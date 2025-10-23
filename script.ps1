$formUrl = 'https://docs.google.com/forms/d/e/1FAIpQLSdbLrFd5CewiPxTKe0H3Xm-7ATz9B5BwGQ_JzCLbxnZpC5flg/formResponse'
$runIdField = 'entry.1376862401'
$timestampField = 'entry.568660776'

$uidFile = "$env:APPDATA\MyScript\unique_id.txt"
if (-not (Test-Path (Split-Path $uidFile))) { New-Item -ItemType Directory -Path (Split-Path $uidFile) -Force | Out-Null }

if (Test-Path $uidFile) {
    $uniqueId = Get-Content $uidFile -Raw
    Write-Host "ID уже существует: $uniqueId. Данные уже отправлены ранее."
} else {
    $uniqueId = [guid]::NewGuid().ToString()
    Set-Content -Path $uidFile -Value $uniqueId
    $timestamp = (Get-Date).ToString("o")

    $formFields = @{
        $runIdField = $uniqueId
        $timestampField = $timestamp
    }

    try {
        $response = Invoke-WebRequest -Uri $formUrl -Method Post -Body $formFields -ContentType 'application/x-www-form-urlencoded'
        Write-Host "Данные успешно отправлены."
    } catch {
        Write-Warning "Ошибка при отправке данных: $_"
    }
}

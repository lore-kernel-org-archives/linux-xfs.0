Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51463 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754519AbeBNH53 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 02:57:29 -0500
Received: by mail-wm0-f67.google.com with SMTP id r71so20799991wmd.1
        for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2018 23:57:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <965fcbcd-bfe3-8cdd-6657-ca20bef24c51@sandeen.net>
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
 <151787298265.3743.11278867933485186707.stgit@magnolia> <965fcbcd-bfe3-8cdd-6657-ca20bef24c51@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 14 Feb 2018 08:57:08 +0100
Message-ID: <CACj3i72rRQ12fGCCMGJvemvcS_M4x4-pbAhF-h78cvPwTgV+wQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] xfs_scrub: always init phase information
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 12, 2018 at 9:53 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
> On 2/5/18 5:23 PM, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Make sure we initialize the overall phase state before we start
>> executing any code that can end up in the report-status-and-exit paths.
>> Otherwise if debugging is turned on we get garbage io/cpu stat reports.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Jan Tulak <jtulak@redhat.com>
>
>> ---
>>  scrub/xfs_scrub.c |   10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>>
>> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
>> index 6efcf77..89b7fa0 100644
>> --- a/scrub/xfs_scrub.c
>> +++ b/scrub/xfs_scrub.c
>> @@ -618,6 +618,11 @@ main(
>>       if (getenv("SERVICE_MODE"))
>>               is_service = true;
>>
>> +     /* Initialize overall phase stats. */
>> +     moveon = phase_start(&all_pi, 0, NULL);
>> +     if (!moveon)
>> +             return SCRUB_RET_OPERROR;
>> +
>>       /* Find the mount record for the passed-in argument. */
>>       if (stat(argv[optind], &ctx.mnt_sb) < 0) {
>>               fprintf(stderr,
>> @@ -641,11 +646,6 @@ main(
>>                       mtab = _PATH_MOUNTED;
>>       }
>>
>> -     /* Initialize overall phase stats. */
>> -     moveon = phase_start(&all_pi, 0, NULL);
>> -     if (!moveon)
>> -             goto out;
>> -
>>       ismnt = find_mountpoint(mtab, &ctx);
>>       if (!ismnt) {
>>               fprintf(stderr,
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

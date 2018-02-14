Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51428 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754519AbeBNH5Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 02:57:16 -0500
Received: by mail-wm0-f67.google.com with SMTP id r71so20799084wmd.1
        for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2018 23:57:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b798e93f-4b52-2dd6-d715-580ffde96df7@sandeen.net>
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
 <151787297178.3743.12195489468667039346.stgit@magnolia> <b798e93f-4b52-2dd6-d715-580ffde96df7@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 14 Feb 2018 08:56:55 +0100
Message-ID: <CACj3i73snXq9qgfDpyw6wdivd=WzsM-fduu-DJDyk_bDdo0bdA@mail.gmail.com>
Subject: Re: [PATCH 5/7] xfs_scrub: reclassify some of the warning messages
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 12, 2018 at 9:53 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
> On 2/5/18 5:22 PM, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Some of the warning messages are actually runtime errors in optional
>> components, so turn them into informational messages.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Jan Tulak <jtulak@redhat.com>
>
>> ---
>>  scrub/inodes.c |    6 +++---
>>  scrub/phase6.c |    4 ++--
>>  2 files changed, 5 insertions(+), 5 deletions(-)
>>
>>
>> diff --git a/scrub/inodes.c b/scrub/inodes.c
>> index 57b773e..744b003 100644
>> --- a/scrub/inodes.c
>> +++ b/scrub/inodes.c
>> @@ -157,7 +157,7 @@ xfs_iterate_inodes_range(
>>               bulkreq.icount = inogrp.xi_alloccount;
>>               error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT, &bulkreq);
>>               if (error)
>> -                     str_warn(ctx, descr, "%s", strerror_r(errno,
>> +                     str_info(ctx, descr, "%s", strerror_r(errno,
>>                                               buf, DESCR_BUFSZ));
>>
>>               xfs_iterate_inodes_range_check(ctx, &inogrp, bstat);
>> @@ -181,8 +181,8 @@ xfs_iterate_inodes_range(
>>                               }
>>                               snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
>>                                               (uint64_t)bs->bs_ino);
>> -                             str_warn(ctx, idescr, "%s", strerror_r(error,
>> -                                             buf, DESCR_BUFSZ));
>> +                             str_info(ctx, idescr,
>> +_("Changed too many times during scan; giving up."));
>>                               break;
>>                       case XFS_ITERATE_INODES_ABORT:
>>                               error = 0;
>> diff --git a/scrub/phase6.c b/scrub/phase6.c
>> index f985950..e255eef 100644
>> --- a/scrub/phase6.c
>> +++ b/scrub/phase6.c
>> @@ -188,7 +188,6 @@ xfs_report_verify_inode(
>>       void                            *arg)
>>  {
>>       char                            descr[DESCR_BUFSZ];
>> -     char                            buf[DESCR_BUFSZ];
>>       bool                            moveon;
>>       int                             fd;
>>       int                             error;
>> @@ -209,7 +208,8 @@ xfs_report_verify_inode(
>>               if (error == ESTALE)
>>                       return error;
>>
>> -             str_warn(ctx, descr, "%s", strerror_r(error, buf, DESCR_BUFSZ));
>> +             str_info(ctx, descr,
>> +_("Disappeared during read error reporting."));
>>               return error;
>>       }
>>
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

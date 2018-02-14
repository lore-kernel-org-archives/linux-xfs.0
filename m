Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36285 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754530AbeBNH7k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 02:59:40 -0500
Received: by mail-wr0-f194.google.com with SMTP id y3so21157861wrh.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2018 23:59:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5279e63a-6ea9-517b-f73f-2b52d0a2f7ea@sandeen.net>
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
 <151787298870.3743.17315196925370109109.stgit@magnolia> <5279e63a-6ea9-517b-f73f-2b52d0a2f7ea@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 14 Feb 2018 08:59:19 +0100
Message-ID: <CACj3i73hozkgQXCL41wb=wM=y_qvR=Q_8FL_S-9onETrazzOgA@mail.gmail.com>
Subject: Re: [PATCH 7/7] xfs_scrub: refactor outcome display into a separate helper
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 12, 2018 at 10:06 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 2/5/18 5:23 PM, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Move all the printing of the scrub outcome into a separate helper to
>> declutter the main function.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>
>
> This might get a bit long, no?
>
> "/path/to/filesystem: errors found 16384; warnings found 16.  Unmount and run xfs_repair."
>
> Can we put the "Unmount and run xfs_repair" on its own line?
> That'd make it stand out more, as well.  </nitpick>

I agree, but that's really just a detail.

Reviewed-by: Jan Tulak <jtulak@redhat.com>

>
>
>> ---
>>  scrub/xfs_scrub.c |   48 ++++++++++++++++++++++++++++++------------------
>>  1 file changed, 30 insertions(+), 18 deletions(-)
>>
>>
>> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
>> index 89b7fa0..fdd35df 100644
>> --- a/scrub/xfs_scrub.c
>> +++ b/scrub/xfs_scrub.c
>> @@ -493,6 +493,34 @@ _("Scrub aborted after phase %d."),
>>       return moveon;
>>  }
>>
>> +static void
>> +report_outcome(
>> +     struct scrub_ctx        *ctx)
>> +{
>> +     unsigned long long      total_errors;
>> +
>> +     total_errors = ctx->errors_found + ctx->runtime_errors;
>> +
>> +     if (total_errors == 0 && ctx->warnings_found == 0)
>> +             return;
>> +
>> +     if (total_errors == 0)
>> +             fprintf(stderr, _("%s: warnings found: %llu."), ctx->mntpoint,
>> +                             ctx->warnings_found);
>> +     else if (ctx->warnings_found == 0)
>> +             fprintf(stderr, _("%s: errors found: %llu."), ctx->mntpoint,
>> +                             total_errors);
>> +     else
>> +             fprintf(stderr, _("%s: errors found: %llu; warnings found: %llu."),
>> +                             ctx->mntpoint, total_errors,
>> +                             ctx->warnings_found);
>> +
>> +     if (ctx->need_repair)
>> +             fprintf(stderr, "  %s\n", _("Unmount and run xfs_repair."));
>> +     else
>> +             fprintf(stderr, "\n");
>> +}
>> +
>>  int
>>  main(
>>       int                     argc,
>> @@ -501,9 +529,7 @@ main(
>>       struct scrub_ctx        ctx = {0};
>>       struct phase_rusage     all_pi;
>>       char                    *mtab = NULL;
>> -     char                    *repairstr = "";
>>       FILE                    *progress_fp = NULL;
>> -     unsigned long long      total_errors;
>>       bool                    moveon = true;
>>       bool                    ismnt;
>>       int                     c;
>> @@ -692,22 +718,8 @@ _("%s: Not a XFS mount point or block device.\n"),
>>               ctx.runtime_errors++;
>>
>>  out:
>> -     total_errors = ctx.errors_found + ctx.runtime_errors;
>> -     if (ctx.need_repair)
>> -             repairstr = _("  Unmount and run xfs_repair.");
>> -     if (total_errors && ctx.warnings_found)
>> -             fprintf(stderr,
>> -_("%s: %llu errors and %llu warnings found.%s\n"),
>> -                     ctx.mntpoint, total_errors, ctx.warnings_found,
>> -                     repairstr);
>> -     else if (total_errors && ctx.warnings_found == 0)
>> -             fprintf(stderr,
>> -_("%s: %llu errors found.%s\n"),
>> -                     ctx.mntpoint, total_errors, repairstr);
>> -     else if (total_errors == 0 && ctx.warnings_found)
>> -             fprintf(stderr,
>> -_("%s: %llu warnings found.\n"),
>> -                     ctx.mntpoint, ctx.warnings_found);
>> +     report_outcome(&ctx);
>> +
>>       if (ctx.errors_found) {
>>               if (ctx.error_action == ERRORS_SHUTDOWN)
>>                       xfs_shutdown_fs(&ctx);
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

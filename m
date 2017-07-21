Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:34734 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753938AbdGUI4t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 04:56:49 -0400
Received: by mail-wr0-f171.google.com with SMTP id 12so79872906wrb.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 01:56:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170720155404.GS4224@magnolia>
References: <20170720092932.32580-1-jtulak@redhat.com> <20170720092932.32580-4-jtulak@redhat.com>
 <20170720155404.GS4224@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 21 Jul 2017 10:56:27 +0200
Message-ID: <CACj3i71m7q2tLFuY82P7Ykrubt54PXs-_JVjYmEDkrKuhqf=MQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] mkfs: remove intermediate getstr followed by getnum
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jul 20, 2017 at 5:54 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, Jul 20, 2017 at 11:29:28AM +0200, Jan Tulak wrote:
>> Some options loaded a number as a string with getstr and converted it to
>> number with getnum later in the code, without any reason for this
>> approach.  (They were probably forgotten in some past cleaning.)
>>
>> This patch changes them to skip the string and use getnum directly in
>> the main option-parsing loop, as do all the other numerical options.
>> And as we now have two variables of the same type for the same value,
>> merge them together. (e.g. former string dsize and number dbytes).
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>> Reviewed-by: Luis R. Rodriguez <mcgrof@kernel.org>
>>
>> ---
>> In reply to Eric's comment, so it doesn't pop up again:
>> This patch has to be applied after "mkfs: Save raw user input ...",
>> because otherwise we would temporary lose the access to strings
>> with user-given values and thus wouldn't be able to report them in
>> case of any issue.
>> ---
>>  mkfs/xfs_mkfs.c | 90 ++++++++++++++++++++++++++-------------------------------
>>  1 file changed, 41 insertions(+), 49 deletions(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index f2f6468e..127f14c3 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -1345,6 +1345,7 @@ getnum(
>>       long long               c;
>>
>>       check_opt(opts, index, false);
>> +     set_conf_raw(opts, index, str);
>>       /* empty strings might just return a default value */
>>       if (!str || *str == '\0') {
>>               if (sp->flagval == SUBOPT_NEEDS_VAL)
>> @@ -1432,12 +1433,12 @@ main(
>>       char                    *dfile;
>>       int                     dirblocklog;
>>       int                     dirblocksize;
>> -     char                    *dsize;
>> +     int                     dbytes;
>>       int                     dsu;
>>       int                     dsw;
>>       int                     dsunit;
>>       int                     dswidth;
>> -     int                     force_overwrite;
>> +     bool                    force_overwrite;
>>       struct fsxattr          fsx;
>>       int                     ilflag;
>>       int                     imaxpct;
>> @@ -1456,7 +1457,7 @@ main(
>>       xfs_rfsblock_t          logblocks;
>>       char                    *logfile;
>>       int                     loginternal;
>> -     char                    *logsize;
>> +     int                     logbytes;
>>       xfs_fsblock_t           logstart;
>>       int                     lvflag;
>>       int                     lsflag;
>> @@ -1485,11 +1486,11 @@ main(
>>       char                    *protostring;
>>       int                     qflag;
>>       xfs_rfsblock_t          rtblocks;
>> +     int             rtbytes;
>>       xfs_extlen_t            rtextblocks;
>>       xfs_rtblock_t           rtextents;
>> -     char                    *rtextsize;
>> +     int             rtextbytes;
>>       char                    *rtfile;
>> -     char                    *rtsize;
>>       xfs_sb_t                *sbp;
>>       int                     sectorlog;
>>       __uint64_t              sector_mask;
>> @@ -1537,7 +1538,8 @@ main(
>>       qflag = 0;
>>       imaxpct = inodelog = inopblock = isize = 0;
>>       dfile = logfile = rtfile = NULL;
>> -     dsize = logsize = rtsize = rtextsize = protofile = NULL;
>> +     protofile = NULL;
>> +     rtbytes = rtextbytes = logbytes = dbytes = 0;
>>       dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
>>       nodsflag = norsflag = 0;
>>       force_overwrite = 0;
>> @@ -1601,7 +1603,7 @@ main(
>>                                       xi.dname = getstr(value, &dopts, D_NAME);
>>                                       break;
>>                               case D_SIZE:
>> -                                     dsize = getstr(value, &dopts, D_SIZE);
>> +                                     dbytes = getnum(value, &dopts, D_SIZE);
>>                                       break;
>>                               case D_SUNIT:
>>                                       dsunit = getnum(value, &dopts, D_SUNIT);
>> @@ -1746,7 +1748,7 @@ main(
>>                                       lvflag = 1;
>>                                       break;
>>                               case L_SIZE:
>> -                                     logsize = getstr(value, &lopts, L_SIZE);
>> +                                     logbytes = getnum(value, &lopts, L_SIZE);
>>                                       break;
>>                               case L_SECTLOG:
>>                                       lsectorlog = getnum(value, &lopts,
>> @@ -1875,8 +1877,7 @@ main(
>>
>>                               switch (getsubopt(&p, subopts, &value)) {
>>                               case R_EXTSIZE:
>> -                                     rtextsize = getstr(value, &ropts,
>> -                                                        R_EXTSIZE);
>> +                                     rtextbytes = getnum(value, &ropts, R_EXTSIZE);
>>                                       break;
>>                               case R_FILE:
>>                                       xi.risfile = getnum(value, &ropts,
>> @@ -1888,7 +1889,7 @@ main(
>>                                                          R_NAME);
>>                                       break;
>>                               case R_SIZE:
>> -                                     rtsize = getstr(value, &ropts, R_SIZE);
>> +                                     rtbytes = getnum(value, &ropts, R_SIZE);
>>                                       break;
>>                               case R_NOALIGN:
>>                                       norsflag = getnum(value, &ropts,
>> @@ -1991,14 +1992,14 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
>>        * sector size mismatches between the new filesystem and the underlying
>>        * host filesystem.
>>        */
>> -     check_device_type(dfile, &xi.disfile, !dsize, !dfile,
>> +     check_device_type(dfile, &xi.disfile, !dbytes, !dfile,
>>                         Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
>>       if (!loginternal)
>> -             check_device_type(xi.logname, &xi.lisfile, !logsize, !xi.logname,
>> -                               Nflag ? NULL : &xi.lcreat,
>> +             check_device_type(xi.logname, &xi.lisfile, !logbytes,
>> +                               !xi.logname, Nflag ? NULL : &xi.lcreat,
>>                                 force_overwrite, "l");
>>       if (xi.rtname)
>> -             check_device_type(xi.rtname, &xi.risfile, !rtsize, !xi.rtname,
>> +             check_device_type(xi.rtname, &xi.risfile, !rtbytes, !xi.rtname,
>>                                 Nflag ? NULL : &xi.rcreat,
>>                                 force_overwrite, "r");
>>       if (xi.disfile || xi.lisfile || xi.risfile)
>> @@ -2179,10 +2180,7 @@ _("rmapbt not supported with realtime devices\n"));
>>       }
>>
>>
>> -     if (dsize) {
>> -             __uint64_t dbytes;
>> -
>> -             dbytes = getnum(dsize, &dopts, D_SIZE);
>> +     if (dbytes) {
>
> Why has dbytes been demoted from uint64_t to int?  This eliminates the
> ability to -d size=8G, right?
>

Ah, thanks for spotting it, I will check the other variables as well.

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me

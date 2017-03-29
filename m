Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:32953 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbdC2O6Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2017 10:58:24 -0400
Received: by mail-vk0-f49.google.com with SMTP id d188so20647388vka.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 Mar 2017 07:58:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <89179241-774e-39d9-9e9d-16828ffbd67b@sandeen.net>
References: <20170315160017.27805-1-jtulak@redhat.com> <20170315160017.27805-9-jtulak@redhat.com>
 <89179241-774e-39d9-9e9d-16828ffbd67b@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 29 Mar 2017 16:57:42 +0200
Message-ID: <CACj3i72e7LqZV7oNkBgnjVKMr1g2zyOk1enRpnWUnKgbd94Y5A@mail.gmail.com>
Subject: Re: [PATCH 08/22] mkfs: move conflicts into the table
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Sat, Mar 25, 2017 at 12:53 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 3/15/17 11:00 AM, Jan Tulak wrote:
>> Fill the table with conflicts data and remove now-duplicate code for their
>> detection from other parts of mkfs.
>
> One other thing that I've noticed is that if you do:
>
> # mkfs.xfs -i align=0 /dev/foo
>
> that passes now, and it shouldn't.  Prior to this patch, it said:
>
> Inodes always aligned for CRC enabled filesytems
>
> The above testcase actually alternates between pass & fail over
> the next several patches.  If you have testcases for these conflicts,
> please try to make sure that they don't regress throughout the
> series.

I'll fix it.

Thanks,
Jan

>
> -Eric
>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> ---
>>  mkfs/xfs_mkfs.c | 152 ++++++++++++++++++++++++++------------------------------
>>  1 file changed, 70 insertions(+), 82 deletions(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 4ba6df05..c100fef9 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -45,7 +45,7 @@ unsigned int                sectorsize;
>>  #define MAX_OPTS     16
>>  #define MAX_SUBOPTS  16
>>  #define SUBOPT_NEEDS_VAL     (-1LL)
>> -#define MAX_CONFLICTS        8
>> +#define MAX_CONFLICTS        32
>>  #define LAST_CONFLICT        (-1)
>>
>>  #define OPT_B                0
>> @@ -409,7 +409,9 @@ struct opt_params {
>>               },
>>               .subopt_params = {
>>                       { .index = I_ALIGN,
>> -                       .conflicts = { {LAST_CONFLICT} },
>> +                       .conflicts = { {OPT_M, M_CRC, true, 1, 0,
>> +             "Inodes always aligned for CRC enabled filesytems."},
>> +                                      {LAST_CONFLICT} },
>>                         .minval = 0,
>>                         .maxval = 1,
>>                         .defaultval = 1,
>> @@ -447,19 +449,26 @@ struct opt_params {
>>                         .defaultval = SUBOPT_NEEDS_VAL,
>>                       },
>>                       { .index = I_ATTR,
>> -                       .conflicts = { {LAST_CONFLICT} },
>> +                       .conflicts = { {OPT_M, M_CRC, true, 1, 1,
>> +             "V2 attribute format always enabled on CRC enabled filesytems."},
>> +                                      {LAST_CONFLICT} },
>>                         .minval = 0,
>>                         .maxval = 2,
>>                         .defaultval = SUBOPT_NEEDS_VAL,
>>                       },
>>                       { .index = I_PROJID32BIT,
>> -                       .conflicts = { {LAST_CONFLICT} },
>> +                       .conflicts = { {OPT_M, M_CRC, true, 1, 0,
>> +             "32 bit Project IDs always enabled on CRC enabled filesytems."},
>> +                                      {LAST_CONFLICT} },
>> +
>>                         .minval = 0,
>>                         .maxval = 1,
>>                         .defaultval = 1,
>>                       },
>>                       { .index = I_SPINODES,
>> -                       .conflicts = { {LAST_CONFLICT} },
>> +                       .conflicts = { {OPT_M, M_CRC, true, 0, 1,
>> +             "Sparse inodes not supported without CRC support."},
>> +                                      {LAST_CONFLICT} },
>>                         .minval = 0,
>>                         .maxval = 1,
>>                         .defaultval = 1,
>> @@ -508,7 +517,9 @@ struct opt_params {
>>                         .defaultval = SUBOPT_NEEDS_VAL,
>>                       },
>>                       { .index = L_VERSION,
>> -                       .conflicts = { {LAST_CONFLICT} },
>> +                       .conflicts = { {OPT_M, M_CRC, true, 1, 1,
>> +                             "V2 logs are required for CRC enabled filesystems."},
>> +                                      {LAST_CONFLICT} },
>>                         .minval = 1,
>>                         .maxval = 2,
>>                         .defaultval = SUBOPT_NEEDS_VAL,
>> @@ -564,7 +575,9 @@ struct opt_params {
>>                         .defaultval = SUBOPT_NEEDS_VAL,
>>                       },
>>                       { .index = L_LAZYSBCNTR,
>> -                       .conflicts = { {LAST_CONFLICT} },
>> +                       .conflicts = { {OPT_M, M_CRC, true, 1, 0,
>> +             "Lazy superblock counted always enabled for CRC enabled filesytems."},
>> +                                      {LAST_CONFLICT} },
>>                         .minval = 0,
>>                         .maxval = 1,
>>                         .defaultval = 1,
>> @@ -605,7 +618,9 @@ struct opt_params {
>>                         .defaultval = SUBOPT_NEEDS_VAL,
>>                       },
>>                       { .index = N_FTYPE,
>> -                       .conflicts = { {LAST_CONFLICT} },
>> +                       .conflicts = {  {OPT_M, M_CRC, true, 1, 0,
>> +             "Cannot disable ftype with crcs enabled."},
>> +                                       {LAST_CONFLICT} },
>>                         .minval = 0,
>>                         .maxval = 1,
>>                         .defaultval = 1,
>> @@ -640,7 +655,9 @@ struct opt_params {
>>                         .defaultval = SUBOPT_NEEDS_VAL,
>>                       },
>>                       { .index = R_DEV,
>> -                       .conflicts = { {LAST_CONFLICT} },
>> +                       .conflicts = { {OPT_M, M_RMAPBT, false, 0, 0,
>> +             "rmapbt not supported without CRC support."},
>> +                                      {LAST_CONFLICT} },
>>                         .defaultval = SUBOPT_NEEDS_VAL,
>>                       },
>>                       { .index = R_FILE,
>> @@ -650,7 +667,9 @@ struct opt_params {
>>                         .conflicts = { {LAST_CONFLICT} },
>>                       },
>>                       { .index = R_NAME,
>> -                       .conflicts = { {LAST_CONFLICT} },
>> +                       .conflicts = { {OPT_M, M_RMAPBT, false, 0, 0,
>> +             "rmapbt not supported without CRC support."},
>> +                                      {LAST_CONFLICT} },
>>                         .defaultval = SUBOPT_NEEDS_VAL,
>>                       },
>>                       { .index = R_NOALIGN,
>> @@ -723,13 +742,35 @@ struct opt_params {
>>               },
>>               .subopt_params = {
>>                       { .index = M_CRC,
>> -                       .conflicts = { {LAST_CONFLICT} },
>> +                       .conflicts = { {OPT_L, L_VERSION, true, 1, 1,
>> +             "V2 logs are required for CRC enabled filesystems."},
>> +                                      {OPT_I, I_ALIGN, true, 0, 1,
>> +             "Inodes always aligned for CRC enabled filesytems."},
>> +                                      {OPT_I, I_PROJID32BIT, true, 0, 1,
>> +             "32 bit Project IDs always enabled on CRC enabled filesytems."},
>> +                                      {OPT_I, I_ATTR, true, 1, 1,
>> +             "V2 attribute format always enabled on CRC enabled filesytems."},
>> +                                      {OPT_L, L_LAZYSBCNTR, true, 0, 1,
>> +             "Lazy superblock counted always enabled for CRC enabled filesytems."},
>> +                                      {OPT_M, M_FINOBT, true, 1, 0,
>> +             "Finobt not supported without CRC support."},
>> +                                      {OPT_M, M_RMAPBT, true, 1, 0,
>> +             "rmapbt not supported without CRC support."},
>> +                                      {OPT_M, M_REFLINK, true, 1, 0,
>> +             "reflink not supported without CRC support."},
>> +                                      {OPT_I, I_SPINODES, true, 1, 0,
>> +             "Sparse inodes not supported without CRC support."},
>> +                                      {OPT_N, N_FTYPE, true, 0, 1,
>> +             "Cannot disable ftype with crcs enabled."},
>> +                                      {LAST_CONFLICT} },
>>                         .minval = 0,
>>                         .maxval = 1,
>>                         .defaultval = 1,
>>                       },
>>                       { .index = M_FINOBT,
>> -                       .conflicts = { {LAST_CONFLICT} },
>> +                       .conflicts = { {OPT_M, M_CRC, true, 0, 1,
>> +             "Finobt not supported without CRC support\n"},
>> +                                      {LAST_CONFLICT} },
>>                         .minval = 0,
>>                         .maxval = 1,
>>                         .defaultval = 1,
>> @@ -739,13 +780,21 @@ struct opt_params {
>>                         .defaultval = SUBOPT_NEEDS_VAL,
>>                       },
>>                       { .index = M_RMAPBT,
>> -                     .conflicts = { {LAST_CONFLICT} },
>> +                     .conflicts = { {OPT_M, M_CRC, true, 0, 1,
>> +             "rmapbt not supported without CRC support."},
>> +                                     {OPT_R, R_NAME, false, 0, 0,
>> +             "rmapbt not supported with realtime devices."},
>> +                                     {OPT_R, R_DEV, false, 0, 0,
>> +             "rmapbt not supported with realtime devices."},
>> +                                    {LAST_CONFLICT} },
>>                       .minval = 0,
>>                       .maxval = 1,
>>                       .defaultval = 0,
>>                       },
>>                       { .index = M_REFLINK,
>> -                       .conflicts = { {LAST_CONFLICT} },
>> +                       .conflicts = { {OPT_M, M_CRC, true, 0, 1,
>> +             "reflink not supported without CRC support."},
>> +                                      {LAST_CONFLICT} },
>>                         .minval = 0,
>>                         .maxval = 1,
>>                         .defaultval = 0,
>> @@ -2183,11 +2232,16 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
>>                       XFS_MIN_CRC_BLOCKSIZE);
>>               usage();
>>       }
>> +
>> +     /*
>> +      * If user explicitly stated -m crc=1 -n ftype=0, an error was already
>> +      * issued. But if -n ftype=0 was stated alone, then it is a conflict
>> +      * with a default value for crc enabled and has to be detected here.
>> +      */
>>       if (sb_feat.crcs_enabled && !sb_feat.dirftype) {
>>               fprintf(stderr, _("cannot disable ftype with crcs enabled\n"));
>>               usage();
>>       }
>> -
>>       if (!slflag && !ssflag) {
>>               sectorlog = XFS_MIN_SECTORSIZE_LOG;
>>               sectorsize = XFS_MIN_SECTORSIZE;
>> @@ -2293,42 +2347,6 @@ _("Minimum inode size for CRCs is %d bytes\n"),
>>                               1 << XFS_DINODE_DFL_CRC_LOG);
>>                       usage();
>>               }
>> -
>> -             /* inodes always aligned */
>> -             if (!sb_feat.inode_align) {
>> -                     fprintf(stderr,
>> -_("Inodes always aligned for CRC enabled filesytems\n"));
>> -                     usage();
>> -             }
>> -
>> -             /* lazy sb counters always on */
>> -             if (!sb_feat.lazy_sb_counters) {
>> -                     fprintf(stderr,
>> -_("Lazy superblock counted always enabled for CRC enabled filesytems\n"));
>> -                     usage();
>> -             }
>> -
>> -             /* version 2 logs always on */
>> -             if (sb_feat.log_version != 2) {
>> -                     fprintf(stderr,
>> -_("V2 logs always enabled for CRC enabled filesytems\n"));
>> -                     usage();
>> -             }
>> -
>> -             /* attr2 always on */
>> -             if (sb_feat.attr_version != 2) {
>> -                     fprintf(stderr,
>> -_("V2 attribute format always enabled on CRC enabled filesytems\n"));
>> -                     usage();
>> -             }
>> -
>> -             /* 32 bit project quota always on */
>> -             /* attr2 always on */
>> -             if (sb_feat.projid16bit) {
>> -                     fprintf(stderr,
>> -_("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
>> -                     usage();
>> -             }
>>       } else {
>>               /*
>>                * The kernel doesn't currently support crc=0,finobt=1
>> @@ -2336,46 +2354,16 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
>>                * explicitly turned finobt on, then silently turn it off to
>>                * avoid an unnecessary warning.
>>                * If the user explicitly tried to use crc=0,finobt=1,
>> -              * then issue an error.
>> +              * the error was already issued during args parsing.
>>                * The same is also for sparse inodes.
>>                */
>> -             if (sb_feat.finobt && opts[OPT_M].subopt_params[M_FINOBT].seen) {
>> -                     fprintf(stderr,
>> -_("finobt not supported without CRC support\n"));
>> -                     usage();
>> -             }
>>               sb_feat.finobt = 0;
>> -
>> -             if (sb_feat.spinodes) {
>> -                     fprintf(stderr,
>> -_("sparse inodes not supported without CRC support\n"));
>> -                     usage();
>> -             }
>>               sb_feat.spinodes = 0;
>>
>> -             if (sb_feat.rmapbt) {
>> -                     fprintf(stderr,
>> -_("rmapbt not supported without CRC support\n"));
>> -                     usage();
>> -             }
>>               sb_feat.rmapbt = false;
>> -
>> -             if (sb_feat.reflink) {
>> -                     fprintf(stderr,
>> -_("reflink not supported without CRC support\n"));
>> -                     usage();
>> -             }
>>               sb_feat.reflink = false;
>>       }
>>
>> -
>> -     if (sb_feat.rmapbt && xi.rtname) {
>> -             fprintf(stderr,
>> -_("rmapbt not supported with realtime devices\n"));
>> -             usage();
>> -             sb_feat.rmapbt = false;
>> -     }
>> -
>>       if (nsflag || nlflag) {
>>               if (dirblocksize < blocksize ||
>>                                       dirblocksize > XFS_MAX_BLOCKSIZE) {
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me

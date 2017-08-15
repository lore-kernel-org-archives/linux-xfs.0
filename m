Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36190 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753562AbdHOKGB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 06:06:01 -0400
Received: by mail-wm0-f41.google.com with SMTP id t201so5580378wmt.1
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 03:06:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170814230606.GH4796@magnolia>
References: <20170811123037.15962-1-jtulak@redhat.com> <20170811123037.15962-5-jtulak@redhat.com>
 <20170814230606.GH4796@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 15 Aug 2017 12:05:38 +0200
Message-ID: <CACj3i73+RRYy5LGZ_PqSX_-yPE5SM=TCgy99Jf=BX=FJM7v3wA@mail.gmail.com>
Subject: Re: [PATCH 4/6] mkfs: merge tables for opts parsing into one table
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Aug 15, 2017 at 1:06 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, Aug 11, 2017 at 02:30:35PM +0200, Jan Tulak wrote:
>> Merge separate instances of opt_params into one indexable table. Git
>> makes this patch looks a bit more complicated, but it does not change
>> values or structure of anything else. It only moves all the "struct
>> opt_params dopts = {...}", changes indentation for these substructures
>> and replaces their usage (dopts -> opts[OPT_D]).
>>
>> The reason for this is to be able to address all options from any single
>> one, even across OPT_X. Right now, we can do automated conflict checks
>> only within one OPT_X, but after this, it is possible to extend the
>> conflict declaration to other options as well.
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> ---
>> Change:
>>  * expand bounds check to newly added opt parameter in get/set functions
>>  * updated description
>> ---
>>  mkfs/xfs_mkfs.c | 1341 +++++++++++++++++++++++++++++--------------------------
>>  1 file changed, 696 insertions(+), 645 deletions(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 78e27498..e3f7d345 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -39,6 +39,7 @@ static int  ispow2(unsigned int i);
>>  unsigned int         blocksize;
>>  unsigned int         sectorsize;
>>
>> +#define MAX_OPTS     16
>>  #define MAX_SUBOPTS  16
>>  #define SUBOPT_NEEDS_VAL     (-1LL)
>>  #define MAX_CONFLICTS        8
>> @@ -49,6 +50,10 @@ unsigned int               sectorsize;
>>   *
>>   * Description of the structure members follows:
>>   *
>> + * index MANDATORY
>> + *   An integer denoting the position of the specific option in opts array,
>> + *   counting from 0 up to MAX_OPTS.
>> + *
>>   * name MANDATORY
>>   *   Name is a single char, e.g., for '-d file', name is 'd'.
>>   *
>> @@ -114,6 +119,7 @@ unsigned int              sectorsize;
>>   *
>>   */
>>  struct opt_params {
>> +     int             index;
>>       const char      name;
>>       const char      *subopts[MAX_SUBOPTS];
>>
>> @@ -129,584 +135,592 @@ struct opt_params {
>>               long long       flagval;
>>               char            *raw_input;
>>       }               subopt_params[MAX_SUBOPTS];
>> -};
>> -
>> -struct opt_params bopts = {
>> -     .name = 'b',
>> -     .subopts = {
>> +} opts[MAX_OPTS] = {
>> +#define OPT_B        0
>> +     {
>> +             .index = OPT_B,
>> +             .name = 'b',
>> +             .subopts = {
>>  #define      B_LOG           0
>> -             "log",
>> +                     "log",
>>  #define      B_SIZE          1
>> -             "size",
>> -             NULL
>> -     },
>> -     .subopt_params = {
>> -             { .index = B_LOG,
>
> I /really/ wish there was a way calculate these automatically, but I
> don't think I know of any such way, at least not without using horrid
> macros.

Yes. :( Some enum magic could help a little bit with type checking,
but it still can't assign correct numbers everywhere on its own.

>
>> -               .conflicts = { B_SIZE,
>> -                              LAST_CONFLICT },
>> -               .minval = XFS_MIN_BLOCKSIZE_LOG,
>> -               .maxval = XFS_MAX_BLOCKSIZE_LOG,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> +                     "size",
>> +                     NULL
>>               },
>> -             { .index = B_SIZE,
>> -               .convert = true,
>> -               .is_power_2 = true,
>> -               .conflicts = { B_LOG,
>> -                              LAST_CONFLICT },
>> -               .minval = XFS_MIN_BLOCKSIZE,
>> -               .maxval = XFS_MAX_BLOCKSIZE,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> +             .subopt_params = {
>> +                     { .index = B_LOG,
>> +                       .conflicts = { B_SIZE,
>> +                                      LAST_CONFLICT },
>> +                       .minval = XFS_MIN_BLOCKSIZE_LOG,
>> +                       .maxval = XFS_MAX_BLOCKSIZE_LOG,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = B_SIZE,
>> +                       .convert = true,
>> +                       .is_power_2 = true,
>> +                       .conflicts = { B_LOG,
>> +                                      LAST_CONFLICT },
>> +                       .minval = XFS_MIN_BLOCKSIZE,
>> +                       .maxval = XFS_MAX_BLOCKSIZE,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>>               },
>>       },
>> -};
>> -
>> -struct opt_params dopts = {
>> -     .name = 'd',
>> -     .subopts = {
>> -#define      D_AGCOUNT       0
>> -             "agcount",
>> -#define      D_FILE          1
>> -             "file",
>> -#define      D_NAME          2
>> -             "name",
>> -#define      D_SIZE          3
>> -             "size",
>> -#define D_SUNIT              4
>> -             "sunit",
>> -#define D_SWIDTH     5
>> -             "swidth",
>> -#define D_AGSIZE     6
>> -             "agsize",
>> -#define D_SU         7
>> -             "su",
>> -#define D_SW         8
>> -             "sw",
>> -#define D_SECTLOG    9
>> -             "sectlog",
>> -#define D_SECTSIZE   10
>> -             "sectsize",
>> -#define D_NOALIGN    11
>> -             "noalign",
>> -#define D_RTINHERIT  12
>> -             "rtinherit",
>> -#define D_PROJINHERIT        13
>> -             "projinherit",
>> -#define D_EXTSZINHERIT       14
>> -             "extszinherit",
>> -             NULL
>> -     },
>> -     .subopt_params = {
>> -             { .index = D_AGCOUNT,
>> -               .conflicts = { D_AGSIZE,
>> -                              LAST_CONFLICT },
>> -               .minval = 1,
>> -               .maxval = XFS_MAX_AGNUMBER,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = D_FILE,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> -             },
>> -             { .index = D_NAME,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = D_SIZE,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .convert = true,
>> -               .minval = XFS_AG_MIN_BYTES,
>> -               .maxval = LLONG_MAX,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = D_SUNIT,
>> -               .conflicts = { D_NOALIGN,
>> -                              D_SU,
>> -                              D_SW,
>> -                              LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = UINT_MAX,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = D_SWIDTH,
>> -               .conflicts = { D_NOALIGN,
>> -                              D_SU,
>> -                              D_SW,
>> -                              LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = UINT_MAX,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = D_AGSIZE,
>> -               .conflicts = { D_AGCOUNT,
>> -                              LAST_CONFLICT },
>> -               .convert = true,
>> -               .minval = XFS_AG_MIN_BYTES,
>> -               .maxval = XFS_AG_MAX_BYTES,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = D_SU,
>> -               .conflicts = { D_NOALIGN,
>> -                              D_SUNIT,
>> -                              D_SWIDTH,
>> -                              LAST_CONFLICT },
>> -               .convert = true,
>> -               .minval = 0,
>> -               .maxval = UINT_MAX,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = D_SW,
>> -               .conflicts = { D_NOALIGN,
>> -                              D_SUNIT,
>> -                              D_SWIDTH,
>> -                              LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = UINT_MAX,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = D_SECTLOG,
>> -               .conflicts = { D_SECTSIZE,
>> -                              LAST_CONFLICT },
>> -               .minval = XFS_MIN_SECTORSIZE_LOG,
>> -               .maxval = XFS_MAX_SECTORSIZE_LOG,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = D_SECTSIZE,
>> -               .conflicts = { D_SECTLOG,
>> -                              LAST_CONFLICT },
>> -               .convert = true,
>> -               .is_power_2 = true,
>> -               .minval = XFS_MIN_SECTORSIZE,
>> -               .maxval = XFS_MAX_SECTORSIZE,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> +#define OPT_D        1
>> +     {
>> +             .index = OPT_D,
>> +             .name = 'd',
>> +             .subopts = {
>> +     #define D_AGCOUNT       0
>> +                     "agcount",
>> +     #define D_FILE          1
>> +                     "file",
>> +     #define D_NAME          2
>> +                     "name",
>> +     #define D_SIZE          3
>> +                     "size",
>> +     #define D_SUNIT         4
>> +                     "sunit",
>> +     #define D_SWIDTH        5
>> +                     "swidth",
>> +     #define D_AGSIZE        6
>> +                     "agsize",
>> +     #define D_SU            7
>> +                     "su",
>> +     #define D_SW            8
>> +                     "sw",
>> +     #define D_SECTLOG       9
>> +                     "sectlog",
>> +     #define D_SECTSIZE      10
>> +                     "sectsize",
>> +     #define D_NOALIGN       11
>> +                     "noalign",
>> +     #define D_RTINHERIT     12
>> +                     "rtinherit",
>> +     #define D_PROJINHERIT   13
>> +                     "projinherit",
>> +     #define D_EXTSZINHERIT  14
>> +                     "extszinherit",
>> +                     NULL
>>               },
>> -             { .index = D_NOALIGN,
>> -               .conflicts = { D_SU,
>> -                              D_SW,
>> -                              D_SUNIT,
>> -                              D_SWIDTH,
>> -                              LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> -             },
>> -             { .index = D_RTINHERIT,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 1,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> -             },
>> -             { .index = D_PROJINHERIT,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = UINT_MAX,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = D_EXTSZINHERIT,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = UINT_MAX,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> +             .subopt_params = {
>> +                     { .index = D_AGCOUNT,
>> +                       .conflicts = { D_AGSIZE,
>> +                                      LAST_CONFLICT },
>> +                       .minval = 1,
>> +                       .maxval = XFS_MAX_AGNUMBER,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = D_FILE,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>> +                     { .index = D_NAME,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = D_SIZE,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .convert = true,
>> +                       .minval = XFS_AG_MIN_BYTES,
>> +                       .maxval = LLONG_MAX,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = D_SUNIT,
>> +                       .conflicts = { D_NOALIGN,
>> +                                      D_SU,
>> +                                      D_SW,
>> +                                      LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = UINT_MAX,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = D_SWIDTH,
>> +                       .conflicts = { D_NOALIGN,
>> +                                      D_SU,
>> +                                      D_SW,
>> +                                      LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = UINT_MAX,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = D_AGSIZE,
>> +                       .conflicts = { D_AGCOUNT,
>> +                                      LAST_CONFLICT },
>> +                       .convert = true,
>> +                       .minval = XFS_AG_MIN_BYTES,
>> +                       .maxval = XFS_AG_MAX_BYTES,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = D_SU,
>> +                       .conflicts = { D_NOALIGN,
>> +                                      D_SUNIT,
>> +                                      D_SWIDTH,
>> +                                      LAST_CONFLICT },
>> +                       .convert = true,
>> +                       .minval = 0,
>> +                       .maxval = UINT_MAX,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = D_SW,
>> +                       .conflicts = { D_NOALIGN,
>> +                                      D_SUNIT,
>> +                                      D_SWIDTH,
>> +                                      LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = UINT_MAX,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = D_SECTLOG,
>> +                       .conflicts = { D_SECTSIZE,
>> +                                      LAST_CONFLICT },
>> +                       .minval = XFS_MIN_SECTORSIZE_LOG,
>> +                       .maxval = XFS_MAX_SECTORSIZE_LOG,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = D_SECTSIZE,
>> +                       .conflicts = { D_SECTLOG,
>> +                                      LAST_CONFLICT },
>> +                       .convert = true,
>> +                       .is_power_2 = true,
>> +                       .minval = XFS_MIN_SECTORSIZE,
>> +                       .maxval = XFS_MAX_SECTORSIZE,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = D_NOALIGN,
>> +                       .conflicts = { D_SU,
>> +                                      D_SW,
>> +                                      D_SUNIT,
>> +                                      D_SWIDTH,
>> +                                      LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>> +                     { .index = D_RTINHERIT,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>> +                     { .index = D_PROJINHERIT,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = UINT_MAX,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = D_EXTSZINHERIT,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = UINT_MAX,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>>               },
>>       },
>> -};
>> -
>> -
>> -struct opt_params iopts = {
>> -     .name = 'i',
>> -     .subopts = {
>> +#define OPT_I        2
>> +     {
>> +             .index = OPT_I,
>> +             .name = 'i',
>> +             .subopts = {
>>  #define      I_ALIGN         0
>> -             "align",
>> +                     "align",
>>  #define      I_LOG           1
>> -             "log",
>> +                     "log",
>>  #define      I_MAXPCT        2
>> -             "maxpct",
>> +                     "maxpct",
>>  #define      I_PERBLOCK      3
>> -             "perblock",
>> +                     "perblock",
>>  #define      I_SIZE          4
>> -             "size",
>> +                     "size",
>>  #define      I_ATTR          5
>> -             "attr",
>> +                     "attr",
>>  #define      I_PROJID32BIT   6
>> -             "projid32bit",
>> +                     "projid32bit",
>>  #define I_SPINODES   7
>> -             "sparse",
>> -             NULL
>> -     },
>> -     .subopt_params = {
>> -             { .index = I_ALIGN,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> -             },
>> -             { .index = I_LOG,
>> -               .conflicts = { I_PERBLOCK,
>> -                              I_SIZE,
>> -                              LAST_CONFLICT },
>> -               .minval = XFS_DINODE_MIN_LOG,
>> -               .maxval = XFS_DINODE_MAX_LOG,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = I_MAXPCT,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 100,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> +                     "sparse",
>> +                     NULL
>>               },
>> -             { .index = I_PERBLOCK,
>> -               .conflicts = { I_LOG,
>> -                              I_SIZE,
>> -                              LAST_CONFLICT },
>> -               .is_power_2 = true,
>> -               .minval = XFS_MIN_INODE_PERBLOCK,
>> -               .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = I_SIZE,
>> -               .conflicts = { I_PERBLOCK,
>> -                              I_LOG,
>> -                              LAST_CONFLICT },
>> -               .is_power_2 = true,
>> -               .minval = XFS_DINODE_MIN_SIZE,
>> -               .maxval = XFS_DINODE_MAX_SIZE,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = I_ATTR,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 2,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = I_PROJID32BIT,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> -             },
>> -             { .index = I_SPINODES,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> +             .subopt_params = {
>> +                     { .index = I_ALIGN,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>> +                     { .index = I_LOG,
>> +                       .conflicts = { I_PERBLOCK,
>> +                                      I_SIZE,
>> +                                      LAST_CONFLICT },
>> +                       .minval = XFS_DINODE_MIN_LOG,
>> +                       .maxval = XFS_DINODE_MAX_LOG,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = I_MAXPCT,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 100,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = I_PERBLOCK,
>> +                       .conflicts = { I_LOG,
>> +                                      I_SIZE,
>> +                                      LAST_CONFLICT },
>> +                       .is_power_2 = true,
>> +                       .minval = XFS_MIN_INODE_PERBLOCK,
>> +                       .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = I_SIZE,
>> +                       .conflicts = { I_PERBLOCK,
>> +                                      I_LOG,
>> +                                      LAST_CONFLICT },
>> +                       .is_power_2 = true,
>> +                       .minval = XFS_DINODE_MIN_SIZE,
>> +                       .maxval = XFS_DINODE_MAX_SIZE,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = I_ATTR,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 2,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = I_PROJID32BIT,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>> +                     { .index = I_SPINODES,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>>               },
>>       },
>> -};
>> -
>> -struct opt_params lopts = {
>> -     .name = 'l',
>> -     .subopts = {
>> -#define      L_AGNUM         0
>> -             "agnum",
>> -#define      L_INTERNAL      1
>> -             "internal",
>> -#define      L_SIZE          2
>> -             "size",
>> -#define L_VERSION    3
>> -             "version",
>> -#define L_SUNIT              4
>> -             "sunit",
>> -#define L_SU         5
>> -             "su",
>> -#define L_DEV                6
>> -             "logdev",
>> -#define      L_SECTLOG       7
>> -             "sectlog",
>> -#define      L_SECTSIZE      8
>> -             "sectsize",
>> -#define      L_FILE          9
>> -             "file",
>> -#define      L_NAME          10
>> -             "name",
>> -#define      L_LAZYSBCNTR    11
>> -             "lazy-count",
>> -             NULL
>> -     },
>> -     .subopt_params = {
>> -             { .index = L_AGNUM,
>> -               .conflicts = { L_DEV,
>> -                              LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = UINT_MAX,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = L_INTERNAL,
>> -               .conflicts = { L_FILE,
>> -                              L_DEV,
>> -                              LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> +#define OPT_L        3
>> +     {
>> +             .index = OPT_L,
>> +             .name = 'l',
>> +             .subopts = {
>> +     #define L_AGNUM         0
>> +                     "agnum",
>> +     #define L_INTERNAL      1
>> +                     "internal",
>> +     #define L_SIZE          2
>> +                     "size",
>> +     #define L_VERSION       3
>> +                     "version",
>> +     #define L_SUNIT         4
>> +                     "sunit",
>> +     #define L_SU            5
>> +                     "su",
>> +     #define L_DEV           6
>> +                     "logdev",
>> +     #define L_SECTLOG       7
>> +                     "sectlog",
>> +     #define L_SECTSIZE      8
>> +                     "sectsize",
>> +     #define L_FILE          9
>> +                     "file",
>> +     #define L_NAME          10
>> +                     "name",
>> +     #define L_LAZYSBCNTR    11
>> +                     "lazy-count",
>> +                     NULL
>>               },
>> -             { .index = L_SIZE,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .convert = true,
>> -               .minval = 2 * 1024 * 1024LL,  /* XXX: XFS_MIN_LOG_BYTES */
>> -               .maxval = XFS_MAX_LOG_BYTES,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = L_VERSION,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 1,
>> -               .maxval = 2,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = L_SUNIT,
>> -               .conflicts = { L_SU,
>> -                              LAST_CONFLICT },
>> -               .minval = 1,
>> -               .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = L_SU,
>> -               .conflicts = { L_SUNIT,
>> -                              LAST_CONFLICT },
>> -               .convert = true,
>> -               .minval = BBTOB(1),
>> -               .maxval = XLOG_MAX_RECORD_BSIZE,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = L_DEV,
>> -               .conflicts = { L_AGNUM,
>> -                              L_INTERNAL,
>> -                              LAST_CONFLICT },
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = L_SECTLOG,
>> -               .conflicts = { L_SECTSIZE,
>> -                              LAST_CONFLICT },
>> -               .minval = XFS_MIN_SECTORSIZE_LOG,
>> -               .maxval = XFS_MAX_SECTORSIZE_LOG,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = L_SECTSIZE,
>> -               .conflicts = { L_SECTLOG,
>> -                              LAST_CONFLICT },
>> -               .convert = true,
>> -               .is_power_2 = true,
>> -               .minval = XFS_MIN_SECTORSIZE,
>> -               .maxval = XFS_MAX_SECTORSIZE,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = L_FILE,
>> -               .conflicts = { L_INTERNAL,
>> -                              LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> -             },
>> -             { .index = L_NAME,
>> -               .conflicts = { L_AGNUM,
>> -                              L_INTERNAL,
>> -                              LAST_CONFLICT },
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = L_LAZYSBCNTR,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> +             .subopt_params = {
>> +                     { .index = L_AGNUM,
>> +                       .conflicts = { L_DEV,
>> +                                      LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = UINT_MAX,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = L_INTERNAL,
>> +                       .conflicts = { L_FILE,
>> +                                      L_DEV,
>> +                                      LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>> +                     { .index = L_SIZE,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .convert = true,
>> +                       .minval = 2 * 1024 * 1024LL,  /* XXX: XFS_MIN_LOG_BYTES */
>
> I recognize that this is a mechanical translation patch, but why does
> this setter have an XXX comment for a #define that actually exists?  And
> why does the value used differ??
>
> If this needs fixing, please do it as a separate patch.

Mmm, I will check this.

>
> As far as this one goes,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>
>> +                       .maxval = XFS_MAX_LOG_BYTES,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = L_VERSION,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 1,
>> +                       .maxval = 2,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = L_SUNIT,
>> +                       .conflicts = { L_SU,
>> +                                      LAST_CONFLICT },
>> +                       .minval = 1,
>> +                       .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = L_SU,
>> +                       .conflicts = { L_SUNIT,
>> +                                      LAST_CONFLICT },
>> +                       .convert = true,
>> +                       .minval = BBTOB(1),
>> +                       .maxval = XLOG_MAX_RECORD_BSIZE,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = L_DEV,
>> +                       .conflicts = { L_AGNUM,
>> +                                      L_INTERNAL,
>> +                                      LAST_CONFLICT },
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = L_SECTLOG,
>> +                       .conflicts = { L_SECTSIZE,
>> +                                      LAST_CONFLICT },
>> +                       .minval = XFS_MIN_SECTORSIZE_LOG,
>> +                       .maxval = XFS_MAX_SECTORSIZE_LOG,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = L_SECTSIZE,
>> +                       .conflicts = { L_SECTLOG,
>> +                                      LAST_CONFLICT },
>> +                       .convert = true,
>> +                       .is_power_2 = true,
>> +                       .minval = XFS_MIN_SECTORSIZE,
>> +                       .maxval = XFS_MAX_SECTORSIZE,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = L_FILE,
>> +                       .conflicts = { L_INTERNAL,
>> +                                      LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>> +                     { .index = L_NAME,
>> +                       .conflicts = { L_AGNUM,
>> +                                      L_INTERNAL,
>> +                                      LAST_CONFLICT },
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = L_LAZYSBCNTR,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>>               },
>>       },
>> -};
>> -
>> -struct opt_params nopts = {
>> -     .name = 'n',
>> -     .subopts = {
>> -#define      N_LOG           0
>> -             "log",
>> -#define      N_SIZE          1
>> -             "size",
>> -#define      N_VERSION       2
>> -             "version",
>> -#define      N_FTYPE         3
>> -             "ftype",
>> -     NULL,
>> -     },
>> -     .subopt_params = {
>> -             { .index = N_LOG,
>> -               .conflicts = { N_SIZE,
>> -                              LAST_CONFLICT },
>> -               .minval = XFS_MIN_REC_DIRSIZE,
>> -               .maxval = XFS_MAX_BLOCKSIZE_LOG,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = N_SIZE,
>> -               .conflicts = { N_LOG,
>> -                              LAST_CONFLICT },
>> -               .convert = true,
>> -               .is_power_2 = true,
>> -               .minval = 1 << XFS_MIN_REC_DIRSIZE,
>> -               .maxval = XFS_MAX_BLOCKSIZE,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> +#define OPT_N        4
>> +     {
>> +             .index = OPT_N,
>> +             .name = 'n',
>> +             .subopts = {
>> +     #define N_LOG           0
>> +                     "log",
>> +     #define N_SIZE          1
>> +                     "size",
>> +     #define N_VERSION       2
>> +                     "version",
>> +     #define N_FTYPE         3
>> +                     "ftype",
>> +             NULL,
>>               },
>> -             { .index = N_VERSION,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 2,
>> -               .maxval = 2,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> +             .subopt_params = {
>> +                     { .index = N_LOG,
>> +                       .conflicts = { N_SIZE,
>> +                                      LAST_CONFLICT },
>> +                       .minval = XFS_MIN_REC_DIRSIZE,
>> +                       .maxval = XFS_MAX_BLOCKSIZE_LOG,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = N_SIZE,
>> +                       .conflicts = { N_LOG,
>> +                                      LAST_CONFLICT },
>> +                       .convert = true,
>> +                       .is_power_2 = true,
>> +                       .minval = 1 << XFS_MIN_REC_DIRSIZE,
>> +                       .maxval = XFS_MAX_BLOCKSIZE,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = N_VERSION,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 2,
>> +                       .maxval = 2,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = N_FTYPE,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>>               },
>> -             { .index = N_FTYPE,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> -             },
>> -     },
>> -};
>> -
>> -struct opt_params ropts = {
>> -     .name = 'r',
>> -     .subopts = {
>> -#define      R_EXTSIZE       0
>> -             "extsize",
>> -#define      R_SIZE          1
>> -             "size",
>> -#define      R_DEV           2
>> -             "rtdev",
>> -#define      R_FILE          3
>> -             "file",
>> -#define      R_NAME          4
>> -             "name",
>> -#define R_NOALIGN    5
>> -             "noalign",
>> -             NULL
>>       },
>> -     .subopt_params = {
>> -             { .index = R_EXTSIZE,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .convert = true,
>> -               .minval = XFS_MIN_RTEXTSIZE,
>> -               .maxval = XFS_MAX_RTEXTSIZE,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> +#define OPT_R        5
>> +     {
>> +             .index = OPT_R,
>> +             .name = 'r',
>> +             .subopts = {
>> +     #define R_EXTSIZE       0
>> +                     "extsize",
>> +     #define R_SIZE          1
>> +                     "size",
>> +     #define R_DEV           2
>> +                     "rtdev",
>> +     #define R_FILE          3
>> +                     "file",
>> +     #define R_NAME          4
>> +                     "name",
>> +     #define R_NOALIGN       5
>> +                     "noalign",
>> +                     NULL
>>               },
>> -             { .index = R_SIZE,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .convert = true,
>> -               .minval = 0,
>> -               .maxval = LLONG_MAX,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = R_DEV,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = R_FILE,
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> -               .conflicts = { LAST_CONFLICT },
>> -             },
>> -             { .index = R_NAME,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = R_NOALIGN,
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> -               .conflicts = { LAST_CONFLICT },
>> +             .subopt_params = {
>> +                     { .index = R_EXTSIZE,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .convert = true,
>> +                       .minval = XFS_MIN_RTEXTSIZE,
>> +                       .maxval = XFS_MAX_RTEXTSIZE,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = R_SIZE,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .convert = true,
>> +                       .minval = 0,
>> +                       .maxval = LLONG_MAX,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = R_DEV,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = R_FILE,
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                     },
>> +                     { .index = R_NAME,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = R_NOALIGN,
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                     },
>>               },
>>       },
>> -};
>> -
>> -struct opt_params sopts = {
>> -     .name = 's',
>> -     .subopts = {
>> -#define      S_LOG           0
>> -             "log",
>> -#define      S_SECTLOG       1
>> -             "sectlog",
>> -#define      S_SIZE          2
>> -             "size",
>> -#define      S_SECTSIZE      3
>> -             "sectsize",
>> -             NULL
>> -     },
>> -     .subopt_params = {
>> -             { .index = S_LOG,
>> -               .conflicts = { S_SIZE,
>> -                              S_SECTSIZE,
>> -                              LAST_CONFLICT },
>> -               .minval = XFS_MIN_SECTORSIZE_LOG,
>> -               .maxval = XFS_MAX_SECTORSIZE_LOG,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = S_SECTLOG,
>> -               .conflicts = { S_SIZE,
>> -                              S_SECTSIZE,
>> -                              LAST_CONFLICT },
>> -               .minval = XFS_MIN_SECTORSIZE_LOG,
>> -               .maxval = XFS_MAX_SECTORSIZE_LOG,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = S_SIZE,
>> -               .conflicts = { S_LOG,
>> -                              S_SECTLOG,
>> -                              LAST_CONFLICT },
>> -               .convert = true,
>> -               .is_power_2 = true,
>> -               .minval = XFS_MIN_SECTORSIZE,
>> -               .maxval = XFS_MAX_SECTORSIZE,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> +#define OPT_S        6
>> +     {
>> +             .index = OPT_S,
>> +             .name = 's',
>> +             .subopts = {
>> +     #define S_LOG           0
>> +                     "log",
>> +     #define S_SECTLOG       1
>> +                     "sectlog",
>> +     #define S_SIZE          2
>> +                     "size",
>> +     #define S_SECTSIZE      3
>> +                     "sectsize",
>> +                     NULL
>>               },
>> -             { .index = S_SECTSIZE,
>> -               .conflicts = { S_LOG,
>> -                              S_SECTLOG,
>> -                              LAST_CONFLICT },
>> -               .convert = true,
>> -               .is_power_2 = true,
>> -               .minval = XFS_MIN_SECTORSIZE,
>> -               .maxval = XFS_MAX_SECTORSIZE,
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> +             .subopt_params = {
>> +                     { .index = S_LOG,
>> +                       .conflicts = { S_SIZE,
>> +                                      S_SECTSIZE,
>> +                                      LAST_CONFLICT },
>> +                       .minval = XFS_MIN_SECTORSIZE_LOG,
>> +                       .maxval = XFS_MAX_SECTORSIZE_LOG,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = S_SECTLOG,
>> +                       .conflicts = { S_SIZE,
>> +                                      S_SECTSIZE,
>> +                                      LAST_CONFLICT },
>> +                       .minval = XFS_MIN_SECTORSIZE_LOG,
>> +                       .maxval = XFS_MAX_SECTORSIZE_LOG,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = S_SIZE,
>> +                       .conflicts = { S_LOG,
>> +                                      S_SECTLOG,
>> +                                      LAST_CONFLICT },
>> +                       .convert = true,
>> +                       .is_power_2 = true,
>> +                       .minval = XFS_MIN_SECTORSIZE,
>> +                       .maxval = XFS_MAX_SECTORSIZE,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = S_SECTSIZE,
>> +                       .conflicts = { S_LOG,
>> +                                      S_SECTLOG,
>> +                                      LAST_CONFLICT },
>> +                       .convert = true,
>> +                       .is_power_2 = true,
>> +                       .minval = XFS_MIN_SECTORSIZE,
>> +                       .maxval = XFS_MAX_SECTORSIZE,
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>>               },
>>       },
>> -};
>> -
>> -struct opt_params mopts = {
>> -     .name = 'm',
>> -     .subopts = {
>> -#define      M_CRC           0
>> -             "crc",
>> -#define M_FINOBT     1
>> -             "finobt",
>> -#define M_UUID               2
>> -             "uuid",
>> -#define M_RMAPBT     3
>> -             "rmapbt",
>> -#define M_REFLINK    4
>> -             "reflink",
>> -             NULL
>> -     },
>> -     .subopt_params = {
>> -             { .index = M_CRC,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> -             },
>> -             { .index = M_FINOBT,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> +#define OPT_M        7
>> +     {
>> +             .index = OPT_M,
>> +             .name = 'm',
>> +             .subopts = {
>> +     #define M_CRC           0
>> +                     "crc",
>> +     #define M_FINOBT        1
>> +                     "finobt",
>> +     #define M_UUID          2
>> +                     "uuid",
>> +     #define M_RMAPBT        3
>> +                     "rmapbt",
>> +     #define M_REFLINK       4
>> +                     "reflink",
>> +                     NULL
>>               },
>> -             { .index = M_UUID,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .flagval = SUBOPT_NEEDS_VAL,
>> -             },
>> -             { .index = M_RMAPBT,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> -             },
>> -             { .index = M_REFLINK,
>> -               .conflicts = { LAST_CONFLICT },
>> -               .minval = 0,
>> -               .maxval = 1,
>> -               .flagval = 1,
>> +             .subopt_params = {
>> +                     { .index = M_CRC,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>> +                     { .index = M_FINOBT,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>> +                     { .index = M_UUID,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .flagval = SUBOPT_NEEDS_VAL,
>> +                     },
>> +                     { .index = M_RMAPBT,
>> +                     .conflicts = { LAST_CONFLICT },
>> +                     .minval = 0,
>> +                     .maxval = 1,
>> +                     .flagval = 1,
>> +                     },
>> +                     { .index = M_REFLINK,
>> +                       .conflicts = { LAST_CONFLICT },
>> +                       .minval = 0,
>> +                       .maxval = 1,
>> +                       .flagval = 1,
>> +                     },
>>               },
>>       },
>>  };
>> @@ -740,21 +754,22 @@ struct opt_params mopts = {
>>   * the string to be saved.
>>   */
>>  static int
>> -set_conf_raw(struct opt_params *opt, const int subopt, const char *value)
>> +set_conf_raw(const int opt, const int subopt, const char *value)
>>  {
>> -     if (subopt < 0 || subopt >= MAX_SUBOPTS) {
>> +     if (subopt < 0 || subopt >= MAX_SUBOPTS ||
>> +         opt < 0 || opt >= MAX_OPTS) {
>>               fprintf(stderr,
>> -             "This is a bug: set_conf_raw called with invalid opt/subopt: %c/%d\n",
>> -             opt->name, subopt);
>> +             "This is a bug: set_conf_raw called with invalid opt/subopt: %d/%d\n",
>> +             opt, subopt);
>>               return -EINVAL;
>>       }
>>       if (value == NULL) {
>> -             if (opt->subopt_params[subopt].raw_input != NULL)
>> -                     free(opt->subopt_params[subopt].raw_input);
>> -             opt->subopt_params[subopt].raw_input = NULL;
>> +             if (opts[opt].subopt_params[subopt].raw_input != NULL)
>> +                     free(opts[opt].subopt_params[subopt].raw_input);
>> +             opts[opt].subopt_params[subopt].raw_input = NULL;
>>       } else {
>> -             opt->subopt_params[subopt].raw_input = strdup(value);
>> -             if (opt->subopt_params[subopt].raw_input == NULL)
>> +             opts[opt].subopt_params[subopt].raw_input = strdup(value);
>> +             if (opts[opt].subopt_params[subopt].raw_input == NULL)
>>                       return -ENOMEM;
>>       }
>>       return 0;
>> @@ -765,19 +780,19 @@ set_conf_raw(struct opt_params *opt, const int subopt, const char *value)
>>   * the string to be saved into the out pointer.
>>   */
>>  static int
>> -get_conf_raw(const struct opt_params *opt, const int subopt, char **out)
>> +get_conf_raw(const int opt, const int subopt, char **out)
>>  {
>> -     if (subopt < 0 || subopt >= MAX_SUBOPTS) {
>> +     if (subopt < 0 || subopt >= MAX_SUBOPTS ||
>> +         opt < 0 || opt >= MAX_OPTS) {
>>               fprintf(stderr,
>> -             "This is a bug: get_conf_raw called with invalid opt/subopt: %c/%d\n",
>> -             opt->name, subopt);
>> +             "This is a bug: get_conf_raw called with invalid opt/subopt: %d/%d\n",
>> +             opt, subopt);
>>               return -EINVAL;
>>       }
>> -     *out = strdup(opt->subopt_params[subopt].raw_input);
>> +     *out = strdup(opts[opt].subopt_params[subopt].raw_input);
>>       if (*out == NULL)
>>               return -ENOMEM;
>>       return 0;
>> -
>>  }
>>
>>  /*
>> @@ -785,7 +800,7 @@ get_conf_raw(const struct opt_params *opt, const int subopt, char **out)
>>   * If any error occurs, return NULL.
>>   */
>>  static char *
>> -get_conf_raw_safe(const struct opt_params *opt, const int subopt)
>> +get_conf_raw_safe(const int opt, const int subopt)
>>  {
>>       char *str;
>>
>> @@ -1396,7 +1411,7 @@ getnum(
>>       long long               c;
>>
>>       check_opt(opts, index, false);
>> -     set_conf_raw(opts, index, str);
>> +     set_conf_raw(opts->index, index, str);
>>       /* empty strings might just return a default value */
>>       if (!str || *str == '\0') {
>>               if (sp->flagval == SUBOPT_NEEDS_VAL)
>> @@ -1611,17 +1626,19 @@ main(
>>               case 'b':
>>                       p = optarg;
>>                       while (*p != '\0') {
>> -                             char    **subopts = (char **)bopts.subopts;
>> +                             char    **subopts =
>> +                                             (char **)opts[OPT_B].subopts;
>>                               char    *value;
>>
>>                               switch (getsubopt(&p, subopts, &value)) {
>>                               case B_LOG:
>> -                                     blocklog = getnum(value, &bopts, B_LOG);
>> +                                     blocklog = getnum(value, &opts[OPT_B],
>> +                                                             B_LOG);
>
> I was thinking that these should get moved to separate functions to
> handle each option category (-b, -d, -m, etc.) to reduce the indenting
> here, but that's a job for a subsequent patch (or maybe you do it later
> already?)

I'm not doing it, but it is a good idea. I will see how it looks in as
a separate patch later on.

Jan

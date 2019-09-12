Return-Path: <SRS0=88Vy=XH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0459EC4CEC7
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 23:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB58220663
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 23:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfILXvW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 19:51:22 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37570 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727529AbfILXvW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Sep 2019 19:51:22 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8A02343E20A;
        Fri, 13 Sep 2019 09:51:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i8Yru-0007wx-17; Fri, 13 Sep 2019 09:51:18 +1000
Date:   Fri, 13 Sep 2019 09:51:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_io: add a bulkstat command
Message-ID: <20190912235117.GR16973@dread.disaster.area>
References: <156774093859.2644581.13218735172589605186.stgit@magnolia>
 <156774094490.2644581.8349943022595761350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156774094490.2644581.8349943022595761350.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=1ET26MayxucR28D5ntsA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:35:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a bulkstat command to xfs_io so that we can test our new xfrog code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  io/Makefile        |    9 -
>  io/bulkstat.c      |  533 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  io/init.c          |    1 
>  io/io.h            |    1 
>  libfrog/bulkstat.c |   20 ++
>  libfrog/bulkstat.h |    3 
>  man/man8/xfs_io.8  |   68 +++++++
>  7 files changed, 631 insertions(+), 4 deletions(-)
>  create mode 100644 io/bulkstat.c
> 
> 
> diff --git a/io/Makefile b/io/Makefile
> index 484e2b5a..1112605e 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -9,10 +9,11 @@ LTCOMMAND = xfs_io
>  LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
>  HFILES = init.h io.h
>  CFILES = init.c \
> -	attr.c bmap.c crc32cselftest.c cowextsize.c encrypt.c file.c freeze.c \
> -	fsync.c getrusage.c imap.c inject.c label.c link.c mmap.c open.c \
> -	parent.c pread.c prealloc.c pwrite.c reflink.c resblks.c scrub.c \
> -	seek.c shutdown.c stat.c swapext.c sync.c truncate.c utimes.c
> +	attr.c bmap.c bulkstat.c crc32cselftest.c cowextsize.c encrypt.c \
> +	file.c freeze.c fsync.c getrusage.c imap.c inject.c label.c link.c \
> +	mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
> +	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
> +	truncate.c utimes.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
> diff --git a/io/bulkstat.c b/io/bulkstat.c
> new file mode 100644
> index 00000000..76ba682b
> --- /dev/null
> +++ b/io/bulkstat.c
> @@ -0,0 +1,533 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include "xfs.h"
> +#include "platform_defs.h"
> +#include "command.h"
> +#include "init.h"
> +#include "libfrog/fsgeom.h"
> +#include "libfrog/bulkstat.h"
> +#include "libfrog/paths.h"
> +#include "io.h"
> +#include "input.h"
> +
> +static bool debug;
> +
> +static void
> +dump_bulkstat_time(
> +	const char		*tag,
> +	uint64_t		sec,
> +	uint32_t		nsec)
> +{
> +	printf("\t%s = %"PRIu64".%"PRIu32"\n", tag, sec, nsec);
> +}
> +
> +static void
> +dump_bulkstat(
> +	struct xfs_bulkstat	*bstat)
> +{
> +	printf("bs_ino = %"PRIu64"\n", bstat->bs_ino);
> +	printf("\tbs_size = %"PRIu64"\n", bstat->bs_size);
> +
> +	printf("\tbs_blocks = %"PRIu64"\n", bstat->bs_blocks);
> +	printf("\tbs_xflags = 0x%"PRIx64"\n", bstat->bs_xflags);
> +
> +	dump_bulkstat_time("bs_atime", bstat->bs_atime, bstat->bs_atime_nsec);
> +	dump_bulkstat_time("bs_ctime", bstat->bs_ctime, bstat->bs_ctime_nsec);
> +	dump_bulkstat_time("bs_mtime", bstat->bs_mtime, bstat->bs_mtime_nsec);
> +	dump_bulkstat_time("bs_btime", bstat->bs_btime, bstat->bs_btime_nsec);
> +
> +	printf("\tbs_gen = 0x%"PRIx32"\n", bstat->bs_gen);
> +	printf("\tbs_uid = %"PRIu32"\n", bstat->bs_uid);
> +	printf("\tbs_gid = %"PRIu32"\n", bstat->bs_gid);
> +	printf("\tbs_projectid = %"PRIu32"\n", bstat->bs_projectid);
> +
> +	printf("\tbs_blksize = %"PRIu32"\n", bstat->bs_blksize);
> +	printf("\tbs_rdev = %"PRIu32"\n", bstat->bs_rdev);
> +	printf("\tbs_cowextsize_blks = %"PRIu32"\n", bstat->bs_cowextsize_blks);
> +	printf("\tbs_extsize_blks = %"PRIu32"\n", bstat->bs_extsize_blks);
> +
> +	printf("\tbs_nlink = %"PRIu32"\n", bstat->bs_nlink);
> +	printf("\tbs_extents = %"PRIu32"\n", bstat->bs_extents);
> +	printf("\tbs_aextents = %"PRIu32"\n", bstat->bs_aextents);
> +	printf("\tbs_version = %"PRIu16"\n", bstat->bs_version);
> +	printf("\tbs_forkoff = %"PRIu16"\n", bstat->bs_forkoff);
> +
> +	printf("\tbs_sick = 0x%"PRIx16"\n", bstat->bs_sick);
> +	printf("\tbs_checked = 0x%"PRIx16"\n", bstat->bs_checked);
> +	printf("\tbs_mode = 0%"PRIo16"\n", bstat->bs_mode);
> +};
> +
> +static void
> +bulkstat_help(void)
> +{
> +	printf(_(
> +"Bulk-queries the filesystem for inode stat information and prints it.\n"
> +"\n"
> +"   -a   Only iterate this AG.\n"
> +"   -d   Print debugging output.\n"
> +"   -e   Stop after this inode.\n"
> +"   -n   Ask for this many results at once.\n"
> +"   -s   Inode to start with.\n"
> +"   -v   Use this version of the ioctl (1 or 5).\n"));
> +}
> +
> +static int
> +bulkstat_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
> +	struct xfs_bulkstat_req	*breq;
> +	unsigned long long	startino = 0;
> +	unsigned long long	endino = -1ULL;
> +	unsigned long		batch_size = 4096;
> +	unsigned long		agno = 0;
> +	unsigned long		ver = 0;
> +	bool			has_agno = false;
> +	unsigned int		i;
> +	int			c;
> +	int			ret;
> +
> +	while ((c = getopt(argc, argv, "a:cde:n:qs:v:")) != -1) {

options c and q are not documented above, and not handled in the
case statement below.

> +		switch (c) {
> +		case 'a':
> +			errno = 0;
> +			agno = strtoul(optarg, NULL, 10);
> +			if (errno) {
> +				perror(optarg);
> +				return 1;
> +			}
> +			has_agno = true;
> +			break;

Why not use cvt_u32() and friends for these so they are directly
converted to the correct type and overflow checked at the same time?

[...]

> +static void
> +inumbers_help(void)
> +{
> +	printf(_(
> +"Queries the filesystem for inode group information and prints it.\n"
> +"\n"
> +"   -a   Only iterate this AG.\n"
> +"   -d   Print debugging output.\n"
> +"   -e   Stop after this inode.\n"
> +"   -n   Ask for this many results at once.\n"
> +"   -s   Inode to start with.\n"
> +"   -v   Use this version of the ioctl (1 or 5).\n"));
> +}
> +
> +static int
> +inumbers_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
> +	struct xfs_inumbers_req	*ireq;
> +	unsigned long long	startino = 0;
> +	unsigned long long	endino = -1ULL;
> +	unsigned long		batch_size = 4096;
> +	unsigned long		agno = 0;
> +	unsigned long		ver = 0;
> +	bool			has_agno = false;
> +	unsigned int		i;
> +	int			c;
> +	int			ret;
> +
> +	while ((c = getopt(argc, argv, "a:cde:n:qs:v:")) != -1) {

Again, c and q not defined. Same comments about cvt_type() as
well...

> +	if (has_agno)
> +		xfrog_inumbers_set_ag(ireq, agno);
> +
> +	switch (ver) {
> +	case 1:
> +		xfd.flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
> +		break;
> +	case 5:
> +		xfd.flags |= XFROG_FLAG_BULKSTAT_FORCE_V5;
> +		break;
> +	default:
> +		break;
> +	}

Common helper?

> +static cmdinfo_t	bulkstat_cmd = {
> +	.name = "bulkstat",
> +	.cfunc = bulkstat_f,
> +	.argmin = 0,
> +	.argmax = -1,
> +	.flags = CMD_NOMAP_OK,
> +	.help = bulkstat_help,
> +};

Theres are all oneshot commands, right?

> +
> +static cmdinfo_t	bulkstat_single_cmd = {
> +	.name = "bulkstat_single",
> +	.cfunc = bulkstat_single_f,
> +	.argmin = 0,
> +	.argmax = -1,
> +	.flags = CMD_NOMAP_OK,
> +	.help = bulkstat_single_help,
> +};

Doesn't this require at least one parameter?

>  
>  .SH FILESYSTEM COMMANDS
>  .TP
> +.BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-n " batchsize " ] [ \-s " startino " ]
> +Display raw stat information about a bunch of inodes in an XFS filesystem.
> +Options are as follows:
> +.RS 1.0i
> +.PD 0
> +.TP
> +.BI \-a " agno"
> +Display only results from the given allocation group.
> +Defaults to zero.

Need to say "If not specified, will all AGs in the fielsystem"

> @@ -1067,6 +1106,35 @@ was specified on the command line, the maximum possible inode number in
>  the system will be printed along with its size.
>  .PD
>  .TP
> +.BI "inumbers [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-n " batchsize " ] [ \-s " startino " ]
> +Prints allocation information about groups of inodes in an XFS filesystem.
> +Callers can use this information to figure out which inodes are allocated.
> +Options are as follows:
> +.RS 1.0i
> +.PD 0
> +.TP
> +.BI \-a " agno"
> +Display only results from the given allocation group.
> +Defaults to zero.

Same again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

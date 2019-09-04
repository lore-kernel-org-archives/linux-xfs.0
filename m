Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325E5C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1163D22CF7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfIDEwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:52:45 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46174 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725267AbfIDEwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:52:45 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6BB8243C349;
        Wed,  4 Sep 2019 14:52:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5NHc-0007dn-3j; Wed, 04 Sep 2019 14:52:40 +1000
Date:   Wed, 4 Sep 2019 14:52:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_spaceman: report health problems
Message-ID: <20190904045240.GB1119@dread.disaster.area>
References: <156685444816.2839912.12432359726352663923.stgit@magnolia>
 <156685445446.2839912.426160608673674011.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685445446.2839912.426160608673674011.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=6ubdwSXrq3sfk1yoSWkA:9
        a=BcixQfwgRtQvA_on:21 a=OZdkxzaGSyvG7xHw:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:20:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the fs and ag geometry ioctls to report health problems to users.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/xfrog.h         |    2 
>  libfrog/fsgeom.c        |   11 +
>  man/man8/xfs_spaceman.8 |   28 +++
>  spaceman/Makefile       |    2 
>  spaceman/health.c       |  432 +++++++++++++++++++++++++++++++++++++++++++++++
>  spaceman/init.c         |    1 
>  spaceman/space.h        |    1 
>  7 files changed, 476 insertions(+), 1 deletion(-)
>  create mode 100644 spaceman/health.c
> 
> 
> diff --git a/include/xfrog.h b/include/xfrog.h
> index 5748e967..3a43a403 100644
> --- a/include/xfrog.h
> +++ b/include/xfrog.h
> @@ -177,4 +177,6 @@ struct xfs_inogrp;
>  int xfrog_inumbers(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
>  		struct xfs_inogrp *ubuffer, uint32_t *ocount);
>  
> +int xfrog_ag_geometry(int fd, unsigned int agno, struct xfs_ag_geometry *ageo);
> +
>  #endif	/* __XFROG_H__ */
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index 17479e4a..cddb5a39 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -131,3 +131,14 @@ xfrog_close(
>  	xfd->fd = -1;
>  	return ret;
>  }
> +
> +/* Try to obtain an AG's geometry. */
> +int
> +xfrog_ag_geometry(
> +	int			fd,
> +	unsigned int		agno,
> +	struct xfs_ag_geometry	*ageo)
> +{
> +	ageo->ag_number = agno;
> +	return ioctl(fd, XFS_IOC_AG_GEOMETRY, ageo);

Does it need this first:

	memset(ageo, 0, sizeof(*ageo));

Because I don't think the callers zero it....

> +static const struct flag_map inode_flags[] = {
> +	{
> +		.mask = XFS_BS_SICK_INODE,
> +		.descr = "inode core",
> +	},
> +	{
> +		.mask = XFS_BS_SICK_BMBTD,
> +		.descr = "data fork",
> +	},
> +	{
> +		.mask = XFS_BS_SICK_BMBTA,
> +		.descr = "extended attribute fork",
> +	},
> +	{
> +		.mask = XFS_BS_SICK_BMBTC,
> +		.descr = "copy on write fork",
> +	},
> +	{
> +		.mask = XFS_BS_SICK_DIR,
> +		.descr = "directory",
> +	},
> +	{
> +		.mask = XFS_BS_SICK_XATTR,
> +		.descr = "extended attributes",
> +	},
> +	{
> +		.mask = XFS_BS_SICK_SYMLINK,
> +		.descr = "symbolic link target",
> +	},
> +	{
> +		.mask = XFS_BS_SICK_PARENT,
> +		.descr = "parent pointers",

This needs a "has_parent_pointers" feature check function,
doesn't it? Or is this already a valid status for directory inodes?

> +static int
> +report_bulkstat_health(
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_bstat	bstat[128];
> +	char			descr[256];
> +	uint64_t		startino = 0;
> +	uint64_t		lastino = -1ULL;
> +	uint32_t		ocount;
> +	uint32_t		i;
> +	int			error;
> +
> +	if (agno != NULLAGNUMBER) {
> +		startino = xfrog_agino_to_ino(&file->xfd, agno, 0);
> +		lastino = xfrog_agino_to_ino(&file->xfd, agno + 1, 0) - 1;
> +	}
> +
> +	while ((error = xfrog_bulkstat(&file->xfd, &startino, 128, bstat,

Nit: use a define for the number of inodes to bulkstat.

> +health_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	unsigned long long	x;
> +	xfs_agnumber_t		agno;
> +	bool			default_report = true;
> +	int			c;
> +	int			ret;
> +
> +	reported = 0;
> +
> +	if (file->xfd.fsgeom.version != XFS_FSOP_GEOM_VERSION_V5) {
> +		perror("health");
> +		return 1;
> +	}
> +
> +	while ((c = getopt(argc, argv, "a:cfi:q")) != EOF) {
> +		switch (c) {
> +		case 'a':
> +			default_report = false;
> +			errno = 0;
> +			x = strtoll(optarg, NULL, 10);
> +			if (!errno && x >= NULLAGNUMBER)
> +				errno = ERANGE;
> +			if (errno) {
> +				perror("ag health");
> +				return 1;
> +			}
> +			agno = x;
> +			ret = report_ag_sick(agno);
> +			if (!ret && comprehensive)
> +				ret = report_bulkstat_health(agno);
> +			if (ret)
> +				return 1;
> +			break;
> +		case 'c':
> +			comprehensive = true;
> +			break;

There's a command line ordering problem here - - "-a" and "-f" 
check the comprehensive flag and do additional stuff based on it.

So I think the -a and -f processing need to be done outside
the args processing loop, or we need two loops to extract the
-c first...

Otherwise looks OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

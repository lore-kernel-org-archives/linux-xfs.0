Return-Path: <SRS0=/CVM=XI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98A6C4CEC6
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Sep 2019 01:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FDBE20856
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Sep 2019 01:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfIMBCl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 21:02:41 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51039 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725775AbfIMBCl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Sep 2019 21:02:41 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DC30F43E39F;
        Fri, 13 Sep 2019 11:02:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i8Zyv-0008So-9u; Fri, 13 Sep 2019 11:02:37 +1000
Date:   Fri, 13 Sep 2019 11:02:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] misc: convert to v5 bulkstat_single call
Message-ID: <20190913010237.GW16973@dread.disaster.area>
References: <156774089024.2643497.2754524603021685770.stgit@magnolia>
 <156774092210.2643497.7118033849671297049.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156774092210.2643497.7118033849671297049.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=JuqHyjTJJpmPSd5TsvEA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:35:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  spaceman/health.c  |    4 +-
>  7 files changed, 105 insertions(+), 32 deletions(-)
> 
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index cc3cc93a..e8fa39ab 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -724,6 +724,7 @@ fsrfile(
>  	xfs_ino_t		ino)
>  {
>  	struct xfs_fd		fsxfd = XFS_FD_INIT_EMPTY;
> +	struct xfs_bulkstat	bulkstat;
>  	struct xfs_bstat	statbuf;
>  	jdm_fshandle_t		*fshandlep;
>  	int			fd = -1;
> @@ -748,12 +749,13 @@ fsrfile(
>  		goto out;
>  	}
>  
> -	error = xfrog_bulkstat_single(&fsxfd, ino, &statbuf);
> +	error = xfrog_bulkstat_single(&fsxfd, ino, 0, &bulkstat);
>  	if (error) {
>  		fsrprintf(_("unable to get bstat on %s: %s\n"),
>  			fname, strerror(error));
>  		goto out;
>  	}
> +	xfrog_bulkstat_to_bstat(&fsxfd, &statbuf, &bulkstat);

So this is so none of the rest of fsr needs to be converted to use
the new structure versions? When will this go away?

>  	do {
> -		struct xfs_bstat tbstat;
> +		struct xfs_bulkstat	tbstat;
>  		char		name[64];
>  		int		ret;
>  
> @@ -983,7 +985,7 @@ fsr_setup_attr_fork(
>  		 * this to compare against the target and determine what we
>  		 * need to do.
>  		 */
> -		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, &tbstat);
> +		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, 0, &tbstat);
>  		if (ret) {
>  			fsrprintf(_("unable to get bstat on temp file: %s\n"),
>  						strerror(ret));

Because this looks like we now have a combination of v1 and v5
structures being used...

>  
> diff --git a/io/swapext.c b/io/swapext.c
> index 2b4918f8..ca024b93 100644
> --- a/io/swapext.c
> +++ b/io/swapext.c
> @@ -28,6 +28,7 @@ swapext_f(
>  	char			**argv)
>  {
>  	struct xfs_fd		fxfd = XFS_FD_INIT(file->fd);
> +	struct xfs_bulkstat	bulkstat;
>  	int			fd;
>  	int			error;
>  	struct xfs_swapext	sx;
> @@ -48,12 +49,13 @@ swapext_f(
>  		goto out;
>  	}
>  
> -	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, &sx.sx_stat);
> +	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, 0, &bulkstat);
>  	if (error) {
>  		errno = error;
>  		perror("bulkstat");
>  		goto out;
>  	}
> +	xfrog_bulkstat_to_bstat(&fxfd, &sx.sx_stat, &bulkstat);

and this is required because bstat is part of the swapext ioctl ABI?

>  	sx.sx_version = XFS_SX_VERSION;
>  	sx.sx_fdtarget = file->fd;
>  	sx.sx_fdtmp = fd;
> diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> index b4468243..2a70824e 100644
> --- a/libfrog/bulkstat.c
> +++ b/libfrog/bulkstat.c
> @@ -20,26 +20,99 @@ xfrog_bulkstat_prep_v1_emulation(
>  	return xfd_prepare_geometry(xfd);
>  }
>  
> +/* Bulkstat a single inode using v5 ioctl. */
> +static int
> +xfrog_bulkstat_single5(
> +	struct xfs_fd			*xfd,
> +	uint64_t			ino,
> +	unsigned int			flags,
> +	struct xfs_bulkstat		*bulkstat)
> +{
> +	struct xfs_bulkstat_req		*req;
> +	int				ret;
> +
> +	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
> +		return EINVAL;

negative error returns, please.

> @@ -57,8 +57,6 @@ xfs_iterate_inodes_range_check(
>  	int			error;
>  
>  	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
> -		struct xfs_bstat bs1;
> -
>  		if (!(inogrp->xi_allocmask & (1ULL << i)))
>  			continue;
>  		if (bs->bs_ino == inogrp->xi_startino + i) {
> @@ -68,13 +66,11 @@ xfs_iterate_inodes_range_check(
>  
>  		/* Load the one inode. */
>  		error = xfrog_bulkstat_single(&ctx->mnt,
> -				inogrp->xi_startino + i, &bs1);
> -		if (error || bs1.bs_ino != inogrp->xi_startino + i) {
> +				inogrp->xi_startino + i, 0, bs);
> +		if (error || bs->bs_ino != inogrp->xi_startino + i) {
>  			memset(bs, 0, sizeof(struct xfs_bulkstat));
>  			bs->bs_ino = inogrp->xi_startino + i;
>  			bs->bs_blksize = ctx->mnt_sv.f_frsize;
> -		} else {
> -			xfrog_bstat_to_bulkstat(&ctx->mnt, bs, &bs1);
>  		}
>  		bs++;
>  	}

So this immediately tears down the confusing stuff that was set up
in the previous patch. Perhaps separate out the scrub changes and do
both bulkstat and bulkstat_single conversions in one patch?

-Dave.

-- 
Dave Chinner
david@fromorbit.com

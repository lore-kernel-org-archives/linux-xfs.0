Return-Path: <SRS0=/CVM=XI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC46C4CEC6
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Sep 2019 00:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E18D420CC7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Sep 2019 00:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfIMAyc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 20:54:32 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41298 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728297AbfIMAyc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Sep 2019 20:54:32 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 22DBA362AA2;
        Fri, 13 Sep 2019 10:54:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i8Zr0-0008Jb-L8; Fri, 13 Sep 2019 10:54:26 +1000
Date:   Fri, 13 Sep 2019 10:54:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] misc: convert XFS_IOC_FSBULKSTAT to XFS_IOC_BULKSTAT
Message-ID: <20190913005426.GV16973@dread.disaster.area>
References: <156774089024.2643497.2754524603021685770.stgit@magnolia>
 <156774091553.2643497.13127754211857633238.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156774091553.2643497.13127754211857633238.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=GvNPqVkMUF8HW12gvJwA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:35:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert the v1 calls to v5 calls.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fsr/xfs_fsr.c      |   45 ++++++--
>  io/open.c          |   17 ++-
>  libfrog/bulkstat.c |  290 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  libfrog/bulkstat.h |   10 +-
>  libfrog/fsgeom.h   |    9 ++
>  quota/quot.c       |   29 ++---
>  scrub/inodes.c     |   45 +++++---
>  scrub/inodes.h     |    2 
>  scrub/phase3.c     |    6 +
>  scrub/phase5.c     |    8 +
>  scrub/phase6.c     |    2 
>  scrub/unicrash.c   |    6 +
>  scrub/unicrash.h   |    4 -
>  spaceman/health.c  |   28 +++--
>  14 files changed, 411 insertions(+), 90 deletions(-)
> 
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index a53eb924..cc3cc93a 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -466,6 +466,17 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
>  				ptr = strchr(ptr, ' ');
>  				if (ptr) {
>  					startino = strtoull(++ptr, NULL, 10);
> +					/*
> +					 * NOTE: The inode number read in from
> +					 * the leftoff file is the last inode
> +					 * to have been fsr'd.  Since the new
> +					 * xfrog_bulkstat function wants to be
> +					 * passed the first inode that we want
> +					 * to examine, increment the value that
> +					 * we read in.  The debug message below
> +					 * prints the lastoff value.
> +					 */
> +					startino++;
>  				}
>  			}
>  			if (startpass < 0)
> @@ -484,7 +495,7 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
>  
>  	if (vflag) {
>  		fsrprintf(_("START: pass=%d ino=%llu %s %s\n"),
> -			  fs->npass, (unsigned long long)startino,
> +			  fs->npass, (unsigned long long)startino - 1,
>  			  fs->dev, fs->mnt);
>  	}

This could probably go in a spearate patch....

> @@ -724,7 +724,6 @@ inode_f(
>  	char			**argv)
>  {
>  	struct xfs_bstat	bstat;
> -	uint32_t		count = 0;
>  	uint64_t		result_ino = 0;
>  	uint64_t		userino = NULLFSINO;
>  	char			*p;
> @@ -775,21 +774,31 @@ inode_f(
>  		}
>  	} else if (ret_next) {
>  		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
> +		struct xfs_bulkstat_req	*breq;
> +
> +		breq = xfrog_bulkstat_alloc_req(1, userino + 1);
> +		if (!breq) {
> +			perror("alloc bulkstat");
> +			exitcode = 1;
> +			return 0;
> +		}
>  
>  		/* get next inode */
> -		ret = xfrog_bulkstat(&xfd, &userino, 1, &bstat, &count);

Why the "+ 1" on userino setup for the new interface?

> @@ -29,29 +42,278 @@ xfrog_bulkstat_single(
>  	return 0;
>  }
>  
> -/* Bulkstat a bunch of inodes.  Returns zero or a positive error code. */
> -int
> -xfrog_bulkstat(
> +/*
> + * Set up emulation of a v5 bulk request ioctl with a v1 bulk request ioctl.
> + * Returns 0 if the emulation should proceed; ECANCELED if there are no
> + * records; or a positive error code.
> + */
> +static int
> +xfrog_bulk_req_setup(
>  	struct xfs_fd		*xfd,
> -	uint64_t		*lastino,
> -	uint32_t		icount,
> -	struct xfs_bstat	*ubuffer,
> -	uint32_t		*ocount)
> +	struct xfs_bulk_ireq	*hdr,
> +	struct xfs_fsop_bulkreq	*bulkreq,
> +	size_t			rec_size)
> +{
> +	void			*buf;
> +
> +	if (hdr->flags & XFS_BULK_IREQ_AGNO) {
> +		uint32_t	agno = cvt_ino_to_agno(xfd, hdr->ino);
> +
> +		if (hdr->ino == 0)
> +			hdr->ino = cvt_agino_to_ino(xfd, hdr->agno, 0);
> +		else if (agno < hdr->agno)
> +			return EINVAL;
> +		else if (agno > hdr->agno)
> +			goto no_results;
> +	}
> +
> +	if (cvt_ino_to_agno(xfd, hdr->ino) > xfd->fsgeom.agcount)
> +		goto no_results;
> +
> +	buf = malloc(hdr->icount * rec_size);
> +	if (!buf)
> +		return errno;
> +
> +	if (hdr->ino)
> +		hdr->ino--;

This goes with my last question: why?

> +	bulkreq->lastip = (__u64 *)&hdr->ino,
> +	bulkreq->icount = hdr->icount,
> +	bulkreq->ocount = (__s32 *)&hdr->ocount,
> +	bulkreq->ubuffer = buf;
> +	return 0;
> +
> +no_results:
> +	hdr->ocount = 0;
> +	return ECANCELED;

We should be returning negative errors for everything.

> +}
> +
> +/*
> + * Convert records and free resources used to do a v1 emulation of v5 bulk
> + * request.
> + */
> +static int
> +xfrog_bulk_req_teardown(

What's "teardown" got to do with converting results to a v1 format?

Indeed, why is there even emulation of v1 calls in the first place?
why don't callers that need v1 format just use the existing v1
ioctls directly?

>  
> +/* Bulkstat a bunch of inodes using the v1 interface. */
> +static int
> +xfrog_bulkstat1(
> +	struct xfs_fd		*xfd,
> +	struct xfs_bulkstat_req	*req)
> +{
> +	struct xfs_fsop_bulkreq	bulkreq = { 0 };
> +	int			error;
> +
> +	error = xfrog_bulkstat_prep_v1_emulation(xfd);
> +	if (error)
> +		return error;
> +
> +	error = xfrog_bulk_req_setup(xfd, &req->hdr, &bulkreq,
> +			sizeof(struct xfs_bstat));
> +	if (error == ECANCELED)
> +		goto out_teardown;
> +	if (error)
> +		return error;
> +
> +	error = ioctl(xfd->fd, XFS_IOC_FSBULKSTAT, &bulkreq);
> +	if (error)
> +		error = errno;

negative errors, please.

> +
> +out_teardown:
> +	return xfrog_bulk_req_teardown(xfd, &req->hdr, &bulkreq,
> +			sizeof(struct xfs_bstat), xfrog_bstat_ino,
> +			&req->bulkstat, sizeof(struct xfs_bulkstat),
> +			xfrog_bstat_cvt, 1, error);
> +}

What conversion is necessary here given we've done a v1 format
bulkstat?

> +/* Bulkstat a bunch of inodes.  Returns zero or a positive error code. */
> +int
> +xfrog_bulkstat(
> +	struct xfs_fd		*xfd,
> +	struct xfs_bulkstat_req	*req)
> +{
> +	int			error;
> +
> +	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V1)
> +		goto try_v1;
> +
> +	error = xfrog_bulkstat5(xfd, req);
> +	if (error == 0 || (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5))
> +		return error;
> +
> +	/* If the v5 ioctl wasn't found, we punt to v1. */
> +	switch (error) {
> +	case EOPNOTSUPP:
> +	case ENOTTY:
> +		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
> +		break;
> +	}
> +
> +try_v1:
> +	return xfrog_bulkstat1(xfd, req);
> +}

Oh, wait, "v1 emulation" is supposed to mean "use a v1 call to
return v5 format structures"? That's emulation of the _v5_ ioctl,
which kinda says to me there's some naming problems here...


> +/* Convert bulkstat (v5) to bstat (v1). */
> +void
> +xfrog_bulkstat_to_bstat(
> +	struct xfs_fd			*xfd,
> +	struct xfs_bstat		*bs1,
> +	const struct xfs_bulkstat	*bstat)

Which I read as "convert bulkstat to bulkstat" and it doesn't tell
me what is actually going on.  xfrog_bulkstat_v5_to_v1() indicates
what format conversion is actually taking place...

and um, naming the v5 field bstat, and the struct xfs_bstat field
bs1 is entirely confusing.

void
xfrog_bulkstat_v5_to_v1(
	struct xfs_fd		*xfd
	const struct xfs_bulkstat *from,
	struct xfs_bstat	*to)
{
	to->bs_ino = from->bs_ino;
....

> +{
> +	bs1->bs_ino = bstat->bs_ino;
> +	bs1->bs_mode = bstat->bs_mode;
> +	bs1->bs_nlink = bstat->bs_nlink;
> +	bs1->bs_uid = bstat->bs_uid;
> +	bs1->bs_gid = bstat->bs_gid;
> +	bs1->bs_rdev = bstat->bs_rdev;
> +	bs1->bs_blksize = bstat->bs_blksize;
> +	bs1->bs_size = bstat->bs_size;
> +	bs1->bs_atime.tv_sec = bstat->bs_atime;
> +	bs1->bs_mtime.tv_sec = bstat->bs_mtime;
> +	bs1->bs_ctime.tv_sec = bstat->bs_ctime;

What about 32 bit overflows here?

> +/* Convert bstat (v1) to bulkstat (v5). */
> +void
> +xfrog_bstat_to_bulkstat(
> +	struct xfs_fd			*xfd,
> +	struct xfs_bulkstat		*bstat,
> +	const struct xfs_bstat		*bs1)
> +{

same comments about names here.
>  
> +/* Only use v1 bulkstat/inumbers ioctls. */
> +#define XFROG_FLAG_BULKSTAT_FORCE_V1	(1 << 0)
> +
> +/* Only use v5 bulkstat/inumbers ioctls. */
> +#define XFROG_FLAG_BULKSTAT_FORCE_V5	(1 << 1)

These don't actually define what format the results are presented
in. What happens if the user wants v1 format structures but wants
the V5 ioctl to be used?

> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -50,13 +50,15 @@ static void
>  xfs_iterate_inodes_range_check(
>  	struct scrub_ctx	*ctx,
>  	struct xfs_inogrp	*inogrp,
> -	struct xfs_bstat	*bstat)
> +	struct xfs_bulkstat	*bstat)
>  {
> -	struct xfs_bstat	*bs;
> +	struct xfs_bulkstat	*bs;
>  	int			i;
>  	int			error;
>  
>  	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
> +		struct xfs_bstat bs1;
> +
>  		if (!(inogrp->xi_allocmask & (1ULL << i)))
>  			continue;
>  		if (bs->bs_ino == inogrp->xi_startino + i) {
> @@ -66,11 +68,13 @@ xfs_iterate_inodes_range_check(
>  
>  		/* Load the one inode. */
>  		error = xfrog_bulkstat_single(&ctx->mnt,
> -				inogrp->xi_startino + i, bs);
> -		if (error || bs->bs_ino != inogrp->xi_startino + i) {
> -			memset(bs, 0, sizeof(struct xfs_bstat));
> +				inogrp->xi_startino + i, &bs1);
> +		if (error || bs1.bs_ino != inogrp->xi_startino + i) {
> +			memset(bs, 0, sizeof(struct xfs_bulkstat));
>  			bs->bs_ino = inogrp->xi_startino + i;
>  			bs->bs_blksize = ctx->mnt_sv.f_frsize;
> +		} else {
> +			xfrog_bstat_to_bulkstat(&ctx->mnt, bs, &bs1);

I'm confused - why is xfrog_bulkstat_single() returning a v1 format
structure here and not using v5 format for everything?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

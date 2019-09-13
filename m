Return-Path: <SRS0=/CVM=XI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF69C4CEC6
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Sep 2019 01:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF294206A4
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Sep 2019 01:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbfIMBKl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 21:10:41 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40292 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728352AbfIMBKk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Sep 2019 21:10:40 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 46A4136196A;
        Fri, 13 Sep 2019 11:10:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i8a6e-0008TV-6v; Fri, 13 Sep 2019 11:10:36 +1000
Date:   Fri, 13 Sep 2019 11:10:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] misc: convert from XFS_IOC_FSINUMBERS to
 XFS_IOC_INUMBERS
Message-ID: <20190913011036.GX16973@dread.disaster.area>
References: <156774089024.2643497.2754524603021685770.stgit@magnolia>
 <156774092832.2643497.11735239040494298471.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156774092832.2643497.11735239040494298471.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=frpxc3HnMu-ZR7MooOwA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:35:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert all programs to use the v5 inumbers ioctl.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  io/imap.c          |   26 +++++-----
>  io/open.c          |   27 +++++++----
>  libfrog/bulkstat.c |  132 ++++++++++++++++++++++++++++++++++++++++++++++------
>  libfrog/bulkstat.h |   10 +++-
>  scrub/fscounters.c |   21 +++++---
>  scrub/inodes.c     |   36 ++++++++------
>  6 files changed, 189 insertions(+), 63 deletions(-)

....
> diff --git a/io/open.c b/io/open.c
> index e1979501..e198bcd8 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -681,39 +681,46 @@ static __u64
>  get_last_inode(void)
>  {
>  	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
> -	uint64_t		lastip = 0;
> +	struct xfs_inumbers_req	*ireq;
>  	uint32_t		lastgrp = 0;
> -	uint32_t		ocount = 0;
>  	__u64			last_ino;

	__u64			last_ino = 0;

> -	struct xfs_inogrp	igroup[IGROUP_NR];
> +
> +	ireq = xfrog_inumbers_alloc_req(IGROUP_NR, 0);
> +	if (!ireq) {
> +		perror("alloc req");
> +		return 0;
> +	}
>  
>  	for (;;) {
>  		int		ret;
>  
> -		ret = xfrog_inumbers(&xfd, &lastip, IGROUP_NR, igroup,
> -				&ocount);
> +		ret = xfrog_inumbers(&xfd, ireq);
>  		if (ret) {
>  			errno = ret;
>  			perror("XFS_IOC_FSINUMBERS");
> +			free(ireq);
>  			return 0;

			goto out;
>  		}
>  
>  		/* Did we reach the last inode? */
> -		if (ocount == 0)
> +		if (ireq->hdr.ocount == 0)
>  			break;
>  
>  		/* last inode in igroup table */
> -		lastgrp = ocount;
> +		lastgrp = ireq->hdr.ocount;
>  	}
>  
> -	if (lastgrp == 0)
> +	if (lastgrp == 0) {
> +		free(ireq);
>  		return 0;

		goto out;
> +	}
>  
>  	lastgrp--;
>  
>  	/* The last inode number in use */
> -	last_ino = igroup[lastgrp].xi_startino +
> -		  libxfs_highbit64(igroup[lastgrp].xi_allocmask);
> +	last_ino = ireq->inumbers[lastgrp].xi_startino +
> +		  libxfs_highbit64(ireq->inumbers[lastgrp].xi_allocmask);

out:
> +	free(ireq);
>  
>  	return last_ino;
>  }
> diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> index 2a70824e..748d0f32 100644
> --- a/libfrog/bulkstat.c
> +++ b/libfrog/bulkstat.c
> @@ -387,6 +387,86 @@ xfrog_bulkstat_alloc_req(
>  	return breq;
>  }
>  
> +/* Convert an inumbers (v5) struct to a inogrp (v1) struct. */
> +void
> +xfrog_inumbers_to_inogrp(
> +	struct xfs_inogrp		*ig1,
> +	const struct xfs_inumbers	*ig)
> +{
> +	ig1->xi_startino = ig->xi_startino;
> +	ig1->xi_alloccount = ig->xi_alloccount;
> +	ig1->xi_allocmask = ig->xi_allocmask;

Same thing - inumbers_v5_to_v1(from, to);

> +}
> +
> +/* Convert an inogrp (v1) struct to a inumbers (v5) struct. */
> +void
> +xfrog_inogrp_to_inumbers(
> +	struct xfs_inumbers		*ig,
> +	const struct xfs_inogrp		*ig1)

ditto.

> +{
> +	memset(ig, 0, sizeof(*ig));
> +	ig->xi_version = XFS_INUMBERS_VERSION_V1;
> +
> +	ig->xi_startino = ig1->xi_startino;
> +	ig->xi_alloccount = ig1->xi_alloccount;
> +	ig->xi_allocmask = ig1->xi_allocmask;
> +}
> +
> +static uint64_t xfrog_inum_ino(void *v1_rec)
> +{
> +	return ((struct xfs_inogrp *)v1_rec)->xi_startino;
> +}
> +
> +static void xfrog_inum_cvt(struct xfs_fd *xfd, void *v5, void *v1)
> +{
> +	xfrog_inogrp_to_inumbers(v5, v1);
> +}

what's the point of this wrapper?

> +
> +/* Query inode allocation bitmask information using v5 ioctl. */
> +static int
> +xfrog_inumbers5(
> +	struct xfs_fd		*xfd,
> +	struct xfs_inumbers_req	*req)
> +{
> +	int			ret;
> +
> +	ret = ioctl(xfd->fd, XFS_IOC_INUMBERS, req);
> +	if (ret)
> +		return errno;
> +	return 0;

negative errors.

> +}
> +
> +/* Query inode allocation bitmask information using v1 ioctl. */
> +static int
> +xfrog_inumbers1(
> +	struct xfs_fd		*xfd,
> +	struct xfs_inumbers_req	*req)
> +{
> +	struct xfs_fsop_bulkreq	bulkreq = { 0 };
> +	int			error;
> +
> +	error = xfrog_bulkstat_prep_v1_emulation(xfd);
> +	if (error)
> +		return error;
> +
> +	error = xfrog_bulk_req_setup(xfd, &req->hdr, &bulkreq,
> +			sizeof(struct xfs_inogrp));
> +	if (error == ECANCELED)
> +		goto out_teardown;
> +	if (error)
> +		return error;
> +
> +	error = ioctl(xfd->fd, XFS_IOC_FSINUMBERS, &bulkreq);
> +	if (error)
> +		error = errno;

negative errors.

> +
> +out_teardown:
> +	return xfrog_bulk_req_teardown(xfd, &req->hdr, &bulkreq,
> +			sizeof(struct xfs_inogrp), xfrog_inum_ino,
> +			&req->inumbers, sizeof(struct xfs_inumbers),
> +			xfrog_inum_cvt, 64, error);
> +}
....

>  	struct xfs_bulkstat	*bs;
> -	uint64_t		igrp_ino;
> -	uint32_t		igrplen = 0;
> +	struct xfs_inumbers	*inogrp;

Isn't that mixing v1 structure names with v5 operations? Aren't we
pulling infomration out in inode records?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

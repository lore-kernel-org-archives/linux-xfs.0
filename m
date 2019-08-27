Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFBFC3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 06:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5606B206BB
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 06:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfH0GmC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 02:42:02 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58463 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726071AbfH0GmB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 02:42:01 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5278A366D95;
        Tue, 27 Aug 2019 16:41:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2VAz-0003WH-LG; Tue, 27 Aug 2019 16:41:57 +1000
Date:   Tue, 27 Aug 2019 16:41:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] libfrog: introduce xfs_fd to wrap an fd to a file on
 an xfs filesystem
Message-ID: <20190827064157.GB1119@dread.disaster.area>
References: <156633303230.1215733.4447734852671168748.stgit@magnolia>
 <156633304473.1215733.8975368605160374407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156633304473.1215733.8975368605160374407.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=TePkaY-AX1GOuNOdnDEA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 01:30:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new "xfs_fd" context structure where we can store a file
> descriptor and all the runtime fs context (geometry, which ioctls work,
> etc.) that goes with it.  We're going to create wrappers for the
> bulkstat and inumbers ioctls in subsequent patches; and when we
> introduce the v5 bulkstat/inumbers ioctls we'll need all that context to
> downgrade gracefully on old kernels.  Start the transition by adopting
> xfs_fd natively in scrub.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/xfrog.h    |   20 ++++++++++++++++++++

naming.

>  libfrog/fsgeom.c   |   25 +++++++++++++++++++++++++
>  scrub/fscounters.c |   22 ++++++++++++----------
>  scrub/inodes.c     |   10 +++++-----
>  scrub/phase1.c     |   41 ++++++++++++++++++++---------------------
>  scrub/phase2.c     |    2 +-
>  scrub/phase3.c     |    4 ++--
>  scrub/phase4.c     |    8 ++++----
>  scrub/phase5.c     |    2 +-
>  scrub/phase6.c     |    6 +++---
>  scrub/phase7.c     |    2 +-
>  scrub/repair.c     |    4 ++--
>  scrub/scrub.c      |   12 ++++++------
>  scrub/spacemap.c   |   12 ++++++------
>  scrub/vfs.c        |    2 +-
>  scrub/xfs_scrub.h  |    7 ++++---
>  16 files changed, 113 insertions(+), 66 deletions(-)
> 
> 
> diff --git a/include/xfrog.h b/include/xfrog.h
> index 5420b47c..f3808911 100644
> --- a/include/xfrog.h
> +++ b/include/xfrog.h
> @@ -19,4 +19,24 @@
>  struct xfs_fsop_geom;
>  int xfrog_geometry(int fd, struct xfs_fsop_geom *fsgeo);
>  
> +/*
> + * Structure for recording whatever observations we want about the level of
> + * xfs runtime support for this fd.  Right now we only store the fd and fs
> + * geometry.
> + */
> +struct xfs_fd {
> +	/* ioctl file descriptor */
> +	int			fd;
> +
> +	/* filesystem geometry */
> +	struct xfs_fsop_geom	fsgeom;
> +};
> +
> +/* Static initializers */
> +#define XFS_FD_INIT(_fd)	{ .fd = (_fd), }
> +#define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)
> +
> +int xfrog_prepare_geometry(struct xfs_fd *xfd);
> +int xfrog_close(struct xfs_fd *xfd);

I'd much prefer to see these named xfd_prepare_geometry() and
xfd_close()...

>  	ci = calloc(1, sizeof(struct xfs_count_inodes) +
> -			(ctx->geo.agcount * sizeof(uint64_t)));
> +			(ctx->mnt.fsgeom.agcount * sizeof(uint64_t)));

This gets a bit verbose, but.... <shrug> .... doesn't make that much
of a mess...

Ok, apart from the naming thing, this looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

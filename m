Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2N0R5ew057602 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 19:27:11 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16EF736BDB5
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 17:30:05 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wsAbiS4m6cEXJJiR for <xfs@oss.sgi.com>;
	Tue, 22 Mar 2011 17:30:05 -0700 (PDT)
Date: Wed, 23 Mar 2011 11:30:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: add online discard support
Message-ID: <20110323003003.GG15270@dastard>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200138.024991786@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110322200138.024991786@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Mar 22, 2011 at 03:55:55PM -0400, Christoph Hellwig wrote:
> Now that we have reliably tracking of deleted extents in a transaction
> we can easily implement "online" discard support which calls
> blkdev_issue_discard once a transaction commits.
> 
> The actual discard is a two stage operation as we first have to mark
> the busy extent as not available for reuse before we can start the
> actual discard.  Note that we don't bother supporting discard for
> the non-delaylog mode.  While that would be possible with this patch
> performance is awfull, and the optimization in the next patch won't
> work as easily.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> @@ -361,13 +362,17 @@ xlog_cil_committed(
>  	int	abort)
>  {
>  	struct xfs_cil_ctx	*ctx = args;
> +	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
>  	struct xfs_busy_extent	*busyp, *n;
>  
>  	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
>  					ctx->start_lsn, abort);
>  
> -	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list)
> -		xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, busyp);
> +	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list) {
> +		if (!abort)
> +			xfs_discard_extent(mp, busyp);
> +		xfs_alloc_busy_clear(mp, busyp);
> +	}
>  
>  	spin_lock(&ctx->cil->xc_cil_lock);
>  	list_del(&ctx->committing);
> Index: xfs/fs/xfs/linux-2.6/xfs_discard.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_discard.c	2011-03-21 14:47:03.614474345 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_discard.c	2011-03-21 14:51:41.449976366 +0100
> @@ -191,3 +191,38 @@ xfs_ioc_trim(
>  		return -XFS_ERROR(EFAULT);
>  	return 0;
>  }
> +
> +int
> +xfs_discard_extent(
> +	struct xfs_mount	*mp,
> +	struct xfs_busy_extent	*busyp)
> +{
> +	struct xfs_perag	*pag;
> +	int			error = 0;
> +	xfs_daddr_t		bno;
> +	int64_t			len;
> +	bool			done  = false;
> +
> +	if ((mp->m_flags & XFS_MOUNT_DISCARD) == 0)
> +		return 0;

I'd move this check to the callers, otherwise we are going to be
doing lots of function calls in a relatively performance sensitive
loop just to run a single check when discard is not enabled...

> +
> +	bno = XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno);
> +	len = XFS_FSB_TO_BB(mp, busyp->length);
> +
> +	pag = xfs_perag_get(mp, busyp->agno);
> +	spin_lock(&pag->pagb_lock);
> +	if (!busyp->length)
> +		done = true;
> +	busyp->flags = XFS_ALLOC_BUSY_DISCARDED;
> +	spin_unlock(&pag->pagb_lock);
> +	xfs_perag_put(pag);
> +
> +	if (done)
> +		return 0;
> +
> +	error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev, bno, len,
> +				      GFP_NOFS, 0);
> +	if (error && error != EOPNOTSUPP)
> +		xfs_info(mp, "discard failed, error %d", error);

This would be more informative if it also printed the bno and len of
the discard that failed. A couple of tracepoints here (e.g.
discard_extent_issued, discard_extent_failed) could also be useful
for tracking discard operations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

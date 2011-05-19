Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4JLrlt5055946 for <xfs@oss.sgi.com>; Thu, 19 May 2011 16:53:47 -0500
Subject: Re: [PATCH 1/4] xfs: add online discard support
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110504190011.156999943@bombadil.infradead.org>
References: <20110504185513.136746538@bombadil.infradead.org>
	<20110504190011.156999943@bombadil.infradead.org>
Date: Thu, 19 May 2011 16:53:44 -0500
Message-ID: <1305842024.2825.86.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-05-04 at 14:55 -0400, Christoph Hellwig wrote:
> Now that we have reliably tracking of deleted extents in a transaction
> we can easily implement "online" discard support which calls
> blkdev_issue_discard once a transaction commits.
> 
> The actual discard is a two stage operation as we first have to mark
> the busy extent as not available for reuse before we can start the
> actual discard.  Note that we don't bother supporting discard for
> the non-delaylog mode.

Generally, this is OK--I don't really see bugs.
But I have some comments and questions.

The first is, why not support it for non-delaylog?

We have not formally deprecated that mode of operation
(though I don't have a problem with doing that).  What
I mean is, if we're going to kill off non-delaylog
we ought to announce that intention and have a plan
and schedule for when we can kill off the old code
for good.  (But that's a separate discussion...)

In any case, it looks like it would not be *that*
hard to maintain discard support.  (I haven't looked
at the follow-on patches yet though; maybe it's
harder than it seems.)
- Add a "do_discard" flag to xfs_trans_free() and pass
  !(abortflag & XFS_LI_ABORTED) from xfs_trans_committed()
  and false from all other callers.
- Add the same discard supporting code to xfs_trans_free()
  that you're adding to xlog_cil_committed().  I.e. use:
     xfs_alloc_busy_clear(tp->t_mountp, &tp->t_busy, do_discard);
     ...
     if (!list_empty(&tp->t_busy)) {
         ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
         ...
     }
  That last block could be encapsulated into a function like:
    void xfs_discard_busy(struct xfs_mount *mp, struct list_head *list);


Second, why is it a two phase operation (marking an
extent for discard, then doing all the discards at
once)?  Is it just so you can do the discards without
holding the perag lock?

Other thoughts below.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2011-05-04 20:44:30.466422727 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_super.c	2011-05-04 20:45:06.302895250 +0200
> @@ -112,6 +112,8 @@ mempool_t *xfs_ioend_pool;
>  #define MNTOPT_QUOTANOENF  "qnoenforce"	/* same as uqnoenforce */
>  #define MNTOPT_DELAYLOG   "delaylog"	/* Delayed loging enabled */
>  #define MNTOPT_NODELAYLOG "nodelaylog"	/* Delayed loging disabled */
> +#define MNTOPT_DISCARD	"discard"	/* Discard unused blocks */
> +#define MNTOPT_NODISCARD "nodiscard"	/* Do not discard unused blocks */

Alignment in this section of this file looks a bit funny.
Perhaps you could clean it up (though your options are
limited).

>  
>  /*
>   * Table driven mount option parser.

. . .

> Index: xfs/fs/xfs/xfs_log_cil.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log_cil.c	2011-05-04 20:44:30.369756584 +0200
> +++ xfs/fs/xfs/xfs_log_cil.c	2011-05-04 20:45:06.302895250 +0200

. . .

> @@ -361,18 +362,28 @@ xlog_cil_committed(
>  	int	abort)
>  {
>  	struct xfs_cil_ctx	*ctx = args;
> +	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
>  
>  	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
>  					ctx->start_lsn, abort);
>  
>  	xfs_alloc_busy_sort(&ctx->busy_extents);

I still think sorting the list belongs inside xfs_alloc_busy_clear().
I see that list_sort() is not necessarily trivial for an already
sorted list though...

> -	xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, &ctx->busy_extents);
> +	xfs_alloc_busy_clear(mp, &ctx->busy_extents,
> +			     (mp->m_flags & XFS_MOUNT_DISCARD) && !abort);
>  
>  	spin_lock(&ctx->cil->xc_cil_lock);
>  	list_del(&ctx->committing);
>  	spin_unlock(&ctx->cil->xc_cil_lock);
>  
>  	xlog_cil_free_logvec(ctx->lv_chain);
> +
> +	if (!list_empty(&ctx->busy_extents)) {
> +		ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
> +
> +		xfs_discard_extents(mp, &ctx->busy_extents);
> +		xfs_alloc_busy_clear(mp, &ctx->busy_extents, false);
> +	}
> +
>  	kmem_free(ctx);
>  }
>  
> Index: xfs/fs/xfs/linux-2.6/xfs_discard.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_discard.c	2011-05-04 20:44:30.329756801 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_discard.c	2011-05-04 20:45:06.306228566 +0200
> @@ -191,3 +191,32 @@ xfs_ioc_trim(
>  		return -XFS_ERROR(EFAULT);
>  	return 0;
>  }
> +
> +int
> +xfs_discard_extents(
> +	struct xfs_mount	*mp,
> +	struct list_head	*list)
> +{
> +	struct xfs_busy_extent	*busyp;
> +	int			error = 0;
> +
> +	list_for_each_entry(busyp, list, list) {
> +		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
> +					 busyp->length);
> +
> +		error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
> +				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
> +				XFS_FSB_TO_BB(mp, busyp->length),
> +				GFP_NOFS, 0);

		if (error == EOPNOTSUPP) {
			/*
			 * Report this once per mount point somehow?
			 * If so, turn off the mount option?
			 */
			break;
		} else if (error) {
> +		if (error && error != EOPNOTSUPP) {
> +			xfs_info(mp,
> +	 "discard failed for extent [0x%llu,%u], error %d",
> +				 (unsigned long long)busyp->bno,
> +				 busyp->length,
> +				 error);
> +			return error;
> +		}
> +	}
> +
> +	return 0;
> +}

. . .
> Index: xfs/fs/xfs/xfs_alloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_alloc.c	2011-05-04 20:44:30.386423159 +0200
> +++ xfs/fs/xfs/xfs_alloc.c	2011-05-04 20:45:11.432867459 +0200
> @@ -2610,6 +2610,18 @@ xfs_alloc_busy_update_extent(
>  	xfs_agblock_t		bend = bbno + busyp->length;
>  
>  	/*
> +	 * This extent is currently beeing discard.  Give the thread

				currently being discarded.

> +	 * performing the discard a chance to mark the extent unbusy
> +	 * and retry.
> +	 */
> +	if (busyp->flags & XFS_ALLOC_BUSY_DISCARDED) {
> +		spin_unlock(&pag->pagb_lock);
> +		delay(1);

I hate seeing calls to delay() although sometimes
it's the right thing to do...  I don't have a feel
for how long a discard is likely to take so I don't
know whether waiting here instead would be worth
the effort.

> +		spin_lock(&pag->pagb_lock);
> +		return false;
> +	}
> +
> +	/*
>  	 * If there is a busy extent overlapping a user allocation, we have
>  	 * no choice but to force the log and retry the search.
>  	 *

. . .

> Index: xfs/Documentation/filesystems/xfs.txt
> ===================================================================
> --- xfs.orig/Documentation/filesystems/xfs.txt	2011-05-04 20:44:30.409756366 +0200
> +++ xfs/Documentation/filesystems/xfs.txt	2011-05-04 20:45:06.306228566 +0200
> @@ -39,6 +39,12 @@ When mounting an XFS filesystem, the fol
>  	drive level write caching to be enabled, for devices that
>  	support write barriers.
>  
> +  discard
> +	Issue command to let the block device reclaim space freed by the
> +	filesystem.  This is useful for SSD devices, thinly provisioned
> +	LUNs and virtual machine images, but may have a performance
> +	impact.

If this option is to only be available for delaylog, it should
say so here (and maybe report that it's being ignored if it's
supplied with nodelaylog at mount time).

> +
>    dmapi
>  	Enable the DMAPI (Data Management API) event callouts.
>  	Use with the "mtpt" option.

. . .



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754427AbcJGSEI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Oct 2016 14:04:08 -0400
Date: Fri, 7 Oct 2016 14:04:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 40/63] xfs: store in-progress CoW allocations in the
 refcount btree
Message-ID: <20161007180404.GC58659@bfoster.bfoster>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520499918.29434.2773482874093907740.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520499918.29434.2773482874093907740.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 08:09:59PM -0700, Darrick J. Wong wrote:
> Due to the way the CoW algorithm in XFS works, there's an interval
> during which blocks allocated to handle a CoW can be lost -- if the FS
> goes down after the blocks are allocated but before the block
> remapping takes place.  This is exacerbated by the cowextsz hint --
> allocated reservations can sit around for a while, waiting to get
> used.
> 
> Since the refcount btree doesn't normally store records with refcount
> of 1, we can use it to record these in-progress extents.  In-progress
> blocks cannot be shared because they're not user-visible, so there
> shouldn't be any conflicts with other programs.  This is a better
> solution than holding EFIs during writeback because (a) EFIs can't be
> relogged currently, (b) even if they could, EFIs are bound by
> available log space, which puts an unnecessary upper bound on how much
> CoW we can have in flight, and (c) we already have a mechanism to
> track blocks.
> 
> At mount time, read the refcount records and free anything we find
> with a refcount of 1 because those were in-progress when the FS went
> down.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: Use the deferred operations system to avoid deadlocks and blowing
> out the transaction reservation.  This allows us to unmap a CoW
> extent from the refcountbt and into a file atomically.
> ---
>  fs/xfs/libxfs/xfs_bmap.c     |   11 +
>  fs/xfs/libxfs/xfs_format.h   |    3 
>  fs/xfs/libxfs/xfs_refcount.c |  336 +++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_refcount.h |   10 +
>  fs/xfs/xfs_mount.c           |   12 ++
>  fs/xfs/xfs_refcount_item.c   |   12 ++
>  fs/xfs/xfs_reflink.c         |  150 +++++++++++++++++++
>  fs/xfs/xfs_reflink.h         |    1 
>  fs/xfs/xfs_super.c           |    9 +
>  fs/xfs/xfs_trace.h           |    4 +
>  10 files changed, 537 insertions(+), 11 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index c95cdc3..673ecc1 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
...
> @@ -772,3 +787,138 @@ xfs_reflink_end_cow(
>  	trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
>  	return error;
>  }
...
> +STATIC int
> +xfs_reflink_recover_cow_ag(
> +	struct xfs_mount		*mp,
> +	xfs_agnumber_t			agno)
> +{
> +	struct xfs_trans		*tp;
> +	struct xfs_btree_cur		*cur;
> +	struct xfs_buf			*agbp;
> +	struct xfs_reflink_recovery	*rr, *n;
> +	struct list_head		debris;
> +	union xfs_btree_irec		low;
> +	union xfs_btree_irec		high;
> +	struct xfs_defer_ops		dfops;
> +	xfs_fsblock_t			fsb;
> +	int				error;
> +
> +	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
> +	if (error)
> +		return error;
> +	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
> +
> +	/* Find all the leftover CoW staging extents. */
> +	INIT_LIST_HEAD(&debris);
> +	memset(&low, 0, sizeof(low));
> +	memset(&high, 0, sizeof(high));
> +	low.rc.rc_startblock = 0;
> +	high.rc.rc_startblock = -1U;
> +	error = xfs_btree_query_range(cur, &low, &high,
> +			xfs_reflink_recover_extent, &debris);
> +	if (error)
> +		goto out_error;

Potential memory leak of debris list entries on error.

> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> +	xfs_buf_relse(agbp);
> +
> +	/* Now iterate the list to free the leftovers */
> +	list_for_each_entry(rr, &debris, rr_list) {
> +		/* Set up transaction. */
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
> +		if (error)
> +			goto out_free;
> +
> +		trace_xfs_reflink_recover_extent(mp, agno, &rr->rr_rrec);
> +
> +		/* Free the orphan record */
> +		xfs_defer_init(&dfops, &fsb);
> +		fsb = XFS_AGB_TO_FSB(mp, agno, rr->rr_rrec.rc_startblock);
> +		error = xfs_refcount_free_cow_extent(mp, &dfops, fsb,
> +				rr->rr_rrec.rc_blockcount);
> +		if (error)
> +			goto out_defer;
> +
> +		/* Free the block. */
> +		xfs_bmap_add_free(mp, &dfops, fsb,
> +				rr->rr_rrec.rc_blockcount, NULL);
> +
> +		error = xfs_defer_finish(&tp, &dfops, NULL);
> +		if (error)
> +			goto out_defer;
> +
> +		error = xfs_trans_commit(tp);
> +		if (error)
> +			goto out_cancel;
> +	}
> +	goto out_free;

return 0 ?

Brian

> +
> +out_defer:
> +	xfs_defer_cancel(&dfops);
> +out_cancel:
> +	xfs_trans_cancel(tp);
> +
> +out_free:
> +	/* Free the leftover list */
> +	list_for_each_entry_safe(rr, n, &debris, rr_list) {
> +		list_del(&rr->rr_list);
> +		kmem_free(rr);
> +	}
> +
> +	return error;
> +
> +out_error:
> +	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> +	xfs_buf_relse(agbp);
> +	return error;
> +}
> +
> +/*
> + * Free leftover CoW reservations that didn't get cleaned out.
> + */
> +int
> +xfs_reflink_recover_cow(
> +	struct xfs_mount	*mp)
> +{
> +	xfs_agnumber_t		agno;
> +	int			error = 0;
> +
> +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> +		return 0;
> +
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		error = xfs_reflink_recover_cow_ag(mp, agno);
> +		if (error)
> +			break;
> +	}
> +
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index c0c989a..1d2f180 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -42,5 +42,6 @@ extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t count);
>  extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t count);
> +extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
>  
>  #endif /* __XFS_REFLINK_H */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 26b45b3..e6aaa91 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1306,6 +1306,15 @@ xfs_fs_remount(
>  		xfs_restore_resvblks(mp);
>  		xfs_log_work_queue(mp);
>  		xfs_queue_eofblocks(mp);
> +
> +		/* Recover any CoW blocks that never got remapped. */
> +		error = xfs_reflink_recover_cow(mp);
> +		if (error) {
> +			xfs_err(mp,
> +	"Error %d recovering leftover CoW allocations.", error);
> +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +			return error;
> +		}
>  	}
>  
>  	/* rw -> ro */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 8e89223..ca0930b 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2916,14 +2916,18 @@ DEFINE_AG_ERROR_EVENT(xfs_refcount_update_error);
>  /* refcount adjustment tracepoints */
>  DEFINE_AG_EXTENT_EVENT(xfs_refcount_increase);
>  DEFINE_AG_EXTENT_EVENT(xfs_refcount_decrease);
> +DEFINE_AG_EXTENT_EVENT(xfs_refcount_cow_increase);
> +DEFINE_AG_EXTENT_EVENT(xfs_refcount_cow_decrease);
>  DEFINE_REFCOUNT_TRIPLE_EXTENT_EVENT(xfs_refcount_merge_center_extents);
>  DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_modify_extent);
> +DEFINE_REFCOUNT_EXTENT_EVENT(xfs_reflink_recover_extent);
>  DEFINE_REFCOUNT_EXTENT_AT_EVENT(xfs_refcount_split_extent);
>  DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_left_extent);
>  DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_right_extent);
>  DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(xfs_refcount_find_left_extent);
>  DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(xfs_refcount_find_right_extent);
>  DEFINE_AG_ERROR_EVENT(xfs_refcount_adjust_error);
> +DEFINE_AG_ERROR_EVENT(xfs_refcount_adjust_cow_error);
>  DEFINE_AG_ERROR_EVENT(xfs_refcount_merge_center_extents_error);
>  DEFINE_AG_ERROR_EVENT(xfs_refcount_modify_extent_error);
>  DEFINE_AG_ERROR_EVENT(xfs_refcount_split_extent_error);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

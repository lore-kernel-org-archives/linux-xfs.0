Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34774 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388299AbeGXOSQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jul 2018 10:18:16 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0845C402332F
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 13:11:47 +0000 (UTC)
Date: Tue, 24 Jul 2018 08:11:44 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH v2 12/15] xfs: remove all boilerplate defer init/finish
 code
Message-ID: <20180724131144.GD8459@redhat.com>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-13-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-13-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:11AM -0400, Brian Foster wrote:
> At this point, the transaction subsystem completely manages deferred
> items internally such that the common and boilerplate
> xfs_trans_alloc() -> xfs_defer_init() -> xfs_defer_finish() ->
> xfs_trans_commit() sequence can be replaced with a simple
> transaction allocation and commit.
> 
> Remove all such boilerplate deferred ops code. In doing so, we
> change each case over to use the dfops in the transaction and
> specifically eliminate:
> 
> - The on-stack dfops and associated xfs_defer_init() call, as the
>   internal dfops is initialized on transaction allocation.
> - xfs_bmap_finish() calls that precede a final xfs_trans_commit() of
>   a transaction.
> - xfs_defer_cancel() calls in error handlers that precede a
>   transaction cancel.
> 
> The only deferred ops calls that remain are those that are
> non-deterministic with respect to the final commit of the associated
> transaction or are open-coded due to special handling.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c     | 16 +-------
>  fs/xfs/libxfs/xfs_refcount.c | 10 +----
>  fs/xfs/xfs_attr_inactive.c   |  2 -
>  fs/xfs/xfs_bmap_util.c       | 43 +++-----------------
>  fs/xfs/xfs_dquot.c           |  4 --
>  fs/xfs/xfs_inode.c           | 79 ++++++------------------------------
>  fs/xfs/xfs_iomap.c           | 26 +-----------
>  fs/xfs/xfs_iops.c            |  2 -
>  fs/xfs/xfs_log_recover.c     |  8 ----
>  fs/xfs/xfs_qm_syscalls.c     |  2 -
>  fs/xfs/xfs_reflink.c         | 37 ++++++-----------
>  fs/xfs/xfs_rtalloc.c         |  9 +---
>  fs/xfs/xfs_symlink.c         | 38 ++++-------------
>  13 files changed, 44 insertions(+), 232 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7b93b1e16ad9..60138514ea86 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1019,7 +1019,6 @@ xfs_bmap_add_attrfork(
>  	int			size,		/* space new attribute needs */
>  	int			rsvd)		/* xact may use reserved blks */
>  {
> -	struct xfs_defer_ops	dfops;		/* freed extent records */
>  	xfs_mount_t		*mp;		/* mount structure */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  	int			blks;		/* space reservation */
> @@ -1038,7 +1037,6 @@ xfs_bmap_add_attrfork(
>  			rsvd ? XFS_TRANS_RESERVE : 0, &tp);
>  	if (error)
>  		return error;
> -	xfs_defer_init(tp, &dfops);
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
> @@ -1103,7 +1101,7 @@ xfs_bmap_add_attrfork(
>  	if (logflags)
>  		xfs_trans_log_inode(tp, ip, logflags);
>  	if (error)
> -		goto bmap_cancel;
> +		goto trans_cancel;
>  	if (!xfs_sb_version_hasattr(&mp->m_sb) ||
>  	   (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2)) {
>  		bool log_sb = false;
> @@ -1122,15 +1120,10 @@ xfs_bmap_add_attrfork(
>  			xfs_log_sb(tp);
>  	}
>  
> -	error = xfs_defer_finish(&tp, &dfops);
> -	if (error)
> -		goto bmap_cancel;
>  	error = xfs_trans_commit(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  
> -bmap_cancel:
> -	xfs_defer_cancel(&dfops);
>  trans_cancel:
>  	xfs_trans_cancel(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -5961,14 +5954,12 @@ xfs_bmap_split_extent(
>  {
>  	struct xfs_mount        *mp = ip->i_mount;
>  	struct xfs_trans        *tp;
> -	struct xfs_defer_ops    dfops;
>  	int                     error;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
>  			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
>  	if (error)
>  		return error;
> -	xfs_defer_init(tp, &dfops);
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> @@ -5977,14 +5968,9 @@ xfs_bmap_split_extent(
>  	if (error)
>  		goto out;
>  
> -	error = xfs_defer_finish(&tp, &dfops);
> -	if (error)
> -		goto out;
> -
>  	return xfs_trans_commit(tp);
>  
>  out:
> -	xfs_defer_cancel(&dfops);
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 2ecfb0518580..85e2d7c56c14 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1635,7 +1635,6 @@ xfs_refcount_recover_cow_leftovers(
>  	struct list_head		debris;
>  	union xfs_btree_irec		low;
>  	union xfs_btree_irec		high;
> -	struct xfs_defer_ops		dfops;
>  	xfs_fsblock_t			fsb;
>  	xfs_agblock_t			agbno;
>  	int				error;
> @@ -1691,22 +1690,17 @@ xfs_refcount_recover_cow_leftovers(
>  		trace_xfs_refcount_recover_extent(mp, agno, &rr->rr_rrec);
>  
>  		/* Free the orphan record */
> -		xfs_defer_init(tp, &dfops);
>  		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
>  		fsb = XFS_AGB_TO_FSB(mp, agno, agbno);
>  		error = xfs_refcount_free_cow_extent(mp, tp->t_dfops, fsb,
>  				rr->rr_rrec.rc_blockcount);
>  		if (error)
> -			goto out_defer;
> +			goto out_trans;
>  
>  		/* Free the block. */
>  		xfs_bmap_add_free(mp, tp->t_dfops, fsb,
>  				rr->rr_rrec.rc_blockcount, NULL);
>  
> -		error = xfs_defer_finish(&tp, tp->t_dfops);
> -		if (error)
> -			goto out_defer;
> -
>  		error = xfs_trans_commit(tp);
>  		if (error)
>  			goto out_free;
> @@ -1716,8 +1710,6 @@ xfs_refcount_recover_cow_leftovers(
>  	}
>  
>  	return error;
> -out_defer:
> -	xfs_defer_cancel(tp->t_dfops);
>  out_trans:
>  	xfs_trans_cancel(tp);
>  out_free:
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index d3055972d3a6..228821b2ebe0 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -382,7 +382,6 @@ xfs_attr_inactive(
>  {
>  	struct xfs_trans	*trans;
>  	struct xfs_mount	*mp;
> -	struct xfs_defer_ops	dfops;
>  	int			lock_mode = XFS_ILOCK_SHARED;
>  	int			error = 0;
>  
> @@ -399,7 +398,6 @@ xfs_attr_inactive(
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrinval, 0, 0, 0, &trans);
>  	if (error)
>  		goto out_destroy_fork;
> -	xfs_defer_init(trans, &dfops);
>  
>  	lock_mode = XFS_ILOCK_EXCL;
>  	xfs_ilock(dp, lock_mode);
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index ee9481b142f0..6b0f31402a81 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -792,7 +792,6 @@ xfs_free_eofblocks(
>  	int			nimaps;
>  	struct xfs_bmbt_irec	imap;
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_defer_ops	dfops;
>  
>  	/*
>  	 * Figure out if there are any blocks beyond the end
> @@ -832,7 +831,6 @@ xfs_free_eofblocks(
>  			ASSERT(XFS_FORCED_SHUTDOWN(mp));
>  			return error;
>  		}
> -		xfs_defer_init(tp, &dfops);
>  
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, 0);
> @@ -880,7 +878,6 @@ xfs_alloc_file_space(
>  	int			rt;
>  	xfs_trans_t		*tp;
>  	xfs_bmbt_irec_t		imaps[1], *imapp;
> -	struct xfs_defer_ops	dfops;
>  	uint			qblocks, resblks, resrtextents;
>  	int			error;
>  
> @@ -973,7 +970,6 @@ xfs_alloc_file_space(
>  
>  		xfs_trans_ijoin(tp, ip, 0);
>  
> -		xfs_defer_init(tp, &dfops);
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
>  					allocatesize_fsb, alloc_type, resblks,
>  					imapp, &nimaps);
> @@ -983,10 +979,6 @@ xfs_alloc_file_space(
>  		/*
>  		 * Complete the transaction
>  		 */
> -		error = xfs_defer_finish(&tp, tp->t_dfops);
> -		if (error)
> -			goto error0;
> -
>  		error = xfs_trans_commit(tp);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		if (error)
> @@ -1005,8 +997,7 @@ xfs_alloc_file_space(
>  
>  	return error;
>  
> -error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
> -	xfs_defer_cancel(&dfops);
> +error0:	/* unlock inode, unreserve quota blocks, cancel trans */
>  	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
>  
>  error1:	/* Just cancel transaction */
> @@ -1024,7 +1015,6 @@ xfs_unmap_extent(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
> -	struct xfs_defer_ops	dfops;
>  	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
>  	int			error;
>  
> @@ -1042,23 +1032,17 @@ xfs_unmap_extent(
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	xfs_defer_init(tp, &dfops);
>  	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
>  	if (error)
> -		goto out_bmap_cancel;
> +		goto out_trans_cancel;
>  
>  	xfs_defer_ijoin(tp->t_dfops, ip);
> -	error = xfs_defer_finish(&tp, tp->t_dfops);
> -	if (error)
> -		goto out_bmap_cancel;
>  
>  	error = xfs_trans_commit(tp);
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  
> -out_bmap_cancel:
> -	xfs_defer_cancel(tp->t_dfops);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  	goto out_unlock;
> @@ -1310,7 +1294,6 @@ xfs_collapse_file_space(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
>  	int			error;
> -	struct xfs_defer_ops	dfops;
>  	xfs_fileoff_t		next_fsb = XFS_B_TO_FSB(mp, offset + len);
>  	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
>  	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> @@ -1343,22 +1326,16 @@ xfs_collapse_file_space(
>  			goto out_trans_cancel;
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> -		xfs_defer_init(tp, &dfops);
>  		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
>  				&done);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  
> -		error = xfs_defer_finish(&tp, tp->t_dfops);
> -		if (error)
> -			goto out_bmap_cancel;
>  		error = xfs_trans_commit(tp);
>  	}
>  
>  	return error;
>  
> -out_bmap_cancel:
> -	xfs_defer_cancel(tp->t_dfops);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  	return error;
> @@ -1385,7 +1362,6 @@ xfs_insert_file_space(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
>  	int			error;
> -	struct xfs_defer_ops	dfops;
>  	xfs_fileoff_t		stop_fsb = XFS_B_TO_FSB(mp, offset);
>  	xfs_fileoff_t		next_fsb = NULLFSBLOCK;
>  	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
> @@ -1421,22 +1397,17 @@ xfs_insert_file_space(
>  
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> -		xfs_defer_init(tp, &dfops);
>  		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
>  				&done, stop_fsb);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  
> -		error = xfs_defer_finish(&tp, tp->t_dfops);
> -		if (error)
> -			goto out_bmap_cancel;
>  		error = xfs_trans_commit(tp);
>  	}
>  
>  	return error;
>  
> -out_bmap_cancel:
> -	xfs_defer_cancel(tp->t_dfops);
> +out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> @@ -1607,7 +1578,7 @@ xfs_swap_extent_rmap(
>  
>  		/* Unmap the old blocks in the source file. */
>  		while (tirec.br_blockcount) {
> -			xfs_defer_init(tp, tp->t_dfops);
> +			ASSERT(tp->t_firstblock == NULLFSBLOCK);
>  			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
>  
>  			/* Read extent from the source file */
> @@ -1841,7 +1812,6 @@ xfs_swap_extents(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
> -	struct xfs_defer_ops	dfops;
>  	struct xfs_bstat	*sbp = &sxp->sx_stat;
>  	int			src_log_flags, target_log_flags;
>  	int			error = 0;
> @@ -1911,7 +1881,6 @@ xfs_swap_extents(
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
>  	if (error)
>  		goto out_unlock;
> -	xfs_defer_init(tp, &dfops);
>  
>  	/*
>  	 * Lock and join the inodes to the tansaction so that transaction commit
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index c53de34c9ae5..a57d5e8c3118 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -295,8 +295,6 @@ xfs_dquot_disk_alloc(
>  
>  	trace_xfs_dqalloc(dqp);
>  
> -	xfs_defer_init(tp, tp->t_dfops);
> -
>  	xfs_ilock(quotip, XFS_ILOCK_EXCL);
>  	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
>  		/*
> @@ -538,7 +536,6 @@ xfs_qm_dqread_alloc(
>  	struct xfs_buf		**bpp)
>  {
>  	struct xfs_trans	*tp;
> -	struct xfs_defer_ops	dfops;
>  	struct xfs_buf		*bp;
>  	int			error;
>  
> @@ -546,7 +543,6 @@ xfs_qm_dqread_alloc(
>  			XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
>  	if (error)
>  		goto err;
> -	xfs_defer_init(tp, &dfops);
>  
>  	error = xfs_dquot_disk_alloc(&tp, dqp, &bp);
>  	if (error)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7d7d7e95fa17..c47183a2f167 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1142,7 +1142,6 @@ xfs_create(
>  	struct xfs_inode	*ip = NULL;
>  	struct xfs_trans	*tp = NULL;
>  	int			error;
> -	struct xfs_defer_ops	dfops;
>  	bool                    unlock_dp_on_error = false;
>  	prid_t			prid;
>  	struct xfs_dquot	*udqp = NULL;
> @@ -1194,8 +1193,6 @@ xfs_create(
>  	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
>  	unlock_dp_on_error = true;
>  
> -	xfs_defer_init(tp, &dfops);
> -
>  	/*
>  	 * Reserve disk quota and the inode.
>  	 */
> @@ -1236,11 +1233,11 @@ xfs_create(
>  	if (is_dir) {
>  		error = xfs_dir_init(tp, ip, dp);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  
>  		error = xfs_bumplink(tp, dp);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  	}
>  
>  	/*
> @@ -1258,10 +1255,6 @@ xfs_create(
>  	 */
>  	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
>  
> -	error = xfs_defer_finish(&tp, &dfops);
> -	if (error)
> -		goto out_bmap_cancel;
> -
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		goto out_release_inode;
> @@ -1273,8 +1266,6 @@ xfs_create(
>  	*ipp = ip;
>  	return 0;
>  
> - out_bmap_cancel:
> -	xfs_defer_cancel(&dfops);
>   out_trans_cancel:
>  	xfs_trans_cancel(tp);
>   out_release_inode:
> @@ -1399,7 +1390,6 @@ xfs_link(
>  	xfs_mount_t		*mp = tdp->i_mount;
>  	xfs_trans_t		*tp;
>  	int			error;
> -	struct xfs_defer_ops	dfops;
>  	int			resblks;
>  
>  	trace_xfs_link(tdp, target_name);
> @@ -1448,8 +1438,6 @@ xfs_link(
>  			goto error_return;
>  	}
>  
> -	xfs_defer_init(tp, &dfops);
> -
>  	/*
>  	 * Handle initial link state of O_TMPFILE inode
>  	 */
> @@ -1478,12 +1466,6 @@ xfs_link(
>  	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
>  		xfs_trans_set_sync(tp);
>  
> -	error = xfs_defer_finish(&tp, &dfops);
> -	if (error) {
> -		xfs_defer_cancel(&dfops);
> -		goto error_return;
> -	}
> -
>  	return xfs_trans_commit(tp);
>  
>   error_return:
> @@ -1719,7 +1701,6 @@ xfs_inactive_truncate(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
> -	struct xfs_defer_ops	dfops;
>  	int			error;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> @@ -1727,8 +1708,6 @@ xfs_inactive_truncate(
>  		ASSERT(XFS_FORCED_SHUTDOWN(mp));
>  		return error;
>  	}
> -	xfs_defer_init(tp, &dfops);
> -
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> @@ -1769,7 +1748,6 @@ STATIC int
>  xfs_inactive_ifree(
>  	struct xfs_inode *ip)
>  {
> -	struct xfs_defer_ops	dfops;
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
>  	int			error;
> @@ -1806,7 +1784,6 @@ xfs_inactive_ifree(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	xfs_defer_init(tp, &dfops);
>  	error = xfs_ifree(tp, ip);
>  	if (error) {
>  		/*
> @@ -1833,12 +1810,6 @@ xfs_inactive_ifree(
>  	 * Just ignore errors at this point.  There is nothing we can do except
>  	 * to try to keep going. Make sure it's not a silent error.
>  	 */
> -	error = xfs_defer_finish(&tp, &dfops);
> -	if (error) {
> -		xfs_notice(mp, "%s: xfs_defer_finish returned error %d",
> -			__func__, error);
> -		xfs_defer_cancel(&dfops);
> -	}
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
> @@ -2569,7 +2540,6 @@ xfs_remove(
>  	xfs_trans_t             *tp = NULL;
>  	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
>  	int                     error = 0;
> -	struct xfs_defer_ops	dfops;
>  	uint			resblks;
>  
>  	trace_xfs_remove(dp, name);
> @@ -2649,11 +2619,10 @@ xfs_remove(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	xfs_defer_init(tp, &dfops);
>  	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
>  	if (error) {
>  		ASSERT(error != -ENOENT);
> -		goto out_bmap_cancel;
> +		goto out_trans_cancel;
>  	}
>  
>  	/*
> @@ -2664,10 +2633,6 @@ xfs_remove(
>  	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
>  		xfs_trans_set_sync(tp);
>  
> -	error = xfs_defer_finish(&tp, &dfops);
> -	if (error)
> -		goto out_bmap_cancel;
> -
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		goto std_return;
> @@ -2677,8 +2642,6 @@ xfs_remove(
>  
>  	return 0;
>  
> - out_bmap_cancel:
> -	xfs_defer_cancel(&dfops);
>   out_trans_cancel:
>  	xfs_trans_cancel(tp);
>   std_return:
> @@ -2740,9 +2703,6 @@ static int
>  xfs_finish_rename(
>  	struct xfs_trans	*tp)
>  {
> -	struct xfs_defer_ops	*dfops = tp->t_dfops;
> -	int			error;
> -
>  	/*
>  	 * If this is a synchronous mount, make sure that the rename transaction
>  	 * goes to disk before returning to the user.
> @@ -2750,13 +2710,6 @@ xfs_finish_rename(
>  	if (tp->t_mountp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
>  		xfs_trans_set_sync(tp);
>  
> -	error = xfs_defer_finish(&tp, dfops);
> -	if (error) {
> -		xfs_defer_cancel(dfops);
> -		xfs_trans_cancel(tp);
> -		return error;
> -	}
> -
>  	return xfs_trans_commit(tp);
>  }
>  
> @@ -2869,7 +2822,6 @@ xfs_cross_rename(
>  	return xfs_finish_rename(tp);
>  
>  out_trans_abort:
> -	xfs_defer_cancel(tp->t_dfops);
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> @@ -2924,7 +2876,6 @@ xfs_rename(
>  {
>  	struct xfs_mount	*mp = src_dp->i_mount;
>  	struct xfs_trans	*tp;
> -	struct xfs_defer_ops	dfops;
>  	struct xfs_inode	*wip = NULL;		/* whiteout inode */
>  	struct xfs_inode	*inodes[__XFS_SORT_INODES];
>  	int			num_inodes = __XFS_SORT_INODES;
> @@ -3006,8 +2957,6 @@ xfs_rename(
>  		goto out_trans_cancel;
>  	}
>  
> -	xfs_defer_init(tp, &dfops);
> -
>  	/* RENAME_EXCHANGE is unique from here on. */
>  	if (flags & RENAME_EXCHANGE)
>  		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
> @@ -3035,7 +2984,7 @@ xfs_rename(
>  		error = xfs_dir_createname(tp, target_dp, target_name,
>  					   src_ip->i_ino, spaceres);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  
>  		xfs_trans_ichgtime(tp, target_dp,
>  					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> @@ -3043,7 +2992,7 @@ xfs_rename(
>  		if (new_parent && src_is_directory) {
>  			error = xfs_bumplink(tp, target_dp);
>  			if (error)
> -				goto out_bmap_cancel;
> +				goto out_trans_cancel;
>  		}
>  	} else { /* target_ip != NULL */
>  		/*
> @@ -3074,7 +3023,7 @@ xfs_rename(
>  		error = xfs_dir_replace(tp, target_dp, target_name,
>  					src_ip->i_ino, spaceres);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  
>  		xfs_trans_ichgtime(tp, target_dp,
>  					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> @@ -3085,7 +3034,7 @@ xfs_rename(
>  		 */
>  		error = xfs_droplink(tp, target_ip);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  
>  		if (src_is_directory) {
>  			/*
> @@ -3093,7 +3042,7 @@ xfs_rename(
>  			 */
>  			error = xfs_droplink(tp, target_ip);
>  			if (error)
> -				goto out_bmap_cancel;
> +				goto out_trans_cancel;
>  		}
>  	} /* target_ip != NULL */
>  
> @@ -3109,7 +3058,7 @@ xfs_rename(
>  					target_dp->i_ino, spaceres);
>  		ASSERT(error != -EEXIST);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  	}
>  
>  	/*
> @@ -3135,7 +3084,7 @@ xfs_rename(
>  		 */
>  		error = xfs_droplink(tp, src_dp);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  	}
>  
>  	/*
> @@ -3150,7 +3099,7 @@ xfs_rename(
>  		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
>  					   spaceres);
>  	if (error)
> -		goto out_bmap_cancel;
> +		goto out_trans_cancel;
>  
>  	/*
>  	 * For whiteouts, we need to bump the link count on the whiteout inode.
> @@ -3164,10 +3113,10 @@ xfs_rename(
>  		ASSERT(VFS_I(wip)->i_nlink == 0);
>  		error = xfs_bumplink(tp, wip);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  		error = xfs_iunlink_remove(tp, wip);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
>  
>  		/*
> @@ -3188,8 +3137,6 @@ xfs_rename(
>  		IRELE(wip);
>  	return error;
>  
> -out_bmap_cancel:
> -	xfs_defer_cancel(&dfops);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  out_release_wip:
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 756694219f77..8e8ca9f03f0e 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -157,7 +157,6 @@ xfs_iomap_write_direct(
>  	int		quota_flag;
>  	int		rt;
>  	xfs_trans_t	*tp;
> -	struct xfs_defer_ops dfops;
>  	uint		qblocks, resblks, resrtextents;
>  	int		error;
>  	int		lockmode;
> @@ -253,20 +252,15 @@ xfs_iomap_write_direct(
>  	 * From this point onwards we overwrite the imap pointer that the
>  	 * caller gave to us.
>  	 */
> -	xfs_defer_init(tp, &dfops);
>  	nimaps = 1;
>  	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
>  				bmapi_flags, resblks, imap, &nimaps);
>  	if (error)
> -		goto out_bmap_cancel;
> +		goto out_res_cancel;
>  
>  	/*
>  	 * Complete the transaction
>  	 */
> -	error = xfs_defer_finish(&tp, tp->t_dfops);
> -	if (error)
> -		goto out_bmap_cancel;
> -
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		goto out_unlock;
> @@ -286,8 +280,7 @@ xfs_iomap_write_direct(
>  	xfs_iunlock(ip, lockmode);
>  	return error;
>  
> -out_bmap_cancel:
> -	xfs_defer_cancel(tp->t_dfops);
> +out_res_cancel:
>  	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
> @@ -663,7 +656,6 @@ xfs_iomap_write_allocate(
>  	xfs_mount_t	*mp = ip->i_mount;
>  	xfs_fileoff_t	offset_fsb, last_block;
>  	xfs_fileoff_t	end_fsb, map_start_fsb;
> -	struct xfs_defer_ops	dfops;
>  	xfs_filblks_t	count_fsb;
>  	xfs_trans_t	*tp;
>  	int		nimaps;
> @@ -713,8 +705,6 @@ xfs_iomap_write_allocate(
>  			xfs_ilock(ip, XFS_ILOCK_EXCL);
>  			xfs_trans_ijoin(tp, ip, 0);
>  
> -			xfs_defer_init(tp, &dfops);
> -
>  			/*
>  			 * it is possible that the extents have changed since
>  			 * we did the read call as we dropped the ilock for a
> @@ -772,10 +762,6 @@ xfs_iomap_write_allocate(
>  			if (error)
>  				goto trans_cancel;
>  
> -			error = xfs_defer_finish(&tp, tp->t_dfops);
> -			if (error)
> -				goto trans_cancel;
> -
>  			error = xfs_trans_commit(tp);
>  			if (error)
>  				goto error0;
> @@ -806,7 +792,6 @@ xfs_iomap_write_allocate(
>  	}
>  
>  trans_cancel:
> -	xfs_defer_cancel(tp->t_dfops);
>  	xfs_trans_cancel(tp);
>  error0:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -827,7 +812,6 @@ xfs_iomap_write_unwritten(
>  	int		nimaps;
>  	xfs_trans_t	*tp;
>  	xfs_bmbt_irec_t imap;
> -	struct xfs_defer_ops dfops;
>  	struct inode	*inode = VFS_I(ip);
>  	xfs_fsize_t	i_size;
>  	uint		resblks;
> @@ -872,7 +856,6 @@ xfs_iomap_write_unwritten(
>  		/*
>  		 * Modify the unwritten extent state of the buffer.
>  		 */
> -		xfs_defer_init(tp, &dfops);
>  		nimaps = 1;
>  		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
>  					XFS_BMAPI_CONVERT, resblks, &imap,
> @@ -896,10 +879,6 @@ xfs_iomap_write_unwritten(
>  			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		}
>  
> -		error = xfs_defer_finish(&tp, tp->t_dfops);
> -		if (error)
> -			goto error_on_bmapi_transaction;
> -
>  		error = xfs_trans_commit(tp);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		if (error)
> @@ -923,7 +902,6 @@ xfs_iomap_write_unwritten(
>  	return 0;
>  
>  error_on_bmapi_transaction:
> -	xfs_defer_cancel(tp->t_dfops);
>  	xfs_trans_cancel(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 704b57a8b99e..2eac22bfad6a 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -813,7 +813,6 @@ xfs_setattr_size(
>  	struct inode		*inode = VFS_I(ip);
>  	xfs_off_t		oldsize, newsize;
>  	struct xfs_trans	*tp;
> -	struct xfs_defer_ops	dfops;
>  	int			error;
>  	uint			lock_flags = 0;
>  	bool			did_zeroing = false;
> @@ -917,7 +916,6 @@ xfs_setattr_size(
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
>  	if (error)
>  		return error;
> -	xfs_defer_init(tp, &dfops);
>  
>  	lock_flags |= XFS_ILOCK_EXCL;
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 958e9b96dc6a..265e1f561157 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4857,15 +4857,7 @@ xlog_finish_defer_ops(
>  	/* transfer all collected dfops to this transaction */
>  	xfs_defer_move(tp->t_dfops, dfops);
>  
> -	error = xfs_defer_finish(&tp, tp->t_dfops);
> -	if (error)
> -		goto out_cancel;
> -
>  	return xfs_trans_commit(tp);
> -
> -out_cancel:
> -	xfs_trans_cancel(tp);
> -	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index df0783303887..c07c5a39d516 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -214,7 +214,6 @@ xfs_qm_scall_trunc_qfile(
>  {
>  	struct xfs_inode	*ip;
>  	struct xfs_trans	*tp;
> -	struct xfs_defer_ops	dfops;
>  	int			error;
>  
>  	if (ino == NULLFSINO)
> @@ -231,7 +230,6 @@ xfs_qm_scall_trunc_qfile(
>  		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  		goto out_put;
>  	}
> -	xfs_defer_init(tp, &dfops);
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index c3f2a0d3e6f5..865ba615dd76 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -364,7 +364,6 @@ xfs_reflink_allocate_cow(
>  	xfs_fileoff_t		offset_fsb = imap->br_startoff;
>  	xfs_filblks_t		count_fsb = imap->br_blockcount;
>  	struct xfs_bmbt_irec	got;
> -	struct xfs_defer_ops	dfops;
>  	struct xfs_trans	*tp = NULL;
>  	int			nimaps, error = 0;
>  	bool			trimmed;
> @@ -424,7 +423,6 @@ xfs_reflink_allocate_cow(
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	xfs_defer_init(tp, &dfops);
>  	nimaps = 1;
>  
>  	/* Allocate the entire reservation as unwritten blocks. */
> @@ -432,15 +430,11 @@ xfs_reflink_allocate_cow(
>  			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC,
>  			resblks, imap, &nimaps);
>  	if (error)
> -		goto out_bmap_cancel;
> +		goto out_trans_cancel;
>  
>  	xfs_inode_set_cowblocks_tag(ip);
>  
>  	/* Finish up. */
> -	error = xfs_defer_finish(&tp, tp->t_dfops);
> -	if (error)
> -		goto out_bmap_cancel;
> -
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		return error;
> @@ -453,8 +447,7 @@ xfs_reflink_allocate_cow(
>  		return -ENOSPC;
>  convert:
>  	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb);
> -out_bmap_cancel:
> -	xfs_defer_cancel(tp->t_dfops);
> +out_trans_cancel:
>  	xfs_trans_unreserve_quota_nblks(tp, ip, (long)resblks, 0,
>  			XFS_QMOPT_RES_REGBLKS);
>  out:
> @@ -624,7 +617,6 @@ xfs_reflink_end_cow(
>  	struct xfs_trans		*tp;
>  	xfs_fileoff_t			offset_fsb;
>  	xfs_fileoff_t			end_fsb;
> -	struct xfs_defer_ops		dfops;
>  	int				error;
>  	unsigned int			resblks;
>  	xfs_filblks_t			rlen;
> @@ -691,11 +683,11 @@ xfs_reflink_end_cow(
>  			goto prev_extent;
>  
>  		/* Unmap the old blocks in the data fork. */
> -		xfs_defer_init(tp, &dfops);
> +		ASSERT(tp->t_dfops && tp->t_firstblock == NULLFSBLOCK);
>  		rlen = del.br_blockcount;
>  		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1);
>  		if (error)
> -			goto out_defer;
> +			goto out_cancel;
>  
>  		/* Trim the extent to whatever got unmapped. */
>  		if (rlen) {
> @@ -708,13 +700,13 @@ xfs_reflink_end_cow(
>  		error = xfs_refcount_free_cow_extent(tp->t_mountp, tp->t_dfops,
>  				del.br_startblock, del.br_blockcount);
>  		if (error)
> -			goto out_defer;
> +			goto out_cancel;
>  
>  		/* Map the new blocks into the data fork. */
>  		error = xfs_bmap_map_extent(tp->t_mountp, tp->t_dfops, ip,
>  					    &del);
>  		if (error)
> -			goto out_defer;
> +			goto out_cancel;
>  
>  		/* Charge this new data fork mapping to the on-disk quota. */
>  		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
> @@ -726,7 +718,7 @@ xfs_reflink_end_cow(
>  		xfs_defer_ijoin(tp->t_dfops, ip);
>  		error = xfs_defer_finish(&tp, tp->t_dfops);
>  		if (error)
> -			goto out_defer;
> +			goto out_cancel;
>  		if (!xfs_iext_get_extent(ifp, &icur, &got))
>  			break;
>  		continue;
> @@ -741,8 +733,6 @@ xfs_reflink_end_cow(
>  		goto out;
>  	return 0;
>  
> -out_defer:
> -	xfs_defer_cancel(tp->t_dfops);
>  out_cancel:
>  	xfs_trans_cancel(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -998,7 +988,6 @@ xfs_reflink_remap_extent(
>  	bool			real_extent = xfs_bmap_is_real_extent(irec);
>  	struct xfs_trans	*tp;
>  	unsigned int		resblks;
> -	struct xfs_defer_ops	dfops;
>  	struct xfs_bmbt_irec	uirec;
>  	xfs_filblks_t		rlen;
>  	xfs_filblks_t		unmap_len;
> @@ -1039,10 +1028,10 @@ xfs_reflink_remap_extent(
>  	/* Unmap the old blocks in the data fork. */
>  	rlen = unmap_len;
>  	while (rlen) {
> -		xfs_defer_init(tp, &dfops);
> +		ASSERT(tp->t_dfops && tp->t_firstblock == NULLFSBLOCK);
>  		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1);
>  		if (error)
> -			goto out_defer;
> +			goto out_cancel;
>  
>  		/*
>  		 * Trim the extent to whatever got unmapped.
> @@ -1063,12 +1052,12 @@ xfs_reflink_remap_extent(
>  		/* Update the refcount tree */
>  		error = xfs_refcount_increase_extent(mp, tp->t_dfops, &uirec);
>  		if (error)
> -			goto out_defer;
> +			goto out_cancel;
>  
>  		/* Map the new blocks into the data fork. */
>  		error = xfs_bmap_map_extent(mp, tp->t_dfops, ip, &uirec);
>  		if (error)
> -			goto out_defer;
> +			goto out_cancel;
>  
>  		/* Update quota accounting. */
>  		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
> @@ -1090,7 +1079,7 @@ xfs_reflink_remap_extent(
>  		xfs_defer_ijoin(tp->t_dfops, ip);
>  		error = xfs_defer_finish(&tp, tp->t_dfops);
>  		if (error)
> -			goto out_defer;
> +			goto out_cancel;
>  	}
>  
>  	error = xfs_trans_commit(tp);
> @@ -1099,8 +1088,6 @@ xfs_reflink_remap_extent(
>  		goto out;
>  	return 0;
>  
> -out_defer:
> -	xfs_defer_cancel(tp->t_dfops);
>  out_cancel:
>  	xfs_trans_cancel(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index bc471d42a968..86d7d2f76226 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -761,7 +761,6 @@ xfs_growfs_rt_alloc(
>  	struct xfs_buf		*bp;	/* temporary buffer for zeroing */
>  	xfs_daddr_t		d;		/* disk block address */
>  	int			error;		/* error return value */
> -	struct xfs_defer_ops	dfops;		/* list of freed blocks */
>  	xfs_fsblock_t		fsbno;		/* filesystem block for bno */
>  	struct xfs_bmbt_irec	map;		/* block map output */
>  	int			nmap;		/* number of block maps */
> @@ -786,7 +785,6 @@ xfs_growfs_rt_alloc(
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> -		xfs_defer_init(tp, &dfops);
>  		/*
>  		 * Allocate blocks to the bitmap file.
>  		 */
> @@ -797,13 +795,10 @@ xfs_growfs_rt_alloc(
>  		if (!error && nmap < 1)
>  			error = -ENOSPC;
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  		/*
>  		 * Free any blocks freed up in the transaction, then commit.
>  		 */
> -		error = xfs_defer_finish(&tp, tp->t_dfops);
> -		if (error)
> -			goto out_bmap_cancel;
>  		error = xfs_trans_commit(tp);
>  		if (error)
>  			return error;
> @@ -853,8 +848,6 @@ xfs_growfs_rt_alloc(
>  
>  	return 0;
>  
> -out_bmap_cancel:
> -	xfs_defer_cancel(tp->t_dfops);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  	return error;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index d1ab0afa2723..ce801aedbcdc 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -163,7 +163,6 @@ xfs_symlink(
>  	struct xfs_inode	*ip = NULL;
>  	int			error = 0;
>  	int			pathlen;
> -	struct xfs_defer_ops	dfops;
>  	bool                    unlock_dp_on_error = false;
>  	xfs_fileoff_t		first_fsb;
>  	xfs_filblks_t		fs_blocks;
> @@ -241,12 +240,6 @@ xfs_symlink(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	/*
> -	 * Initialize the bmap freelist prior to calling either
> -	 * bmapi or the directory create code.
> -	 */
> -	xfs_defer_init(tp, &dfops);
> -
>  	/*
>  	 * Allocate an inode for the symlink.
>  	 */
> @@ -290,7 +283,7 @@ xfs_symlink(
>  		error = xfs_bmapi_write(tp, ip, first_fsb, fs_blocks,
>  				  XFS_BMAPI_METADATA, resblks, mval, &nmaps);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out_trans_cancel;
>  
>  		if (resblks)
>  			resblks -= fs_blocks;
> @@ -308,7 +301,7 @@ xfs_symlink(
>  					       BTOBB(byte_cnt), 0);
>  			if (!bp) {
>  				error = -ENOMEM;
> -				goto out_bmap_cancel;
> +				goto out_trans_cancel;
>  			}
>  			bp->b_ops = &xfs_symlink_buf_ops;
>  
> @@ -337,7 +330,7 @@ xfs_symlink(
>  	 */
>  	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
>  	if (error)
> -		goto out_bmap_cancel;
> +		goto out_trans_cancel;
>  	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
>  
> @@ -350,10 +343,6 @@ xfs_symlink(
>  		xfs_trans_set_sync(tp);
>  	}
>  
> -	error = xfs_defer_finish(&tp, tp->t_dfops);
> -	if (error)
> -		goto out_bmap_cancel;
> -
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		goto out_release_inode;
> @@ -365,8 +354,6 @@ xfs_symlink(
>  	*ipp = ip;
>  	return 0;
>  
> -out_bmap_cancel:
> -	xfs_defer_cancel(tp->t_dfops);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  out_release_inode:
> @@ -399,7 +386,6 @@ xfs_inactive_symlink_rmt(
>  	xfs_buf_t	*bp;
>  	int		done;
>  	int		error;
> -	struct xfs_defer_ops	dfops;
>  	int		i;
>  	xfs_mount_t	*mp;
>  	xfs_bmbt_irec_t	mval[XFS_SYMLINK_MAPS];
> @@ -438,7 +424,6 @@ xfs_inactive_symlink_rmt(
>  	 * Find the block(s) so we can inval and unmap them.
>  	 */
>  	done = 0;
> -	xfs_defer_init(tp, &dfops);
>  	nmaps = ARRAY_SIZE(mval);
>  	error = xfs_bmapi_read(ip, 0, xfs_symlink_blocks(mp, size),
>  				mval, &nmaps, 0);
> @@ -453,7 +438,7 @@ xfs_inactive_symlink_rmt(
>  			XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0);
>  		if (!bp) {
>  			error = -ENOMEM;
> -			goto error_bmap_cancel;
> +			goto error_trans_cancel;
>  		}
>  		xfs_trans_binval(tp, bp);
>  	}
> @@ -462,19 +447,14 @@ xfs_inactive_symlink_rmt(
>  	 */
>  	error = xfs_bunmapi(tp, ip, 0, size, 0, nmaps, &done);
>  	if (error)
> -		goto error_bmap_cancel;
> +		goto error_trans_cancel;
>  	ASSERT(done);
> -	/*
> -	 * Commit the first transaction.  This logs the EFI and the inode.
> -	 */
> -	xfs_defer_ijoin(tp->t_dfops, ip);
> -	error = xfs_defer_finish(&tp, tp->t_dfops);
> -	if (error)
> -		goto error_bmap_cancel;
>  
>  	/*
> -	 * Commit the transaction containing extent freeing and EFDs.
> +	 * Commit the transaction. This first logs the EFI and the inode, then
> +	 * rolls and commits the transaction that frees the extents.
>  	 */
> +	xfs_defer_ijoin(tp->t_dfops, ip);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	error = xfs_trans_commit(tp);
>  	if (error) {
> @@ -492,8 +472,6 @@ xfs_inactive_symlink_rmt(
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return 0;
>  
> -error_bmap_cancel:
> -	xfs_defer_cancel(tp->t_dfops);
>  error_trans_cancel:
>  	xfs_trans_cancel(tp);
>  error_unlock:
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

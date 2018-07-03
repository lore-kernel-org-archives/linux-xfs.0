Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56036 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753105AbeGCV0s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 17:26:48 -0400
Date: Tue, 3 Jul 2018 14:26:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 24/24] xfs: refactor dfops init to attach to transaction
Message-ID: <20180703212632.GT32415@magnolia>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-25-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-25-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:36PM -0400, Brian Foster wrote:
> Most callers of xfs_defer_init() immediately attach the dfops
> structure to a transaction. Add a transaction parameter to eliminate
> much of this boilerplate code. This also helps self-document the
> fact that many codepaths now expect a dfops pointer implicitly via
> xfs_trans->t_dfops.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        | 26 ++++++++++++++------------
>  fs/xfs/libxfs/xfs_attr_remote.c |  6 +++---
>  fs/xfs/libxfs/xfs_bmap.c        |  6 ++----
>  fs/xfs/libxfs/xfs_defer.c       |  9 ++++++++-
>  fs/xfs/libxfs/xfs_defer.h       |  3 ++-
>  fs/xfs/libxfs/xfs_refcount.c    |  3 +--
>  fs/xfs/xfs_bmap_util.c          | 17 ++++++-----------
>  fs/xfs/xfs_dquot.c              |  5 ++---
>  fs/xfs/xfs_inode.c              | 18 ++++++------------
>  fs/xfs/xfs_iomap.c              |  9 +++------
>  fs/xfs/xfs_log_recover.c        |  2 +-
>  fs/xfs/xfs_reflink.c            | 12 ++++--------
>  fs/xfs/xfs_rtalloc.c            |  3 +--
>  fs/xfs/xfs_symlink.c            |  6 ++----
>  14 files changed, 55 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a14ab9b2669e..8a7e2c0308c4 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -253,8 +253,7 @@ xfs_attr_set(
>  			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
>  	if (error)
>  		return error;
> -	xfs_defer_init(&dfops, &firstblock);
> -	args.trans->t_dfops = &dfops;
> +	xfs_defer_init(args.trans, &dfops, &firstblock);
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
>  	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
> @@ -428,8 +427,7 @@ xfs_attr_remove(
>  			&args.trans);
>  	if (error)
>  		return error;
> -	xfs_defer_init(&dfops, &firstblock);
> -	args.trans->t_dfops = &dfops;
> +	xfs_defer_init(args.trans, &dfops, &firstblock);
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
>  	/*
> @@ -600,7 +598,7 @@ xfs_attr_leaf_addname(
>  		 * Commit that transaction so that the node_addname() call
>  		 * can manage its own transactions.
>  		 */
> -		xfs_defer_init(args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -689,7 +687,8 @@ xfs_attr_leaf_addname(
>  		 * If the result is small enough, shrink it all into the inode.
>  		 */
>  		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			xfs_defer_init(args->trans->t_dfops, args->firstblock);
> +			xfs_defer_init(NULL, args->trans->t_dfops,
> +				       args->firstblock);
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
> @@ -754,7 +753,7 @@ xfs_attr_leaf_removename(
>  	 * If the result is small enough, shrink it all into the inode.
>  	 */
>  	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -		xfs_defer_init(args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
>  		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (error)
> @@ -883,7 +882,8 @@ xfs_attr_node_addname(
>  			 */
>  			xfs_da_state_free(state);
>  			state = NULL;
> -			xfs_defer_init(args->trans->t_dfops, args->firstblock);
> +			xfs_defer_init(NULL, args->trans->t_dfops,
> +				       args->firstblock);
>  			error = xfs_attr3_leaf_to_node(args);
>  			if (error)
>  				goto out_defer_cancel;
> @@ -910,7 +910,7 @@ xfs_attr_node_addname(
>  		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
>  		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
>  		 */
> -		xfs_defer_init(args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
>  		error = xfs_da3_split(state);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -1008,7 +1008,8 @@ xfs_attr_node_addname(
>  		 * Check to see if the tree needs to be collapsed.
>  		 */
>  		if (retval && (state->path.active > 1)) {
> -			xfs_defer_init(args->trans->t_dfops, args->firstblock);
> +			xfs_defer_init(NULL, args->trans->t_dfops,
> +				       args->firstblock);
>  			error = xfs_da3_join(state);
>  			if (error)
>  				goto out_defer_cancel;
> @@ -1133,7 +1134,7 @@ xfs_attr_node_removename(
>  	 * Check to see if the tree needs to be collapsed.
>  	 */
>  	if (retval && (state->path.active > 1)) {
> -		xfs_defer_init(args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
>  		error = xfs_da3_join(state);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -1165,7 +1166,8 @@ xfs_attr_node_removename(
>  			goto out;
>  
>  		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			xfs_defer_init(args->trans->t_dfops, args->firstblock);
> +			xfs_defer_init(NULL, args->trans->t_dfops,
> +				       args->firstblock);
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 179259fd1b5e..ab7c2755ad8c 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -480,7 +480,7 @@ xfs_attr_rmtval_set(
>  		 * extent and then crash then the block may not contain the
>  		 * correct metadata after log recovery occurs.
>  		 */
> -		xfs_defer_init(args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
>  		nmap = 1;
>  		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
>  				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
> @@ -522,7 +522,7 @@ xfs_attr_rmtval_set(
>  
>  		ASSERT(blkcnt > 0);
>  
> -		xfs_defer_init(args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
>  		nmap = 1;
>  		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
>  				       blkcnt, &map, &nmap,
> @@ -626,7 +626,7 @@ xfs_attr_rmtval_remove(
>  	blkcnt = args->rmtblkcnt;
>  	done = 0;
>  	while (!done) {
> -		xfs_defer_init(args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
>  		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>  				    XFS_BMAPI_ATTRFORK, 1, args->firstblock,
>  				    &done);
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6b749c1f5c4e..2e2a9661600b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1050,8 +1050,7 @@ xfs_bmap_add_attrfork(
>  			rsvd ? XFS_TRANS_RESERVE : 0, &tp);
>  	if (error)
>  		return error;
> -	xfs_defer_init(&dfops, &firstblock);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &firstblock);
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
> @@ -6027,8 +6026,7 @@ xfs_bmap_split_extent(
>  			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
>  	if (error)
>  		return error;
> -	xfs_defer_init(&dfops, &firstfsb);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &firstfsb);
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 560a7d178c1e..6b25a9436829 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -523,12 +523,19 @@ xfs_defer_init_op_type(
>  /* Initialize a deferred operation. */
>  void
>  xfs_defer_init(
> +	struct xfs_trans		*tp,
>  	struct xfs_defer_ops		*dop,
>  	xfs_fsblock_t			*fbp)
>  {
> +	struct xfs_mount		*mp = NULL;
> +
>  	memset(dop, 0, sizeof(struct xfs_defer_ops));
>  	*fbp = NULLFSBLOCK;
>  	INIT_LIST_HEAD(&dop->dop_intake);
>  	INIT_LIST_HEAD(&dop->dop_pending);
> -	trace_xfs_defer_init(NULL, dop, _RET_IP_);
> +	if (tp) {
> +		tp->t_dfops = dop;
> +		mp = tp->t_mountp;
> +	}
> +	trace_xfs_defer_init(mp, dop, _RET_IP_);
>  }
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index a02b2b748b6d..56eaaac31df5 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -63,7 +63,8 @@ void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
>  		struct list_head *h);
>  int xfs_defer_finish(struct xfs_trans **tp, struct xfs_defer_ops *dop);
>  void xfs_defer_cancel(struct xfs_defer_ops *dop);
> -void xfs_defer_init(struct xfs_defer_ops *dop, xfs_fsblock_t *fbp);
> +void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop,
> +		    xfs_fsblock_t *fbp);
>  bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
>  int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
>  int xfs_defer_bjoin(struct xfs_defer_ops *dop, struct xfs_buf *bp);
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index df67821fb5f4..8dc380574cd8 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1691,8 +1691,7 @@ xfs_refcount_recover_cow_leftovers(
>  		trace_xfs_refcount_recover_extent(mp, agno, &rr->rr_rrec);
>  
>  		/* Free the orphan record */
> -		xfs_defer_init(&dfops, &fsb);
> -		tp->t_dfops = &dfops;
> +		xfs_defer_init(tp, &dfops, &fsb);
>  		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
>  		fsb = XFS_AGB_TO_FSB(mp, agno, agbno);
>  		error = xfs_refcount_free_cow_extent(mp, tp->t_dfops, fsb,
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 4fdf013603ab..aea33d526db2 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -971,8 +971,7 @@ xfs_alloc_file_space(
>  
>  		xfs_trans_ijoin(tp, ip, 0);
>  
> -		xfs_defer_init(&dfops, &firstfsb);
> -		tp->t_dfops = &dfops;
> +		xfs_defer_init(tp, &dfops, &firstfsb);
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
>  					allocatesize_fsb, alloc_type, &firstfsb,
>  					resblks, imapp, &nimaps);
> @@ -1042,8 +1041,7 @@ xfs_unmap_extent(
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	xfs_defer_init(&dfops, &firstfsb);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &firstfsb);
>  	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, &firstfsb,
>  			    done);
>  	if (error)
> @@ -1346,8 +1344,7 @@ xfs_collapse_file_space(
>  			goto out_trans_cancel;
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> -		xfs_defer_init(&dfops, &first_block);
> -		tp->t_dfops = &dfops;
> +		xfs_defer_init(tp, &dfops, &first_block);
>  		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
>  				&done, &first_block);
>  		if (error)
> @@ -1426,8 +1423,7 @@ xfs_insert_file_space(
>  
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> -		xfs_defer_init(&dfops, &first_block);
> -		tp->t_dfops = &dfops;
> +		xfs_defer_init(tp, &dfops, &first_block);
>  		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
>  				&done, stop_fsb, &first_block);
>  		if (error)
> @@ -1614,7 +1610,7 @@ xfs_swap_extent_rmap(
>  
>  		/* Unmap the old blocks in the source file. */
>  		while (tirec.br_blockcount) {
> -			xfs_defer_init(tp->t_dfops, &firstfsb);
> +			xfs_defer_init(tp, tp->t_dfops, &firstfsb);
>  			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
>  
>  			/* Read extent from the source file */
> @@ -1919,8 +1915,7 @@ xfs_swap_extents(
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
>  	if (error)
>  		goto out_unlock;
> -	xfs_defer_init(&dfops, &firstfsb);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &firstfsb);
>  
>  	/*
>  	 * Lock and join the inodes to the tansaction so that transaction commit
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 1ef38e1df679..c698e7f6f744 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -296,7 +296,7 @@ xfs_dquot_disk_alloc(
>  
>  	trace_xfs_dqalloc(dqp);
>  
> -	xfs_defer_init(tp->t_dfops, &firstblock);
> +	xfs_defer_init(tp, tp->t_dfops, &firstblock);
>  
>  	xfs_ilock(quotip, XFS_ILOCK_EXCL);
>  	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
> @@ -549,8 +549,7 @@ xfs_qm_dqread_alloc(
>  			XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
>  	if (error)
>  		goto err;
> -	xfs_defer_init(&dfops, &firstblock);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &firstblock);
>  
>  	error = xfs_dquot_disk_alloc(&tp, dqp, &bp);
>  	if (error)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f456df2e1394..04e17234e5d7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1195,8 +1195,7 @@ xfs_create(
>  	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
>  	unlock_dp_on_error = true;
>  
> -	xfs_defer_init(&dfops, &first_block);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &first_block);
>  
>  	/*
>  	 * Reserve disk quota and the inode.
> @@ -1451,8 +1450,7 @@ xfs_link(
>  			goto error_return;
>  	}
>  
> -	xfs_defer_init(&dfops, &first_block);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &first_block);
>  
>  	/*
>  	 * Handle initial link state of O_TMPFILE inode
> @@ -1584,8 +1582,7 @@ xfs_itruncate_extents_flags(
>  	ASSERT(first_unmap_block < last_block);
>  	unmap_len = last_block - first_unmap_block + 1;
>  	while (!done) {
> -		xfs_defer_init(&dfops, &first_block);
> -		tp->t_dfops = &dfops;
> +		xfs_defer_init(tp, &dfops, &first_block);
>  		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
>  				    XFS_ITRUNC_MAX_EXTENTS, &first_block,
>  				    &done);
> @@ -1816,8 +1813,7 @@ xfs_inactive_ifree(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	xfs_defer_init(&dfops, &first_block);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &first_block);
>  	error = xfs_ifree(tp, ip);
>  	if (error) {
>  		/*
> @@ -2661,8 +2657,7 @@ xfs_remove(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	xfs_defer_init(&dfops, &first_block);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &first_block);
>  	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &first_block,
>  				   resblks);
>  	if (error) {
> @@ -3026,8 +3021,7 @@ xfs_rename(
>  		goto out_trans_cancel;
>  	}
>  
> -	xfs_defer_init(&dfops, &first_block);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &first_block);
>  
>  	/* RENAME_EXCHANGE is unique from here on. */
>  	if (flags & RENAME_EXCHANGE)
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 1b3177ee6896..c9b9c7984f95 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -254,8 +254,7 @@ xfs_iomap_write_direct(
>  	 * From this point onwards we overwrite the imap pointer that the
>  	 * caller gave to us.
>  	 */
> -	xfs_defer_init(&dfops, &firstfsb);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &firstfsb);
>  	nimaps = 1;
>  	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
>  				bmapi_flags, &firstfsb, resblks, imap,
> @@ -717,8 +716,7 @@ xfs_iomap_write_allocate(
>  			xfs_ilock(ip, XFS_ILOCK_EXCL);
>  			xfs_trans_ijoin(tp, ip, 0);
>  
> -			xfs_defer_init(&dfops, &first_block);
> -			tp->t_dfops = &dfops;
> +			xfs_defer_init(tp, &dfops, &first_block);
>  
>  			/*
>  			 * it is possible that the extents have changed since
> @@ -878,8 +876,7 @@ xfs_iomap_write_unwritten(
>  		/*
>  		 * Modify the unwritten extent state of the buffer.
>  		 */
> -		xfs_defer_init(&dfops, &firstfsb);
> -		tp->t_dfops = &dfops;
> +		xfs_defer_init(tp, &dfops, &firstfsb);
>  		nimaps = 1;
>  		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
>  					XFS_BMAPI_CONVERT, &firstfsb, resblks,
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index b181b5f57a19..940eb30e0271 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4902,7 +4902,7 @@ xlog_recover_process_intents(
>  #if defined(DEBUG) || defined(XFS_WARN)
>  	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
>  #endif
> -	xfs_defer_init(&dfops, &firstfsb);
> +	xfs_defer_init(NULL, &dfops, &firstfsb);
>  	while (lip != NULL) {
>  		/*
>  		 * We're done when we see something other than an intent.
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 75a99bb020e4..8496312dde6a 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -428,8 +428,7 @@ xfs_reflink_allocate_cow(
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	xfs_defer_init(&dfops, &first_block);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &first_block);
>  	nimaps = 1;
>  
>  	/* Allocate the entire reservation as unwritten blocks. */
> @@ -580,8 +579,7 @@ xfs_reflink_cancel_cow_blocks(
>  			if (error)
>  				break;
>  		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
> -			xfs_defer_init(&dfops, &firstfsb);
> -			(*tpp)->t_dfops = &dfops;
> +			xfs_defer_init(*tpp, &dfops, &firstfsb);
>  
>  			/* Free the CoW orphan record. */
>  			error = xfs_refcount_free_cow_extent(ip->i_mount,
> @@ -764,8 +762,7 @@ xfs_reflink_end_cow(
>  			goto prev_extent;
>  
>  		/* Unmap the old blocks in the data fork. */
> -		xfs_defer_init(&dfops, &firstfsb);
> -		tp->t_dfops = &dfops;
> +		xfs_defer_init(tp, &dfops, &firstfsb);
>  		rlen = del.br_blockcount;
>  		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1,
>  				&firstfsb);
> @@ -1115,8 +1112,7 @@ xfs_reflink_remap_extent(
>  	/* Unmap the old blocks in the data fork. */
>  	rlen = unmap_len;
>  	while (rlen) {
> -		xfs_defer_init(&dfops, &firstfsb);
> -		tp->t_dfops = &dfops;
> +		xfs_defer_init(tp, &dfops, &firstfsb);
>  		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1, &firstfsb);
>  		if (error)
>  			goto out_defer;
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 1c7d1238ff3b..c102b0d26bc1 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -787,8 +787,7 @@ xfs_growfs_rt_alloc(
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> -		xfs_defer_init(&dfops, &firstblock);
> -		tp->t_dfops = &dfops;
> +		xfs_defer_init(tp, &dfops, &firstblock);
>  		/*
>  		 * Allocate blocks to the bitmap file.
>  		 */
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index a54f095c1409..e50e97308f81 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -246,8 +246,7 @@ xfs_symlink(
>  	 * Initialize the bmap freelist prior to calling either
>  	 * bmapi or the directory create code.
>  	 */
> -	xfs_defer_init(&dfops, &first_block);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &first_block);
>  
>  	/*
>  	 * Allocate an inode for the symlink.
> @@ -443,8 +442,7 @@ xfs_inactive_symlink_rmt(
>  	 * Find the block(s) so we can inval and unmap them.
>  	 */
>  	done = 0;
> -	xfs_defer_init(&dfops, &first_block);
> -	tp->t_dfops = &dfops;
> +	xfs_defer_init(tp, &dfops, &first_block);
>  	nmaps = ARRAY_SIZE(mval);
>  	error = xfs_bmapi_read(ip, 0, xfs_symlink_blocks(mp, size),
>  				mval, &nmaps, 0);
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

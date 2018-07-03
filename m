Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934302AbeGCRXX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:23 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 56EB434706
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:22 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4142F1117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 25/25] xfs: remove xfs_defer_init() firstblock param
Date: Tue,  3 Jul 2018 13:23:19 -0400
Message-Id: <20180703172319.24509-26-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All but one caller of xfs_defer_init() passes in the ->t_firstblock
of the associated transaction. The one outlier is
xlog_recover_process_intents(), which simply passes a dummy value
because a valid pointer is required. This firstblock variable can
simply be removed.

At this point we could remove the xfs_defer_init() firstblock
parameter and initialize ->t_firstblock directly. Even that is not
necessary, however, because ->t_firstblock is automatically
reinitialized in the new transaction on a transaction roll. Since
xfs_defer_init() should never occur more than once on a particular
transaction (since the corresponding finish will roll it), replace
the reinit from xfs_defer_init() with an assert that verifies the
transaction has a NULLFSBLOCK firstblock.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 28 ++++++++++------------------
 fs/xfs/libxfs/xfs_attr_remote.c |  9 +++------
 fs/xfs/libxfs/xfs_bmap.c        |  4 ++--
 fs/xfs/libxfs/xfs_defer.c       |  5 ++---
 fs/xfs/libxfs/xfs_defer.h       |  3 +--
 fs/xfs/libxfs/xfs_refcount.c    |  2 +-
 fs/xfs/xfs_bmap_util.c          | 12 ++++++------
 fs/xfs/xfs_dquot.c              |  4 ++--
 fs/xfs/xfs_inode.c              | 12 ++++++------
 fs/xfs/xfs_iomap.c              |  6 +++---
 fs/xfs/xfs_log_recover.c        |  3 +--
 fs/xfs/xfs_reflink.c            |  8 ++++----
 fs/xfs/xfs_rtalloc.c            |  2 +-
 fs/xfs/xfs_symlink.c            |  4 ++--
 14 files changed, 44 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 153d2e29f872..927d4c968f9a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -251,7 +251,7 @@ xfs_attr_set(
 			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
 	if (error)
 		return error;
-	xfs_defer_init(args.trans, &dfops, &args.trans->t_firstblock);
+	xfs_defer_init(args.trans, &dfops);
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
@@ -422,7 +422,7 @@ xfs_attr_remove(
 			&args.trans);
 	if (error)
 		return error;
-	xfs_defer_init(args.trans, &dfops, &args.trans->t_firstblock);
+	xfs_defer_init(args.trans, &dfops);
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	/*
@@ -593,8 +593,7 @@ xfs_attr_leaf_addname(
 		 * Commit that transaction so that the node_addname() call
 		 * can manage its own transactions.
 		 */
-		xfs_defer_init(args->trans, args->trans->t_dfops,
-			       &args->trans->t_firstblock);
+		xfs_defer_init(args->trans, args->trans->t_dfops);
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			goto out_defer_cancel;
@@ -683,8 +682,7 @@ xfs_attr_leaf_addname(
 		 * If the result is small enough, shrink it all into the inode.
 		 */
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			xfs_defer_init(args->trans, args->trans->t_dfops,
-				       &args->trans->t_firstblock);
+			xfs_defer_init(args->trans, args->trans->t_dfops);
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
@@ -749,8 +747,7 @@ xfs_attr_leaf_removename(
 	 * If the result is small enough, shrink it all into the inode.
 	 */
 	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-		xfs_defer_init(args->trans, args->trans->t_dfops,
-			       &args->trans->t_firstblock);
+		xfs_defer_init(args->trans, args->trans->t_dfops);
 		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
@@ -879,8 +876,7 @@ xfs_attr_node_addname(
 			 */
 			xfs_da_state_free(state);
 			state = NULL;
-			xfs_defer_init(args->trans, args->trans->t_dfops,
-				       &args->trans->t_firstblock);
+			xfs_defer_init(args->trans, args->trans->t_dfops);
 			error = xfs_attr3_leaf_to_node(args);
 			if (error)
 				goto out_defer_cancel;
@@ -907,8 +903,7 @@ xfs_attr_node_addname(
 		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
 		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
 		 */
-		xfs_defer_init(args->trans, args->trans->t_dfops,
-			       &args->trans->t_firstblock);
+		xfs_defer_init(args->trans, args->trans->t_dfops);
 		error = xfs_da3_split(state);
 		if (error)
 			goto out_defer_cancel;
@@ -1006,8 +1001,7 @@ xfs_attr_node_addname(
 		 * Check to see if the tree needs to be collapsed.
 		 */
 		if (retval && (state->path.active > 1)) {
-			xfs_defer_init(args->trans, args->trans->t_dfops,
-				       &args->trans->t_firstblock);
+			xfs_defer_init(args->trans, args->trans->t_dfops);
 			error = xfs_da3_join(state);
 			if (error)
 				goto out_defer_cancel;
@@ -1132,8 +1126,7 @@ xfs_attr_node_removename(
 	 * Check to see if the tree needs to be collapsed.
 	 */
 	if (retval && (state->path.active > 1)) {
-		xfs_defer_init(args->trans, args->trans->t_dfops,
-			       &args->trans->t_firstblock);
+		xfs_defer_init(args->trans, args->trans->t_dfops);
 		error = xfs_da3_join(state);
 		if (error)
 			goto out_defer_cancel;
@@ -1165,8 +1158,7 @@ xfs_attr_node_removename(
 			goto out;
 
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			xfs_defer_init(args->trans, args->trans->t_dfops,
-				       &args->trans->t_firstblock);
+			xfs_defer_init(args->trans, args->trans->t_dfops);
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index f02c705965ff..7841e6255129 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -480,8 +480,7 @@ xfs_attr_rmtval_set(
 		 * extent and then crash then the block may not contain the
 		 * correct metadata after log recovery occurs.
 		 */
-		xfs_defer_init(args->trans, args->trans->t_dfops,
-			       &args->trans->t_firstblock);
+		xfs_defer_init(args->trans, args->trans->t_dfops);
 		nmap = 1;
 		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
 				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
@@ -523,8 +522,7 @@ xfs_attr_rmtval_set(
 
 		ASSERT(blkcnt > 0);
 
-		xfs_defer_init(args->trans, args->trans->t_dfops,
-			       &args->trans->t_firstblock);
+		xfs_defer_init(args->trans, args->trans->t_dfops);
 		nmap = 1;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
 				       blkcnt, &map, &nmap,
@@ -628,8 +626,7 @@ xfs_attr_rmtval_remove(
 	blkcnt = args->rmtblkcnt;
 	done = 0;
 	while (!done) {
-		xfs_defer_init(args->trans, args->trans->t_dfops,
-			       &args->trans->t_firstblock);
+		xfs_defer_init(args->trans, args->trans->t_dfops);
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK, 1, &done);
 		if (error)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1955b8410410..c7f7ef43d032 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1038,7 +1038,7 @@ xfs_bmap_add_attrfork(
 			rsvd ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
 		return error;
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
@@ -5970,7 +5970,7 @@ xfs_bmap_split_extent(
 			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
 	if (error)
 		return error;
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 6b25a9436829..2713e2d808a7 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -524,16 +524,15 @@ xfs_defer_init_op_type(
 void
 xfs_defer_init(
 	struct xfs_trans		*tp,
-	struct xfs_defer_ops		*dop,
-	xfs_fsblock_t			*fbp)
+	struct xfs_defer_ops		*dop)
 {
 	struct xfs_mount		*mp = NULL;
 
 	memset(dop, 0, sizeof(struct xfs_defer_ops));
-	*fbp = NULLFSBLOCK;
 	INIT_LIST_HEAD(&dop->dop_intake);
 	INIT_LIST_HEAD(&dop->dop_pending);
 	if (tp) {
+		ASSERT(tp->t_firstblock == NULLFSBLOCK);
 		tp->t_dfops = dop;
 		mp = tp->t_mountp;
 	}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 56eaaac31df5..c17c9deda995 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -63,8 +63,7 @@ void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
 		struct list_head *h);
 int xfs_defer_finish(struct xfs_trans **tp, struct xfs_defer_ops *dop);
 void xfs_defer_cancel(struct xfs_defer_ops *dop);
-void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop,
-		    xfs_fsblock_t *fbp);
+void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
 bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
 int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
 int xfs_defer_bjoin(struct xfs_defer_ops *dop, struct xfs_buf *bp);
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index d81c17aac710..2ecfb0518580 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1691,7 +1691,7 @@ xfs_refcount_recover_cow_leftovers(
 		trace_xfs_refcount_recover_extent(mp, agno, &rr->rr_rrec);
 
 		/* Free the orphan record */
-		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+		xfs_defer_init(tp, &dfops);
 		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
 		fsb = XFS_AGB_TO_FSB(mp, agno, agbno);
 		error = xfs_refcount_free_cow_extent(mp, tp->t_dfops, fsb,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 96810bea07fd..7fb51534ebd3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -970,7 +970,7 @@ xfs_alloc_file_space(
 
 		xfs_trans_ijoin(tp, ip, 0);
 
-		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+		xfs_defer_init(tp, &dfops);
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
 					allocatesize_fsb, alloc_type, resblks,
 					imapp, &nimaps);
@@ -1039,7 +1039,7 @@ xfs_unmap_extent(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
 	if (error)
 		goto out_bmap_cancel;
@@ -1340,7 +1340,7 @@ xfs_collapse_file_space(
 			goto out_trans_cancel;
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+		xfs_defer_init(tp, &dfops);
 		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
 				&done);
 		if (error)
@@ -1418,7 +1418,7 @@ xfs_insert_file_space(
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+		xfs_defer_init(tp, &dfops);
 		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
 				&done, stop_fsb);
 		if (error)
@@ -1604,7 +1604,7 @@ xfs_swap_extent_rmap(
 
 		/* Unmap the old blocks in the source file. */
 		while (tirec.br_blockcount) {
-			xfs_defer_init(tp, tp->t_dfops, &tp->t_firstblock);
+			xfs_defer_init(tp, tp->t_dfops);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
 
 			/* Read extent from the source file */
@@ -1908,7 +1908,7 @@ xfs_swap_extents(
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error)
 		goto out_unlock;
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 
 	/*
 	 * Lock and join the inodes to the tansaction so that transaction commit
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 3b61b4d266b4..c53de34c9ae5 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -295,7 +295,7 @@ xfs_dquot_disk_alloc(
 
 	trace_xfs_dqalloc(dqp);
 
-	xfs_defer_init(tp, tp->t_dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, tp->t_dfops);
 
 	xfs_ilock(quotip, XFS_ILOCK_EXCL);
 	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
@@ -546,7 +546,7 @@ xfs_qm_dqread_alloc(
 			XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
 	if (error)
 		goto err;
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 
 	error = xfs_dquot_disk_alloc(&tp, dqp, &bp);
 	if (error)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 48d22134b06f..7b2694d3901a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1194,7 +1194,7 @@ xfs_create(
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 
 	/*
 	 * Reserve disk quota and the inode.
@@ -1448,7 +1448,7 @@ xfs_link(
 			goto error_return;
 	}
 
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 
 	/*
 	 * Handle initial link state of O_TMPFILE inode
@@ -1579,7 +1579,7 @@ xfs_itruncate_extents_flags(
 	ASSERT(first_unmap_block < last_block);
 	unmap_len = last_block - first_unmap_block + 1;
 	while (!done) {
-		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+		xfs_defer_init(tp, &dfops);
 		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
 				    XFS_ITRUNC_MAX_EXTENTS, &done);
 		if (error)
@@ -1808,7 +1808,7 @@ xfs_inactive_ifree(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 	error = xfs_ifree(tp, ip);
 	if (error) {
 		/*
@@ -2651,7 +2651,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
 	if (error) {
 		ASSERT(error != -ENOENT);
@@ -3008,7 +3008,7 @@ xfs_rename(
 		goto out_trans_cancel;
 	}
 
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE)
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 46ade3f7a5a3..641861bf4b92 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -253,7 +253,7 @@ xfs_iomap_write_direct(
 	 * From this point onwards we overwrite the imap pointer that the
 	 * caller gave to us.
 	 */
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
 				bmapi_flags, resblks, imap, &nimaps);
@@ -713,7 +713,7 @@ xfs_iomap_write_allocate(
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
 			xfs_trans_ijoin(tp, ip, 0);
 
-			xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+			xfs_defer_init(tp, &dfops);
 
 			/*
 			 * it is possible that the extents have changed since
@@ -872,7 +872,7 @@ xfs_iomap_write_unwritten(
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
-		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+		xfs_defer_init(tp, &dfops);
 		nimaps = 1;
 		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
 					XFS_BMAPI_CONVERT, resblks, &imap,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 940eb30e0271..8317023293a5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4890,7 +4890,6 @@ xlog_recover_process_intents(
 	struct xfs_ail_cursor	cur;
 	struct xfs_log_item	*lip;
 	struct xfs_ail		*ailp;
-	xfs_fsblock_t		firstfsb;
 	int			error = 0;
 #if defined(DEBUG) || defined(XFS_WARN)
 	xfs_lsn_t		last_lsn;
@@ -4902,7 +4901,7 @@ xlog_recover_process_intents(
 #if defined(DEBUG) || defined(XFS_WARN)
 	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
 #endif
-	xfs_defer_init(NULL, &dfops, &firstfsb);
+	xfs_defer_init(NULL, &dfops);
 	while (lip != NULL) {
 		/*
 		 * We're done when we see something other than an intent.
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d509bd7fa822..79b9ce855c72 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -424,7 +424,7 @@ xfs_reflink_allocate_cow(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 	nimaps = 1;
 
 	/* Allocate the entire reservation as unwritten blocks. */
@@ -574,7 +574,7 @@ xfs_reflink_cancel_cow_blocks(
 			if (error)
 				break;
 		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
-			xfs_defer_init(*tpp, &dfops, &(*tpp)->t_firstblock);
+			xfs_defer_init(*tpp, &dfops);
 
 			/* Free the CoW orphan record. */
 			error = xfs_refcount_free_cow_extent(ip->i_mount,
@@ -756,7 +756,7 @@ xfs_reflink_end_cow(
 			goto prev_extent;
 
 		/* Unmap the old blocks in the data fork. */
-		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+		xfs_defer_init(tp, &dfops);
 		rlen = del.br_blockcount;
 		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1);
 		if (error)
@@ -1104,7 +1104,7 @@ xfs_reflink_remap_extent(
 	/* Unmap the old blocks in the data fork. */
 	rlen = unmap_len;
 	while (rlen) {
-		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+		xfs_defer_init(tp, &dfops);
 		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1);
 		if (error)
 			goto out_defer;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index edd949376a51..bc471d42a968 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -786,7 +786,7 @@ xfs_growfs_rt_alloc(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+		xfs_defer_init(tp, &dfops);
 		/*
 		 * Allocate blocks to the bitmap file.
 		 */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a3dc552a5b97..d1ab0afa2723 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -245,7 +245,7 @@ xfs_symlink(
 	 * Initialize the bmap freelist prior to calling either
 	 * bmapi or the directory create code.
 	 */
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 
 	/*
 	 * Allocate an inode for the symlink.
@@ -438,7 +438,7 @@ xfs_inactive_symlink_rmt(
 	 * Find the block(s) so we can inval and unmap them.
 	 */
 	done = 0;
-	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
+	xfs_defer_init(tp, &dfops);
 	nmaps = ARRAY_SIZE(mval);
 	error = xfs_bmapi_read(ip, 0, xfs_symlink_blocks(mp, size),
 				mval, &nmaps, 0);
-- 
2.17.1


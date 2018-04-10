Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35754 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752065AbeDJRqd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 13:46:33 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B4AA2B0A99
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 17:46:33 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18CD07BE83
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 17:46:33 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/7] xfs: allow attach of dfops to transaction
Date: Tue, 10 Apr 2018 13:46:26 -0400
Message-Id: <20180410174631.4915-3-bfoster@redhat.com>
In-Reply-To: <20180410174631.4915-1-bfoster@redhat.com>
References: <20180410174631.4915-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_defer_ops is allocated and managed separately from the xfs_trans
on which it depends. The former is typically allocated on the stack
and processed before the associated thread escapes the scope that
defines the structure.

While this currently works fine, there are many places where
xfs_dfops is plumbed through deep callchains and/or subsystem data
structures (e.g., struct xfs_da_args) to other contexts. Since
deferred operations require a transaction, the scope of
xfs_defer_ops is essentially a subset of that of a transaction. An
upcoming enhancement to defer AGFL block frees will introduce yet
another context that requires plumbing of xfs_defer_ops (struct
xfs_alloc_arg) where a transaction is already present.

Rather than continue to pass dfops around independently, support the
ability to optionally carry an xfs_defer_ops structure in the
transaction itself. This facilitates the addition of deferred AGFL
block free behavior from selective contexts as well as incremental
clean up of other callchains to set/use the transaction reference
rather than plumb the dfops through explicitly.

Note that this patch does not change behavior nor dictate any
changes to how dfops structs are allocated (on the stack) and so all
existing rules apply. Changes to how dfops are allocated can be
considered once all paths are converted and thus would use a
consistent allocation pattern.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 18 +++++++++---------
 fs/xfs/libxfs/xfs_attr_remote.c |  6 +++---
 fs/xfs/libxfs/xfs_bmap.c        |  4 ++--
 fs/xfs/libxfs/xfs_defer.c       |  5 ++++-
 fs/xfs/libxfs/xfs_defer.h       |  3 ++-
 fs/xfs/libxfs/xfs_refcount.c    |  2 +-
 fs/xfs/xfs_bmap_util.c          | 12 ++++++------
 fs/xfs/xfs_dquot.c              |  2 +-
 fs/xfs/xfs_inode.c              | 12 ++++++------
 fs/xfs/xfs_iomap.c              |  6 +++---
 fs/xfs/xfs_log_recover.c        |  2 +-
 fs/xfs/xfs_reflink.c            |  8 ++++----
 fs/xfs/xfs_rtalloc.c            |  2 +-
 fs/xfs/xfs_symlink.c            |  4 ++--
 fs/xfs/xfs_trans.c              | 11 ++++++++---
 fs/xfs/xfs_trans.h              |  1 +
 16 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ce4a34a2751d..afc441b13c97 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -327,7 +327,7 @@ xfs_attr_set(
 		 * It won't fit in the shortform, transform to a leaf block.
 		 * GROT: another possible req'mt for a double-split btree op.
 		 */
-		xfs_defer_init(args.dfops, args.firstblock);
+		xfs_defer_init(NULL, args.dfops, args.firstblock);
 		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
 		if (error)
 			goto out_defer_cancel;
@@ -603,7 +603,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * Commit that transaction so that the node_addname() call
 		 * can manage its own transactions.
 		 */
-		xfs_defer_init(args->dfops, args->firstblock);
+		xfs_defer_init(NULL, args->dfops, args->firstblock);
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			goto out_defer_cancel;
@@ -692,7 +692,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * If the result is small enough, shrink it all into the inode.
 		 */
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			xfs_defer_init(args->dfops, args->firstblock);
+			xfs_defer_init(NULL, args->dfops, args->firstblock);
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
@@ -756,7 +756,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	 * If the result is small enough, shrink it all into the inode.
 	 */
 	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-		xfs_defer_init(args->dfops, args->firstblock);
+		xfs_defer_init(NULL, args->dfops, args->firstblock);
 		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
@@ -884,7 +884,7 @@ xfs_attr_node_addname(xfs_da_args_t *args)
 			 */
 			xfs_da_state_free(state);
 			state = NULL;
-			xfs_defer_init(args->dfops, args->firstblock);
+			xfs_defer_init(NULL, args->dfops, args->firstblock);
 			error = xfs_attr3_leaf_to_node(args);
 			if (error)
 				goto out_defer_cancel;
@@ -910,7 +910,7 @@ xfs_attr_node_addname(xfs_da_args_t *args)
 		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
 		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
 		 */
-		xfs_defer_init(args->dfops, args->firstblock);
+		xfs_defer_init(NULL, args->dfops, args->firstblock);
 		error = xfs_da3_split(state);
 		if (error)
 			goto out_defer_cancel;
@@ -1008,7 +1008,7 @@ xfs_attr_node_addname(xfs_da_args_t *args)
 		 * Check to see if the tree needs to be collapsed.
 		 */
 		if (retval && (state->path.active > 1)) {
-			xfs_defer_init(args->dfops, args->firstblock);
+			xfs_defer_init(NULL, args->dfops, args->firstblock);
 			error = xfs_da3_join(state);
 			if (error)
 				goto out_defer_cancel;
@@ -1132,7 +1132,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	 * Check to see if the tree needs to be collapsed.
 	 */
 	if (retval && (state->path.active > 1)) {
-		xfs_defer_init(args->dfops, args->firstblock);
+		xfs_defer_init(NULL, args->dfops, args->firstblock);
 		error = xfs_da3_join(state);
 		if (error)
 			goto out_defer_cancel;
@@ -1164,7 +1164,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 			goto out;
 
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			xfs_defer_init(args->dfops, args->firstblock);
+			xfs_defer_init(NULL, args->dfops, args->firstblock);
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 21be186067a2..3577585a3e11 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -492,7 +492,7 @@ xfs_attr_rmtval_set(
 		 * extent and then crash then the block may not contain the
 		 * correct metadata after log recovery occurs.
 		 */
-		xfs_defer_init(args->dfops, args->firstblock);
+		xfs_defer_init(NULL, args->dfops, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
 				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
@@ -534,7 +534,7 @@ xfs_attr_rmtval_set(
 
 		ASSERT(blkcnt > 0);
 
-		xfs_defer_init(args->dfops, args->firstblock);
+		xfs_defer_init(NULL, args->dfops, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
 				       blkcnt, &map, &nmap,
@@ -638,7 +638,7 @@ xfs_attr_rmtval_remove(
 	blkcnt = args->rmtblkcnt;
 	done = 0;
 	while (!done) {
-		xfs_defer_init(args->dfops, args->firstblock);
+		xfs_defer_init(NULL, args->dfops, args->firstblock);
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK, 1, args->firstblock,
 				    args->dfops, &done);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6a7c2f03ea11..4d93e4562e7e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1108,7 +1108,7 @@ xfs_bmap_add_attrfork(
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
-	xfs_defer_init(&dfops, &firstblock);
+	xfs_defer_init(NULL, &dfops, &firstblock);
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock, &dfops,
@@ -6004,7 +6004,7 @@ xfs_bmap_split_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-	xfs_defer_init(&dfops, &firstfsb);
+	xfs_defer_init(NULL, &dfops, &firstfsb);
 
 	error = xfs_bmap_split_extent_at(tp, ip, split_fsb,
 			&firstfsb, &dfops);
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 087fea02c389..f3aef54257d1 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -525,6 +525,7 @@ xfs_defer_init_op_type(
 /* Initialize a deferred operation. */
 void
 xfs_defer_init(
+	struct xfs_trans		*tp,
 	struct xfs_defer_ops		*dop,
 	xfs_fsblock_t			*fbp)
 {
@@ -532,5 +533,7 @@ xfs_defer_init(
 	*fbp = NULLFSBLOCK;
 	INIT_LIST_HEAD(&dop->dop_intake);
 	INIT_LIST_HEAD(&dop->dop_pending);
-	trace_xfs_defer_init(NULL, dop);
+	if (tp)
+		tp->t_dfops = dop;
+	trace_xfs_defer_init(tp ? tp->t_mountp : NULL, dop);
 }
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 045beacdd37d..e263b3973cb6 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -76,7 +76,8 @@ void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
 		struct list_head *h);
 int xfs_defer_finish(struct xfs_trans **tp, struct xfs_defer_ops *dop);
 void xfs_defer_cancel(struct xfs_defer_ops *dop);
-void xfs_defer_init(struct xfs_defer_ops *dop, xfs_fsblock_t *fbp);
+void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop,
+		    xfs_fsblock_t *fbp);
 bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
 int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
 int xfs_defer_bjoin(struct xfs_defer_ops *dop, struct xfs_buf *bp);
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 560e28473024..561a08e44289 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1648,7 +1648,7 @@ xfs_refcount_recover_cow_leftovers(
 		trace_xfs_refcount_recover_extent(mp, agno, &rr->rr_rrec);
 
 		/* Free the orphan record */
-		xfs_defer_init(&dfops, &fsb);
+		xfs_defer_init(NULL, &dfops, &fsb);
 		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
 		fsb = XFS_AGB_TO_FSB(mp, agno, agbno);
 		error = xfs_refcount_free_cow_extent(mp, &dfops, fsb,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8cd8c412f52d..78a17c43aab8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -754,7 +754,7 @@ xfs_bmap_punch_delalloc_range(
 		 * allocated or freed for a delalloc extent and hence we need
 		 * don't cancel or finish them after the xfs_bunmapi() call.
 		 */
-		xfs_defer_init(&dfops, &firstblock);
+		xfs_defer_init(NULL, &dfops, &firstblock);
 		error = xfs_bunmapi(NULL, ip, start_fsb, 1, 0, 1, &firstblock,
 					&dfops, &done);
 		if (error)
@@ -1000,7 +1000,7 @@ xfs_alloc_file_space(
 
 		xfs_trans_ijoin(tp, ip, 0);
 
-		xfs_defer_init(&dfops, &firstfsb);
+		xfs_defer_init(NULL, &dfops, &firstfsb);
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
 					allocatesize_fsb, alloc_type, &firstfsb,
 					resblks, imapp, &nimaps, &dfops);
@@ -1070,7 +1070,7 @@ xfs_unmap_extent(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
-	xfs_defer_init(&dfops, &firstfsb);
+	xfs_defer_init(NULL, &dfops, &firstfsb);
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, &firstfsb,
 			&dfops, done);
 	if (error)
@@ -1358,7 +1358,7 @@ xfs_collapse_file_space(
 			goto out_trans_cancel;
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-		xfs_defer_init(&dfops, &first_block);
+		xfs_defer_init(NULL, &dfops, &first_block);
 		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
 				&done, &first_block, &dfops);
 		if (error)
@@ -1433,7 +1433,7 @@ xfs_insert_file_space(
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-		xfs_defer_init(&dfops, &first_block);
+		xfs_defer_init(NULL, &dfops, &first_block);
 		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
 				&done, stop_fsb, &first_block, &dfops);
 		if (error)
@@ -1619,7 +1619,7 @@ xfs_swap_extent_rmap(
 
 		/* Unmap the old blocks in the source file. */
 		while (tirec.br_blockcount) {
-			xfs_defer_init(&dfops, &firstfsb);
+			xfs_defer_init(NULL, &dfops, &firstfsb);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
 
 			/* Read extent from the source file */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a7daef9e16bf..6f63e179b20c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -314,7 +314,7 @@ xfs_qm_dqalloc(
 	/*
 	 * Initialize the bmap freelist prior to calling bmapi code.
 	 */
-	xfs_defer_init(&dfops, &firstblock);
+	xfs_defer_init(NULL, &dfops, &firstblock);
 	xfs_ilock(quotip, XFS_ILOCK_EXCL);
 	/*
 	 * Return if this type of quotas is turned off while we didn't
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c09774ca53ae..0c2e53fbc0f0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1195,7 +1195,7 @@ xfs_create(
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
-	xfs_defer_init(&dfops, &first_block);
+	xfs_defer_init(NULL, &dfops, &first_block);
 
 	/*
 	 * Reserve disk quota and the inode.
@@ -1450,7 +1450,7 @@ xfs_link(
 			goto error_return;
 	}
 
-	xfs_defer_init(&dfops, &first_block);
+	xfs_defer_init(NULL, &dfops, &first_block);
 
 	/*
 	 * Handle initial link state of O_TMPFILE inode
@@ -1578,7 +1578,7 @@ xfs_itruncate_extents(
 	ASSERT(first_unmap_block < last_block);
 	unmap_len = last_block - first_unmap_block + 1;
 	while (!done) {
-		xfs_defer_init(&dfops, &first_block);
+		xfs_defer_init(NULL, &dfops, &first_block);
 		error = xfs_bunmapi(tp, ip,
 				    first_unmap_block, unmap_len,
 				    xfs_bmapi_aflag(whichfork),
@@ -1808,7 +1808,7 @@ xfs_inactive_ifree(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	xfs_defer_init(&dfops, &first_block);
+	xfs_defer_init(NULL, &dfops, &first_block);
 	error = xfs_ifree(tp, ip, &dfops);
 	if (error) {
 		/*
@@ -2644,7 +2644,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_defer_init(&dfops, &first_block);
+	xfs_defer_init(NULL, &dfops, &first_block);
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
 					&first_block, &dfops, resblks);
 	if (error) {
@@ -3011,7 +3011,7 @@ xfs_rename(
 		goto out_trans_cancel;
 	}
 
-	xfs_defer_init(&dfops, &first_block);
+	xfs_defer_init(NULL, &dfops, &first_block);
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE)
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 046469fcc1b8..c942ac25547d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -266,7 +266,7 @@ xfs_iomap_write_direct(
 	 * From this point onwards we overwrite the imap pointer that the
 	 * caller gave to us.
 	 */
-	xfs_defer_init(&dfops, &firstfsb);
+	xfs_defer_init(NULL, &dfops, &firstfsb);
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
 				bmapi_flags, &firstfsb, resblks, imap,
@@ -728,7 +728,7 @@ xfs_iomap_write_allocate(
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
 			xfs_trans_ijoin(tp, ip, 0);
 
-			xfs_defer_init(&dfops, &first_block);
+			xfs_defer_init(NULL, &dfops, &first_block);
 
 			/*
 			 * it is possible that the extents have changed since
@@ -889,7 +889,7 @@ xfs_iomap_write_unwritten(
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
-		xfs_defer_init(&dfops, &firstfsb);
+		xfs_defer_init(NULL, &dfops, &firstfsb);
 		nimaps = 1;
 		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
 					XFS_BMAPI_CONVERT, &firstfsb, resblks,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2b2383f1895e..4674a7cefb8b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4889,7 +4889,7 @@ xlog_recover_process_intents(
 #if defined(DEBUG) || defined(XFS_WARN)
 	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
 #endif
-	xfs_defer_init(&dfops, &firstfsb);
+	xfs_defer_init(NULL, &dfops, &firstfsb);
 	while (lip != NULL) {
 		/*
 		 * We're done when we see something other than an intent.
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cdbd342a5249..467248660028 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -444,7 +444,7 @@ xfs_reflink_allocate_cow(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
-	xfs_defer_init(&dfops, &first_block);
+	xfs_defer_init(NULL, &dfops, &first_block);
 	nimaps = 1;
 
 	/* Allocate the entire reservation as unwritten blocks. */
@@ -593,7 +593,7 @@ xfs_reflink_cancel_cow_blocks(
 				break;
 		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
 			xfs_trans_ijoin(*tpp, ip, 0);
-			xfs_defer_init(&dfops, &firstfsb);
+			xfs_defer_init(NULL, &dfops, &firstfsb);
 
 			/* Free the CoW orphan record. */
 			error = xfs_refcount_free_cow_extent(ip->i_mount,
@@ -776,7 +776,7 @@ xfs_reflink_end_cow(
 			goto prev_extent;
 
 		/* Unmap the old blocks in the data fork. */
-		xfs_defer_init(&dfops, &firstfsb);
+		xfs_defer_init(NULL, &dfops, &firstfsb);
 		rlen = del.br_blockcount;
 		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1,
 				&firstfsb, &dfops);
@@ -1125,7 +1125,7 @@ xfs_reflink_remap_extent(
 	/* Unmap the old blocks in the data fork. */
 	rlen = unmap_len;
 	while (rlen) {
-		xfs_defer_init(&dfops, &firstfsb);
+		xfs_defer_init(NULL, &dfops, &firstfsb);
 		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1,
 				&firstfsb, &dfops);
 		if (error)
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 488719d43ca8..62c40dd96648 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -795,7 +795,7 @@ xfs_growfs_rt_alloc(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-		xfs_defer_init(&dfops, &firstblock);
+		xfs_defer_init(NULL, &dfops, &firstblock);
 		/*
 		 * Allocate blocks to the bitmap file.
 		 */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 5b66ac12913c..e4c4ea25af61 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -258,7 +258,7 @@ xfs_symlink(
 	 * Initialize the bmap freelist prior to calling either
 	 * bmapi or the directory create code.
 	 */
-	xfs_defer_init(&dfops, &first_block);
+	xfs_defer_init(NULL, &dfops, &first_block);
 
 	/*
 	 * Allocate an inode for the symlink.
@@ -454,7 +454,7 @@ xfs_inactive_symlink_rmt(
 	 * Find the block(s) so we can inval and unmap them.
 	 */
 	done = 0;
-	xfs_defer_init(&dfops, &first_block);
+	xfs_defer_init(NULL, &dfops, &first_block);
 	nmaps = ARRAY_SIZE(mval);
 	error = xfs_bmapi_read(ip, 0, xfs_symlink_blocks(mp, size),
 				mval, &nmaps, 0);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index d6d8f9d129a7..c7e82dbd760e 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -31,6 +31,7 @@
 #include "xfs_log.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_defer.h"
 
 kmem_zone_t	*xfs_trans_zone;
 kmem_zone_t	*xfs_log_item_desc_zone;
@@ -94,11 +95,11 @@ xfs_trans_free(
  * blocks.  Locks and log items, however, are no inherited.  They must
  * be added to the new transaction explicitly.
  */
-STATIC xfs_trans_t *
+STATIC struct xfs_trans *
 xfs_trans_dup(
-	xfs_trans_t	*tp)
+	struct xfs_trans	*tp)
 {
-	xfs_trans_t	*ntp;
+	struct xfs_trans	*ntp;
 
 	ntp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP);
 
@@ -127,6 +128,7 @@ xfs_trans_dup(
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
 	ntp->t_pflags = tp->t_pflags;
+	ntp->t_dfops = tp->t_dfops;
 
 	xfs_trans_dup_dqinfo(tp, ntp);
 
@@ -936,6 +938,9 @@ __xfs_trans_commit(
 	int			error = 0;
 	int			sync = tp->t_flags & XFS_TRANS_SYNC;
 
+	ASSERT(!tp->t_dfops || !xfs_defer_has_unfinished_work(tp->t_dfops) ||
+	       regrant);
+
 	/*
 	 * If there is nothing to be logged by the transaction,
 	 * then unlock all of the items associated with the
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9d542dfe0052..220b5b65f524 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -111,6 +111,7 @@ typedef struct xfs_trans {
 	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
 	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
 	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
+	struct xfs_defer_ops	*t_dfops;	/* deferred ops reference */
 	unsigned int		t_flags;	/* misc flags */
 	int64_t			t_icount_delta;	/* superblock icount change */
 	int64_t			t_ifree_delta;	/* superblock ifree change */
-- 
2.13.6


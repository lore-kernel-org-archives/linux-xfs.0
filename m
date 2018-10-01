Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48742 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725740AbeJAXnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 19:43:18 -0400
Subject: [PATCH 1/8] libxfs: port kernel transaction code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Oct 2018 10:04:18 -0700
Message-ID: <153841345864.27952.9364676714544085070.stgit@magnolia>
In-Reply-To: <153841345236.27952.5050172703525712660.stgit@magnolia>
References: <153841345236.27952.5050172703525712660.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Restructure the userspace transaction code to resemble the kernel code
more closely.  This will make deferred operations behave the same (with
respect to transaction lifetimes) as the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |  238 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 187 insertions(+), 51 deletions(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index b1543b0c..11a2098d 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -20,6 +20,10 @@
 #include "xfs_defer.h"
 
 static void xfs_trans_free_items(struct xfs_trans *tp);
+STATIC struct xfs_trans *xfs_trans_dup(struct xfs_trans *tp);
+static int xfs_trans_reserve(struct xfs_trans *tp, struct xfs_trans_res *resp,
+		uint blocks, uint rtextents);
+static int __xfs_trans_commit(struct xfs_trans *tp, bool regrant);
 
 /*
  * Simple transaction interface
@@ -76,24 +80,17 @@ int
 libxfs_trans_roll(
 	struct xfs_trans	**tpp)
 {
-	struct xfs_mount	*mp;
 	struct xfs_trans	*trans = *tpp;
 	struct xfs_trans_res	tres;
-	unsigned int		old_blk_res;
-	xfs_fsblock_t		old_firstblock;
-	struct list_head	old_dfops;
 	int			error;
 
 	/*
 	 * Copy the critical parameters from one trans to the next.
 	 */
-	mp = trans->t_mountp;
 	tres.tr_logres = trans->t_log_res;
 	tres.tr_logcount = trans->t_log_count;
-	old_blk_res = trans->t_blk_res;
-	old_firstblock = trans->t_firstblock;
-	/* structure copy */
-	old_dfops = trans->t_dfops;
+
+	*tpp = xfs_trans_dup(trans);
 
 	/*
 	 * Commit the current transaction.
@@ -102,7 +99,7 @@ libxfs_trans_roll(
 	 * is in progress. The caller takes the responsibility to cancel
 	 * the duplicate transaction that gets returned.
 	 */
-	error = xfs_trans_commit(trans);
+	error = __xfs_trans_commit(trans, true);
 	if (error)
 		return error;
 
@@ -115,14 +112,7 @@ libxfs_trans_roll(
 	 * the prior and the next transactions.
 	 */
 	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	error = libxfs_trans_alloc(mp, &tres, 0, 0, 0, tpp);
-	trans = *tpp;
-	trans->t_blk_res = old_blk_res;
-	trans->t_firstblock = old_firstblock;
-	/* structure copy */
-	trans->t_dfops = old_dfops;
-
-	return 0;
+	return xfs_trans_reserve(*tpp, &tres, 0, 0);
 }
 
 /*
@@ -136,40 +126,150 @@ xfs_trans_free(
 	kmem_zone_free(xfs_trans_zone, tp);
 }
 
-int
-libxfs_trans_alloc(
-	struct xfs_mount	*mp,
-	struct xfs_trans_res	*resp,
-	unsigned int		blocks,
-	unsigned int		rtextents,
-	unsigned int		flags,
-	struct xfs_trans	**tpp)
+/*
+ * This is called to create a new transaction which will share the
+ * permanent log reservation of the given transaction.  The remaining
+ * unused block and rt extent reservations are also inherited.  This
+ * implies that the original transaction is no longer allowed to allocate
+ * blocks.  Locks and log items, however, are no inherited.  They must
+ * be added to the new transaction explicitly.
+ */
+STATIC struct xfs_trans *
+xfs_trans_dup(
+	struct xfs_trans	*tp)
+{
+	struct xfs_trans	*ntp;
 
+	ntp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP);
+
+	/*
+	 * Initialize the new transaction structure.
+	 */
+	ntp->t_mountp = tp->t_mountp;
+	INIT_LIST_HEAD(&ntp->t_items);
+	INIT_LIST_HEAD(&ntp->t_dfops);
+	ntp->t_firstblock = NULLFSBLOCK;
+
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
+		       (tp->t_flags & XFS_TRANS_RESERVE) |
+		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
+	/* We gave our writer reference to the new transaction */
+	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
+
+	/* move deferred ops over to the new tp */
+	xfs_defer_move(ntp, tp);
+
+	return ntp;
+}
+
+/*
+ * This is called to reserve free disk blocks and log space for the
+ * given transaction.  This must be done before allocating any resources
+ * within the transaction.
+ *
+ * This will return ENOSPC if there are not enough blocks available.
+ * It will sleep waiting for available log space.
+ * The only valid value for the flags parameter is XFS_RES_LOG_PERM, which
+ * is used by long running transactions.  If any one of the reservations
+ * fails then they will all be backed out.
+ *
+ * This does not do quota reservations. That typically is done by the
+ * caller afterwards.
+ */
+static int
+xfs_trans_reserve(
+	struct xfs_trans	*tp,
+	struct xfs_trans_res	*resp,
+	uint			blocks,
+	uint			rtextents)
 {
-	struct xfs_sb	*sb = &mp->m_sb;
-	struct xfs_trans *ptr;
+	int			error = 0;
 
 	/*
 	 * Attempt to reserve the needed disk blocks by decrementing
-	 * the number needed from the number available.	 This will
+	 * the number needed from the number available.  This will
 	 * fail if the count would go below zero.
 	 */
 	if (blocks > 0) {
-		if (sb->sb_fdblocks < blocks)
+		if (tp->t_mountp->m_sb.sb_fdblocks < blocks)
 			return -ENOSPC;
+		tp->t_blk_res += blocks;
+	}
+
+	/*
+	 * Reserve the log space needed for this transaction.
+	 */
+	if (resp->tr_logres > 0) {
+		ASSERT(tp->t_log_res == 0 ||
+		       tp->t_log_res == resp->tr_logres);
+		ASSERT(tp->t_log_count == 0 ||
+		       tp->t_log_count == resp->tr_logcount);
+
+		if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES)
+			tp->t_flags |= XFS_TRANS_PERM_LOG_RES;
+		else
+			ASSERT(!(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
+
+		tp->t_log_res = resp->tr_logres;
+		tp->t_log_count = resp->tr_logcount;
 	}
 
-	ptr = kmem_zone_zalloc(xfs_trans_zone,
+	/*
+	 * Attempt to reserve the needed realtime extents by decrementing
+	 * the number needed from the number available.  This will
+	 * fail if the count would go below zero.
+	 */
+	if (rtextents > 0) {
+		if (tp->t_mountp->m_sb.sb_rextents < rtextents) {
+			error = -ENOSPC;
+			goto undo_blocks;
+		}
+	}
+
+	return 0;
+
+	/*
+	 * Error cases jump to one of these labels to undo any
+	 * reservations which have already been performed.
+	 */
+undo_blocks:
+	if (blocks > 0)
+		tp->t_blk_res = 0;
+
+	return error;
+}
+
+int
+libxfs_trans_alloc(
+	struct xfs_mount	*mp,
+	struct xfs_trans_res	*resp,
+	unsigned int		blocks,
+	unsigned int		rtextents,
+	unsigned int		flags,
+	struct xfs_trans	**tpp)
+
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	tp = kmem_zone_zalloc(xfs_trans_zone,
 		(flags & XFS_TRANS_NOFS) ? KM_NOFS : KM_SLEEP);
-	ptr->t_mountp = mp;
-	ptr->t_blk_res = blocks;
-	INIT_LIST_HEAD(&ptr->t_items);
-	INIT_LIST_HEAD(&ptr->t_dfops);
-	ptr->t_firstblock = NULLFSBLOCK;
+	tp->t_mountp = mp;
+	INIT_LIST_HEAD(&tp->t_items);
+	INIT_LIST_HEAD(&tp->t_dfops);
+	tp->t_firstblock = NULLFSBLOCK;
+
+	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
+	if (error) {
+		xfs_trans_cancel(tp);
+		return error;
+	}
 #ifdef XACT_DEBUG
-	fprintf(stderr, "allocated new transaction %p\n", ptr);
+	fprintf(stderr, "allocated new transaction %p\n", tp);
 #endif
-	*tpp = ptr;
+	*tpp = tp;
 	return 0;
 }
 
@@ -197,18 +297,25 @@ libxfs_trans_alloc_empty(
 
 void
 libxfs_trans_cancel(
-	xfs_trans_t	*tp)
+	struct xfs_trans	*tp)
 {
 #ifdef XACT_DEBUG
-	xfs_trans_t	*otp = tp;
+	struct xfs_trans	*otp = tp;
 #endif
-	if (tp != NULL) {
-		xfs_trans_free_items(tp);
-		xfs_trans_free(tp);
-	}
+	if (tp == NULL)
+		goto out;
+
+	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
+		xfs_defer_cancel(tp);
+
+	xfs_trans_free_items(tp);
+	xfs_trans_free(tp);
+
+out:
 #ifdef XACT_DEBUG
 	fprintf(stderr, "## cancelled transaction %p\n", otp);
 #endif
+	return;
 }
 
 int
@@ -261,6 +368,9 @@ libxfs_trans_ijoin(
 	ASSERT(iip->ili_flags == 0);
 	ASSERT(iip->ili_inode != NULL);
 
+	ASSERT(iip->ili_lock_flags == 0);
+	iip->ili_lock_flags = lock_flags;
+
 	xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
 
 	ip->i_transp = tp;
@@ -839,22 +949,36 @@ xfs_trans_free_items(
 /*
  * Commit the changes represented by this transaction
  */
-int
-libxfs_trans_commit(
-	xfs_trans_t	*tp)
+static int
+__xfs_trans_commit(
+	struct xfs_trans	*tp,
+	bool			regrant)
 {
-	xfs_sb_t	*sbp;
+	struct xfs_sb		*sbp;
+	int			error = 0;
 
 	if (tp == NULL)
 		return 0;
 
+	/*
+	 * Finish deferred items on final commit. Only permanent transactions
+	 * should ever have deferred ops.
+	 */
+	WARN_ON_ONCE(!list_empty(&tp->t_dfops) &&
+		     !(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
+	if (!regrant && (tp->t_flags & XFS_TRANS_PERM_LOG_RES)) {
+		error = xfs_defer_finish_noroll(&tp);
+		if (error) {
+			xfs_defer_cancel(tp);
+			goto out_unreserve;
+		}
+	}
+
 	if (!(tp->t_flags & XFS_TRANS_DIRTY)) {
 #ifdef XACT_DEBUG
 		fprintf(stderr, "committed clean transaction %p\n", tp);
 #endif
-		xfs_trans_free_items(tp);
-		xfs_trans_free(tp);
-		return 0;
+		goto out_unreserve;
 	}
 
 	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
@@ -878,4 +1002,16 @@ libxfs_trans_commit(
 	/* That's it for the transaction structure.  Free it. */
 	xfs_trans_free(tp);
 	return 0;
+
+out_unreserve:
+	xfs_trans_free_items(tp);
+	xfs_trans_free(tp);
+	return error;
+}
+
+int
+libxfs_trans_commit(
+	struct xfs_trans	*tp)
+{
+	return __xfs_trans_commit(tp, false);
 }

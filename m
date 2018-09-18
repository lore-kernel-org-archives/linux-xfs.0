Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41812 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727660AbeISA26 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 20:28:58 -0400
Subject: [PATCH 1/4] libxfs: port kernel transaction code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Sep 2018 11:54:56 -0700
Message-ID: <153729689686.13178.17429858052689956943.stgit@magnolia>
In-Reply-To: <153729689066.13178.8524619838625486047.stgit@magnolia>
References: <153729689066.13178.8524619838625486047.stgit@magnolia>
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
more closely.  This will simplify porting the upcoming defer_ops
refactoring.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |  206 +++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 165 insertions(+), 41 deletions(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index 2bb0d3b8..e827f0df 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -19,6 +19,10 @@
 #include "xfs_sb.h"
 
 static void xfs_trans_free_items(struct xfs_trans *tp);
+STATIC struct xfs_trans *xfs_trans_dup(struct xfs_trans *tp);
+static int xfs_trans_reserve(struct xfs_trans *tp, struct xfs_trans_res *resp,
+		uint blocks, uint rtextents);
+static int __xfs_trans_commit(struct xfs_trans *tp, bool regrant);
 
 /*
  * Simple transaction interface
@@ -75,19 +79,17 @@ int
 libxfs_trans_roll(
 	struct xfs_trans	**tpp)
 {
-	struct xfs_mount	*mp;
 	struct xfs_trans	*trans = *tpp;
 	struct xfs_trans_res	tres;
-	unsigned int		old_blk_res;
 	int			error;
 
 	/*
 	 * Copy the critical parameters from one trans to the next.
 	 */
-	mp = trans->t_mountp;
 	tres.tr_logres = trans->t_log_res;
 	tres.tr_logcount = trans->t_log_count;
-	old_blk_res = trans->t_blk_res;
+
+	*tpp = xfs_trans_dup(trans);
 
 	/*
 	 * Commit the current transaction.
@@ -96,7 +98,7 @@ libxfs_trans_roll(
 	 * is in progress. The caller takes the responsibility to cancel
 	 * the duplicate transaction that gets returned.
 	 */
-	error = xfs_trans_commit(trans);
+	error = __xfs_trans_commit(trans, true);
 	if (error)
 		return error;
 
@@ -109,11 +111,7 @@ libxfs_trans_roll(
 	 * the prior and the next transactions.
 	 */
 	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	error = libxfs_trans_alloc(mp, &tres, 0, 0, 0, tpp);
-	trans = *tpp;
-	trans->t_blk_res = old_blk_res;
-
-	return 0;
+	return xfs_trans_reserve(*tpp, &tres, 0, 0);
 }
 
 /*
@@ -127,38 +125,145 @@ xfs_trans_free(
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
+
+	ntp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP);
+
+	/*
+	 * Initialize the new transaction structure.
+	 */
+	ntp->t_mountp = tp->t_mountp;
+	INIT_LIST_HEAD(&ntp->t_items);
+
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
+		       (tp->t_flags & XFS_TRANS_RESERVE) |
+		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
+	/* We gave our writer reference to the new transaction */
+	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
 
+	ntp->t_agfl_dfops = tp->t_agfl_dfops;
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
 	}
 
-	ptr = kmem_zone_zalloc(xfs_trans_zone,
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
+	}
+
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
+	tp->t_mountp = mp;
+	INIT_LIST_HEAD(&tp->t_items);
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
 
@@ -186,18 +291,22 @@ libxfs_trans_alloc_empty(
 
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
@@ -828,22 +937,25 @@ xfs_trans_free_items(
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
 
+	ASSERT(!tp->t_agfl_dfops ||
+	       !xfs_defer_has_unfinished_work(tp->t_agfl_dfops) || regrant);
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
@@ -867,4 +979,16 @@ libxfs_trans_commit(
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

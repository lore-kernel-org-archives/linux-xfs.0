Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34021 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752338AbcKQX5E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2016 18:57:04 -0500
Received: from disappointment.disaster.area ([192.168.1.110] helo=disappointment)
        by dastard with esmtp (Exim 4.80)
        (envelope-from <dave@fromorbit.com>)
        id 1c7WWq-0008NR-P5
        for linux-xfs@vger.kernel.org; Fri, 18 Nov 2016 10:55:40 +1100
Received: from dave by disappointment with local (Exim 4.87)
        (envelope-from <dave@disappointment.disaster>)
        id 1c7WWr-00020K-N1
        for linux-xfs@vger.kernel.org; Fri, 18 Nov 2016 10:55:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: hold AGF buffers over defer ops
Date: Fri, 18 Nov 2016 10:55:34 +1100
Message-Id: <1479426935-7112-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1479426935-7112-1-git-send-email-david@fromorbit.com>
References: <20161117213224.GD28177@dastard>
 <1479426935-7112-1-git-send-email-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We make space and AGFL adjustments in the initial transaction for
rmap defer ops to complete, but those reservations are only valid
while we hold the AGF locked. The issue here is that if we drop the
AGF lock, we can race withother operations that need AGFL
adjustments for their deferred rmap operations, and so we can get
multiple deferred ops running at the same that share a single AGFL
reservation instead of having one each. With enough defered rmap ops
running at the same time, we run the AGFL out of free blocks and
fail rmap insertions, resulting in  corruption shutdowns.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c  | 14 ++++++++++
 fs/xfs/libxfs/xfs_defer.c | 69 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_defer.h |  6 +++++
 fs/xfs/xfs_trans_buf.c    | 12 ++++++++-
 4 files changed, 96 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 00188f559c8d..6211b4b5e826 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3932,6 +3932,20 @@ xfs_bmap_btalloc(
 			ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
 					XFS_TRANS_DQ_BCOUNT,
 			(long) args.len);
+
+		/*
+		 * If we are going to update the rmap btree, we need to join the
+		 * AGF used for this allocation to the defer ops processing so
+		 * that it stays locked until we've processed all the relevant
+		 * btree updates that are required.
+		 */
+		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+			ASSERT(args.agbp);
+			error = xfs_defer_join_buf(ap->tp, ap->dfops,
+						   args.agbp);
+			if (error)
+				return error;
+		}
 	} else {
 		ap->blkno = NULLFSBLOCK;
 		ap->length = 0;
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5c2929f94bd3..1e5a8b04c7f5 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -271,6 +271,13 @@ xfs_defer_trans_roll(
 		xfs_trans_ijoin(*tp, dop->dop_inodes[i], 0);
 	}
 
+	/* Rejoin the held buffers */
+	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS && dop->dop_bufs[i]; i++) {
+		ASSERT(dop->dop_bufs[i]->b_transp == NULL);
+		xfs_trans_bjoin(*tp, dop->dop_bufs[i]);
+		xfs_trans_bhold(*tp, dop->dop_bufs[i]);
+	}
+
 	return error;
 }
 
@@ -297,7 +304,7 @@ xfs_defer_join(
 	for (i = 0; i < XFS_DEFER_OPS_NR_INODES; i++) {
 		if (dop->dop_inodes[i] == ip)
 			return 0;
-		else if (dop->dop_inodes[i] == NULL) {
+		if (!dop->dop_inodes[i]) {
 			dop->dop_inodes[i] = ip;
 			return 0;
 		}
@@ -307,6 +314,60 @@ xfs_defer_join(
 }
 
 /*
+ * Add this buffer to the deferred op.  If this is a new buffer we are joining
+ * to the deferred ops, we need to ensure it will be held locked across
+ * transaction commits. This means each joined buffer remains locked until
+ * the final defer op commits and we clean up the xfs_defer_ops structure. This
+ * ensures atomicity of access to buffers and their state while we perform
+ * multiple operations to them through deferred ops processing.
+ */
+int
+xfs_defer_join_buf(
+	struct xfs_trans	*tp,
+	struct xfs_defer_ops	*dop,
+	struct xfs_buf		*bp)
+{
+	int				i;
+
+	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS; i++) {
+		if (dop->dop_bufs[i] == bp)
+			return 0;
+		if (!dop->dop_bufs[i]) {
+			xfs_trans_bhold(tp, bp);
+			dop->dop_bufs[i] = bp;
+			return 0;
+		}
+	}
+
+	return -EFSCORRUPTED;
+}
+
+/*
+ * When we are all done with the defer processing, the buffers we hold
+ * will still be locked. We need to unlock and release them now.
+ *
+ * We can get called in from a context that doesn't pass a transaction,
+ * but the buffers are still attached to a transaction. If this happens,
+ * pull the transaction from the buffer. If the buffer is not part of a
+ * transaction, then b_transp will be null and the buffer will be released
+ * normally.
+ */
+static void
+xfs_defer_brelse(
+	struct xfs_trans	*tp,
+	struct xfs_defer_ops	*dop)
+{
+	int				i;
+
+	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS; i++) {
+		if (!tp)
+			tp = dop->dop_bufs[i]->b_transp;
+		if (dop->dop_bufs[i])
+			xfs_trans_bhold_release(tp, dop->dop_bufs[i]);
+	}
+}
+
+/*
  * Finish all the pending work.  This involves logging intent items for
  * any work items that wandered in since the last transaction roll (if
  * one has even happened), rolling the transaction, and finishing the
@@ -402,6 +463,7 @@ xfs_defer_finish(
 	}
 
 out:
+	xfs_defer_brelse(*tp, dop);
 	if (error)
 		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
 	else
@@ -449,6 +511,7 @@ xfs_defer_cancel(
 		ASSERT(dfp->dfp_count == 0);
 		kmem_free(dfp);
 	}
+	xfs_defer_brelse(NULL, dop);
 }
 
 /* Add an item for later deferred processing. */
@@ -502,9 +565,7 @@ xfs_defer_init(
 	struct xfs_defer_ops		*dop,
 	xfs_fsblock_t			*fbp)
 {
-	dop->dop_committed = false;
-	dop->dop_low = false;
-	memset(&dop->dop_inodes, 0, sizeof(dop->dop_inodes));
+	memset(dop, 0, sizeof(*dop));
 	*fbp = NULLFSBLOCK;
 	INIT_LIST_HEAD(&dop->dop_intake);
 	INIT_LIST_HEAD(&dop->dop_pending);
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index f6e93ef0bffe..036fde7d839b 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -59,6 +59,7 @@ enum xfs_defer_ops_type {
 };
 
 #define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+#define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 struct xfs_defer_ops {
 	bool			dop_committed;	/* did any trans commit? */
@@ -68,6 +69,9 @@ struct xfs_defer_ops {
 
 	/* relog these inodes with each roll */
 	struct xfs_inode	*dop_inodes[XFS_DEFER_OPS_NR_INODES];
+
+	/* hold these buffers with each roll */
+	struct xfs_buf		*dop_bufs[XFS_DEFER_OPS_NR_BUFS];
 };
 
 void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
@@ -78,6 +82,8 @@ void xfs_defer_cancel(struct xfs_defer_ops *dop);
 void xfs_defer_init(struct xfs_defer_ops *dop, xfs_fsblock_t *fbp);
 bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
 int xfs_defer_join(struct xfs_defer_ops *dop, struct xfs_inode *ip);
+int xfs_defer_join_buf(struct xfs_trans *tp, struct xfs_defer_ops *dop,
+		struct xfs_buf *bp);
 
 /* Description of a deferred type. */
 struct xfs_defer_op_type {
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 8ee29ca132dc..f88552182256 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -66,6 +66,12 @@ xfs_trans_buf_item_match(
  * Add the locked buffer to the transaction.
  *
  * The buffer must be locked, and it cannot be associated with any
+ * transaction other than the one we pass in. This "join" recursion
+ * is a result of needing to hold buffers locked across multiple transactions in
+ * the defer ops processing. To hold the buffer when rolling the transaction we
+ * need to first join the buffer to transaction, and hence when this gets done
+ * in the normal course of the transaction we then get called a second time.
+ * Hence just do nothing if bp->b_transp already matches the incoming
  * transaction.
  *
  * If the buffer does not yet have a buf log item associated with it,
@@ -79,7 +85,11 @@ _xfs_trans_bjoin(
 {
 	struct xfs_buf_log_item	*bip;
 
-	ASSERT(bp->b_transp == NULL);
+	ASSERT(!bp->b_transp || bp->b_transp == tp);
+
+	/* already joined to this transaction from defer ops? */
+	if (bp->b_transp == tp)
+		return;
 
 	/*
 	 * The xfs_buf_log_item pointer is stored in b_fsprivate.  If
-- 
2.8.0.rc3


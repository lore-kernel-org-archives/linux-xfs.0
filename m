Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56366 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbfEUDrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 23:47:12 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/7] libxfs: factor common xfs_trans_bjoin code
Date: Mon, 20 May 2019 22:47:03 -0500
Message-Id: <1558410427-1837-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Most of xfs_trans_bjoin is duplicated in xfs_trans_get_buf_map,
xfs_trans_getsb and xfs_trans_read_buf_map.  Add a new
_xfs_trans_bjoin which can be called by all three functions.

Source kernel commit: d7e84f413726876c0ec66bbf90770f69841f7663

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
[sandeen: merge to userspace]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/trans.c | 53 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 14 deletions(-)

diff --git a/libxfs/trans.c b/libxfs/trans.c
index 763daa0..dc924fa 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -537,19 +537,50 @@ libxfs_trans_binval(
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
 
-void
-libxfs_trans_bjoin(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+/*
+ * Add the locked buffer to the transaction.
+ *
+ * The buffer must be locked, and it cannot be associated with any
+ * transaction.
+ *
+ * If the buffer does not yet have a buf log item associated with it,
+ * then allocate one for it.  Then add the buf item to the transaction.
+ */
+STATIC void
+_libxfs_trans_bjoin(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	int			reset_recur)
 {
-	xfs_buf_log_item_t	*bip;
+	struct xfs_buf_log_item	*bip;
 
 	ASSERT(bp->b_transp == NULL);
 
+        /*
+	 * The xfs_buf_log_item pointer is stored in b_log_item.  If
+	 * it doesn't have one yet, then allocate one and initialize it.
+	 * The checks to see if one is there are in xfs_buf_item_init().
+	 */
 	xfs_buf_item_init(bp, tp->t_mountp);
 	bip = bp->b_log_item;
+	if (reset_recur)
+		bip->bli_recur = 0;
+
+	/*
+	 * Attach the item to the transaction so we can find it in
+	 * xfs_trans_get_buf() and friends.
+	 */
 	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
 	bp->b_transp = tp;
+
+}
+
+void
+libxfs_trans_bjoin(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	_libxfs_trans_bjoin(tp, bp, 0);
 	trace_xfs_trans_bjoin(bp->b_log_item);
 }
 
@@ -594,9 +625,7 @@ libxfs_trans_get_buf_map(
 	if (bp == NULL)
 		return NULL;
 
-	libxfs_trans_bjoin(tp, bp);
-	bip = bp->b_log_item;
-	bip->bli_recur = 0;
+	_libxfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_get_buf(bp->b_log_item);
 	return bp;
 }
@@ -627,9 +656,7 @@ libxfs_trans_getsb(
 
 	bp = libxfs_getsb(mp, flags);
 
-	libxfs_trans_bjoin(tp, bp);
-	bip = bp->b_log_item;
-	bip->bli_recur = 0;
+	_libxfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_getsb(bp->b_log_item);
 	return bp;
 }
@@ -678,9 +705,7 @@ libxfs_trans_read_buf_map(
 	if (bp->b_error)
 		goto out_relse;
 
-	xfs_trans_bjoin(tp, bp);
-	bip = bp->b_log_item;
-	bip->bli_recur = 0;
+	_libxfs_trans_bjoin(tp, bp, 1);
 done:
 	trace_xfs_trans_read_buf(bp->b_log_item);
 	*bpp = bp;
-- 
1.8.3.1

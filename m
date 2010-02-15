Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1FNXqXm097963 for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 17:33:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 286061D27D1
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 15:35:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FTXt3CeXXkNKFOsB for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2010 15:35:09 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NhAT7-00083Z-HI
	for xfs@oss.sgi.com; Mon, 15 Feb 2010 23:35:09 +0000
Date: Mon, 15 Feb 2010 18:35:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: factor common xfs_trans_bjoin code
Message-ID: <20100215233509.GC28817@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Most of xfs_trans_bjoin is duplicated in xfs_trans_get_buf, xfs_trans_getsb
and xfs_trans_read_buf.  Add a new _xfs_trans_bjoin which can be called
by all four functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2010-02-15 16:38:55.996025054 +0100
+++ xfs/fs/xfs/xfs_trans_buf.c	2010-02-16 00:31:57.930031479 +0100
@@ -46,6 +46,65 @@ STATIC xfs_buf_t *xfs_trans_buf_item_mat
 STATIC xfs_buf_t *xfs_trans_buf_item_match_all(xfs_trans_t *, xfs_buftarg_t *,
 		xfs_daddr_t, int);
 
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
+_xfs_trans_bjoin(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	int			reset_recur)
+{
+	struct xfs_buf_log_item	*bip;
+
+	ASSERT(XFS_BUF_ISBUSY(bp));
+	ASSERT(XFS_BUF_FSPRIVATE2(bp, void *) == NULL);
+
+	/*
+	 * The xfs_buf_log_item pointer is stored in b_fsprivate.  If
+	 * it doesn't have one yet, then allocate one and initialize it.
+	 * The checks to see if one is there are in xfs_buf_item_init().
+	 */
+	xfs_buf_item_init(bp, tp->t_mountp);
+	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
+	ASSERT(!(bip->bli_format.blf_flags & XFS_BLI_CANCEL));
+	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
+	if (reset_recur)
+		bip->bli_recur = 0;
+
+	/*
+	 * Take a reference for this transaction on the buf item.
+	 */
+	atomic_inc(&bip->bli_refcount);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	(void) xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
+
+	/*
+	 * Initialize b_fsprivate2 so we can find it with incore_match()
+	 * in xfs_trans_get_buf() and friends above.
+	 */
+	XFS_BUF_SET_FSPRIVATE2(bp, tp);
+
+}
+
+void
+xfs_trans_bjoin(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	_xfs_trans_bjoin(tp, bp, 0);
+	trace_xfs_trans_bjoin(bp->b_fspriv);
+}
 
 /*
  * Get and lock the buffer for the caller if it is not already
@@ -132,40 +191,8 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 
 	ASSERT(!XFS_BUF_GETERROR(bp));
 
-	/*
-	 * The xfs_buf_log_item pointer is stored in b_fsprivate.  If
-	 * it doesn't have one yet, then allocate one and initialize it.
-	 * The checks to see if one is there are in xfs_buf_item_init().
-	 */
-	xfs_buf_item_init(bp, tp->t_mountp);
-
-	/*
-	 * Set the recursion count for the buffer within this transaction
-	 * to 0.
-	 */
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
-	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLI_CANCEL));
-	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
-	bip->bli_recur = 0;
-
-	/*
-	 * Take a reference for this transaction on the buf item.
-	 */
-	atomic_inc(&bip->bli_refcount);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	(void) xfs_trans_add_item(tp, (xfs_log_item_t*)bip);
-
-	/*
-	 * Initialize b_fsprivate2 so we can find it with incore_match()
-	 * above.
-	 */
-	XFS_BUF_SET_FSPRIVATE2(bp, tp);
-
-	trace_xfs_trans_get_buf(bip);
+	_xfs_trans_bjoin(tp, bp, 1);
+	trace_xfs_trans_get_buf(bp->b_fspriv);
 	return (bp);
 }
 
@@ -210,44 +237,11 @@ xfs_trans_getsb(xfs_trans_t	*tp,
 	}
 
 	bp = xfs_getsb(mp, flags);
-	if (bp == NULL) {
+	if (bp == NULL)
 		return NULL;
-	}
-
-	/*
-	 * The xfs_buf_log_item pointer is stored in b_fsprivate.  If
-	 * it doesn't have one yet, then allocate one and initialize it.
-	 * The checks to see if one is there are in xfs_buf_item_init().
-	 */
-	xfs_buf_item_init(bp, mp);
-
-	/*
-	 * Set the recursion count for the buffer within this transaction
-	 * to 0.
-	 */
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
-	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLI_CANCEL));
-	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
-	bip->bli_recur = 0;
-
-	/*
-	 * Take a reference for this transaction on the buf item.
-	 */
-	atomic_inc(&bip->bli_refcount);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	(void) xfs_trans_add_item(tp, (xfs_log_item_t*)bip);
-
-	/*
-	 * Initialize b_fsprivate2 so we can find it with incore_match()
-	 * above.
-	 */
-	XFS_BUF_SET_FSPRIVATE2(bp, tp);
 
-	trace_xfs_trans_getsb(bip);
+	_xfs_trans_bjoin(tp, bp, 1);
+	trace_xfs_trans_getsb(bp->b_fspriv);
 	return (bp);
 }
 
@@ -425,40 +419,9 @@ xfs_trans_read_buf(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		goto shutdown_abort;
 
-	/*
-	 * The xfs_buf_log_item pointer is stored in b_fsprivate.  If
-	 * it doesn't have one yet, then allocate one and initialize it.
-	 * The checks to see if one is there are in xfs_buf_item_init().
-	 */
-	xfs_buf_item_init(bp, tp->t_mountp);
+	_xfs_trans_bjoin(tp, bp, 1);
+	trace_xfs_trans_read_buf(bp->b_fspriv);
 
-	/*
-	 * Set the recursion count for the buffer within this transaction
-	 * to 0.
-	 */
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
-	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLI_CANCEL));
-	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
-	bip->bli_recur = 0;
-
-	/*
-	 * Take a reference for this transaction on the buf item.
-	 */
-	atomic_inc(&bip->bli_refcount);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	(void) xfs_trans_add_item(tp, (xfs_log_item_t*)bip);
-
-	/*
-	 * Initialize b_fsprivate2 so we can find it with incore_match()
-	 * above.
-	 */
-	XFS_BUF_SET_FSPRIVATE2(bp, tp);
-
-	trace_xfs_trans_read_buf(bip);
 	*bpp = bp;
 	return 0;
 
@@ -623,53 +586,6 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 }
 
 /*
- * Add the locked buffer to the transaction.
- * The buffer must be locked, and it cannot be associated with any
- * transaction.
- *
- * If the buffer does not yet have a buf log item associated with it,
- * then allocate one for it.  Then add the buf item to the transaction.
- */
-void
-xfs_trans_bjoin(xfs_trans_t	*tp,
-		xfs_buf_t	*bp)
-{
-	xfs_buf_log_item_t	*bip;
-
-	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, void *) == NULL);
-
-	/*
-	 * The xfs_buf_log_item pointer is stored in b_fsprivate.  If
-	 * it doesn't have one yet, then allocate one and initialize it.
-	 * The checks to see if one is there are in xfs_buf_item_init().
-	 */
-	xfs_buf_item_init(bp, tp->t_mountp);
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
-	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLI_CANCEL));
-	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
-
-	/*
-	 * Take a reference for this transaction on the buf item.
-	 */
-	atomic_inc(&bip->bli_refcount);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	(void) xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
-
-	/*
-	 * Initialize b_fsprivate2 so we can find it with incore_match()
-	 * in xfs_trans_get_buf() and friends above.
-	 */
-	XFS_BUF_SET_FSPRIVATE2(bp, tp);
-
-	trace_xfs_trans_bjoin(bip);
-}
-
-/*
  * Mark the buffer as not needing to be unlocked when the buf item's
  * IOP_UNLOCK() routine is called.  The buffer must already be locked
  * and associated with the given transaction.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

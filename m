Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 22:13:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7K5DTwK018699
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 22:13:30 -0700
Message-ID: <48ABA9EC.5040902@sgi.com>
Date: Wed, 20 Aug 2008 15:21:48 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Fix use-after-free with buffers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

We have a use-after-free issue where log completions access buffers via the
buffer log item and the buffer has already been freed.  Fix this by taking
a reference on the buffer when attaching the buffer log item and release
the hold when the buffer log item is detached and we no longer need the
buffer.  Also create a new function xfs_buf_item_free() to combine some
common code and move an ASSERT in xfs_buf_rele() so that we can catch more
cases.

===========================================================================
fs/xfs/linux-2.6/xfs_buf.c
===========================================================================

--- a/fs/xfs/linux-2.6/xfs_buf.c	2008-08-20 15:08:23.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_buf.c	2008-08-20 15:14:06.000000000 +1000
@@ -831,6 +831,8 @@ xfs_buf_rele(
 
 	XB_TRACE(bp, "rele", bp->b_relse);
 
+	ASSERT(atomic_read(&bp->b_hold) > 0);
+
 	if (unlikely(!hash)) {
 		ASSERT(!bp->b_relse);
 		if (atomic_dec_and_test(&bp->b_hold))
@@ -838,7 +840,6 @@ xfs_buf_rele(
 		return;
 	}
 
-	ASSERT(atomic_read(&bp->b_hold) > 0);
 	if (atomic_dec_and_lock(&bp->b_hold, &hash->bh_lock)) {
 		if (bp->b_relse) {
 			atomic_inc(&bp->b_hold);

===========================================================================
fs/xfs/xfs_buf_item.c
===========================================================================

--- a/fs/xfs/xfs_buf_item.c	2008-08-20 15:08:23.000000000 +1000
+++ b/fs/xfs/xfs_buf_item.c	2008-08-20 15:14:06.000000000 +1000
@@ -732,6 +732,7 @@ xfs_buf_item_init(
 	bip->bli_item.li_ops = &xfs_buf_item_ops;
 	bip->bli_item.li_mountp = mp;
 	bip->bli_buf = bp;
+	xfs_buf_hold(bp);
 	bip->bli_format.blf_type = XFS_LI_BUF;
 	bip->bli_format.blf_blkno = (__int64_t)XFS_BUF_ADDR(bp);
 	bip->bli_format.blf_len = (ushort)BTOBB(XFS_BUF_COUNT(bp));
@@ -867,6 +868,23 @@ xfs_buf_item_dirty(
 	return (bip->bli_flags & XFS_BLI_DIRTY);
 }
 
+void
+xfs_buf_item_free(
+	xfs_buf_log_item_t	*bip)
+{
+#ifdef XFS_TRANS_DEBUG
+	kmem_free(bip->bli_orig);
+	bip->bli_orig = NULL;
+	kmem_free(bip->bli_logged);
+	bip->bli_logged = NULL;
+#endif /* XFS_TRANS_DEBUG */
+
+#ifdef XFS_BLI_TRACE
+	ktrace_free(bip->bli_trace);
+#endif
+	kmem_zone_free(xfs_buf_item_zone, bip);
+}
+
 /*
  * This is called when the buf log item is no longer needed.  It should
  * free the buf log item associated with the given buffer and clear
@@ -887,18 +905,8 @@ xfs_buf_item_relse(
 	    (XFS_BUF_IODONE_FUNC(bp) != NULL)) {
 		XFS_BUF_CLR_IODONE_FUNC(bp);
 	}
-
-#ifdef XFS_TRANS_DEBUG
-	kmem_free(bip->bli_orig);
-	bip->bli_orig = NULL;
-	kmem_free(bip->bli_logged);
-	bip->bli_logged = NULL;
-#endif /* XFS_TRANS_DEBUG */
-
-#ifdef XFS_BLI_TRACE
-	ktrace_free(bip->bli_trace);
-#endif
-	kmem_zone_free(xfs_buf_item_zone, bip);
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
 }
 
 
@@ -1120,6 +1128,7 @@ xfs_buf_iodone(
 
 	ASSERT(bip->bli_buf == bp);
 
+	xfs_buf_rele(bp);
 	mp = bip->bli_item.li_mountp;
 
 	/*
@@ -1136,18 +1145,7 @@ xfs_buf_iodone(
 	 * xfs_trans_delete_ail() drops the AIL lock.
 	 */
 	xfs_trans_delete_ail(mp, (xfs_log_item_t *)bip);
-
-#ifdef XFS_TRANS_DEBUG
-	kmem_free(bip->bli_orig);
-	bip->bli_orig = NULL;
-	kmem_free(bip->bli_logged);
-	bip->bli_logged = NULL;
-#endif /* XFS_TRANS_DEBUG */
-
-#ifdef XFS_BLI_TRACE
-	ktrace_free(bip->bli_trace);
-#endif
-	kmem_zone_free(xfs_buf_item_zone, bip);
+	xfs_buf_item_free(bip);
 }
 
 #if defined(XFS_BLI_TRACE)

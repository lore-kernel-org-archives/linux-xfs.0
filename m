Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Sep 2008 22:56:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m825u87W013384
	for <xfs@oss.sgi.com>; Mon, 1 Sep 2008 22:56:08 -0700
Message-ID: <48BCD79B.1070100@sgi.com>
Date: Tue, 02 Sep 2008 16:05:15 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH V2] Fix use-after-free with buffers
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

--- a/fs/xfs/xfs_buf_item.c	2008-09-02 15:56:20.000000000 +1000
+++ b/fs/xfs/xfs_buf_item.c	2008-08-22 13:23:53.000000000 +1000
@@ -732,6 +732,7 @@ xfs_buf_item_init(
 	bip->bli_item.li_ops = &xfs_buf_item_ops;
 	bip->bli_item.li_mountp = mp;
 	bip->bli_buf = bp;
+	xfs_buf_hold(bp);
 	bip->bli_format.blf_type = XFS_LI_BUF;
 	bip->bli_format.blf_blkno = (__int64_t)XFS_BUF_ADDR(bp);
 	bip->bli_format.blf_len = (ushort)BTOBB(XFS_BUF_COUNT(bp));
@@ -867,6 +868,21 @@ xfs_buf_item_dirty(
 	return (bip->bli_flags & XFS_BLI_DIRTY);
 }
 
+void
+xfs_buf_item_free(
+	xfs_buf_log_item_t	*bip)
+{
+#ifdef XFS_TRANS_DEBUG
+	kmem_free(bip->bli_orig);
+	kmem_free(bip->bli_logged);
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
@@ -887,18 +903,8 @@ xfs_buf_item_relse(
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
 
 
@@ -1120,6 +1126,7 @@ xfs_buf_iodone(
 
 	ASSERT(bip->bli_buf == bp);
 
+	xfs_buf_rele(bp);
 	mp = bip->bli_item.li_mountp;
 
 	/*
@@ -1136,18 +1143,7 @@ xfs_buf_iodone(
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

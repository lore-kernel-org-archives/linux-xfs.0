Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfGLVeW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jul 2019 17:34:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A8021804F2
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 21:34:21 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 79ADB60A9A
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 21:34:21 +0000 (UTC)
Subject: [PATCH 1/4] xfsprogs: reorder functions in libxfs/trans.c
References: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <5cfffec2-092e-5409-e89f-48b5fd905ac2@redhat.com>
Date: Fri, 12 Jul 2019 16:34:20 -0500
MIME-Version: 1.0
In-Reply-To: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This puts these functions in libxfs/trans.c in the same order as
they appear in kernelspace xfs_trans_buf.c for easier comparison.

No functional changes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/trans.c b/libxfs/trans.c
index 5c56b4fe..8954f0fe 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -330,80 +330,6 @@ libxfs_trans_cancel(
 	xfs_trans_free(tp);
 }
 
-void
-libxfs_trans_inode_alloc_buf(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
-{
-	xfs_buf_log_item_t	*bip = bp->b_log_item;
-
-	ASSERT(bp->b_transp == tp);
-	ASSERT(bip != NULL);
-	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
-	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
-}
-
-/*
- * Mark a buffer dirty in the transaction.
- */
-void
-libxfs_trans_dirty_buf(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	ASSERT(bp->b_transp == tp);
-	ASSERT(bip != NULL);
-
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
-}
-
-/*
- * This is called to mark bytes first through last inclusive of the given
- * buffer as needing to be logged when the transaction is committed.
- * The buffer must already be associated with the given transaction.
- *
- * First and last are numbers relative to the beginning of this buffer,
- * so the first byte in the buffer is numbered 0 regardless of the
- * value of b_blkno.
- */
-void
-libxfs_trans_log_buf(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp,
-	uint			first,
-	uint			last)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	ASSERT((first <= last) && (last < bp->b_bcount));
-
-	xfs_trans_dirty_buf(tp, bp);
-	xfs_buf_item_log(bip, first, last);
-}
-
-/*
- * For userspace, ordered buffers just need to be marked dirty so
- * the transaction commit will write them and mark them up-to-date.
- * In essence, they are just like any other logged buffer in userspace.
- *
- * If the buffer is already dirty, trigger the "already logged" return condition.
- */
-bool
-libxfs_trans_ordered_buf(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-	bool			ret;
-
-	ret = test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
-	libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount);
-	return ret;
-}
-
 static void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
@@ -414,63 +340,7 @@ xfs_buf_item_put(
 	kmem_zone_free(xfs_buf_item_zone, bip);
 }
 
-void
-libxfs_trans_brelse(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
-{
-	xfs_buf_log_item_t	*bip;
-
-	if (tp == NULL) {
-		ASSERT(bp->b_transp == NULL);
-		libxfs_putbuf(bp);
-		return;
-	}
-
-	trace_xfs_trans_brelse(bip);
-	ASSERT(bp->b_transp == tp);
-	bip = bp->b_log_item;
-	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
-	if (bip->bli_recur > 0) {
-		bip->bli_recur--;
-		return;
-	}
-	/* If dirty/stale, can't release till transaction committed */
-	if (bip->bli_flags & XFS_BLI_STALE)
-		return;
-	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
-		return;
-	xfs_trans_del_item(&bip->bli_item);
-	if (bip->bli_flags & XFS_BLI_HOLD)
-		bip->bli_flags &= ~XFS_BLI_HOLD;
-	xfs_buf_item_put(bip);
-	bp->b_transp = NULL;
-	libxfs_putbuf(bp);
-}
-
-void
-libxfs_trans_binval(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
-{
-	xfs_buf_log_item_t	*bip = bp->b_log_item;
-
-	ASSERT(bp->b_transp == tp);
-	ASSERT(bip != NULL);
-
-	trace_xfs_trans_binval(bip);
-
-	if (bip->bli_flags & XFS_BLI_STALE)
-		return;
-	XFS_BUF_UNDELAYWRITE(bp);
-	xfs_buf_stale(bp);
-	bip->bli_flags |= XFS_BLI_STALE;
-	bip->bli_flags &= ~XFS_BLI_DIRTY;
-	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
-	bip->__bli_format.blf_flags |= XFS_BLF_CANCEL;
-	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
-	tp->t_flags |= XFS_TRANS_DIRTY;
-}
+/* from xfs_trans_buf.c */
 
 /*
  * Add the locked buffer to the transaction.
@@ -519,20 +389,6 @@ libxfs_trans_bjoin(
 	trace_xfs_trans_bjoin(bp->b_log_item);
 }
 
-void
-libxfs_trans_bhold(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
-{
-	xfs_buf_log_item_t	*bip = bp->b_log_item;
-
-	ASSERT(bp->b_transp == tp);
-	ASSERT(bip != NULL);
-
-	bip->bli_flags |= XFS_BLI_HOLD;
-	trace_xfs_trans_bhold(bip);
-}
-
 xfs_buf_t *
 libxfs_trans_get_buf_map(
 	xfs_trans_t		*tp,
@@ -651,6 +507,160 @@ out_relse:
 	return error;
 }
 
+void
+libxfs_trans_brelse(
+	xfs_trans_t		*tp,
+	xfs_buf_t		*bp)
+{
+	xfs_buf_log_item_t	*bip;
+
+	if (tp == NULL) {
+		ASSERT(bp->b_transp == NULL);
+		libxfs_putbuf(bp);
+		return;
+	}
+
+	trace_xfs_trans_brelse(bip);
+	ASSERT(bp->b_transp == tp);
+	bip = bp->b_log_item;
+	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
+	if (bip->bli_recur > 0) {
+		bip->bli_recur--;
+		return;
+	}
+	/* If dirty/stale, can't release till transaction committed */
+	if (bip->bli_flags & XFS_BLI_STALE)
+		return;
+	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
+		return;
+	xfs_trans_del_item(&bip->bli_item);
+	if (bip->bli_flags & XFS_BLI_HOLD)
+		bip->bli_flags &= ~XFS_BLI_HOLD;
+	xfs_buf_item_put(bip);
+	bp->b_transp = NULL;
+	libxfs_putbuf(bp);
+}
+
+/*
+ * Mark the buffer as not needing to be unlocked when the buf item's
+ * iop_unlock() routine is called.  The buffer must already be locked
+ * and associated with the given transaction.
+ */
+/* ARGSUSED */
+void
+libxfs_trans_bhold(
+	xfs_trans_t		*tp,
+	xfs_buf_t		*bp)
+{
+	xfs_buf_log_item_t	*bip = bp->b_log_item;
+
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip != NULL);
+
+	bip->bli_flags |= XFS_BLI_HOLD;
+	trace_xfs_trans_bhold(bip);
+}
+
+/*
+ * Mark a buffer dirty in the transaction.
+ */
+void
+libxfs_trans_dirty_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip != NULL);
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
+}
+
+/*
+ * This is called to mark bytes first through last inclusive of the given
+ * buffer as needing to be logged when the transaction is committed.
+ * The buffer must already be associated with the given transaction.
+ *
+ * First and last are numbers relative to the beginning of this buffer,
+ * so the first byte in the buffer is numbered 0 regardless of the
+ * value of b_blkno.
+ */
+void
+libxfs_trans_log_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	uint			first,
+	uint			last)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
+	ASSERT((first <= last) && (last < bp->b_bcount));
+
+	xfs_trans_dirty_buf(tp, bp);
+	xfs_buf_item_log(bip, first, last);
+}
+
+void
+libxfs_trans_binval(
+	xfs_trans_t		*tp,
+	xfs_buf_t		*bp)
+{
+	xfs_buf_log_item_t	*bip = bp->b_log_item;
+
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip != NULL);
+
+	trace_xfs_trans_binval(bip);
+
+	if (bip->bli_flags & XFS_BLI_STALE)
+		return;
+	XFS_BUF_UNDELAYWRITE(bp);
+	xfs_buf_stale(bp);
+	bip->bli_flags |= XFS_BLI_STALE;
+	bip->bli_flags &= ~XFS_BLI_DIRTY;
+	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
+	bip->__bli_format.blf_flags |= XFS_BLF_CANCEL;
+	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
+	tp->t_flags |= XFS_TRANS_DIRTY;
+}
+
+void
+libxfs_trans_inode_alloc_buf(
+	xfs_trans_t		*tp,
+	xfs_buf_t		*bp)
+{
+	xfs_buf_log_item_t	*bip = bp->b_log_item;
+
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip != NULL);
+	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
+}
+
+/*
+ * For userspace, ordered buffers just need to be marked dirty so
+ * the transaction commit will write them and mark them up-to-date.
+ * In essence, they are just like any other logged buffer in userspace.
+ *
+ * If the buffer is already dirty, trigger the "already logged" return condition.
+ */
+bool
+libxfs_trans_ordered_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	bool			ret;
+
+	ret = test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
+	libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount);
+	return ret;
+}
+
+/* end of xfs_trans_buf.c */
+
 /*
  * Record the indicated change to the given field for application
  * to the file system's superblock when the transaction commits.

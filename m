Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752339AbdHNQyx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Aug 2017 12:54:53 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EF2C0CCB66
        for <linux-xfs@vger.kernel.org>; Mon, 14 Aug 2017 16:54:52 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA90B60600
        for <linux-xfs@vger.kernel.org>; Mon, 14 Aug 2017 16:54:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 1/2] xfs: refactor buffer logging into buffer dirtying helper
Date: Mon, 14 Aug 2017 12:54:50 -0400
Message-Id: <20170814165451.43788-2-bfoster@redhat.com>
In-Reply-To: <20170814165451.43788-1-bfoster@redhat.com>
References: <20170814165451.43788-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_trans_log_buf() is responsible for logging the dirty segments of
a buffer along with setting all of the necessary state on the
transaction, buffer, bli, etc., to ensure that the associated items
are marked as dirty and prepared for I/O. We have a couple use cases
that need to to dirty a buffer in a transaction without actually
logging dirty ranges of the buffer.  One existing use case is
ordered buffers, which are currently logged with arbitrary ranges to
accomplish this even though the content of ordered buffers is never
written to the log. Another pending use case is to relog an already
dirty buffer across rolled transactions within the deferred
operations infrastructure. This is required to prevent a held
(XFS_BLI_HOLD) buffer from pinning the tail of the log.

Refactor xfs_trans_log_buf() into a new function that contains all
of the logic responsible to dirty the transaction, lidp, buffer and
bli. This new function can be used in the future for the use cases
outlined above. This patch does not introduce functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans.h     |  4 +++-
 fs/xfs/xfs_trans_buf.c | 46 ++++++++++++++++++++++++++++++----------------
 2 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6bdad6f..a9c4404 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -213,7 +213,9 @@ void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
-void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
+void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
+				  uint);
+void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 
 void		xfs_extent_free_init_defer_op(void);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 86987d8..58818a0 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -493,25 +493,17 @@ xfs_trans_bhold_release(xfs_trans_t	*tp,
 }
 
 /*
- * This is called to mark bytes first through last inclusive of the given
- * buffer as needing to be logged when the transaction is committed.
- * The buffer must already be associated with the given transaction.
- *
- * First and last are numbers relative to the beginning of this buffer,
- * so the first byte in the buffer is numbered 0 regardless of the
- * value of b_blkno.
+ * Mark a buffer dirty in the transaction.
  */
 void
-xfs_trans_log_buf(xfs_trans_t	*tp,
-		  xfs_buf_t	*bp,
-		  uint		first,
-		  uint		last)
+xfs_trans_dirty_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
 {
-	xfs_buf_log_item_t	*bip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(first <= last && last < BBTOB(bp->b_length));
 	ASSERT(bp->b_iodone == NULL ||
 	       bp->b_iodone == xfs_buf_iodone_callbacks);
 
@@ -531,8 +523,6 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	bp->b_iodone = xfs_buf_iodone_callbacks;
 	bip->bli_item.li_cb = xfs_buf_iodone;
 
-	trace_xfs_trans_log_buf(bip);
-
 	/*
 	 * If we invalidated the buffer within this transaction, then
 	 * cancel the invalidation now that we're dirtying the buffer
@@ -545,15 +535,39 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 		bp->b_flags &= ~XBF_STALE;
 		bip->__bli_format.blf_flags &= ~XFS_BLF_CANCEL;
 	}
+	bip->bli_flags |= XFS_BLI_DIRTY | XFS_BLI_LOGGED;
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
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
+xfs_trans_log_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	uint			first,
+	uint			last)
+{
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+
+	ASSERT(first <= last && last < BBTOB(bp->b_length));
+
+	xfs_trans_dirty_buf(tp, bp);
 
 	/*
 	 * If we have an ordered buffer we are not logging any dirty range but
 	 * it still needs to be marked dirty and that it has been logged.
 	 */
-	bip->bli_flags |= XFS_BLI_DIRTY | XFS_BLI_LOGGED;
+	trace_xfs_trans_log_buf(bip);
 	if (!(bip->bli_flags & XFS_BLI_ORDERED))
 		xfs_buf_item_log(bip, first, last);
 }
-- 
2.9.4


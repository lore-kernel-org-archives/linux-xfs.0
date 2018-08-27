Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727113AbeH0SMl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Aug 2018 14:12:41 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B2AB40201BE
        for <linux-xfs@vger.kernel.org>; Mon, 27 Aug 2018 14:25:49 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9B1F100727E
        for <linux-xfs@vger.kernel.org>; Mon, 27 Aug 2018 14:25:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/3] xfs: clean up xfs_trans_brelse()
Date: Mon, 27 Aug 2018 10:25:47 -0400
Message-Id: <20180827142548.45029-3-bfoster@redhat.com>
In-Reply-To: <20180827142548.45029-1-bfoster@redhat.com>
References: <20180827142548.45029-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_trans_brelse() is a bit of a historical mess, similar to
xfs_buf_item_unlock(). It is unnecessarily verbose, has snippets of
commented out code, inconsistency with regard to stale items, etc.

Clean up xfs_trans_brelse() to use similar logic and flow as
xfs_buf_item_unlock() with regard to bli reference count handling.
This patch makes no functional changes, but facilitates further
refactoring of the common bli reference count handling code.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans_buf.c | 108 +++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 70 deletions(-)

diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 15919f67a88f..92a708cdfee3 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -322,49 +322,40 @@ xfs_trans_read_buf_map(
 }
 
 /*
- * Release the buffer bp which was previously acquired with one of the
- * xfs_trans_... buffer allocation routines if the buffer has not
- * been modified within this transaction.  If the buffer is modified
- * within this transaction, do decrement the recursion count but do
- * not release the buffer even if the count goes to 0.  If the buffer is not
- * modified within the transaction, decrement the recursion count and
- * release the buffer if the recursion count goes to 0.
+ * Release a buffer previously joined to the transaction. If the buffer is
+ * modified within this transaction, decrement the recursion count but do not
+ * release the buffer even if the count goes to 0. If the buffer is not modified
+ * within the transaction, decrement the recursion count and release the buffer
+ * if the recursion count goes to 0.
  *
- * If the buffer is to be released and it was not modified before
- * this transaction began, then free the buf_log_item associated with it.
+ * If the buffer is to be released and it was not already dirty before this
+ * transaction began, then also free the buf_log_item associated with it.
  *
- * If the transaction pointer is NULL, make this just a normal
- * brelse() call.
+ * If the transaction pointer is NULL, this is a normal xfs_buf_relse() call.
  */
 void
 xfs_trans_brelse(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip;
-	int			freed;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	bool			freed;
+	bool			dirty;
 
-	/*
-	 * Default to a normal brelse() call if the tp is NULL.
-	 */
-	if (tp == NULL) {
-		ASSERT(bp->b_transp == NULL);
+	ASSERT(bp->b_transp == tp);
+
+	if (!tp) {
 		xfs_buf_relse(bp);
 		return;
 	}
 
-	ASSERT(bp->b_transp == tp);
-	bip = bp->b_log_item;
+	trace_xfs_trans_brelse(bip);
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
-	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
-	trace_xfs_trans_brelse(bip);
-
 	/*
-	 * If the release is just for a recursive lock,
-	 * then decrement the count and return.
+	 * If the release is for a recursive lookup, then decrement the count
+	 * and return.
 	 */
 	if (bip->bli_recur > 0) {
 		bip->bli_recur--;
@@ -372,63 +363,40 @@ xfs_trans_brelse(
 	}
 
 	/*
-	 * If the buffer is dirty within this transaction, we can't
+	 * If the buffer is invalidated or dirty in this transaction, we can't
 	 * release it until we commit.
 	 */
 	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
 		return;
-
-	/*
-	 * If the buffer has been invalidated, then we can't release
-	 * it until the transaction commits to disk unless it is re-dirtied
-	 * as part of this transaction.  This prevents us from pulling
-	 * the item from the AIL before we should.
-	 */
 	if (bip->bli_flags & XFS_BLI_STALE)
 		return;
 
-	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
-
 	/*
-	 * Free up the log item descriptor tracking the released item.
+	 * Unlink the log item from the transaction and clear the hold flag, if
+	 * set. We wouldn't want the next user of the buffer to get confused.
 	 */
+	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
 	xfs_trans_del_item(&bip->bli_item);
-
-	/*
-	 * Clear the hold flag in the buf log item if it is set.
-	 * We wouldn't want the next user of the buffer to
-	 * get confused.
-	 */
-	if (bip->bli_flags & XFS_BLI_HOLD) {
+	if (bip->bli_flags & XFS_BLI_HOLD)
 		bip->bli_flags &= ~XFS_BLI_HOLD;
-	}
 
 	/*
-	 * Drop our reference to the buf log item.
+	 * Drop the reference to the bli. At this point, the bli must be either
+	 * freed or dirty (or both). If freed, there are a couple cases where we
+	 * are responsible to free the item. If the bli is clean, we're the last
+	 * user of it. If the fs has shut down, the bli may be dirty and AIL
+	 * resident, but won't ever be written back.
 	 */
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-
-	/*
-	 * If the buf item is not tracking data in the log, then we must free it
-	 * before releasing the buffer back to the free pool.
-	 *
-	 * If the fs has shutdown and we dropped the last reference, it may fall
-	 * on us to release a (possibly dirty) bli if it never made it to the
-	 * AIL (e.g., the aborted unpin already happened and didn't release it
-	 * due to our reference). Since we're already shutdown and need
-	 * ail_lock, just force remove from the AIL and release the bli here.
-	 */
-	if (XFS_FORCED_SHUTDOWN(tp->t_mountp) && freed) {
-		xfs_trans_ail_remove(&bip->bli_item, SHUTDOWN_LOG_IO_ERROR);
-		xfs_buf_item_relse(bp);
-	} else if (!(bip->bli_flags & XFS_BLI_DIRTY)) {
-/***
-		ASSERT(bp->b_pincount == 0);
-***/
-		ASSERT(atomic_read(&bip->bli_refcount) == 0);
-		ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-		ASSERT(!(bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF));
-		xfs_buf_item_relse(bp);
+	dirty = bip->bli_flags & XFS_BLI_DIRTY;
+	ASSERT(freed || dirty);
+	if (freed) {
+		bool abort = XFS_FORCED_SHUTDOWN(tp->t_mountp);
+		ASSERT(abort || !test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+		if (abort)
+			xfs_trans_ail_remove(&bip->bli_item, SHUTDOWN_LOG_IO_ERROR);
+		if (!dirty || abort)
+			xfs_buf_item_relse(bp);
 	}
 
 	bp->b_transp = NULL;
-- 
2.17.1

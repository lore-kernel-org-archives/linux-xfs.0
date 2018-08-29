Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46654 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727245AbeH2VYc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Aug 2018 17:24:32 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 171898076895
        for <linux-xfs@vger.kernel.org>; Wed, 29 Aug 2018 17:26:35 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF7C82166BA1
        for <linux-xfs@vger.kernel.org>; Wed, 29 Aug 2018 17:26:34 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 1/3] xfs: don't unlock invalidated buf on aborted tx commit
Date: Wed, 29 Aug 2018 13:26:32 -0400
Message-Id: <20180829172634.57981-2-bfoster@redhat.com>
In-Reply-To: <20180829172634.57981-1-bfoster@redhat.com>
References: <20180829172634.57981-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfstests generic/388,475 occasionally reproduce assertion failures
in xfs_buf_item_unpin() when the final bli reference is dropped on
an invalidated buffer and the buffer is not locked as it is expected
to be. Invalidated buffers should remain locked on transaction
commit until the final unpin, at which point the buffer is removed
from the AIL and the bli is freed since stale buffers are not
written back.

The assert failures are associated with filesystem shutdown,
typically due to log I/O errors injected by the test. The
problematic situation can occur if the shutdown happens to cause a
race between an active transaction that has invalidated a particular
buffer and an I/O error on a log buffer that contains the bli
associated with the same (now stale) buffer.

Both transaction and log contexts acquire a bli reference. If the
transaction has already invalidated the buffer by the time the I/O
error occurs and ends up aborting due to shutdown, the transaction
and log hold the last two references to a stale bli. If the
transaction cancel occurs first, it treats the buffer as non-stale
due to the aborted state: the bli reference is dropped and the
buffer is released/unlocked. The log buffer I/O error handling
eventually calls into xfs_buf_item_unpin(), drops the final
reference to the bli and treats it as stale. The buffer wasn't left
locked by xfs_buf_item_unlock(), however, so the assert fails and
the buffer is double unlocked. The latter problem is mitigated by
the fact that the fs is shutdown and no further damage is possible.

->iop_unlock() of an invalidated buffer should behave consistently
with respect to the bli refcount, regardless of aborted state. If
the refcount remains elevated on commit, we know the bli is awaiting
an unpin (since it can't be in another transaction) and will be
handled appropriately on log buffer completion. If the final bli
reference of an invalidated buffer is dropped in ->iop_unlock(), we
can assume the transaction has aborted because invalidation implies
a dirty transaction. In the non-abort case, the log would have
acquired a bli reference in ->iop_pin() and prevented bli release at
->iop_unlock() time. In the abort case the item must be freed and
buffer unlocked because it wasn't pinned by the log.

Rework xfs_buf_item_unlock() to simplify the currently circuitous
and duplicate logic and leave invalidated buffers locked based on
bli refcount, regardless of aborted state. This ensures that a
pinned, stale buffer is always found locked when eventually
unpinned.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 92 ++++++++++++++++++++-----------------------
 fs/xfs/xfs_trace.h    |  1 -
 2 files changed, 42 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1c9d1398980b..b39d1b5320e7 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -556,73 +556,65 @@ xfs_buf_item_unlock(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
+	bool			freed;
 	bool			aborted;
-	bool			hold = !!(bip->bli_flags & XFS_BLI_HOLD);
-	bool			dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
+	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
+	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
+	bool			stale = bip->bli_flags & XFS_BLI_STALE;
 #if defined(DEBUG) || defined(XFS_WARN)
-	bool			ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
+	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
 #endif
-
-	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags);
-
-	/* Clear the buffer's association with this transaction. */
-	bp->b_transp = NULL;
-
-	/*
-	 * The per-transaction state has been copied above so clear it from the
-	 * bli.
-	 */
-	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
-
-	/*
-	 * If the buf item is marked stale, then don't do anything.  We'll
-	 * unlock the buffer and free the buf item when the buffer is unpinned
-	 * for the last time.
-	 */
-	if (bip->bli_flags & XFS_BLI_STALE) {
-		trace_xfs_buf_item_unlock_stale(bip);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		if (!aborted) {
-			atomic_dec(&bip->bli_refcount);
-			return;
-		}
-	}
-
 	trace_xfs_buf_item_unlock(bip);
 
 	/*
-	 * If the buf item isn't tracking any data, free it, otherwise drop the
-	 * reference we hold to it. If we are aborting the transaction, this may
-	 * be the only reference to the buf item, so we free it anyway
-	 * regardless of whether it is dirty or not. A dirty abort implies a
-	 * shutdown, anyway.
-	 *
 	 * The bli dirty state should match whether the blf has logged segments
 	 * except for ordered buffers, where only the bli should be dirty.
 	 */
 	ASSERT((!ordered && dirty == xfs_buf_item_dirty_format(bip)) ||
 	       (ordered && dirty && !xfs_buf_item_dirty_format(bip)));
+	ASSERT(!stale || (bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
+
+	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags);
 
 	/*
-	 * Clean buffers, by definition, cannot be in the AIL. However, aborted
-	 * buffers may be in the AIL regardless of dirty state. An aborted
-	 * transaction that invalidates a buffer already in the AIL may have
-	 * marked it stale and cleared the dirty state, for example.
-	 *
-	 * Therefore if we are aborting a buffer and we've just taken the last
-	 * reference away, we have to check if it is in the AIL before freeing
-	 * it. We need to free it in this case, because an aborted transaction
-	 * has already shut the filesystem down and this is the last chance we
-	 * will have to do so.
+	 * Clear the buffer's association with this transaction and
+	 * per-transaction state from the bli, which has been copied above.
+	 */
+	bp->b_transp = NULL;
+	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
+
+	/*
+	 * Drop the transaction's bli reference and deal with the item if we had
+	 * the last one. We must free the item if clean or aborted since it
+	 * wasn't pinned by the log and this is the last chance to do so. If the
+	 * bli is freed and dirty (but non-aborted), the buffer was not dirty in
+	 * this transaction but modified by a previous one and still awaiting
+	 * writeback. In that case, the bli is freed on buffer writeback
+	 * completion.
 	 */
-	if (atomic_dec_and_test(&bip->bli_refcount)) {
-		if (aborted) {
-			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
+	freed = atomic_dec_and_test(&bip->bli_refcount);
+	if (freed) {
+		ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
+		/*
+		 * An aborted item may be in the AIL regardless of dirty state.
+		 * For example, consider an aborted transaction that invalidated
+		 * a dirty bli and cleared the dirty state.
+		 */
+		if (aborted)
 			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
+		if (aborted || !dirty)
 			xfs_buf_item_relse(bp);
-		} else if (!dirty)
-			xfs_buf_item_relse(bp);
+	} else if (stale) {
+		/*
+		 * Stale buffers remain locked until final unpin unless the bli
+		 * was freed in the branch above. A freed stale bli implies an
+		 * abort because buffer invalidation dirties the bli and
+		 * transaction.
+		 */
+		ASSERT(!freed);
+		return;
 	}
+	ASSERT(!stale || (aborted && freed));
 
 	if (!hold)
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ad315e83bc02..3043e5ed6495 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -473,7 +473,6 @@ DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pin);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin_stale);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock_stale);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_committed);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_push);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf);
-- 
2.17.1

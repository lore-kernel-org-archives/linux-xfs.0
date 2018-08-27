Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727299AbeH0SMl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Aug 2018 14:12:41 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2995D87A50
        for <linux-xfs@vger.kernel.org>; Mon, 27 Aug 2018 14:25:49 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1269B100727E
        for <linux-xfs@vger.kernel.org>; Mon, 27 Aug 2018 14:25:49 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/3] xfs: refactor xfs_buf_log_item reference count handling
Date: Mon, 27 Aug 2018 10:25:48 -0400
Message-Id: <20180827142548.45029-4-bfoster@redhat.com>
In-Reply-To: <20180827142548.45029-1-bfoster@redhat.com>
References: <20180827142548.45029-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The xfs_buf_log_item structure has a reference counter with slightly
tricky semantics. In the common case, a buffer is logged and
committed in a transaction, committed to the on-disk log (added to
the AIL) and then finally written back and removed from the AIL. The
bli refcount covers two potentially overlapping timeframes:

 1. the bli is held in an active transaction
 2. the bli is pinned by the log

The caveat to this approach is that the reference counter does not
purely dictate the lifetime of the bli. IOW, when a dirty buffer is
physically logged and unpinned, the bli refcount may go to zero as
the log item is inserted into the AIL. Only once the buffer is
written back can the bli finally be freed.

The above semantics means that it is not enough for the various
refcount decrementing contexts to release the bli on decrement to
zero. xfs_trans_brelse(), transaction commit (->iop_unlock()) and
unpin (->iop_unpin()) must all drop the associated reference and
make additional checks to determine if the current context is
responsible for freeing the item.

For example, if a transaction holds but does not dirty a particular
bli, the commit may drop the refcount to zero. If the bli itself is
clean, it is also not AIL resident and must be freed at this time.
The same is true for xfs_trans_brelse(). If the transaction dirties
a bli and then aborts or an unpin results in an abort due to a log
I/O error, the last reference count holder is expected to explicitly
remove the item from the AIL and release it (since an abort means
filesystem shutdown and metadata writeback will never occur).

This leads to fairly complex checks being replicated in a few
different places. Since ->iop_unlock() and xfs_trans_brelse() are
nearly identical, refactor the logic into a common helper that
implements and documents the semantics in one place. This patch does
not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c  | 85 ++++++++++++++++++++++++------------------
 fs/xfs/xfs_buf_item.h  |  1 +
 fs/xfs/xfs_trans_buf.c | 22 +----------
 3 files changed, 51 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index b39d1b5320e7..d0191451fe18 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -556,13 +556,12 @@ xfs_buf_item_unlock(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	bool			freed;
-	bool			aborted;
+	bool			released;
 	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
-	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	bool			stale = bip->bli_flags & XFS_BLI_STALE;
 #if defined(DEBUG) || defined(XFS_WARN)
 	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
+	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
 #endif
 	trace_xfs_buf_item_unlock(bip);
 
@@ -574,8 +573,6 @@ xfs_buf_item_unlock(
 	       (ordered && dirty && !xfs_buf_item_dirty_format(bip)));
 	ASSERT(!stale || (bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
 
-	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags);
-
 	/*
 	 * Clear the buffer's association with this transaction and
 	 * per-transaction state from the bli, which has been copied above.
@@ -584,40 +581,16 @@ xfs_buf_item_unlock(
 	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
 
 	/*
-	 * Drop the transaction's bli reference and deal with the item if we had
-	 * the last one. We must free the item if clean or aborted since it
-	 * wasn't pinned by the log and this is the last chance to do so. If the
-	 * bli is freed and dirty (but non-aborted), the buffer was not dirty in
-	 * this transaction but modified by a previous one and still awaiting
-	 * writeback. In that case, the bli is freed on buffer writeback
-	 * completion.
+	 * Unref the item and unlock the buffer unless held or stale. Stale
+	 * buffers remain locked until final unpin unless the bli is freed by
+	 * the unref call. The latter implies shutdown because buffer
+	 * invalidation dirties the bli and transaction.
 	 */
-	freed = atomic_dec_and_test(&bip->bli_refcount);
-	if (freed) {
-		ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
-		/*
-		 * An aborted item may be in the AIL regardless of dirty state.
-		 * For example, consider an aborted transaction that invalidated
-		 * a dirty bli and cleared the dirty state.
-		 */
-		if (aborted)
-			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
-		if (aborted || !dirty)
-			xfs_buf_item_relse(bp);
-	} else if (stale) {
-		/*
-		 * Stale buffers remain locked until final unpin unless the bli
-		 * was freed in the branch above. A freed stale bli implies an
-		 * abort because buffer invalidation dirties the bli and
-		 * transaction.
-		 */
-		ASSERT(!freed);
+	released = xfs_buf_item_unref(bip);
+	if ((stale && !released) || hold)
 		return;
-	}
-	ASSERT(!stale || (aborted && freed));
-
-	if (!hold)
-		xfs_buf_relse(bp);
+	ASSERT(!stale || test_bit(XFS_LI_ABORTED, &lip->li_flags));
+	xfs_buf_relse(bp);
 }
 
 /*
@@ -951,6 +924,44 @@ xfs_buf_item_relse(
 	xfs_buf_item_free(bip);
 }
 
+bool
+xfs_buf_item_unref(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_log_item	*lip = &bip->bli_item;
+	bool			aborted;
+	bool			dirty;
+	bool			freed;
+
+	/* drop the bli ref and return if it wasn't the last one */
+	freed = atomic_dec_and_test(&bip->bli_refcount);
+	if (!freed)
+		return false;
+
+	/*
+	 * We dropped the last ref and must free the item if clean or aborted.
+	 * If the bli is dirty and non-aborted, the buffer was clean in the
+	 * transaction but still awaiting writeback from previous changes. In
+	 * that case, the bli is freed on buffer writeback completion.
+	 */
+	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
+		  XFS_FORCED_SHUTDOWN(lip->li_mountp);
+	dirty = bip->bli_flags & XFS_BLI_DIRTY;
+	if (!aborted && dirty)
+		return false;
+
+	/*
+	 * The bli is aborted or clean. An aborted item may be in the AIL
+	 * regardless of dirty state.  For example, consider an aborted
+	 * transaction that invalidated a dirty bli and cleared the dirty
+	 * state.
+	 */
+	if (aborted)
+		xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip->bli_buf);
+	return true;
+}
+
 
 /*
  * Add the given log item with its callback to the list of callbacks
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 3f7d7b72e7e6..ac5663955daf 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -51,6 +51,7 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_relse(struct xfs_buf *);
+bool	xfs_buf_item_unref(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_attach_iodone(struct xfs_buf *,
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 92a708cdfee3..4a16db972518 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -339,8 +339,6 @@ xfs_trans_brelse(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
-	bool			freed;
-	bool			dirty;
 
 	ASSERT(bp->b_transp == tp);
 
@@ -380,24 +378,8 @@ xfs_trans_brelse(
 	if (bip->bli_flags & XFS_BLI_HOLD)
 		bip->bli_flags &= ~XFS_BLI_HOLD;
 
-	/*
-	 * Drop the reference to the bli. At this point, the bli must be either
-	 * freed or dirty (or both). If freed, there are a couple cases where we
-	 * are responsible to free the item. If the bli is clean, we're the last
-	 * user of it. If the fs has shut down, the bli may be dirty and AIL
-	 * resident, but won't ever be written back.
-	 */
-	freed = atomic_dec_and_test(&bip->bli_refcount);
-	dirty = bip->bli_flags & XFS_BLI_DIRTY;
-	ASSERT(freed || dirty);
-	if (freed) {
-		bool abort = XFS_FORCED_SHUTDOWN(tp->t_mountp);
-		ASSERT(abort || !test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-		if (abort)
-			xfs_trans_ail_remove(&bip->bli_item, SHUTDOWN_LOG_IO_ERROR);
-		if (!dirty || abort)
-			xfs_buf_item_relse(bp);
-	}
+	/* drop the reference to the bli */
+	xfs_buf_item_unref(bip);
 
 	bp->b_transp = NULL;
 	xfs_buf_relse(bp);
-- 
2.17.1

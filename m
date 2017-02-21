Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56060 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbdBUPtS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Feb 2017 10:49:18 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 2/7] fs, xfs: convert xfs_buf.b_hold and xfs_buf.b_lru_ref from atomic_t to refcount_t
Date: Tue, 21 Feb 2017 17:49:02 +0200
Message-Id: <1487692147-17066-3-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
References: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, darrick.wong@oracle.com, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/xfs/xfs_buf.c   | 35 ++++++++++++++++++-----------------
 fs/xfs/xfs_buf.h   |  7 ++++---
 fs/xfs/xfs_trace.h |  8 ++++----
 3 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8c7d01b..21a09c1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -151,12 +151,12 @@ xfs_buf_stale(
 	xfs_buf_ioacct_dec(bp);
 
 	spin_lock(&bp->b_lock);
-	atomic_set(&bp->b_lru_ref, 0);
+	refcount_set(&bp->b_lru_ref, 0);
 	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
 	    (list_lru_del(&bp->b_target->bt_lru, &bp->b_lru)))
-		atomic_dec(&bp->b_hold);
+		refcount_dec(&bp->b_hold);
 
-	ASSERT(atomic_read(&bp->b_hold) >= 1);
+	ASSERT(refcount_read(&bp->b_hold) >= 1);
 	spin_unlock(&bp->b_lock);
 }
 
@@ -214,8 +214,8 @@ _xfs_buf_alloc(
 	 */
 	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
 
-	atomic_set(&bp->b_hold, 1);
-	atomic_set(&bp->b_lru_ref, 1);
+	refcount_set(&bp->b_hold, 1);
+	refcount_set(&bp->b_lru_ref, 1);
 	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_lru);
 	INIT_LIST_HEAD(&bp->b_list);
@@ -581,7 +581,7 @@ _xfs_buf_find(
 	bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmap,
 				    xfs_buf_hash_params);
 	if (bp) {
-		atomic_inc(&bp->b_hold);
+		refcount_inc(&bp->b_hold);
 		goto found;
 	}
 
@@ -940,7 +940,7 @@ xfs_buf_hold(
 	xfs_buf_t		*bp)
 {
 	trace_xfs_buf_hold(bp, _RET_IP_);
-	atomic_inc(&bp->b_hold);
+	refcount_inc(&bp->b_hold);
 }
 
 /*
@@ -959,16 +959,16 @@ xfs_buf_rele(
 
 	if (!pag) {
 		ASSERT(list_empty(&bp->b_lru));
-		if (atomic_dec_and_test(&bp->b_hold)) {
+		if (refcount_dec_and_test(&bp->b_hold)) {
 			xfs_buf_ioacct_dec(bp);
 			xfs_buf_free(bp);
 		}
 		return;
 	}
 
-	ASSERT(atomic_read(&bp->b_hold) > 0);
+	ASSERT(refcount_read(&bp->b_hold) > 0);
 
-	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
+	release = refcount_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
 	spin_lock(&bp->b_lock);
 	if (!release) {
 		/*
@@ -977,14 +977,14 @@ xfs_buf_rele(
 		 * haven't acquired the pag lock, but the use of _XBF_IN_FLIGHT
 		 * ensures the decrement occurs only once per-buf.
 		 */
-		if ((atomic_read(&bp->b_hold) == 1) && !list_empty(&bp->b_lru))
+		if ((refcount_read(&bp->b_hold) == 1) && !list_empty(&bp->b_lru))
 			xfs_buf_ioacct_dec(bp);
 		goto out_unlock;
 	}
 
 	/* the last reference has been dropped ... */
 	xfs_buf_ioacct_dec(bp);
-	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
+	if (!(bp->b_flags & XBF_STALE) && refcount_read(&bp->b_lru_ref)) {
 		/*
 		 * If the buffer is added to the LRU take a new reference to the
 		 * buffer for the LRU and clear the (now stale) dispose list
@@ -992,7 +992,7 @@ xfs_buf_rele(
 		 */
 		if (list_lru_add(&bp->b_target->bt_lru, &bp->b_lru)) {
 			bp->b_state &= ~XFS_BSTATE_DISPOSE;
-			atomic_inc(&bp->b_hold);
+			refcount_inc(&bp->b_hold);
 		}
 		spin_unlock(&pag->pag_buf_lock);
 	} else {
@@ -1598,7 +1598,7 @@ xfs_buftarg_wait_rele(
 	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
 	struct list_head	*dispose = arg;
 
-	if (atomic_read(&bp->b_hold) > 1) {
+	if (refcount_read(&bp->b_hold) > 1) {
 		/* need to wait, so skip it this pass */
 		trace_xfs_buf_wait_buftarg(bp, _RET_IP_);
 		return LRU_SKIP;
@@ -1610,7 +1610,7 @@ xfs_buftarg_wait_rele(
 	 * clear the LRU reference count so the buffer doesn't get
 	 * ignored in xfs_buf_rele().
 	 */
-	atomic_set(&bp->b_lru_ref, 0);
+	refcount_set(&bp->b_lru_ref, 0);
 	bp->b_state |= XFS_BSTATE_DISPOSE;
 	list_lru_isolate_move(lru, item, dispose);
 	spin_unlock(&bp->b_lock);
@@ -1684,10 +1684,11 @@ xfs_buftarg_isolate(
 	 * zero. If the value is already zero, we need to reclaim the
 	 * buffer, otherwise it gets another trip through the LRU.
 	 */
-	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
+	if (!refcount_read(&bp->b_lru_ref)) {
 		spin_unlock(&bp->b_lock);
 		return LRU_ROTATE;
 	}
+	refcount_dec_and_test(&bp->b_lru_ref);
 
 	bp->b_state |= XFS_BSTATE_DISPOSE;
 	list_lru_isolate_move(lru, item, dispose);
@@ -1854,7 +1855,7 @@ xfs_buf_delwri_queue(
 	 */
 	bp->b_flags |= _XBF_DELWRI_Q;
 	if (list_empty(&bp->b_list)) {
-		atomic_inc(&bp->b_hold);
+		refcount_inc(&bp->b_hold);
 		list_add_tail(&bp->b_list, list);
 	}
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 3c867e5..7373246 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -27,6 +27,7 @@
 #include <linux/buffer_head.h>
 #include <linux/uio.h>
 #include <linux/list_lru.h>
+#include <linux/refcount.h>
 
 /*
  *	Base types
@@ -153,8 +154,8 @@ typedef struct xfs_buf {
 	struct rhash_head	b_rhash_head;	/* pag buffer hash node */
 	xfs_daddr_t		b_bn;		/* block number of buffer */
 	int			b_length;	/* size of buffer in BBs */
-	atomic_t		b_hold;		/* reference count */
-	atomic_t		b_lru_ref;	/* lru reclaim ref count */
+	refcount_t		b_hold;		/* reference count */
+	refcount_t		b_lru_ref;	/* lru reclaim ref count */
 	xfs_buf_flags_t		b_flags;	/* status flags */
 	struct semaphore	b_sema;		/* semaphore for lockables */
 
@@ -353,7 +354,7 @@ extern void xfs_buf_terminate(void);
 
 static inline void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 {
-	atomic_set(&bp->b_lru_ref, lru_ref);
+	refcount_set(&bp->b_lru_ref, lru_ref);
 }
 
 static inline int xfs_buf_ispinned(struct xfs_buf *bp)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 383ac22..8fc98d5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -326,7 +326,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = bp->b_bn;
 		__entry->nblks = bp->b_length;
-		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->hold = refcount_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
@@ -395,7 +395,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 		__entry->bno = bp->b_bn;
 		__entry->buffer_length = BBTOB(bp->b_length);
 		__entry->flags = flags;
-		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->hold = refcount_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->caller_ip = caller_ip;
@@ -438,7 +438,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = bp->b_bn;
 		__entry->buffer_length = BBTOB(bp->b_length);
-		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->hold = refcount_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->error = error;
@@ -483,7 +483,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 		__entry->buf_bno = bip->bli_buf->b_bn;
 		__entry->buf_len = BBTOB(bip->bli_buf->b_length);
 		__entry->buf_flags = bip->bli_buf->b_flags;
-		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
+		__entry->buf_hold = refcount_read(&bip->bli_buf->b_hold);
 		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
 		__entry->buf_lockval = bip->bli_buf->b_sema.count;
 		__entry->li_desc = bip->bli_item.li_desc;
-- 
2.7.4


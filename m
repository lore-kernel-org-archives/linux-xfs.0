Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30014 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752039AbdBUPtW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Feb 2017 10:49:22 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 3/7] fs, xfs: convert xfs_buf_log_item.bli_refcount from atomic_t to refcount_t
Date: Tue, 21 Feb 2017 17:49:03 +0200
Message-Id: <1487692147-17066-4-git-send-email-elena.reshetova@intel.com>
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
 fs/xfs/xfs_buf_item.c  | 16 ++++++++--------
 fs/xfs/xfs_buf_item.h  |  4 +++-
 fs/xfs/xfs_trace.h     |  2 +-
 fs/xfs/xfs_trans_buf.c | 32 ++++++++++++++++----------------
 4 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 0306168..f6063ad 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -137,7 +137,7 @@ xfs_buf_item_size(
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	int			i;
 
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 	if (bip->bli_flags & XFS_BLI_STALE) {
 		/*
 		 * The buffer is stale, so all we need to log
@@ -316,7 +316,7 @@ xfs_buf_item_format(
 	uint			offset = 0;
 	int			i;
 
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
 	ASSERT((bip->bli_flags & XFS_BLI_STALE) ||
@@ -383,14 +383,14 @@ xfs_buf_item_pin(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_ORDERED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
 
 	trace_xfs_buf_item_pin(bip);
 
-	atomic_inc(&bip->bli_refcount);
+	refcount_inc(&bip->bli_refcount);
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
@@ -419,11 +419,11 @@ xfs_buf_item_unpin(
 	int		freed;
 
 	ASSERT(bp->b_fspriv == bip);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	trace_xfs_buf_item_unpin(bip);
 
-	freed = atomic_dec_and_test(&bip->bli_refcount);
+	freed = refcount_dec_and_test(&bip->bli_refcount);
 
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
@@ -605,7 +605,7 @@ xfs_buf_item_unlock(
 		trace_xfs_buf_item_unlock_stale(bip);
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 		if (!aborted) {
-			atomic_dec(&bip->bli_refcount);
+			refcount_dec(&bip->bli_refcount);
 			return;
 		}
 	}
@@ -642,7 +642,7 @@ xfs_buf_item_unlock(
 	 * it in this case, because an aborted transaction has already shut the
 	 * filesystem down and this is the last chance we will have to do so.
 	 */
-	if (atomic_dec_and_test(&bip->bli_refcount)) {
+	if (refcount_dec_and_test(&bip->bli_refcount)) {
 		if (clean)
 			xfs_buf_item_relse(bp);
 		else if (aborted) {
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index f7eba99..7bbdef7 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -18,6 +18,8 @@
 #ifndef	__XFS_BUF_ITEM_H__
 #define	__XFS_BUF_ITEM_H__
 
+#include <linux/refcount.h>
+
 /* kernel only definitions */
 
 /* buf log item flags */
@@ -55,7 +57,7 @@ typedef struct xfs_buf_log_item {
 	struct xfs_buf		*bli_buf;	/* real buffer pointer */
 	unsigned int		bli_flags;	/* misc flags */
 	unsigned int		bli_recur;	/* lock recursion count */
-	atomic_t		bli_refcount;	/* cnt of tp refs */
+	refcount_t		bli_refcount;	/* cnt of tp refs */
 	int			bli_format_count;	/* count of headers */
 	struct xfs_buf_log_format *bli_formats;	/* array of in-log header ptrs */
 	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8fc98d5..4afd160 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -479,7 +479,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 		__entry->dev = bip->bli_buf->b_target->bt_dev;
 		__entry->bli_flags = bip->bli_flags;
 		__entry->bli_recur = bip->bli_recur;
-		__entry->bli_refcount = atomic_read(&bip->bli_refcount);
+		__entry->bli_refcount = refcount_read(&bip->bli_refcount);
 		__entry->buf_bno = bip->bli_buf->b_bn;
 		__entry->buf_len = BBTOB(bip->bli_buf->b_length);
 		__entry->buf_flags = bip->bli_buf->b_flags;
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 8ee29ca..fa7f213 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -97,7 +97,7 @@ _xfs_trans_bjoin(
 	/*
 	 * Take a reference for this transaction on the buf item.
 	 */
-	atomic_inc(&bip->bli_refcount);
+	refcount_inc(&bip->bli_refcount);
 
 	/*
 	 * Get a log_item_desc to point at the new item.
@@ -161,7 +161,7 @@ xfs_trans_get_buf_map(
 		ASSERT(bp->b_transp == tp);
 		bip = bp->b_fspriv;
 		ASSERT(bip != NULL);
-		ASSERT(atomic_read(&bip->bli_refcount) > 0);
+		ASSERT(refcount_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
 		trace_xfs_trans_get_buf_recur(bip);
 		return bp;
@@ -212,7 +212,7 @@ xfs_trans_getsb(xfs_trans_t	*tp,
 	if (bp->b_transp == tp) {
 		bip = bp->b_fspriv;
 		ASSERT(bip != NULL);
-		ASSERT(atomic_read(&bip->bli_refcount) > 0);
+		ASSERT(refcount_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
 		trace_xfs_trans_getsb_recur(bip);
 		return bp;
@@ -282,7 +282,7 @@ xfs_trans_read_buf_map(
 		bip = bp->b_fspriv;
 		bip->bli_recur++;
 
-		ASSERT(atomic_read(&bip->bli_refcount) > 0);
+		ASSERT(refcount_read(&bip->bli_refcount) > 0);
 		trace_xfs_trans_read_buf_recur(bip);
 		*bpp = bp;
 		return 0;
@@ -371,7 +371,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	trace_xfs_trans_brelse(bip);
 
@@ -419,7 +419,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	/*
 	 * Drop our reference to the buf log item.
 	 */
-	atomic_dec(&bip->bli_refcount);
+	refcount_dec(&bip->bli_refcount);
 
 	/*
 	 * If the buf item is not tracking data in the log, then
@@ -432,7 +432,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 /***
 		ASSERT(bp->b_pincount == 0);
 ***/
-		ASSERT(atomic_read(&bip->bli_refcount) == 0);
+		ASSERT(refcount_read(&bip->bli_refcount) == 0);
 		ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
 		ASSERT(!(bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF));
 		xfs_buf_item_relse(bp);
@@ -458,7 +458,7 @@ xfs_trans_bhold(xfs_trans_t	*tp,
 	ASSERT(bip != NULL);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_HOLD;
 	trace_xfs_trans_bhold(bip);
@@ -478,7 +478,7 @@ xfs_trans_bhold_release(xfs_trans_t	*tp,
 	ASSERT(bip != NULL);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 	ASSERT(bip->bli_flags & XFS_BLI_HOLD);
 
 	bip->bli_flags &= ~XFS_BLI_HOLD;
@@ -520,7 +520,7 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	 */
 	bp->b_flags |= XBF_DONE;
 
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 	bp->b_iodone = xfs_buf_iodone_callbacks;
 	bip->bli_item.li_cb = xfs_buf_iodone;
 
@@ -591,7 +591,7 @@ xfs_trans_binval(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	trace_xfs_trans_binval(bip);
 
@@ -645,7 +645,7 @@ xfs_trans_inode_buf(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_BUF;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
@@ -669,7 +669,7 @@ xfs_trans_stale_inode_buf(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_STALE_INODE;
 	bip->bli_item.li_cb = xfs_buf_iodone;
@@ -694,7 +694,7 @@ xfs_trans_inode_alloc_buf(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
@@ -717,7 +717,7 @@ xfs_trans_ordered_buf(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_ORDERED;
 	trace_xfs_buf_item_ordered(bip);
@@ -740,7 +740,7 @@ xfs_trans_buf_set_type(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(refcount_read(&bip->bli_refcount) > 0);
 
 	xfs_blft_to_flags(&bip->__bli_format, type);
 }
-- 
2.7.4


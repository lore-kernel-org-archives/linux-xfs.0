Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A9BC829E0C
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 03:05:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A2B868F8033
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 01:04:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Cx1ZcCHt4goQT3jX for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 01:04:55 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UZctH-0006ZA-G7
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UZctH-0007rN-85
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/7] xfs: Introduce an ordered buffer item
Date: Tue,  7 May 2013 18:04:32 +1000
Message-Id: <1367913876-30086-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1367913876-30086-1-git-send-email-david@fromorbit.com>
References: <1367913876-30086-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

If we have a buffer that we have modified but we do not wish to
physically log in a transaction (e.g. we've logged a logical
change), we still need to ensure that transactional integrity is
maintained. Hence we must not move the tail of the log past the
transaction that the buffer is associated with before the buffer is
written to disk.

This means these special buffers still need to be included in the
transaction and added to the AIL just like a normal buffer, but we
do not want the modifications to the buffer written into the
transaction. IOWs, what we want is an "ordered buffer" that
maintains the same transactional life cycle as a physically logged
buffer, just without the transcribing of the modifications to the
log.

Hence we need to flag the buffer as an "ordered buffer" to avoid
including it in vector size calculations or formatting during the
transaction. Once the transaction is committed, the buffer appears
for all intents to be the same as a physically logged buffer as it
transitions through the log and AIL.

Relogging will also work just fine for such an ordered buffer - the
logical transaction will be replayed before the subsequent
modifications that relog the buffer, so everything will be
reconstructed correctly by recovery.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_buf_item.c  |   75 +++++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_buf_item.h  |    4 ++-
 fs/xfs/xfs_trace.h     |    2 ++
 fs/xfs/xfs_trans.h     |    1 +
 fs/xfs/xfs_trans_buf.c |   33 +++++++++++++++++++--
 5 files changed, 84 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index cf26347..e547915 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -140,6 +140,16 @@ xfs_buf_item_size(
 
 	ASSERT(bip->bli_flags & XFS_BLI_LOGGED);
 
+	if (bip->bli_flags & XFS_BLI_ORDERED) {
+		/*
+		 * The buffer has been logged just to order it.
+		 * It is not being included in the transaction
+		 * commit, so no vectors are used at all.
+		 */
+		trace_xfs_buf_item_size_ordered(bip);
+		return 0;
+	}
+
 	/*
 	 * the vector count is based on the number of buffer vectors we have
 	 * dirty bits in. This will only be greater than one when we have a
@@ -212,6 +222,7 @@ xfs_buf_item_format_segment(
 		goto out;
 	}
 
+
 	/*
 	 * Fill in an iovec for each set of contiguous chunks.
 	 */
@@ -316,6 +327,16 @@ xfs_buf_item_format(
 		bip->bli_flags &= ~XFS_BLI_INODE_BUF;
 	}
 
+	if ((bip->bli_flags & (XFS_BLI_ORDERED|XFS_BLI_STALE)) ==
+							XFS_BLI_ORDERED) {
+		/*
+		 * The buffer has been logged just to order it.  It is not being
+		 * included in the transaction commit, so don't format it.
+		 */
+		trace_xfs_buf_item_format_ordered(bip);
+		return;
+	}
+
 	for (i = 0; i < bip->bli_format_count; i++) {
 		vecp = xfs_buf_item_format_segment(bip, vecp, offset,
 						&bip->bli_formats[i]);
@@ -345,6 +366,7 @@ xfs_buf_item_pin(
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
+	       (bip->bli_flags & XFS_BLI_ORDERED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
 
 	trace_xfs_buf_item_pin(bip);
@@ -517,8 +539,9 @@ xfs_buf_item_unlock(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	int			aborted, clean, i;
-	uint			hold;
+	bool			clean;
+	bool			aborted;
+	int			flags;
 
 	/* Clear the buffer's association with this transaction. */
 	bp->b_transp = NULL;
@@ -529,23 +552,21 @@ xfs_buf_item_unlock(
 	 * (cancelled) buffers at unpin time, but we'll never go through the
 	 * pin/unpin cycle if we abort inside commit.
 	 */
-	aborted = (lip->li_flags & XFS_LI_ABORTED) != 0;
-
+	aborted = (lip->li_flags & XFS_LI_ABORTED) ? true : false;
 	/*
-	 * Before possibly freeing the buf item, determine if we should
-	 * release the buffer at the end of this routine.
+	 * Before possibly freeing the buf item, copy the per-transaction state
+	 * so we can reference it safely later after clearing it from the
+	 * buffer log item.
 	 */
-	hold = bip->bli_flags & XFS_BLI_HOLD;
-
-	/* Clear the per transaction state. */
-	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD);
+	flags = bip->bli_flags;
+	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
 
 	/*
 	 * If the buf item is marked stale, then don't do anything.  We'll
 	 * unlock the buffer and free the buf item when the buffer is unpinned
 	 * for the last time.
 	 */
-	if (bip->bli_flags & XFS_BLI_STALE) {
+	if (flags & XFS_BLI_STALE) {
 		trace_xfs_buf_item_unlock_stale(bip);
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 		if (!aborted) {
@@ -562,13 +583,19 @@ xfs_buf_item_unlock(
 	 * be the only reference to the buf item, so we free it anyway
 	 * regardless of whether it is dirty or not. A dirty abort implies a
 	 * shutdown, anyway.
+	 *
+	 * Ordered buffers are dirty but may have no recorded changes, so ensure
+	 * we only release clean items here.
 	 */
-	clean = 1;
-	for (i = 0; i < bip->bli_format_count; i++) {
-		if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
-			     bip->bli_formats[i].blf_map_size)) {
-			clean = 0;
-			break;
+	clean = (flags & XFS_BLI_DIRTY) ? false : true;
+	if (clean) {
+		int i;
+		for (i = 0; i < bip->bli_format_count; i++) {
+			if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
+				     bip->bli_formats[i].blf_map_size)) {
+				clean = false;
+				break;
+			}
 		}
 	}
 	if (clean)
@@ -581,7 +608,7 @@ xfs_buf_item_unlock(
 	} else
 		atomic_dec(&bip->bli_refcount);
 
-	if (!hold)
+	if (!(flags & XFS_BLI_HOLD))
 		xfs_buf_relse(bp);
 }
 
@@ -847,12 +874,6 @@ xfs_buf_item_log(
 	struct xfs_buf		*bp = bip->bli_buf;
 
 	/*
-	 * Mark the item as having some dirty data for
-	 * quick reference in xfs_buf_item_dirty.
-	 */
-	bip->bli_flags |= XFS_BLI_DIRTY;
-
-	/*
 	 * walk each buffer segment and mark them dirty appropriately.
 	 */
 	start = 0;
@@ -878,7 +899,7 @@ xfs_buf_item_log(
 
 
 /*
- * Return 1 if the buffer has some data that has been logged (at any
+ * Return 1 if the buffer has been logged or ordered in a transaction (at any
  * point, not just the current transaction) and 0 if not.
  */
 uint
@@ -912,11 +933,11 @@ void
 xfs_buf_item_relse(
 	xfs_buf_t	*bp)
 {
-	xfs_buf_log_item_t	*bip;
+	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
+	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
 
-	bip = bp->b_fspriv;
 	bp->b_fspriv = bip->bli_item.li_bio_list;
 	if (bp->b_fspriv == NULL)
 		bp->b_iodone = NULL;
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 2573d2a..0f1c247 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -120,6 +120,7 @@ xfs_blft_from_flags(struct xfs_buf_log_format *blf)
 #define	XFS_BLI_INODE_ALLOC_BUF	0x10
 #define XFS_BLI_STALE_INODE	0x20
 #define	XFS_BLI_INODE_BUF	0x40
+#define	XFS_BLI_ORDERED		0x80
 
 #define XFS_BLI_FLAGS \
 	{ XFS_BLI_HOLD,		"HOLD" }, \
@@ -128,7 +129,8 @@ xfs_blft_from_flags(struct xfs_buf_log_format *blf)
 	{ XFS_BLI_LOGGED,	"LOGGED" }, \
 	{ XFS_BLI_INODE_ALLOC_BUF, "INODE_ALLOC" }, \
 	{ XFS_BLI_STALE_INODE,	"STALE_INODE" }, \
-	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }
+	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }, \
+	{ XFS_BLI_ORDERED,	"ORDERED" }
 
 
 #ifdef __KERNEL__
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index aa4db33..8dfc562 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -486,8 +486,10 @@ DEFINE_EVENT(xfs_buf_item_class, name, \
 	TP_PROTO(struct xfs_buf_log_item *bip), \
 	TP_ARGS(bip))
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size_ordered);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size_stale);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format_ordered);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format_stale);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pin);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a44dba5..850fe78 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -503,6 +503,7 @@ void		xfs_trans_bhold_release(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_binval(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_inode_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 73a5fa4..57160d2 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -397,7 +397,6 @@ shutdown_abort:
 	return XFS_ERROR(EIO);
 }
 
-
 /*
  * Release the buffer bp which was previously acquired with one of the
  * xfs_trans_... buffer allocation routines if the buffer has not
@@ -603,8 +602,14 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
-	bip->bli_flags |= XFS_BLI_LOGGED;
-	xfs_buf_item_log(bip, first, last);
+
+	/*
+	 * If we have an ordered buffer we are not logging any dirty range but
+	 * it still needs to be marked dirty and that it has been logged.
+	 */
+	bip->bli_flags |= XFS_BLI_DIRTY | XFS_BLI_LOGGED;
+	if (!(bip->bli_flags & XFS_BLI_ORDERED))
+		xfs_buf_item_log(bip, first, last);
 }
 
 
@@ -757,6 +762,28 @@ xfs_trans_inode_alloc_buf(
 }
 
 /*
+ * Mark the buffer as ordered for this transaction. This means
+ * that the contents of the buffer are not recorded in the transaction
+ * but it is tracked in the AIL as though it was. This allows us
+ * to record logical changes in transactions rather than the physical
+ * changes we make to the buffer without changing writeback ordering
+ * constraints of metadata buffers.
+ */
+void
+xfs_trans_ordered_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip != NULL);
+	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+
+	bip->bli_flags |= XFS_BLI_ORDERED;
+}
+
+/*
  * Set the type of the buffer for log recovery so that it can correctly identify
  * and hence attach the correct buffer ops to the buffer after replay.
  */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

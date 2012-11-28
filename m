Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qASMOpIp218576 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 16:24:51 -0600
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B7B8AC007
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 14:27:05 -0800 (PST)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	qASMR6Sh003591
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 16:27:06 -0600 (CST)
	(envelope-from tinguely@sgi.com)
Message-Id: <20121128222622.792433915@sgi.com>
Date: Wed, 28 Nov 2012 16:23:11 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v2 2/3] xfs: fix the buffer log format for contiguous buffers
References: <20121128222309.109033307@.sgi.com>
Content-Disposition: inline;
	filename=2-3-xfs-fix-blf-for-multiple-segment.patch
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Not every segment in a multi-segment buffer is dirty in a
transaction and they will not be outputted. The assert in
xfs_buf_item_format_segment() that checks for the at least
one chunk of data in the segment to be used is not necessary
true for multi-segmented buffers.

This patch:

 1) Change xfs_buf_item_format_segment() to skip over non-dirty
    segments.
 2) Change the bli_format structure to __bli_format so it is not
    accidently confused with the bli_formats pointer.
 3) Remove the buffer XFS_TRANS_DEBUG routines xfs_buf_item_log_debug()
    and xfs_buf_item_log_check(). They are not used and are not
    multi-segment aware.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>

---
 fs/xfs/xfs_buf_item.c  |  151 +++++++++----------------------------------------
 fs/xfs/xfs_buf_item.h  |    2 
 fs/xfs/xfs_trans_buf.c |   24 +++----
 3 files changed, 41 insertions(+), 136 deletions(-)

Index: b/fs/xfs/xfs_buf_item.c
===================================================================
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -37,109 +37,6 @@ static inline struct xfs_buf_log_item *B
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
-
-#ifdef XFS_TRANS_DEBUG
-/*
- * This function uses an alternate strategy for tracking the bytes
- * that the user requests to be logged.  This can then be used
- * in conjunction with the bli_orig array in the buf log item to
- * catch bugs in our callers' code.
- *
- * We also double check the bits set in xfs_buf_item_log using a
- * simple algorithm to check that every byte is accounted for.
- */
-STATIC void
-xfs_buf_item_log_debug(
-	xfs_buf_log_item_t	*bip,
-	uint			first,
-	uint			last)
-{
-	uint	x;
-	uint	byte;
-	uint	nbytes;
-	uint	chunk_num;
-	uint	word_num;
-	uint	bit_num;
-	uint	bit_set;
-	uint	*wordp;
-
-	ASSERT(bip->bli_logged != NULL);
-	byte = first;
-	nbytes = last - first + 1;
-	bfset(bip->bli_logged, first, nbytes);
-	for (x = 0; x < nbytes; x++) {
-		chunk_num = byte >> XFS_BLF_SHIFT;
-		word_num = chunk_num >> BIT_TO_WORD_SHIFT;
-		bit_num = chunk_num & (NBWORD - 1);
-		wordp = &(bip->bli_format.blf_data_map[word_num]);
-		bit_set = *wordp & (1 << bit_num);
-		ASSERT(bit_set);
-		byte++;
-	}
-}
-
-/*
- * This function is called when we flush something into a buffer without
- * logging it.  This happens for things like inodes which are logged
- * separately from the buffer.
- */
-void
-xfs_buf_item_flush_log_debug(
-	xfs_buf_t	*bp,
-	uint		first,
-	uint		last)
-{
-	xfs_buf_log_item_t	*bip = bp->b_fspriv;
-	uint			nbytes;
-
-	if (bip == NULL || (bip->bli_item.li_type != XFS_LI_BUF))
-		return;
-
-	ASSERT(bip->bli_logged != NULL);
-	nbytes = last - first + 1;
-	bfset(bip->bli_logged, first, nbytes);
-}
-
-/*
- * This function is called to verify that our callers have logged
- * all the bytes that they changed.
- *
- * It does this by comparing the original copy of the buffer stored in
- * the buf log item's bli_orig array to the current copy of the buffer
- * and ensuring that all bytes which mismatch are set in the bli_logged
- * array of the buf log item.
- */
-STATIC void
-xfs_buf_item_log_check(
-	xfs_buf_log_item_t	*bip)
-{
-	char		*orig;
-	char		*buffer;
-	int		x;
-	xfs_buf_t	*bp;
-
-	ASSERT(bip->bli_orig != NULL);
-	ASSERT(bip->bli_logged != NULL);
-
-	bp = bip->bli_buf;
-	ASSERT(bp->b_length > 0);
-	ASSERT(bp->b_addr != NULL);
-	orig = bip->bli_orig;
-	buffer = bp->b_addr;
-	for (x = 0; x < BBTOB(bp->b_length); x++) {
-		if (orig[x] != buffer[x] && !btst(bip->bli_logged, x)) {
-			xfs_emerg(bp->b_mount,
-				"%s: bip %x buffer %x orig %x index %d",
-				__func__, bip, bp, orig, x);
-			ASSERT(0);
-		}
-	}
-}
-#else
-#define		xfs_buf_item_log_debug(x,y,z)
-#define		xfs_buf_item_log_check(x)
-#endif
-
 STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
 
 /*
@@ -237,7 +134,7 @@ xfs_buf_item_size(
 		 * cancel flag in it.
 		 */
 		trace_xfs_buf_item_size_stale(bip);
-		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 		return bip->bli_format_count;
 	}
 
@@ -278,7 +175,7 @@ xfs_buf_item_format_segment(
 	uint		buffer_offset;
 
 	/* copy the flags across from the base format item */
-	blfp->blf_flags = bip->bli_format.blf_flags;
+	blfp->blf_flags = bip->__bli_format.blf_flags;
 
 	/*
 	 * Base size is the actual size of the ondisk structure - it reflects
@@ -287,11 +184,6 @@ xfs_buf_item_format_segment(
 	 */
 	base_size = offsetof(struct xfs_buf_log_format, blf_data_map) +
 			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
-	vecp->i_addr = blfp;
-	vecp->i_len = base_size;
-	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
-	vecp++;
-	nvecs = 1;
 
 	if (bip->bli_flags & XFS_BLI_STALE) {
 		/*
@@ -301,7 +193,11 @@ xfs_buf_item_format_segment(
 		 */
 		trace_xfs_buf_item_format_stale(bip);
 		ASSERT(blfp->blf_flags & XFS_BLF_CANCEL);
-		blfp->blf_size = nvecs;
+		vecp->i_addr = blfp;
+		vecp->i_len = base_size;
+		vecp->i_type = XLOG_REG_TYPE_BFORMAT;
+		vecp++;
+		blfp->blf_size = 1;
 		return vecp;
 	}
 
@@ -309,7 +205,19 @@ xfs_buf_item_format_segment(
 	 * Fill in an iovec for each set of contiguous chunks.
 	 */
 	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
-	ASSERT(first_bit != -1);
+	if (first_bit == -1) {
+		/* If the map is not be dirty in the transaction, mark
+		 * the size as zero and do not advance the vector pointer.
+		 */
+		blfp->blf_size = 0;
+		return(vecp);
+	}
+
+	vecp->i_addr = blfp;
+	vecp->i_len = base_size;
+	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
+	vecp++;
+	nvecs = 1;
 	last_bit = first_bit;
 	nbits = 1;
 	for (;;) {
@@ -371,7 +279,7 @@ xfs_buf_item_format_segment(
 			nbits++;
 		}
 	}
-	bip->bli_format.blf_size = nvecs;
+	blfp->blf_size = nvecs;
 	return vecp;
 }
 
@@ -405,7 +313,7 @@ xfs_buf_item_format(
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
 		if (!((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
-			bip->bli_format.blf_flags |= XFS_BLF_INODE_BUF;
+			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
 		bip->bli_flags &= ~XFS_BLI_INODE_BUF;
 	}
 
@@ -419,7 +327,6 @@ xfs_buf_item_format(
 	 * Check to make sure everything is consistent.
 	 */
 	trace_xfs_buf_item_format(bip);
-	xfs_buf_item_log_check(bip);
 }
 
 /*
@@ -485,7 +392,7 @@ xfs_buf_item_unpin(
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(XFS_BUF_ISSTALE(bp));
-		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
@@ -631,7 +538,7 @@ xfs_buf_item_unlock(
 	 */
 	if (bip->bli_flags & XFS_BLI_STALE) {
 		trace_xfs_buf_item_unlock_stale(bip);
-		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 		if (!aborted) {
 			atomic_dec(&bip->bli_refcount);
 			return;
@@ -644,8 +551,8 @@ xfs_buf_item_unlock(
 	 * If the buf item isn't tracking any data, free it, otherwise drop the
 	 * reference we hold to it.
 	 */
-	if (xfs_bitmap_empty(bip->bli_format.blf_data_map,
-			     bip->bli_format.blf_map_size))
+	if (xfs_bitmap_empty(bip->__bli_format.blf_data_map,
+			     bip->__bli_format.blf_map_size))
 		xfs_buf_item_relse(bp);
 	else
 		atomic_dec(&bip->bli_refcount);
@@ -716,7 +623,7 @@ xfs_buf_item_get_format(
 	bip->bli_format_count = count;
 
 	if (count == 1) {
-		bip->bli_formats = &bip->bli_format;
+		bip->bli_formats = &bip->__bli_format;
 		return 0;
 	}
 
@@ -731,7 +638,7 @@ STATIC void
 xfs_buf_item_free_format(
 	struct xfs_buf_log_item	*bip)
 {
-	if (bip->bli_formats != &bip->bli_format) {
+	if (bip->bli_formats != &bip->__bli_format) {
 		kmem_free(bip->bli_formats);
 		bip->bli_formats = NULL;
 	}
@@ -898,8 +805,6 @@ xfs_buf_item_log_segment(
 		mask = (1 << end_bit) - 1;
 		*wordp |= mask;
 	}
-
-	xfs_buf_item_log_debug(bip, first, last);
 }
 
 /*
Index: b/fs/xfs/xfs_buf_item.h
===================================================================
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -104,7 +104,7 @@ typedef struct xfs_buf_log_item {
 #endif
 	int			bli_format_count;	/* count of headers */
 	struct xfs_buf_log_format *bli_formats;	/* array of in-log header ptrs */
-	struct xfs_buf_log_format bli_format;	/* embedded in-log header */
+	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
 } xfs_buf_log_item_t;
 
 void	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
Index: b/fs/xfs/xfs_trans_buf.c
===================================================================
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -93,7 +93,7 @@ _xfs_trans_bjoin(
 	xfs_buf_item_init(bp, tp->t_mountp);
 	bip = bp->b_fspriv;
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
+	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
 	if (reset_recur)
 		bip->bli_recur = 0;
@@ -432,7 +432,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	bip = bp->b_fspriv;
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
+	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	trace_xfs_trans_brelse(bip);
@@ -519,7 +519,7 @@ xfs_trans_bhold(xfs_trans_t	*tp,
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
+	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_HOLD;
@@ -539,7 +539,7 @@ xfs_trans_bhold_release(xfs_trans_t	*tp,
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
+	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	ASSERT(bip->bli_flags & XFS_BLI_HOLD);
 
@@ -598,7 +598,7 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 		bip->bli_flags &= ~XFS_BLI_STALE;
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		XFS_BUF_UNSTALE(bp);
-		bip->bli_format.blf_flags &= ~XFS_BLF_CANCEL;
+		bip->__bli_format.blf_flags &= ~XFS_BLF_CANCEL;
 	}
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
@@ -657,8 +657,8 @@ xfs_trans_binval(
 		 */
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		ASSERT(!(bip->bli_flags & (XFS_BLI_LOGGED | XFS_BLI_DIRTY)));
-		ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_INODE_BUF));
-		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_INODE_BUF));
+		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 		ASSERT(bip->bli_item.li_desc->lid_flags & XFS_LID_DIRTY);
 		ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
 		return;
@@ -668,10 +668,10 @@ xfs_trans_binval(
 
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~(XFS_BLI_INODE_BUF | XFS_BLI_LOGGED | XFS_BLI_DIRTY);
-	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
-	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
-	memset((char *)(bip->bli_format.blf_data_map), 0,
-	      (bip->bli_format.blf_map_size * sizeof(uint)));
+	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
+	bip->__bli_format.blf_flags |= XFS_BLF_CANCEL;
+	memset((char *)(bip->__bli_format.blf_data_map), 0,
+	      (bip->__bli_format.blf_map_size * sizeof(uint)));
 	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
@@ -775,5 +775,5 @@ xfs_trans_dquot_buf(
 	       type == XFS_BLF_GDQUOT_BUF);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
-	bip->bli_format.blf_flags |= type;
+	bip->__bli_format.blf_flags |= type;
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

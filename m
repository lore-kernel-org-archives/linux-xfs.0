Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB76J5FE046681 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 00:19:05 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24D6A1305D44
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 22:19:01 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3MukoW2TNxDsT8N1 for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 22:19:01 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RYAq0-0003o0-Hd
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:40 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RYAq0-0003Uu-4i
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/12] xfs: support compund buffers in buf_item logging
Date: Wed,  7 Dec 2011 17:18:20 +1100
Message-Id: <1323238703-13198-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1323238703-13198-1-git-send-email-david@fromorbit.com>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

>From the perspective of the log, we need to keep each segment of a
compound buffer in separate buffer format structures. This means log
recovery will recover all the changes on a per segment basis without
requiring any knowledge of the fact that it was logged from a
compound buffer.

To do this, we need to be able to determine what buffer segment any
given offset into the compound buffer sits over. This enables us to
translate the dirty bitmap in the number of separate buffer format
structures required.

We also need to be able to determine the number of bitmap elements
that a given buffer segment has, as this determines the size of the
buffer format structure. Hence we need to be able to determine the
both the start offset into the buffer and the length of a given
segment to be able to calculate this.

With this information, we can preallocate, build and format the
correct log vector array for each segment in a compound buffer to
appear exactly the same as individually logged buffers in the log.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c |  352 +++++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_buf_item.h |    6 +-
 2 files changed, 255 insertions(+), 103 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index eac97ef..285b282 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -143,44 +143,26 @@ xfs_buf_item_log_check(
 
 STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
 
-/*
- * This returns the number of log iovecs needed to log the
- * given buf log item.
- *
- * It calculates this as 1 iovec for the buf log format structure
- * and 1 for each stretch of non-contiguous chunks to be logged.
- * Contiguous chunks are logged in a single iovec.
- *
- * If the XFS_BLI_STALE flag has been set, then log nothing.
- */
 STATIC uint
-xfs_buf_item_size(
-	struct xfs_log_item	*lip)
+xfs_buf_item_size_segment(
+	struct xfs_buf_log_item	*bip,
+	struct xfs_buf_log_format *blfp)
 {
-	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
 	uint			nvecs;
 	int			next_bit;
 	int			last_bit;
 
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
-	if (bip->bli_flags & XFS_BLI_STALE) {
-		/*
-		 * The buffer is stale, so all we need to log
-		 * is the buf log format structure with the
-		 * cancel flag in it.
-		 */
-		trace_xfs_buf_item_size_stale(bip);
-		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
-		return 1;
-	}
+	last_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
+	if (last_bit == -1)
+		return 0;
+
+	/*
+	 * initial count for a dirty buffer is 2 vectors - the format structure
+	 * and the first dirty region.
+	 */
+	nvecs = 2;
 
-	ASSERT(bip->bli_flags & XFS_BLI_LOGGED);
-	nvecs = 1;
-	last_bit = xfs_next_bit(bip->bli_format.blf_data_map,
-					 bip->bli_format.blf_map_size, 0);
-	ASSERT(last_bit != -1);
-	nvecs++;
 	while (last_bit != -1) {
 		/*
 		 * This takes the bit number to start looking from and
@@ -188,8 +170,7 @@ xfs_buf_item_size(
 		 * if there are no more bits set or the start bit is
 		 * beyond the end of the bitmap.
 		 */
-		next_bit = xfs_next_bit(bip->bli_format.blf_data_map,
-						 bip->bli_format.blf_map_size,
+		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
 						 last_bit + 1);
 		/*
 		 * If we run out of bits, leave the loop,
@@ -197,7 +178,7 @@ xfs_buf_item_size(
 		 * else keep scanning the current set of bits.
 		 */
 		if (next_bit == -1) {
-			last_bit = -1;
+			break;
 		} else if (next_bit != last_bit + 1) {
 			last_bit = next_bit;
 			nvecs++;
@@ -211,22 +192,80 @@ xfs_buf_item_size(
 		}
 	}
 
-	trace_xfs_buf_item_size(bip);
 	return nvecs;
 }
 
 /*
- * This is called to fill in the vector of log iovecs for the
- * given log buf item.  It fills the first entry with a buf log
- * format structure, and the rest point to contiguous chunks
- * within the buffer.
+ * This returns the number of log iovecs needed to log the
+ * given buf log item.
+ *
+ * It calculates this as 1 iovec for the buf log format structure
+ * and 1 for each stretch of non-contiguous chunks to be logged.
+ * Contiguous chunks are logged in a single iovec.
+ *
+ * Compound buffers need a buf log format structure per vector that that is
+ * being logged. This makes the changes in the compound buffer appear to log
+ * recovery as though they came from separate buffers, just like would occur if
+ * multiple buffers were used instead of a compound buffer. This enables
+ * compound buffers to be in-memory constructs, completely transparent to what
+ * ends up on disk.
+ *
+ * If the XFS_BLI_STALE flag has been set, then log nothing but the buf log
+ * format structures.
  */
-STATIC void
-xfs_buf_item_format(
-	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*vecp)
+STATIC uint
+xfs_buf_item_size(
+	struct xfs_log_item	*lip)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	uint			nvecs;
+
+	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	if (bip->bli_flags & XFS_BLI_STALE) {
+		/*
+		 * The buffer is stale, so all we need to log
+		 * is the buf log format structure with the
+		 * cancel flag in it.
+		 */
+		trace_xfs_buf_item_size_stale(bip);
+		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
+		return bip->bli_format_count;
+	}
+
+	ASSERT(bip->bli_flags & XFS_BLI_LOGGED);
+
+	/*
+	 * the vector count is based on the number of buffer vectors we have
+	 * dirty bits in. This will only be greater than one when we have a
+	 * compound buffer with more than one segment dirty. Hence for compound
+	 * buffers we need to track which segment the dirty bits correspond to,
+	 * and when we move from one segment to the next increment the vector
+	 * count for the extra buf log format structure that will need to be
+	 * written.
+	 */
+	if (bip->bli_format_count == 1) {
+		nvecs = xfs_buf_item_size_segment(bip, &bip->bli_format);
+	} else {
+		int	i;
+
+		nvecs = 0;
+		for (i = 0; i < bip->bli_format_count; i++) {
+			nvecs += xfs_buf_item_size_segment(bip,
+							bip->bli_formatp[i]);
+		}
+	}
+
+	trace_xfs_buf_item_size(bip);
+	return nvecs;
+}
+
+static struct xfs_log_iovec *
+xfs_buf_item_format_segment(
+	struct xfs_buf_log_item	*bip,
+	struct xfs_log_iovec	*vecp,
+	uint			offset,
+	struct xfs_buf_log_format *blfp)
+{
 	struct xfs_buf	*bp = bip->bli_buf;
 	uint		base_size;
 	uint		nvecs;
@@ -236,38 +275,28 @@ xfs_buf_item_format(
 	uint		nbits;
 	uint		buffer_offset;
 
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
-	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
-	       (bip->bli_flags & XFS_BLI_STALE));
+	/* copy the flags across from the base format item */
+	blfp->blf_flags = bip->bli_format.blf_flags;
 
-	/*
-	 * The size of the base structure is the size of the
-	 * declared structure plus the space for the extra words
-	 * of the bitmap.  We subtract one from the map size, because
-	 * the first element of the bitmap is accounted for in the
-	 * size of the base structure.
-	 */
-	base_size =
-		(uint)(sizeof(xfs_buf_log_format_t) +
-		       ((bip->bli_format.blf_map_size - 1) * sizeof(uint)));
-	vecp->i_addr = &bip->bli_format;
+	base_size = (uint)(sizeof(xfs_buf_log_format_t) +
+		       ((blfp->blf_map_size - 1) * sizeof(uint)));
+	vecp->i_addr = blfp;
 	vecp->i_len = base_size;
 	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
 	vecp++;
 	nvecs = 1;
 
 	/*
-	 * If it is an inode buffer, transfer the in-memory state to the
-	 * format flags and clear the in-memory state. We do not transfer
+	 * If it is an inode buffer, transfer the in-memory state to the format
+	 * flags. The in-memory state gets cleared later. We do not transfer
 	 * this state if the inode buffer allocation has not yet been committed
-	 * to the log as setting the XFS_BLI_INODE_BUF flag will prevent
-	 * correct replay of the inode allocation.
+	 * to the log as setting the XFS_BLI_INODE_BUF flag will prevent correct
+	 * replay of the inode allocation.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
 		if (!((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
-		      xfs_log_item_in_current_chkpt(lip)))
-			bip->bli_format.blf_flags |= XFS_BLF_INODE_BUF;
-		bip->bli_flags &= ~XFS_BLI_INODE_BUF;
+		      xfs_log_item_in_current_chkpt(&bip->bli_item)))
+			blfp->blf_flags |= XFS_BLF_INODE_BUF;
 	}
 
 	if (bip->bli_flags & XFS_BLI_STALE) {
@@ -277,16 +306,15 @@ xfs_buf_item_format(
 		 * cancel flag in it.
 		 */
 		trace_xfs_buf_item_format_stale(bip);
-		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
-		bip->bli_format.blf_size = nvecs;
-		return;
+		ASSERT(blfp->blf_flags & XFS_BLF_CANCEL);
+		blfp->blf_size = nvecs;
+		return vecp;
 	}
 
 	/*
 	 * Fill in an iovec for each set of contiguous chunks.
 	 */
-	first_bit = xfs_next_bit(bip->bli_format.blf_data_map,
-					 bip->bli_format.blf_map_size, 0);
+	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
 	ASSERT(first_bit != -1);
 	last_bit = first_bit;
 	nbits = 1;
@@ -297,8 +325,7 @@ xfs_buf_item_format(
 		 * if there are no more bits set or the start bit is
 		 * beyond the end of the bitmap.
 		 */
-		next_bit = xfs_next_bit(bip->bli_format.blf_data_map,
-						 bip->bli_format.blf_map_size,
+		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
 						 (uint)last_bit + 1);
 		/*
 		 * If we run out of bits fill in the last iovec and get
@@ -310,14 +337,14 @@ xfs_buf_item_format(
 		 * keep counting and scanning.
 		 */
 		if (next_bit == -1) {
-			buffer_offset = first_bit * XFS_BLF_CHUNK;
+			buffer_offset = offset + first_bit * XFS_BLF_CHUNK;
 			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
 			vecp->i_len = nbits * XFS_BLF_CHUNK;
 			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
 			nvecs++;
 			break;
 		} else if (next_bit != last_bit + 1) {
-			buffer_offset = first_bit * XFS_BLF_CHUNK;
+			buffer_offset = offset + first_bit * XFS_BLF_CHUNK;
 			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
 			vecp->i_len = nbits * XFS_BLF_CHUNK;
 			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
@@ -326,10 +353,10 @@ xfs_buf_item_format(
 			first_bit = next_bit;
 			last_bit = next_bit;
 			nbits = 1;
-		} else if (xfs_buf_offset(bp, next_bit << XFS_BLF_SHIFT) !=
-			   (xfs_buf_offset(bp, last_bit << XFS_BLF_SHIFT) +
+		} else if (xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
+			   (xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
 			    XFS_BLF_CHUNK)) {
-			buffer_offset = first_bit * XFS_BLF_CHUNK;
+			buffer_offset = offset + first_bit * XFS_BLF_CHUNK;
 			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
 			vecp->i_len = nbits * XFS_BLF_CHUNK;
 			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
@@ -348,6 +375,49 @@ xfs_buf_item_format(
 		}
 	}
 	bip->bli_format.blf_size = nvecs;
+	return vecp;
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given log buf item.  It fills the first entry with a buf log
+ * format structure, and the rest point to contiguous chunks
+ * within the buffer.
+ */
+STATIC void
+xfs_buf_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_iovec	*vecp)
+{
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf	*bp = bip->bli_buf;
+
+	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
+	       (bip->bli_flags & XFS_BLI_STALE));
+
+	/*
+	 * The size of the base structure is the size of the declared structure
+	 * plus the space for the extra words of the bitmap.  We subtract one
+	 * from the map size, because the first element of the bitmap is
+	 * accounted for in the size of the base structure.
+	 */
+	if (bip->bli_format_count == 1) {
+		vecp = xfs_buf_item_format_segment(bip, vecp, 0,
+						   &bip->bli_format);
+	} else {
+		int	i;
+		uint	offset = 0;
+
+		for (i = 0; i < bip->bli_format_count; i++) {
+			vecp = xfs_buf_item_format_segment(bip, vecp, offset,
+							bip->bli_formatp[i]);
+			offset += bp->b_vec[i].bv_len;
+		}
+	}
+
+	/* clear the in-memory inode buffer state now formatting is done. */
+	bip->bli_flags &= ~XFS_BLI_INODE_BUF;
 
 	/*
 	 * Check to make sure everything is consistent.
@@ -697,24 +767,54 @@ xfs_buf_item_init(
 	if (lip != NULL && lip->li_type == XFS_LI_BUF)
 		return;
 
-	/*
-	 * chunks is the number of XFS_BLF_CHUNK size pieces
-	 * the buffer can be divided into. Make sure not to
-	 * truncate any pieces.  map_size is the size of the
-	 * bitmap needed to describe the chunks of the buffer.
-	 */
-	chunks = (int)((XFS_BUF_COUNT(bp) + (XFS_BLF_CHUNK - 1)) >> XFS_BLF_SHIFT);
-	map_size = (int)((chunks + NBWORD) >> BIT_TO_WORD_SHIFT);
 
 	bip = (xfs_buf_log_item_t*)kmem_zone_zalloc(xfs_buf_item_zone,
 						    KM_SLEEP);
 	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
 	bip->bli_buf = bp;
 	xfs_buf_hold(bp);
-	bip->bli_format.blf_type = XFS_LI_BUF;
-	bip->bli_format.blf_blkno = (__int64_t)XFS_BUF_ADDR(bp);
-	bip->bli_format.blf_len = (ushort)BTOBB(XFS_BUF_COUNT(bp));
-	bip->bli_format.blf_map_size = map_size;
+
+	/*
+	 * chunks is the number of XFS_BLF_CHUNK size pieces the buffer
+	 * can be divided into. Make sure not to truncate any pieces.
+	 * map_size is the size of the bitmap needed to describe the
+	 * chunks of the buffer.
+	 */
+	bip->bli_format_count = bp->b_vec_count;
+	if (bip->bli_format_count == 1) {
+		chunks = (int)((XFS_BUF_COUNT(bp) + (XFS_BLF_CHUNK - 1)) >> XFS_BLF_SHIFT);
+		map_size = (int)((chunks + NBWORD) >> BIT_TO_WORD_SHIFT);
+
+		bip->bli_format.blf_type = XFS_LI_BUF;
+		bip->bli_format.blf_blkno = (__int64_t)XFS_BUF_ADDR(bp);
+		bip->bli_format.blf_len = (ushort)BTOBB(XFS_BUF_COUNT(bp));
+		bip->bli_format.blf_map_size = map_size;
+	} else {
+		/*
+		 * Allocate an array to point to all the allocated format buffer
+		 * structures. Then allocate the format buffer structures and
+		 * initialise them.
+		 */
+		int	i;
+
+		bip->bli_formatp = kmem_zalloc(bip->bli_format_count *
+					sizeof(struct xfs_buf_log_format *),
+					       KM_SLEEP);
+		for (i = 0; i < bp->b_vec_count; i++) {
+			struct xfs_buf_log_format *blfp;
+
+			chunks = (int)((bp->b_vec[i].bv_len + (XFS_BLF_CHUNK - 1)) >> XFS_BLF_SHIFT);
+			map_size = (int)((chunks + NBWORD) >> BIT_TO_WORD_SHIFT);
+
+			blfp = kmem_zalloc(sizeof(*blfp) + map_size, KM_SLEEP);
+			bip->bli_formatp[i] = blfp;
+
+			blfp->blf_type = XFS_LI_BUF;
+			blfp->blf_blkno = (__int64_t)bp->b_vec[i].bv_bn;
+			blfp->blf_len = (ushort)BTOBB(bp->b_vec[i].bv_len);
+			blfp->blf_map_size = map_size;
+		}
+	}
 
 #ifdef XFS_TRANS_DEBUG
 	/*
@@ -739,16 +839,12 @@ xfs_buf_item_init(
 	bp->b_fspriv = bip;
 }
 
-
-/*
- * Mark bytes first through last inclusive as dirty in the buf
- * item's bitmap.
- */
 void
-xfs_buf_item_log(
-	xfs_buf_log_item_t	*bip,
+xfs_buf_item_log_segment(
+	struct xfs_buf_log_item	*bip,
 	uint			first,
-	uint			last)
+	uint			last,
+	uint			*map)
 {
 	uint		first_bit;
 	uint		last_bit;
@@ -761,12 +857,6 @@ xfs_buf_item_log(
 	uint		mask;
 
 	/*
-	 * Mark the item as having some dirty data for
-	 * quick reference in xfs_buf_item_dirty.
-	 */
-	bip->bli_flags |= XFS_BLI_DIRTY;
-
-	/*
 	 * Convert byte offsets to bit numbers.
 	 */
 	first_bit = first >> XFS_BLF_SHIFT;
@@ -782,7 +872,7 @@ xfs_buf_item_log(
 	 * to set a bit in.
 	 */
 	word_num = first_bit >> BIT_TO_WORD_SHIFT;
-	wordp = &(bip->bli_format.blf_data_map[word_num]);
+	wordp = &map[word_num];
 
 	/*
 	 * Calculate the starting bit in the first word.
@@ -831,6 +921,55 @@ xfs_buf_item_log(
 
 
 /*
+ * Mark bytes first through last inclusive as dirty in the buf
+ * item's bitmap.
+ */
+void
+xfs_buf_item_log(
+	xfs_buf_log_item_t	*bip,
+	uint			first,
+	uint			last)
+{
+	int			i;
+	uint			start;
+	uint			end;
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	/*
+	 * Mark the item as having some dirty data for
+	 * quick reference in xfs_buf_item_dirty.
+	 */
+	bip->bli_flags |= XFS_BLI_DIRTY;
+
+	if (bip->bli_format_count == 1) {
+		xfs_buf_item_log_segment(bip, first, last,
+					 &bip->bli_format.blf_data_map[0]);
+		return;
+	}
+
+	/*
+	 * walk each buffer segment and mark them dirty appropriately.
+	 */
+	start = 0;
+	for (i = 0; i < bip->bli_format_count; i++) {
+		if (start > last)
+			break;
+		end = start + bp->b_vec[i].bv_len;
+		if (first > end) {
+			start += bp->b_vec[i].bv_len;
+			continue;
+		}
+		if (end > last)
+			end = last;
+
+		xfs_buf_item_log_segment(bip, start, end,
+					 &bip->bli_formatp[i]->blf_data_map[0]);
+
+		start += bp->b_vec[i].bv_len;
+	}
+}
+
+/*
  * Return 1 if the buffer has some data that has been logged (at any
  * point, not just the current transaction) and 0 if not.
  */
@@ -850,6 +989,15 @@ xfs_buf_item_free(
 	kmem_free(bip->bli_logged);
 #endif /* XFS_TRANS_DEBUG */
 
+	if (bip->bli_format_count > 1) {
+		int	i;
+		for (i = 0; i < bip->bli_format_count; i++) {
+			kmem_free(bip->bli_formatp[i]);
+		}
+	}
+
+	kmem_free(bip->bli_formatp);
+
 	kmem_zone_free(xfs_buf_item_zone, bip);
 }
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index b6ecd20..a2c9751 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -102,7 +102,11 @@ typedef struct xfs_buf_log_item {
 	char			*bli_orig;	/* original buffer copy */
 	char			*bli_logged;	/* bytes logged (bitmap) */
 #endif
-	xfs_buf_log_format_t	bli_format;	/* in-log header */
+	xfs_buf_log_format_t	**bli_formatp;	/* array of in-log header ptrs */
+	int			bli_format_count;	/* count of headers */
+
+	/* variable size so must be last */
+	xfs_buf_log_format_t	bli_format;	/* embedded in-log header */
 } xfs_buf_log_item_t;
 
 void	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

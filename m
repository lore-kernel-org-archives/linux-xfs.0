Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3O6XxvC031603 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 01:33:59 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vXhyl5BZtWos2NZt for <xfs@oss.sgi.com>;
	Mon, 23 Apr 2012 23:33:56 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMZJo-0004Nd-Hm
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:44 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMZJo-0005tM-DR
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/10] xfs: support discontiguous buffers in the
	xfs_buf_log_item
Date: Tue, 24 Apr 2012 16:33:37 +1000
Message-Id: <1335249220-22274-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1335249220-22274-1-git-send-email-david@fromorbit.com>
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
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
discontigous buffer in separate buffer format structures. This means log
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
 fs/xfs/xfs_buf_item.c |  337 +++++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_buf_item.h |    2 +
 2 files changed, 247 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 45df2b8..a1b83a8 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -153,33 +153,25 @@ STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
  * If the XFS_BLI_STALE flag has been set, then log nothing.
  */
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
@@ -187,16 +179,15 @@ xfs_buf_item_size(
 		 * if there are no more bits set or the start bit is
 		 * beyond the end of the bitmap.
 		 */
-		next_bit = xfs_next_bit(bip->bli_format.blf_data_map,
-						 bip->bli_format.blf_map_size,
-						 last_bit + 1);
+		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
+					last_bit + 1);
 		/*
 		 * If we run out of bits, leave the loop,
 		 * else if we find a new set of bits bump the number of vecs,
 		 * else keep scanning the current set of bits.
 		 */
 		if (next_bit == -1) {
-			last_bit = -1;
+			break;
 		} else if (next_bit != last_bit + 1) {
 			last_bit = next_bit;
 			nvecs++;
@@ -210,22 +201,73 @@ xfs_buf_item_size(
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
+ * This returns the number of log iovecs needed to log the given buf log item.
+ *
+ * It calculates this as 1 iovec for the buf log format structure and 1 for each
+ * stretch of non-contiguous chunks to be logged.  Contiguous chunks are logged
+ * in a single iovec.
+ *
+ * Discontiguous buffers need a format structure per region that that is being
+ * logged. This makes the changes in the buffer appear to log recovery as though
+ * they came from separate buffers, just like would occur if multiple buffers
+ * were used instead of a single discontiguous buffer. This enables
+ * discontiguous buffers to be in-memory constructs, completely transparent to
+ * what ends up on disk.
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
+	int			i;
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
+	nvecs = 0;
+	for (i = 0; i < bip->bli_format_count; i++) {
+		nvecs += xfs_buf_item_size_segment(bip, &bip->bli_formats[i]);
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
@@ -235,38 +277,34 @@ xfs_buf_item_format(
 	uint		nbits;
 	uint		buffer_offset;
 
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
-	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
-	       (bip->bli_flags & XFS_BLI_STALE));
+	/* copy the flags across from the base format item */
+	blfp->blf_flags = bip->bli_format.blf_flags;
 
 	/*
-	 * The size of the base structure is the size of the
-	 * declared structure plus the space for the extra words
-	 * of the bitmap.  We subtract one from the map size, because
-	 * the first element of the bitmap is accounted for in the
-	 * size of the base structure.
+	 * Base size is the actual size of the ondisk structure - it reflects
+	 * the actual size of the dirty bitmap rather than the size of the in
+	 * memory structure. The xfs_buf_log_format size is the maximum,
+	 * subtract the unused part of the bitmap from it.
 	 */
-	base_size =
-		(uint)(sizeof(xfs_buf_log_format_t) +
-		       ((bip->bli_format.blf_map_size - 1) * sizeof(uint)));
-	vecp->i_addr = &bip->bli_format;
+	base_size = sizeof(struct xfs_buf_log_format) -
+		    ((XFS_BLF_DATAMAP_SIZE - blfp->blf_map_size) * sizeof(uint));
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
@@ -276,16 +314,15 @@ xfs_buf_item_format(
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
@@ -296,9 +333,8 @@ xfs_buf_item_format(
 		 * if there are no more bits set or the start bit is
 		 * beyond the end of the bitmap.
 		 */
-		next_bit = xfs_next_bit(bip->bli_format.blf_data_map,
-						 bip->bli_format.blf_map_size,
-						 (uint)last_bit + 1);
+		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
+					(uint)last_bit + 1);
 		/*
 		 * If we run out of bits fill in the last iovec and get
 		 * out of the loop.
@@ -309,14 +345,14 @@ xfs_buf_item_format(
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
@@ -325,14 +361,17 @@ xfs_buf_item_format(
 			first_bit = next_bit;
 			last_bit = next_bit;
 			nbits = 1;
-		} else if (xfs_buf_offset(bp, next_bit << XFS_BLF_SHIFT) !=
-			   (xfs_buf_offset(bp, last_bit << XFS_BLF_SHIFT) +
+		} else if (xfs_buf_offset(bp, offset +
+					      (next_bit << XFS_BLF_SHIFT)) !=
+			   (xfs_buf_offset(bp, offset +
+					       (last_bit << XFS_BLF_SHIFT)) +
 			    XFS_BLF_CHUNK)) {
-			buffer_offset = first_bit * XFS_BLF_CHUNK;
+			buffer_offset = offset + first_bit * XFS_BLF_CHUNK;
 			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
 			vecp->i_len = nbits * XFS_BLF_CHUNK;
 			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
-/* You would think we need to bump the nvecs here too, but we do not
+/*
+ * You would think we need to bump the nvecs here too, but we do not
  * this number is used by recovery, and it gets confused by the boundary
  * split here
  *			nvecs++;
@@ -347,6 +386,37 @@ xfs_buf_item_format(
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
+	struct xfs_buf		*bp = bip->bli_buf;
+	uint			offset = 0;
+	int			i;
+
+	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
+	       (bip->bli_flags & XFS_BLI_STALE));
+
+	for (i = 0; i < bip->bli_format_count; i++) {
+		vecp = xfs_buf_item_format_segment(bip, vecp, offset,
+						&bip->bli_formats[i]);
+		offset += bp->b_maps[i].bm_len;
+	}
+
+	/* clear the in-memory inode buffer state now formatting is done. */
+	bip->bli_flags &= ~XFS_BLI_INODE_BUF;
 
 	/*
 	 * Check to make sure everything is consistent.
@@ -622,6 +692,35 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_committing = xfs_buf_item_committing
 };
 
+STATIC int
+xfs_buf_item_get_format(
+	struct xfs_buf_log_item	*bip,
+	int			count)
+{
+	ASSERT(bip->bli_formats == NULL);
+	bip->bli_format_count = count;
+
+	if (count == 1) {
+		bip->bli_formats = &bip->bli_format;
+		return 0;
+	}
+
+	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
+				KM_SLEEP);
+	if (!bip->bli_formats)
+		return ENOMEM;
+	return 0;
+}
+
+STATIC void
+xfs_buf_item_free_format(
+	struct xfs_buf_log_item	*bip)
+{
+	if (bip->bli_formats != &bip->bli_format) {
+		kmem_free(bip->bli_formats);
+		bip->bli_formats = NULL;
+	}
+}
 
 /*
  * Allocate a new buf log item to go with the given buffer.
@@ -639,6 +738,8 @@ xfs_buf_item_init(
 	xfs_buf_log_item_t	*bip;
 	int			chunks;
 	int			map_size;
+	int			error;
+	int			i;
 
 	/*
 	 * Check to see if there is already a buf log item for
@@ -650,25 +751,32 @@ xfs_buf_item_init(
 	if (lip != NULL && lip->li_type == XFS_LI_BUF)
 		return;
 
-	/*
-	 * chunks is the number of XFS_BLF_CHUNK size pieces
-	 * the buffer can be divided into. Make sure not to
-	 * truncate any pieces.  map_size is the size of the
-	 * bitmap needed to describe the chunks of the buffer.
-	 */
-	chunks = (int)((BBTOB(bp->b_length) + (XFS_BLF_CHUNK - 1)) >>
-								XFS_BLF_SHIFT);
-	map_size = (int)((chunks + NBWORD) >> BIT_TO_WORD_SHIFT);
-
-	bip = (xfs_buf_log_item_t*)kmem_zone_zalloc(xfs_buf_item_zone,
-						    KM_SLEEP);
+	bip = kmem_zone_zalloc(xfs_buf_item_zone, KM_SLEEP);
 	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
 	bip->bli_buf = bp;
 	xfs_buf_hold(bp);
-	bip->bli_format.blf_type = XFS_LI_BUF;
-	bip->bli_format.blf_blkno = (__int64_t)XFS_BUF_ADDR(bp);
-	bip->bli_format.blf_len = (ushort)bp->b_length;
-	bip->bli_format.blf_map_size = map_size;
+
+	/*
+	 * chunks is the number of XFS_BLF_CHUNK size pieces the buffer
+	 * can be divided into. Make sure not to truncate any pieces.
+	 * map_size is the size of the bitmap needed to describe the
+	 * chunks of the buffer.
+	 *
+	 * Discontiguous buffer support follows the layout of the underlying
+	 * buffer. This makes the implementation as simple as possible.
+	 */
+	error = xfs_buf_item_get_format(bip, bp->b_map_count);
+	ASSERT(error == 0);
+
+	for (i = 0; i < bip->bli_format_count; i++) {
+		chunks = DIV_ROUND_UP(bp->b_maps[i].bm_len, XFS_BLF_CHUNK);
+		map_size = (chunks + NBWORD) >> BIT_TO_WORD_SHIFT;
+
+		bip->bli_formats[i].blf_type = XFS_LI_BUF;
+		bip->bli_formats[i].blf_blkno = bp->b_maps[i].bm_bn;
+		bip->bli_formats[i].blf_len = bp->b_maps[i].bm_len;
+		bip->bli_formats[i].blf_map_size = map_size;
+	}
 
 #ifdef XFS_TRANS_DEBUG
 	/*
@@ -699,10 +807,11 @@ xfs_buf_item_init(
  * item's bitmap.
  */
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
@@ -715,12 +824,6 @@ xfs_buf_item_log(
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
@@ -736,7 +839,7 @@ xfs_buf_item_log(
 	 * to set a bit in.
 	 */
 	word_num = first_bit >> BIT_TO_WORD_SHIFT;
-	wordp = &(bip->bli_format.blf_data_map[word_num]);
+	wordp = &map[word_num];
 
 	/*
 	 * Calculate the starting bit in the first word.
@@ -783,6 +886,55 @@ xfs_buf_item_log(
 	xfs_buf_item_log_debug(bip, first, last);
 }
 
+/*
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
+		end = start + bp->b_maps[i].bm_len;
+		if (first > end) {
+			start += bp->b_maps[i].bm_len;
+			continue;
+		}
+		if (end > last)
+			end = last;
+
+		xfs_buf_item_log_segment(bip, start, end,
+					 &bip->bli_formats[i].blf_data_map[0]);
+
+		start += bp->b_maps[i].bm_len;
+	}
+}
+
 
 /*
  * Return 1 if the buffer has some data that has been logged (at any
@@ -804,6 +956,7 @@ xfs_buf_item_free(
 	kmem_free(bip->bli_logged);
 #endif /* XFS_TRANS_DEBUG */
 
+	xfs_buf_item_free_format(bip);
 	kmem_zone_free(xfs_buf_item_zone, bip);
 }
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index ff26867..6850f49 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -102,6 +102,8 @@ typedef struct xfs_buf_log_item {
 	char			*bli_orig;	/* original buffer copy */
 	char			*bli_logged;	/* bytes logged (bitmap) */
 #endif
+	int			bli_format_count;	/* count of headers */
+	struct xfs_buf_log_format *bli_formats;	/* array of in-log header ptrs */
 	struct xfs_buf_log_format bli_format;	/* embedded in-log header */
 } xfs_buf_log_item_t;
 
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

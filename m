Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 95D817F51
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 16:26:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7BC688F8035
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 14:26:20 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wwsQH7PH7z9VI409 for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 14:26:16 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WHhUg-0003jb-8W
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 09:25:54 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WHhUg-0003Kk-6U
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 09:25:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] [RFC] xfs: byte range buffer dirty region tracking
Date: Mon, 24 Feb 2014 09:25:54 +1100
Message-Id: <1393194354-12780-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The biggest problem with large directory block sizes is the CPU
overhead in maintaining the buffer log item direty region bitmap.
The bit manipulations and buffer region mapping calls are right at
the top of the profiles when running tests on 64k directory buffers:

+  16.65%  [kernel]  [k] memcpy
+  11.99%  [kernel]  [k] xfs_next_bit
+   5.87%  [kernel]  [k] xfs_buf_item_format
+   5.85%  [kernel]  [k] xfs_buf_item_size_segment.isra.4
+   5.72%  [kernel]  [k] xfs_buf_offset

The memcpy is the copying of the dirty regions into the log vec
array, but almost twice as much CPU time is spent working out what
needs to be copied and where it needs to be copied from. As a
result, on a production kernel creating 100,000 entries in a 64k
directory runs at about 9,000 files/s while on a 4k directory block
size it runs at 19,000 files/s - about half the speed.

Switching this to just track the first and last modified bytes in
the block and only converting that to a dirty bitmap in the buffer
log item at format time, however, gets rid of most of this dirty
bitmap overhead without increasing memcpy time  at all. the result
is that peformance on a 64k directory block size increases to
roughly 16,000 files/s with memcpy() overhead only slightly
increasing.

The code so far is a rudimentary proof of concept.  The point for
discussion is not whether the technique works (clearly it does) or
whether the code is production quality (clearly it isn't), but how
to apply apply it appropriately.

I think that we need to track multiple regions - 3 or 4 is probably
sufficient - because the nature of directory operations are that
just about every operation modifies a header in the buffer, a tail
section in the buffer and then some number of bytes/regions in the
middle of the buffer.

Hence if we just track a signle region, it will almost always cover
the entire directory buffer - if we only modify a single entry in
the buffer, then that's a fairly large cost in terms of log space
and CPU overhead for random individual operations. If we decide that
we are going to use a single range, then we may as well just use the
dirty flag and log the entire buffer every time.

We also have to consider non-directory buffer modification patterns.
freespace, inode and extent btrees are the other major types of
buffers that get logged, but they also have modification patterns
that lend themselves well to a small number of ranges for dirty
tracking. That is, each btree block is kept compact, so when we
insert or remove a record or pointer we shift then higher
records/ptrs up or down as a block, and then log the lot of them.
And they also often have a header that is dirtied with each
insert/delete, so typically there are usually only one or two dirty
ranges in a btree block.

The only metadata type that really seems to benefit from dirty range
logging is the inode buffers. Specifically, for v4 sueprblocks the
create transaction only dirties the regions of the inode core, so
for 256 byte inodes only dirties every alternate bitmap segement.
Dirty range tracking will double the required log bandwidth of inode
buffers during create (roughly 25% increase on a 4k directory block
size filesystem). There isn't any performance differential noticable
on typical systems because the log is far from being bandwidth
bound.

For v5 filesystems, this isn't an issue because the initialised
inode buffers are XFS_BLI_ORDERED buffers and so their contents
aren't logged.

The same problem happens with unlinks. Again there is an increase in
log bandwidth on both v4 and v5 filesystems, but there isn't any
performance differential that occurs because, again, the log isn't
bandwidth bound. As it is, there is an existing plan of improvement
to the unlinked list logging (moving the unlinked list logging into
the inode core transaction) and hence that will avoid any extra
overhead here as well.

Overall, I think this is a no-brainer given the performance
improvements we get on large directory block size filesystems. There
are some downsides, but looking at the medium-term development plans
we are planning to mitigate the impact of most of those downsides.
Hence I think this is the way forward.

Discuss. :)


Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c      |   2 +
 fs/xfs/xfs_buf_item.c | 357 +++++++++++++++++++++++---------------------------
 fs/xfs/xfs_buf_item.h |  14 ++
 3 files changed, 179 insertions(+), 194 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9c061ef..21dfdad 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1428,6 +1428,8 @@ xfs_buf_iomove(
 		page = bp->b_pages[page_index];
 		csize = min_t(size_t, PAGE_SIZE - page_offset,
 				      BBTOB(bp->b_io_length) - boff);
+		if (boff + csize > bend)
+			csize = bend - boff;
 
 		ASSERT((csize + page_offset) <= PAGE_SIZE);
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8752821..dddda58 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -69,46 +69,12 @@ xfs_buf_item_size_segment(
 	int			next_bit;
 	int			last_bit;
 
-	last_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
-	if (last_bit == -1)
-		return;
-
 	/*
 	 * initial count for a dirty buffer is 2 vectors - the format structure
-	 * and the first dirty region.
+	 * and the dirty region. Dirty region is accounted for separately.
 	 */
 	*nvecs += 2;
-	*nbytes += xfs_buf_log_format_size(blfp) + XFS_BLF_CHUNK;
-
-	while (last_bit != -1) {
-		/*
-		 * This takes the bit number to start looking from and
-		 * returns the next set bit from there.  It returns -1
-		 * if there are no more bits set or the start bit is
-		 * beyond the end of the bitmap.
-		 */
-		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
-					last_bit + 1);
-		/*
-		 * If we run out of bits, leave the loop,
-		 * else if we find a new set of bits bump the number of vecs,
-		 * else keep scanning the current set of bits.
-		 */
-		if (next_bit == -1) {
-			break;
-		} else if (next_bit != last_bit + 1) {
-			last_bit = next_bit;
-			(*nvecs)++;
-		} else if (xfs_buf_offset(bp, next_bit * XFS_BLF_CHUNK) !=
-			   (xfs_buf_offset(bp, last_bit * XFS_BLF_CHUNK) +
-			    XFS_BLF_CHUNK)) {
-			last_bit = next_bit;
-			(*nvecs)++;
-		} else {
-			last_bit++;
-		}
-		*nbytes += XFS_BLF_CHUNK;
-	}
+	*nbytes += xfs_buf_log_format_size(blfp);
 }
 
 /*
@@ -135,6 +101,8 @@ xfs_buf_item_size(
 	int			*nbytes)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf	*bp = bip->bli_buf;
+	uint			offset = 0;
 	int			i;
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
@@ -175,10 +143,31 @@ xfs_buf_item_size(
 	 * count for the extra buf log format structure that will need to be
 	 * written.
 	 */
+	if (bip->bli_range[0].last == 0) {
+		/* clean! */
+		ASSERT(bip->bli_range[0].first == 0);
+		return;
+	}
+
 	for (i = 0; i < bip->bli_format_count; i++) {
-		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
-					  nvecs, nbytes);
+		struct xfs_bli_range *rp = &bip->bli_range[0];
+
+		//xfs_warn(NULL, "rf = 0x%x, rl = 0x%x, off 0x%x, len 0x%x",
+			//rp->first, rp->last, offset, BBTOB(bp->b_maps[i].bm_len));
+
+		/*
+		 * Only format dirty regions or stale buffers
+		 */
+		if ((rp->first <= offset + BBTOB(bp->b_maps[i].bm_len) &&
+		     rp->last >= offset))
+			xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
+						  nvecs, nbytes);
+		offset += BBTOB(bp->b_maps[i].bm_len);
 	}
+	*nbytes += bip->bli_range[0].last - bip->bli_range[0].first;
+	//xfs_warn(NULL, "nvecs %d, nbytes 0x%x", *nvecs, *nbytes);
+
+
 	trace_xfs_buf_item_size(bip);
 }
 
@@ -191,7 +180,6 @@ xfs_buf_item_copy_iovec(
 	int			first_bit,
 	uint			nbits)
 {
-	offset += first_bit * XFS_BLF_CHUNK;
 	xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BCHUNK,
 			xfs_buf_offset(bp, offset),
 			nbits * XFS_BLF_CHUNK);
@@ -210,18 +198,85 @@ xfs_buf_item_straddle(
 }
 
 static void
+xfs_set_bits(
+	unsigned int	*map,
+	unsigned int	first_bit,
+	unsigned int	bits_to_set)
+{
+	uint            bits_set;
+	uint            word_num;
+	uint            *wordp;
+	uint            bit;
+	uint            end_bit;
+	uint            mask;
+
+	/*
+	 * Get a pointer to the first word in the bitmap
+	 * to set a bit in.
+	 */
+	word_num = first_bit >> BIT_TO_WORD_SHIFT;
+	wordp = &map[word_num];
+
+	/*
+	 * Calculate the starting bit in the first word.
+	 */
+	bit = first_bit & (uint)(NBWORD - 1);
+
+	/*
+	 * First set any bits in the first word of our range.
+	 * If it starts at bit 0 of the word, it will be
+	 * set below rather than here.  That is what the variable
+	 * bit tells us. The variable bits_set tracks the number
+	 * of bits that have been set so far.  End_bit is the number
+	 * of the last bit to be set in this word plus one.
+	 */
+	if (bit) {
+		end_bit = MIN(bit + bits_to_set, (uint)NBWORD);
+		mask = ((1 << (end_bit - bit)) - 1) << bit;
+		*wordp |= mask;
+		wordp++;
+		bits_set = end_bit - bit;
+	} else {
+		bits_set = 0;
+	}
+
+	/*
+	 * Now set bits a whole word at a time that are between
+	 * first_bit and last_bit.
+	 */
+	while ((bits_to_set - bits_set) >= NBWORD) {
+		*wordp |= 0xffffffff;
+		bits_set += NBWORD;
+		wordp++;
+	}
+
+	/*
+	 * Finally, set any bits left to be set in one last partial word.
+	 */
+	end_bit = bits_to_set - bits_set;
+	if (end_bit) {
+		mask = (1 << end_bit) - 1;
+		*wordp |= mask;
+	}
+}
+
+static void
 xfs_buf_item_format_segment(
 	struct xfs_buf_log_item	*bip,
 	struct xfs_log_vec	*lv,
 	struct xfs_log_iovec	**vecp,
+	struct xfs_bli_range	*rp,
 	uint			offset,
+	uint			length,
 	struct xfs_buf_log_format *blfp)
 {
 	struct xfs_buf	*bp = bip->bli_buf;
+	char		*buf;
 	uint		base_size;
+	uint		start;
+	uint		end;
 	int		first_bit;
 	int		last_bit;
-	int		next_bit;
 	uint		nbits;
 
 	/* copy the flags across from the base format item */
@@ -233,16 +288,6 @@ xfs_buf_item_format_segment(
 	 * memory structure.
 	 */
 	base_size = xfs_buf_log_format_size(blfp);
-
-	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
-	if (!(bip->bli_flags & XFS_BLI_STALE) && first_bit == -1) {
-		/*
-		 * If the map is not be dirty in the transaction, mark
-		 * the size as zero and do not advance the vector pointer.
-		 */
-		return;
-	}
-
 	blfp = xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
 	blfp->blf_size = 1;
 
@@ -257,46 +302,46 @@ xfs_buf_item_format_segment(
 		return;
 	}
 
+	blfp->blf_size++;
 
 	/*
-	 * Fill in an iovec for each set of contiguous chunks.
+	 * Now we need to set the bits in the bitmap and set up the iovecs
+	 * appropriately. We know there is a contiguous range in this buffer
+	 * than needs to be set, so find the first bit, the last bit, and
+	 * go from there.
 	 */
-	last_bit = first_bit;
-	nbits = 1;
-	for (;;) {
-		/*
-		 * This takes the bit number to start looking from and
-		 * returns the next set bit from there.  It returns -1
-		 * if there are no more bits set or the start bit is
-		 * beyond the end of the bitmap.
-		 */
-		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
-					(uint)last_bit + 1);
-		/*
-		 * If we run out of bits fill in the last iovec and get out of
-		 * the loop.  Else if we start a new set of bits then fill in
-		 * the iovec for the series we were looking at and start
-		 * counting the bits in the new one.  Else we're still in the
-		 * same set of bits so just keep counting and scanning.
-		 */
-		if (next_bit == -1) {
-			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
-						first_bit, nbits);
-			blfp->blf_size++;
-			break;
-		} else if (next_bit != last_bit + 1 ||
-		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
-			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
-						first_bit, nbits);
-			blfp->blf_size++;
-			first_bit = next_bit;
-			last_bit = next_bit;
-			nbits = 1;
-		} else {
-			last_bit++;
-			nbits++;
-		}
-	}
+	start = 0;
+	if (offset < rp->first)
+		start = rp->first - offset;
+	end = length - 1;
+	if (offset + length > rp->last)
+		end = rp->last - offset - 1;
+
+	start &= ~((1 << XFS_BLF_SHIFT) - 1);
+
+	first_bit = start >> XFS_BLF_SHIFT;
+	last_bit = end >> XFS_BLF_SHIFT;
+	nbits = last_bit - first_bit + 1;
+	//xfs_warn(NULL, "fb = %d, lb = %d, start 0x%x, end 0x%x\n",
+		//first_bit, last_bit, start, end);
+	//xfs_set_bits(blfp->blf_data_map, first_bit, nbits);
+	bitmap_set((unsigned long *)blfp->blf_data_map, first_bit, nbits);
+	//xfs_hex_dump(blfp->blf_data_map, 4);
+
+	ASSERT(end <= length);
+	ASSERT(start <= length);
+	ASSERT(start + end <= length);
+	ASSERT(length >= nbits * XFS_BLF_CHUNK);
+	/*
+	 * Copy needs to be done a buffer page at a time as we can be logging
+	 * unmapped buffers. hence we have to use xfs_buf_iomove() rather than a
+	 * straight memcpy here.
+	 */
+	offset += first_bit * XFS_BLF_CHUNK;
+	length = nbits * XFS_BLF_CHUNK;
+	buf = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_BCHUNK);
+	xfs_buf_iomove(bp, offset, length, buf, XBRW_READ);
+	xlog_finish_iovec(lv, *vecp, length);
 }
 
 /*
@@ -320,6 +365,7 @@ xfs_buf_item_format(
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
 
+	//xfs_warn(NULL, "%s 0x%llx", __func__, bp->b_bn);
 	/*
 	 * If it is an inode buffer, transfer the in-memory state to the
 	 * format flags and clear the in-memory state.
@@ -352,10 +398,29 @@ xfs_buf_item_format(
 		return;
 	}
 
+	if (!(bip->bli_flags & XFS_BLI_STALE) && bip->bli_range[0].last == 0) {
+		/* clean! */
+		ASSERT(bip->bli_range[0].first == 0);
+		return;
+	}
+
 	for (i = 0; i < bip->bli_format_count; i++) {
-		xfs_buf_item_format_segment(bip, lv, &vecp, offset,
-					    &bip->bli_formats[i]);
-		offset += bp->b_maps[i].bm_len;
+		struct xfs_bli_range *rp = &bip->bli_range[0];
+
+		//xfs_warn(NULL, "rf = 0x%x, rl = 0x%x, off 0x%x, len 0x%x",
+			//rp->first, rp->last, offset,
+			//BBTOB(bp->b_maps[i].bm_len));
+
+		/*
+		 * Only format dirty regions or stale buffers
+		 */
+		if ((bip->bli_flags & XFS_BLI_STALE) ||
+		    (rp->first <= offset + BBTOB(bp->b_maps[i].bm_len) &&
+		     rp->last >= offset))
+			xfs_buf_item_format_segment(bip, lv, &vecp, rp, offset,
+						    BBTOB(bp->b_maps[i].bm_len),
+						    &bip->bli_formats[i]);
+		offset += BBTOB(bp->b_maps[i].bm_len);
 	}
 
 	/*
@@ -807,90 +872,7 @@ xfs_buf_item_init(
 
 
 /*
- * Mark bytes first through last inclusive as dirty in the buf
- * item's bitmap.
- */
-static void
-xfs_buf_item_log_segment(
-	struct xfs_buf_log_item	*bip,
-	uint			first,
-	uint			last,
-	uint			*map)
-{
-	uint		first_bit;
-	uint		last_bit;
-	uint		bits_to_set;
-	uint		bits_set;
-	uint		word_num;
-	uint		*wordp;
-	uint		bit;
-	uint		end_bit;
-	uint		mask;
-
-	/*
-	 * Convert byte offsets to bit numbers.
-	 */
-	first_bit = first >> XFS_BLF_SHIFT;
-	last_bit = last >> XFS_BLF_SHIFT;
-
-	/*
-	 * Calculate the total number of bits to be set.
-	 */
-	bits_to_set = last_bit - first_bit + 1;
-
-	/*
-	 * Get a pointer to the first word in the bitmap
-	 * to set a bit in.
-	 */
-	word_num = first_bit >> BIT_TO_WORD_SHIFT;
-	wordp = &map[word_num];
-
-	/*
-	 * Calculate the starting bit in the first word.
-	 */
-	bit = first_bit & (uint)(NBWORD - 1);
-
-	/*
-	 * First set any bits in the first word of our range.
-	 * If it starts at bit 0 of the word, it will be
-	 * set below rather than here.  That is what the variable
-	 * bit tells us. The variable bits_set tracks the number
-	 * of bits that have been set so far.  End_bit is the number
-	 * of the last bit to be set in this word plus one.
-	 */
-	if (bit) {
-		end_bit = MIN(bit + bits_to_set, (uint)NBWORD);
-		mask = ((1 << (end_bit - bit)) - 1) << bit;
-		*wordp |= mask;
-		wordp++;
-		bits_set = end_bit - bit;
-	} else {
-		bits_set = 0;
-	}
-
-	/*
-	 * Now set bits a whole word at a time that are between
-	 * first_bit and last_bit.
-	 */
-	while ((bits_to_set - bits_set) >= NBWORD) {
-		*wordp |= 0xffffffff;
-		bits_set += NBWORD;
-		wordp++;
-	}
-
-	/*
-	 * Finally, set any bits left to be set in one last partial word.
-	 */
-	end_bit = bits_to_set - bits_set;
-	if (end_bit) {
-		mask = (1 << end_bit) - 1;
-		*wordp |= mask;
-	}
-}
-
-/*
- * Mark bytes first through last inclusive as dirty in the buf
- * item's bitmap.
+ * record dirty regions on the buffer.
  */
 void
 xfs_buf_item_log(
@@ -903,28 +885,15 @@ xfs_buf_item_log(
 	uint			end;
 	struct xfs_buf		*bp = bip->bli_buf;
 
-	/*
-	 * walk each buffer segment and mark them dirty appropriately.
-	 */
-	start = 0;
-	for (i = 0; i < bip->bli_format_count; i++) {
-		if (start > last)
-			break;
-		end = start + BBTOB(bp->b_maps[i].bm_len);
-		if (first > end) {
-			start += BBTOB(bp->b_maps[i].bm_len);
-			continue;
-		}
-		if (first < start)
-			first = start;
-		if (end > last)
-			end = last;
+	//xfs_warn(NULL, "bil f 0x%x/0x%x l 0x%x/0x%x",
+		//first, bip->bli_range[0].first, last, bip->bli_range[0].last);
 
-		xfs_buf_item_log_segment(bip, first, end,
-					 &bip->bli_formats[i].blf_data_map[0]);
+	/* initial implementation - single range */
+	if (first < bip->bli_range[0].first)
+		bip->bli_range[0].first = rounddown(first, XFS_BLF_CHUNK);
+	if (last > bip->bli_range[0].last)
+		bip->bli_range[0].last = roundup(last, XFS_BLF_CHUNK);
 
-		start += bp->b_maps[i].bm_len;
-	}
 }
 
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 3f3455a..97cefc4 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -57,6 +57,20 @@ typedef struct xfs_buf_log_item {
 	unsigned int		bli_recur;	/* lock recursion count */
 	atomic_t		bli_refcount;	/* cnt of tp refs */
 	int			bli_format_count;	/* count of headers */
+
+	/*
+	 * logging ranges. Keep a small number of distinct ranges rather than a
+	 * bitmap which is expensive to maintain. 4 is chosen at first to be
+	 * able to keep a header region, a tail region, and a couple separate
+	 * regions in the middle if necessary
+	 */
+#define XFS_BLI_RANGES	4
+	struct xfs_bli_range {
+		uint16_t	first;
+		uint16_t	last;
+	}			bli_range[XFS_BLI_RANGES];
+	int			bli_ranges;
+
 	struct xfs_buf_log_format *bli_formats;	/* array of in-log header ptrs */
 	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
 } xfs_buf_log_item_t;
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

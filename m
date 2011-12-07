Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB76IxcE046650 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 00:18:59 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EF1B2A1EAD
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 22:18:53 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BQTnTBhQBoSDp59g for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 22:18:53 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RYAqA-0003oI-Cm
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:50 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RYAq0-0003Ur-1n
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/12] xfs: support multiple irec maps in buffer code
Date: Wed,  7 Dec 2011 17:18:19 +1100
Message-Id: <1323238703-13198-9-git-send-email-david@fromorbit.com>
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

Add support for initialising and doing IO on multi-segment compound
buffers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c |  317 ++++++++++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_buf.h |    7 +-
 2 files changed, 228 insertions(+), 96 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2ca9086..c533597 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -166,13 +166,15 @@ xfs_buf_stale(
 }
 
 struct xfs_buf *
-xfs_buf_alloc(
+xfs_buf_alloc_irec(
 	struct xfs_buftarg	*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
+	struct xfs_bmbt_irec	*map,
+	int			nmaps,
 	xfs_buf_flags_t		flags)
 {
+	xfs_daddr_t		blkno;
 	struct xfs_buf		*bp;
+	int			i;
 
 	bp = kmem_zone_alloc(xfs_buf_zone, xb_to_km(flags));
 	if (unlikely(!bp))
@@ -193,21 +195,45 @@ xfs_buf_alloc(
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
 	XB_SET_OWNER(bp);
 	bp->b_target = target;
-	bp->b_file_offset = blkno << BBSHIFT;
+	bp->b_flags = flags;
+
+	/* initialise the buffer IO vector array appropriately */
+	if (nmaps <= XB_VECS) {
+		bp->b_vec = &bp->b_vec_array[0];
+	} else {
+		bp->b_vec = kmem_alloc(nmaps * sizeof(*bp->b_vec),
+					xb_to_km(flags));
+		if (!bp->b_vec) {
+			kmem_zone_free(xfs_buf_zone, bp);
+			return NULL;
+		}
+	}
+	bp->b_vec_count = nmaps;
+	bp->b_buffer_length = 0;
+
+	if (map[0].br_state == XFS_EXT_DADDR)
+		blkno = map[0].br_startblock;
+	else
+		blkno = XFS_FSB_TO_DADDR(target->bt_mount, map[0].br_startblock);
+	bp->b_file_offset = BBTOB(blkno);
+
+	for (i = 0; i < nmaps; i++) {
+		if (map[0].br_state == XFS_EXT_DADDR) {
+			bp->b_vec[i].bv_len += BBTOB(map[i].br_blockcount);
+		} else {
+			bp->b_vec[i].bv_len += XFS_FSB_TO_B(target->bt_mount,
+						 map[i].br_blockcount);
+		}
+		bp->b_buffer_length += bp->b_vec[i].bv_len;
+		bp->b_vec[i].bv_bn = XFS_BUF_DADDR_NULL;
+	}
+
 	/*
 	 * Set buffer_length and count_desired to the same value initially.
 	 * I/O routines should use count_desired, which will be the same in
 	 * most cases but may be reset (e.g. XFS recovery).
 	 */
-	bp->b_buffer_length = bp->b_count_desired = numblks << BBSHIFT;
-	bp->b_flags = flags;
-
-	/* XXX: we have the block number. Why don't we just set it here? */
-	/* initialise the buffer IO vector array appropriately */
-	bp->b_vec_count = 1;
-	bp->b_vec = &bp->b_vec_array[0];
-	bp->b_vec[0].bv_bn = XFS_BUF_DADDR_NULL;
-	bp->b_vec[0].bv_len = bp->b_buffer_length;
+	bp->b_count_desired = bp->b_buffer_length;
 
 	atomic_set(&bp->b_pin_count, 0);
 	init_waitqueue_head(&bp->b_waiters);
@@ -218,6 +244,22 @@ xfs_buf_alloc(
 	return bp;
 }
 
+struct xfs_buf *
+xfs_buf_alloc(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	xfs_buf_flags_t		flags)
+{
+	struct xfs_bmbt_irec	map = {
+		.br_startblock = blkno,
+		.br_blockcount = numblks,
+		.br_state = XFS_EXT_DADDR,
+	};
+
+	return xfs_buf_alloc_irec(target, &map, 1, flags);
+}
+
 /*
  *	Allocate a page array capable of holding a specified number
  *	of pages, and point the page buf at it.
@@ -287,6 +329,10 @@ xfs_buf_free(
 		}
 	} else if (bp->b_flags & _XBF_KMEM)
 		kmem_free(bp->b_addr);
+
+	if (bp->b_vec_count > XB_VECS)
+		kmem_free(bp->b_vec);
+
 	_xfs_buf_free_pages(bp);
 	kmem_zone_free(xfs_buf_zone, bp);
 }
@@ -429,11 +475,11 @@ _xfs_buf_map_pages(
  *	a given range of an inode.  The buffer is returned
  *	locked.	No I/O is implied by this call.
  */
-xfs_buf_t *
-_xfs_buf_find(
+static xfs_buf_t *
+xfs_buf_find_irec(
 	xfs_buftarg_t		*btp,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
+	struct xfs_bmbt_irec	*map,
+	int			nmaps,
 	xfs_buf_flags_t		flags,
 	xfs_buf_t		*new_bp)
 {
@@ -442,14 +488,37 @@ _xfs_buf_find(
 	struct xfs_perag	*pag;
 	struct rb_node		**rbp;
 	struct rb_node		*parent;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
+	xfs_daddr_t		blkno;
+	int			i;
 
-	offset = blkno << BBSHIFT;
-	numbytes = numblks << BBSHIFT;
+	/*
+	 * Check for IOs smaller than the sector size or not sector aligned,
+	 * calculate the size of the buffer and initialise variables that ggc
+	 * thinks get unused without initialisation because it can't grok the
+	 * fact they are initialised within the loop body.
+	 */
+	numbytes = 0;
+	offset = 0;
+	blkno = XFS_BUF_DADDR_NULL;
+	for (i = 0; i < nmaps; i++) {
+		size_t	len;
+
+		if (map[0].br_state == XFS_EXT_DADDR) {
+			len = BBTOB(map[i].br_blockcount);
+			blkno = map[i].br_startblock;
+		} else {
+			len = XFS_FSB_TO_B(btp->bt_mount, map[i].br_blockcount);
+			blkno = XFS_FSB_TO_DADDR(btp->bt_mount,
+							map[i].br_startblock);
+		}
+		ASSERT(!(len < (1 << btp->bt_sshift)));
+		ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_smask));
+		numbytes += len;
+		if (i == 0)
+			offset = BBTOB(blkno);
 
-	/* Check for IOs smaller than the sector size / not sector aligned */
-	ASSERT(!(numbytes < (1 << btp->bt_sshift)));
-	ASSERT(!(offset & (xfs_off_t)btp->bt_smask));
+	}
 
 	/* get tree root */
 	pag = xfs_perag_get(btp->bt_mount,
@@ -530,27 +599,6 @@ found:
 	return bp;
 }
 
-/*
- * Assembles a buffer covering the specified range. The code is optimised for
- * cache hits, as metadata intensive workloads will see 3 orders of magnitude
- * more hits than misses.
- */
-struct xfs_buf *
-xfs_buf_get(
-	xfs_buftarg_t		*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
-	xfs_buf_flags_t		flags)
-{
-	struct xfs_bmbt_irec	map = {
-		.br_startblock = blkno,
-		.br_blockcount = numblks,
-		.br_state = XFS_EXT_DADDR,
-	};
-
-	return xfs_buf_get_irec(target, &map, 1, flags);
-}
-
 STATIC int
 _xfs_buf_read(
 	xfs_buf_t		*bp,
@@ -571,7 +619,9 @@ _xfs_buf_read(
 }
 
 /*
- * XXX: only supports a single map for now
+ * Assembles a buffer covering the specified range. The code is optimised for
+ * cache hits, as metadata intensive workloads will see 3 orders of magnitude
+ * more hits than misses.
  */
 struct xfs_buf *
 xfs_buf_get_irec(
@@ -580,31 +630,20 @@ xfs_buf_get_irec(
 	int			nmaps,
 	xfs_buf_flags_t		flags)
 {
-	xfs_daddr_t		blkno;
-	size_t			numblks;
 	struct xfs_buf		*bp;
 	struct xfs_buf		*new_bp;
 	int			error = 0;
+	int			i;
 
-	ASSERT_ALWAYS(nmaps == 1);
-
-	if (map->br_state == XFS_EXT_DADDR) {
-		blkno = map->br_startblock;
-		numblks = map->br_blockcount;
-	} else {
-		blkno = XFS_FSB_TO_DADDR(target->bt_mount, map->br_startblock);
-		numblks = XFS_FSB_TO_BB(target->bt_mount, map->br_blockcount);
-	}
-
-	bp = _xfs_buf_find(target, blkno, numblks, flags, NULL);
+	bp = xfs_buf_find_irec(target, map, nmaps, flags, NULL);
 	if (likely(bp))
 		goto found;
 
-	new_bp = xfs_buf_alloc(target, blkno, numblks, flags);
+	new_bp = xfs_buf_alloc_irec(target, map, nmaps, flags);
 	if (unlikely(!new_bp))
 		return NULL;
 
-	bp = _xfs_buf_find(target, blkno, numblks, flags, new_bp);
+	bp = xfs_buf_find_irec(target, map, nmaps, flags, new_bp);
 	if (!bp) {
 		kmem_zone_free(xfs_buf_zone, new_bp);
 		return NULL;
@@ -618,11 +657,17 @@ xfs_buf_get_irec(
 		kmem_zone_free(xfs_buf_zone, new_bp);
 
 	/*
-	 * Now we have a workable buffer, fill in the block number so
-	 * that we can do IO on it.
+	 * Now we have a workable buffer, fill in the block vector addresses
+	 * so that we can do IO on it. The lengths have already been filled in
+	 * by xfs_buf_alloc_irec().
 	 */
-	bp->b_vec[0].bv_bn = blkno;
-	bp->b_vec[0].bv_len = bp->b_buffer_length;
+	for (i = 0; i < nmaps; i++) {
+		if (map[0].br_state == XFS_EXT_DADDR)
+			bp->b_vec[i].bv_bn = map[i].br_startblock;
+		else
+			bp->b_vec[i].bv_bn = XFS_FSB_TO_DADDR(target->bt_mount,
+							map[i].br_startblock);
+	}
 	bp->b_count_desired = bp->b_buffer_length;
 
 found:
@@ -699,6 +744,39 @@ xfs_buf_readahead_irec(
 }
 
 xfs_buf_t *
+xfs_buf_find(
+	xfs_buftarg_t		*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	xfs_buf_flags_t		flags)
+{
+	struct xfs_bmbt_irec	map = {
+		.br_startblock = blkno,
+		.br_blockcount = numblks,
+		.br_state = XFS_EXT_DADDR,
+	};
+
+	return xfs_buf_find_irec(target, &map, 1, flags, NULL);
+}
+
+struct xfs_buf *
+xfs_buf_get(
+	xfs_buftarg_t		*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	xfs_buf_flags_t		flags)
+{
+	struct xfs_bmbt_irec	map = {
+		.br_startblock = blkno,
+		.br_blockcount = numblks,
+		.br_state = XFS_EXT_DADDR,
+	};
+
+	return xfs_buf_get_irec(target, &map, 1, flags);
+}
+
+
+xfs_buf_t *
 xfs_buf_read(
 	xfs_buftarg_t		*target,
 	xfs_daddr_t		blkno,
@@ -773,6 +851,8 @@ xfs_buf_set_empty(
 	struct xfs_buf		*bp,
 	size_t			numblks)
 {
+	ASSERT(bp->b_vec_count == 1);
+
 	if (bp->b_pages)
 		_xfs_buf_free_pages(bp);
 
@@ -780,7 +860,7 @@ xfs_buf_set_empty(
 	bp->b_page_count = 0;
 	bp->b_addr = NULL;
 	bp->b_file_offset = 0;
-	bp->b_buffer_length = bp->b_count_desired = numblks << BBSHIFT;
+	bp->b_buffer_length = bp->b_count_desired = BBTOB(numblks);
 	bp->b_vec[0].bv_bn = XFS_BUF_DADDR_NULL;
 	bp->b_vec[0].bv_len = bp->b_buffer_length;
 	bp->b_flags &= ~XBF_MAPPED;
@@ -849,12 +929,16 @@ xfs_buf_get_uncached(
 	unsigned long		page_count;
 	int			error, i;
 	xfs_buf_t		*bp;
+	struct xfs_bmbt_irec	map = {
+		.br_blockcount = numblks,
+		.br_state = XFS_EXT_DADDR,
+	};
 
-	bp = xfs_buf_alloc(target, 0, numblks, 0);
+	bp = xfs_buf_alloc_irec(target, &map, 1, 0);
 	if (unlikely(bp == NULL))
 		goto fail;
 
-	page_count = PAGE_ALIGN(numblks << BBSHIFT) >> PAGE_SHIFT;
+	page_count = PAGE_ALIGN(BBTOB(numblks)) >> PAGE_SHIFT;
 	error = _xfs_buf_get_pages(bp, page_count, 0);
 	if (error)
 		goto fail_free_buf;
@@ -1248,36 +1332,38 @@ xfs_buf_bio_end_io(
 	bio_put(bio);
 }
 
-STATIC void
-_xfs_buf_ioapply(
-	xfs_buf_t		*bp)
+static void
+_xfs_buf_ioapply_vec(
+	struct xfs_buf	*bp,
+	int		vec,
+	int		*buf_offset,
+	int		*count,
+	int		rw)
 {
-	int			rw, map_i, total_nr_pages, nr_pages;
+	int			map_i;
+	int			total_nr_pages = bp->b_page_count;
+	int			nr_pages;
 	struct bio		*bio;
-	int			offset = bp->b_offset;
-	int			size = bp->b_count_desired;
-	sector_t		sector = bp->b_vec[0].bv_bn;
+	sector_t		sector =  bp->b_vec[vec].bv_bn;
+	int			size;
+	int			offset;
 
 	total_nr_pages = bp->b_page_count;
-	map_i = 0;
 
-	if (bp->b_flags & XBF_WRITE) {
-		if (bp->b_flags & XBF_SYNCIO)
-			rw = WRITE_SYNC;
-		else
-			rw = WRITE;
-		if (bp->b_flags & XBF_FUA)
-			rw |= REQ_FUA;
-		if (bp->b_flags & XBF_FLUSH)
-			rw |= REQ_FLUSH;
-	} else if (bp->b_flags & XBF_READ_AHEAD) {
-		rw = READA;
-	} else {
-		rw = READ;
+	/* skip the pages in the buffer before the start offset */
+	map_i = 0;
+	offset = *buf_offset;
+	while (offset >= PAGE_SIZE) {
+		map_i++;
+		offset -= PAGE_SIZE;
 	}
 
-	/* we only use the buffer cache for meta-data */
-	rw |= REQ_META;
+	/*
+	 * Limit the IO size to the length of the current vector, and update the
+	 * remaining IO count for the next time around.
+	 */
+	size = min_t(int, bp->b_vec[vec].bv_len, *count);
+	*count -= size;
 
 next_chunk:
 	atomic_inc(&bp->b_io_remaining);
@@ -1291,7 +1377,6 @@ next_chunk:
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
 
-
 	for (; size && nr_pages; nr_pages--, map_i++) {
 		int	rbytes, nbytes = PAGE_SIZE - offset;
 
@@ -1303,7 +1388,7 @@ next_chunk:
 			break;
 
 		offset = 0;
-		sector += nbytes >> BBSHIFT;
+		sector += BTOBB(nbytes);
 		size -= nbytes;
 		total_nr_pages--;
 	}
@@ -1320,8 +1405,56 @@ next_chunk:
 		xfs_buf_ioerror(bp, EIO);
 		bio_put(bio);
 	}
+
+	/* update the start offset for the next IO */
+	*buf_offset += bp->b_vec[vec].bv_len;
+}
+
+STATIC void
+_xfs_buf_ioapply(
+	struct xfs_buf	*bp)
+{
+	int		rw;
+	int		offset;
+	int		size;
+	int		i;
+
+	if (bp->b_flags & XBF_WRITE) {
+		if (bp->b_flags & XBF_SYNCIO)
+			rw = WRITE_SYNC;
+		else
+			rw = WRITE;
+		if (bp->b_flags & XBF_FUA)
+			rw |= REQ_FUA;
+		if (bp->b_flags & XBF_FLUSH)
+			rw |= REQ_FLUSH;
+	} else if (bp->b_flags & XBF_READ_AHEAD) {
+		rw = READA;
+	} else {
+		rw = READ;
+	}
+
+	/* we only use the buffer cache for meta-data */
+	rw |= REQ_META;
+
+	/*
+	 * Walk all the vectors issuing IO on them. Set up the initial offset
+	 * into the buffer and the desired IO size before we start -
+	 * _xfs_buf_ioapply_vec() will modify them appropriately for each
+	 * subsequent call.
+	 */
+	offset = bp->b_offset;
+	size = bp->b_count_desired;
+	for (i = 0; i < bp->b_vec_count; i++) {
+		_xfs_buf_ioapply_vec(bp, i, &offset, &size, rw);
+		if (bp->b_error)
+			break;
+		if (size <= 0)
+			break;	/* all done */
+	}
 }
 
+
 int
 xfs_buf_iorequest(
 	xfs_buf_t		*bp)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index e3cbd73..71c9665 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -177,11 +177,10 @@ typedef struct xfs_buf {
 
 
 /* Finding and Reading Buffers */
-struct xfs_buf *_xfs_buf_find(struct xfs_buftarg *target, xfs_daddr_t blkno,
-				size_t numblks, xfs_buf_flags_t flags,
-				struct xfs_buf *new_bp);
+struct xfs_buf *xfs_buf_find(struct xfs_buftarg *target, xfs_daddr_t blkno,
+				size_t numblks, xfs_buf_flags_t flags);
 #define xfs_incore(buftarg,blkno,len,lockit) \
-	_xfs_buf_find(buftarg, blkno ,len, lockit, NULL)
+	xfs_buf_find(buftarg, blkno, len, lockit)
 
 struct xfs_buf *xfs_buf_get(struct xfs_buftarg *target, xfs_daddr_t blkno,
 				size_t numblks, xfs_buf_flags_t flags);
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

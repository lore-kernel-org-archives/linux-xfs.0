Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3O6Y1i3031627 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 01:34:01 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	F77m1TXHz0Wcg5D5 for <xfs@oss.sgi.com>;
	Mon, 23 Apr 2012 23:33:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMZJo-0004NN-44
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:44 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMZJn-0005tA-Vr
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/10] xfs: convert internal buffer functions to pass maps
Date: Tue, 24 Apr 2012 16:33:33 +1000
Message-Id: <1335249220-22274-4-git-send-email-david@fromorbit.com>
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

While the external interface currently uses separate blockno/length
variables, we need to move internal interfaces to passing and
parsing vector maps. This will then allow us to add external
interfaces to support discontiguous buffer maps as the internal code
will already support them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c |  207 ++++++++++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_buf.h |   46 +++++++++---
 2 files changed, 199 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0a07db4..1766edd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -164,14 +164,49 @@ xfs_buf_stale(
 	ASSERT(atomic_read(&bp->b_hold) >= 1);
 }
 
+STATIC int
+_xfs_buf_get_maps(
+	struct xfs_buf		*bp,
+	int			map_count)
+{
+	ASSERT(bp->b_maps == NULL);
+	bp->b_map_count = map_count;
+
+	if (map_count == 1) {
+		bp->b_maps = &bp->b_map;
+		return 0;
+	}
+
+	bp->b_maps = kmem_zalloc(map_count * sizeof(struct xfs_buf_map),
+				KM_NOFS);
+	if (!bp->b_maps)
+		return ENOMEM;
+	return 0;
+}
+
+/*
+ *	Frees b_pages if it was allocated.
+ */
+STATIC void
+_xfs_buf_free_maps(
+	struct xfs_buf	*bp)
+{
+	if (bp->b_maps != &bp->b_map) {
+		kmem_free(bp->b_maps);
+		bp->b_maps = NULL;
+	}
+}
+
 struct xfs_buf *
-xfs_buf_alloc(
+_xfs_buf_alloc(
 	struct xfs_buftarg	*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
+	struct xfs_buf_map	*map,
+	int			nmaps,
 	xfs_buf_flags_t		flags)
 {
 	struct xfs_buf		*bp;
+	int			error;
+	int			i;
 
 	bp = kmem_zone_zalloc(xfs_buf_zone, KM_NOFS);
 	if (unlikely(!bp))
@@ -192,16 +227,27 @@ xfs_buf_alloc(
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
 	XB_SET_OWNER(bp);
 	bp->b_target = target;
+	bp->b_flags = flags;
 
 	/*
 	 * Set length and io_length to the same value initially.
 	 * I/O routines should use io_length, which will be the same in
 	 * most cases but may be reset (e.g. XFS recovery).
 	 */
-	bp->b_length = numblks;
-	bp->b_map.bm_len = numblks;
-	bp->b_io_length = numblks;
-	bp->b_flags = flags;
+	bp->b_bn = XFS_BUF_DADDR_NULL;
+	error = _xfs_buf_get_maps(bp, nmaps);
+	if (error)  {
+		kmem_zone_free(xfs_buf_zone, bp);
+		return NULL;
+	}
+
+	bp->b_length = 0;
+	for (i = 0; i < nmaps; i++) {
+		bp->b_maps[i].bm_bn = map[i].bm_bn;
+		bp->b_maps[i].bm_len = map[i].bm_len;
+		bp->b_length += map[i].bm_len;
+	}
+	bp->b_io_length = bp->b_length;
 
 	/*
 	 * We do not set the block number here in the buffer because we have not
@@ -209,8 +255,6 @@ xfs_buf_alloc(
 	 * in this state, so this ensures that we are unable to do IO on a
 	 * buffer that hasn't been fully initialised.
 	 */
-	bp->b_bn = XFS_BUF_DADDR_NULL;
-	bp->b_map.bm_bn = XFS_BUF_DADDR_NULL;
 	atomic_set(&bp->b_pin_count, 0);
 	init_waitqueue_head(&bp->b_waiters);
 
@@ -289,6 +333,7 @@ xfs_buf_free(
 	} else if (bp->b_flags & _XBF_KMEM)
 		kmem_free(bp->b_addr);
 	_xfs_buf_free_pages(bp);
+	_xfs_buf_free_maps(bp);
 	kmem_zone_free(xfs_buf_zone, bp);
 }
 
@@ -435,8 +480,8 @@ _xfs_buf_map_pages(
 xfs_buf_t *
 _xfs_buf_find(
 	struct xfs_buftarg	*btp,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
+	struct xfs_buf_map	*map,
+	int			nmaps,
 	xfs_buf_flags_t		flags,
 	xfs_buf_t		*new_bp)
 {
@@ -445,7 +490,13 @@ _xfs_buf_find(
 	struct rb_node		**rbp;
 	struct rb_node		*parent;
 	xfs_buf_t		*bp;
+	xfs_daddr_t		blkno = map[0].bm_bn;
+	int			numblks = 0;
+	int			i;
 
+	for (i = 0; i < nmaps; i++) {
+		numblks += map[i].bm_len;
+	}
 	numbytes = BBTOB(numblks);
 
 	/* Check for IOs smaller than the sector size / not sector aligned */
@@ -545,23 +596,27 @@ xfs_buf_get(
 {
 	struct xfs_buf		*bp;
 	struct xfs_buf		*new_bp;
+	struct xfs_buf_map	map = {
+		.bm_bn = blkno,
+		.bm_len = numblks,
+	};
 	int			error = 0;
 
-	bp = _xfs_buf_find(target, blkno, numblks, flags, NULL);
+	bp = _xfs_buf_find(target, &map, 1, flags, NULL);
 	if (likely(bp))
 		goto found;
 
-	new_bp = xfs_buf_alloc(target, blkno, numblks, flags);
+	new_bp = _xfs_buf_alloc(target, &map, 1, flags);
 	if (unlikely(!new_bp))
 		return NULL;
 
 	error = xfs_buf_allocate_memory(new_bp, flags);
 	if (error) {
-		kmem_zone_free(xfs_buf_zone, new_bp);
+		xfs_buf_free(new_bp);
 		return NULL;
 	}
 
-	bp = _xfs_buf_find(target, blkno, numblks, flags, new_bp);
+	bp = _xfs_buf_find(target, &map, 1, flags, new_bp);
 	if (!bp) {
 		xfs_buf_free(new_bp);
 		return NULL;
@@ -575,7 +630,6 @@ xfs_buf_get(
 	 * that we can do IO on it.
 	 */
 	bp->b_bn = blkno;
-	bp->b_map.bm_bn = blkno;
 
 found:
 	if (!bp->b_addr) {
@@ -680,7 +734,9 @@ xfs_buf_read_uncached(
 		return NULL;
 
 	/* set up the buffer for a read IO */
-	bp->b_map.bm_bn = daddr;
+	ASSERT(bp->b_map_count == 1);
+	bp->b_bn = daddr;
+	bp->b_maps[0].bm_bn = daddr;
 	bp->b_flags |= XBF_READ;
 
 	xfsbdstrat(target->bt_mount, bp);
@@ -709,9 +765,11 @@ xfs_buf_set_empty(
 	bp->b_addr = NULL;
 	bp->b_length = numblks;
 	bp->b_io_length = numblks;
+
+	ASSERT(bp->b_map_count == 1);
 	bp->b_bn = XFS_BUF_DADDR_NULL;
-	bp->b_map.bm_bn = XFS_BUF_DADDR_NULL;
-	bp->b_map.bm_len = bp->b_length;
+	bp->b_maps[0].bm_bn = XFS_BUF_DADDR_NULL;
+	bp->b_maps[0].bm_len = bp->b_length;
 }
 
 static inline struct page *
@@ -775,9 +833,13 @@ xfs_buf_get_uncached(
 {
 	unsigned long		page_count;
 	int			error, i;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
+	struct xfs_buf_map	map = {
+		.bm_len = numblks,
+	};
 
-	bp = xfs_buf_alloc(target, 0, numblks, 0);
+
+	bp = _xfs_buf_alloc(target, &map, 1, 0);
 	if (unlikely(bp == NULL))
 		goto fail;
 
@@ -808,6 +870,7 @@ xfs_buf_get_uncached(
 		__free_page(bp->b_pages[i]);
 	_xfs_buf_free_pages(bp);
  fail_free_buf:
+	_xfs_buf_free_maps(bp);
 	kmem_zone_free(xfs_buf_zone, bp);
  fail:
 	return NULL;
@@ -1168,36 +1231,39 @@ xfs_buf_bio_end_io(
 	bio_put(bio);
 }
 
-STATIC void
-_xfs_buf_ioapply(
-	xfs_buf_t		*bp)
+static void
+_xfs_buf_ioapply_map(
+	struct xfs_buf	*bp,
+	int		map,
+	int		*buf_offset,
+	int		*count,
+	int		rw)
 {
-	int			rw, map_i, total_nr_pages, nr_pages;
+	int			page_index;
+	int			total_nr_pages = bp->b_page_count;
+	int			nr_pages;
 	struct bio		*bio;
-	int			offset = bp->b_offset;
-	int			size = BBTOB(bp->b_io_length);
-	sector_t		sector = bp->b_map.bm_bn;
+	sector_t		sector =  bp->b_maps[map].bm_bn;
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
+	page_index = 0;
+	offset = *buf_offset;
+	while (offset >= PAGE_SIZE) {
+		page_index++;
+		offset -= PAGE_SIZE;
 	}
 
-	/* we only use the buffer cache for meta-data */
-	rw |= REQ_META;
+	/*
+	 * Limit the IO size to the length of the current vector, and update the
+	 * remaining IO count for the next time around.
+	 */
+	size = min_t(int, BBTOB(bp->b_maps[map].bm_len), *count);
+	*count -= size;
+	*buf_offset += size;
 
 next_chunk:
 	atomic_inc(&bp->b_io_remaining);
@@ -1212,13 +1278,14 @@ next_chunk:
 	bio->bi_private = bp;
 
 
-	for (; size && nr_pages; nr_pages--, map_i++) {
+	for (; size && nr_pages; nr_pages--, page_index++) {
 		int	rbytes, nbytes = PAGE_SIZE - offset;
 
 		if (nbytes > size)
 			nbytes = size;
 
-		rbytes = bio_add_page(bio, bp->b_pages[map_i], nbytes, offset);
+		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
+				      offset);
 		if (rbytes < nbytes)
 			break;
 
@@ -1240,6 +1307,54 @@ next_chunk:
 		xfs_buf_ioerror(bp, EIO);
 		bio_put(bio);
 	}
+
+}
+
+STATIC void
+_xfs_buf_ioapply(
+	struct xfs_buf	*bp)
+{
+	struct blk_plug	plug;
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
+	size = BBTOB(bp->b_io_length);
+	blk_start_plug(&plug);
+	for (i = 0; i < bp->b_map_count; i++) {
+		_xfs_buf_ioapply_map(bp, i, &offset, &size, rw);
+		if (bp->b_error)
+			break;
+		if (size <= 0)
+			break;	/* all done */
+	}
+	blk_finish_plug(&plug);
 }
 
 void
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index cc616969..3de9e80 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -134,7 +134,9 @@ typedef struct xfs_buf {
 	struct xfs_trans	*b_transp;
 	struct page		**b_pages;	/* array of page pointers */
 	struct page		*b_page_array[XB_PAGES]; /* inline pages */
-	struct xfs_buf_map	b_map;		/* compound buffer map */
+	struct xfs_buf_map	*b_maps;	/* compound buffer map */
+	struct xfs_buf_map	b_map;		/* inline compound buffer map */
+	int			b_map_count;
 	int			b_io_length;	/* IO size in BBs */
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
@@ -149,11 +151,41 @@ typedef struct xfs_buf {
 
 
 /* Finding and Reading Buffers */
-struct xfs_buf *_xfs_buf_find(struct xfs_buftarg *target, xfs_daddr_t blkno,
-				size_t numblks, xfs_buf_flags_t flags,
-				struct xfs_buf *new_bp);
-#define xfs_incore(buftarg,blkno,len,lockit) \
-	_xfs_buf_find(buftarg, blkno ,len, lockit, NULL)
+struct xfs_buf *_xfs_buf_find(struct xfs_buftarg *target,
+			      struct xfs_buf_map *map, int nmaps,
+			      xfs_buf_flags_t flags, struct xfs_buf *new_bp);
+
+static inline struct xfs_buf *
+xfs_incore(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	xfs_buf_flags_t		flags)
+{
+	struct xfs_buf_map	map = {
+		.bm_bn = blkno,
+		.bm_len = numblks,
+	};
+	return _xfs_buf_find(target, &map, 1, flags, NULL);
+}
+
+struct xfs_buf *_xfs_buf_alloc(struct xfs_buftarg *target,
+			       struct xfs_buf_map *map, int nmaps,
+			       xfs_buf_flags_t flags);
+
+static inline struct xfs_buf *
+xfs_buf_alloc(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	xfs_buf_flags_t		flags)
+{
+	struct xfs_buf_map	map = {
+		.bm_bn = blkno,
+		.bm_len = numblks,
+	};
+	return _xfs_buf_alloc(target, &map, 1, flags);
+}
 
 struct xfs_buf *xfs_buf_get(struct xfs_buftarg *target, xfs_daddr_t blkno,
 				size_t numblks, xfs_buf_flags_t flags);
@@ -163,8 +195,6 @@ void xfs_buf_readahead(struct xfs_buftarg *target, xfs_daddr_t blkno,
 				size_t numblks);
 
 struct xfs_buf *xfs_buf_get_empty(struct xfs_buftarg *target, size_t numblks);
-struct xfs_buf *xfs_buf_alloc(struct xfs_buftarg *target, xfs_daddr_t blkno,
-				size_t numblks, xfs_buf_flags_t flags);
 void xfs_buf_set_empty(struct xfs_buf *bp, size_t numblks);
 int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
 
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

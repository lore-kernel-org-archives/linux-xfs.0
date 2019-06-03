Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53674 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729954AbfFCRad (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:30:33 -0400
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXqn3-0003jj-32
        for linux-xfs@vger.kernel.org; Mon, 03 Jun 2019 17:30:33 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/20] xfs: remove unused buffer cache APIs
Date: Mon,  3 Jun 2019 19:29:43 +0200
Message-Id: <20190603172945.13819-19-hch@lst.de>
In-Reply-To: <20190603172945.13819-1-hch@lst.de>
References: <20190603172945.13819-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that the log code uses bios directly we can drop various special
cases in the buffer cache code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 83 ++----------------------------------------------
 fs/xfs/xfs_buf.h | 27 ----------------
 2 files changed, 2 insertions(+), 108 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ade6ec28e1c9..68444d20d2ed 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -213,7 +213,7 @@ xfs_buf_free_maps(
 	}
 }
 
-struct xfs_buf *
+static struct xfs_buf *
 _xfs_buf_alloc(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
@@ -909,72 +909,6 @@ xfs_buf_read_uncached(
 	return 0;
 }
 
-/*
- * Return a buffer allocated as an empty buffer and associated to external
- * memory via xfs_buf_associate_memory() back to it's empty state.
- */
-void
-xfs_buf_set_empty(
-	struct xfs_buf		*bp,
-	size_t			numblks)
-{
-	if (bp->b_pages)
-		_xfs_buf_free_pages(bp);
-
-	bp->b_pages = NULL;
-	bp->b_page_count = 0;
-	bp->b_addr = NULL;
-	bp->b_length = numblks;
-	bp->b_io_length = numblks;
-
-	ASSERT(bp->b_map_count == 1);
-	bp->b_bn = XFS_BUF_DADDR_NULL;
-	bp->b_maps[0].bm_bn = XFS_BUF_DADDR_NULL;
-	bp->b_maps[0].bm_len = bp->b_length;
-}
-
-int
-xfs_buf_associate_memory(
-	xfs_buf_t		*bp,
-	void			*mem,
-	size_t			len)
-{
-	int			rval;
-	int			i = 0;
-	unsigned long		pageaddr;
-	unsigned long		offset;
-	size_t			buflen;
-	int			page_count;
-
-	pageaddr = (unsigned long)mem & PAGE_MASK;
-	offset = (unsigned long)mem - pageaddr;
-	buflen = PAGE_ALIGN(len + offset);
-	page_count = buflen >> PAGE_SHIFT;
-
-	/* Free any previous set of page pointers */
-	if (bp->b_pages)
-		_xfs_buf_free_pages(bp);
-
-	bp->b_pages = NULL;
-	bp->b_addr = mem;
-
-	rval = _xfs_buf_get_pages(bp, page_count);
-	if (rval)
-		return rval;
-
-	bp->b_offset = offset;
-
-	for (i = 0; i < bp->b_page_count; i++) {
-		bp->b_pages[i] = kmem_to_page((void *)pageaddr);
-		pageaddr += PAGE_SIZE;
-	}
-
-	bp->b_io_length = BTOBB(len);
-	bp->b_length = BTOBB(buflen);
-
-	return 0;
-}
-
 xfs_buf_t *
 xfs_buf_get_uncached(
 	struct xfs_buftarg	*target,
@@ -1258,7 +1192,7 @@ xfs_buf_ioend_async(
 	struct xfs_buf	*bp)
 {
 	INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
-	queue_work(bp->b_ioend_wq, &bp->b_ioend_work);
+	queue_work(bp->b_target->bt_mount->m_buf_workqueue, &bp->b_ioend_work);
 }
 
 void
@@ -1425,21 +1359,8 @@ _xfs_buf_ioapply(
 	 */
 	bp->b_error = 0;
 
-	/*
-	 * Initialize the I/O completion workqueue if we haven't yet or the
-	 * submitter has not opted to specify a custom one.
-	 */
-	if (!bp->b_ioend_wq)
-		bp->b_ioend_wq = bp->b_target->bt_mount->m_buf_workqueue;
-
 	if (bp->b_flags & XBF_WRITE) {
 		op = REQ_OP_WRITE;
-		if (bp->b_flags & XBF_SYNCIO)
-			op_flags = REQ_SYNC;
-		if (bp->b_flags & XBF_FUA)
-			op_flags |= REQ_FUA;
-		if (bp->b_flags & XBF_FLUSH)
-			op_flags |= REQ_PREFLUSH;
 
 		/*
 		 * Run the write verifier callback function if it exists. If
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 15f6ce3974ac..c1965c7e76bb 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -36,11 +36,6 @@ typedef enum {
 #define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
 #define XBF_WRITE_FAIL	 (1 << 7) /* async writes have failed on this buffer */
 
-/* I/O hints for the BIO layer */
-#define XBF_SYNCIO	 (1 << 10)/* treat this buffer as synchronous I/O */
-#define XBF_FUA		 (1 << 11)/* force cache write through mode */
-#define XBF_FLUSH	 (1 << 12)/* flush the disk cache before a write */
-
 /* flags used only as arguments to access routines */
 #define XBF_TRYLOCK	 (1 << 16)/* lock requested, but do not wait */
 #define XBF_UNMAPPED	 (1 << 17)/* do not map the buffer */
@@ -61,9 +56,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
-	{ XBF_SYNCIO,		"SYNCIO" }, \
-	{ XBF_FUA,		"FUA" }, \
-	{ XBF_FLUSH,		"FLUSH" }, \
 	{ XBF_TRYLOCK,		"TRYLOCK" },	/* should never be set */\
 	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
@@ -162,7 +154,6 @@ typedef struct xfs_buf {
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
 	void			*b_addr;	/* virtual address of buffer */
 	struct work_struct	b_ioend_work;
-	struct workqueue_struct	*b_ioend_wq;	/* I/O completion wq */
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	void			*b_log_item;
@@ -207,21 +198,6 @@ struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
 			   xfs_daddr_t blkno, size_t numblks,
 			   xfs_buf_flags_t flags);
 
-struct xfs_buf *_xfs_buf_alloc(struct xfs_buftarg *target,
-			       struct xfs_buf_map *map, int nmaps,
-			       xfs_buf_flags_t flags);
-
-static inline struct xfs_buf *
-xfs_buf_alloc(
-	struct xfs_buftarg	*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
-	xfs_buf_flags_t		flags)
-{
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return _xfs_buf_alloc(target, &map, 1, flags);
-}
-
 struct xfs_buf *xfs_buf_get_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
 			       xfs_buf_flags_t flags);
@@ -267,9 +243,6 @@ xfs_buf_readahead(
 	return xfs_buf_readahead_map(target, &map, 1, ops);
 }
 
-void xfs_buf_set_empty(struct xfs_buf *bp, size_t numblks);
-int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
-
 struct xfs_buf *xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
 				int flags);
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
-- 
2.20.1

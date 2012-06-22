Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5M8oNBZ256985 for <xfs@oss.sgi.com>; Fri, 22 Jun 2012 03:50:23 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	kBdrsm6MKA25curk for <xfs@oss.sgi.com>;
	Fri, 22 Jun 2012 01:50:21 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1ShzZK-0005Ro-C0
	for xfs@oss.sgi.com; Fri, 22 Jun 2012 18:50:18 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1ShzZK-0006q9-8s
	for xfs@oss.sgi.com; Fri, 22 Jun 2012 18:50:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/9] xfs: separate buffer indexing from block map
Date: Fri, 22 Jun 2012 18:50:08 +1000
Message-Id: <1340355015-26250-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1340355015-26250-1-git-send-email-david@fromorbit.com>
References: <1340355015-26250-1-git-send-email-david@fromorbit.com>
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

To support discontiguous buffers in the buffer cache, we need to
separate the cache index variables from the I/O map. While this is
currently a 1:1 mapping, discontiguous buffer support will break
this relationship.

However, for caching purposes, we can still treat them the same as a
contiguous buffer - the block number of the first block and the
length of the buffer - as that is still a unique representation.
Also, the only way we will ever access the discontiguous regions of
buffers is via bulding the complete buffer in the first place, so
using the initial block number and entire buffer length is a sane
way to index the buffers.

Add a block mapping vector construct to the xfs_buf and use it in
the places where we are doing IO instead of the current
b_bn/b_length variables.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c |   21 ++++++++++++---------
 fs/xfs/xfs_buf.h |   27 +++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a4beb42..a843873 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -202,6 +202,8 @@ xfs_buf_alloc(
 	bp->b_io_length = numblks;
 	bp->b_flags = flags;
 	bp->b_bn = blkno;
+	bp->b_map.bm_bn = blkno;
+	bp->b_map.bm_len = numblks;
 	atomic_set(&bp->b_pin_count, 0);
 	init_waitqueue_head(&bp->b_waiters);
 
@@ -327,8 +329,9 @@ xfs_buf_allocate_memory(
 	}
 
 use_alloc_page:
-	start = BBTOB(bp->b_bn) >> PAGE_SHIFT;
-	end = (BBTOB(bp->b_bn + bp->b_length) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	start = BBTOB(bp->b_map.bm_bn) >> PAGE_SHIFT;
+	end = (BBTOB(bp->b_map.bm_bn + bp->b_length) + PAGE_SIZE - 1)
+								>> PAGE_SHIFT;
 	page_count = end - start;
 	error = _xfs_buf_get_pages(bp, page_count, flags);
 	if (unlikely(error))
@@ -560,8 +563,6 @@ xfs_buf_get(
 	if (bp != new_bp)
 		xfs_buf_free(new_bp);
 
-	bp->b_io_length = bp->b_length;
-
 found:
 	if (!bp->b_addr) {
 		error = _xfs_buf_map_pages(bp, flags);
@@ -584,7 +585,7 @@ _xfs_buf_read(
 	xfs_buf_flags_t		flags)
 {
 	ASSERT(!(flags & XBF_WRITE));
-	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
+	ASSERT(bp->b_map.bm_bn != XFS_BUF_DADDR_NULL);
 
 	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
@@ -665,8 +666,8 @@ xfs_buf_read_uncached(
 		return NULL;
 
 	/* set up the buffer for a read IO */
-	XFS_BUF_SET_ADDR(bp, daddr);
-	XFS_BUF_READ(bp);
+	bp->b_map.bm_bn = daddr;
+	bp->b_flags |= XBF_READ;
 
 	xfsbdstrat(target->bt_mount, bp);
 	error = xfs_buf_iowait(bp);
@@ -695,6 +696,8 @@ xfs_buf_set_empty(
 	bp->b_length = numblks;
 	bp->b_io_length = numblks;
 	bp->b_bn = XFS_BUF_DADDR_NULL;
+	bp->b_map.bm_bn = XFS_BUF_DADDR_NULL;
+	bp->b_map.bm_len = bp->b_length;
 }
 
 static inline struct page *
@@ -1159,7 +1162,7 @@ _xfs_buf_ioapply(
 	struct bio		*bio;
 	int			offset = bp->b_offset;
 	int			size = BBTOB(bp->b_io_length);
-	sector_t		sector = bp->b_bn;
+	sector_t		sector = bp->b_map.bm_bn;
 
 	total_nr_pages = bp->b_page_count;
 	map_i = 0;
@@ -1564,7 +1567,7 @@ xfs_buf_cmp(
 	struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
 	xfs_daddr_t		diff;
 
-	diff = ap->b_bn - bp->b_bn;
+	diff = ap->b_map.bm_bn - bp->b_map.bm_bn;
 	if (diff < 0)
 		return -1;
 	if (diff > 0)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 7f1d139..c9c2ba9 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -58,6 +58,7 @@ typedef enum {
 #define _XBF_PAGES	(1 << 20)/* backed by refcounted pages */
 #define _XBF_KMEM	(1 << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	(1 << 22)/* buffer on a delwri queue */
+#define _XBF_COMPOUND	(1 << 23)/* compound buffer */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -75,7 +76,8 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
-	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
+	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
+	{ _XBF_COMPOUND,	"COMPOUND" }
 
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
@@ -98,6 +100,11 @@ typedef void (*xfs_buf_iodone_t)(struct xfs_buf *);
 
 #define XB_PAGES	2
 
+struct xfs_buf_map {
+	xfs_daddr_t		bm_bn;	/* block number for I/O */
+	int			bm_len;	/* size of I/O */
+};
+
 typedef struct xfs_buf {
 	/*
 	 * first cacheline holds all the fields needed for an uncontended cache
@@ -107,7 +114,7 @@ typedef struct xfs_buf {
 	 * fast-path on locking.
 	 */
 	struct rb_node		b_rbnode;	/* rbtree node */
-	xfs_daddr_t		b_bn;		/* block number for I/O */
+	xfs_daddr_t		b_bn;		/* block number of buffer */
 	int			b_length;	/* size of buffer in BBs */
 	atomic_t		b_hold;		/* reference count */
 	atomic_t		b_lru_ref;	/* lru reclaim ref count */
@@ -127,12 +134,14 @@ typedef struct xfs_buf {
 	struct xfs_trans	*b_transp;
 	struct page		**b_pages;	/* array of page pointers */
 	struct page		*b_page_array[XB_PAGES]; /* inline pages */
+	struct xfs_buf_map	b_map;		/* compound buffer map */
 	int			b_io_length;	/* IO size in BBs */
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	unsigned int		b_page_count;	/* size of page array */
 	unsigned int		b_offset;	/* page offset in first page */
 	unsigned short		b_error;	/* error code on I/O */
+
 #ifdef XFS_BUF_LOCK_TRACKING
 	int			b_last_holder;
 #endif
@@ -233,8 +242,18 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
 #define XFS_BUF_ISWRITE(bp)	((bp)->b_flags & XBF_WRITE)
 
-#define XFS_BUF_ADDR(bp)		((bp)->b_bn)
-#define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_bn = (xfs_daddr_t)(bno))
+/*
+ * These macros use the IO block map rather than b_bn. b_bn is now really
+ * just for the buffer cache index for cached buffers. As IO does not use b_bn
+ * anymore, uncached buffers do not use b_bn at all and hence must modify the IO
+ * map directly. Uncached buffers are not allowed to be discontiguous, so this
+ * is safe to do.
+ *
+ * In future, uncached buffers will pass the block number directly to the io
+ * request function and hence these macros will go away at that point.
+ */
+#define XFS_BUF_ADDR(bp)		((bp)->b_map.bm_bn)
+#define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_map.bm_bn = (xfs_daddr_t)(bno))
 
 static inline void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 {
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

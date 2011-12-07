Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB76Ix0h046625 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 00:18:59 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 414392A1EAD
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 22:18:51 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TDHQN8PQdppcQCRq for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 22:18:51 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RYAq4-0003nu-PK
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:44 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RYApz-0003Ub-Ap
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/12] xfs: introduce a compound buffer construct
Date: Wed,  7 Dec 2011 17:18:14 +1100
Message-Id: <1323238703-13198-4-git-send-email-david@fromorbit.com>
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

The first step to replacing the dabuf infrastructure is to introduce
a buffer construct that can support multiple block ranges in a
single mapping.

Directory buffers back be made up of multiple extents, but are
currently formed by creating individual buffers and them copying the
data out of them into a dabuf structure. All dabuf operations then
require walking all the underlying buffers to change the state of
the underlying buffers, and once a dabuf is modified the contents
need to be copied back to the underlying buffers before they are
logged.

All of these operations can be done on a normal xfs_buf, but the
normal xfs_buf does not support multiple disk block ranges or doing
multiple disjoint I/Os to read or write a buffer. Supporting
multiple disk block ranges is not difficult - we simply need to
attach an iovec-like array to the buffer rather than just using a
single block number and length.

Splitting the buffer up into multiple IOs for read and write is not
difficult, either. We already track the number of IO remaining to
complete an IO, so this can be used to wait for the multiple IO
dispatched to complete (for both read and write).

The only interesting twist to this is logging the changes. We can
treat the compound buffer as a single buffer for most purposes
except for formatting the changes into the log. When formatting, we
need to split the changes into a format item per underlying region
so that recovery does not need to know about compound buffers and
can recover each segment of a directory block indivdually as it does
now. The fact that recovery will replay all or none of the
transaction nesures this process is still atomic from a change
recovery point of view.

This new sort of buffer will be known as a "compound buffer", and
will be tagged with a flag to indicate it is such. Compound buffers
will be indexed and cached by the block number of their initial
segment and the length of the entire buffer.

Introduce the compound buffer flags and the block vector
infrastructure needed to replace the existing block number indexing.
Further patches will introduce the real compound buffer
functionality.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c   |   19 +++++++++++++------
 fs/xfs/xfs_buf.h   |   17 ++++++++++++++---
 fs/xfs/xfs_trace.h |    8 ++++----
 3 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 44cf63c..152e855 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -201,7 +201,12 @@ xfs_buf_alloc(
 	bp->b_flags = flags;
 
 	/* XXX: we have the block number. Why don't we just set it here? */
-	bp->b_bn = XFS_BUF_DADDR_NULL;
+	/* initialise the buffer IO vector array appropriately */
+	bp->b_vec_count = 1;
+	bp->b_vec = &bp->b_vec_array[0];
+	bp->b_vec[0].bv_bn = XFS_BUF_DADDR_NULL;
+	bp->b_vec[0].bv_len = bp->b_buffer_length;
+
 	atomic_set(&bp->b_pin_count, 0);
 	init_waitqueue_head(&bp->b_waiters);
 
@@ -564,7 +569,8 @@ xfs_buf_get(
 	 * Now we have a workable buffer, fill in the block number so
 	 * that we can do IO on it.
 	 */
-	bp->b_bn = blkno;
+	bp->b_vec[0].bv_bn = blkno;
+	bp->b_vec[0].bv_len = bp->b_buffer_length;
 	bp->b_count_desired = bp->b_buffer_length;
 
 found:
@@ -596,7 +602,7 @@ _xfs_buf_read(
 	int			status;
 
 	ASSERT(!(flags & (XBF_DELWRI|XBF_WRITE)));
-	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
+	ASSERT(bp->b_vec[0].bv_bn != XFS_BUF_DADDR_NULL);
 
 	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_DELWRI | XBF_READ_AHEAD);
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
@@ -711,7 +717,8 @@ xfs_buf_set_empty(
 	bp->b_addr = NULL;
 	bp->b_file_offset = 0;
 	bp->b_buffer_length = bp->b_count_desired = numblks << BBSHIFT;
-	bp->b_bn = XFS_BUF_DADDR_NULL;
+	bp->b_vec[0].bv_bn = XFS_BUF_DADDR_NULL;
+	bp->b_vec[0].bv_len = bp->b_buffer_length;
 	bp->b_flags &= ~XBF_MAPPED;
 }
 
@@ -1185,7 +1192,7 @@ _xfs_buf_ioapply(
 	struct bio		*bio;
 	int			offset = bp->b_offset;
 	int			size = bp->b_count_desired;
-	sector_t		sector = bp->b_bn;
+	sector_t		sector = bp->b_vec[0].bv_bn;
 
 	total_nr_pages = bp->b_page_count;
 	map_i = 0;
@@ -1678,7 +1685,7 @@ xfs_buf_cmp(
 	struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
 	xfs_daddr_t		diff;
 
-	diff = ap->b_bn - bp->b_bn;
+	diff = ap->b_vec[0].bv_bn - bp->b_vec[0].bv_bn;
 	if (diff < 0)
 		return -1;
 	if (diff > 0)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index a1c078d..1a3367e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -67,6 +67,7 @@ typedef enum {
 #define _XBF_PAGES	(1 << 20)/* backed by refcounted pages */
 #define _XBF_KMEM	(1 << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	(1 << 22)/* buffer on delwri queue */
+#define _XBF_COMPOUND	(1 << 23)/* compound buffer */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -121,6 +122,12 @@ typedef void (*xfs_buf_iodone_t)(struct xfs_buf *);
 
 #define XB_PAGES	2
 
+struct xfs_buf_vec {
+	xfs_daddr_t		bv_bn;	/* block number for I/O */
+	size_t			bv_len;	/* size of I/O */
+};
+#define XB_VECS		2
+
 typedef struct xfs_buf {
 	/*
 	 * first cacheline holds all the fields needed for an uncontended cache
@@ -142,7 +149,6 @@ typedef struct xfs_buf {
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
-	xfs_daddr_t		b_bn;		/* block number for I/O */
 	size_t			b_count_desired;/* desired transfer size */
 	void			*b_addr;	/* virtual address of buffer */
 	struct work_struct	b_iodone_work;
@@ -158,6 +164,11 @@ typedef struct xfs_buf {
 	unsigned int		b_page_count;	/* size of page array */
 	unsigned int		b_offset;	/* page offset in first page */
 	unsigned short		b_error;	/* error code on I/O */
+
+	struct xfs_buf_vec	*b_vec;		/* compound buffer vector */
+	struct xfs_buf_vec	b_vec_array[XB_VECS]; /* inline vectors */
+	int			b_vec_count;	/* size of vector array */
+
 #ifdef XFS_BUF_LOCK_TRACKING
 	int			b_last_holder;
 #endif
@@ -260,8 +271,8 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
 #define XFS_BUF_ISWRITE(bp)	((bp)->b_flags & XBF_WRITE)
 
-#define XFS_BUF_ADDR(bp)		((bp)->b_bn)
-#define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_bn = (xfs_daddr_t)(bno))
+#define XFS_BUF_ADDR(bp)		((bp)->b_vec[0].bv_bn)
+#define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_vec[0].bv_bn = (xfs_daddr_t)(bno))
 #define XFS_BUF_OFFSET(bp)		((bp)->b_file_offset)
 #define XFS_BUF_SET_OFFSET(bp, off)	((bp)->b_file_offset = (off))
 #define XFS_BUF_COUNT(bp)		((bp)->b_count_desired)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f1d2802..40d1f9c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -290,7 +290,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 	),
 	TP_fast_assign(
 		__entry->dev = bp->b_target->bt_dev;
-		__entry->bno = bp->b_bn;
+		__entry->bno = bp->b_vec[0].bv_bn;
 		__entry->buffer_length = bp->b_buffer_length;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
@@ -361,7 +361,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 	),
 	TP_fast_assign(
 		__entry->dev = bp->b_target->bt_dev;
-		__entry->bno = bp->b_bn;
+		__entry->bno = bp->b_vec[0].bv_bn;
 		__entry->buffer_length = bp->b_buffer_length;
 		__entry->flags = flags;
 		__entry->hold = atomic_read(&bp->b_hold);
@@ -405,7 +405,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 	),
 	TP_fast_assign(
 		__entry->dev = bp->b_target->bt_dev;
-		__entry->bno = bp->b_bn;
+		__entry->bno = bp->b_vec[0].bv_bn;
 		__entry->buffer_length = bp->b_buffer_length;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
@@ -449,7 +449,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 		__entry->bli_flags = bip->bli_flags;
 		__entry->bli_recur = bip->bli_recur;
 		__entry->bli_refcount = atomic_read(&bip->bli_refcount);
-		__entry->buf_bno = bip->bli_buf->b_bn;
+		__entry->buf_bno = bip->bli_buf->b_vec[0].bv_bn;
 		__entry->buf_len = bip->bli_buf->b_buffer_length;
 		__entry->buf_flags = bip->bli_buf->b_flags;
 		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

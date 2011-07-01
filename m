Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k9VA056155 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47DAA4669F
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:08 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	PGPrGktyynwMepfw for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:08 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIZ-00022z-Ie
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:07 +0000
Message-Id: <20110701094607.536262104@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 26/27] xfs: cleanup I/O-related buffer flags
References: <20110701094321.936534538@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-buf-cleanup-flags
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

Remove the unused and misnamed _XBF_RUN_QUEUES flag, rename XBF_LOG_BUFFER
to the more fitting XBF_SYNCIO, and split XBF_ORDERED into XBF_FUA and
XBF_FLUSH to allow more fine grained control over the bio flags.  Also
cleanup processing of the flags in _xfs_buf_ioapply to make more sense,
and renumber the sparse flag number space to group flags by purpose.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-06-29 14:04:28.084452749 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2011-06-29 14:27:00.987123445 +0200
@@ -592,10 +592,8 @@ _xfs_buf_read(
 	ASSERT(!(flags & (XBF_DELWRI|XBF_WRITE)));
 	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
 
-	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_DELWRI | \
-			XBF_READ_AHEAD | _XBF_RUN_QUEUES);
-	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | \
-			XBF_READ_AHEAD | _XBF_RUN_QUEUES);
+	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_DELWRI | XBF_READ_AHEAD);
+	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
 
 	status = xfs_buf_iorequest(bp);
 	if (status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC))
@@ -1211,23 +1209,21 @@ _xfs_buf_ioapply(
 	total_nr_pages = bp->b_page_count;
 	map_i = 0;
 
-	if (bp->b_flags & XBF_ORDERED) {
-		ASSERT(!(bp->b_flags & XBF_READ));
-		rw = WRITE_FLUSH_FUA;
-	} else if (bp->b_flags & XBF_LOG_BUFFER) {
-		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
-		bp->b_flags &= ~_XBF_RUN_QUEUES;
-		rw = (bp->b_flags & XBF_WRITE) ? WRITE_SYNC : READ_SYNC;
-	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
-		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
-		bp->b_flags &= ~_XBF_RUN_QUEUES;
-		rw = (bp->b_flags & XBF_WRITE) ? WRITE_META : READ_META;
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
 	} else {
-		rw = (bp->b_flags & XBF_WRITE) ? WRITE :
-		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
+		rw = READ;
 	}
 
-
 next_chunk:
 	atomic_inc(&bp->b_io_remaining);
 	nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);
@@ -1689,8 +1685,7 @@ xfs_buf_delwri_split(
 				break;
 			}
 
-			bp->b_flags &= ~(XBF_DELWRI|_XBF_DELWRI_Q|
-					 _XBF_RUN_QUEUES);
+			bp->b_flags &= ~(XBF_DELWRI | _XBF_DELWRI_Q);
 			bp->b_flags |= XBF_WRITE;
 			list_move_tail(&bp->b_list, list);
 			trace_xfs_buf_delwri_split(bp, _RET_IP_);
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2011-06-29 14:03:57.994615760 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2011-06-29 14:18:16.806629842 +0200
@@ -46,43 +46,46 @@ typedef enum {
 
 #define XBF_READ	(1 << 0) /* buffer intended for reading from device */
 #define XBF_WRITE	(1 << 1) /* buffer intended for writing to device */
-#define XBF_MAPPED	(1 << 2) /* buffer mapped (b_addr valid) */
+#define XBF_READ_AHEAD	(1 << 2) /* asynchronous read-ahead */
+#define XBF_MAPPED	(1 << 3) /* buffer mapped (b_addr valid) */
 #define XBF_ASYNC	(1 << 4) /* initiator will not wait for completion */
 #define XBF_DONE	(1 << 5) /* all pages in the buffer uptodate */
 #define XBF_DELWRI	(1 << 6) /* buffer has dirty pages */
 #define XBF_STALE	(1 << 7) /* buffer has been staled, do not find it */
-#define XBF_ORDERED	(1 << 11)/* use ordered writes */
-#define XBF_READ_AHEAD	(1 << 12)/* asynchronous read-ahead */
-#define XBF_LOG_BUFFER	(1 << 13)/* this is a buffer used for the log */
+
+/* I/O hints for the BIO layer */
+#define XBF_SYNCIO	(1 << 10)/* treat this buffer as synchronous I/O */
+#define XBF_FUA		(1 << 11)/* force cache write through mode */
+#define XBF_FLUSH	(1 << 12)/* flush the disk cache before a write */
 
 /* flags used only as arguments to access routines */
-#define XBF_LOCK	(1 << 14)/* lock requested */
-#define XBF_TRYLOCK	(1 << 15)/* lock requested, but do not wait */
-#define XBF_DONT_BLOCK	(1 << 16)/* do not block in current thread */
+#define XBF_LOCK	(1 << 15)/* lock requested */
+#define XBF_TRYLOCK	(1 << 16)/* lock requested, but do not wait */
+#define XBF_DONT_BLOCK	(1 << 17)/* do not block in current thread */
 
 /* flags used only internally */
-#define _XBF_PAGES	(1 << 18)/* backed by refcounted pages */
-#define	_XBF_RUN_QUEUES	(1 << 19)/* run block device task queue	*/
-#define	_XBF_KMEM	(1 << 20)/* backed by heap memory */
-#define _XBF_DELWRI_Q	(1 << 21)/* buffer on delwri queue */
+#define _XBF_PAGES	(1 << 20)/* backed by refcounted pages */
+#define	_XBF_KMEM	(1 << 21)/* backed by heap memory */
+#define _XBF_DELWRI_Q	(1 << 22)/* buffer on delwri queue */
 
 typedef unsigned int xfs_buf_flags_t;
 
 #define XFS_BUF_FLAGS \
 	{ XBF_READ,		"READ" }, \
 	{ XBF_WRITE,		"WRITE" }, \
+	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
 	{ XBF_MAPPED,		"MAPPED" }, \
 	{ XBF_ASYNC,		"ASYNC" }, \
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_DELWRI,		"DELWRI" }, \
 	{ XBF_STALE,		"STALE" }, \
-	{ XBF_ORDERED,		"ORDERED" }, \
-	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
+	{ XBF_SYNCIO,		"SYNCIO" }, \
+	{ XBF_FUA,		"FUA" }, \
+	{ XBF_FLUSH,		"FLUSH" }, \
 	{ XBF_LOCK,		"LOCK" },  	/* should never be set */\
 	{ XBF_TRYLOCK,		"TRYLOCK" }, 	/* ditto */\
 	{ XBF_DONT_BLOCK,	"DONT_BLOCK" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
-	{ _XBF_RUN_QUEUES,	"RUN_QUEUES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
 
@@ -230,8 +233,9 @@ extern void xfs_buf_terminate(void);
 
 
 #define XFS_BUF_BFLAGS(bp)	((bp)->b_flags)
-#define XFS_BUF_ZEROFLAGS(bp)	((bp)->b_flags &= \
-		~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED))
+#define XFS_BUF_ZEROFLAGS(bp) \
+	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI| \
+			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH))
 
 void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_STALE(bp)	xfs_buf_stale(bp);
@@ -263,10 +267,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNASYNC(bp)	((bp)->b_flags &= ~XBF_ASYNC)
 #define XFS_BUF_ISASYNC(bp)	((bp)->b_flags & XBF_ASYNC)
 
-#define XFS_BUF_ORDERED(bp)	((bp)->b_flags |= XBF_ORDERED)
-#define XFS_BUF_UNORDERED(bp)	((bp)->b_flags &= ~XBF_ORDERED)
-#define XFS_BUF_ISORDERED(bp)	((bp)->b_flags & XBF_ORDERED)
-
 #define XFS_BUF_HOLD(bp)	xfs_buf_hold(bp)
 #define XFS_BUF_READ(bp)	((bp)->b_flags |= XBF_READ)
 #define XFS_BUF_UNREAD(bp)	((bp)->b_flags &= ~XBF_READ)
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-06-29 14:04:18.587837528 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-06-29 19:45:20.176987585 +0200
@@ -1268,7 +1268,6 @@ xlog_bdstrat(
 		return 0;
 	}
 
-	bp->b_flags |= _XBF_RUN_QUEUES;
 	xfs_buf_iorequest(bp);
 	return 0;
 }
@@ -1369,7 +1368,7 @@ xlog_sync(xlog_t		*log,
 	XFS_BUF_ZEROFLAGS(bp);
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
-	bp->b_flags |= XBF_LOG_BUFFER;
+	bp->b_flags |= XBF_SYNCIO;
 
 	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
 		/*
@@ -1380,7 +1379,7 @@ xlog_sync(xlog_t		*log,
 		 */
 		if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
 			xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
-		XFS_BUF_ORDERED(bp);
+		bp->b_flags |= XBF_FUA | XBF_FLUSH;
 	}
 
 	ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
@@ -1413,9 +1412,9 @@ xlog_sync(xlog_t		*log,
 		XFS_BUF_ZEROFLAGS(bp);
 		XFS_BUF_BUSY(bp);
 		XFS_BUF_ASYNC(bp);
-		bp->b_flags |= XBF_LOG_BUFFER;
+		bp->b_flags |= XBF_SYNCIO;
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
-			XFS_BUF_ORDERED(bp);
+			bp->b_flags |= XBF_FUA | XBF_FLUSH;
 		dptr = XFS_BUF_PTR(bp);
 		/*
 		 * Bump the cycle numbers at the start of each block

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6D6OC5x122409 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 01:24:12 -0500
Date: Fri, 13 Jul 2012 02:24:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2 v2] xfs: do not call xfs_bdstrat_cb in
	xfs_buf_iodone_callbacks
Message-ID: <20120713062410.GA24788@infradead.org>
References: <20120702100003.960640484@bombadil.infradead.org>
	<20120702100034.921366796@bombadil.infradead.org>
	<20120712230421.GE29979@sgi.com>
	<20120713061651.GA20909@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120713061651.GA20909@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

xfs_bdstrat_cb only adds a check for a shutdown filesystem over
xfs_buf_iorequest, but xfs_buf_iodone_callbacks just checked for a shut down
filesystem a little earlier.  In addition the shutdown handling in
xfs_bdstrat_cb is not very suitable for this caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_buf.c      |   51 +++++++++++++++++++++-----------------------------
 fs/xfs/xfs_buf.h      |    1 
 fs/xfs/xfs_buf_item.c |    2 -
 3 files changed, 23 insertions(+), 31 deletions(-)

Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2012-07-13 08:11:17.019997085 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2012-07-13 08:11:19.699997069 +0200
@@ -1101,7 +1101,7 @@ xfs_buf_iodone_callbacks(
 
 		if (!XFS_BUF_ISSTALE(bp)) {
 			bp->b_flags |= XBF_WRITE | XBF_ASYNC | XBF_DONE;
-			xfs_bdstrat_cb(bp);
+			xfs_buf_iorequest(bp);
 		} else {
 			xfs_buf_relse(bp);
 		}
Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2012-07-13 08:11:19.346663738 +0200
+++ xfs/fs/xfs/xfs_buf.c	2012-07-13 08:11:19.699997069 +0200
@@ -1049,27 +1049,6 @@ xfs_buf_ioerror_alert(
 		(__uint64_t)XFS_BUF_ADDR(bp), func, bp->b_error, bp->b_length);
 }
 
-int
-xfs_bwrite(
-	struct xfs_buf		*bp)
-{
-	int			error;
-
-	ASSERT(xfs_buf_islocked(bp));
-
-	bp->b_flags |= XBF_WRITE;
-	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q);
-
-	xfs_bdstrat_cb(bp);
-
-	error = xfs_buf_iowait(bp);
-	if (error) {
-		xfs_force_shutdown(bp->b_target->bt_mount,
-				   SHUTDOWN_META_IO_ERROR);
-	}
-	return error;
-}
-
 /*
  * Called when we want to stop a buffer from getting written or read.
  * We attach the EIO error, muck with its flags, and call xfs_buf_ioend
@@ -1139,14 +1118,7 @@ xfs_bioerror_relse(
 	return EIO;
 }
 
-
-/*
- * All xfs metadata buffers except log state machine buffers
- * get this attached as their b_bdstrat callback function.
- * This is so that we can catch a buffer
- * after prematurely unpinning it to forcibly shutdown the filesystem.
- */
-int
+STATIC int
 xfs_bdstrat_cb(
 	struct xfs_buf	*bp)
 {
@@ -1167,6 +1139,27 @@ xfs_bdstrat_cb(
 	return 0;
 }
 
+int
+xfs_bwrite(
+	struct xfs_buf		*bp)
+{
+	int			error;
+
+	ASSERT(xfs_buf_islocked(bp));
+
+	bp->b_flags |= XBF_WRITE;
+	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q);
+
+	xfs_bdstrat_cb(bp);
+
+	error = xfs_buf_iowait(bp);
+	if (error) {
+		xfs_force_shutdown(bp->b_target->bt_mount,
+				   SHUTDOWN_META_IO_ERROR);
+	}
+	return error;
+}
+
 /*
  * Wrapper around bdstrat so that we can stop data from going to disk in case
  * we are shutting down the filesystem.  Typically user data goes thru this
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2012-07-02 12:11:56.429113153 +0200
+++ xfs/fs/xfs/xfs_buf.h	2012-07-13 08:11:36.246663636 +0200
@@ -250,7 +250,6 @@ extern void xfs_buf_unlock(xfs_buf_t *);
 extern int xfs_bwrite(struct xfs_buf *bp);
 
 extern void xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
-extern int xfs_bdstrat_cb(struct xfs_buf *);
 
 extern void xfs_buf_ioend(xfs_buf_t *,	int);
 extern void xfs_buf_ioerror(xfs_buf_t *, int);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

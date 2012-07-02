Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q62A0bFc201585 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 05:00:39 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2WmGPqm3mKleocQ7 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jul 2012 03:00:35 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SldQp-0005a7-0Z
	for xfs@oss.sgi.com; Mon, 02 Jul 2012 10:00:35 +0000
Message-Id: <20120702100034.921366796@bombadil.infradead.org>
Date: Mon, 02 Jul 2012 06:00:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: do not call xfs_bdstrat_cb in
	xfs_buf_iodone_callbacks
References: <20120702100003.960640484@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_bdstrat_cb-1
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

xfs_bdstrat_cb only adds a check for a shutdown filesystem over xfs_buf_iorequest,
but xfs_buf_iodone_callbacks just checked for a shut down filesystem a little
earlier.  In addition the shutdown handling in xfs_bdstrat_cb is not very suitable
for this caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_buf.c      |   51 +++++++++++++++++++++-----------------------------
 fs/xfs/xfs_buf_item.c |    2 -
 2 files changed, 23 insertions(+), 30 deletions(-)

Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2012-06-26 23:20:22.326407387 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2012-06-26 23:20:28.766407349 +0200
@@ -954,7 +954,7 @@ xfs_buf_iodone_callbacks(
 
 		if (!XFS_BUF_ISSTALE(bp)) {
 			bp->b_flags |= XBF_WRITE | XBF_ASYNC | XBF_DONE;
-			xfs_bdstrat_cb(bp);
+			xfs_buf_iorequest(bp);
 		} else {
 			xfs_buf_relse(bp);
 		}
Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2012-06-26 23:20:23.686407379 +0200
+++ xfs/fs/xfs/xfs_buf.c	2012-06-26 23:21:40.286406924 +0200
@@ -989,27 +989,6 @@ xfs_buf_ioerror_alert(
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
@@ -1079,14 +1058,7 @@ xfs_bioerror_relse(
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
@@ -1107,6 +1079,27 @@ xfs_bdstrat_cb(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CD3D67F4E
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 01:39:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BBF098F8084
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 23:39:17 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	CDIZXBM9OhjnkpDe for <xfs@oss.sgi.com>;
	Thu, 14 Aug 2014 23:39:15 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XIBAL-0001ZQ-A3
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XIBAL-0001UJ-9C
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/9] xfs: xfs_buf_ioend and xfs_buf_iodone_work duplicate
	functionality
Date: Fri, 15 Aug 2014 16:39:00 +1000
Message-Id: <1408084747-4540-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1408084747-4540-1-git-send-email-david@fromorbit.com>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
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

We do some work in xfs_buf_ioend, and some work in
xfs_buf_iodone_work, but much of that functionality is the same.
This work can all be done in a single function, leaving
xfs_buf_iodone just a wrapper to determine if we should execute it
by workqueue or directly. hence rename xfs_buf_iodone_work to
xfs_buf_ioend(), and add a new xfs_buf_ioend_async() for places that
need async processing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c         | 79 +++++++++++++++++++++---------------------------
 fs/xfs/xfs_buf.h         |  2 +-
 fs/xfs/xfs_buf_item.c    |  4 +--
 fs/xfs/xfs_inode.c       |  2 +-
 fs/xfs/xfs_log.c         |  2 +-
 fs/xfs/xfs_log_recover.c |  2 +-
 6 files changed, 40 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 5d86bbd..1b7f0bc 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -999,54 +999,49 @@ xfs_buf_wait_unpin(
  */
 
 STATIC void
-xfs_buf_iodone_work(
-	struct work_struct	*work)
+xfs_buf_ioend(
+	struct xfs_buf	*bp)
 {
-	struct xfs_buf		*bp =
-		container_of(work, xfs_buf_t, b_iodone_work);
-	bool			read = !!(bp->b_flags & XBF_READ);
+	bool		read = !!(bp->b_flags & XBF_READ);
+
+	trace_xfs_buf_iodone(bp, _RET_IP_);
 
 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
 
-	/* only validate buffers that were read without errors */
-	if (read && bp->b_ops && !bp->b_error && (bp->b_flags & XBF_DONE))
-		bp->b_ops->verify_read(bp);
+	if (!bp->b_error) {
+		bp->b_flags |= XBF_DONE;
+
+		/* only validate buffers that were read without errors */
+		if (read && bp->b_ops)
+			bp->b_ops->verify_read(bp);
+	}
 
 	if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
 	else if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_relse(bp);
 	else {
-		ASSERT(read && bp->b_ops);
 		complete(&bp->b_iowait);
 		xfs_buf_rele(bp);
 	}
 }
 
-void
-xfs_buf_ioend(
-	struct xfs_buf	*bp,
-	int		schedule)
+static void
+xfs_buf_ioend_work(
+	struct work_struct	*work)
 {
-	bool		read = !!(bp->b_flags & XBF_READ);
-
-	trace_xfs_buf_iodone(bp, _RET_IP_);
+	struct xfs_buf		*bp =
+		container_of(work, xfs_buf_t, b_iodone_work);
 
-	if (bp->b_error == 0)
-		bp->b_flags |= XBF_DONE;
+	xfs_buf_ioend(bp);
+}
 
-	if (bp->b_iodone || (read && bp->b_ops) || (bp->b_flags & XBF_ASYNC)) {
-		if (schedule) {
-			INIT_WORK(&bp->b_iodone_work, xfs_buf_iodone_work);
-			queue_work(xfslogd_workqueue, &bp->b_iodone_work);
-		} else {
-			xfs_buf_iodone_work(&bp->b_iodone_work);
-		}
-	} else {
-		bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
-		complete(&bp->b_iowait);
-		xfs_buf_rele(bp);
-	}
+void
+xfs_buf_ioend_async(
+	struct xfs_buf	*bp)
+{
+	INIT_WORK(&bp->b_iodone_work, xfs_buf_ioend_work);
+	queue_work(xfslogd_workqueue, &bp->b_iodone_work);
 }
 
 void
@@ -1094,7 +1089,7 @@ xfs_bioerror(
 	XFS_BUF_UNDONE(bp);
 	xfs_buf_stale(bp);
 
-	xfs_buf_ioend(bp, 0);
+	xfs_buf_ioend(bp);
 
 	return -EIO;
 }
@@ -1181,15 +1176,6 @@ xfs_bwrite(
 }
 
 STATIC void
-_xfs_buf_ioend(
-	xfs_buf_t		*bp,
-	int			schedule)
-{
-	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
-		xfs_buf_ioend(bp, schedule);
-}
-
-STATIC void
 xfs_buf_bio_end_io(
 	struct bio		*bio,
 	int			error)
@@ -1206,7 +1192,8 @@ xfs_buf_bio_end_io(
 	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
 
-	_xfs_buf_ioend(bp, 1);
+	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
+		xfs_buf_ioend_async(bp);
 	bio_put(bio);
 }
 
@@ -1425,10 +1412,12 @@ xfs_buf_iorequest(
 	 * waiting, and in the synchronous IO case it avoids unnecessary context
 	 * switches an latency for high-peformance devices.
 	 */
-	if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
-		_xfs_buf_ioend(bp, 0);
-	else
-		_xfs_buf_ioend(bp, 1);
+	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
+		if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
+			xfs_buf_ioend(bp);
+		else
+			xfs_buf_ioend_async(bp);
+	}
 
 	xfs_buf_rele(bp);
 }
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index c753183..4585c15 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -286,7 +286,7 @@ extern void xfs_buf_unlock(xfs_buf_t *);
 
 /* Buffer Read and Write Routines */
 extern int xfs_bwrite(struct xfs_buf *bp);
-extern void xfs_buf_ioend(xfs_buf_t *,	int);
+extern void xfs_buf_ioend(struct xfs_buf *bp);
 extern void xfs_buf_ioerror(xfs_buf_t *, int);
 extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
 extern void xfs_buf_iorequest(xfs_buf_t *);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 76007de..4fd41b5 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -491,7 +491,7 @@ xfs_buf_item_unpin(
 		xfs_buf_ioerror(bp, -EIO);
 		XFS_BUF_UNDONE(bp);
 		xfs_buf_stale(bp);
-		xfs_buf_ioend(bp, 0);
+		xfs_buf_ioend(bp);
 	}
 }
 
@@ -1115,7 +1115,7 @@ do_callbacks:
 	xfs_buf_do_callbacks(bp);
 	bp->b_fspriv = NULL;
 	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
+	xfs_buf_ioend(bp);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fea3c92..00d210b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3056,7 +3056,7 @@ cluster_corrupt_out:
 			XFS_BUF_UNDONE(bp);
 			xfs_buf_stale(bp);
 			xfs_buf_ioerror(bp, -EIO);
-			xfs_buf_ioend(bp, 0);
+			xfs_buf_ioend(bp);
 		} else {
 			xfs_buf_stale(bp);
 			xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8eaa8f5..e4665db 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1689,7 +1689,7 @@ xlog_bdstrat(
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		xfs_buf_ioerror(bp, -EIO);
 		xfs_buf_stale(bp);
-		xfs_buf_ioend(bp, 0);
+		xfs_buf_ioend(bp);
 		/*
 		 * It would seem logical to return EIO here, but we rely on
 		 * the log state machine to propagate I/O errors instead of
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1fd5787..4ba19bf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -383,7 +383,7 @@ xlog_recover_iodone(
 					SHUTDOWN_META_IO_ERROR);
 	}
 	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
+	xfs_buf_ioend(bp);
 }
 
 /*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

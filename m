Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE1207FA7
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:34:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5BCACAC003
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:34:49 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5HtDNKE0xPjBHaIl for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:34:46 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX8Fb-0006nC-T6
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX8Fb-0007gZ-Rt
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/11] xfs: xfs_buf_ioend and xfs_buf_iodone_work duplicate
	functionality
Date: Thu, 25 Sep 2014 22:34:14 +1000
Message-Id: <1411648461-29003-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1411648461-29003-1-git-send-email-david@fromorbit.com>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_buf.c         | 88 +++++++++++++++++++++---------------------------
 fs/xfs/xfs_buf.h         |  2 +-
 fs/xfs/xfs_buf_item.c    |  4 +--
 fs/xfs/xfs_inode.c       |  2 +-
 fs/xfs/xfs_log.c         |  2 +-
 fs/xfs/xfs_log_recover.c |  2 +-
 6 files changed, 45 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 5d8d2e1..08f9fca 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -998,26 +998,30 @@ xfs_buf_wait_unpin(
  *	Buffer Utility Routines
  */
 
-STATIC void
-xfs_buf_iodone_work(
-	struct work_struct	*work)
+void
+xfs_buf_ioend(
+	struct xfs_buf	*bp)
 {
-	struct xfs_buf		*bp =
-		container_of(work, xfs_buf_t, b_iodone_work);
-	bool			read = !!(bp->b_flags & XBF_READ);
+	bool		read = bp->b_flags & XBF_READ;
+
+	trace_xfs_buf_iodone(bp, _RET_IP_);
 
 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
 
-	/* only validate buffers that were read without errors */
-	if (read && bp->b_ops && !bp->b_error && (bp->b_flags & XBF_DONE))
+	/* Only validate buffers that were read without errors */
+	if (read && !bp->b_error && bp->b_ops) {
+		ASSERT(!bp->b_iodone);
 		bp->b_ops->verify_read(bp);
+	}
+
+	if (!bp->b_error)
+		bp->b_flags |= XBF_DONE;
 
 	if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
 	else if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_relse(bp);
 	else {
-		ASSERT(read && bp->b_ops);
 		complete(&bp->b_iowait);
 
 		/* release the !XBF_ASYNC ref now we are done. */
@@ -1025,30 +1029,22 @@ xfs_buf_iodone_work(
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
@@ -1099,7 +1095,7 @@ xfs_bioerror(
 	XFS_BUF_UNDONE(bp);
 	xfs_buf_stale(bp);
 
-	xfs_buf_ioend(bp, 0);
+	xfs_buf_ioend(bp);
 
 	return -EIO;
 }
@@ -1186,15 +1182,6 @@ xfs_bwrite(
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
@@ -1211,7 +1198,8 @@ xfs_buf_bio_end_io(
 	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
 
-	_xfs_buf_ioend(bp, 1);
+	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
+		xfs_buf_ioend_async(bp);
 	bio_put(bio);
 }
 
@@ -1423,15 +1411,17 @@ xfs_buf_iorequest(
 	/*
 	 * If _xfs_buf_ioapply failed or we are doing synchronous IO that
 	 * completes extremely quickly, we can get back here with only the IO
-	 * reference we took above. _xfs_buf_ioend will drop it to zero. Run
-	 * completion processing synchronously so that we don't return to the
-	 * caller with completion still pending. This avoids unnecessary context
-	 * switches associated with the end_io workqueue.
+	 * reference we took above. If we drop it to zero, run completion
+	 * processing synchronously so that we don't return to the caller with
+	 * completion still pending. This avoids unnecessary context switches
+	 * associated with the end_io workqueue.
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
index 30fa5db..3916384 100644
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
index c92cb48..e5bbc1f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3062,7 +3062,7 @@ cluster_corrupt_out:
 			XFS_BUF_UNDONE(bp);
 			xfs_buf_stale(bp);
 			xfs_buf_ioerror(bp, -EIO);
-			xfs_buf_ioend(bp, 0);
+			xfs_buf_ioend(bp);
 		} else {
 			xfs_buf_stale(bp);
 			xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a598955..b5170e5 100644
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
index 29e101f..02ad115 100644
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

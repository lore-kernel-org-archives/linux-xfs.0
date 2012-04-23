Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xSX3127482 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:29 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9VPWwYxjW79GcIrp for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:27 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCIy-0001aQ-TR
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:20 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIy-0004YC-P4
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/37] xfs: check for buffer errors before waiting
Date: Mon, 23 Apr 2012 15:58:46 +1000
Message-Id: <1335160747-17254-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

If we call xfs_buf_iowait() on a buffer that failed dispatch due to
an IO error, it will wait forever for an Io that does not exist.
This is hndled in xfs_buf_read, but there is other code that calls
xfs_buf_iowait directly that doesn't.

Rather than make the call sites have to handle checking for dispatch
errors and then checking for completion errors, make
xfs_buf_iowait() check for dispatch errors on the buffer before
waiting. This means we handle both dispatch and completion errors
with one set of error handling at the caller sites.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_buf.c         |   22 ++++++++++------------
 fs/xfs/xfs_buf.h         |    2 +-
 fs/xfs/xfs_log_recover.c |    2 ++
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index da2541e..86d9af7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -600,17 +600,15 @@ _xfs_buf_read(
 	xfs_buf_t		*bp,
 	xfs_buf_flags_t		flags)
 {
-	int			status;
-
 	ASSERT(!(flags & XBF_WRITE));
 	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
 
 	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
 
-	status = xfs_buf_iorequest(bp);
-	if (status || bp->b_error || (flags & XBF_ASYNC))
-		return status;
+	xfs_buf_iorequest(bp);
+	if (flags & XBF_ASYNC)
+		return 0;
 	return xfs_buf_iowait(bp);
 }
 
@@ -695,7 +693,7 @@ xfs_buf_read_uncached(
 
 	xfsbdstrat(mp, bp);
 	error = xfs_buf_iowait(bp);
-	if (error || bp->b_error) {
+	if (error) {
 		xfs_buf_relse(bp);
 		return NULL;
 	}
@@ -1252,7 +1250,7 @@ next_chunk:
 	}
 }
 
-int
+void
 xfs_buf_iorequest(
 	xfs_buf_t		*bp)
 {
@@ -1273,13 +1271,12 @@ xfs_buf_iorequest(
 	_xfs_buf_ioend(bp, 0);
 
 	xfs_buf_rele(bp);
-	return 0;
 }
 
 /*
- *	Waits for I/O to complete on the buffer supplied.
- *	It returns immediately if no I/O is pending.
- *	It returns the I/O error code, if any, or 0 if there was no error.
+ * Waits for I/O to complete on the buffer supplied.  It returns immediately if
+ * no I/O is pending or there is already a pending error on the buffer.  It
+ * returns the I/O error code, if any, or 0 if there was no error.
  */
 int
 xfs_buf_iowait(
@@ -1287,7 +1284,8 @@ xfs_buf_iowait(
 {
 	trace_xfs_buf_iowait(bp, _RET_IP_);
 
-	wait_for_completion(&bp->b_iowait);
+	if (!bp->b_error)
+		wait_for_completion(&bp->b_iowait);
 
 	trace_xfs_buf_iowait_done(bp, _RET_IP_);
 	return bp->b_error;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 7083cf4..87a4748 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -191,7 +191,7 @@ extern int xfs_bdstrat_cb(struct xfs_buf *);
 extern void xfs_buf_ioend(xfs_buf_t *,	int);
 extern void xfs_buf_ioerror(xfs_buf_t *, int);
 extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
-extern int xfs_buf_iorequest(xfs_buf_t *);
+extern void xfs_buf_iorequest(xfs_buf_t *);
 extern int xfs_buf_iowait(xfs_buf_t *);
 extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
 				xfs_buf_rw_t);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 396e3bf..64ed6ff 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -179,6 +179,7 @@ xlog_bread_noalign(
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
+	bp->b_error = 0;
 
 	xfsbdstrat(log->l_mp, bp);
 	error = xfs_buf_iowait(bp);
@@ -266,6 +267,7 @@ xlog_bwrite(
 	xfs_buf_hold(bp);
 	xfs_buf_lock(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
+	bp->b_error = 0;
 
 	error = xfs_bwrite(bp);
 	if (error)
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

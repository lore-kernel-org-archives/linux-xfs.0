Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54Vvm135787 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:32 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	175zH96H64vHSllW for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:16 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbU-0003JQ-QY
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:12 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbK-0003iA-OG
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 082/102] xfs: check for buffer errors before waiting
Date: Thu, 23 Aug 2012 15:02:40 +1000
Message-Id: <1345698180-13612-83-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

Upstream commit: 0e95f19ad983e72a9cb93a67b3290b58f0467b36

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
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   24 +++++++++++-------------
 fs/xfs/linux-2.6/xfs_buf.h |    2 +-
 fs/xfs/xfs_log_recover.c   |    2 ++
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 0858fe1..5487eaa 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -597,8 +597,6 @@ _xfs_buf_read(
 	xfs_buf_t		*bp,
 	xfs_buf_flags_t		flags)
 {
-	int			status;
-
 	ASSERT(!(flags & (XBF_DELWRI|XBF_WRITE)));
 	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
 
@@ -607,9 +605,9 @@ _xfs_buf_read(
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | \
 			XBF_READ_AHEAD | _XBF_RUN_QUEUES);
 
-	status = xfs_buf_iorequest(bp);
-	if (status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC))
-		return status;
+	xfs_buf_iorequest(bp);
+	if (flags & XBF_ASYNC)
+		return 0;
 	return xfs_buf_iowait(bp);
 }
 
@@ -696,7 +694,7 @@ xfs_buf_read_uncached(
 
 	xfsbdstrat(mp, bp);
 	error = xfs_buf_iowait(bp);
-	if (error || bp->b_error) {
+	if (error) {
 		xfs_buf_relse(bp);
 		return NULL;
 	}
@@ -1288,7 +1286,7 @@ next_chunk:
 	}
 }
 
-int
+void
 xfs_buf_iorequest(
 	xfs_buf_t		*bp)
 {
@@ -1296,7 +1294,7 @@ xfs_buf_iorequest(
 
 	if (bp->b_flags & XBF_DELWRI) {
 		xfs_buf_delwri_queue(bp, 1);
-		return 0;
+		return;
 	}
 
 	if (bp->b_flags & XBF_WRITE) {
@@ -1314,13 +1312,12 @@ xfs_buf_iorequest(
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
@@ -1328,7 +1325,8 @@ xfs_buf_iowait(
 {
 	trace_xfs_buf_iowait(bp, _RET_IP_);
 
-	wait_for_completion(&bp->b_iowait);
+	if (!bp->b_error)
+		wait_for_completion(&bp->b_iowait);
 
 	trace_xfs_buf_iowait_done(bp, _RET_IP_);
 	return bp->b_error;
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 71d6698..edb8d7c 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -208,7 +208,7 @@ extern int xfs_bdstrat_cb(struct xfs_buf *);
 extern void xfs_buf_ioend(xfs_buf_t *,	int);
 extern void xfs_buf_ioerror(xfs_buf_t *, int);
 extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
-extern int xfs_buf_iorequest(xfs_buf_t *);
+extern void xfs_buf_iorequest(xfs_buf_t *);
 extern int xfs_buf_iowait(xfs_buf_t *);
 extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
 				xfs_buf_rw_t);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 82f7d18..13c057b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -177,6 +177,7 @@ xlog_bread_noalign(
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
 	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
+	bp->b_error = 0;
 
 	xfsbdstrat(log->l_mp, bp);
 	error = xfs_buf_iowait(bp);
@@ -266,6 +267,7 @@ xlog_bwrite(
 	XFS_BUF_PSEMA(bp, PRIBIO);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
 	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
+	bp->b_error = 0;
 
 	error = xfs_bwrite(log->l_mp, bp);
 	if (error)
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

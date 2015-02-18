Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6038F7FA4
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 16:32:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1AB368F804C
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 14:32:24 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	j2LRCgosisb07am7 for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 14:32:22 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YODAK-0000JV-BA
	for xfs@oss.sgi.com; Thu, 19 Feb 2015 09:32:20 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YODAK-0006j5-7c
	for xfs@oss.sgi.com; Thu, 19 Feb 2015 09:32:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: Introduce permanent async buffer write IO failures
Date: Thu, 19 Feb 2015 09:32:20 +1100
Message-Id: <1424298740-25821-1-git-send-email-david@fromorbit.com>
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

Currently we consider all async metadata buffer write failures as
transient failures and retry the IO immediately and then again at a
a later time. The issue with this is that we can hang forever is the
error is not recoverable.

An example of this is a device that has been pulled and so is
returning ENODEV to all IO. Attempting to unmount the filesystem
with the device in this state will result in a hang waiting for the
async metadata IO to be flushed and written successfully. In this
case, we need metadata writeback to error out and trigger a shutdown
state so the unmount can complete.

Put simply, we need to consider some errors as permanent and
unrecoverable rather than transient.

Hence add infrastructure that allows us to classify the async write
errors and hence apply different policies to the different failures.
In this patch, classify ENODEV as a permanent error but leave
all the other types of error handling unchanged.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 110 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 66 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 507d96a..274678f 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1041,14 +1041,13 @@ xfs_buf_do_callbacks(
 }
 
 /*
- * This is the iodone() function for buffers which have had callbacks
- * attached to them by xfs_buf_attach_iodone().  It should remove each
- * log item from the buffer's list and call the callback of each in turn.
- * When done, the buffer's fsprivate field is set to NULL and the buffer
- * is unlocked with a call to iodone().
+ * Process a write IO error on a buffer with active log items.
+ *
+ * Returns true if the buffer has been completed and released, false if callback
+ * processing still needs to be performed and the IO completed.
  */
-void
-xfs_buf_iodone_callbacks(
+static bool
+xfs_buf_iodone_callback_error(
 	struct xfs_buf		*bp)
 {
 	struct xfs_log_item	*lip = bp->b_fspriv;
@@ -1056,19 +1055,12 @@ xfs_buf_iodone_callbacks(
 	static ulong		lasttime;
 	static xfs_buftarg_t	*lasttarg;
 
-	if (likely(!bp->b_error))
-		goto do_callbacks;
-
 	/*
 	 * If we've already decided to shutdown the filesystem because of
 	 * I/O errors, there's no point in giving this a retry.
 	 */
-	if (XFS_FORCED_SHUTDOWN(mp)) {
-		xfs_buf_stale(bp);
-		XFS_BUF_DONE(bp);
-		trace_xfs_buf_item_iodone(bp, _RET_IP_);
-		goto do_callbacks;
-	}
+	if (XFS_FORCED_SHUTDOWN(mp))
+		goto out_stale;
 
 	if (bp->b_target != lasttarg ||
 	    time_after(jiffies, (lasttime + 5*HZ))) {
@@ -1077,45 +1069,75 @@ xfs_buf_iodone_callbacks(
 	}
 	lasttarg = bp->b_target;
 
+	/* synchronous writes will have callers process the error */
+	if (!(bp->b_flags & XBF_ASYNC))
+		goto out_stale;
+
+	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
+	ASSERT(bp->b_iodone != NULL);
+	xfs_buf_ioerror(bp, 0);
+
 	/*
 	 * If the write was asynchronous then no one will be looking for the
-	 * error.  Clear the error state and write the buffer out again.
-	 *
-	 * XXX: This helps against transient write errors, but we need to find
-	 * a way to shut the filesystem down if the writes keep failing.
-	 *
-	 * In practice we'll shut the filesystem down soon as non-transient
-	 * errors tend to affect the whole device and a failing log write
-	 * will make us give up.  But we really ought to do better here.
+	 * error.  If this is the first failure, clear the error state and write
+	 * the buffer out again.
 	 */
-	if (XFS_BUF_ISASYNC(bp)) {
-		ASSERT(bp->b_iodone != NULL);
-
-		trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
-
-		xfs_buf_ioerror(bp, 0); /* errno of 0 unsets the flag */
-
-		if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL))) {
-			bp->b_flags |= XBF_WRITE | XBF_ASYNC |
-				       XBF_DONE | XBF_WRITE_FAIL;
-			xfs_buf_submit(bp);
-		} else {
-			xfs_buf_relse(bp);
-		}
-
-		return;
+	if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL))) {
+		bp->b_flags |= XBF_WRITE | XBF_ASYNC |
+			       XBF_DONE | XBF_WRITE_FAIL;
+		xfs_buf_submit(bp);
+		return true;
 	}
 
 	/*
-	 * If the write of the buffer was synchronous, we want to make
-	 * sure to return the error to the caller of xfs_bwrite().
+	 * Repeated failure on an async write.
+	 *
+	 * Now we need to classify the error and determine the correct action to
+	 * take. Different types of errors will require different processing,
+	 * but make the default classification "transient" so that we keep
+	 * retrying in these cases.  If this is the wrog thing to do, then we'll
+	 * get reports that the filesystem hung in the presence of that type of
+	 * error and we can take appropriate action to remedy the issue for that
+	 * type of error.
 	 */
+	switch (bp->b_error) {
+	case ENODEV:
+		/* permanent error, no recovery possible */
+		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+		goto out_stale;
+	default:
+		/* do nothing, higher layers will retry */
+		break;
+	}
+
+	xfs_buf_relse(bp);
+	return true;
+
+out_stale:
 	xfs_buf_stale(bp);
 	XFS_BUF_DONE(bp);
-
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
+	return false;
+}
+
+/*
+ * This is the iodone() function for buffers which have had callbacks attached
+ * to them by xfs_buf_attach_iodone(). We need to iterate the items on the
+ * callback list, mark the buffer as having no more callbacks and then push the
+ * buffer through IO completion processing.
+ */
+void
+xfs_buf_iodone_callbacks(
+	struct xfs_buf		*bp)
+{
+	/*
+	 * If there is an error, process it. Some errors require us
+	 * to run callbacks after failure processing is done so we
+	 * detect that and take appropriate action.
+	 */
+	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
+		return;
 
-do_callbacks:
 	xfs_buf_do_callbacks(bp);
 	bp->b_fspriv = NULL;
 	bp->b_iodone = NULL;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

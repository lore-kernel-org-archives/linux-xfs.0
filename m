Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7530F7F6F
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 16:39:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5570D304032
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 14:39:10 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wiaCHO69gyQNlqde for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 14:39:08 -0800 (PST)
Message-ID: <54E6660B.6040406@sandeen.net>
Date: Thu, 19 Feb 2015 16:39:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Introduce permanent async buffer write IO failures
References: <1424298740-25821-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1424298740-25821-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

What about something along these lines (rough, but works) - 
shut down the fs after enough time goes by with sequential errors
and no success, on the same buffer (based on your patch...)

One thing that still happens is a lot of error spew during the
retries, maybe we can make more use of XBF_WRITE_FAIL to only
print errors once?


Based-on-patch-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 75ff5d5..13c47a1 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -181,6 +181,7 @@ typedef struct xfs_buf {
 	unsigned int		b_page_count;	/* size of page array */
 	unsigned int		b_offset;	/* page offset in first page */
 	int			b_error;	/* error code on I/O */
+	unsigned long		b_first_error_time;
 	const struct xfs_buf_ops	*b_ops;
 
 #ifdef XFS_BUF_LOCK_TRACKING
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 507d96a..4751c5f 100644
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
@@ -1077,45 +1069,70 @@ xfs_buf_iodone_callbacks(
 	}
 	lasttarg = bp->b_target;
 
+	/* synchronous writes will have callers process the error */
+	if (!(bp->b_flags & XBF_ASYNC))
+		goto out_stale;
+
+	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
+	ASSERT(bp->b_iodone != NULL);
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
+		if (!bp->b_first_error_time)
+			bp->b_first_error_time = get_seconds();
+		xfs_buf_ioerror(bp, 0);
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
+	 * Let things retry for <tuneable handwave> 60s, then give up.
+	 * XXX handle seconds wrap?
 	 */
+	if (get_seconds() - bp->b_first_error_time > 60) {
+		xfs_err(mp, "too many errors, giving up");
+		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+		goto out_stale;
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
+	/* zero out error timer if we're good */
+	bp->b_first_error_time = 0;
 	xfs_buf_do_callbacks(bp);
 	bp->b_fspriv = NULL;
 	bp->b_iodone = NULL;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

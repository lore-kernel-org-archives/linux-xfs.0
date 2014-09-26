Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2AC497FAF
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 07:33:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1634F304039
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 05:33:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id CJpQOQ1vEBB8Gg4f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 05:33:39 -0700 (PDT)
Date: Fri, 26 Sep 2014 05:33:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/11] xfs: introduce xfs_buf_submit[_wait]
Message-ID: <20140926123338.GA18558@infradead.org>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
	<1411648461-29003-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411648461-29003-10-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks good, although I still think this would benefit from a helper
like the one below (patch lightly tested).

Reviewed-by: Christoph Hellwig <hch@lst.de>


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0ac54a0..081ccf3 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1287,28 +1287,18 @@ _xfs_buf_ioapply(
 	blk_finish_plug(&plug);
 }
 
-/*
- * Asynchronous IO submission path. This transfers the buffer lock ownership and
- * the current reference to the IO. It is not safe to reference the buffer after
- * a call to this function unless the caller holds an additional reference
- * itself.
- */
-void
-xfs_buf_submit(
+static int
+__xfs_buf_submit(
 	struct xfs_buf	*bp)
 {
-	trace_xfs_buf_submit(bp, _RET_IP_);
-
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
-	ASSERT(bp->b_flags & XBF_ASYNC);
 
 	/* on shutdown we stale and complete the buffer immediately */
 	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
 		xfs_buf_ioerror(bp, -EIO);
 		bp->b_flags &= ~XBF_DONE;
 		xfs_buf_stale(bp);
-		xfs_buf_ioend(bp);
-		return;
+		return -EIO;
 	}
 
 	if (bp->b_flags & XBF_WRITE)
@@ -1318,12 +1308,8 @@ xfs_buf_submit(
 	bp->b_io_error = 0;
 
 	/*
-	 * The caller's reference is released during I/O completion.
-	 * This occurs some time after the last b_io_remaining reference is
-	 * released, so after we drop our Io reference we have to have some
-	 * other reference to ensure the buffer doesn't go away from underneath
-	 * us. Take a direct reference to ensure we have safe access to the
-	 * buffer until we are finished with it.
+	 * Take a reference to ensure we have safe access to the buffer until
+	 * we are finished with it.
 	 */
 	xfs_buf_hold(bp);
 
@@ -1341,64 +1327,56 @@ xfs_buf_submit(
 	 * that we don't return to the caller with completion still pending.
 	 */
 	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
-		if (bp->b_error)
-			xfs_buf_ioend(bp);
-		else
+		if ((bp->b_flags & XBF_ASYNC) && !bp->b_error)
 			xfs_buf_ioend_async(bp);
+		else
+			xfs_buf_ioend(bp);
 	}
 
-	xfs_buf_rele(bp);
-	/* Note: it is not safe to reference bp now we've dropped our ref */
+	return 0;
 }
 
 /*
- * Synchronous buffer IO submission path, read or write.
+ * Asynchronous IO submission path. This transfers the buffer lock ownership and
+ * the current reference to the IO. It is not safe to reference the buffer after
+ * a call to this function unless the caller holds an additional reference
+ * itself.
  */
-int
-xfs_buf_submit_wait(
+void
+xfs_buf_submit(
 	struct xfs_buf	*bp)
 {
 	int		error;
 
-	trace_xfs_buf_submit_wait(bp, _RET_IP_);
+	trace_xfs_buf_submit(bp, _RET_IP_);
 
-	ASSERT(!(bp->b_flags & (_XBF_DELWRI_Q | XBF_ASYNC)));
+	ASSERT(bp->b_flags & XBF_ASYNC);
 
-	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
-		xfs_buf_ioerror(bp, -EIO);
-		xfs_buf_stale(bp);
-		bp->b_flags &= ~XBF_DONE;
-		return -EIO;
-	}
+	error = __xfs_buf_submit(bp);
+	if (error)
+		xfs_buf_ioend(bp);
+	else
+		xfs_buf_rele(bp);
 
-	if (bp->b_flags & XBF_WRITE)
-		xfs_buf_wait_unpin(bp);
+	/* Note: it is not safe to reference bp now we've dropped our ref */
+}
 
-	/* clear the internal error state to avoid spurious errors */
-	bp->b_io_error = 0;
+/*
+ * Synchronous buffer IO submission path, read or write.
+ */
+int
+xfs_buf_submit_wait(
+	struct xfs_buf	*bp)
+{
+	int		error;
 
-	/*
-	 * For synchronous IO, the IO does not inherit the submitters reference
-	 * count, nor the buffer lock. Hence we cannot release the reference we
-	 * are about to take until we've waited for all IO completion to occur,
-	 * including any xfs_buf_ioend_async() work that may be pending.
-	 */
-	xfs_buf_hold(bp);
+	trace_xfs_buf_submit_wait(bp, _RET_IP_);
 
-	/*
-	 * Set the count to 1 initially, this will stop an I/O completion
-	 * callout which happens before we have started all the I/O from calling
-	 * xfs_buf_ioend too early.
-	 */
-	atomic_set(&bp->b_io_remaining, 1);
-	_xfs_buf_ioapply(bp);
+	ASSERT(!(bp->b_flags & XBF_ASYNC));
 
-	/*
-	 * make sure we run completion synchronously if it raced with us and is
-	 * already complete.
-	 */
-	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
-		xfs_buf_ioend(bp);
+	error = __xfs_buf_submit(bp);
+	if (error)
+		return error;
 
 	/* wait for completion before gathering the error from the buffer */
 	trace_xfs_buf_iowait(bp, _RET_IP_);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

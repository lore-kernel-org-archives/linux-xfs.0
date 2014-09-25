Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D41F7F9B
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:34:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F19328F8050
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:34:45 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	1m4hw8tyIOpBoXww for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:34:44 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX8Fb-0006nB-ST
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX8Fb-0007gU-RL
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/11] xfs: synchronous buffer IO needs a reference
Date: Thu, 25 Sep 2014 22:34:13 +1000
Message-Id: <1411648461-29003-4-git-send-email-david@fromorbit.com>
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

When synchronous IO runs IO completion work, it does so without an
IO reference or a hold reference on the buffer. The IO "hold
reference" is owned by the submitter, and released when the
submission is complete. The IO reference is released when both the
submitter and the bio end_io processing is run, and so if the io
completion work is run from IO completion context, it is run without
an IO reference.

Hence we can get the situation where the submitter can submit the
IO, see an error on the buffer and unlock and free the buffer while
there is still IO in progress. This leads to use-after-free and
memory corruption.

Fix this by taking a "sync IO hold" reference that is owned by the
IO and not released until after the buffer completion calls are run
to wake up synchronous waiters. This means that the buffer will not
be freed in any circumstance until all IO processing is completed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 51 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f1bd238..5d8d2e1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1019,6 +1019,9 @@ xfs_buf_iodone_work(
 	else {
 		ASSERT(read && bp->b_ops);
 		complete(&bp->b_iowait);
+
+		/* release the !XBF_ASYNC ref now we are done. */
+		xfs_buf_rele(bp);
 	}
 }
 
@@ -1044,6 +1047,7 @@ xfs_buf_ioend(
 	} else {
 		bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
 		complete(&bp->b_iowait);
+		xfs_buf_rele(bp);
 	}
 }
 
@@ -1086,8 +1090,11 @@ xfs_bioerror(
 	xfs_buf_ioerror(bp, -EIO);
 
 	/*
-	 * We're calling xfs_buf_ioend, so delete XBF_DONE flag.
+	 * We're calling xfs_buf_ioend, so delete XBF_DONE flag. For
+	 * sync IO, xfs_buf_ioend is going to remove a ref here.
 	 */
+	if (!(bp->b_flags & XBF_ASYNC))
+		xfs_buf_hold(bp);
 	XFS_BUF_UNREAD(bp);
 	XFS_BUF_UNDONE(bp);
 	xfs_buf_stale(bp);
@@ -1383,22 +1390,48 @@ xfs_buf_iorequest(
 
 	if (bp->b_flags & XBF_WRITE)
 		xfs_buf_wait_unpin(bp);
+
+	/*
+	 * Take references to the buffer. For XBF_ASYNC buffers, holding a
+	 * reference for as long as submission takes is all that is necessary
+	 * here. The IO inherits the lock and hold count from the submitter,
+	 * and these are release during IO completion processing. Taking a hold
+	 * over submission ensures that the buffer is not freed until we have
+	 * completed all processing, regardless of when IO errors occur or are
+	 * reported.
+	 *
+	 * However, for synchronous IO, the IO does not inherit the submitters
+	 * reference count, nor the buffer lock. Hence we need to take an extra
+	 * reference to the buffer for the for the IO context so that we can
+	 * guarantee the buffer is not freed until all IO completion processing
+	 * is done. Otherwise the caller can drop their reference while the IO
+	 * is still in progress and hence trigger a use-after-free situation.
+	 */
 	xfs_buf_hold(bp);
+	if (!(bp->b_flags & XBF_ASYNC))
+		xfs_buf_hold(bp);
+
 
 	/*
-	 * Set the count to 1 initially, this will stop an I/O
-	 * completion callout which happens before we have started
-	 * all the I/O from calling xfs_buf_ioend too early.
+	 * Set the count to 1 initially, this will stop an I/O completion
+	 * callout which happens before we have started all the I/O from calling
+	 * xfs_buf_ioend too early.
 	 */
 	atomic_set(&bp->b_io_remaining, 1);
 	_xfs_buf_ioapply(bp);
+
 	/*
-	 * If _xfs_buf_ioapply failed, we'll get back here with
-	 * only the reference we took above.  _xfs_buf_ioend will
-	 * drop it to zero, so we'd better not queue it for later,
-	 * or we'll free it before it's done.
+	 * If _xfs_buf_ioapply failed or we are doing synchronous IO that
+	 * completes extremely quickly, we can get back here with only the IO
+	 * reference we took above. _xfs_buf_ioend will drop it to zero. Run
+	 * completion processing synchronously so that we don't return to the
+	 * caller with completion still pending. This avoids unnecessary context
+	 * switches associated with the end_io workqueue.
 	 */
-	_xfs_buf_ioend(bp, bp->b_error ? 0 : 1);
+	if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
+		_xfs_buf_ioend(bp, 0);
+	else
+		_xfs_buf_ioend(bp, 1);
 
 	xfs_buf_rele(bp);
 }
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

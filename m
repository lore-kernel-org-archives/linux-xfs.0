Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 26A237F59
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 01:39:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0615B8F8052
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 23:39:15 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nJUazeS1axm4KoZR for <xfs@oss.sgi.com>;
	Thu, 14 Aug 2014 23:39:14 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XIBAL-0001ZP-9U
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XIBAL-0001UE-8L
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/9] xfs: synchronous buffer IO needs a reference
Date: Fri, 15 Aug 2014 16:38:59 +1000
Message-Id: <1408084747-4540-2-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_buf.c | 46 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index cd7b8ca..5d86bbd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1019,6 +1019,7 @@ xfs_buf_iodone_work(
 	else {
 		ASSERT(read && bp->b_ops);
 		complete(&bp->b_iowait);
+		xfs_buf_rele(bp);
 	}
 }
 
@@ -1044,6 +1045,7 @@ xfs_buf_ioend(
 	} else {
 		bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
 		complete(&bp->b_iowait);
+		xfs_buf_rele(bp);
 	}
 }
 
@@ -1383,22 +1385,50 @@ xfs_buf_iorequest(
 
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
+	 * reference we took above.  _xfs_buf_ioend will drop it to zero, so
+	 * we'd better run completion processing synchronously so that the we
+	 * don't return to the caller with completion still pending. In the
+	 * error case, this allows the caller to check b_error safely without
+	 * waiting, and in the synchronous IO case it avoids unnecessary context
+	 * switches an latency for high-peformance devices.
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

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 72BD37F47
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 01:39:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 617A9304043
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 23:39:17 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VJ9s7AMB8H2MOqii for <xfs@oss.sgi.com>;
	Thu, 14 Aug 2014 23:39:15 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XIBAL-0001ZT-BY
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XIBAL-0001UZ-Ah
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/9] xfs: xfs_bioerror can die.
Date: Fri, 15 Aug 2014 16:39:03 +1000
Message-Id: <1408084747-4540-6-git-send-email-david@fromorbit.com>
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

Internal buffer write error handling is a mess due to the unnatural
split between xfs_bioerror and xfs_bioerror_relse(). The buffer
reference counting is also wrong for the xfs_bioerror path for
xfs_bwrite - it uses sync IO and so xfs_buf_ioend will release a
hold count that was never taken.

Further, xfs_bwrite only does sync IO and determines the handler to
call based on b_iodone, so for this caller the only difference
between xfs_bioerror() and xfs_bioerror_release() is the XBF_DONE
flag. We don't care what the XBF_DONE flag state is because we stale
the buffer in both paths - the next buffer lookup will clear
XBF_DONE anyway because XBF_STALE is set. Hence we can use common
error handling for xfs_bwrite().

__xfs_buf_delwri_submit() is a similar - it's only ever called
on writes - all sync or async - and again there's no reason to
handle them any differently at all.

Clean up the nasty error handling and remove xfs_bioerror().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 67 +++++++++++++++++---------------------------------------
 1 file changed, 20 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 98fcf5a..f444285 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1072,36 +1072,6 @@ xfs_buf_ioerror_alert(
 }
 
 /*
- * Called when we want to stop a buffer from getting written or read.
- * We attach the EIO error, muck with its flags, and call xfs_buf_ioend
- * so that the proper iodone callbacks get called.
- */
-STATIC int
-xfs_bioerror(
-	xfs_buf_t *bp)
-{
-#ifdef XFSERRORDEBUG
-	ASSERT(XFS_BUF_ISREAD(bp) || bp->b_iodone);
-#endif
-
-	/*
-	 * No need to wait until the buffer is unpinned, we aren't flushing it.
-	 */
-	xfs_buf_ioerror(bp, -EIO);
-
-	/*
-	 * We're calling xfs_buf_ioend, so delete XBF_DONE flag.
-	 */
-	XFS_BUF_UNREAD(bp);
-	XFS_BUF_UNDONE(bp);
-	xfs_buf_stale(bp);
-
-	xfs_buf_ioend(bp);
-
-	return -EIO;
-}
-
-/*
  * Same as xfs_bioerror, except that we are releasing the buffer
  * here ourselves, and avoiding the xfs_buf_ioend call.
  * This is meant for userdata errors; metadata bufs come with
@@ -1149,19 +1119,19 @@ xfs_bwrite(
 	ASSERT(xfs_buf_islocked(bp));
 
 	bp->b_flags |= XBF_WRITE;
-	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q | XBF_WRITE_FAIL);
+	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
+			 XBF_WRITE_FAIL | XBF_DONE);
 
 	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
 		trace_xfs_bdstrat_shut(bp, _RET_IP_);
 
-		/*
-		 * Metadata write that didn't get logged but written anyway.
-		 * These aren't associated with a transaction, and can be
-		 * ignored.
-		 */
-		if (!bp->b_iodone)
-			return xfs_bioerror_relse(bp);
-		return xfs_bioerror(bp);
+		xfs_buf_ioerror(bp, -EIO);
+		xfs_buf_stale(bp);
+
+		/* sync IO, xfs_buf_ioend is going to remove a ref here */
+		xfs_buf_hold(bp);
+		xfs_buf_ioend(bp);
+		return -EIO;
 	}
 
 	xfs_buf_iorequest(bp);
@@ -1848,16 +1818,19 @@ __xfs_buf_delwri_submit(
 		if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
 			trace_xfs_bdstrat_shut(bp, _RET_IP_);
 
+			xfs_buf_ioerror(bp, -EIO);
+			xfs_buf_stale(bp);
+
 			/*
-			 * Metadata write that didn't get logged but written anyway.
-			 * These aren't associated with a transaction, and can be
-			 * ignored.
+			 * if sync IO, xfs_buf_ioend is going to remove a
+			 * ref here. We need to add that so we can collect
+			 * all the buffer errors in the wait loop.
 			 */
-			if (!bp->b_iodone)
-				return xfs_bioerror_relse(bp);
-			return xfs_bioerror(bp);
-		}
-		xfs_buf_iorequest(bp);
+			if (wait)
+				xfs_buf_hold(bp);
+			xfs_buf_ioend(bp);
+		} else
+			xfs_buf_iorequest(bp);
 	}
 	blk_finish_plug(&plug);
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

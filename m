Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 024A67FAD
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:34:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D8BF68F8039
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:34:49 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0JF4xtGR30htdU6T for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:34:48 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX8Fb-0006nF-Ug
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX8Fb-0007go-TQ
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/11] xfs: xfs_bioerror can die.
Date: Thu, 25 Sep 2014 22:34:17 +1000
Message-Id: <1411648461-29003-8-git-send-email-david@fromorbit.com>
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

Internal buffer write error handling is a mess due to the unnatural
split between xfs_bioerror and xfs_bioerror_relse().

xfs_bwrite() only does sync IO and determines the handler to
call based on b_iodone, so for this caller the only difference
between xfs_bioerror() and xfs_bioerror_release() is the XBF_DONE
flag. We don't care what the XBF_DONE flag state is because we stale
the buffer in both paths - the next buffer lookup will clear
XBF_DONE because XBF_STALE is set. Hence we can use common
error handling for xfs_bwrite().

__xfs_buf_delwri_submit() is a similar - it's only ever called
on writes - all sync or async - and again there's no reason to
handle them any differently at all.

Clean up the nasty error handling and remove xfs_bioerror().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 58 ++++++++++++--------------------------------------------
 1 file changed, 12 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 411111a..cc6a558 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1075,39 +1075,6 @@ xfs_buf_ioerror_alert(
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
-	 * We're calling xfs_buf_ioend, so delete XBF_DONE flag. For
-	 * sync IO, xfs_buf_ioend is going to remove a ref here.
-	 */
-	if (!(bp->b_flags & XBF_ASYNC))
-		xfs_buf_hold(bp);
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
@@ -1155,19 +1122,19 @@ xfs_bwrite(
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
@@ -1857,10 +1824,9 @@ __xfs_buf_delwri_submit(
 		if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
 			trace_xfs_bdstrat_shut(bp, _RET_IP_);
 
-			if (!bp->b_iodone)
-				xfs_bioerror_relse(bp);
-			else
-				xfs_bioerror(bp);
+			xfs_buf_ioerror(bp, -EIO);
+			xfs_buf_stale(bp);
+			xfs_buf_ioend(bp);
 			continue;
 		}
 		xfs_buf_iorequest(bp);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

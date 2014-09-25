Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 14C607FA5
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:34:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88F7AAC007
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:34:47 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LHeAM0XABcCDjqmb for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:34:45 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX8Fb-0006nE-U2
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX8Fb-0007gj-Sz
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/11] xfs: kill xfs_bdstrat_cb
Date: Thu, 25 Sep 2014 22:34:16 +1000
Message-Id: <1411648461-29003-7-git-send-email-david@fromorbit.com>
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

Only has two callers, and is just a shutdown check and error handler
around xfs_buf_iorequest. However, the error handling is a mess of
read and write semantics, and both internal callers only call it for
writes. Hence kill the wrapper, and follow up with a patch to
sanitise the error handling.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a8f4a39..411111a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1146,27 +1146,6 @@ xfs_bioerror_relse(
 	return -EIO;
 }
 
-STATIC int
-xfs_bdstrat_cb(
-	struct xfs_buf	*bp)
-{
-	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
-		trace_xfs_bdstrat_shut(bp, _RET_IP_);
-		/*
-		 * Metadata write that didn't get logged but
-		 * written delayed anyway. These aren't associated
-		 * with a transaction, and can be ignored.
-		 */
-		if (!bp->b_iodone && !XFS_BUF_ISREAD(bp))
-			return xfs_bioerror_relse(bp);
-		else
-			return xfs_bioerror(bp);
-	}
-
-	xfs_buf_iorequest(bp);
-	return 0;
-}
-
 int
 xfs_bwrite(
 	struct xfs_buf		*bp)
@@ -1178,7 +1157,20 @@ xfs_bwrite(
 	bp->b_flags |= XBF_WRITE;
 	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q | XBF_WRITE_FAIL);
 
-	xfs_bdstrat_cb(bp);
+	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
+		trace_xfs_bdstrat_shut(bp, _RET_IP_);
+
+		/*
+		 * Metadata write that didn't get logged but written anyway.
+		 * These aren't associated with a transaction, and can be
+		 * ignored.
+		 */
+		if (!bp->b_iodone)
+			return xfs_bioerror_relse(bp);
+		return xfs_bioerror(bp);
+	}
+
+	xfs_buf_iorequest(bp);
 
 	error = xfs_buf_iowait(bp);
 	if (error) {
@@ -1861,7 +1853,17 @@ __xfs_buf_delwri_submit(
 			xfs_buf_hold(bp);
 		else
 			list_del_init(&bp->b_list);
-		xfs_bdstrat_cb(bp);
+
+		if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
+			trace_xfs_bdstrat_shut(bp, _RET_IP_);
+
+			if (!bp->b_iodone)
+				xfs_bioerror_relse(bp);
+			else
+				xfs_bioerror(bp);
+			continue;
+		}
+		xfs_buf_iorequest(bp);
 	}
 	blk_finish_plug(&plug);
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

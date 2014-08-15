Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7D3F029DF9
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 01:39:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2D5B304039
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 23:39:18 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	BiLXs6cKcCev9Grk for <xfs@oss.sgi.com>;
	Thu, 14 Aug 2014 23:39:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XIBAL-0001ZS-Az
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XIBAL-0001UT-A9
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/9] xfs: kill xfs_bdstrat_cb
Date: Fri, 15 Aug 2014 16:39:02 +1000
Message-Id: <1408084747-4540-5-git-send-email-david@fromorbit.com>
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

Only has two callers, and is just a shutdown check and error handler
around xfs_buf_iorequest. However, the error handling is a mess of
read and write semantics, and both internal callers only call it for
writes. Hence kill the wrapper, and follow up with a patch to
sanitise the error handling.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 51 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 58ae34c..98fcf5a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1140,27 +1140,6 @@ xfs_bioerror_relse(
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
@@ -1172,7 +1151,20 @@ xfs_bwrite(
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
@@ -1852,7 +1844,20 @@ __xfs_buf_delwri_submit(
 			bp->b_flags |= XBF_ASYNC;
 			list_del_init(&bp->b_list);
 		}
-		xfs_bdstrat_cb(bp);
+
+		if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
+			trace_xfs_bdstrat_shut(bp, _RET_IP_);
+
+			/*
+			 * Metadata write that didn't get logged but written anyway.
+			 * These aren't associated with a transaction, and can be
+			 * ignored.
+			 */
+			if (!bp->b_iodone)
+				return xfs_bioerror_relse(bp);
+			return xfs_bioerror(bp);
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

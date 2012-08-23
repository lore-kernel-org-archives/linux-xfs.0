Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52gso134609 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:42 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tksJHqO9FR0A5BUE for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:27 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZl-0003Eg-0S
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:25 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZf-0003cB-TH
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 013/102] xfs: reduce the number of log forces from tail pushing
Date: Thu, 23 Aug 2012 15:01:31 +1000
Message-Id: <1345698180-13612-14-git-send-email-david@fromorbit.com>
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

Upstream commit: 670ce93fef93bba8c8a422a79747385bec8e846a

The AIL push code will issue a log force on ever single push loop
that it exits and has encountered pinned items. It doesn't rescan
these pinned items until it revisits the AIL from the start. Hence
we only need to force the log once per walk from the start of the
AIL to the target LSN.

This results in numbers like this:

	xs_push_ail_flush.....         1456
	xs_log_force.........          1485

For an 8-way 50M inode create workload - almost all the log forces
are coming from the AIL pushing code.

Reduce the number of log forces by only forcing the log if the
previous walk found pinned buffers. This reduces the numbers to:

	xs_push_ail_flush.....          665
	xs_log_force.........           682

For the same test.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_trans_ail.c  |   35 +++++++++++++++++++++--------------
 fs/xfs/xfs_trans_priv.h |    1 +
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index a4c281b..3949a5e 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -414,12 +414,24 @@ xfsaild_push(
 	xfs_lsn_t		lsn;
 	xfs_lsn_t		target;
 	long			tout = 10;
-	int			flush_log = 0;
 	int			stuck = 0;
 	int			count = 0;
 	int			push_xfsbufd = 0;
 
+	/*
+	 * If last time we ran we encountered pinned items, force the log first
+	 * and wait for it before pushing again.
+	 */
 	spin_lock(&ailp->xa_lock);
+	if (ailp->xa_last_pushed_lsn == 0 && ailp->xa_log_flush &&
+	    !list_empty(&ailp->xa_ail)) {
+		ailp->xa_log_flush = 0;
+		spin_unlock(&ailp->xa_lock);
+		XFS_STATS_INC(xs_push_ail_flush);
+		xfs_log_force(mp, XFS_LOG_SYNC);
+		spin_lock(&ailp->xa_lock);
+	}
+
 	target = ailp->xa_target;
 	xfs_trans_ail_cursor_init(ailp, cur);
 	lip = xfs_trans_ail_cursor_first(ailp, cur, ailp->xa_last_pushed_lsn);
@@ -473,7 +485,7 @@ xfsaild_push(
 
 			if (!IOP_PUSHBUF(lip)) {
 				stuck++;
-				flush_log = 1;
+				ailp->xa_log_flush++;
 			} else {
 				ailp->xa_last_pushed_lsn = lsn;
 			}
@@ -483,7 +495,7 @@ xfsaild_push(
 		case XFS_ITEM_PINNED:
 			XFS_STATS_INC(xs_push_ail_pinned);
 			stuck++;
-			flush_log = 1;
+			ailp->xa_log_flush++;
 			break;
 
 		case XFS_ITEM_LOCKED:
@@ -527,16 +539,6 @@ xfsaild_push(
 	xfs_trans_ail_cursor_done(ailp, cur);
 	spin_unlock(&ailp->xa_lock);
 
-	if (flush_log) {
-		/*
-		 * If something we need to push out was pinned, then
-		 * push out the log so it will become unpinned and
-		 * move forward in the AIL.
-		 */
-		XFS_STATS_INC(xs_push_ail_flush);
-		xfs_log_force(mp, 0);
-	}
-
 	if (push_xfsbufd) {
 		/* we've got delayed write buffers to flush */
 		wake_up_process(mp->m_ddev_targp->bt_task);
@@ -547,6 +549,7 @@ out_done:
 	if (!count) {
 		/* We're past our target or empty, so idle */
 		ailp->xa_last_pushed_lsn = 0;
+		ailp->xa_log_flush = 0;
 
 		tout = 50;
 	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
@@ -565,9 +568,13 @@ out_done:
 		 * were stuck.
 		 *
 		 * Backoff a bit more to allow some I/O to complete before
-		 * continuing from where we were.
+		 * restarting from the start of the AIL. This prevents us
+		 * from spinning on the same items, and if they are pinned will
+		 * all the restart to issue a log force to unpin the stuck
+		 * items.
 		 */
 		tout = 20;
+		ailp->xa_last_pushed_lsn = 0;
 	}
 
 	return tout;
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index fe2e3cb..8c0c465 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -70,6 +70,7 @@ struct xfs_ail {
 	struct xfs_ail_cursor	xa_cursors;
 	spinlock_t		xa_lock;
 	xfs_lsn_t		xa_last_pushed_lsn;
+	int			xa_log_flush;
 };
 
 /*
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

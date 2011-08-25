Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P7HP3V172920 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 02:17:25 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD95C113358
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 00:17:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4NbChN4o7CrIJltB for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2011 00:17:23 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1QwUBk-00049V-0j
	for xfs@oss.sgi.com; Thu, 25 Aug 2011 17:17:20 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QwUBZ-0002v8-QZ
	for xfs@oss.sgi.com; Thu, 25 Aug 2011 17:17:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: reduce the number of log forces from tail pushing
Date: Thu, 25 Aug 2011 17:17:04 +1000
Message-Id: <1314256626-11136-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1314256626-11136-1-git-send-email-david@fromorbit.com>
References: <1314256626-11136-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_trans_ail.c  |   28 ++++++++++++++++------------
 fs/xfs/xfs_trans_priv.h |    1 +
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index c15aa29..dd966e0 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -372,12 +372,24 @@ xfs_ail_worker(
 	xfs_lsn_t		lsn;
 	xfs_lsn_t		target;
 	long			tout = 10;
-	int			flush_log = 0;
 	int			stuck = 0;
 	int			count = 0;
 	int			push_xfsbufd = 0;
 
+	/*
+	 * If last time we ran we encountered pinned items, force the log first,
+	 * wait for it and then push again.
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
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->xa_last_pushed_lsn);
 	if (!lip || XFS_FORCED_SHUTDOWN(mp)) {
@@ -391,6 +403,7 @@ xfs_ail_worker(
 
 	XFS_STATS_INC(xs_push_ail);
 
+
 	/*
 	 * While the item we are looking at is below the given threshold
 	 * try to flush it out. We'd like not to stop until we've at least
@@ -435,7 +448,7 @@ xfs_ail_worker(
 		case XFS_ITEM_PINNED:
 			XFS_STATS_INC(xs_push_ail_pinned);
 			stuck++;
-			flush_log = 1;
+			ailp->xa_log_flush++;
 			break;
 
 		case XFS_ITEM_LOCKED:
@@ -480,16 +493,6 @@ xfs_ail_worker(
 	xfs_trans_ail_cursor_done(ailp, &cur);
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
@@ -500,6 +503,7 @@ out_done:
 	if (!count) {
 		/* We're past our target or empty, so idle */
 		ailp->xa_last_pushed_lsn = 0;
+		ailp->xa_log_flush = 0;
 
 		/*
 		 * We clear the XFS_AIL_PUSHING_BIT first before checking
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 212946b..0a6eec6 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -71,6 +71,7 @@ struct xfs_ail {
 	struct delayed_work	xa_work;
 	xfs_lsn_t		xa_last_pushed_lsn;
 	unsigned long		xa_flags;
+	int			xa_log_flush;
 };
 
 #define XFS_AIL_PUSHING_BIT	0
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

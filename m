Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p786pSU5020215 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 01:51:28 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 647791EF844B
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2011 23:51:26 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fQFo7VFadZyfJylM for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2011 23:51:26 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1QqJgA-00028Z-Ae
	for xfs@oss.sgi.com; Mon, 08 Aug 2011 16:51:14 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QqJgA-0002qF-3b
	for xfs@oss.sgi.com; Mon, 08 Aug 2011 16:51:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: reduce the number of log forces from tail pushing
Date: Mon,  8 Aug 2011 16:51:11 +1000
Message-Id: <1312786271-10871-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1312786271-10871-1-git-send-email-david@fromorbit.com>
References: <1312786271-10871-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_trans_ail.c  |   18 +++++++++++++++++-
 fs/xfs/xfs_trans_priv.h |    1 +
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index c15aa29..7a74bca 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -377,6 +377,7 @@ xfs_ail_worker(
 	int			count = 0;
 	int			push_xfsbufd = 0;
 
+again:
 	spin_lock(&ailp->xa_lock);
 	target = ailp->xa_target;
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->xa_last_pushed_lsn);
@@ -392,6 +393,20 @@ xfs_ail_worker(
 	XFS_STATS_INC(xs_push_ail);
 
 	/*
+	 * If last time we ran we encountered pinned items, force the log first,
+	 * wait for it and then push again.
+	 */
+	if (ailp->xa_last_pushed_lsn == 0 &&
+	    ailp->xa_log_flush) {
+		ailp->xa_log_flush = 0;
+		xfs_trans_ail_cursor_done(ailp, &cur);
+		spin_unlock(&ailp->xa_lock);
+		XFS_STATS_INC(xs_push_ail_flush);
+		xfs_log_force(mp, SYNC_WAIT);
+		goto again;
+	}
+
+	/*
 	 * While the item we are looking at is below the given threshold
 	 * try to flush it out. We'd like not to stop until we've at least
 	 * tried to push on everything in the AIL with an LSN less than
@@ -435,7 +450,7 @@ xfs_ail_worker(
 		case XFS_ITEM_PINNED:
 			XFS_STATS_INC(xs_push_ail_pinned);
 			stuck++;
-			flush_log = 1;
+			ailp->xa_log_flush++;
 			break;
 
 		case XFS_ITEM_LOCKED:
@@ -500,6 +515,7 @@ out_done:
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

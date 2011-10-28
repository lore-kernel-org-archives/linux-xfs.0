Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3jtA145582 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47DC8203865
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:44 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HFAqdjCgBaswtISm for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:44 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHr-0003E9-Ne
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:43 +0000
Message-Id: <20111028100343.681567769@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:55:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 45/45] xfs: force the log in xfs_buf_wait_unpin
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs_buf_wait_unpin-force-log
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

For the log if we are waiting for a buffered to be unpinned for writing
it out.  Currently all synchronous callers already do this unless they
might never encounter a pinned buffer, and non-blocking writes already
have a check for the pincount.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_buf.c   |    5 +++++
 fs/xfs/xfs_dquot.c |    7 -------
 fs/xfs/xfs_qm.c    |   16 ----------------
 fs/xfs/xfs_sync.c  |   17 -----------------
 4 files changed, 5 insertions(+), 40 deletions(-)

Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2011-10-27 22:40:16.821171772 +0200
+++ xfs/fs/xfs/xfs_sync.c	2011-10-27 22:40:19.445176345 +0200
@@ -268,17 +268,7 @@ xfs_sync_fsdata(
 	struct xfs_buf		*bp;
 	int			error;
 
-	/*
-	 * If the buffer is pinned then push on the log so we won't get stuck
-	 * waiting in the write for someone, maybe ourselves, to flush the log.
-	 *
-	 * Even though we just pushed the log above, we did not have the
-	 * superblock buffer locked at that point so it can become pinned in
-	 * between there and here.
-	 */
 	bp = xfs_getsb(mp, 0);
-	if (xfs_buf_ispinned(bp))
-		xfs_log_force(mp, 0);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);
 	return error;
@@ -724,13 +714,6 @@ restart:
 		delay(2);
 		goto restart;
 	} else if (!error) {
-		/*
-		 * If the buffer is pinned then push on the log now so we
-		 * won't get stuck waiting in the write for too long.
-		 */
-		if (xfs_buf_ispinned(bp))
-			xfs_log_force(ip->i_mount, 0);
-
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
 	}
Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-10-27 22:40:16.210189457 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-10-27 22:40:19.445176345 +0200
@@ -936,6 +936,11 @@ xfs_buf_wait_unpin(
 	if (atomic_read(&bp->b_pin_count) == 0)
 		return;
 
+	/*
+	 * Give the log a push so we don't wait here too long.
+	 */
+	xfs_log_force(bp->b_target->bt_mount, 0);
+
 	add_wait_queue(&bp->b_waiters, &wait);
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-10-27 22:40:18.049202868 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-10-27 22:40:19.449175026 +0200
@@ -1143,13 +1143,6 @@ xfs_qm_dqpurge(
 		 */
 		error = xfs_qm_dqflush(dqp, &bp);
 		if (!error && bp) {
-			/*
-			 * If the buffer is pinned then push on the log so we
-			 * won't get stuck waiting in the write for too long.
-			 */
-			if (xfs_buf_ispinned(bp))
-				xfs_log_force(mp, 0);
-
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
 		}
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:18.049202868 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:19.453172157 +0200
@@ -388,7 +388,6 @@ xfs_qm_dqflush_all(
 	int			recl;
 	struct xfs_dquot	*dqp;
 	int			error = 0, error2;
-	int			pinned = 0;
 	LIST_HEAD		(buffer_list);
 
 	if (!q)
@@ -416,12 +415,6 @@ again:
 		mutex_unlock(&q->qi_dqlist_lock);
 		error = xfs_qm_dqflush(dqp, &bp);
 		if (!error && bp) {
-			/*
-			 * If the buffer is pinned then push on the log so we
-			 * won't get stuck waiting in the write for too long.
-			 */
-			if (xfs_buf_ispinned(bp))
-				pinned++;
 			xfs_buf_delwri_queue(bp, &buffer_list);
 			xfs_buf_relse(bp);
 		}
@@ -439,8 +432,6 @@ again:
 
 	mutex_unlock(&q->qi_dqlist_lock);
 out:
-	if (pinned)
-		xfs_log_force(mp, 0);
 	error2 = xfs_buf_delwri_submit(&buffer_list);
 	return error ? error : error2;
 }
@@ -1659,13 +1650,6 @@ xfs_qm_dqreclaim_one(
 			mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 			error = xfs_qm_dqflush(dqp, &bp);
 			if (!error && bp) {
-				/*
-				 * If the buffer is pinned then push on the
-				 * log so we won't get stuck waiting in the
-				 * write for too long.
-				 */
-				if (xfs_buf_ispinned(bp))
-					xfs_log_force(mp, 0);
 				xfs_buf_delwri_queue(bp, &buffer_list);
 				xfs_buf_relse(bp);
 			}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p462osWe173106 for <xfs@oss.sgi.com>; Thu, 5 May 2011 21:50:54 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EEFA1E1F002
	for <xfs@oss.sgi.com>; Thu,  5 May 2011 19:54:32 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9kCkuq7jZd1Niug6 for <xfs@oss.sgi.com>;
	Thu, 05 May 2011 19:54:32 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QIBBV-00017y-P0
	for xfs@oss.sgi.com; Fri, 06 May 2011 12:54:29 +1000
Received: from dave by disappointment with local (Exim 4.75)
	(envelope-from <dave@disappointment.disaster>) id 1QIBBO-0007PO-KO
	for xfs@oss.sgi.com; Fri, 06 May 2011 12:54:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: exit AIL push work correctly when AIL is empty
Date: Fri,  6 May 2011 12:54:05 +1000
Message-Id: <1304650448-28438-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1304650448-28438-1-git-send-email-david@fromorbit.com>
References: <1304650448-28438-1-git-send-email-david@fromorbit.com>
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

The recent conversion of the xfsaild functionality to a work queue
introduced a hard-to-hit log space grant hang. The main cause is a
regression where a work exit path fails to clear the PUSHING state
and recheck the target correctly.

Make both exit paths do the same PUSHING bit clearing and target
checking when the "no more work to be done" condition is hit.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_ail.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index acdb92f..226c58b 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -346,18 +346,20 @@ xfs_ail_delete(
  */
 STATIC void
 xfs_ail_worker(
-	struct work_struct *work)
+	struct work_struct	*work)
 {
-	struct xfs_ail	*ailp = container_of(to_delayed_work(work),
+	struct xfs_ail		*ailp = container_of(to_delayed_work(work),
 					struct xfs_ail, xa_work);
-	long		tout;
-	xfs_lsn_t	target =  ailp->xa_target;
-	xfs_lsn_t	lsn;
-	xfs_log_item_t	*lip;
-	int		flush_log, count, stuck;
-	xfs_mount_t	*mp = ailp->xa_mount;
+	xfs_mount_t		*mp = ailp->xa_mount;
 	struct xfs_ail_cursor	*cur = &ailp->xa_cursors;
-	int		push_xfsbufd = 0;
+	xfs_log_item_t		*lip;
+	xfs_lsn_t		lsn;
+	xfs_lsn_t		target = ailp->xa_target;
+	long			tout = 10;
+	int			flush_log = 0;
+	int			stuck = 0;
+	int			count = 0;
+	int			push_xfsbufd = 0;
 
 	spin_lock(&ailp->xa_lock);
 	xfs_trans_ail_cursor_init(ailp, cur);
@@ -368,8 +370,7 @@ xfs_ail_worker(
 		 */
 		xfs_trans_ail_cursor_done(ailp, cur);
 		spin_unlock(&ailp->xa_lock);
-		ailp->xa_last_pushed_lsn = 0;
-		return;
+		goto out_done;
 	}
 
 	XFS_STATS_INC(xs_push_ail);
@@ -386,7 +387,6 @@ xfs_ail_worker(
 	 * lots of contention on the AIL lists.
 	 */
 	lsn = lip->li_lsn;
-	flush_log = stuck = count = 0;
 	while ((XFS_LSN_CMP(lip->li_lsn, target) < 0)) {
 		int	lock_result;
 		/*
@@ -480,7 +480,7 @@ xfs_ail_worker(
 	}
 
 	/* assume we have more work to do in a short while */
-	tout = 10;
+out_done:
 	if (!count) {
 		/* We're past our target or empty, so idle */
 		ailp->xa_last_pushed_lsn = 0;
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

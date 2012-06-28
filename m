Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5SAqSpr021758 for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 05:52:28 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DH8VPrCBXfqVlmER for
	<xfs@oss.sgi.com>; Thu, 28 Jun 2012 03:52:27 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5SAqQYO022624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 06:52:27 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q5SAqPfq024895
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 06:52:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3] xfs: re-enable xfsaild idle mode and fix associated races
Date: Thu, 28 Jun 2012 06:52:56 -0400
Message-Id: <1340880776-45730-1-git-send-email-bfoster@redhat.com>
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

xfsaild idle mode logic currently leads to a couple hangs:

1.) If xfsaild is rescheduled in during an incremental scan
    (i.e., tout != 0) and the target has been updated since
    the previous run, we can hit the new target and go into
    idle mode with a still populated ail.
2.) A wake up is only issued when the target is pushed forward.
    The wake up can race with xfsaild if it is currently in the
    process of entering idle mode, causing future wake up
    events to be lost.

These hangs have been reproduced and verified as fixed by
running xfstests 273 in a loop on a slightly modified upstream
kernel. The kernel is modified to re-enable idle mode as
previously implemented (when count == 0) and with a revert of
commit 670ce93f, which includes performance improvements that
make this harder to reproduce.

The solution, the algorithm for which has been outlined by
Dave Chinner, is to modify xfsaild to enter idle mode only when
the ail is empty and the push target has not been moved forward
since the last push.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
Hi,

I haven't heard any further comments on v2 with regard to the
sleep logic being located in xfsaild(), so I've left it as is
and fixed a couple style issues for v3.

Brian

v3:
- Fix a couple style issues and elaborate on the idle mode
  comment based on Christoph Hellwig's review.
v2:
- Fixed up comments in xfsaild() based on Dave Chinner's
  review.

 fs/xfs/xfs_trans_ail.c  |   35 ++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trans_priv.h |    1 +
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 9c51448..6011ee6 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -383,6 +383,12 @@ xfsaild_push(
 	}
 
 	spin_lock(&ailp->xa_lock);
+
+	/* barrier matches the xa_target update in xfs_ail_push() */
+	smp_rmb();
+	target = ailp->xa_target;
+	ailp->xa_target_prev = target;
+
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->xa_last_pushed_lsn);
 	if (!lip) {
 		/*
@@ -397,7 +403,6 @@ xfsaild_push(
 	XFS_STATS_INC(xs_push_ail);
 
 	lsn = lip->li_lsn;
-	target = ailp->xa_target;
 	while ((XFS_LSN_CMP(lip->li_lsn, target) <= 0)) {
 		int	lock_result;
 
@@ -527,8 +532,32 @@ xfsaild(
 			__set_current_state(TASK_KILLABLE);
 		else
 			__set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(tout ?
-				 msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
+
+		spin_lock(&ailp->xa_lock);
+
+		/*
+		 * Idle if the AIL is empty and we are not racing with a target
+		 * update. We check the AIL after we set the task to a sleep
+		 * state to guarantee that we either catch an xa_target update
+		 * or that a wake_up resets the state to TASK_RUNNING.
+		 * Otherwise, we run the risk of sleeping indefinitely.
+		 *
+		 * The barrier matches the xa_target update in xfs_ail_push().
+		 */
+		smp_rmb();
+		if (!xfs_ail_min(ailp) &&
+		    ailp->xa_target == ailp->xa_target_prev) {
+			spin_unlock(&ailp->xa_lock);
+			schedule();
+			tout = 0;
+			continue;
+		}
+		spin_unlock(&ailp->xa_lock);
+
+		if (tout)
+			schedule_timeout(msecs_to_jiffies(tout));
+
+		__set_current_state(TASK_RUNNING);
 
 		try_to_freeze();
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index fb62377..53b7c9b 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -67,6 +67,7 @@ struct xfs_ail {
 	struct task_struct	*xa_task;
 	struct list_head	xa_ail;
 	xfs_lsn_t		xa_target;
+	xfs_lsn_t		xa_target_prev;
 	struct list_head	xa_cursors;
 	spinlock_t		xa_lock;
 	xfs_lsn_t		xa_last_pushed_lsn;
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

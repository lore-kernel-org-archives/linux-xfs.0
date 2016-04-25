Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 73F9A7CA0
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 02:42:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE0DAAC002
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 00:42:53 -0700 (PDT)
Received: from lynxeye.de (ns.lynxeye.de [87.118.118.114]) by cuda.sgi.com
	with ESMTP id bFyxlHSCWF4ftqBu for <xfs@oss.sgi.com>;
	Mon, 25 Apr 2016 00:42:50 -0700 (PDT)
From: Lucas Stach <dev@lynxeye.de>
Subject: [PATCH] xfs: idle aild if the AIL is pushed up to the target LSN
Date: Mon, 25 Apr 2016 09:42:43 +0200
Message-Id: <1461570163-4083-1-git-send-email-dev@lynxeye.de>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

The current logic only idles aild if the AIL is empty, rescheduling
the worker with a timeout of 50ms otherwise. If the target LSN isn't
moved forward, the worker will not make any progress as it only
pushes the AIL up to the target LSN, leading to the empty AIL
condition to only be met after the log worker pushed the complete
AIL. As the log worker runs on the scale of minutes, this leaves
aild in the "no progress, 50ms timeout" state for extended periods of
time, causing many unecessary wakeups.

Fix this by idling aild as soon as the AIL is pushed up to the target
LSN. All code paths that move the target LSN forward already ensure
that aild is woken up again when needed.

Signed-off-by: Lucas Stach <dev@lynxeye.de>
---
I'm pretty sure that the above deduction is correct, but as this my
first real encounter with the XFS code base, someone with a bit more
knowledge than me should give this some thought.
---
 fs/xfs/xfs_trans_ail.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index d6c9c3e..7eca852 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -495,6 +495,7 @@ xfsaild(
 {
 	struct xfs_ail	*ailp = data;
 	long		tout = 0;	/* milliseconds */
+	struct xfs_log_item *lip;
 
 	current->flags |= PF_MEMALLOC;
 	set_freezable();
@@ -508,7 +509,8 @@ xfsaild(
 		spin_lock(&ailp->xa_lock);
 
 		/*
-		 * Idle if the AIL is empty and we are not racing with a target
+		 * Idle if the AIL is empty or pushed up to the requested
+		 * target LSN and we are not racing with a target
 		 * update. We check the AIL after we set the task to a sleep
 		 * state to guarantee that we either catch an xa_target update
 		 * or that a wake_up resets the state to TASK_RUNNING.
@@ -517,7 +519,8 @@ xfsaild(
 		 * The barrier matches the xa_target update in xfs_ail_push().
 		 */
 		smp_rmb();
-		if (!xfs_ail_min(ailp) &&
+		lip = xfs_ail_min(ailp);
+		if ((!lip || XFS_LSN_CMP(lip->li_lsn, ailp->xa_target) >= 0) &&
 		    ailp->xa_target == ailp->xa_target_prev) {
 			spin_unlock(&ailp->xa_lock);
 			freezable_schedule();
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p462otoX173130 for <xfs@oss.sgi.com>; Thu, 5 May 2011 21:50:55 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0819C593DE
	for <xfs@oss.sgi.com>; Thu,  5 May 2011 19:54:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GyquYSnDJw46pJy4 for <xfs@oss.sgi.com>;
	Thu, 05 May 2011 19:54:33 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QIBBV-00018C-VF
	for xfs@oss.sgi.com; Fri, 06 May 2011 12:54:29 +1000
Received: from dave by disappointment with local (Exim 4.75)
	(envelope-from <dave@disappointment.disaster>) id 1QIBBO-0007PX-Pr
	for xfs@oss.sgi.com; Fri, 06 May 2011 12:54:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/5] xfs: fix race condition in AIL push trigger
Date: Fri,  6 May 2011 12:54:08 +1000
Message-Id: <1304650448-28438-6-git-send-email-david@fromorbit.com>
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
introduced a hard-to-hit log space grant hang. One is caused by a
race condition in determining whether there is a psh in progress or
not.

The XFS_AIL_PUSHING_BIT is used to determine whether a push is
currently in progress.  When the AIL push work completes, it checked
whether the target changed and cleared the PUSHING bit to allow a
new push to be requeued. The race condition is as follows:

	Thread 1		push work

	smp_wmb()
				smp_rmb()
				check ailp->xa_target unchanged
	update ailp->xa_target
	test/set PUSHING bit
	does not queue
				clear PUSHING bit
				does not requeue

Now that the push target is updated, new attempts to push the AIL
will not trigger as the push target will be the same, and hence
despite trying to push the AIL we won't ever wake it again.

The fix is to ensure that the AIL push work clears the PUSHING bit
before it checks if the target is unchanged.

As a result, both push triggers operate on the same test/set bit
criteria, so even if we race in the push work and miss the target
update, the thread requesting the push will still set the PUSHING
bit and queue the push work to occur. For safety sake, the same
queue check is done if the push work detects the target change,
though only one of the two will will queue new work due to the use
of test_and_set_bit() checks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_ail.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index d7eebbf..5fc2380 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -487,15 +487,19 @@ out_done:
 		ailp->xa_last_pushed_lsn = 0;
 
 		/*
-		 * Check for an updated push target before clearing the
-		 * XFS_AIL_PUSHING_BIT. If the target changed, we've got more
-		 * work to do. Wait a bit longer before starting that work.
+		 * We clear the XFS_AIL_PUSHING_BIT first before checking
+		 * whether the target has changed. If the target has changed,
+		 * this pushes the requeue race directly onto the result of the
+		 * atomic test/set bit, so we are guaranteed that either the
+		 * the pusher that changed the target or ourselves will requeue
+		 * the work (but not both).
 		 */
+		clear_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags);
 		smp_rmb();
-		if (XFS_LSN_CMP(ailp->xa_target, target) == 0) {
-			clear_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags);
+		if (XFS_LSN_CMP(ailp->xa_target, target) == 0 ||
+		    test_and_set_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags))
 			return;
-		}
+
 		tout = 50;
 	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
 		/*
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4WCFd158200 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:32:12 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B37B143FE32
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:34:01 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	0uNJp55QPV2c02Xj for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:34:01 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49888021-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:04:01 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS06p-000217-OL
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:33:59 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS05L-0004iY-L0
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:32:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/9] xfs: reduce the number of AIL push wakeups
Date: Mon, 13 Dec 2010 15:32:19 +1100
Message-Id: <1292214743-18073-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1292214743-18073-1-git-send-email-david@fromorbit.com>
References: <1292214743-18073-1-git-send-email-david@fromorbit.com>
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

The xfaild often tries to rest to wait for congestion to pass of for
IO to complete, but is regularly woken in tail-pushing situations.
In severe cases, the xfsaild is getting woken tens of thousands of
times a second. Reduce the number needless wakeups by only waking
the xfsaild if the new target is larger than the old one. Further
make short sleeps uninterruptible as they occur when the xfsaild has
decided it needs to back off to allow some IO to complete and being
woken early is counter-productive.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_super.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index abcda07..b49ad02 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -834,8 +834,11 @@ xfsaild_wakeup(
 	struct xfs_ail		*ailp,
 	xfs_lsn_t		threshold_lsn)
 {
-	ailp->xa_target = threshold_lsn;
-	wake_up_process(ailp->xa_task);
+	/* only ever move the target forwards */
+	if (XFS_LSN_CMP(threshold_lsn, ailp->xa_target) > 0) {
+		ailp->xa_target = threshold_lsn;
+		wake_up_process(ailp->xa_task);
+	}
 }
 
 STATIC int
@@ -847,8 +850,17 @@ xfsaild(
 	long		tout = 0; /* milliseconds */
 
 	while (!kthread_should_stop()) {
-		schedule_timeout_interruptible(tout ?
-				msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
+		/*
+		 * for short sleeps indicating congestion, don't allow us to
+		 * get woken early. Otherwise all we do is bang on the AIL lock
+		 * without making progress.
+		 */
+		if (tout && tout <= 20)
+			__set_current_state(TASK_KILLABLE);
+		else
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(tout ?
+				 msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
 
 		/* swsusp */
 		try_to_freeze();
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

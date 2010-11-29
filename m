Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1BVNp077037 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:11:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57EB31AF8FE
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:13:12 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	n6nYS6VVzkTQkKWx for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:13:12 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	47774563-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 11:43:11 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMsId-0000b3-QM
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:12:59 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMsIE-0005Us-Ev
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:12:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfs: reduce the number of AIL push wakeups
Date: Mon, 29 Nov 2010 12:12:28 +1100
Message-Id: <1290993152-20999-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1290993152-20999-1-git-send-email-david@fromorbit.com>
References: <1290993152-20999-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/linux-2.6/xfs_super.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 6cbebb2..8546805 100644
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

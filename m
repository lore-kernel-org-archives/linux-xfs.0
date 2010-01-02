Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o022kPcg052099 for <xfs@oss.sgi.com>; Fri, 1 Jan 2010 20:46:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E83611502C1C
	for <xfs@oss.sgi.com>; Fri,  1 Jan 2010 18:47:12 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	TKhQIDIni9D8cBHp for <xfs@oss.sgi.com>;
	Fri, 01 Jan 2010 18:47:12 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11047659-1927428
	for <xfs@oss.sgi.com>; Sat, 02 Jan 2010 13:17:12 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NQu1G-0007xD-7j
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 13:47:10 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NQtxr-00054J-EY
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 13:43:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] XFS: Don't wake the aild once per second
Date: Sat,  2 Jan 2010 13:43:34 +1100
Message-Id: <1262400215-19443-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1262400215-19443-1-git-send-email-david@fromorbit.com>
References: <1262400215-19443-1-git-send-email-david@fromorbit.com>
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

Now that the AIL push algorithm is traversal safe, we don't need a
watchdog function in the xfsaild to catch pushes that fail to make
progress. Remove the watchdog timeout and make pushes purely driven
by demand. This will remove the once-per-second wakeup that is seen
when the filesystem is idle and make laptop power misers happy.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    7 +++----
 fs/xfs/xfs_trans_ail.c       |   17 ++++++++++-------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 09783cc..84ce77a 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -877,12 +877,11 @@ xfsaild(
 {
 	struct xfs_ail	*ailp = data;
 	xfs_lsn_t	last_pushed_lsn = 0;
-	long		tout = 0;
+	long		tout = 1000; /* milliseconds */
 
 	while (!kthread_should_stop()) {
-		if (tout)
-			schedule_timeout_interruptible(msecs_to_jiffies(tout));
-		tout = 1000;
+		tout = !tout ? MAX_SCHEDULE_TIMEOUT : msecs_to_jiffies(tout);
+		schedule_timeout_interruptible(tout);
 
 		/* swsusp */
 		try_to_freeze();
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 2ffc570..8ca123e 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -237,14 +237,15 @@ out:
 }
 
 /*
- * Function that does the work of pushing on the AIL
+ * xfsaild_push does the work of pushing on the AIL.  Returning a timeout of
+ * zero indicates that the caller should sleep until woken.
  */
 long
 xfsaild_push(
 	struct xfs_ail	*ailp,
 	xfs_lsn_t	*last_lsn)
 {
-	long		tout = 1000; /* milliseconds */
+	long		tout = 0;
 	xfs_lsn_t	last_pushed_lsn = *last_lsn;
 	xfs_lsn_t	target =  ailp->xa_target;
 	xfs_lsn_t	lsn;
@@ -279,7 +280,6 @@ xfsaild_push(
 	 * prevents use from spinning when we can't do anything or there is
 	 * lots of contention on the AIL lists.
 	 */
-	tout = 10;
 	lsn = lip->li_lsn;
 	flush_log = stuck = count = 0;
 	while ((XFS_LSN_CMP(lip->li_lsn, target) < 0)) {
@@ -376,14 +376,14 @@ xfsaild_push(
 
 	if (!count) {
 		/* We're past our target or empty, so idle */
-		tout = 1000;
+		tout = 0;
 	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
 		/*
 		 * We reached the target so wait a bit longer for I/O to
 		 * complete and remove pushed items from the AIL before we
 		 * start the next scan from the start of the AIL.
 		 */
-		tout += 20;
+		tout = 50;
 		last_pushed_lsn = 0;
 	} else if ((stuck * 100) / count > 90) {
 		/*
@@ -395,11 +395,14 @@ xfsaild_push(
 		 * Backoff a bit more to allow some I/O to complete before
 		 * continuing from where we were.
 		 */
-		tout += 10;
+		tout = 20;
+	} else {
+		/* more to do, but wait a short while before continuing */
+		tout = 10;
 	}
 	*last_lsn = last_pushed_lsn;
 	return tout;
-}	/* xfsaild_push */
+}
 
 
 /*
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

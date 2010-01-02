Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o022kOTx052091 for <xfs@oss.sgi.com>; Fri, 1 Jan 2010 20:46:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 169AA1DAB3C8
	for <xfs@oss.sgi.com>; Fri,  1 Jan 2010 18:47:12 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	IYEG2Q5Z0pxU1H20 for <xfs@oss.sgi.com>;
	Fri, 01 Jan 2010 18:47:12 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11047658-1927428
	for <xfs@oss.sgi.com>; Sat, 02 Jan 2010 13:17:11 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NQu1G-0007xE-9b
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 13:47:10 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NQtxr-00054L-HW
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 13:43:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] XFS: Don't wake xfsbufd when idle
Date: Sat,  2 Jan 2010 13:43:35 +1100
Message-Id: <1262400215-19443-3-git-send-email-david@fromorbit.com>
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

The xfsbufd wakes every xfsbufd_centisecs (once per second by
default) for each filesystem even when the filesystem is idle.
If the xfsbufd has nothing to do, put it into a long term sleep
and only wake it up when there is work pending (i.e. dirty
buffers to flush soon). This will make laptop power misers happy.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 77b8be8..759cbaf 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -43,10 +43,10 @@
 
 static kmem_zone_t *xfs_buf_zone;
 STATIC int xfsbufd(void *);
-STATIC int xfsbufd_wakeup(int, gfp_t);
+STATIC int xfsbufd_wakeup_all(int, gfp_t);
 STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
 static struct shrinker xfs_buf_shake = {
-	.shrink = xfsbufd_wakeup,
+	.shrink = xfsbufd_wakeup_all,
 	.seeks = DEFAULT_SEEKS,
 };
 
@@ -385,7 +385,7 @@ _xfs_buf_lookup_pages(
 					__func__, gfp_mask);
 
 			XFS_STATS_INC(xb_page_retries);
-			xfsbufd_wakeup(0, gfp_mask);
+			xfsbufd_wakeup_all(0, gfp_mask);
 			congestion_wait(BLK_RW_ASYNC, HZ/50);
 			goto retry;
 		}
@@ -1595,6 +1595,11 @@ xfs_buf_delwri_queue(
 		list_del(&bp->b_list);
 	}
 
+	if (list_empty(dwq)) {
+		/* start xfsbufd as it has something to do now */
+		wake_up_process(bp->b_target->bt_task);
+	}
+
 	bp->b_flags |= _XBF_DELWRI_Q;
 	list_add_tail(&bp->b_list, dwq);
 	bp->b_queuetime = jiffies;
@@ -1634,7 +1639,7 @@ xfs_buf_runall_queues(
 }
 
 STATIC int
-xfsbufd_wakeup(
+xfsbufd_wakeup_all(
 	int			priority,
 	gfp_t			mask)
 {
@@ -1644,6 +1649,8 @@ xfsbufd_wakeup(
 	list_for_each_entry(btp, &xfs_buftarg_list, bt_list) {
 		if (test_bit(XBT_FORCE_SLEEP, &btp->bt_flags))
 			continue;
+		if (list_empty(&btp->bt_delwrite_queue))
+			continue;
 		set_bit(XBT_FORCE_FLUSH, &btp->bt_flags);
 		wake_up_process(btp->bt_task);
 	}
@@ -1708,6 +1715,9 @@ xfsbufd(
 	set_freezable();
 
 	do {
+		long	age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
+		long	tout = age;
+
 		if (unlikely(freezing(current))) {
 			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
 			refrigerator();
@@ -1715,12 +1725,12 @@ xfsbufd(
 			clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
 		}
 
-		schedule_timeout_interruptible(
-			xfs_buf_timer_centisecs * msecs_to_jiffies(10));
-
-		xfs_buf_delwri_split(target, &tmp,
-				xfs_buf_age_centisecs * msecs_to_jiffies(10));
+		/* sleep for a long time if there is nothing to do. */
+		if (list_empty(&target->bt_delwrite_queue))
+			tout = MAX_SCHEDULE_TIMEOUT;
+		schedule_timeout_interruptible(tout);
 
+		xfs_buf_delwri_split(target, &tmp, age);
 		count = 0;
 		while (!list_empty(&tmp)) {
 			bp = list_entry(tmp.next, xfs_buf_t, b_list);
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

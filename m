Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BBrNDn138152 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 05:53:24 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA1B11357F87
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 03:54:17 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	fEcfI6AM2TIPFMwL for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 03:54:17 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11397740-1927428
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:24:16 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUIqd-0003fo-GC
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:54:15 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUImb-0006qd-A3
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:50:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] XFS: Don't wake xfsbufd when idle
Date: Mon, 11 Jan 2010 22:49:59 +1100
Message-Id: <1263210599-25067-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1263210599-25067-1-git-send-email-david@fromorbit.com>
References: <1263210599-25067-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/linux-2.6/xfs_buf.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 77b8be8..b51be4e 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1595,6 +1595,11 @@ xfs_buf_delwri_queue(
 		list_del(&bp->b_list);
 	}
 
+	if (list_empty(dwq)) {
+		/* start xfsbufd as it is about to have something to do */
+		wake_up_process(bp->b_target->bt_task);
+	}
+
 	bp->b_flags |= _XBF_DELWRI_Q;
 	list_add_tail(&bp->b_list, dwq);
 	bp->b_queuetime = jiffies;
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

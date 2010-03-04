Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o241jGnQ126534 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 19:45:16 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B563215BE0
	for <xfs@oss.sgi.com>; Wed,  3 Mar 2010 17:46:42 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	VI85JMuqbHPfnAe7 for <xfs@oss.sgi.com>;
	Wed, 03 Mar 2010 17:46:42 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	15909981-1927428
	for <xfs@oss.sgi.com>; Thu, 04 Mar 2010 12:16:41 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1Nn095-0004aT-M9
	for xfs@oss.sgi.com; Thu, 04 Mar 2010 12:46:35 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nn08y-000230-1m
	for xfs@oss.sgi.com; Thu, 04 Mar 2010 12:46:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: check for more work before sleeping in xfssyncd
Date: Thu,  4 Mar 2010 12:46:23 +1100
Message-Id: <1267667185-7736-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1267667185-7736-1-git-send-email-david@fromorbit.com>
References: <1267667185-7736-1-git-send-email-david@fromorbit.com>
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

xfssyncd processes a queue of work by detaching the queue and
then iterating over all the work items. It then sleeps for a
time period or until new work comes in. If new work is queued
while xfssyncd is actively processing the detached work queue,
it will not process that new work until after a sleep timeout
or the next work event queued wakes it.

Fix this by checking the work queue again before going to sleep.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index f9fc154..05cd853 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -607,7 +607,8 @@ xfssyncd(
 	set_freezable();
 	timeleft = xfs_syncd_centisecs * msecs_to_jiffies(10);
 	for (;;) {
-		timeleft = schedule_timeout_interruptible(timeleft);
+		if (list_empty(&mp->m_sync_list))
+			timeleft = schedule_timeout_interruptible(timeleft);
 		/* swsusp */
 		try_to_freeze();
 		if (kthread_should_stop() && list_empty(&mp->m_sync_list))
@@ -627,8 +628,7 @@ xfssyncd(
 			list_add_tail(&mp->m_sync_work.w_list,
 					&mp->m_sync_list);
 		}
-		list_for_each_entry_safe(work, n, &mp->m_sync_list, w_list)
-			list_move(&work->w_list, &tmp);
+		list_splice_init(&mp->m_sync_list, &tmp);
 		spin_unlock(&mp->m_sync_lock);
 
 		list_for_each_entry_safe(work, n, &tmp, w_list) {
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

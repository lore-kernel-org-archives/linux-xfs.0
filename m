Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D6Pvag199516 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 01:25:57 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4263C2BAC5E
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 23:27:51 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	FZdjPlh33h1xsUzK for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 23:27:51 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] [PATCH] xfs: check for more work before sleeping in
	xfssyncd
Date: Tue, 13 Apr 2010 16:27:32 +1000
Message-Id: <1271140052-15365-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1271140052-15365-1-git-send-email-david@fromorbit.com>
References: <1271140052-15365-1-git-send-email-david@fromorbit.com>
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
To: stable@kernel.org
Cc: xfs@oss.sgi.com

>From 20f6b2c785cf187445f126321638ab8ba7aa7494 Thu, 4 Mar 2010 01:46:23 +0000

xfssyncd processes a queue of work by detaching the queue and
then iterating over all the work items. It then sleeps for a
time period or until new work comes in. If new work is queued
while xfssyncd is actively processing the detached work queue,
it will not process that new work until after a sleep timeout
or the next work event queued wakes it.

Fix this by checking the work queue again before going to sleep.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 687e9fc..6b6b394 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -613,7 +613,8 @@ xfssyncd(
 	set_freezable();
 	timeleft = xfs_syncd_centisecs * msecs_to_jiffies(10);
 	for (;;) {
-		timeleft = schedule_timeout_interruptible(timeleft);
+		if (list_empty(&mp->m_sync_list))
+			timeleft = schedule_timeout_interruptible(timeleft);
 		/* swsusp */
 		try_to_freeze();
 		if (kthread_should_stop() && list_empty(&mp->m_sync_list))
@@ -633,8 +634,7 @@ xfssyncd(
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

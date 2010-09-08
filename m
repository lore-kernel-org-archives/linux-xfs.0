Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o888xn28023878 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 03:59:49 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DFCADA4A9D
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 02:11:44 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	pJ3gjyBYloZOdSmz for <xfs@oss.sgi.com>;
	Wed, 08 Sep 2010 02:11:44 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	26659253-1927428
	for <xfs@oss.sgi.com>; Wed, 08 Sep 2010 18:30:30 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OtGW5-0003YW-7t
	for xfs@oss.sgi.com; Wed, 08 Sep 2010 19:00:29 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OtGVy-0005Fe-AD
	for xfs@oss.sgi.com; Wed, 08 Sep 2010 19:00:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: log IO completion workqueue is a high priority queue
Date: Wed,  8 Sep 2010 19:00:22 +1000
Message-Id: <1283936422-20160-1-git-send-email-david@fromorbit.com>
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

The workqueue implementation in 2.6.36-rcX has changed, resulting in the
workqueues no longer having dedicated threads for work processing. This has
caused severe livelocks under heavy parallel create workloads because the
log IO completions have been getting held up behind metadata IO completions.
Hence log commits would stall, memory allocation would stall because pages
could not be cleaned, and lock contention on the AIL during inode IO completion
processing was being seen to slow everything down even further.

By making the log Io completion workqueue a high priority workqueue, they are
queued ahead of all data/metadata IO completions and processed before the
data/metadata completions. Hence the log never gets stalled, and operations
needed to clean memory can continue as quickly as possible. This avoids the
livelock conditions and allos the system to keep running under heavy load as
per normal.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 6130828..2a6645f 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1956,7 +1956,8 @@ xfs_buf_init(void)
 	if (!xfs_buf_zone)
 		goto out;
 
-	xfslogd_workqueue = create_workqueue("xfslogd");
+	xfslogd_workqueue = alloc_workqueue("xfslogd",
+					WQ_RESCUER | WQ_HIGHPRI, 1);
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

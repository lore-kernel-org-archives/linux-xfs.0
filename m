Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6AD8B7F57
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:51:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 10895AC003
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:51:35 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5r6dcALtSwsUiYzY for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 01:51:34 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WIxcb-0007bo-Ab
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:51:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WIxcb-0007sH-9V
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:51:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/10] repair: fix prefetch queue limiting
Date: Thu, 27 Feb 2014 20:51:11 +1100
Message-Id: <1393494675-30194-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1393494675-30194-1-git-send-email-david@fromorbit.com>
References: <1393494675-30194-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The length of the prefetch queue is limited by a semaphore. To avoid
a ABBA deadlock, we only trywait on the semaphore so if we fail to
get it we can kick the IO queues before sleeping. Unfortunately,
the "need to sleep" detection is just a little wrong - it needs to
lok at errno, not err for the EAGAIN value.

Hence this queue throttling has not been working for a long time.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase6.c   | 9 ++++++++-
 repair/prefetch.c | 2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 7be68b3..63359d1 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2999,8 +2999,15 @@ traverse_function(
 		if (irec->ino_isa_dir == 0)
 			continue;
 
-		if (pf_args)
+		if (pf_args) {
 			sem_post(&pf_args->ra_count);
+#ifdef XR_PF_TRACE
+			sem_getvalue(&pf_args->ra_count, &i);
+			pftrace(
+		"processing inode chunk %p in AG %d (sem count = %d)",
+				irec, agno, i);
+#endif
+		}
 
 		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
 			if (inode_isadir(irec, i))
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 984beda..f4f3d71 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -723,7 +723,7 @@ pf_queuing_worker(
 			irec, args->agno, i);
 #endif
 		err = sem_trywait(&args->ra_count);
-		if (err == EAGAIN) {
+		if (err < 0 && errno == EAGAIN) {
 			/*
 			 * Kick the queue once we have reached the limit;
 			 * without this the threads processing the inodes
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

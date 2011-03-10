Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2A03mg7068892 for <xfs@oss.sgi.com>; Wed, 9 Mar 2011 18:03:54 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E52D1333C45
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2011 16:06:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Fa9cIOTgJx0s4QZ9 for <xfs@oss.sgi.com>;
	Wed, 09 Mar 2011 16:06:37 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PxTNn-0002vT-0c
	for xfs@oss.sgi.com; Thu, 10 Mar 2011 11:05:35 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PxTNk-0002tC-Vp
	for xfs@oss.sgi.com; Thu, 10 Mar 2011 11:05:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: introduce background inode reclaim work
Date: Thu, 10 Mar 2011 11:05:27 +1100
Message-Id: <1299715529-11026-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1299715529-11026-1-git-send-email-david@fromorbit.com>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
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

Background inode reclaim needs to run more frequently that the XFS
syncd work is run as 30s is too long between optimal reclaim runs.
Add a new periodic work item to the xfs syncd workqueue to run a
fast, non-blocking inode reclaim scan.

To make memory reclaim based inode reclaim throttle to inode
cleaning but still reclaim inodes efficiently, make it kick the
background inode reclaim so that when we are low on memory we are
trying to reclaim inodes as efficiently as possible. To contrast
this, make the shrinker past do synchronous inode reclaim so that it
blocks on inodes under IO. This means that the shrinker will reclaim
inodes rather than just skipping over them, but it does not
adversely affect the rate of reclaim because most dirty inodes are
already under IO due to the background reclaim work the shrinker
kicked.

These two modifications solve one of the two OOM killer invocations
Chris Mason reported recently when running a stress testing script.
The particular workload trigger for the OOM killer invocation is
where there are more threads than CPUs all unlinking files in an
extremely memory constrained environment. Unlike other solutions,
this one does not have a performance impact on performance when
memory is not constrained or the number of concurrent threads
operating is <= to the number of CPUs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   56 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_mount.h          |    1 +
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 62e1f09..3f39d83 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -470,6 +470,44 @@ xfs_sync_worker(
 }
 
 /*
+ * Queue a new inode reclaim pass if there isn't one already in progress.
+ * Wait for completion of the flush if necessary.
+ */
+static void
+xfs_syncd_queue_reclaim(
+	struct xfs_mount        *mp)
+{
+	queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
+			xfs_syncd_centisecs / 5 * msecs_to_jiffies(10));
+}
+
+/*
+ * This is a fast pass over the inode cache to try to get reclaim moving on as
+ * many inodes as possible in a short period of time. It kicks itself every few
+ * seconds, as well as being kicked by the inode cache shrinker when memory
+ * goes low.
+ */
+STATIC void
+xfs_reclaim_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_reclaim_work);
+
+	/* first unpin all the dirty and stale inodes. */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
+	/*
+	 * now scan as quickly as possible, not getting hung up on locked
+	 * inodes or those that are already flushing.
+	 */
+	xfs_reclaim_inodes(mp, SYNC_TRYLOCK);
+
+	/* queue us up again */
+	xfs_syncd_queue_reclaim(mp);
+}
+
+/*
  * Flush delayed allocate data, attempting to free up reserved space
  * from existing allocations.  At this point a new allocation attempt
  * has failed with ENOSPC and we are in the process of scratching our
@@ -509,7 +547,10 @@ xfs_syncd_init(
 {
 	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
 	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
+	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+
 	xfs_syncd_queue_sync(mp);
+	xfs_syncd_queue_reclaim(mp);
 
 	return 0;
 }
@@ -519,6 +560,7 @@ xfs_syncd_stop(
 	struct xfs_mount	*mp)
 {
 	cancel_delayed_work_sync(&mp->m_sync_work);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	cancel_work_sync(&mp->m_flush_work);
 }
 
@@ -954,7 +996,13 @@ xfs_reclaim_inodes(
 }
 
 /*
- * Shrinker infrastructure.
+ * Inode cache shrinker.
+ *
+ * When called we make sure that there is a background (fast) inode reclaim in
+ * progress, while we will throttle the speed of reclaim via doiing synchronous
+ * reclaim of inodes. That means if we come across dirty inodes, we wait for
+ * them to be cleaned, which we hope will not be very long due to the
+ * background walker having already kicked the IO off on those dirty inodes.
  */
 static int
 xfs_reclaim_inode_shrink(
@@ -969,10 +1017,14 @@ xfs_reclaim_inode_shrink(
 
 	mp = container_of(shrink, struct xfs_mount, m_inode_shrink);
 	if (nr_to_scan) {
+		/* kick background reclaimer */
+		xfs_syncd_queue_reclaim(mp);
+
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
 
-		xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
+		xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT,
+					&nr_to_scan);
 		/* terminate if we don't exhaust the scan */
 		if (nr_to_scan > 0)
 			return -1;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a0ad90e..19af0ab 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -204,6 +204,7 @@ typedef struct xfs_mount {
 #endif
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_sync_work;	/* background sync work */
+	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct work_struct	m_flush_work;	/* background inode flush */
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

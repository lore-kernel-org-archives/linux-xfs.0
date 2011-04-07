Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p371sU6O067079 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 20:54:30 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8781AB91A98
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 18:57:45 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	X8aSxcRp8yXxtDPo for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 18:57:45 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q7eTN-00063L-Sx
	for xfs@oss.sgi.com; Thu, 07 Apr 2011 11:57:25 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q7eTQ-00079j-HY
	for xfs@oss.sgi.com; Thu, 07 Apr 2011 11:57:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/9] xfs: introduce background inode reclaim work
Date: Thu,  7 Apr 2011 11:57:20 +1000
Message-Id: <1302141445-27457-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1302141445-27457-1-git-send-email-david@fromorbit.com>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
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

Background inode reclaim is kicked by the act of marking inodes for
reclaim.  When an AG is first marked as having reclaimable inodes,
the background reclaim work is kicked. It will continue to run
periodically untill it detects that there are no more reclaimable
inodes. It will be kicked again when the first inode is queued for
reclaim.

To ensure shrinker based inode reclaim throttles to the inode
cleaning and reclaim rate but still reclaim inodes efficiently, make it kick the
background inode reclaim so that when we are low on memory we are
trying to reclaim inodes as efficiently as possible. This kick shoul
d not be necessary, but it will protect against failures to kick the
background reclaim when inodes are first dirtied.

To provide the rate throttling, make the shrinker pass do
synchronous inode reclaim so that it blocks on inodes under IO. This
means that the shrinker will reclaim inodes rather than just
skipping over them, but it does not adversely affect the rate of
reclaim because most dirty inodes are already under IO due to the
background reclaim work the shrinker kicked.

These two modifications solve one of the two OOM killer invocations
Chris Mason reported recently when running a stress testing script.
The particular workload trigger for the OOM killer invocation is
where there are more threads than CPUs all unlinking files in an
extremely memory constrained environment. Unlike other solutions,
this one does not have a performance impact on performance when
memory is not constrained or the number of concurrent threads
operating is <= to the number of CPUs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_sync.c |   69 +++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_mount.h          |    1 +
 2 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index af32759..debe282 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -461,7 +461,6 @@ xfs_sync_worker(
 			error = xfs_fs_log_dummy(mp);
 		else
 			xfs_log_force(mp, 0);
-		xfs_reclaim_inodes(mp, 0);
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 	}
 
@@ -470,6 +469,52 @@ xfs_sync_worker(
 }
 
 /*
+ * Queue a new inode reclaim pass if there are reclaimable inodes and there
+ * isn't a reclaim pass already in progress. By default it runs every 5s based
+ * on the xfs syncd work default of 30s. Perhaps this should have it's own
+ * tunable, but that can be done if this method proves to be ineffective or too
+ * aggressive.
+ */
+static void
+xfs_syncd_queue_reclaim(
+	struct xfs_mount        *mp)
+{
+
+	/*
+	 * We can have inodes enter reclaim after we've shut down the syncd
+	 * workqueue during unmount, so don't allow reclaim work to be queued
+	 * during unmount.
+	 */
+	if (!(mp->m_super->s_flags & MS_ACTIVE))
+		return;
+
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
+		queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
+			msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
+	}
+	rcu_read_unlock();
+}
+
+/*
+ * This is a fast pass over the inode cache to try to get reclaim moving on as
+ * many inodes as possible in a short period of time. It kicks itself every few
+ * seconds, as well as being kicked by the inode cache shrinker when memory
+ * goes low. It scans as quickly as possible avoiding locked inodes or those
+ * already being flushed, and once done schedules a future pass.
+ */
+STATIC void
+xfs_reclaim_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_reclaim_work);
+
+	xfs_reclaim_inodes(mp, SYNC_TRYLOCK);
+	xfs_syncd_queue_reclaim(mp);
+}
+
+/*
  * Flush delayed allocate data, attempting to free up reserved space
  * from existing allocations.  At this point a new allocation attempt
  * has failed with ENOSPC and we are in the process of scratching our
@@ -508,7 +553,10 @@ xfs_syncd_init(
 {
 	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
 	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
+	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+
 	xfs_syncd_queue_sync(mp);
+	xfs_syncd_queue_reclaim(mp);
 
 	return 0;
 }
@@ -518,6 +566,7 @@ xfs_syncd_stop(
 	struct xfs_mount	*mp)
 {
 	cancel_delayed_work_sync(&mp->m_sync_work);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	cancel_work_sync(&mp->m_flush_work);
 }
 
@@ -537,6 +586,10 @@ __xfs_inode_set_reclaim_tag(
 				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
 				XFS_ICI_RECLAIM_TAG);
 		spin_unlock(&ip->i_mount->m_perag_lock);
+
+		/* schedule periodic background inode reclaim */
+		xfs_syncd_queue_reclaim(ip->i_mount);
+
 		trace_xfs_perag_set_reclaim(ip->i_mount, pag->pag_agno,
 							-1, _RET_IP_);
 	}
@@ -953,7 +1006,13 @@ xfs_reclaim_inodes(
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
@@ -968,10 +1027,14 @@ xfs_reclaim_inode_shrink(
 
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

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EAu6BW121096 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:56:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E32031E6530B
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 03:56:53 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	aHDEjfOrEGvPjaxD for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 03:56:53 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	38830800-1927428
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 20:26:51 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OvTBn-0004OJ-2O
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:39 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OvTBa-0000Pq-LW
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/18] xfs: single thread inode cache shrinking.
Date: Tue, 14 Sep 2010 20:56:00 +1000
Message-Id: <1284461777-1496-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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

Having multiple CPUs trying to do the same cache shrinking work can
be actively harmful to perforamnce when the shrinkers land in the
same AGs.  They then lockstep on perag locks, causing contention and
slowing each other down. Reclaim walking is sufficiently efficient
that we do no need parallelism to make significant progress, so stop
parallel access at the door.

Instead, keep track of the number of objects the shrinkers want
cleaned and make sure the single running shrinker does not stop
until it has hit the threshold that the other shrinker calls have
built up.

This increases the cold-cache unlink rate of a 8-way parallel unlink
workload from about 15,000 unlinks/s to 60-70,000 unlinks/s for the
same CPU usage (~700%), resulting in the runtime for a 200M inode
unlink workload dropping from 4h50m to just under 1 hour.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_sync.c |   21 +++++++++++++++++++--
 fs/xfs/xfs_mount.h          |    2 ++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index d59c4a6..bc54cd6 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -869,7 +869,9 @@ xfs_reclaim_inodes(
 }
 
 /*
- * Shrinker infrastructure.
+ * Shrinker infrastructure. We allow filesystem reclaim recursion here because
+ * we trylock everything in the reclaim path and hence will not deadlock with
+ * locks that may already be held through direct reclaim.
  */
 static int
 xfs_reclaim_inode_shrink(
@@ -883,12 +885,25 @@ xfs_reclaim_inode_shrink(
 	int		reclaimable;
 
 	mp = container_of(shrink, struct xfs_mount, m_inode_shrink);
+
 	if (nr_to_scan) {
-		if (!(gfp_mask & __GFP_FS))
+		int64_t scan_cnt;
+
+		if (!mutex_trylock(&mp->m_ino_shrink_lock)) {
+			atomic64_add(nr_to_scan, &mp->m_ino_shrink_nr);
 			return -1;
+		}
 
+		do {
+			scan_cnt = atomic64_read(&mp->m_ino_shrink_nr);
+		} while (scan_cnt !=
+			atomic64_cmpxchg(&mp->m_ino_shrink_nr, scan_cnt, 0));
+
+		nr_to_scan += scan_cnt;
 		xfs_inode_ag_iterator(mp, xfs_reclaim_inode, 0,
 					XFS_ICI_RECLAIM_TAG, 1, &nr_to_scan);
+		mutex_unlock(&mp->m_ino_shrink_lock);
+
 		/* if we don't exhaust the scan, don't bother coming back */
 		if (nr_to_scan > 0)
 			return -1;
@@ -910,6 +925,8 @@ xfs_inode_shrinker_register(
 {
 	mp->m_inode_shrink.shrink = xfs_reclaim_inode_shrink;
 	mp->m_inode_shrink.seeks = DEFAULT_SEEKS;
+	atomic64_set(&mp->m_ino_shrink_nr, 0);
+	mutex_init(&mp->m_ino_shrink_lock);
 	register_shrinker(&mp->m_inode_shrink);
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 622da21..57b5644 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -199,6 +199,8 @@ typedef struct xfs_mount {
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
+	atomic64_t		m_ino_shrink_nr;
+	struct mutex		m_ino_shrink_lock;
 } xfs_mount_t;
 
 /*
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

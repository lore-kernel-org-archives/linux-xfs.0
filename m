Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OCUhvj180938 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 07:30:43 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4ED41BAB3EB
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 05:31:37 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	DmOMlBkVIdUd9n6B for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 05:31:37 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40309808-1927428
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 22:01:36 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Oz7R8-0007VM-TF
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:34 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1Oz7R4-00060a-Ly
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/18] xfs: serialise inode reclaim within an AG
Date: Fri, 24 Sep 2010 22:31:14 +1000
Message-Id: <1285331476-23015-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1285331476-23015-1-git-send-email-david@fromorbit.com>
References: <1285331476-23015-1-git-send-email-david@fromorbit.com>
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

Memory reclaim via shrinkers has a terrible habit of having N+M
concurrent shrinker executions (N = num CPUs, M = num kswapds) all
trying to shrink the same cache. When the cache they are all working
on is protected by a single spinlock, massive contention an
slowdowns occur.

Wrap the per-ag inode caches with a reclaim mutex to serialise
reclaim access to the AG. This will block concurrent reclaim in each
AG but still allow reclaim to scan multiple AGs concurrently. Allow
shrinkers to move on to the next AG if it can't get the lock, and if
we can't get any AG, then start blocking on locks.

To prevent reclaimers from continually scanning the same inodes in
each AG, add a cursor that tracks where the last reclaim got up to
and start from that point on the next reclaim. This should avoid
only ever scanning a small number of inodes at the satart of each AG
and not making progress. If we have a non-shrinker based reclaim
pass, ignore the cursor and reset it to zero once we are done.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   24 ++++++++++++++++++++++++
 fs/xfs/xfs_ag.h             |    2 ++
 fs/xfs/xfs_mount.c          |    1 +
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index c0c09e9..7d6f312 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -828,7 +828,9 @@ xfs_reclaim_inodes_ag(
 	int			error = 0;
 	int			last_error = 0;
 	xfs_agnumber_t		ag;
+	int			trylock = !!(flags & SYNC_TRYLOCK);
 
+restart:
 	ag = 0;
 	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
 		unsigned long	first_index = 0;
@@ -837,6 +839,17 @@ xfs_reclaim_inodes_ag(
 
 		ag = pag->pag_agno + 1;
 
+		if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
+			if (trylock) {
+				trylock++;
+				continue;
+			}
+			mutex_lock(&pag->pag_ici_reclaim_lock);
+		}
+
+		if (trylock)
+			first_index = pag->pag_ici_reclaim_cursor;
+
 		do {
 			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
 			int	i;
@@ -889,8 +902,19 @@ xfs_reclaim_inodes_ag(
 
 		} while (nr_found && !done && *nr_to_scan > 0);
 
+		pag->pag_ici_reclaim_cursor = (done || !trylock) ? 0 : first_index;
+		mutex_unlock(&pag->pag_ici_reclaim_lock);
 		xfs_perag_put(pag);
 	}
+
+	/*
+	 * if we skipped any AG, and we still have scan count remaining, do
+	 * another pass this time waiting on the reclaim locks.
+	 */
+	if (trylock > 1 && *nr_to_scan) {
+		trylock = 0;
+		goto restart;
+	}
 	return XFS_ERROR(last_error);
 }
 
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 51c42c2..baeec83 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -230,6 +230,8 @@ typedef struct xfs_perag {
 	rwlock_t	pag_ici_lock;	/* incore inode lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
+	struct mutex	pag_ici_reclaim_lock;	/* serialisation point */
+	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
 	/* for rcu-safe freeing */
 	struct rcu_head	rcu_head;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d66e87c..59859c3 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -477,6 +477,7 @@ xfs_initialize_perag(
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
 		rwlock_init(&pag->pag_ici_lock);
+		mutex_init(&pag->pag_ici_reclaim_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 
 		if (radix_tree_preload(GFP_NOFS))
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

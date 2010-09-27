Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8R1lVGO150768 for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 20:47:32 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4299CE7934F
	for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 19:01:20 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	D7aYUzeaMjRuRnmR for <xfs@oss.sgi.com>;
	Sun, 26 Sep 2010 19:01:20 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	28957937-1927428
	for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 11:18:26 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1P02pC-0002t6-OQ
	for xfs@oss.sgi.com; Mon, 27 Sep 2010 11:48:14 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1P02p6-0003qI-2l
	for xfs@oss.sgi.com; Mon, 27 Sep 2010 11:48:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/18] xfs: serialise inode reclaim within an AG
Date: Mon, 27 Sep 2010 11:47:51 +1000
Message-Id: <1285552073-14663-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1285552073-14663-1-git-send-email-david@fromorbit.com>
References: <1285552073-14663-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/linux-2.6/xfs_sync.c |   30 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_ag.h             |    2 ++
 fs/xfs/xfs_mount.c          |    1 +
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index f8e0644..d66e162 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -828,8 +828,12 @@ xfs_reclaim_inodes_ag(
 	int			error = 0;
 	int			last_error = 0;
 	xfs_agnumber_t		ag;
+	int			trylock = flags & SYNC_TRYLOCK;
+	int			skipped;
 
+restart:
 	ag = 0;
+	skipped = 0;
 	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
 		unsigned long	first_index = 0;
 		int		done = 0;
@@ -837,6 +841,15 @@ xfs_reclaim_inodes_ag(
 
 		ag = pag->pag_agno + 1;
 
+		if (trylock) {
+			if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
+				skipped++;
+				continue;
+			}
+			first_index = pag->pag_ici_reclaim_cursor;
+		} else
+			mutex_lock(&pag->pag_ici_reclaim_lock);
+
 		do {
 			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
 			int	i;
@@ -889,8 +902,25 @@ xfs_reclaim_inodes_ag(
 
 		} while (nr_found && !done && *nr_to_scan > 0);
 
+		if (trylock && !done)
+			pag->pag_ici_reclaim_cursor = first_index;
+		else
+			pag->pag_ici_reclaim_cursor = 0;
+		mutex_unlock(&pag->pag_ici_reclaim_lock);
 		xfs_perag_put(pag);
 	}
+
+	/*
+	 * if we skipped any AG, and we still have scan count remaining, do
+	 * another pass this time using blocking reclaim semantics (i.e
+	 * waiting on the reclaim locks and ignoring the reclaim cursors). This
+	 * ensure that when we get more reclaimers than AGs we block rather
+	 * than spin trying to execute reclaim.
+	 */
+	if (trylock && skipped && *nr_to_scan > 0) {
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

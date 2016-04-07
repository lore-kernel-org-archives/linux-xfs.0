Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD6A07CBA
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 18:38:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 825F28F8049
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 16:38:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ka4hfIBUvVZnN9Ai for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 16:38:49 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aoJVK-00004u-Cf
	for xfs@oss.sgi.com; Fri, 08 Apr 2016 09:38:26 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aoJUo-0006GI-8c
	for xfs@oss.sgi.com; Fri, 08 Apr 2016 09:37:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: mark reclaimed inodes invalid earlier
Date: Fri,  8 Apr 2016 09:37:51 +1000
Message-Id: <1460072271-23923-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1460072271-23923-1-git-send-email-david@fromorbit.com>
References: <1460072271-23923-1-git-send-email-david@fromorbit.com>
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

The last thing we do before using call_rcu() on an xfs_inode to be
freed is mark it as invalid. This means there is a window between
when we know for certain that the inode is going to be freed and
when we do actually mark it as "freed".

This is important in the context of RCU lookups - we can look up the
inode, find that it is valid, and then use it as such not realising
that it is in the final stages of being freed.

As such, mark the inode as being invalid the moment we know it is
going to be reclaimed. This can be done while we still hold the
XFS_ILOCK_EXCL and the flush lock in xfs_inode_reclaim, meaning that
it occurs well before we remove it from the radix tree, and that
the i_flags_lock, the XFS_ILOCK and the inode flush lock all act as
synchronisation points for detecting that an inode is about to go
away.

For defensive purposes, this allows us to add a further check to
xfs_iflush_cluster to ensure we skip inodes that are being freed
after we grab the XFS_ILOCK_SHARED and the flush lock - we know that
if the inode number if valid while we have these locks held we know
that it has not progressed through reclaim to the point where it is
clean and is about to be freed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 40 ++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode.c  | 14 +++++++++++++-
 2 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0c94cde..a60db43 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -114,6 +114,18 @@ xfs_inode_free_callback(
 	kmem_zone_free(xfs_inode_zone, ip);
 }
 
+static void
+__xfs_inode_free(
+	struct xfs_inode	*ip)
+{
+	/* asserts to verify all state is correct here */
+	ASSERT(atomic_read(&ip->i_pincount) == 0);
+	ASSERT(!xfs_isiflocked(ip));
+	XFS_STATS_DEC(ip->i_mount, vn_active);
+
+	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
+}
+
 void
 xfs_inode_free(
 	struct xfs_inode	*ip)
@@ -129,12 +141,7 @@ xfs_inode_free(
 	ip->i_ino = 0;
 	spin_unlock(&ip->i_flags_lock);
 
-	/* asserts to verify all state is correct here */
-	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!xfs_isiflocked(ip));
-	XFS_STATS_DEC(ip->i_mount, vn_active);
-
-	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
+	__xfs_inode_free(ip);
 }
 
 /*
@@ -929,6 +936,7 @@ xfs_reclaim_inode(
 	int			sync_mode)
 {
 	struct xfs_buf		*bp = NULL;
+	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
 	int			error;
 
 restart:
@@ -993,6 +1001,22 @@ restart:
 
 	xfs_iflock(ip);
 reclaim:
+	/*
+	 * Because we use RCU freeing we need to ensure the inode always appears
+	 * to be reclaimed with an invalid inode number when in the free state.
+	 * We do this as early as possible under the ILOCK and flush lock so
+	 * that xfs_iflush_cluster() can be guaranteed to detect races with us
+	 * here. By doing this, we guarantee that once xfs_iflush_cluster has
+	 * locked both the XFS_ILOCK and the flush lock that it will see either
+	 * a valid, flushable inode that will serialise correctly against the
+	 * locks below, or it will see a clean (and invalid) inode that it can
+	 * skip.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	ip->i_flags = XFS_IRECLAIM;
+	ip->i_ino = 0;
+	spin_unlock(&ip->i_flags_lock);
+
 	xfs_ifunlock(ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
@@ -1006,7 +1030,7 @@ reclaim:
 	 */
 	spin_lock(&pag->pag_ici_lock);
 	if (!radix_tree_delete(&pag->pag_ici_root,
-				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino)))
+				XFS_INO_TO_AGINO(ip->i_mount, ino)))
 		ASSERT(0);
 	__xfs_inode_clear_reclaim(pag, ip);
 	spin_unlock(&pag->pag_ici_lock);
@@ -1023,7 +1047,7 @@ reclaim:
 	xfs_qm_dqdetach(ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
-	xfs_inode_free(ip);
+	__xfs_inode_free(ip);
 	return error;
 
 out_ifunlock:
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b984be4..5b84bbc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3222,7 +3222,6 @@ xfs_iflush_cluster(
 		 * Try to get locks.  If any are unavailable or it is pinned,
 		 * then this inode cannot be flushed and is skipped.
 		 */
-
 		if (!xfs_ilock_nowait(cip, XFS_ILOCK_SHARED))
 			continue;
 		if (!xfs_iflock_nowait(cip)) {
@@ -3235,6 +3234,19 @@ xfs_iflush_cluster(
 			continue;
 		}
 
+
+		/*
+		 * Check the inode number again, just to be certain we are not
+		 * racing with freeing in xfs_reclaim_inode(). See the comments
+		 * in that function for more information as to why the initial
+		 * check is not sufficient.
+		 */
+		if (!cip->i_ino) {
+			xfs_ifunlock(cip);
+			xfs_iunlock(cip, XFS_ILOCK_SHARED);
+			continue;
+		}
+
 		/*
 		 * arriving here means that this inode can be flushed.  First
 		 * re-check that it's dirty before flushing.
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

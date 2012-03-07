Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q274odel020598 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 22:50:39 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NNAwvEEC04CieLnj for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 20:50:36 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S58pc-0001o9-Gm
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:32 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S58pc-0007V9-AT
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/10] xfs: don't cache inodes read through bulkstat
Date: Wed,  7 Mar 2012 15:50:28 +1100
Message-Id: <1331095828-28742-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1331095828-28742-1-git-send-email-david@fromorbit.com>
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
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

When we read inodes via bulkstat, we generally only read them once
and then throw them away - they never get used again. If we retain
them in cache, then it simply causes the working set of inodes and
other cached items to be reclaimed just so the inode cache can grow.

Avoid this problem by marking inodes read by bulkstat as not to be
cached and check this flag in .drop_inode to determine whether the
inode should be added to the VFS LRU or not. If the inode lookup
hits an already cached inode, then don't set the flag. If the inode
lookup hits an inode marked with no cache flag, remove the flag and
allow it to be cached once the current reference goes away.

Inodes marked as not cached will get cleaned up by the background
inode reclaim or via memory pressure, so they will still generate
some short term cache pressure. They will, however, be reclaimed
much sooner and in preference to cache hot inodes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iget.c   |    8 ++++++--
 fs/xfs/xfs_inode.h  |    4 +++-
 fs/xfs/xfs_itable.c |    3 ++-
 fs/xfs/xfs_super.c  |   17 +++++++++++++++++
 4 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 93fc1dc..20ddb1e 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -290,7 +290,7 @@ xfs_iget_cache_hit(
 	if (lock_flags != 0)
 		xfs_ilock(ip, lock_flags);
 
-	xfs_iflags_clear(ip, XFS_ISTALE);
+	xfs_iflags_clear(ip, XFS_ISTALE | XFS_IDONTCACHE);
 	XFS_STATS_INC(xs_ig_found);
 
 	return 0;
@@ -315,6 +315,7 @@ xfs_iget_cache_miss(
 	struct xfs_inode	*ip;
 	int			error;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ino);
+	int			iflags;
 
 	ip = xfs_inode_alloc(mp, ino);
 	if (!ip)
@@ -359,8 +360,11 @@ xfs_iget_cache_miss(
 	 * memory barrier that ensures this detection works correctly at lookup
 	 * time.
 	 */
+	iflags = XFS_INEW;
+	if (flags & XFS_IGET_DONTCACHE)
+		iflags |= XFS_IDONTCACHE;
 	ip->i_udquot = ip->i_gdquot = NULL;
-	xfs_iflags_set(ip, XFS_INEW);
+	xfs_iflags_set(ip, iflags);
 
 	/* insert the new inode */
 	spin_lock(&pag->pag_ici_lock);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index eda4937..096b887 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -374,10 +374,11 @@ xfs_set_projid(struct xfs_inode *ip,
 #define XFS_IFLOCK		(1 << __XFS_IFLOCK_BIT)
 #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
 #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
+#define XFS_IDONTCACHE		(1 << 9) /* don't cache the inode long term */
 
 /*
  * Per-lifetime flags need to be reset when re-using a reclaimable inode during
- * inode lookup. Thi prevents unintended behaviour on the new inode from
+ * inode lookup. This prevents unintended behaviour on the new inode from
  * ocurring.
  */
 #define XFS_IRECLAIM_RESET_FLAGS	\
@@ -544,6 +545,7 @@ do { \
  */
 #define XFS_IGET_CREATE		0x1
 #define XFS_IGET_UNTRUSTED	0x2
+#define XFS_IGET_DONTCACHE	0x4
 
 int		xfs_inotobp(struct xfs_mount *, struct xfs_trans *,
 			    xfs_ino_t, struct xfs_dinode **,
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 751e94f..b832c58 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -76,7 +76,8 @@ xfs_bulkstat_one_int(
 		return XFS_ERROR(ENOMEM);
 
 	error = xfs_iget(mp, NULL, ino,
-			 XFS_IGET_UNTRUSTED, XFS_ILOCK_SHARED, &ip);
+			 (XFS_IGET_DONTCACHE | XFS_IGET_UNTRUSTED),
+			 XFS_ILOCK_SHARED, &ip);
 	if (error) {
 		*stat = BULKSTAT_RV_NOTHING;
 		goto out_free;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b1df512..c162765 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -953,6 +953,22 @@ xfs_fs_evict_inode(
 	xfs_inactive(ip);
 }
 
+/*
+ * We do an unlocked check for XFS_IDONTCACHE here because we are already
+ * serialised against cache hits here via the inode->i_lock and igrab() in
+ * xfs_iget_cache_hit(). Hence a lookup that might clear this flag will not be
+ * racing with us, and it avoids needing to grab a spinlock here for every inode
+ * we drop the final reference on.
+ */
+STATIC int
+xfs_fs_drop_inode(
+	struct inode		*inode)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+
+	return generic_drop_inode(inode) || (ip->i_flags & XFS_IDONTCACHE);
+}
+
 STATIC void
 xfs_free_fsname(
 	struct xfs_mount	*mp)
@@ -1431,6 +1447,7 @@ static const struct super_operations xfs_super_operations = {
 	.dirty_inode		= xfs_fs_dirty_inode,
 	.write_inode		= xfs_fs_write_inode,
 	.evict_inode		= xfs_fs_evict_inode,
+	.drop_inode		= xfs_fs_drop_inode,
 	.put_super		= xfs_fs_put_super,
 	.sync_fs		= xfs_fs_sync_fs,
 	.freeze_fs		= xfs_fs_freeze,
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

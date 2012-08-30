Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UAvHJ9182492 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 05:57:17 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6EQl7jHE1MfCR6Fb for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 03:58:09 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T72Rh-0003iE-Lj
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 20:57:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T72RX-00006Q-IU
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 20:57:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/13] xfs: xfs_sync_data is redundant.
Date: Thu, 30 Aug 2012 20:57:36 +1000
Message-Id: <1346324262-32724-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1346324262-32724-1-git-send-email-david@fromorbit.com>
References: <1346324262-32724-1-git-send-email-david@fromorbit.com>
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

We don't do any data writeback from XFS any more - the VFS is
completely responsible for that, including for freeze. We can
replace the remaining caller with the VFS level function that
achieves the same thing, but without conflicting with current
writeback work - writeback_inodes_sb_if_idle().

This means we can remove the flush_work and xfs_flush_inodes() - the
VFS functionality completely replaces the internal flush queue for
doing this writeback work in a separate context to avoid stack
overruns..

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c    |    3 +-
 fs/xfs/xfs_mount.h    |    1 -
 fs/xfs/xfs_super.c    |    3 --
 fs/xfs/xfs_sync.c     |   78 -------------------------------------------------
 fs/xfs/xfs_sync.h     |    3 --
 fs/xfs/xfs_vnodeops.c |    3 +-
 6 files changed, 4 insertions(+), 87 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 973dff6..b3351d6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -446,7 +446,8 @@ retry:
 
 		if (error == ENOSPC) {
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			xfs_flush_inodes(ip);
+			writeback_inodes_sb_if_idle(VFS_I(ip)->i_sb,
+						    WB_REASON_FS_FREE_SPACE);
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
 		}
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 10e17d5..4959c5c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -200,7 +200,6 @@ typedef struct xfs_mount {
 #endif
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct work_struct	m_flush_work;	/* background inode flush */
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 15946a9..787dd79 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -918,8 +918,6 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	cancel_work_sync(&mp->m_flush_work);
-
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
@@ -1230,7 +1228,6 @@ xfs_fs_fill_super(
 	spin_lock_init(&mp->m_sb_lock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
-	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 
 	mp->m_super = sb;
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index c4c9301..e5ee24a 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -216,51 +216,6 @@ xfs_inode_ag_iterator(
 }
 
 STATIC int
-xfs_sync_inode_data(
-	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
-	int			flags)
-{
-	struct inode		*inode = VFS_I(ip);
-	struct address_space *mapping = inode->i_mapping;
-	int			error = 0;
-
-	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
-		return 0;
-
-	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
-		if (flags & SYNC_TRYLOCK)
-			return 0;
-		xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	}
-
-	error = xfs_flush_pages(ip, 0, -1, (flags & SYNC_WAIT) ?
-				0 : XBF_ASYNC, FI_NONE);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-	return error;
-}
-
-/*
- * Write out pagecache data for the whole filesystem.
- */
-STATIC int
-xfs_sync_data(
-	struct xfs_mount	*mp,
-	int			flags)
-{
-	int			error;
-
-	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
-
-	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags);
-	if (error)
-		return XFS_ERROR(error);
-
-	xfs_log_force(mp, (flags & SYNC_WAIT) ? XFS_LOG_SYNC : 0);
-	return 0;
-}
-
-STATIC int
 xfs_sync_fsdata(
 	struct xfs_mount	*mp)
 {
@@ -414,39 +369,6 @@ xfs_reclaim_worker(
 	xfs_reclaim_queue_work(mp);
 }
 
-/*
- * Flush delayed allocate data, attempting to free up reserved space
- * from existing allocations.  At this point a new allocation attempt
- * has failed with ENOSPC and we are in the process of scratching our
- * heads, looking about for more room.
- *
- * Queue a new data flush if there isn't one already in progress and
- * wait for completion of the flush. This means that we only ever have one
- * inode flush in progress no matter how many ENOSPC events are occurring and
- * so will prevent the system from bogging down due to every concurrent
- * ENOSPC event scanning all the active inodes in the system for writeback.
- */
-void
-xfs_flush_inodes(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-
-	queue_work(xfs_mount_wq, &mp->m_flush_work);
-	flush_work_sync(&mp->m_flush_work);
-}
-
-void
-xfs_flush_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(work,
-					struct xfs_mount, m_flush_work);
-
-	xfs_sync_data(mp, SYNC_TRYLOCK);
-	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
-}
-
 void
 __xfs_inode_set_reclaim_tag(
 	struct xfs_perag	*pag,
diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
index 707c46e..0beabea 100644
--- a/fs/xfs/xfs_sync.h
+++ b/fs/xfs/xfs_sync.h
@@ -24,14 +24,11 @@ struct xfs_perag;
 #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
 #define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
 
-void xfs_flush_worker(struct work_struct *work);
 void xfs_reclaim_worker(struct work_struct *work);
 
 int xfs_quiesce_data(struct xfs_mount *mp);
 void xfs_quiesce_attr(struct xfs_mount *mp);
 
-void xfs_flush_inodes(struct xfs_inode *ip);
-
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 void xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 2a5c6373..04fe077 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -777,7 +777,8 @@ xfs_create(
 			XFS_TRANS_PERM_LOG_RES, log_count);
 	if (error == ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
-		xfs_flush_inodes(dp);
+		writeback_inodes_sb_if_idle(VFS_I(ip)->i_sb,
+					    WB_REASON_FS_FREE_SPACE);
 		error = xfs_trans_reserve(tp, resblks, log_res, 0,
 				XFS_TRANS_PERM_LOG_RES, log_count);
 	}
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

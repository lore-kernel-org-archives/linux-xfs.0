Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95HIJ2f071529 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 12:18:19 -0500
Message-Id: <20121005171946.330155632@sgi.com>
Date: Fri, 05 Oct 2012 12:18:59 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [patch v4 06/13] [PATCH 06/13] xfs: xfs_sync_data is redundant.
References: <20121005171853.985930109@sgi.com>
Content-Disposition: inline; filename=xfs-xfs_sync_data-is-redundant-2.patch
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

We don't do any data writeback from XFS any more - the VFS is
completely responsible for that, including for freeze.

We could replace the remaining caller with the VFS level function that
achieves the same thing, but without conflicting with current writeback
work - writeback_inodes_sb_if_idle().  However,
writeback_inodes_sb_if_idle() is not sufficient to trigger delalloc
conversion fast enough to prevent spurious ENOSPC when there are
hundreds of writers, thousands of small files and GBs of free RAM.  Use
sync_sb_inodes() instead to block callers while we wait for writeback.

This means we can remove the flush_work and xfs_flush_inodes() - the
VFS functionality completely replaces the internal flush queue for
doing this writeback work in a separate context to avoid stack
overruns.

This does have one complication - it cannot be called with page
locks held.  Hence move the flushing of delalloc space when ENOSPC
occurs back up into xfs_file_aio_buffered_write when we don't hold
any locks that will stall writeback.

Note that we always need to pass a count of zero to
generic_file_buffered_write() as the previously written byte count.
We only do this by accident before this patch by the virtue of ret
always being zero when there are no errors. Make this explicit
rather than needing to specifically zero ret in the ENOSPC retry
case.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

---

v2: cleaned up the xfs_flush_inodes interface as per Christoph's request. -bpm

v3: updated the xfs_flush_inode implementation with the patch from
http://oss.sgi.com/archives/xfs/2012-10/msg00036.html.  Folded the commit
header comments into this commit header and into the comment above
xfs_flush_inode. -bpm

 fs/xfs/xfs_file.c     |   13 ++++----
 fs/xfs/xfs_iomap.c    |   23 ++++----------
 fs/xfs/xfs_mount.h    |   22 +++++++++++++-
 fs/xfs/xfs_super.c    |    3 -
 fs/xfs/xfs_sync.c     |   78 --------------------------------------------------
 fs/xfs/xfs_sync.h     |    3 -
 fs/xfs/xfs_vnodeops.c |    2 -
 7 files changed, 36 insertions(+), 108 deletions(-)

Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c
+++ xfs/fs/xfs/xfs_file.c
@@ -728,16 +728,17 @@ xfs_file_buffered_aio_write(
 write_retry:
 	trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, 0);
 	ret = generic_file_buffered_write(iocb, iovp, nr_segs,
-			pos, &iocb->ki_pos, count, ret);
+			pos, &iocb->ki_pos, count, 0);
+
 	/*
-	 * if we just got an ENOSPC, flush the inode now we aren't holding any
-	 * page locks and retry *once*
+	 * If we just got an ENOSPC, try to write back all dirty inodes to
+	 * convert delalloc space to free up some of the excess reserved
+	 * metadata space.
 	 */
 	if (ret == -ENOSPC && !enospc) {
 		enospc = 1;
-		ret = -xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
-		if (!ret)
-			goto write_retry;
+		xfs_flush_inodes(ip->i_mount);
+		goto write_retry;
 	}
 
 	current->backing_dev_info = NULL;
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c
+++ xfs/fs/xfs/xfs_iomap.c
@@ -373,7 +373,7 @@ xfs_iomap_write_delay(
 	xfs_extlen_t	extsz;
 	int		nimaps;
 	xfs_bmbt_irec_t imap[XFS_WRITE_IMAPS];
-	int		prealloc, flushed = 0;
+	int		prealloc;
 	int		error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -434,26 +434,17 @@ retry:
 	}
 
 	/*
-	 * If bmapi returned us nothing, we got either ENOSPC or EDQUOT.  For
-	 * ENOSPC, * flush all other inodes with delalloc blocks to free up
-	 * some of the excess reserved metadata space. For both cases, retry
+	 * If bmapi returned us nothing, we got either ENOSPC or EDQUOT. Retry
 	 * without EOF preallocation.
 	 */
 	if (nimaps == 0) {
 		trace_xfs_delalloc_enospc(ip, offset, count);
-		if (flushed)
-			return XFS_ERROR(error ? error : ENOSPC);
-
-		if (error == ENOSPC) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			xfs_flush_inodes(ip);
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
+		if (prealloc) {
+			prealloc = 0;
+			error = 0;
+			goto retry;
 		}
-
-		flushed = 1;
-		error = 0;
-		prealloc = 0;
-		goto retry;
+		return XFS_ERROR(error ? error : ENOSPC);
 	}
 
 	if (!(imap[0].br_startblock || XFS_IS_REALTIME_INODE(ip)))
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h
+++ xfs/fs/xfs/xfs_mount.h
@@ -198,7 +198,6 @@ typedef struct xfs_mount {
 #endif
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct work_struct	m_flush_work;	/* background inode flush */
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
@@ -381,6 +380,27 @@ extern int	xfs_dev_is_read_only(struct x
 
 extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 
+/*
+ * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
+ * or a page lock.
+ *
+ * We have to hold the s_umount lock here, but because this call can nest
+ * inside i_mutex (the parent directory in the create case, held by the VFS),
+ * we have to use down_read_trylock() to avoid potential deadlocks. In
+ * practice, this trylock will succeed on almost every attempt as
+ * unmount/remount type operations are exceedingly rare.
+ */
+static inline void
+xfs_flush_inodes(struct xfs_mount *mp)
+{
+	struct super_block *sb = mp->m_super;
+
+	if (down_read_trylock(&sb->s_umount)) {
+		sync_inodes_sb(sb);
+		up_read(&sb->s_umount);
+	}
+}
+
 #endif	/* __KERNEL__ */
 
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c
+++ xfs/fs/xfs/xfs_super.c
@@ -1005,8 +1005,6 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	cancel_work_sync(&mp->m_flush_work);
-
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 
@@ -1324,7 +1322,6 @@ xfs_fs_fill_super(
 	spin_lock_init(&mp->m_sb_lock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
-	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 
 	mp->m_super = sb;
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c
+++ xfs/fs/xfs/xfs_sync.c
@@ -217,51 +217,6 @@ xfs_inode_ag_iterator(
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
@@ -415,39 +370,6 @@ xfs_reclaim_worker(
 	xfs_syncd_queue_reclaim(mp);
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
-	queue_work(xfs_syncd_wq, &mp->m_flush_work);
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
Index: xfs/fs/xfs/xfs_sync.h
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.h
+++ xfs/fs/xfs/xfs_sync.h
@@ -26,14 +26,11 @@ struct xfs_perag;
 
 extern struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
 
-void xfs_flush_worker(struct work_struct *work);
 void xfs_reclaim_worker(struct work_struct *work);
 
 int xfs_quiesce_data(struct xfs_mount *mp);
 void xfs_quiesce_attr(struct xfs_mount *mp);
 
-void xfs_flush_inodes(struct xfs_inode *ip);
-
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 void xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c
+++ xfs/fs/xfs/xfs_vnodeops.c
@@ -777,7 +777,7 @@ xfs_create(
 			XFS_TRANS_PERM_LOG_RES, log_count);
 	if (error == ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
-		xfs_flush_inodes(dp);
+		xfs_flush_inodes(dp->i_mount);
 		error = xfs_trans_reserve(tp, resblks, log_res, 0,
 				XFS_TRANS_PERM_LOG_RES, log_count);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

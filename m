Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 16:37:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9TNbeSB000367
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 16:37:44 -0700
Date: Tue, 30 Oct 2007 10:37:42 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] fix inode allocation latency
Message-ID: <20071029233742.GS995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: xfs-dev@sgi.com

The log force added in xfs_iget_core() has been a performance
issue since it was introduced for tight loops that allocate
then unlink a single file. under heavy writeback, this can
introduce unnecessary latency due tothe log I/o getting
stuck behind bulk data writes.

Fix this latency problem by avoinding the need for the log
force by moving the place we mark linux inode dirty to the
transaction commit rather than on transaction completion.

This also closes a potential hole in the sync code where a
linux inode is not dirty betwen the time it is modified and
the time the log buffer has been written to disk.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |   16 ++++++++++++++++
 fs/xfs/xfs_iget.c           |   18 ------------------
 fs/xfs/xfs_inode.c          |   34 +---------------------------------
 fs/xfs/xfs_inode.h          |    1 +
 fs/xfs/xfs_inode_item.c     |    5 +++++
 5 files changed, 23 insertions(+), 51 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-10-02 16:01:47.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c	2007-10-12 09:54:12.466194814 +1000
@@ -71,6 +71,22 @@ xfs_synchronize_atime(
 }
 
 /*
+ * If the linux inode exists, mark it dirty.
+ * Used when commiting a dirty inode into a transaction so that
+ * the inode will get written back by the linux code
+ */
+void
+xfs_mark_inode_dirty_sync(
+	xfs_inode_t	*ip)
+{
+	bhv_vnode_t	*vp;
+
+	vp = XFS_ITOV_NULL(ip);
+	if (vp)
+		mark_inode_dirty_sync(vn_to_inode(vp));
+}
+
+/*
  * Change the requested timestamp in the given inode.
  * We don't lock across timestamp updates, and we don't log them but
  * we do record the fact that there is dirty information in core.
Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2007-10-02 16:01:48.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2007-10-12 09:58:38.263910771 +1000
@@ -140,27 +140,9 @@ again:
 				return ENOENT;
 			}
 
-			/*
-			 * There may be transactions sitting in the
-			 * incore log buffers or being flushed to disk
-			 * at this time.  We can't clear the
-			 * XFS_IRECLAIMABLE flag until these
-			 * transactions have hit the disk, otherwise we
-			 * will void the guarantee the flag provides
-			 * xfs_iunpin()
-			 */
-			if (xfs_ipincount(ip)) {
-				read_unlock(&pag->pag_ici_lock);
-				xfs_log_force(mp, 0,
-					XFS_LOG_FORCE|XFS_LOG_SYNC);
-				XFS_STATS_INC(xs_ig_frecycle);
-				goto again;
-			}
-
 			xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 
 			XFS_STATS_INC(xs_ig_found);
-
 			xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
 			read_unlock(&pag->pag_ici_lock);
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-10-11 09:53:53.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-10-12 09:56:49.721912637 +1000
@@ -2807,40 +2807,8 @@ xfs_iunpin(
 {
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
 
-	if (atomic_dec_and_lock(&ip->i_pincount, &ip->i_flags_lock)) {
-
-		/*
-		 * If the inode is currently being reclaimed, the link between
-		 * the bhv_vnode and the xfs_inode will be broken after the
-		 * XFS_IRECLAIM* flag is set. Hence, if these flags are not
-		 * set, then we can move forward and mark the linux inode dirty
-		 * knowing that it is still valid as it won't freed until after
-		 * the bhv_vnode<->xfs_inode link is broken in xfs_reclaim. The
-		 * i_flags_lock is used to synchronise the setting of the
-		 * XFS_IRECLAIM* flags and the breaking of the link, and so we
-		 * can execute atomically w.r.t to reclaim by holding this lock
-		 * here.
-		 *
-		 * However, we still need to issue the unpin wakeup call as the
-		 * inode reclaim may be blocked waiting for the inode to become
-		 * unpinned.
-		 */
-
-		if (!__xfs_iflags_test(ip, XFS_IRECLAIM|XFS_IRECLAIMABLE)) {
-			bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
-			struct inode *inode = NULL;
-
-			BUG_ON(vp == NULL);
-			inode = vn_to_inode(vp);
-			BUG_ON(inode->i_state & I_CLEAR);
-
-			/* make sync come back and flush this inode */
-			if (!(inode->i_state & (I_NEW|I_FREEING)))
-				mark_inode_dirty_sync(inode);
-		}
-		spin_unlock(&ip->i_flags_lock);
+	if (atomic_dec_and_test(&ip->i_pincount))
 		wake_up(&ip->i_ipin_wait);
-	}
 }
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2007-10-02 16:01:48.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2007-10-12 10:00:10.979948827 +1000
@@ -532,6 +532,7 @@ xfs_fsize_t	xfs_file_last_byte(xfs_inode
 void		xfs_lock_inodes(xfs_inode_t **, int, int, uint);
 
 void		xfs_synchronize_atime(xfs_inode_t *);
+void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
 xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
 void		xfs_iext_insert(xfs_ifork_t *, xfs_extnum_t, xfs_extnum_t,
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode_item.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode_item.c	2007-10-02 16:01:48.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode_item.c	2007-10-12 09:54:18.053474268 +1000
@@ -274,6 +274,11 @@ xfs_inode_item_format(
 	 */
 	xfs_synchronize_atime(ip);
 
+	/*
+	 * make sure the linux inode is dirty
+	 */
+	xfs_mark_inode_dirty_sync(ip);
+
 	vecp->i_addr = (xfs_caddr_t)&ip->i_d;
 	vecp->i_len  = sizeof(xfs_dinode_core_t);
 	XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_ICORE);

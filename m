Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 00:20:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9O7JuaG003698
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 00:19:58 -0700
Date: Tue, 24 Oct 2006 17:19:08 +1000
From: David Chinner <dgc@sgi.com>
Subject: [REVIEW 2 of 4] Remove igrab from xfs_iunpin
Message-ID: <20061024071908.GS11034@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: t-nagano@ah.jp.nec.com, xfs-dev@sgi.com


-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


Remove the need for grabbing the linux inode in xfs_iunpin(). This
causes deadlocks when the xfslogd drops the final reference to an
inode and needs to issue a transaction when the log is full. We can
do this by providing a guarantee external to xfs_iunpin() that when
either of the XFS_IRECLAIM or XFS_IRECLAIMABLE flags are set on the
xfs inode there is no linux inode to look up.

---
 fs/xfs/xfs_inode.c    |   44 +++++++++++++++++++++-----------------------
 fs/xfs/xfs_vnodeops.c |   21 ++++++++++++++-------
 2 files changed, 35 insertions(+), 30 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-10-19 10:25:07.334515530 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-10-19 10:26:01.983441994 +1000
@@ -2742,41 +2742,39 @@ xfs_iunpin(
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
 
 	if (atomic_dec_and_test(&ip->i_pincount)) {
+
 		/*
-		 * If the inode is currently being reclaimed, the
-		 * linux inode _and_ the xfs vnode may have been
-		 * freed so we cannot reference either of them safely.
-		 * Hence we should not try to do anything to them
-		 * if the xfs inode is currently in the reclaim
-		 * path.
+		 * If the inode is currently being reclaimed, the link between
+		 * the bhv_vnode and the xfs_inode will be broken after the
+		 * XFS_IRECLAIM* flag is set. Hence, if these flags are not
+		 * set, then we can move forward and mark the linux inode dirty
+		 * knowing that it is still valid as it won't freed until after
+		 * the bhv_vnode<->xfs_inode link is broken in xfs_reclaim. The
+		 * i_flags_lock is used to synchronise the setting of the
+		 * XFS_IRECLAIM* flags and the breaking of the link, and so we
+		 * can execute atomically w.r.t to reclaim by holding this lock
+		 * here.
 		 *
-		 * However, we still need to issue the unpin wakeup
-		 * call as the inode reclaim may be blocked waiting for
-		 * the inode to become unpinned.
+		 * However, we still need to issue the unpin wakeup call as the
+		 * inode reclaim may be blocked waiting for the inode to become
+		 * unpinned.
 		 */
-		struct inode *inode = NULL;
 
 		spin_lock(&ip->i_flags_lock);
 		if (!__xfs_iflags_test(ip, XFS_IRECLAIM|XFS_IRECLAIMABLE)) {
 			bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
+			struct inode *inode = NULL;
 
-			/* make sync come back and flush this inode */
-			if (vp) {
-				inode = vn_to_inode(vp);
+			BUG_ON(vp == NULL);
+			inode = vn_to_inode(vp);
+			BUG_ON(inode->i_state & I_CLEAR);
 
-				if (!(inode->i_state &
-						(I_NEW|I_FREEING|I_CLEAR))) {
-					inode = igrab(inode);
-					if (inode)
-						mark_inode_dirty_sync(inode);
-				} else
-					inode = NULL;
-			}
+			/* make sync come back and flush this inode */
+			if (!(inode->i_state & (I_NEW|I_FREEING)))
+				mark_inode_dirty_sync(inode);
 		}
 		spin_unlock(&ip->i_flags_lock);
 		wake_up(&ip->i_ipin_wait);
-		if (inode)
-			iput(inode);
 	}
 }
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2006-10-19 10:25:07.338515013 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2006-10-19 10:25:17.957140602 +1000
@@ -3827,11 +3827,16 @@ xfs_reclaim(
 	 */
 	xfs_synchronize_atime(ip);
 
-	/* If we have nothing to flush with this inode then complete the
-	 * teardown now, otherwise break the link between the xfs inode
-	 * and the linux inode and clean up the xfs inode later. This
-	 * avoids flushing the inode to disk during the delete operation
-	 * itself.
+	/*
+	 * If we have nothing to flush with this inode then complete the
+	 * teardown now, otherwise break the link between the xfs inode and the
+	 * linux inode and clean up the xfs inode later. This avoids flushing
+	 * the inode to disk during the delete operation itself.
+	 *
+	 * When breaking the link, we need to set the XFS_IRECLAIMABLE flag
+	 * first to ensure that xfs_iunpin() will never see an xfs inode
+	 * that has a linux inode being reclaimed. Synchronisation is provided
+	 * by the i_flags_lock.
 	 */
 	if (!ip->i_update_core && (ip->i_itemp == NULL)) {
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -3840,11 +3845,13 @@ xfs_reclaim(
 	} else {
 		xfs_mount_t	*mp = ip->i_mount;
 
-		/* Protect sync from us */
+		/* Protect sync and unpin from us */
 		XFS_MOUNT_ILOCK(mp);
+		spin_lock(&ip->i_flags_lock);
+		__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 		vn_bhv_remove(VN_BHV_HEAD(vp), XFS_ITOBHV(ip));
+		spin_unlock(&ip->i_flags_lock);
 		list_add_tail(&ip->i_reclaim, &mp->m_del_inodes);
-		xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 		XFS_MOUNT_IUNLOCK(mp);
 	}
 	return 0;

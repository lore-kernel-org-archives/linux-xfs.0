Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Oct 2006 22:07:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9357faG026731
	for <xfs@oss.sgi.com>; Mon, 2 Oct 2006 22:07:43 -0700
Date: Tue, 3 Oct 2006 15:06:54 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: prevent deadlock via async iput from xfs_iunpin
Message-ID: <20061003050654.GQ4695059@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com


In fixing the recent problems with inode use-after-free in
xfs_iunpin, we introduced a new deadlock. When iput() is called, it
can trigger new transactions on the inode if we are dropping the
final reference. This is a bad thing to do from a xfslogd because it
is theonly thread that can move the tail of the log forwards.

Hence if we attempt to reservespace for the transaction from
xfslogd, and we then need to push the tail of the log forward to
make space, we may end up going to sleep  waiting for space to
become available.  This is a deadlock condition because the only
thing that can move the tail forward at this point is by running the
remaining log callbacks that are pending and only the xfslogd can do
this.

Hence we cannot call iput() directly from xfs_iunpin. The simple
solution is to push the iput() call off to a different thread to
drop the reference we gained via igrab() earlier in xfs_iunpin().
The patch below does this by pushing the iput to the xfssyncd.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/linux-2.6/xfs_super.c |   26 ++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_super.h |    1 +
 fs/xfs/xfs_inode.c           |    2 +-
 3 files changed, 28 insertions(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2006-09-21 13:29:17.784671067 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2006-09-21 14:56:58.546131524 +1000
@@ -551,6 +551,32 @@ xfs_flush_device(
 	xfs_log_force(ip->i_mount, (xfs_lsn_t)0, XFS_LOG_FORCE|XFS_LOG_SYNC);
 }
 
+/*
+ * If xfs_iunpin was unfortunate enough to be the last holder of an
+ * inode reference, the iput() call could issues transactions. This is a
+ * bad thing to do from xfslogd as it can deadlock waiting for log
+ * space that only it can free up. hence we simply push the iput off into
+ * the xfssyncd so that any transactions that are needed can occur without
+ * fear of deadlock.
+ */
+STATIC void
+xfs_inode_iput_work(
+	bhv_vfs_t	*vfs,
+	void		*inode)
+{
+	iput((struct inode *)inode);
+}
+
+void
+xfs_inode_iput(
+	xfs_inode_t	*ip)
+{
+	struct inode	*inode = vn_to_inode(XFS_ITOV(ip));
+	struct bhv_vfs	*vfs = XFS_MTOVFS(ip->i_mount);
+
+	xfs_syncd_queue_work(vfs, inode, xfs_inode_iput_work);
+}
+
 STATIC void
 vfs_sync_worker(
 	bhv_vfs_t	*vfsp,
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.h	2006-09-21 13:29:17.788670542 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.h	2006-09-21 13:32:53.216411081 +1000
@@ -81,6 +81,7 @@ extern void xfs_initialize_vnode(bhv_des
 
 extern void xfs_flush_inode(struct xfs_inode *);
 extern void xfs_flush_device(struct xfs_inode *);
+extern void xfs_inode_iput(struct xfs_inode *);
 
 extern int  xfs_blkdev_get(struct xfs_mount *, const char *,
 				struct block_device **);
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-09-21 13:29:17.812667394 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-09-21 13:32:53.240407934 +1000
@@ -2773,7 +2773,7 @@ xfs_iunpin(
 		spin_unlock(&ip->i_flags_lock);
 		wake_up(&ip->i_ipin_wait);
 		if (inode)
-			iput(inode);
+			xfs_inode_iput(ip);
 	}
 }
 

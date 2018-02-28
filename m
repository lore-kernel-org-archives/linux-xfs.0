Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55156 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933833AbeB1R5o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Feb 2018 12:57:44 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] xfs: implement the lazytime mount option
Date: Wed, 28 Feb 2018 09:57:37 -0800
Message-Id: <20180228175737.317-3-hch@lst.de>
In-Reply-To: <20180228175737.317-1-hch@lst.de>
References: <20180228175737.317-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

Use the VFS dirty inode tracking for lazytime inodes only, and just
log them in ->dirty_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c        | 13 ++++++++++++-
 fs/xfs/xfs_super.c       | 23 +++++++++++++++++++++++
 fs/xfs/xfs_trans_inode.c | 14 ++++++++++++++
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 56475fcd76f2..8567951eff10 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -46,6 +46,7 @@
 #include <linux/security.h>
 #include <linux/iomap.h>
 #include <linux/slab.h>
+#include <linux/iversion.h>
 
 /*
  * Directories have different lock order w.r.t. mmap_sem compared to regular
@@ -1052,11 +1053,21 @@ xfs_vn_update_time(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
+	int			log_flags = XFS_ILOG_TIMESTAMP;
 	struct xfs_trans	*tp;
 	int			error;
 
 	trace_xfs_update_time(ip);
 
+	if (inode->i_sb->s_flags & SB_LAZYTIME) {
+		if (!((flags & S_VERSION) &&
+		      inode_maybe_inc_iversion(inode, false)))
+			return generic_update_time(inode, now, flags);
+
+		/* Capture the iversion update that just occurred */
+		log_flags |= XFS_ILOG_CORE;
+	}
+
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
 	if (error)
 		return error;
@@ -1070,7 +1081,7 @@ xfs_vn_update_time(
 		inode->i_atime = *now;
 
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
+	xfs_trans_log_inode(tp, ip, log_flags);
 	return xfs_trans_commit(tp);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7aba628dc527..20d53f125c35 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1007,6 +1007,28 @@ xfs_fs_destroy_inode(
 	xfs_inode_set_reclaim_tag(ip);
 }
 
+static void
+xfs_fs_dirty_inode(
+	struct inode			*inode,
+	int				flag)
+{
+	struct xfs_inode		*ip = XFS_I(inode);
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_trans		*tp;
+
+	if (!(inode->i_sb->s_flags & SB_LAZYTIME))
+		return;
+	if (flag != I_DIRTY_SYNC || !(inode->i_state & I_DIRTY_TIME))
+		return;
+
+	if (xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp))
+		return;
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
+	xfs_trans_commit(tp);
+}
+
 /*
  * Slab object creation initialisation for the XFS inode.
  * This covers only the idempotent fields in the XFS inode;
@@ -1787,6 +1809,7 @@ xfs_fs_free_cached_objects(
 static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
+	.dirty_inode		= xfs_fs_dirty_inode,
 	.drop_inode		= xfs_fs_drop_inode,
 	.put_super		= xfs_fs_put_super,
 	.sync_fs		= xfs_fs_sync_fs,
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index fddacf9575df..bbb596860bf8 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -98,9 +98,23 @@ xfs_trans_log_inode(
 	xfs_inode_t	*ip,
 	uint		flags)
 {
+	struct inode	*inode = VFS_I(ip);
+
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
+	/*
+	 * Don't bother with i_lock for the I_DIRTY_TIME check here, as races
+	 * don't matter - we either will need an extra transaction in 24 hours
+	 * to log the timestamps, or will clear already cleared fields in the
+	 * worst case.
+	 */
+	if (inode->i_state & (I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED)) {
+		spin_lock(&inode->i_lock);
+		inode->i_state &= ~(I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED);
+		spin_unlock(&inode->i_lock);
+	}
+
 	/*
 	 * First time we log the inode in a transaction, bump the inode change
 	 * counter if it is configured for this to occur. While we have the
-- 
2.14.2


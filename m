Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53940 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755418AbeAHTEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 14:04:45 -0500
Date: Mon, 8 Jan 2018 11:02:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] vfs/xfs: clean up cow mappings during fs data freeze
Message-ID: <20180108190216.GR5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

As part of the fs freezing process, we want to free the copy-on-write
reservations after all the dirty data has been written to disk but prior
to freezing the filesystem.  Currently, only a sync_filesystem call is
hardwired into the VFS code, so provide a new callout, ->freeze_data, so
that filesystems can override with whatever behavior they want.

In the case of XFS, that behavior is "sync and then clean the cow
mappings".  This reduces the amount of recovery that must happen if the
system goes down while the fs is frozen.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/super.c         |   23 +++++++++++++++++------
 fs/xfs/xfs_super.c |   21 +++++++++++++++++++++
 include/linux/fs.h |    1 +
 3 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index d4e33e8..f0ee186 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1454,7 +1454,16 @@ int freeze_super(struct super_block *sb)
 	sb_wait_write(sb, SB_FREEZE_PAGEFAULT);
 
 	/* All writers are done so after syncing there won't be dirty data */
-	sync_filesystem(sb);
+	if (sb->s_op->freeze_data) {
+		ret = sb->s_op->freeze_data(sb);
+		if (ret) {
+			printk(KERN_ERR
+				"VFS:Filesystem data freeze failed\n");
+			goto freeze_fail;
+		}
+	} else {
+		sync_filesystem(sb);
+	}
 
 	/* Now wait for internal filesystem counter */
 	sb->s_writers.frozen = SB_FREEZE_FS;
@@ -1465,11 +1474,7 @@ int freeze_super(struct super_block *sb)
 		if (ret) {
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
-			sb->s_writers.frozen = SB_UNFROZEN;
-			sb_freeze_unlock(sb);
-			wake_up(&sb->s_writers.wait_unfrozen);
-			deactivate_locked_super(sb);
-			return ret;
+			goto freeze_fail;
 		}
 	}
 	/*
@@ -1480,6 +1485,12 @@ int freeze_super(struct super_block *sb)
 	lockdep_sb_freeze_release(sb);
 	up_write(&sb->s_umount);
 	return 0;
+freeze_fail:
+	sb->s_writers.frozen = SB_UNFROZEN;
+	sb_freeze_unlock(sb);
+	wake_up(&sb->s_writers.wait_unfrozen);
+	deactivate_locked_super(sb);
+	return ret;
 }
 EXPORT_SYMBOL(freeze_super);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2db6a40..2817bce 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1408,6 +1408,26 @@ xfs_fs_remount(
 }
 
 /*
+ * First stage of a freeze.  We need to sync all the dirty data and clean up
+ * all the leftover CoW mappings to make the filesystem as tidy as possible.
+ */
+STATIC int
+xfs_fs_freeze_data(
+	struct super_block	*sb)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+	int			error;
+
+	error = sync_filesystem(sb);
+	if (error)
+		return error;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+	return xfs_icache_free_cowblocks(mp, NULL);
+}
+
+/*
  * Second stage of a freeze. The data is already frozen so we only
  * need to take care of the metadata. Once that's done sync the superblock
  * to the log to dirty it in case of a crash while frozen. This ensures that we
@@ -1780,6 +1800,7 @@ static const struct super_operations xfs_super_operations = {
 	.drop_inode		= xfs_fs_drop_inode,
 	.put_super		= xfs_fs_put_super,
 	.sync_fs		= xfs_fs_sync_fs,
+	.freeze_data		= xfs_fs_freeze_data,
 	.freeze_fs		= xfs_fs_freeze,
 	.unfreeze_fs		= xfs_fs_unfreeze,
 	.statfs			= xfs_fs_statfs,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2995a27..d53d55f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1811,6 +1811,7 @@ struct super_operations {
 	void (*put_super) (struct super_block *);
 	int (*sync_fs)(struct super_block *sb, int wait);
 	int (*freeze_super) (struct super_block *);
+	int (*freeze_data) (struct super_block *);
 	int (*freeze_fs) (struct super_block *);
 	int (*thaw_super) (struct super_block *);
 	int (*unfreeze_fs) (struct super_block *);

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FBB97F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 17:59:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1C76AC005
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 15:59:15 -0800 (PST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id BQeW4h50lQtrqTmY for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 15:59:14 -0800 (PST)
Subject: [PATCH 2/3] xfs: handle shutdown notifications
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 01 Dec 2015 15:58:46 -0800
Message-ID: <20151201235846.36836.1476.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151201235836.36836.90416.stgit@dwillia2-desk3.jf.intel.com>
References: <20151201235836.36836.90416.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org, xfs@oss.sgi.com, linux-nvdimm@lists.01.org

Force a filesystem shutdown when the backing device is known to be dead.
I.e. blk_queue_enter() permanently returns -ENODEV.

Cc: xfs@oss.sgi.com
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/block_dev.c     |    3 ++-
 fs/xfs/xfs_super.c |    9 +++++++++
 include/linux/fs.h |    2 ++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 39989e990df9..dfe9a53a7c53 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1802,7 +1802,7 @@ int __invalidate_device(struct block_device *bdev, bool kill_dirty)
 }
 EXPORT_SYMBOL(__invalidate_device);
 
-static void generic_bdi_gone(struct super_block *sb)
+void generic_bdi_gone(struct super_block *sb)
 {
 	struct inode *inode, *_inode = NULL;
 
@@ -1828,6 +1828,7 @@ static void generic_bdi_gone(struct super_block *sb)
 	spin_unlock(&sb->s_inode_list_lock);
 	iput(_inode);
 }
+EXPORT_SYMBOL(generic_bdi_gone);
 
 void shutdown_partition(struct gendisk *disk, int partno)
 {
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 36bd8825bfb0..63c36508e9db 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1618,6 +1618,14 @@ xfs_fs_free_cached_objects(
 	return xfs_reclaim_inodes_nr(XFS_M(sb), sc->nr_to_scan);
 }
 
+static void
+xfs_fs_bdi_gone(
+	struct super_block *sb)
+{
+	xfs_force_shutdown(XFS_M(sb), SHUTDOWN_DEVICE_REQ);
+	generic_bdi_gone(sb);
+}
+
 static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
@@ -1632,6 +1640,7 @@ static const struct super_operations xfs_super_operations = {
 	.show_options		= xfs_fs_show_options,
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
+	.bdi_gone		= xfs_fs_bdi_gone,
 };
 
 static struct file_system_type xfs_fs_type = {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0e201ed38045..b1e8e049e4b8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2265,6 +2265,7 @@ extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
 extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
 extern int fsync_bdev(struct block_device *);
+extern void generic_bdi_gone(struct super_block *sb);
 
 extern struct super_block *blockdev_superblock;
 
@@ -2277,6 +2278,7 @@ static inline void bd_forget(struct inode *inode) {}
 static inline int sync_blockdev(struct block_device *bdev) { return 0; }
 static inline void kill_bdev(struct block_device *bdev) {}
 static inline void invalidate_bdev(struct block_device *bdev) {}
+static inline void generic_bdi_gone(struct super_block *sb) {}
 
 static inline struct super_block *freeze_bdev(struct block_device *sb)
 {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

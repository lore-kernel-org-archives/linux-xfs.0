Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:17566 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756541AbdLXBFD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Dec 2017 20:05:03 -0500
Subject: [PATCH v4 09/18] mm,
 dax: enable filesystems to trigger dev_pagemap ->page_free callbacks
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Dec 2017 16:56:48 -0800
Message-ID: <151407700867.38751.6057494992833550623.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de

In order to resolve collisions between filesystem operations and DMA to
DAX mapped pages we need a callback when DMA completes. With a callback
we can hold off filesystem operations while DMA is in-flight and then
resume those operations when the last put_page() occurs on a DMA page.

Recall that the 'struct page' entries for DAX memory are created with
devm_memremap_pages(). That routine arranges for the pages to be
allocated, but never onlined, so a DAX page is DMA-idle when its
reference count reaches one.

Also recall that the HMM sub-system added infrastructure to trap the
page-idle (2-to-1 reference count) transition of the pages allocated by
devm_memremap_pages() and trigger a callback via the 'struct
dev_pagemap' associated with the page range. Whereas the HMM callbacks
are going to a device driver to manage bounce pages in device-memory in
the filesystem-dax case we will call back to filesystem specified
callback.

Since the callback is not known at devm_memremap_pages() time we arrange
for the filesystem to install it at mount time. No functional changes
are expected as this only registers a nop handler for the ->page_free()
event for device-mapped pages.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c      |   79 ++++++++++++++++++++++++++++++++++++++++------
 drivers/nvdimm/pmem.c    |    3 +-
 fs/ext2/super.c          |    6 ++-
 fs/ext4/super.c          |    6 ++-
 fs/xfs/xfs_super.c       |   20 ++++++------
 include/linux/dax.h      |   17 +++++-----
 include/linux/memremap.h |    8 +++++
 7 files changed, 103 insertions(+), 36 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 516124ae1ccf..e926e373a3a5 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -29,6 +29,7 @@ static struct vfsmount *dax_mnt;
 static DEFINE_IDA(dax_minor_ida);
 static struct kmem_cache *dax_cache __read_mostly;
 static struct super_block *dax_superblock __read_mostly;
+static DEFINE_MUTEX(devmap_lock);
 
 #define DAX_HASH_SIZE (PAGE_SIZE / sizeof(struct hlist_head))
 static struct hlist_head dax_host_list[DAX_HASH_SIZE];
@@ -62,16 +63,6 @@ int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
 }
 EXPORT_SYMBOL(bdev_dax_pgoff);
 
-#if IS_ENABLED(CONFIG_FS_DAX)
-struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
-{
-	if (!blk_queue_dax(bdev->bd_queue))
-		return NULL;
-	return fs_dax_get_by_host(bdev->bd_disk->disk_name);
-}
-EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
-#endif
-
 /**
  * __bdev_dax_supported() - Check if the device supports dax for filesystem
  * @sb: The superblock of the device
@@ -169,9 +160,66 @@ struct dax_device {
 	const char *host;
 	void *private;
 	unsigned long flags;
+	struct dev_pagemap *pgmap;
 	const struct dax_operations *ops;
 };
 
+#if IS_ENABLED(CONFIG_FS_DAX)
+static void generic_dax_pagefree(struct page *page, void *data)
+{
+	/* TODO: wakeup page-idle waiters */
+}
+
+struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *owner)
+{
+	struct dax_device *dax_dev;
+	struct dev_pagemap *pgmap;
+
+	if (!blk_queue_dax(bdev->bd_queue))
+		return NULL;
+	dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
+	if (!dax_dev->pgmap)
+		return dax_dev;
+	pgmap = dax_dev->pgmap;
+
+	mutex_lock(&devmap_lock);
+	if ((pgmap->data && pgmap->data != owner) || pgmap->page_free
+			|| pgmap->page_fault
+			|| pgmap->type != MEMORY_DEVICE_HOST) {
+		put_dax(dax_dev);
+		mutex_unlock(&devmap_lock);
+		return NULL;
+	}
+
+	pgmap->type = MEMORY_DEVICE_FS_DAX;
+	pgmap->page_free = generic_dax_pagefree;
+	pgmap->data = owner;
+	mutex_unlock(&devmap_lock);
+
+	return dax_dev;
+}
+EXPORT_SYMBOL_GPL(fs_dax_claim_bdev);
+
+void fs_dax_release(struct dax_device *dax_dev, void *owner)
+{
+	struct dev_pagemap *pgmap = dax_dev ? dax_dev->pgmap : NULL;
+
+	put_dax(dax_dev);
+	if (!pgmap)
+		return;
+	if (!pgmap->data)
+		return;
+
+	mutex_lock(&devmap_lock);
+	WARN_ON(pgmap->data != owner);
+	pgmap->type = MEMORY_DEVICE_HOST;
+	pgmap->page_free = NULL;
+	pgmap->data = NULL;
+	mutex_unlock(&devmap_lock);
+}
+EXPORT_SYMBOL_GPL(fs_dax_release);
+#endif
+
 static ssize_t write_cache_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -505,6 +553,17 @@ struct dax_device *alloc_dax(void *private, const char *__host,
 }
 EXPORT_SYMBOL_GPL(alloc_dax);
 
+struct dax_device *alloc_dax_devmap(void *private, const char *host,
+		const struct dax_operations *ops, struct dev_pagemap *pgmap)
+{
+	struct dax_device *dax_dev = alloc_dax(private, host, ops);
+
+	if (dax_dev)
+		dax_dev->pgmap = pgmap;
+	return dax_dev;
+}
+EXPORT_SYMBOL_GPL(alloc_dax_devmap);
+
 void put_dax(struct dax_device *dax_dev)
 {
 	if (!dax_dev)
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index cf074b1ce219..bbe3044c1b26 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -407,7 +407,8 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_res);
 	disk->bb = &pmem->bb;
 
-	dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops);
+	dax_dev = alloc_dax_devmap(pmem, disk->disk_name, &pmem_dax_ops,
+			&pmem->pgmap);
 	if (!dax_dev) {
 		put_disk(disk);
 		return -ENOMEM;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 38f9222606ee..b0d6d9954945 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -171,7 +171,7 @@ static void ext2_put_super (struct super_block * sb)
 	brelse (sbi->s_sbh);
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
-	fs_put_dax(sbi->s_daxdev);
+	fs_dax_release(sbi->s_daxdev, sb);
 	kfree(sbi);
 }
 
@@ -814,7 +814,7 @@ static unsigned long descriptor_loc(struct super_block *sb,
 
 static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 {
-	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
+	struct dax_device *dax_dev = fs_dax_claim_bdev(sb->s_bdev, sb);
 	struct buffer_head * bh;
 	struct ext2_sb_info * sbi;
 	struct ext2_super_block * es;
@@ -1210,7 +1210,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 failed:
-	fs_put_dax(dax_dev);
+	fs_dax_release(dax_dev, sb);
 	return ret;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 18873ea89e08..238cad596733 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -950,7 +950,7 @@ static void ext4_put_super(struct super_block *sb)
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
 	kfree(sbi->s_blockgroup_lock);
-	fs_put_dax(sbi->s_daxdev);
+	fs_dax_release(sbi->s_daxdev, sb);
 	kfree(sbi);
 }
 
@@ -3396,7 +3396,7 @@ static void ext4_set_resv_clusters(struct super_block *sb)
 
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 {
-	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
+	struct dax_device *dax_dev = fs_dax_claim_bdev(sb->s_bdev, sb);
 	char *orig_data = kstrdup(data, GFP_KERNEL);
 	struct buffer_head *bh;
 	struct ext4_super_block *es = NULL;
@@ -4406,7 +4406,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 out_free_base:
 	kfree(sbi);
 	kfree(orig_data);
-	fs_put_dax(dax_dev);
+	fs_dax_release(dax_dev, sb);
 	return err ? err : ret;
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5122d3021117..8ff821f3bcfb 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -722,7 +722,7 @@ xfs_close_devices(
 
 		xfs_free_buftarg(mp, mp->m_logdev_targp);
 		xfs_blkdev_put(logdev);
-		fs_put_dax(dax_logdev);
+		fs_dax_release(dax_logdev, mp);
 	}
 	if (mp->m_rtdev_targp) {
 		struct block_device *rtdev = mp->m_rtdev_targp->bt_bdev;
@@ -730,10 +730,10 @@ xfs_close_devices(
 
 		xfs_free_buftarg(mp, mp->m_rtdev_targp);
 		xfs_blkdev_put(rtdev);
-		fs_put_dax(dax_rtdev);
+		fs_dax_release(dax_rtdev, mp);
 	}
 	xfs_free_buftarg(mp, mp->m_ddev_targp);
-	fs_put_dax(dax_ddev);
+	fs_dax_release(dax_ddev, mp);
 }
 
 /*
@@ -751,9 +751,9 @@ xfs_open_devices(
 	struct xfs_mount	*mp)
 {
 	struct block_device	*ddev = mp->m_super->s_bdev;
-	struct dax_device	*dax_ddev = fs_dax_get_by_bdev(ddev);
-	struct dax_device	*dax_logdev = NULL, *dax_rtdev = NULL;
+	struct dax_device	*dax_ddev = fs_dax_claim_bdev(ddev, mp);
 	struct block_device	*logdev = NULL, *rtdev = NULL;
+	struct dax_device	*dax_logdev = NULL, *dax_rtdev = NULL;
 	int			error;
 
 	/*
@@ -763,7 +763,7 @@ xfs_open_devices(
 		error = xfs_blkdev_get(mp, mp->m_logname, &logdev);
 		if (error)
 			goto out;
-		dax_logdev = fs_dax_get_by_bdev(logdev);
+		dax_logdev = fs_dax_claim_bdev(logdev, mp);
 	}
 
 	if (mp->m_rtname) {
@@ -777,7 +777,7 @@ xfs_open_devices(
 			error = -EINVAL;
 			goto out_close_rtdev;
 		}
-		dax_rtdev = fs_dax_get_by_bdev(rtdev);
+		dax_rtdev = fs_dax_claim_bdev(rtdev, mp);
 	}
 
 	/*
@@ -811,14 +811,14 @@ xfs_open_devices(
 	xfs_free_buftarg(mp, mp->m_ddev_targp);
  out_close_rtdev:
 	xfs_blkdev_put(rtdev);
-	fs_put_dax(dax_rtdev);
+	fs_dax_release(dax_rtdev, mp);
  out_close_logdev:
 	if (logdev && logdev != ddev) {
 		xfs_blkdev_put(logdev);
-		fs_put_dax(dax_logdev);
+		fs_dax_release(dax_logdev, mp);
 	}
  out:
-	fs_put_dax(dax_ddev);
+	fs_dax_release(dax_ddev, mp);
 	return error;
 }
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 5258346c558c..1c6ed44fe9fc 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -51,12 +51,8 @@ static inline struct dax_device *fs_dax_get_by_host(const char *host)
 	return dax_get_by_host(host);
 }
 
-static inline void fs_put_dax(struct dax_device *dax_dev)
-{
-	put_dax(dax_dev);
-}
-
-struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
+struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *owner);
+void fs_dax_release(struct dax_device *dax_dev, void *owner);
 #else
 static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
@@ -68,13 +64,14 @@ static inline struct dax_device *fs_dax_get_by_host(const char *host)
 	return NULL;
 }
 
-static inline void fs_put_dax(struct dax_device *dax_dev)
+static inline struct dax_device *fs_dax_claim_bdev(struct block_device *bdev,
+		void *owner)
 {
+	return NULL;
 }
 
-static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
+static inline void fs_dax_release(struct dax_device *dax_dev, void *owner)
 {
-	return NULL;
 }
 #endif
 
@@ -82,6 +79,8 @@ int dax_read_lock(void);
 void dax_read_unlock(int id);
 struct dax_device *alloc_dax(void *private, const char *host,
 		const struct dax_operations *ops);
+struct dax_device *alloc_dax_devmap(void *private, const char *host,
+		const struct dax_operations *ops, struct dev_pagemap *pgmap);
 bool dax_alive(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 7b4899c06f49..02d6d042ee7f 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -53,11 +53,19 @@ struct vmem_altmap {
  * driver can hotplug the device memory using ZONE_DEVICE and with that memory
  * type. Any page of a process can be migrated to such memory. However no one
  * should be allow to pin such memory so that it can always be evicted.
+ *
+ * MEMORY_DEVICE_FS_DAX:
+ * When MEMORY_DEVICE_HOST memory is represented by a device that can
+ * host a filesystem, for example /dev/pmem0, that filesystem can
+ * register for a callback when a page is idled. For the filesystem-dax
+ * case page idle callbacks are used to coordinate DMA vs
+ * hole-punch/truncate.
  */
 enum memory_type {
 	MEMORY_DEVICE_HOST = 0,
 	MEMORY_DEVICE_PRIVATE,
 	MEMORY_DEVICE_PUBLIC,
+	MEMORY_DEVICE_FS_DAX,
 };
 
 /*


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:63411 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752598AbeCaEM7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 31 Mar 2018 00:12:59 -0400
Subject: [PATCH v8 10/18] dax, dm: introduce ->fs_{claim,
 release}() dax_device infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Mar 2018 21:03:03 -0700
Message-ID: <152246898322.36038.17918469633893320678.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, david@fromorbit.com, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.orgjack@suse.czsnitzer@redhat.com

In preparation for allowing filesystems to augment the dev_pagemap
associated with a dax_device, add an ->fs_claim() callback. The
->fs_claim() callback is leveraged by the device-mapper dax
implementation to iterate all member devices in the map and repeat the
claim operation across the array.

In order to resolve collisions between filesystem operations and DMA to
DAX mapped pages we need a callback when DMA completes. With a callback
we can hold off filesystem operations while DMA is in-flight and then
resume those operations when the last put_page() occurs on a DMA page.
The ->fs_claim() operation arranges for this callback to be registered,
although that implementation is saved for a later patch.

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c      |   80 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c          |   56 ++++++++++++++++++++++++++++++++
 include/linux/dax.h      |   16 +++++++++
 include/linux/memremap.h |    8 +++++
 4 files changed, 160 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 2b2332b605e4..c4cf284dfe1c 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -29,6 +29,7 @@ static struct vfsmount *dax_mnt;
 static DEFINE_IDA(dax_minor_ida);
 static struct kmem_cache *dax_cache __read_mostly;
 static struct super_block *dax_superblock __read_mostly;
+static DEFINE_MUTEX(devmap_lock);
 
 #define DAX_HASH_SIZE (PAGE_SIZE / sizeof(struct hlist_head))
 static struct hlist_head dax_host_list[DAX_HASH_SIZE];
@@ -169,9 +170,88 @@ struct dax_device {
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
+struct dax_device *fs_dax_claim(struct dax_device *dax_dev, void *owner)
+{
+	struct dev_pagemap *pgmap;
+
+	if (!dax_dev->pgmap)
+		return dax_dev;
+	pgmap = dax_dev->pgmap;
+
+	mutex_lock(&devmap_lock);
+	if (pgmap->data && pgmap->data == owner) {
+		/* dm might try to claim the same device more than once... */
+		mutex_unlock(&devmap_lock);
+		return dax_dev;
+	} else if (pgmap->page_free || pgmap->page_fault
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
+EXPORT_SYMBOL_GPL(fs_dax_claim);
+
+struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *owner)
+{
+	struct dax_device *dax_dev;
+
+	if (!blk_queue_dax(bdev->bd_queue))
+		return NULL;
+	dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
+	if (dax_dev->ops->fs_claim)
+		return dax_dev->ops->fs_claim(dax_dev, owner);
+	else
+		return fs_dax_claim(dax_dev, owner);
+}
+EXPORT_SYMBOL_GPL(fs_dax_claim_bdev);
+
+void __fs_dax_release(struct dax_device *dax_dev, void *owner)
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
+EXPORT_SYMBOL_GPL(__fs_dax_release);
+
+void fs_dax_release(struct dax_device *dax_dev, void *owner)
+{
+	if (dax_dev->ops->fs_release)
+		dax_dev->ops->fs_release(dax_dev, owner);
+	else
+		__fs_dax_release(dax_dev, owner);
+}
+EXPORT_SYMBOL_GPL(fs_dax_release);
+#endif
+
 static ssize_t write_cache_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ffc93aecc02a..964cb7537f11 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1090,6 +1090,60 @@ static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 	return ret;
 }
 
+static int dm_dax_dev_claim(struct dm_target *ti, struct dm_dev *dev,
+		sector_t start, sector_t len, void *owner)
+{
+	if (fs_dax_claim(dev->dax_dev, owner))
+		return 0;
+	/*
+	 * Outside of a kernel bug there is no reason a dax_dev should
+	 * fail a claim attempt. Device-mapper should have exclusive
+	 * ownership of the dm_dev and the filesystem should have
+	 * exclusive ownership of the dm_target.
+	 */
+	WARN_ON_ONCE(1);
+	return -ENXIO;
+}
+
+static int dm_dax_dev_release(struct dm_target *ti, struct dm_dev *dev,
+		sector_t start, sector_t len, void *owner)
+{
+	__fs_dax_release(dev->dax_dev, owner);
+	return 0;
+}
+
+static struct dax_device *dm_dax_iterate(struct dax_device *dax_dev,
+		iterate_devices_callout_fn fn, void *arg)
+{
+	struct mapped_device *md = dax_get_private(dax_dev);
+	struct dm_table *map;
+	struct dm_target *ti;
+	int i, srcu_idx;
+
+	map = dm_get_live_table(md, &srcu_idx);
+
+	for (i = 0; i < dm_table_get_num_targets(map); i++) {
+		ti = dm_table_get_target(map, i);
+
+		if (ti->type->iterate_devices)
+			ti->type->iterate_devices(ti, fn, arg);
+	}
+
+	dm_put_live_table(md, srcu_idx);
+	return dax_dev;
+}
+
+static struct dax_device *dm_dax_fs_claim(struct dax_device *dax_dev,
+		void *owner)
+{
+	return dm_dax_iterate(dax_dev, dm_dax_dev_claim, owner);
+}
+
+static void dm_dax_fs_release(struct dax_device *dax_dev, void *owner)
+{
+	dm_dax_iterate(dax_dev, dm_dax_dev_release, owner);
+}
+
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH and REQ_OP_ZONE_RESET.
@@ -3111,6 +3165,8 @@ static const struct block_device_operations dm_blk_dops = {
 static const struct dax_operations dm_dax_ops = {
 	.direct_access = dm_dax_direct_access,
 	.copy_from_iter = dm_dax_copy_from_iter,
+	.fs_claim = dm_dax_fs_claim,
+	.fs_release = dm_dax_fs_release,
 };
 
 /*
diff --git a/include/linux/dax.h b/include/linux/dax.h
index f9eb22ad341e..e9d59a6b06e1 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -20,6 +20,10 @@ struct dax_operations {
 	/* copy_from_iter: required operation for fs-dax direct-i/o */
 	size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
 			struct iov_iter *);
+	/* fs_claim: setup filesytem parameters for the device's dev_pagemap */
+	struct dax_device *(*fs_claim)(struct dax_device *, void *);
+	/* fs_release: restore device's dev_pagemap to its default state */
+	void (*fs_release)(struct dax_device *, void *);
 };
 
 extern struct attribute_group dax_attribute_group;
@@ -83,6 +87,8 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
 struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
 int dax_writeback_mapping_range(struct address_space *mapping,
 		struct block_device *bdev, struct writeback_control *wbc);
+struct dax_device *fs_dax_claim(struct dax_device *dax_dev, void *owner);
+void __fs_dax_release(struct dax_device *dax_dev, void *owner);
 #else
 static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
@@ -108,6 +114,16 @@ static inline int dax_writeback_mapping_range(struct address_space *mapping,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline struct dax_device *fs_dax_claim(struct dax_device *dax_dev,
+		void *owner)
+{
+	return NULL;
+}
+
+static inline void __fs_dax_release(struct dax_device *dax_dev, void *owner)
+{
+}
 #endif
 
 int dax_read_lock(void);
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


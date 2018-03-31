Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:25302 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752957AbeCaENQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 31 Mar 2018 00:13:16 -0400
Subject: [PATCH v8 13/18] mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Mar 2018 21:03:19 -0700
Message-ID: <152246899919.36038.9145086226090928099.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Michal Hocko <mhocko@suse.com>, Thomas Meyer <thomas@m3y3r.de>, Christoph Hellwig <hch@lst.de>, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Jan Kara <jack@suse.cz>, david@fromorbit.com, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.orgjack@suse.cz, snitzer@redhat.com

The HMM sub-system extended dev_pagemap to arrange a callback when a
dev_pagemap managed page is freed. Since a dev_pagemap page is free /
idle when its reference count is 1 it requires an additional branch to
check the page-type at put_page() time. Given put_page() is a hot-path
we do not want to incur that check if HMM is not in use, so a static
branch is used to avoid that overhead when not necessary.

Now, the FS_DAX implementation wants to reuse this mechanism for
receiving dev_pagemap ->page_free() callbacks. Rework the HMM-specific
static-key into a generic mechanism that either HMM or FS_DAX code paths
can enable.

For ARCH=um builds, and any other arch that lacks ZONE_DEVICE support,
care must be taken to compile out the DEV_PAGEMAP_OPS infrastructure.
However, we still need to support FS_DAX in the FS_DAX_LIMITED case
implemented by the s390/dcssblk driver.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Reported-by: Thomas Meyer <thomas@m3y3r.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Jérôme Glisse" <jglisse@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c      |    4 ++-
 fs/Kconfig               |    1 +
 include/linux/dax.h      |   35 ++++++++++++++++-------
 include/linux/memremap.h |   17 -----------
 include/linux/mm.h       |   71 ++++++++++++++++++++++++++++++++++------------
 kernel/memremap.c        |   30 +++++++++++++++++--
 mm/Kconfig               |    5 +++
 mm/hmm.c                 |   13 +-------
 mm/swap.c                |    3 +-
 9 files changed, 116 insertions(+), 63 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 7d260f118a39..3bafaddd02f1 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -164,7 +164,7 @@ struct dax_device {
 	const struct dax_operations *ops;
 };
 
-#if IS_ENABLED(CONFIG_FS_DAX)
+#if IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS)
 static void generic_dax_pagefree(struct page *page, void *data)
 {
 	/* TODO: wakeup page-idle waiters */
@@ -190,6 +190,7 @@ struct dax_device *fs_dax_claim(struct dax_device *dax_dev, void *owner)
 		return NULL;
 	}
 
+	dev_pagemap_get_ops();
 	pgmap->type = MEMORY_DEVICE_FS_DAX;
 	pgmap->page_free = generic_dax_pagefree;
 	pgmap->data = owner;
@@ -228,6 +229,7 @@ void __fs_dax_release(struct dax_device *dax_dev, void *owner)
 	pgmap->type = MEMORY_DEVICE_HOST;
 	pgmap->page_free = NULL;
 	pgmap->data = NULL;
+	dev_pagemap_put_ops();
 	mutex_unlock(&devmap_lock);
 }
 EXPORT_SYMBOL_GPL(__fs_dax_release);
diff --git a/fs/Kconfig b/fs/Kconfig
index bc821a86d965..1e050e012eb9 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -38,6 +38,7 @@ config FS_DAX
 	bool "Direct Access (DAX) support"
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
+	select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
 	select FS_IOMAP
 	select DAX
 	help
diff --git a/include/linux/dax.h b/include/linux/dax.h
index a88ff009e2a1..a36b74aa96e8 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -4,6 +4,7 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/genhd.h>
 #include <linux/radix-tree.h>
 #include <asm/pgtable.h>
 
@@ -87,12 +88,8 @@ static inline struct dax_device *fs_dax_get_by_host(const char *host)
 	return dax_get_by_host(host);
 }
 
-struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *owner);
-void fs_dax_release(struct dax_device *dax_dev, void *owner);
 int dax_writeback_mapping_range(struct address_space *mapping,
 		struct block_device *bdev, struct writeback_control *wbc);
-struct dax_device *fs_dax_claim(struct dax_device *dax_dev, void *owner);
-void __fs_dax_release(struct dax_device *dax_dev, void *owner);
 #else
 static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
@@ -104,26 +101,42 @@ static inline struct dax_device *fs_dax_get_by_host(const char *host)
 	return NULL;
 }
 
+static inline int dax_writeback_mapping_range(struct address_space *mapping,
+		struct block_device *bdev, struct writeback_control *wbc)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+#if IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS)
+struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *owner);
+struct dax_device *fs_dax_claim(struct dax_device *dax_dev, void *owner);
+void __fs_dax_release(struct dax_device *dax_dev, void *owner);
+void fs_dax_release(struct dax_device *dax_dev, void *owner);
+#else
+#ifdef CONFIG_BLOCK
 static inline struct dax_device *fs_dax_claim_bdev(struct block_device *bdev,
 		void *owner)
 {
-	return NULL;
+	return fs_dax_get_by_host(bdev->bd_disk->disk_name);
 }
-
-static inline void fs_dax_release(struct dax_device *dax_dev, void *owner)
+#else
+static inline struct dax_device *fs_dax_claim_bdev(struct block_device *bdev,
+		void *owner)
 {
+	return NULL;
 }
+#endif
 
-static inline int dax_writeback_mapping_range(struct address_space *mapping,
-		struct block_device *bdev, struct writeback_control *wbc)
+static inline void fs_dax_release(struct dax_device *dax_dev, void *owner)
 {
-	return -EOPNOTSUPP;
+	put_dax(dax_dev);
 }
 
 static inline struct dax_device *fs_dax_claim(struct dax_device *dax_dev,
 		void *owner)
 {
-	return NULL;
+	return dax_dev;
 }
 
 static inline void __fs_dax_release(struct dax_device *dax_dev, void *owner)
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 02d6d042ee7f..8cc619fe347b 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_MEMREMAP_H_
 #define _LINUX_MEMREMAP_H_
-#include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/percpu-refcount.h>
 
@@ -137,8 +136,6 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
 void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns);
-
-static inline bool is_zone_device_page(const struct page *page);
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct dev_pagemap *pgmap)
@@ -169,20 +166,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif /* CONFIG_ZONE_DEVICE */
 
-#if defined(CONFIG_DEVICE_PRIVATE) || defined(CONFIG_DEVICE_PUBLIC)
-static inline bool is_device_private_page(const struct page *page)
-{
-	return is_zone_device_page(page) &&
-		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
-}
-
-static inline bool is_device_public_page(const struct page *page)
-{
-	return is_zone_device_page(page) &&
-		page->pgmap->type == MEMORY_DEVICE_PUBLIC;
-}
-#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
-
 static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
 {
 	if (pgmap)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ad06d42adb1a..be9969e3cf09 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -812,27 +812,65 @@ static inline bool is_zone_device_page(const struct page *page)
 }
 #endif
 
-#if defined(CONFIG_DEVICE_PRIVATE) || defined(CONFIG_DEVICE_PUBLIC)
-void put_zone_device_private_or_public_page(struct page *page);
-DECLARE_STATIC_KEY_FALSE(device_private_key);
-#define IS_HMM_ENABLED static_branch_unlikely(&device_private_key)
-static inline bool is_device_private_page(const struct page *page);
-static inline bool is_device_public_page(const struct page *page);
-#else /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
-static inline void put_zone_device_private_or_public_page(struct page *page)
+#ifdef CONFIG_DEV_PAGEMAP_OPS
+void dev_pagemap_get_ops(void);
+void dev_pagemap_put_ops(void);
+void __put_devmap_managed_page(struct page *page);
+DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
+static inline bool put_devmap_managed_page(struct page *page)
+{
+	if (!static_branch_unlikely(&devmap_managed_key))
+		return false;
+	if (!is_zone_device_page(page))
+		return false;
+	switch (page->pgmap->type) {
+	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_PUBLIC:
+	case MEMORY_DEVICE_FS_DAX:
+		__put_devmap_managed_page(page);
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+static inline bool is_device_private_page(const struct page *page)
 {
+	return is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
 }
-#define IS_HMM_ENABLED 0
+
+static inline bool is_device_public_page(const struct page *page)
+{
+	return is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_PUBLIC;
+}
+
+#else /* CONFIG_DEV_PAGEMAP_OPS */
+static inline void dev_pagemap_get_ops(void)
+{
+}
+
+static inline void dev_pagemap_put_ops(void)
+{
+}
+
+static inline bool put_devmap_managed_page(struct page *page)
+{
+	return false;
+}
+
 static inline bool is_device_private_page(const struct page *page)
 {
 	return false;
 }
+
 static inline bool is_device_public_page(const struct page *page)
 {
 	return false;
 }
-#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
-
+#endif /* CONFIG_DEV_PAGEMAP_OPS */
 
 static inline void get_page(struct page *page)
 {
@@ -850,16 +888,13 @@ static inline void put_page(struct page *page)
 	page = compound_head(page);
 
 	/*
-	 * For private device pages we need to catch refcount transition from
-	 * 2 to 1, when refcount reach one it means the private device page is
-	 * free and we need to inform the device driver through callback. See
+	 * For devmap managed pages we need to catch refcount transition from
+	 * 2 to 1, when refcount reach one it means the page is free and we
+	 * need to inform the device driver through callback. See
 	 * include/linux/memremap.h and HMM for details.
 	 */
-	if (IS_HMM_ENABLED && unlikely(is_device_private_page(page) ||
-	    unlikely(is_device_public_page(page)))) {
-		put_zone_device_private_or_public_page(page);
+	if (put_devmap_managed_page(page))
 		return;
-	}
 
 	if (put_page_testzero(page))
 		__put_page(page);
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 52a2742f527f..07a6a405cf3d 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -302,8 +302,30 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 	return pgmap;
 }
 
-#if IS_ENABLED(CONFIG_DEVICE_PRIVATE) ||  IS_ENABLED(CONFIG_DEVICE_PUBLIC)
-void put_zone_device_private_or_public_page(struct page *page)
+#ifdef CONFIG_DEV_PAGEMAP_OPS
+DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
+EXPORT_SYMBOL_GPL(devmap_managed_key);
+static atomic_t devmap_enable;
+
+/*
+ * Toggle the static key for ->page_free() callbacks when dev_pagemap
+ * pages go idle.
+ */
+void dev_pagemap_get_ops(void)
+{
+	if (atomic_inc_return(&devmap_enable) == 1)
+		static_branch_enable(&devmap_managed_key);
+}
+EXPORT_SYMBOL_GPL(dev_pagemap_get_ops);
+
+void dev_pagemap_put_ops(void)
+{
+	if (atomic_dec_and_test(&devmap_enable))
+		static_branch_disable(&devmap_managed_key);
+}
+EXPORT_SYMBOL_GPL(dev_pagemap_put_ops);
+
+void __put_devmap_managed_page(struct page *page)
 {
 	int count = page_ref_dec_return(page);
 
@@ -323,5 +345,5 @@ void put_zone_device_private_or_public_page(struct page *page)
 	} else if (!count)
 		__put_page(page);
 }
-EXPORT_SYMBOL(put_zone_device_private_or_public_page);
-#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
+EXPORT_SYMBOL_GPL(__put_devmap_managed_page);
+#endif /* CONFIG_DEV_PAGEMAP_OPS */
diff --git a/mm/Kconfig b/mm/Kconfig
index c782e8fb7235..dc32828984a3 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -700,6 +700,9 @@ config ARCH_HAS_HMM
 config MIGRATE_VMA_HELPER
 	bool
 
+config DEV_PAGEMAP_OPS
+	bool
+
 config HMM
 	bool
 	select MIGRATE_VMA_HELPER
@@ -720,6 +723,7 @@ config DEVICE_PRIVATE
 	bool "Unaddressable device memory (GPU memory, ...)"
 	depends on ARCH_HAS_HMM
 	select HMM
+	select DEV_PAGEMAP_OPS
 
 	help
 	  Allows creation of struct pages to represent unaddressable device
@@ -730,6 +734,7 @@ config DEVICE_PUBLIC
 	bool "Addressable device memory (like GPU memory)"
 	depends on ARCH_HAS_HMM
 	select HMM
+	select DEV_PAGEMAP_OPS
 
 	help
 	  Allows creation of struct pages to represent addressable device
diff --git a/mm/hmm.c b/mm/hmm.c
index 320545b98ff5..4aa554e76d06 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -35,15 +35,6 @@
 
 #define PA_SECTION_SIZE (1UL << PA_SECTION_SHIFT)
 
-#if defined(CONFIG_DEVICE_PRIVATE) || defined(CONFIG_DEVICE_PUBLIC)
-/*
- * Device private memory see HMM (Documentation/vm/hmm.txt) or hmm.h
- */
-DEFINE_STATIC_KEY_FALSE(device_private_key);
-EXPORT_SYMBOL(device_private_key);
-#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
-
-
 #if IS_ENABLED(CONFIG_HMM_MIRROR)
 static const struct mmu_notifier_ops hmm_mmu_notifier_ops;
 
@@ -996,7 +987,7 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
 	resource_size_t addr;
 	int ret;
 
-	static_branch_enable(&device_private_key);
+	dev_pagemap_get_ops();
 
 	devmem = devres_alloc_node(&hmm_devmem_release, sizeof(*devmem),
 				   GFP_KERNEL, dev_to_node(device));
@@ -1090,7 +1081,7 @@ struct hmm_devmem *hmm_devmem_add_resource(const struct hmm_devmem_ops *ops,
 	if (res->desc != IORES_DESC_DEVICE_PUBLIC_MEMORY)
 		return ERR_PTR(-EINVAL);
 
-	static_branch_enable(&device_private_key);
+	dev_pagemap_get_ops();
 
 	devmem = devres_alloc_node(&hmm_devmem_release, sizeof(*devmem),
 				   GFP_KERNEL, dev_to_node(device));
diff --git a/mm/swap.c b/mm/swap.c
index 0f17330dd0e5..eed846cfc8b8 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -29,6 +29,7 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/backing-dev.h>
+#include <linux/memremap.h>
 #include <linux/memcontrol.h>
 #include <linux/gfp.h>
 #include <linux/uio.h>
@@ -744,7 +745,7 @@ void release_pages(struct page **pages, int nr)
 						       flags);
 				locked_pgdat = NULL;
 			}
-			put_zone_device_private_or_public_page(page);
+			put_devmap_managed_page(page);
 			continue;
 		}
 


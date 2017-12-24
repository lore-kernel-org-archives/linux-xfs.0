Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:2363 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756541AbdLXBFI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Dec 2017 20:05:08 -0500
Subject: [PATCH v4 10/18] mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Dec 2017 16:56:53 -0800
Message-ID: <151407701384.38751.18357520725643239723.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c      |    2 ++
 fs/Kconfig               |    1 +
 include/linux/memremap.h |   20 ++-------------
 include/linux/mm.h       |   61 ++++++++++++++++++++++++++++++++--------------
 kernel/memremap.c        |   30 ++++++++++++++++++++---
 mm/Kconfig               |    5 ++++
 mm/hmm.c                 |   13 ++--------
 mm/swap.c                |    3 ++
 8 files changed, 84 insertions(+), 51 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e926e373a3a5..0352a098b099 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -191,6 +191,7 @@ struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *owner)
 		return NULL;
 	}
 
+	dev_pagemap_enable_ops();
 	pgmap->type = MEMORY_DEVICE_FS_DAX;
 	pgmap->page_free = generic_dax_pagefree;
 	pgmap->data = owner;
@@ -215,6 +216,7 @@ void fs_dax_release(struct dax_device *dax_dev, void *owner)
 	pgmap->type = MEMORY_DEVICE_HOST;
 	pgmap->page_free = NULL;
 	pgmap->data = NULL;
+	dev_pagemap_disable_ops();
 	mutex_unlock(&devmap_lock);
 }
 EXPORT_SYMBOL_GPL(fs_dax_release);
diff --git a/fs/Kconfig b/fs/Kconfig
index b40128bf6d1a..73fe372c00db 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -38,6 +38,7 @@ config FS_DAX
 	bool "Direct Access (DAX) support"
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
+	select DEV_PAGEMAP_OPS
 	select FS_IOMAP
 	select DAX
 	help
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 02d6d042ee7f..60c7608379ca 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_MEMREMAP_H_
 #define _LINUX_MEMREMAP_H_
-#include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/percpu-refcount.h>
 
@@ -130,6 +129,9 @@ struct dev_pagemap {
 	enum memory_type type;
 };
 
+void dev_pagemap_enable_ops(void);
+void dev_pagemap_disable_ops(void);
+
 #ifdef CONFIG_ZONE_DEVICE
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
@@ -137,8 +139,6 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
 void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns);
-
-static inline bool is_zone_device_page(const struct page *page);
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct dev_pagemap *pgmap)
@@ -169,20 +169,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
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
index dc124b278173..fda3d7dcddc3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -812,27 +812,55 @@ static inline bool is_zone_device_page(const struct page *page)
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
+void __put_devmap_managed_page(struct page *page);
+DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
+static inline bool put_devmap_managed_page(struct page *page)
 {
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
 }
-#define IS_HMM_ENABLED 0
+
 static inline bool is_device_private_page(const struct page *page)
 {
-	return false;
+	return is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
 }
+
 static inline bool is_device_public_page(const struct page *page)
 {
+	return is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_PUBLIC;
+}
+
+#else /* CONFIG_DEV_PAGEMAP_OPS */
+static inline bool put_devmap_managed_page(struct page *page)
+{
 	return false;
 }
-#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
 
+static inline bool is_device_private_page(const struct page *page)
+{
+	return false;
+}
+
+static inline bool is_device_public_page(const struct page *page)
+{
+	return false;
+}
+#endif /* CONFIG_DEV_PAGEMAP_OPS */
 
 static inline void get_page(struct page *page)
 {
@@ -850,16 +878,13 @@ static inline void put_page(struct page *page)
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
index c04000361664..bad64045b546 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -467,8 +467,30 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 }
 #endif /* CONFIG_ZONE_DEVICE */
 
-#if IS_ENABLED(CONFIG_DEVICE_PRIVATE) ||  IS_ENABLED(CONFIG_DEVICE_PUBLIC)
-void put_zone_device_private_or_public_page(struct page *page)
+#ifdef CONFIG_DEV_PAGEMAP_OPS
+DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
+EXPORT_SYMBOL(devmap_managed_key);
+static atomic_t devmap_enable;
+
+/*
+ * Toggle the static key for ->page_free() callbacks when dev_pagemap
+ * pages go idle.
+ */
+void dev_pagemap_enable_ops(void)
+{
+	if (atomic_inc_return(&devmap_enable) == 1)
+		static_branch_enable(&devmap_managed_key);
+}
+EXPORT_SYMBOL(dev_pagemap_enable_ops);
+
+void dev_pagemap_disable_ops(void)
+{
+	if (atomic_dec_and_test(&devmap_enable))
+		static_branch_disable(&devmap_managed_key);
+}
+EXPORT_SYMBOL(dev_pagemap_disable_ops);
+
+void __put_devmap_managed_page(struct page *page)
 {
 	int count = page_ref_dec_return(page);
 
@@ -488,5 +510,5 @@ void put_zone_device_private_or_public_page(struct page *page)
 	} else if (!count)
 		__put_page(page);
 }
-EXPORT_SYMBOL(put_zone_device_private_or_public_page);
-#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
+EXPORT_SYMBOL(__put_devmap_managed_page);
+#endif /* CONFIG_DEV_PAGEMAP_OPS */
diff --git a/mm/Kconfig b/mm/Kconfig
index 03ff7703d322..f8cf32411e1a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -705,6 +705,9 @@ config ARCH_HAS_HMM
 config MIGRATE_VMA_HELPER
 	bool
 
+config DEV_PAGEMAP_OPS
+	bool
+
 config HMM
 	bool
 	select MIGRATE_VMA_HELPER
@@ -725,6 +728,7 @@ config DEVICE_PRIVATE
 	bool "Unaddressable device memory (GPU memory, ...)"
 	depends on ARCH_HAS_HMM
 	select HMM
+	select DEV_PAGEMAP_OPS
 
 	help
 	  Allows creation of struct pages to represent unaddressable device
@@ -735,6 +739,7 @@ config DEVICE_PUBLIC
 	bool "Addressable device memory (like GPU memory)"
 	depends on ARCH_HAS_HMM
 	select HMM
+	select DEV_PAGEMAP_OPS
 
 	help
 	  Allows creation of struct pages to represent addressable device
diff --git a/mm/hmm.c b/mm/hmm.c
index ee75b2923dde..a27b4ae12823 100644
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
 
@@ -998,7 +989,7 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
 	resource_size_t addr;
 	int ret;
 
-	static_branch_enable(&device_private_key);
+	dev_pagemap_enable_ops();
 
 	devmem = devres_alloc_node(&hmm_devmem_release, sizeof(*devmem),
 				   GFP_KERNEL, dev_to_node(device));
@@ -1092,7 +1083,7 @@ struct hmm_devmem *hmm_devmem_add_resource(const struct hmm_devmem_ops *ops,
 	if (res->desc != IORES_DESC_DEVICE_PUBLIC_MEMORY)
 		return ERR_PTR(-EINVAL);
 
-	static_branch_enable(&device_private_key);
+	dev_pagemap_enable_ops();
 
 	devmem = devres_alloc_node(&hmm_devmem_release, sizeof(*devmem),
 				   GFP_KERNEL, dev_to_node(device));
diff --git a/mm/swap.c b/mm/swap.c
index 38e1b6374a97..f2acaa93637b 100644
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
@@ -772,7 +773,7 @@ void release_pages(struct page **pages, int nr)
 						       flags);
 				locked_pgdat = NULL;
 			}
-			put_zone_device_private_or_public_page(page);
+			put_devmap_managed_page(page);
 			continue;
 		}
 


Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 94A487CA0
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 01:57:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EAD00AC004
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 23:57:38 -0700 (PDT)
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31]) by
	cuda.sgi.com with ESMTP id ksLaoCd8Rr3RsihX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 14 Sep 2016 23:57:37 -0700 (PDT)
Subject: [PATCH v2 1/3] mm, dax: add VM_SYNC flag for device-dax VMAs
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Sep 2016 23:54:33 -0700
Message-ID: <147392247341.9873.312027612778133485.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-mm@kvack.org
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, npiggin@gmail.com, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, hch@lst.de

Introduce a new vma flag to indicate the property of device-dax VMAs
that, while file-backed, do not require notification to a filesystem
agent to sync metadata after a fault.  In particular this enables
persistent memory applications to know if they can commit transactions
to media via cpu instructions alone, or need to call back into the
kernel to synchronize metadata.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig |    1 +
 drivers/dax/dax.c   |    2 +-
 fs/proc/task_mmu.c  |    3 +++
 include/linux/mm.h  |   21 +++++++++++++++++----
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index cedab7572de3..a4d99e637623 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -2,6 +2,7 @@ menuconfig DEV_DAX
 	tristate "DAX: direct access to differentiated memory"
 	default m if NVDIMM_DAX
 	depends on TRANSPARENT_HUGEPAGE
+	select ARCH_USES_HIGH_VMA_FLAGS if 64BIT
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 29f600f2c447..88fad2519907 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -528,7 +528,7 @@ static int dax_dev_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	kref_get(&dax_dev->kref);
 	vma->vm_ops = &dax_dev_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE | VM_SYNC;
 	return 0;
 
 }
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index f6fa99eca515..03a65ac7f222 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -675,6 +675,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_PKEY_BIT2)]	= "",
 		[ilog2(VM_PKEY_BIT3)]	= "",
 #endif
+#ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
+		[ilog2(VM_SYNC)]	= "sn",
+#endif
 	};
 	size_t i;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ef815b9cd426..f3f6df6bb498 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -198,14 +198,17 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
 
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
-#define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
-#define VM_HIGH_ARCH_BIT_1	33	/* bit only usable on 64-bit architectures */
-#define VM_HIGH_ARCH_BIT_2	34	/* bit only usable on 64-bit architectures */
-#define VM_HIGH_ARCH_BIT_3	35	/* bit only usable on 64-bit architectures */
+/* bits below only usable on 64-bit architectures */
+#define VM_HIGH_ARCH_BIT_0	32
+#define VM_HIGH_ARCH_BIT_1	33
+#define VM_HIGH_ARCH_BIT_2	34
+#define VM_HIGH_ARCH_BIT_3	35
+#define VM_HIGH_ARCH_BIT_4	36
 #define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
 #define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
 #define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
 #define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
+#define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
 #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
 
 #if defined(CONFIG_X86)
@@ -234,6 +237,16 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_MPX		VM_ARCH_2
 #endif
 
+#ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
+/*
+ * The metadata for file-backed vma does not exist or is otherwise
+ * synced before fault handler returns to userspace
+ */
+#define VM_SYNC		VM_HIGH_ARCH_4
+#else
+#define VM_SYNC		0
+#endif
+
 #ifndef VM_GROWSUP
 # define VM_GROWSUP	VM_NONE
 #endif

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 655427CA0
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 01:57:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F06228F8050
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 23:57:43 -0700 (PDT)
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31]) by
	cuda.sgi.com with ESMTP id iSPCNhIR7VVYzrzX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 14 Sep 2016 23:57:41 -0700 (PDT)
Subject: [PATCH v2 2/3] mm, dax: add VM_DAX flag for DAX VMAs
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Sep 2016 23:54:38 -0700
Message-ID: <147392247875.9873.4205533916442000884.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The DAX property, page cache bypass, of a VMA is only detectable via the
vma_is_dax() helper to check the S_DAX inode flag.  However, this is
only available internal to the kernel and is a property that userspace
applications would like to interrogate.

Yes, this new VM_DAX flag is only available on 64-bit, but the
expectation is that the capacities of persistent memory devices are too
large for 32-bit platforms.  While there is usage of DAX on 32-bit, that
usage is primarily driven by DAX's replacement of XIP.  XIP is a memory
saving technique for embedded devices to execute out of DAX, but in that
usage the application does not need to discern if page cache is present
or not.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c  |    2 +-
 fs/Kconfig         |    1 +
 fs/ext2/file.c     |    2 +-
 fs/ext4/file.c     |    2 +-
 fs/proc/task_mmu.c |    1 +
 fs/xfs/xfs_file.c  |    2 +-
 include/linux/mm.h |   10 ++++++++++
 7 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 88fad2519907..1cb4117870bd 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -528,7 +528,7 @@ static int dax_dev_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	kref_get(&dax_dev->kref);
 	vma->vm_ops = &dax_dev_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE | VM_SYNC;
+	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE | VM_SYNC | VM_DAX;
 	return 0;
 
 }
diff --git a/fs/Kconfig b/fs/Kconfig
index 2bc7ad775842..6d9afe4c1710 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -38,6 +38,7 @@ config FS_DAX
 	bool "Direct Access (DAX) support"
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
+	select ARCH_USES_HIGH_VMA_FLAGS if 64BIT
 	help
 	  Direct Access (DAX) can be used on memory-backed block devices.
 	  If the block device supports DAX and the filesystem supports DAX,
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 5efeefe17abb..b9c829cf427c 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -118,7 +118,7 @@ static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	file_accessed(file);
 	vma->vm_ops = &ext2_dax_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE | VM_DAX;
 	return 0;
 }
 #else
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 261ac3734c58..7a777f1bbde3 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -312,7 +312,7 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 	file_accessed(file);
 	if (IS_DAX(file_inode(file))) {
 		vma->vm_ops = &ext4_dax_vm_ops;
-		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE | VM_DAX;
 	} else {
 		vma->vm_ops = &ext4_file_vm_ops;
 	}
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 03a65ac7f222..b9b9dc059e19 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -677,6 +677,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 #endif
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
 		[ilog2(VM_SYNC)]	= "sn",
+		[ilog2(VM_DAX)]		= "dx",
 #endif
 	};
 	size_t i;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e612a0233710..80ed83405683 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1644,7 +1644,7 @@ xfs_file_mmap(
 	file_accessed(filp);
 	vma->vm_ops = &xfs_file_vm_ops;
 	if (IS_DAX(file_inode(filp)))
-		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE | VM_DAX;
 	return 0;
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f3f6df6bb498..5930402596c0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -204,11 +204,13 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HIGH_ARCH_BIT_2	34
 #define VM_HIGH_ARCH_BIT_3	35
 #define VM_HIGH_ARCH_BIT_4	36
+#define VM_HIGH_ARCH_BIT_5	37
 #define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
 #define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
 #define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
 #define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
 #define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
+#define VM_HIGH_ARCH_5	BIT(VM_HIGH_ARCH_BIT_5)
 #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
 
 #if defined(CONFIG_X86)
@@ -243,8 +245,16 @@ extern unsigned int kobjsize(const void *objp);
  * synced before fault handler returns to userspace
  */
 #define VM_SYNC		VM_HIGH_ARCH_4
+/*
+ * Mapping is not indirected through the page-cache, accesses hit memory
+ * media directly*.
+ *
+ * (*) a fileystem may map the zero-page into holes of a file.
+ */
+#define VM_DAX		VM_HIGH_ARCH_5
 #else
 #define VM_SYNC		0
+#define VM_DAX		0
 #endif
 
 #ifndef VM_GROWSUP

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

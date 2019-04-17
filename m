Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39625 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728486AbfDQB10 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 21:27:26 -0400
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 3/4] fs/dax: copy source blocks before writing when COW
Date: Wed, 17 Apr 2019 09:27:14 +0800
Message-ID: <20190417012715.8287-4-ruansy.fnst@cn.fujitsu.com>
In-Reply-To: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
References: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org

The actor functions get the source blocks' start address from
iomap->src_addr, and then copy these blocks to the new allocated
blocks before writing the user data.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
cc: linux-nvdimm@lists.01.org
---
 fs/dax.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index ca0671d55aa6..28519bdecf7c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -982,6 +982,11 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
 }
 
+static sector_t dax_iomap_src_sector(struct iomap *iomap, loff_t pos)
+{
+	return (iomap->src_addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
+}
+
 static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 			 pfn_t *pfnp)
 {
@@ -1014,6 +1019,51 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 	return rc;
 }
 
+static int dax_iomap_addr(struct iomap *iomap, sector_t sector, size_t size,
+			    void **kaddr)
+{
+	pgoff_t pgoff;
+	int id, rc;
+	long length;
+
+	rc = bdev_dax_pgoff(iomap->bdev, sector, size, &pgoff);
+	if (rc)
+		return rc;
+
+	id = dax_read_lock();
+	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
+					kaddr, NULL);
+	if (length < 0)
+		rc = length;
+	if (!*kaddr)
+		rc = -EFAULT;
+
+	dax_read_unlock(id);
+	return rc;
+}
+
+static int dax_iomap_cow_copy(struct iomap *iomap, loff_t pos, size_t size)
+{
+	void *kaddr = 0, *src_kaddr = 0;
+	int error = 0;
+	const sector_t src_sector = dax_iomap_src_sector(iomap, pos);
+	const sector_t sector = dax_iomap_sector(iomap, pos);
+
+	error = dax_iomap_addr(iomap, src_sector, size, &src_kaddr);
+	if (error < 0)
+		return error;
+	error = dax_iomap_addr(iomap, sector, size, &kaddr);
+	if (error < 0)
+		return error;
+
+	/*
+	 * Copy data from source blocks to the new allocated blocks before
+	 * writing user data.
+	 */
+	memcpy(kaddr, src_kaddr, size);
+	return 0;
+}
+
 /*
  * The user has performed a load from a hole in the file.  Allocating a new
  * page in the file would cause excessive storage usage for workloads with
@@ -1149,6 +1199,12 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		if (map_len > end - pos)
 			map_len = end - pos;
 
+		if (iomap->src_addr) {
+			ret = dax_iomap_cow_copy(iomap, pos, size);
+			if (ret < 0)
+				break;
+		}
+
 		/*
 		 * The userspace address for the memory copy has already been
 		 * validated via access_ok() in either vfs_read() or
@@ -1336,6 +1392,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
+
 		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
 		if (error < 0)
 			goto error_finish_iomap;
@@ -1358,6 +1415,13 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			ret = VM_FAULT_NEEDDSYNC | major;
 			goto finish_iomap;
 		}
+
+		if (iomap.src_addr) {
+			error = dax_iomap_cow_copy(&iomap, pos, PAGE_SIZE);
+			if (error < 0)
+				goto error_finish_iomap;
+		}
+
 		trace_dax_insert_mapping(inode, vmf, entry);
 		if (write)
 			ret = vmf_insert_mixed_mkwrite(vma, vaddr, pfn);
@@ -1559,6 +1623,12 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			goto finish_iomap;
 		}
 
+		if (iomap.src_addr) {
+			error = dax_iomap_cow_copy(&iomap, pos, PMD_SIZE);
+			if (error < 0)
+				goto finish_iomap;
+		}
+
 		trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, entry);
 		result = vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
 					    write);
-- 
2.17.0

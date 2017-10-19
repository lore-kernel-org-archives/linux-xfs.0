Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33986 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752274AbdJSNIl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Oct 2017 09:08:41 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/17] dax: Simplify arguments of dax_insert_mapping()
Date: Thu, 19 Oct 2017 14:58:02 +0200
Message-Id: <20171019125817.11580-4-jack@suse.cz>
In-Reply-To: <20171019125817.11580-1-jack@suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>

dax_insert_mapping() has lots of arguments and a lot of them is actuall
duplicated by passing vm_fault structure as well. Change the function to
take the same arguments as dax_pmd_insert_mapping().

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index f001d8c72a06..0bc42ac294ca 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -820,23 +820,30 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
-static int dax_insert_mapping(struct address_space *mapping,
-		struct block_device *bdev, struct dax_device *dax_dev,
-		sector_t sector, size_t size, void *entry,
-		struct vm_area_struct *vma, struct vm_fault *vmf)
+static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
+{
+	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
+}
+
+static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
+			      loff_t pos, void *entry)
 {
+	const sector_t sector = dax_iomap_sector(iomap, pos);
+	struct vm_area_struct *vma = vmf->vma;
+	struct address_space *mapping = vma->vm_file->f_mapping;
 	unsigned long vaddr = vmf->address;
 	void *ret, *kaddr;
 	pgoff_t pgoff;
 	int id, rc;
 	pfn_t pfn;
 
-	rc = bdev_dax_pgoff(bdev, sector, size, &pgoff);
+	rc = bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
 	if (rc)
 		return rc;
 
 	id = dax_read_lock();
-	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
+	rc = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(PAGE_SIZE),
+			       &kaddr, &pfn);
 	if (rc < 0) {
 		dax_read_unlock(id);
 		return rc;
@@ -936,11 +943,6 @@ int __dax_zero_page_range(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(__dax_zero_page_range);
 
-static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
-{
-	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
-}
-
 static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap)
@@ -1087,7 +1089,6 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
 	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
-	sector_t sector;
 	struct iomap iomap = { 0 };
 	unsigned flags = IOMAP_FAULT;
 	int error, major = 0;
@@ -1140,9 +1141,9 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 		goto error_finish_iomap;
 	}
 
-	sector = dax_iomap_sector(&iomap, pos);
-
 	if (vmf->cow_page) {
+		sector_t sector = dax_iomap_sector(&iomap, pos);
+
 		switch (iomap.type) {
 		case IOMAP_HOLE:
 		case IOMAP_UNWRITTEN:
@@ -1175,8 +1176,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 			count_memcg_event_mm(vmf->vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
-		error = dax_insert_mapping(mapping, iomap.bdev, iomap.dax_dev,
-				sector, PAGE_SIZE, entry, vmf->vma, vmf);
+		error = dax_insert_mapping(vmf, &iomap, pos, entry);
 		/* -EBUSY is fine, somebody else faulted on the same PTE */
 		if (error == -EBUSY)
 			error = 0;
-- 
2.12.3


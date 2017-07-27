Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52476 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751501AbdG0NMu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 09:12:50 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/7] dax: Make dax_insert_mapping() return VM_FAULT_ state
Date: Thu, 27 Jul 2017 15:12:42 +0200
Message-Id: <20170727131245.28279-5-jack@suse.cz>
In-Reply-To: <20170727131245.28279-1-jack@suse.cz>
References: <20170727131245.28279-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>

Currently dax_insert_mapping() returns normal error code which is later
converted to VM_FAULT_ state. Since we will need to do more state
modifications specific to dax_insert_mapping() it does not make sense to
push them up to the caller of dax_insert_mapping(). Instead make
dax_insert_mapping() return VM_FAULT_ state the same way as
dax_pmd_insert_mapping() does that.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 0673efd72f53..9658975b926a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -814,6 +814,15 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
+static int dax_fault_return(int error)
+{
+	if (error == 0)
+		return VM_FAULT_NOPAGE;
+	if (error == -ENOMEM)
+		return VM_FAULT_OOM;
+	return VM_FAULT_SIGBUS;
+}
+
 static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 {
 	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
@@ -828,7 +837,7 @@ static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
 	unsigned long vaddr = vmf->address;
 	void *ret, *kaddr;
 	pgoff_t pgoff;
-	int id, rc;
+	int id, rc, vmf_ret;
 	pfn_t pfn;
 
 	rc = bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
@@ -850,9 +859,18 @@ static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
 
 	trace_dax_insert_mapping(mapping->host, vmf, ret);
 	if (vmf->flags & FAULT_FLAG_WRITE)
-		return vm_insert_mixed_mkwrite(vma, vaddr, pfn);
+		rc = vm_insert_mixed_mkwrite(vma, vaddr, pfn);
 	else
-		return vm_insert_mixed(vma, vaddr, pfn);
+		rc = vm_insert_mixed(vma, vaddr, pfn);
+
+	/* -EBUSY is fine, somebody else faulted on the same PTE */
+	if (rc == -EBUSY)
+		rc = 0;
+
+	vmf_ret = dax_fault_return(rc);
+	if (iomap->flags & IOMAP_F_NEW)
+		vmf_ret |= VM_FAULT_MAJOR;
+	return vmf_ret;
 }
 
 /*
@@ -1062,15 +1080,6 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 }
 EXPORT_SYMBOL_GPL(dax_iomap_rw);
 
-static int dax_fault_return(int error)
-{
-	if (error == 0)
-		return VM_FAULT_NOPAGE;
-	if (error == -ENOMEM)
-		return VM_FAULT_OOM;
-	return VM_FAULT_SIGBUS;
-}
-
 static int dax_iomap_pte_fault(struct vm_fault *vmf, bool sync,
 			       const struct iomap_ops *ops)
 {
@@ -1080,7 +1089,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, bool sync,
 	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
 	struct iomap iomap = { 0 };
 	unsigned flags = IOMAP_FAULT;
-	int error, major = 0;
+	int error;
 	int vmf_ret = 0;
 	void *entry;
 
@@ -1163,13 +1172,9 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, bool sync,
 		if (iomap.flags & IOMAP_F_NEW) {
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(vmf->vma->vm_mm, PGMAJFAULT);
-			major = VM_FAULT_MAJOR;
 		}
-		error = dax_insert_mapping(vmf, &iomap, pos, entry);
-		/* -EBUSY is fine, somebody else faulted on the same PTE */
-		if (error == -EBUSY)
-			error = 0;
-		break;
+		vmf_ret = dax_insert_mapping(vmf, &iomap, pos, entry);
+		goto finish_iomap;
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
 		if (!(vmf->flags & FAULT_FLAG_WRITE)) {
@@ -1184,7 +1189,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, bool sync,
 	}
 
  error_finish_iomap:
-	vmf_ret = dax_fault_return(error) | major;
+	vmf_ret = dax_fault_return(error);
  finish_iomap:
 	if (ops->iomap_end) {
 		int copied = PAGE_SIZE;
-- 
2.12.3


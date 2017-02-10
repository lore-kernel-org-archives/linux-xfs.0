Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:52041 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751035AbdBJGw1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Feb 2017 01:52:27 -0500
Date: Fri, 10 Feb 2017 17:41:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the akpm-current tree with the xfs tree
Message-ID: <20170210174100.0524b8d7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Jiang <dave.jiang@intel.com>

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in:

  fs/dax.c

between commit:

  8ff6daa17b6a ("iomap: constify struct iomap_ops")

from the xfs tree and commit:

  5dce5c335124 ("mm,fs,dax: change ->pmd_fault to ->huge_fault")

from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

-- 
Cheers,
Stephen Rothwell

diff --cc fs/dax.c
index 99b5b4458a78,97b8ecbed1c4..000000000000
--- a/fs/dax.c
+++ b/fs/dax.c
@@@ -1116,20 -1114,9 +1118,9 @@@ static int dax_fault_return(int error
  	return VM_FAULT_SIGBUS;
  }
  
- /**
-  * dax_iomap_fault - handle a page fault on a DAX file
-  * @vma: The virtual memory area where the fault occurred
-  * @vmf: The description of the fault
-  * @ops: iomap ops passed from the file system
-  *
-  * When a page fault occurs, filesystems may call this helper in their fault
-  * or mkwrite handler for DAX files. Assumes the caller has done all the
-  * necessary locking for the page fault to proceed successfully.
-  */
- int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
- 			const struct iomap_ops *ops)
 -static int dax_iomap_pte_fault(struct vm_fault *vmf, struct iomap_ops *ops)
++static int dax_iomap_pte_fault(struct vm_fault *vmf, const struct iomap_ops *ops)
  {
- 	struct address_space *mapping = vma->vm_file->f_mapping;
+ 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
  	struct inode *inode = mapping->host;
  	unsigned long vaddr = vmf->address;
  	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
@@@ -1309,28 -1300,33 +1304,33 @@@ static int dax_pmd_load_hole(struct vm_
  	ret = dax_insert_mapping_entry(mapping, vmf, *entryp, 0,
  			RADIX_DAX_PMD | RADIX_DAX_HZP);
  	if (IS_ERR(ret))
- 		return VM_FAULT_FALLBACK;
+ 		goto fallback;
  	*entryp = ret;
  
- 	ptl = pmd_lock(vma->vm_mm, pmd);
- 	if (!pmd_none(*pmd)) {
+ 	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
+ 	if (!pmd_none(*(vmf->pmd))) {
  		spin_unlock(ptl);
- 		return VM_FAULT_FALLBACK;
+ 		goto fallback;
  	}
  
- 	pmd_entry = mk_pmd(zero_page, vma->vm_page_prot);
+ 	pmd_entry = mk_pmd(zero_page, vmf->vma->vm_page_prot);
  	pmd_entry = pmd_mkhuge(pmd_entry);
- 	set_pmd_at(vma->vm_mm, pmd_addr, pmd, pmd_entry);
+ 	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
  	spin_unlock(ptl);
+ 	trace_dax_pmd_load_hole(inode, vmf, zero_page, ret);
  	return VM_FAULT_NOPAGE;
+ 
+ fallback:
+ 	trace_dax_pmd_load_hole_fallback(inode, vmf, zero_page, ret);
+ 	return VM_FAULT_FALLBACK;
  }
  
- int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
- 		pmd_t *pmd, unsigned int flags, const struct iomap_ops *ops)
 -static int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops)
++static int dax_iomap_pmd_fault(struct vm_fault *vmf, const struct iomap_ops *ops)
  {
+ 	struct vm_area_struct *vma = vmf->vma;
  	struct address_space *mapping = vma->vm_file->f_mapping;
- 	unsigned long pmd_addr = address & PMD_MASK;
- 	bool write = flags & FAULT_FLAG_WRITE;
+ 	unsigned long pmd_addr = vmf->address & PMD_MASK;
+ 	bool write = vmf->flags & FAULT_FLAG_WRITE;
  	unsigned int iomap_flags = (write ? IOMAP_WRITE : 0) | IOMAP_FAULT;
  	struct inode *inode = mapping->host;
  	int result = VM_FAULT_FALLBACK;
@@@ -1429,10 -1422,40 +1426,40 @@@
  	}
   fallback:
  	if (result == VM_FAULT_FALLBACK) {
- 		split_huge_pmd(vma, pmd, address);
+ 		split_huge_pmd(vma, vmf->pmd, vmf->address);
  		count_vm_event(THP_FAULT_FALLBACK);
  	}
+ out:
+ 	trace_dax_pmd_fault_done(inode, vmf, max_pgoff, result);
  	return result;
  }
- EXPORT_SYMBOL_GPL(dax_iomap_pmd_fault);
+ #else
 -static int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops)
++static int dax_iomap_pmd_fault(struct vm_fault *vmf, const struct iomap_ops *ops)
+ {
+ 	return VM_FAULT_FALLBACK;
+ }
  #endif /* CONFIG_FS_DAX_PMD */
+ 
+ /**
+  * dax_iomap_fault - handle a page fault on a DAX file
+  * @vmf: The description of the fault
+  * @ops: iomap ops passed from the file system
+  *
+  * When a page fault occurs, filesystems may call this helper in
+  * their fault handler for DAX files. dax_iomap_fault() assumes the caller
+  * has done all the necessary locking for page fault to proceed
+  * successfully.
+  */
+ int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
 -		struct iomap_ops *ops)
++		const struct iomap_ops *ops)
+ {
+ 	switch (pe_size) {
+ 	case PE_SIZE_PTE:
+ 		return dax_iomap_pte_fault(vmf, ops);
+ 	case PE_SIZE_PMD:
+ 		return dax_iomap_pmd_fault(vmf, ops);
+ 	default:
+ 		return VM_FAULT_FALLBACK;
+ 	}
+ }
+ EXPORT_SYMBOL_GPL(dax_iomap_fault);

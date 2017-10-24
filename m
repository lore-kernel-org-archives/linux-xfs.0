Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36151 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932441AbdJXPZf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Oct 2017 11:25:35 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 14/17] dax: Implement dax_finish_sync_fault()
Date: Tue, 24 Oct 2017 17:24:11 +0200
Message-Id: <20171024152415.22864-15-jack@suse.cz>
In-Reply-To: <20171024152415.22864-1-jack@suse.cz>
References: <20171024152415.22864-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>

Implement a function that filesystems can call to finish handling of
synchronous page faults. It takes care of syncing appropriare file range
and insertion of page table entry.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c                      | 83 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h           |  2 ++
 include/trace/events/fs_dax.h |  2 ++
 3 files changed, 87 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index bb9ff907738c..78233c716757 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1492,3 +1492,86 @@ int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
 	}
 }
 EXPORT_SYMBOL_GPL(dax_iomap_fault);
+
+/**
+ * dax_insert_pfn_mkwrite - insert PTE or PMD entry into page tables
+ * @vmf: The description of the fault
+ * @pe_size: Size of entry to be inserted
+ * @pfn: PFN to insert
+ *
+ * This function inserts writeable PTE or PMD entry into page tables for mmaped
+ * DAX file.  It takes care of marking corresponding radix tree entry as dirty
+ * as well.
+ */
+static int dax_insert_pfn_mkwrite(struct vm_fault *vmf,
+				  enum page_entry_size pe_size,
+				  pfn_t pfn)
+{
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	void *entry, **slot;
+	pgoff_t index = vmf->pgoff;
+	int vmf_ret, error;
+
+	spin_lock_irq(&mapping->tree_lock);
+	entry = get_unlocked_mapping_entry(mapping, index, &slot);
+	/* Did we race with someone splitting entry or so? */
+	if (!entry ||
+	    (pe_size == PE_SIZE_PTE && !dax_is_pte_entry(entry)) ||
+	    (pe_size == PE_SIZE_PMD && !dax_is_pmd_entry(entry))) {
+		put_unlocked_mapping_entry(mapping, index, entry);
+		spin_unlock_irq(&mapping->tree_lock);
+		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
+						      VM_FAULT_NOPAGE);
+		return VM_FAULT_NOPAGE;
+	}
+	radix_tree_tag_set(&mapping->page_tree, index, PAGECACHE_TAG_DIRTY);
+	entry = lock_slot(mapping, slot);
+	spin_unlock_irq(&mapping->tree_lock);
+	switch (pe_size) {
+	case PE_SIZE_PTE:
+		error = vm_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
+		vmf_ret = dax_fault_return(error);
+		break;
+#ifdef CONFIG_FS_DAX_PMD
+	case PE_SIZE_PMD:
+		vmf_ret = vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
+			pfn, true);
+		break;
+#endif
+	default:
+		vmf_ret = VM_FAULT_FALLBACK;
+	}
+	put_locked_mapping_entry(mapping, index);
+	trace_dax_insert_pfn_mkwrite(mapping->host, vmf, vmf_ret);
+	return vmf_ret;
+}
+
+/**
+ * dax_finish_sync_fault - finish synchronous page fault
+ * @vmf: The description of the fault
+ * @pe_size: Size of entry to be inserted
+ * @pfn: PFN to insert
+ *
+ * This function ensures that the file range touched by the page fault is
+ * stored persistently on the media and handles inserting of appropriate page
+ * table entry.
+ */
+int dax_finish_sync_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
+			  pfn_t pfn)
+{
+	int err;
+	loff_t start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
+	size_t len = 0;
+
+	if (pe_size == PE_SIZE_PTE)
+		len = PAGE_SIZE;
+	else if (pe_size == PE_SIZE_PMD)
+		len = PMD_SIZE;
+	else
+		WARN_ON_ONCE(1);
+	err = vfs_fsync_range(vmf->vma->vm_file, start, start + len - 1, 1);
+	if (err)
+		return VM_FAULT_SIGBUS;
+	return dax_insert_pfn_mkwrite(vmf, pe_size, pfn);
+}
+EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index e7fa4b8f45bc..d403f78b706c 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -96,6 +96,8 @@ ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops);
 int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
 		    pfn_t *pfnp, const struct iomap_ops *ops);
+int dax_finish_sync_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
+			  pfn_t pfn);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index 88a9d19b8ff8..7725459fafef 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -190,6 +190,8 @@ DEFINE_EVENT(dax_pte_fault_class, name, \
 DEFINE_PTE_FAULT_EVENT(dax_pte_fault);
 DEFINE_PTE_FAULT_EVENT(dax_pte_fault_done);
 DEFINE_PTE_FAULT_EVENT(dax_load_hole);
+DEFINE_PTE_FAULT_EVENT(dax_insert_pfn_mkwrite_no_entry);
+DEFINE_PTE_FAULT_EVENT(dax_insert_pfn_mkwrite);
 
 TRACE_EVENT(dax_insert_mapping,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, void *radix_entry),
-- 
2.12.3


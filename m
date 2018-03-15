Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:5210 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932959AbeCOQBH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 12:01:07 -0400
Subject: [PATCH v6 07/15] fs,
 dax: use page->mapping to warn if truncate collides with a busy page
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 08:52:01 -0700
Message-ID: <152112912106.24669.9677997765966949415.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: Jeff Moyer <jmoyer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.orgjack@suse.czross.zwisler@linux.intel.comhch@lst.de, linux-kernel@vger.kernel.org

Catch cases where extent unmap operations encounter pages that are
pinned / busy. Typically this is pinned pages that are under active dma.
This warning is a canary for potential data corruption as truncated
blocks could be allocated to a new file while the device is still
performing i/o.

Here is an example of a collision that this implementation catches:

 WARNING: CPU: 2 PID: 1286 at fs/dax.c:343 dax_disassociate_entry+0x55/0x80
 [..]
 Call Trace:
  __dax_invalidate_mapping_entry+0x6c/0xf0
  dax_delete_mapping_entry+0xf/0x20
  truncate_exceptional_pvec_entries.part.12+0x1af/0x200
  truncate_inode_pages_range+0x268/0x970
  ? tlb_gather_mmu+0x10/0x20
  ? up_write+0x1c/0x40
  ? unmap_mapping_range+0x73/0x140
  xfs_free_file_space+0x1b6/0x5b0 [xfs]
  ? xfs_file_fallocate+0x7f/0x320 [xfs]
  ? down_write_nested+0x40/0x70
  ? xfs_ilock+0x21d/0x2f0 [xfs]
  xfs_file_fallocate+0x162/0x320 [xfs]
  ? rcu_read_lock_sched_held+0x3f/0x70
  ? rcu_sync_lockdep_assert+0x2a/0x50
  ? __sb_start_write+0xd0/0x1b0
  ? vfs_fallocate+0x20c/0x270
  vfs_fallocate+0x154/0x270
  SyS_fallocate+0x43/0x80
  entry_SYSCALL_64_fastpath+0x1f/0x96

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index b646a46e4d12..9ba043eb6294 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -298,6 +298,56 @@ static void put_unlocked_mapping_entry(struct address_space *mapping,
 	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
 }
 
+static unsigned long dax_entry_size(void *entry)
+{
+	if (dax_is_zero_entry(entry))
+		return 0;
+	else if (dax_is_empty_entry(entry))
+		return 0;
+	else if (dax_is_pmd_entry(entry))
+		return HPAGE_SIZE;
+	else
+		return PAGE_SIZE;
+}
+
+#define for_each_entry_pfn(entry, pfn, end_pfn) \
+	for (pfn = dax_radix_pfn(entry), \
+			end_pfn = pfn + dax_entry_size(entry) / PAGE_SIZE; \
+			pfn < end_pfn; \
+			pfn++)
+
+static void dax_associate_entry(void *entry, struct address_space *mapping)
+{
+	unsigned long pfn, end_pfn;
+
+	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
+		return;
+
+	for_each_entry_pfn(entry, pfn, end_pfn) {
+		struct page *page = pfn_to_page(pfn);
+
+		WARN_ON_ONCE(page->mapping);
+		page->mapping = mapping;
+	}
+}
+
+static void dax_disassociate_entry(void *entry, struct address_space *mapping,
+		bool trunc)
+{
+	unsigned long pfn, end_pfn;
+
+	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
+		return;
+
+	for_each_entry_pfn(entry, pfn, end_pfn) {
+		struct page *page = pfn_to_page(pfn);
+
+		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
+		WARN_ON_ONCE(page->mapping && page->mapping != mapping);
+		page->mapping = NULL;
+	}
+}
+
 /*
  * Find radix tree entry at given index. If it points to an exceptional entry,
  * return it with the radix tree entry locked. If the radix tree doesn't
@@ -404,6 +454,7 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 		}
 
 		if (pmd_downgrade) {
+			dax_disassociate_entry(entry, mapping, false);
 			radix_tree_delete(&mapping->page_tree, index);
 			mapping->nrexceptional--;
 			dax_wake_mapping_entry_waiter(mapping, index, entry,
@@ -453,6 +504,7 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 	    (radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_DIRTY) ||
 	     radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE)))
 		goto out;
+	dax_disassociate_entry(entry, mapping, trunc);
 	radix_tree_delete(page_tree, index);
 	mapping->nrexceptional--;
 	ret = 1;
@@ -547,6 +599,10 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 
 	spin_lock_irq(&mapping->tree_lock);
 	new_entry = dax_radix_locked_entry(pfn, flags);
+	if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
+		dax_disassociate_entry(entry, mapping, false);
+		dax_associate_entry(new_entry, mapping);
+	}
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		/*


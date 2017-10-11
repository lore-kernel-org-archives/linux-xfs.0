Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58299 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757452AbdJKUGT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Oct 2017 16:06:19 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/19] dax: Allow tuning whether dax_insert_mapping_entry() dirties entry
Date: Wed, 11 Oct 2017 22:05:55 +0200
Message-Id: <20171011200603.27442-12-jack@suse.cz>
In-Reply-To: <20171011200603.27442-1-jack@suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>

Currently we dirty radix tree entry whenever dax_insert_mapping_entry()
gets called for a write fault. With synchronous page faults we would
like to insert clean radix tree entry and dirty it only once we call
fdatasync() and update page tables to same some unnecessary cache
flushing. Add 'dirty' argument to dax_insert_mapping_entry() for that.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5ddf15161390..efc210ff6665 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -526,13 +526,13 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 static void *dax_insert_mapping_entry(struct address_space *mapping,
 				      struct vm_fault *vmf,
 				      void *entry, sector_t sector,
-				      unsigned long flags)
+				      unsigned long flags, bool dirty)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
 	void *new_entry;
 	pgoff_t index = vmf->pgoff;
 
-	if (vmf->flags & FAULT_FLAG_WRITE)
+	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
 	if (dax_is_zero_entry(entry) && !(flags & RADIX_DAX_ZERO_PAGE)) {
@@ -569,7 +569,7 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 		entry = new_entry;
 	}
 
-	if (vmf->flags & FAULT_FLAG_WRITE)
+	if (dirty)
 		radix_tree_tag_set(page_tree, index, PAGECACHE_TAG_DIRTY);
 
 	spin_unlock_irq(&mapping->tree_lock);
@@ -881,7 +881,7 @@ static int dax_load_hole(struct address_space *mapping, void *entry,
 	}
 
 	entry2 = dax_insert_mapping_entry(mapping, vmf, entry, 0,
-			RADIX_DAX_ZERO_PAGE);
+			RADIX_DAX_ZERO_PAGE, false);
 	if (IS_ERR(entry2)) {
 		ret = VM_FAULT_SIGBUS;
 		goto out;
@@ -1182,7 +1182,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 		entry = dax_insert_mapping_entry(mapping, vmf, entry,
 						 dax_iomap_sector(&iomap, pos),
-						 0);
+						 0, write);
 		if (IS_ERR(entry)) {
 			error = PTR_ERR(entry);
 			goto error_finish_iomap;
@@ -1258,7 +1258,7 @@ static int dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
 		goto fallback;
 
 	ret = dax_insert_mapping_entry(mapping, vmf, entry, 0,
-			RADIX_DAX_PMD | RADIX_DAX_ZERO_PAGE);
+			RADIX_DAX_PMD | RADIX_DAX_ZERO_PAGE, false);
 	if (IS_ERR(ret))
 		goto fallback;
 
@@ -1379,7 +1379,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 		entry = dax_insert_mapping_entry(mapping, vmf, entry,
 						dax_iomap_sector(&iomap, pos),
-						RADIX_DAX_PMD);
+						RADIX_DAX_PMD, write);
 		if (IS_ERR(entry))
 			goto finish_iomap;
 
-- 
2.12.3


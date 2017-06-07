Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:36830 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751710AbdFGUto (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Jun 2017 16:49:44 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/3] dax: relocate dax_load_hole()
Date: Wed,  7 Jun 2017 14:48:58 -0600
Message-Id: <20170607204859.13104-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20170607204859.13104-1-ross.zwisler@linux.intel.com>
References: <20170607204859.13104-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

dax_load_hole() will soon need to call dax_insert_mapping_entry(), so it
needs to be moved lower in dax.c so the definition exists.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 88 ++++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 2a6889b..66e0e93 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -469,50 +469,6 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 	return __dax_invalidate_mapping_entry(mapping, index, false);
 }
 
-/*
- * The user has performed a load from a hole in the file.  Allocating
- * a new page in the file would cause excessive storage usage for
- * workloads with sparse files.  We allocate a page cache page instead.
- * We'll kick it out of the page cache if it's ever written to,
- * otherwise it will simply fall out of the page cache under memory
- * pressure without ever having been dirtied.
- */
-static int dax_load_hole(struct address_space *mapping, void **entry,
-			 struct vm_fault *vmf)
-{
-	struct inode *inode = mapping->host;
-	struct page *page;
-	int ret;
-
-	/* Hole page already exists? Return it...  */
-	if (!radix_tree_exceptional_entry(*entry)) {
-		page = *entry;
-		goto finish_fault;
-	}
-
-	/* This will replace locked radix tree entry with a hole page */
-	page = find_or_create_page(mapping, vmf->pgoff,
-				   vmf->gfp_mask | __GFP_ZERO);
-	if (!page) {
-		ret = VM_FAULT_OOM;
-		goto out;
-	}
-
-finish_fault:
-	vmf->page = page;
-	ret = finish_fault(vmf);
-	vmf->page = NULL;
-	*entry = page;
-	if (!ret) {
-		/* Grab reference for PTE that is now referencing the page */
-		get_page(page);
-		ret = VM_FAULT_NOPAGE;
-	}
-out:
-	trace_dax_load_hole(inode, vmf, ret);
-	return ret;
-}
-
 static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 		sector_t sector, size_t size, struct page *to,
 		unsigned long vaddr)
@@ -936,6 +892,50 @@ int dax_pfn_mkwrite(struct vm_fault *vmf)
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
 
+/*
+ * The user has performed a load from a hole in the file.  Allocating
+ * a new page in the file would cause excessive storage usage for
+ * workloads with sparse files.  We allocate a page cache page instead.
+ * We'll kick it out of the page cache if it's ever written to,
+ * otherwise it will simply fall out of the page cache under memory
+ * pressure without ever having been dirtied.
+ */
+static int dax_load_hole(struct address_space *mapping, void **entry,
+			 struct vm_fault *vmf)
+{
+	struct inode *inode = mapping->host;
+	struct page *page;
+	int ret;
+
+	/* Hole page already exists? Return it...  */
+	if (!radix_tree_exceptional_entry(*entry)) {
+		page = *entry;
+		goto finish_fault;
+	}
+
+	/* This will replace locked radix tree entry with a hole page */
+	page = find_or_create_page(mapping, vmf->pgoff,
+				   vmf->gfp_mask | __GFP_ZERO);
+	if (!page) {
+		ret = VM_FAULT_OOM;
+		goto out;
+	}
+
+finish_fault:
+	vmf->page = page;
+	ret = finish_fault(vmf);
+	vmf->page = NULL;
+	*entry = page;
+	if (!ret) {
+		/* Grab reference for PTE that is now referencing the page */
+		get_page(page);
+		ret = VM_FAULT_NOPAGE;
+	}
+out:
+	trace_dax_load_hole(inode, vmf, ret);
+	return ret;
+}
+
 static bool dax_range_is_aligned(struct block_device *bdev,
 				 unsigned int offset, unsigned int length)
 {
-- 
2.9.4


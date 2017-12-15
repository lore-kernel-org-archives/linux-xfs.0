Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756586AbdLOWFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 17:05:25 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 64/78] dax: Convert dax_insert_mapping_entry to XArray
Date: Fri, 15 Dec 2017 14:04:36 -0800
Message-Id: <20171215220450.7899-65-willy@infradead.org>
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9cfd4fcc0b0d..a3e795ad2493 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -498,9 +498,9 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 				      void *entry, sector_t sector,
 				      unsigned long flags, bool dirty)
 {
-	struct radix_tree_root *pages = &mapping->pages;
 	void *new_entry;
 	pgoff_t index = vmf->pgoff;
+	XA_STATE(xas, &mapping->pages, index);
 
 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -516,7 +516,7 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 					PAGE_SIZE, 0);
 	}
 
-	xa_lock_irq(&mapping->pages);
+	xas_lock_irq(&xas);
 	new_entry = dax_radix_locked_entry(sector, flags);
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
@@ -528,21 +528,15 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 		 * existing entry is a PMD, we will just leave the PMD in the
 		 * tree and dirty it if necessary.
 		 */
-		struct radix_tree_node *node;
-		void **slot;
-		void *ret;
-
-		ret = __radix_tree_lookup(pages, index, &node, &slot);
-		WARN_ON_ONCE(ret != entry);
-		__radix_tree_replace(pages, node, slot,
-				     new_entry, NULL);
+		void *prev = xas_store(&xas, new_entry);
+		WARN_ON_ONCE(prev != entry);
 		entry = new_entry;
 	}
 
 	if (dirty)
-		radix_tree_tag_set(pages, index, PAGECACHE_TAG_DIRTY);
+		xas_set_tag(&xas, PAGECACHE_TAG_DIRTY);
 
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
 	return entry;
 }
 
-- 
2.15.1


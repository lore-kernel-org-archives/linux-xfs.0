Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51393 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756628AbdLOWFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 17:05:22 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 27/78] page cache: Convert page deletion to XArray
Date: Fri, 15 Dec 2017 14:03:59 -0800
Message-Id: <20171215220450.7899-28-willy@infradead.org>
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

The code is slightly shorter and simpler.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 91df92f5c96d..c9bc0dee0154 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -115,27 +115,25 @@
 static void page_cache_tree_delete(struct address_space *mapping,
 				   struct page *page, void *shadow)
 {
-	int i, nr;
+	XA_STATE(xas, &mapping->pages, page->index);
+	unsigned int i, nr;
 
-	/* hugetlb pages are represented by one entry in the radix tree */
+	xas_set_update(&xas, workingset_lookup_update(mapping));
+
+	/* hugetlb pages are represented by a single entry in the xarray */
 	nr = PageHuge(page) ? 1 : hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	VM_BUG_ON_PAGE(nr != 1 && shadow, page);
 
-	for (i = 0; i < nr; i++) {
-		struct radix_tree_node *node;
-		void **slot;
-
-		__radix_tree_lookup(&mapping->pages, page->index + i,
-				    &node, &slot);
-
-		VM_BUG_ON_PAGE(!node && nr != 1, page);
-
-		radix_tree_clear_tags(&mapping->pages, node, slot);
-		__radix_tree_replace(&mapping->pages, node, slot, shadow,
-				workingset_lookup_update(mapping));
+	i = nr;
+repeat:
+	xas_store(&xas, shadow);
+	xas_init_tags(&xas);
+	if (--i) {
+		xas_next(&xas);
+		goto repeat;
 	}
 
 	page->mapping = NULL;
-- 
2.15.1


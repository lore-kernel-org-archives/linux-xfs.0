Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46467 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753561AbeAQUWg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 15:22:36 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 25/99] page cache: Convert page deletion to XArray
Date: Wed, 17 Jan 2018 12:20:49 -0800
Message-Id: <20180117202203.19756-26-willy@infradead.org>
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

The code is slightly shorter and simpler.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index e6371b551de1..ed30d5310e50 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -112,30 +112,28 @@
  *   ->tasklist_lock            (memory_failure, collect_procs_ao)
  */
 
-static void page_cache_tree_delete(struct address_space *mapping,
+static void page_cache_delete(struct address_space *mapping,
 				   struct page *page, void *shadow)
 {
-	int i, nr;
+	XA_STATE(xas, &mapping->pages, page->index);
+	unsigned int i, nr;
 
-	/* hugetlb pages are represented by one entry in the radix tree */
+	mapping_set_update(&xas, mapping);
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
@@ -235,7 +233,7 @@ void __delete_from_page_cache(struct page *page, void *shadow)
 	trace_mm_filemap_delete_from_page_cache(page);
 
 	unaccount_page_cache_page(mapping, page);
-	page_cache_tree_delete(mapping, page, shadow);
+	page_cache_delete(mapping, page, shadow);
 }
 
 static void page_cache_free_page(struct address_space *mapping,
-- 
2.15.1


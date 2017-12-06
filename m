Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44304 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753301AbdLFAmK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Dec 2017 19:42:10 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 27/73] page cache: Convert delete_batch to XArray
Date: Tue,  5 Dec 2017 16:41:13 -0800
Message-Id: <20171206004159.3755-28-willy@infradead.org>
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Rename the function from page_cache_tree_delete_batch to just
page_cache_delete_batch.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6c9cad248e7f..9e6158cfbaeb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -276,7 +276,7 @@ void delete_from_page_cache(struct page *page)
 EXPORT_SYMBOL(delete_from_page_cache);
 
 /*
- * page_cache_tree_delete_batch - delete several pages from page cache
+ * page_cache_delete_batch - delete several pages from page cache
  * @mapping: the mapping to which pages belong
  * @pvec: pagevec with pages to delete
  *
@@ -289,23 +289,18 @@ EXPORT_SYMBOL(delete_from_page_cache);
  *
  * The function expects xa_lock to be held.
  */
-static void
-page_cache_tree_delete_batch(struct address_space *mapping,
+static void page_cache_delete_batch(struct address_space *mapping,
 			     struct pagevec *pvec)
 {
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->pages, pvec->pages[0]->index);
 	int total_pages = 0;
 	int i = 0, tail_pages = 0;
 	struct page *page;
-	pgoff_t start;
 
-	start = pvec->pages[0]->index;
-	radix_tree_for_each_slot(slot, &mapping->pages, &iter, start) {
+	xas_set_update(&xas, workingset_lookup_update(mapping));
+	xas_for_each(&xas, page, ULONG_MAX) {
 		if (i >= pagevec_count(pvec) && !tail_pages)
 			break;
-		page = radix_tree_deref_slot_protected(slot,
-						       &mapping->pages.xa_lock);
 		if (xa_is_value(page))
 			continue;
 		if (!tail_pages) {
@@ -328,9 +323,7 @@ page_cache_tree_delete_batch(struct address_space *mapping,
 		} else {
 			tail_pages--;
 		}
-		radix_tree_clear_tags(&mapping->pages, iter.node, slot);
-		__radix_tree_replace(&mapping->pages, iter.node, slot, NULL,
-				workingset_lookup_update(mapping));
+		xas_store(&xas, NULL);
 		total_pages++;
 	}
 	mapping->nrpages -= total_pages;
@@ -351,7 +344,7 @@ void delete_from_page_cache_batch(struct address_space *mapping,
 
 		unaccount_page_cache_page(mapping, pvec->pages[i]);
 	}
-	page_cache_tree_delete_batch(mapping, pvec);
+	page_cache_delete_batch(mapping, pvec);
 	xa_unlock_irqrestore(&mapping->pages, flags);
 
 	for (i = 0; i < pagevec_count(pvec); i++)
-- 
2.15.0


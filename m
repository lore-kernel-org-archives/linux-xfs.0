Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38601 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753633AbeAQUWj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 15:22:39 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 36/99] mm: Convert page migration to XArray
Date: Wed, 17 Jan 2018 12:21:00 -0800
Message-Id: <20180117202203.19756-37-willy@infradead.org>
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/migrate.c | 41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 75d19904dd9a..7122fec9b075 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -322,7 +322,7 @@ void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
 	page = migration_entry_to_page(entry);
 
 	/*
-	 * Once radix-tree replacement of page migration started, page_count
+	 * Once page cache replacement of page migration started, page_count
 	 * *must* be zero. And, we don't want to call wait_on_page_locked()
 	 * against a page without get_page().
 	 * So, we use get_page_unless_zero(), here. Even failed, page fault
@@ -437,10 +437,10 @@ int migrate_page_move_mapping(struct address_space *mapping,
 		struct buffer_head *head, enum migrate_mode mode,
 		int extra_count)
 {
+	XA_STATE(xas, &mapping->pages, page_index(page));
 	struct zone *oldzone, *newzone;
 	int dirty;
 	int expected_count = 1 + extra_count;
-	void **pslot;
 
 	/*
 	 * Device public or private pages have an extra refcount as they are
@@ -466,21 +466,16 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	oldzone = page_zone(page);
 	newzone = page_zone(newpage);
 
-	xa_lock_irq(&mapping->pages);
-
-	pslot = radix_tree_lookup_slot(&mapping->pages,
- 					page_index(page));
+	xas_lock_irq(&xas);
 
 	expected_count += 1 + page_has_private(page);
-	if (page_count(page) != expected_count ||
-		radix_tree_deref_slot_protected(pslot,
-					&mapping->pages.xa_lock) != page) {
-		xa_unlock_irq(&mapping->pages);
+	if (page_count(page) != expected_count || xas_load(&xas) != page) {
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
 	if (!page_ref_freeze(page, expected_count)) {
-		xa_unlock_irq(&mapping->pages);
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
@@ -494,7 +489,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	if (mode == MIGRATE_ASYNC && head &&
 			!buffer_migrate_lock_buffers(head, mode)) {
 		page_ref_unfreeze(page, expected_count);
-		xa_unlock_irq(&mapping->pages);
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
@@ -522,7 +517,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 		SetPageDirty(newpage);
 	}
 
-	radix_tree_replace_slot(&mapping->pages, pslot, newpage);
+	xas_store(&xas, newpage);
 
 	/*
 	 * Drop cache reference from old page by unfreezing
@@ -531,7 +526,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	 */
 	page_ref_unfreeze(page, expected_count - 1);
 
-	xa_unlock(&mapping->pages);
+	xas_unlock(&xas);
 	/* Leave irq disabled to prevent preemption while updating stats */
 
 	/*
@@ -571,22 +566,18 @@ EXPORT_SYMBOL(migrate_page_move_mapping);
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 				   struct page *newpage, struct page *page)
 {
+	XA_STATE(xas, &mapping->pages, page_index(page));
 	int expected_count;
-	void **pslot;
-
-	xa_lock_irq(&mapping->pages);
-
-	pslot = radix_tree_lookup_slot(&mapping->pages, page_index(page));
 
+	xas_lock_irq(&xas);
 	expected_count = 2 + page_has_private(page);
-	if (page_count(page) != expected_count ||
-		radix_tree_deref_slot_protected(pslot, &mapping->pages.xa_lock) != page) {
-		xa_unlock_irq(&mapping->pages);
+	if (page_count(page) != expected_count || xas_load(&xas) != page) {
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
 	if (!page_ref_freeze(page, expected_count)) {
-		xa_unlock_irq(&mapping->pages);
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
@@ -595,11 +586,11 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 
 	get_page(newpage);
 
-	radix_tree_replace_slot(&mapping->pages, pslot, newpage);
+	xas_store(&xas, newpage);
 
 	page_ref_unfreeze(page, expected_count - 1);
 
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
 
 	return MIGRATEPAGE_SUCCESS;
 }
-- 
2.15.1


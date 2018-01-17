Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45645 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753694AbeAQUWu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 15:22:50 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 57/99] dax: Convert dax_unlock_mapping_entry to XArray
Date: Wed, 17 Jan 2018 12:21:21 -0800
Message-Id: <20180117202203.19756-58-willy@infradead.org>
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Replace slot_locked() with dax_locked() and inline unlock_slot() into
its only caller.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 48 ++++++++++++++++--------------------------------
 1 file changed, 16 insertions(+), 32 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5097a606da1a..f3463d93a6ce 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -73,6 +73,11 @@ fs_initcall(init_dax_wait_table);
 #define DAX_ZERO_PAGE	(1UL << 2)
 #define DAX_EMPTY	(1UL << 3)
 
+static bool dax_locked(void *entry)
+{
+	return xa_to_value(entry) & DAX_ENTRY_LOCK;
+}
+
 static unsigned long dax_radix_sector(void *entry)
 {
 	return xa_to_value(entry) >> DAX_SHIFT;
@@ -180,16 +185,6 @@ static void dax_wake_mapping_entry_waiter(struct address_space *mapping,
 		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
 }
 
-/*
- * Check whether the given slot is locked.  Must be called with xa_lock held.
- */
-static inline int slot_locked(struct address_space *mapping, void **slot)
-{
-	unsigned long entry = xa_to_value(
-		radix_tree_deref_slot_protected(slot, &mapping->pages.xa_lock));
-	return entry & DAX_ENTRY_LOCK;
-}
-
 /*
  * Mark the given slot as locked.  Must be called with xa_lock held.
  */
@@ -202,18 +197,6 @@ static inline void *lock_slot(struct address_space *mapping, void **slot)
 	return entry;
 }
 
-/*
- * Mark the given slot as unlocked.  Must be called with xa_lock held.
- */
-static inline void *unlock_slot(struct address_space *mapping, void **slot)
-{
-	unsigned long v = xa_to_value(
-		radix_tree_deref_slot_protected(slot, &mapping->pages.xa_lock));
-	void *entry = xa_mk_value(v & ~DAX_ENTRY_LOCK);
-	radix_tree_replace_slot(&mapping->pages, slot, entry);
-	return entry;
-}
-
 /*
  * Lookup entry in radix tree, wait for it to become unlocked if it is
  * a DAX entry and return it. The caller must call
@@ -237,8 +220,7 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
 		entry = __radix_tree_lookup(&mapping->pages, index, NULL,
 					  &slot);
 		if (!entry ||
-		    WARN_ON_ONCE(!xa_is_value(entry)) ||
-		    !slot_locked(mapping, slot)) {
+		    WARN_ON_ONCE(!xa_is_value(entry)) || !dax_locked(entry)) {
 			if (slotp)
 				*slotp = slot;
 			return entry;
@@ -257,17 +239,19 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
 static void dax_unlock_mapping_entry(struct address_space *mapping,
 				     pgoff_t index)
 {
-	void *entry, **slot;
+	XA_STATE(xas, &mapping->pages, index);
+	void *entry;
 
-	xa_lock_irq(&mapping->pages);
-	entry = __radix_tree_lookup(&mapping->pages, index, NULL, &slot);
-	if (WARN_ON_ONCE(!entry || !xa_is_value(entry) ||
-			 !slot_locked(mapping, slot))) {
-		xa_unlock_irq(&mapping->pages);
+	xas_lock_irq(&xas);
+	entry = xas_load(&xas);
+	if (WARN_ON_ONCE(!entry || !xa_is_value(entry) || !dax_locked(entry))) {
+		xas_unlock_irq(&xas);
 		return;
 	}
-	unlock_slot(mapping, slot);
-	xa_unlock_irq(&mapping->pages);
+	entry = xa_mk_value(xa_to_value(entry) & ~DAX_ENTRY_LOCK);
+	xas_store(&xas, entry);
+	/* Safe to not call xas_pause here -- we don't touch the array after */
+	xas_unlock_irq(&xas);
 	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
 }
 
-- 
2.15.1


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53843 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752667AbeAQUWi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 15:22:38 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 32/99] mm: Convert truncate to XArray
Date: Wed, 17 Jan 2018 12:20:56 -0800
Message-Id: <20180117202203.19756-33-willy@infradead.org>
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

This is essentially xa_cmpxchg() with the locking handled above us,
and it doesn't have to handle replacing a NULL entry.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/truncate.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 69bb743dd7e5..70323c347298 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -33,15 +33,12 @@
 static inline void __clear_shadow_entry(struct address_space *mapping,
 				pgoff_t index, void *entry)
 {
-	struct radix_tree_node *node;
-	void **slot;
+	XA_STATE(xas, &mapping->pages, index);
 
-	if (!__radix_tree_lookup(&mapping->pages, index, &node, &slot))
+	xas_set_update(&xas, workingset_update_node);
+	if (xas_load(&xas) != entry)
 		return;
-	if (*slot != entry)
-		return;
-	__radix_tree_replace(&mapping->pages, node, slot, NULL,
-			     workingset_update_node);
+	xas_store(&xas, NULL);
 	mapping->nrexceptional--;
 }
 
@@ -746,10 +743,10 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 		index++;
 	}
 	/*
-	 * For DAX we invalidate page tables after invalidating radix tree.  We
+	 * For DAX we invalidate page tables after invalidating page cache.  We
 	 * could invalidate page tables while invalidating each entry however
 	 * that would be expensive. And doing range unmapping before doesn't
-	 * work as we have no cheap way to find whether radix tree entry didn't
+	 * work as we have no cheap way to find whether page cache entry didn't
 	 * get remapped later.
 	 */
 	if (dax_mapping(mapping)) {
-- 
2.15.1


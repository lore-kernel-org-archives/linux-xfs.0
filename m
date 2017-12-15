Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53477 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756312AbdLOWF0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 17:05:26 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 54/78] fs: Convert writeback to XArray
Date: Fri, 15 Dec 2017 14:04:26 -0800
Message-Id: <20171215220450.7899-55-willy@infradead.org>
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

A couple of short loops.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/fs-writeback.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e2c1ca667d9a..897a89489fe9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -339,9 +339,9 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	struct address_space *mapping = inode->i_mapping;
 	struct bdi_writeback *old_wb = inode->i_wb;
 	struct bdi_writeback *new_wb = isw->new_wb;
-	struct radix_tree_iter iter;
+	XA_STATE(xas, &mapping->pages, 0);
+	struct page *page;
 	bool switched = false;
-	void **slot;
 
 	/*
 	 * By the time control reaches here, RCU grace period has passed
@@ -375,25 +375,18 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	 * to possibly dirty pages while PAGECACHE_TAG_WRITEBACK points to
 	 * pages actually under writeback.
 	 */
-	radix_tree_for_each_tagged(slot, &mapping->pages, &iter, 0,
-				   PAGECACHE_TAG_DIRTY) {
-		struct page *page = radix_tree_deref_slot_protected(slot,
-						&mapping->pages.xa_lock);
-		if (likely(page) && PageDirty(page)) {
+	xas_for_each_tag(&xas, page, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
+		if (PageDirty(page)) {
 			dec_wb_stat(old_wb, WB_RECLAIMABLE);
 			inc_wb_stat(new_wb, WB_RECLAIMABLE);
 		}
 	}
 
-	radix_tree_for_each_tagged(slot, &mapping->pages, &iter, 0,
-				   PAGECACHE_TAG_WRITEBACK) {
-		struct page *page = radix_tree_deref_slot_protected(slot,
-						&mapping->pages.xa_lock);
-		if (likely(page)) {
-			WARN_ON_ONCE(!PageWriteback(page));
-			dec_wb_stat(old_wb, WB_WRITEBACK);
-			inc_wb_stat(new_wb, WB_WRITEBACK);
-		}
+	xas_set(&xas, 0);
+	xas_for_each_tag(&xas, page, ULONG_MAX, PAGECACHE_TAG_WRITEBACK) {
+		WARN_ON_ONCE(!PageWriteback(page));
+		dec_wb_stat(old_wb, WB_WRITEBACK);
+		inc_wb_stat(new_wb, WB_WRITEBACK);
 	}
 
 	wb_get(new_wb);
-- 
2.15.1


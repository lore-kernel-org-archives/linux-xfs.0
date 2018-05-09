Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933383AbeEIHtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 03:49:00 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/33] mm: split ->readpages calls to avoid non-contiguous pages lists
Date: Wed,  9 May 2018 09:48:04 +0200
Message-Id: <20180509074830.16196-8-hch@lst.de>
In-Reply-To: <20180509074830.16196-1-hch@lst.de>
References: <20180509074830.16196-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

That way file systems don't have to go spotting for non-contiguous pages
and work around them.  It also kicks off I/O earlier, allowing it to
finish earlier and reduce latency.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/readahead.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 16d0cb1e2616..3f608e00286d 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -177,8 +177,18 @@ int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 		rcu_read_lock();
 		page = radix_tree_lookup(&mapping->i_pages, page_offset);
 		rcu_read_unlock();
-		if (page && !radix_tree_exceptional_entry(page))
+		if (page && !radix_tree_exceptional_entry(page)) {
+			/*
+			 * Page already present?  Kick off the current batch of
+			 * contiguous pages before continueing with the next
+			 * batch.
+			 */
+			if (nr_pages)
+				read_pages(mapping, filp, &page_pool, nr_pages,
+						gfp_mask);
+			nr_pages = 0;
 			continue;
+		}
 
 		page = __page_cache_alloc(gfp_mask);
 		if (!page)
-- 
2.17.0


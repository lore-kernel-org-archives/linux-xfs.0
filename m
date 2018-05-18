Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49800 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbeERQs4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 May 2018 12:48:56 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/34] mm: split ->readpages calls to avoid non-contiguous pages lists
Date: Fri, 18 May 2018 18:48:04 +0200
Message-Id: <20180518164830.1552-9-hch@lst.de>
In-Reply-To: <20180518164830.1552-1-hch@lst.de>
References: <20180518164830.1552-1-hch@lst.de>
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
index fa4d4b767130..044ab0c137cc 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -177,8 +177,18 @@ unsigned int __do_page_cache_readahead(struct address_space *mapping,
 		rcu_read_lock();
 		page = radix_tree_lookup(&mapping->i_pages, page_offset);
 		rcu_read_unlock();
-		if (page && !radix_tree_exceptional_entry(page))
+		if (page && !radix_tree_exceptional_entry(page)) {
+			/*
+			 * Page already present?  Kick off the current batch of
+			 * contiguous pages before continuing with the next
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


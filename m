Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbeERQsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 May 2018 12:48:51 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/34] mm: give the 'ret' variable a better name __do_page_cache_readahead
Date: Fri, 18 May 2018 18:48:02 +0200
Message-Id: <20180518164830.1552-7-hch@lst.de>
In-Reply-To: <20180518164830.1552-1-hch@lst.de>
References: <20180518164830.1552-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

It counts the number of pages acted on, so name it nr_pages to make that
obvious.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/readahead.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 539bbb6c1fad..16d0cb1e2616 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -156,7 +156,7 @@ int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 	unsigned long end_index;	/* The last page we want to read */
 	LIST_HEAD(page_pool);
 	int page_idx;
-	int ret = 0;
+	int nr_pages = 0;
 	loff_t isize = i_size_read(inode);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
 
@@ -187,7 +187,7 @@ int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 		list_add(&page->lru, &page_pool);
 		if (page_idx == nr_to_read - lookahead_size)
 			SetPageReadahead(page);
-		ret++;
+		nr_pages++;
 	}
 
 	/*
@@ -195,11 +195,11 @@ int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 	 * uptodate then the caller will launch readpage again, and
 	 * will then handle the error.
 	 */
-	if (ret)
-		read_pages(mapping, filp, &page_pool, ret, gfp_mask);
+	if (nr_pages)
+		read_pages(mapping, filp, &page_pool, nr_pages, gfp_mask);
 	BUG_ON(!list_empty(&page_pool));
 out:
-	return ret;
+	return nr_pages;
 }
 
 /*
-- 
2.17.0


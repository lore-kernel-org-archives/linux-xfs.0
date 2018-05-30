Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34530 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751597AbeE3J63 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 05:58:29 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/13] mm: return an unsigned int from __do_page_cache_readahead
Date: Wed, 30 May 2018 11:58:03 +0200
Message-Id: <20180530095813.31245-4-hch@lst.de>
In-Reply-To: <20180530095813.31245-1-hch@lst.de>
References: <20180530095813.31245-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

We never return an error, so switch to returning an unsigned int.  Most
callers already did implicit casts to an unsigned type, and the one that
didn't can be simplified now.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mm/internal.h  |  2 +-
 mm/readahead.c | 15 +++++----------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 62d8c34e63d5..954003ac766a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -53,7 +53,7 @@ void unmap_page_range(struct mmu_gather *tlb,
 			     unsigned long addr, unsigned long end,
 			     struct zap_details *details);
 
-extern int __do_page_cache_readahead(struct address_space *mapping,
+extern unsigned int __do_page_cache_readahead(struct address_space *mapping,
 		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
 		unsigned long lookahead_size);
 
diff --git a/mm/readahead.c b/mm/readahead.c
index 16d0cb1e2616..fa4d4b767130 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -147,16 +147,16 @@ static int read_pages(struct address_space *mapping, struct file *filp,
  *
  * Returns the number of pages requested, or the maximum amount of I/O allowed.
  */
-int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read,
-			unsigned long lookahead_size)
+unsigned int __do_page_cache_readahead(struct address_space *mapping,
+		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
+		unsigned long lookahead_size)
 {
 	struct inode *inode = mapping->host;
 	struct page *page;
 	unsigned long end_index;	/* The last page we want to read */
 	LIST_HEAD(page_pool);
 	int page_idx;
-	int nr_pages = 0;
+	unsigned int nr_pages = 0;
 	loff_t isize = i_size_read(inode);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
 
@@ -223,16 +223,11 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 	max_pages = max_t(unsigned long, bdi->io_pages, ra->ra_pages);
 	nr_to_read = min(nr_to_read, max_pages);
 	while (nr_to_read) {
-		int err;
-
 		unsigned long this_chunk = (2 * 1024 * 1024) / PAGE_SIZE;
 
 		if (this_chunk > nr_to_read)
 			this_chunk = nr_to_read;
-		err = __do_page_cache_readahead(mapping, filp,
-						offset, this_chunk, 0);
-		if (err < 0)
-			return err;
+		__do_page_cache_readahead(mapping, filp, offset, this_chunk, 0);
 
 		offset += this_chunk;
 		nr_to_read -= this_chunk;
-- 
2.17.0


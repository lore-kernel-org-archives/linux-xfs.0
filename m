Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbeJBEtH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 00:49:07 -0400
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g76NL-0002Ar-O5
        for linux-xfs@vger.kernel.org; Mon, 01 Oct 2018 22:09:11 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: don't use slab for metadata buffers
Date: Mon,  1 Oct 2018 15:09:11 -0700
Message-Id: <20181001220911.4679-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

It turns out the slub allocator won't always give us aligned memory,
and on some controllers this can lead to data corruption.  Remove the
special slab backed fast path in xfs_buf_allocate_memory.  The only
downside of this is a slight waste of memory for metadata buffers
smaller than page size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 37 ++++---------------------------------
 fs/xfs/xfs_buf.h |  6 ++----
 2 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e839907e8492..4808fd38e7d7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -313,8 +313,8 @@ xfs_buf_free(
 
 			__free_page(page);
 		}
-	} else if (bp->b_flags & _XBF_KMEM)
-		kmem_free(bp->b_addr);
+	}
+
 	_xfs_buf_free_pages(bp);
 	xfs_buf_free_maps(bp);
 	kmem_zone_free(xfs_buf_zone, bp);
@@ -328,42 +328,13 @@ xfs_buf_allocate_memory(
 	xfs_buf_t		*bp,
 	uint			flags)
 {
-	size_t			size;
+	size_t			size = BBTOB(bp->b_length);
 	size_t			nbytes, offset;
 	gfp_t			gfp_mask = xb_to_gfp(flags);
 	unsigned short		page_count, i;
 	xfs_off_t		start, end;
 	int			error;
 
-	/*
-	 * for buffers that are contained within a single page, just allocate
-	 * the memory from the heap - there's no need for the complexity of
-	 * page arrays to keep allocation down to order 0.
-	 */
-	size = BBTOB(bp->b_length);
-	if (size < PAGE_SIZE) {
-		bp->b_addr = kmem_alloc(size, KM_NOFS);
-		if (!bp->b_addr) {
-			/* low memory - use alloc_page loop instead */
-			goto use_alloc_page;
-		}
-
-		if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=
-		    ((unsigned long)bp->b_addr & PAGE_MASK)) {
-			/* b_addr spans two pages - use alloc_page instead */
-			kmem_free(bp->b_addr);
-			bp->b_addr = NULL;
-			goto use_alloc_page;
-		}
-		bp->b_offset = offset_in_page(bp->b_addr);
-		bp->b_pages = bp->b_page_array;
-		bp->b_pages[0] = virt_to_page(bp->b_addr);
-		bp->b_page_count = 1;
-		bp->b_flags |= _XBF_KMEM;
-		return 0;
-	}
-
-use_alloc_page:
 	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
 	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
 								>> PAGE_SHIFT;
@@ -628,7 +599,7 @@ xfs_buf_find(
 	if (bp->b_flags & XBF_STALE) {
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
 		ASSERT(bp->b_iodone == NULL);
-		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
+		bp->b_flags &= _XBF_PAGES;
 		bp->b_ops = NULL;
 	}
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 4e3171acd0f8..338fabb91f61 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -47,9 +47,8 @@ typedef enum {
 
 /* flags used only internally */
 #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
-#define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
-#define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
-#define _XBF_COMPOUND	 (1 << 23)/* compound buffer */
+#define _XBF_DELWRI_Q	 (1 << 21)/* buffer on a delwri queue */
+#define _XBF_COMPOUND	 (1 << 22)/* compound buffer */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -68,7 +67,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_TRYLOCK,		"TRYLOCK" },	/* should never be set */\
 	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
-	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	{ _XBF_COMPOUND,	"COMPOUND" }
 
-- 
2.19.0

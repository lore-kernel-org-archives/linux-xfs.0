Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETP0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:26 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/24] xfs: make mem_to_page available outside of xfs_buf.c
Date: Wed,  5 Jun 2019 21:14:51 +0200
Message-Id: <20190605191511.32695-5-hch@lst.de>
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>

Rename the function to kmem_to_page and move it to kmem.h together
with our kmem_large allocator that may either return kmalloced or
vmalloc pages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/kmem.h    |  8 ++++++++
 fs/xfs/xfs_buf.c | 13 +------------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 8e6b3ba81c03..267655acd426 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -124,4 +124,12 @@ kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 	return kmem_zone_alloc(zone, flags | KM_ZERO);
 }
 
+static inline struct page *
+kmem_to_page(void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		return vmalloc_to_page(addr);
+	return virt_to_page(addr);
+}
+
 #endif /* __XFS_SUPPORT_KMEM_H__ */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 548344e25128..ade6ec28e1c9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -933,17 +933,6 @@ xfs_buf_set_empty(
 	bp->b_maps[0].bm_len = bp->b_length;
 }
 
-static inline struct page *
-mem_to_page(
-	void			*addr)
-{
-	if ((!is_vmalloc_addr(addr))) {
-		return virt_to_page(addr);
-	} else {
-		return vmalloc_to_page(addr);
-	}
-}
-
 int
 xfs_buf_associate_memory(
 	xfs_buf_t		*bp,
@@ -976,7 +965,7 @@ xfs_buf_associate_memory(
 	bp->b_offset = offset;
 
 	for (i = 0; i < bp->b_page_count; i++) {
-		bp->b_pages[i] = mem_to_page((void *)pageaddr);
+		bp->b_pages[i] = kmem_to_page((void *)pageaddr);
 		pageaddr += PAGE_SIZE;
 	}
 
-- 
2.20.1

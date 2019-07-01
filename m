Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44868 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfGAV4e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 17:56:34 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/15] gfs2: don't use buffer_heads in gfs2_allocate_page_backing
Date: Mon,  1 Jul 2019 23:54:38 +0200
Message-Id: <20190701215439.19162-15-hch@lst.de>
In-Reply-To: <20190701215439.19162-1-hch@lst.de>
References: <20190701215439.19162-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com

Rewrite gfs2_allocate_page_backing to call gfs2_iomap_get_alloc and
operate on struct iomap directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/gfs2/file.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 282a4aaab900..8c72e4cecd89 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -379,31 +379,30 @@ static void gfs2_size_hint(struct file *filep, loff_t offset, size_t size)
 }
 
 /**
- * gfs2_allocate_page_backing - Use bmap to allocate blocks
+ * gfs2_allocate_page_backing - Allocate blocks for a write fault
  * @page: The (locked) page to allocate backing for
  *
- * We try to allocate all the blocks required for the page in
- * one go. This might fail for various reasons, so we keep
- * trying until all the blocks to back this page are allocated.
- * If some of the blocks are already allocated, thats ok too.
+ * We try to allocate all the blocks required for the page in one go.  This
+ * might fail for various reasons, so we keep trying until all the blocks to
+ * back this page are allocated.  If some of the blocks are already allocated,
+ * that is ok too.
  */
-
 static int gfs2_allocate_page_backing(struct page *page)
 {
-	struct inode *inode = page->mapping->host;
-	struct buffer_head bh;
-	unsigned long size = PAGE_SIZE;
-	u64 lblock = page->index << (PAGE_SHIFT - inode->i_blkbits);
+	u64 pos = page_offset(page);
+	u64 size = PAGE_SIZE;
 
 	do {
-		bh.b_state = 0;
-		bh.b_size = size;
-		gfs2_block_map(inode, lblock, &bh, 1);
-		if (!buffer_mapped(&bh))
+		struct iomap iomap = { };
+
+		if (gfs2_iomap_get_alloc(page->mapping->host, pos, 1, &iomap))
 			return -EIO;
-		size -= bh.b_size;
-		lblock += (bh.b_size >> inode->i_blkbits);
-	} while(size > 0);
+
+		iomap.length = min(iomap.length, size);
+		size -= iomap.length;
+		pos += iomap.length;
+	} while (size > 0);
+
 	return 0;
 }
 
-- 
2.20.1

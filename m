Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44854 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfGAV41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 17:56:27 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/15] gfs2: implement gfs2_block_zero_range using iomap_zero_range
Date: Mon,  1 Jul 2019 23:54:37 +0200
Message-Id: <20190701215439.19162-14-hch@lst.de>
In-Reply-To: <20190701215439.19162-1-hch@lst.de>
References: <20190701215439.19162-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com

iomap handles all the nitty-gritty details of zeroing a file
range for us, so use the proper helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/gfs2/bmap.c | 68 +-------------------------------------------------
 1 file changed, 1 insertion(+), 67 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 8e8768685264..b7bd811872cb 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1281,76 +1281,10 @@ int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsi
 	return ret;
 }
 
-/**
- * gfs2_block_zero_range - Deal with zeroing out data
- *
- * This is partly borrowed from ext3.
- */
 static int gfs2_block_zero_range(struct inode *inode, loff_t from,
 				 unsigned int length)
 {
-	struct address_space *mapping = inode->i_mapping;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	unsigned long index = from >> PAGE_SHIFT;
-	unsigned offset = from & (PAGE_SIZE-1);
-	unsigned blocksize, iblock, pos;
-	struct buffer_head *bh;
-	struct page *page;
-	int err;
-
-	page = find_or_create_page(mapping, index, GFP_NOFS);
-	if (!page)
-		return 0;
-
-	blocksize = inode->i_sb->s_blocksize;
-	iblock = index << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits);
-
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, blocksize, 0);
-
-	/* Find the buffer that contains "offset" */
-	bh = page_buffers(page);
-	pos = blocksize;
-	while (offset >= pos) {
-		bh = bh->b_this_page;
-		iblock++;
-		pos += blocksize;
-	}
-
-	err = 0;
-
-	if (!buffer_mapped(bh)) {
-		gfs2_block_map(inode, iblock, bh, 0);
-		/* unmapped? It's a hole - nothing to do */
-		if (!buffer_mapped(bh))
-			goto unlock;
-	}
-
-	/* Ok, it's mapped. Make sure it's up-to-date */
-	if (PageUptodate(page))
-		set_buffer_uptodate(bh);
-
-	if (!buffer_uptodate(bh)) {
-		err = -EIO;
-		ll_rw_block(REQ_OP_READ, 0, 1, &bh);
-		wait_on_buffer(bh);
-		/* Uhhuh. Read error. Complain and punt. */
-		if (!buffer_uptodate(bh))
-			goto unlock;
-		err = 0;
-	}
-
-	if (gfs2_is_jdata(ip))
-		gfs2_trans_add_data(ip->i_gl, bh);
-	else
-		gfs2_ordered_add_inode(ip);
-
-	zero_user(page, offset, length);
-	mark_buffer_dirty(bh);
-unlock:
-	unlock_page(page);
-	put_page(page);
-	return err;
+	return iomap_zero_range(inode, from, length, NULL, &gfs2_iomap_ops);
 }
 
 #define GFS2_JTRUNC_REVOKES 8192
-- 
2.20.1

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44764 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfGAVzx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 17:55:53 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/15] gfs2: remove the unused gfs2_stuffed_write_end function
Date: Mon,  1 Jul 2019 23:54:32 +0200
Message-Id: <20190701215439.19162-9-hch@lst.de>
In-Reply-To: <20190701215439.19162-1-hch@lst.de>
References: <20190701215439.19162-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/gfs2/aops.c | 41 -----------------------------------------
 fs/gfs2/aops.h |  3 ---
 2 files changed, 44 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index abeac61cfed3..3c58b40c93eb 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -685,47 +685,6 @@ void adjust_fs_space(struct inode *inode)
 	gfs2_trans_end(sdp);
 }
 
-/**
- * gfs2_stuffed_write_end - Write end for stuffed files
- * @inode: The inode
- * @dibh: The buffer_head containing the on-disk inode
- * @pos: The file position
- * @copied: How much was actually copied by the VFS
- * @page: The page
- *
- * This copies the data from the page into the inode block after
- * the inode data structure itself.
- *
- * Returns: copied bytes or errno
- */
-int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
-			   loff_t pos, unsigned copied,
-			   struct page *page)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	u64 to = pos + copied;
-	void *kaddr;
-	unsigned char *buf = dibh->b_data + sizeof(struct gfs2_dinode);
-
-	BUG_ON(pos + copied > gfs2_max_stuffed_size(ip));
-
-	kaddr = kmap_atomic(page);
-	memcpy(buf + pos, kaddr + pos, copied);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr);
-
-	WARN_ON(!PageUptodate(page));
-	unlock_page(page);
-	put_page(page);
-
-	if (copied) {
-		if (inode->i_size < to)
-			i_size_write(inode, to);
-		mark_inode_dirty(inode);
-	}
-	return copied;
-}
-
 /**
  * jdata_set_page_dirty - Page dirtying function
  * @page: The page to dirty
diff --git a/fs/gfs2/aops.h b/fs/gfs2/aops.h
index fa8e5d0144dd..3a6d8a90d99e 100644
--- a/fs/gfs2/aops.h
+++ b/fs/gfs2/aops.h
@@ -9,9 +9,6 @@
 #include "incore.h"
 
 extern int stuffed_readpage(struct gfs2_inode *ip, struct page *page);
-extern int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
-				  loff_t pos, unsigned copied,
-				  struct page *page);
 extern void adjust_fs_space(struct inode *inode);
 extern void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
 				   unsigned int from, unsigned int len);
-- 
2.20.1

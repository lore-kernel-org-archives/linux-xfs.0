Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44796 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfGAV4G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 17:56:06 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/15] gfs2: merge gfs2_writepage_common into gfs2_writepage
Date: Mon,  1 Jul 2019 23:54:34 +0200
Message-Id: <20190701215439.19162-11-hch@lst.de>
In-Reply-To: <20190701215439.19162-1-hch@lst.de>
References: <20190701215439.19162-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com

No need to keep these two functions separate.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/gfs2/aops.c | 32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 3b3043332e5a..d78b5778fca7 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -82,15 +82,11 @@ static int gfs2_get_block_noalloc(struct inode *inode, sector_t lblock,
 }
 
 /**
- * gfs2_writepage_common - Common bits of writepage
- * @page: The page to be written
+ * gfs2_writepage - Write page for writeback mappings
+ * @page: The page
  * @wbc: The writeback control
- *
- * Returns: 1 if writepage is ok, otherwise an error code or zero if no error.
  */
-
-static int gfs2_writepage_common(struct page *page,
-				 struct writeback_control *wbc)
+static int gfs2_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
@@ -109,7 +105,9 @@ static int gfs2_writepage_common(struct page *page,
 		page->mapping->a_ops->invalidatepage(page, 0, PAGE_SIZE);
 		goto out;
 	}
-	return 1;
+
+	return nobh_writepage(page, gfs2_get_block_noalloc, wbc);
+
 redirty:
 	redirty_page_for_writepage(wbc, page);
 out:
@@ -117,24 +115,6 @@ static int gfs2_writepage_common(struct page *page,
 	return 0;
 }
 
-/**
- * gfs2_writepage - Write page for writeback mappings
- * @page: The page
- * @wbc: The writeback control
- *
- */
-
-static int gfs2_writepage(struct page *page, struct writeback_control *wbc)
-{
-	int ret;
-
-	ret = gfs2_writepage_common(page, wbc);
-	if (ret <= 0)
-		return ret;
-
-	return nobh_writepage(page, gfs2_get_block_noalloc, wbc);
-}
-
 /* This is the same as calling block_write_full_page, but it also
  * writes pages outside of i_size
  */
-- 
2.20.1

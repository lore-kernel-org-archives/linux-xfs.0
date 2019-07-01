Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44814 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfGAV4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 17:56:12 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/15] gfs2: mark stuffed_readpage static
Date: Mon,  1 Jul 2019 23:54:35 +0200
Message-Id: <20190701215439.19162-12-hch@lst.de>
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
 fs/gfs2/aops.c | 3 +--
 fs/gfs2/aops.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index d78b5778fca7..030210f1430b 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -434,8 +434,7 @@ static int gfs2_jdata_writepages(struct address_space *mapping,
  *
  * Returns: errno
  */
-
-int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
+static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 {
 	struct buffer_head *dibh;
 	u64 dsize = i_size_read(&ip->i_inode);
diff --git a/fs/gfs2/aops.h b/fs/gfs2/aops.h
index 3a6d8a90d99e..ff9877a68780 100644
--- a/fs/gfs2/aops.h
+++ b/fs/gfs2/aops.h
@@ -8,7 +8,6 @@
 
 #include "incore.h"
 
-extern int stuffed_readpage(struct gfs2_inode *ip, struct page *page);
 extern void adjust_fs_space(struct inode *inode);
 extern void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
 				   unsigned int from, unsigned int len);
-- 
2.20.1

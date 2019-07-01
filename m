Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44778 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfGAVz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 17:55:59 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/15] gfs2: merge gfs2_writeback_aops and gfs2_ordered_aops
Date: Mon,  1 Jul 2019 23:54:33 +0200
Message-Id: <20190701215439.19162-10-hch@lst.de>
In-Reply-To: <20190701215439.19162-1-hch@lst.de>
References: <20190701215439.19162-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com

The only difference between the two is that gfs2_ordered_aops sets the
set_page_dirty method to __set_page_dirty_buffers, but given that
__set_page_dirty_buffers is the default if no method is set there is
no need to to do that.  Merge the two sets of operations into one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/gfs2/aops.c | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 3c58b40c93eb..3b3043332e5a 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -847,7 +847,7 @@ int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 	return 0;
 }
 
-static const struct address_space_operations gfs2_writeback_aops = {
+static const struct address_space_operations gfs2_aops = {
 	.writepage = gfs2_writepage,
 	.writepages = gfs2_writepages,
 	.readpage = gfs2_readpage,
@@ -861,21 +861,6 @@ static const struct address_space_operations gfs2_writeback_aops = {
 	.error_remove_page = generic_error_remove_page,
 };
 
-static const struct address_space_operations gfs2_ordered_aops = {
-	.writepage = gfs2_writepage,
-	.writepages = gfs2_writepages,
-	.readpage = gfs2_readpage,
-	.readpages = gfs2_readpages,
-	.set_page_dirty = __set_page_dirty_buffers,
-	.bmap = gfs2_bmap,
-	.invalidatepage = gfs2_invalidatepage,
-	.releasepage = gfs2_releasepage,
-	.direct_IO = noop_direct_IO,
-	.migratepage = buffer_migrate_page,
-	.is_partially_uptodate = block_is_partially_uptodate,
-	.error_remove_page = generic_error_remove_page,
-};
-
 static const struct address_space_operations gfs2_jdata_aops = {
 	.writepage = gfs2_jdata_writepage,
 	.writepages = gfs2_jdata_writepages,
@@ -891,15 +876,8 @@ static const struct address_space_operations gfs2_jdata_aops = {
 
 void gfs2_set_aops(struct inode *inode)
 {
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-
-	if (gfs2_is_jdata(ip))
+	if (gfs2_is_jdata(GFS2_I(inode)))
 		inode->i_mapping->a_ops = &gfs2_jdata_aops;
-	else if (gfs2_is_writeback(sdp))
-		inode->i_mapping->a_ops = &gfs2_writeback_aops;
-	else if (gfs2_is_ordered(sdp))
-		inode->i_mapping->a_ops = &gfs2_ordered_aops;
 	else
-		BUG();
+		inode->i_mapping->a_ops = &gfs2_aops;
 }
-- 
2.20.1

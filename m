Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbeERQtM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 May 2018 12:49:12 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/34] iomap: add a iomap_sector helper
Date: Fri, 18 May 2018 18:48:09 +0200
Message-Id: <20180518164830.1552-14-hch@lst.de>
In-Reply-To: <20180518164830.1552-1-hch@lst.de>
References: <20180518164830.1552-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

Factor the repeated calculation of the on-disk sector for a given logical
block into a littler helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 6427627a247f..44259eadb69d 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -97,6 +97,12 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
 	return written ? written : ret;
 }
 
+static sector_t
+iomap_sector(struct iomap *iomap, loff_t pos)
+{
+	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
+}
+
 static void
 iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 {
@@ -354,11 +360,8 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
 static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
 		struct iomap *iomap)
 {
-	sector_t sector = (iomap->addr +
-			   (pos & PAGE_MASK) - iomap->offset) >> 9;
-
-	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev, sector,
-			offset, bytes);
+	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev,
+			iomap_sector(iomap, pos & PAGE_MASK), offset, bytes);
 }
 
 static loff_t
@@ -951,8 +954,7 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 
 	bio = bio_alloc(GFP_KERNEL, 1);
 	bio_set_dev(bio, iomap->bdev);
-	bio->bi_iter.bi_sector =
-		(iomap->addr + pos - iomap->offset) >> 9;
+	bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
@@ -1046,8 +1048,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 
 		bio = bio_alloc(GFP_KERNEL, nr_pages);
 		bio_set_dev(bio, iomap->bdev);
-		bio->bi_iter.bi_sector =
-			(iomap->addr + pos - iomap->offset) >> 9;
+		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 		bio->bi_write_hint = dio->iocb->ki_hint;
 		bio->bi_private = dio;
 		bio->bi_end_io = iomap_dio_bio_end_io;
-- 
2.17.0


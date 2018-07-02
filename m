Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55244 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752555AbeGBOzA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:55:00 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] iomap: refactor iomap_dio_actor
Date: Mon,  2 Jul 2018 08:54:56 -0600
Message-Id: <20180702145458.22330-2-hch@lst.de>
In-Reply-To: <20180702145458.22330-1-hch@lst.de>
References: <20180702145458.22330-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org

Split the function up into two helpers for the bio based I/O and hole
case, and a small helper to call the two.  This separates the code a
little better in preparation for supporting I/O to inline data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap.c | 88 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 36 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 2ebff76039b5..4d8ff0f5ecc9 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1327,10 +1327,9 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 }
 
 static loff_t
-iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
-		void *data, struct iomap *iomap)
+iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
+		struct iomap_dio *dio, struct iomap *iomap)
 {
-	struct iomap_dio *dio = data;
 	unsigned int blkbits = blksize_bits(bdev_logical_block_size(iomap->bdev));
 	unsigned int fs_block_size = i_blocksize(inode), pad;
 	unsigned int align = iov_iter_alignment(dio->submit.iter);
@@ -1344,41 +1343,27 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 	if ((pos | length | align) & ((1 << blkbits) - 1))
 		return -EINVAL;
 
-	switch (iomap->type) {
-	case IOMAP_HOLE:
-		if (WARN_ON_ONCE(dio->flags & IOMAP_DIO_WRITE))
-			return -EIO;
-		/*FALLTHRU*/
-	case IOMAP_UNWRITTEN:
-		if (!(dio->flags & IOMAP_DIO_WRITE)) {
-			length = iov_iter_zero(length, dio->submit.iter);
-			dio->size += length;
-			return length;
-		}
+	if (iomap->type == IOMAP_UNWRITTEN) {
 		dio->flags |= IOMAP_DIO_UNWRITTEN;
 		need_zeroout = true;
-		break;
-	case IOMAP_MAPPED:
-		if (iomap->flags & IOMAP_F_SHARED)
-			dio->flags |= IOMAP_DIO_COW;
-		if (iomap->flags & IOMAP_F_NEW) {
-			need_zeroout = true;
-		} else {
-			/*
-			 * Use a FUA write if we need datasync semantics, this
-			 * is a pure data IO that doesn't require any metadata
-			 * updates and the underlying device supports FUA. This
-			 * allows us to avoid cache flushes on IO completion.
-			 */
-			if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
-			    (dio->flags & IOMAP_DIO_WRITE_FUA) &&
-			    blk_queue_fua(bdev_get_queue(iomap->bdev)))
-				use_fua = true;
-		}
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return -EIO;
+	}
+
+	if (iomap->flags & IOMAP_F_SHARED)
+		dio->flags |= IOMAP_DIO_COW;
+
+	if (iomap->flags & IOMAP_F_NEW) {
+		need_zeroout = true;
+	} else {
+		/*
+		 * Use a FUA write if we need datasync semantics, this
+		 * is a pure data IO that doesn't require any metadata
+		 * updates and the underlying device supports FUA. This
+		 * allows us to avoid cache flushes on IO completion.
+		 */
+		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
+		    (dio->flags & IOMAP_DIO_WRITE_FUA) &&
+		    blk_queue_fua(bdev_get_queue(iomap->bdev)))
+			use_fua = true;
 	}
 
 	/*
@@ -1457,6 +1442,37 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 	return copied;
 }
 
+static loff_t
+iomap_dio_hole_actor(loff_t length, struct iomap_dio *dio)
+{
+	length = iov_iter_zero(length, dio->submit.iter);
+	dio->size += length;
+	return length;
+}
+
+static loff_t
+iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
+		void *data, struct iomap *iomap)
+{
+	struct iomap_dio *dio = data;
+
+	switch (iomap->type) {
+	case IOMAP_HOLE:
+		if (WARN_ON_ONCE(dio->flags & IOMAP_DIO_WRITE))
+			return -EIO;
+		return iomap_dio_hole_actor(length, dio);
+	case IOMAP_UNWRITTEN:
+		if (!(dio->flags & IOMAP_DIO_WRITE))
+			return iomap_dio_hole_actor(length, dio);
+		return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
+	case IOMAP_MAPPED:
+		return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
+	default:
+		WARN_ON_ONCE(1);
+		return -EIO;
+	}
+}
+
 /*
  * iomap_dio_rw() always completes O_[D]SYNC writes regardless of whether the IO
  * is being issued as AIO or not.  This allows us to optimise pure data writes
-- 
2.18.0


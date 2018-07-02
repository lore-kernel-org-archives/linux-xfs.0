Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55250 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752556AbeGBOzA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:55:00 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] iomap: support direct I/O to inline data
Date: Mon,  2 Jul 2018 08:54:57 -0600
Message-Id: <20180702145458.22330-3-hch@lst.de>
In-Reply-To: <20180702145458.22330-1-hch@lst.de>
References: <20180702145458.22330-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

Add support for reading from and writing to inline data to iomap_dio_rw.
This saves filesystems from having to implement fallback code for this
case.

The inline data is actually cached in the inode, so the I/O is only
direct in the sense that it doesn't go through the page cache.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 4d8ff0f5ecc9..98a1fdd5c091 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1450,6 +1450,33 @@ iomap_dio_hole_actor(loff_t length, struct iomap_dio *dio)
 	return length;
 }
 
+static loff_t
+iomap_dio_inline_actor(struct inode *inode, loff_t pos, loff_t length,
+		struct iomap_dio *dio, struct iomap *iomap)
+{
+	struct iov_iter *iter = dio->submit.iter;
+	size_t copied;
+
+	BUG_ON(pos + length > PAGE_SIZE - offset_in_page(iomap->inline_data));
+
+	if (dio->flags & IOMAP_DIO_WRITE) {
+		loff_t size = inode->i_size;
+
+		if (pos > size)
+			memset(iomap->inline_data + size, 0, pos - size);
+		copied = copy_from_iter(iomap->inline_data + pos, length, iter);
+		if (copied) {
+			if (pos + copied > size)
+				i_size_write(inode, pos + copied);
+			mark_inode_dirty(inode);
+		}
+	} else {
+		copied = copy_to_iter(iomap->inline_data + pos, length, iter);
+	}
+	dio->size += copied;
+	return copied;
+}
+
 static loff_t
 iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 		void *data, struct iomap *iomap)
@@ -1467,6 +1494,8 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 		return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
 	case IOMAP_MAPPED:
 		return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
+	case IOMAP_INLINE:
+		return iomap_dio_inline_actor(inode, pos, length, dio, iomap);
 	default:
 		WARN_ON_ONCE(1);
 		return -EIO;
-- 
2.18.0


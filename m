Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60817 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753046AbdF2Ny2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2017 09:54:28 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] vfs: Add iomap_seek_hole and iomap_seek_data helpers
Date: Thu, 29 Jun 2017 06:54:18 -0700
Message-Id: <20170629135420.21357-4-hch@lst.de>
In-Reply-To: <20170629135420.21357-1-hch@lst.de>
References: <20170629135420.21357-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

Filesystems can use this for implementing lseek SEEK_HOLE / SEEK_DATA
support via iomap.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
[hch: split functions, coding style cleanups]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c            | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h |  4 +++
 2 files changed, 98 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 4b10892967a5..432eed8f091f 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -584,6 +584,100 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 }
 EXPORT_SYMBOL_GPL(iomap_fiemap);
 
+static loff_t
+iomap_seek_hole_actor(struct inode *inode, loff_t offset, loff_t length,
+		      void *data, struct iomap *iomap)
+{
+	switch (iomap->type) {
+	case IOMAP_UNWRITTEN:
+		offset = page_cache_seek_hole_data(inode, offset, length,
+						   SEEK_HOLE);
+		if (offset < 0)
+			return length;
+		/* fall through */
+	case IOMAP_HOLE:
+		*(loff_t *)data = offset;
+		return 0;
+	default:
+		return length;
+	}
+}
+
+loff_t
+iomap_seek_hole(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
+{
+	loff_t size = i_size_read(inode);
+	loff_t length = size - offset;
+	loff_t ret;
+
+	/* Nothing to be found beyond the end of the file. */
+	if (offset >= size)
+		return -ENXIO;
+
+	while (length > 0) {
+		ret = iomap_apply(inode, offset, length, IOMAP_REPORT, ops,
+				  &offset, iomap_seek_hole_actor);
+		if (ret < 0)
+			return ret;
+		if (ret == 0)
+			break;
+
+		offset += ret;
+		length -= ret;
+	}
+
+	return offset;
+}
+EXPORT_SYMBOL_GPL(iomap_seek_hole);
+
+static loff_t
+iomap_seek_data_actor(struct inode *inode, loff_t offset, loff_t length,
+		      void *data, struct iomap *iomap)
+{
+	switch (iomap->type) {
+	case IOMAP_HOLE:
+		return length;
+	case IOMAP_UNWRITTEN:
+		offset = page_cache_seek_hole_data(inode, offset, length,
+						   SEEK_DATA);
+		if (offset < 0)
+			return length;
+		/*FALLTHRU*/
+	default:
+		*(loff_t *)data = offset;
+		return 0;
+	}
+}
+
+loff_t
+iomap_seek_data(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
+{
+	loff_t size = i_size_read(inode);
+	loff_t length = size - offset;
+	loff_t ret;
+
+	/* Nothing to be found beyond the end of the file. */
+	if (offset >= size)
+		return -ENXIO;
+
+	while (length > 0) {
+		ret = iomap_apply(inode, offset, length, IOMAP_REPORT, ops,
+				  &offset, iomap_seek_data_actor);
+		if (ret < 0)
+			return ret;
+		if (ret == 0)
+			break;
+
+		offset += ret;
+		length -= ret;
+	}
+
+	if (length <= 0)
+		return -ENXIO;
+	return offset;
+}
+EXPORT_SYMBOL_GPL(iomap_seek_data);
+
 /*
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index f753e788da31..8a03f5dcd89b 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -83,6 +83,10 @@ int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops);
 int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		loff_t start, loff_t len, const struct iomap_ops *ops);
+loff_t iomap_seek_hole(struct inode *inode, loff_t offset,
+		const struct iomap_ops *ops);
+loff_t iomap_seek_data(struct inode *inode, loff_t offset,
+		const struct iomap_ops *ops);
 
 /*
  * Flags for direct I/O ->end_io:
-- 
2.11.0


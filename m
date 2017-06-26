Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751435AbdFZOZb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jun 2017 10:25:31 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v3 4/5] vfs: Add iomap_seek_hole_data helper
Date: Mon, 26 Jun 2017 16:25:17 +0200
Message-Id: <1498487118-6564-5-git-send-email-agruenba@redhat.com>
In-Reply-To: <1498487118-6564-1-git-send-email-agruenba@redhat.com>
References: <1498487118-6564-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

Filesystems can use this for implementing lseek SEEK_HOLE / SEEK_DATA
support via iomap.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap.c            | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h |  3 ++
 2 files changed, 94 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index c71a64b..ced7423 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -584,6 +584,97 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 }
 EXPORT_SYMBOL_GPL(iomap_fiemap);
 
+static loff_t
+iomap_seek_hole_actor(struct inode *inode, loff_t offset, loff_t length,
+		      void *data, struct iomap *iomap)
+{
+	switch(iomap->type) {
+	case IOMAP_UNWRITTEN:
+		offset = page_cache_seek_hole_data(inode, offset, length,
+						   SEEK_HOLE);
+		if (offset < 0)
+			break;
+		/* fall through */
+	case IOMAP_HOLE:
+		*(loff_t *)data = offset;
+		return 0;
+	}
+	return length;
+}
+
+static loff_t
+iomap_seek_data_actor(struct inode *inode, loff_t offset, loff_t length,
+		      void *data, struct iomap *iomap)
+{
+	switch(iomap->type) {
+	case IOMAP_UNWRITTEN:
+		offset = page_cache_seek_hole_data(inode, offset, length,
+						   SEEK_DATA);
+		if (offset >= 0)
+			break;
+		/* fall through */
+	case IOMAP_HOLE:
+		return length;
+	}
+	*(loff_t *)data = offset;
+	return 0;
+}
+
+/*
+ * Filesystem helper for lseek SEEK_HOLE / SEEK_DATA.
+ */
+loff_t
+iomap_seek_hole_data(struct inode *inode, loff_t offset,
+		     int whence, const struct iomap_ops *ops)
+{
+	static loff_t (*actor)(struct inode *, loff_t, loff_t, void *,
+			       struct iomap *);
+	loff_t size = i_size_read(inode);
+	loff_t length;
+
+	/* Nothing to be found beyond the end of the file. */
+	if (offset >= size)
+		return -ENXIO;
+	length = size - offset;
+
+	switch(whence) {
+	case SEEK_HOLE:
+		actor = iomap_seek_hole_actor;
+		break;
+
+	case SEEK_DATA:
+		actor = iomap_seek_data_actor;
+		break;
+	}
+
+	while (length > 0) {
+		loff_t ret;
+
+		ret = iomap_apply(inode, offset, length, IOMAP_REPORT, ops,
+				  &offset, actor);
+		if (ret <= 0) {
+			if (ret < 0)
+				return ret;
+			break;
+		}
+		offset += ret;
+		length -= ret;
+	}
+
+	if (length <= 0) {
+		/* There is an implicit hole at the end of the file. */
+		if (whence != SEEK_HOLE)
+			return -ENXIO;
+
+		/* The last segment can extend beyond the end of the file. */
+		if (offset > size)
+			offset = size;
+	}
+
+	return offset;
+}
+EXPORT_SYMBOL_GPL(iomap_seek_hole_data);
+
 /*
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 69f4e94..ca0a5ec 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -84,6 +84,9 @@ int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops);
 int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		loff_t start, loff_t len, const struct iomap_ops *ops);
+loff_t iomap_seek_hole_data(struct inode *inode, loff_t offset,
+			    int whence, const struct iomap_ops *ops);
+
 
 /*
  * Flags for direct I/O ->end_io:
-- 
2.7.5


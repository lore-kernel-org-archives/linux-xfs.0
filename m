Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751183AbdFWNeu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jun 2017 09:34:50 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 1/6] vfs: Add iomap_seek_hole_data helper
Date: Fri, 23 Jun 2017 15:34:39 +0200
Message-Id: <1498224884-346-2-git-send-email-agruenba@redhat.com>
In-Reply-To: <1498224884-346-1-git-send-email-agruenba@redhat.com>
References: <1498224884-346-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>

Filesystems can use this for implementing lseek SEEK_HOLE / SEEK_DATA
support via iomap.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap.c            | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h |  3 ++
 2 files changed, 92 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 4b10892..781f0a0 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -584,6 +584,95 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 }
 EXPORT_SYMBOL_GPL(iomap_fiemap);
 
+static loff_t
+iomap_seek_hole_actor(struct inode *inode, loff_t offset, loff_t length,
+		      void *data, struct iomap *iomap)
+{
+	if (iomap->type == IOMAP_HOLE)
+		goto found;
+	length = iomap->offset + iomap->length - offset;
+	if (iomap->type != IOMAP_UNWRITTEN)
+		return length;
+	offset = page_cache_seek_hole_data(inode, offset, length, SEEK_HOLE);
+	if (offset < 0)
+		return length;
+found:
+	*(loff_t *)data = offset;
+	return 0;
+}
+
+static loff_t
+iomap_seek_data_actor(struct inode *inode, loff_t offset, loff_t length,
+		      void *data, struct iomap *iomap)
+{
+	if (iomap->type != IOMAP_HOLE && iomap->type != IOMAP_UNWRITTEN)
+		goto found;
+	length = iomap->offset + iomap->length - offset;
+	if (iomap->type != IOMAP_UNWRITTEN)
+		return length;
+	offset = page_cache_seek_hole_data(inode, offset, length, SEEK_DATA);
+	if (offset < 0)
+		return length;
+found:
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
index f753e78..ff89026 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -83,6 +83,9 @@ int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
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


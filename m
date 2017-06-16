Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754429AbdFPOvj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 10:51:39 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 4/7] vfs: Add iomap_seek_hole_data helper
Date: Fri, 16 Jun 2017 16:51:17 +0200
Message-Id: <1497624680-16685-5-git-send-email-agruenba@redhat.com>
In-Reply-To: <1497624680-16685-1-git-send-email-agruenba@redhat.com>
References: <1497624680-16685-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Bob Peterson <rpeterso@redhat.com>, linux-xfs@vger.kernel.org, cluster-devel@redhat.com

Filesystems can use this for implementing lseek SEEK_HOLE / SEEK_DATA
support via iomap.

The __iomap_seek_hole_data helper takes an additional size argument and
doesn't reposition the file offset; this is for internal use for xfs
quota files which don't maintain the inode size.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap.c            | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h |  6 ++++
 2 files changed, 87 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 4b10892..cf01694 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -584,6 +584,87 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 }
 EXPORT_SYMBOL_GPL(iomap_fiemap);
 
+static loff_t
+iomap_seek_hole_actor(struct inode *inode, loff_t offset, loff_t length,
+		      void *data, struct iomap *iomap)
+{
+	if (iomap->type == IOMAP_HOLE)
+		return 0;
+	return iomap->offset + iomap->length - offset;
+}
+
+static loff_t
+iomap_seek_data_actor(struct inode *inode, loff_t offset, loff_t length,
+		      void *data, struct iomap *iomap)
+{
+	if (iomap->type != IOMAP_HOLE)
+		return 0;
+	return iomap->offset + iomap->length - offset;
+}
+
+loff_t
+__iomap_seek_hole_data(struct inode *inode, loff_t offset, loff_t size,
+		       int whence, const struct iomap_ops *ops)
+{
+	static loff_t (*actor)(struct inode *, loff_t, loff_t, void *,
+			       struct iomap *);
+	loff_t len = size - offset;
+	loff_t ret;
+
+	/* Nothing to be found beyond the end of the file. */
+	if (len <= 0)
+		return -ENXIO;
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
+	while (len > 0) {
+		ret = iomap_apply(inode, offset, len, IOMAP_REPORT, ops,
+				  NULL, actor);
+		if (ret <= 0) {
+			if (ret < 0)
+				return ret;
+			break;
+		}
+		offset += ret;
+		len -= ret;
+	}
+
+	if (len <= 0) {
+		/* There is an implicit hole at the end of the file. */
+		if (whence != SEEK_HOLE)
+			offset = -ENXIO;
+
+		/* The last segment can extend beyond the end of the file. */
+		if (offset > size)
+			offset = size;
+	}
+
+	return offset;
+}
+EXPORT_SYMBOL_GPL(__iomap_seek_hole_data);
+
+loff_t
+iomap_seek_hole_data(struct file *file, loff_t offset, int whence,
+		     const struct iomap_ops *ops)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	offset = __iomap_seek_hole_data(inode, offset, i_size_read(inode),
+					whence, ops);
+	if (offset <= 0)
+		return offset;
+	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
+}
+EXPORT_SYMBOL_GPL(iomap_seek_hole_data);
+
 /*
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 9d64933..49b6ec0 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -85,6 +85,12 @@ int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops);
 int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		loff_t start, loff_t len, const struct iomap_ops *ops);
 
+struct file;
+loff_t __iomap_seek_hole_data(struct inode *inode, loff_t pos, loff_t size,
+			      int whence, const struct iomap_ops *ops);
+loff_t iomap_seek_hole_data(struct file *file, loff_t pos,
+			    int whence, const struct iomap_ops *ops);
+
 /*
  * Flags for direct I/O ->end_io:
  */
-- 
2.7.5


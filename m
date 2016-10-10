Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37360 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbcJJNiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 09:38:13 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/9] iomap: add IOMAP_REPORT
Date: Mon, 10 Oct 2016 15:37:57 +0200
Message-Id: <1476106685-29048-2-git-send-email-hch@lst.de>
In-Reply-To: <1476106685-29048-1-git-send-email-hch@lst.de>
References: <1476106685-29048-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

This allows the file system to tell a FIEMAP from a read operation, and thus
avoids the need to report flags that aren't actually used in the read path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c            |  2 +-
 include/linux/iomap.h | 17 +++++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 013d1d3..a922040 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -561,7 +561,7 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 	}
 
 	while (len > 0) {
-		ret = iomap_apply(inode, start, len, 0, ops, &ctx,
+		ret = iomap_apply(inode, start, len, IOMAP_REPORT, ops, &ctx,
 				iomap_fiemap_actor);
 		/* inode with no (attribute) mapping will give ENOENT */
 		if (ret == -ENOENT)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index e63e288..7892f55 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -19,11 +19,15 @@ struct vm_fault;
 #define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
 
 /*
- * Flags for iomap mappings:
+ * Flags for all iomap mappings:
  */
-#define IOMAP_F_MERGED	0x01	/* contains multiple blocks/extents */
-#define IOMAP_F_SHARED	0x02	/* block shared with another file */
-#define IOMAP_F_NEW	0x04	/* blocks have been newly allocated */
+#define IOMAP_F_NEW	0x01	/* blocks have been newly allocated */
+
+/*
+ * Flags that only need to be reported for IOMAP_REPORT requests:
+ */
+#define IOMAP_F_MERGED	0x10	/* contains multiple blocks/extents */
+#define IOMAP_F_SHARED	0x20	/* block shared with another file */
 
 /*
  * Magic value for blkno:
@@ -42,8 +46,9 @@ struct iomap {
 /*
  * Flags for iomap_begin / iomap_end.  No flag implies a read.
  */
-#define IOMAP_WRITE		(1 << 0)
-#define IOMAP_ZERO		(1 << 1)
+#define IOMAP_WRITE		(1 << 0) /* writing, must allocate blocks */
+#define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
+#define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
 
 struct iomap_ops {
 	/*
-- 
2.10.1.382.ga23ca1b


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37490 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfGOSAD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 14:00:03 -0400
Subject: [PATCH 4/9] iomap: move the SEEK_HOLE code into a separate file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Jul 2019 10:59:45 -0700
Message-ID: <156321358581.148361.8774330141606166898.stgit@magnolia>
In-Reply-To: <156321356040.148361.7463881761568794395.stgit@magnolia>
References: <156321356040.148361.7463881761568794395.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, agruenba@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the SEEK_HOLE/SEEK_DATA code into a separate file so that we can
group related functions in a single file instead of having a single
enormous source file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c        |  201 --------------------------------------------------
 fs/iomap/Makefile |    3 -
 fs/iomap/seek.c   |  214 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 216 insertions(+), 202 deletions(-)
 create mode 100644 fs/iomap/seek.c


diff --git a/fs/iomap.c b/fs/iomap.c
index d14d75a97ab3..ad994c408cb8 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1149,207 +1149,6 @@ vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
 }
 EXPORT_SYMBOL_GPL(iomap_page_mkwrite);
 
-/*
- * Seek for SEEK_DATA / SEEK_HOLE within @page, starting at @lastoff.
- * Returns true if found and updates @lastoff to the offset in file.
- */
-static bool
-page_seek_hole_data(struct inode *inode, struct page *page, loff_t *lastoff,
-		int whence)
-{
-	const struct address_space_operations *ops = inode->i_mapping->a_ops;
-	unsigned int bsize = i_blocksize(inode), off;
-	bool seek_data = whence == SEEK_DATA;
-	loff_t poff = page_offset(page);
-
-	if (WARN_ON_ONCE(*lastoff >= poff + PAGE_SIZE))
-		return false;
-
-	if (*lastoff < poff) {
-		/*
-		 * Last offset smaller than the start of the page means we found
-		 * a hole:
-		 */
-		if (whence == SEEK_HOLE)
-			return true;
-		*lastoff = poff;
-	}
-
-	/*
-	 * Just check the page unless we can and should check block ranges:
-	 */
-	if (bsize == PAGE_SIZE || !ops->is_partially_uptodate)
-		return PageUptodate(page) == seek_data;
-
-	lock_page(page);
-	if (unlikely(page->mapping != inode->i_mapping))
-		goto out_unlock_not_found;
-
-	for (off = 0; off < PAGE_SIZE; off += bsize) {
-		if (offset_in_page(*lastoff) >= off + bsize)
-			continue;
-		if (ops->is_partially_uptodate(page, off, bsize) == seek_data) {
-			unlock_page(page);
-			return true;
-		}
-		*lastoff = poff + off + bsize;
-	}
-
-out_unlock_not_found:
-	unlock_page(page);
-	return false;
-}
-
-/*
- * Seek for SEEK_DATA / SEEK_HOLE in the page cache.
- *
- * Within unwritten extents, the page cache determines which parts are holes
- * and which are data: uptodate buffer heads count as data; everything else
- * counts as a hole.
- *
- * Returns the resulting offset on successs, and -ENOENT otherwise.
- */
-static loff_t
-page_cache_seek_hole_data(struct inode *inode, loff_t offset, loff_t length,
-		int whence)
-{
-	pgoff_t index = offset >> PAGE_SHIFT;
-	pgoff_t end = DIV_ROUND_UP(offset + length, PAGE_SIZE);
-	loff_t lastoff = offset;
-	struct pagevec pvec;
-
-	if (length <= 0)
-		return -ENOENT;
-
-	pagevec_init(&pvec);
-
-	do {
-		unsigned nr_pages, i;
-
-		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping, &index,
-						end - 1);
-		if (nr_pages == 0)
-			break;
-
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
-
-			if (page_seek_hole_data(inode, page, &lastoff, whence))
-				goto check_range;
-			lastoff = page_offset(page) + PAGE_SIZE;
-		}
-		pagevec_release(&pvec);
-	} while (index < end);
-
-	/* When no page at lastoff and we are not done, we found a hole. */
-	if (whence != SEEK_HOLE)
-		goto not_found;
-
-check_range:
-	if (lastoff < offset + length)
-		goto out;
-not_found:
-	lastoff = -ENOENT;
-out:
-	pagevec_release(&pvec);
-	return lastoff;
-}
-
-
-static loff_t
-iomap_seek_hole_actor(struct inode *inode, loff_t offset, loff_t length,
-		      void *data, struct iomap *iomap)
-{
-	switch (iomap->type) {
-	case IOMAP_UNWRITTEN:
-		offset = page_cache_seek_hole_data(inode, offset, length,
-						   SEEK_HOLE);
-		if (offset < 0)
-			return length;
-		/* fall through */
-	case IOMAP_HOLE:
-		*(loff_t *)data = offset;
-		return 0;
-	default:
-		return length;
-	}
-}
-
-loff_t
-iomap_seek_hole(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
-{
-	loff_t size = i_size_read(inode);
-	loff_t length = size - offset;
-	loff_t ret;
-
-	/* Nothing to be found before or beyond the end of the file. */
-	if (offset < 0 || offset >= size)
-		return -ENXIO;
-
-	while (length > 0) {
-		ret = iomap_apply(inode, offset, length, IOMAP_REPORT, ops,
-				  &offset, iomap_seek_hole_actor);
-		if (ret < 0)
-			return ret;
-		if (ret == 0)
-			break;
-
-		offset += ret;
-		length -= ret;
-	}
-
-	return offset;
-}
-EXPORT_SYMBOL_GPL(iomap_seek_hole);
-
-static loff_t
-iomap_seek_data_actor(struct inode *inode, loff_t offset, loff_t length,
-		      void *data, struct iomap *iomap)
-{
-	switch (iomap->type) {
-	case IOMAP_HOLE:
-		return length;
-	case IOMAP_UNWRITTEN:
-		offset = page_cache_seek_hole_data(inode, offset, length,
-						   SEEK_DATA);
-		if (offset < 0)
-			return length;
-		/*FALLTHRU*/
-	default:
-		*(loff_t *)data = offset;
-		return 0;
-	}
-}
-
-loff_t
-iomap_seek_data(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
-{
-	loff_t size = i_size_read(inode);
-	loff_t length = size - offset;
-	loff_t ret;
-
-	/* Nothing to be found before or beyond the end of the file. */
-	if (offset < 0 || offset >= size)
-		return -ENXIO;
-
-	while (length > 0) {
-		ret = iomap_apply(inode, offset, length, IOMAP_REPORT, ops,
-				  &offset, iomap_seek_data_actor);
-		if (ret < 0)
-			return ret;
-		if (ret == 0)
-			break;
-
-		offset += ret;
-		length -= ret;
-	}
-
-	if (length <= 0)
-		return -ENXIO;
-	return offset;
-}
-EXPORT_SYMBOL_GPL(iomap_seek_data);
-
 /*
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
diff --git a/fs/iomap/Makefile b/fs/iomap/Makefile
index 861c07137792..12dc7f844bbd 100644
--- a/fs/iomap/Makefile
+++ b/fs/iomap/Makefile
@@ -9,6 +9,7 @@ ccflags-y += -I $(srctree)/$(src)/..
 obj-$(CONFIG_FS_IOMAP)		+= iomap.o
 
 iomap-y				+= \
-					fiemap.o
+					fiemap.o \
+					seek.o
 
 iomap-$(CONFIG_SWAP)		+= swapfile.o
diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
new file mode 100644
index 000000000000..0c36bef46522
--- /dev/null
+++ b/fs/iomap/seek.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2010 Red Hat, Inc.
+ * Copyright (c) 2016-2018 Christoph Hellwig.
+ */
+#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/fs.h>
+#include <linux/iomap.h>
+#include <linux/pagemap.h>
+#include <linux/pagevec.h>
+
+#include "internal.h"
+
+/*
+ * Seek for SEEK_DATA / SEEK_HOLE within @page, starting at @lastoff.
+ * Returns true if found and updates @lastoff to the offset in file.
+ */
+static bool
+page_seek_hole_data(struct inode *inode, struct page *page, loff_t *lastoff,
+		int whence)
+{
+	const struct address_space_operations *ops = inode->i_mapping->a_ops;
+	unsigned int bsize = i_blocksize(inode), off;
+	bool seek_data = whence == SEEK_DATA;
+	loff_t poff = page_offset(page);
+
+	if (WARN_ON_ONCE(*lastoff >= poff + PAGE_SIZE))
+		return false;
+
+	if (*lastoff < poff) {
+		/*
+		 * Last offset smaller than the start of the page means we found
+		 * a hole:
+		 */
+		if (whence == SEEK_HOLE)
+			return true;
+		*lastoff = poff;
+	}
+
+	/*
+	 * Just check the page unless we can and should check block ranges:
+	 */
+	if (bsize == PAGE_SIZE || !ops->is_partially_uptodate)
+		return PageUptodate(page) == seek_data;
+
+	lock_page(page);
+	if (unlikely(page->mapping != inode->i_mapping))
+		goto out_unlock_not_found;
+
+	for (off = 0; off < PAGE_SIZE; off += bsize) {
+		if (offset_in_page(*lastoff) >= off + bsize)
+			continue;
+		if (ops->is_partially_uptodate(page, off, bsize) == seek_data) {
+			unlock_page(page);
+			return true;
+		}
+		*lastoff = poff + off + bsize;
+	}
+
+out_unlock_not_found:
+	unlock_page(page);
+	return false;
+}
+
+/*
+ * Seek for SEEK_DATA / SEEK_HOLE in the page cache.
+ *
+ * Within unwritten extents, the page cache determines which parts are holes
+ * and which are data: uptodate buffer heads count as data; everything else
+ * counts as a hole.
+ *
+ * Returns the resulting offset on successs, and -ENOENT otherwise.
+ */
+static loff_t
+page_cache_seek_hole_data(struct inode *inode, loff_t offset, loff_t length,
+		int whence)
+{
+	pgoff_t index = offset >> PAGE_SHIFT;
+	pgoff_t end = DIV_ROUND_UP(offset + length, PAGE_SIZE);
+	loff_t lastoff = offset;
+	struct pagevec pvec;
+
+	if (length <= 0)
+		return -ENOENT;
+
+	pagevec_init(&pvec);
+
+	do {
+		unsigned nr_pages, i;
+
+		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping, &index,
+						end - 1);
+		if (nr_pages == 0)
+			break;
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			if (page_seek_hole_data(inode, page, &lastoff, whence))
+				goto check_range;
+			lastoff = page_offset(page) + PAGE_SIZE;
+		}
+		pagevec_release(&pvec);
+	} while (index < end);
+
+	/* When no page at lastoff and we are not done, we found a hole. */
+	if (whence != SEEK_HOLE)
+		goto not_found;
+
+check_range:
+	if (lastoff < offset + length)
+		goto out;
+not_found:
+	lastoff = -ENOENT;
+out:
+	pagevec_release(&pvec);
+	return lastoff;
+}
+
+
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
+	/* Nothing to be found before or beyond the end of the file. */
+	if (offset < 0 || offset >= size)
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
+	/* Nothing to be found before or beyond the end of the file. */
+	if (offset < 0 || offset >= size)
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

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:1838 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729969AbeKGQBV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:21 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/16] iomap: mode iomap_zero_range and friends
Date: Wed,  7 Nov 2018 17:31:19 +1100
Message-Id: <20181107063127.3902-9-david@fromorbit.com>
In-Reply-To: <20181107063127.3902-1-david@fromorbit.com>
References: <20181107063127.3902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We're going to need access to zeroing from within the iomap_write
and iomap_page_mkwrite paths for block size > page size support,
so move it higher up in the file.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c | 158 ++++++++++++++++++++++++++---------------------------
 1 file changed, 79 insertions(+), 79 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index dd6aa6b403a6..e417a5911239 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -769,6 +769,85 @@ iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
 	return ret;
 }
 
+static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
+		unsigned bytes, struct iomap *iomap)
+{
+	struct page *page;
+	int status;
+
+	status = iomap_write_begin(inode, pos, bytes, AOP_FLAG_NOFS, &page,
+				   iomap);
+	if (status)
+		return status;
+
+	zero_user(page, offset, bytes);
+	mark_page_accessed(page);
+
+	return iomap_write_end(inode, pos, bytes, bytes, page, iomap);
+}
+
+static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
+		struct iomap *iomap)
+{
+	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev,
+			iomap_sector(iomap, pos & PAGE_MASK), offset, bytes);
+}
+
+static loff_t
+iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
+		void *data, struct iomap *iomap)
+{
+	bool *did_zero = data;
+	loff_t written = 0;
+	int status;
+
+	/* already zeroed?  we're done. */
+	if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_UNWRITTEN)
+		return count;
+
+	do {
+		unsigned offset, bytes;
+
+		offset = offset_in_page(pos);
+		bytes = min_t(loff_t, PAGE_SIZE - offset, count);
+
+		if (IS_DAX(inode))
+			status = iomap_dax_zero(pos, offset, bytes, iomap);
+		else
+			status = iomap_zero(inode, pos, offset, bytes, iomap);
+		if (status < 0)
+			return status;
+
+		pos += bytes;
+		count -= bytes;
+		written += bytes;
+		if (did_zero)
+			*did_zero = true;
+	} while (count > 0);
+
+	return written;
+}
+
+int
+iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
+		const struct iomap_ops *ops)
+{
+	loff_t ret;
+
+	while (len > 0) {
+		ret = iomap_apply(inode, pos, len, IOMAP_ZERO,
+				ops, did_zero, iomap_zero_range_actor);
+		if (ret <= 0)
+			return ret;
+
+		pos += ret;
+		len -= ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iomap_zero_range);
+
 static loff_t
 iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap)
@@ -951,85 +1030,6 @@ iomap_file_dirty(struct inode *inode, loff_t pos, loff_t len,
 }
 EXPORT_SYMBOL_GPL(iomap_file_dirty);
 
-static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
-		unsigned bytes, struct iomap *iomap)
-{
-	struct page *page;
-	int status;
-
-	status = iomap_write_begin(inode, pos, bytes, AOP_FLAG_NOFS, &page,
-				   iomap);
-	if (status)
-		return status;
-
-	zero_user(page, offset, bytes);
-	mark_page_accessed(page);
-
-	return iomap_write_end(inode, pos, bytes, bytes, page, iomap);
-}
-
-static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
-		struct iomap *iomap)
-{
-	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev,
-			iomap_sector(iomap, pos & PAGE_MASK), offset, bytes);
-}
-
-static loff_t
-iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
-		void *data, struct iomap *iomap)
-{
-	bool *did_zero = data;
-	loff_t written = 0;
-	int status;
-
-	/* already zeroed?  we're done. */
-	if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_UNWRITTEN)
-	    	return count;
-
-	do {
-		unsigned offset, bytes;
-
-		offset = offset_in_page(pos);
-		bytes = min_t(loff_t, PAGE_SIZE - offset, count);
-
-		if (IS_DAX(inode))
-			status = iomap_dax_zero(pos, offset, bytes, iomap);
-		else
-			status = iomap_zero(inode, pos, offset, bytes, iomap);
-		if (status < 0)
-			return status;
-
-		pos += bytes;
-		count -= bytes;
-		written += bytes;
-		if (did_zero)
-			*did_zero = true;
-	} while (count > 0);
-
-	return written;
-}
-
-int
-iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
-		const struct iomap_ops *ops)
-{
-	loff_t ret;
-
-	while (len > 0) {
-		ret = iomap_apply(inode, pos, len, IOMAP_ZERO,
-				ops, did_zero, iomap_zero_range_actor);
-		if (ret <= 0)
-			return ret;
-
-		pos += ret;
-		len -= ret;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(iomap_zero_range);
-
 /*
  * Zero the truncated tail of the page provided.
  *
-- 
2.19.1

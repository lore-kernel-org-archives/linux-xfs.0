Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:1838 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730268AbeKGQBW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:22 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/16] iomap: zero-around in iomap_page_mkwrite
Date: Wed,  7 Nov 2018 17:31:23 +1100
Message-Id: <20181107063127.3902-13-david@fromorbit.com>
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

When we take a write fault over a page in a block size > page size
filesystem, we may have to issue zero-around to initialise all the
pages in the block that mmap is writing to. This is essentially the
same as the zero-around in the buffered write path, with the added
complexity that we have to drop the page lock on the page that
was passed to iomap_page_mkwrite_actor().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 41922fc775c4..7aacd48c593e 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1183,7 +1183,46 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
 		void *data, struct iomap *iomap)
 {
 	struct page *page = data;
-	int ret;
+	loff_t ret;
+
+	/*
+	 * if we need to zero-around, we have to unlock the page we were given.
+	 * No big deal, we just have to repeat the "is this page ours" checks
+	 * after relocking it
+	 */
+	if (iomap_need_zero_around(iomap)) {
+		loff_t size;
+
+		/*
+		 * This only happens for block size > page size, so the file
+		 * offset of a page fault should always be page aligned.
+		 */
+		WARN_ON(offset_in_page(pos));
+
+		unlock_page(page);
+		ret = iomap_zero_around(inode, pos, length, iomap);
+		lock_page(page);
+		size = i_size_read(inode);
+		if ((page->mapping != inode->i_mapping) ||
+		    (page_offset(page) > size)) {
+			/* We overload EFAULT to mean page got truncated */
+			return -EFAULT;
+		}
+
+		if (page_offset(page) != pos) {
+			/* it moved in the file! */
+			return -EFAULT;
+		}
+
+		/* return failure now if zeroing had an error */
+		if (ret)
+			return ret;
+
+		/* trim down the length is we straddle EOF. */
+		if (((page->index + 1) << PAGE_SHIFT) > size)
+			length = offset_in_page(size);
+
+	}
 
 	if (iomap->flags & IOMAP_F_BUFFER_HEAD) {
 		ret = __block_write_begin_int(page, pos, length, NULL, iomap);
-- 
2.19.1

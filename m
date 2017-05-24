Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47583 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935568AbdEXQmF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 May 2017 12:42:05 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 02/10] fs: Introduce filemap_range_has_page()
Date: Wed, 24 May 2017 11:41:42 -0500
Message-Id: <20170524164150.9492-3-rgoldwyn@suse.de>
In-Reply-To: <20170524164150.9492-1-rgoldwyn@suse.de>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

filemap_range_has_page() return true if the file's mapping has
a page within the range mentioned. This function will be used
to check if a write() call will cause a writeback of previous
writes.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fs.h |  2 ++
 mm/filemap.c       | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index f53867140f43..dc0ab585cd56 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2517,6 +2517,8 @@ extern int filemap_fdatawait(struct address_space *);
 extern void filemap_fdatawait_keep_errors(struct address_space *);
 extern int filemap_fdatawait_range(struct address_space *, loff_t lstart,
 				   loff_t lend);
+extern int filemap_range_has_page(struct address_space *, loff_t lstart,
+				  loff_t lend);
 extern int filemap_write_and_wait(struct address_space *mapping);
 extern int filemap_write_and_wait_range(struct address_space *mapping,
 				        loff_t lstart, loff_t lend);
diff --git a/mm/filemap.c b/mm/filemap.c
index 6f1be573a5e6..87aba7698584 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -376,6 +376,39 @@ int filemap_flush(struct address_space *mapping)
 }
 EXPORT_SYMBOL(filemap_flush);
 
+/**
+ * filemap_range_has_page - check if a page exists in range.
+ * @mapping:           address space structure to wait for
+ * @start_byte:        offset in bytes where the range starts
+ * @end_byte:          offset in bytes where the range ends (inclusive)
+ *
+ * Find at least one page in the range supplied, usually used to check if
+ * direct writing in this range will trigger a writeback.
+ */
+int filemap_range_has_page(struct address_space *mapping,
+			   loff_t start_byte, loff_t end_byte)
+{
+	pgoff_t index = start_byte >> PAGE_SHIFT;
+	pgoff_t end = end_byte >> PAGE_SHIFT;
+	struct pagevec pvec;
+	int ret;
+
+	if (end_byte < start_byte)
+		return 0;
+
+	if (mapping->nrpages == 0)
+		return 0;
+
+	pagevec_init(&pvec, 0);
+	ret = pagevec_lookup(&pvec, mapping, index, 1);
+	if (!ret)
+		return 0;
+	ret = (pvec.pages[0]->index <= end);
+	pagevec_release(&pvec);
+	return ret;
+}
+EXPORT_SYMBOL(filemap_range_has_page);
+
 static int __filemap_fdatawait_range(struct address_space *mapping,
 				     loff_t start_byte, loff_t end_byte)
 {
-- 
2.12.0


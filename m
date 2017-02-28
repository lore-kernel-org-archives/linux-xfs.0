Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55554 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751734AbdCAA6c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 19:58:32 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 3/8] nowait aio: return if direct write will trigger writeback
Date: Tue, 28 Feb 2017 17:36:05 -0600
Message-Id: <20170228233610.25456-4-rgoldwyn@suse.de>
In-Reply-To: <20170228233610.25456-1-rgoldwyn@suse.de>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jack@suse.com
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Find out if the write will trigger a wait due to writeback. If yes,
return -EAGAIN.

This introduces a new function filemap_range_has_page() which
returns true if the file's mapping has a page within the range
mentioned.

Return -EINVAL for buffered AIO: there are multiple causes of
delay such as page locks, dirty throttling logic, page loading
from disk etc. which cannot be taken care of.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 include/linux/fs.h |  2 ++
 mm/filemap.c       | 50 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index ab2f556..527ef53 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2494,6 +2494,8 @@ extern int filemap_fdatawait(struct address_space *);
 extern void filemap_fdatawait_keep_errors(struct address_space *);
 extern int filemap_fdatawait_range(struct address_space *, loff_t lstart,
 				   loff_t lend);
+extern int filemap_range_has_page(struct address_space *, loff_t lstart,
+				   loff_t lend);
 extern int filemap_write_and_wait(struct address_space *mapping);
 extern int filemap_write_and_wait_range(struct address_space *mapping,
 				        loff_t lstart, loff_t lend);
diff --git a/mm/filemap.c b/mm/filemap.c
index 78dd50e..82335f4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -375,6 +375,39 @@ int filemap_flush(struct address_space *mapping)
 }
 EXPORT_SYMBOL(filemap_flush);
 
+/**
+ * filemap_range_has_page - check if a page exists in range.
+ * @mapping:		address space structure to wait for
+ * @start_byte:		offset in bytes where the range starts
+ * @end_byte:		offset in bytes where the range ends (inclusive)
+ *
+ * Find at least one page in the range supplied, usually used to check if
+ * direct writing in this range will trigger a writeback.
+ */
+int filemap_range_has_page(struct address_space *mapping,
+				loff_t start_byte, loff_t end_byte)
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
@@ -2631,6 +2664,9 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 
 	pos = iocb->ki_pos;
 
+	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
+		return -EINVAL;
+
 	if (limit != RLIM_INFINITY) {
 		if (iocb->ki_pos >= limit) {
 			send_sig(SIGXFSZ, current, 0);
@@ -2700,9 +2736,17 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	write_len = iov_iter_count(from);
 	end = (pos + write_len - 1) >> PAGE_SHIFT;
 
-	written = filemap_write_and_wait_range(mapping, pos, pos + write_len - 1);
-	if (written)
-		goto out;
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		/* If there are pages to writeback, return */
+		if (filemap_range_has_page(inode->i_mapping, pos,
+					   pos + iov_iter_count(from)))
+			return -EAGAIN;
+	} else {
+		written = filemap_write_and_wait_range(mapping, pos,
+							pos + write_len - 1);
+		if (written)
+			goto out;
+	}
 
 	/*
 	 * After a write we want buffered reads to be sure to go to disk to get
-- 
2.10.2


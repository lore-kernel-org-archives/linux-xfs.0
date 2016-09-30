Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55685 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752464AbcI3Iqq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:46:46 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] fs: update atime before I/O in generic_file_read_iter
Date: Fri, 30 Sep 2016 10:46:34 +0200
Message-Id: <1475225194-3702-3-git-send-email-hch@lst.de>
In-Reply-To: <1475225194-3702-1-git-send-email-hch@lst.de>
References: <1475225194-3702-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

After the call to ->direct_IO the final reference to the file might have
been dropped by aio_complete already, and the call to file_accessed might
cause a use after free.

Instead update the access time before the I/O, similar to how we
update the time stamps before writes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/filemap.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 8a287df..2f1175e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1910,16 +1910,18 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		struct address_space *mapping = file->f_mapping;
 		struct inode *inode = mapping->host;
+		struct iov_iter data = *iter;
 		loff_t size;
 
 		size = i_size_read(inode);
 		retval = filemap_write_and_wait_range(mapping, iocb->ki_pos,
 					iocb->ki_pos + count - 1);
-		if (!retval) {
-			struct iov_iter data = *iter;
-			retval = mapping->a_ops->direct_IO(iocb, &data);
-		}
+		if (retval < 0)
+			goto out;
 
+		file_accessed(file);
+
+		retval = mapping->a_ops->direct_IO(iocb, &data);
 		if (retval > 0) {
 			iocb->ki_pos += retval;
 			iov_iter_advance(iter, retval);
@@ -1935,10 +1937,8 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		 * DAX files, so don't bother trying.
 		 */
 		if (retval < 0 || !iov_iter_count(iter) || iocb->ki_pos >= size ||
-		    IS_DAX(inode)) {
-			file_accessed(file);
+		    IS_DAX(inode))
 			goto out;
-		}
 	}
 
 	retval = do_generic_file_read(file, &iocb->ki_pos, iter, retval);
-- 
2.1.4


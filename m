Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33162 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdB1O6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 09:58:04 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/12] iomap: add a IOMAP_ATOMIC flag
Date: Tue, 28 Feb 2017 06:57:28 -0800
Message-Id: <20170228145737.19016-4-hch@lst.de>
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
References: <20170228145737.19016-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

To pass through O_ATOMIC to the iomap_begin methods.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c            | 13 +++++++++++--
 include/linux/iomap.h |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 16a9d2b89cb6..096cbf573932 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -237,6 +237,10 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *iter,
 {
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
 	loff_t pos = iocb->ki_pos, ret = 0, written = 0;
+	unsigned flags = IOMAP_WRITE;
+
+	if (iocb->ki_filp->f_flags & O_ATOMIC)
+		flags |= IOMAP_ATOMIC;
 
 	while (iov_iter_count(iter)) {
 		ret = iomap_apply(inode, pos, iov_iter_count(iter),
@@ -452,8 +456,12 @@ int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	struct inode *inode = file_inode(vma->vm_file);
 	unsigned long length;
 	loff_t offset, size;
+	unsigned flags = IOMAP_WRITE | IOMAP_FAULT;
 	ssize_t ret;
 
+	if (vma->vm_file->f_flags & O_ATOMIC)
+		flags |= IOMAP_ATOMIC;
+
 	lock_page(page);
 	size = i_size_read(inode);
 	if ((page->mapping != inode->i_mapping) ||
@@ -471,8 +479,7 @@ int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	offset = page_offset(page);
 	while (length > 0) {
-		ret = iomap_apply(inode, offset, length,
-				IOMAP_WRITE | IOMAP_FAULT, ops, page,
+		ret = iomap_apply(inode, offset, length, flags, ops, page,
 				iomap_page_mkwrite_actor);
 		if (unlikely(ret <= 0))
 			goto out_unlock;
@@ -883,6 +890,8 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	} else {
 		dio->flags |= IOMAP_DIO_WRITE;
 		flags |= IOMAP_WRITE;
+		if (iocb->ki_filp->f_flags & O_ATOMIC)
+			flags |= IOMAP_ATOMIC;
 	}
 
 	if (mapping->nrpages) {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 891459caa278..a670ff18ccd6 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -51,6 +51,7 @@ struct iomap {
 #define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
 #define IOMAP_FAULT		(1 << 3) /* mapping for page fault */
 #define IOMAP_DIRECT		(1 << 4) /* direct I/O */
+#define IOMAP_ATOMIC		(1 << 5) /* atomic write vs power fail */
 
 struct iomap_ops {
 	/*
-- 
2.11.0


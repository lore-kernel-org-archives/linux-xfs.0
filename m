Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37183 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752000AbdB1O6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 09:58:04 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/12] fs: add a BH_Atomic flag
Date: Tue, 28 Feb 2017 06:57:29 -0800
Message-Id: <20170228145737.19016-5-hch@lst.de>
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
References: <20170228145737.19016-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

This allows us propagate the O_ATOMIC flag through the writeback code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/buffer.c                 | 13 +++++++++----
 fs/internal.h               |  2 +-
 fs/iomap.c                  |  4 ++--
 include/linux/buffer_head.h |  2 ++
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 0e87401cf335..85b0dce31b34 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1937,7 +1937,7 @@ EXPORT_SYMBOL(page_zero_new_buffers);
 
 static void
 iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
-		struct iomap *iomap)
+		struct iomap *iomap, unsigned flags)
 {
 	loff_t offset = block << inode->i_blkbits;
 
@@ -1987,10 +1987,15 @@ iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
 		set_buffer_mapped(bh);
 		break;
 	}
+
+	if (flags & IOMAP_ATOMIC)
+		set_buffer_atomic(bh);
+	else
+		clear_buffer_atomic(bh);
 }
 
 int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
-		get_block_t *get_block, struct iomap *iomap)
+		get_block_t *get_block, struct iomap *iomap, unsigned flags)
 {
 	unsigned from = pos & (PAGE_SIZE - 1);
 	unsigned to = from + len;
@@ -2031,7 +2036,7 @@ int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
 				if (err)
 					break;
 			} else {
-				iomap_to_bh(inode, block, bh, iomap);
+				iomap_to_bh(inode, block, bh, iomap, flags);
 			}
 
 			if (buffer_new(bh)) {
@@ -2077,7 +2082,7 @@ int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
 int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 		get_block_t *get_block)
 {
-	return __block_write_begin_int(page, pos, len, get_block, NULL);
+	return __block_write_begin_int(page, pos, len, get_block, NULL, 0);
 }
 EXPORT_SYMBOL(__block_write_begin);
 
diff --git a/fs/internal.h b/fs/internal.h
index 1934fdb2bb27..5f4cbdedafdb 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -42,7 +42,7 @@ static inline int __sync_blockdev(struct block_device *bdev, int wait)
  */
 extern void guard_bio_eod(int rw, struct bio *bio);
 extern int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
-		get_block_t *get_block, struct iomap *iomap);
+		get_block_t *get_block, struct iomap *iomap, unsigned flags);
 
 /*
  * char_dev.c
diff --git a/fs/iomap.c b/fs/iomap.c
index 096cbf573932..3c3c09104dcd 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -119,7 +119,7 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len,
 	if (!page)
 		return -ENOMEM;
 
-	status = __block_write_begin_int(page, pos, len, NULL, iomap);
+	status = __block_write_begin_int(page, pos, len, NULL, iomap, flags);
 	if (unlikely(status)) {
 		unlock_page(page);
 		put_page(page);
@@ -441,7 +441,7 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
 	struct page *page = data;
 	int ret;
 
-	ret = __block_write_begin_int(page, pos, length, NULL, iomap);
+	ret = __block_write_begin_int(page, pos, length, NULL, iomap, flags);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index d67ab83823ad..baff49fdfbe8 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -37,6 +37,7 @@ enum bh_state_bits {
 	BH_Meta,	/* Buffer contains metadata */
 	BH_Prio,	/* Buffer should be submitted with REQ_PRIO */
 	BH_Defer_Completion, /* Defer AIO completion to workqueue */
+	BH_Atomic,	/* part of an O_ATOMIC write */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
@@ -130,6 +131,7 @@ BUFFER_FNS(Unwritten, unwritten)
 BUFFER_FNS(Meta, meta)
 BUFFER_FNS(Prio, prio)
 BUFFER_FNS(Defer_Completion, defer_completion)
+BUFFER_FNS(Atomic, atomic);
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 
-- 
2.11.0


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:2964 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726670AbfGCHzf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 03:55:35 -0400
From: Chao Yu <yuchao0@huawei.com>
Subject: [RFC PATCH] iomap: generalize IOMAP_INLINE to cover tail-packing case
Date: Wed, 3 Jul 2019 15:55:02 +0800
Message-ID: <20190703075502.79782-1-yuchao0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, andreas.gruenbacher@gmail.com, gaoxiang25@huawei.com, chao@kernel.org, Chao Yu <yuchao0@huawei.com>

Some filesystems like erofs/reiserfs have the ability to pack tail
data into metadata, e.g.:
IOMAP_MAPPED [0, 8192]
IOMAP_INLINE [8192, 8200]

However current IOMAP_INLINE type has assumption that:
- inline data should be locating at page #0.
- inline size should equal to .i_size
Those restriction fail to convert to use iomap IOMAP_INLINE in erofs,
so this patch tries to relieve above limits to make IOMAP_INLINE more
generic to cover tail-packing case.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
---
 fs/iomap.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 12654c2e78f8..d1c16b692d31 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -264,13 +264,12 @@ static void
 iomap_read_inline_data(struct inode *inode, struct page *page,
 		struct iomap *iomap)
 {
-	size_t size = i_size_read(inode);
+	size_t size = iomap->length;
 	void *addr;
 
 	if (PageUptodate(page))
 		return;
 
-	BUG_ON(page->index);
 	BUG_ON(size > PAGE_SIZE - offset_in_page(iomap->inline_data));
 
 	addr = kmap_atomic(page);
@@ -293,7 +292,6 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	sector_t sector;
 
 	if (iomap->type == IOMAP_INLINE) {
-		WARN_ON_ONCE(pos);
 		iomap_read_inline_data(inode, page, iomap);
 		return PAGE_SIZE;
 	}
-- 
2.18.0.rc1

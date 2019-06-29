Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:2960 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726527AbfF2Hao (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 29 Jun 2019 03:30:44 -0400
From: Chao Yu <yuchao0@huawei.com>
Subject: [PATCH RFC] iomap: introduce IOMAP_TAIL
Date: Sat, 29 Jun 2019 15:30:20 +0800
Message-ID: <20190629073020.22759-1-yuchao0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, gaoxiang25@huawei.com, chao@kernel.org, Chao Yu <yuchao0@huawei.com>

Some filesystems like erofs/reiserfs have the ability to pack tail
data into metadata, however iomap framework can only support mapping
inline data with IOMAP_INLINE type, it restricts that:
- inline data should be locating at page #0.
- inline size should equal to .i_size
So we can not use IOMAP_INLINE to handle tail-packing case.

This patch introduces new mapping type IOMAP_TAIL to map tail-packed
data for further use of erofs.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
---
 fs/iomap.c            | 22 ++++++++++++++++++++++
 include/linux/iomap.h |  1 +
 2 files changed, 23 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 12654c2e78f8..ae7777ce77d0 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -280,6 +280,23 @@ iomap_read_inline_data(struct inode *inode, struct page *page,
 	SetPageUptodate(page);
 }
 
+static void
+iomap_read_tail_data(struct inode *inode, struct page *page,
+		struct iomap *iomap)
+{
+	size_t size = i_size_read(inode) & (PAGE_SIZE - 1);
+	void *addr;
+
+	if (PageUptodate(page))
+		return;
+
+	addr = kmap_atomic(page);
+	memcpy(addr, iomap->inline_data, size);
+	memset(addr + size, 0, PAGE_SIZE - size);
+	kunmap_atomic(addr);
+	SetPageUptodate(page);
+}
+
 static loff_t
 iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap)
@@ -298,6 +315,11 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		return PAGE_SIZE;
 	}
 
+	if (iomap->type == IOMAP_TAIL) {
+		iomap_read_tail_data(inode, page, iomap);
+		return PAGE_SIZE;
+	}
+
 	/* zero post-eof blocks as the page may be mapped */
 	iomap_adjust_read_range(inode, iop, &pos, length, &poff, &plen);
 	if (plen == 0)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 2103b94cb1bf..7e1ee48e3db7 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -25,6 +25,7 @@ struct vm_fault;
 #define IOMAP_MAPPED	0x03	/* blocks allocated at @addr */
 #define IOMAP_UNWRITTEN	0x04	/* blocks allocated at @addr in unwritten state */
 #define IOMAP_INLINE	0x05	/* data inline in the inode */
+#define IOMAP_TAIL	0x06	/* tail data packed in metdata */
 
 /*
  * Flags for all iomap mappings:
-- 
2.18.0.rc1

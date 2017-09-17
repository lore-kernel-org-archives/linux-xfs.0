Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54712 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752098AbdIQVHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:23 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/47] iomap: fix integer truncation issues in the zeroing and dirtying helpers
Date: Sun, 17 Sep 2017 14:06:45 -0700
Message-Id: <20170917210712.10804-21-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit e28ae8e428fefe2facd72cea9f29906ecb9c861d upstream.

Fix the min_t calls in the zeroing and dirtying helpers to perform the
comparisms on 64-bit types, which prevents them from incorrectly
being truncated, and larger zeroing operations being stuck in a never
ending loop.

Special thanks to Markus Stockhausen for spotting the bug.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 798c291cbc75..a49db8806a3a 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -281,7 +281,7 @@ iomap_dirty_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		unsigned long bytes;	/* Bytes to write to page */
 
 		offset = (pos & (PAGE_SIZE - 1));
-		bytes = min_t(unsigned long, PAGE_SIZE - offset, length);
+		bytes = min_t(loff_t, PAGE_SIZE - offset, length);
 
 		rpage = __iomap_read_page(inode, pos);
 		if (IS_ERR(rpage))
@@ -376,7 +376,7 @@ iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
 		unsigned offset, bytes;
 
 		offset = pos & (PAGE_SIZE - 1); /* Within page */
-		bytes = min_t(unsigned, PAGE_SIZE - offset, count);
+		bytes = min_t(loff_t, PAGE_SIZE - offset, count);
 
 		if (IS_DAX(inode))
 			status = iomap_dax_zero(pos, offset, bytes, iomap);
-- 
2.14.1


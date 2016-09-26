Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33588 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965962AbcIZQ2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2016 12:28:45 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] ext2: fix possible integer truncation in ext2_iomap_begin
Date: Mon, 26 Sep 2016 09:28:38 -0700
Message-Id: <1474907318-19561-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org

For 32-bit architectures we need to cast first_block to u64 before
shifting it left.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index aae5f61..c7dbb46 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -806,7 +806,7 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	iomap->flags = 0;
 	iomap->bdev = inode->i_sb->s_bdev;
-	iomap->offset = first_block << blkbits;
+	iomap->offset = (u64)first_block << blkbits;
 
 	if (ret == 0) {
 		iomap->type = IOMAP_HOLE;
-- 
2.1.4


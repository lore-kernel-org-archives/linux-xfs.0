Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38211 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932522AbcJQMGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 08:06:45 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] xfs: remove the same fs check from xfs_file_share_range
Date: Mon, 17 Oct 2016 14:05:17 +0200
Message-Id: <1476705920-32493-2-git-send-email-hch@lst.de>
In-Reply-To: <1476705920-32493-1-git-send-email-hch@lst.de>
References: <1476705920-32493-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

The VFS already does the check, and the placement of this duplicate is in
the way of the following locking rework.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a314fc7..20563f2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1003,9 +1003,6 @@ xfs_file_share_range(
 	    IS_SWAPFILE(inode_out))
 		return -ETXTBSY;
 
-	/* Reflink only works within this filesystem. */
-	if (inode_in->i_sb != inode_out->i_sb)
-		return -EXDEV;
 	same_inode = (inode_in->i_ino == inode_out->i_ino);
 
 	/* Don't reflink dirs, pipes, sockets... */
-- 
2.1.4


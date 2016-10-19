Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60418 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938936AbcJSOUl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Oct 2016 10:20:41 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] xfs: fix the same_inode check in xfs_file_share_range
Date: Wed, 19 Oct 2016 14:47:25 +0200
Message-Id: <1476881248-18669-3-git-send-email-hch@lst.de>
In-Reply-To: <1476881248-18669-1-git-send-email-hch@lst.de>
References: <1476881248-18669-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

The VFS i_ino is an unsigned long, while XFS inode numbers are 64-bit
wide, so checking i_ino for equality could lead to rate false positives
on 32-bit architectures.  Just compare the inode pointers themselves
to be safe.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 20563f2..012a960 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1003,7 +1003,7 @@ xfs_file_share_range(
 	    IS_SWAPFILE(inode_out))
 		return -ETXTBSY;
 
-	same_inode = (inode_in->i_ino == inode_out->i_ino);
+	same_inode = (inode_in == inode_out);
 
 	/* Don't reflink dirs, pipes, sockets... */
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
-- 
2.1.4


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60916 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933245AbeB1Rp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Feb 2018 12:45:59 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] xfs: don't start out with the exclusive ilock for direct I/O
Date: Wed, 28 Feb 2018 09:45:51 -0800
Message-Id: <20180228174552.31919-3-hch@lst.de>
In-Reply-To: <20180228174552.31919-1-hch@lst.de>
References: <20180228174552.31919-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com

There is no reason to take the ilock exclusively at the start of
xfs_file_iomap_begin for direct I/O, given that it will be demoted
just before calling xfs_iomap_write_direct anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4e771e0f1170..ee01859b77a5 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -965,13 +965,11 @@ static inline bool needs_cow_for_zeroing(struct xfs_bmbt_irec *imap, int nimaps)
 static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
 {
 	/*
-	 * COW writes will allocate delalloc space, so we need to make sure
-	 * to take the lock exclusively here.
+	 * COW writes may allocate delalloc space or convert unwritten COW
+	 * extents, so we need to make sure to take the lock exclusively here.
 	 */
 	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO)))
 		return true;
-	if ((flags & IOMAP_DIRECT) && (flags & IOMAP_WRITE))
-		return true;
 	return false;
 }
 
-- 
2.14.2


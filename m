Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46178 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932316AbeBVPG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 10:06:56 -0500
Received: from [107.17.164.176] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eosSV-0006pm-SB
        for linux-xfs@vger.kernel.org; Thu, 22 Feb 2018 15:06:55 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: don't block on the ilock for RWF_NOWAIT
Date: Thu, 22 Feb 2018 07:06:53 -0800
Message-Id: <20180222150653.18479-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Fix xfs_file_iomap_begin to trylock the ilock if IOMAP_NOWAIT is passed,
so that we don't block io_submit callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 221d218f08a9..6dccc76d2b37 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -993,16 +993,20 @@ xfs_file_iomap_begin(
 		return xfs_file_iomap_begin_delay(inode, offset, length, iomap);
 	}
 
-	if (need_excl_ilock(ip, flags)) {
+	if (need_excl_ilock(ip, flags) ||
+	    ((ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
+	      !(ip->i_df.if_flags & XFS_IFEXTENTS))))
 		lockmode = XFS_ILOCK_EXCL;
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-	} else {
-		lockmode = xfs_ilock_data_map_shared(ip);
-	}
+	else
+		lockmode = XFS_ILOCK_SHARED;
 
-	if ((flags & IOMAP_NOWAIT) && !(ip->i_df.if_flags & XFS_IFEXTENTS)) {
-		error = -EAGAIN;
-		goto out_unlock;
+	if (flags & IOMAP_NOWAIT) {
+		if (!(ip->i_df.if_flags & XFS_IFEXTENTS))
+			return -EAGAIN;
+		if (!xfs_ilock_nowait(ip, lockmode))
+			return -EAGAIN;
+	} else {
+		xfs_ilock(ip, lockmode);
 	}
 
 	ASSERT(offset <= mp->m_super->s_maxbytes);
-- 
2.14.2


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60954 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934466AbeB1RqA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Feb 2018 12:46:00 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] xfs: don't block on the ilock for RWF_NOWAIT
Date: Wed, 28 Feb 2018 09:45:52 -0800
Message-Id: <20180228174552.31919-4-hch@lst.de>
In-Reply-To: <20180228174552.31919-1-hch@lst.de>
References: <20180228174552.31919-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com

Fix xfs_file_iomap_begin to trylock the ilock if IOMAP_NOWAIT is passed,
so that we don't block io_submit callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ee01859b77a5..046469fcc1b8 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -970,6 +970,15 @@ static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
 	 */
 	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO)))
 		return true;
+
+	/*
+	 * Extents not yet cached requires exclusive access, don't block.
+	 * This is an opencoded xfs_ilock_data_map_shared() to cater for the
+	 * non-blocking behaviour.
+	 */
+	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
+	    !(ip->i_df.if_flags & XFS_IFEXTENTS))
+		return true;
 	return false;
 }
 
@@ -998,16 +1007,18 @@ xfs_file_iomap_begin(
 		return xfs_file_iomap_begin_delay(inode, offset, length, iomap);
 	}
 
-	if (need_excl_ilock(ip, flags)) {
+	if (need_excl_ilock(ip, flags))
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


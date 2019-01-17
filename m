Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53116 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbfAQQgm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 11:36:42 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/11] xfs: remove xfs_trim_extent_eof
Date: Thu, 17 Jan 2019 17:36:26 +0100
Message-Id: <20190117163636.23171-2-hch@lst.de>
In-Reply-To: <20190117163636.23171-1-hch@lst.de>
References: <20190117163636.23171-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>

Opencoding this function in the only caller makes it blindly obvious
what is going on instead of having to look at two files for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 11 -----------
 fs/xfs/libxfs/xfs_bmap.h |  1 -
 fs/xfs/xfs_aops.c        |  2 +-
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 332eefa2700b..4c73927819c2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3685,17 +3685,6 @@ xfs_trim_extent(
 	}
 }
 
-/* trim extent to within eof */
-void
-xfs_trim_extent_eof(
-	struct xfs_bmbt_irec	*irec,
-	struct xfs_inode	*ip)
-
-{
-	xfs_trim_extent(irec, 0, XFS_B_TO_FSB(ip->i_mount,
-					      i_size_read(VFS_I(ip))));
-}
-
 /*
  * Trim the returned map to the required bounds
  */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 09d3ea97cc15..b4ff710d7250 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -181,7 +181,6 @@ static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
 
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
-void	xfs_trim_extent_eof(struct xfs_bmbt_irec *, struct xfs_inode *);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 338b9d9984e0..d7275075878e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -329,7 +329,7 @@ xfs_map_blocks(
 	 * mechanism to protect us from arbitrary extent modifying contexts, not
 	 * just eofblocks.
 	 */
-	xfs_trim_extent_eof(&wpc->imap, ip);
+	xfs_trim_extent(&wpc->imap, 0, XFS_B_TO_FSB(mp, i_size_read(inode)));
 
 	/*
 	 * COW fork blocks can overlap data fork blocks even if the blocks
-- 
2.20.1

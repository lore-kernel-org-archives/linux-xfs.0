Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49896 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753121AbcJOIxf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Oct 2016 04:53:35 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 9/9] xfs: remove xfs_bunmapi_cow
Date: Sat, 15 Oct 2016 10:52:34 +0200
Message-Id: <1476521554-1894-10-git-send-email-hch@lst.de>
In-Reply-To: <1476521554-1894-1-git-send-email-hch@lst.de>
References: <1476521554-1894-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, bfoster@redhat.com

Since no one uses it anymore.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 22 ----------------------
 fs/xfs/libxfs/xfs_bmap.h |  1 -
 2 files changed, 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 64f82c8..cc193e6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5417,28 +5417,6 @@ xfs_bmap_del_extent(
 	return error;
 }
 
-/* Remove an extent from the CoW fork.  Similar to xfs_bmap_del_extent. */
-int
-xfs_bunmapi_cow(
-	struct xfs_inode		*ip,
-	struct xfs_bmbt_irec		*del)
-{
-	struct xfs_bmbt_rec_host	*ep;
-	struct xfs_bmbt_irec		got;
-	struct xfs_bmbt_irec		new;
-	int				eof;
-	xfs_extnum_t			eidx;
-
-	ep = xfs_bmap_search_extents(ip, del->br_startoff, XFS_COW_FORK, &eof,
-				&eidx, &got, &new);
-	ASSERT(ep);
-	if (isnullstartblock(got.br_startblock))
-		xfs_bmap_del_extent_delay(ip, XFS_COW_FORK, &eidx, &got, del);
-	else
-		xfs_bmap_del_extent_cow(ip, &eidx, &got, del);
-	return 0;
-}
-
 /*
  * Unmap (remove) blocks from a file.
  * If nexts is nonzero then the number of extents to remove is limited to
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 5f18248..7cae6ec 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -223,7 +223,6 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
 		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
 		struct xfs_defer_ops *dfops, int *done);
-int	xfs_bunmapi_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *del);
 int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
 		xfs_extnum_t *idx, struct xfs_bmbt_irec *got,
 		struct xfs_bmbt_irec *del);
-- 
2.1.4


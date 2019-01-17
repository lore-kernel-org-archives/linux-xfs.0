Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53128 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbfAQQgr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 11:36:47 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/11] xfs: remove the s_maxbytes checks in xfs_map_blocks
Date: Thu, 17 Jan 2019 17:36:28 +0100
Message-Id: <20190117163636.23171-4-hch@lst.de>
In-Reply-To: <20190117163636.23171-1-hch@lst.de>
References: <20190117163636.23171-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>

We already ensure all data fits into s_maxbytes in the write / fault
path.  The only reason we have them here is that they were copy and
pasted from xfs_bmapi_read when we stopped using that function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8fec6fd4c632..5b6fab283316 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -301,7 +301,8 @@ xfs_map_blocks(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			count = i_blocksize(inode);
-	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset), end_fsb;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
 	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
 	struct xfs_bmbt_irec	imap;
 	struct xfs_iext_cursor	icur;
@@ -356,11 +357,6 @@ xfs_map_blocks(
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
-	ASSERT(offset <= mp->m_super->s_maxbytes);
-
-	if (offset > mp->m_super->s_maxbytes - count)
-		count = mp->m_super->s_maxbytes - offset;
-	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
 
 	/*
 	 * Check if this is offset is covered by a COW extents, and if yes use
-- 
2.20.1

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40978 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbeLCQXq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 11:23:46 -0500
Received: from [8.46.75.6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gTr0S-0002G9-PC
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 16:23:37 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/11] xfs: remove the s_maxbytes checks in xfs_map_blocks
Date: Mon,  3 Dec 2018 11:21:23 -0500
Message-Id: <20181203162131.11652-4-hch@lst.de>
In-Reply-To: <20181203162131.11652-1-hch@lst.de>
References: <20181203162131.11652-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We already ensure all data fits into s_maxbytes in the write / fault
path.  The only reason we have them here is that they were copy and
pasted from xfs_bmapi_read when we stopped using that function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
2.19.1

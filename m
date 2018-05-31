Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51106 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932722AbeEaSI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 14:08:29 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/21] xfs: don't use XFS_BMAPI_IGSTATE in xfs_map_blocks
Date: Thu, 31 May 2018 20:07:46 +0200
Message-Id: <20180531180759.21631-9-hch@lst.de>
In-Reply-To: <20180531180759.21631-1-hch@lst.de>
References: <20180531180759.21631-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

We want to be able to use the extent state as a reliably indicator for
the type of I/O, and stop using the buffer head state.  For this we
need to stop using the XFS_BMAPI_IGSTATE so that we don't see merged
extents of different types.

Based on a patch from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 25d112a4bcf5..2966d62b0594 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -385,7 +385,6 @@ xfs_map_blocks(
 	ssize_t			count = i_blocksize(inode);
 	xfs_fileoff_t		offset_fsb, end_fsb;
 	int			error = 0;
-	int			bmapi_flags = XFS_BMAPI_ENTIRE;
 	int			nimaps = 1;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -405,8 +404,6 @@ xfs_map_blocks(
 		return 0;
 
 	ASSERT(type != XFS_IO_COW);
-	if (type == XFS_IO_UNWRITTEN)
-		bmapi_flags |= XFS_BMAPI_IGSTATE;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
@@ -418,7 +415,7 @@ xfs_map_blocks(
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				imap, &nimaps, bmapi_flags);
+				imap, &nimaps, XFS_BMAPI_ENTIRE);
 	/*
 	 * Truncate an overwrite extent if there's a pending CoW
 	 * reservation before the end of this extent.  This forces us
-- 
2.17.0


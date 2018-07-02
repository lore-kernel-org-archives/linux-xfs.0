Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32988 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbeGBO6T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:58:19 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/22] xfs: don't use XFS_BMAPI_IGSTATE in xfs_map_blocks
Date: Mon,  2 Jul 2018 08:57:57 -0600
Message-Id: <20180702145813.22496-7-hch@lst.de>
In-Reply-To: <20180702145813.22496-1-hch@lst.de>
References: <20180702145813.22496-1-hch@lst.de>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1d1cb917cc6e..6b6150683343 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -373,7 +373,6 @@ xfs_map_blocks(
 	ssize_t			count = i_blocksize(inode);
 	xfs_fileoff_t		offset_fsb, end_fsb;
 	int			error = 0;
-	int			bmapi_flags = XFS_BMAPI_ENTIRE;
 	int			nimaps = 1;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -393,8 +392,6 @@ xfs_map_blocks(
 		return 0;
 
 	ASSERT(type != XFS_IO_COW);
-	if (type == XFS_IO_UNWRITTEN)
-		bmapi_flags |= XFS_BMAPI_IGSTATE;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
@@ -406,7 +403,7 @@ xfs_map_blocks(
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				imap, &nimaps, bmapi_flags);
+				imap, &nimaps, XFS_BMAPI_ENTIRE);
 	/*
 	 * Truncate an overwrite extent if there's a pending CoW
 	 * reservation before the end of this extent.  This forces us
-- 
2.18.0


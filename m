Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55028 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756091AbdLVXUq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 18:20:46 -0500
Date: Fri, 22 Dec 2017 15:17:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix s_maxbytes overflow problems
Message-ID: <20171222231733.GD12613@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix some integer overflow problems if offset + count happen to be large
enough to cause an integer overflow.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c  |    4 ++--
 fs/xfs/xfs_iomap.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 21e2d70..4fc526a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -399,7 +399,7 @@ xfs_map_blocks(
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
 	ASSERT(offset <= mp->m_super->s_maxbytes);
 
-	if ((xfs_ufsize_t)offset + count > mp->m_super->s_maxbytes)
+	if (offset > mp->m_super->s_maxbytes - count)
 		count = mp->m_super->s_maxbytes - offset;
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
@@ -1312,7 +1312,7 @@ xfs_get_blocks(
 	lockmode = xfs_ilock_data_map_shared(ip);
 
 	ASSERT(offset <= mp->m_super->s_maxbytes);
-	if ((xfs_ufsize_t)offset + size > mp->m_super->s_maxbytes)
+	if (offset > mp->m_super->s_maxbytes - size)
 		size = mp->m_super->s_maxbytes - offset;
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7ab52a8..66e1edb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1006,7 +1006,7 @@ xfs_file_iomap_begin(
 	}
 
 	ASSERT(offset <= mp->m_super->s_maxbytes);
-	if ((xfs_fsize_t)offset + length > mp->m_super->s_maxbytes)
+	if (offset > mp->m_super->s_maxbytes - length)
 		length = mp->m_super->s_maxbytes - offset;
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19115 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdAUIAh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:00:37 -0500
Subject: [PATCH 03/55] xfs: filter out obviously bad btree pointers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:00:34 -0800
Message-ID: <148498563444.15323.4070127412874713378.stgit@birch.djwong.org>
In-Reply-To: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
References: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Don't let anybody load an obviously bad btree pointer.  Since the values
come from disk, we must return an error, not just ASSERT.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c  |    4 +---
 fs/xfs/libxfs/xfs_btree.c |    3 ++-
 fs/xfs/libxfs/xfs_btree.h |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 44773c9..3ac13be 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1291,9 +1291,7 @@ xfs_bmap_read_extents(
 	ASSERT(level > 0);
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
-	ASSERT(bno != NULLFSBLOCK);
-	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
-	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
+
 	/*
 	 * Go down the tree until leaf level is reached, following the first
 	 * pointer (leftmost) at each level.
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 21e6a6a..2849d3f 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -810,7 +810,8 @@ xfs_btree_read_bufl(
 	xfs_daddr_t		d;		/* real disk block address */
 	int			error;
 
-	ASSERT(fsbno != NULLFSBLOCK);
+	if (!XFS_FSB_SANITY_CHECK(mp, fsbno))
+		return -EFSCORRUPTED;
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
 				   mp->m_bsize, lock, &bp, ops);
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index b69b947..33a8f86 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -456,7 +456,7 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
 #define	XFS_FILBLKS_MAX(a,b)	max_t(xfs_filblks_t, (a), (b))
 
 #define	XFS_FSB_SANITY_CHECK(mp,fsb)	\
-	(XFS_FSB_TO_AGNO(mp, fsb) < mp->m_sb.sb_agcount && \
+	(fsb && XFS_FSB_TO_AGNO(mp, fsb) < mp->m_sb.sb_agcount && \
 		XFS_FSB_TO_AGBNO(mp, fsb) < mp->m_sb.sb_agblocks)
 
 /*


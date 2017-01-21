Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24733 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbdAUIAo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:00:44 -0500
Subject: [PATCH 04/55] xfs: check for obviously bad level values in the bmbt
 root
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:00:40 -0800
Message-ID: <148498564058.15323.13908390753786561753.stgit@birch.djwong.org>
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

We can't handle a bmbt that's taller than BTREE_MAXLEVELS, and there's
no such thing as a zero-level bmbt (for that we have extents format),
so if we see this, send back an error code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 222e103..84b3e51 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -26,6 +26,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
+#include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
@@ -429,11 +430,13 @@ xfs_iformat_btree(
 	/* REFERENCED */
 	int			nrecs;
 	int			size;
+	int			level;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	dfp = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 	size = XFS_BMAP_BROOT_SPACE(mp, dfp);
 	nrecs = be16_to_cpu(dfp->bb_numrecs);
+	level = be16_to_cpu(dfp->bb_level);
 
 	/*
 	 * blow out if -- fork has less extents than can fit in
@@ -446,7 +449,8 @@ xfs_iformat_btree(
 					XFS_IFORK_MAXEXT(ip, whichfork) ||
 		     XFS_BMDR_SPACE_CALC(nrecs) >
 					XFS_DFORK_SIZE(dip, mp, whichfork) ||
-		     XFS_IFORK_NEXTENTS(ip, whichfork) > ip->i_d.di_nblocks)) {
+		     XFS_IFORK_NEXTENTS(ip, whichfork) > ip->i_d.di_nblocks) ||
+		     level == 0 || level > XFS_BTREE_MAXLEVELS) {
 		xfs_warn(mp, "corrupt inode %Lu (btree).",
 					(unsigned long long) ip->i_ino);
 		XFS_CORRUPTION_ERROR("xfs_iformat_btree", XFS_ERRLEVEL_LOW,


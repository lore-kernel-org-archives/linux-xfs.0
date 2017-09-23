Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32806 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdIWHMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Sep 2017 03:12:01 -0400
Date: Sat, 23 Sep 2017 00:11:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: revert "xfs: factor rmap btree size into the indlen
 calculations"
Message-ID: <20170923071142.GM5728@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: eguan@redhat.com

In commit fd26a88093ba we added a worst case estimate for rmapbt blocks
needed to satisfy the block mapping request.  Since then, we added the
ability to reserve enough space in each AG such that we should never run
out of blocks to grow the rmapbt, which makes this calculation
unnecessary.  Revert the commit because it makes the extra delalloc
indlen accounting unnecessary and incorrect.

Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 459f4b4f0..044a363 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -49,7 +49,6 @@
 #include "xfs_rmap.h"
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
-#include "xfs_rmap_btree.h"
 #include "xfs_icache.h"
 
 
@@ -192,12 +191,8 @@ xfs_bmap_worst_indlen(
 	int		maxrecs;	/* maximum record count at this level */
 	xfs_mount_t	*mp;		/* mount structure */
 	xfs_filblks_t	rval;		/* return value */
-	xfs_filblks_t   orig_len;
 
 	mp = ip->i_mount;
-
-	/* Calculate the worst-case size of the bmbt. */
-	orig_len = len;
 	maxrecs = mp->m_bmap_dmxr[0];
 	for (level = 0, rval = 0;
 	     level < XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK);
@@ -205,20 +200,12 @@ xfs_bmap_worst_indlen(
 		len += maxrecs - 1;
 		do_div(len, maxrecs);
 		rval += len;
-		if (len == 1) {
-			rval += XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) -
+		if (len == 1)
+			return rval + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) -
 				level - 1;
-			break;
-		}
 		if (level == 0)
 			maxrecs = mp->m_bmap_dmxr[1];
 	}
-
-	/* Calculate the worst-case size of the rmapbt. */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		rval += 1 + xfs_rmapbt_calc_size(mp, orig_len) +
-				mp->m_rmap_maxlevels;
-
 	return rval;
 }
 

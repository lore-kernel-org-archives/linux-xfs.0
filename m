Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34021 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752747AbcKQX5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2016 18:57:05 -0500
Received: from disappointment.disaster.area ([192.168.1.110] helo=disappointment)
        by dastard with esmtp (Exim 4.80)
        (envelope-from <dave@fromorbit.com>)
        id 1c7WWq-0008NP-Od
        for linux-xfs@vger.kernel.org; Fri, 18 Nov 2016 10:55:40 +1100
Received: from dave by disappointment with local (Exim 4.87)
        (envelope-from <dave@disappointment.disaster>)
        id 1c7WWr-00020E-Lr
        for linux-xfs@vger.kernel.org; Fri, 18 Nov 2016 10:55:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: factor rmap btree size into the indlen calculations
Date: Fri, 18 Nov 2016 10:55:32 +1100
Message-Id: <1479426935-7112-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1479426935-7112-1-git-send-email-david@fromorbit.com>
References: <20161117213224.GD28177@dastard>
 <1479426935-7112-1-git-send-email-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

When we're estimating the amount of space it's going to take to satisfy
a delalloc reservation, we need to include the space that we might need
to grow the rmapbt.  This helps us to avoid running out of space later
when _iomap_write_allocate needs more space than we reserved.  Eryu Guan
observed this happening on generic/224 when sunit/swidth were set.

Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5c3c4dd14735..00188f559c8d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -49,6 +49,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
+#include "xfs_rmap_btree.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -190,8 +191,12 @@ xfs_bmap_worst_indlen(
 	int		maxrecs;	/* maximum record count at this level */
 	xfs_mount_t	*mp;		/* mount structure */
 	xfs_filblks_t	rval;		/* return value */
+	xfs_filblks_t   orig_len;
 
 	mp = ip->i_mount;
+
+	/* Calculate the worst-case size of the bmbt. */
+	orig_len = len;
 	maxrecs = mp->m_bmap_dmxr[0];
 	for (level = 0, rval = 0;
 	     level < XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK);
@@ -199,12 +204,20 @@ xfs_bmap_worst_indlen(
 		len += maxrecs - 1;
 		do_div(len, maxrecs);
 		rval += len;
-		if (len == 1)
-			return rval + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) -
+		if (len == 1) {
+			rval += XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) -
 				level - 1;
+			break;
+		}
 		if (level == 0)
 			maxrecs = mp->m_bmap_dmxr[1];
 	}
+
+	/* Calculate the worst-case size of the rmapbt. */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		rval += 1 + xfs_rmapbt_calc_size(mp, orig_len) +
+				mp->m_rmap_maxlevels;
+
 	return rval;
 }
 
-- 
2.8.0.rc3


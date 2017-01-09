Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57108 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934298AbdAIPjc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:39:32 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/32] xfs: factor rmap btree size into the indlen calculations
Date: Mon,  9 Jan 2017 16:38:40 +0100
Message-Id: <1483976343-661-10-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit fd26a88093bab6529ea2de819114ca92dbd1d71d upstream.

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
index 5c3c4dd..00188f5 100644
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
2.1.4


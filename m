Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20109 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932509AbcLCBjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:39:45 -0500
Subject: [PATCH 40/55] xfs: cross-reference the block mappings when possible
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:39:41 -0800
Message-ID: <148072918174.12995.14311468769477304731.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Check inode field contents against the block mappings when possible.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/repair/inode.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)


diff --git a/fs/xfs/repair/inode.c b/fs/xfs/repair/inode.c
index 9eb3e35..8b50736 100644
--- a/fs/xfs/repair/inode.c
+++ b/fs/xfs/repair/inode.c
@@ -37,6 +37,8 @@
 #include "xfs_inode_fork.h"
 #include "xfs_ialloc.h"
 #include "xfs_rmap.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "repair/common.h"
 
 /* Inode core */
@@ -63,6 +65,7 @@ xfs_scrub_inode(
 	struct xfs_dinode		*dip;
 	xfs_ino_t			ino;
 	unsigned long long		isize;
+	unsigned long long		count;
 	uint64_t			flags2;
 	uint32_t			nextents;
 	uint32_t			extsize;
@@ -278,6 +281,40 @@ xfs_scrub_inode(
 		xfs_scrub_ag_free(&sa);
 	}
 
+	/* Walk all the extents to check nextents/naextents/nblocks. */
+	count = 0;
+	err2 = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
+			&nextents, &count);
+	if (!xfs_scrub_should_xref(sc, err2, NULL))
+		goto skip_block_check;
+	XFS_SCRUB_INODE_CHECK(nextents == be32_to_cpu(dip->di_nextents));
+
+	err2 = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+			&nextents, &count);
+	if (!xfs_scrub_should_xref(sc, err2, NULL))
+		goto skip_block_check;
+	XFS_SCRUB_INODE_CHECK(nextents == be16_to_cpu(dip->di_anextents));
+	XFS_SCRUB_INODE_CHECK(count == be64_to_cpu(dip->di_nblocks));
+
+skip_block_check:
+	/* Make sure we don't have any written extents after EOF. */
+	if (S_ISREG(mode) && !(flags & XFS_DIFLAG_PREALLOC) &&
+	    (dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+	     dip->di_format == XFS_DINODE_FMT_BTREE)) {
+		struct xfs_bmbt_irec		got;
+		struct xfs_ifork		*ifp;
+		xfs_fileoff_t			lblk;
+		xfs_extnum_t			lastx;
+
+		ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+		lblk = XFS_B_TO_FSB(mp, i_size_read(VFS_I(sc->ip)));
+		while (xfs_iext_lookup_extent(sc->ip, ifp, lblk, &lastx,
+				&got)) {
+			XFS_SCRUB_INODE_PREEN(got.br_startoff < lblk ||
+					got.br_state != XFS_EXT_NORM);
+			lblk = got.br_startoff + got.br_blockcount;
+		}
+	}
 out:
 	if (bp)
 		xfs_trans_brelse(sc->tp, bp);


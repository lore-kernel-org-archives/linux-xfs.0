Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19912 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751212AbdAUIEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:04:44 -0500
Subject: [PATCH 40/55] xfs: cross-reference the block mappings when possible
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:04:41 -0800
Message-ID: <148498588148.15323.1003787360040383897.stgit@birch.djwong.org>
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

Check inode field contents against the block mappings when possible.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/inode.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 8b625b5..e79fe5b 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -39,6 +39,8 @@
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
 #include "xfs_rmap.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "scrub/common.h"
 
 /*
@@ -181,6 +183,7 @@ xfs_scrub_inode(
 	struct xfs_dinode		*dip;
 	xfs_ino_t			ino;
 	unsigned long long		isize;
+	unsigned long long		count;
 	uint64_t			flags2;
 	uint32_t			nextents;
 	uint32_t			extsize;
@@ -396,6 +399,46 @@ xfs_scrub_inode(
 		xfs_scrub_ag_free(&sa);
 	}
 
+	/* Walk all the extents to check nextents/naextents/nblocks. */
+	count = 0;
+	err2 = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
+			&nextents, &count);
+	if (!xfs_scrub_should_xref(sc, err2, NULL))
+		goto skip_block_check;
+	XFS_SCRUB_INODE_XCHECK(nextents >= be32_to_cpu(dip->di_nextents));
+
+	err2 = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+			&nextents, &count);
+	if (!xfs_scrub_should_xref(sc, err2, NULL))
+		goto skip_block_check;
+	XFS_SCRUB_INODE_XCHECK(nextents == be16_to_cpu(dip->di_anextents));
+
+	/* Check nblocks, taking any delalloc extents into account. */
+	if (sc->ip)
+		count -= sc->ip->i_delayed_blks;
+	XFS_SCRUB_INODE_XCHECK(count == be64_to_cpu(dip->di_nblocks));
+
+skip_block_check:
+	/* Make sure we don't have any written extents after EOF. */
+	if (S_ISREG(mode) && !(flags & XFS_DIFLAG_PREALLOC) &&
+	    (dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+	     dip->di_format == XFS_DINODE_FMT_BTREE)) {
+		struct xfs_bmbt_irec		got;
+		struct xfs_ifork		*ifp;
+		xfs_fileoff_t			lblk;
+		xfs_extnum_t			idx;
+		bool				found;
+
+		lblk = XFS_B_TO_FSB(mp, i_size_read(VFS_I(sc->ip)));
+		ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+		found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
+		while (found) {
+			XFS_SCRUB_INODE_PREEN(got.br_startoff < lblk ||
+					got.br_state != XFS_EXT_NORM);
+			lblk = got.br_startoff + got.br_blockcount;
+			found = xfs_iext_get_extent(ifp, ++idx, &got);
+		}
+	}
 out:
 	if (bp)
 		xfs_trans_brelse(sc->tp, bp);


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41066 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161539AbdAGAjR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 19:39:17 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v070dGpB025188
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:39:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v070dGKV027117
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:39:16 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v070dFvU004514
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:39:16 GMT
Subject: [PATCH 32/47] xfs: cross-reference the block mappings when possible
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 06 Jan 2017 16:39:14 -0800
Message-ID: <148374955484.30431.7066197703632274610.stgit@birch.djwong.org>
In-Reply-To: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Check inode field contents against the block mappings when possible.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/repair/inode.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


diff --git a/fs/xfs/repair/inode.c b/fs/xfs/repair/inode.c
index 14d9e19..51f0e78 100644
--- a/fs/xfs/repair/inode.c
+++ b/fs/xfs/repair/inode.c
@@ -39,6 +39,8 @@
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
 #include "xfs_rmap.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "repair/common.h"
 
 /*
@@ -176,6 +178,7 @@ xfs_scrub_inode(
 	struct xfs_dinode		*dip;
 	xfs_ino_t			ino;
 	unsigned long long		isize;
+	unsigned long long		count;
 	uint64_t			flags2;
 	uint32_t			nextents;
 	uint32_t			extsize;
@@ -391,6 +394,46 @@ xfs_scrub_inode(
 		xfs_scrub_ag_free(&sa);
 	}
 
+	/* Walk all the extents to check nextents/naextents/nblocks. */
+	count = 0;
+	err2 = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
+			&nextents, &count);
+	if (!xfs_scrub_should_xref(sc, err2, NULL))
+		goto skip_block_check;
+	XFS_SCRUB_INODE_CHECK(nextents >= be32_to_cpu(dip->di_nextents));
+
+	err2 = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+			&nextents, &count);
+	if (!xfs_scrub_should_xref(sc, err2, NULL))
+		goto skip_block_check;
+	XFS_SCRUB_INODE_CHECK(nextents == be16_to_cpu(dip->di_anextents));
+
+	/* Check nblocks, taking any delalloc extents into account. */
+	if (sc->ip)
+		count -= sc->ip->i_delayed_blks;
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


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18717 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754903AbcLCBfb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:35:31 -0500
Subject: [PATCH 02/55] xfs: check for bogus values in btree block headers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:35:27 -0800
Message-ID: <148072892722.12995.6297042295929105024.stgit@birch.djwong.org>
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

When we're reading a btree block, make sure that what we retrieved
matches the owner and level; and has a plausible number of records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 0e80993..21e6a6a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1769,8 +1769,28 @@ xfs_btree_lookup_get_block(
 	if (error)
 		return error;
 
+	/* Check the inode owner since the verifiers don't. */
+	if (xfs_sb_version_hascrc(&cur->bc_mp->m_sb) &&
+	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
+	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
+			cur->bc_private.b.ip->i_ino)
+		goto out_bad;
+
+	/* Did we get the level we were looking for? */
+	if (be16_to_cpu((*blkp)->bb_level) != level)
+		goto out_bad;
+
+	/* Check that internal nodes have at least one record. */
+	if (level != 0 && be16_to_cpu((*blkp)->bb_numrecs) == 0)
+		goto out_bad;
+
 	xfs_btree_setbuf(cur, level, bp);
 	return 0;
+
+out_bad:
+	*blkp = NULL;
+	xfs_trans_brelse(cur->bc_tp, bp);
+	return -EFSCORRUPTED;
 }
 
 /*


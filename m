Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41915 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754937AbdJSOXX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:23:23 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/16] xfs: always swap the cow forks when swapping extents
Date: Thu, 19 Oct 2017 16:22:51 +0200
Message-Id: <20171019142259.20082-9-hch@lst.de>
In-Reply-To: <20171019142259.20082-1-hch@lst.de>
References: <20171019142259.20082-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 52bfcdd7adbc26639bc7b2356ab9a3f5dad68ad6 upstream.

Since the CoW fork exists as a secondary data structure to the data
fork, we must always swap cow forks during swapext.  We also need to
swap the extent counts and reset the cowblocks tags.

Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5fccf9811e66..bbc389e353e8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -2106,11 +2106,31 @@ xfs_swap_extents(
 		ip->i_d.di_flags2 |= tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
 		tip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
 		tip->i_d.di_flags2 |= f & XFS_DIFLAG2_REFLINK;
+	}
+
+	/* Swap the cow forks. */
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		xfs_extnum_t	extnum;
+
+		ASSERT(ip->i_cformat == XFS_DINODE_FMT_EXTENTS);
+		ASSERT(tip->i_cformat == XFS_DINODE_FMT_EXTENTS);
+
+		extnum = ip->i_cnextents;
+		ip->i_cnextents = tip->i_cnextents;
+		tip->i_cnextents = extnum;
+
 		cowfp = ip->i_cowfp;
 		ip->i_cowfp = tip->i_cowfp;
 		tip->i_cowfp = cowfp;
-		xfs_inode_set_cowblocks_tag(ip);
-		xfs_inode_set_cowblocks_tag(tip);
+
+		if (ip->i_cowfp && ip->i_cnextents)
+			xfs_inode_set_cowblocks_tag(ip);
+		else
+			xfs_inode_clear_cowblocks_tag(ip);
+		if (tip->i_cowfp && tip->i_cnextents)
+			xfs_inode_set_cowblocks_tag(tip);
+		else
+			xfs_inode_clear_cowblocks_tag(tip);
 	}
 
 	xfs_trans_log_inode(tp, ip,  src_log_flags);
-- 
2.14.2


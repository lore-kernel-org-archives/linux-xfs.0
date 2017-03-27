Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52010 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752169AbdC0Ik3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:40:29 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/26] xfs: Use xfs_icluster_size_fsb() to calculate inode alignment mask
Date: Mon, 27 Mar 2017 10:38:35 +0200
Message-Id: <20170327083837.11027-25-hch@lst.de>
In-Reply-To: <20170327083837.11027-1-hch@lst.de>
References: <20170327083837.11027-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, Chandan Rajendra <chandan@linux.vnet.ibm.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Chandan Rajendra <chandan@linux.vnet.ibm.com>

commit d5825712ee98d68a2c17bc89dad2c30276894cba upstream.

When block size is larger than inode cluster size, the call to
XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size) returns 0. Also, mkfs.xfs
would have set xfs_sb->sb_inoalignmt to 0. Hence in
xfs_set_inoalignment(), xfs_mount->m_inoalign_mask gets initialized to
-1 instead of 0. However, xfs_mount->m_sinoalign would get correctly
intialized to 0 because for every positive value of xfs_mount->m_dalign,
the condition "!(mp->m_dalign & mp->m_inoalign_mask)" would evaluate to
false.

Also, xfs_imap() worked fine even with xfs_mount->m_inoalign_mask having
-1 as the value because blks_per_cluster variable would have the value 1
and hence we would never have a need to use xfs_mount->m_inoalign_mask
to compute the inode chunk's agbno and offset within the chunk.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1f1e4ae44150..52d27cc4370a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -511,8 +511,7 @@ STATIC void
 xfs_set_inoalignment(xfs_mount_t *mp)
 {
 	if (xfs_sb_version_hasalign(&mp->m_sb) &&
-	    mp->m_sb.sb_inoalignmt >=
-	    XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size))
+		mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
 		mp->m_inoalign_mask = mp->m_sb.sb_inoalignmt - 1;
 	else
 		mp->m_inoalign_mask = 0;
-- 
2.11.0


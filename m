Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74812C433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 11:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BD5A613BD
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 11:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343629AbhDFL7j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:59:39 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59515 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343630AbhDFL7i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 07:59:38 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BE7A81041F58
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 21:59:27 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lTkMg-00CnsA-Ur
        for linux-xfs@vger.kernel.org; Tue, 06 Apr 2021 21:59:26 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lTkMg-007IOa-NA
        for linux-xfs@vger.kernel.org; Tue, 06 Apr 2021 21:59:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: precalculate default inode attribute offset
Date:   Tue,  6 Apr 2021 21:59:23 +1000
Message-Id: <20210406115923.1738753-5-david@fromorbit.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210406115923.1738753-1-david@fromorbit.com>
References: <20210406115923.1738753-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=3YhXtTcJ-WEA:10 a=20KFwNOVAAAA:8 a=Brqe-ThOQP42QkIYx_0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Default attr fork offset is based on inode size, so is a fixed
geometry parameter of the inode. Move it to the xfs_ino_geometry
structure and stop calculating it on every call to
xfs_default_attroffset().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c   | 21 ++++++++++-----------
 fs/xfs/libxfs/xfs_bmap.h   |  1 +
 fs/xfs/libxfs/xfs_shared.h |  4 ++++
 fs/xfs/xfs_mount.c         | 14 +++++++++++++-
 4 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 414882ebcc8e..f937d3f05bc7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -94,6 +94,15 @@ xfs_bmap_compute_maxlevels(
 	mp->m_bm_maxlevels[whichfork] = level;
 }
 
+unsigned int
+xfs_bmap_compute_attr_offset(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_sb.sb_inodesize == 256)
+		return XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	return XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
+}
+
 STATIC int				/* error */
 xfs_bmbt_lookup_eq(
 	struct xfs_btree_cur	*cur,
@@ -192,19 +201,9 @@ uint
 xfs_default_attroffset(
 	struct xfs_inode	*ip)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	uint			offset;
-
 	if (ip->i_df.if_format == XFS_DINODE_FMT_DEV)
 		return roundup(sizeof(xfs_dev_t), 8);
-
-	if (mp->m_sb.sb_inodesize == 256)
-		offset = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	else
-		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
-
-	ASSERT(offset < XFS_LITINO(mp));
-	return offset;
+	return M_IGEO(ip->i_mount)->attr_fork_offset;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 6747e97a7949..a49df4092c30 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -185,6 +185,7 @@ static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
 
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
+unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 8c61a461bf7b..782fdd08f759 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -176,8 +176,12 @@ struct xfs_ino_geometry {
 
 	unsigned int	agino_log;	/* #bits for agino in inum */
 
+	/* precomputed default inode attribute fork offset */
+	unsigned int	attr_fork_offset;
+
 	/* precomputed value for di_flags2 */
 	uint64_t	new_diflags2;
+
 };
 
 #endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1c97b155a8ee..cb1e2c4702c3 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -675,6 +675,18 @@ xfs_unmount_flush_inodes(
 	xfs_health_unmount(mp);
 }
 
+static void
+xfs_mount_setup_inode_geom(
+	struct xfs_mount	*mp)
+{
+	struct xfs_ino_geometry *igeo = M_IGEO(mp);
+
+	igeo->attr_fork_offset = xfs_bmap_compute_attr_offset(mp);
+	ASSERT(igeo->attr_fork_offset < XFS_LITINO(mp));
+
+	xfs_ialloc_setup_geometry(mp);
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -758,7 +770,7 @@ xfs_mountfs(
 	xfs_alloc_compute_maxlevels(mp);
 	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
-	xfs_ialloc_setup_geometry(mp);
+	xfs_mount_setup_inode_geom(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
-- 
2.31.0


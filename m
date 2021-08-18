Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E06BC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 23:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3690C60FE8
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 23:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhHSAAQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 20:00:16 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59729 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235325AbhHSAAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 20:00:15 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 413921049A8C
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 09:59:39 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGVT8-002JPq-LB
        for linux-xfs@vger.kernel.org; Thu, 19 Aug 2021 09:59:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mGVT8-000cwT-DK
        for linux-xfs@vger.kernel.org; Thu, 19 Aug 2021 09:59:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/16] xfs: convert xfs_fs_geometry to use mount feature checks
Date:   Thu, 19 Aug 2021 09:59:29 +1000
Message-Id: <20210818235935.149431-11-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818235935.149431-1-david@fromorbit.com>
References: <20210818235935.149431-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=QzJ7RRMRbXgQee3RgIYA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Reporting filesystem features to userspace is currently superblock
based. Now we have a general mount-based feature infrastructure,
switch to using the xfs_mount rather than the superblock directly.

This reduces the size of the function by over 300 bytes.

$ size -t fs/xfs/built-in.a
	text    data     bss     dec     hex filename
before	1127855  311352     484 1439691  15f7cb (TOTALS)
after	1127535  311352     484 1439371  15f68b (TOTALS)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_sb.c | 46 ++++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_sb.h |  2 +-
 fs/xfs/xfs_ioctl.c     |  2 +-
 fs/xfs/xfs_ioctl32.c   |  2 +-
 4 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index baaec7e6a975..5eaf14b6fe3c 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1016,10 +1016,12 @@ xfs_sync_sb_buf(
 
 void
 xfs_fs_geometry(
-	struct xfs_sb		*sbp,
+	struct xfs_mount	*mp,
 	struct xfs_fsop_geom	*geo,
 	int			struct_version)
 {
+	struct xfs_sb		*sbp = &mp->m_sb;
+
 	memset(geo, 0, sizeof(struct xfs_fsop_geom));
 
 	geo->blocksize = sbp->sb_blocksize;
@@ -1050,51 +1052,51 @@ xfs_fs_geometry(
 	geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
 		     XFS_FSOP_GEOM_FLAGS_DIRV2 |
 		     XFS_FSOP_GEOM_FLAGS_EXTFLG;
-	if (xfs_sb_version_hasattr(sbp))
+	if (xfs_has_attr(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR;
-	if (xfs_sb_version_hasquota(sbp))
+	if (xfs_has_quota(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_QUOTA;
-	if (xfs_sb_version_hasalign(sbp))
+	if (xfs_has_align(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_IALIGN;
-	if (xfs_sb_version_hasdalign(sbp))
+	if (xfs_has_dalign(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_DALIGN;
-	if (xfs_sb_version_hassector(sbp))
-		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
-	if (xfs_sb_version_hasasciici(sbp))
+	if (xfs_has_asciici(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_DIRV2CI;
-	if (xfs_sb_version_haslazysbcount(sbp))
+	if (xfs_has_lazysbcount(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LAZYSB;
-	if (xfs_sb_version_hasattr2(sbp))
+	if (xfs_has_attr2(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR2;
-	if (xfs_sb_version_hasprojid32(sbp))
+	if (xfs_has_projid32(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_PROJID32;
-	if (xfs_sb_version_hascrc(sbp))
+	if (xfs_has_crc(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_V5SB;
-	if (xfs_sb_version_hasftype(sbp))
+	if (xfs_has_ftype(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_FTYPE;
-	if (xfs_sb_version_hasfinobt(sbp))
+	if (xfs_has_finobt(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_FINOBT;
-	if (xfs_sb_version_hassparseinodes(sbp))
+	if (xfs_has_sparseinodes(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SPINODES;
-	if (xfs_sb_version_hasrmapbt(sbp))
+	if (xfs_has_rmapbt(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_RMAPBT;
-	if (xfs_sb_version_hasreflink(sbp))
+	if (xfs_has_reflink(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
-	if (xfs_sb_version_hasbigtime(sbp))
+	if (xfs_has_bigtime(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
-	if (xfs_sb_version_hasinobtcounts(sbp))
+	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
-	if (xfs_sb_version_hassector(sbp))
+	if (xfs_has_sector(mp)) {
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
-	else
+	} else {
 		geo->logsectsize = BBSIZE;
+	}
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
 	if (struct_version < 4)
 		return;
 
-	if (xfs_sb_version_haslogv2(sbp))
+	if (xfs_has_logv2(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LOGV2;
 
 	geo->logsunit = sbp->sb_logsunit;
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index d2dd99cb6921..8902f4bfa5df 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -25,7 +25,7 @@ extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
 #define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
-extern void	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
+extern void	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2f526e3319a4..0c795dc093ef 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1010,7 +1010,7 @@ xfs_ioc_fsgeometry(
 	struct xfs_fsop_geom	fsgeo;
 	size_t			len;
 
-	xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
+	xfs_fs_geometry(mp, &fsgeo, struct_version);
 
 	if (struct_version <= 3)
 		len = sizeof(struct xfs_fsop_geom_v1);
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 20adf35aa37b..8783af203cfc 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -50,7 +50,7 @@ xfs_compat_ioc_fsgeometry_v1(
 {
 	struct xfs_fsop_geom	  fsgeo;
 
-	xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
+	xfs_fs_geometry(mp, &fsgeo, 3);
 	/* The 32-bit variant simply has some padding at the end */
 	if (copy_to_user(arg32, &fsgeo, sizeof(struct compat_xfs_fsop_geom_v1)))
 		return -EFAULT;
-- 
2.31.1


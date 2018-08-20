Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:38458 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbeHTIDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Aug 2018 04:03:10 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0006SF-9p
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0000QV-8l
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/10] xfs: convert scrub to use mount-based feature checks
Date: Mon, 20 Aug 2018 14:48:50 +1000
Message-Id: <20180820044851.414-10-david@fromorbit.com>
In-Reply-To: <20180820044851.414-1-david@fromorbit.com>
References: <20180820044851.414-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

THe scrub feature checks are the last place that the superblock
feature checks are used. Convert them to mount based feature checks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/scrub.c | 12 ++++++------
 fs/xfs/scrub/scrub.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8c1edb39fb8c..4e3323777a2f 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -250,21 +250,21 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_iallocbt,
 		.scrub	= xchk_finobt,
-		.has	= xfs_sb_version_hasfinobt,
+		.has	= xfs_has_finobt,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_rmapbt,
 		.scrub	= xchk_rmapbt,
-		.has	= xfs_sb_version_hasrmapbt,
+		.has	= xfs_has_rmapbt,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_REFCNTBT] = {	/* refcountbt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_refcountbt,
 		.scrub	= xchk_refcountbt,
-		.has	= xfs_sb_version_hasreflink,
+		.has	= xfs_has_reflink,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_INODE] = {	/* inode record */
@@ -319,14 +319,14 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_rt,
 		.scrub	= xchk_rtbitmap,
-		.has	= xfs_sb_version_hasrealtime,
+		.has	= xfs_has_realtime,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
 		.type	= ST_FS,
 		.setup	= xchk_setup_rt,
 		.scrub	= xchk_rtsummary,
-		.has	= xfs_sb_version_hasrealtime,
+		.has	= xfs_has_realtime,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */
@@ -388,7 +388,7 @@ xchk_validate_inputs(
 	if (ops->setup == NULL || ops->scrub == NULL)
 		goto out;
 	/* Does this fs even support this type of metadata? */
-	if (ops->has && !ops->has(&mp->m_sb))
+	if (ops->has && !ops->has(mp))
 		goto out;
 
 	error = -EINVAL;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index af323b229c4b..1453766a6920 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -28,7 +28,7 @@ struct xchk_meta_ops {
 	int		(*repair)(struct xfs_scrub *);
 
 	/* Decide if we even have this piece of metadata. */
-	bool		(*has)(struct xfs_sb *);
+	bool		(*has)(struct xfs_mount *);
 
 	/* type describing required/allowed inputs */
 	enum xchk_type	type;
-- 
2.17.0

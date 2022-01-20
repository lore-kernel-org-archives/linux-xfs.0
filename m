Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E26C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345317AbiATAZE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:25:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:32768 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345290AbiATAZD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:25:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D57E61516
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D13C004E1;
        Thu, 20 Jan 2022 00:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638302;
        bh=vJGr3/GisQboDQeGQddY5RpA1C+s8yruNRf1kbhzx44=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QA8qHBIfE7D0NcNde6ccErDxj+5xQiNV8RWXTj7c9/LIW88FGZiD/gZod3+G4+PZ6
         1pr3+iTfMm/uTbU6s7ZfL3zyOa4HBjsxsQhOggRG6Bu/A1rFFPnl/Qk4ymXbcBZf8X
         VXp3ebl14IY7xWd+8Y76cIyH6pSVDvBbTHO5Gee7zz5Y61yD9r1H12X/vjRemBW8j5
         xknfVeo5PGrIDK7bdmf+ivLW6iVDakboVWvAgT2KTFvmjs/m/nHJdhF7rgyT4MsChV
         YJV+i06yuPBbVgFKg9C9liC2Z6iyPNlKgSEIX7387A4yEbguqgV8SXz1GQ8b2VOUfG
         R3CIL3R4TS2HA==
Subject: [PATCH 20/48] xfs: rename m_ag_maxlevels to m_allocbt_maxlevels
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:25:02 -0800
Message-ID: <164263830239.865554.3465546750462142656.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 7cb3efb4cfdd4f3eb1f36b0ce39254b848ff2371

Years ago when XFS was thought to be much more simple, we introduced
m_ag_maxlevels to specify the maximum btree height of per-AG btrees for
a given filesystem mount.  Then we observed that inode btrees don't
actually have the same height and split that off; and now we have rmap
and refcount btrees with much different geometries and separate
maxlevels variables.

The 'ag' part of the name doesn't make much sense anymore, so rename
this to m_alloc_maxlevels to reinforce that this is the maximum height
of the *free space* btrees.  This sets us up for the next patch, which
will add a variable to track the maximum height of all AG btrees.

(Also take the opportunity to improve adjacent comments and fix minor
style problems.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h      |    2 +-
 libxfs/xfs_alloc.c       |   19 +++++++++++--------
 libxfs/xfs_alloc.h       |    2 +-
 libxfs/xfs_alloc_btree.c |    4 ++--
 libxfs/xfs_trans_resv.c  |    2 +-
 libxfs/xfs_trans_space.h |    2 +-
 6 files changed, 17 insertions(+), 14 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index dc2206de..308ceff0 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -71,7 +71,7 @@ typedef struct xfs_mount {
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
 	uint			m_refc_mxr[2];	/* max refc btree records */
 	uint			m_refc_mnr[2];	/* min refc btree records */
-	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
+	uint			m_alloc_maxlevels; /* max alloc btree levels */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_refc_maxlevels; /* max refc btree levels */
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index b8857204..e20d8fb7 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2186,13 +2186,13 @@ xfs_free_ag_extent(
  */
 
 /*
- * Compute and fill in value of m_ag_maxlevels.
+ * Compute and fill in value of m_alloc_maxlevels.
  */
 void
 xfs_alloc_compute_maxlevels(
 	xfs_mount_t	*mp)	/* file system mount structure */
 {
-	mp->m_ag_maxlevels = xfs_btree_compute_maxlevels(mp->m_alloc_mnr,
+	mp->m_alloc_maxlevels = xfs_btree_compute_maxlevels(mp->m_alloc_mnr,
 			(mp->m_sb.sb_agblocks + 1) / 2);
 }
 
@@ -2251,14 +2251,14 @@ xfs_alloc_min_freelist(
 	const uint8_t		*levels = pag ? pag->pagf_levels : fake_levels;
 	unsigned int		min_free;
 
-	ASSERT(mp->m_ag_maxlevels > 0);
+	ASSERT(mp->m_alloc_maxlevels > 0);
 
 	/* space needed by-bno freespace btree */
 	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
-				       mp->m_ag_maxlevels);
+				       mp->m_alloc_maxlevels);
 	/* space needed by-size freespace btree */
 	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
-				       mp->m_ag_maxlevels);
+				       mp->m_alloc_maxlevels);
 	/* space needed reverse mapping used space btree */
 	if (xfs_has_rmapbt(mp))
 		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
@@ -2899,13 +2899,16 @@ xfs_agf_verify(
 
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
-	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > mp->m_ag_maxlevels ||
-	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > mp->m_ag_maxlevels)
+	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) >
+						mp->m_alloc_maxlevels ||
+	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) >
+						mp->m_alloc_maxlevels)
 		return __this_address;
 
 	if (xfs_has_rmapbt(mp) &&
 	    (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
-	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > mp->m_rmap_maxlevels))
+	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) >
+						mp->m_rmap_maxlevels))
 		return __this_address;
 
 	if (xfs_has_rmapbt(mp) &&
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index df4aefaf..2f3f8c2e 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -98,7 +98,7 @@ unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
 		struct xfs_perag *pag);
 
 /*
- * Compute and fill in value of m_ag_maxlevels.
+ * Compute and fill in value of m_alloc_maxlevels.
  */
 void
 xfs_alloc_compute_maxlevels(
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index c1030ad1..d752500b 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -314,7 +314,7 @@ xfs_allocbt_verify(
 	if (pag && pag->pagf_init) {
 		if (level >= pag->pagf_levels[btnum])
 			return __this_address;
-	} else if (level >= mp->m_ag_maxlevels)
+	} else if (level >= mp->m_alloc_maxlevels)
 		return __this_address;
 
 	return xfs_btree_sblock_verify(bp, mp->m_alloc_mxr[level != 0]);
@@ -475,7 +475,7 @@ xfs_allocbt_init_common(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_ag_maxlevels);
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_alloc_maxlevels);
 	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index d383528d..68daefd4 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -69,7 +69,7 @@ xfs_allocfree_log_count(
 {
 	uint		blocks;
 
-	blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
+	blocks = num_ops * 2 * (2 * mp->m_alloc_maxlevels - 1);
 	if (xfs_has_rmapbt(mp))
 		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
 	if (xfs_has_reflink(mp))
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 50332be3..bd04cb83 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -74,7 +74,7 @@
 #define	XFS_DIOSTRAT_SPACE_RES(mp, v)	\
 	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + (v))
 #define	XFS_GROWFS_SPACE_RES(mp)	\
-	(2 * (mp)->m_ag_maxlevels)
+	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
 #define	XFS_LINK_SPACE_RES(mp,nl)	\


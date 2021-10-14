Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12251C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE30461166
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhJNUUB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhJNUUB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:20:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B83AC6105A;
        Thu, 14 Oct 2021 20:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242675;
        bh=1gxkjtg/jvciOQjtUyBAdVauqtzXEMgYSSP+4MTnqOs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Z5hoaeuiWhVNwJrQkQrYzO+uMfsytpwTEpwSZvccGqweC9Y07xoXNhJ5+bUNu6DkN
         MdHHpSgEIwqZsBDp9i3GTmT06MjD/SJbtmGl+ExGwM/krVu1ZkBwo3LvMJwQXuOV6l
         mtCcDIPYIaq0I2N7Ysk6NqOBh1x0jr1gSgPfnplNoSqFc3dgBec/bpiF0Kp8U2mI1R
         zCvddanlf40SI+U2IVJocbcpvnErwnzx+IwUg8PLegCV+JxIdCs1tRAO5VvR6KOc6P
         pKjcM+e1sp2ZcaIP4o8ADBPiV5SkTsIxOITKLKjorOA3zXLZY+X3Y/6S/e5RTjzZpV
         7c7jNDrTBvvkA==
Subject: [PATCH 11/17] xfs: rename m_ag_maxlevels to m_allocbt_maxlevels
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:17:55 -0700
Message-ID: <163424267542.756780.9763514054029645043.stgit@magnolia>
In-Reply-To: <163424261462.756780.16294781570977242370.stgit@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Years ago when XFS was thought to be much more simple, we introduced
m_ag_maxlevels to specify the maximum btree height of per-AG btrees for
a given filesystem mount.  Then we observed that inode btrees don't
actually have the same height and split that off; and now we have rmap
and refcount btrees with much different geometries and separate
maxlevels variables.

The 'ag' part of the name doesn't make much sense anymore, so rename
this to m_allocbt_maxlevels to reinforce that this is the maximum height
of the *free space* btrees.  This sets us up for the next patch, which
will add a variable to track the maximum height of all AG btrees.

(Also take the opportunity to improve adjacent comments and fix minor
style problems.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c       |   19 +++++++++++--------
 fs/xfs/libxfs/xfs_alloc.h       |    2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c |    4 ++--
 fs/xfs/libxfs/xfs_trans_resv.c  |    2 +-
 fs/xfs/libxfs/xfs_trans_space.h |    2 +-
 fs/xfs/scrub/agheader.c         |    4 ++--
 fs/xfs/scrub/agheader_repair.c  |    4 ++--
 fs/xfs/xfs_mount.h              |    4 ++--
 8 files changed, 22 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 55c5adc9b54e..2efb4f4539f1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2190,13 +2190,13 @@ xfs_free_ag_extent(
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
 
@@ -2255,14 +2255,14 @@ xfs_alloc_min_freelist(
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
@@ -2903,13 +2903,16 @@ xfs_agf_verify(
 
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
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index df4aefaf0046..2f3f8c2e0860 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -98,7 +98,7 @@ unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
 		struct xfs_perag *pag);
 
 /*
- * Compute and fill in value of m_ag_maxlevels.
+ * Compute and fill in value of m_alloc_maxlevels.
  */
 void
 xfs_alloc_compute_maxlevels(
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index f14bad21503f..c3e262290f6f 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -316,7 +316,7 @@ xfs_allocbt_verify(
 	if (pag && pag->pagf_init) {
 		if (level >= pag->pagf_levels[btnum])
 			return __this_address;
-	} else if (level >= mp->m_ag_maxlevels)
+	} else if (level >= mp->m_alloc_maxlevels)
 		return __this_address;
 
 	return xfs_btree_sblock_verify(bp, mp->m_alloc_mxr[level != 0]);
@@ -477,7 +477,7 @@ xfs_allocbt_init_common(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_ag_maxlevels);
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_alloc_maxlevels);
 	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5e300daa2559..c879e7754ee6 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -70,7 +70,7 @@ xfs_allocfree_log_count(
 {
 	uint		blocks;
 
-	blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
+	blocks = num_ops * 2 * (2 * mp->m_alloc_maxlevels - 1);
 	if (xfs_has_rmapbt(mp))
 		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
 	if (xfs_has_reflink(mp))
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 50332be34388..bd04cb836419 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -74,7 +74,7 @@
 #define	XFS_DIOSTRAT_SPACE_RES(mp, v)	\
 	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + (v))
 #define	XFS_GROWFS_SPACE_RES(mp)	\
-	(2 * (mp)->m_ag_maxlevels)
+	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
 #define	XFS_LINK_SPACE_RES(mp,nl)	\
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index a2c3af77b6c2..bed798792226 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -555,11 +555,11 @@ xchk_agf(
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
-	if (level <= 0 || level > mp->m_ag_maxlevels)
+	if (level <= 0 || level > mp->m_alloc_maxlevels)
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
-	if (level <= 0 || level > mp->m_ag_maxlevels)
+	if (level <= 0 || level > mp->m_alloc_maxlevels)
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	if (xfs_has_rmapbt(mp)) {
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 05c27149b65d..d7bfed52f4cd 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -339,12 +339,12 @@ xrep_agf(
 		[XREP_AGF_BNOBT] = {
 			.rmap_owner = XFS_RMAP_OWN_AG,
 			.buf_ops = &xfs_bnobt_buf_ops,
-			.maxlevels = sc->mp->m_ag_maxlevels,
+			.maxlevels = sc->mp->m_alloc_maxlevels,
 		},
 		[XREP_AGF_CNTBT] = {
 			.rmap_owner = XFS_RMAP_OWN_AG,
 			.buf_ops = &xfs_cntbt_buf_ops,
-			.maxlevels = sc->mp->m_ag_maxlevels,
+			.maxlevels = sc->mp->m_alloc_maxlevels,
 		},
 		[XREP_AGF_RMAPBT] = {
 			.rmap_owner = XFS_RMAP_OWN_AG,
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e091f3b3fa15..e4b7a8eb0d06 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -128,8 +128,8 @@ typedef struct xfs_mount {
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
 	uint			m_refc_mxr[2];	/* max refc btree records */
 	uint			m_refc_mnr[2];	/* min refc btree records */
-	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
-	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
+	uint			m_alloc_maxlevels; /* max alloc btree levels */
+	uint			m_bm_maxlevels[2]; /* max bmap btree levels */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_refc_maxlevels; /* max refcount btree level */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */


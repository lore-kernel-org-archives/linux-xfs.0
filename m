Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:38458 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbeHTIDb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Aug 2018 04:03:31 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0006Ry-3F
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0000QA-2Q
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/10] xfs: replace xfs_sb_version checks with feature flag checks
Date: Mon, 20 Aug 2018 14:48:43 +1000
Message-Id: <20180820044851.414-3-david@fromorbit.com>
In-Reply-To: <20180820044851.414-1-david@fromorbit.com>
References: <20180820044851.414-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Convert the xfs_sb_version_hasfoo() to checks against
mp->m_features. Checks of the superblock itself during disk
operations (e.g. in the read/write verifiers and the to/from disk
formatters) are not converted - they operate purely on the
superblock state. Everything else should use the mount features.

Large parts of this conversion were done with sed with commands like
this:

for f in `git grep -l xfs_sb_version_has fs/xfs/*.c`; do
	sed -i -e 's/xfs_sb_version_has\(.*\)(&\(.*\)->m_sb)/xfs_has_\1(\2)/' $f
done

With manual cleanups for things like "xfs_has_extflgbit" and other
little inconsistencies in naming.

The result is ia lot less typing to check features and an XFS binary
size reduced by a bit over 3kB:

$ size -t fs/xfs/built-in.a
	text	   data	    bss	    dec	    hex	filenam
before	1294873	 182766	   1036	1478675	 169013	(TOTALS)
after	1291658	 182766	   1036	1475460	 168384	(TOTALS)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c             | 20 +++++++--------
 fs/xfs/libxfs/xfs_alloc.c          | 40 +++++++++++++++---------------
 fs/xfs/libxfs/xfs_alloc_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_alloc_btree.h    |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      | 16 ++++++------
 fs/xfs/libxfs/xfs_attr_remote.c    | 12 ++++-----
 fs/xfs/libxfs/xfs_bmap.c           | 20 +++++++--------
 fs/xfs/libxfs/xfs_bmap_btree.c     |  4 +--
 fs/xfs/libxfs/xfs_bmap_btree.h     |  2 +-
 fs/xfs/libxfs/xfs_btree.c          | 20 +++++++--------
 fs/xfs/libxfs/xfs_da_btree.c       |  6 ++---
 fs/xfs/libxfs/xfs_da_format.c      |  6 ++---
 fs/xfs/libxfs/xfs_da_format.h      |  2 +-
 fs/xfs/libxfs/xfs_dir2.c           |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |  8 +++---
 fs/xfs/libxfs/xfs_dir2_data.c      |  8 +++---
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  8 +++---
 fs/xfs/libxfs/xfs_dir2_node.c      | 10 ++++----
 fs/xfs/libxfs/xfs_dir2_sf.c        |  2 +-
 fs/xfs/libxfs/xfs_dquot_buf.c      |  6 ++---
 fs/xfs/libxfs/xfs_format.h         | 14 +++++------
 fs/xfs/libxfs/xfs_ialloc.c         | 28 ++++++++++-----------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  6 ++---
 fs/xfs/libxfs/xfs_ialloc_btree.h   |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c      | 12 ++++-----
 fs/xfs/libxfs/xfs_log_format.h     |  4 +--
 fs/xfs/libxfs/xfs_log_rlimit.c     |  2 +-
 fs/xfs/libxfs/xfs_refcount.c       |  8 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c |  4 +--
 fs/xfs/libxfs/xfs_rmap.c           |  6 ++---
 fs/xfs/libxfs/xfs_rmap_btree.c     |  6 ++---
 fs/xfs/libxfs/xfs_sb.c             | 16 ++++++------
 fs/xfs/libxfs/xfs_symlink_remote.c | 10 ++++----
 fs/xfs/libxfs/xfs_trans_resv.c     | 14 +++++------
 fs/xfs/libxfs/xfs_trans_space.h    |  4 +--
 fs/xfs/libxfs/xfs_types.c          |  2 +-
 fs/xfs/scrub/agheader.c            | 12 ++++-----
 fs/xfs/scrub/agheader_repair.c     | 20 +++++++--------
 fs/xfs/scrub/attr.c                |  2 +-
 fs/xfs/scrub/bmap.c                |  8 +++---
 fs/xfs/scrub/common.c              |  8 +++---
 fs/xfs/scrub/dabtree.c             |  4 +--
 fs/xfs/scrub/dir.c                 | 10 ++++----
 fs/xfs/scrub/ialloc.c              |  2 +-
 fs/xfs/scrub/inode.c               |  6 ++---
 fs/xfs/scrub/quota.c               |  2 +-
 fs/xfs/scrub/repair.c              | 14 +++++------
 fs/xfs/scrub/scrub.c               |  4 +--
 fs/xfs/xfs_bmap_util.c             | 10 ++++----
 fs/xfs/xfs_buf.c                   |  2 +-
 fs/xfs/xfs_buf_item.c              |  2 +-
 fs/xfs/xfs_dir2_readdir.c          |  2 +-
 fs/xfs/xfs_dquot.c                 |  4 +--
 fs/xfs/xfs_fsmap.c                 |  4 +--
 fs/xfs/xfs_ioctl.c                 |  8 +++---
 fs/xfs/xfs_iops.c                  |  6 ++---
 fs/xfs/xfs_log.c                   | 20 +++++++--------
 fs/xfs/xfs_log_recover.c           | 30 +++++++++++-----------
 fs/xfs/xfs_mount.c                 | 23 +++++++++--------
 fs/xfs/xfs_qm.c                    | 10 ++++----
 fs/xfs/xfs_qm_bhv.c                |  2 +-
 fs/xfs/xfs_qm_syscalls.c           |  2 +-
 fs/xfs/xfs_reflink.c               |  6 ++---
 fs/xfs/xfs_super.c                 | 16 ++++++------
 fs/xfs/xfs_symlink.c               |  2 +-
 fs/xfs/xfs_trans.c                 | 14 +++++------
 66 files changed, 295 insertions(+), 294 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9345802c99f7..41c53f7a0cf3 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -139,7 +139,7 @@ xfs_rmaproot_init(
 	rrec->rm_offset = 0;
 
 	/* account for refc btree root */
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		rrec = XFS_RMAP_REC_ADDR(block, 5);
 		rrec->rm_startblock = cpu_to_be32(xfs_refc_block(mp));
 		rrec->rm_blockcount = cpu_to_be32(1);
@@ -186,7 +186,7 @@ xfs_agfblock_init(
 	agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
 	agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
 	agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (xfs_has_rmapbt(mp)) {
 		agf->agf_roots[XFS_BTNUM_RMAPi] =
 					cpu_to_be32(XFS_RMAP_BLOCK(mp));
 		agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
@@ -199,9 +199,9 @@ xfs_agfblock_init(
 	tmpsize = id->agsize - mp->m_ag_prealloc_blocks;
 	agf->agf_freeblks = cpu_to_be32(tmpsize);
 	agf->agf_longest = cpu_to_be32(tmpsize);
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		agf->agf_refcount_root = cpu_to_be32(
 				xfs_refc_block(mp));
 		agf->agf_refcount_level = cpu_to_be32(1);
@@ -219,7 +219,7 @@ xfs_agflblock_init(
 	__be32			*agfl_bno;
 	int			bucket;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 		agfl->agfl_seqno = cpu_to_be32(id->agno);
 		uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
@@ -249,9 +249,9 @@ xfs_agiblock_init(
 	agi->agi_freecount = 0;
 	agi->agi_newino = cpu_to_be32(NULLAGINO);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
-	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+	if (xfs_has_finobt(mp)) {
 		agi->agi_free_root = cpu_to_be32(XFS_FIBT_BLOCK(mp));
 		agi->agi_free_level = cpu_to_be32(1);
 	}
@@ -364,14 +364,14 @@ xfs_ag_init_headers(
 		.ops = &xfs_inobt_buf_ops,
 		.work = &xfs_btroot_init,
 		.type = XFS_BTNUM_FINO,
-		.need_init =  xfs_sb_version_hasfinobt(&mp->m_sb)
+		.need_init =  xfs_has_finobt(mp)
 	},
 	{ /* RMAP root block */
 		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_RMAP_BLOCK(mp)),
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_rmapbt_buf_ops,
 		.work = &xfs_rmaproot_init,
-		.need_init = xfs_sb_version_hasrmapbt(&mp->m_sb)
+		.need_init = xfs_has_rmapbt(mp)
 	},
 	{ /* REFC root block */
 		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, xfs_refc_block(mp)),
@@ -379,7 +379,7 @@ xfs_ag_init_headers(
 		.ops = &xfs_refcountbt_buf_ops,
 		.work = &xfs_btroot_init,
 		.type = XFS_BTNUM_REFC,
-		.need_init = xfs_sb_version_hasreflink(&mp->m_sb)
+		.need_init = xfs_has_reflink(mp)
 	},
 	{ /* NULL terminating block */
 		.daddr = XFS_BUF_DADDR_NULL,
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e1c0c0d2f1b0..edf0fbd58ee5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -55,7 +55,7 @@ xfs_agfl_size(
 {
 	unsigned int		size = mp->m_sb.sb_sectsize;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		size -= sizeof(struct xfs_agfl);
 
 	return size / sizeof(xfs_agblock_t);
@@ -65,9 +65,9 @@ unsigned int
 xfs_refc_block(
 	struct xfs_mount	*mp)
 {
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		return XFS_RMAP_BLOCK(mp) + 1;
-	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (xfs_has_finobt(mp))
 		return XFS_FIBT_BLOCK(mp) + 1;
 	return XFS_IBT_BLOCK(mp) + 1;
 }
@@ -76,11 +76,11 @@ xfs_extlen_t
 xfs_prealloc_blocks(
 	struct xfs_mount	*mp)
 {
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		return xfs_refc_block(mp) + 1;
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		return XFS_RMAP_BLOCK(mp) + 1;
-	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (xfs_has_finobt(mp))
 		return XFS_FIBT_BLOCK(mp) + 1;
 	return XFS_IBT_BLOCK(mp) + 1;
 }
@@ -130,11 +130,11 @@ xfs_alloc_ag_max_usable(
 	blocks = XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)); /* ag headers */
 	blocks += XFS_ALLOC_AGFL_RESERVE;
 	blocks += 3;			/* AGF, AGI btree root blocks */
-	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (xfs_has_finobt(mp))
 		blocks++;		/* finobt root block */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		blocks++; 		/* rmap root block */
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		blocks++;		/* refcount root block */
 
 	return mp->m_sb.sb_agblocks - blocks;
@@ -565,7 +565,7 @@ xfs_agfl_verify(
 	 * AGFL is what the AGF says is active. We can't get to the AGF, so we
 	 * can't verify just those entries are valid.
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return NULL;
 
 	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
@@ -605,7 +605,7 @@ xfs_agfl_read_verify(
 	 * AGFL is what the AGF says is active. We can't get to the AGF, so we
 	 * can't verify just those entries are valid.
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
@@ -626,7 +626,7 @@ xfs_agfl_write_verify(
 	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc AGFLs */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	fa = xfs_agfl_verify(bp);
@@ -2019,7 +2019,7 @@ xfs_alloc_min_freelist(
 	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_CNTi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed reverse mapping used space btree */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		min_free += min_t(unsigned int,
 				  pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
 				  mp->m_rmap_maxlevels);
@@ -2121,7 +2121,7 @@ xfs_agfl_needs_reset(
 	int			active;
 
 	/* no agfl header on v4 supers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return false;
 
 	/*
@@ -2580,7 +2580,7 @@ xfs_agf_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(bp);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (!xfs_log_check_lsn(mp,
@@ -2602,7 +2602,7 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > XFS_BTREE_MAXLEVELS)
 		return __this_address;
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	if (xfs_has_rmapbt(mp) &&
 	    (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
 	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS))
 		return __this_address;
@@ -2616,11 +2616,11 @@ xfs_agf_verify(
 	if (bp->b_pag && be32_to_cpu(agf->agf_seqno) != bp->b_pag->pag_agno)
 		return __this_address;
 
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
+	if (xfs_has_lazysbcount(mp) &&
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return __this_address;
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	if (xfs_has_reflink(mp) &&
 	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
 	     be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS))
 		return __this_address;
@@ -2636,7 +2636,7 @@ xfs_agf_read_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	xfs_failaddr_t	fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -2660,7 +2660,7 @@ xfs_agf_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 4e59cc8a2802..dd9c552d3eb0 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -513,7 +513,7 @@ xfs_allocbt_init_cursor(
 	cur->bc_private.a.agbp = agbp;
 	cur->bc_private.a.agno = agno;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	return cur;
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index c9305ebb69f6..0f7afe756add 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -18,7 +18,7 @@ struct xfs_mount;
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_ALLOC_BLOCK_LEN(mp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+	(xfs_has_crc(((mp))) ? \
 		XFS_BTREE_SBLOCK_CRC_LEN : XFS_BTREE_SBLOCK_LEN)
 
 /*
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6fc5425b1474..fbd53362b5bc 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -248,7 +248,7 @@ xfs_attr3_leaf_verify(
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
 		if (ichdr.magic != XFS_ATTR3_LEAF_MAGIC)
@@ -328,7 +328,7 @@ xfs_attr3_leaf_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -350,7 +350,7 @@ xfs_attr3_leaf_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -508,10 +508,10 @@ STATIC void
 xfs_sbversion_add_attr2(xfs_mount_t *mp, xfs_trans_t *tp)
 {
 	if ((mp->m_flags & XFS_MOUNT_ATTR2) &&
-	    !(xfs_sb_version_hasattr2(&mp->m_sb))) {
+	    !(xfs_has_attr2(mp))) {
 		spin_lock(&mp->m_sb_lock);
-		if (!xfs_sb_version_hasattr2(&mp->m_sb)) {
-			xfs_sb_version_addattr2(&mp->m_sb);
+		if (!xfs_has_attr2(mp)) {
+			xfs_feat_add_attr2(mp);
 			spin_unlock(&mp->m_sb_lock);
 			xfs_log_sb(tp);
 		} else
@@ -1089,7 +1089,7 @@ xfs_attr3_leaf_to_node(
 	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLFT_ATTR_LEAF_BUF);
 	bp2->b_ops = bp1->b_ops;
 	memcpy(bp2->b_addr, bp1->b_addr, args->geo->blksize);
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_blkinfo *hdr3 = bp2->b_addr;
 		hdr3->blkno = cpu_to_be64(bp2->b_bn);
 	}
@@ -1155,7 +1155,7 @@ xfs_attr3_leaf_create(
 	memset(&ichdr, 0, sizeof(ichdr));
 	ichdr.firstused = args->geo->blksize;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_blkinfo *hdr3 = bp->b_addr;
 
 		ichdr.magic = XFS_ATTR3_LEAF_MAGIC;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index af094063e402..a23946447037 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -41,7 +41,7 @@ xfs_attr3_rmt_blocks(
 	struct xfs_mount *mp,
 	int		attrlen)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		int buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
 		return (attrlen + buflen - 1) / buflen;
 	}
@@ -85,7 +85,7 @@ xfs_attr3_rmt_verify(
 {
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return __this_address;
 	if (rmt->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
 		return __this_address;
@@ -117,7 +117,7 @@ __xfs_attr3_rmt_read_verify(
 	int		blksize = mp->m_attr_geo->blksize;
 
 	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return 0;
 
 	ptr = bp->b_addr;
@@ -182,7 +182,7 @@ xfs_attr3_rmt_write_verify(
 	xfs_daddr_t	bno;
 
 	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	ptr = bp->b_addr;
@@ -236,7 +236,7 @@ xfs_attr3_rmt_hdr_set(
 {
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return 0;
 
 	rmt->rm_magic = cpu_to_be32(XFS_ATTR3_RMT_MAGIC);
@@ -286,7 +286,7 @@ xfs_attr_rmtval_copyout(
 
 		byte_cnt = min(*valuelen, byte_cnt);
 
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (xfs_has_crc(mp)) {
 			if (xfs_attr3_rmt_hdr_ok(src, ino, *offset,
 						  byte_cnt, bno)) {
 				xfs_alert(mp,
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2760314fdf7f..777630f3066a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1110,17 +1110,17 @@ xfs_bmap_add_attrfork(
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (error)
 		goto trans_cancel;
-	if (!xfs_sb_version_hasattr(&mp->m_sb) ||
-	   (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2)) {
+	if (!xfs_has_attr(mp) ||
+	   (!xfs_has_attr2(mp) && version == 2)) {
 		bool log_sb = false;
 
 		spin_lock(&mp->m_sb_lock);
-		if (!xfs_sb_version_hasattr(&mp->m_sb)) {
-			xfs_sb_version_addattr(&mp->m_sb);
+		if (!xfs_has_attr(mp)) {
+			xfs_feat_add_attr(mp);
 			log_sb = true;
 		}
-		if (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2) {
-			xfs_sb_version_addattr2(&mp->m_sb);
+		if (!xfs_has_attr2(mp) && version == 2) {
+			xfs_feat_add_attr2(mp);
 			log_sb = true;
 		}
 		spin_unlock(&mp->m_sb_lock);
@@ -4080,7 +4080,7 @@ xfs_bmapi_allocate(
 	 */
 	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
 	    (bma->flags & XFS_BMAPI_PREALLOC) &&
-	    xfs_sb_version_hasextflgbit(&mp->m_sb))
+	    xfs_has_extflg(mp))
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
 	if (bma->wasdel)
@@ -5244,7 +5244,7 @@ __xfs_bunmapi(
 			 * get rid of part of a realtime extent.
 			 */
 			if (del.br_state == XFS_EXT_UNWRITTEN ||
-			    !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
+			    !xfs_has_extflg(mp)) {
 				/*
 				 * This piece is unwritten, or we're not
 				 * using unwritten extents.  Skip over it.
@@ -5297,7 +5297,7 @@ __xfs_bunmapi(
 			} else if ((del.br_startoff == start &&
 				    (del.br_state == XFS_EXT_UNWRITTEN ||
 				     tp->t_blk_res == 0)) ||
-				   !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
+				   !xfs_has_extflg(mp)) {
 				/*
 				 * Can't make it unwritten.  There isn't
 				 * a full extent here so just skip it.
@@ -6115,7 +6115,7 @@ xfs_bmap_validate_extent(
 	if (irec->br_state != XFS_EXT_NORM) {
 		if (whichfork != XFS_DATA_FORK)
 			return __this_address;
-		if (!xfs_sb_version_hasextflgbit(&mp->m_sb))
+		if (!xfs_has_extflg(mp))
 			return __this_address;
 	}
 	return NULL;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index cdb74d2e2a43..91275ff86c8d 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -139,7 +139,7 @@ xfs_bmbt_to_bmdr(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		ASSERT(rblock->bb_magic == cpu_to_be32(XFS_BMAP_CRC_MAGIC));
 		ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid,
 		       &mp->m_sb.sb_meta_uuid));
@@ -555,7 +555,7 @@ xfs_bmbt_init_cursor(
 
 	cur->bc_ops = &xfs_bmbt_ops;
 	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 29b407d053b4..11a5586e752e 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -16,7 +16,7 @@ struct xfs_trans;
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_BMBT_BLOCK_LEN(mp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+	(xfs_has_crc(((mp))) ? \
 		XFS_BTREE_LBLOCK_CRC_LEN : XFS_BTREE_LBLOCK_LEN)
 
 #define XFS_BMBT_REC_ADDR(mp, block, index) \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 34c6d7bd4d18..3319b9f8e2ba 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -65,7 +65,7 @@ __xfs_btree_check_lblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
-	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
+	int			crc = xfs_has_crc(mp);
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -131,7 +131,7 @@ __xfs_btree_check_sblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
-	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
+	int			crc = xfs_has_crc(mp);
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -276,7 +276,7 @@ xfs_btree_lblock_calc_crc(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	if (!xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	if (!xfs_has_crc(bp->b_target->bt_mount))
 		return;
 	if (bip)
 		block->bb_u.l.bb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
@@ -290,7 +290,7 @@ xfs_btree_lblock_verify_crc(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn)))
 			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
@@ -314,7 +314,7 @@ xfs_btree_sblock_calc_crc(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	if (!xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	if (!xfs_has_crc(bp->b_target->bt_mount))
 		return;
 	if (bip)
 		block->bb_u.s.bb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
@@ -328,7 +328,7 @@ xfs_btree_sblock_verify_crc(
 	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
 			return __this_address;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
@@ -1146,7 +1146,7 @@ xfs_btree_init_block_int(
 	__u64			owner,
 	unsigned int		flags)
 {
-	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
+	int			crc = xfs_has_crc(mp);
 	__u32			magic = xfs_btree_magic(crc, btnum);
 
 	buf->bb_magic = cpu_to_be32(magic);
@@ -1811,7 +1811,7 @@ xfs_btree_lookup_get_block(
 		return error;
 
 	/* Check the inode owner since the verifiers don't. */
-	if (xfs_sb_version_hascrc(&cur->bc_mp->m_sb) &&
+	if (xfs_has_crc(cur->bc_mp) &&
 	    !(cur->bc_private.b.flags & XFS_BTCUR_BPRV_INVALID_OWNER) &&
 	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
 	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
@@ -4436,7 +4436,7 @@ xfs_btree_lblock_v5hdr_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return __this_address;
 	if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
@@ -4488,7 +4488,7 @@ xfs_btree_sblock_v5hdr_verify(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return __this_address;
 	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 376bee94b5dd..ed2132c0e3bc 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -129,7 +129,7 @@ xfs_da3_node_verify(
 
 	ops->node_hdr_from_disk(&ichdr, hdr);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
 		if (ichdr.magic != XFS_DA3_NODE_MAGIC)
@@ -180,7 +180,7 @@ xfs_da3_node_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -337,7 +337,7 @@ xfs_da3_node_create(
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
 	node = bp->b_addr;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
 		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index b39053dcb643..04ca3b9044b0 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -869,9 +869,9 @@ xfs_dir_get_ops(
 		return dp->d_ops;
 	if (mp->m_dir_inode_ops)
 		return mp->m_dir_inode_ops;
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		return &xfs_dir3_ops;
-	if (xfs_sb_version_hasftype(&mp->m_sb))
+	if (xfs_has_ftype(mp))
 		return &xfs_dir2_ftype_ops;
 	return &xfs_dir2_ops;
 }
@@ -885,7 +885,7 @@ xfs_nondir_get_ops(
 		return dp->d_ops;
 	if (mp->m_nondir_inode_ops)
 		return mp->m_nondir_inode_ops;
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		return &xfs_dir3_nondir_ops;
 	return &xfs_dir2_nondir_ops;
 }
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 5d5bf3bffc78..5df76821ffc8 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -860,7 +860,7 @@ struct xfs_attr3_rmt_hdr {
 #define XFS_ATTR3_RMT_CRC_OFF	offsetof(struct xfs_attr3_rmt_hdr, rm_crc)
 
 #define XFS_ATTR3_RMT_BUF_SPACE(mp, bufsize)	\
-	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
+	((bufsize) - (xfs_has_crc((mp)) ? \
 			sizeof(struct xfs_attr3_rmt_hdr) : 0))
 
 /* Number of bytes in a directory block. */
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 229152cd1a24..f80fde72ad2d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -151,7 +151,7 @@ xfs_da_mount(
 				(uint)sizeof(xfs_da_node_entry_t);
 	dageo->magicpct = (dageo->blksize * 37) / 100;
 
-	if (xfs_sb_version_hasasciici(&mp->m_sb))
+	if (xfs_has_asciici(mp))
 		mp->m_dirnameops = &xfs_ascii_ci_nameops;
 	else
 		mp->m_dirnameops = &xfs_default_nameops;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 30ed5919da72..7ae94e0c111c 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -53,7 +53,7 @@ xfs_dir3_block_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
 			return __this_address;
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
@@ -76,7 +76,7 @@ xfs_dir3_block_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -101,7 +101,7 @@ xfs_dir3_block_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -145,7 +145,7 @@ xfs_dir3_block_init(
 	bp->b_ops = &xfs_dir3_block_buf_ops;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_BLOCK_BUF);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		memset(hdr3, 0, sizeof(*hdr3));
 		hdr3->magic = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
 		hdr3->blkno = cpu_to_be64(bp->b_bn);
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 01162c62ec8f..cf0a3b40b3e5 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -252,7 +252,7 @@ xfs_dir3_data_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC))
 			return __this_address;
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
@@ -303,7 +303,7 @@ xfs_dir3_data_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -328,7 +328,7 @@ xfs_dir3_data_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -665,7 +665,7 @@ xfs_dir3_data_init(
 	 * Initialize the header.
 	 */
 	hdr = bp->b_addr;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
 		memset(hdr3, 0, sizeof(*hdr3));
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 1728a3e6f5cf..7ed0e018555e 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -150,7 +150,7 @@ xfs_dir3_leaf_verify(
 
 	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
 		uint16_t		magic3;
 
@@ -181,7 +181,7 @@ __read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -207,7 +207,7 @@ __write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -321,7 +321,7 @@ xfs_dir3_leaf_init(
 
 	ASSERT(type == XFS_DIR2_LEAF1_MAGIC || type == XFS_DIR2_LEAFN_MAGIC);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
 
 		memset(leaf3, 0, sizeof(*leaf3));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index f1bb3434f51c..60e5b19a4516 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -87,7 +87,7 @@ xfs_dir3_free_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir2_free_hdr *hdr = bp->b_addr;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_FREE_MAGIC))
@@ -115,7 +115,7 @@ xfs_dir3_free_read_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -140,7 +140,7 @@ xfs_dir3_free_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -171,7 +171,7 @@ xfs_dir3_free_header_check(
 	firstdb = (xfs_dir2_da_to_db(mp->m_dir_geo, fbno) -
 		   xfs_dir2_byte_to_db(mp->m_dir_geo, XFS_DIR2_FREE_OFFSET)) *
 			maxbests;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_free_hdr *hdr3 = bp->b_addr;
 
 		if (be32_to_cpu(hdr3->firstdb) != firstdb)
@@ -272,7 +272,7 @@ xfs_dir3_free_get_buf(
 	memset(bp->b_addr, 0, sizeof(struct xfs_dir3_free_hdr));
 	memset(&hdr, 0, sizeof(hdr));
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_free_hdr *hdr3 = bp->b_addr;
 
 		hdr.magic = XFS_DIR3_FREE_MAGIC;
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 585dfdb7b6b6..8f5e17f79151 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -75,7 +75,7 @@ xfs_dir2_block_sfsize(
 	 * if there is a filetype field, add the extra byte to the namelen
 	 * for each entry that we see.
 	 */
-	has_ftype = xfs_sb_version_hasftype(&mp->m_sb) ? 1 : 0;
+	has_ftype = xfs_has_ftype(mp) ? 1 : 0;
 
 	count = i8count = namelen = 0;
 	btp = xfs_dir2_block_tail_p(geo, hdr);
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index d293f371dd54..b61029e2ca58 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -100,7 +100,7 @@ xfs_dqblk_verify(
 	xfs_dqid_t	 	id,
 	uint		 	type)	/* used only during quotacheck */
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
 
@@ -128,7 +128,7 @@ xfs_dqblk_repair(
 	dqb->dd_diskdq.d_flags = type;
 	dqb->dd_diskdq.d_id = cpu_to_be32(id);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		uuid_copy(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid);
 		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
@@ -147,7 +147,7 @@ xfs_dquot_buf_verify_crc(
 	int			ndquots;
 	int			i;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return true;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c7b5a43af910..e21c39b13890 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -357,7 +357,7 @@ static inline bool xfs_sb_version_haslogv2(struct xfs_sb *sbp)
 	       (sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
 }
 
-static inline bool xfs_sb_version_hasextflgbit(struct xfs_sb *sbp)
+static inline bool xfs_sb_version_hasextflg(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
 	       (sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
@@ -409,7 +409,7 @@ static inline void xfs_sb_version_removeattr2(struct xfs_sb *sbp)
 		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
 }
 
-static inline bool xfs_sb_version_hasprojid32bit(struct xfs_sb *sbp)
+static inline bool xfs_sb_version_hasprojid32(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
 	       (xfs_sb_version_hasmorebits(sbp) &&
@@ -501,7 +501,7 @@ static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
-static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
+static inline bool xfs_sb_version_haspquotino(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
@@ -790,7 +790,7 @@ typedef struct xfs_agi {
 #define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
 
 #define XFS_BUF_TO_AGFL_BNO(mp, bp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+	(xfs_has_crc(((mp))) ? \
 		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
 		(__be32 *)(bp)->b_addr)
 
@@ -1208,7 +1208,7 @@ struct xfs_dsymlink_hdr {
 #define XFS_SYMLINK_MAPS 3
 
 #define XFS_SYMLINK_BUF_SPACE(mp, bufsize)	\
-	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
+	((bufsize) - (xfs_has_crc((mp)) ? \
 			sizeof(struct xfs_dsymlink_hdr) : 0))
 
 
@@ -1440,7 +1440,7 @@ struct xfs_rmap_key {
 typedef __be32 xfs_rmap_ptr_t;
 
 #define	XFS_RMAP_BLOCK(mp) \
-	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
+	(xfs_has_finobt(((mp))) ? \
 	 XFS_FIBT_BLOCK(mp) + 1 : \
 	 XFS_IBT_BLOCK(mp) + 1)
 
@@ -1665,7 +1665,7 @@ struct xfs_acl {
  * limited only by the maximum size of the xattr that stores the information.
  */
 #define XFS_ACL_MAX_ENTRIES(mp)	\
-	(xfs_sb_version_hascrc(&mp->m_sb) \
+	(xfs_has_crc(mp) \
 		?  (XFS_XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
 						sizeof(struct xfs_acl_entry) \
 		: 25)
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a8f6db735d5d..8d23491badb7 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -39,7 +39,7 @@ int
 xfs_ialloc_cluster_alignment(
 	struct xfs_mount	*mp)
 {
-	if (xfs_sb_version_hasalign(&mp->m_sb) &&
+	if (xfs_has_align(mp) &&
 	    mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
 		return mp->m_sb.sb_inoalignmt;
 	return 1;
@@ -75,7 +75,7 @@ xfs_inobt_update(
 	union xfs_btree_rec	rec;
 
 	rec.inobt.ir_startino = cpu_to_be32(irec->ir_startino);
-	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+	if (xfs_has_sparseinodes(cur->bc_mp)) {
 		rec.inobt.ir_u.sp.ir_holemask = cpu_to_be16(irec->ir_holemask);
 		rec.inobt.ir_u.sp.ir_count = irec->ir_count;
 		rec.inobt.ir_u.sp.ir_freecount = irec->ir_freecount;
@@ -95,7 +95,7 @@ xfs_inobt_btrec_to_irec(
 	struct xfs_inobt_rec_incore	*irec)
 {
 	irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb)) {
+	if (xfs_has_sparseinodes(mp)) {
 		irec->ir_holemask = be16_to_cpu(rec->inobt.ir_u.sp.ir_holemask);
 		irec->ir_count = rec->inobt.ir_u.sp.ir_count;
 		irec->ir_freecount = rec->inobt.ir_u.sp.ir_freecount;
@@ -322,7 +322,7 @@ xfs_ialloc_inode_init(
 	 * That means for v3 inode we log the entire buffer rather than just the
 	 * inode cores.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		version = 3;
 		ino = XFS_AGINO_TO_INO(mp, agno,
 				       XFS_OFFBNO_TO_AGINO(mp, agbno, 0));
@@ -645,7 +645,7 @@ xfs_ialloc_ag_alloc(
 
 #ifdef DEBUG
 	/* randomly do sparse inode allocations */
-	if (xfs_sb_version_hassparseinodes(&tp->t_mountp->m_sb) &&
+	if (xfs_has_sparseinodes(tp->t_mountp) &&
 	    args.mp->m_ialloc_min_blks < args.mp->m_ialloc_blks)
 		do_sparse = prandom_u32() & 1;
 #endif
@@ -765,7 +765,7 @@ xfs_ialloc_ag_alloc(
 	 * Finally, try a sparse allocation if the filesystem supports it and
 	 * the sparse allocation length is smaller than a full chunk.
 	 */
-	if (xfs_sb_version_hassparseinodes(&args.mp->m_sb) &&
+	if (xfs_has_sparseinodes(args.mp) &&
 	    args.mp->m_ialloc_min_blks < args.mp->m_ialloc_blks &&
 	    args.fsbno == NULLFSBLOCK) {
 sparse_alloc:
@@ -868,7 +868,7 @@ xfs_ialloc_ag_alloc(
 		 * from the previous call. Set merge false to replace any
 		 * existing record with this one.
 		 */
-		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
+		if (xfs_has_finobt(args.mp)) {
 			error = xfs_inobt_insert_sprec(args.mp, tp, agbp,
 						       XFS_BTNUM_FINO, &rec,
 						       false);
@@ -882,7 +882,7 @@ xfs_ialloc_ag_alloc(
 		if (error)
 			return error;
 
-		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
+		if (xfs_has_finobt(args.mp)) {
 			error = xfs_inobt_insert(args.mp, tp, agbp, newino,
 						 newlen, XFS_BTNUM_FINO);
 			if (error)
@@ -1572,7 +1572,7 @@ xfs_dialloc_ag(
 	int				offset;
 	int				i;
 
-	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (!xfs_has_finobt(mp))
 		return xfs_dialloc_ag_inobt(tp, agbp, parent, inop);
 
 	pag = xfs_perag_get(mp, agno);
@@ -2206,7 +2206,7 @@ xfs_difree(
 	/*
 	 * Fix up the free inode btree.
 	 */
-	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+	if (xfs_has_finobt(mp)) {
 		error = xfs_difree_finobt(mp, tp, agbp, agino, &rec);
 		if (error)
 			goto error0;
@@ -2503,7 +2503,7 @@ xfs_agi_verify(
 	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
 	int		i;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (!xfs_log_check_lsn(mp,
@@ -2523,7 +2523,7 @@ xfs_agi_verify(
 	    be32_to_cpu(agi->agi_level) > XFS_BTREE_MAXLEVELS)
 		return __this_address;
 
-	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	if (xfs_has_finobt(mp) &&
 	    (be32_to_cpu(agi->agi_free_level) < 1 ||
 	     be32_to_cpu(agi->agi_free_level) > XFS_BTREE_MAXLEVELS))
 		return __this_address;
@@ -2554,7 +2554,7 @@ xfs_agi_read_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	xfs_failaddr_t	fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -2578,7 +2578,7 @@ xfs_agi_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 86c50208a143..11af5a89c297 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -196,7 +196,7 @@ xfs_inobt_init_rec_from_cur(
 	union xfs_btree_rec	*rec)
 {
 	rec->inobt.ir_startino = cpu_to_be32(cur->bc_rec.i.ir_startino);
-	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+	if (xfs_has_sparseinodes(cur->bc_mp)) {
 		rec->inobt.ir_u.sp.ir_holemask =
 					cpu_to_be16(cur->bc_rec.i.ir_holemask);
 		rec->inobt.ir_u.sp.ir_count = cur->bc_rec.i.ir_count;
@@ -429,7 +429,7 @@ xfs_inobt_init_cursor(
 
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_private.a.agbp = agbp;
@@ -587,7 +587,7 @@ xfs_finobt_calc_reserves(
 	xfs_extlen_t		tree_len = 0;
 	int			error;
 
-	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (!xfs_has_finobt(mp))
 		return 0;
 
 	error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO, &tree_len);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index ebdd0c6b8766..f6f2123e7ca7 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -18,7 +18,7 @@ struct xfs_mount;
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_INOBT_BLOCK_LEN(mp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+	(xfs_has_crc(((mp))) ? \
 		XFS_BTREE_SBLOCK_CRC_LEN : XFS_BTREE_SBLOCK_LEN)
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 30d1d60f1d46..6eb9f967d087 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -54,7 +54,7 @@ xfs_dinode_good_version(
 	struct xfs_mount *mp,
 	__u8		version)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		return version == 3;
 
 	return version == 1 || version == 2;
@@ -432,7 +432,7 @@ xfs_dinode_verify(
 
 	/* Verify v3 integrity information first */
 	if (dip->di_version >= 3) {
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
+		if (!xfs_has_crc(mp))
 			return __this_address;
 		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
 				      XFS_DINODE_CRC_OFF))
@@ -529,7 +529,7 @@ xfs_dinode_verify(
 
 	/* don't allow reflink/cowextsize if we don't have reflink */
 	if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
-	     !xfs_sb_version_hasreflink(&mp->m_sb))
+	     !xfs_has_reflink(mp))
 		return __this_address;
 
 	/* only regular files get reflink */
@@ -563,7 +563,7 @@ xfs_dinode_calc_crc(
 	if (dip->di_version < 3)
 		return;
 
-	ASSERT(xfs_sb_version_hascrc(&mp->m_sb));
+	ASSERT(xfs_has_crc(mp));
 	crc = xfs_start_cksum_update((char *)dip, mp->m_sb.sb_inodesize,
 			      XFS_DINODE_CRC_OFF);
 	dip->di_crc = xfs_end_cksum(crc);
@@ -602,7 +602,7 @@ xfs_iread(
 
 	/* shortcut IO on inode allocation if possible */
 	if ((iget_flags & XFS_IGET_CREATE) &&
-	    xfs_sb_version_hascrc(&mp->m_sb) &&
+	    xfs_has_crc(mp) &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
@@ -769,7 +769,7 @@ xfs_inode_validate_cowextsize(
 	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
 	cowextsize_bytes = XFS_FSB_TO_B(mp, cowextsize);
 
-	if (hint_flag && !xfs_sb_version_hasreflink(&mp->m_sb))
+	if (hint_flag && !xfs_has_reflink(mp))
 		return __this_address;
 
 	if (hint_flag && !(S_ISDIR(mode) || S_ISREG(mode)))
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e5f97c69b320..2654741bcff0 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -44,10 +44,10 @@ typedef uint32_t xlog_tid_t;
 #define XFS_MIN_LOG_FACTOR	3
 
 #define XLOG_REC_SHIFT(log) \
-	BTOBB(1 << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
+	BTOBB(1 << (xfs_has_logv2(log->l_mp) ? \
 	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
 #define XLOG_TOTAL_REC_SHIFT(log) \
-	BTOBB(XLOG_MAX_ICLOGS << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
+	BTOBB(XLOG_MAX_ICLOGS << (xfs_has_logv2(log->l_mp) ? \
 	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
 
 /* get lsn fields */
diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 1b542ec11d5d..5837ea72eaee 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -94,7 +94,7 @@ xfs_log_calc_minimum_size(
 	if (tres.tr_logcount > 1)
 		max_logres *= tres.tr_logcount;
 
-	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1)
+	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
 		lsunit = BTOBB(mp->m_sb.sb_logsunit);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 542aa1475b5f..00e6d51f157a 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1209,7 +1209,7 @@ xfs_refcount_increase_extent(
 	struct xfs_trans		*tp,
 	struct xfs_bmbt_irec		*PREV)
 {
-	if (!xfs_sb_version_hasreflink(&tp->t_mountp->m_sb))
+	if (!xfs_has_reflink(tp->t_mountp))
 		return 0;
 
 	return __xfs_refcount_add(tp, XFS_REFCOUNT_INCREASE,
@@ -1224,7 +1224,7 @@ xfs_refcount_decrease_extent(
 	struct xfs_trans		*tp,
 	struct xfs_bmbt_irec		*PREV)
 {
-	if (!xfs_sb_version_hasreflink(&tp->t_mountp->m_sb))
+	if (!xfs_has_reflink(tp->t_mountp))
 		return 0;
 
 	return __xfs_refcount_add(tp, XFS_REFCOUNT_DECREASE,
@@ -1552,7 +1552,7 @@ xfs_refcount_alloc_cow_extent(
 	struct xfs_mount		*mp = tp->t_mountp;
 	int				error;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return 0;
 
 	error = __xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
@@ -1574,7 +1574,7 @@ xfs_refcount_free_cow_extent(
 	struct xfs_mount		*mp = tp->t_mountp;
 	int				error;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return 0;
 
 	/* Remove rmap entry */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 1aaa01c97517..d409e7c91083 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -214,7 +214,7 @@ xfs_refcountbt_verify(
 	if (block->bb_magic != cpu_to_be32(XFS_REFC_CRC_MAGIC))
 		return __this_address;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return __this_address;
 	fa = xfs_btree_sblock_v5hdr_verify(bp);
 	if (fa)
@@ -415,7 +415,7 @@ xfs_refcountbt_calc_reserves(
 	xfs_extlen_t		tree_len;
 	int			error;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return 0;
 
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 245af452840e..bba475aa3424 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -664,7 +664,7 @@ xfs_rmap_free(
 	struct xfs_btree_cur	*cur;
 	int			error;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
@@ -901,7 +901,7 @@ xfs_rmap_alloc(
 	struct xfs_btree_cur	*cur;
 	int			error;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
@@ -2268,7 +2268,7 @@ xfs_rmap_update_is_needed(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	return xfs_sb_version_hasrmapbt(&mp->m_sb) && whichfork != XFS_COW_FORK;
+	return xfs_has_rmapbt(mp) && whichfork != XFS_COW_FORK;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index f79cf040d745..f3c6bab96429 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -313,7 +313,7 @@ xfs_rmapbt_verify(
 	if (block->bb_magic != cpu_to_be32(XFS_RMAP_CRC_MAGIC))
 		return __this_address;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return __this_address;
 	fa = xfs_btree_sblock_v5hdr_verify(bp);
 	if (fa)
@@ -517,7 +517,7 @@ xfs_rmapbt_compute_maxlevels(
 	 * disallow reflinking when less than 10% of the per-AG metadata
 	 * block reservation since the fallback is a regular file copy.
 	 */
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		mp->m_rmap_maxlevels = XFS_BTREE_MAXLEVELS;
 	else
 		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(
@@ -565,7 +565,7 @@ xfs_rmapbt_calc_reserves(
 	xfs_extlen_t		tree_len;
 	int			error;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 
 	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f9c8e1e9d8e3..5dcb9005173c 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -299,7 +299,7 @@ xfs_validate_sb_common(
 		return -EWRONGFS;
 	}
 
-	if (xfs_sb_version_has_pquotino(sbp)) {
+	if (xfs_sb_version_haspquotino(sbp)) {
 		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
 			xfs_notice(mp,
 			   "Version 5 of Super block has XFS_OQUOTA bits.");
@@ -409,7 +409,7 @@ xfs_validate_sb_common(
 	}
 
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
 		xfs_notice(mp, "v5 SB sanity check failed");
 		return -EFSCORRUPTED;
@@ -485,7 +485,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 	 * We need to do these manipilations only if we are working
 	 * with an older version of on-disk superblock.
 	 */
-	if (xfs_sb_version_has_pquotino(sbp))
+	if (xfs_sb_version_haspquotino(sbp))
 		return;
 
 	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
@@ -603,7 +603,7 @@ xfs_sb_quota_to_disk(
 	uint16_t	qflags = from->sb_qflags;
 
 	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
-	if (xfs_sb_version_has_pquotino(from)) {
+	if (xfs_sb_version_haspquotino(from)) {
 		to->sb_qflags = cpu_to_be16(from->sb_qflags);
 		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
 		to->sb_pquotino = cpu_to_be64(from->sb_pquotino);
@@ -761,7 +761,7 @@ xfs_sb_read_verify(
 		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
 			/* Only fail bad secondaries on a known V5 filesystem */
 			if (bp->b_bn == XFS_SB_DADDR ||
-			    xfs_sb_version_hascrc(&mp->m_sb)) {
+			    xfs_has_crc(mp)) {
 				error = -EFSBADCRC;
 				goto out_error;
 			}
@@ -827,7 +827,7 @@ xfs_sb_write_verify(
 	if (error)
 		goto out_error;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -1185,7 +1185,7 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_IALIGN;
 	if (xfs_sb_version_hasdalign(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_DALIGN;
-	if (xfs_sb_version_hasextflgbit(sbp))
+	if (xfs_sb_version_hasextflg(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXTFLG;
 	if (xfs_sb_version_hassector(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
@@ -1195,7 +1195,7 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LAZYSB;
 	if (xfs_sb_version_hasattr2(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR2;
-	if (xfs_sb_version_hasprojid32bit(sbp))
+	if (xfs_sb_version_hasprojid32(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_PROJID32;
 	if (xfs_sb_version_hascrc(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_V5SB;
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 95374ab2dee7..a9377ceedaeb 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -46,7 +46,7 @@ xfs_symlink_hdr_set(
 {
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return 0;
 
 	memset(dsl, 0, sizeof(struct xfs_dsymlink_hdr));
@@ -93,7 +93,7 @@ xfs_symlink_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return __this_address;
 	if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
 		return __this_address;
@@ -120,7 +120,7 @@ xfs_symlink_read_verify(
 	xfs_failaddr_t	fa;
 
 	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF))
@@ -141,7 +141,7 @@ xfs_symlink_write_verify(
 	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	fa = xfs_symlink_verify(bp);
@@ -176,7 +176,7 @@ xfs_symlink_local_to_remote(
 
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SYMLINK_BUF);
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (!xfs_has_crc(mp)) {
 		bp->b_ops = NULL;
 		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
 		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index f99a7aefe418..a9af5d9962fe 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -73,9 +73,9 @@ xfs_allocfree_log_count(
 	uint		blocks;
 
 	blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
 
 	return blocks;
@@ -156,7 +156,7 @@ STATIC uint
 xfs_calc_finobt_res(
 	struct xfs_mount	*mp)
 {
-	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (!xfs_has_finobt(mp))
 		return 0;
 
 	return xfs_calc_inobt_res(mp);
@@ -188,7 +188,7 @@ xfs_calc_inode_chunk_res(
 			       XFS_FSB_TO_B(mp, 1));
 	if (alloc) {
 		/* icreate tx uses ordered buffers */
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_has_crc(mp))
 			return res;
 		size = XFS_FSB_TO_B(mp, 1);
 	}
@@ -785,14 +785,14 @@ xfs_trans_resv_calc(
 	 * require a permanent reservation on space.
 	 */
 	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
 	else
 		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		resp->tr_itruncate.tr_logcount =
 				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
 	else
@@ -853,7 +853,7 @@ xfs_trans_resv_calc(
 	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
 	else
 		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index a62fb950bef1..83d10dc5b1cc 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -57,7 +57,7 @@
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
 #define	XFS_IALLOC_SPACE_RES(mp)	\
 	((mp)->m_ialloc_blks + \
-	 (xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1 * \
+	 (xfs_has_finobt(mp) ? 2 : 1 * \
 	  ((mp)->m_in_maxlevels - 1)))
 
 /*
@@ -94,7 +94,7 @@
 #define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
-	(xfs_sb_version_hasfinobt(&mp->m_sb) ? (mp)->m_in_maxlevels : 0)
+	(xfs_has_finobt(mp) ? (mp)->m_in_maxlevels : 0)
 
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 33a5ca346baf..a5b87f20248f 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -142,7 +142,7 @@ xfs_internal_inum(
 	xfs_ino_t		ino)
 {
 	return ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
-		(xfs_sb_version_hasquota(&mp->m_sb) &&
+		(xfs_has_quota(mp) &&
 		 xfs_is_quota_inode(&mp->m_sb, ino));
 }
 
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 3068a9382feb..9135a0ffe751 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -280,7 +280,7 @@ xchk_superblock(
 	    (cpu_to_be32(mp->m_sb.sb_features2) & features_mask))
 		xchk_block_set_corrupt(sc, bp);
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (!xfs_has_crc(mp)) {
 		/* all v5 fields must be zero */
 		if (memchr_inv(&sb->sb_features_compat, 0,
 				sizeof(struct xfs_dsb) -
@@ -331,7 +331,7 @@ xchk_superblock(
 		/* Don't care about sb_lsn */
 	}
 
-	if (xfs_sb_version_hasmetauuid(&mp->m_sb)) {
+	if (xfs_has_metauuid(mp)) {
 		/* The metadata UUID must be the same for all supers */
 		if (!uuid_equal(&sb->sb_meta_uuid, &mp->m_sb.sb_meta_uuid))
 			xchk_block_set_corrupt(sc, bp);
@@ -441,7 +441,7 @@ xchk_agf_xref_btreeblks(
 	 * No rmap cursor; we can't xref if we have the rmapbt feature.
 	 * We also can't do it if we're missing the free space btree cursors.
 	 */
-	if ((xfs_sb_version_hasrmapbt(&mp->m_sb) && !sc->sa.rmap_cur) ||
+	if ((xfs_has_rmapbt(mp) && !sc->sa.rmap_cur) ||
 	    !sc->sa.bno_cur || !sc->sa.cnt_cur)
 		return;
 
@@ -559,7 +559,7 @@ xchk_agf(
 	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (xfs_has_rmapbt(mp)) {
 		agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
 		if (!xfs_verify_agbno(mp, agno, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
@@ -569,7 +569,7 @@ xchk_agf(
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 	}
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		agbno = be32_to_cpu(agf->agf_refcount_root);
 		if (!xfs_verify_agbno(mp, agno, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
@@ -856,7 +856,7 @@ xchk_agi(
 	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
-	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+	if (xfs_has_finobt(mp)) {
 		agbno = be32_to_cpu(agi->agi_free_root);
 		if (!xfs_verify_agbno(mp, agno, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index f7568a4b5fe5..5ba094312cb0 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -168,7 +168,7 @@ xrep_agf_find_btrees(
 		return -EFSCORRUPTED;
 
 	/* We must find the refcountbt root if that feature is enabled. */
-	if (xfs_sb_version_hasreflink(&sc->mp->m_sb) &&
+	if (xfs_has_reflink(sc->mp) &&
 	    !xrep_check_btree_root(sc, &fab[XREP_AGF_REFCOUNTBT]))
 		return -EFSCORRUPTED;
 
@@ -197,7 +197,7 @@ xrep_agf_init_header(
 	agf->agf_flfirst = old_agf->agf_flfirst;
 	agf->agf_fllast = old_agf->agf_fllast;
 	agf->agf_flcount = old_agf->agf_flcount;
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
 
 	/* Mark the incore AGF data stale until we're done fixing things. */
@@ -227,7 +227,7 @@ xrep_agf_set_roots(
 	agf->agf_levels[XFS_BTNUM_RMAPi] =
 			cpu_to_be32(fab[XREP_AGF_RMAPBT].height);
 
-	if (xfs_sb_version_hasreflink(&sc->mp->m_sb)) {
+	if (xfs_has_reflink(sc->mp)) {
 		agf->agf_refcount_root =
 				cpu_to_be32(fab[XREP_AGF_REFCOUNTBT].root);
 		agf->agf_refcount_level =
@@ -284,7 +284,7 @@ xrep_agf_calc_from_btrees(
 	agf->agf_btreeblks = cpu_to_be32(btreeblks);
 
 	/* Update the AGF counters from the refcountbt. */
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		cur = xfs_refcountbt_init_cursor(mp, sc->tp, agf_bp,
 				sc->sa.agno);
 		error = xfs_btree_count_blocks(cur, &blocks);
@@ -371,7 +371,7 @@ xrep_agf(
 	int				error;
 
 	/* We require the rmapbt to rebuild anything. */
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return -EOPNOTSUPP;
 
 	xchk_perag_get(sc->mp, &sc->sa);
@@ -655,7 +655,7 @@ xrep_agfl(
 	int			error;
 
 	/* We require the rmapbt to rebuild anything. */
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return -EOPNOTSUPP;
 
 	xchk_perag_get(sc->mp, &sc->sa);
@@ -758,7 +758,7 @@ xrep_agi_find_btrees(
 		return -EFSCORRUPTED;
 
 	/* We must find the finobt root if that feature is enabled. */
-	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	if (xfs_has_finobt(mp) &&
 	    !xrep_check_btree_root(sc, &fab[XREP_AGI_FINOBT]))
 		return -EFSCORRUPTED;
 
@@ -786,7 +786,7 @@ xrep_agi_init_header(
 	agi->agi_length = cpu_to_be32(xfs_ag_block_count(mp, sc->sa.agno));
 	agi->agi_newino = cpu_to_be32(NULLAGINO);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
 
 	/* We don't know how to fix the unlinked list yet. */
@@ -808,7 +808,7 @@ xrep_agi_set_roots(
 	agi->agi_root = cpu_to_be32(fab[XREP_AGI_INOBT].root);
 	agi->agi_level = cpu_to_be32(fab[XREP_AGI_INOBT].height);
 
-	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb)) {
+	if (xfs_has_finobt(sc->mp)) {
 		agi->agi_free_root = cpu_to_be32(fab[XREP_AGI_FINOBT].root);
 		agi->agi_free_level = cpu_to_be32(fab[XREP_AGI_FINOBT].height);
 	}
@@ -894,7 +894,7 @@ xrep_agi(
 	int				error;
 
 	/* We require the rmapbt to rebuild anything. */
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return -EOPNOTSUPP;
 
 	xchk_perag_get(sc->mp, &sc->sa);
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 81d5e90547a1..0ac1f766e1c0 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -270,7 +270,7 @@ xchk_xattr_block(
 	bitmap_zero(usedmap, mp->m_attr_geo->blksize);
 
 	/* Check all the padding. */
-	if (xfs_sb_version_hascrc(&ds->sc->mp->m_sb)) {
+	if (xfs_has_crc(ds->sc->mp)) {
 		struct xfs_attr3_leafblock	*leaf = bp->b_addr;
 
 		if (leaf->hdr.pad1 != 0 || leaf->hdr.pad2 != 0 ||
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index e1d11f3223e3..db53b81cf667 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -372,7 +372,7 @@ xchk_bmapbt_rec(
 	 * Check the owners of the btree blocks up to the level below
 	 * the root since the verifiers don't do that.
 	 */
-	if (xfs_sb_version_hascrc(&bs->cur->bc_mp->m_sb) &&
+	if (xfs_has_crc(bs->cur->bc_mp) &&
 	    bs->cur->bc_ptrs[0] == 1) {
 		for (i = 0; i < bs->cur->bc_nlevels - 1; i++) {
 			block = xfs_btree_get_block(bs->cur, i, &bp);
@@ -529,7 +529,7 @@ xchk_bmap_check_rmaps(
 	xfs_agnumber_t		agno;
 	int			error;
 
-	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb) ||
+	if (!xfs_has_rmapbt(sc->mp) ||
 	    whichfork == XFS_COW_FORK ||
 	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return 0;
@@ -612,8 +612,8 @@ xchk_bmap(
 	case XFS_ATTR_FORK:
 		if (!ifp)
 			goto out_check_rmap;
-		if (!xfs_sb_version_hasattr(&mp->m_sb) &&
-		    !xfs_sb_version_hasattr2(&mp->m_sb))
+		if (!xfs_has_attr(mp) &&
+		    !xfs_has_attr2(mp))
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		break;
 	default:
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 346b02abccf7..26752fbee3fb 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -481,7 +481,7 @@ xchk_ag_btcur_init(
 	}
 
 	/* Set up a finobt cursor for cross-referencing. */
-	if (sa->agi_bp && xfs_sb_version_hasfinobt(&mp->m_sb)) {
+	if (sa->agi_bp && xfs_has_finobt(mp)) {
 		sa->fino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
 				agno, XFS_BTNUM_FINO);
 		if (!sa->fino_cur)
@@ -489,7 +489,7 @@ xchk_ag_btcur_init(
 	}
 
 	/* Set up a rmapbt cursor for cross-referencing. */
-	if (sa->agf_bp && xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (sa->agf_bp && xfs_has_rmapbt(mp)) {
 		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
 				agno);
 		if (!sa->rmap_cur)
@@ -497,7 +497,7 @@ xchk_ag_btcur_init(
 	}
 
 	/* Set up a refcountbt cursor for cross-referencing. */
-	if (sa->agf_bp && xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (sa->agf_bp && xfs_has_reflink(mp)) {
 		sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
 				sa->agf_bp, agno);
 		if (!sa->refc_cur)
@@ -850,7 +850,7 @@ xchk_metadata_inode_forks(
 		return error;
 
 	/* Look for incorrect shared blocks. */
-	if (xfs_sb_version_hasreflink(&sc->mp->m_sb)) {
+	if (xfs_has_reflink(sc->mp)) {
 		error = xfs_reflink_inode_has_shared_extents(sc->tp, sc->ip,
 				&shared);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0,
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index f1260b4bfdee..1497d6731bca 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -387,11 +387,11 @@ xchk_da_btree_block(
 	pmaxrecs = &ds->maxrecs[level];
 
 	/* We only started zeroing the header on v5 filesystems. */
-	if (xfs_sb_version_hascrc(&ds->sc->mp->m_sb) && hdr3->hdr.pad)
+	if (xfs_has_crc(ds->sc->mp) && hdr3->hdr.pad)
 		xchk_da_set_corrupt(ds, level);
 
 	/* Check the owner. */
-	if (xfs_sb_version_hascrc(&ip->i_mount->m_sb)) {
+	if (xfs_has_crc(ip->i_mount)) {
 		owner = be64_to_cpu(hdr3->owner);
 		if (owner != ip->i_ino)
 			xchk_da_set_corrupt(ds, level);
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index cd3e4d768a18..68560a83871a 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -62,7 +62,7 @@ xchk_dir_check_ftype(
 	int			ino_dtype;
 	int			error = 0;
 
-	if (!xfs_sb_version_hasftype(&mp->m_sb)) {
+	if (!xfs_has_ftype(mp)) {
 		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
@@ -131,7 +131,7 @@ xchk_dir_actor(
 
 	if (!strncmp(".", name, namelen)) {
 		/* If this is "." then check that the inum matches the dir. */
-		if (xfs_sb_version_hasftype(&mp->m_sb) && type != DT_DIR)
+		if (xfs_has_ftype(mp) && type != DT_DIR)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
 		if (ino != ip->i_ino)
@@ -142,7 +142,7 @@ xchk_dir_actor(
 		 * If this is ".." in the root inode, check that the inum
 		 * matches this dir.
 		 */
-		if (xfs_sb_version_hasftype(&mp->m_sb) && type != DT_DIR)
+		if (xfs_has_ftype(mp) && type != DT_DIR)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
 		if (ip->i_ino == mp->m_sb.sb_rootino && ino != ip->i_ino)
@@ -508,7 +508,7 @@ xchk_directory_leaf1_bestfree(
 	bestcount = be32_to_cpu(ltp->bestcount);
 	bestp = xfs_dir2_leaf_bests_p(ltp);
 
-	if (xfs_sb_version_hascrc(&sc->mp->m_sb)) {
+	if (xfs_has_crc(sc->mp)) {
 		struct xfs_dir3_leaf_hdr	*hdr3 = bp->b_addr;
 
 		if (hdr3->pad != cpu_to_be32(0))
@@ -591,7 +591,7 @@ xchk_directory_free_bestfree(
 		goto out;
 	xchk_buffer_recheck(sc, bp);
 
-	if (xfs_sb_version_hascrc(&sc->mp->m_sb)) {
+	if (xfs_has_crc(sc->mp)) {
 		struct xfs_dir3_free_hdr	*hdr3 = bp->b_addr;
 
 		if (hdr3->pad != cpu_to_be32(0))
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 224dba937492..7b046abf3c8c 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -373,7 +373,7 @@ xchk_iallocbt_xref_rmap_btreeblks(
 	int			error;
 
 	if (!sc->sa.ino_cur || !sc->sa.rmap_cur ||
-	    (xfs_sb_version_hasfinobt(&sc->mp->m_sb) && !sc->sa.fino_cur) ||
+	    (xfs_has_finobt(sc->mp) && !sc->sa.fino_cur) ||
 	    xchk_skip_xref(sc->sm))
 		return;
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 5b3b177c0fc9..4fbddbbf84b4 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -177,7 +177,7 @@ xchk_inode_flags2(
 
 	/* reflink flag requires reflink feature */
 	if ((flags2 & XFS_DIFLAG2_REFLINK) &&
-	    !xfs_sb_version_hasreflink(&mp->m_sb))
+	    !xfs_has_reflink(mp))
 		goto bad;
 
 	/* cowextsize flag is checked w.r.t. mode separately */
@@ -259,7 +259,7 @@ xchk_dinode(
 			xchk_ino_set_corrupt(sc, ino);
 
 		if (dip->di_projid_hi != 0 &&
-		    !xfs_sb_version_hasprojid32bit(&mp->m_sb))
+		    !xfs_has_projid32(mp))
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	default:
@@ -547,7 +547,7 @@ xchk_inode_check_reflink_iflag(
 	bool			has_shared;
 	int			error;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return;
 
 	error = xfs_reflink_inode_has_shared_extents(sc->tp, sc->ip,
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 782d582d3edd..c740b932a4b8 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -165,7 +165,7 @@ xchk_quota_item(
 	 * a reflink filesystem we're allowed to exceed physical space
 	 * if there are no quota limits.
 	 */
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		if (mp->m_sb.sb_dblocks < bcount)
 			xchk_fblock_set_warning(sc, XFS_DATA_FORK,
 					offset);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 9f08dd9bf1d5..7c117582d6fd 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -258,19 +258,19 @@ xrep_calc_ag_resblks(
 	 * bnobt/cntbt or inobt/finobt as pairs.
 	 */
 	bnobt_sz = 2 * xfs_allocbt_calc_size(mp, freelen);
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+	if (xfs_has_sparseinodes(mp))
 		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
 				XFS_INODES_PER_HOLEMASK_BIT);
 	else
 		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
 				XFS_INODES_PER_CHUNK);
-	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (xfs_has_finobt(mp))
 		inobt_sz *= 2;
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		refcbt_sz = xfs_refcountbt_calc_size(mp, usedlen);
 	else
 		refcbt_sz = 0;
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (xfs_has_rmapbt(mp)) {
 		/*
 		 * Guess how many blocks we need to rebuild the rmapbt.
 		 * For non-reflink filesystems we can't have more records than
@@ -279,7 +279,7 @@ xrep_calc_ag_resblks(
 		 * many rmaps there could be in the AG, so we start off with
 		 * what we hope is an generous over-estimation.
 		 */
-		if (xfs_sb_version_hasreflink(&mp->m_sb))
+		if (xfs_has_reflink(mp))
 			rmapbt_sz = xfs_rmapbt_calc_size(mp,
 					(unsigned long long)aglen * 2);
 		else
@@ -620,7 +620,7 @@ xrep_reap_extents(
 	xfs_fsblock_t		fsbno;
 	int			error = 0;
 
-	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
+	ASSERT(xfs_has_rmapbt(sc->mp));
 
 	for_each_xfs_bitmap_block(fsbno, bmr, n, bitmap) {
 		ASSERT(sc->ip != NULL ||
@@ -730,7 +730,7 @@ xrep_findroot_block(
 	btblock = XFS_BUF_TO_BLOCK(bp);
 	if (be32_to_cpu(btblock->bb_magic) != fab->magic)
 		goto out;
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !uuid_equal(&btblock->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 		goto out;
 	bp->b_ops = fab->buf_ops;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 4bfae1e61d30..4c486e89829d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -422,7 +422,7 @@ xchk_validate_inputs(
 	 * We also don't support v1-v3 filesystems, which aren't
 	 * mountable.
 	 */
-	if (!xfs_sb_version_hasextflgbit(&mp->m_sb))
+	if (!xfs_has_extflg(mp))
 		goto out;
 
 	/*
@@ -433,7 +433,7 @@ xchk_validate_inputs(
 	 */
 	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
 		error = -EOPNOTSUPP;
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
+		if (!xfs_has_crc(mp))
 			goto out;
 
 		error = -EROFS;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index addbd74ecd8e..2647e4ef8dc5 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1143,7 +1143,7 @@ xfs_free_file_space(
 	 * boundaries, and xfs_bunmapi will handle the rest.
 	 */
 	if (XFS_IS_REALTIME_INODE(ip) &&
-	    !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
+	    !xfs_has_extflg(mp)) {
 		error = xfs_adjust_extent_unmap_boundaries(ip, &startoffset_fsb,
 				&endoffset_fsb);
 		if (error)
@@ -1452,7 +1452,7 @@ xfs_swap_extents_check_format(
 	 * If we have to use the (expensive) rmap swap method, we can
 	 * handle any number of extents and any format.
 	 */
-	if (xfs_sb_version_hasrmapbt(&ip->i_mount->m_sb))
+	if (xfs_has_rmapbt(ip->i_mount))
 		return 0;
 
 	/*
@@ -1835,7 +1835,7 @@ xfs_swap_extents(
 	 * a block reservation because it's really just a remap operation
 	 * performed with log redo items!
 	 */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (xfs_has_rmapbt(mp)) {
 		int		w	= XFS_DATA_FORK;
 		uint32_t	ipnext	= XFS_IFORK_NEXTENTS(ip, w);
 		uint32_t	tipnext	= XFS_IFORK_NEXTENTS(tip, w);
@@ -1918,7 +1918,7 @@ xfs_swap_extents(
 	src_log_flags = XFS_ILOG_CORE;
 	target_log_flags = XFS_ILOG_CORE;
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		error = xfs_swap_extent_rmap(&tp, ip, tip);
 	else
 		error = xfs_swap_extent_forks(tp, ip, tip, &src_log_flags,
@@ -1937,7 +1937,7 @@ xfs_swap_extents(
 	}
 
 	/* Swap the cow forks. */
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		ASSERT(ip->i_cformat == XFS_DINODE_FMT_EXTENTS);
 		ASSERT(tip->i_cformat == XFS_DINODE_FMT_EXTENTS);
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e839907e8492..8043c7a8c2e0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1394,7 +1394,7 @@ _xfs_buf_ioapply(
 			 * non-crc filesystems don't attach verifiers during
 			 * log recovery, so don't warn for such filesystems.
 			 */
-			if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			if (xfs_has_crc(mp)) {
 				xfs_warn(mp,
 					"%s: no buf ops on daddr 0x%llx len %d",
 					__func__, bp->b_bn, bp->b_length);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1c9d1398980b..5d8495380d2b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -330,7 +330,7 @@ xfs_buf_item_format(
 	 * occurs during recovery.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
-		if (xfs_sb_version_hascrc(&lip->li_mountp->m_sb) ||
+		if (xfs_has_crc(lip->li_mountp) ||
 		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 5142e64e2345..5b1d16b2a823 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -34,7 +34,7 @@ xfs_dir3_get_dtype(
 	struct xfs_mount	*mp,
 	uint8_t			filetype)
 {
-	if (!xfs_sb_version_hasftype(&mp->m_sb))
+	if (!xfs_has_ftype(mp))
 		return DT_UNKNOWN;
 
 	if (filetype >= XFS_DIR3_FT_MAX)
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 87e6dd5326d5..296d6cdfe7aa 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -235,7 +235,7 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
 		d->dd_diskdq.d_flags = type;
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (xfs_has_crc(mp)) {
 			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
 					 XFS_DQUOT_CRC_OFF);
@@ -1152,7 +1152,7 @@ xfs_qm_dqflush(
 	 * buffer always has a valid CRC. This ensures there is no possibility
 	 * of a dquot without an up-to-date CRC getting to disk.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		dqb->dd_lsn = cpu_to_be64(dqp->q_logitem.qli_item.li_lsn);
 		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 3d76a9e35870..a52cd4830553 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -205,7 +205,7 @@ xfs_getfsmap_is_shared(
 	int				error;
 
 	*stat = false;
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return 0;
 	/* rt files will have agno set to NULLAGNUMBER */
 	if (info->agno == NULLAGNUMBER)
@@ -837,7 +837,7 @@ xfs_getfsmap(
 		return -EINVAL;
 
 	use_rmap = capable(CAP_SYS_ADMIN) &&
-		   xfs_sb_version_hasrmapbt(&mp->m_sb);
+		   xfs_has_rmapbt(mp);
 	head->fmh_entries = 0;
 
 	/* Set up our device handlers. */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0ef5ece5634c..4f4c6cd81b54 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -608,7 +608,7 @@ xfs_ioc_space(
 	 * Only allow the sys admin to reserve space unless
 	 * unwritten extents are enabled.
 	 */
-	if (!xfs_sb_version_hasextflgbit(&ip->i_mount->m_sb) &&
+	if (!xfs_has_extflg(ip->i_mount) &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -1264,7 +1264,7 @@ xfs_ioctl_setattr_check_cowextsize(
 	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
 		return 0;
 
-	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
+	if (!xfs_has_reflink(ip->i_mount) ||
 	    ip->i_d.di_version != 3)
 		return -EINVAL;
 
@@ -1296,9 +1296,9 @@ xfs_ioctl_setattr_check_projid(
 	struct xfs_inode	*ip,
 	struct fsxattr		*fa)
 {
-	/* Disallow 32bit project ids if projid32bit feature is not enabled. */
+	/* Disallow 32bit project ids if projid32 feature is not enabled. */
 	if (fa->fsx_projid > (uint16_t)-1 &&
-	    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
+	    !xfs_has_projid32(ip->i_mount))
 		return -EINVAL;
 
 	/*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c3e74f9128e8..066a97d108f5 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -349,7 +349,7 @@ xfs_vn_unlink(
 	 * but still hashed. This is incompatible with case-insensitive
 	 * mode, so invalidate (unhash) the dentry in CI-mode.
 	 */
-	if (xfs_sb_version_hasasciici(&XFS_M(dir->i_sb)->m_sb))
+	if (xfs_has_asciici(XFS_M(dir->i_sb)))
 		d_invalidate(dentry);
 	return 0;
 }
@@ -721,7 +721,7 @@ xfs_setattr_nonsize(
 		}
 		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
-				ASSERT(xfs_sb_version_has_pquotino(&mp->m_sb) ||
+				ASSERT(xfs_has_pquotino(mp) ||
 				       !XFS_IS_PQUOTA_ON(mp));
 				ASSERT(mask & ATTR_GID);
 				ASSERT(gdqp);
@@ -1312,7 +1312,7 @@ xfs_setup_iops(
 			inode->i_mapping->a_ops = &xfs_address_space_operations;
 		break;
 	case S_IFDIR:
-		if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
+		if (xfs_has_asciici(XFS_M(inode->i_sb)))
 			inode->i_op = &xfs_dir_ci_inode_operations;
 		else
 			inode->i_op = &xfs_dir_inode_operations;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c3b610b687d1..7ad8c7bb1345 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -596,7 +596,7 @@ xfs_log_mount(
 	xfs_daddr_t	blk_offset,
 	int		num_bblks)
 {
-	bool		fatal = xfs_sb_version_hascrc(&mp->m_sb);
+	bool		fatal = xfs_has_crc(mp);
 	int		error = 0;
 	int		min_logfsbs;
 
@@ -1325,7 +1325,7 @@ xlog_get_iclog_buffer_size(
 			size >>= 1;
 		}
 
-		if (xfs_sb_version_haslogv2(&mp->m_sb)) {
+		if (xfs_has_logv2(mp)) {
 			/* # headers = size / 32k
 			 * one header holds cycles from 32k of data
 			 */
@@ -1451,7 +1451,7 @@ xlog_alloc_log(
 	xlog_grant_head_init(&log->l_write_head);
 
 	error = -EFSCORRUPTED;
-	if (xfs_sb_version_hassector(&mp->m_sb)) {
+	if (xfs_has_sector(mp)) {
 	        log2_size = mp->m_sb.sb_logsectlog;
 		if (log2_size < BBSHIFT) {
 			xfs_warn(mp, "Log sector size too small (0x%x < 0x%x)",
@@ -1468,7 +1468,7 @@ xlog_alloc_log(
 
 		/* for larger sector sizes, must have v2 or external log */
 		if (log2_size && log->l_logBBstart > 0 &&
-			    !xfs_sb_version_haslogv2(&mp->m_sb)) {
+			    !xfs_has_logv2(mp)) {
 			xfs_warn(mp,
 		"log sector size (0x%x) invalid for configuration.",
 				log2_size);
@@ -1545,7 +1545,7 @@ xlog_alloc_log(
 		memset(head, 0, sizeof(xlog_rec_header_t));
 		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
 		head->h_version = cpu_to_be32(
-			xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? 2 : 1);
+			xfs_has_logv2(log->l_mp) ? 2 : 1);
 		head->h_size = cpu_to_be32(log->l_iclog_size);
 		/* new fields */
 		head->h_fmt = cpu_to_be32(XLOG_FMT);
@@ -1707,7 +1707,7 @@ xlog_pack_data(
 		dp += BBSIZE;
 	}
 
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		xlog_in_core_2_t *xhdr = iclog->ic_data;
 
 		for ( ; i < BTOBB(size); i++) {
@@ -1744,7 +1744,7 @@ xlog_cksum(
 			      offsetof(struct xlog_rec_header, h_crc));
 
 	/* ... then for additional cycle data for v2 logs ... */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		union xlog_in_core2 *xhdr = (union xlog_in_core2 *)rhead;
 		int		i;
 		int		xheads;
@@ -1840,7 +1840,7 @@ xlog_sync(
 	int		roundoff;       /* roundoff to BB or stripe */
 	int		split = 0;	/* split write into two regions */
 	int		error;
-	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
+	int		v2 = xfs_has_logv2(log->l_mp);
 	int		size;
 
 	XFS_STATS_INC(log->l_mp, xs_log_writes);
@@ -3259,7 +3259,7 @@ xlog_state_switch_iclogs(
 	log->l_curr_block += BTOBB(eventual_size)+BTOBB(log->l_iclog_hsize);
 
 	/* Round up to next log-sunit */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
+	if (xfs_has_logv2(log->l_mp) &&
 	    log->l_mp->m_sb.sb_logsunit > 1) {
 		uint32_t sunit_bb = BTOBB(log->l_mp->m_sb.sb_logsunit);
 		log->l_curr_block = roundup(log->l_curr_block, sunit_bb);
@@ -3657,7 +3657,7 @@ xfs_log_calc_unit_res(
 	unit_bytes += log->l_iclog_hsize;
 
 	/* for roundoff padding for transaction data and one for commit record */
-	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1) {
+	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1) {
 		/* log su roundoff */
 		unit_bytes += 2 * mp->m_sb.sb_logsunit;
 	} else {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5d0438ec07dd..d57b992f6f6e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -592,7 +592,7 @@ xlog_find_verify_log_record(
 	 * reset last_blk.  Only when last_blk points in the middle of a log
 	 * record do we update last_blk.
 	 */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		uint	h_size = be32_to_cpu(head->h_size);
 
 		xhdrs = h_size / XLOG_HEADER_CYCLE_SIZE;
@@ -1287,7 +1287,7 @@ xlog_check_unmount_rec(
 	 * below. We won't want to clear the unmount record if there is one, so
 	 * we pass the lsn of the unmount record rather than the block after it.
 	 */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		int	h_size = be32_to_cpu(rhead->h_size);
 		int	h_version = be32_to_cpu(rhead->h_version);
 
@@ -1650,7 +1650,7 @@ xlog_add_record(
 	recp->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
 	recp->h_cycle = cpu_to_be32(cycle);
 	recp->h_version = cpu_to_be32(
-			xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? 2 : 1);
+			xfs_has_logv2(log->l_mp) ? 2 : 1);
 	recp->h_lsn = cpu_to_be64(xlog_assign_lsn(cycle, block));
 	recp->h_tail_lsn = cpu_to_be64(xlog_assign_lsn(tail_cycle, tail_block));
 	recp->h_fmt = cpu_to_be32(XLOG_FMT);
@@ -2169,7 +2169,7 @@ xlog_recover_do_inode_buffer(
 	 * Post recovery validation only works properly on CRC enabled
 	 * filesystems.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		bp->b_ops = &xfs_inode_buf_ops;
 
 	inodes_per_buf = BBTOB(bp->b_io_length) >> mp->m_sb.sb_inodelog;
@@ -2283,7 +2283,7 @@ xlog_recover_get_buf_lsn(
 	xfs_lsn_t		lsn = -1;
 
 	/* v4 filesystems always recover immediately */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		goto recover_immediately;
 
 	magic32 = be32_to_cpu(*(__be32 *)blk);
@@ -2350,7 +2350,7 @@ xlog_recover_get_buf_lsn(
 		 * the relevant UUID in the superblock.
 		 */
 		lsn = be64_to_cpu(((struct xfs_dsb *)blk)->sb_lsn);
-		if (xfs_sb_version_hasmetauuid(&mp->m_sb))
+		if (xfs_has_metauuid(mp))
 			uuid = &((struct xfs_dsb *)blk)->sb_meta_uuid;
 		else
 			uuid = &((struct xfs_dsb *)blk)->sb_uuid;
@@ -2439,7 +2439,7 @@ xlog_recover_validate_buf_type(
 	 * inconsistent state resulting in verification failures. Hence for now
 	 * just avoid the verification stage for non-crc filesystems
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	magic32 = be32_to_cpu(*(__be32 *)bp->b_addr);
@@ -3100,7 +3100,7 @@ xlog_recover_inode_pass2(
 	 * superblock flag to determine whether we need to look at di_flushiter
 	 * to skip replay when the on disk inode is newer than the log one
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (!xfs_has_crc(mp) &&
 	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
 		/*
 		 * Deal with the wrap case, DI_MAX_FLUSH is less
@@ -3389,7 +3389,7 @@ xlog_recover_dquot_pass2(
 	 * If the dquot has an LSN in it, recover the dquot only if it's less
 	 * than the lsn of the transaction we are replaying.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
 		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
 
@@ -3399,7 +3399,7 @@ xlog_recover_dquot_pass2(
 	}
 
 	memcpy(ddq, recddq, item->ri_buf[1].i_len);
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
@@ -5189,7 +5189,7 @@ xlog_unpack_data(
 		dp += BBSIZE;
 	}
 
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
 		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
@@ -5241,7 +5241,7 @@ xlog_recover_process(
 	 * the kernel from one that does not add CRCs by default.
 	 */
 	if (crc != old_crc) {
-		if (old_crc || xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
+		if (old_crc || xfs_has_crc(log->l_mp)) {
 			xfs_alert(log->l_mp,
 		"log record CRC mismatch: found 0x%x, expected 0x%x.",
 					le32_to_cpu(old_crc),
@@ -5253,7 +5253,7 @@ xlog_recover_process(
 		 * If the filesystem is CRC enabled, this mismatch becomes a
 		 * fatal log corruption failure.
 		 */
-		if (xfs_sb_version_hascrc(&log->l_mp->m_sb))
+		if (xfs_has_crc(log->l_mp))
 			return -EFSCORRUPTED;
 	}
 
@@ -5340,7 +5340,7 @@ xlog_do_recovery_pass(
 	 * Read the header of the tail block and get the iclog buffer size from
 	 * h_size.  Use this to tell how many sectors make up the log header.
 	 */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		/*
 		 * When using variable length iclogs, read first sector of
 		 * iclog header and extract the header size from it.  Get a
@@ -5761,7 +5761,7 @@ xlog_recover(
 	 * could not be verified. Check the superblock LSN against the current
 	 * LSN now that it's known.
 	 */
-	if (xfs_sb_version_hascrc(&log->l_mp->m_sb) &&
+	if (xfs_has_crc(log->l_mp) &&
 	    !xfs_log_check_lsn(log->l_mp, log->l_mp->m_sb.sb_lsn))
 		return -EINVAL;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fc567ca8b9d3..212ae2695b88 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -400,7 +400,7 @@ xfs_update_alignment(xfs_mount_t *mp)
 		 * Update superblock with new values
 		 * and log changes
 		 */
-		if (xfs_sb_version_hasdalign(sbp)) {
+		if (xfs_has_dalign(mp)) {
 			if (sbp->sb_unit != mp->m_dalign) {
 				sbp->sb_unit = mp->m_dalign;
 				mp->m_update_sb = true;
@@ -415,7 +415,7 @@ xfs_update_alignment(xfs_mount_t *mp)
 			return -EINVAL;
 		}
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
-		    xfs_sb_version_hasdalign(&mp->m_sb)) {
+		    xfs_has_dalign(mp)) {
 			mp->m_dalign = sbp->sb_unit;
 			mp->m_swidth = sbp->sb_width;
 	}
@@ -510,7 +510,7 @@ xfs_set_low_space_thresholds(
 STATIC void
 xfs_set_inoalignment(xfs_mount_t *mp)
 {
-	if (xfs_sb_version_hasalign(&mp->m_sb) &&
+	if (xfs_has_align(mp) &&
 		mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
 		mp->m_inoalign_mask = mp->m_sb.sb_inoalignmt - 1;
 	else
@@ -653,7 +653,7 @@ xfs_check_summary_counts(
 	 * superblock to be correct and we don't need to do anything here.
 	 * Otherwise, recalculate the summary counters.
 	 */
-	if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
+	if ((!xfs_has_lazysbcount(mp) ||
 	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
 	    !(mp->m_flags & XFS_MOUNT_BAD_SUMMARY))
 		return 0;
@@ -709,14 +709,14 @@ xfs_mountfs(
 		 * Re-check for ATTR2 in case it was found in bad_features2
 		 * slot.
 		 */
-		if (xfs_sb_version_hasattr2(&mp->m_sb) &&
+		if (xfs_has_attr2(mp) &&
 		   !(mp->m_flags & XFS_MOUNT_NOATTR2))
 			mp->m_flags |= XFS_MOUNT_ATTR2;
 	}
 
-	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
+	if (xfs_has_attr2(mp) &&
 	   (mp->m_flags & XFS_MOUNT_NOATTR2)) {
-		xfs_sb_version_removeattr2(&mp->m_sb);
+		xfs_feat_remove_attr2(mp);
 		mp->m_update_sb = true;
 
 		/* update sb_versionnum for the clearing of the morebits */
@@ -727,6 +727,7 @@ xfs_mountfs(
 	/* always use v2 inodes by default now */
 	if (!(mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
 		mp->m_sb.sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
+		mp->m_features |= XFS_FEAT_NLINK;
 		mp->m_update_sb = true;
 	}
 
@@ -792,7 +793,7 @@ xfs_mountfs(
 	 * sizes.
 	 */
 	mp->m_inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		int	new_size = mp->m_inode_cluster_size;
 
 		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
@@ -805,7 +806,7 @@ xfs_mountfs(
 	 * cluster size. Full inode chunk alignment must match the chunk size,
 	 * but that is checked on sb read verification...
 	 */
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	if (xfs_has_sparseinodes(mp) &&
 	    mp->m_sb.sb_spino_align !=
 			XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size)) {
 		xfs_warn(mp,
@@ -1225,7 +1226,7 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	 * we don't need to do this if we are updating the superblock
 	 * counters on every modification.
 	 */
-	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
+	if (!xfs_has_lazysbcount(mp))
 		return 0;
 
 	return xfs_sync_sb(mp, true);
@@ -1434,7 +1435,7 @@ void
 xfs_force_summary_recalc(
 	struct xfs_mount	*mp)
 {
-	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
+	if (!xfs_has_lazysbcount(mp))
 		return;
 
 	spin_lock(&mp->m_sb_lock);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 52ed7904df10..9ee840472138 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -751,7 +751,7 @@ xfs_qm_qino_alloc(
 	 * with PQUOTA, just use sb_gquotino for sb_pquotino and
 	 * vice-versa.
 	 */
-	if (!xfs_sb_version_has_pquotino(&mp->m_sb) &&
+	if (!xfs_has_pquotino(mp) &&
 			(flags & (XFS_QMOPT_PQUOTA|XFS_QMOPT_GQUOTA))) {
 		xfs_ino_t ino = NULLFSINO;
 
@@ -794,9 +794,9 @@ xfs_qm_qino_alloc(
 	 */
 	spin_lock(&mp->m_sb_lock);
 	if (flags & XFS_QMOPT_SBVERSION) {
-		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
+		ASSERT(!xfs_has_quota(mp));
 
-		xfs_sb_version_addquota(&mp->m_sb);
+		xfs_feat_add_quota(mp);
 		mp->m_sb.sb_uquotino = NULLFSINO;
 		mp->m_sb.sb_gquotino = NULLFSINO;
 		mp->m_sb.sb_pquotino = NULLFSINO;
@@ -877,7 +877,7 @@ xfs_qm_reset_dqcounts(
 		ddq->d_iwarns = 0;
 		ddq->d_rtbwarns = 0;
 
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (xfs_has_crc(mp)) {
 			xfs_update_cksum((char *)&dqb[j],
 					 sizeof(struct xfs_dqblk),
 					 XFS_DQUOT_CRC_OFF);
@@ -1509,7 +1509,7 @@ xfs_qm_init_quotainos(
 	/*
 	 * Get the uquota and gquota inodes
 	 */
-	if (xfs_sb_version_hasquota(&mp->m_sb)) {
+	if (xfs_has_quota(mp)) {
 		if (XFS_IS_UQUOTA_ON(mp) &&
 		    mp->m_sb.sb_uquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_uquotino > 0);
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 73a1d77ec187..97a46b176e14 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -75,7 +75,7 @@ xfs_qm_newmount(
 	uint		quotaondisk;
 	uint		uquotaondisk = 0, gquotaondisk = 0, pquotaondisk = 0;
 
-	quotaondisk = xfs_sb_version_hasquota(&mp->m_sb) &&
+	quotaondisk = xfs_has_quota(mp) &&
 				(mp->m_sb.sb_qflags & XFS_ALL_QUOTA_ACCT);
 
 	if (quotaondisk) {
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index b3190890f096..49860b1765f1 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -262,7 +262,7 @@ xfs_qm_scall_trunc_qfiles(
 {
 	int		error = -EINVAL;
 
-	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0 ||
+	if (!xfs_has_quota(mp) || flags == 0 ||
 	    (flags & ~XFS_DQ_ALLTYPES)) {
 		xfs_debug(mp, "%s: flags=%x m_qflags=%x",
 			__func__, flags, mp->m_qflags);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 38f405415b88..66ba7c4446d5 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -743,7 +743,7 @@ xfs_reflink_recover_cow(
 	xfs_agnumber_t		agno;
 	int			error = 0;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return 0;
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
@@ -953,7 +953,7 @@ xfs_reflink_ag_has_free_space(
 	struct xfs_perag	*pag;
 	int			error = 0;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 
 	pag = xfs_perag_get(mp, agno);
@@ -1218,7 +1218,7 @@ xfs_reflink_remap_range(
 	xfs_extlen_t		cowextsize;
 	ssize_t			ret;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return -EOPNOTSUPP;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 207ee302b1bb..cf76884c2a95 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -810,7 +810,7 @@ xfs_setup_devices(
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
 		unsigned int	log_sector_size = BBSIZE;
 
-		if (xfs_sb_version_hassector(&mp->m_sb))
+		if (xfs_has_sector(mp))
 			log_sector_size = mp->m_sb.sb_logsectsize;
 		error = xfs_setsize_buftarg(mp->m_logdev_targp,
 					    log_sector_size);
@@ -1438,7 +1438,7 @@ xfs_finish_flags(
 	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
 
 	/* Fail a mount where the logbuf is smaller than the log stripe */
-	if (xfs_sb_version_haslogv2(&mp->m_sb)) {
+	if (xfs_has_logv2(mp)) {
 		if (mp->m_logbsize <= 0 &&
 		    mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE) {
 			mp->m_logbsize = mp->m_sb.sb_logsunit;
@@ -1460,7 +1460,7 @@ xfs_finish_flags(
 	/*
 	 * V5 filesystems always use attr2 format for attributes.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    (mp->m_flags & XFS_MOUNT_NOATTR2)) {
 		xfs_warn(mp, "Cannot mount a V5 filesystem as noattr2. "
 			     "attr2 is always enabled for V5 filesystems.");
@@ -1471,7 +1471,7 @@ xfs_finish_flags(
 	 * mkfs'ed attr2 will turn on attr2 mount unless explicitly
 	 * told by noattr2 to turn it off
 	 */
-	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
+	if (xfs_has_attr2(mp) &&
 	    !(mp->m_flags & XFS_MOUNT_NOATTR2))
 		mp->m_flags |= XFS_MOUNT_ATTR2;
 
@@ -1486,7 +1486,7 @@ xfs_finish_flags(
 
 	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
 	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE)) &&
-	    !xfs_sb_version_has_pquotino(&mp->m_sb)) {
+	    !xfs_has_pquotino(mp)) {
 		xfs_warn(mp,
 		  "Super block does not support project and group quota together");
 		return -EINVAL;
@@ -1678,7 +1678,7 @@ xfs_fs_fill_super(
 			"DAX unsupported by block device. Turning off DAX.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
 		}
-		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		if (xfs_has_reflink(mp)) {
 			xfs_alert(mp,
 		"DAX and reflink cannot be used together!");
 			error = -EINVAL;
@@ -1696,14 +1696,14 @@ xfs_fs_fill_super(
 		}
 	}
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb) && mp->m_sb.sb_rblocks) {
+	if (xfs_has_reflink(mp) && mp->m_sb.sb_rblocks) {
 		xfs_alert(mp,
 	"reflink not compatible with realtime device!");
 		error = -EINVAL;
 		goto out_filestream_unmount;
 	}
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks) {
+	if (xfs_has_rmapbt(mp) && mp->m_sb.sb_rblocks) {
 		xfs_alert(mp,
 	"reverse mapping btree not compatible with realtime device!");
 		error = -EINVAL;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a3e98c64b6e3..647a9aa98646 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -80,7 +80,7 @@ xfs_readlink_bmap_ilocked(
 			byte_cnt = pathlen;
 
 		cur_chunk = bp->b_addr;
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (xfs_has_crc(mp)) {
 			if (!xfs_symlink_hdr_ok(ip->i_ino, offset,
 							byte_cnt, bp)) {
 				error = -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bedc5a5133a5..db4367baab34 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -342,12 +342,12 @@ xfs_trans_mod_sb(
 	switch (field) {
 	case XFS_TRANS_SB_ICOUNT:
 		tp->t_icount_delta += delta;
-		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		if (xfs_has_lazysbcount(mp))
 			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_IFREE:
 		tp->t_ifree_delta += delta;
-		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		if (xfs_has_lazysbcount(mp))
 			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_FDBLOCKS:
@@ -362,7 +362,7 @@ xfs_trans_mod_sb(
 				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		}
 		tp->t_fdblocks_delta += delta;
-		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		if (xfs_has_lazysbcount(mp))
 			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_RES_FDBLOCKS:
@@ -372,7 +372,7 @@ xfs_trans_mod_sb(
 		 * be applied to the on-disk superblock.
 		 */
 		tp->t_res_fdblocks_delta += delta;
-		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		if (xfs_has_lazysbcount(mp))
 			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_FREXTENTS:
@@ -459,7 +459,7 @@ xfs_trans_apply_sb_deltas(
 	/*
 	 * Only update the superblock counters if we are logging them
 	 */
-	if (!xfs_sb_version_haslazysbcount(&(tp->t_mountp->m_sb))) {
+	if (!xfs_has_lazysbcount((tp->t_mountp))) {
 		if (tp->t_icount_delta)
 			be64_add_cpu(&sbp->sb_icount, tp->t_icount_delta);
 		if (tp->t_ifree_delta)
@@ -600,7 +600,7 @@ xfs_trans_unreserve_and_mod_sb(
 	if (tp->t_blk_res > 0)
 		blkdelta = tp->t_blk_res;
 	if ((tp->t_fdblocks_delta != 0) &&
-	    (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
+	    (xfs_has_lazysbcount(mp) ||
 	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
 	        blkdelta += tp->t_fdblocks_delta;
 
@@ -610,7 +610,7 @@ xfs_trans_unreserve_and_mod_sb(
 	    (tp->t_flags & XFS_TRANS_SB_DIRTY))
 		rtxdelta += tp->t_frextents_delta;
 
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
+	if (xfs_has_lazysbcount(mp) ||
 	     (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
 		idelta = tp->t_icount_delta;
 		ifreedelta = tp->t_ifree_delta;
-- 
2.17.0

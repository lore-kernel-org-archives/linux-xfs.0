Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDB7C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357736AbiATATo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:19:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46250 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357734AbiATATn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:19:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CDAAB81C24
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCF4C004E1;
        Thu, 20 Jan 2022 00:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637980;
        bh=frHK+o/rVOi0tOQL6SIH8P671ALIeCY14tCf+dct5+A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oCFX351HrUaRSvzdBiiR3ull6IdgfB1s3ECmWUyM1C2BGDjFwR0UkIqiLV/77C9gN
         kZJx/361Cf9O9cfzf37GIOQ83YDrt3869tylme2HtP0RvAprJ95WtqW9cq2J0vGV/g
         kj0x/xY4eMguBcdRTfdX6TpHs18+U9SfsYDWrTpTNJOduBbtJVfHVeDuniUL6BYXGr
         NTjinxYfOUfxsQfaimUW3gFytOJvSN+L5ICOIYUEwDwAqeLw7yFsinUmpENdhd/DAM
         m247PuGHbjeW29JbI1zLC8XkmG7kMVt9r1/7LOM3WyYpWnMBjdRd4S6wkFn4PE2DNx
         tD1J6KMROWhUw==
Subject: [PATCH 25/45] xfs: replace xfs_sb_version checks with feature flag
 checks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:19:40 -0800
Message-ID: <164263798039.860211.10552021726334936470.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 38c26bfd90e1999650d5ef40f90d721f05916643

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
text       data     bss     dec     hex filenam
before  1130866  311352     484 1442702  16038e (TOTALS)
after   1127727  311352     484 1439563  15f74b (TOTALS)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c                     |    2 +-
 libxfs/xfs_ag.c             |   20 ++++++++++----------
 libxfs/xfs_alloc.c          |   34 +++++++++++++++++-----------------
 libxfs/xfs_alloc_btree.c    |    2 +-
 libxfs/xfs_alloc_btree.h    |    2 +-
 libxfs/xfs_attr_leaf.c      |   14 +++++++-------
 libxfs/xfs_attr_remote.c    |   10 +++++-----
 libxfs/xfs_bmap.c           |   12 ++++++------
 libxfs/xfs_bmap_btree.c     |    4 ++--
 libxfs/xfs_bmap_btree.h     |    2 +-
 libxfs/xfs_btree.c          |   14 +++++++-------
 libxfs/xfs_da_btree.c       |    4 ++--
 libxfs/xfs_da_format.h      |    2 +-
 libxfs/xfs_dir2_block.c     |    6 +++---
 libxfs/xfs_dir2_data.c      |    6 +++---
 libxfs/xfs_dir2_leaf.c      |    6 +++---
 libxfs/xfs_dir2_node.c      |   10 +++++-----
 libxfs/xfs_dir2_sf.c        |    2 +-
 libxfs/xfs_dquot_buf.c      |    6 +++---
 libxfs/xfs_format.h         |   10 +++++-----
 libxfs/xfs_ialloc.c         |   14 +++++++-------
 libxfs/xfs_ialloc_btree.c   |    6 +++---
 libxfs/xfs_ialloc_btree.h   |    2 +-
 libxfs/xfs_inode_buf.c      |    6 +++---
 libxfs/xfs_log_format.h     |    4 ++--
 libxfs/xfs_log_rlimit.c     |    2 +-
 libxfs/xfs_refcount_btree.c |    4 ++--
 libxfs/xfs_rmap.c           |    6 +++---
 libxfs/xfs_rmap_btree.c     |    6 +++---
 libxfs/xfs_sb.c             |   12 ++++++------
 libxfs/xfs_symlink_remote.c |   10 +++++-----
 libxfs/xfs_trans_resv.c     |   12 ++++++------
 libxfs/xfs_types.c          |    2 +-
 repair/agheader.c           |    2 +-
 34 files changed, 128 insertions(+), 128 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index 7909acae..94001943 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -682,7 +682,7 @@ version_string(
 		strcat(s, ",ATTR2");
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
 		strcat(s, ",LAZYSBCOUNT");
-	if (xfs_sb_version_hasprojid32bit(&mp->m_sb))
+	if (xfs_sb_version_hasprojid32(&mp->m_sb))
 		strcat(s, ",PROJID32BIT");
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		strcat(s, ",CRC");
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index da950e10..4fc54605 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -469,7 +469,7 @@ xfs_rmaproot_init(
 	rrec->rm_offset = 0;
 
 	/* account for refc btree root */
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		rrec = XFS_RMAP_REC_ADDR(block, 5);
 		rrec->rm_startblock = cpu_to_be32(xfs_refc_block(mp));
 		rrec->rm_blockcount = cpu_to_be32(1);
@@ -528,7 +528,7 @@ xfs_agfblock_init(
 	agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
 	agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
 	agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (xfs_has_rmapbt(mp)) {
 		agf->agf_roots[XFS_BTNUM_RMAPi] =
 					cpu_to_be32(XFS_RMAP_BLOCK(mp));
 		agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
@@ -541,9 +541,9 @@ xfs_agfblock_init(
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
@@ -569,7 +569,7 @@ xfs_agflblock_init(
 	__be32			*agfl_bno;
 	int			bucket;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 		agfl->agfl_seqno = cpu_to_be32(id->agno);
 		uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
@@ -599,9 +599,9 @@ xfs_agiblock_init(
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
@@ -719,14 +719,14 @@ xfs_ag_init_headers(
 		.ops = &xfs_finobt_buf_ops,
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
@@ -734,7 +734,7 @@ xfs_ag_init_headers(
 		.ops = &xfs_refcountbt_buf_ops,
 		.work = &xfs_btroot_init,
 		.type = XFS_BTNUM_REFC,
-		.need_init = xfs_sb_version_hasreflink(&mp->m_sb)
+		.need_init = xfs_has_reflink(mp)
 	},
 	{ /* NULL terminating block */
 		.daddr = XFS_BUF_DADDR_NULL,
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index a7c3b079..b8725339 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -47,7 +47,7 @@ xfs_agfl_size(
 {
 	unsigned int		size = mp->m_sb.sb_sectsize;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		size -= sizeof(struct xfs_agfl);
 
 	return size / sizeof(xfs_agblock_t);
@@ -57,9 +57,9 @@ unsigned int
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
@@ -68,11 +68,11 @@ xfs_extlen_t
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
@@ -122,11 +122,11 @@ xfs_alloc_ag_max_usable(
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
@@ -594,7 +594,7 @@ xfs_agfl_verify(
 	 * AGFL is what the AGF says is active. We can't get to the AGF, so we
 	 * can't verify just those entries are valid.
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return NULL;
 
 	if (!xfs_verify_magic(bp, agfl->agfl_magicnum))
@@ -634,7 +634,7 @@ xfs_agfl_read_verify(
 	 * AGFL is what the AGF says is active. We can't get to the AGF, so we
 	 * can't verify just those entries are valid.
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
@@ -655,7 +655,7 @@ xfs_agfl_write_verify(
 	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc AGFLs */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	fa = xfs_agfl_verify(bp);
@@ -2369,7 +2369,7 @@ xfs_agfl_needs_reset(
 	int			active;
 
 	/* no agfl header on v4 supers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return false;
 
 	/*
@@ -2873,7 +2873,7 @@ xfs_agf_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_agf		*agf = bp->b_addr;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(agf->agf_lsn)))
@@ -2903,7 +2903,7 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > mp->m_ag_maxlevels)
 		return __this_address;
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	if (xfs_has_rmapbt(mp) &&
 	    (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
 	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > mp->m_rmap_maxlevels))
 		return __this_address;
@@ -2946,7 +2946,7 @@ xfs_agf_read_verify(
 	struct xfs_mount *mp = bp->b_mount;
 	xfs_failaddr_t	fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -2971,7 +2971,7 @@ xfs_agf_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 34a514c6..a8a24fa4 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -496,7 +496,7 @@ xfs_allocbt_init_common(
 	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	return cur;
diff --git a/libxfs/xfs_alloc_btree.h b/libxfs/xfs_alloc_btree.h
index 9eb4c667..2f6b816a 100644
--- a/libxfs/xfs_alloc_btree.h
+++ b/libxfs/xfs_alloc_btree.h
@@ -20,7 +20,7 @@ struct xbtree_afakeroot;
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_ALLOC_BLOCK_LEN(mp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+	(xfs_has_crc(((mp))) ? \
 		XFS_BTREE_SBLOCK_CRC_LEN : XFS_BTREE_SBLOCK_LEN)
 
 /*
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 6499f16f..3fff838e 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -381,7 +381,7 @@ xfs_attr3_leaf_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -403,7 +403,7 @@ xfs_attr3_leaf_read_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -624,10 +624,10 @@ STATIC void
 xfs_sbversion_add_attr2(xfs_mount_t *mp, xfs_trans_t *tp)
 {
 	if ((mp->m_flags & XFS_MOUNT_ATTR2) &&
-	    !(xfs_sb_version_hasattr2(&mp->m_sb))) {
+	    !(xfs_has_attr2(mp))) {
 		spin_lock(&mp->m_sb_lock);
-		if (!xfs_sb_version_hasattr2(&mp->m_sb)) {
-			xfs_sb_version_addattr2(&mp->m_sb);
+		if (!xfs_has_attr2(mp)) {
+			xfs_add_attr2(mp);
 			spin_unlock(&mp->m_sb_lock);
 			xfs_log_sb(tp);
 		} else
@@ -1196,7 +1196,7 @@ xfs_attr3_leaf_to_node(
 	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLFT_ATTR_LEAF_BUF);
 	bp2->b_ops = bp1->b_ops;
 	memcpy(bp2->b_addr, bp1->b_addr, args->geo->blksize);
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_blkinfo *hdr3 = bp2->b_addr;
 		hdr3->blkno = cpu_to_be64(bp2->b_bn);
 	}
@@ -1261,7 +1261,7 @@ xfs_attr3_leaf_create(
 	memset(&ichdr, 0, sizeof(ichdr));
 	ichdr.firstused = args->geo->blksize;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_blkinfo *hdr3 = bp->b_addr;
 
 		ichdr.magic = XFS_ATTR3_LEAF_MAGIC;
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index b781e44d..73eb256e 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -50,7 +50,7 @@ xfs_attr3_rmt_blocks(
 	struct xfs_mount *mp,
 	int		attrlen)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		int buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
 		return (attrlen + buflen - 1) / buflen;
 	}
@@ -125,7 +125,7 @@ __xfs_attr3_rmt_read_verify(
 	int		blksize = mp->m_attr_geo->blksize;
 
 	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return 0;
 
 	ptr = bp->b_addr;
@@ -190,7 +190,7 @@ xfs_attr3_rmt_write_verify(
 	xfs_daddr_t	bno;
 
 	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	ptr = bp->b_addr;
@@ -245,7 +245,7 @@ xfs_attr3_rmt_hdr_set(
 {
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return 0;
 
 	rmt->rm_magic = cpu_to_be32(XFS_ATTR3_RMT_MAGIC);
@@ -295,7 +295,7 @@ xfs_attr_rmtval_copyout(
 
 		byte_cnt = min(*valuelen, byte_cnt);
 
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (xfs_has_crc(mp)) {
 			if (xfs_attr3_rmt_hdr_ok(src, ino, *offset,
 						  byte_cnt, bno)) {
 				xfs_alert(mp,
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index a548507c..db9e8566 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1108,17 +1108,17 @@ xfs_bmap_add_attrfork(
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
+			xfs_add_attr(mp);
 			log_sb = true;
 		}
-		if (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2) {
-			xfs_sb_version_addattr2(&mp->m_sb);
+		if (!xfs_has_attr2(mp) && version == 2) {
+			xfs_add_attr2(mp);
 			log_sb = true;
 		}
 		spin_unlock(&mp->m_sb_lock);
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 0552157a..f5f228bc 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -134,7 +134,7 @@ xfs_bmbt_to_bmdr(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		ASSERT(rblock->bb_magic == cpu_to_be32(XFS_BMAP_CRC_MAGIC));
 		ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid,
 		       &mp->m_sb.sb_meta_uuid));
@@ -561,7 +561,7 @@ xfs_bmbt_init_cursor(
 
 	cur->bc_ops = &xfs_bmbt_ops;
 	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_ino.forksize = XFS_IFORK_SIZE(ip, whichfork);
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index eda85512..729e3bc5 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -16,7 +16,7 @@ struct xfs_trans;
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_BMBT_BLOCK_LEN(mp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+	(xfs_has_crc(((mp))) ? \
 		XFS_BTREE_LBLOCK_CRC_LEN : XFS_BTREE_LBLOCK_LEN)
 
 #define XFS_BMBT_REC_ADDR(mp, block, index) \
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 1cf3d813..817d6123 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -61,7 +61,7 @@ __xfs_btree_check_lblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
-	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
+	int			crc = xfs_has_crc(mp);
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -126,7 +126,7 @@ __xfs_btree_check_sblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
-	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
+	int			crc = xfs_has_crc(mp);
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -284,7 +284,7 @@ xfs_btree_lblock_verify_crc(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_mount	*mp = bp->b_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn)))
 			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
@@ -322,7 +322,7 @@ xfs_btree_sblock_verify_crc(
 	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_mount	*mp = bp->b_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
 			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
@@ -1087,7 +1087,7 @@ xfs_btree_init_block_int(
 	__u64			owner,
 	unsigned int		flags)
 {
-	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
+	int			crc = xfs_has_crc(mp);
 	__u32			magic = xfs_btree_magic(crc, btnum);
 
 	buf->bb_magic = cpu_to_be32(magic);
@@ -4419,7 +4419,7 @@ xfs_btree_lblock_v5hdr_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return __this_address;
 	if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
@@ -4469,7 +4469,7 @@ xfs_btree_sblock_v5hdr_verify(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return __this_address;
 	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index f4e1fe80..196f0a9e 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -250,7 +250,7 @@ xfs_da3_node_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -439,7 +439,7 @@ xfs_da3_node_create(
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
 	node = bp->b_addr;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
 		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index b876b44c..5a49caa5 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -789,7 +789,7 @@ struct xfs_attr3_rmt_hdr {
 #define XFS_ATTR3_RMT_CRC_OFF	offsetof(struct xfs_attr3_rmt_hdr, rm_crc)
 
 #define XFS_ATTR3_RMT_BUF_SPACE(mp, bufsize)	\
-	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
+	((bufsize) - (xfs_has_crc((mp)) ? \
 			sizeof(struct xfs_attr3_rmt_hdr) : 0))
 
 /* Number of bytes in a directory block. */
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 522f0ffc..4373e819 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -68,7 +68,7 @@ xfs_dir3_block_read_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -93,7 +93,7 @@ xfs_dir3_block_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -168,7 +168,7 @@ xfs_dir3_block_init(
 	bp->b_ops = &xfs_dir3_block_buf_ops;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_BLOCK_BUF);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		memset(hdr3, 0, sizeof(*hdr3));
 		hdr3->magic = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
 		hdr3->blkno = cpu_to_be64(bp->b_bn);
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index d1dbf73a..76f55736 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -340,7 +340,7 @@ xfs_dir3_data_read_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -365,7 +365,7 @@ xfs_dir3_data_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -714,7 +714,7 @@ xfs_dir3_data_init(
 	 * Initialize the header.
 	 */
 	hdr = bp->b_addr;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
 		memset(hdr3, 0, sizeof(*hdr3));
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index e25ee46e..cd63b37e 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -207,7 +207,7 @@ xfs_dir3_leaf_read_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -232,7 +232,7 @@ xfs_dir3_leaf_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -306,7 +306,7 @@ xfs_dir3_leaf_init(
 
 	ASSERT(type == XFS_DIR2_LEAF1_MAGIC || type == XFS_DIR2_LEAFN_MAGIC);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
 
 		memset(leaf3, 0, sizeof(*leaf3));
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 3c2653e9..2bccabaf 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -102,7 +102,7 @@ xfs_dir3_free_verify(
 	if (!xfs_verify_magic(bp, hdr->magic))
 		return __this_address;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
@@ -125,7 +125,7 @@ xfs_dir3_free_read_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -150,7 +150,7 @@ xfs_dir3_free_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -182,7 +182,7 @@ xfs_dir3_free_header_check(
 	firstdb = (xfs_dir2_da_to_db(mp->m_dir_geo, fbno) -
 		   xfs_dir2_byte_to_db(mp->m_dir_geo, XFS_DIR2_FREE_OFFSET)) *
 			maxbests;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_free_hdr *hdr3 = bp->b_addr;
 
 		if (be32_to_cpu(hdr3->firstdb) != firstdb)
@@ -338,7 +338,7 @@ xfs_dir3_free_get_buf(
 	memset(bp->b_addr, 0, sizeof(struct xfs_dir3_free_hdr));
 	memset(&hdr, 0, sizeof(hdr));
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_free_hdr *hdr3 = bp->b_addr;
 
 		hdr.magic = XFS_DIR3_FREE_MAGIC;
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index c1cc2e71..6a57ad27 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -192,7 +192,7 @@ xfs_dir2_block_sfsize(
 	 * if there is a filetype field, add the extra byte to the namelen
 	 * for each entry that we see.
 	 */
-	has_ftype = xfs_sb_version_hasftype(&mp->m_sb) ? 1 : 0;
+	has_ftype = xfs_has_ftype(mp) ? 1 : 0;
 
 	count = i8count = namelen = 0;
 	btp = xfs_dir2_block_tail_p(geo, hdr);
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 0a5a237d..b77f303c 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -104,7 +104,7 @@ xfs_dqblk_verify(
 	struct xfs_dqblk	*dqb,
 	xfs_dqid_t		id)	/* used only during quotacheck */
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
 
@@ -132,7 +132,7 @@ xfs_dqblk_repair(
 	dqb->dd_diskdq.d_type = type;
 	dqb->dd_diskdq.d_id = cpu_to_be32(id);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		uuid_copy(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid);
 		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
@@ -149,7 +149,7 @@ xfs_dquot_buf_verify_crc(
 	int			ndquots;
 	int			i;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return true;
 
 	/*
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index fdd35202..d4690f28 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -398,7 +398,7 @@ static inline void xfs_sb_version_addattr2(struct xfs_sb *sbp)
 	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
 }
 
-static inline bool xfs_sb_version_hasprojid32bit(struct xfs_sb *sbp)
+static inline bool xfs_sb_version_hasprojid32(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
 	       (xfs_sb_version_hasmorebits(sbp) &&
@@ -528,7 +528,7 @@ static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
 	return version == 1 || version == 2;
 }
 
-static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
+static inline bool xfs_sb_version_haspquotino(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
@@ -1462,7 +1462,7 @@ struct xfs_dsymlink_hdr {
 #define XFS_SYMLINK_MAPS 3
 
 #define XFS_SYMLINK_BUF_SPACE(mp, bufsize)	\
-	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
+	((bufsize) - (xfs_has_crc((mp)) ? \
 			sizeof(struct xfs_dsymlink_hdr) : 0))
 
 
@@ -1694,7 +1694,7 @@ struct xfs_rmap_key {
 typedef __be32 xfs_rmap_ptr_t;
 
 #define	XFS_RMAP_BLOCK(mp) \
-	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
+	(xfs_has_finobt(((mp))) ? \
 	 XFS_FIBT_BLOCK(mp) + 1 : \
 	 XFS_IBT_BLOCK(mp) + 1)
 
@@ -1926,7 +1926,7 @@ struct xfs_acl {
  * limited only by the maximum size of the xattr that stores the information.
  */
 #define XFS_ACL_MAX_ENTRIES(mp)	\
-	(xfs_sb_version_hascrc(&mp->m_sb) \
+	(xfs_has_crc(mp) \
 		?  (XFS_XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
 						sizeof(struct xfs_acl_entry) \
 		: 25)
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index c1f3d28a..567f9996 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -53,7 +53,7 @@ xfs_inobt_update(
 	union xfs_btree_rec	rec;
 
 	rec.inobt.ir_startino = cpu_to_be32(irec->ir_startino);
-	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+	if (xfs_has_sparseinodes(cur->bc_mp)) {
 		rec.inobt.ir_u.sp.ir_holemask = cpu_to_be16(irec->ir_holemask);
 		rec.inobt.ir_u.sp.ir_count = irec->ir_count;
 		rec.inobt.ir_u.sp.ir_freecount = irec->ir_freecount;
@@ -73,7 +73,7 @@ xfs_inobt_btrec_to_irec(
 	struct xfs_inobt_rec_incore	*irec)
 {
 	irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb)) {
+	if (xfs_has_sparseinodes(mp)) {
 		irec->ir_holemask = be16_to_cpu(rec->inobt.ir_u.sp.ir_holemask);
 		irec->ir_count = rec->inobt.ir_u.sp.ir_count;
 		irec->ir_freecount = rec->inobt.ir_u.sp.ir_freecount;
@@ -2473,7 +2473,7 @@ xfs_agi_verify(
 	struct xfs_agi	*agi = bp->b_addr;
 	int		i;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(agi->agi_lsn)))
@@ -2492,7 +2492,7 @@ xfs_agi_verify(
 	    be32_to_cpu(agi->agi_level) > M_IGEO(mp)->inobt_maxlevels)
 		return __this_address;
 
-	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	if (xfs_has_finobt(mp) &&
 	    (be32_to_cpu(agi->agi_free_level) < 1 ||
 	     be32_to_cpu(agi->agi_free_level) > M_IGEO(mp)->inobt_maxlevels))
 		return __this_address;
@@ -2523,7 +2523,7 @@ xfs_agi_read_verify(
 	struct xfs_mount *mp = bp->b_mount;
 	xfs_failaddr_t	fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -2548,7 +2548,7 @@ xfs_agi_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -2948,7 +2948,7 @@ xfs_ialloc_check_shrink(
 	int			has;
 	int			error;
 
-	if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
+	if (!xfs_has_sparseinodes(mp))
 		return 0;
 
 	pag = xfs_perag_get(mp, agno);
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 5053c4a5..5fb96203 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -211,7 +211,7 @@ xfs_inobt_init_rec_from_cur(
 	union xfs_btree_rec	*rec)
 {
 	rec->inobt.ir_startino = cpu_to_be32(cur->bc_rec.i.ir_startino);
-	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+	if (xfs_has_sparseinodes(cur->bc_mp)) {
 		rec->inobt.ir_u.sp.ir_holemask =
 					cpu_to_be16(cur->bc_rec.i.ir_holemask);
 		rec->inobt.ir_u.sp.ir_count = cur->bc_rec.i.ir_count;
@@ -445,7 +445,7 @@ xfs_inobt_init_common(
 
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	/* take a reference for the cursor */
@@ -736,7 +736,7 @@ xfs_finobt_calc_reserves(
 	xfs_extlen_t		tree_len = 0;
 	int			error;
 
-	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (!xfs_has_finobt(mp))
 		return 0;
 
 	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index e530c82b..8a322d40 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -19,7 +19,7 @@ struct xfs_perag;
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_INOBT_BLOCK_LEN(mp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+	(xfs_has_crc(((mp))) ? \
 		XFS_BTREE_SBLOCK_CRC_LEN : XFS_BTREE_SBLOCK_LEN)
 
 /*
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index f98f5c47..946261cd 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -512,7 +512,7 @@ xfs_dinode_verify(
 
 	/* don't allow reflink/cowextsize if we don't have reflink */
 	if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
-	     !xfs_sb_version_hasreflink(&mp->m_sb))
+	     !xfs_has_reflink(mp))
 		return __this_address;
 
 	/* only regular files get reflink */
@@ -547,7 +547,7 @@ xfs_dinode_calc_crc(
 	if (dip->di_version < 3)
 		return;
 
-	ASSERT(xfs_sb_version_hascrc(&mp->m_sb));
+	ASSERT(xfs_has_crc(mp));
 	crc = xfs_start_cksum_update((char *)dip, mp->m_sb.sb_inodesize,
 			      XFS_DINODE_CRC_OFF);
 	dip->di_crc = xfs_end_cksum(crc);
@@ -674,7 +674,7 @@ xfs_inode_validate_cowextsize(
 	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
 	cowextsize_bytes = XFS_FSB_TO_B(mp, cowextsize);
 
-	if (hint_flag && !xfs_sb_version_hasreflink(&mp->m_sb))
+	if (hint_flag && !xfs_has_reflink(mp))
 		return __this_address;
 
 	if (hint_flag && !(S_ISDIR(mode) || S_ISREG(mode)))
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 2c5bcbc1..28c02047 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -41,10 +41,10 @@ typedef uint32_t xlog_tid_t;
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
diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index c8398b7d..116178fd 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
@@ -92,7 +92,7 @@ xfs_log_calc_minimum_size(
 	if (tres.tr_logcount > 1)
 		max_logres *= tres.tr_logcount;
 
-	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1)
+	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
 		lsunit = BTOBB(mp->m_sb.sb_logsunit);
 
 	/*
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 7a5a1a8d..ded0ebe1 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -208,7 +208,7 @@ xfs_refcountbt_verify(
 	if (!xfs_verify_magic(bp, block->bb_magic))
 		return __this_address;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return __this_address;
 	fa = xfs_btree_sblock_v5hdr_verify(bp);
 	if (fa)
@@ -461,7 +461,7 @@ xfs_refcountbt_calc_reserves(
 	xfs_extlen_t		tree_len;
 	int			error;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return 0;
 
 	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index ed7db353..e93010ff 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -704,7 +704,7 @@ xfs_rmap_free(
 	struct xfs_btree_cur		*cur;
 	int				error;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
@@ -958,7 +958,7 @@ xfs_rmap_alloc(
 	struct xfs_btree_cur		*cur;
 	int				error;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
@@ -2458,7 +2458,7 @@ xfs_rmap_update_is_needed(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	return xfs_sb_version_hasrmapbt(&mp->m_sb) && whichfork != XFS_COW_FORK;
+	return xfs_has_rmapbt(mp) && whichfork != XFS_COW_FORK;
 }
 
 /*
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 7a441f64..05d962d8 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -302,7 +302,7 @@ xfs_rmapbt_verify(
 	if (!xfs_verify_magic(bp, block->bb_magic))
 		return __this_address;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return __this_address;
 	fa = xfs_btree_sblock_v5hdr_verify(bp);
 	if (fa)
@@ -556,7 +556,7 @@ xfs_rmapbt_compute_maxlevels(
 	 * disallow reflinking when less than 10% of the per-AG metadata
 	 * block reservation since the fallback is a regular file copy.
 	 */
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		mp->m_rmap_maxlevels = XFS_BTREE_MAXLEVELS;
 	else
 		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(
@@ -604,7 +604,7 @@ xfs_rmapbt_calc_reserves(
 	xfs_extlen_t		tree_len;
 	int			error;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 
 	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 100dd87d..25a4ffdb 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -237,7 +237,7 @@ xfs_validate_sb_common(
 		return -EWRONGFS;
 	}
 
-	if (xfs_sb_version_has_pquotino(sbp)) {
+	if (xfs_sb_version_haspquotino(sbp)) {
 		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
 			xfs_notice(mp,
 			   "Version 5 of Super block has XFS_OQUOTA bits.");
@@ -376,7 +376,7 @@ xfs_validate_sb_common(
 			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
 		return -EFSCORRUPTED;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_sb_version_hascrc(sbp) &&
 	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
 		xfs_notice(mp, "v5 SB sanity check failed");
 		return -EFSCORRUPTED;
@@ -425,7 +425,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 	 * We need to do these manipilations only if we are working
 	 * with an older version of on-disk superblock.
 	 */
-	if (xfs_sb_version_has_pquotino(sbp))
+	if (xfs_sb_version_haspquotino(sbp))
 		return;
 
 	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
@@ -543,7 +543,7 @@ xfs_sb_quota_to_disk(
 	uint16_t	qflags = from->sb_qflags;
 
 	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
-	if (xfs_sb_version_has_pquotino(from)) {
+	if (xfs_sb_version_haspquotino(from)) {
 		to->sb_qflags = cpu_to_be16(from->sb_qflags);
 		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
 		to->sb_pquotino = cpu_to_be64(from->sb_pquotino);
@@ -768,7 +768,7 @@ xfs_sb_write_verify(
 	if (error)
 		goto out_error;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_sb_version_hascrc(&sb))
 		return;
 
 	if (bip)
@@ -1064,7 +1064,7 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LAZYSB;
 	if (xfs_sb_version_hasattr2(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR2;
-	if (xfs_sb_version_hasprojid32bit(sbp))
+	if (xfs_sb_version_hasprojid32(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_PROJID32;
 	if (xfs_sb_version_hascrc(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_V5SB;
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 8eb3d59f..e0a68319 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -39,7 +39,7 @@ xfs_symlink_hdr_set(
 {
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return 0;
 
 	memset(dsl, 0, sizeof(struct xfs_dsymlink_hdr));
@@ -86,7 +86,7 @@ xfs_symlink_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return __this_address;
 	if (!xfs_verify_magic(bp, dsl->sl_magic))
 		return __this_address;
@@ -113,7 +113,7 @@ xfs_symlink_read_verify(
 	xfs_failaddr_t	fa;
 
 	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF))
@@ -134,7 +134,7 @@ xfs_symlink_write_verify(
 	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	fa = xfs_symlink_verify(bp);
@@ -170,7 +170,7 @@ xfs_symlink_local_to_remote(
 
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SYMLINK_BUF);
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (!xfs_has_crc(mp)) {
 		bp->b_ops = NULL;
 		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
 		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index fa5edb87..ea57e810 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -70,9 +70,9 @@ xfs_allocfree_log_count(
 	uint		blocks;
 
 	blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
 
 	return blocks;
@@ -154,7 +154,7 @@ STATIC uint
 xfs_calc_finobt_res(
 	struct xfs_mount	*mp)
 {
-	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (!xfs_has_finobt(mp))
 		return 0;
 
 	return xfs_calc_inobt_res(mp);
@@ -818,14 +818,14 @@ xfs_trans_resv_calc(
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
@@ -886,7 +886,7 @@ xfs_trans_resv_calc(
 	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
 	else
 		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index 93dd10fb..c4cc5ce5 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -169,7 +169,7 @@ xfs_internal_inum(
 	xfs_ino_t		ino)
 {
 	return ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
-		(xfs_sb_version_hasquota(&mp->m_sb) &&
+		(xfs_has_quota(mp) &&
 		 xfs_is_quota_inode(&mp->m_sb, ino));
 }
 
diff --git a/repair/agheader.c b/repair/agheader.c
index 2af24106..fc62c03a 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -376,7 +376,7 @@ secondary_sb_whack(
 	 * superblocks. If it is anything other than 0 it is considered garbage
 	 * data beyond the valid sb and explicitly zeroed above.
 	 */
-	if (xfs_sb_version_has_pquotino(&mp->m_sb) &&
+	if (xfs_sb_version_haspquotino(&mp->m_sb) &&
 	    sb->sb_inprogress == 1 && sb->sb_pquotino != NULLFSINO)  {
 		if (!no_modify) {
 			sb->sb_pquotino = 0;


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA8AC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 23:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9593C61051
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 23:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbhHSAAT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 20:00:19 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:33054 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235392AbhHSAAS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 20:00:18 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 08C7E1142FC6
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 09:59:40 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGVT8-002JPc-E6
        for linux-xfs@vger.kernel.org; Thu, 19 Aug 2021 09:59:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mGVT8-000cwF-3Y
        for linux-xfs@vger.kernel.org; Thu, 19 Aug 2021 09:59:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/16] xfs: replace xfs_sb_version checks with feature flag checks
Date:   Thu, 19 Aug 2021 09:59:24 +1000
Message-Id: <20210818235935.149431-6-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818235935.149431-1-david@fromorbit.com>
References: <20210818235935.149431-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=IgiNuIJcbZpfP7CVQhwA:9 a=Cl-aT4JgoK5GLTt1:21 a=6Ub0EjLIX964Auyz:21
        a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
before	1130866  311352     484 1442702  16038e (TOTALS)
after	1127727  311352     484 1439563  15f74b (TOTALS)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c             | 20 +++++++++---------
 fs/xfs/libxfs/xfs_alloc.c          | 34 +++++++++++++++---------------
 fs/xfs/libxfs/xfs_alloc_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_alloc_btree.h    |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      | 14 ++++++------
 fs/xfs/libxfs/xfs_attr_remote.c    | 10 ++++-----
 fs/xfs/libxfs/xfs_bmap.c           | 12 +++++------
 fs/xfs/libxfs/xfs_bmap_btree.c     |  4 ++--
 fs/xfs/libxfs/xfs_bmap_btree.h     |  2 +-
 fs/xfs/libxfs/xfs_btree.c          | 14 ++++++------
 fs/xfs/libxfs/xfs_da_btree.c       |  4 ++--
 fs/xfs/libxfs/xfs_da_format.h      |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |  6 +++---
 fs/xfs/libxfs/xfs_dir2_data.c      |  6 +++---
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  6 +++---
 fs/xfs/libxfs/xfs_dir2_node.c      | 10 ++++-----
 fs/xfs/libxfs/xfs_dir2_sf.c        |  2 +-
 fs/xfs/libxfs/xfs_dquot_buf.c      |  6 +++---
 fs/xfs/libxfs/xfs_format.h         | 10 ++++-----
 fs/xfs/libxfs/xfs_ialloc.c         | 14 ++++++------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  6 +++---
 fs/xfs/libxfs/xfs_ialloc_btree.h   |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |  6 +++---
 fs/xfs/libxfs/xfs_log_format.h     |  4 ++--
 fs/xfs/libxfs/xfs_log_rlimit.c     |  2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  4 ++--
 fs/xfs/libxfs/xfs_rmap.c           |  6 +++---
 fs/xfs/libxfs/xfs_rmap_btree.c     |  6 +++---
 fs/xfs/libxfs/xfs_sb.c             | 12 +++++------
 fs/xfs/libxfs/xfs_symlink_remote.c | 10 ++++-----
 fs/xfs/libxfs/xfs_trans_resv.c     | 12 +++++------
 fs/xfs/libxfs/xfs_types.c          |  2 +-
 fs/xfs/scrub/agheader.c            | 12 +++++------
 fs/xfs/scrub/agheader_repair.c     | 20 +++++++++---------
 fs/xfs/scrub/attr.c                |  2 +-
 fs/xfs/scrub/bmap.c                |  4 ++--
 fs/xfs/scrub/common.c              |  2 +-
 fs/xfs/scrub/dabtree.c             |  4 ++--
 fs/xfs/scrub/dir.c                 | 10 ++++-----
 fs/xfs/scrub/ialloc.c              |  2 +-
 fs/xfs/scrub/inode.c               |  6 +++---
 fs/xfs/scrub/repair.c              | 12 +++++------
 fs/xfs/scrub/scrub.c               |  2 +-
 fs/xfs/xfs_bmap_util.c             | 14 ++++++------
 fs/xfs/xfs_buf.c                   |  6 +++---
 fs/xfs/xfs_buf_item.c              |  2 +-
 fs/xfs/xfs_buf_item_recover.c      |  8 +++----
 fs/xfs/xfs_dir2_readdir.c          |  2 +-
 fs/xfs/xfs_dquot.c                 | 10 ++++-----
 fs/xfs/xfs_dquot_item_recover.c    |  4 ++--
 fs/xfs/xfs_file.c                  |  2 +-
 fs/xfs/xfs_fsmap.c                 |  4 ++--
 fs/xfs/xfs_fsops.c                 |  2 +-
 fs/xfs/xfs_icache.c                |  2 +-
 fs/xfs/xfs_inode.c                 | 10 ++++-----
 fs/xfs/xfs_inode_item.c            |  2 +-
 fs/xfs/xfs_inode_item_recover.c    |  2 +-
 fs/xfs/xfs_ioctl.c                 |  8 +++----
 fs/xfs/xfs_iops.c                  |  8 +++----
 fs/xfs/xfs_itable.c                |  2 +-
 fs/xfs/xfs_log.c                   | 18 ++++++++--------
 fs/xfs/xfs_log_recover.c           | 14 ++++++------
 fs/xfs/xfs_mount.c                 | 13 ++++++------
 fs/xfs/xfs_mount.h                 |  6 +++---
 fs/xfs/xfs_qm.c                    | 14 ++++++------
 fs/xfs/xfs_qm_bhv.c                |  2 +-
 fs/xfs/xfs_qm_syscalls.c           |  2 +-
 fs/xfs/xfs_refcount_item.c         |  2 +-
 fs/xfs/xfs_reflink.c               |  4 ++--
 fs/xfs/xfs_rmap_item.c             |  2 +-
 fs/xfs/xfs_rtalloc.c               |  3 +--
 fs/xfs/xfs_super.c                 | 18 ++++++++--------
 fs/xfs/xfs_symlink.c               |  2 +-
 fs/xfs/xfs_trans.c                 | 16 +++++++-------
 fs/xfs/xfs_trans_dquot.c           |  2 +-
 75 files changed, 267 insertions(+), 267 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index ee9ec0c50bec..6e391bdc4d6d 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
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
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6929157d8d6e..5f943a804d9e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -51,7 +51,7 @@ xfs_agfl_size(
 {
 	unsigned int		size = mp->m_sb.sb_sectsize;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		size -= sizeof(struct xfs_agfl);
 
 	return size / sizeof(xfs_agblock_t);
@@ -61,9 +61,9 @@ unsigned int
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
@@ -72,11 +72,11 @@ xfs_extlen_t
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
@@ -126,11 +126,11 @@ xfs_alloc_ag_max_usable(
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
@@ -598,7 +598,7 @@ xfs_agfl_verify(
 	 * AGFL is what the AGF says is active. We can't get to the AGF, so we
 	 * can't verify just those entries are valid.
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return NULL;
 
 	if (!xfs_verify_magic(bp, agfl->agfl_magicnum))
@@ -638,7 +638,7 @@ xfs_agfl_read_verify(
 	 * AGFL is what the AGF says is active. We can't get to the AGF, so we
 	 * can't verify just those entries are valid.
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
@@ -659,7 +659,7 @@ xfs_agfl_write_verify(
 	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc AGFLs */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	fa = xfs_agfl_verify(bp);
@@ -2373,7 +2373,7 @@ xfs_agfl_needs_reset(
 	int			active;
 
 	/* no agfl header on v4 supers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return false;
 
 	/*
@@ -2877,7 +2877,7 @@ xfs_agf_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_agf		*agf = bp->b_addr;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(agf->agf_lsn)))
@@ -2907,7 +2907,7 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > mp->m_ag_maxlevels)
 		return __this_address;
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	if (xfs_has_rmapbt(mp) &&
 	    (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
 	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > mp->m_rmap_maxlevels))
 		return __this_address;
@@ -2950,7 +2950,7 @@ xfs_agf_read_verify(
 	struct xfs_mount *mp = bp->b_mount;
 	xfs_failaddr_t	fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -2975,7 +2975,7 @@ xfs_agf_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 6b363f78cfa2..6dce6a566926 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -498,7 +498,7 @@ xfs_allocbt_init_common(
 	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	return cur;
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index 9eb4c667a6b8..2f6b816aaf9f 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -20,7 +20,7 @@ struct xbtree_afakeroot;
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_ALLOC_BLOCK_LEN(mp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+	(xfs_has_crc(((mp))) ? \
 		XFS_BTREE_SBLOCK_CRC_LEN : XFS_BTREE_SBLOCK_LEN)
 
 /*
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index cdd06213ab44..4ed6196bb73e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -384,7 +384,7 @@ xfs_attr3_leaf_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -406,7 +406,7 @@ xfs_attr3_leaf_read_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -627,10 +627,10 @@ STATIC void
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
@@ -1199,7 +1199,7 @@ xfs_attr3_leaf_to_node(
 	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLFT_ATTR_LEAF_BUF);
 	bp2->b_ops = bp1->b_ops;
 	memcpy(bp2->b_addr, bp1->b_addr, args->geo->blksize);
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_blkinfo *hdr3 = bp2->b_addr;
 		hdr3->blkno = cpu_to_be64(bp2->b_bn);
 	}
@@ -1264,7 +1264,7 @@ xfs_attr3_leaf_create(
 	memset(&ichdr, 0, sizeof(ichdr));
 	ichdr.firstused = args->geo->blksize;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_blkinfo *hdr3 = bp->b_addr;
 
 		ichdr.magic = XFS_ATTR3_LEAF_MAGIC;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 16690439121e..8429395ad5f1 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -51,7 +51,7 @@ xfs_attr3_rmt_blocks(
 	struct xfs_mount *mp,
 	int		attrlen)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		int buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
 		return (attrlen + buflen - 1) / buflen;
 	}
@@ -126,7 +126,7 @@ __xfs_attr3_rmt_read_verify(
 	int		blksize = mp->m_attr_geo->blksize;
 
 	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return 0;
 
 	ptr = bp->b_addr;
@@ -191,7 +191,7 @@ xfs_attr3_rmt_write_verify(
 	xfs_daddr_t	bno;
 
 	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	ptr = bp->b_addr;
@@ -246,7 +246,7 @@ xfs_attr3_rmt_hdr_set(
 {
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return 0;
 
 	rmt->rm_magic = cpu_to_be32(XFS_ATTR3_RMT_MAGIC);
@@ -296,7 +296,7 @@ xfs_attr_rmtval_copyout(
 
 		byte_cnt = min(*valuelen, byte_cnt);
 
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (xfs_has_crc(mp)) {
 			if (xfs_attr3_rmt_hdr_ok(src, ino, *offset,
 						  byte_cnt, bno)) {
 				xfs_alert(mp,
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 948092babb6a..e806f8517012 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1115,17 +1115,17 @@ xfs_bmap_add_attrfork(
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
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 1ceba020940e..4565e471c55e 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -136,7 +136,7 @@ xfs_bmbt_to_bmdr(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		ASSERT(rblock->bb_magic == cpu_to_be32(XFS_BMAP_CRC_MAGIC));
 		ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid,
 		       &mp->m_sb.sb_meta_uuid));
@@ -563,7 +563,7 @@ xfs_bmbt_init_cursor(
 
 	cur->bc_ops = &xfs_bmbt_ops;
 	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_ino.forksize = XFS_IFORK_SIZE(ip, whichfork);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 72bf74c79fb9..2a1a94c2f513 100644
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
index be74a6b53689..5ff3c0474c6a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -64,7 +64,7 @@ __xfs_btree_check_lblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
-	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
+	int			crc = xfs_has_crc(mp);
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -129,7 +129,7 @@ __xfs_btree_check_sblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
-	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
+	int			crc = xfs_has_crc(mp);
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -287,7 +287,7 @@ xfs_btree_lblock_verify_crc(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_mount	*mp = bp->b_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn)))
 			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
@@ -325,7 +325,7 @@ xfs_btree_sblock_verify_crc(
 	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_mount	*mp = bp->b_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
 			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
@@ -1090,7 +1090,7 @@ xfs_btree_init_block_int(
 	__u64			owner,
 	unsigned int		flags)
 {
-	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
+	int			crc = xfs_has_crc(mp);
 	__u32			magic = xfs_btree_magic(crc, btnum);
 
 	buf->bb_magic = cpu_to_be32(magic);
@@ -4418,7 +4418,7 @@ xfs_btree_lblock_v5hdr_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return __this_address;
 	if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
@@ -4468,7 +4468,7 @@ xfs_btree_sblock_v5hdr_verify(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return __this_address;
 	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 747ec77912c3..0a8cde1fbe0d 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -253,7 +253,7 @@ xfs_da3_node_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -442,7 +442,7 @@ xfs_da3_node_create(
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
 	node = bp->b_addr;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
 		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index b876b44c0204..5a49caa5c9df 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -789,7 +789,7 @@ struct xfs_attr3_rmt_hdr {
 #define XFS_ATTR3_RMT_CRC_OFF	offsetof(struct xfs_attr3_rmt_hdr, rm_crc)
 
 #define XFS_ATTR3_RMT_BUF_SPACE(mp, bufsize)	\
-	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
+	((bufsize) - (xfs_has_crc((mp)) ? \
 			sizeof(struct xfs_attr3_rmt_hdr) : 0))
 
 /* Number of bytes in a directory block. */
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 75e1421f69c4..49e61ca1045b 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -71,7 +71,7 @@ xfs_dir3_block_read_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -96,7 +96,7 @@ xfs_dir3_block_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -171,7 +171,7 @@ xfs_dir3_block_init(
 	bp->b_ops = &xfs_dir3_block_buf_ops;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_BLOCK_BUF);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		memset(hdr3, 0, sizeof(*hdr3));
 		hdr3->magic = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
 		hdr3->blkno = cpu_to_be64(bp->b_bn);
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index e67fa086f2c1..920bd13512a8 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -343,7 +343,7 @@ xfs_dir3_data_read_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -368,7 +368,7 @@ xfs_dir3_data_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -717,7 +717,7 @@ xfs_dir3_data_init(
 	 * Initialize the header.
 	 */
 	hdr = bp->b_addr;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
 		memset(hdr3, 0, sizeof(*hdr3));
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 5369d8bb2593..40ac411acf03 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -209,7 +209,7 @@ xfs_dir3_leaf_read_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -234,7 +234,7 @@ xfs_dir3_leaf_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -308,7 +308,7 @@ xfs_dir3_leaf_init(
 
 	ASSERT(type == XFS_DIR2_LEAF1_MAGIC || type == XFS_DIR2_LEAFN_MAGIC);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
 
 		memset(leaf3, 0, sizeof(*leaf3));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index d0520afb913a..a2ee1d48519c 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -105,7 +105,7 @@ xfs_dir3_free_verify(
 	if (!xfs_verify_magic(bp, hdr->magic))
 		return __this_address;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
@@ -128,7 +128,7 @@ xfs_dir3_free_read_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -153,7 +153,7 @@ xfs_dir3_free_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -185,7 +185,7 @@ xfs_dir3_free_header_check(
 	firstdb = (xfs_dir2_da_to_db(mp->m_dir_geo, fbno) -
 		   xfs_dir2_byte_to_db(mp->m_dir_geo, XFS_DIR2_FREE_OFFSET)) *
 			maxbests;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_free_hdr *hdr3 = bp->b_addr;
 
 		if (be32_to_cpu(hdr3->firstdb) != firstdb)
@@ -341,7 +341,7 @@ xfs_dir3_free_get_buf(
 	memset(bp->b_addr, 0, sizeof(struct xfs_dir3_free_hdr));
 	memset(&hdr, 0, sizeof(hdr));
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_free_hdr *hdr3 = bp->b_addr;
 
 		hdr.magic = XFS_DIR3_FREE_MAGIC;
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 46d18bf9d5e1..1afe09910bee 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -192,7 +192,7 @@ xfs_dir2_block_sfsize(
 	 * if there is a filetype field, add the extra byte to the namelen
 	 * for each entry that we see.
 	 */
-	has_ftype = xfs_sb_version_hasftype(&mp->m_sb) ? 1 : 0;
+	has_ftype = xfs_has_ftype(mp) ? 1 : 0;
 
 	count = i8count = namelen = 0;
 	btp = xfs_dir2_block_tail_p(geo, hdr);
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 6766417d5ba4..edd0f413f030 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -106,7 +106,7 @@ xfs_dqblk_verify(
 	struct xfs_dqblk	*dqb,
 	xfs_dqid_t		id)	/* used only during quotacheck */
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
 
@@ -134,7 +134,7 @@ xfs_dqblk_repair(
 	dqb->dd_diskdq.d_type = type;
 	dqb->dd_diskdq.d_id = cpu_to_be32(id);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		uuid_copy(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid);
 		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
@@ -151,7 +151,7 @@ xfs_dquot_buf_verify_crc(
 	int			ndquots;
 	int			i;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return true;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index fdd35202f92c..d4690f2807e0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 19eb7ec0103f..86a5ff66b220 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -58,7 +58,7 @@ xfs_inobt_update(
 	union xfs_btree_rec	rec;
 
 	rec.inobt.ir_startino = cpu_to_be32(irec->ir_startino);
-	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+	if (xfs_has_sparseinodes(cur->bc_mp)) {
 		rec.inobt.ir_u.sp.ir_holemask = cpu_to_be16(irec->ir_holemask);
 		rec.inobt.ir_u.sp.ir_count = irec->ir_count;
 		rec.inobt.ir_u.sp.ir_freecount = irec->ir_freecount;
@@ -78,7 +78,7 @@ xfs_inobt_btrec_to_irec(
 	struct xfs_inobt_rec_incore	*irec)
 {
 	irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb)) {
+	if (xfs_has_sparseinodes(mp)) {
 		irec->ir_holemask = be16_to_cpu(rec->inobt.ir_u.sp.ir_holemask);
 		irec->ir_count = rec->inobt.ir_u.sp.ir_count;
 		irec->ir_freecount = rec->inobt.ir_u.sp.ir_freecount;
@@ -2478,7 +2478,7 @@ xfs_agi_verify(
 	struct xfs_agi	*agi = bp->b_addr;
 	int		i;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(agi->agi_lsn)))
@@ -2497,7 +2497,7 @@ xfs_agi_verify(
 	    be32_to_cpu(agi->agi_level) > M_IGEO(mp)->inobt_maxlevels)
 		return __this_address;
 
-	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	if (xfs_has_finobt(mp) &&
 	    (be32_to_cpu(agi->agi_free_level) < 1 ||
 	     be32_to_cpu(agi->agi_free_level) > M_IGEO(mp)->inobt_maxlevels))
 		return __this_address;
@@ -2528,7 +2528,7 @@ xfs_agi_read_verify(
 	struct xfs_mount *mp = bp->b_mount;
 	xfs_failaddr_t	fa;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
@@ -2553,7 +2553,7 @@ xfs_agi_write_verify(
 		return;
 	}
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (bip)
@@ -2953,7 +2953,7 @@ xfs_ialloc_check_shrink(
 	int			has;
 	int			error;
 
-	if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
+	if (!xfs_has_sparseinodes(mp))
 		return 0;
 
 	pag = xfs_perag_get(mp, agno);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 823a038939f8..4a599c8ca33a 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -212,7 +212,7 @@ xfs_inobt_init_rec_from_cur(
 	union xfs_btree_rec	*rec)
 {
 	rec->inobt.ir_startino = cpu_to_be32(cur->bc_rec.i.ir_startino);
-	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+	if (xfs_has_sparseinodes(cur->bc_mp)) {
 		rec->inobt.ir_u.sp.ir_holemask =
 					cpu_to_be16(cur->bc_rec.i.ir_holemask);
 		rec->inobt.ir_u.sp.ir_count = cur->bc_rec.i.ir_count;
@@ -446,7 +446,7 @@ xfs_inobt_init_common(
 
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	/* take a reference for the cursor */
@@ -737,7 +737,7 @@ xfs_finobt_calc_reserves(
 	xfs_extlen_t		tree_len = 0;
 	int			error;
 
-	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (!xfs_has_finobt(mp))
 		return 0;
 
 	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index e530c82b2217..8a322d402e61 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -19,7 +19,7 @@ struct xfs_perag;
  * Btree block header size depends on a superblock flag.
  */
 #define XFS_INOBT_BLOCK_LEN(mp) \
-	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+	(xfs_has_crc(((mp))) ? \
 		XFS_BTREE_SBLOCK_CRC_LEN : XFS_BTREE_SBLOCK_LEN)
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 84ea2e0af9f0..698af856a7f7 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -515,7 +515,7 @@ xfs_dinode_verify(
 
 	/* don't allow reflink/cowextsize if we don't have reflink */
 	if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
-	     !xfs_sb_version_hasreflink(&mp->m_sb))
+	     !xfs_has_reflink(mp))
 		return __this_address;
 
 	/* only regular files get reflink */
@@ -550,7 +550,7 @@ xfs_dinode_calc_crc(
 	if (dip->di_version < 3)
 		return;
 
-	ASSERT(xfs_sb_version_hascrc(&mp->m_sb));
+	ASSERT(xfs_has_crc(mp));
 	crc = xfs_start_cksum_update((char *)dip, mp->m_sb.sb_inodesize,
 			      XFS_DINODE_CRC_OFF);
 	dip->di_crc = xfs_end_cksum(crc);
@@ -677,7 +677,7 @@ xfs_inode_validate_cowextsize(
 	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
 	cowextsize_bytes = XFS_FSB_TO_B(mp, cowextsize);
 
-	if (hint_flag && !xfs_sb_version_hasreflink(&mp->m_sb))
+	if (hint_flag && !xfs_has_reflink(mp))
 		return __this_address;
 
 	if (hint_flag && !(S_ISDIR(mode) || S_ISREG(mode)))
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 2c5bcbc19264..28c020472f9a 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
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
diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 7f55eb3f3653..67798ff5e14e 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -92,7 +92,7 @@ xfs_log_calc_minimum_size(
 	if (tres.tr_logcount > 1)
 		max_logres *= tres.tr_logcount;
 
-	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1)
+	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
 		lsunit = BTOBB(mp->m_sb.sb_logsunit);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 92d336c17e83..31ce9d2d45e1 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -209,7 +209,7 @@ xfs_refcountbt_verify(
 	if (!xfs_verify_magic(bp, block->bb_magic))
 		return __this_address;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return __this_address;
 	fa = xfs_btree_sblock_v5hdr_verify(bp);
 	if (fa)
@@ -462,7 +462,7 @@ xfs_refcountbt_calc_reserves(
 	xfs_extlen_t		tree_len;
 	int			error;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return 0;
 
 	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index d1dfad0204e3..1aa2b499d7e8 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -705,7 +705,7 @@ xfs_rmap_free(
 	struct xfs_btree_cur		*cur;
 	int				error;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
@@ -959,7 +959,7 @@ xfs_rmap_alloc(
 	struct xfs_btree_cur		*cur;
 	int				error;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
@@ -2459,7 +2459,7 @@ xfs_rmap_update_is_needed(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	return xfs_sb_version_hasrmapbt(&mp->m_sb) && whichfork != XFS_COW_FORK;
+	return xfs_has_rmapbt(mp) && whichfork != XFS_COW_FORK;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index f29bc71b9950..921651fb4b1b 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -304,7 +304,7 @@ xfs_rmapbt_verify(
 	if (!xfs_verify_magic(bp, block->bb_magic))
 		return __this_address;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return __this_address;
 	fa = xfs_btree_sblock_v5hdr_verify(bp);
 	if (fa)
@@ -558,7 +558,7 @@ xfs_rmapbt_compute_maxlevels(
 	 * disallow reflinking when less than 10% of the per-AG metadata
 	 * block reservation since the fallback is a regular file copy.
 	 */
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		mp->m_rmap_maxlevels = XFS_BTREE_MAXLEVELS;
 	else
 		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(
@@ -606,7 +606,7 @@ xfs_rmapbt_calc_reserves(
 	xfs_extlen_t		tree_len;
 	int			error;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 
 	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f9af5f1c9ffc..a1e286fb8ac3 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -239,7 +239,7 @@ xfs_validate_sb_common(
 		return -EWRONGFS;
 	}
 
-	if (xfs_sb_version_has_pquotino(sbp)) {
+	if (xfs_sb_version_haspquotino(sbp)) {
 		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
 			xfs_notice(mp,
 			   "Version 5 of Super block has XFS_OQUOTA bits.");
@@ -378,7 +378,7 @@ xfs_validate_sb_common(
 			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
 		return -EFSCORRUPTED;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_sb_version_hascrc(sbp) &&
 	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
 		xfs_notice(mp, "v5 SB sanity check failed");
 		return -EFSCORRUPTED;
@@ -427,7 +427,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 	 * We need to do these manipilations only if we are working
 	 * with an older version of on-disk superblock.
 	 */
-	if (xfs_sb_version_has_pquotino(sbp))
+	if (xfs_sb_version_haspquotino(sbp))
 		return;
 
 	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
@@ -545,7 +545,7 @@ xfs_sb_quota_to_disk(
 	uint16_t	qflags = from->sb_qflags;
 
 	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
-	if (xfs_sb_version_has_pquotino(from)) {
+	if (xfs_sb_version_haspquotino(from)) {
 		to->sb_qflags = cpu_to_be16(from->sb_qflags);
 		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
 		to->sb_pquotino = cpu_to_be64(from->sb_pquotino);
@@ -770,7 +770,7 @@ xfs_sb_write_verify(
 	if (error)
 		goto out_error;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_sb_version_hascrc(&sb))
 		return;
 
 	if (bip)
@@ -1066,7 +1066,7 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LAZYSB;
 	if (xfs_sb_version_hasattr2(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR2;
-	if (xfs_sb_version_hasprojid32bit(sbp))
+	if (xfs_sb_version_hasprojid32(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_PROJID32;
 	if (xfs_sb_version_hascrc(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_V5SB;
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 594bc447a7dd..98b2b6804657 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -42,7 +42,7 @@ xfs_symlink_hdr_set(
 {
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return 0;
 
 	memset(dsl, 0, sizeof(struct xfs_dsymlink_hdr));
@@ -89,7 +89,7 @@ xfs_symlink_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return __this_address;
 	if (!xfs_verify_magic(bp, dsl->sl_magic))
 		return __this_address;
@@ -116,7 +116,7 @@ xfs_symlink_read_verify(
 	xfs_failaddr_t	fa;
 
 	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF))
@@ -137,7 +137,7 @@ xfs_symlink_write_verify(
 	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	fa = xfs_symlink_verify(bp);
@@ -173,7 +173,7 @@ xfs_symlink_local_to_remote(
 
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SYMLINK_BUF);
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (!xfs_has_crc(mp)) {
 		bp->b_ops = NULL;
 		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
 		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index ce12c8142bd1..99df706fe2b9 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -71,9 +71,9 @@ xfs_allocfree_log_count(
 	uint		blocks;
 
 	blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
 
 	return blocks;
@@ -155,7 +155,7 @@ STATIC uint
 xfs_calc_finobt_res(
 	struct xfs_mount	*mp)
 {
-	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (!xfs_has_finobt(mp))
 		return 0;
 
 	return xfs_calc_inobt_res(mp);
@@ -819,14 +819,14 @@ xfs_trans_resv_calc(
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
@@ -887,7 +887,7 @@ xfs_trans_resv_calc(
 	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
 	else
 		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index e8f4abee7892..e810d23f2d97 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -169,7 +169,7 @@ xfs_internal_inum(
 	xfs_ino_t		ino)
 {
 	return ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
-		(xfs_sb_version_hasquota(&mp->m_sb) &&
+		(xfs_has_quota(mp) &&
 		 xfs_is_quota_inode(&mp->m_sb, ino));
 }
 
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 6152ce01c057..9a7dd72a9884 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -283,7 +283,7 @@ xchk_superblock(
 	    (cpu_to_be32(mp->m_sb.sb_features2) & features_mask))
 		xchk_block_set_corrupt(sc, bp);
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (!xfs_has_crc(mp)) {
 		/* all v5 fields must be zero */
 		if (memchr_inv(&sb->sb_features_compat, 0,
 				sizeof(struct xfs_dsb) -
@@ -334,7 +334,7 @@ xchk_superblock(
 		/* Don't care about sb_lsn */
 	}
 
-	if (xfs_sb_version_hasmetauuid(&mp->m_sb)) {
+	if (xfs_has_metauuid(mp)) {
 		/* The metadata UUID must be the same for all supers */
 		if (!uuid_equal(&sb->sb_meta_uuid, &mp->m_sb.sb_meta_uuid))
 			xchk_block_set_corrupt(sc, bp);
@@ -449,7 +449,7 @@ xchk_agf_xref_btreeblks(
 	 * No rmap cursor; we can't xref if we have the rmapbt feature.
 	 * We also can't do it if we're missing the free space btree cursors.
 	 */
-	if ((xfs_sb_version_hasrmapbt(&mp->m_sb) && !sc->sa.rmap_cur) ||
+	if ((xfs_has_rmapbt(mp) && !sc->sa.rmap_cur) ||
 	    !sc->sa.bno_cur || !sc->sa.cnt_cur)
 		return;
 
@@ -562,7 +562,7 @@ xchk_agf(
 	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (xfs_has_rmapbt(mp)) {
 		agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
 		if (!xfs_verify_agbno(mp, agno, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
@@ -572,7 +572,7 @@ xchk_agf(
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 	}
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		agbno = be32_to_cpu(agf->agf_refcount_root);
 		if (!xfs_verify_agbno(mp, agno, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
@@ -883,7 +883,7 @@ xchk_agi(
 	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
-	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+	if (xfs_has_finobt(mp)) {
 		agbno = be32_to_cpu(agi->agi_free_root);
 		if (!xfs_verify_agbno(mp, agno, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index f122f2e20e79..0db855f0c82f 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -164,7 +164,7 @@ xrep_agf_find_btrees(
 		return -EFSCORRUPTED;
 
 	/* We must find the refcountbt root if that feature is enabled. */
-	if (xfs_sb_version_hasreflink(&sc->mp->m_sb) &&
+	if (xfs_has_reflink(sc->mp) &&
 	    !xrep_check_btree_root(sc, &fab[XREP_AGF_REFCOUNTBT]))
 		return -EFSCORRUPTED;
 
@@ -193,7 +193,7 @@ xrep_agf_init_header(
 	agf->agf_flfirst = old_agf->agf_flfirst;
 	agf->agf_fllast = old_agf->agf_fllast;
 	agf->agf_flcount = old_agf->agf_flcount;
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
 
 	/* Mark the incore AGF data stale until we're done fixing things. */
@@ -223,7 +223,7 @@ xrep_agf_set_roots(
 	agf->agf_levels[XFS_BTNUM_RMAPi] =
 			cpu_to_be32(fab[XREP_AGF_RMAPBT].height);
 
-	if (xfs_sb_version_hasreflink(&sc->mp->m_sb)) {
+	if (xfs_has_reflink(sc->mp)) {
 		agf->agf_refcount_root =
 				cpu_to_be32(fab[XREP_AGF_REFCOUNTBT].root);
 		agf->agf_refcount_level =
@@ -280,7 +280,7 @@ xrep_agf_calc_from_btrees(
 	agf->agf_btreeblks = cpu_to_be32(btreeblks);
 
 	/* Update the AGF counters from the refcountbt. */
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		cur = xfs_refcountbt_init_cursor(mp, sc->tp, agf_bp,
 				sc->sa.pag);
 		error = xfs_btree_count_blocks(cur, &blocks);
@@ -363,7 +363,7 @@ xrep_agf(
 	int				error;
 
 	/* We require the rmapbt to rebuild anything. */
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return -EOPNOTSUPP;
 
 	/*
@@ -637,7 +637,7 @@ xrep_agfl(
 	int			error;
 
 	/* We require the rmapbt to rebuild anything. */
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return -EOPNOTSUPP;
 
 	xbitmap_init(&agfl_extents);
@@ -735,7 +735,7 @@ xrep_agi_find_btrees(
 		return -EFSCORRUPTED;
 
 	/* We must find the finobt root if that feature is enabled. */
-	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	if (xfs_has_finobt(mp) &&
 	    !xrep_check_btree_root(sc, &fab[XREP_AGI_FINOBT]))
 		return -EFSCORRUPTED;
 
@@ -763,7 +763,7 @@ xrep_agi_init_header(
 	agi->agi_length = cpu_to_be32(xfs_ag_block_count(mp, sc->sa.agno));
 	agi->agi_newino = cpu_to_be32(NULLAGINO);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
 
 	/* We don't know how to fix the unlinked list yet. */
@@ -785,7 +785,7 @@ xrep_agi_set_roots(
 	agi->agi_root = cpu_to_be32(fab[XREP_AGI_INOBT].root);
 	agi->agi_level = cpu_to_be32(fab[XREP_AGI_INOBT].height);
 
-	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb)) {
+	if (xfs_has_finobt(sc->mp)) {
 		agi->agi_free_root = cpu_to_be32(fab[XREP_AGI_FINOBT].root);
 		agi->agi_free_level = cpu_to_be32(fab[XREP_AGI_FINOBT].height);
 	}
@@ -891,7 +891,7 @@ xrep_agi(
 	int				error;
 
 	/* We require the rmapbt to rebuild anything. */
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return -EOPNOTSUPP;
 
 	/*
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 6c36af6dbd35..b6f0c9f3f124 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -336,7 +336,7 @@ xchk_xattr_block(
 	bitmap_zero(usedmap, mp->m_attr_geo->blksize);
 
 	/* Check all the padding. */
-	if (xfs_sb_version_hascrc(&ds->sc->mp->m_sb)) {
+	if (xfs_has_crc(ds->sc->mp)) {
 		struct xfs_attr3_leafblock	*leaf = bp->b_addr;
 
 		if (leaf->hdr.pad1 != 0 || leaf->hdr.pad2 != 0 ||
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 678afceeb16b..14a3242e93ce 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -400,7 +400,7 @@ xchk_bmapbt_rec(
 	 * Check the owners of the btree blocks up to the level below
 	 * the root since the verifiers don't do that.
 	 */
-	if (xfs_sb_version_hascrc(&bs->cur->bc_mp->m_sb) &&
+	if (xfs_has_crc(bs->cur->bc_mp) &&
 	    bs->cur->bc_ptrs[0] == 1) {
 		for (i = 0; i < bs->cur->bc_nlevels - 1; i++) {
 			block = xfs_btree_get_block(bs->cur, i, &bp);
@@ -581,7 +581,7 @@ xchk_bmap_check_rmaps(
 	bool			zero_size;
 	int			error;
 
-	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb) ||
+	if (!xfs_has_rmapbt(sc->mp) ||
 	    whichfork == XFS_COW_FORK ||
 	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return 0;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 0ef96ed71017..08ba2fa75f67 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -832,7 +832,7 @@ xchk_metadata_inode_forks(
 		return error;
 
 	/* Look for incorrect shared blocks. */
-	if (xfs_sb_version_hasreflink(&sc->mp->m_sb)) {
+	if (xfs_has_reflink(sc->mp)) {
 		error = xfs_reflink_inode_has_shared_extents(sc->tp, sc->ip,
 				&shared);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0,
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 9f0dbb47c82c..8a52514bc1ff 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -367,11 +367,11 @@ xchk_da_btree_block(
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
index 28dda391d5df..200a63f58fe7 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -51,7 +51,7 @@ xchk_dir_check_ftype(
 	int			ino_dtype;
 	int			error = 0;
 
-	if (!xfs_sb_version_hasftype(&mp->m_sb)) {
+	if (!xfs_has_ftype(mp)) {
 		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
@@ -140,7 +140,7 @@ xchk_dir_actor(
 
 	if (!strncmp(".", name, namelen)) {
 		/* If this is "." then check that the inum matches the dir. */
-		if (xfs_sb_version_hasftype(&mp->m_sb) && type != DT_DIR)
+		if (xfs_has_ftype(mp) && type != DT_DIR)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
 		checked_ftype = true;
@@ -152,7 +152,7 @@ xchk_dir_actor(
 		 * If this is ".." in the root inode, check that the inum
 		 * matches this dir.
 		 */
-		if (xfs_sb_version_hasftype(&mp->m_sb) && type != DT_DIR)
+		if (xfs_has_ftype(mp) && type != DT_DIR)
 			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
 		checked_ftype = true;
@@ -526,7 +526,7 @@ xchk_directory_leaf1_bestfree(
 	bestcount = be32_to_cpu(ltp->bestcount);
 	bestp = xfs_dir2_leaf_bests_p(ltp);
 
-	if (xfs_sb_version_hascrc(&sc->mp->m_sb)) {
+	if (xfs_has_crc(sc->mp)) {
 		struct xfs_dir3_leaf_hdr	*hdr3 = bp->b_addr;
 
 		if (hdr3->pad != cpu_to_be32(0))
@@ -623,7 +623,7 @@ xchk_directory_free_bestfree(
 		return error;
 	xchk_buffer_recheck(sc, bp);
 
-	if (xfs_sb_version_hascrc(&sc->mp->m_sb)) {
+	if (xfs_has_crc(sc->mp)) {
 		struct xfs_dir3_free_hdr	*hdr3 = bp->b_addr;
 
 		if (hdr3->pad != cpu_to_be32(0))
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 30e568596b79..d51393677461 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -517,7 +517,7 @@ xchk_iallocbt_xref_rmap_btreeblks(
 	int			error;
 
 	if (!sc->sa.ino_cur || !sc->sa.rmap_cur ||
-	    (xfs_sb_version_hasfinobt(&sc->mp->m_sb) && !sc->sa.fino_cur) ||
+	    (xfs_has_finobt(sc->mp) && !sc->sa.fino_cur) ||
 	    xchk_skip_xref(sc->sm))
 		return;
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index a6a68ba19f0a..a8703278e168 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -181,7 +181,7 @@ xchk_inode_flags2(
 
 	/* reflink flag requires reflink feature */
 	if ((flags2 & XFS_DIFLAG2_REFLINK) &&
-	    !xfs_sb_version_hasreflink(&mp->m_sb))
+	    !xfs_has_reflink(mp))
 		goto bad;
 
 	/* cowextsize flag is checked w.r.t. mode separately */
@@ -278,7 +278,7 @@ xchk_dinode(
 			xchk_ino_set_corrupt(sc, ino);
 
 		if (dip->di_projid_hi != 0 &&
-		    !xfs_sb_version_hasprojid32bit(&mp->m_sb))
+		    !xfs_has_projid32(mp))
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	default:
@@ -560,7 +560,7 @@ xchk_inode_check_reflink_iflag(
 	bool			has_shared;
 	int			error;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return;
 
 	error = xfs_reflink_inode_has_shared_extents(sc->tp, sc->ip,
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index ebb0e245aa72..123bad3fba39 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -248,19 +248,19 @@ xrep_calc_ag_resblks(
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
@@ -269,7 +269,7 @@ xrep_calc_ag_resblks(
 		 * many rmaps there could be in the AG, so we start off with
 		 * what we hope is an generous over-estimation.
 		 */
-		if (xfs_sb_version_hasreflink(&mp->m_sb))
+		if (xfs_has_reflink(mp))
 			rmapbt_sz = xfs_rmapbt_calc_size(mp,
 					(unsigned long long)aglen * 2);
 		else
@@ -611,7 +611,7 @@ xrep_reap_extents(
 	xfs_fsblock_t			fsbno;
 	int				error = 0;
 
-	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
+	ASSERT(xfs_has_rmapbt(sc->mp));
 
 	for_each_xbitmap_block(fsbno, bmr, n, bitmap) {
 		ASSERT(sc->ip != NULL ||
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0e542636227c..2bed6bc573da 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -415,7 +415,7 @@ xchk_validate_inputs(
 	 */
 	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
 		error = -EOPNOTSUPP;
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
+		if (!xfs_has_crc(mp))
 			goto out;
 
 		error = -EROFS;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 213a97a921bb..af0a61134d1f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1282,7 +1282,7 @@ xfs_swap_extents_check_format(
 	 * If we have to use the (expensive) rmap swap method, we can
 	 * handle any number of extents and any format.
 	 */
-	if (xfs_sb_version_hasrmapbt(&ip->i_mount->m_sb))
+	if (xfs_has_rmapbt(ip->i_mount))
 		return 0;
 
 	/*
@@ -1516,7 +1516,7 @@ xfs_swap_extent_forks(
 	 * event of a crash. Set the owner change log flags now and leave the
 	 * bmbt scan as the last step.
 	 */
-	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+	if (xfs_has_v3inodes(ip->i_mount)) {
 		if (ip->i_df.if_format == XFS_DINODE_FMT_BTREE)
 			(*target_log_flags) |= XFS_ILOG_DOWNER;
 		if (tip->i_df.if_format == XFS_DINODE_FMT_BTREE)
@@ -1553,7 +1553,7 @@ xfs_swap_extent_forks(
 		(*src_log_flags) |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		ASSERT(!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) ||
+		ASSERT(!xfs_has_v3inodes(ip->i_mount) ||
 		       (*src_log_flags & XFS_ILOG_DOWNER));
 		(*src_log_flags) |= XFS_ILOG_DBROOT;
 		break;
@@ -1565,7 +1565,7 @@ xfs_swap_extent_forks(
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		(*target_log_flags) |= XFS_ILOG_DBROOT;
-		ASSERT(!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) ||
+		ASSERT(!xfs_has_v3inodes(ip->i_mount) ||
 		       (*target_log_flags & XFS_ILOG_DOWNER));
 		break;
 	}
@@ -1679,7 +1679,7 @@ xfs_swap_extents(
 	 * a block reservation because it's really just a remap operation
 	 * performed with log redo items!
 	 */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (xfs_has_rmapbt(mp)) {
 		int		w = XFS_DATA_FORK;
 		uint32_t	ipnext = ip->i_df.if_nextents;
 		uint32_t	tipnext	= tip->i_df.if_nextents;
@@ -1761,7 +1761,7 @@ xfs_swap_extents(
 	src_log_flags = XFS_ILOG_CORE;
 	target_log_flags = XFS_ILOG_CORE;
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		error = xfs_swap_extent_rmap(&tp, ip, tip);
 	else
 		error = xfs_swap_extent_forks(tp, ip, tip, &src_log_flags,
@@ -1780,7 +1780,7 @@ xfs_swap_extents(
 	}
 
 	/* Swap the cow forks. */
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		ASSERT(!ip->i_cowfp ||
 		       ip->i_cowfp->if_format == XFS_DINODE_FMT_EXTENTS);
 		ASSERT(!tip->i_cowfp ||
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a5ef1f9eb622..5d2ebee263d9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1520,7 +1520,7 @@ _xfs_buf_ioapply(
 			 * non-crc filesystems don't attach verifiers during
 			 * log recovery, so don't warn for such filesystems.
 			 */
-			if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			if (xfs_has_crc(mp)) {
 				xfs_warn(mp,
 					"%s: no buf ops on daddr 0x%llx len %d",
 					__func__, bp->b_bn, bp->b_length);
@@ -2301,7 +2301,7 @@ xfs_verify_magic(
 	struct xfs_mount	*mp = bp->b_mount;
 	int			idx;
 
-	idx = xfs_sb_version_hascrc(&mp->m_sb);
+	idx = xfs_has_crc(mp);
 	if (WARN_ON(!bp->b_ops || !bp->b_ops->magic[idx]))
 		return false;
 	return dmagic == bp->b_ops->magic[idx];
@@ -2319,7 +2319,7 @@ xfs_verify_magic16(
 	struct xfs_mount	*mp = bp->b_mount;
 	int			idx;
 
-	idx = xfs_sb_version_hascrc(&mp->m_sb);
+	idx = xfs_has_crc(mp);
 	if (WARN_ON(!bp->b_ops || !bp->b_ops->magic16[idx]))
 		return false;
 	return dmagic == bp->b_ops->magic16[idx];
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 2828ce45b701..0136cde9359b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -428,7 +428,7 @@ xfs_buf_item_format(
 	 * occurs during recovery.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
-		if (xfs_sb_version_has_v3inode(&lip->li_mountp->m_sb) ||
+		if (xfs_has_v3inodes(lip->li_mountp) ||
 		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 4775485b4062..a14f7039d346 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -219,7 +219,7 @@ xlog_recover_validate_buf_type(
 	 * inconsistent state resulting in verification failures. Hence for now
 	 * just avoid the verification stage for non-crc filesystems
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		return;
 
 	magic32 = be32_to_cpu(*(__be32 *)bp->b_addr);
@@ -597,7 +597,7 @@ xlog_recover_do_inode_buffer(
 	 * Post recovery validation only works properly on CRC enabled
 	 * filesystems.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		bp->b_ops = &xfs_inode_buf_ops;
 
 	inodes_per_buf = BBTOB(bp->b_length) >> mp->m_sb.sb_inodelog;
@@ -710,7 +710,7 @@ xlog_recover_get_buf_lsn(
 	uint16_t		blft;
 
 	/* v4 filesystems always recover immediately */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	if (!xfs_has_crc(mp))
 		goto recover_immediately;
 
 	/*
@@ -787,7 +787,7 @@ xlog_recover_get_buf_lsn(
 		 * the relevant UUID in the superblock.
 		 */
 		lsn = be64_to_cpu(((struct xfs_dsb *)blk)->sb_lsn);
-		if (xfs_sb_version_hasmetauuid(&mp->m_sb))
+		if (xfs_has_metauuid(mp))
 			uuid = &((struct xfs_dsb *)blk)->sb_meta_uuid;
 		else
 			uuid = &((struct xfs_dsb *)blk)->sb_uuid;
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index da1cc683560c..8e2408290727 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -32,7 +32,7 @@ xfs_dir3_get_dtype(
 	struct xfs_mount	*mp,
 	uint8_t			filetype)
 {
-	if (!xfs_sb_version_hasftype(&mp->m_sb))
+	if (!xfs_has_ftype(mp))
 		return DT_UNKNOWN;
 
 	if (filetype >= XFS_DIR3_FT_MAX)
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c301b18b7685..c15d61d47a06 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -223,9 +223,9 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
 		d->dd_diskdq.d_type = type;
-		if (curid > 0 && xfs_sb_version_hasbigtime(&mp->m_sb))
+		if (curid > 0 && xfs_has_bigtime(mp))
 			d->dd_diskdq.d_type |= XFS_DQTYPE_BIGTIME;
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (xfs_has_crc(mp)) {
 			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
 					 XFS_DQUOT_CRC_OFF);
@@ -526,7 +526,7 @@ xfs_dquot_check_type(
 	 * expect an exact match for user dquots and for non-root group and
 	 * project dquots.
 	 */
-	if (xfs_sb_version_hascrc(&dqp->q_mount->m_sb) ||
+	if (xfs_has_crc(dqp->q_mount) ||
 	    dqp_type == XFS_DQTYPE_USER || dqp->q_id != 0)
 		return ddqp_type == dqp_type;
 
@@ -1219,7 +1219,7 @@ xfs_qm_dqflush_check(
 
 	/* bigtime flag should never be set on root dquots */
 	if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
-		if (!xfs_sb_version_hasbigtime(&dqp->q_mount->m_sb))
+		if (!xfs_has_bigtime(dqp->q_mount))
 			return __this_address;
 		if (dqp->q_id == 0)
 			return __this_address;
@@ -1298,7 +1298,7 @@ xfs_qm_dqflush(
 	 * buffer always has a valid CRC. This ensures there is no possibility
 	 * of a dquot without an up-to-date CRC getting to disk.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		dqblk->dd_lsn = cpu_to_be64(dqp->q_logitem.qli_item.li_lsn);
 		xfs_update_cksum((char *)dqblk, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 5875c7e1bd28..8966ba842395 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -136,7 +136,7 @@ xlog_recover_dquot_commit_pass2(
 	 * If the dquot has an LSN in it, recover the dquot only if it's less
 	 * than the lsn of the transaction we are replaying.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
 		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
 
@@ -146,7 +146,7 @@ xlog_recover_dquot_commit_pass2(
 	}
 
 	memcpy(ddq, recddq, item->ri_buf[1].i_len);
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index cc3cfb12df53..fe31b53274ce 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1153,7 +1153,7 @@ xfs_file_remap_range(
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return -EOPNOTSUPP;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 7d0b09c1366e..2b86ae64dca6 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -202,7 +202,7 @@ xfs_getfsmap_is_shared(
 	int				error;
 
 	*stat = false;
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return 0;
 	/* rt files will have no perag structure */
 	if (!info->pag)
@@ -859,7 +859,7 @@ xfs_getfsmap(
 		return -EINVAL;
 
 	use_rmap = capable(CAP_SYS_ADMIN) &&
-		   xfs_sb_version_hasrmapbt(&mp->m_sb);
+		   xfs_has_rmapbt(mp);
 	head->fmh_entries = 0;
 
 	/* Set up our device handlers. */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 7a2f4feacc35..cbdb9a86edfc 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -177,7 +177,7 @@ xfs_growfs_data_private(
 	 * particularly important for shrink because the write verifier
 	 * will fail if sb_fdblocks is ever larger than sb_dblocks.
 	 */
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+	if (xfs_has_lazysbcount(mp))
 		xfs_log_sb(tp);
 
 	xfs_trans_set_sync(tp);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e7e69e55b768..ccc4df4b6b27 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -619,7 +619,7 @@ xfs_iget_cache_miss(
 	 * value and hence we must also read the inode off disk even when
 	 * initializing new inodes.
 	 */
-	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
+	if (xfs_has_v3inodes(mp) &&
 	    (flags & XFS_IGET_CREATE) && !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		VFS_I(ip)->i_generation = prandom_u32();
 	} else {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3c6ce1f6f643..3d6e566146de 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -705,7 +705,7 @@ xfs_inode_inherit_flags(
 			di_flags |= XFS_DIFLAG_PROJINHERIT;
 	} else if (S_ISREG(mode)) {
 		if ((pip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
-		    xfs_sb_version_hasrealtime(&ip->i_mount->m_sb))
+		    xfs_has_realtime(ip->i_mount))
 			di_flags |= XFS_DIFLAG_REALTIME;
 		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
 			di_flags |= XFS_DIFLAG_EXTSIZE;
@@ -857,7 +857,7 @@ xfs_init_new_inode(
 	ip->i_extsize = 0;
 	ip->i_diflags = 0;
 
-	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
+	if (xfs_has_v3inodes(mp)) {
 		inode_set_iversion(inode, 1);
 		ip->i_cowextsize = 0;
 		ip->i_crtime = tv;
@@ -897,7 +897,7 @@ xfs_init_new_inode(
 	 * this saves us from needing to run a separate transaction to set the
 	 * fork offset in the immediate future.
 	 */
-	if (init_xattrs && xfs_sb_version_hasattr(&mp->m_sb)) {
+	if (init_xattrs && xfs_has_attr(mp)) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
 	}
@@ -3515,7 +3515,7 @@ xfs_iflush(
 	 * happen but we need to still do it to ensure backwards compatibility
 	 * with old kernels that predate logging all inode changes.
 	 */
-	if (!xfs_sb_version_has_v3inode(&mp->m_sb))
+	if (!xfs_has_v3inodes(mp))
 		ip->i_flushiter++;
 
 	/*
@@ -3537,7 +3537,7 @@ xfs_iflush(
 	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
 
 	/* Wrap, we never let the log put out DI_MAX_FLUSH */
-	if (!xfs_sb_version_has_v3inode(&mp->m_sb)) {
+	if (!xfs_has_v3inodes(mp)) {
 		if (ip->i_flushiter == DI_MAX_FLUSH)
 			ip->i_flushiter = 0;
 	}
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 35de30849fcc..0659d19c211e 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -396,7 +396,7 @@ xfs_inode_to_log_dinode(
 	/* log a dummy value to ensure log structure is fully initialised */
 	to->di_next_unlinked = NULLAGINO;
 
-	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+	if (xfs_has_v3inodes(ip->i_mount)) {
 		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
 		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, ip->i_crtime);
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index e0072a6cd2d3..239dd2e3384e 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -295,7 +295,7 @@ xlog_recover_inode_commit_pass2(
 	 * superblock flag to determine whether we need to look at di_flushiter
 	 * to skip replay when the on disk inode is newer than the log one
 	 */
-	if (!xfs_sb_version_has_v3inode(&mp->m_sb) &&
+	if (!xfs_has_v3inodes(mp) &&
 	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
 		/*
 		 * Deal with the wrap case, DI_MAX_FLUSH is less
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e2d995502cd8..86150e0206cf 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1213,7 +1213,7 @@ xfs_ioctl_setattr_xflags(
 
 	/* diflags2 only valid for v3 inodes. */
 	i_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
-	if (i_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
+	if (i_flags2 && !xfs_has_v3inodes(mp))
 		return -EINVAL;
 
 	ip->i_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
@@ -1362,9 +1362,9 @@ xfs_ioctl_setattr_check_projid(
 	if (!fa->fsx_valid)
 		return 0;
 
-	/* Disallow 32bit project ids if projid32bit feature is not enabled. */
+	/* Disallow 32bit project ids if 32bit IDs are not enabled. */
 	if (fa->fsx_projid > (uint16_t)-1 &&
-	    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
+	    !xfs_has_projid32(ip->i_mount))
 		return -EINVAL;
 	return 0;
 }
@@ -1467,7 +1467,7 @@ xfs_fileattr_set(
 	else
 		ip->i_extsize = 0;
 
-	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
+	if (xfs_has_v3inodes(mp)) {
 		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			ip->i_cowextsize = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
 		else
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 327d65ef1e26..fd9a13381491 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -393,7 +393,7 @@ xfs_vn_unlink(
 	 * but still hashed. This is incompatible with case-insensitive
 	 * mode, so invalidate (unhash) the dentry in CI-mode.
 	 */
-	if (xfs_sb_version_hasasciici(&XFS_M(dir->i_sb)->m_sb))
+	if (xfs_has_asciici(XFS_M(dir->i_sb)))
 		d_invalidate(dentry);
 	return 0;
 }
@@ -597,7 +597,7 @@ xfs_vn_getattr(
 	stat->ctime = inode->i_ctime;
 	stat->blocks = XFS_FSB_TO_BB(mp, ip->i_nblocks + ip->i_delayed_blks);
 
-	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
+	if (xfs_has_v3inodes(mp)) {
 		if (request_mask & STATX_BTIME) {
 			stat->result_mask |= STATX_BTIME;
 			stat->btime = ip->i_crtime;
@@ -788,7 +788,7 @@ xfs_setattr_nonsize(
 		}
 		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_GQUOTA_ON(mp)) {
-				ASSERT(xfs_sb_version_has_pquotino(&mp->m_sb) ||
+				ASSERT(xfs_has_pquotino(mp) ||
 				       !XFS_IS_PQUOTA_ON(mp));
 				ASSERT(mask & ATTR_GID);
 				ASSERT(gdqp);
@@ -1401,7 +1401,7 @@ xfs_setup_iops(
 			inode->i_mapping->a_ops = &xfs_address_space_operations;
 		break;
 	case S_IFDIR:
-		if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
+		if (xfs_has_asciici(XFS_M(inode->i_sb)))
 			inode->i_op = &xfs_dir_ci_inode_operations;
 		else
 			inode->i_op = &xfs_dir_inode_operations;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 84c17a9f9869..c08c79d9e311 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -108,7 +108,7 @@ xfs_bulkstat_one_int(
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
 	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
 
-	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
+	if (xfs_has_v3inodes(mp)) {
 		buf->bs_btime = ip->i_crtime.tv_sec;
 		buf->bs_btime_nsec = ip->i_crtime.tv_nsec;
 		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 098f5c8ceb29..c927ad6d3eb7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -634,7 +634,7 @@ xfs_log_mount(
 	int		num_bblks)
 {
 	struct xlog	*log;
-	bool		fatal = xfs_sb_version_hascrc(&mp->m_sb);
+	bool		fatal = xfs_has_crc(mp);
 	int		error = 0;
 	int		min_logfsbs;
 
@@ -1234,7 +1234,7 @@ xfs_log_cover(
 	 * handles this for us.
 	 */
 	need_covered = xfs_log_need_covered(mp);
-	if (!need_covered && !xfs_sb_version_haslazysbcount(&mp->m_sb))
+	if (!need_covered && !xfs_has_lazysbcount(mp))
 		return 0;
 
 	/*
@@ -1533,7 +1533,7 @@ xlog_alloc_log(
 	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
 
-	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1)
+	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
 		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
 	else
 		log->l_iclog_roundoff = BBSIZE;
@@ -1542,7 +1542,7 @@ xlog_alloc_log(
 	xlog_grant_head_init(&log->l_write_head);
 
 	error = -EFSCORRUPTED;
-	if (xfs_sb_version_hassector(&mp->m_sb)) {
+	if (xfs_has_sector(mp)) {
 	        log2_size = mp->m_sb.sb_logsectlog;
 		if (log2_size < BBSHIFT) {
 			xfs_warn(mp, "Log sector size too small (0x%x < 0x%x)",
@@ -1559,7 +1559,7 @@ xlog_alloc_log(
 
 		/* for larger sector sizes, must have v2 or external log */
 		if (log2_size && log->l_logBBstart > 0 &&
-			    !xfs_sb_version_haslogv2(&mp->m_sb)) {
+			    !xfs_has_logv2(mp)) {
 			xfs_warn(mp,
 		"log sector size (0x%x) invalid for configuration.",
 				log2_size);
@@ -1607,7 +1607,7 @@ xlog_alloc_log(
 		memset(head, 0, sizeof(xlog_rec_header_t));
 		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
 		head->h_version = cpu_to_be32(
-			xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? 2 : 1);
+			xfs_has_logv2(log->l_mp) ? 2 : 1);
 		head->h_size = cpu_to_be32(log->l_iclog_size);
 		/* new fields */
 		head->h_fmt = cpu_to_be32(XLOG_FMT);
@@ -1766,7 +1766,7 @@ xlog_pack_data(
 		dp += BBSIZE;
 	}
 
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		xlog_in_core_2_t *xhdr = iclog->ic_data;
 
 		for ( ; i < BTOBB(size); i++) {
@@ -1803,7 +1803,7 @@ xlog_cksum(
 			      offsetof(struct xlog_rec_header, h_crc));
 
 	/* ... then for additional cycle data for v2 logs ... */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		union xlog_in_core2 *xhdr = (union xlog_in_core2 *)rhead;
 		int		i;
 		int		xheads;
@@ -2030,7 +2030,7 @@ xlog_sync(
 
 	/* real byte length */
 	size = iclog->ic_offset;
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb))
+	if (xfs_has_logv2(log->l_mp))
 		size += roundoff;
 	iclog->ic_header.h_len = cpu_to_be32(size);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bcab5c67c0f7..d462b856cea3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -375,7 +375,7 @@ xlog_find_verify_cycle(
 static inline int
 xlog_logrec_hblks(struct xlog *log, struct xlog_rec_header *rh)
 {
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		int	h_size = be32_to_cpu(rh->h_size);
 
 		if ((be32_to_cpu(rh->h_version) & XLOG_VERSION_2) &&
@@ -1504,7 +1504,7 @@ xlog_add_record(
 	recp->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
 	recp->h_cycle = cpu_to_be32(cycle);
 	recp->h_version = cpu_to_be32(
-			xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? 2 : 1);
+			xfs_has_logv2(log->l_mp) ? 2 : 1);
 	recp->h_lsn = cpu_to_be64(xlog_assign_lsn(cycle, block));
 	recp->h_tail_lsn = cpu_to_be64(xlog_assign_lsn(tail_cycle, tail_block));
 	recp->h_fmt = cpu_to_be32(XLOG_FMT);
@@ -2835,7 +2835,7 @@ xlog_unpack_data(
 		dp += BBSIZE;
 	}
 
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
 		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
@@ -2883,7 +2883,7 @@ xlog_recover_process(
 	 * the kernel from one that does not add CRCs by default.
 	 */
 	if (crc != old_crc) {
-		if (old_crc || xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
+		if (old_crc || xfs_has_crc(log->l_mp)) {
 			xfs_alert(log->l_mp,
 		"log record CRC mismatch: found 0x%x, expected 0x%x.",
 					le32_to_cpu(old_crc),
@@ -2895,7 +2895,7 @@ xlog_recover_process(
 		 * If the filesystem is CRC enabled, this mismatch becomes a
 		 * fatal log corruption failure.
 		 */
-		if (xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
+		if (xfs_has_crc(log->l_mp)) {
 			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 			return -EFSCORRUPTED;
 		}
@@ -2981,7 +2981,7 @@ xlog_do_recovery_pass(
 	 * Read the header of the tail block and get the iclog buffer size from
 	 * h_size.  Use this to tell how many sectors make up the log header.
 	 */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+	if (xfs_has_logv2(log->l_mp)) {
 		/*
 		 * When using variable length iclogs, read first sector of
 		 * iclog header and extract the header size from it.  Get a
@@ -3386,7 +3386,7 @@ xlog_recover(
 	 * could not be verified. Check the superblock LSN against the current
 	 * LSN now that it's known.
 	 */
-	if (xfs_sb_version_hascrc(&log->l_mp->m_sb) &&
+	if (xfs_has_crc(log->l_mp) &&
 	    !xfs_log_check_lsn(log->l_mp, log->l_mp->m_sb.sb_lsn))
 		return -EINVAL;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ff53b3f2bf50..e85d5ccc3763 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -319,7 +319,7 @@ xfs_validate_new_dalign(
 		}
 	}
 
-	if (!xfs_sb_version_hasdalign(&mp->m_sb)) {
+	if (!xfs_has_dalign(mp)) {
 		xfs_warn(mp,
 "cannot change alignment: superblock does not support data alignment");
 		return -EINVAL;
@@ -351,7 +351,7 @@ xfs_update_alignment(
 		sbp->sb_width = mp->m_swidth;
 		mp->m_update_sb = true;
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
-		    xfs_sb_version_hasdalign(&mp->m_sb)) {
+		    xfs_has_dalign(mp)) {
 		mp->m_dalign = sbp->sb_unit;
 		mp->m_swidth = sbp->sb_width;
 	}
@@ -506,7 +506,7 @@ xfs_check_summary_counts(
 	 * superblock to be correct and we don't need to do anything here.
 	 * Otherwise, recalculate the summary counters.
 	 */
-	if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
+	if ((!xfs_has_lazysbcount(mp) ||
 	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
 	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
 		return 0;
@@ -619,6 +619,7 @@ xfs_mountfs(
 	/* always use v2 inodes by default now */
 	if (!(mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
 		mp->m_sb.sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
+		mp->m_features |= XFS_FEAT_NLINK;
 		mp->m_update_sb = true;
 	}
 
@@ -691,7 +692,7 @@ xfs_mountfs(
 	 * cluster size. Full inode chunk alignment must match the chunk size,
 	 * but that is checked on sb read verification...
 	 */
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	if (xfs_has_sparseinodes(mp) &&
 	    mp->m_sb.sb_spino_align !=
 			XFS_B_TO_FSBT(mp, igeo->inode_cluster_size_raw)) {
 		xfs_warn(mp,
@@ -786,7 +787,7 @@ xfs_mountfs(
 	 * behaviour specified by the superblock feature bit.
 	 */
 	if (!(mp->m_flags & (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) &&
-	    xfs_sb_version_hasattr2(&mp->m_sb))
+	    xfs_has_attr2(mp))
 		mp->m_flags |= XFS_MOUNT_ATTR2;
 
 	/*
@@ -1229,7 +1230,7 @@ void
 xfs_force_summary_recalc(
 	struct xfs_mount	*mp)
 {
-	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
+	if (!xfs_has_lazysbcount(mp))
 		return;
 
 	xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dd8cd4540781..e44ac7a870df 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -316,9 +316,9 @@ __XFS_HAS_FEAT(reflink, REFLINK)
 __XFS_HAS_FEAT(sparseinodes, SPINODES)
 __XFS_HAS_FEAT(metauuid, META_UUID)
 __XFS_HAS_FEAT(realtime, REALTIME)
-__XFS_HAS_FEAT(inobtcounts, REALTIME)
-__XFS_HAS_FEAT(bigtime, REALTIME)
-__XFS_HAS_FEAT(needsrepair, REALTIME)
+__XFS_HAS_FEAT(inobtcounts, INOBTCNT)
+__XFS_HAS_FEAT(bigtime, BIGTIME)
+__XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 
 /*
  * Flags for m_flags.
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 2bef4735d030..44d158d5d302 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -656,7 +656,7 @@ xfs_qm_init_quotainfo(
 	/* Precalc some constants */
 	qinf->qi_dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
 	qinf->qi_dqperchunk = xfs_calc_dquots_per_chunk(qinf->qi_dqchunklen);
-	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+	if (xfs_has_bigtime(mp)) {
 		qinf->qi_expiry_min =
 			xfs_dq_bigtime_to_unix(XFS_DQ_BIGTIME_EXPIRY_MIN);
 		qinf->qi_expiry_max =
@@ -749,7 +749,7 @@ xfs_qm_qino_alloc(
 	 * with PQUOTA, just use sb_gquotino for sb_pquotino and
 	 * vice-versa.
 	 */
-	if (!xfs_sb_version_has_pquotino(&mp->m_sb) &&
+	if (!xfs_has_pquotino(mp) &&
 			(flags & (XFS_QMOPT_PQUOTA|XFS_QMOPT_GQUOTA))) {
 		xfs_ino_t ino = NULLFSINO;
 
@@ -802,9 +802,9 @@ xfs_qm_qino_alloc(
 	 */
 	spin_lock(&mp->m_sb_lock);
 	if (flags & XFS_QMOPT_SBVERSION) {
-		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
+		ASSERT(!xfs_has_quota(mp));
 
-		xfs_sb_version_addquota(&mp->m_sb);
+		xfs_add_quota(mp);
 		mp->m_sb.sb_uquotino = NULLFSINO;
 		mp->m_sb.sb_gquotino = NULLFSINO;
 		mp->m_sb.sb_pquotino = NULLFSINO;
@@ -890,11 +890,11 @@ xfs_qm_reset_dqcounts(
 			ddq->d_bwarns = 0;
 			ddq->d_iwarns = 0;
 			ddq->d_rtbwarns = 0;
-			if (xfs_sb_version_hasbigtime(&mp->m_sb))
+			if (xfs_has_bigtime(mp))
 				ddq->d_type |= XFS_DQTYPE_BIGTIME;
 		}
 
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (xfs_has_crc(mp)) {
 			xfs_update_cksum((char *)&dqb[j],
 					 sizeof(struct xfs_dqblk),
 					 XFS_DQUOT_CRC_OFF);
@@ -1498,7 +1498,7 @@ xfs_qm_init_quotainos(
 	/*
 	 * Get the uquota and gquota inodes
 	 */
-	if (xfs_sb_version_hasquota(&mp->m_sb)) {
+	if (xfs_has_quota(mp)) {
 		if (XFS_IS_UQUOTA_ON(mp) &&
 		    mp->m_sb.sb_uquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_uquotino > 0);
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index df00dfbf5c9d..b77673dd0558 100644
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
index c6902f9d064c..47fe60e1a887 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -105,7 +105,7 @@ xfs_qm_scall_trunc_qfiles(
 {
 	int		error = -EINVAL;
 
-	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0 ||
+	if (!xfs_has_quota(mp) || flags == 0 ||
 	    (flags & ~XFS_QMOPT_QUOTALL)) {
 		xfs_debug(mp, "%s: flags=%x m_qflags=%x",
 			__func__, flags, mp->m_qflags);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 163615285b18..46904b793bd4 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -423,7 +423,7 @@ xfs_cui_validate_phys(
 	struct xfs_mount		*mp,
 	struct xfs_phys_extent		*refc)
 {
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return false;
 
 	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c256104772cb..76355f293488 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -759,7 +759,7 @@ xfs_reflink_recover_cow(
 	xfs_agnumber_t		agno;
 	int			error = 0;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return 0;
 
 	for_each_perag(mp, agno, pag) {
@@ -967,7 +967,7 @@ xfs_reflink_ag_has_free_space(
 	struct xfs_perag	*pag;
 	int			error = 0;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return 0;
 
 	pag = xfs_perag_get(mp, agno);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 9b91a788722a..5f0695980467 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -466,7 +466,7 @@ xfs_rui_validate_map(
 	struct xfs_mount		*mp,
 	struct xfs_map_extent		*rmap)
 {
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (!xfs_has_rmapbt(mp))
 		return false;
 
 	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f3eb4bf06423..b8c79ee791af 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -951,8 +951,7 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb) ||
-	    xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6ab985ee6ba2..bf9ca921ebed 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -485,7 +485,7 @@ xfs_setup_devices(
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
 		unsigned int	log_sector_size = BBSIZE;
 
-		if (xfs_sb_version_hassector(&mp->m_sb))
+		if (xfs_has_sector(mp))
 			log_sector_size = mp->m_sb.sb_logsectsize;
 		error = xfs_setsize_buftarg(mp->m_logdev_targp,
 					    log_sector_size);
@@ -939,7 +939,7 @@ xfs_finish_flags(
 	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
 
 	/* Fail a mount where the logbuf is smaller than the log stripe */
-	if (xfs_sb_version_haslogv2(&mp->m_sb)) {
+	if (xfs_has_logv2(mp)) {
 		if (mp->m_logbsize <= 0 &&
 		    mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE) {
 			mp->m_logbsize = mp->m_sb.sb_logsunit;
@@ -961,7 +961,7 @@ xfs_finish_flags(
 	/*
 	 * V5 filesystems always use attr2 format for attributes.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (xfs_has_crc(mp) &&
 	    (mp->m_flags & XFS_MOUNT_NOATTR2)) {
 		xfs_warn(mp, "Cannot mount a V5 filesystem as noattr2. "
 			     "attr2 is always enabled for V5 filesystems.");
@@ -979,7 +979,7 @@ xfs_finish_flags(
 
 	if ((mp->m_qflags & XFS_GQUOTA_ACCT) &&
 	    (mp->m_qflags & XFS_PQUOTA_ACCT) &&
-	    !xfs_sb_version_has_pquotino(&mp->m_sb)) {
+	    !xfs_has_pquotino(mp)) {
 		xfs_warn(mp,
 		  "Super block does not support project and group quota together");
 		return -EINVAL;
@@ -1497,7 +1497,7 @@ xfs_fs_fill_super(
 		goto out_free_sb;
 
 	/* V4 support is undergoing deprecation. */
-	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (!xfs_has_crc(mp)) {
 #ifdef CONFIG_XFS_SUPPORT_V4
 		xfs_warn_once(mp,
 	"Deprecated V4 format (crc=0) will not be supported after September 2030.");
@@ -1582,7 +1582,7 @@ xfs_fs_fill_super(
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
-	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+	if (xfs_has_bigtime(mp)) {
 		sb->s_time_min = xfs_bigtime_to_unix(XFS_BIGTIME_TIME_MIN);
 		sb->s_time_max = xfs_bigtime_to_unix(XFS_BIGTIME_TIME_MAX);
 	} else {
@@ -1614,7 +1614,7 @@ xfs_fs_fill_super(
 			"DAX unsupported by block device. Turning off DAX.");
 			xfs_mount_set_dax_mode(mp, XFS_DAX_NEVER);
 		}
-		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		if (xfs_has_reflink(mp)) {
 			xfs_alert(mp,
 		"DAX and reflink cannot be used together!");
 			error = -EINVAL;
@@ -1632,7 +1632,7 @@ xfs_fs_fill_super(
 		}
 	}
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		if (mp->m_sb.sb_rblocks) {
 			xfs_alert(mp,
 	"reflink not compatible with realtime device!");
@@ -1646,7 +1646,7 @@ xfs_fs_fill_super(
 		}
 	}
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks) {
+	if (xfs_has_rmapbt(mp) && mp->m_sb.sb_rblocks) {
 		xfs_alert(mp,
 	"reverse mapping btree not compatible with realtime device!");
 		error = -EINVAL;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 1525636f4065..707d36556bc5 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -63,7 +63,7 @@ xfs_readlink_bmap_ilocked(
 			byte_cnt = pathlen;
 
 		cur_chunk = bp->b_addr;
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (xfs_has_crc(mp)) {
 			if (!xfs_symlink_hdr_ok(ip->i_ino, offset,
 							byte_cnt, bp)) {
 				error = -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b52394b0e1f4..2aa0aae7d289 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -275,7 +275,7 @@ xfs_trans_alloc(
 	WARN_ON(resp->tr_logres > 0 &&
 		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
-	       xfs_sb_version_haslazysbcount(&mp->m_sb));
+	       xfs_has_lazysbcount(mp));
 
 	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
 	tp->t_flags = flags;
@@ -364,12 +364,12 @@ xfs_trans_mod_sb(
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
@@ -398,7 +398,7 @@ xfs_trans_mod_sb(
 			delta -= blkres_delta;
 		}
 		tp->t_fdblocks_delta += delta;
-		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		if (xfs_has_lazysbcount(mp))
 			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_RES_FDBLOCKS:
@@ -408,7 +408,7 @@ xfs_trans_mod_sb(
 		 * be applied to the on-disk superblock.
 		 */
 		tp->t_res_fdblocks_delta += delta;
-		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		if (xfs_has_lazysbcount(mp))
 			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_FREXTENTS:
@@ -487,7 +487,7 @@ xfs_trans_apply_sb_deltas(
 	/*
 	 * Only update the superblock counters if we are logging them
 	 */
-	if (!xfs_sb_version_haslazysbcount(&(tp->t_mountp->m_sb))) {
+	if (!xfs_has_lazysbcount((tp->t_mountp))) {
 		if (tp->t_icount_delta)
 			be64_add_cpu(&sbp->sb_icount, tp->t_icount_delta);
 		if (tp->t_ifree_delta)
@@ -585,7 +585,7 @@ xfs_trans_unreserve_and_mod_sb(
 	if (tp->t_blk_res > 0)
 		blkdelta = tp->t_blk_res;
 	if ((tp->t_fdblocks_delta != 0) &&
-	    (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
+	    (xfs_has_lazysbcount(mp) ||
 	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
 	        blkdelta += tp->t_fdblocks_delta;
 
@@ -595,7 +595,7 @@ xfs_trans_unreserve_and_mod_sb(
 	    (tp->t_flags & XFS_TRANS_SB_DIRTY))
 		rtxdelta += tp->t_frextents_delta;
 
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
+	if (xfs_has_lazysbcount(mp) ||
 	     (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
 		idelta = tp->t_icount_delta;
 		ifreedelta = tp->t_ifree_delta;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index eb76bc5bed9d..3872ce671411 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -58,7 +58,7 @@ xfs_trans_log_dquot(
 
 	/* Upgrade the dquot to bigtime format if possible. */
 	if (dqp->q_id != 0 &&
-	    xfs_sb_version_hasbigtime(&tp->t_mountp->m_sb) &&
+	    xfs_has_bigtime(tp->t_mountp) &&
 	    !(dqp->q_type & XFS_DQTYPE_BIGTIME))
 		dqp->q_type |= XFS_DQTYPE_BIGTIME;
 
-- 
2.31.1


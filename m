Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41746 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeAPXZG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 18:25:06 -0500
Date: Tue, 16 Jan 2018 15:25:02 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 17/21] xfs: cross-reference reverse-mapping btree
Message-ID: <20180116232502.GB5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398987679.18741.2129470901020229164.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398987679.18741.2129470901020229164.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

When scrubbing various btrees, we should cross-reference the records
with the reverse mapping btree and ensure that traversing the btree
finds the same number of blocks that the rmapbt thinks are owned by
that btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: fix indenting and standardize helper naming, refactor helpers per dave's suggestion
v2: streamline scrubber arguments, remove stack allocated objects
---
 fs/xfs/scrub/agheader.c |   68 +++++++++++++++++++++++-
 fs/xfs/scrub/alloc.c    |    1 
 fs/xfs/scrub/bmap.c     |  134 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/btree.c    |    4 +
 fs/xfs/scrub/common.c   |   53 +++++++++++++++++++
 fs/xfs/scrub/common.h   |    4 +
 fs/xfs/scrub/ialloc.c   |  103 +++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/inode.c    |    4 +
 fs/xfs/scrub/rmap.c     |   65 +++++++++++++++++++++++
 fs/xfs/scrub/scrub.h    |    8 +++
 10 files changed, 440 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 13ec76b..1d109d5 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -32,6 +32,7 @@
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_rmap.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -107,6 +108,7 @@ xfs_scrub_superblock_xref(
 	struct xfs_scrub_context	*sc,
 	struct xfs_buf			*bp)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
 	xfs_agnumber_t			agno = sc->sm->sm_agno;
 	xfs_agblock_t			agbno;
@@ -123,6 +125,8 @@ xfs_scrub_superblock_xref(
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
 	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -487,11 +491,58 @@ xfs_scrub_agf_xref_cntbt(
 		xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
 }
 
+/* Check the btree block counts in the AGF against the btrees. */
+STATIC void
+xfs_scrub_agf_xref_btreeblks(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	struct xfs_mount		*mp = sc->mp;
+	xfs_agblock_t			blocks;
+	xfs_agblock_t			btreeblks;
+	int				error;
+
+	/* Check agf_rmap_blocks; set up for agf_btreeblks check */
+	if (sc->sa.rmap_cur) {
+		error = xfs_btree_count_blocks(sc->sa.rmap_cur, &blocks);
+		if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+			return;
+		btreeblks = blocks - 1;
+		if (blocks != be32_to_cpu(agf->agf_rmap_blocks))
+			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+	} else {
+		btreeblks = 0;
+	}
+
+	/*
+	 * No rmap cursor; we can't xref if we have the rmapbt feature.
+	 * We also can't do it if we're missing the free space btree cursors.
+	 */
+	if ((xfs_sb_version_hasrmapbt(&mp->m_sb) && !sc->sa.rmap_cur) ||
+	    !sc->sa.bno_cur || !sc->sa.cnt_cur)
+		return;
+
+	/* Check agf_btreeblks */
+	error = xfs_btree_count_blocks(sc->sa.bno_cur, &blocks);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.bno_cur))
+		return;
+	btreeblks += blocks - 1;
+
+	error = xfs_btree_count_blocks(sc->sa.cnt_cur, &blocks);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.cnt_cur))
+		return;
+	btreeblks += blocks - 1;
+
+	if (btreeblks != be32_to_cpu(agf->agf_btreeblks))
+		xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_agf_xref(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
 	xfs_agblock_t			agbno;
 	int				error;
@@ -509,6 +560,9 @@ xfs_scrub_agf_xref(
 	xfs_scrub_agf_xref_freeblks(sc);
 	xfs_scrub_agf_xref_cntbt(sc);
 	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xfs_scrub_agf_xref_btreeblks(sc);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -599,6 +653,7 @@ xfs_scrub_agf(
 /* AGFL */
 
 struct xfs_scrub_agfl_info {
+	struct xfs_owner_info		oinfo;
 	unsigned int			sz_entries;
 	unsigned int			nr_entries;
 	xfs_agblock_t			*entries;
@@ -608,13 +663,15 @@ struct xfs_scrub_agfl_info {
 STATIC void
 xfs_scrub_agfl_block_xref(
 	struct xfs_scrub_context	*sc,
-	xfs_agblock_t			agbno)
+	xfs_agblock_t			agbno,
+	struct xfs_owner_info		*oinfo)
 {
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
 	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
+	xfs_scrub_xref_is_owned_by(sc, agbno, 1, oinfo);
 }
 
 /* Scrub an AGFL block. */
@@ -634,7 +691,7 @@ xfs_scrub_agfl_block(
 	else
 		xfs_scrub_block_set_corrupt(sc, sc->sa.agfl_bp);
 
-	xfs_scrub_agfl_block_xref(sc, agbno);
+	xfs_scrub_agfl_block_xref(sc, agbno, priv);
 
 	return 0;
 }
@@ -655,6 +712,7 @@ STATIC void
 xfs_scrub_agfl_xref(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
 	xfs_agblock_t			agbno;
 	int				error;
@@ -670,6 +728,8 @@ xfs_scrub_agfl_xref(
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
 	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
 
 	/*
 	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
@@ -717,6 +777,7 @@ xfs_scrub_agfl(
 	}
 
 	/* Check the blocks in the AGFL. */
+	xfs_rmap_ag_owner(&sai.oinfo, XFS_RMAP_OWN_AG);
 	error = xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sai);
 	if (error)
 		goto out_free;
@@ -770,6 +831,7 @@ STATIC void
 xfs_scrub_agi_xref(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
 	xfs_agblock_t			agbno;
 	int				error;
@@ -786,6 +848,8 @@ xfs_scrub_agi_xref(
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
 	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
 	xfs_scrub_agi_xref_icounts(sc);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 0031014..3faa437 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -105,6 +105,7 @@ xfs_scrub_allocbt_xref(
 
 	xfs_scrub_allocbt_xref_other(sc, agbno, len);
 	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, len);
+	xfs_scrub_xref_has_no_owner(sc, agbno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 6f1d145..933e0b8 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -99,6 +99,139 @@ struct xfs_scrub_bmap_info {
 	int				whichfork;
 };
 
+/* Look for a corresponding rmap for this irec. */
+static inline bool
+xfs_scrub_bmap_get_rmap(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_bmbt_irec		*irec,
+	xfs_agblock_t			agbno,
+	uint64_t			owner,
+	struct xfs_rmap_irec		*rmap)
+{
+	xfs_fileoff_t			offset;
+	unsigned int			rflags = 0;
+	int				has_rmap;
+	int				error;
+
+	if (info->whichfork == XFS_ATTR_FORK)
+		rflags |= XFS_RMAP_ATTR_FORK;
+
+	/*
+	 * CoW staging extents are owned (on disk) by the refcountbt, so
+	 * their rmaps do not have offsets.
+	 */
+	if (info->whichfork == XFS_COW_FORK)
+		offset = 0;
+	else
+		offset = irec->br_startoff;
+
+	/*
+	 * If the caller thinks this could be a shared bmbt extent (IOWs,
+	 * any data fork extent of a reflink inode) then we have to use the
+	 * range rmap lookup to make sure we get the correct owner/offset.
+	 */
+	if (info->is_shared) {
+		error = xfs_rmap_lookup_le_range(info->sc->sa.rmap_cur, agbno,
+				owner, offset, rflags, rmap, &has_rmap);
+		if (!xfs_scrub_should_check_xref(info->sc, &error,
+				&info->sc->sa.rmap_cur))
+			return false;
+		goto out;
+	}
+
+	/*
+	 * Otherwise, use the (faster) regular lookup.
+	 */
+	error = xfs_rmap_lookup_le(info->sc->sa.rmap_cur, agbno, 0, owner,
+			offset, rflags, &has_rmap);
+	if (!xfs_scrub_should_check_xref(info->sc, &error,
+			&info->sc->sa.rmap_cur))
+		return false;
+	if (!has_rmap)
+		goto out;
+
+	error = xfs_rmap_get_rec(info->sc->sa.rmap_cur, rmap, &has_rmap);
+	if (!xfs_scrub_should_check_xref(info->sc, &error,
+			&info->sc->sa.rmap_cur))
+		return false;
+
+out:
+	if (!has_rmap)
+		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+			irec->br_startoff);
+	return has_rmap;
+}
+
+/* Make sure that we have rmapbt records for this extent. */
+STATIC void
+xfs_scrub_bmap_xref_rmap(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_bmbt_irec		*irec,
+	xfs_agblock_t			agbno)
+{
+	struct xfs_rmap_irec		rmap;
+	unsigned long long		rmap_end;
+	uint64_t			owner;
+
+	if (!info->sc->sa.rmap_cur)
+		return;
+
+	if (info->whichfork == XFS_COW_FORK)
+		owner = XFS_RMAP_OWN_COW;
+	else
+		owner = info->sc->ip->i_ino;
+
+	/* Find the rmap record for this irec. */
+	if (!xfs_scrub_bmap_get_rmap(info, irec, agbno, owner, &rmap))
+		return;
+
+	/* Check the rmap. */
+	rmap_end = (unsigned long long)rmap.rm_startblock + rmap.rm_blockcount;
+	if (rmap.rm_startblock > agbno ||
+	    agbno + irec->br_blockcount > rmap_end)
+		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+
+	/*
+	 * Check the logical offsets if applicable.  CoW staging extents
+	 * don't track logical offsets since the mappings only exist in
+	 * memory.
+	 */
+	if (info->whichfork != XFS_COW_FORK) {
+		rmap_end = (unsigned long long)rmap.rm_offset +
+				rmap.rm_blockcount;
+		if (rmap.rm_offset > irec->br_startoff ||
+		    irec->br_startoff + irec->br_blockcount > rmap_end)
+			xfs_scrub_fblock_xref_set_corrupt(info->sc,
+					info->whichfork, irec->br_startoff);
+	}
+
+	if (rmap.rm_owner != owner)
+		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+
+	/*
+	 * Check for discrepancies between the unwritten flag in the irec and
+	 * the rmap.  Note that the (in-memory) CoW fork distinguishes between
+	 * unwritten and written extents, but we don't track that in the rmap
+	 * records because the blocks are owned (on-disk) by the refcountbt,
+	 * which doesn't track unwritten state.
+	 */
+	if (owner != XFS_RMAP_OWN_COW &&
+	    irec->br_state == XFS_EXT_UNWRITTEN &&
+	    !(rmap.rm_flags & XFS_RMAP_UNWRITTEN))
+		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+
+	if (info->whichfork == XFS_ATTR_FORK &&
+	    !(rmap.rm_flags & XFS_RMAP_ATTR_FORK))
+		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+	if (rmap.rm_flags & XFS_RMAP_BMBT_BLOCK)
+		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+}
+
 /* Cross-reference a single rtdev extent record. */
 STATIC void
 xfs_scrub_bmap_rt_extent_xref(
@@ -139,6 +272,7 @@ xfs_scrub_bmap_extent_xref(
 
 	xfs_scrub_xref_is_used_space(info->sc, agbno, len);
 	xfs_scrub_xref_is_not_inode_chunk(info->sc, agbno, len);
+	xfs_scrub_bmap_xref_rmap(info, irec, agbno);
 
 	xfs_scrub_ag_free(info->sc, &info->sc->sa);
 }
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 222e031..0589d4e 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -407,6 +407,10 @@ xfs_scrub_btree_check_block_owner(
 	if (!bs->sc->sa.bno_cur && btnum == XFS_BTNUM_BNO)
 		bs->cur = NULL;
 
+	xfs_scrub_xref_is_owned_by(bs->sc, agbno, 1, bs->oinfo);
+	if (!bs->sc->sa.rmap_cur && btnum == XFS_BTNUM_RMAP)
+		bs->cur = NULL;
+
 	if (init_sa)
 		xfs_scrub_ag_free(bs->sc, &bs->sc->sa);
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 68fea09..f5df8f2 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -325,6 +325,59 @@ xfs_scrub_set_incomplete(
 }
 
 /*
+ * rmap scrubbing -- compute the number of blocks with a given owner,
+ * at least according to the reverse mapping data.
+ */
+
+struct xfs_scrub_rmap_ownedby_info {
+	struct xfs_owner_info	*oinfo;
+	xfs_filblks_t		*blocks;
+};
+
+STATIC int
+xfs_scrub_count_rmap_ownedby_irec(
+	struct xfs_btree_cur			*cur,
+	struct xfs_rmap_irec			*rec,
+	void					*priv)
+{
+	struct xfs_scrub_rmap_ownedby_info	*sroi = priv;
+	bool					irec_attr;
+	bool					oinfo_attr;
+
+	irec_attr = rec->rm_flags & XFS_RMAP_ATTR_FORK;
+	oinfo_attr = sroi->oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK;
+
+	if (rec->rm_owner != sroi->oinfo->oi_owner)
+		return 0;
+
+	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) || irec_attr == oinfo_attr)
+		(*sroi->blocks) += rec->rm_blockcount;
+
+	return 0;
+}
+
+/*
+ * Calculate the number of blocks the rmap thinks are owned by something.
+ * The caller should pass us an rmapbt cursor.
+ */
+int
+xfs_scrub_count_rmap_ownedby_ag(
+	struct xfs_scrub_context		*sc,
+	struct xfs_btree_cur			*cur,
+	struct xfs_owner_info			*oinfo,
+	xfs_filblks_t				*blocks)
+{
+	struct xfs_scrub_rmap_ownedby_info	sroi;
+
+	sroi.oinfo = oinfo;
+	*blocks = 0;
+	sroi.blocks = blocks;
+
+	return xfs_rmap_query_all(cur, xfs_scrub_count_rmap_ownedby_irec,
+			&sroi);
+}
+
+/*
  * AG scrubbing
  *
  * These helpers facilitate locking an allocation group's header
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 84c302f..bf88a67 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -148,6 +148,10 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 			int (*fn)(struct xfs_scrub_context *, xfs_agblock_t bno,
 				  void *),
 			void *priv);
+int xfs_scrub_count_rmap_ownedby_ag(struct xfs_scrub_context *sc,
+				    struct xfs_btree_cur *cur,
+				    struct xfs_owner_info *oinfo,
+				    xfs_filblks_t *blocks);
 
 int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
 			     struct xfs_inode *ip, bool force_log);
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index bd7ba16..1a16f78 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -96,11 +96,15 @@ xfs_scrub_iallocbt_chunk_xref(
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
+	struct xfs_owner_info		oinfo;
+
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, len);
 	xfs_scrub_iallocbt_chunk_xref_other(sc, irec, agino);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+	xfs_scrub_xref_is_owned_by(sc, agbno, len, &oinfo);
 }
 
 /* Is this chunk worth checking? */
@@ -237,8 +241,14 @@ xfs_scrub_iallocbt_check_freemask(
 		}
 
 		/* If any part of this is a hole, skip it. */
-		if (ir_holemask)
+		if (ir_holemask) {
+			xfs_scrub_xref_is_not_owned_by(bs->sc, agbno,
+					blks_per_cluster, &oinfo);
 			continue;
+		}
+
+		xfs_scrub_xref_is_owned_by(bs->sc, agbno, blks_per_cluster,
+				&oinfo);
 
 		/* Grab the inode cluster buffer. */
 		imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno,
@@ -274,6 +284,7 @@ xfs_scrub_iallocbt_rec(
 	union xfs_btree_rec		*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
+	xfs_filblks_t			*inode_blocks = bs->private;
 	struct xfs_inobt_rec_incore	irec;
 	uint64_t			holes;
 	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
@@ -311,6 +322,9 @@ xfs_scrub_iallocbt_rec(
 	    (agbno & (xfs_icluster_size_fsb(mp) - 1)))
 		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
 
+	*inode_blocks += XFS_B_TO_FSB(mp,
+			irec.ir_count * mp->m_sb.sb_inodesize);
+
 	/* Handle non-sparse inodes */
 	if (!xfs_inobt_issparse(irec.ir_holemask)) {
 		len = XFS_B_TO_FSB(mp,
@@ -355,6 +369,72 @@ xfs_scrub_iallocbt_rec(
 	return error;
 }
 
+/*
+ * Make sure the inode btrees are as large as the rmap thinks they are.
+ * Don't bother if we're missing btree cursors, as we're already corrupt.
+ */
+STATIC void
+xfs_scrub_iallocbt_xref_rmap_btreeblks(
+	struct xfs_scrub_context	*sc,
+	int				which)
+{
+	struct xfs_owner_info		oinfo;
+	xfs_filblks_t			blocks;
+	xfs_extlen_t			inobt_blocks = 0;
+	xfs_extlen_t			finobt_blocks = 0;
+	int				error;
+
+	if (!sc->sa.ino_cur || !sc->sa.rmap_cur ||
+	    (xfs_sb_version_hasfinobt(&sc->mp->m_sb) && !sc->sa.fino_cur))
+		return;
+
+	/* Check that we saw as many inobt blocks as the rmap says. */
+	error = xfs_btree_count_blocks(sc->sa.ino_cur, &inobt_blocks);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.ino_cur))
+		return;
+
+	if (sc->sa.fino_cur) {
+		error = xfs_btree_count_blocks(sc->sa.fino_cur, &finobt_blocks);
+		if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.fino_cur))
+			return;
+	}
+
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
+	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
+			&blocks);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+		return;
+	if (blocks != inobt_blocks + finobt_blocks)
+		xfs_scrub_btree_set_corrupt(sc, sc->sa.ino_cur, 0);
+}
+
+/*
+ * Make sure that the inobt records point to the same number of blocks as
+ * the rmap says are owned by inodes.
+ */
+STATIC void
+xfs_scrub_iallocbt_xref_rmap_inodes(
+	struct xfs_scrub_context	*sc,
+	int				which,
+	xfs_filblks_t			inode_blocks)
+{
+	struct xfs_owner_info		oinfo;
+	xfs_filblks_t			blocks;
+	int				error;
+
+	if (!sc->sa.rmap_cur)
+		return;
+
+	/* Check that we saw as many inode blocks as the rmap knows about. */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
+			&blocks);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+		return;
+	if (blocks != inode_blocks)
+		xfs_scrub_btree_set_corrupt(sc, sc->sa.ino_cur, 0);
+}
+
 /* Scrub the inode btrees for some AG. */
 STATIC int
 xfs_scrub_iallocbt(
@@ -363,10 +443,29 @@ xfs_scrub_iallocbt(
 {
 	struct xfs_btree_cur		*cur;
 	struct xfs_owner_info		oinfo;
+	xfs_filblks_t			inode_blocks = 0;
+	int				error;
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
 	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
-	return xfs_scrub_btree(sc, cur, xfs_scrub_iallocbt_rec, &oinfo, NULL);
+	error = xfs_scrub_btree(sc, cur, xfs_scrub_iallocbt_rec, &oinfo,
+			&inode_blocks);
+	if (error)
+		return error;
+
+	xfs_scrub_iallocbt_xref_rmap_btreeblks(sc, which);
+
+	/*
+	 * If we're scrubbing the inode btree, inode_blocks is the number of
+	 * blocks pointed to by all the inode chunk records.  Therefore, we
+	 * should compare to the number of inode chunk blocks that the rmap
+	 * knows about.  We can't do this for the finobt since it only points
+	 * to inode chunks with free inodes.
+	 */
+	if (which == XFS_BTNUM_INO)
+		xfs_scrub_iallocbt_xref_rmap_inodes(sc, which, inode_blocks);
+
+	return error;
 }
 
 int
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index b48d5fb..6e99577 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -36,6 +36,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_da_format.h"
 #include "xfs_reflink.h"
+#include "xfs_rmap.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -632,6 +633,7 @@ xfs_scrub_inode_xref(
 	xfs_ino_t			ino,
 	struct xfs_dinode		*dip)
 {
+	struct xfs_owner_info		oinfo;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	int				error;
@@ -648,6 +650,8 @@ xfs_scrub_inode_xref(
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
 	xfs_scrub_inode_xref_finobt(sc, ino);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
 
 	xfs_scrub_ag_free(sc, &sc->sa);
 }
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 6e937ef..3ee5061 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -157,3 +157,68 @@ xfs_scrub_rmapbt(
 	return xfs_scrub_btree(sc, sc->sa.rmap_cur, xfs_scrub_rmapbt_rec,
 			&oinfo, NULL);
 }
+
+/* xref check that the extent is owned by a given owner */
+static inline void
+xfs_scrub_xref_check_owner(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	struct xfs_owner_info		*oinfo,
+	bool				should_have_rmap)
+{
+	bool				has_rmap;
+	int				error;
+
+	if (!sc->sa.rmap_cur)
+		return;
+
+	error = xfs_rmap_record_exists(sc->sa.rmap_cur, bno, len, oinfo,
+			&has_rmap);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+		return;
+	if (has_rmap != should_have_rmap)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+}
+
+/* xref check that the extent is owned by a given owner */
+void
+xfs_scrub_xref_is_owned_by(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	struct xfs_owner_info		*oinfo)
+{
+	xfs_scrub_xref_check_owner(sc, bno, len, oinfo, true);
+}
+
+/* xref check that the extent is not owned by a given owner */
+void
+xfs_scrub_xref_is_not_owned_by(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	struct xfs_owner_info		*oinfo)
+{
+	xfs_scrub_xref_check_owner(sc, bno, len, oinfo, false);
+}
+
+/* xref check that the extent has no reverse mapping at all */
+void
+xfs_scrub_xref_has_no_owner(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+	bool				has_rmap;
+	int				error;
+
+	if (!sc->sa.rmap_cur)
+		return;
+
+	error = xfs_rmap_has_record(sc->sa.rmap_cur, bno, len, &has_rmap);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+		return;
+	if (has_rmap)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 9b0033b..8fcf491 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -130,5 +130,13 @@ void xfs_scrub_xref_is_not_inode_chunk(struct xfs_scrub_context *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len);
 void xfs_scrub_xref_is_inode_chunk(struct xfs_scrub_context *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len);
+void xfs_scrub_xref_is_owned_by(struct xfs_scrub_context *sc,
+		xfs_agblock_t agbno, xfs_extlen_t len,
+		struct xfs_owner_info *oinfo);
+void xfs_scrub_xref_is_not_owned_by(struct xfs_scrub_context *sc,
+		xfs_agblock_t agbno, xfs_extlen_t len,
+		struct xfs_owner_info *oinfo);
+void xfs_scrub_xref_has_no_owner(struct xfs_scrub_context *sc,
+		xfs_agblock_t agbno, xfs_extlen_t len);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33550 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbeAIV23 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 16:28:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09LRBSR106684
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:28:29 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fd599046y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jan 2018 21:28:28 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w09LOo9S030011
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:24:50 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w09LOoPH032766
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:24:50 GMT
Date: Tue, 9 Jan 2018 13:24:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 17/21] xfs: cross-reference reverse-mapping btree
Message-ID: <20180109212449.GL5602@magnolia>
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

From: Darrick J. Wong <darrick.wong@oracle.com>

When scrubbing various btrees, we should cross-reference the records
with the reverse mapping btree and ensure that traversing the btree
finds the same number of blocks that the rmapbt thinks are owned by
that btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: streamline scrubber arguments, remove stack allocated objects
---
 fs/xfs/scrub/agheader.c |   68 ++++++++++++++++++++++++++++++-
 fs/xfs/scrub/alloc.c    |    1 
 fs/xfs/scrub/bmap.c     |  104 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/btree.c    |    1 
 fs/xfs/scrub/common.c   |   47 +++++++++++++++++++++
 fs/xfs/scrub/common.h   |    4 ++
 fs/xfs/scrub/ialloc.c   |   76 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode.c    |    4 ++
 fs/xfs/scrub/rmap.c     |   63 ++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h    |    8 ++++
 10 files changed, 373 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 4d4ce1f..6bc8121 100644
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
 	xfs_scrub_xref_not_inodes(sc, agbno, 1);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+	xfs_scrub_xref_owned_by(sc, agbno, 1, &oinfo);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -467,11 +471,57 @@ xfs_scrub_agf_xref_cntbt(
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
+	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.bno_cur))
+		btreeblks += blocks - 1;
+
+	error = xfs_btree_count_blocks(sc->sa.cnt_cur, &blocks);
+	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.cnt_cur))
+		btreeblks += blocks - 1;
+
+	if (sc->sa.bno_cur && sc->sa.cnt_cur &&
+	    btreeblks != be32_to_cpu(agf->agf_btreeblks))
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
 	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
 	xfs_agblock_t			agbno;
@@ -503,6 +553,9 @@ xfs_scrub_agf_xref(
 	xfs_scrub_agf_xref_cntbt(sc, agf);
 
 	xfs_scrub_xref_not_inodes(sc, agbno, 1);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+	xfs_scrub_xref_owned_by(sc, agbno, 1, &oinfo);
+	xfs_scrub_agf_xref_btreeblks(sc);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -593,6 +646,7 @@ xfs_scrub_agf(
 /* AGFL */
 
 struct xfs_scrub_agfl_info {
+	struct xfs_owner_info		oinfo;
 	unsigned int			sz_entries;
 	unsigned int			nr_entries;
 	xfs_agblock_t			*entries;
@@ -602,13 +656,15 @@ struct xfs_scrub_agfl_info {
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
 	xfs_scrub_xref_not_inodes(sc, agbno, 1);
+	xfs_scrub_xref_owned_by(sc, agbno, 1, oinfo);
 }
 
 /* Scrub an AGFL block. */
@@ -628,7 +684,7 @@ xfs_scrub_agfl_block(
 	else
 		xfs_scrub_block_set_corrupt(sc, sc->sa.agfl_bp);
 
-	xfs_scrub_agfl_block_xref(sc, agbno);
+	xfs_scrub_agfl_block_xref(sc, agbno, priv);
 
 	return 0;
 }
@@ -649,6 +705,7 @@ STATIC void
 xfs_scrub_agfl_xref(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
 	xfs_agblock_t			agbno;
 	int				error;
@@ -664,6 +721,8 @@ xfs_scrub_agfl_xref(
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
 	xfs_scrub_xref_not_inodes(sc, agbno, 1);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+	xfs_scrub_xref_owned_by(sc, agbno, 1, &oinfo);
 
 	/*
 	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
@@ -711,6 +770,7 @@ xfs_scrub_agfl(
 	}
 
 	/* Check the blocks in the AGFL. */
+	xfs_rmap_ag_owner(&sai.oinfo, XFS_RMAP_OWN_AG);
 	error = xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sai);
 	if (error)
 		goto out_free;
@@ -743,6 +803,7 @@ STATIC void
 xfs_scrub_agi_xref(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_agi			*agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
 	xfs_agblock_t			agbno;
@@ -772,6 +833,9 @@ xfs_scrub_agi_xref(
 			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agi_bp);
 	}
 
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+	xfs_scrub_xref_owned_by(sc, agbno, 1, &oinfo);
+
 	/* scrub teardown will take care of sc->sa for us */
 }
 
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 2a58558..b4defa4 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -105,6 +105,7 @@ xfs_scrub_allocbt_xref(
 
 	xfs_scrub_allocbt_xref_other(sc, agbno, len);
 	xfs_scrub_xref_not_inodes(sc, agbno, len);
+	xfs_scrub_xref_no_rmap(sc, agbno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index d2b4747..ef7b461 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -99,6 +99,109 @@ struct xfs_scrub_bmap_info {
 	int				whichfork;
 };
 
+/* Make sure that we have rmapbt records for this extent. */
+STATIC void
+xfs_scrub_bmap_xref_rmap(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_bmbt_irec		*irec,
+	xfs_fsblock_t			bno)
+{
+	struct xfs_rmap_irec		rmap;
+	uint64_t			owner;
+	xfs_fileoff_t			offset;
+	unsigned long long		rmap_end;
+	unsigned int			rflags;
+	int				has_rmap;
+	int				error;
+
+	if (!info->sc->sa.rmap_cur)
+		return;
+
+	if (info->whichfork == XFS_COW_FORK) {
+		owner = XFS_RMAP_OWN_COW;
+		offset = 0;
+	} else {
+		owner = info->sc->ip->i_ino;
+		offset = irec->br_startoff;
+	}
+
+	/* Look for a corresponding rmap. */
+	rflags = 0;
+	if (info->whichfork == XFS_ATTR_FORK)
+		rflags |= XFS_RMAP_ATTR_FORK;
+
+	if (info->is_shared) {
+		error = xfs_rmap_lookup_le_range(info->sc->sa.rmap_cur, bno,
+				owner, offset, rflags, &rmap, &has_rmap);
+		if (!xfs_scrub_should_check_xref(info->sc, &error,
+				&info->sc->sa.rmap_cur))
+			return;
+		if (!has_rmap) {
+			xfs_scrub_fblock_xref_set_corrupt(info->sc,
+					info->whichfork, irec->br_startoff);
+			return;
+		}
+	} else {
+		error = xfs_rmap_lookup_le(info->sc->sa.rmap_cur, bno, 0, owner,
+				offset, rflags, &has_rmap);
+		if (!xfs_scrub_should_check_xref(info->sc, &error,
+				&info->sc->sa.rmap_cur))
+			return;
+		if (!has_rmap) {
+			xfs_scrub_fblock_xref_set_corrupt(info->sc,
+					info->whichfork, irec->br_startoff);
+			return;
+		}
+
+		error = xfs_rmap_get_rec(info->sc->sa.rmap_cur, &rmap,
+				&has_rmap);
+		if (!xfs_scrub_should_check_xref(info->sc, &error,
+				&info->sc->sa.rmap_cur))
+			return;
+		if (!has_rmap) {
+			xfs_scrub_fblock_xref_set_corrupt(info->sc,
+					info->whichfork, irec->br_startoff);
+			return;
+		}
+	}
+
+	/* Check the rmap. */
+	rmap_end = (unsigned long long)rmap.rm_startblock + rmap.rm_blockcount;
+	if (rmap.rm_startblock > bno ||
+	    bno + irec->br_blockcount > rmap_end)
+		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+
+	if (owner != XFS_RMAP_OWN_COW) {
+		rmap_end = (unsigned long long)rmap.rm_offset +
+				rmap.rm_blockcount;
+		if (rmap.rm_offset > offset ||
+		    offset + irec->br_blockcount > rmap_end)
+			xfs_scrub_fblock_xref_set_corrupt(info->sc,
+					info->whichfork, irec->br_startoff);
+	} else {
+		/*
+		 * We don't set the unwritten flag for CoW
+		 * staging extent rmaps; everything is unwritten.
+		 */
+		irec->br_state = XFS_EXT_NORM;
+	}
+	if (rmap.rm_owner != owner)
+		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+	if (irec->br_state == XFS_EXT_UNWRITTEN &&
+	    !(rmap.rm_flags & XFS_RMAP_UNWRITTEN))
+		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
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
@@ -139,6 +242,7 @@ xfs_scrub_bmap_extent_xref(
 
 	xfs_scrub_xref_is_used_space(info->sc, agbno, len);
 	xfs_scrub_xref_not_inodes(info->sc, agbno, len);
+	xfs_scrub_bmap_xref_rmap(info, irec, agbno);
 
 	xfs_scrub_ag_free(info->sc, &info->sc->sa);
 }
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 3dbac4c..1bdfa99 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -393,6 +393,7 @@ xfs_scrub_btree_check_block_owner(
 
 	/* Cross-reference with the bnobt. */
 	xfs_scrub_xref_is_used_space(bs->sc, agbno, 1);
+	xfs_scrub_xref_owned_by(bs->sc, agbno, 1, bs->oinfo);
 
 	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		xfs_scrub_ag_free(bs->sc, &bs->sc->sa);
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 68fea09..d3aaa6a 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -325,6 +325,53 @@ xfs_scrub_set_incomplete(
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
+xfs_scrub_count_rmap_ownedby_helper(
+	struct xfs_btree_cur			*cur,
+	struct xfs_rmap_irec			*rec,
+	void					*priv)
+{
+	struct xfs_scrub_rmap_ownedby_info	*sroi = priv;
+
+	if (rec->rm_owner == sroi->oinfo->oi_owner &&
+	    (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
+	     !!(rec->rm_flags & XFS_RMAP_ATTR_FORK) ==
+	     !!(sroi->oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK)))
+		(*sroi->blocks) += rec->rm_blockcount;
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
+	return xfs_rmap_query_all(cur, xfs_scrub_count_rmap_ownedby_helper,
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
index 34c133e..30603b4 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -67,6 +67,7 @@ xfs_scrub_iallocbt_chunk_xref(
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_btree_cur		**pcur;
 	bool				has_irec;
 	int				error;
@@ -93,6 +94,9 @@ xfs_scrub_iallocbt_chunk_xref(
 		     (irec->ir_freecount == 0 && has_irec)))
 			xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
 	}
+
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+	xfs_scrub_xref_owned_by(sc, agbno, len, &oinfo);
 }
 
 /* Is this chunk worth checking? */
@@ -228,6 +232,13 @@ xfs_scrub_iallocbt_check_freemask(
 			continue;
 		}
 
+		if (ir_holemask == 0)
+			xfs_scrub_xref_owned_by(bs->sc, agbno,
+					blks_per_cluster, &oinfo);
+		else
+			xfs_scrub_xref_not_owned_by(bs->sc, agbno,
+					blks_per_cluster, &oinfo);
+
 		/* If any part of this is a hole, skip it. */
 		if (ir_holemask)
 			continue;
@@ -266,6 +277,7 @@ xfs_scrub_iallocbt_rec(
 	union xfs_btree_rec		*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
+	xfs_filblks_t			*inode_blocks = bs->private;
 	struct xfs_inobt_rec_incore	irec;
 	uint64_t			holes;
 	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
@@ -302,6 +314,8 @@ xfs_scrub_iallocbt_rec(
 	if ((agbno & (xfs_ialloc_cluster_alignment(mp) - 1)) ||
 	    (agbno & (xfs_icluster_size_fsb(mp) - 1)))
 		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+	*inode_blocks += XFS_B_TO_FSB(mp,
+			irec.ir_count * mp->m_sb.sb_inodesize);
 
 	/* Handle non-sparse inodes */
 	if (!xfs_inobt_issparse(irec.ir_holemask)) {
@@ -347,6 +361,56 @@ xfs_scrub_iallocbt_rec(
 	return error;
 }
 
+/*
+ * Make sure the inode btrees are as large as the rmap thinks they are.
+ * Don't bother if we're missing btree cursors, as we're already corrupt.
+ */
+STATIC void
+xfs_scrub_iallocbt_xref_rmap(
+	struct xfs_scrub_context	*sc,
+	int				which,
+	struct xfs_owner_info		*oinfo,
+	xfs_filblks_t			inode_blocks)
+{
+	xfs_filblks_t			blocks;
+	xfs_extlen_t			inobt_blocks = 0;
+	xfs_extlen_t			finobt_blocks = 0;
+	int				error;
+
+	if (!sc->sa.ino_cur || !sc->sa.rmap_cur)
+		return;
+
+	/* Check that we saw as many inobt blocks as the rmap says. */
+	error = xfs_btree_count_blocks(sc->sa.ino_cur, &inobt_blocks);
+	if (error)
+		return;
+
+	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb)) {
+		if (!sc->sa.fino_cur)
+			return;
+		error = xfs_btree_count_blocks(sc->sa.fino_cur, &finobt_blocks);
+		if (error)
+			return;
+	}
+
+	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
+			&blocks);
+	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur) &&
+	    blocks != inobt_blocks + finobt_blocks)
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	if (!sc->sa.rmap_cur)
+		return;
+
+	/* Check that we saw as many inode blocks as the rmap knows about. */
+	xfs_rmap_ag_owner(oinfo, XFS_RMAP_OWN_INODES);
+	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
+			&blocks);
+	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur) &&
+	    blocks != inode_blocks)
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+}
+
 /* Scrub the inode btrees for some AG. */
 STATIC int
 xfs_scrub_iallocbt(
@@ -355,10 +419,20 @@ xfs_scrub_iallocbt(
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
+	if (which == XFS_BTNUM_INO)
+		xfs_scrub_iallocbt_xref_rmap(sc, which, &oinfo, inode_blocks);
+
+	return error;
 }
 
 int
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index b48d5fb..fc546f2 100644
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
+	xfs_scrub_xref_owned_by(sc, agbno, 1, &oinfo);
 
 	xfs_scrub_ag_free(sc, &sc->sa);
 }
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 02704b0..8421c6e 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -157,3 +157,66 @@ xfs_scrub_rmapbt(
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
+	bool				fs_ok)
+{
+	bool				has_rmap;
+	int				error;
+
+	if (!sc->sa.rmap_cur)
+		return;
+
+	error = xfs_rmap_record_exists(sc->sa.rmap_cur, bno, len, oinfo,
+			&has_rmap);
+	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur) &&
+			has_rmap != fs_ok)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+}
+
+/* xref check that the extent is owned by a given owner */
+void
+xfs_scrub_xref_owned_by(
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
+xfs_scrub_xref_not_owned_by(
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
+xfs_scrub_xref_no_rmap(
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
+	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur) &&
+	    has_rmap)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 340273f..53cc526 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -130,5 +130,13 @@ void xfs_scrub_xref_not_inodes(struct xfs_scrub_context *sc,
 		xfs_agblock_t bno, xfs_extlen_t len);
 void xfs_scrub_xref_are_inodes(struct xfs_scrub_context *sc,
 		xfs_agblock_t bno, xfs_extlen_t len);
+void xfs_scrub_xref_owned_by(struct xfs_scrub_context *sc,
+		xfs_agblock_t bno, xfs_extlen_t len,
+		struct xfs_owner_info *oinfo);
+void xfs_scrub_xref_not_owned_by(struct xfs_scrub_context *sc,
+		xfs_agblock_t bno, xfs_extlen_t len,
+		struct xfs_owner_info *oinfo);
+void xfs_scrub_xref_no_rmap(struct xfs_scrub_context *sc,
+		xfs_agblock_t bno, xfs_extlen_t len);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

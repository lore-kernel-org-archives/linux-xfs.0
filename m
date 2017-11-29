Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20071 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751846AbdK2B0f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:26:35 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT1QYE6015557
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:26:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1QXMv014789
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:26:33 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1QXWI027516
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:26:33 GMT
Subject: [PATCH 11/16] xfs: cross-reference reverse-mapping btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Nov 2017 17:26:32 -0800
Message-ID: <151191879207.8553.9863176615926190438.stgit@magnolia>
In-Reply-To: <151191872395.8553.15627872818207535470.stgit@magnolia>
References: <151191872395.8553.15627872818207535470.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When scrubbing various btrees, we should cross-reference the records
with the reverse mapping btree and ensure that traversing the btree
finds the same number of blocks that the rmapbt thinks are owned by
that btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   70 +++++++++++++++++++++++++++++++-
 fs/xfs/scrub/alloc.c    |    1 
 fs/xfs/scrub/bmap.c     |  102 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/btree.c    |    2 +
 fs/xfs/scrub/common.c   |   47 ++++++++++++++++++++++
 fs/xfs/scrub/common.h   |    4 ++
 fs/xfs/scrub/ialloc.c   |   74 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode.c    |    4 ++
 fs/xfs/scrub/rmap.c     |   64 +++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h    |    9 ++++
 10 files changed, 374 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 3204158..a84989cf 100644
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
@@ -124,6 +125,7 @@ xfs_scrub_superblock_xref(
 	struct xfs_scrub_context	*sc,
 	struct xfs_buf			*bp)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
 	xfs_agnumber_t			agno = sc->sm->sm_agno;
 	xfs_agblock_t			bno;
@@ -138,6 +140,8 @@ xfs_scrub_superblock_xref(
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, bno, 1, &oinfo);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -437,11 +441,59 @@ xfs_scrub_agf_record_bno_lengths(
 	return 0;
 }
 
+/* Check the btree block counts in the AGF against the btrees. */
+STATIC void
+xfs_scrub_agf_xref_btreeblks(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_btree_cur		**pcur;
+	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	struct xfs_mount		*mp = sc->mp;
+	xfs_agblock_t			blocks;
+	xfs_agblock_t			btreeblks;
+	int				error;
+
+	/* Check agf_rmap_blocks; set up for agf_btreeblks check */
+	pcur = &sc->sa.rmap_cur;
+	if (*pcur) {
+		error = xfs_btree_count_blocks(*pcur, &blocks);
+		if (!xfs_scrub_should_xref(sc, &error, pcur))
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
+	if (xfs_scrub_should_xref(sc, &error, &sc->sa.bno_cur))
+		btreeblks += blocks - 1;
+
+	error = xfs_btree_count_blocks(sc->sa.cnt_cur, &blocks);
+	if (xfs_scrub_should_xref(sc, &error, &sc->sa.cnt_cur))
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
 	struct xfs_btree_cur		**pcur;
@@ -496,6 +548,9 @@ xfs_scrub_agf_xref(
 
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, bno, 1, &oinfo);
+	xfs_scrub_agf_xref_btreeblks(sc);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -589,6 +644,7 @@ xfs_scrub_agf(
 /* AGFL */
 
 struct xfs_scrub_agfl_info {
+	struct xfs_owner_info		oinfo;
 	unsigned int			sz_entries;
 	unsigned int			nr_entries;
 	xfs_agblock_t			*entries;
@@ -598,11 +654,13 @@ struct xfs_scrub_agfl_info {
 STATIC void
 xfs_scrub_agfl_block_xref(
 	struct xfs_scrub_context	*sc,
-	xfs_agblock_t			bno)
+	xfs_agblock_t			bno,
+	struct xfs_owner_info		*oinfo)
 {
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
+	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, bno, 1, oinfo);
 }
 
 /* Scrub an AGFL block. */
@@ -625,7 +683,7 @@ xfs_scrub_agfl_block(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 
-	xfs_scrub_agfl_block_xref(sc, agbno);
+	xfs_scrub_agfl_block_xref(sc, agbno, priv);
 out:
 	return 0;
 }
@@ -646,6 +704,7 @@ STATIC void
 xfs_scrub_agfl_xref(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
 	xfs_agblock_t			bno;
 	int				error;
@@ -659,6 +718,8 @@ xfs_scrub_agfl_xref(
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, bno, 1, &oinfo);
 
 	/*
 	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
@@ -706,6 +767,7 @@ xfs_scrub_agfl(
 	}
 
 	/* Check the blocks in the AGFL. */
+	xfs_rmap_ag_owner(&sai.oinfo, XFS_RMAP_OWN_AG);
 	error = xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sai);
 	if (error)
 		goto out_free;
@@ -738,6 +800,7 @@ STATIC void
 xfs_scrub_agi_xref(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_btree_cur		**pcur;
 	struct xfs_agi			*agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
@@ -766,6 +829,9 @@ xfs_scrub_agi_xref(
 			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agi_bp);
 	}
 
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, bno, 1, &oinfo);
+
 	/* scrub teardown will take care of sc->sa for us */
 }
 
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index cd709f4..a4046c1 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -97,6 +97,7 @@ xfs_scrub_allocbt_xref(
 
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, len);
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, len);
+	xfs_scrub_xref_no_rmap(sc, &sc->sa.rmap_cur, bno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index a0274d3..f408193 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -99,6 +99,107 @@ struct xfs_scrub_bmap_info {
 	int				whichfork;
 };
 
+/* Make sure that we have rmapbt records for this extent. */
+STATIC void
+xfs_scrub_bmap_xref_rmap(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_scrub_ag		*sa,
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
+	if (!sa->rmap_cur)
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
+		error = xfs_rmap_lookup_le_range(sa->rmap_cur, bno, owner,
+				offset, rflags, &rmap,
+				&has_rmap);
+		if (!xfs_scrub_should_xref(info->sc, &error, &sa->rmap_cur))
+			return;
+		if (!has_rmap) {
+			xfs_scrub_fblock_xref_set_corrupt(info->sc,
+					info->whichfork, irec->br_startoff);
+			return;
+		}
+	} else {
+		error = xfs_rmap_lookup_le(sa->rmap_cur, bno, 0, owner,
+				offset, rflags, &has_rmap);
+		if (!xfs_scrub_should_xref(info->sc, &error, &sa->rmap_cur))
+			return;
+		if (!has_rmap) {
+			xfs_scrub_fblock_xref_set_corrupt(info->sc,
+					info->whichfork, irec->br_startoff);
+			return;
+		}
+
+		error = xfs_rmap_get_rec(sa->rmap_cur, &rmap, &has_rmap);
+		if (!xfs_scrub_should_xref(info->sc, &error, &sa->rmap_cur))
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
@@ -136,6 +237,7 @@ xfs_scrub_bmap_extent_xref(
 	xfs_scrub_xref_not_free(info->sc, &sa.bno_cur, agbno, len);
 	xfs_scrub_xref_not_inodes(info->sc, &sa.ino_cur, agbno, len);
 	xfs_scrub_xref_not_inodes(info->sc, &sa.fino_cur, agbno, len);
+	xfs_scrub_bmap_xref_rmap(info, &sa, irec, agbno);
 
 	xfs_scrub_ag_free(info->sc, &sa);
 }
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 67b6248..26149cb 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -404,6 +404,8 @@ xfs_scrub_btree_check_block_owner(
 					0);
 	}
 
+	xfs_scrub_xref_owned_by(bs->sc, &psa->rmap_cur, bno, 1, bs->oinfo);
+
 	if (psa == &sa)
 		xfs_scrub_ag_free(bs->sc, &sa);
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 9d6730f..1ebdfc2 100644
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
index 47576d9..6372456 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -150,6 +150,10 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
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
index da07393..d4b7f13 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -67,6 +67,7 @@ xfs_scrub_iallocbt_chunk_xref(
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_btree_cur		**pcur;
 	bool				has_irec;
 	int				error;
@@ -90,6 +91,9 @@ xfs_scrub_iallocbt_chunk_xref(
 		     (irec->ir_freecount == 0 && has_irec)))
 			xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
 	}
+
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, bno, len, &oinfo);
 }
 
 /* Is this chunk worth checking? */
@@ -228,6 +232,14 @@ xfs_scrub_iallocbt_check_freemask(
 			continue;
 		}
 
+		if (ir_holemask == 0)
+			xfs_scrub_xref_owned_by(bs->sc, &bs->sc->sa.rmap_cur,
+					agbno, blks_per_cluster, &oinfo);
+		else
+			xfs_scrub_xref_not_owned_by(bs->sc,
+					&bs->sc->sa.rmap_cur,
+					agbno, blks_per_cluster, &oinfo);
+
 		/* If any part of this is a hole, skip it. */
 		if (ir_holemask)
 			continue;
@@ -266,6 +278,7 @@ xfs_scrub_iallocbt_rec(
 	union xfs_btree_rec		*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
+	xfs_filblks_t			*inode_blocks = bs->private;
 	struct xfs_inobt_rec_incore	irec;
 	uint64_t			holes;
 	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
@@ -302,6 +315,8 @@ xfs_scrub_iallocbt_rec(
 	if ((agbno & (xfs_ialloc_cluster_alignment(mp) - 1)) ||
 	    (agbno & (xfs_icluster_size_fsb(mp) - 1)))
 		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+	*inode_blocks += XFS_B_TO_FSB(mp,
+			irec.ir_count * mp->m_sb.sb_inodesize);
 
 	/* Handle non-sparse inodes */
 	if (!xfs_inobt_issparse(irec.ir_holemask)) {
@@ -346,6 +361,53 @@ xfs_scrub_iallocbt_rec(
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
+	if (xfs_scrub_should_xref(sc, &error, &sc->sa.rmap_cur) &&
+	    blocks != inobt_blocks + finobt_blocks)
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+
+	/* Check that we saw as many inode blocks as the rmap knows about. */
+	xfs_rmap_ag_owner(oinfo, XFS_RMAP_OWN_INODES);
+	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
+			&blocks);
+	if (xfs_scrub_should_xref(sc, &error, &sc->sa.rmap_cur) &&
+	    blocks != inode_blocks)
+		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+}
+
 /* Scrub the inode btrees for some AG. */
 STATIC int
 xfs_scrub_iallocbt(
@@ -354,10 +416,20 @@ xfs_scrub_iallocbt(
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
index 687c3fd..bec67f4 100644
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
@@ -563,6 +564,7 @@ xfs_scrub_inode_xref(
 	struct xfs_dinode		*dip)
 {
 	struct xfs_scrub_ag		sa = { 0 };
+	struct xfs_owner_info		oinfo;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	int				error;
@@ -577,6 +579,8 @@ xfs_scrub_inode_xref(
 	xfs_scrub_xref_not_free(sc, &sa.bno_cur, agbno, 1);
 	xfs_scrub_xref_are_inodes(sc, &sc->sa.ino_cur, agbno, 1);
 	xfs_scrub_xref_are_inodes(sc, &sc->sa.fino_cur, agbno, 1);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, agbno, 1, &oinfo);
 
 	xfs_scrub_ag_free(sc, &sa);
 }
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 8d49556..7970e73 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -159,3 +159,67 @@ xfs_scrub_rmapbt(
 	return xfs_scrub_btree(sc, sc->sa.rmap_cur, xfs_scrub_rmapbt_rec,
 			&oinfo, NULL);
 }
+
+/* xref check that the extent is owned by a given owner */
+static inline void
+xfs_scrub_xref_check_owner(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		**pcur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	struct xfs_owner_info		*oinfo,
+	bool				fs_ok)
+{
+	bool				has_rmap;
+	int				error;
+
+	if (!(*pcur))
+		return;
+
+	error = xfs_rmap_record_exists(*pcur, bno, len, oinfo, &has_rmap);
+	if (xfs_scrub_should_xref(sc, &error, pcur) && has_rmap != fs_ok)
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+}
+
+/* xref check that the extent is owned by a given owner */
+void
+xfs_scrub_xref_owned_by(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		**pcur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	struct xfs_owner_info		*oinfo)
+{
+	xfs_scrub_xref_check_owner(sc, pcur, bno, len, oinfo, true);
+}
+
+/* xref check that the extent is not owned by a given owner */
+void
+xfs_scrub_xref_not_owned_by(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		**pcur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	struct xfs_owner_info		*oinfo)
+{
+	xfs_scrub_xref_check_owner(sc, pcur, bno, len, oinfo, false);
+}
+
+/* xref check that the extent has no reverse mapping at all */
+void
+xfs_scrub_xref_no_rmap(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		**pcur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+	bool				has_rmap;
+	int				error;
+
+	if (!(*pcur))
+		return;
+
+	error = xfs_rmap_has_record(*pcur, bno, len, &has_rmap);
+	if (xfs_scrub_should_xref(sc, &error, pcur) && has_rmap)
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index b1ed843..605b1c2 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -122,5 +122,14 @@ void xfs_scrub_xref_not_inodes(struct xfs_scrub_context *sc,
 void xfs_scrub_xref_are_inodes(struct xfs_scrub_context *sc,
 		struct xfs_btree_cur **pcur, xfs_agblock_t bno,
 		xfs_extlen_t len);
+void xfs_scrub_xref_owned_by(struct xfs_scrub_context *sc,
+		struct xfs_btree_cur **pcur, xfs_agblock_t bno,
+		xfs_extlen_t len, struct xfs_owner_info *oinfo);
+void xfs_scrub_xref_not_owned_by(struct xfs_scrub_context *sc,
+		struct xfs_btree_cur **pcur, xfs_agblock_t bno,
+		xfs_extlen_t len, struct xfs_owner_info *oinfo);
+void xfs_scrub_xref_no_rmap(struct xfs_scrub_context *sc,
+		struct xfs_btree_cur **pcur, xfs_agblock_t bno,
+		xfs_extlen_t len);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */


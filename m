Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44620 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757643AbeAIVAV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 16:00:21 -0500
Date: Tue, 9 Jan 2018 13:00:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 13/21] xfs: introduce scrubber cross-referencing stubs
Message-ID: <20180109210012.GH5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398985228.18741.6364419677377927534.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398985228.18741.6364419677377927534.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Create some stubs that will be used to cross-reference metadata records.
The actual cross-referencing will be filled in by subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: move the OFLAG_CORRUPT checks into the helpers to clean up the call sites
---
 fs/xfs/scrub/agheader.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/alloc.c    |   13 ++++++++++
 fs/xfs/scrub/bmap.c     |   29 ++++++++++++++++++++++
 fs/xfs/scrub/ialloc.c   |   15 +++++++++++
 fs/xfs/scrub/inode.c    |   12 +++++++++
 fs/xfs/scrub/refcount.c |   14 ++++++++++
 fs/xfs/scrub/rmap.c     |   12 +++++++++
 7 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 97beb47..1477aad 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -37,7 +37,10 @@
 #include "scrub/common.h"
 #include "scrub/trace.h"
 
-/* Walk all the blocks in the AGFL. */
+/*
+ * Walk all the blocks in the AGFL.  The fn function can return any negative
+ * error code or XFS_BTREE_QUERY_RANGE_ABORT.
+ */
 int
 xfs_scrub_walk_agfl(
 	struct xfs_scrub_context	*sc,
@@ -98,6 +101,16 @@ xfs_scrub_walk_agfl(
 
 /* Superblock */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_superblock_xref(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+}
+
 /*
  * Scrub the filesystem superblock.
  *
@@ -386,11 +399,22 @@ xfs_scrub_superblock(
 			BBTOB(bp->b_length) - sizeof(struct xfs_dsb)))
 		xfs_scrub_block_set_corrupt(sc, bp);
 
+	xfs_scrub_superblock_xref(sc, bp);
+
 	return error;
 }
 
 /* AGF */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_agf_xref(
+	struct xfs_scrub_context	*sc)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+}
+
 /* Scrub the AGF. */
 int
 xfs_scrub_agf(
@@ -469,6 +493,7 @@ xfs_scrub_agf(
 	if (agfl_count != 0 && fl_count != agfl_count)
 		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
 
+	xfs_scrub_agf_xref(sc);
 out:
 	return error;
 }
@@ -481,6 +506,16 @@ struct xfs_scrub_agfl_info {
 	xfs_agblock_t			*entries;
 };
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_agfl_block_xref(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+}
+
 /* Scrub an AGFL block. */
 STATIC int
 xfs_scrub_agfl_block(
@@ -498,6 +533,8 @@ xfs_scrub_agfl_block(
 	else
 		xfs_scrub_block_set_corrupt(sc, sc->sa.agfl_bp);
 
+	xfs_scrub_agfl_block_xref(sc, agbno);
+
 	return 0;
 }
 
@@ -512,6 +549,15 @@ xfs_scrub_agblock_cmp(
 	return (int)*a - (int)*b;
 }
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_agfl_xref(
+	struct xfs_scrub_context	*sc)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+}
+
 /* Scrub the AGFL. */
 int
 xfs_scrub_agfl(
@@ -532,6 +578,11 @@ xfs_scrub_agfl(
 	if (!sc->sa.agf_bp)
 		return -EFSCORRUPTED;
 
+	xfs_scrub_agfl_xref(sc);
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
 	/* Allocate buffer to ensure uniqueness of AGFL entries. */
 	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
 	agflcount = be32_to_cpu(agf->agf_flcount);
@@ -574,6 +625,15 @@ xfs_scrub_agfl(
 
 /* AGI */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_agi_xref(
+	struct xfs_scrub_context	*sc)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+}
+
 /* Scrub the AGI. */
 int
 xfs_scrub_agi(
@@ -652,6 +712,7 @@ xfs_scrub_agi(
 	if (agi->agi_pad32 != cpu_to_be32(0))
 		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
 
+	xfs_scrub_agi_xref(sc);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 059663e..03ed403 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -50,6 +50,17 @@ xfs_scrub_setup_ag_allocbt(
 
 /* Free space btree scrubber. */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_allocbt_xref(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+}
+
 /* Scrub a bnobt/cntbt record. */
 STATIC int
 xfs_scrub_allocbt_rec(
@@ -70,6 +81,8 @@ xfs_scrub_allocbt_rec(
 	    !xfs_verify_agbno(mp, agno, bno + len - 1))
 		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
 
+	xfs_scrub_allocbt_xref(bs->sc, bno, len);
+
 	return error;
 }
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 0261e11..b693192 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -99,6 +99,30 @@ struct xfs_scrub_bmap_info {
 	int				whichfork;
 };
 
+/* Cross-reference a single rtdev extent record. */
+STATIC void
+xfs_scrub_bmap_rt_extent_xref(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_inode		*ip,
+	struct xfs_btree_cur		*cur,
+	struct xfs_bmbt_irec		*irec)
+{
+	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+}
+
+/* Cross-reference a single datadev extent record. */
+STATIC void
+xfs_scrub_bmap_extent_xref(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_inode		*ip,
+	struct xfs_btree_cur		*cur,
+	struct xfs_bmbt_irec		*irec)
+{
+	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+}
+
 /* Scrub a single extent record. */
 STATIC int
 xfs_scrub_bmap_extent(
@@ -158,6 +182,11 @@ xfs_scrub_bmap_extent(
 		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
+	if (info->is_rt)
+		xfs_scrub_bmap_rt_extent_xref(info, ip, cur, irec);
+	else
+		xfs_scrub_bmap_extent_xref(info, ip, cur, irec);
+
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
 	return error;
 }
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 496d6f2..9294148 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -58,6 +58,19 @@ xfs_scrub_setup_ag_iallocbt(
 
 /* Inode btree scrubber. */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_iallocbt_chunk_xref(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inobt_rec_incore	*irec,
+	xfs_agino_t			agino,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+}
+
 /* Is this chunk worth checking? */
 STATIC bool
 xfs_scrub_iallocbt_chunk(
@@ -76,6 +89,8 @@ xfs_scrub_iallocbt_chunk(
 	    !xfs_verify_agbno(mp, agno, bno + len - 1))
 		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
 
+	xfs_scrub_iallocbt_chunk_xref(bs->sc, irec, agino, bno, len);
+
 	return true;
 }
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 304e8bc..2aa12e1 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -577,6 +577,17 @@ xfs_scrub_inode_map_raw(
 	return error;
 }
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_inode_xref(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
+	struct xfs_dinode		*dip)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+}
+
 /* Scrub an inode. */
 int
 xfs_scrub_inode(
@@ -626,6 +637,7 @@ xfs_scrub_inode(
 			xfs_scrub_ino_set_preen(sc, ino, bp);
 	}
 
+	xfs_scrub_inode_xref(sc, ino, dip);
 out:
 	if (bp)
 		xfs_trans_brelse(sc->tp, bp);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 2f88a8d..d202382 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -50,6 +50,18 @@ xfs_scrub_setup_ag_refcountbt(
 
 /* Reference count btree scrubber. */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_refcountbt_xref(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	xfs_nlink_t			refcount)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+}
+
 /* Scrub a refcountbt record. */
 STATIC int
 xfs_scrub_refcountbt_rec(
@@ -83,6 +95,8 @@ xfs_scrub_refcountbt_rec(
 	if (refcount == 0)
 		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
 
+	xfs_scrub_refcountbt_xref(bs->sc, bno, len, refcount);
+
 	return error;
 }
 
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 97846c4..8655948 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -51,6 +51,16 @@ xfs_scrub_setup_ag_rmapbt(
 
 /* Reverse-mapping scrubber. */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_rmapbt_xref(
+	struct xfs_scrub_context	*sc,
+	struct xfs_rmap_irec		*irec)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+}
+
 /* Scrub an rmapbt record. */
 STATIC int
 xfs_scrub_rmapbt_rec(
@@ -121,6 +131,8 @@ xfs_scrub_rmapbt_rec(
 		    irec.rm_owner > XFS_RMAP_OWN_FS)
 			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
 	}
+
+	xfs_scrub_rmapbt_xref(bs->sc, &irec);
 out:
 	return error;
 }

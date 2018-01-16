Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43320 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751459AbeAPXX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 18:23:26 -0500
Date: Tue, 16 Jan 2018 15:23:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 16/21] xfs: cross-reference inode btrees during scrub
Message-ID: <20180116232322.GA5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398987068.18741.4829286717637372866.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398987068.18741.4829286717637372866.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Cross-reference the inode btrees with the other metadata when we
scrub the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: fix some indenting craziness, clean up helpers per dave's suggestion
v2: streamline scrubber arguments, remove stack allocated objects
---
 fs/xfs/scrub/agheader.c |   27 +++++++++++++++++
 fs/xfs/scrub/alloc.c    |    1 +
 fs/xfs/scrub/bmap.c     |    1 +
 fs/xfs/scrub/ialloc.c   |   73 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode.c    |   49 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/refcount.c |    1 +
 fs/xfs/scrub/rmap.c     |    4 +++
 fs/xfs/scrub/scrub.h    |    4 +++
 8 files changed, 160 insertions(+)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 1aba7c0..13ec76b 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -122,6 +122,7 @@ xfs_scrub_superblock_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -507,6 +508,7 @@ xfs_scrub_agf_xref(
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
 	xfs_scrub_agf_xref_freeblks(sc);
 	xfs_scrub_agf_xref_cntbt(sc);
+	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -612,6 +614,7 @@ xfs_scrub_agfl_block_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
 }
 
 /* Scrub an AGFL block. */
@@ -666,6 +669,7 @@ xfs_scrub_agfl_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
 
 	/*
 	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
@@ -740,6 +744,27 @@ xfs_scrub_agfl(
 
 /* AGI */
 
+/* Check agi_count/agi_freecount */
+static inline void
+xfs_scrub_agi_xref_icounts(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_agi			*agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	xfs_agino_t			icount;
+	xfs_agino_t			freecount;
+	int				error;
+
+	if (!sc->sa.ino_cur)
+		return;
+
+	error = xfs_ialloc_count_inodes(sc->sa.ino_cur, &icount, &freecount);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.ino_cur))
+		return;
+	if (be32_to_cpu(agi->agi_count) != icount ||
+	    be32_to_cpu(agi->agi_freecount) != freecount)
+		xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agi_bp);
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_agi_xref(
@@ -759,6 +784,8 @@ xfs_scrub_agi_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
+	xfs_scrub_agi_xref_icounts(sc);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 836b3c3..0031014 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -104,6 +104,7 @@ xfs_scrub_allocbt_xref(
 		return;
 
 	xfs_scrub_allocbt_xref_other(sc, agbno, len);
+	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 7e8e239..6f1d145 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -138,6 +138,7 @@ xfs_scrub_bmap_extent_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(info->sc, agbno, len);
+	xfs_scrub_xref_is_not_inode_chunk(info->sc, agbno, len);
 
 	xfs_scrub_ag_free(info->sc, &info->sc->sa);
 }
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 4526894..bd7ba16 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -58,6 +58,35 @@ xfs_scrub_setup_ag_iallocbt(
 
 /* Inode btree scrubber. */
 
+/*
+ * If we're checking the finobt, cross-reference with the inobt.
+ * Otherwise we're checking the inobt; if there is an finobt, make sure
+ * we have a record or not depending on freecount.
+ */
+static inline void
+xfs_scrub_iallocbt_chunk_xref_other(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inobt_rec_incore	*irec,
+	xfs_agino_t			agino)
+{
+	struct xfs_btree_cur		**pcur;
+	bool				has_irec;
+	int				error;
+
+	if (sc->sm->sm_type == XFS_SCRUB_TYPE_FINOBT)
+		pcur = &sc->sa.ino_cur;
+	else
+		pcur = &sc->sa.fino_cur;
+	if (!(*pcur))
+		return;
+	error = xfs_ialloc_has_inode_record(*pcur, agino, agino, &has_irec);
+	if (!xfs_scrub_should_check_xref(sc, &error, pcur))
+		return;
+	if (((irec->ir_freecount > 0 && !has_irec) ||
+	     (irec->ir_freecount == 0 && has_irec)))
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_iallocbt_chunk_xref(
@@ -71,6 +100,7 @@ xfs_scrub_iallocbt_chunk_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, len);
+	xfs_scrub_iallocbt_chunk_xref_other(sc, irec, agino);
 }
 
 /* Is this chunk worth checking? */
@@ -352,3 +382,46 @@ xfs_scrub_finobt(
 {
 	return xfs_scrub_iallocbt(sc, XFS_BTNUM_FINO);
 }
+
+/* See if an inode btree has (or doesn't have) an inode chunk record. */
+static inline void
+xfs_scrub_xref_inode_check(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len,
+	struct xfs_btree_cur		**icur,
+	bool				should_have_inodes)
+{
+	bool				has_inodes;
+	int				error;
+
+	if (!(*icur))
+		return;
+
+	error = xfs_ialloc_has_inodes_at_extent(*icur, agbno, len, &has_inodes);
+	if (!xfs_scrub_should_check_xref(sc, &error, icur))
+		return;
+	if (has_inodes != should_have_inodes)
+		xfs_scrub_btree_xref_set_corrupt(sc, *icur, 0);
+}
+
+/* xref check that the extent is not covered by inodes */
+void
+xfs_scrub_xref_is_not_inode_chunk(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len)
+{
+	xfs_scrub_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur, false);
+	xfs_scrub_xref_inode_check(sc, agbno, len, &sc->sa.fino_cur, false);
+}
+
+/* xref check that the extent is covered by inodes */
+void
+xfs_scrub_xref_is_inode_chunk(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len)
+{
+	xfs_scrub_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur, true);
+}
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index be9cf19..b48d5fb 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -39,6 +39,7 @@
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/btree.h"
 #include "scrub/trace.h"
 
 /*
@@ -577,6 +578,53 @@ xfs_scrub_inode_map_raw(
 	return error;
 }
 
+/*
+ * Make sure the finobt doesn't think this inode is free.
+ * We don't have to check the inobt ourselves because we got the inode via
+ * IGET_UNTRUSTED, which checks the inobt for us.
+ */
+static void
+xfs_scrub_inode_xref_finobt(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino)
+{
+	struct xfs_inobt_rec_incore	rec;
+	xfs_agino_t			agino;
+	int				has_record;
+	int				error;
+
+	if (!sc->sa.fino_cur)
+		return;
+
+	agino = XFS_INO_TO_AGINO(sc->mp, ino);
+
+	/*
+	 * Try to get the finobt record.  If we can't get it, then we're
+	 * in good shape.
+	 */
+	error = xfs_inobt_lookup(sc->sa.fino_cur, agino, XFS_LOOKUP_LE,
+			&has_record);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.fino_cur) ||
+	    !has_record)
+		return;
+
+	error = xfs_inobt_get_rec(sc->sa.fino_cur, &rec, &has_record);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.fino_cur) ||
+	    !has_record)
+		return;
+
+	/*
+	 * Otherwise, make sure this record either doesn't cover this inode,
+	 * or that it does but it's marked present.
+	 */
+	if (rec.ir_startino > agino ||
+	    rec.ir_startino + XFS_INODES_PER_CHUNK <= agino)
+		return;
+
+	if (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino))
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.fino_cur, 0);
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_inode_xref(
@@ -599,6 +647,7 @@ xfs_scrub_inode_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+	xfs_scrub_inode_xref_finobt(sc, ino);
 
 	xfs_scrub_ag_free(sc, &sc->sa);
 }
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 09a04ae..af54590 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -62,6 +62,7 @@ xfs_scrub_refcountbt_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, len);
+	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, len);
 }
 
 /* Scrub a refcountbt record. */
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 54b0eac..6e937ef 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -64,6 +64,10 @@ xfs_scrub_rmapbt_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, len);
+	if (irec->rm_owner == XFS_RMAP_OWN_INODES)
+		xfs_scrub_xref_is_inode_chunk(sc, agbno, len);
+	else
+		xfs_scrub_xref_is_not_inode_chunk(sc, agbno, len);
 }
 
 /* Scrub an rmapbt record. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index cbc6363..9b0033b 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -126,5 +126,9 @@ xfs_scrub_quota(struct xfs_scrub_context *sc)
 /* cross-referencing helpers */
 void xfs_scrub_xref_is_used_space(struct xfs_scrub_context *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len);
+void xfs_scrub_xref_is_not_inode_chunk(struct xfs_scrub_context *sc,
+		xfs_agblock_t agbno, xfs_extlen_t len);
+void xfs_scrub_xref_is_inode_chunk(struct xfs_scrub_context *sc,
+		xfs_agblock_t agbno, xfs_extlen_t len);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

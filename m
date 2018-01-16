Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35154 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbeAPX1S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 18:27:18 -0500
Date: Tue, 16 Jan 2018 15:27:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 19/21] xfs: cross-reference refcount btree during scrub
Message-ID: <20180116232715.GD5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398988926.18741.14757152372859283463.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398988926.18741.14757152372859283463.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

During metadata btree scrub, we should cross-reference with the
reference counts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: fix indenting and standardize helper naming, refactor helpers per dave's
    suggestion and add clarifying comments
v2: streamline scrubber arguments, remove stack allocated objects
---
 fs/xfs/scrub/agheader.c |   25 ++++++++++++++++++
 fs/xfs/scrub/alloc.c    |    1 +
 fs/xfs/scrub/bmap.c     |   15 +++++++++++
 fs/xfs/scrub/ialloc.c   |    1 +
 fs/xfs/scrub/inode.c    |   50 +++++++++++++++++++++++++----------
 fs/xfs/scrub/refcount.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rmap.c     |   37 ++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h    |    4 +++
 8 files changed, 186 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 1d109d5..20a3beb 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -127,6 +127,7 @@ xfs_scrub_superblock_xref(
 	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
 	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xfs_scrub_xref_is_not_shared(sc, agbno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -537,6 +538,25 @@ xfs_scrub_agf_xref_btreeblks(
 		xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
 }
 
+/* Check agf_refcount_blocks against tree size */
+static inline void
+xfs_scrub_agf_xref_refcblks(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	xfs_agblock_t			blocks;
+	int				error;
+
+	if (!sc->sa.refc_cur)
+		return;
+
+	error = xfs_btree_count_blocks(sc->sa.refc_cur, &blocks);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur))
+		return;
+	if (blocks != be32_to_cpu(agf->agf_refcount_blocks))
+		xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_agf_xref(
@@ -563,6 +583,8 @@ xfs_scrub_agf_xref(
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
 	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
 	xfs_scrub_agf_xref_btreeblks(sc);
+	xfs_scrub_xref_is_not_shared(sc, agbno, 1);
+	xfs_scrub_agf_xref_refcblks(sc);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -672,6 +694,7 @@ xfs_scrub_agfl_block_xref(
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
 	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
 	xfs_scrub_xref_is_owned_by(sc, agbno, 1, oinfo);
+	xfs_scrub_xref_is_not_shared(sc, agbno, 1);
 }
 
 /* Scrub an AGFL block. */
@@ -730,6 +753,7 @@ xfs_scrub_agfl_xref(
 	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
 	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xfs_scrub_xref_is_not_shared(sc, agbno, 1);
 
 	/*
 	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
@@ -850,6 +874,7 @@ xfs_scrub_agi_xref(
 	xfs_scrub_agi_xref_icounts(sc);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
 	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xfs_scrub_xref_is_not_shared(sc, agbno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 3faa437..517c079 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -106,6 +106,7 @@ xfs_scrub_allocbt_xref(
 	xfs_scrub_allocbt_xref_other(sc, agbno, len);
 	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, len);
 	xfs_scrub_xref_has_no_owner(sc, agbno, len);
+	xfs_scrub_xref_is_not_shared(sc, agbno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 933e0b8..7b2cf8f 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -37,6 +37,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -273,6 +274,20 @@ xfs_scrub_bmap_extent_xref(
 	xfs_scrub_xref_is_used_space(info->sc, agbno, len);
 	xfs_scrub_xref_is_not_inode_chunk(info->sc, agbno, len);
 	xfs_scrub_bmap_xref_rmap(info, irec, agbno);
+	switch (info->whichfork) {
+	case XFS_DATA_FORK:
+		if (xfs_is_reflink_inode(info->sc->ip))
+			break;
+		/* fall through */
+	case XFS_ATTR_FORK:
+		xfs_scrub_xref_is_not_shared(info->sc, agbno,
+				irec->br_blockcount);
+		break;
+	case XFS_COW_FORK:
+		xfs_scrub_xref_is_cow_staging(info->sc, agbno,
+				irec->br_blockcount);
+		break;
+	}
 
 	xfs_scrub_ag_free(info->sc, &info->sc->sa);
 }
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 1a16f78..21c850a 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -105,6 +105,7 @@ xfs_scrub_iallocbt_chunk_xref(
 	xfs_scrub_iallocbt_chunk_xref_other(sc, irec, agino);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 	xfs_scrub_xref_is_owned_by(sc, agbno, len, &oinfo);
+	xfs_scrub_xref_is_not_shared(sc, agbno, len);
 }
 
 /* Is this chunk worth checking? */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 6e99577..e92d633 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -652,22 +652,50 @@ xfs_scrub_inode_xref(
 	xfs_scrub_inode_xref_finobt(sc, ino);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xfs_scrub_xref_is_not_shared(sc, agbno, 1);
 
 	xfs_scrub_ag_free(sc, &sc->sa);
 }
 
+/*
+ * If the reflink iflag disagrees with a scan for shared data fork extents,
+ * either flag an error (shared extents w/ no flag) or a preen (flag set w/o
+ * any shared extents).  We already checked for reflink iflag set on a non
+ * reflink filesystem.
+ */
+static void
+xfs_scrub_inode_check_reflink_iflag(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
+	struct xfs_buf			*bp)
+{
+	struct xfs_mount		*mp = sc->mp;
+	bool				has_shared;
+	int				error;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return;
+
+	error = xfs_reflink_inode_has_shared_extents(sc->tp, sc->ip,
+			&has_shared);
+	if (!xfs_scrub_xref_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGBNO(mp, ino), &error))
+		return;
+	if (xfs_is_reflink_inode(sc->ip) && !has_shared)
+		xfs_scrub_ino_set_preen(sc, ino, bp);
+	else if (!xfs_is_reflink_inode(sc->ip) && has_shared)
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+}
+
 /* Scrub an inode. */
 int
 xfs_scrub_inode(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_dinode		di;
-	struct xfs_mount		*mp = sc->mp;
 	struct xfs_buf			*bp = NULL;
 	struct xfs_dinode		*dip;
 	xfs_ino_t			ino;
-
-	bool				has_shared;
 	int				error = 0;
 
 	/* Did we get the in-core inode, or are we doing this manually? */
@@ -692,18 +720,12 @@ xfs_scrub_inode(
 		goto out;
 
 	/*
-	 * Does this inode have the reflink flag set but no shared extents?
-	 * Set the preening flag if this is the case.
+	 * Look for discrepancies between file's data blocks and the reflink
+	 * iflag.  We already checked the iflag against the file mode when
+	 * we scrubbed the dinode.
 	 */
-	if (xfs_is_reflink_inode(sc->ip)) {
-		error = xfs_reflink_inode_has_shared_extents(sc->tp, sc->ip,
-				&has_shared);
-		if (!xfs_scrub_xref_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
-				XFS_INO_TO_AGBNO(mp, ino), &error))
-			goto out;
-		if (!has_shared)
-			xfs_scrub_ino_set_preen(sc, ino, bp);
-	}
+	if (S_ISREG(VFS_I(sc->ip)->i_mode))
+		xfs_scrub_inode_check_reflink_iflag(sc, ino, bp);
 
 	xfs_scrub_inode_xref(sc, ino, dip);
 out:
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 27e00fa..31bc5ec 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -31,6 +31,7 @@
 #include "xfs_sb.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -450,3 +451,69 @@ xfs_scrub_refcountbt(
 
 	return 0;
 }
+
+/* xref check that a cow staging extent is marked in the refcountbt. */
+void
+xfs_scrub_xref_is_cow_staging(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len)
+{
+	struct xfs_refcount_irec	rc;
+	bool				has_cowflag;
+	int				has_refcount;
+	int				error;
+
+	if (!sc->sa.refc_cur)
+		return;
+
+	/* Find the CoW staging extent. */
+	error = xfs_refcount_lookup_le(sc->sa.refc_cur,
+			agbno + XFS_REFC_COW_START, &has_refcount);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur))
+		return;
+	if (!has_refcount) {
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+		return;
+	}
+
+	error = xfs_refcount_get_rec(sc->sa.refc_cur, &rc, &has_refcount);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur))
+		return;
+	if (!has_refcount) {
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+		return;
+	}
+
+	/* CoW flag must be set, refcount must be 1. */
+	has_cowflag = (rc.rc_startblock & XFS_REFC_COW_START);
+	if (!has_cowflag || rc.rc_refcount != 1)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+
+	/* Must be at least as long as what was passed in */
+	if (rc.rc_blockcount < len)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+}
+
+/*
+ * xref check that the extent is not shared.  Only file data blocks
+ * can have multiple owners.
+ */
+void
+xfs_scrub_xref_is_not_shared(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len)
+{
+	bool				shared;
+	int				error;
+
+	if (!sc->sa.refc_cur)
+		return;
+
+	error = xfs_refcount_has_record(sc->sa.refc_cur, agbno, len, &shared);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur))
+		return;
+	if (shared)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+}
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 3ee5061..8f2a7c3 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -32,6 +32,7 @@
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -51,6 +52,37 @@ xfs_scrub_setup_ag_rmapbt(
 
 /* Reverse-mapping scrubber. */
 
+/* Cross-reference a rmap against the refcount btree. */
+STATIC void
+xfs_scrub_rmapbt_xref_refc(
+	struct xfs_scrub_context	*sc,
+	struct xfs_rmap_irec		*irec)
+{
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
+	bool				non_inode;
+	bool				is_bmbt;
+	bool				is_attr;
+	bool				is_unwritten;
+	int				error;
+
+	if (!sc->sa.refc_cur)
+		return;
+
+	non_inode = XFS_RMAP_NON_INODE_OWNER(irec->rm_owner);
+	is_bmbt = irec->rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec->rm_flags & XFS_RMAP_ATTR_FORK;
+	is_unwritten = irec->rm_flags & XFS_RMAP_UNWRITTEN;
+
+	/* If this is shared, must be a data fork extent. */
+	error = xfs_refcount_find_shared(sc->sa.refc_cur, irec->rm_startblock,
+			irec->rm_blockcount, &fbno, &flen, false);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur))
+		return;
+	if (flen != 0 && (non_inode || is_attr || is_bmbt || is_unwritten))
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_rmapbt_xref(
@@ -68,6 +100,11 @@ xfs_scrub_rmapbt_xref(
 		xfs_scrub_xref_is_inode_chunk(sc, agbno, len);
 	else
 		xfs_scrub_xref_is_not_inode_chunk(sc, agbno, len);
+	if (irec->rm_owner == XFS_RMAP_OWN_COW)
+		xfs_scrub_xref_is_cow_staging(sc, irec->rm_startblock,
+				irec->rm_blockcount);
+	else
+		xfs_scrub_rmapbt_xref_refc(sc, irec);
 }
 
 /* Scrub an rmapbt record. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 8fcf491..c8f8b42 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -138,5 +138,9 @@ void xfs_scrub_xref_is_not_owned_by(struct xfs_scrub_context *sc,
 		struct xfs_owner_info *oinfo);
 void xfs_scrub_xref_has_no_owner(struct xfs_scrub_context *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len);
+void xfs_scrub_xref_is_cow_staging(struct xfs_scrub_context *sc,
+		xfs_agblock_t bno, xfs_extlen_t len);
+void xfs_scrub_xref_is_not_shared(struct xfs_scrub_context *sc,
+		xfs_agblock_t bno, xfs_extlen_t len);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

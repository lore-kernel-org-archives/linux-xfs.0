Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19988 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758930AbcLCBjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:39:33 -0500
Subject: [PATCH 36/55] xfs: cross-reference inode btrees during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:39:16 -0800
Message-ID: <148072915609.12995.9903661150997712733.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Cross-reference the inode btrees with the other metadata when we
scrub the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |   99 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |    6 +++
 fs/xfs/repair/agheader.c   |   81 ++++++++++++++++++++++++++++++++++++
 fs/xfs/repair/alloc.c      |   18 ++++++++
 fs/xfs/repair/bmap.c       |   20 +++++++++
 fs/xfs/repair/ialloc.c     |   16 +++++++
 fs/xfs/repair/refcount.c   |   20 +++++++++
 fs/xfs/repair/rmap.c       |   24 +++++++++++
 8 files changed, 284 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 542f6a9..c725eb9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2668,3 +2668,102 @@ xfs_ialloc_pagi_init(
 		xfs_trans_brelse(tp, bp);
 	return 0;
 }
+
+/* Is there an inode record covering a given range of inode numbers? */
+int
+xfs_ialloc_has_inode_record(
+	struct xfs_btree_cur	*cur,
+	xfs_agino_t		low,
+	xfs_agino_t		high,
+	bool			*exists)
+{
+	struct xfs_inobt_rec_incore	irec;
+	xfs_agino_t		agino;
+	__uint16_t		holemask;
+	int			has;
+	int			i;
+	int			error;
+
+	*exists = false;
+	error = xfs_inobt_lookup(cur, low, XFS_LOOKUP_LE, &has);
+	while (error == 0 && has) {
+		error = xfs_inobt_get_rec(cur, &irec, &has);
+		if (error || irec.ir_startino > high)
+			break;
+
+		agino = irec.ir_startino;
+		holemask = irec.ir_holemask;
+		for (i = 0; i < XFS_INOBT_HOLEMASK_BITS; holemask >>= 1,
+				i++, agino += XFS_INODES_PER_HOLEMASK_BIT) {
+			if (holemask & 1)
+				continue;
+			if (agino + XFS_INODES_PER_HOLEMASK_BIT > low &&
+					agino <= high) {
+				*exists = true;
+				goto out;
+			}
+		}
+
+		error = xfs_btree_increment(cur, 0, &has);
+	}
+out:
+	return error;
+}
+
+/* Is there an inode record covering a given extent? */
+int
+xfs_ialloc_has_inodes_at_extent(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			*exists)
+{
+	xfs_agino_t		low;
+	xfs_agino_t		high;
+
+	low = XFS_OFFBNO_TO_AGINO(cur->bc_mp, bno, 0);
+	high = XFS_OFFBNO_TO_AGINO(cur->bc_mp, bno + len, 0) - 1;
+
+	return xfs_ialloc_has_inode_record(cur, low, high, exists);
+}
+
+struct xfs_ialloc_count_inodes {
+	xfs_agino_t			count;
+	xfs_agino_t			freecount;
+};
+
+/* Record inode counts across all inobt records. */
+STATIC int
+xfs_ialloc_count_inodes_helper(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	struct xfs_inobt_rec_incore	irec;
+	struct xfs_ialloc_count_inodes	*ci = priv;
+
+	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, &irec);
+	ci->count += irec.ir_count;
+	ci->freecount += irec.ir_freecount;
+
+	return 0;
+}
+
+/* Count allocated and free inodes under an inobt. */
+int
+xfs_ialloc_count_inodes(
+	struct xfs_btree_cur		*cur,
+	xfs_agino_t			*count,
+	xfs_agino_t			*freecount)
+{
+	struct xfs_ialloc_count_inodes	ci = {0};
+	int				error;
+
+	ASSERT(cur->bc_btnum == XFS_BTNUM_INO);
+	error = xfs_btree_query_all(cur, xfs_ialloc_count_inodes_helper, &ci);
+	if (!error) {
+		*count = ci.count;
+		*freecount = ci.freecount;
+	}
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 8e5861d..17f0f1b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -171,5 +171,11 @@ int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 union xfs_btree_rec;
 void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
 		struct xfs_inobt_rec_incore *irec);
+int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+int xfs_ialloc_has_inode_record(struct xfs_btree_cur *cur, xfs_agino_t low,
+		xfs_agino_t high, bool *exists);
+int xfs_ialloc_count_inodes(struct xfs_btree_cur *cur, xfs_agino_t *count,
+		xfs_agino_t *freecount);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/repair/agheader.c b/fs/xfs/repair/agheader.c
index c1b4b13..62baeed 100644
--- a/fs/xfs/repair/agheader.c
+++ b/fs/xfs/repair/agheader.c
@@ -31,6 +31,7 @@
 #include "xfs_trace.h"
 #include "xfs_sb.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "repair/common.h"
 
 /* Find the size of the AG, in blocks. */
@@ -143,6 +144,7 @@ xfs_scrub_superblock(
 	xfs_agnumber_t			agno;
 	uint32_t			v2_ok;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error;
 	int				err2;
 
@@ -279,6 +281,22 @@ xfs_scrub_superblock(
 			XFS_SCRUB_SB_CHECK(!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				XFS_SB_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &psa->ino_cur))
+			XFS_SCRUB_SB_CHECK(!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				XFS_SB_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &psa->fino_cur))
+			XFS_SCRUB_SB_CHECK(!has_inodes);
+	}
+
 out:
 	return error;
 }
@@ -324,6 +342,7 @@ xfs_scrub_agf(
 	xfs_agblock_t			fl_count;
 	xfs_extlen_t			blocks;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				have;
 	int				level;
 	int				error = 0;
@@ -443,6 +462,22 @@ xfs_scrub_agf(
 	}
 skip_cntbt:
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				XFS_AGF_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &psa->ino_cur))
+			XFS_SCRUB_AGF_CHECK(!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				XFS_AGF_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &psa->fino_cur))
+			XFS_SCRUB_AGF_CHECK(!has_inodes);
+	}
+
 out:
 	return error;
 }
@@ -469,6 +504,7 @@ xfs_scrub_agfl_block(
 	xfs_agnumber_t			agno = sc->sa.agno;
 	struct xfs_scrub_agfl		*sagfl = priv;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				err2;
 
 	XFS_SCRUB_AGFL_CHECK(agbno > XFS_AGI_BLOCK(mp));
@@ -487,6 +523,22 @@ xfs_scrub_agfl_block(
 			XFS_SCRUB_AGFL_CHECK(!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (sc->sa.ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(sc->sa.ino_cur,
+				agbno, 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.ino_cur))
+			XFS_SCRUB_AGFL_CHECK(!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (sc->sa.fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(sc->sa.fino_cur,
+				agbno, 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.fino_cur))
+			XFS_SCRUB_AGFL_CHECK(!has_inodes);
+	}
+
 	return 0;
 }
 
@@ -554,7 +606,10 @@ xfs_scrub_agi(
 	xfs_agino_t			agino;
 	xfs_agino_t			first_agino;
 	xfs_agino_t			last_agino;
+	xfs_agino_t			count;
+	xfs_agino_t			freecount;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				i;
 	int				level;
 	int				error = 0;
@@ -640,6 +695,32 @@ xfs_scrub_agi(
 			XFS_SCRUB_AGI_CHECK(!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				XFS_AGI_BLOCK(mp), 1, &has_inodes);
+		if (!xfs_scrub_should_xref(sc, err2, &psa->ino_cur))
+			goto skip_inobt_xref;
+		XFS_SCRUB_AGI_CHECK(!has_inodes);
+		err2 = xfs_ialloc_count_inodes(psa->ino_cur, &count,
+				&freecount);
+		if (xfs_scrub_should_xref(sc, err2, &psa->ino_cur)) {
+			XFS_SCRUB_AGI_CHECK(be32_to_cpu(agi->agi_count) ==
+					count);
+			XFS_SCRUB_AGI_CHECK(be32_to_cpu(agi->agi_freecount) ==
+					freecount);
+		}
+	}
+
+skip_inobt_xref:
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				XFS_AGI_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &psa->fino_cur))
+			XFS_SCRUB_AGI_CHECK(!has_inodes);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/repair/alloc.c b/fs/xfs/repair/alloc.c
index 6369f09..d7ca294 100644
--- a/fs/xfs/repair/alloc.c
+++ b/fs/xfs/repair/alloc.c
@@ -32,6 +32,7 @@
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -51,6 +52,7 @@ xfs_scrub_allocbt_helper(
 	xfs_agblock_t			bno;
 	xfs_extlen_t			flen;
 	xfs_extlen_t			len;
+	bool				has_inodes;
 	int				has_otherrec;
 	int				error = 0;
 	int				err2;
@@ -94,6 +96,22 @@ xfs_scrub_allocbt_helper(
 		}
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->ino_cur, bno,
+				len, &has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->ino_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->fino_cur, bno,
+				len, &has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->fino_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !has_inodes);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/repair/bmap.c b/fs/xfs/repair/bmap.c
index b4f0abb..94d40f4 100644
--- a/fs/xfs/repair/bmap.c
+++ b/fs/xfs/repair/bmap.c
@@ -37,6 +37,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -80,6 +81,7 @@ xfs_scrub_bmap_extent(
 	xfs_agnumber_t			agno;
 	xfs_fsblock_t			bno;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error = 0;
 	int				err2 = 0;
 
@@ -134,6 +136,24 @@ xfs_scrub_bmap_extent(
 			XFS_SCRUB_BMAP_CHECK(!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (sa.ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(sa.ino_cur,
+				irec->br_startblock, irec->br_blockcount,
+				&has_inodes);
+		if (xfs_scrub_should_xref(info->sc, err2, &sa.ino_cur))
+			XFS_SCRUB_BMAP_CHECK(!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (sa.fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(sa.fino_cur,
+				irec->br_startblock, irec->br_blockcount,
+				&has_inodes);
+		if (xfs_scrub_should_xref(info->sc, err2, &sa.fino_cur))
+			XFS_SCRUB_BMAP_CHECK(!has_inodes);
+	}
+
 	xfs_scrub_ag_free(&sa);
 out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
diff --git a/fs/xfs/repair/ialloc.c b/fs/xfs/repair/ialloc.c
index 4f01932..141c6bb 100644
--- a/fs/xfs/repair/ialloc.c
+++ b/fs/xfs/repair/ialloc.c
@@ -53,9 +53,11 @@ xfs_scrub_iallocbt_chunk(
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
 	struct xfs_scrub_ag		*psa;
+	struct xfs_btree_cur		**xcur;
 	xfs_agblock_t			eoag;
 	xfs_agblock_t			bno;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error = 0;
 	int				err2;
 
@@ -89,6 +91,20 @@ xfs_scrub_iallocbt_chunk(
 			XFS_SCRUB_BTREC_CHECK(bs, !is_freesp);
 	}
 
+	/* If we have a finobt, cross-reference with it. */
+	if (bs->cur == psa->fino_cur)
+		xcur = &psa->ino_cur;
+	else if (bs->cur == psa->ino_cur && irec->ir_freecount > 0)
+		xcur = &psa->fino_cur;
+	else
+		xcur = NULL;
+	if (xcur && *xcur) {
+		err2 = xfs_ialloc_has_inode_record(*xcur,
+				agino, agino, &has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, xcur))
+			XFS_SCRUB_BTREC_CHECK(bs, has_inodes);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/repair/refcount.c b/fs/xfs/repair/refcount.c
index 527a916..95b54d6 100644
--- a/fs/xfs/repair/refcount.c
+++ b/fs/xfs/repair/refcount.c
@@ -32,6 +32,7 @@
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -50,6 +51,7 @@ xfs_scrub_refcountbt_helper(
 	xfs_agblock_t			eoag;
 	bool				has_cowflag;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error = 0;
 	int				err2;
 
@@ -89,6 +91,24 @@ xfs_scrub_refcountbt_helper(
 			XFS_SCRUB_BTREC_CHECK(bs, !is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				irec.rc_startblock, irec.rc_blockcount,
+				&has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->ino_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				irec.rc_startblock, irec.rc_blockcount,
+				&has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->fino_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !has_inodes);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/repair/rmap.c b/fs/xfs/repair/rmap.c
index 401580e..961afc5 100644
--- a/fs/xfs/repair/rmap.c
+++ b/fs/xfs/repair/rmap.c
@@ -32,6 +32,7 @@
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -53,6 +54,7 @@ xfs_scrub_rmapbt_helper(
 	bool				is_unwritten;
 	bool				is_bmbt;
 	bool				is_attr;
+	bool				has_inodes;
 	int				error = 0;
 	int				err2;
 
@@ -120,6 +122,28 @@ xfs_scrub_rmapbt_helper(
 			XFS_SCRUB_BTREC_CHECK(bs, !is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				irec.rm_startblock, irec.rm_blockcount,
+				&has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->ino_cur))
+			XFS_SCRUB_BTREC_CHECK(bs,
+					irec.rm_owner == XFS_RMAP_OWN_INODES ||
+					!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				irec.rm_startblock, irec.rm_blockcount,
+				&has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->fino_cur))
+			XFS_SCRUB_BTREC_CHECK(bs,
+					irec.rm_owner == XFS_RMAP_OWN_INODES ||
+					!has_inodes);
+	}
+
 out:
 	return error;
 }


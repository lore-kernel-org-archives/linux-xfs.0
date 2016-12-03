Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20050 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759149AbcLCBjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:39:33 -0500
Subject: [PATCH 38/55] xfs: cross-reference refcount btree during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:39:28 -0800
Message-ID: <148072916863.12995.13399836656397350360.stgit@birch.djwong.org>
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

During metadata btree scrub, we should cross-reference with the
reference counts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   19 +++++++++++++
 fs/xfs/libxfs/xfs_refcount.h |    3 ++
 fs/xfs/repair/agheader.c     |   52 ++++++++++++++++++++++++++++++++++++
 fs/xfs/repair/alloc.c        |   10 +++++++
 fs/xfs/repair/bmap.c         |   57 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/repair/ialloc.c       |   10 +++++++
 fs/xfs/repair/rmap.c         |   60 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 211 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index b177ef3..c6c875d 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1696,3 +1696,22 @@ xfs_refcount_recover_cow_leftovers(
 	xfs_trans_cancel(tp);
 	goto out_free;
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_refcount_has_record(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			*exists)
+{
+	union xfs_btree_irec	low;
+	union xfs_btree_irec	high;
+
+	memset(&low, 0, sizeof(low));
+	low.rc.rc_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rc.rc_startblock = bno + len - 1;
+
+	return xfs_btree_has_record(cur, &low, &high, exists);
+}
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 098dc66..78cb142 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -67,4 +67,7 @@ extern int xfs_refcount_free_cow_extent(struct xfs_mount *mp,
 extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
 		xfs_agnumber_t agno);
 
+extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+
 #endif	/* __XFS_REFCOUNT_H__ */
diff --git a/fs/xfs/repair/agheader.c b/fs/xfs/repair/agheader.c
index 9751f52..df7c811 100644
--- a/fs/xfs/repair/agheader.c
+++ b/fs/xfs/repair/agheader.c
@@ -33,6 +33,7 @@
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount.h"
 #include "repair/common.h"
 
 /* Find the size of the AG, in blocks. */
@@ -148,6 +149,7 @@ xfs_scrub_superblock(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				error;
 	int				err2;
 
@@ -309,6 +311,14 @@ xfs_scrub_superblock(
 			XFS_SCRUB_SB_CHECK(has_rmap);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (psa->refc_cur) {
+		err2 = xfs_refcount_has_record(psa->refc_cur, XFS_SB_BLOCK(mp),
+				1, &has_refcount);
+		if (xfs_scrub_should_xref(sc, err2, &psa->refc_cur))
+			XFS_SCRUB_SB_CHECK(!has_refcount);
+	}
+
 out:
 	return error;
 }
@@ -358,6 +368,7 @@ xfs_scrub_agf(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				have;
 	int				level;
 	int				error = 0;
@@ -524,6 +535,20 @@ xfs_scrub_agf(
 					agf->agf_btreeblks));
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (psa->refc_cur) {
+		err2 = xfs_refcount_has_record(psa->refc_cur, XFS_AGF_BLOCK(mp),
+				1, &has_refcount);
+		if (xfs_scrub_should_xref(sc, err2, &psa->refc_cur))
+			XFS_SCRUB_AGF_CHECK(!has_refcount);
+	}
+	if (psa->refc_cur) {
+		err2 = xfs_btree_count_blocks(psa->refc_cur, &blocks);
+		if (xfs_scrub_should_xref(sc, err2, &psa->refc_cur))
+			XFS_SCRUB_AGF_CHECK(blocks == be32_to_cpu(
+					agf->agf_refcount_blocks));
+	}
+
 out:
 	return error;
 }
@@ -553,6 +578,7 @@ xfs_scrub_agfl_block(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				err2;
 
 	XFS_SCRUB_AGFL_CHECK(agbno > XFS_AGI_BLOCK(mp));
@@ -595,6 +621,14 @@ xfs_scrub_agfl_block(
 			XFS_SCRUB_AGFL_CHECK(has_rmap);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (sc->sa.refc_cur) {
+		err2 = xfs_refcount_has_record(sc->sa.refc_cur, agbno, 1,
+				&has_refcount);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.refc_cur))
+			XFS_SCRUB_AGFL_CHECK(!has_refcount);
+	}
+
 	return 0;
 }
 
@@ -612,6 +646,7 @@ xfs_scrub_agfl(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				error;
 	int				err2;
 
@@ -658,6 +693,14 @@ xfs_scrub_agfl(
 			XFS_SCRUB_AGFL_CHECK(has_rmap);
 	}
 
+	/* Set up cross-reference with refcountbt. */
+	if (sc->sa.refc_cur) {
+		err2 = xfs_refcount_has_record(sc->sa.refc_cur,
+				XFS_AGFL_BLOCK(mp), 1, &has_refcount);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.refc_cur))
+			XFS_SCRUB_AGFL_CHECK(!has_refcount);
+	}
+
 	/* Check the blocks in the AGFL. */
 	xfs_rmap_ag_owner(&sagfl.oinfo, XFS_RMAP_OWN_AG);
 	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sagfl);
@@ -696,6 +739,7 @@ xfs_scrub_agi(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				i;
 	int				level;
 	int				error = 0;
@@ -816,6 +860,14 @@ xfs_scrub_agi(
 			XFS_SCRUB_AGI_CHECK(has_rmap);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (psa->refc_cur) {
+		err2 = xfs_refcount_has_record(psa->refc_cur, XFS_AGI_BLOCK(mp),
+				1, &has_refcount);
+		if (xfs_scrub_should_xref(sc, err2, &psa->refc_cur))
+			XFS_SCRUB_AGI_CHECK(!has_refcount);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/repair/alloc.c b/fs/xfs/repair/alloc.c
index 1020e8d..a295607 100644
--- a/fs/xfs/repair/alloc.c
+++ b/fs/xfs/repair/alloc.c
@@ -33,6 +33,7 @@
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_refcount.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -54,6 +55,7 @@ xfs_scrub_allocbt_helper(
 	xfs_extlen_t			len;
 	bool				has_rmap;
 	bool				has_inodes;
+	bool				has_refcount;
 	int				has_otherrec;
 	int				error = 0;
 	int				err2;
@@ -121,6 +123,14 @@ xfs_scrub_allocbt_helper(
 			XFS_SCRUB_BTREC_CHECK(bs, !has_rmap);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (psa->refc_cur) {
+		err2 = xfs_refcount_has_record(psa->refc_cur, bno, len,
+				&has_refcount);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->refc_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !has_refcount);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/repair/bmap.c b/fs/xfs/repair/bmap.c
index a393c82..2bc661d 100644
--- a/fs/xfs/repair/bmap.c
+++ b/fs/xfs/repair/bmap.c
@@ -38,6 +38,7 @@
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_refcount.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -81,12 +82,17 @@ xfs_scrub_bmap_extent(
 	xfs_agnumber_t			agno;
 	xfs_fsblock_t			bno;
 	struct xfs_rmap_irec		rmap;
+	struct xfs_refcount_irec	rc;
 	uint64_t			owner;
 	xfs_fileoff_t			offset;
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_cowflag;
 	unsigned int			rflags;
 	int				has_rmap;
+	int				has_refcount;
 	int				error = 0;
 	int				err2 = 0;
 
@@ -243,6 +249,57 @@ xfs_scrub_bmap_extent(
 		;
 	}
 
+	/*
+	 * If this is a non-shared file on a reflink filesystem,
+	 * check the refcountbt to see if the flag is wrong.
+	 */
+	if (sa.refc_cur) {
+		if (info->whichfork == XFS_COW_FORK) {
+			/* Check this CoW staging extent. */
+			err2 = xfs_refcount_lookup_le(sa.refc_cur,
+					bno + XFS_REFC_COW_START,
+					&has_refcount);
+			if (xfs_scrub_should_xref(info->sc, err2,
+					&sa.refc_cur)) {
+				XFS_SCRUB_BMAP_GOTO(has_refcount,
+						skip_refc_xref);
+			} else
+				goto skip_refc_xref;
+
+			err2 = xfs_refcount_get_rec(sa.refc_cur, &rc,
+					&has_refcount);
+			if (xfs_scrub_should_xref(info->sc, err2,
+					&sa.refc_cur)) {
+				XFS_SCRUB_BMAP_GOTO(has_refcount,
+						skip_refc_xref);
+			} else
+				goto skip_refc_xref;
+
+			has_cowflag = !!(rc.rc_startblock & XFS_REFC_COW_START);
+			XFS_SCRUB_BMAP_CHECK(
+					(rc.rc_refcount == 1 && has_cowflag) ||
+					(rc.rc_refcount != 1 && !has_cowflag));
+			rc.rc_startblock &= ~XFS_REFC_COW_START;
+			XFS_SCRUB_BMAP_CHECK(rc.rc_startblock <= bno);
+			XFS_SCRUB_BMAP_CHECK(rc.rc_startblock <
+					rc.rc_startblock + rc.rc_blockcount);
+			XFS_SCRUB_BMAP_CHECK(bno + irec->br_blockcount <=
+					rc.rc_startblock + rc.rc_blockcount);
+			XFS_SCRUB_BMAP_CHECK(rc.rc_refcount == 1);
+		} else {
+			/* If this is shared, the inode flag must be set. */
+			err2 = xfs_refcount_find_shared(sa.refc_cur, bno,
+					irec->br_blockcount, &fbno, &flen,
+					false);
+			if (xfs_scrub_should_xref(info->sc, err2,
+					&sa.refc_cur))
+				XFS_SCRUB_BMAP_CHECK(flen == 0 ||
+						xfs_is_reflink_inode(ip));
+		}
+skip_refc_xref:
+		;
+	}
+
 	xfs_scrub_ag_free(&sa);
 out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
diff --git a/fs/xfs/repair/ialloc.c b/fs/xfs/repair/ialloc.c
index 2fa4c25..4981c65 100644
--- a/fs/xfs/repair/ialloc.c
+++ b/fs/xfs/repair/ialloc.c
@@ -36,6 +36,7 @@
 #include "xfs_icache.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
+#include "xfs_refcount.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -60,6 +61,7 @@ xfs_scrub_iallocbt_chunk(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				error = 0;
 	int				err2;
 
@@ -116,6 +118,14 @@ xfs_scrub_iallocbt_chunk(
 			XFS_SCRUB_BTREC_CHECK(bs, has_rmap);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (psa->refc_cur) {
+		err2 = xfs_refcount_has_record(psa->refc_cur, bno,
+				len, &has_refcount);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->refc_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !has_refcount);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/repair/rmap.c b/fs/xfs/repair/rmap.c
index 961afc5..fa2fa3b 100644
--- a/fs/xfs/repair/rmap.c
+++ b/fs/xfs/repair/rmap.c
@@ -33,6 +33,7 @@
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_refcount.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -48,13 +49,18 @@ xfs_scrub_rmapbt_helper(
 	struct xfs_agf			*agf;
 	struct xfs_scrub_ag		*psa;
 	struct xfs_rmap_irec		irec;
+	struct xfs_refcount_irec	crec;
 	xfs_agblock_t			eoag;
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
 	bool				is_freesp;
 	bool				non_inode;
 	bool				is_unwritten;
 	bool				is_bmbt;
 	bool				is_attr;
 	bool				has_inodes;
+	bool				has_cowflag;
+	int				has_refcount;
 	int				error = 0;
 	int				err2;
 
@@ -144,6 +150,60 @@ xfs_scrub_rmapbt_helper(
 					!has_inodes);
 	}
 
+	/* Cross-reference with the refcount btree. */
+	if (psa->refc_cur) {
+		if (irec.rm_owner == XFS_RMAP_OWN_COW) {
+			/* Check this CoW staging extent. */
+			err2 = xfs_refcount_lookup_le(psa->refc_cur,
+					irec.rm_startblock + XFS_REFC_COW_START,
+					&has_refcount);
+			if (xfs_scrub_btree_should_xref(bs, err2,
+					&psa->refc_cur)) {
+				XFS_SCRUB_BTREC_GOTO(bs, has_refcount,
+						skip_refc_xref);
+			} else
+				goto skip_refc_xref;
+
+			err2 = xfs_refcount_get_rec(psa->refc_cur, &crec,
+					&has_refcount);
+			if (xfs_scrub_btree_should_xref(bs, err2,
+					&psa->refc_cur)) {
+				XFS_SCRUB_BTREC_GOTO(bs, has_refcount,
+						skip_refc_xref);
+			} else
+				goto skip_refc_xref;
+
+			has_cowflag = !!(crec.rc_startblock & XFS_REFC_COW_START);
+			XFS_SCRUB_BTREC_CHECK(bs,
+					(crec.rc_refcount == 1 && has_cowflag) ||
+					(crec.rc_refcount != 1 && !has_cowflag));
+			crec.rc_startblock &= ~XFS_REFC_COW_START;
+			XFS_SCRUB_BTREC_CHECK(bs, crec.rc_startblock <=
+					irec.rm_startblock);
+			XFS_SCRUB_BTREC_CHECK(bs, crec.rc_startblock +
+					crec.rc_blockcount >
+					crec.rc_startblock);
+			XFS_SCRUB_BTREC_CHECK(bs, crec.rc_startblock +
+					crec.rc_blockcount >=
+					irec.rm_startblock +
+					irec.rm_blockcount);
+			XFS_SCRUB_BTREC_CHECK(bs,
+					crec.rc_refcount == 1);
+		} else {
+			/* If this is shared, the inode flag must be set. */
+			err2 = xfs_refcount_find_shared(psa->refc_cur,
+					irec.rm_startblock, irec.rm_blockcount,
+					&fbno, &flen, false);
+			if (xfs_scrub_btree_should_xref(bs, err2,
+					&psa->refc_cur))
+				XFS_SCRUB_BTREC_CHECK(bs, flen == 0 ||
+						(!non_inode && !is_attr &&
+						 !is_bmbt && !is_unwritten));
+		}
+skip_refc_xref:
+		;
+	}
+
 out:
 	return error;
 }


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50592 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdHKHLS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:11:18 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7BHBw031874
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7BGx2018488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:16 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7BGuJ027072
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:16 GMT
Subject: [PATCH 10/16] xfs: cross-reference inode btrees during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:11:15 -0700
Message-ID: <150243547503.29473.11765628077868454938.stgit@magnolia>
In-Reply-To: <150243541274.29473.1227559008347544526.stgit@magnolia>
References: <150243541274.29473.1227559008347544526.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Cross-reference the inode btrees with the other metadata when we
scrub the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |  106 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/alloc.c    |   20 +++++++++
 fs/xfs/scrub/bmap.c     |   24 +++++++++++
 fs/xfs/scrub/ialloc.c   |   17 ++++++++
 fs/xfs/scrub/refcount.c |   22 ++++++++++
 fs/xfs/scrub/rmap.c     |   24 +++++++++++
 6 files changed, 213 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 275271e..fedd86b 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -31,6 +31,7 @@
 #include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -155,6 +156,7 @@ xfs_scrub_superblock(
 	uint32_t			v2_ok;
 	__be32				features_mask;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error;
 	__be16				vernum_mask;
 
@@ -429,6 +431,22 @@ xfs_scrub_superblock(
 			xfs_scrub_block_xref_check_ok(sc, bp, !is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				XFS_SB_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, &error, &psa->ino_cur))
+			xfs_scrub_block_xref_check_ok(sc, bp, !has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				XFS_SB_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, &error, &psa->fino_cur))
+			xfs_scrub_block_xref_check_ok(sc, bp, !has_inodes);
+	}
+
 	return error;
 }
 
@@ -466,6 +484,7 @@ xfs_scrub_agf(
 	xfs_agblock_t			fl_count;
 	xfs_extlen_t			blocks;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				have;
 	int				level;
 	int				error = 0;
@@ -589,6 +608,24 @@ xfs_scrub_agf(
 		break;
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				XFS_AGF_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, &error, &psa->ino_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agf_bp,
+					!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				XFS_AGF_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, &error, &psa->fino_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agf_bp,
+					!has_inodes);
+	}
+
 out:
 	return error;
 }
@@ -611,6 +648,7 @@ xfs_scrub_agfl_block(
 	xfs_agnumber_t			agno = sc->sa.agno;
 	struct xfs_scrub_agfl		*sagfl = priv;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error = 0;
 
 	xfs_scrub_block_check_ok(sc, sc->sa.agfl_bp,
@@ -632,6 +670,24 @@ xfs_scrub_agfl_block(
 					!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (sc->sa.ino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(sc->sa.ino_cur,
+				agbno, 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, &error, &sc->sa.ino_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agfl_bp,
+					!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (sc->sa.fino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(sc->sa.fino_cur,
+				agbno, 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, &error, &sc->sa.fino_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agfl_bp,
+					!has_inodes);
+	}
+
 	return error;
 }
 
@@ -645,6 +701,7 @@ xfs_scrub_agfl(
 	struct xfs_agf			*agf;
 	xfs_agnumber_t			agno;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error;
 
 	agno = sc->sm->sm_agno;
@@ -667,6 +724,24 @@ xfs_scrub_agfl(
 					!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (sc->sa.ino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(sc->sa.ino_cur,
+			XFS_AGFL_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, &error, &sc->sa.ino_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agfl_bp,
+					!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (sc->sa.fino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(sc->sa.fino_cur,
+				XFS_AGFL_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, &error, &sc->sa.fino_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agfl_bp,
+					!has_inodes);
+	}
+
 	/* Check the blocks in the AGFL. */
 	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sagfl);
 out:
@@ -691,7 +766,10 @@ xfs_scrub_agi(
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
@@ -776,6 +854,34 @@ xfs_scrub_agi(
 					!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	while (psa->ino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				XFS_AGI_BLOCK(mp), 1, &has_inodes);
+		if (!xfs_scrub_should_xref(sc, &error, &psa->ino_cur))
+			break;
+		xfs_scrub_block_xref_check_ok(sc, sc->sa.agi_bp,
+				!has_inodes);
+
+		error = xfs_ialloc_count_inodes(psa->ino_cur, &count,
+				&freecount);
+		if (!xfs_scrub_should_xref(sc, &error, &psa->ino_cur))
+			break;
+		xfs_scrub_block_xref_check_ok(sc, sc->sa.agi_bp,
+				be32_to_cpu(agi->agi_count) == count &&
+				be32_to_cpu(agi->agi_freecount) == freecount);
+		break;
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				XFS_AGI_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, &error, &psa->fino_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agi_bp,
+					!has_inodes);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 0a4f4ea..d99ad99 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -31,6 +31,7 @@
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -66,6 +67,7 @@ xfs_scrub_allocbt_helper(
 	xfs_agblock_t			bno;
 	xfs_extlen_t			flen;
 	xfs_extlen_t			len;
+	bool				has_inodes;
 	int				has_otherrec;
 	int				error = 0;
 
@@ -110,6 +112,24 @@ xfs_scrub_allocbt_helper(
 		break;
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(psa->ino_cur, bno,
+				len, &has_inodes);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->ino_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->ino_cur, 0,
+					!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(psa->fino_cur, bno,
+				len, &has_inodes);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->fino_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->ino_cur, 0,
+					!has_inodes);
+	}
+
 	return error;
 }
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 9ad08ff..7ad8ba0 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -36,6 +36,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -141,6 +142,7 @@ xfs_scrub_bmap_extent(
 	xfs_fsblock_t			bno;
 	xfs_agnumber_t			agno;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error = 0;
 
 	if (cur)
@@ -200,6 +202,28 @@ xfs_scrub_bmap_extent(
 					!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (sa.ino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(sa.ino_cur,
+				irec->br_startblock, irec->br_blockcount,
+				&has_inodes);
+		if (xfs_scrub_should_xref(info->sc, &error, &sa.ino_cur))
+			xfs_scrub_fblock_xref_check_ok(info->sc,
+					info->whichfork, irec->br_startoff,
+					!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (sa.fino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(sa.fino_cur,
+				irec->br_startblock, irec->br_blockcount,
+				&has_inodes);
+		if (xfs_scrub_should_xref(info->sc, &error, &sa.fino_cur))
+			xfs_scrub_fblock_xref_check_ok(info->sc,
+					info->whichfork, irec->br_startoff,
+					!has_inodes);
+	}
+
 	xfs_scrub_ag_free(info->sc, &sa);
 out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index e9d7764..7f7247f 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -69,10 +69,12 @@ xfs_scrub_iallocbt_chunk(
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
 	struct xfs_scrub_ag		*psa;
+	struct xfs_btree_cur		**xcur;
 	unsigned long long		rec_end;
 	xfs_agblock_t			eoag;
 	xfs_agblock_t			bno;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error = 0;
 
 	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
@@ -99,6 +101,21 @@ xfs_scrub_iallocbt_chunk(
 					!is_freesp);
 	}
 
+	/* If we have a finobt, cross-reference with it. */
+	if (bs->cur == psa->fino_cur)
+		xcur = &psa->ino_cur;
+	else if (bs->cur == psa->ino_cur && irec->ir_freecount > 0)
+		xcur = &psa->fino_cur;
+	else
+		xcur = NULL;
+	if (xcur && *xcur) {
+		error = xfs_ialloc_has_inode_record(*xcur,
+				agino, agino, &has_inodes);
+		if (xfs_scrub_should_xref(bs->sc, &error, xcur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, *xcur, 0,
+					has_inodes);
+	}
+
 	return true;
 }
 
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 12cfd9f..f8f51e2 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -31,6 +31,7 @@
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -64,6 +65,7 @@ xfs_scrub_refcountbt_helper(
 	xfs_agblock_t			eoag;
 	bool				has_cowflag;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error = 0;
 
 	irec.rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
@@ -101,6 +103,26 @@ xfs_scrub_refcountbt_helper(
 					!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				irec.rc_startblock, irec.rc_blockcount,
+				&has_inodes);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->ino_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->ino_cur, 0,
+					!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				irec.rc_startblock, irec.rc_blockcount,
+				&has_inodes);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->fino_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->fino_cur, 0,
+					!has_inodes);
+	}
+
 	return error;
 }
 
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 2fd4aa7..e5e648d 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -31,6 +31,7 @@
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -67,6 +68,7 @@ xfs_scrub_rmapbt_helper(
 	bool				is_unwritten;
 	bool				is_bmbt;
 	bool				is_attr;
+	bool				has_inodes;
 	int				error;
 
 	error = xfs_rmap_btrec_to_irec(rec, &irec);
@@ -133,6 +135,28 @@ xfs_scrub_rmapbt_helper(
 					!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				irec.rm_startblock, irec.rm_blockcount,
+				&has_inodes);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->ino_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->ino_cur, 0,
+					irec.rm_owner == XFS_RMAP_OWN_INODES ||
+					!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				irec.rm_startblock, irec.rm_blockcount,
+				&has_inodes);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->fino_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->fino_cur, 0,
+					irec.rm_owner == XFS_RMAP_OWN_INODES ||
+					!has_inodes);
+	}
+
 out:
 	return error;
 }


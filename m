Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50719 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdHKHLg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:11:36 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7Basq032089
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7BaLL023768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:36 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7BZsq020790
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:35 GMT
Subject: [PATCH 13/16] xfs: cross-reference refcount btree during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:11:34 -0700
Message-ID: <150243549432.29473.5775848033237095111.stgit@magnolia>
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

During metadata btree scrub, we should cross-reference with the
reference counts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   60 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/alloc.c    |   11 ++++++++
 fs/xfs/scrub/bmap.c     |   66 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/ialloc.c   |   11 ++++++++
 fs/xfs/scrub/rmap.c     |   66 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 214 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 569d3c0..8507153 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -33,6 +33,7 @@
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -160,6 +161,7 @@ xfs_scrub_superblock(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				error;
 	__be16				vernum_mask;
 
@@ -459,6 +461,14 @@ xfs_scrub_superblock(
 			xfs_scrub_block_xref_check_ok(sc, bp, has_rmap);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (psa->refc_cur) {
+		error = xfs_refcount_has_record(psa->refc_cur, XFS_SB_BLOCK(mp),
+				1, &has_refcount);
+		if (xfs_scrub_should_xref(sc, &error, &psa->refc_cur))
+			xfs_scrub_block_xref_check_ok(sc, bp, !has_refcount);
+	}
+
 	return error;
 }
 
@@ -500,6 +510,7 @@ xfs_scrub_agf(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				have;
 	int				level;
 	int				error = 0;
@@ -675,6 +686,25 @@ xfs_scrub_agf(
 						agf->agf_btreeblks));
 	}
 
+	/* Cross-reference with the refcountbt. */
+	while (psa->refc_cur) {
+		error = xfs_refcount_has_record(psa->refc_cur,
+				XFS_AGF_BLOCK(mp), 1, &has_refcount);
+		if (!xfs_scrub_should_xref(sc, &error, &psa->refc_cur))
+			break;
+		xfs_scrub_block_xref_check_ok(sc, sc->sa.agf_bp,
+				!has_refcount);
+
+		error = xfs_btree_count_blocks(psa->refc_cur, &blocks);
+		if (!xfs_scrub_should_xref(sc, &error, &psa->refc_cur))
+			break;
+
+		xfs_scrub_block_xref_check_ok(sc, sc->sa.agf_bp,
+				blocks ==
+				be32_to_cpu(agf->agf_refcount_blocks));
+		break;
+	}
+
 out:
 	return error;
 }
@@ -700,6 +730,7 @@ xfs_scrub_agfl_block(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				error = 0;
 
 	xfs_scrub_block_check_ok(sc, sc->sa.agfl_bp,
@@ -748,6 +779,15 @@ xfs_scrub_agfl_block(
 					has_rmap);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (sc->sa.refc_cur) {
+		error = xfs_refcount_has_record(sc->sa.refc_cur, agbno, 1,
+				&has_refcount);
+		if (xfs_scrub_should_xref(sc, &error, &sc->sa.refc_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agfl_bp,
+					!has_refcount);
+	}
+
 	return error;
 }
 
@@ -763,6 +803,7 @@ xfs_scrub_agfl(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				error;
 
 	agno = sc->sm->sm_agno;
@@ -813,6 +854,15 @@ xfs_scrub_agfl(
 					has_rmap);
 	}
 
+	/* Set up cross-reference with refcountbt. */
+	if (sc->sa.refc_cur) {
+		error = xfs_refcount_has_record(sc->sa.refc_cur,
+				XFS_AGFL_BLOCK(mp), 1, &has_refcount);
+		if (xfs_scrub_should_xref(sc, &error, &sc->sa.refc_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agfl_bp,
+					!has_refcount);
+	}
+
 	/* Check the blocks in the AGFL. */
 	xfs_rmap_ag_owner(&sagfl.oinfo, XFS_RMAP_OWN_AG);
 	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sagfl);
@@ -844,6 +894,7 @@ xfs_scrub_agi(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				i;
 	int				level;
 	int				error = 0;
@@ -966,6 +1017,15 @@ xfs_scrub_agi(
 					has_rmap);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (psa->refc_cur) {
+		error = xfs_refcount_has_record(psa->refc_cur, XFS_AGI_BLOCK(mp),
+				1, &has_refcount);
+		if (xfs_scrub_should_xref(sc, &error, &psa->refc_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agi_bp,
+					!has_refcount);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index a45ca18..812843c 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -32,6 +32,7 @@
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -69,6 +70,7 @@ xfs_scrub_allocbt_helper(
 	xfs_extlen_t			len;
 	bool				has_rmap;
 	bool				has_inodes;
+	bool				has_refcount;
 	int				has_otherrec;
 	int				error = 0;
 
@@ -140,6 +142,15 @@ xfs_scrub_allocbt_helper(
 					!has_rmap);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (psa->refc_cur) {
+		error = xfs_refcount_has_record(psa->refc_cur, bno, len,
+				&has_refcount);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->refc_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->refc_cur, 0,
+					!has_refcount);
+	}
+
 	return error;
 }
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 1bd16db..21d88aa 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -37,6 +37,7 @@
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -210,6 +211,64 @@ xfs_scrub_bmap_xref_rmap(
 			!(rmap.rm_flags & XFS_RMAP_BMBT_BLOCK));
 }
 
+/* Make sure the refcount records match this extent. */
+STATIC void
+xfs_scrub_bmap_xref_refc(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_scrub_ag		*sa,
+	struct xfs_bmbt_irec		*irec,
+	xfs_fsblock_t			bno)
+{
+	struct xfs_refcount_irec	rc;
+	unsigned long long		rec_end;
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
+	bool				has_cowflag;
+	int				has_refcount;
+	int				error;
+
+	if (info->whichfork != XFS_COW_FORK) {
+		/* If this is shared, the inode flag must be set. */
+		error = xfs_refcount_find_shared(sa->refc_cur, bno,
+				irec->br_blockcount, &fbno, &flen,
+				false);
+		if (xfs_scrub_should_xref(info->sc, &error, &sa->refc_cur))
+			xfs_scrub_fblock_xref_check_ok(info->sc,
+					info->whichfork, irec->br_startoff,
+					flen == 0 ||
+					xfs_is_reflink_inode(info->sc->ip));
+		return;
+	}
+
+	/* Check this CoW staging extent. */
+	error = xfs_refcount_lookup_le(sa->refc_cur, bno + XFS_REFC_COW_START,
+			&has_refcount);
+	if (!xfs_scrub_should_xref(info->sc, &error, &sa->refc_cur) ||
+	    !xfs_scrub_fblock_xref_check_ok(info->sc, info->whichfork,
+			irec->br_startoff, has_refcount))
+		return;
+
+	error = xfs_refcount_get_rec(sa->refc_cur, &rc, &has_refcount);
+	if (!xfs_scrub_should_xref(info->sc, &error, &sa->refc_cur) ||
+	    !xfs_scrub_fblock_xref_check_ok(info->sc, info->whichfork,
+			irec->br_startoff, has_refcount))
+		return;
+
+	has_cowflag = !!(rc.rc_startblock & XFS_REFC_COW_START);
+	xfs_scrub_fblock_xref_check_ok(info->sc, info->whichfork,
+			irec->br_startoff,
+			(rc.rc_refcount == 1 && has_cowflag) ||
+			(rc.rc_refcount != 1 && !has_cowflag));
+
+	rc.rc_startblock &= ~XFS_REFC_COW_START;
+	rec_end = (unsigned long long)rc.rc_startblock + rc.rc_blockcount;
+	xfs_scrub_fblock_xref_check_ok(info->sc, info->whichfork,
+			irec->br_startoff,
+			rc.rc_startblock <= bno &&
+			bno + irec->br_blockcount <= rec_end &&
+			rc.rc_refcount == 1);
+}
+
 /* Scrub a single extent record. */
 STATIC int
 xfs_scrub_bmap_extent(
@@ -312,6 +371,13 @@ xfs_scrub_bmap_extent(
 	if (sa.rmap_cur)
 		xfs_scrub_bmap_xref_rmap(info, &sa, irec, bno);
 
+	/*
+	 * If this is a non-shared file on a reflink filesystem,
+	 * check the refcountbt to see if the flag is wrong.
+	 */
+	if (sa.refc_cur)
+		xfs_scrub_bmap_xref_refc(info, &sa, irec, bno);
+
 	xfs_scrub_ag_free(info->sc, &sa);
 out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 310d5ad..08baab0 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -37,6 +37,7 @@
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
 #include "xfs_alloc.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -77,6 +78,7 @@ xfs_scrub_iallocbt_chunk(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				error = 0;
 
 	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
@@ -128,6 +130,15 @@ xfs_scrub_iallocbt_chunk(
 					has_rmap);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (psa->refc_cur) {
+		error = xfs_refcount_has_record(psa->refc_cur, bno,
+				len, &has_refcount);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->refc_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->refc_cur, 0,
+					!has_refcount);
+	}
+
 	return true;
 }
 
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index e5e648d..c11401b 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -32,6 +32,7 @@
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -51,6 +52,66 @@ xfs_scrub_setup_ag_rmapbt(
 
 /* Reverse-mapping scrubber. */
 
+/* Cross-reference a rmap against the refcount btree. */
+STATIC void
+xfs_scrub_rmapbt_xref_refc(
+	struct xfs_scrub_btree		*bs,
+	struct xfs_rmap_irec		*irec,
+	bool				non_inode,
+	bool				is_attr,
+	bool				is_bmbt,
+	bool				is_unwritten)
+{
+	struct xfs_scrub_ag		*psa = &bs->sc->sa;
+	struct xfs_refcount_irec	crec;
+	unsigned long long		rec_end;
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
+	bool				has_cowflag;
+	int				has_refcount;
+	int				error;
+
+	if (irec->rm_owner != XFS_RMAP_OWN_COW) {
+		/* If this is shared, must be a data fork extent. */
+		error = xfs_refcount_find_shared(psa->refc_cur,
+				irec->rm_startblock, irec->rm_blockcount,
+				&fbno, &flen, false);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->refc_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->refc_cur, 0,
+					flen == 0 ||
+					(!non_inode && !is_attr &&
+					 !is_bmbt && !is_unwritten));
+		return;
+	}
+
+	/* Check this CoW staging extent. */
+	error = xfs_refcount_lookup_le(psa->refc_cur,
+			irec->rm_startblock + XFS_REFC_COW_START,
+			&has_refcount);
+	if (!xfs_scrub_should_xref(bs->sc, &error, &psa->refc_cur) ||
+	    !xfs_scrub_btree_xref_check_ok(bs->sc, psa->refc_cur, 0,
+			has_refcount))
+		return;
+
+	error = xfs_refcount_get_rec(psa->refc_cur, &crec, &has_refcount);
+	if (!xfs_scrub_should_xref(bs->sc, &error, &psa->refc_cur) ||
+	    !xfs_scrub_btree_xref_check_ok(bs->sc, psa->refc_cur, 0,
+			has_refcount))
+		return;
+
+	has_cowflag = !!(crec.rc_startblock & XFS_REFC_COW_START);
+	xfs_scrub_btree_xref_check_ok(bs->sc, psa->refc_cur, 0,
+			(crec.rc_refcount == 1 && has_cowflag) ||
+			(crec.rc_refcount != 1 && !has_cowflag));
+
+	crec.rc_startblock &= ~XFS_REFC_COW_START;
+	rec_end = (unsigned long long)crec.rc_startblock + crec.rc_blockcount;
+	xfs_scrub_btree_xref_check_ok(bs->sc, psa->refc_cur, 0,
+			crec.rc_startblock <= irec->rm_startblock &&
+			rec_end >= irec->rm_startblock + irec->rm_blockcount &&
+			crec.rc_refcount == 1);
+}
+
 /* Scrub an rmapbt record. */
 STATIC int
 xfs_scrub_rmapbt_helper(
@@ -157,6 +218,11 @@ xfs_scrub_rmapbt_helper(
 					!has_inodes);
 	}
 
+	/* Cross-reference with the refcount btree. */
+	if (psa->refc_cur)
+		xfs_scrub_rmapbt_xref_refc(bs, &irec, non_inode, is_attr,
+				is_bmbt, is_unwritten);
+
 out:
 	return error;
 }


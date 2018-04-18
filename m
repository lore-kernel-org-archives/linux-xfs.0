Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45936 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeDRCmM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:42:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2g5Yl100997
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:11 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2hdrxn8juu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:11 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2gBX0009804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:11 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2gBY3031313
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:11 GMT
Subject: [PATCH 03/24] xfs: add helpers to deal with transaction allocation
 and rolling
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:42:09 -0700
Message-ID: <152401932899.12079.11463794891965919567.stgit@magnolia>
In-Reply-To: <152401930978.12079.2000682561964128780.stgit@magnolia>
References: <152401930978.12079.2000682561964128780.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For repairs, we need to reserve at least as many blocks as we think
we're going to need to rebuild the data structure, and we're going to
need some helpers to roll transactions while maintaining locks on the AG
headers so that other threads cannot wander into the middle of a repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c   |    2 -
 fs/xfs/scrub/common.c |   21 ++++++-
 fs/xfs/scrub/common.h |    2 -
 fs/xfs/scrub/inode.c  |    4 +
 fs/xfs/scrub/repair.c |  152 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |   12 ++++
 6 files changed, 186 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 3f8fd10..df04215 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -74,7 +74,7 @@ xfs_scrub_setup_inode_bmap(
 	}
 
 	/* Got the inode, lock it and we're ready to go. */
-	error = xfs_scrub_trans_alloc(sc);
+	error = xfs_scrub_trans_alloc(sc, 0);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 93f9e7d..0833fa5 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -49,6 +49,7 @@
 #include "scrub/common.h"
 #include "scrub/trace.h"
 #include "scrub/btree.h"
+#include "scrub/repair.h"
 
 /* Common code for the metadata scrubbers. */
 
@@ -571,11 +572,22 @@ xfs_scrub_ag_init(
 /*
  * Grab an empty transaction so that we can re-grab locked buffers if
  * one of our btrees turns out to be cyclic.
+ *
+ * If we're going to repair something, we need to ask for the largest possible
+ * log reservation so that we can handle the worst case scenario for metadata
+ * updates while rebuilding a metadata item.  We also need to reserve as many
+ * blocks in the head transaction as we think we're going to need to rebuild
+ * the metadata object.
  */
 int
 xfs_scrub_trans_alloc(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub_context	*sc,
+	uint				resblks)
 {
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+		return xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
+				resblks, 0, 0, &sc->tp);
+
 	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
 }
 
@@ -585,7 +597,10 @@ xfs_scrub_setup_fs(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	return xfs_scrub_trans_alloc(sc);
+	uint				resblks;
+
+	resblks = xfs_repair_calc_ag_resblks(sc);
+	return xfs_scrub_trans_alloc(sc, resblks);
 }
 
 /* Set us up with AG headers and btree cursors. */
@@ -715,7 +730,7 @@ xfs_scrub_setup_inode_contents(
 	/* Got the inode, lock it and we're ready to go. */
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
-	error = xfs_scrub_trans_alloc(sc);
+	error = xfs_scrub_trans_alloc(sc, resblks);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 5d3e9c5..510aa8a 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -38,7 +38,7 @@ xfs_scrub_should_terminate(
 	return false;
 }
 
-int xfs_scrub_trans_alloc(struct xfs_scrub_context *sc);
+int xfs_scrub_trans_alloc(struct xfs_scrub_context *sc, uint resblks);
 bool xfs_scrub_process_error(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 		xfs_agblock_t bno, int *error);
 bool xfs_scrub_fblock_process_error(struct xfs_scrub_context *sc, int whichfork,
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index e15b1bc..a807ad4 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -67,7 +67,7 @@ xfs_scrub_setup_inode(
 		break;
 	case -EFSCORRUPTED:
 	case -EFSBADCRC:
-		return xfs_scrub_trans_alloc(sc);
+		return xfs_scrub_trans_alloc(sc, 0);
 	default:
 		return error;
 	}
@@ -75,7 +75,7 @@ xfs_scrub_setup_inode(
 	/* Got the inode, lock it and we're ready to go. */
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
-	error = xfs_scrub_trans_alloc(sc);
+	error = xfs_scrub_trans_alloc(sc, 0);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index be30825..ab053d0 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -128,3 +128,155 @@ xfs_repair_probe(
 
 	return 0;
 }
+
+/*
+ * Roll a transaction, keeping the AG headers locked and reinitializing
+ * the btree cursors.
+ */
+int
+xfs_repair_roll_ag_trans(
+	struct xfs_scrub_context	*sc)
+{
+	int				error;
+
+	/* Keep the AG header buffers locked so we can keep going. */
+	xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
+	xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
+	xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
+
+	/* Roll the transaction. */
+	error = xfs_trans_roll(&sc->tp);
+	if (error)
+		goto out_release;
+
+	/* Join AG headers to the new transaction. */
+	xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
+	xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
+	xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
+
+	return 0;
+
+out_release:
+	/*
+	 * Rolling failed, so release the hold on the buffers.  The
+	 * buffers will be released during teardown on our way out
+	 * of the kernel.
+	 */
+	xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
+	xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
+	xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
+
+	return error;
+}
+
+/*
+ * Does the given AG have enough space to rebuild a btree?  Neither AG
+ * reservation can be critical, and we must have enough space (factoring
+ * in AG reservations) to construct a whole btree.
+ */
+bool
+xfs_repair_ag_has_space(
+	struct xfs_perag		*pag,
+	xfs_extlen_t			nr_blocks,
+	enum xfs_ag_resv_type		type)
+{
+	return  !xfs_ag_resv_critical(pag, XFS_AG_RESV_AGFL) &&
+		!xfs_ag_resv_critical(pag, XFS_AG_RESV_METADATA) &&
+		pag->pagf_freeblks > xfs_ag_resv_needed(pag, type) + nr_blocks;
+}
+
+/*
+ * Figure out how many blocks to reserve for an AG repair.  We calculate the
+ * worst case estimate for the number of blocks we'd need to rebuild one of
+ * any type of per-AG btree.
+ */
+xfs_extlen_t
+xfs_repair_calc_ag_resblks(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_scrub_metadata	*sm = sc->sm;
+	struct xfs_perag		*pag;
+	struct xfs_buf			*bp;
+	xfs_agino_t			icount = 0;
+	xfs_extlen_t			aglen = 0;
+	xfs_extlen_t			usedlen;
+	xfs_extlen_t			freelen;
+	xfs_extlen_t			bnobt_sz;
+	xfs_extlen_t			inobt_sz;
+	xfs_extlen_t			rmapbt_sz;
+	xfs_extlen_t			refcbt_sz;
+	int				error;
+
+	if (!(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
+		return 0;
+
+	/* Use in-core counters if possible. */
+	pag = xfs_perag_get(mp, sm->sm_agno);
+	if (pag->pagi_init)
+		icount = pag->pagi_count;
+	xfs_perag_put(pag);
+
+	/*
+	 * Otherwise try to get the actual counters from disk; if not, make
+	 * some worst case assumptions.
+	 */
+	if (icount == 0) {
+		error = xfs_ialloc_read_agi(mp, NULL, sm->sm_agno, &bp);
+		if (error) {
+			icount = mp->m_sb.sb_agblocks / mp->m_sb.sb_inopblock;
+		} else {
+			pag = xfs_perag_get(mp, sm->sm_agno);
+			icount = pag->pagi_count;
+			xfs_perag_put(pag);
+			xfs_buf_relse(bp);
+		}
+	}
+
+	/* Now grab the block counters from the AGF. */
+	error = xfs_alloc_read_agf(mp, NULL, sm->sm_agno, 0, &bp);
+	if (error) {
+		aglen = mp->m_sb.sb_agblocks;
+		freelen = aglen;
+		usedlen = aglen;
+	} else {
+		pag = xfs_perag_get(mp, sm->sm_agno);
+		aglen = be32_to_cpu(XFS_BUF_TO_AGF(bp)->agf_length);
+		freelen = pag->pagf_freeblks;
+		usedlen = aglen - freelen;
+		xfs_perag_put(pag);
+		xfs_buf_relse(bp);
+	}
+
+	trace_xfs_repair_calc_ag_resblks(mp, sm->sm_agno, icount, aglen,
+			freelen, usedlen);
+
+	/*
+	 * Figure out how many blocks we'd need worst case to rebuild
+	 * each type of btree.  Note that we can only rebuild the
+	 * bnobt/cntbt or inobt/finobt as pairs.
+	 */
+	bnobt_sz = 2 * xfs_allocbt_calc_size(mp, freelen);
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
+				XFS_INODES_PER_HOLEMASK_BIT);
+	else
+		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
+				XFS_INODES_PER_CHUNK);
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		inobt_sz *= 2;
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		rmapbt_sz = xfs_rmapbt_calc_size(mp, aglen);
+		refcbt_sz = xfs_refcountbt_calc_size(mp, usedlen);
+	} else {
+		rmapbt_sz = xfs_rmapbt_calc_size(mp, usedlen);
+		refcbt_sz = 0;
+	}
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		rmapbt_sz = 0;
+
+	trace_xfs_repair_calc_ag_resblks_btsize(mp, sm->sm_agno, bnobt_sz,
+			inobt_sz, rmapbt_sz, refcbt_sz);
+
+	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 83170dd..8d181dc 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -32,6 +32,10 @@ static inline int xfs_repair_notsupported(struct xfs_scrub_context *sc)
 int xfs_repair_attempt(struct xfs_inode *ip, struct xfs_scrub_context *sc,
 		bool *fixed);
 void xfs_repair_failure(struct xfs_mount *mp);
+int xfs_repair_roll_ag_trans(struct xfs_scrub_context *sc);
+bool xfs_repair_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
+		enum xfs_ag_resv_type type);
+xfs_extlen_t xfs_repair_calc_ag_resblks(struct xfs_scrub_context *sc);
 
 /* Metadata repairers */
 
@@ -49,6 +53,14 @@ static inline int xfs_repair_attempt(
 
 static inline void xfs_repair_failure(struct xfs_mount *mp) {}
 
+static inline xfs_extlen_t
+xfs_repair_calc_ag_resblks(
+	struct xfs_scrub_context	*sc)
+{
+	ASSERT(!(sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR));
+	return 0;
+}
+
 #define xfs_repair_probe		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60810 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753908AbeARAMX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 19:12:23 -0500
Subject: [PATCH 1/5] xfs: convert XFS_AGFL_SIZE to a helper function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Jan 2018 16:07:17 -0800
Message-ID: <151623403752.4727.11057315462007855705.stgit@magnolia>
In-Reply-To: <151623403113.4727.2418454911805718650.stgit@magnolia>
References: <151623403113.4727.2418454911805718650.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

The AGFL size calculation is about to get more complex, so lets turn
the macro into a function first and remove the macro.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick: forward port to newer kernel, simplify the helper]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |   31 ++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_alloc.h  |    2 ++
 fs/xfs/libxfs/xfs_format.h |   13 +------------
 fs/xfs/scrub/agheader.c    |   10 +++++-----
 fs/xfs/scrub/repair.c      |    2 +-
 fs/xfs/xfs_fsops.c         |    2 +-
 6 files changed, 34 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6883a76..f3f17a1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -53,6 +53,23 @@ STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
 
+/*
+ * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of slots in
+ * the beginning of the block for a proper header with the location information
+ * and CRC.
+ */
+unsigned int
+xfs_agfl_size(
+	struct xfs_mount	*mp)
+{
+	unsigned int		size = mp->m_sb.sb_sectsize;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		size -= sizeof(struct xfs_agfl);
+
+	return size / sizeof(xfs_agblock_t);
+}
+
 unsigned int
 xfs_refc_block(
 	struct xfs_mount	*mp)
@@ -550,7 +567,7 @@ xfs_agfl_verify(
 	if (bp->b_pag && be32_to_cpu(agfl->agfl_seqno) != bp->b_pag->pag_agno)
 		return __this_address;
 
-	for (i = 0; i < XFS_AGFL_SIZE(mp); i++) {
+	for (i = 0; i < xfs_agfl_size(mp); i++) {
 		if (be32_to_cpu(agfl->agfl_bno[i]) != NULLAGBLOCK &&
 		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
 			return __this_address;
@@ -2266,7 +2283,7 @@ xfs_alloc_get_freelist(
 	bno = be32_to_cpu(agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
 	be32_add_cpu(&agf->agf_flfirst, 1);
 	xfs_trans_brelse(tp, agflbp);
-	if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
+	if (be32_to_cpu(agf->agf_flfirst) == xfs_agfl_size(mp))
 		agf->agf_flfirst = 0;
 
 	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
@@ -2377,7 +2394,7 @@ xfs_alloc_put_freelist(
 			be32_to_cpu(agf->agf_seqno), &agflbp)))
 		return error;
 	be32_add_cpu(&agf->agf_fllast, 1);
-	if (be32_to_cpu(agf->agf_fllast) == XFS_AGFL_SIZE(mp))
+	if (be32_to_cpu(agf->agf_fllast) == xfs_agfl_size(mp))
 		agf->agf_fllast = 0;
 
 	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
@@ -2395,7 +2412,7 @@ xfs_alloc_put_freelist(
 
 	xfs_alloc_log_agf(tp, agbp, logflags);
 
-	ASSERT(be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp));
+	ASSERT(be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp));
 
 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
 	blockp = &agfl_bno[be32_to_cpu(agf->agf_fllast)];
@@ -2428,9 +2445,9 @@ xfs_agf_verify(
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
 	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
-	      be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
-	      be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
-	      be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp)))
+	      be32_to_cpu(agf->agf_flfirst) < xfs_agfl_size(mp) &&
+	      be32_to_cpu(agf->agf_fllast) < xfs_agfl_size(mp) &&
+	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
 		return __this_address;
 
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 65a0caf..a311a24 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -26,6 +26,8 @@ struct xfs_trans;
 
 extern struct workqueue_struct *xfs_alloc_wq;
 
+unsigned int xfs_agfl_size(struct xfs_mount *mp);
+
 /*
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
  */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 826296f..bb42a11 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -810,24 +810,13 @@ typedef struct xfs_agi {
 		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
 		(__be32 *)(bp)->b_addr)
 
-/*
- * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of
- * slots in the beginning of the block for a proper header with the
- * location information and CRC.
- */
-#define XFS_AGFL_SIZE(mp) \
-	(((mp)->m_sb.sb_sectsize - \
-	 (xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-		sizeof(struct xfs_agfl) : 0)) / \
-	  sizeof(xfs_agblock_t))
-
 typedef struct xfs_agfl {
 	__be32		agfl_magicnum;
 	__be32		agfl_seqno;
 	uuid_t		agfl_uuid;
 	__be64		agfl_lsn;
 	__be32		agfl_crc;
-	__be32		agfl_bno[];	/* actually XFS_AGFL_SIZE(mp) */
+	__be32		agfl_bno[];	/* actually xfs_agfl_size(mp) */
 } __attribute__((packed)) xfs_agfl_t;
 
 #define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index c2cec24..fbd1744 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -86,7 +86,7 @@ xfs_scrub_walk_agfl(
 	}
 
 	/* first to the end */
-	for (i = flfirst; i < XFS_AGFL_SIZE(mp); i++) {
+	for (i = flfirst; i < xfs_agfl_size(mp); i++) {
 		error = fn(sc, be32_to_cpu(agfl_bno[i]), priv);
 		if (error)
 			return error;
@@ -705,7 +705,7 @@ xfs_scrub_agf(
 	if (agfl_last > agfl_first)
 		fl_count = agfl_last - agfl_first + 1;
 	else
-		fl_count = XFS_AGFL_SIZE(mp) - agfl_first + agfl_last + 1;
+		fl_count = xfs_agfl_size(mp) - agfl_first + agfl_last + 1;
 	if (agfl_count != 0 && fl_count != agfl_count)
 		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
 
@@ -770,7 +770,7 @@ xfs_repair_agf_check_agfl(
 	}
 
 	/* first to the end */
-	for (i = flfirst; i < XFS_AGFL_SIZE(mp); i++) {
+	for (i = flfirst; i < xfs_agfl_size(mp); i++) {
 		bno = be32_to_cpu(agfl_bno[i]);
 		if (!xfs_verify_agbno(mp, sc->sa.agno, bno))
 			return -EFSCORRUPTED;
@@ -1079,7 +1079,7 @@ xfs_scrub_agfl(
 	/* Allocate buffer to ensure uniqueness of AGFL entries. */
 	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
 	agflcount = be32_to_cpu(agf->agf_flcount);
-	if (agflcount > XFS_AGFL_SIZE(sc->mp)) {
+	if (agflcount > xfs_agfl_size(sc->mp)) {
 		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
 		goto out;
 	}
@@ -1286,7 +1286,7 @@ xfs_repair_agfl(
 		trace_xfs_repair_agfl_insert(mp, sc->sa.agno, agbno, rbe->len);
 
 		for (bno = 0; bno < rbe->len; bno++) {
-			if (flcount >= XFS_AGFL_SIZE(mp) - 1)
+			if (flcount >= xfs_agfl_size(mp) - 1)
 				break;
 			agfl_bno[flcount + 1] = cpu_to_be32(agbno + bno);
 			flcount++;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index bc13aa5..c8d699b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -604,7 +604,7 @@ xfs_repair_is_block_in_agfl(
 	}
 
 	/* first to the end */
-	for (i = flfirst; i < XFS_AGFL_SIZE(mp); i++) {
+	for (i = flfirst; i < xfs_agfl_size(mp); i++) {
 		if (be32_to_cpu(agfl_bno[i]) == agbno)
 			return true;
 	}
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 84d7383..b1e6292 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -217,7 +217,7 @@ xfs_growfs_data_private(
 		}
 
 		agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, bp);
-		for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
+		for (bucket = 0; bucket < xfs_agfl_size(mp); bucket++)
 			agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
 
 		error = xfs_bwrite(bp);


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37752 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbeGRQas (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 12:30:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6IFn68k167231
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:51:55 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2k9yjx2903-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:51:54 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6IFprNX026508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:51:53 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6IFprb1003246
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:51:53 GMT
Subject: [PATCH 5/8] xfs: shorten xfs_scrub_ prefix
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 18 Jul 2018 08:51:51 -0700
Message-ID: <153192911134.31685.16403417933365296036.stgit@magnolia>
In-Reply-To: <153192902811.31685.11590100183112248407.stgit@magnolia>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Shorten all the metadata checking xfs_scrub_ prefixes to xchk_.  After
this, the only xfs_scrub* symbols are the ones that pertain to both
scrub and repair.  Whitespace damage will be fixed in a subsequent
patch.  There are no functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |  318 ++++++++++++++++++++++++-----------------------
 fs/xfs/scrub/alloc.c    |   56 ++++----
 fs/xfs/scrub/attr.c     |  106 ++++++++--------
 fs/xfs/scrub/bmap.c     |  176 +++++++++++++-------------
 fs/xfs/scrub/btree.c    |  166 ++++++++++++-------------
 fs/xfs/scrub/btree.h    |   22 ++-
 fs/xfs/scrub/common.c   |  172 +++++++++++++------------
 fs/xfs/scrub/common.h   |  102 ++++++++-------
 fs/xfs/scrub/dabtree.c  |  124 +++++++++---------
 fs/xfs/scrub/dabtree.h  |   14 +-
 fs/xfs/scrub/dir.c      |  170 +++++++++++++------------
 fs/xfs/scrub/ialloc.c   |  138 ++++++++++----------
 fs/xfs/scrub/inode.c    |  160 ++++++++++++------------
 fs/xfs/scrub/parent.c   |   62 +++++----
 fs/xfs/scrub/quota.c    |   64 +++++----
 fs/xfs/scrub/refcount.c |  114 ++++++++---------
 fs/xfs/scrub/repair.c   |    4 -
 fs/xfs/scrub/rmap.c     |   78 ++++++------
 fs/xfs/scrub/rtbitmap.c |   30 ++--
 fs/xfs/scrub/scrub.c    |  142 +++++++++++----------
 fs/xfs/scrub/scrub.h    |   82 ++++++------
 fs/xfs/scrub/symlink.c  |   14 +-
 fs/xfs/scrub/trace.c    |    2 
 fs/xfs/scrub/trace.h    |   70 +++++-----
 24 files changed, 1196 insertions(+), 1190 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 9bb0745f1ad2..c0625ec16d63 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -28,7 +28,7 @@
 
 /* Cross-reference with the other btrees. */
 STATIC void
-xfs_scrub_superblock_xref(
+xchk_superblock_xref(
 	struct xfs_scrub_context	*sc,
 	struct xfs_buf			*bp)
 {
@@ -43,15 +43,15 @@ xfs_scrub_superblock_xref(
 
 	agbno = XFS_SB_BLOCK(mp);
 
-	error = xfs_scrub_ag_init(sc, agno, &sc->sa);
-	if (!xfs_scrub_xref_process_error(sc, agno, agbno, &error))
+	error = xchk_ag_init(sc, agno, &sc->sa);
+	if (!xchk_xref_process_error(sc, agno, agbno, &error))
 		return;
 
-	xfs_scrub_xref_is_used_space(sc, agbno, 1);
-	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
+	xchk_xref_is_used_space(sc, agbno, 1);
+	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
-	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
-	xfs_scrub_xref_is_not_shared(sc, agbno, 1);
+	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xchk_xref_is_not_shared(sc, agbno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -65,7 +65,7 @@ xfs_scrub_superblock_xref(
  * sb 0 is ok and we can use its information to check everything else.
  */
 int
-xfs_scrub_superblock(
+xchk_superblock(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_mount		*mp = sc->mp;
@@ -98,7 +98,7 @@ xfs_scrub_superblock(
 	default:
 		break;
 	}
-	if (!xfs_scrub_process_error(sc, agno, XFS_SB_BLOCK(mp), &error))
+	if (!xchk_process_error(sc, agno, XFS_SB_BLOCK(mp), &error))
 		return error;
 
 	sb = XFS_BUF_TO_SBP(bp);
@@ -110,46 +110,46 @@ xfs_scrub_superblock(
 	 * checked.
 	 */
 	if (sb->sb_blocksize != cpu_to_be32(mp->m_sb.sb_blocksize))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_dblocks != cpu_to_be64(mp->m_sb.sb_dblocks))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_rblocks != cpu_to_be64(mp->m_sb.sb_rblocks))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_rextents != cpu_to_be64(mp->m_sb.sb_rextents))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (!uuid_equal(&sb->sb_uuid, &mp->m_sb.sb_uuid))
-		xfs_scrub_block_set_preen(sc, bp);
+		xchk_block_set_preen(sc, bp);
 
 	if (sb->sb_logstart != cpu_to_be64(mp->m_sb.sb_logstart))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_rootino != cpu_to_be64(mp->m_sb.sb_rootino))
-		xfs_scrub_block_set_preen(sc, bp);
+		xchk_block_set_preen(sc, bp);
 
 	if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
-		xfs_scrub_block_set_preen(sc, bp);
+		xchk_block_set_preen(sc, bp);
 
 	if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
-		xfs_scrub_block_set_preen(sc, bp);
+		xchk_block_set_preen(sc, bp);
 
 	if (sb->sb_rextsize != cpu_to_be32(mp->m_sb.sb_rextsize))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_agblocks != cpu_to_be32(mp->m_sb.sb_agblocks))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_agcount != cpu_to_be32(mp->m_sb.sb_agcount))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_rbmblocks != cpu_to_be32(mp->m_sb.sb_rbmblocks))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_logblocks != cpu_to_be32(mp->m_sb.sb_logblocks))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	/* Check sb_versionnum bits that are set at mkfs time. */
 	vernum_mask = cpu_to_be16(~XFS_SB_VERSION_OKBITS |
@@ -163,7 +163,7 @@ xfs_scrub_superblock(
 				  XFS_SB_VERSION_DIRV2BIT);
 	if ((sb->sb_versionnum & vernum_mask) !=
 	    (cpu_to_be16(mp->m_sb.sb_versionnum) & vernum_mask))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	/* Check sb_versionnum bits that can be set after mkfs time. */
 	vernum_mask = cpu_to_be16(XFS_SB_VERSION_ATTRBIT |
@@ -171,40 +171,40 @@ xfs_scrub_superblock(
 				  XFS_SB_VERSION_QUOTABIT);
 	if ((sb->sb_versionnum & vernum_mask) !=
 	    (cpu_to_be16(mp->m_sb.sb_versionnum) & vernum_mask))
-		xfs_scrub_block_set_preen(sc, bp);
+		xchk_block_set_preen(sc, bp);
 
 	if (sb->sb_sectsize != cpu_to_be16(mp->m_sb.sb_sectsize))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_inodesize != cpu_to_be16(mp->m_sb.sb_inodesize))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_inopblock != cpu_to_be16(mp->m_sb.sb_inopblock))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (memcmp(sb->sb_fname, mp->m_sb.sb_fname, sizeof(sb->sb_fname)))
-		xfs_scrub_block_set_preen(sc, bp);
+		xchk_block_set_preen(sc, bp);
 
 	if (sb->sb_blocklog != mp->m_sb.sb_blocklog)
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_sectlog != mp->m_sb.sb_sectlog)
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_inodelog != mp->m_sb.sb_inodelog)
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_inopblog != mp->m_sb.sb_inopblog)
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_agblklog != mp->m_sb.sb_agblklog)
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_rextslog != mp->m_sb.sb_rextslog)
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_imax_pct != mp->m_sb.sb_imax_pct)
-		xfs_scrub_block_set_preen(sc, bp);
+		xchk_block_set_preen(sc, bp);
 
 	/*
 	 * Skip the summary counters since we track them in memory anyway.
@@ -212,10 +212,10 @@ xfs_scrub_superblock(
 	 */
 
 	if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
-		xfs_scrub_block_set_preen(sc, bp);
+		xchk_block_set_preen(sc, bp);
 
 	if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
-		xfs_scrub_block_set_preen(sc, bp);
+		xchk_block_set_preen(sc, bp);
 
 	/*
 	 * Skip the quota flags since repair will force quotacheck.
@@ -223,46 +223,46 @@ xfs_scrub_superblock(
 	 */
 
 	if (sb->sb_flags != mp->m_sb.sb_flags)
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_shared_vn != mp->m_sb.sb_shared_vn)
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_inoalignmt != cpu_to_be32(mp->m_sb.sb_inoalignmt))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_unit != cpu_to_be32(mp->m_sb.sb_unit))
-		xfs_scrub_block_set_preen(sc, bp);
+		xchk_block_set_preen(sc, bp);
 
 	if (sb->sb_width != cpu_to_be32(mp->m_sb.sb_width))
-		xfs_scrub_block_set_preen(sc, bp);
+		xchk_block_set_preen(sc, bp);
 
 	if (sb->sb_dirblklog != mp->m_sb.sb_dirblklog)
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_logsectlog != mp->m_sb.sb_logsectlog)
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_logsectsize != cpu_to_be16(mp->m_sb.sb_logsectsize))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (sb->sb_logsunit != cpu_to_be32(mp->m_sb.sb_logsunit))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	/* Do we see any invalid bits in sb_features2? */
 	if (!xfs_sb_version_hasmorebits(&mp->m_sb)) {
 		if (sb->sb_features2 != 0)
-			xfs_scrub_block_set_corrupt(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 	} else {
 		v2_ok = XFS_SB_VERSION2_OKBITS;
 		if (XFS_SB_VERSION_NUM(&mp->m_sb) >= XFS_SB_VERSION_5)
 			v2_ok |= XFS_SB_VERSION2_CRCBIT;
 
 		if (!!(sb->sb_features2 & cpu_to_be32(~v2_ok)))
-			xfs_scrub_block_set_corrupt(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 
 		if (sb->sb_features2 != sb->sb_bad_features2)
-			xfs_scrub_block_set_preen(sc, bp);
+			xchk_block_set_preen(sc, bp);
 	}
 
 	/* Check sb_features2 flags that are set at mkfs time. */
@@ -272,26 +272,26 @@ xfs_scrub_superblock(
 				    XFS_SB_VERSION2_FTYPE);
 	if ((sb->sb_features2 & features_mask) !=
 	    (cpu_to_be32(mp->m_sb.sb_features2) & features_mask))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	/* Check sb_features2 flags that can be set after mkfs time. */
 	features_mask = cpu_to_be32(XFS_SB_VERSION2_ATTR2BIT);
 	if ((sb->sb_features2 & features_mask) !=
 	    (cpu_to_be32(mp->m_sb.sb_features2) & features_mask))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
 		/* all v5 fields must be zero */
 		if (memchr_inv(&sb->sb_features_compat, 0,
 				sizeof(struct xfs_dsb) -
 				offsetof(struct xfs_dsb, sb_features_compat)))
-			xfs_scrub_block_set_corrupt(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 	} else {
 		/* Check compat flags; all are set at mkfs time. */
 		features_mask = cpu_to_be32(XFS_SB_FEAT_COMPAT_UNKNOWN);
 		if ((sb->sb_features_compat & features_mask) !=
 		    (cpu_to_be32(mp->m_sb.sb_features_compat) & features_mask))
-			xfs_scrub_block_set_corrupt(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 
 		/* Check ro compat flags; all are set at mkfs time. */
 		features_mask = cpu_to_be32(XFS_SB_FEAT_RO_COMPAT_UNKNOWN |
@@ -301,7 +301,7 @@ xfs_scrub_superblock(
 		if ((sb->sb_features_ro_compat & features_mask) !=
 		    (cpu_to_be32(mp->m_sb.sb_features_ro_compat) &
 		     features_mask))
-			xfs_scrub_block_set_corrupt(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 
 		/* Check incompat flags; all are set at mkfs time. */
 		features_mask = cpu_to_be32(XFS_SB_FEAT_INCOMPAT_UNKNOWN |
@@ -311,22 +311,22 @@ xfs_scrub_superblock(
 		if ((sb->sb_features_incompat & features_mask) !=
 		    (cpu_to_be32(mp->m_sb.sb_features_incompat) &
 		     features_mask))
-			xfs_scrub_block_set_corrupt(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 
 		/* Check log incompat flags; all are set at mkfs time. */
 		features_mask = cpu_to_be32(XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN);
 		if ((sb->sb_features_log_incompat & features_mask) !=
 		    (cpu_to_be32(mp->m_sb.sb_features_log_incompat) &
 		     features_mask))
-			xfs_scrub_block_set_corrupt(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 
 		/* Don't care about sb_crc */
 
 		if (sb->sb_spino_align != cpu_to_be32(mp->m_sb.sb_spino_align))
-			xfs_scrub_block_set_corrupt(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 
 		if (sb->sb_pquotino != cpu_to_be64(mp->m_sb.sb_pquotino))
-			xfs_scrub_block_set_preen(sc, bp);
+			xchk_block_set_preen(sc, bp);
 
 		/* Don't care about sb_lsn */
 	}
@@ -334,15 +334,15 @@ xfs_scrub_superblock(
 	if (xfs_sb_version_hasmetauuid(&mp->m_sb)) {
 		/* The metadata UUID must be the same for all supers */
 		if (!uuid_equal(&sb->sb_meta_uuid, &mp->m_sb.sb_meta_uuid))
-			xfs_scrub_block_set_corrupt(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 	}
 
 	/* Everything else must be zero. */
 	if (memchr_inv(sb + 1, 0,
 			BBTOB(bp->b_length) - sizeof(struct xfs_dsb)))
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 
-	xfs_scrub_superblock_xref(sc, bp);
+	xchk_superblock_xref(sc, bp);
 
 	return error;
 }
@@ -351,7 +351,7 @@ xfs_scrub_superblock(
 
 /* Tally freespace record lengths. */
 STATIC int
-xfs_scrub_agf_record_bno_lengths(
+xchk_agf_record_bno_lengths(
 	struct xfs_btree_cur		*cur,
 	struct xfs_alloc_rec_incore	*rec,
 	void				*priv)
@@ -364,7 +364,7 @@ xfs_scrub_agf_record_bno_lengths(
 
 /* Check agf_freeblks */
 static inline void
-xfs_scrub_agf_xref_freeblks(
+xchk_agf_xref_freeblks(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
@@ -375,16 +375,16 @@ xfs_scrub_agf_xref_freeblks(
 		return;
 
 	error = xfs_alloc_query_all(sc->sa.bno_cur,
-			xfs_scrub_agf_record_bno_lengths, &blocks);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.bno_cur))
+			xchk_agf_record_bno_lengths, &blocks);
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.bno_cur))
 		return;
 	if (blocks != be32_to_cpu(agf->agf_freeblks))
-		xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+		xchk_block_xref_set_corrupt(sc, sc->sa.agf_bp);
 }
 
 /* Cross reference the AGF with the cntbt (freespace by length btree) */
 static inline void
-xfs_scrub_agf_xref_cntbt(
+xchk_agf_xref_cntbt(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
@@ -398,25 +398,25 @@ xfs_scrub_agf_xref_cntbt(
 
 	/* Any freespace at all? */
 	error = xfs_alloc_lookup_le(sc->sa.cnt_cur, 0, -1U, &have);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.cnt_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.cnt_cur))
 		return;
 	if (!have) {
 		if (agf->agf_freeblks != be32_to_cpu(0))
-			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+			xchk_block_xref_set_corrupt(sc, sc->sa.agf_bp);
 		return;
 	}
 
 	/* Check agf_longest */
 	error = xfs_alloc_get_rec(sc->sa.cnt_cur, &agbno, &blocks, &have);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.cnt_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.cnt_cur))
 		return;
 	if (!have || blocks != be32_to_cpu(agf->agf_longest))
-		xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+		xchk_block_xref_set_corrupt(sc, sc->sa.agf_bp);
 }
 
 /* Check the btree block counts in the AGF against the btrees. */
 STATIC void
-xfs_scrub_agf_xref_btreeblks(
+xchk_agf_xref_btreeblks(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
@@ -428,11 +428,11 @@ xfs_scrub_agf_xref_btreeblks(
 	/* Check agf_rmap_blocks; set up for agf_btreeblks check */
 	if (sc->sa.rmap_cur) {
 		error = xfs_btree_count_blocks(sc->sa.rmap_cur, &blocks);
-		if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+		if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 			return;
 		btreeblks = blocks - 1;
 		if (blocks != be32_to_cpu(agf->agf_rmap_blocks))
-			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+			xchk_block_xref_set_corrupt(sc, sc->sa.agf_bp);
 	} else {
 		btreeblks = 0;
 	}
@@ -447,22 +447,22 @@ xfs_scrub_agf_xref_btreeblks(
 
 	/* Check agf_btreeblks */
 	error = xfs_btree_count_blocks(sc->sa.bno_cur, &blocks);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.bno_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.bno_cur))
 		return;
 	btreeblks += blocks - 1;
 
 	error = xfs_btree_count_blocks(sc->sa.cnt_cur, &blocks);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.cnt_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.cnt_cur))
 		return;
 	btreeblks += blocks - 1;
 
 	if (btreeblks != be32_to_cpu(agf->agf_btreeblks))
-		xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+		xchk_block_xref_set_corrupt(sc, sc->sa.agf_bp);
 }
 
 /* Check agf_refcount_blocks against tree size */
 static inline void
-xfs_scrub_agf_xref_refcblks(
+xchk_agf_xref_refcblks(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
@@ -473,15 +473,15 @@ xfs_scrub_agf_xref_refcblks(
 		return;
 
 	error = xfs_btree_count_blocks(sc->sa.refc_cur, &blocks);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
 	if (blocks != be32_to_cpu(agf->agf_refcount_blocks))
-		xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+		xchk_block_xref_set_corrupt(sc, sc->sa.agf_bp);
 }
 
 /* Cross-reference with the other btrees. */
 STATIC void
-xfs_scrub_agf_xref(
+xchk_agf_xref(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_owner_info		oinfo;
@@ -494,26 +494,26 @@ xfs_scrub_agf_xref(
 
 	agbno = XFS_AGF_BLOCK(mp);
 
-	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
+	error = xchk_ag_btcur_init(sc, &sc->sa);
 	if (error)
 		return;
 
-	xfs_scrub_xref_is_used_space(sc, agbno, 1);
-	xfs_scrub_agf_xref_freeblks(sc);
-	xfs_scrub_agf_xref_cntbt(sc);
-	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
+	xchk_xref_is_used_space(sc, agbno, 1);
+	xchk_agf_xref_freeblks(sc);
+	xchk_agf_xref_cntbt(sc);
+	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
-	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
-	xfs_scrub_agf_xref_btreeblks(sc);
-	xfs_scrub_xref_is_not_shared(sc, agbno, 1);
-	xfs_scrub_agf_xref_refcblks(sc);
+	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xchk_agf_xref_btreeblks(sc);
+	xchk_xref_is_not_shared(sc, agbno, 1);
+	xchk_agf_xref_refcblks(sc);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
 
 /* Scrub the AGF. */
 int
-xfs_scrub_agf(
+xchk_agf(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_mount		*mp = sc->mp;
@@ -529,54 +529,54 @@ xfs_scrub_agf(
 	int				error = 0;
 
 	agno = sc->sa.agno = sc->sm->sm_agno;
-	error = xfs_scrub_ag_read_headers(sc, agno, &sc->sa.agi_bp,
+	error = xchk_ag_read_headers(sc, agno, &sc->sa.agi_bp,
 			&sc->sa.agf_bp, &sc->sa.agfl_bp);
-	if (!xfs_scrub_process_error(sc, agno, XFS_AGF_BLOCK(sc->mp), &error))
+	if (!xchk_process_error(sc, agno, XFS_AGF_BLOCK(sc->mp), &error))
 		goto out;
-	xfs_scrub_buffer_recheck(sc, sc->sa.agf_bp);
+	xchk_buffer_recheck(sc, sc->sa.agf_bp);
 
 	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
 
 	/* Check the AG length */
 	eoag = be32_to_cpu(agf->agf_length);
 	if (eoag != xfs_ag_block_count(mp, agno))
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	/* Check the AGF btree roots and levels */
 	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
 	if (!xfs_verify_agbno(mp, agno, agbno))
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
 	if (!xfs_verify_agbno(mp, agno, agbno))
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
 	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
 	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
 		agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
 		if (!xfs_verify_agbno(mp, agno, agbno))
-			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 		level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
 		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
-			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 	}
 
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
 		agbno = be32_to_cpu(agf->agf_refcount_root);
 		if (!xfs_verify_agbno(mp, agno, agbno))
-			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 		level = be32_to_cpu(agf->agf_refcount_level);
 		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
-			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 	}
 
 	/* Check the AGFL counters */
@@ -588,16 +588,16 @@ xfs_scrub_agf(
 	else
 		fl_count = xfs_agfl_size(mp) - agfl_first + agfl_last + 1;
 	if (agfl_count != 0 && fl_count != agfl_count)
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
-	xfs_scrub_agf_xref(sc);
+	xchk_agf_xref(sc);
 out:
 	return error;
 }
 
 /* AGFL */
 
-struct xfs_scrub_agfl_info {
+struct xchk_agfl_info {
 	struct xfs_owner_info		oinfo;
 	unsigned int			sz_entries;
 	unsigned int			nr_entries;
@@ -607,7 +607,7 @@ struct xfs_scrub_agfl_info {
 
 /* Cross-reference with the other btrees. */
 STATIC void
-xfs_scrub_agfl_block_xref(
+xchk_agfl_block_xref(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			agbno,
 	struct xfs_owner_info		*oinfo)
@@ -615,20 +615,20 @@ xfs_scrub_agfl_block_xref(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
-	xfs_scrub_xref_is_used_space(sc, agbno, 1);
-	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
-	xfs_scrub_xref_is_owned_by(sc, agbno, 1, oinfo);
-	xfs_scrub_xref_is_not_shared(sc, agbno, 1);
+	xchk_xref_is_used_space(sc, agbno, 1);
+	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
+	xchk_xref_is_owned_by(sc, agbno, 1, oinfo);
+	xchk_xref_is_not_shared(sc, agbno, 1);
 }
 
 /* Scrub an AGFL block. */
 STATIC int
-xfs_scrub_agfl_block(
+xchk_agfl_block(
 	struct xfs_mount		*mp,
 	xfs_agblock_t			agbno,
 	void				*priv)
 {
-	struct xfs_scrub_agfl_info	*sai = priv;
+	struct xchk_agfl_info		*sai = priv;
 	struct xfs_scrub_context	*sc = sai->sc;
 	xfs_agnumber_t			agno = sc->sa.agno;
 
@@ -636,9 +636,9 @@ xfs_scrub_agfl_block(
 	    sai->nr_entries < sai->sz_entries)
 		sai->entries[sai->nr_entries++] = agbno;
 	else
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agfl_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agfl_bp);
 
-	xfs_scrub_agfl_block_xref(sc, agbno, priv);
+	xchk_agfl_block_xref(sc, agbno, priv);
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return XFS_BTREE_QUERY_RANGE_ABORT;
@@ -647,7 +647,7 @@ xfs_scrub_agfl_block(
 }
 
 static int
-xfs_scrub_agblock_cmp(
+xchk_agblock_cmp(
 	const void		*pa,
 	const void		*pb)
 {
@@ -659,7 +659,7 @@ xfs_scrub_agblock_cmp(
 
 /* Cross-reference with the other btrees. */
 STATIC void
-xfs_scrub_agfl_xref(
+xchk_agfl_xref(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_owner_info		oinfo;
@@ -672,15 +672,15 @@ xfs_scrub_agfl_xref(
 
 	agbno = XFS_AGFL_BLOCK(mp);
 
-	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
+	error = xchk_ag_btcur_init(sc, &sc->sa);
 	if (error)
 		return;
 
-	xfs_scrub_xref_is_used_space(sc, agbno, 1);
-	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
+	xchk_xref_is_used_space(sc, agbno, 1);
+	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
-	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
-	xfs_scrub_xref_is_not_shared(sc, agbno, 1);
+	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xchk_xref_is_not_shared(sc, agbno, 1);
 
 	/*
 	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
@@ -690,10 +690,10 @@ xfs_scrub_agfl_xref(
 
 /* Scrub the AGFL. */
 int
-xfs_scrub_agfl(
+xchk_agfl(
 	struct xfs_scrub_context	*sc)
 {
-	struct xfs_scrub_agfl_info	sai;
+	struct xchk_agfl_info		sai;
 	struct xfs_agf			*agf;
 	xfs_agnumber_t			agno;
 	unsigned int			agflcount;
@@ -701,15 +701,15 @@ xfs_scrub_agfl(
 	int				error;
 
 	agno = sc->sa.agno = sc->sm->sm_agno;
-	error = xfs_scrub_ag_read_headers(sc, agno, &sc->sa.agi_bp,
+	error = xchk_ag_read_headers(sc, agno, &sc->sa.agi_bp,
 			&sc->sa.agf_bp, &sc->sa.agfl_bp);
-	if (!xfs_scrub_process_error(sc, agno, XFS_AGFL_BLOCK(sc->mp), &error))
+	if (!xchk_process_error(sc, agno, XFS_AGFL_BLOCK(sc->mp), &error))
 		goto out;
 	if (!sc->sa.agf_bp)
 		return -EFSCORRUPTED;
-	xfs_scrub_buffer_recheck(sc, sc->sa.agfl_bp);
+	xchk_buffer_recheck(sc, sc->sa.agfl_bp);
 
-	xfs_scrub_agfl_xref(sc);
+	xchk_agfl_xref(sc);
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
@@ -718,7 +718,7 @@ xfs_scrub_agfl(
 	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
 	agflcount = be32_to_cpu(agf->agf_flcount);
 	if (agflcount > xfs_agfl_size(sc->mp)) {
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 		goto out;
 	}
 	memset(&sai, 0, sizeof(sai));
@@ -734,7 +734,7 @@ xfs_scrub_agfl(
 	/* Check the blocks in the AGFL. */
 	xfs_rmap_ag_owner(&sai.oinfo, XFS_RMAP_OWN_AG);
 	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
-			sc->sa.agfl_bp, xfs_scrub_agfl_block, &sai);
+			sc->sa.agfl_bp, xchk_agfl_block, &sai);
 	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
 		error = 0;
 		goto out_free;
@@ -743,16 +743,16 @@ xfs_scrub_agfl(
 		goto out_free;
 
 	if (agflcount != sai.nr_entries) {
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 		goto out_free;
 	}
 
 	/* Sort entries, check for duplicates. */
 	sort(sai.entries, sai.nr_entries, sizeof(sai.entries[0]),
-			xfs_scrub_agblock_cmp, NULL);
+			xchk_agblock_cmp, NULL);
 	for (i = 1; i < sai.nr_entries; i++) {
 		if (sai.entries[i] == sai.entries[i - 1]) {
-			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
+			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 			break;
 		}
 	}
@@ -767,7 +767,7 @@ xfs_scrub_agfl(
 
 /* Check agi_count/agi_freecount */
 static inline void
-xfs_scrub_agi_xref_icounts(
+xchk_agi_xref_icounts(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_agi			*agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
@@ -779,16 +779,16 @@ xfs_scrub_agi_xref_icounts(
 		return;
 
 	error = xfs_ialloc_count_inodes(sc->sa.ino_cur, &icount, &freecount);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.ino_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.ino_cur))
 		return;
 	if (be32_to_cpu(agi->agi_count) != icount ||
 	    be32_to_cpu(agi->agi_freecount) != freecount)
-		xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agi_bp);
+		xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
 }
 
 /* Cross-reference with the other btrees. */
 STATIC void
-xfs_scrub_agi_xref(
+xchk_agi_xref(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_owner_info		oinfo;
@@ -801,23 +801,23 @@ xfs_scrub_agi_xref(
 
 	agbno = XFS_AGI_BLOCK(mp);
 
-	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
+	error = xchk_ag_btcur_init(sc, &sc->sa);
 	if (error)
 		return;
 
-	xfs_scrub_xref_is_used_space(sc, agbno, 1);
-	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, 1);
-	xfs_scrub_agi_xref_icounts(sc);
+	xchk_xref_is_used_space(sc, agbno, 1);
+	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
+	xchk_agi_xref_icounts(sc);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
-	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
-	xfs_scrub_xref_is_not_shared(sc, agbno, 1);
+	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xchk_xref_is_not_shared(sc, agbno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
 
 /* Scrub the AGI. */
 int
-xfs_scrub_agi(
+xchk_agi(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_mount		*mp = sc->mp;
@@ -834,36 +834,36 @@ xfs_scrub_agi(
 	int				error = 0;
 
 	agno = sc->sa.agno = sc->sm->sm_agno;
-	error = xfs_scrub_ag_read_headers(sc, agno, &sc->sa.agi_bp,
+	error = xchk_ag_read_headers(sc, agno, &sc->sa.agi_bp,
 			&sc->sa.agf_bp, &sc->sa.agfl_bp);
-	if (!xfs_scrub_process_error(sc, agno, XFS_AGI_BLOCK(sc->mp), &error))
+	if (!xchk_process_error(sc, agno, XFS_AGI_BLOCK(sc->mp), &error))
 		goto out;
-	xfs_scrub_buffer_recheck(sc, sc->sa.agi_bp);
+	xchk_buffer_recheck(sc, sc->sa.agi_bp);
 
 	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
 
 	/* Check the AG length */
 	eoag = be32_to_cpu(agi->agi_length);
 	if (eoag != xfs_ag_block_count(mp, agno))
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	/* Check btree roots and levels */
 	agbno = be32_to_cpu(agi->agi_root);
 	if (!xfs_verify_agbno(mp, agno, agbno))
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	level = be32_to_cpu(agi->agi_level);
 	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
 		agbno = be32_to_cpu(agi->agi_free_root);
 		if (!xfs_verify_agbno(mp, agno, agbno))
-			xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 		level = be32_to_cpu(agi->agi_free_level);
 		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
-			xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 	}
 
 	/* Check inode counters */
@@ -871,16 +871,16 @@ xfs_scrub_agi(
 	icount = be32_to_cpu(agi->agi_count);
 	if (icount > last_agino - first_agino + 1 ||
 	    icount < be32_to_cpu(agi->agi_freecount))
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	/* Check inode pointers */
 	agino = be32_to_cpu(agi->agi_newino);
 	if (agino != NULLAGINO && !xfs_verify_agino(mp, agno, agino))
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	agino = be32_to_cpu(agi->agi_dirino);
 	if (agino != NULLAGINO && !xfs_verify_agino(mp, agno, agino))
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	/* Check unlinked inode buckets */
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
@@ -888,13 +888,13 @@ xfs_scrub_agi(
 		if (agino == NULLAGINO)
 			continue;
 		if (!xfs_verify_agino(mp, agno, agino))
-			xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 	}
 
 	if (agi->agi_pad32 != cpu_to_be32(0))
-		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
+		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
-	xfs_scrub_agi_xref(sc);
+	xchk_agi_xref(sc);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 50e4f7fa06f0..1f6e3a6a1fdd 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -28,11 +28,11 @@
  * Set us up to scrub free space btrees.
  */
 int
-xfs_scrub_setup_ag_allocbt(
+xchk_setup_ag_allocbt(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	return xfs_scrub_setup_ag_btree(sc, ip, false);
+	return xchk_setup_ag_btree(sc, ip, false);
 }
 
 /* Free space btree scrubber. */
@@ -41,7 +41,7 @@ xfs_scrub_setup_ag_allocbt(
  * bnobt/cntbt record, respectively.
  */
 STATIC void
-xfs_scrub_allocbt_xref_other(
+xchk_allocbt_xref_other(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
@@ -56,32 +56,32 @@ xfs_scrub_allocbt_xref_other(
 		pcur = &sc->sa.cnt_cur;
 	else
 		pcur = &sc->sa.bno_cur;
-	if (!*pcur || xfs_scrub_skip_xref(sc->sm))
+	if (!*pcur || xchk_skip_xref(sc->sm))
 		return;
 
 	error = xfs_alloc_lookup_le(*pcur, agbno, len, &has_otherrec);
-	if (!xfs_scrub_should_check_xref(sc, &error, pcur))
+	if (!xchk_should_check_xref(sc, &error, pcur))
 		return;
 	if (!has_otherrec) {
-		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+		xchk_btree_xref_set_corrupt(sc, *pcur, 0);
 		return;
 	}
 
 	error = xfs_alloc_get_rec(*pcur, &fbno, &flen, &has_otherrec);
-	if (!xfs_scrub_should_check_xref(sc, &error, pcur))
+	if (!xchk_should_check_xref(sc, &error, pcur))
 		return;
 	if (!has_otherrec) {
-		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+		xchk_btree_xref_set_corrupt(sc, *pcur, 0);
 		return;
 	}
 
 	if (fbno != agbno || flen != len)
-		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+		xchk_btree_xref_set_corrupt(sc, *pcur, 0);
 }
 
 /* Cross-reference with the other btrees. */
 STATIC void
-xfs_scrub_allocbt_xref(
+xchk_allocbt_xref(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
@@ -89,16 +89,16 @@ xfs_scrub_allocbt_xref(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
-	xfs_scrub_allocbt_xref_other(sc, agbno, len);
-	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, len);
-	xfs_scrub_xref_has_no_owner(sc, agbno, len);
-	xfs_scrub_xref_is_not_shared(sc, agbno, len);
+	xchk_allocbt_xref_other(sc, agbno, len);
+	xchk_xref_is_not_inode_chunk(sc, agbno, len);
+	xchk_xref_has_no_owner(sc, agbno, len);
+	xchk_xref_is_not_shared(sc, agbno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
 STATIC int
-xfs_scrub_allocbt_rec(
-	struct xfs_scrub_btree		*bs,
+xchk_allocbt_rec(
+	struct xchk_btree		*bs,
 	union xfs_btree_rec		*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
@@ -113,16 +113,16 @@ xfs_scrub_allocbt_rec(
 	if (bno + len <= bno ||
 	    !xfs_verify_agbno(mp, agno, bno) ||
 	    !xfs_verify_agbno(mp, agno, bno + len - 1))
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
-	xfs_scrub_allocbt_xref(bs->sc, bno, len);
+	xchk_allocbt_xref(bs->sc, bno, len);
 
 	return error;
 }
 
 /* Scrub the freespace btrees for some AG. */
 STATIC int
-xfs_scrub_allocbt(
+xchk_allocbt(
 	struct xfs_scrub_context	*sc,
 	xfs_btnum_t			which)
 {
@@ -131,26 +131,26 @@ xfs_scrub_allocbt(
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
 	cur = which == XFS_BTNUM_BNO ? sc->sa.bno_cur : sc->sa.cnt_cur;
-	return xfs_scrub_btree(sc, cur, xfs_scrub_allocbt_rec, &oinfo, NULL);
+	return xchk_btree(sc, cur, xchk_allocbt_rec, &oinfo, NULL);
 }
 
 int
-xfs_scrub_bnobt(
+xchk_bnobt(
 	struct xfs_scrub_context	*sc)
 {
-	return xfs_scrub_allocbt(sc, XFS_BTNUM_BNO);
+	return xchk_allocbt(sc, XFS_BTNUM_BNO);
 }
 
 int
-xfs_scrub_cntbt(
+xchk_cntbt(
 	struct xfs_scrub_context	*sc)
 {
-	return xfs_scrub_allocbt(sc, XFS_BTNUM_CNT);
+	return xchk_allocbt(sc, XFS_BTNUM_CNT);
 }
 
 /* xref check that the extent is not free */
 void
-xfs_scrub_xref_is_used_space(
+xchk_xref_is_used_space(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
@@ -158,12 +158,12 @@ xfs_scrub_xref_is_used_space(
 	bool				is_freesp;
 	int				error;
 
-	if (!sc->sa.bno_cur || xfs_scrub_skip_xref(sc->sm))
+	if (!sc->sa.bno_cur || xchk_skip_xref(sc->sm))
 		return;
 
 	error = xfs_alloc_has_record(sc->sa.bno_cur, agbno, len, &is_freesp);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.bno_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.bno_cur))
 		return;
 	if (is_freesp)
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.bno_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.bno_cur, 0);
 }
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index de51cf8a8516..0068bebddf3e 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -32,7 +32,7 @@
 
 /* Set us up to scrub an inode's extended attributes. */
 int
-xfs_scrub_setup_xattr(
+xchk_setup_xattr(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
@@ -50,12 +50,12 @@ xfs_scrub_setup_xattr(
 	if (!sc->buf)
 		return -ENOMEM;
 
-	return xfs_scrub_setup_inode_contents(sc, ip, 0);
+	return xchk_setup_inode_contents(sc, ip, 0);
 }
 
 /* Extended Attributes */
 
-struct xfs_scrub_xattr {
+struct xchk_xattr {
 	struct xfs_attr_list_context	context;
 	struct xfs_scrub_context	*sc;
 };
@@ -69,22 +69,22 @@ struct xfs_scrub_xattr {
  * or if we get more or less data than we expected.
  */
 static void
-xfs_scrub_xattr_listent(
+xchk_xattr_listent(
 	struct xfs_attr_list_context	*context,
 	int				flags,
 	unsigned char			*name,
 	int				namelen,
 	int				valuelen)
 {
-	struct xfs_scrub_xattr		*sx;
+	struct xchk_xattr		*sx;
 	struct xfs_da_args		args = { NULL };
 	int				error = 0;
 
-	sx = container_of(context, struct xfs_scrub_xattr, context);
+	sx = container_of(context, struct xchk_xattr, context);
 
 	if (flags & XFS_ATTR_INCOMPLETE) {
 		/* Incomplete attr key, just mark the inode for preening. */
-		xfs_scrub_ino_set_preen(sx->sc, context->dp->i_ino);
+		xchk_ino_set_preen(sx->sc, context->dp->i_ino);
 		return;
 	}
 
@@ -106,11 +106,11 @@ xfs_scrub_xattr_listent(
 	error = xfs_attr_get_ilocked(context->dp, &args);
 	if (error == -EEXIST)
 		error = 0;
-	if (!xfs_scrub_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
+	if (!xchk_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
 			&error))
 		goto fail_xref;
 	if (args.valuelen != valuelen)
-		xfs_scrub_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK,
+		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK,
 					     args.blkno);
 fail_xref:
 	if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
@@ -126,7 +126,7 @@ xfs_scrub_xattr_listent(
  * the smallest address
  */
 STATIC bool
-xfs_scrub_xattr_set_map(
+xchk_xattr_set_map(
 	struct xfs_scrub_context	*sc,
 	unsigned long			*map,
 	unsigned int			start,
@@ -154,7 +154,7 @@ xfs_scrub_xattr_set_map(
  * attr freemap has problems or points to used space.
  */
 STATIC bool
-xfs_scrub_xattr_check_freemap(
+xchk_xattr_check_freemap(
 	struct xfs_scrub_context	*sc,
 	unsigned long			*map,
 	struct xfs_attr3_icleaf_hdr	*leafhdr)
@@ -168,7 +168,7 @@ xfs_scrub_xattr_check_freemap(
 	freemap = (unsigned long *)sc->buf + BITS_TO_LONGS(mapsize);
 	bitmap_zero(freemap, mapsize);
 	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
-		if (!xfs_scrub_xattr_set_map(sc, freemap,
+		if (!xchk_xattr_set_map(sc, freemap,
 				leafhdr->freemap[i].base,
 				leafhdr->freemap[i].size))
 			return false;
@@ -184,8 +184,8 @@ xfs_scrub_xattr_check_freemap(
  * Returns the number of bytes used for the name/value data.
  */
 STATIC void
-xfs_scrub_xattr_entry(
-	struct xfs_scrub_da_btree	*ds,
+xchk_xattr_entry(
+	struct xchk_da_btree		*ds,
 	int				level,
 	char				*buf_end,
 	struct xfs_attr_leafblock	*leaf,
@@ -204,17 +204,17 @@ xfs_scrub_xattr_entry(
 	unsigned int			namesize;
 
 	if (ent->pad2 != 0)
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 
 	/* Hash values in order? */
 	if (be32_to_cpu(ent->hashval) < *last_hashval)
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 	*last_hashval = be32_to_cpu(ent->hashval);
 
 	nameidx = be16_to_cpu(ent->nameidx);
 	if (nameidx < leafhdr->firstused ||
 	    nameidx >= mp->m_attr_geo->blksize) {
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 		return;
 	}
 
@@ -225,27 +225,27 @@ xfs_scrub_xattr_entry(
 				be16_to_cpu(lentry->valuelen));
 		name_end = (char *)lentry + namesize;
 		if (lentry->namelen == 0)
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 	} else {
 		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
 		if (rentry->namelen == 0 || rentry->valueblk == 0)
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 	}
 	if (name_end > buf_end)
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 
-	if (!xfs_scrub_xattr_set_map(ds->sc, usedmap, nameidx, namesize))
-		xfs_scrub_da_set_corrupt(ds, level);
+	if (!xchk_xattr_set_map(ds->sc, usedmap, nameidx, namesize))
+		xchk_da_set_corrupt(ds, level);
 	if (!(ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		*usedbytes += namesize;
 }
 
 /* Scrub an attribute leaf. */
 STATIC int
-xfs_scrub_xattr_block(
-	struct xfs_scrub_da_btree	*ds,
+xchk_xattr_block(
+	struct xchk_da_btree		*ds,
 	int				level)
 {
 	struct xfs_attr3_icleaf_hdr	leafhdr;
@@ -275,10 +275,10 @@ xfs_scrub_xattr_block(
 
 		if (leaf->hdr.pad1 != 0 || leaf->hdr.pad2 != 0 ||
 		    leaf->hdr.info.hdr.pad != 0)
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 	} else {
 		if (leaf->hdr.pad1 != 0 || leaf->hdr.info.pad != 0)
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 	}
 
 	/* Check the leaf header */
@@ -286,44 +286,44 @@ xfs_scrub_xattr_block(
 	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
 
 	if (leafhdr.usedbytes > mp->m_attr_geo->blksize)
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 	if (leafhdr.firstused > mp->m_attr_geo->blksize)
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 	if (leafhdr.firstused < hdrsize)
-		xfs_scrub_da_set_corrupt(ds, level);
-	if (!xfs_scrub_xattr_set_map(ds->sc, usedmap, 0, hdrsize))
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
+	if (!xchk_xattr_set_map(ds->sc, usedmap, 0, hdrsize))
+		xchk_da_set_corrupt(ds, level);
 
 	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 
 	entries = xfs_attr3_leaf_entryp(leaf);
 	if ((char *)&entries[leafhdr.count] > (char *)leaf + leafhdr.firstused)
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 
 	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
 	for (i = 0, ent = entries; i < leafhdr.count; ent++, i++) {
 		/* Mark the leaf entry itself. */
 		off = (char *)ent - (char *)leaf;
-		if (!xfs_scrub_xattr_set_map(ds->sc, usedmap, off,
+		if (!xchk_xattr_set_map(ds->sc, usedmap, off,
 				sizeof(xfs_attr_leaf_entry_t))) {
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 			goto out;
 		}
 
 		/* Check the entry and nameval. */
-		xfs_scrub_xattr_entry(ds, level, buf_end, leaf, &leafhdr,
+		xchk_xattr_entry(ds, level, buf_end, leaf, &leafhdr,
 				usedmap, ent, i, &usedbytes, &last_hashval);
 
 		if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 			goto out;
 	}
 
-	if (!xfs_scrub_xattr_check_freemap(ds->sc, usedmap, &leafhdr))
-		xfs_scrub_da_set_corrupt(ds, level);
+	if (!xchk_xattr_check_freemap(ds->sc, usedmap, &leafhdr))
+		xchk_da_set_corrupt(ds, level);
 
 	if (leafhdr.usedbytes != usedbytes)
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 
 out:
 	return 0;
@@ -331,8 +331,8 @@ xfs_scrub_xattr_block(
 
 /* Scrub a attribute btree record. */
 STATIC int
-xfs_scrub_xattr_rec(
-	struct xfs_scrub_da_btree	*ds,
+xchk_xattr_rec(
+	struct xchk_da_btree		*ds,
 	int				level,
 	void				*rec)
 {
@@ -352,14 +352,14 @@ xfs_scrub_xattr_rec(
 	blk = &ds->state->path.blk[level];
 
 	/* Check the whole block, if necessary. */
-	error = xfs_scrub_xattr_block(ds, level);
+	error = xchk_xattr_block(ds, level);
 	if (error)
 		goto out;
 	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 
 	/* Check the hash of the entry. */
-	error = xfs_scrub_da_btree_hash(ds, level, &ent->hashval);
+	error = xchk_da_btree_hash(ds, level, &ent->hashval);
 	if (error)
 		goto out;
 
@@ -368,7 +368,7 @@ xfs_scrub_xattr_rec(
 	hdrsize = xfs_attr3_leaf_hdr_size(bp->b_addr);
 	nameidx = be16_to_cpu(ent->nameidx);
 	if (nameidx < hdrsize || nameidx >= mp->m_attr_geo->blksize) {
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 		goto out;
 	}
 
@@ -377,12 +377,12 @@ xfs_scrub_xattr_rec(
 	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
 			XFS_ATTR_INCOMPLETE);
 	if ((ent->flags & badflags) != 0)
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = (struct xfs_attr_leaf_name_local *)
 				(((char *)bp->b_addr) + nameidx);
 		if (lentry->namelen <= 0) {
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 			goto out;
 		}
 		calc_hash = xfs_da_hashname(lentry->nameval, lentry->namelen);
@@ -390,13 +390,13 @@ xfs_scrub_xattr_rec(
 		rentry = (struct xfs_attr_leaf_name_remote *)
 				(((char *)bp->b_addr) + nameidx);
 		if (rentry->namelen <= 0) {
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 			goto out;
 		}
 		calc_hash = xfs_da_hashname(rentry->name, rentry->namelen);
 	}
 	if (calc_hash != hash)
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 
 out:
 	return error;
@@ -404,10 +404,10 @@ xfs_scrub_xattr_rec(
 
 /* Scrub the extended attribute metadata. */
 int
-xfs_scrub_xattr(
+xchk_xattr(
 	struct xfs_scrub_context	*sc)
 {
-	struct xfs_scrub_xattr		sx;
+	struct xchk_xattr		sx;
 	struct attrlist_cursor_kern	cursor = { 0 };
 	xfs_dablk_t			last_checked = -1U;
 	int				error = 0;
@@ -417,7 +417,7 @@ xfs_scrub_xattr(
 
 	memset(&sx, 0, sizeof(sx));
 	/* Check attribute tree structure */
-	error = xfs_scrub_da_btree(sc, XFS_ATTR_FORK, xfs_scrub_xattr_rec,
+	error = xchk_da_btree(sc, XFS_ATTR_FORK, xchk_xattr_rec,
 			&last_checked);
 	if (error)
 		goto out;
@@ -429,7 +429,7 @@ xfs_scrub_xattr(
 	sx.context.dp = sc->ip;
 	sx.context.cursor = &cursor;
 	sx.context.resynch = 1;
-	sx.context.put_listent = xfs_scrub_xattr_listent;
+	sx.context.put_listent = xchk_xattr_listent;
 	sx.context.tp = sc->tp;
 	sx.context.flags = ATTR_INCOMPLETE;
 	sx.sc = sc;
@@ -438,7 +438,7 @@ xfs_scrub_xattr(
 	 * Look up every xattr in this file by name.
 	 *
 	 * Use the backend implementation of xfs_attr_list to call
-	 * xfs_scrub_xattr_listent on every attribute key in this inode.
+	 * xchk_xattr_listent on every attribute key in this inode.
 	 * In other words, we use the same iterator/callback mechanism
 	 * that listattr uses to scrub extended attributes, though in our
 	 * _listent function, we check the value of the attribute.
@@ -451,7 +451,7 @@ xfs_scrub_xattr(
 	 * locking order.
 	 */
 	error = xfs_attr_list_int_ilocked(&sx.context);
-	if (!xfs_scrub_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
+	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
 		goto out;
 out:
 	return error;
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index ebbfab173e97..19cfbd3910a2 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -33,13 +33,13 @@
 
 /* Set us up with an inode's bmap. */
 int
-xfs_scrub_setup_inode_bmap(
+xchk_setup_inode_bmap(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
 	int				error;
 
-	error = xfs_scrub_get_inode(sc, ip);
+	error = xchk_get_inode(sc, ip);
 	if (error)
 		goto out;
 
@@ -60,7 +60,7 @@ xfs_scrub_setup_inode_bmap(
 	}
 
 	/* Got the inode, lock it and we're ready to go. */
-	error = xfs_scrub_trans_alloc(sc, 0);
+	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
@@ -78,7 +78,7 @@ xfs_scrub_setup_inode_bmap(
  * is in btree format.
  */
 
-struct xfs_scrub_bmap_info {
+struct xchk_bmap_info {
 	struct xfs_scrub_context	*sc;
 	xfs_fileoff_t			lastoff;
 	bool				is_rt;
@@ -88,8 +88,8 @@ struct xfs_scrub_bmap_info {
 
 /* Look for a corresponding rmap for this irec. */
 static inline bool
-xfs_scrub_bmap_get_rmap(
-	struct xfs_scrub_bmap_info	*info,
+xchk_bmap_get_rmap(
+	struct xchk_bmap_info		*info,
 	struct xfs_bmbt_irec		*irec,
 	xfs_agblock_t			agbno,
 	uint64_t			owner,
@@ -120,7 +120,7 @@ xfs_scrub_bmap_get_rmap(
 	if (info->is_shared) {
 		error = xfs_rmap_lookup_le_range(info->sc->sa.rmap_cur, agbno,
 				owner, offset, rflags, rmap, &has_rmap);
-		if (!xfs_scrub_should_check_xref(info->sc, &error,
+		if (!xchk_should_check_xref(info->sc, &error,
 				&info->sc->sa.rmap_cur))
 			return false;
 		goto out;
@@ -131,28 +131,28 @@ xfs_scrub_bmap_get_rmap(
 	 */
 	error = xfs_rmap_lookup_le(info->sc->sa.rmap_cur, agbno, 0, owner,
 			offset, rflags, &has_rmap);
-	if (!xfs_scrub_should_check_xref(info->sc, &error,
+	if (!xchk_should_check_xref(info->sc, &error,
 			&info->sc->sa.rmap_cur))
 		return false;
 	if (!has_rmap)
 		goto out;
 
 	error = xfs_rmap_get_rec(info->sc->sa.rmap_cur, rmap, &has_rmap);
-	if (!xfs_scrub_should_check_xref(info->sc, &error,
+	if (!xchk_should_check_xref(info->sc, &error,
 			&info->sc->sa.rmap_cur))
 		return false;
 
 out:
 	if (!has_rmap)
-		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 			irec->br_startoff);
 	return has_rmap;
 }
 
 /* Make sure that we have rmapbt records for this extent. */
 STATIC void
-xfs_scrub_bmap_xref_rmap(
-	struct xfs_scrub_bmap_info	*info,
+xchk_bmap_xref_rmap(
+	struct xchk_bmap_info		*info,
 	struct xfs_bmbt_irec		*irec,
 	xfs_agblock_t			agbno)
 {
@@ -160,7 +160,7 @@ xfs_scrub_bmap_xref_rmap(
 	unsigned long long		rmap_end;
 	uint64_t			owner;
 
-	if (!info->sc->sa.rmap_cur || xfs_scrub_skip_xref(info->sc->sm))
+	if (!info->sc->sa.rmap_cur || xchk_skip_xref(info->sc->sm))
 		return;
 
 	if (info->whichfork == XFS_COW_FORK)
@@ -169,14 +169,14 @@ xfs_scrub_bmap_xref_rmap(
 		owner = info->sc->ip->i_ino;
 
 	/* Find the rmap record for this irec. */
-	if (!xfs_scrub_bmap_get_rmap(info, irec, agbno, owner, &rmap))
+	if (!xchk_bmap_get_rmap(info, irec, agbno, owner, &rmap))
 		return;
 
 	/* Check the rmap. */
 	rmap_end = (unsigned long long)rmap.rm_startblock + rmap.rm_blockcount;
 	if (rmap.rm_startblock > agbno ||
 	    agbno + irec->br_blockcount > rmap_end)
-		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
 	/*
@@ -189,12 +189,12 @@ xfs_scrub_bmap_xref_rmap(
 				rmap.rm_blockcount;
 		if (rmap.rm_offset > irec->br_startoff ||
 		    irec->br_startoff + irec->br_blockcount > rmap_end)
-			xfs_scrub_fblock_xref_set_corrupt(info->sc,
+			xchk_fblock_xref_set_corrupt(info->sc,
 					info->whichfork, irec->br_startoff);
 	}
 
 	if (rmap.rm_owner != owner)
-		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
 	/*
@@ -207,22 +207,22 @@ xfs_scrub_bmap_xref_rmap(
 	if (owner != XFS_RMAP_OWN_COW &&
 	    irec->br_state == XFS_EXT_UNWRITTEN &&
 	    !(rmap.rm_flags & XFS_RMAP_UNWRITTEN))
-		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
 	if (info->whichfork == XFS_ATTR_FORK &&
 	    !(rmap.rm_flags & XFS_RMAP_ATTR_FORK))
-		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (rmap.rm_flags & XFS_RMAP_BMBT_BLOCK)
-		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 }
 
 /* Cross-reference a single rtdev extent record. */
 STATIC void
-xfs_scrub_bmap_rt_extent_xref(
-	struct xfs_scrub_bmap_info	*info,
+xchk_bmap_rt_extent_xref(
+	struct xchk_bmap_info		*info,
 	struct xfs_inode		*ip,
 	struct xfs_btree_cur		*cur,
 	struct xfs_bmbt_irec		*irec)
@@ -230,14 +230,14 @@ xfs_scrub_bmap_rt_extent_xref(
 	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
-	xfs_scrub_xref_is_used_rt_space(info->sc, irec->br_startblock,
+	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
 			irec->br_blockcount);
 }
 
 /* Cross-reference a single datadev extent record. */
 STATIC void
-xfs_scrub_bmap_extent_xref(
-	struct xfs_scrub_bmap_info	*info,
+xchk_bmap_extent_xref(
+	struct xchk_bmap_info		*info,
 	struct xfs_inode		*ip,
 	struct xfs_btree_cur		*cur,
 	struct xfs_bmbt_irec		*irec)
@@ -255,38 +255,38 @@ xfs_scrub_bmap_extent_xref(
 	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
 	len = irec->br_blockcount;
 
-	error = xfs_scrub_ag_init(info->sc, agno, &info->sc->sa);
-	if (!xfs_scrub_fblock_process_error(info->sc, info->whichfork,
+	error = xchk_ag_init(info->sc, agno, &info->sc->sa);
+	if (!xchk_fblock_process_error(info->sc, info->whichfork,
 			irec->br_startoff, &error))
 		return;
 
-	xfs_scrub_xref_is_used_space(info->sc, agbno, len);
-	xfs_scrub_xref_is_not_inode_chunk(info->sc, agbno, len);
-	xfs_scrub_bmap_xref_rmap(info, irec, agbno);
+	xchk_xref_is_used_space(info->sc, agbno, len);
+	xchk_xref_is_not_inode_chunk(info->sc, agbno, len);
+	xchk_bmap_xref_rmap(info, irec, agbno);
 	switch (info->whichfork) {
 	case XFS_DATA_FORK:
 		if (xfs_is_reflink_inode(info->sc->ip))
 			break;
 		/* fall through */
 	case XFS_ATTR_FORK:
-		xfs_scrub_xref_is_not_shared(info->sc, agbno,
+		xchk_xref_is_not_shared(info->sc, agbno,
 				irec->br_blockcount);
 		break;
 	case XFS_COW_FORK:
-		xfs_scrub_xref_is_cow_staging(info->sc, agbno,
+		xchk_xref_is_cow_staging(info->sc, agbno,
 				irec->br_blockcount);
 		break;
 	}
 
-	xfs_scrub_ag_free(info->sc, &info->sc->sa);
+	xchk_ag_free(info->sc, &info->sc->sa);
 }
 
 /* Scrub a single extent record. */
 STATIC int
-xfs_scrub_bmap_extent(
+xchk_bmap_extent(
 	struct xfs_inode		*ip,
 	struct xfs_btree_cur		*cur,
-	struct xfs_scrub_bmap_info	*info,
+	struct xchk_bmap_info		*info,
 	struct xfs_bmbt_irec		*irec)
 {
 	struct xfs_mount		*mp = info->sc->mp;
@@ -302,12 +302,12 @@ xfs_scrub_bmap_extent(
 	 * from the incore list, for which there is no ordering check.
 	 */
 	if (irec->br_startoff < info->lastoff)
-		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
 	/* There should never be a "hole" extent in either extent list. */
 	if (irec->br_startblock == HOLESTARTBLOCK)
-		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
 	/*
@@ -315,40 +315,40 @@ xfs_scrub_bmap_extent(
 	 * in-core extent scan, and we should never see these in the bmbt.
 	 */
 	if (isnullstartblock(irec->br_startblock))
-		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
 	/* Make sure the extent points to a valid place. */
 	if (irec->br_blockcount > MAXEXTLEN)
-		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (irec->br_startblock + irec->br_blockcount <= irec->br_startblock)
-		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	end = irec->br_startblock + irec->br_blockcount - 1;
 	if (info->is_rt &&
 	    (!xfs_verify_rtbno(mp, irec->br_startblock) ||
 	     !xfs_verify_rtbno(mp, end)))
-		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (!info->is_rt &&
 	    (!xfs_verify_fsbno(mp, irec->br_startblock) ||
 	     !xfs_verify_fsbno(mp, end) ||
 	     XFS_FSB_TO_AGNO(mp, irec->br_startblock) !=
 				XFS_FSB_TO_AGNO(mp, end)))
-		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
 	/* We don't allow unwritten extents on attr forks. */
 	if (irec->br_state == XFS_EXT_UNWRITTEN &&
 	    info->whichfork == XFS_ATTR_FORK)
-		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
 	if (info->is_rt)
-		xfs_scrub_bmap_rt_extent_xref(info, ip, cur, irec);
+		xchk_bmap_rt_extent_xref(info, ip, cur, irec);
 	else
-		xfs_scrub_bmap_extent_xref(info, ip, cur, irec);
+		xchk_bmap_extent_xref(info, ip, cur, irec);
 
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
 	return error;
@@ -356,12 +356,12 @@ xfs_scrub_bmap_extent(
 
 /* Scrub a bmbt record. */
 STATIC int
-xfs_scrub_bmapbt_rec(
-	struct xfs_scrub_btree		*bs,
+xchk_bmapbt_rec(
+	struct xchk_btree		*bs,
 	union xfs_btree_rec		*rec)
 {
 	struct xfs_bmbt_irec		irec;
-	struct xfs_scrub_bmap_info	*info = bs->private;
+	struct xchk_bmap_info		*info = bs->private;
 	struct xfs_inode		*ip = bs->cur->bc_private.b.ip;
 	struct xfs_buf			*bp = NULL;
 	struct xfs_btree_block		*block;
@@ -378,22 +378,22 @@ xfs_scrub_bmapbt_rec(
 			block = xfs_btree_get_block(bs->cur, i, &bp);
 			owner = be64_to_cpu(block->bb_u.l.bb_owner);
 			if (owner != ip->i_ino)
-				xfs_scrub_fblock_set_corrupt(bs->sc,
+				xchk_fblock_set_corrupt(bs->sc,
 						info->whichfork, 0);
 		}
 	}
 
 	/* Set up the in-core record and scrub it. */
 	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
-	return xfs_scrub_bmap_extent(ip, bs->cur, info, &irec);
+	return xchk_bmap_extent(ip, bs->cur, info, &irec);
 }
 
 /* Scan the btree records. */
 STATIC int
-xfs_scrub_bmap_btree(
+xchk_bmap_btree(
 	struct xfs_scrub_context	*sc,
 	int				whichfork,
-	struct xfs_scrub_bmap_info	*info)
+	struct xchk_bmap_info		*info)
 {
 	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
@@ -403,12 +403,12 @@ xfs_scrub_bmap_btree(
 
 	cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
-	error = xfs_scrub_btree(sc, cur, xfs_scrub_bmapbt_rec, &oinfo, info);
+	error = xchk_btree(sc, cur, xchk_bmapbt_rec, &oinfo, info);
 	xfs_btree_del_cursor(cur, error);
 	return error;
 }
 
-struct xfs_scrub_bmap_check_rmap_info {
+struct xchk_bmap_check_rmap_info {
 	struct xfs_scrub_context	*sc;
 	int				whichfork;
 	struct xfs_iext_cursor		icur;
@@ -416,13 +416,13 @@ struct xfs_scrub_bmap_check_rmap_info {
 
 /* Can we find bmaps that fit this rmap? */
 STATIC int
-xfs_scrub_bmap_check_rmap(
+xchk_bmap_check_rmap(
 	struct xfs_btree_cur		*cur,
 	struct xfs_rmap_irec		*rec,
 	void				*priv)
 {
 	struct xfs_bmbt_irec		irec;
-	struct xfs_scrub_bmap_check_rmap_info	*sbcri = priv;
+	struct xchk_bmap_check_rmap_info	*sbcri = priv;
 	struct xfs_ifork		*ifp;
 	struct xfs_scrub_context	*sc = sbcri->sc;
 	bool				have_map;
@@ -439,14 +439,14 @@ xfs_scrub_bmap_check_rmap(
 	/* Now look up the bmbt record. */
 	ifp = XFS_IFORK_PTR(sc->ip, sbcri->whichfork);
 	if (!ifp) {
-		xfs_scrub_fblock_set_corrupt(sc, sbcri->whichfork,
+		xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 				rec->rm_offset);
 		goto out;
 	}
 	have_map = xfs_iext_lookup_extent(sc->ip, ifp, rec->rm_offset,
 			&sbcri->icur, &irec);
 	if (!have_map)
-		xfs_scrub_fblock_set_corrupt(sc, sbcri->whichfork,
+		xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 				rec->rm_offset);
 	/*
 	 * bmap extent record lengths are constrained to 2^21 blocks in length
@@ -457,14 +457,14 @@ xfs_scrub_bmap_check_rmap(
 	 */
 	while (have_map) {
 		if (irec.br_startoff != rec->rm_offset)
-			xfs_scrub_fblock_set_corrupt(sc, sbcri->whichfork,
+			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					rec->rm_offset);
 		if (irec.br_startblock != XFS_AGB_TO_FSB(sc->mp,
 				cur->bc_private.a.agno, rec->rm_startblock))
-			xfs_scrub_fblock_set_corrupt(sc, sbcri->whichfork,
+			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					rec->rm_offset);
 		if (irec.br_blockcount > rec->rm_blockcount)
-			xfs_scrub_fblock_set_corrupt(sc, sbcri->whichfork,
+			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					rec->rm_offset);
 		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 			break;
@@ -475,7 +475,7 @@ xfs_scrub_bmap_check_rmap(
 			break;
 		have_map = xfs_iext_next_extent(ifp, &sbcri->icur, &irec);
 		if (!have_map)
-			xfs_scrub_fblock_set_corrupt(sc, sbcri->whichfork,
+			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					rec->rm_offset);
 	}
 
@@ -487,12 +487,12 @@ xfs_scrub_bmap_check_rmap(
 
 /* Make sure each rmap has a corresponding bmbt entry. */
 STATIC int
-xfs_scrub_bmap_check_ag_rmaps(
+xchk_bmap_check_ag_rmaps(
 	struct xfs_scrub_context	*sc,
 	int				whichfork,
 	xfs_agnumber_t			agno)
 {
-	struct xfs_scrub_bmap_check_rmap_info	sbcri;
+	struct xchk_bmap_check_rmap_info	sbcri;
 	struct xfs_btree_cur		*cur;
 	struct xfs_buf			*agf;
 	int				error;
@@ -509,7 +509,7 @@ xfs_scrub_bmap_check_ag_rmaps(
 
 	sbcri.sc = sc;
 	sbcri.whichfork = whichfork;
-	error = xfs_rmap_query_all(cur, xfs_scrub_bmap_check_rmap, &sbcri);
+	error = xfs_rmap_query_all(cur, xchk_bmap_check_rmap, &sbcri);
 	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
 		error = 0;
 
@@ -521,7 +521,7 @@ xfs_scrub_bmap_check_ag_rmaps(
 
 /* Make sure each rmap has a corresponding bmbt entry. */
 STATIC int
-xfs_scrub_bmap_check_rmaps(
+xchk_bmap_check_rmaps(
 	struct xfs_scrub_context	*sc,
 	int				whichfork)
 {
@@ -561,7 +561,7 @@ xfs_scrub_bmap_check_rmaps(
 		return 0;
 
 	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
-		error = xfs_scrub_bmap_check_ag_rmaps(sc, whichfork, agno);
+		error = xchk_bmap_check_ag_rmaps(sc, whichfork, agno);
 		if (error)
 			return error;
 		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
@@ -578,12 +578,12 @@ xfs_scrub_bmap_check_rmaps(
  * Then we unconditionally scan the incore extent cache.
  */
 STATIC int
-xfs_scrub_bmap(
+xchk_bmap(
 	struct xfs_scrub_context	*sc,
 	int				whichfork)
 {
 	struct xfs_bmbt_irec		irec;
-	struct xfs_scrub_bmap_info	info = { NULL };
+	struct xchk_bmap_info		info = { NULL };
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_inode		*ip = sc->ip;
 	struct xfs_ifork		*ifp;
@@ -605,7 +605,7 @@ xfs_scrub_bmap(
 			goto out;
 		/* No CoW forks on non-reflink inodes/filesystems. */
 		if (!xfs_is_reflink_inode(ip)) {
-			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 			goto out;
 		}
 		break;
@@ -614,7 +614,7 @@ xfs_scrub_bmap(
 			goto out_check_rmap;
 		if (!xfs_sb_version_hasattr(&mp->m_sb) &&
 		    !xfs_sb_version_hasattr2(&mp->m_sb))
-			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		break;
 	default:
 		ASSERT(whichfork == XFS_DATA_FORK);
@@ -630,22 +630,22 @@ xfs_scrub_bmap(
 		goto out;
 	case XFS_DINODE_FMT_EXTENTS:
 		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-			xfs_scrub_fblock_set_corrupt(sc, whichfork, 0);
+			xchk_fblock_set_corrupt(sc, whichfork, 0);
 			goto out;
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (whichfork == XFS_COW_FORK) {
-			xfs_scrub_fblock_set_corrupt(sc, whichfork, 0);
+			xchk_fblock_set_corrupt(sc, whichfork, 0);
 			goto out;
 		}
 
-		error = xfs_scrub_bmap_btree(sc, whichfork, &info);
+		error = xchk_bmap_btree(sc, whichfork, &info);
 		if (error)
 			goto out;
 		break;
 	default:
-		xfs_scrub_fblock_set_corrupt(sc, whichfork, 0);
+		xchk_fblock_set_corrupt(sc, whichfork, 0);
 		goto out;
 	}
 
@@ -655,37 +655,37 @@ xfs_scrub_bmap(
 	/* Now try to scrub the in-memory extent list. */
         if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(sc->tp, ip, whichfork);
-		if (!xfs_scrub_fblock_process_error(sc, whichfork, 0, &error))
+		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
 			goto out;
 	}
 
 	/* Find the offset of the last extent in the mapping. */
 	error = xfs_bmap_last_offset(ip, &endoff, whichfork);
-	if (!xfs_scrub_fblock_process_error(sc, whichfork, 0, &error))
+	if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
 		goto out;
 
 	/* Scrub extent records. */
 	info.lastoff = 0;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	for_each_xfs_iext(ifp, &icur, &irec) {
-		if (xfs_scrub_should_terminate(sc, &error) ||
+		if (xchk_should_terminate(sc, &error) ||
 		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 			break;
 		if (isnullstartblock(irec.br_startblock))
 			continue;
 		if (irec.br_startoff >= endoff) {
-			xfs_scrub_fblock_set_corrupt(sc, whichfork,
+			xchk_fblock_set_corrupt(sc, whichfork,
 					irec.br_startoff);
 			goto out;
 		}
-		error = xfs_scrub_bmap_extent(ip, NULL, &info, &irec);
+		error = xchk_bmap_extent(ip, NULL, &info, &irec);
 		if (error)
 			goto out;
 	}
 
 out_check_rmap:
-	error = xfs_scrub_bmap_check_rmaps(sc, whichfork);
-	if (!xfs_scrub_fblock_xref_process_error(sc, whichfork, 0, &error))
+	error = xchk_bmap_check_rmaps(sc, whichfork);
+	if (!xchk_fblock_xref_process_error(sc, whichfork, 0, &error))
 		goto out;
 out:
 	return error;
@@ -693,27 +693,27 @@ xfs_scrub_bmap(
 
 /* Scrub an inode's data fork. */
 int
-xfs_scrub_bmap_data(
+xchk_bmap_data(
 	struct xfs_scrub_context	*sc)
 {
-	return xfs_scrub_bmap(sc, XFS_DATA_FORK);
+	return xchk_bmap(sc, XFS_DATA_FORK);
 }
 
 /* Scrub an inode's attr fork. */
 int
-xfs_scrub_bmap_attr(
+xchk_bmap_attr(
 	struct xfs_scrub_context	*sc)
 {
-	return xfs_scrub_bmap(sc, XFS_ATTR_FORK);
+	return xchk_bmap(sc, XFS_ATTR_FORK);
 }
 
 /* Scrub an inode's CoW fork. */
 int
-xfs_scrub_bmap_cow(
+xchk_bmap_cow(
 	struct xfs_scrub_context	*sc)
 {
 	if (!xfs_is_reflink_inode(sc->ip))
 		return -ENOENT;
 
-	return xfs_scrub_bmap(sc, XFS_COW_FORK);
+	return xchk_bmap(sc, XFS_COW_FORK);
 }
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 5b472045f036..30fe9a147959 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -29,7 +29,7 @@
  * operational errors in common.c.
  */
 static bool
-__xfs_scrub_btree_process_error(
+__xchk_btree_process_error(
 	struct xfs_scrub_context	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level,
@@ -43,7 +43,7 @@ __xfs_scrub_btree_process_error(
 	switch (*error) {
 	case -EDEADLOCK:
 		/* Used to restart an op with deadlock avoidance. */
-		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
+		trace_xchk_deadlock_retry(sc->ip, sc->sm, *error);
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
@@ -53,10 +53,10 @@ __xfs_scrub_btree_process_error(
 		/* fall through */
 	default:
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
-			trace_xfs_scrub_ifork_btree_op_error(sc, cur, level,
+			trace_xchk_ifork_btree_op_error(sc, cur, level,
 					*error, ret_ip);
 		else
-			trace_xfs_scrub_btree_op_error(sc, cur, level,
+			trace_xchk_btree_op_error(sc, cur, level,
 					*error, ret_ip);
 		break;
 	}
@@ -64,30 +64,30 @@ __xfs_scrub_btree_process_error(
 }
 
 bool
-xfs_scrub_btree_process_error(
+xchk_btree_process_error(
 	struct xfs_scrub_context	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level,
 	int				*error)
 {
-	return __xfs_scrub_btree_process_error(sc, cur, level, error,
+	return __xchk_btree_process_error(sc, cur, level, error,
 			XFS_SCRUB_OFLAG_CORRUPT, __return_address);
 }
 
 bool
-xfs_scrub_btree_xref_process_error(
+xchk_btree_xref_process_error(
 	struct xfs_scrub_context	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level,
 	int				*error)
 {
-	return __xfs_scrub_btree_process_error(sc, cur, level, error,
+	return __xchk_btree_process_error(sc, cur, level, error,
 			XFS_SCRUB_OFLAG_XFAIL, __return_address);
 }
 
 /* Record btree block corruption. */
 static void
-__xfs_scrub_btree_set_corrupt(
+__xchk_btree_set_corrupt(
 	struct xfs_scrub_context	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level,
@@ -97,30 +97,30 @@ __xfs_scrub_btree_set_corrupt(
 	sc->sm->sm_flags |= errflag;
 
 	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
-		trace_xfs_scrub_ifork_btree_error(sc, cur, level,
+		trace_xchk_ifork_btree_error(sc, cur, level,
 				ret_ip);
 	else
-		trace_xfs_scrub_btree_error(sc, cur, level,
+		trace_xchk_btree_error(sc, cur, level,
 				ret_ip);
 }
 
 void
-xfs_scrub_btree_set_corrupt(
+xchk_btree_set_corrupt(
 	struct xfs_scrub_context	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level)
 {
-	__xfs_scrub_btree_set_corrupt(sc, cur, level, XFS_SCRUB_OFLAG_CORRUPT,
+	__xchk_btree_set_corrupt(sc, cur, level, XFS_SCRUB_OFLAG_CORRUPT,
 			__return_address);
 }
 
 void
-xfs_scrub_btree_xref_set_corrupt(
+xchk_btree_xref_set_corrupt(
 	struct xfs_scrub_context	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level)
 {
-	__xfs_scrub_btree_set_corrupt(sc, cur, level, XFS_SCRUB_OFLAG_XCORRUPT,
+	__xchk_btree_set_corrupt(sc, cur, level, XFS_SCRUB_OFLAG_XCORRUPT,
 			__return_address);
 }
 
@@ -129,8 +129,8 @@ xfs_scrub_btree_xref_set_corrupt(
  * keys.
  */
 STATIC void
-xfs_scrub_btree_rec(
-	struct xfs_scrub_btree	*bs)
+xchk_btree_rec(
+	struct xchk_btree	*bs)
 {
 	struct xfs_btree_cur	*cur = bs->cur;
 	union xfs_btree_rec	*rec;
@@ -144,11 +144,11 @@ xfs_scrub_btree_rec(
 	block = xfs_btree_get_block(cur, 0, &bp);
 	rec = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
 
-	trace_xfs_scrub_btree_rec(bs->sc, cur, 0);
+	trace_xchk_btree_rec(bs->sc, cur, 0);
 
 	/* If this isn't the first record, are they in order? */
 	if (!bs->firstrec && !cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec))
-		xfs_scrub_btree_set_corrupt(bs->sc, cur, 0);
+		xchk_btree_set_corrupt(bs->sc, cur, 0);
 	bs->firstrec = false;
 	memcpy(&bs->lastrec, rec, cur->bc_ops->rec_len);
 
@@ -160,7 +160,7 @@ xfs_scrub_btree_rec(
 	keyblock = xfs_btree_get_block(cur, 1, &bp);
 	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[1], keyblock);
 	if (cur->bc_ops->diff_two_keys(cur, &key, keyp) < 0)
-		xfs_scrub_btree_set_corrupt(bs->sc, cur, 1);
+		xchk_btree_set_corrupt(bs->sc, cur, 1);
 
 	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
 		return;
@@ -169,7 +169,7 @@ xfs_scrub_btree_rec(
 	cur->bc_ops->init_high_key_from_rec(&hkey, rec);
 	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[1], keyblock);
 	if (cur->bc_ops->diff_two_keys(cur, keyp, &hkey) < 0)
-		xfs_scrub_btree_set_corrupt(bs->sc, cur, 1);
+		xchk_btree_set_corrupt(bs->sc, cur, 1);
 }
 
 /*
@@ -177,8 +177,8 @@ xfs_scrub_btree_rec(
  * keys.
  */
 STATIC void
-xfs_scrub_btree_key(
-	struct xfs_scrub_btree	*bs,
+xchk_btree_key(
+	struct xchk_btree	*bs,
 	int			level)
 {
 	struct xfs_btree_cur	*cur = bs->cur;
@@ -191,12 +191,12 @@ xfs_scrub_btree_key(
 	block = xfs_btree_get_block(cur, level, &bp);
 	key = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
 
-	trace_xfs_scrub_btree_key(bs->sc, cur, level);
+	trace_xchk_btree_key(bs->sc, cur, level);
 
 	/* If this isn't the first key, are they in order? */
 	if (!bs->firstkey[level] &&
 	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level], key))
-		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
+		xchk_btree_set_corrupt(bs->sc, cur, level);
 	bs->firstkey[level] = false;
 	memcpy(&bs->lastkey[level], key, cur->bc_ops->key_len);
 
@@ -207,7 +207,7 @@ xfs_scrub_btree_key(
 	keyblock = xfs_btree_get_block(cur, level + 1, &bp);
 	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
 	if (cur->bc_ops->diff_two_keys(cur, key, keyp) < 0)
-		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
+		xchk_btree_set_corrupt(bs->sc, cur, level);
 
 	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
 		return;
@@ -216,7 +216,7 @@ xfs_scrub_btree_key(
 	key = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
 	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
 	if (cur->bc_ops->diff_two_keys(cur, keyp, key) < 0)
-		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
+		xchk_btree_set_corrupt(bs->sc, cur, level);
 }
 
 /*
@@ -224,8 +224,8 @@ xfs_scrub_btree_key(
  * Callers do not need to set the corrupt flag.
  */
 static bool
-xfs_scrub_btree_ptr_ok(
-	struct xfs_scrub_btree		*bs,
+xchk_btree_ptr_ok(
+	struct xchk_btree		*bs,
 	int				level,
 	union xfs_btree_ptr		*ptr)
 {
@@ -242,15 +242,15 @@ xfs_scrub_btree_ptr_ok(
 	else
 		res = xfs_btree_check_sptr(bs->cur, be32_to_cpu(ptr->s), level);
 	if (!res)
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
 
 	return res;
 }
 
 /* Check that a btree block's sibling matches what we expect it. */
 STATIC int
-xfs_scrub_btree_block_check_sibling(
-	struct xfs_scrub_btree		*bs,
+xchk_btree_block_check_sibling(
+	struct xchk_btree		*bs,
 	int				level,
 	int				direction,
 	union xfs_btree_ptr		*sibling)
@@ -264,7 +264,7 @@ xfs_scrub_btree_block_check_sibling(
 	int				error;
 
 	error = xfs_btree_dup_cursor(cur, &ncur);
-	if (!xfs_scrub_btree_process_error(bs->sc, cur, level + 1, &error) ||
+	if (!xchk_btree_process_error(bs->sc, cur, level + 1, &error) ||
 	    !ncur)
 		return error;
 
@@ -278,7 +278,7 @@ xfs_scrub_btree_block_check_sibling(
 		else
 			error = xfs_btree_decrement(ncur, level + 1, &success);
 		if (error == 0 && success)
-			xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
+			xchk_btree_set_corrupt(bs->sc, cur, level);
 		error = 0;
 		goto out;
 	}
@@ -288,23 +288,23 @@ xfs_scrub_btree_block_check_sibling(
 		error = xfs_btree_increment(ncur, level + 1, &success);
 	else
 		error = xfs_btree_decrement(ncur, level + 1, &success);
-	if (!xfs_scrub_btree_process_error(bs->sc, cur, level + 1, &error))
+	if (!xchk_btree_process_error(bs->sc, cur, level + 1, &error))
 		goto out;
 	if (!success) {
-		xfs_scrub_btree_set_corrupt(bs->sc, cur, level + 1);
+		xchk_btree_set_corrupt(bs->sc, cur, level + 1);
 		goto out;
 	}
 
 	/* Compare upper level pointer to sibling pointer. */
 	pblock = xfs_btree_get_block(ncur, level + 1, &pbp);
 	pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
-	if (!xfs_scrub_btree_ptr_ok(bs, level + 1, pp))
+	if (!xchk_btree_ptr_ok(bs, level + 1, pp))
 		goto out;
 	if (pbp)
-		xfs_scrub_buffer_recheck(bs->sc, pbp);
+		xchk_buffer_recheck(bs->sc, pbp);
 
 	if (xfs_btree_diff_two_ptrs(cur, pp, sibling))
-		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
+		xchk_btree_set_corrupt(bs->sc, cur, level);
 out:
 	xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
 	return error;
@@ -312,8 +312,8 @@ xfs_scrub_btree_block_check_sibling(
 
 /* Check the siblings of a btree block. */
 STATIC int
-xfs_scrub_btree_block_check_siblings(
-	struct xfs_scrub_btree		*bs,
+xchk_btree_block_check_siblings(
+	struct xchk_btree		*bs,
 	struct xfs_btree_block		*block)
 {
 	struct xfs_btree_cur		*cur = bs->cur;
@@ -330,7 +330,7 @@ xfs_scrub_btree_block_check_siblings(
 	if (level == cur->bc_nlevels - 1) {
 		if (!xfs_btree_ptr_is_null(cur, &leftsib) ||
 		    !xfs_btree_ptr_is_null(cur, &rightsib))
-			xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
+			xchk_btree_set_corrupt(bs->sc, cur, level);
 		goto out;
 	}
 
@@ -339,10 +339,10 @@ xfs_scrub_btree_block_check_siblings(
 	 * parent level pointers?
 	 * (These function absorbs error codes for us.)
 	 */
-	error = xfs_scrub_btree_block_check_sibling(bs, level, -1, &leftsib);
+	error = xchk_btree_block_check_sibling(bs, level, -1, &leftsib);
 	if (error)
 		return error;
-	error = xfs_scrub_btree_block_check_sibling(bs, level, 1, &rightsib);
+	error = xchk_btree_block_check_sibling(bs, level, 1, &rightsib);
 	if (error)
 		return error;
 out:
@@ -360,8 +360,8 @@ struct check_owner {
  * an rmap record for it.
  */
 STATIC int
-xfs_scrub_btree_check_block_owner(
-	struct xfs_scrub_btree		*bs,
+xchk_btree_check_block_owner(
+	struct xchk_btree		*bs,
 	int				level,
 	xfs_daddr_t			daddr)
 {
@@ -380,13 +380,13 @@ xfs_scrub_btree_check_block_owner(
 
 	init_sa = bs->cur->bc_flags & XFS_BTREE_LONG_PTRS;
 	if (init_sa) {
-		error = xfs_scrub_ag_init(bs->sc, agno, &bs->sc->sa);
-		if (!xfs_scrub_btree_xref_process_error(bs->sc, bs->cur,
+		error = xchk_ag_init(bs->sc, agno, &bs->sc->sa);
+		if (!xchk_btree_xref_process_error(bs->sc, bs->cur,
 				level, &error))
 			return error;
 	}
 
-	xfs_scrub_xref_is_used_space(bs->sc, agbno, 1);
+	xchk_xref_is_used_space(bs->sc, agbno, 1);
 	/*
 	 * The bnobt scrubber aliases bs->cur to bs->sc->sa.bno_cur, so we
 	 * have to nullify it (to shut down further block owner checks) if
@@ -395,20 +395,20 @@ xfs_scrub_btree_check_block_owner(
 	if (!bs->sc->sa.bno_cur && btnum == XFS_BTNUM_BNO)
 		bs->cur = NULL;
 
-	xfs_scrub_xref_is_owned_by(bs->sc, agbno, 1, bs->oinfo);
+	xchk_xref_is_owned_by(bs->sc, agbno, 1, bs->oinfo);
 	if (!bs->sc->sa.rmap_cur && btnum == XFS_BTNUM_RMAP)
 		bs->cur = NULL;
 
 	if (init_sa)
-		xfs_scrub_ag_free(bs->sc, &bs->sc->sa);
+		xchk_ag_free(bs->sc, &bs->sc->sa);
 
 	return error;
 }
 
 /* Check the owner of a btree block. */
 STATIC int
-xfs_scrub_btree_check_owner(
-	struct xfs_scrub_btree		*bs,
+xchk_btree_check_owner(
+	struct xchk_btree		*bs,
 	int				level,
 	struct xfs_buf			*bp)
 {
@@ -437,7 +437,7 @@ xfs_scrub_btree_check_owner(
 		return 0;
 	}
 
-	return xfs_scrub_btree_check_block_owner(bs, level, XFS_BUF_ADDR(bp));
+	return xchk_btree_check_block_owner(bs, level, XFS_BUF_ADDR(bp));
 }
 
 /*
@@ -445,8 +445,8 @@ xfs_scrub_btree_check_owner(
  * special blocks that don't require that.
  */
 STATIC void
-xfs_scrub_btree_check_minrecs(
-	struct xfs_scrub_btree	*bs,
+xchk_btree_check_minrecs(
+	struct xchk_btree	*bs,
 	int			level,
 	struct xfs_btree_block	*block)
 {
@@ -475,7 +475,7 @@ xfs_scrub_btree_check_minrecs(
 	if (level >= ok_level)
 		return;
 
-	xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
+	xchk_btree_set_corrupt(bs->sc, bs->cur, level);
 }
 
 /*
@@ -483,8 +483,8 @@ xfs_scrub_btree_check_minrecs(
  * and buffer pointers (if applicable) if they're ok to use.
  */
 STATIC int
-xfs_scrub_btree_get_block(
-	struct xfs_scrub_btree		*bs,
+xchk_btree_get_block(
+	struct xchk_btree		*bs,
 	int				level,
 	union xfs_btree_ptr		*pp,
 	struct xfs_btree_block		**pblock,
@@ -497,7 +497,7 @@ xfs_scrub_btree_get_block(
 	*pbp = NULL;
 
 	error = xfs_btree_lookup_get_block(bs->cur, level, pp, pblock);
-	if (!xfs_scrub_btree_process_error(bs->sc, bs->cur, level, &error) ||
+	if (!xchk_btree_process_error(bs->sc, bs->cur, level, &error) ||
 	    !*pblock)
 		return error;
 
@@ -509,19 +509,19 @@ xfs_scrub_btree_get_block(
 		failed_at = __xfs_btree_check_sblock(bs->cur, *pblock,
 				 level, *pbp);
 	if (failed_at) {
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
 		return 0;
 	}
 	if (*pbp)
-		xfs_scrub_buffer_recheck(bs->sc, *pbp);
+		xchk_buffer_recheck(bs->sc, *pbp);
 
-	xfs_scrub_btree_check_minrecs(bs, level, *pblock);
+	xchk_btree_check_minrecs(bs, level, *pblock);
 
 	/*
 	 * Check the block's owner; this function absorbs error codes
 	 * for us.
 	 */
-	error = xfs_scrub_btree_check_owner(bs, level, *pbp);
+	error = xchk_btree_check_owner(bs, level, *pbp);
 	if (error)
 		return error;
 
@@ -529,7 +529,7 @@ xfs_scrub_btree_get_block(
 	 * Check the block's siblings; this function absorbs error codes
 	 * for us.
 	 */
-	return xfs_scrub_btree_block_check_siblings(bs, *pblock);
+	return xchk_btree_block_check_siblings(bs, *pblock);
 }
 
 /*
@@ -537,8 +537,8 @@ xfs_scrub_btree_get_block(
  * in the parent block.
  */
 STATIC void
-xfs_scrub_btree_block_keys(
-	struct xfs_scrub_btree		*bs,
+xchk_btree_block_keys(
+	struct xchk_btree		*bs,
 	int				level,
 	struct xfs_btree_block		*block)
 {
@@ -562,7 +562,7 @@ xfs_scrub_btree_block_keys(
 			parent_block);
 
 	if (cur->bc_ops->diff_two_keys(cur, &block_keys, parent_keys) != 0)
-		xfs_scrub_btree_set_corrupt(bs->sc, cur, 1);
+		xchk_btree_set_corrupt(bs->sc, cur, 1);
 
 	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
 		return;
@@ -573,7 +573,7 @@ xfs_scrub_btree_block_keys(
 			parent_block);
 
 	if (cur->bc_ops->diff_two_keys(cur, high_bk, high_pk) != 0)
-		xfs_scrub_btree_set_corrupt(bs->sc, cur, 1);
+		xchk_btree_set_corrupt(bs->sc, cur, 1);
 }
 
 /*
@@ -582,14 +582,14 @@ xfs_scrub_btree_block_keys(
  * so that the caller can verify individual records.
  */
 int
-xfs_scrub_btree(
+xchk_btree(
 	struct xfs_scrub_context	*sc,
 	struct xfs_btree_cur		*cur,
-	xfs_scrub_btree_rec_fn		scrub_fn,
+	xchk_btree_rec_fn		scrub_fn,
 	struct xfs_owner_info		*oinfo,
 	void				*private)
 {
-	struct xfs_scrub_btree		bs = { NULL };
+	struct xchk_btree		bs = { NULL };
 	union xfs_btree_ptr		ptr;
 	union xfs_btree_ptr		*pp;
 	union xfs_btree_rec		*recp;
@@ -614,7 +614,7 @@ xfs_scrub_btree(
 
 	/* Don't try to check a tree with a height we can't handle. */
 	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS) {
-		xfs_scrub_btree_set_corrupt(sc, cur, 0);
+		xchk_btree_set_corrupt(sc, cur, 0);
 		goto out;
 	}
 
@@ -624,9 +624,9 @@ xfs_scrub_btree(
 	 */
 	level = cur->bc_nlevels - 1;
 	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
-	if (!xfs_scrub_btree_ptr_ok(&bs, cur->bc_nlevels, &ptr))
+	if (!xchk_btree_ptr_ok(&bs, cur->bc_nlevels, &ptr))
 		goto out;
-	error = xfs_scrub_btree_get_block(&bs, level, &ptr, &block, &bp);
+	error = xchk_btree_get_block(&bs, level, &ptr, &block, &bp);
 	if (error || !block)
 		goto out;
 
@@ -639,7 +639,7 @@ xfs_scrub_btree(
 			/* End of leaf, pop back towards the root. */
 			if (cur->bc_ptrs[level] >
 			    be16_to_cpu(block->bb_numrecs)) {
-				xfs_scrub_btree_block_keys(&bs, level, block);
+				xchk_btree_block_keys(&bs, level, block);
 				if (level < cur->bc_nlevels - 1)
 					cur->bc_ptrs[level + 1]++;
 				level++;
@@ -647,14 +647,14 @@ xfs_scrub_btree(
 			}
 
 			/* Records in order for scrub? */
-			xfs_scrub_btree_rec(&bs);
+			xchk_btree_rec(&bs);
 
 			/* Call out to the record checker. */
 			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
 			error = bs.scrub_rec(&bs, recp);
 			if (error)
 				break;
-			if (xfs_scrub_should_terminate(sc, &error) ||
+			if (xchk_should_terminate(sc, &error) ||
 			    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 				break;
 
@@ -664,7 +664,7 @@ xfs_scrub_btree(
 
 		/* End of node, pop back towards the root. */
 		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
-			xfs_scrub_btree_block_keys(&bs, level, block);
+			xchk_btree_block_keys(&bs, level, block);
 			if (level < cur->bc_nlevels - 1)
 				cur->bc_ptrs[level + 1]++;
 			level++;
@@ -672,16 +672,16 @@ xfs_scrub_btree(
 		}
 
 		/* Keys in order for scrub? */
-		xfs_scrub_btree_key(&bs, level);
+		xchk_btree_key(&bs, level);
 
 		/* Drill another level deeper. */
 		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
-		if (!xfs_scrub_btree_ptr_ok(&bs, level, pp)) {
+		if (!xchk_btree_ptr_ok(&bs, level, pp)) {
 			cur->bc_ptrs[level]++;
 			continue;
 		}
 		level--;
-		error = xfs_scrub_btree_get_block(&bs, level, pp, &block, &bp);
+		error = xchk_btree_get_block(&bs, level, pp, &block, &bp);
 		if (error || !block)
 			goto out;
 
@@ -692,7 +692,7 @@ xfs_scrub_btree(
 	/* Process deferred owner checks on btree blocks. */
 	list_for_each_entry_safe(co, n, &bs.to_check, list) {
 		if (!error && bs.cur)
-			error = xfs_scrub_btree_check_block_owner(&bs,
+			error = xchk_btree_check_block_owner(&bs,
 					co->level, co->daddr);
 		list_del(&co->list);
 		kmem_free(co);
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index 956627500f2c..598ac04a6c3e 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -9,32 +9,32 @@
 /* btree scrub */
 
 /* Check for btree operation errors. */
-bool xfs_scrub_btree_process_error(struct xfs_scrub_context *sc,
+bool xchk_btree_process_error(struct xfs_scrub_context *sc,
 		struct xfs_btree_cur *cur, int level, int *error);
 
 /* Check for btree xref operation errors. */
-bool xfs_scrub_btree_xref_process_error(struct xfs_scrub_context *sc,
+bool xchk_btree_xref_process_error(struct xfs_scrub_context *sc,
 				struct xfs_btree_cur *cur, int level,
 				int *error);
 
 /* Check for btree corruption. */
-void xfs_scrub_btree_set_corrupt(struct xfs_scrub_context *sc,
+void xchk_btree_set_corrupt(struct xfs_scrub_context *sc,
 		struct xfs_btree_cur *cur, int level);
 
 /* Check for btree xref discrepancies. */
-void xfs_scrub_btree_xref_set_corrupt(struct xfs_scrub_context *sc,
+void xchk_btree_xref_set_corrupt(struct xfs_scrub_context *sc,
 		struct xfs_btree_cur *cur, int level);
 
-struct xfs_scrub_btree;
-typedef int (*xfs_scrub_btree_rec_fn)(
-	struct xfs_scrub_btree	*bs,
+struct xchk_btree;
+typedef int (*xchk_btree_rec_fn)(
+	struct xchk_btree	*bs,
 	union xfs_btree_rec	*rec);
 
-struct xfs_scrub_btree {
+struct xchk_btree {
 	/* caller-provided scrub state */
 	struct xfs_scrub_context	*sc;
 	struct xfs_btree_cur		*cur;
-	xfs_scrub_btree_rec_fn		scrub_rec;
+	xchk_btree_rec_fn		scrub_rec;
 	struct xfs_owner_info		*oinfo;
 	void				*private;
 
@@ -45,8 +45,8 @@ struct xfs_scrub_btree {
 	bool				firstkey[XFS_BTREE_MAXLEVELS];
 	struct list_head		to_check;
 };
-int xfs_scrub_btree(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
-		    xfs_scrub_btree_rec_fn scrub_fn,
+int xchk_btree(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+		    xchk_btree_rec_fn scrub_fn,
 		    struct xfs_owner_info *oinfo, void *private);
 
 #endif /* __XFS_SCRUB_BTREE_H__ */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 70e70c69f83f..a4004a06f482 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -68,7 +68,7 @@
 
 /* Check for operational errors. */
 static bool
-__xfs_scrub_process_error(
+__xchk_process_error(
 	struct xfs_scrub_context	*sc,
 	xfs_agnumber_t			agno,
 	xfs_agblock_t			bno,
@@ -81,7 +81,7 @@ __xfs_scrub_process_error(
 		return true;
 	case -EDEADLOCK:
 		/* Used to restart an op with deadlock avoidance. */
-		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
+		trace_xchk_deadlock_retry(sc->ip, sc->sm, *error);
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
@@ -90,7 +90,7 @@ __xfs_scrub_process_error(
 		*error = 0;
 		/* fall through */
 	default:
-		trace_xfs_scrub_op_error(sc, agno, bno, *error,
+		trace_xchk_op_error(sc, agno, bno, *error,
 				ret_ip);
 		break;
 	}
@@ -98,30 +98,30 @@ __xfs_scrub_process_error(
 }
 
 bool
-xfs_scrub_process_error(
+xchk_process_error(
 	struct xfs_scrub_context	*sc,
 	xfs_agnumber_t			agno,
 	xfs_agblock_t			bno,
 	int				*error)
 {
-	return __xfs_scrub_process_error(sc, agno, bno, error,
+	return __xchk_process_error(sc, agno, bno, error,
 			XFS_SCRUB_OFLAG_CORRUPT, __return_address);
 }
 
 bool
-xfs_scrub_xref_process_error(
+xchk_xref_process_error(
 	struct xfs_scrub_context	*sc,
 	xfs_agnumber_t			agno,
 	xfs_agblock_t			bno,
 	int				*error)
 {
-	return __xfs_scrub_process_error(sc, agno, bno, error,
+	return __xchk_process_error(sc, agno, bno, error,
 			XFS_SCRUB_OFLAG_XFAIL, __return_address);
 }
 
 /* Check for operational errors for a file offset. */
 static bool
-__xfs_scrub_fblock_process_error(
+__xchk_fblock_process_error(
 	struct xfs_scrub_context	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset,
@@ -134,7 +134,7 @@ __xfs_scrub_fblock_process_error(
 		return true;
 	case -EDEADLOCK:
 		/* Used to restart an op with deadlock avoidance. */
-		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
+		trace_xchk_deadlock_retry(sc->ip, sc->sm, *error);
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
@@ -143,7 +143,7 @@ __xfs_scrub_fblock_process_error(
 		*error = 0;
 		/* fall through */
 	default:
-		trace_xfs_scrub_file_op_error(sc, whichfork, offset, *error,
+		trace_xchk_file_op_error(sc, whichfork, offset, *error,
 				ret_ip);
 		break;
 	}
@@ -151,24 +151,24 @@ __xfs_scrub_fblock_process_error(
 }
 
 bool
-xfs_scrub_fblock_process_error(
+xchk_fblock_process_error(
 	struct xfs_scrub_context	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset,
 	int				*error)
 {
-	return __xfs_scrub_fblock_process_error(sc, whichfork, offset, error,
+	return __xchk_fblock_process_error(sc, whichfork, offset, error,
 			XFS_SCRUB_OFLAG_CORRUPT, __return_address);
 }
 
 bool
-xfs_scrub_fblock_xref_process_error(
+xchk_fblock_xref_process_error(
 	struct xfs_scrub_context	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset,
 	int				*error)
 {
-	return __xfs_scrub_fblock_process_error(sc, whichfork, offset, error,
+	return __xchk_fblock_process_error(sc, whichfork, offset, error,
 			XFS_SCRUB_OFLAG_XFAIL, __return_address);
 }
 
@@ -186,12 +186,12 @@ xfs_scrub_fblock_xref_process_error(
 
 /* Record a block which could be optimized. */
 void
-xfs_scrub_block_set_preen(
+xchk_block_set_preen(
 	struct xfs_scrub_context	*sc,
 	struct xfs_buf			*bp)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
-	trace_xfs_scrub_block_preen(sc, bp->b_bn, __return_address);
+	trace_xchk_block_preen(sc, bp->b_bn, __return_address);
 }
 
 /*
@@ -200,32 +200,32 @@ xfs_scrub_block_set_preen(
  * the block location of the inode record itself.
  */
 void
-xfs_scrub_ino_set_preen(
+xchk_ino_set_preen(
 	struct xfs_scrub_context	*sc,
 	xfs_ino_t			ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
-	trace_xfs_scrub_ino_preen(sc, ino, __return_address);
+	trace_xchk_ino_preen(sc, ino, __return_address);
 }
 
 /* Record a corrupt block. */
 void
-xfs_scrub_block_set_corrupt(
+xchk_block_set_corrupt(
 	struct xfs_scrub_context	*sc,
 	struct xfs_buf			*bp)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
-	trace_xfs_scrub_block_error(sc, bp->b_bn, __return_address);
+	trace_xchk_block_error(sc, bp->b_bn, __return_address);
 }
 
 /* Record a corruption while cross-referencing. */
 void
-xfs_scrub_block_xref_set_corrupt(
+xchk_block_xref_set_corrupt(
 	struct xfs_scrub_context	*sc,
 	struct xfs_buf			*bp)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
-	trace_xfs_scrub_block_error(sc, bp->b_bn, __return_address);
+	trace_xchk_block_error(sc, bp->b_bn, __return_address);
 }
 
 /*
@@ -234,44 +234,44 @@ xfs_scrub_block_xref_set_corrupt(
  * inode record itself.
  */
 void
-xfs_scrub_ino_set_corrupt(
+xchk_ino_set_corrupt(
 	struct xfs_scrub_context	*sc,
 	xfs_ino_t			ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
-	trace_xfs_scrub_ino_error(sc, ino, __return_address);
+	trace_xchk_ino_error(sc, ino, __return_address);
 }
 
 /* Record a corruption while cross-referencing with an inode. */
 void
-xfs_scrub_ino_xref_set_corrupt(
+xchk_ino_xref_set_corrupt(
 	struct xfs_scrub_context	*sc,
 	xfs_ino_t			ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
-	trace_xfs_scrub_ino_error(sc, ino, __return_address);
+	trace_xchk_ino_error(sc, ino, __return_address);
 }
 
 /* Record corruption in a block indexed by a file fork. */
 void
-xfs_scrub_fblock_set_corrupt(
+xchk_fblock_set_corrupt(
 	struct xfs_scrub_context	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
-	trace_xfs_scrub_fblock_error(sc, whichfork, offset, __return_address);
+	trace_xchk_fblock_error(sc, whichfork, offset, __return_address);
 }
 
 /* Record a corruption while cross-referencing a fork block. */
 void
-xfs_scrub_fblock_xref_set_corrupt(
+xchk_fblock_xref_set_corrupt(
 	struct xfs_scrub_context	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
-	trace_xfs_scrub_fblock_error(sc, whichfork, offset, __return_address);
+	trace_xchk_fblock_error(sc, whichfork, offset, __return_address);
 }
 
 /*
@@ -279,32 +279,32 @@ xfs_scrub_fblock_xref_set_corrupt(
  * incorrect.
  */
 void
-xfs_scrub_ino_set_warning(
+xchk_ino_set_warning(
 	struct xfs_scrub_context	*sc,
 	xfs_ino_t			ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
-	trace_xfs_scrub_ino_warning(sc, ino, __return_address);
+	trace_xchk_ino_warning(sc, ino, __return_address);
 }
 
 /* Warn about a block indexed by a file fork that needs review. */
 void
-xfs_scrub_fblock_set_warning(
+xchk_fblock_set_warning(
 	struct xfs_scrub_context	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
-	trace_xfs_scrub_fblock_warning(sc, whichfork, offset, __return_address);
+	trace_xchk_fblock_warning(sc, whichfork, offset, __return_address);
 }
 
 /* Signal an incomplete scrub. */
 void
-xfs_scrub_set_incomplete(
+xchk_set_incomplete(
 	struct xfs_scrub_context	*sc)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_INCOMPLETE;
-	trace_xfs_scrub_incomplete(sc, __return_address);
+	trace_xchk_incomplete(sc, __return_address);
 }
 
 /*
@@ -312,18 +312,18 @@ xfs_scrub_set_incomplete(
  * at least according to the reverse mapping data.
  */
 
-struct xfs_scrub_rmap_ownedby_info {
+struct xchk_rmap_ownedby_info {
 	struct xfs_owner_info	*oinfo;
 	xfs_filblks_t		*blocks;
 };
 
 STATIC int
-xfs_scrub_count_rmap_ownedby_irec(
+xchk_count_rmap_ownedby_irec(
 	struct xfs_btree_cur			*cur,
 	struct xfs_rmap_irec			*rec,
 	void					*priv)
 {
-	struct xfs_scrub_rmap_ownedby_info	*sroi = priv;
+	struct xchk_rmap_ownedby_info		*sroi = priv;
 	bool					irec_attr;
 	bool					oinfo_attr;
 
@@ -344,19 +344,19 @@ xfs_scrub_count_rmap_ownedby_irec(
  * The caller should pass us an rmapbt cursor.
  */
 int
-xfs_scrub_count_rmap_ownedby_ag(
+xchk_count_rmap_ownedby_ag(
 	struct xfs_scrub_context		*sc,
 	struct xfs_btree_cur			*cur,
 	struct xfs_owner_info			*oinfo,
 	xfs_filblks_t				*blocks)
 {
-	struct xfs_scrub_rmap_ownedby_info	sroi;
+	struct xchk_rmap_ownedby_info		sroi;
 
 	sroi.oinfo = oinfo;
 	*blocks = 0;
 	sroi.blocks = blocks;
 
-	return xfs_rmap_query_all(cur, xfs_scrub_count_rmap_ownedby_irec,
+	return xfs_rmap_query_all(cur, xchk_count_rmap_ownedby_irec,
 			&sroi);
 }
 
@@ -392,12 +392,12 @@ want_ag_read_header_failure(
 /*
  * Grab all the headers for an AG.
  *
- * The headers should be released by xfs_scrub_ag_free, but as a fail
+ * The headers should be released by xchk_ag_free, but as a fail
  * safe we attach all the buffers we grab to the scrub transaction so
  * they'll all be freed when we cancel it.
  */
 int
-xfs_scrub_ag_read_headers(
+xchk_ag_read_headers(
 	struct xfs_scrub_context	*sc,
 	xfs_agnumber_t			agno,
 	struct xfs_buf			**agi,
@@ -425,8 +425,8 @@ xfs_scrub_ag_read_headers(
 
 /* Release all the AG btree cursors. */
 void
-xfs_scrub_ag_btcur_free(
-	struct xfs_scrub_ag		*sa)
+xchk_ag_btcur_free(
+	struct xchk_ag		*sa)
 {
 	if (sa->refc_cur)
 		xfs_btree_del_cursor(sa->refc_cur, XFS_BTREE_ERROR);
@@ -451,9 +451,9 @@ xfs_scrub_ag_btcur_free(
 
 /* Initialize all the btree cursors for an AG. */
 int
-xfs_scrub_ag_btcur_init(
+xchk_ag_btcur_init(
 	struct xfs_scrub_context	*sc,
-	struct xfs_scrub_ag		*sa)
+	struct xchk_ag		*sa)
 {
 	struct xfs_mount		*mp = sc->mp;
 	xfs_agnumber_t			agno = sa->agno;
@@ -511,11 +511,11 @@ xfs_scrub_ag_btcur_init(
 
 /* Release the AG header context and btree cursors. */
 void
-xfs_scrub_ag_free(
+xchk_ag_free(
 	struct xfs_scrub_context	*sc,
-	struct xfs_scrub_ag		*sa)
+	struct xchk_ag		*sa)
 {
-	xfs_scrub_ag_btcur_free(sa);
+	xchk_ag_btcur_free(sa);
 	if (sa->agfl_bp) {
 		xfs_trans_brelse(sc->tp, sa->agfl_bp);
 		sa->agfl_bp = NULL;
@@ -543,30 +543,30 @@ xfs_scrub_ag_free(
  * transaction ourselves.
  */
 int
-xfs_scrub_ag_init(
+xchk_ag_init(
 	struct xfs_scrub_context	*sc,
 	xfs_agnumber_t			agno,
-	struct xfs_scrub_ag		*sa)
+	struct xchk_ag		*sa)
 {
 	int				error;
 
 	sa->agno = agno;
-	error = xfs_scrub_ag_read_headers(sc, agno, &sa->agi_bp,
+	error = xchk_ag_read_headers(sc, agno, &sa->agi_bp,
 			&sa->agf_bp, &sa->agfl_bp);
 	if (error)
 		return error;
 
-	return xfs_scrub_ag_btcur_init(sc, sa);
+	return xchk_ag_btcur_init(sc, sa);
 }
 
 /*
  * Grab the per-ag structure if we haven't already gotten it.  Teardown of the
- * xfs_scrub_ag will release it for us.
+ * xchk_ag will release it for us.
  */
 void
-xfs_scrub_perag_get(
+xchk_perag_get(
 	struct xfs_mount	*mp,
-	struct xfs_scrub_ag	*sa)
+	struct xchk_ag	*sa)
 {
 	if (!sa->pag)
 		sa->pag = xfs_perag_get(mp, sa->agno);
@@ -585,7 +585,7 @@ xfs_scrub_perag_get(
  * the metadata object.
  */
 int
-xfs_scrub_trans_alloc(
+xchk_trans_alloc(
 	struct xfs_scrub_context	*sc,
 	uint				resblks)
 {
@@ -598,19 +598,19 @@ xfs_scrub_trans_alloc(
 
 /* Set us up with a transaction and an empty context. */
 int
-xfs_scrub_setup_fs(
+xchk_setup_fs(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
 	uint				resblks;
 
 	resblks = xfs_repair_calc_ag_resblks(sc);
-	return xfs_scrub_trans_alloc(sc, resblks);
+	return xchk_trans_alloc(sc, resblks);
 }
 
 /* Set us up with AG headers and btree cursors. */
 int
-xfs_scrub_setup_ag_btree(
+xchk_setup_ag_btree(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip,
 	bool				force_log)
@@ -625,21 +625,21 @@ xfs_scrub_setup_ag_btree(
 	 * document why they need to do so.
 	 */
 	if (force_log) {
-		error = xfs_scrub_checkpoint_log(mp);
+		error = xchk_checkpoint_log(mp);
 		if (error)
 			return error;
 	}
 
-	error = xfs_scrub_setup_fs(sc, ip);
+	error = xchk_setup_fs(sc, ip);
 	if (error)
 		return error;
 
-	return xfs_scrub_ag_init(sc, sc->sm->sm_agno, &sc->sa);
+	return xchk_ag_init(sc, sc->sm->sm_agno, &sc->sa);
 }
 
 /* Push everything out of the log onto disk. */
 int
-xfs_scrub_checkpoint_log(
+xchk_checkpoint_log(
 	struct xfs_mount	*mp)
 {
 	int			error;
@@ -657,7 +657,7 @@ xfs_scrub_checkpoint_log(
  * The inode is not locked.
  */
 int
-xfs_scrub_get_inode(
+xchk_get_inode(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip_in)
 {
@@ -704,7 +704,7 @@ xfs_scrub_get_inode(
 		error = -EFSCORRUPTED;
 		/* fall through */
 	default:
-		trace_xfs_scrub_op_error(sc,
+		trace_xchk_op_error(sc,
 				XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
 				XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
 				error, __return_address);
@@ -721,21 +721,21 @@ xfs_scrub_get_inode(
 
 /* Set us up to scrub a file's contents. */
 int
-xfs_scrub_setup_inode_contents(
+xchk_setup_inode_contents(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip,
 	unsigned int			resblks)
 {
 	int				error;
 
-	error = xfs_scrub_get_inode(sc, ip);
+	error = xchk_get_inode(sc, ip);
 	if (error)
 		return error;
 
 	/* Got the inode, lock it and we're ready to go. */
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
-	error = xfs_scrub_trans_alloc(sc, resblks);
+	error = xchk_trans_alloc(sc, resblks);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
@@ -752,13 +752,13 @@ xfs_scrub_setup_inode_contents(
  * the cursor and skip the check.
  */
 bool
-xfs_scrub_should_check_xref(
+xchk_should_check_xref(
 	struct xfs_scrub_context	*sc,
 	int				*error,
 	struct xfs_btree_cur		**curpp)
 {
 	/* No point in xref if we already know we're corrupt. */
-	if (xfs_scrub_skip_xref(sc->sm))
+	if (xchk_skip_xref(sc->sm))
 		return false;
 
 	if (*error == 0)
@@ -775,7 +775,7 @@ xfs_scrub_should_check_xref(
 	}
 
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
-	trace_xfs_scrub_xref_error(sc, *error, __return_address);
+	trace_xchk_xref_error(sc, *error, __return_address);
 
 	/*
 	 * Errors encountered during cross-referencing with another
@@ -787,25 +787,25 @@ xfs_scrub_should_check_xref(
 
 /* Run the structure verifiers on in-memory buffers to detect bad memory. */
 void
-xfs_scrub_buffer_recheck(
+xchk_buffer_recheck(
 	struct xfs_scrub_context	*sc,
 	struct xfs_buf			*bp)
 {
 	xfs_failaddr_t			fa;
 
 	if (bp->b_ops == NULL) {
-		xfs_scrub_block_set_corrupt(sc, bp);
+		xchk_block_set_corrupt(sc, bp);
 		return;
 	}
 	if (bp->b_ops->verify_struct == NULL) {
-		xfs_scrub_set_incomplete(sc);
+		xchk_set_incomplete(sc);
 		return;
 	}
 	fa = bp->b_ops->verify_struct(bp);
 	if (!fa)
 		return;
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
-	trace_xfs_scrub_block_error(sc, bp->b_bn, fa);
+	trace_xchk_block_error(sc, bp->b_bn, fa);
 }
 
 /*
@@ -813,7 +813,7 @@ xfs_scrub_buffer_recheck(
  * pointed to by sc->ip and the ILOCK must be held.
  */
 int
-xfs_scrub_metadata_inode_forks(
+xchk_metadata_inode_forks(
 	struct xfs_scrub_context	*sc)
 {
 	__u32				smtype;
@@ -825,26 +825,26 @@ xfs_scrub_metadata_inode_forks(
 
 	/* Metadata inodes don't live on the rt device. */
 	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
-		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		return 0;
 	}
 
 	/* They should never participate in reflink. */
 	if (xfs_is_reflink_inode(sc->ip)) {
-		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		return 0;
 	}
 
 	/* They also should never have extended attributes. */
 	if (xfs_inode_hasattr(sc->ip)) {
-		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		return 0;
 	}
 
 	/* Invoke the data fork scrubber. */
 	smtype = sc->sm->sm_type;
 	sc->sm->sm_type = XFS_SCRUB_TYPE_BMBTD;
-	error = xfs_scrub_bmap_data(sc);
+	error = xchk_bmap_data(sc);
 	sc->sm->sm_type = smtype;
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
@@ -853,11 +853,11 @@ xfs_scrub_metadata_inode_forks(
 	if (xfs_sb_version_hasreflink(&sc->mp->m_sb)) {
 		error = xfs_reflink_inode_has_shared_extents(sc->tp, sc->ip,
 				&shared);
-		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0,
+		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0,
 				&error))
 			return error;
 		if (shared)
-			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 	}
 
 	return error;
@@ -871,7 +871,7 @@ xfs_scrub_metadata_inode_forks(
  * we can't.
  */
 int
-xfs_scrub_ilock_inverted(
+xchk_ilock_inverted(
 	struct xfs_inode	*ip,
 	uint			lock_mode)
 {
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 2172bd5361e2..5881cb2ecc26 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -12,7 +12,7 @@
  * Note that we're careful not to make any judgements about *error.
  */
 static inline bool
-xfs_scrub_should_terminate(
+xchk_should_terminate(
 	struct xfs_scrub_context	*sc,
 	int				*error)
 {
@@ -24,121 +24,121 @@ xfs_scrub_should_terminate(
 	return false;
 }
 
-int xfs_scrub_trans_alloc(struct xfs_scrub_context *sc, uint resblks);
-bool xfs_scrub_process_error(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+int xchk_trans_alloc(struct xfs_scrub_context *sc, uint resblks);
+bool xchk_process_error(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 		xfs_agblock_t bno, int *error);
-bool xfs_scrub_fblock_process_error(struct xfs_scrub_context *sc, int whichfork,
+bool xchk_fblock_process_error(struct xfs_scrub_context *sc, int whichfork,
 		xfs_fileoff_t offset, int *error);
 
-bool xfs_scrub_xref_process_error(struct xfs_scrub_context *sc,
+bool xchk_xref_process_error(struct xfs_scrub_context *sc,
 		xfs_agnumber_t agno, xfs_agblock_t bno, int *error);
-bool xfs_scrub_fblock_xref_process_error(struct xfs_scrub_context *sc,
+bool xchk_fblock_xref_process_error(struct xfs_scrub_context *sc,
 		int whichfork, xfs_fileoff_t offset, int *error);
 
-void xfs_scrub_block_set_preen(struct xfs_scrub_context *sc,
+void xchk_block_set_preen(struct xfs_scrub_context *sc,
 		struct xfs_buf *bp);
-void xfs_scrub_ino_set_preen(struct xfs_scrub_context *sc, xfs_ino_t ino);
+void xchk_ino_set_preen(struct xfs_scrub_context *sc, xfs_ino_t ino);
 
-void xfs_scrub_block_set_corrupt(struct xfs_scrub_context *sc,
+void xchk_block_set_corrupt(struct xfs_scrub_context *sc,
 		struct xfs_buf *bp);
-void xfs_scrub_ino_set_corrupt(struct xfs_scrub_context *sc, xfs_ino_t ino);
-void xfs_scrub_fblock_set_corrupt(struct xfs_scrub_context *sc, int whichfork,
+void xchk_ino_set_corrupt(struct xfs_scrub_context *sc, xfs_ino_t ino);
+void xchk_fblock_set_corrupt(struct xfs_scrub_context *sc, int whichfork,
 		xfs_fileoff_t offset);
 
-void xfs_scrub_block_xref_set_corrupt(struct xfs_scrub_context *sc,
+void xchk_block_xref_set_corrupt(struct xfs_scrub_context *sc,
 		struct xfs_buf *bp);
-void xfs_scrub_ino_xref_set_corrupt(struct xfs_scrub_context *sc,
+void xchk_ino_xref_set_corrupt(struct xfs_scrub_context *sc,
 		xfs_ino_t ino);
-void xfs_scrub_fblock_xref_set_corrupt(struct xfs_scrub_context *sc,
+void xchk_fblock_xref_set_corrupt(struct xfs_scrub_context *sc,
 		int whichfork, xfs_fileoff_t offset);
 
-void xfs_scrub_ino_set_warning(struct xfs_scrub_context *sc, xfs_ino_t ino);
-void xfs_scrub_fblock_set_warning(struct xfs_scrub_context *sc, int whichfork,
+void xchk_ino_set_warning(struct xfs_scrub_context *sc, xfs_ino_t ino);
+void xchk_fblock_set_warning(struct xfs_scrub_context *sc, int whichfork,
 		xfs_fileoff_t offset);
 
-void xfs_scrub_set_incomplete(struct xfs_scrub_context *sc);
-int xfs_scrub_checkpoint_log(struct xfs_mount *mp);
+void xchk_set_incomplete(struct xfs_scrub_context *sc);
+int xchk_checkpoint_log(struct xfs_mount *mp);
 
 /* Are we set up for a cross-referencing check? */
-bool xfs_scrub_should_check_xref(struct xfs_scrub_context *sc, int *error,
+bool xchk_should_check_xref(struct xfs_scrub_context *sc, int *error,
 			   struct xfs_btree_cur **curpp);
 
 /* Setup functions */
-int xfs_scrub_setup_fs(struct xfs_scrub_context *sc, struct xfs_inode *ip);
-int xfs_scrub_setup_ag_allocbt(struct xfs_scrub_context *sc,
+int xchk_setup_fs(struct xfs_scrub_context *sc, struct xfs_inode *ip);
+int xchk_setup_ag_allocbt(struct xfs_scrub_context *sc,
 			       struct xfs_inode *ip);
-int xfs_scrub_setup_ag_iallocbt(struct xfs_scrub_context *sc,
+int xchk_setup_ag_iallocbt(struct xfs_scrub_context *sc,
 				struct xfs_inode *ip);
-int xfs_scrub_setup_ag_rmapbt(struct xfs_scrub_context *sc,
+int xchk_setup_ag_rmapbt(struct xfs_scrub_context *sc,
 			      struct xfs_inode *ip);
-int xfs_scrub_setup_ag_refcountbt(struct xfs_scrub_context *sc,
+int xchk_setup_ag_refcountbt(struct xfs_scrub_context *sc,
 				  struct xfs_inode *ip);
-int xfs_scrub_setup_inode(struct xfs_scrub_context *sc,
+int xchk_setup_inode(struct xfs_scrub_context *sc,
 			  struct xfs_inode *ip);
-int xfs_scrub_setup_inode_bmap(struct xfs_scrub_context *sc,
+int xchk_setup_inode_bmap(struct xfs_scrub_context *sc,
 			       struct xfs_inode *ip);
-int xfs_scrub_setup_inode_bmap_data(struct xfs_scrub_context *sc,
+int xchk_setup_inode_bmap_data(struct xfs_scrub_context *sc,
 				    struct xfs_inode *ip);
-int xfs_scrub_setup_directory(struct xfs_scrub_context *sc,
+int xchk_setup_directory(struct xfs_scrub_context *sc,
 			      struct xfs_inode *ip);
-int xfs_scrub_setup_xattr(struct xfs_scrub_context *sc,
+int xchk_setup_xattr(struct xfs_scrub_context *sc,
 			  struct xfs_inode *ip);
-int xfs_scrub_setup_symlink(struct xfs_scrub_context *sc,
+int xchk_setup_symlink(struct xfs_scrub_context *sc,
 			    struct xfs_inode *ip);
-int xfs_scrub_setup_parent(struct xfs_scrub_context *sc,
+int xchk_setup_parent(struct xfs_scrub_context *sc,
 			   struct xfs_inode *ip);
 #ifdef CONFIG_XFS_RT
-int xfs_scrub_setup_rt(struct xfs_scrub_context *sc, struct xfs_inode *ip);
+int xchk_setup_rt(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 #else
 static inline int
-xfs_scrub_setup_rt(struct xfs_scrub_context *sc, struct xfs_inode *ip)
+xchk_setup_rt(struct xfs_scrub_context *sc, struct xfs_inode *ip)
 {
 	return -ENOENT;
 }
 #endif
 #ifdef CONFIG_XFS_QUOTA
-int xfs_scrub_setup_quota(struct xfs_scrub_context *sc, struct xfs_inode *ip);
+int xchk_setup_quota(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 #else
 static inline int
-xfs_scrub_setup_quota(struct xfs_scrub_context *sc, struct xfs_inode *ip)
+xchk_setup_quota(struct xfs_scrub_context *sc, struct xfs_inode *ip)
 {
 	return -ENOENT;
 }
 #endif
 
-void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
-int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
-		      struct xfs_scrub_ag *sa);
-void xfs_scrub_perag_get(struct xfs_mount *mp, struct xfs_scrub_ag *sa);
-int xfs_scrub_ag_read_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+void xchk_ag_free(struct xfs_scrub_context *sc, struct xchk_ag *sa);
+int xchk_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+		      struct xchk_ag *sa);
+void xchk_perag_get(struct xfs_mount *mp, struct xchk_ag *sa);
+int xchk_ag_read_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 			      struct xfs_buf **agi, struct xfs_buf **agf,
 			      struct xfs_buf **agfl);
-void xfs_scrub_ag_btcur_free(struct xfs_scrub_ag *sa);
-int xfs_scrub_ag_btcur_init(struct xfs_scrub_context *sc,
-			    struct xfs_scrub_ag *sa);
-int xfs_scrub_count_rmap_ownedby_ag(struct xfs_scrub_context *sc,
+void xchk_ag_btcur_free(struct xchk_ag *sa);
+int xchk_ag_btcur_init(struct xfs_scrub_context *sc,
+			    struct xchk_ag *sa);
+int xchk_count_rmap_ownedby_ag(struct xfs_scrub_context *sc,
 				    struct xfs_btree_cur *cur,
 				    struct xfs_owner_info *oinfo,
 				    xfs_filblks_t *blocks);
 
-int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
+int xchk_setup_ag_btree(struct xfs_scrub_context *sc,
 			     struct xfs_inode *ip, bool force_log);
-int xfs_scrub_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
-int xfs_scrub_setup_inode_contents(struct xfs_scrub_context *sc,
+int xchk_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
+int xchk_setup_inode_contents(struct xfs_scrub_context *sc,
 				   struct xfs_inode *ip, unsigned int resblks);
-void xfs_scrub_buffer_recheck(struct xfs_scrub_context *sc, struct xfs_buf *bp);
+void xchk_buffer_recheck(struct xfs_scrub_context *sc, struct xfs_buf *bp);
 
 /*
  * Don't bother cross-referencing if we already found corruption or cross
  * referencing discrepancies.
  */
-static inline bool xfs_scrub_skip_xref(struct xfs_scrub_metadata *sm)
+static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 {
 	return sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
 			       XFS_SCRUB_OFLAG_XCORRUPT);
 }
 
-int xfs_scrub_metadata_inode_forks(struct xfs_scrub_context *sc);
-int xfs_scrub_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
+int xchk_metadata_inode_forks(struct xfs_scrub_context *sc);
+int xchk_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index d700c4d4d4ef..fee80f6ddfd7 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -35,8 +35,8 @@
  * operational errors in common.c.
  */
 bool
-xfs_scrub_da_process_error(
-	struct xfs_scrub_da_btree	*ds,
+xchk_da_process_error(
+	struct xchk_da_btree		*ds,
 	int				level,
 	int				*error)
 {
@@ -48,7 +48,7 @@ xfs_scrub_da_process_error(
 	switch (*error) {
 	case -EDEADLOCK:
 		/* Used to restart an op with deadlock avoidance. */
-		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
+		trace_xchk_deadlock_retry(sc->ip, sc->sm, *error);
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
@@ -57,7 +57,7 @@ xfs_scrub_da_process_error(
 		*error = 0;
 		/* fall through */
 	default:
-		trace_xfs_scrub_file_op_error(sc, ds->dargs.whichfork,
+		trace_xchk_file_op_error(sc, ds->dargs.whichfork,
 				xfs_dir2_da_to_db(ds->dargs.geo,
 					ds->state->path.blk[level].blkno),
 				*error, __return_address);
@@ -71,15 +71,15 @@ xfs_scrub_da_process_error(
  * operational errors in common.c.
  */
 void
-xfs_scrub_da_set_corrupt(
-	struct xfs_scrub_da_btree	*ds,
+xchk_da_set_corrupt(
+	struct xchk_da_btree		*ds,
 	int				level)
 {
 	struct xfs_scrub_context	*sc = ds->sc;
 
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 
-	trace_xfs_scrub_fblock_error(sc, ds->dargs.whichfork,
+	trace_xchk_fblock_error(sc, ds->dargs.whichfork,
 			xfs_dir2_da_to_db(ds->dargs.geo,
 				ds->state->path.blk[level].blkno),
 			__return_address);
@@ -87,8 +87,8 @@ xfs_scrub_da_set_corrupt(
 
 /* Find an entry at a certain level in a da btree. */
 STATIC void *
-xfs_scrub_da_btree_entry(
-	struct xfs_scrub_da_btree	*ds,
+xchk_da_btree_entry(
+	struct xchk_da_btree		*ds,
 	int				level,
 	int				rec)
 {
@@ -123,8 +123,8 @@ xfs_scrub_da_btree_entry(
 
 /* Scrub a da btree hash (key). */
 int
-xfs_scrub_da_btree_hash(
-	struct xfs_scrub_da_btree	*ds,
+xchk_da_btree_hash(
+	struct xchk_da_btree		*ds,
 	int				level,
 	__be32				*hashp)
 {
@@ -136,7 +136,7 @@ xfs_scrub_da_btree_hash(
 	/* Is this hash in order? */
 	hash = be32_to_cpu(*hashp);
 	if (hash < ds->hashes[level])
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 	ds->hashes[level] = hash;
 
 	if (level == 0)
@@ -144,10 +144,10 @@ xfs_scrub_da_btree_hash(
 
 	/* Is this hash no larger than the parent hash? */
 	blks = ds->state->path.blk;
-	entry = xfs_scrub_da_btree_entry(ds, level - 1, blks[level - 1].index);
+	entry = xchk_da_btree_entry(ds, level - 1, blks[level - 1].index);
 	parent_hash = be32_to_cpu(entry->hashval);
 	if (parent_hash < hash)
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 
 	return 0;
 }
@@ -157,13 +157,13 @@ xfs_scrub_da_btree_hash(
  * pointer.
  */
 STATIC bool
-xfs_scrub_da_btree_ptr_ok(
-	struct xfs_scrub_da_btree	*ds,
+xchk_da_btree_ptr_ok(
+	struct xchk_da_btree		*ds,
 	int				level,
 	xfs_dablk_t			blkno)
 {
 	if (blkno < ds->lowest || (ds->highest != 0 && blkno >= ds->highest)) {
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 		return false;
 	}
 
@@ -176,7 +176,7 @@ xfs_scrub_da_btree_ptr_ok(
  * leaf1, we must multiplex the verifiers.
  */
 static void
-xfs_scrub_da_btree_read_verify(
+xchk_da_btree_read_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_da_blkinfo	*info = bp->b_addr;
@@ -198,7 +198,7 @@ xfs_scrub_da_btree_read_verify(
 	}
 }
 static void
-xfs_scrub_da_btree_write_verify(
+xchk_da_btree_write_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_da_blkinfo	*info = bp->b_addr;
@@ -220,7 +220,7 @@ xfs_scrub_da_btree_write_verify(
 	}
 }
 static void *
-xfs_scrub_da_btree_verify(
+xchk_da_btree_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_da_blkinfo	*info = bp->b_addr;
@@ -236,17 +236,17 @@ xfs_scrub_da_btree_verify(
 	}
 }
 
-static const struct xfs_buf_ops xfs_scrub_da_btree_buf_ops = {
-	.name = "xfs_scrub_da_btree",
-	.verify_read = xfs_scrub_da_btree_read_verify,
-	.verify_write = xfs_scrub_da_btree_write_verify,
-	.verify_struct = xfs_scrub_da_btree_verify,
+static const struct xfs_buf_ops xchk_da_btree_buf_ops = {
+	.name = "xchk_da_btree",
+	.verify_read = xchk_da_btree_read_verify,
+	.verify_write = xchk_da_btree_write_verify,
+	.verify_struct = xchk_da_btree_verify,
 };
 
 /* Check a block's sibling. */
 STATIC int
-xfs_scrub_da_btree_block_check_sibling(
-	struct xfs_scrub_da_btree	*ds,
+xchk_da_btree_block_check_sibling(
+	struct xchk_da_btree		*ds,
 	int				level,
 	int				direction,
 	xfs_dablk_t			sibling)
@@ -265,7 +265,7 @@ xfs_scrub_da_btree_block_check_sibling(
 		error = xfs_da3_path_shift(ds->state, &ds->state->altpath,
 				direction, false, &retval);
 		if (error == 0 && retval == 0)
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 		error = 0;
 		goto out;
 	}
@@ -273,19 +273,19 @@ xfs_scrub_da_btree_block_check_sibling(
 	/* Move the alternate cursor one block in the direction given. */
 	error = xfs_da3_path_shift(ds->state, &ds->state->altpath,
 			direction, false, &retval);
-	if (!xfs_scrub_da_process_error(ds, level, &error))
+	if (!xchk_da_process_error(ds, level, &error))
 		return error;
 	if (retval) {
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 		return error;
 	}
 	if (ds->state->altpath.blk[level].bp)
-		xfs_scrub_buffer_recheck(ds->sc,
+		xchk_buffer_recheck(ds->sc,
 				ds->state->altpath.blk[level].bp);
 
 	/* Compare upper level pointer to sibling pointer. */
 	if (ds->state->altpath.blk[level].blkno != sibling)
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 	xfs_trans_brelse(ds->dargs.trans, ds->state->altpath.blk[level].bp);
 out:
 	return error;
@@ -293,8 +293,8 @@ xfs_scrub_da_btree_block_check_sibling(
 
 /* Check a block's sibling pointers. */
 STATIC int
-xfs_scrub_da_btree_block_check_siblings(
-	struct xfs_scrub_da_btree	*ds,
+xchk_da_btree_block_check_siblings(
+	struct xchk_da_btree		*ds,
 	int				level,
 	struct xfs_da_blkinfo		*hdr)
 {
@@ -308,7 +308,7 @@ xfs_scrub_da_btree_block_check_siblings(
 	/* Top level blocks should not have sibling pointers. */
 	if (level == 0) {
 		if (forw != 0 || back != 0)
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 		return 0;
 	}
 
@@ -316,10 +316,10 @@ xfs_scrub_da_btree_block_check_siblings(
 	 * Check back (left) and forw (right) pointers.  These functions
 	 * absorb error codes for us.
 	 */
-	error = xfs_scrub_da_btree_block_check_sibling(ds, level, 0, back);
+	error = xchk_da_btree_block_check_sibling(ds, level, 0, back);
 	if (error)
 		goto out;
-	error = xfs_scrub_da_btree_block_check_sibling(ds, level, 1, forw);
+	error = xchk_da_btree_block_check_sibling(ds, level, 1, forw);
 
 out:
 	memset(&ds->state->altpath, 0, sizeof(ds->state->altpath));
@@ -328,8 +328,8 @@ xfs_scrub_da_btree_block_check_siblings(
 
 /* Load a dir/attribute block from a btree. */
 STATIC int
-xfs_scrub_da_btree_block(
-	struct xfs_scrub_da_btree	*ds,
+xchk_da_btree_block(
+	struct xchk_da_btree		*ds,
 	int				level,
 	xfs_dablk_t			blkno)
 {
@@ -355,17 +355,17 @@ xfs_scrub_da_btree_block(
 
 	/* Check the pointer. */
 	blk->blkno = blkno;
-	if (!xfs_scrub_da_btree_ptr_ok(ds, level, blkno))
+	if (!xchk_da_btree_ptr_ok(ds, level, blkno))
 		goto out_nobuf;
 
 	/* Read the buffer. */
 	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno, -2,
 			&blk->bp, dargs->whichfork,
-			&xfs_scrub_da_btree_buf_ops);
-	if (!xfs_scrub_da_process_error(ds, level, &error))
+			&xchk_da_btree_buf_ops);
+	if (!xchk_da_process_error(ds, level, &error))
 		goto out_nobuf;
 	if (blk->bp)
-		xfs_scrub_buffer_recheck(ds->sc, blk->bp);
+		xchk_buffer_recheck(ds->sc, blk->bp);
 
 	/*
 	 * We didn't find a dir btree root block, which means that
@@ -378,7 +378,7 @@ xfs_scrub_da_btree_block(
 
 	/* It's /not/ ok for attr trees not to have a da btree. */
 	if (blk->bp == NULL) {
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 		goto out_nobuf;
 	}
 
@@ -388,17 +388,17 @@ xfs_scrub_da_btree_block(
 
 	/* We only started zeroing the header on v5 filesystems. */
 	if (xfs_sb_version_hascrc(&ds->sc->mp->m_sb) && hdr3->hdr.pad)
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 
 	/* Check the owner. */
 	if (xfs_sb_version_hascrc(&ip->i_mount->m_sb)) {
 		owner = be64_to_cpu(hdr3->owner);
 		if (owner != ip->i_ino)
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 	}
 
 	/* Check the siblings. */
-	error = xfs_scrub_da_btree_block_check_siblings(ds, level, &hdr3->hdr);
+	error = xchk_da_btree_block_check_siblings(ds, level, &hdr3->hdr);
 	if (error)
 		goto out;
 
@@ -411,7 +411,7 @@ xfs_scrub_da_btree_block(
 		blk->magic = XFS_ATTR_LEAF_MAGIC;
 		blk->hashval = xfs_attr_leaf_lasthash(blk->bp, pmaxrecs);
 		if (ds->tree_level != 0)
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 		break;
 	case XFS_DIR2_LEAFN_MAGIC:
 	case XFS_DIR3_LEAFN_MAGIC:
@@ -420,7 +420,7 @@ xfs_scrub_da_btree_block(
 		blk->magic = XFS_DIR2_LEAFN_MAGIC;
 		blk->hashval = xfs_dir2_leaf_lasthash(ip, blk->bp, pmaxrecs);
 		if (ds->tree_level != 0)
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 		break;
 	case XFS_DIR2_LEAF1_MAGIC:
 	case XFS_DIR3_LEAF1_MAGIC:
@@ -429,7 +429,7 @@ xfs_scrub_da_btree_block(
 		blk->magic = XFS_DIR2_LEAF1_MAGIC;
 		blk->hashval = xfs_dir2_leaf_lasthash(ip, blk->bp, pmaxrecs);
 		if (ds->tree_level != 0)
-			xfs_scrub_da_set_corrupt(ds, level);
+			xchk_da_set_corrupt(ds, level);
 		break;
 	case XFS_DA_NODE_MAGIC:
 	case XFS_DA3_NODE_MAGIC:
@@ -443,13 +443,13 @@ xfs_scrub_da_btree_block(
 		blk->hashval = be32_to_cpu(btree[*pmaxrecs - 1].hashval);
 		if (level == 0) {
 			if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
-				xfs_scrub_da_set_corrupt(ds, level);
+				xchk_da_set_corrupt(ds, level);
 				goto out_freebp;
 			}
 			ds->tree_level = nodehdr.level;
 		} else {
 			if (ds->tree_level != nodehdr.level) {
-				xfs_scrub_da_set_corrupt(ds, level);
+				xchk_da_set_corrupt(ds, level);
 				goto out_freebp;
 			}
 		}
@@ -457,7 +457,7 @@ xfs_scrub_da_btree_block(
 		/* XXX: Check hdr3.pad32 once we know how to fix it. */
 		break;
 	default:
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 		goto out_freebp;
 	}
 
@@ -473,13 +473,13 @@ xfs_scrub_da_btree_block(
 
 /* Visit all nodes and leaves of a da btree. */
 int
-xfs_scrub_da_btree(
+xchk_da_btree(
 	struct xfs_scrub_context	*sc,
 	int				whichfork,
-	xfs_scrub_da_btree_rec_fn	scrub_fn,
+	xchk_da_btree_rec_fn	scrub_fn,
 	void				*private)
 {
-	struct xfs_scrub_da_btree	ds = {};
+	struct xchk_da_btree		ds = {};
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_da_state_blk		*blks;
 	struct xfs_da_node_entry	*key;
@@ -517,7 +517,7 @@ xfs_scrub_da_btree(
 
 	/* Find the root of the da tree, if present. */
 	blks = ds.state->path.blk;
-	error = xfs_scrub_da_btree_block(&ds, level, blkno);
+	error = xchk_da_btree_block(&ds, level, blkno);
 	if (error)
 		goto out_state;
 	/*
@@ -542,12 +542,12 @@ xfs_scrub_da_btree(
 			}
 
 			/* Dispatch record scrubbing. */
-			rec = xfs_scrub_da_btree_entry(&ds, level,
+			rec = xchk_da_btree_entry(&ds, level,
 					blks[level].index);
 			error = scrub_fn(&ds, level, rec);
 			if (error)
 				break;
-			if (xfs_scrub_should_terminate(sc, &error) ||
+			if (xchk_should_terminate(sc, &error) ||
 			    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 				break;
 
@@ -566,8 +566,8 @@ xfs_scrub_da_btree(
 		}
 
 		/* Hashes in order for scrub? */
-		key = xfs_scrub_da_btree_entry(&ds, level, blks[level].index);
-		error = xfs_scrub_da_btree_hash(&ds, level, &key->hashval);
+		key = xchk_da_btree_entry(&ds, level, blks[level].index);
+		error = xchk_da_btree_hash(&ds, level, &key->hashval);
 		if (error)
 			goto out;
 
@@ -575,7 +575,7 @@ xfs_scrub_da_btree(
 		blkno = be32_to_cpu(key->before);
 		level++;
 		ds.tree_level--;
-		error = xfs_scrub_da_btree_block(&ds, level, blkno);
+		error = xchk_da_btree_block(&ds, level, blkno);
 		if (error)
 			goto out;
 		if (blks[level].bp == NULL)
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index 365f9f0019e6..80e4af0e2589 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -8,7 +8,7 @@
 
 /* dir/attr btree */
 
-struct xfs_scrub_da_btree {
+struct xchk_da_btree {
 	struct xfs_da_args		dargs;
 	xfs_dahash_t			hashes[XFS_DA_NODE_MAXDEPTH];
 	int				maxrecs[XFS_DA_NODE_MAXDEPTH];
@@ -28,18 +28,18 @@ struct xfs_scrub_da_btree {
 	int				tree_level;
 };
 
-typedef int (*xfs_scrub_da_btree_rec_fn)(struct xfs_scrub_da_btree *ds,
+typedef int (*xchk_da_btree_rec_fn)(struct xchk_da_btree *ds,
 		int level, void *rec);
 
 /* Check for da btree operation errors. */
-bool xfs_scrub_da_process_error(struct xfs_scrub_da_btree *ds, int level, int *error);
+bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 
 /* Check for da btree corruption. */
-void xfs_scrub_da_set_corrupt(struct xfs_scrub_da_btree *ds, int level);
+void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
 
-int xfs_scrub_da_btree_hash(struct xfs_scrub_da_btree *ds, int level,
+int xchk_da_btree_hash(struct xchk_da_btree *ds, int level,
 			    __be32 *hashp);
-int xfs_scrub_da_btree(struct xfs_scrub_context *sc, int whichfork,
-		       xfs_scrub_da_btree_rec_fn scrub_fn, void *private);
+int xchk_da_btree(struct xfs_scrub_context *sc, int whichfork,
+		       xchk_da_btree_rec_fn scrub_fn, void *private);
 
 #endif /* __XFS_SCRUB_DABTREE_H__ */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 86324775fc9b..2ac07bb73478 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -31,18 +31,18 @@
 
 /* Set us up to scrub directories. */
 int
-xfs_scrub_setup_directory(
+xchk_setup_directory(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	return xfs_scrub_setup_inode_contents(sc, ip, 0);
+	return xchk_setup_inode_contents(sc, ip, 0);
 }
 
 /* Directories */
 
 /* Scrub a directory entry. */
 
-struct xfs_scrub_dir_ctx {
+struct xchk_dir_ctx {
 	/* VFS fill-directory iterator */
 	struct dir_context		dir_iter;
 
@@ -51,8 +51,8 @@ struct xfs_scrub_dir_ctx {
 
 /* Check that an inode's mode matches a given DT_ type. */
 STATIC int
-xfs_scrub_dir_check_ftype(
-	struct xfs_scrub_dir_ctx	*sdc,
+xchk_dir_check_ftype(
+	struct xchk_dir_ctx		*sdc,
 	xfs_fileoff_t			offset,
 	xfs_ino_t			inum,
 	int				dtype)
@@ -64,7 +64,7 @@ xfs_scrub_dir_check_ftype(
 
 	if (!xfs_sb_version_hasftype(&mp->m_sb)) {
 		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
-			xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
+			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
 		goto out;
 	}
@@ -78,7 +78,7 @@ xfs_scrub_dir_check_ftype(
 	 * inodes can trigger immediate inactive cleanup of the inode.
 	 */
 	error = xfs_iget(mp, sdc->sc->tp, inum, 0, 0, &ip);
-	if (!xfs_scrub_fblock_xref_process_error(sdc->sc, XFS_DATA_FORK, offset,
+	if (!xchk_fblock_xref_process_error(sdc->sc, XFS_DATA_FORK, offset,
 			&error))
 		goto out;
 
@@ -86,7 +86,7 @@ xfs_scrub_dir_check_ftype(
 	ino_dtype = xfs_dir3_get_dtype(mp,
 			xfs_mode_to_ftype(VFS_I(ip)->i_mode));
 	if (ino_dtype != dtype)
-		xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
 	iput(VFS_I(ip));
 out:
 	return error;
@@ -101,7 +101,7 @@ xfs_scrub_dir_check_ftype(
  * we can look up this filename.  Finally, we check the ftype.
  */
 STATIC int
-xfs_scrub_dir_actor(
+xchk_dir_actor(
 	struct dir_context		*dir_iter,
 	const char			*name,
 	int				namelen,
@@ -111,13 +111,13 @@ xfs_scrub_dir_actor(
 {
 	struct xfs_mount		*mp;
 	struct xfs_inode		*ip;
-	struct xfs_scrub_dir_ctx	*sdc;
+	struct xchk_dir_ctx		*sdc;
 	struct xfs_name			xname;
 	xfs_ino_t			lookup_ino;
 	xfs_dablk_t			offset;
 	int				error = 0;
 
-	sdc = container_of(dir_iter, struct xfs_scrub_dir_ctx, dir_iter);
+	sdc = container_of(dir_iter, struct xchk_dir_ctx, dir_iter);
 	ip = sdc->sc->ip;
 	mp = ip->i_mount;
 	offset = xfs_dir2_db_to_da(mp->m_dir_geo,
@@ -125,17 +125,17 @@ xfs_scrub_dir_actor(
 
 	/* Does this inode number make sense? */
 	if (!xfs_verify_dir_ino(mp, ino)) {
-		xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
 		goto out;
 	}
 
 	if (!strncmp(".", name, namelen)) {
 		/* If this is "." then check that the inum matches the dir. */
 		if (xfs_sb_version_hasftype(&mp->m_sb) && type != DT_DIR)
-			xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
+			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
 		if (ino != ip->i_ino)
-			xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
+			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
 	} else if (!strncmp("..", name, namelen)) {
 		/*
@@ -143,10 +143,10 @@ xfs_scrub_dir_actor(
 		 * matches this dir.
 		 */
 		if (xfs_sb_version_hasftype(&mp->m_sb) && type != DT_DIR)
-			xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
+			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
 		if (ip->i_ino == mp->m_sb.sb_rootino && ino != ip->i_ino)
-			xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
+			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
 					offset);
 	}
 
@@ -156,23 +156,23 @@ xfs_scrub_dir_actor(
 	xname.type = XFS_DIR3_FT_UNKNOWN;
 
 	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
-	if (!xfs_scrub_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
+	if (!xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
 			&error))
 		goto out;
 	if (lookup_ino != ino) {
-		xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
 		goto out;
 	}
 
 	/* Verify the file type.  This function absorbs error codes. */
-	error = xfs_scrub_dir_check_ftype(sdc, offset, lookup_ino, type);
+	error = xchk_dir_check_ftype(sdc, offset, lookup_ino, type);
 	if (error)
 		goto out;
 out:
 	/*
 	 * A negative error code returned here is supposed to cause the
 	 * dir_emit caller (xfs_readdir) to abort the directory iteration
-	 * and return zero to xfs_scrub_directory.
+	 * and return zero to xchk_directory.
 	 */
 	if (error == 0 && sdc->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return -EFSCORRUPTED;
@@ -181,8 +181,8 @@ xfs_scrub_dir_actor(
 
 /* Scrub a directory btree record. */
 STATIC int
-xfs_scrub_dir_rec(
-	struct xfs_scrub_da_btree	*ds,
+xchk_dir_rec(
+	struct xchk_da_btree		*ds,
 	int				level,
 	void				*rec)
 {
@@ -203,7 +203,7 @@ xfs_scrub_dir_rec(
 	int				error;
 
 	/* Check the hash of the entry. */
-	error = xfs_scrub_da_btree_hash(ds, level, &ent->hashval);
+	error = xchk_da_btree_hash(ds, level, &ent->hashval);
 	if (error)
 		goto out;
 
@@ -218,18 +218,18 @@ xfs_scrub_dir_rec(
 	rec_bno = xfs_dir2_db_to_da(mp->m_dir_geo, db);
 
 	if (rec_bno >= mp->m_dir_geo->leafblk) {
-		xfs_scrub_da_set_corrupt(ds, level);
+		xchk_da_set_corrupt(ds, level);
 		goto out;
 	}
 	error = xfs_dir3_data_read(ds->dargs.trans, dp, rec_bno, -2, &bp);
-	if (!xfs_scrub_fblock_process_error(ds->sc, XFS_DATA_FORK, rec_bno,
+	if (!xchk_fblock_process_error(ds->sc, XFS_DATA_FORK, rec_bno,
 			&error))
 		goto out;
 	if (!bp) {
-		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out;
 	}
-	xfs_scrub_buffer_recheck(ds->sc, bp);
+	xchk_buffer_recheck(ds->sc, bp);
 
 	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out_relse;
@@ -240,7 +240,7 @@ xfs_scrub_dir_rec(
 	p = (char *)mp->m_dir_inode_ops->data_entry_p(bp->b_addr);
 	endp = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
 	if (!endp) {
-		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
 	while (p < endp) {
@@ -258,7 +258,7 @@ xfs_scrub_dir_rec(
 		p += mp->m_dir_inode_ops->data_entsize(dep->namelen);
 	}
 	if (p >= endp) {
-		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
 
@@ -267,14 +267,14 @@ xfs_scrub_dir_rec(
 	hash = be32_to_cpu(ent->hashval);
 	tag = be16_to_cpup(dp->d_ops->data_entry_tag_p(dent));
 	if (!xfs_verify_dir_ino(mp, ino) || tag != off)
-		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 	if (dent->namelen == 0) {
-		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
 	calc_hash = xfs_da_hashname(dent->name, dent->namelen);
 	if (calc_hash != hash)
-		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 
 out_relse:
 	xfs_trans_brelse(ds->dargs.trans, bp);
@@ -288,7 +288,7 @@ xfs_scrub_dir_rec(
  * shortest, and that there aren't any bogus entries.
  */
 STATIC void
-xfs_scrub_directory_check_free_entry(
+xchk_directory_check_free_entry(
 	struct xfs_scrub_context	*sc,
 	xfs_dablk_t			lblk,
 	struct xfs_dir2_data_free	*bf,
@@ -308,12 +308,12 @@ xfs_scrub_directory_check_free_entry(
 			return;
 
 	/* Unused entry should be in the bestfrees but wasn't found. */
-	xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+	xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 }
 
 /* Check free space info in a directory data block. */
 STATIC int
-xfs_scrub_directory_data_bestfree(
+xchk_directory_data_bestfree(
 	struct xfs_scrub_context	*sc,
 	xfs_dablk_t			lblk,
 	bool				is_block)
@@ -339,15 +339,15 @@ xfs_scrub_directory_data_bestfree(
 	if (is_block) {
 		/* dir block format */
 		if (lblk != XFS_B_TO_FSBT(mp, XFS_DIR2_DATA_OFFSET))
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
 	} else {
 		/* dir data format */
 		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, -1, &bp);
 	}
-	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
-	xfs_scrub_buffer_recheck(sc, bp);
+	xchk_buffer_recheck(sc, bp);
 
 	/* XXX: Check xfs_dir3_data_hdr.pad is zero once we start setting it. */
 
@@ -362,7 +362,7 @@ xfs_scrub_directory_data_bestfree(
 		if (offset == 0)
 			continue;
 		if (offset >= mp->m_dir_geo->blksize) {
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out_buf;
 		}
 		dup = (struct xfs_dir2_data_unused *)(bp->b_addr + offset);
@@ -372,13 +372,13 @@ xfs_scrub_directory_data_bestfree(
 		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG) ||
 		    be16_to_cpu(dup->length) != be16_to_cpu(dfp->length) ||
 		    tag != ((char *)dup - (char *)bp->b_addr)) {
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out_buf;
 		}
 
 		/* bestfree records should be ordered largest to smallest */
 		if (smallest_bestfree < be16_to_cpu(dfp->length)) {
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out_buf;
 		}
 
@@ -400,7 +400,7 @@ xfs_scrub_directory_data_bestfree(
 			dep = (struct xfs_dir2_data_entry *)ptr;
 			newlen = d_ops->data_entsize(dep->namelen);
 			if (newlen <= 0) {
-				xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
+				xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
 						lblk);
 				goto out_buf;
 			}
@@ -411,7 +411,7 @@ xfs_scrub_directory_data_bestfree(
 		/* Spot check this free entry */
 		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
 		if (tag != ((char *)dup - (char *)bp->b_addr)) {
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out_buf;
 		}
 
@@ -419,14 +419,14 @@ xfs_scrub_directory_data_bestfree(
 		 * Either this entry is a bestfree or it's smaller than
 		 * any of the bestfrees.
 		 */
-		xfs_scrub_directory_check_free_entry(sc, lblk, bf, dup);
+		xchk_directory_check_free_entry(sc, lblk, bf, dup);
 		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 			goto out_buf;
 
 		/* Move on. */
 		newlen = be16_to_cpu(dup->length);
 		if (newlen <= 0) {
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out_buf;
 		}
 		ptr += newlen;
@@ -436,11 +436,11 @@ xfs_scrub_directory_data_bestfree(
 
 	/* We're required to fill all the space. */
 	if (ptr != endptr)
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 
 	/* Did we see at least as many free slots as there are bestfrees? */
 	if (nr_frees < nr_bestfrees)
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 out_buf:
 	xfs_trans_brelse(sc->tp, bp);
 out:
@@ -454,7 +454,7 @@ xfs_scrub_directory_data_bestfree(
  * array is in order.
  */
 STATIC void
-xfs_scrub_directory_check_freesp(
+xchk_directory_check_freesp(
 	struct xfs_scrub_context	*sc,
 	xfs_dablk_t			lblk,
 	struct xfs_buf			*dbp,
@@ -465,15 +465,15 @@ xfs_scrub_directory_check_freesp(
 	dfp = sc->ip->d_ops->data_bestfree_p(dbp->b_addr);
 
 	if (len != be16_to_cpu(dfp->length))
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 
 	if (len > 0 && be16_to_cpu(dfp->offset) == 0)
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 }
 
 /* Check free space info in a directory leaf1 block. */
 STATIC int
-xfs_scrub_directory_leaf1_bestfree(
+xchk_directory_leaf1_bestfree(
 	struct xfs_scrub_context	*sc,
 	struct xfs_da_args		*args,
 	xfs_dablk_t			lblk)
@@ -497,9 +497,9 @@ xfs_scrub_directory_leaf1_bestfree(
 
 	/* Read the free space block. */
 	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
-	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
-	xfs_scrub_buffer_recheck(sc, bp);
+	xchk_buffer_recheck(sc, bp);
 
 	leaf = bp->b_addr;
 	d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
@@ -512,7 +512,7 @@ xfs_scrub_directory_leaf1_bestfree(
 		struct xfs_dir3_leaf_hdr	*hdr3 = bp->b_addr;
 
 		if (hdr3->pad != cpu_to_be32(0))
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 	}
 
 	/*
@@ -520,19 +520,19 @@ xfs_scrub_directory_leaf1_bestfree(
 	 * blocks that can fit under i_size.
 	 */
 	if (bestcount != xfs_dir2_byte_to_db(geo, sc->ip->i_d.di_size)) {
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 		goto out;
 	}
 
 	/* Is the leaf count even remotely sane? */
 	if (leafhdr.count > d_ops->leaf_max_ents(geo)) {
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 		goto out;
 	}
 
 	/* Leaves and bests don't overlap in leaf format. */
 	if ((char *)&ents[leafhdr.count] > (char *)bestp) {
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 		goto out;
 	}
 
@@ -540,13 +540,13 @@ xfs_scrub_directory_leaf1_bestfree(
 	for (i = 0; i < leafhdr.count; i++) {
 		hash = be32_to_cpu(ents[i].hashval);
 		if (i > 0 && lasthash > hash)
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 		lasthash = hash;
 		if (ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			stale++;
 	}
 	if (leafhdr.stale != stale)
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 
@@ -557,10 +557,10 @@ xfs_scrub_directory_leaf1_bestfree(
 			continue;
 		error = xfs_dir3_data_read(sc->tp, sc->ip,
 				i * args->geo->fsbcount, -1, &dbp);
-		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk,
+		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
 				&error))
 			break;
-		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
+		xchk_directory_check_freesp(sc, lblk, dbp, best);
 		xfs_trans_brelse(sc->tp, dbp);
 		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 			goto out;
@@ -571,7 +571,7 @@ xfs_scrub_directory_leaf1_bestfree(
 
 /* Check free space info in a directory freespace block. */
 STATIC int
-xfs_scrub_directory_free_bestfree(
+xchk_directory_free_bestfree(
 	struct xfs_scrub_context	*sc,
 	struct xfs_da_args		*args,
 	xfs_dablk_t			lblk)
@@ -587,15 +587,15 @@ xfs_scrub_directory_free_bestfree(
 
 	/* Read the free space block */
 	error = xfs_dir2_free_read(sc->tp, sc->ip, lblk, &bp);
-	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
-	xfs_scrub_buffer_recheck(sc, bp);
+	xchk_buffer_recheck(sc, bp);
 
 	if (xfs_sb_version_hascrc(&sc->mp->m_sb)) {
 		struct xfs_dir3_free_hdr	*hdr3 = bp->b_addr;
 
 		if (hdr3->pad != cpu_to_be32(0))
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 	}
 
 	/* Check all the entries. */
@@ -610,22 +610,22 @@ xfs_scrub_directory_free_bestfree(
 		error = xfs_dir3_data_read(sc->tp, sc->ip,
 				(freehdr.firstdb + i) * args->geo->fsbcount,
 				-1, &dbp);
-		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk,
+		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
 				&error))
 			break;
-		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
+		xchk_directory_check_freesp(sc, lblk, dbp, best);
 		xfs_trans_brelse(sc->tp, dbp);
 	}
 
 	if (freehdr.nused + stale != freehdr.nvalid)
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 out:
 	return error;
 }
 
 /* Check free space information in directories. */
 STATIC int
-xfs_scrub_directory_blocks(
+xchk_directory_blocks(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_bmbt_irec		got;
@@ -656,7 +656,7 @@ xfs_scrub_directory_blocks(
 	args.geo = mp->m_dir_geo;
 	args.trans = sc->tp;
 	error = xfs_dir2_isblock(&args, &is_block);
-	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
 
 	/* Iterate all the data extents in the directory... */
@@ -666,7 +666,7 @@ xfs_scrub_directory_blocks(
 		if (is_block &&
 		    (got.br_startoff > 0 ||
 		     got.br_blockcount != args.geo->fsbcount)) {
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
 					got.br_startoff);
 			break;
 		}
@@ -690,7 +690,7 @@ xfs_scrub_directory_blocks(
 				args.geo->fsbcount);
 		     lblk < got.br_startoff + got.br_blockcount;
 		     lblk += args.geo->fsbcount) {
-			error = xfs_scrub_directory_data_bestfree(sc, lblk,
+			error = xchk_directory_data_bestfree(sc, lblk,
 					is_block);
 			if (error)
 				goto out;
@@ -709,10 +709,10 @@ xfs_scrub_directory_blocks(
 	    got.br_blockcount == args.geo->fsbcount &&
 	    !xfs_iext_next_extent(ifp, &icur, &got)) {
 		if (is_block) {
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out;
 		}
-		error = xfs_scrub_directory_leaf1_bestfree(sc, &args,
+		error = xchk_directory_leaf1_bestfree(sc, &args,
 				leaf_lblk);
 		if (error)
 			goto out;
@@ -731,11 +731,11 @@ xfs_scrub_directory_blocks(
 		 */
 		lblk = got.br_startoff;
 		if (lblk & ~0xFFFFFFFFULL) {
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out;
 		}
 		if (is_block) {
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out;
 		}
 
@@ -754,7 +754,7 @@ xfs_scrub_directory_blocks(
 				args.geo->fsbcount);
 		     lblk < got.br_startoff + got.br_blockcount;
 		     lblk += args.geo->fsbcount) {
-			error = xfs_scrub_directory_free_bestfree(sc, &args,
+			error = xchk_directory_free_bestfree(sc, &args,
 					lblk);
 			if (error)
 				goto out;
@@ -769,11 +769,11 @@ xfs_scrub_directory_blocks(
 
 /* Scrub a whole directory. */
 int
-xfs_scrub_directory(
+xchk_directory(
 	struct xfs_scrub_context	*sc)
 {
-	struct xfs_scrub_dir_ctx	sdc = {
-		.dir_iter.actor = xfs_scrub_dir_actor,
+	struct xchk_dir_ctx		sdc = {
+		.dir_iter.actor = xchk_dir_actor,
 		.dir_iter.pos = 0,
 		.sc = sc,
 	};
@@ -786,12 +786,12 @@ xfs_scrub_directory(
 
 	/* Plausible size? */
 	if (sc->ip->i_d.di_size < xfs_dir2_sf_hdr_size(0)) {
-		xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		goto out;
 	}
 
 	/* Check directory tree structure */
-	error = xfs_scrub_da_btree(sc, XFS_DATA_FORK, xfs_scrub_dir_rec, NULL);
+	error = xchk_da_btree(sc, XFS_DATA_FORK, xchk_dir_rec, NULL);
 	if (error)
 		return error;
 
@@ -799,7 +799,7 @@ xfs_scrub_directory(
 		return error;
 
 	/* Check the freespace. */
-	error = xfs_scrub_directory_blocks(sc);
+	error = xchk_directory_blocks(sc);
 	if (error)
 		return error;
 
@@ -816,7 +816,7 @@ xfs_scrub_directory(
 	/*
 	 * Look up every name in this directory by hash.
 	 *
-	 * Use the xfs_readdir function to call xfs_scrub_dir_actor on
+	 * Use the xfs_readdir function to call xchk_dir_actor on
 	 * every directory entry in this directory.  In _actor, we check
 	 * the name, inode number, and ftype (if applicable) of the
 	 * entry.  xfs_readdir uses the VFS filldir functions to provide
@@ -834,7 +834,7 @@ xfs_scrub_directory(
 	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
 	while (true) {
 		error = xfs_readdir(sc->tp, sc->ip, &sdc.dir_iter, bufsize);
-		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0,
+		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0,
 				&error))
 			goto out;
 		if (oldpos == sdc.dir_iter.pos)
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 13d43d108574..69d652b7299c 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -35,11 +35,11 @@
  * try again after forcing logged inode cores out to disk.
  */
 int
-xfs_scrub_setup_ag_iallocbt(
+xchk_setup_ag_iallocbt(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	return xfs_scrub_setup_ag_btree(sc, ip, sc->try_harder);
+	return xchk_setup_ag_btree(sc, ip, sc->try_harder);
 }
 
 /* Inode btree scrubber. */
@@ -50,7 +50,7 @@ xfs_scrub_setup_ag_iallocbt(
  * we have a record or not depending on freecount.
  */
 static inline void
-xfs_scrub_iallocbt_chunk_xref_other(
+xchk_iallocbt_chunk_xref_other(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inobt_rec_incore	*irec,
 	xfs_agino_t			agino)
@@ -66,16 +66,16 @@ xfs_scrub_iallocbt_chunk_xref_other(
 	if (!(*pcur))
 		return;
 	error = xfs_ialloc_has_inode_record(*pcur, agino, agino, &has_irec);
-	if (!xfs_scrub_should_check_xref(sc, &error, pcur))
+	if (!xchk_should_check_xref(sc, &error, pcur))
 		return;
 	if (((irec->ir_freecount > 0 && !has_irec) ||
 	     (irec->ir_freecount == 0 && has_irec)))
-		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+		xchk_btree_xref_set_corrupt(sc, *pcur, 0);
 }
 
 /* Cross-reference with the other btrees. */
 STATIC void
-xfs_scrub_iallocbt_chunk_xref(
+xchk_iallocbt_chunk_xref(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inobt_rec_incore	*irec,
 	xfs_agino_t			agino,
@@ -87,17 +87,17 @@ xfs_scrub_iallocbt_chunk_xref(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
-	xfs_scrub_xref_is_used_space(sc, agbno, len);
-	xfs_scrub_iallocbt_chunk_xref_other(sc, irec, agino);
+	xchk_xref_is_used_space(sc, agbno, len);
+	xchk_iallocbt_chunk_xref_other(sc, irec, agino);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
-	xfs_scrub_xref_is_owned_by(sc, agbno, len, &oinfo);
-	xfs_scrub_xref_is_not_shared(sc, agbno, len);
+	xchk_xref_is_owned_by(sc, agbno, len, &oinfo);
+	xchk_xref_is_not_shared(sc, agbno, len);
 }
 
 /* Is this chunk worth checking? */
 STATIC bool
-xfs_scrub_iallocbt_chunk(
-	struct xfs_scrub_btree		*bs,
+xchk_iallocbt_chunk(
+	struct xchk_btree		*bs,
 	struct xfs_inobt_rec_incore	*irec,
 	xfs_agino_t			agino,
 	xfs_extlen_t			len)
@@ -110,16 +110,16 @@ xfs_scrub_iallocbt_chunk(
 	if (bno + len <= bno ||
 	    !xfs_verify_agbno(mp, agno, bno) ||
 	    !xfs_verify_agbno(mp, agno, bno + len - 1))
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
-	xfs_scrub_iallocbt_chunk_xref(bs->sc, irec, agino, bno, len);
+	xchk_iallocbt_chunk_xref(bs->sc, irec, agino, bno, len);
 
 	return true;
 }
 
 /* Count the number of free inodes. */
 static unsigned int
-xfs_scrub_iallocbt_freecount(
+xchk_iallocbt_freecount(
 	xfs_inofree_t			freemask)
 {
 	BUILD_BUG_ON(sizeof(freemask) != sizeof(__u64));
@@ -128,8 +128,8 @@ xfs_scrub_iallocbt_freecount(
 
 /* Check a particular inode with ir_free. */
 STATIC int
-xfs_scrub_iallocbt_check_cluster_freemask(
-	struct xfs_scrub_btree		*bs,
+xchk_iallocbt_check_cluster_freemask(
+	struct xchk_btree		*bs,
 	xfs_ino_t			fsino,
 	xfs_agino_t			chunkino,
 	xfs_agino_t			clusterino,
@@ -143,14 +143,14 @@ xfs_scrub_iallocbt_check_cluster_freemask(
 	bool				inuse;
 	int				error = 0;
 
-	if (xfs_scrub_should_terminate(bs->sc, &error))
+	if (xchk_should_terminate(bs->sc, &error))
 		return error;
 
 	dip = xfs_buf_offset(bp, clusterino * mp->m_sb.sb_inodesize);
 	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC ||
 	    (dip->di_version >= 3 &&
 	     be64_to_cpu(dip->di_ino) != fsino + clusterino)) {
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		goto out;
 	}
 
@@ -175,15 +175,15 @@ xfs_scrub_iallocbt_check_cluster_freemask(
 		freemask_ok = inode_is_free ^ inuse;
 	}
 	if (!freemask_ok)
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 out:
 	return 0;
 }
 
 /* Make sure the free mask is consistent with what the inodes think. */
 STATIC int
-xfs_scrub_iallocbt_check_freemask(
-	struct xfs_scrub_btree		*bs,
+xchk_iallocbt_check_freemask(
+	struct xchk_btree		*bs,
 	struct xfs_inobt_rec_incore	*irec)
 {
 	struct xfs_owner_info		oinfo;
@@ -223,18 +223,18 @@ xfs_scrub_iallocbt_check_freemask(
 		/* The whole cluster must be a hole or not a hole. */
 		ir_holemask = (irec->ir_holemask & holemask);
 		if (ir_holemask != holemask && ir_holemask != 0) {
-			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 			continue;
 		}
 
 		/* If any part of this is a hole, skip it. */
 		if (ir_holemask) {
-			xfs_scrub_xref_is_not_owned_by(bs->sc, agbno,
+			xchk_xref_is_not_owned_by(bs->sc, agbno,
 					blks_per_cluster, &oinfo);
 			continue;
 		}
 
-		xfs_scrub_xref_is_owned_by(bs->sc, agbno, blks_per_cluster,
+		xchk_xref_is_owned_by(bs->sc, agbno, blks_per_cluster,
 				&oinfo);
 
 		/* Grab the inode cluster buffer. */
@@ -245,13 +245,13 @@ xfs_scrub_iallocbt_check_freemask(
 
 		error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap,
 				&dip, &bp, 0, 0);
-		if (!xfs_scrub_btree_xref_process_error(bs->sc, bs->cur, 0,
+		if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0,
 				&error))
 			continue;
 
 		/* Which inodes are free? */
 		for (clusterino = 0; clusterino < nr_inodes; clusterino++) {
-			error = xfs_scrub_iallocbt_check_cluster_freemask(bs,
+			error = xchk_iallocbt_check_cluster_freemask(bs,
 					fsino, chunkino, clusterino, irec, bp);
 			if (error) {
 				xfs_trans_brelse(bs->cur->bc_tp, bp);
@@ -267,8 +267,8 @@ xfs_scrub_iallocbt_check_freemask(
 
 /* Scrub an inobt/finobt record. */
 STATIC int
-xfs_scrub_iallocbt_rec(
-	struct xfs_scrub_btree		*bs,
+xchk_iallocbt_rec(
+	struct xchk_btree		*bs,
 	union xfs_btree_rec		*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
@@ -289,18 +289,18 @@ xfs_scrub_iallocbt_rec(
 
 	if (irec.ir_count > XFS_INODES_PER_CHUNK ||
 	    irec.ir_freecount > XFS_INODES_PER_CHUNK)
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	real_freecount = irec.ir_freecount +
 			(XFS_INODES_PER_CHUNK - irec.ir_count);
-	if (real_freecount != xfs_scrub_iallocbt_freecount(irec.ir_free))
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+	if (real_freecount != xchk_iallocbt_freecount(irec.ir_free))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	agino = irec.ir_startino;
 	/* Record has to be properly aligned within the AG. */
 	if (!xfs_verify_agino(mp, agno, agino) ||
 	    !xfs_verify_agino(mp, agno, agino + XFS_INODES_PER_CHUNK - 1)) {
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		goto out;
 	}
 
@@ -308,7 +308,7 @@ xfs_scrub_iallocbt_rec(
 	agbno = XFS_AGINO_TO_AGBNO(mp, irec.ir_startino);
 	if ((agbno & (xfs_ialloc_cluster_alignment(mp) - 1)) ||
 	    (agbno & (xfs_icluster_size_fsb(mp) - 1)))
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	*inode_blocks += XFS_B_TO_FSB(mp,
 			irec.ir_count * mp->m_sb.sb_inodesize);
@@ -318,9 +318,9 @@ xfs_scrub_iallocbt_rec(
 		len = XFS_B_TO_FSB(mp,
 				XFS_INODES_PER_CHUNK * mp->m_sb.sb_inodesize);
 		if (irec.ir_count != XFS_INODES_PER_CHUNK)
-			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
-		if (!xfs_scrub_iallocbt_chunk(bs, &irec, agino, len))
+		if (!xchk_iallocbt_chunk(bs, &irec, agino, len))
 			goto out;
 		goto check_freemask;
 	}
@@ -333,12 +333,12 @@ xfs_scrub_iallocbt_rec(
 	holes = ~xfs_inobt_irec_to_allocmask(&irec);
 	if ((holes & irec.ir_free) != holes ||
 	    irec.ir_freecount > irec.ir_count)
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	for (i = 0; i < XFS_INOBT_HOLEMASK_BITS; i++) {
 		if (holemask & 1)
 			holecount += XFS_INODES_PER_HOLEMASK_BIT;
-		else if (!xfs_scrub_iallocbt_chunk(bs, &irec, agino, len))
+		else if (!xchk_iallocbt_chunk(bs, &irec, agino, len))
 			break;
 		holemask >>= 1;
 		agino += XFS_INODES_PER_HOLEMASK_BIT;
@@ -346,10 +346,10 @@ xfs_scrub_iallocbt_rec(
 
 	if (holecount > XFS_INODES_PER_CHUNK ||
 	    holecount + irec.ir_count != XFS_INODES_PER_CHUNK)
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 check_freemask:
-	error = xfs_scrub_iallocbt_check_freemask(bs, &irec);
+	error = xchk_iallocbt_check_freemask(bs, &irec);
 	if (error)
 		goto out;
 
@@ -362,7 +362,7 @@ xfs_scrub_iallocbt_rec(
  * Don't bother if we're missing btree cursors, as we're already corrupt.
  */
 STATIC void
-xfs_scrub_iallocbt_xref_rmap_btreeblks(
+xchk_iallocbt_xref_rmap_btreeblks(
 	struct xfs_scrub_context	*sc,
 	int				which)
 {
@@ -374,27 +374,27 @@ xfs_scrub_iallocbt_xref_rmap_btreeblks(
 
 	if (!sc->sa.ino_cur || !sc->sa.rmap_cur ||
 	    (xfs_sb_version_hasfinobt(&sc->mp->m_sb) && !sc->sa.fino_cur) ||
-	    xfs_scrub_skip_xref(sc->sm))
+	    xchk_skip_xref(sc->sm))
 		return;
 
 	/* Check that we saw as many inobt blocks as the rmap says. */
 	error = xfs_btree_count_blocks(sc->sa.ino_cur, &inobt_blocks);
-	if (!xfs_scrub_process_error(sc, 0, 0, &error))
+	if (!xchk_process_error(sc, 0, 0, &error))
 		return;
 
 	if (sc->sa.fino_cur) {
 		error = xfs_btree_count_blocks(sc->sa.fino_cur, &finobt_blocks);
-		if (!xfs_scrub_process_error(sc, 0, 0, &error))
+		if (!xchk_process_error(sc, 0, 0, &error))
 			return;
 	}
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
-	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
 			&blocks);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
 	if (blocks != inobt_blocks + finobt_blocks)
-		xfs_scrub_btree_set_corrupt(sc, sc->sa.ino_cur, 0);
+		xchk_btree_set_corrupt(sc, sc->sa.ino_cur, 0);
 }
 
 /*
@@ -402,7 +402,7 @@ xfs_scrub_iallocbt_xref_rmap_btreeblks(
  * the rmap says are owned by inodes.
  */
 STATIC void
-xfs_scrub_iallocbt_xref_rmap_inodes(
+xchk_iallocbt_xref_rmap_inodes(
 	struct xfs_scrub_context	*sc,
 	int				which,
 	xfs_filblks_t			inode_blocks)
@@ -411,22 +411,22 @@ xfs_scrub_iallocbt_xref_rmap_inodes(
 	xfs_filblks_t			blocks;
 	int				error;
 
-	if (!sc->sa.rmap_cur || xfs_scrub_skip_xref(sc->sm))
+	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
 		return;
 
 	/* Check that we saw as many inode blocks as the rmap knows about. */
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
-	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
 			&blocks);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
 	if (blocks != inode_blocks)
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 }
 
 /* Scrub the inode btrees for some AG. */
 STATIC int
-xfs_scrub_iallocbt(
+xchk_iallocbt(
 	struct xfs_scrub_context	*sc,
 	xfs_btnum_t			which)
 {
@@ -437,12 +437,12 @@ xfs_scrub_iallocbt(
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
 	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
-	error = xfs_scrub_btree(sc, cur, xfs_scrub_iallocbt_rec, &oinfo,
+	error = xchk_btree(sc, cur, xchk_iallocbt_rec, &oinfo,
 			&inode_blocks);
 	if (error)
 		return error;
 
-	xfs_scrub_iallocbt_xref_rmap_btreeblks(sc, which);
+	xchk_iallocbt_xref_rmap_btreeblks(sc, which);
 
 	/*
 	 * If we're scrubbing the inode btree, inode_blocks is the number of
@@ -452,28 +452,28 @@ xfs_scrub_iallocbt(
 	 * to inode chunks with free inodes.
 	 */
 	if (which == XFS_BTNUM_INO)
-		xfs_scrub_iallocbt_xref_rmap_inodes(sc, which, inode_blocks);
+		xchk_iallocbt_xref_rmap_inodes(sc, which, inode_blocks);
 
 	return error;
 }
 
 int
-xfs_scrub_inobt(
+xchk_inobt(
 	struct xfs_scrub_context	*sc)
 {
-	return xfs_scrub_iallocbt(sc, XFS_BTNUM_INO);
+	return xchk_iallocbt(sc, XFS_BTNUM_INO);
 }
 
 int
-xfs_scrub_finobt(
+xchk_finobt(
 	struct xfs_scrub_context	*sc)
 {
-	return xfs_scrub_iallocbt(sc, XFS_BTNUM_FINO);
+	return xchk_iallocbt(sc, XFS_BTNUM_FINO);
 }
 
 /* See if an inode btree has (or doesn't have) an inode chunk record. */
 static inline void
-xfs_scrub_xref_inode_check(
+xchk_xref_inode_check(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len,
@@ -483,33 +483,33 @@ xfs_scrub_xref_inode_check(
 	bool				has_inodes;
 	int				error;
 
-	if (!(*icur) || xfs_scrub_skip_xref(sc->sm))
+	if (!(*icur) || xchk_skip_xref(sc->sm))
 		return;
 
 	error = xfs_ialloc_has_inodes_at_extent(*icur, agbno, len, &has_inodes);
-	if (!xfs_scrub_should_check_xref(sc, &error, icur))
+	if (!xchk_should_check_xref(sc, &error, icur))
 		return;
 	if (has_inodes != should_have_inodes)
-		xfs_scrub_btree_xref_set_corrupt(sc, *icur, 0);
+		xchk_btree_xref_set_corrupt(sc, *icur, 0);
 }
 
 /* xref check that the extent is not covered by inodes */
 void
-xfs_scrub_xref_is_not_inode_chunk(
+xchk_xref_is_not_inode_chunk(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
-	xfs_scrub_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur, false);
-	xfs_scrub_xref_inode_check(sc, agbno, len, &sc->sa.fino_cur, false);
+	xchk_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur, false);
+	xchk_xref_inode_check(sc, agbno, len, &sc->sa.fino_cur, false);
 }
 
 /* xref check that the extent is covered by inodes */
 void
-xfs_scrub_xref_is_inode_chunk(
+xchk_xref_is_inode_chunk(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
-	xfs_scrub_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur, true);
+	xchk_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur, true);
 }
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 7a6208505980..d85fbec39e52 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -37,7 +37,7 @@
  * the goal.
  */
 int
-xfs_scrub_setup_inode(
+xchk_setup_inode(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
@@ -47,13 +47,13 @@ xfs_scrub_setup_inode(
 	 * Try to get the inode.  If the verifiers fail, we try again
 	 * in raw mode.
 	 */
-	error = xfs_scrub_get_inode(sc, ip);
+	error = xchk_get_inode(sc, ip);
 	switch (error) {
 	case 0:
 		break;
 	case -EFSCORRUPTED:
 	case -EFSBADCRC:
-		return xfs_scrub_trans_alloc(sc, 0);
+		return xchk_trans_alloc(sc, 0);
 	default:
 		return error;
 	}
@@ -61,7 +61,7 @@ xfs_scrub_setup_inode(
 	/* Got the inode, lock it and we're ready to go. */
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
-	error = xfs_scrub_trans_alloc(sc, 0);
+	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
@@ -76,7 +76,7 @@ xfs_scrub_setup_inode(
 
 /* Validate di_extsize hint. */
 STATIC void
-xfs_scrub_inode_extsize(
+xchk_inode_extsize(
 	struct xfs_scrub_context	*sc,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino,
@@ -88,7 +88,7 @@ xfs_scrub_inode_extsize(
 	fa = xfs_inode_validate_extsize(sc->mp, be32_to_cpu(dip->di_extsize),
 			mode, flags);
 	if (fa)
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 }
 
 /*
@@ -98,7 +98,7 @@ xfs_scrub_inode_extsize(
  * These functions must be kept in sync with each other.
  */
 STATIC void
-xfs_scrub_inode_cowextsize(
+xchk_inode_cowextsize(
 	struct xfs_scrub_context	*sc,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino,
@@ -112,12 +112,12 @@ xfs_scrub_inode_cowextsize(
 			be32_to_cpu(dip->di_cowextsize), mode, flags,
 			flags2);
 	if (fa)
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 }
 
 /* Make sure the di_flags make sense for the inode. */
 STATIC void
-xfs_scrub_inode_flags(
+xchk_inode_flags(
 	struct xfs_scrub_context	*sc,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino,
@@ -157,12 +157,12 @@ xfs_scrub_inode_flags(
 
 	return;
 bad:
-	xfs_scrub_ino_set_corrupt(sc, ino);
+	xchk_ino_set_corrupt(sc, ino);
 }
 
 /* Make sure the di_flags2 make sense for the inode. */
 STATIC void
-xfs_scrub_inode_flags2(
+xchk_inode_flags2(
 	struct xfs_scrub_context	*sc,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino,
@@ -200,12 +200,12 @@ xfs_scrub_inode_flags2(
 
 	return;
 bad:
-	xfs_scrub_ino_set_corrupt(sc, ino);
+	xchk_ino_set_corrupt(sc, ino);
 }
 
 /* Scrub all the ondisk inode fields. */
 STATIC void
-xfs_scrub_dinode(
+xchk_dinode(
 	struct xfs_scrub_context	*sc,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino)
@@ -237,7 +237,7 @@ xfs_scrub_dinode(
 		/* mode is recognized */
 		break;
 	default:
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 		break;
 	}
 
@@ -248,22 +248,22 @@ xfs_scrub_dinode(
 		 * We autoconvert v1 inodes into v2 inodes on writeout,
 		 * so just mark this inode for preening.
 		 */
-		xfs_scrub_ino_set_preen(sc, ino);
+		xchk_ino_set_preen(sc, ino);
 		break;
 	case 2:
 	case 3:
 		if (dip->di_onlink != 0)
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 
 		if (dip->di_mode == 0 && sc->ip)
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 
 		if (dip->di_projid_hi != 0 &&
 		    !xfs_sb_version_hasprojid32bit(&mp->m_sb))
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 		break;
 	default:
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 		return;
 	}
 
@@ -273,40 +273,40 @@ xfs_scrub_dinode(
 	 */
 	if (dip->di_uid == cpu_to_be32(-1U) ||
 	    dip->di_gid == cpu_to_be32(-1U))
-		xfs_scrub_ino_set_warning(sc, ino);
+		xchk_ino_set_warning(sc, ino);
 
 	/* di_format */
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_DEV:
 		if (!S_ISCHR(mode) && !S_ISBLK(mode) &&
 		    !S_ISFIFO(mode) && !S_ISSOCK(mode))
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_LOCAL:
 		if (!S_ISDIR(mode) && !S_ISLNK(mode))
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
 		if (!S_ISREG(mode) && !S_ISDIR(mode) && !S_ISLNK(mode))
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (!S_ISREG(mode) && !S_ISDIR(mode))
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_UUID:
 	default:
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 		break;
 	}
 
 	/* di_[amc]time.nsec */
 	if (be32_to_cpu(dip->di_atime.t_nsec) >= NSEC_PER_SEC)
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 	if (be32_to_cpu(dip->di_mtime.t_nsec) >= NSEC_PER_SEC)
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 	if (be32_to_cpu(dip->di_ctime.t_nsec) >= NSEC_PER_SEC)
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 
 	/*
 	 * di_size.  xfs_dinode_verify checks for things that screw up
@@ -315,19 +315,19 @@ xfs_scrub_dinode(
 	 */
 	isize = be64_to_cpu(dip->di_size);
 	if (isize & (1ULL << 63))
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 
 	/* Devices, fifos, and sockets must have zero size */
 	if (!S_ISDIR(mode) && !S_ISREG(mode) && !S_ISLNK(mode) && isize != 0)
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 
 	/* Directories can't be larger than the data section size (32G) */
 	if (S_ISDIR(mode) && (isize == 0 || isize >= XFS_DIR2_SPACE_SIZE))
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 
 	/* Symlinks can't be larger than SYMLINK_MAXLEN */
 	if (S_ISLNK(mode) && (isize == 0 || isize >= XFS_SYMLINK_MAXLEN))
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 
 	/*
 	 * Warn if the running kernel can't handle the kinds of offsets
@@ -336,7 +336,7 @@ xfs_scrub_dinode(
 	 * overly large offsets, flag the inode for admin review.
 	 */
 	if (isize >= mp->m_super->s_maxbytes)
-		xfs_scrub_ino_set_warning(sc, ino);
+		xchk_ino_set_warning(sc, ino);
 
 	/* di_nblocks */
 	if (flags2 & XFS_DIFLAG2_REFLINK) {
@@ -351,15 +351,15 @@ xfs_scrub_dinode(
 		 */
 		if (be64_to_cpu(dip->di_nblocks) >=
 		    mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks)
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 	} else {
 		if (be64_to_cpu(dip->di_nblocks) >= mp->m_sb.sb_dblocks)
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 	}
 
-	xfs_scrub_inode_flags(sc, dip, ino, mode, flags);
+	xchk_inode_flags(sc, dip, ino, mode, flags);
 
-	xfs_scrub_inode_extsize(sc, dip, ino, mode, flags);
+	xchk_inode_extsize(sc, dip, ino, mode, flags);
 
 	/* di_nextents */
 	nextents = be32_to_cpu(dip->di_nextents);
@@ -367,31 +367,31 @@ xfs_scrub_dinode(
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		if (nextents > fork_recs)
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (nextents <= fork_recs)
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 		break;
 	default:
 		if (nextents != 0)
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 		break;
 	}
 
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 
 	/* di_aformat */
 	if (dip->di_aformat != XFS_DINODE_FMT_LOCAL &&
 	    dip->di_aformat != XFS_DINODE_FMT_EXTENTS &&
 	    dip->di_aformat != XFS_DINODE_FMT_BTREE)
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 
 	/* di_anextents */
 	nextents = be16_to_cpu(dip->di_anextents);
@@ -399,22 +399,22 @@ xfs_scrub_dinode(
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
 		if (nextents > fork_recs)
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (nextents <= fork_recs)
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 		break;
 	default:
 		if (nextents != 0)
-			xfs_scrub_ino_set_corrupt(sc, ino);
+			xchk_ino_set_corrupt(sc, ino);
 	}
 
 	if (dip->di_version >= 3) {
 		if (be32_to_cpu(dip->di_crtime.t_nsec) >= NSEC_PER_SEC)
-			xfs_scrub_ino_set_corrupt(sc, ino);
-		xfs_scrub_inode_flags2(sc, dip, ino, mode, flags, flags2);
-		xfs_scrub_inode_cowextsize(sc, dip, ino, mode, flags,
+			xchk_ino_set_corrupt(sc, ino);
+		xchk_inode_flags2(sc, dip, ino, mode, flags, flags2);
+		xchk_inode_cowextsize(sc, dip, ino, mode, flags,
 				flags2);
 	}
 }
@@ -425,7 +425,7 @@ xfs_scrub_dinode(
  * IGET_UNTRUSTED, which checks the inobt for us.
  */
 static void
-xfs_scrub_inode_xref_finobt(
+xchk_inode_xref_finobt(
 	struct xfs_scrub_context	*sc,
 	xfs_ino_t			ino)
 {
@@ -434,7 +434,7 @@ xfs_scrub_inode_xref_finobt(
 	int				has_record;
 	int				error;
 
-	if (!sc->sa.fino_cur || xfs_scrub_skip_xref(sc->sm))
+	if (!sc->sa.fino_cur || xchk_skip_xref(sc->sm))
 		return;
 
 	agino = XFS_INO_TO_AGINO(sc->mp, ino);
@@ -445,12 +445,12 @@ xfs_scrub_inode_xref_finobt(
 	 */
 	error = xfs_inobt_lookup(sc->sa.fino_cur, agino, XFS_LOOKUP_LE,
 			&has_record);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.fino_cur) ||
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.fino_cur) ||
 	    !has_record)
 		return;
 
 	error = xfs_inobt_get_rec(sc->sa.fino_cur, &rec, &has_record);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.fino_cur) ||
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.fino_cur) ||
 	    !has_record)
 		return;
 
@@ -463,12 +463,12 @@ xfs_scrub_inode_xref_finobt(
 		return;
 
 	if (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino))
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.fino_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.fino_cur, 0);
 }
 
 /* Cross reference the inode fields with the forks. */
 STATIC void
-xfs_scrub_inode_xref_bmap(
+xchk_inode_xref_bmap(
 	struct xfs_scrub_context	*sc,
 	struct xfs_dinode		*dip)
 {
@@ -477,32 +477,32 @@ xfs_scrub_inode_xref_bmap(
 	xfs_filblks_t			acount;
 	int				error;
 
-	if (xfs_scrub_skip_xref(sc->sm))
+	if (xchk_skip_xref(sc->sm))
 		return;
 
 	/* Walk all the extents to check nextents/naextents/nblocks. */
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
 			&nextents, &count);
-	if (!xfs_scrub_should_check_xref(sc, &error, NULL))
+	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (nextents < be32_to_cpu(dip->di_nextents))
-		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
 			&nextents, &acount);
-	if (!xfs_scrub_should_check_xref(sc, &error, NULL))
+	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (nextents != be16_to_cpu(dip->di_anextents))
-		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	/* Check nblocks against the inode. */
 	if (count + acount != be64_to_cpu(dip->di_nblocks))
-		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 }
 
 /* Cross-reference with the other btrees. */
 STATIC void
-xfs_scrub_inode_xref(
+xchk_inode_xref(
 	struct xfs_scrub_context	*sc,
 	xfs_ino_t			ino,
 	struct xfs_dinode		*dip)
@@ -518,18 +518,18 @@ xfs_scrub_inode_xref(
 	agno = XFS_INO_TO_AGNO(sc->mp, ino);
 	agbno = XFS_INO_TO_AGBNO(sc->mp, ino);
 
-	error = xfs_scrub_ag_init(sc, agno, &sc->sa);
-	if (!xfs_scrub_xref_process_error(sc, agno, agbno, &error))
+	error = xchk_ag_init(sc, agno, &sc->sa);
+	if (!xchk_xref_process_error(sc, agno, agbno, &error))
 		return;
 
-	xfs_scrub_xref_is_used_space(sc, agbno, 1);
-	xfs_scrub_inode_xref_finobt(sc, ino);
+	xchk_xref_is_used_space(sc, agbno, 1);
+	xchk_inode_xref_finobt(sc, ino);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
-	xfs_scrub_xref_is_owned_by(sc, agbno, 1, &oinfo);
-	xfs_scrub_xref_is_not_shared(sc, agbno, 1);
-	xfs_scrub_inode_xref_bmap(sc, dip);
+	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
+	xchk_xref_is_not_shared(sc, agbno, 1);
+	xchk_inode_xref_bmap(sc, dip);
 
-	xfs_scrub_ag_free(sc, &sc->sa);
+	xchk_ag_free(sc, &sc->sa);
 }
 
 /*
@@ -539,7 +539,7 @@ xfs_scrub_inode_xref(
  * reflink filesystem.
  */
 static void
-xfs_scrub_inode_check_reflink_iflag(
+xchk_inode_check_reflink_iflag(
 	struct xfs_scrub_context	*sc,
 	xfs_ino_t			ino)
 {
@@ -552,18 +552,18 @@ xfs_scrub_inode_check_reflink_iflag(
 
 	error = xfs_reflink_inode_has_shared_extents(sc->tp, sc->ip,
 			&has_shared);
-	if (!xfs_scrub_xref_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
+	if (!xchk_xref_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
 			XFS_INO_TO_AGBNO(mp, ino), &error))
 		return;
 	if (xfs_is_reflink_inode(sc->ip) && !has_shared)
-		xfs_scrub_ino_set_preen(sc, ino);
+		xchk_ino_set_preen(sc, ino);
 	else if (!xfs_is_reflink_inode(sc->ip) && has_shared)
-		xfs_scrub_ino_set_corrupt(sc, ino);
+		xchk_ino_set_corrupt(sc, ino);
 }
 
 /* Scrub an inode. */
 int
-xfs_scrub_inode(
+xchk_inode(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_dinode		di;
@@ -575,13 +575,13 @@ xfs_scrub_inode(
 	 * and a NULL inode, so flag the corruption error and return.
 	 */
 	if (!sc->ip) {
-		xfs_scrub_ino_set_corrupt(sc, sc->sm->sm_ino);
+		xchk_ino_set_corrupt(sc, sc->sm->sm_ino);
 		return 0;
 	}
 
 	/* Scrub the inode core. */
 	xfs_inode_to_disk(sc->ip, &di, 0);
-	xfs_scrub_dinode(sc, &di, sc->ip->i_ino);
+	xchk_dinode(sc, &di, sc->ip->i_ino);
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 
@@ -591,9 +591,9 @@ xfs_scrub_inode(
 	 * we scrubbed the dinode.
 	 */
 	if (S_ISREG(VFS_I(sc->ip)->i_mode))
-		xfs_scrub_inode_check_reflink_iflag(sc, sc->ip->i_ino);
+		xchk_inode_check_reflink_iflag(sc, sc->ip->i_ino);
 
-	xfs_scrub_inode_xref(sc, sc->ip->i_ino, &di);
+	xchk_inode_xref(sc, sc->ip->i_ino, &di);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index e2bda58c32f0..0a78d8411f23 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -27,18 +27,18 @@
 
 /* Set us up to scrub parents. */
 int
-xfs_scrub_setup_parent(
+xchk_setup_parent(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	return xfs_scrub_setup_inode_contents(sc, ip, 0);
+	return xchk_setup_inode_contents(sc, ip, 0);
 }
 
 /* Parent pointers */
 
 /* Look for an entry in a parent pointing to this inode. */
 
-struct xfs_scrub_parent_ctx {
+struct xchk_parent_ctx {
 	struct dir_context		dc;
 	xfs_ino_t			ino;
 	xfs_nlink_t			nlink;
@@ -46,7 +46,7 @@ struct xfs_scrub_parent_ctx {
 
 /* Look for a single entry in a directory pointing to an inode. */
 STATIC int
-xfs_scrub_parent_actor(
+xchk_parent_actor(
 	struct dir_context		*dc,
 	const char			*name,
 	int				namelen,
@@ -54,9 +54,9 @@ xfs_scrub_parent_actor(
 	u64				ino,
 	unsigned			type)
 {
-	struct xfs_scrub_parent_ctx	*spc;
+	struct xchk_parent_ctx		*spc;
 
-	spc = container_of(dc, struct xfs_scrub_parent_ctx, dc);
+	spc = container_of(dc, struct xchk_parent_ctx, dc);
 	if (spc->ino == ino)
 		spc->nlink++;
 	return 0;
@@ -64,13 +64,13 @@ xfs_scrub_parent_actor(
 
 /* Count the number of dentries in the parent dir that point to this inode. */
 STATIC int
-xfs_scrub_parent_count_parent_dentries(
+xchk_parent_count_parent_dentries(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*parent,
 	xfs_nlink_t			*nlink)
 {
-	struct xfs_scrub_parent_ctx	spc = {
-		.dc.actor = xfs_scrub_parent_actor,
+	struct xchk_parent_ctx		spc = {
+		.dc.actor = xchk_parent_actor,
 		.dc.pos = 0,
 		.ino = sc->ip->i_ino,
 		.nlink = 0,
@@ -120,7 +120,7 @@ xfs_scrub_parent_count_parent_dentries(
  * entry pointing back to the inode being scrubbed.
  */
 STATIC int
-xfs_scrub_parent_validate(
+xchk_parent_validate(
 	struct xfs_scrub_context	*sc,
 	xfs_ino_t			dnum,
 	bool				*try_again)
@@ -138,7 +138,7 @@ xfs_scrub_parent_validate(
 
 	/* '..' must not point to ourselves. */
 	if (sc->ip->i_ino == dnum) {
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out;
 	}
 
@@ -165,13 +165,13 @@ xfs_scrub_parent_validate(
 	error = xfs_iget(mp, sc->tp, dnum, XFS_IGET_UNTRUSTED, 0, &dp);
 	if (error == -EINVAL) {
 		error = -EFSCORRUPTED;
-		xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error);
+		xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error);
 		goto out;
 	}
-	if (!xfs_scrub_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
+	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
 	if (dp == sc->ip || !S_ISDIR(VFS_I(dp)->i_mode)) {
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out_rele;
 	}
 
@@ -183,12 +183,12 @@ xfs_scrub_parent_validate(
 	 * the child inodes.
 	 */
 	if (xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
-		error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nlink);
-		if (!xfs_scrub_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
+		error = xchk_parent_count_parent_dentries(sc, dp, &nlink);
+		if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
 				&error))
 			goto out_unlock;
 		if (nlink != expected_nlink)
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out_unlock;
 	}
 
@@ -200,18 +200,18 @@ xfs_scrub_parent_validate(
 	 */
 	xfs_iunlock(sc->ip, sc->ilock_flags);
 	sc->ilock_flags = 0;
-	error = xfs_scrub_ilock_inverted(dp, XFS_IOLOCK_SHARED);
+	error = xchk_ilock_inverted(dp, XFS_IOLOCK_SHARED);
 	if (error)
 		goto out_rele;
 
 	/* Go looking for our dentry. */
-	error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nlink);
-	if (!xfs_scrub_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
+	error = xchk_parent_count_parent_dentries(sc, dp, &nlink);
+	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out_unlock;
 
 	/* Drop the parent lock, relock this inode. */
 	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
-	error = xfs_scrub_ilock_inverted(sc->ip, XFS_IOLOCK_EXCL);
+	error = xchk_ilock_inverted(sc->ip, XFS_IOLOCK_EXCL);
 	if (error)
 		goto out_rele;
 	sc->ilock_flags = XFS_IOLOCK_EXCL;
@@ -225,7 +225,7 @@ xfs_scrub_parent_validate(
 
 	/* Look up '..' to see if the inode changed. */
 	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
-	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out_rele;
 
 	/* Drat, parent changed.  Try again! */
@@ -241,7 +241,7 @@ xfs_scrub_parent_validate(
 	 * for us in the parent.
 	 */
 	if (nlink != expected_nlink)
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 	return error;
 
 out_unlock:
@@ -254,7 +254,7 @@ xfs_scrub_parent_validate(
 
 /* Scrub a parent pointer. */
 int
-xfs_scrub_parent(
+xchk_parent(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_mount		*mp = sc->mp;
@@ -272,7 +272,7 @@ xfs_scrub_parent(
 
 	/* We're not a special inode, are we? */
 	if (!xfs_verify_dir_ino(mp, sc->ip->i_ino)) {
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out;
 	}
 
@@ -288,10 +288,10 @@ xfs_scrub_parent(
 
 	/* Look up '..' */
 	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
-	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
 	if (!xfs_verify_dir_ino(mp, dnum)) {
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out;
 	}
 
@@ -299,12 +299,12 @@ xfs_scrub_parent(
 	if (sc->ip == mp->m_rootip) {
 		if (sc->ip->i_ino != mp->m_sb.sb_rootino ||
 		    sc->ip->i_ino != dnum)
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out;
 	}
 
 	do {
-		error = xfs_scrub_parent_validate(sc, dnum, &try_again);
+		error = xchk_parent_validate(sc, dnum, &try_again);
 		if (error)
 			goto out;
 	} while (try_again && ++tries < 20);
@@ -314,7 +314,7 @@ xfs_scrub_parent(
 	 * incomplete.  Userspace can decide if it wants to try again.
 	 */
 	if (try_again && tries == 20)
-		xfs_scrub_set_incomplete(sc);
+		xchk_set_incomplete(sc);
 out:
 	/*
 	 * If we failed to lock the parent inode even after a retry, just mark
@@ -322,7 +322,7 @@ xfs_scrub_parent(
 	 */
 	if (sc->try_harder && error == -EDEADLOCK) {
 		error = 0;
-		xfs_scrub_set_incomplete(sc);
+		xchk_set_incomplete(sc);
 	}
 	return error;
 }
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 6ff906aa0a3b..d1b52dd7efcd 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -30,7 +30,7 @@
 
 /* Convert a scrub type code to a DQ flag, or return 0 if error. */
 static inline uint
-xfs_scrub_quota_to_dqtype(
+xchk_quota_to_dqtype(
 	struct xfs_scrub_context	*sc)
 {
 	switch (sc->sm->sm_type) {
@@ -47,7 +47,7 @@ xfs_scrub_quota_to_dqtype(
 
 /* Set us up to scrub a quota. */
 int
-xfs_scrub_setup_quota(
+xchk_setup_quota(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
@@ -57,14 +57,14 @@ xfs_scrub_setup_quota(
 	if (!XFS_IS_QUOTA_RUNNING(sc->mp) || !XFS_IS_QUOTA_ON(sc->mp))
 		return -ENOENT;
 
-	dqtype = xfs_scrub_quota_to_dqtype(sc);
+	dqtype = xchk_quota_to_dqtype(sc);
 	if (dqtype == 0)
 		return -EINVAL;
 	sc->has_quotaofflock = true;
 	mutex_lock(&sc->mp->m_quotainfo->qi_quotaofflock);
 	if (!xfs_this_quota_on(sc->mp, dqtype))
 		return -ENOENT;
-	error = xfs_scrub_setup_fs(sc, ip);
+	error = xchk_setup_fs(sc, ip);
 	if (error)
 		return error;
 	sc->ip = xfs_quota_inode(sc->mp, dqtype);
@@ -75,19 +75,19 @@ xfs_scrub_setup_quota(
 
 /* Quotas. */
 
-struct xfs_scrub_quota_info {
+struct xchk_quota_info {
 	struct xfs_scrub_context	*sc;
 	xfs_dqid_t			last_id;
 };
 
 /* Scrub the fields in an individual quota item. */
 STATIC int
-xfs_scrub_quota_item(
+xchk_quota_item(
 	struct xfs_dquot		*dq,
 	uint				dqtype,
 	void				*priv)
 {
-	struct xfs_scrub_quota_info	*sqi = priv;
+	struct xchk_quota_info		*sqi = priv;
 	struct xfs_scrub_context	*sc = sqi->sc;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_disk_dquot		*d = &dq->q_core;
@@ -111,16 +111,16 @@ xfs_scrub_quota_item(
 	 */
 	offset = id / qi->qi_dqperchunk;
 	if (id && id <= sqi->last_id)
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	sqi->last_id = id;
 
 	/* Did we get the dquot type we wanted? */
 	if (dqtype != (d->d_flags & XFS_DQ_ALLTYPES))
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/* Check the limits. */
 	bhard = be64_to_cpu(d->d_blk_hardlimit);
@@ -140,19 +140,19 @@ xfs_scrub_quota_item(
 	 * the hard limit.
 	 */
 	if (bhard > mp->m_sb.sb_dblocks)
-		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 	if (bsoft > bhard)
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (ihard > mp->m_maxicount)
-		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 	if (isoft > ihard)
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (rhard > mp->m_sb.sb_rblocks)
-		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 	if (rsoft > rhard)
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/* Check the resource counts. */
 	bcount = be64_to_cpu(d->d_bcount);
@@ -167,15 +167,15 @@ xfs_scrub_quota_item(
 	 */
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
 		if (mp->m_sb.sb_dblocks < bcount)
-			xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK,
+			xchk_fblock_set_warning(sc, XFS_DATA_FORK,
 					offset);
 	} else {
 		if (mp->m_sb.sb_dblocks < bcount)
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
 					offset);
 	}
 	if (icount > fs_icount || rcount > mp->m_sb.sb_rblocks)
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/*
 	 * We can violate the hard limits if the admin suddenly sets a
@@ -183,18 +183,18 @@ xfs_scrub_quota_item(
 	 * admin review.
 	 */
 	if (id != 0 && bhard != 0 && bcount > bhard)
-		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 	if (id != 0 && ihard != 0 && icount > ihard)
-		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 	if (id != 0 && rhard != 0 && rcount > rhard)
-		xfs_scrub_fblock_set_warning(sc, XFS_DATA_FORK, offset);
+		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 
 	return 0;
 }
 
 /* Check the quota's data fork. */
 STATIC int
-xfs_scrub_quota_data_fork(
+xchk_quota_data_fork(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_bmbt_irec		irec = { 0 };
@@ -205,7 +205,7 @@ xfs_scrub_quota_data_fork(
 	int				error = 0;
 
 	/* Invoke the fork scrubber. */
-	error = xfs_scrub_metadata_inode_forks(sc);
+	error = xchk_metadata_inode_forks(sc);
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
@@ -213,7 +213,7 @@ xfs_scrub_quota_data_fork(
 	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
 	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
 	for_each_xfs_iext(ifp, &icur, &irec) {
-		if (xfs_scrub_should_terminate(sc, &error))
+		if (xchk_should_terminate(sc, &error))
 			break;
 		/*
 		 * delalloc extents or blocks mapped above the highest
@@ -222,7 +222,7 @@ xfs_scrub_quota_data_fork(
 		if (isnullstartblock(irec.br_startblock) ||
 		    irec.br_startoff > max_dqid_off ||
 		    irec.br_startoff + irec.br_blockcount - 1 > max_dqid_off) {
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK,
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
 					irec.br_startoff);
 			break;
 		}
@@ -233,19 +233,19 @@ xfs_scrub_quota_data_fork(
 
 /* Scrub all of a quota type's items. */
 int
-xfs_scrub_quota(
+xchk_quota(
 	struct xfs_scrub_context	*sc)
 {
-	struct xfs_scrub_quota_info	sqi;
+	struct xchk_quota_info		sqi;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_quotainfo		*qi = mp->m_quotainfo;
 	uint				dqtype;
 	int				error = 0;
 
-	dqtype = xfs_scrub_quota_to_dqtype(sc);
+	dqtype = xchk_quota_to_dqtype(sc);
 
 	/* Look for problem extents. */
-	error = xfs_scrub_quota_data_fork(sc);
+	error = xchk_quota_data_fork(sc);
 	if (error)
 		goto out;
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
@@ -260,10 +260,10 @@ xfs_scrub_quota(
 	sc->ilock_flags = 0;
 	sqi.sc = sc;
 	sqi.last_id = 0;
-	error = xfs_qm_dqiterate(mp, dqtype, xfs_scrub_quota_item, &sqi);
+	error = xfs_qm_dqiterate(mp, dqtype, xchk_quota_item, &sqi);
 	sc->ilock_flags = XFS_ILOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
-	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK,
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK,
 			sqi.last_id * qi->qi_dqperchunk, &error))
 		goto out;
 
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 607a9faa8ecc..274febc49b23 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -28,11 +28,11 @@
  * Set us up to scrub reference count btrees.
  */
 int
-xfs_scrub_setup_ag_refcountbt(
+xchk_setup_ag_refcountbt(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	return xfs_scrub_setup_ag_btree(sc, ip, false);
+	return xchk_setup_ag_btree(sc, ip, false);
 }
 
 /* Reference count btree scrubber. */
@@ -73,12 +73,12 @@ xfs_scrub_setup_ag_refcountbt(
  * If the refcount is correct, all the check conditions in the algorithm
  * should always hold true.  If not, the refcount is incorrect.
  */
-struct xfs_scrub_refcnt_frag {
+struct xchk_refcnt_frag {
 	struct list_head		list;
 	struct xfs_rmap_irec		rm;
 };
 
-struct xfs_scrub_refcnt_check {
+struct xchk_refcnt_check {
 	struct xfs_scrub_context	*sc;
 	struct list_head		fragments;
 
@@ -99,18 +99,18 @@ struct xfs_scrub_refcnt_check {
  * fragments as the refcountbt says we should have.
  */
 STATIC int
-xfs_scrub_refcountbt_rmap_check(
+xchk_refcountbt_rmap_check(
 	struct xfs_btree_cur		*cur,
 	struct xfs_rmap_irec		*rec,
 	void				*priv)
 {
-	struct xfs_scrub_refcnt_check	*refchk = priv;
-	struct xfs_scrub_refcnt_frag	*frag;
+	struct xchk_refcnt_check	*refchk = priv;
+	struct xchk_refcnt_frag		*frag;
 	xfs_agblock_t			rm_last;
 	xfs_agblock_t			rc_last;
 	int				error = 0;
 
-	if (xfs_scrub_should_terminate(refchk->sc, &error))
+	if (xchk_should_terminate(refchk->sc, &error))
 		return error;
 
 	rm_last = rec->rm_startblock + rec->rm_blockcount - 1;
@@ -118,7 +118,7 @@ xfs_scrub_refcountbt_rmap_check(
 
 	/* Confirm that a single-owner refc extent is a CoW stage. */
 	if (refchk->refcount == 1 && rec->rm_owner != XFS_RMAP_OWN_COW) {
-		xfs_scrub_btree_xref_set_corrupt(refchk->sc, cur, 0);
+		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
 		return 0;
 	}
 
@@ -135,7 +135,7 @@ xfs_scrub_refcountbt_rmap_check(
 		 * is healthy each rmap_irec we see will be in agbno order
 		 * so we don't need insertion sort here.
 		 */
-		frag = kmem_alloc(sizeof(struct xfs_scrub_refcnt_frag),
+		frag = kmem_alloc(sizeof(struct xchk_refcnt_frag),
 				KM_MAYFAIL);
 		if (!frag)
 			return -ENOMEM;
@@ -154,12 +154,12 @@ xfs_scrub_refcountbt_rmap_check(
  * we have a refcountbt error.
  */
 STATIC void
-xfs_scrub_refcountbt_process_rmap_fragments(
-	struct xfs_scrub_refcnt_check	*refchk)
+xchk_refcountbt_process_rmap_fragments(
+	struct xchk_refcnt_check	*refchk)
 {
 	struct list_head		worklist;
-	struct xfs_scrub_refcnt_frag	*frag;
-	struct xfs_scrub_refcnt_frag	*n;
+	struct xchk_refcnt_frag		*frag;
+	struct xchk_refcnt_frag		*n;
 	xfs_agblock_t			bno;
 	xfs_agblock_t			rbno;
 	xfs_agblock_t			next_rbno;
@@ -277,13 +277,13 @@ xfs_scrub_refcountbt_process_rmap_fragments(
 
 /* Use the rmap entries covering this extent to verify the refcount. */
 STATIC void
-xfs_scrub_refcountbt_xref_rmap(
+xchk_refcountbt_xref_rmap(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	xfs_nlink_t			refcount)
 {
-	struct xfs_scrub_refcnt_check	refchk = {
+	struct xchk_refcnt_check	refchk = {
 		.sc = sc,
 		.bno = bno,
 		.len = len,
@@ -292,11 +292,11 @@ xfs_scrub_refcountbt_xref_rmap(
 	};
 	struct xfs_rmap_irec		low;
 	struct xfs_rmap_irec		high;
-	struct xfs_scrub_refcnt_frag	*frag;
-	struct xfs_scrub_refcnt_frag	*n;
+	struct xchk_refcnt_frag		*frag;
+	struct xchk_refcnt_frag		*n;
 	int				error;
 
-	if (!sc->sa.rmap_cur || xfs_scrub_skip_xref(sc->sm))
+	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
 		return;
 
 	/* Cross-reference with the rmapbt to confirm the refcount. */
@@ -307,13 +307,13 @@ xfs_scrub_refcountbt_xref_rmap(
 
 	INIT_LIST_HEAD(&refchk.fragments);
 	error = xfs_rmap_query_range(sc->sa.rmap_cur, &low, &high,
-			&xfs_scrub_refcountbt_rmap_check, &refchk);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+			&xchk_refcountbt_rmap_check, &refchk);
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		goto out_free;
 
-	xfs_scrub_refcountbt_process_rmap_fragments(&refchk);
+	xchk_refcountbt_process_rmap_fragments(&refchk);
 	if (refcount != refchk.seen)
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 
 out_free:
 	list_for_each_entry_safe(frag, n, &refchk.fragments, list) {
@@ -324,7 +324,7 @@ xfs_scrub_refcountbt_xref_rmap(
 
 /* Cross-reference with the other btrees. */
 STATIC void
-xfs_scrub_refcountbt_xref(
+xchk_refcountbt_xref(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len,
@@ -333,15 +333,15 @@ xfs_scrub_refcountbt_xref(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
-	xfs_scrub_xref_is_used_space(sc, agbno, len);
-	xfs_scrub_xref_is_not_inode_chunk(sc, agbno, len);
-	xfs_scrub_refcountbt_xref_rmap(sc, agbno, len, refcount);
+	xchk_xref_is_used_space(sc, agbno, len);
+	xchk_xref_is_not_inode_chunk(sc, agbno, len);
+	xchk_refcountbt_xref_rmap(sc, agbno, len, refcount);
 }
 
 /* Scrub a refcountbt record. */
 STATIC int
-xfs_scrub_refcountbt_rec(
-	struct xfs_scrub_btree		*bs,
+xchk_refcountbt_rec(
+	struct xchk_btree		*bs,
 	union xfs_btree_rec		*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
@@ -360,7 +360,7 @@ xfs_scrub_refcountbt_rec(
 	/* Only CoW records can have refcount == 1. */
 	has_cowflag = (bno & XFS_REFC_COW_START);
 	if ((refcount == 1 && !has_cowflag) || (refcount != 1 && has_cowflag))
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 	if (has_cowflag)
 		(*cow_blocks) += len;
 
@@ -369,19 +369,19 @@ xfs_scrub_refcountbt_rec(
 	if (bno + len <= bno ||
 	    !xfs_verify_agbno(mp, agno, bno) ||
 	    !xfs_verify_agbno(mp, agno, bno + len - 1))
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	if (refcount == 0)
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
-	xfs_scrub_refcountbt_xref(bs->sc, bno, len, refcount);
+	xchk_refcountbt_xref(bs->sc, bno, len, refcount);
 
 	return error;
 }
 
 /* Make sure we have as many refc blocks as the rmap says. */
 STATIC void
-xfs_scrub_refcount_xref_rmap(
+xchk_refcount_xref_rmap(
 	struct xfs_scrub_context	*sc,
 	struct xfs_owner_info		*oinfo,
 	xfs_filblks_t			cow_blocks)
@@ -390,33 +390,33 @@ xfs_scrub_refcount_xref_rmap(
 	xfs_filblks_t			blocks;
 	int				error;
 
-	if (!sc->sa.rmap_cur || xfs_scrub_skip_xref(sc->sm))
+	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
 		return;
 
 	/* Check that we saw as many refcbt blocks as the rmap knows about. */
 	error = xfs_btree_count_blocks(sc->sa.refc_cur, &refcbt_blocks);
-	if (!xfs_scrub_btree_process_error(sc, sc->sa.refc_cur, 0, &error))
+	if (!xchk_btree_process_error(sc, sc->sa.refc_cur, 0, &error))
 		return;
-	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
 			&blocks);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
 	if (blocks != refcbt_blocks)
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 
 	/* Check that we saw as many cow blocks as the rmap knows about. */
 	xfs_rmap_ag_owner(oinfo, XFS_RMAP_OWN_COW);
-	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
 			&blocks);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
 	if (blocks != cow_blocks)
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 }
 
 /* Scrub the refcount btree for some AG. */
 int
-xfs_scrub_refcountbt(
+xchk_refcountbt(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_owner_info		oinfo;
@@ -424,19 +424,19 @@ xfs_scrub_refcountbt(
 	int				error;
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
-	error = xfs_scrub_btree(sc, sc->sa.refc_cur, xfs_scrub_refcountbt_rec,
+	error = xchk_btree(sc, sc->sa.refc_cur, xchk_refcountbt_rec,
 			&oinfo, &cow_blocks);
 	if (error)
 		return error;
 
-	xfs_scrub_refcount_xref_rmap(sc, &oinfo, cow_blocks);
+	xchk_refcount_xref_rmap(sc, &oinfo, cow_blocks);
 
 	return 0;
 }
 
 /* xref check that a cow staging extent is marked in the refcountbt. */
 void
-xfs_scrub_xref_is_cow_staging(
+xchk_xref_is_cow_staging(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
@@ -446,35 +446,35 @@ xfs_scrub_xref_is_cow_staging(
 	int				has_refcount;
 	int				error;
 
-	if (!sc->sa.refc_cur || xfs_scrub_skip_xref(sc->sm))
+	if (!sc->sa.refc_cur || xchk_skip_xref(sc->sm))
 		return;
 
 	/* Find the CoW staging extent. */
 	error = xfs_refcount_lookup_le(sc->sa.refc_cur,
 			agbno + XFS_REFC_COW_START, &has_refcount);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
 	if (!has_refcount) {
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 		return;
 	}
 
 	error = xfs_refcount_get_rec(sc->sa.refc_cur, &rc, &has_refcount);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
 	if (!has_refcount) {
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 		return;
 	}
 
 	/* CoW flag must be set, refcount must be 1. */
 	has_cowflag = (rc.rc_startblock & XFS_REFC_COW_START);
 	if (!has_cowflag || rc.rc_refcount != 1)
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 
 	/* Must be at least as long as what was passed in */
 	if (rc.rc_blockcount < len)
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 }
 
 /*
@@ -482,7 +482,7 @@ xfs_scrub_xref_is_cow_staging(
  * can have multiple owners.
  */
 void
-xfs_scrub_xref_is_not_shared(
+xchk_xref_is_not_shared(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
@@ -490,12 +490,12 @@ xfs_scrub_xref_is_not_shared(
 	bool				shared;
 	int				error;
 
-	if (!sc->sa.refc_cur || xfs_scrub_skip_xref(sc->sm))
+	if (!sc->sa.refc_cur || xchk_skip_xref(sc->sm))
 		return;
 
 	error = xfs_refcount_has_record(sc->sa.refc_cur, agbno, len, &shared);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
 	if (shared)
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 }
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index ea39e2bdc96a..5eccd89c64a8 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -50,7 +50,7 @@ xfs_repair_attempt(
 
 	trace_xfs_repair_attempt(ip, sc->sm, error);
 
-	xfs_scrub_ag_btcur_free(&sc->sa);
+	xchk_ag_btcur_free(&sc->sa);
 
 	/* Repair whatever's broken. */
 	ASSERT(sc->ops->repair);
@@ -110,7 +110,7 @@ xfs_repair_probe(
 {
 	int				error = 0;
 
-	if (xfs_scrub_should_terminate(sc, &error))
+	if (xchk_should_terminate(sc, &error))
 		return error;
 
 	return 0;
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index c6d763236ba7..4b75fc2f31f3 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -29,18 +29,18 @@
  * Set us up to scrub reverse mapping btrees.
  */
 int
-xfs_scrub_setup_ag_rmapbt(
+xchk_setup_ag_rmapbt(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	return xfs_scrub_setup_ag_btree(sc, ip, false);
+	return xchk_setup_ag_btree(sc, ip, false);
 }
 
 /* Reverse-mapping scrubber. */
 
 /* Cross-reference a rmap against the refcount btree. */
 STATIC void
-xfs_scrub_rmapbt_xref_refc(
+xchk_rmapbt_xref_refc(
 	struct xfs_scrub_context	*sc,
 	struct xfs_rmap_irec		*irec)
 {
@@ -52,7 +52,7 @@ xfs_scrub_rmapbt_xref_refc(
 	bool				is_unwritten;
 	int				error;
 
-	if (!sc->sa.refc_cur || xfs_scrub_skip_xref(sc->sm))
+	if (!sc->sa.refc_cur || xchk_skip_xref(sc->sm))
 		return;
 
 	non_inode = XFS_RMAP_NON_INODE_OWNER(irec->rm_owner);
@@ -63,15 +63,15 @@ xfs_scrub_rmapbt_xref_refc(
 	/* If this is shared, must be a data fork extent. */
 	error = xfs_refcount_find_shared(sc->sa.refc_cur, irec->rm_startblock,
 			irec->rm_blockcount, &fbno, &flen, false);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
 	if (flen != 0 && (non_inode || is_attr || is_bmbt || is_unwritten))
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 }
 
 /* Cross-reference with the other btrees. */
 STATIC void
-xfs_scrub_rmapbt_xref(
+xchk_rmapbt_xref(
 	struct xfs_scrub_context	*sc,
 	struct xfs_rmap_irec		*irec)
 {
@@ -81,22 +81,22 @@ xfs_scrub_rmapbt_xref(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
-	xfs_scrub_xref_is_used_space(sc, agbno, len);
+	xchk_xref_is_used_space(sc, agbno, len);
 	if (irec->rm_owner == XFS_RMAP_OWN_INODES)
-		xfs_scrub_xref_is_inode_chunk(sc, agbno, len);
+		xchk_xref_is_inode_chunk(sc, agbno, len);
 	else
-		xfs_scrub_xref_is_not_inode_chunk(sc, agbno, len);
+		xchk_xref_is_not_inode_chunk(sc, agbno, len);
 	if (irec->rm_owner == XFS_RMAP_OWN_COW)
-		xfs_scrub_xref_is_cow_staging(sc, irec->rm_startblock,
+		xchk_xref_is_cow_staging(sc, irec->rm_startblock,
 				irec->rm_blockcount);
 	else
-		xfs_scrub_rmapbt_xref_refc(sc, irec);
+		xchk_rmapbt_xref_refc(sc, irec);
 }
 
 /* Scrub an rmapbt record. */
 STATIC int
-xfs_scrub_rmapbt_rec(
-	struct xfs_scrub_btree		*bs,
+xchk_rmapbt_rec(
+	struct xchk_btree		*bs,
 	union xfs_btree_rec		*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
@@ -109,12 +109,12 @@ xfs_scrub_rmapbt_rec(
 	int				error;
 
 	error = xfs_rmap_btrec_to_irec(rec, &irec);
-	if (!xfs_scrub_btree_process_error(bs->sc, bs->cur, 0, &error))
+	if (!xchk_btree_process_error(bs->sc, bs->cur, 0, &error))
 		goto out;
 
 	/* Check extent. */
 	if (irec.rm_startblock + irec.rm_blockcount <= irec.rm_startblock)
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	if (irec.rm_owner == XFS_RMAP_OWN_FS) {
 		/*
@@ -124,7 +124,7 @@ xfs_scrub_rmapbt_rec(
 		 */
 		if (irec.rm_startblock != 0 ||
 		    irec.rm_blockcount != XFS_AGFL_BLOCK(mp) + 1)
-			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 	} else {
 		/*
 		 * Otherwise we must point somewhere past the static metadata
@@ -133,7 +133,7 @@ xfs_scrub_rmapbt_rec(
 		if (!xfs_verify_agbno(mp, agno, irec.rm_startblock) ||
 		    !xfs_verify_agbno(mp, agno, irec.rm_startblock +
 				irec.rm_blockcount - 1))
-			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 	}
 
 	/* Check flags. */
@@ -143,47 +143,47 @@ xfs_scrub_rmapbt_rec(
 	is_unwritten = irec.rm_flags & XFS_RMAP_UNWRITTEN;
 
 	if (is_bmbt && irec.rm_offset != 0)
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	if (non_inode && irec.rm_offset != 0)
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	if (is_unwritten && (is_bmbt || non_inode || is_attr))
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	if (non_inode && (is_bmbt || is_unwritten || is_attr))
-		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	if (!non_inode) {
 		if (!xfs_verify_ino(mp, irec.rm_owner))
-			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 	} else {
 		/* Non-inode owner within the magic values? */
 		if (irec.rm_owner <= XFS_RMAP_OWN_MIN ||
 		    irec.rm_owner > XFS_RMAP_OWN_FS)
-			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 	}
 
-	xfs_scrub_rmapbt_xref(bs->sc, &irec);
+	xchk_rmapbt_xref(bs->sc, &irec);
 out:
 	return error;
 }
 
 /* Scrub the rmap btree for some AG. */
 int
-xfs_scrub_rmapbt(
+xchk_rmapbt(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_owner_info		oinfo;
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
-	return xfs_scrub_btree(sc, sc->sa.rmap_cur, xfs_scrub_rmapbt_rec,
+	return xchk_btree(sc, sc->sa.rmap_cur, xchk_rmapbt_rec,
 			&oinfo, NULL);
 }
 
 /* xref check that the extent is owned by a given owner */
 static inline void
-xfs_scrub_xref_check_owner(
+xchk_xref_check_owner(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
@@ -193,42 +193,42 @@ xfs_scrub_xref_check_owner(
 	bool				has_rmap;
 	int				error;
 
-	if (!sc->sa.rmap_cur || xfs_scrub_skip_xref(sc->sm))
+	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
 		return;
 
 	error = xfs_rmap_record_exists(sc->sa.rmap_cur, bno, len, oinfo,
 			&has_rmap);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
 	if (has_rmap != should_have_rmap)
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 }
 
 /* xref check that the extent is owned by a given owner */
 void
-xfs_scrub_xref_is_owned_by(
+xchk_xref_is_owned_by(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	struct xfs_owner_info		*oinfo)
 {
-	xfs_scrub_xref_check_owner(sc, bno, len, oinfo, true);
+	xchk_xref_check_owner(sc, bno, len, oinfo, true);
 }
 
 /* xref check that the extent is not owned by a given owner */
 void
-xfs_scrub_xref_is_not_owned_by(
+xchk_xref_is_not_owned_by(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	struct xfs_owner_info		*oinfo)
 {
-	xfs_scrub_xref_check_owner(sc, bno, len, oinfo, false);
+	xchk_xref_check_owner(sc, bno, len, oinfo, false);
 }
 
 /* xref check that the extent has no reverse mapping at all */
 void
-xfs_scrub_xref_has_no_owner(
+xchk_xref_has_no_owner(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len)
@@ -236,12 +236,12 @@ xfs_scrub_xref_has_no_owner(
 	bool				has_rmap;
 	int				error;
 
-	if (!sc->sa.rmap_cur || xfs_scrub_skip_xref(sc->sm))
+	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
 		return;
 
 	error = xfs_rmap_has_record(sc->sa.rmap_cur, bno, len, &has_rmap);
-	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
 	if (has_rmap)
-		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 }
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 1f86e02a07ca..3f0fc83562ae 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -25,13 +25,13 @@
 
 /* Set us up with the realtime metadata locked. */
 int
-xfs_scrub_setup_rt(
+xchk_setup_rt(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
 	int				error;
 
-	error = xfs_scrub_setup_fs(sc, ip);
+	error = xchk_setup_fs(sc, ip);
 	if (error)
 		return error;
 
@@ -46,7 +46,7 @@ xfs_scrub_setup_rt(
 
 /* Scrub a free extent record from the realtime bitmap. */
 STATIC int
-xfs_scrub_rtbitmap_rec(
+xchk_rtbitmap_rec(
 	struct xfs_trans		*tp,
 	struct xfs_rtalloc_rec		*rec,
 	void				*priv)
@@ -61,24 +61,24 @@ xfs_scrub_rtbitmap_rec(
 	if (startblock + blockcount <= startblock ||
 	    !xfs_verify_rtbno(sc->mp, startblock) ||
 	    !xfs_verify_rtbno(sc->mp, startblock + blockcount - 1))
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 	return 0;
 }
 
 /* Scrub the realtime bitmap. */
 int
-xfs_scrub_rtbitmap(
+xchk_rtbitmap(
 	struct xfs_scrub_context	*sc)
 {
 	int				error;
 
 	/* Invoke the fork scrubber. */
-	error = xfs_scrub_metadata_inode_forks(sc);
+	error = xchk_metadata_inode_forks(sc);
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
-	error = xfs_rtalloc_query_all(sc->tp, xfs_scrub_rtbitmap_rec, sc);
-	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+	error = xfs_rtalloc_query_all(sc->tp, xchk_rtbitmap_rec, sc);
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
 
 out:
@@ -87,7 +87,7 @@ xfs_scrub_rtbitmap(
 
 /* Scrub the realtime summary. */
 int
-xfs_scrub_rtsummary(
+xchk_rtsummary(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_inode		*rsumip = sc->mp->m_rsumip;
@@ -107,12 +107,12 @@ xfs_scrub_rtsummary(
 	xfs_ilock(sc->ip, sc->ilock_flags);
 
 	/* Invoke the fork scrubber. */
-	error = xfs_scrub_metadata_inode_forks(sc);
+	error = xchk_metadata_inode_forks(sc);
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		goto out;
 
 	/* XXX: implement this some day */
-	xfs_scrub_set_incomplete(sc);
+	xchk_set_incomplete(sc);
 out:
 	/* Switch back to the rtbitmap inode and lock flags. */
 	xfs_iunlock(sc->ip, sc->ilock_flags);
@@ -124,7 +124,7 @@ xfs_scrub_rtsummary(
 
 /* xref check that the extent is not free in the rtbitmap */
 void
-xfs_scrub_xref_is_used_rt_space(
+xchk_xref_is_used_rt_space(
 	struct xfs_scrub_context	*sc,
 	xfs_rtblock_t			fsbno,
 	xfs_extlen_t			len)
@@ -135,7 +135,7 @@ xfs_scrub_xref_is_used_rt_space(
 	bool				is_free;
 	int				error;
 
-	if (xfs_scrub_skip_xref(sc->sm))
+	if (xchk_skip_xref(sc->sm))
 		return;
 
 	startext = fsbno;
@@ -147,10 +147,10 @@ xfs_scrub_xref_is_used_rt_space(
 	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext, extcount,
 			&is_free);
-	if (!xfs_scrub_should_check_xref(sc, &error, NULL))
+	if (!xchk_should_check_xref(sc, &error, NULL))
 		goto out_unlock;
 	if (is_free)
-		xfs_scrub_ino_xref_set_corrupt(sc, sc->mp->m_rbmip->i_ino);
+		xchk_ino_xref_set_corrupt(sc, sc->mp->m_rbmip->i_ino);
 out_unlock:
 	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 58ae76b3a421..ead97ab91a3c 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -131,6 +131,12 @@
  * optimize the structure so that the rebuild knows what to do.  The
  * second check evaluates the completeness of the repair; that is what
  * is reported to userspace.
+ *
+ * A quick note on symbol prefixes:
+ * - "xfs_" are general XFS symbols.
+ * - "xchk_" are symbols related to metadata checking.
+ * - "xrep_" are symbols related to metadata repair.
+ * - "xfs_scrub_" are symbols that tie online fsck to the rest of XFS.
  */
 
 /*
@@ -144,12 +150,12 @@
  * supported by the running kernel.
  */
 static int
-xfs_scrub_probe(
+xchk_probe(
 	struct xfs_scrub_context	*sc)
 {
 	int				error = 0;
 
-	if (xfs_scrub_should_terminate(sc, &error))
+	if (xchk_should_terminate(sc, &error))
 		return error;
 
 	return 0;
@@ -159,12 +165,12 @@ xfs_scrub_probe(
 
 /* Free all the resources and finish the transactions. */
 STATIC int
-xfs_scrub_teardown(
+xchk_teardown(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip_in,
 	int				error)
 {
-	xfs_scrub_ag_free(sc, &sc->sa);
+	xchk_ag_free(sc, &sc->sa);
 	if (sc->tp) {
 		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
 			error = xfs_trans_commit(sc->tp);
@@ -191,165 +197,165 @@ xfs_scrub_teardown(
 
 /* Scrubbing dispatch. */
 
-static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
+static const struct xchk_meta_ops meta_scrub_ops[] = {
 	[XFS_SCRUB_TYPE_PROBE] = {	/* ioctl presence test */
 		.type	= ST_NONE,
-		.setup	= xfs_scrub_setup_fs,
-		.scrub	= xfs_scrub_probe,
+		.setup	= xchk_setup_fs,
+		.scrub	= xchk_probe,
 		.repair = xfs_repair_probe,
 	},
 	[XFS_SCRUB_TYPE_SB] = {		/* superblock */
 		.type	= ST_PERAG,
-		.setup	= xfs_scrub_setup_fs,
-		.scrub	= xfs_scrub_superblock,
+		.setup	= xchk_setup_fs,
+		.scrub	= xchk_superblock,
 		.repair	= xfs_repair_superblock,
 	},
 	[XFS_SCRUB_TYPE_AGF] = {	/* agf */
 		.type	= ST_PERAG,
-		.setup	= xfs_scrub_setup_fs,
-		.scrub	= xfs_scrub_agf,
+		.setup	= xchk_setup_fs,
+		.scrub	= xchk_agf,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_AGFL]= {	/* agfl */
 		.type	= ST_PERAG,
-		.setup	= xfs_scrub_setup_fs,
-		.scrub	= xfs_scrub_agfl,
+		.setup	= xchk_setup_fs,
+		.scrub	= xchk_agfl,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_AGI] = {	/* agi */
 		.type	= ST_PERAG,
-		.setup	= xfs_scrub_setup_fs,
-		.scrub	= xfs_scrub_agi,
+		.setup	= xchk_setup_fs,
+		.scrub	= xchk_agi,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_BNOBT] = {	/* bnobt */
 		.type	= ST_PERAG,
-		.setup	= xfs_scrub_setup_ag_allocbt,
-		.scrub	= xfs_scrub_bnobt,
+		.setup	= xchk_setup_ag_allocbt,
+		.scrub	= xchk_bnobt,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_CNTBT] = {	/* cntbt */
 		.type	= ST_PERAG,
-		.setup	= xfs_scrub_setup_ag_allocbt,
-		.scrub	= xfs_scrub_cntbt,
+		.setup	= xchk_setup_ag_allocbt,
+		.scrub	= xchk_cntbt,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_INOBT] = {	/* inobt */
 		.type	= ST_PERAG,
-		.setup	= xfs_scrub_setup_ag_iallocbt,
-		.scrub	= xfs_scrub_inobt,
+		.setup	= xchk_setup_ag_iallocbt,
+		.scrub	= xchk_inobt,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_FINOBT] = {	/* finobt */
 		.type	= ST_PERAG,
-		.setup	= xfs_scrub_setup_ag_iallocbt,
-		.scrub	= xfs_scrub_finobt,
+		.setup	= xchk_setup_ag_iallocbt,
+		.scrub	= xchk_finobt,
 		.has	= xfs_sb_version_hasfinobt,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
 		.type	= ST_PERAG,
-		.setup	= xfs_scrub_setup_ag_rmapbt,
-		.scrub	= xfs_scrub_rmapbt,
+		.setup	= xchk_setup_ag_rmapbt,
+		.scrub	= xchk_rmapbt,
 		.has	= xfs_sb_version_hasrmapbt,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_REFCNTBT] = {	/* refcountbt */
 		.type	= ST_PERAG,
-		.setup	= xfs_scrub_setup_ag_refcountbt,
-		.scrub	= xfs_scrub_refcountbt,
+		.setup	= xchk_setup_ag_refcountbt,
+		.scrub	= xchk_refcountbt,
 		.has	= xfs_sb_version_hasreflink,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_INODE] = {	/* inode record */
 		.type	= ST_INODE,
-		.setup	= xfs_scrub_setup_inode,
-		.scrub	= xfs_scrub_inode,
+		.setup	= xchk_setup_inode,
+		.scrub	= xchk_inode,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_BMBTD] = {	/* inode data fork */
 		.type	= ST_INODE,
-		.setup	= xfs_scrub_setup_inode_bmap,
-		.scrub	= xfs_scrub_bmap_data,
+		.setup	= xchk_setup_inode_bmap,
+		.scrub	= xchk_bmap_data,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_BMBTA] = {	/* inode attr fork */
 		.type	= ST_INODE,
-		.setup	= xfs_scrub_setup_inode_bmap,
-		.scrub	= xfs_scrub_bmap_attr,
+		.setup	= xchk_setup_inode_bmap,
+		.scrub	= xchk_bmap_attr,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_BMBTC] = {	/* inode CoW fork */
 		.type	= ST_INODE,
-		.setup	= xfs_scrub_setup_inode_bmap,
-		.scrub	= xfs_scrub_bmap_cow,
+		.setup	= xchk_setup_inode_bmap,
+		.scrub	= xchk_bmap_cow,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_DIR] = {	/* directory */
 		.type	= ST_INODE,
-		.setup	= xfs_scrub_setup_directory,
-		.scrub	= xfs_scrub_directory,
+		.setup	= xchk_setup_directory,
+		.scrub	= xchk_directory,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_XATTR] = {	/* extended attributes */
 		.type	= ST_INODE,
-		.setup	= xfs_scrub_setup_xattr,
-		.scrub	= xfs_scrub_xattr,
+		.setup	= xchk_setup_xattr,
+		.scrub	= xchk_xattr,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_SYMLINK] = {	/* symbolic link */
 		.type	= ST_INODE,
-		.setup	= xfs_scrub_setup_symlink,
-		.scrub	= xfs_scrub_symlink,
+		.setup	= xchk_setup_symlink,
+		.scrub	= xchk_symlink,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_PARENT] = {	/* parent pointers */
 		.type	= ST_INODE,
-		.setup	= xfs_scrub_setup_parent,
-		.scrub	= xfs_scrub_parent,
+		.setup	= xchk_setup_parent,
+		.scrub	= xchk_parent,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RTBITMAP] = {	/* realtime bitmap */
 		.type	= ST_FS,
-		.setup	= xfs_scrub_setup_rt,
-		.scrub	= xfs_scrub_rtbitmap,
+		.setup	= xchk_setup_rt,
+		.scrub	= xchk_rtbitmap,
 		.has	= xfs_sb_version_hasrealtime,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
 		.type	= ST_FS,
-		.setup	= xfs_scrub_setup_rt,
-		.scrub	= xfs_scrub_rtsummary,
+		.setup	= xchk_setup_rt,
+		.scrub	= xchk_rtsummary,
 		.has	= xfs_sb_version_hasrealtime,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */
 		.type	= ST_FS,
-		.setup	= xfs_scrub_setup_quota,
-		.scrub	= xfs_scrub_quota,
+		.setup	= xchk_setup_quota,
+		.scrub	= xchk_quota,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_GQUOTA] = {	/* group quota */
 		.type	= ST_FS,
-		.setup	= xfs_scrub_setup_quota,
-		.scrub	= xfs_scrub_quota,
+		.setup	= xchk_setup_quota,
+		.scrub	= xchk_quota,
 		.repair	= xfs_repair_notsupported,
 	},
 	[XFS_SCRUB_TYPE_PQUOTA] = {	/* project quota */
 		.type	= ST_FS,
-		.setup	= xfs_scrub_setup_quota,
-		.scrub	= xfs_scrub_quota,
+		.setup	= xchk_setup_quota,
+		.scrub	= xchk_quota,
 		.repair	= xfs_repair_notsupported,
 	},
 };
 
 /* This isn't a stable feature, warn once per day. */
 static inline void
-xfs_scrub_experimental_warning(
+xchk_experimental_warning(
 	struct xfs_mount	*mp)
 {
 	static struct ratelimit_state scrub_warning = RATELIMIT_STATE_INIT(
-			"xfs_scrub_warning", 86400 * HZ, 1);
+			"xchk_warning", 86400 * HZ, 1);
 	ratelimit_set_flags(&scrub_warning, RATELIMIT_MSG_ON_RELEASE);
 
 	if (__ratelimit(&scrub_warning))
@@ -358,12 +364,12 @@ xfs_scrub_experimental_warning(
 }
 
 static int
-xfs_scrub_validate_inputs(
+xchk_validate_inputs(
 	struct xfs_mount		*mp,
 	struct xfs_scrub_metadata	*sm)
 {
 	int				error;
-	const struct xfs_scrub_meta_ops	*ops;
+	const struct xchk_meta_ops	*ops;
 
 	error = -EINVAL;
 	/* Check our inputs. */
@@ -441,7 +447,7 @@ xfs_scrub_validate_inputs(
 }
 
 #ifdef CONFIG_XFS_ONLINE_REPAIR
-static inline void xfs_scrub_postmortem(struct xfs_scrub_context *sc)
+static inline void xchk_postmortem(struct xfs_scrub_context *sc)
 {
 	/*
 	 * Userspace asked us to repair something, we repaired it, rescanned
@@ -454,7 +460,7 @@ static inline void xfs_scrub_postmortem(struct xfs_scrub_context *sc)
 		xfs_repair_failure(sc->mp);
 }
 #else
-static inline void xfs_scrub_postmortem(struct xfs_scrub_context *sc)
+static inline void xchk_postmortem(struct xfs_scrub_context *sc)
 {
 	/*
 	 * Userspace asked us to scrub something, it's broken, and we have no
@@ -480,9 +486,9 @@ xfs_scrub_metadata(
 	int				error = 0;
 
 	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
-		(sizeof(struct xfs_scrub_meta_ops) * XFS_SCRUB_TYPE_NR));
+		(sizeof(struct xchk_meta_ops) * XFS_SCRUB_TYPE_NR));
 
-	trace_xfs_scrub_start(ip, sm, error);
+	trace_xchk_start(ip, sm, error);
 
 	/* Forbidden if we are shut down or mounted norecovery. */
 	error = -ESHUTDOWN;
@@ -492,11 +498,11 @@ xfs_scrub_metadata(
 	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
 		goto out;
 
-	error = xfs_scrub_validate_inputs(mp, sm);
+	error = xchk_validate_inputs(mp, sm);
 	if (error)
 		goto out;
 
-	xfs_scrub_experimental_warning(mp);
+	xchk_experimental_warning(mp);
 
 retry_op:
 	/* Set up for the operation. */
@@ -518,7 +524,7 @@ xfs_scrub_metadata(
 		 * Tear down everything we hold, then set up again with
 		 * preparation for worst-case scenarios.
 		 */
-		error = xfs_scrub_teardown(&sc, ip, 0);
+		error = xchk_teardown(&sc, ip, 0);
 		if (error)
 			goto out;
 		try_harder = true;
@@ -553,7 +559,7 @@ xfs_scrub_metadata(
 		if (error == -EAGAIN) {
 			if (sc.try_harder)
 				try_harder = true;
-			error = xfs_scrub_teardown(&sc, ip, 0);
+			error = xchk_teardown(&sc, ip, 0);
 			if (error) {
 				xfs_repair_failure(mp);
 				goto out;
@@ -563,11 +569,11 @@ xfs_scrub_metadata(
 	}
 
 out_nofix:
-	xfs_scrub_postmortem(&sc);
+	xchk_postmortem(&sc);
 out_teardown:
-	error = xfs_scrub_teardown(&sc, ip, error);
+	error = xchk_teardown(&sc, ip, error);
 out:
-	trace_xfs_scrub_done(ip, sm, error);
+	trace_xchk_done(ip, sm, error);
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC) {
 		sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		error = 0;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index b295edd5fc0e..0f59a47c4bb0 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -9,14 +9,14 @@
 struct xfs_scrub_context;
 
 /* Type info and names for the scrub types. */
-enum xfs_scrub_type {
+enum xchk_type {
 	ST_NONE = 1,	/* disabled */
 	ST_PERAG,	/* per-AG metadata */
 	ST_FS,		/* per-FS metadata */
 	ST_INODE,	/* per-inode metadata */
 };
 
-struct xfs_scrub_meta_ops {
+struct xchk_meta_ops {
 	/* Acquire whatever resources are needed for the operation. */
 	int		(*setup)(struct xfs_scrub_context *,
 				 struct xfs_inode *);
@@ -31,11 +31,11 @@ struct xfs_scrub_meta_ops {
 	bool		(*has)(struct xfs_sb *);
 
 	/* type describing required/allowed inputs */
-	enum xfs_scrub_type	type;
+	enum xchk_type	type;
 };
 
 /* Buffer pointers and btree cursors for an entire AG. */
-struct xfs_scrub_ag {
+struct xchk_ag {
 	xfs_agnumber_t			agno;
 	struct xfs_perag		*pag;
 
@@ -57,7 +57,7 @@ struct xfs_scrub_context {
 	/* General scrub state. */
 	struct xfs_mount		*mp;
 	struct xfs_scrub_metadata	*sm;
-	const struct xfs_scrub_meta_ops	*ops;
+	const struct xchk_meta_ops	*ops;
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip;
 	void				*buf;
@@ -66,78 +66,78 @@ struct xfs_scrub_context {
 	bool				has_quotaofflock;
 
 	/* State tracking for single-AG operations. */
-	struct xfs_scrub_ag		sa;
+	struct xchk_ag		sa;
 };
 
 /* Metadata scrubbers */
-int xfs_scrub_tester(struct xfs_scrub_context *sc);
-int xfs_scrub_superblock(struct xfs_scrub_context *sc);
-int xfs_scrub_agf(struct xfs_scrub_context *sc);
-int xfs_scrub_agfl(struct xfs_scrub_context *sc);
-int xfs_scrub_agi(struct xfs_scrub_context *sc);
-int xfs_scrub_bnobt(struct xfs_scrub_context *sc);
-int xfs_scrub_cntbt(struct xfs_scrub_context *sc);
-int xfs_scrub_inobt(struct xfs_scrub_context *sc);
-int xfs_scrub_finobt(struct xfs_scrub_context *sc);
-int xfs_scrub_rmapbt(struct xfs_scrub_context *sc);
-int xfs_scrub_refcountbt(struct xfs_scrub_context *sc);
-int xfs_scrub_inode(struct xfs_scrub_context *sc);
-int xfs_scrub_bmap_data(struct xfs_scrub_context *sc);
-int xfs_scrub_bmap_attr(struct xfs_scrub_context *sc);
-int xfs_scrub_bmap_cow(struct xfs_scrub_context *sc);
-int xfs_scrub_directory(struct xfs_scrub_context *sc);
-int xfs_scrub_xattr(struct xfs_scrub_context *sc);
-int xfs_scrub_symlink(struct xfs_scrub_context *sc);
-int xfs_scrub_parent(struct xfs_scrub_context *sc);
+int xchk_tester(struct xfs_scrub_context *sc);
+int xchk_superblock(struct xfs_scrub_context *sc);
+int xchk_agf(struct xfs_scrub_context *sc);
+int xchk_agfl(struct xfs_scrub_context *sc);
+int xchk_agi(struct xfs_scrub_context *sc);
+int xchk_bnobt(struct xfs_scrub_context *sc);
+int xchk_cntbt(struct xfs_scrub_context *sc);
+int xchk_inobt(struct xfs_scrub_context *sc);
+int xchk_finobt(struct xfs_scrub_context *sc);
+int xchk_rmapbt(struct xfs_scrub_context *sc);
+int xchk_refcountbt(struct xfs_scrub_context *sc);
+int xchk_inode(struct xfs_scrub_context *sc);
+int xchk_bmap_data(struct xfs_scrub_context *sc);
+int xchk_bmap_attr(struct xfs_scrub_context *sc);
+int xchk_bmap_cow(struct xfs_scrub_context *sc);
+int xchk_directory(struct xfs_scrub_context *sc);
+int xchk_xattr(struct xfs_scrub_context *sc);
+int xchk_symlink(struct xfs_scrub_context *sc);
+int xchk_parent(struct xfs_scrub_context *sc);
 #ifdef CONFIG_XFS_RT
-int xfs_scrub_rtbitmap(struct xfs_scrub_context *sc);
-int xfs_scrub_rtsummary(struct xfs_scrub_context *sc);
+int xchk_rtbitmap(struct xfs_scrub_context *sc);
+int xchk_rtsummary(struct xfs_scrub_context *sc);
 #else
 static inline int
-xfs_scrub_rtbitmap(struct xfs_scrub_context *sc)
+xchk_rtbitmap(struct xfs_scrub_context *sc)
 {
 	return -ENOENT;
 }
 static inline int
-xfs_scrub_rtsummary(struct xfs_scrub_context *sc)
+xchk_rtsummary(struct xfs_scrub_context *sc)
 {
 	return -ENOENT;
 }
 #endif
 #ifdef CONFIG_XFS_QUOTA
-int xfs_scrub_quota(struct xfs_scrub_context *sc);
+int xchk_quota(struct xfs_scrub_context *sc);
 #else
 static inline int
-xfs_scrub_quota(struct xfs_scrub_context *sc)
+xchk_quota(struct xfs_scrub_context *sc)
 {
 	return -ENOENT;
 }
 #endif
 
 /* cross-referencing helpers */
-void xfs_scrub_xref_is_used_space(struct xfs_scrub_context *sc,
+void xchk_xref_is_used_space(struct xfs_scrub_context *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len);
-void xfs_scrub_xref_is_not_inode_chunk(struct xfs_scrub_context *sc,
+void xchk_xref_is_not_inode_chunk(struct xfs_scrub_context *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len);
-void xfs_scrub_xref_is_inode_chunk(struct xfs_scrub_context *sc,
+void xchk_xref_is_inode_chunk(struct xfs_scrub_context *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len);
-void xfs_scrub_xref_is_owned_by(struct xfs_scrub_context *sc,
+void xchk_xref_is_owned_by(struct xfs_scrub_context *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len,
 		struct xfs_owner_info *oinfo);
-void xfs_scrub_xref_is_not_owned_by(struct xfs_scrub_context *sc,
+void xchk_xref_is_not_owned_by(struct xfs_scrub_context *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len,
 		struct xfs_owner_info *oinfo);
-void xfs_scrub_xref_has_no_owner(struct xfs_scrub_context *sc,
+void xchk_xref_has_no_owner(struct xfs_scrub_context *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len);
-void xfs_scrub_xref_is_cow_staging(struct xfs_scrub_context *sc,
+void xchk_xref_is_cow_staging(struct xfs_scrub_context *sc,
 		xfs_agblock_t bno, xfs_extlen_t len);
-void xfs_scrub_xref_is_not_shared(struct xfs_scrub_context *sc,
+void xchk_xref_is_not_shared(struct xfs_scrub_context *sc,
 		xfs_agblock_t bno, xfs_extlen_t len);
 #ifdef CONFIG_XFS_RT
-void xfs_scrub_xref_is_used_rt_space(struct xfs_scrub_context *sc,
+void xchk_xref_is_used_rt_space(struct xfs_scrub_context *sc,
 		xfs_rtblock_t rtbno, xfs_extlen_t len);
 #else
-# define xfs_scrub_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
+# define xchk_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
 #endif
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 570a89812116..e2a288e34337 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -25,7 +25,7 @@
 
 /* Set us up to scrub a symbolic link. */
 int
-xfs_scrub_setup_symlink(
+xchk_setup_symlink(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
@@ -34,13 +34,13 @@ xfs_scrub_setup_symlink(
 	if (!sc->buf)
 		return -ENOMEM;
 
-	return xfs_scrub_setup_inode_contents(sc, ip, 0);
+	return xchk_setup_inode_contents(sc, ip, 0);
 }
 
 /* Symbolic links. */
 
 int
-xfs_scrub_symlink(
+xchk_symlink(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_inode		*ip = sc->ip;
@@ -55,7 +55,7 @@ xfs_scrub_symlink(
 
 	/* Plausible size? */
 	if (len > XFS_SYMLINK_MAXLEN || len <= 0) {
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out;
 	}
 
@@ -63,16 +63,16 @@ xfs_scrub_symlink(
 	if (ifp->if_flags & XFS_IFINLINE) {
 		if (len > XFS_IFORK_DSIZE(ip) ||
 		    len > strnlen(ifp->if_u1.if_data, XFS_IFORK_DSIZE(ip)))
-			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out;
 	}
 
 	/* Remote symlink; must read the contents. */
 	error = xfs_readlink_bmap_ilocked(sc->ip, sc->buf);
-	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
 	if (strnlen(sc->buf, XFS_SYMLINK_MAXLEN) < len)
-		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 7c76d8b5cb05..1ef1202a1e45 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -22,7 +22,7 @@
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
-xfs_scrub_btree_cur_fsbno(
+xchk_btree_cur_fsbno(
 	struct xfs_btree_cur		*cur,
 	int				level)
 {
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cec3e5ece5a1..11967d3942ac 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -12,7 +12,7 @@
 #include <linux/tracepoint.h>
 #include "xfs_bit.h"
 
-DECLARE_EVENT_CLASS(xfs_scrub_class,
+DECLARE_EVENT_CLASS(xchk_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),
 	TP_ARGS(ip, sm, error),
@@ -47,18 +47,18 @@ DECLARE_EVENT_CLASS(xfs_scrub_class,
 		  __entry->error)
 )
 #define DEFINE_SCRUB_EVENT(name) \
-DEFINE_EVENT(xfs_scrub_class, name, \
+DEFINE_EVENT(xchk_class, name, \
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm, \
 		 int error), \
 	TP_ARGS(ip, sm, error))
 
-DEFINE_SCRUB_EVENT(xfs_scrub_start);
-DEFINE_SCRUB_EVENT(xfs_scrub_done);
-DEFINE_SCRUB_EVENT(xfs_scrub_deadlock_retry);
+DEFINE_SCRUB_EVENT(xchk_start);
+DEFINE_SCRUB_EVENT(xchk_done);
+DEFINE_SCRUB_EVENT(xchk_deadlock_retry);
 DEFINE_SCRUB_EVENT(xfs_repair_attempt);
 DEFINE_SCRUB_EVENT(xfs_repair_done);
 
-TRACE_EVENT(xfs_scrub_op_error,
+TRACE_EVENT(xchk_op_error,
 	TP_PROTO(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 		 xfs_agblock_t bno, int error, void *ret_ip),
 	TP_ARGS(sc, agno, bno, error, ret_ip),
@@ -87,7 +87,7 @@ TRACE_EVENT(xfs_scrub_op_error,
 		  __entry->ret_ip)
 );
 
-TRACE_EVENT(xfs_scrub_file_op_error,
+TRACE_EVENT(xchk_file_op_error,
 	TP_PROTO(struct xfs_scrub_context *sc, int whichfork,
 		 xfs_fileoff_t offset, int error, void *ret_ip),
 	TP_ARGS(sc, whichfork, offset, error, ret_ip),
@@ -119,7 +119,7 @@ TRACE_EVENT(xfs_scrub_file_op_error,
 		  __entry->ret_ip)
 );
 
-DECLARE_EVENT_CLASS(xfs_scrub_block_error_class,
+DECLARE_EVENT_CLASS(xchk_block_error_class,
 	TP_PROTO(struct xfs_scrub_context *sc, xfs_daddr_t daddr, void *ret_ip),
 	TP_ARGS(sc, daddr, ret_ip),
 	TP_STRUCT__entry(
@@ -153,15 +153,15 @@ DECLARE_EVENT_CLASS(xfs_scrub_block_error_class,
 )
 
 #define DEFINE_SCRUB_BLOCK_ERROR_EVENT(name) \
-DEFINE_EVENT(xfs_scrub_block_error_class, name, \
+DEFINE_EVENT(xchk_block_error_class, name, \
 	TP_PROTO(struct xfs_scrub_context *sc, xfs_daddr_t daddr, \
 		 void *ret_ip), \
 	TP_ARGS(sc, daddr, ret_ip))
 
-DEFINE_SCRUB_BLOCK_ERROR_EVENT(xfs_scrub_block_error);
-DEFINE_SCRUB_BLOCK_ERROR_EVENT(xfs_scrub_block_preen);
+DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_block_error);
+DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_block_preen);
 
-DECLARE_EVENT_CLASS(xfs_scrub_ino_error_class,
+DECLARE_EVENT_CLASS(xchk_ino_error_class,
 	TP_PROTO(struct xfs_scrub_context *sc, xfs_ino_t ino, void *ret_ip),
 	TP_ARGS(sc, ino, ret_ip),
 	TP_STRUCT__entry(
@@ -184,16 +184,16 @@ DECLARE_EVENT_CLASS(xfs_scrub_ino_error_class,
 )
 
 #define DEFINE_SCRUB_INO_ERROR_EVENT(name) \
-DEFINE_EVENT(xfs_scrub_ino_error_class, name, \
+DEFINE_EVENT(xchk_ino_error_class, name, \
 	TP_PROTO(struct xfs_scrub_context *sc, xfs_ino_t ino, \
 		 void *ret_ip), \
 	TP_ARGS(sc, ino, ret_ip))
 
-DEFINE_SCRUB_INO_ERROR_EVENT(xfs_scrub_ino_error);
-DEFINE_SCRUB_INO_ERROR_EVENT(xfs_scrub_ino_preen);
-DEFINE_SCRUB_INO_ERROR_EVENT(xfs_scrub_ino_warning);
+DEFINE_SCRUB_INO_ERROR_EVENT(xchk_ino_error);
+DEFINE_SCRUB_INO_ERROR_EVENT(xchk_ino_preen);
+DEFINE_SCRUB_INO_ERROR_EVENT(xchk_ino_warning);
 
-DECLARE_EVENT_CLASS(xfs_scrub_fblock_error_class,
+DECLARE_EVENT_CLASS(xchk_fblock_error_class,
 	TP_PROTO(struct xfs_scrub_context *sc, int whichfork,
 		 xfs_fileoff_t offset, void *ret_ip),
 	TP_ARGS(sc, whichfork, offset, ret_ip),
@@ -223,15 +223,15 @@ DECLARE_EVENT_CLASS(xfs_scrub_fblock_error_class,
 );
 
 #define DEFINE_SCRUB_FBLOCK_ERROR_EVENT(name) \
-DEFINE_EVENT(xfs_scrub_fblock_error_class, name, \
+DEFINE_EVENT(xchk_fblock_error_class, name, \
 	TP_PROTO(struct xfs_scrub_context *sc, int whichfork, \
 		 xfs_fileoff_t offset, void *ret_ip), \
 	TP_ARGS(sc, whichfork, offset, ret_ip))
 
-DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xfs_scrub_fblock_error);
-DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xfs_scrub_fblock_warning);
+DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_error);
+DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_warning);
 
-TRACE_EVENT(xfs_scrub_incomplete,
+TRACE_EVENT(xchk_incomplete,
 	TP_PROTO(struct xfs_scrub_context *sc, void *ret_ip),
 	TP_ARGS(sc, ret_ip),
 	TP_STRUCT__entry(
@@ -250,7 +250,7 @@ TRACE_EVENT(xfs_scrub_incomplete,
 		  __entry->ret_ip)
 );
 
-TRACE_EVENT(xfs_scrub_btree_op_error,
+TRACE_EVENT(xchk_btree_op_error,
 	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
 		 int level, int error, void *ret_ip),
 	TP_ARGS(sc, cur, level, error, ret_ip),
@@ -266,7 +266,7 @@ TRACE_EVENT(xfs_scrub_btree_op_error,
 		__field(void *, ret_ip)
 	),
 	TP_fast_assign(
-		xfs_fsblock_t fsbno = xfs_scrub_btree_cur_fsbno(cur, level);
+		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->type = sc->sm->sm_type;
@@ -290,7 +290,7 @@ TRACE_EVENT(xfs_scrub_btree_op_error,
 		  __entry->ret_ip)
 );
 
-TRACE_EVENT(xfs_scrub_ifork_btree_op_error,
+TRACE_EVENT(xchk_ifork_btree_op_error,
 	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
 		 int level, int error, void *ret_ip),
 	TP_ARGS(sc, cur, level, error, ret_ip),
@@ -308,7 +308,7 @@ TRACE_EVENT(xfs_scrub_ifork_btree_op_error,
 		__field(void *, ret_ip)
 	),
 	TP_fast_assign(
-		xfs_fsblock_t fsbno = xfs_scrub_btree_cur_fsbno(cur, level);
+		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->ino = sc->ip->i_ino;
 		__entry->whichfork = cur->bc_private.b.whichfork;
@@ -335,7 +335,7 @@ TRACE_EVENT(xfs_scrub_ifork_btree_op_error,
 		  __entry->ret_ip)
 );
 
-TRACE_EVENT(xfs_scrub_btree_error,
+TRACE_EVENT(xchk_btree_error,
 	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
 		 int level, void *ret_ip),
 	TP_ARGS(sc, cur, level, ret_ip),
@@ -350,7 +350,7 @@ TRACE_EVENT(xfs_scrub_btree_error,
 		__field(void *, ret_ip)
 	),
 	TP_fast_assign(
-		xfs_fsblock_t fsbno = xfs_scrub_btree_cur_fsbno(cur, level);
+		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->type = sc->sm->sm_type;
 		__entry->btnum = cur->bc_btnum;
@@ -371,7 +371,7 @@ TRACE_EVENT(xfs_scrub_btree_error,
 		  __entry->ret_ip)
 );
 
-TRACE_EVENT(xfs_scrub_ifork_btree_error,
+TRACE_EVENT(xchk_ifork_btree_error,
 	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
 		 int level, void *ret_ip),
 	TP_ARGS(sc, cur, level, ret_ip),
@@ -388,7 +388,7 @@ TRACE_EVENT(xfs_scrub_ifork_btree_error,
 		__field(void *, ret_ip)
 	),
 	TP_fast_assign(
-		xfs_fsblock_t fsbno = xfs_scrub_btree_cur_fsbno(cur, level);
+		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->ino = sc->ip->i_ino;
 		__entry->whichfork = cur->bc_private.b.whichfork;
@@ -413,7 +413,7 @@ TRACE_EVENT(xfs_scrub_ifork_btree_error,
 		  __entry->ret_ip)
 );
 
-DECLARE_EVENT_CLASS(xfs_scrub_sbtree_class,
+DECLARE_EVENT_CLASS(xchk_sbtree_class,
 	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
 		 int level),
 	TP_ARGS(sc, cur, level),
@@ -428,7 +428,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_sbtree_class,
 		__field(int, ptr)
 	),
 	TP_fast_assign(
-		xfs_fsblock_t fsbno = xfs_scrub_btree_cur_fsbno(cur, level);
+		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->type = sc->sm->sm_type;
@@ -450,15 +450,15 @@ DECLARE_EVENT_CLASS(xfs_scrub_sbtree_class,
 		  __entry->ptr)
 )
 #define DEFINE_SCRUB_SBTREE_EVENT(name) \
-DEFINE_EVENT(xfs_scrub_sbtree_class, name, \
+DEFINE_EVENT(xchk_sbtree_class, name, \
 	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur, \
 		 int level), \
 	TP_ARGS(sc, cur, level))
 
-DEFINE_SCRUB_SBTREE_EVENT(xfs_scrub_btree_rec);
-DEFINE_SCRUB_SBTREE_EVENT(xfs_scrub_btree_key);
+DEFINE_SCRUB_SBTREE_EVENT(xchk_btree_rec);
+DEFINE_SCRUB_SBTREE_EVENT(xchk_btree_key);
 
-TRACE_EVENT(xfs_scrub_xref_error,
+TRACE_EVENT(xchk_xref_error,
 	TP_PROTO(struct xfs_scrub_context *sc, int error, void *ret_ip),
 	TP_ARGS(sc, error, ret_ip),
 	TP_STRUCT__entry(


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40222 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757161AbdLWBOH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:14:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN1CiuD079635
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:07 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2f1cvd81p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:05 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN17iWD010706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:07:44 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBN17hkT009239
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:07:43 GMT
Subject: [PATCH 06/20] xfs: have buffer verifier functions report failing
 address
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:07:41 -0800
Message-ID: <151399126186.23543.3819575446280820300.stgit@magnolia>
In-Reply-To: <151399122361.23543.15718507168231759645.stgit@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Modify each function that checks the contents of a metadata buffer to
return the instruction address of the failing test so that we can report
more precise failure errors to the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |   43 ++++++++++---------
 fs/xfs/libxfs/xfs_alloc_btree.c    |   27 +++++++-----
 fs/xfs/libxfs/xfs_attr_leaf.c      |   20 ++++-----
 fs/xfs/libxfs/xfs_attr_remote.c    |   36 ++++++++--------
 fs/xfs/libxfs/xfs_bmap_btree.c     |   16 ++++---
 fs/xfs/libxfs/xfs_btree.c          |   46 ++++++++++----------
 fs/xfs/libxfs/xfs_btree.h          |   11 +++--
 fs/xfs/libxfs/xfs_da_btree.c       |   26 ++++++-----
 fs/xfs/libxfs/xfs_dir2_block.c     |   16 +++----
 fs/xfs/libxfs/xfs_dir2_data.c      |   83 ++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_dir2_leaf.c      |   55 ++++++++++++++----------
 fs/xfs/libxfs/xfs_dir2_node.c      |   61 +++++++++++++++-----------
 fs/xfs/libxfs/xfs_dir2_priv.h      |   16 +++----
 fs/xfs/libxfs/xfs_ialloc.c         |   22 +++++-----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   16 ++++---
 fs/xfs/libxfs/xfs_inode_buf.c      |   36 ++++++++--------
 fs/xfs/libxfs/xfs_inode_buf.h      |    4 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   20 +++++----
 fs/xfs/libxfs/xfs_rmap_btree.c     |   20 +++++----
 fs/xfs/libxfs/xfs_symlink_remote.c |   22 +++++-----
 fs/xfs/scrub/inode.c               |    2 -
 21 files changed, 323 insertions(+), 275 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c4bab34..e730aca 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -520,7 +520,7 @@ xfs_alloc_fixup_trees(
 	return 0;
 }
 
-static bool
+static xfs_failaddr_t
 xfs_agfl_verify(
 	struct xfs_buf	*bp)
 {
@@ -529,9 +529,9 @@ xfs_agfl_verify(
 	int		i;
 
 	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
-		return false;
+		return __this_address;
 	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
-		return false;
+		return __this_address;
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
@@ -539,16 +539,17 @@ xfs_agfl_verify(
 	 * so we can detect and avoid this problem.
 	 */
 	if (bp->b_pag && be32_to_cpu(agfl->agfl_seqno) != bp->b_pag->pag_agno)
-		return false;
+		return __this_address;
 
 	for (i = 0; i < XFS_AGFL_SIZE(mp); i++) {
 		if (be32_to_cpu(agfl->agfl_bno[i]) != NULLAGBLOCK &&
 		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
-			return false;
+			return __this_address;
 	}
 
-	return xfs_log_check_lsn(mp,
-				 be64_to_cpu(XFS_BUF_TO_AGFL(bp)->agfl_lsn));
+	if (!xfs_log_check_lsn(mp, be64_to_cpu(XFS_BUF_TO_AGFL(bp)->agfl_lsn)))
+		return __this_address;
+	return NULL;
 }
 
 static void
@@ -568,7 +569,7 @@ xfs_agfl_read_verify(
 
 	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (!xfs_agfl_verify(bp))
+	else if (xfs_agfl_verify(bp))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 }
 
@@ -583,7 +584,7 @@ xfs_agfl_write_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_agfl_verify(bp)) {
+	if (xfs_agfl_verify(bp)) {
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
 	}
@@ -2393,7 +2394,7 @@ xfs_alloc_put_freelist(
 	return 0;
 }
 
-static bool
+static xfs_failaddr_t
 xfs_agf_verify(
 	struct xfs_mount *mp,
 	struct xfs_buf	*bp)
@@ -2402,10 +2403,10 @@ xfs_agf_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
+			return __this_address;
 		if (!xfs_log_check_lsn(mp,
 				be64_to_cpu(XFS_BUF_TO_AGF(bp)->agf_lsn)))
-			return false;
+			return __this_address;
 	}
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
@@ -2414,18 +2415,18 @@ xfs_agf_verify(
 	      be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
 	      be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
 	      be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp)))
-		return false;
+		return __this_address;
 
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > XFS_BTREE_MAXLEVELS)
-		return false;
+		return __this_address;
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
 	    (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
 	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS))
-		return false;
+		return __this_address;
 
 	/*
 	 * during growfs operations, the perag is not fully initialised,
@@ -2434,18 +2435,18 @@ xfs_agf_verify(
 	 * so we can detect and avoid this problem.
 	 */
 	if (bp->b_pag && be32_to_cpu(agf->agf_seqno) != bp->b_pag->pag_agno)
-		return false;
+		return __this_address;
 
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
-		return false;
+		return __this_address;
 
 	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
 	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
 	     be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS))
-		return false;
+		return __this_address;
 
-	return true;;
+	return NULL;
 
 }
 
@@ -2458,7 +2459,7 @@ xfs_agf_read_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (XFS_TEST_ERROR(!xfs_agf_verify(mp, bp), mp,
+	else if (XFS_TEST_ERROR(xfs_agf_verify(mp, bp), mp,
 				XFS_ERRTAG_ALLOC_READ_AGF))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 }
@@ -2470,7 +2471,7 @@ xfs_agf_write_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
-	if (!xfs_agf_verify(mp, bp)) {
+	if (xfs_agf_verify(mp, bp)) {
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
 	}
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 752d6aa..4383c05 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -307,13 +307,14 @@ xfs_cntbt_diff_two_keys(
 		be32_to_cpu(k2->alloc.ar_startblock);
 }
 
-static bool
+static xfs_failaddr_t
 xfs_allocbt_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
+	xfs_failaddr_t		fa;
 	unsigned int		level;
 
 	/*
@@ -331,29 +332,31 @@ xfs_allocbt_verify(
 	level = be16_to_cpu(block->bb_level);
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
-		if (!xfs_btree_sblock_v5hdr_verify(bp))
-			return false;
+		fa = xfs_btree_sblock_v5hdr_verify(bp);
+		if (fa)
+			return fa;
 		/* fall through */
 	case cpu_to_be32(XFS_ABTB_MAGIC):
 		if (pag && pag->pagf_init) {
 			if (level >= pag->pagf_levels[XFS_BTNUM_BNOi])
-				return false;
+				return __this_address;
 		} else if (level >= mp->m_ag_maxlevels)
-			return false;
+			return __this_address;
 		break;
 	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
-		if (!xfs_btree_sblock_v5hdr_verify(bp))
-			return false;
+		fa = xfs_btree_sblock_v5hdr_verify(bp);
+		if (fa)
+			return fa;
 		/* fall through */
 	case cpu_to_be32(XFS_ABTC_MAGIC):
 		if (pag && pag->pagf_init) {
 			if (level >= pag->pagf_levels[XFS_BTNUM_CNTi])
-				return false;
+				return __this_address;
 		} else if (level >= mp->m_ag_maxlevels)
-			return false;
+			return __this_address;
 		break;
 	default:
-		return false;
+		return __this_address;
 	}
 
 	return xfs_btree_sblock_verify(bp, mp->m_alloc_mxr[level != 0]);
@@ -365,7 +368,7 @@ xfs_allocbt_read_verify(
 {
 	if (!xfs_btree_sblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (!xfs_allocbt_verify(bp))
+	else if (xfs_allocbt_verify(bp))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
@@ -376,7 +379,7 @@ static void
 xfs_allocbt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (!xfs_allocbt_verify(bp)) {
+	if (xfs_allocbt_verify(bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6a9805a..f6281e1 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -247,7 +247,7 @@ xfs_attr3_leaf_hdr_to_disk(
 	}
 }
 
-static bool
+static xfs_failaddr_t
 xfs_attr3_leaf_verify(
 	struct xfs_buf		*bp)
 {
@@ -262,17 +262,17 @@ xfs_attr3_leaf_verify(
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
 		if (ichdr.magic != XFS_ATTR3_LEAF_MAGIC)
-			return false;
+			return __this_address;
 
 		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
+			return __this_address;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
-			return false;
+			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
-			return false;
+			return __this_address;
 	} else {
 		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
-			return false;
+			return __this_address;
 	}
 	/*
 	 * In recovery there is a transient state where count == 0 is valid
@@ -280,12 +280,12 @@ xfs_attr3_leaf_verify(
 	 * if the attr didn't fit in shortform.
 	 */
 	if (pag && pag->pagf_init && ichdr.count == 0)
-		return false;
+		return __this_address;
 
 	/* XXX: need to range check rest of attr header values */
 	/* XXX: hash order check? */
 
-	return true;
+	return NULL;
 }
 
 static void
@@ -296,7 +296,7 @@ xfs_attr3_leaf_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_attr3_leaf_hdr *hdr3 = bp->b_addr;
 
-	if (!xfs_attr3_leaf_verify(bp)) {
+	if (xfs_attr3_leaf_verify(bp)) {
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
 	}
@@ -325,7 +325,7 @@ xfs_attr3_leaf_read_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (!xfs_attr3_leaf_verify(bp))
+	else if (xfs_attr3_leaf_verify(bp))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 231b569..06858db 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -65,7 +65,7 @@ xfs_attr3_rmt_blocks(
  * does CRC, location and bounds checking, the unpacking function checks the
  * attribute parameters and owner.
  */
-static bool
+static xfs_failaddr_t
 xfs_attr3_rmt_hdr_ok(
 	void			*ptr,
 	xfs_ino_t		ino,
@@ -76,19 +76,19 @@ xfs_attr3_rmt_hdr_ok(
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
 	if (bno != be64_to_cpu(rmt->rm_blkno))
-		return false;
+		return __this_address;
 	if (offset != be32_to_cpu(rmt->rm_offset))
-		return false;
+		return __this_address;
 	if (size != be32_to_cpu(rmt->rm_bytes))
-		return false;
+		return __this_address;
 	if (ino != be64_to_cpu(rmt->rm_owner))
-		return false;
+		return __this_address;
 
 	/* ok */
-	return true;
+	return NULL;
 }
 
-static bool
+static xfs_failaddr_t
 xfs_attr3_rmt_verify(
 	struct xfs_mount	*mp,
 	void			*ptr,
@@ -98,22 +98,22 @@ xfs_attr3_rmt_verify(
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return false;
+		return __this_address;
 	if (rmt->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
-		return false;
+		return __this_address;
 	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid))
-		return false;
+		return __this_address;
 	if (be64_to_cpu(rmt->rm_blkno) != bno)
-		return false;
+		return __this_address;
 	if (be32_to_cpu(rmt->rm_bytes) > fsbsize - sizeof(*rmt))
-		return false;
+		return __this_address;
 	if (be32_to_cpu(rmt->rm_offset) +
 				be32_to_cpu(rmt->rm_bytes) > XFS_XATTR_SIZE_MAX)
-		return false;
+		return __this_address;
 	if (rmt->rm_owner == 0)
-		return false;
+		return __this_address;
 
-	return true;
+	return NULL;
 }
 
 static void
@@ -140,7 +140,7 @@ xfs_attr3_rmt_read_verify(
 			xfs_verifier_error(bp, -EFSBADCRC);
 			return;
 		}
-		if (!xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
+		if (xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
 			xfs_verifier_error(bp, -EFSCORRUPTED);
 			return;
 		}
@@ -175,7 +175,7 @@ xfs_attr3_rmt_write_verify(
 	while (len > 0) {
 		struct xfs_attr3_rmt_hdr *rmt = (struct xfs_attr3_rmt_hdr *)ptr;
 
-		if (!xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
+		if (xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
 			xfs_verifier_error(bp, -EFSCORRUPTED);
 			return;
 		}
@@ -267,7 +267,7 @@ xfs_attr_rmtval_copyout(
 		byte_cnt = min(*valuelen, byte_cnt);
 
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
-			if (!xfs_attr3_rmt_hdr_ok(src, ino, *offset,
+			if (xfs_attr3_rmt_hdr_ok(src, ino, *offset,
 						  byte_cnt, bno)) {
 				xfs_alert(mp,
 "remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)",
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index b6d61c7..0fdae57 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -425,12 +425,13 @@ xfs_bmbt_diff_two_keys(
 			  be64_to_cpu(k2->bmbt.br_startoff);
 }
 
-static bool
+static xfs_failaddr_t
 xfs_bmbt_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
 	unsigned int		level;
 
 	switch (block->bb_magic) {
@@ -439,13 +440,14 @@ xfs_bmbt_verify(
 		 * XXX: need a better way of verifying the owner here. Right now
 		 * just make sure there has been one set.
 		 */
-		if (!xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN))
-			return false;
+		fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+		if (fa)
+			return fa;
 		/* fall through */
 	case cpu_to_be32(XFS_BMAP_MAGIC):
 		break;
 	default:
-		return false;
+		return __this_address;
 	}
 
 	/*
@@ -457,7 +459,7 @@ xfs_bmbt_verify(
 	 */
 	level = be16_to_cpu(block->bb_level);
 	if (level > max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]))
-		return false;
+		return __this_address;
 
 	return xfs_btree_lblock_verify(bp, mp->m_bmap_dmxr[level != 0]);
 }
@@ -468,7 +470,7 @@ xfs_bmbt_read_verify(
 {
 	if (!xfs_btree_lblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (!xfs_bmbt_verify(bp))
+	else if (xfs_bmbt_verify(bp))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
@@ -479,7 +481,7 @@ static void
 xfs_bmbt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (!xfs_bmbt_verify(bp)) {
+	if (xfs_bmbt_verify(bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index be995ee..7455f8e 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -329,7 +329,7 @@ xfs_btree_sblock_verify_crc(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
-			return false;
+			return __this_address;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
 	}
 
@@ -4530,7 +4530,7 @@ xfs_btree_change_owner(
 }
 
 /* Verify the v5 fields of a long-format btree block. */
-bool
+xfs_failaddr_t
 xfs_btree_lblock_v5hdr_verify(
 	struct xfs_buf		*bp,
 	uint64_t		owner)
@@ -4539,19 +4539,19 @@ xfs_btree_lblock_v5hdr_verify(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return false;
+		return __this_address;
 	if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
-		return false;
+		return __this_address;
 	if (block->bb_u.l.bb_blkno != cpu_to_be64(bp->b_bn))
-		return false;
+		return __this_address;
 	if (owner != XFS_RMAP_OWN_UNKNOWN &&
 	    be64_to_cpu(block->bb_u.l.bb_owner) != owner)
-		return false;
-	return true;
+		return __this_address;
+	return NULL;
 }
 
 /* Verify a long-format btree block. */
-bool
+xfs_failaddr_t
 xfs_btree_lblock_verify(
 	struct xfs_buf		*bp,
 	unsigned int		max_recs)
@@ -4561,17 +4561,17 @@ xfs_btree_lblock_verify(
 
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
-		return false;
+		return __this_address;
 
 	/* sibling pointer verification */
 	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
 	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_leftsib)))
-		return false;
+		return __this_address;
 	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
 	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_rightsib)))
-		return false;
+		return __this_address;
 
-	return true;
+	return NULL;
 }
 
 /**
@@ -4582,7 +4582,7 @@ xfs_btree_lblock_verify(
  * @max_recs: pointer to the m_*_mxr max records field in the xfs mount
  * @pag_max_level: pointer to the per-ag max level field
  */
-bool
+xfs_failaddr_t
 xfs_btree_sblock_v5hdr_verify(
 	struct xfs_buf		*bp)
 {
@@ -4591,14 +4591,14 @@ xfs_btree_sblock_v5hdr_verify(
 	struct xfs_perag	*pag = bp->b_pag;
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return false;
+		return __this_address;
 	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
-		return false;
+		return __this_address;
 	if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
-		return false;
+		return __this_address;
 	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
-		return false;
-	return true;
+		return __this_address;
+	return NULL;
 }
 
 /**
@@ -4607,7 +4607,7 @@ xfs_btree_sblock_v5hdr_verify(
  * @bp: buffer containing the btree block
  * @max_recs: maximum records allowed in this btree node
  */
-bool
+xfs_failaddr_t
 xfs_btree_sblock_verify(
 	struct xfs_buf		*bp,
 	unsigned int		max_recs)
@@ -4618,18 +4618,18 @@ xfs_btree_sblock_verify(
 
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
-		return false;
+		return __this_address;
 
 	/* sibling pointer verification */
 	agno = xfs_daddr_to_agno(mp, XFS_BUF_ADDR(bp));
 	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
 	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_leftsib)))
-		return false;
+		return __this_address;
 	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
 	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_rightsib)))
-		return false;
+		return __this_address;
 
-	return true;
+	return NULL;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 6bf79ad..50440b5 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -492,10 +492,13 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
 #define XFS_BTREE_TRACE_ARGR(c, r)
 #define	XFS_BTREE_TRACE_CURSOR(c, t)
 
-bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
-bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
-bool xfs_btree_lblock_v5hdr_verify(struct xfs_buf *bp, uint64_t owner);
-bool xfs_btree_lblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+xfs_failaddr_t xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
+xfs_failaddr_t xfs_btree_sblock_verify(struct xfs_buf *bp,
+		unsigned int max_recs);
+xfs_failaddr_t xfs_btree_lblock_v5hdr_verify(struct xfs_buf *bp,
+		uint64_t owner);
+xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
+		unsigned int max_recs);
 
 uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
 				 unsigned long len);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 27b5ed3..60a2572 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -128,7 +128,7 @@ xfs_da_state_free(xfs_da_state_t *state)
 	kmem_zone_free(xfs_da_state_zone, state);
 }
 
-static bool
+static xfs_failaddr_t
 xfs_da3_node_verify(
 	struct xfs_buf		*bp)
 {
@@ -145,24 +145,24 @@ xfs_da3_node_verify(
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
 		if (ichdr.magic != XFS_DA3_NODE_MAGIC)
-			return false;
+			return __this_address;
 
 		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
+			return __this_address;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
-			return false;
+			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
-			return false;
+			return __this_address;
 	} else {
 		if (ichdr.magic != XFS_DA_NODE_MAGIC)
-			return false;
+			return __this_address;
 	}
 	if (ichdr.level == 0)
-		return false;
+		return __this_address;
 	if (ichdr.level > XFS_DA_NODE_MAXDEPTH)
-		return false;
+		return __this_address;
 	if (ichdr.count == 0)
-		return false;
+		return __this_address;
 
 	/*
 	 * we don't know if the node is for and attribute or directory tree,
@@ -170,11 +170,11 @@ xfs_da3_node_verify(
 	 */
 	if (ichdr.count > mp->m_dir_geo->node_ents &&
 	    ichdr.count > mp->m_attr_geo->node_ents)
-		return false;
+		return __this_address;
 
 	/* XXX: hash order check? */
 
-	return true;
+	return NULL;
 }
 
 static void
@@ -185,7 +185,7 @@ xfs_da3_node_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
-	if (!xfs_da3_node_verify(bp)) {
+	if (xfs_da3_node_verify(bp)) {
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
 	}
@@ -219,7 +219,7 @@ xfs_da3_node_read_verify(
 			}
 			/* fall through */
 		case XFS_DA_NODE_MAGIC:
-			if (!xfs_da3_node_verify(bp))
+			if (xfs_da3_node_verify(bp))
 				xfs_verifier_error(bp, -EFSCORRUPTED);
 			return;
 		case XFS_ATTR_LEAF_MAGIC:
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index a5d95c9..3b72879 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -58,7 +58,7 @@ xfs_dir_startup(void)
 	xfs_dir_hash_dotdot = xfs_da_hashname((unsigned char *)"..", 2);
 }
 
-static bool
+static xfs_failaddr_t
 xfs_dir3_block_verify(
 	struct xfs_buf		*bp)
 {
@@ -67,16 +67,16 @@ xfs_dir3_block_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
-			return false;
+			return __this_address;
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
+			return __this_address;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
-			return false;
+			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
-			return false;
+			return __this_address;
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
-			return false;
+			return __this_address;
 	}
 	return __xfs_dir3_data_check(NULL, bp);
 }
@@ -90,7 +90,7 @@ xfs_dir3_block_read_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (!xfs_dir3_block_verify(bp))
+	else if (xfs_dir3_block_verify(bp))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 }
 
@@ -102,7 +102,7 @@ xfs_dir3_block_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
-	if (!xfs_dir3_block_verify(bp)) {
+	if (xfs_dir3_block_verify(bp)) {
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index e1546fb..3eda247 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -36,9 +36,9 @@
 /*
  * Check the consistency of the data block.
  * The input can also be a block-format directory.
- * Return true if the buffer is good.
+ * Return NULL if the buffer is good, otherwise the address of the error.
  */
-bool
+xfs_failaddr_t
 __xfs_dir3_data_check(
 	struct xfs_inode	*dp,		/* incore inode pointer */
 	struct xfs_buf		*bp)		/* data block's buffer */
@@ -92,14 +92,14 @@ __xfs_dir3_data_check(
 		 */
 		if (be32_to_cpu(btp->count) >=
 		    ((char *)btp - p) / sizeof(struct xfs_dir2_leaf_entry))
-			return false;
+			return __this_address;
 		break;
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
 		endp = (char *)hdr + geo->blksize;
 		break;
 	default:
-		return false;
+		return __this_address;
 	}
 
 	/*
@@ -109,24 +109,24 @@ __xfs_dir3_data_check(
 	count = lastfree = freeseen = 0;
 	if (!bf[0].length) {
 		if (bf[0].offset)
-			return false;
+			return __this_address;
 		freeseen |= 1 << 0;
 	}
 	if (!bf[1].length) {
 		if (bf[1].offset)
-			return false;
+			return __this_address;
 		freeseen |= 1 << 1;
 	}
 	if (!bf[2].length) {
 		if (bf[2].offset)
-			return false;
+			return __this_address;
 		freeseen |= 1 << 2;
 	}
 
 	if (be16_to_cpu(bf[0].length) < be16_to_cpu(bf[1].length))
-		return false;
+		return __this_address;
 	if (be16_to_cpu(bf[1].length) < be16_to_cpu(bf[2].length))
-		return false;
+		return __this_address;
 	/*
 	 * Loop over the data/unused entries.
 	 */
@@ -139,22 +139,22 @@ __xfs_dir3_data_check(
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			if (lastfree != 0)
-				return false;
+				return __this_address;
 			if (endp < p + be16_to_cpu(dup->length))
-				return false;
+				return __this_address;
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
 			    (char *)dup - (char *)hdr)
-				return false;
+				return __this_address;
 			dfp = xfs_dir2_data_freefind(hdr, bf, dup);
 			if (dfp) {
 				i = (int)(dfp - bf);
 				if ((freeseen & (1 << i)) != 0)
-					return false;
+					return __this_address;
 				freeseen |= 1 << i;
 			} else {
 				if (be16_to_cpu(dup->length) >
 				    be16_to_cpu(bf[2].length))
-					return false;
+					return __this_address;
 			}
 			p += be16_to_cpu(dup->length);
 			lastfree = 1;
@@ -168,16 +168,16 @@ __xfs_dir3_data_check(
 		 */
 		dep = (xfs_dir2_data_entry_t *)p;
 		if (dep->namelen == 0)
-			return false;
+			return __this_address;
 		if (xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)))
-			return false;
+			return __this_address;
 		if (endp < p + ops->data_entsize(dep->namelen))
-			return false;
+			return __this_address;
 		if (be16_to_cpu(*ops->data_entry_tag_p(dep)) !=
 		    (char *)dep - (char *)hdr)
-			return false;
+			return __this_address;
 		if (ops->data_get_ftype(dep) >= XFS_DIR3_FT_MAX)
-			return false;
+			return __this_address;
 		count++;
 		lastfree = 0;
 		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
@@ -194,7 +194,7 @@ __xfs_dir3_data_check(
 					break;
 			}
 			if (i >= be32_to_cpu(btp->count))
-				return false;
+				return __this_address;
 		}
 		p += ops->data_entsize(dep->namelen);
 	}
@@ -202,7 +202,7 @@ __xfs_dir3_data_check(
 	 * Need to have seen all the entries and all the bestfree slots.
 	 */
 	if (freeseen != 7)
-		return false;
+		return __this_address;
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
 		for (i = stale = 0; i < be32_to_cpu(btp->count); i++) {
@@ -211,17 +211,34 @@ __xfs_dir3_data_check(
 				stale++;
 			if (i > 0 && be32_to_cpu(lep[i].hashval) <
 				     be32_to_cpu(lep[i - 1].hashval))
-				return false;
+				return __this_address;
 		}
 		if (count != be32_to_cpu(btp->count) - be32_to_cpu(btp->stale))
-			return false;
+			return __this_address;
 		if (stale != be32_to_cpu(btp->stale))
-			return false;
+			return __this_address;
 	}
-	return true;
+	return NULL;
 }
 
-static bool
+#ifdef DEBUG
+void
+xfs_dir3_data_check(
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp)
+{
+	xfs_failaddr_t		fa;
+
+	fa = __xfs_dir3_data_check(dp, bp);
+	if (!fa)
+		return;
+	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
+			bp->b_addr, __FILE__, __LINE__, fa);
+	ASSERT(0);
+}
+#endif
+
+static xfs_failaddr_t
 xfs_dir3_data_verify(
 	struct xfs_buf		*bp)
 {
@@ -230,16 +247,16 @@ xfs_dir3_data_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC))
-			return false;
+			return __this_address;
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
+			return __this_address;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
-			return false;
+			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
-			return false;
+			return __this_address;
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC))
-			return false;
+			return __this_address;
 	}
 	return __xfs_dir3_data_check(NULL, bp);
 }
@@ -281,7 +298,7 @@ xfs_dir3_data_read_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (!xfs_dir3_data_verify(bp))
+	else if (xfs_dir3_data_verify(bp))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 }
 
@@ -293,7 +310,7 @@ xfs_dir3_data_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
-	if (!xfs_dir3_data_verify(bp)) {
+	if (xfs_dir3_data_verify(bp)) {
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 071f879..a869486 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -50,13 +50,7 @@ static void xfs_dir3_leaf_log_tail(struct xfs_da_args *args,
  * Pop an assert if something is wrong.
  */
 #ifdef DEBUG
-#define	xfs_dir3_leaf_check(dp, bp) \
-do { \
-	if (!xfs_dir3_leaf1_check((dp), (bp))) \
-		ASSERT(0); \
-} while (0);
-
-STATIC bool
+static xfs_failaddr_t
 xfs_dir3_leaf1_check(
 	struct xfs_inode	*dp,
 	struct xfs_buf		*bp)
@@ -69,17 +63,32 @@ xfs_dir3_leaf1_check(
 	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
-			return false;
+			return __this_address;
 	} else if (leafhdr.magic != XFS_DIR2_LEAF1_MAGIC)
-		return false;
+		return __this_address;
 
 	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf);
 }
+
+static inline void
+xfs_dir3_leaf_check(
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp)
+{
+	xfs_failaddr_t		fa;
+
+	fa = xfs_dir3_leaf1_check(dp, bp);
+	if (!fa)
+		return;
+	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
+			bp->b_addr, __FILE__, __LINE__, fa);
+	ASSERT(0);
+}
 #else
 #define	xfs_dir3_leaf_check(dp, bp)
 #endif
 
-bool
+xfs_failaddr_t
 xfs_dir3_leaf_check_int(
 	struct xfs_mount	*mp,
 	struct xfs_inode	*dp,
@@ -114,27 +123,27 @@ xfs_dir3_leaf_check_int(
 	 * We can deduce a value for that from di_size.
 	 */
 	if (hdr->count > ops->leaf_max_ents(geo))
-		return false;
+		return __this_address;
 
 	/* Leaves and bests don't overlap in leaf format. */
 	if ((hdr->magic == XFS_DIR2_LEAF1_MAGIC ||
 	     hdr->magic == XFS_DIR3_LEAF1_MAGIC) &&
 	    (char *)&ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
-		return false;
+		return __this_address;
 
 	/* Check hash value order, count stale entries.  */
 	for (i = stale = 0; i < hdr->count; i++) {
 		if (i + 1 < hdr->count) {
 			if (be32_to_cpu(ents[i].hashval) >
 					be32_to_cpu(ents[i + 1].hashval))
-				return false;
+				return __this_address;
 		}
 		if (ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			stale++;
 	}
 	if (hdr->stale != stale)
-		return false;
-	return true;
+		return __this_address;
+	return NULL;
 }
 
 /*
@@ -142,7 +151,7 @@ xfs_dir3_leaf_check_int(
  * kernels we don't get assertion failures in xfs_dir3_leaf_hdr_from_disk() due
  * to incorrect magic numbers.
  */
-static bool
+static xfs_failaddr_t
 xfs_dir3_leaf_verify(
 	struct xfs_buf		*bp,
 	uint16_t		magic)
@@ -160,16 +169,16 @@ xfs_dir3_leaf_verify(
 							 : XFS_DIR3_LEAFN_MAGIC;
 
 		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
-			return false;
+			return __this_address;
 		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
+			return __this_address;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
-			return false;
+			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
-			return false;
+			return __this_address;
 	} else {
 		if (leaf->hdr.info.magic != cpu_to_be16(magic))
-			return false;
+			return __this_address;
 	}
 
 	return xfs_dir3_leaf_check_int(mp, NULL, NULL, leaf);
@@ -185,7 +194,7 @@ __read_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (!xfs_dir3_leaf_verify(bp, magic))
+	else if (xfs_dir3_leaf_verify(bp, magic))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 }
 
@@ -198,7 +207,7 @@ __write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
 
-	if (!xfs_dir3_leaf_verify(bp, magic)) {
+	if (xfs_dir3_leaf_verify(bp, magic)) {
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 888301d..051a21f 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -53,13 +53,7 @@ static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
  * Check internal consistency of a leafn block.
  */
 #ifdef DEBUG
-#define	xfs_dir3_leaf_check(dp, bp) \
-do { \
-	if (!xfs_dir3_leafn_check((dp), (bp))) \
-		ASSERT(0); \
-} while (0);
-
-static bool
+static xfs_failaddr_t
 xfs_dir3_leafn_check(
 	struct xfs_inode	*dp,
 	struct xfs_buf		*bp)
@@ -72,17 +66,32 @@ xfs_dir3_leafn_check(
 	if (leafhdr.magic == XFS_DIR3_LEAFN_MAGIC) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
-			return false;
+			return __this_address;
 	} else if (leafhdr.magic != XFS_DIR2_LEAFN_MAGIC)
-		return false;
+		return __this_address;
 
 	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf);
 }
+
+static inline void
+xfs_dir3_leaf_check(
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp)
+{
+	xfs_failaddr_t		fa;
+
+	fa = xfs_dir3_leafn_check(dp, bp);
+	if (!fa)
+		return;
+	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
+			bp->b_addr, __FILE__, __LINE__, fa);
+	ASSERT(0);
+}
 #else
 #define	xfs_dir3_leaf_check(dp, bp)
 #endif
 
-static bool
+static xfs_failaddr_t
 xfs_dir3_free_verify(
 	struct xfs_buf		*bp)
 {
@@ -93,21 +102,21 @@ xfs_dir3_free_verify(
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_FREE_MAGIC))
-			return false;
+			return __this_address;
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
+			return __this_address;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
-			return false;
+			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
-			return false;
+			return __this_address;
 	} else {
 		if (hdr->magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC))
-			return false;
+			return __this_address;
 	}
 
 	/* XXX: should bounds check the xfs_dir3_icfree_hdr here */
 
-	return true;
+	return NULL;
 }
 
 static void
@@ -119,7 +128,7 @@ xfs_dir3_free_read_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (!xfs_dir3_free_verify(bp))
+	else if (xfs_dir3_free_verify(bp))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 }
 
@@ -131,7 +140,7 @@ xfs_dir3_free_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
-	if (!xfs_dir3_free_verify(bp)) {
+	if (xfs_dir3_free_verify(bp)) {
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
 	}
@@ -170,22 +179,22 @@ xfs_dir3_free_header_check(
 		struct xfs_dir3_free_hdr *hdr3 = bp->b_addr;
 
 		if (be32_to_cpu(hdr3->firstdb) != firstdb)
-			return false;
+			return __this_address;
 		if (be32_to_cpu(hdr3->nvalid) > maxbests)
-			return false;
+			return __this_address;
 		if (be32_to_cpu(hdr3->nvalid) < be32_to_cpu(hdr3->nused))
-			return false;
+			return __this_address;
 	} else {
 		struct xfs_dir2_free_hdr *hdr = bp->b_addr;
 
 		if (be32_to_cpu(hdr->firstdb) != firstdb)
-			return false;
+			return __this_address;
 		if (be32_to_cpu(hdr->nvalid) > maxbests)
-			return false;
+			return __this_address;
 		if (be32_to_cpu(hdr->nvalid) < be32_to_cpu(hdr->nused))
-			return false;
+			return __this_address;
 	}
-	return true;
+	return NULL;
 }
 
 static int
@@ -204,7 +213,7 @@ __xfs_dir3_free_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	if (!xfs_dir3_free_header_check(dp, fbno, *bpp)) {
+	if (xfs_dir3_free_header_check(dp, fbno, *bpp)) {
 		xfs_verifier_error(*bpp, -EFSCORRUPTED);
 		xfs_trans_brelse(tp, *bpp);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 45c68d0..a15ad7c 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -39,18 +39,13 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 
 /* xfs_dir2_data.c */
 #ifdef DEBUG
-#define	xfs_dir3_data_check(dp, bp) \
-do { \
-	if (!__xfs_dir3_data_check((dp), (bp))) { \
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, \
-				(bp)->b_target->bt_mount, (bp)->b_addr); \
-	} \
-} while (0)
+extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 #else
 #define	xfs_dir3_data_check(dp,bp)
 #endif
 
-extern bool __xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
+extern xfs_failaddr_t __xfs_dir3_data_check(struct xfs_inode *dp,
+		struct xfs_buf *bp);
 extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
 extern int xfs_dir3_data_readahead(struct xfs_inode *dp, xfs_dablk_t bno,
@@ -95,8 +90,9 @@ xfs_dir3_leaf_find_entry(struct xfs_dir3_icleaf_hdr *leafhdr,
 		int lowstale, int highstale, int *lfloglow, int *lfloghigh);
 extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
 
-extern bool xfs_dir3_leaf_check_int(struct xfs_mount *mp, struct xfs_inode *dp,
-		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_dir2_leaf *leaf);
+extern xfs_failaddr_t xfs_dir3_leaf_check_int(struct xfs_mount *mp,
+		struct xfs_inode *dp, struct xfs_dir3_icleaf_hdr *hdr,
+		struct xfs_dir2_leaf *leaf);
 
 /* xfs_dir2_node.c */
 extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 60b6666..5a6e6ae 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2491,7 +2491,7 @@ xfs_check_agi_unlinked(
 #define xfs_check_agi_unlinked(agi)
 #endif
 
-static bool
+static xfs_failaddr_t
 xfs_agi_verify(
 	struct xfs_buf	*bp)
 {
@@ -2500,28 +2500,28 @@ xfs_agi_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
+			return __this_address;
 		if (!xfs_log_check_lsn(mp,
 				be64_to_cpu(XFS_BUF_TO_AGI(bp)->agi_lsn)))
-			return false;
+			return __this_address;
 	}
 
 	/*
 	 * Validate the magic number of the agi block.
 	 */
 	if (agi->agi_magicnum != cpu_to_be32(XFS_AGI_MAGIC))
-		return false;
+		return __this_address;
 	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
-		return false;
+		return __this_address;
 
 	if (be32_to_cpu(agi->agi_level) < 1 ||
 	    be32_to_cpu(agi->agi_level) > XFS_BTREE_MAXLEVELS)
-		return false;
+		return __this_address;
 
 	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
 	    (be32_to_cpu(agi->agi_free_level) < 1 ||
 	     be32_to_cpu(agi->agi_free_level) > XFS_BTREE_MAXLEVELS))
-		return false;
+		return __this_address;
 
 	/*
 	 * during growfs operations, the perag is not fully initialised,
@@ -2530,10 +2530,10 @@ xfs_agi_verify(
 	 * so we can detect and avoid this problem.
 	 */
 	if (bp->b_pag && be32_to_cpu(agi->agi_seqno) != bp->b_pag->pag_agno)
-		return false;
+		return __this_address;
 
 	xfs_check_agi_unlinked(agi);
-	return true;
+	return NULL;
 }
 
 static void
@@ -2545,7 +2545,7 @@ xfs_agi_read_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (XFS_TEST_ERROR(!xfs_agi_verify(bp), mp,
+	else if (XFS_TEST_ERROR(xfs_agi_verify(bp), mp,
 				XFS_ERRTAG_IALLOC_READ_AGI))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 }
@@ -2557,7 +2557,7 @@ xfs_agi_write_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
-	if (!xfs_agi_verify(bp)) {
+	if (xfs_agi_verify(bp)) {
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
 	}
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index d86bdce..8fe126b 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -250,12 +250,13 @@ xfs_inobt_diff_two_keys(
 			  be32_to_cpu(k2->inobt.ir_startino);
 }
 
-static int
+static xfs_failaddr_t
 xfs_inobt_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
 	unsigned int		level;
 
 	/*
@@ -271,20 +272,21 @@ xfs_inobt_verify(
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_IBT_CRC_MAGIC):
 	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
-		if (!xfs_btree_sblock_v5hdr_verify(bp))
-			return false;
+		fa = xfs_btree_sblock_v5hdr_verify(bp);
+		if (fa)
+			return fa;
 		/* fall through */
 	case cpu_to_be32(XFS_IBT_MAGIC):
 	case cpu_to_be32(XFS_FIBT_MAGIC):
 		break;
 	default:
-		return 0;
+		return NULL;
 	}
 
 	/* level verification */
 	level = be16_to_cpu(block->bb_level);
 	if (level >= mp->m_in_maxlevels)
-		return false;
+		return __this_address;
 
 	return xfs_btree_sblock_verify(bp, mp->m_inobt_mxr[level != 0]);
 }
@@ -295,7 +297,7 @@ xfs_inobt_read_verify(
 {
 	if (!xfs_btree_sblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (!xfs_inobt_verify(bp))
+	else if (xfs_inobt_verify(bp))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
@@ -306,7 +308,7 @@ static void
 xfs_inobt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (!xfs_inobt_verify(bp)) {
+	if (xfs_inobt_verify(bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index b625f65..607dcca 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -380,7 +380,7 @@ xfs_log_dinode_to_disk(
 	}
 }
 
-bool
+xfs_failaddr_t
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
@@ -391,33 +391,33 @@ xfs_dinode_verify(
 	uint64_t		flags2;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
-		return false;
+		return __this_address;
 
 	/* don't allow invalid i_size */
 	if (be64_to_cpu(dip->di_size) & (1ULL << 63))
-		return false;
+		return __this_address;
 
 	mode = be16_to_cpu(dip->di_mode);
 	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
-		return false;
+		return __this_address;
 
 	/* No zero-length symlinks/dirs. */
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && dip->di_size == 0)
-		return false;
+		return __this_address;
 
 	/* only version 3 or greater inodes are extensively verified here */
 	if (dip->di_version < 3)
-		return true;
+		return NULL;
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return false;
+		return __this_address;
 	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
 			      XFS_DINODE_CRC_OFF))
-		return false;
+		return __this_address;
 	if (be64_to_cpu(dip->di_ino) != ino)
-		return false;
+		return __this_address;
 	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
-		return false;
+		return __this_address;
 
 	flags = be16_to_cpu(dip->di_flags);
 	flags2 = be64_to_cpu(dip->di_flags2);
@@ -425,17 +425,17 @@ xfs_dinode_verify(
 	/* don't allow reflink/cowextsize if we don't have reflink */
 	if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
             !xfs_sb_version_hasreflink(&mp->m_sb))
-		return false;
+		return __this_address;
 
 	/* don't let reflink and realtime mix */
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
-		return false;
+		return __this_address;
 
 	/* don't let reflink and dax mix */
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags2 & XFS_DIFLAG2_DAX))
-		return false;
+		return __this_address;
 
-	return true;
+	return NULL;
 }
 
 void
@@ -475,6 +475,7 @@ xfs_iread(
 {
 	xfs_buf_t	*bp;
 	xfs_dinode_t	*dip;
+	xfs_failaddr_t	fa;
 	int		error;
 
 	/*
@@ -506,9 +507,10 @@ xfs_iread(
 		return error;
 
 	/* even unallocated inodes are verified */
-	if (!xfs_dinode_verify(mp, ip->i_ino, dip)) {
-		xfs_alert(mp, "%s: validation failed for inode %lld",
-				__func__, ip->i_ino);
+	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
+	if (fa) {
+		xfs_alert(mp, "%s: validation failed for inode %lld at %pS",
+				__func__, ip->i_ino, fa);
 
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);
 		error = -EFSCORRUPTED;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index a9c97a3..8a5e1da 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -82,7 +82,7 @@ void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #define	xfs_inobp_check(mp, bp)
 #endif /* DEBUG */
 
-bool	xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
-			  struct xfs_dinode *dip);
+xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
+			   struct xfs_dinode *dip);
 
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index ce940eb..aa09051 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -223,29 +223,31 @@ xfs_refcountbt_diff_two_keys(
 			  be32_to_cpu(k2->refc.rc_startblock);
 }
 
-STATIC bool
+STATIC xfs_failaddr_t
 xfs_refcountbt_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
+	xfs_failaddr_t		fa;
 	unsigned int		level;
 
 	if (block->bb_magic != cpu_to_be32(XFS_REFC_CRC_MAGIC))
-		return false;
+		return __this_address;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
-		return false;
-	if (!xfs_btree_sblock_v5hdr_verify(bp))
-		return false;
+		return __this_address;
+	fa = xfs_btree_sblock_v5hdr_verify(bp);
+	if (fa)
+		return fa;
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && pag->pagf_init) {
 		if (level >= pag->pagf_refcount_level)
-			return false;
+			return __this_address;
 	} else if (level >= mp->m_refc_maxlevels)
-		return false;
+		return __this_address;
 
 	return xfs_btree_sblock_verify(bp, mp->m_refc_mxr[level != 0]);
 }
@@ -256,7 +258,7 @@ xfs_refcountbt_read_verify(
 {
 	if (!xfs_btree_sblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (!xfs_refcountbt_verify(bp))
+	else if (xfs_refcountbt_verify(bp))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
@@ -267,7 +269,7 @@ STATIC void
 xfs_refcountbt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (!xfs_refcountbt_verify(bp)) {
+	if (xfs_refcountbt_verify(bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 6325908..333fd5c 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -303,13 +303,14 @@ xfs_rmapbt_diff_two_keys(
 	return 0;
 }
 
-static bool
+static xfs_failaddr_t
 xfs_rmapbt_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
+	xfs_failaddr_t		fa;
 	unsigned int		level;
 
 	/*
@@ -325,19 +326,20 @@ xfs_rmapbt_verify(
 	 * in this case.
 	 */
 	if (block->bb_magic != cpu_to_be32(XFS_RMAP_CRC_MAGIC))
-		return false;
+		return __this_address;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
-		return false;
-	if (!xfs_btree_sblock_v5hdr_verify(bp))
-		return false;
+		return __this_address;
+	fa = xfs_btree_sblock_v5hdr_verify(bp);
+	if (fa)
+		return fa;
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && pag->pagf_init) {
 		if (level >= pag->pagf_levels[XFS_BTNUM_RMAPi])
-			return false;
+			return __this_address;
 	} else if (level >= mp->m_rmap_maxlevels)
-		return false;
+		return __this_address;
 
 	return xfs_btree_sblock_verify(bp, mp->m_rmap_mxr[level != 0]);
 }
@@ -348,7 +350,7 @@ xfs_rmapbt_read_verify(
 {
 	if (!xfs_btree_sblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (!xfs_rmapbt_verify(bp))
+	else if (xfs_rmapbt_verify(bp))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 
 	if (bp->b_error)
@@ -359,7 +361,7 @@ static void
 xfs_rmapbt_write_verify(
 	struct xfs_buf	*bp)
 {
-	if (!xfs_rmapbt_verify(bp)) {
+	if (xfs_rmapbt_verify(bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 58c21a6..64db737 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -98,7 +98,7 @@ xfs_symlink_hdr_ok(
 	return true;
 }
 
-static bool
+static xfs_failaddr_t
 xfs_symlink_verify(
 	struct xfs_buf		*bp)
 {
@@ -106,22 +106,22 @@ xfs_symlink_verify(
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return false;
+		return __this_address;
 	if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
-		return false;
+		return __this_address;
 	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))
-		return false;
+		return __this_address;
 	if (bp->b_bn != be64_to_cpu(dsl->sl_blkno))
-		return false;
+		return __this_address;
 	if (be32_to_cpu(dsl->sl_offset) +
 				be32_to_cpu(dsl->sl_bytes) >= XFS_SYMLINK_MAXLEN)
-		return false;
+		return __this_address;
 	if (dsl->sl_owner == 0)
-		return false;
+		return __this_address;
 	if (!xfs_log_check_lsn(mp, be64_to_cpu(dsl->sl_lsn)))
-		return false;
+		return __this_address;
 
-	return true;
+	return NULL;
 }
 
 static void
@@ -136,7 +136,7 @@ xfs_symlink_read_verify(
 
 	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC);
-	else if (!xfs_symlink_verify(bp))
+	else if (xfs_symlink_verify(bp))
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 }
 
@@ -151,7 +151,7 @@ xfs_symlink_write_verify(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_symlink_verify(bp)) {
+	if (xfs_symlink_verify(bp)) {
 		xfs_verifier_error(bp, -EFSCORRUPTED);
 		return;
 	}
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index d21866f..90b80be 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -559,7 +559,7 @@ xfs_scrub_inode_map_raw(
 	 */
 	bp->b_ops = &xfs_inode_buf_ops;
 	dip = xfs_buf_offset(bp, imap.im_boffset);
-	if (!xfs_dinode_verify(mp, ino, dip) ||
+	if (xfs_dinode_verify(mp, ino, dip) != NULL ||
 	    !xfs_dinode_good_version(mp, dip->di_version)) {
 		xfs_scrub_ino_set_corrupt(sc, ino, bp);
 		goto out_buf;


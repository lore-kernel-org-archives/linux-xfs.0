Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 93DB87F58
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67A8A304039
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:19:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tlWuDNxPtffF1WV7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:57 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id E442FC0B64D7
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:56 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJuiH026222
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 01/18] libxfs: validate metadata LSNs against log on v5
	superblocks
Date: Fri,  2 Oct 2015 14:19:38 -0400
Message-Id: <1443809995-20395-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
References: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Backport the associated kernel commit. Replace the xfs_log_check_lsn()
helper with a stub.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/libxfs_priv.h        |  2 ++
 libxfs/util.c               |  8 ++++++++
 libxfs/xfs_alloc.c          | 12 +++++++++---
 libxfs/xfs_attr_leaf.c      |  2 ++
 libxfs/xfs_btree.c          | 16 ++++++++++++++--
 libxfs/xfs_da_btree.c       |  3 +++
 libxfs/xfs_dir2_block.c     |  2 ++
 libxfs/xfs_dir2_data.c      |  2 ++
 libxfs/xfs_dir2_leaf.c      |  2 ++
 libxfs/xfs_dir2_node.c      |  2 ++
 libxfs/xfs_ialloc.c         |  9 +++++++--
 libxfs/xfs_sb.c             |  9 +++++++++
 libxfs/xfs_symlink_remote.c |  3 +++
 13 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 22f2d53..9135aac 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -505,4 +505,6 @@ void xfs_verifier_error(struct xfs_buf *bp);
 /* xfs_rtalloc.c */
 int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
 
+bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
+
 #endif	/* __LIBXFS_INTERNAL_XFS_H__ */
diff --git a/libxfs/util.c b/libxfs/util.c
index c9f9175..fcf6e96 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -729,3 +729,11 @@ xfs_verifier_error(
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
 		  bp->b_bn, BBTOB(bp->b_length));
 }
+
+bool
+xfs_log_check_lsn(
+	struct xfs_mount	*mp,
+	xfs_lsn_t		lsn)
+{
+	return true;
+}
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 4f3008a..95c8d44 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -478,7 +478,9 @@ xfs_agfl_verify(
 		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
 			return false;
 	}
-	return true;
+
+	return xfs_log_check_lsn(mp,
+				 be64_to_cpu(XFS_BUF_TO_AGFL(bp)->agfl_lsn));
 }
 
 static void
@@ -2255,9 +2257,13 @@ xfs_agf_verify(
  {
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
+		if (!xfs_log_check_lsn(mp,
+				be64_to_cpu(XFS_BUF_TO_AGF(bp)->agf_lsn)))
+			return false;
+	}
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index cc25068..bf473eb 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -262,6 +262,8 @@ xfs_attr3_leaf_verify(
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
+			return false;
 	} else {
 		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
 			return false;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a16ae7d..f28e3a5 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -240,8 +240,14 @@ bool
 xfs_btree_lblock_verify_crc(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn)))
+			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
+	}
 
 	return true;
 }
@@ -272,8 +278,14 @@ bool
 xfs_btree_sblock_verify_crc(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
+			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
+	}
 
 	return true;
 }
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 289dc1e..bdd60a0 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -146,6 +146,8 @@ xfs_da3_node_verify(
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
+			return false;
 	} else {
 		if (ichdr.magic != XFS_DA_NODE_MAGIC)
 			return false;
@@ -318,6 +320,7 @@ xfs_da3_node_create(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
+		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
 		ichdr.magic = XFS_DA3_NODE_MAGIC;
 		hdr3->info.blkno = cpu_to_be64(bp->b_bn);
 		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 489f301..d7ba0e9 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -68,6 +68,8 @@ xfs_dir3_block_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
+			return false;
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
 			return false;
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 0c9f529..37b3b68 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -222,6 +222,8 @@ xfs_dir3_data_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
+			return false;
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC))
 			return false;
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 80d03b3..77c2e65 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -162,6 +162,8 @@ xfs_dir3_leaf_verify(
 			return false;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
 			return false;
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
+			return false;
 	} else {
 		if (leaf->hdr.info.magic != cpu_to_be16(magic))
 			return false;
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 0514cea..689a3fd 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -95,6 +95,8 @@ xfs_dir3_free_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
+			return false;
 	} else {
 		if (hdr->magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC))
 			return false;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 93bfaea..d39f9b6 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2495,9 +2495,14 @@ xfs_agi_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
+			return false;
+		if (!xfs_log_check_lsn(mp,
+				be64_to_cpu(XFS_BUF_TO_AGI(bp)->agi_lsn)))
 			return false;
+	}
+
 	/*
 	 * Validate the magic number of the agi block.
 	 */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index f944a58..c293d68 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -161,6 +161,15 @@ xfs_mount_validate_sb(
 "Filesystem can not be safely mounted by this kernel.");
 			return -EINVAL;
 		}
+	} else if (xfs_sb_version_hascrc(sbp)) {
+		/*
+		 * We can't read verify the sb LSN because the read verifier is
+		 * called before the log is allocated and processed. We know the
+		 * log is set up before write verifier (!check_version) calls,
+		 * so just check it here.
+		 */
+		if (!xfs_log_check_lsn(mp, sbp->sb_lsn))
+			return -EFSCORRUPTED;
 	}
 
 	if (xfs_sb_version_has_pquotino(sbp)) {
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 7d46d9e..647444a 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -57,6 +57,7 @@ xfs_symlink_hdr_set(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return 0;
 
+	memset(dsl, 0, sizeof(struct xfs_dsymlink_hdr));
 	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
 	dsl->sl_offset = cpu_to_be32(offset);
 	dsl->sl_bytes = cpu_to_be32(size);
@@ -113,6 +114,8 @@ xfs_symlink_verify(
 		return false;
 	if (dsl->sl_owner == 0)
 		return false;
+	if (!xfs_log_check_lsn(mp, be64_to_cpu(dsl->sl_lsn)))
+		return false;
 
 	return true;
 }
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

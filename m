Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2945F7F50
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 13:55:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA132AC00E
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LOGCgx94QjsIrrkS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:44 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 346B8C0A1605
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 18:55:44 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-37.bos.redhat.com [10.18.41.37])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8BIthPw022533
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 14:55:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 01/12] libxfs: validate metadata LSNs against log on v5
	superblocks
Date: Fri, 11 Sep 2015 14:55:31 -0400
Message-Id: <1441997742-37160-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
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

Backport the associated kernel commit. Replace the
xfs_detect_invalid_lsn() helper with a stub.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/libxfs_priv.h        |  2 ++
 libxfs/util.c               |  7 +++++++
 libxfs/xfs_alloc.c          |  9 +++++++--
 libxfs/xfs_attr_leaf.c      |  2 ++
 libxfs/xfs_btree.c          | 14 ++++++++++++--
 libxfs/xfs_da_btree.c       |  3 +++
 libxfs/xfs_dir2_block.c     |  1 +
 libxfs/xfs_dir2_data.c      |  1 +
 libxfs/xfs_dir2_leaf.c      |  1 +
 libxfs/xfs_dir2_node.c      |  1 +
 libxfs/xfs_ialloc.c         |  8 ++++++--
 libxfs/xfs_sb.c             |  8 ++++++++
 libxfs/xfs_symlink_remote.c |  3 +++
 13 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 22f2d53..59cb6c3 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -505,4 +505,6 @@ void xfs_verifier_error(struct xfs_buf *bp);
 /* xfs_rtalloc.c */
 int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
 
+extern void	xfs_detect_invalid_lsn(struct xfs_mount *, xfs_lsn_t);
+
 #endif	/* __LIBXFS_INTERNAL_XFS_H__ */
diff --git a/libxfs/util.c b/libxfs/util.c
index c9f9175..43338b8 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -729,3 +729,10 @@ xfs_verifier_error(
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
 		  bp->b_bn, BBTOB(bp->b_length));
 }
+
+void
+xfs_detect_invalid_lsn(
+	struct xfs_mount	*mp,
+	xfs_lsn_t		lsn)
+{
+}
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 4f3008a..f1f2791 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -478,6 +478,8 @@ xfs_agfl_verify(
 		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
 			return false;
 	}
+
+	xfs_detect_invalid_lsn(mp, be64_to_cpu(XFS_BUF_TO_AGFL(bp)->agfl_lsn));
 	return true;
 }
 
@@ -2255,9 +2257,12 @@ xfs_agf_verify(
  {
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
+		xfs_detect_invalid_lsn(mp,
+				be64_to_cpu(XFS_BUF_TO_AGF(bp)->agf_lsn));
+	}
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index cc25068..aca3cf8 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -262,6 +262,8 @@ xfs_attr3_leaf_verify(
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
+
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(hdr3->info.lsn));
 	} else {
 		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
 			return false;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a16ae7d..b2b2db5 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -240,8 +240,13 @@ bool
 xfs_btree_lblock_verify_crc(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn));
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
+	}
 
 	return true;
 }
@@ -272,8 +277,13 @@ bool
 xfs_btree_sblock_verify_crc(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn));
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
+	}
 
 	return true;
 }
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 289dc1e..beb02ed 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -146,6 +146,8 @@ xfs_da3_node_verify(
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
+
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(hdr3->info.lsn));
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
index 489f301..c886d70 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -68,6 +68,7 @@ xfs_dir3_block_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(hdr3->lsn));
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
 			return false;
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 0c9f529..b68c7ab 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -222,6 +222,7 @@ xfs_dir3_data_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(hdr3->lsn));
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC))
 			return false;
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 80d03b3..e2dac37 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -162,6 +162,7 @@ xfs_dir3_leaf_verify(
 			return false;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
 			return false;
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(leaf3->info.lsn));
 	} else {
 		if (leaf->hdr.info.magic != cpu_to_be16(magic))
 			return false;
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 0514cea..5328859 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -95,6 +95,7 @@ xfs_dir3_free_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(hdr3->lsn));
 	} else {
 		if (hdr->magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC))
 			return false;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 93bfaea..a9b0e4a 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2495,9 +2495,13 @@ xfs_agi_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
+		xfs_detect_invalid_lsn(mp,
+				be64_to_cpu(XFS_BUF_TO_AGI(bp)->agi_lsn));
+	}
+
 	/*
 	 * Validate the magic number of the agi block.
 	 */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index f944a58..5fe892d 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -161,6 +161,14 @@ xfs_mount_validate_sb(
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
+		xfs_detect_invalid_lsn(mp, sbp->sb_lsn);
 	}
 
 	if (xfs_sb_version_has_pquotino(sbp)) {
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 7d46d9e..364329a 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -57,6 +57,7 @@ xfs_symlink_hdr_set(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return 0;
 
+	memset(dsl, 0, sizeof(struct xfs_dsymlink_hdr));
 	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
 	dsl->sl_offset = cpu_to_be32(offset);
 	dsl->sl_bytes = cpu_to_be32(size);
@@ -114,6 +115,8 @@ xfs_symlink_verify(
 	if (dsl->sl_owner == 0)
 		return false;
 
+	xfs_detect_invalid_lsn(mp, be64_to_cpu(dsl->sl_lsn));
+
 	return true;
 }
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

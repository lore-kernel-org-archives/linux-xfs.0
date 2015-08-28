Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0EF4E7F37
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 13:06:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EED488F8040
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 11:06:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9VdegGesLUnplbqv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Aug 2015 11:06:49 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 65BA3A2C33
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 18:06:49 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-103.bos.redhat.com [10.18.41.103])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7SI6nSN007986
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 14:06:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/9] xfs: validate metadata LSNs against log on v5 superblocks
Date: Fri, 28 Aug 2015 14:06:39 -0400
Message-Id: <1440785207-17543-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1440785207-17543-1-git-send-email-bfoster@redhat.com>
References: <1440785207-17543-1-git-send-email-bfoster@redhat.com>
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

Backport of kernel commit. Replace xfs_valid_lsn() with stub.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/libxfs_priv.h        |  2 ++
 libxfs/util.c               | 14 ++++++++++++++
 libxfs/xfs_alloc.c          | 10 ++++++++--
 libxfs/xfs_attr_leaf.c      |  3 +++
 libxfs/xfs_btree.c          | 18 ++++++++++++++++--
 libxfs/xfs_da_btree.c       |  3 +++
 libxfs/xfs_dir2_block.c     |  2 ++
 libxfs/xfs_dir2_data.c      |  2 ++
 libxfs/xfs_dir2_leaf.c      |  2 ++
 libxfs/xfs_dir2_node.c      |  2 ++
 libxfs/xfs_ialloc.c         |  9 +++++++--
 libxfs/xfs_sb.c             |  9 +++++++++
 libxfs/xfs_symlink_remote.c |  3 +++
 13 files changed, 73 insertions(+), 6 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 2a8b850..d21e78e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -506,4 +506,6 @@ void xfs_verifier_error(struct xfs_buf *bp);
 /* xfs_rtalloc.c */
 int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
 
+bool xfs_valid_lsn(struct xfs_mount *, xfs_lsn_t);
+
 #endif	/* __LIBXFS_INTERNAL_XFS_H__ */
diff --git a/libxfs/util.c b/libxfs/util.c
index c9f9175..96ce31f 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -729,3 +729,17 @@ xfs_verifier_error(
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
 		  bp->b_bn, BBTOB(bp->b_length));
 }
+
+/*
+ * This is called from I/O verifiers on v5 superblock filesystems. In the
+ * kernel, it validates the metadata LSN parameter against the current LSN of
+ * the active log. We don't have an active log in userspace, so just return
+ * true.
+ */
+bool
+xfs_valid_lsn(
+	struct xfs_mount	*mp,
+	xfs_lsn_t		lsn)
+{
+	return true;
+}
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 4f3008a..4a3df1f 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -464,6 +464,8 @@ xfs_agfl_verify(
 		return false;
 	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
 		return false;
+	if (!xfs_valid_lsn(mp, be64_to_cpu(XFS_BUF_TO_AGFL(bp)->agfl_lsn)))
+		return false;
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
@@ -2255,9 +2257,13 @@ xfs_agf_verify(
  {
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
+		if (!xfs_valid_lsn(mp,
+				   be64_to_cpu(XFS_BUF_TO_AGF(bp)->agf_lsn)))
+			return false;
+	}
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index cc25068..ae49d7f 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -262,6 +262,9 @@ xfs_attr3_leaf_verify(
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
+
+		if (!xfs_valid_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
+			return false;
 	} else {
 		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
 			return false;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a16ae7d..9c1296f 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -240,8 +240,15 @@ bool
 xfs_btree_lblock_verify_crc(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+		if (!xfs_valid_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn)))
+			return false;
+
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
+	}
 
 	return true;
 }
@@ -272,8 +279,15 @@ bool
 xfs_btree_sblock_verify_crc(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+		if (!xfs_valid_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
+			return false;
+
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
+	}
 
 	return true;
 }
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index c874164..99a8ad7 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -146,6 +146,9 @@ xfs_da3_node_verify(
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
+
+		if (!xfs_valid_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
+			return false;
 	} else {
 		if (ichdr.magic != XFS_DA_NODE_MAGIC)
 			return false;
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 489f301..567b5a4 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -68,6 +68,8 @@ xfs_dir3_block_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		if (!xfs_valid_lsn(mp, be64_to_cpu(hdr3->lsn)))
+			return false;
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
 			return false;
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 0c9f529..58bbc80 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -222,6 +222,8 @@ xfs_dir3_data_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		if (!xfs_valid_lsn(mp, be64_to_cpu(hdr3->lsn)))
+			return false;
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC))
 			return false;
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 80d03b3..37b9c4a 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -162,6 +162,8 @@ xfs_dir3_leaf_verify(
 			return false;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
 			return false;
+		if (!xfs_valid_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
+			return false;
 	} else {
 		if (leaf->hdr.info.magic != cpu_to_be16(magic))
 			return false;
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 0514cea..d03b7ff 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -95,6 +95,8 @@ xfs_dir3_free_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		if (!xfs_valid_lsn(mp, be64_to_cpu(hdr3->lsn)))
+			return false;
 	} else {
 		if (hdr->magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC))
 			return false;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 93bfaea..6a0e4e2 100644
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
+		if (!xfs_valid_lsn(mp,
+				   be64_to_cpu(XFS_BUF_TO_AGI(bp)->agi_lsn)))
 			return false;
+	}
+
 	/*
 	 * Validate the magic number of the agi block.
 	 */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index f944a58..97e2b66 100644
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
+		if (!xfs_valid_lsn(mp, sbp->sb_lsn))
+			return -EINVAL;
 	}
 
 	if (xfs_sb_version_has_pquotino(sbp)) {
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 7d46d9e..bb9f89f 100644
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
+	if (!xfs_valid_lsn(mp, be64_to_cpu(dsl->sl_lsn)))
+		return false;
 
 	return true;
 }
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

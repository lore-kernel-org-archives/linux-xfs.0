Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731284AbfAaPqM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 10:46:12 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8C0F5DC909
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 15:46:11 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 410DE600C2
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 15:46:11 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 5/7] xfs: use verifier magic field in dir2 leaf verifiers
Date: Thu, 31 Jan 2019 10:46:06 -0500
Message-Id: <20190131154608.36837-6-bfoster@redhat.com>
In-Reply-To: <20190131154608.36837-1-bfoster@redhat.com>
References: <20190131154608.36837-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The dir2 leaf verifiers share the same underlying structure
verification code, but implement six accessor functions to multiplex
the code across the two verifiers. Further, the magic value isn't
sufficiently abstracted such that the common helper has to manually
fix up the magic from the caller on v5 filesystems.

Use the magic field in the verifier structure to eliminate the
duplicate code and clean this all up. No functional change.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c | 88 ++++++++---------------------------
 1 file changed, 20 insertions(+), 68 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 1728a3e6f5cf..a99ae2cd292e 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -142,41 +142,32 @@ xfs_dir3_leaf_check_int(
  */
 static xfs_failaddr_t
 xfs_dir3_leaf_verify(
-	struct xfs_buf		*bp,
-	uint16_t		magic)
+	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 
-	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
+	if (!xfs_verify_magic(bp, leaf->hdr.info.magic))
+		return __this_address;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
-		uint16_t		magic3;
 
-		magic3 = (magic == XFS_DIR2_LEAF1_MAGIC) ? XFS_DIR3_LEAF1_MAGIC
-							 : XFS_DIR3_LEAFN_MAGIC;
-
-		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
-			return __this_address;
+		ASSERT(leaf3->info.hdr.magic == leaf->hdr.info.magic);
 		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
 			return __this_address;
-	} else {
-		if (leaf->hdr.info.magic != cpu_to_be16(magic))
-			return __this_address;
 	}
 
 	return xfs_dir3_leaf_check_int(mp, NULL, NULL, leaf);
 }
 
 static void
-__read_verify(
-	struct xfs_buf  *bp,
-	uint16_t	magic)
+xfs_dir3_leaf_read_verify(
+	struct xfs_buf  *bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	xfs_failaddr_t		fa;
@@ -185,23 +176,22 @@ __read_verify(
 	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_dir3_leaf_verify(bp, magic);
+		fa = xfs_dir3_leaf_verify(bp);
 		if (fa)
 			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 	}
 }
 
 static void
-__write_verify(
-	struct xfs_buf  *bp,
-	uint16_t	magic)
+xfs_dir3_leaf_write_verify(
+	struct xfs_buf  *bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
 
-	fa = xfs_dir3_leaf_verify(bp, magic);
+	fa = xfs_dir3_leaf_verify(bp);
 	if (fa) {
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
@@ -216,60 +206,22 @@ __write_verify(
 	xfs_buf_update_cksum(bp, XFS_DIR3_LEAF_CRC_OFF);
 }
 
-static xfs_failaddr_t
-xfs_dir3_leaf1_verify(
-	struct xfs_buf	*bp)
-{
-	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAF1_MAGIC);
-}
-
-static void
-xfs_dir3_leaf1_read_verify(
-	struct xfs_buf	*bp)
-{
-	__read_verify(bp, XFS_DIR2_LEAF1_MAGIC);
-}
-
-static void
-xfs_dir3_leaf1_write_verify(
-	struct xfs_buf	*bp)
-{
-	__write_verify(bp, XFS_DIR2_LEAF1_MAGIC);
-}
-
-static xfs_failaddr_t
-xfs_dir3_leafn_verify(
-	struct xfs_buf	*bp)
-{
-	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAFN_MAGIC);
-}
-
-static void
-xfs_dir3_leafn_read_verify(
-	struct xfs_buf	*bp)
-{
-	__read_verify(bp, XFS_DIR2_LEAFN_MAGIC);
-}
-
-static void
-xfs_dir3_leafn_write_verify(
-	struct xfs_buf	*bp)
-{
-	__write_verify(bp, XFS_DIR2_LEAFN_MAGIC);
-}
-
 const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
 	.name = "xfs_dir3_leaf1",
-	.verify_read = xfs_dir3_leaf1_read_verify,
-	.verify_write = xfs_dir3_leaf1_write_verify,
-	.verify_struct = xfs_dir3_leaf1_verify,
+	.magic = { cpu_to_be16(XFS_DIR2_LEAF1_MAGIC),
+		   cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) },
+	.verify_read = xfs_dir3_leaf_read_verify,
+	.verify_write = xfs_dir3_leaf_write_verify,
+	.verify_struct = xfs_dir3_leaf_verify,
 };
 
 const struct xfs_buf_ops xfs_dir3_leafn_buf_ops = {
 	.name = "xfs_dir3_leafn",
-	.verify_read = xfs_dir3_leafn_read_verify,
-	.verify_write = xfs_dir3_leafn_write_verify,
-	.verify_struct = xfs_dir3_leafn_verify,
+	.magic = { cpu_to_be16(XFS_DIR2_LEAFN_MAGIC),
+		   cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) },
+	.verify_read = xfs_dir3_leaf_read_verify,
+	.verify_write = xfs_dir3_leaf_write_verify,
+	.verify_struct = xfs_dir3_leaf_verify,
 };
 
 int
-- 
2.17.2

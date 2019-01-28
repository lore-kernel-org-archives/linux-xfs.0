Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbfA1PUh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Jan 2019 10:20:37 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B5C9C7C3B
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jan 2019 15:20:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A677B19E34
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jan 2019 15:20:36 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC v2 3/3] xfs: detect and warn about finobt blocks with an inobt magic value
Date: Mon, 28 Jan 2019 10:20:34 -0500
Message-Id: <20190128152034.21080-4-bfoster@redhat.com>
In-Reply-To: <20190128152034.21080-1-bfoster@redhat.com>
References: <20190128152034.21080-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_repair had a bug where finobt reconstruction could create
certain level > 0 nodes with an inobt magic. This went undetected by
kernel verifiers because the inode btree verifiers were common
between the inobt and finobt. Now that the verifiers enforce the
appropriate magic value based on btree type, a mitigation strategy
is necessary to avoid turning a low impact metadata inconsistency
into an immediate and fatal runtime error.

Add an explicit check for a finobt block with an inobt verifier to
the [f]inobt structure verifier function. In the event that this
occurs, report this as a warning rather than a verifier error to
indicate to the user to upgrade xfsprogs and run xfs_repair. Note
that without this change, an affected finobt filesystem will trigger
a verifier error at mount time due to the perag reservation finobt
scan and fail to mount.

Also filter out this error from the lower level btree verification
logic. This logic is what detected the problem in the first place,
but can also cause an otherwise functional filesystem to fail. Note
that while this logic has been around for some time, it hasn't
always been active on non-debug kernels or triggered a runtime
error. This means that the scarcity of error reports is not
necessarily indicative of the prevalence of the problem in the
field.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.c        | 12 ++++++++++--
 fs/xfs/libxfs/xfs_ialloc_btree.c | 25 ++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index bbdae2b4559f..6bb5882d69f3 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -132,6 +132,7 @@ __xfs_btree_check_sblock(
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
+	uint32_t		magic = xfs_btree_magic(crc, btnum);
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -141,8 +142,15 @@ __xfs_btree_check_sblock(
 			return __this_address;
 	}
 
-	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(crc, btnum))
-		return __this_address;
+	/*
+	 * Exclude the case of a finobt block with inobt magic from being an
+	 * error. See the inobt verifier for further details.
+	 */
+	if (be32_to_cpu(block->bb_magic) != magic) {
+		if (!(magic == XFS_FIBT_CRC_MAGIC &&
+		     (be32_to_cpu(block->bb_magic) == XFS_IBT_CRC_MAGIC)))
+			return __this_address;
+	}
 	if (be16_to_cpu(block->bb_level) != level)
 		return __this_address;
 	if (be16_to_cpu(block->bb_numrecs) >
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index c57ecb6b1255..79aafef42df6 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -259,9 +259,28 @@ xfs_inobt_verify(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	xfs_failaddr_t		fa;
 	unsigned int		level;
+	bool			hascrc = xfs_sb_version_hascrc(&mp->m_sb);
 
-	if (!xfs_verify_magic(bp, block->bb_magic))
-		return __this_address;
+	/*
+	 * xfs_repair had a bug that created interior finobt nodes with inobt
+	 * magic values. This escaped verifier detection for some time because
+	 * the verifier originally passed so long as the magic matched one of
+	 * the several possible [f]inobt magic values.
+	 *
+	 * We now distinguish between magic values per tree, but we cannot
+	 * outright fail as this would cause otherwise working filesystems to
+	 * become unusable. Instead, warn the user to upgrade xfs_repair and fix
+	 * the problem.
+	 */
+	if (!xfs_verify_magic(bp, block->bb_magic)) {
+		if ((bp->b_ops->magic[hascrc] == XFS_FIBT_CRC_MAGIC) &&
+		    (block->bb_magic == cpu_to_be32(XFS_IBT_CRC_MAGIC)))
+			xfs_warn(mp,
+"WARNING: inobt magic on finobt block 0x%llx. This is caused by xfs_repair. "
+"Please upgrade xfsprogs, unmount and run xfs_repair.", bp->b_bn);
+		else
+			return __this_address;
+	}
 
 	/*
 	 * During growfs operations, we can't verify the exact owner as the
@@ -273,7 +292,7 @@ xfs_inobt_verify(
 	 * but beware of the landmine (i.e. need to check pag->pagi_init) if we
 	 * ever do.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (hascrc) {
 		fa = xfs_btree_sblock_v5hdr_verify(bp);
 		if (fa)
 			return fa;
-- 
2.17.2

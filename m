Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbfA1PUg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Jan 2019 10:20:36 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2042980F7C
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jan 2019 15:20:36 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8CBB19E34
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jan 2019 15:20:35 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC v2 1/3] xfs: create a separate finobt verifier
Date: Mon, 28 Jan 2019 10:20:32 -0500
Message-Id: <20190128152034.21080-2-bfoster@redhat.com>
In-Reply-To: <20190128152034.21080-1-bfoster@redhat.com>
References: <20190128152034.21080-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The inobt verifier is reused for the inobt and finobt, which
prevents the ability to distinguish between magic values on a
per-tree basis. Create a separate finobt structure in preparation
for changes to enforce the appropriate magic value for the
associated tree. This patch has no functional change.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c           | 2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c | 9 ++++++++-
 fs/xfs/libxfs/xfs_shared.h       | 1 +
 fs/xfs/scrub/agheader_repair.c   | 2 +-
 fs/xfs/xfs_log_recover.c         | 6 ++++--
 5 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 999ad8d00d43..bde67ef3ff43 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -361,7 +361,7 @@ xfs_ag_init_headers(
 	{ /* FINO root block */
 		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_FIBT_BLOCK(mp)),
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
-		.ops = &xfs_inobt_buf_ops,
+		.ops = &xfs_finobt_buf_ops,
 		.work = &xfs_btroot_init,
 		.type = XFS_BTNUM_FINO,
 		.need_init =  xfs_sb_version_hasfinobt(&mp->m_sb)
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 9b25e7a0df47..798269eb4767 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -333,6 +333,13 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.verify_struct = xfs_inobt_verify,
 };
 
+const struct xfs_buf_ops xfs_finobt_buf_ops = {
+	.name = "xfs_finobt",
+	.verify_read = xfs_inobt_read_verify,
+	.verify_write = xfs_inobt_write_verify,
+	.verify_struct = xfs_inobt_verify,
+};
+
 STATIC int
 xfs_inobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -389,7 +396,7 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
-	.buf_ops		= &xfs_inobt_buf_ops,
+	.buf_ops		= &xfs_finobt_buf_ops,
 	.diff_two_keys		= xfs_inobt_diff_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 1c5debe748f0..9855f4d2f98f 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -36,6 +36,7 @@ extern const struct xfs_buf_ops xfs_dquot_buf_ops;
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 extern const struct xfs_buf_ops xfs_agi_buf_ops;
 extern const struct xfs_buf_ops xfs_inobt_buf_ops;
+extern const struct xfs_buf_ops xfs_finobt_buf_ops;
 extern const struct xfs_buf_ops xfs_inode_buf_ops;
 extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_dquot_buf_ops;
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 03d1e15cceba..673be3cf7b8d 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -879,7 +879,7 @@ xrep_agi(
 		},
 		[XREP_AGI_FINOBT] = {
 			.rmap_owner = XFS_RMAP_OWN_INOBT,
-			.buf_ops = &xfs_inobt_buf_ops,
+			.buf_ops = &xfs_finobt_buf_ops,
 			.magic = XFS_FIBT_CRC_MAGIC,
 		},
 		[XREP_AGI_END] = {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9fe88d125f0a..228c754bb137 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2445,11 +2445,13 @@ xlog_recover_validate_buf_type(
 			bp->b_ops = &xfs_allocbt_buf_ops;
 			break;
 		case XFS_IBT_CRC_MAGIC:
-		case XFS_FIBT_CRC_MAGIC:
 		case XFS_IBT_MAGIC:
-		case XFS_FIBT_MAGIC:
 			bp->b_ops = &xfs_inobt_buf_ops;
 			break;
+		case XFS_FIBT_CRC_MAGIC:
+		case XFS_FIBT_MAGIC:
+			bp->b_ops = &xfs_finobt_buf_ops;
+			break;
 		case XFS_BMAP_CRC_MAGIC:
 		case XFS_BMAP_MAGIC:
 			bp->b_ops = &xfs_bmbt_buf_ops;
-- 
2.17.2

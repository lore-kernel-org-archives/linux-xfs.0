Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39230 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfBGS5T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Feb 2019 13:57:19 -0500
Date: Thu, 7 Feb 2019 10:57:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/8] xfs: use buf ops magic to detect btree block type
Message-ID: <20190207185713.GI7991@magnolia>
References: <20190207184105.17064-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207184105.17064-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we encode block magic numbers in all the buffer ops, use that
for block type detection in the ag header repair code instead of
encoding magics directly in the repair code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader_repair.c |    6 ------
 fs/xfs/scrub/repair.c          |    3 ++-
 fs/xfs/scrub/repair.h          |    3 ---
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 2799d1531639..64e31f87d490 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -342,22 +342,18 @@ xrep_agf(
 		[XREP_AGF_BNOBT] = {
 			.rmap_owner = XFS_RMAP_OWN_AG,
 			.buf_ops = &xfs_bnobt_buf_ops,
-			.magic = XFS_ABTB_CRC_MAGIC,
 		},
 		[XREP_AGF_CNTBT] = {
 			.rmap_owner = XFS_RMAP_OWN_AG,
 			.buf_ops = &xfs_cntbt_buf_ops,
-			.magic = XFS_ABTC_CRC_MAGIC,
 		},
 		[XREP_AGF_RMAPBT] = {
 			.rmap_owner = XFS_RMAP_OWN_AG,
 			.buf_ops = &xfs_rmapbt_buf_ops,
-			.magic = XFS_RMAP_CRC_MAGIC,
 		},
 		[XREP_AGF_REFCOUNTBT] = {
 			.rmap_owner = XFS_RMAP_OWN_REFC,
 			.buf_ops = &xfs_refcountbt_buf_ops,
-			.magic = XFS_REFC_CRC_MAGIC,
 		},
 		[XREP_AGF_END] = {
 			.buf_ops = NULL,
@@ -875,12 +871,10 @@ xrep_agi(
 		[XREP_AGI_INOBT] = {
 			.rmap_owner = XFS_RMAP_OWN_INOBT,
 			.buf_ops = &xfs_inobt_buf_ops,
-			.magic = XFS_IBT_CRC_MAGIC,
 		},
 		[XREP_AGI_FINOBT] = {
 			.rmap_owner = XFS_RMAP_OWN_INOBT,
 			.buf_ops = &xfs_finobt_buf_ops,
-			.magic = XFS_FIBT_CRC_MAGIC,
 		},
 		[XREP_AGI_END] = {
 			.buf_ops = NULL
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 6acf1bfa0bfe..f28f4bad317b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -743,7 +743,8 @@ xrep_findroot_block(
 
 	/* Ensure the block magic matches the btree type we're looking for. */
 	btblock = XFS_BUF_TO_BLOCK(bp);
-	if (be32_to_cpu(btblock->bb_magic) != fab->magic)
+	ASSERT(fab->buf_ops->magic[1] != 0);
+	if (btblock->bb_magic != fab->buf_ops->magic[1])
 		goto out;
 
 	/*
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index f2fc18bb7605..d990314eb08b 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -42,9 +42,6 @@ struct xrep_find_ag_btree {
 	/* in: buffer ops */
 	const struct xfs_buf_ops	*buf_ops;
 
-	/* in: magic number of the btree */
-	uint32_t			magic;
-
 	/* out: the highest btree block found and the tree height */
 	xfs_agblock_t			root;
 	unsigned int			height;

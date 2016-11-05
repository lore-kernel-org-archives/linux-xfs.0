Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36615 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbcKEAIk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:08:40 -0400
Subject: [PATCH 06/16] libxfs: refactor btree crc verifier
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:08:36 -0700
Message-ID: <147830451684.26713.17449721738475726138.stgit@birch.djwong.org>
In-Reply-To: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

In a65d8d293b ("libxfs: validate metadata LSNs against log on v5
superblocks") the hascrc check was modified to use the helper mp
variable in the kernel.  This was left out of the xfsprogs patch, so
change it here too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 1d41265..3dea6bd 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -244,7 +244,7 @@ xfs_btree_lblock_verify_crc(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn)))
 			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
@@ -282,7 +282,7 @@ xfs_btree_sblock_verify_crc(
 	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
 			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);


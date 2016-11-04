Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46211 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934946AbcKDSae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 14:30:34 -0400
Subject: [PATCH 04/11] libxfs: remove unnecessary hascrc test in btree
 verifiers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 11:30:30 -0700
Message-ID: <147828423060.31492.13968588974592065768.stgit@birch.djwong.org>
In-Reply-To: <147828420554.31492.4173929442743951581.stgit@birch.djwong.org>
References: <147828420554.31492.4173929442743951581.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

xfs_btree_sblock_v5hdr_verify already checks _hascrc, so we can
remove it from the verifier functions.  For whatever reason this
change made it into the kernel but not xfsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc_btree.c  |    4 ----
 libxfs/xfs_ialloc_btree.c |    2 --
 2 files changed, 6 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index f993b87..ff4bae4 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -278,8 +278,6 @@ xfs_allocbt_verify(
 	level = be16_to_cpu(block->bb_level);
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
-			return false;
 		if (!xfs_btree_sblock_v5hdr_verify(bp))
 			return false;
 		/* fall through */
@@ -291,8 +289,6 @@ xfs_allocbt_verify(
 			return false;
 		break;
 	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
-			return false;
 		if (!xfs_btree_sblock_v5hdr_verify(bp))
 			return false;
 		/* fall through */
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 8ccabcc..7bf6040 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -225,8 +225,6 @@ xfs_inobt_verify(
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_IBT_CRC_MAGIC):
 	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
-			return false;
 		if (!xfs_btree_sblock_v5hdr_verify(bp))
 			return false;
 		/* fall through */


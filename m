Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16525 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756502AbcI1CyJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:54:09 -0400
Subject: [PATCH 05/63] xfs: refcount btree add more reserved blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:54:02 -0700
Message-ID: <147503124203.30303.12757234426644427539.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Since XFS reserves a small amount of space in each AG as the minimum
free space needed for an operation, save some more space in case we
touch the refcount btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c  |   13 +++++++++++++
 fs/xfs/libxfs/xfs_format.h |    2 ++
 2 files changed, 15 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 275d345..aa0e1ca 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -52,10 +52,23 @@ STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
 
+unsigned int
+xfs_refc_block(
+	struct xfs_mount	*mp)
+{
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return XFS_RMAP_BLOCK(mp) + 1;
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		return XFS_FIBT_BLOCK(mp) + 1;
+	return XFS_IBT_BLOCK(mp) + 1;
+}
+
 xfs_extlen_t
 xfs_prealloc_blocks(
 	struct xfs_mount	*mp)
 {
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		return xfs_refc_block(mp) + 1;
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return XFS_RMAP_BLOCK(mp) + 1;
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 57c52a6..622055b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1455,6 +1455,8 @@ typedef __be32 xfs_rmap_ptr_t;
  */
 #define	XFS_REFC_CRC_MAGIC	0x52334643	/* 'R3FC' */
 
+unsigned int xfs_refc_block(struct xfs_mount *mp);
+
 
 /*
  * BMAP Btree format definitions


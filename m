Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 780D77FA9
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:33:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11B55AC006
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:33:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id cOq4BqGwMfx2X8Qk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:33:31 -0700 (PDT)
Subject: [PATCH 04/24] xfs: refcount btree add more reserved blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 Jul 2015 15:33:24 -0700
Message-ID: <20150729223324.17414.85659.stgit@birch.djwong.org>
In-Reply-To: <20150729223258.17414.91354.stgit@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Since XFS reserves a small amount of space in each AG as the minimum
free space needed for an operation, save some more space in case we
touch the refcount btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |   13 +++++++++++++
 fs/xfs/libxfs/xfs_format.h |    2 ++
 2 files changed, 15 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 40e8129..cb6b3d9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -50,10 +50,23 @@ STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
 
+unsigned int
+XFS_REFC_BLOCK(
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
+		return XFS_REFC_BLOCK(mp) + 1;
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return XFS_RMAP_BLOCK(mp) + 1;
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c0dd355..b1ad07d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1365,6 +1365,8 @@ typedef __be32 xfs_rmap_ptr_t;
  */
 #define	XFS_REFC_CRC_MAGIC	0x52334643	/* 'R3FC' */
 
+unsigned int XFS_REFC_BLOCK(struct xfs_mount *mp);
+
 
 /*
  * BMAP Btree format definitions

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

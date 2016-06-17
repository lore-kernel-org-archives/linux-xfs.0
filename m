Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A1707CB5
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:20:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA8DFAC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:20:42 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Spc4CUiB9qiIBhz0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:20:40 -0700 (PDT)
Subject: [PATCH 025/119] xfs: rmap btree add more reserved blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:20:32 -0700
Message-ID: <146612643276.12839.2224272649304333643.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

XFS reserves a small amount of space in each AG for the minimum
number of free blocks needed for operation. Adding the rmap btree
increases the number of reserved blocks, but it also increases the
complexity of the calculation as the free inode btree is optional
(like the rmbt).

Rather than calculate the prealloc blocks every time we need to
check it, add a function to calculate it at mount time and store it
in the struct xfs_mount, and convert the XFS_PREALLOC_BLOCKS macro
just to use the xfs-mount variable directly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |   11 +++++++++++
 fs/xfs/libxfs/xfs_alloc.h  |    2 ++
 fs/xfs/libxfs/xfs_format.h |    9 +--------
 fs/xfs/xfs_fsops.c         |    6 +++---
 fs/xfs/xfs_mount.c         |    2 ++
 fs/xfs/xfs_mount.h         |    1 +
 6 files changed, 20 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b61e9c6..fb00042 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -50,6 +50,17 @@ STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
 
+xfs_extlen_t
+xfs_prealloc_blocks(
+	struct xfs_mount	*mp)
+{
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return XFS_RMAP_BLOCK(mp) + 1;
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		return XFS_FIBT_BLOCK(mp) + 1;
+	return XFS_IBT_BLOCK(mp) + 1;
+}
+
 /*
  * Lookup the record equal to [bno, len] in the btree given by cur.
  */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index cf268b2..20b54aa 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -232,4 +232,6 @@ int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
 int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
 		struct xfs_buf **agbp);
 
+xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 8ca4a3d..b5b0901 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1318,18 +1318,11 @@ typedef __be32 xfs_inobt_ptr_t;
  */
 #define	XFS_RMAP_CRC_MAGIC	0x524d4233	/* 'RMB3' */
 
-/*
- * The first data block of an AG depends on whether the filesystem was formatted
- * with the finobt feature. If so, account for the finobt reserved root btree
- * block.
- */
-#define XFS_PREALLOC_BLOCKS(mp) \
+#define	XFS_RMAP_BLOCK(mp) \
 	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
 	 XFS_FIBT_BLOCK(mp) + 1 : \
 	 XFS_IBT_BLOCK(mp) + 1)
 
-
-
 /*
  * BMAP Btree format definitions
  *
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 064fce1..62162d4 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -243,7 +243,7 @@ xfs_growfs_data_private(
 		agf->agf_flfirst = cpu_to_be32(1);
 		agf->agf_fllast = 0;
 		agf->agf_flcount = 0;
-		tmpsize = agsize - XFS_PREALLOC_BLOCKS(mp);
+		tmpsize = agsize - mp->m_ag_prealloc_blocks;
 		agf->agf_freeblks = cpu_to_be32(tmpsize);
 		agf->agf_longest = cpu_to_be32(tmpsize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
@@ -340,7 +340,7 @@ xfs_growfs_data_private(
 						agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
-		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
+		arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
 		arec->ar_blockcount = cpu_to_be32(
 			agsize - be32_to_cpu(arec->ar_startblock));
 
@@ -369,7 +369,7 @@ xfs_growfs_data_private(
 						agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
-		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
+		arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
 		arec->ar_blockcount = cpu_to_be32(
 			agsize - be32_to_cpu(arec->ar_startblock));
 		nfree += be32_to_cpu(arec->ar_blockcount);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bf63682..b4153f0 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -231,6 +231,8 @@ xfs_initialize_perag(
 
 	if (maxagi)
 		*maxagi = index;
+
+	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
 	return 0;
 
 out_unwind:
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c1b798c..0537b1f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -119,6 +119,7 @@ typedef struct xfs_mount {
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* max inobt btree levels. */
+	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	struct mutex		m_growlock;	/* growfs mutex */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

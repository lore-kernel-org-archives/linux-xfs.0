Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A3E27CA1
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 22:17:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5D331304039
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 20:17:07 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8oVXAa4QSvkCxst1 for <xfs@oss.sgi.com>;
	Mon, 07 Mar 2016 20:17:04 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ad94T-0004A6-06
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:33 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ad94G-0007uD-EP
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/16] xfs: rmap btree add more reserved blocks
Date: Tue,  8 Mar 2016 15:16:05 +1100
Message-Id: <1457410578-30233-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1457410578-30233-1-git-send-email-david@fromorbit.com>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
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

>From : Dave Chinner <dchinner@redhat.com>

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
 fs/xfs/libxfs/xfs_alloc.c  | 11 +++++++++++
 fs/xfs/libxfs/xfs_alloc.h  |  2 ++
 fs/xfs/libxfs/xfs_format.h |  9 +--------
 fs/xfs/xfs_fsops.c         |  6 +++---
 fs/xfs/xfs_mount.c         |  2 ++
 fs/xfs/xfs_mount.h         |  1 +
 6 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d0b78b7..19b7521 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -49,6 +49,17 @@ STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
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
index 135eb3d..d260916 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -237,4 +237,6 @@ int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
 
+xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4a48977..ebe0eec 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1319,18 +1319,11 @@ typedef __be32 xfs_inobt_ptr_t;
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
index ee3aaa0a..32e24ec 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -246,7 +246,7 @@ xfs_growfs_data_private(
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
-		tmpsize = agsize - XFS_PREALLOC_BLOCKS(mp);
+		tmpsize = agsize - mp->m_ag_prealloc_blocks;
 		agf->agf_freeblks = cpu_to_be32(tmpsize);
 		agf->agf_longest = cpu_to_be32(tmpsize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
@@ -343,7 +343,7 @@ xfs_growfs_data_private(
 						agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
-		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
+		arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
 		arec->ar_blockcount = cpu_to_be32(
 			agsize - be32_to_cpu(arec->ar_startblock));
 
@@ -372,7 +372,7 @@ xfs_growfs_data_private(
 						agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
-		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
+		arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
 		arec->ar_blockcount = cpu_to_be32(
 			agsize - be32_to_cpu(arec->ar_startblock));
 		nfree += be32_to_cpu(arec->ar_blockcount);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 536a0ee..ef5de545 100644
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
index 1c8611f..9788686 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -93,6 +93,7 @@ typedef struct xfs_mount {
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* max inobt btree levels. */
+	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	struct mutex		m_growlock;	/* growfs mutex */
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

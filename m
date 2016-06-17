Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E4B9E7E4F
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:34:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A3F558F8050
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:34:02 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id dXWgXHqZz5B37izf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:34:00 -0700 (PDT)
Subject: [PATCH 030/145] xfs: rmap btree add more reserved blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:33:53 -0700
Message-ID: <146612723321.16048.10346293125851584186.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

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
 include/xfs_mount.h |    1 +
 libxfs/init.c       |    2 ++
 libxfs/xfs_alloc.c  |   11 +++++++++++
 libxfs/xfs_alloc.h  |    2 ++
 libxfs/xfs_format.h |    9 +--------
 mkfs/xfs_mkfs.c     |   14 +++++++-------
 6 files changed, 24 insertions(+), 15 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 14b05a6..2c7c72e 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -67,6 +67,7 @@ typedef struct xfs_mount {
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* XFS_IN_MAXLEVELS */
+	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	struct radix_tree_root	m_perag_tree;
 	uint			m_flags;	/* global mount flags */
 	uint			m_qflags;	/* quota status flags */
diff --git a/libxfs/init.c b/libxfs/init.c
index 553da7b..7b618da 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -572,6 +572,8 @@ libxfs_initialize_perag(
 
 	if (maxagi)
 		*maxagi = index;
+
+	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
 	return 0;
 
 out_unwind:
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 675151d..738275f 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -46,6 +46,17 @@ STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
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
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index cf268b2..20b54aa 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -232,4 +232,6 @@ int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
 int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
 		struct xfs_buf **agbp);
 
+xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index cb30a25..12048fa 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index de00c8e..e9d2851 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2965,7 +2965,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 	/*
 	 * sb_versionnum and finobt flags must be set before we use
-	 * XFS_PREALLOC_BLOCKS().
+	 * xfs_prealloc_blocks().
 	 */
 	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
 
@@ -2982,7 +2982,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			/* revalidate the log size is valid if we changed it */
 			validate_log_size(logblocks, blocklog, min_logblocks);
 		}
-		if (logblocks > agsize - XFS_PREALLOC_BLOCKS(mp)) {
+		if (logblocks > agsize - xfs_prealloc_blocks(mp)) {
 			fprintf(stderr,
 	_("internal log size %lld too large, must fit in allocation group\n"),
 				(long long)logblocks);
@@ -2999,7 +2999,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		} else
 			logagno = (xfs_agnumber_t)(agcount / 2);
 
-		logstart = XFS_AGB_TO_FSB(mp, logagno, XFS_PREALLOC_BLOCKS(mp));
+		logstart = XFS_AGB_TO_FSB(mp, logagno, xfs_prealloc_blocks(mp));
 		/*
 		 * Align the logstart at stripe unit boundary.
 		 */
@@ -3077,7 +3077,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_imax_pct = imaxpct;
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
-	sbp->sb_fdblocks = dblocks - agcount * XFS_PREALLOC_BLOCKS(mp) -
+	sbp->sb_fdblocks = dblocks - agcount * xfs_prealloc_blocks(mp) -
 		(loginternal ? logblocks : 0);
 	sbp->sb_frextents = 0;	/* will do a free later */
 	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
@@ -3219,7 +3219,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
-		nbmblocks = (xfs_extlen_t)(agsize - XFS_PREALLOC_BLOCKS(mp));
+		nbmblocks = (xfs_extlen_t)(agsize - xfs_prealloc_blocks(mp));
 		agf->agf_freeblks = cpu_to_be32(nbmblocks);
 		agf->agf_longest = cpu_to_be32(nbmblocks);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
@@ -3300,7 +3300,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 						agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
-		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
+		arec->ar_startblock = cpu_to_be32(xfs_prealloc_blocks(mp));
 		if (loginternal && agno == logagno) {
 			if (lalign) {
 				/*
@@ -3355,7 +3355,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 						agno, 0);
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
-		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
+		arec->ar_startblock = cpu_to_be32(xfs_prealloc_blocks(mp));
 		if (loginternal && agno == logagno) {
 			if (lalign) {
 				arec->ar_blockcount = cpu_to_be32(

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

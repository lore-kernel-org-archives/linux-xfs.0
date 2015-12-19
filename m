Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2960C81B1
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:06:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E59628F8066
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:06:06 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id uoVL4lVw5nlrRbzm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:06:04 -0800 (PST)
Subject: [PATCH 11/53] xfs: rmap btree requires more reserved free space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:06:01 -0800
Message-ID: <20151219090601.14255.30900.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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

>From : Dave Chinner <dchinner@redhat.com>

The rmap btree is allocated from the AGFL, which means we have to
ensure ENOSPC is reported to userspace before we run out of free
space in each AG. The last allocation in an AG can cause a full
height rmap btree split, and that means we have to reserve at least
this many blocks *in each AG* to be placed on the AGFL at ENOSPC.
Update the various space calculation functiosn to handle this.

Also, because the macros are now executing conditional code and are called quite
frequently, convert them to functions that initialise varaibles in the struct
xfs_mount, use the new variables everywhere and document the calculations
better.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[port to xfsprogs]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_mount.h |    2 +
 libxfs/xfs_alloc.c  |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_alloc.h  |   43 ++++----------------------------
 libxfs/xfs_bmap.c   |    2 +
 libxfs/xfs_sb.c     |    2 +
 5 files changed, 79 insertions(+), 39 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 1daee74..390ec77 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -69,6 +69,8 @@ typedef struct xfs_mount {
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* XFS_IN_MAXLEVELS */
+	uint			m_alloc_set_aside; /* space we can't use */
+	uint			m_ag_max_usable; /* max space per AG */
 	struct radix_tree_root	m_perag_tree;
 	uint			m_flags;	/* global mount flags */
 	uint			m_qflags;	/* quota status flags */
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index fea94c8..bc2b3d4 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -58,6 +58,72 @@ xfs_prealloc_blocks(
 }
 
 /*
+ * In order to avoid ENOSPC-related deadlock caused by out-of-order locking of
+ * AGF buffer (PV 947395), we place constraints on the relationship among actual
+ * allocations for data blocks, freelist blocks, and potential file data bmap
+ * btree blocks. However, these restrictions may result in no actual space
+ * allocated for a delayed extent, for example, a data block in a certain AG is
+ * allocated but there is no additional block for the additional bmap btree
+ * block due to a split of the bmap btree of the file. The result of this may
+ * lead to an infinite loop when the file gets flushed to disk and all delayed
+ * extents need to be actually allocated. To get around this, we explicitly set
+ * aside a few blocks which will not be reserved in delayed allocation.
+ *
+ * The minimum number of needed freelist blocks is 4 fsbs _per AG_ when we are
+ * not using rmap btrees a potential split of file's bmap btree requires 1 fsb,
+ * so we set the number of set-aside blocks to 4 + 4*agcount when not using rmap
+ * btrees.
+ *
+ * When rmap btrees are active, we have to consider that using the last block in
+ * the AG can cause a full height rmap btree split and we need enough blocks on
+ * the AGFL to be able to handle this. That means we have, in addition to the
+ * above consideration, another (2 * mp->m_ag_levels) - 1 blocks required to be
+ * available to the free list.
+ */
+unsigned int
+xfs_alloc_set_aside(
+	struct xfs_mount *mp)
+{
+	unsigned int	blocks;
+
+	blocks = 4 + (mp->m_sb.sb_agcount * XFS_ALLOC_AGFL_RESERVE);
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return blocks;
+	return blocks + (mp->m_sb.sb_agcount * (2 * mp->m_ag_maxlevels) - 1);
+}
+
+/*
+ * When deciding how much space to allocate out of an AG, we limit the
+ * allocation maximum size to the size the AG. However, we cannot use all the
+ * blocks in the AG - some are permanently used by metadata. These
+ * blocks are generally:
+ *	- the AG superblock, AGF, AGI and AGFL
+ *	- the AGF (bno and cnt) and AGI btree root blocks, and optionally
+ *	  the AGI free inode and rmap btree root blocks.
+ *	- blocks on the AGFL according to xfs_alloc_set_aside() limits
+ *
+ * The AG headers are sector sized, so the amount of space they take up is
+ * dependent on filesystem geometry. The others are all single blocks.
+ */
+unsigned int
+xfs_alloc_ag_max_usable(struct xfs_mount *mp)
+{
+	unsigned int	blocks;
+
+	blocks = XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)); /* ag headers */
+	blocks += XFS_ALLOC_AGFL_RESERVE;
+	blocks += 3;			/* AGF, AGI btree root blocks */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		blocks++;		/* finobt root block */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		/* rmap root block + full tree split on full AG */
+		blocks += 1 + (2 * mp->m_ag_maxlevels) - 1;
+	}
+
+	return mp->m_sb.sb_agblocks - blocks;
+}
+
+/*
  * Lookup the record equal to [bno, len] in the btree given by cur.
  */
 STATIC int				/* error */
@@ -1900,6 +1966,9 @@ xfs_alloc_min_freelist(
 	/* space needed by-size freespace btree */
 	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_CNTi] + 1,
 				       mp->m_ag_maxlevels);
+	/* space needed reverse mapping used space btree */
+	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
+				       mp->m_ag_maxlevels);
 
 	return min_free;
 }
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 35b60ae..5b2b616 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -55,44 +55,6 @@ typedef unsigned int xfs_alloctype_t;
 #define	XFS_ALLOC_FLAG_TRYLOCK	0x00000001  /* use trylock for buffer locking */
 #define	XFS_ALLOC_FLAG_FREEING	0x00000002  /* indicate caller is freeing extents*/
 
-/*
- * In order to avoid ENOSPC-related deadlock caused by
- * out-of-order locking of AGF buffer (PV 947395), we place
- * constraints on the relationship among actual allocations for
- * data blocks, freelist blocks, and potential file data bmap
- * btree blocks. However, these restrictions may result in no
- * actual space allocated for a delayed extent, for example, a data
- * block in a certain AG is allocated but there is no additional
- * block for the additional bmap btree block due to a split of the
- * bmap btree of the file. The result of this may lead to an
- * infinite loop in xfssyncd when the file gets flushed to disk and
- * all delayed extents need to be actually allocated. To get around
- * this, we explicitly set aside a few blocks which will not be
- * reserved in delayed allocation. Considering the minimum number of
- * needed freelist blocks is 4 fsbs _per AG_, a potential split of file's bmap
- * btree requires 1 fsb, so we set the number of set-aside blocks
- * to 4 + 4*agcount.
- *
- * XXX: this changes for rmapbt filesystems.
- */
-#define XFS_ALLOC_SET_ASIDE(mp)  (4 + ((mp)->m_sb.sb_agcount * 4))
-
-/*
- * When deciding how much space to allocate out of an AG, we limit the
- * allocation maximum size to the size the AG. However, we cannot use all the
- * blocks in the AG - some are permanently used by metadata. These
- * blocks are generally:
- *	- the AG superblock, AGF, AGI and AGFL
- *	- the AGF (bno and cnt) and AGI btree root blocks
- *	- 4 blocks on the AGFL according to XFS_ALLOC_SET_ASIDE() limits
- *
- * The AG headers are sector sized, so the amount of space they take up is
- * dependent on filesystem geometry. The others are all single blocks.
- *
- * XXX: this changes for rmapbt filesystems.
- */
-#define XFS_ALLOC_AG_MAX_USABLE(mp)	\
-	((mp)->m_sb.sb_agblocks - XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)) - 7)
 
 /*
  * Argument structure for xfs_alloc routines.
@@ -134,6 +96,11 @@ typedef struct xfs_alloc_arg {
 #define XFS_ALLOC_USERDATA		1	/* allocation is for user data*/
 #define XFS_ALLOC_INITIAL_USER_DATA	2	/* special case start of file */
 
+/* freespace limit calculations */
+#define XFS_ALLOC_AGFL_RESERVE	4
+unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
+unsigned int xfs_alloc_ag_max_usable(struct xfs_mount *mp);
+
 xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_mount *mp,
 		struct xfs_perag *pag, xfs_extlen_t need);
 unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 3fe18fc..785d10a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3686,7 +3686,7 @@ xfs_bmap_btalloc(
 	args.fsbno = ap->blkno;
 
 	/* Trim the allocation back to the maximum an AG can fit. */
-	args.maxlen = MIN(ap->length, XFS_ALLOC_AG_MAX_USABLE(mp));
+	args.maxlen = MIN(ap->length, mp->m_ag_max_usable);
 	args.firstblock = *ap->firstblock;
 	blen = 0;
 	if (nullfb) {
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index b23dfd1..85ef128 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -726,6 +726,8 @@ xfs_sb_mount_common(
 		mp->m_ialloc_min_blks = sbp->sb_spino_align;
 	else
 		mp->m_ialloc_min_blks = mp->m_ialloc_blks;
+	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

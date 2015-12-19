Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 14D757FBF
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:58:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 788E3AC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:58:26 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id e9BJ3yB2mZl2T6uM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:58:24 -0800 (PST)
Subject: [PATCH 18/76] xfs: rmap btree requires more reserved free space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:58:21 -0800
Message-ID: <20151219085820.12713.33396.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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
---
 fs/xfs/libxfs/xfs_alloc.c |   69 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h |   41 +++------------------------
 fs/xfs/libxfs/xfs_bmap.c  |    2 +
 fs/xfs/libxfs/xfs_sb.c    |    2 +
 fs/xfs/xfs_discard.c      |    2 +
 fs/xfs/xfs_fsops.c        |    4 +--
 fs/xfs/xfs_mount.c        |    2 +
 fs/xfs/xfs_mount.h        |    2 +
 fs/xfs/xfs_super.c        |    2 +
 9 files changed, 84 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6c82021..5a829d7 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -62,6 +62,72 @@ xfs_prealloc_blocks(
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
@@ -1913,6 +1979,9 @@ xfs_alloc_min_freelist(
 	/* space needed by-size freespace btree */
 	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_CNTi] + 1,
 				       mp->m_ag_maxlevels);
+	/* space needed reverse mapping used space btree */
+	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
+				       mp->m_ag_maxlevels);
 
 	return min_free;
 }
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 6d0f328..ea2868d 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -56,42 +56,6 @@ typedef unsigned int xfs_alloctype_t;
 #define	XFS_ALLOC_FLAG_FREEING	0x00000002  /* indicate caller is freeing extents*/
 
 /*
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
- */
-#define XFS_ALLOC_AG_MAX_USABLE(mp)	\
-	((mp)->m_sb.sb_agblocks - XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)) - 7)
-
-
-/*
  * Argument structure for xfs_alloc routines.
  * This is turned into a structure to avoid having 20 arguments passed
  * down several levels of the stack.
@@ -133,6 +97,11 @@ typedef struct xfs_alloc_arg {
 #define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
 #define XFS_ALLOC_USERDATA_ZERO		(1 << 2)/* zero extent on allocation */
 
+/* freespace limit calculations */
+#define XFS_ALLOC_AGFL_RESERVE	4
+unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
+unsigned int xfs_alloc_ag_max_usable(struct xfs_mount *mp);
+
 xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_mount *mp,
 		struct xfs_perag *pag, xfs_extlen_t need);
 unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9183602..9fd02de 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3703,7 +3703,7 @@ xfs_bmap_btalloc(
 	args.fsbno = ap->blkno;
 
 	/* Trim the allocation back to the maximum an AG can fit. */
-	args.maxlen = MIN(ap->length, XFS_ALLOC_AG_MAX_USABLE(mp));
+	args.maxlen = MIN(ap->length, mp->m_ag_max_usable);
 	args.firstblock = *ap->firstblock;
 	blen = 0;
 	if (nullfb) {
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 7c3eb6c..c9114b7 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -742,6 +742,8 @@ xfs_sb_mount_common(
 		mp->m_ialloc_min_blks = sbp->sb_spino_align;
 	else
 		mp->m_ialloc_min_blks = mp->m_ialloc_blks;
+	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index e85a951..ec7bb8b 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -179,7 +179,7 @@ xfs_ioc_trim(
 	 * matter as trimming blocks is an advisory interface.
 	 */
 	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
-	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)) ||
+	    range.minlen > XFS_FSB_TO_B(mp, mp->m_ag_max_usable) ||
 	    range.len < mp->m_sb.sb_blocksize)
 		return -EINVAL;
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 119be0a..031dd92 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -723,7 +723,7 @@ xfs_fs_counts(
 	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
 	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
 	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
-							XFS_ALLOC_SET_ASIDE(mp);
+						mp->m_alloc_set_aside;
 
 	spin_lock(&mp->m_sb_lock);
 	cnt->freertx = mp->m_sb.sb_frextents;
@@ -796,7 +796,7 @@ retry:
 		__int64_t	free;
 
 		free = percpu_counter_sum(&mp->m_fdblocks) -
-							XFS_ALLOC_SET_ASIDE(mp);
+						mp->m_alloc_set_aside;
 		if (!free)
 			goto out; /* ENOSPC and fdblks_delta = 0 */
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3d4a4fb..335bcad 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1215,7 +1215,7 @@ xfs_mod_fdblocks(
 		batch = XFS_FDBLOCKS_BATCH;
 
 	__percpu_counter_add(&mp->m_fdblocks, delta, batch);
-	if (__percpu_counter_compare(&mp->m_fdblocks, XFS_ALLOC_SET_ASIDE(mp),
+	if (__percpu_counter_compare(&mp->m_fdblocks, mp->m_alloc_set_aside,
 				     XFS_FDBLOCKS_BATCH) >= 0) {
 		/* we had space! */
 		return 0;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6b52575..16f31f3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -96,6 +96,8 @@ typedef struct xfs_mount {
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* max inobt btree levels. */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
+	uint			m_alloc_set_aside; /* space we can't use */
+	uint			m_ag_max_usable; /* max space per AG */
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	struct mutex		m_growlock;	/* growfs mutex */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 36bd882..85e582d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1073,7 +1073,7 @@ xfs_fs_statfs(
 	statp->f_blocks = sbp->sb_dblocks - lsize;
 	spin_unlock(&mp->m_sb_lock);
 
-	statp->f_bfree = fdblocks - XFS_ALLOC_SET_ASIDE(mp);
+	statp->f_bfree = fdblocks - mp->m_alloc_set_aside;
 	statp->f_bavail = statp->f_bfree;
 
 	fakeinos = statp->f_bfree << sbp->sb_inopblog;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D5A277CD6
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:18:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 865A1304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:18:38 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 9441FjvpX9WpWhH5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:18:36 -0700 (PDT)
Subject: [PATCH 006/119] xfs: port differences from xfsprogs libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:18:30 -0700
Message-ID: <146612631079.12839.13685287438216197909.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Port various differences between xfsprogs and the kernel.  This
cleans up both so that we can develop rmap and reflink on the
same libxfs code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c      |    2 ++
 fs/xfs/libxfs/xfs_attr_leaf.h  |    2 +-
 fs/xfs/libxfs/xfs_bmap.c       |    2 +-
 fs/xfs/libxfs/xfs_bmap.h       |    6 ++++++
 fs/xfs/libxfs/xfs_btree.c      |    4 ++++
 fs/xfs/libxfs/xfs_btree.h      |    4 ++--
 fs/xfs/libxfs/xfs_dir2.h       |    2 ++
 fs/xfs/libxfs/xfs_dir2_priv.h  |    1 -
 fs/xfs/libxfs/xfs_dquot_buf.c  |   10 ++++++++++
 fs/xfs/libxfs/xfs_format.h     |    1 -
 fs/xfs/libxfs/xfs_ialloc.c     |    4 ++--
 fs/xfs/libxfs/xfs_inode_buf.c  |   19 +++++++++++++++----
 fs/xfs/libxfs/xfs_inode_buf.h  |    6 ++++--
 fs/xfs/libxfs/xfs_log_format.h |    4 ++--
 fs/xfs/libxfs/xfs_rtbitmap.c   |    1 -
 fs/xfs/libxfs/xfs_sb.c         |    4 ++++
 fs/xfs/libxfs/xfs_types.h      |    3 +++
 17 files changed, 58 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 99b077c..58bdca7 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2415,7 +2415,9 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
+#ifdef __KERNEL__
 		pag->pagb_tree = RB_ROOT;
+#endif
 		pag->pagf_init = 1;
 	}
 #ifdef DEBUG
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 4f2aed0..8ef420a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -51,7 +51,7 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
-int	xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes);
+int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
 void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 932381c..499e980 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1425,7 +1425,7 @@ xfs_bmap_search_multi_extents(
  * Else, *lastxp will be set to the index of the found
  * entry; *gotp will contain the entry.
  */
-STATIC xfs_bmbt_rec_host_t *                 /* pointer to found extent entry */
+xfs_bmbt_rec_host_t *                 /* pointer to found extent entry */
 xfs_bmap_search_extents(
 	xfs_inode_t     *ip,            /* incore inode pointer */
 	xfs_fileoff_t   bno,            /* block number searched for */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 423a34e..79e3ebe 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -231,4 +231,10 @@ int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		int num_exts);
 int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
 
+struct xfs_bmbt_rec_host *
+	xfs_bmap_search_extents(struct xfs_inode *ip, xfs_fileoff_t bno,
+				int fork, int *eofp, xfs_extnum_t *lastxp,
+				struct xfs_bmbt_irec *gotp,
+				struct xfs_bmbt_irec *prevp);
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 1f88e1c..105979d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2532,6 +2532,7 @@ error0:
 	return error;
 }
 
+#ifdef __KERNEL__
 struct xfs_btree_split_args {
 	struct xfs_btree_cur	*cur;
 	int			level;
@@ -2609,6 +2610,9 @@ xfs_btree_split(
 	destroy_work_on_stack(&args.work);
 	return args.result;
 }
+#else /* !KERNEL */
+#define xfs_btree_split	__xfs_btree_split
+#endif
 
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 2e874be..9a88839 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -95,7 +95,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(__mp, bmbt, stat); break; \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(__mp, ibt, stat); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(__mp, fibt, stat); break; \
-	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	case XFS_BTNUM_MAX: ASSERT(0); __mp = __mp /* fucking gcc */ ; break; \
 	}       \
 } while (0)
 
@@ -115,7 +115,7 @@ do {    \
 		__XFS_BTREE_STATS_ADD(__mp, ibt, stat, val); break; \
 	case XFS_BTNUM_FINO:	\
 		__XFS_BTREE_STATS_ADD(__mp, fibt, stat, val); break; \
-	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break; \
+	case XFS_BTNUM_MAX: ASSERT(0); __mp = __mp /* fucking gcc */ ; break; \
 	}       \
 } while (0)
 
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index e553536..0a62e73 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -177,6 +177,8 @@ extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
 		struct xfs_dir2_data_unused *dup);
 
+extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
+
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index ef9f6ea..d04547f 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -21,7 +21,6 @@
 struct dir_context;
 
 /* xfs_dir2.c */
-extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);
 extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 3cc3cf7..06b574d 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -31,10 +31,16 @@
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 
+/*
+ * XXX: kernel implementation causes ndquots calc to go real
+ * bad. Just leaving the existing userspace calc here right now.
+ */
 int
 xfs_calc_dquots_per_chunk(
 	unsigned int		nbblks)	/* basic block units */
 {
+#ifdef __KERNEL__
+	/* kernel code that goes wrong in userspace! */
 	unsigned int	ndquots;
 
 	ASSERT(nbblks > 0);
@@ -42,6 +48,10 @@ xfs_calc_dquots_per_chunk(
 	do_div(ndquots, sizeof(xfs_dqblk_t));
 
 	return ndquots;
+#else
+	ASSERT(nbblks > 0);
+	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
+#endif
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index dc97eb21..ba528b3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -835,7 +835,6 @@ typedef struct xfs_timestamp {
  * padding field for v3 inodes.
  */
 #define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
-#define XFS_DINODE_GOOD_VERSION(v)	((v) >= 1 && (v) <= 3)
 typedef struct xfs_dinode {
 	__be16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
 	__be16		di_mode;	/* mode and type of file */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 22297f9..77b5990 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2340,7 +2340,7 @@ xfs_imap(
 
 		imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
 		imap->im_len = XFS_FSB_TO_BB(mp, 1);
-		imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
+		imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
 		return 0;
 	}
 
@@ -2368,7 +2368,7 @@ out_map:
 
 	imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, cluster_agbno);
 	imap->im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
-	imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
+	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
 
 	/*
 	 * If the inode number maps to a block outside the bounds
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 9d9559e..794fa66 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -56,6 +56,17 @@ xfs_inobp_check(
 }
 #endif
 
+bool
+xfs_dinode_good_version(
+	struct xfs_mount *mp,
+	__u8		version)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		return version == 3;
+
+	return version == 1 || version == 2;
+}
+
 /*
  * If we are doing readahead on an inode buffer, we might be in log recovery
  * reading an inode allocation buffer that hasn't yet been replayed, and hence
@@ -90,7 +101,7 @@ xfs_inode_buf_verify(
 
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
-			    XFS_DINODE_GOOD_VERSION(dip->di_version);
+			xfs_dinode_good_version(mp, dip->di_version);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP,
 						XFS_RANDOM_ITOBP_INOTOBP))) {
@@ -369,7 +380,7 @@ xfs_log_dinode_to_disk(
 static bool
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
-	struct xfs_inode	*ip,
+	xfs_ino_t		ino,
 	struct xfs_dinode	*dip)
 {
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
@@ -384,7 +395,7 @@ xfs_dinode_verify(
 	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
 			      XFS_DINODE_CRC_OFF))
 		return false;
-	if (be64_to_cpu(dip->di_ino) != ip->i_ino)
+	if (be64_to_cpu(dip->di_ino) != ino)
 		return false;
 	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
@@ -459,7 +470,7 @@ xfs_iread(
 		return error;
 
 	/* even unallocated inodes are verified */
-	if (!xfs_dinode_verify(mp, ip, dip)) {
+	if (!xfs_dinode_verify(mp, ip->i_ino, dip)) {
 		xfs_alert(mp, "%s: validation failed for inode %lld failed",
 				__func__, ip->i_ino);
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 7c4dd32..958c543 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -57,8 +57,8 @@ struct xfs_icdinode {
  */
 struct xfs_imap {
 	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
-	ushort		im_len;		/* length in BBs of inode chunk */
-	ushort		im_boffset;	/* inode offset in block in bytes */
+	unsigned short	im_len;		/* length in BBs of inode chunk */
+	unsigned short	im_boffset;	/* inode offset in block in bytes */
 };
 
 int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
@@ -73,6 +73,8 @@ void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
 
+bool	xfs_dinode_good_version(struct xfs_mount *mp, __u8 version);
+
 #if defined(DEBUG)
 void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #else
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e8f49c0..e5baba3 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -462,8 +462,8 @@ static inline uint xfs_log_dinode_size(int version)
 typedef struct xfs_buf_log_format {
 	unsigned short	blf_type;	/* buf log item type indicator */
 	unsigned short	blf_size;	/* size of this item */
-	ushort		blf_flags;	/* misc state */
-	ushort		blf_len;	/* number of blocks in this buf */
+	unsigned short	blf_flags;	/* misc state */
+	unsigned short	blf_len;	/* number of blocks in this buf */
 	__int64_t	blf_blkno;	/* starting blkno of this buf */
 	unsigned int	blf_map_size;	/* used size of data bitmap in words */
 	unsigned int	blf_data_map[XFS_BLF_DATAMAP_SIZE]; /* dirty bitmap */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index e2e1106..ea45584 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1016,4 +1016,3 @@ xfs_rtfree_extent(
 	}
 	return 0;
 }
-
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 12ca867..09d6fd0 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -261,6 +261,7 @@ xfs_mount_validate_sb(
 	/*
 	 * Until this is fixed only page-sized or smaller data blocks work.
 	 */
+#ifdef __KERNEL__
 	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
 		xfs_warn(mp,
 		"File system with blocksize %d bytes. "
@@ -268,6 +269,7 @@ xfs_mount_validate_sb(
 				sbp->sb_blocksize, PAGE_SIZE);
 		return -ENOSYS;
 	}
+#endif
 
 	/*
 	 * Currently only very few inode sizes are supported.
@@ -291,10 +293,12 @@ xfs_mount_validate_sb(
 		return -EFBIG;
 	}
 
+#ifdef __KERNEL__
 	if (check_inprogress && sbp->sb_inprogress) {
 		xfs_warn(mp, "Offline file system operation in progress!");
 		return -EFSCORRUPTED;
 	}
+#endif
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b79dc66..f0d145a 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -75,11 +75,14 @@ typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
  * The sectorsize upper limit is due to sizeof(sb_sectsize).
+ * CRC enable filesystems use 512 byte inodes, meaning 512 byte block sizes
+ * cannot be used.
  */
 #define XFS_MIN_BLOCKSIZE_LOG	9	/* i.e. 512 bytes */
 #define XFS_MAX_BLOCKSIZE_LOG	16	/* i.e. 65536 bytes */
 #define XFS_MIN_BLOCKSIZE	(1 << XFS_MIN_BLOCKSIZE_LOG)
 #define XFS_MAX_BLOCKSIZE	(1 << XFS_MAX_BLOCKSIZE_LOG)
+#define XFS_MIN_CRC_BLOCKSIZE	(1 << (XFS_MIN_BLOCKSIZE_LOG + 1))
 #define XFS_MIN_SECTORSIZE_LOG	9	/* i.e. 512 bytes */
 #define XFS_MAX_SECTORSIZE_LOG	15	/* i.e. 32768 bytes */
 #define XFS_MIN_SECTORSIZE	(1 << XFS_MIN_SECTORSIZE_LOG)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

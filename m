Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 134F929E2A
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:09:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 70A25AC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:09:30 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id qLOAmALVDfGSCzu0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:09:19 -0800 (PST)
Subject: [PATCH 39/53] libxfs: add support for refcount btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:09:16 -0800
Message-ID: <20151219090916.14255.26444.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Import definitions and refcount btree code from the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h            |    2 
 include/linux.h             |    1 
 include/list.h              |    3 
 include/xfs_inode.h         |    8 +
 include/xfs_mount.h         |    4 
 include/xfs_trace.h         |   43 +++
 libxfs/Makefile             |    6 
 libxfs/xfs_alloc.c          |   21 ++
 libxfs/xfs_bmap.c           |  364 ++++++++++++++++++++++++---
 libxfs/xfs_bmap.h           |   30 ++
 libxfs/xfs_bmap_btree.c     |    1 
 libxfs/xfs_btree.c          |    8 -
 libxfs/xfs_btree.h          |    7 +
 libxfs/xfs_format.h         |   71 +++++
 libxfs/xfs_fs.h             |    1 
 libxfs/xfs_inode_fork.c     |   72 +++++
 libxfs/xfs_inode_fork.h     |   28 ++
 libxfs/xfs_perag_pool.c     |  378 ++++++++++++++++++++++++++++
 libxfs/xfs_perag_pool.h     |   47 ++++
 libxfs/xfs_refcount_btree.c |  576 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_refcount_btree.h |   71 +++++
 libxfs/xfs_rmap.c           |    2 
 libxfs/xfs_sb.c             |    9 +
 libxfs/xfs_shared.h         |    2 
 libxfs/xfs_types.h          |    3 
 25 files changed, 1694 insertions(+), 64 deletions(-)
 create mode 100644 libxfs/xfs_perag_pool.c
 create mode 100644 libxfs/xfs_perag_pool.h
 create mode 100644 libxfs/xfs_refcount_btree.c
 create mode 100644 libxfs/xfs_refcount_btree.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 5382191..c7041f5 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -78,6 +78,8 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/linux.h b/include/linux.h
index 674717c..990d4a3 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -145,6 +145,7 @@ typedef loff_t		xfs_off_t;
 typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
+typedef __uint32_t	xfs_nlink_t;
 
 /**
  * Abstraction of mountpoints.
diff --git a/include/list.h b/include/list.h
index f92faed..c52fc68 100644
--- a/include/list.h
+++ b/include/list.h
@@ -161,4 +161,7 @@ static inline void list_splice_init(struct list_head *list,
 	     &pos->member != (head); 					\
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
+#define list_first_entry(ptr, type, member) \
+	list_entry((ptr)->next, type, member)
+
 #endif	/* __LIST_H__ */
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 71c0fb4..681bc93 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -38,6 +38,7 @@ typedef struct xfs_inode {
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
 	struct xfs_buftarg	i_dev;		/* dev for this inode */
 	struct xfs_ifork	*i_afp;		/* attribute fork pointer */
+	struct xfs_ifork	*i_cowfp;	/* copy on write extents */
 	struct xfs_ifork	i_df;		/* data fork */
 	struct xfs_trans	*i_transp;	/* ptr to owning transaction */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
@@ -45,6 +46,8 @@ typedef struct xfs_inode {
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 	xfs_fsize_t		i_size;		/* in-memory size */
 	const struct xfs_dir_ops *d_ops;	/* directory ops vector */
+	xfs_extnum_t		i_cnextents;	/* # of extents in cow fork */
+	unsigned int		i_cformat;	/* format of cow fork */
 } xfs_inode_t;
 
 /*
@@ -81,6 +84,11 @@ xfs_set_projid(struct xfs_icdinode *id, prid_t projid)
 	id->di_projid_lo = (__uint16_t) (projid & 0xffff);
 }
 
+static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
+{
+	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
+}
+
 typedef struct cred {
 	uid_t	cr_uid;
 	gid_t	cr_gid;
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 390ec77..bf44d69 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -66,6 +66,8 @@ typedef struct xfs_mount {
 	uint			m_inobt_mnr[2];	/* XFS_INOBT_BLOCK_MINRECS */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
+	uint			m_refc_mxr[2];	/* max refc btree records */
+	uint			m_refc_mnr[2];	/* min refc btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* XFS_IN_MAXLEVELS */
@@ -140,6 +142,8 @@ typedef struct xfs_perag {
 	xfs_agino_t	pagl_leftrec;
 	xfs_agino_t	pagl_rightrec;
 	int		pagb_count;	/* pagb slots in use */
+	__uint8_t	pagf_refcount_level;
+	struct xfs_perag_pool	*pagf_refcountbt_pool;
 } xfs_perag_t;
 
 #define LIBXFS_MOUNT_DEBUGGER		0x0001
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 2c8d34e..da12c36 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -190,4 +190,47 @@
 #define trace_xfs_rmap_lcombine(a...)			((void) 0)
 #define trace_xfs_rmap_rcombine(a...)			((void) 0)
 
+#define trace_xfs_refcountbt_lookup(a...)		((void)0)
+#define trace_xfs_refcountbt_get(a...)			((void)0)
+#define trace_xfs_refcountbt_update(a...)		((void)0)
+#define trace_xfs_refcountbt_insert(a...)		((void)0)
+#define trace_xfs_refcountbt_delete(a...)		((void)0)
+#define trace_xfs_refcount_split_left_extent(a...)	((void)0)
+#define trace_xfs_refcount_split_left_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_split_right_extent(a...)	((void)0)
+#define trace_xfs_refcount_split_right_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_merge_center_extents_error(a...)	((void)0)
+#define trace_xfs_refcount_merge_left_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_merge_right_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_find_left_extent(a...)	((void)0)
+#define trace_xfs_refcount_find_left_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_find_right_extent(a...)	((void)0)
+#define trace_xfs_refcount_find_right_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_merge_center_extents(a...)	((void)0)
+#define trace_xfs_refcount_merge_left_extent(a...)	((void)0)
+#define trace_xfs_refcount_merge_right_extent(a...)	((void)0)
+#define trace_xfs_refcount_modify_extent(a...)		((void)0)
+#define trace_xfs_refcount_modify_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_adjust_error(a...)		((void)0)
+#define trace_xfs_refcount_increase(a...)		((void)0)
+#define trace_xfs_refcount_decrease(a...)		((void)0)
+#define trace_xfs_reflink_relink_blocks(a...)		((void)0)
+
+#define trace_xfs_bmap_remap_alloc(a...)		((void)0)
+#define trace_xfs_bmap_remap_alloc_error(a...)		((void)0)
+#define trace_xfs_refcount_find_shared(a...)		((void)0)
+#define trace_xfs_refcount_find_shared_result(a...)	((void)0)
+#define trace_xfs_refcount_find_shared_error(a...)	((void)0)
+#define trace_xfs_perag_pool_free_extent(a...)		((void)0)
+#define trace_xfs_perag_pool_free_error(a...)		((void)0)
+#define trace_xfs_perag_pool_grab_block(a...)		((void)0)
+#define trace_xfs_perag_pool_grab_block_error(a...)	((void)0)
+#define trace_xfs_perag_pool_init(a...)			((void)0)
+#define trace_xfs_perag_pool_init_error(a...)		((void)0)
+#define trace_xfs_perag_pool_alloc_block(a...)		((void)0)
+#define trace_xfs_perag_pool_alloc_block_error(a...)	((void)0)
+#define trace_xfs_perag_pool_free_block(a...)		((void)0)
+#define trace_xfs_perag_pool_ensure_capacity(a...)	((void)0)
+#define trace_xfs_perag_pool_ensure_capacity_error(a...)	((void)0)
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 3255917..70e7e2f 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -35,7 +35,10 @@ HFILES = \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
 	xfs_quota_defs.h \
+	xfs_perag_pool.h \
 	xfs_rmap_btree.h \
+	xfs_refcount.h \
+	xfs_refcount_btree.h \
 	xfs_sb.h \
 	xfs_shared.h \
 	xfs_trans_resv.h \
@@ -80,6 +83,9 @@ CFILES = cache.c \
 	xfs_inode_fork.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
+	xfs_perag_pool.c \
+	xfs_refcount.c \
+	xfs_refcount_btree.c \
 	xfs_rtbitmap.c \
 	xfs_rmap.c \
 	xfs_rmap_btree.c \
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index fd0767e..619e06d 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -32,6 +32,7 @@
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_refcount_btree.h"
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -46,10 +47,23 @@ STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
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
@@ -119,6 +133,8 @@ xfs_alloc_ag_max_usable(struct xfs_mount *mp)
 		/* rmap root block + full tree split on full AG */
 		blocks += 1 + (2 * mp->m_ag_maxlevels) - 1;
 	}
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		blocks += xfs_refcountbt_max_btree_size(mp);
 
 	return mp->m_sb.sb_agblocks - blocks;
 }
@@ -2409,6 +2425,10 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return false;
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	return true;;
 
 }
@@ -2529,6 +2549,7 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
 		pag->pagf_levels[XFS_BTNUM_RMAPi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
+		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
 		/* XXX: pagb_tree doesn't exist in userspace */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cedb64b..69eb3f0 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -37,6 +37,7 @@
 #include "xfs_trace.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_quota_defs.h"
+#include "xfs_refcount.h"
 #include "xfs_rmap_btree.h"
 
 
@@ -130,7 +131,8 @@ xfs_bmbt_lookup_ge(
  */
 static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
 {
-	return XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
+	return whichfork != XFS_COW_FORK &&
+		XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
 		XFS_IFORK_NEXTENTS(ip, whichfork) >
 			XFS_IFORK_MAXEXT(ip, whichfork);
 }
@@ -140,7 +142,8 @@ static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
  */
 static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 {
-	return XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
+	return whichfork != XFS_COW_FORK &&
+		XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
 		XFS_IFORK_NEXTENTS(ip, whichfork) <=
 			XFS_IFORK_MAXEXT(ip, whichfork);
 }
@@ -662,6 +665,7 @@ xfs_bmap_btree_to_extents(
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ASSERT(whichfork != XFS_COW_FORK);
 	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
 	rblock = ifp->if_broot;
@@ -728,6 +732,7 @@ xfs_bmap_extents_to_btree(
 	xfs_bmbt_ptr_t		*pp;		/* root block address pointer */
 
 	mp = ip->i_mount;
+	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS);
 
@@ -859,6 +864,7 @@ xfs_bmap_local_to_extents_empty(
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 
+	ASSERT(whichfork != XFS_COW_FORK);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
 	ASSERT(ifp->if_bytes == 0);
 	ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) == 0);
@@ -1692,7 +1698,8 @@ xfs_bmap_one_block(
  */
 STATIC int				/* error */
 xfs_bmap_add_extent_delay_real(
-	struct xfs_bmalloca	*bma)
+	struct xfs_bmalloca	*bma,
+	int			whichfork)
 {
 	struct xfs_bmbt_irec	*new = &bma->got;
 	int			diff;	/* temp value */
@@ -1711,10 +1718,13 @@ xfs_bmap_add_extent_delay_real(
 	xfs_filblks_t		temp2=0;/* value for da_new calculations */
 	int			tmp_rval;	/* partial logging flags */
 	struct xfs_mount	*mp;
-	int			whichfork = XFS_DATA_FORK;
+	xfs_extnum_t		*nextents;
 
 	mp  = bma->tp ? bma->tp->t_mountp : NULL;
 	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
+	ASSERT(whichfork != XFS_ATTR_FORK);
+	nextents = (whichfork == XFS_COW_FORK ? &bma->ip->i_cnextents :
+						&bma->ip->i_d.di_nextents);
 
 	ASSERT(bma->idx >= 0);
 	ASSERT(bma->idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
@@ -1728,6 +1738,9 @@ xfs_bmap_add_extent_delay_real(
 #define	RIGHT		r[1]
 #define	PREV		r[2]
 
+	if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
+
 	/*
 	 * Set up a bunch of variables to make the tests simpler.
 	 */
@@ -1814,7 +1827,7 @@ xfs_bmap_add_extent_delay_real(
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
 		xfs_iext_remove(bma->ip, bma->idx + 1, 2, state);
-		bma->ip->i_d.di_nextents--;
+		(*nextents)--;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -1842,7 +1855,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		error = xfs_rmap_combine(mp, bma->rlist, bma->ip->i_ino,
-				XFS_DATA_FORK, &LEFT, &RIGHT, &PREV);
+				whichfork, &LEFT, &RIGHT, &PREV);
 		if (error)
 			goto done;
 		break;
@@ -1878,7 +1891,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		error = xfs_rmap_resize(mp, bma->rlist, bma->ip->i_ino,
-				XFS_DATA_FORK, &LEFT, PREV.br_blockcount);
+				whichfork, &LEFT, PREV.br_blockcount);
 		if (error)
 			goto done;
 		break;
@@ -1913,7 +1926,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		error = xfs_rmap_move(mp, bma->rlist, bma->ip->i_ino,
-				XFS_DATA_FORK, &RIGHT, -PREV.br_blockcount);
+				whichfork, &RIGHT, -PREV.br_blockcount);
 		if (error)
 			goto done;
 		break;
@@ -1928,7 +1941,7 @@ xfs_bmap_add_extent_delay_real(
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		bma->ip->i_d.di_nextents++;
+		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -1946,7 +1959,7 @@ xfs_bmap_add_extent_delay_real(
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
-				XFS_DATA_FORK, new);
+				whichfork, new);
 		if (error)
 			goto done;
 		break;
@@ -1985,7 +1998,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		error = xfs_rmap_resize(mp, bma->rlist, bma->ip->i_ino,
-				XFS_DATA_FORK, &LEFT, new->br_blockcount);
+				whichfork, &LEFT, new->br_blockcount);
 		if (error)
 			goto done;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
@@ -2006,7 +2019,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = PREV.br_blockcount - new->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
 		xfs_iext_insert(bma->ip, bma->idx, 1, new, state);
-		bma->ip->i_d.di_nextents++;
+		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2024,7 +2037,7 @@ xfs_bmap_add_extent_delay_real(
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
-				XFS_DATA_FORK, new);
+				whichfork, new);
 		if (error)
 			goto done;
 
@@ -2076,7 +2089,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		error = xfs_rmap_move(mp, bma->rlist, bma->ip->i_ino,
-				XFS_DATA_FORK, &RIGHT, -new->br_blockcount);
+				whichfork, &RIGHT, -new->br_blockcount);
 
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock));
@@ -2096,7 +2109,7 @@ xfs_bmap_add_extent_delay_real(
 		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
 		xfs_iext_insert(bma->ip, bma->idx + 1, 1, new, state);
-		bma->ip->i_d.di_nextents++;
+		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2114,7 +2127,7 @@ xfs_bmap_add_extent_delay_real(
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
-				XFS_DATA_FORK, new);
+				whichfork, new);
 		if (error)
 			goto done;
 
@@ -2169,7 +2182,7 @@ xfs_bmap_add_extent_delay_real(
 		RIGHT.br_blockcount = temp2;
 		/* insert LEFT (r[0]) and RIGHT (r[1]) at the same time */
 		xfs_iext_insert(bma->ip, bma->idx + 1, 2, &LEFT, state);
-		bma->ip->i_d.di_nextents++;
+		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2187,7 +2200,7 @@ xfs_bmap_add_extent_delay_real(
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
-				XFS_DATA_FORK, new);
+				whichfork, new);
 		if (error)
 			goto done;
 
@@ -2266,7 +2279,8 @@ xfs_bmap_add_extent_delay_real(
 
 	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
 done:
-	bma->logflags |= rval;
+	if (whichfork != XFS_COW_FORK)
+		bma->logflags |= rval;
 	return error;
 #undef	LEFT
 #undef	RIGHT
@@ -2867,6 +2881,7 @@ done:
 STATIC void
 xfs_bmap_add_extent_hole_delay(
 	xfs_inode_t		*ip,	/* incore inode pointer */
+	int			whichfork,
 	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_bmbt_irec_t		*new)	/* new data to add to file extents */
 {
@@ -2878,8 +2893,10 @@ xfs_bmap_add_extent_hole_delay(
 	int			state;  /* state bits, accessed thru macros */
 	xfs_filblks_t		temp=0;	/* temp for indirect calculations */
 
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	ifp = XFS_IFORK_PTR(ip, whichfork);
 	state = 0;
+	if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
 	ASSERT(isnullstartblock(new->br_startblock));
 
 	/*
@@ -2897,7 +2914,7 @@ xfs_bmap_add_extent_hole_delay(
 	 * Check and set flags if the current (right) segment exists.
 	 * If it doesn't exist, we're converting the hole at end-of-file.
 	 */
-	if (*idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+	if (*idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &right);
 
@@ -3032,6 +3049,7 @@ xfs_bmap_add_extent_hole_real(
 	ASSERT(!isnullstartblock(new->br_startblock));
 	ASSERT(!bma->cur ||
 	       !(bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
+	ASSERT(whichfork != XFS_COW_FORK);
 
 	XFS_STATS_INC(xs_add_exlist);
 
@@ -3967,7 +3985,8 @@ xfs_bmap_btalloc(
 		ASSERT(nullfb || fb_agno == args.agno ||
 		       (ap->flist->xbf_low && fb_agno < args.agno));
 		ap->length = args.len;
-		ap->ip->i_d.di_nblocks += args.len;
+		if (!(ap->flags & XFS_BMAPI_COWFORK))
+			ap->ip->i_d.di_nblocks += args.len;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 		if (ap->wasdel)
 			ap->ip->i_delayed_blks -= args.len;
@@ -3987,6 +4006,54 @@ xfs_bmap_btalloc(
 }
 
 /*
+ * For a remap operation, just "allocate" an extent at the address that the
+ * caller passed in, and ensure that the AGFL is the right size.  The caller
+ * will then map the "allocated" extent into the file somewhere.
+ */
+STATIC int
+xfs_bmap_remap_alloc(
+	struct xfs_bmalloca	*ap)
+{
+	struct xfs_trans	*tp = ap->tp;
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_agblock_t		bno;
+	struct xfs_alloc_arg	args;
+	int			error;
+
+	/*
+	 * validate that the block number is legal - the enables us to detect
+	 * and handle a silent filesystem corruption rather than crashing.
+	 */
+	memset(&args, 0, sizeof(struct xfs_alloc_arg));
+	args.tp = ap->tp;
+	args.mp = ap->tp->t_mountp;
+	bno = *ap->firstblock;
+	args.agno = XFS_FSB_TO_AGNO(mp, bno);
+	ASSERT(args.agno < mp->m_sb.sb_agcount);
+	args.agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	ASSERT(args.agbno < mp->m_sb.sb_agblocks);
+
+	/* "Allocate" the extent from the range we passed in. */
+	trace_xfs_bmap_remap_alloc(ap->ip, *ap->firstblock, ap->length);
+	ap->blkno = bno;
+	ap->ip->i_d.di_nblocks += ap->length;
+	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+
+	/* Fix the freelist, like a real allocator does. */
+	args.pag = xfs_perag_get(args.mp, args.agno);
+	ASSERT(args.pag);
+
+	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
+	if (error)
+		goto error0;
+error0:
+	xfs_perag_put(args.pag);
+	if (error)
+		trace_xfs_bmap_remap_alloc_error(ap->ip, error, _RET_IP_);
+	return error;
+}
+
+/*
  * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
  * It figures out where to ask the underlying allocator to put the new extent.
  */
@@ -3994,6 +4061,8 @@ STATIC int
 xfs_bmap_alloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
+	if (ap->flags & XFS_BMAPI_REMAP)
+		return xfs_bmap_remap_alloc(ap);
 	if (XFS_IS_REALTIME_INODE(ap->ip) && ap->userdata)
 		return xfs_bmap_rtalloc(ap);
 	return xfs_bmap_btalloc(ap);
@@ -4122,8 +4191,7 @@ xfs_bmapi_read(
 	int			error;
 	int			eof;
 	int			n = 0;
-	int			whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
-						XFS_ATTR_FORK : XFS_DATA_FORK;
+	int			whichfork = xfs_bmapi_whichfork(flags);
 
 	ASSERT(*nmap >= 1);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK|XFS_BMAPI_ENTIRE|
@@ -4194,6 +4262,7 @@ xfs_bmapi_read(
 STATIC int
 xfs_bmapi_reserve_delalloc(
 	struct xfs_inode	*ip,
+	int			whichfork,
 	xfs_fileoff_t		aoff,
 	xfs_filblks_t		len,
 	struct xfs_bmbt_irec	*got,
@@ -4202,7 +4271,7 @@ xfs_bmapi_reserve_delalloc(
 	int			eof)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
 	char			rt = XFS_IS_REALTIME_INODE(ip);
@@ -4261,7 +4330,7 @@ xfs_bmapi_reserve_delalloc(
 	got->br_startblock = nullstartblock(indlen);
 	got->br_blockcount = alen;
 	got->br_state = XFS_EXT_NORM;
-	xfs_bmap_add_extent_hole_delay(ip, lastx, got);
+	xfs_bmap_add_extent_hole_delay(ip, whichfork, lastx, got);
 
 	/*
 	 * Update our extent pointer, given that xfs_bmap_add_extent_hole_delay
@@ -4293,6 +4362,7 @@ out_unreserve_quota:
 int
 xfs_bmapi_delay(
 	struct xfs_inode	*ip,	/* incore inode */
+	int			whichfork, /* data or cow fork? */
 	xfs_fileoff_t		bno,	/* starting file offs. mapped */
 	xfs_filblks_t		len,	/* length to map in file */
 	struct xfs_bmbt_irec	*mval,	/* output: map values */
@@ -4300,7 +4370,7 @@ xfs_bmapi_delay(
 	int			flags)	/* XFS_BMAPI_... */
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_bmbt_irec	got;	/* current file extent record */
 	struct xfs_bmbt_irec	prev;	/* previous file extent record */
 	xfs_fileoff_t		obno;	/* old block number (offset) */
@@ -4310,14 +4380,15 @@ xfs_bmapi_delay(
 	int			n = 0;	/* current extent index */
 	int			error = 0;
 
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK);
 	ASSERT(*nmap >= 1);
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
 	ASSERT(!(flags & ~XFS_BMAPI_ENTIRE));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
+	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
 	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmapi_delay", XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
@@ -4328,19 +4399,20 @@ xfs_bmapi_delay(
 
 	XFS_STATS_INC(xs_blk_mapw);
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+	if (whichfork == XFS_DATA_FORK && !(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(NULL, ip, whichfork);
 		if (error)
 			return error;
 	}
 
-	xfs_bmap_search_extents(ip, bno, XFS_DATA_FORK, &eof, &lastx, &got, &prev);
+	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got, &prev);
 	end = bno + len;
 	obno = bno;
 
 	while (bno < end && n < *nmap) {
 		if (eof || got.br_startoff > bno) {
-			error = xfs_bmapi_reserve_delalloc(ip, bno, len, &got,
+			error = xfs_bmapi_reserve_delalloc(ip, whichfork,
+							   bno, len, &got,
 							   &prev, &lastx, eof);
 			if (error) {
 				if (n == 0) {
@@ -4376,8 +4448,7 @@ xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
 {
 	struct xfs_mount	*mp = bma->ip->i_mount;
-	int			whichfork = (bma->flags & XFS_BMAPI_ATTRFORK) ?
-						XFS_ATTR_FORK : XFS_DATA_FORK;
+	int			whichfork = xfs_bmapi_whichfork(bma->flags);
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 	int			tmp_logflags = 0;
 	int			error;
@@ -4463,7 +4534,7 @@ xfs_bmapi_allocate(
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
 	if (bma->wasdel)
-		error = xfs_bmap_add_extent_delay_real(bma);
+		error = xfs_bmap_add_extent_delay_real(bma, whichfork);
 	else
 		error = xfs_bmap_add_extent_hole_real(bma, whichfork);
 
@@ -4493,8 +4564,7 @@ xfs_bmapi_convert_unwritten(
 	xfs_filblks_t		len,
 	int			flags)
 {
-	int			whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
-						XFS_ATTR_FORK : XFS_DATA_FORK;
+	int			whichfork = xfs_bmapi_whichfork(flags);
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 	int			tmp_logflags = 0;
 	int			error;
@@ -4510,6 +4580,8 @@ xfs_bmapi_convert_unwritten(
 			(XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT))
 		return 0;
 
+	ASSERT(whichfork != XFS_COW_FORK);
+
 	/*
 	 * Modify (by adding) the state flag, if writing.
 	 */
@@ -4605,8 +4677,7 @@ xfs_bmapi_write(
 	orig_mval = mval;
 	orig_nmap = *nmap;
 #endif
-	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
-		XFS_ATTR_FORK : XFS_DATA_FORK;
+	whichfork = xfs_bmapi_whichfork(flags);
 
 	ASSERT(*nmap >= 1);
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
@@ -4615,6 +4686,17 @@ xfs_bmapi_write(
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	if (whichfork == XFS_ATTR_FORK)
+		ASSERT(!(flags & XFS_BMAPI_REMAP));
+	if (whichfork == XFS_COW_FORK) {
+		ASSERT(!(flags & XFS_BMAPI_REMAP));
+		ASSERT(!(flags & XFS_BMAPI_PREALLOC));
+		ASSERT(!(flags & XFS_BMAPI_CONVERT));
+	}
+	if (flags & XFS_BMAPI_REMAP) {
+		ASSERT(!(flags & XFS_BMAPI_PREALLOC));
+		ASSERT(!(flags & XFS_BMAPI_CONVERT));
+	}
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -4665,6 +4747,14 @@ xfs_bmapi_write(
 		wasdelay = !inhole && isnullstartblock(bma.got.br_startblock);
 
 		/*
+		 * Make sure we only reflink into a hole.
+		 */
+		if (flags & XFS_BMAPI_REMAP)
+			ASSERT(inhole);
+		if (flags & XFS_BMAPI_COWFORK)
+			ASSERT(!inhole);
+
+		/*
 		 * First, deal with the hole before the allocated space
 		 * that we found, if any.
 		 */
@@ -4827,6 +4917,8 @@ xfs_bmap_del_extent(
 
 	if (whichfork == XFS_ATTR_FORK)
 		state |= BMAP_ATTRFORK;
+	else if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -5103,9 +5195,18 @@ xfs_bmap_del_extent(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx)
-		xfs_bmap_add_free(mp, flist, del->br_startblock,
-			del->br_blockcount, NULL);
+	if (do_fx) {
+		if (xfs_is_reflink_inode(ip)) {
+			error = xfs_refcount_put_extent(mp, tp, flist,
+						del->br_startblock,
+						del->br_blockcount, NULL);
+			if (error)
+				goto done;
+		} else
+			xfs_bmap_add_free(mp, flist, del->br_startblock,
+					  del->br_blockcount, NULL);
+	}
+
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
@@ -5130,6 +5231,179 @@ done:
 }
 
 /*
+ * xfs_bunmapi_cow() -- Remove the relevant parts of the CoW fork.
+ *			See xfs_bmap_del_extent.
+ * @ip: XFS inode.
+ * @idx: Extent number to delete.
+ * @del: Extent to remove.
+ */
+int
+xfs_bunmapi_cow(
+	xfs_inode_t		*ip,
+	xfs_extnum_t		*idx,
+	xfs_bmbt_irec_t		*del)
+{
+	xfs_filblks_t		da_new;	/* new delay-alloc indirect blocks */
+	xfs_filblks_t		da_old;	/* old delay-alloc indirect blocks */
+	xfs_fsblock_t		del_endblock = 0;/* first block past del */
+	xfs_fileoff_t		del_endoff;	/* first offset past del */
+	int			delay;	/* current block is delayed allocated */
+	xfs_bmbt_rec_host_t	*ep;	/* current extent entry pointer */
+	int			error;	/* error return value */
+	xfs_bmbt_irec_t		got;	/* current extent entry */
+	xfs_fileoff_t		got_endoff;	/* first offset past got */
+	xfs_ifork_t		*ifp;	/* inode fork pointer */
+	xfs_mount_t		*mp;	/* mount structure */
+	xfs_filblks_t		nblks;	/* quota/sb block count */
+	xfs_bmbt_irec_t		new;	/* new record to be inserted */
+	/* REFERENCED */
+	uint			qfield;	/* quota field to update */
+	xfs_filblks_t		temp;	/* for indirect length calculations */
+	xfs_filblks_t		temp2;	/* for indirect length calculations */
+	int			state = BMAP_COWFORK;
+
+	mp = ip->i_mount;
+	XFS_STATS_INC(xs_del_exlist);
+
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	ASSERT((*idx >= 0) && (*idx < ifp->if_bytes /
+		(uint)sizeof(xfs_bmbt_rec_t)));
+	ASSERT(del->br_blockcount > 0);
+	ep = xfs_iext_get_ext(ifp, *idx);
+	xfs_bmbt_get_all(ep, &got);
+	ASSERT(got.br_startoff <= del->br_startoff);
+	del_endoff = del->br_startoff + del->br_blockcount;
+	got_endoff = got.br_startoff + got.br_blockcount;
+	ASSERT(got_endoff >= del_endoff);
+	delay = isnullstartblock(got.br_startblock);
+	ASSERT(isnullstartblock(del->br_startblock) == delay);
+	qfield = 0;
+	error = 0;
+	/*
+	 * If deleting a real allocation, must free up the disk space.
+	 */
+	if (!delay) {
+		nblks = del->br_blockcount;
+		qfield = XFS_TRANS_DQ_BCOUNT;
+		/*
+		 * Set up del_endblock and cur for later.
+		 */
+		del_endblock = del->br_startblock + del->br_blockcount;
+		da_old = da_new = 0;
+	} else {
+		da_old = startblockval(got.br_startblock);
+		da_new = 0;
+		nblks = 0;
+	}
+	qfield = qfield;
+	nblks = nblks;
+
+	/*
+	 * Set flag value to use in switch statement.
+	 * Left-contig is 2, right-contig is 1.
+	 */
+	switch (((got.br_startoff == del->br_startoff) << 1) |
+		(got_endoff == del_endoff)) {
+	case 3:
+		/*
+		 * Matches the whole extent.  Delete the entry.
+		 */
+		xfs_iext_remove(ip, *idx, 1, BMAP_COWFORK);
+		--*idx;
+		break;
+
+	case 2:
+		/*
+		 * Deleting the first part of the extent.
+		 */
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_startoff(ep, del_endoff);
+		temp = got.br_blockcount - del->br_blockcount;
+		xfs_bmbt_set_blockcount(ep, temp);
+		if (delay) {
+			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+				da_old);
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+			trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+			da_new = temp;
+			break;
+		}
+		xfs_bmbt_set_startblock(ep, del_endblock);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		break;
+
+	case 1:
+		/*
+		 * Deleting the last part of the extent.
+		 */
+		temp = got.br_blockcount - del->br_blockcount;
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(ep, temp);
+		if (delay) {
+			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+				da_old);
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+			trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+			da_new = temp;
+			break;
+		}
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		break;
+
+	case 0:
+		/*
+		 * Deleting the middle of the extent.
+		 */
+		temp = del->br_startoff - got.br_startoff;
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(ep, temp);
+		new.br_startoff = del_endoff;
+		temp2 = got_endoff - del_endoff;
+		new.br_blockcount = temp2;
+		new.br_state = got.br_state;
+		if (!delay) {
+			new.br_startblock = del_endblock;
+		} else {
+			temp = xfs_bmap_worst_indlen(ip, temp);
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+			temp2 = xfs_bmap_worst_indlen(ip, temp2);
+			new.br_startblock = nullstartblock((int)temp2);
+			da_new = temp + temp2;
+			while (da_new > da_old) {
+				if (temp) {
+					temp--;
+					da_new--;
+					xfs_bmbt_set_startblock(ep,
+						nullstartblock((int)temp));
+				}
+				if (da_new == da_old)
+					break;
+				if (temp2) {
+					temp2--;
+					da_new--;
+					new.br_startblock =
+						nullstartblock((int)temp2);
+				}
+			}
+		}
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_insert(ip, *idx + 1, 1, &new, state);
+		++*idx;
+		break;
+	}
+
+	/*
+	 * Account for change in delayed indirect blocks.
+	 * Nothing to do for disk quota accounting here.
+	 */
+	ASSERT(da_old >= da_new);
+	if (da_old > da_new)
+		xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new), false);
+
+	return error;
+}
+
+/*
  * Unmap (remove) blocks from a file.
  * If nexts is nonzero then the number of extents to remove is limited to
  * that value.  If not all extents in the block range can be removed then
@@ -5171,8 +5445,8 @@ xfs_bunmapi(
 
 	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
 
-	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
-		XFS_ATTR_FORK : XFS_DATA_FORK;
+	whichfork = xfs_bmapi_whichfork(flags);
+	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (unlikely(
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 77d8771..9d6d060 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -118,6 +118,15 @@ typedef	struct xfs_bmap_free
  * from written to unwritten, otherwise convert from unwritten to written.
  */
 #define XFS_BMAPI_CONVERT	0x040
+/*
+ * Map the inode offset to the block given in ap->firstblock.  Primarily
+ * used for reflink.  The range must be in a hole, and this flag cannot be
+ * turned on with PREALLOC or CONVERT, and cannot be used on the attr fork.
+ */
+#define XFS_BMAPI_REMAP		0x100
+
+/* Map something in the CoW fork. */
+#define XFS_BMAPI_COWFORK	0x200
 
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
@@ -126,7 +135,9 @@ typedef	struct xfs_bmap_free
 	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
 	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
 	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
-	{ XFS_BMAPI_CONVERT,	"CONVERT" }
+	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
+	{ XFS_BMAPI_REMAP,	"REMAP" }, \
+	{ XFS_BMAPI_COWFORK,	"COWFORK" }
 
 
 static inline int xfs_bmapi_aflag(int w)
@@ -134,6 +145,15 @@ static inline int xfs_bmapi_aflag(int w)
 	return (w == XFS_ATTR_FORK ? XFS_BMAPI_ATTRFORK : 0);
 }
 
+static inline int xfs_bmapi_whichfork(int bmapi_flags)
+{
+	if (bmapi_flags & XFS_BMAPI_COWFORK)
+		return XFS_COW_FORK;
+	else if (bmapi_flags & XFS_BMAPI_ATTRFORK)
+		return XFS_ATTR_FORK;
+	return XFS_DATA_FORK;
+}
+
 /*
  * Special values for xfs_bmbt_irec_t br_startblock field.
  */
@@ -160,13 +180,15 @@ static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
 #define BMAP_LEFT_VALID		(1 << 6)
 #define BMAP_RIGHT_VALID	(1 << 7)
 #define BMAP_ATTRFORK		(1 << 8)
+#define BMAP_COWFORK		(1 << 9)
 
 #define XFS_BMAP_EXT_FLAGS \
 	{ BMAP_LEFT_CONTIG,	"LC" }, \
 	{ BMAP_RIGHT_CONTIG,	"RC" }, \
 	{ BMAP_LEFT_FILLING,	"LF" }, \
 	{ BMAP_RIGHT_FILLING,	"RF" }, \
-	{ BMAP_ATTRFORK,	"ATTR" }
+	{ BMAP_ATTRFORK,	"ATTR" }, \
+	{ BMAP_COWFORK,		"COW" }
 
 
 /*
@@ -213,7 +235,7 @@ int	xfs_bmap_read_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
-int	xfs_bmapi_delay(struct xfs_inode *ip, xfs_fileoff_t bno,
+int	xfs_bmapi_delay(struct xfs_inode *ip, int whichfork, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
 int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
@@ -221,6 +243,8 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fsblock_t *firstblock, xfs_extlen_t total,
 		struct xfs_bmbt_irec *mval, int *nmap,
 		struct xfs_bmap_free *flist);
+int	xfs_bunmapi_cow(struct xfs_inode *ip, xfs_extnum_t *idx,
+		struct xfs_bmbt_irec *del);
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
 		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index bc09b2b..dc3152b 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -785,6 +785,7 @@ xfs_bmbt_init_cursor(
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_cur	*cur;
+	ASSERT(whichfork != XFS_COW_FORK);
 
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 1622ddd..f325adc 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -41,9 +41,10 @@ kmem_zone_t	*xfs_btree_cur_zone;
  */
 static const __uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
 	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, 0, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
-	  XFS_FIBT_MAGIC },
+	  XFS_FIBT_MAGIC, 0 },
 	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC, XFS_RMAP_CRC_MAGIC,
-	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC }
+	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC,
+	  XFS_REFC_CRC_MAGIC }
 };
 #define xfs_btree_magic(cur) \
 	xfs_magics[!!((cur)->bc_flags & XFS_BTREE_CRC_BLOCKS)][cur->bc_btnum]
@@ -1129,6 +1130,9 @@ xfs_btree_set_refs(
 	case XFS_BTNUM_RMAP:
 		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
 		break;
+	case XFS_BTNUM_REFC:
+		xfs_buf_set_ref(bp, XFS_REFC_BTREE_REF);
+		break;
 	default:
 		ASSERT(0);
 	}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index dd29d15..94848a1 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -43,6 +43,7 @@ union xfs_btree_key {
 	xfs_alloc_key_t			alloc;
 	struct xfs_inobt_key		inobt;
 	struct xfs_rmap_key		rmap;
+	struct xfs_refcount_key		refc;
 };
 
 union xfs_btree_rec {
@@ -51,6 +52,7 @@ union xfs_btree_rec {
 	struct xfs_alloc_rec		alloc;
 	struct xfs_inobt_rec		inobt;
 	struct xfs_rmap_rec		rmap;
+	struct xfs_refcount_rec		refc;
 };
 
 /*
@@ -66,6 +68,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
+#define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 
 /*
  * For logging record fields.
@@ -98,6 +101,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(rmap, stat); break;	\
+	case XFS_BTNUM_REFC: __XFS_BTREE_STATS_INC(refcbt, stat); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -113,6 +117,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_ADD(rmap, stat, val); break; \
+	case XFS_BTNUM_REFC: __XFS_BTREE_STATS_ADD(refcbt, stat, val); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -205,6 +210,7 @@ typedef struct xfs_btree_cur
 		xfs_bmbt_irec_t		b;
 		xfs_inobt_rec_incore_t	i;
 		struct xfs_rmap_irec	r;
+		struct xfs_refcount_irec	rc;
 	}		bc_rec;		/* current insert/search record value */
 	struct xfs_buf	*bc_bufs[XFS_BTREE_MAXLEVELS];	/* buf ptr per level */
 	int		bc_ptrs[XFS_BTREE_MAXLEVELS];	/* key/record # */
@@ -217,6 +223,7 @@ typedef struct xfs_btree_cur
 	union {
 		struct {			/* needed for BNO, CNT, INO */
 			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
+			struct xfs_bmap_free *flist;	/* list to free after */
 			xfs_agnumber_t	agno;	/* ag number */
 		} a;
 		struct {			/* needed for BMAP */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 94bd2f9..7876c98 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -456,9 +456,11 @@ xfs_sb_has_compat_feature(
 
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
+#define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
-		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
@@ -529,6 +531,12 @@ static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
 }
 
+static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
+}
+
 static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
@@ -641,12 +649,15 @@ typedef struct xfs_agf {
 	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
 	uuid_t		agf_uuid;	/* uuid of filesystem */
 
+	__be32		agf_refcount_root;	/* refcount tree root block */
+	__be32		agf_refcount_level;	/* refcount btree levels */
+
 	/*
 	 * reserve some contiguous space for future logged fields before we add
 	 * the unlogged fields. This makes the range logging via flags and
 	 * structure offsets much simpler.
 	 */
-	__be64		agf_spare64[16];
+	__be64		agf_spare64[15];
 
 	/* unlogged fields, written during buffer writeback. */
 	__be64		agf_lsn;	/* last write sequence */
@@ -1032,6 +1043,18 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM)
 
 /*
+ * Values for di_flags2
+ * There should be a one-to-one correspondence between these flags and the
+ * XFS_XFLAG_s.
+ */
+#define XFS_DIFLAG2_REFLINK_BIT   0	/* file's blocks may be reflinked */
+#define XFS_DIFLAG2_REFLINK      (1 << XFS_DIFLAG2_REFLINK_BIT)
+
+#define XFS_DIFLAG2_ANY \
+	(XFS_DIFLAG2_REFLINK)
+
+
+/*
  * Inode number format:
  * low inopblog bits - offset in block
  * next agblklog bits - block number in ag
@@ -1376,7 +1399,8 @@ XFS_RMAP_INO_OWNER(
 #define XFS_RMAP_OWN_AG		(-5ULL)	/* AG freespace btree blocks */
 #define XFS_RMAP_OWN_INOBT	(-6ULL)	/* Inode btree blocks */
 #define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
-#define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
+#define XFS_RMAP_OWN_REFC	(-8ULL) /* refcount tree */
+#define XFS_RMAP_OWN_MIN	(-9ULL) /* guard */
 
 #define XFS_RMAP_NON_INODE_OWNER(owner)	(!!((owner) & (1ULL << 63)))
 
@@ -1479,6 +1503,47 @@ xfs_owner_info_pack(
 }
 
 /*
+ * Reference Count Btree format definitions
+ *
+ */
+#define	XFS_REFC_CRC_MAGIC	0x52334643	/* 'R3FC' */
+
+unsigned int xfs_refc_block(struct xfs_mount *mp);
+
+/*
+ * Data record/key structure
+ *
+ * Each record associates a range of physical blocks (starting at
+ * rc_startblock and ending rc_blockcount blocks later) with a
+ * reference count (rc_refcount).  A record is only stored in the
+ * btree if the refcount is > 2.  An entry in the free block btree
+ * means that the refcount is 0, and no entries anywhere means that
+ * the refcount is 1, as was true in XFS before reflinking.
+ */
+struct xfs_refcount_rec {
+	__be32		rc_startblock;	/* starting block number */
+	__be32		rc_blockcount;	/* count of blocks */
+	__be32		rc_refcount;	/* number of inodes linked here */
+};
+
+struct xfs_refcount_key {
+	__be32		rc_startblock;	/* starting block number */
+};
+
+struct xfs_refcount_irec {
+	xfs_agblock_t	rc_startblock;	/* starting block number */
+	xfs_extlen_t	rc_blockcount;	/* count of free blocks */
+	xfs_nlink_t	rc_refcount;	/* number of inodes linked here */
+};
+
+#define MAXREFCOUNT	((xfs_nlink_t)~0U)
+#define MAXREFCEXTLEN	((xfs_extlen_t)~0U)
+
+/* btree pointer type */
+typedef __be32 xfs_refcount_ptr_t;
+
+
+/*
  * BMAP Btree format definitions
  *
  * This includes both the root block definition that sits inside an inode fork
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 56990eb..3af7747 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -67,6 +67,7 @@ struct fsxattr {
 #define XFS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
 #define XFS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
 #define XFS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
+#define XFS_XFLAG_REFLINK	0x00008000	/* file is reflinked */
 #define XFS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /*
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 96a633e..0c60205 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -117,6 +117,26 @@ xfs_iformat_fork(
 		return -EFSCORRUPTED;
 	}
 
+	if (unlikely(xfs_is_reflink_inode(ip) &&
+	    (ip->i_d.di_mode & S_IFMT) != S_IFREG)) {
+		xfs_warn(ip->i_mount,
+			"corrupt dinode %llu, wrong file type for reflink.",
+			ip->i_ino);
+		XFS_CORRUPTION_ERROR("xfs_iformat(reflink)",
+				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
+		return -EFSCORRUPTED;
+	}
+
+	if (unlikely(xfs_is_reflink_inode(ip) &&
+	    (ip->i_d.di_flags & XFS_DIFLAG_REALTIME))) {
+		xfs_warn(ip->i_mount,
+			"corrupt dinode %llu, has reflink+realtime flag set.",
+			ip->i_ino);
+		XFS_CORRUPTION_ERROR("xfs_iformat(reflink)",
+				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
+		return -EFSCORRUPTED;
+	}
+
 	switch (ip->i_d.di_mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:
@@ -182,9 +202,14 @@ xfs_iformat_fork(
 		XFS_ERROR_REPORT("xfs_iformat(7)", XFS_ERRLEVEL_LOW, ip->i_mount);
 		return -EFSCORRUPTED;
 	}
-	if (error) {
+	if (error)
 		return error;
+
+	if (xfs_is_reflink_inode(ip)) {
+		ASSERT(ip->i_cowfp == NULL);
+		xfs_ifork_init_cow(ip);
 	}
+
 	if (!XFS_DFORK_Q(dip))
 		return 0;
 
@@ -204,7 +229,8 @@ xfs_iformat_fork(
 			XFS_CORRUPTION_ERROR("xfs_iformat(8)",
 					     XFS_ERRLEVEL_LOW,
 					     ip->i_mount, dip);
-			return -EFSCORRUPTED;
+			error = -EFSCORRUPTED;
+			break;
 		}
 
 		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK, size);
@@ -222,6 +248,9 @@ xfs_iformat_fork(
 	if (error) {
 		kmem_zone_free(xfs_ifork_zone, ip->i_afp);
 		ip->i_afp = NULL;
+		if (ip->i_cowfp)
+			kmem_zone_free(xfs_ifork_zone, ip->i_cowfp);
+		ip->i_cowfp = NULL;
 		xfs_idestroy_fork(ip, XFS_DATA_FORK);
 	}
 	return error;
@@ -712,6 +741,9 @@ xfs_idestroy_fork(
 	if (whichfork == XFS_ATTR_FORK) {
 		kmem_zone_free(xfs_ifork_zone, ip->i_afp);
 		ip->i_afp = NULL;
+	} else if (whichfork == XFS_COW_FORK) {
+		kmem_zone_free(xfs_ifork_zone, ip->i_cowfp);
+		ip->i_cowfp = NULL;
 	}
 }
 
@@ -899,6 +931,19 @@ xfs_iext_get_ext(
 	}
 }
 
+/* XFS_IEXT_STATE_TO_FORK() -- Convert BMAP state flags to an inode fork. */
+xfs_ifork_t *
+XFS_IEXT_STATE_TO_FORK(
+	struct xfs_inode	*ip,
+	int			state)
+{
+	if (state & BMAP_COWFORK)
+		return ip->i_cowfp;
+	else if (state & BMAP_ATTRFORK)
+		return ip->i_afp;
+	return &ip->i_df;
+}
+
 /*
  * Insert new item(s) into the extent records for incore inode
  * fork 'ifp'.  'count' new items are inserted at index 'idx'.
@@ -911,7 +956,7 @@ xfs_iext_insert(
 	xfs_bmbt_irec_t	*new,		/* items to insert */
 	int		state)		/* type of extent conversion */
 {
-	xfs_ifork_t	*ifp = (state & BMAP_ATTRFORK) ? ip->i_afp : &ip->i_df;
+	xfs_ifork_t	*ifp = XFS_IEXT_STATE_TO_FORK(ip, state);
 	xfs_extnum_t	i;		/* extent record index */
 
 	trace_xfs_iext_insert(ip, idx, new, state, _RET_IP_);
@@ -1161,7 +1206,7 @@ xfs_iext_remove(
 	int		ext_diff,	/* number of extents to remove */
 	int		state)		/* type of extent conversion */
 {
-	xfs_ifork_t	*ifp = (state & BMAP_ATTRFORK) ? ip->i_afp : &ip->i_df;
+	xfs_ifork_t	*ifp = XFS_IEXT_STATE_TO_FORK(ip, state);
 	xfs_extnum_t	nextents;	/* number of extents in file */
 	int		new_size;	/* size of extents after removal */
 
@@ -1897,3 +1942,22 @@ xfs_iext_irec_update_extoffs(
 		ifp->if_u1.if_ext_irec[i].er_extoff += ext_diff;
 	}
 }
+
+/**
+ * xfs_ifork_init_cow() -- Initialize an inode's copy-on-write fork.
+ *
+ * @ip: XFS inode.
+ */
+void
+xfs_ifork_init_cow(
+	struct xfs_inode	*ip)
+{
+	if (ip->i_cowfp)
+		return;
+
+	ip->i_cowfp = kmem_zone_zalloc(xfs_ifork_zone,
+				       KM_SLEEP | KM_NOFS);
+	ip->i_cowfp->if_flags = XFS_IFEXTENTS;
+	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
+	ip->i_cnextents = 0;
+}
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 7d3b1ed..a9f5270 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -92,7 +92,9 @@ typedef struct xfs_ifork {
 #define XFS_IFORK_PTR(ip,w)		\
 	((w) == XFS_DATA_FORK ? \
 		&(ip)->i_df : \
-		(ip)->i_afp)
+		((w) == XFS_ATTR_FORK ? \
+			(ip)->i_afp : \
+			(ip)->i_cowfp))
 #define XFS_IFORK_DSIZE(ip) \
 	(XFS_IFORK_Q(ip) ? \
 		XFS_IFORK_BOFF(ip) : \
@@ -105,26 +107,38 @@ typedef struct xfs_ifork {
 #define XFS_IFORK_SIZE(ip,w) \
 	((w) == XFS_DATA_FORK ? \
 		XFS_IFORK_DSIZE(ip) : \
-		XFS_IFORK_ASIZE(ip))
+		((w) == XFS_ATTR_FORK ? \
+			XFS_IFORK_ASIZE(ip) : \
+			0))
 #define XFS_IFORK_FORMAT(ip,w) \
 	((w) == XFS_DATA_FORK ? \
 		(ip)->i_d.di_format : \
-		(ip)->i_d.di_aformat)
+		((w) == XFS_ATTR_FORK ? \
+			(ip)->i_d.di_aformat : \
+			(ip)->i_cformat))
 #define XFS_IFORK_FMT_SET(ip,w,n) \
 	((w) == XFS_DATA_FORK ? \
 		((ip)->i_d.di_format = (n)) : \
-		((ip)->i_d.di_aformat = (n)))
+		((w) == XFS_ATTR_FORK ? \
+			((ip)->i_d.di_aformat = (n)) : \
+			((ip)->i_cformat = (n))))
 #define XFS_IFORK_NEXTENTS(ip,w) \
 	((w) == XFS_DATA_FORK ? \
 		(ip)->i_d.di_nextents : \
-		(ip)->i_d.di_anextents)
+		((w) == XFS_ATTR_FORK ? \
+			(ip)->i_d.di_anextents : \
+			(ip)->i_cnextents))
 #define XFS_IFORK_NEXT_SET(ip,w,n) \
 	((w) == XFS_DATA_FORK ? \
 		((ip)->i_d.di_nextents = (n)) : \
-		((ip)->i_d.di_anextents = (n)))
+		((w) == XFS_ATTR_FORK ? \
+			((ip)->i_d.di_anextents = (n)) : \
+			((ip)->i_cnextents = (n))))
 #define XFS_IFORK_MAXEXT(ip, w) \
 	(XFS_IFORK_SIZE(ip, w) / sizeof(xfs_bmbt_rec_t))
 
+xfs_ifork_t	*XFS_IEXT_STATE_TO_FORK(struct xfs_inode *ip, int state);
+
 int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
 void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 				struct xfs_inode_log_item *, int);
@@ -168,4 +182,6 @@ void		xfs_iext_irec_update_extoffs(struct xfs_ifork *, int, int);
 
 extern struct kmem_zone	*xfs_ifork_zone;
 
+extern void xfs_ifork_init_cow(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_FORK_H__ */
diff --git a/libxfs/xfs_perag_pool.c b/libxfs/xfs_perag_pool.c
new file mode 100644
index 0000000..5fdd293
--- /dev/null
+++ b/libxfs/xfs_perag_pool.c
@@ -0,0 +1,378 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2015 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_alloc.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_trans.h"
+#include "xfs_bit.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_perag_pool.h"
+#include "xfs_trans_space.h"
+
+/**
+ * xfs_perag_pool_free() -- Free a per-AG reserved block pool.
+ */
+int
+xfs_perag_pool_free(
+	struct xfs_perag_pool		*p)
+{
+	struct xfs_mount		*mp;
+	struct xfs_perag_pool_entry	*ppe, *n;
+	struct xfs_trans		*tp;
+	xfs_fsblock_t			fsb;
+	struct xfs_bmap_free		freelist;
+	int				committed;
+	int				error = 0, err;
+
+	if (!p)
+		return 0;
+
+	mp = p->pp_mount;
+	list_for_each_entry_safe(ppe, n, &p->pp_entries, ppe_list) {
+		list_del(&ppe->ppe_list);
+		if (XFS_FORCED_SHUTDOWN(mp)) {
+			kmem_free(ppe);
+			continue;
+		}
+
+		/* Set up transaction. */
+		tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+		tp->t_flags |= XFS_TRANS_RESERVE;
+		err = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, 0, 0);
+		if (err)
+			goto loop_cancel;
+		xfs_bmap_init(&freelist, &fsb);
+		fsb = XFS_AGB_TO_FSB(p->pp_mount, p->pp_agno, ppe->ppe_bno);
+
+		trace_xfs_perag_pool_free_extent(mp, p->pp_agno, ppe->ppe_bno,
+				ppe->ppe_len, &p->pp_oinfo);
+
+		/* Free the block. */
+		xfs_bmap_add_free(mp, &freelist, fsb, ppe->ppe_len,
+				&p->pp_oinfo);
+
+		err = xfs_bmap_finish(&tp, &freelist, &committed, NULL);
+		if (err)
+			goto loop_cancel;
+
+		err = xfs_trans_commit(tp);
+		if (!error)
+			error = err;
+		kmem_free(ppe);
+		continue;
+loop_cancel:
+		if (!error)
+			error = err;
+		xfs_trans_cancel(tp);
+		kmem_free(ppe);
+	}
+
+	kmem_free(p);
+	if (error)
+		trace_xfs_perag_pool_free_error(mp, p->pp_agno, error,
+				_RET_IP_);
+	return error;
+}
+
+/* Allocate a block for the pool. */
+static int
+xfs_perag_pool_grab_block(
+	struct xfs_perag_pool		*p,
+	struct xfs_trans		*tp,
+	xfs_extlen_t			*len)
+{
+	struct xfs_mount		*mp;
+	struct xfs_perag_pool_entry	*ppe;
+	struct xfs_alloc_arg		args;
+	int				error;
+
+	mp = p->pp_mount;
+
+	/* Set up the allocation. */
+	memset(&args, 0, sizeof(args));
+	args.mp = mp;
+	args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	args.fsbno = XFS_AGB_TO_FSB(mp, p->pp_agno, p->pp_agbno);
+	args.firstblock = args.fsbno;
+	args.oinfo = p->pp_oinfo;
+	args.minlen = 1;
+
+	/* Allocate blocks. */
+	args.tp = tp;
+	args.maxlen = args.prod = *len;
+	p->pp_allocating = true;
+	error = xfs_alloc_vextent(&args);
+	p->pp_allocating = false;
+	if (error)
+		goto out_error;
+	if (args.fsbno == NULLFSBLOCK) {
+		/* oh well, we're headed towards failure. */
+		error = -ENOSPC;
+		goto out_error;
+	}
+	*len = args.len;
+
+	trace_xfs_perag_pool_grab_block(mp, p->pp_agno, args.agbno, args.len,
+			&p->pp_oinfo);
+
+	/* Add to our list. */
+	ASSERT(args.agno == p->pp_agno);
+	ppe = kmem_alloc(sizeof(struct xfs_perag_pool_entry), KM_SLEEP);
+	ppe->ppe_bno = args.agbno;
+	ppe->ppe_len = args.len;
+	list_add_tail(&ppe->ppe_list, &p->pp_entries);
+	return 0;
+
+out_error:
+	trace_xfs_perag_pool_grab_block_error(mp, p->pp_agno, error, _RET_IP_);
+	return error;
+}
+
+/* Ensure the pool has some capacity. */
+static int
+__xfs_perag_pool_ensure_capacity(
+	struct xfs_perag_pool		*p,
+	xfs_extlen_t			sz,
+	bool				force)
+{
+	struct xfs_mount		*mp = p->pp_mount;
+	struct xfs_trans		*tp;
+	struct xfs_perag		*pag;
+	uint				resblks;
+	xfs_extlen_t			alloc_len;
+	int				error;
+
+	if (sz <= p->pp_len - p->pp_inuse)
+		return 0;
+	sz -= p->pp_len - p->pp_inuse;
+
+	trace_xfs_perag_pool_ensure_capacity(mp, p->pp_agno,
+			p->pp_len - p->pp_inuse, sz, &p->pp_oinfo);
+
+	/* Do we even have enough free blocks? */
+	pag = xfs_perag_get(mp, p->pp_agno);
+	resblks = pag->pagf_freeblks;
+	xfs_perag_put(pag);
+	if (force && resblks < sz)
+		sz = resblks;
+	if (resblks < sz) {
+		error = -ENOSPC;
+		goto out_error;
+	}
+
+	while (sz) {
+		/* Set up a transaction */
+		resblks = XFS_DIOSTRAT_SPACE_RES(mp, sz);
+		tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
+		if (error)
+			goto out_cancel;
+
+		/* Allocate the blocks */
+		alloc_len = sz;
+		error = xfs_perag_pool_grab_block(p, tp, &alloc_len);
+		if (error)
+			goto out_cancel;
+
+		/* Commit the transaction */
+		error = xfs_trans_commit(tp);
+		if (error)
+			goto out_error;
+
+		p->pp_len += alloc_len;
+		sz -= alloc_len;
+	}
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+out_error:
+	trace_xfs_perag_pool_ensure_capacity_error(mp, p->pp_agno, error,
+			_RET_IP_);
+	return error;
+}
+
+/**
+ * xfs_perag_pool_ensure_capacity() -- Ensure the pool has some capacity.
+ *
+ * @p: per-AG reserved blocks pool.
+ * @sz: Ensure that there are at least this many free blocks.
+ */
+int
+xfs_perag_pool_ensure_capacity(
+	struct xfs_perag_pool		*p,
+	xfs_extlen_t			sz)
+{
+	if (!p)
+		return 0;
+	return __xfs_perag_pool_ensure_capacity(p, sz, false);
+}
+
+/**
+ * xfs_perag_pool_init() -- Initialize a per-AG reserved block pool.
+ */
+int
+xfs_perag_pool_init(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len,
+	xfs_extlen_t			inuse,
+	uint64_t			owner,
+	struct xfs_perag_pool		**pp)
+{
+	struct xfs_perag_pool		*p;
+	struct xfs_owner_info		oinfo;
+	int				error;
+
+	XFS_RMAP_AG_OWNER(&oinfo, owner);
+	trace_xfs_perag_pool_init(mp, agno, agbno, len, &oinfo);
+	trace_xfs_perag_pool_init(mp, agno, agbno, inuse, &oinfo);
+
+	p = kmem_alloc(sizeof(struct xfs_perag_pool), KM_SLEEP);
+	p->pp_mount = mp;
+	p->pp_agno = agno;
+	p->pp_agbno = agbno;
+	p->pp_inuse = p->pp_len = inuse;
+	p->pp_oinfo = oinfo;
+	p->pp_allocating = false;
+	INIT_LIST_HEAD(&p->pp_entries);
+	*pp = p;
+
+	/* Try to reserve some blocks. */
+	error = __xfs_perag_pool_ensure_capacity(p, len - inuse, true);
+	if (error == -ENOSPC)
+		error = 0;
+
+	if (error)
+		trace_xfs_perag_pool_init_error(mp, agno, error, _RET_IP_);
+	return error;
+}
+
+/**
+ * xfs_perag_pool_alloc_block() -- Allocate a block from the pool.
+ *
+ * @p: Reserved block pool.
+ * @tp: Transaction to record the allocation.
+ * @bno: (out) The allocated block number.
+ */
+int
+xfs_perag_pool_alloc_block(
+	struct xfs_perag_pool		*p,
+	struct xfs_trans		*tp,
+	xfs_agblock_t			*bno)
+{
+	struct xfs_mount		*mp;
+	struct xfs_perag_pool_entry	*ppe;
+	xfs_extlen_t			len;
+	int				error;
+
+	if (p == NULL || p->pp_allocating)
+		return -EINVAL;
+
+	mp = p->pp_mount;
+	mp = mp;
+	/* Empty pool?  Grab another block. */
+	if (list_empty(&p->pp_entries)) {
+		len = 1;
+		error = xfs_perag_pool_grab_block(p, tp, &len);
+		if (error)
+			goto err;
+		ASSERT(len == 1);
+		if (list_empty(&p->pp_entries)) {
+			error = -ENOSPC;
+			goto err;
+		}
+	}
+
+	/* Find an available block. */
+	ppe = list_first_entry(&p->pp_entries, struct xfs_perag_pool_entry,
+			ppe_list);
+	*bno = ppe->ppe_bno;
+
+	trace_xfs_perag_pool_alloc_block(mp, p->pp_agno, *bno, 1, &p->pp_oinfo);
+
+	/* Update the accounting. */
+	ppe->ppe_len--;
+	ppe->ppe_bno++;
+	if (ppe->ppe_len == 0)
+		list_del(&ppe->ppe_list);
+	p->pp_inuse++;
+
+	return 0;
+err:
+	trace_xfs_perag_pool_alloc_block_error(mp, p->pp_agno, error, _RET_IP_);
+	return error;
+}
+
+/**
+ * xfs_perag_pool_free_block() -- Put a block back in the pool.
+ *
+ * @p: Reserved block pool.
+ * @tp: Transaction to record the free operation.
+ * @bno: Block to put back.
+ */
+int
+xfs_perag_pool_free_block(
+	struct xfs_perag_pool		*p,
+	struct xfs_trans		*tp,
+	xfs_agblock_t			bno)
+{
+	struct xfs_mount		*mp;
+	struct xfs_perag_pool_entry	*ppe;
+
+	if (p == NULL)
+		return -EINVAL;
+
+	mp = p->pp_mount;
+	mp = mp;
+	trace_xfs_perag_pool_free_block(mp, p->pp_agno, bno, 1, &p->pp_oinfo);
+
+	list_for_each_entry(ppe, &p->pp_entries, ppe_list) {
+		if (ppe->ppe_bno - 1 == bno) {
+
+			/* Adjust bookkeeping. */
+			p->pp_inuse--;
+			ppe->ppe_bno--;
+			ppe->ppe_len++;
+			return 0;
+		}
+		if (ppe->ppe_bno + ppe->ppe_len == bno) {
+			p->pp_inuse--;
+			ppe->ppe_len++;
+			return 0;
+		}
+	}
+	ppe = kmem_alloc(sizeof(struct xfs_perag_pool_entry), KM_SLEEP);
+	ppe->ppe_bno = bno;
+	ppe->ppe_len = 1;
+	p->pp_inuse--;
+
+	list_add_tail(&ppe->ppe_list, &p->pp_entries);
+	return 0;
+}
diff --git a/libxfs/xfs_perag_pool.h b/libxfs/xfs_perag_pool.h
new file mode 100644
index 0000000..ecdcd2a
--- /dev/null
+++ b/libxfs/xfs_perag_pool.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2015 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+struct xfs_perag_pool_entry {
+	struct list_head	ppe_list;	/* pool list */
+	xfs_agblock_t		ppe_bno;	/* AG block number */
+	xfs_extlen_t		ppe_len;	/* length */
+};
+
+struct xfs_perag_pool {
+	struct xfs_mount	*pp_mount;	/* XFS mount */
+	xfs_agnumber_t		pp_agno;	/* AG number */
+	xfs_agblock_t		pp_agbno;	/* suggested AG block number */
+	xfs_extlen_t		pp_len;		/* blocks in pool */
+	xfs_extlen_t		pp_inuse;	/* blocks in use */
+	struct xfs_owner_info	pp_oinfo;	/* owner */
+	struct list_head	pp_entries;	/* pool entries */
+	bool			pp_allocating;	/* are we allocating? */
+};
+
+int xfs_perag_pool_free(struct xfs_perag_pool *p);
+int xfs_perag_pool_init(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agblock_t agbno, xfs_extlen_t len, xfs_extlen_t inuse,
+		uint64_t owner, struct xfs_perag_pool **pp);
+
+int xfs_perag_pool_ensure_capacity(struct xfs_perag_pool *p, xfs_extlen_t sz);
+
+int xfs_perag_pool_alloc_block(struct xfs_perag_pool *p, struct xfs_trans *tp,
+		xfs_agblock_t *bno);
+int xfs_perag_pool_free_block(struct xfs_perag_pool *p, struct xfs_trans *tp,
+		xfs_agblock_t bno);
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
new file mode 100644
index 0000000..4ad7cb1
--- /dev/null
+++ b/libxfs/xfs_refcount_btree.c
@@ -0,0 +1,576 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2015 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_trans.h"
+#include "xfs_bit.h"
+#include "xfs_perag_pool.h"
+
+static struct xfs_btree_cur *
+xfs_refcountbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_refcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.a.agbp, cur->bc_private.a.agno,
+			cur->bc_private.a.flist);
+}
+
+STATIC void
+xfs_refcountbt_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			inc)
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
+
+	ASSERT(ptr->s != 0);
+
+	agf->agf_refcount_root = ptr->s;
+	be32_add_cpu(&agf->agf_refcount_level, inc);
+	pag->pagf_refcount_level += inc;
+	xfs_perag_put(pag);
+
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
+}
+
+STATIC int
+xfs_refcountbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			*stat)
+{
+	struct xfs_alloc_arg	args;		/* block allocation args */
+	struct xfs_perag	*pag;
+	xfs_agblock_t		bno;
+	int			error;		/* error return value */
+
+	/* First try the per-AG reserve pool. */
+	pag = xfs_perag_get(cur->bc_mp, cur->bc_private.a.agno);
+	error = xfs_perag_pool_alloc_block(pag->pagf_refcountbt_pool,
+			cur->bc_tp, &bno);
+	xfs_perag_put(pag);
+
+	switch (error) {
+	case 0:
+		*stat = 1;
+		new->s = cpu_to_be32(bno);
+		return 0;
+	case -EINVAL:
+		break;
+	case -ENOSPC:
+		error = 0;
+		/* fall through */
+	default:
+		*stat = 0;
+		return error;
+	}
+
+	/* No pool; try a regular allocation. */
+	memset(&args, 0, sizeof(args));
+	args.tp = cur->bc_tp;
+	args.mp = cur->bc_mp;
+	args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+			xfs_refc_block(args.mp));
+	args.firstblock = args.fsbno;
+	XFS_RMAP_AG_OWNER(&args.oinfo, XFS_RMAP_OWN_REFC);
+	args.minlen = args.maxlen = args.prod = 1;
+
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto out_error;
+	if (args.fsbno == NULLFSBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+	ASSERT(args.agno == cur->bc_private.a.agno);
+	ASSERT(args.len == 1);
+
+	new->s = cpu_to_be32(args.agbno);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+out_error:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+STATIC int
+xfs_refcountbt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_trans	*tp = cur->bc_tp;
+	struct xfs_perag	*pag;
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	struct xfs_owner_info	oinfo;
+	int			error;
+
+	/* Try to give it back to the pool. */
+	pag = xfs_perag_get(cur->bc_mp, cur->bc_private.a.agno);
+	error = xfs_perag_pool_free_block(pag->pagf_refcountbt_pool, cur->bc_tp,
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno));
+	xfs_perag_put(pag);
+
+	switch (error) {
+	case 0:
+		return 0;
+	case -EINVAL:
+		break;
+	default:
+		return error;
+	}
+
+	/* Return it to the AG. */
+	XFS_RMAP_AG_OWNER(&oinfo, XFS_RMAP_OWN_REFC);
+	xfs_bmap_add_free(mp, cur->bc_private.a.flist, fsbno, 1,
+			&oinfo);
+	xfs_trans_binval(tp, bp);
+	return 0;
+}
+
+STATIC int
+xfs_refcountbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_refc_mnr[level != 0];
+}
+
+STATIC int
+xfs_refcountbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_refc_mxr[level != 0];
+}
+
+STATIC void
+xfs_refcountbt_init_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(rec->refc.rc_startblock != 0);
+
+	key->refc.rc_startblock = rec->refc.rc_startblock;
+}
+
+STATIC void
+xfs_refcountbt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(key->refc.rc_startblock != 0);
+
+	rec->refc.rc_startblock = key->refc.rc_startblock;
+}
+
+STATIC void
+xfs_refcountbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(cur->bc_rec.rc.rc_startblock != 0);
+
+	rec->refc.rc_startblock = cpu_to_be32(cur->bc_rec.rc.rc_startblock);
+	rec->refc.rc_blockcount = cpu_to_be32(cur->bc_rec.rc.rc_blockcount);
+	rec->refc.rc_refcount = cpu_to_be32(cur->bc_rec.rc.rc_refcount);
+}
+
+STATIC void
+xfs_refcountbt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+
+	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(agf->agf_refcount_root != 0);
+
+	ptr->s = agf->agf_refcount_root;
+}
+
+STATIC __int64_t
+xfs_refcountbt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	struct xfs_refcount_irec	*rec = &cur->bc_rec.rc;
+	struct xfs_refcount_key		*kp = &key->refc;
+
+	return (__int64_t)be32_to_cpu(kp->rc_startblock) - rec->rc_startblock;
+}
+
+STATIC bool
+xfs_refcountbt_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_perag	*pag = bp->b_pag;
+	unsigned int		level;
+
+	if (block->bb_magic != cpu_to_be32(XFS_REFC_CRC_MAGIC))
+		return false;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+	if (!xfs_btree_sblock_v5hdr_verify(bp))
+		return false;
+
+	level = be16_to_cpu(block->bb_level);
+	if (pag && pag->pagf_init) {
+		if (level >= pag->pagf_refcount_level)
+			return false;
+	} else if (level >= mp->m_ag_maxlevels)
+		return false;
+
+	return xfs_btree_sblock_verify(bp, mp->m_refc_mxr[level != 0]);
+}
+
+STATIC void
+xfs_refcountbt_read_verify(
+	struct xfs_buf	*bp)
+{
+	if (!xfs_btree_sblock_verify_crc(bp))
+		xfs_buf_ioerror(bp, -EFSBADCRC);
+	else if (!xfs_refcountbt_verify(bp))
+		xfs_buf_ioerror(bp, -EFSCORRUPTED);
+
+	if (bp->b_error) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp);
+	}
+}
+
+STATIC void
+xfs_refcountbt_write_verify(
+	struct xfs_buf	*bp)
+{
+	if (!xfs_refcountbt_verify(bp)) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_buf_ioerror(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp);
+		return;
+	}
+	xfs_btree_sblock_calc_crc(bp);
+
+}
+
+const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
+	.name			= "xfs_refcountbt",
+	.verify_read		= xfs_refcountbt_read_verify,
+	.verify_write		= xfs_refcountbt_write_verify,
+};
+
+#if defined(DEBUG) || defined(XFS_WARN)
+STATIC int
+xfs_refcountbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return be32_to_cpu(k1->refc.rc_startblock) <
+	       be32_to_cpu(k2->refc.rc_startblock);
+}
+
+STATIC int
+xfs_refcountbt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
+{
+	struct xfs_refcount_irec	a, b;
+
+	int ret = be32_to_cpu(r1->refc.rc_startblock) +
+		be32_to_cpu(r1->refc.rc_blockcount) <=
+		be32_to_cpu(r2->refc.rc_startblock);
+	if (!ret) {
+		a.rc_startblock = be32_to_cpu(r1->refc.rc_startblock);
+		a.rc_blockcount = be32_to_cpu(r1->refc.rc_blockcount);
+		a.rc_refcount = be32_to_cpu(r1->refc.rc_refcount);
+		b.rc_startblock = be32_to_cpu(r2->refc.rc_startblock);
+		b.rc_blockcount = be32_to_cpu(r2->refc.rc_blockcount);
+		b.rc_refcount = be32_to_cpu(r2->refc.rc_refcount);
+		trace_xfs_refcount_rec_order_error(cur->bc_mp,
+				cur->bc_private.a.agno, &a, &b);
+	}
+
+	return ret;
+}
+#endif	/* DEBUG */
+
+static const struct xfs_btree_ops xfs_refcountbt_ops = {
+	.rec_len		= sizeof(struct xfs_refcount_rec),
+	.key_len		= sizeof(struct xfs_refcount_key),
+
+	.dup_cursor		= xfs_refcountbt_dup_cursor,
+	.set_root		= xfs_refcountbt_set_root,
+	.alloc_block		= xfs_refcountbt_alloc_block,
+	.free_block		= xfs_refcountbt_free_block,
+	.get_minrecs		= xfs_refcountbt_get_minrecs,
+	.get_maxrecs		= xfs_refcountbt_get_maxrecs,
+	.init_key_from_rec	= xfs_refcountbt_init_key_from_rec,
+	.init_rec_from_key	= xfs_refcountbt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_refcountbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
+	.key_diff		= xfs_refcountbt_key_diff,
+	.buf_ops		= &xfs_refcountbt_buf_ops,
+#if defined(DEBUG) || defined(XFS_WARN)
+	.keys_inorder		= xfs_refcountbt_keys_inorder,
+	.recs_inorder		= xfs_refcountbt_recs_inorder,
+#endif
+};
+
+/**
+ * xfs_refcountbt_init_cursor() -- Allocate a new refcount btree cursor.
+ *
+ * @mp: XFS mount object
+ * @tp: XFS transaction
+ * @agbp: Buffer containing the AGF
+ * @agno: AG number
+ */
+struct xfs_btree_cur *
+xfs_refcountbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	struct xfs_bmap_free	*flist)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_btree_cur	*cur;
+
+	ASSERT(agno != NULLAGNUMBER);
+	ASSERT(agno < mp->m_sb.sb_agcount);
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_btnum = XFS_BTNUM_REFC;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur->bc_ops = &xfs_refcountbt_ops;
+
+	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
+
+	cur->bc_private.a.agbp = agbp;
+	cur->bc_private.a.agno = agno;
+	cur->bc_private.a.flist = flist;
+	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
+
+	return cur;
+}
+
+/**
+ * xfs_refcountbt_maxrecs() -- Calculate number of records in a refcount
+ *			       btree block.
+ * @mp: XFS mount object
+ * @blocklen: Length of block, in bytes.
+ * @leaf: true if this is a leaf btree block, false otherwise
+ */
+int
+xfs_refcountbt_maxrecs(
+	struct xfs_mount	*mp,
+	int			blocklen,
+	bool			leaf)
+{
+	blocklen -= XFS_REFCOUNT_BLOCK_LEN;
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_refcount_rec);
+	return blocklen / (sizeof(struct xfs_refcount_key) +
+			   sizeof(xfs_refcount_ptr_t));
+}
+
+DEFINE_BTREE_SIZE_FN(refcountbt, m_refc_mxr, XFS_BTREE_MAXLEVELS);
+
+/**
+ * xfs_refcountbt_max_btree_size() -- Calculate the maximum refcount btree size.
+ */
+unsigned int
+xfs_refcountbt_max_btree_size(
+	struct xfs_mount	*mp)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_refc_mxr[0] == 0)
+		return 0;
+
+	return xfs_refcountbt_calc_btree_size(mp, mp->m_sb.sb_agblocks);
+}
+
+/* Count the blocks in the reference count tree. */
+static int
+xfs_refcountbt_count_tree_blocks(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*tree_len)
+{
+	struct xfs_buf		*agfbp;
+	struct xfs_buf		*bp = NULL;
+	struct xfs_agf		*agfp;
+	struct xfs_btree_block	*block = NULL;
+	int			level;
+	xfs_agblock_t		bno;
+	xfs_fsblock_t		fsbno;
+	__be32			*pp;
+	int			error;
+	xfs_extlen_t		nr_blocks = 0;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agfbp);
+	if (error)
+		goto out;
+	agfp = XFS_BUF_TO_AGF(agfbp);
+	level = be32_to_cpu(agfp->agf_refcount_level);
+	bno = be32_to_cpu(agfp->agf_refcount_root);
+
+	/*
+	 * Go down the tree until leaf level is reached, following the first
+	 * pointer (leftmost) at each level.
+	 */
+	while (level-- > 0) {
+		fsbno = XFS_AGB_TO_FSB(mp, agno, bno);
+		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp, fsbno),
+				XFS_FSB_TO_BB(mp, 1), 0, &bp,
+				&xfs_refcountbt_buf_ops);
+		if (error)
+			goto err;
+		block = XFS_BUF_TO_BLOCK(bp);
+		if (level == 0)
+			break;
+		pp = XFS_REFCOUNT_PTR_ADDR(block, 1, mp->m_refc_mxr[1]);
+		bno = be32_to_cpu(*pp);
+		xfs_trans_brelse(NULL, bp);
+	}
+
+	/* Jog rightward though level zero. */
+	while (block) {
+		nr_blocks++;
+		bno = be32_to_cpu(block->bb_u.s.bb_rightsib);
+		if (bno == NULLAGBLOCK)
+			break;
+		fsbno = XFS_AGB_TO_FSB(mp, agno, bno);
+		xfs_trans_brelse(NULL, bp);
+		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp, fsbno),
+				XFS_FSB_TO_BB(mp, 1), 0, &bp,
+				&xfs_refcountbt_buf_ops);
+		if (error)
+			goto err;
+		block = XFS_BUF_TO_BLOCK(bp);
+	}
+
+	if (bp)
+		xfs_trans_brelse(NULL, bp);
+
+	/* Add in the upper levels of tree. */
+	*tree_len = nr_blocks;
+err:
+	xfs_trans_brelse(NULL, agfbp);
+out:
+	return error;
+}
+
+/**
+ * xfs_refcountbt_alloc_reserve_pool() -- Create reserved block pools for each
+ *					  allocation group.
+ */
+int
+xfs_refcountbt_alloc_reserve_pool(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag;
+	xfs_extlen_t		pool_len;
+	xfs_extlen_t		tree_len;
+	int			error = 0;
+	int			err;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	pool_len = xfs_refcountbt_max_btree_size(mp);
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		if (pag->pagf_refcountbt_pool) {
+			xfs_perag_put(pag);
+			continue;
+		}
+		tree_len = 0;
+		xfs_refcountbt_count_tree_blocks(mp, agno, &tree_len);
+		err = xfs_perag_pool_init(mp, agno,
+				xfs_refc_block(mp),
+				pool_len, tree_len,
+				XFS_RMAP_OWN_REFC,
+				&pag->pagf_refcountbt_pool);
+		xfs_perag_put(pag);
+		if (err && !error)
+			error = err;
+	}
+
+	return error;
+}
+
+/**
+ * xfs_refcountbt_free_reserve_pool() -- Free the reference count btree pools.
+ */
+int
+xfs_refcountbt_free_reserve_pool(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag;
+	int			error = 0;
+	int			err;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		err = xfs_perag_pool_free(pag->pagf_refcountbt_pool);
+		pag->pagf_refcountbt_pool = NULL;
+		xfs_perag_put(pag);
+		if (err && !error)
+			error = err;
+	}
+
+	return error;
+}
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
new file mode 100644
index 0000000..93eebda
--- /dev/null
+++ b/libxfs/xfs_refcount_btree.h
@@ -0,0 +1,71 @@
+/*
+ * Copyright (c) 2000,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2015 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_REFCOUNT_BTREE_H__
+#define	__XFS_REFCOUNT_BTREE_H__
+
+/*
+ * Reference Count Btree on-disk structures
+ */
+
+struct xfs_buf;
+struct xfs_btree_cur;
+struct xfs_mount;
+
+/*
+ * Btree block header size
+ */
+#define XFS_REFCOUNT_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
+
+/*
+ * Record, key, and pointer address macros for btree blocks.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
+ */
+#define XFS_REFCOUNT_REC_ADDR(block, index) \
+	((struct xfs_refcount_rec *) \
+		((char *)(block) + \
+		 XFS_REFCOUNT_BLOCK_LEN + \
+		 (((index) - 1) * sizeof(struct xfs_refcount_rec))))
+
+#define XFS_REFCOUNT_KEY_ADDR(block, index) \
+	((struct xfs_refcount_key *) \
+		((char *)(block) + \
+		 XFS_REFCOUNT_BLOCK_LEN + \
+		 ((index) - 1) * sizeof(struct xfs_refcount_key)))
+
+#define XFS_REFCOUNT_PTR_ADDR(block, index, maxrecs) \
+	((xfs_refcount_ptr_t *) \
+		((char *)(block) + \
+		 XFS_REFCOUNT_BLOCK_LEN + \
+		 (maxrecs) * sizeof(struct xfs_refcount_key) + \
+		 ((index) - 1) * sizeof(xfs_refcount_ptr_t)))
+
+extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_agnumber_t agno,
+		struct xfs_bmap_free *flist);
+extern int xfs_refcountbt_maxrecs(struct xfs_mount *mp, int blocklen,
+		bool leaf);
+
+DECLARE_BTREE_SIZE_FN(refcountbt);
+extern unsigned int xfs_refcountbt_max_btree_size(struct xfs_mount *mp);
+
+extern int xfs_refcountbt_alloc_reserve_pool(struct xfs_mount *mp);
+extern int xfs_refcountbt_free_reserve_pool(struct xfs_mount *mp);
+
+#endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 5ae4c1e..bbb6c90 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -1073,6 +1073,8 @@ __xfs_rmap_add(
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
+	if (ri->ri_whichfork == XFS_COW_FORK)
+		return 0;
 
 	new = kmem_zalloc(sizeof(struct xfs_rmap_intent), KM_SLEEP | KM_NOFS);
 	*new = *ri;
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 85ef128..c952c6a 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -34,6 +34,8 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_refcount_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -717,6 +719,13 @@ xfs_sb_mount_common(
 	mp->m_rmap_mnr[0] = mp->m_rmap_mxr[0] / 2;
 	mp->m_rmap_mnr[1] = mp->m_rmap_mxr[1] / 2;
 
+	mp->m_refc_mxr[0] = xfs_refcountbt_maxrecs(mp, sbp->sb_blocksize,
+			true);
+	mp->m_refc_mxr[1] = xfs_refcountbt_maxrecs(mp, sbp->sb_blocksize,
+			false);
+	mp->m_refc_mnr[0] = mp->m_refc_mxr[0] / 2;
+	mp->m_refc_mnr[1] = mp->m_refc_mxr[1] / 2;
+
 	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
 	mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
 					sbp->sb_inopblock);
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index fa2bb9b..bffef9e 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -39,6 +39,7 @@ extern const struct xfs_buf_ops xfs_agf_buf_ops;
 extern const struct xfs_buf_ops xfs_agfl_buf_ops;
 extern const struct xfs_buf_ops xfs_allocbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
+extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
 extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
@@ -216,6 +217,7 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define	XFS_INO_REF		2
 #define	XFS_ATTR_BTREE_REF	1
 #define	XFS_DQUOT_REF		1
+#define	XFS_REFC_BTREE_REF	1
 
 /*
  * Flags for xfs_trans_ichgtime().
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index da87796..cf044c0 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -93,6 +93,7 @@ typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
  */
 #define	XFS_DATA_FORK	0
 #define	XFS_ATTR_FORK	1
+#define	XFS_COW_FORK	2
 
 /*
  * Min numbers of data/attr fork btree root pointers.
@@ -112,7 +113,7 @@ typedef enum {
 
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
-	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_MAX
+	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 struct xfs_name {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

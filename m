Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8735A8423
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:59:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5A35F8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:59 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id H2EmjDxvrF668788 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:56 -0700 (PDT)
Subject: [PATCH 12/29] xfs: wire up a new inode fork type for the realtime rmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:59:51 -0700
Message-ID: <147216959175.7022.847188187496926834.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Plumb in the pieces we need to embed the root of the realtime rmap
btree in an inode's data fork, complete with new fork type and
on-disk interpretation functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_format.h       |    8 +
 libxfs/xfs_inode_fork.c   |   48 ++++++++-
 libxfs/xfs_rtrmap_btree.c |  250 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |   49 +++++++++
 4 files changed, 353 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 5fb5e52..b3f595e 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1478,6 +1478,14 @@ typedef __be32 xfs_rmap_ptr_t;
 #define	XFS_RTRMAP_CRC_MAGIC	0x4d415052	/* 'MAPR' */
 
 /*
+ * rtrmap root header, on-disk form only.
+ */
+struct xfs_rtrmap_root {
+	__be16		bb_level;	/* 0 is a leaf */
+	__be16		bb_numrecs;	/* current # of data records */
+};
+
+/*
  * Data record structure
  */
 struct xfs_rtrmap_rec {
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index b006e2f..b0dea20 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -28,12 +28,14 @@
 #include "xfs_trace.h"
 #include "xfs_attr_sf.h"
 #include "xfs_da_format.h"
+#include "xfs_rtrmap_btree.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
 STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
 STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
 STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
+STATIC int xfs_iformat_rmap(struct xfs_inode *, struct xfs_dinode *);
 
 #ifdef DEBUG
 /*
@@ -196,7 +198,7 @@ xfs_iformat_fork(
 				return -EFSCORRUPTED;
 			if (ip->i_ino != ip->i_mount->m_sb.sb_rrmapino)
 				return -EFSCORRUPTED;
-			/* to be implemented later */
+			error = xfs_iformat_rmap(ip, dip);
 			break;
 		default:
 			XFS_ERROR_REPORT("xfs_iformat(6)", XFS_ERRLEVEL_LOW,
@@ -472,6 +474,37 @@ xfs_iformat_btree(
 	return 0;
 }
 
+/* The file is a reverse mapping tree. */
+STATIC int
+xfs_iformat_rmap(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_rtrmap_root	*dfp;
+	struct xfs_ifork	*ifp;
+	/* REFERENCED */
+	int			size;
+	int			whichfork = XFS_DATA_FORK;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	dfp = (struct xfs_rtrmap_root *)XFS_DFORK_PTR(dip, whichfork);
+	size = XFS_RTRMAP_BROOT_SPACE(dfp);
+
+	ifp->if_broot_bytes = size;
+	ifp->if_broot = kmem_alloc(size, KM_SLEEP | KM_NOFS);
+	ASSERT(ifp->if_broot != NULL);
+	/*
+	 * Copy and convert from the on-disk structure
+	 * to the in-memory structure.
+	 */
+	xfs_rtrmapbt_from_disk(ip, dfp,
+			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
+			ifp->if_broot, size);
+	ifp->if_flags = XFS_IFBROOT;
+
+	return 0;
+}
+
 /*
  * Read in extents from a btree-format inode.
  * Allocate and fill in if_extents.  Real work is done in xfs_bmap.c.
@@ -801,7 +834,18 @@ xfs_iflush_fork(
 		break;
 
 	case XFS_DINODE_FMT_RMAP:
-		/* to be implemented later */
+		ASSERT(whichfork == XFS_DATA_FORK);
+		ASSERT(ip->i_ino == mp->m_sb.sb_rrmapino);
+		if ((iip->ili_fields & brootflag[whichfork]) &&
+		    (ifp->if_broot_bytes > 0)) {
+			ASSERT(ifp->if_broot != NULL);
+			ASSERT(XFS_RTRMAP_ROOT_SPACE(ifp->if_broot) <=
+			        XFS_IFORK_SIZE(ip, whichfork));
+			xfs_rtrmapbt_to_disk(mp, ifp->if_broot,
+				ifp->if_broot_bytes,
+				(struct xfs_rtrmap_root *)cp,
+				XFS_DFORK_SIZE(dip, mp, whichfork));
+		}
 		break;
 
 	default:
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index e4dbe88..503e64e 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -222,6 +222,42 @@ xfs_rtrmapbt_get_maxrecs(
 	return cur->bc_mp->m_rtrmap_mxr[level != 0];
 }
 
+/*
+ * Calculate number of records in a realtime rmap btree inode root.
+ */
+STATIC int
+xfs_rtrmapbt_root_maxrecs(
+	int			blocklen,
+	bool			leaf)
+{
+	blocklen -= sizeof(struct xfs_rtrmap_root);
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_rtrmap_rec);
+	return blocklen / (2 * sizeof(struct xfs_rtrmap_key) +
+			sizeof(xfs_rtrmap_ptr_t));
+}
+
+/*
+ * Get the maximum records we could store in the on-disk format.
+ *
+ * For non-root nodes this is equivalent to xfs_bmbt_get_maxrecs, but
+ * for the root node this checks the available space in the dinode fork
+ * so that we can resize the in-memory buffer to match it.  After a
+ * resize to the maximum size this function returns the same value
+ * as xfs_bmbt_get_maxrecs for the root node, too.
+ */
+STATIC int
+xfs_rtrmapbt_get_dmaxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	if (level != cur->bc_nlevels - 1)
+		return cur->bc_mp->m_rtrmap_mxr[level != 0];
+	return xfs_rtrmapbt_root_maxrecs(cur->bc_private.b.forksize,
+			level == 0);
+}
+
 STATIC void
 xfs_rtrmapbt_init_key_from_rec(
 	union xfs_btree_key	*key,
@@ -339,6 +375,129 @@ xfs_rtrmapbt_diff_two_keys(
 	return 0;
 }
 
+/*
+ * Reallocate the space for if_broot based on the number of records
+ * being added or deleted as indicated in rec_diff.  Move the records
+ * and pointers in if_broot to fit the new size.  When shrinking this
+ * will eliminate holes between the records and pointers created by
+ * the caller.  When growing this will create holes to be filled in
+ * by the caller.
+ *
+ * The caller must not request to add more records than would fit in
+ * the on-disk inode root.  If the if_broot is currently NULL, then
+ * if we are adding records, one will be allocated.  The caller must also
+ * not request that the number of records go below zero, although
+ * it can go to zero.
+ */
+STATIC void
+xfs_rtrmapbt_iroot_realloc(
+	struct xfs_btree_cur	*cur,
+	int			rec_diff)
+{
+	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	int			whichfork = cur->bc_private.b.whichfork;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			cur_max;
+	struct xfs_ifork	*ifp;
+	struct xfs_btree_block	*new_broot;
+	struct xfs_btree_block	*broot;
+	int			new_max;
+	size_t			new_size;
+	char			*np;
+	char			*op;
+	int			level;
+
+	/*
+	 * Handle the degenerate case quietly.
+	 */
+	if (rec_diff == 0) {
+		return;
+	}
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if (rec_diff > 0) {
+		/*
+		 * If there wasn't any memory allocated before, just
+		 * allocate it now and get out.
+		 */
+		if (ifp->if_broot_bytes == 0) {
+			new_size = XFS_RTRMAP_BROOT_SPACE_CALC(rec_diff,
+					cur->bc_nlevels - 1);
+			ifp->if_broot = kmem_alloc(new_size,
+					KM_SLEEP | KM_NOFS);
+			ifp->if_broot_bytes = (int)new_size;
+			return;
+		}
+
+		/*
+		 * If there is already an existing if_broot, then we need
+		 * to realloc() it and shift the pointers to their new
+		 * location.  The records don't change location because
+		 * they are kept butted up against the btree block header.
+		 */
+		broot = (struct xfs_btree_block *)ifp->if_broot;
+		level = be16_to_cpu(broot->bb_level);
+		cur_max = xfs_rtrmapbt_maxrecs(mp, ifp->if_broot_bytes,
+				level == 0);
+		new_max = cur_max + rec_diff;
+		new_size = XFS_RTRMAP_BROOT_SPACE_CALC(new_max, level);
+		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
+				KM_SLEEP | KM_NOFS);
+		if (level > 0) {
+			op = (char *)XFS_RTRMAP_BROOT_PTR_ADDR(ifp->if_broot,
+					1, ifp->if_broot_bytes);
+			np = (char *)XFS_RTRMAP_BROOT_PTR_ADDR(ifp->if_broot,
+					1, (int)new_size);
+			memmove(np, op, cur_max * sizeof(xfs_fsblock_t));
+		}
+		ifp->if_broot_bytes = (int)new_size;
+		ASSERT(XFS_RTRMAP_ROOT_SPACE(ifp->if_broot) <=
+				XFS_IFORK_SIZE(ip, whichfork));
+		return;
+	}
+
+	/*
+	 * rec_diff is less than 0.  In this case, we are shrinking the
+	 * if_broot buffer.  It must already exist.  If we go to zero
+	 * records, just get rid of the root and clear the status bit.
+	 */
+	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
+	broot = (struct xfs_btree_block *)ifp->if_broot;
+	level = be16_to_cpu(broot->bb_level);
+	cur_max = xfs_rtrmapbt_maxrecs(mp, ifp->if_broot_bytes, level == 0);
+	new_max = cur_max + rec_diff;
+	if (new_max < 0)
+		new_max = 0;
+	new_size = XFS_RTRMAP_BROOT_SPACE_CALC(new_max, level);
+	new_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
+	memcpy(new_broot, ifp->if_broot, XFS_RTRMAP_BLOCK_LEN);
+
+	/* Copy the records or keys and pointers. */
+	if (level > 0) {
+		op = (char *)XFS_RTRMAP_KEY_ADDR(ifp->if_broot, 1);
+		np = (char *)XFS_RTRMAP_KEY_ADDR(new_broot, 1);
+		memcpy(np, op, new_max * 2 * sizeof(struct xfs_rtrmap_key));
+
+		op = (char *)XFS_RTRMAP_BROOT_PTR_ADDR(ifp->if_broot, 1,
+				ifp->if_broot_bytes);
+		np = (char *)XFS_RTRMAP_BROOT_PTR_ADDR(new_broot, 1,
+				(int)new_size);
+		memcpy(np, op, new_max * sizeof(xfs_fsblock_t));
+	} else {
+		op = (char *)XFS_RTRMAP_REC_ADDR(ifp->if_broot, 1);
+		np = (char *)XFS_RTRMAP_REC_ADDR(new_broot, 1);
+		memcpy(np, op, new_max * sizeof(struct xfs_rtrmap_rec));
+	}
+
+	kmem_free(ifp->if_broot);
+	ifp->if_broot = new_broot;
+	ifp->if_broot_bytes = (int)new_size;
+	if (ifp->if_broot)
+		ASSERT(XFS_RTRMAP_ROOT_SPACE(ifp->if_broot) <=
+				XFS_IFORK_SIZE(ip, whichfork));
+	return;
+}
+
 static bool
 xfs_rtrmapbt_verify(
 	struct xfs_buf		*bp)
@@ -441,12 +600,14 @@ static const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.free_block		= xfs_rtrmapbt_free_block,
 	.get_minrecs		= xfs_rtrmapbt_get_minrecs,
 	.get_maxrecs		= xfs_rtrmapbt_get_maxrecs,
+	.get_dmaxrecs		= xfs_rtrmapbt_get_dmaxrecs,
 	.init_key_from_rec	= xfs_rtrmapbt_init_key_from_rec,
 	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rtrmapbt_init_ptr_from_cur,
 	.key_diff		= xfs_rtrmapbt_key_diff,
 	.buf_ops		= &xfs_rtrmapbt_buf_ops,
+	.iroot_realloc		= xfs_rtrmapbt_iroot_realloc,
 	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
 	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
@@ -512,3 +673,92 @@ xfs_rtrmapbt_compute_maxlevels(
 			mp->m_rtrmap_mnr, mp->m_sb.sb_rblocks);
 	ASSERT(mp->m_rtrmap_maxlevels <= XFS_BTREE_MAXLEVELS);
 }
+
+/*
+ * Convert on-disk form of btree root to in-memory form.
+ */
+void
+xfs_rtrmapbt_from_disk(
+	struct xfs_inode	*ip,
+	struct xfs_rtrmap_root	*dblock,
+	int			dblocklen,
+	struct xfs_btree_block	*rblock,
+	int			rblocklen)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	int			dmxr;
+	struct xfs_rtrmap_key	*fkp;
+	__be64			*fpp;
+	struct xfs_rtrmap_key	*tkp;
+	__be64			*tpp;
+	struct xfs_rtrmap_rec	*frp;
+	struct xfs_rtrmap_rec	*trp;
+
+	xfs_btree_init_block_int(mp, rblock, XFS_BUF_DADDR_NULL,
+			 XFS_RTRMAP_CRC_MAGIC, 0, 0, ip->i_ino,
+			 XFS_BTREE_LONG_PTRS | XFS_BTREE_CRC_BLOCKS);
+
+	rblock->bb_level = dblock->bb_level;
+	rblock->bb_numrecs = dblock->bb_numrecs;
+
+	if (be16_to_cpu(rblock->bb_level) > 0) {
+		dmxr = xfs_rtrmapbt_maxrecs(mp, dblocklen, 0);
+		fkp = XFS_RTRMAP_ROOT_KEY_ADDR(dblock, 1);
+		tkp = XFS_RTRMAP_KEY_ADDR(rblock, 1);
+		fpp = XFS_RTRMAP_ROOT_PTR_ADDR(dblock, 1, dmxr);
+		tpp = XFS_RTRMAP_BROOT_PTR_ADDR(rblock, 1, rblocklen);
+		dmxr = be16_to_cpu(dblock->bb_numrecs);
+		memcpy(tkp, fkp, 2 * sizeof(*fkp) * dmxr);
+		memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
+	} else {
+		frp = XFS_RTRMAP_ROOT_REC_ADDR(dblock, 1);
+		trp = XFS_RTRMAP_REC_ADDR(rblock, 1);
+		dmxr = be16_to_cpu(dblock->bb_numrecs);
+		memcpy(trp, frp, sizeof(*frp) * dmxr);
+	}
+}
+
+/*
+ * Convert in-memory form of btree root to on-disk form.
+ */
+void
+xfs_rtrmapbt_to_disk(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*rblock,
+	int			rblocklen,
+	struct xfs_rtrmap_root	*dblock,
+	int			dblocklen)
+{
+	int			dmxr;
+	struct xfs_rtrmap_key	*fkp;
+	__be64			*fpp;
+	struct xfs_rtrmap_key	*tkp;
+	__be64			*tpp;
+	struct xfs_rtrmap_rec	*frp;
+	struct xfs_rtrmap_rec	*trp;
+
+	ASSERT(rblock->bb_magic == cpu_to_be32(XFS_RTRMAP_CRC_MAGIC));
+	ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid));
+	ASSERT(rblock->bb_u.l.bb_blkno == cpu_to_be64(XFS_BUF_DADDR_NULL));
+	ASSERT(rblock->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK));
+	ASSERT(rblock->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK));
+
+	dblock->bb_level = rblock->bb_level;
+	dblock->bb_numrecs = rblock->bb_numrecs;
+
+	if (be16_to_cpu(rblock->bb_level) > 0) {
+		dmxr = xfs_rtrmapbt_maxrecs(mp, dblocklen, 0);
+		fkp = XFS_RTRMAP_KEY_ADDR(rblock, 1);
+		tkp = XFS_RTRMAP_ROOT_KEY_ADDR(dblock, 1);
+		fpp = XFS_RTRMAP_BROOT_PTR_ADDR(rblock, 1, rblocklen);
+		tpp = XFS_RTRMAP_ROOT_PTR_ADDR(dblock, 1, dmxr);
+		dmxr = be16_to_cpu(rblock->bb_numrecs);
+		memcpy(tkp, fkp, 2 * sizeof(*fkp) * dmxr);
+		memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
+	} else {
+		frp = XFS_RTRMAP_REC_ADDR(rblock, 1);
+		trp = XFS_RTRMAP_ROOT_REC_ADDR(dblock, 1);
+		dmxr = be16_to_cpu(rblock->bb_numrecs);
+		memcpy(trp, frp, sizeof(*frp) * dmxr);
+	}
+}
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 5eb19f4..51adc0c 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -54,9 +54,58 @@ struct xfs_mount;
 		 (maxrecs) * 2 * sizeof(struct xfs_rtrmap_key) + \
 		 ((index) - 1) * sizeof(xfs_rtrmap_ptr_t)))
 
+/* Macros for handling the inode root */
+
+#define XFS_RTRMAP_ROOT_REC_ADDR(block, index) \
+	((struct xfs_rtrmap_rec *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_rtrmap_root) + \
+		 ((index) - 1) * sizeof(struct xfs_rtrmap_rec)))
+
+#define XFS_RTRMAP_ROOT_KEY_ADDR(block, index) \
+	((struct xfs_rtrmap_key *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_rtrmap_root) + \
+		 ((index) - 1) * 2 * sizeof(struct xfs_rtrmap_key)))
+
+#define XFS_RTRMAP_ROOT_PTR_ADDR(block, index, maxrecs) \
+	((xfs_rtrmap_ptr_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_rtrmap_root) + \
+		 (maxrecs) * 2 * sizeof(struct xfs_rtrmap_key) + \
+		 ((index) - 1) * sizeof(xfs_rtrmap_ptr_t)))
+
+#define XFS_RTRMAP_BROOT_PTR_ADDR(bb, i, sz) \
+	XFS_RTRMAP_PTR_ADDR(bb, i, xfs_rtrmapbt_maxrecs(mp, sz, 0))
+
+#define XFS_RTRMAP_BROOT_SPACE_CALC(nrecs, level) \
+	(int)(XFS_RTRMAP_BLOCK_LEN + ((level) > 0 ? \
+	       ((nrecs) * (2 * sizeof(struct xfs_rtrmap_key) + sizeof(xfs_rtrmap_ptr_t))) : \
+	       ((nrecs) * sizeof(struct xfs_rtrmap_rec))))
+
+#define XFS_RTRMAP_BROOT_SPACE(bb) \
+	(XFS_RTRMAP_BROOT_SPACE_CALC(be16_to_cpu((bb)->bb_numrecs), \
+				     be16_to_cpu((bb)->bb_level)))
+
+#define XFS_RTRMAP_ROOT_SPACE_CALC(nrecs, level) \
+	(int)(sizeof(struct xfs_rtrmap_root) + ((level) > 0 ? \
+	       ((nrecs) * (2 * sizeof(struct xfs_rtrmap_key) + sizeof(xfs_rtrmap_ptr_t))) : \
+	       ((nrecs) * sizeof(struct xfs_rtrmap_rec))))
+
+#define XFS_RTRMAP_ROOT_SPACE(bb) \
+	(XFS_RTRMAP_ROOT_SPACE_CALC(be16_to_cpu((bb)->bb_numrecs), \
+				    be16_to_cpu((bb)->bb_level)))
+
 struct xfs_btree_cur *xfs_rtrmapbt_init_cursor(struct xfs_mount *mp,
 				struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_rtrmapbt_maxrecs(struct xfs_mount *mp, int blocklen, bool leaf);
 extern void xfs_rtrmapbt_compute_maxlevels(struct xfs_mount *mp);
 
+void xfs_rtrmapbt_from_disk(struct xfs_inode *ip,
+		struct xfs_rtrmap_root *dblock, int dblocklen,
+		struct xfs_btree_block *rblock, int rblocklen);
+void xfs_rtrmapbt_to_disk(struct xfs_mount *mp,
+		struct xfs_btree_block *rblock, int rblocklen,
+		struct xfs_rtrmap_root *dblock, int dblocklen);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

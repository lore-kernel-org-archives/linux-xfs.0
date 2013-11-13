Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 014317F7D
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:56:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD10B304067
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:56:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id L6fCgkWwGcaON8nT for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:56:24 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rADFuOJv017180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:24 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rADFuNq0001406
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 03/20] xfs: support the XFS_BTNUM_FINOBT free inode btree
	type
Date: Wed, 13 Nov 2013 10:56:05 -0500
Message-Id: <1384358182-37967-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1384358182-37967-1-git-send-email-bfoster@redhat.com>
References: <1384358182-37967-1-git-send-email-bfoster@redhat.com>
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

Define the AGI fields for the finobt root/level and add magic
numbers. Update the btree code to add support for the new
XFS_BTNUM_FINOBT inode btree.

The finobt root block is reserved immediately following the inobt
root block in the AG. Update XFS_PREALLOC_BLOCKS() to determine the
starting AG data block based on whether finobt support is enabled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 include/xfs_ag.h          | 32 +++++++++++++++----------
 include/xfs_btree.h       |  3 +++
 include/xfs_format.h      | 14 ++++++++++-
 include/xfs_types.h       |  2 +-
 libxfs/xfs_btree.c        |  6 +++--
 libxfs/xfs_ialloc.c       | 37 +++++++++++++++++++++++++----
 libxfs/xfs_ialloc_btree.c | 60 +++++++++++++++++++++++++++++++++++++++++++++--
 7 files changed, 130 insertions(+), 24 deletions(-)

diff --git a/include/xfs_ag.h b/include/xfs_ag.h
index 3fc1098..5d3011f 100644
--- a/include/xfs_ag.h
+++ b/include/xfs_ag.h
@@ -164,22 +164,28 @@ typedef struct xfs_agi {
 	__be32		agi_pad32;
 	__be64		agi_lsn;	/* last write sequence */
 
+	__be32		agi_free_root; /* root of the free inode btree */
+	__be32		agi_free_level;/* levels in free inode btree */
+
 	/* structure must be padded to 64 bit alignment */
 } xfs_agi_t;
 
-#define	XFS_AGI_MAGICNUM	0x00000001
-#define	XFS_AGI_VERSIONNUM	0x00000002
-#define	XFS_AGI_SEQNO		0x00000004
-#define	XFS_AGI_LENGTH		0x00000008
-#define	XFS_AGI_COUNT		0x00000010
-#define	XFS_AGI_ROOT		0x00000020
-#define	XFS_AGI_LEVEL		0x00000040
-#define	XFS_AGI_FREECOUNT	0x00000080
-#define	XFS_AGI_NEWINO		0x00000100
-#define	XFS_AGI_DIRINO		0x00000200
-#define	XFS_AGI_UNLINKED	0x00000400
-#define	XFS_AGI_NUM_BITS	11
-#define	XFS_AGI_ALL_BITS	((1 << XFS_AGI_NUM_BITS) - 1)
+#define	XFS_AGI_MAGICNUM	(1 << 0)
+#define	XFS_AGI_VERSIONNUM	(1 << 1)
+#define	XFS_AGI_SEQNO		(1 << 2)
+#define	XFS_AGI_LENGTH		(1 << 3)
+#define	XFS_AGI_COUNT		(1 << 4)
+#define	XFS_AGI_ROOT		(1 << 5)
+#define	XFS_AGI_LEVEL		(1 << 6)
+#define	XFS_AGI_FREECOUNT	(1 << 7)
+#define	XFS_AGI_NEWINO		(1 << 8)
+#define	XFS_AGI_DIRINO		(1 << 9)
+#define	XFS_AGI_UNLINKED	(1 << 10)
+#define	XFS_AGI_NUM_BITS_R1	11	/* end of the 1st agi logging region */
+#define	XFS_AGI_ALL_BITS_R1	((1 << XFS_AGI_NUM_BITS_R1) - 1)
+#define	XFS_AGI_FREE_ROOT	(1 << 11)
+#define	XFS_AGI_FREE_LEVEL	(1 << 12)
+#define	XFS_AGI_NUM_BITS_R2	13
 
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGI_DADDR(mp)	((xfs_daddr_t)(2 << (mp)->m_sectbb_log))
diff --git a/include/xfs_btree.h b/include/xfs_btree.h
index 6afe0b2..2590d40 100644
--- a/include/xfs_btree.h
+++ b/include/xfs_btree.h
@@ -37,6 +37,7 @@ extern kmem_zone_t	*xfs_btree_cur_zone;
 #define	XFS_BTNUM_CNT	((xfs_btnum_t)XFS_BTNUM_CNTi)
 #define	XFS_BTNUM_BMAP	((xfs_btnum_t)XFS_BTNUM_BMAPi)
 #define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
+#define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 
 /*
  * For logging record fields.
@@ -67,6 +68,7 @@ do {    \
 	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_INC(abtc, stat); break;	\
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(bmbt, stat); break;	\
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
+	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -80,6 +82,7 @@ do {    \
 	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_ADD(abtc, stat, val); break; \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_ADD(bmbt, stat, val); break; \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
+	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
diff --git a/include/xfs_format.h b/include/xfs_format.h
index 997c770..f8e1834 100644
--- a/include/xfs_format.h
+++ b/include/xfs_format.h
@@ -200,6 +200,8 @@ typedef __be32 xfs_alloc_ptr_t;
  */
 #define	XFS_IBT_MAGIC		0x49414254	/* 'IABT' */
 #define	XFS_IBT_CRC_MAGIC	0x49414233	/* 'IAB3' */
+#define	XFS_FIBT_MAGIC		0x46494254	/* 'FIBT' */
+#define	XFS_FIBT_CRC_MAGIC	0x46494233	/* 'FIB3' */
 
 typedef	__uint64_t	xfs_inofree_t;
 #define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
@@ -242,7 +244,17 @@ typedef __be32 xfs_inobt_ptr_t;
  * block numbers in the AG.
  */
 #define	XFS_IBT_BLOCK(mp)		((xfs_agblock_t)(XFS_CNT_BLOCK(mp) + 1))
-#define	XFS_PREALLOC_BLOCKS(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
+#define	XFS_FIBT_BLOCK(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
+
+/*
+ * The first data block of an AG depends on whether the filesystem was formatted
+ * with the finobt feature. If so, account for the finobt reserved root btree
+ * block.
+ */
+#define XFS_PREALLOC_BLOCKS(mp) \
+	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
+	 XFS_FIBT_BLOCK(mp) + 1 : \
+	 XFS_IBT_BLOCK(mp) + 1)
 
 
 
diff --git a/include/xfs_types.h b/include/xfs_types.h
index 82bbc34..65c6e66 100644
--- a/include/xfs_types.h
+++ b/include/xfs_types.h
@@ -134,7 +134,7 @@ typedef enum {
 
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_BMAPi, XFS_BTNUM_INOi,
-	XFS_BTNUM_MAX
+	XFS_BTNUM_FINOi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 struct xfs_name {
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 2dd6fb7..871323a 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -27,9 +27,10 @@ kmem_zone_t	*xfs_btree_cur_zone;
  * Btree magic numbers.
  */
 static const __uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
-	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, XFS_BMAP_MAGIC, XFS_IBT_MAGIC },
+	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
+	  XFS_FIBT_MAGIC },
 	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC,
-	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC }
+	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC }
 };
 #define xfs_btree_magic(cur) \
 	xfs_magics[!!((cur)->bc_flags & XFS_BTREE_CRC_BLOCKS)][cur->bc_btnum]
@@ -1101,6 +1102,7 @@ xfs_btree_set_refs(
 		xfs_buf_set_ref(bp, XFS_ALLOC_BTREE_REF);
 		break;
 	case XFS_BTNUM_INO:
+	case XFS_BTNUM_FINO:
 		xfs_buf_set_ref(bp, XFS_INO_BTREE_REF);
 		break;
 	case XFS_BTNUM_BMAP:
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 337a4c6..1bb30c6 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1482,6 +1482,8 @@ xfs_ialloc_log_agi(
 		offsetof(xfs_agi_t, agi_newino),
 		offsetof(xfs_agi_t, agi_dirino),
 		offsetof(xfs_agi_t, agi_unlinked),
+		offsetof(xfs_agi_t, agi_free_root),
+		offsetof(xfs_agi_t, agi_free_level),
 		sizeof(xfs_agi_t)
 	};
 #ifdef DEBUG
@@ -1491,14 +1493,39 @@ xfs_ialloc_log_agi(
 	ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
 #endif
 	/*
-	 * Compute byte offsets for the first and last fields.
+	 * The growth of the agi buffer over time now requires that we interpret
+	 * the buffer as two logical regions delineated at the end of the unlinked
+	 * list. This is due to the size of the hash table and its location in the
+	 * middle of the agi.
+	 *
+	 * For example, a request to log a field before agi_unlinked and a field
+	 * after agi_unlinked could cause us to log the entire hash table and use
+	 * an excessive amount of log space. To avoid this behavior, log the
+	 * region up through agi_unlinked in one call and the region after
+	 * agi_unlinked through the end of the structure in another.
 	 */
-	xfs_btree_offsets(fields, offsets, XFS_AGI_NUM_BITS, &first, &last);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_AGI_BUF);
+
 	/*
-	 * Log the allocation group inode header buffer.
+	 * Compute byte offsets for the first and last fields in the first
+	 * region and log agi buffer. This only logs up through agi_unlinked.
 	 */
-	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_AGI_BUF);
-	xfs_trans_log_buf(tp, bp, first, last);
+	if (fields & XFS_AGI_ALL_BITS_R1) {
+		xfs_btree_offsets(fields, offsets, XFS_AGI_NUM_BITS_R1,
+				  &first, &last);
+		xfs_trans_log_buf(tp, bp, first, last);
+	}
+
+	/*
+	 * Mask off the bits in the first region and calculate the first and last
+	 * field offsets for any bits in the second region.
+	 */
+	fields &= ~XFS_AGI_ALL_BITS_R1;
+	if (fields) {
+		xfs_btree_offsets(fields, offsets, XFS_AGI_NUM_BITS_R2,
+				  &first, &last);
+		xfs_trans_log_buf(tp, bp, first, last);
+	}
 }
 
 #ifdef DEBUG
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 0b9b91a..3e9425c 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -48,6 +48,21 @@ xfs_inobt_set_root(
 	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
 }
 
+STATIC void
+xfs_finobt_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*nptr,
+	int			inc)	/* level change */
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+
+	agi->agi_free_root = nptr->s;
+	be32_add_cpu(&agi->agi_free_level, inc);
+	xfs_ialloc_log_agi(cur->bc_tp, agbp,
+			   XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL);
+}
+
 STATIC int
 xfs_inobt_alloc_block(
 	struct xfs_btree_cur	*cur,
@@ -155,6 +170,17 @@ xfs_inobt_init_ptr_from_cur(
 	ptr->s = agi->agi_root;
 }
 
+STATIC void
+xfs_finobt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
+
+	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
+	ptr->s = agi->agi_free_root;
+}
+
 STATIC __int64_t
 xfs_inobt_key_diff(
 	struct xfs_btree_cur	*cur,
@@ -185,6 +211,7 @@ xfs_inobt_verify(
 	 */
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_IBT_CRC_MAGIC):
+	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
@@ -196,6 +223,7 @@ xfs_inobt_verify(
 			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_IBT_MAGIC):
+	case cpu_to_be32(XFS_FIBT_MAGIC):
 		break;
 	default:
 		return 0;
@@ -370,6 +398,28 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 #endif
 };
 
+static const struct xfs_btree_ops xfs_finobt_ops = {
+	.rec_len		= sizeof(xfs_inobt_rec_t),
+	.key_len		= sizeof(xfs_inobt_key_t),
+
+	.dup_cursor		= xfs_inobt_dup_cursor,
+	.set_root		= xfs_finobt_set_root,
+	.alloc_block		= xfs_inobt_alloc_block,
+	.free_block		= xfs_inobt_free_block,
+	.get_minrecs		= xfs_inobt_get_minrecs,
+	.get_maxrecs		= xfs_inobt_get_maxrecs,
+	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
+	.init_rec_from_key	= xfs_inobt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
+	.key_diff		= xfs_inobt_key_diff,
+	.buf_ops		= &xfs_inobt_buf_ops,
+#if defined(DEBUG) || defined(XFS_WARN)
+	.keys_inorder		= xfs_inobt_keys_inorder,
+	.recs_inorder		= xfs_inobt_recs_inorder,
+#endif
+};
+
 /*
  * Allocate a new inode btree cursor.
  */
@@ -388,11 +438,17 @@ xfs_inobt_init_cursor(
 
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
-	cur->bc_nlevels = be32_to_cpu(agi->agi_level);
 	cur->bc_btnum = btnum;
+	if (btnum == XFS_BTNUM_INO) {
+		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
+		cur->bc_ops = &xfs_inobt_ops;
+	} else {
+		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
+		cur->bc_ops = &xfs_finobt_ops;
+	}
+
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
-	cur->bc_ops = &xfs_inobt_ops;
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

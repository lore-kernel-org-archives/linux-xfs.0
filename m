Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 84A0B7F50
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 13:25:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 57196304089
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 11:25:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gEIaRpUObWqBcZ6z for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 11:25:47 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r83IPkQ3031075
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r83IPkE0021382
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 03/11] xfs: support the XFS_BTNUM_FINOBT free inode btree
	type
Date: Tue,  3 Sep 2013 14:25:00 -0400
Message-Id: <1378232708-57156-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/xfs_ag.h           |  7 ++++++-
 fs/xfs/xfs_btree.c        |  6 ++++--
 fs/xfs/xfs_btree.h        |  3 +++
 fs/xfs/xfs_ialloc.c       |  2 ++
 fs/xfs/xfs_ialloc_btree.c | 29 +++++++++++++++++++++++------
 fs/xfs/xfs_ialloc_btree.h | 14 +++++++++++++-
 fs/xfs/xfs_log_recover.c  |  2 ++
 fs/xfs/xfs_stats.h        | 18 +++++++++++++++++-
 fs/xfs/xfs_types.h        |  2 +-
 9 files changed, 71 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 1cb740a..b85585d 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -166,6 +166,9 @@ typedef struct xfs_agi {
 	__be32		agi_pad32;
 	__be64		agi_lsn;	/* last write sequence */
 
+	__be32		agi_free_root; /* root of the free inode btree */
+	__be32		agi_free_level;/* levels in free inode btree */
+
 	/* structure must be padded to 64 bit alignment */
 } xfs_agi_t;
 
@@ -180,7 +183,9 @@ typedef struct xfs_agi {
 #define	XFS_AGI_NEWINO		0x00000100
 #define	XFS_AGI_DIRINO		0x00000200
 #define	XFS_AGI_UNLINKED	0x00000400
-#define	XFS_AGI_NUM_BITS	11
+#define	XFS_AGI_FREE_ROOT	0x00000800
+#define	XFS_AGI_FREE_LEVEL	0x00001000
+#define	XFS_AGI_NUM_BITS	13
 #define	XFS_AGI_ALL_BITS	((1 << XFS_AGI_NUM_BITS) - 1)
 
 /* disk block (xfs_daddr_t) in the AG */
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 7a2b4da..0090e3f 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -45,9 +45,10 @@ kmem_zone_t	*xfs_btree_cur_zone;
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
@@ -1102,6 +1103,7 @@ xfs_btree_set_refs(
 		xfs_buf_set_ref(bp, XFS_ALLOC_BTREE_REF);
 		break;
 	case XFS_BTNUM_INO:
+	case XFS_BTNUM_FINO:
 		xfs_buf_set_ref(bp, XFS_INO_BTREE_REF);
 		break;
 	case XFS_BTNUM_BMAP:
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index c8473c7..939002d 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -37,6 +37,7 @@ extern kmem_zone_t	*xfs_btree_cur_zone;
 #define	XFS_BTNUM_CNT	((xfs_btnum_t)XFS_BTNUM_CNTi)
 #define	XFS_BTNUM_BMAP	((xfs_btnum_t)XFS_BTNUM_BMAPi)
 #define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
+#define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 
 /*
  * Generic btree header.
@@ -144,6 +145,7 @@ do {    \
 	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_INC(abtc, stat); break;	\
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(bmbt, stat); break;	\
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
+	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -157,6 +159,7 @@ do {    \
 	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_ADD(abtc, stat, val); break; \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_ADD(bmbt, stat, val); break; \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
+	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 524aa88..5ced506 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1505,6 +1505,8 @@ xfs_ialloc_log_agi(
 		offsetof(xfs_agi_t, agi_newino),
 		offsetof(xfs_agi_t, agi_dirino),
 		offsetof(xfs_agi_t, agi_unlinked),
+		offsetof(xfs_agi_t, agi_free_root),
+		offsetof(xfs_agi_t, agi_free_level),
 		sizeof(xfs_agi_t)
 	};
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index 0cdb88b..7923292 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -62,10 +62,18 @@ xfs_inobt_set_root(
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
 	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
-
-	agi->agi_root = nptr->s;
-	be32_add_cpu(&agi->agi_level, inc);
-	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
+	int			fields;
+
+	if (cur->bc_btnum == XFS_BTNUM_INO) {
+		agi->agi_root = nptr->s;
+		be32_add_cpu(&agi->agi_level, inc);
+		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
+	} else {
+		agi->agi_free_root = nptr->s;
+		be32_add_cpu(&agi->agi_free_level, inc);
+		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
+	}
+	xfs_ialloc_log_agi(cur->bc_tp, agbp, fields);
 }
 
 STATIC int
@@ -172,7 +180,10 @@ xfs_inobt_init_ptr_from_cur(
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
 
-	ptr->s = agi->agi_root;
+	if (cur->bc_btnum == XFS_BTNUM_INO)
+		ptr->s = agi->agi_root;
+	else
+		ptr->s = agi->agi_free_root;
 }
 
 STATIC __int64_t
@@ -205,6 +216,7 @@ xfs_inobt_verify(
 	 */
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_IBT_CRC_MAGIC):
+	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
@@ -216,6 +228,7 @@ xfs_inobt_verify(
 			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_IBT_MAGIC):
+	case cpu_to_be32(XFS_FIBT_MAGIC):
 		break;
 	default:
 		return 0;
@@ -335,8 +348,12 @@ xfs_inobt_init_cursor(
 
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
-	cur->bc_nlevels = be32_to_cpu(agi->agi_level);
 	cur->bc_btnum = btnum;
+	if (btnum == XFS_BTNUM_INO)
+		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
+	else
+		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
+
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
 	cur->bc_ops = &xfs_inobt_ops;
diff --git a/fs/xfs/xfs_ialloc_btree.h b/fs/xfs/xfs_ialloc_btree.h
index ce7a62b..33d6dd4 100644
--- a/fs/xfs/xfs_ialloc_btree.h
+++ b/fs/xfs/xfs_ialloc_btree.h
@@ -31,6 +31,8 @@ struct xfs_mount;
  */
 #define	XFS_IBT_MAGIC		0x49414254	/* 'IABT' */
 #define	XFS_IBT_CRC_MAGIC	0x49414233	/* 'IAB3' */
+#define	XFS_FIBT_MAGIC		0x46494254	/* 'FIBT' */
+#define	XFS_FIBT_CRC_MAGIC	0x46494233	/* 'FIB3' */
 
 typedef	__uint64_t	xfs_inofree_t;
 #define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
@@ -73,7 +75,17 @@ typedef __be32 xfs_inobt_ptr_t;
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
 
 /*
  * Btree block header size depends on a superblock flag.
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7c0c1fd..b8f16d2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2088,7 +2088,9 @@ xlog_recover_validate_buf_type(
 			bp->b_ops = &xfs_allocbt_buf_ops;
 			break;
 		case XFS_IBT_CRC_MAGIC:
+		case XFS_FIBT_CRC_MAGIC:
 		case XFS_IBT_MAGIC:
+		case XFS_FIBT_MAGIC:
 			bp->b_ops = &xfs_inobt_buf_ops;
 			break;
 		case XFS_BMAP_CRC_MAGIC:
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index c03ad38..c8f238b 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -183,7 +183,23 @@ struct xfsstats {
 	__uint32_t		xs_ibt_2_alloc;
 	__uint32_t		xs_ibt_2_free;
 	__uint32_t		xs_ibt_2_moves;
-#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_IBT_V2+6)
+#define XFSSTAT_END_FIBT_V2		(XFSSTAT_END_IBT_V2+15)
+	__uint32_t		xs_fibt_2_lookup;
+	__uint32_t		xs_fibt_2_compare;
+	__uint32_t		xs_fibt_2_insrec;
+	__uint32_t		xs_fibt_2_delrec;
+	__uint32_t		xs_fibt_2_newroot;
+	__uint32_t		xs_fibt_2_killroot;
+	__uint32_t		xs_fibt_2_increment;
+	__uint32_t		xs_fibt_2_decrement;
+	__uint32_t		xs_fibt_2_lshift;
+	__uint32_t		xs_fibt_2_rshift;
+	__uint32_t		xs_fibt_2_split;
+	__uint32_t		xs_fibt_2_join;
+	__uint32_t		xs_fibt_2_alloc;
+	__uint32_t		xs_fibt_2_free;
+	__uint32_t		xs_fibt_2_moves;
+#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_FIBT_V2+6)
 	__uint32_t		xs_qm_dqreclaims;
 	__uint32_t		xs_qm_dqreclaim_misses;
 	__uint32_t		xs_qm_dquot_dups;
diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
index 82bbc34..65c6e66 100644
--- a/fs/xfs/xfs_types.h
+++ b/fs/xfs/xfs_types.h
@@ -134,7 +134,7 @@ typedef enum {
 
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_BMAPi, XFS_BTNUM_INOi,
-	XFS_BTNUM_MAX
+	XFS_BTNUM_FINOi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 struct xfs_name {
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

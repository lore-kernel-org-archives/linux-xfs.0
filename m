Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C0E97FA7
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 00:41:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9D0A9AC004
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 22:41:24 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GuaqYSJ8BKK6hBG8 for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 22:41:21 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VgU8N-0005bF-TC
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:03 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VgU8N-0006hZ-Rv
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/36] xfs: create a shared header file for format-related
	information
Date: Wed, 13 Nov 2013 17:40:27 +1100
Message-Id: <1384324860-25677-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1384324860-25677-1-git-send-email-david@fromorbit.com>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
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

All of the buffer operations structures are needed to be exported
for xfs_db, so move them all to a common location rather than
spreading them all over the place. They are verifying the on-disk
format, so while xfs_format.h might be a good place, it is not part
of the on disk format.

Hence we need to create a new header file that we centralise these
related definitions. Start by moving the bffer operations
structures, and then also move all the other definitions that have
crept into xfs_log_format.h and xfs_format.h as there was no other
shared header file to put them in.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/Makefile           |   1 +
 include/libxfs.h           |   1 +
 include/xfs_ag.h           |   4 -
 include/xfs_alloc.h        |   3 -
 include/xfs_alloc_btree.h  |   2 -
 include/xfs_attr_leaf.h    |   2 -
 include/xfs_bmap_btree.h   |   2 -
 include/xfs_da_btree.h     |   2 -
 include/xfs_format.h       |  10 --
 include/xfs_ialloc.h       |   2 -
 include/xfs_ialloc_btree.h |   2 -
 include/xfs_inode_buf.h    |   2 -
 include/xfs_log_format.h   | 177 --------------------------------
 include/xfs_sb.h           |   3 -
 include/xfs_shared.h       | 244 +++++++++++++++++++++++++++++++++++++++++++++
 15 files changed, 246 insertions(+), 211 deletions(-)
 create mode 100644 include/xfs_shared.h

diff --git a/include/Makefile b/include/Makefile
index dc6a8bb..6682b9d 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -40,6 +40,7 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_metadump.h \
 	xfs_quota_defs.h \
 	xfs_sb.h \
+	xfs_shared.h \
 	xfs_trace.h \
 	xfs_trans_resv.h \
 	xfs_trans_space.h
diff --git a/include/libxfs.h b/include/libxfs.h
index b837072..835ba37 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -37,6 +37,7 @@
 #include <xfs/xfs_fs.h>
 #include <xfs/xfs_arch.h>
 
+#include <xfs/xfs_shared.h>
 #include <xfs/xfs_format.h>
 #include <xfs/xfs_log_format.h>
 #include <xfs/xfs_quota_defs.h>
diff --git a/include/xfs_ag.h b/include/xfs_ag.h
index 1cb740a..3fc1098 100644
--- a/include/xfs_ag.h
+++ b/include/xfs_ag.h
@@ -128,8 +128,6 @@ typedef struct xfs_agf {
 extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
 
-extern const struct xfs_buf_ops xfs_agf_buf_ops;
-
 /*
  * Size of the unlinked inode hash table in the agi.
  */
@@ -191,8 +189,6 @@ typedef struct xfs_agi {
 extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 				xfs_agnumber_t agno, struct xfs_buf **bpp);
 
-extern const struct xfs_buf_ops xfs_agi_buf_ops;
-
 /*
  * The third a.g. block contains the a.g. freelist, an array
  * of block pointers to blocks owned by the allocation btree code.
diff --git a/include/xfs_alloc.h b/include/xfs_alloc.h
index 99d0a61..feacb06 100644
--- a/include/xfs_alloc.h
+++ b/include/xfs_alloc.h
@@ -231,7 +231,4 @@ xfs_alloc_get_rec(
 	xfs_extlen_t		*len,	/* output: length of extent */
 	int			*stat);	/* output: success/failure */
 
-extern const struct xfs_buf_ops xfs_agf_buf_ops;
-extern const struct xfs_buf_ops xfs_agfl_buf_ops;
-
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/include/xfs_alloc_btree.h b/include/xfs_alloc_btree.h
index e3a3f74..72676c3 100644
--- a/include/xfs_alloc_btree.h
+++ b/include/xfs_alloc_btree.h
@@ -95,6 +95,4 @@ extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		xfs_agnumber_t, xfs_btnum_t);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
 
-extern const struct xfs_buf_ops xfs_allocbt_buf_ops;
-
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/include/xfs_attr_leaf.h b/include/xfs_attr_leaf.h
index d9b148f..3ec5ec0 100644
--- a/include/xfs_attr_leaf.h
+++ b/include/xfs_attr_leaf.h
@@ -106,6 +106,4 @@ void	xfs_attr3_leaf_hdr_from_disk(struct xfs_attr3_icleaf_hdr *to,
 void	xfs_attr3_leaf_hdr_to_disk(struct xfs_attr_leafblock *to,
 				   struct xfs_attr3_icleaf_hdr *from);
 
-extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
-
 #endif	/* __XFS_ATTR_LEAF_H__ */
diff --git a/include/xfs_bmap_btree.h b/include/xfs_bmap_btree.h
index 1b726d6..e307978 100644
--- a/include/xfs_bmap_btree.h
+++ b/include/xfs_bmap_btree.h
@@ -239,6 +239,4 @@ extern int xfs_bmbt_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
 
-extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
-
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/include/xfs_da_btree.h b/include/xfs_da_btree.h
index 9323b0e..e492dca 100644
--- a/include/xfs_da_btree.h
+++ b/include/xfs_da_btree.h
@@ -169,8 +169,6 @@ int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			 xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			 struct xfs_buf **bpp, int which_fork);
 
-extern const struct xfs_buf_ops xfs_da3_node_buf_ops;
-
 /*
  * Utility routines.
  */
diff --git a/include/xfs_format.h b/include/xfs_format.h
index 35c08ff..a790428 100644
--- a/include/xfs_format.h
+++ b/include/xfs_format.h
@@ -156,14 +156,4 @@ struct xfs_dsymlink_hdr {
 	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
 			sizeof(struct xfs_dsymlink_hdr) : 0))
 
-int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
-int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
-			uint32_t size, struct xfs_buf *bp);
-bool xfs_symlink_hdr_ok(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
-			uint32_t size, struct xfs_buf *bp);
-void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
-				 struct xfs_inode *ip, struct xfs_ifork *ifp);
-
-extern const struct xfs_buf_ops xfs_symlink_buf_ops;
-
 #endif /* __XFS_FORMAT_H__ */
diff --git a/include/xfs_ialloc.h b/include/xfs_ialloc.h
index 68c0732..1557798 100644
--- a/include/xfs_ialloc.h
+++ b/include/xfs_ialloc.h
@@ -158,6 +158,4 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_agnumber_t agno, xfs_agblock_t agbno,
 			  xfs_agblock_t length, unsigned int gen);
 
-extern const struct xfs_buf_ops xfs_agi_buf_ops;
-
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/include/xfs_ialloc_btree.h b/include/xfs_ialloc_btree.h
index 3ac36b7..cfbfe46 100644
--- a/include/xfs_ialloc_btree.h
+++ b/include/xfs_ialloc_btree.h
@@ -110,6 +110,4 @@ extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
-extern const struct xfs_buf_ops xfs_inobt_buf_ops;
-
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/include/xfs_inode_buf.h b/include/xfs_inode_buf.h
index aae9fc4..e8fd3bd 100644
--- a/include/xfs_inode_buf.h
+++ b/include/xfs_inode_buf.h
@@ -47,6 +47,4 @@ void		xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #define	xfs_inobp_check(mp, bp)
 #endif /* DEBUG */
 
-extern const struct xfs_buf_ops xfs_inode_buf_ops;
-
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/include/xfs_log_format.h b/include/xfs_log_format.h
index 31e3a06..aeaa715 100644
--- a/include/xfs_log_format.h
+++ b/include/xfs_log_format.h
@@ -234,178 +234,6 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_ICREATE,	"XFS_LI_ICREATE" }
 
 /*
- * Transaction types.  Used to distinguish types of buffers.
- */
-#define XFS_TRANS_SETATTR_NOT_SIZE	1
-#define XFS_TRANS_SETATTR_SIZE		2
-#define XFS_TRANS_INACTIVE		3
-#define XFS_TRANS_CREATE		4
-#define XFS_TRANS_CREATE_TRUNC		5
-#define XFS_TRANS_TRUNCATE_FILE		6
-#define XFS_TRANS_REMOVE		7
-#define XFS_TRANS_LINK			8
-#define XFS_TRANS_RENAME		9
-#define XFS_TRANS_MKDIR			10
-#define XFS_TRANS_RMDIR			11
-#define XFS_TRANS_SYMLINK		12
-#define XFS_TRANS_SET_DMATTRS		13
-#define XFS_TRANS_GROWFS		14
-#define XFS_TRANS_STRAT_WRITE		15
-#define XFS_TRANS_DIOSTRAT		16
-/* 17 was XFS_TRANS_WRITE_SYNC */
-#define	XFS_TRANS_WRITEID		18
-#define	XFS_TRANS_ADDAFORK		19
-#define	XFS_TRANS_ATTRINVAL		20
-#define	XFS_TRANS_ATRUNCATE		21
-#define	XFS_TRANS_ATTR_SET		22
-#define	XFS_TRANS_ATTR_RM		23
-#define	XFS_TRANS_ATTR_FLAG		24
-#define	XFS_TRANS_CLEAR_AGI_BUCKET	25
-#define XFS_TRANS_QM_SBCHANGE		26
-/*
- * Dummy entries since we use the transaction type to index into the
- * trans_type[] in xlog_recover_print_trans_head()
- */
-#define XFS_TRANS_DUMMY1		27
-#define XFS_TRANS_DUMMY2		28
-#define XFS_TRANS_QM_QUOTAOFF		29
-#define XFS_TRANS_QM_DQALLOC		30
-#define XFS_TRANS_QM_SETQLIM		31
-#define XFS_TRANS_QM_DQCLUSTER		32
-#define XFS_TRANS_QM_QINOCREATE		33
-#define XFS_TRANS_QM_QUOTAOFF_END	34
-#define XFS_TRANS_SB_UNIT		35
-#define XFS_TRANS_FSYNC_TS		36
-#define	XFS_TRANS_GROWFSRT_ALLOC	37
-#define	XFS_TRANS_GROWFSRT_ZERO		38
-#define	XFS_TRANS_GROWFSRT_FREE		39
-#define	XFS_TRANS_SWAPEXT		40
-#define	XFS_TRANS_SB_COUNT		41
-#define	XFS_TRANS_CHECKPOINT		42
-#define	XFS_TRANS_ICREATE		43
-#define	XFS_TRANS_TYPE_MAX		43
-/* new transaction types need to be reflected in xfs_logprint(8) */
-
-#define XFS_TRANS_TYPES \
-	{ XFS_TRANS_SETATTR_NOT_SIZE,	"SETATTR_NOT_SIZE" }, \
-	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
-	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
-	{ XFS_TRANS_CREATE,		"CREATE" }, \
-	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
-	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
-	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
-	{ XFS_TRANS_LINK,		"LINK" }, \
-	{ XFS_TRANS_RENAME,		"RENAME" }, \
-	{ XFS_TRANS_MKDIR,		"MKDIR" }, \
-	{ XFS_TRANS_RMDIR,		"RMDIR" }, \
-	{ XFS_TRANS_SYMLINK,		"SYMLINK" }, \
-	{ XFS_TRANS_SET_DMATTRS,	"SET_DMATTRS" }, \
-	{ XFS_TRANS_GROWFS,		"GROWFS" }, \
-	{ XFS_TRANS_STRAT_WRITE,	"STRAT_WRITE" }, \
-	{ XFS_TRANS_DIOSTRAT,		"DIOSTRAT" }, \
-	{ XFS_TRANS_WRITEID,		"WRITEID" }, \
-	{ XFS_TRANS_ADDAFORK,		"ADDAFORK" }, \
-	{ XFS_TRANS_ATTRINVAL,		"ATTRINVAL" }, \
-	{ XFS_TRANS_ATRUNCATE,		"ATRUNCATE" }, \
-	{ XFS_TRANS_ATTR_SET,		"ATTR_SET" }, \
-	{ XFS_TRANS_ATTR_RM,		"ATTR_RM" }, \
-	{ XFS_TRANS_ATTR_FLAG,		"ATTR_FLAG" }, \
-	{ XFS_TRANS_CLEAR_AGI_BUCKET,	"CLEAR_AGI_BUCKET" }, \
-	{ XFS_TRANS_QM_SBCHANGE,	"QM_SBCHANGE" }, \
-	{ XFS_TRANS_QM_QUOTAOFF,	"QM_QUOTAOFF" }, \
-	{ XFS_TRANS_QM_DQALLOC,		"QM_DQALLOC" }, \
-	{ XFS_TRANS_QM_SETQLIM,		"QM_SETQLIM" }, \
-	{ XFS_TRANS_QM_DQCLUSTER,	"QM_DQCLUSTER" }, \
-	{ XFS_TRANS_QM_QINOCREATE,	"QM_QINOCREATE" }, \
-	{ XFS_TRANS_QM_QUOTAOFF_END,	"QM_QOFF_END" }, \
-	{ XFS_TRANS_SB_UNIT,		"SB_UNIT" }, \
-	{ XFS_TRANS_FSYNC_TS,		"FSYNC_TS" }, \
-	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
-	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
-	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
-	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
-	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
-	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
-	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
-	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
-	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
-
-/*
- * This structure is used to track log items associated with
- * a transaction.  It points to the log item and keeps some
- * flags to track the state of the log item.  It also tracks
- * the amount of space needed to log the item it describes
- * once we get to commit processing (see xfs_trans_commit()).
- */
-struct xfs_log_item_desc {
-	struct xfs_log_item	*lid_item;
-	struct list_head	lid_trans;
-	unsigned char		lid_flags;
-};
-
-#define XFS_LID_DIRTY		0x1
-
-/*
- * Values for t_flags.
- */
-#define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
-#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
-#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
-#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
-#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
-#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
-#define XFS_TRANS_FREEZE_PROT	0x40	/* Transaction has elevated writer
-					   count in superblock */
-
-/*
- * Values for call flags parameter.
- */
-#define	XFS_TRANS_RELEASE_LOG_RES	0x4
-#define	XFS_TRANS_ABORT			0x8
-
-/*
- * Field values for xfs_trans_mod_sb.
- */
-#define	XFS_TRANS_SB_ICOUNT		0x00000001
-#define	XFS_TRANS_SB_IFREE		0x00000002
-#define	XFS_TRANS_SB_FDBLOCKS		0x00000004
-#define	XFS_TRANS_SB_RES_FDBLOCKS	0x00000008
-#define	XFS_TRANS_SB_FREXTENTS		0x00000010
-#define	XFS_TRANS_SB_RES_FREXTENTS	0x00000020
-#define	XFS_TRANS_SB_DBLOCKS		0x00000040
-#define	XFS_TRANS_SB_AGCOUNT		0x00000080
-#define	XFS_TRANS_SB_IMAXPCT		0x00000100
-#define	XFS_TRANS_SB_REXTSIZE		0x00000200
-#define	XFS_TRANS_SB_RBMBLOCKS		0x00000400
-#define	XFS_TRANS_SB_RBLOCKS		0x00000800
-#define	XFS_TRANS_SB_REXTENTS		0x00001000
-#define	XFS_TRANS_SB_REXTSLOG		0x00002000
-
-/*
- * Here we centralize the specification of XFS meta-data buffer
- * reference count values.  This determine how hard the buffer
- * cache tries to hold onto the buffer.
- */
-#define	XFS_AGF_REF		4
-#define	XFS_AGI_REF		4
-#define	XFS_AGFL_REF		3
-#define	XFS_INO_BTREE_REF	3
-#define	XFS_ALLOC_BTREE_REF	2
-#define	XFS_BMAP_BTREE_REF	2
-#define	XFS_DIR_BTREE_REF	2
-#define	XFS_INO_REF		2
-#define	XFS_ATTR_BTREE_REF	1
-#define	XFS_DQUOT_REF		1
-
-/*
- * Flags for xfs_trans_ichgtime().
- */
-#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
-#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
-#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
-
-
-/*
  * Inode Log Item Format definitions.
  *
  * This is the structure used to lay out an inode log item in the
@@ -793,7 +621,6 @@ typedef struct xfs_qoff_logformat {
 	char			qf_pad[12];	/* padding for future */
 } xfs_qoff_logformat_t;
 
-
 /*
  * Disk quotas status in m_qflags, and also sb_qflags. 16 bits.
  */
@@ -845,8 +672,4 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
-int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
-int	xfs_log_calc_minimum_size(struct xfs_mount *);
-
-
 #endif /* __XFS_LOG_FORMAT_H__ */
diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index 6835b44..35061d4 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -699,7 +699,4 @@ extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
 extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
 
-extern const struct xfs_buf_ops xfs_sb_buf_ops;
-extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
-
 #endif	/* __XFS_SB_H__ */
diff --git a/include/xfs_shared.h b/include/xfs_shared.h
new file mode 100644
index 0000000..63c94b1
--- /dev/null
+++ b/include/xfs_shared.h
@@ -0,0 +1,244 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
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
+#ifndef __XFS_SHARED_H__
+#define __XFS_SHARED_H__
+
+/*
+ * Definitions shared between kernel and userspace that don't fit into any other
+ * header file that is shared with userspace.
+ */
+struct xfs_ifork;
+struct xfs_buf;
+struct xfs_buf_ops;
+struct xfs_mount;
+struct xfs_trans;
+struct xfs_inode;
+
+/*
+ * Buffer verifier operations are widely used, including userspace tools
+ */
+extern const struct xfs_buf_ops xfs_agf_buf_ops;
+extern const struct xfs_buf_ops xfs_agi_buf_ops;
+extern const struct xfs_buf_ops xfs_agf_buf_ops;
+extern const struct xfs_buf_ops xfs_agfl_buf_ops;
+extern const struct xfs_buf_ops xfs_allocbt_buf_ops;
+extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
+extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
+extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
+extern const struct xfs_buf_ops xfs_da3_node_buf_ops;
+extern const struct xfs_buf_ops xfs_dquot_buf_ops;
+extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+extern const struct xfs_buf_ops xfs_agi_buf_ops;
+extern const struct xfs_buf_ops xfs_inobt_buf_ops;
+extern const struct xfs_buf_ops xfs_inode_buf_ops;
+extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
+extern const struct xfs_buf_ops xfs_dquot_buf_ops;
+extern const struct xfs_buf_ops xfs_sb_buf_ops;
+extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
+extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+
+/*
+ * Transaction types.  Used to distinguish types of buffers. These never reach
+ * the log.
+ */
+#define XFS_TRANS_SETATTR_NOT_SIZE	1
+#define XFS_TRANS_SETATTR_SIZE		2
+#define XFS_TRANS_INACTIVE		3
+#define XFS_TRANS_CREATE		4
+#define XFS_TRANS_CREATE_TRUNC		5
+#define XFS_TRANS_TRUNCATE_FILE		6
+#define XFS_TRANS_REMOVE		7
+#define XFS_TRANS_LINK			8
+#define XFS_TRANS_RENAME		9
+#define XFS_TRANS_MKDIR			10
+#define XFS_TRANS_RMDIR			11
+#define XFS_TRANS_SYMLINK		12
+#define XFS_TRANS_SET_DMATTRS		13
+#define XFS_TRANS_GROWFS		14
+#define XFS_TRANS_STRAT_WRITE		15
+#define XFS_TRANS_DIOSTRAT		16
+/* 17 was XFS_TRANS_WRITE_SYNC */
+#define	XFS_TRANS_WRITEID		18
+#define	XFS_TRANS_ADDAFORK		19
+#define	XFS_TRANS_ATTRINVAL		20
+#define	XFS_TRANS_ATRUNCATE		21
+#define	XFS_TRANS_ATTR_SET		22
+#define	XFS_TRANS_ATTR_RM		23
+#define	XFS_TRANS_ATTR_FLAG		24
+#define	XFS_TRANS_CLEAR_AGI_BUCKET	25
+#define XFS_TRANS_QM_SBCHANGE		26
+/*
+ * Dummy entries since we use the transaction type to index into the
+ * trans_type[] in xlog_recover_print_trans_head()
+ */
+#define XFS_TRANS_DUMMY1		27
+#define XFS_TRANS_DUMMY2		28
+#define XFS_TRANS_QM_QUOTAOFF		29
+#define XFS_TRANS_QM_DQALLOC		30
+#define XFS_TRANS_QM_SETQLIM		31
+#define XFS_TRANS_QM_DQCLUSTER		32
+#define XFS_TRANS_QM_QINOCREATE		33
+#define XFS_TRANS_QM_QUOTAOFF_END	34
+#define XFS_TRANS_SB_UNIT		35
+#define XFS_TRANS_FSYNC_TS		36
+#define	XFS_TRANS_GROWFSRT_ALLOC	37
+#define	XFS_TRANS_GROWFSRT_ZERO		38
+#define	XFS_TRANS_GROWFSRT_FREE		39
+#define	XFS_TRANS_SWAPEXT		40
+#define	XFS_TRANS_SB_COUNT		41
+#define	XFS_TRANS_CHECKPOINT		42
+#define	XFS_TRANS_ICREATE		43
+#define	XFS_TRANS_TYPE_MAX		43
+/* new transaction types need to be reflected in xfs_logprint(8) */
+
+#define XFS_TRANS_TYPES \
+	{ XFS_TRANS_SETATTR_NOT_SIZE,	"SETATTR_NOT_SIZE" }, \
+	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
+	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
+	{ XFS_TRANS_CREATE,		"CREATE" }, \
+	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
+	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
+	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
+	{ XFS_TRANS_LINK,		"LINK" }, \
+	{ XFS_TRANS_RENAME,		"RENAME" }, \
+	{ XFS_TRANS_MKDIR,		"MKDIR" }, \
+	{ XFS_TRANS_RMDIR,		"RMDIR" }, \
+	{ XFS_TRANS_SYMLINK,		"SYMLINK" }, \
+	{ XFS_TRANS_SET_DMATTRS,	"SET_DMATTRS" }, \
+	{ XFS_TRANS_GROWFS,		"GROWFS" }, \
+	{ XFS_TRANS_STRAT_WRITE,	"STRAT_WRITE" }, \
+	{ XFS_TRANS_DIOSTRAT,		"DIOSTRAT" }, \
+	{ XFS_TRANS_WRITEID,		"WRITEID" }, \
+	{ XFS_TRANS_ADDAFORK,		"ADDAFORK" }, \
+	{ XFS_TRANS_ATTRINVAL,		"ATTRINVAL" }, \
+	{ XFS_TRANS_ATRUNCATE,		"ATRUNCATE" }, \
+	{ XFS_TRANS_ATTR_SET,		"ATTR_SET" }, \
+	{ XFS_TRANS_ATTR_RM,		"ATTR_RM" }, \
+	{ XFS_TRANS_ATTR_FLAG,		"ATTR_FLAG" }, \
+	{ XFS_TRANS_CLEAR_AGI_BUCKET,	"CLEAR_AGI_BUCKET" }, \
+	{ XFS_TRANS_QM_SBCHANGE,	"QM_SBCHANGE" }, \
+	{ XFS_TRANS_QM_QUOTAOFF,	"QM_QUOTAOFF" }, \
+	{ XFS_TRANS_QM_DQALLOC,		"QM_DQALLOC" }, \
+	{ XFS_TRANS_QM_SETQLIM,		"QM_SETQLIM" }, \
+	{ XFS_TRANS_QM_DQCLUSTER,	"QM_DQCLUSTER" }, \
+	{ XFS_TRANS_QM_QINOCREATE,	"QM_QINOCREATE" }, \
+	{ XFS_TRANS_QM_QUOTAOFF_END,	"QM_QOFF_END" }, \
+	{ XFS_TRANS_SB_UNIT,		"SB_UNIT" }, \
+	{ XFS_TRANS_FSYNC_TS,		"FSYNC_TS" }, \
+	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
+	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
+	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
+	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
+	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
+	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
+	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
+	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
+	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
+
+/*
+ * This structure is used to track log items associated with
+ * a transaction.  It points to the log item and keeps some
+ * flags to track the state of the log item.  It also tracks
+ * the amount of space needed to log the item it describes
+ * once we get to commit processing (see xfs_trans_commit()).
+ */
+struct xfs_log_item_desc {
+	struct xfs_log_item	*lid_item;
+	struct list_head	lid_trans;
+	unsigned char		lid_flags;
+};
+
+#define XFS_LID_DIRTY		0x1
+
+/* log size calculation functions */
+int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
+int	xfs_log_calc_minimum_size(struct xfs_mount *);
+
+
+/*
+ * Values for t_flags.
+ */
+#define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
+#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
+#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
+#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
+#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
+#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
+#define XFS_TRANS_FREEZE_PROT	0x40	/* Transaction has elevated writer
+					   count in superblock */
+/*
+ * Values for call flags parameter.
+ */
+#define	XFS_TRANS_RELEASE_LOG_RES	0x4
+#define	XFS_TRANS_ABORT			0x8
+
+/*
+ * Field values for xfs_trans_mod_sb.
+ */
+#define	XFS_TRANS_SB_ICOUNT		0x00000001
+#define	XFS_TRANS_SB_IFREE		0x00000002
+#define	XFS_TRANS_SB_FDBLOCKS		0x00000004
+#define	XFS_TRANS_SB_RES_FDBLOCKS	0x00000008
+#define	XFS_TRANS_SB_FREXTENTS		0x00000010
+#define	XFS_TRANS_SB_RES_FREXTENTS	0x00000020
+#define	XFS_TRANS_SB_DBLOCKS		0x00000040
+#define	XFS_TRANS_SB_AGCOUNT		0x00000080
+#define	XFS_TRANS_SB_IMAXPCT		0x00000100
+#define	XFS_TRANS_SB_REXTSIZE		0x00000200
+#define	XFS_TRANS_SB_RBMBLOCKS		0x00000400
+#define	XFS_TRANS_SB_RBLOCKS		0x00000800
+#define	XFS_TRANS_SB_REXTENTS		0x00001000
+#define	XFS_TRANS_SB_REXTSLOG		0x00002000
+
+/*
+ * Here we centralize the specification of XFS meta-data buffer reference count
+ * values.  This determine how hard the buffer cache tries to hold onto the
+ * buffer.
+ */
+#define	XFS_AGF_REF		4
+#define	XFS_AGI_REF		4
+#define	XFS_AGFL_REF		3
+#define	XFS_INO_BTREE_REF	3
+#define	XFS_ALLOC_BTREE_REF	2
+#define	XFS_BMAP_BTREE_REF	2
+#define	XFS_DIR_BTREE_REF	2
+#define	XFS_INO_REF		2
+#define	XFS_ATTR_BTREE_REF	1
+#define	XFS_DQUOT_REF		1
+
+/*
+ * Flags for xfs_trans_ichgtime().
+ */
+#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
+#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
+#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+
+
+/*
+ * Symlink decoding/encoding functions
+ */
+int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
+int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
+			uint32_t size, struct xfs_buf *bp);
+bool xfs_symlink_hdr_ok(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
+			uint32_t size, struct xfs_buf *bp);
+void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
+				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+
+#endif /* __XFS_SHARED_H__ */
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

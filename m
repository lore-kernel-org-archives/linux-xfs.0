Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 31FD680A5
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 148ED304039
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jiGN7eeQoXbqlhz8 for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RT-0004JG-8F
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RT-0002Lh-7C
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 33/49] xfsprogs: sync minor kernel header differences
Date: Fri, 19 Jul 2013 16:45:08 +1000
Message-Id: <1374216324-8781-34-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

There are lots of little differences between kernel and userspace
headers noticable now that the files are largely the same. Clean up
all the formatting, whitespace and other minor differences in the
userspace headers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h           |  8 +++++---
 include/xfs_ag.h           |  2 +-
 include/xfs_alloc_btree.h  |  3 +--
 include/xfs_attr_remote.h  | 28 +++++++++++-----------------
 include/xfs_bmap_btree.h   |  3 +--
 include/xfs_btree.h        |  3 +--
 include/xfs_dinode.h       |  3 ---
 include/xfs_dir2.h         | 11 +----------
 include/xfs_dir2_format.h  | 22 ++++++++++++++--------
 include/xfs_fs.h           | 26 +++++++++++++++-----------
 include/xfs_ialloc_btree.h |  3 +--
 include/xfs_inode_buf.h    |  1 -
 include/xfs_trans.h        |  8 +++-----
 libxfs/xfs.h               |  2 ++
 14 files changed, 56 insertions(+), 67 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index b4d2657..d3b3f02 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -46,7 +46,6 @@
 #include <xfs/xfs_inum.h>
 #include <xfs/xfs_sb.h>
 #include <xfs/xfs_ag.h>
-#include <xfs/xfs_dir2.h>
 #include <xfs/xfs_da_btree.h>
 #include <xfs/xfs_bmap_btree.h>
 #include <xfs/xfs_alloc_btree.h>
@@ -235,6 +234,11 @@ extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
 extern void	libxfs_umount (xfs_mount_t *);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 
+/*
+ * xfs/xfs_dir2_format.h needs struct xfs_mount to be defined
+ */
+#include <xfs/xfs_dir2_format.h>
+#include <xfs/xfs_dir2.h>
 
 /*
  * Simple I/O interface
@@ -610,8 +614,6 @@ extern int	libxfs_iget (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
 				uint, xfs_inode_t **, xfs_daddr_t);
 extern void	libxfs_iput (xfs_inode_t *, uint);
 
-#include <xfs/xfs_dir2_format.h>
-
 /* Shared utility routines */
 extern unsigned int	libxfs_log2_roundup(unsigned int i);
 
diff --git a/include/xfs_ag.h b/include/xfs_ag.h
index 1e0fa34..317aa86 100644
--- a/include/xfs_ag.h
+++ b/include/xfs_ag.h
@@ -102,7 +102,7 @@ typedef struct xfs_agf {
 #define	XFS_AGF_LONGEST		0x00000400
 #define	XFS_AGF_BTREEBLKS	0x00000800
 #define	XFS_AGF_UUID		0x00001000
-#define	XFS_AGF_NUM_BITS	12
+#define	XFS_AGF_NUM_BITS	13
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
 #define XFS_AGF_FLAGS \
diff --git a/include/xfs_alloc_btree.h b/include/xfs_alloc_btree.h
index e160339..e3a3f74 100644
--- a/include/xfs_alloc_btree.h
+++ b/include/xfs_alloc_btree.h
@@ -64,8 +64,7 @@ typedef __be32 xfs_alloc_ptr_t;
  */
 #define XFS_ALLOC_BLOCK_LEN(mp) \
 	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-	 XFS_BTREE_SBLOCK_CRC_LEN : \
-	 XFS_BTREE_SBLOCK_LEN)
+		XFS_BTREE_SBLOCK_CRC_LEN : XFS_BTREE_SBLOCK_LEN)
 
 /*
  * Record, key, and pointer address macros for btree blocks.
diff --git a/include/xfs_attr_remote.h b/include/xfs_attr_remote.h
index d087305..92a8fd7 100644
--- a/include/xfs_attr_remote.h
+++ b/include/xfs_attr_remote.h
@@ -1,25 +1,19 @@
 /*
  * Copyright (c) 2013 Red Hat, Inc.
+ * All Rights Reserved.
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2.1 of the GNU Lesser General Public License
- * as published by the Free Software Foundation.
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
  *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- * Further, this software is distributed without any warranty that it is
- * free of the rightful claim of any third person regarding infringement
- * or the like.  Any license provided herein, whether implied or
- * otherwise, applies only to this software file.  Patent licenses, if
- * any, provided herein do not apply to combinations of this program with
- * other software, or any other product whatsoever.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307,
- * USA.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #ifndef __XFS_ATTR_REMOTE_H__
 #define	__XFS_ATTR_REMOTE_H__
diff --git a/include/xfs_bmap_btree.h b/include/xfs_bmap_btree.h
index f1069bb..1b726d6 100644
--- a/include/xfs_bmap_btree.h
+++ b/include/xfs_bmap_btree.h
@@ -140,8 +140,7 @@ typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
  */
 #define XFS_BMBT_BLOCK_LEN(mp) \
 	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-	 XFS_BTREE_LBLOCK_CRC_LEN : \
-	 XFS_BTREE_LBLOCK_LEN)
+		XFS_BTREE_LBLOCK_CRC_LEN : XFS_BTREE_LBLOCK_LEN)
 
 #define XFS_BMBT_REC_ADDR(mp, block, index) \
 	((xfs_bmbt_rec_t *) \
diff --git a/include/xfs_btree.h b/include/xfs_btree.h
index c0acbbf..b55af99 100644
--- a/include/xfs_btree.h
+++ b/include/xfs_btree.h
@@ -93,7 +93,6 @@ struct xfs_btree_block {
 #define XFS_BTREE_LBLOCK_CRC_OFF \
 	offsetof(struct xfs_btree_block, bb_u.l.bb_crc)
 
-
 /*
  * Generic key, ptr and record wrapper structures.
  *
@@ -214,7 +213,7 @@ struct xfs_btree_ops {
 
 	const struct xfs_buf_ops	*buf_ops;
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	/* check that k1 is lower than k2 */
 	int	(*keys_inorder)(struct xfs_btree_cur *cur,
 				union xfs_btree_key *k1,
diff --git a/include/xfs_dinode.h b/include/xfs_dinode.h
index f7a0e95..07d735a 100644
--- a/include/xfs_dinode.h
+++ b/include/xfs_dinode.h
@@ -132,9 +132,6 @@ typedef enum xfs_dinode_fmt {
 #define XFS_LITINO(mp, version) \
 	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
 
-#define XFS_BROOT_SIZE_ADJ(ip) \
-	(XFS_BMBT_BLOCK_LEN((ip)->i_mount) - sizeof(xfs_bmdr_block_t))
-
 /*
  * Inode data & attribute fork sizes, per inode.
  */
diff --git a/include/xfs_dir2.h b/include/xfs_dir2.h
index 75e8596..7fe2b8f 100644
--- a/include/xfs_dir2.h
+++ b/include/xfs_dir2.h
@@ -28,14 +28,6 @@ struct xfs_dir2_sf_entry;
 struct xfs_dir2_data_hdr;
 struct xfs_dir2_data_entry;
 struct xfs_dir2_data_unused;
-struct xfs_dir2_data_free;
-
-typedef uint		xfs_dir2_data_aoff_t;	/* argument form */
-
-/*
- * Directory block number (logical dirblk in file)
- */
-typedef	__uint32_t	xfs_dir2_db_t;
 
 extern struct xfs_name	xfs_name_dotdot;
 
@@ -71,7 +63,7 @@ extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
 
 /*
- * used by db
+ * Interface routines used by userspace utilities
  */
 extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
 extern void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *sfp,
@@ -110,5 +102,4 @@ extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_free_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_data_buf_ops;
 
-
 #endif	/* __XFS_DIR2_H__ */
diff --git a/include/xfs_dir2_format.h b/include/xfs_dir2_format.h
index 4126e86..2095e17 100644
--- a/include/xfs_dir2_format.h
+++ b/include/xfs_dir2_format.h
@@ -73,6 +73,7 @@
  */
 typedef	__uint16_t	xfs_dir2_data_off_t;
 #define	NULLDATAOFF	0xffffU
+typedef uint		xfs_dir2_data_aoff_t;	/* argument form */
 
 /*
  * Normalized offset (in a data block) of the entry, really xfs_dir2_data_off_t.
@@ -93,6 +94,11 @@ typedef	__uint32_t	xfs_dir2_dataptr_t;
 typedef	xfs_off_t	xfs_dir2_off_t;
 
 /*
+ * Directory block number (logical dirblk in file)
+ */
+typedef	__uint32_t	xfs_dir2_db_t;
+
+/*
  * Inode number stored as 8 8-bit values.
  */
 typedef	struct { __uint8_t i[8]; } xfs_dir2_ino8_t;
@@ -144,19 +150,19 @@ static inline int xfs_dir2_sf_hdr_size(int i8count)
 		(sizeof(xfs_dir2_ino8_t) - sizeof(xfs_dir2_ino4_t));
 }
 
-	static inline xfs_dir2_data_aoff_t
+static inline xfs_dir2_data_aoff_t
 xfs_dir2_sf_get_offset(xfs_dir2_sf_entry_t *sfep)
 {
 	return get_unaligned_be16(&sfep->offset.i);
 }
 
-	static inline void
+static inline void
 xfs_dir2_sf_put_offset(xfs_dir2_sf_entry_t *sfep, xfs_dir2_data_aoff_t off)
 {
 	put_unaligned_be16(off, &sfep->offset.i);
 }
 
-	static inline int
+static inline int
 xfs_dir2_sf_entsize(struct xfs_dir2_sf_hdr *hdr, int len)
 {
 	return sizeof(struct xfs_dir2_sf_entry) +	/* namelen + offset */
@@ -166,14 +172,14 @@ xfs_dir2_sf_entsize(struct xfs_dir2_sf_hdr *hdr, int len)
 		 sizeof(xfs_dir2_ino4_t));
 }
 
-	static inline struct xfs_dir2_sf_entry *
+static inline struct xfs_dir2_sf_entry *
 xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
 {
 	return (struct xfs_dir2_sf_entry *)
 		((char *)hdr + xfs_dir2_sf_hdr_size(hdr->i8count));
 }
 
-	static inline struct xfs_dir2_sf_entry *
+static inline struct xfs_dir2_sf_entry *
 xfs_dir2_sf_nextentry(struct xfs_dir2_sf_hdr *hdr,
 		struct xfs_dir2_sf_entry *sfep)
 {
@@ -238,7 +244,7 @@ typedef struct xfs_dir2_data_free {
  */
 typedef struct xfs_dir2_data_hdr {
 	__be32			magic;		/* XFS_DIR2_DATA_MAGIC or */
-	/* XFS_DIR2_BLOCK_MAGIC */
+						/* XFS_DIR2_BLOCK_MAGIC */
 	xfs_dir2_data_free_t	bestfree[XFS_DIR2_DATA_FD_COUNT];
 } xfs_dir2_data_hdr_t;
 
@@ -265,7 +271,7 @@ struct xfs_dir3_data_hdr {
 
 #define XFS_DIR3_DATA_CRC_OFF  offsetof(struct xfs_dir3_data_hdr, hdr.crc)
 
-	static inline struct xfs_dir2_data_free *
+static inline struct xfs_dir2_data_free *
 xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
 {
 	if (hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
@@ -514,7 +520,7 @@ struct xfs_dir3_leaf {
 #define XFS_DIR3_LEAF_CRC_OFF  offsetof(struct xfs_dir3_leaf_hdr, info.crc)
 
 extern void xfs_dir3_leaf_hdr_from_disk(struct xfs_dir3_icleaf_hdr *to,
-		struct xfs_dir2_leaf *from);
+					struct xfs_dir2_leaf *from);
 
 static inline int
 xfs_dir3_leaf_hdr_size(struct xfs_dir2_leaf *lp)
diff --git a/include/xfs_fs.h b/include/xfs_fs.h
index 44b69e7..68c2e18 100644
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -311,6 +311,17 @@ typedef struct xfs_bstat {
 } xfs_bstat_t;
 
 /*
+ * Project quota id helpers (previously projid was 16bit only
+ * and using two 16bit values to hold new 32bit projid was choosen
+ * to retain compatibility with "old" filesystems).
+ */
+static inline __uint32_t
+bstat_get_projid(struct xfs_bstat *bs)
+{
+	return (__uint32_t)bs->bs_projid_hi << 16 | bs->bs_projid_lo;
+}
+
+/*
  * The user-level BulkStat Request interface structure.
  */
 typedef struct xfs_fsop_bulkreq {
@@ -511,10 +522,14 @@ typedef struct xfs_handle {
 #define XFS_IOC_ERROR_INJECTION	     _IOW ('X', 116, struct xfs_error_injection)
 #define XFS_IOC_ERROR_CLEARALL	     _IOW ('X', 117, struct xfs_error_injection)
 /*	XFS_IOC_ATTRCTL_BY_HANDLE -- deprecated 118	 */
+
 /*	XFS_IOC_FREEZE		  -- FIFREEZE   119	 */
 /*	XFS_IOC_THAW		  -- FITHAW     120	 */
+#ifndef FIFREEZE
 #define XFS_IOC_FREEZE		     _IOWR('X', 119, int)
 #define XFS_IOC_THAW		     _IOWR('X', 120, int)
+#endif
+
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
@@ -537,15 +552,4 @@ typedef struct xfs_handle {
 #define BBTOB(bbs)	((bbs) << BBSHIFT)
 #endif
 
-/*
- * Project quota id helpers (previously projid was 16bit only
- * and using two 16bit values to hold new 32bit projid was choosen
- * to retain compatibility with "old" filesystems).
- */
-static inline __uint32_t
-bstat_get_projid(struct xfs_bstat *bs)
-{
-	return (__uint32_t)bs->bs_projid_hi << 16 | bs->bs_projid_lo;
-}
-
 #endif	/* __XFS_FS_H__ */
diff --git a/include/xfs_ialloc_btree.h b/include/xfs_ialloc_btree.h
index 7f5ae6b..3ac36b7 100644
--- a/include/xfs_ialloc_btree.h
+++ b/include/xfs_ialloc_btree.h
@@ -80,8 +80,7 @@ typedef __be32 xfs_inobt_ptr_t;
  */
 #define XFS_INOBT_BLOCK_LEN(mp) \
 	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-	 XFS_BTREE_SBLOCK_CRC_LEN : \
-	 XFS_BTREE_SBLOCK_LEN)
+		XFS_BTREE_SBLOCK_CRC_LEN : XFS_BTREE_SBLOCK_LEN)
 
 /*
  * Record, key, and pointer address macros for btree blocks.
diff --git a/include/xfs_inode_buf.h b/include/xfs_inode_buf.h
index b5f1e22..aae9fc4 100644
--- a/include/xfs_inode_buf.h
+++ b/include/xfs_inode_buf.h
@@ -40,7 +40,6 @@ int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
 void		xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
-bool		xfs_can_free_eofblocks(struct xfs_inode *, bool);
 
 #if defined(DEBUG)
 void		xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 37aca08..8e67284 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -200,7 +200,7 @@ typedef struct xfs_trans {
 	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
 	int64_t			t_frextents_delta;/* superblock freextents chg*/
 	int64_t			t_res_frextents_delta; /* on-disk only chg */
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	int64_t			t_ag_freeblks_delta; /* debugging counter */
 	int64_t			t_ag_flist_delta; /* debugging counter */
 	int64_t			t_ag_btree_delta; /* debugging counter */
@@ -228,7 +228,7 @@ typedef struct xfs_trans {
 #define	xfs_trans_get_block_res(tp)	((tp)->t_blk_res)
 #define	xfs_trans_set_sync(tp)		((tp)->t_flags |= XFS_TRANS_SYNC)
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 #define	xfs_trans_agblocks_delta(tp, d)	((tp)->t_ag_freeblks_delta += (int64_t)d)
 #define	xfs_trans_agflist_delta(tp, d)	((tp)->t_ag_flist_delta += (int64_t)d)
 #define	xfs_trans_agbtree_delta(tp, d)	((tp)->t_ag_btree_delta += (int64_t)d)
@@ -298,6 +298,7 @@ void		xfs_trans_bhold_release(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_binval(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_inode_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
@@ -327,7 +328,4 @@ extern kmem_zone_t	*xfs_log_item_desc_zone;
 
 #endif	/* __KERNEL__ */
 
-void		xfs_trans_init(struct xfs_mount *);
-int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
-
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 276fc25..0ab5f21 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -437,3 +437,5 @@ xfs_buf_t *xfs_trans_buf_item_match(xfs_trans_t *, struct xfs_buftarg *,
 /* local source files */
 int  xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
 void xfs_trans_mod_sb(xfs_trans_t *, uint, long);
+void xfs_trans_init(struct xfs_mount *);
+int  xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 17AA87FE0
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:36:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F7408F8033
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:36:51 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2cwcJgbubq7tx5Jb for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:36:48 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4O-0003B5-J8
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:36 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4E-0000EC-Er
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/50] xfsprogs: sync minor kernel header differences
Date: Wed, 19 Jun 2013 15:35:33 +1000
Message-Id: <1371620173-712-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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
 include/libxfs.h           |    8 +++++---
 include/xfs_ag.h           |    2 +-
 include/xfs_alloc_btree.h  |    3 +--
 include/xfs_attr_remote.h  |   28 +++++++++++-----------------
 include/xfs_bmap.h         |   14 ++++++--------
 include/xfs_bmap_btree.h   |    3 +--
 include/xfs_btree.h        |    3 +--
 include/xfs_buf_item.h     |    4 +++-
 include/xfs_dir2.h         |   20 ++++++++++----------
 include/xfs_dir2_format.h  |   22 ++++++++++++++--------
 include/xfs_extfree_item.h |   14 +++++++++-----
 include/xfs_fs.h           |   26 +++++++++++++++-----------
 include/xfs_ialloc_btree.h |    3 +--
 include/xfs_icreate_item.h |    1 +
 include/xfs_log.h          |    2 ++
 include/xfs_log_priv.h     |    1 -
 include/xfs_quota.h        |    2 ++
 include/xfs_symlink.h      |   20 ++++++++++++++++++++
 include/xfs_trans.h        |   21 +++++++++++++++------
 19 files changed, 118 insertions(+), 79 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index ee69cac..eeb663e 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -40,7 +40,6 @@
 #include <xfs/xfs_inum.h>
 #include <xfs/xfs_sb.h>
 #include <xfs/xfs_ag.h>
-#include <xfs/xfs_dir2.h>
 #include <xfs/xfs_da_btree.h>
 #include <xfs/xfs_bmap_btree.h>
 #include <xfs/xfs_alloc_btree.h>
@@ -233,6 +232,11 @@ extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
 extern void	libxfs_umount (xfs_mount_t *);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 
+/*
+ * xfs/xfs_dir2_format.h needs struct xfs_mount to be defined
+ */
+#include <xfs/xfs_dir2_format.h>
+#include <xfs/xfs_dir2.h>
 
 /*
  * Simple I/O interface
@@ -584,8 +588,6 @@ extern int	libxfs_iget (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
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
diff --git a/include/xfs_bmap.h b/include/xfs_bmap.h
index ffa67b1..262f760 100644
--- a/include/xfs_bmap.h
+++ b/include/xfs_bmap.h
@@ -18,7 +18,6 @@
 #ifndef __XFS_BMAP_H__
 #define	__XFS_BMAP_H__
 
-struct getbmap;
 struct xfs_bmbt_irec;
 struct xfs_ifork;
 struct xfs_inode;
@@ -135,8 +134,13 @@ typedef struct xfs_bmalloca {
 	char			userdata;/* set if is user data */
 	char			aeof;	/* allocated space at eof */
 	char			conv;	/* overwriting unwritten extents */
+	char			stack_switch;
 	int			flags;
-	int			stack_switch;
+#ifdef __KERNEL__
+	struct completion	*done;
+	struct work_struct	work;
+	int			result;
+#endif /* __KERNEL__ */
 } xfs_bmalloca_t;
 
 /*
@@ -203,19 +207,13 @@ int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 uint	xfs_default_attroffset(struct xfs_inode *ip);
 
 #ifdef __KERNEL__
-/* bmap to userspace formatter - copy to user & advance pointer */
-typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *, int *);
 
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
 		int *committed);
-int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
-		xfs_bmap_format_t formatter, void *arg);
 int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
 		int whichfork, int *eof);
 int	xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		int whichfork, int *count);
-int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
-		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
 
 xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
 
diff --git a/include/xfs_bmap_btree.h b/include/xfs_bmap_btree.h
index 20d66b0..70c43d9 100644
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
diff --git a/include/xfs_buf_item.h b/include/xfs_buf_item.h
index 2573d2a..0f1c247 100644
--- a/include/xfs_buf_item.h
+++ b/include/xfs_buf_item.h
@@ -120,6 +120,7 @@ xfs_blft_from_flags(struct xfs_buf_log_format *blf)
 #define	XFS_BLI_INODE_ALLOC_BUF	0x10
 #define XFS_BLI_STALE_INODE	0x20
 #define	XFS_BLI_INODE_BUF	0x40
+#define	XFS_BLI_ORDERED		0x80
 
 #define XFS_BLI_FLAGS \
 	{ XFS_BLI_HOLD,		"HOLD" }, \
@@ -128,7 +129,8 @@ xfs_blft_from_flags(struct xfs_buf_log_format *blf)
 	{ XFS_BLI_LOGGED,	"LOGGED" }, \
 	{ XFS_BLI_INODE_ALLOC_BUF, "INODE_ALLOC" }, \
 	{ XFS_BLI_STALE_INODE,	"STALE_INODE" }, \
-	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }
+	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }, \
+	{ XFS_BLI_ORDERED,	"ORDERED" }
 
 
 #ifdef __KERNEL__
diff --git a/include/xfs_dir2.h b/include/xfs_dir2.h
index 75e8596..4faf66e 100644
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
 
@@ -71,7 +63,16 @@ extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
 
 /*
- * used by db
+ * Direct call on directory open, before entering the readdir code.
+ */
+extern int xfs_dir3_data_readahead(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dablk_t bno, xfs_daddr_t mapped_bno);
+extern int xfs_readdir(struct xfs_inode *dp, void *dirent, size_t bufsize,
+		       xfs_off_t *offset, filldir_t filldir);
+
+
+/*
+ * Interface routines used by userspace utilities
  */
 extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
 extern void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *sfp,
@@ -110,5 +111,4 @@ extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_free_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_data_buf_ops;
 
-
 #endif	/* __XFS_DIR2_H__ */
diff --git a/include/xfs_dir2_format.h b/include/xfs_dir2_format.h
index 8c16bb0..3a73736 100644
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
 
@@ -264,7 +270,7 @@ struct xfs_dir3_data_hdr {
 
 #define XFS_DIR3_DATA_CRC_OFF  offsetof(struct xfs_dir3_data_hdr, hdr.crc)
 
-	static inline struct xfs_dir2_data_free *
+static inline struct xfs_dir2_data_free *
 xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
 {
 	if (hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
@@ -513,7 +519,7 @@ struct xfs_dir3_leaf {
 #define XFS_DIR3_LEAF_CRC_OFF  offsetof(struct xfs_dir3_leaf_hdr, info.crc)
 
 extern void xfs_dir3_leaf_hdr_from_disk(struct xfs_dir3_icleaf_hdr *to,
-		struct xfs_dir2_leaf *from);
+					struct xfs_dir2_leaf *from);
 
 static inline int
 xfs_dir3_leaf_hdr_size(struct xfs_dir2_leaf *lp)
diff --git a/include/xfs_extfree_item.h b/include/xfs_extfree_item.h
index 375f68e..4322224 100644
--- a/include/xfs_extfree_item.h
+++ b/include/xfs_extfree_item.h
@@ -114,16 +114,20 @@ typedef struct xfs_efd_log_format_64 {
  * Define EFI flag bits. Manipulated by set/clear/test_bit operators.
  */
 #define	XFS_EFI_RECOVERED	1
-#define	XFS_EFI_COMMITTED	2
 
 /*
- * This is the "extent free intention" log item.  It is used
- * to log the fact that some extents need to be free.  It is
- * used in conjunction with the "extent free done" log item
- * described below.
+ * This is the "extent free intention" log item.  It is used to log the fact
+ * that some extents need to be free.  It is used in conjunction with the
+ * "extent free done" log item described below.
+ *
+ * The EFI is reference counted so that it is not freed prior to both the EFI
+ * and EFD being committed and unpinned. This ensures that when the last
+ * reference goes away the EFI will always be in the AIL as it has been
+ * unpinned, regardless of whether the EFD is processed before or after the EFI.
  */
 typedef struct xfs_efi_log_item {
 	xfs_log_item_t		efi_item;
+	atomic_t		efi_refcount;
 	atomic_t		efi_next_extent;
 	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
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
diff --git a/include/xfs_icreate_item.h b/include/xfs_icreate_item.h
index 70dc03c..79df981 100644
--- a/include/xfs_icreate_item.h
+++ b/include/xfs_icreate_item.h
@@ -50,6 +50,7 @@ void xfs_icreate_log(struct xfs_trans *tp, xfs_agnumber_t agno,
 			xfs_agblock_t agbno, unsigned int count,
 			unsigned int inode_size, xfs_agblock_t length,
 			unsigned int generation);
+
 #endif /* __KERNEL__ */
 
 #endif	/* XFS_ICREATE_ITEM_H */
diff --git a/include/xfs_log.h b/include/xfs_log.h
index 70cc014..fb630e4 100644
--- a/include/xfs_log.h
+++ b/include/xfs_log.h
@@ -106,6 +106,8 @@ struct xfs_log_vec {
 	int			lv_buf_len;	/* size of formatted buffer */
 };
 
+#define XFS_LOG_VEC_ORDERED	(-1)
+
 /*
  * Structure used to pass callback function and the function's argument
  * to the log manager.
diff --git a/include/xfs_log_priv.h b/include/xfs_log_priv.h
index 16d8d12..b9ea262 100644
--- a/include/xfs_log_priv.h
+++ b/include/xfs_log_priv.h
@@ -468,7 +468,6 @@ struct xfs_cil {
  * threshold, yet give us plenty of space for aggregation on large logs.
  */
 #define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize >> 3)
-#define XLOG_CIL_HARD_SPACE_LIMIT(log)	(3 * (log->l_logsize >> 4))
 
 /*
  * ticket grant locks, queues and accounting have their own cachlines
diff --git a/include/xfs_quota.h b/include/xfs_quota.h
index c61e31c..c38068f 100644
--- a/include/xfs_quota.h
+++ b/include/xfs_quota.h
@@ -87,6 +87,8 @@ typedef struct xfs_dqblk {
 	uuid_t		  dd_uuid;	/* location information */
 } xfs_dqblk_t;
 
+#define XFS_DQUOT_CRC_OFF	offsetof(struct xfs_dqblk, dd_crc)
+
 /*
  * flags for q_flags field in the dquot.
  */
diff --git a/include/xfs_symlink.h b/include/xfs_symlink.h
index e85dfd1..4818edf 100644
--- a/include/xfs_symlink.h
+++ b/include/xfs_symlink.h
@@ -1,9 +1,29 @@
 /*
  * Copyright (c) 2012 Red Hat, Inc. All rights reserved.
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
  */
 #ifndef __XFS_SYMLINK_H
 #define __XFS_SYMLINK_H 1
 
+struct xfs_mount;
+struct xfs_trans;
+struct xfs_inode;
+struct xfs_buf;
+struct xfs_ifork;
+struct xfs_name;
+
 #define XFS_SYMLINK_MAGIC	0x58534c4d	/* XSLM */
 
 struct xfs_dsymlink_hdr {
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 78074f3..c9019c6 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -209,6 +209,9 @@ struct xfs_log_item_desc {
 #define	XFS_TRANS_SB_REXTENTS		0x00001000
 #define	XFS_TRANS_SB_REXTSLOG		0x00002000
 
+/*
+ * structure for maintaining pre-calculated transaction reservations.
+ */
 struct xfs_trans_reservations {
 	uint	tr_write;	/* extent alloc trans */
 	uint	tr_itruncate;	/* truncate trans */
@@ -225,8 +228,8 @@ struct xfs_trans_reservations {
 	uint	tr_addafork;	/* cvt inode to attributed trans */
 	uint	tr_writeid;	/* write setuid/setgid file */
 	uint	tr_attrinval;	/* attr fork buffer invalidation */
-	uint	tr_attrsetm;    /* set/create an attribute at mount time */
-	uint	tr_attrsetrt;   /* set/create an attribute at runtime */
+	uint	tr_attrsetm;	/* set/create an attribute at mount time */
+	uint	tr_attrsetrt;	/* set/create an attribute at runtime */
 	uint	tr_attrrm;	/* remove an attribute */
 	uint	tr_clearagi;	/* clear bad agi unlinked ino bucket */
 	uint	tr_growrtalloc;	/* grow realtime allocations */
@@ -285,14 +288,19 @@ struct xfs_trans_reservations {
  * as long as SWRITE logs the entire inode core
  */
 #define XFS_FSYNC_TS_LOG_RES(mp)        ((mp)->m_reservations.tr_swrite)
-#define	XFS_WRITEID_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
+#define	XFS_WRITEID_LOG_RES(mp)		((mp)->m_reservations.tr_swrite)
 #define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
 #define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
 #define	XFS_ATTRSETM_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetm)
 #define	XFS_ATTRSETRT_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetrt)
 #define	XFS_ATTRRM_LOG_RES(mp)		((mp)->m_reservations.tr_attrrm)
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
-
+#define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange)
+#define XFS_QM_SETQLIM_LOG_RES(mp)	((mp)->m_reservations.tr_qm_setqlim)
+#define XFS_QM_DQALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_qm_dqalloc)
+#define XFS_QM_QUOTAOFF_LOG_RES(mp)	((mp)->m_reservations.tr_qm_quotaoff)
+#define XFS_QM_QUOTAOFF_END_LOG_RES(mp)	((mp)->m_reservations.tr_qm_equotaoff)
+#define XFS_SB_LOG_RES(mp)		((mp)->m_reservations.tr_sb)
 
 /*
  * Various log count values.
@@ -433,7 +441,7 @@ typedef struct xfs_trans {
 	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
 	int64_t			t_frextents_delta;/* superblock freextents chg*/
 	int64_t			t_res_frextents_delta; /* on-disk only chg */
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	int64_t			t_ag_freeblks_delta; /* debugging counter */
 	int64_t			t_ag_flist_delta; /* debugging counter */
 	int64_t			t_ag_btree_delta; /* debugging counter */
@@ -461,7 +469,7 @@ typedef struct xfs_trans {
 #define	xfs_trans_get_block_res(tp)	((tp)->t_blk_res)
 #define	xfs_trans_set_sync(tp)		((tp)->t_flags |= XFS_TRANS_SYNC)
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 #define	xfs_trans_agblocks_delta(tp, d)	((tp)->t_ag_freeblks_delta += (int64_t)d)
 #define	xfs_trans_agflist_delta(tp, d)	((tp)->t_ag_flist_delta += (int64_t)d)
 #define	xfs_trans_agbtree_delta(tp, d)	((tp)->t_ag_btree_delta += (int64_t)d)
@@ -531,6 +539,7 @@ void		xfs_trans_bhold_release(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_binval(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_inode_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

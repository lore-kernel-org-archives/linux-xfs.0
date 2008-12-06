Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB6J84uv003765 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 13:08:04 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 968801670BB0
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 11:08:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XuAEtrmqjdGz83FP for
	<xfs@oss.sgi.com>; Sat, 06 Dec 2008 11:08:03 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L92VW-0006cZ-RI
	for xfs@oss.sgi.com; Sat, 06 Dec 2008 19:08:02 +0000
Date: Sat, 6 Dec 2008 14:08:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: resync xfs with the kernel code
Message-ID: <20081206190802.GA18831@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Also use the kernel xfs_iread now instead of a duplicated version.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/xfsprogs/include/xfs_ag.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_ag.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_ag.h	2008-12-06 20:05:49.000000000 +0100
@@ -91,6 +91,8 @@
 #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
 #define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)XFS_BUF_PTR(bp))
 
+extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
+			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
 
 /*
  * Size of the unlinked inode hash table in the agi.
@@ -142,6 +144,9 @@
 #define	XFS_AGI_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGI_DADDR(mp))
 #define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)XFS_BUF_PTR(bp))
 
+extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
+				xfs_agnumber_t agno, struct xfs_buf **bpp);
+
 /*
  * The third a.g. block contains the a.g. freelist, an array
  * of block pointers to blocks owned by the allocation btree code.
@@ -204,6 +209,11 @@
 #endif
 } xfs_perag_t;
 
+/*
+ * tags for inode radix tree
+ */
+#define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
+
 #define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
 #define	XFS_MIN_FREELIST_RAW(bl,cl,mp)	\
 	(MIN(bl + 1, XFS_AG_MAXLEVELS(mp)) + MIN(cl + 1, XFS_AG_MAXLEVELS(mp)))
Index: xfs-cmds/xfsprogs/include/xfs_bmap.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_bmap.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_bmap.h	2008-12-06 20:05:49.000000000 +0100
@@ -356,15 +356,18 @@
 	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
 	int			*committed);	/* xact committed or not */
 
+/* bmap to userspace formatter - copy to user & advance pointer */
+typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *, int *);
+
 /*
- * Fcntl interface to xfs_bmapi.
+ * Get inode's extents as described in bmv, and format for output.
  */
 int						/* error code */
 xfs_getbmap(
 	xfs_inode_t		*ip,
-	struct getbmap		*bmv,		/* user bmap structure */
-	void			__user *ap,	/* pointer to user's array */
-	int			iflags);	/* interface flags */
+	struct getbmapx		*bmv,		/* user bmap structure */
+	xfs_bmap_format_t	formatter,	/* format to user */
+	void			*arg);		/* formatter arg */
 
 /*
  * Check if the endoff is outside the last extent. If so the caller will grow
Index: xfs-cmds/xfsprogs/include/xfs_dfrag.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_dfrag.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_dfrag.h	2008-12-06 20:05:49.000000000 +0100
@@ -46,7 +46,7 @@
 /*
  * Syscall interface for xfs_swapext
  */
-int	xfs_swapext(struct xfs_swapext __user *sx);
+int	xfs_swapext(struct xfs_swapext *sx);
 
 int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
 		struct xfs_swapext *sxp);
Index: xfs-cmds/xfsprogs/include/xfs_dinode.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_dinode.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_dinode.h	2008-12-06 20:05:49.000000000 +0100
@@ -18,32 +18,29 @@
 #ifndef __XFS_DINODE_H__
 #define	__XFS_DINODE_H__
 
-struct xfs_buf;
-struct xfs_mount;
+#define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
+#define XFS_DINODE_GOOD_VERSION(v)	(((v) == 1 || (v) == 2))
 
-#define	XFS_DINODE_VERSION_1	1
-#define	XFS_DINODE_VERSION_2	2
-#define XFS_DINODE_GOOD_VERSION(v)	\
-	(((v) == XFS_DINODE_VERSION_1 || (v) == XFS_DINODE_VERSION_2))
-#define	XFS_DINODE_MAGIC	0x494e	/* 'IN' */
-
-/*
- * Disk inode structure.
- * This is just the header; the inode is expanded to fill a variable size
- * with the last field expanding.  It is split into the core and "other"
- * because we only need the core part in the in-core inode.
- */
 typedef struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
 	__be32		t_nsec;		/* timestamp nanoseconds */
 } xfs_timestamp_t;
 
 /*
- * Note: Coordinate changes to this structure with the XFS_DI_* #defines
- * below, the offsets table in xfs_ialloc_log_di() and struct xfs_icdinode
- * in xfs_inode.h.
+ * On-disk inode structure.
+ *
+ * This is just the header or "dinode core", the inode is expanded to fill a
+ * variable size the leftover area split into a data and an attribute fork.
+ * The format of the data and attribute fork depends on the format of the
+ * inode as indicated by di_format and di_aformat.  To access the data and
+ * attribute use the XFS_DFORK_PTR, XFS_DFORK_DPTR, and XFS_DFORK_PTR macros
+ * below.
+ *
+ * There is a very similar struct icdinode in xfs_inode which matches the
+ * layout of the first 96 bytes of this structure, but is kept in native
+ * format instead of big endian.
  */
-typedef struct xfs_dinode_core {
+typedef struct xfs_dinode {
 	__be16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
 	__be16		di_mode;	/* mode and type of file */
 	__u8		di_version;	/* inode version */
@@ -69,33 +66,12 @@
 	__be16		di_dmstate;	/* DMIG state info */
 	__be16		di_flags;	/* random flags, XFS_DIFLAG_... */
 	__be32		di_gen;		/* generation number */
-} xfs_dinode_core_t;
 
-#define DI_MAX_FLUSH 0xffff
+	/* di_next_unlinked is the only non-core field in the old dinode */
+	__be32		di_next_unlinked;/* agi unlinked list ptr */
+} __attribute__((packed)) xfs_dinode_t;
 
-typedef struct xfs_dinode
-{
-	xfs_dinode_core_t	di_core;
-	/*
-	 * In adding anything between the core and the union, be
-	 * sure to update the macros like XFS_LITINO below.
-	 */
-	__be32			di_next_unlinked;/* agi unlinked list ptr */
-	union {
-		xfs_bmdr_block_t di_bmbt;	/* btree root block */
-		xfs_bmbt_rec_32_t di_bmx[1];	/* extent list */
-		xfs_dir2_sf_t	di_dir2sf;	/* shortform directory v2 */
-		char		di_c[1];	/* local contents */
-		__be32		di_dev;		/* device for S_IFCHR/S_IFBLK */
-		uuid_t		di_muuid;	/* mount point value */
-		char		di_symlink[1];	/* local symbolic link */
-	}		di_u;
-	union {
-		xfs_bmdr_block_t di_abmbt;	/* btree root block */
-		xfs_bmbt_rec_32_t di_abmx[1];	/* extent list */
-		xfs_attr_shortform_t di_attrsf;	/* shortform attribute list */
-	}		di_a;
-} xfs_dinode_t;
+#define DI_MAX_FLUSH 0xffff
 
 /*
  * The 32 bit link count in the inode theoretically maxes out at UINT_MAX.
@@ -106,50 +82,14 @@
 #define	XFS_MAXLINK_1		65535U
 
 /*
- * Bit names for logging disk inodes only
- */
-#define	XFS_DI_MAGIC		0x0000001
-#define	XFS_DI_MODE		0x0000002
-#define	XFS_DI_VERSION		0x0000004
-#define	XFS_DI_FORMAT		0x0000008
-#define	XFS_DI_ONLINK		0x0000010
-#define	XFS_DI_UID		0x0000020
-#define	XFS_DI_GID		0x0000040
-#define	XFS_DI_NLINK		0x0000080
-#define	XFS_DI_PROJID		0x0000100
-#define	XFS_DI_PAD		0x0000200
-#define	XFS_DI_ATIME		0x0000400
-#define	XFS_DI_MTIME		0x0000800
-#define	XFS_DI_CTIME		0x0001000
-#define	XFS_DI_SIZE		0x0002000
-#define	XFS_DI_NBLOCKS		0x0004000
-#define	XFS_DI_EXTSIZE		0x0008000
-#define	XFS_DI_NEXTENTS		0x0010000
-#define	XFS_DI_NAEXTENTS	0x0020000
-#define	XFS_DI_FORKOFF		0x0040000
-#define	XFS_DI_AFORMAT		0x0080000
-#define	XFS_DI_DMEVMASK		0x0100000
-#define	XFS_DI_DMSTATE		0x0200000
-#define	XFS_DI_FLAGS		0x0400000
-#define	XFS_DI_GEN		0x0800000
-#define	XFS_DI_NEXT_UNLINKED	0x1000000
-#define	XFS_DI_U		0x2000000
-#define	XFS_DI_A		0x4000000
-#define	XFS_DI_NUM_BITS		27
-#define	XFS_DI_ALL_BITS		((1 << XFS_DI_NUM_BITS) - 1)
-#define	XFS_DI_CORE_BITS	(XFS_DI_ALL_BITS & ~(XFS_DI_U|XFS_DI_A))
-
-/*
  * Values for di_format
  */
-typedef enum xfs_dinode_fmt
-{
-	XFS_DINODE_FMT_DEV,		/* CHR, BLK: di_dev */
-	XFS_DINODE_FMT_LOCAL,		/* DIR, REG: di_c */
-					/* LNK: di_symlink */
-	XFS_DINODE_FMT_EXTENTS,		/* DIR, REG, LNK: di_bmx */
-	XFS_DINODE_FMT_BTREE,		/* DIR, REG, LNK: di_bmbt */
-	XFS_DINODE_FMT_UUID		/* MNT: di_uuid */
+typedef enum xfs_dinode_fmt {
+	XFS_DINODE_FMT_DEV,		/* xfs_dev_t */
+	XFS_DINODE_FMT_LOCAL,		/* bulk data */
+	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
+	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
+	XFS_DINODE_FMT_UUID		/* uuid_t */
 } xfs_dinode_fmt_t;
 
 /*
@@ -170,8 +110,8 @@
 /*
  * Inode data & attribute fork sizes, per inode.
  */
-#define XFS_DFORK_Q(dip)		((dip)->di_core.di_forkoff != 0)
-#define XFS_DFORK_BOFF(dip)		((int)((dip)->di_core.di_forkoff << 3))
+#define XFS_DFORK_Q(dip)		((dip)->di_forkoff != 0)
+#define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
 
 #define XFS_DFORK_DSIZE(dip,mp) \
 	(XFS_DFORK_Q(dip) ? \
@@ -186,23 +126,42 @@
 		XFS_DFORK_DSIZE(dip, mp) : \
 		XFS_DFORK_ASIZE(dip, mp))
 
-#define XFS_DFORK_DPTR(dip)		    ((dip)->di_u.di_c)
+/*
+ * Return pointers to the data or attribute forks.
+ */
+#define XFS_DFORK_DPTR(dip) \
+	((char *)(dip) + sizeof(struct xfs_dinode))
 #define XFS_DFORK_APTR(dip)	\
-	((dip)->di_u.di_c + XFS_DFORK_BOFF(dip))
+	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
 #define XFS_DFORK_PTR(dip,w)	\
 	((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : XFS_DFORK_APTR(dip))
+
 #define XFS_DFORK_FORMAT(dip,w) \
 	((w) == XFS_DATA_FORK ? \
-		(dip)->di_core.di_format : \
-		(dip)->di_core.di_aformat)
+		(dip)->di_format : \
+		(dip)->di_aformat)
 #define XFS_DFORK_NEXTENTS(dip,w) \
 	((w) == XFS_DATA_FORK ? \
-	 	be32_to_cpu((dip)->di_core.di_nextents) : \
-	 	be16_to_cpu((dip)->di_core.di_anextents))
+		be32_to_cpu((dip)->di_nextents) : \
+		be16_to_cpu((dip)->di_anextents))
 
 #define	XFS_BUF_TO_DINODE(bp)	((xfs_dinode_t *)XFS_BUF_PTR(bp))
 
 /*
+ * For block and character special files the 32bit dev_t is stored at the
+ * beginning of the data fork.
+ */
+static inline xfs_dev_t xfs_dinode_get_rdev(struct xfs_dinode *dip)
+{
+	return be32_to_cpu(*(__be32 *)XFS_DFORK_DPTR(dip));
+}
+
+static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
+{
+	*(__be32 *)XFS_DFORK_DPTR(dip) = cpu_to_be32(rdev);
+}
+
+/*
  * Values for di_flags
  * There should be a one-to-one correspondence between these flags and the
  * XFS_XFLAG_s.
Index: xfs-cmds/xfsprogs/include/xfs_dir2_sf.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_dir2_sf.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_dir2_sf.h	2008-12-06 20:05:49.000000000 +0100
@@ -34,13 +34,6 @@
 struct xfs_trans;
 
 /*
- * Maximum size of a shortform directory.
- */
-#define	XFS_DIR2_SF_MAX_SIZE	\
-	(XFS_DINODE_MAX_SIZE - (uint)sizeof(xfs_dinode_core_t) - \
-	 (uint)sizeof(xfs_agino_t))
-
-/*
  * Inode number stored as 8 8-bit values.
  */
 typedef	struct { __uint8_t i[8]; } xfs_dir2_ino8_t;
Index: xfs-cmds/xfsprogs/include/xfs_fs.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_fs.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_fs.h	2008-12-06 20:05:49.000000000 +0100
@@ -113,22 +113,14 @@
 #define BMV_IF_ATTRFORK		0x1	/* return attr fork rather than data */
 #define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
 #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
-#define BMV_IF_VALID	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC)
-#ifdef __KERNEL__
-#define BMV_IF_EXTENDED 0x40000000	/* getpmapx if set */
-#endif
+#define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
+#define BMV_IF_VALID	\
+	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|BMV_IF_DELALLOC)
 
 /*	bmv_oflags values - returned for for each non-header segment */
 #define BMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
-
-/*	Convert getbmap <-> getbmapx - move fields from p1 to p2. */
-#define GETBMAP_CONVERT(p1,p2) {	\
-	p2.bmv_offset = p1.bmv_offset;	\
-	p2.bmv_block = p1.bmv_block;	\
-	p2.bmv_length = p1.bmv_length;	\
-	p2.bmv_count = p1.bmv_count;	\
-	p2.bmv_entries = p1.bmv_entries;  }
-
+#define BMV_OF_DELALLOC		0x2	/* segment = delayed allocation */
+#define BMV_OF_LAST		0x4	/* segment is the last in the file */
 
 /*
  * Structure for XFS_IOC_FSSETDM.
@@ -426,10 +418,6 @@
 #define XFS_IOC_GETXFLAGS	FS_IOC_GETFLAGS
 #define XFS_IOC_SETXFLAGS	FS_IOC_SETFLAGS
 #define XFS_IOC_GETVERSION	FS_IOC_GETVERSION
-/* 32-bit compat counterparts */
-#define XFS_IOC32_GETXFLAGS	FS_IOC32_GETFLAGS
-#define XFS_IOC32_SETXFLAGS	FS_IOC32_SETFLAGS
-#define XFS_IOC32_GETVERSION	FS_IOC32_GETVERSION
 
 /*
  * ioctl commands that replace IRIX fcntl()'s
Index: xfs-cmds/xfsprogs/include/xfs_ialloc.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_ialloc.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_ialloc.h	2008-12-06 20:05:49.000000000 +0100
@@ -20,6 +20,7 @@
 
 struct xfs_buf;
 struct xfs_dinode;
+struct xfs_imap;
 struct xfs_mount;
 struct xfs_trans;
 
@@ -104,17 +105,14 @@
 	xfs_ino_t	*first_ino);	/* first inode in deleted cluster */
 
 /*
- * Return the location of the inode in bno/len/off,
- * for mapping it into a buffer.
+ * Return the location of the inode in imap, for mapping it into a buffer.
  */
 int
-xfs_dilocate(
+xfs_imap(
 	struct xfs_mount *mp,		/* file system mount structure */
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	ino,		/* inode to locate */
-	xfs_fsblock_t	*bno,		/* output: block containing inode */
-	int		*len,		/* output: num blocks in cluster*/
-	int		*off,		/* output: index in block of inode */
+	struct xfs_imap	*imap,		/* location map structure */
 	uint		flags);		/* flags for inode btree lookup */
 
 /*
Index: xfs-cmds/xfsprogs/include/xfs_inode.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_inode.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_inode.h	2008-12-06 20:05:49.000000000 +0100
@@ -19,7 +19,6 @@
 #define	__XFS_INODE_H__
 
 struct xfs_dinode;
-struct xfs_dinode_core;
 struct xfs_inode;
 
 /*
@@ -84,6 +83,16 @@
 } xfs_ifork_t;
 
 /*
+ * Inode location information.  Stored in the inode and passed to
+ * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
+ */
+struct xfs_imap {
+	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
+	ushort		im_len;		/* length in BBs of inode chunk */
+	ushort		im_boffset;	/* inode offset in block in bytes */
+};
+
+/*
  * This is the xfs in-core inode structure.
  * Most of the on-disk inode is embedded in the i_d field.
  *
@@ -112,7 +121,7 @@
 } xfs_ictimestamp_t;
 
 /*
- * NOTE:  This structure must be kept identical to struct xfs_dinode_core
+ * NOTE:  This structure must be kept identical to struct xfs_dinode
  * 	  in xfs_dinode.h except for the endianess annotations.
  */
 typedef struct xfs_icdinode {
@@ -158,12 +167,6 @@
 #define	XFS_IFEXTIREC	0x08	/* Indirection array of extent blocks */
 
 /*
- * Flags for xfs_itobp(), xfs_imap() and xfs_dilocate().
- */
-#define XFS_IMAP_LOOKUP		0x1
-#define XFS_IMAP_BULKSTAT	0x2
-
-/*
  * Fork handling.
  */
 
@@ -232,27 +235,15 @@
 	__uint16_t	da_pad;		/* DMIG extra padding */
 } dm_attrs_t;
 
-typedef struct {
-	struct xfs_inode	*ip_mnext;	/* next inode in mount list */
-	struct xfs_inode	*ip_mprev;	/* ptr to prev inode */
-	struct xfs_mount	*ip_mount;	/* fs mount struct ptr */
-} xfs_iptr_t;
-
 typedef struct xfs_inode {
 	/* Inode linking and identification information. */
-	struct xfs_inode	*i_mnext;	/* next inode in mount list */
-	struct xfs_inode	*i_mprev;	/* ptr to prev inode */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
-	struct list_head	i_reclaim;	/* reclaim list */
-	struct inode		*i_vnode;	/* vnode backpointer */
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
 
 	/* Inode location stuff */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
-	xfs_daddr_t		i_blkno;	/* blkno of inode buffer */
-	ushort			i_len;		/* len of inode buffer */
-	ushort			i_boffset;	/* off of inode in buffer */
+	struct xfs_imap		i_imap;		/* location for xfs_imap() */
 
 	/* Extent information. */
 	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
@@ -271,7 +262,6 @@
 	unsigned short		i_flags;	/* see defined flags below */
 	unsigned char		i_update_core;	/* timestamps/size is dirty */
 	unsigned char		i_update_size;	/* di_size field is dirty */
-	unsigned int		i_gen;		/* generation count */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
@@ -279,6 +269,10 @@
 	xfs_fsize_t		i_size;		/* in-memory size */
 	xfs_fsize_t		i_new_size;	/* size when write completes */
 	atomic_t		i_iocount;	/* outstanding I/O count */
+
+	/* VFS inode */
+	struct inode		i_vnode;	/* embedded VFS inode */
+
 	/* Trace buffers per inode. */
 #ifdef XFS_INODE_TRACE
 	struct ktrace		*i_trace;	/* general inode trace */
@@ -306,13 +300,30 @@
 /* Convert from vfs inode to xfs inode */
 static inline struct xfs_inode *XFS_I(struct inode *inode)
 {
-	return (struct xfs_inode *)inode->i_private;
+	return container_of(inode, struct xfs_inode, i_vnode);
 }
 
 /* convert from xfs inode to vfs inode */
 static inline struct inode *VFS_I(struct xfs_inode *ip)
 {
-	return (struct inode *)ip->i_vnode;
+	return &ip->i_vnode;
+}
+
+/*
+ * Get rid of a partially initialized inode.
+ *
+ * We have to go through destroy_inode to make sure allocations
+ * from init_inode_always like the security data are undone.
+ *
+ * We mark the inode bad so that it takes the short cut in
+ * the reclaim path instead of going through the flush path
+ * which doesn't make sense for an inode that has never seen the
+ * light of day.
+ */
+static inline void xfs_destroy_inode(struct xfs_inode *ip)
+{
+	make_bad_inode(VFS_I(ip));
+	return destroy_inode(VFS_I(ip));
 }
 
 /*
@@ -392,17 +403,12 @@
 /*
  * In-core inode flags.
  */
-#define XFS_IGRIO	0x0001  /* inode used for guaranteed rate i/o */
-#define XFS_IUIOSZ	0x0002  /* inode i/o sizes have been explicitly set */
-#define XFS_IQUIESCE    0x0004  /* we have started quiescing for this inode */
-#define XFS_IRECLAIM    0x0008  /* we have started reclaiming this inode    */
-#define XFS_ISTALE	0x0010	/* inode has been staled */
-#define XFS_IRECLAIMABLE 0x0020 /* inode can be reclaimed */
-#define XFS_INEW	0x0040
-#define XFS_IFILESTREAM	0x0080	/* inode is in a filestream directory */
-#define XFS_IMODIFIED	0x0100	/* XFS inode state possibly differs */
-				/* to the Linux inode state. */
-#define XFS_ITRUNCATED	0x0200	/* truncated down so flush-on-close */
+#define XFS_IRECLAIM    0x0001  /* we have started reclaiming this inode    */
+#define XFS_ISTALE	0x0002	/* inode has been staled */
+#define XFS_IRECLAIMABLE 0x0004 /* inode can be reclaimed */
+#define XFS_INEW	0x0008	/* inode has just been allocated */
+#define XFS_IFILESTREAM	0x0010	/* inode is in a filestream directory */
+#define XFS_ITRUNCATED	0x0020	/* truncated down so flush-on-close */
 
 /*
  * Flags for inode locking.
@@ -477,16 +483,8 @@
 	 ((pip)->i_d.di_mode & S_ISGID))
 
 /*
- * Flags for xfs_iget()
- */
-#define XFS_IGET_CREATE		0x1
-#define XFS_IGET_BULKSTAT	0x2
-
-/*
  * xfs_iget.c prototypes.
  */
-void		xfs_ihash_init(struct xfs_mount *);
-void		xfs_ihash_free(struct xfs_mount *);
 xfs_inode_t	*xfs_inode_incore(struct xfs_mount *, xfs_ino_t,
 				  struct xfs_trans *);
 int		xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
@@ -501,14 +499,10 @@
 uint		xfs_ilock_map_shared(xfs_inode_t *);
 void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
 void		xfs_ireclaim(xfs_inode_t *);
-int		xfs_finish_reclaim(xfs_inode_t *, int, int);
-int		xfs_finish_reclaim_all(struct xfs_mount *, int);
 
 /*
  * xfs_inode.c prototypes.
  */
-int		xfs_iread(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-			  xfs_inode_t **, xfs_daddr_t, uint);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, mode_t,
 			   xfs_nlink_t, xfs_dev_t, struct cred *, xfs_prid_t,
 			   int, struct xfs_buf **, boolean_t *, xfs_inode_t **);
@@ -522,14 +516,10 @@
 				     xfs_fsize_t, int, int);
 int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
 
-struct xfs_inode * xfs_inode_alloc(struct xfs_mount *, xfs_ino_t);
-void		xfs_idestroy(xfs_inode_t *);
-void		xfs_iextract(xfs_inode_t *);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 void		xfs_ipin(xfs_inode_t *);
 void		xfs_iunpin(xfs_inode_t *);
 int		xfs_iflush(xfs_inode_t *, uint);
-void		xfs_iflush_all(struct xfs_mount *);
 void		xfs_ichgtime(xfs_inode_t *, int);
 xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
@@ -538,14 +528,70 @@
 void		xfs_synchronize_atime(xfs_inode_t *);
 void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
+#if defined(XFS_INODE_TRACE)
+
+#define	INODE_TRACE_SIZE	16		/* number of trace entries */
+#define	INODE_KTRACE_ENTRY	1
+#define	INODE_KTRACE_EXIT	2
+#define	INODE_KTRACE_HOLD	3
+#define	INODE_KTRACE_REF	4
+#define	INODE_KTRACE_RELE	5
+
+extern void _xfs_itrace_entry(struct xfs_inode *, const char *, inst_t *);
+extern void _xfs_itrace_exit(struct xfs_inode *, const char *, inst_t *);
+extern void xfs_itrace_hold(struct xfs_inode *, char *, int, inst_t *);
+extern void _xfs_itrace_ref(struct xfs_inode *, char *, int, inst_t *);
+extern void xfs_itrace_rele(struct xfs_inode *, char *, int, inst_t *);
+#define xfs_itrace_entry(ip)	\
+	_xfs_itrace_entry(ip, __func__, (inst_t *)__return_address)
+#define xfs_itrace_exit(ip)	\
+	_xfs_itrace_exit(ip, __func__, (inst_t *)__return_address)
+#define xfs_itrace_exit_tag(ip, tag)	\
+	_xfs_itrace_exit(ip, tag, (inst_t *)__return_address)
+#define xfs_itrace_ref(ip)	\
+	_xfs_itrace_ref(ip, __FILE__, __LINE__, (inst_t *)__return_address)
+
+#else
+#define	xfs_itrace_entry(a)
+#define	xfs_itrace_exit(a)
+#define	xfs_itrace_exit_tag(a, b)
+#define	xfs_itrace_hold(a, b, c, d)
+#define	xfs_itrace_ref(a)
+#define	xfs_itrace_rele(a, b, c, d)
+#endif
+
+#define IHOLD(ip) \
+do { \
+	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
+	atomic_inc(&(VFS_I(ip)->i_count)); \
+	xfs_itrace_hold((ip), __FILE__, __LINE__, (inst_t *)__return_address); \
+} while (0)
+
+#define IRELE(ip) \
+do { \
+	xfs_itrace_rele((ip), __FILE__, __LINE__, (inst_t *)__return_address); \
+	iput(VFS_I(ip)); \
+} while (0)
+
 #endif /* __KERNEL__ */
 
+/*
+ * Flags for xfs_iget()
+ */
+#define XFS_IGET_CREATE		0x1
+#define XFS_IGET_BULKSTAT	0x2
+
+int		xfs_inotobp(struct xfs_mount *, struct xfs_trans *,
+			    xfs_ino_t, struct xfs_dinode **,
+			    struct xfs_buf **, int *, uint);
 int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, struct xfs_dinode **,
-			  struct xfs_buf **, xfs_daddr_t, uint, uint);
+			  struct xfs_buf **, uint);
+int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
+			  struct xfs_inode *, xfs_daddr_t, uint);
 void		xfs_dinode_from_disk(struct xfs_icdinode *,
-				     struct xfs_dinode_core *);
-void		xfs_dinode_to_disk(struct xfs_dinode_core *,
+				     struct xfs_dinode *);
+void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
 void		xfs_idata_realloc(struct xfs_inode *, int, int);
Index: xfs-cmds/xfsprogs/include/xfs_log.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_log.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_log.h	2008-12-06 20:05:49.000000000 +0100
@@ -134,6 +134,7 @@
 #ifdef __KERNEL__
 /* Log manager interfaces */
 struct xfs_mount;
+struct xlog_ticket;
 xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
 		       xfs_log_ticket_t ticket,
 		       void		**iclog,
@@ -177,6 +178,9 @@
 
 void	  xlog_iodone(struct xfs_buf *);
 
+struct xlog_ticket * xfs_log_ticket_get(struct xlog_ticket *ticket);
+void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
+
 #endif
 
 
Index: xfs-cmds/xfsprogs/include/xfs_log_priv.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_log_priv.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_log_priv.h	2008-12-06 20:05:49.000000000 +0100
@@ -245,6 +245,7 @@
 	struct xlog_ticket *t_next;	 /*			         :4|8 */
 	struct xlog_ticket *t_prev;	 /*				 :4|8 */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
+	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
 	int		   t_curr_res;	 /* current reservation in bytes : 4  */
 	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
 	char		   t_ocnt;	 /* original count		 : 1  */
@@ -309,6 +310,16 @@
 } xlog_rec_ext_header_t;
 
 #ifdef __KERNEL__
+
+/*
+ * Quite misnamed, because this union lays out the actual on-disk log buffer.
+ */
+typedef union xlog_in_core2 {
+	xlog_rec_header_t	hic_header;
+	xlog_rec_ext_header_t	hic_xheader;
+	char			hic_sector[XLOG_HEADER_SIZE];
+} xlog_in_core_2_t;
+
 /*
  * - A log record header is 512 bytes.  There is plenty of room to grow the
  *	xlog_rec_header_t into the reserved space.
@@ -338,7 +349,7 @@
  * We'll put all the read-only and l_icloglock fields in the first cacheline,
  * and move everything else out to subsequent cachelines.
  */
-typedef struct xlog_iclog_fields {
+typedef struct xlog_in_core {
 	sv_t			ic_force_wait;
 	sv_t			ic_write_wait;
 	struct xlog_in_core	*ic_next;
@@ -361,41 +372,11 @@
 
 	/* reference counts need their own cacheline */
 	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
-} xlog_iclog_fields_t;
-
-typedef union xlog_in_core2 {
-	xlog_rec_header_t	hic_header;
-	xlog_rec_ext_header_t	hic_xheader;
-	char			hic_sector[XLOG_HEADER_SIZE];
-} xlog_in_core_2_t;
-
-typedef struct xlog_in_core {
-	xlog_iclog_fields_t	hic_fields;
-	xlog_in_core_2_t	*hic_data;
+	xlog_in_core_2_t	*ic_data;
+#define ic_header	ic_data->hic_header
 } xlog_in_core_t;
 
 /*
- * Defines to save our code from this glop.
- */
-#define	ic_force_wait	hic_fields.ic_force_wait
-#define ic_write_wait	hic_fields.ic_write_wait
-#define	ic_next		hic_fields.ic_next
-#define	ic_prev		hic_fields.ic_prev
-#define	ic_bp		hic_fields.ic_bp
-#define	ic_log		hic_fields.ic_log
-#define	ic_callback	hic_fields.ic_callback
-#define	ic_callback_lock hic_fields.ic_callback_lock
-#define	ic_callback_tail hic_fields.ic_callback_tail
-#define	ic_trace	hic_fields.ic_trace
-#define	ic_size		hic_fields.ic_size
-#define	ic_offset	hic_fields.ic_offset
-#define	ic_refcnt	hic_fields.ic_refcnt
-#define	ic_bwritecnt	hic_fields.ic_bwritecnt
-#define	ic_state	hic_fields.ic_state
-#define ic_datap	hic_fields.ic_datap
-#define ic_header	hic_data->hic_header
-
-/*
  * The reservation head lsn is not made up of a cycle number and block number.
  * Instead, it uses a cycle number and byte number.  Logs don't expect to
  * overflow 31 bits worth of byte offset, so using a byte number will mean
@@ -404,6 +385,7 @@
 typedef struct log {
 	/* The following fields don't need locking */
 	struct xfs_mount	*l_mp;	        /* mount point */
+	struct xfs_ail		*l_ailp;	/* AIL log is working with */
 	struct xfs_buf		*l_xbuf;        /* extra buffer for log
 						 * wrapping */
 	struct xfs_buftarg	*l_targ;        /* buftarg of log */
Index: xfs-cmds/xfsprogs/include/xfs_mount.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_mount.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_mount.h	2008-12-06 20:05:49.000000000 +0100
@@ -18,7 +18,6 @@
 #ifndef __XFS_MOUNT_H__
 #define	__XFS_MOUNT_H__
 
-
 typedef struct xfs_trans_reservations {
 	uint	tr_write;	/* extent alloc trans */
 	uint	tr_itruncate;	/* truncate trans */
@@ -52,6 +51,8 @@
 
 #else /* __KERNEL__ */
 
+#include "xfs_sync.h"
+
 struct cred;
 struct log;
 struct xfs_mount_args;
@@ -62,6 +63,7 @@
 struct xfs_swapext;
 struct xfs_mru_cache;
 struct xfs_nameops;
+struct xfs_ail;
 
 /*
  * Prototypes and functions for the Data Migration subsystem.
@@ -115,7 +117,7 @@
 
 typedef int	(*xfs_qminit_t)(struct xfs_mount *, uint *, uint *);
 typedef int	(*xfs_qmmount_t)(struct xfs_mount *, uint, uint);
-typedef int	(*xfs_qmunmount_t)(struct xfs_mount *);
+typedef void	(*xfs_qmunmount_t)(struct xfs_mount *);
 typedef void	(*xfs_qmdone_t)(struct xfs_mount *);
 typedef void	(*xfs_dqrele_t)(struct xfs_dquot *);
 typedef int	(*xfs_dqattach_t)(struct xfs_inode *, uint);
@@ -132,7 +134,7 @@
 			struct xfs_dquot **, struct xfs_dquot *);
 typedef int	(*xfs_dqvopchownresv_t)(struct xfs_trans *, struct xfs_inode *,
 			struct xfs_dquot *, struct xfs_dquot *, uint);
-typedef void	(*xfs_dqstatvfs_t)(struct xfs_inode *, bhv_statvfs_t *);
+typedef void	(*xfs_dqstatvfs_t)(struct xfs_inode *, struct kstatfs *);
 typedef int	(*xfs_dqsync_t)(struct xfs_mount *, int flags);
 typedef int	(*xfs_quotactl_t)(struct xfs_mount *, int, int, xfs_caddr_t);
 
@@ -223,18 +225,10 @@
 #define xfs_icsb_sync_counters_locked(mp, flags) do { } while (0)
 #endif
 
-typedef struct xfs_ail {
-	struct list_head	xa_ail;
-	uint			xa_gen;
-	struct task_struct	*xa_task;
-	xfs_lsn_t		xa_target;
-} xfs_ail_t;
-
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
-	spinlock_t		m_ail_lock;	/* fs AIL mutex */
-	xfs_ail_t		m_ail;		/* fs active log item list */
+	struct xfs_ail		*m_ail;		/* fs active log item list */
 	xfs_sb_t		m_sb;		/* copy of fs superblock */
 	spinlock_t		m_sb_lock;	/* sb counter lock */
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
@@ -247,10 +241,6 @@
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	struct xfs_inode	*m_inodes;	/* active inode list */
-	struct list_head	m_del_inodes;	/* inodes to reclaim */
-	mutex_t			m_ilock;	/* inode list mutex */
-	uint			m_ireclaims;	/* count of calls to reclaim*/
 	uint			m_readio_log;	/* min read size log bytes */
 	uint			m_readio_blocks; /* min read size blocks */
 	uint			m_writeio_log;	/* min write size log bytes */
@@ -311,9 +301,6 @@
 	int			m_sinoalign;	/* stripe unit inode alignment */
 	int			m_attr_magicpct;/* 37% of the blocksize */
 	int			m_dir_magicpct;	/* 37% of the dir blocksize */
-	__uint8_t		m_mk_sharedro;	/* mark shared ro on unmount */
-	__uint8_t		m_inode_quiesce;/* call quiesce on new inodes.
-						   field governed by m_ilock */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
@@ -340,7 +327,6 @@
 	spinlock_t		m_sync_lock;	/* work item list lock */
 	int			m_sync_seq;	/* sync thread generation no. */
 	wait_queue_head_t	m_wait_single_sync_task;
-	struct vfsmount		*m_vfsmount;
 } xfs_mount_t;
 
 /*
@@ -362,7 +348,6 @@
 #define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
 #define XFS_MOUNT_GRPID		(1ULL << 9)	/* group-ID assigned from directory */
 #define XFS_MOUNT_NORECOVERY	(1ULL << 10)	/* no recovery - dirty fs */
-#define XFS_MOUNT_SHARED	(1ULL << 11)	/* shared mount */
 #define XFS_MOUNT_DFLT_IOSIZE	(1ULL << 12)	/* set default i/o size */
 #define XFS_MOUNT_OSYNCISOSYNC	(1ULL << 13)	/* o_sync is REALLY o_sync */
 						/* osyncisdsync is now default*/
@@ -439,6 +424,16 @@
 #define xfs_force_shutdown(m,f)	\
 	xfs_do_force_shutdown(m, f, __FILE__, __LINE__)
 
+#define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
+#define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
+#define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
+#define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
+#define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
+#define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
+
+#define xfs_test_for_freeze(mp)		((mp)->m_super->s_frozen)
+#define xfs_wait_for_freeze(mp,l)	vfs_check_frozen((mp)->m_super, (l))
+
 /*
  * Flags for xfs_mountfs
  */
@@ -514,7 +509,6 @@
 
 extern void	xfs_unmountfs(xfs_mount_t *);
 extern int	xfs_unmountfs_writesb(xfs_mount_t *);
-extern int	xfs_unmount_flush(xfs_mount_t *, int);
 extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
 extern int	xfs_mod_incore_sb_unlocked(xfs_mount_t *, xfs_sb_field_t,
 			int64_t, int);
@@ -524,13 +518,11 @@
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
 extern int	xfs_fs_writable(xfs_mount_t *);
-extern int	xfs_syncsub(xfs_mount_t *, int, int *);
-extern int	xfs_sync_inodes(xfs_mount_t *, int, int *);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
-extern int	xfs_dmops_get(struct xfs_mount *, struct xfs_mount_args *);
+extern int	xfs_dmops_get(struct xfs_mount *);
 extern void	xfs_dmops_put(struct xfs_mount *);
-extern int	xfs_qmops_get(struct xfs_mount *, struct xfs_mount_args *);
+extern int	xfs_qmops_get(struct xfs_mount *);
 extern void	xfs_qmops_put(struct xfs_mount *);
 
 extern struct xfs_dmops xfs_dmcore_xfs;
Index: xfs-cmds/xfsprogs/include/xfs_quota.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_quota.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_quota.h	2008-12-06 20:05:49.000000000 +0100
@@ -84,11 +84,9 @@
 #define XFS_DQ_USER		0x0001		/* a user quota */
 #define XFS_DQ_PROJ		0x0002		/* project quota */
 #define XFS_DQ_GROUP		0x0004		/* a group quota */
-#define XFS_DQ_FLOCKED		0x0008		/* flush lock taken */
-#define XFS_DQ_DIRTY		0x0010		/* dquot is dirty */
-#define XFS_DQ_WANT		0x0020		/* for lookup/reclaim race */
-#define XFS_DQ_INACTIVE		0x0040		/* dq off mplist & hashlist */
-#define XFS_DQ_MARKER		0x0080		/* sentinel */
+#define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
+#define XFS_DQ_WANT		0x0010		/* for lookup/reclaim race */
+#define XFS_DQ_INACTIVE		0x0020		/* dq off mplist & hashlist */
 
 #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
Index: xfs-cmds/xfsprogs/include/xfs_sb.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_sb.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_sb.h	2008-12-06 20:05:49.000000000 +0100
@@ -297,30 +297,34 @@
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-#ifdef __KERNEL__
 static inline int xfs_sb_good_version(xfs_sb_t *sbp)
 {
-	return (((sbp->sb_versionnum >= XFS_SB_VERSION_1) && \
-		  (sbp->sb_versionnum <= XFS_SB_VERSION_3)) || \
-		   ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		    !((sbp->sb_versionnum & ~XFS_SB_VERSION_OKREALBITS) || \
-		      ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) && \
-		       (sbp->sb_features2 & ~XFS_SB_VERSION2_OKREALBITS))) && \
-	  	    (sbp->sb_shared_vn <= XFS_SB_MAX_SHARED_VN)));
-}
+	/* We always support version 1-3 */
+	if (sbp->sb_versionnum >= XFS_SB_VERSION_1 &&
+	    sbp->sb_versionnum <= XFS_SB_VERSION_3)
+		return 1;
+
+	/* We support version 4 if all feature bits are supported */
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) {
+		if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKREALBITS) ||
+		    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
+		     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKREALBITS)))
+			return 0;
+
+#ifdef __KERNEL__
+		if (sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
+			return 0;
 #else
-static inline int xfs_sb_good_version(xfs_sb_t *sbp)
-{
-	return (((sbp->sb_versionnum >= XFS_SB_VERSION_1) && \
-		  (sbp->sb_versionnum <= XFS_SB_VERSION_3)) || \
-		   ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		    !((sbp->sb_versionnum & ~XFS_SB_VERSION_OKREALBITS) || \
-		      ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) && \
-		       (sbp->sb_features2 & ~XFS_SB_VERSION2_OKREALBITS))) && \
-		  (!(sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT) || \
-		   (sbp->sb_shared_vn <= XFS_SB_MAX_SHARED_VN))));
+		if ((sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT) &&
+		    sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
+			return 0;
+#endif
+
+		return 1;
+	}
+
+	return 0;
 }
-#endif /* __KERNEL__ */
 
 /*
  * Detect a mismatched features2 field.  Older kernels read/wrote
@@ -333,123 +337,127 @@
 
 static inline unsigned xfs_sb_version_tonew(unsigned v)
 {
-	return ((((v) == XFS_SB_VERSION_1) ? \
-		0 : \
-		(((v) == XFS_SB_VERSION_2) ? \
-			XFS_SB_VERSION_ATTRBIT : \
-			(XFS_SB_VERSION_ATTRBIT | XFS_SB_VERSION_NLINKBIT))) | \
-		XFS_SB_VERSION_4);
+	if (v == XFS_SB_VERSION_1)
+		return XFS_SB_VERSION_4;
+
+	if (v == XFS_SB_VERSION_2)
+		return XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
+
+	return XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT |
+		XFS_SB_VERSION_NLINKBIT;
 }
 
 static inline unsigned xfs_sb_version_toold(unsigned v)
 {
-	return (((v) & (XFS_SB_VERSION_QUOTABIT | XFS_SB_VERSION_ALIGNBIT)) ? \
-		0 : \
-		(((v) & XFS_SB_VERSION_NLINKBIT) ? \
-			XFS_SB_VERSION_3 : \
-			(((v) & XFS_SB_VERSION_ATTRBIT) ?  \
-				XFS_SB_VERSION_2 : \
-				XFS_SB_VERSION_1)));
+	if (v & (XFS_SB_VERSION_QUOTABIT | XFS_SB_VERSION_ALIGNBIT))
+		return 0;
+	if (v & XFS_SB_VERSION_NLINKBIT)
+		return XFS_SB_VERSION_3;
+	if (v & XFS_SB_VERSION_ATTRBIT)
+		return XFS_SB_VERSION_2;
+	return XFS_SB_VERSION_1;
 }
 
 static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
 {
-	return ((sbp)->sb_versionnum == XFS_SB_VERSION_2) || \
-		 ((sbp)->sb_versionnum == XFS_SB_VERSION_3) || \
-		 ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		  ((sbp)->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
+	return sbp->sb_versionnum == XFS_SB_VERSION_2 ||
+		sbp->sb_versionnum == XFS_SB_VERSION_3 ||
+		(XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		 (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
 }
 
 static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
 {
-	(sbp)->sb_versionnum = (((sbp)->sb_versionnum == XFS_SB_VERSION_1) ? \
-		XFS_SB_VERSION_2 : \
-		((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) ? \
-			((sbp)->sb_versionnum | XFS_SB_VERSION_ATTRBIT) : \
-			(XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT)));
+	if (sbp->sb_versionnum == XFS_SB_VERSION_1)
+		sbp->sb_versionnum = XFS_SB_VERSION_2;
+	else if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
+		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
+	else
+		sbp->sb_versionnum = XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
 }
 
 static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
 {
-	return ((sbp)->sb_versionnum == XFS_SB_VERSION_3) || \
-		 ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		  ((sbp)->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
+	return sbp->sb_versionnum == XFS_SB_VERSION_3 ||
+		 (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		  (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
 }
 
 static inline void xfs_sb_version_addnlink(xfs_sb_t *sbp)
 {
-	(sbp)->sb_versionnum = ((sbp)->sb_versionnum <= XFS_SB_VERSION_2 ? \
-		XFS_SB_VERSION_3 : \
-		((sbp)->sb_versionnum | XFS_SB_VERSION_NLINKBIT));
+	if (sbp->sb_versionnum <= XFS_SB_VERSION_2)
+		sbp->sb_versionnum = XFS_SB_VERSION_3;
+	else
+		sbp->sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
 }
 
 static inline int xfs_sb_version_hasquota(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
 }
 
 static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
 {
-	(sbp)->sb_versionnum = \
-		 (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 ? \
-			((sbp)->sb_versionnum | XFS_SB_VERSION_QUOTABIT) : \
-			(xfs_sb_version_tonew((sbp)->sb_versionnum) | \
-			 XFS_SB_VERSION_QUOTABIT));
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
+		sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
+	else
+		sbp->sb_versionnum = xfs_sb_version_tonew(sbp->sb_versionnum) |
+					XFS_SB_VERSION_QUOTABIT;
 }
 
 static inline int xfs_sb_version_hasalign(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_ALIGNBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT);
 }
 
 static inline int xfs_sb_version_hasdalign(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
 }
 
 static inline int xfs_sb_version_hasshared(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_SHAREDBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT);
 }
 
 static inline int xfs_sb_version_hasdirv2(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 }
 
 static inline int xfs_sb_version_haslogv2(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
 }
 
 static inline int xfs_sb_version_hasextflgbit(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
 }
 
 static inline int xfs_sb_version_hassector(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
 
 static inline int xfs_sb_version_hasasciici(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
 		(sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
 }
 
 static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
 }
 
 /*
@@ -464,22 +472,20 @@
 
 static inline int xfs_sb_version_haslazysbcount(xfs_sb_t *sbp)
 {
-	return (xfs_sb_version_hasmorebits(sbp) &&	\
-		((sbp)->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
+	return xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT);
 }
 
 static inline int xfs_sb_version_hasattr2(xfs_sb_t *sbp)
 {
-	return (xfs_sb_version_hasmorebits(sbp)) &&	\
-		((sbp)->sb_features2 & XFS_SB_VERSION2_ATTR2BIT);
+	return xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT);
 }
 
 static inline void xfs_sb_version_addattr2(xfs_sb_t *sbp)
 {
-	((sbp)->sb_versionnum =	\
-		((sbp)->sb_versionnum | XFS_SB_VERSION_MOREBITSBIT),	\
-	((sbp)->sb_features2 =	\
-		((sbp)->sb_features2 | XFS_SB_VERSION2_ATTR2BIT)));
+	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
 }
 
 static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)
Index: xfs-cmds/xfsprogs/include/xfs_trans.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_trans.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/xfs_trans.h	2008-12-06 20:05:49.000000000 +0100
@@ -768,6 +768,7 @@
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
 	struct xfs_log_item_desc	*li_desc;	/* ptr to current desc*/
 	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
+	struct xfs_ail			*li_ailp;	/* ptr to AIL */
 	uint				li_type;	/* item type */
 	uint				li_flags;	/* misc flags */
 	struct xfs_log_item		*li_bio_list;	/* buffer item list */
@@ -970,10 +971,6 @@
 void		xfs_trans_cancel(xfs_trans_t *, int);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
-void		xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
-xfs_lsn_t	xfs_trans_tail_ail(struct xfs_mount *);
-void		xfs_trans_unlocked_item(struct xfs_mount *,
-					xfs_log_item_t *);
 xfs_log_busy_slot_t *xfs_trans_add_busy(xfs_trans_t *tp,
 					xfs_agnumber_t ag,
 					xfs_extlen_t idx);
Index: xfs-cmds/xfsprogs/db/bmap.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/bmap.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/db/bmap.c	2008-12-06 20:05:49.000000000 +0100
@@ -171,9 +171,9 @@
 		push_cur();
 		set_cur_inode(iocur_top->ino);
 		dip = iocur_top->data;
-		if (be32_to_cpu(dip->di_core.di_nextents))
+		if (dip->di_nextents)
 			dfork = 1;
-		if (be16_to_cpu(dip->di_core.di_anextents))
+		if (dip->di_anextents)
 			afork = 1;
 		pop_cur();
 	}
Index: xfs-cmds/xfsprogs/db/check.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/check.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/db/check.c	2008-12-06 20:05:49.000000000 +0100
@@ -2502,23 +2502,23 @@
 	inodata_t	*id,
 	xfs_ino_t	*parent)
 {
-	xfs_fsize_t	size = be64_to_cpu(dip->di_core.di_size);
+	xfs_fsize_t	size = be64_to_cpu(dip->di_size);
 
 	if (size <= XFS_DFORK_DSIZE(dip, mp) && 
-				dip->di_core.di_format == XFS_DINODE_FMT_LOCAL)
+				dip->di_format == XFS_DINODE_FMT_LOCAL)
 		*parent = process_shortform_dir_v1(dip, dot, dotdot, id);
 	else if (size == XFS_LBSIZE(mp) &&
-			(dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ||
-			dip->di_core.di_format == XFS_DINODE_FMT_BTREE))
+			(dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format == XFS_DINODE_FMT_BTREE))
 		*parent = process_leaf_dir_v1(blkmap, dot, dotdot, id);
 	else if (size >= XFS_LBSIZE(mp) &&
-			(dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ||
-			dip->di_core.di_format == XFS_DINODE_FMT_BTREE))
+			(dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format == XFS_DINODE_FMT_BTREE))
 		*parent = process_node_dir_v1(blkmap, dot, dotdot, id);
 	else  {
 		dbprintf("bad size (%lld) or format (%d) for directory inode "
 			 "%lld\n",
-			size, dip->di_core.di_format, id->ino);
+			size, dip->di_format, id->ino);
 		error++;
 		return 1;
 	}
@@ -2535,25 +2535,25 @@
 	xfs_ino_t	*parent)
 {
 	xfs_fileoff_t	last = 0;
-	xfs_fsize_t	size = be64_to_cpu(dip->di_core.di_size);
+	xfs_fsize_t	size = be64_to_cpu(dip->di_size);
 
 	if (blkmap)
 		last = blkmap_last_off(blkmap);
 	if (size <= XFS_DFORK_DSIZE(dip, mp) &&
-				dip->di_core.di_format == XFS_DINODE_FMT_LOCAL)
+				dip->di_format == XFS_DINODE_FMT_LOCAL)
 		*parent = process_sf_dir_v2(dip, dot, dotdot, id);
 	else if (last == mp->m_dirblkfsbs &&
-			(dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ||
-			dip->di_core.di_format == XFS_DINODE_FMT_BTREE))
+			(dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format == XFS_DINODE_FMT_BTREE))
 		*parent = process_block_dir_v2(blkmap, dot, dotdot, id);
 	else if (last >= mp->m_dirleafblk + mp->m_dirblkfsbs &&
-			(dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ||
-			dip->di_core.di_format == XFS_DINODE_FMT_BTREE))
+			(dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format == XFS_DINODE_FMT_BTREE))
 		*parent = process_leaf_node_dir_v2(blkmap, dot, dotdot, id, size);
 	else  {
 		dbprintf("bad size (%lld) or format (%d) for directory inode "
 			 "%lld\n",
-			size, dip->di_core.di_format, id->ino);
+			size, dip->di_format, id->ino);
 		error++;
 		return 1;
 	}
@@ -2639,7 +2639,7 @@
 		"dev", "local", "extents", "btree", "uuid"
 	};
 
-	libxfs_dinode_from_disk(&idic, &dip->di_core);
+	libxfs_dinode_from_disk(&idic, dip);
 
 	ino = XFS_AGINO_TO_INO(mp, be32_to_cpu(agf->agf_seqno), agino);
 	if (!isfree) {
@@ -2669,7 +2669,7 @@
 					idic.di_nblocks, ino);
 			error++;
 		}
-		if (idic.di_version == XFS_DINODE_VERSION_1)
+		if (idic.di_version == 1)
 			nlink = idic.di_onlink;
 		else
 			nlink = idic.di_nlink;
@@ -2773,7 +2773,7 @@
 		type = DBM_UNKNOWN;
 		break;
 	}
-	if (idic.di_version == XFS_DINODE_VERSION_1)
+	if (idic.di_version == 1)
 		setlink_inode(id, idic.di_onlink, type == DBM_DIR, security);
 	else {
 		sbversion |= XFS_SB_VERSION_NLINKBIT;
@@ -2901,12 +2901,12 @@
 	xfs_fsblock_t		bno;
 
 	bno = XFS_INO_TO_FSB(mp, id->ino);
-	if (whichfork == XFS_DATA_FORK && be64_to_cpu(dip->di_core.di_size) >
+	if (whichfork == XFS_DATA_FORK && be64_to_cpu(dip->di_size) >
 						XFS_DFORK_DSIZE(dip, mp)) {
 		if (!sflag || id->ilist || CHECK_BLIST(bno))
 			dbprintf("local inode %lld data is too large (size "
 				 "%lld)\n",
-				id->ino, be64_to_cpu(dip->di_core.di_size));
+				id->ino, be64_to_cpu(dip->di_size));
 		error++;
 	}
 	else if (whichfork == XFS_ATTR_FORK) {
@@ -3638,7 +3638,7 @@
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
 	for (i = sf->hdr.count - 1, i8 = 0; i >= 0; i--) {
 		if ((__psint_t)sfe + xfs_dir2_sf_entsize_byentry(sf, sfe) -
-		    (__psint_t)sf > be64_to_cpu(dip->di_core.di_size)) {
+		    (__psint_t)sf > be64_to_cpu(dip->di_size)) {
 			if (!sflag)
 				dbprintf("dir %llu bad size in entry at %d\n",
 					id->ino,
@@ -3680,10 +3680,10 @@
 		sfe = xfs_dir2_sf_nextentry(sf, sfe);
 	}
 	if (i < 0 && (__psint_t)sfe - (__psint_t)sf != 
-					be64_to_cpu(dip->di_core.di_size)) {
+					be64_to_cpu(dip->di_size)) {
 		if (!sflag)
 			dbprintf("dir %llu size is %lld, should be %u\n",
-				id->ino, be64_to_cpu(dip->di_core.di_size),
+				id->ino, be64_to_cpu(dip->di_size),
 				(uint)((char *)sfe - (char *)sf));
 		error++;
 	}
@@ -3760,9 +3760,9 @@
 				sfe->namelen, sfe->namelen, sfe->name, lino);
 		sfe = xfs_dir_sf_nextentry(sfe);
 	}
-	if ((__psint_t)sfe - (__psint_t)sf != be64_to_cpu(dip->di_core.di_size))
+	if ((__psint_t)sfe - (__psint_t)sf != be64_to_cpu(dip->di_size))
 		dbprintf("dir %llu size is %lld, should be %d\n",
-			id->ino, be64_to_cpu(dip->di_core.di_size),
+			id->ino, be64_to_cpu(dip->di_size),
 			(int)((char *)sfe - (char *)sf));
 	lino = XFS_GET_DIR_INO8(sf->hdr.parent);
 	cid = find_inode(lino, 1);
Index: xfs-cmds/xfsprogs/db/dir2sf.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/dir2sf.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/db/dir2sf.c	2008-12-06 20:05:49.000000000 +0100
@@ -73,10 +73,10 @@
 	void		*obj,
 	int		startoff)
 {
-	xfs_dir2_sf_t	*sf;
+	xfs_dinode_t	*dip = obj;
+	xfs_dir2_sf_t	*sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = &((xfs_dinode_t *)obj)->di_u.di_dir2sf;
 	return sf->hdr.i8count == 0;
 }
 
@@ -86,10 +86,10 @@
 	void		*obj,
 	int		startoff)
 {
-	xfs_dir2_sf_t	*sf;
+	xfs_dinode_t	*dip = obj;
+	xfs_dir2_sf_t	*sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = &((xfs_dinode_t *)obj)->di_u.di_dir2sf;
 	return sf->hdr.i8count != 0;
 }
 
@@ -100,11 +100,11 @@
 	int		startoff,
 	int		idx)
 {
-	xfs_dir2_sf_t	*sf;
+	xfs_dinode_t	*dip = obj;
+	xfs_dir2_sf_t	*sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(idx == 0);
-	sf = &((xfs_dinode_t *)obj)->di_u.di_dir2sf;
 	return bitize(sf->hdr.i8count ?
 		      (uint)sizeof(xfs_dir2_ino8_t) :
 		      (uint)sizeof(xfs_dir2_ino4_t));
Index: xfs-cmds/xfsprogs/db/field.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/field.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/db/field.c	2008-12-06 20:05:49.000000000 +0100
@@ -150,8 +150,6 @@
 	  FTARG_DONULL, fa_dfsbno, NULL },
 	{ FLDT_DINODE_A, "dinode_a", NULL, (char *)inode_a_flds, inode_a_size,
 	  FTARG_SIZE|FTARG_OKEMPTY, NULL, inode_a_flds },
-	{ FLDT_DINODE_CORE, "dinode_core", NULL, (char *)inode_core_flds,
-	  SI(bitsz(xfs_dinode_core_t)), 0, NULL, inode_core_flds },
 	{ FLDT_DINODE_FMT, "dinode_fmt", fp_dinode_fmt, NULL,
 	  SI(bitsz(__int8_t)), 0, NULL, NULL },
 	{ FLDT_DINODE_U, "dinode_u", NULL, (char *)inode_u_flds, inode_u_size,
Index: xfs-cmds/xfsprogs/db/field.h
===================================================================
--- xfs-cmds.orig/xfsprogs/db/field.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/db/field.h	2008-12-06 20:05:49.000000000 +0100
@@ -72,7 +72,6 @@
 	FLDT_DFILOFFD,
 	FLDT_DFSBNO,
 	FLDT_DINODE_A,
-	FLDT_DINODE_CORE,
 	FLDT_DINODE_FMT,
 	FLDT_DINODE_U,
 	FLDT_DIR,
Index: xfs-cmds/xfsprogs/db/frag.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/frag.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/db/frag.c	2008-12-06 20:05:49.000000000 +0100
@@ -308,20 +308,18 @@
 	xfs_dinode_t		*dip)
 {
 	__uint64_t		actual;
-	xfs_dinode_core_t	*dic;
 	__uint64_t		ideal;
 	xfs_ino_t		ino;
 	int			skipa;
 	int			skipd;
 
-	dic = &dip->di_core;
 	ino = XFS_AGINO_TO_INO(mp, be32_to_cpu(agf->agf_seqno), agino);
-	switch (be16_to_cpu(dic->di_mode) & S_IFMT) {
+	switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
 	case S_IFDIR:
 		skipd = !dflag;
 		break;
 	case S_IFREG:
-		if (!rflag && (be16_to_cpu(dic->di_flags) & XFS_DIFLAG_REALTIME))
+		if (!rflag && (be16_to_cpu(dip->di_flags) & XFS_DIFLAG_REALTIME))
 			skipd = 1;
 		else if (!Rflag &&
 			 (ino == mp->m_sb.sb_rbmino ||
Index: xfs-cmds/xfsprogs/db/inode.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/inode.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/db/inode.c	2008-12-06 20:05:49.000000000 +0100
@@ -40,6 +40,7 @@
 static int	inode_core_projid_count(void *obj, int startoff);
 static int	inode_core_nlinkv1_count(void *obj, int startoff);
 static int	inode_f(int argc, char **argv);
+static int	inode_u_offset(void *obj, int startoff, int idx);
 static int	inode_u_bmbt_count(void *obj, int startoff);
 static int	inode_u_bmx_count(void *obj, int startoff);
 static int	inode_u_c_count(void *obj, int startoff);
@@ -60,91 +61,85 @@
 
 #define	OFF(f)	bitize(offsetof(xfs_dinode_t, di_ ## f))
 const field_t	inode_flds[] = {
-	{ "core", FLDT_DINODE_CORE, OI(OFF(core)), C1, 0, TYP_NONE },
-	{ "next_unlinked", FLDT_AGINO, OI(OFF(next_unlinked)), C1, 0,
-	  TYP_INODE },
-	{ "u", FLDT_DINODE_U, OI(OFF(u)), C1, 0, TYP_NONE },
-	{ "a", FLDT_DINODE_A, inode_a_offset, inode_a_count,
-	  FLD_COUNT|FLD_OFFSET, TYP_NONE },
-	{ NULL }
-};
-
-#define	COFF(f)	bitize(offsetof(xfs_dinode_core_t, di_ ## f))
-const field_t	inode_core_flds[] = {
-	{ "magic", FLDT_UINT16X, OI(COFF(magic)), C1, 0, TYP_NONE },
-	{ "mode", FLDT_UINT16O, OI(COFF(mode)), C1, 0, TYP_NONE },
-	{ "version", FLDT_INT8D, OI(COFF(version)), C1, 0, TYP_NONE },
-	{ "format", FLDT_DINODE_FMT, OI(COFF(format)), C1, 0, TYP_NONE },
-	{ "nlinkv1", FLDT_UINT16D, OI(COFF(onlink)), inode_core_nlinkv1_count,
+	{ "magic", FLDT_UINT16X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "mode", FLDT_UINT16O, OI(OFF(mode)), C1, 0, TYP_NONE },
+	{ "version", FLDT_INT8D, OI(OFF(version)), C1, 0, TYP_NONE },
+	{ "format", FLDT_DINODE_FMT, OI(OFF(format)), C1, 0, TYP_NONE },
+	{ "nlinkv1", FLDT_UINT16D, OI(OFF(onlink)), inode_core_nlinkv1_count,
 	  FLD_COUNT, TYP_NONE },
-	{ "nlinkv2", FLDT_UINT32D, OI(COFF(nlink)), inode_core_nlinkv2_count,
+	{ "nlinkv2", FLDT_UINT32D, OI(OFF(nlink)), inode_core_nlinkv2_count,
 	  FLD_COUNT, TYP_NONE },
-	{ "onlink", FLDT_UINT16D, OI(COFF(onlink)), inode_core_onlink_count,
+	{ "onlink", FLDT_UINT16D, OI(OFF(onlink)), inode_core_onlink_count,
 	  FLD_COUNT, TYP_NONE },
-	{ "projid", FLDT_UINT16D, OI(COFF(projid)), inode_core_projid_count,
+	{ "projid", FLDT_UINT16D, OI(OFF(projid)), inode_core_projid_count,
 	  FLD_COUNT, TYP_NONE },
-	{ "uid", FLDT_UINT32D, OI(COFF(uid)), C1, 0, TYP_NONE },
-	{ "gid", FLDT_UINT32D, OI(COFF(gid)), C1, 0, TYP_NONE },
-	{ "flushiter", FLDT_UINT16D, OI(COFF(flushiter)), C1, 0, TYP_NONE },
-	{ "atime", FLDT_TIMESTAMP, OI(COFF(atime)), C1, 0, TYP_NONE },
-	{ "mtime", FLDT_TIMESTAMP, OI(COFF(mtime)), C1, 0, TYP_NONE },
-	{ "ctime", FLDT_TIMESTAMP, OI(COFF(ctime)), C1, 0, TYP_NONE },
-	{ "size", FLDT_FSIZE, OI(COFF(size)), C1, 0, TYP_NONE },
-	{ "nblocks", FLDT_DRFSBNO, OI(COFF(nblocks)), C1, 0, TYP_NONE },
-	{ "extsize", FLDT_EXTLEN, OI(COFF(extsize)), C1, 0, TYP_NONE },
-	{ "nextents", FLDT_EXTNUM, OI(COFF(nextents)), C1, 0, TYP_NONE },
-	{ "naextents", FLDT_AEXTNUM, OI(COFF(anextents)), C1, 0, TYP_NONE },
-	{ "forkoff", FLDT_UINT8D, OI(COFF(forkoff)), C1, 0, TYP_NONE },
-	{ "aformat", FLDT_DINODE_FMT, OI(COFF(aformat)), C1, 0, TYP_NONE },
-	{ "dmevmask", FLDT_UINT32X, OI(COFF(dmevmask)), C1, 0, TYP_NONE },
-	{ "dmstate", FLDT_UINT16D, OI(COFF(dmstate)), C1, 0, TYP_NONE },
-	{ "flags", FLDT_UINT16X, OI(COFF(flags)), C1, FLD_SKIPALL, TYP_NONE },
+	{ "uid", FLDT_UINT32D, OI(OFF(uid)), C1, 0, TYP_NONE },
+	{ "gid", FLDT_UINT32D, OI(OFF(gid)), C1, 0, TYP_NONE },
+	{ "flushiter", FLDT_UINT16D, OI(OFF(flushiter)), C1, 0, TYP_NONE },
+	{ "atime", FLDT_TIMESTAMP, OI(OFF(atime)), C1, 0, TYP_NONE },
+	{ "mtime", FLDT_TIMESTAMP, OI(OFF(mtime)), C1, 0, TYP_NONE },
+	{ "ctime", FLDT_TIMESTAMP, OI(OFF(ctime)), C1, 0, TYP_NONE },
+	{ "size", FLDT_FSIZE, OI(OFF(size)), C1, 0, TYP_NONE },
+	{ "nblocks", FLDT_DRFSBNO, OI(OFF(nblocks)), C1, 0, TYP_NONE },
+	{ "extsize", FLDT_EXTLEN, OI(OFF(extsize)), C1, 0, TYP_NONE },
+	{ "nextents", FLDT_EXTNUM, OI(OFF(nextents)), C1, 0, TYP_NONE },
+	{ "naextents", FLDT_AEXTNUM, OI(OFF(anextents)), C1, 0, TYP_NONE },
+	{ "forkoff", FLDT_UINT8D, OI(OFF(forkoff)), C1, 0, TYP_NONE },
+	{ "aformat", FLDT_DINODE_FMT, OI(OFF(aformat)), C1, 0, TYP_NONE },
+	{ "dmevmask", FLDT_UINT32X, OI(OFF(dmevmask)), C1, 0, TYP_NONE },
+	{ "dmstate", FLDT_UINT16D, OI(OFF(dmstate)), C1, 0, TYP_NONE },
+	{ "flags", FLDT_UINT16X, OI(OFF(flags)), C1, FLD_SKIPALL, TYP_NONE },
 	{ "newrtbm", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NEWRTBM_BIT - 1), C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NEWRTBM_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "prealloc", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_PREALLOC_BIT - 1), C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_PREALLOC_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "realtime", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_REALTIME_BIT - 1), C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_REALTIME_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "immutable", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_IMMUTABLE_BIT-1), C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_IMMUTABLE_BIT-1), C1,
 	  0, TYP_NONE },
 	{ "append", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_APPEND_BIT - 1), C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_APPEND_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "sync", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_SYNC_BIT - 1), C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_SYNC_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "noatime", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NOATIME_BIT - 1), C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NOATIME_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "nodump", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NODUMP_BIT - 1), C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NODUMP_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "rtinherit", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_RTINHERIT_BIT-1), C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_RTINHERIT_BIT-1), C1,
 	  0, TYP_NONE },
 	{ "projinherit", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_PROJINHERIT_BIT-1),C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_PROJINHERIT_BIT-1),C1,
 	  0, TYP_NONE },
 	{ "nosymlinks", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NOSYMLINKS_BIT-1), C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NOSYMLINKS_BIT-1), C1,
 	  0, TYP_NONE },
 	{ "extsz", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_EXTSIZE_BIT-1),C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_EXTSIZE_BIT-1),C1,
 	  0, TYP_NONE },
 	{ "extszinherit", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_EXTSZINHERIT_BIT-1),C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_EXTSZINHERIT_BIT-1),C1,
 	  0, TYP_NONE },
 	{ "nodefrag", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NODEFRAG_BIT-1),C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NODEFRAG_BIT-1),C1,
 	  0, TYP_NONE },
 	{ "filestream", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_FILESTREAM_BIT-1),C1,
+	  OI(OFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_FILESTREAM_BIT-1),C1,
 	  0, TYP_NONE },
-	{ "gen", FLDT_UINT32D, OI(COFF(gen)), C1, 0, TYP_NONE },
+	{ "gen", FLDT_UINT32D, OI(OFF(gen)), C1, 0, TYP_NONE },
+	{ "next_unlinked", FLDT_AGINO, OI(OFF(next_unlinked)), C1, 0,
+	  TYP_INODE },
+	{ "u", FLDT_DINODE_U, inode_u_offset, C1, FLD_OFFSET, TYP_NONE },
+	{ "a", FLDT_DINODE_A, inode_a_offset, inode_a_count,
+	  FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ NULL }
 };
 
@@ -226,7 +221,7 @@
 	if (!XFS_DFORK_Q(dip))
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
-	return dip->di_core.di_aformat == XFS_DINODE_FMT_BTREE;
+	return dip->di_aformat == XFS_DINODE_FMT_BTREE;
 }
 
 static int
@@ -242,8 +237,8 @@
 	if (!XFS_DFORK_Q(dip))
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
-	return dip->di_core.di_aformat == XFS_DINODE_FMT_EXTENTS ?
-		be16_to_cpu(dip->di_core.di_anextents) : 0;
+	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
+		be16_to_cpu(dip->di_anextents) : 0;
 }
 
 static int
@@ -251,10 +246,9 @@
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	xfs_dinode_t	*dip = obj;
 
 	ASSERT(startoff == 0);
-	dip = obj;
 	return XFS_DFORK_Q(dip);
 }
 
@@ -264,11 +258,10 @@
 	int		startoff,
 	int		idx)
 {
-	xfs_dinode_t	*dip;
+	xfs_dinode_t	*dip = obj;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
-	dip = obj;
 	ASSERT(XFS_DFORK_Q(dip));
 	return bitize((int)((char *)XFS_DFORK_APTR(dip) - (char *)dip));
 }
@@ -286,7 +279,7 @@
 	if (!XFS_DFORK_Q(dip))
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
-	return dip->di_core.di_aformat == XFS_DINODE_FMT_LOCAL;
+	return dip->di_aformat == XFS_DINODE_FMT_LOCAL;
 }
 
 int
@@ -301,12 +294,12 @@
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
 	dip = obj;
-	switch (dip->di_core.di_aformat) {
+	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
 		asf = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		return bitize(be16_to_cpu(asf->hdr.totsize));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be16_to_cpu(dip->di_core.di_anextents) * 
+		return (int)be16_to_cpu(dip->di_anextents) *
 							bitsz(xfs_bmbt_rec_t);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
@@ -320,12 +313,11 @@
 	void			*obj,
 	int			startoff)
 {
-	xfs_dinode_core_t	*dic;
+	xfs_dinode_t		*dip = obj;
 
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
-	dic = obj;
-	return dic->di_version == XFS_DINODE_VERSION_1;
+	return dip->di_version == 1;
 }
 
 static int
@@ -333,12 +325,11 @@
 	void			*obj,
 	int			startoff)
 {
-	xfs_dinode_core_t	*dic;
+	xfs_dinode_t		*dip = obj;
 
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
-	dic = obj;
-	return dic->di_version == XFS_DINODE_VERSION_2;
+	return dip->di_version == 2;
 }
 
 static int
@@ -346,12 +337,11 @@
 	void			*obj,
 	int			startoff)
 {
-	xfs_dinode_core_t	*dic;
+	xfs_dinode_t		*dip = obj;
 
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
-	dic = obj;
-	return dic->di_version == XFS_DINODE_VERSION_2;
+	return dip->di_version == 2;
 }
 
 static int
@@ -359,12 +349,11 @@
 	void			*obj,
 	int			startoff)
 {
-	xfs_dinode_core_t	*dic;
+	xfs_dinode_t		*dip = obj;
 
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
-	dic = obj;
-	return dic->di_version == XFS_DINODE_VERSION_2;
+	return dip->di_version == 2;
 }
 
 static int
@@ -428,17 +417,29 @@
 }
 
 static int
+inode_u_offset(
+	void		*obj,
+	int		startoff,
+	int		idx)
+{
+	xfs_dinode_t	*dip = obj;
+
+	ASSERT(startoff == 0);
+	ASSERT(idx == 0);
+	return bitize((int)((char *)XFS_DFORK_DPTR(dip) - (char *)dip));
+}
+
+static int
 inode_u_bmbt_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	xfs_dinode_t	*dip = obj;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
-	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_BTREE;
+	ASSERT(XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_BTREE;
 }
 
 static int
@@ -446,14 +447,13 @@
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	xfs_dinode_t	*dip = obj;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
-	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ?
-		be32_to_cpu(dip->di_core.di_nextents) : 0;
+	ASSERT(XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
+		be32_to_cpu(dip->di_nextents) : 0;
 }
 
 static int
@@ -461,15 +461,14 @@
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	xfs_dinode_t	*dip = obj;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
-	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_LOCAL &&
-	       (be16_to_cpu(dip->di_core.di_mode) & S_IFMT) == S_IFREG ?
-		(int)be64_to_cpu(dip->di_core.di_size) : 0;
+	ASSERT(XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_LOCAL &&
+	       (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFREG ?
+		(int)be64_to_cpu(dip->di_size) : 0;
 }
 
 static int
@@ -477,13 +476,12 @@
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	xfs_dinode_t	*dip = obj;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
-	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_DEV;
+	ASSERT(XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_DEV;
 }
 
 static int
@@ -491,13 +489,12 @@
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	xfs_dinode_t	*dip = obj;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
-	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_UUID;
+	ASSERT(XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_UUID;
 }
 
 static int
@@ -505,14 +502,13 @@
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	xfs_dinode_t	*dip = obj;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
-	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_LOCAL &&
-	       (be16_to_cpu(dip->di_core.di_mode) & S_IFMT) == S_IFDIR
+	ASSERT(XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_LOCAL &&
+	       (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFDIR
 	       && !xfs_sb_version_hasdirv2(&mp->m_sb);
 }
 
@@ -521,14 +517,13 @@
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	xfs_dinode_t	*dip = obj;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
-	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_LOCAL &&
-	       (be16_to_cpu(dip->di_core.di_mode) & S_IFMT) == S_IFDIR &&
+	ASSERT(XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_LOCAL &&
+	       (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFDIR &&
 	       xfs_sb_version_hasdirv2(&mp->m_sb);
 }
 
@@ -543,13 +538,13 @@
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
 	dip = obj;
-	switch (dip->di_core.di_format) {
+	switch (dip->di_format) {
 	case XFS_DINODE_FMT_DEV:
 		return bitsz(xfs_dev_t);
 	case XFS_DINODE_FMT_LOCAL:
-		return bitize((int)be64_to_cpu(dip->di_core.di_size));
+		return bitize((int)be64_to_cpu(dip->di_size));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be32_to_cpu(dip->di_core.di_nextents) * 
+		return (int)be32_to_cpu(dip->di_nextents) *
 						bitsz(xfs_bmbt_rec_t);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
@@ -565,15 +560,14 @@
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	xfs_dinode_t	*dip = obj;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
-	dip = obj;
-	ASSERT((char *)&dip->di_u - (char *)dip == byteize(startoff));
-	return dip->di_core.di_format == XFS_DINODE_FMT_LOCAL &&
-	       (be16_to_cpu(dip->di_core.di_mode) & S_IFMT) == S_IFLNK ?
-		(int)be64_to_cpu(dip->di_core.di_size) : 0;
+	ASSERT(XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_LOCAL &&
+	       (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFLNK ?
+		(int)be64_to_cpu(dip->di_size) : 0;
 }
 
 void
@@ -609,7 +603,7 @@
 	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
 	dip = iocur_top->data;
 	iocur_top->ino = ino;
-	iocur_top->mode = be16_to_cpu(dip->di_core.di_mode);
+	iocur_top->mode = be16_to_cpu(dip->di_mode);
 	if ((iocur_top->mode & S_IFMT) == S_IFDIR)
 		iocur_top->dirino = ino;
 
Index: xfs-cmds/xfsprogs/db/inode.h
===================================================================
--- xfs-cmds.orig/xfsprogs/db/inode.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/db/inode.h	2008-12-06 20:05:49.000000000 +0100
@@ -17,7 +17,7 @@
  */
 
 extern const struct field	inode_a_flds[];
-extern const struct field	inode_core_flds[];
+extern const struct field	inode_flds[];
 extern const struct field	inode_flds[];
 extern const struct field	inode_hfld[];
 extern const struct field	inode_u_flds[];
Index: xfs-cmds/xfsprogs/db/metadump.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/metadump.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/db/metadump.c	2008-12-06 20:05:49.000000000 +0100
@@ -501,8 +501,8 @@
 	__uint64_t		ino_dir_size;
 	int			i;
 
-	sfp = &dip->di_u.di_dir2sf;
-	ino_dir_size = be64_to_cpu(dip->di_core.di_size);
+	sfp = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
+	ino_dir_size = be64_to_cpu(dip->di_size);
 	if (ino_dir_size > XFS_DFORK_DSIZE(dip, mp)) {
 		ino_dir_size = XFS_DFORK_DSIZE(dip, mp);
 		if (show_warnings)
@@ -554,8 +554,9 @@
 	xfs_dinode_t		*dip)
 {
 	__uint64_t		len;
+	char			*symlink = XFS_DFORK_DPTR(dip);
 
-	len = be64_to_cpu(dip->di_core.di_size);
+	len = be64_to_cpu(dip->di_size);
 	if (len > XFS_DFORK_DSIZE(dip, mp)) {
 		if (show_warnings)
 			print_warning("invalid size (%d) in symlink inode %llu",
@@ -564,7 +565,7 @@
 	}
 
 	while (len > 0)
-		dip->di_u.di_symlink[--len] = random() % 127 + 1;
+		symlink[--len] = random() % 127 + 1;
 }
 
 static void
@@ -1142,27 +1143,24 @@
 	xfs_dinode_t		*dip,
 	typnm_t			itype)
 {
-	switch (dip->di_core.di_format) {
-		case XFS_DINODE_FMT_LOCAL:
-			if (!dont_obfuscate)
-				switch (itype) {
-					case TYP_DIR2:
-						obfuscate_sf_dir(dip);
-						break;
-
-					case TYP_SYMLINK:
-						obfuscate_sf_symlink(dip);
-						break;
-
-					default: ;
-				}
-			break;
-
-		case XFS_DINODE_FMT_EXTENTS:
-			return process_exinode(dip, itype);
-
-		case XFS_DINODE_FMT_BTREE:
-			return process_btinode(dip, itype);
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_LOCAL:
+		if (!dont_obfuscate)
+			switch (itype) {
+			case TYP_DIR2:
+				obfuscate_sf_dir(dip);
+				break;
+			case TYP_SYMLINK:
+				obfuscate_sf_symlink(dip);
+				break;
+			default:
+				;
+		}
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		return process_exinode(dip, itype);
+	case XFS_DINODE_FMT_BTREE:
+		return process_btinode(dip, itype);
 	}
 	return 1;
 }
@@ -1179,7 +1177,7 @@
 	cur_ino = XFS_AGINO_TO_INO(mp, agno, agino);
 
 	/* copy appropriate data fork metadata */
-	switch (be16_to_cpu(dip->di_core.di_mode) & S_IFMT) {
+	switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
 		case S_IFDIR:
 			memset(&dir_data, 0, sizeof(dir_data));
 			success = process_inode_data(dip, TYP_DIR2);
@@ -1197,7 +1195,7 @@
 	/* copy extended attributes if they exist and forkoff is valid */
 	if (success && XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
 		attr_data.remote_val_count = 0;
-		switch (dip->di_core.di_aformat) {
+		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
 				if (!dont_obfuscate)
 					obfuscate_sf_attr(dip);
Index: xfs-cmds/xfsprogs/libxfs/util.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/util.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/libxfs/util.c	2008-12-06 20:05:49.000000000 +0100
@@ -47,126 +47,6 @@
 }
 
 /*
- * Given a mount structure and an inode number, return a pointer
- * to a newly allocated in-core inode coresponding to the given
- * inode number.
- *
- * Initialize the inode's attributes and extent pointers if it
- * already has them (it will not if the inode has no links).
- *
- * NOTE: this has slightly different behaviour to the kernel in
- * that this version requires the already allocated *ip being 
- * passed in while the kernel version does the allocation and 
- * returns it in **ip.
- */
-int
-libxfs_iread(
-	xfs_mount_t     *mp,
-	xfs_trans_t	*tp,
-	xfs_ino_t	ino,
-	xfs_inode_t	*ip,
-	xfs_daddr_t	bno)
-{
-	xfs_buf_t	*bp;
-	xfs_dinode_t	*dip;
-	int		error;
-
-	ip->i_ino = ino;
-	ip->i_mount = mp;
-
-	/*
-	 * Get pointer's to the on-disk inode and the buffer containing it.
-	 * If the inode number refers to a block outside the file system
-	 * then xfs_itobp() will return NULL.  In this case we should
-	 * return NULL as well.  Set i_blkno to 0 so that xfs_itobp() will
-	 * know that this is a new incore inode.
-	 */
-	error = xfs_itobp(mp, tp, ip, &dip, &bp, bno, 0, XFS_BUF_LOCK);
-	if (error) 
-		return error;
-
-	/*
-	 * If we got something that isn't an inode it means someone
-	 * (nfs or dmi) has a stale handle.
-	 */
-	if (be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC) {
-		xfs_trans_brelse(tp, bp);
-		return EINVAL;
-	}
-
-	/*
-	 * If the on-disk inode is already linked to a directory
-	 * entry, copy all of the inode into the in-core inode.
-	 * xfs_iformat() handles copying in the inode format
-	 * specific information.
-	 * Otherwise, just get the truly permanent information.
-	 */
-	if (dip->di_core.di_mode) {
-		xfs_dinode_from_disk(&ip->i_d, &dip->di_core);
-		error = xfs_iformat(ip, dip);
-		if (error)  {
-			xfs_trans_brelse(tp, bp);
-			return error;
-		}
-	} else {
-		ip->i_d.di_magic = be16_to_cpu(dip->di_core.di_magic);
-		ip->i_d.di_version = dip->di_core.di_version;
-		ip->i_d.di_gen = be32_to_cpu(dip->di_core.di_gen);
-		ip->i_d.di_flushiter = be16_to_cpu(dip->di_core.di_flushiter);
-		/*
-		 * Make sure to pull in the mode here as well in
-		 * case the inode is released without being used.
-		 * This ensures that xfs_inactive() will see that
-		 * the inode is already free and not try to mess
-		 * with the uninitialized part of it.
-		 */
-		ip->i_d.di_mode = 0;
-		/*
-		 * Initialize the per-fork minima and maxima for a new
-		 * inode here.  xfs_iformat will do it for old inodes.
-		 */
-		ip->i_df.if_ext_max =
-			XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
-	}
-
-	/*
-	 * The inode format changed when we moved the link count and
-	 * made it 32 bits long.  If this is an old format inode,
-	 * convert it in memory to look like a new one.  If it gets
-	 * flushed to disk we will convert back before flushing or
-	 * logging it.  We zero out the new projid field and the old link
-	 * count field.  We'll handle clearing the pad field (the remains
-	 * of the old uuid field) when we actually convert the inode to
-	 * the new format. We don't change the version number so that we
-	 * can distinguish this from a real new format inode.
-	 */
-	if (ip->i_d.di_version == XFS_DINODE_VERSION_1) {
-		ip->i_d.di_nlink = ip->i_d.di_onlink;
-		ip->i_d.di_onlink = 0;
-		ip->i_d.di_projid = 0;
-	}
-
-	ip->i_delayed_blks = 0;
-	ip->i_size = ip->i_d.di_size;
-
-	/*
-	 * Use xfs_trans_brelse() to release the buffer containing the
-	 * on-disk inode, because it was acquired with xfs_trans_read_buf()
-	 * in xfs_itobp() above.  If tp is NULL, this is just a normal
-	 * brelse().  If we're within a transaction, then xfs_trans_brelse()
-	 * will only release the buffer if it is not dirty within the
-	 * transaction.  It will be OK to release the buffer in this case,
-	 * because inodes on disk are never destroyed and we will be
-	 * locking the new in-core inode before putting it in the hash
-	 * table where other processes can find it.  Thus we don't have
-	 * to worry about the inode being changed just because we released
-	 * the buffer.
-	 */
-	xfs_trans_brelse(tp, bp);
-	return 0;
-}
-
-/*
  * Allocate an inode on disk and return a copy of it's in-core version.
  * Set mode, nlink, and rdev appropriately within the inode.
  * The uid and gid for the inode are set according to the contents of
@@ -229,8 +109,8 @@
 	 * here rather than here and in the flush/logging code.
 	 */
 	if (xfs_sb_version_hasnlink(&tp->t_mountp->m_sb) &&
-	    ip->i_d.di_version == XFS_DINODE_VERSION_1) {
-		ip->i_d.di_version = XFS_DINODE_VERSION_2;
+	    ip->i_d.di_version == 1) {
+		ip->i_d.di_version = 2;
 		/* old link count, projid field, pad field already zeroed */
 	}
 
@@ -395,7 +275,7 @@
 	mp = ip->i_mount;
 
 	/* set *dip = inode's place in the buffer */
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_boffset);
+	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
 	ASSERT(ip->i_d.di_magic == XFS_DINODE_MAGIC);
 	if ((ip->i_d.di_mode & S_IFMT) == S_IFREG) {
@@ -416,7 +296,7 @@
 	 * because if the inode is dirty at all the core must
 	 * be.
 	 */
-	xfs_dinode_to_disk(&dip->di_core, &ip->i_d);
+	xfs_dinode_to_disk(dip, &ip->i_d);
 
 	/*
 	 * If this is really an old format inode and the superblock version
@@ -424,28 +304,26 @@
 	 * convert back to the old inode format.  If the superblock version
 	 * has been updated, then make the conversion permanent.
 	 */
-	ASSERT(ip->i_d.di_version == XFS_DINODE_VERSION_1 ||
-		xfs_sb_version_hasnlink(&mp->m_sb));
-	if (ip->i_d.di_version == XFS_DINODE_VERSION_1) {
+	ASSERT(ip->i_d.di_version == 1 || xfs_sb_version_hasnlink(&mp->m_sb));
+	if (ip->i_d.di_version == 1) {
 		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
 			/*
 			 * Convert it back.
 			 */
 			ASSERT(ip->i_d.di_nlink <= XFS_MAXLINK_1);
-			dip->di_core.di_onlink = cpu_to_be16(ip->i_d.di_nlink);
+			dip->di_onlink = cpu_to_be16(ip->i_d.di_nlink);
 		} else {
 			/*
 			 * The superblock version has already been bumped,
 			 * so just make the conversion to the new inode
 			 * format permanent.
 			 */
-			ip->i_d.di_version = XFS_DINODE_VERSION_2;
-			dip->di_core.di_version =  XFS_DINODE_VERSION_2;
+			ip->i_d.di_version = 2;
+			dip->di_version = 2;
 			ip->i_d.di_onlink = 0;
-			dip->di_core.di_onlink = 0;
-			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
-			memset(&(dip->di_core.di_pad[0]), 0,
-			      sizeof(dip->di_core.di_pad));
+			dip->di_onlink = 0;
+			memset(&ip->i_d.di_pad[0], 0, sizeof(ip->i_d.di_pad));
+			memset(&dip->di_pad[0], 0, sizeof(dip->di_pad));
 			ASSERT(ip->i_d.di_projid == 0);
 		}
 	}
Index: xfs-cmds/xfsprogs/libxfs/xfs_alloc.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_alloc.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/libxfs/xfs_alloc.c	2008-12-06 20:05:49.000000000 +0100
@@ -2064,44 +2064,41 @@
  * Read in the allocation group header (free/alloc section).
  */
 int					/* error */
-xfs_alloc_read_agf(
-	xfs_mount_t	*mp,		/* mount point structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	int		flags,		/* XFS_ALLOC_FLAG_... */
-	xfs_buf_t	**bpp)		/* buffer for the ag freelist header */
+xfs_read_agf(
+	struct xfs_mount	*mp,	/* mount point structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	int			flags,	/* XFS_BUF_ */
+	struct xfs_buf		**bpp)	/* buffer for the ag freelist header */
 {
-	xfs_agf_t	*agf;		/* ag freelist header */
+	struct xfs_agf	*agf;		/* ag freelist header */
 	int		agf_ok;		/* set if agf is consistent */
-	xfs_buf_t	*bp;		/* return value */
-	xfs_perag_t	*pag;		/* per allocation group data */
 	int		error;
 
 	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_trans_read_buf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1),
-			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XFS_BUF_TRYLOCK : 0U,
-			&bp);
+			XFS_FSS_TO_BB(mp, 1), flags, bpp);
 	if (error)
 		return error;
-	ASSERT(!bp || !XFS_BUF_GETERROR(bp));
-	if (!bp) {
-		*bpp = NULL;
+	if (!*bpp)
 		return 0;
-	}
+
+	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	agf = XFS_BUF_TO_AGF(*bpp);
+
 	/*
 	 * Validate the magic number of the agf block.
 	 */
-	agf = XFS_BUF_TO_AGF(bp);
 	agf_ok =
 		be32_to_cpu(agf->agf_magicnum) == XFS_AGF_MAGIC &&
 		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
 		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
 		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
 		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
-		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp);
+		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp) &&
+		be32_to_cpu(agf->agf_seqno) == agno;
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
 		agf_ok = agf_ok && be32_to_cpu(agf->agf_btreeblks) <=
 						be32_to_cpu(agf->agf_length);
@@ -2109,9 +2106,41 @@
 			XFS_RANDOM_ALLOC_READ_AGF))) {
 		XFS_CORRUPTION_ERROR("xfs_alloc_read_agf",
 				     XFS_ERRLEVEL_LOW, mp, agf);
-		xfs_trans_brelse(tp, bp);
+		xfs_trans_brelse(tp, *bpp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
+
+	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGF, XFS_AGF_REF);
+	return 0;
+}
+
+/*
+ * Read in the allocation group header (free/alloc section).
+ */
+int					/* error */
+xfs_alloc_read_agf(
+	struct xfs_mount	*mp,	/* mount point structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	int			flags,	/* XFS_ALLOC_FLAG_... */
+	struct xfs_buf		**bpp)	/* buffer for the ag freelist header */
+{
+	struct xfs_agf		*agf;		/* ag freelist header */
+	struct xfs_perag	*pag;		/* per allocation group data */
+	int			error;
+
+	ASSERT(agno != NULLAGNUMBER);
+
+	error = xfs_read_agf(mp, tp, agno,
+			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XFS_BUF_TRYLOCK : 0,
+			bpp);
+	if (error)
+		return error;
+	if (!*bpp)
+		return 0;
+	ASSERT(!XFS_BUF_GETERROR(*bpp));
+
+	agf = XFS_BUF_TO_AGF(*bpp);
 	pag = &mp->m_perag[agno];
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
@@ -2139,8 +2168,6 @@
 		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
 	}
 #endif
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGF, XFS_AGF_REF);
-	*bpp = bp;
 	return 0;
 }
 
Index: xfs-cmds/xfsprogs/libxfs/xfs_ialloc.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_ialloc.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/libxfs/xfs_ialloc.c	2008-12-06 20:05:49.000000000 +0100
@@ -22,68 +22,6 @@
  * Internal functions.
  */
 
-/*
- * Log specified fields for the inode given by bp and off.
- */
-STATIC void
-xfs_ialloc_log_di(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_buf_t	*bp,		/* inode buffer */
-	int		off,		/* index of inode in buffer */
-	int		fields)		/* bitmask of fields to log */
-{
-	int			first;		/* first byte number */
-	int			ioffset;	/* off in bytes */
-	int			last;		/* last byte number */
-	xfs_mount_t		*mp;		/* mount point structure */
-	static const short	offsets[] = {	/* field offsets */
-						/* keep in sync with bits */
-		offsetof(xfs_dinode_core_t, di_magic),
-		offsetof(xfs_dinode_core_t, di_mode),
-		offsetof(xfs_dinode_core_t, di_version),
-		offsetof(xfs_dinode_core_t, di_format),
-		offsetof(xfs_dinode_core_t, di_onlink),
-		offsetof(xfs_dinode_core_t, di_uid),
-		offsetof(xfs_dinode_core_t, di_gid),
-		offsetof(xfs_dinode_core_t, di_nlink),
-		offsetof(xfs_dinode_core_t, di_projid),
-		offsetof(xfs_dinode_core_t, di_pad),
-		offsetof(xfs_dinode_core_t, di_atime),
-		offsetof(xfs_dinode_core_t, di_mtime),
-		offsetof(xfs_dinode_core_t, di_ctime),
-		offsetof(xfs_dinode_core_t, di_size),
-		offsetof(xfs_dinode_core_t, di_nblocks),
-		offsetof(xfs_dinode_core_t, di_extsize),
-		offsetof(xfs_dinode_core_t, di_nextents),
-		offsetof(xfs_dinode_core_t, di_anextents),
-		offsetof(xfs_dinode_core_t, di_forkoff),
-		offsetof(xfs_dinode_core_t, di_aformat),
-		offsetof(xfs_dinode_core_t, di_dmevmask),
-		offsetof(xfs_dinode_core_t, di_dmstate),
-		offsetof(xfs_dinode_core_t, di_flags),
-		offsetof(xfs_dinode_core_t, di_gen),
-		offsetof(xfs_dinode_t, di_next_unlinked),
-		offsetof(xfs_dinode_t, di_u),
-		offsetof(xfs_dinode_t, di_a),
-		sizeof(xfs_dinode_t)
-	};
-
-
-	ASSERT(offsetof(xfs_dinode_t, di_core) == 0);
-	ASSERT((fields & (XFS_DI_U|XFS_DI_A)) == 0);
-	mp = tp->t_mountp;
-	/*
-	 * Get the inode-relative first and last bytes for these fields
-	 */
-	xfs_btree_offsets(fields, offsets, XFS_DI_NUM_BITS, &first, &last);
-	/*
-	 * Convert to buffer offsets and log it.
-	 */
-	ioffset = off << mp->m_sb.sb_inodelog;
-	first += ioffset;
-	last += ioffset;
-	xfs_trans_log_buf(tp, bp, first, last);
-}
 
 /*
  * Allocation group level functions.
@@ -364,9 +302,9 @@
 	 * able to use the file system.
 	 */
 	if (xfs_sb_version_hasnlink(&args.mp->m_sb))
-		version = XFS_DINODE_VERSION_2;
+		version = 2;
 	else
-		version = XFS_DINODE_VERSION_1;
+		version = 1;
 
 	/*
 	 * Seed the new inode cluster with a random generation number. This
@@ -387,18 +325,25 @@
 					 XFS_BUF_LOCK);
 		ASSERT(fbuf);
 		ASSERT(!XFS_BUF_GETERROR(fbuf));
+
 		/*
-		 * Set initial values for the inodes in this buffer.
+		 * Initialize all inodes in this buffer and then log them.
+		 *
+		 * XXX: It would be much better if we had just one transaction to
+		 *      log a whole cluster of inodes instead of all the indivdual
+		 *      transactions causing a lot of log traffic.
 		 */
 		xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
 		for (i = 0; i < ninodes; i++) {
+			int	ioffset = i << args.mp->m_sb.sb_inodelog;
+			uint	isize = sizeof(struct xfs_dinode);
+
 			free = XFS_MAKE_IPTR(args.mp, fbuf, i);
-			free->di_core.di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
-			free->di_core.di_version = version;
-			free->di_core.di_gen = cpu_to_be32(gen);
+			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+			free->di_version = version;
+			free->di_gen = cpu_to_be32(gen);
 			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
-			xfs_ialloc_log_di(tp, fbuf, i,
-				XFS_DI_CORE_BITS | XFS_DI_NEXT_UNLINKED);
+			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
 		}
 		xfs_trans_inode_alloc_buf(tp, fbuf);
 	}
@@ -1019,38 +964,29 @@
 	return error;
 }
 
-
 /*
- * Return the location of the inode in bno/off, for mapping it into a buffer.
+ * Return the location of the inode in imap, for mapping it into a buffer.
  */
-/*ARGSUSED*/
 int
-xfs_dilocate(
-	xfs_mount_t	*mp,	/* file system mount structure */
-	xfs_trans_t	*tp,	/* transaction pointer */
+xfs_imap(
+	xfs_mount_t	 *mp,	/* file system mount structure */
+	xfs_trans_t	 *tp,	/* transaction pointer */
 	xfs_ino_t	ino,	/* inode to locate */
-	xfs_fsblock_t	*bno,	/* output: block containing inode */
-	int		*len,	/* output: num blocks in inode cluster */
-	int		*off,	/* output: index in block of inode */
-	uint		flags)	/* flags concerning inode lookup */
+	struct xfs_imap	*imap,	/* location map structure */
+	uint		flags)	/* flags for inode btree lookup */
 {
 	xfs_agblock_t	agbno;	/* block number of inode in the alloc group */
-	xfs_buf_t	*agbp;	/* agi buffer */
 	xfs_agino_t	agino;	/* inode number within alloc group */
 	xfs_agnumber_t	agno;	/* allocation group number */
 	int		blks_per_cluster; /* num blocks per inode cluster */
 	xfs_agblock_t	chunk_agbno;	/* first block in inode chunk */
-	xfs_agino_t	chunk_agino;	/* first agino in inode chunk */
-	__int32_t	chunk_cnt;	/* count of free inodes in chunk */
-	xfs_inofree_t	chunk_free;	/* mask of free inodes in chunk */
 	xfs_agblock_t	cluster_agbno;	/* first block in inode cluster */
-	xfs_btree_cur_t	*cur;	/* inode btree cursor */
 	int		error;	/* error code */
-	int		i;	/* temp state */
 	int		offset;	/* index of inode in its buffer */
 	int		offset_agbno;	/* blks from chunk start to inode */
 
 	ASSERT(ino != NULLFSINO);
+
 	/*
 	 * Split up the inode number into its parts.
 	 */
@@ -1061,24 +997,24 @@
 	    ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
 #ifdef DEBUG
 		/* no diagnostics for bulkstat, ino comes from userspace */
-		if (flags & XFS_IMAP_BULKSTAT)
+		if (flags & XFS_IGET_BULKSTAT)
 			return XFS_ERROR(EINVAL);
 		if (agno >= mp->m_sb.sb_agcount) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xfs_dilocate: agno (%d) >= "
+					"xfs_imap: agno (%d) >= "
 					"mp->m_sb.sb_agcount (%d)",
 					agno,  mp->m_sb.sb_agcount);
 		}
 		if (agbno >= mp->m_sb.sb_agblocks) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xfs_dilocate: agbno (0x%llx) >= "
+					"xfs_imap: agbno (0x%llx) >= "
 					"mp->m_sb.sb_agblocks (0x%lx)",
 					(unsigned long long) agbno,
 					(unsigned long) mp->m_sb.sb_agblocks);
 		}
 		if (ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xfs_dilocate: ino (0x%llx) != "
+					"xfs_imap: ino (0x%llx) != "
 					"XFS_AGINO_TO_INO(mp, agno, agino) "
 					"(0x%llx)",
 					ino, XFS_AGINO_TO_INO(mp, agno, agino));
@@ -1087,64 +1023,89 @@
 #endif /* DEBUG */
 		return XFS_ERROR(EINVAL);
 	}
-	if ((mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) ||
-	    !(flags & XFS_IMAP_LOOKUP)) {
+
+	/*
+	 * If the inode cluster size is the same as the blocksize or
+	 * smaller we get to the buffer by simple arithmetics.
+	 */
+	if (XFS_INODE_CLUSTER_SIZE(mp) <= mp->m_sb.sb_blocksize) {
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
-		*bno = XFS_AGB_TO_FSB(mp, agno, agbno);
-		*off = offset;
-		*len = 1;
+
+		imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		imap->im_len = XFS_FSB_TO_BB(mp, 1);
+		imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
 		return 0;
 	}
+
 	blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
-	if (*bno != NULLFSBLOCK) {
+
+	/*
+	 * If we get a block number passed from bulkstat we can use it to
+	 * find the buffer easily.
+	 */
+	if (imap->im_blkno) {
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
-		cluster_agbno = XFS_FSB_TO_AGBNO(mp, *bno);
-		*off = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
-			offset;
-		*len = blks_per_cluster;
+
+		cluster_agbno = XFS_DADDR_TO_AGBNO(mp, imap->im_blkno);
+		offset += (agbno - cluster_agbno) * mp->m_sb.sb_inopblock;
+
+		imap->im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
+		imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
 		return 0;
 	}
+
+	/*
+	 * If the inode chunks are aligned then use simple maths to
+	 * find the location. Otherwise we have to do a btree
+	 * lookup to find the location.
+	 */
 	if (mp->m_inoalign_mask) {
 		offset_agbno = agbno & mp->m_inoalign_mask;
 		chunk_agbno = agbno - offset_agbno;
 	} else {
+		xfs_btree_cur_t	*cur;	/* inode btree cursor */
+		xfs_agino_t	chunk_agino; /* first agino in inode chunk */
+		__int32_t	chunk_cnt; /* count of free inodes in chunk */
+		xfs_inofree_t	chunk_free; /* mask of free inodes in chunk */
+		xfs_buf_t	*agbp;	/* agi buffer */
+		int		i;	/* temp state */
+
 		down_read(&mp->m_peraglock);
 		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
 		up_read(&mp->m_peraglock);
 		if (error) {
-#ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
+			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
 					"xfs_ialloc_read_agi() returned "
 					"error %d, agno %d",
 					error, agno);
-#endif /* DEBUG */
 			return error;
 		}
+
 		cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
-		if ((error = xfs_inobt_lookup_le(cur, agino, 0, 0, &i))) {
-#ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
+		error = xfs_inobt_lookup_le(cur, agino, 0, 0, &i);
+		if (error) {
+			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
 					"xfs_inobt_lookup_le() failed");
-#endif /* DEBUG */
 			goto error0;
 		}
-		if ((error = xfs_inobt_get_rec(cur, &chunk_agino, &chunk_cnt,
-				&chunk_free, &i))) {
-#ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
+
+		error = xfs_inobt_get_rec(cur, &chunk_agino, &chunk_cnt,
+				&chunk_free, &i);
+		if (error) {
+			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
 					"xfs_inobt_get_rec() failed");
-#endif /* DEBUG */
 			goto error0;
 		}
 		if (i == 0) {
 #ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
+			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
 					"xfs_inobt_get_rec() failed");
 #endif /* DEBUG */
 			error = XFS_ERROR(EINVAL);
 		}
+ error0:
 		xfs_trans_brelse(tp, agbp);
 		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 		if (error)
@@ -1152,19 +1113,35 @@
 		chunk_agbno = XFS_AGINO_TO_AGBNO(mp, chunk_agino);
 		offset_agbno = agbno - chunk_agbno;
 	}
+
 	ASSERT(agbno >= chunk_agbno);
 	cluster_agbno = chunk_agbno +
 		((offset_agbno / blks_per_cluster) * blks_per_cluster);
 	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
 		XFS_INO_TO_OFFSET(mp, ino);
-	*bno = XFS_AGB_TO_FSB(mp, agno, cluster_agbno);
-	*off = offset;
-	*len = blks_per_cluster;
+
+	imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, cluster_agbno);
+	imap->im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
+	imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
+
+	/*
+	 * If the inode number maps to a block outside the bounds
+	 * of the file system then return NULL rather than calling
+	 * read_buf and panicing when we get an error from the
+	 * driver.
+	 */
+	if ((imap->im_blkno + imap->im_len) >
+	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
+		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
+			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
+			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
+			(unsigned long long) imap->im_blkno,
+			(unsigned long long) imap->im_len,
+			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
+		return XFS_ERROR(EINVAL);
+	}
+
 	return 0;
-error0:
-	xfs_trans_brelse(tp, agbp);
-	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-	return error;
 }
 
 /*
@@ -1232,70 +1209,95 @@
 	xfs_trans_log_buf(tp, bp, first, last);
 }
 
+#ifdef DEBUG
+STATIC void
+xfs_check_agi_unlinked(
+	struct xfs_agi		*agi)
+{
+	int			i;
+
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
+		ASSERT(agi->agi_unlinked[i]);
+}
+#else
+#define xfs_check_agi_unlinked(agi)
+#endif
+
 /*
  * Read in the allocation group header (inode allocation section)
  */
 int
-xfs_ialloc_read_agi(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_buf_t	**bpp)		/* allocation group hdr buf */
+xfs_read_agi(
+	struct xfs_mount	*mp,	/* file system mount structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	struct xfs_buf		**bpp)	/* allocation group hdr buf */
 {
-	xfs_agi_t	*agi;		/* allocation group header */
-	int		agi_ok;		/* agi is consistent */
-	xfs_buf_t	*bp;		/* allocation group hdr buf */
-	xfs_perag_t	*pag;		/* per allocation group data */
-	int		error;
+	struct xfs_agi		*agi;	/* allocation group header */
+	int			agi_ok;	/* agi is consistent */
+	int			error;
 
 	ASSERT(agno != NULLAGNUMBER);
-	error = xfs_trans_read_buf(
-			mp, tp, mp->m_ddev_targp,
+
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, &bp);
+			XFS_FSS_TO_BB(mp, 1), 0, bpp);
 	if (error)
 		return error;
-	ASSERT(bp && !XFS_BUF_GETERROR(bp));
+
+	ASSERT(*bpp && !XFS_BUF_GETERROR(*bpp));
+	agi = XFS_BUF_TO_AGI(*bpp);
 
 	/*
 	 * Validate the magic number of the agi block.
 	 */
-	agi = XFS_BUF_TO_AGI(bp);
-	agi_ok =
-		be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
-		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum));
+	agi_ok = be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC &&
+		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)) &&
+		be32_to_cpu(agi->agi_seqno) == agno;
 	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
 			XFS_RANDOM_IALLOC_READ_AGI))) {
-		XFS_CORRUPTION_ERROR("xfs_ialloc_read_agi", XFS_ERRLEVEL_LOW,
+		XFS_CORRUPTION_ERROR("xfs_read_agi", XFS_ERRLEVEL_LOW,
 				     mp, agi);
-		xfs_trans_brelse(tp, bp);
+		xfs_trans_brelse(tp, *bpp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
+
+	XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_AGI, XFS_AGI_REF);
+
+	xfs_check_agi_unlinked(agi);
+	return 0;
+}
+
+int
+xfs_ialloc_read_agi(
+	struct xfs_mount	*mp,	/* file system mount structure */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_agnumber_t		agno,	/* allocation group number */
+	struct xfs_buf		**bpp)	/* allocation group hdr buf */
+{
+	struct xfs_agi		*agi;	/* allocation group header */
+	struct xfs_perag	*pag;	/* per allocation group data */
+	int			error;
+
+	error = xfs_read_agi(mp, tp, agno, bpp);
+	if (error)
+		return error;
+
+	agi = XFS_BUF_TO_AGI(*bpp);
 	pag = &mp->m_perag[agno];
+
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 		pag->pagi_count = be32_to_cpu(agi->agi_count);
 		pag->pagi_init = 1;
-	} else {
-		/*
-		 * It's possible for these to be out of sync if
-		 * we are in the middle of a forced shutdown.
-		 */
-		ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-			XFS_FORCED_SHUTDOWN(mp));
-	}
-
-#ifdef DEBUG
-	{
-		int	i;
-
-		for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
-			ASSERT(agi->agi_unlinked[i]);
 	}
-#endif
 
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGI, XFS_AGI_REF);
-	*bpp = bp;
+	/*
+	 * It's possible for these to be out of sync if
+	 * we are in the middle of a forced shutdown.
+	 */
+	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
+		XFS_FORCED_SHUTDOWN(mp));
 	return 0;
 }
 
Index: xfs-cmds/xfsprogs/libxfs/xfs_inode.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_inode.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/libxfs/xfs_inode.c	2008-12-06 20:05:49.000000000 +0100
@@ -91,10 +91,10 @@
 xfs_imap_to_bp(
 	xfs_mount_t	*mp,
 	xfs_trans_t	*tp,
-	xfs_imap_t	*imap,
+	struct xfs_imap	*imap,
 	xfs_buf_t	**bpp,
 	uint		buf_flags,
-	uint		imap_flags)
+	uint		iget_flags)
 {
 	int		error;
 	int		i;
@@ -131,12 +131,12 @@
 
 		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
 					(i << mp->m_sb.sb_inodelog));
-		di_ok = be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC &&
-			    XFS_DINODE_GOOD_VERSION(dip->di_core.di_version);
+		di_ok = be16_to_cpu(dip->di_magic) == XFS_DINODE_MAGIC &&
+			    XFS_DINODE_GOOD_VERSION(dip->di_version);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP,
 						XFS_RANDOM_ITOBP_INOTOBP))) {
-			if (imap_flags & XFS_IMAP_BULKSTAT) {
+			if (iget_flags & XFS_IGET_BULKSTAT) {
 				xfs_trans_brelse(tp, bp);
 				return XFS_ERROR(EINVAL);
 			}
@@ -148,7 +148,7 @@
 					"daddr %lld #%d (magic=%x)",
 				XFS_BUFTARG_NAME(mp->m_ddev_targp),
 				(unsigned long long)imap->im_blkno, i,
-				be16_to_cpu(dip->di_core.di_magic));
+				be16_to_cpu(dip->di_magic));
 #endif
 			xfs_trans_brelse(tp, bp);
 			return XFS_ERROR(EFSCORRUPTED);
@@ -167,6 +167,49 @@
 }
 
 /*
+ * This routine is called to map an inode number within a file
+ * system to the buffer containing the on-disk version of the
+ * inode.  It returns a pointer to the buffer containing the
+ * on-disk inode in the bpp parameter, and in the dip parameter
+ * it returns a pointer to the on-disk inode within that buffer.
+ *
+ * If a non-zero error is returned, then the contents of bpp and
+ * dipp are undefined.
+ *
+ * Use xfs_imap() to determine the size and location of the
+ * buffer to read from disk.
+ */
+int
+xfs_inotobp(
+	xfs_mount_t	*mp,
+	xfs_trans_t	*tp,
+	xfs_ino_t	ino,
+	xfs_dinode_t	**dipp,
+	xfs_buf_t	**bpp,
+	int		*offset,
+	uint		imap_flags)
+{
+	struct xfs_imap	imap;
+	xfs_buf_t	*bp;
+	int		error;
+
+	imap.im_blkno = 0;
+	error = xfs_imap(mp, tp, ino, &imap, imap_flags);
+	if (error)
+		return error;
+
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, imap_flags);
+	if (error)
+		return error;
+
+	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
+	*bpp = bp;
+	*offset = imap.im_boffset;
+	return 0;
+}
+
+
+/*
  * This routine is called to map an inode to the buffer containing
  * the on-disk version of the inode.  It returns a pointer to the
  * buffer containing the on-disk inode in the bpp parameter, and in
@@ -176,15 +219,11 @@
  * If a non-zero error is returned, then the contents of bpp and
  * dipp are undefined.
  *
- * If the inode is new and has not yet been initialized, use xfs_imap()
- * to determine the size and location of the buffer to read from disk.
- * If the inode has already been mapped to its buffer and read in once,
- * then use the mapping information stored in the inode rather than
- * calling xfs_imap().  This allows us to avoid the overhead of looking
- * at the inode btree for small block file systems (see xfs_dilocate()).
- * We can tell whether the inode has been mapped in before by comparing
- * its disk block address to 0.  Only uninitialized inodes will have
- * 0 for the disk block address.
+ * The inode is expected to already been mapped to its buffer and read
+ * in once, thus we can use the mapping information stored in the inode
+ * rather than calling xfs_imap().  This allows us to avoid the overhead
+ * of looking at the inode btree for small block file systems
+ * (see xfs_imap()).
  */
 int
 xfs_itobp(
@@ -193,40 +232,14 @@
 	xfs_inode_t	*ip,
 	xfs_dinode_t	**dipp,
 	xfs_buf_t	**bpp,
-	xfs_daddr_t	bno,
-	uint		imap_flags,
 	uint		buf_flags)
 {
-	xfs_imap_t	imap;
 	xfs_buf_t	*bp;
 	int		error;
 
-	if (ip->i_blkno == (xfs_daddr_t)0) {
-		imap.im_blkno = bno;
-		error = xfs_imap(mp, tp, ip->i_ino, &imap,
-					XFS_IMAP_LOOKUP | imap_flags);
-		if (error)
-			return error;
-
-		/*
-		 * Fill in the fields in the inode that will be used to
-		 * map the inode to its buffer from now on.
-		 */
-		ip->i_blkno = imap.im_blkno;
-		ip->i_len = imap.im_len;
-		ip->i_boffset = imap.im_boffset;
-	} else {
-		/*
-		 * We've already mapped the inode once, so just use the
-		 * mapping that we saved the first time.
-		 */
-		imap.im_blkno = ip->i_blkno;
-		imap.im_len = ip->i_len;
-		imap.im_boffset = ip->i_boffset;
-	}
-	ASSERT(bno == 0 || bno == imap.im_blkno);
+	ASSERT(ip->i_imap.im_blkno != 0);
 
-	error = xfs_imap_to_bp(mp, tp, &imap, &bp, buf_flags, imap_flags);
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp, buf_flags, 0);
 	if (error)
 		return error;
 
@@ -237,7 +250,7 @@
 		return EAGAIN;
 	}
 
-	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
+	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 	*bpp = bp;
 	return 0;
 }
@@ -250,10 +263,8 @@
  * pointers.  For a file in B-tree format, only the root is immediately
  * brought in-core.  The rest will be in-lined in if_extents when it
  * is first referenced (see xfs_iread_extents()).
- *
- * Note: this requires user-space public scope for libxfs_iread
  */
-int
+STATIC int
 xfs_iformat(
 	xfs_inode_t		*ip,
 	xfs_dinode_t		*dip)
@@ -266,26 +277,26 @@
 		XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
 	error = 0;
 
-	if (unlikely(be32_to_cpu(dip->di_core.di_nextents) +
-		     be16_to_cpu(dip->di_core.di_anextents) >
-		     be64_to_cpu(dip->di_core.di_nblocks))) {
+	if (unlikely(be32_to_cpu(dip->di_nextents) +
+		     be16_to_cpu(dip->di_anextents) >
+		     be64_to_cpu(dip->di_nblocks))) {
 		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 			"corrupt dinode %Lu, extent total = %d, nblocks = %Lu.",
 			(unsigned long long)ip->i_ino,
-			(int)(be32_to_cpu(dip->di_core.di_nextents) +
-			      be16_to_cpu(dip->di_core.di_anextents)),
+			(int)(be32_to_cpu(dip->di_nextents) +
+			      be16_to_cpu(dip->di_anextents)),
 			(unsigned long long)
-				be64_to_cpu(dip->di_core.di_nblocks));
+				be64_to_cpu(dip->di_nblocks));
 		XFS_CORRUPTION_ERROR("xfs_iformat(1)", XFS_ERRLEVEL_LOW,
 				     ip->i_mount, dip);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
-	if (unlikely(dip->di_core.di_forkoff > ip->i_mount->m_sb.sb_inodesize)) {
+	if (unlikely(dip->di_forkoff > ip->i_mount->m_sb.sb_inodesize)) {
 		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 			"corrupt dinode %Lu, forkoff = 0x%x.",
 			(unsigned long long)ip->i_ino,
-			dip->di_core.di_forkoff);
+			dip->di_forkoff);
 		XFS_CORRUPTION_ERROR("xfs_iformat(2)", XFS_ERRLEVEL_LOW,
 				     ip->i_mount, dip);
 		return XFS_ERROR(EFSCORRUPTED);
@@ -296,25 +307,25 @@
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFSOCK:
-		if (unlikely(dip->di_core.di_format != XFS_DINODE_FMT_DEV)) {
+		if (unlikely(dip->di_format != XFS_DINODE_FMT_DEV)) {
 			XFS_CORRUPTION_ERROR("xfs_iformat(3)", XFS_ERRLEVEL_LOW,
 					      ip->i_mount, dip);
 			return XFS_ERROR(EFSCORRUPTED);
 		}
 		ip->i_d.di_size = 0;
 		ip->i_size = 0;
-		ip->i_df.if_u2.if_rdev = be32_to_cpu(dip->di_u.di_dev);
+		ip->i_df.if_u2.if_rdev = xfs_dinode_get_rdev(dip);
 		break;
 
 	case S_IFREG:
 	case S_IFLNK:
 	case S_IFDIR:
-		switch (dip->di_core.di_format) {
+		switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
 			/*
 			 * no local regular files yet
 			 */
-			if (unlikely((be16_to_cpu(dip->di_core.di_mode) & S_IFMT) == S_IFREG)) {
+			if (unlikely((be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFREG)) {
 				xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 					"corrupt inode %Lu "
 					"(local format for regular file).",
@@ -325,7 +336,7 @@
 				return XFS_ERROR(EFSCORRUPTED);
 			}
 
-			di_size = be64_to_cpu(dip->di_core.di_size);
+			di_size = be64_to_cpu(dip->di_size);
 			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
 				xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 					"corrupt inode %Lu "
@@ -367,7 +378,7 @@
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
 	ip->i_afp->if_ext_max =
 		XFS_IFORK_ASIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
-	switch (dip->di_core.di_aformat) {
+	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
 		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		size = be16_to_cpu(atp->hdr.totsize);
@@ -579,7 +590,7 @@
 void
 xfs_dinode_from_disk(
 	xfs_icdinode_t		*to,
-	xfs_dinode_core_t	*from)
+	xfs_dinode_t		*from)
 {
 	to->di_magic = be16_to_cpu(from->di_magic);
 	to->di_mode = be16_to_cpu(from->di_mode);
@@ -613,7 +624,7 @@
 
 void
 xfs_dinode_to_disk(
-	xfs_dinode_core_t	*to,
+	xfs_dinode_t		*to,
 	xfs_icdinode_t		*from)
 {
 	to->di_magic = cpu_to_be16(from->di_magic);
@@ -647,6 +658,139 @@
 }
 
 /*
+ * Read the disk inode attributes into the in-core inode structure.
+ */
+int
+xfs_iread(
+	xfs_mount_t	*mp,
+	xfs_trans_t	*tp,
+	xfs_inode_t	*ip,
+	xfs_daddr_t	bno,
+	uint		iget_flags)
+{
+	xfs_buf_t	*bp;
+	xfs_dinode_t	*dip;
+	int		error;
+
+	/*
+	 * Fill in the location information in the in-core inode.
+	 */
+	ip->i_imap.im_blkno = bno;
+	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, iget_flags);
+	if (error)
+		return error;
+	ASSERT(bno == 0 || bno == ip->i_imap.im_blkno);
+
+	/*
+	 * Get pointers to the on-disk inode and the buffer containing it.
+	 */
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp,
+			       XFS_BUF_LOCK, iget_flags);
+	if (error)
+		return error;
+	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
+
+	/*
+	 * If we got something that isn't an inode it means someone
+	 * (nfs or dmi) has a stale handle.
+	 */
+	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC) {
+#ifdef DEBUG
+		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
+				"dip->di_magic (0x%x) != "
+				"XFS_DINODE_MAGIC (0x%x)",
+				be16_to_cpu(dip->di_magic),
+				XFS_DINODE_MAGIC);
+#endif /* DEBUG */
+		error = XFS_ERROR(EINVAL);
+		goto out_brelse;
+	}
+
+	/*
+	 * If the on-disk inode is already linked to a directory
+	 * entry, copy all of the inode into the in-core inode.
+	 * xfs_iformat() handles copying in the inode format
+	 * specific information.
+	 * Otherwise, just get the truly permanent information.
+	 */
+	if (dip->di_mode) {
+		xfs_dinode_from_disk(&ip->i_d, dip);
+		error = xfs_iformat(ip, dip);
+		if (error)  {
+#ifdef DEBUG
+			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
+					"xfs_iformat() returned error %d",
+					error);
+#endif /* DEBUG */
+			goto out_brelse;
+		}
+	} else {
+		ip->i_d.di_magic = be16_to_cpu(dip->di_magic);
+		ip->i_d.di_version = dip->di_version;
+		ip->i_d.di_gen = be32_to_cpu(dip->di_gen);
+		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
+		/*
+		 * Make sure to pull in the mode here as well in
+		 * case the inode is released without being used.
+		 * This ensures that xfs_inactive() will see that
+		 * the inode is already free and not try to mess
+		 * with the uninitialized part of it.
+		 */
+		ip->i_d.di_mode = 0;
+		/*
+		 * Initialize the per-fork minima and maxima for a new
+		 * inode here.  xfs_iformat will do it for old inodes.
+		 */
+		ip->i_df.if_ext_max =
+			XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
+	}
+
+	/*
+	 * The inode format changed when we moved the link count and
+	 * made it 32 bits long.  If this is an old format inode,
+	 * convert it in memory to look like a new one.  If it gets
+	 * flushed to disk we will convert back before flushing or
+	 * logging it.  We zero out the new projid field and the old link
+	 * count field.  We'll handle clearing the pad field (the remains
+	 * of the old uuid field) when we actually convert the inode to
+	 * the new format. We don't change the version number so that we
+	 * can distinguish this from a real new format inode.
+	 */
+	if (ip->i_d.di_version == 1) {
+		ip->i_d.di_nlink = ip->i_d.di_onlink;
+		ip->i_d.di_onlink = 0;
+		ip->i_d.di_projid = 0;
+	}
+
+	ip->i_delayed_blks = 0;
+	ip->i_size = ip->i_d.di_size;
+
+	/*
+	 * Mark the buffer containing the inode as something to keep
+	 * around for a while.  This helps to keep recently accessed
+	 * meta-data in-core longer.
+	 */
+	XFS_BUF_SET_REF(bp, XFS_INO_REF);
+
+	/*
+	 * Use xfs_trans_brelse() to release the buffer containing the
+	 * on-disk inode, because it was acquired with xfs_trans_read_buf()
+	 * in xfs_itobp() above.  If tp is NULL, this is just a normal
+	 * brelse().  If we're within a transaction, then xfs_trans_brelse()
+	 * will only release the buffer if it is not dirty within the
+	 * transaction.  It will be OK to release the buffer in this case,
+	 * because inodes on disk are never destroyed and we will be
+	 * locking the new in-core inode before putting it in the hash
+	 * table where other processes can find it.  Thus we don't have
+	 * to worry about the inode being changed just because we released
+	 * the buffer.
+	 */
+ out_brelse:
+	xfs_trans_brelse(tp, bp);
+	return error;
+}
+
+/*
  * Read in extents from a btree-format inode.
  * Allocate and fill in if_extents.  Real work is done in xfs_bmap.c.
  */
@@ -906,64 +1050,6 @@
 	ASSERT(ifp->if_bytes <= XFS_IFORK_SIZE(ip, whichfork));
 }
 
-
-
-
-/*
- * Map inode to disk block and offset.
- *
- * mp -- the mount point structure for the current file system
- * tp -- the current transaction
- * ino -- the inode number of the inode to be located
- * imap -- this structure is filled in with the information necessary
- *	 to retrieve the given inode from disk
- * flags -- flags to pass to xfs_dilocate indicating whether or not
- *	 lookups in the inode btree were OK or not
- */
-int
-xfs_imap(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_ino_t	ino,
-	xfs_imap_t	*imap,
-	uint		flags)
-{
-	xfs_fsblock_t	fsbno;
-	int		len;
-	int		off;
-	int		error;
-
-	fsbno = imap->im_blkno ?
-		XFS_DADDR_TO_FSB(mp, imap->im_blkno) : NULLFSBLOCK;
-	error = xfs_dilocate(mp, tp, ino, &fsbno, &len, &off, flags);
-	if (error)
-		return error;
-
-	imap->im_blkno = XFS_FSB_TO_DADDR(mp, fsbno);
-	imap->im_len = XFS_FSB_TO_BB(mp, len);
-	imap->im_agblkno = XFS_FSB_TO_AGBNO(mp, fsbno);
-	imap->im_ioffset = (ushort)off;
-	imap->im_boffset = (ushort)(off << mp->m_sb.sb_inodelog);
-
-	/*
-	 * If the inode number maps to a block outside the bounds
-	 * of the file system then return NULL rather than calling
-	 * read_buf and panicing when we get an error from the
-	 * driver.
-	 */
-	if ((imap->im_blkno + imap->im_len) >
-	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
-		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
-			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
-			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
-			(unsigned long long) imap->im_blkno,
-			(unsigned long long) imap->im_len,
-			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
-		return EINVAL;
-	}
-	return 0;
-}
-
 void
 xfs_idestroy_fork(
 	xfs_inode_t	*ip,
@@ -1077,7 +1163,7 @@
  * In these cases, the format always takes precedence, because the
  * format indicates the current state of the fork.
  * 
- * Note: this requires user-space public scope for libxfs_iread
+ * Note: this requires user-space public scope for libxfs_iflush_int
  */
 /*ARGSUSED*/
 void
@@ -1155,15 +1241,16 @@
 	case XFS_DINODE_FMT_DEV:
 		if (iip->ili_format.ilf_fields & XFS_ILOG_DEV) {
 			ASSERT(whichfork == XFS_DATA_FORK);
-			dip->di_u.di_dev = cpu_to_be32(ip->i_df.if_u2.if_rdev);
+			xfs_dinode_put_rdev(dip, ip->i_df.if_u2.if_rdev);
 		}
 		break;
 
 	case XFS_DINODE_FMT_UUID:
 		if (iip->ili_format.ilf_fields & XFS_ILOG_UUID) {
 			ASSERT(whichfork == XFS_DATA_FORK);
-			memcpy(&dip->di_u.di_muuid, &ip->i_df.if_u2.if_uuid,
-				sizeof(uuid_t));
+			memcpy(XFS_DFORK_DPTR(dip),
+			       &ip->i_df.if_u2.if_uuid,
+			       sizeof(uuid_t));
 		}
 		break;
 
Index: xfs-cmds/xfsprogs/libxfs/xfs_mount.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_mount.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/libxfs/xfs_mount.c	2008-12-06 20:05:49.000000000 +0100
@@ -265,8 +265,7 @@
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
 	mp->m_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-	mp->m_litino = sbp->sb_inodesize -
-		((uint)sizeof(xfs_dinode_core_t) + (uint)sizeof(xfs_agino_t));
+	mp->m_litino = sbp->sb_inodesize - sizeof(struct xfs_dinode);
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
Index: xfs-cmds/xfsprogs/libxlog/xfs_log_recover.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxlog/xfs_log_recover.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/libxlog/xfs_log_recover.c	2008-12-06 20:05:49.000000000 +0100
@@ -1238,7 +1238,6 @@
 	xlog_t			*log)
 {
 	int			i, j, k;
-	xlog_in_core_2_t	*xhdr;
 
 	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
 		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
@@ -1247,7 +1246,7 @@
 	}
 
 	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
-		xhdr = (xlog_in_core_2_t *)rhead;
+		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
 		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
Index: xfs-cmds/xfsprogs/logprint/log_misc.c
===================================================================
--- xfs-cmds.orig/xfsprogs/logprint/log_misc.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/logprint/log_misc.c	2008-12-06 20:05:49.000000000 +0100
@@ -642,7 +642,7 @@
     mode = dino.di_mode & S_IFMT;
     size = (int)dino.di_size;
     xlog_print_trans_inode_core(&dino);
-    *ptr += sizeof(xfs_dinode_core_t);
+    *ptr += sizeof(xfs_icdinode_t);
 
     if (*i == num_ops-1 && f->ilf_size == 3)  {
 	return 1;
Index: xfs-cmds/xfsprogs/repair/attr_repair.c
===================================================================
--- xfs-cmds.orig/xfsprogs/repair/attr_repair.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/repair/attr_repair.c	2008-12-06 20:05:49.000000000 +0100
@@ -840,8 +840,8 @@
 	bno = blkmap_get(blkmap, 0);
 
 	if ( bno == NULLDFSBNO ) {
-		if (dip->di_core.di_aformat == XFS_DINODE_FMT_EXTENTS && 
-				be16_to_cpu(dip->di_core.di_anextents) == 0)
+		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
+				be16_to_cpu(dip->di_anextents) == 0)
 			return(0); /* the kernel can handle this state */
 		do_warn(_("block 0 of inode %llu attribute fork is missing\n"), 
 			ino);
@@ -958,7 +958,7 @@
 	int		*repair)  /* returned if we did repair */
 {
 	int		err;
-	__u8		aformat = dip->di_core.di_aformat;
+	__u8		aformat = dip->di_aformat;
 	xfs_attr_shortform_t *asf;
 
 	asf = (xfs_attr_shortform_t *) XFS_DFORK_APTR(dip);
Index: xfs-cmds/xfsprogs/repair/dino_chunks.c
===================================================================
--- xfs-cmds.orig/xfsprogs/repair/dino_chunks.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/repair/dino_chunks.c	2008-12-06 20:05:49.000000000 +0100
@@ -810,9 +810,9 @@
 			 * store on-disk nlink count for comparing in phase 7
 			 */
 			set_inode_disk_nlinks(ino_rec, irec_offset,
-				dino->di_core.di_version > XFS_DINODE_VERSION_1
-					? be32_to_cpu(dino->di_core.di_nlink)
-					: be16_to_cpu(dino->di_core.di_onlink));
+				dino->di_version > 1
+					? be32_to_cpu(dino->di_nlink)
+					: be16_to_cpu(dino->di_onlink));
 
 		} else  {
 			set_inode_free(ino_rec, irec_offset);
Index: xfs-cmds/xfsprogs/repair/dinode.c
===================================================================
--- xfs-cmds.orig/xfsprogs/repair/dinode.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/repair/dinode.c	2008-12-06 20:05:49.000000000 +0100
@@ -41,29 +41,29 @@
  */
 /* ARGSUSED */
 int
-calc_attr_offset(xfs_mount_t *mp, xfs_dinode_t *dino)
+calc_attr_offset(xfs_mount_t *mp, xfs_dinode_t *dip)
 {
-	xfs_dinode_core_t	*dinoc = &dino->di_core;
-	int			offset = ((__psint_t) &dino->di_u)
-						- (__psint_t)dino;
+	char			*dfork = XFS_DFORK_DPTR(dip);
+	xfs_bmdr_block_t	*bmdr = (xfs_bmdr_block_t *)dfork;
+	int			offset = ((__psint_t)dfork) - (__psint_t)dip;
 
 	/*
 	 * don't worry about alignment when calculating offset
 	 * because the data fork is already 8-byte aligned
 	 */
-	switch (dinoc->di_format)  {
+	switch (dip->di_format)  {
 	case XFS_DINODE_FMT_DEV:
 		offset += sizeof(xfs_dev_t);
 		break;
 	case XFS_DINODE_FMT_LOCAL:
-		offset += be64_to_cpu(dinoc->di_size);
+		offset += be64_to_cpu(dip->di_size);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
-		offset += be32_to_cpu(dinoc->di_nextents) * 
+		offset += be32_to_cpu(dip->di_nextents) *
 						sizeof(xfs_bmbt_rec_t);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		offset += be16_to_cpu(dino->di_u.di_bmbt.bb_numrecs) * 
+		offset += be16_to_cpu(bmdr->bb_numrecs) *
 						sizeof(xfs_bmbt_rec_t);
 		break;
 	default:
@@ -77,11 +77,9 @@
 
 /* ARGSUSED */
 int
-clear_dinode_attr(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
+clear_dinode_attr(xfs_mount_t *mp, xfs_dinode_t *dip, xfs_ino_t ino_num)
 {
-	xfs_dinode_core_t *dinoc = &dino->di_core;
-
-	ASSERT(dinoc->di_forkoff != 0);
+	ASSERT(dip->di_forkoff != 0);
 
 	if (!no_modify)
 		fprintf(stderr, _("clearing inode %llu attributes\n"),
@@ -90,16 +88,16 @@
 		fprintf(stderr, _("would have cleared inode %llu attributes\n"),
 			(unsigned long long)ino_num);
 
-	if (be16_to_cpu(dinoc->di_anextents) != 0)  {
+	if (dip->di_anextents)  {
 		if (no_modify)
-			return(1);
-		dinoc->di_anextents = cpu_to_be16(0);
+			return 1;
+		dip->di_anextents = 0;
 	}
 
-	if (dinoc->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
+	if (dip->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
 		if (no_modify)
-			return(1);
-		dinoc->di_aformat = XFS_DINODE_FMT_EXTENTS;
+			return 1;
+		dip->di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
 
 	/* get rid of the fork by clearing forkoff */
@@ -115,168 +113,138 @@
 
 	if (!no_modify) {
 		xfs_attr_shortform_t *asf = (xfs_attr_shortform_t *)
-				XFS_DFORK_APTR(dino);
+				XFS_DFORK_APTR(dip);
 		asf->hdr.totsize = cpu_to_be16(sizeof(xfs_attr_sf_hdr_t));
 		asf->hdr.count = 0;
-		dinoc->di_forkoff = 0;  /* got to do this after asf is set */
+		dip->di_forkoff = 0;  /* got to do this after asf is set */
 	}
 
 	/*
 	 * always returns 1 since the fork gets zapped
 	 */
-	return(1);
+	return 1;
 }
 
 /* ARGSUSED */
 int
-clear_dinode_core(xfs_dinode_core_t *dinoc, xfs_ino_t ino_num)
+clear_dinode_core(xfs_dinode_t *dip, xfs_ino_t ino_num)
 {
 	int dirty = 0;
 
-	if (be16_to_cpu(dinoc->di_magic) != XFS_DINODE_MAGIC)  {
+	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+			return 1;
+		dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 	}
 
-	if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
-	    (!fs_inode_nlink && dinoc->di_version > XFS_DINODE_VERSION_1))  {
+	if (!XFS_DINODE_GOOD_VERSION(dip->di_version) ||
+	    (!fs_inode_nlink && dip->di_version > 1)) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_version = (fs_inode_nlink) ? XFS_DINODE_VERSION_2
-						: XFS_DINODE_VERSION_1;
+			return 1;
+		dip->di_version = (fs_inode_nlink) ? 2 : 1;
 	}
 
-	if (be16_to_cpu(dinoc->di_mode) != 0)  {
+	if (dip->di_mode) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_mode = 0;
+			return 1;
+		dip->di_mode = 0;
 	}
 
-	if (be16_to_cpu(dinoc->di_flags) != 0)  {
+	if (dip->di_flags) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_flags = 0;
+			return 1;
+		dip->di_flags = 0;
 	}
 
-	if (be32_to_cpu(dinoc->di_dmevmask) != 0)  {
+	if (dip->di_dmevmask) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_dmevmask = 0;
+			return 1;
+		dip->di_dmevmask = 0;
 	}
 
-	if (dinoc->di_forkoff != 0)  {
+	if (dip->di_forkoff) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_forkoff = 0;
+			return 1;
+		dip->di_forkoff = 0;
 	}
 
-	if (dinoc->di_format != XFS_DINODE_FMT_EXTENTS)  {
+	if (dip->di_format != XFS_DINODE_FMT_EXTENTS) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_format = XFS_DINODE_FMT_EXTENTS;
+			return 1;
+		dip->di_format = XFS_DINODE_FMT_EXTENTS;
 	}
 
-	if (dinoc->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
+	if (dip->di_aformat != XFS_DINODE_FMT_EXTENTS) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_aformat = XFS_DINODE_FMT_EXTENTS;
+			return 1;
+		dip->di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
 
-	if (be64_to_cpu(dinoc->di_size) != 0)  {
+	if (dip->di_size) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_size = 0;
+			return 1;
+		dip->di_size = 0;
 	}
 
-	if (be64_to_cpu(dinoc->di_nblocks) != 0)  {
+	if (dip->di_nblocks) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_nblocks = 0;
+			return 1;
+		dip->di_nblocks = 0;
 	}
 
-	if (be16_to_cpu(dinoc->di_onlink) != 0)  {
+	if (dip->di_onlink) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_onlink = 0;
+			return 1;
+		dip->di_onlink = 0;
 	}
 
-	if (be32_to_cpu(dinoc->di_nextents) != 0)  {
+	if (dip->di_nextents) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_nextents = 0;
+			return 1;
+		dip->di_nextents = 0;
 	}
 
-	if (be16_to_cpu(dinoc->di_anextents) != 0)  {
+	if (dip->di_anextents) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_anextents = 0;
+			return 1;
+		dip->di_anextents = 0;
 	}
 
-	if (dinoc->di_version > XFS_DINODE_VERSION_1 &&
-			be32_to_cpu(dinoc->di_nlink) != 0)  {
+	if (dip->di_version > 1 && dip->di_nlink) {
 		dirty = 1;
-
 		if (no_modify)
-			return(1);
-
-		dinoc->di_nlink = 0;
+			return 1;
+		dip->di_nlink = 0;
 	}
 
-	return(dirty);
+	return dirty;
 }
 
 /* ARGSUSED */
 int
-clear_dinode_unlinked(xfs_mount_t *mp, xfs_dinode_t *dino)
+clear_dinode_unlinked(xfs_mount_t *mp, xfs_dinode_t *dip)
 {
 
-	if (be32_to_cpu(dino->di_next_unlinked) != NULLAGINO)  {
+	if (be32_to_cpu(dip->di_next_unlinked) != NULLAGINO) {
 		if (!no_modify)
-			dino->di_next_unlinked = cpu_to_be32(NULLAGINO);
-		return(1);
+			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
+		return 1;
 	}
 
-	return(0);
+	return 0;
 }
 
 /*
@@ -285,17 +253,17 @@
  * returns > zero if the inode has been altered while being cleared
  */
 int
-clear_dinode(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
+clear_dinode(xfs_mount_t *mp, xfs_dinode_t *dip, xfs_ino_t ino_num)
 {
 	int dirty;
 
-	dirty = clear_dinode_core(&dino->di_core, ino_num);
-	dirty += clear_dinode_unlinked(mp, dino);
+	dirty = clear_dinode_core(dip, ino_num);
+	dirty += clear_dinode_unlinked(mp, dip);
 
 	/* and clear the forks */
 
 	if (dirty && !no_modify)
-		memset(&dino->di_u, 0, XFS_LITINO(mp));
+		memset(XFS_DFORK_DPTR(dip), 0, XFS_LITINO(mp));
 
 	return(dirty);
 }
@@ -1354,11 +1322,11 @@
 	xfs_ino_t		lino;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-	if (whichfork == XFS_DATA_FORK && be64_to_cpu(dip->di_core.di_size) >
-						XFS_DFORK_DSIZE(dip, mp)) {
+	if (whichfork == XFS_DATA_FORK &&
+	    be64_to_cpu(dip->di_size) > XFS_DFORK_DSIZE(dip, mp)) {
 		do_warn(
 	_("local inode %llu data fork is too large (size = %lld, max = %d)\n"),
-			lino, be64_to_cpu(dip->di_core.di_size),
+			lino, be64_to_cpu(dip->di_size),
 			XFS_DFORK_DSIZE(dip, mp));
 		return(1);
 	} else if (whichfork == XFS_ATTR_FORK) {
@@ -1383,7 +1351,7 @@
 }
 
 int
-process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
+process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dip)
 {
 	xfs_dfiloff_t		expected_offset;
 	xfs_bmbt_rec_t		*rp;
@@ -1392,23 +1360,23 @@
 	int			i;
 	int			max_blocks;
 
-	if (be64_to_cpu(dino->di_core.di_size) <= XFS_DFORK_DSIZE(dino, mp)) {
-		if (dino->di_core.di_format == XFS_DINODE_FMT_LOCAL)  
+	if (be64_to_cpu(dip->di_size) <= XFS_DFORK_DSIZE(dip, mp)) {
+		if (dip->di_format == XFS_DINODE_FMT_LOCAL)
 			return 0;
 		do_warn(_("mismatch between format (%d) and size (%lld) in "
-			"symlink ino %llu\n"), dino->di_core.di_format, 
-			be64_to_cpu(dino->di_core.di_size), lino);
+			"symlink ino %llu\n"), dip->di_format,
+			be64_to_cpu(dip->di_size), lino);
 		return 1;
 	}
-	if (dino->di_core.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (dip->di_format == XFS_DINODE_FMT_LOCAL) {
 		do_warn(_("mismatch between format (%d) and size (%lld) in "
-			"symlink inode %llu\n"), dino->di_core.di_format,
-			be64_to_cpu(dino->di_core.di_size), lino);
+			"symlink inode %llu\n"), dip->di_format,
+			be64_to_cpu(dip->di_size), lino);
 		return 1;
 	}
 
-	rp = (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino);
-	numrecs = be32_to_cpu(dino->di_core.di_nextents);
+	rp = (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dip);
+	numrecs = be32_to_cpu(dip->di_nextents);
 
 	/*
 	 * the max # of extents in a symlink inode is equal to the
@@ -1474,11 +1442,10 @@
 process_symlink(
 	xfs_mount_t	*mp,
 	xfs_ino_t	lino,
-	xfs_dinode_t	*dino,
+	xfs_dinode_t	*dip,
 	blkmap_t 	*blkmap)
 {
 	xfs_dfsbno_t		fsbno;
-	xfs_dinode_core_t	*dinoc = &dino->di_core;
 	xfs_buf_t		*bp = NULL;
 	char			*symlink, *cptr, *buf_data;
 	int			i, size, amountdone;
@@ -1490,9 +1457,9 @@
 	 * the inode is structurally ok so we don't have to check
 	 * for that
 	 */
-	if (be64_to_cpu(dinoc->di_size) >= MAXPATHLEN)  {
+	if (be64_to_cpu(dip->di_size) >= MAXPATHLEN)  {
 		do_warn(_("symlink in inode %llu too long (%lld chars)\n"),
-			lino, be64_to_cpu(dinoc->di_size));
+			lino, be64_to_cpu(dip->di_size));
 		return(1);
 	}
 
@@ -1501,13 +1468,13 @@
 	 * get symlink contents into data area
 	 */
 	symlink = &data[0];
-	if (be64_to_cpu(dinoc->di_size) <= XFS_DFORK_DSIZE(dino, mp))  {
+	if (be64_to_cpu(dip->di_size) <= XFS_DFORK_DSIZE(dip, mp))  {
 		/*
 		 * local symlink, just copy the symlink out of the
 		 * inode into the data area
 		 */
-		memmove(symlink, XFS_DFORK_DPTR(dino), 
-						be64_to_cpu(dinoc->di_size));
+		memmove(symlink, XFS_DFORK_DPTR(dip),
+						be64_to_cpu(dip->di_size));
 	} else {
 		/*
 		 * stored in a meta-data file, have to bmap one block
@@ -1516,7 +1483,7 @@
 		i = size = amountdone = 0;
 		cptr = symlink;
 
-		while (amountdone < be64_to_cpu(dinoc->di_size)) {
+		while (amountdone < be64_to_cpu(dip->di_size)) {
 			fsbno = blkmap_get(blkmap, i);
 			if (fsbno != NULLDFSBNO)
 				bp = libxfs_readbuf(mp->m_dev,
@@ -1530,7 +1497,7 @@
 			}
 
 			buf_data = (char *)XFS_BUF_PTR(bp);
-			size = MIN(be64_to_cpu(dinoc->di_size) - amountdone, 
+			size = MIN(be64_to_cpu(dip->di_size) - amountdone,
 						XFS_FSB_TO_BB(mp, 1) * BBSIZE);
 			memmove(cptr, buf_data, size);
 			cptr += size;
@@ -1539,12 +1506,12 @@
 			libxfs_putbuf(bp);
 		}
 	}
-	data[be64_to_cpu(dinoc->di_size)] = '\0';
+	data[be64_to_cpu(dip->di_size)] = '\0';
 
 	/*
 	 * check for nulls
 	 */
-	if (null_check(symlink, be64_to_cpu(dinoc->di_size)))  {
+	if (null_check(symlink, be64_to_cpu(dip->di_size)))  {
 		do_warn(
 		_("found illegal null character in symlink inode %llu\n"),
 			lino);
@@ -1554,7 +1521,7 @@
 	/*
 	 * check for any component being too long
 	 */
-	if (be64_to_cpu(dinoc->di_size) >= MAXNAMELEN)  {
+	if (be64_to_cpu(dip->di_size) >= MAXNAMELEN)  {
 		cptr = strchr(symlink, '/');
 
 		while (cptr != NULL)  {
@@ -1585,7 +1552,7 @@
  */
 static int
 process_misc_ino_types(xfs_mount_t	*mp,
-			xfs_dinode_t	*dino,
+			xfs_dinode_t	*dip,
 			xfs_ino_t	lino,
 			int		type)
 {
@@ -1602,27 +1569,27 @@
 	/*
 	 * must also have a zero size
 	 */
-	if (be64_to_cpu(dino->di_core.di_size) != 0)  {
+	if (be64_to_cpu(dip->di_size) != 0)  {
 		switch (type)  {
 		case XR_INO_CHRDEV:
 			do_warn(_("size of character device inode %llu != 0 "
 				  "(%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_core.di_size));
+				be64_to_cpu(dip->di_size));
 			break;
 		case XR_INO_BLKDEV:
 			do_warn(_("size of block device inode %llu != 0 "
 				  "(%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_core.di_size));
+				be64_to_cpu(dip->di_size));
 			break;
 		case XR_INO_SOCK:
 			do_warn(_("size of socket inode %llu != 0 "
 				  "(%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_core.di_size));
+				be64_to_cpu(dip->di_size));
 			break;
 		case XR_INO_FIFO:
 			do_warn(_("size of fifo inode %llu != 0 "
 				  "(%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_core.di_size));
+				be64_to_cpu(dip->di_size));
 			break;
 		default:
 			do_warn(_("Internal error - process_misc_ino_types, "
@@ -1641,7 +1608,7 @@
 {
 	/*
 	 * you can not enforce all misc types have zero data fork blocks
-	 * by checking dino->di_core.di_nblocks because atotblocks (attribute
+	 * by checking dip->di_nblocks because atotblocks (attribute
 	 * blocks) are part of nblocks. We must check this later when atotblocks
 	 * has been calculated or by doing a simple check that anExtents == 0.
 	 * We must also guarantee that totblocks is 0. Thus nblocks checking
@@ -1680,50 +1647,50 @@
 
 static inline int
 dinode_fmt(
-	xfs_dinode_core_t *dinoc)
+	xfs_dinode_t	*dip)
 {
-	return be16_to_cpu(dinoc->di_mode) & S_IFMT;
+	return be16_to_cpu(dip->di_mode) & S_IFMT;
 }
 
 static inline void
 change_dinode_fmt(
-	xfs_dinode_core_t *dinoc,
+	xfs_dinode_t	*dip,
 	int		new_fmt)
 {
-	int		mode = be16_to_cpu(dinoc->di_mode);
+	int		mode = be16_to_cpu(dip->di_mode);
 
 	ASSERT((new_fmt & ~S_IFMT) == 0);
 
 	mode &= ~S_IFMT;
 	mode |= new_fmt;
-	dinoc->di_mode = cpu_to_be16(mode);
+	dip->di_mode = cpu_to_be16(mode);
 }
 
 static int
 check_dinode_mode_format(
-	xfs_dinode_core_t *dinoc)
+	xfs_dinode_t	*dip)
 {
-	if (dinoc->di_format >= XFS_DINODE_FMT_UUID)
+	if (dip->di_format >= XFS_DINODE_FMT_UUID)
 		return -1;	/* FMT_UUID is not used */
 
-	switch (dinode_fmt(dinoc)) {
+	switch (dinode_fmt(dip)) {
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFSOCK:
-		return (dinoc->di_format != XFS_DINODE_FMT_DEV) ? -1 : 0;
+		return (dip->di_format != XFS_DINODE_FMT_DEV) ? -1 : 0;
 
 	case S_IFDIR:
-		return (dinoc->di_format < XFS_DINODE_FMT_LOCAL ||
-			dinoc->di_format > XFS_DINODE_FMT_BTREE) ? -1 : 0;
+		return (dip->di_format < XFS_DINODE_FMT_LOCAL ||
+			dip->di_format > XFS_DINODE_FMT_BTREE) ? -1 : 0;
 
 	case S_IFREG:
-		return (dinoc->di_format < XFS_DINODE_FMT_EXTENTS ||
-			dinoc->di_format > XFS_DINODE_FMT_BTREE) ? -1 : 0;
+		return (dip->di_format < XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format > XFS_DINODE_FMT_BTREE) ? -1 : 0;
 
 	case S_IFLNK:
-		return (dinoc->di_format < XFS_DINODE_FMT_LOCAL ||
-			dinoc->di_format > XFS_DINODE_FMT_EXTENTS) ? -1 : 0;
+		return (dip->di_format < XFS_DINODE_FMT_LOCAL ||
+			dip->di_format > XFS_DINODE_FMT_EXTENTS) ? -1 : 0;
 
 	default: ;
 	}
@@ -1738,7 +1705,7 @@
 static int
 process_check_sb_inodes(
 	xfs_mount_t	*mp,
-	xfs_dinode_core_t *dinoc,
+	xfs_dinode_t	*dip,
 	xfs_ino_t	lino,
 	int		*type,
 	int		*dirty)
@@ -1746,11 +1713,11 @@
 	if (lino == mp->m_sb.sb_rootino) {
 	 	if (*type != XR_INO_DIR)  {
 			do_warn(_("root inode %llu has bad type 0x%x\n"),
-				lino, dinode_fmt(dinoc));
+				lino, dinode_fmt(dip));
 			*type = XR_INO_DIR;
 			if (!no_modify)  {
 				do_warn(_("resetting to directory\n"));
-				change_dinode_fmt(dinoc, S_IFDIR);
+				change_dinode_fmt(dip, S_IFDIR);
 				*dirty = 1;
 			} else
 				do_warn(_("would reset to directory\n"));
@@ -1760,7 +1727,7 @@
 	if (lino == mp->m_sb.sb_uquotino)  {
 		if (*type != XR_INO_DATA)  {
 			do_warn(_("user quota inode %llu has bad type 0x%x\n"),
-				lino, dinode_fmt(dinoc));
+				lino, dinode_fmt(dip));
 			mp->m_sb.sb_uquotino = NULLFSINO;
 			return 1;
 		}
@@ -1769,7 +1736,7 @@
 	if (lino == mp->m_sb.sb_gquotino)  {
 		if (*type != XR_INO_DATA)  {
 			do_warn(_("group quota inode %llu has bad type 0x%x\n"),
-				lino, dinode_fmt(dinoc));
+				lino, dinode_fmt(dip));
 			mp->m_sb.sb_gquotino = NULLFSINO;
 			return 1;
 		}
@@ -1778,18 +1745,18 @@
 	if (lino == mp->m_sb.sb_rsumino) {
 		if (*type != XR_INO_RTSUM) {
 			do_warn(_("realtime summary inode %llu has bad type 0x%x, "),
-				lino, dinode_fmt(dinoc));
+				lino, dinode_fmt(dip));
 			if (!no_modify)  {
 				do_warn(_("resetting to regular file\n"));
-				change_dinode_fmt(dinoc, S_IFREG);
+				change_dinode_fmt(dip, S_IFREG);
 				*dirty = 1;
 			} else  {
 				do_warn(_("would reset to regular file\n"));
 			}
 		}
-		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+		if (mp->m_sb.sb_rblocks == 0 && dip->di_nextents != 0)  {
 			do_warn(_("bad # of extents (%u) for realtime summary inode %llu\n"),
-				be32_to_cpu(dinoc->di_nextents), lino);
+				be32_to_cpu(dip->di_nextents), lino);
 			return 1;
 		}
 		return 0;
@@ -1797,18 +1764,18 @@
 	if (lino == mp->m_sb.sb_rbmino) {
 		if (*type != XR_INO_RTBITMAP) {
 			do_warn(_("realtime bitmap inode %llu has bad type 0x%x, "),
-				lino, dinode_fmt(dinoc));
+				lino, dinode_fmt(dip));
 			if (!no_modify)  {
 				do_warn(_("resetting to regular file\n"));
-				change_dinode_fmt(dinoc, S_IFREG);
+				change_dinode_fmt(dip, S_IFREG);
 				*dirty = 1;
 			} else  {
 				do_warn(_("would reset to regular file\n"));
 			}
 		}
-		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+		if (mp->m_sb.sb_rblocks == 0 && dip->di_nextents != 0)  {
 			do_warn(_("bad # of extents (%u) for realtime bitmap inode %llu\n"),
-				be32_to_cpu(dinoc->di_nextents), lino);
+				be32_to_cpu(dip->di_nextents), lino);
 			return 1;
 		}
 		return 0;
@@ -1830,21 +1797,20 @@
 static int
 process_check_inode_sizes(
 	xfs_mount_t	*mp,
-	xfs_dinode_t	*dino,
+	xfs_dinode_t	*dip,
 	xfs_ino_t	lino,
 	int		type)
 {
-	xfs_dinode_core_t *dinoc = &dino->di_core;
-	xfs_fsize_t	size = be64_to_cpu(dinoc->di_size);
+	xfs_fsize_t	size = be64_to_cpu(dip->di_size);
 
 	switch (type)  {
 
 	case XR_INO_DIR:
-		if (size <= XFS_DFORK_DSIZE(dino, mp) &&
-				dinoc->di_format != XFS_DINODE_FMT_LOCAL) {
+		if (size <= XFS_DFORK_DSIZE(dip, mp) &&
+				dip->di_format != XFS_DINODE_FMT_LOCAL) {
 			do_warn(_("mismatch between format (%d) and size "
 				"(%lld) in directory ino %llu\n"),
-				dinoc->di_format, size, lino);
+				dip->di_format, size, lino);
 			return 1;
 		}
 		if (size > XFS_DIR2_LEAF_OFFSET) {
@@ -1855,7 +1821,7 @@
 		break;
 
 	case XR_INO_SYMLINK:
-		if (process_symlink_extlist(mp, lino, dino))  {
+		if (process_symlink_extlist(mp, lino, dip))  {
 			do_warn(_("bad data fork in symlink %llu\n"), lino);
 			return 1;
 		}
@@ -1866,7 +1832,7 @@
 	case XR_INO_SOCK:	/* fall through to FIFO case ... */
 	case XR_INO_MOUNTPOINT:	/* fall through to FIFO case ... */
 	case XR_INO_FIFO:
-		if (process_misc_ino_types(mp, dino, lino, type))
+		if (process_misc_ino_types(mp, dip, lino, type))
 			return 1;
 		break;
 
@@ -1914,17 +1880,17 @@
 static int
 process_check_inode_forkoff(
 	xfs_mount_t	*mp,
-	xfs_dinode_core_t *dinoc,
+	xfs_dinode_t	*dip,
 	xfs_ino_t	lino)
 {
-	if (dinoc->di_forkoff == 0)
+	if (dip->di_forkoff == 0)
 		return 0;
 
-	switch (dinoc->di_format)  {
+	switch (dip->di_format)  {
 	case XFS_DINODE_FMT_DEV:
-		if (dinoc->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3)) {
+		if (dip->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3)) {
 			do_warn(_("bad attr fork offset %d in dev inode %llu, "
-				"should be %d\n"), dinoc->di_forkoff, lino,
+				"should be %d\n"), dip->di_forkoff, lino,
 				(int)(roundup(sizeof(xfs_dev_t), 8) >> 3));
 			return 1;
 		}
@@ -1932,15 +1898,15 @@
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:	/* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
-		if (dinoc->di_forkoff >= (XFS_LITINO(mp) >> 3)) {
+		if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3)) {
 			do_warn(_("bad attr fork offset %d in inode %llu, "
-				"max=%d\n"), dinoc->di_forkoff, lino,
+				"max=%d\n"), dip->di_forkoff, lino,
 				XFS_LITINO(mp) >> 3);
 			return 1;
 		}
 		break;
 	default:
-		do_error(_("unexpected inode format %d\n"), dinoc->di_format);
+		do_error(_("unexpected inode format %d\n"), dip->di_format);
 		break;
 	}
 	return 0;
@@ -1951,24 +1917,24 @@
  */
 static int
 process_inode_blocks_and_extents(
-	xfs_dinode_core_t *dinoc,
+	xfs_dinode_t	*dip,
 	xfs_drfsbno_t	nblocks,
 	__uint64_t	nextents,
 	__uint64_t	anextents,
 	xfs_ino_t	lino,
 	int		*dirty)
 {
-	if (nblocks != be64_to_cpu(dinoc->di_nblocks))  {
+	if (nblocks != be64_to_cpu(dip->di_nblocks))  {
 		if (!no_modify)  {
 			do_warn(_("correcting nblocks for inode %llu, "
 				"was %llu - counted %llu\n"), lino,
-				be64_to_cpu(dinoc->di_nblocks), nblocks);
-			dinoc->di_nblocks = cpu_to_be64(nblocks);
+				be64_to_cpu(dip->di_nblocks), nblocks);
+			dip->di_nblocks = cpu_to_be64(nblocks);
 			*dirty = 1;
 		} else  {
 			do_warn(_("bad nblocks %llu for inode %llu, "
 				"would reset to %llu\n"),
-				be64_to_cpu(dinoc->di_nblocks), lino, nblocks);
+				be64_to_cpu(dip->di_nblocks), lino, nblocks);
 		}
 	}
 
@@ -1977,16 +1943,16 @@
 			nextents, lino);
 		return 1;
 	}
-	if (nextents != be32_to_cpu(dinoc->di_nextents))  {
+	if (nextents != be32_to_cpu(dip->di_nextents))  {
 		if (!no_modify)  {
 			do_warn(_("correcting nextents for inode %llu, "
 				"was %d - counted %llu\n"), lino,
-				be32_to_cpu(dinoc->di_nextents), nextents);
-			dinoc->di_nextents = cpu_to_be32(nextents);
+				be32_to_cpu(dip->di_nextents), nextents);
+			dip->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(_("bad nextents %d for inode %llu, would reset "
-				"to %llu\n"), be32_to_cpu(dinoc->di_nextents),
+				"to %llu\n"), be32_to_cpu(dip->di_nextents),
 				lino, nextents);
 		}
 	}
@@ -1996,16 +1962,16 @@
 			anextents, lino);
 		return 1;
 	}
-	if (anextents != be16_to_cpu(dinoc->di_anextents))  {
+	if (anextents != be16_to_cpu(dip->di_anextents))  {
 		if (!no_modify)  {
 			do_warn(_("correcting anextents for inode %llu, "
 				"was %d - counted %llu\n"), lino,
-				be16_to_cpu(dinoc->di_anextents), anextents);
-			dinoc->di_anextents = cpu_to_be16(anextents);
+				be16_to_cpu(dip->di_anextents), anextents);
+			dip->di_anextents = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(_("bad anextents %d for inode %llu, would reset"
-				" to %llu\n"), be16_to_cpu(dinoc->di_anextents),
+				" to %llu\n"), be16_to_cpu(dip->di_anextents),
 				lino, anextents);
 		}
 	}
@@ -2020,7 +1986,7 @@
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agno,
 	xfs_agino_t	ino,
-	xfs_dinode_t	*dino,
+	xfs_dinode_t	*dip,
 	int		type,
 	int		*dirty,
 	xfs_drfsbno_t	*totblocks,
@@ -2028,30 +1994,29 @@
 	blkmap_t	**dblkmap,
 	int		check_dups)
 {
-	xfs_dinode_core_t *dinoc = &dino->di_core;
 	xfs_ino_t	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	int		err = 0;
 
-	*nextents = be32_to_cpu(dinoc->di_nextents);
-	if (*nextents > be64_to_cpu(dinoc->di_nblocks))
+	*nextents = be32_to_cpu(dip->di_nextents);
+	if (*nextents > be64_to_cpu(dip->di_nblocks))
 		*nextents = 1;
 
-	if (dinoc->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
+	if (dip->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
 		*dblkmap = blkmap_alloc(*nextents);
 	*nextents = 0;
 
-	switch (dinoc->di_format) {
+	switch (dip->di_format) {
 	case XFS_DINODE_FMT_LOCAL:
-		err = process_lclinode(mp, agno, ino, dino, XFS_DATA_FORK);
+		err = process_lclinode(mp, agno, ino, dip, XFS_DATA_FORK);
 		*totblocks = 0;
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
-		err = process_exinode(mp, agno, ino, dino, type, dirty,
+		err = process_exinode(mp, agno, ino, dip, type, dirty,
 			totblocks, nextents, dblkmap, XFS_DATA_FORK,
 			check_dups);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		err = process_btinode(mp, agno, ino, dino, type, dirty,
+		err = process_btinode(mp, agno, ino, dip, type, dirty,
 			totblocks, nextents, dblkmap, XFS_DATA_FORK,
 			check_dups);
 		break;
@@ -2060,13 +2025,13 @@
 		break;
 	default:
 		do_error(_("unknown format %d, ino %llu (mode = %d)\n"),
-			dinoc->di_format, lino, be16_to_cpu(dinoc->di_mode));
+			dip->di_format, lino, be16_to_cpu(dip->di_mode));
 	}
 
 	if (err)  {
 		do_warn(_("bad data fork in inode %llu\n"), lino);
 		if (!no_modify)  {
-			*dirty += clear_dinode(mp, dino, lino);
+			*dirty += clear_dinode(mp, dip, lino);
 			ASSERT(*dirty > 0);
 		}
 		return 1;
@@ -2078,18 +2043,18 @@
 		 * re-process data fork to set bitmap since the
 		 * bitmap wasn't set the first time through
 		 */
-		switch (dinoc->di_format) {
+		switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
-			err = process_lclinode(mp, agno, ino, dino, 
+			err = process_lclinode(mp, agno, ino, dip,
 						XFS_DATA_FORK);
 			break;
 		case XFS_DINODE_FMT_EXTENTS:
-			err = process_exinode(mp, agno, ino, dino, type,
+			err = process_exinode(mp, agno, ino, dip, type,
 				dirty, totblocks, nextents, dblkmap,
 				XFS_DATA_FORK, 0);
 			break;
 		case XFS_DINODE_FMT_BTREE:
-			err = process_btinode(mp, agno, ino, dino, type,
+			err = process_btinode(mp, agno, ino, dip, type,
 				dirty, totblocks, nextents, dblkmap,
 				XFS_DATA_FORK, 0);
 			break;
@@ -2098,8 +2063,8 @@
 			break;
 		default:
 			do_error(_("unknown format %d, ino %llu (mode = %d)\n"),
-				dinoc->di_format, lino,
-				be16_to_cpu(dinoc->di_mode));
+				dip->di_format, lino,
+				be16_to_cpu(dip->di_mode));
 		}
 
 		if (no_modify && err != 0)
@@ -2118,7 +2083,7 @@
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agno,
 	xfs_agino_t	ino,
-	xfs_dinode_t	*dino,
+	xfs_dinode_t	*dip,
 	int		type,
 	int		*dirty,
 	xfs_drfsbno_t	*atotblocks,
@@ -2127,20 +2092,19 @@
 	int		extra_attr_check,
 	int		*retval)
 {
-	xfs_dinode_core_t *dinoc = &dino->di_core;
 	xfs_ino_t	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	blkmap_t	*ablkmap = NULL;
 	int		repair = 0;
 	int		err;
 
-	if (!XFS_DFORK_Q(dino)) {
+	if (!XFS_DFORK_Q(dip)) {
 		*anextents = 0;
-		if (dinoc->di_aformat != XFS_DINODE_FMT_EXTENTS) {
+		if (dip->di_aformat != XFS_DINODE_FMT_EXTENTS) {
 			do_warn(_("bad attribute format %d in inode %llu, "),
-				dinoc->di_aformat, lino);
+				dip->di_aformat, lino);
 			if (!no_modify) {
 				do_warn(_("resetting value\n"));
-				dinoc->di_aformat = XFS_DINODE_FMT_EXTENTS;
+				dip->di_aformat = XFS_DINODE_FMT_EXTENTS;
 				*dirty = 1;
 			} else
 				do_warn(_("would reset value\n"));
@@ -2148,33 +2112,33 @@
 		return 0;
 	}
 
-	*anextents = be16_to_cpu(dinoc->di_anextents);
-	if (*anextents > be64_to_cpu(dinoc->di_nblocks))
+	*anextents = be16_to_cpu(dip->di_anextents);
+	if (*anextents > be64_to_cpu(dip->di_nblocks))
 		*anextents = 1;
 
-	switch (dinoc->di_aformat) {
+	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
 		*anextents = 0;
 		*atotblocks = 0;
-		err = process_lclinode(mp, agno, ino, dino, XFS_ATTR_FORK);
+		err = process_lclinode(mp, agno, ino, dip, XFS_ATTR_FORK);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
 		ablkmap = blkmap_alloc(*anextents);
 		*anextents = 0;
-		err = process_exinode(mp, agno, ino, dino, type, dirty,
+		err = process_exinode(mp, agno, ino, dip, type, dirty,
 				atotblocks, anextents, &ablkmap,
 				XFS_ATTR_FORK, check_dups);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		ablkmap = blkmap_alloc(*anextents);
 		*anextents = 0;
-		err = process_btinode(mp, agno, ino, dino, type, dirty,
+		err = process_btinode(mp, agno, ino, dip, type, dirty,
 				atotblocks, anextents, &ablkmap,
 				XFS_ATTR_FORK, check_dups);
 		break;
 	default:
 		do_warn(_("illegal attribute format %d, ino %llu\n"),
-				dinoc->di_aformat, lino);
+				dip->di_aformat, lino);
 		err = 1;
 		break;
 	}
@@ -2193,11 +2157,11 @@
 		if (!no_modify)  {
 			if (delete_attr_ok)  {
 				do_warn(_(", clearing attr fork\n"));
-				*dirty += clear_dinode_attr(mp, dino, lino);
-				dinoc->di_aformat = XFS_DINODE_FMT_LOCAL;
+				*dirty += clear_dinode_attr(mp, dip, lino);
+				dip->di_aformat = XFS_DINODE_FMT_LOCAL;
 			} else  {
 				do_warn("\n");
-				*dirty += clear_dinode(mp, dino, lino);
+				*dirty += clear_dinode(mp, dip, lino);
 			}
 			ASSERT(*dirty > 0);
 		} else  {
@@ -2213,24 +2177,24 @@
 	}
 
 	if (check_dups)  {
-		switch (dinoc->di_aformat) {
+		switch (dip->di_aformat) {
 		case XFS_DINODE_FMT_LOCAL:
-			err = process_lclinode(mp, agno, ino, dino, 
+			err = process_lclinode(mp, agno, ino, dip,
 						XFS_ATTR_FORK);
 			break;
 		case XFS_DINODE_FMT_EXTENTS:
-			err = process_exinode(mp, agno, ino, dino,
+			err = process_exinode(mp, agno, ino, dip,
 				type, dirty, atotblocks, anextents,
 				&ablkmap, XFS_ATTR_FORK, 0);
 			break;
 		case XFS_DINODE_FMT_BTREE:
-			err = process_btinode(mp, agno, ino, dino,
+			err = process_btinode(mp, agno, ino, dip,
 				type, dirty, atotblocks, anextents,
 				&ablkmap, XFS_ATTR_FORK, 0);
 			break;
 		default:
 			do_error(_("illegal attribute fmt %d, ino %llu\n"),
-				dinoc->di_aformat, lino);
+				dip->di_aformat, lino);
 		}
 
 		if (no_modify && err != 0) {
@@ -2247,14 +2211,14 @@
 
 	/* get this only in phase 3, not in both phase 3 and 4 */
 	if (extra_attr_check &&
-			process_attributes(mp, lino, dino, ablkmap, &repair)) {
+			process_attributes(mp, lino, dip, ablkmap, &repair)) {
 		do_warn(_("problem with attribute contents in inode %llu\n"),
 			lino);
 		if (!repair) {
 			/* clear attributes if not done already */
 			if (!no_modify)  {
-				*dirty += clear_dinode_attr(mp, dino, lino);
-				dinoc->di_aformat = XFS_DINODE_FMT_LOCAL;
+				*dirty += clear_dinode_attr(mp, dip, lino);
+				dip->di_aformat = XFS_DINODE_FMT_LOCAL;
 			} else  {
 				do_warn(_("would clear attr fork\n"));
 			}
@@ -2277,18 +2241,18 @@
 
 static int
 process_check_inode_nlink_version(
-	xfs_dinode_core_t *dinoc,
+	xfs_dinode_t	*dip,
 	xfs_ino_t	lino)
 {
 	int		dirty = 0;
 
-	if (dinoc->di_version > XFS_DINODE_VERSION_1 && !fs_inode_nlink)  {
+	if (dip->di_version > 1 && !fs_inode_nlink)  {
 		/*
 		 * do we have a fs/inode version mismatch with a valid
 		 * version 2 inode here that has to stay version 2 or
 		 * lose links?
 		 */
-		if (be32_to_cpu(dinoc->di_nlink) > XFS_MAXLINK_1)  {
+		if (be32_to_cpu(dip->di_nlink) > XFS_MAXLINK_1)  {
 			/*
 			 * yes.  are nlink inodes allowed?
 			 */
@@ -2318,17 +2282,17 @@
 				if (!no_modify)  {
 					do_warn(_("converting back to version 1,\n"
 						"this may destroy %d links\n"),
-						be32_to_cpu(dinoc->di_nlink) -
+						be32_to_cpu(dip->di_nlink) -
 							XFS_MAXLINK_1);
 
-					dinoc->di_version = XFS_DINODE_VERSION_1;
-					dinoc->di_nlink = cpu_to_be32(XFS_MAXLINK_1);
-					dinoc->di_onlink = cpu_to_be16(XFS_MAXLINK_1);
+					dip->di_version = 1;
+					dip->di_nlink = cpu_to_be32(XFS_MAXLINK_1);
+					dip->di_onlink = cpu_to_be16(XFS_MAXLINK_1);
 					dirty = 1;
 				} else  {
 					do_warn(_("would convert back to version 1,\n"
 						"\tthis might destroy %d links\n"),
-						be32_to_cpu(dinoc->di_nlink) -
+						be32_to_cpu(dip->di_nlink) -
 							XFS_MAXLINK_1);
 				}
 			}
@@ -2344,9 +2308,9 @@
 			do_warn(_("found version 2 inode %llu, "), lino);
 			if (!no_modify)  {
 				do_warn(_("converting back to version 1\n"));
-				dinoc->di_version = XFS_DINODE_VERSION_1;
-				dinoc->di_onlink = cpu_to_be16(
-					be32_to_cpu(dinoc->di_nlink));
+				dip->di_version = 1;
+				dip->di_onlink = cpu_to_be16(
+					be32_to_cpu(dip->di_nlink));
 				dirty = 1;
 			} else  {
 				do_warn(_("would convert back to version 1\n"));
@@ -2359,18 +2323,17 @@
 	 * to stay a version 2 inode.  it should have a zero
 	 * onlink field, so clear it.
 	 */
-	if (dinoc->di_version > XFS_DINODE_VERSION_1 &&
-			dinoc->di_onlink != 0 && fs_inode_nlink > 0) {
+	if (dip->di_version > 1 && dip->di_onlink != 0 && fs_inode_nlink > 0) {
 		if (!no_modify) {
 			do_warn(_("clearing obsolete nlink field in "
 				"version 2 inode %llu, was %d, now 0\n"),
-				lino, be16_to_cpu(dinoc->di_onlink));
-			dinoc->di_onlink = 0;
+				lino, be16_to_cpu(dip->di_onlink));
+			dip->di_onlink = 0;
 			dirty = 1;
 		} else  {
 			do_warn(_("would clear obsolete nlink field in "
 				"version 2 inode %llu, currently %d\n"),
-				lino, be16_to_cpu(dinoc->di_onlink));
+				lino, be16_to_cpu(dip->di_onlink));
 		}
 	}
 	return dirty;
@@ -2388,7 +2351,7 @@
 /* ARGSUSED */
 int
 process_dinode_int(xfs_mount_t *mp,
-		xfs_dinode_t *dino,
+		xfs_dinode_t *dip,
 		xfs_agnumber_t agno,
 		xfs_agino_t ino,
 		int was_free,		/* 1 if inode is currently free */
@@ -2405,7 +2368,6 @@
 {
 	xfs_drfsbno_t		totblocks = 0;
 	xfs_drfsbno_t		atotblocks = 0;
-	xfs_dinode_core_t	*dinoc;
 	int			di_mode;
 	int			type;
 	int			retval = 0;
@@ -2420,9 +2382,8 @@
 	*used = is_used;
 	type = XR_INO_UNKNOWN;
 
-	dinoc = &dino->di_core;
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-	di_mode = be16_to_cpu(dinoc->di_mode);
+	di_mode = be16_to_cpu(dip->di_mode);
 
 	/*
 	 * if in verify mode, don't modify the inode.
@@ -2438,35 +2399,33 @@
 	 */
 	ASSERT(uncertain == 0 || verify_mode != 0);
 
-	if (be16_to_cpu(dinoc->di_magic) != XFS_DINODE_MAGIC)  {
+	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC)  {
 		retval = 1;
 		if (!uncertain)
 			do_warn(_("bad magic number 0x%x on inode %llu%c"),
-				be16_to_cpu(dinoc->di_magic), lino,
+				be16_to_cpu(dip->di_magic), lino,
 				verify_mode ? '\n' : ',');
 		if (!verify_mode) {
 			if (!no_modify)  {
 				do_warn(_(" resetting magic number\n"));
-				dinoc->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+				dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 				*dirty = 1;
 			} else
 				do_warn(_(" would reset magic number\n"));
 		}
 	}
 
-	if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
-	    (!fs_inode_nlink && dinoc->di_version > XFS_DINODE_VERSION_1))  {
+	if (!XFS_DINODE_GOOD_VERSION(dip->di_version) ||
+	    (!fs_inode_nlink && dip->di_version > 1))  {
 		retval = 1;
 		if (!uncertain)
 			do_warn(_("bad version number 0x%x on inode %llu%c"),
-				(__s8)dinoc->di_version, lino,
+				(__s8)dip->di_version, lino,
 				verify_mode ? '\n' : ',');
 		if (!verify_mode) {
 			if (!no_modify) {
 				do_warn(_(" resetting version number\n"));
-				dinoc->di_version = (fs_inode_nlink) ?
-					XFS_DINODE_VERSION_2 :
-					XFS_DINODE_VERSION_1;
+				dip->di_version = (fs_inode_nlink) ? 2 : 1;
 				*dirty = 1;
 			} else
 				do_warn(_(" would reset version number\n"));
@@ -2476,10 +2435,10 @@
 	/*
 	 * blow out of here if the inode size is < 0
 	 */
-	if ((xfs_fsize_t)be64_to_cpu(dinoc->di_size) < 0)  {
+	if ((xfs_fsize_t)be64_to_cpu(dip->di_size) < 0)  {
 		if (!uncertain)
 			do_warn(_("bad (negative) size %lld on inode %llu\n"),
-				be64_to_cpu(dinoc->di_size), lino);
+				be64_to_cpu(dip->di_size), lino);
 		if (verify_mode)
 			return 1;
 		goto clear_bad_out;
@@ -2500,7 +2459,7 @@
 			 * set correctly
 			 */
 			if (!no_modify)
-				*dirty += clear_dinode(mp, dino, lino);
+				*dirty += clear_dinode(mp, dip, lino);
 			*used = is_free;
 			return 0;
 		}
@@ -2512,7 +2471,7 @@
 		do_warn(_("imap claims a free inode %llu is in use, "), lino);
 		if (!no_modify)  {
 			do_warn(_("correcting imap and clearing inode\n"));
-			*dirty += clear_dinode(mp, dino, lino);
+			*dirty += clear_dinode(mp, dip, lino);
 			retval = 1;
 		} else
 			do_warn(_("would correct imap and clear inode\n"));
@@ -2529,7 +2488,7 @@
 	 * free inodes since technically any format is legal
 	 * as we reset the inode when we re-use it.
 	 */
-	if (di_mode != 0 && check_dinode_mode_format(dinoc) != 0) {
+	if (di_mode != 0 && check_dinode_mode_format(dip) != 0) {
 		if (!uncertain)
 			do_warn(_("bad inode format in inode %llu\n"), lino);
 		if (verify_mode)
@@ -2549,7 +2508,7 @@
 	 * phase 4.  Ugly.
 	 */
 	if (check_dups && !no_modify)
-		*dirty += clear_dinode_unlinked(mp, dino);
+		*dirty += clear_dinode_unlinked(mp, dip);
 
 	/* set type and map type info */
 
@@ -2559,7 +2518,7 @@
 		*isa_dir = 1;
 		break;
 	case S_IFREG:
-		if (be16_to_cpu(dinoc->di_flags) & XFS_DIFLAG_REALTIME)
+		if (be16_to_cpu(dip->di_flags) & XFS_DIFLAG_REALTIME)
 			type = XR_INO_RTDATA;
 		else if (lino == mp->m_sb.sb_rbmino)
 			type = XR_INO_RTBITMAP;
@@ -2592,27 +2551,27 @@
 	/*
 	 * type checks for superblock inodes
 	 */
-	if (process_check_sb_inodes(mp, dinoc, lino, &type, dirty) != 0)
+	if (process_check_sb_inodes(mp, dip, lino, &type, dirty) != 0)
 		goto clear_bad_out;
 
 	/*
 	 * only regular files with REALTIME or EXTSIZE flags set can have
 	 * extsize set, or directories with EXTSZINHERIT.
 	 */
-	if (be32_to_cpu(dinoc->di_extsize) != 0) {
+	if (be32_to_cpu(dip->di_extsize) != 0) {
 		if ((type == XR_INO_RTDATA) ||
-		    (type == XR_INO_DIR && (be16_to_cpu(dinoc->di_flags) &
+		    (type == XR_INO_DIR && (be16_to_cpu(dip->di_flags) &
 					XFS_DIFLAG_EXTSZINHERIT)) ||
-		    (type == XR_INO_DATA && (be16_to_cpu(dinoc->di_flags) &
+		    (type == XR_INO_DATA && (be16_to_cpu(dip->di_flags) &
 				 XFS_DIFLAG_EXTSIZE)))  {
 			/* s'okay */ ;
 		} else {
 			do_warn(_("bad non-zero extent size %u for "
 					"non-realtime/extsize inode %llu, "),
-					be32_to_cpu(dinoc->di_extsize), lino);
+					be32_to_cpu(dip->di_extsize), lino);
 			if (!no_modify)  {
 				do_warn(_("resetting to zero\n"));
-				dinoc->di_extsize = 0;
+				dip->di_extsize = 0;
 				*dirty = 1;
 			} else
 				do_warn(_("would reset to zero\n"));
@@ -2622,19 +2581,19 @@
 	/*
 	 * general size/consistency checks:
 	 */
-	if (process_check_inode_sizes(mp, dino, lino, type) != 0)
+	if (process_check_inode_sizes(mp, dip, lino, type) != 0)
 		goto clear_bad_out;
 
 	/*
 	 * check for illegal values of forkoff
 	 */
-	if (process_check_inode_forkoff(mp, dinoc, lino) != 0)
+	if (process_check_inode_forkoff(mp, dip, lino) != 0)
 		goto clear_bad_out;
 
 	/*
 	 * check data fork -- if it's bad, clear the inode
 	 */
-	if (process_inode_data_fork(mp, agno, ino, dino, type, dirty,
+	if (process_inode_data_fork(mp, agno, ino, dip, type, dirty,
 			&totblocks, &nextents, &dblkmap, check_dups) != 0)
 		goto bad_out;
 
@@ -2642,7 +2601,7 @@
 	 * check attribute fork if necessary.  attributes are
 	 * always stored in the regular filesystem.
 	 */
-	if (process_inode_attr_fork(mp, agno, ino, dino, type, dirty,
+	if (process_inode_attr_fork(mp, agno, ino, dip, type, dirty,
 			&atotblocks, &anextents, check_dups, extra_attr_check,
 			&retval))
 		goto bad_out;
@@ -2656,7 +2615,7 @@
 	/*
 	 * correct space counters if required
 	 */
-	if (process_inode_blocks_and_extents(dinoc, totblocks + atotblocks,
+	if (process_inode_blocks_and_extents(dip, totblocks + atotblocks,
 			nextents, anextents, lino, dirty) != 0)
 		goto clear_bad_out;
 
@@ -2666,9 +2625,9 @@
 	switch (type)  {
 	case XR_INO_DIR:
 		if (xfs_sb_version_hasdirv2(&mp->m_sb) ?
-				process_dir2(mp, lino, dino, ino_discovery,
+				process_dir2(mp, lino, dip, ino_discovery,
 						dirty, "", parent, dblkmap) :
-				process_dir(mp, lino, dino, ino_discovery,
+				process_dir(mp, lino, dip, ino_discovery,
 						dirty, "", parent, dblkmap)) {
 			do_warn(_("problem with directory contents in "
 				"inode %llu\n"), lino);
@@ -2676,7 +2635,7 @@
 		}
 		break;
 	case XR_INO_SYMLINK:
-		if (process_symlink(mp, lino, dino, dblkmap) != 0) {
+		if (process_symlink(mp, lino, dip, dblkmap) != 0) {
 			do_warn(_("problem with symbolic link in inode %llu\n"),
 				lino);
 			goto clear_bad_out;
@@ -2694,13 +2653,13 @@
 	 * just leave nlinks alone.  even if it's set wrong,
 	 * it'll be reset when read in.
 	 */
-	*dirty += process_check_inode_nlink_version(dinoc, lino);
+	*dirty += process_check_inode_nlink_version(dip, lino);
 
 	return retval;
 
 clear_bad_out:
 	if (!no_modify)  {
-		*dirty += clear_dinode(mp, dino, lino);
+		*dirty += clear_dinode(mp, dip, lino);
 		ASSERT(*dirty > 0);
 	}
 bad_out:
Index: xfs-cmds/xfsprogs/repair/dir.c
===================================================================
--- xfs-cmds.orig/xfsprogs/repair/dir.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/repair/dir.c	2008-12-06 20:05:49.000000000 +0100
@@ -107,7 +107,7 @@
 	sf = (xfs_dir_shortform_t *)XFS_DFORK_DPTR(dip);
 	max_size = XFS_DFORK_DSIZE(dip, mp);
 	num_entries = sf->hdr.count;
-	ino_dir_size = be64_to_cpu(dip->di_core.di_size);
+	ino_dir_size = be64_to_cpu(dip->di_size);
 	*repair = 0;
 
 	ASSERT(ino_dir_size <= max_size);
@@ -338,7 +338,7 @@
 
 			if (!no_modify)  {
 				tmp_elen = xfs_dir_sf_entsize_byentry(sf_entry);
-				be64_add_cpu(&dip->di_core.di_size, -tmp_elen);
+				be64_add_cpu(&dip->di_size, -tmp_elen);
 				ino_dir_size -= tmp_elen;
 
 				tmp_sfe = (xfs_dir_sf_entry_t *)
@@ -425,7 +425,7 @@
 				ino, (__int64_t) ino_dir_size,
 			(__int64_t)((__psint_t) next_sfe - (__psint_t) sf));
 
-			dip->di_core.di_size = cpu_to_be64((__psint_t)next_sfe 
+			dip->di_size = cpu_to_be64((__psint_t)next_sfe
 							- (__psint_t)sf);
 			*dino_dirty = 1;
 			*repair = 1;
@@ -954,7 +954,7 @@
 		return(fsbno);
 	}
 
-	if (be64_to_cpu(dino->di_core.di_size) <= XFS_LBSIZE(mp))
+	if (be64_to_cpu(dino->di_size) <= XFS_LBSIZE(mp))
 		return(fsbno);
 
 	do {
@@ -2551,7 +2551,7 @@
 	/*
 	 * sanity check inode size
 	 */
-	if (be64_to_cpu(dip->di_core.di_size) <
+	if (be64_to_cpu(dip->di_size) <
 			(da_cursor.greatest_bno + 1) * mp->m_sb.sb_blocksize)  {
 		if ((xfs_fsize_t) da_cursor.greatest_bno
 				* mp->m_sb.sb_blocksize > UINT_MAX)  {
@@ -2565,9 +2565,9 @@
 _("setting directory inode (%llu) size to %llu bytes, was %lld bytes\n"),
 			ino, (xfs_dfiloff_t) (da_cursor.greatest_bno + 1)
 				* mp->m_sb.sb_blocksize,
-			be64_to_cpu(dip->di_core.di_size));
+			be64_to_cpu(dip->di_size));
 
-		dip->di_core.di_size = cpu_to_be64((da_cursor.greatest_bno + 1) 
+		dip->di_size = cpu_to_be64((da_cursor.greatest_bno + 1)
 						* mp->m_sb.sb_blocksize);
 	}
 	return(0);
@@ -2709,13 +2709,13 @@
 	 * is only called ONCE so all the subordinate routines will
 	 * fix '.' and junk '..' if they're bogus.
 	 */
-	if (be64_to_cpu(dip->di_core.di_size) <= XFS_DFORK_DSIZE(dip, mp))  {
+	if (be64_to_cpu(dip->di_size) <= XFS_DFORK_DSIZE(dip, mp))  {
 		dot = 1;
 		dotdot = 1;
 		if (process_shortform_dir(mp, ino, dip, ino_discovery,
 				dino_dirty, parent, dirname, &repair))
 			res = 1;
-	} else if (be64_to_cpu(dip->di_core.di_size) <= XFS_LBSIZE(mp))  {
+	} else if (be64_to_cpu(dip->di_size) <= XFS_LBSIZE(mp))  {
 		if (process_leaf_dir(mp, ino, dip, ino_discovery,
 				dino_dirty, blkmap, &dot, &dotdot,
 				parent, dirname, &repair))
Index: xfs-cmds/xfsprogs/repair/dir2.c
===================================================================
--- xfs-cmds.orig/xfsprogs/repair/dir2.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/repair/dir2.c	2008-12-06 20:05:49.000000000 +0100
@@ -806,7 +806,7 @@
 	xfs_dir2_sf_entry_t	*sfep;
 	xfs_dir2_sf_t		*sfp;
 
-	sfp = &dip->di_u.di_dir2sf;
+	sfp = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
 
@@ -858,10 +858,10 @@
 	xfs_dir2_sf_entry_t	*tmp_sfep;
 	xfs_ino_t		zero = 0;
 
-	sfp = &dip->di_u.di_dir2sf;
+	sfp = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
 	max_size = XFS_DFORK_DSIZE(dip, mp);
 	num_entries = sfp->hdr.count;
-	ino_dir_size = be64_to_cpu(dip->di_core.di_size);
+	ino_dir_size = be64_to_cpu(dip->di_size);
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
 	bad_offset = *repair = 0;
 
@@ -1097,7 +1097,7 @@
 			if (!no_modify)  {
 				tmp_elen =
 					xfs_dir2_sf_entsize_byentry(sfp, sfep);
-				be64_add_cpu(&dip->di_core.di_size, -tmp_elen);
+				be64_add_cpu(&dip->di_size, -tmp_elen);
 				ino_dir_size -= tmp_elen;
 
 				tmp_sfep = (xfs_dir2_sf_entry_t *)
@@ -1205,7 +1205,7 @@
 				(__int64_t)((__psint_t)next_sfep -
 					    (__psint_t)sfp));
 
-			dip->di_core.di_size = cpu_to_be64(
+			dip->di_size = cpu_to_be64(
 					(__psint_t)next_sfep - (__psint_t)sfp);
 			*dino_dirty = 1;
 			*repair = 1;
@@ -2069,20 +2069,20 @@
 	 */
 	if (blkmap)
 		last = blkmap_last_off(blkmap);
-	if (be64_to_cpu(dip->di_core.di_size) <= XFS_DFORK_DSIZE(dip, mp) &&
-			dip->di_core.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (be64_to_cpu(dip->di_size) <= XFS_DFORK_DSIZE(dip, mp) &&
+			dip->di_format == XFS_DINODE_FMT_LOCAL) {
 		dot = dotdot = 1;
 		res = process_sf_dir2(mp, ino, dip, ino_discovery, dino_dirty,
 			dirname, parent, &repair);
 	} else if (last == mp->m_dirblkfsbs &&
-			(dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ||
-			dip->di_core.di_format == XFS_DINODE_FMT_BTREE)) {
+			(dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format == XFS_DINODE_FMT_BTREE)) {
 		res = process_block_dir2(mp, ino, dip, ino_discovery,
 			dino_dirty, dirname, parent, blkmap, &dot, &dotdot,
 			&repair);
 	} else if (last >= mp->m_dirleafblk + mp->m_dirblkfsbs &&
-			(dip->di_core.di_format == XFS_DINODE_FMT_EXTENTS ||
-			dip->di_core.di_format == XFS_DINODE_FMT_BTREE)) {
+			(dip->di_format == XFS_DINODE_FMT_EXTENTS ||
+			dip->di_format == XFS_DINODE_FMT_BTREE)) {
 		res = process_leaf_node_dir2(mp, ino, dip, ino_discovery,
 			dirname, parent, blkmap, &dot, &dotdot, &repair,
 			last > mp->m_dirleafblk + mp->m_dirblkfsbs);
Index: xfs-cmds/xfsprogs/repair/phase6.c
===================================================================
--- xfs-cmds.orig/xfsprogs/repair/phase6.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/repair/phase6.c	2008-12-06 20:05:49.000000000 +0100
@@ -444,11 +444,11 @@
 			error);
 	}
 
-	memset(&ip->i_d, 0, sizeof(xfs_dinode_core_t));
+	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = S_IFREG;
-	ip->i_d.di_version = XFS_DINODE_VERSION_1;
+	ip->i_d.di_version = 1;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
@@ -677,11 +677,11 @@
 			error);
 	}
 
-	memset(&ip->i_d, 0, sizeof(xfs_dinode_core_t));
+	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = S_IFREG;
-	ip->i_d.di_version = XFS_DINODE_VERSION_1;
+	ip->i_d.di_version = 1;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
@@ -778,11 +778,11 @@
 	/*
 	 * take care of the core -- initialization from xfs_ialloc()
 	 */
-	memset(&ip->i_d, 0, sizeof(xfs_dinode_core_t));
+	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = (__uint16_t) mode|S_IFDIR;
-	ip->i_d.di_version = XFS_DINODE_VERSION_1;
+	ip->i_d.di_version = 1;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
Index: xfs-cmds/xfsprogs/repair/prefetch.c
===================================================================
--- xfs-cmds.orig/xfsprogs/repair/prefetch.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/repair/prefetch.c	2008-12-06 20:05:49.000000000 +0100
@@ -330,7 +330,7 @@
 	xfs_dinode_t		*dino)
 {
 	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
-			be32_to_cpu(dino->di_core.di_nextents));
+			be32_to_cpu(dino->di_nextents));
 }
 
 static void
@@ -338,27 +338,25 @@
 	prefetch_args_t		*args,
 	xfs_buf_t		*bp)
 {
-	xfs_dinode_t		*dino;
 	int			icnt = 0;
 	int			hasdir = 0;
 	int			isadir;
-	xfs_dinode_core_t	*dinoc;
+	xfs_dinode_t		*dip;
 
 	for (icnt = 0; icnt < (XFS_BUF_COUNT(bp) >> mp->m_sb.sb_inodelog); icnt++) {
-		dino = XFS_MAKE_IPTR(mp, bp, icnt);
-		dinoc = &dino->di_core;
+		dip = XFS_MAKE_IPTR(mp, bp, icnt);
 
 		/*
 		 * We are only prefetching directory contents in extents
 		 * and btree nodes for other inodes
 		 */
-		isadir = (be16_to_cpu(dinoc->di_mode) & S_IFMT) == S_IFDIR;
+		isadir = (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFDIR;
 		hasdir |= isadir;
 
-		if (dinoc->di_format <= XFS_DINODE_FMT_LOCAL)
+		if (dip->di_format <= XFS_DINODE_FMT_LOCAL)
 			continue;
 
-		if (!isadir && (dinoc->di_format == XFS_DINODE_FMT_EXTENTS ||
+		if (!isadir && (dip->di_format == XFS_DINODE_FMT_EXTENTS ||
 				args->dirs_only))
 			continue;
 
@@ -367,30 +365,29 @@
 		 * its directory data. It's a cut down version of
 		 * process_dinode_int() in dinode.c.
 		 */
-		if (dinoc->di_format > XFS_DINODE_FMT_BTREE)
+		if (dip->di_format > XFS_DINODE_FMT_BTREE)
 			continue;
 
-		if (be16_to_cpu(dinoc->di_magic) != XFS_DINODE_MAGIC)
+		if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC)
 			continue;
 
-		if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
-				(!fs_inode_nlink && dinoc->di_version >
-					XFS_DINODE_VERSION_1))
+		if (!XFS_DINODE_GOOD_VERSION(dip->di_version) ||
+		    (!fs_inode_nlink && dip->di_version > 1))
 			continue;
 
-		if (be64_to_cpu(dinoc->di_size) <= XFS_DFORK_DSIZE(dino, mp))
+		if (be64_to_cpu(dip->di_size) <= XFS_DFORK_DSIZE(dip, mp))
 			continue;
 
-		if ((dinoc->di_forkoff != 0) &&
-				(dinoc->di_forkoff >= (XFS_LITINO(mp) >> 3)))
+		if (dip->di_forkoff &&
+		    (dip->di_forkoff >= (XFS_LITINO(mp) >> 3)))
 			continue;
 
-		switch (dinoc->di_format) {
+		switch (dip->di_format) {
 			case XFS_DINODE_FMT_EXTENTS:
-				pf_read_exinode(args, dino);
+				pf_read_exinode(args, dip);
 				break;
 			case XFS_DINODE_FMT_BTREE:
-				pf_read_btinode(args, dino, isadir);
+				pf_read_btinode(args, dip, isadir);
 				break;
 		}
 	}
Index: xfs-cmds/xfsprogs/include/libxfs.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/libxfs.h	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/include/libxfs.h	2008-12-06 20:05:49.000000000 +0100
@@ -389,10 +389,8 @@
 	struct cache_node	i_node;
 	xfs_mount_t		*i_mount;	/* fs mount struct ptr */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino) */
-	xfs_daddr_t		i_blkno;	/* blkno of inode buffer */
+	struct xfs_imap		i_imap;		/* location for xfs_imap() */
 	dev_t			i_dev;		/* dev for this inode */
-	ushort			i_len;		/* len of inode buffer */
-	ushort			i_boffset;	/* off of inode in buffer */
 	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
 	xfs_ifork_t		i_df;		/* data fork */
 	xfs_trans_t		*i_transp;	/* ptr to owning transaction */
@@ -419,8 +417,6 @@
 
 extern void	libxfs_ichgtime (xfs_inode_t *, int);
 extern int	libxfs_iflush_int (xfs_inode_t *, xfs_buf_t *);
-extern int	libxfs_iread (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
-				xfs_inode_t *, xfs_daddr_t);
 
 /* Inode Cache Interfaces */
 extern struct cache	*libxfs_icache;
@@ -465,7 +461,6 @@
 #include <xfs/xfs_attr_leaf.h>
 #include <xfs/xfs_quota.h>
 #include <xfs/xfs_trans_space.h>
-#include <xfs/xfs_imap.h>
 #include <xfs/xfs_log.h>
 #include <xfs/xfs_log_priv.h>
 
Index: xfs-cmds/xfsprogs/libxfs/logitem.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/logitem.c	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/libxfs/logitem.c	2008-12-06 20:05:49.000000000 +0100
@@ -493,7 +493,7 @@
 	iip->ili_inode = ip;
 	iip->ili_format.ilf_type = XFS_LI_INODE;
 	iip->ili_format.ilf_ino = ip->i_ino;
-	iip->ili_format.ilf_blkno = ip->i_blkno;
-	iip->ili_format.ilf_len = ip->i_len;
-	iip->ili_format.ilf_boffset = ip->i_boffset;
+	iip->ili_format.ilf_blkno = ip->i_imap.im_blkno;
+	iip->ili_format.ilf_len = ip->i_imap.im_len;
+	iip->ili_format.ilf_boffset = ip->i_imap.im_boffset;
 }
Index: xfs-cmds/xfsprogs/libxfs/rdwr.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/rdwr.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/libxfs/rdwr.c	2008-12-06 20:05:49.000000000 +0100
@@ -677,7 +677,10 @@
 		fprintf(stderr, "%s: allocated inode, ino=%llu(%llu), %p\n",
 			__FUNCTION__, (unsigned long long)ino, bno, ip);
 #endif
-		if ((error = libxfs_iread(mp, tp, ino, ip, bno))) {
+		ip->i_ino = ino;
+		ip->i_mount = mp;
+		error = xfs_iread(mp, tp, ip, bno, 0);
+		if (error) {
 			cache_node_purge(libxfs_icache, &ino,
 					(struct cache_node *)ip);
 			ip = NULL;
Index: xfs-cmds/xfsprogs/libxfs/trans.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/trans.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/libxfs/trans.c	2008-12-06 20:05:49.000000000 +0100
@@ -592,7 +592,7 @@
 	/*
 	 * Get the buffer containing the on-disk inode.
 	 */
-	error = xfs_itobp(mp, NULL, ip, &dip, &bp, 0, 0, 0);
+	error = xfs_itobp(mp, NULL, ip, &dip, &bp, 0);
 	if (error) {
 		fprintf(stderr, _("%s: warning - itobp failed (%d)\n"),
 			progname, error);
Index: xfs-cmds/xfsprogs/libxfs/xfs.h
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs.h	2008-12-06 20:05:45.000000000 +0100
+++ xfs-cmds/xfsprogs/libxfs/xfs.h	2008-12-06 20:05:49.000000000 +0100
@@ -181,6 +181,7 @@
 #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
 #define XFS_BUF_SET_VTYPE(a,b)		((void) 0)
 #define XFS_BUF_SET_VTYPE_REF(a,b,c)	((void) 0)
+#define XFS_BUF_SET_REF(a,b)		((void) 0)
 #define XFS_BUF_SET_BDSTRAT_FUNC(a,b)	((void) 0)
 
 #define xfs_incore(bt,blkno,len,lockit)	0
@@ -300,7 +301,6 @@
 /* xfs_inode.c */
 void xfs_iflush_fork(xfs_inode_t *, xfs_dinode_t *, xfs_inode_log_item_t *,
 			int, xfs_buf_t *);
-int xfs_iformat(xfs_inode_t *, xfs_dinode_t *);
 
 /* xfs_mount.c */
 int xfs_initialize_perag_data(xfs_mount_t *, xfs_agnumber_t);
Index: xfs-cmds/xfsprogs/libxfs/xfs_da_btree.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_da_btree.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/libxfs/xfs_da_btree.c	2008-12-06 20:05:49.000000000 +0100
@@ -1539,11 +1539,14 @@
 	int nmap, error, w, count, c, got, i, mapi;
 	xfs_trans_t *tp;
 	xfs_mount_t *mp;
+	xfs_drfsbno_t	nblks;
 
 	dp = args->dp;
 	mp = dp->i_mount;
 	w = args->whichfork;
 	tp = args->trans;
+	nblks = dp->i_d.di_nblocks;
+
 	/*
 	 * For new directories adjust the file offset and block count.
 	 */
@@ -1620,6 +1623,8 @@
 	}
 	if (mapp != &map)
 		kmem_free(mapp);
+	/* account for newly allocated blocks in reserved blocks total */
+	args->total -= dp->i_d.di_nblocks - nblks;
 	*new_blkno = (xfs_dablk_t)bno;
 	return 0;
 }
Index: xfs-cmds/xfsprogs/libxfs/xfs_bmap.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_bmap.c	2008-12-06 20:05:46.000000000 +0100
+++ xfs-cmds/xfsprogs/libxfs/xfs_bmap.c	2008-12-06 20:05:49.000000000 +0100
@@ -169,7 +169,7 @@
  * Remove the entry "free" from the free item list.  Prev points to the
  * previous entry, unless "free" is the head of the list.
  * 
- * Note: this requires user-space public scope for libxfs_iread
+ * Note: this requires user-space public scope for libxfs_bmap_finish
  */
 void
 xfs_bmap_del_free(
@@ -3250,7 +3250,7 @@
  * Remove the entry "free" from the free item list.  Prev points to the
  * previous entry, unless "free" is the head of the list.
  *
- * Note: this requires user-space public scope for libxfs_iread
+ * Note: this requires user-space public scope for libxfs_bmap_finish
  */
 void
 xfs_bmap_del_free(
Index: xfs-cmds/xfstests/186
===================================================================
--- xfs-cmds.orig/xfstests/186	2008-12-06 20:04:34.000000000 +0100
+++ xfs-cmds/xfstests/186	2008-12-06 20:05:59.000000000 +0100
@@ -66,7 +66,7 @@
 
 _filter_inode()
 {
-	tee -a $seq.full | egrep '^u.sfdir2|^a.sfattr|core.forkoff' |\
+	tee -a $seq.full | egrep '^u.sfdir2|^a.sfattr|forkoff' |\
 	egrep -v 'inumber|parent'
 }
 
Index: xfs-cmds/xfstests/186.out
===================================================================
--- xfs-cmds.orig/xfstests/186.out	2008-12-06 20:05:57.000000000 +0100
+++ xfs-cmds/xfstests/186.out	2008-12-06 20:05:59.000000000 +0100
@@ -2,7 +2,7 @@
 
 =================================
 ATTR2
-core.forkoff = 0
+forkoff = 0
 u.sfdir2.hdr.count = 0
 u.sfdir2.hdr.i8count = 0
 =================================
@@ -12,7 +12,7 @@
 
 =================================
 ATTR2
-core.forkoff = 0
+forkoff = 0
 u.sfdir2.hdr.count = 25
 u.sfdir2.hdr.i8count = 0
 u.sfdir2.list[0].namelen = 6
@@ -98,7 +98,7 @@
 =================================
 ATTR
 ATTR2
-core.forkoff = 47
+forkoff = 47
 u.sfdir2.hdr.count = 25
 u.sfdir2.hdr.i8count = 0
 u.sfdir2.list[0].namelen = 6
@@ -195,7 +195,7 @@
 
 =================================
 ATTR
-core.forkoff = 47
+forkoff = 47
 u.sfdir2.hdr.count = 25
 u.sfdir2.hdr.i8count = 0
 u.sfdir2.list[0].namelen = 6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

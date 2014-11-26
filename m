Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C5D987F57
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 13:14:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4ABA304070
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 11:14:43 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id ulrDAZXKQQjRASYI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 11:14:37 -0800 (PST)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xti2t-0002oy-6Q
	for xfs@oss.sgi.com; Wed, 26 Nov 2014 19:14:35 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] xfs: merge xfs_dinode.h into xfs_format.h
Date: Wed, 26 Nov 2014 20:14:23 +0100
Message-Id: <1417029267-20149-1-git-send-email-hch@lst.de>
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

More consolidatation for the on-disk format defintions.  Note that the
XFS_IS_REALTIME_INODE moves to xfs_linux.h instead as it is not related
to the on disk format, but depends on a CONFIG_ option.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c       |   1 -
 fs/xfs/libxfs/xfs_attr_leaf.c  |   1 -
 fs/xfs/libxfs/xfs_bmap.c       |   1 -
 fs/xfs/libxfs/xfs_bmap_btree.c |   1 -
 fs/xfs/libxfs/xfs_dinode.h     | 243 -----------------------------------------
 fs/xfs/libxfs/xfs_dir2.c       |   1 -
 fs/xfs/libxfs/xfs_dir2_block.c |   1 -
 fs/xfs/libxfs/xfs_dir2_sf.c    |   1 -
 fs/xfs/libxfs/xfs_format.h     | 214 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c     |   1 -
 fs/xfs/libxfs/xfs_inode_buf.c  |   1 -
 fs/xfs/libxfs/xfs_inode_fork.c |   1 -
 fs/xfs/libxfs/xfs_log_format.h |   2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c   |   1 -
 fs/xfs/libxfs/xfs_sb.c         |   1 -
 fs/xfs/xfs_aops.c              |   1 -
 fs/xfs/xfs_attr_inactive.c     |   1 -
 fs/xfs/xfs_attr_list.c         |   1 -
 fs/xfs/xfs_bmap_util.c         |   1 -
 fs/xfs/xfs_dir2_readdir.c      |   1 -
 fs/xfs/xfs_file.c              |   1 -
 fs/xfs/xfs_filestream.c        |   1 -
 fs/xfs/xfs_fsops.c             |   1 -
 fs/xfs/xfs_inode.h             |   2 -
 fs/xfs/xfs_inode_item.c        |   1 -
 fs/xfs/xfs_ioctl.c             |   1 -
 fs/xfs/xfs_iomap.c             |   1 -
 fs/xfs/xfs_iops.c              |   1 -
 fs/xfs/xfs_itable.c            |   1 -
 fs/xfs/xfs_linux.h             |   6 +
 fs/xfs/xfs_log_recover.c       |   1 -
 fs/xfs/xfs_mount.c             |   1 -
 fs/xfs/xfs_qm.c                |   1 -
 fs/xfs/xfs_rtalloc.c           |   1 -
 fs/xfs/xfs_super.c             |   1 -
 fs/xfs/xfs_symlink.c           |   1 -
 36 files changed, 221 insertions(+), 277 deletions(-)
 delete mode 100644 fs/xfs/libxfs/xfs_dinode.h

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 353fb42..4c0e33b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -42,7 +42,6 @@
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
-#include "xfs_dinode.h"
 
 /*
  * xfs_attr.c
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b1f73db..d9a172b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -41,7 +41,6 @@
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
-#include "xfs_dinode.h"
 #include "xfs_dir2.h"
 
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 79c9819..427c13f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -46,7 +46,6 @@
 #include "xfs_trace.h"
 #include "xfs_symlink.h"
 #include "xfs_attr_leaf.h"
-#include "xfs_dinode.h"
 #include "xfs_filestream.h"
 
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index fba7533..b016fc4 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -36,7 +36,6 @@
 #include "xfs_quota.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
-#include "xfs_dinode.h"
 
 /*
  * Determine the extent state.
diff --git a/fs/xfs/libxfs/xfs_dinode.h b/fs/xfs/libxfs/xfs_dinode.h
deleted file mode 100644
index 623bbe8..0000000
--- a/fs/xfs/libxfs/xfs_dinode.h
+++ /dev/null
@@ -1,243 +0,0 @@
-/*
- * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_DINODE_H__
-#define	__XFS_DINODE_H__
-
-#define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
-#define XFS_DINODE_GOOD_VERSION(v)	((v) >= 1 && (v) <= 3)
-
-typedef struct xfs_timestamp {
-	__be32		t_sec;		/* timestamp seconds */
-	__be32		t_nsec;		/* timestamp nanoseconds */
-} xfs_timestamp_t;
-
-/*
- * On-disk inode structure.
- *
- * This is just the header or "dinode core", the inode is expanded to fill a
- * variable size the leftover area split into a data and an attribute fork.
- * The format of the data and attribute fork depends on the format of the
- * inode as indicated by di_format and di_aformat.  To access the data and
- * attribute use the XFS_DFORK_DPTR, XFS_DFORK_APTR, and XFS_DFORK_PTR macros
- * below.
- *
- * There is a very similar struct icdinode in xfs_inode which matches the
- * layout of the first 96 bytes of this structure, but is kept in native
- * format instead of big endian.
- *
- * Note: di_flushiter is only used by v1/2 inodes - it's effectively a zeroed
- * padding field for v3 inodes.
- */
-typedef struct xfs_dinode {
-	__be16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
-	__be16		di_mode;	/* mode and type of file */
-	__u8		di_version;	/* inode version */
-	__u8		di_format;	/* format of di_c data */
-	__be16		di_onlink;	/* old number of links to file */
-	__be32		di_uid;		/* owner's user id */
-	__be32		di_gid;		/* owner's group id */
-	__be32		di_nlink;	/* number of links to file */
-	__be16		di_projid_lo;	/* lower part of owner's project id */
-	__be16		di_projid_hi;	/* higher part owner's project id */
-	__u8		di_pad[6];	/* unused, zeroed space */
-	__be16		di_flushiter;	/* incremented on flush */
-	xfs_timestamp_t	di_atime;	/* time last accessed */
-	xfs_timestamp_t	di_mtime;	/* time last modified */
-	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
-	__be64		di_size;	/* number of bytes in file */
-	__be64		di_nblocks;	/* # of direct & btree blocks used */
-	__be32		di_extsize;	/* basic/minimum extent size for file */
-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
-	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
-	__s8		di_aformat;	/* format of attr fork's data */
-	__be32		di_dmevmask;	/* DMIG event mask */
-	__be16		di_dmstate;	/* DMIG state info */
-	__be16		di_flags;	/* random flags, XFS_DIFLAG_... */
-	__be32		di_gen;		/* generation number */
-
-	/* di_next_unlinked is the only non-core field in the old dinode */
-	__be32		di_next_unlinked;/* agi unlinked list ptr */
-
-	/* start of the extended dinode, writable fields */
-	__le32		di_crc;		/* CRC of the inode */
-	__be64		di_changecount;	/* number of attribute changes */
-	__be64		di_lsn;		/* flush sequence */
-	__be64		di_flags2;	/* more random flags */
-	__u8		di_pad2[16];	/* more padding for future expansion */
-
-	/* fields only written to during inode creation */
-	xfs_timestamp_t	di_crtime;	/* time created */
-	__be64		di_ino;		/* inode number */
-	uuid_t		di_uuid;	/* UUID of the filesystem */
-
-	/* structure must be padded to 64 bit alignment */
-} xfs_dinode_t;
-
-#define XFS_DINODE_CRC_OFF	offsetof(struct xfs_dinode, di_crc)
-
-#define DI_MAX_FLUSH 0xffff
-
-/*
- * Size of the core inode on disk.  Version 1 and 2 inodes have
- * the same size, but version 3 has grown a few additional fields.
- */
-static inline uint xfs_dinode_size(int version)
-{
-	if (version == 3)
-		return sizeof(struct xfs_dinode);
-	return offsetof(struct xfs_dinode, di_crc);
-}
-
-/*
- * The 32 bit link count in the inode theoretically maxes out at UINT_MAX.
- * Since the pathconf interface is signed, we use 2^31 - 1 instead.
- * The old inode format had a 16 bit link count, so its maximum is USHRT_MAX.
- */
-#define	XFS_MAXLINK		((1U << 31) - 1U)
-#define	XFS_MAXLINK_1		65535U
-
-/*
- * Values for di_format
- */
-typedef enum xfs_dinode_fmt {
-	XFS_DINODE_FMT_DEV,		/* xfs_dev_t */
-	XFS_DINODE_FMT_LOCAL,		/* bulk data */
-	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
-	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
-	XFS_DINODE_FMT_UUID		/* uuid_t */
-} xfs_dinode_fmt_t;
-
-/*
- * Inode minimum and maximum sizes.
- */
-#define	XFS_DINODE_MIN_LOG	8
-#define	XFS_DINODE_MAX_LOG	11
-#define	XFS_DINODE_MIN_SIZE	(1 << XFS_DINODE_MIN_LOG)
-#define	XFS_DINODE_MAX_SIZE	(1 << XFS_DINODE_MAX_LOG)
-
-/*
- * Inode size for given fs.
- */
-#define XFS_LITINO(mp, version) \
-	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
-
-/*
- * Inode data & attribute fork sizes, per inode.
- */
-#define XFS_DFORK_Q(dip)		((dip)->di_forkoff != 0)
-#define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
-
-#define XFS_DFORK_DSIZE(dip,mp) \
-	(XFS_DFORK_Q(dip) ? \
-		XFS_DFORK_BOFF(dip) : \
-		XFS_LITINO(mp, (dip)->di_version))
-#define XFS_DFORK_ASIZE(dip,mp) \
-	(XFS_DFORK_Q(dip) ? \
-		XFS_LITINO(mp, (dip)->di_version) - XFS_DFORK_BOFF(dip) : \
-		0)
-#define XFS_DFORK_SIZE(dip,mp,w) \
-	((w) == XFS_DATA_FORK ? \
-		XFS_DFORK_DSIZE(dip, mp) : \
-		XFS_DFORK_ASIZE(dip, mp))
-
-/*
- * Return pointers to the data or attribute forks.
- */
-#define XFS_DFORK_DPTR(dip) \
-	((char *)dip + xfs_dinode_size(dip->di_version))
-#define XFS_DFORK_APTR(dip)	\
-	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
-#define XFS_DFORK_PTR(dip,w)	\
-	((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : XFS_DFORK_APTR(dip))
-
-#define XFS_DFORK_FORMAT(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		(dip)->di_format : \
-		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
-
-#define	XFS_BUF_TO_DINODE(bp)	((xfs_dinode_t *)((bp)->b_addr))
-
-/*
- * For block and character special files the 32bit dev_t is stored at the
- * beginning of the data fork.
- */
-static inline xfs_dev_t xfs_dinode_get_rdev(struct xfs_dinode *dip)
-{
-	return be32_to_cpu(*(__be32 *)XFS_DFORK_DPTR(dip));
-}
-
-static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
-{
-	*(__be32 *)XFS_DFORK_DPTR(dip) = cpu_to_be32(rdev);
-}
-
-/*
- * Values for di_flags
- * There should be a one-to-one correspondence between these flags and the
- * XFS_XFLAG_s.
- */
-#define XFS_DIFLAG_REALTIME_BIT  0	/* file's blocks come from rt area */
-#define XFS_DIFLAG_PREALLOC_BIT  1	/* file space has been preallocated */
-#define XFS_DIFLAG_NEWRTBM_BIT   2	/* for rtbitmap inode, new format */
-#define XFS_DIFLAG_IMMUTABLE_BIT 3	/* inode is immutable */
-#define XFS_DIFLAG_APPEND_BIT    4	/* inode is append-only */
-#define XFS_DIFLAG_SYNC_BIT      5	/* inode is written synchronously */
-#define XFS_DIFLAG_NOATIME_BIT   6	/* do not update atime */
-#define XFS_DIFLAG_NODUMP_BIT    7	/* do not dump */
-#define XFS_DIFLAG_RTINHERIT_BIT 8	/* create with realtime bit set */
-#define XFS_DIFLAG_PROJINHERIT_BIT   9	/* create with parents projid */
-#define XFS_DIFLAG_NOSYMLINKS_BIT   10	/* disallow symlink creation */
-#define XFS_DIFLAG_EXTSIZE_BIT      11	/* inode extent size allocator hint */
-#define XFS_DIFLAG_EXTSZINHERIT_BIT 12	/* inherit inode extent size */
-#define XFS_DIFLAG_NODEFRAG_BIT     13	/* do not reorganize/defragment */
-#define XFS_DIFLAG_FILESTREAM_BIT   14  /* use filestream allocator */
-#define XFS_DIFLAG_REALTIME      (1 << XFS_DIFLAG_REALTIME_BIT)
-#define XFS_DIFLAG_PREALLOC      (1 << XFS_DIFLAG_PREALLOC_BIT)
-#define XFS_DIFLAG_NEWRTBM       (1 << XFS_DIFLAG_NEWRTBM_BIT)
-#define XFS_DIFLAG_IMMUTABLE     (1 << XFS_DIFLAG_IMMUTABLE_BIT)
-#define XFS_DIFLAG_APPEND        (1 << XFS_DIFLAG_APPEND_BIT)
-#define XFS_DIFLAG_SYNC          (1 << XFS_DIFLAG_SYNC_BIT)
-#define XFS_DIFLAG_NOATIME       (1 << XFS_DIFLAG_NOATIME_BIT)
-#define XFS_DIFLAG_NODUMP        (1 << XFS_DIFLAG_NODUMP_BIT)
-#define XFS_DIFLAG_RTINHERIT     (1 << XFS_DIFLAG_RTINHERIT_BIT)
-#define XFS_DIFLAG_PROJINHERIT   (1 << XFS_DIFLAG_PROJINHERIT_BIT)
-#define XFS_DIFLAG_NOSYMLINKS    (1 << XFS_DIFLAG_NOSYMLINKS_BIT)
-#define XFS_DIFLAG_EXTSIZE       (1 << XFS_DIFLAG_EXTSIZE_BIT)
-#define XFS_DIFLAG_EXTSZINHERIT  (1 << XFS_DIFLAG_EXTSZINHERIT_BIT)
-#define XFS_DIFLAG_NODEFRAG      (1 << XFS_DIFLAG_NODEFRAG_BIT)
-#define XFS_DIFLAG_FILESTREAM    (1 << XFS_DIFLAG_FILESTREAM_BIT)
-
-#ifdef CONFIG_XFS_RT
-#define XFS_IS_REALTIME_INODE(ip) ((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME)
-#else
-#define XFS_IS_REALTIME_INODE(ip) (0)
-#endif
-
-#define XFS_DIFLAG_ANY \
-	(XFS_DIFLAG_REALTIME | XFS_DIFLAG_PREALLOC | XFS_DIFLAG_NEWRTBM | \
-	 XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND | XFS_DIFLAG_SYNC | \
-	 XFS_DIFLAG_NOATIME | XFS_DIFLAG_NODUMP | XFS_DIFLAG_RTINHERIT | \
-	 XFS_DIFLAG_PROJINHERIT | XFS_DIFLAG_NOSYMLINKS | XFS_DIFLAG_EXTSIZE | \
-	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM)
-
-#endif	/* __XFS_DINODE_H__ */
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 7075aaf..d6ddb3f 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -34,7 +34,6 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
-#include "xfs_dinode.h"
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 9628cec..a9afd7e 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -36,7 +36,6 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
-#include "xfs_dinode.h"
 
 /*
  * Local function prototypes.
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 5079e05..58133d2 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -32,7 +32,6 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
-#include "xfs_dinode.h"
 
 /*
  * Prototypes for internal functions.
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7e42bba..3be17ee 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -33,6 +33,220 @@ struct xfs_inode;
 struct xfs_buf;
 struct xfs_ifork;
 
+typedef struct xfs_timestamp {
+	__be32		t_sec;		/* timestamp seconds */
+	__be32		t_nsec;		/* timestamp nanoseconds */
+} xfs_timestamp_t;
+
+/*
+ * On-disk inode structure.
+ *
+ * This is just the header or "dinode core", the inode is expanded to fill a
+ * variable size the leftover area split into a data and an attribute fork.
+ * The format of the data and attribute fork depends on the format of the
+ * inode as indicated by di_format and di_aformat.  To access the data and
+ * attribute use the XFS_DFORK_DPTR, XFS_DFORK_APTR, and XFS_DFORK_PTR macros
+ * below.
+ *
+ * There is a very similar struct icdinode in xfs_inode which matches the
+ * layout of the first 96 bytes of this structure, but is kept in native
+ * format instead of big endian.
+ *
+ * Note: di_flushiter is only used by v1/2 inodes - it's effectively a zeroed
+ * padding field for v3 inodes.
+ */
+#define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
+#define XFS_DINODE_GOOD_VERSION(v)	((v) >= 1 && (v) <= 3)
+typedef struct xfs_dinode {
+	__be16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
+	__be16		di_mode;	/* mode and type of file */
+	__u8		di_version;	/* inode version */
+	__u8		di_format;	/* format of di_c data */
+	__be16		di_onlink;	/* old number of links to file */
+	__be32		di_uid;		/* owner's user id */
+	__be32		di_gid;		/* owner's group id */
+	__be32		di_nlink;	/* number of links to file */
+	__be16		di_projid_lo;	/* lower part of owner's project id */
+	__be16		di_projid_hi;	/* higher part owner's project id */
+	__u8		di_pad[6];	/* unused, zeroed space */
+	__be16		di_flushiter;	/* incremented on flush */
+	xfs_timestamp_t	di_atime;	/* time last accessed */
+	xfs_timestamp_t	di_mtime;	/* time last modified */
+	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
+	__be64		di_size;	/* number of bytes in file */
+	__be64		di_nblocks;	/* # of direct & btree blocks used */
+	__be32		di_extsize;	/* basic/minimum extent size for file */
+	__be32		di_nextents;	/* number of extents in data fork */
+	__be16		di_anextents;	/* number of extents in attribute fork*/
+	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
+	__s8		di_aformat;	/* format of attr fork's data */
+	__be32		di_dmevmask;	/* DMIG event mask */
+	__be16		di_dmstate;	/* DMIG state info */
+	__be16		di_flags;	/* random flags, XFS_DIFLAG_... */
+	__be32		di_gen;		/* generation number */
+
+	/* di_next_unlinked is the only non-core field in the old dinode */
+	__be32		di_next_unlinked;/* agi unlinked list ptr */
+
+	/* start of the extended dinode, writable fields */
+	__le32		di_crc;		/* CRC of the inode */
+	__be64		di_changecount;	/* number of attribute changes */
+	__be64		di_lsn;		/* flush sequence */
+	__be64		di_flags2;	/* more random flags */
+	__u8		di_pad2[16];	/* more padding for future expansion */
+
+	/* fields only written to during inode creation */
+	xfs_timestamp_t	di_crtime;	/* time created */
+	__be64		di_ino;		/* inode number */
+	uuid_t		di_uuid;	/* UUID of the filesystem */
+
+	/* structure must be padded to 64 bit alignment */
+} xfs_dinode_t;
+
+#define XFS_DINODE_CRC_OFF	offsetof(struct xfs_dinode, di_crc)
+
+#define DI_MAX_FLUSH 0xffff
+
+/*
+ * Size of the core inode on disk.  Version 1 and 2 inodes have
+ * the same size, but version 3 has grown a few additional fields.
+ */
+static inline uint xfs_dinode_size(int version)
+{
+	if (version == 3)
+		return sizeof(struct xfs_dinode);
+	return offsetof(struct xfs_dinode, di_crc);
+}
+
+/*
+ * The 32 bit link count in the inode theoretically maxes out at UINT_MAX.
+ * Since the pathconf interface is signed, we use 2^31 - 1 instead.
+ * The old inode format had a 16 bit link count, so its maximum is USHRT_MAX.
+ */
+#define	XFS_MAXLINK		((1U << 31) - 1U)
+#define	XFS_MAXLINK_1		65535U
+
+/*
+ * Values for di_format
+ */
+typedef enum xfs_dinode_fmt {
+	XFS_DINODE_FMT_DEV,		/* xfs_dev_t */
+	XFS_DINODE_FMT_LOCAL,		/* bulk data */
+	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
+	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
+	XFS_DINODE_FMT_UUID		/* uuid_t */
+} xfs_dinode_fmt_t;
+
+/*
+ * Inode minimum and maximum sizes.
+ */
+#define	XFS_DINODE_MIN_LOG	8
+#define	XFS_DINODE_MAX_LOG	11
+#define	XFS_DINODE_MIN_SIZE	(1 << XFS_DINODE_MIN_LOG)
+#define	XFS_DINODE_MAX_SIZE	(1 << XFS_DINODE_MAX_LOG)
+
+/*
+ * Inode size for given fs.
+ */
+#define XFS_LITINO(mp, version) \
+	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
+
+/*
+ * Inode data & attribute fork sizes, per inode.
+ */
+#define XFS_DFORK_Q(dip)		((dip)->di_forkoff != 0)
+#define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
+
+#define XFS_DFORK_DSIZE(dip,mp) \
+	(XFS_DFORK_Q(dip) ? \
+		XFS_DFORK_BOFF(dip) : \
+		XFS_LITINO(mp, (dip)->di_version))
+#define XFS_DFORK_ASIZE(dip,mp) \
+	(XFS_DFORK_Q(dip) ? \
+		XFS_LITINO(mp, (dip)->di_version) - XFS_DFORK_BOFF(dip) : \
+		0)
+#define XFS_DFORK_SIZE(dip,mp,w) \
+	((w) == XFS_DATA_FORK ? \
+		XFS_DFORK_DSIZE(dip, mp) : \
+		XFS_DFORK_ASIZE(dip, mp))
+
+/*
+ * Return pointers to the data or attribute forks.
+ */
+#define XFS_DFORK_DPTR(dip) \
+	((char *)dip + xfs_dinode_size(dip->di_version))
+#define XFS_DFORK_APTR(dip)	\
+	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
+#define XFS_DFORK_PTR(dip,w)	\
+	((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : XFS_DFORK_APTR(dip))
+
+#define XFS_DFORK_FORMAT(dip,w) \
+	((w) == XFS_DATA_FORK ? \
+		(dip)->di_format : \
+		(dip)->di_aformat)
+#define XFS_DFORK_NEXTENTS(dip,w) \
+	((w) == XFS_DATA_FORK ? \
+		be32_to_cpu((dip)->di_nextents) : \
+		be16_to_cpu((dip)->di_anextents))
+
+/*
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
+ * Values for di_flags
+ * There should be a one-to-one correspondence between these flags and the
+ * XFS_XFLAG_s.
+ */
+#define XFS_DIFLAG_REALTIME_BIT  0	/* file's blocks come from rt area */
+#define XFS_DIFLAG_PREALLOC_BIT  1	/* file space has been preallocated */
+#define XFS_DIFLAG_NEWRTBM_BIT   2	/* for rtbitmap inode, new format */
+#define XFS_DIFLAG_IMMUTABLE_BIT 3	/* inode is immutable */
+#define XFS_DIFLAG_APPEND_BIT    4	/* inode is append-only */
+#define XFS_DIFLAG_SYNC_BIT      5	/* inode is written synchronously */
+#define XFS_DIFLAG_NOATIME_BIT   6	/* do not update atime */
+#define XFS_DIFLAG_NODUMP_BIT    7	/* do not dump */
+#define XFS_DIFLAG_RTINHERIT_BIT 8	/* create with realtime bit set */
+#define XFS_DIFLAG_PROJINHERIT_BIT   9	/* create with parents projid */
+#define XFS_DIFLAG_NOSYMLINKS_BIT   10	/* disallow symlink creation */
+#define XFS_DIFLAG_EXTSIZE_BIT      11	/* inode extent size allocator hint */
+#define XFS_DIFLAG_EXTSZINHERIT_BIT 12	/* inherit inode extent size */
+#define XFS_DIFLAG_NODEFRAG_BIT     13	/* do not reorganize/defragment */
+#define XFS_DIFLAG_FILESTREAM_BIT   14  /* use filestream allocator */
+#define XFS_DIFLAG_REALTIME      (1 << XFS_DIFLAG_REALTIME_BIT)
+#define XFS_DIFLAG_PREALLOC      (1 << XFS_DIFLAG_PREALLOC_BIT)
+#define XFS_DIFLAG_NEWRTBM       (1 << XFS_DIFLAG_NEWRTBM_BIT)
+#define XFS_DIFLAG_IMMUTABLE     (1 << XFS_DIFLAG_IMMUTABLE_BIT)
+#define XFS_DIFLAG_APPEND        (1 << XFS_DIFLAG_APPEND_BIT)
+#define XFS_DIFLAG_SYNC          (1 << XFS_DIFLAG_SYNC_BIT)
+#define XFS_DIFLAG_NOATIME       (1 << XFS_DIFLAG_NOATIME_BIT)
+#define XFS_DIFLAG_NODUMP        (1 << XFS_DIFLAG_NODUMP_BIT)
+#define XFS_DIFLAG_RTINHERIT     (1 << XFS_DIFLAG_RTINHERIT_BIT)
+#define XFS_DIFLAG_PROJINHERIT   (1 << XFS_DIFLAG_PROJINHERIT_BIT)
+#define XFS_DIFLAG_NOSYMLINKS    (1 << XFS_DIFLAG_NOSYMLINKS_BIT)
+#define XFS_DIFLAG_EXTSIZE       (1 << XFS_DIFLAG_EXTSIZE_BIT)
+#define XFS_DIFLAG_EXTSZINHERIT  (1 << XFS_DIFLAG_EXTSZINHERIT_BIT)
+#define XFS_DIFLAG_NODEFRAG      (1 << XFS_DIFLAG_NODEFRAG_BIT)
+#define XFS_DIFLAG_FILESTREAM    (1 << XFS_DIFLAG_FILESTREAM_BIT)
+
+#define XFS_DIFLAG_ANY \
+	(XFS_DIFLAG_REALTIME | XFS_DIFLAG_PREALLOC | XFS_DIFLAG_NEWRTBM | \
+	 XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND | XFS_DIFLAG_SYNC | \
+	 XFS_DIFLAG_NOATIME | XFS_DIFLAG_NODUMP | XFS_DIFLAG_RTINHERIT | \
+	 XFS_DIFLAG_PROJINHERIT | XFS_DIFLAG_NOSYMLINKS | XFS_DIFLAG_EXTSIZE | \
+	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM)
+
+
 /*
  * RealTime Device format definitions
  */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 23dcb72..7eb2fca 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -39,7 +39,6 @@
 #include "xfs_buf_item.h"
 #include "xfs_icreate_item.h"
 #include "xfs_icache.h"
-#include "xfs_dinode.h"
 #include "xfs_trace.h"
 
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index f18fd2d..184c68e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -30,7 +30,6 @@
 #include "xfs_icache.h"
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
-#include "xfs_dinode.h"
 
 /*
  * Check that none of the inode's in the buffer have a next
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 6a00f7f..e45d833 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -34,7 +34,6 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index aff12f2..2653146 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -361,7 +361,7 @@ typedef struct xfs_ictimestamp {
 
 /*
  * NOTE:  This structure must be kept identical to struct xfs_dinode
- *	  in xfs_dinode.h except for the endianness annotations.
+ *	  except for the endianness annotations.
  */
 typedef struct xfs_icdinode {
 	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 7c818f1..de0fe1e 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -36,7 +36,6 @@
 #include "xfs_trace.h"
 #include "xfs_buf.h"
 #include "xfs_icache.h"
-#include "xfs_dinode.h"
 #include "xfs_rtalloc.h"
 
 
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5f902fa..1eed436 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -33,7 +33,6 @@
 #include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
-#include "xfs_dinode.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f5b2453..e4f27e7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -33,7 +33,6 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include <linux/aio.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index aa2a8b1..5665f46 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -39,7 +39,6 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trace.h"
-#include "xfs_dinode.h"
 #include "xfs_dir2.h"
 
 /*
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 62db83a..143435c 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -39,7 +39,6 @@
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
-#include "xfs_dinode.h"
 #include "xfs_dir2.h"
 
 STATIC int
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2810026..6bafbc0 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -42,7 +42,6 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_log.h"
-#include "xfs_dinode.h"
 
 /* Kernel only BMAP related definitions and functions */
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index f1b69ed..1e937fc 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -34,7 +34,6 @@
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
-#include "xfs_dinode.h"
 
 /*
  * Directory file type support functions
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index eb596b4..8fe87bb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,7 +37,6 @@
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
-#include "xfs_dinode.h"
 #include "xfs_icache.h"
 
 #include <linux/aio.h>
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index e92730c..fe47f3d 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -29,7 +29,6 @@
 #include "xfs_bmap_util.h"
 #include "xfs_alloc.h"
 #include "xfs_mru_cache.h"
-#include "xfs_dinode.h"
 #include "xfs_filestream.h"
 #include "xfs_trace.h"
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index c05ac8b..594af19 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -40,7 +40,6 @@
 #include "xfs_rtalloc.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
-#include "xfs_dinode.h"
 #include "xfs_filestream.h"
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9af2882..4ed2ba9 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -20,7 +20,6 @@
 
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
-#include "xfs_dinode.h"
 
 /*
  * Kernel only inode definitions
@@ -324,7 +323,6 @@ static inline int xfs_isiflocked(struct xfs_inode *ip)
 	(((pip)->i_mount->m_flags & XFS_MOUNT_GRPID) || \
 	 ((pip)->i_d.di_mode & S_ISGID))
 
-
 int		xfs_release(struct xfs_inode *ip);
 void		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 63de0b0..efa6e59 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -29,7 +29,6 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans_priv.h"
-#include "xfs_dinode.h"
 #include "xfs_log.h"
 
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 24c926b6..6a8737b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -40,7 +40,6 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_symlink.h"
-#include "xfs_dinode.h"
 #include "xfs_trans.h"
 
 #include <linux/capability.h>
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index afcf3c9..cf110224 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -38,7 +38,6 @@
 #include "xfs_quota.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
-#include "xfs_dinode.h"
 
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ec6dcdc..1e72c77 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -38,7 +38,6 @@
 #include "xfs_symlink.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
-#include "xfs_dinode.h"
 #include "xfs_trans_space.h"
 
 #include <linux/capability.h>
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 894924a..c3f51f6 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -33,7 +33,6 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
-#include "xfs_dinode.h"
 
 STATIC int
 xfs_internal_inum(
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 6a51619..c31d2c2 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -384,4 +384,10 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
 #endif /* XFS_WARN */
 #endif /* DEBUG */
 
+#ifdef CONFIG_XFS_RT
+#define XFS_IS_REALTIME_INODE(ip) ((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME)
+#else
+#define XFS_IS_REALTIME_INODE(ip) (0)
+#endif
+
 #endif /* __XFS_LINUX__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 00cd7f3..9b3fca6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -42,7 +42,6 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
 #include "xfs_error.h"
 #include "xfs_dir2.h"
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 51435db..faf3e36 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -41,7 +41,6 @@
 #include "xfs_fsops.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
-#include "xfs_dinode.h"
 #include "xfs_sysfs.h"
 
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d68f230..cca7445 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -38,7 +38,6 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_cksum.h"
-#include "xfs_dinode.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e1175ea..562dcdf 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -36,7 +36,6 @@
 #include "xfs_trace.h"
 #include "xfs_buf.h"
 #include "xfs_icache.h"
-#include "xfs_dinode.h"
 #include "xfs_rtalloc.h"
 
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9f622fe..8f02647 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -44,7 +44,6 @@
 #include "xfs_icache.h"
 #include "xfs_trace.h"
 #include "xfs_icreate_item.h"
-#include "xfs_dinode.h"
 #include "xfs_filestream.h"
 #include "xfs_quota.h"
 #include "xfs_sysfs.h"
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 02ae62a..f38a3f1 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -42,7 +42,6 @@
 #include "xfs_symlink.h"
 #include "xfs_trans.h"
 #include "xfs_log.h"
-#include "xfs_dinode.h"
 
 /* ----- Kernel only functions below ----- */
 STATIC int
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

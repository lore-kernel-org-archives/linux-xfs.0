Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8580A8048
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EC0CFAC010
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DnGQMEAiYNGWm7d6 for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:52 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RS-0004IZ-TY
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RS-0002KP-S9
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 17/49] xfs: split out inode log item format definition
Date: Fri, 19 Jul 2013 16:44:52 +1000
Message-Id: <1374216324-8781-18-git-send-email-david@fromorbit.com>
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

Th elog item format definitions are shared with userspace. split the
out of header files that contain kernel only defintions to make it
simple to shared them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile         |   4 +-
 include/libxfs.h         |   5 +-
 include/libxlog.h        |   1 -
 include/xfs_inode.h      |  70 ------------------
 include/xfs_inode_item.h | 170 ------------------------------------------
 include/xfs_log_format.h | 189 +++++++++++++++++++++++++++++++++++++++++++++++
 include/xfs_types.h      |   6 ++
 libxfs/trans.c           |   2 +-
 8 files changed, 202 insertions(+), 245 deletions(-)
 delete mode 100644 include/xfs_inode_item.h

diff --git a/include/Makefile b/include/Makefile
index efa3275..722aef3 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -26,7 +26,9 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_btree_trace.h xfs_buf_item.h xfs_cksum.h xfs_da_btree.h \
 	xfs_dinode.h xfs_dir2.h xfs_dir2_format.h \
 	xfs_extfree_item.h xfs_ialloc.h xfs_ialloc_btree.h \
-	xfs_icreate_item.h xfs_inode.h xfs_inode_item.h xfs_inum.h \
+	xfs_icreate_item.h \
+	xfs_inode.h \
+	xfs_inum.h \
 	xfs_log_format.h \
 	xfs_log_recover.h \
 	xfs_metadump.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index c9918cd..c96857b 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -36,6 +36,9 @@
 #include <xfs/xfs_types.h>
 #include <xfs/xfs_fs.h>
 #include <xfs/xfs_arch.h>
+
+#include <xfs/xfs_log_format.h>
+
 #include <xfs/xfs_bit.h>
 #include <xfs/xfs_inum.h>
 #include <xfs/xfs_sb.h>
@@ -50,7 +53,6 @@
 #include <xfs/xfs_dinode.h>
 #include <xfs/xfs_inode.h>
 #include <xfs/xfs_buf_item.h>
-#include <xfs/xfs_inode_item.h>
 #include <xfs/xfs_alloc.h>
 #include <xfs/xfs_btree.h>
 #include <xfs/xfs_btree_trace.h>
@@ -59,7 +61,6 @@
 #include <xfs/xfs_symlink.h>
 #include <xfs/xfs_icreate_item.h>
 
-#include <xfs/xfs_log_format.h>
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/libxlog.h b/include/libxlog.h
index 961c4b5..301e3dd 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -49,7 +49,6 @@ struct xlog {
 
 #include <xfs/xfs_log_recover.h>
 #include <xfs/xfs_buf_item.h>
-#include <xfs/xfs_inode_item.h>
 #include <xfs/xfs_extfree_item.h>
 #include <xfs/xfs_icreate_item.h>
 
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index fdca7f7..1e92338 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -23,12 +23,6 @@ struct xfs_dinode;
 struct xfs_inode;
 
 /*
- * Fork identifiers.
- */
-#define	XFS_DATA_FORK	0
-#define	XFS_ATTR_FORK	1
-
-/*
  * The following xfs_ext_irec_t struct introduces a second (top) level
  * to the in-core extent allocation scheme. These structs are allocated
  * in a contiguous block, creating an indirection array where each entry
@@ -113,69 +107,6 @@ struct xfs_imap {
  * i_mnext and i_mprev fields, it is used as a marker in the inode
  * chain off the mount structure by xfs_sync calls.
  */
-
-typedef struct xfs_ictimestamp {
-	__int32_t	t_sec;		/* timestamp seconds */
-	__int32_t	t_nsec;		/* timestamp nanoseconds */
-} xfs_ictimestamp_t;
-
-/*
- * NOTE:  This structure must be kept identical to struct xfs_dinode
- * 	  in xfs_dinode.h except for the endianness annotations.
- */
-typedef struct xfs_icdinode {
-	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
-	__uint16_t	di_mode;	/* mode and type of file */
-	__int8_t	di_version;	/* inode version */
-	__int8_t	di_format;	/* format of di_c data */
-	__uint16_t	di_onlink;	/* old number of links to file */
-	__uint32_t	di_uid;		/* owner's user id */
-	__uint32_t	di_gid;		/* owner's group id */
-	__uint32_t	di_nlink;	/* number of links to file */
-	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
-	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
-	__uint8_t	di_pad[6];	/* unused, zeroed space */
-	__uint16_t	di_flushiter;	/* incremented on flush */
-	xfs_ictimestamp_t di_atime;	/* time last accessed */
-	xfs_ictimestamp_t di_mtime;	/* time last modified */
-	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
-	xfs_fsize_t	di_size;	/* number of bytes in file */
-	xfs_drfsbno_t	di_nblocks;	/* # of direct & btree blocks used */
-	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
-	__uint8_t	di_forkoff;	/* attr fork offs, <<3 for 64b align */
-	__int8_t	di_aformat;	/* format of attr fork's data */
-	__uint32_t	di_dmevmask;	/* DMIG event mask */
-	__uint16_t	di_dmstate;	/* DMIG state info */
-	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
-	__uint32_t	di_gen;		/* generation number */
-
-	/* di_next_unlinked is the only non-core field in the old dinode */
-	__be32		di_next_unlinked;/* agi unlinked list ptr */
-
-	/* start of the extended dinode, writable fields */
-	__uint32_t	di_crc;		/* CRC of the inode */
-	__uint64_t	di_changecount;	/* number of attribute changes */
-	xfs_lsn_t	di_lsn;		/* flush sequence */
-	__uint64_t	di_flags2;	/* more random flags */
-	__uint8_t	di_pad2[16];	/* more padding for future expansion */
-
-	/* fields only written to during inode creation */
-	xfs_ictimestamp_t di_crtime;	/* time created */
-	xfs_ino_t	di_ino;		/* inode number */
-	uuid_t		di_uuid;	/* UUID of the filesystem */
-
-	/* structure must be padded to 64 bit alignment */
-} xfs_icdinode_t;
-
-static inline uint xfs_icdinode_size(int version)
-{
-	if (version == 3)
-		return sizeof(struct xfs_icdinode);
-	return offsetof(struct xfs_icdinode, di_next_unlinked);
-}
-
 /*
  * Flags for xfs_ichgtime().
  */
@@ -625,7 +556,6 @@ void		xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 
 extern struct kmem_zone	*xfs_ifork_zone;
 extern struct kmem_zone	*xfs_inode_zone;
-extern struct kmem_zone	*xfs_ili_zone;
 extern const struct xfs_buf_ops xfs_inode_buf_ops;
 
 #endif	/* __XFS_INODE_H__ */
diff --git a/include/xfs_inode_item.h b/include/xfs_inode_item.h
deleted file mode 100644
index 779812f..0000000
--- a/include/xfs_inode_item.h
+++ /dev/null
@@ -1,170 +0,0 @@
-/*
- * Copyright (c) 2000,2005 Silicon Graphics, Inc.
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
-#ifndef	__XFS_INODE_ITEM_H__
-#define	__XFS_INODE_ITEM_H__
-
-/*
- * This is the structure used to lay out an inode log item in the
- * log.  The size of the inline data/extents/b-tree root to be logged
- * (if any) is indicated in the ilf_dsize field.  Changes to this structure
- * must be added on to the end.
- */
-typedef struct xfs_inode_log_format {
-	__uint16_t		ilf_type;	/* inode log item type */
-	__uint16_t		ilf_size;	/* size of this item */
-	__uint32_t		ilf_fields;	/* flags for fields logged */
-	__uint16_t		ilf_asize;	/* size of attr d/ext/root */
-	__uint16_t		ilf_dsize;	/* size of data/ext/root */
-	__uint64_t		ilf_ino;	/* inode number */
-	union {
-		__uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
-		uuid_t		ilfu_uuid;	/* mount point value */
-	} ilf_u;
-	__int64_t		ilf_blkno;	/* blkno of inode buffer */
-	__int32_t		ilf_len;	/* len of inode buffer */
-	__int32_t		ilf_boffset;	/* off of inode in buffer */
-} xfs_inode_log_format_t;
-
-typedef struct xfs_inode_log_format_32 {
-	__uint16_t		ilf_type;	/* inode log item type */
-	__uint16_t		ilf_size;	/* size of this item */
-	__uint32_t		ilf_fields;	/* flags for fields logged */
-	__uint16_t		ilf_asize;	/* size of attr d/ext/root */
-	__uint16_t		ilf_dsize;	/* size of data/ext/root */
-	__uint64_t		ilf_ino;	/* inode number */
-	union {
-		__uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
-		uuid_t		ilfu_uuid;	/* mount point value */
-	} ilf_u;
-	__int64_t		ilf_blkno;	/* blkno of inode buffer */
-	__int32_t		ilf_len;	/* len of inode buffer */
-	__int32_t		ilf_boffset;	/* off of inode in buffer */
-} __attribute__((packed)) xfs_inode_log_format_32_t;
-
-typedef struct xfs_inode_log_format_64 {
-	__uint16_t		ilf_type;	/* inode log item type */
-	__uint16_t		ilf_size;	/* size of this item */
-	__uint32_t		ilf_fields;	/* flags for fields logged */
-	__uint16_t		ilf_asize;	/* size of attr d/ext/root */
-	__uint16_t		ilf_dsize;	/* size of data/ext/root */
-	__uint32_t		ilf_pad;	/* pad for 64 bit boundary */
-	__uint64_t		ilf_ino;	/* inode number */
-	union {
-		__uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
-		uuid_t		ilfu_uuid;	/* mount point value */
-	} ilf_u;
-	__int64_t		ilf_blkno;	/* blkno of inode buffer */
-	__int32_t		ilf_len;	/* len of inode buffer */
-	__int32_t		ilf_boffset;	/* off of inode in buffer */
-} xfs_inode_log_format_64_t;
-
-/*
- * Flags for xfs_trans_log_inode flags field.
- */
-#define	XFS_ILOG_CORE	0x001	/* log standard inode fields */
-#define	XFS_ILOG_DDATA	0x002	/* log i_df.if_data */
-#define	XFS_ILOG_DEXT	0x004	/* log i_df.if_extents */
-#define	XFS_ILOG_DBROOT	0x008	/* log i_df.i_broot */
-#define	XFS_ILOG_DEV	0x010	/* log the dev field */
-#define	XFS_ILOG_UUID	0x020	/* log the uuid field */
-#define	XFS_ILOG_ADATA	0x040	/* log i_af.if_data */
-#define	XFS_ILOG_AEXT	0x080	/* log i_af.if_extents */
-#define	XFS_ILOG_ABROOT	0x100	/* log i_af.i_broot */
-
-
-/*
- * The timestamps are dirty, but not necessarily anything else in the inode
- * core.  Unlike the other fields above this one must never make it to disk
- * in the ilf_fields of the inode_log_format, but is purely store in-memory in
- * ili_fields in the inode_log_item.
- */
-#define XFS_ILOG_TIMESTAMP	0x4000
-
-#define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
-				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
-				 XFS_ILOG_UUID | XFS_ILOG_ADATA | \
-				 XFS_ILOG_AEXT | XFS_ILOG_ABROOT)
-
-#define	XFS_ILOG_DFORK		(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
-				 XFS_ILOG_DBROOT)
-
-#define	XFS_ILOG_AFORK		(XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
-				 XFS_ILOG_ABROOT)
-
-#define	XFS_ILOG_ALL		(XFS_ILOG_CORE | XFS_ILOG_DDATA | \
-				 XFS_ILOG_DEXT | XFS_ILOG_DBROOT | \
-				 XFS_ILOG_DEV | XFS_ILOG_UUID | \
-				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
-				 XFS_ILOG_ABROOT | XFS_ILOG_TIMESTAMP)
-
-static inline int xfs_ilog_fbroot(int w)
-{
-	return (w == XFS_DATA_FORK ? XFS_ILOG_DBROOT : XFS_ILOG_ABROOT);
-}
-
-static inline int xfs_ilog_fext(int w)
-{
-	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
-}
-
-static inline int xfs_ilog_fdata(int w)
-{
-	return (w == XFS_DATA_FORK ? XFS_ILOG_DDATA : XFS_ILOG_ADATA);
-}
-
-#ifdef __KERNEL__
-
-struct xfs_buf;
-struct xfs_bmbt_rec;
-struct xfs_inode;
-struct xfs_mount;
-
-
-typedef struct xfs_inode_log_item {
-	xfs_log_item_t		ili_item;	   /* common portion */
-	struct xfs_inode	*ili_inode;	   /* inode ptr */
-	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
-	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
-	unsigned short		ili_lock_flags;	   /* lock flags */
-	unsigned short		ili_logged;	   /* flushed logged data */
-	unsigned int		ili_last_fields;   /* fields when flushed */
-	unsigned int		ili_fields;	   /* fields to be logged */
-	struct xfs_bmbt_rec	*ili_extents_buf;  /* array of logged
-						      data exts */
-	struct xfs_bmbt_rec	*ili_aextents_buf; /* array of logged
-						      attr exts */
-	xfs_inode_log_format_t	ili_format;	   /* logged structure */
-} xfs_inode_log_item_t;
-
-
-static inline int xfs_inode_clean(xfs_inode_t *ip)
-{
-	return !ip->i_itemp || !(ip->i_itemp->ili_fields & XFS_ILOG_ALL);
-}
-
-extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
-extern void xfs_inode_item_destroy(struct xfs_inode *);
-extern void xfs_iflush_done(struct xfs_buf *, struct xfs_log_item *);
-extern void xfs_istale_done(struct xfs_buf *, struct xfs_log_item *);
-extern void xfs_iflush_abort(struct xfs_inode *, bool);
-extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
-					 xfs_inode_log_format_t *);
-
-#endif	/* __KERNEL__ */
-
-#endif	/* __XFS_INODE_ITEM_H__ */
diff --git a/include/xfs_log_format.h b/include/xfs_log_format.h
index 9f9aeb6..fd46a7f 100644
--- a/include/xfs_log_format.h
+++ b/include/xfs_log_format.h
@@ -18,6 +18,16 @@
 #ifndef	__XFS_LOG_FORMAT_H__
 #define __XFS_LOG_FORMAT_H__
 
+/*
+ * On-disk Log Format definitions.
+ *
+ * This file contains all the on-disk format definitions used within the log. It
+ * includes the physical log structure itself, as well as all the log item
+ * format structures that are written into the log and intepreted by log
+ * recovery. We start with the physical log format definitions, and then work
+ * through all the log items definitions and everything they encode into the
+ * log.
+ */
 typedef __uint32_t xlog_tid_t;
 
 #define XLOG_MIN_ICLOGS		2
@@ -175,4 +185,183 @@ typedef struct xfs_log_iovec {
 	uint		i_type;		/* type of region */
 } xfs_log_iovec_t;
 
+
+/*
+ * Inode Log Item Format definitions.
+ *
+ * This is the structure used to lay out an inode log item in the
+ * log.  The size of the inline data/extents/b-tree root to be logged
+ * (if any) is indicated in the ilf_dsize field.  Changes to this structure
+ * must be added on to the end.
+ */
+typedef struct xfs_inode_log_format {
+	__uint16_t		ilf_type;	/* inode log item type */
+	__uint16_t		ilf_size;	/* size of this item */
+	__uint32_t		ilf_fields;	/* flags for fields logged */
+	__uint16_t		ilf_asize;	/* size of attr d/ext/root */
+	__uint16_t		ilf_dsize;	/* size of data/ext/root */
+	__uint64_t		ilf_ino;	/* inode number */
+	union {
+		__uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
+		uuid_t		ilfu_uuid;	/* mount point value */
+	} ilf_u;
+	__int64_t		ilf_blkno;	/* blkno of inode buffer */
+	__int32_t		ilf_len;	/* len of inode buffer */
+	__int32_t		ilf_boffset;	/* off of inode in buffer */
+} xfs_inode_log_format_t;
+
+typedef struct xfs_inode_log_format_32 {
+	__uint16_t		ilf_type;	/* inode log item type */
+	__uint16_t		ilf_size;	/* size of this item */
+	__uint32_t		ilf_fields;	/* flags for fields logged */
+	__uint16_t		ilf_asize;	/* size of attr d/ext/root */
+	__uint16_t		ilf_dsize;	/* size of data/ext/root */
+	__uint64_t		ilf_ino;	/* inode number */
+	union {
+		__uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
+		uuid_t		ilfu_uuid;	/* mount point value */
+	} ilf_u;
+	__int64_t		ilf_blkno;	/* blkno of inode buffer */
+	__int32_t		ilf_len;	/* len of inode buffer */
+	__int32_t		ilf_boffset;	/* off of inode in buffer */
+} __attribute__((packed)) xfs_inode_log_format_32_t;
+
+typedef struct xfs_inode_log_format_64 {
+	__uint16_t		ilf_type;	/* inode log item type */
+	__uint16_t		ilf_size;	/* size of this item */
+	__uint32_t		ilf_fields;	/* flags for fields logged */
+	__uint16_t		ilf_asize;	/* size of attr d/ext/root */
+	__uint16_t		ilf_dsize;	/* size of data/ext/root */
+	__uint32_t		ilf_pad;	/* pad for 64 bit boundary */
+	__uint64_t		ilf_ino;	/* inode number */
+	union {
+		__uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
+		uuid_t		ilfu_uuid;	/* mount point value */
+	} ilf_u;
+	__int64_t		ilf_blkno;	/* blkno of inode buffer */
+	__int32_t		ilf_len;	/* len of inode buffer */
+	__int32_t		ilf_boffset;	/* off of inode in buffer */
+} xfs_inode_log_format_64_t;
+
+/*
+ * Flags for xfs_trans_log_inode flags field.
+ */
+#define	XFS_ILOG_CORE	0x001	/* log standard inode fields */
+#define	XFS_ILOG_DDATA	0x002	/* log i_df.if_data */
+#define	XFS_ILOG_DEXT	0x004	/* log i_df.if_extents */
+#define	XFS_ILOG_DBROOT	0x008	/* log i_df.i_broot */
+#define	XFS_ILOG_DEV	0x010	/* log the dev field */
+#define	XFS_ILOG_UUID	0x020	/* log the uuid field */
+#define	XFS_ILOG_ADATA	0x040	/* log i_af.if_data */
+#define	XFS_ILOG_AEXT	0x080	/* log i_af.if_extents */
+#define	XFS_ILOG_ABROOT	0x100	/* log i_af.i_broot */
+
+
+/*
+ * The timestamps are dirty, but not necessarily anything else in the inode
+ * core.  Unlike the other fields above this one must never make it to disk
+ * in the ilf_fields of the inode_log_format, but is purely store in-memory in
+ * ili_fields in the inode_log_item.
+ */
+#define XFS_ILOG_TIMESTAMP	0x4000
+
+#define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
+				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
+				 XFS_ILOG_UUID | XFS_ILOG_ADATA | \
+				 XFS_ILOG_AEXT | XFS_ILOG_ABROOT)
+
+#define	XFS_ILOG_DFORK		(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
+				 XFS_ILOG_DBROOT)
+
+#define	XFS_ILOG_AFORK		(XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
+				 XFS_ILOG_ABROOT)
+
+#define	XFS_ILOG_ALL		(XFS_ILOG_CORE | XFS_ILOG_DDATA | \
+				 XFS_ILOG_DEXT | XFS_ILOG_DBROOT | \
+				 XFS_ILOG_DEV | XFS_ILOG_UUID | \
+				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
+				 XFS_ILOG_ABROOT | XFS_ILOG_TIMESTAMP)
+
+static inline int xfs_ilog_fbroot(int w)
+{
+	return (w == XFS_DATA_FORK ? XFS_ILOG_DBROOT : XFS_ILOG_ABROOT);
+}
+
+static inline int xfs_ilog_fext(int w)
+{
+	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
+}
+
+static inline int xfs_ilog_fdata(int w)
+{
+	return (w == XFS_DATA_FORK ? XFS_ILOG_DDATA : XFS_ILOG_ADATA);
+}
+
+/*
+ * Incore version of the on-disk inode core structures. We log this directly
+ * into the journal in host CPU format (for better or worse) and as such
+ * directly mirrors the xfs_dinode structure as it must contain all the same
+ * information.
+ */
+typedef struct xfs_ictimestamp {
+	__int32_t	t_sec;		/* timestamp seconds */
+	__int32_t	t_nsec;		/* timestamp nanoseconds */
+} xfs_ictimestamp_t;
+
+/*
+ * NOTE:  This structure must be kept identical to struct xfs_dinode
+ *	  in xfs_dinode.h except for the endianness annotations.
+ */
+typedef struct xfs_icdinode {
+	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
+	__uint16_t	di_mode;	/* mode and type of file */
+	__int8_t	di_version;	/* inode version */
+	__int8_t	di_format;	/* format of di_c data */
+	__uint16_t	di_onlink;	/* old number of links to file */
+	__uint32_t	di_uid;		/* owner's user id */
+	__uint32_t	di_gid;		/* owner's group id */
+	__uint32_t	di_nlink;	/* number of links to file */
+	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
+	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
+	__uint8_t	di_pad[6];	/* unused, zeroed space */
+	__uint16_t	di_flushiter;	/* incremented on flush */
+	xfs_ictimestamp_t di_atime;	/* time last accessed */
+	xfs_ictimestamp_t di_mtime;	/* time last modified */
+	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
+	xfs_fsize_t	di_size;	/* number of bytes in file */
+	xfs_drfsbno_t	di_nblocks;	/* # of direct & btree blocks used */
+	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
+	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
+	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	__uint8_t	di_forkoff;	/* attr fork offs, <<3 for 64b align */
+	__int8_t	di_aformat;	/* format of attr fork's data */
+	__uint32_t	di_dmevmask;	/* DMIG event mask */
+	__uint16_t	di_dmstate;	/* DMIG state info */
+	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
+	__uint32_t	di_gen;		/* generation number */
+
+	/* di_next_unlinked is the only non-core field in the old dinode */
+	xfs_agino_t	di_next_unlinked;/* agi unlinked list ptr */
+
+	/* start of the extended dinode, writable fields */
+	__uint32_t	di_crc;		/* CRC of the inode */
+	__uint64_t	di_changecount;	/* number of attribute changes */
+	xfs_lsn_t	di_lsn;		/* flush sequence */
+	__uint64_t	di_flags2;	/* more random flags */
+	__uint8_t	di_pad2[16];	/* more padding for future expansion */
+
+	/* fields only written to during inode creation */
+	xfs_ictimestamp_t di_crtime;	/* time created */
+	xfs_ino_t	di_ino;		/* inode number */
+	uuid_t		di_uuid;	/* UUID of the filesystem */
+
+	/* structure must be padded to 64 bit alignment */
+} xfs_icdinode_t;
+
+static inline uint xfs_icdinode_size(int version)
+{
+	if (version == 3)
+		return sizeof(struct xfs_icdinode);
+	return offsetof(struct xfs_icdinode, di_next_unlinked);
+}
 #endif /* __XFS_LOG_FORMAT_H__ */
diff --git a/include/xfs_types.h b/include/xfs_types.h
index dd6bf71..543fdf0 100644
--- a/include/xfs_types.h
+++ b/include/xfs_types.h
@@ -147,6 +147,12 @@ typedef __uint64_t	xfs_filblks_t;	/* number of blocks in a file */
 #define XFS_MAX_SECTORSIZE	(1 << XFS_MAX_SECTORSIZE_LOG)
 
 /*
+ * Inode fork identifiers.
+ */
+#define	XFS_DATA_FORK	0
+#define	XFS_ATTR_FORK	1
+
+/*
  * Min numbers of data/attr fork btree root pointers.
  */
 #define MINDBTPTRS	3
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 97220e7..645952c 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -226,7 +226,7 @@ libxfs_trans_inode_alloc_buf(
  * to be logged when the transaction is committed.  The inode must
  * already be associated with the given transaction.
  *
- * The values for fieldmask are defined in xfs_inode_item.h.  We always
+ * The values for fieldmask are defined in xfs_log_format.h.  We always
  * log all of the core inode if any of it has changed, and we always log
  * all of the inline data/extents/b-tree root if any of them has changed.
  */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

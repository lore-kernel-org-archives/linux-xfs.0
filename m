Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 11:53:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m99IrB7f010018
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 11:53:11 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9565AA2E91E
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2008 11:54:50 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 2t5I6bBkR5fhZ7EC for <xfs@oss.sgi.com>; Thu, 09 Oct 2008 11:54:50 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m99IsnIF007828
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 20:54:49 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m99Isnia007826
	for xfs@oss.sgi.com; Thu, 9 Oct 2008 20:54:49 +0200
Date: Thu, 9 Oct 2008 20:54:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] kill xfs_ialloc_log_di
Message-ID: <20081009185448.GA7583@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_ialloc_log_di alwasy logs the full inode core + di_next_unlinked, so
there's really no need for all the offset magic and we can just call
xfs_trans_log_buf directly from it's only user.  Also add a comment
describing what we should do here instead.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-10-09 09:12:06.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-10-09 10:47:18.000000000 +0200
@@ -41,68 +41,6 @@
 #include "xfs_error.h"
 #include "xfs_bmap.h"
 
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
@@ -406,18 +344,25 @@ xfs_ialloc_ag_alloc(
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
+			uint	isize = sizeof(xfs_dinode_t) + sizeof(__be32);
+
 			free = XFS_MAKE_IPTR(args.mp, fbuf, i);
 			free->di_core.di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 			free->di_core.di_version = version;
 			free->di_core.di_gen = cpu_to_be32(gen);
 			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
-			xfs_ialloc_log_di(tp, fbuf, i,
-				XFS_DI_CORE_BITS | XFS_DI_NEXT_UNLINKED);
+			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
 		}
 		xfs_trans_inode_alloc_buf(tp, fbuf);
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h	2008-10-09 09:24:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dinode.h	2008-10-09 10:47:18.000000000 +0200
@@ -106,40 +106,6 @@ typedef struct xfs_dinode
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
 typedef enum xfs_dinode_fmt

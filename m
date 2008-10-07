Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 13:20:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97KKGJO018984
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 13:20:18 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0AAE4C5BF1
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 13:21:55 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id gyx5X1tp2Ua041xh for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 13:21:55 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m97KLrIF016709
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 22:21:53 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m97KLr6D016707
	for xfs@oss.sgi.com; Tue, 7 Oct 2008 22:21:53 +0200
Date: Tue, 7 Oct 2008 22:21:53 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] kill XFS_LITINO
Message-ID: <20081007202153.GA16485@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

No point having a macro that just derefences a member of the struct
pointer passed in.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr_leaf.c	2008-10-07 19:50:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr_leaf.c	2008-10-07 19:51:10.000000000 +0200
@@ -106,7 +106,7 @@ xfs_attr_namesp_match(int arg_flags, int
 
 
 /*========================================================================
- * External routines when attribute fork size < XFS_LITINO(mp).
+ * External routines when attribute fork size < mp->m_litino.
  *========================================================================*/
 
 /*
@@ -127,7 +127,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 	int dsize;	
 	xfs_mount_t *mp = dp->i_mount;
 
-	offset = (XFS_LITINO(mp) - bytes) >> 3; /* rounded down */
+	offset = (mp->m_litino - bytes) >> 3; /* rounded down */
 
 	switch (dp->i_d.di_format) {
 	case XFS_DINODE_FMT_DEV:
@@ -184,7 +184,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
-	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	maxforkoff = mp->m_litino - XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */
 
 	if (offset >= minforkoff && offset < maxforkoff)
Index: linux-2.6-xfs/fs/xfs/xfs_attr_leaf.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr_leaf.h	2008-10-07 19:50:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr_leaf.h	2008-10-07 19:51:10.000000000 +0200
@@ -218,7 +218,7 @@ typedef struct xfs_attr_inactive_list {
  *========================================================================*/
 
 /*
- * Internal routines when attribute fork size < XFS_LITINO(mp).
+ * Internal routines when attribute fork size < mp->m_litino.
  */
 void	xfs_attr_shortform_create(struct xfs_da_args *args);
 void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h	2008-10-07 19:50:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dinode.h	2008-10-07 19:51:22.000000000 +0200
@@ -76,10 +76,6 @@ typedef struct xfs_dinode_core {
 typedef struct xfs_dinode
 {
 	xfs_dinode_core_t	di_core;
-	/*
-	 * In adding anything between the core and the union, be
-	 * sure to update the macros like XFS_LITINO below.
-	 */
 	__be32			di_next_unlinked;/* agi unlinked list ptr */
 	union {
 		xfs_bmdr_block_t di_bmbt;	/* btree root block */
@@ -160,10 +156,6 @@ typedef enum xfs_dinode_fmt
 #define	XFS_DINODE_MIN_SIZE	(1 << XFS_DINODE_MIN_LOG)
 #define	XFS_DINODE_MAX_SIZE	(1 << XFS_DINODE_MAX_LOG)
 
-/*
- * Inode size for given fs.
- */
-#define	XFS_LITINO(mp)	((mp)->m_litino)
 #define	XFS_BROOT_SIZE_ADJ	\
 	(XFS_BTREE_LBLOCK_LEN - sizeof(xfs_bmdr_block_t))
 
@@ -176,10 +168,10 @@ typedef enum xfs_dinode_fmt
 #define XFS_DFORK_DSIZE(dip,mp) \
 	(XFS_DFORK_Q(dip) ? \
 		XFS_DFORK_BOFF(dip) : \
-		XFS_LITINO(mp))
+		(mp)->m_litino)
 #define XFS_DFORK_ASIZE(dip,mp) \
 	(XFS_DFORK_Q(dip) ? \
-		XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : \
+		(mp)->m_litino - XFS_DFORK_BOFF(dip) : \
 		0)
 #define XFS_DFORK_SIZE(dip,mp,w) \
 	((w) == XFS_DATA_FORK ? \
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-10-07 19:50:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-10-07 19:51:10.000000000 +0200
@@ -177,10 +177,10 @@ typedef struct xfs_icdinode {
 #define XFS_IFORK_DSIZE(ip) \
 	(XFS_IFORK_Q(ip) ? \
 		XFS_IFORK_BOFF(ip) : \
-		XFS_LITINO((ip)->i_mount))
+		(ip)->i_mount->m_litino)
 #define XFS_IFORK_ASIZE(ip) \
 	(XFS_IFORK_Q(ip) ? \
-		XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : \
+		(ip)->i_mount->m_litino - XFS_IFORK_BOFF(ip) : \
 		0)
 #define XFS_IFORK_SIZE(ip,w) \
 	((w) == XFS_DATA_FORK ? \
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-10-07 19:50:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-10-07 19:51:10.000000000 +0200
@@ -590,8 +590,8 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
 	ASSERT(sbp->sb_inodesize >= 256 && sbp->sb_inodesize <= 2048);
 	switch (sbp->sb_inodesize) {
 	case 256:
-		mp->m_attroffset = XFS_LITINO(mp) -
-				   XFS_BMDR_SPACE_CALC(MINABTPTRS);
+		mp->m_attroffset =
+			mp->m_litino - XFS_BMDR_SPACE_CALC(MINABTPTRS);
 		break;
 	case 512:
 	case 1024:
@@ -601,7 +601,7 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
 	default:
 		ASSERT(0);
 	}
-	ASSERT(mp->m_attroffset < XFS_LITINO(mp));
+	ASSERT(mp->m_attroffset < mp->m_litino);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-10-07 19:50:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-10-07 19:51:10.000000000 +0200
@@ -2406,7 +2406,7 @@ xfs_symlink(
 	 * The symlink will fit into the inode data fork?
 	 * There can't be any attributes so we get the whole variable part.
 	 */
-	if (pathlen <= XFS_LITINO(mp))
+	if (pathlen <= mp->m_litino)
 		fs_blocks = 0;
 	else
 		fs_blocks = XFS_B_TO_FSB(mp, pathlen);

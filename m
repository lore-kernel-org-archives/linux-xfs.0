Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 04:52:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9LBq991015766
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 04:52:09 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E5041311D00
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 04:53:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id BVYSEWhlD51TUian for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 04:53:53 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KsFo9-0001C0-BJ
	for xfs@oss.sgi.com; Tue, 21 Oct 2008 11:53:53 +0000
Date: Tue, 21 Oct 2008 07:53:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/3] cleanup xfs_imap useage
Message-ID: <20081021115353.GA2881@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Embedd a struct xfs_imap into the xfs_inode as that's what we use
xfs_imap and xfs_imap_to_bp on mostly.  Remove the two superflous
members of struct xfs_imap so that the inode size stays the same.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-2.6/fs/xfs/xfs_inode.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode.c	2008-10-21 11:50:56.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.c	2008-10-21 11:58:37.000000000 +0200
@@ -23,7 +23,6 @@
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
-#include "xfs_imap.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_sb.h"
@@ -140,7 +139,7 @@ xfs_imap(
 	xfs_mount_t	*mp,
 	xfs_trans_t	*tp,
 	xfs_ino_t	ino,
-	xfs_imap_t	*imap,
+	struct xfs_imap	*imap,
 	uint		flags)
 {
 	xfs_fsblock_t	fsbno;
@@ -156,8 +155,6 @@ xfs_imap(
 
 	imap->im_blkno = XFS_FSB_TO_DADDR(mp, fsbno);
 	imap->im_len = XFS_FSB_TO_BB(mp, len);
-	imap->im_agblkno = XFS_FSB_TO_AGBNO(mp, fsbno);
-	imap->im_ioffset = (ushort)off;
 	imap->im_boffset = (ushort)(off << mp->m_sb.sb_inodelog);
 
 	/*
@@ -188,7 +185,7 @@ STATIC int
 xfs_imap_to_bp(
 	xfs_mount_t	*mp,
 	xfs_trans_t	*tp,
-	xfs_imap_t	*imap,
+	struct xfs_imap	*imap,
 	xfs_buf_t	**bpp,
 	uint		buf_flags,
 	uint		imap_flags)
@@ -286,7 +283,7 @@ xfs_inotobp(
 	int		*offset,
 	uint		imap_flags)
 {
-	xfs_imap_t	imap;
+	struct xfs_imap	imap;
 	xfs_buf_t	*bp;
 	int		error;
 
@@ -331,17 +328,12 @@ xfs_itobp(
 	xfs_buf_t	**bpp,
 	uint		buf_flags)
 {
-	xfs_imap_t	imap;
 	xfs_buf_t	*bp;
 	int		error;
 
-	ASSERT(ip->i_blkno != 0);
+	ASSERT(ip->i_imap.im_blkno != 0);
 
-	imap.im_blkno = ip->i_blkno;
-	imap.im_len = ip->i_len;
-	imap.im_boffset = ip->i_boffset;
-
-	error = xfs_imap_to_bp(mp, tp, &imap, &bp, buf_flags, 0);
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp, buf_flags, 0);
 	if (error)
 		return error;
 
@@ -352,7 +344,7 @@ xfs_itobp(
 		return EAGAIN;
 	}
 
-	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
+	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 	*bpp = bp;
 	return 0;
 }
@@ -855,9 +847,7 @@ xfs_inode_alloc(
 	/* initialise the xfs inode */
 	ip->i_ino = ino;
 	ip->i_mount = mp;
-	ip->i_blkno = 0;
-	ip->i_len = 0;
-	ip->i_boffset =0;
+	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
 	ip->i_afp = NULL;
 	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
 	ip->i_flags = 0;
@@ -913,7 +903,6 @@ xfs_iread(
 	xfs_buf_t	*bp;
 	xfs_dinode_t	*dip;
 	xfs_inode_t	*ip;
-	xfs_imap_t	imap;
 	int		error;
 
 	ip = xfs_inode_alloc(mp, ino);
@@ -921,27 +910,23 @@ xfs_iread(
 		return ENOMEM;
 
 	/*
-	 * Get pointer's to the on-disk inode and the buffer containing it.
+	 * Fill in the location information in the in-core inode.
 	 */
-	imap.im_blkno = bno;
-	error = xfs_imap(mp, tp, ip->i_ino, &imap, imap_flags);
+	ip->i_imap.im_blkno = bno;
+	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, imap_flags);
 	if (error)
 		goto out_destroy_inode;
 
+	ASSERT(bno == 0 || bno == ip->i_imap.im_blkno);
+
 	/*
-	 * Fill in the fields in the inode that will be used to
-	 * map the inode to its buffer from now on.
+	 * Get pointers to the on-disk inode and the buffer containing it.
 	 */
-	ip->i_blkno = imap.im_blkno;
-	ip->i_len = imap.im_len;
-	ip->i_boffset = imap.im_boffset;
-	ASSERT(bno == 0 || bno == imap.im_blkno);
-
-	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, imap_flags);
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp,
+			       XFS_BUF_LOCK, imap_flags);
 	if (error)
 		goto out_destroy_inode;
-
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
+	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
 	/*
 	 * If we got something that isn't an inode it means someone
@@ -1942,7 +1927,7 @@ xfs_iunlink(
 		ASSERT(be32_to_cpu(dip->di_next_unlinked) == NULLAGINO);
 		/* both on-disk, don't endian flip twice */
 		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
-		offset = ip->i_boffset +
+		offset = ip->i_imap.im_boffset +
 			offsetof(xfs_dinode_t, di_next_unlinked);
 		xfs_trans_inode_buf(tp, ibp);
 		xfs_trans_log_buf(tp, ibp, offset,
@@ -2054,7 +2039,7 @@ xfs_iunlink_remove(
 		ASSERT(next_agino != 0);
 		if (next_agino != NULLAGINO) {
 			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
-			offset = ip->i_boffset +
+			offset = ip->i_imap.im_boffset +
 				offsetof(xfs_dinode_t, di_next_unlinked);
 			xfs_trans_inode_buf(tp, ibp);
 			xfs_trans_log_buf(tp, ibp, offset,
@@ -2117,7 +2102,7 @@ xfs_iunlink_remove(
 		ASSERT(next_agino != agino);
 		if (next_agino != NULLAGINO) {
 			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
-			offset = ip->i_boffset +
+			offset = ip->i_imap.im_boffset +
 				offsetof(xfs_dinode_t, di_next_unlinked);
 			xfs_trans_inode_buf(tp, ibp);
 			xfs_trans_log_buf(tp, ibp, offset,
@@ -3296,7 +3281,7 @@ xfs_iflush_int(
 	}
 
 	/* set *dip = inode's place in the buffer */
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_boffset);
+	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
 	/*
 	 * Clear i_update_core before copying out the data.
Index: xfs-2.6/fs/xfs/xfs_inode.h
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode.h	2008-10-21 11:49:04.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.h	2008-10-21 11:56:52.000000000 +0200
@@ -84,6 +84,16 @@ typedef struct xfs_ifork {
 } xfs_ifork_t;
 
 /*
+ * Inode location information.  Stored in the inode and passed to
+ * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
+ */
+struct xfs_imap {
+	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
+	uint		im_len;		/* length in BBs of inode chunk */
+	ushort		im_boffset;	/* inode offset in block in bytes */
+};
+
+/*
  * This is the xfs in-core inode structure.
  * Most of the on-disk inode is embedded in the i_d field.
  *
@@ -239,9 +249,7 @@ typedef struct xfs_inode {
 
 	/* Inode location stuff */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
-	xfs_daddr_t		i_blkno;	/* blkno of inode buffer */
-	ushort			i_len;		/* len of inode buffer */
-	ushort			i_boffset;	/* off of inode in buffer */
+	struct xfs_imap		i_imap;		/* location for xfs_imap() */
 
 	/* Extent information. */
 	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
Index: xfs-2.6/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode_item.c	2008-10-21 11:49:01.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode_item.c	2008-10-21 11:52:20.000000000 +0200
@@ -943,9 +943,9 @@ xfs_inode_item_init(
 
 	iip->ili_format.ilf_type = XFS_LI_INODE;
 	iip->ili_format.ilf_ino = ip->i_ino;
-	iip->ili_format.ilf_blkno = ip->i_blkno;
-	iip->ili_format.ilf_len = ip->i_len;
-	iip->ili_format.ilf_boffset = ip->i_boffset;
+	iip->ili_format.ilf_blkno = ip->i_imap.im_blkno;
+	iip->ili_format.ilf_len = ip->i_imap.im_len;
+	iip->ili_format.ilf_boffset = ip->i_imap.im_boffset;
 }
 
 /*
Index: xfs-2.6/fs/xfs/xfs_itable.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_itable.c	2008-10-21 11:49:00.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_itable.c	2008-10-21 11:52:20.000000000 +0200
@@ -69,7 +69,7 @@ xfs_bulkstat_one_iget(
 	}
 
 	ASSERT(ip != NULL);
-	ASSERT(ip->i_blkno != (xfs_daddr_t)0);
+	ASSERT(ip->i_imap.im_blkno != 0);
 
 	dic = &ip->i_d;
 
Index: xfs-2.6/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_log_recover.c	2008-10-21 11:49:04.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_log_recover.c	2008-10-21 11:52:20.000000000 +0200
@@ -36,7 +36,6 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
-#include "xfs_imap.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_log_priv.h"
Index: xfs-2.6/fs/xfs/xfs_imap.h
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_imap.h	2008-10-21 11:51:12.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,33 +0,0 @@
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
-#ifndef __XFS_IMAP_H__
-#define	__XFS_IMAP_H__
-
-/*
- * This is the structure passed to xfs_imap() to map
- * an inode number to its on disk location.
- */
-typedef struct xfs_imap {
-	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
-	uint		im_len;		/* length in BBs of inode chunk */
-	xfs_agblock_t	im_agblkno;	/* logical block of inode chunk in ag */
-	ushort		im_ioffset;	/* inode offset in block in "inodes" */
-	ushort		im_boffset;	/* inode offset in block in bytes */
-} xfs_imap_t;
-
-#endif	/* __XFS_IMAP_H__ */

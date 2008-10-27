Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:41:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDfS4e024608
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:29 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4465ADE72E
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id XMB4cIKTRHnAT57s for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:27 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSLW-0000q3-V6
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:41:26 +0000
Date: Mon, 27 Oct 2008 09:41:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/6] embededd struct xfs_imap into xfs_inode
Message-ID: <20081027134126.GE3183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-imap-cleanup
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Most uses of struct xfs_imap are to map and inode to a buffer.  To avoid
copying around the inode location information we should just embedd a
strcut xfs_imap into the xfs_inode.  To make sure it doesn't bloat an
inode the im_len is changed to a ushort, which is fine as that's what
the users exepect anyway.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-10-25 13:30:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-10-25 13:30:56.000000000 +0200
@@ -23,7 +23,6 @@
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
-#include "xfs_imap.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_sb.h"
@@ -134,7 +133,7 @@ STATIC int
 xfs_imap_to_bp(
 	xfs_mount_t	*mp,
 	xfs_trans_t	*tp,
-	xfs_imap_t	*imap,
+	struct xfs_imap	*imap,
 	xfs_buf_t	**bpp,
 	uint		buf_flags,
 	uint		imap_flags)
@@ -232,7 +231,7 @@ xfs_inotobp(
 	int		*offset,
 	uint		imap_flags)
 {
-	xfs_imap_t	imap;
+	struct xfs_imap	imap;
 	xfs_buf_t	*bp;
 	int		error;
 
@@ -277,17 +276,12 @@ xfs_itobp(
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
 
@@ -298,7 +292,7 @@ xfs_itobp(
 		return EAGAIN;
 	}
 
-	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
+	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 	*bpp = bp;
 	return 0;
 }
@@ -799,9 +793,7 @@ xfs_inode_alloc(
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
@@ -857,7 +849,6 @@ xfs_iread(
 	xfs_buf_t	*bp;
 	xfs_dinode_t	*dip;
 	xfs_inode_t	*ip;
-	xfs_imap_t	imap;
 	int		error;
 
 	ip = xfs_inode_alloc(mp, ino);
@@ -865,26 +856,22 @@ xfs_iread(
 		return ENOMEM;
 
 	/*
-	 * Get pointers to the on-disk inode and the buffer containing it.
+	 * Fill in the location information in the in-core inode.
 	 */
-	imap.im_blkno = bno;
-	error = xfs_imap(mp, tp, ip->i_ino, &imap, imap_flags);
+	ip->i_imap.im_blkno = bno;
+	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, imap_flags);
 	if (error)
 		goto out_destroy_inode;
+	ASSERT(bno == 0 || bno == ip->i_imap.im_blkno);
 
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
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
+	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
 	/*
 	 * If we got something that isn't an inode it means someone
@@ -1866,7 +1853,7 @@ xfs_iunlink(
 		ASSERT(be32_to_cpu(dip->di_next_unlinked) == NULLAGINO);
 		/* both on-disk, don't endian flip twice */
 		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
-		offset = ip->i_boffset +
+		offset = ip->i_imap.im_boffset +
 			offsetof(xfs_dinode_t, di_next_unlinked);
 		xfs_trans_inode_buf(tp, ibp);
 		xfs_trans_log_buf(tp, ibp, offset,
@@ -1955,7 +1942,7 @@ xfs_iunlink_remove(
 		ASSERT(next_agino != 0);
 		if (next_agino != NULLAGINO) {
 			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
-			offset = ip->i_boffset +
+			offset = ip->i_imap.im_boffset +
 				offsetof(xfs_dinode_t, di_next_unlinked);
 			xfs_trans_inode_buf(tp, ibp);
 			xfs_trans_log_buf(tp, ibp, offset,
@@ -2018,7 +2005,7 @@ xfs_iunlink_remove(
 		ASSERT(next_agino != agino);
 		if (next_agino != NULLAGINO) {
 			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
-			offset = ip->i_boffset +
+			offset = ip->i_imap.im_boffset +
 				offsetof(xfs_dinode_t, di_next_unlinked);
 			xfs_trans_inode_buf(tp, ibp);
 			xfs_trans_log_buf(tp, ibp, offset,
@@ -3198,7 +3185,7 @@ xfs_iflush_int(
 	}
 
 	/* set *dip = inode's place in the buffer */
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_boffset);
+	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
 	/*
 	 * Clear i_update_core before copying out the data.
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-10-25 13:30:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-10-25 13:30:56.000000000 +0200
@@ -83,6 +83,16 @@ typedef struct xfs_ifork {
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
@@ -239,9 +249,7 @@ typedef struct xfs_inode {
 
 	/* Inode location stuff */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
-	xfs_daddr_t		i_blkno;	/* blkno of inode buffer */
-	ushort			i_len;		/* len of inode buffer */
-	ushort			i_boffset;	/* off of inode in buffer */
+	struct xfs_imap		i_imap;		/* location for xfs_imap() */
 
 	/* Extent information. */
 	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
Index: linux-2.6-xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode_item.c	2008-10-25 13:29:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode_item.c	2008-10-25 13:30:56.000000000 +0200
@@ -942,9 +942,9 @@ xfs_inode_item_init(
 
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
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c	2008-10-25 13:29:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c	2008-10-25 13:30:56.000000000 +0200
@@ -69,7 +69,7 @@ xfs_bulkstat_one_iget(
 	}
 
 	ASSERT(ip != NULL);
-	ASSERT(ip->i_blkno != (xfs_daddr_t)0);
+	ASSERT(ip->i_imap.im_blkno != 0);
 
 	dic = &ip->i_d;
 
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-10-25 13:29:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-10-25 13:30:56.000000000 +0200
@@ -36,7 +36,6 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
-#include "xfs_imap.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_log_priv.h"
Index: linux-2.6-xfs/fs/xfs/xfs_imap.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_imap.h	2008-10-25 13:30:03.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,31 +0,0 @@
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
-	ushort		im_boffset;	/* inode offset in block in bytes */
-} xfs_imap_t;
-
-#endif	/* __XFS_IMAP_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-10-25 13:30:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-10-25 13:30:56.000000000 +0200
@@ -40,7 +40,6 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_bmap.h"
-#include "xfs_imap.h"
 
 
 /*
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-10-25 13:31:11.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-10-25 13:31:17.000000000 +0200
@@ -20,7 +20,6 @@
 #include "xfs_bit.h"
 #include "xfs_buf.h"
 #include "xfs_log.h"
-#include "xfs_imap.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-10-25 13:32:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-10-25 13:32:53.000000000 +0200
@@ -6559,9 +6559,9 @@ xfsidbg_xnode(xfs_inode_t *ip)
 		ip->i_mount->m_ddev_targp->bt_dev,
 		xfs_fmtino(ip->i_ino, ip->i_mount));
 	kdb_printf("blkno 0x%llx len 0x%x boffset 0x%x\n",
-		(long long) ip->i_blkno,
-		ip->i_len,
-		ip->i_boffset);
+		(long long) ip->i_imap.im_blkno,
+		ip->i_imap.im_len,
+		ip->i_imap.im_boffset);
 	kdb_printf("transp 0x%p &itemp 0x%p\n",
 		ip->i_transp,
 		ip->i_itemp);

-- 

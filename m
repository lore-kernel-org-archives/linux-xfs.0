Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 09:28:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MGSn9P027270
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 09:28:49 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CE5510C9745
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 09:30:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id dAKx2DxJQOyUKmUZ for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 09:30:34 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KsgbS-0006dW-Hm
	for xfs@oss.sgi.com; Wed, 22 Oct 2008 16:30:34 +0000
Date: Wed, 22 Oct 2008 12:30:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] stop using xfs_itobp in xfs_bulkstat
Message-ID: <20081022163034.GB25556@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_bulkstat only wants the dinode, offset and buffer from a given
inode number.  Instead of using xfs_itobp on a fake inode which is
complicated and currently leads to leaks of the security data just use
xfs_inotobp which is designed to do exactly the kind of lookup
xfs_bulkstat wants.  The only thing that's missing in xfs_inotobp is
a flags paramter that let's us pass down XFS_IMAP_BULKSTAT, but that can
easily added.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-2.6/fs/xfs/xfs_inode.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode.c	2008-10-20 23:49:30.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.c	2008-10-21 09:28:16.000000000 +0200
@@ -222,25 +222,26 @@ xfs_imap_to_bp(
  * Use xfs_imap() to determine the size and location of the
  * buffer to read from disk.
  */
-STATIC int
+int
 xfs_inotobp(
 	xfs_mount_t	*mp,
 	xfs_trans_t	*tp,
 	xfs_ino_t	ino,
 	xfs_dinode_t	**dipp,
 	xfs_buf_t	**bpp,
-	int		*offset)
+	int		*offset,
+	uint		imap_flags)
 {
 	xfs_imap_t	imap;
 	xfs_buf_t	*bp;
 	int		error;
 
 	imap.im_blkno = 0;
-	error = xfs_imap(mp, tp, ino, &imap, XFS_IMAP_LOOKUP);
+	error = xfs_imap(mp, tp, ino, &imap, imap_flags | XFS_IMAP_LOOKUP);
 	if (error)
 		return error;
 
-	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, 0);
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, imap_flags);
 	if (error)
 		return error;
 
@@ -792,7 +793,7 @@ xfs_dic2xflags(
 /*
  * Allocate and initialise an xfs_inode.
  */
-struct xfs_inode *
+STATIC struct xfs_inode *
 xfs_inode_alloc(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
@@ -2046,7 +2047,7 @@ xfs_iunlink_remove(
 			}
 			next_ino = XFS_AGINO_TO_INO(mp, agno, next_agino);
 			error = xfs_inotobp(mp, tp, next_ino, &last_dip,
-					    &last_ibp, &last_offset);
+					    &last_ibp, &last_offset, 0);
 			if (error) {
 				cmn_err(CE_WARN,
 			"xfs_iunlink_remove: xfs_inotobp()  returned an error %d on %s.  Returning error.",
Index: xfs-2.6/fs/xfs/xfs_inode.h
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode.h	2008-10-20 23:49:30.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.h	2008-10-21 09:28:03.000000000 +0200
@@ -158,7 +158,7 @@ typedef struct xfs_icdinode {
 #define	XFS_IFEXTIREC	0x08	/* Indirection array of extent blocks */
 
 /*
- * Flags for xfs_itobp(), xfs_imap() and xfs_dilocate().
+ * Flags for xfs_inotobp, xfs_itobp(), xfs_imap() and xfs_dilocate().
  */
 #define XFS_IMAP_LOOKUP		0x1
 #define XFS_IMAP_BULKSTAT	0x2
@@ -514,7 +514,6 @@ int		xfs_itruncate_finish(struct xfs_tra
 				     xfs_fsize_t, int, int);
 int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
 
-struct xfs_inode * xfs_inode_alloc(struct xfs_mount *, xfs_ino_t);
 void		xfs_idestroy(xfs_inode_t *);
 void		xfs_iextract(xfs_inode_t *);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
@@ -531,6 +530,9 @@ void		xfs_mark_inode_dirty_sync(xfs_inod
 
 #endif /* __KERNEL__ */
 
+int		xfs_inotobp(struct xfs_mount *, struct xfs_trans *,
+			    xfs_ino_t, struct xfs_dinode **,
+			    struct xfs_buf **, int *, uint);
 int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, struct xfs_dinode **,
 			  struct xfs_buf **, xfs_daddr_t, uint, uint);
Index: xfs-2.6/fs/xfs/xfs_itable.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_itable.c	2008-10-20 23:49:30.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_itable.c	2008-10-20 23:49:34.000000000 +0200
@@ -359,7 +359,6 @@ xfs_bulkstat(
 	int			ubused;	/* bytes used by formatter */
 	xfs_buf_t		*bp;	/* ptr to on-disk inode cluster buf */
 	xfs_dinode_t		*dip;	/* ptr into bp for specific inode */
-	xfs_inode_t		*ip;	/* ptr to in-core inode struct */
 
 	/*
 	 * Get the last inode value, see if there's nothing to do.
@@ -585,6 +584,8 @@ xfs_bulkstat(
 
 					if (flags & (BULKSTAT_FG_QUICK |
 						     BULKSTAT_FG_INLINE)) {
+						int offset;
+
 						ino = XFS_AGINO_TO_INO(mp, agno,
 								       agino);
 						bno = XFS_AGB_TO_DADDR(mp, agno,
@@ -595,19 +596,13 @@ xfs_bulkstat(
 						 */
 						if (bp)
 							xfs_buf_relse(bp);
-						ip = xfs_inode_alloc(mp, ino);
-						if (!ip) {
-							bp = NULL;
-							rval = ENOMEM;
-							break;
-						}
-						error = xfs_itobp(mp, NULL, ip,
-								&dip, &bp, bno,
-								XFS_IMAP_BULKSTAT,
-								XFS_BUF_LOCK);
+
+						error = xfs_inotobp(mp, NULL, ino, &dip,
+								    &bp, &offset,
+								    XFS_IMAP_BULKSTAT);
+
 						if (!error)
-							clustidx = ip->i_boffset / mp->m_sb.sb_inodesize;
-						xfs_idestroy(ip);
+							clustidx = offset / mp->m_sb.sb_inodesize;
 						if (XFS_TEST_ERROR(error != 0,
 								   mp, XFS_ERRTAG_BULKSTAT_READ_CHUNK,
 								   XFS_RANDOM_BULKSTAT_READ_CHUNK)) {

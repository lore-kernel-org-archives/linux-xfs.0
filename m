Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 15:18:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9KMIsiQ010118
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:18:55 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE0F610BA2C7
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:20:38 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id M56wPIOBZVWiscaC for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:20:38 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m9KMKaIF023687
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 00:20:36 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m9KMKa7B023685
	for xfs@oss.sgi.com; Tue, 21 Oct 2008 00:20:36 +0200
Date: Tue, 21 Oct 2008 00:20:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] stop using xfs_itobp in xfs_bulkstat
Message-ID: <20081020222036.GA23662@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_bulkstat only wants the dinode, offset and buffer from a given
inode number.  Instead of using xfs_itobp on a fake inode that is much
easier done with xfs_inotobp, which just needs an imap_flag paramter to
pass down the XFS_IMAP_BULKSTAT flag.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-2.6/fs/xfs/xfs_inode.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_inode.c	2008-10-20 17:56:26.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.c	2008-10-20 17:56:37.000000000 +0200
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
 
@@ -2046,7 +2046,7 @@ xfs_iunlink_remove(
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
--- xfs-2.6.orig/fs/xfs/xfs_inode.h	2008-10-20 17:56:26.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_inode.h	2008-10-20 17:56:37.000000000 +0200
@@ -158,7 +158,7 @@ typedef struct xfs_icdinode {
 #define	XFS_IFEXTIREC	0x08	/* Indirection array of extent blocks */
 
 /*
- * Flags for xfs_itobp(), xfs_imap() and xfs_dilocate().
+ * Flags for xfs_inotobp, xfs_itobp(), xfs_imap() and xfs_dilocate().
  */
 #define XFS_IMAP_LOOKUP		0x1
 #define XFS_IMAP_BULKSTAT	0x2
@@ -531,6 +531,9 @@ void		xfs_mark_inode_dirty_sync(xfs_inod
 
 #endif /* __KERNEL__ */
 
+int		xfs_inotobp(struct xfs_mount *, struct xfs_trans *,
+			    xfs_ino_t, struct xfs_dinode **,
+			    struct xfs_buf **, int *, uint);
 int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, struct xfs_dinode **,
 			  struct xfs_buf **, xfs_daddr_t, uint, uint);
Index: xfs-2.6/fs/xfs/xfs_itable.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_itable.c	2008-10-20 17:56:26.000000000 +0200
+++ xfs-2.6/fs/xfs/xfs_itable.c	2008-10-20 17:56:57.000000000 +0200
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

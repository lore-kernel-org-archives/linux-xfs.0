Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:41:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDfTaK024622
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:31 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56BD31487F5B
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id yxKrmIiX8fT0mbLb for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:29 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSLZ-0000q9-0e
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:41:29 +0000
Date: Mon, 27 Oct 2008 09:41:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/6] kill the XFS_IMAP_BULKSTAT flag
Message-ID: <20081027134129.GF3183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-kill-XFS_IMAP_BULKSTAT
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Just pass down the XFS_IGET_* flags all the way down to xfs_imap instead
of translating them mid-way.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-10-25 13:30:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-10-25 13:33:21.000000000 +0200
@@ -1228,7 +1228,7 @@ xfs_imap(
 	    ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
 #ifdef DEBUG
 		/* no diagnostics for bulkstat, ino comes from userspace */
-		if (flags & XFS_IMAP_BULKSTAT)
+		if (flags & XFS_IGET_BULKSTAT)
 			return XFS_ERROR(EINVAL);
 		if (agno >= mp->m_sb.sb_agcount) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2008-10-25 13:15:42.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2008-10-25 13:40:06.000000000 +0200
@@ -147,8 +147,7 @@ xfs_iget_cache_miss(
 	 * Read the disk inode attributes into a new inode structure and get
 	 * a new vnode for it. This should also initialize i_ino and i_mount.
 	 */
-	error = xfs_iread(mp, tp, ino, &ip, bno,
-			  (flags & XFS_IGET_BULKSTAT) ? XFS_IMAP_BULKSTAT : 0);
+	error = xfs_iread(mp, tp, ino, &ip, bno, flags);
 	if (error)
 		return error;
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-10-25 13:30:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-10-25 13:40:06.000000000 +0200
@@ -136,7 +136,7 @@ xfs_imap_to_bp(
 	struct xfs_imap	*imap,
 	xfs_buf_t	**bpp,
 	uint		buf_flags,
-	uint		imap_flags)
+	uint		iget_flags)
 {
 	int		error;
 	int		i;
@@ -178,7 +178,7 @@ xfs_imap_to_bp(
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP,
 						XFS_RANDOM_ITOBP_INOTOBP))) {
-			if (imap_flags & XFS_IMAP_BULKSTAT) {
+			if (iget_flags & XFS_IGET_BULKSTAT) {
 				xfs_trans_brelse(tp, bp);
 				return XFS_ERROR(EINVAL);
 			}
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-10-25 13:30:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-10-25 13:40:06.000000000 +0200
@@ -167,11 +167,6 @@ typedef struct xfs_icdinode {
 #define	XFS_IFEXTIREC	0x08	/* Indirection array of extent blocks */
 
 /*
- * Flags for xfs_inotobp and xfs_imap().
- */
-#define XFS_IMAP_BULKSTAT	0x1
-
-/*
  * Fork handling.
  */
 
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c	2008-10-25 13:30:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c	2008-10-25 13:33:21.000000000 +0200
@@ -595,7 +595,7 @@ xfs_bulkstat(
 
 						error = xfs_inotobp(mp, NULL, ino, &dip,
 								    &bp, &offset,
-								    XFS_IMAP_BULKSTAT);
+								    XFS_IGET_BULKSTAT);
 
 						if (!error)
 							clustidx = offset / mp->m_sb.sb_inodesize;

-- 

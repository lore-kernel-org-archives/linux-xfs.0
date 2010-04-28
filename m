Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SCUMFD233085 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:30:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0158C2F9893
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ESTD3cngmMVpBBKI for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O76PA-0000rZ-Ki
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 12:30:16 +0000
Message-Id: <20100428123016.553009023@bombadil.infradead.org>
Date: Wed, 28 Apr 2010 08:29:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/11] xfs: mark xfs_iomap_write_ helpers static
References: <20100428122850.075189557@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-cleanup-12
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

And also drop a useless argument to xfs_iomap_write_direct.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-04-27 18:24:42.775004380 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-04-27 18:32:10.114024284 +0200
@@ -55,6 +55,13 @@
 #define XFS_STRAT_WRITE_IMAPS	2
 #define XFS_WRITE_IMAPS		XFS_BMAP_MAX_NMAP
 
+STATIC int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
+				  int, struct xfs_bmbt_irec *, int *);
+STATIC int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t, int,
+				 struct xfs_bmbt_irec *, int *);
+STATIC int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t, size_t,
+				struct xfs_bmbt_irec *, int *);
+
 int
 xfs_iomap(
 	struct xfs_inode	*ip,
@@ -133,7 +140,7 @@ xfs_iomap(
 
 		if (flags & (BMAPI_DIRECT|BMAPI_MMAP)) {
 			error = xfs_iomap_write_direct(ip, offset, count, flags,
-						       imap, nimaps, *nimaps);
+						       imap, nimaps);
 		} else {
 			error = xfs_iomap_write_delay(ip, offset, count, flags,
 						      imap, nimaps);
@@ -234,15 +241,14 @@ xfs_cmn_err_fsblock_zero(
 	return EFSCORRUPTED;
 }
 
-int
+STATIC int
 xfs_iomap_write_direct(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	size_t		count,
 	int		flags,
 	xfs_bmbt_irec_t *ret_imap,
-	int		*nmaps,
-	int		found)
+	int		*nmaps)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb;
@@ -279,7 +285,7 @@ xfs_iomap_write_direct(
 		if (error)
 			goto error_out;
 	} else {
-		if (found && (ret_imap->br_startblock == HOLESTARTBLOCK))
+		if (*nmaps && (ret_imap->br_startblock == HOLESTARTBLOCK))
 			last_fsb = MIN(last_fsb, (xfs_fileoff_t)
 					ret_imap->br_blockcount +
 					ret_imap->br_startoff);
@@ -434,7 +440,7 @@ xfs_iomap_eof_want_preallocate(
 	return 0;
 }
 
-int
+STATIC int
 xfs_iomap_write_delay(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
@@ -537,7 +543,7 @@ retry:
  * We no longer bother to look at the incoming map - all we have to
  * guarantee is that whatever we allocate fills the required range.
  */
-int
+STATIC int
 xfs_iomap_write_allocate(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
Index: xfs/fs/xfs/xfs_iomap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.h	2010-04-27 18:24:42.787004729 +0200
+++ xfs/fs/xfs/xfs_iomap.h	2010-04-27 18:32:10.115023027 +0200
@@ -44,12 +44,6 @@ struct xfs_bmbt_irec;
 
 extern int xfs_iomap(struct xfs_inode *, xfs_off_t, ssize_t, int,
 		     struct xfs_bmbt_irec *, int *, int *);
-extern int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
-				  int, struct xfs_bmbt_irec *, int *, int);
-extern int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t, int,
-				 struct xfs_bmbt_irec *, int *);
-extern int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t, size_t,
-				struct xfs_bmbt_irec *, int *);
 extern int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, size_t);
 
 #endif /* __XFS_IOMAP_H__*/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

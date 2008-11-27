Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mARJv1Xd028557 for <xfs@oss.sgi.com>; Thu, 27 Nov 2008 13:57:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E4CE16131E3
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2008 11:57:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sOKwqF91yFILVkW9 for
	<xfs@oss.sgi.com>; Thu, 27 Nov 2008 11:57:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L5myy-0007Z7-Bc
	for xfs@oss.sgi.com; Thu, 27 Nov 2008 19:57:00 +0000
Date: Thu, 27 Nov 2008 14:57:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] kill vn_ioerror
Message-ID: <20081127195700.GA15027@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There's just one caller of this helper, and it's much cleaner to just merge
the xfs_do_force_shutdown call into it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2008-11-16 20:51:30.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2008-11-16 20:54:00.000000000 +0100
@@ -146,16 +146,25 @@ xfs_destroy_ioend(
 	xfs_ioend_t		*ioend)
 {
 	struct buffer_head	*bh, *next;
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 
 	for (bh = ioend->io_buffer_head; bh; bh = next) {
 		next = bh->b_private;
 		bh->b_end_io(bh, !ioend->io_error);
 	}
-	if (unlikely(ioend->io_error)) {
-		vn_ioerror(XFS_I(ioend->io_inode), ioend->io_error,
-				__FILE__,__LINE__);
+
+	/*
+	 * Volume managers supporting multiple paths can send back ENODEV
+	 * when the final path disappears.  In this case continuing to fill
+	 * the page cache with dirty data which cannot be written out is
+	 * evil, so prevent that.
+	 */
+	if (unlikely(ioend->io_error == -ENODEV)) {
+		xfs_do_force_shutdown(ip->i_mount, SHUTDOWN_DEVICE_REQ,
+				      __FILE__, __LINE__);
 	}
-	vn_iowake(XFS_I(ioend->io_inode));
+
+	vn_iowake(ip);
 	mempool_free(ioend, xfs_ioend_pool);
 }
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2008-11-16 20:51:30.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2008-11-16 20:54:29.000000000 +0100
@@ -66,22 +66,6 @@ vn_iowake(
 		wake_up(vptosync(ip));
 }
 
-/*
- * Volume managers supporting multiple paths can send back ENODEV when the
- * final path disappears.  In this case continuing to fill the page cache
- * with dirty data which cannot be written out is evil, so prevent that.
- */
-void
-vn_ioerror(
-	xfs_inode_t	*ip,
-	int		error,
-	char		*f,
-	int		l)
-{
-	if (unlikely(error == -ENODEV))
-		xfs_do_force_shutdown(ip->i_mount, SHUTDOWN_DEVICE_REQ, f, l);
-}
-
 #ifdef	XFS_INODE_TRACE
 
 #define KTRACE_ENTER(ip, vk, s, line, ra)			\
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-11-16 20:54:09.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-11-16 20:54:21.000000000 +0100
@@ -63,7 +63,6 @@ extern void	vn_init(void);
  */
 extern void	vn_iowait(struct xfs_inode *ip);
 extern void	vn_iowake(struct xfs_inode *ip);
-extern void	vn_ioerror(struct xfs_inode *ip, int error, char *f, int l);
 
 static inline int vn_count(struct inode *vp)
 {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

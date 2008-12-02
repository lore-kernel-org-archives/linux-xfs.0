Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2G6rq2031664 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:06:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8631164F1C6
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:06:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oVSIyiBCEb6ju7Sh for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:06:52 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xm0-0007cE-Ep
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:52 +0000
Message-Id: <20081202160652.335328000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 19/22] kill vn_ioerror
Content-Disposition: inline; filename=xfs-kill-vn_ioerror
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

There's just one caller of this helper, and it's much cleaner to just merge
the xfs_do_force_shutdown call into it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_aops.c	2008-12-02 11:24:34.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_aops.c	2008-12-02 11:26:38.000000000 +0100
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
 
Index: xfs-master/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_vnode.c	2008-12-02 11:24:34.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_vnode.c	2008-12-02 11:26:38.000000000 +0100
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
Index: xfs-master/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-12-02 11:24:59.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_vnode.h	2008-12-02 11:26:38.000000000 +0100
@@ -63,7 +63,6 @@ extern void	vn_init(void);
  */
 extern void	vn_iowait(struct xfs_inode *ip);
 extern void	vn_iowake(struct xfs_inode *ip);
-extern void	vn_ioerror(struct xfs_inode *ip, int error, char *f, int l);
 
 #define IHOLD(ip) \
 do { \

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

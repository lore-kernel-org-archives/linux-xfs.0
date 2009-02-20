Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1K8r2tu164774 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 02:53:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55C041383A3
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:52:30 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ElFzxBmHD4ef47N9 for
	<xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:52:30 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LaR7W-00042T-20
	for xfs@oss.sgi.com; Fri, 20 Feb 2009 08:52:30 +0000
Message-Id: <20090220085229.964618000@bombadil.infradead.org>
Date: Fri, 20 Feb 2009 03:52:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/7] xfs: kill VN_BAD
References: <20090220085207.663702000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-VN_BAD
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

Remove this rather pointless wrapper and use is_bad_inode directly.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2009-02-03 17:41:55.249436184 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_vnode.h	2009-02-03 17:42:24.938561825 +0100
@@ -50,14 +50,6 @@ struct attrlist_cursor_kern;
 					   the operation completes. */
 
 /*
- * Dealing with bad inodes
- */
-static inline int VN_BAD(struct inode *vp)
-{
-	return is_bad_inode(vp);
-}
-
-/*
  * Some useful predicates.
  */
 #define VN_MAPPED(vp)	mapping_mapped(vp->i_mapping)
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-02-03 17:41:55.261436104 +0100
+++ xfs/fs/xfs/xfs_vnodeops.c	2009-02-03 17:42:10.690562980 +0100
@@ -1136,7 +1136,7 @@ xfs_inactive(
 	 * If the inode is already free, then there can be nothing
 	 * to clean up here.
 	 */
-	if (ip->i_d.di_mode == 0 || VN_BAD(VFS_I(ip))) {
+	if (ip->i_d.di_mode == 0 || is_bad_inode(VFS_I(ip))) {
 		ASSERT(ip->i_df.if_real_bytes == 0);
 		ASSERT(ip->i_df.if_broot_bytes == 0);
 		return VN_INACTIVE_CACHE;
@@ -2448,7 +2448,7 @@ xfs_reclaim(
 	ASSERT(!VN_MAPPED(VFS_I(ip)));
 
 	/* bad inode, get out here ASAP */
-	if (VN_BAD(VFS_I(ip))) {
+	if (is_bad_inode(VFS_I(ip))) {
 		xfs_ireclaim(ip);
 		return 0;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

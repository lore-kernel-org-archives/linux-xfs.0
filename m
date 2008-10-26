Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 13:35:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9QKYtpH027210
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:34:55 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD71712ABC8D
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:34:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id ry2Ep5hNpOJsOE2k for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:34:55 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuCK6-0001tn-WC
	for xfs@oss.sgi.com; Sun, 26 Oct 2008 20:34:55 +0000
Date: Sun, 26 Oct 2008 16:34:54 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] remove bhv_statvfs_t typedef
Message-ID: <20081026203454.GE4173@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-kill-bhv_statvfs_t
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.h	2008-10-16 00:18:08.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h	2008-10-16 00:18:49.000000000 +0200
@@ -31,8 +31,6 @@ struct xfs_inode;
 struct xfs_mount;
 struct xfs_mount_args;
 
-typedef struct kstatfs	bhv_statvfs_t;
-
 #define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
 #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
 #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm_bhv.c	2008-10-16 00:18:08.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm_bhv.c	2008-10-16 00:18:49.000000000 +0200
@@ -50,7 +50,7 @@
 
 STATIC void
 xfs_fill_statvfs_from_dquot(
-	bhv_statvfs_t		*statp,
+	struct kstatfs		*statp,
 	xfs_disk_dquot_t	*dp)
 {
 	__uint64_t		limit;
@@ -87,7 +87,7 @@ xfs_fill_statvfs_from_dquot(
 STATIC void
 xfs_qm_statvfs(
 	xfs_inode_t		*ip,
-	bhv_statvfs_t		*statp)
+	struct kstatfs		*statp)
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_dquot_t		*dqp;
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-10-16 00:18:08.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-10-22 09:29:09.000000000 +0200
@@ -133,7 +133,7 @@ typedef struct xfs_dquot * (*xfs_dqvopch
 			struct xfs_dquot **, struct xfs_dquot *);
 typedef int	(*xfs_dqvopchownresv_t)(struct xfs_trans *, struct xfs_inode *,
 			struct xfs_dquot *, struct xfs_dquot *, uint);
-typedef void	(*xfs_dqstatvfs_t)(struct xfs_inode *, bhv_statvfs_t *);
+typedef void	(*xfs_dqstatvfs_t)(struct xfs_inode *, struct kstatfs *);
 typedef int	(*xfs_dqsync_t)(struct xfs_mount *, int flags);
 typedef int	(*xfs_quotactl_t)(struct xfs_mount *, int, int, xfs_caddr_t);
 

-- 

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB99mWE8012889 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 03:48:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A462742
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2008 01:48:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MlKKiDIFxubKDC8R for
	<xfs@oss.sgi.com>; Tue, 09 Dec 2008 01:48:32 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L9zCD-0005WS-Ey
	for xfs@oss.sgi.com; Tue, 09 Dec 2008 09:48:01 +0000
Message-Id: <20081209094801.381484000@bombadil.infradead.org>
References: <20081209094729.939583000@bombadil.infradead.org>
Date: Tue, 09 Dec 2008 04:47:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 3/5] resync headers with libxfs
Content-Disposition: inline; filename=xfs-resync-with-xfs-cmds
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

 - xfs_sb.h add the XFS_SB_VERSION2_PARENTBIT features2 that has been
   around in userspace for some time
 - xfs_inode.h: move a few things out of __KERNEL__ that are needed by
   userspace
 - xfs_mount.h: only include xfs_sync.h under __KERNEL__
 - xfs_inode.c: minor whitespace fixup.  I accidentaly changes this when
   importing this file for use by userspace.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_sb.h
===================================================================
--- xfs.orig/fs/xfs/xfs_sb.h	2008-12-04 08:03:24.000000000 +0100
+++ xfs/fs/xfs/xfs_sb.h	2008-12-06 13:22:03.000000000 +0100
@@ -79,6 +79,7 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters */
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
+#define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2008-12-05 17:19:55.000000000 +0100
+++ xfs/fs/xfs/xfs_inode.h	2008-12-06 13:22:35.000000000 +0100
@@ -483,12 +483,6 @@ static inline void xfs_ifunlock(xfs_inod
 	 ((pip)->i_d.di_mode & S_ISGID))
 
 /*
- * Flags for xfs_iget()
- */
-#define XFS_IGET_CREATE		0x1
-#define XFS_IGET_BULKSTAT	0x2
-
-/*
  * xfs_iget.c prototypes.
  */
 xfs_inode_t	*xfs_inode_incore(struct xfs_mount *, xfs_ino_t,
@@ -509,8 +503,6 @@ void		xfs_ireclaim(xfs_inode_t *);
 /*
  * xfs_inode.c prototypes.
  */
-int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
-			  struct xfs_inode *, xfs_daddr_t, uint);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, mode_t,
 			   xfs_nlink_t, xfs_dev_t, struct cred *, xfs_prid_t,
 			   int, struct xfs_buf **, boolean_t *, xfs_inode_t **);
@@ -583,12 +575,20 @@ do { \
 
 #endif /* __KERNEL__ */
 
+/*
+ * Flags for xfs_iget()
+ */
+#define XFS_IGET_CREATE		0x1
+#define XFS_IGET_BULKSTAT	0x2
+
 int		xfs_inotobp(struct xfs_mount *, struct xfs_trans *,
 			    xfs_ino_t, struct xfs_dinode **,
 			    struct xfs_buf **, int *, uint);
 int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, struct xfs_dinode **,
 			  struct xfs_buf **, uint);
+int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
+			  struct xfs_inode *, xfs_daddr_t, uint);
 void		xfs_dinode_from_disk(struct xfs_icdinode *,
 				     struct xfs_dinode *);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2008-12-04 14:50:44.000000000 +0100
+++ xfs/fs/xfs/xfs_inode.c	2008-12-06 13:24:23.000000000 +0100
@@ -870,7 +870,7 @@ xfs_iread(
 	 * around for a while.  This helps to keep recently accessed
 	 * meta-data in-core longer.
 	 */
-	 XFS_BUF_SET_REF(bp, XFS_INO_REF);
+	XFS_BUF_SET_REF(bp, XFS_INO_REF);
 
 	/*
 	 * Use xfs_trans_brelse() to release the buffer containing the
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2008-12-05 17:19:56.000000000 +0100
+++ xfs/fs/xfs/xfs_mount.h	2008-12-06 13:31:27.000000000 +0100
@@ -18,8 +18,6 @@
 #ifndef __XFS_MOUNT_H__
 #define	__XFS_MOUNT_H__
 
-#include "xfs_sync.h"
-
 typedef struct xfs_trans_reservations {
 	uint	tr_write;	/* extent alloc trans */
 	uint	tr_itruncate;	/* truncate trans */
@@ -53,6 +51,8 @@ typedef struct xfs_trans_reservations {
 
 #else /* __KERNEL__ */
 
+#include "xfs_sync.h"
+
 struct cred;
 struct log;
 struct xfs_mount_args;

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

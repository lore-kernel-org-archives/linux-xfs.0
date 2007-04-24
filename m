Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 03:13:00 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3OACvfB026156
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 03:12:58 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l3OACqLD029679
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 12:12:52 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l3OACqor029677
	for xfs@oss.sgi.com; Tue, 24 Apr 2007 12:12:52 +0200
Date: Tue, 24 Apr 2007 12:12:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [RFC PATCH 3/3] replace xfs_iflush_all with xfs_reclaim_all
Message-ID: <20070424101252.GA28314@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_iflush_all is another variant of the loop all deleted inodes
without vnode and flush them scheme.  Use xfs_finish_reclaim_all
without the nonblock flag and with XFS_IFLUSH_ASYNC as sync_flag
instead.

Btw, shouldn't xfs_quiesce_fs also pass XFS_IFLUSH_ASYNC to
xfs_finish_reclaim_all?


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.c	2007-04-24 10:58:55.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_inode.c	2007-04-24 11:00:42.000000000 +0200
@@ -3518,45 +3518,6 @@ corrupt_out:
 	return XFS_ERROR(EFSCORRUPTED);
 }
 
-
-/*
- * Flush all inactive inodes in mp.
- */
-void
-xfs_iflush_all(
-	xfs_mount_t	*mp)
-{
-	xfs_inode_t	*ip;
-	bhv_vnode_t	*vp;
-
- again:
-	XFS_MOUNT_ILOCK(mp);
-	ip = mp->m_inodes;
-	if (ip == NULL)
-		goto out;
-
-	do {
-		/* Make sure we skip markers inserted by sync */
-		if (ip->i_mount == NULL) {
-			ip = ip->i_mnext;
-			continue;
-		}
-
-		vp = XFS_ITOV_NULL(ip);
-		if (!vp) {
-			XFS_MOUNT_IUNLOCK(mp);
-			xfs_finish_reclaim(ip, 0, XFS_IFLUSH_ASYNC);
-			goto again;
-		}
-
-		ASSERT(vn_count(vp) == 0);
-
-		ip = ip->i_mnext;
-	} while (ip != mp->m_inodes);
- out:
-	XFS_MOUNT_IUNLOCK(mp);
-}
-
 /*
  * xfs_iaccess: check accessibility of inode for mode.
  */
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2007-04-24 10:58:55.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_inode.h	2007-04-24 11:00:22.000000000 +0200
@@ -499,7 +499,6 @@ void		xfs_ipin(xfs_inode_t *);
 void		xfs_iunpin(xfs_inode_t *);
 int		xfs_iextents_copy(xfs_inode_t *, xfs_bmbt_rec_t *, int);
 int		xfs_iflush(xfs_inode_t *, uint);
-void		xfs_iflush_all(struct xfs_mount *);
 int		xfs_iaccess(xfs_inode_t *, mode_t, cred_t *);
 uint		xfs_iroundup(uint);
 void		xfs_ichgtime(xfs_inode_t *, int);
Index: linux-2.6/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.c	2007-04-24 10:58:53.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_mount.c	2007-04-24 11:00:22.000000000 +0200
@@ -1084,7 +1084,7 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
 	int64_t		fsid;
 #endif
 
-	xfs_iflush_all(mp);
+	xfs_finish_reclaim_all(mp, 0, XFS_IFLUSH_ASYNC);
 
 	XFS_QM_DQPURGEALL(mp, XFS_QMOPT_QUOTALL | XFS_QMOPT_UMOUNTING);
 

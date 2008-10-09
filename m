Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 11:53:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m99IrPs6010083
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 11:53:25 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84E54A2E927
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2008 11:55:04 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Y7ISdNGpPaPGLOKR for <xfs@oss.sgi.com>; Thu, 09 Oct 2008 11:55:04 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m99It3IF007869
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 20:55:03 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m99It24e007867
	for xfs@oss.sgi.com; Thu, 9 Oct 2008 20:55:02 +0200
Date: Thu, 9 Oct 2008 20:55:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] kill XFS_DINODE_VERSION_ defines
Message-ID: <20081009185502.GC7583@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

These names don't add any value at all over just using the numerical
version.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-10-09 17:59:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-10-09 17:59:26.000000000 +0200
@@ -331,7 +331,7 @@ xfs_dip_to_stat(
 	 * the new format. We don't change the version number so that we
 	 * can distinguish this from a real new format inode.
 	 */
-	if (dic->di_version == XFS_DINODE_VERSION_1) {
+	if (dic->di_version == 1) {
 		buf->dt_nlink = be16_to_cpu(dic->di_onlink);
 		/*buf->dt_xfs_projid = 0;*/
 	} else {
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-10-09 18:00:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-10-09 18:00:33.000000000 +0200
@@ -1132,7 +1132,7 @@ xfs_ioctl_setattr(
 			 * the superblock version number since projids didn't
 			 * exist before DINODE_VERSION_2 and SB_VERSION_NLINK.
 			 */
-			if (ip->i_d.di_version == XFS_DINODE_VERSION_1)
+			if (ip->i_d.di_version == 1)
 				xfs_bump_ino_vers2(tp, ip);
 		}
 
Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h	2008-10-09 18:01:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dinode.h	2008-10-09 18:01:54.000000000 +0200
@@ -18,11 +18,8 @@
 #ifndef __XFS_DINODE_H__
 #define	__XFS_DINODE_H__
 
-#define	XFS_DINODE_VERSION_1	1
-#define	XFS_DINODE_VERSION_2	2
-#define XFS_DINODE_GOOD_VERSION(v)	\
-	(((v) == XFS_DINODE_VERSION_1 || (v) == XFS_DINODE_VERSION_2))
-#define	XFS_DINODE_MAGIC	0x494e	/* 'IN' */
+#define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
+#define XFS_DINODE_GOOD_VERSION(v)	(((v) == 1 || (v) == 2))
 
 typedef struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-10-09 18:00:39.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-10-09 18:00:49.000000000 +0200
@@ -321,9 +321,9 @@ xfs_ialloc_ag_alloc(
 	 * able to use the file system.
 	 */
 	if (xfs_sb_version_hasnlink(&args.mp->m_sb))
-		version = XFS_DINODE_VERSION_2;
+		version = 2;
 	else
-		version = XFS_DINODE_VERSION_1;
+		version = 1;
 
 	/*
 	 * Seed the new inode cluster with a random generation number. This
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-10-09 17:59:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-10-09 18:00:25.000000000 +0200
@@ -959,7 +959,7 @@ xfs_iread(
 	 * the new format. We don't change the version number so that we
 	 * can distinguish this from a real new format inode.
 	 */
-	if (ip->i_d.di_version == XFS_DINODE_VERSION_1) {
+	if (ip->i_d.di_version == 1) {
 		ip->i_d.di_nlink = ip->i_d.di_onlink;
 		ip->i_d.di_onlink = 0;
 		ip->i_d.di_projid = 0;
@@ -1128,8 +1128,8 @@ xfs_ialloc(
 	 * here rather than here and in the flush/logging code.
 	 */
 	if (xfs_sb_version_hasnlink(&tp->t_mountp->m_sb) &&
-	    ip->i_d.di_version == XFS_DINODE_VERSION_1) {
-		ip->i_d.di_version = XFS_DINODE_VERSION_2;
+	    ip->i_d.di_version == 1) {
+		ip->i_d.di_version = 2;
 		/*
 		 * We've already zeroed the old link count, the projid field,
 		 * and the pad field.
@@ -1139,7 +1139,7 @@ xfs_ialloc(
 	/*
 	 * Project ids won't be stored on disk if we are using a version 1 inode.
 	 */
-	if ((prid != 0) && (ip->i_d.di_version == XFS_DINODE_VERSION_1))
+	if ((prid != 0) && (ip->i_d.di_version == 1))
 		xfs_bump_ino_vers2(tp, ip);
 
 	if (pip && XFS_INHERIT_GID(pip)) {
@@ -3348,9 +3348,8 @@ xfs_iflush_int(
 	 * convert back to the old inode format.  If the superblock version
 	 * has been updated, then make the conversion permanent.
 	 */
-	ASSERT(ip->i_d.di_version == XFS_DINODE_VERSION_1 ||
-	       xfs_sb_version_hasnlink(&mp->m_sb));
-	if (ip->i_d.di_version == XFS_DINODE_VERSION_1) {
+	ASSERT(ip->i_d.di_version == 1 || xfs_sb_version_hasnlink(&mp->m_sb));
+	if (ip->i_d.di_version == 1) {
 		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
 			/*
 			 * Convert it back.
@@ -3363,8 +3362,8 @@ xfs_iflush_int(
 			 * so just make the conversion to the new inode
 			 * format permanent.
 			 */
-			ip->i_d.di_version = XFS_DINODE_VERSION_2;
-			dip->di_version =  XFS_DINODE_VERSION_2;
+			ip->i_d.di_version = 2;
+			dip->di_version = 2;
 			ip->i_d.di_onlink = 0;
 			dip->di_onlink = 0;
 			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
Index: linux-2.6-xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode_item.c	2008-10-09 18:00:54.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode_item.c	2008-10-09 18:01:19.000000000 +0200
@@ -296,9 +296,8 @@ xfs_inode_item_format(
 	 * has a new version number, then we don't bother converting back.
 	 */
 	mp = ip->i_mount;
-	ASSERT(ip->i_d.di_version == XFS_DINODE_VERSION_1 ||
-	       xfs_sb_version_hasnlink(&mp->m_sb));
-	if (ip->i_d.di_version == XFS_DINODE_VERSION_1) {
+	ASSERT(ip->i_d.di_version == 1 || xfs_sb_version_hasnlink(&mp->m_sb));
+	if (ip->i_d.di_version == 1) {
 		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
 			/*
 			 * Convert it back.
@@ -311,7 +310,7 @@ xfs_inode_item_format(
 			 * so just make the conversion to the new inode
 			 * format permanent.
 			 */
-			ip->i_d.di_version = XFS_DINODE_VERSION_2;
+			ip->i_d.di_version = 2;
 			ip->i_d.di_onlink = 0;
 			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 		}
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c	2008-10-09 17:59:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c	2008-10-09 17:59:33.000000000 +0200
@@ -139,7 +139,7 @@ xfs_bulkstat_one_dinode(
 	 * the new format. We don't change the version number so that we
 	 * can distinguish this from a real new format inode.
 	 */
-	if (dic->di_version == XFS_DINODE_VERSION_1) {
+	if (dic->di_version == 1) {
 		buf->bs_nlink = be16_to_cpu(dic->di_onlink);
 		buf->bs_projid = 0;
 	} else {
Index: linux-2.6-xfs/fs/xfs/xfs_utils.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.c	2008-10-09 17:59:36.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_utils.c	2008-10-09 17:59:46.000000000 +0200
@@ -268,9 +268,9 @@ xfs_bump_ino_vers2(
 	xfs_mount_t	*mp;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(ip->i_d.di_version == XFS_DINODE_VERSION_1);
+	ASSERT(ip->i_d.di_version == 1);
 
-	ip->i_d.di_version = XFS_DINODE_VERSION_2;
+	ip->i_d.di_version = 2;
 	ip->i_d.di_onlink = 0;
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 	mp = tp->t_mountp;
@@ -302,7 +302,7 @@ xfs_bumplink(
 	ASSERT(ip->i_d.di_nlink > 0);
 	ip->i_d.di_nlink++;
 	inc_nlink(VFS_I(ip));
-	if ((ip->i_d.di_version == XFS_DINODE_VERSION_1) &&
+	if ((ip->i_d.di_version == 1) &&
 	    (ip->i_d.di_nlink > XFS_MAXLINK_1)) {
 		/*
 		 * The inode has increased its number of links beyond

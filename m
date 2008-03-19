Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 13:50:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2JKoOGe031001
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:50:25 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C03D16C0452
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:50:56 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id MUNXVPvBrKi3pDZ3 for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:50:56 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m2JKlOF3024361
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 21:47:24 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m2JKlO9K024359
	for xfs@oss.sgi.com; Wed, 19 Mar 2008 21:47:24 +0100
Date: Wed, 19 Mar 2008 21:47:24 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cleanup root inode handling in xfs_fs_fill_super
Message-ID: <20080319204724.GA24271@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

 - rename rootvp to root for clarify
 - remove useless vn_to_inode call
 - check is_bad_inode before calling d_alloc_root
 - use iput instead of VN_RELE in the error case


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-02-27 00:40:51.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-02-27 00:43:04.000000000 +0100
@@ -1307,7 +1307,7 @@ xfs_fs_fill_super(
 	void			*data,
 	int			silent)
 {
-	struct inode		*rootvp;
+	struct inode		*root;
 	struct xfs_mount	*mp = NULL;
 	struct xfs_mount_args	*args = xfs_args_allocate(sb, silent);
 	int			error;
@@ -1345,19 +1345,18 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
-	rootvp = igrab(mp->m_rootip->i_vnode);
-	if (!rootvp) {
+	root = igrab(mp->m_rootip->i_vnode);
+	if (!root) {
 		error = ENOENT;
 		goto fail_unmount;
 	}
-
-	sb->s_root = d_alloc_root(vn_to_inode(rootvp));
-	if (!sb->s_root) {
-		error = ENOMEM;
+	if (is_bad_inode(root)) {
+		error = EINVAL;
 		goto fail_vnrele;
 	}
-	if (is_bad_inode(sb->s_root->d_inode)) {
-		error = EINVAL;
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		error = ENOMEM;
 		goto fail_vnrele;
 	}
 
@@ -1379,7 +1378,7 @@ fail_vnrele:
 		dput(sb->s_root);
 		sb->s_root = NULL;
 	} else {
-		VN_RELE(rootvp);
+		iput(root);
 	}
 
 fail_unmount:

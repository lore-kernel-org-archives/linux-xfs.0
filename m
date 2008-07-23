Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 12:49:21 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NJn0u7010836
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:06 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15C821B3E78E
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:43 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id c5QEJIHqvZ6HviYe for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:43 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NJnYNg006580
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 21:49:34 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NJnYxo006578
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 21:49:34 +0200
Date: Wed, 23 Jul 2008 21:49:34 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] kill vn_from_inode
Message-ID: <20080723194934.GB6188@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

bhv_vnode_t is just a typedef for struct inode, so there's no need for
a helper to convert between the two.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 19:29:16.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 19:29:22.000000000 +0200
@@ -994,7 +994,7 @@ STATIC void
 xfs_fs_destroy_inode(
 	struct inode		*inode)
 {
-	kmem_zone_free(xfs_vnode_zone, vn_from_inode(inode));
+	kmem_zone_free(xfs_vnode_zone, inode);
 }
 
 STATIC void
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-07-23 19:29:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-07-23 19:29:52.000000000 +0200
@@ -27,10 +27,6 @@ typedef struct inode	bhv_vnode_t;
 /*
  * Vnode to Linux inode mapping.
  */
-static inline bhv_vnode_t *vn_from_inode(struct inode *inode)
-{
-	return inode;
-}
 static inline struct inode *vn_to_inode(bhv_vnode_t *vnode)
 {
 	return vnode;
@@ -100,8 +96,7 @@ extern bhv_vnode_t	*vn_hold(bhv_vnode_t 
 
 static inline bhv_vnode_t *vn_grab(bhv_vnode_t *vp)
 {
-	struct inode *inode = igrab(vn_to_inode(vp));
-	return inode ? vn_from_inode(inode) : NULL;
+	return igrab(vn_to_inode(vp));
 }
 
 /*

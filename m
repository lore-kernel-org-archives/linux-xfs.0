Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jan 2008 04:49:54 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m03CnhoC016449
	for <xfs@oss.sgi.com>; Thu, 3 Jan 2008 04:49:48 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CE1D4DD23D
	for <xfs@oss.sgi.com>; Thu,  3 Jan 2008 04:49:55 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 7djmb188imasBatK for <xfs@oss.sgi.com>; Thu, 03 Jan 2008 04:49:55 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m03CnnF3005399
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 3 Jan 2008 13:49:49 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m03CnnIh005395
	for xfs@oss.sgi.com; Thu, 3 Jan 2008 13:49:49 +0100
Date: Thu, 3 Jan 2008 13:49:49 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] vnode cleanup in xfs_fs_subr.c
Message-ID: <20080103124949.GA5331@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Cleanup the unneeded intermediate vnode step in the flushing helpers
and go directly from the xfs_inode to the struct address_space.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_fs_subr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-09-23 14:09:19.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-09-23 14:11:55.000000000 +0200
@@ -17,18 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_vnodeops.h"
-
-/*
- * The following six includes are needed so that we can include
- * xfs_inode.h.  What a mess..
- */
 #include "xfs_bmap_btree.h"
-#include "xfs_inum.h"
-#include "xfs_dir2.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
-
 #include "xfs_inode.h"
 
 int  fs_noerr(void) { return 0; }
@@ -42,11 +31,10 @@ xfs_tosspages(
 	xfs_off_t	last,
 	int		fiopt)
 {
-	bhv_vnode_t	*vp = XFS_ITOV(ip);
-	struct inode	*inode = vn_to_inode(vp);
+	struct address_space *mapping = ip->i_vnode->i_mapping;
 
-	if (VN_CACHED(vp))
-		truncate_inode_pages(inode->i_mapping, first);
+	if (mapping->nrpages)
+		truncate_inode_pages(mapping, first);
 }
 
 int
@@ -56,15 +44,14 @@ xfs_flushinval_pages(
 	xfs_off_t	last,
 	int		fiopt)
 {
-	bhv_vnode_t	*vp = XFS_ITOV(ip);
-	struct inode	*inode = vn_to_inode(vp);
+	struct address_space *mapping = ip->i_vnode->i_mapping;
 	int		ret = 0;
 
-	if (VN_CACHED(vp)) {
+	if (mapping->nrpages) {
 		xfs_iflags_clear(ip, XFS_ITRUNCATED);
-		ret = filemap_write_and_wait(inode->i_mapping);
+		ret = filemap_write_and_wait(mapping);
 		if (!ret)
-			truncate_inode_pages(inode->i_mapping, first);
+			truncate_inode_pages(mapping, first);
 	}
 	return ret;
 }
@@ -77,17 +64,16 @@ xfs_flush_pages(
 	uint64_t	flags,
 	int		fiopt)
 {
-	bhv_vnode_t	*vp = XFS_ITOV(ip);
-	struct inode	*inode = vn_to_inode(vp);
+	struct address_space *mapping = ip->i_vnode->i_mapping;
 	int		ret = 0;
 	int		ret2;
 
-	if (VN_DIRTY(vp)) {
+	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 		xfs_iflags_clear(ip, XFS_ITRUNCATED);
-		ret = filemap_fdatawrite(inode->i_mapping);
+		ret = filemap_fdatawrite(mapping);
 		if (flags & XFS_B_ASYNC)
 			return ret;
-		ret2 = filemap_fdatawait(inode->i_mapping);
+		ret2 = filemap_fdatawait(mapping);
 		if (!ret)
 			ret = ret2;
 	}

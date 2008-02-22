Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:01:59 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M41pBS031687
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:01:54 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E32AE8EE1E
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:02:17 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id v4A6QtYCQ3f0cq57 for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:02:17 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m1M42CF3006180
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 05:02:12 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m1M42C7c006178
	for xfs@oss.sgi.com; Fri, 22 Feb 2008 05:02:12 +0100
Date: Fri, 22 Feb 2008 05:02:12 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/8] cleanup vnode use in xfs_lrw.c
Message-ID: <20080222040212.GF5964@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-01-03 14:57:26.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2008-01-03 14:59:07.000000000 +0100
@@ -176,7 +176,6 @@ xfs_read(
 {
 	struct file		*file = iocb->ki_filp;
 	struct inode		*inode = file->f_mapping->host;
-	bhv_vnode_t		*vp = XFS_ITOV(ip);
 	xfs_mount_t		*mp = ip->i_mount;
 	size_t			size = 0;
 	ssize_t			ret = 0;
@@ -242,7 +241,7 @@ xfs_read(
 	}
 
 	if (unlikely(ioflags & IO_ISDIRECT)) {
-		if (VN_CACHED(vp))
+		if (inode->i_mapping->nrpages)
 			ret = xfs_flushinval_pages(ip, (*offset & PAGE_CACHE_MASK),
 						    -1, FI_REMAPF_LOCKED);
 		mutex_unlock(&inode->i_mutex);
@@ -571,7 +570,6 @@ xfs_write(
 	struct file		*file = iocb->ki_filp;
 	struct address_space	*mapping = file->f_mapping;
 	struct inode		*inode = mapping->host;
-	bhv_vnode_t		*vp = XFS_ITOV(xip);
 	unsigned long		segs = nsegs;
 	xfs_mount_t		*mp;
 	ssize_t			ret = 0, error = 0;
@@ -658,7 +656,7 @@ start:
 			return XFS_ERROR(-EINVAL);
 		}
 
-		if (!need_i_mutex && (VN_CACHED(vp) || pos > xip->i_size)) {
+		if (!need_i_mutex && (mapping->nrpages || pos > xip->i_size)) {
 			xfs_iunlock(xip, XFS_ILOCK_EXCL|iolock);
 			iolock = XFS_IOLOCK_EXCL;
 			need_i_mutex = 1;
@@ -720,7 +718,7 @@ retry:
 	current->backing_dev_info = mapping->backing_dev_info;
 
 	if ((ioflags & IO_ISDIRECT)) {
-		if (VN_CACHED(vp)) {
+		if (mapping->nrpages) {
 			WARN_ON(need_i_mutex == 0);
 			xfs_inval_cached_trace(xip, pos, -1,
 					(pos & PAGE_CACHE_MASK), -1);

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3I00x6w096092 for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 19:01:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7ADFC102B350
	for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 17:02:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id c3pzb9OtMKGCUdFU for
	<xfs@oss.sgi.com>; Sat, 17 Apr 2010 17:02:53 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O3HyP-0005Js-3X
	for xfs@oss.sgi.com; Sun, 18 Apr 2010 00:02:53 +0000
Date: Sat, 17 Apr 2010 20:02:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: wait for direct I/O to complete in fsync and write_inode
Message-ID: <20100418000252.GA20432@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We need to wait for all pending direct I/O requests before taking care of
metadata in fsync and write_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-03-15 09:24:53.332004798 -0700
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-04-16 09:50:08.197004486 -0700
@@ -115,6 +115,8 @@ xfs_file_fsync(
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 
+	xfs_ioend_wait(ip);
+
 	/*
 	 * We always need to make sure that the required inode state is safe on
 	 * disk.  The inode might be clean but we still might need to force the
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-04-05 11:21:31.643011861 -0700
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-04-16 09:51:19.891255575 -0700
@@ -1092,6 +1092,7 @@ xfs_fs_write_inode(
 		 * the code will only flush the inode if it isn't already
 		 * being flushed.
 		 */
+		xfs_ioend_wait(ip);
 		xfs_ilock(ip, XFS_ILOCK_SHARED);
 		if (ip->i_update_core) {
 			error = xfs_log_inode(ip);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

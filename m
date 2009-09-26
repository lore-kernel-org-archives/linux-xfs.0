Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8QJriYq261900 for <xfs@oss.sgi.com>; Sat, 26 Sep 2009 14:53:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57EDD481B3D
	for <xfs@oss.sgi.com>; Sat, 26 Sep 2009 12:55:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lj08FP7eqqrOJreE for
	<xfs@oss.sgi.com>; Sat, 26 Sep 2009 12:55:05 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MrdMG-0004Xq-R4
	for xfs@oss.sgi.com; Sat, 26 Sep 2009 19:55:04 +0000
Date: Sat, 26 Sep 2009 15:55:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: stop calling filemap_fdatawait inside ->fsync
Message-ID: <20090926195504.GA11121@infradead.org>
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

Now that the VFS actually waits for the data I/O to complete before
calling into ->fsync we can stop doing it ourselves.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_file.c	2009-09-26 14:09:24.933003650 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c	2009-09-26 14:09:46.804256831 -0300
@@ -176,14 +176,7 @@ xfs_file_fsync(
 	struct dentry		*dentry,
 	int			datasync)
 {
-	struct inode		*inode = dentry->d_inode;
 	struct xfs_inode	*ip = XFS_I(inode);
-	int			error;
-
-	/* capture size updates in I/O completion before writing the inode. */
-	error = filemap_fdatawait(inode->i_mapping);
-	if (error)
-		return error;
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 	return -xfs_fsync(ip);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o26DImCI089709 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 07:18:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8ACD41D1B241
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 05:20:18 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id N1MHif6AYnczDWoq for
	<xfs@oss.sgi.com>; Sat, 06 Mar 2010 05:20:18 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NntvW-0008AN-3O
	for xfs@oss.sgi.com; Sat, 06 Mar 2010 13:20:18 +0000
Date: Sat, 6 Mar 2010 08:20:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: wait for direct I/O to complete in fsync and write_inode
Message-ID: <20100306132018.GA31360@infradead.org>
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

Note that the write_inode hunk will causes conflicts when merging with
mainline, I'm not sure how to best deal with that.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-03-06 14:10:12.247004588 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-03-06 14:16:48.460003752 +0100
@@ -115,6 +115,8 @@ xfs_file_fsync(
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 
+	xfs_ioend_wait(ip);
+
 	/*
 	 * We always need to make sure that the required inode state is safe on
 	 * disk.  The inode might be clean but we still might need to force the
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-03-06 14:10:12.259026379 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-03-06 14:16:48.461003193 +0100
@@ -1079,6 +1079,8 @@ xfs_fs_write_inode(
 		if (error)
 			goto out;
 
+		xfs_ioend_wait(ip);
+
 		/*
 		 * Make sure the inode has hit stable storage.  By using the
 		 * log and the fsync transactions we reduce the IOs we have

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

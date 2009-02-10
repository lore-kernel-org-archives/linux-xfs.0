Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AJkNdD071306 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 13:46:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 510391903E67
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 11:45:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id p5Z05sfjewvWHXNg for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 11:45:47 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWyXj-0000jc-Vo
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 19:45:16 +0000
Message-Id: <20090210194515.812431000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 14:44:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: reject swapext ioctl on swapfiles
References: <20090210194422.767988000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-swapext-reject-swapfiles
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

Swapfiles are magic - I/O is directly initialized by the VM without
involving the filesystem.  Swapping out extents underneath the VM thus
can cause severe problems.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dfrag.c	2009-02-10 19:19:25.440068967 +0100
+++ xfs/fs/xfs/xfs_dfrag.c	2009-02-10 19:20:35.182944272 +0100
@@ -79,6 +79,12 @@ xfs_swapext(
 		goto out_put_target_file;
 	}
 
+	if (IS_SWAPFILE(file->f_path.dentry->d_inode) ||
+	    IS_SWAPFILE(target_file->f_path.dentry->d_inode)) {
+		error = XFS_ERROR(EINVAL);
+		goto out_put_target_file;
+	}
+
 	ip = XFS_I(file->f_path.dentry->d_inode);
 	tip = XFS_I(target_file->f_path.dentry->d_inode);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2GCMPb032661 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:12:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78208164F2EA
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:12:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tSB1cukgzpC9tIrC for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:12:21 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xly-0007MK-Jg
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:50 +0000
Message-Id: <20081202160650.515494000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 07/22] stop using igrab in xfs_vn_link
Content-Disposition: inline; filename=xfs-stop-using-igrab-in-xfs_link
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

->link is guranteed to get an already reference inode passed so we
can do a simple increment of i_count instead of using igrab and thus
avoid banging on the global inode_lock.  This is what most filesystems
already do.

Also move the increment after the call to xfs_link to simplify error
handling.

(First sent on July 26th)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-10-25 13:00:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-10-25 13:13:24.000000000 +0200
@@ -366,21 +366,18 @@ xfs_vn_link(
 	struct inode	*dir,
 	struct dentry	*dentry)
 {
-	struct inode	*inode;	/* inode of guy being linked to */
+	struct inode	*inode = old_dentry->d_inode;
 	struct xfs_name	name;
 	int		error;
 
-	inode = old_dentry->d_inode;
 	xfs_dentry_to_name(&name, dentry);
 
-	igrab(inode);
 	error = xfs_link(XFS_I(dir), XFS_I(inode), &name);
-	if (unlikely(error)) {
-		iput(inode);
+	if (unlikely(error))
 		return -error;
-	}
 
 	xfs_iflags_set(XFS_I(dir), XFS_IMODIFIED);
+	atomic_inc(&inode->i_count);
 	d_instantiate(dentry, inode);
 	return 0;
 }

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

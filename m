Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:47:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDlFu0026125
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:47:15 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD9FE54B8D2
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:47:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id LNIAtmqZKdnV66j1 for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:47:14 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSR8-0001YX-Be
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:47:14 +0000
Date: Mon, 27 Oct 2008 09:47:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/10] stop using igrab in xfs_vn_link
Message-ID: <20081027134714.GD5730@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-stop-using-igrab-in-xfs_link
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
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

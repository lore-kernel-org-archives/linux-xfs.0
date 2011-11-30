Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAU8wJoV175773 for <xfs@oss.sgi.com>; Wed, 30 Nov 2011 02:58:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2209319F3A9F
	for <xfs@oss.sgi.com>; Wed, 30 Nov 2011 00:58:18 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	4PGgxx6QTrRkRXKD for <xfs@oss.sgi.com>;
	Wed, 30 Nov 2011 00:58:18 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RVfze-0005qe-B8
	for xfs@oss.sgi.com; Wed, 30 Nov 2011 08:58:18 +0000
Date: Wed, 30 Nov 2011 03:58:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/4] xfs: fix nfs export of 64-bit inodes numbers on 32-bit
	kernels
Message-ID: <20111130085817.GA22471@infradead.org>
References: <20111128081732.350228200@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128081732.350228200@bombadil.infradead.org>
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

The i_ino field in the VFS inode is of type unsigned long and thus can't
hold the full 64-bit inode number on 32-bit kernels.  We have the full
inode number in the XFS inode, so use that one for nfs exports.  Note
that I've also switched the 32-bit file handles types to it, just to make
the code more consistent and copy & paste errors less likely to happen.

Reported-by: Guoquan Yang <ygq51@hotmail.com>
Reported-by: Hank Peng <pengxihan@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_export.c
===================================================================
--- xfs.orig/fs/xfs/xfs_export.c	2011-11-28 12:11:08.923630697 +0100
+++ xfs/fs/xfs/xfs_export.c	2011-11-29 05:48:12.682177223 +0100
@@ -98,22 +98,22 @@ xfs_fs_encode_fh(
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
 		spin_lock(&dentry->d_lock);
-		fid->i32.parent_ino = dentry->d_parent->d_inode->i_ino;
+		fid->i32.parent_ino = XFS_I(dentry->d_parent->d_inode)->i_ino;
 		fid->i32.parent_gen = dentry->d_parent->d_inode->i_generation;
 		spin_unlock(&dentry->d_lock);
 		/*FALLTHRU*/
 	case FILEID_INO32_GEN:
-		fid->i32.ino = inode->i_ino;
+		fid->i32.ino = XFS_I(inode)->i_ino;
 		fid->i32.gen = inode->i_generation;
 		break;
 	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
 		spin_lock(&dentry->d_lock);
-		fid64->parent_ino = dentry->d_parent->d_inode->i_ino;
+		fid64->parent_ino = XFS_I(dentry->d_parent->d_inode)->i_ino;
 		fid64->parent_gen = dentry->d_parent->d_inode->i_generation;
 		spin_unlock(&dentry->d_lock);
 		/*FALLTHRU*/
 	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
-		fid64->ino = inode->i_ino;
+		fid64->ino = XFS_I(inode)->i_ino;
 		fid64->gen = inode->i_generation;
 		break;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

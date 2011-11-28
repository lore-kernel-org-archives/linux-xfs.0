Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASBJmO3233374
	for <linux-xfs@oss.sgi.com>; Mon, 28 Nov 2011 05:19:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49BE327B336
	for <linux-xfs@oss.sgi.com>; Mon, 28 Nov 2011 03:19:48 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Hk9R0LvY61F4GrAV for <linux-xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 03:19:48 -0800 (PST)
Date: Mon, 28 Nov 2011 06:19:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: validate inode numbers in file handles correctly
Message-ID: <20111128111947.GA26454@infradead.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>
	<loom.20111123T134243-580@post.gmane.org>
	<20111123143045.GA20892@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111123143045.GA20892@infradead.org>
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
To: Guoquan Yang <ygq51@hotmail.com>
Cc: linux-xfs@oss.sgi.com, hank peng <pengxihan@gmail.com>

Guoquan and hank,

are you using 32-bit or 64-bit kernels?  I just noticed we have a
problem with exporting 64-bit inodes on 32-bit kernel because the
VFS i_ino field is just 32-bits long.  The patch below would fix
that issue.

--- xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2011-11-28 12:11:08.923630697 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_export.c	2011-11-28 12:13:21.766244360 +0100
@@ -61,6 +61,8 @@ xfs_fs_encode_fh(
 	struct fid		*fid = (struct fid *)fh;
 	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fh;
 	struct inode		*inode = dentry->d_inode;
+	struct inode		*parent;
+	struct xfs_inode	*ip = XFS_I(inode);
 	int			fileid_type;
 	int			len;
 
@@ -98,22 +100,24 @@ xfs_fs_encode_fh(
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
 		spin_lock(&dentry->d_lock);
-		fid->i32.parent_ino = dentry->d_parent->d_inode->i_ino;
-		fid->i32.parent_gen = dentry->d_parent->d_inode->i_generation;
+		parent = dentry->d_parent->d_inode;
+		fid->i32.parent_ino = XFS_I(parent)->i_ino;
+		fid->i32.parent_gen = parent->i_generation;
 		spin_unlock(&dentry->d_lock);
 		/*FALLTHRU*/
 	case FILEID_INO32_GEN:
-		fid->i32.ino = inode->i_ino;
+		fid->i32.ino = ip->i_ino;
 		fid->i32.gen = inode->i_generation;
 		break;
 	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
 		spin_lock(&dentry->d_lock);
-		fid64->parent_ino = dentry->d_parent->d_inode->i_ino;
-		fid64->parent_gen = dentry->d_parent->d_inode->i_generation;
+		parent = dentry->d_parent->d_inode;
+		fid64->parent_ino = XFS_I(parent)->i_ino;
+		fid64->parent_gen = parent->i_generation;
 		spin_unlock(&dentry->d_lock);
 		/*FALLTHRU*/
 	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
-		fid64->ino = inode->i_ino;
+		fid64->ino = ip->i_ino;
 		fid64->gen = inode->i_generation;
 		break;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n55AQ6e5039136 for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 05:26:11 -0500
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F55B1BCBC40
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 03:26:24 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com
	with ESMTP id KAh9LIefZFSSZhMk for <xfs@oss.sgi.com>;
	Fri, 05 Jun 2009 03:26:24 -0700 (PDT)
Date: Fri, 5 Jun 2009 12:26:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: remove ->write_super and stop maintaining ->s_dirt
Message-ID: <20090605102622.GA30685@lst.de>
Mime-Version: 1.0
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
To: viro@zeniv.linux.org.uk, xfs@oss.sgi.com

Al, can you put this in via the vfs tree?  With people starting to
change these bits now I think we're better off feeding this through
the VFS tree early than later via the XFS tree.

--

Subject: [PATCH] xfs: remove ->write_super and stop maintaining ->s_dirt
From: Christoph Hellwig <hch@lst.de>

the write_super method is used for

 (1) writing back the superblock periodically from pdflush
 (2) called just before ->sync_fs for data integerity syncs

We don't need (1) because we have our own peridoc writeout through xfssyncd,
and we don't need (2) because xfs_fs_sync_fs performs a proper synchronous
superblock writeout after all other data and metadata has been written out.

Also remove ->s_dirt tracking as it's only used to decide when too call
->write_super.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Index: vfs-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- vfs-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2009-05-11 11:13:24.528784658 +0200
+++ vfs-2.6/fs/xfs/linux-2.6/xfs_super.c	2009-05-11 22:09:29.802683006 +0200
@@ -1108,15 +1108,6 @@ xfs_fs_put_super(
 	unlock_kernel();
 }
 
-STATIC void
-xfs_fs_write_super(
-	struct super_block	*sb)
-{
-	if (!(sb->s_flags & MS_RDONLY))
-		xfs_sync_fsdata(XFS_M(sb), 0);
-	sb->s_dirt = 0;
-}
-
 STATIC int
 xfs_fs_sync_super(
 	struct super_block	*sb,
@@ -1141,7 +1132,6 @@ xfs_fs_sync_super(
 		error = xfs_quiesce_data(mp);
 	else
 		error = xfs_sync_fsdata(mp, 0);
-	sb->s_dirt = 0;
 
 	if (unlikely(laptop_mode)) {
 		int	prev_sync_seq = mp->m_sync_seq;
@@ -1447,7 +1437,6 @@ xfs_fs_fill_super(
 
 	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, mtpt, mp->m_fsname);
 
-	sb->s_dirt = 1;
 	sb->s_magic = XFS_SB_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
@@ -1537,7 +1526,6 @@ static struct super_operations xfs_super
 	.write_inode		= xfs_fs_write_inode,
 	.clear_inode		= xfs_fs_clear_inode,
 	.put_super		= xfs_fs_put_super,
-	.write_super		= xfs_fs_write_super,
 	.sync_fs		= xfs_fs_sync_super,
 	.freeze_fs		= xfs_fs_freeze,
 	.statfs			= xfs_fs_statfs,
Index: vfs-2.6/fs/xfs/xfs_trans.c
===================================================================
--- vfs-2.6.orig/fs/xfs/xfs_trans.c	2009-05-05 14:18:45.481659125 +0200
+++ vfs-2.6/fs/xfs/xfs_trans.c	2009-05-11 22:09:29.803682225 +0200
@@ -628,8 +628,6 @@ xfs_trans_apply_sb_deltas(
 		xfs_trans_log_buf(tp, bp, offsetof(xfs_dsb_t, sb_icount),
 				  offsetof(xfs_dsb_t, sb_frextents) +
 				  sizeof(sbp->sb_frextents) - 1);
-
-	tp->t_mountp->m_super->s_dirt = 1;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

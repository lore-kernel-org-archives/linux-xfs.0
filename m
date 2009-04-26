Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3QE79CF233107 for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 09:07:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D04D23E3DF
	for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 07:07:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4jC9D6bpn27Gok8R for
	<xfs@oss.sgi.com>; Sun, 26 Apr 2009 07:07:08 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Ly50d-0008Hg-K9
	for xfs@oss.sgi.com; Sun, 26 Apr 2009 14:07:07 +0000
Message-Id: <20090426140707.533370000@bombadil.infradead.org>
Date: Sun, 26 Apr 2009 10:03:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] xfs: remove ->write_super and stop maintaining ->s_dirt
References: <20090426140305.113371000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-stop-maintaining-s_dirt
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

the write_super method is used for

 (1) writing back the superblock periodically from pdflush
 (2) called just before ->sync_fs for data integerity syncs
 (3) just before ->put_super

We don't need (1) because we have our own peridoc writeout through xfssyncd,
we don't need (2) because xfs_fs_sync_fs performs a proper synchronous
superblock writeout after all other data and metadata has been written out,
and we don't need (3) because we synchronously write the superblock in
->put_super once the filesystem is fully shut down.

Also remove ->s_dirt tracking as it's only used to decide when too call
->write_super.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2009-04-26 10:33:36.051949562 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c	2009-04-26 10:34:19.962075469 +0200
@@ -1104,15 +1104,6 @@ xfs_fs_put_super(
 	kfree(mp);
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
@@ -1137,7 +1128,6 @@ xfs_fs_sync_super(
 		error = xfs_quiesce_data(mp);
 	else
 		error = xfs_sync_fsdata(mp, 0);
-	sb->s_dirt = 0;
 
 	if (unlikely(laptop_mode)) {
 		int	prev_sync_seq = mp->m_sync_seq;
@@ -1443,7 +1433,6 @@ xfs_fs_fill_super(
 
 	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, mtpt, mp->m_fsname);
 
-	sb->s_dirt = 1;
 	sb->s_magic = XFS_SB_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
@@ -1533,7 +1522,6 @@ static struct super_operations xfs_super
 	.write_inode		= xfs_fs_write_inode,
 	.clear_inode		= xfs_fs_clear_inode,
 	.put_super		= xfs_fs_put_super,
-	.write_super		= xfs_fs_write_super,
 	.sync_fs		= xfs_fs_sync_super,
 	.freeze_fs		= xfs_fs_freeze,
 	.statfs			= xfs_fs_statfs,
Index: linux-2.6/fs/xfs/xfs_trans.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_trans.c	2009-04-26 10:33:25.534949105 +0200
+++ linux-2.6/fs/xfs/xfs_trans.c	2009-04-26 10:33:31.760951563 +0200
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

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALGSUSG018631 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 10:28:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 073251BDDF58
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 08:28:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JNY7CljBvB4UwukK for
	<xfs@oss.sgi.com>; Fri, 21 Nov 2008 08:28:29 -0800 (PST)
Date: Fri, 21 Nov 2008 11:28:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] fix NULL pointer dereference in xfs_log_force_umount
Message-ID: <20081121162829.GA17277@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: aluno3@poczta.onet.pl

xfs_log_force_umount may be called very early during log recovery where

If we fail a buffer read in xlog_recover_do_inode_trans we abort the mount.
But at that point log recovery has started delayed writeback of inode
buffers.   As part of the aborted mount we try to flush out all delwri
buffers, but at that point we have already freed the superblock, and set
mp->m_sb_bp to NULL, and xfs_log_force_umount which gets called after
the inode buffer writeback trips over it.

Make xfs_log_force_umounr a little more careful when accessing mp->m_sb_bp
to avoid this.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-2.6/fs/xfs/xfs_log.c
===================================================================
--- xfs-2.6.orig/fs/xfs/xfs_log.c	2008-11-21 17:07:30.000000000 +0100
+++ xfs-2.6/fs/xfs/xfs_log.c	2008-11-21 17:13:02.000000000 +0100
@@ -3525,7 +3525,8 @@ xfs_log_force_umount(
 	if (!log ||
 	    log->l_flags & XLOG_ACTIVE_RECOVERY) {
 		mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
-		XFS_BUF_DONE(mp->m_sb_bp);
+		if (mp->m_sb_bp)
+			XFS_BUF_DONE(mp->m_sb_bp);
 		return 0;
 	}
 
@@ -3546,7 +3547,9 @@ xfs_log_force_umount(
 	spin_lock(&log->l_icloglock);
 	spin_lock(&log->l_grant_lock);
 	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
-	XFS_BUF_DONE(mp->m_sb_bp);
+	if (mp->m_sb_bp)
+		XFS_BUF_DONE(mp->m_sb_bp);
+
 	/*
 	 * This flag is sort of redundant because of the mount flag, but
 	 * it's good to maintain the separation between the log and the rest

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

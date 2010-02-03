Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13JgMbq241215 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 13:42:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B48B1C9E846
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 11:43:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DKgDPNNNKOZ3WaNO for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 11:43:32 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Ncl8N-0004Bw-Rv
	for xfs@oss.sgi.com; Wed, 03 Feb 2010 19:43:31 +0000
Date: Wed, 3 Feb 2010 14:43:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: only clear the suid bit once in xfs_write
Message-ID: <20100203194331.GA20199@infradead.org>
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

file_remove_suid already calls into ->setattr to clear the suid and sgid
bits if needed, no need to start a second transaction to do it ourselves.

Note that xfs_write_clear_setuid issues a sync transaction while the
path through ->setattr doesn't, but that is consistant with the other
filesystems.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2010-02-03 20:37:45.956003749 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_lrw.c	2010-02-03 20:37:49.348003520 +0100
@@ -630,18 +630,9 @@ start:
 	 * by root.  This keeps people from modifying setuid and
 	 * setgid binaries.
 	 */
-
-	if (((xip->i_d.di_mode & S_ISUID) ||
-	    ((xip->i_d.di_mode & (S_ISGID | S_IXGRP)) ==
-		(S_ISGID | S_IXGRP))) &&
-	     !capable(CAP_FSETID)) {
-		error = xfs_write_clear_setuid(xip);
-		if (likely(!error))
-			error = -file_remove_suid(file);
-		if (unlikely(error)) {
-			goto out_unlock_internal;
-		}
-	}
+	error = -file_remove_suid(file);
+	if (unlikely(error))
+		goto out_unlock_internal;
 
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2010-02-03 20:37:45.965004126 +0100
+++ xfs/fs/xfs/xfs_rw.c	2010-02-03 20:37:49.349010212 +0100
@@ -47,48 +47,6 @@
 #include "xfs_trace.h"
 
 /*
- * This is a subroutine for xfs_write() and other writers (xfs_ioctl)
- * which clears the setuid and setgid bits when a file is written.
- */
-int
-xfs_write_clear_setuid(
-	xfs_inode_t	*ip)
-{
-	xfs_mount_t	*mp;
-	xfs_trans_t	*tp;
-	int		error;
-
-	mp = ip->i_mount;
-	tp = xfs_trans_alloc(mp, XFS_TRANS_WRITEID);
-	if ((error = xfs_trans_reserve(tp, 0,
-				      XFS_WRITEID_LOG_RES(mp),
-				      0, 0, 0))) {
-		xfs_trans_cancel(tp, 0);
-		return error;
-	}
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_ihold(tp, ip);
-	ip->i_d.di_mode &= ~S_ISUID;
-
-	/*
-	 * Note that we don't have to worry about mandatory
-	 * file locking being disabled here because we only
-	 * clear the S_ISGID bit if the Group execute bit is
-	 * on, but if it was on then mandatory locking wouldn't
-	 * have been enabled.
-	 */
-	if (ip->i_d.di_mode & S_IXGRP) {
-		ip->i_d.di_mode &= ~S_ISGID;
-	}
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
-}
-
-/*
  * Force a shutdown of the filesystem instantly while keeping
  * the filesystem consistent. We don't do an unmount here; just shutdown
  * the shop, make sure that absolutely nothing persistent happens to
Index: xfs/fs/xfs/xfs_rw.h
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.h	2010-02-03 20:37:53.085003394 +0100
+++ xfs/fs/xfs/xfs_rw.h	2010-02-03 20:37:57.946033654 +0100
@@ -39,7 +39,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_
 /*
  * Prototypes for functions in xfs_rw.c.
  */
-extern int xfs_write_clear_setuid(struct xfs_inode *ip);
 extern int xfs_read_buf(struct xfs_mount *mp, xfs_buftarg_t *btp,
 			xfs_daddr_t blkno, int len, uint flags,
 			struct xfs_buf **bpp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

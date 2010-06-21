Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L8XSip113447 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 03:33:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D1CF15113FF
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:36:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4rsK6OPCc4I2jG3m for
	<xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:36:08 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OQcUC-0007d3-AY
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 08:36:08 +0000
Message-Id: <20100621083608.249757129@bombadil.infradead.org>
Date: Mon, 21 Jun 2010 04:35:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/12] xfs: remove xfs_iput
References: <20100621083543.125860679@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-xfs_iput
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

xfs_iput is just a small wrapper for xfs_iunlock + IRELE.  Having this
out of line wrapper means the trace events in those two can't track
their caller properly.  So just remove the wrapper and opencode the
unlock + rele in the few callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2010-06-19 23:06:59.269003778 +0200
+++ xfs/fs/xfs/xfs_iget.c	2010-06-19 23:08:14.611253952 +0200
@@ -418,23 +418,6 @@ out_error_or_again:
 }
 
 /*
- * Decrement reference count of an inode structure and unlock it.
- *
- * ip -- the inode being released
- * lock_flags -- this parameter indicates the inode's locks to be
- *       to be released.  See the comment on xfs_iunlock() for a list
- *	 of valid values.
- */
-void
-xfs_iput(xfs_inode_t	*ip,
-	 uint		lock_flags)
-{
-	xfs_itrace_entry(ip);
-	xfs_iunlock(ip, lock_flags);
-	IRELE(ip);
-}
-
-/*
  * This is called free all the memory associated with an inode.
  * It must free the inode itself and any buffers allocated for
  * if_extents/if_data and if_broot.  It must also free the lock
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-06-19 23:06:53.000000000 +0200
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-06-19 23:08:14.612254022 +0200
@@ -1662,7 +1662,8 @@ xfs_qm_dqusage_adjust(
 	 * making us disable quotas for the file system.
 	 */
 	if ((error = xfs_qm_dqget_noattach(ip, &udqp, &gdqp))) {
-		xfs_iput(ip, XFS_ILOCK_EXCL);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		IRELE(ip);
 		*res = BULKSTAT_RV_GIVEUP;
 		return error;
 	}
@@ -1675,7 +1676,8 @@ xfs_qm_dqusage_adjust(
 		 * Walk thru the extent list and count the realtime blocks.
 		 */
 		if ((error = xfs_qm_get_rtblks(ip, &rtblks))) {
-			xfs_iput(ip, XFS_ILOCK_EXCL);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			IRELE(ip);
 			if (udqp)
 				xfs_qm_dqput(udqp);
 			if (gdqp)
Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2010-06-19 23:06:53.000000000 +0200
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2010-06-19 23:08:14.613254161 +0200
@@ -861,8 +861,9 @@ xfs_dqrele_inode(
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
-	xfs_iput(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
+	IRELE(ip);
 	return 0;
 }
 
@@ -1129,7 +1130,8 @@ xfs_qm_internalqcheck_adjust(
 	 * of those now.
 	 */
 	if (! ipreleased) {
-		xfs_iput(ip, lock_flags);
+		xfs_iunlock(ip, lock_flags);
+		IRELE(ip);
 		ipreleased = B_TRUE;
 		goto again;
 	}
@@ -1146,7 +1148,8 @@ xfs_qm_internalqcheck_adjust(
 		ASSERT(gd);
 		xfs_qm_internalqcheck_dqadjust(ip, gd);
 	}
-	xfs_iput(ip, lock_flags);
+	xfs_iunlock(ip, lock_flags);
+	IRELE(ip);
 	*res = BULKSTAT_RV_DIDONE;
 	return (0);
 }
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2010-06-19 23:06:59.000000000 +0200
+++ xfs/fs/xfs/xfs_inode.h	2010-06-19 23:08:14.618253882 +0200
@@ -443,7 +443,6 @@ static inline void xfs_ifunlock(xfs_inod
  */
 int		xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 			 uint, uint, xfs_inode_t **);
-void		xfs_iput(xfs_inode_t *, uint);
 void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-06-19 23:06:49.000000000 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2010-06-19 23:08:14.623253952 +0200
@@ -660,8 +660,10 @@ xfs_inode_item_unlock(
 
 	lock_flags = iip->ili_lock_flags;
 	iip->ili_lock_flags = 0;
-	if (lock_flags)
-		xfs_iput(iip->ili_inode, lock_flags);
+	if (lock_flags) {
+		xfs_iunlock(iip->ili_inode, lock_flags);
+		IRELE(iip->ili_inode);
+	}
 }
 
 /*
Index: xfs/fs/xfs/xfs_itable.c
===================================================================
--- xfs.orig/fs/xfs/xfs_itable.c	2010-06-19 23:06:53.000000000 +0200
+++ xfs/fs/xfs/xfs_itable.c	2010-06-19 23:08:14.627253952 +0200
@@ -34,6 +34,7 @@
 #include "xfs_itable.h"
 #include "xfs_error.h"
 #include "xfs_btree.h"
+#include "xfs_trace.h"
 
 STATIC int
 xfs_internal_inum(
@@ -139,7 +140,8 @@ xfs_bulkstat_one_int(
 		buf->bs_blocks = dic->di_nblocks + ip->i_delayed_blks;
 		break;
 	}
-	xfs_iput(ip, XFS_ILOCK_SHARED);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	IRELE(ip);
 
 	error = formatter(buffer, ubsize, ubused, buf);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

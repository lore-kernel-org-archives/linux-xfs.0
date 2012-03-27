Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2REcSVH093891 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 09:38:28 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ICMU823c519feiHW (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 07:38:27 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCXXW-0004Jr-Lb
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 14:38:26 +0000
Message-Id: <20120327143826.615954651@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 10:34:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] xfs: reduce ilock hold times in xfs_setattr_size
References: <20120327143445.196524266@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-reduce-ilock-in-truncate
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

We do not need the ilock for most checks done in the beginning of
xfs_setattr_size.  Replace the long critical section before starting the
transaction with a smaller one around xfs_zero_eof and an optional one
inside xfs_qm_dqattach that isn't entered unless using quotas.  While
this isn't a big optimization for xfs_setattr_size itself it will allow
pushing the ilock into xfs_zero_eof itself later.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_iops.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: xfs/fs/xfs/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.c	2012-03-26 15:17:47.088854526 +0200
+++ xfs/fs/xfs/xfs_iops.c	2012-03-26 15:17:57.265521382 +0200
@@ -700,7 +700,7 @@ xfs_setattr_size(
 	xfs_off_t		oldsize, newsize;
 	struct xfs_trans	*tp;
 	int			error;
-	uint			lock_flags;
+	uint			lock_flags = 0;
 	uint			commit_flags = 0;
 
 	trace_xfs_setattr(ip);
@@ -720,10 +720,10 @@ xfs_setattr_size(
 			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
 			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
 
-	lock_flags = XFS_ILOCK_EXCL;
-	if (!(flags & XFS_ATTR_NOLOCK))
+	if (!(flags & XFS_ATTR_NOLOCK)) {
 		lock_flags |= XFS_IOLOCK_EXCL;
-	xfs_ilock(ip, lock_flags);
+		xfs_ilock(ip, lock_flags);
+	}
 
 	oldsize = inode->i_size;
 	newsize = iattr->ia_size;
@@ -746,7 +746,7 @@ xfs_setattr_size(
 	/*
 	 * Make sure that the dquots are attached to the inode.
 	 */
-	error = xfs_qm_dqattach_locked(ip, 0);
+	error = xfs_qm_dqattach(ip, 0);
 	if (error)
 		goto out_unlock;
 
@@ -764,12 +764,12 @@ xfs_setattr_size(
 		 * before the inode is joined to the transaction to modify
 		 * i_size.
 		 */
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_zero_eof(ip, newsize, oldsize);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
 			goto out_unlock;
 	}
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	lock_flags &= ~XFS_ILOCK_EXCL;
 
 	/*
 	 * We are going to log the inode size change in this transaction so

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

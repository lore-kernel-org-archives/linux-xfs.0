Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2REcRXo093890 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 09:38:28 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NC7s073z2D1E0K1O (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 07:38:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCXXW-0004JL-FZ
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 14:38:26 +0000
Message-Id: <20120327143826.433267717@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 10:34:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: reduce ilock hold times in xfs_file_aio_write_checks
References: <20120327143445.196524266@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-reduce-ilock-in-write-preparation
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

We do not need the ilock for generic_write_checks and the i_size read,
which are protected by i_mutex and/or iolock, so reduce the ilock
critical section to just the call to xfs_zero_eof.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_file.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2012-03-26 21:22:01.495953714 +0200
+++ xfs/fs/xfs/xfs_file.c	2012-03-26 21:24:07.955268625 +0200
@@ -593,35 +593,31 @@ xfs_file_aio_write_checks(
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error = 0;
 
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
 restart:
 	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
-	if (error) {
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
 		return error;
-	}
 
 	/*
 	 * If the offset is beyond the size of the file, we need to zero any
 	 * blocks that fall between the existing EOF and the start of this
 	 * write.  If zeroing is needed and we are currently holding the
-	 * iolock shared, we need to update it to exclusive which involves
-	 * dropping all locks and relocking to maintain correct locking order.
-	 * If we do this, restart the function to ensure all checks and values
-	 * are still valid.
+	 * iolock shared, we need to update it to exclusive which implies
+	 * having to redo all checks before.
 	 */
 	if (*pos > i_size_read(inode)) {
 		if (*iolock == XFS_IOLOCK_SHARED) {
-			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
+			xfs_rw_iunlock(ip, *iolock);
 			*iolock = XFS_IOLOCK_EXCL;
-			xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
+			xfs_rw_ilock(ip, *iolock);
 			goto restart;
 		}
+		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
 		error = -xfs_zero_eof(ip, *pos, i_size_read(inode));
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
+		if (error)
+			return error;
 	}
-	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
-	if (error)
-		return error;
 
 	/*
 	 * Updating the timestamps will grab the ilock again from
@@ -638,7 +634,6 @@ restart:
 	 * people from modifying setuid and setgid binaries.
 	 */
 	return file_remove_suid(file);
-
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

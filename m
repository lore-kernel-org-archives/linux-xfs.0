Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54IaO135641 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:18 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SB2fG4JqVKXSJAPe for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:03 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbK-0003IU-2S
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pb9-0003gu-WF
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 069/102] xfs: reduce ilock hold times in
	xfs_file_aio_write_checks
Date: Thu, 23 Aug 2012 15:02:27 +1000
Message-Id: <1345698180-13612-70-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 467f78992a0743e0e71729e4faa20b67b0f25289

We do not need the ilock for generic_write_checks and the i_size_read,
which are protected by i_mutex and/or iolock, so reduce the ilock
critical section to just the call to xfs_zero_eof.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_file.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 1dbd1d8..d0239cf 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -589,35 +589,31 @@ xfs_file_aio_write_checks(
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
@@ -634,7 +630,6 @@ restart:
 	 * people from modifying setuid and setgid binaries.
 	 */
 	return file_remove_suid(file);
-
 }
 
 /*
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

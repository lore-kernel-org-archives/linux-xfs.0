Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54ABx135583 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:10 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kUgC5BforWE2HwzR for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:55 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbA-0003IV-7S
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:52 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbA-0003h9-0z
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 070/102] xfs: reduce ilock hold times in xfs_setattr_size
Date: Thu, 23 Aug 2012 15:02:28 +1000
Message-Id: <1345698180-13612-71-git-send-email-david@fromorbit.com>
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

Upstream commit: f38996f5768713fb60e1d2de66c097367d54bb6a

We do not need the ilock for most checks done in the beginning of
xfs_setattr_size.  Replace the long critical section before starting the
transaction with a smaller one around xfs_zero_eof and an optional one
inside xfs_qm_dqattach that isn't entered unless using quotas.  While
this isn't a big optimization for xfs_setattr_size itself it will allow
pushing the ilock into xfs_zero_eof itself later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_vnodeops.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 0e94d59..b156e46 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -61,7 +61,7 @@ xfs_setattr(
 	int			mask = iattr->ia_valid;
 	xfs_trans_t		*tp;
 	int			code;
-	uint			lock_flags;
+	uint			lock_flags = 0;
 	uint			commit_flags=0;
 	uid_t			uid=0, iuid=0;
 	gid_t			gid=0, igid=0;
@@ -126,7 +126,7 @@ xfs_setattr(
 	 */
 	tp = NULL;
 restart:
-	lock_flags = XFS_ILOCK_EXCL;
+	lock_flags = 0;
 	if (flags & XFS_ATTR_NOLOCK)
 		need_iolock = 0;
 	if (!(mask & ATTR_SIZE)) {
@@ -139,6 +139,7 @@ restart:
 			lock_flags = 0;
 			goto error_return;
 		}
+		lock_flags = XFS_ILOCK_EXCL;
 	} else {
 		if (need_iolock)
 			lock_flags |= XFS_IOLOCK_EXCL;
@@ -186,8 +187,6 @@ restart:
 		/* Short circuit the truncate case for zero length files */
 		if (iattr->ia_size == 0 &&
 		    old_size == 0 && ip->i_d.di_nextents == 0) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			lock_flags &= ~XFS_ILOCK_EXCL;
 			if (mask & ATTR_CTIME) {
 				/* need to log timestamp changes */
 				iattr->ia_ctime = iattr->ia_mtime =
@@ -213,7 +212,7 @@ restart:
 		/*
 		 * Make sure that the dquots are attached to the inode.
 		 */
-		code = xfs_qm_dqattach_locked(ip, 0);
+		code = xfs_qm_dqattach(ip, 0);
 		if (code)
 			goto error_return;
 
@@ -232,12 +231,12 @@ restart:
 			 * need to do this before the inode is joined to the
 			 * transaction to modify the i_size.
 			 */
+			xfs_ilock(ip, XFS_ILOCK_EXCL);
 			code = xfs_zero_eof(ip, iattr->ia_size, old_size);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			if (code)
 				goto error_return;
 		}
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		lock_flags &= ~XFS_ILOCK_EXCL;
 
 		/*
 		 * We are going to log the inode size change in this
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

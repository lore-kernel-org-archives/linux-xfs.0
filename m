Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N537IG134931 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:07 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	31x3zFN0IjNAFHLu for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:52 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pa0-0003Fs-KK
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pa0-0003df-HT
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 031/102] xfs: always return with the iolock held from
Date: Thu, 23 Aug 2012 15:01:49 +1000
Message-Id: <1345698180-13612-32-git-send-email-david@fromorbit.com>
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

Upstream commit: 5bf1f26227a59b9634e95eb3c7c012b766e5e6a0
 xfs_file_aio_write_checks

While xfs_iunlock is fine with 0 lockflags the calling conventions are much
cleaner if xfs_file_aio_write_checks never returns without the iolock held.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_file.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index e3076f0..b9e3101 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -631,7 +631,9 @@ out_lock:
 /*
  * Common pre-write limit and setup checks.
  *
- * Returns with iolock held according to @iolock.
+ * Called with the iolocked held either shared and exclusive according to
+ * @iolock, and returns with it held.  Might upgrade the iolock to exclusive
+ * if called for a direct write beyond i_size.
  */
 STATIC ssize_t
 xfs_file_aio_write_checks(
@@ -648,8 +650,7 @@ xfs_file_aio_write_checks(
 restart:
 	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
 	if (error) {
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
-		*iolock = 0;
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 		return error;
 	}
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

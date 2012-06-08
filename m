Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q585jll8174281 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 00:45:47 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HkYweNayBu8Kdpu1 for <xfs@oss.sgi.com>;
	Thu, 07 Jun 2012 22:45:45 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Scs12-0004jw-AQ
	for xfs@oss.sgi.com; Fri, 08 Jun 2012 15:45:44 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1Scs12-0002zh-6L
	for xfs@oss.sgi.com; Fri, 08 Jun 2012 15:45:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: kill copy and paste segment checks in xfs_file_aio_read
Date: Fri,  8 Jun 2012 15:45:44 +1000
Message-Id: <1339134344-11479-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The generic segment check code now returns a count of the number of
bytes in the iovec, so we don't need to roll our own anymore.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index bcb97dc..07339a5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -236,7 +236,6 @@ xfs_file_aio_read(
 	ssize_t			ret = 0;
 	int			ioflags = 0;
 	xfs_fsize_t		n;
-	unsigned long		seg;
 
 	XFS_STATS_INC(xs_read_calls);
 
@@ -247,19 +246,9 @@ xfs_file_aio_read(
 	if (file->f_mode & FMODE_NOCMTIME)
 		ioflags |= IO_INVIS;
 
-	/* START copy & waste from filemap.c */
-	for (seg = 0; seg < nr_segs; seg++) {
-		const struct iovec *iv = &iovp[seg];
-
-		/*
-		 * If any segment has a negative length, or the cumulative
-		 * length ever wraps negative then return -EINVAL.
-		 */
-		size += iv->iov_len;
-		if (unlikely((ssize_t)(size|iv->iov_len) < 0))
-			return XFS_ERROR(-EINVAL);
-	}
-	/* END copy & waste from filemap.c */
+	ret = generic_segment_checks(iovp, &nr_segs, &size, VERIFY_WRITE);
+	if (ret < 0)
+		return ret;
 
 	if (unlikely(ioflags & IO_ISDIRECT)) {
 		xfs_buftarg_t	*target =
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

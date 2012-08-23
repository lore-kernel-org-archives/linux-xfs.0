Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N55D2Q136117 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:13 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EDwllDuzSieGrUd4 for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pbz-0003KY-ES
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:43 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pbp-0003jL-CA
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 096/102] xfs: kill copy and paste segment checks in
	xfs_file_aio_read
Date: Thu, 23 Aug 2012 15:02:54 +1000
Message-Id: <1345698180-13612-97-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: 5276432997feb2366ac1e77949e94fe86a394813

The generic segment check code now returns a count of the number of
bytes in the iovec, so we don't need to roll our own anymore.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_file.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 28e3eed..1b57ff9 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -232,7 +232,6 @@ xfs_file_aio_read(
 	ssize_t			ret = 0;
 	int			ioflags = 0;
 	xfs_fsize_t		n;
-	unsigned long		seg;
 
 	XFS_STATS_INC(xs_read_calls);
 
@@ -243,19 +242,9 @@ xfs_file_aio_read(
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

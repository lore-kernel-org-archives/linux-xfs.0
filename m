Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52X4g134519 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:33 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Na1N5IFwHFGbFUoh for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:18 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZa-0003EM-R6
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZa-0003bx-Oi
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 010/102] xfs: fix possible overflow in xfs_ioc_trim()
Date: Thu, 23 Aug 2012 15:01:28 +1000
Message-Id: <1345698180-13612-11-git-send-email-david@fromorbit.com>
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

From: Lukas Czerner <lczerner@redhat.com>

Upstream commit: c029a50d51b8a9520105ec903639de03389915d0

In xfs_ioc_trim it is possible that computing the last allocation group
to discard might overflow for big start & len values, because the result
might be bigger then xfs_agnumber_t which is 32 bit long. Fix this by not
allowing the start and end block of the range to be beyond the end of the
file system.

Note that if the start is beyond the end of the file system we have to
return -EINVAL, but in the "end" case we have to truncate it to the fs
size.

Also introduce "end" variable, rather than using start+len which which
might be more confusing to get right as this bug shows.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_discard.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_discard.c b/fs/xfs/linux-2.6/xfs_discard.c
index 572494f..286a051 100644
--- a/fs/xfs/linux-2.6/xfs_discard.c
+++ b/fs/xfs/linux-2.6/xfs_discard.c
@@ -38,7 +38,7 @@ xfs_trim_extents(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_fsblock_t		start,
-	xfs_fsblock_t		len,
+	xfs_fsblock_t		end,
 	xfs_fsblock_t		minlen,
 	__uint64_t		*blocks_trimmed)
 {
@@ -100,7 +100,7 @@ xfs_trim_extents(
 		 * down partially overlapping ranges for now.
 		 */
 		if (XFS_AGB_TO_FSB(mp, agno, fbno) + flen < start ||
-		    XFS_AGB_TO_FSB(mp, agno, fbno) >= start + len) {
+		    XFS_AGB_TO_FSB(mp, agno, fbno) > end) {
 			trace_xfs_discard_exclude(mp, agno, fbno, flen);
 			goto next_extent;
 		}
@@ -145,7 +145,7 @@ xfs_ioc_trim(
 	struct request_queue	*q = mp->m_ddev_targp->bt_bdev->bd_disk->queue;
 	unsigned int		granularity = q->limits.discard_granularity;
 	struct fstrim_range	range;
-	xfs_fsblock_t		start, len, minlen;
+	xfs_fsblock_t		start, end, minlen;
 	xfs_agnumber_t		start_agno, end_agno, agno;
 	__uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
@@ -165,19 +165,19 @@ xfs_ioc_trim(
 	 * matter as trimming blocks is an advisory interface.
 	 */
 	start = XFS_B_TO_FSBT(mp, range.start);
-	len = XFS_B_TO_FSBT(mp, range.len);
+	end = start + XFS_B_TO_FSBT(mp, range.len) - 1;
 	minlen = XFS_B_TO_FSB(mp, max_t(u64, granularity, range.minlen));
 
-	start_agno = XFS_FSB_TO_AGNO(mp, start);
-	if (start_agno >= mp->m_sb.sb_agcount)
+	if (start >= mp->m_sb.sb_dblocks)
 		return -XFS_ERROR(EINVAL);
+	if (end > mp->m_sb.sb_dblocks - 1)
+		end = mp->m_sb.sb_dblocks - 1;
 
-	end_agno = XFS_FSB_TO_AGNO(mp, start + len);
-	if (end_agno >= mp->m_sb.sb_agcount)
-		end_agno = mp->m_sb.sb_agcount - 1;
+	start_agno = XFS_FSB_TO_AGNO(mp, start);
+	end_agno = XFS_FSB_TO_AGNO(mp, end);
 
 	for (agno = start_agno; agno <= end_agno; agno++) {
-		error = -xfs_trim_extents(mp, agno, start, len, minlen,
+		error = -xfs_trim_extents(mp, agno, start, end, minlen,
 					  &blocks_trimmed);
 		if (error)
 			last_error = error;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

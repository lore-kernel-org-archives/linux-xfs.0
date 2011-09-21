Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8L9ggiT130484 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 04:42:42 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A32511608D44
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 02:48:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VzEG5BvgCWpzxfuN for
	<xfs@oss.sgi.com>; Wed, 21 Sep 2011 02:48:03 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v3] xfs: fix possible overflow in xfs_ioc_trim()
Date: Wed, 21 Sep 2011 11:42:30 +0200
Message-Id: <1316598150-12447-1-git-send-email-lczerner@redhat.com>
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
Cc: hch@infradead.org, Lukas Czerner <lczerner@redhat.com>

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
---
v2: Use sb_dblocks instead of XFS_MAX_DBLOCKS to get max block count
v3: Rework the patch

 fs/xfs/xfs_discard.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 244e797..8a24f0c 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
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
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

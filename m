Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54Ue3135764 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:30 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	u9TthrDOAN1pKpBG for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:15 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbK-0003JA-MP
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbK-0003hk-DT
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 078/102] xfs: don't assert on delalloc regions beyond EOF
Date: Thu, 23 Aug 2012 15:02:36 +1000
Message-Id: <1345698180-13612-79-git-send-email-david@fromorbit.com>
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

Upstream commit: 58e20770646932fe9b758c94e8c278ea9ec93878

When we are doing speculative delayed allocation beyond EOF,
conversion of the region allocated beyond EOF is dependent on the
largest free space extent available. If the largest free extent is
smaller than the delalloc range, then after allocation we leave
a delalloc extent that starts beyond EOF. This extent cannot *ever*
be converted by flushing data, and so will remain there until either
the EOF moves into the extent or it is truncated away.

Hence if xfs_getbmap() runs on such an inode and is asked to return
extents beyond EOF, it will assert fail on this extent even though
there is nothing xfs_getbmap() can do to convert it to a real
extent. Hence we should simply report these delalloc extents rather
than assert that there should be none.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_bmap.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 8f3b730..2b4e8d2 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5541,8 +5541,20 @@ xfs_getbmap(
 				XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			out[cur_ext].bmv_unused1 = 0;
 			out[cur_ext].bmv_unused2 = 0;
-			ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
-			      (map[i].br_startblock != DELAYSTARTBLOCK));
+
+			/*
+			 * delayed allocation extents that start beyond EOF can
+			 * occur due to speculative EOF allocation when the
+			 * delalloc extent is larger than the largest freespace
+			 * extent at conversion time. These extents cannot be
+			 * converted by data writeback, so can exist here even
+			 * if we are not supposed to be finding delalloc
+			 * extents.
+			 */
+			if (map[i].br_startblock == DELAYSTARTBLOCK &&
+			    map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
+				ASSERT((iflags & BMV_IF_DELALLOC) != 0);
+
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
 			    whichfork == XFS_ATTR_FORK) {
 				/* came to the end of attribute fork */
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from nfs10.americas.sgi.com (nfs10.americas.sgi.com [128.162.245.67])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47KSDuS156270 for <xfs@oss.sgi.com>; Mon, 7 May 2012 15:28:13 -0500
Message-Id: <20120507204247.120777169@nfs10.americas.sgi.com>
Date: Mon, 07 May 2012 15:42:25 -0500
From: bpm@sgi.com
Subject: [patch 3/5] [PATCH 4/3] xfs: dont assert on delalloc regions beyond
	EOF
References: <20120507204222.921092617@nfs10.americas.sgi.com>
Content-Disposition: inline;
	filename=xfs-don-t-assert-on-delalloc-regions-beyond-eof.patch
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
To: xfs-dev@sgi.com, xfs@oss.sgi.com
Cc: Dave Chinner <dchinner@redhat.com>


From: Dave Chinner <dchinner@redhat.com>

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
---
 fs/xfs/xfs_bmap.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 26ab256..478bce9 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5620,8 +5620,20 @@ xfs_getbmap(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

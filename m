Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3357E7F52
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 00:46:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8F84AC005
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 22:46:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bZwXscHAyeT9X36n for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 22:45:59 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkpUd-0004Xw-9z
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 15:45:43 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkpUT-0003kX-6s
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 15:45:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/17] xfs: plug directory buffer readahead
Date: Fri,  7 Jun 2013 15:45:15 +1000
Message-Id: <1370583929-14276-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1370583929-14276-1-git-send-email-david@fromorbit.com>
References: <1370583929-14276-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Similar to bulkstat inode chunk readahead, we need to plug directory
data buffer readahead during getdents to ensure that we can merge
adjacent readahead requests and sort out of order requests optimally
before they are dispatched. This improves the readahead efficiency
and reduces the IO load it generates as the IO patterns are
significantly better for both contiguous and fragmented directories.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_leaf.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index da71a18..bb22aac 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1108,6 +1108,7 @@ xfs_dir2_leaf_readbuf(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_buf		*bp = *bpp;
 	struct xfs_bmbt_irec	*map = mip->map;
+	struct blk_plug		plug;
 	int			error = 0;
 	int			length;
 	int			i;
@@ -1236,6 +1237,7 @@ xfs_dir2_leaf_readbuf(
 	/*
 	 * Do we need more readahead?
 	 */
+	blk_start_plug(&plug);
 	for (mip->ra_index = mip->ra_offset = i = 0;
 	     mip->ra_want > mip->ra_current && i < mip->map_blocks;
 	     i += mp->m_dirblkfsbs) {
@@ -1287,6 +1289,7 @@ xfs_dir2_leaf_readbuf(
 			}
 		}
 	}
+	blk_finish_plug(&plug);
 
 out:
 	*bpp = bp;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

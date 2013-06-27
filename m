Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C462A7F74
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 01:05:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A0A69304051
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 23:05:16 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mmKPDQBc4y7EVy1W for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 23:05:15 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Us5KM-0008Gn-Gr
	for xfs@oss.sgi.com; Thu, 27 Jun 2013 16:05:06 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Us5KH-00027t-Dv
	for xfs@oss.sgi.com; Thu, 27 Jun 2013 16:05:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/15] xfs: plug directory buffer readahead
Date: Thu, 27 Jun 2013 16:04:47 +1000
Message-Id: <1372313099-8121-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1372313099-8121-1-git-send-email-david@fromorbit.com>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
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

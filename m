Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52pEJ134768 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:51 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	T8ACd2m46znuiAMN for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:37 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZp-0003Ez-Vh
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:29 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZf-0003c2-RA
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 011/102] xfs: XFS_TRANS_SWAPEXT is not a valid flag for
Date: Thu, 23 Aug 2012 15:01:29 +1000
Message-Id: <1345698180-13612-12-git-send-email-david@fromorbit.com>
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

Upstream commit: 815cb21662b914e1e14c256a3d662b1352c8509e
 xfs_trans_commit

XFS_TRANS_SWAPEXT is a transaction type, not a flag for xfs_trans_commit, so
don't pass it in xfs_swap_extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_dfrag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index 9a84a85..645387b 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -438,7 +438,7 @@ xfs_swap_extents(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(tp);
 
-	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
+	error = xfs_trans_commit(tp, 0);
 
 	trace_xfs_swap_extent_after(ip, 0);
 	trace_xfs_swap_extent_after(tip, 1);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

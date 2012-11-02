Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA20b9La064974 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 19:37:09 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Hl1156PnsJtkQL1b for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 17:39:00 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TU5Hl-0004WQ-Cq
	for xfs@oss.sgi.com; Fri, 02 Nov 2012 11:38:57 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TU5Hl-0000nS-8B
	for xfs@oss.sgi.com; Fri, 02 Nov 2012 11:38:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: don't vmap inode cluster buffers during free
Date: Fri,  2 Nov 2012 11:38:42 +1100
Message-Id: <1351816724-3000-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1351816724-3000-1-git-send-email-david@fromorbit.com>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
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

Inode buffers do not need to be mapped as inodes are read or written
directly from/to the pages underlying the buffer. This fixes a
regression introduced by commit 611c994 ("xfs: make XBF_MAPPED the
default behaviour").

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bba8f37..6a0a710 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1760,7 +1760,8 @@ xfs_ifree_cluster(
 		 * to mark all the active inodes on the buffer stale.
 		 */
 		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
-					mp->m_bsize * blks_per_cluster, 0);
+					mp->m_bsize * blks_per_cluster,
+					XBF_UNMAPPED);
 
 		if (!bp)
 			return ENOMEM;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

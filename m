Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKBPQp3151944 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 05:25:26 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vBAK47sxH2FAqPyB for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 03:27:35 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Talyz-000133-O3
	for xfs@oss.sgi.com; Tue, 20 Nov 2012 22:27:13 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Talyz-0005ub-K7
	for xfs@oss.sgi.com; Tue, 20 Nov 2012 22:27:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: inode allocation should use unmapped buffers.
Date: Tue, 20 Nov 2012 22:27:10 +1100
Message-Id: <1353410831-22653-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1353410831-22653-1-git-send-email-david@fromorbit.com>
References: <1353410831-22653-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_ialloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 2d6495e..a815412 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -200,7 +200,8 @@ xfs_ialloc_inode_init(
 		 */
 		d = XFS_AGB_TO_DADDR(mp, agno, agbno + (j * blks_per_cluster));
 		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-					 mp->m_bsize * blks_per_cluster, 0);
+					 mp->m_bsize * blks_per_cluster,
+					 XBF_UNMAPPED);
 		if (!fbuf)
 			return ENOMEM;
 		/*
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

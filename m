Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N558HJ136055 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:08 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fqctkBGa2jsTQCZB for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:54 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pbf-0003Jt-4n
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pbf-0003ib-2X
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 087/102] xfs: flush outstanding buffers on log mount failure
Date: Thu, 23 Aug 2012 15:02:45 +1000
Message-Id: <1345698180-13612-88-git-send-email-david@fromorbit.com>
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

Upstream commit: d4f3512b0891658b6b4d5fc99567242b3fc2d6b7

When we fail to mount the log in xfs_mountfs(), we tear down all the
infrastructure we have already allocated. However, the process of
mounting the log may have progressed to the point of reading,
caching and modifying buffers in memory. Hence before we can free
all the infrastructure, we have to flush and remove all the buffers
from memory.

Problem first reported by Eric Sandeen, later a different incarnation
was reported by Ben Myers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_mount.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2f011fd..beb9968 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1297,7 +1297,7 @@ xfs_mountfs(
 			      XFS_FSB_TO_BB(mp, sbp->sb_logblocks));
 	if (error) {
 		xfs_warn(mp, "log mount failed");
-		goto out_free_perag;
+		goto out_fail_wait;
 	}
 
 	/*
@@ -1324,7 +1324,7 @@ xfs_mountfs(
 	     !mp->m_sb.sb_inprogress) {
 		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
 		if (error)
-			goto out_free_perag;
+			goto out_fail_wait;
 	}
 
 	/*
@@ -1448,6 +1448,10 @@ xfs_mountfs(
 	IRELE(rip);
  out_log_dealloc:
 	xfs_log_unmount(mp);
+ out_fail_wait:
+	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
+		xfs_wait_buftarg(mp->m_logdev_targp);
+	xfs_wait_buftarg(mp->m_ddev_targp);
  out_free_perag:
 	xfs_free_perag(mp);
  out_remove_uuid:
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

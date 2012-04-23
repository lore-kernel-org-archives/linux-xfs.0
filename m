Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xvWE127770 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:57 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	rHoPeON8hvZEhYGq for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:55 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCJU-0001bx-BJ
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:52 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCJP-0004ZC-72
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 36/37] xfs: flush outstanding buffers on log mount failure
Date: Mon, 23 Apr 2012 15:59:06 +1000
Message-Id: <1335160747-17254-37-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

When we fail to mount the log in xfs_mountfs(), we tear down all the
infrastructure we have already allocated. However, the process of
mounting the log may have progressed to the point of reading,
caching and modifying buffers in memory. Hence before we can free
all the infrastructure, we have to flush and remove all the buffers
from memory.

Problem first reported by Eric Sandeen, later a different incarnation
was reported by Ben Myers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6698e0d..b09a4a7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1288,7 +1288,7 @@ xfs_mountfs(
 			      XFS_FSB_TO_BB(mp, sbp->sb_logblocks));
 	if (error) {
 		xfs_warn(mp, "log mount failed");
-		goto out_free_perag;
+		goto out_fail_wait;
 	}
 
 	/*
@@ -1315,7 +1315,7 @@ xfs_mountfs(
 	     !mp->m_sb.sb_inprogress) {
 		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
 		if (error)
-			goto out_free_perag;
+			goto out_fail_wait;
 	}
 
 	/*
@@ -1439,6 +1439,10 @@ xfs_mountfs(
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
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

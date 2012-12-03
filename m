Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NegGZ067714 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:43 -0600
Message-Id: <20121203144311.221176799@sgi.com>
Date: Mon, 03 Dec 2012 17:42:34 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 26/36] xfs: flush outstanding buffers on log mount
	failure
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=087
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

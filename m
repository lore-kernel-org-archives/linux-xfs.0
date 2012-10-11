Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9B8WUIS071623 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 03:32:30 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id h9nPl4e2ete5ZHWn for
	<xfs@oss.sgi.com>; Thu, 11 Oct 2012 01:34:02 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2] xfs: avoid underflow in xfs_ioc_trim()
Date: Thu, 11 Oct 2012 10:33:52 +0200
Message-Id: <1349944432-13776-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

Currently if len argument in xfs_ioc_trim() is smaller than one FSB
the 'end' variable underflow. Avoid that by returning EINVAL when
range is smaller than FSB.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: reworked, return EINVAL if len < FSB

 fs/xfs/xfs_discard.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 69cf4fc..04ddbbb 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -180,7 +180,8 @@ xfs_ioc_trim(
 	 * matter as trimming blocks is an advisory interface.
 	 */
 	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
-	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)))
+	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)) ||
+	    range.len < XFS_FSB_TO_B(mp, 1))
 		return -XFS_ERROR(EINVAL);
 
 	start = BTOBB(range.start);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

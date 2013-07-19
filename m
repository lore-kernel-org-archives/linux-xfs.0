Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A4F47F77
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF75E8F8033
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	LEiPD6UYo35JUBro for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:36 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-00048N-Du
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-000208-Cg
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 42/49] xfs: Validate log space at mount time
Date: Fri, 19 Jul 2013 16:25:13 +1000
Message-Id: <1374215120-7271-43-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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

From: Jie Liu <jeff.liu@oracle.com>

Validate log space during log mount stage, the underlying function
will drop a warning message via syslog in critical level if the log
space is too small or too large.

[ dchinner: For CRC enable filesystems, abort the mounting of the
filesystem as mkfs should never make a log too small for the given
filesystem configuration. ]

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b02415b..64b1f01 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -614,7 +614,9 @@ xfs_log_mount(
 	xfs_daddr_t	blk_offset,
 	int		num_bblks)
 {
-	int		error;
+	int		error = 0;
+	int		min_logfsbs;
+	int		max_logfsbs;
 
 	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY))
 		xfs_notice(mp, "Mounting Filesystem");
@@ -631,6 +633,51 @@ xfs_log_mount(
 	}
 
 	/*
+	 * Validate the given log space and drop a critical message via syslog
+	 * if the log size is too small that would lead to some unexpected
+	 * situations in transaction log space reservation stage.
+	 *
+	 * Note: we can't just reject the mount if the validation fails.  This
+	 * would mean that people would have to downgrade their kernel just to
+	 * remedy the situation as there is no way to grow the log (short of
+	 * black magic surgery with xfs_db).
+	 *
+	 * We can, however, reject mounts for CRC format filesystems, as the
+	 * mkfs binary being used to make the filesystem should never create a
+	 * filesystem with a log that is too small.
+	 */
+	min_logfsbs = xfs_log_calc_minimum_size(mp);
+	max_logfsbs = XFS_BB_TO_FSB(mp, XFS_MAX_LOG_BLOCKS);
+
+	if (mp->m_sb.sb_logblocks < min_logfsbs) {
+		xfs_warn(mp,
+		"Log size %d blocks too small, minimum size is %d blocks",
+			 mp->m_sb.sb_logblocks, min_logfsbs);
+		error = EINVAL;
+	} else if (mp->m_sb.sb_logblocks > max_logfsbs) {
+		xfs_warn(mp,
+		"Log size %d blocks too large, maximum size is %d blocks",
+			 mp->m_sb.sb_logblocks, max_logfsbs);
+		error = EINVAL;
+	} else if (XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks) > XFS_MAX_LOG_BYTES) {
+		xfs_warn(mp,
+		"log size %lld bytes too large, maximum size is %lld bytes",
+			 XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks),
+			 XFS_MAX_LOG_BYTES);
+		error = EINVAL;
+	}
+	if (error) {
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			xfs_crit(mp, "AAIEEE! Log failed size checks. Abort!");
+			ASSERT(0);
+			goto out_free_log;
+		}
+		xfs_crit(mp,
+"Log size out of supported range. Continuing onwards, but if log hangs are\n"
+"experienced then please report this message in the bug report.");
+	}
+
+	/*
 	 * Initialize the AIL now we have a log.
 	 */
 	error = xfs_trans_ail_init(mp);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

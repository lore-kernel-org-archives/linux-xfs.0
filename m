Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 607307F56
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 450BC8F8049
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:45 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UmSt82C5gAR7qOZQ for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:43 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004Yd-Qj
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:16 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-00063p-G9
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 42/50] xfs: Validate log space at
	mount time
Date: Mon, 12 Aug 2013 20:50:03 +1000
Message-Id: <1376304611-22994-43-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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

[ dchinner: make a note of the fact that the log size limits in
block counts are in units of filesystem blocks, not basic blocks. ]

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fs.h  |  4 +++-
 fs/xfs/xfs_log.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 74b24b2..53e33c2 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -240,7 +240,9 @@ typedef struct xfs_fsop_resblks {
 
 
 /*
- * Minimum and maximum sizes need for growth checks
+ * Minimum and maximum sizes need for growth checks.
+ *
+ * Block counts are in units of filesystem blocks, not basic blocks.
  */
 #define XFS_MIN_AG_BLOCKS	64
 #define XFS_MIN_LOG_BLOCKS	512ULL
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 704f095..b5703cc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -614,7 +614,8 @@ xfs_log_mount(
 	xfs_daddr_t	blk_offset,
 	int		num_bblks)
 {
-	int		error;
+	int		error = 0;
+	int		min_logfsbs;
 
 	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY))
 		xfs_notice(mp, "Mounting Filesystem");
@@ -631,6 +632,50 @@ xfs_log_mount(
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
+
+	if (mp->m_sb.sb_logblocks < min_logfsbs) {
+		xfs_warn(mp,
+		"Log size %d blocks too small, minimum size is %d blocks",
+			 mp->m_sb.sb_logblocks, min_logfsbs);
+		error = EINVAL;
+	} else if (mp->m_sb.sb_logblocks > XFS_MAX_LOG_BLOCKS) {
+		xfs_warn(mp,
+		"Log size %d blocks too large, maximum size is %lld blocks",
+			 mp->m_sb.sb_logblocks, XFS_MAX_LOG_BLOCKS);
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

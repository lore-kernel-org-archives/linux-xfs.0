Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E3CF17F51
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 13:15:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1338304048
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 11:15:18 -0700 (PDT)
Received: from smtprelay.hostedemail.com (smtprelay0089.hostedemail.com
	[216.40.44.89]) by cuda.sgi.com with ESMTP id 6E8nBYgFY6Gnvp5V
	for <xfs@oss.sgi.com>; Wed, 08 Jul 2015 11:15:15 -0700 (PDT)
Message-ID: <1436379312.2682.90.camel@perches.com>
Subject: [PATCH] xfs: Use consistent logging message prefixes
From: Joe Perches <joe@perches.com>
Date: Wed, 08 Jul 2015 11:15:12 -0700
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

The second and subsequent lines of multi-line logging messages
are not prefixed with the same information as the first line.

Separate messages with newlines into multiple calls to ensure
consistent prefixing and allow easier grep use.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c |  3 +--
 fs/xfs/libxfs/xfs_sb.c        | 14 +++++++-----
 fs/xfs/xfs_buf.c              |  5 +++--
 fs/xfs/xfs_log.c              | 50 +++++++++++++++++++++----------------------
 fs/xfs/xfs_log_recover.c      |  8 ++++---
 5 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 41b80d3..d68326a 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1845,8 +1845,7 @@ xfs_dir2_node_addname_int(
 
 			if (dp->d_ops->db_to_fdb(args->geo, dbno) != fbno) {
 				xfs_alert(mp,
-			"%s: dir ino %llu needed freesp block %lld for\n"
-			"  data block %lld, got %lld ifbno %llu lastfbno %d",
+"%s: dir ino %llu needed freesp block %lld for data block %lld, got %lld ifbno %llu lastfbno %d",
 					__func__, (unsigned long long)dp->i_ino,
 					(long long)dp->d_ops->db_to_fdb(
 								args->geo, dbno),
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index df9851c..a3f4504 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -131,10 +131,11 @@ xfs_mount_validate_sb(
 		if (xfs_sb_has_compat_feature(sbp,
 					XFS_SB_FEAT_COMPAT_UNKNOWN)) {
 			xfs_warn(mp,
-"Superblock has unknown compatible features (0x%x) enabled.\n"
-"Using a more recent kernel is recommended.",
+"Superblock has unknown compatible features (0x%x) enabled.",
 				(sbp->sb_features_compat &
 						XFS_SB_FEAT_COMPAT_UNKNOWN));
+			xfs_warn(mp,
+"Using a more recent kernel is recommended.");
 		}
 
 		if (xfs_sb_has_ro_compat_feature(sbp,
@@ -145,18 +146,21 @@ xfs_mount_validate_sb(
 						XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
 			if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 				xfs_warn(mp,
-"Attempted to mount read-only compatible filesystem read-write.\n"
+"Attempted to mount read-only compatible filesystem read-write.");
+				xfs_warn(mp,
 "Filesystem can only be safely mounted read only.");
+
 				return -EINVAL;
 			}
 		}
 		if (xfs_sb_has_incompat_feature(sbp,
 					XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
 			xfs_warn(mp,
-"Superblock has unknown incompatible features (0x%x) enabled.\n"
-"Filesystem can not be safely mounted by this kernel.",
+"Superblock has unknown incompatible features (0x%x) enabled.",
 				(sbp->sb_features_incompat &
 						XFS_SB_FEAT_INCOMPAT_UNKNOWN));
+			xfs_warn(mp,
+"Filesystem can not be safely mounted by this kernel.");
 			return -EINVAL;
 		}
 	}
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a4b7d92..d7dbd81 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1533,9 +1533,10 @@ xfs_wait_buftarg(
 			list_del_init(&bp->b_lru);
 			if (bp->b_flags & XBF_WRITE_FAIL) {
 				xfs_alert(btp->bt_mount,
-"Corruption Alert: Buffer at block 0x%llx had permanent write failures!\n"
-"Please run xfs_repair to determine the extent of the problem.",
+"Corruption Alert: Buffer at block 0x%llx had permanent write failures!",
 					(long long)bp->b_bn);
+				xfs_alert(btp->bt_mount,
+"Please run xfs_repair to determine the extent of the problem.");
 			}
 			xfs_buf_rele(bp);
 		}
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 08d4fe4..6b5a84a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -668,9 +668,9 @@ xfs_log_mount(
 			ASSERT(0);
 			goto out_free_log;
 		}
+		xfs_crit(mp, "Log size out of supported range.");
 		xfs_crit(mp,
-"Log size out of supported range. Continuing onwards, but if log hangs are\n"
-"experienced then please report this message in the bug report.");
+"Continuing onwards, but if log hangs are experienced then please report this message in the bug report.");
 	}
 
 	/*
@@ -1142,11 +1142,13 @@ xlog_space_left(
 		 * In this case we just want to return the size of the
 		 * log as the amount of space left.
 		 */
+		xfs_alert(log->l_mp, "xlog_space_left: head behind tail");
 		xfs_alert(log->l_mp,
-			"xlog_space_left: head behind tail\n"
-			"  tail_cycle = %d, tail_bytes = %d\n"
-			"  GH   cycle = %d, GH   bytes = %d",
-			tail_cycle, tail_bytes, head_cycle, head_bytes);
+			  "  tail_cycle = %d, tail_bytes = %d",
+			  tail_cycle, tail_bytes);
+		xfs_alert(log->l_mp,
+			  "  GH   cycle = %d, GH   bytes = %d",
+			  head_cycle, head_bytes);
 		ASSERT(0);
 		free_bytes = log->l_logsize;
 	}
@@ -2028,26 +2030,24 @@ xlog_print_tic_res(
 	    "SWAPEXT"
 	};
 
-	xfs_warn(mp,
-		"xlog_write: reservation summary:\n"
-		"  trans type  = %s (%u)\n"
-		"  unit res    = %d bytes\n"
-		"  current res = %d bytes\n"
-		"  total reg   = %u bytes (o/flow = %u bytes)\n"
-		"  ophdrs      = %u (ophdr space = %u bytes)\n"
-		"  ophdr + reg = %u bytes\n"
-		"  num regions = %u",
-		((ticket->t_trans_type <= 0 ||
-		  ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
+	xfs_warn(mp, "xlog_write: reservation summary:");
+	xfs_warn(mp, "  trans type  = %s (%u)",
+		 ((ticket->t_trans_type <= 0 ||
+		   ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
 		  "bad-trans-type" : trans_type_str[ticket->t_trans_type-1]),
-		ticket->t_trans_type,
-		ticket->t_unit_res,
-		ticket->t_curr_res,
-		ticket->t_res_arr_sum, ticket->t_res_o_flow,
-		ticket->t_res_num_ophdrs, ophdr_spc,
-		ticket->t_res_arr_sum +
-		ticket->t_res_o_flow + ophdr_spc,
-		ticket->t_res_num);
+		 ticket->t_trans_type);
+	xfs_warn(mp, "  unit res    = %d bytes",
+		 ticket->t_unit_res);
+	xfs_warn(mp, "  current res = %d bytes",
+		 ticket->t_curr_res);
+	xfs_warn(mp, "  total reg   = %u bytes (o/flow = %u bytes)",
+		 ticket->t_res_arr_sum, ticket->t_res_o_flow);
+	xfs_warn(mp, "  ophdrs      = %u (ophdr space = %u bytes)",
+		 ticket->t_res_num_ophdrs, ophdr_spc);
+	xfs_warn(mp, "  ophdr + reg = %u bytes",
+		 ticket->t_res_arr_sum + ticket->t_res_o_flow + ophdr_spc);
+	xfs_warn(mp, "  num regions = %u",
+		 ticket->t_res_num);
 
 	for (i = 0; i < ticket->t_res_num; i++) {
 		uint r_type = ticket->t_res_arr[i].r_type;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 01dd228..c2c9b4e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4527,11 +4527,13 @@ xlog_recover(
 		    xfs_sb_has_incompat_log_feature(&log->l_mp->m_sb,
 					XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN)) {
 			xfs_warn(log->l_mp,
-"Superblock has unknown incompatible log features (0x%x) enabled.\n"
-"The log can not be fully and/or safely recovered by this kernel.\n"
-"Please recover the log on a kernel that supports the unknown features.",
+"Superblock has unknown incompatible log features (0x%x) enabled.",
 				(log->l_mp->m_sb.sb_features_log_incompat &
 					XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
+			xfs_warn(log->l_mp,
+"The log can not be fully and/or safely recovered by this kernel.");
+			xfs_warn(log->l_mp,
+"Please recover the log on a kernel that supports the unknown features.");
 			return -EINVAL;
 		}
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

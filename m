Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C2E357F5A
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:59:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B03C68F8071
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 03:59:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	lskMbVE7RlyZBzte for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 03:59:38 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YaMYY-0002sb-49
	for xfs@oss.sgi.com; Tue, 24 Mar 2015 21:59:34 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YaMYY-00013H-2l
	for xfs@oss.sgi.com; Tue, 24 Mar 2015 21:59:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] xfs: make xfs_cross_rename() complete fully
Date: Tue, 24 Mar 2015 21:59:30 +1100
Message-Id: <1427194771-3105-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194771-3105-1-git-send-email-david@fromorbit.com>
References: <1427194771-3105-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Now that xfs_finish_rename() exists, there is no reason for
xfs_cross_rename() to return to xfs_rename() to finish off the
rename transaction. Drive the completion code into
xfs_cross_rename() and handle all errors there so as to simplify
the xfs_rename() code.

Further, push the rename exchange target_ip check to early in the
rename code so as to make the error handling easy and obviously
correct.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 45 +++++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4a13a48..1ea05be 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2769,14 +2769,14 @@ xfs_cross_rename(
 				ip2->i_ino,
 				first_block, free_list, spaceres);
 	if (error)
-		goto out;
+		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
 	error = xfs_dir_replace(tp, dp2, name2,
 				ip1->i_ino,
 				first_block, free_list, spaceres);
 	if (error)
-		goto out;
+		goto out_trans_abort;
 
 	/*
 	 * If we're renaming one or more directories across different parents,
@@ -2791,16 +2791,16 @@ xfs_cross_rename(
 						dp1->i_ino, first_block,
 						free_list, spaceres);
 			if (error)
-				goto out;
+				goto out_trans_abort;
 
 			/* transfer ip2 ".." reference to dp1 */
 			if (!S_ISDIR(ip1->i_d.di_mode)) {
 				error = xfs_droplink(tp, dp2);
 				if (error)
-					goto out;
+					goto out_trans_abort;
 				error = xfs_bumplink(tp, dp1);
 				if (error)
-					goto out;
+					goto out_trans_abort;
 			}
 
 			/*
@@ -2818,16 +2818,16 @@ xfs_cross_rename(
 						dp2->i_ino, first_block,
 						free_list, spaceres);
 			if (error)
-				goto out;
+				goto out_trans_abort;
 
 			/* transfer ip1 ".." reference to dp2 */
 			if (!S_ISDIR(ip2->i_d.di_mode)) {
 				error = xfs_droplink(tp, dp1);
 				if (error)
-					goto out;
+					goto out_trans_abort;
 				error = xfs_bumplink(tp, dp2);
 				if (error)
-					goto out;
+					goto out_trans_abort;
 			}
 
 			/*
@@ -2855,7 +2855,11 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
-out:
+	return xfs_finish_rename(tp, free_list);
+
+out_trans_abort:
+	xfs_bmap_cancel(free_list);
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	return error;
 }
 
@@ -2886,6 +2890,9 @@ xfs_rename(
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
+	if ((flags & RENAME_EXCHANGE) && !target_ip)
+		return -EINVAL;
+
 	new_parent = (src_dp != target_dp);
 	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
 
@@ -2943,21 +2950,11 @@ xfs_rename(
 
 	xfs_bmap_init(&free_list, &first_block);
 
-	/*
-	 * Handle RENAME_EXCHANGE flags
-	 */
-	if (flags & RENAME_EXCHANGE) {
-		if (target_ip == NULL) {
-			error = -EINVAL;
-			goto out_trans_cancel;
-		}
-		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
-					 target_dp, target_name, target_ip,
-					 &free_list, &first_block, spaceres);
-		if (error)
-			goto out_trans_abort;
-		return xfs_finish_rename(tp, &free_list);
-	}
+	/* RENAME_EXCHANGE is unique from here on. */
+	if (flags & RENAME_EXCHANGE)
+		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+					target_dp, target_name, target_ip,
+					&free_list, &first_block, spaceres);
 
 	/*
 	 * Set up the target.
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

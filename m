Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2075C7F5A
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:59:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E25D8F8071
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 03:59:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pTtKkH9Dsm3U8aQt for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 03:59:38 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YaMYY-0002sZ-2a
	for xfs@oss.sgi.com; Tue, 24 Mar 2015 21:59:34 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YaMYY-000137-1X
	for xfs@oss.sgi.com; Tue, 24 Mar 2015 21:59:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: cleanup xfs_rename error handling
Date: Tue, 24 Mar 2015 21:59:28 +1100
Message-Id: <1427194771-3105-3-git-send-email-david@fromorbit.com>
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

The jump labels are ambiguous and unclear and some of the error
paths are used inconsistently. Rules for error jumps are:

- use out_trans_cancel for unmodified transaction context
- use out_bmap_cancel on ENOSPC errors
- use out_trans_abort when transaction is likely to be dirty.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 61 ++++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e38bc40..981e036 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2854,7 +2854,7 @@ xfs_rename(
 	int		error;
 	xfs_bmap_free_t free_list;
 	xfs_fsblock_t   first_block;
-	int		cancel_flags;
+	int		cancel_flags = 0;
 	int		committed;
 	xfs_inode_t	*inodes[__XFS_SORT_INODES];
 	int		num_inodes = __XFS_SORT_INODES;
@@ -2868,28 +2868,23 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, NULL,
 				inodes, &num_inodes);
 
-	xfs_bmap_init(&free_list, &first_block);
 	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
-	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
 	if (error == -ENOSPC) {
 		spaceres = 0;
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
 	}
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		goto std_return;
-	}
+	if (error)
+		goto out_trans_cancel;
+	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 
 	/*
 	 * Attach the dquots to the inodes
 	 */
 	error = xfs_qm_vop_rename_dqattach(inodes);
-	if (error) {
-		xfs_trans_cancel(tp, cancel_flags);
-		goto std_return;
-	}
+	if (error)
+		goto out_trans_cancel;
 
 	/*
 	 * Lock all the participating inodes. Depending upon whether
@@ -2919,22 +2914,24 @@ xfs_rename(
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
 		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
 		error = -EXDEV;
-		goto error_return;
+		goto out_trans_cancel;
 	}
 
+	xfs_bmap_init(&free_list, &first_block);
+
 	/*
 	 * Handle RENAME_EXCHANGE flags
 	 */
 	if (flags & RENAME_EXCHANGE) {
 		if (target_ip == NULL) {
 			error = -EINVAL;
-			goto error_return;
+			goto out_trans_cancel;
 		}
 		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					 target_dp, target_name, target_ip,
 					 &free_list, &first_block, spaceres);
 		if (error)
-			goto abort_return;
+			goto out_trans_abort;
 		goto finish_rename;
 	}
 
@@ -2949,7 +2946,7 @@ xfs_rename(
 		if (!spaceres) {
 			error = xfs_dir_canenter(tp, target_dp, target_name);
 			if (error)
-				goto error_return;
+				goto out_trans_cancel;
 		}
 		/*
 		 * If target does not exist and the rename crosses
@@ -2960,9 +2957,9 @@ xfs_rename(
 						src_ip->i_ino, &first_block,
 						&free_list, spaceres);
 		if (error == -ENOSPC)
-			goto error_return;
+			goto out_bmap_cancel;
 		if (error)
-			goto abort_return;
+			goto out_trans_abort;
 
 		xfs_trans_ichgtime(tp, target_dp,
 					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -2970,7 +2967,7 @@ xfs_rename(
 		if (new_parent && src_is_directory) {
 			error = xfs_bumplink(tp, target_dp);
 			if (error)
-				goto abort_return;
+				goto out_trans_abort;
 		}
 	} else { /* target_ip != NULL */
 		/*
@@ -2985,7 +2982,7 @@ xfs_rename(
 			if (!(xfs_dir_isempty(target_ip)) ||
 			    (target_ip->i_d.di_nlink > 2)) {
 				error = -EEXIST;
-				goto error_return;
+				goto out_trans_cancel;
 			}
 		}
 
@@ -3002,7 +2999,7 @@ xfs_rename(
 					src_ip->i_ino,
 					&first_block, &free_list, spaceres);
 		if (error)
-			goto abort_return;
+			goto out_trans_abort;
 
 		xfs_trans_ichgtime(tp, target_dp,
 					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -3013,7 +3010,7 @@ xfs_rename(
 		 */
 		error = xfs_droplink(tp, target_ip);
 		if (error)
-			goto abort_return;
+			goto out_trans_abort;
 
 		if (src_is_directory) {
 			/*
@@ -3021,7 +3018,7 @@ xfs_rename(
 			 */
 			error = xfs_droplink(tp, target_ip);
 			if (error)
-				goto abort_return;
+				goto out_trans_abort;
 		}
 	} /* target_ip != NULL */
 
@@ -3038,7 +3035,7 @@ xfs_rename(
 					&first_block, &free_list, spaceres);
 		ASSERT(error != -EEXIST);
 		if (error)
-			goto abort_return;
+			goto out_trans_abort;
 	}
 
 	/*
@@ -3064,13 +3061,13 @@ xfs_rename(
 		 */
 		error = xfs_droplink(tp, src_dp);
 		if (error)
-			goto abort_return;
+			goto out_trans_abort;
 	}
 
 	error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					&first_block, &free_list, spaceres);
 	if (error)
-		goto abort_return;
+		goto out_trans_abort;
 
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
@@ -3088,12 +3085,8 @@ finish_rename:
 	}
 
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
-	if (error) {
-		xfs_bmap_cancel(&free_list);
-		xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES |
-				 XFS_TRANS_ABORT));
-		goto std_return;
-	}
+	if (error)
+		goto out_trans_abort;
 
 	/*
 	 * trans_commit will unlock src_ip, target_ip & decrement
@@ -3101,12 +3094,12 @@ finish_rename:
 	 */
 	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 
- abort_return:
+out_trans_abort:
 	cancel_flags |= XFS_TRANS_ABORT;
- error_return:
+out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
+out_trans_cancel:
 	xfs_trans_cancel(tp, cancel_flags);
- std_return:
 	return error;
 }
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

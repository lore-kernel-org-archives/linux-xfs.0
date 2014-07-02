Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7FA557F63
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 09:52:22 -0500 (CDT)
Received: from eagdhcp-232-174.americas.sgi.com
	(eagdhcp-232-174.americas.sgi.com [128.162.232.174])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D0AA304071
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 07:52:19 -0700 (PDT)
Received: from eagdhcp-232-174.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-174.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s62EqF4a005633
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2014 09:52:15 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-174.americas.sgi.com)
Message-Id: <20140702144139.790241031@sgi.com>
Date: Wed, 02 Jul 2014 09:32:09 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 3/5] xfs: free the list of recovery items on error
References: <20140702143206.438456679@sgi.com>
Content-Disposition: inline; filename=xfs-fix-log-recovery-leaks.patch
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

Recovery builds a list of items on the transaction's
r_itemq head. Normally these items are committed and freed.
But in the event of a recovery error, these allocations
are leaked.

If the error occurs during item reordering, then reconstruct
the r_itemq list before deleting the list to avoid leaking
the entries that were on one of the temporary lists.

Fix potential use-after-free of the trans structure by ensuring
they are removed from the transaction recoovery-in-progress hash
table before they are freed.

History:
 My first version corrected the xlog_recover_free_trans for
 the error path of xlog_recover_commit_trans.

 Dave Chinner removed most of the XFS_ERROR(), changed messages
 in xlog_recover_process_data and pushed the xlog_recover_free_trans
 calls into the lower layers.

 This has all those patches plus suggestions from Christoph Hellwig.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log_recover.c |   88 ++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 43 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -539,7 +539,7 @@ xlog_find_verify_log_record(
 			xfs_warn(log->l_mp,
 		"Log inconsistent (didn't find previous header)");
 			ASSERT(0);
-			error = XFS_ERROR(EIO);
+			error = EIO;
 			goto out;
 		}
 
@@ -961,7 +961,7 @@ xlog_find_tail(
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
 		xlog_put_bp(bp);
 		ASSERT(0);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	/* find blk_no of tail of log */
@@ -1551,7 +1551,7 @@ xlog_recover_add_to_trans(
 			xfs_warn(log->l_mp, "%s: bad header magic number",
 				__func__);
 			ASSERT(0);
-			return XFS_ERROR(EIO);
+			return EIO;
 		}
 		if (len == sizeof(xfs_trans_header_t))
 			xlog_recover_add_item(&trans->r_itemq);
@@ -1581,7 +1581,7 @@ xlog_recover_add_to_trans(
 				  in_f->ilf_size);
 			ASSERT(0);
 			kmem_free(ptr);
-			return XFS_ERROR(EIO);
+			return EIO;
 		}
 
 		item->ri_total = in_f->ilf_size;
@@ -1702,7 +1702,7 @@ xlog_recover_reorder_trans(
 			 */
 			if (!list_empty(&sort_list))
 				list_splice_init(&sort_list, &trans->r_itemq);
-			error = XFS_ERROR(EIO);
+			error = EIO;
 			goto out;
 		}
 	}
@@ -3395,7 +3395,7 @@ xlog_recover_commit_pass1(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 }
 
@@ -3431,7 +3431,7 @@ xlog_recover_commit_pass2(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 }
 
@@ -3478,7 +3478,7 @@ xlog_recover_commit_trans(
 
 	#define XLOG_RECOVER_COMMIT_QUEUE_MAX 100
 
-	hlist_del(&trans->r_list);
+	hlist_del_init(&trans->r_list);
 
 	error = xlog_recover_reorder_trans(log, trans, pass);
 	if (error)
@@ -3503,13 +3503,14 @@ xlog_recover_commit_trans(
 			break;
 		default:
 			ASSERT(0);
+			error = ERANGE;
+			break;
 		}
 
 		if (error)
-			goto out;
+			break;
 	}
 
-out:
 	if (!list_empty(&ra_list)) {
 		if (!error)
 			error = xlog_recover_items_pass2(log, trans,
@@ -3520,21 +3521,10 @@ out:
 	if (!list_empty(&done_list))
 		list_splice_init(&done_list, &trans->r_itemq);
 
-	xlog_recover_free_trans(trans);
-
 	error2 = xfs_buf_delwri_submit(&buffer_list);
 	return error ? error : error2;
 }
 
-STATIC int
-xlog_recover_unmount_trans(
-	struct xlog		*log)
-{
-	/* Do nothing now */
-	xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
-	return 0;
-}
-
 /*
  * There are two valid states of the r_state field.  0 indicates that the
  * transaction structure is in a normal state.  We have either seen the
@@ -3555,9 +3545,9 @@ xlog_recover_process_data(
 	xfs_caddr_t		lp;
 	int			num_logops;
 	xlog_op_header_t	*ohead;
-	xlog_recover_t		*trans;
+	xlog_recover_t		*trans = NULL;
 	xlog_tid_t		tid;
-	int			error;
+	int			error = 0;
 	unsigned long		hash;
 	uint			flags;
 
@@ -3566,7 +3556,7 @@ xlog_recover_process_data(
 
 	/* check the log format matches our own - else we can't recover */
 	if (xlog_header_check_recover(log->l_mp, rhead))
-		return (XFS_ERROR(EIO));
+		return XFS_ERROR(EIO);
 
 	while ((dp < lp) && num_logops) {
 		ASSERT(dp + sizeof(xlog_op_header_t) <= lp);
@@ -3574,10 +3564,12 @@ xlog_recover_process_data(
 		dp += sizeof(xlog_op_header_t);
 		if (ohead->oh_clientid != XFS_TRANSACTION &&
 		    ohead->oh_clientid != XFS_LOG) {
-			xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
+			xfs_warn(log->l_mp,
+			      "%s: bad bad transaction opheader clientid 0x%x",
 					__func__, ohead->oh_clientid);
 			ASSERT(0);
-			return (XFS_ERROR(EIO));
+			error = EIO;
+			goto out_error;
 		}
 		tid = be32_to_cpu(ohead->oh_tid);
 		hash = XLOG_RHASH(tid);
@@ -3588,10 +3580,12 @@ xlog_recover_process_data(
 					be64_to_cpu(rhead->h_lsn));
 		} else {
 			if (dp + be32_to_cpu(ohead->oh_len) > lp) {
-				xfs_warn(log->l_mp, "%s: bad length 0x%x",
+				xfs_warn(log->l_mp,
+			      "%s: bad bad transaction opheader length 0x%x",
 					__func__, be32_to_cpu(ohead->oh_len));
 				WARN_ON(1);
-				return (XFS_ERROR(EIO));
+				error = XFS_ERROR(EIO);
+				goto out_error;
 			}
 			flags = ohead->oh_flags & ~XLOG_END_TRANS;
 			if (flags & XLOG_WAS_CONT_TRANS)
@@ -3600,42 +3594,50 @@ xlog_recover_process_data(
 			case XLOG_COMMIT_TRANS:
 				error = xlog_recover_commit_trans(log,
 								trans, pass);
-				break;
-			case XLOG_UNMOUNT_TRANS:
-				error = xlog_recover_unmount_trans(log);
+				if (error)
+					goto out_error;
+				/*
+				 * xlog_recover_commit_trans removed the trans
+				 * structure from the hash, so nobody else will
+				 * ever find this structure again. Hence we
+				 * must free it here.
+				 */
+				xlog_recover_free_trans(trans);
 				break;
 			case XLOG_WAS_CONT_TRANS:
 				error = xlog_recover_add_to_cont_trans(log,
 						trans, dp,
 						be32_to_cpu(ohead->oh_len));
 				break;
-			case XLOG_START_TRANS:
-				xfs_warn(log->l_mp, "%s: bad transaction",
-					__func__);
-				ASSERT(0);
-				error = XFS_ERROR(EIO);
-				break;
 			case 0:
 			case XLOG_CONTINUE_TRANS:
 				error = xlog_recover_add_to_trans(log, trans,
 						dp, be32_to_cpu(ohead->oh_len));
 				break;
+			case XLOG_UNMOUNT_TRANS:
+				xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
+				break;
+			case XLOG_START_TRANS:
 			default:
-				xfs_warn(log->l_mp, "%s: bad flag 0x%x",
+				xfs_warn(log->l_mp,
+			      "%s: bad bad transaction opheader flag 0x%x",
 					__func__, flags);
 				ASSERT(0);
-				error = XFS_ERROR(EIO);
+				error = EIO;
 				break;
 			}
-			if (error) {
-				xlog_recover_free_trans(trans);
-				return error;
-			}
+			if (error)
+				goto out_error;
 		}
 		dp += be32_to_cpu(ohead->oh_len);
 		num_logops--;
 	}
 	return 0;
+
+ out_error:
+	if (trans)
+		xlog_recover_free_trans(trans);
+	return error;
 }
 
 /*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1C7DA7F92
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 08:24:43 -0500 (CDT)
Received: from eagdhcp-232-155.americas.sgi.com
	(eagdhcp-232-155.americas.sgi.com [128.162.232.155])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5A8C304032
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 06:24:42 -0700 (PDT)
Received: from eagdhcp-232-155.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-155.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r92DOgck002411
	for <xfs@oss.sgi.com>; Wed, 2 Oct 2013 08:24:42 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-155.americas.sgi.com)
Message-Id: <20131002125409.930462395@sgi.com>
Date: Wed, 02 Oct 2013 07:51:12 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 2/2] xfs free the list of recovery items on error.
References: <20131002125110.745269864@sgi.com>
Content-Disposition: inline; filename=xfs-fix-leaked-xlog_recover_items.patch
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

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log_recover.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1659,6 +1659,7 @@ xlog_recover_reorder_trans(
 	int			pass)
 {
 	xlog_recover_item_t	*item, *n;
+	int			error = 0;
 	LIST_HEAD(sort_list);
 	LIST_HEAD(cancel_list);
 	LIST_HEAD(buffer_list);
@@ -1700,9 +1701,17 @@ xlog_recover_reorder_trans(
 				"%s: unrecognized type of log operation",
 				__func__);
 			ASSERT(0);
-			return XFS_ERROR(EIO);
+			/*
+			 * return the remaining items back to the transaction
+			 * item list so they can be freed in caller.
+			 */
+			if (!list_empty(&sort_list))
+				list_splice_init(&sort_list, &trans->r_itemq);
+			error = XFS_ERROR(EIO);
+			goto out;
 		}
 	}
+out:
 	ASSERT(list_empty(&sort_list));
 	if (!list_empty(&buffer_list))
 		list_splice(&buffer_list, &trans->r_itemq);
@@ -1712,7 +1721,7 @@ xlog_recover_reorder_trans(
 		list_splice_tail(&inode_buffer_list, &trans->r_itemq);
 	if (!list_empty(&cancel_list))
 		list_splice_tail(&cancel_list, &trans->r_itemq);
-	return 0;
+	return error;
 }
 
 /*
@@ -3743,8 +3752,10 @@ xlog_recover_process_data(
 				error = XFS_ERROR(EIO);
 				break;
 			}
-			if (error)
+			if (error) {
+				xlog_recover_free_trans(trans);
 				return error;
+			}
 		}
 		dp += be32_to_cpu(ohead->oh_len);
 		num_logops--;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

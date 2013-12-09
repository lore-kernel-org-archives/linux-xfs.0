Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1AAD97F3F
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 18:30:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AAB57AC002
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:30:10 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	eejDx3dW0Oyw4Rpa for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 16:29:54 -0800 (PST)
Date: Mon, 9 Dec 2013 11:29:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: fix double free on error when cleaning log items
Message-ID: <20131209002942.GM31386@dastard>
References: <20131206212027.846346746@sgi.com>
	<20131206212037.475868363@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206212037.475868363@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 03:20:28PM -0600, Mark Tinguely wrote:
> Commit 2a84108 cleans the remaining pending log item entries
> when log recovery fails. Unfortunately, the cleaning call was
> not removed from the error path in xlog_recover_commit_trans,
> This can result in a use after free and a second free of the
> transaction structure when the cleaning is done in
> xlog_recover_process_data.
> 
> Now the log item entry cleaning in xlog_recover_commit_trans
> is only performed for the non-error case.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  fs/xfs/xfs_log_recover.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: b/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3509,9 +3509,10 @@ out:
>  	if (!list_empty(&done_list))
>  		list_splice_init(&done_list, &trans->r_itemq);
>  
> -	xlog_recover_free_trans(trans);
> -
>  	error2 = xfs_buf_delwri_submit(&buffer_list);
> +	/* caller will free transactions in the error path */
> +	if (!error && !error2)
> +		xlog_recover_free_trans(trans);
>  	return error ? error : error2;
>  }

Mark, please stop and think about the problem being reported and
consider the wider context of it rather than just slapping band-aids
over the code that solve just the specific problem being reported.


Indeed, the above change doesn't take into account that the
transaction has already been removed from the hash by
xlog_recover_process_data(), and so it must always free the
transaction structure here regardless of whether it succeeds or not
as nobody else can ever find it by lookup.

Further, it doesn't take into account the fact that calling
xlog_recover_free_trans() without removing the transaction from the
recovery hash in the error paths leaves a vector for use-after-free
(and hence memory corruption) remaining behind. Hence the change in
2a84108 turned minor memory leaks into memory corruption vectors.

And finally, it misses the other error handling paths where
xlog_recover_process_data() leaks the trans structure that
it is working on....

So, let's go back to the "callee cleans up" semantics that were in
place before commit 2a84108 and fix all these problems in one go,
rather than slapping a bandaid on them one at a time as they are
reported.

Smoke tested patch to fix all this below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: xlog_recover_process_data leaks like a sieve

From: Dave Chinner <dchinner@redhat.com>

Fix the double free of the transaction structure introduced by
commit 2a84108 ("xfs: free the list of recovery items on error").
In the process, make the freeing of the trans structure on error or
completion of processing consistent - i.e. the responsibility of the
the function that detected the error or completes processing. Add
comments to document this behaviour so it can be maintained more
easily in future.

Fix the rest of the memory leaks of the transaction structure used
by xlog_recover_process_data() that commit 2a84108 didn't address.

Fix potential use-after-free of the trans structure by ensuring
they are removed from the transaction recovery-in-progress hash
table before they are freed.

Remove all the shouty XFS_ERROR() macros that are used directly
after ASSERT(0) calls as they are entirely redundant and make the
code harder to read.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 155 +++++++++++++++++++++++++++--------------------
 1 file changed, 88 insertions(+), 67 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 07ab52c..517f7ee 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1483,6 +1483,32 @@ xlog_recover_add_item(
 	list_add_tail(&item->ri_list, head);
 }
 
+/*
+ * Free up any resources allocated by the transaction
+ *
+ * Remember that EFIs, EFDs, and IUNLINKs are handled later.
+ */
+STATIC void
+xlog_recover_free_trans(
+	struct xlog_recover	*trans)
+{
+	xlog_recover_item_t	*item, *n;
+	int			i;
+
+	hlist_del_init(&trans->r_list);
+	list_for_each_entry_safe(item, n, &trans->r_itemq, ri_list) {
+		/* Free the regions in the item. */
+		list_del(&item->ri_list);
+		for (i = 0; i < item->ri_cnt; i++)
+			kmem_free(item->ri_buf[i].i_addr);
+		/* Free the item itself */
+		kmem_free(item->ri_buf);
+		kmem_free(item);
+	}
+	/* Free the transaction recover structure */
+	kmem_free(trans);
+}
+
 STATIC int
 xlog_recover_add_to_cont_trans(
 	struct xlog		*log,
@@ -1548,7 +1574,7 @@ xlog_recover_add_to_trans(
 			xfs_warn(log->l_mp, "%s: bad header magic number",
 				__func__);
 			ASSERT(0);
-			return XFS_ERROR(EIO);
+			goto out_eio;
 		}
 		if (len == sizeof(xfs_trans_header_t))
 			xlog_recover_add_item(&trans->r_itemq);
@@ -1577,8 +1603,8 @@ xlog_recover_add_to_trans(
 		"bad number of regions (%d) in inode log format",
 				  in_f->ilf_size);
 			ASSERT(0);
-			kmem_free(ptr);
-			return XFS_ERROR(EIO);
+			goto out_free_eio;
+
 		}
 
 		item->ri_total = in_f->ilf_size;
@@ -1593,6 +1619,17 @@ xlog_recover_add_to_trans(
 	item->ri_cnt++;
 	trace_xfs_log_recover_item_add(log, trans, item, 0);
 	return 0;
+
+out_free_eio:
+	kmem_free(ptr);
+out_eio:
+	/*
+	 * This transaction is now unrecoverable, so we need to remove it from
+	 * the transaction hash so nobody else can find it and free it.  The
+	 * error we return will abort further recovery processing.
+	 */
+	xlog_recover_free_trans(trans);
+	return EIO;
 }
 
 /*
@@ -1699,7 +1736,7 @@ xlog_recover_reorder_trans(
 			 */
 			if (!list_empty(&sort_list))
 				list_splice_init(&sort_list, &trans->r_itemq);
-			error = XFS_ERROR(EIO);
+			error = EIO;
 			goto out;
 		}
 	}
@@ -1713,6 +1750,15 @@ out:
 		list_splice_tail(&inode_buffer_list, &trans->r_itemq);
 	if (!list_empty(&cancel_list))
 		list_splice_tail(&cancel_list, &trans->r_itemq);
+
+	/*
+	 * If we failed to reorder the transaction, it is now unrecoverable so
+	 * we need to remove it from the transaction hash so nobody else can
+	 * find it and free it.  The error we return will abort further recovery
+	 * processing.
+	 */
+	if (error)
+		xlog_recover_free_trans(trans);
 	return error;
 }
 
@@ -3235,31 +3281,6 @@ xlog_recover_do_icreate_pass2(
 	return 0;
 }
 
-/*
- * Free up any resources allocated by the transaction
- *
- * Remember that EFIs, EFDs, and IUNLINKs are handled later.
- */
-STATIC void
-xlog_recover_free_trans(
-	struct xlog_recover	*trans)
-{
-	xlog_recover_item_t	*item, *n;
-	int			i;
-
-	list_for_each_entry_safe(item, n, &trans->r_itemq, ri_list) {
-		/* Free the regions in the item. */
-		list_del(&item->ri_list);
-		for (i = 0; i < item->ri_cnt; i++)
-			kmem_free(item->ri_buf[i].i_addr);
-		/* Free the item itself */
-		kmem_free(item->ri_buf);
-		kmem_free(item);
-	}
-	/* Free the transaction recover structure */
-	kmem_free(trans);
-}
-
 STATIC void
 xlog_recover_buffer_ra_pass2(
 	struct xlog                     *log,
@@ -3384,7 +3405,7 @@ xlog_recover_commit_pass1(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 }
 
@@ -3420,7 +3441,7 @@ xlog_recover_commit_pass2(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 }
 
@@ -3467,7 +3488,7 @@ xlog_recover_commit_trans(
 
 	#define XLOG_RECOVER_COMMIT_QUEUE_MAX 100
 
-	hlist_del(&trans->r_list);
+	hlist_del_init(&trans->r_list);
 
 	error = xlog_recover_reorder_trans(log, trans, pass);
 	if (error)
@@ -3488,17 +3509,17 @@ xlog_recover_commit_trans(
 				list_splice_tail_init(&ra_list, &done_list);
 				items_queued = 0;
 			}
-
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
@@ -3509,22 +3530,17 @@ out:
 	if (!list_empty(&done_list))
 		list_splice_init(&done_list, &trans->r_itemq);
 
+	/*
+	 * We've already removed the trans structure from the hash, so nobody
+	 * else will ever find this structure again. Hence we must free it here
+	 * regardless of whether we processed it successfully or not.
+	 */
 	xlog_recover_free_trans(trans);
 
 	error2 = xfs_buf_delwri_submit(&buffer_list);
 	return error ? error : error2;
 }
 
-STATIC int
-xlog_recover_unmount_trans(
-	struct xlog		*log,
-	struct xlog_recover	*trans)
-{
-	/* Do nothing now */
-	xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
-	return 0;
-}
-
 /*
  * There are two valid states of the r_state field.  0 indicates that the
  * transaction structure is in a normal state.  We have either seen the
@@ -3545,9 +3561,9 @@ xlog_recover_process_data(
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
 
@@ -3556,7 +3572,7 @@ xlog_recover_process_data(
 
 	/* check the log format matches our own - else we can't recover */
 	if (xlog_header_check_recover(log->l_mp, rhead))
-		return (XFS_ERROR(EIO));
+		return XFS_ERROR(EIO);
 
 	while ((dp < lp) && num_logops) {
 		ASSERT(dp + sizeof(xlog_op_header_t) <= lp);
@@ -3564,10 +3580,13 @@ xlog_recover_process_data(
 		dp += sizeof(xlog_op_header_t);
 		if (ohead->oh_clientid != XFS_TRANSACTION &&
 		    ohead->oh_clientid != XFS_LOG) {
-			xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
+			xfs_warn(log->l_mp,
+				"%s: bad transaction opheader clientid 0x%x",
 					__func__, ohead->oh_clientid);
 			ASSERT(0);
-			return (XFS_ERROR(EIO));
+			if (trans)
+				xlog_recover_free_trans(trans);
+			return EIO;
 		}
 		tid = be32_to_cpu(ohead->oh_tid);
 		hash = XLOG_RHASH(tid);
@@ -3578,11 +3597,14 @@ xlog_recover_process_data(
 					be64_to_cpu(rhead->h_lsn));
 		} else {
 			if (dp + be32_to_cpu(ohead->oh_len) > lp) {
-				xfs_warn(log->l_mp, "%s: bad length 0x%x",
+				xfs_warn(log->l_mp,
+				"%s: bad transaction opheader length 0x%x",
 					__func__, be32_to_cpu(ohead->oh_len));
 				WARN_ON(1);
-				return (XFS_ERROR(EIO));
+				xlog_recover_free_trans(trans);
+				return EIO;
 			}
+
 			flags = ohead->oh_flags & ~XLOG_END_TRANS;
 			if (flags & XLOG_WAS_CONT_TRANS)
 				flags &= ~XLOG_CONTINUE_TRANS;
@@ -3591,36 +3613,35 @@ xlog_recover_process_data(
 				error = xlog_recover_commit_trans(log,
 								trans, pass);
 				break;
-			case XLOG_UNMOUNT_TRANS:
-				error = xlog_recover_unmount_trans(log, trans);
-				break;
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
+				"%s: bad transaction opheader flag 0x%x",
 					__func__, flags);
 				ASSERT(0);
-				error = XFS_ERROR(EIO);
-				break;
-			}
-			if (error) {
 				xlog_recover_free_trans(trans);
-				return error;
+				return EIO;
 			}
+			/*
+			 * If there's been an error, the trans structure has
+			 * already been freed. So there's nothing for us to do
+			 * but abort the recovery process.
+			 */
+			if (error)
+				return error;
 		}
 		dp += be32_to_cpu(ohead->oh_len);
 		num_logops--;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21469 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752544AbdFZP4s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2017 11:56:48 -0400
Date: Mon, 26 Jun 2017 08:56:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: free uncommitted transactions during log recovery
Message-ID: <20170626155640.GG4733@birch.djwong.org>
References: <1497639397-15083-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497639397-15083-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 16, 2017 at 02:56:37PM -0400, Brian Foster wrote:
> Log recovery allocates in-core transaction and member item data
> structures on-demand as it processes the on-disk log. Transactions
> are allocated on first encounter on-disk and stored in a hash table
> structure where they are easily accessible for subsequent lookups.
> Transaction items are also allocated on demand and are attached to
> the associated transactions.
> 
> When a commit record is encountered in the log, the transaction is
> committed to the fs and the in-core structures are freed. If a
> filesystem crashes or shuts down before all in-core log buffers are
> flushed to the log, however, not all transactions may have commit
> records in the log. As expected, the modifications in such an
> incomplete transaction are not replayed to the fs. The in-core data
> structures for the partial transaction are never freed, however,
> resulting in a memory leak.
> 
> Update xlog_do_recovery_pass() to first correctly initialize the
> hash table array so empty lists can be distinguished from populated
> lists on function exit. Update xlog_recover_free_trans() to always
> remove the transaction from the list prior to freeing the associated
> memory. Finally, walk the hash table of transaction lists as the
> last step before it goes out of scope and free any transactions that
> may remain on the lists. This prevents a memory leak of partial
> transactions in the log.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> v2:
> - Initialize rhash[] properly to address xfs/051 bug.
> - Update xlog_recover_free_trans() to remove trans from list.
> v1: http://www.spinics.net/lists/linux-xfs/msg07516.html
> 
>  fs/xfs/xfs_log_recover.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 4a98762..4a4322b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4152,7 +4152,7 @@ xlog_recover_commit_trans(
>  
>  	#define XLOG_RECOVER_COMMIT_QUEUE_MAX 100
>  
> -	hlist_del(&trans->r_list);
> +	hlist_del_init(&trans->r_list);
>  
>  	error = xlog_recover_reorder_trans(log, trans, pass);
>  	if (error)
> @@ -4354,6 +4354,8 @@ xlog_recover_free_trans(
>  	xlog_recover_item_t	*item, *n;
>  	int			i;
>  
> +	hlist_del_init(&trans->r_list);
> +
>  	list_for_each_entry_safe(item, n, &trans->r_itemq, ri_list) {
>  		/* Free the regions in the item. */
>  		list_del(&item->ri_list);
> @@ -5224,12 +5226,16 @@ xlog_do_recovery_pass(
>  	int			error2 = 0;
>  	int			bblks, split_bblks;
>  	int			hblks, split_hblks, wrapped_hblks;
> +	int			i;
>  	struct hlist_head	rhash[XLOG_RHASH_SIZE];
>  	LIST_HEAD		(buffer_list);
>  
>  	ASSERT(head_blk != tail_blk);
>  	rhead_blk = 0;
>  
> +	for (i = 0; i < XLOG_RHASH_SIZE; i++)
> +		INIT_HLIST_HEAD(&rhash[i]);
> +
>  	/*
>  	 * Read the header of the tail block and get the iclog buffer size from
>  	 * h_size.  Use this to tell how many sectors make up the log header.
> @@ -5466,6 +5472,19 @@ xlog_do_recovery_pass(
>  	if (error && first_bad)
>  		*first_bad = rhead_blk;
>  
> +	/*
> +	 * Transactions are freed at commit time but transactions without commit
> +	 * records on disk are never committed. Free any that may be left in the
> +	 * hash table.
> +	 */
> +	for (i = 0; i < XLOG_RHASH_SIZE; i++) {
> +		struct hlist_node	*tmp;
> +		struct xlog_recover	*trans;
> +
> +		hlist_for_each_entry_safe(trans, tmp, &rhash[i], r_list)
> +			xlog_recover_free_trans(trans);
> +	}
> +
>  	return error ? error : error2;
>  }
>  
> -- 
> 2.7.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

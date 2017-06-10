Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31710 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751675AbdFJVKl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Jun 2017 17:10:41 -0400
Date: Sat, 10 Jun 2017 14:10:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: free uncommitted transactions during log recovery
Message-ID: <20170610211029.GM4530@birch.djwong.org>
References: <1497029889-12299-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497029889-12299-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 09, 2017 at 01:38:09PM -0400, Brian Foster wrote:
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
> Update xlog_do_recovery_pass() to walk the hash table of transaction
> lists as the last step before it goes out of scope and free any
> transactions that may remain on the lists. This prevents a memory
> leak of partial transactions in the log.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok, I think.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Do the log intent items get freed properly too?  I /think/ the answer is
yes, but that yes could use another set of eyes. :)

--D

> ---
> 
> FYI, I suspect this has been a problem for a while and and rare/harmless
> enough that this can target 4.13.
> 
> Brian
> 
>  fs/xfs/xfs_log_recover.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 4a98762..37b34c5 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5224,6 +5224,7 @@ xlog_do_recovery_pass(
>  	int			error2 = 0;
>  	int			bblks, split_bblks;
>  	int			hblks, split_hblks, wrapped_hblks;
> +	int			i;
>  	struct hlist_head	rhash[XLOG_RHASH_SIZE];
>  	LIST_HEAD		(buffer_list);
>  
> @@ -5466,6 +5467,19 @@ xlog_do_recovery_pass(
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

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728084AbeIGSom (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Sep 2018 14:44:42 -0400
Date: Fri, 7 Sep 2018 10:03:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix transaction leak in xfs_reflink_allocate_cow()
Message-ID: <20180907140333.GB37751@bfoster>
References: <20180907015113.32448-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180907015113.32448-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, git.user@gmail.com

On Fri, Sep 07, 2018 at 11:51:13AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When xfs_reflink_allocate_cow() allocates a transaction, it drops
> the ILOCK to perform the operation. This Introduces a race condition
> where another thread modifying the file can perform the COW
> allocation operation underneath us. This result in the retry loop
> finding an allocated block and jumping straight to the conversion
> code. It does not, however, cancel the transaction it holds and so
> this gets leaked. This results in a lockdep warning:
> 
> ================================================
> WARNING: lock held when returning to user space!
> 4.18.5 #1 Not tainted
> ------------------------------------------------
> worker/6123 is leaving the kernel with locks still held!
> 1 lock held by worker/6123:
>  #0: 000000009eab4f1b (sb_internal#2){.+.+}, at: xfs_trans_alloc+0x17c/0x220
> 
> And eventually the filesystem deadlocks because it runs out of log
> space that is reserved by the leaked transaction and never gets
> released.
> 
> The logic flow in xfs_reflink_allocate_cow() is a convoluted mess of
> gotos - it's no surprise that it has bug where the flow through
> several goto jumps then fails to clean up context from a non-obvious
> logic path. CLean up the logic flow and make sure every path does
> the right thing.
> 
> Reported-by: Alexander Y. Fomichev <git.user@gmail.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=200981
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c | 98 +++++++++++++++++++++++++++++---------------
>  1 file changed, 66 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 38f405415b88..b39f5afa57aa 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -352,6 +352,47 @@ xfs_reflink_convert_cow(
>  	return error;
>  }
>  
> +/*
> + * Find the extent that maps the given range in the COW fork. Even if the extent
> + * is not shared we might have a preallocation for it in the COW fork. If so we
> + * use it that rather than trigger a new allocation.
> + */
> +static int
> +find_trim_cow_extent(
> +	struct xfs_inode	*ip,
> +	struct xfs_bmbt_irec	*imap,
> +	bool			*shared,
> +	bool			*found)
> +{
> +	xfs_fileoff_t		offset_fsb = imap->br_startoff;
> +	xfs_filblks_t		count_fsb = imap->br_blockcount;
> +	struct xfs_iext_cursor	icur;
> +	struct xfs_bmbt_irec	got;
> +	bool			trimmed;
> +
> +	*found = false;
> +
> +	/*
> +	 * if we don't find an overlapping extent, trim the range we need to
> +	 * allocate to fit the hole we found.
> +	 */
> +	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got) ||
> +	    got.br_startoff > offset_fsb)
> +		return xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
> +
> +	*shared = true;
> +	if (isnullstartblock(got.br_startblock)) {
> +		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
> +		return 0;
> +	}
> +
> +	/* real extent found - no need to allocate */
> +	xfs_trim_extent(&got, offset_fsb, count_fsb);
> +	*imap = got;
> +	*found = true;
> +	return 0;
> +}
> +
>  /* Allocate all CoW reservations covering a range of blocks in a file. */
>  int
>  xfs_reflink_allocate_cow(
> @@ -363,41 +404,37 @@ xfs_reflink_allocate_cow(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fileoff_t		offset_fsb = imap->br_startoff;
>  	xfs_filblks_t		count_fsb = imap->br_blockcount;
> -	struct xfs_bmbt_irec	got;
>  	struct xfs_trans	*tp = NULL;
>  	int			nimaps, error = 0;
> -	bool			trimmed;
> +	bool			found;
>  	xfs_filblks_t		resaligned;
>  	xfs_extlen_t		resblks = 0;
> -	struct xfs_iext_cursor	icur;
>  
> -retry:
> -	ASSERT(xfs_is_reflink_inode(ip));
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
>  	/*
> -	 * Even if the extent is not shared we might have a preallocation for
> -	 * it in the COW fork.  If so use it.
> +	 * do-while to run a single lookup retry after transaction allocation.
> +	 * All exits from the loop need to check if the transaction needs
> +	 * cancelling. Dropping the ILOCK to allocate the transaction allows
> +	 * races with other COW fork allocations, so we need to start the extent
> +	 * lookup from scratch once we have the ILOCK again.
>  	 */
> -	if (xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got) &&
> -	    got.br_startoff <= offset_fsb) {
> -		*shared = true;
> +	do {
> +		ASSERT(xfs_is_reflink_inode(ip));
>  
> -		/* If we have a real allocation in the COW fork we're done. */
> -		if (!isnullstartblock(got.br_startblock)) {
> -			xfs_trim_extent(&got, offset_fsb, count_fsb);
> -			*imap = got;
> +		error = find_trim_cow_extent(ip, imap, shared, &found);
> +		if (error || !*shared)
> +			goto out_trans_cancel;
> +		if (found) {
> +			if (tp)
> +				xfs_trans_cancel(tp);
>  			goto convert;
>  		}
>  
> -		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
> -	} else {
> -		error = xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
> -		if (error || !*shared)
> -			goto out;
> -	}
> +		/* if we have a transaction, it's time to allocate */
> +		if (tp)
> +			break;
>  
> -	if (!tp) {
>  		resaligned = xfs_aligned_fsb_count(imap->br_startoff,
>  			imap->br_blockcount, xfs_get_cowextsz_hint(ip));
>  		resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
> @@ -412,29 +449,25 @@ xfs_reflink_allocate_cow(
>  
>  		error = xfs_qm_dqattach_locked(ip, false);
>  		if (error)
> -			goto out;
> -		goto retry;
> -	}
> +			goto out_trans_cancel;
> +	} while (tp);
>  
>  	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
>  			XFS_QMOPT_RES_REGBLKS);
>  	if (error)
> -		goto out;
> +		goto out_trans_cancel;
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	nimaps = 1;
> -
>  	/* Allocate the entire reservation as unwritten blocks. */
> +	nimaps = 1;
>  	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
>  			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC,
>  			resblks, imap, &nimaps);
>  	if (error)
> -		goto out_trans_cancel;
> +		goto out_unreserve;
>  
>  	xfs_inode_set_cowblocks_tag(ip);
> -
> -	/* Finish up. */
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		return error;
> @@ -447,10 +480,11 @@ xfs_reflink_allocate_cow(
>  		return -ENOSPC;
>  convert:
>  	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb);
> -out_trans_cancel:
> +
> +out_unreserve:
>  	xfs_trans_unreserve_quota_nblks(tp, ip, (long)resblks, 0,
>  			XFS_QMOPT_RES_REGBLKS);
> -out:
> +out_trans_cancel:
>  	if (tp)
>  		xfs_trans_cancel(tp);
>  	return error;
> -- 
> 2.17.0
> 

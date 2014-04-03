Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3FE7A7F9F
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 14:07:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7BACAC001
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 12:07:06 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gUWlUHo42bywGNAU for <xfs@oss.sgi.com>;
	Thu, 03 Apr 2014 12:07:04 -0700 (PDT)
Date: Fri, 4 Apr 2014 06:07:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/2] xfs: remove efi from AIL in log recovery
Message-ID: <20140403190700.GM16336@dastard>
References: <20140325195819.638326569@sgi.com>
	<20140331202615.264666182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140331202615.264666182@sgi.com>
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
Cc: xfs@oss.sgi.com

On Mon, Mar 31, 2014 at 03:25:56PM -0500, Mark Tinguely wrote:
> xlog_recover_process_efi{s}() functions are completing the
> second half of xfs_bmap_finish() which frees extents. If this
> operation fails, the EFI will stay on the AIL and prevents
> the xfs_ail_push all_sync() from completing and the mount will
> fail to unmount.
> 
> Rather than have a special log recovery flag XFS_EFI_RECOVERED
> to decrement the EFI/EFD counter, call the same decrement function
> from the log recovery routine that is called then the EFI is added
> to the AIL from a log write.
....
> ===================================================================
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3634,6 +3634,7 @@ xlog_recover_process_data(
>  /*
>   * Process an extent free intent item that was recovered from
>   * the log.  We need to free the extents that it describes.
> + * The caller will release this and any following EFIs upon error.
>   */
>  STATIC int
>  xlog_recover_process_efi(
> @@ -3648,6 +3649,13 @@ xlog_recover_process_efi(
>  	xfs_fsblock_t		startblock_fsb;
>  
>  	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
> +	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
> +
> +	/*
> +	 * Decrement the EFI/EFD counter so the EFI is removed after
> +	 * processing the EFD or error handling in the caller.
> +	 */
> +	xfs_efi_item_unpin(&efip->efi_item, 0);

This should be done where the EFI is inserted into the AIL during
recovery, not where it is removed. That means "committed" EFIs in
the AIL have the same reference count values for both the normal
transaction case and the log recovery case. Brian already caught a
bug in your original patch because of this, so lets not leave
landmines if we can avoid it.

Also, the comment needs to explain why we don't need the reference
count (i.e. because it's a committed EFI and hence only the active
EFD can hold a reference against it now) and that on error the
caller is responsible for removing the EFI from the AIL and freeing
it.

Finally, I don't think there's any need for the XFS_EFI_RECOVERED
bit anymore, because we either process it (and remove it from the
AIL) or free it after removing it from the AIL on error and so it
won't ever get found in the AIL with that flag set....

> @@ -3750,13 +3751,23 @@ xlog_recover_process_efis(
>  		}
>  
>  		spin_unlock(&ailp->xa_lock);
> -		error = xlog_recover_process_efi(log->l_mp, efip);
> -		spin_lock(&ailp->xa_lock);
> +		if (error) {
> +			/*
> +			 * An error happened while processing a previous
> +			 * EFI entry. Since the extents are freed in order,
> +			 * skip the remaining unprocessed EFIs. To do this
> +			 * the EFI entry counter must be decremented once
> +			 * here and the entry will be decremented and removed
> +			 * with the following xfs_efi_release().
> +			 */
> +			xfs_efi_item_unpin(&efip->efi_item, 0);
> +		} else
> +			error = xlog_recover_process_efi(log->l_mp, efip);
>  		if (error)
> -			goto out;
> +			xfs_efi_release(efip, efip->efi_format.efi_nextents);
> +		spin_lock(&ailp->xa_lock);
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);

OK, so this now relies on xfs_efi_release() to remove the EFI from
the AIL. But the reason the unpin ugliness needs to be done here is
that we left a stale AIL reference on the EFI when we inserted it
into the AIL. That's another reason for moving that
xfs_efi_item_unpin() to the insert code.

Also, I'd prefer the large comment decribing the logic flow goes at
the head of the function (i.e. describing the overall logic flow of
the function) and that call should clean up this logic a lot.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

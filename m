Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E7E17F58
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 16:32:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8CF62304081
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 14:32:50 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	B1kJCBfOcFZIWQjY for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 14:32:48 -0800 (PST)
Date: Fri, 6 Dec 2013 09:32:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: free the efi AIL entry on log recovery failure
Message-ID: <20131205223244.GJ29897@dastard>
References: <20131205214054.330817383@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205214054.330817383@sgi.com>
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

On Thu, Dec 05, 2013 at 03:40:07PM -0600, Mark Tinguely wrote:
> If freeing an extent fails during recovery, then the filesystem
> will be forced down with the EFI entry still on the AIL. This
> will result in hanging the function xfs_ail_push_all_sync().
> 
> This patch is similar to the patches that removed the dquot and
> inode in commits 32ce90a and dea9609.
> 
> Found by mounting an metadata dump that triggers a
> XFS_WANT_CORRUPTED_RETURN() on log recovery.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  fs/xfs/xfs_log_recover.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: b/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3668,7 +3668,7 @@ xlog_recover_process_efi(
>  		extp = &(efip->efi_format.efi_extents[i]);
>  		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len);
>  		if (error)
> -			goto abort_error;
> +			goto free_abort;
>  		xfs_trans_log_efd_extent(tp, efdp, extp->ext_start,
>  					 extp->ext_len);
>  	}
> @@ -3677,6 +3677,9 @@ xlog_recover_process_efi(
>  	error = xfs_trans_commit(tp, 0);
>  	return error;
>  
> +free_abort:
> +	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
> +	xfs_efi_release(efip, efip->efi_format.efi_nextents);
>  abort_error:
>  	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
>  	return error;

Why does a failure of xfs_trans_reserve() in this function
not require the XFS_EFI_RECOVERED bit to be set?

If it does require setting the XFS_EFI_RECOVERED bit (I think it
does), then we unconditionally set that bit in
xlog_recover_process_efi() so it should be pulled up to be the first
thing the function does, not something that is handled in the error
paths. IOWs, we leave this function having guaranteed that we've
pulled the EFI from the AIL on any failure.

Bigger picture: if we fail to recover this EFI, we abort the AIL
walk across all the EFIs in the AIL. That means all unrecovered EFIs
get left in the AIL and this will result in hanging the function
xfs_ail_push_all_sync().  IOWs, this patch only fixes the case where
we get an error on the last EFI in the AIL during recovery. 

Hence a larger fix is needed here - if we fail to recover an EFI, we
need to continue to walk the AIL and set the XFS_EFI_RECOVERED bit
on all the EFIs still in the AIL and release them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

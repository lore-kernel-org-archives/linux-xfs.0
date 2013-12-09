Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BCF4D7F37
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 19:01:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A2F7304039
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 17:01:19 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	SvZpI0gxc5SxIGBQ for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 17:01:09 -0800 (PST)
Date: Mon, 9 Dec 2013 12:00:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: free the efi AIL entry on log recovery failure
Message-ID: <20131209010049.GN31386@dastard>
References: <20131206212037.560711585@sgi.com>
	<20131208005224.696001432@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131208005224.696001432@sgi.com>
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

On Sat, Dec 07, 2013 at 06:52:12PM -0600, Mark Tinguely wrote:
> If an extent free fails during recovery, the filesystem will be
> forced down. The efi entry is still on the AIL and the log
> shutdown function xfs_ail_push_all_sync() will hang.
> 
> This patch is similar to the patches that removed the dquot and
> inode in commits 32ce90a and dea9609 but removes all the EFI
> entries from the AIL.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
> v3 (Augh - where is my head?) only remove efi items on error.
> v2 remove all the EFIs from the AIL rather than the current entry
>    per Dave's suggestion.
>    move the cleaning routine to caller.
> 
>  fs/xfs/xfs_log_recover.c |   36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> Index: b/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3635,11 +3635,11 @@ xlog_recover_process_data(
>   */
>  STATIC int
>  xlog_recover_process_efi(
> -	xfs_mount_t		*mp,
> -	xfs_efi_log_item_t	*efip)
> +	struct xfs_mount	*mp,
> +	struct xfs_efi_log_item	*efip)
>  {
> -	xfs_efd_log_item_t	*efdp;
> -	xfs_trans_t		*tp;
> +	struct xfs_efd_log_item	*efdp;
> +	struct xfs_trans	*tp;
>  	int			i;
>  	int			error = 0;
>  	xfs_extent_t		*extp;
> @@ -3660,12 +3660,7 @@ xlog_recover_process_efi(
>  		    (extp->ext_len == 0) ||
>  		    (startblock_fsb >= mp->m_sb.sb_dblocks) ||
>  		    (extp->ext_len >= mp->m_sb.sb_agblocks)) {
> -			/*
> -			 * This will pull the EFI from the AIL and
> -			 * free the memory associated with it.
> -			 */
> -			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
> -			xfs_efi_release(efip, efip->efi_format.efi_nextents);
> +			/* The caller will free all efi entries on error. */
>  			return XFS_ERROR(EIO);
>  		}
>  	}
> @@ -3691,6 +3686,7 @@ xlog_recover_process_efi(
>  
>  abort_error:
>  	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
> +	/* The caller will free all efi entries on error. */
>  	return error;
>  }

That sort of comment belongs in the function header, not there.

Also, like I said previously, XFS_EFI_RECOVERED should be set
unconditionally at the start of the function and the error handling
should always release it, so that the state of the EFI on leaving
this function is always consistent. This is especially important if
we have an EFD pointing at the EFI - right now we can leave the
function on error with an EFD pointing at the EFI, but the EFI may
or may not ahve the XFS_EFI_RECOVERED bit set. i.e. consider that
if xfs_trans_commit() fails, it's the same case as calling
xfs_trans_cancel(XFS_TRANS_ABORT).


> @@ -3716,8 +3712,8 @@ STATIC int
>  xlog_recover_process_efis(
>  	struct xlog	*log)
>  {
> -	xfs_log_item_t		*lip;
> -	xfs_efi_log_item_t	*efip;
> +	struct xfs_log_item	*lip;
> +	struct xfs_efi_log_item	*efip;
>  	int			error = 0;
>  	struct xfs_ail_cursor	cur;
>  	struct xfs_ail		*ailp;
> @@ -3756,7 +3752,23 @@ xlog_recover_process_efis(
>  	}
>  out:
>  	xfs_trans_ail_cursor_done(ailp, &cur);
> +	lip = xfs_ail_min(ailp);
>  	spin_unlock(&ailp->xa_lock);
> +	if (!error)
> +		return 0;
> +
> +	/* Free all the EFI from the AIL upon error */
> +	while (lip) {
> +		if (lip->li_type == XFS_LI_EFI) {
> +			efip = (xfs_efi_log_item_t *)lip;
> +			if (!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
> +				set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
> +			xfs_efi_release(efip, efip->efi_format.efi_nextents);
> +		}
> +		spin_lock(&ailp->xa_lock);
> +		lip = xfs_ail_min(ailp);
> +		spin_unlock(&ailp->xa_lock);
> +	}
>  	return error;

It's never valid to walk the AIL without a cursor. Especially here,
where we could be racing with log IO completion doing shutdown
processing and modifying the AIL.

What's to stop log IO completion from freeing the log item at the
tail of the log just after we drop the AIL lock here?

What happens if the tail of the log is not an EFI? We just spin on
it and then, potentially, access it after it's been removed from the
AIL and freed....

IOWs, the only safe entries for us to touch here are EFIs and we
have to safely traverse the AIL because there are items other than
EFIs in the AIL and they may be concurrently removed by the log.
Only a cursor-based traversal makes that AIL traversal safe as it
detects list perturbations while the AIL has been dropped and
prevents us from accessing objects that we shouldn't be touching.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF4297F86
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 00:29:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A4D36304032
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 22:29:59 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	D2wsZCUAKccx3WAN for <xfs@oss.sgi.com>;
	Sun, 16 Mar 2014 22:29:56 -0700 (PDT)
Date: Mon, 17 Mar 2014 16:29:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: free the EFI entries from AIL on forced shutdown
Message-ID: <20140317052951.GE7072@dastard>
References: <20140314163723.916178776@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140314163723.916178776@sgi.com>
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

On Fri, Mar 14, 2014 at 11:37:01AM -0500, Mark Tinguely wrote:
> The extent free intention (EFI) and extent free done (EFD)
> log items are in separate transactions. It is possible that
> the EFI can be pushed to the AIL before a forced shutdown
> where it gets stuck for following reasons:
> 
>  No EFD. If freeing the extent fails in xfs_bmap_finish() or
>  xfs_recover_process_efi(), then the corresponding extent
>  free done (EFD) entry will not be created.

You don't handle the xfs_bmap_finish() case properly - the patch
only addresses the case where the EFD was created and contains a
reference to the EFI. The only time we can have an EFI in the AIL
without an EFD pointing to it is if xfs_trans_reserve() call in
xfs_bmap_finish() fails due to a shutdown. That failure case
leaks the EFI reference that is supposed to be passed to the EFD...

>  EFD IOP Abort processing. If xfs_trans_cancel() is called with
>  an abort flag, or if the xfs_trans_commit() is called when the
>  file system is in forced shutdown or if the log buffer write fails,
>  then the EFD iop commands will not remove the EFI from the AIL.

Which they should, because after xfs_trans_get_efd(), the EFD owns
the reference to the EFI. Hence aborting the EFD should release the
EFI reference it owns.

> Index: b/fs/xfs/xfs_extfree_item.c
> ===================================================================
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -420,8 +420,15 @@ STATIC void
>  xfs_efd_item_unlock(
>  	struct xfs_log_item	*lip)
>  {
> -	if (lip->li_flags & XFS_LI_ABORTED)
> +	/*
> +	 * Clear the EFI if on AIL when aborting xfs_bmap_finish.
> +	 * The forced shutdown will force the log, so other EFDs
> +	 * should not be processed from the CIL.
> +	 */
> +	if (lip->li_flags & XFS_LI_ABORTED) {
> +		xfs_efi_clear_ail(lip->li_ailp);
>  		xfs_efd_item_free(EFD_ITEM(lip));
> +	}
>  }

So, we abort one EFI, so we kill every EFI in the filesystem? We
want to be able to cancel and rollback transactions eventually, and
this will prevent us from being able to do that as it will kill EFIs
unrelated to the EFD being aborted.

AFAICT, all this needs to do is:

	if (!(lip->li_flags & XFS_LI_ABORTED))
		return;

	xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
	xfs_efd_item_free(efdp);

i.e. before freeing the EFD, release the reference to the EFI
that it was passed.

> @@ -439,10 +446,15 @@ xfs_efd_item_committed(
>  	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
>  
>  	/*
> -	 * If we got a log I/O error, it's always the case that the LR with the
> -	 * EFI got unpinned and freed before the EFD got aborted.
> +	 * If we got a log I/O error and the EFI is also in this buffer, it
> +	 * will be unpinned and freed before the EFD got aborted. But the EFI
> +	 * is in an earlier transaction and could be on the AIL when the log
> +	 * I/O error happened for this EFD. In that case, manually remove the
> +	 * remaining EFIs from the AIL.
>  	 */
> -	if (!(lip->li_flags & XFS_LI_ABORTED))
> +	if (lip->li_flags & XFS_LI_ABORTED)
> +		xfs_efi_clear_ail(lip->li_ailp);
> +	else
>  		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);

Same here - we can simply always call xfs_efi_release() and we'll
end up doing the right thing w.r.t. the EFi reference count.

And if we do the right thing with the EFI reference count when
aborting the EFI (i.e. call __xfs_efi_release() rather than freeing
it) the aborting of transactions will correctly free all the
references to the EFI and remove them from the AIL. The only case we
then have to handle specially is the xfs_trans_reserve failure in
xfs_bmap_finish(), where we need to release the EFI directly in the
error path.

That gets rid of the "big hammer" error handling for normal runtime
shutdown that xfs_efi_clear_ail(). i.e. we need to fix the reference
count handling, not work around it.


> Index: b/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3634,20 +3634,23 @@ xlog_recover_process_data(
>  /*
>   * Process an extent free intent item that was recovered from
>   * the log.  We need to free the extents that it describes.
> + * The caller will free all EFI entries on error.
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
>  	xfs_fsblock_t		startblock_fsb;
>  
>  	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
> +	/* All paths need the XFS_EFI_RECOVERED flag set. Do it here. */
> +	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
>  
>  	/*
>  	 * First check the validity of the extents described by the
> @@ -3662,12 +3665,6 @@ xlog_recover_process_efi(
>  		    (extp->ext_len == 0) ||
>  		    (startblock_fsb >= mp->m_sb.sb_dblocks) ||
>  		    (extp->ext_len >= mp->m_sb.sb_agblocks)) {
> -			/*
> -			 * This will pull the EFI from the AIL and
> -			 * free the memory associated with it.
> -			 */
> -			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
> -			xfs_efi_release(efip, efip->efi_format.efi_nextents);
>  			return XFS_ERROR(EIO);
>  		}
>  	}
> @@ -3687,7 +3684,6 @@ xlog_recover_process_efi(
>  					 extp->ext_len);
>  	}
>  
> -	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
>  	error = xfs_trans_commit(tp, 0);
>  	return error;

This is basically saying "xfs_efi_release() should drop both the AIL
and the EFD reference as we really only only have one reference". I
think we should simply remove the XFS_EFI_RECOVERED bit from the
reference counting code, and simply subtract one of the EFI
references in xlog_recover_efi_pass2() where we insert the EFI into
the AIL, so that it behaves exactly like the runtime case when
later processing the EFDs.

That is, in xlog_recover_efd_pass2() when we find a matching EFD we
simply call xfs_efi_release() and that does all the freeing because
we're removing the EFD reference which is the only remaining
reference.

Then in xlog_recover_process_efi(), we simply call xfs_efi_release()
for the error cases to drop the last reference to the EFI, otherwise
the commit of the EFD will free it because it calls
xfs_efi_release() appropriately.

>  
> @@ -3718,8 +3714,8 @@ STATIC int
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
> @@ -3753,12 +3749,13 @@ xlog_recover_process_efis(
>  		error = xlog_recover_process_efi(log->l_mp, efip);
>  		spin_lock(&ailp->xa_lock);
>  		if (error)
> -			goto out;
> +			break;
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
>  	}
> -out:
>  	xfs_trans_ail_cursor_done(ailp, &cur);
>  	spin_unlock(&ailp->xa_lock);
> +	if (error)
> +		xfs_efi_clear_ail(ailp);
>  	return error;
>  }

If we fix the reference counting, then I think all we need here is:

	int	error = 0;

	while (ail cursor next) {
		....
		if (!error)
			error = xlog_recover_process_efi()
		else
			xfs_efi_release(efip)
		....
	}

So that any error will trigger freeing of all the other unprocessed
EFIs on the AIL that are pending recovery without needing any more
special looping....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

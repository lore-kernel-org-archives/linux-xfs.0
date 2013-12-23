Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 020CF7F57
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 10:42:28 -0600 (CST)
Message-ID: <52B867F1.2030804@sgi.com>
Date: Mon, 23 Dec 2013 10:42:25 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfs: free the efi AIL entry on log recovery failure
References: <20131206212037.560711585@sgi.com>
	<20131208005224.696001432@sgi.com>
	<20131211113126.GA6248@infradead.org>
In-Reply-To: <20131211113126.GA6248@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Sorry it took me so long to get to this.

I like the idea to keep the majority of EFI items off the AIL, but it 
does not simply the EFI recovery processing. xfs_recover_process_efi() 
will place the EFI entry on the AIL and recreate the hanging on unmount 
problem when there is an error in the extent free or transaction commit.

Since the patch removes the XFS_EFI_RECOVERED flag/code, it is harder to 
remove this entry. If you leave the XFS_EFI_RECOVERED flag/code in XFS, 
the patch to avoid a hang in xfs_ail_push_all_sync() will be the same as 
before.

As you commented, it does leak some memory, which can be easily fixed...

On 12/11/13 05:31, Christoph Hellwig wrote

> Use a cancellation table, similar to how we handle buffers instead of
> abusing the AIL during recovery.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> ---

...

> @@ -3059,82 +3065,50 @@ xlog_recover_efi_pass2(
>   	struct xlog_recover_item	*item,
>   	xfs_lsn_t			lsn)
>   {
> -	int			error;
> -	xfs_mount_t		*mp = log->l_mp;
> -	xfs_efi_log_item_t	*efip;
> -	xfs_efi_log_format_t	*efi_formatp;
> +	struct xfs_efi_cancel		*ecp;
> +	int				error;
> +	xfs_mount_t			*mp = log->l_mp;
> +	xfs_efi_log_format_t		*efi_formatp;

typedef got leaked back in.

...

> @@ -3618,27 +3592,26 @@ xlog_recover_process_data(
>   }
>
>   /*
> - * Process an extent free intent item that was recovered from
> - * the log.  We need to free the extents that it describes.
> + * Process an extent free intent item that was recovered from the log.
> + * We need to free the extents that it describes.
>    */
>   STATIC int
>   xlog_recover_process_efi(
> -	xfs_mount_t		*mp,
> -	xfs_efi_log_item_t	*efip)
> +	struct xlog		*log,
> +	struct xfs_efi_cancel	*ecp)
>   {
> -	xfs_efd_log_item_t	*efdp;
> -	xfs_trans_t		*tp;
> -	int			i;
> -	int			error = 0;
> -	xfs_extent_t		*extp;
> +	struct xfs_mount	*mp = log->l_mp;
> +	struct xfs_efi_log_item	*efip = ecp->ec_efip;
> +	struct xfs_efd_log_item	*efdp;
> +	struct xfs_trans	*tp;
> +	struct xfs_extent	*extp;
>   	xfs_fsblock_t		startblock_fsb;
> -
> -	ASSERT(!test_bit(XFS_EFI_RECOVERED,&efip->efi_flags));
> +	int			error = 0;
> +	int			i;
>
>   	/*
> -	 * First check the validity of the extents described by the
> -	 * EFI.  If any are bad, then assume that all are bad and
> -	 * just toss the EFI.
> +	 * First check the validity of the extents described by the EFI.
> +	 * If any are bad, then assume that all are bad and just toss the EFI.
>   	 */
>   	for (i = 0; i<  efip->efi_format.efi_nextents; i++) {
>   		extp =&(efip->efi_format.efi_extents[i]);
> @@ -3652,12 +3625,14 @@ xlog_recover_process_efi(
>   			 * This will pull the EFI from the AIL and
>   			 * free the memory associated with it.
>   			 */
> -			set_bit(XFS_EFI_RECOVERED,&efip->efi_flags);
>   			xfs_efi_release(efip, efip->efi_format.efi_nextents);
>   			return XFS_ERROR(EIO);
>   		}
>   	}

Soo at this point we are dealing with the EFIs that do not have matching 
EFD. The EFI are in the new l_efi_cancel and not on the AIL. I am 
correct in thinking that there is no reason to do a xfs_efi_release() above?
>
> +	spin_lock(&log->l_ailp->xa_lock);
> +	xfs_trans_ail_update(log->l_ailp,&efip->efi_item, ecp->ec_lsn);

we now added the EFI to the AIL. If anything fails in the 
xfs_free_extent()/xfs_trans_commit then EFI has to be removed which is 
now trickier without the XFS_EFI_RECOVERED flag.

I suppose we could:

  1) leave the XFS_EFI_RECOVERED counter/code.
  2) manually decrease the counter. *
  3) manually remove the entry from the AIL. *
* terrible hack that everyone will NACK.

> - */
>   STATIC int
>   xlog_recover_process_efis(
>   	struct xlog	*log)
>   {
...

> -		spin_lock(&ailp->xa_lock);
> +	list_for_each_entry_safe(ecp, next,&log->l_efi_cancel, ec_list) {
> +		list_del(&ecp->ec_list);
> +		error = xlog_recover_process_efi(log, ecp);
>   		if (error)
> -			goto out;
> -		lip = xfs_trans_ail_cursor_next(ailp,&cur);
> +			break; /* XXX: will leak remaining EFIs.. */

...rather than leaking the rest of the efi cancel entries:

		/* comment here about removing entries on error */
		if (!error)
			error = xlog_recover_process_efi(log, ecp);

Again, sorry for the delay. I will wait to see what you want to do with 
this patch before resubmitting the patch to free EFI from the AIL.

--Mark.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

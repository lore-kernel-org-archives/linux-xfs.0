Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 673637F6B
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 20:52:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 009D1AC002
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 18:52:12 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZEBS5NCV4CBxl54r for <xfs@oss.sgi.com>;
	Thu, 06 Aug 2015 18:52:09 -0700 (PDT)
Date: Fri, 7 Aug 2015 11:51:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/11] xfs: use EFI refcount consistently in log recovery
Message-ID: <20150807015133.GE16638@dastard>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-6-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438883072-28706-6-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 06, 2015 at 01:44:26PM -0400, Brian Foster wrote:
> @@ -2933,16 +2933,16 @@ xlog_recover_efi_pass2(
>  	struct xlog_recover_item	*item,
>  	xfs_lsn_t			lsn)
>  {
> -	int			error;
> -	xfs_mount_t		*mp = log->l_mp;
> -	xfs_efi_log_item_t	*efip;
> -	xfs_efi_log_format_t	*efi_formatp;
> +	int				error;
> +	struct xfs_mount		*mp = log->l_mp;
> +	struct xfs_efi_log_item		*efip;
> +	struct xfs_efi_log_format	*efi_formatp;
>  
>  	efi_formatp = item->ri_buf[0].i_addr;
>  
>  	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
> -	if ((error = xfs_efi_copy_format(&(item->ri_buf[0]),
> -					 &(efip->efi_format)))) {
> +	error = xfs_efi_copy_format(&(item->ri_buf[0]), &(efip->efi_format));
> +	if (error) {

You can kill the extra (..) around the variables here.

....

> @@ -2995,18 +2998,18 @@ xlog_recover_efd_pass2(
>  			efip = (xfs_efi_log_item_t *)lip;
>  			if (efip->efi_format.efi_id == efi_id) {
>  				/*
> -				 * xfs_trans_ail_delete() drops the
> -				 * AIL lock.
> +				 * Drop the EFD reference to the EFI. This
> +				 * removes the EFI from the AIL and frees it.
>  				 */
> -				xfs_trans_ail_delete(ailp, lip,
> -						     SHUTDOWN_CORRUPT_INCORE);
> -				xfs_efi_item_free(efip);
> +				spin_unlock(&ailp->xa_lock);
> +				xfs_efi_release(efip);
>  				spin_lock(&ailp->xa_lock);

Need to call xfs_efi_release() outside the ailp->xa_lock as
xfs_efi_release() now does the removal of the log item from the AIL
and so can deadlock when taking the ailp->xa_lock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

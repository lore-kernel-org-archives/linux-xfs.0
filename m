Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBHBL0Y6222425 for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 05:21:00 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E4011FB940
	for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 03:22:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2MQofLxmi8sNL2q0 for
	<xfs@oss.sgi.com>; Fri, 17 Dec 2010 03:22:54 -0800 (PST)
Date: Fri, 17 Dec 2010 06:22:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] xfs: Pull EFI/EFD handling out from under the AIL lock
Message-ID: <20101217112254.GB12965@infradead.org>
References: <1292214743-18073-1-git-send-email-david@fromorbit.com>
	<1292214743-18073-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292214743-18073-3-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Some minor comments below:

> +STATIC void
> +__xfs_efi_release(
> +	struct xfs_efi_log_item	*efip)
> +{
> +	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
> +
> +	if (!test_and_clear_bit(XFS_EFI_COMMITTED, &efip->efi_flags)) {
> +		spin_lock(&ailp->xa_lock);
> +		/* xfs_trans_ail_delete() drops the AIL lock. */
> +		xfs_trans_ail_delete(ailp, (xfs_log_item_t *)efip);

The second argument should be &efip->efi_item to preserve ty;e safety.

>  void
>  xfs_efi_release(xfs_efi_log_item_t	*efip,
>  		uint			nextents)
>  {
> +	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
> +	if (!atomic_sub_and_test(nextents, &efip->efi_next_extent))
> +		return;
>  
> +	__xfs_efi_release(efip);

Why not just:

	if (atomic_sub_and_test(nextents, &efip->efi_next_extent))
		__xfs_efi_release(efip);

?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

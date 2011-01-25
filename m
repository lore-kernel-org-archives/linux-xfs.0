Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0PNpWPi103395 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 17:51:34 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F2C81A29F58
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 15:53:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LeRVn4E9Spa97F71 for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 15:53:56 -0800 (PST)
Date: Tue, 25 Jan 2011 18:53:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] xfs: fix efi item leak on forced shutdown
Message-ID: <20110125235354.GA3832@infradead.org>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295945444-29488-3-git-send-email-david@fromorbit.com>
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

On Tue, Jan 25, 2011 at 07:50:38PM +1100, Dave Chinner wrote:
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 75f2ef6..effbb41 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -138,7 +138,6 @@ xfs_efi_item_unpin(
>  
>  	if (remove) {
>  		ASSERT(!(lip->li_flags & XFS_LI_IN_AIL));
> -		xfs_trans_del_item(lip);
>  		xfs_efi_item_free(efip);
>  		return;
>  	}

>  STATIC void
>  xfs_trans_uncommit(
>  	struct xfs_trans	*tp,
>  	uint			flags)
>  {
> -	struct xfs_log_item_desc *lidp;
> +	struct xfs_log_item_desc *lidp, *n;
>  
> -	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
> +	list_for_each_entry_safe(lidp, n, &tp->t_items, lid_trans) {
>  		/*
>  		 * Unpin all but those that aren't dirty.
>  		 */
> -		if (lidp->lid_flags & XFS_LID_DIRTY)
> +		if (lidp->lid_flags & XFS_LID_DIRTY) {
> +			xfs_trans_del_item(lidp->lid_item);
>  			IOP_UNPIN(lidp->lid_item, 1);
> +		}

This part of the patch isn't explained in the changelog, and I suspect
it should be a separate patch from the addition of the IOP_UNPIN with
remove call to the CIL error path.

Moving the xfs_trans_del_item from the IOP_UNPIN implementation into
the caller seems sane to me, but:

 - why is the call to xfs_trans_del_item left in xfs_buf_item_unpin
 - why did xfs_buf_item_unpin get away only calling it for the stale
   case, and the other log item implementations completely without
   it

I suspect the answer lies in xfs_trans_free_items opencoding the
call to xfs_trans_del_item, thus avoiding any leak of log item
descriptors or log items on the transaction list.  By adding the
call of xfs_trans_del_item to xfs_trans_uncommit we thus skip
the calls to IOP_UNLOCK for dirty log items, which is a large
change in behaviour for the existing log items that didn't have
the xfs_trans_del_item calls, and at least for the dquot and
inode items seems incorrect.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

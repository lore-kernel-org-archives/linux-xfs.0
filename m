Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:2144 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751569AbdEQA5x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2017 20:57:53 -0400
Date: Wed, 17 May 2017 10:57:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170517005749.GO17542@dastard>
References: <20170511135733.21765-1-cmaiolino@redhat.com>
 <20170511135733.21765-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170511135733.21765-3-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 11, 2017 at 03:57:33PM +0200, Carlos Maiolino wrote:
> +xfs_inode_item_error(
> +	struct xfs_log_item	*lip,
> +	unsigned int		bflags)
> +{
> +
> +	/*
> +	 * The buffer writeback containing this inode has been failed
> +	 * mark it as failed and unlock the flush lock, so it can be retried
> +	 * again
> +	 */
> +	if (bflags & XBF_WRITE_FAIL)
> +		lip->li_flags |= XFS_LI_FAILED;
> +}

I'm pretty sure we can't modify the log item state like this in
IO context because the parent object is not locked by this context.
We can modify the state during IO submission because we hold the
parent object lock, but we don't hold it here.

i.e. we can race with other log item state changes done during a
concurrent transaction (e.g. marking the log item dirty in
xfs_trans_log_inode()).

> +
>  STATIC uint
>  xfs_inode_item_push(
>  	struct xfs_log_item	*lip,
> @@ -517,8 +532,44 @@ xfs_inode_item_push(
>  	 * the AIL.
>  	 */
>  	if (!xfs_iflock_nowait(ip)) {
> +		if (lip->li_flags & XFS_LI_FAILED) {
> +
> +			struct xfs_dinode	*dip;
> +			struct xfs_log_item	*next;
> +			int			error;
> +
> +			error = xfs_imap_to_bp(ip->i_mount, NULL, &ip->i_imap,
> +					       &dip, &bp, XBF_TRYLOCK, 0);
> +
> +			if (error) {
> +				rval = XFS_ITEM_FLUSHING;
> +				goto out_unlock;
> +			}
> +
> +			if (!(bp->b_flags & XBF_WRITE_FAIL)) {
> +				rval = XFS_ITEM_FLUSHING;
> +				xfs_buf_relse(bp);
> +				goto out_unlock;
> +			}
> +
> +			while (lip != NULL) {
> +				next = lip->li_bio_list;
> +
> +				if (lip->li_flags & XFS_LI_FAILED)
> +					lip->li_flags &= XFS_LI_FAILED;
> +				lip = next;
> +			}

Same race here - we hold the lock for this inode, but not all the
other inodes linked to the buffer.

This implies that lip->li_flags needs to use atomic bit updates so
there are no RMW update races like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

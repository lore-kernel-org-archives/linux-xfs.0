Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53986 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755208AbdEKPcR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 11:32:17 -0400
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
References: <20170511135733.21765-1-cmaiolino@redhat.com>
 <20170511135733.21765-3-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <588425aa-420d-67a8-76cb-3974fc600455@sandeen.net>
Date: Thu, 11 May 2017 10:32:16 -0500
MIME-Version: 1.0
In-Reply-To: <20170511135733.21765-3-cmaiolino@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On 5/11/17 8:57 AM, Carlos Maiolino wrote:
> When a buffer has been failed during writeback, the inode items into it
> are kept flush locked, and are never resubmitted due the flush lock, so,
> if any buffer fails to be written, the items in AIL are never written to
> disk and never unlocked.
> 
> This causes a filesystem to be unmountable due these items flush locked

I think you mean "not unmountable?"

> in AIL, but this also causes the items in AIL to never be written back,
> even when the IO device comes back to normal.
> 
> I've been testing this patch with a DM-thin device, creating a
> filesystem larger than the real device.
> 
> When writing enough data to fill the DM-thin device, XFS receives ENOSPC
> errors from the device, and keep spinning on xfsaild (when 'retry
> forever' configuration is set).
> 
> At this point, the filesystem is unmountable because of the flush locked

(or cannot be unmounted ...)

> items in AIL, but worse, the items in AIL are never retried at all
> (once xfs_inode_item_push() will skip the items that are flush locked),
> even if the underlying DM-thin device is expanded to the proper size.

Can you turn that into an xfstest?

> This patch fixes both cases, retrying any item that has been failed
> previously, using the infra-structure provided by the previous patch.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> This same problem is also possible in dquot code, but the fix is almost
> identical.
> 
> I am not submitting a fix for dquot yet to avoid the need to create VX for both
> patches, once we agree with the solution, I'll submit a fix to dquot.
> 
>  fs/xfs/xfs_inode_item.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 53 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 08cb7d1..583fa9e 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -475,6 +475,21 @@ xfs_inode_item_unpin(
>  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
>  }
>  
> +STATIC void
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
> +
>  STATIC uint
>  xfs_inode_item_push(
>  	struct xfs_log_item	*lip,
> @@ -517,8 +532,44 @@ xfs_inode_item_push(
>  	 * the AIL.
>  	 */
>  	if (!xfs_iflock_nowait(ip)) {

Some comments about what this new block is for would be helpful, I think.

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

This confuses me.  If XFS_LI_FAILED is set, set XFS_LI_FAILED?
I assume you meant to clear it?

> +				lip = next;
> +			}
> +

			/* Add this buffer back to the delayed write list */

> +			if (!xfs_buf_delwri_queue(bp, buffer_list))
> +				rval = XFS_ITEM_FLUSHING;

> +			xfs_buf_relse(bp);

So by here we have an implicit rval = XFS_ITEM_SUCCESS, I guess?

(I wonder about setting FLUSHING at the top, and setting SUCCESS
only if everything in here works out - but maybe that would be
more confusing)

Anyway that's my first drive-by review, I'm not sure I have all the state & 
locking clear in my head for this stuff.

Thanks,
-Eric

> +			goto out_unlock;
> +		}
> +
>  		rval = XFS_ITEM_FLUSHING;
>  		goto out_unlock;
> +
>  	}
>  
>  	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
> @@ -622,7 +673,8 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
>  	.iop_unlock	= xfs_inode_item_unlock,
>  	.iop_committed	= xfs_inode_item_committed,
>  	.iop_push	= xfs_inode_item_push,
> -	.iop_committing = xfs_inode_item_committing
> +	.iop_committing = xfs_inode_item_committing,
> +	.iop_error	= xfs_inode_item_error
>  };
>  
>  
> 

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24193 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbdHPRPH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 13:15:07 -0400
Date: Wed, 16 Aug 2017 10:15:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 2/2] xfs: don't log dirty ranges for ordered buffers
Message-ID: <20170816171501.GY4796@magnolia>
References: <20170814165451.43788-1-bfoster@redhat.com>
 <20170814165451.43788-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170814165451.43788-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 14, 2017 at 12:54:51PM -0400, Brian Foster wrote:
> Ordered buffers are attached to transactions and pushed through the
> logging infrastructure just like normal buffers with the exception
> that they are not actually written to the log. Therefore, we don't
> need to log dirty ranges of ordered buffers. xfs_trans_log_buf() is
> called on ordered buffers to set up all of the dirty state on the
> transaction, buffer and log item and prepare the buffer for I/O.
> 
> Now that xfs_trans_dirty_buf() is available, call it from
> xfs_trans_ordered_buf() so the latter is now mutually exclusive with
> xfs_trans_log_buf(). This reflects the implementation of ordered
> buffers and helps eliminate confusion over the need to log ranges of
> ordered buffers just to set up internal log state.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_btree.c  |  3 ++-
>  fs/xfs/libxfs/xfs_ialloc.c |  2 --
>  fs/xfs/xfs_trans_buf.c     | 25 +++++++++++++------------
>  3 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index e0bcc4a..9c97896 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4466,7 +4466,8 @@ xfs_btree_block_change_owner(
>  	if (bp) {
>  		if (cur->bc_tp) {
>  			xfs_trans_ordered_buf(cur->bc_tp, bp);
> -			xfs_btree_log_block(cur, bp, XFS_BB_OWNER);
> +			/*xfs_trans_buf_set_type(cur->bc_tp, bp,
> +					       XFS_BLFT_BTREE_BUF);*/

I don't see the point of this, but maybe you've already dropped it anyway. :)

>  		} else {
>  			xfs_buf_delwri_queue(bp, bbcoi->buffer_list);
>  		}
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index ffd5a15..12c0452 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -378,8 +378,6 @@ xfs_ialloc_inode_init(
>  				 * transaction and pin the log appropriately.
>  				 */
>  				xfs_trans_ordered_buf(tp, fbuf);
> -				xfs_trans_log_buf(tp, fbuf, 0,
> -						  BBTOB(fbuf->b_length) - 1);
>  			}
>  		} else {
>  			fbuf->b_flags |= XBF_DONE;
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 58818a0..3a358cb 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -560,16 +560,12 @@ xfs_trans_log_buf(
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
>  	ASSERT(first <= last && last < BBTOB(bp->b_length));
> +	ASSERT(!(bip->bli_flags & XFS_BLI_ORDERED));
>  
>  	xfs_trans_dirty_buf(tp, bp);
>  
> -	/*
> -	 * If we have an ordered buffer we are not logging any dirty range but
> -	 * it still needs to be marked dirty and that it has been logged.
> -	 */
>  	trace_xfs_trans_log_buf(bip);
> -	if (!(bip->bli_flags & XFS_BLI_ORDERED))
> -		xfs_buf_item_log(bip, first, last);
> +	xfs_buf_item_log(bip, first, last);
>  }
>  
>  
> @@ -722,12 +718,11 @@ xfs_trans_inode_alloc_buf(
>  }
>  
>  /*
> - * Mark the buffer as ordered for this transaction. This means
> - * that the contents of the buffer are not recorded in the transaction
> - * but it is tracked in the AIL as though it was. This allows us
> - * to record logical changes in transactions rather than the physical
> - * changes we make to the buffer without changing writeback ordering
> - * constraints of metadata buffers.
> + * Mark the buffer as ordered for this transaction. This means that the contents
> + * of the buffer are not recorded in the transaction but it is tracked in the
> + * AIL as though it was. This allows us to record logical changes in
> + * transactions rather than the physical changes we make to the buffer without
> + * changing writeback ordering constraints of metadata buffers.

Did the text of this comment change?  AFAICT the only difference is
where we line wrap?

(If that's the case, why bother?)

>   */
>  void
>  xfs_trans_ordered_buf(
> @@ -742,6 +737,12 @@ xfs_trans_ordered_buf(
>  
>  	bip->bli_flags |= XFS_BLI_ORDERED;
>  	trace_xfs_buf_item_ordered(bip);
> +
> +	/*
> +	 * We don't log a dirty range of an ordered buffer but it still needs
> +	 * to be marked dirty and that it has been logged.
> +	 */
> +	xfs_trans_dirty_buf(tp, bp);

Otherwise looks ok to me...

--D

>  }
>  
>  /*
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

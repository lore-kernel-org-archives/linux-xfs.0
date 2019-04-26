Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbfDZLQ4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Apr 2019 07:16:56 -0400
Date: Fri, 26 Apr 2019 07:16:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: always rejoin held resources during defer roll
Message-ID: <20190426111654.GA34536@bfoster>
References: <20190426064137.GM178290@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426064137.GM178290@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Apr 25, 2019 at 11:41:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During testing of xfs/141 on a V4 filesystem, I observed some
> inconsistent behavior with regards to resources that are held (i.e.
> remain locked) across a defer roll.  The transaction roll always gives
> the defer roll function a new transaction, even if committing the old
> transaction fails.  However, the defer roll function only rejoins the
> held resources if the transaction commit succeedied.  This means that
> callers of defer roll have to figure out whether the held resources are
> attached to the transaction being passed back.
> 
> Worse yet, if the defer roll was part of a defer finish call, we have a
> third possibility: the defer finish could pass back a dirty transaction
> with dirty held resources and an error code.
> 
> The only sane way to handle all of these scenarios is to require that
> the code that held the resource either cancel the transaction before
> unlocking and releasing the resources, or use functions that detach
> resources from a transaction properly (e.g.  xfs_trans_brelse) if they
> need to drop the reference before committing or cancelling the
> transaction.
> 
> In order to make this so, change the defer roll code to join held
> resources to the new transaction unconditionally and fix all the bhold
> callers to release the held buffers correctly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: release the buffer hold after the defer roll unless we're actually
> planning to use the buffer after the transactions are all done
> ---
>  fs/xfs/libxfs/xfs_attr.c  |   35 ++++++++++++-----------------------
>  fs/xfs/libxfs/xfs_attr.h  |    2 +-
>  fs/xfs/libxfs/xfs_defer.c |   14 +++++++++-----
>  fs/xfs/xfs_dquot.c        |   17 +++++++++--------
>  4 files changed, 31 insertions(+), 37 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 87e6dd5326d5..a1af984e4913 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -277,7 +277,8 @@ xfs_dquot_set_prealloc_limits(struct xfs_dquot *dqp)
>  
>  /*
>   * Ensure that the given in-core dquot has a buffer on disk backing it, and
> - * return the buffer. This is called when the bmapi finds a hole.
> + * return the buffer locked and held. This is called when the bmapi finds a
> + * hole.
>   */
>  STATIC int
>  xfs_dquot_disk_alloc(
> @@ -355,13 +356,14 @@ xfs_dquot_disk_alloc(
>  	 * If everything succeeds, the caller of this function is returned a
>  	 * buffer that is locked and held to the transaction.  The caller
>  	 * is responsible for unlocking any buffer passed back, either
> -	 * manually or by committing the transaction.
> +	 * manually or by committing the transaction.  On error, the buffer is
> +	 * released and not passed back.
>  	 */
>  	xfs_trans_bhold(tp, bp);
>  	error = xfs_defer_finish(tpp);
> -	tp = *tpp;
>  	if (error) {
> -		xfs_buf_relse(bp);
> +		xfs_trans_bhold_release(*tpp, bp);
> +		xfs_trans_brelse(*tpp, bp);

The xfs_trans_brelse() calls here and in the xattr case both seem
superfluous. In both cases the buffer is attached to the transaction and
should be released appropriately on abort. That said, they're harmless
and the code still looks correct to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  		return error;
>  	}
>  	*bpp = bp;
> @@ -521,7 +523,6 @@ xfs_qm_dqread_alloc(
>  	struct xfs_buf		**bpp)
>  {
>  	struct xfs_trans	*tp;
> -	struct xfs_buf		*bp;
>  	int			error;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
> @@ -529,7 +530,7 @@ xfs_qm_dqread_alloc(
>  	if (error)
>  		goto err;
>  
> -	error = xfs_dquot_disk_alloc(&tp, dqp, &bp);
> +	error = xfs_dquot_disk_alloc(&tp, dqp, bpp);
>  	if (error)
>  		goto err_cancel;
>  
> @@ -539,10 +540,10 @@ xfs_qm_dqread_alloc(
>  		 * Buffer was held to the transaction, so we have to unlock it
>  		 * manually here because we're not passing it back.
>  		 */
> -		xfs_buf_relse(bp);
> +		xfs_buf_relse(*bpp);
> +		*bpp = NULL;
>  		goto err;
>  	}
> -	*bpp = bp;
>  	return 0;
>  
>  err_cancel:

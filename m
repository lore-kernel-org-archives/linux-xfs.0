Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932087AbdGSQSb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Jul 2017 12:18:31 -0400
Date: Wed, 19 Jul 2017 12:18:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] libxfs: propagate transaction block reservations
Message-ID: <20170719161827.GB55813@bfoster.bfoster>
References: <20170719155555.GO4224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170719155555.GO4224@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Wed, Jul 19, 2017 at 08:55:55AM -0700, Darrick J. Wong wrote:
> Certain parts of the libxfs preemptively refuse to run if the
> transaction block reservation has fallen to zero.  We leave t_blk_res at
> its default of zero, which means that these code paths always fail even
> if the transaction was allocated with a non-zero block reservation.  Set
> t_blk_res and maintain it through transaction rolls, even though we
> don't do much enforcement the transaction block limits.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  libxfs/trans.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index fe22cb9..035248f 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -106,6 +106,7 @@ libxfs_trans_roll(
>  	struct xfs_mount	*mp;
>  	struct xfs_trans	*trans;
>  	struct xfs_trans_res	tres;
> +	unsigned int		old_blk_res;
>  	int			error;
>  
>  	/*
> @@ -121,6 +122,7 @@ libxfs_trans_roll(
>  	mp = trans->t_mountp;
>  	tres.tr_logres = trans->t_log_res;
>  	tres.tr_logcount = trans->t_log_count;
> +	old_blk_res = trans->t_blk_res;
>  
>  	/*
>  	 * Commit the current transaction.
> @@ -145,6 +147,8 @@ libxfs_trans_roll(
>  	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>  	error = libxfs_trans_alloc(mp, &tres, 0, 0, 0, tpp);
>  	trans = *tpp;
> +	trans->t_blk_res = old_blk_res;
> +
>  	/*
>  	 *  Ensure that the inode is in the new transaction and locked.
>  	 */
> @@ -185,6 +189,7 @@ libxfs_trans_alloc(
>  		exit(1);
>  	}
>  	ptr->t_mountp = mp;
> +	ptr->t_blk_res = blocks;
>  	INIT_LIST_HEAD(&ptr->t_items);
>  #ifdef XACT_DEBUG
>  	fprintf(stderr, "allocated new transaction %p\n", ptr);
> @@ -750,7 +755,7 @@ trans_committed(
>          list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
>  		struct xfs_log_item *lip = lidp->lid_item;
>  
> -                xfs_trans_del_item(lip);
> +		xfs_trans_del_item(lip);
>  
>  		if (lip->li_type == XFS_LI_BUF)
>  			buf_item_done((xfs_buf_log_item_t *)lip);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

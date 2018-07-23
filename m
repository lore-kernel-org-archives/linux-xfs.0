Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388078AbeGWVwZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 17:52:25 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 16E0A40201BD
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 20:49:28 +0000 (UTC)
Date: Mon, 23 Jul 2018 15:49:26 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH v2 09/15] xfs: use internal dfops in cow blocks cancel
Message-ID: <20180723204926.GG18737@redhat.com>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-10-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-10-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:08AM -0400, Brian Foster wrote:
> All callers either explicitly initialize a dfops or pass a
> transaction with an internal dfops. Drop the hacky old dfops
> replacement logic and use the one associated with the transaction.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/xfs_reflink.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 3143889097f1..c3f2a0d3e6f5 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -483,8 +483,6 @@ xfs_reflink_cancel_cow_blocks(
>  	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	struct xfs_bmbt_irec		got, del;
>  	struct xfs_iext_cursor		icur;
> -	struct xfs_defer_ops		dfops;
> -	struct xfs_defer_ops		*odfops = (*tpp)->t_dfops;
>  	int				error = 0;
>  
>  	if (!xfs_is_reflink_inode(ip))
> @@ -511,7 +509,8 @@ xfs_reflink_cancel_cow_blocks(
>  			if (error)
>  				break;
>  		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
> -			xfs_defer_init(*tpp, &dfops);
> +			ASSERT((*tpp)->t_dfops);
> +			ASSERT((*tpp)->t_firstblock == NULLFSBLOCK);
>  
>  			/* Free the CoW orphan record. */
>  			error = xfs_refcount_free_cow_extent(ip->i_mount,
> @@ -553,7 +552,6 @@ xfs_reflink_cancel_cow_blocks(
>  	/* clear tag if cow fork is emptied */
>  	if (!ifp->if_bytes)
>  		xfs_inode_clear_cowblocks_tag(ip);
> -	(*tpp)->t_dfops = odfops;
>  	return error;
>  }
>  
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

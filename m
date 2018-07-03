Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38246 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932959AbeGCPPs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 11:15:48 -0400
Date: Tue, 3 Jul 2018 08:15:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: use ->t_dfops for recovery of [b|c]ui log items
Message-ID: <20180703151535.GT5711@magnolia>
References: <20180628163636.52564-6-bfoster@redhat.com>
 <20180702173836.9533-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180702173836.9533-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 02, 2018 at 01:38:36PM -0400, Brian Foster wrote:
> Log recovery passes down a central dfops structure to recovery
> handlers for bui and cui log items. Each of these handlers allocates
> and commits a transaction and defers any remaining operations to be
> completed by the main recovery sequence.
> 
> Since dfops outlives the transaction in this context, set and clear
> ->t_dfops appropriately such that the *_finish_item() paths and
> below (i.e., xfs_bmapi*()) can expect to find the dfops in the
> transaction without it being committed with the dfops attached. This
> is required because transaction commit expects that an associated
> dfops is finished and in this context the dfops may be populated at
> commit time.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> v2:
> - Add comments to explain unique ->t_dfops usage in bui/cui log item
>   recovery.
> 
>  fs/xfs/xfs_bmap_item.c     | 8 ++++++++
>  fs/xfs/xfs_refcount_item.c | 8 ++++++++

General note: realtime rmap (being rooted in an inode) log item replay
can generate further dfops, so I'll have to wire that up when I pass the
log recovery dfops collector into xfs_rui_recover, and I'll have to
remember to attach it to the transaction when I do that.

Otherwise I think this is fine,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  2 files changed, 16 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 956ebd583e27..478bfc798861 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -441,6 +441,7 @@ xfs_bui_recover(
>  			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
>  	if (error)
>  		return error;
> +	tp->t_dfops = dfops;
>  	budp = xfs_trans_get_bud(tp, buip);
>  
>  	/* Grab the inode. */
> @@ -487,6 +488,12 @@ xfs_bui_recover(
>  	}
>  
>  	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
> +	/*
> +	 * Recovery finishes all deferred ops once intent processing is
> +	 * complete. Reset the trans reference because commit expects a finished
> +	 * dfops or none at all.
> +	 */
> +	tp->t_dfops = NULL;
>  	error = xfs_trans_commit(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	IRELE(ip);
> @@ -494,6 +501,7 @@ xfs_bui_recover(
>  	return error;
>  
>  err_inode:
> +	tp->t_dfops = NULL;
>  	xfs_trans_cancel(tp);
>  	if (ip) {
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 472a73e9d331..2064c689bc72 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -452,6 +452,7 @@ xfs_cui_recover(
>  			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;
> +	tp->t_dfops = dfops;
>  	cudp = xfs_trans_get_cud(tp, cuip);
>  
>  	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
> @@ -514,11 +515,18 @@ xfs_cui_recover(
>  
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
>  	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
> +	/*
> +	 * Recovery finishes all deferred ops once intent processing is
> +	 * complete. Reset the trans reference because commit expects a finished
> +	 * dfops or none at all.
> +	 */
> +	tp->t_dfops = NULL;
>  	error = xfs_trans_commit(tp);
>  	return error;
>  
>  abort_error:
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> +	tp->t_dfops = NULL;
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43164 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732562AbeGKQ2W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jul 2018 12:28:22 -0400
Date: Wed, 11 Jul 2018 09:23:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] xfs: simplify xfs_idata_realloc
Message-ID: <20180711162311.GB32415@magnolia>
References: <20180710060528.4071-1-hch@lst.de>
 <20180710060528.4071-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180710060528.4071-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 10, 2018 at 08:05:24AM +0200, Christoph Hellwig wrote:
> Streamline the code and take advantage of the fact that kmem_realloc
> through krealloc will be have like a normal allocation if passing in a
> NULL old pointer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_fork.c | 55 ++++++++++++----------------------
>  1 file changed, 19 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index dee85b0f8846..a0e3fb804605 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -468,51 +468,34 @@ xfs_iroot_realloc(
>   */
>  void
>  xfs_idata_realloc(
> -	xfs_inode_t	*ip,
> -	int		byte_diff,
> -	int		whichfork)
> +	struct xfs_inode	*ip,
> +	int			byte_diff,
> +	int			whichfork)
>  {
> -	xfs_ifork_t	*ifp;
> -	int		new_size;
> -	int		real_size;
> -
> -	if (byte_diff == 0) {
> -		return;
> -	}
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	int			new_size = (int)ifp->if_bytes + byte_diff;
>  
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	new_size = (int)ifp->if_bytes + byte_diff;
>  	ASSERT(new_size >= 0);
> +	ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));
> +
> +	if (byte_diff == 0)
> +		return;
>  
>  	if (new_size == 0) {
>  		kmem_free(ifp->if_u1.if_data);
>  		ifp->if_u1.if_data = NULL;
> -		real_size = 0;
> -	} else {
> -		/*
> -		 * Stuck with malloc/realloc.
> -		 * For inline data, the underlying buffer must be
> -		 * a multiple of 4 bytes in size so that it can be
> -		 * logged and stay on word boundaries.  We enforce
> -		 * that here.
> -		 */
> -		real_size = roundup(new_size, 4);
> -		if (ifp->if_u1.if_data == NULL) {
> -			ifp->if_u1.if_data = kmem_alloc(real_size,
> -							KM_SLEEP | KM_NOFS);
> -		} else {
> -			/*
> -			 * Only do the realloc if the underlying size
> -			 * is really changing.
> -			 */
> -			ifp->if_u1.if_data =
> -				kmem_realloc(ifp->if_u1.if_data,
> -						real_size,
> -						KM_SLEEP | KM_NOFS);
> -		}
> +		ifp->if_bytes = 0;
> +		return;
>  	}
> +
> +	/*
> +	 * For inline data, the underlying buffer must be a multiple of 4 bytes
> +	 * in size so that it can be logged and stay on word boundaries.
> +	 * We enforce that here.
> +	 */
> +	ifp->if_u1.if_data = kmem_realloc(ifp->if_u1.if_data,
> +			roundup(new_size, 4), KM_SLEEP | KM_NOFS);
>  	ifp->if_bytes = new_size;
> -	ASSERT(ifp->if_bytes <= XFS_IFORK_SIZE(ip, whichfork));
>  }
>  
>  void
> -- 
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

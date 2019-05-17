Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48272 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727386AbfEQIQz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 04:16:55 -0400
Subject: Re: [PATCH 13/20] xfs: merge xfs_efd_init into xfs_trans_get_efd
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-14-hch@lst.de>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <790a6cfb-7fb9-db50-05c4-ba91fb7628b0@suse.com>
Date: Fri, 17 May 2019 11:16:52 +0300
MIME-Version: 1.0
In-Reply-To: <20190517073119.30178-14-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org



On 17.05.19 г. 10:31 ч., Christoph Hellwig wrote:
> There is no good reason to keep these two functions separate.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_extfree_item.c  | 27 +++++++++++++++------------
>  fs/xfs/xfs_extfree_item.h  |  2 --
>  fs/xfs/xfs_trans_extfree.c | 26 --------------------------
>  3 files changed, 15 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index bb0b1e942d00..ccf95cb8234c 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -312,32 +312,35 @@ static const struct xfs_item_ops xfs_efd_item_ops = {
>  };
>  
>  /*
> - * Allocate and initialize an efd item with the given number of extents.
> + * Allocate an "extent free done" log item that will hold nextents worth of
> + * extents.  The caller must use all nextents extents, because we are not
> + * flexible about this at all.
>   */
>  struct xfs_efd_log_item *
> -xfs_efd_init(
> -	struct xfs_mount	*mp,
> -	struct xfs_efi_log_item	*efip,
> -	uint			nextents)
> -
> +xfs_trans_get_efd(
> +	struct xfs_trans		*tp,
> +	struct xfs_efi_log_item		*efip,
> +	unsigned int			nextents)
>  {
> -	struct xfs_efd_log_item	*efdp;
> -	uint			size;
> +	struct xfs_efd_log_item		*efdp;
>  
>  	ASSERT(nextents > 0);
> +
>  	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> -		size = (uint)(sizeof(xfs_efd_log_item_t) +
> -			((nextents - 1) * sizeof(xfs_extent_t)));
> -		efdp = kmem_zalloc(size, KM_SLEEP);
> +		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> +				(nextents - 1) * sizeof(struct xfs_extent),
> +				KM_SLEEP);

xfs_efd_log is really a struct which ends with an array. I think it will
make it slightly more obvious if you use the newly introduced
struct_size like so:

kmem_zalloc(struct_size(efdp, efd_format.efd_extents, nextents -1),
KM_SLEEP)


<snip>

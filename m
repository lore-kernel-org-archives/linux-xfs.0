Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbfEQRuh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 13:50:37 -0400
Date: Fri, 17 May 2019 13:50:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/20] xfs: don't cast inode_log_items to get the log_item
Message-ID: <20190517175035.GI7888@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-10-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:08AM +0200, Christoph Hellwig wrote:
> The cast is not type safe, and we can just dereference the first
> member instead to start with.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 71d216cf6f87..419eae485ff3 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -485,7 +485,7 @@ xfs_lock_inodes(
>  		 */
>  		if (!try_lock) {
>  			for (j = (i - 1); j >= 0 && !try_lock; j--) {
> -				lp = (xfs_log_item_t *)ips[j]->i_itemp;
> +				lp = &ips[j]->i_itemp->ili_item;
>  				if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags))
>  					try_lock++;
>  			}
> @@ -585,7 +585,7 @@ xfs_lock_two_inodes(
>  	 * the second lock. If we can't get it, we must release the first one
>  	 * and try again.
>  	 */
> -	lp = (xfs_log_item_t *)ip0->i_itemp;
> +	lp = &ip0->i_itemp->ili_item;
>  	if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags)) {
>  		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(ip1_mode, 1))) {
>  			xfs_iunlock(ip0, ip0_mode);
> -- 
> 2.20.1
> 

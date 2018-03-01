Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162589AbeCAWsG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 17:48:06 -0500
Date: Thu, 1 Mar 2018 14:48:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Correctly invert xfs_buftarg LRU isolation logic
Message-ID: <20180301224800.GI12763@magnolia>
References: <20180228154951.31714-1-vbendel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180228154951.31714-1-vbendel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vratislav Bendel <vbendel@redhat.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, djwong@kernel.org

On Wed, Feb 28, 2018 at 04:49:51PM +0100, Vratislav Bendel wrote:
> The function xfs_buftarg_isolate() used by xfs buffer schrinkers 
> to determine whether a buffer should be isolated and disposed 
> from LRU list, has inverted logic.
> 
> Excerpt from xfs_buftarg_isolate():
>         /*
>          * Decrement the b_lru_ref count unless the value is already
>          * zero. If the value is already zero, we need to reclaim the
>          * buffer, otherwise it gets another trip through the LRU.
>          */
>         if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
>                 spin_unlock(&bp->b_lock);
>                 return LRU_ROTATE;
>         }
> 
> However, as per documentation, atomic_add_unless() returns _zero_
> if the atomic value was originally equal to the specified *unsless* value.
> 
> Ultimately causing a xfs_buffer with ->b_lru_ref == 0, to take another 
> trip around LRU, while isolating buffers with non-zero b_lru_ref.
> 
> Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
> CC: Brian Foster <bfoster@redhat.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d1da2ee9e6db..ac669a10c62f 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1708,7 +1708,7 @@ xfs_buftarg_isolate(
>  	 * zero. If the value is already zero, we need to reclaim the
>  	 * buffer, otherwise it gets another trip through the LRU.
>  	 */
> -	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
> +	if (atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
>  		spin_unlock(&bp->b_lock);
>  		return LRU_ROTATE;
>  	}
> -- 
> 2.14.3
> 

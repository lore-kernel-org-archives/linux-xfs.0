Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033270AbeCARjl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Mar 2018 12:39:41 -0500
Date: Thu, 1 Mar 2018 12:39:39 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Correctly invert xfs_buftarg LRU isolation logic
Message-ID: <20180301173939.GB34164@bfoster.bfoster>
References: <20180228154951.31714-1-vbendel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180228154951.31714-1-vbendel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vratislav Bendel <vbendel@redhat.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org

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

Nit:							     unless

> Ultimately causing a xfs_buffer with ->b_lru_ref == 0, to take another 
> trip around LRU, while isolating buffers with non-zero b_lru_ref.
> 
> Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
> CC: Brian Foster <bfoster@redhat.com>
> ---

It might be worth pointing out in the commit log that currently isolated
buffers end up right back on the LRU once they are released, because
->b_lru_ref remains elevated. Therefore, this patch essentially fixes
that circuitous route by leaving them on the LRU as originally intended.
Otherwise this looks Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for sending the patch.

Brian

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

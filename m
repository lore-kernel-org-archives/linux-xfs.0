Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42145 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753689AbdAaAam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2017 19:30:42 -0500
Date: Mon, 30 Jan 2017 16:30:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/14] xfs: use atomic_dec_not_zero()
Message-ID: <20170131003033.GD9134@birch.djwong.org>
References: <20170130184844.19290-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170130184844.19290-1-fabf@skynet.be>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Fabian Frederick <fabf@skynet.be>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jan 30, 2017 at 07:48:44PM +0100, Fabian Frederick wrote:
> instead of atomic_add_unless(value, -1, 0)
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/xfs/xfs_buf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ac3b4db..51b2167 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1684,7 +1684,7 @@ xfs_buftarg_isolate(
>  	 * zero. If the value is already zero, we need to reclaim the
>  	 * buffer, otherwise it gets another trip through the LRU.
>  	 */
> -	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
> +	if (!atomic_dec_not_zero(&bp->b_lru_ref)) {

Hard to tell if this is correct, since there's no atomic_dec_not_zero
defined in any of my kernel trees' include/ headers and I haven't seen a
patch adding such a symbol appear on this list.  Did you hoist the
lib/fault-inject.c definition or something?

--D

>  		spin_unlock(&bp->b_lock);
>  		return LRU_ROTATE;
>  	}
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

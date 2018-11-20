Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52438 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbeKUJSK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 04:18:10 -0500
Date: Tue, 20 Nov 2018 14:46:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/7] xfs: uncached buffer tracing needs to print bno
Message-ID: <20181120224634.GF6792@magnolia>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181119210459.8506-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119210459.8506-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 08:04:54AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Useless:
> 
> xfs_buf_get_uncached: dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
> xfs_buf_unlock:       dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
> xfs_buf_submit:       dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
> xfs_buf_hold:         dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
> xfs_buf_iowait:       dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
> xfs_buf_iodone:       dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
> xfs_buf_iowait_done:  dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
> xfs_buf_rele:         dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
> 
> Useful:
> 
> 
> xfs_buf_get_uncached: dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
> xfs_buf_unlock:       dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
> xfs_buf_submit:       dev 253:32 bno 0x200b5 nblks 0x1 ...
> xfs_buf_hold:         dev 253:32 bno 0x200b5 nblks 0x1 ...
> xfs_buf_iowait:       dev 253:32 bno 0x200b5 nblks 0x1 ...
> xfs_buf_iodone:       dev 253:32 bno 0x200b5 nblks 0x1 ...
> xfs_buf_iowait_done:  dev 253:32 bno 0x200b5 nblks 0x1 ...
> xfs_buf_rele:         dev 253:32 bno 0x200b5 nblks 0x1 ...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trace.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 3043e5ed6495..8a6532aae779 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -280,7 +280,10 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = bp->b_target->bt_dev;
> -		__entry->bno = bp->b_bn;
> +		if (bp->b_bn == XFS_BUF_DADDR_NULL)
> +			__entry->bno = bp->b_maps[0].bm_bn;
> +		else
> +			__entry->bno = bp->b_bn;
>  		__entry->nblks = bp->b_length;
>  		__entry->hold = atomic_read(&bp->b_hold);
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
> -- 
> 2.19.1
> 

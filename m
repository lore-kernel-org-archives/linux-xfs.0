Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:5444 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935315AbeFMWIe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jun 2018 18:08:34 -0400
Date: Thu, 14 Jun 2018 08:08:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/2] xfs: use sync buffer I/O for sync delwri queue
 submission
Message-ID: <20180613220807.GG10363@dastard>
References: <20180613110516.65494-1-bfoster@redhat.com>
 <20180613110516.65494-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180613110516.65494-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 13, 2018 at 07:05:16AM -0400, Brian Foster wrote:
> If a delwri queue occurs of a buffer that sits on a delwri queue
> wait list, the queue sets _XBF_DELWRI_Q without changing the state
> of ->b_list. This occurs, for example, if another thread beats the
> current delwri waiter thread to the buffer lock after I/O
> completion. Once the waiter acquires the lock, it removes the buffer
> from the wait list and leaves a buffer with _XBF_DELWRI_Q set but
> not populated on a list. This results in a lost buffer submission
> and in turn can result in assert failures due to _XBF_DELWRI_Q being
> set on buffer reclaim or filesystem lockups if the buffer happens to
> cover an item in the AIL.
> 
> This problem has been reproduced by repeated iterations of xfs/305
> on high CPU count (28xcpu) systems with limited memory (~1GB). Dirty
> dquot reclaim races with an xfsaild push of a separate dquot backed
> by the same buffer such that the buffer sits on the reclaim wait
> list at the time xfsaild attempts to queue it. Since the latter
> dquot has been flush locked but the underlying buffer not submitted
> for I/O, the dquot pins the AIL and causes the filesystem to
> livelock.
> 
> This race is essentially made possible by the buffer lock cycle
> involved with waiting on a synchronous delwri queue submission.
> Close the race by using synchronous buffer I/O for respective delwri
> queue submission. This means the buffer remains locked across the
> I/O and so is inaccessible from other contexts while in the
> intermediate wait list state. The sync buffer I/O wait mechanism is
> factored into a helper such that sync delwri buffer submission and
> serialization are batched operations.
> 
> Designed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---

Just something I noticed on a initial brief scan:

> @@ -2013,21 +2017,22 @@ xfs_buf_delwri_submit_buffers(
>  		trace_xfs_buf_delwri_split(bp, _RET_IP_);
>  
>  		/*
> -		 * We do all IO submission async. This means if we need
> -		 * to wait for IO completion we need to take an extra
> -		 * reference so the buffer is still valid on the other
> -		 * side. We need to move the buffer onto the io_list
> -		 * at this point so the caller can still access it.
> +		 * If we have a wait list, each buffer (and associated delwri
> +		 * queue reference) transfers to it and is submitted
> +		 * synchronously. Otherwise, drop the buffer from the delwri
> +		 * queue and submit async.
>  		 */
>  		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_WRITE_FAIL);
> -		bp->b_flags |= XBF_WRITE | XBF_ASYNC;
> +		bp->b_flags |= XBF_WRITE;
>  		if (wait_list) {
> -			xfs_buf_hold(bp);
> +			bp->b_flags &= ~XBF_ASYNC;
>  			list_move_tail(&bp->b_list, wait_list);
> -		} else
> +			__xfs_buf_submit(bp);

We lose a buffer submission tracepoint here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

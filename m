Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3PIYJU2223849 for <xfs@oss.sgi.com>; Wed, 25 Apr 2012 13:34:19 -0500
Message-ID: <4F9843A7.4010000@sgi.com>
Date: Wed, 25 Apr 2012 13:34:15 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 09/37] xfs: on-stack delayed write buffer lists
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-10-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/23/12 00:58, Dave Chinner wrote:
> From: Christoph Hellwig<hch@infradead.org>
>
> Queue delwri buffers on a local on-stack list instead of a per-buftarg one,
> and write back the buffers per-process instead of by waking up xfsbufd.
>
> This is now easily doable given that we have very few places left that write
> delwri buffers:
>
>   - log recovery:
> 	Only done at mount time, and already forcing out the buffers
> 	synchronously using xfs_flush_buftarg
>
>   - quotacheck:
> 	Same story.
>
>   - dquot reclaim:
> 	Writes out dirty dquots on the LRU under memory pressure.  We might
> 	want to look into doing more of this via xfsaild, but it's already
> 	more optimal than the synchronous inode reclaim that writes each
> 	buffer synchronously.
>
>   - xfsaild:
> 	This is the main beneficiary of the change.  By keeping a local list
> 	of buffers to write we reduce latency of writing out buffers, and
> 	more importably we can remove all the delwri list promotions which
> 	were hitting the buffer cache hard under sustained metadata loads.
>
> The implementation is very straight forward - xfs_buf_delwri_queue now gets
> a new list_head pointer that it adds the delwri buffers to, and all callers
> need to eventually submit the list using xfs_buf_delwi_submit or
> xfs_buf_delwi_submit_nowait.  Buffers that already are on a delwri list are
> skipped in xfs_buf_delwri_queue, assuming they already are on another delwri
> list.  The biggest change to pass down the buffer list was done to the AIL
> pushing. Now that we operate on buffers the trylock, push and pushbuf log
> item methods are merged into a single push routine, which tries to lock the
> item, and if possible add the buffer that needs writeback to the buffer list.
> This leads to much simpler code than the previous split but requires the
> individual IOP_PUSH instances to unlock and reacquire the AIL around calls
> to blocking routines.
>
> Given that xfsailds now also handle writing out buffers, the conditions for
> log forcing and the sleep times needed some small changes.  The most
> important one is that we consider an AIL busy as long we still have buffers
> to push, and the other one is that we do increment the pushed LSN for
> buffers that are under flushing at this moment, but still count them towards
> the stuck items for restart purposes.  Without this we could hammer on stuck
> items without ever forcing the log and not make progress under heavy random
> delete workloads on fast flash storage devices.
>
> [ Dave Chinner:
> 	- rebase on previous patches.
> 	- improved comments for XBF_DELWRI_Q handling
> 	- fix XBF_ASYNC handling in queue submission (test 106 failure)
> 	- rename delwri submit function buffer list parameters for clarity
> 	- xfs_efd_item_push() should return XFS_ITEM_PINNED ]
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 95A377CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 18:24:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F0687AC001
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 16:24:16 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	40dwAZREsInSDz4k for <xfs@oss.sgi.com>;
	Mon, 22 Aug 2016 16:24:13 -0700 (PDT)
Date: Tue, 23 Aug 2016 09:24:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: close xfs_wait_buftarg() race with buffer lookups
Message-ID: <20160822232410.GW19025@dastard>
References: <1471883461-27407-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471883461-27407-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 22, 2016 at 12:31:01PM -0400, Brian Foster wrote:
> xfs_wait_buftarg() is invoked on unmount and filesystem freeze to drain and
> free the buffer LRU. We have reports of filesystem freeze hangs with the
> following call chain:
> 
>   ->xfs_wait_buftarg()
>     ->xfs_log_quiesce()
>       ->xfs_quiesce_attr()
>         ->xfs_fs_freeze()
>           ...
> 
> This hang can reproduced with a long enough running fsstress instance
> running in parallel with a tight freeze/unfreeze loop. The cause of the
> hang is racing b_hold updates between xfs_wait_buftarg() and
> _xfs_buf_lookup(). Specifically, buftarg wait path checks whether a
> buffer has a >1 b_hold count to determine whether to skip the buffer.
> If b_hold == 1, xfs_wait_buftarg_rele() proceeds to prepare the buffer
> for the final removal and ultimately calls xfs_buf_rele() to drop the
> LRU reference.

So, dumb question: why are we reclaiming the entire buffer cache
when the filesystem is being frozen?

> The problem is that _xfs_buf_find() can acquire a b_hold reference any
> time after xfs_buftarg_wait_rele() has decided it has the only remaining
> reference. If this occurs, xfs_wait_buftarg() drops the LRU reference,
> but the xfs_buf_rele() instance doesn't actually remove the buffer from
> the LRU due to the _xfs_buf_find() hold.

Right.


> At this point b_hold == 1, yet
> the buffer is held via the _xfs_buf_find() codepath and still remains on
> the LRU.  Both call chains will ultimately call xfs_buf_rele() on a
> buffer with b_hold == 1.

I don't follow your logic here? We've gone form a count of 2 (i.e.
lru + racing lookup) to a count of 1 by dropping the LRU hold count,
but now you're saying that both the find and lru still need to call
xfs_buf_rele()? I'm clearly missing something here - how do we get
to a hold count of 1 here without dropping a reference twice?

(I wrote this to analisys is so I'll leave it here for discussion
purposes).

The code paths are:

Freeze process			lookup process

xfs_buftarg_wait
<lru>
xfs_buftarg_wait_rele()
b_hold = 1
lock(b_lock)
b_lru_ref = 0
XFS_BSTATE_DISPOSE
move to dispose list
unlock(b_lock)
.....
				_xfs_buf_find()
				<finds buffer>
				atomic_inc(b_hold)	//hold count = 2
				.....
walks dispose list
xfs_buf_rele()
atomic_dec(b_hold)					//hold count = 1
release == false
<does nothing>

				b_lru_ref set to non-zero
				.....
				xfs_buf_rele()
				atomic_dec(b_hold)	// hold_count = 0
				!stale, b_lru_ref > 0
				add back to LRU,
				atomic_inc(b_hold)	// hold_count = 1
				~XFS_BSTATE_DISPOSE


So where does the hold count become 1 while both still need to call
xfs_buf_rele()?

> Update xfs_buftarg_wait_rele() to properly synchronize the LRU drain
> against buffer lookups. Atomically decrement and lock the perag
> associated with the buffer to lock out buffer lookups before
> xfs_wait_buftarg() determines whether the LRU holds the final reference.
> Open code freeing of the buffer so we can remove it from the perag
> rbtree before the perag lock is dropped and guarantee it cannot be
> looked up once freeing is imminent. Also update xfs_buftarg_wait_rele()
> to drop and reacquire the lru_lock in the correct order to avoid
> deadlocks with LRU insertion.

While this is a solution, I don't yet understand the reace being
solved, so I can't comment on whether it's the best solution or not.
It doesn't happen at unmount because there can't be racing lookups
occurring at that point in unmount, so it comes back to this
question: why are we invalidating the entire LRU on freeze?

We really only need to wait for IO to completei during freeze,
right?  i.e.  xfs-wait_buftarg() is doing 2 things: the first is
waiting for outstanding IO to complete, and the other is reclaiming
the LRU. And for freeze, we don't need to do the second?

So if we stop trying to reclaim the buffer cache on freeze, then the
whole lookup vs forced reclaim problem will go away?

> Second, I believe we still have an independent freeze hang upstream due
> to an issue with how we use drain_workqueue(). Specifically, I see the
> following warning from kernel/workqueue.c:__queue_work():
> 
> 	if (unlikely(wq->flags & __WQ_DRAINING) &&
> 	    WARN_ON_ONCE(!is_chained_work(wq)))
> 		return;

Using flush_workqueue() would solve that problem. We've already
guaranteed for unmount that there isn't any new incoming work. i.e:

        while (percpu_counter_sum(&btp->bt_io_count)) {
		delay(100);
		flush_workqueue(btp->bt_mount->m_buf_workqueue);
	}
	flush_workqueue(btp->bt_mount->m_buf_workqueue);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5118 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725841AbeJKFGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 01:06:47 -0400
Date: Thu, 11 Oct 2018 08:42:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix use-after-free race in xfs_buf_rele
Message-ID: <20181010214239.GM6311@dastard>
References: <20181009220044.5539-1-david@fromorbit.com>
 <20181010131949.GA53848@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181010131949.GA53848@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 09:19:51AM -0400, Brian Foster wrote:
> On Wed, Oct 10, 2018 at 09:00:44AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When looking at a 4.18 based KASAN use after free report, I noticed
> > that racing xfs_buf_rele() may race on dropping the last reference
> > to the buffer and taking the buffer lock. This was the symptom
> > displayed by the KASAN report, but the actual issue that was
> > reported had already been fixed in 4.19-rc1 by commit e339dd8d8b04
> > ("xfs: use sync buffer I/O for sync delwri queue submission").
> > 
> 
> Are you saying that the KASAN report reflected the delwri queue race and
> the rele() issue was discovered by inspection, or that the KASAN report
> occurred with the delwri queue fix already in place? Or IOW, has this
> been reproduced?

Neither. The KASAN report exposed the rele() race on 4.18, but the
code that exposed the race was modified in 4.19 so it was not
susceptible to the race condition.

i.e. the old delwri code had the condition that the async io
completion could drop the IO reference at the same that the delwri
queue waiting code would drop it's reference. Basically, it was

IO completion			delwri wait for complation
				lock
xfs_buf_relse()
  unlock
    wakeup waiter
				xfs_buf_relse
				  unlock
  xfs_buf_rele()		  xfs_buf_rele()

And the two of them then race for the last reference and bp->b_lock.

This can happen anywhere there are two concurrent xfs_buf_rele()
calls. That's not common because most buffer access are serialised
by the bp->b_sema, but the above is an example of how waiting on
IO completion by just locking the buffer can trigger it...

> > Despite this, I think there is still an issue with xfs_buf_rele()
> > in this code:
> > 
> > 
> >         release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
> >         spin_lock(&bp->b_lock);
> >         if (!release) {
> > .....
> > 
> > If two threads race on the b_lock after both dropping a reference
> > and one getting dropping the last reference so release = true, we
> > end up with:
> > 
> > 
> > CPU 0				CPU 1
> > atomic_dec_and_lock()
> > 				atomic_dec_and_lock()
> > 				spin_lock(&bp->b_lock)
> > spin_lock(&bp->b_lock)
> > <spins>
> 
> Ok, so CPU0 drops one ref and returns, CPU1 drops the last ref, acquires
> ->b_pag_lock, returns and wins the race to ->b_lock. The latter bit
> basically means the final reference cleanup executes before the previous
> reference drop gets to acquire ->b_lock. CPU1 releases ->b_lock and the
> race is on between freeing the buffer and processing the intermediate
> release.
> 
> I suppose this makes sense because ->b_pag_lock is only acquired on the
> final release. Therefore, ->b_lock is the real serialization point as
> far as xfs_buf_rele() is concerned.

Yes, that's pretty much the issue here.

> > 				<release = true bp->b_lru_ref = 0>
> > 				<remove from lists>
> > 				freebuf = true
> > 				spin_unlock(&bp->b_lock)
> > 				xfs_buf_free(bp)
> > <gets lock, reading and writing freed memory>
> > <accesses freed memory>
> > spin_unlock(&bp->b_lock) <reads/writes freed memory>
> > 
> > IOWs, we can't safely take bp->b_lock after dropping the hold
> > reference because the buffer may go away at any time after we
> > drop that reference. However, this can be fixed simply by taking the
> > bp->b_lock before we drop the reference.
> > 
> > It is safe to nest the pag_buf_lock inside bp->b_lock as the
> > pag_buf_lock is only used to serialise against lookup in
> > xfs_buf_find() and no other locks are held over or under the
> > pag_buf_lock there. Make this clear by documenting the buffer lock
> > orders at the top of the file.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Looks reasonable enough to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC4AD7F4E
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 15:59:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C9D18F8039
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 13:59:39 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	k2fYKZJULA2EXHiz for <xfs@oss.sgi.com>;
	Wed, 30 Jan 2013 13:59:37 -0800 (PST)
Date: Thu, 31 Jan 2013 08:59:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 0/2] fix spinlock recursion on xa_lock in
	xfs_buf_item_push
Message-ID: <20130130215934.GB32297@disturbed.disaster>
References: <1359492157-30521-1-git-send-email-bfoster@redhat.com>
	<20130130060551.GG7255@disturbed.disaster>
	<5109291E.6090303@sgi.com> <51094423.8000703@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51094423.8000703@redhat.com>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Jan 30, 2013 at 11:02:43AM -0500, Brian Foster wrote:
> (added Dave and the list back on CC)
> 
> On 01/30/2013 09:07 AM, Mark Tinguely wrote:
> > On 01/30/13 00:05, Dave Chinner wrote:
> >> On Tue, Jan 29, 2013 at 03:42:35PM -0500, Brian Foster wrote:
> ...
> > 
> >> So essentially what is happening here is that we are trying to lock
> >> a stale buffer in the AIL to flush it. Well, we can't flush it from
> >> the AIL, and indeed the next line of code is this:
> >>
> >>     if (!xfs_buf_trylock(bp))
> >>         return XFS_ITEM_LOCKED;
> >>
> >>>>>>>     ASSERT(!(bip->bli_flags&  XFS_BLI_STALE));
> >>
> >> The only reason this ASSERT is not firing is that we are failing to
> >> lock stale buffers. Hence we are relying on the failed lock to force
> >> the log, instead of detecting that we need to force the log after we
> >> drop the AIL lock and letting the caller handle it.
> >>
> >> So, wouldn't a better solution be to do something like simply like:
> >>
> >> +    if (bp->b_flags&  XBF_STALE)
> >> +        return XFS_ITEM_PINNED;
> >> +
> >>     if (!xfs_buf_trylock(bp))
> >>         return XFS_ITEM_LOCKED;
> ...
> > 
> 
> Thanks guys. This certainly looks nicer than messing with the lock
> wrapper, but is it susceptible to the same problem? In other words, does
> this fix the problem or just tighten the window?

That's what I need to think about more - the only difference here is
that we are checking the flag before the down_trylock() instead of
after....

> So if the buf lock covers the pinned state (e.g., buffer gets locked,
> added to a transaction, the transaction gets committed and pins and
> unlocks the buffer, IIUC) and the stale state (buf gets locked, added to
> a new transaction and inval'd before the original transaction was
> written ?), but we don't hold the buf lock in xfs_buf_item_push(), how
> can we guarantee the state of either doesn't change between the time we
> check the flags and the time the lock fails?

... but the order of them being set and checked may be significant
and hence checking the stale flag first might be sufficient to avoid
the pin count race and hence the log force. Hence this might just
need a pair of memory barriers - one here and one in xfs_buf_stale()
- to ensure that we always see the XBF_STALE flag without needing to
lock the buffer first.

> > Makes sense. It would prevent the lock recursion. The more that I think
> > about, we do not want to release xa_lock during an AIL scan.
> > 
> 
> FWIW, the other log item abstractions appear to use this model (e.g.,
> xfs_inode_item_push()), where it appears safe to drop xa_lock once the
> actual object lock/ref is acquired and reacquire xa_lock before
> returning.

Right. We can't hold the AIL while doing blocking lock operations
because the AIL lock is an innermost lock.  That's fundamentally the
cause of this problem - the trylock is doing more work that we can
allow in the context that it is being called in...

We also do not hold the AIL lock for the entire
traversal as long holds of the AIL lock result in serialisation
across the entire transaction subsystem. A successful IOP_PUSH()
typically drops and reacquires the AIL lock, but a failure doesn't.
Hence we limit the number of failed pushes under a single traversal
so that we don't spend a long time holding the lock doing no work
and instead back off and try again later....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.come

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

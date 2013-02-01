Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 37DFF7F4E
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 19:26:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AA729AC002
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 17:26:18 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6sjqQCgRLZtCrEG2 for <xfs@oss.sgi.com>;
	Thu, 31 Jan 2013 17:26:16 -0800 (PST)
Date: Fri, 1 Feb 2013 12:26:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 0/2] fix spinlock recursion on xa_lock in
	xfs_buf_item_push
Message-ID: <20130201012610.GK32297@disturbed.disaster>
References: <1359492157-30521-1-git-send-email-bfoster@redhat.com>
	<20130130060551.GG7255@disturbed.disaster>
	<5109291E.6090303@sgi.com> <51094423.8000703@redhat.com>
	<20130130215934.GB32297@disturbed.disaster>
	<510AADC5.3000305@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <510AADC5.3000305@redhat.com>
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

On Thu, Jan 31, 2013 at 12:45:41PM -0500, Brian Foster wrote:
> On 01/30/2013 04:59 PM, Dave Chinner wrote:
> > On Wed, Jan 30, 2013 at 11:02:43AM -0500, Brian Foster wrote:
> >> (added Dave and the list back on CC)
> >>
> >> On 01/30/2013 09:07 AM, Mark Tinguely wrote:
> >>> On 01/30/13 00:05, Dave Chinner wrote:
> >>>> On Tue, Jan 29, 2013 at 03:42:35PM -0500, Brian Foster wrote:
> ...
> >>
> >> Thanks guys. This certainly looks nicer than messing with the lock
> >> wrapper, but is it susceptible to the same problem? In other words, does
> >> this fix the problem or just tighten the window?
> > 
> > That's what I need to think about more - the only difference here is
> > that we are checking the flag before the down_trylock() instead of
> > after....
> > 
> >> So if the buf lock covers the pinned state (e.g., buffer gets locked,
> >> added to a transaction, the transaction gets committed and pins and
> >> unlocks the buffer, IIUC) and the stale state (buf gets locked, added to
> >> a new transaction and inval'd before the original transaction was
> >> written ?), but we don't hold the buf lock in xfs_buf_item_push(), how
> >> can we guarantee the state of either doesn't change between the time we
> >> check the flags and the time the lock fails?
> > 
> > ... but the order of them being set and checked may be significant
> > and hence checking the stale flag first might be sufficient to avoid
> > the pin count race and hence the log force. Hence this might just
> > need a pair of memory barriers - one here and one in xfs_buf_stale()
> > - to ensure that we always see the XBF_STALE flag without needing to
> > lock the buffer first.
> > 
> 
> I _think_ I follow your train of thought. If we're racing on the pin
> check, presumably the lock holder is committing the transaction and we
> should either already see the buffer being stale, being pinned or we
> should get the lock (assuming the order is: stale, pinned, unlocked).

Right, that is the order in which operations occur. Marking a buffer
stale happens in the transaction body, the pin and subsequent unlock
occur some time later during the transaction commit.

> That aside for a moment, here's some specific tracepoint (some of which
> I've hacked in) data for when the recursion occurs:
....
> ... so as expected, the buffer is marked stale, we attempt the trylock,
> the buf is pinned, we run the log force and we're dead.

*nod*

> From the looks of the trace, I'd expect an additional stale check to
> eliminate the ability to reproduce this, but that doesn't necessarily
> make it correct of course. Regardless, I'm putting that to the test now
> and letting it run for a bit while we get this sorted out.
> 
> I also need to stare at the code some more. My pending questions are:
> 
> - Is it always reasonable to to assume/consider a stale buf as pinned in
> the context of xfsaild?

A stale buffer in the AIL is either pinned (transaction committed)
or on it's way to being pinned (transaction that marked it stale is
currently in progress). When the transaction commit completes, the
IOP_UNPIN() call will remove the item from the AIL if it is the last
reference to the item.

Hence we generally do not get unpinned, stale buffers in the AIL
because the last reference to the stale buffer is usually the
transaction that marked it stale....

> - If we currently reproduce the following sequence:
> 
> A		xfsaild
> stale
> 		(!pinned) ==> trylock()
> pinned
> 		(!trylock && pinned && stale)
> 			==> xfs_log_force() (boom)
> 
> ... what prevents the following sequence from occurring sometime in the
> future or with some alternate high-level sequence of events?
> 
> A		xfsaild
> locked
> 		(!pinned && !stale) ==> trylock()
> pinned
> stale
> 		(!trylock && pinned && stale)
> 			==> xfs_log_force()

You can't get that order and trigger the race. If the item is pinned
before it is marked stale, that means we will always see pin count
because it was pinned by a previous transaction commit.

Pinning occurs on the commit of the first transaction commit that
inserts the item into the CIL. It doesn't get unpinned until the CIL
is checkpointed and inserted into the AIL. Hence the order of
operations that marks an uncommitted buffer stale should always be
lock->stale->pinned->unlock.

However, if the buffer has been previously modified and is in the
CIL, you'll see:

	lock->pinned->CIL insert->unlock.....->lock->stale->unlock

If the buffer was modified a while back and the CIL is committed, the
buffer will be in the AIL but not the CIL. If the buffer was
modified a while back, and then again recently, it will be in both
pinned in the CIL and the AIL. Neither of these cases can trigger
this problem because the pinned check will fire reliably.

Hence the specific case here is the buffer has been previously modified,
the CIL committed so it's in the AIL, and we are marking the buffer
stale as the first modification of the buffer after it was added to
the AIL. IOWs, the order that is of concern is this while the item
is in the AIL:

	lock->stale->pin->CIL insert->unlock

So in terms of the xfsaild racing and causing problems, the only case
it will occur in is this:

	Thread 1	xfsaild
	lock		xfs_buf_item_push
	....		not pinned
	stale
			trylock
			<delay>
	commit
	pin
			  if(pinned && stale)
				<splat>
	unlock

So what I was asking is whether we can do checks in the order of:

	smb_mb();
	if (stale)
		return
	if (pinned)
		return

What I've just realised is that we really don't care if we race in
xfs_buf_item_push(). The race that matters is in xfs_buf_trylock()
and at that point it is too late to avoid it.

So I think your original patch is on the right path but having the
xfsaild handle the log force gets rid of most of the nasty cruft it
had.... ie. we're going to have to tell xfs_buf_trylock() that we
should not do a log force if the lock fails, and return
XFS_ITEM_PINNED rather than XFS_ITEM_LOCKED in
xfs_buf_item_push()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

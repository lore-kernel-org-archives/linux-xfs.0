Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 26A987F52
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 10:03:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF940AC003
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 08:03:19 -0800 (PST)
Message-ID: <510BE6C0.3030506@redhat.com>
Date: Fri, 01 Feb 2013 11:01:04 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH RFC 0/2] fix spinlock recursion on xa_lock in
	xfs_buf_item_push
References: <1359492157-30521-1-git-send-email-bfoster@redhat.com>
	<20130130060551.GG7255@disturbed.disaster>
	<5109291E.6090303@sgi.com> <51094423.8000703@redhat.com>
	<20130130215934.GB32297@disturbed.disaster>
	<510AADC5.3000305@redhat.com>
	<20130201012610.GK32297@disturbed.disaster>
In-Reply-To: <20130201012610.GK32297@disturbed.disaster>
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
To: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com, david@fromorbit.com

On 01/31/2013 08:26 PM, Dave Chinner wrote:
> On Thu, Jan 31, 2013 at 12:45:41PM -0500, Brian Foster wrote:
>> On 01/30/2013 04:59 PM, Dave Chinner wrote:
>>> On Wed, Jan 30, 2013 at 11:02:43AM -0500, Brian Foster wrote:
>>>> (added Dave and the list back on CC)
>>>>
>>>> On 01/30/2013 09:07 AM, Mark Tinguely wrote:
>>>>> On 01/30/13 00:05, Dave Chinner wrote:
>>>>>> On Tue, Jan 29, 2013 at 03:42:35PM -0500, Brian Foster wrote:
...
>> ... what prevents the following sequence from occurring sometime in the
>> future or with some alternate high-level sequence of events?
>>
>> A		xfsaild
>> locked
>> 		(!pinned && !stale) ==> trylock()
>> pinned
>> stale
>> 		(!trylock && pinned && stale)
>> 			==> xfs_log_force()
> 
> You can't get that order and trigger the race. If the item is pinned
> before it is marked stale, that means we will always see pin count
> because it was pinned by a previous transaction commit.
> 

Ok, so if we're seeing the pin count race, we have a buffer that is
obviously in the ail and we're racing with another transaction commit on
the buffer. This means the buf is either (!pinned && locked), (pinned &&
locked) or (pinned && !locked). The first two cases imply that if the
buf is stale, it is marked stale by this transaction, or as you point
out, by a previous transaction (because it would have required the lock).

If we suppose it is possible for the buf to go from (!pinned && locked)
to (pinned && !locked) after the trylock fails but before the log force
check, what I'm not quite following is what would prevent some third
thread (I guess my diagram was wrong to only include xfsaild and thread
A) to squeeze in there and set the buf stale? For example, I was looking
at xfs_buf_iodone_callbacks() and the forced shutdown check (is the bp
always locked here?).

> Pinning occurs on the commit of the first transaction commit that
> inserts the item into the CIL. It doesn't get unpinned until the CIL
> is checkpointed and inserted into the AIL. Hence the order of
> operations that marks an uncommitted buffer stale should always be
> lock->stale->pinned->unlock.
> 
> However, if the buffer has been previously modified and is in the
> CIL, you'll see:
> 
> 	lock->pinned->CIL insert->unlock.....->lock->stale->unlock
> 
> If the buffer was modified a while back and the CIL is committed, the
> buffer will be in the AIL but not the CIL. If the buffer was
> modified a while back, and then again recently, it will be in both
> pinned in the CIL and the AIL. Neither of these cases can trigger
> this problem because the pinned check will fire reliably.
> 
> Hence the specific case here is the buffer has been previously modified,
> the CIL committed so it's in the AIL, and we are marking the buffer
> stale as the first modification of the buffer after it was added to
> the AIL. IOWs, the order that is of concern is this while the item
> is in the AIL:
> 
> 	lock->stale->pin->CIL insert->unlock
> 
> So in terms of the xfsaild racing and causing problems, the only case
> it will occur in is this:
> 
> 	Thread 1	xfsaild
> 	lock		xfs_buf_item_push
> 	....		not pinned
> 	stale
> 			trylock
> 			<delay>
> 	commit
> 	pin
> 			  if(pinned && stale)
> 				<splat>
> 	unlock
> 

Ok, thanks for the context.

> So what I was asking is whether we can do checks in the order of:
> 
> 	smb_mb();
> 	if (stale)
> 		return
> 	if (pinned)
> 		return
> 

Right...

> What I've just realised is that we really don't care if we race in
> xfs_buf_item_push(). The race that matters is in xfs_buf_trylock()
> and at that point it is too late to avoid it.
> 
> So I think your original patch is on the right path but having the
> xfsaild handle the log force gets rid of most of the nasty cruft it
> had.... ie. we're going to have to tell xfs_buf_trylock() that we
> should not do a log force if the lock fails, and return
> XFS_ITEM_PINNED rather than XFS_ITEM_LOCKED in
> xfs_buf_item_push()....
> 

... and that's the bit I wasn't so sure about. If it's Ok to pend up the
log force as such, the xfs_buf_item_push() part can be made cleaner
(xfs_buf_trylock() is still uglified with the new parameter). I'll start
testing something like that and follow up with a new set if it addresses
the problem and survives some sanity testing. Thanks.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

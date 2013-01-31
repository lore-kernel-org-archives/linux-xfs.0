Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7882F7F4E
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 11:42:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 660EC304048
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 09:42:47 -0800 (PST)
Message-ID: <510AADC5.3000305@redhat.com>
Date: Thu, 31 Jan 2013 12:45:41 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH RFC 0/2] fix spinlock recursion on xa_lock in
	xfs_buf_item_push
References: <1359492157-30521-1-git-send-email-bfoster@redhat.com>
	<20130130060551.GG7255@disturbed.disaster>
	<5109291E.6090303@sgi.com> <51094423.8000703@redhat.com>
	<20130130215934.GB32297@disturbed.disaster>
In-Reply-To: <20130130215934.GB32297@disturbed.disaster>
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

On 01/30/2013 04:59 PM, Dave Chinner wrote:
> On Wed, Jan 30, 2013 at 11:02:43AM -0500, Brian Foster wrote:
>> (added Dave and the list back on CC)
>>
>> On 01/30/2013 09:07 AM, Mark Tinguely wrote:
>>> On 01/30/13 00:05, Dave Chinner wrote:
>>>> On Tue, Jan 29, 2013 at 03:42:35PM -0500, Brian Foster wrote:
...
>>
>> Thanks guys. This certainly looks nicer than messing with the lock
>> wrapper, but is it susceptible to the same problem? In other words, does
>> this fix the problem or just tighten the window?
> 
> That's what I need to think about more - the only difference here is
> that we are checking the flag before the down_trylock() instead of
> after....
> 
>> So if the buf lock covers the pinned state (e.g., buffer gets locked,
>> added to a transaction, the transaction gets committed and pins and
>> unlocks the buffer, IIUC) and the stale state (buf gets locked, added to
>> a new transaction and inval'd before the original transaction was
>> written ?), but we don't hold the buf lock in xfs_buf_item_push(), how
>> can we guarantee the state of either doesn't change between the time we
>> check the flags and the time the lock fails?
> 
> ... but the order of them being set and checked may be significant
> and hence checking the stale flag first might be sufficient to avoid
> the pin count race and hence the log force. Hence this might just
> need a pair of memory barriers - one here and one in xfs_buf_stale()
> - to ensure that we always see the XBF_STALE flag without needing to
> lock the buffer first.
> 

I _think_ I follow your train of thought. If we're racing on the pin
check, presumably the lock holder is committing the transaction and we
should either already see the buffer being stale, being pinned or we
should get the lock (assuming the order is: stale, pinned, unlocked).

That aside for a moment, here's some specific tracepoint (some of which
I've hacked in) data for when the recursion occurs:

      xfsalloc/5-3220  [005]  4304.223158: xfs_buf_item_stale: dev 253:3
bno 0x847feb28 len 0x1000 hold 2 pincount 0 lock 0 flags
|MAPPED|ASYNC|DONE|STALE|PAGES recur 0 refcount 1 bliflags |DIRTY|STALE
lidesc 0xffff88067ada5610 liflags IN_AIL
 smallfile_cli.p-3702  [007]  4304.223209: xfs_buf_item_format_stale:
dev 253:3 bno 0x847feb28 len 0x1000 hold 2 pincount 0 lock 0 flags
|MAPPED|ASYNC|DONE|STALE|PAGES recur 0 refcount 1 bliflags |STALE lidesc
0xffff88067ada5610 liflags IN_AIL
...
xfsaild/dm-3-3695  [002]  4304.223217: xfs_buf_item_trylock: dev 253:3
bno 0x847feb28 len 0x1000 hold 2 pincount 1 lock 0 flags
|MAPPED|ASYNC|DONE|STALE|PAGES recur 0 refcount 1 bliflags |STALE lidesc
0xffff88067ada5610 liflags IN_AIL
 smallfile_cli.p-3702  [007]  4304.223217: xfs_buf_item_pin: dev 253:3
bno 0x847feb28 len 0x1000 hold 2 pincount 0 lock 0 flags
|MAPPED|ASYNC|DONE|STALE|PAGES recur 0 refcount 1 bliflags |STALE lidesc
0xffff88067ada5610 liflags IN_AIL
...
    xfsaild/dm-3-3695  [002]  4304.223219: xfs_buf_cond_lock_log_force:
dev 253:3 bno 0x847feb28 len 0x1000 hold 2 pincount 1 lock 0 flags
MAPPED|ASYNC|DONE|STALE|PAGES caller xfs_buf_item_trylock

[NOTES:
 - I moved xfs_buf_item_trylock up to after the pinned check but before
the trylock.
 - xfs_buf_item_stale() is in xfs_trans_binval(). This was an oversight,
as I was looking at bli_flags, but still illustrates the sequence.]

... so as expected, the buffer is marked stale, we attempt the trylock,
the buf is pinned, we run the log force and we're dead.

>From the looks of the trace, I'd expect an additional stale check to
eliminate the ability to reproduce this, but that doesn't necessarily
make it correct of course. Regardless, I'm putting that to the test now
and letting it run for a bit while we get this sorted out.

I also need to stare at the code some more. My pending questions are:

- Is it always reasonable to to assume/consider a stale buf as pinned in
the context of xfsaild?
- If we currently reproduce the following sequence:

A		xfsaild
stale
		(!pinned) ==> trylock()
pinned
		(!trylock && pinned && stale)
			==> xfs_log_force() (boom)

... what prevents the following sequence from occurring sometime in the
future or with some alternate high-level sequence of events?

A		xfsaild
locked
		(!pinned && !stale) ==> trylock()
pinned
stale
		(!trylock && pinned && stale)
			==> xfs_log_force()

Granted the window is seriously tight, but is there some crazy sequence
where we could race with the pin count and the stale state? E.g., I
notice some error or forced shutdown sequences mark buffers as stale, etc.

Brian

...
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

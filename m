Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Sep 2008 23:50:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8T6odb9006660
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 23:50:39 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D04AF490BB2
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 23:52:14 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id SHpSTEiT3b8FiwsU for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 23:52:14 -0700 (PDT)
Date: Mon, 29 Sep 2008 16:51:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Running out of reserved data blocks
Message-ID: <20080929065152.GB16064@disturbed>
References: <48DC73AB.4050309@sgi.com> <20080926070831.GM27997@disturbed> <48DC9306.104@sgi.com> <20080926084814.GD13705@disturbed> <48E040FA.9090709@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E040FA.9090709@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 29, 2008 at 12:44:10PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Fri, Sep 26, 2008 at 05:45:10PM +1000, Lachlan McIlroy wrote:
>>> Dave Chinner wrote:
>>>> On Fri, Sep 26, 2008 at 03:31:23PM +1000, Lachlan McIlroy
>>>> wrote:
>>>>> A while back I posted a patch to re-dirty pages on I/O error
>>>>> to handle errors from xfs_trans_reserve() that was failing
>>>>> with ENOSPC when trying to convert delayed allocations.  I'm
>>>>> now seeing xfs_trans_reserve() fail when converting unwritten
>>>>> extents and in that case we silently ignore the error and
>>>>> leave the extent as unwritten which effectively causes data
>>>>> corruption.  I can also get failures when trying to unreserve
>>>>> disk space.
>>>> Is this problem being seen in the real world, or just in
>>>> artificial test workloads?
>>> Customer escalations.
>>
>> And the main cause is what? Direct I/O into unwritten extents?
> The system is so busy that it's overwhelming the bandwidth of the
> log and many threads have taken a slice of the reserved pool and
> are waiting for log space. 

By that I assume you mean that there are lots of threads waiting
in xlog_state_get_iclog_space()?

> Extent conversions start failing and we invalidate the page but
> fail to remove the delayed allocation.

IIUC, you are trying to say that delayed allocation is failing with
ENOSPC in xfs_iomap_write_allocate(), and everything goes downhill
from there?

Perhaps we shuld propagate the "BMAPI_TRYLOCK" flag into
xfs_iomap_write_allocate() and convert ENOSPC errors from
xfs_trans_reserve() into EAGAIN for non-blocking writeback. That
means any sort of synchronous write will propagate an error, but
async writeback (like pdflush) will simply treat the condition the
same as inode lock contention.

Hence issuing something like a fsync() or sync(1) will cause ENOSPC 
errors to be triggered on delalloc in this situation, but async
writeback won't. In the case of a direct I/O read, it should get an
ENOSPC error reported back instead of.....

> Then a direct I/O read
> runs into a delayed allocation where it does not expect one and
> hits a BUG_ON().

.... doing that.

>>>> If you start new operations like writing into unwritten extents once
>>>> you are already at ENOSPC, then you can consume the entire of the
>>>> reserve pool. There is nothing we can do to prevent that from
>>>> occurring, except by doing something like partially freezing the
>>>> filesystem (i.e. just the data write() level, not the transaction
>>>> level) until the ENOSPC condition goes away....
>>> Yes we could eat into the reserve pool with btree split/newroot
>>> allocations.  Same with delayed allocations. That's yet another
>>> problem where we need to account for potential btree space before
>>> creating delayed allocations or unwritten extents.
>>
>> It's the same problem - allocation can cause consumption of
>> blocks in the BMBT tree. At ENOSPC, it's not the allocbt that
>> is being split or consuming blocks...
>>
>> Metadata block allocation due to delayed data allocation is bound by
>> memory size and dirty page limits - once we get to ENOSPC, there
>> will be no more pages accepted for delayed allocation - the app will
>> get an ENOSPC up front. The reserved pool needs to be larger enough
>> to handle all the allocations that this dirty data can trigger.
>> Easily solved by bumping the tunable for large mmory systems.
> Yep, but how high do we bump it?

Not sure. It sounds like the problem is the number of transactions
that can be in flight at once, each taking their 4-8 blocks of
reservation out of the pool, and then blocking for some period of
time waiting for iclog space to be able to commit the transaction.

Given that the most I've previously seen is ~1500 transactions
blocked waiting for iclog space, I'd say that gives a rough
indication of how deep the reservation pool could be bumped to....

> I've run some pathological workloads
> that can deplete a reserved pool of 16384 blocks.  While our customers
> may never run this workload their systems are much bigger than what I
> have at my disposal.  When the reserved pool depletes I would rather
> have the system degrade performance than cause data corruption or panic.

Right, so would I. The problem is how to do it without introducing
excessive complexity.

> In other words if we can find a solution to safely handle a depleted
> reserved pool (even if it means taking a performance hit) rather than
> hope it never happens I would like to hear about it.

I think what I mentioned above might prevent the common case of the
problem you are seeing. It doesn't fix the "depletion by a thousand
unwritten extent conversion" problem, but it should prevent the
silent trashing of delalloc data due to temporary reserve pool
depletion....

>> FWIW, determining the number of blocks to reserve for delayed
>> allocation during delayed allocation is not worth the complexity.
>> You don't know how many extents the data will end up in, you don't
>> know what order the pages might get written in so you could have
>> worst case sparse page writeout before the holes are filled (i.e.
>> have tree growth and then have it shrink), etc. Even reserving
>> enough blocks for a full btree split per dirtied inode is not
>> sufficient, as allocation may trigger multiple full tree splits.
>> Basically the reservations will get so large that they will cause
>> applications to get premature ENOSPC errors when the writes could
>> have succeeded without problems.
> I totally agree.  If only there was some way to know what was going
> to happen to the btree during writeout we could account for the space.
> We could disable delayed allocations when the filesystem is near ENOSPC
> and do immediate allocations like in direct I/O.

Define "near ENOSPC" ;)

[ Well, I already have once. ;) The incore per-cpu superblock
counters fall back to updating the global superblock when the
filesystem approaches ENOSPC (per-cpu threshold, so scales with the
size of machine), but you'd effectively need to flush all the
delalloc data at this point as well if you were to switch of
delalloc.... ]

I guess just switching to sync writes when we near ENOSPC would
do what you are suggesting...

>> For the unwritten extent conversion case, though, we need to
>> prevent new writes (after ENOSPC occurs) from draining the
>> reserved pool. That means we either have to return an ENOSPC
>> to the application, or we freeze the writes into preallocated
>> space when we are at ENOSPC and the reserve pool is getting
>> depleted. This needs to be done up-front, not in the I/O completion
>> where it is too late to handle the fact that the reserve pool
>> too depleted to do the conversion.....
>>
>> That seems simple enough to do without having to add any code
>> to the back end I/O path or the transaction subsystem....
> Sounds reasonable.  We could report ENOSPC for an extent conversion that
> could work - ie if a split is not needed and users might get a little
> confused with ENOSPC if they know they preallocated the space.  But it's
> better than data corruption.

Certainly is ;)

> What if we were to do the unwritten extent conversion up front?

Crash after conversion but before the data I/O is issued then
results in stale data exposure. Not a good failure mode.

> Could
> we delay the transaction commit until after the I/O or will that mean
> holding an ilock across the I/O?

Right - that's not allowed. To do something like this, it would need
to be a two-phase transaction commit. That is, we do all the work
up front before the I/O, then commit that transaction as "pending".
Then on I/O completion we commit a subsequent "I/O done" transaction
that is paired with the coversion/allocation. Then in recovery, we
only do the conversion if we see the I/O done transaction as well.

Realistically, we should do this for all allocations to close the
allocate-crash-expose-stale-data hole that exists. The model for
this is the Extent Free Intent/Extent Free Done (EFI/EFD)
transaction pair and their linked log items used when freeing
extents.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

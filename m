Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Sep 2008 19:33:29 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8T2XQfB020293
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 19:33:26 -0700
Message-ID: <48E040FA.9090709@sgi.com>
Date: Mon, 29 Sep 2008 12:44:10 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Running out of reserved data blocks
References: <48DC73AB.4050309@sgi.com> <20080926070831.GM27997@disturbed> <48DC9306.104@sgi.com> <20080926084814.GD13705@disturbed>
In-Reply-To: <20080926084814.GD13705@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Fri, Sep 26, 2008 at 05:45:10PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Fri, Sep 26, 2008 at 03:31:23PM +1000, Lachlan McIlroy wrote:
>>>> A while back I posted a patch to re-dirty pages on I/O error to handle errors from
>>>> xfs_trans_reserve() that was failing with ENOSPC when trying to convert delayed
>>>> allocations.  I'm now seeing xfs_trans_reserve() fail when converting unwritten
>>>> extents and in that case we silently ignore the error and leave the extent as
>>>> unwritten which effectively causes data corruption.  I can also get failures when
>>>> trying to unreserve disk space.
>>> Is this problem being seen in the real world, or just in artificial
>>> test workloads?
>> Customer escalations.
> 
> And the main cause is what? Direct I/O into unwritten extents?
The system is so busy that it's overwhelming the bandwidth of the log and
many threads have taken a slice of the reserved pool and are waiting for
log space.  Extent conversions start failing and we invalidate the page
but fail to remove the delayed allocation.  Then a direct I/O read runs
into a delayed allocation where it does not expect one and hits a BUG_ON().

> 
>>> If you start new operations like writing into unwritten extents once
>>> you are already at ENOSPC, then you can consume the entire of the
>>> reserve pool. There is nothing we can do to prevent that from
>>> occurring, except by doing something like partially freezing the
>>> filesystem (i.e. just the data write() level, not the transaction
>>> level) until the ENOSPC condition goes away....
>> Yes we could eat into the reserve pool with btree split/newroot
>> allocations.  Same with delayed allocations. That's yet another
>> problem where we need to account for potential btree space before
>> creating delayed allocations or unwritten extents.
> 
> It's the same problem - allocation can cause consumption of
> blocks in the BMBT tree. At ENOSPC, it's not the allocbt that
> is being split or consuming blocks...
> 
> Metadata block allocation due to delayed data allocation is bound by
> memory size and dirty page limits - once we get to ENOSPC, there
> will be no more pages accepted for delayed allocation - the app will
> get an ENOSPC up front. The reserved pool needs to be larger enough
> to handle all the allocations that this dirty data can trigger.
> Easily solved by bumping the tunable for large mmory systems.
Yep, but how high do we bump it?  I've run some pathological workloads
that can deplete a reserved pool of 16384 blocks.  While our customers
may never run this workload their systems are much bigger than what I
have at my disposal.  When the reserved pool depletes I would rather
have the system degrade performance than cause data corruption or panic.
In other words if we can find a solution to safely handle a depleted
reserved pool (even if it means taking a performance hit) rather than
hope it never happens I would like to hear about it.

> 
> FWIW, determining the number of blocks to reserve for delayed
> allocation during delayed allocation is not worth the complexity.
> You don't know how many extents the data will end up in, you don't
> know what order the pages might get written in so you could have
> worst case sparse page writeout before the holes are filled (i.e.
> have tree growth and then have it shrink), etc. Even reserving
> enough blocks for a full btree split per dirtied inode is not
> sufficient, as allocation may trigger multiple full tree splits.
> Basically the reservations will get so large that they will cause
> applications to get premature ENOSPC errors when the writes could
> have succeeded without problems.
I totally agree.  If only there was some way to know what was going
to happen to the btree during writeout we could account for the space.
We could disable delayed allocations when the filesystem is near ENOSPC
and do immediate allocations like in direct I/O.

> 
> That's why this problem has not been solved in the past - it's too
> damn complex to enumerate correctly, and in almost all cases the
> default sized reserved pool is sufficient to prevent data loss
> problems.
Yeah - in almost all cases...

> 
> For the unwritten extent conversion case, though, we need to
> prevent new writes (after ENOSPC occurs) from draining the
> reserved pool. That means we either have to return an ENOSPC
> to the application, or we freeze the writes into preallocated
> space when we are at ENOSPC and the reserve pool is getting
> depleted. This needs to be done up-front, not in the I/O completion
> where it is too late to handle the fact that the reserve pool
> too depleted to do the conversion.....
> 
> That seems simple enough to do without having to add any code
> to the back end I/O path or the transaction subsystem....
Sounds reasonable.  We could report ENOSPC for an extent conversion that
could work - ie if a split is not needed and users might get a little
confused with ENOSPC if they know they preallocated the space.  But it's
better than data corruption.

What if we were to do the unwritten extent conversion up front?  Could
we delay the transaction commit until after the I/O or will that mean
holding an ilock across the I/O?

> 
>>>> I've tried increasing the size of the reserved data blocks pool
>>>> but that only delays the inevitable.  Increasing the size to 65536
>>>> blocks seems to avoid failures but that's getting to be a lot of
>>>> disk space.
>>> You're worried about reserving 20c worth of disk space and 10s of
>>> time to change the config vs hours of enginnering and test time
>>> to come up with a different solution that may or may not be
>>> as effective?
>> 65536 x 16KB blocks is 1GB of disk space - people will notice that go
>> missing.
> 
> Still small change for typical SGI customers.
> 
> Cheers,
> 
> Dave.

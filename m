Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 00:34:49 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q7Ydpm017290
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:34:40 -0700
Message-ID: <48DC9306.104@sgi.com>
Date: Fri, 26 Sep 2008 17:45:10 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Running out of reserved data blocks
References: <48DC73AB.4050309@sgi.com> <20080926070831.GM27997@disturbed>
In-Reply-To: <20080926070831.GM27997@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Fri, Sep 26, 2008 at 03:31:23PM +1000, Lachlan McIlroy wrote:
>> A while back I posted a patch to re-dirty pages on I/O error to handle errors from
>> xfs_trans_reserve() that was failing with ENOSPC when trying to convert delayed
>> allocations.  I'm now seeing xfs_trans_reserve() fail when converting unwritten
>> extents and in that case we silently ignore the error and leave the extent as
>> unwritten which effectively causes data corruption.  I can also get failures when
>> trying to unreserve disk space.
> 
> Is this problem being seen in the real world, or just in artificial
> test workloads?
Customer escalations.

> 
> What the reserve pool is supposed to do is provide sufficient blocks
> to allow dirty data to be flushed, xattrs to be added, etc in the
> immediately period after the ENOSPC occurs so that none of the
> existing operations we've committed to fail.  The reserve pool is
> not meant to be an endless source of space that allows the system to
> continue operating permanently at ENOSPC.
I'm well aware of what the reserve pool is there for.

> 
> If you start new operations like writing into unwritten extents once
> you are already at ENOSPC, then you can consume the entire of the
> reserve pool. There is nothing we can do to prevent that from
> occurring, except by doing something like partially freezing the
> filesystem (i.e. just the data write() level, not the transaction
> level) until the ENOSPC condition goes away....
Yes we could eat into the reserve pool with btree split/newroot
allocations.  Same with delayed allocations.  That's yet another
problem where we need to account for potential btree space before
creating delayed allocations or unwritten extents.

> 
>> I've tried increasing the size of the reserved data blocks pool
>> but that only delays the inevitable.  Increasing the size to 65536
>> blocks seems to avoid failures but that's getting to be a lot of
>> disk space.
> 
> You're worried about reserving 20c worth of disk space and 10s of
> time to change the config vs hours of enginnering and test time
> to come up with a different solution that may or may not be
> as effective?
65536 x 16KB blocks is 1GB of disk space - people will notice that go
missing.

> 
> Reserving a bit of extra space is a cheap, cost effective solution
> to the problem.
We already plan to bump the pool size to help reduce the liklihood of
this problem occuring but it's not a solution - it's a work around.
It's only a matter of time before we hit this issue again.

> 
>> All of these ENOSPC errors should be transient and if we retried
>> the operation - or waited for the reserved pool to refill - we
>> could proceed with the transaction.  I was thinking about adding a
>> retry loop in xfs_trans_reserve() so if XFS_TRANS_RESERVE is set
>> and we fail to get space we just keep trying.
> 
> ENOSPC is not a transient condition unless you do something to
> free up space. If the system is unattended, then ENOSPC can
> persist for a long time. This is effectively silently livelocking
> the system until the ENOSPC is cleared. That will have effect on
> operations on other filesystems, too. e.g. pdflush gets stuck
> in one of these loops...
The loop would be just like the code that waits for logspace to
become available (which we do right after allocating this space).
But you're right that we may have permanently consumed all of the
reserved space and then we cannot proceed - although I haven't
actually seen that case in testing.

> 
> Either increase the size of the reserved pool so your reserve pool
> doesn't empty, or identify and prevent what-ever I/O is depleting
> the reserve pool at ENOSPC....
The reserve pool is not depleting permanently - there are many threads
each in a transaction and each has 4 blocks from the reserved pool.
After the transaction completes the 4 blocks are returned to the pool.
If another thread starts a transaction while the entire pool is tied
up then that transaction will fail - if it comes back later it could
work.

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 00:41:33 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5H7fTsH029221
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 00:41:30 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C18A17D8401
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 00:42:26 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id q7fUAnvjSApHsb7F for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 00:42:26 -0700 (PDT)
Date: Tue, 17 Jun 2008 17:39:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Prevent extent btree block allocation failures
Message-ID: <20080617073949.GP3700@disturbed>
References: <485223E4.6030404@sgi.com> <20080613155708.GG3700@disturbed> <485603FD.2080204@sgi.com> <200806161010.22476.dchinner@agami.com> <48571A57.5090901@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48571A57.5090901@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Dave Chinner <dchinner@agami.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 17, 2008 at 11:58:47AM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Sunday 15 June 2008 11:11 pm, Lachlan McIlroy wrote:
>>> I'm well aware of that particular deadlock involving the freelist - I
>>> hit it while testing.  If you look closely at the code that deadlock
>>> can occur with or without the AG locking avoidance logic.  This is
>>> because the rest of the transaction is unaware that an AG has been
>>> locked due to a freelist operation.
>>
>> Yes, which is why you need to prevent freelist modifications occurring
>> when you can't allocate anything out of the AG.
>
> That sounds reasonable but it isn't consistent with the deadlock I saw.
> One of the threads that was deadlocked had tried to allocate a data extent
> in AG3 but didn't find the space.  It had modified, and hence locked, AG3
> due to modifying the freelist but since it didn't get the space it needed
> it had to go on to another AG.

That sounds like an exact allocation failure - there is enough
space, a large enough extent but no free space at the exact block
required. This is exactly the case that occurred with the inode
allocation - and then allocation in the same AG failed because of
alignment that wasn't taken into account by the first exact
allocation attempt. Perhaps the minalignslop calculation in
xfs_bmap_btalloc() is incorrect...

> So before we even allocated the data extent
> (and before we tried to modify the btree, etc) we had an AG locked.  The
> deadlock avoidance code in xfs_alloc_vextent() didn't know this because
> it only checks for a previous allocation.  It makes sense that we should
> avoid modifying the freelist if there isn't enough space for the allocation
> so the puzzle is why didn't the code do that?

Good question, and I think that is one we need to answer.

>>> I considered that approach (using the minleft field in xfs_alloc_arg_t)
>>> but it has it's problems too.  When we reserve space for the btree
>>> operations it is done on the global filesystem counters, not a
>>> particular AG, so there is the possibility that not one AG has sufficent
>>> space to perform the allocation even though there is enough free space
>>> in the whole filesystem.
>>
>> Yes, we had that problem with the ENOSPC deadlock fixes in that we always
>> needed at least 4 blocks per AG available for a extent free to succeed.
>> Hence we have the XFS_ALLOC_SET_ASIDE() value for determining if the
>> filesystem is out of space, not a count of zero free blocks.
>
> Those 4 blocks are for one extent free operation, right?  What if we have
> multiple threads all trying to do the same thing (in the same AG)?

If we have empty AGF btrees we need to allocate two new root blocks,
and then we won't have to allocate any more btree blocks for the
next 100+ extent free operations...

For allocations, the first would succeed, the rest would have to
search for another AG...

>>> I'm worried with this approach that we could have delayed allocations and
>>> unwritten extents that need to be converted but we can't do it because we
>>> don't have the space we might need (but probably don't).
>>
>> Delayed allocation is the issue - unwritten extent conversion failure will
>> simply return an error and leave the extent unwritten.
>
> That's still a problem though - if we can't convert unwritten extents then
> we can't clean dirty pages and we wont be able to unmount the filesystem.

There will be errors logged and the extents will remain unwritten.
The filesystem should still be able to be unmounted.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

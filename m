Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jun 2008 18:54:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5H1sYI5030352
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 18:54:34 -0700
Received: from larry.melbourne.sgi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 4AA8523A0AD
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 18:55:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130]) by cuda.sgi.com with SMTP id zRmCF7qjQa3RX3xt for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 18:55:26 -0700 (PDT)
Message-ID: <48571A57.5090901@sgi.com>
Date: Tue, 17 Jun 2008 11:58:47 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Prevent extent btree block allocation failures
References: <485223E4.6030404@sgi.com> <20080613155708.GG3700@disturbed> <485603FD.2080204@sgi.com> <200806161010.22476.dchinner@agami.com>
In-Reply-To: <200806161010.22476.dchinner@agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <dchinner@agami.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Sunday 15 June 2008 11:11 pm, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Fri, Jun 13, 2008 at 05:38:12PM +1000, Lachlan McIlroy wrote:
>>>> When at ENOSPC conditions extent btree block allocations can fail and we
>>>> have no error handling to undo partial btree operations.  Prior to extent
>>>> btree operations we reserve enough disk blocks somewhere in the filesystem
>>>> to satisfy the operation but in some conditions we require the blocks to
>>>> come from specific AGs and if those AGs are full the allocation fails.
>>>>
>>>> This change fixes xfs_bmap_extents_to_btree(), xfs_bmap_local_to_extents(),
>>>> xfs_bmbt_split() and xfs_bmbt_newroot() so that they can search other AGs
>>>> for the space needed.  Since we have reserved the space these allocations
>>>> are now guaranteed to succeed. 
>>> Sure, but we didn't reserve space for potential btree splits in a
>>> second AG as a result of this. That needs to be reserved in the
>>> transaction as well, which will blow out transaction reservations
>>> substantially as we'll need to add another 2 full AGF btree splits to
>>> every transaction that modifies the bmap btree.
>> Right.  And most of the time we wont need the space either so it's a
>> real waste.
> 
> Waste, yes, but still needed otherwise transaction overruns and log space
> deadlocks could occur....
> 
>>>> In order to search all AGs I had to revert
>>>> a change made to xfs_alloc_vextent() that prevented a search from looking
>>>> at AGs lower than the starting AG.  This original change was made to prevent
>>>> out of order AG locking when allocating multiple extents on data writeout
>>>> but since we only allocate one extent at a time now this particular problem
>>>> can't happen.
>>> You missed the fact that the AGF of modified AGs is already held
>>> locked in the transaction, hence the locking order within the
>>> transaction is wrong. Also, if we modify the free list in an AG
>>> the fail an allocation (e.g. can't do an exact allocation), we'll
>>> have multiple dirty and locked AGFs in the one allocation. Hence
>>> we still can have locking order violations if you remove that check
>>> and therefore deadlocks.
>> I'm well aware of that particular deadlock involving the freelist - I
>> hit it while testing.  If you look closely at the code that deadlock
>> can occur with or without the AG locking avoidance logic.  This is
>> because the rest of the transaction is unaware that an AG has been
>> locked due to a freelist operation.
> 
> Yes, which is why you need to prevent freelist modifications occurring
> when you can't allocate anything out of the AG.

That sounds reasonable but it isn't consistent with the deadlock I saw.
One of the threads that was deadlocked had tried to allocate a data extent
in AG3 but didn't find the space.  It had modified, and hence locked, AG3
due to modifying the freelist but since it didn't get the space it needed
it had to go on to another AG.  So before we even allocated the data extent
(and before we tried to modify the btree, etc) we had an AG locked.  The
deadlock avoidance code in xfs_alloc_vextent() didn't know this because
it only checks for a previous allocation.  It makes sense that we should
avoid modifying the freelist if there isn't enough space for the allocation
so the puzzle is why didn't the code do that?

> 
>>> This is not the solution to the problem. As I suggested (back when
>>> you first floated this idea as a fix for the problem several weeks
>>> ago) I think the bug is that we are not taking into account the
>>> number of blocks required for a bmbt split when selecting an AG to
>>> allocate from. All we take into account is the blocks required for
>>> the extent to be allocated and nothing else. If we take the blocks
>>> for a bmbt split into account then we'll never try to allocate an
>>> extent in an AG that we can't also allocate all the blocks for the
>>> bmbt split in at the same time.
>> I considered that approach (using the minleft field in xfs_alloc_arg_t)
>> but it has it's problems too.  When we reserve space for the btree
>> operations it is done on the global filesystem counters, not a
>> particular AG, so there is the possibility that not one AG has sufficent
>> space to perform the allocation even though there is enough free space
>> in the whole filesystem.
> 
> Yes, we had that problem with the ENOSPC deadlock fixes in that we always
> needed at least 4 blocks per AG available for a extent free to succeed.
> Hence we have the XFS_ALLOC_SET_ASIDE() value for determining if the
> filesystem is out of space, not a count of zero free blocks.

Those 4 blocks are for one extent free operation, right?  What if we have
multiple threads all trying to do the same thing (in the same AG)?

> 
> In this case, this macro can be extended to guarantee that our aggregate
> block usage never goes below the threshold that would prevent each AG from
> holding enough blocks for a worst case allocation to succeed.....
> 
>> Of course if we have enough space left in one 
>> AG and the AG is locked then the space we reserved doesn't matter anymore
>> and it should all work.
> 
> Yes.
> 
>> I'm worried with this approach that we could have delayed allocations and
>> unwritten extents that need to be converted but we can't do it because we
>> don't have the space we might need (but probably don't).
> 
> Delayed allocation is the issue - unwritten extent conversion failure will
> simply return an error and leave the extent unwritten.

That's still a problem though - if we can't convert unwritten extents then
we can't clean dirty pages and we wont be able to unmount the filesystem.

> 
> With delayed allocation, we can oversubscribe a given AG but we can
> always try a different AG. If we get to the situation that we don't have
> enough space in any AG then we are screwed. However, by ensuring we can
> sustain a worst-case split within any AG we can avoid this situation
> completely.
> 
> Cheers,
> 
> Dave.
> 

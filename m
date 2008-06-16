Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 23:06:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5G66t9a015146
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 23:06:55 -0700
Received: from larry.melbourne.sgi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 681E02350C7
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 23:07:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130]) by cuda.sgi.com with SMTP id ociSLFtR0V60inVo for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 23:07:50 -0700 (PDT)
Message-ID: <485603FD.2080204@sgi.com>
Date: Mon, 16 Jun 2008 16:11:09 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Prevent extent btree block allocation failures
References: <485223E4.6030404@sgi.com> <20080613155708.GG3700@disturbed>
In-Reply-To: <20080613155708.GG3700@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Fri, Jun 13, 2008 at 05:38:12PM +1000, Lachlan McIlroy wrote:
>> When at ENOSPC conditions extent btree block allocations can fail and we
>> have no error handling to undo partial btree operations.  Prior to extent
>> btree operations we reserve enough disk blocks somewhere in the filesystem
>> to satisfy the operation but in some conditions we require the blocks to
>> come from specific AGs and if those AGs are full the allocation fails.
>>
>> This change fixes xfs_bmap_extents_to_btree(), xfs_bmap_local_to_extents(),
>> xfs_bmbt_split() and xfs_bmbt_newroot() so that they can search other AGs
>> for the space needed.  Since we have reserved the space these allocations
>> are now guaranteed to succeed. 
> 
> Sure, but we didn't reserve space for potential btree splits in a
> second AG as a result of this. That needs to be reserved in the
> transaction as well, which will blow out transaction reservations
> substantially as we'll need to add another 2 full AGF btree splits to
> every transaction that modifies the bmap btree.

Right.  And most of the time we wont need the space either so it's a
real waste.

> 
>> In order to search all AGs I had to revert
>> a change made to xfs_alloc_vextent() that prevented a search from looking
>> at AGs lower than the starting AG.  This original change was made to prevent
>> out of order AG locking when allocating multiple extents on data writeout
>> but since we only allocate one extent at a time now this particular problem
>> can't happen.
> 
> You missed the fact that the AGF of modified AGs is already held
> locked in the transaction, hence the locking order within the
> transaction is wrong. Also, if we modify the free list in an AG
> the fail an allocation (e.g. can't do an exact allocation), we'll
> have multiple dirty and locked AGFs in the one allocation. Hence
> we still can have locking order violations if you remove that check
> and therefore deadlocks.

I'm well aware of that particular deadlock involving the freelist - I
hit it while testing.  If you look closely at the code that deadlock
can occur with or without the AG locking avoidance logic.  This is
because the rest of the transaction is unaware that an AG has been
locked due to a freelist operation.

> 
> This is not the solution to the problem. As I suggested (back when
> you first floated this idea as a fix for the problem several weeks
> ago) I think the bug is that we are not taking into account the
> number of blocks required for a bmbt split when selecting an AG to
> allocate from. All we take into account is the blocks required for
> the extent to be allocated and nothing else. If we take the blocks
> for a bmbt split into account then we'll never try to allocate an
> extent in an AG that we can't also allocate all the blocks for the
> bmbt split in at the same time.
> 

I considered that approach (using the minleft field in xfs_alloc_arg_t)
but it has it's problems too.  When we reserve space for the btree
operations it is done on the global filesystem counters, not a
particular AG, so there is the possibility that not one AG has sufficent
space to perform the allocation even though there is enough free space
in the whole filesystem.  Of course if we have enough space left in one
AG and the AG is locked then the space we reserved doesn't matter anymore
and it should all work.

I'm worried with this approach that we could have delayed allocations and
unwritten extents that need to be converted but we can't do it because we
don't have the space we might need (but probably don't).

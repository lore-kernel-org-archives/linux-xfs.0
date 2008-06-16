Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jun 2008 10:09:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5GH9RcM019787
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:09:28 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BAF7C239DBA
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:10:24 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id qcLAOuRWQcdzQNZN for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:10:24 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m5GHA08Z017894
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:10:00 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m5GHA02H014936
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:10:00 -0700
From: Dave Chinner <dchinner@agami.com>
Subject: Re: [PATCH] Prevent extent btree block allocation failures
Date: Mon, 16 Jun 2008 10:10:22 -0700
References: <485223E4.6030404@sgi.com> <20080613155708.GG3700@disturbed> <485603FD.2080204@sgi.com>
In-Reply-To: <485603FD.2080204@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806161010.22476.dchinner@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Sunday 15 June 2008 11:11 pm, Lachlan McIlroy wrote:
> Dave Chinner wrote:
> > On Fri, Jun 13, 2008 at 05:38:12PM +1000, Lachlan McIlroy wrote:
> >> When at ENOSPC conditions extent btree block allocations can fail and we
> >> have no error handling to undo partial btree operations.  Prior to extent
> >> btree operations we reserve enough disk blocks somewhere in the filesystem
> >> to satisfy the operation but in some conditions we require the blocks to
> >> come from specific AGs and if those AGs are full the allocation fails.
> >>
> >> This change fixes xfs_bmap_extents_to_btree(), xfs_bmap_local_to_extents(),
> >> xfs_bmbt_split() and xfs_bmbt_newroot() so that they can search other AGs
> >> for the space needed.  Since we have reserved the space these allocations
> >> are now guaranteed to succeed. 
> > 
> > Sure, but we didn't reserve space for potential btree splits in a
> > second AG as a result of this. That needs to be reserved in the
> > transaction as well, which will blow out transaction reservations
> > substantially as we'll need to add another 2 full AGF btree splits to
> > every transaction that modifies the bmap btree.
> 
> Right.  And most of the time we wont need the space either so it's a
> real waste.

Waste, yes, but still needed otherwise transaction overruns and log space
deadlocks could occur....

> >> In order to search all AGs I had to revert
> >> a change made to xfs_alloc_vextent() that prevented a search from looking
> >> at AGs lower than the starting AG.  This original change was made to prevent
> >> out of order AG locking when allocating multiple extents on data writeout
> >> but since we only allocate one extent at a time now this particular problem
> >> can't happen.
> > 
> > You missed the fact that the AGF of modified AGs is already held
> > locked in the transaction, hence the locking order within the
> > transaction is wrong. Also, if we modify the free list in an AG
> > the fail an allocation (e.g. can't do an exact allocation), we'll
> > have multiple dirty and locked AGFs in the one allocation. Hence
> > we still can have locking order violations if you remove that check
> > and therefore deadlocks.
> 
> I'm well aware of that particular deadlock involving the freelist - I
> hit it while testing.  If you look closely at the code that deadlock
> can occur with or without the AG locking avoidance logic.  This is
> because the rest of the transaction is unaware that an AG has been
> locked due to a freelist operation.

Yes, which is why you need to prevent freelist modifications occurring
when you can't allocate anything out of the AG.

> > This is not the solution to the problem. As I suggested (back when
> > you first floated this idea as a fix for the problem several weeks
> > ago) I think the bug is that we are not taking into account the
> > number of blocks required for a bmbt split when selecting an AG to
> > allocate from. All we take into account is the blocks required for
> > the extent to be allocated and nothing else. If we take the blocks
> > for a bmbt split into account then we'll never try to allocate an
> > extent in an AG that we can't also allocate all the blocks for the
> > bmbt split in at the same time.
> 
> I considered that approach (using the minleft field in xfs_alloc_arg_t)
> but it has it's problems too.  When we reserve space for the btree
> operations it is done on the global filesystem counters, not a
> particular AG, so there is the possibility that not one AG has sufficent
> space to perform the allocation even though there is enough free space
> in the whole filesystem.

Yes, we had that problem with the ENOSPC deadlock fixes in that we always
needed at least 4 blocks per AG available for a extent free to succeed.
Hence we have the XFS_ALLOC_SET_ASIDE() value for determining if the
filesystem is out of space, not a count of zero free blocks.

In this case, this macro can be extended to guarantee that our aggregate
block usage never goes below the threshold that would prevent each AG from
holding enough blocks for a worst case allocation to succeed.....

> Of course if we have enough space left in one 
> AG and the AG is locked then the space we reserved doesn't matter anymore
> and it should all work.

Yes.

> I'm worried with this approach that we could have delayed allocations and
> unwritten extents that need to be converted but we can't do it because we
> don't have the space we might need (but probably don't).

Delayed allocation is the issue - unwritten extent conversion failure will
simply return an error and leave the extent unwritten.

With delayed allocation, we can oversubscribe a given AG but we can
always try a different AG. If we get to the situation that we don't have
enough space in any AG then we are screwed. However, by ensuring we can
sustain a worst-case split within any AG we can avoid this situation
completely.

Cheers,

Dave.

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 00:24:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5J7OMjh000450
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 00:24:23 -0700
Message-ID: <485A0AB2.4060009@sgi.com>
Date: Thu, 19 Jun 2008 17:28:50 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Prevent extent btree block allocation failures
References: <485223E4.6030404@sgi.com> <20080613155708.GG3700@disturbed> <485603FD.2080204@sgi.com> <200806161010.22476.dchinner@agami.com> <48571A57.5090901@sgi.com> <20080617073949.GP3700@disturbed>
In-Reply-To: <20080617073949.GP3700@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, Dave Chinner <dchinner@agami.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Tue, Jun 17, 2008 at 11:58:47AM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Sunday 15 June 2008 11:11 pm, Lachlan McIlroy wrote:
>>>> I'm well aware of that particular deadlock involving the freelist - I
>>>> hit it while testing.  If you look closely at the code that deadlock
>>>> can occur with or without the AG locking avoidance logic.  This is
>>>> because the rest of the transaction is unaware that an AG has been
>>>> locked due to a freelist operation.
>>> Yes, which is why you need to prevent freelist modifications occurring
>>> when you can't allocate anything out of the AG.
>> That sounds reasonable but it isn't consistent with the deadlock I saw.
>> One of the threads that was deadlocked had tried to allocate a data extent
>> in AG3 but didn't find the space.  It had modified, and hence locked, AG3
>> due to modifying the freelist but since it didn't get the space it needed
>> it had to go on to another AG.
> 
> That sounds like an exact allocation failure - there is enough
> space, a large enough extent but no free space at the exact block
> required. This is exactly the case that occurred with the inode
> allocation - and then allocation in the same AG failed because of
> alignment that wasn't taken into account by the first exact
> allocation attempt. Perhaps the minalignslop calculation in
> xfs_bmap_btalloc() is incorrect...

Okay I'll look into that.

There's something else that looks suspicious to me - this code in
xfs_bmap_btalloc() is setting minleft to 0.  Doesn't this go against
what you were saying about setting minleft to be the space we might
need for the btree operations?

	if (args.fsbno == NULLFSBLOCK && nullfb) {
		args.fsbno = 0;
		args.type = XFS_ALLOCTYPE_FIRST_AG;
		args.total = ap->minlen;
		args.minleft = 0;
		if ((error = xfs_alloc_vextent(&args)))
			return error;
		ap->low = 1;
	}

I see it sets a lowspace indicator which filters back up and into
some btree operations.  It appears the purpose of this feature is to
allow allocations to search for space in other AGs as in this example
from xfs_bmap_extents_to_btree():

	if (*firstblock == NULLFSBLOCK) {
		args.type = XFS_ALLOCTYPE_START_BNO;
		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
	} else if (flist->xbf_low) {
		args.type = XFS_ALLOCTYPE_START_BNO;
		args.fsbno = *firstblock;
	} else {
		args.type = XFS_ALLOCTYPE_NEAR_BNO;
		args.fsbno = *firstblock;
	}

This is sort of what I was trying to do with my patch but without the
special lowspace condition.  This lowspace feature is probably broken
because there was a similar special case in xfs_bmbt_split() that got
removed with the changes that fixed the AG out-of-order locking problem.

@@ -1569,12 +1569,11 @@
 	lbno = XFS_DADDR_TO_FSB(args.mp, XFS_BUF_ADDR(lbp));
 	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
 	args.fsbno = cur->bc_private.b.firstblock;
+	args.firstblock = args.fsbno;
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = lbno;
 		args.type = XFS_ALLOCTYPE_START_BNO;
-	} else if (cur->bc_private.b.flist->xbf_low)
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
-	else
+	} else
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	args.mod = args.minleft = args.alignment = args.total = args.isfl =
 		args.userdata = args.minalignslop = 0;

This could be why we have allocations failing now.  Maybe it should
have been left in and XFS_ALLOCTYPE_FIRST_AG changed to
XFS_ALLOCTYPE_START_BNO.  But even then it could still fail because the
AG deadlock avoidance code may prevent us from searching the AG that has
the space we need.

Should we ditch this lowspace special condition (and the code in
xfs_bmap_btalloc()) and insist that all the space we need (using minleft)
should come from one AG?

> 
>> So before we even allocated the data extent
>> (and before we tried to modify the btree, etc) we had an AG locked.  The
>> deadlock avoidance code in xfs_alloc_vextent() didn't know this because
>> it only checks for a previous allocation.  It makes sense that we should
>> avoid modifying the freelist if there isn't enough space for the allocation
>> so the puzzle is why didn't the code do that?
> 
> Good question, and I think that is one we need to answer.
> 
>>>> I considered that approach (using the minleft field in xfs_alloc_arg_t)
>>>> but it has it's problems too.  When we reserve space for the btree
>>>> operations it is done on the global filesystem counters, not a
>>>> particular AG, so there is the possibility that not one AG has sufficent
>>>> space to perform the allocation even though there is enough free space
>>>> in the whole filesystem.
>>> Yes, we had that problem with the ENOSPC deadlock fixes in that we always
>>> needed at least 4 blocks per AG available for a extent free to succeed.
>>> Hence we have the XFS_ALLOC_SET_ASIDE() value for determining if the
>>> filesystem is out of space, not a count of zero free blocks.
>> Those 4 blocks are for one extent free operation, right?  What if we have
>> multiple threads all trying to do the same thing (in the same AG)?
> 
> If we have empty AGF btrees we need to allocate two new root blocks,
> and then we won't have to allocate any more btree blocks for the
> next 100+ extent free operations...
> 
> For allocations, the first would succeed, the rest would have to
> search for another AG...
> 
>>>> I'm worried with this approach that we could have delayed allocations and
>>>> unwritten extents that need to be converted but we can't do it because we
>>>> don't have the space we might need (but probably don't).
>>> Delayed allocation is the issue - unwritten extent conversion failure will
>>> simply return an error and leave the extent unwritten.
>> That's still a problem though - if we can't convert unwritten extents then
>> we can't clean dirty pages and we wont be able to unmount the filesystem.
> 
> There will be errors logged and the extents will remain unwritten.
> The filesystem should still be able to be unmounted.
> 

So returning an error from unwritten extent conversion will not re-dirty the
pages?  So we effectively throw the user's data away?

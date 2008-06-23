Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jun 2008 22:20:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5N5K1cb024160
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 22:20:03 -0700
Message-ID: <485F339D.7090802@sgi.com>
Date: Mon, 23 Jun 2008 15:24:45 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Prevent extent btree block allocation failures
References: <485223E4.6030404@sgi.com> <20080613155708.GG3700@disturbed> <485603FD.2080204@sgi.com> <200806161010.22476.dchinner@agami.com> <48571A57.5090901@sgi.com> <20080617073949.GP3700@disturbed> <485A0AB2.4060009@sgi.com> <20080620052120.GA3700@disturbed>
In-Reply-To: <20080620052120.GA3700@disturbed>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Thu, Jun 19, 2008 at 05:28:50PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Tue, Jun 17, 2008 at 11:58:47AM +1000, Lachlan McIlroy wrote:
>>>> Dave Chinner wrote:
>>>>> On Sunday 15 June 2008 11:11 pm, Lachlan McIlroy wrote:
>>>>>> I'm well aware of that particular deadlock involving the freelist - I
>>>>>> hit it while testing.  If you look closely at the code that deadlock
>>>>>> can occur with or without the AG locking avoidance logic.  This is
>>>>>> because the rest of the transaction is unaware that an AG has been
>>>>>> locked due to a freelist operation.
>>>>> Yes, which is why you need to prevent freelist modifications occurring
>>>>> when you can't allocate anything out of the AG.
>>>> That sounds reasonable but it isn't consistent with the deadlock I saw.
>>>> One of the threads that was deadlocked had tried to allocate a data extent
>>>> in AG3 but didn't find the space.  It had modified, and hence locked, AG3
>>>> due to modifying the freelist but since it didn't get the space it needed
>>>> it had to go on to another AG.
>>> That sounds like an exact allocation failure - there is enough
>>> space, a large enough extent but no free space at the exact block
>>> required. This is exactly the case that occurred with the inode
>>> allocation - and then allocation in the same AG failed because of
>>> alignment that wasn't taken into account by the first exact
>>> allocation attempt. Perhaps the minalignslop calculation in
>>> xfs_bmap_btalloc() is incorrect...
>> Okay I'll look into that.
>>
>> There's something else that looks suspicious to me - this code in
>> xfs_bmap_btalloc() is setting minleft to 0.  Doesn't this go against
>> what you were saying about setting minleft to be the space we might
>> need for the btree operations?
>>
>> 	if (args.fsbno == NULLFSBLOCK && nullfb) {
>> 		args.fsbno = 0;
>> 		args.type = XFS_ALLOCTYPE_FIRST_AG;
>> 		args.total = ap->minlen;
>> 		args.minleft = 0;
>> 		if ((error = xfs_alloc_vextent(&args)))
>> 			return error;
>> 		ap->low = 1;
>> 	}
> 
> Hmmm - that looks suspicious. In xfs_bmapi(), when we are doing a
> write and *firstblock == NULLFSBLOCK (which leads to nullfb being
> set in the above code), we do:
> 
>         if (wr && *firstblock == NULLFSBLOCK) {
>                 if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
>                         minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
>                 else
>                         minleft = 1;
>         } else
>                 minleft = 0;
> 
> If we are in btree format we set the minleft to the number of blocks needed
> for a split. If we are in extent or local format, change to extent of btree
> format requires one extra block.
> 
> The above code you point out definitely breaks this - we haven't done a
> previous allocation so we can start from the first AG, but we sure as
> hell still need minleft set to the number of blocks needed for a
> format change or btree split.
> 
>> I see it sets a lowspace indicator which filters back up and into
>> some btree operations.  It appears the purpose of this feature is to
>> allow allocations to search for space in other AGs as in this example
>> from xfs_bmap_extents_to_btree():
>>
>> 	if (*firstblock == NULLFSBLOCK) {
>> 		args.type = XFS_ALLOCTYPE_START_BNO;
>> 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
>> 	} else if (flist->xbf_low) {
>> 		args.type = XFS_ALLOCTYPE_START_BNO;
>> 		args.fsbno = *firstblock;
>> 	} else {
>> 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>> 		args.fsbno = *firstblock;
>> 	}
> 
> Hmmm - the only place xbf_low is used in the extent-to-btree conversion. I
> don't have access to the revision history anymore, so i can't find out what
> bug the xbf_low condition was added for. It certainly looks like it is
> allowing the btree block to be allocated in a different AG to data block.

The lowspace algorithm was added way back in the early '90s and has been
'tweaked' many times since.

> 
>> This is sort of what I was trying to do with my patch but without the
>> special lowspace condition.  This lowspace feature is probably broken
>> because there was a similar special case in xfs_bmbt_split() that got
>> removed with the changes that fixed the AG out-of-order locking problem.
>>
>> @@ -1569,12 +1569,11 @@
>> 	lbno = XFS_DADDR_TO_FSB(args.mp, XFS_BUF_ADDR(lbp));
>> 	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
>> 	args.fsbno = cur->bc_private.b.firstblock;
>> +	args.firstblock = args.fsbno;
>> 	if (args.fsbno == NULLFSBLOCK) {
>> 		args.fsbno = lbno;
>> 		args.type = XFS_ALLOCTYPE_START_BNO;
>> -	} else if (cur->bc_private.b.flist->xbf_low)
>> -		args.type = XFS_ALLOCTYPE_FIRST_AG;
>> -	else
>> +	} else
>> 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>> 	args.mod = args.minleft = args.alignment = args.total = args.isfl =
>> 		args.userdata = args.minalignslop = 0;
>>
>> This could be why we have allocations failing now. 
> 
> Hmmm - yes, could be. Well found, Lachlan. Was there an equivalent change
> to the allocation of a new root block?

Yeah but it got dropped 14 years ago in a code cleanup change!  Looks like
it was by mistake too.  There used to be another special case for converting
delayed allocations that had the same semantics as this low space trick - it
used XFS_ALLOCTYPE_FIRST_AG instead - maybe to try a little harder to find
space for cases where it is too late to return an error to the user.

> 
>> Maybe it should
>> have been left in and XFS_ALLOCTYPE_FIRST_AG changed to
>> XFS_ALLOCTYPE_START_BNO.  But even then it could still fail because the
>> AG deadlock avoidance code may prevent us from searching the AG that has
>> the space we need.
> 
> Right. But it would definitely be more likely to find space than the current
> code without re-introducing the deadlock.
> 
>> Should we ditch this lowspace special condition (and the code in
>> xfs_bmap_btalloc()) and insist that all the space we need (using minleft)
>> should come from one AG?
> 
> Well, we could, but I suspect that one condition that it is used it
> is safe to do so. That is, the logic goes like this:
> 
> 	- allocate the last extent in an AG. By definition, that has not
> 	  caused a AGF btree split as the trees are now empty.
> 	- because we haven't split any AGF btrees, we still have an unused
> 	  transaction reservation for full AGF btree splits.
> 	- seeing as we have a full reservation, we can safely allocate in a
> 	  different AG without overrunning a transaction reservation.
> 
> However, we still need to obey the AGF locking order.
> 
> Hmmmm - perhaps before allocating with minleft = 0 we need to
> check if we can allocate the rest of the blocks from another AG and
> lock both AGs in the correct order first, recheck we can allocate
> from both of them after they are locked but before modifying anything
> and only then proceed. If we can't find two AGs to allocate from then
> we can safely ENOSPC without any problems. In this special case we'd then
> be able to search the entire FS for space and hence only get an ENOSPC
> if we are really at ENOSPC. Can you pick holes in this?

Sounds like it should work.  We may need to lock more than two AGs at once to
find all the space we need.  Since we can't lock AGs out of order then if we get
to the last AG and we still don't have enough space then we will need to try
again but start at an earlier AG (say AG 0 which should work).

So the code in xfs_alloc_vextent() that uses XFS_ALLOCTYPE_FIRST_AG and sets
minleft to 0 should work.  If we start at AG 0 and we've done the proper reservations
then we should eventually find all the space we need - as long as everything that
needs to allocate space obeys the lowspace algorithm and we always kick off each
search for space from the AG we last allocated from.

> 
>>>>>> I'm worried with this approach that we could have delayed allocations and
>>>>>> unwritten extents that need to be converted but we can't do it because we
>>>>>> don't have the space we might need (but probably don't).
>>>>> Delayed allocation is the issue - unwritten extent conversion failure will
>>>>> simply return an error and leave the extent unwritten.
>>>> That's still a problem though - if we can't convert unwritten extents then
>>>> we can't clean dirty pages and we wont be able to unmount the filesystem.
>>> There will be errors logged and the extents will remain unwritten.
>>> The filesystem should still be able to be unmounted.
>> So returning an error from unwritten extent conversion will not re-dirty the
>> pages?  So we effectively throw the user's data away?
> 
> Yes, I think that can happen async writes. For anything that is sync the
> error will be propagated back to application. Often there is nothing to
> report errors back to on async writes - I'm not sure if the errors get
> logged in that case, though...
> 
> I suspect that this is a holdover from before we had ENOSPC checking on
> mmap writes - that could result in mmap oversubscribing space and the
> data could not ever be written. In low memory conditions this could
> deadlock the machine if we did not throw the pages away. We probably
> need to reevisit this now that ->page_mkwrite() prevents
> oversubscription from occurring....
> 
> Cheers,
> 
> Dave.

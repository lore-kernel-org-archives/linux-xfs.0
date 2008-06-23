Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jun 2008 23:21:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5N6L1kI001050
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 23:21:01 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55EB3D1D9E6
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 23:22:00 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 26KpanblBhk7PhPt for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 23:22:00 -0700 (PDT)
Date: Mon, 23 Jun 2008 16:21:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Prevent extent btree block allocation failures
Message-ID: <20080623062157.GH29319@disturbed>
References: <485223E4.6030404@sgi.com> <20080613155708.GG3700@disturbed> <485603FD.2080204@sgi.com> <200806161010.22476.dchinner@agami.com> <48571A57.5090901@sgi.com> <20080617073949.GP3700@disturbed> <485A0AB2.4060009@sgi.com> <20080620052120.GA3700@disturbed> <485F339D.7090802@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485F339D.7090802@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 23, 2008 at 03:24:45PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Thu, Jun 19, 2008 at 05:28:50PM +1000, Lachlan McIlroy wrote:
>>> I see it sets a lowspace indicator which filters back up and into
>>> some btree operations.  It appears the purpose of this feature is to
>>> allow allocations to search for space in other AGs as in this example
>>> from xfs_bmap_extents_to_btree():
>>>
>>> 	if (*firstblock == NULLFSBLOCK) {
>>> 		args.type = XFS_ALLOCTYPE_START_BNO;
>>> 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
>>> 	} else if (flist->xbf_low) {
>>> 		args.type = XFS_ALLOCTYPE_START_BNO;
>>> 		args.fsbno = *firstblock;
>>> 	} else {
>>> 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>>> 		args.fsbno = *firstblock;
>>> 	}
>>
>> Hmmm - the only place xbf_low is used in the extent-to-btree conversion. I
>> don't have access to the revision history anymore, so i can't find out what
>> bug the xbf_low condition was added for. It certainly looks like it is
>> allowing the btree block to be allocated in a different AG to data block.
>
> The lowspace algorithm was added way back in the early '90s and has been
> 'tweaked' many times since.

It's good to have a complete revision history around somewhere. ;)

>>> This is sort of what I was trying to do with my patch but without the
>>> special lowspace condition.  This lowspace feature is probably broken
>>> because there was a similar special case in xfs_bmbt_split() that got
>>> removed with the changes that fixed the AG out-of-order locking problem.
>>>
>>> @@ -1569,12 +1569,11 @@
>>> 	lbno = XFS_DADDR_TO_FSB(args.mp, XFS_BUF_ADDR(lbp));
>>> 	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
>>> 	args.fsbno = cur->bc_private.b.firstblock;
>>> +	args.firstblock = args.fsbno;
>>> 	if (args.fsbno == NULLFSBLOCK) {
>>> 		args.fsbno = lbno;
>>> 		args.type = XFS_ALLOCTYPE_START_BNO;
>>> -	} else if (cur->bc_private.b.flist->xbf_low)
>>> -		args.type = XFS_ALLOCTYPE_FIRST_AG;
>>> -	else
>>> +	} else
>>> 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>>> 	args.mod = args.minleft = args.alignment = args.total = args.isfl =
>>> 		args.userdata = args.minalignslop = 0;
>>>
>>> This could be why we have allocations failing now. 
>>
>> Hmmm - yes, could be. Well found, Lachlan. Was there an equivalent change
>> to the allocation of a new root block?
>
> Yeah but it got dropped 14 years ago in a code cleanup change!  Looks like
> it was by mistake too. 

Ouch.

> There used to be another special case for converting
> delayed allocations that had the same semantics as this low space trick - it
> used XFS_ALLOCTYPE_FIRST_AG instead - maybe to try a little harder to find
> space for cases where it is too late to return an error to the user.

Interesting. Any idea why that was removed? Or another accident?

[....]

>> Hmmmm - perhaps before allocating with minleft = 0 we need to
>> check if we can allocate the rest of the blocks from another AG and
>> lock both AGs in the correct order first, recheck we can allocate
>> from both of them after they are locked but before modifying anything
>> and only then proceed. If we can't find two AGs to allocate from then
>> we can safely ENOSPC without any problems. In this special case we'd then
>> be able to search the entire FS for space and hence only get an ENOSPC
>> if we are really at ENOSPC. Can you pick holes in this?
>
> Sounds like it should work.  We may need to lock more than two AGs at once to
> find all the space we need.  Since we can't lock AGs out of order then if we get
> to the last AG and we still don't have enough space then we will need to try
> again but start at an earlier AG (say AG 0 which should work).

In this case, I'd just start from XFS_ALLOCTYPE_FIRST_AG rather than
doing multiple passes and having to undo between them....

> So the code in xfs_alloc_vextent() that uses XFS_ALLOCTYPE_FIRST_AG and sets
> minleft to 0 should work.

Yes, as long as the next selected AG has the original minleft blocks
available in it.

> If we start at AG 0 and we've done the proper reservations
> then we should eventually find all the space we need - as long as everything that
> needs to allocate space obeys the lowspace algorithm and we always kick off each
> search for space from the AG we last allocated from.

Yup. Seems sane to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

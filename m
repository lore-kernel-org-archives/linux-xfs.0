Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jun 2008 23:35:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5N6Zgwt003102
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 23:35:43 -0700
Message-ID: <485F455A.9060701@sgi.com>
Date: Mon, 23 Jun 2008 16:40:26 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Prevent extent btree block allocation failures
References: <485223E4.6030404@sgi.com> <20080613155708.GG3700@disturbed> <485603FD.2080204@sgi.com> <200806161010.22476.dchinner@agami.com> <48571A57.5090901@sgi.com> <20080617073949.GP3700@disturbed> <485A0AB2.4060009@sgi.com> <20080620052120.GA3700@disturbed> <20080623052025.GF29319@disturbed> <485F3B42.9050300@sgi.com> <20080623061421.GG29319@disturbed>
In-Reply-To: <20080623061421.GG29319@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Mon, Jun 23, 2008 at 03:57:22PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Fri, Jun 20, 2008 at 03:21:20PM +1000, Dave Chinner wrote:
>>>> On Thu, Jun 19, 2008 at 05:28:50PM +1000, Lachlan McIlroy wrote:
>>>>> There's something else that looks suspicious to me - this code in
>>>>> xfs_bmap_btalloc() is setting minleft to 0.  Doesn't this go against
>>>>> what you were saying about setting minleft to be the space we might
>>>>> need for the btree operations?
>>>>>
>>>>> 	if (args.fsbno == NULLFSBLOCK && nullfb) {
>>>>> 		args.fsbno = 0;
>>>>> 		args.type = XFS_ALLOCTYPE_FIRST_AG;
>>>>> 		args.total = ap->minlen;
>>>>> 		args.minleft = 0;
>>>>> 		if ((error = xfs_alloc_vextent(&args)))
>>>>> 			return error;
>>>>> 		ap->low = 1;
>>>>> 	}
>>>> Hmmm - that looks suspicious. In xfs_bmapi(), when we are doing a
>>>> write and *firstblock == NULLFSBLOCK (which leads to nullfb being
>>>> set in the above code), we do:
>>>>
>>>>         if (wr && *firstblock == NULLFSBLOCK) {
>>>>                 if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
>>>>                         minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
>>>>                 else
>>>>                         minleft = 1;
>>>>         } else
>>>>                 minleft = 0;
>>>>
>>>> If we are in btree format we set the minleft to the number of blocks needed
>>>> for a split. If we are in extent or local format, change to extent of btree
>>>> format requires one extra block.
>>>>
>>>> The above code you point out definitely breaks this - we haven't done a
>>>> previous allocation so we can start from the first AG, but we sure as
>>>> hell still need minleft set to the number of blocks needed for a
>>>> format change or btree split.
>>> Just to point out yet another problem in this code (one that's just
>>> been tripped over @ agami) is unwritten extent conversion.
>>>
>>> Basically, we don't do an allocation here, so when we end up in
>>> xfs_bmap_add_extent_unwritten_real() with a null firstblock. Hence
>>> the cases where conversion can cause a split - case
>>> MASK(LEFT_FILLING), MASK(RIGHT_FILLING) and 0 (convert the middle of
>>> an extent) - we can select an AG that doesn't have enough space for
>>> the entire split as we've ignored the number of blocks we might
>>> need to allocate in the split (the minleft parameter) entirely.
>>>
>>> I suspect that xfs_bmbt_split() needs to handle the null first block
>>> case slightly differently - the minleft parameter passed to the
>>> allocation should not be zero - it should be the number of levels
>>> above the current level left in the tree. i.e:
>>>
>>> 	minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
>>>
>>> If we've already got a firstblock set, then this should have already
>>> been taken into account (i.e. we still need to fix the low space
>>> case where it got ignored as we were discussing).
>> Funny.  I tested the exact same change last week to try to fix the same
>> problem.  Seemed to work okay.
> 
> Cool. Got a patch for review?

I couldn't find the original patch that calculated minleft as above - instead
here's a variant that addresses the double insert problem by retrieving the
reservation amount from the transaction.  It could very well be overkill though.

--- fs/xfs/xfs_bmap_btree.c_1.169	2008-06-16 17:25:10.000000000 +1000
+++ fs/xfs/xfs_bmap_btree.c	2008-06-16 18:32:45.000000000 +1000
@@ -1496,9 +1496,12 @@ xfs_bmbt_split(
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = lbno;
 		args.type = XFS_ALLOCTYPE_START_BNO;
-	} else
+		args.minleft = xfs_trans_get_block_res(args.tp);
+	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	args.mod = args.minleft = args.alignment = args.total = args.isfl =
+		args.minleft = 0;
+	}
+	args.mod = args.alignment = args.total = args.isfl =
 		args.userdata = args.minalignslop = 0;
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;


> 
>> In the case where we convert the middle of an existing unwritten extent
>> we need to insert two new extents.  I might be paranoid here but I'll
>> assume the worst case scenario and that we'll need space for two complete
>> tree splits.
> 
> Yes, I think so. Certainly, if you look at the block reservation in
> xfs_iomap_write_unwritten():
> 
> 892         resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
> 
> #define XFS_DIOSTRAT_SPACE_RES(mp, v)   \
>         (XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + (v))
> 
> #define XFS_EXTENTADD_SPACE_RES(mp,w)   (XFS_BM_MAXLEVELS(mp,w) - 1)
> 
> It reserves enough blocks for 2 bmbt splits so I think this is
> definitely a possibility we need to handle.
> 
>> The first allocation for the first insert will set minleft
>> correctly but what about the allocations for splits during the second
>> insert?  We could run out of space in the chosen AG because minleft wasn't
>> enough.
> 
> Yeah, so we probably need pass a flag in the cursor to indicate
> it's a double split case when doing the first allocation in
> xfs_bmbt_split....
> 
> Cheers,
> 
> Dave.

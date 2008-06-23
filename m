Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jun 2008 22:19:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5N5JVDC023950
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 22:19:31 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37FE3266580
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 22:20:30 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id I4qmFrtWsKncSuKX for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 22:20:30 -0700 (PDT)
Date: Mon, 23 Jun 2008 15:20:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Prevent extent btree block allocation failures
Message-ID: <20080623052025.GF29319@disturbed>
References: <485223E4.6030404@sgi.com> <20080613155708.GG3700@disturbed> <485603FD.2080204@sgi.com> <200806161010.22476.dchinner@agami.com> <48571A57.5090901@sgi.com> <20080617073949.GP3700@disturbed> <485A0AB2.4060009@sgi.com> <20080620052120.GA3700@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620052120.GA3700@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 20, 2008 at 03:21:20PM +1000, Dave Chinner wrote:
> On Thu, Jun 19, 2008 at 05:28:50PM +1000, Lachlan McIlroy wrote:
> > Dave Chinner wrote:
> >> On Tue, Jun 17, 2008 at 11:58:47AM +1000, Lachlan McIlroy wrote:
> >>> Dave Chinner wrote:
> >>>> On Sunday 15 June 2008 11:11 pm, Lachlan McIlroy wrote:
> >>>>> I'm well aware of that particular deadlock involving the freelist - I
> >>>>> hit it while testing.  If you look closely at the code that deadlock
> >>>>> can occur with or without the AG locking avoidance logic.  This is
> >>>>> because the rest of the transaction is unaware that an AG has been
> >>>>> locked due to a freelist operation.
> >>>> Yes, which is why you need to prevent freelist modifications occurring
> >>>> when you can't allocate anything out of the AG.
> >>> That sounds reasonable but it isn't consistent with the deadlock I saw.
> >>> One of the threads that was deadlocked had tried to allocate a data extent
> >>> in AG3 but didn't find the space.  It had modified, and hence locked, AG3
> >>> due to modifying the freelist but since it didn't get the space it needed
> >>> it had to go on to another AG.
> >>
> >> That sounds like an exact allocation failure - there is enough
> >> space, a large enough extent but no free space at the exact block
> >> required. This is exactly the case that occurred with the inode
> >> allocation - and then allocation in the same AG failed because of
> >> alignment that wasn't taken into account by the first exact
> >> allocation attempt. Perhaps the minalignslop calculation in
> >> xfs_bmap_btalloc() is incorrect...
> >
> > Okay I'll look into that.
> >
> > There's something else that looks suspicious to me - this code in
> > xfs_bmap_btalloc() is setting minleft to 0.  Doesn't this go against
> > what you were saying about setting minleft to be the space we might
> > need for the btree operations?
> >
> > 	if (args.fsbno == NULLFSBLOCK && nullfb) {
> > 		args.fsbno = 0;
> > 		args.type = XFS_ALLOCTYPE_FIRST_AG;
> > 		args.total = ap->minlen;
> > 		args.minleft = 0;
> > 		if ((error = xfs_alloc_vextent(&args)))
> > 			return error;
> > 		ap->low = 1;
> > 	}
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

Just to point out yet another problem in this code (one that's just
been tripped over @ agami) is unwritten extent conversion.

Basically, we don't do an allocation here, so when we end up in
xfs_bmap_add_extent_unwritten_real() with a null firstblock. Hence
the cases where conversion can cause a split - case
MASK(LEFT_FILLING), MASK(RIGHT_FILLING) and 0 (convert the middle of
an extent) - we can select an AG that doesn't have enough space for
the entire split as we've ignored the number of blocks we might
need to allocate in the split (the minleft parameter) entirely.

I suspect that xfs_bmbt_split() needs to handle the null first block
case slightly differently - the minleft parameter passed to the
allocation should not be zero - it should be the number of levels
above the current level left in the tree. i.e:

	minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;

If we've already got a firstblock set, then this should have already
been taken into account (i.e. we still need to fix the low space
case where it got ignored as we were discussing).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

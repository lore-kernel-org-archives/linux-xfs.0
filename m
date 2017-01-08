Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59812 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753255AbdAHQJg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jan 2017 11:09:36 -0500
Date: Sun, 8 Jan 2017 11:09:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/5] xfs: fix bogus minleft manipulations
Message-ID: <20170108160935.GC62847@bfoster.bfoster>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
 <1482436822-31546-4-git-send-email-hch@lst.de>
 <20170104181933.GC41989@bfoster.bfoster>
 <20170108103611.GC26451@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170108103611.GC26451@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Sun, Jan 08, 2017 at 11:36:11AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 04, 2017 at 01:19:33PM -0500, Brian Foster wrote:
> > Staring at this some more, I'm still not terribly fond of this, moreso
> > because I wonder how much more of this can be ripped out
> 
> What else do you have in mind?
> 

Oh, I don't have anything better to offer atm. :P It's just that we're
messing with this little corner of the low space allocation mechanism
when a broader reassessment of the bigger picture seems more appropriate
(hence the low space allocator question). It sounds like doing that is
on your radar, though..

Sorry, I recognize there's a bug to fix here.. I guess I'm just trying
to convince myself this is as minimal as necessary to fix it.

> > and whether the
> > low space allocator thing is still effective.
> 
> That's a good question.  Another item added to my not critical allocator
> TODO list, which keeps growing..
> 

You're welcome. ;)

> > Aside from that, afaict
> > the set_aside change should make it robust and addresses my previous
> > question in that it holds blocks out of all transaction reservations.
> > 
> > I'm also curious whether the set_aside patch alone addresses the
> > original problem, or setting minleft = 0 in one of these cases was
> > actually the cause.
> 
> I think I needed both changes, but it's been a while and I'll have to
> retest.
> 

Ok, thanks.

> > > -		/*
> > > -		 * Could not find an AG with enough free space to satisfy
> > > -		 * a full btree split.  Try again without minleft and if
> > > -		 * successful activate the lowspace algorithm.
> > > -		 */
> > > -		args.fsbno = 0;
> > > -		args.type = XFS_ALLOCTYPE_FIRST_AG;
> > > -		args.minleft = 0;
> > > -		error = xfs_alloc_vextent(&args);
> > > -		if (error)
> > > -			goto error0;
> > > -		cur->bc_private.b.dfops->dop_low = true;
> > > -	}
> > 
> > We have a similar retry pattern in xfs_bmap_btalloc() where, in the hunk
> > just above, we retain the retry that appears analogous to this one (in
> > that it activates the low space algo) and just drop the minleft = 0 bit.
> > Here we are dropping the whole thing. Any reason not to be consistent
> > one way or the other? (Though do note that we don't check firstblock
> > here...).
> 
> xfs_bmap_btalloc is a bit different because the alignment question
> comes into play as well, in addition to the non-binding AG selection
> from the higher level allocator code.  But I suspect that there is a lot
> of dead or questionable code in it, and it's been on my todo list
> to audit xfs_bmap_btalloc, xfs_alloc_vectent and it's subfunction,
> and make the argument passing, allocator modes and things like the
> lowspace mode aswell as the firstblock magic a lot cleaner and properly
> documented.

I agree that is much needed and may very well kill some of this code
off...

In this particular case, I think it's probably safer to defer the
removal of the entire bmbt_alloc_block() hunk to that audit that will
take into consideration the broader context. IOWs, take the same
approach in bmbt_alloc_block() as you have in xfs_bmap_btalloc().

I'm not even sure the code is correct as it is, but if we're in a
situation where multiple bmbt block allocations are required, afaict
that hunk can affect subsequent bmbt block allocs in terms of how
aggressive the allocation request is (via allocation mode). I think that
also provides some logical separation between minleft changes and all of
this retry logic and low space allocator stuff, fwiw.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

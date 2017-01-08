Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57907 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755984AbdAHKgN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jan 2017 05:36:13 -0500
Date: Sun, 8 Jan 2017 11:36:11 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/5] xfs: fix bogus minleft manipulations
Message-ID: <20170108103611.GC26451@lst.de>
References: <1482436822-31546-1-git-send-email-hch@lst.de> <1482436822-31546-4-git-send-email-hch@lst.de> <20170104181933.GC41989@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170104181933.GC41989@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Wed, Jan 04, 2017 at 01:19:33PM -0500, Brian Foster wrote:
> Staring at this some more, I'm still not terribly fond of this, moreso
> because I wonder how much more of this can be ripped out

What else do you have in mind?

> and whether the
> low space allocator thing is still effective.

That's a good question.  Another item added to my not critical allocator
TODO list, which keeps growing..

> Aside from that, afaict
> the set_aside change should make it robust and addresses my previous
> question in that it holds blocks out of all transaction reservations.
> 
> I'm also curious whether the set_aside patch alone addresses the
> original problem, or setting minleft = 0 in one of these cases was
> actually the cause.

I think I needed both changes, but it's been a while and I'll have to
retest.

> > -		/*
> > -		 * Could not find an AG with enough free space to satisfy
> > -		 * a full btree split.  Try again without minleft and if
> > -		 * successful activate the lowspace algorithm.
> > -		 */
> > -		args.fsbno = 0;
> > -		args.type = XFS_ALLOCTYPE_FIRST_AG;
> > -		args.minleft = 0;
> > -		error = xfs_alloc_vextent(&args);
> > -		if (error)
> > -			goto error0;
> > -		cur->bc_private.b.dfops->dop_low = true;
> > -	}
> 
> We have a similar retry pattern in xfs_bmap_btalloc() where, in the hunk
> just above, we retain the retry that appears analogous to this one (in
> that it activates the low space algo) and just drop the minleft = 0 bit.
> Here we are dropping the whole thing. Any reason not to be consistent
> one way or the other? (Though do note that we don't check firstblock
> here...).

xfs_bmap_btalloc is a bit different because the alignment question
comes into play as well, in addition to the non-binding AG selection
from the higher level allocator code.  But I suspect that there is a lot
of dead or questionable code in it, and it's been on my todo list
to audit xfs_bmap_btalloc, xfs_alloc_vectent and it's subfunction,
and make the argument passing, allocator modes and things like the
lowspace mode aswell as the firstblock magic a lot cleaner and properly
documented.

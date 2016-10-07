Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44330 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751608AbcJGGRd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Oct 2016 02:17:33 -0400
Date: Fri, 7 Oct 2016 08:17:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 37/63] xfs: implement CoW for directio writes
Message-ID: <20161007061729.GA29194@lst.de>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org> <147520498004.29434.11046105793006225587.stgit@birch.djwong.org> <20161005182709.GC4042@bfoster.bfoster> <20161005205542.GA3992@birch.djwong.org> <20161006122007.GA16893@bfoster.bfoster> <20161007010225.GC11241@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161007010225.GC11241@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, Oct 06, 2016 at 06:02:25PM -0700, Darrick J. Wong wrote:
> > Ok, kind of nasty with all of the various paths through get_blocks(),
> > but hopefully that dies off with buffer heads.
> 
> It's possible Christoph might have further cleanup patches for reflink
> that fix this?  <shrug>

I do.  It's stuck on not getting one of the corner cases right at the
moment, and I had to take a break from it yesterday to go insane, but
I hope I'll be able to post it soon.

> Yes, that would have been another way to implement it.  I think I
> finally see your point about using the delalloc mechanism -- since we've
> converted the buffered write path to iomap and therefore know exactly
> how much userspace wants to write in both buffered and directio cases,
> we could just allocate the cow extent right then and there, skipping the
> overhead of writing a delalloc reservation and then changing it.
> 
> For buffered writes, though, it's nice to be able to use the DA
> mechanism so that we can ask the allocator for as big of an extent as we
> have contiguous dirty pages.  Hm.  I guess for directio then we could
> just fill in the holes directly and convert any delalloc reservations
> that happened already to be there, which requires only a single loop.
> 
> Will ponder this some more, thx for the pushback. :)

Having spent a lot of the time with the COW and non-COW I/O path
lately here is my 2 cents:  delalloc for the buffered write path
inherently make sense and mirrors what we do for non-COW I/O.  I
have patches to rewrite parts of how we do it, but I see no
reason to change that we are doing delayed allocations.

For the direct I/O path there is absolutely no point in doing delayed
allocation and I plan to get rid of them for the next merge window.

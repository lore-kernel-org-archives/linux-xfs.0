Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35292 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933127AbdA0Rpr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Jan 2017 12:45:47 -0500
Date: Fri, 27 Jan 2017 09:44:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct I/O
 COW writes
Message-ID: <20170127174447.GZ9134@birch.djwong.org>
References: <20170124083732.GA17818@lst.de>
 <20170124135044.GA60234@bfoster.bfoster>
 <20170124135937.GA25885@lst.de>
 <20170124150222.GD60234@bfoster.bfoster>
 <20170124150959.GA27705@lst.de>
 <20170124161719.GE60234@bfoster.bfoster>
 <20170124162156.GA29361@lst.de>
 <20170124174318.GH60234@bfoster.bfoster>
 <20170124200855.GA1385@lst.de>
 <20170125000934.GG9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170125000934.GG9134@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 04:09:34PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 24, 2017 at 09:08:55PM +0100, Christoph Hellwig wrote:
> > On Tue, Jan 24, 2017 at 12:43:18PM -0500, Brian Foster wrote:
> > > Hmm, that's not what I'm seeing (not that it really matters, but I'm
> > > curious if I'm missing something):
> > 
> > Yeah, I can reproduce this on mainline.  Turns out the it was done
> > by the align call in xfs_bmap_btalloc that even my before run had
> > removed.
> > 
> > Took me some time to spin my head around this.
> > 
> > Btw, I think we have a nasty race in the current DIO code that might
> > expose stale data, but this is just the same kind of head spinning
> > exercise for now:
> > 
> > Thread 1 writes a range from B to c
> > 
> >                     B --------- C
> 
>           A --------- B --------- C
>                ^           ^
>                d           e
> 
> I'm assuming B-C has no shared blocks, d-B has shared blocks, and that
> both d & e are cowextsize boundaries.
> 
> > a little later thread 2 writes from A to B
> > 
> >         A --------- B
> > but the code preallocates beyond B into the range where thread
> > 1 has just written, but ->end_io hasn't been called yet.
> > But once ->end_io is called thread 2 has already allocated
> > up to the extent size hint into the write range of thread 1,
> > so the end_io handler will splice the unintialized blocks from
> > that preallocation back into the file right after B.
> 
> I think you're right about there being a dio race here.  I'm not sure
> what the solution here is -- certainly we could disregard the cowextsize
> hint, though that has a fragmentation cost that we already know about.
> 
> We could also change the dio write setup to extend the range that it
> checks for shared blocks up and down to the nearest cowextsize boundary
> and set up the delalloc reservations in the cow fork as necessary.  If
> our thread2 comes along then it'll find the reservations already set
> up for a cow so that we avoid the situation where B-C changes between
> iomap_begin and dio_write_end_io does the wrong thing.  That's more in
> the spirit of cowextsize since we'd promote future writes to CoW.
> However it's more wasteful of blocks since we have no idea if those
> future writes are ever actually going to happen, and it also adds more
> bmap records if we don't use all of the reservation.
> 
> Ugh, my head hurts, I'm going to go for a walk to ponder this some more,
> and to try to work out whether the buffered path is all right.

I think I came up with a better idea overnight: take advantage of the
unwritten bit.  Currently, all extents in the cow fork are either
delalloc or normal extents.  When we allocate the blocks to fill a cow
extent, we'll flag the extent as unwritten.  When we go to write the
data to disk, we convert the unwritten extent to a real extent, and the
post-write remap (since it only takes a file offset and length) will
be changed to remap only real, written extents into the data fork.

--D

> 
> --D
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

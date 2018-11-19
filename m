Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:28201
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727068AbeKSKsE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Nov 2018 05:48:04 -0500
Date: Mon, 19 Nov 2018 11:26:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: flush posteof zeroing before reflink truncation
Message-ID: <20181119002611.GH19305@dastard>
References: <20181116190724.GW4235@magnolia>
 <20181116203756.GF19305@dastard>
 <20181118141205.GA40476@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181118141205.GA40476@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Sun, Nov 18, 2018 at 09:12:06AM -0500, Brian Foster wrote:
> On Sat, Nov 17, 2018 at 07:37:56AM +1100, Dave Chinner wrote:
> > On Fri, Nov 16, 2018 at 11:07:24AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > If we're remapping into a range that starts beyond EOF, we have to zero
> > > the memory between EOF and the start of the target range, as established
> > > in 410fdc72b05af.  However, in 4918ef4ea008, we extended the pagecache
> > > truncation range downwards to a page boundary to guarantee that
> > > pagecache pages are removed and that there's no possibility that we end
> > > up zeroing subpage blocks within a page.  Unfortunately, we never commit
> > > the posteof zeroing to disk, so on a filesystem where page size > block
> > > size the truncation partially undoes the zeroing and we end up with
> > > stale disk contents.
> > > 
> > > Brian and I reproduced this problem by running generic/091 on a 1k block
> > > xfs filesystem, assuming fsx in fstests supports clone/dedupe/copyrange.
> > > 
> > > Fixes: 410fdc72b05a ("xfs: zero posteof blocks when cloning above eof")
> > > Fixes: 4918ef4ea008 ("xfs: fix pagecache truncation prior to reflink")
> > > Simultaneously-diagnosed-by: Brian Foster <bfoster@redhat.com>
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Ok, I have a different fix for this again.
> > 
> > > ---
> > > Note: I haven't tested this thoroughly but wanted to push this out for
> > > everyone to look at ASAP.
> > > ---
> > >  fs/xfs/xfs_reflink.c |    8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > > index c56bdbfcf7ae..8ea09a7e550c 100644
> > > --- a/fs/xfs/xfs_reflink.c
> > > +++ b/fs/xfs/xfs_reflink.c
> > > @@ -1255,13 +1255,19 @@ xfs_reflink_zero_posteof(
> > >  	loff_t			pos)
> > >  {
> > >  	loff_t			isize = i_size_read(VFS_I(ip));
> > > +	int			error;
> > >  
> > >  	if (pos <= isize)
> > >  		return 0;
> > >  
> > >  	trace_xfs_zero_eof(ip, isize, pos - isize);
> > > -	return iomap_zero_range(VFS_I(ip), isize, pos - isize, NULL,
> > > +	error = iomap_zero_range(VFS_I(ip), isize, pos - isize, NULL,
> > >  			&xfs_iomap_ops);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	return filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> > > +			isize, pos - 1);
> > 
> > This doesn't work on block size > page size setups, unfortunately.
> > 
> > Immediately after this we truncate the page cache, which also
> > doesn't do the right thing on block size > page cache setups.
> > So there's a couple of bugs here.
> > 
> > IMO, the truncate needs fixing, not the zeroing. Flushing after
> > zeroing leaves a potential landmine of other dirty data not getting
> > flushed properly before the truncate, so we should fix the truncate
> > to do a flush first. And we should fix it in a way that doesn't mean
> > we need to fix it again in the very near future. i.e. the patch
> > below that uses xfs_flush_unmap_range().
> > 
> > FWIW, I'm workng on cleaning up the ~10 patches I have for various
> > fsx and other corruption fixes so I can post them - it'll be monday
> > before I get that done - but if you're having fsx failures w/
> > copy/dedupe/clone on fsx I've probably already got a fix for it...
> > 
> 
> Ok, so FYI this doesn't actually address the writeback issue I
> reproduced because the added flush targets the start of the destination
> offset.

Oh, sorry, I didn't notice that difference. Fixed that now. That
might actually be one(*) of the fsx bugs I've been chasing for
several days.

> Note again that I think this is distinct from the issue both you
> and Darrick have documented in each commit log. Darrick's patch
> addresses it because the flush targets the range that has been zeroed
> (isize to dest offset) and thus potentially dirtied in cache. The
> zeroing is what leads to sharing a block with an active dirty page (and
> eventually leads to writeback of a page to a shared block).

Yes, we may be seeing *different symptoms* but the underlying
problem is the same - we are not writing back pages over the range
we are about to share, and so we don't trigger a COW on the range
before writeback occurs.

IMO, using xfs_flush_unmap_range() is still the right change to make
here, even if my initial patch didn't address this specific problem
but a different flush/inval problem with this code.

Cheers.

Dave.

(*) I've still got several different fsx variants that fail on either
default configs and/or 1k block size with different signatures.
Problem is they take between 370,000 ops and 5 million ops to
trigger, and so generate tens to hundreds of GB of trace data....

e.g. on a default 4k filesystem on pmem, this fails after 377k ops:

# ltp/fsx -q -p50000 -l 500000 -r 4096 -t 512 -w 512 -Z -R -W /mnt/scratch/foo
....
READ BAD DATA: offset = 0x31000, size = 0xa000, fname = /mnt/scratch/foo
OFFSET  GOOD    BAD     RANGE
0x36000 0x9084  0x7940  0x00000
....

and this slight variant (buffered IO rather than direct IO) fails
after 2.17 million ops:

# ltp/fsx -q -p50000 -l 500000 -r 4096 -t 512 -w 512 -R -W /mnt/scratch/foo
....
READ BAD DATA: offset = 0xf000, size = 0xf318, fname = /mnt/scratch/foo
OFFSET  GOOD    BAD     RANGE
0x15000 0x990b  0x6c0b  0x00000
....

I'm also seeing MAPREAD failures with data after EOF on several
different configs, and there's a couple of other failures that show
up every so often, too.

If I turn off copy/dedupe/clone file range, they all run for
billions of ops without failure....

-- 
Dave Chinner
david@fromorbit.com

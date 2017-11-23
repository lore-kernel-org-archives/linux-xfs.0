Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:39258 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752656AbdKWAg2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 19:36:28 -0500
Date: Thu, 23 Nov 2017 11:24:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: tr_ifree transaction log reservation calculation
Message-ID: <20171123002401.GT5858@dastard>
References: <20171121150557.GA5014@bfoster.bfoster>
 <0a9b47ba-a41e-3b96-981f-f04f9e2ab11c@hpe.com>
 <20171121173557.GB6004@bfoster.bfoster>
 <20171122022645.GR5858@dastard>
 <20171122122100.GA9984@bfoster.bfoster>
 <20171122204126.GA19041@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171122204126.GA19041@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Mark Tinguely <mark.tinguely@hpe.com>, linux-xfs@vger.kernel.org

On Wed, Nov 22, 2017 at 03:41:26PM -0500, Brian Foster wrote:
> On Wed, Nov 22, 2017 at 07:21:01AM -0500, Brian Foster wrote:
> > On Wed, Nov 22, 2017 at 01:26:45PM +1100, Dave Chinner wrote:
> > > On Tue, Nov 21, 2017 at 12:35:57PM -0500, Brian Foster wrote:
> > > I'm still not 100% sure what the extra "2 +" is accounting for
> > > there, though, so to be safe that migh need to be accounted as full
> > > blocks, not log headers.
> > > 
> > 
> > Same.. there is still a bit of cruft in this calculation that really
> > isn't clear. That +2 is one part and then there's another
> > xfs_calc_buf_res(1, 0) right before the m_ialloc_blks line. The fact
> > that it's a separate line implies it is logically separate, but who
> > knows.
> > 
> > I suppose I'll keep that line as is, replace the inobt entry bit with
> > the full inobt calculation (as above), keep the +2 associated with the
> > inobt calculation and run some tests on that.

I think I've worked out what the +2 is supposed to be - the AGF
and AGFL when we alloc/free blocks for either the inode chunk
or inobt records. You see them in, say, xfs_calc_write_reservation()
but not in the inode allocation reservations, despite needing
to do allocation....

Ok, xfs_calc_itruncate_reservation() appears to have the same
inobt modification bug in it. But now I'm wondering: why does a
truncate transaction modify the inobt?

It doesn't, and the commitin the historic tree doesn't explain why
it was necesary then, either:

commit 5fe6abb82f76472ad4ca0d99c0c86585948060eb
Author: Glen Overby <overby@sgi.com>
Date:   Wed Mar 17 00:52:31 2004 +0000

    Add space for inode and allocation btrees to ITRUNCATE log reservation
    Add XFS_ALLOCFREE_LOG_RES to IFREE log reservation.

FWIW, there's a bunch of stuff in the other transactions
reservations that I'm finding highly questionable, too....

And thinking on this a bit further, I suspect the whole allocation
reservation is just be a fudge. We do a single alloc/free
reservation per AG per transaction, which allows for one full height
split of the tree. The problem that Brian has reported is that this
reservation only covers a /single/ freespace tree modification and
we're overrunning it just in fixing up the freelist.

So if we want to cover the worst case, we need a reservation for
each freespace tree modification, not one to cover them all. i.e.
one for each AGFL modification, and one for the actual extent being
allocated/freed. And we need one of those reservations for
*every single allocation/free that can occur in a transaction*.

This rapidly blows out to being impractical. We're not going to get
full height splits/joins on every single allocation that occurs in a
transaction, and the number of potential allocations in a
transaction can be considered essentially unbound. e.g.  how many
allocations can a single a directory modification do? Hash btree
split, data/node btree split,  new freespace block, too - especially
when considering that a each directory block could - in the worse
case - be 128 x 512 byte extents (64k dir block size on 512 byte
block size filesystem).

So, no, I don't think it's realistic to start trying to cater for
worst case reservations here. Such crazy shit just doesn't happen
often enough in the real world for us to penalise everything with
such reservations.

In which case, I think we need to consider that each major operation
(inobt, directory, finobt, etc) probably should have it's own
allocation reservation. It's extremely unlikely that all of them are
going to overrun in the same transaction, so maybe this is a good
enough safe guard without going completely over the top...

.....

> Quick update... I ended up still hitting an overrun with this fix in
> place (actually, the original bug report shows an overrun of ~32k which
> should have indicated that was going to be the case).

Yeah, no surprise there given the above.

> In any event, that had me thinking about tweaking how we manage the agfl
> and subsequently brings up a couple other issues. Firstly, this is a
> large fs, so we have 1TB AGs and the associated 16 entry agfls.

16 entries?

The AGFL can hold (on a v5 filesystems and 512 byte sectors) 117
individual freespace blocks.  It's always much larger than we need
to hold the blocks for a single extent allocation.

> The min
> agfl allocation is 8 at the time of the overrun, which is the maximum
> case for such a filesystem (4 per space btree). IIUC, as much as we need
> to keep the agfl populated with a minimum of 8 blocks in this case, we
> conversely also need to make sure we have 8 free slots, yes? If so, I'm
> not sure that being lazy about freeing blocks is an option because I
> have at least one trace where it takes 3 agfl block frees just to get
> the agfl from 9 down to the required 8.

Even the AGFL is half full, we've still got space for ~50 blocks to
be freed from the bno/cnt/rmap btrees in a single allocation/free
operation, so I just don't think we have to care about being a few
blocks off. If trying to free blocks from the AGFL results in it
growing, then just abort unless the AGFL is over half full...

> Unrelated to the overrun issue, I also notice that we use the agfl for
> the rmapbt. That adds another 5 blocks in the maximum case, which means
> a 1TB AG can have a min agfl requirement of 4+4+5=13 blocks allocated of
> 16 slots. Unless I'm missing something in the reasoning above, aren't we
> kind of playing with fire in that case?

No, because the AGFL is 117 blocks long at minimum.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

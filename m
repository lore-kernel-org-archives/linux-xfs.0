Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:44592 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753317AbdKWVzB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Nov 2017 16:55:01 -0500
Date: Fri, 24 Nov 2017 08:54:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: tr_ifree transaction log reservation calculation
Message-ID: <20171123215457.GU5858@dastard>
References: <20171121150557.GA5014@bfoster.bfoster>
 <0a9b47ba-a41e-3b96-981f-f04f9e2ab11c@hpe.com>
 <20171121173557.GB6004@bfoster.bfoster>
 <20171122022645.GR5858@dastard>
 <20171122122100.GA9984@bfoster.bfoster>
 <20171122204126.GA19041@bfoster.bfoster>
 <20171123002401.GT5858@dastard>
 <20171123143652.GA22032@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171123143652.GA22032@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Mark Tinguely <mark.tinguely@hpe.com>, linux-xfs@vger.kernel.org

On Thu, Nov 23, 2017 at 09:36:53AM -0500, Brian Foster wrote:
> On Thu, Nov 23, 2017 at 11:24:02AM +1100, Dave Chinner wrote:
> > On Wed, Nov 22, 2017 at 03:41:26PM -0500, Brian Foster wrote:
> > > On Wed, Nov 22, 2017 at 07:21:01AM -0500, Brian Foster wrote:
> > > > On Wed, Nov 22, 2017 at 01:26:45PM +1100, Dave Chinner wrote:
> > > > > On Tue, Nov 21, 2017 at 12:35:57PM -0500, Brian Foster wrote:
> > > > > I'm still not 100% sure what the extra "2 +" is accounting for
> > > > > there, though, so to be safe that migh need to be accounted as full
> > > > > blocks, not log headers.
> > > > > 
> > > > 
> > > > Same.. there is still a bit of cruft in this calculation that really
> > > > isn't clear. That +2 is one part and then there's another
> > > > xfs_calc_buf_res(1, 0) right before the m_ialloc_blks line. The fact
> > > > that it's a separate line implies it is logically separate, but who
> > > > knows.
> > > > 
> > > > I suppose I'll keep that line as is, replace the inobt entry bit with
> > > > the full inobt calculation (as above), keep the +2 associated with the
> > > > inobt calculation and run some tests on that.
> > 
> > I think I've worked out what the +2 is supposed to be - the AGF
> > and AGFL when we alloc/free blocks for either the inode chunk
> > or inobt records. You see them in, say, xfs_calc_write_reservation()
> > but not in the inode allocation reservations, despite needing
> > to do allocation....
> > 
> 
> That sounds sane.. though it looks like in the case of
> xfs_calc_write_reservation() those are accounted as sectors rather than
> full blocks as in the ifree calculation. I suppose we should fix those
> up in the ifree calculation to reflect the sector size and properly
> document them.
> 
> Hmm, xfs_calc_write_reservation() also handles the space freeing bits a
> bit more how I would expect: using the max of two calculations since a
> part of the operation occurs after a transaction roll. The ifree
> calculation just adds everything together (and we still overrun it :/).

Well, I don't think that's going to matter - more below...

[....]

> > So if we want to cover the worst case, we need a reservation for
> > each freespace tree modification, not one to cover them all. i.e.
> > one for each AGFL modification, and one for the actual extent being
> > allocated/freed. And we need one of those reservations for
> > *every single allocation/free that can occur in a transaction*.
> > 
> > This rapidly blows out to being impractical. We're not going to get
> > full height splits/joins on every single allocation that occurs in a
> > transaction, and the number of potential allocations in a
> > transaction can be considered essentially unbound. e.g.  how many
> > allocations can a single a directory modification do? Hash btree
> > split, data/node btree split,  new freespace block, too - especially
> > when considering that a each directory block could - in the worse
> > case - be 128 x 512 byte extents (64k dir block size on 512 byte
> > block size filesystem).
> > 
> 
> The impression I get is that at the time of designing these transactions
> it was simply easiest to characterize worst case of a single operation
> as a full btree modification, and then either there was an assumption
> made that would be sufficient to cover other multiple allocation/free
> cases (since the full tree changes are relatively rare) or that was just
> borne out in practice and so was never really revisited. 

Yup, that seems to fit the pattern over time of "increase the
reservation when it runs out" fixes....

> > So, no, I don't think it's realistic to start trying to cater for
> > worst case reservations here. Such crazy shit just doesn't happen
> > often enough in the real world for us to penalise everything with
> > such reservations.
> > 
> 
> Agreed.
> 
> > In which case, I think we need to consider that each major operation
> > (inobt, directory, finobt, etc) probably should have it's own
> > allocation reservation. It's extremely unlikely that all of them are
> > going to overrun in the same transaction, so maybe this is a good
> > enough safe guard without going completely over the top...
> > 
> 
> For the ifree example, I take this to mean we should refactor the
> calculation to consider freeing of the inode chunk separate from the
> inobt and finobt modifications with respect to free space tree
> modifications.  In other words, we account one allocfree res for the
> inode chunk, another for the inobt modification (to effectively cover
> agfl fixups) and another (optional) for the finobt as opposed to one for
> the whole transaction. Is that what you're suggesting?
> 
> That sounds reasonable, but at the same time I'm a bit concerned that I
> think the ifree transaction should technically be refactored into a max
> of the pre/post tx roll reservations similar to the write reservation
> mentioned above. For example:
> 
> 	MAX(inode + inobt + finobt + agi + inode chunk + etc.,
> 	    allocfree for inode chunk + (allocfree * nr inobts));

Yeah, I think you're right in that we need to we need to look at
redefining the reservations at a higher level.

For this specific example, though, we have to take into account that
a finobt modification to mark an inode free can insert a new record
into the btree. Hence we have scope for a finobt block allocation
and tree split, so we need to have allocfree reservations in the
primary transaction.

Also, the inode btree modifications (and refcountbt, too) call
xfs_free_extent() directly - they don't use deferops free list that
is processed as an EFI/EFD op after the primary transaction has been
rolled.  i.e:

xfs_btree_delrec
  xfs_btree_free_block
    xfs_inobt_free_block
      xfs_free_extent

Hence the primary transaction reservation has to take into account
that operations that remove a record from the tree can cause and
extent to be freed. As such, the removal of an inode chunk - which
removes the record from both the inobt and finobt - can trigger
freespace tree modification directly.

IOWs, the primary ifree transaction needs alloc/free reservations
for the modifications of both the inobt and the finobt, regardless
of anything else that goes on, so.....

> But that would end up making the transaction smaller than adding it all
> together. Of course, that may be fine with the agfl fixup below..

.... I doubt it will shrink if we take into account the multiple
direct alloc/free operations in the primary transaction properly. :/

Hmmmm - I'm wondering if we need to limit the max extents in a
defer-ops EFI/EFD item to 2 so we don't try to free all the defered
extent frees in a single EFI/EFD transaction pair. i.e. force it
to roll the transaction and get a new log reservation every two
extents being freed so we can limit the reservation size defered
extent freeing requires....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

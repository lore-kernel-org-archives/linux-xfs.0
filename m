Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:41514 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751443AbdK0V3u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Nov 2017 16:29:50 -0500
Date: Tue, 28 Nov 2017 08:29:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: tr_ifree transaction log reservation calculation
Message-ID: <20171127212946.GY5858@dastard>
References: <20171121173557.GB6004@bfoster.bfoster>
 <20171122022645.GR5858@dastard>
 <20171122122100.GA9984@bfoster.bfoster>
 <20171122204126.GA19041@bfoster.bfoster>
 <20171123002401.GT5858@dastard>
 <20171123143652.GA22032@bfoster.bfoster>
 <20171123215457.GU5858@dastard>
 <20171124145121.GA26516@bfoster.bfoster>
 <20171125232010.GW5858@dastard>
 <20171127184651.GA39719@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127184651.GA39719@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Mark Tinguely <mark.tinguely@hpe.com>, linux-xfs@vger.kernel.org

On Mon, Nov 27, 2017 at 01:46:51PM -0500, Brian Foster wrote:
> On Sun, Nov 26, 2017 at 10:20:10AM +1100, Dave Chinner wrote:
> > On Fri, Nov 24, 2017 at 09:51:22AM -0500, Brian Foster wrote:
> > > On Fri, Nov 24, 2017 at 08:54:57AM +1100, Dave Chinner wrote:
> > > > On Thu, Nov 23, 2017 at 09:36:53AM -0500, Brian Foster wrote:
> > > > > On Thu, Nov 23, 2017 at 11:24:02AM +1100, Dave Chinner wrote:
> > > > > That sounds reasonable, but at the same time I'm a bit concerned that I
> > > > > think the ifree transaction should technically be refactored into a max
> > > > > of the pre/post tx roll reservations similar to the write reservation
> > > > > mentioned above. For example:
> > > > > 
> > > > > 	MAX(inode + inobt + finobt + agi + inode chunk + etc.,
> > > > > 	    allocfree for inode chunk + (allocfree * nr inobts));
> > > > 
> > > > Yeah, I think you're right in that we need to we need to look at
> > > > redefining the reservations at a higher level.
> > > > 
> > > > For this specific example, though, we have to take into account that
> > > > a finobt modification to mark an inode free can insert a new record
> > > > into the btree. Hence we have scope for a finobt block allocation
> > > > and tree split, so we need to have allocfree reservations in the
> > > > primary transaction.
> > > > 
> > > > Also, the inode btree modifications (and refcountbt, too) call
> > > > xfs_free_extent() directly - they don't use deferops free list that
> > > > is processed as an EFI/EFD op after the primary transaction has been
> > > > rolled.  i.e:
> > > > 
> > > > xfs_btree_delrec
> > > >   xfs_btree_free_block
> > > >     xfs_inobt_free_block
> > > >       xfs_free_extent
> > > > 
> > > > Hence the primary transaction reservation has to take into account
> > > > that operations that remove a record from the tree can cause and
> > > > extent to be freed. As such, the removal of an inode chunk - which
> > > > removes the record from both the inobt and finobt - can trigger
> > > > freespace tree modification directly.
> > > > 
> > > 
> > > Ah, because the inobt doesn't use the agfl. It looks like we try to do
> > > this in xfs_calc_finobt_res(), but it doesn't appear to be fully correct
> > > because the allocfree res is only accounted for transactions that "do
> > > not already account for free space btree modifications," according to
> > > the comment. I don't recall the exact reasoning there off the top of my
> > > head, but if I had to guess, this was probably just another instance of
> > > "bolt something on to the transaction that appears to follow the pattern
> > > of other transactions and doesn't explode."
> > > 
> > > Given that, it seems like the appropriate thing to do is in fact for the
> > > transaction to include an independent allocfree res for the inode chunk,
> > > the inobt and finobt. That justifies the existence of the current
> > > allocfree in the pre-roll part of the transaction and would increase the
> > > transaction size by one more allocfree in the finobt case (the inode
> > > chunk should technically be part of the post-roll calculation).
> > > 
> > > Actually, with addition of some proper documentation that may also
> > > obviate the need to do the whole pre/post tx roll thing because the
> > > first part of the transaction will obviously be larger than a single
> > > allocfree res for the second part (amazing how a little documentation to
> > > establish/assess intent can save us time from trying to work backwards
> > > from the transaction :P).
> > > 
> > > Ok, I think that gives me enough to go on to try and refactor at least
> > > the inobt tx res bits. I'll take a closer look next week, thanks for all
> > > of the feedback.
> > 
> > Actually, I wrote a patch as I was working all this out :p
> > 
> > Not complete, or anything like that, but I've attached it below
> > so you've got some idea of what I was thinking....
> > 
> 
> Ok. While I get the basic idea, this isn't quite what I was thinking
> with regard to the finobt bits. The current finobt reservation applies
> the allocation part of the logic only when the higher level transaction
> doesn't already include the allocfree res.

Which is wrong, as we've already discussed. If we are doing an
allocation of [f]inobt blocks, we need an allocfree reservation for
that specific operation.

> This kind of handwaves away
> the finobt allocfree res by assuming the existing transaction
> reservation would cover the blocks alloc'd/freed by the finobt.
>
> IOW, there isn't really a clear separation between the modify and
> allocation cases for the finobt as there is for the inobt. The finobt
> can add/remove a record in either of those cases. The requirement to add
> an additional allocfree res with the finobt operation pretty much
> invalidates the finobt modify case, I think.

Sure. What I did was separate allocation vs no allocation
(modification) in terms of what the tree operation requires. But
that doesn't mean we actually use the modification variant for
finobt if all operations we take reservations for could require
allocation.

It's the difference between "this is the reservation for a pure
record modification operation" vs "this is the reservation for a
record modification operation that *may* require record insertion or
deletion and hence allocation/freeing"

> Also, it looks like this makes some other changes that are not
> immediately clear to me,

Which ones?

> squashes in a couple of the fixes I've already
> made and doesn't actually add a new allocfree res in some of the
> create/alloc calculations (but rather refactors the existing allocfree
> res to use the new helper). It's not clear to me if the latter is
> intentional..?

Not sure what you are asking? I factored existing open-coded inobt
reservations to use helpers so that I didn't have to modify the
reservation in lots of places. Get it right in one place, all the
others are correct too. Indeed, most of the cases I factored already
had the allocfree reservation, so I'm not sure why we'd be adding a
new one to those reservations?

And, keep in mind that I did say "the patch is just what I wrote as
I discovered problems" before tearing into it about not being
complete a complete solution....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

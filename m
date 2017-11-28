Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:21223 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752182AbdK1VgM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 16:36:12 -0500
Date: Wed, 29 Nov 2017 08:34:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: tr_ifree transaction log reservation calculation
Message-ID: <20171128213408.GD5858@dastard>
References: <20171122122100.GA9984@bfoster.bfoster>
 <20171122204126.GA19041@bfoster.bfoster>
 <20171123002401.GT5858@dastard>
 <20171123143652.GA22032@bfoster.bfoster>
 <20171123215457.GU5858@dastard>
 <20171124145121.GA26516@bfoster.bfoster>
 <20171125232010.GW5858@dastard>
 <20171127184651.GA39719@bfoster.bfoster>
 <20171127212946.GY5858@dastard>
 <20171128132801.GA45759@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128132801.GA45759@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Mark Tinguely <mark.tinguely@hpe.com>, linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 08:28:02AM -0500, Brian Foster wrote:
> On Tue, Nov 28, 2017 at 08:29:46AM +1100, Dave Chinner wrote:
> > On Mon, Nov 27, 2017 at 01:46:51PM -0500, Brian Foster wrote:
> > > Also, it looks like this makes some other changes that are not
> > > immediately clear to me,
> > 
> > Which ones?
> > 
> 
> The truncate and iunlink bits...

The truncate reservation includes a reservation for an inobt
modification. We *never* modify the inobt inside a truncate
transaction, so even if we ignore the fact it was wrong (like all
the others we are fixing), it really shouldn't be there.

THe commit message from the archive tree doesn't help explain it,
either. It just says (paraphrasing) "fix transaction reservation".
So I removed it.

As for the iunlink bit, you mean this the fact I added the on disk
inode cluster to the reservation in
xfs_calc_iunlink_add_reservation()?

That's because we log the inode cluster in unlink when we modify the
inode unlinked list. That's missing from all the unlinked inode
manipulation reservations - some of them take into account modifying
the inode cluster of another inode in the unlinked list (e.g. ifree)
but they all fail to reserve space for logging the unlinked list
pointer in the inode being unlinked/freed.

> > > squashes in a couple of the fixes I've already
> > > made and doesn't actually add a new allocfree res in some of the
> > > create/alloc calculations (but rather refactors the existing allocfree
> > > res to use the new helper). It's not clear to me if the latter is
> > > intentional..?
> > 
> > Not sure what you are asking? I factored existing open-coded inobt
> > reservations to use helpers so that I didn't have to modify the
> > reservation in lots of places. Get it right in one place, all the
> > others are correct too. Indeed, most of the cases I factored already
> > had the allocfree reservation, so I'm not sure why we'd be adding a
> > new one to those reservations?
> > 
> 
> Understood wrt to the helpers. What I'm asking is why
> xfs_calc_create_resv_alloc(), for example, doesn't actually add another
> allocfree res if the intent was to add one for all inode tree related
> ops..?

Because the patch wasn't complete and finished and there's no
guarantee I factored it correctly. You're still reading that patch
as though it was a completely polished, finished patch, not a set of
"noticed these things while thinking about the problem" notes.

I factored the code first, never went back the create
code because we were focussed on the problems in the iunlink
reservations....

> Using that example, my understanding is that tx should now have
> an allocfree res for the inode chunk allocation and a new one for the
> inobt insertion. The latter is the one that's now abstracted into the
> helpers, yes..? That's the model I tried to follow for the rfc patch,
> anyways.

Sure, that's what needs to be done, as we've discussed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

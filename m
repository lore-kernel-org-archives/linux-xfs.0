Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49474 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751749AbeFGEm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 00:42:59 -0400
Date: Wed, 6 Jun 2018 21:42:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/14] xfs: repair the AGF and AGFL
Message-ID: <20180607044255.GB25007@magnolia>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
 <152770864591.11611.5564813732568495676.stgit@magnolia>
 <20180604015255.GJ10363@dastard>
 <20180605231856.GO9437@magnolia>
 <20180606040624.GO10363@dastard>
 <20180606045603.GV9437@magnolia>
 <20180607003132.GQ10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180607003132.GQ10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 07, 2018 at 10:31:32AM +1000, Dave Chinner wrote:
> On Tue, Jun 05, 2018 at 09:56:03PM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 06, 2018 at 02:06:24PM +1000, Dave Chinner wrote:
> > > On Tue, Jun 05, 2018 at 04:18:56PM -0700, Darrick J. Wong wrote:
> > > > On Mon, Jun 04, 2018 at 11:52:55AM +1000, Dave Chinner wrote:
> > > > > > +int
> > > > > > +xfs_repair_mod_fdblocks(
> > > > > > +	struct xfs_scrub_context	*sc,
> > > > > > +	int64_t				delta_fdblocks)
> > > > > > +{
> > > > > > +	int				error;
> > > > > > +
> > > > > > +	if (delta_fdblocks == 0)
> > > > > > +		return 0;
> > > > > > +
> > > > > > +	if (delta_fdblocks < 0) {
> > > > > > +		error = xfs_trans_reserve_more(sc->tp, -delta_fdblocks, 0);
> > > > > > +		if (error)
> > > > > > +			return error;
> > > > > > +	}
> > > > > > +
> > > > > > +	xfs_trans_mod_sb(sc->tp, XFS_TRANS_SB_FDBLOCKS, delta_fdblocks);
> > > > > 
> > > > > This seems a little hacky - it's working around a transaction
> > > > > reservation overflow warning, right?
> > > > 
> > > > More than that -- we're trying to avoid the situation where the incore
> > > > free block counter goes negative.
> > > 
> > > Which will only happen if we overflow the transaction reservation,
> > > yes?
> > > 
> > > > Things go south pretty quickly when
> > > > that happens because transaction reservations succeed when there's not
> > > > enough free space to accomodate them.  We'd rather error out to
> > > > userspace and have the admin unmount and xfs_repair than risk letting
> > > > the fs really blow up.
> > > 
> > > Sure, but I really don't like retrospective modification of
> > > transaction reservations.  The repair code is already supposed to
> > > have a reservation that is big enough to rebuild the AG trees, so
> > > why should we need to reserve more space while rebuilding the AG
> > > trees?
> > > 
> > > > Note that this function has to be called before repair dirties anything
> > > > in the repair transaction so we're still at a place where we could back
> > > > out with no harm done.
> > > 
> > > Still doesn't explain to me what the problem is that this code works
> > > around. And because I don't understand why it is necessary, this just
> > > seems like a hack....
> > 
> > It /is/ a hack while I figure out a sane strategy for checking the
> > summary counters that doesn't regularly shut down the filesystem.  I've
> > thought that perhaps we should leave the global counters alone.  If
> > something corrupts agf_flcount to 0x1000032 (when the real flcount is
> > 0x32) then we're going to subtract a huge quantity from the global
> > counter, which is totally stupid.
> 
> But that sort of thing is easy to deal with via bounding:
> 
> 	min(agf_flcount, XFS_AGFL_SIZE(mp))
> 
> I'd like to avoid hacks for the "near to ENOSPC" conditions for the
> moment. Repair being unreliable at ENOSPC, or even having repair
> shut down because of unexpected ENOSPC is fine for the initial
> commits. Document it as a problem that needs fixing and add it to
> the list of things hat need to be addressed before we can remove the
> EXPERIMENTAL tag.

Yeah.  I agree that online repair should avoid pushing the system off an
ENOSPC cliff.  Or a corrupted fs cliff of any kind.

> > I've been mulling over what to do here -- normally, repair always writes
> > out fresh AG headers and summary counters and under normal circumstance
> > we'll always keep the AG counts and the global counts in sync, right?
> 
> Userspace repair rebuilds the freespace and inode trees in each ag,
> and the rebuild keeps it's own count of the free space, used and
> free inodes tracked in the new versions of the trees.  Once all AGs
> have been rebuilt, it sums the counts gathered in memory from each
> AG, and then it calls sync_sb() to write those aggregated counters
> back into the global superblock.
> 
> IOWs, userspace repair doesn't rely on the existing counters (on
> disk or in memory) at all, nor does it try to keep them up to date
> as it goes. it keeps it's own state and assumes nothing else is
> modifying the filesystem so it's always going to be correct.

Ok, that's what I thought too.

> > The idea I have to solve all these problems is to add a superblock state
> > flag that we set whenever we think the global counters might be wrong.
> > We'd only do this if we had to fix the counters in an AGF, or if the
> > agfl padding fixer triggered, etc.
> 
> That's pretty much what I suggested via an "unclean unmount" state
> flag. That way a new mount would always trigger a resync.

Heh ok. :)

> > Then we add a new FSSUMMARY scrubber that only does anything if the
> > 'counters might be wrong' flag is set.  When it does, we freeze the fs,
> > tally up all the counters and reservations, and fix the counters if we
> > can.  Then unfreeze and exit.  This way we're not locking the entire
> > filesystem every time scrub runs, but we have a way to fix the global
> > counters if we need to.  Granted, figuring out the total amount of
> > incore reservation might not be quick.
> 
> Right - that's basically the problem doing it at mount time avoids -
> having to freeze the filesystem for an unknown amount of time to fix
> it up. I agree with you that "unmount/mount" is not really an option

(Yeah.  I'll put it out there that mount time quotacheck should (some
day) just be an online repair function that runs at mount, and all the
metadata-corruptions that can stop a mount dead in its tracks
(finobt/refcountbt corruption) should just invoke invoke repair.  But
not for several years while we stabilize this beast....)

> for fixing this up, and that freeze/fix/thaw is a much preferrable
> option. However, this really is something that needs to be scheduled
> for a maintenance period, not be done on a live production
> filesystem where a freeze will violate performance SLAs....

[catching the list up with irc]

Agreed.  We can't just decide to freeze the fs, even if it's relatively
fast.  For a while I had ruminated about adding a time budget field to
the scrub ioctl which would cause it to abort (or chicken out) if it
couldn't execute the job within a certain time constraint, but that
mostly just ended with the behavior that specifying more -b to xfs_scrub
adds sleeps in between scrub calls to throttle the disk/cpu that online
repair eats up.

(I figure if that proves particularly irksome we can rip it out before
we remove the EXPERIMENTAL tags.)

> IOWs, I think this "sync global counters" op needs to be a separate
> admin controlled repair operation, not something we do automatically
> as part of the normal scrub/repair process. i.e. when repair
> completes, it tells the admin that:
>
> **** IMPORTANT - Repair operations still pending ****
> 
> There are pending repair operations that need a quiesced filesystem
> to perform. Quiescing the filesystem will block all access to the
> filesystem while the repair operation is being performed, so this
> should be performed only during a scheduled maintenance period.
> 
> To perform the pending repair operations, please run:
> 
> <repair prog> --quiesce --pending <mntpt>

Yeah, I agree that when the kernel tells scrub it avoided doing
something for fear of freezing the fs then it should print something to
the effect of:

"xfs_scrub: 439 repairs completed."
"xfs_scrub: rerun me with --do-the-slow-thing to complete repairs."

> 
> **** /IMPORTANT ****
> 
> > The other repair functions no longer need xfs_repair_mod_fdblocks; if
> > they has to make a correction to any of the per-ag free counters all
> > they do is set the "wrong counters" flag.
> 
> *nod*

Ok, so two extra scrub ioctl flags, then:

_IFLAG_FREEZE_OK	/* userspace allows repair to freeze the fs */
_OFLAG_AVOIDED_FREEZE	/* would have done something but couldn't freeze */

I'll think about how to add a new scrubber to take care of the global
summary counters, and in the meantime I think I'll nominate online
rmapbt repair and online quotacheck for _IFLAG_FREEZE_OK.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

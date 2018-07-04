Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:32720 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753468AbeGDBDw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 21:03:52 -0400
Date: Wed, 4 Jul 2018 11:03:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/21] xfs: repair inode records
Message-ID: <20180704010344.GK2234@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986829144.3155.13577483407162701849.stgit@magnolia>
 <20180703061718.GJ2234@dastard>
 <20180704001612.GZ32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180704001612.GZ32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 05:16:12PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 03, 2018 at 04:17:18PM +1000, Dave Chinner wrote:
> > On Sun, Jun 24, 2018 at 12:24:51PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Try to reinitialize corrupt inodes, or clear the reflink flag
> > > if it's not needed.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > A comment somewhere that this is only attmepting to repair inodes
> > that have failed verifier checks on read would be good.
> 
> There are a few comments in the callers, e.g.
> 
> "Repair all the things that the inode verifiers care about"
> 
> "Fix everything xfs_dinode_verify cares about."
> 
> "Make sure we can pass the inode buffer verifier."
> 
> Hmm, I think maybe you meant that I need to make it more obvious which
> functions exist to make the verifiers happy (and so there won't be any
> in-core inodes while they run) vs. which ones fix irregularities that
> aren't caught as a condition for setting up in-core inodes?

Well, that too. My main point is that various one-liners don't
explain the overall picture of what, why and how the repair is being
done....

> xrep_inode_unchecked_* are the ones that run on in-core inodes; the rest
> run on inodes so damaged they can't be _iget'd.

It's completely ambiguous, though: "unchecked" by what, exactly? :P

> > Also, is there a need to check the inode CRC here?
> 
> We already know the inode core is bad, so why not just reset it?

But you don't recalculate it if di_ok and unlinked_ok are true. It
only gets recalc'd if when changes need to be made. hence an inode
that failed the verifier because of a CRC error still won't pass the
verifier after going through this function.

> > > +		dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> > > +		dip->di_version = 3;
> > > +		if (!unlinked_ok)
> > > +			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
> > > +		xfs_dinode_calc_crc(mp, dip);
> > > +		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
> > > +		xfs_trans_log_buf(tp, bp, ioff, ioff + sizeof(*dip) - 1);
> > 
> > Hmmmm. how does this interact with other transactions in repair that
> > might have logged changes to the same in-core inode? If it was just
> > changing the unlinked pointer, then that would be ok, but
> > magic/version are overwritten by the inode item recovery...
> 
> There shouldn't be an in-core inode; this function should only get
> called if we failed to _iget the inode, which implies that nobody else
> has an in-core inode.

OK - so we've held the buffer locked across a check for in-core
inodes we are trying to repair?

> > > +	switch (mode & S_IFMT) {
> > > +	case S_IFIFO:
> > > +	case S_IFCHR:
> > > +	case S_IFBLK:
> > > +	case S_IFSOCK:
> > > +		/* di_size can't be nonzero for special files */
> > > +		dip->di_size = 0;
> > > +		break;
> > > +	case S_IFREG:
> > > +		/* Regular files can't be larger than 2^63-1 bytes. */
> > > +		dip->di_size = cpu_to_be64(size & ~(1ULL << 63));
> > > +		break;
> > > +	case S_IFLNK:
> > > +		/* Catch over- or under-sized symlinks. */
> > > +		if (size > XFS_SYMLINK_MAXLEN)
> > > +			dip->di_size = cpu_to_be64(XFS_SYMLINK_MAXLEN);
> > > +		else if (size == 0)
> > > +			dip->di_size = cpu_to_be64(1);
> > 
> > Not sure this is valid - if the inode is in extent format then a
> > size of 1 is invalid and means the symlink will point to the
> > first byte in the data fork, and that could be anything....
> 
> I picked these wonky looking formats so that we'd always trigger the
> higher level repair functions to have a look at the link/dir without
> blowing up elsewhere in the code if we tried to use them.  Not that we
> can do much for broken symlinks, but directories could be rebuilt.

Change the symlink to an inline symlink that points to "zero length
symlink repaired by online repair" and set the c/mtimes to the
current time?

> But maybe directories should simply be reset to an empty inline
> directory, and eventually grow an iflag that will always trigger
> directory reconstruction (when parent pointers become a thing).

Yeah, I think if we are going to do anything here we should be
setting the inodes to valid "empty" state. Or at least comment that
it's being set to a state that will detected and rebuilt by the
upcoming fork repair pass.

> > what if the inode failed the fork verifiers rather than the dinode
> > verifier?
> 
> That's coming up in the next patch.  Want me to put in an XXX comment to
> that effect?

Not if all you do is remove it in the next patch - better to
document where we are making changes that the fork rebuild will
detect and fix up. :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

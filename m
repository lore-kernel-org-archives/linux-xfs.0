Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:47026 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751208AbdJEHOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2017 03:14:45 -0400
Date: Thu, 5 Oct 2017 18:13:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/25] xfs: scrub inodes
Message-ID: <20171005071339.GN3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706335008.19351.13005092237576865356.stgit@magnolia>
 <20171005040452.GM3666@dastard>
 <20171005052219.GE7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171005052219.GE7122@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2017 at 10:22:19PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 05, 2017 at 03:04:52PM +1100, Dave Chinner wrote:
> > On Tue, Oct 03, 2017 at 01:42:30PM -0700, Darrick J. Wong wrote:
> > > +	error = xfs_iget(mp, NULL, sc->sm->sm_ino, XFS_IGET_UNTRUSTED,
> > > +			0, &ips);
> > 
> > I think we also want XFS_IGET_DONTCACHE here, so we don't trash the
> > inode cache with inodes that we use once for scrub and never touch
> > again.
> 
> I thought about adding this, but if we let the inodes fall out of the
> cache now then we'll just have to load them back in for the bmap checks,
> right?

Well, I'm looking at ensuring that we don't blow out the memory
side of things. We've still got the inode buffer in the buffer
cache, so I don't see why we should double cache these things
and then leave both cached copied hanging around after we've
finished with them. Leave the buffer around because we do a fair few
checks with it, but don't use excessive icache memory and trash the
working set if we can avoid it...

> > > +xfs_scrub_checkpoint_log(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	int			error;
> > > +
> > > +	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
> > > +	if (error)
> > > +		return error;
> > > +	xfs_ail_push_all_sync(mp->m_ail);
> > > +	return 0;
> > > +}
> > 
> > Oooo, that's a nasty thing to do on busy systems with large dirty
> > logs. I hope this is a "last resort" kind of thing....
> 
> It is; we only do this if the inobt says there's an inode there and the
> inode verifiers fail.

Ok, so why would pushing the log and the AIL make the verifier then
succeed? how likely is this to occur on a busy system?

> > > +/* Set us up with an inode. */
> > 
> > What state are we trying to get the inode into here? We grab all the
> > various locks, but we can still have data changing via mmap pages
> > that are already faulted in and delalloc extents in the incore
> > extent list that aren't reflected on disk...
> > 
> > A comment explaining what we expect here would be nice.
> 
> /* 
>  * Grab total control of the inode metadata.  It doesn't matter here if
>  * the file data is still changing, we just want exclusive access to the
>  * metadata.
>  */

*nod*

> > > +	/* Got the inode, lock it and we're ready to go. */
> > > +	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
> > > +	xfs_ilock(sc->ip, sc->ilock_flags);
> > > +	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
> > > +	if (error)
> > > +		goto out_unlock;
> > > +	sc->ilock_flags |= XFS_ILOCK_EXCL;
> > > +	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
> > 
> > Should the inode be joined to the transaction so that cancelling the
> > transaction unlocks the inode? Then the need for the ilock_flags
> > variable goes away....
> 
> This is the confluence of two semi-icky things: first, some of the
> scrubbers (particularly the dir and parent pointer scrubbers) will need
> to drop the ILOCK for short periods of time; later on, repair will want
> to keep the inode locked across all the repair transactions, so it makes
> more sense to control the lock and unlock directly.

Ok, I'll pass on this for now, see how the rest of the code falls
out.

> > > +	/* di_size */
> > > +	isize = be64_to_cpu(dip->di_size);
> > > +	if (isize & (1ULL << 63))
> > > +		xfs_scrub_ino_set_corrupt(sc, ino, bp);
> > 
> > Should we be checking against the on disk format size, or the
> > mounted filesystem maximum size (i.e. mp->m_super->s_maxbytes)?
> > 32 or 64 bit systems are going to have different maximum valid file
> > sizes..
> 
> It's perfectly valid to 'truncate -s $((2 ** 60) foofile' so the only

Ugh. We can't do IO past 16TB on 32 bit systems, so I'm kinda
surprised truncate doesn't have the same s_maxbytes restriction...

> thing we can really check for here is that the upper bit isn't set
> (because the VFS does not check, but barfs on, files with that large of
> a size).

xfs_max_file_offset() sets the max file offset to 2^63 - 1, so it
looks like the lack of checking in truncate is the problem here,
not the IO path.

> > Directories have a maximum bound size, too - the data space, leaf
> > space and freespace space, each of which are 32GB in size, IIRC.
> > 
> > And symlinks have a different maximum size, too.
> 
> Fair enough, I'll expand the i_size checks, though ISTR the verifiers
> now check that for us.

If they do, then just drop a comment in there to say what is checked
by the verifier.

> > > +	if (!S_ISDIR(mode) && !S_ISREG(mode) && !S_ISLNK(mode) && isize != 0)
> > > +		xfs_scrub_ino_set_corrupt(sc, ino, bp);
> > 
> > > +
> > > +	/* di_nblocks */
> > > +	if (flags2 & XFS_DIFLAG2_REFLINK) {
> > > +		; /* nblocks can exceed dblocks */
> > > +	} else if (flags & XFS_DIFLAG_REALTIME) {
> > > +		if (be64_to_cpu(dip->di_nblocks) >=
> > > +		    mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks)
> > > +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> > 
> > That doesn't seem right. the file can be on either the data or the
> > rt device, so the maximum file blocks is the size of one device or
> > the other, not both combined.
> 
> di_nblocks is the sum of (data blocks + bmbt blocks + attr blocks),
> right?

Yeah, forgot it was more than just data extents.

> So in theory if you had a rt file with 1000 data blocks, 10 bmbt
> blocks to map the data blocks, and 100 attr blocks then di_nblocks has
> to be 1110.

Yup, but the additional metadata on the data device is not going to
be anywhere near the size of the data device.

/me shrugs

I can't think of an easy way to get a maximum block count, so I
guess that'll have to do...

> > > +		if (nextents > fork_recs)
> > > +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> > > +		break;
> > > +	case XFS_DINODE_FMT_BTREE:
> > > +		if (nextents <= fork_recs)
> > > +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> > > +		break;
> > > +	case XFS_DINODE_FMT_LOCAL:
> > > +	case XFS_DINODE_FMT_DEV:
> > > +	case XFS_DINODE_FMT_UUID:
> > > +	default:
> > > +		if (nextents != 0)
> > > +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> > > +		break;
> > > +	}
> > > +
> > > +	/* di_anextents */
> > > +	nextents = be16_to_cpu(dip->di_anextents);
> > > +	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
> > > +	switch (dip->di_aformat) {
> > > +	case XFS_DINODE_FMT_EXTENTS:
> > > +		if (nextents > fork_recs)
> > > +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> > > +		break;
> > > +	case XFS_DINODE_FMT_BTREE:
> > > +		if (nextents <= fork_recs)
> > > +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> > > +		break;
> > > +	case XFS_DINODE_FMT_LOCAL:
> > > +	case XFS_DINODE_FMT_DEV:
> > > +	case XFS_DINODE_FMT_UUID:
> > > +	default:
> > > +		if (nextents != 0)
> > > +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> > > +		break;
> > > +	}
> > 
> > Don't we need a check here first to see whether an attribute fork
> > exists or not?
> 
> Do you mean the xfs_inode_fork, or something else?

SOmething else. :P

> XFS_DFORK_ASIZE returns zero if !XFS_DFORK_Q which in turn is based on
> di_forkoff so we're really only checking that di_aformat makes sense
> given the number of extents and the size of the attr fork area.

Right, but if XFS_DFORK_ASIZE == 0, the dip->di_aformat *must* be
XFS_DINODE_FMT_EXTENTS. That's the only valid configuration when
there is no attribute fork present.

If there is an attribute fork present, then it can be XFS_DINODE_FMT_LOCAL,
EXTENT or BTREE, and then the extent count needs checking.
XFS_DINODE_FMT_DEV and XFS_DINODE_FMT_UUID are both invalid for the
attribute fork.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

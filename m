Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33269 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750743AbdJEEFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2017 00:05:35 -0400
Date: Thu, 5 Oct 2017 15:04:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/25] xfs: scrub inodes
Message-ID: <20171005040452.GM3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706335008.19351.13005092237576865356.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150706335008.19351.13005092237576865356.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 01:42:30PM -0700, Darrick J. Wong wrote:
> @@ -559,3 +563,64 @@ xfs_scrub_setup_ag_btree(
>  
>  	return xfs_scrub_ag_init(sc, sc->sm->sm_agno, &sc->sa);
>  }
> +
> +/*
> + * Given an inode and the scrub control structure, grab either the
> + * inode referenced in the control structure or the inode passed in.
> + * The inode is not locked.
> + */
> +int
> +xfs_scrub_get_inode(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*ip_in)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_inode		*ips = NULL;

*ip?

> +	int				error;
> +
> +	if (sc->sm->sm_agno || (sc->sm->sm_gen && !sc->sm->sm_ino))
> +		return -EINVAL;

What's this checking?

> +
> +	/* We want to scan the inode we already had opened. */
> +	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino) {
> +		sc->ip = ip_in;
> +		return 0;
> +	}
> +
> +	/* Look up the inode, see if the generation number matches. */
> +	if (xfs_internal_inum(mp, sc->sm->sm_ino))
> +		return -ENOENT;

maybe xfs_internal_inum should be moved to the same place as all the
inode/agbno/bno verification functions....

> +	error = xfs_iget(mp, NULL, sc->sm->sm_ino, XFS_IGET_UNTRUSTED,
> +			0, &ips);

I think we also want XFS_IGET_DONTCACHE here, so we don't trash the
inode cache with inodes that we use once for scrub and never touch
again.

> +	if (error == -ENOENT || error == -EINVAL) {
> +		/* inode doesn't exist... */
> +		return -ENOENT;
> +	} else if (error) {
> +		trace_xfs_scrub_op_error(sc,
> +				XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
> +				XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
> +				error, __return_address);
> +		return error;
> +	}
> +	if (VFS_I(ips)->i_generation != sc->sm->sm_gen) {
> +		iput(VFS_I(ips));
> +		return -ENOENT;
> +	}
> +
> +	sc->ip = ips;
> +	return 0;
> +}
> +
> +/* Push everything out of the log onto disk. */
> +int
> +xfs_scrub_checkpoint_log(
> +	struct xfs_mount	*mp)
> +{
> +	int			error;
> +
> +	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
> +	if (error)
> +		return error;
> +	xfs_ail_push_all_sync(mp->m_ail);
> +	return 0;
> +}

Oooo, that's a nasty thing to do on busy systems with large dirty
logs. I hope this is a "last resort" kind of thing....

> +/* Set us up with an inode. */

What state are we trying to get the inode into here? We grab all the
various locks, but we can still have data changing via mmap pages
that are already faulted in and delalloc extents in the incore
extent list that aren't reflected on disk...

A comment explaining what we expect here would be nice.

> +int
> +xfs_scrub_setup_inode(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*ip)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	int				error;
> +
> +	/*
> +	 * Try to get the inode.  If the verifiers fail, we try again
> +	 * in raw mode.
> +	 */
> +	error = xfs_scrub_get_inode(sc, ip);
> +	switch (error) {
> +	case 0:
> +		break;
> +	case -EFSCORRUPTED:
> +	case -EFSBADCRC:
> +		return xfs_scrub_checkpoint_log(mp);
> +	default:
> +		return error;
> +	}
> +
> +	/* Got the inode, lock it and we're ready to go. */
> +	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
> +	xfs_ilock(sc->ip, sc->ilock_flags);
> +	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
> +	if (error)
> +		goto out_unlock;
> +	sc->ilock_flags |= XFS_ILOCK_EXCL;
> +	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);

Should the inode be joined to the transaction so that cancelling the
transaction unlocks the inode? Then the need for the ilock_flags
variable goes away....

> +
> +	return error;
> +out_unlock:
> +	xfs_iunlock(sc->ip, sc->ilock_flags);
> +	if (sc->ip != ip)
> +		iput(VFS_I(sc->ip));
> +	sc->ip = NULL;
> +	return error;
> +}
> +
> +/* Inode core */
> +
> +/* Scrub an inode. */
> +int
> +xfs_scrub_inode(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_imap			imap;
> +	struct xfs_dinode		di;
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_buf			*bp = NULL;
> +	struct xfs_dinode		*dip;
> +	xfs_ino_t			ino;
> +	size_t				fork_recs;
> +	unsigned long long		isize;
> +	uint64_t			flags2;
> +	uint32_t			nextents;
> +	uint32_t			extsize;
> +	uint32_t			cowextsize;
> +	uint16_t			flags;
> +	uint16_t			mode;
> +	bool				has_shared;
> +	int				error = 0;
> +
> +	/* Did we get the in-core inode, or are we doing this manually? */
> +	if (sc->ip) {
> +		ino = sc->ip->i_ino;
> +		xfs_inode_to_disk(sc->ip, &di, 0);
> +		dip = &di;
> +	} else {
> +		/* Map & read inode. */
> +		ino = sc->sm->sm_ino;
> +		error = xfs_imap(mp, sc->tp, ino, &imap, XFS_IGET_UNTRUSTED);
> +		if (error == -EINVAL) {
> +			/*
> +			 * Inode could have gotten deleted out from under us;
> +			 * just forget about it.
> +			 */
> +			error = -ENOENT;
> +			goto out;
> +		}
> +		if (!xfs_scrub_op_ok(sc, XFS_INO_TO_AGNO(mp, ino),
> +				XFS_INO_TO_AGBNO(mp, ino), &error))
> +			goto out;
> +
> +		error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> +				imap.im_blkno, imap.im_len, XBF_UNMAPPED, &bp,
> +				NULL);
> +		if (!xfs_scrub_op_ok(sc, XFS_INO_TO_AGNO(mp, ino),
> +				XFS_INO_TO_AGBNO(mp, ino), &error))
> +			goto out;
> +
> +		/* Is this really an inode? */
> +		bp->b_ops = &xfs_inode_buf_ops;
> +		dip = xfs_buf_offset(bp, imap.im_boffset);
> +		if (!xfs_dinode_verify(mp, ino, dip) ||
> +		    !xfs_dinode_good_version(mp, dip->di_version)) {
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +			goto out;
> +		}
> +
> +		/* ...and is it the one we asked for? */
> +		if (be32_to_cpu(dip->di_gen) != sc->sm->sm_gen) {
> +			error = -ENOENT;
> +			goto out;
> +		}
> +	}

Can we factor the manual mapping into a separate function? Just
makes it a bit cleaner and gets rid of a bunch of local variables
from this function that are just used to map and read the inode.

ANd reading on and getting ahead of the code, could we split it
further into

	<setup dip>

	xfs_scrub_dinode(sc, ino, dip, bp);

	<do live incore inode stuff>

> +
> +	flags = be16_to_cpu(dip->di_flags);
> +	if (dip->di_version >= 3)
> +		flags2 = be64_to_cpu(dip->di_flags2);
> +	else
> +		flags2 = 0;
> +
> +	/* di_mode */
> +	mode = be16_to_cpu(dip->di_mode);
> +	if (mode & ~(S_IALLUGO | S_IFMT))
> +		xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +
> +	/* v1/v2 fields */
> +	switch (dip->di_version) {
> +	case 1:
> +		if (dip->di_nlink != 0)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +
> +		if (dip->di_mode == 0 && sc->ip)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +
> +		if (dip->di_projid_lo != 0 || dip->di_projid_hi != 0)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;

We don't really support v1 inode format anymore - we convert it to
version 2 automatically in xfs_inode_from_disk() so the in-memory
inode is always v2 or v3, never v1. And when we write it back out,
we write it as a v2 inode, never as a v1 inode.

Hence I'm not sure whether we should be worrying about scrubbing
such inodes - they are going to be in an ever shrinking minority
of filesystems. At minimum, they should always return "preen".

> +	case 2:
> +	case 3:
> +		if (dip->di_onlink != 0)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +
> +		if (dip->di_mode == 0 && sc->ip)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +
> +		if (dip->di_projid_hi != 0 &&
> +		    !xfs_sb_version_hasprojid32bit(&mp->m_sb))
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	default:
> +		ASSERT(0);

If we don't understand the version, it's corrupt.

> +		break;
> +	}
> +
> +	/*
> +	 * di_uid/di_gid -- -1 isn't invalid, but there's no way that
> +	 * userspace could have created that.
> +	 */
> +	if (dip->di_uid == cpu_to_be32(-1U) ||
> +	    dip->di_gid == cpu_to_be32(-1U))
> +		xfs_scrub_ino_set_warning(sc, bp);
> +
> +	/* di_format */
> +	switch (dip->di_format) {
> +	case XFS_DINODE_FMT_DEV:
> +		if (!S_ISCHR(mode) && !S_ISBLK(mode) &&
> +		    !S_ISFIFO(mode) && !S_ISSOCK(mode))
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	case XFS_DINODE_FMT_LOCAL:
> +		if (!S_ISDIR(mode) && !S_ISLNK(mode))
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	case XFS_DINODE_FMT_EXTENTS:
> +		if (!S_ISREG(mode) && !S_ISDIR(mode) && !S_ISLNK(mode))
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	case XFS_DINODE_FMT_BTREE:
> +		if (!S_ISREG(mode) && !S_ISDIR(mode))
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	case XFS_DINODE_FMT_UUID:
> +	default:
> +		xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	}
> +
> +	/* di_size */
> +	isize = be64_to_cpu(dip->di_size);
> +	if (isize & (1ULL << 63))
> +		xfs_scrub_ino_set_corrupt(sc, ino, bp);

Should we be checking against the on disk format size, or the
mounted filesystem maximum size (i.e. mp->m_super->s_maxbytes)?
32 or 64 bit systems are going to have different maximum valid file
sizes..

Directories have a maximum bound size, too - the data space, leaf
space and freespace space, each of which are 32GB in size, IIRC.

And symlinks have a different maximum size, too.

> +	if (!S_ISDIR(mode) && !S_ISREG(mode) && !S_ISLNK(mode) && isize != 0)
> +		xfs_scrub_ino_set_corrupt(sc, ino, bp);

> +
> +	/* di_nblocks */
> +	if (flags2 & XFS_DIFLAG2_REFLINK) {
> +		; /* nblocks can exceed dblocks */
> +	} else if (flags & XFS_DIFLAG_REALTIME) {
> +		if (be64_to_cpu(dip->di_nblocks) >=
> +		    mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);

That doesn't seem right. the file can be on either the data or the
rt device, so the maximum file blocks is the size of one device or
the other, not both combined.

> +	} else {
> +		if (be64_to_cpu(dip->di_nblocks) >= mp->m_sb.sb_dblocks)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +	}
> +
> +	/* di_extsize */
> +	extsize = be32_to_cpu(dip->di_extsize);
> +	if (flags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT)) {
> +		if (extsize <= 0 || extsize > MAXEXTLEN)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +
> +		if (!(flags & XFS_DIFLAG_REALTIME) &&
> +		    extsize > mp->m_sb.sb_agblocks / 2)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +	} else {
> +		if (extsize != 0)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +	}

There more to validating the extentsize hints than this. From
xfs_ioctl_setattr_check_extsize():

/*
 * extent size hint validation is somewhat cumbersome. Rules are:
 *
 * 1. extent size hint is only valid for directories and regular files
 * 2. FS_XFLAG_EXTSIZE is only valid for regular files
 * 3. FS_XFLAG_EXTSZINHERIT is only valid for directories.
 * 4. can only be changed on regular files if no extents are allocated
 * 5. can be changed on directories at any time
 * 6. extsize hint of 0 turns off hints, clears inode flags.
 * 7. Extent size must be a multiple of the appropriate block size.
 * 8. for non-realtime files, the extent size hint must be limited
 *    to half the AG size to avoid alignment extending the extent beyond the
 *    limits of the AG.
 */

Maybe there's some commonality between these two functions...

> +
> +	/* di_flags */
> +	if ((flags & XFS_DIFLAG_IMMUTABLE) && (flags & XFS_DIFLAG_APPEND))
> +		xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +	if ((flags & XFS_DIFLAG_FILESTREAM) && (flags & XFS_DIFLAG_REALTIME))
> +		xfs_scrub_ino_set_corrupt(sc, ino, bp);

What about project id flags?

Also, there are flags that are allowed only on regular files, and
there are flags that are only allowed on directories. Those should
probably also be checked for preening.

> +
> +	/* di_nextents */
> +	nextents = be32_to_cpu(dip->di_nextents);
> +	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
> +	switch (dip->di_format) {
> +	case XFS_DINODE_FMT_EXTENTS:
> +		if (nextents > fork_recs)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	case XFS_DINODE_FMT_BTREE:
> +		if (nextents <= fork_recs)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	case XFS_DINODE_FMT_LOCAL:
> +	case XFS_DINODE_FMT_DEV:
> +	case XFS_DINODE_FMT_UUID:
> +	default:
> +		if (nextents != 0)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	}
> +
> +	/* di_anextents */
> +	nextents = be16_to_cpu(dip->di_anextents);
> +	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
> +	switch (dip->di_aformat) {
> +	case XFS_DINODE_FMT_EXTENTS:
> +		if (nextents > fork_recs)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	case XFS_DINODE_FMT_BTREE:
> +		if (nextents <= fork_recs)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	case XFS_DINODE_FMT_LOCAL:
> +	case XFS_DINODE_FMT_DEV:
> +	case XFS_DINODE_FMT_UUID:
> +	default:
> +		if (nextents != 0)
> +			xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	}

Don't we need a check here first to see whether an attribute fork
exists or not?

> +
> +	/* di_forkoff */
> +	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
> +		xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
> +		xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +
> +	/* di_aformat */
> +	if (dip->di_aformat != XFS_DINODE_FMT_LOCAL &&
> +	    dip->di_aformat != XFS_DINODE_FMT_EXTENTS &&
> +	    dip->di_aformat != XFS_DINODE_FMT_BTREE)
> +		xfs_scrub_ino_set_corrupt(sc, ino, bp);

Shouldn't this come before we use dip->di_aformat in a switch
statement? Hmmm - aren't we missing the same checks for the data
fork?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

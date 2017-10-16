Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:18185 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750731AbdJPFJd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 01:09:33 -0400
Date: Mon, 16 Oct 2017 16:09:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 28/30] xfs: scrub directory parent pointers
Message-ID: <20171016050928.GE3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777262776.1724.11135251107601015017.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777262776.1724.11135251107601015017.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:43:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Scrub parent pointers, sort of.  For directories, we can ride the
> '..' entry up to the parent to confirm that there's at most one
> dentry that points back to this directory.

....

> +/* Count the number of dentries in the parent dir that point to this inode. */
> +STATIC int
> +xfs_scrub_parent_count_parent_dentries(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*parent,
> +	xfs_nlink_t			*nlink)
> +{
> +	struct xfs_scrub_parent_ctx	spc = {
> +		.dc.actor = xfs_scrub_parent_actor,
> +		.dc.pos = 0,
> +		.ino = sc->ip->i_ino,
> +		.nlink = 0,
> +	};
> +	struct xfs_ifork		*ifp;
> +	size_t				bufsize;
> +	loff_t				oldpos;
> +	uint				lock_mode;
> +	int				error;
> +
> +	/*
> +	 * Load the parent directory's extent map.  A regular directory
> +	 * open would start readahead (and thus load the extent map)
> +	 * before we even got to a readdir call, but this isn't
> +	 * guaranteed here.
> +	 */
> +	lock_mode = xfs_ilock_data_map_shared(parent);
> +	ifp = XFS_IFORK_PTR(parent, XFS_DATA_FORK);
> +	if (XFS_IFORK_FORMAT(parent, XFS_DATA_FORK) == XFS_DINODE_FMT_BTREE &&
> +	    !(ifp->if_flags & XFS_IFEXTENTS)) {
> +		error = xfs_iread_extents(sc->tp, parent, XFS_DATA_FORK);
> +		if (error) {
> +			xfs_iunlock(parent, lock_mode);
> +			return error;
> +		}
> +	}
> +	xfs_iunlock(parent, lock_mode);

Why not just do what xfs_dir_open() does? i.e.

        /*
         * If there are any blocks, read-ahead block 0 as we're almost
         * certain to have the next operation be a read there.
         */
        mode = xfs_ilock_data_map_shared(ip);
        if (ip->i_d.di_nextents > 0)
                error = xfs_dir3_data_readahead(ip, 0, -1);
        xfs_iunlock(ip, mode);

> +	/*
> +	 * Iterate the parent dir to confirm that there is
> +	 * exactly one entry pointing back to the inode being
> +	 * scanned.
> +	 */
> +	bufsize = (size_t)min_t(loff_t, 32768, parent->i_d.di_size);

Perhaps we need a define for that 32k magic number now it's being
used in multiple places?

> +	oldpos = 0;
> +	while (true) {
> +		error = xfs_readdir(sc->tp, parent, &spc.dc, bufsize);
> +		if (error)
> +			goto out;
> +		if (oldpos == spc.dc.pos)
> +			break;
> +		oldpos = spc.dc.pos;
> +	}
> +	*nlink = spc.nlink;
> +out:
> +	return error;
> +}
> +
> +/* Scrub a parent pointer. */
> +int
> +xfs_scrub_parent(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_inode		*dp = NULL;
> +	xfs_ino_t			dnum;
> +	xfs_nlink_t			expected_nlink;
> +	xfs_nlink_t			nlink;
> +	int				tries = 0;
> +	int				error;
> +
> +	/*
> +	 * If we're a directory, check that the '..' link points up to
> +	 * a directory that has one entry pointing to us.
> +	 */
> +	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
> +		return -ENOENT;
> +
> +	/* We're not a special inode, are we? */
> +	if (!xfs_verify_dir_ino_ptr(mp, sc->ip->i_ino)) {
> +		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
> +		goto out;
> +	}
> +
> +	/*
> +	 * If we're an unlinked directory, the parent /won't/ have a link
> +	 * to us.  Otherwise, it should have one link.
> +	 */
> +	expected_nlink = VFS_I(sc->ip)->i_nlink == 0 ? 0 : 1;
> +
> +	/*
> +	 * The VFS grabs a read or write lock via i_rwsem before it reads
> +	 * or writes to a directory.  If we've gotten this far we've
> +	 * already obtained IOLOCK_EXCL, which (since 4.10) is the same as
> +	 * getting a write lock on i_rwsem.  Therefore, it is safe for us
> +	 * to drop the ILOCK here in order to do directory lookups.
> +	 */
> +	sc->ilock_flags &= ~(XFS_ILOCK_EXCL | XFS_MMAPLOCK_EXCL);
> +	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL | XFS_MMAPLOCK_EXCL);
> +
> +	/* Look up '..' */
> +	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
> +	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
> +		goto out;
> +	if (!xfs_verify_dir_ino_ptr(mp, dnum)) {
> +		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
> +		goto out;
> +	}
> +
> +	/* Is this the root dir?  Then '..' must point to itself. */
> +	if (sc->ip == mp->m_rootip) {
> +		if (sc->ip->i_ino != mp->m_sb.sb_rootino ||
> +		    sc->ip->i_ino != dnum)
> +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
> +		return 0;
> +	}

All good to here.

> +try_again:
> +	/* Otherwise, '..' must not point to ourselves. */
> +	if (sc->ip->i_ino == dnum) {
> +		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
> +		goto out;
> +	}
> +
> +	error = xfs_iget(mp, sc->tp, dnum, XFS_IGET_DONTCACHE, 0, &dp);
> +	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
> +		goto out;
> +	if (dp == sc->ip) {
> +		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
> +		goto out_rele;
> +	}
> +
> +	/*
> +	 * We prefer to keep the inode locked while we lock and search
> +	 * its alleged parent for a forward reference.  However, this
> +	 * child -> parent scheme can deadlock with the parent -> child
> +	 * scheme that is normally used.  Therefore, if we can lock the
> +	 * parent, just validate the references and get out.
> +	 */
> +	if (xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
> +		error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nlink);
> +		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0,
> +				&error))
> +			goto out_unlock;
> +		if (nlink != expected_nlink)
> +			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
> +		goto out_unlock;
> +	}
> +
> +	/*
> +	 * The game changes if we get here.  We failed to lock the parent,
> +	 * so we're going to try to verify both pointers while only holding
> +	 * one lock so as to avoid deadlocking with something that's actually
> +	 * trying to traverse down the directory tree.
> +	 */
> +	xfs_iunlock(sc->ip, sc->ilock_flags);
> +	sc->ilock_flags = 0;
> +	xfs_ilock(dp, XFS_IOLOCK_SHARED);
> +
> +	/* Go looking for our dentry. */
> +	error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nlink);
> +	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
> +		goto out_unlock;
> +
> +	/* Drop the parent lock, relock this inode. */
> +	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
> +	sc->ilock_flags = XFS_IOLOCK_EXCL;
> +	xfs_ilock(sc->ip, sc->ilock_flags);
> +
> +	/* Look up '..' to see if the inode changed. */
> +	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
> +	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
> +		goto out_rele;
> +
> +	/* Drat, parent changed.  Try again! */
> +	if (dnum != dp->i_ino) {
> +		iput(VFS_I(dp));
> +		tries++;
> +		if (tries < 20)
> +			goto try_again;
> +		xfs_scrub_set_incomplete(sc);
> +		goto out;
> +	}
> +	iput(VFS_I(dp));

Can you factor this into a loop and function?

	do {
		valid = xfs_scrub_parent_validate(&error)
		if (error)
			goto out_unlock;
	} while (!valid && ++retries < 20)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

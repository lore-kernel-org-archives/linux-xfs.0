Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16646 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbdJFTpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 15:45:43 -0400
Date: Fri, 6 Oct 2017 12:45:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 19/25] xfs: scrub directory metadata
Message-ID: <20171006194539.GL7122@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706336897.19351.7541168310430592724.stgit@magnolia>
 <20171006070714.GS3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171006070714.GS3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2017 at 06:07:14PM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 01:42:49PM -0700, Darrick J. Wong wrote:
> > +
> > +/* Set us up to scrub a file's contents. */
> > +int
> > +xfs_scrub_setup_inode_contents(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_inode		*ip,
> > +	unsigned int			resblks)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	int				error;
> > +
> > +	error = xfs_scrub_get_inode(sc, ip);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Got the inode, lock it and we're ready to go. */
> > +	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
> > +	xfs_ilock(sc->ip, sc->ilock_flags);
> > +	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
> > +	if (error)
> > +		goto out_unlock;
> > +	sc->ilock_flags |= XFS_ILOCK_EXCL;
> > +	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
> > +
> > +	return 0;
> > +out_unlock:
> > +	xfs_iunlock(sc->ip, sc->ilock_flags);
> > +	if (sc->ip != ip)
> > +		iput(VFS_I(sc->ip));
> > +	sc->ip = NULL;
> > +	return error;
> > +}
> 
> I've seen this get/lock/alloc code many times now - seems like scope
> for factoring?

(Yeah, they're all gone now.)

> > +/* Scrub a directory entry. */
> > +
> > +struct xfs_scrub_dir_ctx {
> > +	struct dir_context		dc;
> > +	struct xfs_scrub_context	*sc;
> > +};
> 
> These two character variable names make the code really hard to
> understand, especially when....
> 
> > +
> > +/* Check that an inode's mode matches a given DT_ type. */
> > +STATIC int
> > +xfs_scrub_dir_check_ftype(
> > +	struct xfs_scrub_dir_ctx	*sdc,
> 
> ... we now have sc, dc, and sdc all intertwined. Especially as some
> of these functions seem to invert the calling convention of the rest
> of the scrub code in that the scrub context is the primary object
> that is passed around and everything is attached to the sc....

The change in calling conventions is due to the fact that we're using
the VFS filldir iterator, which doesn't have a facility for passing
through a (void *).  To reuse that code,  we therefore must use this
annoying xfs_scrub_dir_ctx wrapper so that we can pass our own context
through to the _actor function.

Now, I /could/ make it a little clearer simply by doing this instead:

/*
 * Scrub a single directory entry.
 *
 * We use the VFS directory iterator (i.e. readdir) to call this
 * function for every directory entry in a directory.  Once we're here,
 * we check the inode number to make sure it's sane, then we check that
 * we can look up this filename.  Finally, we check the ftype.
 */
STATIC inline int
xfs_scrub_dir_entry(
	struct xfs_scrub_context	*sc,
	const char			*name,
	int				namelen,
	loff_t				pos,
	u64				ino,
	unsigned			type)
{
	/* do actual dirent scrubbing here */
}

/* Adapter for VFS filldir iterator function. */
STATIC int
xfs_scrub_readdir_actor(
	struct dir_context		*dir_iter,
	const char			*name,
	int				namelen,
	loff_t				pos,
	u64				ino,
	unsigned			type)
{
	struct xfs_scrub_dir_ctx	*sdc;

	sdc = container_of(dir_iter, struct xfs_scrub_dir_ctx, dir_iter);
	return xfs_scrub_dir_entry(sdc->sc, name, namelen, pos, ino, type);
}

At least that would contain the xfs_scrub_dir_ctx nastiness to a smaller
part of the code.  Better?

> Brain hurts trying to keep all this straight here...
> 
> /me keeps blundering around until it becomes apparent that
> dir_context has nothing to do with scrub, but is a VFS filldir
> callback structure triggered through readdir.

Correct.

> Darrick, can you add some comments explaining how the dirent
> scrubbing works?  It'd make it so much easier to understand if I
> didn't have to reverse engineer the intent and design from the
> patch. I'm going to skip this one for now...

Ok.  Down by the xfs_readdir call I will have:

/*
 * Look up every name in this directory by hash.
 *
 * Use the xfs_readdir function to call xfs_scrub_dir_actor on every
 * directory entry in this directory.  In _actor, we check the name,
 * inode number, and ftype (if applicable) of the entry.  xfs_readdir
 * uses the VFS filldir functions to provide iteration context.
 *
 * The VFS grabs a read or write lock via i_rwsem before it reads or
 * writes to a directory.  If we've gotten this far we've already
 * obtained IOLOCK_EXCL, which (since 4.10) is the same as getting a
 * write lock on i_rwsem.  Therefore, it is safe for us to drop the
 * ILOCK here in order to reuse the _readdir and _dir_lookup routines,
 * which do their own ILOCK locking.
 */

--D

> 
> CHeers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

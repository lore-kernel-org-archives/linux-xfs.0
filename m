Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1400 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932488AbdJPXab (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 19:30:31 -0400
Date: Tue, 17 Oct 2017 10:30:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 28/30] xfs: scrub directory parent pointers
Message-ID: <20171016233017.GN15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777262776.1724.11135251107601015017.stgit@magnolia>
 <20171016050928.GE3666@dastard>
 <20171016214601.GN4703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016214601.GN4703@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 02:46:01PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 16, 2017 at 04:09:28PM +1100, Dave Chinner wrote:
> > On Wed, Oct 11, 2017 at 06:43:47PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Scrub parent pointers, sort of.  For directories, we can ride the
> > > '..' entry up to the parent to confirm that there's at most one
> > > dentry that points back to this directory.
> > 
> > ....
> > 
> > > +/* Count the number of dentries in the parent dir that point to this inode. */
> > > +STATIC int
> > > +xfs_scrub_parent_count_parent_dentries(
> > > +	struct xfs_scrub_context	*sc,
> > > +	struct xfs_inode		*parent,
> > > +	xfs_nlink_t			*nlink)
> > > +{
> > > +	struct xfs_scrub_parent_ctx	spc = {
> > > +		.dc.actor = xfs_scrub_parent_actor,
> > > +		.dc.pos = 0,
> > > +		.ino = sc->ip->i_ino,
> > > +		.nlink = 0,
> > > +	};
> > > +	struct xfs_ifork		*ifp;
> > > +	size_t				bufsize;
> > > +	loff_t				oldpos;
> > > +	uint				lock_mode;
> > > +	int				error;
> > > +
> > > +	/*
> > > +	 * Load the parent directory's extent map.  A regular directory
> > > +	 * open would start readahead (and thus load the extent map)
> > > +	 * before we even got to a readdir call, but this isn't
> > > +	 * guaranteed here.
> > > +	 */
> > > +	lock_mode = xfs_ilock_data_map_shared(parent);
> > > +	ifp = XFS_IFORK_PTR(parent, XFS_DATA_FORK);
> > > +	if (XFS_IFORK_FORMAT(parent, XFS_DATA_FORK) == XFS_DINODE_FMT_BTREE &&
> > > +	    !(ifp->if_flags & XFS_IFEXTENTS)) {
> > > +		error = xfs_iread_extents(sc->tp, parent, XFS_DATA_FORK);
> > > +		if (error) {
> > > +			xfs_iunlock(parent, lock_mode);
> > > +			return error;
> > > +		}
> > > +	}
> > > +	xfs_iunlock(parent, lock_mode);
> > 
> > Why not just do what xfs_dir_open() does? i.e.
> > 
> >         /*
> >          * If there are any blocks, read-ahead block 0 as we're almost
> >          * certain to have the next operation be a read there.
> >          */
> >         mode = xfs_ilock_data_map_shared(ip);
> >         if (ip->i_d.di_nextents > 0)
> >                 error = xfs_dir3_data_readahead(ip, 0, -1);
> >         xfs_iunlock(ip, mode);
> 
> Ok.
> 
> > > +	/*
> > > +	 * Iterate the parent dir to confirm that there is
> > > +	 * exactly one entry pointing back to the inode being
> > > +	 * scanned.
> > > +	 */
> > > +	bufsize = (size_t)min_t(loff_t, 32768, parent->i_d.di_size);
> > 
> > Perhaps we need a define for that 32k magic number now it's being
> > used in multiple places?
> 
> Magic indeed; glibc uses the minimum of (4 * BUFSIZ) or (sizeof(struct
> dirent)); musl uses a static 2k buffer; dietlibc uses (PAGE_SIZE -
> sizeof(structure header))...
> 
> ...what would we call it?
> 
> /*
>  * The Linux API doesn't pass down the total size of the buffer we read
>  * into down to the filesystem.  With the filldir concept it's not
>  * needed for correct information, but the XFS dir2 leaf code wants an
>  * estimate of the buffer size to calculate its readahead window and
>  * size the buffers used for mapping to physical blocks.
>  *
>  * Try to give it an estimate that's good enough, maybe at some point we
>  * can change the ->readdir prototype to include the buffer size.  For
>  * now we use the current glibc buffer size.
>  */
> #define XFS_DEFAULT_READDIR_BUFSIZE	(32768)

That looks fine, though I think XFS_READDIR_BUFSIZE (or purple!) is
sufficient.

> (As a side question, do we want to bump this up to a full pagesize on
> architectures that have 64k pages?  I'd probably just leave it, but
> let's see if anyone running those architectures complains or sends in a
> patch?)

If it was to be dynamic, it should be determined by the directory
block size, not the arch page size.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

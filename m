Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:30698 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751418AbdJFWQw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 18:16:52 -0400
Date: Sat, 7 Oct 2017 09:16:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/25] xfs: scrub directory metadata
Message-ID: <20171006221648.GT3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706336897.19351.7541168310430592724.stgit@magnolia>
 <20171006070714.GS3666@dastard>
 <20171006194539.GL7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171006194539.GL7122@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2017 at 12:45:39PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 06, 2017 at 06:07:14PM +1100, Dave Chinner wrote:
> > On Tue, Oct 03, 2017 at 01:42:49PM -0700, Darrick J. Wong wrote:
> > > +/* Scrub a directory entry. */
> > > +
> > > +struct xfs_scrub_dir_ctx {
> > > +	struct dir_context		dc;
> > > +	struct xfs_scrub_context	*sc;
> > > +};
> > 
> > These two character variable names make the code really hard to
> > understand, especially when....
> > 
> > > +
> > > +/* Check that an inode's mode matches a given DT_ type. */
> > > +STATIC int
> > > +xfs_scrub_dir_check_ftype(
> > > +	struct xfs_scrub_dir_ctx	*sdc,
> > 
> > ... we now have sc, dc, and sdc all intertwined. Especially as some
> > of these functions seem to invert the calling convention of the rest
> > of the scrub code in that the scrub context is the primary object
> > that is passed around and everything is attached to the sc....
> 
> The change in calling conventions is due to the fact that we're using
> the VFS filldir iterator, which doesn't have a facility for passing
> through a (void *).  To reuse that code,  we therefore must use this
> annoying xfs_scrub_dir_ctx wrapper so that we can pass our own context
> through to the _actor function.
> 
> Now, I /could/ make it a little clearer simply by doing this instead:
> 
> /*
>  * Scrub a single directory entry.
>  *
>  * We use the VFS directory iterator (i.e. readdir) to call this
>  * function for every directory entry in a directory.  Once we're here,
>  * we check the inode number to make sure it's sane, then we check that
>  * we can look up this filename.  Finally, we check the ftype.
>  */
> STATIC inline int
> xfs_scrub_dir_entry(
> 	struct xfs_scrub_context	*sc,
> 	const char			*name,
> 	int				namelen,
> 	loff_t				pos,
> 	u64				ino,
> 	unsigned			type)
> {
> 	/* do actual dirent scrubbing here */
> }
> 
> /* Adapter for VFS filldir iterator function. */
> STATIC int
> xfs_scrub_readdir_actor(
> 	struct dir_context		*dir_iter,
> 	const char			*name,
> 	int				namelen,
> 	loff_t				pos,
> 	u64				ino,
> 	unsigned			type)
> {
> 	struct xfs_scrub_dir_ctx	*sdc;
> 
> 	sdc = container_of(dir_iter, struct xfs_scrub_dir_ctx, dir_iter);
> 	return xfs_scrub_dir_entry(sdc->sc, name, namelen, pos, ino, type);
> }
> 
> At least that would contain the xfs_scrub_dir_ctx nastiness to a smaller
> part of the code.  Better?

Yeah, that does help, and with the comments you've added it makes it
easier to wrap my feeble brain around. Thanks!

-Dave.

-- 
Dave Chinner
david@fromorbit.com

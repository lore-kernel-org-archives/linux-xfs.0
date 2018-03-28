Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:36390 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751106AbeC1Xmp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Mar 2018 19:42:45 -0400
Date: Thu, 29 Mar 2018 10:42:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/20] xfs: implement the metadata repair ioctl flag
Message-ID: <20180328234242.GF18129@dastard>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
 <152210860614.13184.13848520110703401019.stgit@magnolia>
 <20180327235514.GZ18129@dastard>
 <20180328045812.GL4818@magnolia>
 <20180328231915.GN4818@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180328231915.GN4818@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 28, 2018 at 04:19:15PM -0700, Darrick J. Wong wrote:
> On Tue, Mar 27, 2018 at 09:58:12PM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 28, 2018 at 10:55:14AM +1100, Dave Chinner wrote:
> > > On Mon, Mar 26, 2018 at 04:56:46PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Plumb in the pieces necessary to make the "scrub" subfunction of
> > > > the scrub ioctl actually work.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Can you list the pieces here - the ioctl, the errtag for debug, etc?
> > 
> > "This means that we make XFS_SCRUB_IFLAG_REPAIR actually do something
> > when userspace calls the scrub ioctl and add a debugging error tag so
> > that xfstests can force the kernel to repair things even when it's not
> > necessary."
> > 
> > > 
> > > ....
> > > 
> > > > +config XFS_ONLINE_REPAIR
> > > > +	bool "XFS online metadata repair support"
> > > > +	default n
> > > > +	depends on XFS_FS && XFS_ONLINE_SCRUB
> > > > +	help
> > > > +	  If you say Y here you will be able to repair metadata on a
> > > > +	  mounted XFS filesystem.  This feature is intended to reduce
> > > > +	  filesystem downtime even further by fixing minor problems
> > > 
> > > s/even further//
> > 
> > Ok.
> > 
> > > > +	  before they cause the filesystem to go down.  However, it
> > > > +	  requires that the filesystem be formatted with secondary
> > > > +	  metadata, such as reverse mappings and inode parent pointers.
> > > > +
> > > > +	  This feature is considered EXPERIMENTAL.  Use with caution!
> > > > +
> > > > +	  See the xfs_scrub man page in section 8 for additional information.
> > > > +
> > > > +	  If unsure, say N.
> > > 
> > > .....
> > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > > > index faf1a4e..8bf3ded 100644
> > > > --- a/fs/xfs/libxfs/xfs_fs.h
> > > > +++ b/fs/xfs/libxfs/xfs_fs.h
> > > > @@ -542,13 +542,20 @@ struct xfs_scrub_metadata {
> > > >  /* o: Metadata object looked funny but isn't corrupt. */
> > > >  #define XFS_SCRUB_OFLAG_WARNING		(1 << 6)
> > > >  
> > > > +/*
> > > > + * o: IFLAG_REPAIR was set but metadata object did not need fixing or
> > > > + *    optimization and has therefore not been altered.
> > > > + */
> > > > +#define XFS_SCRUB_OFLAG_UNTOUCHED	(1 << 7)
> > > 
> > > bikeshed: CLEAN rather than UNTOUCHED?
> > 
> > The thing I don't like about using 'CLEAN' is that we only set this flag
> > if userspace told us to touch (i.e. repair) the structure and the kernel
> > decides to leave it alone.
> 
> XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED?

Yeah, that's better.

> I uploaded the htmlized manpage for this ioctl:
> https://djwong.org/docs/ioctl-xfs-scrub-metadata.html
> 
> Hopefully that will make the meanings of all these flags and their
> intended usages clearer, which will make it easier to sift through all
> the code in here. :)

And that helps a lot, too.

> > > > +	/*
> > > > +	 * Repair whatever's broken.  We have to clear the out flags during the
> > > > +	 * repair call because some of our iterator functions abort if any of
> > > > +	 * the corruption flags are set.
> > > > +	 */
> > > > +	scrub_oflags = sc->sm->sm_flags & XFS_SCRUB_FLAGS_OUT;
> > > > +	sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
> > > > +	error = sc->ops->repair(sc, scrub_oflags);
> > > 
> > > Urk, that's a bit messy. Shouldn't we drive that inwards to just the
> > > iterator methods that have this problem? Then we can slowly work
> > > over the iterators that are problematic and fix them?
> > 
> > Hmm, I'll have a closer look tomorrow at which ones actually trigger
> > this...
> 
> Aha, it's the two calls to xfs_scrub_walk_agfl.  That function is almost
> generic enough to be a library function, so I'll promote it to a libxfs
> helper function:
> 
> /*
>  * Walk all the blocks in the AGFL.  The fn function can return any
>  * negative error code or XFS_BTREE_QUERY_RANGE_ABORT.
>  */
> int
> xfs_agfl_walk(
> 	struct xfs_mount	*mp,
> 	struct xfs_agf		*agf,
> 	struct xfs_buf		*agflbp,
> 	xfs_agfl_walk_fn	fn,
> 	void			*priv)
> {
> 	__be32			*agfl_bno;
> 	unsigned int		flfirst;
> 	unsigned int		fllast;
> 	int			i;
> 	int			error;
> 
> 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> 	flfirst = be32_to_cpu(agf->agf_flfirst);
> 	fllast = be32_to_cpu(agf->agf_fllast);
> 
> 	/* Nothing to walk in an empty AGFL. */
> 	if (agf->agf_flcount == cpu_to_be32(0))
> 		return 0;
> 
> 	/* first to last is a consecutive list. */
> 	if (fllast >= flfirst) {
> 		for (i = flfirst; i <= fllast; i++) {
> 			error = fn(mp, be32_to_cpu(agfl_bno[i]), priv);
> 			if (error)
> 				return error;
> 		}
> 
> 		return 0;
> 	}
> 
> 	/* first to the end */
> 	for (i = flfirst; i < xfs_agfl_size(mp); i++) {
> 		error = fn(mp, be32_to_cpu(agfl_bno[i]), priv);
> 		if (error)
> 			return error;
> 	}
> 
> 	/* the start to last. */
> 	for (i = 0; i <= fllast; i++) {
> 		error = fn(mp, be32_to_cpu(agfl_bno[i]), priv);
> 		if (error)
> 			return error;
> 	}
> 
> 	return 0;
> }
> 
> And then adapt the three callers to use the library function instead.
> 
> xfs_scrub_agfl_block() can return QUERY_ABORT if OFLAG_CORRUPT gets set,
> which will cause xfs_scrub_agfl to return as soon as it hits the first
> error.
> 
> xfs_repair_allocbt and xfs_repair_rmapbt can call the library function
> and then we don't need this weird quirk anymore.

Yup, that sounds like a good way to solve the problem. Thanks,
Darrick!

-Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46660 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933105AbdGTFvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2017 01:51:05 -0400
Date: Wed, 19 Jul 2017 22:50:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: consolidate local format inode fork verifiers
Message-ID: <20170720055057.GQ4224@magnolia>
References: <20170719160318.GP4224@magnolia>
 <20170720022602.GR17762@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170720022602.GR17762@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Jul 20, 2017 at 12:26:02PM +1000, Dave Chinner wrote:
> On Wed, Jul 19, 2017 at 09:03:18AM -0700, Darrick J. Wong wrote:
> > Create a centralized function to verify local format inode forks, then
> > migrate the existing short format directory verifier to use this
> > framework and add verifiers for the other two things we support (attrs
> > and symlinks).
> > 
> > Obviously this will get broken up into smaller pieces (one patch to
> > refactor/move the existing verifier calls, another one to add the two
> > new verifiers), but what do people think?
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.c      |   70 ++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_attr_leaf.h      |    1 +
> >  fs/xfs/libxfs/xfs_inode_fork.c     |   10 -----
> >  fs/xfs/libxfs/xfs_shared.h         |    1 +
> >  fs/xfs/libxfs/xfs_symlink_remote.c |   29 +++++++++++++++
> >  fs/xfs/xfs_icache.c                |   46 ++++++++++++++++++++++++
> >  fs/xfs/xfs_icache.h                |    1 +
> >  fs/xfs/xfs_inode.c                 |    6 +--
> >  8 files changed, 150 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index c6c15e5..43b881e 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -871,6 +871,76 @@ xfs_attr_shortform_allfit(
> >  	return xfs_attr_shortform_bytesfit(dp, bytes);
> >  }
> >  
> > +/* Verify the consistency of an inline attribute fork. */
> > +int
> > +xfs_attr_shortform_verify(
> > +	struct xfs_inode		*ip)
> > +{
> > +	struct xfs_attr_shortform	*sfp;
> > +	struct xfs_attr_sf_entry	*sfep;
> > +	struct xfs_attr_sf_entry	*next_sfep;
> > +	char				*endp;
> > +	struct xfs_ifork		*ifp;
> > +	int				i;
> > +	int				size;
> > +
> > +	ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL);
> > +	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
> > +	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
> > +	size = ifp->if_bytes;
> > +
> > +	/*
> > +	 * Give up if the attribute is way too short.
> > +	 */
> > +	if (size < sizeof (struct xfs_attr_sf_hdr))
> > +		return -EFSCORRUPTED;
> 
> This seems to already be checked in xfs_iformat_fork() for
> attr forks. There are also inconsistent checks between data/attr
> forks whether size is valid prior formatting the fork, so there's
> more cleanup needed there, and if we are checking attr/dir validity
> in these functions, we shouldn't be peeking inside the fork
> in xfs_iformat_fork().

Hm.  Right now iformat_fork seems to want to use sf attr header totsize
as the size of the attr fork, but that only works if the attr fork area
is large enough to have a full sf attr header, and... (keep reading)

> > +	endp = (char *)sfp + size;
> > +
> > +	/* Check all reported entries */
> > +	sfep = &sfp->list[0];
> > +	for (i = 0; i < sfp->hdr.count; i++) {
> > +		/*
> > +		 * struct xfs_attr_sf_entry has a variable length.
> > +		 * Check the fixed-offset parts of the structure are
> > +		 * within the data buffer.
> > +		 */
> > +		if (((char *)sfep + sizeof(*sfep)) >= endp)
> > +			return -EFSCORRUPTED;
> > +
> > +		/* Don't allow names with known bad length. */
> > +		if (sfep->namelen == 0)
> > +			return -EFSCORRUPTED;
> > +
> > +		/*
> > +		 * Check that the variable-length part of the structure is
> > +		 * within the data buffer.  The next entry starts after the
> > +		 * name component, so nextentry is an acceptable test.
> > +		 */
> > +		next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
> > +		if (endp < (char *)next_sfep)
> > +			return -EFSCORRUPTED;
> 
> Can we make the "past endp" checks consistent in variable order and
> operators? i.e
> 
> 		if ((char *)next_sfep >= endp)

Sure.

> 
> [snip]
> 
> > diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> > index c484877..96e2957 100644
> > --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> > +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> > @@ -207,3 +207,32 @@ xfs_symlink_local_to_remote(
> >  	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
> >  					ifp->if_bytes - 1);
> >  }
> > +
> > +/* Verify the consistency of an inline symlink. */
> > +int
> > +xfs_symlink_sf_verify(
> > +	struct xfs_inode	*ip)
> > +{
> > +	char			*sfp;
> > +	char			*endp;
> > +	struct xfs_ifork	*ifp;
> > +	int			size;
> > +
> > +	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
> > +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +	sfp = (char *)ifp->if_u1.if_data;
> > +	size = ifp->if_bytes;
> > +	endp = sfp + size;
> > +
> > +	/* No negative sizes or overly long symlink targets. */
> > +	if (size < 0 || size > XFS_SYMLINK_MAXLEN)
> > +		return -EFSCORRUPTED;
> > +
> > +	/* No NULLs in the target either. */
> > +	for (; sfp < endp; sfp++) {
> > +		if (*sfp == 0)
> > +			return -EFSCORRUPTED;
> > +	}
> 
> Hmmm - do we need to check that the symlink has been correctly null
> terminated in memory (i.e. that *endp == 0) because the VFS requires
> this and we add the zero termination before checking fork contents
> validity?
> 
> > +/* Check inline fork contents. */
> > +int
> > +xfs_iget_verify_forks(
> 
> *_verify_inline_content()?
> 
> > +	struct xfs_inode		*ip)
> > +{
> > +	int				error;
> 
> Too much indenting :P
> 
> > +
> > +	/* Check the attribute fork if there is one. */
> > +	if (XFS_IFORK_PTR(ip, XFS_ATTR_FORK) &&
> > +	    ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> 
> If there is no attr fork, then ip->i_d.di_aformat should be set to
> XFS_DINODE_FMT_EXTENTS. Hence we can just do the same check as
> for the data fork....
> 
> OTOH, having a value of XFS_DINODE_FMT_LOCAL in di_aformat without
> an attr fork indicates corruption, so perhaps we need to catch that

Hm, the documentation ought to reflect that. :)

> here as it's not checked in xfs_ifork_format() or xfs_iflush_int().
> Indeed, there are partial attr/data fork format/size checks in
> xfs_ifork_format() and xfs_iflush_int(), but we don't do
> comprehensive checks in either place. Maybe they should all be moved
> inside this function and expanded to check that all the fork format
> information is valid?

Yes, this could get cleaned up this way...  What if we make
_iformat_fork check that the sizes requested aren't insane, allocate
memory, and load contents from the dinode; then we later use
_verify_ifork_content to pick all the bugs out and destroy the inode if
we finds any.

Hm.  The bmbt root actually needs numrecs read out of the header.  The
sf attr header has the total size, though we're never going to need more
than (inodesize - forkoff) bytes for it.  The bmdr thing could
complicate this.

(Maybe I'll sleep on this...)

Also, I thought di_forkoff was multiplied by 8 to calculate the distance
of the attr fork from the data fork?  If that's the case, then isn't
this verifier wrong?

    if (unlikely(dip->di_forkoff > ip->i_mount->m_sb.sb_inodesize)) {

<rambling off topic now>

While we're on the subject of verifiers, Eric Sandeen has been wishing
that we could make it easier to figure out which buffer verifier test
failed, and it would seem that the XFS_CORRUPTION_ERROR macro is used to
highlight bad inode fork contents.  Perhaps we should create a similar
macro that we could use to log exactly which buffer verifier test
failed?

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

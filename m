Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37072 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932471AbeGDD05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 23:26:57 -0400
Date: Tue, 3 Jul 2018 20:26:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/21] xfs: zap broken inode forks
Message-ID: <20180704032142.GD32415@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986829769.3155.762174417583296955.stgit@magnolia>
 <20180704020706.GL2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180704020706.GL2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 04, 2018 at 12:07:06PM +1000, Dave Chinner wrote:
> On Sun, Jun 24, 2018 at 12:24:57PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Determine if inode fork damage is responsible for the inode being unable
> > to pass the ifork verifiers in xfs_iget and zap the fork contents if
> > this is true.  Once this is done the fork will be empty but we'll be
> > able to construct an in-core inode, and a subsequent call to the inode
> > fork repair ioctl will search the rmapbt to rebuild the records that
> > were in the fork.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.c |   32 ++-
> >  fs/xfs/libxfs/xfs_attr_leaf.h |    2 
> >  fs/xfs/libxfs/xfs_bmap.c      |   21 ++
> >  fs/xfs/libxfs/xfs_bmap.h      |    2 
> >  fs/xfs/scrub/inode_repair.c   |  399 +++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 437 insertions(+), 19 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index b3c19339e1b5..f6c458104934 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -894,23 +894,16 @@ xfs_attr_shortform_allfit(
> >  	return xfs_attr_shortform_bytesfit(dp, bytes);
> >  }
> >  
> > -/* Verify the consistency of an inline attribute fork. */
> > +/* Verify the consistency of a raw inline attribute fork. */
> >  xfs_failaddr_t
> > -xfs_attr_shortform_verify(
> > -	struct xfs_inode		*ip)
> > +xfs_attr_shortform_verify_struct(
> > +	struct xfs_attr_shortform	*sfp,
> > +	size_t				size)
> 
> The internal structure checking functions in the directory code
> use the naming convention xfs_dir3_<type>_check(). I think we should use
> the same here. i.e. xfs_attr_sf_check().

Ok.

> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index b7f094e19bab..b1254e6c17b5 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -6223,18 +6223,16 @@ xfs_bmap_finish_one(
> >  	return error;
> >  }
> >  
> > -/* Check that an inode's extent does not have invalid flags or bad ranges. */
> > +/* Check that an extent does not have invalid flags or bad ranges. */
> >  xfs_failaddr_t
> > -xfs_bmap_validate_extent(
> > -	struct xfs_inode	*ip,
> > +xfs_bmbt_validate_extent(
> 
> xfs_bmbt_ prefixes should only appear in xfs_bmap_btree.c, not
> xfs_bmap.c....
> 
> So either it needs to get moved or renamed to something like
> xfs_bmap_validate_irec()?

Hmm, well the only difference between the two functions is that one
gets what it needs out of struct xfs_inode and the other takes all the
raw inputs.  They both take xfs_bmbt_irec, so...

xfs_failaddr_t
__xfs_bmbt_validate_irec(
	struct xfs_mount	*mp,
	bool			isrt,
	int			whichfork,
	struct xfs_bmbt_irec	*irec)

xfs_failaddr_t
xfs_bmap_validate_irec(
	struct xfs_inode	*ip,
	int			whichfork,
	struct xfs_bmbt_irec	*irec)

?

> 
> > diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> > index 4ac43c1b1eb0..b941f21d7667 100644
> > --- a/fs/xfs/scrub/inode_repair.c
> > +++ b/fs/xfs/scrub/inode_repair.c
> > @@ -22,11 +22,15 @@
> >  #include "xfs_ialloc.h"
> >  #include "xfs_da_format.h"
> >  #include "xfs_reflink.h"
> > +#include "xfs_alloc.h"
> >  #include "xfs_rmap.h"
> > +#include "xfs_rmap_btree.h"
> >  #include "xfs_bmap.h"
> > +#include "xfs_bmap_btree.h"
> >  #include "xfs_bmap_util.h"
> >  #include "xfs_dir2.h"
> >  #include "xfs_quota_defs.h"
> > +#include "xfs_attr_leaf.h"
> >  #include "scrub/xfs_scrub.h"
> >  #include "scrub/scrub.h"
> >  #include "scrub/common.h"
> > @@ -113,7 +117,8 @@ xfs_repair_inode_mode(
> >  STATIC void
> >  xfs_repair_inode_flags(
> >  	struct xfs_scrub_context	*sc,
> > -	struct xfs_dinode		*dip)
> > +	struct xfs_dinode		*dip,
> > +	bool				is_rt_file)
> >  {
> >  	struct xfs_mount		*mp = sc->mp;
> >  	uint64_t			flags2;
> > @@ -132,6 +137,10 @@ xfs_repair_inode_flags(
> >  		flags2 &= ~XFS_DIFLAG2_REFLINK;
> >  	if (flags2 & XFS_DIFLAG2_REFLINK)
> >  		flags2 &= ~XFS_DIFLAG2_DAX;
> > +	if (is_rt_file)
> > +		flags |= XFS_DIFLAG_REALTIME;
> > +	else
> > +		flags &= ~XFS_DIFLAG_REALTIME;
> 
> This needs to be done first. i.e. before we check things like rt vs
> reflink flags.

Ok.

> > @@ -210,17 +219,402 @@ xfs_repair_inode_extsize_hints(
> >  	}
> >  }
> >  
> > +struct xfs_repair_inode_fork_counters {
> > +	struct xfs_scrub_context	*sc;
> > +	xfs_rfsblock_t			data_blocks;
> > +	xfs_rfsblock_t			rt_blocks;
> 
> inode is either data or rt, not both. Why do you need two separate
> counters? Oh, bmbt blocks are always data, right? Coment, perhaps?

Ok.

/* blocks on the data device, including bmbt blocks. */
	xfs_rfsblock_t			data_blocks;

/* rt_blocks: blocks on the realtime device, if any. */
	xfs_rfsblock_t			rt_blocks;

> > +	xfs_rfsblock_t			attr_blocks;
> > +	xfs_extnum_t			data_extents;
> > +	xfs_extnum_t			rt_extents;
> 
> but bmbt blocks are not data extents, so only one counter here?

In theory we'd look on all the rmapbt's and error out if we find data
fork blocks on both...

> > +/* Count extents and blocks for a given inode from all rmap data. */
> > +STATIC int
> > +xfs_repair_inode_count_rmaps(
> > +	struct xfs_repair_inode_fork_counters	*rifc)
> > +{
> > +	xfs_agnumber_t			agno;
> > +	int				error;
> > +
> > +	if (!xfs_sb_version_hasrmapbt(&rifc->sc->mp->m_sb) ||
> > +	    xfs_sb_version_hasrealtime(&rifc->sc->mp->m_sb))
> > +		return -EOPNOTSUPP;
> > +
> > +	/* XXX: find rt blocks too */
> 
> Ok, needs a comment up front that realtime repair isn't supported,
> rather than hiding it down here.

...but all this is clumsily roped off while there's no rt rmap. :)

> > +	for (agno = 0; agno < rifc->sc->mp->m_sb.sb_agcount; agno++) {
> > +		error = xfs_repair_inode_count_ag_rmaps(rifc, agno);
> > +		if (error)
> > +			return error;
> > +	}
> 
> 	/* rt not supported yet */
> 	ASSERT(rifc->rt_extents == 0);

I'll move the feature checking up to the start of xfs_repair_inode.

> > +	/* Can't have extents on both the rt and the data device. */
> > +	if (rifc->data_extents && rifc->rt_extents)
> > +		return -EFSCORRUPTED;
> > +
> > +	return 0;
> > +}
> > +
> > +/* Figure out if we need to zap this extents format fork. */
> > +STATIC bool
> > +xfs_repair_inode_core_check_extents_fork(
> 
> 
> Urk. Not sure what this function is supposed to be doing from the
> name. xrep_ifork_extent_check()? And then the next function
> becomes xrep_ifork_btree_check()?
> 
> Also document the return values.


/*
 * Decide if this extents-format inode fork looks like garbage.  If so,
 * return true.
 */

> 
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_dinode		*dip,
> > +	int				dfork_size,
> > +	int				whichfork)
> > +{
> > +	struct xfs_bmbt_irec		new;
> > +	struct xfs_bmbt_rec		*dp;
> > +	bool				isrt;
> > +	int				i;
> > +	int				nex;
> > +	int				fork_size;
> > +
> > +	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> > +	fork_size = nex * sizeof(struct xfs_bmbt_rec);
> > +	if (fork_size < 0 || fork_size > dfork_size)
> > +		return true;
> 
> Check nex against dip->di_nextents?

Isn't XFS_DFORK_NEXTENTS just dip->di_nextents?

Nevertheless, it should be range checked.

> > +	dp = (struct xfs_bmbt_rec *)XFS_DFORK_PTR(dip, whichfork);
> > +
> > +	isrt = dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME);
> > +	for (i = 0; i < nex; i++, dp++) {
> > +		xfs_failaddr_t	fa;
> > +
> > +		xfs_bmbt_disk_get_all(dp, &new);
> > +		fa = xfs_bmbt_validate_extent(sc->mp, isrt, whichfork, &new);
> > +		if (fa)
> > +			return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> > +/* Figure out if we need to zap this btree format fork. */
> > +STATIC bool
> > +xfs_repair_inode_core_check_btree_fork(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_dinode		*dip,
> > +	int				dfork_size,
> > +	int				whichfork)
> > +{
> > +	struct xfs_bmdr_block		*dfp;
> > +	int				nrecs;
> > +	int				level;
> > +
> > +	if (XFS_DFORK_NEXTENTS(dip, whichfork) <=
> > +			dfork_size / sizeof(struct xfs_bmbt_irec))
> > +		return true;
> 
> check against dip->di_nextents?

Yes.

> > +	dfp = (struct xfs_bmdr_block *)XFS_DFORK_PTR(dip, whichfork);
> > +	nrecs = be16_to_cpu(dfp->bb_numrecs);
> > +	level = be16_to_cpu(dfp->bb_level);
> > +
> > +	if (nrecs == 0 || XFS_BMDR_SPACE_CALC(nrecs) > dfork_size)
> > +		return true;
> > +	if (level == 0 || level > XFS_BTREE_MAXLEVELS)
> > +		return true;
> 
> Should this visit the bmbt blocks to check the level is actually
> correct?

The bmbt checker will detect and repair that.

> > +	return false;
> > +}
> > +
> > +/*
> > + * Check the data fork for things that will fail the ifork verifiers or the
> > + * ifork formatters.
> > + */
> > +STATIC bool
> > +xfs_repair_inode_core_check_data_fork(
> 
> xrep_ifork_check_data()

<nod>

> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_dinode		*dip,
> > +	uint16_t			mode)
> > +{
> > +	uint64_t			size;
> > +	int				dfork_size;
> > +
> > +	size = be64_to_cpu(dip->di_size);
> > +	switch (mode & S_IFMT) {
> > +	case S_IFIFO:
> > +	case S_IFCHR:
> > +	case S_IFBLK:
> > +	case S_IFSOCK:
> > +		if (XFS_DFORK_FORMAT(dip, XFS_DATA_FORK) != XFS_DINODE_FMT_DEV)
> > +			return true;
> > +		break;
> > +	case S_IFREG:
> > +	case S_IFLNK:
> > +	case S_IFDIR:
> > +		switch (XFS_DFORK_FORMAT(dip, XFS_DATA_FORK)) {
> > +		case XFS_DINODE_FMT_LOCAL:
> 
> local format is not valid for S_IFREG.

<nod>

> > +		case XFS_DINODE_FMT_EXTENTS:
> > +		case XFS_DINODE_FMT_BTREE:
> > +			break;
> > +		default:
> > +			return true;
> > +		}
> > +		break;
> > +	default:
> > +		return true;
> > +	}
> > +	dfork_size = XFS_DFORK_SIZE(dip, sc->mp, XFS_DATA_FORK);
> > +	switch (XFS_DFORK_FORMAT(dip, XFS_DATA_FORK)) {
> > +	case XFS_DINODE_FMT_DEV:
> > +		break;
> > +	case XFS_DINODE_FMT_LOCAL:
> > +		if (size > dfork_size)
> > +			return true;
> > +		break;
> > +	case XFS_DINODE_FMT_EXTENTS:
> > +		if (xfs_repair_inode_core_check_extents_fork(sc, dip,
> > +				dfork_size, XFS_DATA_FORK))
> > +			return true;
> > +		break;
> > +	case XFS_DINODE_FMT_BTREE:
> > +		if (xfs_repair_inode_core_check_btree_fork(sc, dip,
> > +				dfork_size, XFS_DATA_FORK))
> > +			return true;
> > +		break;
> > +	default:
> > +		return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> > +/* Reset the data fork to something sane. */
> > +STATIC void
> > +xfs_repair_inode_core_zap_data_fork(
> 
> xrep_ifork_zap_data()
> 
> (you get the idea :P)
> 
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_dinode		*dip,
> > +	uint16_t			mode,
> > +	struct xfs_repair_inode_fork_counters	*rifc)
> 
> (structure names can change, too :)

Yay!

	struct xrep_ifork_counters	*rifc;

> > +{
> > +	char				*p;
> > +	const struct xfs_dir_ops	*ops;
> > +	struct xfs_dir2_sf_hdr		*sfp;
> > +	int				i8count;
> > +
> > +	/* Special files always get reset to DEV */
> > +	switch (mode & S_IFMT) {
> > +	case S_IFIFO:
> > +	case S_IFCHR:
> > +	case S_IFBLK:
> > +	case S_IFSOCK:
> > +		dip->di_format = XFS_DINODE_FMT_DEV;
> > +		dip->di_size = 0;
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * If we have data extents, reset to an empty map and hope the user
> > +	 * will run the bmapbtd checker next.
> > +	 */
> > +	if (rifc->data_extents || rifc->rt_extents || S_ISREG(mode)) {
> > +		dip->di_format = XFS_DINODE_FMT_EXTENTS;
> > +		dip->di_nextents = 0;
> > +		return;
> > +	}
> 
> Does the userspace tool run the bmapbtd checker next?

Yes.

> > +	/* Otherwise, reset the local format to the minimum. */
> > +	switch (mode & S_IFMT) {
> > +	case S_IFLNK:
> > +		/* Blow out symlink; now it points to root dir */
> > +		dip->di_format = XFS_DINODE_FMT_LOCAL;
> > +		dip->di_size = cpu_to_be64(1);
> > +		p = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
> > +		*p = '/';
> 
> Maybe factor this so zero length symlinks can be set directly to the
> same thing? FWIW, would making it point at '.' be better than '/' so
> it always points within the same filesystem?

Perhaps?  I'll take any other suggestions the list has for appropriate
targets that don't point anywhere.

I though your earlier suggestion of setting the link target to "broken
link repaired by xfs_scrub" was quite amusing. :)

> > +		break;
> > +	case S_IFDIR:
> > +		/*
> > +		 * Blow out dir, make it point to the root.  In the
> > +		 * future the direction repair will reconstruct this
> > +		 * dir for us.
> > +		 */
> 
> s/the direction//

Ok.

> > +		dip->di_format = XFS_DINODE_FMT_LOCAL;
> > +		i8count = sc->mp->m_sb.sb_rootino > XFS_DIR2_MAX_SHORT_INUM;
> > +		ops = xfs_dir_get_ops(sc->mp, NULL);
> > +		sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_PTR(dip,
> > +				XFS_DATA_FORK);
> > +		sfp->count = 0;
> > +		sfp->i8count = i8count;
> > +		ops->sf_put_parent_ino(sfp, sc->mp->m_sb.sb_rootino);
> > +		dip->di_size = cpu_to_be64(xfs_dir2_sf_hdr_size(i8count));
> 
> What happens now if this dir has an ancestor still pointing at it?
> Haven't we just screwed the directory structure? How does this
> interact with the dentry cache, esp. w.r.t. disconnected dentries
> (filehandle lookups)?

Hmm, good question. :)

> > +/*
> > + * Check the attr fork for things that will fail the ifork verifiers or the
> > + * ifork formatters.
> > + */
> > +STATIC bool
> > +xfs_repair_inode_core_check_attr_fork(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_dinode		*dip)
> > +{
> > +	struct xfs_attr_shortform	*sfp;
> > +	int				size;
> > +
> > +	if (XFS_DFORK_BOFF(dip) == 0)
> > +		return dip->di_aformat != XFS_DINODE_FMT_EXTENTS ||
> > +		       dip->di_anextents != 0;
> > +
> > +	size = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
> > +	switch (XFS_DFORK_FORMAT(dip, XFS_ATTR_FORK)) {
> > +	case XFS_DINODE_FMT_LOCAL:
> > +		sfp = (struct xfs_attr_shortform *)XFS_DFORK_PTR(dip,
> > +				XFS_ATTR_FORK);
> 
> As a side note, we should make XFS_DFORK_PTR() return a void * so we
> don't need casts like this.

Ok.

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

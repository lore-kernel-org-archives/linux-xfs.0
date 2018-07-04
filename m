Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38878 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753192AbeGDDls (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 23:41:48 -0400
Date: Tue, 3 Jul 2018 20:41:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/21] xfs: repair inode block maps
Message-ID: <20180704034141.GE32415@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986830398.3155.17588593858936667680.stgit@magnolia>
 <20180704030022.GN2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180704030022.GN2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 04, 2018 at 01:00:22PM +1000, Dave Chinner wrote:
> On Sun, Jun 24, 2018 at 12:25:04PM -0700, Darrick J. Wong wrote:
> > +#include "scrub/repair.h"
> > +
> > +/* Inode fork block mapping (BMBT) repair. */
> > +
> > +struct xfs_repair_bmap_extent {
> > +	struct list_head		list;
> > +	struct xfs_rmap_irec		rmap;
> > +	xfs_agnumber_t			agno;
> > +};
> > +
> > +struct xfs_repair_bmap {
> > +	struct list_head		*extlist;
> > +	struct xfs_repair_extent_list	*btlist;
> > +	struct xfs_scrub_context	*sc;
> > +	xfs_ino_t			ino;
> > +	xfs_rfsblock_t			otherfork_blocks;
> > +	xfs_rfsblock_t			bmbt_blocks;
> > +	xfs_extnum_t			extents;
> > +	int				whichfork;
> > +};
> > +
> > +/* Record extents that belong to this inode's fork. */
> > +STATIC int
> > +xfs_repair_bmap_extent_fn(
> > +	struct xfs_btree_cur		*cur,
> > +	struct xfs_rmap_irec		*rec,
> > +	void				*priv)
> > +{
> > +	struct xfs_repair_bmap		*rb = priv;
> > +	struct xfs_repair_bmap_extent	*rbe;
> > +	struct xfs_mount		*mp = cur->bc_mp;
> > +	xfs_fsblock_t			fsbno;
> > +	int				error = 0;
> > +
> > +	if (xfs_scrub_should_terminate(rb->sc, &error))
> > +		return error;
> > +
> > +	/* Skip extents which are not owned by this inode and fork. */
> > +	if (rec->rm_owner != rb->ino) {
> > +		return 0;
> > +	} else if (rb->whichfork == XFS_DATA_FORK &&
> > +		 (rec->rm_flags & XFS_RMAP_ATTR_FORK)) {
> > +		rb->otherfork_blocks += rec->rm_blockcount;
> > +		return 0;
> > +	} else if (rb->whichfork == XFS_ATTR_FORK &&
> > +		 !(rec->rm_flags & XFS_RMAP_ATTR_FORK)) {
> > +		rb->otherfork_blocks += rec->rm_blockcount;
> > +		return 0;
> > +	}
> > +
> > +	rb->extents++;
> 
> Shouldn't this be incremented after we've checked for and processed
> old BMBT blocks?

Yes.

> > +	/* Delete the old bmbt blocks later. */
> > +	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
> > +		fsbno = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
> > +				rec->rm_startblock);
> > +		rb->bmbt_blocks += rec->rm_blockcount;
> > +		return xfs_repair_collect_btree_extent(rb->sc, rb->btlist,
> > +				fsbno, rec->rm_blockcount);
> > +	}
> ....
> > +
> > +/* Check for garbage inputs. */
> > +STATIC int
> > +xfs_repair_bmap_check_inputs(
> > +	struct xfs_scrub_context	*sc,
> > +	int				whichfork)
> > +{
> > +	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
> > +
> > +	/* Don't know how to repair the other fork formats. */
> > +	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> > +	    XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE)
> > +		return -EOPNOTSUPP;
> > +
> > +	/* Only files, symlinks, and directories get to have data forks. */
> > +	if (whichfork == XFS_DATA_FORK && !S_ISREG(VFS_I(sc->ip)->i_mode) &&
> > +	    !S_ISDIR(VFS_I(sc->ip)->i_mode) && !S_ISLNK(VFS_I(sc->ip)->i_mode))
> > +		return -EINVAL;
> 
> That'd be nicer as a switch statement.

Will fix.

> > +
> > +	/* If we somehow have delalloc extents, forget it. */
> > +	if (whichfork == XFS_DATA_FORK && sc->ip->i_delayed_blks)
> > +		return -EBUSY;
> 
> and this can be rolled into the same if (datafork) branch.
> 
> ....
> > +	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb))
> > +		return -EOPNOTSUPP;
> 
> Do this first?

It's redundant, see xfs_repair_bmap_check_inputs.  Will remove this one.

> Hmmm, and if you do the attr fork check second then the rest
> of the code is all data fork. i.e.
> 
> 	if (!rmap)
> 		return -EOPNOTSUPP
> 	if (attrfork) {
> 		if (no attr fork)
> 			return ....
> 		return 0
> 	}
> 	/* now do all data fork checks */
> 
> This becomes a lot easier to follow.

Ok.

> > +/*
> > + * Collect block mappings for this fork of this inode and decide if we have
> > + * enough space to rebuild.  Caller is responsible for cleaning up the list if
> > + * anything goes wrong.
> > + */
> > +STATIC int
> > +xfs_repair_bmap_find_mappings(
> > +	struct xfs_scrub_context	*sc,
> > +	int				whichfork,
> > +	struct list_head		*mapping_records,
> > +	struct xfs_repair_extent_list	*old_bmbt_blocks,
> > +	xfs_rfsblock_t			*old_bmbt_block_count,
> > +	xfs_rfsblock_t			*otherfork_blocks)
> > +{
> > +	struct xfs_repair_bmap		rb;
> > +	xfs_agnumber_t			agno;
> > +	unsigned int			resblks;
> > +	int				error;
> > +
> > +	memset(&rb, 0, sizeof(rb));
> > +	rb.extlist = mapping_records;
> > +	rb.btlist = old_bmbt_blocks;
> > +	rb.ino = sc->ip->i_ino;
> > +	rb.whichfork = whichfork;
> > +	rb.sc = sc;
> > +
> > +	/* Iterate the rmaps for extents. */
> > +	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
> > +		error = xfs_repair_bmap_scan_ag(&rb, agno);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	/*
> > +	 * Guess how many blocks we're going to need to rebuild an entire bmap
> > +	 * from the number of extents we found, and pump up our transaction to
> > +	 * have sufficient block reservation.
> > +	 */
> > +	resblks = xfs_bmbt_calc_size(sc->mp, rb.extents);
> > +	error = xfs_trans_reserve_more(sc->tp, resblks, 0);
> > +	if (error)
> > +		return error;
> 
> I don't really like this, but I can't think of a way around needing
> it at the moment.

Me neither.

(That is to say, I can't think of a way around it that doesn't involve
backing all the way out to the setup function, which would be pretty
gruesome.)

> > +
> > +	*otherfork_blocks = rb.otherfork_blocks;
> > +	*old_bmbt_block_count = rb.bmbt_blocks;
> > +	return 0;
> > +}
> > +
> > +/* Update the inode counters. */
> > +STATIC int
> > +xfs_repair_bmap_reset_counters(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_rfsblock_t			old_bmbt_block_count,
> > +	xfs_rfsblock_t			otherfork_blocks,
> > +	int				*log_flags)
> > +{
> > +	int				error;
> > +
> > +	xfs_trans_ijoin(sc->tp, sc->ip, 0);
> > +
> > +	/*
> > +	 * Drop the block counts associated with this fork since we'll re-add
> > +	 * them with the bmap routines later.
> > +	 */
> > +	sc->ip->i_d.di_nblocks = otherfork_blocks;
> 
> This needs a little more explanation. i.e. that the rmap walk we
> just performed for this fork also counted all the data and bmbt
> blocks for the other fork so this is really only zeroing the block
> count for the fork we are about to rebuild.

/*
 * We're going to use the bmap routines to reconstruct a fork from rmap
 * records.  Those functions increment di_nblocks for us, so we need to
 * subtract out all the data and bmbt blocks from the fork we're about
 * to rebuild.  otherfork_blocks reflects all the data and bmbt blocks
 * for the other fork, so this assignment effectively performs the
 * subtraction for us.
 */

> 
> > +/* Initialize a new fork and implant it in the inode. */
> > +STATIC void
> > +xfs_repair_bmap_reset_fork(
> > +	struct xfs_scrub_context	*sc,
> > +	int				whichfork,
> > +	bool				has_mappings,
> > +	int				*log_flags)
> > +{
> > +	/* Set us back to extents format with zero records. */
> > +	XFS_IFORK_FMT_SET(sc->ip, whichfork, XFS_DINODE_FMT_EXTENTS);
> > +	XFS_IFORK_NEXT_SET(sc->ip, whichfork, 0);
> > +
> > +	/* Reinitialize the on-disk fork. */
> 
> I don't think this touches the on-disk fork - it's re-initialising
> the in-memory fork.

Will fix.

> > +	if (XFS_IFORK_PTR(sc->ip, whichfork) != NULL)
> > +		xfs_idestroy_fork(sc->ip, whichfork);
> > +	if (whichfork == XFS_DATA_FORK) {
> > +		memset(&sc->ip->i_df, 0, sizeof(struct xfs_ifork));
> > +		sc->ip->i_df.if_flags |= XFS_IFEXTENTS;
> > +	} else if (whichfork == XFS_ATTR_FORK) {
> > +		if (has_mappings) {
> > +			sc->ip->i_afp = NULL;
> > +		} else {
> > +			sc->ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone,
> > +					KM_SLEEP);
> > +			sc->ip->i_afp->if_flags |= XFS_IFEXTENTS;
> > +		}
> > +	}

/*
 * Now that we've reinitialized the in-memory fork and set the inode
 * back to extents format with zero extents, any extents that we
 * subsequently map into the file will reinitialize the on-disk fork
 * area for us.  All we have to do is log the inode core to preserve
 * the format and extent count fields.
 */

> > +	*log_flags |= XFS_ILOG_CORE;
> > +}
> ......
> 
> > +/* Repair an inode fork. */
> > +STATIC int
> > +xfs_repair_bmap(
> > +	struct xfs_scrub_context	*sc,
> > +	int				whichfork)
> > +{
> > +	struct list_head		mapping_records;
> > +	struct xfs_repair_extent_list	old_bmbt_blocks;
> > +	struct xfs_inode		*ip = sc->ip;
> > +	xfs_rfsblock_t			old_bmbt_block_count;
> > +	xfs_rfsblock_t			otherfork_blocks;
> > +	int				log_flags = 0;
> > +	int				error = 0;
> > +
> > +	error = xfs_repair_bmap_check_inputs(sc, whichfork);
> > +	if (error)
> > +		return error;
> > +
> > +	/*
> > +	 * If this is a file data fork, wait for all pending directio to
> > +	 * complete, then tear everything out of the page cache.
> > +	 */
> > +	if (S_ISREG(VFS_I(ip)->i_mode) && whichfork == XFS_DATA_FORK) {
> > +		inode_dio_wait(VFS_I(ip));
> > +		truncate_inode_pages(VFS_I(ip)->i_mapping, 0);
> > +	}
> 
> Why would we be waiting only for DIO here? Haven't we already locked
> up the inode, flushed dirty data, waited for dio and invalidated the
> page cache when we called xfs_scrub_setup_inode_bmap() prior to
> doing this work?

Extra paranoia?  IOWs I don't know why. :)

Probably we should xfs_break_layouts here though.

--D

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

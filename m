Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44969 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751487AbdJFRAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 13:00:48 -0400
Date: Fri, 6 Oct 2017 10:00:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/25] xfs: scrub inode block mappings
Message-ID: <20171006170044.GJ7122@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706335646.19351.8363960454156993724.stgit@magnolia>
 <20171006025123.GQ3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171006025123.GQ3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2017 at 01:51:23PM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 01:42:36PM -0700, Darrick J. Wong wrote:
> > +/* Set us up with an inode's bmap. */
> > +STATIC int
> > +__xfs_scrub_setup_inode_bmap(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_inode		*ip,
> > +	bool				flush_data)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	int				error;
> > +
> > +	error = xfs_scrub_get_inode(sc, ip);
> > +	if (error)
> > +		return error;
> > +
> > +	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
> > +	xfs_ilock(sc->ip, sc->ilock_flags);
> > +
> > +	/*
> > +	 * We don't want any ephemeral data fork updates sitting around
> > +	 * while we inspect block mappings, so wait for directio to finish
> > +	 * and flush dirty data if we have delalloc reservations.
> > +	 */
> > +	if (S_ISREG(VFS_I(sc->ip)->i_mode) && flush_data) {
> > +		inode_dio_wait(VFS_I(sc->ip));
> > +		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
> > +		if (error)
> > +			goto out_unlock;
> > +		error = invalidate_inode_pages2(VFS_I(sc->ip)->i_mapping);
> > +		if (error)
> > +			goto out_unlock;
> > +	}
> 
> The same flush and invalidate is done in xfs_fs_map_blocks and
> xfs_ioctl_setattr_dax_invalidate. we used to have helper functions
> to do this, but we got rid of them because we removed all the
> cases where such behaviour was necessary. Now we're adding them
> back, perhaps we should have a helper for this again?

Hmmm... looking at all the filemap_write_and_wait callers in the kernel:

xfs_ioctl_setattr_dax_invalidate flushes & invalidates the page cache
xfs_vm_bmap flushes dirty pages only
xfs_reflink_unshare flushes a range of dirty pages
xfs_fs_map_blocks flushes & invalidates pagecache
xfs_setattr_size flushes between old and new EOF
xfs_getbmap flushes dirty pages
xfs_flush_unmap_range flushes and rips out the page cache

Looking at the one caller of invalidate_inode_pages* that I hadn't
already mentioned:

xfs_fs_commit_blocks invalidates a range of pagecache

And looking at the callers of truncate_pagecache_range:

xfs_file_iomap_end_delalloc truncates pagecache for a partial delalloc write

So you're right, the only usage patterns that match are the two that you
suggested.  However, I got to thinking last night, do we actually need
to invalidate pagecache if we're /only/ doing a readonly check of the
data fork mappings?  I see a good argument for doing so if we need to
rebuild the data maps, but since scrub never dirties anything, the page
cache needn't be nuked here.

I'm going to try changing this code only to invalidate if userspace set
IFLAG_REPAIR.

> > +	/* Got the inode, lock it and we're ready to go. */
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
> 
> Slightly tricky - how many places do we end up having to do this?
> If its more than one, perhaps we need a xfs_scrub_irele(sc, ip)
> helper?

Three places, two of which are setup functions and the third is the
teardown function.  The teardown function is always called even if setup
fails, so I'll just purge those out and let xfs_scrub_teardown do this
once.  With a better comment.

> > +/*
> > + * Inode fork block mapping (BMBT) scrubber.
> > + * More complex than the others because we have to scrub
> > + * all the extents regardless of whether or not the fork
> > + * is in btree format.
> > + */
> > +
> > +struct xfs_scrub_bmap_info {
> > +	struct xfs_scrub_context	*sc;
> > +	xfs_daddr_t			eofs;
> > +	xfs_fileoff_t			lastoff;
> > +	bool				is_rt;
> > +	bool				is_shared;
> > +	int				whichfork;
> > +};
> > +
> > +/* Scrub a single extent record. */
> > +STATIC int
> > +xfs_scrub_bmap_extent(
> > +	struct xfs_inode		*ip,
> > +	struct xfs_btree_cur		*cur,
> > +	struct xfs_scrub_bmap_info	*info,
> > +	struct xfs_bmbt_irec		*irec)
> > +{
> > +	struct xfs_scrub_ag		sa = { 0 };
> > +	struct xfs_mount		*mp = info->sc->mp;
> > +	struct xfs_buf			*bp = NULL;
> > +	xfs_daddr_t			daddr;
> > +	xfs_daddr_t			dlen;
> > +	xfs_fsblock_t			bno;
> > +	xfs_agnumber_t			agno;
> > +	int				error = 0;
> > +
> > +	if (cur)
> > +		xfs_btree_get_block(cur, 0, &bp);
> > +
> > +	if (irec->br_startoff < info->lastoff ||
> > +	    irec->br_startblock == HOLESTARTBLOCK ||
> > +	    isnullstartblock(irec->br_startblock))
> > +		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
> > +				irec->br_startoff);
> 
> What are we checking here? that it's ordered correctly and not a
> hole/delalloc record? If it is bad, shouldn't we just jump out here
> because the following checks are likely to throw silly errors on
> hole/delalloc mappings?

Yes, I rewrote this section to use xfs_verify_fsbno and jump out if
corrupt.  I plan to make all the check functions skip the xref if
OFLAG_CORRUPT is set by the time we finish the record sanity checks.

> > +	/* Actual mapping, so check the block ranges. */
> > +	if (info->is_rt) {
> > +		daddr = XFS_FSB_TO_BB(mp, irec->br_startblock);
> > +		agno = NULLAGNUMBER;
> > +		bno = irec->br_startblock;
> > +	} else {
> > +		daddr = XFS_FSB_TO_DADDR(mp, irec->br_startblock);
> > +		agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
> > +		if (agno >= mp->m_sb.sb_agcount) {
> > +			xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
> > +				irec->br_startoff);
> > +			goto out;
> > +		}
> > +		bno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
> > +		if (bno >= mp->m_sb.sb_agblocks)
> > +			xfs_scrub_fblock_set_corrupt(info->sc,
> > +						     info->whichfork,
> > +						     irec->br_startoff);
> 
> more verify_agbno()/verify_fsbno stuff.
> 
> > +	}
> > +	dlen = XFS_FSB_TO_BB(mp, irec->br_blockcount);
> > +	if (irec->br_blockcount <= 0 ||
> > +	    irec->br_blockcount > MAXEXTLEN ||
> 
> irec->br_blockcount is unsigned (uint64_t).
> 
> Also needs to be checked against AG size.
> 
> > +	    daddr >= info->eofs ||
> > +	    daddr + dlen > info->eofs)
> > +		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
> > +				irec->br_startoff);
> > +
> > +	if (irec->br_state == XFS_EXT_UNWRITTEN &&
> > +	    !xfs_sb_version_hasextflgbit(&mp->m_sb))
> 
> Superblock scrubber should reject any filesystem without the
> extflgbit as corrupt - it's always set by mkfs - so I'm not sure we
> need to check this here.

What happens if scrub encounters a v4 filesystem without EXTFLGBIT?
The superblock scrubber only checks that the secondary superblocks are
consistent (geometry-wise) with sb 0, and mount doesn't prohibit
!EXTFLGBIT filesystems from mounting.  fallocate and friends even work,
albeit slower because we actually write zeroes to the disk in lieu of
setting the unwritten flag, apparently.

But, seeing as mkfs always sets EXTFLGBIT and v5 implies the feature
even if the bit isn't set; and there's no way to turn off the feature
bit (except unsupported things like xfs_db -x), are you suggesting that
we should simply end support for mounting !EXTFLGBIT v4 filesystems?

> > +/* Scrub an inode fork's block mappings. */
> > +STATIC int
> > +xfs_scrub_bmap(
> > +	struct xfs_scrub_context	*sc,
> > +	int				whichfork)
> > +{
> > +	struct xfs_bmbt_irec		irec;
> > +	struct xfs_scrub_bmap_info	info = {0};
> > +	struct xfs_owner_info		oinfo;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_inode		*ip = sc->ip;
> > +	struct xfs_ifork		*ifp;
> > +	struct xfs_btree_cur		*cur;
> > +	xfs_fileoff_t			endoff;
> > +	xfs_extnum_t			idx;
> > +	bool				found;
> > +	int				error = 0;
> > +
> > +	ifp = XFS_IFORK_PTR(ip, whichfork);
> > +
> > +	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
> > +	info.eofs = XFS_FSB_TO_BB(mp, info.is_rt ? mp->m_sb.sb_rblocks :
> > +					      mp->m_sb.sb_dblocks);
> > +	info.whichfork = whichfork;
> > +	info.is_shared = whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(ip);
> > +	info.sc = sc;
> > +
> > +	switch (whichfork) {
> > +	case XFS_COW_FORK:
> > +		/* Non-existent CoW forks are ignorable. */
> > +		if (!ifp)
> > +			goto out_unlock;
> > +		/* No CoW forks on non-reflink inodes/filesystems. */
> > +		if (!xfs_is_reflink_inode(ip)) {
> > +			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino, NULL);
> > +			goto out_unlock;
> > +		}
> > +		break;
> > +	case XFS_ATTR_FORK:
> > +		if (!ifp)
> > +			goto out_unlock;
> > +		if (!xfs_sb_version_hasattr(&mp->m_sb) &&
> > +		    !xfs_sb_version_hasattr2(&mp->m_sb))
> > +			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino, NULL);
> > +		break;
> > +	}
> > +
> > +	/* Check the fork values */
> > +	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
> > +	case XFS_DINODE_FMT_UUID:
> > +	case XFS_DINODE_FMT_DEV:
> > +	case XFS_DINODE_FMT_LOCAL:
> > +		/* No mappings to check. */
> > +		goto out_unlock;
> > +	case XFS_DINODE_FMT_EXTENTS:
> > +		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > +			xfs_scrub_fblock_set_corrupt(sc, whichfork, 0);
> > +			goto out_unlock;
> > +		}
> > +		break;
> > +	case XFS_DINODE_FMT_BTREE:
> > +		ASSERT(whichfork != XFS_COW_FORK);
> 
> Corruption check, jump to out?

Oops, yes.

> > +
> > +		/* Scan the btree records. */
> > +		cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
> > +		xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
> > +		error = xfs_scrub_btree(sc, cur, xfs_scrub_bmapbt_helper,
> > +				&oinfo, &info);
> > +		xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
> > +						  XFS_BTREE_NOERROR);
> 
> FYI, I missed that the on-disk bmbt was scanned here the first time
> I went through this code - i had to go back and work out why the
> code only appeared to scrub the incore extent list. Can you wrap
> this whole chunk of code into a helper named xfs_scrub_bmbt()
> so it stands out that this is where the on disk btree is scrubbed?

Sure.  I'll update the xfs_scrub_bmap comment to point this out too.

> 
> > +		if (error == -EDEADLOCK)
> > +			return error;
> 
> Ok, why don't we go to out_unlock here?

<urk> bad code.

> 
> > +		else if (error)
> > +			goto out_unlock;
> 
> But do for all other errors....
> 
> > +		break;
> > +	default:
> > +		xfs_scrub_fblock_set_corrupt(sc, whichfork, 0);
> > +		goto out_unlock;
> > +	}
> > +
> > +	/* Extent data is in memory, so scrub that. */
> > +
> > +	/* Find the offset of the last extent in the mapping. */
> > +	error = xfs_bmap_last_offset(ip, &endoff, whichfork);
> > +	if (!xfs_scrub_fblock_op_ok(sc, whichfork, 0, &error))
> > +		goto out_unlock;
> > +
> > +	/* Scrub extent records. */
> > +	info.lastoff = 0;
> > +	ifp = XFS_IFORK_PTR(ip, whichfork);
> > +	for (found = xfs_iext_lookup_extent(ip, ifp, 0, &idx, &irec);
> > +	     found != 0;
> > +	     found = xfs_iext_get_extent(ifp, ++idx, &irec)) {
> > +		if (xfs_scrub_should_terminate(sc, &error))
> > +			break;
> > +		if (isnullstartblock(irec.br_startblock))
> > +			continue;
> > +		if (irec.br_startoff >= endoff) {
> > +			xfs_scrub_fblock_set_corrupt(sc, whichfork,
> > +					irec.br_startoff);
> > +			goto out_unlock;
> > +		}
> > +		error = xfs_scrub_bmap_extent(ip, NULL, &info, &irec);
> > +		if (error == -EDEADLOCK)
> > +			return error;
> > +	}
> > +
> > +out_unlock:
> > +	return error;
> 
> Hmmm - out_unlock doesn't unlock anything?

Heh, it never does.  Baaaaaaaaad label.

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

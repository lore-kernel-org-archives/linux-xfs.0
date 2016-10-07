Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45747 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932611AbcJGTok (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 15:44:40 -0400
Date: Fri, 7 Oct 2016 12:44:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 41/63] xfs: reflink extents from one file to another
Message-ID: <20161007194430.GE11241@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520500568.29434.12086636072867873080.stgit@birch.djwong.org>
 <20161007180415.GD58659@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161007180415.GD58659@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Oct 07, 2016 at 02:04:15PM -0400, Brian Foster wrote:
> On Thu, Sep 29, 2016 at 08:10:05PM -0700, Darrick J. Wong wrote:
> > Reflink extents from one file to another; that is to say, iteratively
> > remove the mappings from the destination file, copy the mappings from
> > the source file to the destination file, and increment the reference
> > count of all the blocks that got remapped.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: Call xfs_defer_cancel before cancelling the transaction if the
> > remap operation fails.  Use the deferred operations system to avoid
> > deadlocks or blowing out the transaction reservation, and make the
> > entire reflink operation atomic for each extent being remapped.  The
> > destination file's i_size will be updated if necessary to avoid
> > violating the assumption that there are no shared blocks past the EOF
> > block.
> > ---
> >  fs/xfs/xfs_reflink.c |  425 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_reflink.h |    2 
> >  2 files changed, 427 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 673ecc1..94c19fff 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -922,3 +922,428 @@ xfs_reflink_recover_cow(
> >  
> >  	return error;
> >  }
> ...
> > +/*
> > + * Unmap a range of blocks from a file, then map other blocks into the hole.
> > + * The range to unmap is (destoff : destoff + srcioff + irec->br_blockcount).
> > + * The extent irec is mapped into dest at irec->br_startoff.
> > + */
> > +STATIC int
> > +xfs_reflink_remap_extent(
> > +	struct xfs_inode	*ip,
> > +	struct xfs_bmbt_irec	*irec,
> > +	xfs_fileoff_t		destoff,
> > +	xfs_off_t		new_isize)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_trans	*tp;
> > +	xfs_fsblock_t		firstfsb;
> > +	unsigned int		resblks;
> > +	struct xfs_defer_ops	dfops;
> > +	struct xfs_bmbt_irec	uirec;
> > +	bool			real_extent;
> > +	xfs_filblks_t		rlen;
> > +	xfs_filblks_t		unmap_len;
> > +	xfs_off_t		newlen;
> > +	int			error;
> > +
> > +	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
> > +	trace_xfs_reflink_punch_range(ip, destoff, unmap_len);
> > +
> > +	/* Only remap normal extents. */
> > +	real_extent =  (irec->br_startblock != HOLESTARTBLOCK &&
> > +			irec->br_startblock != DELAYSTARTBLOCK &&
> > +			!ISUNWRITTEN(irec));
> > +
> > +	/* Start a rolling transaction to switch the mappings */
> > +	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> > +	if (error)
> > +		goto out;
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, ip, 0);
> > +
> > +	/* If we're not just clearing space, then do we have enough quota? */
> > +	if (real_extent) {
> > +		error = xfs_trans_reserve_quota_nblks(tp, ip,
> > +				irec->br_blockcount, 0, XFS_QMOPT_RES_REGBLKS);
> > +		if (error)
> > +			goto out_cancel;
> > +	}
> > +
> > +	trace_xfs_reflink_remap(ip, irec->br_startoff,
> > +				irec->br_blockcount, irec->br_startblock);
> > +
> > +	/* Unmap the old blocks in the data fork. */
> > +	rlen = unmap_len;
> > +	while (rlen) {
> > +		xfs_defer_init(&dfops, &firstfsb);
> > +		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1,
> > +				&firstfsb, &dfops);
> > +		if (error)
> > +			goto out_defer;
> > +
> > +		/* Trim the extent to whatever got unmapped. */
> > +		uirec = *irec;
> > +		xfs_trim_extent(&uirec, destoff + rlen, unmap_len - rlen);
> > +		unmap_len = rlen;
> > +
> > +		/* If this isn't a real mapping, we're done. */
> > +		if (!real_extent || uirec.br_blockcount == 0)
> > +			goto next_extent;
> > +
> 
> Any reason we couldn't reuse existing mechanisms for this? E.g., hole
> punch the dest file range before we remap the source file extents. That
> might change behavior in the event of a partial/failed reflink, but it's
> not clear to me that matters.

It matters a lot for the dedupe operation -- the unmap and remap
operations must be atomic with each other so that if the dedupe
operation fails, the user will still see the same file contents after
reboot/recovery.  We don't want users to find their files suddenly full
of zeroes.

For reflink I suspect that you're right, but we already guarantee that
the user sees either the old contents or the new contents, so yay. :)

> 
> > +		trace_xfs_reflink_remap(ip, uirec.br_startoff,
> > +				uirec.br_blockcount, uirec.br_startblock);
> > +
> ...
> > +}
> > +
> > +/*
> > + * Iteratively remap one file's extents (and holes) to another's.
> > + */
> > +STATIC int
> > +xfs_reflink_remap_blocks(
> > +	struct xfs_inode	*src,
> > +	xfs_fileoff_t		srcoff,
> > +	struct xfs_inode	*dest,
> > +	xfs_fileoff_t		destoff,
> > +	xfs_filblks_t		len,
> > +	xfs_off_t		new_isize)
> > +{
> > +	struct xfs_bmbt_irec	imap;
> > +	int			nimaps;
> > +	int			error = 0;
> > +	xfs_filblks_t		range_len;
> > +
> > +	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
> > +	while (len) {
> > +		trace_xfs_reflink_remap_blocks_loop(src, srcoff, len,
> > +				dest, destoff);
> > +		/* Read extent from the source file */
> > +		nimaps = 1;
> > +		xfs_ilock(src, XFS_ILOCK_EXCL);
> > +		error = xfs_bmapi_read(src, srcoff, len, &imap, &nimaps, 0);
> > +		xfs_iunlock(src, XFS_ILOCK_EXCL);
> > +		if (error)
> > +			goto err;
> > +		ASSERT(nimaps == 1);
> > +
> > +		trace_xfs_reflink_remap_imap(src, srcoff, len, XFS_IO_OVERWRITE,
> > +				&imap);
> > +
> > +		/* Translate imap into the destination file. */
> > +		range_len = imap.br_startoff + imap.br_blockcount - srcoff;
> > +		imap.br_startoff += destoff - srcoff;
> > +
> 
> Just FYI... these are all unsigned vars...

Yeah.  It should handle that correctly.  See generic/30[34].

--D

> 
> Brian
> 
> > +		/* Clear dest from destoff to the end of imap and map it in. */
> > +		error = xfs_reflink_remap_extent(dest, &imap, destoff,
> > +				new_isize);
> > +		if (error)
> > +			goto err;
> > +
> > +		if (fatal_signal_pending(current)) {
> > +			error = -EINTR;
> > +			goto err;
> > +		}
> > +
> > +		/* Advance drange/srange */
> > +		srcoff += range_len;
> > +		destoff += range_len;
> > +		len -= range_len;
> > +	}
> > +
> > +	return 0;
> > +
> > +err:
> > +	trace_xfs_reflink_remap_blocks_error(dest, error, _RET_IP_);
> > +	return error;
> > +}
> > +
> > +/*
> > + * Link a range of blocks from one file to another.
> > + */
> > +int
> > +xfs_reflink_remap_range(
> > +	struct xfs_inode	*src,
> > +	xfs_off_t		srcoff,
> > +	struct xfs_inode	*dest,
> > +	xfs_off_t		destoff,
> > +	xfs_off_t		len)
> > +{
> > +	struct xfs_mount	*mp = src->i_mount;
> > +	xfs_fileoff_t		sfsbno, dfsbno;
> > +	xfs_filblks_t		fsblen;
> > +	int			error;
> > +
> > +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > +		return -EOPNOTSUPP;
> > +
> > +	if (XFS_FORCED_SHUTDOWN(mp))
> > +		return -EIO;
> > +
> > +	/* Don't reflink realtime inodes */
> > +	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
> > +		return -EINVAL;
> > +
> > +	trace_xfs_reflink_remap_range(src, srcoff, len, dest, destoff);
> > +
> > +	/* Lock both files against IO */
> > +	if (src->i_ino == dest->i_ino) {
> > +		xfs_ilock(src, XFS_IOLOCK_EXCL);
> > +		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
> > +	} else {
> > +		xfs_lock_two_inodes(src, dest, XFS_IOLOCK_EXCL);
> > +		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
> > +	}
> > +
> > +	error = xfs_reflink_set_inode_flag(src, dest);
> > +	if (error)
> > +		goto out_error;
> > +
> > +	/*
> > +	 * Invalidate the page cache so that we can clear any CoW mappings
> > +	 * in the destination file.
> > +	 */
> > +	truncate_inode_pages_range(&VFS_I(dest)->i_data, destoff,
> > +				   PAGE_ALIGN(destoff + len) - 1);
> > +
> > +	dfsbno = XFS_B_TO_FSBT(mp, destoff);
> > +	sfsbno = XFS_B_TO_FSBT(mp, srcoff);
> > +	fsblen = XFS_B_TO_FSB(mp, len);
> > +	error = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
> > +			destoff + len);
> > +	if (error)
> > +		goto out_error;
> > +
> > +	error = xfs_reflink_update_dest(dest, destoff + len);
> > +	if (error)
> > +		goto out_error;
> > +
> > +out_error:
> > +	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
> > +	xfs_iunlock(src, XFS_IOLOCK_EXCL);
> > +	if (src->i_ino != dest->i_ino) {
> > +		xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
> > +		xfs_iunlock(dest, XFS_IOLOCK_EXCL);
> > +	}
> > +	if (error)
> > +		trace_xfs_reflink_remap_range_error(dest, error, _RET_IP_);
> > +	return error;
> > +}
> > diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> > index 1d2f180..c35ce29 100644
> > --- a/fs/xfs/xfs_reflink.h
> > +++ b/fs/xfs/xfs_reflink.h
> > @@ -43,5 +43,7 @@ extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
> >  extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
> >  		xfs_off_t count);
> >  extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
> > +extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
> > +		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len);
> >  
> >  #endif /* __XFS_REFLINK_H */
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40676 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbeLDM3K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Dec 2018 07:29:10 -0500
Date: Tue, 4 Dec 2018 07:29:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: split up the xfs_reflink_end_cow work into smaller
 transactions
Message-ID: <20181204122906.GB63209@bfoster>
References: <20181130191910.GN8125@magnolia>
 <20181203151312.GA46858@bfoster>
 <20181203231929.GE24487@magnolia>
 <20181204045857.GG24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204045857.GG24487@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, Dec 03, 2018 at 08:58:57PM -0800, Darrick J. Wong wrote:
> On Mon, Dec 03, 2018 at 03:19:29PM -0800, Darrick J. Wong wrote:
> > On Mon, Dec 03, 2018 at 10:13:12AM -0500, Brian Foster wrote:
> > > On Fri, Nov 30, 2018 at 11:19:10AM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > In xfs_reflink_end_cow, we allocate a single transaction for the entire
> > > > end_cow operation and then loop the CoW fork mappings to move them to
> > > > the data fork.  This design fails on a heavily fragmented filesystem
> > > > where an inode's data fork has exactly one more extent than would fit in
> > > > an extents-format fork, because the unmap can collapse the data fork
> > > > into extents format (freeing the bmbt block) but the remap can expand
> > > > the data fork back into a (newly allocated) bmbt block.  If the number
> > > > of extents we end up remapping is large, we can overflow the block
> > > > reservation because we reserved blocks assuming that we were adding
> > > > mappings into an already-cleared area of the data fork.
> > > > 
> > > > Let's say we have 8 extents in the data fork, 8 extents in the CoW fork,
> > > > and the data fork can hold at most 7 extents before needing to convert
> > > > to btree format; and that blocks A-P are discontiguous single-block
> > > > extents:
> > > > 
> > > >    0......7
> > > > D: ABCDEFGH
> > > > C: IJKLMNOP
> > > > 
> > > > When a write to file blocks 0-7 completes, we must remap I-P into the
> > > > data fork.  We start by removing H from the btree-format data fork.  Now
> > > > we have 7 extents, so we convert the fork to extents format, freeing the
> > > > bmbt block.   We then move P into the data fork and it now has 8 extents
> > > > again.  We must convert the data fork back to btree format, requiring a
> > > > block allocation.  If we repeat this sequence for blocks 6-5-4-3-2-1-0,
> > > > we'll need a total of 8 block allocations to remap all 8 blocks.  We
> > > > reserved only enough blocks to handle one btree split (5 blocks on a 4k
> > > > block filesystem), which means we overflow the block reservation.
> > > > 
> > > > To fix this issue, create a separate helper function to remap a single
> > > > extent, and change _reflink_end_cow to call it in a tight loop over the
> > > > entire range we're completing.  As a side effect this also removes the
> > > > size restrictions on how many extents we can end_cow at a time, though
> > > > nobody ever hit that.  It is not reasonable to reserve N blocks to remap
> > > > N blocks.
> > > > 
> > > > Note that this can be reproduced after ~320 million fsx ops while
> > > > running generic/938 (long soak directio fsx exerciser):
> > > > 
> > > > XFS: Assertion failed: tp->t_blk_res >= tp->t_blk_res_used, file: fs/xfs/xfs_trans.c, line: 116
> > > > <machine registers snipped>
> > > > Call Trace:
> > > >  xfs_trans_dup+0x211/0x250 [xfs]
> > > >  xfs_trans_roll+0x6d/0x180 [xfs]
> > > >  xfs_defer_trans_roll+0x10c/0x3b0 [xfs]
> > > >  xfs_defer_finish_noroll+0xdf/0x740 [xfs]
> > > >  xfs_defer_finish+0x13/0x70 [xfs]
> > > >  xfs_reflink_end_cow+0x2c6/0x680 [xfs]
> > > >  xfs_dio_write_end_io+0x115/0x220 [xfs]
> > > >  iomap_dio_complete+0x3f/0x130
> > > >  iomap_dio_rw+0x3c3/0x420
> > > >  xfs_file_dio_aio_write+0x132/0x3c0 [xfs]
> > > >  xfs_file_write_iter+0x8b/0xc0 [xfs]
> > > >  __vfs_write+0x193/0x1f0
> > > >  vfs_write+0xba/0x1c0
> > > >  ksys_write+0x52/0xc0
> > > >  do_syscall_64+0x50/0x160
> > > >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/xfs_reflink.c |  202 ++++++++++++++++++++++++++------------------------
> > > >  1 file changed, 105 insertions(+), 97 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > > > index 322a852ce284..af0b2da76adf 100644
> > > > --- a/fs/xfs/xfs_reflink.c
> > > > +++ b/fs/xfs/xfs_reflink.c
> > > > @@ -623,53 +623,41 @@ xfs_reflink_cancel_cow_range(
> > > >  }
> > > >  
> > > >  /*
> > > > - * Remap parts of a file's data fork after a successful CoW.
> > > > + * Remap part of the CoW fork into the data fork.
> > > > + *
> > > > + * We aim to remap the range starting at @offset_fsb and ending at @end_fsb
> > > > + * into the data fork; this function will remap what it can (at the end of the
> > > > + * range) and update @end_fsb appropriately.  Each remap gets its own
> > > > + * transaction because we can end up merging and splitting bmbt blocks for
> > > > + * every remap operation and we'd like to keep the block reservation
> > > > + * requirements as low as possible.
> > > >   */
> > > > -int
> > > > -xfs_reflink_end_cow(
> > > > -	struct xfs_inode		*ip,
> > > > -	xfs_off_t			offset,
> > > > -	xfs_off_t			count)
> > > > +STATIC int
> > > > +xfs_reflink_end_cow_extent(
> > > > +	struct xfs_inode	*ip,
> > > > +	xfs_fileoff_t		offset_fsb,
> > > > +	xfs_fileoff_t		*end_fsb)
> > > >  {
> > > > -	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> > > > -	struct xfs_bmbt_irec		got, del;
> > > > -	struct xfs_trans		*tp;
> > > > -	xfs_fileoff_t			offset_fsb;
> > > > -	xfs_fileoff_t			end_fsb;
> > > > -	int				error;
> > > > -	unsigned int			resblks;
> > > > -	xfs_filblks_t			rlen;
> > > > -	struct xfs_iext_cursor		icur;
> > > > -
> > > > -	trace_xfs_reflink_end_cow(ip, offset, count);
> > > > +	struct xfs_bmbt_irec	got, del;
> > > > +	struct xfs_iext_cursor	icur;
> > > > +	struct xfs_mount	*mp = ip->i_mount;
> > > > +	struct xfs_trans	*tp;
> > > > +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> > > > +	xfs_filblks_t		rlen;
> > > > +	unsigned int		resblks;
> > > > +	int			error;
> > > >  
> > > >  	/* No COW extents?  That's easy! */
> > > > -	if (ifp->if_bytes == 0)
> > > > +	if (ifp->if_bytes == 0) {
> > > > +		*end_fsb = offset_fsb;
> > > >  		return 0;
> > > > -
> > > > -	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
> > > > -	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
> > > > -
> > > > -	/*
> > > > -	 * Start a rolling transaction to switch the mappings.  We're
> > > > -	 * unlikely ever to have to remap 16T worth of single-block
> > > > -	 * extents, so just cap the worst case extent count to 2^32-1.
> > > > -	 * Stick a warning in just in case, and avoid 64-bit division.
> > > > -	 */
> > > > -	BUILD_BUG_ON(MAX_RW_COUNT > UINT_MAX);
> > > > -	if (end_fsb - offset_fsb > UINT_MAX) {
> > > > -		error = -EFSCORRUPTED;
> > > > -		xfs_force_shutdown(ip->i_mount, SHUTDOWN_CORRUPT_INCORE);
> > > > -		ASSERT(0);
> > > > -		goto out;
> > > >  	}
> > > > -	resblks = XFS_NEXTENTADD_SPACE_RES(ip->i_mount,
> > > > -			(unsigned int)(end_fsb - offset_fsb),
> > > > -			XFS_DATA_FORK);
> > > > -	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
> > > > -			resblks, 0, XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
> > > > +
> > > > +	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> > > > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
> > > > +			XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
> > > >  	if (error)
> > > > -		goto out;
> > > > +		goto out_err;
> > > >  
> > > >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > >  	xfs_trans_ijoin(tp, ip, 0);
> > > > @@ -679,80 +667,100 @@ xfs_reflink_end_cow(
> > > >  	 * left by the time I/O completes for the loser of the race.  In that
> > > >  	 * case we are done.
> > > >  	 */
> > > > -	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
> > > > +	if (!xfs_iext_lookup_extent_before(ip, ifp, end_fsb, &icur, &got) ||
> > > > +	    got.br_startoff + got.br_blockcount <= offset_fsb) {
> > > > +		*end_fsb = offset_fsb;
> > > >  		goto out_cancel;
> > > > +	}
> > > >  
> > > > -	/* Walk backwards until we're out of the I/O range... */
> > > > -	while (got.br_startoff + got.br_blockcount > offset_fsb) {
> > > > -		del = got;
> > > > -		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
> > > > -
> > > > -		/* Extent delete may have bumped ext forward */
> > > > -		if (!del.br_blockcount)
> > > > -			goto prev_extent;
> > > > +	/*
> > > > +	 * Structure copy @got into @del, then trim @del to the range that we
> > > > +	 * were asked to remap.  We preserve @got for the eventual CoW fork
> > > > +	 * deletion; from now on @del represents the mapping that we're
> > > > +	 * actually remapping.
> > > > +	 */
> > > > +	del = got;
> > > > +	xfs_trim_extent(&del, offset_fsb, *end_fsb - offset_fsb);
> > > >  
> > > > -		/*
> > > > -		 * Only remap real extent that contain data.  With AIO
> > > > -		 * speculatively preallocations can leak into the range we
> > > > -		 * are called upon, and we need to skip them.
> > > > -		 */
> > > > -		if (!xfs_bmap_is_real_extent(&got))
> > > > -			goto prev_extent;
> > > > +	ASSERT(del.br_blockcount > 0);
> > > >  
> > > > -		/* Unmap the old blocks in the data fork. */
> > > > -		ASSERT(tp->t_firstblock == NULLFSBLOCK);
> > > > -		rlen = del.br_blockcount;
> > > > -		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1);
> > > > -		if (error)
> > > > -			goto out_cancel;
> > > > +	/*
> > > > +	 * Only remap real extents that contain data.  With AIO, speculative
> > > > +	 * preallocations can leak into the range we are called upon, and we
> > > > +	 * need to skip them.
> > > > +	 */
> > > > +	if (!xfs_bmap_is_real_extent(&got)) {
> > > > +		*end_fsb = del.br_startoff;
> > > > +		goto out_cancel;
> > > > +	}
> > > >  
> > > > -		/* Trim the extent to whatever got unmapped. */
> > > > -		if (rlen) {
> > > > -			xfs_trim_extent(&del, del.br_startoff + rlen,
> > > > -				del.br_blockcount - rlen);
> > > > -		}
> > > > -		trace_xfs_reflink_cow_remap(ip, &del);
> > > > +	/* Unmap the old blocks in the data fork. */
> > > > +	rlen = del.br_blockcount;
> > > > +	error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1);
> > > > +	if (error)
> > > > +		goto out_cancel;
> > > >  
> > > > -		/* Free the CoW orphan record. */
> > > > -		error = xfs_refcount_free_cow_extent(tp, del.br_startblock,
> > > > -				del.br_blockcount);
> > > > -		if (error)
> > > > -			goto out_cancel;
> > > > +	/* Trim the extent to whatever got unmapped. */
> > > > +	xfs_trim_extent(&del, del.br_startoff + rlen, del.br_blockcount - rlen);
> > > > +	trace_xfs_reflink_cow_remap(ip, &del);
> > > >  
> > > > -		/* Map the new blocks into the data fork. */
> > > > -		error = xfs_bmap_map_extent(tp, ip, &del);
> > > > -		if (error)
> > > > -			goto out_cancel;
> > > > +	/* Free the CoW orphan record. */
> > > > +	error = xfs_refcount_free_cow_extent(tp, del.br_startblock,
> > > > +			del.br_blockcount);
> > > > +	if (error)
> > > > +		goto out_cancel;
> > > >  
> > > > -		/* Charge this new data fork mapping to the on-disk quota. */
> > > > -		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
> > > > -				(long)del.br_blockcount);
> > > > +	/* Map the new blocks into the data fork. */
> > > > +	error = xfs_bmap_map_extent(tp, ip, &del);
> > > > +	if (error)
> > > > +		goto out_cancel;
> > > >  
> > > > -		/* Remove the mapping from the CoW fork. */
> > > > -		xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
> > > > +	/* Charge this new data fork mapping to the on-disk quota. */
> > > > +	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
> > > > +			(long)del.br_blockcount);
> > > >  
> > > > -		error = xfs_defer_finish(&tp);
> > > > -		if (error)
> > > > -			goto out_cancel;
> > > > -		if (!xfs_iext_get_extent(ifp, &icur, &got))
> > > > -			break;
> > > > -		continue;
> > > > -prev_extent:
> > > > -		if (!xfs_iext_prev_extent(ifp, &icur, &got))
> > > > -			break;
> > > > -	}
> > > > +	/* Remove the mapping from the CoW fork. */
> > > > +	xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
> > > >  
> > > >  	error = xfs_trans_commit(tp);
> > > > -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > >  	if (error)
> > > > -		goto out;
> > > > -	return 0;
> > > > +		goto out_unlock;
> > > >  
> > > > +	/* Update the caller about how much progress we made. */
> > > > +	*end_fsb = del.br_startoff;
> > > > +	goto out_unlock;
> > > >  out_cancel:
> > > >  	xfs_trans_cancel(tp);
> > > > +out_unlock:
> > > >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > -out:
> > > > -	trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
> > > > +out_err:
> > > > +	return error;
> > > > +}
> > > > +
> > > 
> > > Nit, but the error handling/labels could be cleaned up a bit here. The
> > > ilock can be transferred to the transaction to eliminate that label, the
> > > trans alloc and commit sites can then just return directly to eliminate
> > > out_err, and we're left with a single out_cancel label (and no longer
> > > need a goto in the common return path).
> > 
> > Ok, will do.
> 
> Looking at this more closely, the lead transaction in the chain is the
> freeing of the refcountbt cow record, and data fork update is performed
> as a deferred bmap log item.  Therefore we can't have ijoin
> automatically drop the ilock because it'll drop the ilock during the
> first transaction roll in xfs_trans_commit.
> 

Ah, Ok. I guess we should still be able to clean up the out_err thing
and return 0 directly in the success path.

> > 
> > > > +/*
> > > > + * Remap parts of a file's data fork after a successful CoW.
> > > > + */
> > > > +int
> > > > +xfs_reflink_end_cow(
> > > > +	struct xfs_inode		*ip,
> > > > +	xfs_off_t			offset,
> > > > +	xfs_off_t			count)
> > > > +{
> > > > +	xfs_fileoff_t			offset_fsb;
> > > > +	xfs_fileoff_t			end_fsb;
> > > > +	int				error = 0;
> > > > +
> > > > +	trace_xfs_reflink_end_cow(ip, offset, count);
> > > > +
> > > > +	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
> > > > +	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
> > > > +
> > > > +	/* Walk backwards until we're out of the I/O range... */
> > > > +	while (end_fsb > offset_fsb && !error)
> > > > +		error = xfs_reflink_end_cow_extent(ip, offset_fsb, &end_fsb);
> > > > +
> > > 
> > > The high level change seems reasonable provided we've thought through
> > > whether it's Ok to cycle the ILOCK around this operation. For example,
> > > maybe this is not possible, but I'm wondering if the end I/O processing
> > > could technically race with something crazy across a lock cycle like a
> > > truncate followed by another reflink -> COW writeback that lands in the
> > > same target range of the file.
> > 
> > I think the answer to this is that reflink always flushes both ranges
> > and truncates the pagecache (with iolock/mmaplock held) before starting
> > the remapping, and pagecache truncation waits for PageWriteback pages,
> > which means that we shouldn't end up reflinking into a range that's
> > undergoing writeback.
> > 
> > As far as reflink + directio writes go, reflink also waits for all dio
> > to finish so there shouldn't be a race there, and the dio write will
> > flush dirty pages and invalidate the pagecache before it starts the dio,
> > so I think we're (mostly) protected from races there, insofar as we
> > don't 100% support buffered and dio writes to the same parts of a
> > file....
> > 
> > > I guess we'd only remap COW blocks if they are "real," but that
> > > conversion looks like it happens on I/O submission, so what if that I/O
> > > happens to fail? Could we end up with racing success/fail COW I/O
> > > completions somehow or another?
> > 
> > ...so I think that leaves only the potential for a race between two
> > directio writes to the same region where one of them succeeds and the
> > other fails.  I /thought/ that there could be a race there, but I
> > noticed that on dio error we no longer _reflink_cancel_cow, we simply
> > don't _reflink_remap_cow.  So I think we're ok there too.  If both both
> > dio writes succeed then one or the other of them will do the remapping.
> > 
> > (I'm not sure how we define the expected outcome of simultaneous dio
> > writes to the same part of a file, but that seems rather suspect to
> > me...)
> 
> The comment I came up with is:
> 
> /*
>  * Walk backwards until we're out of the I/O range.  The loop function
>  * repeatedly cycles the ILOCK to allocate one transaction per remapped
>  * extent.
>  *
>  * If we're being called by writeback then the the pages will still
>  * have PageWriteback set, which prevents races with reflink remapping
>  * and truncate.  Reflink remapping prevents races with writeback by
>  * taking the iolock and mmaplock before flushing the pages and
>  * remapping, which means there won't be any further writeback or page
>  * cache dirtying until the reflink completes.
>  *
>  * We should never have two threads issuing writeback for the same file
>  * region.  There are also have post-eof checks in the writeback
>  * preparation code so that we don't bother writing out pages that are
>  * about to be truncated.
>  *
>  * If we're being called as part of directio write completion, the dio
>  * count is still elevated, which reflink and truncate will wait for.
>  * Reflink remapping takes the iolock and mmaplock and waits for
>  * pending dio to finish, which should prevent any directio until the
>  * remap completes.  Multiple concurrent directio writes to the same
>  * region are handled by end_cow processing only occurring for the
>  * threads which succeed; the outcome of multiple overlapping direct
>  * writes is not well defined anyway.
>  *
>  * It's possible that a buffered write and a direct write could collide
>  * here (the buffered write stumbles in after the dio flushes and
>  * invalidates the page cache and immediately queues writeback), but we
>  * have never supported this 100%.  If either disk write succeeds the
>  * blocks will be remapped.
>  */
> 

Sounds good, thanks for the comment.

Brian

> --D
> 
> > --D
> > 
> > > (Conversely, if the ilock approach is safe here then a quick note in the
> > > commit log as to why would be useful.)
> > 
> > > Brian
> > > 
> > > > +	if (error)
> > > > +		trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
> > > >  	return error;
> > > >  }
> > > >  

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50030 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbeLSUU5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 15:20:57 -0500
Date: Wed, 19 Dec 2018 12:20:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/11] xfs: merge COW handling into
 xfs_file_iomap_begin_delay
Message-ID: <20181219202045.GZ27208@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181203222503.30649-9-hch@lst.de>
 <20181218233641.GT27208@magnolia>
 <20181219193843.GE28624@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181219193843.GE28624@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 19, 2018 at 08:38:43PM +0100, Christoph Hellwig wrote:
> On Tue, Dec 18, 2018 at 03:36:41PM -0800, Darrick J. Wong wrote:
> > On Mon, Dec 03, 2018 at 05:25:00PM -0500, Christoph Hellwig wrote:
> > > Besides simplifying the code a bit this allows to actually implement
> > > the behavior of using COW preallocation for non-COW data mentioned
> > > in the current comments.
> > > 
> > > Note that this breaks the current version of xfs/420, but that is
> > > because the test is broken.  A separate fix will be sent for it.
> > 
> > (Still waiting for this...)
> 
> It was sent quite a while ago, but I need to resend it..
> 
> > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_iomap.c   | 132 ++++++++++++++++++++++++++++++-------------
> > >  fs/xfs/xfs_reflink.c |  67 ----------------------
> > >  fs/xfs/xfs_trace.h   |   1 -
> > >  3 files changed, 93 insertions(+), 107 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > index d851abac16a9..d19f99e5476a 100644
> > > --- a/fs/xfs/xfs_iomap.c
> > > +++ b/fs/xfs/xfs_iomap.c
> > > @@ -534,15 +534,16 @@ xfs_file_iomap_begin_delay(
> > >  {
> > >  	struct xfs_inode	*ip = XFS_I(inode);
> > >  	struct xfs_mount	*mp = ip->i_mount;
> > > -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > >  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> > >  	xfs_fileoff_t		maxbytes_fsb =
> > >  		XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> > >  	xfs_fileoff_t		end_fsb;
> > > -	int			error = 0, eof = 0;
> > > -	struct xfs_bmbt_irec	got;
> > > -	struct xfs_iext_cursor	icur;
> > > +	struct xfs_bmbt_irec	imap, cmap;
> > > +	struct xfs_iext_cursor	icur, ccur;
> > >  	xfs_fsblock_t		prealloc_blocks = 0;
> > > +	bool			eof = false, cow_eof = false, shared;
> > > +	int			whichfork = XFS_DATA_FORK;
> > > +	int			error = 0;
> > >  
> > >  	ASSERT(!XFS_IS_REALTIME_INODE(ip));
> > >  	ASSERT(!xfs_get_extsz_hint(ip));
> > > @@ -560,7 +561,7 @@ xfs_file_iomap_begin_delay(
> > >  
> > >  	XFS_STATS_INC(mp, xs_blk_mapw);
> > >  
> > > -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > > +	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
> > >  		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> > >  		if (error)
> > >  			goto out_unlock;
> > > @@ -568,51 +569,92 @@ xfs_file_iomap_begin_delay(
> > >  
> > >  	end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
> > >  
> > > -	eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got);
> > > +	/*
> > > +	 * Search the data fork fork first to look up our source mapping.  We
> > > +	 * always need the data fork map, as we have to return it to the
> > > +	 * iomap code so that the higher level write code can read data in to
> > > +	 * perform read-modify-write cycles for unaligned writes.
> > > +	 */
> > > +	eof = !xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, &imap);
> > >  	if (eof)
> > > -		got.br_startoff = end_fsb; /* fake hole until the end */
> > > +		imap.br_startoff = end_fsb; /* fake hole until the end */
> > >  
> > > -	if (got.br_startoff <= offset_fsb) {
> > > +	/* We never need to allocate blocks for zeroing a hole. */
> > > +	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
> > > +		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Search the COW fork extent list even if we did not find a data fork
> > > +	 * extent.  This serves two purposes: first this implements the
> > > +	 * speculative preallocation using cowextisze, so that we also unshare
> > 
> > "cowextsize"
> > 
> > > +	 * block adjacent to shared blocks instead of just the shared blocks
> > > +	 * themselves.  Second the lookup in the extent list is generally faster
> > > +	 * than going out to the shared extent tree.
> > > +	 */
> > > +	if (xfs_is_reflink_inode(ip)) {
> > > +		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
> > > +				&ccur, &cmap);
> > > +		if (!cow_eof && cmap.br_startoff <= offset_fsb) {
> > > +			trace_xfs_reflink_cow_found(ip, &cmap);
> > > +			whichfork = XFS_COW_FORK;
> > > +			goto done;
> > > +		}
> > > +	}
> > > +
> > > +	if (imap.br_startoff <= offset_fsb) {
> > >  		/*
> > >  		 * For reflink files we may need a delalloc reservation when
> > >  		 * overwriting shared extents.   This includes zeroing of
> > >  		 * existing extents that contain data.
> > >  		 */
> > > -		if (xfs_is_reflink_inode(ip) &&
> > > -		    ((flags & IOMAP_WRITE) ||
> > > -		     got.br_state != XFS_EXT_UNWRITTEN)) {
> > > -			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
> > > -			error = xfs_reflink_reserve_cow(ip, &got);
> > > -			if (error)
> > > -				goto out_unlock;
> > > +		if (!xfs_is_reflink_inode(ip) ||
> > > +		    ((flags & IOMAP_ZERO) && imap.br_state != XFS_EXT_NORM)) {
> > > +			trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK,
> > > +					&imap);
> > > +			goto done;
> > >  		}
> > >  
> > > -		trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK, &got);
> > > -		goto done;
> > > -	}
> > > +		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
> > >  
> > > -	if (flags & IOMAP_ZERO) {
> > > -		xfs_hole_to_iomap(ip, iomap, offset_fsb, got.br_startoff);
> > > -		goto out_unlock;
> > > +		/* Trim the mapping to the nearest shared extent boundary. */
> > > +		error = xfs_reflink_trim_around_shared(ip, &imap, &shared);
> > > +		if (error)
> > > +			goto out_unlock;
> > > +
> > > +		/* Not shared?  Just report the (potentially capped) extent. */
> > > +		if (!shared) {
> > > +			trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK,
> > > +					&imap);
> > > +			goto done;
> > > +		}
> > > +
> > > +		/*
> > > +		 * Fork all the shared blocks from our write offset until the
> > > +		 * end of the extent.
> > > +		 */
> > > +		whichfork = XFS_COW_FORK;
> > > +		end_fsb = imap.br_startoff + imap.br_blockcount;
> > > +	} else {
> > > +		/*
> > > +		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
> > > +		 * pages to keep the chunks of work done where somewhat
> > > +		 * symmetric with the work writeback does.  This is a completely
> > > +		 * arbitrary number pulled out of thin air.
> > > +		 *
> > > +		 * Note that the values needs to be less than 32-bits wide until
> > > +		 * the lower level functions are updated.
> > > +		 */
> > > +		count = min_t(loff_t, count, 1024 * PAGE_SIZE);
> > > +		end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
> > >  	}
> > >  
> > >  	error = xfs_qm_dqattach_locked(ip, false);
> > >  	if (error)
> > >  		goto out_unlock;
> > >  
> > > -	/*
> > > -	 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES pages
> > > -	 * to keep the chunks of work done where somewhat symmetric with the
> > > -	 * work writeback does. This is a completely arbitrary number pulled
> > > -	 * out of thin air as a best guess for initial testing.
> > > -	 *
> > > -	 * Note that the values needs to be less than 32-bits wide until
> > > -	 * the lower level functions are updated.
> > > -	 */
> > > -	count = min_t(loff_t, count, 1024 * PAGE_SIZE);
> > > -	end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
> > > -
> > > -	if (eof) {
> > > +	if (eof && whichfork == XFS_DATA_FORK) {
> > >  		prealloc_blocks = xfs_iomap_prealloc_size(ip, offset, count,
> > >  				&icur);
> > >  		if (prealloc_blocks) {
> > > @@ -635,9 +677,11 @@ xfs_file_iomap_begin_delay(
> > >  	}
> > >  
> > >  retry:
> > > -	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
> > > -			end_fsb - offset_fsb, prealloc_blocks, &got, &icur,
> > > -			eof);
> > > +	error = xfs_bmapi_reserve_delalloc(ip, whichfork, offset_fsb,
> > > +			end_fsb - offset_fsb, prealloc_blocks,
> > > +			whichfork == XFS_DATA_FORK ? &imap : &cmap,
> > > +			whichfork == XFS_DATA_FORK ? &icur : &ccur,
> > > +			whichfork == XFS_DATA_FORK ? eof : cow_eof);
> > >  	switch (error) {
> > >  	case 0:
> > >  		break;
> > > @@ -659,9 +703,19 @@ xfs_file_iomap_begin_delay(
> > >  	 * them out if the write happens to fail.
> > >  	 */
> > >  	iomap->flags |= IOMAP_F_NEW;
> > > -	trace_xfs_iomap_alloc(ip, offset, count, XFS_DATA_FORK, &got);
> > > +	trace_xfs_iomap_alloc(ip, offset, count, whichfork, &imap);
> > 
> > I'm confused by this, if whichfork == COW then won't ftrace report
> > results from the wrong fork?
> 
> The question is what the "right" fork to trace is as both matter here.
> At least we now clearly tell you which fork the trace belongs too.

True.  But I think it's misleading to have a tracepoint report say "cow"
when the extent data it records is actually from the data fork, and
particularly because we sometimes pass cmap back to the caller when
whichfork == COW.

If I were tracing through here I'd probably want to know what we found
from both forks at that particular point in time so that I could
continue following the logic.

--D

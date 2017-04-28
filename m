Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17407 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425249AbdD1SqL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2017 14:46:11 -0400
Date: Fri, 28 Apr 2017 11:46:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: refactor dir2 leaf readahead shadow buffer
 cleverness
Message-ID: <20170428184601.GC27447@birch.djwong.org>
References: <20170425020353.GT23371@birch.djwong.org>
 <20170427130450.GB46981@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170427130450.GB46981@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cmaiolin@redhat.com>, billodo@redhat.com, Dave Chinner <david@fromorbit.com>

On Thu, Apr 27, 2017 at 09:04:52AM -0400, Brian Foster wrote:
> On Mon, Apr 24, 2017 at 07:03:53PM -0700, Darrick J. Wong wrote:
> > Currently, the dir2 leaf block getdents function uses a complex state
> > tracking mechanism to create a shadow copy of the block mappings and
> > then uses the shadow copy to schedule readahead.  Since the read and
> > readahead functions are perfectly capable of reading the mappings
> > themselves, we can tear all that out in favor of a simpler function that
> > simply keeps pushing the readahead window further out.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: fix readahead of more than ra_want
> > ---
> >  fs/xfs/xfs_dir2_readdir.c |  325 ++++++++++++---------------------------------
> >  1 file changed, 88 insertions(+), 237 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> > index 20b7a5c..70a4a38 100644
> > --- a/fs/xfs/xfs_dir2_readdir.c
> > +++ b/fs/xfs/xfs_dir2_readdir.c
> > @@ -243,215 +243,110 @@ xfs_dir2_block_getdents(
> ...
> >  STATIC int
> >  xfs_dir2_leaf_readbuf(
> >  	struct xfs_da_args	*args,
> >  	size_t			bufsize,
> > -	struct xfs_dir2_leaf_map_info *mip,
> > -	xfs_dir2_off_t		*curoff,
> > -	struct xfs_buf		**bpp,
> > -	bool			trim_map)
> > +	xfs_dir2_off_t		*cur_off,
> > +	xfs_dablk_t		*ra_blk,
> > +	struct xfs_buf		**bpp)
> >  {
> ...
> > +	/* Flush old buf; remember its daddr for error detection. */
> > +	if (*bpp) {
> > +		old_daddr = (*bpp)->b_bn;
> > +		xfs_trans_brelse(args->trans, *bpp);
> > +		*bpp = NULL;
> >  	}
> 
> This seems kind of misplaced to me. IMO, it makes more sense for the
> caller to handle any such tracking across buffers..
> 
> >  
> ...
> > +	if (!bp || bp->b_bn == old_daddr) {
> > +		ASSERT(0);
> > +		if (bp)
> > +			xfs_trans_brelse(args->trans, bp);
> > +		error = -EFSCORRUPTED;
> > +		goto out;
> > +	}
> 
> ... because it's not clear how passing an unexpected buffer parameter to
> a readbuf() helper constitutes corruption.
> 
> Similar to hch's question, is this a scenario that is somehow introduced
> by the refactoring here? If not, this kind of seems like it should be
> ultimately split out into a separate patch.

No, just unnecessary paranoia on my part. :0

> >  
> >  	/*
> > -	 * Do we need more readahead?
> > -	 * Each loop tries to process 1 full dir blk; last may be partial.
> > +	 * Do we need more readahead for this call?  Issue ra against
> > +	 * bufsize's worth of dir blocks or until we hit the end of the
> > +	 * data section.
> >  	 */
> > +	ra_want = howmany(bufsize + geo->blksize, (1 << geo->fsblog)) - 1;
> > +	if (*ra_blk == 0)
> > +		*ra_blk = map.br_startoff;
> > +	next_ra = *ra_blk + geo->fsbcount;
> ...
> > +	while (ra_want > 0 && next_ra < last_da) {
> > +		nmap = 1;
> > +		error = xfs_bmapi_read(dp, next_ra, last_da - next_ra,
> > +				&map, &nmap, 0);
> > +		if (error || !nmap)
> > +			break;
> > +		next_ra = roundup((xfs_dablk_t)map.br_startoff, geo->fsbcount);
> > +		while (ra_want > 0 &&
> > +		       map.br_startblock != HOLESTARTBLOCK &&
> > +		       next_ra < map.br_startoff + map.br_blockcount) {
> > +			xfs_dir3_data_readahead(dp, next_ra, -2);
> > +			*ra_blk = next_ra;
> > +			ra_want -= geo->fsbcount;
> > +			next_ra += geo->fsbcount;
> >  		}
> > +		next_ra = map.br_startoff + map.br_blockcount;
> >  	}
> 
> So if I'm following the new logic correctly, we'll get here on the first
> readbuf() of the dir and basically issue readahead of the subsequent 32k
> or so of physical blocks. We set ra_blk to the last offset I/O was
> issued to and return. The next time around, we may only be 4k into the
> buffer, but the readahead mechanism rolls forward another 32k based on
> where readahead last left off.

Yeah, it does go blasting off into the stratosphere.  Initially I was
designing under the premise that we might as well go issue $bufsize
worth of readahead with every call to pull dir blocks into memory even
sooner, but you're right that this could wait for a second patch with
more concrete tuning and testing.

Note that $bufsize shrinks with every readbuf call, so we were only
issuing ~200K worth of readahead for each 32k getdents call.  The
downside of that of course is that ra gets so far ahead of read that
something else evicts the ra pages and now we take the hit of reading
the pages back in.  Hm.

> This strikes me as particularly aggressive. At the very least, it seems
> a notable enough departure from the existing logic for a patch that
> (IIUC) has an objective of refactoring/simplification moreso than
> performance to warrant performance testing. Am I missing something here,
> or otherwise is this behavior intended? (BTW, I do think this at least
> warrants a performance regression test against a known fragmented
> directory or some such to ensure we don't break performance.)
> 
> FWIW, and if I follow the existing (more complicated) logic correctly,
> it looks like the current code maintains more of a sliding window of the
> associated buffer size. So the first readdir->readbuf call occurs and we
> still issue the first 32k of readahead. As each buffer is processed,
> however, we only issue enough readahead to fill up the slot in the
> window left by the data that was just processed.
> 
> In effect (assuming the 32k buffer size guess is accurate), it seems to
> me that we basically issue buffer size amount of readahead at the onset
> of each readdir call and by the end of the call, we've issued enough
> readahead to anticipate the next readdir call. Of course the next call
> loses the mapping context, so we reconstruct the mapping table and
> repeat the readahead cycle for the current buffer into the next.
> 
> Given that, I'm wondering if we can achieve the simplification we're
> after while still maintaining close to the current behavior by doing
> something like splitting out the readahead logic entirely from the
> readbuf() call, form it into a helper that just issues the next N amount
> of readahead from a particular offset, and call that helper at the start
> and end of every readdir() call (and perhaps every once and a while
> during the call to cover the case of larger buffers, since 32k appears
> to be a guess). Thoughts?

If we go back to a more faithful translation of the old code, we'll
maintain a sliding readahead window of ($bufsize rounded up to the next
block) ahead of the block we just read, which should be enough to make
sure that we're only scheduling readahead for a few blocks out.  Because
dirblock headers don't count against bufsize, the first readbuf in a
getdents call doesn't actually schedule enough readahead to anticipate
the entire buffer contents, though the subsequent readbuf calls keep the
readahead window ahead of the read offset even into the next getdents
call.

I'll post a new revision of the patch that is less aggressive and more
parsimonious about memory & disk bandwidth use.

--D

> 
> Brian
> 
> >  	blk_finish_plug(&plug);
> >  
> > @@ -475,14 +370,14 @@ xfs_dir2_leaf_getdents(
> >  	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
> >  	xfs_dir2_data_entry_t	*dep;		/* data entry */
> >  	xfs_dir2_data_unused_t	*dup;		/* unused entry */
> > -	int			error = 0;	/* error return value */
> > -	int			length;		/* temporary length value */
> > -	int			byteoff;	/* offset in current block */
> > -	xfs_dir2_off_t		curoff;		/* current overall offset */
> > -	xfs_dir2_off_t		newoff;		/* new curoff after new blk */
> >  	char			*ptr = NULL;	/* pointer to current data */
> > -	struct xfs_dir2_leaf_map_info *map_info;
> >  	struct xfs_da_geometry	*geo = args->geo;
> > +	xfs_dablk_t		rablk = 0;	/* current readahead block */
> > +	xfs_dir2_off_t		curoff;		/* current overall offset */
> > +	int			length;		/* temporary length value */
> > +	int			byteoff;	/* offset in current block */
> > +	int			lock_mode;
> > +	int			error = 0;	/* error return value */
> >  
> >  	/*
> >  	 * If the offset is at or past the largest allowed value,
> > @@ -492,30 +387,12 @@ xfs_dir2_leaf_getdents(
> >  		return 0;
> >  
> >  	/*
> > -	 * Set up to bmap a number of blocks based on the caller's
> > -	 * buffer size, the directory block size, and the filesystem
> > -	 * block size.
> > -	 */
> > -	length = howmany(bufsize + geo->blksize, (1 << geo->fsblog));
> > -	map_info = kmem_zalloc(offsetof(struct xfs_dir2_leaf_map_info, map) +
> > -				(length * sizeof(struct xfs_bmbt_irec)),
> > -			       KM_SLEEP | KM_NOFS);
> > -	map_info->map_size = length;
> > -
> > -	/*
> >  	 * Inside the loop we keep the main offset value as a byte offset
> >  	 * in the directory file.
> >  	 */
> >  	curoff = xfs_dir2_dataptr_to_byte(ctx->pos);
> >  
> >  	/*
> > -	 * Force this conversion through db so we truncate the offset
> > -	 * down to get the start of the data block.
> > -	 */
> > -	map_info->map_off = xfs_dir2_db_to_da(geo,
> > -					      xfs_dir2_byte_to_db(geo, curoff));
> > -
> > -	/*
> >  	 * Loop over directory entries until we reach the end offset.
> >  	 * Get more blocks and readahead as necessary.
> >  	 */
> > @@ -527,38 +404,13 @@ xfs_dir2_leaf_getdents(
> >  		 * current buffer, need to get another one.
> >  		 */
> >  		if (!bp || ptr >= (char *)bp->b_addr + geo->blksize) {
> > -			int	lock_mode;
> > -			bool	trim_map = false;
> > -
> > -			if (bp) {
> > -				xfs_trans_brelse(NULL, bp);
> > -				bp = NULL;
> > -				trim_map = true;
> > -			}
> > -
> >  			lock_mode = xfs_ilock_data_map_shared(dp);
> > -			error = xfs_dir2_leaf_readbuf(args, bufsize, map_info,
> > -						      &curoff, &bp, trim_map);
> > +			error = xfs_dir2_leaf_readbuf(args, bufsize, &curoff,
> > +					&rablk, &bp);
> >  			xfs_iunlock(dp, lock_mode);
> > -			if (error || !map_info->map_valid)
> > +			if (error || !bp)
> >  				break;
> >  
> > -			/*
> > -			 * Having done a read, we need to set a new offset.
> > -			 */
> > -			newoff = xfs_dir2_db_off_to_byte(geo,
> > -							 map_info->curdb, 0);
> > -			/*
> > -			 * Start of the current block.
> > -			 */
> > -			if (curoff < newoff)
> > -				curoff = newoff;
> > -			/*
> > -			 * Make sure we're in the right block.
> > -			 */
> > -			else if (curoff > newoff)
> > -				ASSERT(xfs_dir2_byte_to_db(geo, curoff) ==
> > -				       map_info->curdb);
> >  			hdr = bp->b_addr;
> >  			xfs_dir3_data_check(dp, bp);
> >  			/*
> > @@ -643,7 +495,6 @@ xfs_dir2_leaf_getdents(
> >  		ctx->pos = XFS_DIR2_MAX_DATAPTR & 0x7fffffff;
> >  	else
> >  		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
> > -	kmem_free(map_info);
> >  	if (bp)
> >  		xfs_trans_brelse(NULL, bp);
> >  	return error;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

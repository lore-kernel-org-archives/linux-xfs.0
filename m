Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32048 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S978369AbdDXVbP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2017 17:31:15 -0400
Date: Mon, 24 Apr 2017 14:31:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: refactor dir2 leaf readahead shadow buffer
 cleverness
Message-ID: <20170424213107.GR23371@birch.djwong.org>
References: <20170419001434.GF5193@birch.djwong.org>
 <20170422121533.GB2770@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170422121533.GB2770@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Carlos Maiolino <cmaiolin@redhat.com>, billodo@redhat.com, Dave Chinner <david@fromorbit.com>

On Sat, Apr 22, 2017 at 08:15:33AM -0400, Brian Foster wrote:
> On Tue, Apr 18, 2017 at 05:14:34PM -0700, Darrick J. Wong wrote:
> > Currently, the dir2 leaf block getdents function uses a complex state
> > tracking mechanism to create a shadow copy of the block mappings and
> > then uses the shadow copy to schedule readahead.  Since the read and
> > readahead functions are perfectly capable of reading the mappings
> > themselves, we can tear all that out in favor of a simpler function that
> > simply keeps pushing the readahead window further out.
> > 
> > Inspired-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> I attempted to take a look at this yesterday (email has been dead) but
> noticed it didn't apply to for-next (w/ or w/o Eric's fix)..?

It should apply with both Eric and your fixes applied...

> >  fs/xfs/xfs_dir2_readdir.c |  324 ++++++++++++---------------------------------
> >  1 file changed, 87 insertions(+), 237 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> > index 929e8b6..290c610 100644
> > --- a/fs/xfs/xfs_dir2_readdir.c
> > +++ b/fs/xfs/xfs_dir2_readdir.c
> > @@ -243,215 +243,109 @@ xfs_dir2_block_getdents(
> ...
> > +	while (ra_want > 0 && next_ra < last_da) {
> > +		nmap = 1;
> > +		error = xfs_bmapi_read(dp, next_ra, last_da - next_ra,
> > +				&map, &nmap, 0);
> > +		if (error || !nmap)
> > +			break;
> > +		next_ra = roundup((xfs_dablk_t)map.br_startoff, geo->fsbcount);
> > +		while (map.br_startblock != HOLESTARTBLOCK &&
> > +		       next_ra < map.br_startoff + map.br_blockcount) {
> > +			xfs_dir3_data_readahead(dp, next_ra, -2);
> > +			*ra_blk = next_ra;
> > +			ra_want -= geo->fsbcount;
> > +			next_ra += geo->fsbcount;
> >  		}
> 
> FWIW and not having looked at the rest of the patch, it does look like
> the readahead window can stretch far beyond the expected size if you
> happen to have a large contiguous extent (IOW, the inner loop doesn't
> consider ra_want).

Oops, good catch.  I'll fix that before the next submission.

--D

> 
> Brian
> 
> > +		next_ra = map.br_startoff + map.br_blockcount;
> >  	}
> >  	blk_finish_plug(&plug);
> >  
> > @@ -475,14 +369,14 @@ xfs_dir2_leaf_getdents(
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
> > @@ -492,30 +386,12 @@ xfs_dir2_leaf_getdents(
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
> > @@ -527,38 +403,13 @@ xfs_dir2_leaf_getdents(
> >  		 * current buffer, need to get another one.
> >  		 */
> >  		if (!bp || ptr >= (char *)bp->b_addr + geo->blksize) {
> > -			int	lock_mode;
> > -			bool	trim_map = false;
> > -
> > -			if (bp) {
> > -				xfs_trans_brelse(args->trans, bp);
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
> > @@ -643,7 +494,6 @@ xfs_dir2_leaf_getdents(
> >  		ctx->pos = XFS_DIR2_MAX_DATAPTR & 0x7fffffff;
> >  	else
> >  		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
> > -	kmem_free(map_info);
> >  	if (bp)
> >  		xfs_trans_brelse(args->trans, bp);
> >  	return error;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 465397F56
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 18:54:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D4AF0AC004
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 16:54:17 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HfNufaL9U3NW7jhc for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 16:54:11 -0800 (PST)
Date: Tue, 17 Feb 2015 11:54:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 2/12] xfs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Message-ID: <20150217005408.GE4251@dastard>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
	<1424101680-3301-3-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424101680-3301-3-git-send-email-linkinjeon@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-man@vger.kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue, Feb 17, 2015 at 12:47:49AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This patch implements fallocate's FALLOC_FL_INSERT_RANGE for XFS.
> 
> 1) Make sure that both offset and len are block size aligned.
> 2) Update the i_size of inode by len bytes.
> 3) Compute the file's logical block number against offset. If the computed
>    block number is not the starting block of the extent, split the extent
>    such that the block number is the starting block of the extent.
> 4) Shift all the extents which are lying bewteen [offset, last allocated extent]
>    towards right by len bytes. This step will make a hole of len bytes
>    at offset.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |  358 ++++++++++++++++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_bmap.h |   13 +-
>  fs/xfs/xfs_bmap_util.c   |  126 +++++++++++-----
>  fs/xfs/xfs_bmap_util.h   |    2 +
>  fs/xfs/xfs_file.c        |   38 ++++-
>  fs/xfs/xfs_trace.h       |    1 +
>  6 files changed, 455 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 61ec015..6699e53 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5518,50 +5518,86 @@ xfs_bmse_shift_one(
>  	int				*current_ext,
>  	struct xfs_bmbt_rec_host	*gotp,
>  	struct xfs_btree_cur		*cur,
> -	int				*logflags)
> +	int				*logflags,
> +	enum SHIFT_DIRECTION		SHIFT)

Please don't shout. ;)

Lower case for types and variables, upper case for the enum values.
I also think the "shift" variable should be named "direction",
too, so the code reads "if (direction == SHIFT_LEFT)" and so is
clearly self documenting...

(only commenting once on this, please change it in other places)
as well ;)

>  {
>  	struct xfs_ifork		*ifp;
>  	xfs_fileoff_t			startoff;
> -	struct xfs_bmbt_rec_host	*leftp;
> +	struct xfs_bmbt_rec_host	*contp;
>  	struct xfs_bmbt_irec		got;
> -	struct xfs_bmbt_irec		left;
> +	struct xfs_bmbt_irec		cont;

Not sure what "cont" is short for. It's used as the "adjacent
extent" record, so that would be a better name IMO.

>  	int				error;
>  	int				i;
> +	int				total_extents;
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> +	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
>  
>  	xfs_bmbt_get_all(gotp, &got);
> -	startoff = got.br_startoff - offset_shift_fsb;
>  
>  	/* delalloc extents should be prevented by caller */
>  	XFS_WANT_CORRUPTED_RETURN(!isnullstartblock(got.br_startblock));
>  
> -	/*
> -	 * Check for merge if we've got an extent to the left, otherwise make
> -	 * sure there's enough room at the start of the file for the shift.
> -	 */
> -	if (*current_ext) {
> -		/* grab the left extent and check for a large enough hole */
> -		leftp = xfs_iext_get_ext(ifp, *current_ext - 1);
> -		xfs_bmbt_get_all(leftp, &left);
> +	if (SHIFT == SHIFT_LEFT) {
> +		startoff = got.br_startoff - offset_shift_fsb;
>  
> -		if (startoff < left.br_startoff + left.br_blockcount)
> +		/*
> +		 * Check for merge if we've got an extent to the left,
> +		 * otherwise make sure there's enough room at the start
> +		 * of the file for the shift.
> +		 */
> +		if (*current_ext) {
> +			/*
> +			 * grab the left extent and check for a large
> +			 * enough hole.
> +			 */
> +			contp = xfs_iext_get_ext(ifp, *current_ext - 1);
> +			xfs_bmbt_get_all(contp, &cont);
> +
> +			if (startoff < cont.br_startoff + cont.br_blockcount)
> +				return -EINVAL;
> +
> +			/* check whether to merge the extent or shift it down */
> +			if (xfs_bmse_can_merge(&cont, &got, offset_shift_fsb)) {
> +				return xfs_bmse_merge(ip, whichfork,
> +						      offset_shift_fsb,
> +						      *current_ext, gotp, contp,
> +						      cur, logflags);
> +			}
> +		} else if (got.br_startoff < offset_shift_fsb)
>  			return -EINVAL;

This would be better written:

		if (!*current_ext) {
			if (got.br_startoff < offset_shift_fsb)
				return -EINVAL;
			goto update_current_ext;
		}

and then the rest of the code in the shift left branch can drop a
level of indent and hence become less congested and easier to read.


> +	} else {
> +		startoff = got.br_startoff + offset_shift_fsb;
> +		/*
> +		 * If this is not the last extent in the file, make sure there's
> +		 * enough room between current extent and next extent for
> +		 * accommodating the shift.
> +		 */
> +		if (*current_ext < (total_extents - 1)) {
> +			contp = xfs_iext_get_ext(ifp, *current_ext + 1);
> +			xfs_bmbt_get_all(contp, &cont);
> +			if (startoff + got.br_blockcount > cont.br_startoff)
> +				return -EINVAL;
>  
> -		/* check whether to merge the extent or shift it down */
> -		if (xfs_bmse_can_merge(&left, &got, offset_shift_fsb)) {
> -			return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
> -					      *current_ext, gotp, leftp, cur,
> -					      logflags);
> +			/*
> +			 * Unlike a left shift (which involves a hole punch),
> +			 * a right shift does not modify extent neighbors
> +			 * in any way. We should never find mergeable extents
> +			 * in this scenario. Check anyways and warn if we
> +			 * encounter two extents that could be one.
> +			 */
> +			if (xfs_bmse_can_merge(&got, &cont,  offset_shift_fsb))
> +				WARN_ON_ONCE(1);
>  		}

Similarly:
		/* nothing to move if this is the last extent */
		if (*current_ext >= total_extents)
			goto update_current_ext;

> -	} else if (got.br_startoff < offset_shift_fsb)
> -		return -EINVAL;
> -
> +	}
>  	/*
>  	 * Increment the extent index for the next iteration, update the start
>  	 * offset of the in-core extent and update the btree if applicable.
>  	 */
> -	(*current_ext)++;

update_current_ext:
> +	if (SHIFT == SHIFT_LEFT)
> +		(*current_ext)++;
> +	else
> +		(*current_ext)--;
>  	xfs_bmbt_set_startoff(gotp, startoff);
>  	*logflags |= XFS_ILOG_CORE;
>  	if (!cur) {
> @@ -5581,10 +5617,10 @@ xfs_bmse_shift_one(
>  }
>  
>  /*
> - * Shift extent records to the left to cover a hole.
> + * Shift extent records to the left/right to cover/create a hole.
>   *
>   * The maximum number of extents to be shifted in a single operation is
> - * @num_exts. @start_fsb specifies the file offset to start the shift and the
> + * @num_exts. @stop_fsb specifies the file offset at which to stop shift and the
>   * file offset where we've left off is returned in @next_fsb. @offset_shift_fsb
>   * is the length by which each extent is shifted. If there is no hole to shift
>   * the extents into, this will be considered invalid operation and we abort
> @@ -5594,12 +5630,13 @@ int
>  xfs_bmap_shift_extents(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
> -	xfs_fileoff_t		start_fsb,
> +	xfs_fileoff_t		*next_fsb,
>  	xfs_fileoff_t		offset_shift_fsb,
>  	int			*done,
> -	xfs_fileoff_t		*next_fsb,
> +	xfs_fileoff_t		stop_fsb,
>  	xfs_fsblock_t		*firstblock,
>  	struct xfs_bmap_free	*flist,
> +	enum SHIFT_DIRECTION	SHIFT,
>  	int			num_exts)
>  {
>  	struct xfs_btree_cur		*cur = NULL;
> @@ -5609,10 +5646,11 @@ xfs_bmap_shift_extents(
>  	struct xfs_ifork		*ifp;
>  	xfs_extnum_t			nexts = 0;
>  	xfs_extnum_t			current_ext;
> +	xfs_extnum_t			total_extents;
> +	xfs_extnum_t			stop_extent;
>  	int				error = 0;
>  	int				whichfork = XFS_DATA_FORK;
>  	int				logflags = 0;
> -	int				total_extents;
>  
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> @@ -5628,6 +5666,7 @@ xfs_bmap_shift_extents(
>  
>  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	ASSERT(SHIFT == SHIFT_LEFT || SHIFT == SHIFT_RIGHT);
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> @@ -5645,43 +5684,85 @@ xfs_bmap_shift_extents(
>  	}
>  
>  	/*
> +	 * There may be delalloc extents in the data fork before the range we
> +	 * are collapsing out, so we cannot use the count of real extents here.
> +	 * Instead we have to calculate it from the incore fork.
> +	 */
> +	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
> +	if (total_extents == 0) {
> +		*done = 1;
> +		goto del_cursor;
> +	}
> +
> +	/*
> +	 * In case of first right shift, we need to initialize next_fsb
> +	 */
> +	if (*next_fsb == NULLFSBLOCK) {
> +		ASSERT(SHIFT == SHIFT_RIGHT);

This should be at the top of the function. i.e.

	ASSERT(*next_fsb != NULLFSBLOCK || direction == SHIFT_RIGHT)

> +		gotp = xfs_iext_get_ext(ifp, total_extents - 1);
> +		xfs_bmbt_get_all(gotp, &got);
> +		*next_fsb = got.br_startoff;
> +		if (stop_fsb > *next_fsb) {
> +			*done = 1;
> +			goto del_cursor;
> +		}
> +	}
> +
> +	/* Lookup the extent index at which we have to stop */
> +	if (SHIFT == SHIFT_RIGHT) {
> +		gotp = xfs_iext_bno_to_ext(ifp, stop_fsb, &stop_extent);
> +		/* Make stop_extent exclusive of shift range */
> +		stop_extent--;
> +	} else
> +		stop_extent = total_extents;
> +
> +	/*
>  	 * Look up the extent index for the fsb where we start shifting. We can
>  	 * henceforth iterate with current_ext as extent list changes are locked
>  	 * out via ilock.
>  	 *
>  	 * gotp can be null in 2 cases: 1) if there are no extents or 2)
> -	 * start_fsb lies in a hole beyond which there are no extents. Either
> +	 * *next_fsb lies in a hole beyond which there are no extents. Either
>  	 * way, we are done.
>  	 */
> -	gotp = xfs_iext_bno_to_ext(ifp, start_fsb, &current_ext);
> +	gotp = xfs_iext_bno_to_ext(ifp, *next_fsb, &current_ext);
>  	if (!gotp) {
>  		*done = 1;
>  		goto del_cursor;
>  	}
>  
> -	/*
> -	 * There may be delalloc extents in the data fork before the range we
> -	 * are collapsing out, so we cannot use the count of real extents here.
> -	 * Instead we have to calculate it from the incore fork.
> -	 */
> -	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
> -	while (nexts++ < num_exts && current_ext < total_extents) {
> +	/* some sanity checking before we finally start shifting extents */
> +	if ((SHIFT == SHIFT_LEFT && current_ext >= stop_extent) ||
> +	     (SHIFT == SHIFT_RIGHT && current_ext <= stop_extent)) {
> +		error = EIO;

		error = -EIO;

> +		goto del_cursor;
> +	}
> +
> +	while (nexts++ < num_exts) {
>  		error = xfs_bmse_shift_one(ip, whichfork, offset_shift_fsb,
> -					&current_ext, gotp, cur, &logflags);
> +					   &current_ext, gotp, cur, &logflags,
> +					   SHIFT);
>  		if (error)
>  			goto del_cursor;
> +		/*
> +		 * In case there was an extent merge after shifting extent,
> +		 * extent numbers would change.
> +		 * Update total extent count and grab the next record.
> +		 */

		/*
		 * If there was an extent merge during the shift, the extent
		 * count can change. Update the total and grade the next record.
		 */

> +		if (SHIFT == SHIFT_LEFT) {
> +			total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
> +			stop_extent = total_extents;
> +		}
>  
> -		/* update total extent count and grab the next record */
> -		total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
> -		if (current_ext >= total_extents)
> +		if (current_ext == stop_extent) {
> +			*done = 1;
> +			*next_fsb = NULLFSBLOCK;
>  			break;
> +		}
>  		gotp = xfs_iext_get_ext(ifp, current_ext);
>  	}
>  
> -	/* Check if we are done */
> -	if (current_ext == total_extents) {
> -		*done = 1;
> -	} else if (next_fsb) {
> +	if (!*done) {
>  		xfs_bmbt_get_all(gotp, &got);
>  		*next_fsb = got.br_startoff;
>  	}
> @@ -5696,3 +5777,192 @@ del_cursor:
>  
>  	return error;
>  }
> +
> +/*
> + * Splits an extent into two extents at split_fsb block that it is
> + * the first block of the current_ext. @current_ext is a target extent
> + * to be split. @split_fsb is a block where the extents is split.
> + * If split_fsb lies in a hole or the first block of extents, just return 0.
> + */
> +STATIC int
> +xfs_bmap_split_extent_at(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	xfs_fileoff_t		split_fsb,
> +	xfs_fsblock_t		*firstfsb,
> +	struct xfs_bmap_free	*free_list)
> +{
> +	int				whichfork = XFS_DATA_FORK;
> +	struct xfs_btree_cur		*cur = NULL;
> +	struct xfs_bmbt_rec_host	*gotp;
> +	struct xfs_bmbt_irec		got;
> +	struct xfs_bmbt_irec		new; /* split extent */
> +	struct xfs_mount		*mp = ip->i_mount;
> +	struct xfs_ifork		*ifp;
> +	xfs_fsblock_t			gotblkcnt; /* new block count for got */
> +	xfs_extnum_t			current_ext;
> +	int				error = 0;
> +	int				logflags = 0;
> +	int				i = 0;
> +
> +	if (unlikely(XFS_TEST_ERROR(
> +	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> +	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
> +	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
> +		XFS_ERROR_REPORT("xfs_bmap_split_extent_at",
> +				 XFS_ERRLEVEL_LOW, mp);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return -EIO;
> +
> +	ifp = XFS_IFORK_PTR(ip, whichfork);
> +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +		/* Read in all the extents */
> +		error = xfs_iread_extents(tp, ip, whichfork);
> +		if (error)
> +			return error;
> +	}
> +
> +	gotp = xfs_iext_bno_to_ext(ifp, split_fsb, &current_ext);
> +	/*
> +	 * gotp can be null in 2 cases: 1) if there are no extents
> +	 * or 2) split_fsb lies in a hole beyond which there are
> +	 * no extents. Either way, we are done.
> +	 */
> +	if (!gotp)
> +		return 0;

Comment can go before the call to xfs_iext_bno_to_ext().

> +
> +	xfs_bmbt_get_all(gotp, &got);
> +
> +	/*
> +	 * Check split_fsb lies in a hole or the start boundary offset
> +	 * of the extent.
> +	 */
> +	if (got.br_startoff >= split_fsb)
> +		return 0;
> +
> +	gotblkcnt = split_fsb - got.br_startoff;
> +	new.br_startoff = split_fsb;
> +	new.br_startblock = got.br_startblock + gotblkcnt;
> +	new.br_blockcount = got.br_blockcount - gotblkcnt;
> +	new.br_state = got.br_state;
> +
> +	if (ifp->if_flags & XFS_IFBROOT) {
> +		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> +		cur->bc_private.b.firstblock = *firstfsb;
> +		cur->bc_private.b.flist = free_list;
> +		cur->bc_private.b.flags = 0;
> +	}
> +
> +	if (cur) {

No need to close the XFS_IFBROOT branch and then check for cur;
we just allocated it inside the XFS_IFBROOT branch!

> +		error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
> +				got.br_startblock,
> +				got.br_blockcount,
> +				&i);
> +		if (error)
> +			goto del_cursor;
> +		XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
> +	}

....

> @@ -1427,20 +1429,23 @@ xfs_collapse_file_space(
>  
>  	/*
>  	 * Writeback and invalidate cache for the remainder of the file as we're
> -	 * about to shift down every extent from the collapse range to EOF. The
> -	 * free of the collapse range above might have already done some of
> -	 * this, but we shouldn't rely on it to do anything outside of the range
> -	 * that was freed.
> +	 * about to shift down every extent from offset to EOF.
>  	 */
>  	error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> -					     offset + len, -1);
> +					     offset, -1);
>  	if (error)
>  		return error;
>  	error = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
> -					(offset + len) >> PAGE_CACHE_SHIFT, -1);
> +					offset >> PAGE_CACHE_SHIFT, -1);
>  	if (error)
>  		return error;
>  
> +	if (SHIFT == SHIFT_RIGHT) {
> +		error = xfs_bmap_split_extent(ip, stop_fsb);
> +		if (error)
> +			return error;
> +	}

This needs a comment explaining why we are splitting an extent here.

> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 1cdba95..222a91a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -823,11 +823,13 @@ xfs_file_fallocate(
>  	long			error;
>  	enum xfs_prealloc_flags	flags = 0;
>  	loff_t			new_size = 0;
> +	int			do_file_insert = 0;

bool rather than int.

>  
>  	if (!S_ISREG(inode->i_mode))
>  		return -EINVAL;
>  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> -		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
> +		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
> +		     FALLOC_FL_INSERT_RANGE))
>  		return -EOPNOTSUPP;

This should use a local define before the function such as:

#define XFS_FALLOC_FL_SUPPORTED		\
		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE | \
		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE | \
		 FALLOC_FL_INSERT_RANGE)

This is similar to how we define supported checks for FIEMAP
operations in xfs_vn_fiemap().

>  
>  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> @@ -857,6 +859,28 @@ xfs_file_fallocate(
>  		error = xfs_collapse_file_space(ip, offset, len);
>  		if (error)
>  			goto out_unlock;
> +	} else if (mode & FALLOC_FL_INSERT_RANGE) {
> +		unsigned blksize_mask = (1 << inode->i_blkbits) - 1;
> +
> +		if (offset & blksize_mask || len & blksize_mask) {
> +			error = -EINVAL;
> +			goto out_unlock;
> +		}
> +
> +		/* Check for wrap through zero */
> +		if (inode->i_size + len > inode->i_sb->s_maxbytes) {
> +			error = -EFBIG;
> +			goto out_unlock;
> +		}

At first I thought that was a duplicate check of what is in
vfs_fallocate() (i.e. off + len > s_maxbytes). Can you change the
comment to read something like:

		/* check the new inode size does not wrap through zero */

> +
> +		/* Offset should be less than i_size */
> +		if (offset >= i_size_read(inode)) {
> +			error = -EINVAL;
> +			goto out_unlock;
> +		}
> +
> +		new_size = i_size_read(inode) + len;
> +		do_file_insert = 1;

Why do you use inode->i_size onthe wrap check, yet i_size_read()
twice here?

>  	} else {
>  		flags |= XFS_PREALLOC_SET;
>  
> @@ -891,8 +915,20 @@ xfs_file_fallocate(
>  		iattr.ia_valid = ATTR_SIZE;
>  		iattr.ia_size = new_size;
>  		error = xfs_setattr_size(ip, &iattr);
> +		if (error)
> +			goto out_unlock;
>  	}
>  
> +	/*
> +	 * Some operations are performed after the inode size is updated. For
> +	 * example, insert range expands the address space of the file, shifts
> +	 * all subsequent extents to create a hole inside the file. Updating
> +	 * the size first ensures that shifted extents aren't left hanging
> +	 * past EOF in the event of a crash or failure.
> +	 */

	/*
	 * Perform hole insertion now that the file size has been
	 * updated so that if we crash during the operation we don't
	 * leave shifted extents past EOF and hence losing access to
	 * the data that is contained within them.
	 */
> +	if (do_file_insert)
> +		error = xfs_insert_file_space(ip, offset, len);
> +
>  out_unlock:
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  	return error;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

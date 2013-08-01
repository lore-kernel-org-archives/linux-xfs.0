Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7277F7CBF
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 20:18:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D51ACAC005
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 18:18:16 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kHi8z4uwiZoHZaMY for <xfs@oss.sgi.com>;
	Wed, 31 Jul 2013 18:18:15 -0700 (PDT)
Date: Thu, 1 Aug 2013 11:18:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: Implement FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130801011812.GJ7118@dastard>
References: <1375281734-15874-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1375281734-15874-1-git-send-email-linkinjeon@gmail.com>
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
Cc: elder@kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, adilger.kernel@dilger.ca, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Jul 31, 2013 at 11:42:14PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> New fallocate flag FALLOC_FL_COLLAPSE_RANGE implementation for XFS.

A good start, but there's lots of work needed to make this safe for
general use.

> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/xfs/xfs_bmap.c     |   92 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap.h     |    3 ++
>  fs/xfs/xfs_file.c     |   26 ++++++++++++--
>  fs/xfs/xfs_iops.c     |   35 +++++++++++++++++++
>  fs/xfs/xfs_vnodeops.c |   62 +++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_vnodeops.h |    2 ++
>  6 files changed, 217 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 05c698c..ae677b1 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -6145,3 +6145,95 @@ next_block:
>  
>  	return error;
>  }
> +
> +/*
> + * xfs_update_logical()
> + *	Updates starting logical block of extents by subtracting
> + *	shift from them. At max XFS_LINEAR_EXTS number extents
> + *	will be updated and *current_ext is the extent number which
> + *	is currently being updated.

Single space after the "*" in the comments. Also, format them out to
80 columns.

> + */
> +int
> +xfs_update_logical(
> +	xfs_trans_t		*tp,
> +	struct xfs_inode	*ip,
> +	int			*done,
> +	xfs_fileoff_t		start_fsb,
> +	xfs_fileoff_t		shift,
> +	xfs_extnum_t		*current_ext)

This belongs in xfs_bmap_btree.c, named something like
xfs_bmbt_shift_rec_offsets().

Also, not typedefs for structures, please. (i.e. struct xfs_trans).


> +{
> +	xfs_btree_cur_t		*cur;

	struct xfs_btree_cur	*cur;

And for all the other structures, too.

> +	xfs_bmbt_rec_host_t	*gotp;
> +	xfs_mount_t		*mp;
> +	xfs_ifork_t		*ifp;
> +	xfs_extnum_t		nexts = 0;
> +	xfs_fileoff_t		startoff;
> +	int			error = 0;
> +	int			i;
> +
> +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	mp = ip->i_mount;

Do the assigment in the declaration on mp.

	struct xfs_mount	*mp = ip->i_mount;

> +
> +	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
> +		(error = xfs_iread_extents(tp, ip, XFS_DATA_FORK)))
> +		return error;

Hmmmm - that rings alarm bells.

> +
> +	if (!*current_ext) {
> +		gotp = xfs_iext_bno_to_ext(ifp, start_fsb, current_ext);
> +		/*
> +		 * gotp can be null in 2 cases: 1) if there are no extents
> +		 * or 2) start_fsb lies in a hole beyond which there are
> +		 * no extents. Either way, we are done.
> +		 */
> +		if (!gotp) {
> +			*done = 1;
> +			return 0;
> +		}
> +	}

So, you do a lookup on an extent index, which returns a incore
extent record.

> +
> +	if (ifp->if_flags & XFS_IFBROOT)
> +		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
> +	else
> +		cur = NULL;
> +
> +	while (nexts++ < XFS_LINEAR_EXTS &&

What has XFS_LINEAR_EXTS got to do with how many extents can be moved
in a single transaction at a time?

> +	       *current_ext <  XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK)) {
> +		gotp = xfs_iext_get_ext(ifp, (*current_ext)++);
> +		startoff = xfs_bmbt_get_startoff(gotp);
> +		if (cur) {
> +			if ((error = xfs_bmbt_lookup_eq(cur,
> +					startoff,
> +					xfs_bmbt_get_startblock(gotp),
> +					xfs_bmbt_get_blockcount(gotp),
> +					&i)))

Please don't put assignments inside if() statements where possible.
i.e.
			error = xfs_bmbt_lookup_eq(cur, ....
			if (error)

Is the normal way of doing this.

> +				goto del_cursor;
> +			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
> +		}
> +		startoff -= shift;
> +		xfs_bmbt_set_startoff(gotp, startoff);

So, we've looked up and extent, and reduced it's offset by shift.

> +		if (cur) {
> +			error = xfs_bmbt_update(cur, startoff,
> +						xfs_bmbt_get_startblock(gotp),
> +						xfs_bmbt_get_blockcount(gotp),
> +						xfs_bmbt_get_state(gotp));
> +			if (error)
> +				goto del_cursor;

And then we update the btree record in place.

Ok, major alarm bells are going off at this point. Is the record
still in the right place? Where did you validate that the shift
downwards didn't overlap the previous extent in the tree?

What happens if the start or end of the range to be shifted partially
overlaps an extent? The shift can only be done into a hole in the
file offset, so any attempt to shift downwards that overlaps an
existing extent is immediately invalid and indicates something is
wrong (pssobily corruption).

And if the end of the range being shifted partially overlaps an
extent, then that extent needs to be split - it requires two records
in the tree to track the part that was shifted and the part that was
not.

> +		}
> +	}
> +
> +	/* Check if we are done */
> +	if (*current_ext ==  XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK))
> +		*done = 1;
> +
> +del_cursor:
> +	if (cur) {
> +		if (!error)
> +			cur->bc_private.b.allocated = 0;

Um, why?

> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> +		     FALLOC_FL_COLLAPSE_RANGE))
> +		return -EOPNOTSUPP;
> +
> +	/* not just yet for rt inodes */
> +	if ((mode & FALLOC_FL_COLLAPSE_RANGE) && XFS_IS_REALTIME_INODE(ip))
>  		return -EOPNOTSUPP;

Why not? The extent manipulations are identical....

> @@ -845,6 +850,21 @@ xfs_file_fallocate(
>  	if (error)
>  		goto out_unlock;
>  
> +	if (mode & FALLOC_FL_COLLAPSE_RANGE) {
> +		error = -xfs_collapse_file_space(ip, offset + len, len);
> +		if (error || offset >= i_size_read(inode))
> +			goto out_unlock;
> +
> +		/* Shrink size in case of FALLOC_FL_COLLAPSE_RANGE */
> +		if ((offset + len) > i_size_read(inode))
> +			new_size = offset;
> +		else
> +			new_size = i_size_read(inode) - len;
> +		error = -xfs_update_file_size(ip, new_size);
> +
> +		goto out_unlock;
> +	}

This needs to vector through xfs_change_file_space() - it already
has code for doing offset/range validity checks, attaching
appropriate dquots for accounting, post-op file size and timestamp
updates, etc.

> +
> +/*
> + * xfs_update_file_size()
> + *	Just a simple disk size and time update
> + */
> +int
> +xfs_update_file_size(
> +	struct xfs_inode        *ip,
> +	loff_t			newsize)

This function should be nuked from orbit. I stopped looking at it
when the bug count got past 5. If you use xfs_change_file_space,
it's not necessary, either.

> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index dc730ac..95b46e7 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -1868,3 +1868,65 @@ xfs_change_file_space(
>  		xfs_trans_set_sync(tp);
>  	return xfs_trans_commit(tp, 0);
>  }
> +
> +/*
> + * xfs_collapse_file_space()
> + *	This implements the fallocate collapse range functionlaity.
> + *	It removes the hole from file by shifting all the extents which
> + *	lies beyond start block.
> + */
> +int
> +xfs_collapse_file_space(
> +	xfs_inode_t	*ip,
> +	loff_t		start,
> +	loff_t		shift)
> +{
> +	int		done = 0;
> +	xfs_mount_t	*mp = ip->i_mount;
> +	uint		resblks;
> +	xfs_trans_t	*tp;
> +	int		error = 0;
> +	xfs_extnum_t	current_ext = 0;
> +	xfs_fileoff_t	start_fsb = XFS_B_TO_FSB(mp, start);
> +	xfs_fileoff_t	shift_fsb = XFS_B_TO_FSB(mp, shift);
> +	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> +
> +	while (!error && !done) {
> +		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> +		tp->t_flags |= XFS_TRANS_RESERVE;
> +		error = xfs_trans_reserve(tp, resblks, XFS_WRITE_LOG_RES(mp),
> +					  0, XFS_TRANS_PERM_LOG_RES,
> +					  XFS_WRITE_LOG_COUNT);

Why a permanent log reservation for a single, non-nested transaction?

> +		if (error) {
> +			ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
> +			xfs_trans_cancel(tp, 0);
> +			break;
> +		}
> +
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
> +						ip->i_gdquot, ip->i_pdquot,
> +						resblks, 0,
> +						XFS_QMOPT_RES_REGBLKS);
> +		if (error)
> +			goto out;
> +
> +		xfs_trans_ijoin(tp, ip, 0);
> +
> +		error = xfs_update_logical(tp, ip, &done, start_fsb,
> +					   shift_fsb, &current_ext);
> +		if (error)
> +			goto out;
> +
> +		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	}

Where are you punching out the blocks in the range we are shifting
the down into? i.e. before you can do this shift operation, you have
to ensure that the range being shifted into has no extents in it.
IOWs, the first operation that needs to be done is a hole punch of
the range being removed - we need xfs_free_file_space() call on the
range first.

And as Ted pointed out, we also need to invalidate the page cache
over the range being moved.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

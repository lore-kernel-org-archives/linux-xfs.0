Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 332847F3F
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 05:19:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 86DC8AC002
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 03:19:55 -0800 (PST)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25]) by
	cuda.sgi.com with ESMTP id Z7fVHb6CdDOSA4WD (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2014 03:19:52 -0800 (PST)
Received: from epcpsbgr5.samsung.com
	(u145.gpu120.samsung.co.kr [203.254.230.145])
	by mailout2.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NG2007ZJ252F6B0@mailout2.samsung.com> for
	xfs@oss.sgi.com; Thu, 04 Dec 2014 20:19:50 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <002b01d007ae$319ed0a0$94dc71e0$@samsung.com>
	<20141202204801.GA44400@bfoster.bfoster>
In-reply-to: <20141202204801.GA44400@bfoster.bfoster>
Subject: RE: [PATCH v6 2/10] xfs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Date: Thu, 04 Dec 2014 20:19:50 +0900
Message-id: <001c01d00fb4$38029e50$a807daf0$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: 'Brian Foster' <bfoster@redhat.com>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>

> 
> Hi Namjae,
Hi Brian,

> 
> Here are some review notes. I haven't got to any of the test code or
> played around with it just yet...
Thanks for your reivew :)

> >
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 79c9819..da01890 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5528,56 +5528,87 @@ xfs_bmse_shift_one(
> 
> FYI, you're probably going to need to rebase the xfs_bmse_shift_one()
> bits on top of Dave's recent cleanup here:
> 
> http://oss.sgi.com/archives/xfs/2014-11/msg00458.html
okay.

> 
> >  	int				*current_ext,
> >  	struct xfs_bmbt_rec_host	*gotp,
> >  	struct xfs_btree_cur		*cur,
> > -	int				*logflags)
> > +	int				*logflags,
> > +	enum SHIFT_DIRECTION		SHIFT)
> >  {
> >  	struct xfs_ifork		*ifp;
> >  	xfs_fileoff_t			startoff;
> > -	struct xfs_bmbt_rec_host	*leftp;
> > +	struct xfs_bmbt_rec_host	*contp;
> >  	struct xfs_bmbt_irec		got;
> > -	struct xfs_bmbt_irec		left;
> > +	struct xfs_bmbt_irec		cont;
> >  	int				error;
> >  	int				i;
> > +	int				total_extents;
> >
> >  	ifp = XFS_IFORK_PTR(ip, whichfork);
> > +	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
> >
> >  	xfs_bmbt_get_all(gotp, &got);
> > -	startoff = got.br_startoff - offset_shift_fsb;
> >
> >  	/* delalloc extents should be prevented by caller */
> >  	XFS_WANT_CORRUPTED_GOTO(!isnullstartblock(got.br_startblock),
> >  				out_error);
> >
> > -	/*
> > -	 * If this is the first extent in the file, make sure there's enough
> > -	 * room at the start of the file and jump right to the shift as there's
> > -	 * no left extent to merge.
> > -	 */
> > -	if (*current_ext == 0) {
> > -		if (got.br_startoff < offset_shift_fsb)
> > +	if (SHIFT == SHIFT_LEFT) {
> > +		startoff = got.br_startoff - offset_shift_fsb;
> > +		/*
> > +		 * If this is the first extent in the file, make sure there's
> > +		 * enough room at the start of the file and jump right to the
> > +		 * shift as there's no left extent to merge.
> > +		 */
> > +		if (*current_ext == 0) {
> > +			if (got.br_startoff < offset_shift_fsb)
> > +				return -EINVAL;
> > +			goto shift_extent;
> > +		}
> > +
> > +		/* grab the left extent and check for a large enough hole */
> > +		contp = xfs_iext_get_ext(ifp, *current_ext - 1);
> > +		xfs_bmbt_get_all(contp, &cont);
> > +
> > +		if (startoff < cont.br_startoff + cont.br_blockcount)
> >  			return -EINVAL;
> > -		goto shift_extent;
> > -	}
> >
> > -	/* grab the left extent and check for a large enough hole */
> > -	leftp = xfs_iext_get_ext(ifp, *current_ext - 1);
> > -	xfs_bmbt_get_all(leftp, &left);
> > +		/* check whether to merge the extent or shift it down */
> > +		if (!xfs_bmse_can_merge(&cont, &got, offset_shift_fsb))
> > +			goto shift_extent;
> >
> > -	if (startoff < left.br_startoff + left.br_blockcount)
> > -		return -EINVAL;
> > +		return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
> > +				      *current_ext, gotp, contp, cur, logflags);
> > +	} else {
> > +		startoff = got.br_startoff + offset_shift_fsb;
> > +		/*
> > +		 * If this is the last extent in the file, make sure there's
> > +		 * enough room at the end of the file and jump right to the
> > +		 * shift as there's no right extent to merge.
> > +		 */
> > +		if (*current_ext == (total_extents - 1))
> > +			goto shift_extent;
> >
> > -	/* check whether to merge the extent or shift it down */
> > -	if (!xfs_bmse_can_merge(&left, &got, offset_shift_fsb))
> > -		goto shift_extent;
> > +		/* grab the right extent and check for a large enough hole */
> > +		contp = xfs_iext_get_ext(ifp, *current_ext + 1);
> > +		xfs_bmbt_get_all(contp, &cont);
> >
> > -	return xfs_bmse_merge(ip, whichfork, offset_shift_fsb, *current_ext,
> > -			      gotp, leftp, cur, logflags);
> > +		if (startoff > cont.br_startoff)
> > +			return -EINVAL;
> 
> Shouldn't this be 'if (startoff + got.br_blockount > cont.br_startoff)'?
True, I will fix.

> 
> > +
> > +		if (!xfs_bmse_can_merge(&got, &cont,  offset_shift_fsb))
> > +			goto shift_extent;
> > +
> > +		return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
> > +				      *current_ext + 1, contp, gotp, cur,
> > +				      logflags);
> 
> It doesn't look like xfs_bmse_merge() is bidirectional in this sense.
> The can_merge() helper might work Ok since we're just checking whether
> the extents line up. The merge code, however, will always extend the
> block count of the left extent and delete the right. The left extent is
> gotp in this case, which is the extent we want to shift right. In other
> words, it seems like we should adjust the start offset of the right
> extent to the right-shifted start offset of the left and delete the
> left.
Right, I will change.

> 
> That said, I wonder whether we even care about a merge in the right
> shift case since we haven't punched a hole in the file and thus have not
> changed the "neighbors" of any of the extents we're shuffling around. I
> would think any extents that are already contiguous as such are already
> a single extent.
yes, in case of insert range it is highly unlikely that a merge is required.
But we have kept this code as part of a generic API for shifting extents.

> 
> > +	}
> >
> >  shift_extent:
> >  	/*
> >  	 * Increment the extent index for the next iteration, update the start
> >  	 * offset of the in-core extent and update the btree if applicable.
> >  	 */
> > -	(*current_ext)++;
> > +	if (SHIFT == SHIFT_LEFT)
> > +		(*current_ext)++;
> > +	else
> > +		(*current_ext)--;
> >  	xfs_bmbt_set_startoff(gotp, startoff);
> >  	*logflags |= XFS_ILOG_CORE;
> >  	if (!cur) {
> > @@ -5604,10 +5635,10 @@ out_error:
> >  }
> >
> >  /*
> > - * Shift extent records to the left to cover a hole.
> > + * Shift extent records to the left/right to cover/create a hole.
> >   *
> >   * The maximum number of extents to be shifted in a single operation is
> > - * @num_exts. @start_fsb specifies the file offset to start the shift and the
> > + * @num_exts. @stop_fsb specifies the file offset at which to stop shift and the
> >   * file offset where we've left off is returned in @next_fsb. @offset_shift_fsb
> >   * is the length by which each extent is shifted. If there is no hole to shift
> >   * the extents into, this will be considered invalid operation and we abort
> > @@ -5617,12 +5648,13 @@ int
> >  xfs_bmap_shift_extents(
> >  	struct xfs_trans	*tp,
> >  	struct xfs_inode	*ip,
> > -	xfs_fileoff_t		start_fsb,
> > +	xfs_fileoff_t		stop_fsb,
> >  	xfs_fileoff_t		offset_shift_fsb,
> >  	int			*done,
> >  	xfs_fileoff_t		*next_fsb,
> >  	xfs_fsblock_t		*firstblock,
> >  	struct xfs_bmap_free	*flist,
> > +	enum SHIFT_DIRECTION	SHIFT,
> >  	int			num_exts)
> >  {
> >  	struct xfs_btree_cur		*cur = NULL;
> > @@ -5636,6 +5668,7 @@ xfs_bmap_shift_extents(
> >  	int				whichfork = XFS_DATA_FORK;
> >  	int				logflags = 0;
> >  	int				total_extents;
> > +	int				stop_extent;
> >
> >  	if (unlikely(XFS_TEST_ERROR(
> >  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> > @@ -5651,6 +5684,7 @@ xfs_bmap_shift_extents(
> >
> >  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > +	ASSERT(SHIFT == SHIFT_LEFT || SHIFT == SHIFT_RIGHT);
> >
> >  	ifp = XFS_IFORK_PTR(ip, whichfork);
> >  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > @@ -5668,43 +5702,87 @@ xfs_bmap_shift_extents(
> >  	}
> >
> >  	/*
> > +	 * There may be delalloc extents in the data fork before the range we
> > +	 * are collapsing out, so we cannot use the count of real extents here.
> > +	 * Instead we have to calculate it from the incore fork.
> > +	 */
> > +	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
> > +	if (total_extents == 0) {
> > +		*done = 1;
> > +		goto del_cursor;
> > +	}
> > +
> > +	/*
> > +	 * In case of first right shift, we need to initialize next_fsb
> > +	 */
> > +	if (*next_fsb == NULLFSBLOCK) {
> > +		ASSERT(SHIFT == SHIFT_RIGHT);
> > +		gotp = xfs_iext_get_ext(ifp, total_extents - 1);
> > +		xfs_bmbt_get_all(gotp, &got);
> > +		*next_fsb = got.br_startoff;
> > +		if (stop_fsb > *next_fsb) {
> > +			*done = 1;
> > +			goto del_cursor;
> > +		}
> > +	}
> > +
> > +	/* Lookup the extent index at which we have to stop */
> > +	if (SHIFT == SHIFT_RIGHT)
> > +		gotp = xfs_iext_bno_to_ext(ifp, stop_fsb, &stop_extent);
> > +	else
> > +		stop_extent = total_extents;
> > +
> > +	/*
> >  	 * Look up the extent index for the fsb where we start shifting. We can
> >  	 * henceforth iterate with current_ext as extent list changes are locked
> >  	 * out via ilock.
> >  	 *
> >  	 * gotp can be null in 2 cases: 1) if there are no extents or 2)
> > -	 * start_fsb lies in a hole beyond which there are no extents. Either
> > +	 * *next_fsb lies in a hole beyond which there are no extents. Either
> >  	 * way, we are done.
> >  	 */
> > -	gotp = xfs_iext_bno_to_ext(ifp, start_fsb, &current_ext);
> > +	gotp = xfs_iext_bno_to_ext(ifp, *next_fsb, &current_ext);
> >  	if (!gotp) {
> >  		*done = 1;
> >  		goto del_cursor;
> >  	}
> >
> > -	/*
> > -	 * There may be delalloc extents in the data fork before the range we
> > -	 * are collapsing out, so we cannot use the count of real extents here.
> > -	 * Instead we have to calculate it from the incore fork.
> > -	 */
> > -	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
> > -	while (nexts++ < num_exts && current_ext < total_extents) {
> > +	/* some sanity checking before we finally start shifting extents */
> > +	if ((SHIFT == SHIFT_LEFT && current_ext >= stop_extent) ||
> > +	     (SHIFT == SHIFT_RIGHT && current_ext < stop_extent)) {
> > +		error = EIO;
> > +		goto del_cursor;
> > +	}
> 
> It looks like stop_extent is exclusive for left shifts (== total_extents
> rather than the last extent number) and inclusive for right shifts.
> Could we be consistent between the two?
Right, we can change stop_extent = total_extents - 1 in case of collapse
to make it consistent.

> 
> > +
> > +	while (nexts++ < num_exts) {
> >  		error = xfs_bmse_shift_one(ip, whichfork, offset_shift_fsb,
> > -					&current_ext, gotp, cur, &logflags);
> > +					   &current_ext, gotp, cur, &logflags,
> > +					   SHIFT);
> >  		if (error)
> >  			goto del_cursor;
> > -
> > -		/* update total extent count and grab the next record */
> > +		/*
> > +		 * In case there was an extent merge after shifting extent,
> > +		 * extent numbers would change.
> > +		 * Update total extent count and grab the next record.
> > +		 */
> >  		total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
> > -		if (current_ext >= total_extents)
> > -			break;
> > +		if (SHIFT == SHIFT_RIGHT) {
> > +			gotp = xfs_iext_bno_to_ext(ifp, stop_fsb, &stop_extent);
> > +			if (current_ext < stop_extent) {
> > +				*done = 1;
> > +				break;
> > +			}
> > +		} else {
> > +			stop_extent = total_extents;
> > +			if (current_ext == stop_extent) {
> > +				*done = 1;
> > +				break;
> > +			}
> 
> ... and if we can make stop_extent consistently exclusive, it looks like
> we could use 'if (current_ext == stop_extent)' as a stop condition for
> both cases, yes?
Yes. Right.

> 
> > +		}
> >  		gotp = xfs_iext_get_ext(ifp, current_ext);
> >  	}
> >
> > -	/* Check if we are done */
> > -	if (current_ext == total_extents) {
> > -		*done = 1;
> > -	} else if (next_fsb) {
> > +	if (!*done) {
> >  		xfs_bmbt_get_all(gotp, &got);
> >  		*next_fsb = got.br_startoff;
> >  	}
> 
> Might be good to set next_fsb to NULLFSBLOCK or some such value if we
> are done.
Okay.


> > +
> > +	/*
> > +	 * Check split_fsb lies in a hole or the start boundary offset
> > +	 * of the extent.
> > +	 */
> > +	if (got.br_startoff >= split_fsb)
> > +		return 0;
> > +
> > +	gotblkcnt = split_fsb - got.br_startoff;
> > +	new.br_startoff = split_fsb;
> > +	new.br_startblock = got.br_startblock + gotblkcnt;
> > +	new.br_blockcount = got.br_blockcount - gotblkcnt;
> > +	new.br_state = got.br_state;
> > +
> > +	/* We are going to change core inode */
> > +	logflags = XFS_ILOG_CORE;
> > +
> > +	if (ifp->if_flags & XFS_IFBROOT) {
> > +		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> > +		cur->bc_private.b.firstblock = *firstfsb;
> > +		cur->bc_private.b.flist = free_list;
> > +		cur->bc_private.b.flags = 0;
> > +	} else {
> > +		cur = NULL;
> > +		logflags |= XFS_ILOG_DEXT;
> > +	}
> 
> This looks like it suffers from a similar problem as the bmap shift code
> with regard to logflags and error handling. Check out the subsequent fix
> for reference:
> 
> ca446d88 xfs: don't log inode unless extent shift makes extent modifications
> 
> We basically init. logflags to 0 and delay setting the actual flags as
> long as possible, until we actually make a change to the extent tree or
> bmap btree.
> 
> Otherwise, if the following lookup were to fail, for example, we'd still
> log the inode even though we haven't changed anything and ultimately the
> fs will shutdown on transaction cancel.
True, I will update.


> > +	}
> > +
> > +	/*
> > +	 * Convert to a btree if necessary.
> > +	 */
> > +	if (xfs_bmap_needs_btree(ip, whichfork)) {
> > +		int tmp_logflags; /* partial log flag return val */
> > +
> > +		ASSERT(cur == NULL);
> > +		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, free_list,
> > +				&cur, 0, &tmp_logflags, whichfork);
> > +		logflags |= tmp_logflags;
> > +	}
> 
> Hmm, looks Ok, but it would be nice if we had a test case for this
> convert to btree scenario. I suspect something that falloc's just the
> right number extents for a known fs format and does an insert range
> right in the middle of one would suffice (and probably only require a
> few seconds to run).
Okay, I will prepare a testcase for convert to btree scenario of insert
range.
for collapse range we have generic/017 which tests multiple collapse
calls on same file. I can write same test for insert range which will
insert a single block hole at every alternate block in the file.
Each insert range call will split the extent into 2 extents. This test
need not be fs specfic so can be used for ext4 also.

> 
> > +
> > +del_cursor:
> > +	if (cur) {
> > +		cur->bc_private.b.allocated = 0;
> > +		xfs_btree_del_cursor(cur,
> > +				error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> > +	}
> > +	xfs_trans_log_inode(tp, ip, logflags);
> > +	return error;
> > +}
> > +
> > +int
> > +xfs_bmap_split_extent(
> > +		struct xfs_inode        *ip,
> > +		xfs_fileoff_t           split_fsb)
> 
> You can line up the above params with the local vars below.
Okay.

> 
> > +{
> > +	struct xfs_mount        *mp = ip->i_mount;
> > +	struct xfs_trans        *tp;
> > +	struct xfs_bmap_free    free_list;
> > +	xfs_fsblock_t           firstfsb;
> > +	int                     committed;
> > +	int                     error;
> > +
> > +	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> > +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
> > +			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
> > +	if (error) {
> > +		xfs_trans_cancel(tp, 0);
> > +		return error;
> > +	}
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
> > +			ip->i_gdquot, ip->i_pdquot,
> > +			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
> > +			XFS_QMOPT_RES_REGBLKS);
> > +	if (error)
> > +		goto out;
> > +
> > +	xfs_trans_ijoin(tp, ip, 0);
> 
> Might as well transfer the lock to the tp here? That avoids the need for
> the unlocks below. We just need to make sure we order things correctly
> such that the inode is unlocked on error conditions.
Could you elaborate more ? Acutally, I can not find what is problem..


> > - *
> > + * @next_fsb will keep track of the extent currently undergoing shift.
> > + * @stop_fsb will keep track of the extent at which we have to stop.
> > + * If we are shifting left, we will start with block (offset + len) and
> > + * shift each extent till last extent.
> > + * If we are shifting right, we will start with last extent inside file space
> > + * and continue until we reach the block corresponding to offset.
> > + * If right shift, delegate the work of
> > + * initialization of next_fsb to xfs_bmap_shift_extent as it has ilock held.
> 
> Could you move the bit of the comment about the next_fsb right-shift
> init down where we set it to NULLFSBLOCK? That way it is a bit more
> clear.
Okay.


> > +
> >  	while (!error && !done) {
> >  		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> >  		/*
> > @@ -1475,10 +1478,9 @@ xfs_collapse_file_space(
> >  		 * We are using the write transaction in which max 2 bmbt
> >  		 * updates are allowed
> >  		 */
> > -		start_fsb = next_fsb;
> > -		error = xfs_bmap_shift_extents(tp, ip, start_fsb, shift_fsb,
> > +		error = xfs_bmap_shift_extents(tp, ip, stop_fsb, shift_fsb,
> 
> Nice clean up, but could we reorder next_fsb prior to stop_fsb to be a
> bit more clean?
Yes, We could.

> >  }
> >
> >  /*
> > +
> > +		new_size = i_size_read(inode) + len;
> > +		do_file_insert = 1;
> >  	} else {
> >  		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> >  		    offset + len > i_size_read(inode)) {
> 
> There's a check that sets XFS_DIFLAG_PREALLOC down after this hunk but
> before the next that we probably want to update to exclude insert range
> (it already handles collapse).
Okay.

Thanks!
> 
> Brian
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

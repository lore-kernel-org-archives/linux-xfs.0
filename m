Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9EB1A7F3F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 03:45:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F7108F8064
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 01:45:59 -0800 (PST)
Received: from mail-qa0-f44.google.com (mail-qa0-f44.google.com
	[209.85.216.44]) by cuda.sgi.com with ESMTP id IbHjUU3fFeprV0ez
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Feb 2014 01:45:54 -0800 (PST)
Received: by mail-qa0-f44.google.com with SMTP id w5so11455113qac.31
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 01:45:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140210233258.GX13647@dastard>
References: <1391319851-3169-1-git-send-email-linkinjeon@gmail.com>
	<20140210233258.GX13647@dastard>
Date: Tue, 11 Feb 2014 18:45:53 +0900
Message-ID: <CAKYAXd_8Bg=SSZ3bqpoe7jxwH6Tjkx57kYuWQgqG1nSoMFA5UQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/10] xfs: Add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, mtk.manpages@gmail.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk

Hi Dave.
2014-02-11 8:32 GMT+09:00, Dave Chinner <david@fromorbit.com>:
> On Sun, Feb 02, 2014 at 02:44:11PM +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Add support FALLOC_FL_COLLAPSE_RANGE for fallocate.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>
> A more detailed description would be nice for the change logs.
> .....
Okay, I will update it on next version.
>
>> +	while (nexts++ < num_exts &&
>> +	       *current_ext <  XFS_IFORK_NEXTENTS(ip, whichfork)) {
>> +
>> +		gotp = xfs_iext_get_ext(ifp, *current_ext);
>> +		xfs_bmbt_get_all(gotp, &got);
>> +		startoff = got.br_startoff - offset_shift_fsb;
>> +
>> +		/*
>> +		 * Before shifting extent into hole, make sure that the hole
>> +		 * is large enough to accomodate the shift.
>> +		 */
>> +		if (*current_ext) {
>> +			xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
>> +						*current_ext - 1), &left);
>> +
>> +			if (startoff < left.br_startoff + left.br_blockcount)
>> +				error = XFS_ERROR(EINVAL);
>> +
>> +		} else if (startoff > xfs_bmbt_get_startoff(gotp)) {
>> +			/* Hole is at the start but not large enough */
>> +			error = XFS_ERROR(EINVAL);
>> +		}
>
> This second branch seems wrong to me:
>
> 	startoff = got.br_startoff - offset_shift_fsb;
> and
> 	got.br_startoff = xfs_bmbt_get_startoff(gotp)).
>
> I'm not 100% sure what you are trying to check in this case -
> perhaps some basic ascii art to describe the two cases is in order
> here:
>
> 	left	hole		got
> 	+-------+hhhhhhhhhhhhhhh+---------+
> 	LS      LE              GS        GE
> 		HS              HE
>
> The first is checking that GS - offset_shift_fsb is greater than LE.
> i.e the shift doesn't overrun the hole betwenn LE and GS.
>
> 	left	hole		got
> 	+-------+hhhhhhhhhhhhhhh+---------+
> 	LS      LE              GS        GE
> 		HS              HE
> 	+-------+hhhhhhh+---------+
> 	LS      LE      GS'       GE'
> 		HS      HE'
>
> The second I can't visualise from the code or comment....
When we shift first extent, *current_ext  will be 0. So we need to
check that offset_shift_fsb ( Number of blocks to be shifted ) should
be less than starting offset of the first extent.
So, code will be changed more clearly like this.

 + else if (offset_shift_fsb > got.br_startoff) {
 + /* Hole is at the start but not large enough */
 + error = XFS_ERROR(EINVAL);
 + }
And will update comment more clearly.
>
>
>> +
>> +		if (error)
>> +			goto del_cursor;
>> +
>> +		if (cur) {
>> +			error = xfs_bmbt_lookup_eq(cur,
>> +					got.br_startoff,
>> +					got.br_startblock,
>> +					got.br_blockcount,
>> +					&i);
>
> Whitespace comment - a more compact form is the typical XFS
> convention if it will fit in 80 columns:
Okay. I will fix it.
>
> 			error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
> 						   got.br_startblock,
> 						   got.br_blockcount, &i);
>
>> +			if (error)
>> +				goto del_cursor;
>> +			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
>> +		}
>> +
>> +		/* Check if we can merge 2 adjacent extents */
>> +		if (*current_ext &&
>> +		    left.br_startoff + left.br_blockcount == startoff &&
>> +		    left.br_startblock + left.br_blockcount ==
>> +				got.br_startblock &&
>> +		    left.br_state == got.br_state &&
>> +		    left.br_blockcount + got.br_blockcount <= MAXEXTLEN) {
>> +			blockcount = left.br_blockcount +
>> +				xfs_bmbt_get_blockcount(gotp);
>
> 				got.br_blockcount?
Right. will fix it.
>
>> +			xfs_iext_remove(ip, *current_ext, 1, 0);
>> +			if (cur) {
>> +				error = xfs_btree_delete(cur, &i);
>> +				if (error)
>> +					goto del_cursor;
>> +				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
>> +			}
>> +			XFS_IFORK_NEXT_SET(ip, whichfork,
>> +				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
>> +			gotp = xfs_iext_get_ext(ifp, --*current_ext);
>> +			xfs_bmbt_get_all(gotp, &got);
>> +
>> +			/* Make cursor point to the extent we will update */
>> +			if (cur) {
>> +				error = xfs_bmbt_lookup_eq(cur,
>> +				got.br_startoff,
>> +				got.br_startblock,
>> +				got.br_blockcount,
>> +				&i);
>
> whitespace.
Okay.
>
>> +				if (error)
>> +					goto del_cursor;
>> +				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
>> +			}
>> +
>> +			xfs_bmbt_set_blockcount(gotp, blockcount);
>> +			got.br_blockcount = blockcount;
>> +			goto bmbt_update;
>> +		}
>> +
>> +		/* We have to update the startoff */
>> +		xfs_bmbt_set_startoff(gotp, startoff);
>> +		got.br_startoff = startoff;
>> +
>> +bmbt_update:
>
> Use an } else {} for this, and the goto can be removed.
Okay, I will change.
>
> ....
>>  /*
>> + * xfs_collapse_file_space()
>> + *      This routine frees disk space and shift extent for the given
>> file.
>> + *
>> + * RETURNS:
>> + *      0 on success
>> + *      errno on error
>> + *
>> + */
>> +int
>> +xfs_collapse_file_space(
>> +	struct xfs_inode	*ip,
>> +	xfs_off_t		offset,
>> +	xfs_off_t		len)
>> +{
>> +	int			done = 0;
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	struct xfs_trans	*tp;
>> +	int			error;
>> +	xfs_extnum_t		current_ext = 0;
>> +	struct xfs_bmap_free	free_list;
>> +	xfs_fsblock_t		first_block;
>> +	int			committed;
>> +	xfs_fileoff_t		start_fsb;
>> +	xfs_fileoff_t		shift_fsb;
>> +
>> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
>> +
>> +	trace_xfs_collapse_file_space(ip);
>> +
>> +	start_fsb = XFS_B_TO_FSB(mp, offset + len);
>> +	shift_fsb = XFS_B_TO_FSB(mp, len);
>> +
>> +	/*
>> +	 * The first thing we do is to free data blocks in the specified range
>> +	 * by calling xfs_free_file_space(). It would also sync dirty data
>> +	 * and invalidate page cache over the region on which collapse range
>> +	 * is working.
>> +	 */
>
> This can probably go in the function header as part of describing
> the overall algorithm the code is using.
Okay.

>
>> +	error = xfs_free_file_space(ip, offset, len);
>> +	if (error)
>> +		return error;
>> +
>> +	while (!error && !done) {
>> +		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
>> +		tp->t_flags |= XFS_TRANS_RESERVE;
>> +		/*
>> +		 * We would need to reserve permanent block for transaction.
>> +		 * This will come into picture when after shifting extent into
>> +		 * hole we found that adjacent extents can be merged which
>> +		 * may lead to freeing of a block during record update.
>> +		 */
>> +		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
>> +				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
>> +		if (error) {
>> +			ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
>> +			xfs_trans_cancel(tp, 0);
>> +			break;
>> +		}
>> +
>> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
>> +				ip->i_gdquot, ip->i_pdquot,
>> +				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
>> +				XFS_QMOPT_RES_REGBLKS);
>> +		if (error)
>> +			goto out;
>> +
>> +		xfs_trans_ijoin(tp, ip, 0);
>> +
>> +		xfs_bmap_init(&free_list, &first_block);
>> +
>> +		/*
>> +		 * We are using the write transaction in which max 2 bmbt
>> +		 * updates are allowed
>> +		 */
>
> Right, but you've only reserved blocks for a single BMBT split
> through XFS_DIOSTRAT_SPACE_RES(). In cases of allocation, adjacent
> offset allocation is guaranteed to only require one split at most
> and hence it's safe from that perspective. However, I can see how a
> shift can require a split on the first extent move, and a merge on
> the second. e.g:
>
>
> 		left		middle		right
> before		maxrecs		minrecs + 1	minrecs
> first shift	maxrecs + 1	minrecs		minrecs
> 		split
> 		maxrecs / 2	minrecs		minrecs
> second shift
> 		maxrecs/2 + 1	minrecs - 1	minrecs
> 				merge		merge
> 				minrecs*2 - 1	(freed)
>
> So the question is whether the transaction reservations (both log
> space and block allocation requirements) are covered.
Yes, As you said, we could require two splits for extent move and
merge in some cases.
So, I will change number of shift extents with decraring define you
pointed like this.
#define XFS_BMAP_MAX_SHIFT_EXTENTS      1

>
>> +		error = xfs_bmap_shift_extents(tp, ip, &done, start_fsb,
>> +				shift_fsb, &current_ext,
>> +				&first_block, &free_list, 2);
>
> And that should really have a #define associated with it. ie.:
>
> #define XFS_BMAP_MAX_SHIFT_EXTENTS	2
>
> And document the constraints that lead to that number with the
> definition.
>
> Overall, all I'm really looking for here is sufficient comments to
> document the constraints the code is operating under. Functionally
> the code looks correct (apart from the branch above I can't work
> out). Mostly I just want to make sure that in a couple of
> years time I don't have to work it all out from first principles
> again. ;)
Okay, I will add sufficient comments to maintain easily this change.

Thanks for your review!
>
> Cheers,
>
> Dave.
>
> --
> Dave Chinner
> david@fromorbit.com
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

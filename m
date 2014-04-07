Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C33FE7F4E
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 09:11:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27E88AC009
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 07:11:52 -0700 (PDT)
Received: from mail-qg0-f47.google.com (mail-qg0-f47.google.com
	[209.85.192.47]) by cuda.sgi.com with ESMTP id LYFCE4QBXm4sJ50w
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Apr 2014 07:11:50 -0700 (PDT)
Received: by mail-qg0-f47.google.com with SMTP id i50so758139qgf.6
	for <xfs@oss.sgi.com>; Mon, 07 Apr 2014 07:11:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140404203521.GA15122@laptop.bfoster>
References: <1396277668-10861-1-git-send-email-linkinjeon@gmail.com>
	<20140404203521.GA15122@laptop.bfoster>
Date: Mon, 7 Apr 2014 23:11:49 +0900
Message-ID: <CAKYAXd_e1vDhEe+svh1ycfWOcNvZZVPT634AGeNSfJfPwkq-xQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
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
To: Brian Foster <bfoster@redhat.com>
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, Ashish Sangwan <a.sangwan@samsung.com>, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org

>> +
>> +int
>> +xfs_bmap_split_extent(
>> +	struct xfs_inode	*ip,
>> +	xfs_fileoff_t		split_fsb,
>> +	xfs_extnum_t		*split_ext)
>> +{
>> +	struct xfs_mount        *mp = ip->i_mount;
>> +	struct xfs_trans	*tp;
>> +	struct xfs_bmap_free	free_list;
>> +	xfs_fsblock_t		firstfsb;
>> +	int			committed;
>> +	int			error;
>> +
>> +	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
>> +	tp->t_flags |= XFS_TRANS_RESERVE;
>
> Any reason this (or the other cases) has to be reserve enabled?
Hi Brian.
No Particular reason apart from following the same pattern we used
in collapse range patches.
During Collapse range review, Dave Chinner also suggested that
we should not use reserved pool:
"This probably shouldn't use XFS_TRANS_RESERVE. If we are at ENOSPC,
then the operation simply fails. Yes, we've already punched the
hole, so we shouldn't get ENOSPC here, but I don't think it's worth
dipping into the reserve pool as it has much more important uses..."

I will remove this and from other places in next version.
(and probably the same need to be done for collapse range)

>
>> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
>> +			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
>> +
>> +	/*
>> +	 * check for running out of space
>> +	 */
>> +	if (error) {
>> +		/*
>> +		 * Free the transaction structure.
>> +		 */
>> +		ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
>> +		xfs_trans_cancel(tp, 0);
>> +		return error;
>> +	}
>> +
>> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
>> +			ip->i_gdquot, ip->i_pdquot,
>> +			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
>> +			XFS_QMOPT_RES_REGBLKS);
>> +	if (error)
>> +		goto error1;
>
> We should probably have an xfs_qm_dqattach() call before we get here. As
> it is, it looks like the first one is in xfs_alloc_file_space().
Okay, I will check about this point.
>

>> +
>> +/*
>> + * Shift extent records to the right to make a hole.
>> + * The maximum number of extents to be shifted in a single operation
>> + * is @num_exts, and @current_ext keeps track of the current extent
>> + * index we have shifted. @offset_shift_fsb is the length by which each
>> + * extent is shifted. @end_ext is the last extent to be shifted.
>> + */
>> +int
>> +xfs_bmap_shift_extents_right(
>> +	struct xfs_trans	*tp,
>> +	struct xfs_inode	*ip,
>> +	int			*done,
>> +	xfs_fileoff_t		offset_shift_fsb,
>> +	xfs_extnum_t		*current_ext,
>> +	xfs_extnum_t		end_ext,
>> +	xfs_fsblock_t		*firstblock,
>> +	struct xfs_bmap_free	*flist,
>> +	int			num_exts)
>> +{
>> +	struct xfs_mount		*mp = ip->i_mount;
>> +	struct xfs_btree_cur		*cur;
>> +	struct xfs_bmbt_rec_host	*gotp;
>> +	struct xfs_bmbt_irec		got;
>> +	struct xfs_bmbt_irec            right;
>> +	xfs_ifork_t			*ifp;
>> +	xfs_fileoff_t			startoff;
>> +	xfs_filblks_t			blockcount = 0;
>> +	int				error = 0;
>> +	int				i;
>> +	int				whichfork = XFS_DATA_FORK;
>> +	int				logflags;
>> +
>> +	if (unlikely(XFS_TEST_ERROR(
>> +	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
>> +	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
>> +	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
>> +		XFS_ERROR_REPORT("xfs_bmap_shift_extents_right",
>> +				 XFS_ERRLEVEL_LOW, mp);
>> +		return XFS_ERROR(EFSCORRUPTED);
>> +	}
>> +
>> +	if (XFS_FORCED_SHUTDOWN(mp))
>> +		return XFS_ERROR(EIO);
>> +
>> +	ASSERT(current_ext != NULL);
>> +
>> +	/* We are going to change core inode */
>> +	logflags = XFS_ILOG_CORE;
>> +	ifp = XFS_IFORK_PTR(ip, whichfork);
>> +
>> +	if (ifp->if_flags & XFS_IFBROOT) {
>> +		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>> +		cur->bc_private.b.firstblock = *firstblock;
>> +		cur->bc_private.b.flist = flist;
>> +		cur->bc_private.b.flags = 0;
>> +	} else {
>> +		cur = NULL;
>> +		logflags |= XFS_ILOG_DEXT;
>> +	}
>> +
>> +	/* start shifting extents to right */
>> +	while (num_exts-- > 0) {
>> +		if (*current_ext < end_ext) {
>> +			*done = 1;
>> +			break;
>> +		}
>> +
>> +		gotp = xfs_iext_get_ext(ifp, *current_ext);
>> +		xfs_bmbt_get_all(gotp, &got);
>> +		startoff = got.br_startoff + offset_shift_fsb;
>> +
>> +		/*
>> +		 * Before shifting extent into hole, make sure that the hole
>> +		 * is large enough to accomodate the shift. This checking has
>> +		 * to be performed for all except the last extent.
>> +		 */
>> +		if ((XFS_IFORK_NEXTENTS(ip, whichfork) - 1) != *current_ext) {
>> +			xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
>> +						*current_ext + 1), &right);
>> +			if (startoff + got.br_blockcount > right.br_startoff) {
>> +				error = XFS_ERROR(EINVAL);
>> +				if (error)
>> +					goto del_cursor;
>> +			}
>> +		}
>> +
>> +		/* Check if we can merge 2 adjacent extents */
>> +		if ((XFS_IFORK_NEXTENTS(ip, whichfork) - 1) != *current_ext &&
>> +		    right.br_startoff == startoff + got.br_blockcount &&
>> +		    right.br_startblock ==
>> +				got.br_startblock + got.br_blockcount &&
>> +		    right.br_state == got.br_state &&
>> +		    right.br_blockcount + got.br_blockcount <= MAXEXTLEN) {
>> +			blockcount = right.br_blockcount + got.br_blockcount;
>> +
>> +			/* Make cursor point to the extent we will update */
>> +			if (cur) {
>> +				error = xfs_bmbt_lookup_eq(cur,
>> +							   right.br_startoff,
>> +							   right.br_startblock,
>> +							   right.br_blockcount,
>> +							   &i);
>> +				if (error)
>> +					goto del_cursor;
>> +				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
>> +			}
>> +
>> +			xfs_iext_remove(ip, *current_ext + 1, 1, 0);
>> +			if (cur) {
>> +				error = xfs_btree_delete(cur, &i);
>> +				if (error)
>> +					goto del_cursor;
>> +				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
>> +			}
>> +			XFS_IFORK_NEXT_SET(ip, whichfork,
>> +					XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
>> +
>> +		}
>> +
>> +		if (cur) {
>> +			error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
>> +						   got.br_startblock,
>> +						   got.br_blockcount,
>> +						   &i);
>> +			if (error)
>> +				goto del_cursor;
>> +			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
>> +		}
>> +
>> +		if (got.br_blockcount < blockcount) {
>> +			xfs_bmbt_set_blockcount(gotp, blockcount);
>> +			got.br_blockcount = blockcount;
>> +		}
>
> A comment would be nice here for this bit that fixes up the blockcount
> in the extent merge case. You also probably want to reset blockcount. ;)
Right. Blockcount needs to be reset. Although we are shifting just a single
extent, It does not matter in current situation.
But as a generic API for shifting extents, It is better to reset the blockcount.
>
>> +
>> +
>> +		xfs_bmbt_set_startoff(gotp, startoff);
>> +		got.br_startoff = startoff;
>> +
>> +		if (cur) {
>> +			error = xfs_bmbt_update(cur, got.br_startoff,
>> +						got.br_startblock,
>> +						got.br_blockcount,
>> +						got.br_state);
>> +			if (error)
>> +				goto del_cursor;
>> +		}
>> +
>> +		(*current_ext)--;
>> +	}
>> +
>> +del_cursor:
>> +	if (cur)
>> +		xfs_btree_del_cursor(cur,
>> +			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
>> +	xfs_trans_log_inode(tp, ip, logflags);
>> +	return error;
>> +}
>> diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
>> index f84bd7a..91ca1a7 100644
>> --- a/fs/xfs/xfs_bmap.h
>> +++ b/fs/xfs/xfs_bmap.h
>> @@ -179,10 +179,17 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct
>> xfs_inode *ip,
>>  int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
>>  		xfs_extnum_t num);
>>  uint	xfs_default_attroffset(struct xfs_inode *ip);
>> -int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>> +int	xfs_bmap_shift_extents_left(struct xfs_trans *tp, struct xfs_inode
>> *ip,
>>  		int *done, xfs_fileoff_t start_fsb,
>>  		xfs_fileoff_t offset_shift_fsb, xfs_extnum_t *current_ext,
>>  		xfs_fsblock_t *firstblock, struct xfs_bmap_free	*flist,
>>  		int num_exts);
>> +int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t
>> split_offset,
>> +		xfs_extnum_t *split_ext);
>> +int	xfs_bmap_shift_extents_right(struct xfs_trans *tp, struct xfs_inode
>> *ip,
>> +		int *done, xfs_fsblock_t offset_shift_fsb,
>> +		xfs_extnum_t *current_ext, xfs_extnum_t end_ext,
>> +		xfs_fsblock_t *firstblock, struct xfs_bmap_free *flist,
>> +		int num_exts);
>>
>>  #endif	/* __XFS_BMAP_H__ */
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index 01f6a64..8b10d6d 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -1539,7 +1539,7 @@ xfs_collapse_file_space(
>>  		 * We are using the write transaction in which max 2 bmbt
>>  		 * updates are allowed
>>  		 */
>> -		error = xfs_bmap_shift_extents(tp, ip, &done, start_fsb,
>> +		error = xfs_bmap_shift_extents_left(tp, ip, &done, start_fsb,
>>  					       shift_fsb, &current_ext,
>>  					       &first_block, &free_list,
>>  					       XFS_BMAP_MAX_SHIFT_EXTENTS);
>> @@ -1563,6 +1563,127 @@ out:
>>  }
>>
>>  /*
>> + * xfs_insert_file_space()
>> + *	This routine allocate disk space and shift extent for the given file.
>> + *	The first thing we do is to sync dirty data and invalidate page cache
>> + *	over the region on which insert range is working. And split an extent
>> + *	to two extents at given offset by calling xfs_bmap_split_extent.
>> + *	And shift all extent records which are laying between [offset,
>> + *	last allocated extent] to the right to reserve hole range. Lastly
>> + *	allocate an unwritten extent in hole range created by shifting
>> extents.
>> + *
>> + * RETURNS:
>> + *	0 on success
>> + *	errno on error
>> + *
>> + */
>> +int
>> +xfs_insert_file_space(
>> +	struct xfs_inode	*ip,
>> +	loff_t			offset,
>> +	loff_t			len)
>> +{
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	struct xfs_trans	*tp;
>> +	struct xfs_bmap_free	free_list;
>> +	xfs_fsblock_t		first_block;
>> +	int			done = 0;
>> +	int			committed;
>> +	int			error;
>> +	uint			rounding;
>> +	xfs_fileoff_t		start_fsb;
>> +	xfs_fileoff_t		shift_fsb;
>> +	xfs_extnum_t		split_ext;
>> +	xfs_extnum_t		current_ext = 0;
>> +	xfs_off_t		ioffset;
>> +
>> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
>> +	trace_xfs_insert_file_space(ip);
>> +
>> +	/* wait for the completion of any pending DIOs */
>> +	inode_dio_wait(VFS_I(ip));
>> +
>> +	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
>> +	ioffset = offset & ~(rounding - 1);
>> +	error = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
>> +			ioffset, -1);
>> +	if (error)
>> +		return error;
>> +	truncate_pagecache_range(VFS_I(ip), ioffset, -1);
>> +
>> +	start_fsb = XFS_B_TO_FSB(mp, offset);
>> +	shift_fsb = XFS_B_TO_FSB(mp, len);
>> +
>> +	error = xfs_bmap_split_extent(ip, start_fsb, &split_ext);
>> +	if (error)
>> +		return error;
>> +
>> +	current_ext = XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) - 1;
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
>> +			goto error1;
>> +
>> +		xfs_trans_ijoin(tp, ip, 0);
>> +
>> +		xfs_bmap_init(&free_list, &first_block);
>> +
>> +		/*
>> +		 * We are using the write transaction in which max 2 bmbt
>> +		 * updates are allowed
>> +		 */
>> +		error = xfs_bmap_shift_extents_right(tp, ip, &done, shift_fsb,
>> +						&current_ext, split_ext,
>> +						&first_block, &free_list,
>> +						XFS_BMAP_MAX_SHIFT_EXTENTS);
>> +		if (error)
>> +			goto error0;
>> +
>> +		error = xfs_bmap_finish(&tp, &free_list, &committed);
>> +		if (error)
>> +			goto error0;
>> +
>> +		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +		if (error)
>> +			goto out;
>> +	}
>> +
>> +	/* make unwritten extent in a hole range. */
>> +	error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_PREALLOC);
>
> There is potential for this to fail with ENOSPC or due to quota after
> we've already inserted the address range in the file and moved the
> extent over. Are we Ok with that behavior?
>
> Even if so, what is the caller left with? Even though I think it would
> be nicer if we were to fail in that scenario sooner, I could understand
> if we completed the extent shift and just left a hole in the inserted
> region. As it is, it looks like the caller will skip updating the file
> size and thus some file data might fall after EOF, which is probably not
> what we want. I don't know if it's worth worrying about the same thing
> if we happen to fail earlier in the middle of shifting extents over..?
Good point. We should not skip updating the file size even if we fail after
shifting a single extent. i.e. even if there is a single successful shift, there
has to be inode size update otherwise the user will loose data.

Failing in between the extent shifting will have the same effect as with
collapse range. We will end up with a hole somewhere between the EOF
and the shift start point. This is the limitation with journal filesystem where
we have to reserve journal blocks in advance and commit transactions in
between the shifting operation. If a user is well equipped with xfs_bmap,
He can still reissue insert range commands after checking
the files's extent tree.

Thanks for review!
>
> Brian
>
>> +
>> +out:
>> +	return error;
>> +
>> +error0:
>> +	xfs_bmap_cancel(&free_list);
>> +error1:
>> +	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +	return error;
>> +}
>> +
>> +/*
>>   * We need to check that the format of the data fork in the temporary
>> inode is
>>   * valid for the target inode before doing the swap. This is not a
>> problem with
>>   * attr1 because of the fixed fork offset, but attr2 has a dynamically
>> sized
>> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
>> index 935ed2b..d62ab4b 100644
>> --- a/fs/xfs/xfs_bmap_util.h
>> +++ b/fs/xfs/xfs_bmap_util.h
>> @@ -101,6 +101,8 @@ int	xfs_zero_file_space(struct xfs_inode *ip,
>> xfs_off_t offset,
>>  			    xfs_off_t len);
>>  int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
>>  				xfs_off_t len);
>> +int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
>> +				xfs_off_t len);
>>
>>  /* EOF block manipulation functions */
>>  bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 003c005..6603b36 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -824,7 +824,8 @@ xfs_file_fallocate(
>>  	if (!S_ISREG(inode->i_mode))
>>  		return -EINVAL;
>>  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
>> -		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
>> +		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
>> +		     FALLOC_FL_INSERT_RANGE))
>>  		return -EOPNOTSUPP;
>>
>>  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
>> @@ -846,6 +847,20 @@ xfs_file_fallocate(
>>  		error = xfs_collapse_file_space(ip, offset, len);
>>  		if (error)
>>  			goto out_unlock;
>> +	} else if (mode & FALLOC_FL_INSERT_RANGE) {
>> +		unsigned blksize_mask = (1 << inode->i_blkbits) - 1;
>> +
>> +		if (offset & blksize_mask || len & blksize_mask) {
>> +			error = -EINVAL;
>> +			goto out_unlock;
>> +		}
>> +
>> +		ASSERT(offset < i_size_read(inode));
>> +		new_size = i_size_read(inode) + len;
>> +
>> +		error = xfs_insert_file_space(ip, offset, len);
>> +		if (error)
>> +			goto out_unlock;
>>  	} else {
>>  		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
>>  		    offset + len > i_size_read(inode)) {
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index a4ae41c..c870288 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -604,6 +604,7 @@ DEFINE_INODE_EVENT(xfs_inactive_symlink);
>>  DEFINE_INODE_EVENT(xfs_alloc_file_space);
>>  DEFINE_INODE_EVENT(xfs_free_file_space);
>>  DEFINE_INODE_EVENT(xfs_collapse_file_space);
>> +DEFINE_INODE_EVENT(xfs_insert_file_space);
>>  DEFINE_INODE_EVENT(xfs_readdir);
>>  #ifdef CONFIG_XFS_POSIX_ACL
>>  DEFINE_INODE_EVENT(xfs_get_acl);
>> --
>> 1.7.11-rc0
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

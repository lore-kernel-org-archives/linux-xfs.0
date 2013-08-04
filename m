Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 16A937F4E
	for <xfs@oss.sgi.com>; Sun,  4 Aug 2013 03:29:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CFCC78F8071
	for <xfs@oss.sgi.com>; Sun,  4 Aug 2013 01:29:07 -0700 (PDT)
Received: from mail-pa0-f49.google.com (mail-pa0-f49.google.com
	[209.85.220.49]) by cuda.sgi.com with ESMTP id DuoeGbkpcfcWX2i7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 04 Aug 2013 01:29:03 -0700 (PDT)
Received: by mail-pa0-f49.google.com with SMTP id bi5so2166365pad.8
	for <xfs@oss.sgi.com>; Sun, 04 Aug 2013 01:29:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130802034759.GU13468@dastard>
References: <1375281734-15874-1-git-send-email-linkinjeon@gmail.com>
	<20130801011812.GJ7118@dastard>
	<CAKYAXd-miJBmDs3aArkhoFwGuVYDc9FSnX2gabbmX86Yu78amA@mail.gmail.com>
	<20130802034759.GU13468@dastard>
Date: Sun, 4 Aug 2013 17:29:02 +0900
Message-ID: <CAKYAXd-mQjuCFxWGEw33j_-_a_R2xKHtBZ9X3nx5fa6_xT+P_Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] xfs: Implement FALLOC_FL_COLLAPSE_RANGE
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
Cc: elder@kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, adilger.kernel@dilger.ca, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

>
>> >> +	if (cur) {
>> >> +		if (!error)
>> >> +			cur->bc_private.b.allocated = 0;
>> >
>> > Um, why?
>> Okay, will remove.
>
> I'm asking you to explain why you put it there. Don't remove code
> that might be necessary just because a hard question was asked....
We copied this code from xfs_bunmapi. And we realize that why it is
there because xfs_bunmapi may split the extents, which could require
block allocation for btree, but I think that is not necessary here
because updating starting offsets of extents would not reqire a btree
split and allocation.
>
>> >> @@ -845,6 +850,21 @@ xfs_file_fallocate(
>> >>  	if (error)
>> >>  		goto out_unlock;
>> >>
>> >> +	if (mode & FALLOC_FL_COLLAPSE_RANGE) {
>> >> +		error = -xfs_collapse_file_space(ip, offset + len, len);
>> >> +		if (error || offset >= i_size_read(inode))
>> >> +			goto out_unlock;
>> >> +
>> >> +		/* Shrink size in case of FALLOC_FL_COLLAPSE_RANGE */
>> >> +		if ((offset + len) > i_size_read(inode))
>> >> +			new_size = offset;
>> >> +		else
>> >> +			new_size = i_size_read(inode) - len;
>> >> +		error = -xfs_update_file_size(ip, new_size);
>> >> +
>> >> +		goto out_unlock;
>> >> +	}
>> >
>> > This needs to vector through xfs_change_file_space() - it already
>> > has code for doing offset/range validity checks, attaching
>> > appropriate dquots for accounting, post-op file size and timestamp
>> > updates, etc.
>> It already is going through xfs_change_file_space(). Check this=>
>
> No it isn't - this is calling xfs_collapse_file_space from
> xfs_file_fallocate(). That is not going through
> xfs_change_file_space().
>
> Oh, I see now, this hunk is *after* the xfs_change_file_space()
> call.  That's nasty - it's a layering violation, pure and simple.
>
> No wonder I thought that no hole punching was done, it's triggered
> by a non-obvious flag set and so hidden three layers away from the
> xfs_collapse_file_space() call that acts on the hole that was
> punched.  This code *must* go through the same code paths as the
> other fallocate operations so it is obvious how it interacts with
> everything.
>
>> >> +
>> >> +/*
>> >> + * xfs_update_file_size()
>> >> + *	Just a simple disk size and time update
>> >> + */
>> >> +int
>> >> +xfs_update_file_size(
>> >> +	struct xfs_inode        *ip,
>> >> +	loff_t			newsize)
>> >
>> > This function should be nuked from orbit. I stopped looking at it
>> > when the bug count got past 5. If you use xfs_change_file_space,
>> > it's not necessary, either.
>> we are using xfs_change_file_space(). See my comment above. :)
>
> Yes, badly. See my comment above. :)
>
>> But, xfs_change_file_space does not change logical file size.
>> Neither can we use xfs_setattr, because it will truncate the
>> preallocated extents beyond EOF.
>
> And the problem with that is?
>
> Seriously, if you are chopping chunks out of a file and moving
> extents around in it, you aren't going to be writing to it while
> that is happening. For NLE workflows, this manipulation happens
> after the entire stream is written. If you collapse the range while
> the video is being written, you are going to end up with big
> chunks of zeroes in the file as you the write() has a file position
> way beyond the new EOF....
>
>> >> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
>> >> index dc730ac..95b46e7 100644
>> >> --- a/fs/xfs/xfs_vnodeops.c
>> >> +++ b/fs/xfs/xfs_vnodeops.c
>> >> @@ -1868,3 +1868,65 @@ xfs_change_file_space(
>> >>  		xfs_trans_set_sync(tp);
>> >>  	return xfs_trans_commit(tp, 0);
>> >>  }
>> >> +
>> >> +/*
>> >> + * xfs_collapse_file_space()
>> >> + *	This implements the fallocate collapse range functionlaity.
>> >> + *	It removes the hole from file by shifting all the extents which
>> >> + *	lies beyond start block.
>> >> + */
>> >> +int
>> >> +xfs_collapse_file_space(
>> >> +	xfs_inode_t	*ip,
>> >> +	loff_t		start,
>> >> +	loff_t		shift)
>> >> +{
>> >> +	int		done = 0;
>> >> +	xfs_mount_t	*mp = ip->i_mount;
>> >> +	uint		resblks;
>> >> +	xfs_trans_t	*tp;
>> >> +	int		error = 0;
>> >> +	xfs_extnum_t	current_ext = 0;
>> >> +	xfs_fileoff_t	start_fsb = XFS_B_TO_FSB(mp, start);
>> >> +	xfs_fileoff_t	shift_fsb = XFS_B_TO_FSB(mp, shift);
>> >> +	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
>> >> +
>> >> +	while (!error && !done) {
>> >> +		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
>> >> +		tp->t_flags |= XFS_TRANS_RESERVE;
>> >> +		error = xfs_trans_reserve(tp, resblks, XFS_WRITE_LOG_RES(mp),
>> >> +					  0, XFS_TRANS_PERM_LOG_RES,
>> >> +					  XFS_WRITE_LOG_COUNT);
>> >
>> > Why a permanent log reservation for a single, non-nested transaction?
>> XFS transaction log reservation code is becoming our major problem.
>> Could you suggest a proper way?
>
> Permanent log transactions are only needed for transactions that
> commit multiple times between reservations. You are doing:
>
> 	tp = alloc()
> 	reserve(tp, XFS_WRITE_LOG_RES, XFS_TRANS_PERM_LOG_RES,
> XFS_WRITE_LOG_COUNT)
> 	commit(tp, XFS_TRANS_RELEASE_LOG_RES)
>
> It's a single transaction. Permanent log transactions are used for
> multi-stage, rolling transactions that can be broken up into
> multiple atomic operations, so as freeing multiple extents from a
> file:
>
> 	tp = alloc()
> 	reserve(tp, XFS_WRITE_LOG_RES, XFS_TRANS_PERM_LOG_RES,
> XFS_WRITE_LOG_COUNT)
> 	.....
> 	tp2 = dup(tp)
> 	commit(tp)
> 	reserve(tp2, XFS_WRITE_LOG_RES, XFS_TRANS_PERM_LOG_RES,
> XFS_WRITE_LOG_COUNT)
> 	....
> 	commit(tp2, XFS_TRANS_PERM_LOG_RES).
>
>
> The dup/reserve/commit loop keeps the same transaction context
> across the whole operation and allows them to make continual forward
> progress.
>
> Hmmmm. In looking at this, I notice the update case that uses a
> btree cursor doesn't have an the flist/firstblock initialised.
> That'll cause an oops if a block is ever allocated or freed in a
> record update. That would also indicate that the above does indeed
> need a permanent log transaction and probably needs to be structured
> similar to xfs_itruncate_extents with
> xfs_bmap_init/xfs_bmap_finish() and a rolling transaction just in
> case we end up modifying the btree.
Ok, we noted all your points and understand that a lot of work is
really needed to make it stable. we will try to implement them in next
version of patch. Really thanks for your time and help.

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

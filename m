Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3FCC829DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 22:48:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1FFB48F8049
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 20:48:13 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bUOV6acbF05ldq2j for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 20:48:07 -0700 (PDT)
Date: Fri, 2 Aug 2013 13:47:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: Implement FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130802034759.GU13468@dastard>
References: <1375281734-15874-1-git-send-email-linkinjeon@gmail.com>
	<20130801011812.GJ7118@dastard>
	<CAKYAXd-miJBmDs3aArkhoFwGuVYDc9FSnX2gabbmX86Yu78amA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKYAXd-miJBmDs3aArkhoFwGuVYDc9FSnX2gabbmX86Yu78amA@mail.gmail.com>
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

On Thu, Aug 01, 2013 at 02:33:09PM +0900, Namjae Jeon wrote:
> 2013/8/1, Dave Chinner <david@fromorbit.com>:
> > On Wed, Jul 31, 2013 at 11:42:14PM +0900, Namjae Jeon wrote:
> >> From: Namjae Jeon <namjae.jeon@samsung.com>
> >>
> >> New fallocate flag FALLOC_FL_COLLAPSE_RANGE implementation for XFS.
> >
> Hi Dave.
> > A good start, but there's lots of work needed to make this safe for
> > general use.
> First, Thanks for your advice and help.
> 
> >
> >> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> >> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> >> ---
> >>  fs/xfs/xfs_bmap.c     |   92
> >> +++++++++++++++++++++++++++++++++++++++++++++++++
> >>  fs/xfs/xfs_bmap.h     |    3 ++
> >>  fs/xfs/xfs_file.c     |   26 ++++++++++++--
> >>  fs/xfs/xfs_iops.c     |   35 +++++++++++++++++++
> >>  fs/xfs/xfs_vnodeops.c |   62 +++++++++++++++++++++++++++++++++
> >>  fs/xfs/xfs_vnodeops.h |    2 ++
> >>  6 files changed, 217 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> >> index 05c698c..ae677b1 100644
> >> --- a/fs/xfs/xfs_bmap.c
> >> +++ b/fs/xfs/xfs_bmap.c
> >> @@ -6145,3 +6145,95 @@ next_block:
> >>
> >>  	return error;
> >>  }
> >> +
> >> +/*
> >> + * xfs_update_logical()
> >> + *	Updates starting logical block of extents by subtracting
> >> + *	shift from them. At max XFS_LINEAR_EXTS number extents
> >> + *	will be updated and *current_ext is the extent number which
> >> + *	is currently being updated.
> >
> > Single space after the "*" in the comments. Also, format them out to
> > 80 columns.
> >
> Single space after * followed by a tab gives checkpath warning:
> WARNING: please, no space before tabs
> #29: FILE: fs/xfs/xfs_bmap.c:6151:
> + * ^IUpdates starting logical block of extents by subtracting$

Get rid of the tabs altogether. The comment doesn't nee dthe
function name in it, and it doesn't need indenting. i.e.:

/*
 * Update the starting logical block of extents by subtracting shift from them.
 * At max XFS_LINEAR_EXTS number extents will be updated and *current_ext is
 * the extent number which is currently being updated.
 */


> > 	struct xfs_mount	*mp = ip->i_mount;
> >
> >> +
> >> +	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
> >> +		(error = xfs_iread_extents(tp, ip, XFS_DATA_FORK)))
> >> +		return error;
> >
> > Hmmmm - that rings alarm bells.
> ok, we will remove the alarm.

The reason it rings alarm bells is that this indicates that we have
an extent manipulation function being done without any of the usual
checks that the inode is in a format that we can do this
operation, or that it is correctly locked, or that the filesyste is
not shut down, etc. Have a look at all the other functions that call
xfs_iread_extents() in xfs_bmap.c....


> >> +
> >> +	if (!*current_ext) {
> >> +		gotp = xfs_iext_bno_to_ext(ifp, start_fsb, current_ext);
> >> +		/*
> >> +		 * gotp can be null in 2 cases: 1) if there are no extents
> >> +		 * or 2) start_fsb lies in a hole beyond which there are
> >> +		 * no extents. Either way, we are done.
> >> +		 */
> >> +		if (!gotp) {
> >> +			*done = 1;
> >> +			return 0;
> >> +		}
> >> +	}
> >
> > So, you do a lookup on an extent index, which returns a incore
> > extent record.
> >
> >> +
> >> +	if (ifp->if_flags & XFS_IFBROOT)
> >> +		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
> >> +	else
> >> +		cur = NULL;
> >> +
> >> +	while (nexts++ < XFS_LINEAR_EXTS &&
> >
> > What has XFS_LINEAR_EXTS got to do with how many extents can be moved
> > in a single transaction at a time?
> We are also not sure how many extents to move in 1 transaction.
> xfs_bunmapi deletes 3 extents in 1 iteration.

No, it removes as many as the caller asks it to. The caller defines
that number because the caller is the one that reserved the
transaction space for the removal.

> But deletion and updation are 2 different tasks.

Yes, they are.

> BTW, we tested this patch with 10,000 extents and it is working fine.
> Could you help us out here? What number would be appropriate?

How many btree modifications can a record update do? Can it cause a
btree split? If it can cause a btree split, then we nee dto do
allocation and reserve enough blocks in the transaction reservation
for the split.

So, if we can split the bmbt, then allocation can cause the free
space btrees to split as well, so we need to reserve blocks for
those tree splits, too.

And if each record update can potentially cause a bmbt split and
multiple free space btree splits, then how many records should we
update in a single transaction? IOWs, it's no different to hole
punching, truncation, *allocation*, etc.

You used the write transaction reservation, which is defined as:

/*
 * In a write transaction we can allocate a maximum of 2
 * extents.  This gives:
 *    the inode getting the new extents: inode size
 *    the inode's bmap btree: max depth * block size
 *    the agfs of the ags from which the extents are allocated: 2 * sector
 *    the superblock free block counter: sector size
 *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
 * And the bmap_finish transaction can free bmap blocks in a join:
 *    the agfs of the ags containing the blocks: 2 * sector size
 *    the agfls of the ags containing the blocks: 2 * sector size
 *    the super block free block counter: sector size
 *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
 */


And that defines exactly how many bmbt updates you are
allowed to do in that transaction: 2 extents.

> >
> >> +				goto del_cursor;
> >> +			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
> >> +		}
> >> +		startoff -= shift;
> >> +		xfs_bmbt_set_startoff(gotp, startoff);
> >
> > So, we've looked up and extent, and reduced it's offset by shift.
> >
> >> +		if (cur) {
> >> +			error = xfs_bmbt_update(cur, startoff,
> >> +						xfs_bmbt_get_startblock(gotp),
> >> +						xfs_bmbt_get_blockcount(gotp),
> >> +						xfs_bmbt_get_state(gotp));
> >> +			if (error)
> >> +				goto del_cursor;
> >
> > And then we update the btree record in place.
> >
> > Ok, major alarm bells are going off at this point. Is the record
> > still in the right place? Where did you validate that the shift
> > downwards didn't overlap the previous extent in the tree?
> >
> > What happens if the start or end of the range to be shifted partially
> > overlaps an extent? The shift can only be done into a hole in the
> > file offset, so any attempt to shift downwards that overlaps an
> > existing extent is immediately invalid and indicates something is
> > wrong (pssobily corruption).
> >
> > And if the end of the range being shifted partially overlaps an
> > extent, then that extent needs to be split - it requires two records
> > in the tree to track the part that was shifted and the part that was
> > not.
> Your concern is correct.
> There can be 2 approach of updating the extent tree.
> 
> Approach1: (The way truncate works): We start from the last allocated
> extent and move towards the last offset which was punched out.
> It mean start updating extents from right side and move towards left
> and update btree in between
> Approach2: We start from the extent just after the punched area and
> move towards the last extent of the file.

Yes, I can see *how* you are doing the shifting - I don't need you
to explain that. What I'm pointing out is that you are not
checking that it is safe to make this modification. i.e. where do
you guarantee that there is a hole in the location that you are
shifting the extents into?

FWIW, you don't check to see if the first shifted extent can be
merged with the extent that is to the left of it as a result of the
shift. If it is adjacent and contiguous and the result is a single
extent that doesn'te xceed the maximum supported by the filesystem,
then they should be merged and the old record removed.

> >> +	if (cur) {
> >> +		if (!error)
> >> +			cur->bc_private.b.allocated = 0;
> >
> > Um, why?
> Okay, will remove.

I'm asking you to explain why you put it there. Don't remove code
that might be necessary just because a hard question was asked....

> >> @@ -845,6 +850,21 @@ xfs_file_fallocate(
> >>  	if (error)
> >>  		goto out_unlock;
> >>
> >> +	if (mode & FALLOC_FL_COLLAPSE_RANGE) {
> >> +		error = -xfs_collapse_file_space(ip, offset + len, len);
> >> +		if (error || offset >= i_size_read(inode))
> >> +			goto out_unlock;
> >> +
> >> +		/* Shrink size in case of FALLOC_FL_COLLAPSE_RANGE */
> >> +		if ((offset + len) > i_size_read(inode))
> >> +			new_size = offset;
> >> +		else
> >> +			new_size = i_size_read(inode) - len;
> >> +		error = -xfs_update_file_size(ip, new_size);
> >> +
> >> +		goto out_unlock;
> >> +	}
> >
> > This needs to vector through xfs_change_file_space() - it already
> > has code for doing offset/range validity checks, attaching
> > appropriate dquots for accounting, post-op file size and timestamp
> > updates, etc.
> It already is going through xfs_change_file_space(). Check this=>

No it isn't - this is calling xfs_collapse_file_space from
xfs_file_fallocate(). That is not going through
xfs_change_file_space().

Oh, I see now, this hunk is *after* the xfs_change_file_space()
call.  That's nasty - it's a layering violation, pure and simple.

No wonder I thought that no hole punching was done, it's triggered
by a non-obvious flag set and so hidden three layers away from the
xfs_collapse_file_space() call that acts on the hole that was
punched.  This code *must* go through the same code paths as the
other fallocate operations so it is obvious how it interacts with
everything.

> >> +
> >> +/*
> >> + * xfs_update_file_size()
> >> + *	Just a simple disk size and time update
> >> + */
> >> +int
> >> +xfs_update_file_size(
> >> +	struct xfs_inode        *ip,
> >> +	loff_t			newsize)
> >
> > This function should be nuked from orbit. I stopped looking at it
> > when the bug count got past 5. If you use xfs_change_file_space,
> > it's not necessary, either.
> we are using xfs_change_file_space(). See my comment above. :)

Yes, badly. See my comment above. :)

> But, xfs_change_file_space does not change logical file size.
> Neither can we use xfs_setattr, because it will truncate the
> preallocated extents beyond EOF.

And the problem with that is?

Seriously, if you are chopping chunks out of a file and moving
extents around in it, you aren't going to be writing to it while
that is happening. For NLE workflows, this manipulation happens
after the entire stream is written. If you collapse the range while
the video is being written, you are going to end up with big
chunks of zeroes in the file as you the write() has a file position
way beyond the new EOF....

> >> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> >> index dc730ac..95b46e7 100644
> >> --- a/fs/xfs/xfs_vnodeops.c
> >> +++ b/fs/xfs/xfs_vnodeops.c
> >> @@ -1868,3 +1868,65 @@ xfs_change_file_space(
> >>  		xfs_trans_set_sync(tp);
> >>  	return xfs_trans_commit(tp, 0);
> >>  }
> >> +
> >> +/*
> >> + * xfs_collapse_file_space()
> >> + *	This implements the fallocate collapse range functionlaity.
> >> + *	It removes the hole from file by shifting all the extents which
> >> + *	lies beyond start block.
> >> + */
> >> +int
> >> +xfs_collapse_file_space(
> >> +	xfs_inode_t	*ip,
> >> +	loff_t		start,
> >> +	loff_t		shift)
> >> +{
> >> +	int		done = 0;
> >> +	xfs_mount_t	*mp = ip->i_mount;
> >> +	uint		resblks;
> >> +	xfs_trans_t	*tp;
> >> +	int		error = 0;
> >> +	xfs_extnum_t	current_ext = 0;
> >> +	xfs_fileoff_t	start_fsb = XFS_B_TO_FSB(mp, start);
> >> +	xfs_fileoff_t	shift_fsb = XFS_B_TO_FSB(mp, shift);
> >> +	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> >> +
> >> +	while (!error && !done) {
> >> +		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> >> +		tp->t_flags |= XFS_TRANS_RESERVE;
> >> +		error = xfs_trans_reserve(tp, resblks, XFS_WRITE_LOG_RES(mp),
> >> +					  0, XFS_TRANS_PERM_LOG_RES,
> >> +					  XFS_WRITE_LOG_COUNT);
> >
> > Why a permanent log reservation for a single, non-nested transaction?
> XFS transaction log reservation code is becoming our major problem.
> Could you suggest a proper way?

Permanent log transactions are only needed for transactions that
commit multiple times between reservations. You are doing:

	tp = alloc()
	reserve(tp, XFS_WRITE_LOG_RES, XFS_TRANS_PERM_LOG_RES, XFS_WRITE_LOG_COUNT)
	commit(tp, XFS_TRANS_RELEASE_LOG_RES)

It's a single transaction. Permanent log transactions are used for
multi-stage, rolling transactions that can be broken up into
multiple atomic operations, so as freeing multiple extents from a
file:

	tp = alloc()
	reserve(tp, XFS_WRITE_LOG_RES, XFS_TRANS_PERM_LOG_RES, XFS_WRITE_LOG_COUNT)
	.....
	tp2 = dup(tp)
	commit(tp)
	reserve(tp2, XFS_WRITE_LOG_RES, XFS_TRANS_PERM_LOG_RES, XFS_WRITE_LOG_COUNT)
	....
	commit(tp2, XFS_TRANS_PERM_LOG_RES).


The dup/reserve/commit loop keeps the same transaction context
across the whole operation and allows them to make continual forward
progress.

Hmmmm. In looking at this, I notice the update case that uses a
btree cursor doesn't have an the flist/firstblock initialised.
That'll cause an oops if a block is ever allocated or freed in a
record update. That would also indicate that the above does indeed
need a permanent log transaction and probably needs to be structured
similar to xfs_itruncate_extents with
xfs_bmap_init/xfs_bmap_finish() and a rolling transaction just in
case we end up modifying the btree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

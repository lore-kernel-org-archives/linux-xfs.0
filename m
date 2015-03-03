Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4D6FA7F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 15:56:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E687EAC001
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 13:56:01 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	YC2KXLsZqaShwWdu for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 13:55:59 -0800 (PST)
Date: Wed, 4 Mar 2015 08:55:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] Implement XFS_IOC_FSBULKSTAT_RANGE ioctl
Message-ID: <20150303215557.GU4251@dastard>
References: <1425393678-4550-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1425393678-4550-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 03, 2015 at 11:41:18AM -0300, Carlos Maiolino wrote:
> This patch aims to implement a ranged bulkstat ioctl, which will make users able
> to bulkstat inodes in a filesystem based on range instead on rely only in a
> whole filesystem bulkstat.
> 
> This first implementation add a per AG bulkstat possibility, but it also adds
> the necessary infrastructure to implement different kinds of ranged bulkstat,
> like per block.
> 
> The patch is already working and I've been testing it for a while, so, I think
> it's time to send this patch out and ask for comments on it.
> 
> The core of the implementation is very similar with what xfs_bulsktat() does by
> now, which, instead bulkstat the whole filesystem, it start/stop on the
> specified range.
> 
> As per Dave's suggesting, I added to  rgbulkreq structure (used to pass data
> to/from userland), a padding, so we can use the same structure for another kind
> of ranged bulkstats without the need to actually change the structure size.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h |  12 +++
>  fs/xfs/xfs_ioctl.c     |  56 +++++++++++++
>  fs/xfs/xfs_itable.c    | 210 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_itable.h    |  16 ++++
>  4 files changed, 294 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 18dc721..88665aa 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -334,6 +334,17 @@ typedef struct xfs_fsop_bulkreq {
>  	__s32		__user *ocount;	/* output count pointer		*/
>  } xfs_fsop_bulkreq_t;
>  
> +typedef struct xfs_fsop_rgbulkreq {
> +	__u64		__user *lastip; /* last inode # pointer		*/
> +	__s32		icount;		/* count of entries in buffer	*/
> +	void		__user *ubuffer;/* user buffer for inode desc.	*/
> +	__s32		__user *ocount;	/* output count pointer		*/
> +	__u64		start;		/* start point of rgbulkstat	*/
> +	__u64		end;		/* end point of rgbulkstat	*/
> +	__u32		flags;		/* multipurpose flag field	*/
> +	__u32		pad[5];		/* reserved space		*/
> +} xfs_fsop_rgbulkreq_t;

No new typedefs. Also, call it struct xfs_fsop_bulkstat_range, so
it's clear what ioctl it belongs with.

And, as eric mentioned, the flag:

#define XFS_FSOP_BSRANGE_AGNUMBER	1

also needs to be defined to tell the kernel that start/end are ag
numbers.

> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index f7afb86..34a4de5 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -790,6 +790,59 @@ xfs_ioc_bulkstat(
>  }
>  
>  STATIC int
> +xfs_ioc_bulkstat_range(
> +	xfs_mount_t		*mp,
> +	unsigned int		cmd,
> +	void			__user *arg)
> +{
> +
> +	xfs_fsop_rgbulkreq_t	rgbulkreq;

Again, better name needed. Even just "bsreq" would be fine, because
it's just a bulkstat request structure....

> +	int			count;	/* # of records returned */
> +	xfs_ino_t		inlast; /* last inode number */
> +	int			done;
> +	int			error;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return -EIO;
> +
> +	/* We do not support another ranged calls yet */
> +	if (cmd != XFS_IOC_FSBULKSTAT_RANGE)
> +		return -EINVAL;

Not necessary.

> +
> +	if (copy_from_user(&rgbulkreq, arg, sizeof(xfs_fsop_rgbulkreq_t)))
> +		return -EFAULT;
> +
> +	if (copy_from_user(&inlast, rgbulkreq.lastip, sizeof(__s64)))
> +		return -EFAULT;
> +
> +	if ((count = rgbulkreq.icount) <= 0)
> +		return -EINVAL;

Assignments need to be on their own line.

> +
> +	if (rgbulkreq.ubuffer == NULL)
> +		return -EINVAL;

Missing is validation of the start, end and flags fields.

> +
> +	error = xfs_bulkstat_range(mp, &inlast, &count, xfs_bulkstat_one,
> +				   sizeof(xfs_bstat_t), rgbulkreq.ubuffer,
> +				   rgbulkreq.start, rgbulkreq.end, &done);

Why do you need a "done" parameter?  Also, just pass the bsreq
structure, not the individual elements. I don't see any point in
passing the formatter or size parameters at this point, either,
because xfs_bulkstat_range() can easily define them.

> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 82e3142..d6b27ee 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -530,6 +530,216 @@ del_cursor:
>  	return error;
>  }
>  
> +/*
> + * Return stat information in bulk (by-inode) for specified
> + * filesystem range.
> + */
> +int
> +xfs_bulkstat_range(
> +	xfs_mount_t		*mp,	/* mount point for filesystem */
> +	xfs_ino_t		*lastinop, /* last inode returned */
> +	int			*ubcountp, /* size of buffer/count returned */
> +	bulkstat_one_pf		formatter, /* func that'd fill a single buf */
> +	size_t			statstruct_size, /* sizeof struct filling */
> +	char			__user *ubuffer, /* buffer with inode stats */
> +	__u64			start,	/* start bulkstat here */
> +	__u64			end,	/* end bulkstat here */
> +	int			*done) /* 1 if there are more stats to get */
> +{
> +	xfs_buf_t		*agbp;	/* agi header buffer */
> +	xfs_agino_t		agino;	/* inode # in allocation group */
> +	xfs_agnumber_t		agno;	/* allocation group number */
> +	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
> +	size_t			irbsize; /* size of irec buffer in bytes */
> +	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
> +	int			nirbuf;	/* size of irbuf */
> +	int			ubcount; /* size of user's buffer */
> +	struct xfs_bulkstat_agichunk ac;
> +	int			error = 0;
> +
> +	/*
> +	 * Get the last inode value, see if there is nothing to do.
> +	 */
> +	if (*lastinop != 0)
> +		agno = XFS_INO_TO_AGNO(mp, *lastinop);
> +	else
> +		agno = start;
> +
> +	agino = XFS_INO_TO_AGINO(mp, *lastinop);
> +
> +	/*
> +	 * If specified end is bigger than mp->m_sb.sb_agount, should we
> +	 * gracefully interpret as if there is nothing to do, or trigger
> +	 * an error?
> +	 */

We should have already errored out before we get here in this case.

> +	if (agno >= mp->m_sb.sb_agcount) {
> +		*done = 1;
> +		*ubcountp = 0;
> +		return 0;
> +	}

>From this point onwards, you've pretty much copy-n-pasted the
xfs_bulkstat() implementation. What should happen here is:

	for (agno = start; agno < end; agno++) {
		error = xfs_bulkstat_range_ag(agno, ... );
		if (error)
			break;
	}

and all this:

> +	ubcount = *ubcountp;
> +	ac.ac_ubuffer = &ubuffer;
> +	ac.ac_ubleft = ubcount * statstruct_size; /* bytes */
> +	ac.ac_ubelem = 0;
> +
> +	*ubcountp = 0;
> +	*done = 0;
> +
> +	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
> +	if (!irbuf)
> +		return -ENOMEM;
> +
> +	nirbuf = irbsize / sizeof(*irbuf);
> +
> +	/*
> +	 * Loop over the allocation groups, starting from the last inode
> +	 * returned; - means start of the allocation group.
> +	 */
> +	while (agno <= end) {
> +		struct xfs_inobt_rec_incore	*irbp = irbuf;
> +		struct xfs_inobt_rec_incore	*irbufend = irbuf + nirbuf;
> +		bool				end_of_ag = false;
> +		int				icount = 0;
> +		int				stat;
> +
> +		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
> +		if (error)
> +			break;
> +
> +		/*
> +		 * Allocate and initialize a btree cursor for ialloc btree.
> +		 */
> +		cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
> +					    XFS_BTNUM_INO);
> +
> +		if (agino > 0) {
> +			/*
> +			 * In the middle of an allocation group, we need to get
> +			 * the remainder of the chunk we are in.
> +			 */
> +			struct xfs_inobt_rec_incore	r;
> +
> +			error = xfs_bulkstat_grab_ichunk(cur, agino, &icount, &r);
> +			if (error)
> +				goto del_cursor;
> +			if (icount) {
> +				irbp->ir_startino = r.ir_startino;
> +				irbp->ir_freecount = r.ir_freecount;
> +				irbp->ir_free = r.ir_free;
> +				irbp++;
> +			}
> +			/* Increment to the next record */
> +			error = xfs_btree_increment(cur, 0, &stat);
> +		} else {
> +			/* Start of ag. Lookup the first inode chunk */
> +			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &stat);
> +		}
> +		if (error || stat == 0) {
> +			end_of_ag = true;
> +			goto del_cursor;
> +		}
> +
> +		/*
> +		 * Loop through inode btree records in this ag,
> +		 * until we run out of inodes or space in the buffer.
> +		 */
> +		while (irbp < irbufend && icount < ubcount) {
> +			struct xfs_inobt_rec_incore	r;
> +
> +			error = xfs_inobt_get_rec(cur, &r, &stat);
> +			if (error || stat == 0) {
> +				end_of_ag = true;
> +				goto del_cursor;
> +			}
> +
> +			/*
> +			 * If this chunk has any allocated inodes, save it.
> +			 * Also start read-ahead now for this chunk.
> +			 */
> +			if (r.ir_freecount < XFS_INODES_PER_CHUNK) {
> +				xfs_bulkstat_ichunk_ra(mp, agno, &r);
> +				irbp->ir_startino = r.ir_startino;
> +				irbp->ir_freecount = r.ir_freecount;
> +				irbp->ir_free = r.ir_free;
> +				irbp++;
> +				icount += XFS_INODES_PER_CHUNK - r.ir_freecount;
> +			}
> +			error = xfs_btree_increment(cur, 0, &stat);
> +			if (error || stat == 0) {
> +				end_of_ag = true;
> +				goto del_cursor;
> +			}
> +			cond_resched();
> +		}
> +
> +	/*
> +	 * Drop the btree buffers and the agi buffer as we can't hold any of the
> +	 * locks these represent when calling iget. If there is a pending error,
> +	 * then we are done.
> +	 */
> +del_cursor:
> +		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> +		xfs_buf_relse(agbp);
> +		if (error)
> +			break;
> +		/*
> +		 * Now format all the good inodes into the user's buffer. The
> +		 * call to xfs_bulkstat_ag_ichunk() sets up the agino pointer
> +		 * for the next loop iteration.
> +		 */
> +		irbufend = irbp;
> +		for (irbp = irbuf;
> +		     irbp < irbufend && ac.ac_ubleft >= statstruct_size;
> +		     irbp++) {
> +			error = xfs_bulkstat_ag_ichunk(mp, agno, irbp, formatter,
> +						statstruct_size, &ac, &agino);
> +			if (error)
> +				break;
> +
> +			cond_resched();
> +		}
> +
> +		/*
> +		 * If we have run out of space or had a formatting error, we
> +		 * are now done
> +		 */
> +		if (ac.ac_ubleft < statstruct_size || error)
> +			break;
> +
> +		if (end_of_ag) {
> +			agno++;
> +			agino = 0;
> +		}
> +	}
> +	/*
> +	 * Done, we are either out of specified inode range or space to
> +	 * put the data.
> +	 */
> +	kmem_free(irbuf);
> +	*ubcountp = ac.ac_ubelem;

Up to here is done by xfs_bulkstat_range_ag(). This factoring should
be done to xfs_bulkstat() as the first patch in the series, then you
can add the xfs_bulkstat_range() function that uses it, then finally
introduce the ioctl that wraps around xfs_bulkstat_range().

This avoids all of the copy/paste, and ensures that the bulkstat
APIs all use the same implementation which makes testing and
maintenance of the code in future much simpler.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

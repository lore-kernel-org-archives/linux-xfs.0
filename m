Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51316 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfAQSmH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 13:42:07 -0500
Date: Thu, 17 Jan 2019 10:41:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/12] xfs: wait for deferred inactivation when
 destroying unlinked inodes
Message-ID: <20190117184158.GE4424@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
 <154630908468.16693.4548983851684057794.stgit@magnolia>
 <20190103124644.GN4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190103124644.GN4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 03, 2019 at 11:46:44PM +1100, Dave Chinner wrote:
> On Mon, Dec 31, 2018 at 06:18:04PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that we've constructed a mechanism to batch background inode
> > inactivation work, we actually want in some cases to throttle the amount
> > of backlog work that the frontend can generate.  We do this by making
> > destroy_inode wait for inactivation when we're deleting things, assuming
> > that deleted inodes are dropped and destroyed in process context and not
> > from fs reclaim.
> 
> This would kills performance of highly concurrent unlink
> workloads.
> 
> That said, the current unlink code needs severe throttling because
> the unlinked inode list management does not scale at all well - get
> more than a a couple of hundred inodes into the AGI unlinked lists,
> and xfs_iunlink_remove burns huge amounts of CPU.
> 
> So if it isn't throttled, it'll be just as slow, but burn huge
> amounts amounts of extra CPU walking the unlinked lists.....

...so I've refactored the iunlink code to record "who points to this
inode?" references, which speeds up iunlink_remove substantially.  I'll
put that series out for review after letting it run on some real
workloads.

I've also dropped this patch from the series entirely, just to see what
happens.  The tradeoff here is that allocations see increased latency
upon hitting ENOSPC because we now force inactivation to see if we can
clean things out, but OTOH if we never hit ENOSPC then the rest of the
fs runs considerably faster.

> > +/*
> > + * Decide if this inode is a candidate for unlinked inactivation throttling.
> > + * We have to decide this prior to setting the NEED_INACTIVE iflag because
> > + * once we flag the inode for inactivation we can't access it any more.
> > + */
> > +enum xfs_iwait
> > +xfs_iwait_check(
> > +	struct xfs_inode	*ip)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	unsigned long long	x;
> > +	unsigned long long	y;
> > +	bool			rt = XFS_IS_REALTIME_INODE(ip);
> > +
> > +	/*
> > +	 * Don't wait unless we're doing a deletion inactivation.  We assume
> > +	 * that unlinked inodes that lose all their refcount are dropped,
> > +	 * evicted, and destroyed immediately in the context of the unlink()ing
> > +	 * process.
> > +	 */
> 
> I think this is wrong - we want to push unlinked inode processing
> into the background so we don't have to wait on it, not force
> inactivation of unlinked inodes to wait for other inodes to be
> inactivated.

The original idea behind most of this was that we'd try to slow down a
rm -rf so that the fs doesn't find itself facing a gigantic flood of
inactivation work, particularly if there were a lot of extents to free
or a lot of inodes to free.  Under this scheme we don't ever wait for
inactivation if we're just closing a linked file, but we could do so for
deletions.

However, it is difficult to quantify what "gigantic" means here.  The
situation I was trying to avoid is where the system gets bogged down
with background processing work for a long time after the userspace
process terminates, but perhaps it's better not to bother. :)

> > +	if (VFS_I(ip)->i_nlink > 0)
> > +		return XFS_IWAIT_NEVER;
> > +
> > +	/*
> > +	 * If we're being called from kswapd we're in background memory reclaim
> > +	 * context.  There's no point in making it wait for ondisk metadata
> > +	 * updates, which themselves require memory allocations.
> > +	 */
> > +	if (current->flags & PF_KSWAPD)
> > +		return XFS_IWAIT_NEVER;
> > +
> > +	/*
> > +	 * Always wait for directory removal so we clean up any files that
> > +	 * were in that directory.
> > +	 */
> > +	if (S_ISDIR(VFS_I(ip)->i_mode)) {
> > +		trace_xfs_inactive_iwait_all(ip);
> > +		return XFS_IWAIT_ALL;
> > +	}
> 
> why do we need to wait for directories? it's already unlinked, so if
> we crash it and everything in it are not going to reappear....

Same reasoning as above.

> > +	/* Heavily fragmented files take a while to delete. */
> > +	x = XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) +
> > +	    XFS_IFORK_NEXTENTS(ip, XFS_ATTR_FORK) +
> > +	    XFS_IFORK_NEXTENTS(ip, XFS_COW_FORK);
> > +	y = rt ? 256 : 32 * mp->m_sb.sb_agcount;
> > +	if (x >= y) {
> > +		trace_xfs_inactive_iwait_inode(ip);
> > +		return XFS_IWAIT_INODE;
> > +	}
> 
> Why does the number of extents in the current inode determine
> whether we wait for completion of all other inode inactivations in
> the same AG?

<urk> This might've grown into a way to force inactivation of a single
inode, but for now it's dropped.

> > +
> > +	return XFS_IWAIT_UNDECIDED;
> > +}
> > +
> > +/*
> > + * Wait for deferred inode inactivation of an unlinked inode being destroyed.
> > + *
> > + * The deferred inode inactivation mechanism provides for background batching
> > + * of whatever on-disk metadata updates are necessary to free an inode and all
> > + * the resources it holds.  In theory this should speed up deletion by enabling
> > + * us to inactivate in inode number order.
> > + *
> > + * However, there are a few situations where we actually /want/ to throttle
> > + * unlinking.  Specifically, if we're unlinking fragmented files or removing
> > + * entire directory trees, we should wait instead of allowing an enormous
> > + * processing backlog that causes update storms later.
> > + *
> > + * We will wait for inactivation to finish under the following circumstances:
> > + *  - Removing a directory
> > + *  - Removing a heavily fragmented file
> > + *  - A large number of blocks could be freed by inactivation
> > + *  - A large number of inodes could be freed by inactivation
> > + */
> > +void
> > +xfs_inactive_wait(
> > +	struct xfs_mount	*mp,
> > +	enum xfs_iwait		iwait,
> > +	xfs_agnumber_t		agno)
> > +{
> > +	unsigned long long	x;
> > +	unsigned long long	y;
> > +
> > +	switch (iwait) {
> > +	case XFS_IWAIT_NEVER:
> > +		return;
> > +	case XFS_IWAIT_ALL:
> > +	case XFS_IWAIT_INODE:
> > +		goto wait;
> > +	default:
> > +		break;
> > +	}
> > +
> > +	iwait = XFS_IWAIT_ALL;
> > +
> > +	/* More than 1/4 of an AG space could be freed by inactivation. */
> > +	x = percpu_counter_read_positive(&mp->m_dinactive);
> > +	y = mp->m_sb.sb_agblocks / 4;
> > +	if (x >= y)
> > +		goto wait;
> 
> But that's a global counter - how does that relate to individual AG
> space at all?
> 
> > +
> > +	/* Less than 1/16 of the datadev is free. */
> > +	x = percpu_counter_read_positive(&mp->m_fdblocks);
> > +	y = mp->m_sb.sb_dblocks / 16;
> > +	if (x <= y)
> > +		goto wait;
> 
> urk. If I have a 100TB filesystem, that means we always throttle with 6-7TB
> of free space available. That's not right.
> 
> > +	/* More than 1/4 of the rtdev could be freed by inactivation. */
> > +	y = mp->m_sb.sb_rblocks;
> > +	if (y > 0) {
> > +		x = percpu_counter_read_positive(&mp->m_rinactive);
> > +		if (x >= y / 4)
> > +			goto wait;
> 
> That's even worse - this might not even be a rt inode... :/

<nod> I think I've managed to flush out all the places where we bail out
to userspace with ENOSPC and amend them to force inactivation and try
once more, so these shouldn't be necessary.

> > +
> > +		/* Less than 1/16 of the rtdev is free. */
> > +		x = mp->m_sb.sb_frextents * mp->m_sb.sb_rextsize;
> > +		if (x <= y / 16)
> > +			goto wait;
> > +	}
> > +
> > +	/* A lot of inodes could be freed by inactivation. */
> > +	x = percpu_counter_read_positive(&mp->m_iinactive);
> > +	y = XFS_INODES_PER_CHUNK * 4 * (unsigned long long)mp->m_sb.sb_agcount;
> > +	if (x >= y)
> > +		goto wait;
> 
> And, yeah, that's just wrong once we fix the unlinked inode
> scalability problem, as the patch below does.
> 
> 
> > +	return;
> > +wait:
> > +	switch (iwait) {
> > +	case XFS_IWAIT_ALL:
> > +		xfs_inactive_force(mp);
> > +		break;
> > +	case XFS_IWAIT_INODE:
> > +		xfs_inactive_force_ag(mp, agno);
> > +		break;
> > +	default:
> > +		ASSERT(0);
> 
> So we assert here if we get XFS_IWAIT_UNDECIDED?
> 
> >  	 * reclaim tear down all inodes.
> >  	 */
> >  	xfs_inode_set_reclaim_tag(ip, need_inactive);
> > +
> > +	/*
> > +	 * Wait for inactivation of this inode if the inode has zero nlink.
> > +	 * This cannot be done in fs reclaim context, which means we assume
> > +	 * that unlinked inodes that lose all their refcount are dropped,
> > +	 * evicted, and destroyed immediately in the context of the unlink()ing
> > +	 * process and are never fed to the LRU for reclaim.
> > +	 */
> 
> Apparently overlay breaks this assumption - AFAIA it can drop the last
> inode reference on unlinked inodes from it's dcache shrinker.

Heh.  Ok, maybe we simply never wait for inactivation then.

> > +	xfs_inactive_wait(mp, caniwait, agno);
> 
> So, prototype incore unlinked inode list patch is below. It needs
> log recovery help - the incore list needs to be rebuilt in log
> recovery so xfs_iunlink_remove works correctly. It also
> short-circuits some of the above "should wait for inactivation"
> checks and so some of the performance regressions are mostly
> removed...

As noted earlier, I took over this from Dave.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: incore unlinked inode list
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Introduce an incore per-ag unlinked inode list to avoid needing to
> walk the buffer based unlinked lists to find the inodes to modify
> when removing an inode from the unlinked list.  When the unlinked
> lists grow long, finding an inode on the unlinked list requires
> mapping the inode number to a buffer, reading the buffer, extracting
> the inode from the buffer and reading the next inode number on the
> list. This is a lot of overhead, especially the buffer lookups. If
> we keep an in-core copy of the unlinked list, we don't need to do
> the buffer traversal to find the previous buffer in the list for
> unlinking; it's just the previous inode in the incore list.
> 
> The incore list is rooted in the xfs_perag, and mirrors the same
> hash structure in the AGI. The order of the lists is identical to
> the ordering on disk. Hence we can look up the incore list and then
> find the buffer we need to modify to remove inodes from the unlinked
> list.
> 
> Discussion: in this implementation, the incore list nests inside the
> AGI buffer locks, so the AGI buffer lock effectively serialises all
> unlinked list operations on the AGI whether it is needed or not. If
> we change the order of the locking and use the incore list as the
> canonical source of unlinked inodes, then we only need to get the
> AGI lock when we are modifying the AGI, not all modifications to the
> unlinked list. This could allow some level of parallelisation of
> unlinked list operations even within the same AG....
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c |   9 ++
>  fs/xfs/xfs_inode.c  | 318 +++++++++++++++++++++++++---------------------------
>  fs/xfs/xfs_inode.h  |   2 +
>  fs/xfs/xfs_mount.c  |   7 ++
>  fs/xfs/xfs_mount.h  |   5 +
>  5 files changed, 177 insertions(+), 164 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a34f6101526b..5a28173b5ecd 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1952,6 +1952,7 @@ xfs_inactive_wait(
>  	enum xfs_iwait		iwait,
>  	xfs_agnumber_t		agno)
>  {
> +	struct xfs_perag	*pag;
>  	unsigned long long	x;
>  	unsigned long long	y;
>  
> @@ -1993,10 +1994,18 @@ xfs_inactive_wait(
>  	}
>  
>  	/* A lot of inodes could be freed by inactivation. */
> +#if 0
>  	x = percpu_counter_read_positive(&mp->m_iinactive);
>  	y = XFS_INODES_PER_CHUNK * 4 * (unsigned long long)mp->m_sb.sb_agcount;
>  	if (x >= y)
>  		goto wait;
> +	pag = xfs_perag_get(mp, agno);
> +	if (pag->pagi_unlinked_count > 10000) {
> +		xfs_perag_put(pag);
> +		goto wait;
> +	}
> +	xfs_perag_put(pag);
> +#endif
>  
>  	return;
>  wait:
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2c7f8aeffa92..a4b6f3e597f8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2053,6 +2053,48 @@ xfs_inactive(
>  	xfs_qm_dqdetach(ip);
>  }
>  
> +/*
> + * Modify the next unlinked inode pointer on disk. Returns the old pointer value
> + * or a negative error.
> + *
> + * XXX: really want a new logical inode transaction flag for this so we don't
> + * ever need to touch buffers again here. That will change locking requirements,
> + * though.
> + */
> +static int
> +xfs_iunlink_mod(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	xfs_agino_t		next_agino,
> +	xfs_agino_t		*old_agino)
> +{
> +	struct xfs_mount *mp = tp->t_mountp;
> +	struct xfs_dinode *dip;
> +	struct xfs_buf	*ibp;
> +	int		offset;
> +	int		error;
> +
> +	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0, 0);
> +	if (error) {
> +		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
> +			__func__, error);
> +		return error;
> +	}
> +	if (old_agino)
> +		*old_agino = be32_to_cpu(dip->di_next_unlinked);
> +	dip->di_next_unlinked = cpu_to_be32(next_agino);
> +	offset = ip->i_imap.im_boffset +
> +				offsetof(struct xfs_dinode, di_next_unlinked);
> +
> +	/* need to recalc the inode CRC if appropriate */
> +	xfs_dinode_calc_crc(mp, dip);
> +
> +	xfs_trans_inode_buf(tp, ibp);
> +	xfs_trans_log_buf(tp, ibp, offset, (offset + sizeof(xfs_agino_t) - 1));
> +	xfs_inobp_check(mp, ibp);
> +	return 0;
> +}
> +
>  /*
>   * This is called when the inode's link count goes to 0 or we are creating a
>   * tmpfile via O_TMPFILE. In the case of a tmpfile, @ignore_linkcount will be
> @@ -2068,23 +2110,32 @@ xfs_iunlink(
>  	struct xfs_trans *tp,
>  	struct xfs_inode *ip)
>  {
> -	xfs_mount_t	*mp = tp->t_mountp;
> -	xfs_agi_t	*agi;
> -	xfs_dinode_t	*dip;
> -	xfs_buf_t	*agibp;
> -	xfs_buf_t	*ibp;
> +	struct xfs_mount *mp = tp->t_mountp;
> +	struct xfs_perag *pag;
> +	struct xfs_agi	*agi;
> +	struct xfs_buf	*agibp;
>  	xfs_agino_t	agino;
> +	xfs_agino_t	next_agino;
> +	xfs_agnumber_t	agno;
> +	struct list_head *unlinked_list;
>  	short		bucket_index;
>  	int		offset;
>  	int		error;
>  
>  	ASSERT(VFS_I(ip)->i_mode != 0);
>  
> +	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> +	ASSERT(agino != 0);
> +        bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
> +
> +	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	pag = xfs_perag_get(mp, agno);
> +	unlinked_list = &pag->pagi_unlinked_list[bucket_index];
> +
>  	/*
> -	 * Get the agi buffer first.  It ensures lock ordering
> -	 * on the list.
> +	 * Get the agi buffer first.  It ensures lock ordering on the list.
>  	 */
> -	error = xfs_read_agi(mp, tp, XFS_INO_TO_AGNO(mp, ip->i_ino), &agibp);
> +	error = xfs_read_agi(mp, tp, agno, &agibp);
>  	if (error)
>  		return error;
>  	agi = XFS_BUF_TO_AGI(agibp);
> @@ -2093,48 +2144,57 @@ xfs_iunlink(
>  	 * Get the index into the agi hash table for the
>  	 * list this inode will go on.
>  	 */
> -	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> -	ASSERT(agino != 0);
> -	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
> -	ASSERT(agi->agi_unlinked[bucket_index]);
> -	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
> +	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> +	ASSERT(next_agino != 0);
> +	ASSERT(next_agino != agino);
> +
> +	mutex_lock(&pag->pagi_unlink_lock);
> +	if (next_agino != NULLAGINO) {
> +		xfs_agino_t	old_agino;
> +#ifdef DEBUG
> +		struct xfs_inode *nip;
> +
> +		ASSERT(!list_empty(unlinked_list));
> +		nip = list_first_entry(unlinked_list, struct xfs_inode,
> +					i_unlinked_list);
> +		ASSERT(XFS_INO_TO_AGINO(mp, nip->i_ino) == next_agino);
> +#endif
>  
> -	if (agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO)) {
>  		/*
>  		 * There is already another inode in the bucket we need
>  		 * to add ourselves to.  Add us at the front of the list.
>  		 * Here we put the head pointer into our next pointer,
>  		 * and then we fall through to point the head at us.
>  		 */
> -		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
> -				       0, 0);
> -		if (error)
> -			return error;
> -
> -		ASSERT(dip->di_next_unlinked == cpu_to_be32(NULLAGINO));
> -		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
> -		offset = ip->i_imap.im_boffset +
> -			offsetof(xfs_dinode_t, di_next_unlinked);
> -
> -		/* need to recalc the inode CRC if appropriate */
> -		xfs_dinode_calc_crc(mp, dip);
> -
> -		xfs_trans_inode_buf(tp, ibp);
> -		xfs_trans_log_buf(tp, ibp, offset,
> -				  (offset + sizeof(xfs_agino_t) - 1));
> -		xfs_inobp_check(mp, ibp);
> +		error = xfs_iunlink_mod(tp, ip, next_agino, &old_agino);
> +		if (error) {
> +			mutex_unlock(&pag->pagi_unlink_lock);
> +			goto out;
> +		}
> +		ASSERT(old_agino == NULLAGINO);
> +	} else {
> +		ASSERT(list_empty(unlinked_list));
>  	}
>  
> +	/*
> +	* As we are always adding the inode at the head of the AGI list,
> +	* it always gets added to the head here.
> +	*/
> +	list_add(&ip->i_unlinked_list, unlinked_list);
> +	mutex_unlock(&pag->pagi_unlink_lock);
> +
>  	/*
>  	 * Point the bucket head pointer at the inode being inserted.
>  	 */
> -	ASSERT(agino != 0);
>  	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
>  	offset = offsetof(xfs_agi_t, agi_unlinked) +
>  		(sizeof(xfs_agino_t) * bucket_index);
>  	xfs_trans_log_buf(tp, agibp, offset,
>  			  (offset + sizeof(xfs_agino_t) - 1));
> -	return 0;
> +	pag->pagi_unlinked_count++;
> +out:
> +	xfs_perag_put(pag);
> +	return error;
>  }
>  
>  /*
> @@ -2145,81 +2205,72 @@ xfs_iunlink_remove(
>  	xfs_trans_t	*tp,
>  	xfs_inode_t	*ip)
>  {
> -	xfs_ino_t	next_ino;
> -	xfs_mount_t	*mp;
> -	xfs_agi_t	*agi;
> -	xfs_dinode_t	*dip;
> -	xfs_buf_t	*agibp;
> -	xfs_buf_t	*ibp;
> +	struct xfs_mount *mp = tp->t_mountp;
> +	struct xfs_perag *pag;
> +	struct xfs_agi	*agi;
> +	struct xfs_buf	*agibp;
>  	xfs_agnumber_t	agno;
>  	xfs_agino_t	agino;
> +	xfs_agino_t	old_agino;
>  	xfs_agino_t	next_agino;
> -	xfs_buf_t	*last_ibp;
> -	xfs_dinode_t	*last_dip = NULL;
> +	struct list_head *unlinked_list;
>  	short		bucket_index;
> -	int		offset, last_offset = 0;
>  	int		error;
>  
> -	mp = tp->t_mountp;
>  	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> +	if (!xfs_verify_agino(mp, agno, agino))
> +		return -EFSCORRUPTED;
> +
> +	pag = xfs_perag_get(mp, agno);
> +        bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
> +	unlinked_list = &pag->pagi_unlinked_list[bucket_index];
>  
>  	/*
> -	 * Get the agi buffer first.  It ensures lock ordering
> -	 * on the list.
> +	 * Get the agi buffer first.  It ensures lock ordering on the list.
>  	 */
>  	error = xfs_read_agi(mp, tp, agno, &agibp);
>  	if (error)
>  		return error;
> -
>  	agi = XFS_BUF_TO_AGI(agibp);
>  
> -	/*
> -	 * Get the index into the agi hash table for the
> -	 * list this inode will go on.
> -	 */
> -	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> -	if (!xfs_verify_agino(mp, agno, agino))
> -		return -EFSCORRUPTED;
> -	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
> -	if (!xfs_verify_agino(mp, agno,
> -			be32_to_cpu(agi->agi_unlinked[bucket_index]))) {
> +	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> +	if (!xfs_verify_agino(mp, agno, next_agino)) {
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  				agi, sizeof(*agi));
>  		return -EFSCORRUPTED;
>  	}
>  
> -	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
> +	mutex_lock(&pag->pagi_unlink_lock);
> +	if (unlinked_list->next == &ip->i_unlinked_list) {
> +		int	offset;
> +
> +		ASSERT(next_agino == agino);
>  		/*
> -		 * We're at the head of the list.  Get the inode's on-disk
> -		 * buffer to see if there is anyone after us on the list.
> -		 * Only modify our next pointer if it is not already NULLAGINO.
> -		 * This saves us the overhead of dealing with the buffer when
> -		 * there is no need to change it.
> +		 * We're at the head of the list. Check if there is anyone
> +		 * after us on the list, and if so modify the on disk pointers
> +		 * to remove us from the list.
>  		 */
> -		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
> -				       0, 0);
> -		if (error) {
> -			xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
> -				__func__, error);
> -			return error;
> -		}
> -		next_agino = be32_to_cpu(dip->di_next_unlinked);
> -		ASSERT(next_agino != 0);
> -		if (next_agino != NULLAGINO) {
> -			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
> -			offset = ip->i_imap.im_boffset +
> -				offsetof(xfs_dinode_t, di_next_unlinked);
> -
> -			/* need to recalc the inode CRC if appropriate */
> -			xfs_dinode_calc_crc(mp, dip);
> -
> -			xfs_trans_inode_buf(tp, ibp);
> -			xfs_trans_log_buf(tp, ibp, offset,
> -					  (offset + sizeof(xfs_agino_t) - 1));
> -			xfs_inobp_check(mp, ibp);
> -		} else {
> -			xfs_trans_brelse(tp, ibp);
> +		next_agino = NULLAGINO;
> +		list_del_init(&ip->i_unlinked_list);
> +		if (!list_empty(unlinked_list)) {
> +			struct xfs_inode *nip;
> +
> +			/*
> +			 * If there's more entries on the list, clear the on-disk
> +			 * unlinked list pointer in the inode, then get the
> +			 * pointer to the new list head.
> +			 */
> +			error = xfs_iunlink_mod(tp, ip, NULLAGINO, &old_agino);
> +			if (error)
> +				goto out_unlock;
> +
> +			nip = list_first_entry(unlinked_list, struct xfs_inode,
> +						i_unlinked_list);
> +			next_agino = XFS_INO_TO_AGINO(mp, nip->i_ino);
> +			ASSERT(old_agino == next_agino);
>  		}
> +
>  		/*
>  		 * Point the bucket head pointer at the next inode.
>  		 */
> @@ -2230,92 +2281,31 @@ xfs_iunlink_remove(
>  			(sizeof(xfs_agino_t) * bucket_index);
>  		xfs_trans_log_buf(tp, agibp, offset,
>  				  (offset + sizeof(xfs_agino_t) - 1));
> -	} else {
> -		/*
> -		 * We need to search the list for the inode being freed.
> -		 */
> -		next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> -		last_ibp = NULL;
> -		while (next_agino != agino) {
> -			struct xfs_imap	imap;
>  
> -			if (last_ibp)
> -				xfs_trans_brelse(tp, last_ibp);
>  
> -			imap.im_blkno = 0;
> -			next_ino = XFS_AGINO_TO_INO(mp, agno, next_agino);
> -
> -			error = xfs_imap(mp, tp, next_ino, &imap, 0);
> -			if (error) {
> -				xfs_warn(mp,
> -	"%s: xfs_imap returned error %d.",
> -					 __func__, error);
> -				return error;
> -			}
> -
> -			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
> -					       &last_ibp, 0, 0);
> -			if (error) {
> -				xfs_warn(mp,
> -	"%s: xfs_imap_to_bp returned error %d.",
> -					__func__, error);
> -				return error;
> -			}
> -
> -			last_offset = imap.im_boffset;
> -			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
> -			if (!xfs_verify_agino(mp, agno, next_agino)) {
> -				XFS_CORRUPTION_ERROR(__func__,
> -						XFS_ERRLEVEL_LOW, mp,
> -						last_dip, sizeof(*last_dip));
> -				return -EFSCORRUPTED;
> -			}
> -		}
> -
> -		/*
> -		 * Now last_ibp points to the buffer previous to us on the
> -		 * unlinked list.  Pull us from the list.
> -		 */
> -		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
> -				       0, 0);
> -		if (error) {
> -			xfs_warn(mp, "%s: xfs_imap_to_bp(2) returned error %d.",
> -				__func__, error);
> -			return error;
> -		}
> -		next_agino = be32_to_cpu(dip->di_next_unlinked);
> -		ASSERT(next_agino != 0);
> -		ASSERT(next_agino != agino);
> -		if (next_agino != NULLAGINO) {
> -			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
> -			offset = ip->i_imap.im_boffset +
> -				offsetof(xfs_dinode_t, di_next_unlinked);
> -
> -			/* need to recalc the inode CRC if appropriate */
> -			xfs_dinode_calc_crc(mp, dip);
> -
> -			xfs_trans_inode_buf(tp, ibp);
> -			xfs_trans_log_buf(tp, ibp, offset,
> -					  (offset + sizeof(xfs_agino_t) - 1));
> -			xfs_inobp_check(mp, ibp);
> -		} else {
> -			xfs_trans_brelse(tp, ibp);
> -		}
> +	} else {
>  		/*
> -		 * Point the previous inode on the list to the next inode.
> +		 * Get the previous inode in the list, point it at the next
> +		 * one in the list.
>  		 */
> -		last_dip->di_next_unlinked = cpu_to_be32(next_agino);
> -		ASSERT(next_agino != 0);
> -		offset = last_offset + offsetof(xfs_dinode_t, di_next_unlinked);
> +		struct xfs_inode *lip = list_entry(ip->i_unlinked_list.prev,
> +					struct xfs_inode, i_unlinked_list);
>  
> -		/* need to recalc the inode CRC if appropriate */
> -		xfs_dinode_calc_crc(mp, last_dip);
> +		list_del_init(&ip->i_unlinked_list);
> +		error = xfs_iunlink_mod(tp, ip, NULLAGINO, &next_agino);
> +		if (error)
> +			goto out_unlock;
> +
> +		error = xfs_iunlink_mod(tp, lip, next_agino, &old_agino);
> +		if (error)
> +			goto out_unlock;
> +		ASSERT(old_agino == agino);
>  
> -		xfs_trans_inode_buf(tp, last_ibp);
> -		xfs_trans_log_buf(tp, last_ibp, offset,
> -				  (offset + sizeof(xfs_agino_t) - 1));
> -		xfs_inobp_check(mp, last_ibp);
>  	}
> +	pag->pagi_unlinked_count--;
> +out_unlock:
> +	mutex_unlock(&pag->pagi_unlink_lock);
> +	xfs_perag_put(pag);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e95e30a94243..d00c6e2b806b 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -47,6 +47,7 @@ typedef struct xfs_inode {
>  	atomic_t		i_pincount;	/* inode pin count */
>  	spinlock_t		i_flags_lock;	/* inode i_flags lock */
>  	/* Miscellaneous state. */
> +	struct list_head	i_unlinked_list;
>  	unsigned long		i_flags;	/* see defined flags below */
>  	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
>  
> @@ -55,6 +56,7 @@ typedef struct xfs_inode {
>  	xfs_extnum_t		i_cnextents;	/* # of extents in cow fork */
>  	unsigned int		i_cformat;	/* format of cow fork */
>  
> +
>  	/* VFS inode */
>  	struct inode		i_vnode;	/* embedded VFS inode */
>  } xfs_inode_t;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index aa953d2018dd..591e52e93236 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -185,6 +185,7 @@ xfs_initialize_perag(
>  	xfs_agnumber_t	first_initialised = NULLAGNUMBER;
>  	xfs_perag_t	*pag;
>  	int		error = -ENOMEM;
> +	int		i;
>  
>  	/*
>  	 * Walk the current per-ag tree so we don't try to initialise AGs
> @@ -230,6 +231,12 @@ xfs_initialize_perag(
>  		/* first new pag is fully initialized */
>  		if (first_initialised == NULLAGNUMBER)
>  			first_initialised = index;
> +
> +		/* in-core inode unlinked lists */
> +		mutex_init(&pag->pagi_unlink_lock);
> +		for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
> +			INIT_LIST_HEAD(&pag->pagi_unlinked_list[i]);
> +
>  	}
>  
>  	index = xfs_set_inode_alloc(mp, agcount);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 34f2cf96ec27..9c4e9c9ceb94 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -402,6 +402,11 @@ typedef struct xfs_perag {
>  
>  	/* reference count */
>  	uint8_t			pagf_refcount_level;
> +
> +	/* inode unlinked lists */
> +	struct mutex		pagi_unlink_lock;
> +	struct list_head	pagi_unlinked_list[XFS_AGI_UNLINKED_BUCKETS];
> +	uint32_t		pagi_unlinked_count;
>  } xfs_perag_t;
>  
>  static inline struct xfs_ag_resv *

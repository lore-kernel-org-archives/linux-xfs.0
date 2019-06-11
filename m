Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388333AbfFKPIy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Jun 2019 11:08:54 -0400
Date: Tue, 11 Jun 2019 11:08:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 10/10] xfs: refactor INUMBERS to use iwalk functions
Message-ID: <20190611150851.GC10942@bfoster>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968503328.1657646.15035810252397604734.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155968503328.1657646.15035810252397604734.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 02:50:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we have generic functions to walk inode records, refactor the
> INUMBERS implementation to use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c   |   20 ++++--
>  fs/xfs/xfs_ioctl.h   |    2 +
>  fs/xfs/xfs_ioctl32.c |   35 ++++------
>  fs/xfs/xfs_itable.c  |  168 ++++++++++++++++++++------------------------------
>  fs/xfs/xfs_itable.h  |   22 +------
>  fs/xfs/xfs_iwalk.c   |  161 ++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_iwalk.h   |   12 ++++

It looks like there's a decent amount of xfs_iwalk code changes in this
patch. That should probably be a separate patch, at minimum to have a
separate changelog to document the changes/updates required for
inumbers.

>  7 files changed, 262 insertions(+), 158 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 06abe5c9c0ee..bade54d6ac64 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -259,121 +259,85 @@ xfs_bulkstat(
>  	return error;
>  }
>  
> -int
> -xfs_inumbers_fmt(
> -	void			__user *ubuffer, /* buffer to write to */
> -	const struct xfs_inogrp	*buffer,	/* buffer to read from */
> -	long			count,		/* # of elements to read */
> -	long			*written)	/* # of bytes written */
> +struct xfs_inumbers_chunk {
> +	inumbers_fmt_pf		formatter;
> +	struct xfs_ibulk	*breq;
> +};
> +
> +/*
> + * INUMBERS
> + * ========
> + * This is how we export inode btree records to userspace, so that XFS tools
> + * can figure out where inodes are allocated.
> + */
> +
> +/*
> + * Format the inode group structure and report it somewhere.
> + *
> + * Similar to xfs_bulkstat_one_int, lastino is the inode cursor as we walk
> + * through the filesystem so we move it forward unless there was a runtime
> + * error.  If the formatter tells us the buffer is now full we also move the
> + * cursor forward and abort the walk.
> + */
> +STATIC int
> +xfs_inumbers_walk(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	const struct xfs_inobt_rec_incore *irec,
> +	void			*data)
>  {
> -	if (copy_to_user(ubuffer, buffer, count * sizeof(*buffer)))
> -		return -EFAULT;
> -	*written = count * sizeof(*buffer);
> -	return 0;
> +	struct xfs_inogrp	inogrp = {
> +		.xi_startino	= XFS_AGINO_TO_INO(mp, agno, irec->ir_startino),
> +		.xi_alloccount	= irec->ir_count - irec->ir_freecount,
> +		.xi_allocmask	= ~irec->ir_free,
> +	};

Not related to this patch, but I'm wondering if we should be using
xfs_inobt_irec_to_allocmask() here to mask off holes from the resulting
allocation bitmap. Eh, I guess it's misleading either way..

> +	struct xfs_inumbers_chunk *ic = data;
> +	xfs_agino_t		agino;
> +	int			error;
> +
> +	error = ic->formatter(ic->breq, &inogrp);
> +	if (error && error != XFS_IBULK_BUFFER_FULL)
> +		return error;
> +	if (error == XFS_IBULK_BUFFER_FULL)
> +		error = XFS_INOBT_WALK_ABORT;
> +
> +	agino = irec->ir_startino + XFS_INODES_PER_CHUNK;
> +	ic->breq->startino = XFS_AGINO_TO_INO(mp, agno, agino);
> +	return error;
>  }
>  
...
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index c4a9c4c246b7..3a35d1cf7e14 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
...
> @@ -286,7 +298,7 @@ xfs_iwalk_ag_start(
>  	 * have to deal with tearing down the cursor to walk the records.
>  	 */
>  	error = xfs_iwalk_grab_ichunk(*curpp, agino, &icount,
> -			&iwag->recs[iwag->nr_recs]);
> +			&iwag->recs[iwag->nr_recs], trim);

Hmm, it looks like we could lift the lookup from xfs_iwalk_grab_ichunk()
up into xfs_iwalk_ag_start() and avoid needing to pass trim down
multiple levels. In fact, if we're not trimming the record we don't need
to grab the record at all in this path. We could do the lookup (setting
has_more) then bounce right up to the core walker algorithm, right? If
so, that seems a bit cleaner in terms of only using special cased code
when it's actually necessary.

>  	if (error)
>  		return error;
>  	if (icount)
...
> @@ -561,3 +574,135 @@ xfs_iwalk_threaded(
...
> +/*
> + * Walk all inode btree records in a single AG, from @iwag->startino to the end
> + * of the AG.
> + */
> +STATIC int
> +xfs_inobt_walk_ag(
> +	struct xfs_iwalk_ag		*iwag)
> +{
> +	struct xfs_mount		*mp = iwag->mp;
> +	struct xfs_trans		*tp = iwag->tp;
> +	struct xfs_buf			*agi_bp = NULL;
> +	struct xfs_btree_cur		*cur = NULL;
> +	xfs_agnumber_t			agno;
> +	xfs_agino_t			agino;
> +	int				has_more;
> +	int				error = 0;
> +
> +	/* Set up our cursor at the right place in the inode btree. */
> +	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
> +	agino = XFS_INO_TO_AGINO(mp, iwag->startino);
> +	error = xfs_iwalk_ag_start(iwag, agno, agino, &cur, &agi_bp, &has_more,
> +			false);
> +
> +	while (!error && has_more && !xfs_pwork_want_abort(&iwag->pwork)) {
> +		struct xfs_inobt_rec_incore	*irec;
> +
> +		cond_resched();
> +
> +		/* Fetch the inobt record. */
> +		irec = &iwag->recs[iwag->nr_recs];
> +		error = xfs_inobt_get_rec(cur, irec, &has_more);
> +		if (error || !has_more)
> +			break;
> +
> +		/*
> +		 * If there's space in the buffer for more records, increment
> +		 * the btree cursor and grab more.
> +		 */
> +		if (++iwag->nr_recs < iwag->sz_recs) {
> +			error = xfs_btree_increment(cur, 0, &has_more);
> +			if (error || !has_more)
> +				break;
> +			continue;
> +		}
> +
> +		/*
> +		 * Otherwise, we need to save cursor state and run the callback
> +		 * function on the cached records.  The run_callbacks function
> +		 * is supposed to return a cursor pointing to the record where
> +		 * we would be if we had been able to increment like above.
> +		 */
> +		error = xfs_iwalk_run_callbacks(iwag, xfs_inobt_walk_ag_recs,
> +				agno, &cur, &agi_bp, &has_more);
> +	}
> +
> +	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
> +
> +	/* Walk any records left behind in the cache. */
> +	if (iwag->nr_recs == 0 || error || xfs_pwork_want_abort(&iwag->pwork))
> +		return error;
> +
> +	return xfs_inobt_walk_ag_recs(iwag);
> +}

Similar comments apply here as for the previous xfs_iwalk_ag() patch.
Though looking at it, the only differences here are the lack of free
inode check, readahead and the callback function (particularly once you
consider the partial completion refactoring we discussed earlier). I
think this could all be generalized with a single flag such that there's
no need for separate xfs_[inobt|iwalk]_ag() functions.

Hmmm.. perhaps we could use a flag or separate function pointers in
struct xfs_iwalk_ag to accomplish the same thing all the way up through
the record walker functions. IOW, xfs_iwalk_ag_recs() looks like it
could call either callback based on which is defined in the
xfs_iwalk_ag.

This could all be done as a separate patch of course, if that's easier.

> +
> +/*
> + * Walk all inode btree records in the filesystem starting from @startino.  The
> + * @inobt_walk_fn will be called for each btree record, being passed the incore
> + * record and @data.  @max_prefetch controls how many inobt records we try to
> + * cache ahead of time.
> + */
> +int
> +xfs_inobt_walk(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_ino_t		startino,
> +	xfs_inobt_walk_fn	inobt_walk_fn,
> +	unsigned int		max_prefetch,
> +	void			*data)
> +{
> +	struct xfs_iwalk_ag	iwag = {
> +		.mp		= mp,
> +		.tp		= tp,
> +		.inobt_walk_fn	= inobt_walk_fn,
> +		.data		= data,
> +		.startino	= startino,
> +		.pwork		= XFS_PWORK_SINGLE_THREADED,
> +	};
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
> +	int			error;
> +
> +	ASSERT(agno < mp->m_sb.sb_agcount);
> +
> +	xfs_iwalk_set_prefetch(&iwag, max_prefetch * XFS_INODES_PER_CHUNK);

A brief comment above this line would be helpful. Something like:

	/* translate inumbers record count to inode count */

Brian

> +	error = xfs_iwalk_alloc(&iwag);
> +	if (error)
> +		return error;
> +
> +	for (; agno < mp->m_sb.sb_agcount; agno++) {
> +		error = xfs_inobt_walk_ag(&iwag);
> +		if (error)
> +			break;
> +		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
> +	}
> +
> +	xfs_iwalk_free(&iwag);
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
> index 76d8f87a39ef..20bee93d4676 100644
> --- a/fs/xfs/xfs_iwalk.h
> +++ b/fs/xfs/xfs_iwalk.h
> @@ -18,4 +18,16 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
>  		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, bool poll,
>  		void *data);
>  
> +/* Walk all inode btree records in the filesystem starting from @startino. */
> +typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
> +				 xfs_agnumber_t agno,
> +				 const struct xfs_inobt_rec_incore *irec,
> +				 void *data);
> +/* Return value (for xfs_inobt_walk_fn) that aborts the walk immediately. */
> +#define XFS_INOBT_WALK_ABORT	(XFS_IWALK_ABORT)
> +
> +int xfs_inobt_walk(struct xfs_mount *mp, struct xfs_trans *tp,
> +		xfs_ino_t startino, xfs_inobt_walk_fn inobt_walk_fn,
> +		unsigned int max_prefetch, void *data);
> +
>  #endif /* __XFS_IWALK_H__ */
> 

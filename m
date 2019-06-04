Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56321 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726637AbfFDHlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 03:41:49 -0400
Date: Tue, 4 Jun 2019 17:41:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/11] xfs: create simplified inode walk function
Message-ID: <20190604074142.GV29573@dread.disaster.area>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
 <155916878781.757870.16686660432312494436.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155916878781.757870.16686660432312494436.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 29, 2019 at 03:26:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Description? :)

> +/*
> + * Walking All the Inodes in the Filesystem
> + * ========================================
> + * Starting at some @startino, call a walk function on every allocated inode in
> + * the system.  The walk function is called with the relevant inode number and
> + * a pointer to caller-provided data.  The walk function can return the usual
> + * negative error code, 0, or XFS_IWALK_ABORT to stop the iteration.  This
> + * return value is returned to the caller.

The walker iterates inodes in what order? What does it do with
inodes before @startino?

> + * Internally, we allow the walk function to do anything, which means that we
> + * cannot maintain the inobt cursor or our lock on the AGI buffer.  We
> + * therefore build up a batch of inobt records in kernel memory and only call
> + * the walk function when our memory buffer is full.
> + */

"It is the responsibility of the walk function to ensure it accesses
allocated inodes, as the inobt records may be stale by the time they are
acted upon."

> +struct xfs_iwalk_ag {
> +	struct xfs_mount		*mp;
> +	struct xfs_trans		*tp;
> +
> +	/* Where do we start the traversal? */
> +	xfs_ino_t			startino;
> +
> +	/* Array of inobt records we cache. */
> +	struct xfs_inobt_rec_incore	*recs;
> +	unsigned int			sz_recs;
> +	unsigned int			nr_recs;

sz is the size of the allocated array, nr is the number of entries
used?

> +	/* Inode walk function and data pointer. */
> +	xfs_iwalk_fn			iwalk_fn;
> +	void				*data;
> +};
> +
> +/* Allocate memory for a walk. */
> +STATIC int
> +xfs_iwalk_allocbuf(
> +	struct xfs_iwalk_ag	*iwag)
> +{
> +	size_t			size;
> +
> +	ASSERT(iwag->recs == NULL);
> +	iwag->nr_recs = 0;
> +
> +	/* Allocate a prefetch buffer for inobt records. */
> +	size = iwag->sz_recs * sizeof(struct xfs_inobt_rec_incore);
> +	iwag->recs = kmem_alloc(size, KM_SLEEP);
> +	if (iwag->recs == NULL)
> +		return -ENOMEM;

KM_SLEEP will never fail. You mean to use KM_MAYFAIL here?

> +
> +	return 0;
> +}
> +
> +/* Free memory we allocated for a walk. */
> +STATIC void
> +xfs_iwalk_freebuf(
> +	struct xfs_iwalk_ag	*iwag)
> +{
> +	ASSERT(iwag->recs != NULL);
> +	kmem_free(iwag->recs);
> +}

No need for the assert here - kmem_free() handles null pointers just
fine.

> +/* For each inuse inode in each cached inobt record, call our function. */
> +STATIC int
> +xfs_iwalk_ag_recs(
> +	struct xfs_iwalk_ag		*iwag)
> +{
> +	struct xfs_mount		*mp = iwag->mp;
> +	struct xfs_trans		*tp = iwag->tp;
> +	struct xfs_inobt_rec_incore	*irec;
> +	xfs_ino_t			ino;
> +	unsigned int			i, j;
> +	xfs_agnumber_t			agno;
> +	int				error;
> +
> +	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
> +	for (i = 0, irec = iwag->recs; i < iwag->nr_recs; i++, irec++) {

I kinda prefer single iterator loops for array walking like this:

	for (i = 0; i < iwag->nr_recs; i++) {
		irec = &iwag->recs[i];

It's much easier to read and understand what is going on...

> +		trace_xfs_iwalk_ag_rec(mp, agno, irec->ir_startino,
> +				irec->ir_free);

Could just pass irec to the trace function and extract startino/free
within the tracepoint macro....

> +		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
> +			/* Skip if this inode is free */
> +			if (XFS_INOBT_MASK(j) & irec->ir_free)
> +				continue;
> +
> +			/* Otherwise call our function. */
> +			ino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino + j);
> +			error = iwag->iwalk_fn(mp, tp, ino, iwag->data);
> +			if (error)
> +				return error;
> +		}
> +	}
> +
> +	iwag->nr_recs = 0;

Why is this zeroed here?

> +	return 0;
> +}
> +
> +/* Read AGI and create inobt cursor. */
> +static inline int
> +xfs_iwalk_inobt_cur(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	struct xfs_btree_cur	**curpp,
> +	struct xfs_buf		**agi_bpp)
> +{
> +	struct xfs_btree_cur	*cur;
> +	int			error;
> +
> +	ASSERT(*agi_bpp == NULL);
> +
> +	error = xfs_ialloc_read_agi(mp, tp, agno, agi_bpp);
> +	if (error)
> +		return error;
> +
> +	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, agno, XFS_BTNUM_INO);
> +	if (!cur)
> +		return -ENOMEM;
> +	*curpp = cur;
> +	return 0;
> +}

This is a common pattern. Used in xfs_imap_lookup(), xfs_bulkstat(),
xfs_inumbers and xfs_inobt_count_blocks. Perhaps should be a common
inobt function?

> +
> +/* Delete cursor and let go of AGI. */
> +static inline void
> +xfs_iwalk_del_inobt(
> +	struct xfs_trans	*tp,
> +	struct xfs_btree_cur	**curpp,
> +	struct xfs_buf		**agi_bpp,
> +	int			error)
> +{
> +	if (*curpp) {
> +		xfs_btree_del_cursor(*curpp, error);
> +		*curpp = NULL;
> +	}
> +	if (*agi_bpp) {
> +		xfs_trans_brelse(tp, *agi_bpp);
> +		*agi_bpp = NULL;
> +	}
> +}
> +
> +/*
> + * Set ourselves up for walking inobt records starting from a given point in
> + * the filesystem.
> + *
> + * If caller passed in a nonzero start inode number, load the record from the
> + * inobt and make the record look like all the inodes before agino are free so
> + * that we skip them, and then move the cursor to the next inobt record.  This
> + * is how we support starting an iwalk in the middle of an inode chunk.
> + *
> + * If the caller passed in a start number of zero, move the cursor to the first
> + * inobt record.
> + *
> + * The caller is responsible for cleaning up the cursor and buffer pointer
> + * regardless of the error status.
> + */
> +STATIC int
> +xfs_iwalk_ag_start(
> +	struct xfs_iwalk_ag	*iwag,
> +	xfs_agnumber_t		agno,
> +	xfs_agino_t		agino,
> +	struct xfs_btree_cur	**curpp,
> +	struct xfs_buf		**agi_bpp,
> +	int			*has_more)
> +{
> +	struct xfs_mount	*mp = iwag->mp;
> +	struct xfs_trans	*tp = iwag->tp;
> +	int			icount;
> +	int			error;
> +
> +	/* Set up a fresh cursor and empty the inobt cache. */
> +	iwag->nr_recs = 0;
> +	error = xfs_iwalk_inobt_cur(mp, tp, agno, curpp, agi_bpp);
> +	if (error)
> +		return error;
> +
> +	/* Starting at the beginning of the AG?  That's easy! */
> +	if (agino == 0)
> +		return xfs_inobt_lookup(*curpp, 0, XFS_LOOKUP_GE, has_more);
> +
> +	/*
> +	 * Otherwise, we have to grab the inobt record where we left off, stuff
> +	 * the record into our cache, and then see if there are more records.
> +	 * We require a lookup cache of at least two elements so that we don't
> +	 * have to deal with tearing down the cursor to walk the records.
> +	 */
> +	error = xfs_bulkstat_grab_ichunk(*curpp, agino - 1, &icount,
> +			&iwag->recs[iwag->nr_recs]);
> +	if (error)
> +		return error;
> +	if (icount)
> +		iwag->nr_recs++;
> +
> +	ASSERT(iwag->nr_recs < iwag->sz_recs);

Why this code does what it does with nr_recs is a bit of a mystery
to me...

> +	return xfs_btree_increment(*curpp, 0, has_more);
> +}
> +
> +typedef int (*xfs_iwalk_ag_recs_fn)(struct xfs_iwalk_ag *iwag);
> +
> +/*
> + * Acknowledge that we added an inobt record to the cache.  Flush the inobt
> + * record cache if the buffer is full, and position the cursor wherever it
> + * needs to be so that we can keep going.
> + */
> +STATIC int
> +xfs_iwalk_ag_increment(
> +	struct xfs_iwalk_ag		*iwag,
> +	xfs_iwalk_ag_recs_fn		walk_ag_recs_fn,
> +	xfs_agnumber_t			agno,
> +	struct xfs_btree_cur		**curpp,
> +	struct xfs_buf			**agi_bpp,
> +	int				*has_more)
> +{
> +	struct xfs_mount		*mp = iwag->mp;
> +	struct xfs_trans		*tp = iwag->tp;
> +	struct xfs_inobt_rec_incore	*irec;
> +	xfs_agino_t			restart;
> +	int				error;
> +
> +	iwag->nr_recs++;
> +
> +	/* If there's space, just increment and look for more records. */
> +	if (iwag->nr_recs < iwag->sz_recs)
> +		return xfs_btree_increment(*curpp, 0, has_more);

Incrementing before explaining why we're incrementing seems a bit
fack-to-bront....

> +	/*
> +	 * Otherwise the record cache is full; delete the cursor and walk the
> +	 * records...
> +	 */
> +	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
> +	irec = &iwag->recs[iwag->nr_recs - 1];
> +	restart = irec->ir_startino + XFS_INODES_PER_CHUNK - 1;
> +
> +	error = walk_ag_recs_fn(iwag);
> +	if (error)
> +		return error;

Urk, so an "increment" function actually run all the object callbacks?
But only if it fails to increment?

> +
> +	/* ...and recreate cursor where we left off. */
> +	error = xfs_iwalk_inobt_cur(mp, tp, agno, curpp, agi_bpp);
> +	if (error)
> +		return error;
> +
> +	return xfs_inobt_lookup(*curpp, restart, XFS_LOOKUP_GE, has_more);

And then it goes an increments anyway?

That's all a bit .... non-obvious. Especially as it has a single
caller - this should really be something like
xfs_iwalk_run_callbacks(). Bit more context below...

> +}
> +
> +/* Walk all inodes in a single AG, from @iwag->startino to the end of the AG. */
> +STATIC int
> +xfs_iwalk_ag(
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
> +	error = xfs_iwalk_ag_start(iwag, agno, agino, &cur, &agi_bp, &has_more);
> +	if (error)
> +		goto out_cur;
> +
> +	while (has_more) {
> +		struct xfs_inobt_rec_incore	*irec;
> +
> +		/* Fetch the inobt record. */
> +		irec = &iwag->recs[iwag->nr_recs];
> +		error = xfs_inobt_get_rec(cur, irec, &has_more);
> +		if (error)
> +			goto out_cur;
> +		if (!has_more)
> +			break;
> +
> +		/* No allocated inodes in this chunk; skip it. */
> +		if (irec->ir_freecount == irec->ir_count) {
> +			error = xfs_btree_increment(cur, 0, &has_more);
> +			goto next_loop;
> +		}
> +
> +		/*
> +		 * Start readahead for this inode chunk in anticipation of
> +		 * walking the inodes.
> +		 */
> +		xfs_bulkstat_ichunk_ra(mp, agno, irec);
> +
> +		/*
> +		 * Add this inobt record to our cache, flush the cache if
> +		 * needed, and move on to the next record.
> +		 */
> +		error = xfs_iwalk_ag_increment(iwag, xfs_iwalk_ag_recs, agno,
> +				&cur, &agi_bp, &has_more);

Ok, so given this loop already has an increment case in it, it seems
like it would be better to pull some of this function into the loop
somewhat like:

	while (has_more) {
		struct xfs_inobt_rec_incore	*irec;

		cond_resched();

		/* Fetch the inobt record. */
		irec = &iwag->recs[iwag->nr_recs];
		error = xfs_inobt_get_rec(cur, irec, &has_more);
		if (error || !has_more)
			break;

		/* No allocated inodes in this chunk; skip it. */
		if (irec->ir_freecount == irec->ir_count) {
			error = xfs_btree_increment(cur, 0, &has_more);
			if (error)
				break;
			continue;
		}

		/*
		 * Start readahead for this inode chunk in anticipation of
		 * walking the inodes.
		 */
		xfs_bulkstat_ichunk_ra(mp, agno, irec);

		/* If there's space in the buffer, just grab more records. */
		if (++iwag->nr_recs < iwag->sz_recs)
			error = xfs_btree_increment(cur, 0, &has_more);
			if (error)
				break;
			continue;
		}

		error = xfs_iwalk_run_callbacks(iwag, ...);
	}

	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
	if (!iwag->nr_recs || error)
		return error;
	return xfs_iwalk_ag_recs(iwag);
}


> +	/* Walk any records left behind in the cache. */
> +	if (iwag->nr_recs) {
> +		xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
> +		return xfs_iwalk_ag_recs(iwag);
> +	}
> +
> +out_cur:
> +	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
> +	return error;
> +}
> +
> +/*
> + * Given the number of inodes to prefetch, set the number of inobt records that
> + * we cache in memory, which controls the number of inodes we try to read
> + * ahead.
> + *
> + * If no max prefetch was given, default to one page's worth of inobt records;
> + * this should be plenty of inodes to read ahead.

That's a lot of inodes on a 64k page size machine. I think it would
be better capped at number that doesn't change with processor
architecture...

> + */
> +static inline void
> +xfs_iwalk_set_prefetch(
> +	struct xfs_iwalk_ag	*iwag,
> +	unsigned int		max_prefetch)
> +{
> +	if (max_prefetch)
> +		iwag->sz_recs = round_up(max_prefetch, XFS_INODES_PER_CHUNK) /
> +					XFS_INODES_PER_CHUNK;
> +	else
> +		iwag->sz_recs = PAGE_SIZE / sizeof(struct xfs_inobt_rec_incore);
> +
> +	/*
> +	 * Allocate enough space to prefetch at least two records so that we
> +	 * can cache both the inobt record where the iwalk started and the next
> +	 * record.  This simplifies the AG inode walk loop setup code.
> +	 */
> +	if (iwag->sz_recs < 2)
> +		iwag->sz_recs = 2;

	iwag->sz_recs = max(iwag->sz_recs, 2);

....
> +	xfs_iwalk_set_prefetch(&iwag, max_prefetch);
> +	error = xfs_iwalk_allocbuf(&iwag);
....
> +	xfs_iwalk_freebuf(&iwag);

I'd drop the "buf" from the names of those two functions...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

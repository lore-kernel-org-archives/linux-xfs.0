Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50382 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFMSGb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:06:31 -0400
Date: Thu, 13 Jun 2019 11:06:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/14] xfs: create simplified inode walk function
Message-ID: <20190613180609.GF3773859@magnolia>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
 <156032206425.3774243.10420463221575428170.stgit@magnolia>
 <20190613162703.GB21773@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613162703.GB21773@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 12:27:06PM -0400, Brian Foster wrote:
> On Tue, Jun 11, 2019 at 11:47:44PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a new iterator function to simplify walking inodes in an XFS
> > filesystem.  This new iterator will replace the existing open-coded
> > walking that goes on in various places.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/Makefile                  |    1 
> >  fs/xfs/libxfs/xfs_ialloc_btree.c |   36 +++
> >  fs/xfs/libxfs/xfs_ialloc_btree.h |    3 
> >  fs/xfs/xfs_itable.c              |    5 
> >  fs/xfs/xfs_itable.h              |    8 +
> >  fs/xfs/xfs_iwalk.c               |  418 ++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_iwalk.h               |   19 ++
> >  fs/xfs/xfs_trace.h               |   40 ++++
> >  8 files changed, 524 insertions(+), 6 deletions(-)
> >  create mode 100644 fs/xfs/xfs_iwalk.c
> >  create mode 100644 fs/xfs/xfs_iwalk.h
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> > new file mode 100644
> > index 000000000000..49289588413f
> > --- /dev/null
> > +++ b/fs/xfs/xfs_iwalk.c
> > @@ -0,0 +1,418 @@
> ...
> > +/* Allocate memory for a walk. */
> > +STATIC int
> > +xfs_iwalk_alloc(
> > +	struct xfs_iwalk_ag	*iwag)
> > +{
> > +	size_t			size;
> > +
> > +	ASSERT(iwag->recs == NULL);
> > +	iwag->nr_recs = 0;
> > +
> > +	/* Allocate a prefetch buffer for inobt records. */
> > +	size = iwag->sz_recs * sizeof(struct xfs_inobt_rec_incore);
> > +	iwag->recs = kmem_alloc(size, KM_MAYFAIL);
> > +	if (iwag->recs == NULL)
> > +		return -ENOMEM;
> > +
> > +	return 0;
> > +}
> > +
> > +/* Free memory we allocated for a walk. */
> > +STATIC void
> > +xfs_iwalk_free(
> > +	struct xfs_iwalk_ag	*iwag)
> > +{
> > +	kmem_free(iwag->recs);
> 
> It might be a good idea to ->recs = NULL here since the alloc call
> asserts for that (if any future code happens to free and realloc the
> recs buffer for whatever reason).
> 
> > +}
> > +
> ...
> > +/* Walk all inodes in a single AG, from @iwag->startino to the end of the AG. */
> > +STATIC int
> > +xfs_iwalk_ag(
> > +	struct xfs_iwalk_ag		*iwag)
> > +{
> > +	struct xfs_mount		*mp = iwag->mp;
> > +	struct xfs_trans		*tp = iwag->tp;
> > +	struct xfs_buf			*agi_bp = NULL;
> > +	struct xfs_btree_cur		*cur = NULL;
> > +	xfs_agnumber_t			agno;
> > +	xfs_agino_t			agino;
> > +	int				has_more;
> > +	int				error = 0;
> > +
> > +	/* Set up our cursor at the right place in the inode btree. */
> > +	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
> > +	agino = XFS_INO_TO_AGINO(mp, iwag->startino);
> > +	error = xfs_iwalk_ag_start(iwag, agno, agino, &cur, &agi_bp, &has_more);
> > +
> > +	while (!error && has_more) {
> > +		struct xfs_inobt_rec_incore	*irec;
> > +
> > +		cond_resched();
> > +
> > +		/* Fetch the inobt record. */
> > +		irec = &iwag->recs[iwag->nr_recs];
> > +		error = xfs_inobt_get_rec(cur, irec, &has_more);
> > +		if (error || !has_more)
> > +			break;
> > +
> > +		/* No allocated inodes in this chunk; skip it. */
> > +		if (irec->ir_freecount == irec->ir_count) {
> > +			error = xfs_btree_increment(cur, 0, &has_more);
> > +			if (error)
> > +				break;
> > +			continue;
> > +		}
> > +
> > +		/*
> > +		 * Start readahead for this inode chunk in anticipation of
> > +		 * walking the inodes.
> > +		 */
> > +		xfs_bulkstat_ichunk_ra(mp, agno, irec);
> > +
> > +		/*
> > +		 * If there's space in the buffer for more records, increment
> > +		 * the btree cursor and grab more.
> > +		 */
> > +		if (++iwag->nr_recs < iwag->sz_recs) {
> > +			error = xfs_btree_increment(cur, 0, &has_more);
> > +			if (error || !has_more)
> > +				break;
> > +			continue;
> > +		}
> > +
> > +		/*
> > +		 * Otherwise, we need to save cursor state and run the callback
> > +		 * function on the cached records.  The run_callbacks function
> > +		 * is supposed to return a cursor pointing to the record where
> > +		 * we would be if we had been able to increment like above.
> > +		 */
> > +		has_more = true;
> 
> has_more should always be true if we get here right? If so, perhaps
> better to replace this with ASSERT(has_more).
> 
> > +		error = xfs_iwalk_run_callbacks(iwag, agno, &cur, &agi_bp,
> > +				&has_more);
> > +	}
> > +
> > +	if (iwag->nr_recs == 0 || error)
> > +		goto out;
> > +
> > +	/* Walk the unprocessed records in the cache. */
> > +	error = xfs_iwalk_run_callbacks(iwag, agno, &cur, &agi_bp, &has_more);
> > +
> > +out:
> > +	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
> > +	return error;
> > +}
> > +
> > +/*
> > + * Given the number of inodes to prefetch, set the number of inobt records that
> > + * we cache in memory, which controls the number of inodes we try to read
> > + * ahead.
> > + */
> > +static inline void
> > +xfs_iwalk_set_prefetch(
> > +	struct xfs_iwalk_ag	*iwag,
> > +	unsigned int		max_prefetch)
> > +{
> > +	/*
> > +	 * Default to 4096 bytes' worth of inobt records; this should be plenty
> > +	 * of inodes to read ahead.  This number was chosen so that the cache
> > +	 * is never more than a single memory page and the amount of inode
> > +	 * readahead is limited to to 16k inodes regardless of CPU:
> > +	 *
> > +	 * 4096 bytes / 16 bytes per inobt record = 256 inobt records
> > +	 * 256 inobt records * 64 inodes per record = 16384 inodes
> > +	 * 16384 inodes * 512 bytes per inode(?) = 8MB of inode readahead
> > +	 */
> > +	iwag->sz_recs = 4096 / sizeof(struct xfs_inobt_rec_incore);
> > +
> 
> So we decided not to preserve current readahead behavior in this patch?

I sent this patch before I received your reply. :(

The current version of this patch restores the (4 * PAGE_SIZE) behavior,
and a new patch immediately afterwards replaces it with better logic.
"better" is where we allow prefetch up to 2048 inodes and use the
(admittedly sparse) amount of information gathered so far about average
inode chunk free factors to guess at how many inobt records to cache.

> > +	/*
> > +	 * If the caller gives us a desired prefetch amount, round it up to
> > +	 * an even inode chunk and cap it as defined previously.
> > +	 */
> > +	if (max_prefetch) {
> > +		unsigned int	nr;
> > +
> > +		nr = round_up(max_prefetch, XFS_INODES_PER_CHUNK) /
> > +				XFS_INODES_PER_CHUNK;
> > +		iwag->sz_recs = min_t(unsigned int, iwag->sz_recs, nr);
> 
> This is comparing the record count calculated above with max_prefetch,
> which the rounding just above suggests is in inodes. BTW, could we add a
> one line /* prefetch in inodes */ comment on the max_prefetch parameter
> line at the top of the function?

I renamed the parameter "inode_records", FWIW.
> 
> Aside from those nits the rest looks good to me.

<nod> Thanks for review!

(Oh, more replies are slowly wandering in...)

--D

> 
> Brian
> 
> > +	}
> > +
> > +	/*
> > +	 * Allocate enough space to prefetch at least two records so that we
> > +	 * can cache both the inobt record where the iwalk started and the next
> > +	 * record.  This simplifies the AG inode walk loop setup code.
> > +	 */
> > +	iwag->sz_recs = max_t(unsigned int, iwag->sz_recs, 2);
> > +}
> > +
> > +/*
> > + * Walk all inodes in the filesystem starting from @startino.  The @iwalk_fn
> > + * will be called for each allocated inode, being passed the inode's number and
> > + * @data.  @max_prefetch controls how many inobt records' worth of inodes we
> > + * try to readahead.
> > + */
> > +int
> > +xfs_iwalk(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	*tp,
> > +	xfs_ino_t		startino,
> > +	xfs_iwalk_fn		iwalk_fn,
> > +	unsigned int		max_prefetch,
> > +	void			*data)
> > +{
> > +	struct xfs_iwalk_ag	iwag = {
> > +		.mp		= mp,
> > +		.tp		= tp,
> > +		.iwalk_fn	= iwalk_fn,
> > +		.data		= data,
> > +		.startino	= startino,
> > +	};
> > +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
> > +	int			error;
> > +
> > +	ASSERT(agno < mp->m_sb.sb_agcount);
> > +
> > +	xfs_iwalk_set_prefetch(&iwag, max_prefetch);
> > +	error = xfs_iwalk_alloc(&iwag);
> > +	if (error)
> > +		return error;
> > +
> > +	for (; agno < mp->m_sb.sb_agcount; agno++) {
> > +		error = xfs_iwalk_ag(&iwag);
> > +		if (error)
> > +			break;
> > +		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
> > +	}
> > +
> > +	xfs_iwalk_free(&iwag);
> > +	return error;
> > +}
> > diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
> > new file mode 100644
> > index 000000000000..9e762e31dadc
> > --- /dev/null
> > +++ b/fs/xfs/xfs_iwalk.h
> > @@ -0,0 +1,19 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + */
> > +#ifndef __XFS_IWALK_H__
> > +#define __XFS_IWALK_H__
> > +
> > +/* Walk all inodes in the filesystem starting from @startino. */
> > +typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
> > +			    xfs_ino_t ino, void *data);
> > +/* Return values for xfs_iwalk_fn. */
> > +#define XFS_IWALK_CONTINUE	(XFS_ITER_CONTINUE)
> > +#define XFS_IWALK_ABORT		(XFS_ITER_ABORT)
> > +
> > +int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
> > +		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
> > +
> > +#endif /* __XFS_IWALK_H__ */
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 2464ea351f83..f9bb1d50bc0e 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3516,6 +3516,46 @@ DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
> >  DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
> >  DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
> >  
> > +TRACE_EVENT(xfs_iwalk_ag,
> > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> > +		 xfs_agino_t startino),
> > +	TP_ARGS(mp, agno, startino),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_agnumber_t, agno)
> > +		__field(xfs_agino_t, startino)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->agno = agno;
> > +		__entry->startino = startino;
> > +	),
> > +	TP_printk("dev %d:%d agno %d startino %u",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
> > +		  __entry->startino)
> > +)
> > +
> > +TRACE_EVENT(xfs_iwalk_ag_rec,
> > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> > +		 struct xfs_inobt_rec_incore *irec),
> > +	TP_ARGS(mp, agno, irec),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_agnumber_t, agno)
> > +		__field(xfs_agino_t, startino)
> > +		__field(uint64_t, freemask)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->agno = agno;
> > +		__entry->startino = irec->ir_startino;
> > +		__entry->freemask = irec->ir_free;
> > +	),
> > +	TP_printk("dev %d:%d agno %d startino %u freemask 0x%llx",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
> > +		  __entry->startino, __entry->freemask)
> > +)
> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > 

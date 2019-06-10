Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36440 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389373AbfFJN6W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jun 2019 09:58:22 -0400
Date: Mon, 10 Jun 2019 09:58:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/10] xfs: create simplified inode walk function
Message-ID: <20190610135816.GA6473@bfoster>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968497450.1657646.15305138327955918345.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155968497450.1657646.15305138327955918345.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 02:49:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new iterator function to simplify walking inodes in an XFS
> filesystem.  This new iterator will replace the existing open-coded
> walking that goes on in various places.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/Makefile                  |    1 
>  fs/xfs/libxfs/xfs_ialloc_btree.c |   31 +++
>  fs/xfs/libxfs/xfs_ialloc_btree.h |    3 
>  fs/xfs/xfs_itable.c              |    5 
>  fs/xfs/xfs_itable.h              |    8 +
>  fs/xfs/xfs_iwalk.c               |  400 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iwalk.h               |   18 ++
>  fs/xfs/xfs_trace.h               |   40 ++++
>  8 files changed, 502 insertions(+), 4 deletions(-)
>  create mode 100644 fs/xfs/xfs_iwalk.c
>  create mode 100644 fs/xfs/xfs_iwalk.h
> 
> 
...
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index ac4b65da4c2b..cb7eac2f51c0 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -564,6 +564,34 @@ xfs_inobt_max_size(
>  					XFS_INODES_PER_CHUNK);
>  }
>  
> +/* Read AGI and create inobt cursor. */
> +int
> +xfs_inobt_cur(
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

FYI, the xfs_inobt_count_blocks() caller doesn't initialize the pointer
according to the assert.

> +	error = xfs_ialloc_read_agi(mp, tp, agno, agi_bpp);
> +	if (error)
> +		return error;
> +
> +	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, agno, XFS_BTNUM_INO);
> +	if (!cur) {
> +		xfs_trans_brelse(tp, *agi_bpp);
> +		*agi_bpp = NULL;
> +		return -ENOMEM;
> +	}
> +	*curpp = cur;
> +	return 0;
> +}
> +
>  static int
>  xfs_inobt_count_blocks(
>  	struct xfs_mount	*mp,
...
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> new file mode 100644
> index 000000000000..3e6c06e69c75
> --- /dev/null
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -0,0 +1,400 @@
...
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
> +
> +	while (!error && has_more) {
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
> +		/* No allocated inodes in this chunk; skip it. */
> +		if (irec->ir_freecount == irec->ir_count) {
> +			error = xfs_btree_increment(cur, 0, &has_more);
> +			if (error)
> +				break;
> +			continue;
> +		}
> +
> +		/*
> +		 * Start readahead for this inode chunk in anticipation of
> +		 * walking the inodes.
> +		 */
> +		xfs_bulkstat_ichunk_ra(mp, agno, irec);
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
> +		error = xfs_iwalk_run_callbacks(iwag, xfs_iwalk_ag_recs, agno,
> +				&cur, &agi_bp, &has_more);
> +	}
> +
> +	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
> +
> +	/* Walk any records left behind in the cache. */
> +	if (iwag->nr_recs == 0 || error)
> +		return error;
> +
> +	return xfs_iwalk_ag_recs(iwag);

Hmm, I find the above pattern to process the leftover records a bit
confusing because of how it is open coded. Could we find a way to reuse
xfs_iwalk_run_callbacks() in both cases so it looks more obvious? For
example, pass a flag to indicate whether the callback helper should
recreate the cursor for continued processing. FWIW, it looks like
has_more already reflects that state in the current logic above.

> +}
> +
> +/*
> + * Given the number of inodes to prefetch, set the number of inobt records that
> + * we cache in memory, which controls the number of inodes we try to read
> + * ahead.
> + *
> + * If no max prefetch was given, default to 4096 bytes' worth of inobt records;
> + * this should be plenty of inodes to read ahead.  This number (256 inobt
> + * records) was chosen so that the cache is never more than a single memory
> + * page.
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
> +		iwag->sz_recs = 4096 / sizeof(struct xfs_inobt_rec_incore);
> +

Perhaps this should use PAGE_SIZE or a related macro?

Brian

> +	/*
> +	 * Allocate enough space to prefetch at least two records so that we
> +	 * can cache both the inobt record where the iwalk started and the next
> +	 * record.  This simplifies the AG inode walk loop setup code.
> +	 */
> +	iwag->sz_recs = max_t(unsigned int, iwag->sz_recs, 2);
> +}
> +
> +/*
> + * Walk all inodes in the filesystem starting from @startino.  The @iwalk_fn
> + * will be called for each allocated inode, being passed the inode's number and
> + * @data.  @max_prefetch controls how many inobt records' worth of inodes we
> + * try to readahead.
> + */
> +int
> +xfs_iwalk(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_ino_t		startino,
> +	xfs_iwalk_fn		iwalk_fn,
> +	unsigned int		max_prefetch,
> +	void			*data)
> +{
> +	struct xfs_iwalk_ag	iwag = {
> +		.mp		= mp,
> +		.tp		= tp,
> +		.iwalk_fn	= iwalk_fn,
> +		.data		= data,
> +		.startino	= startino,
> +	};
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
> +	int			error;
> +
> +	ASSERT(agno < mp->m_sb.sb_agcount);
> +
> +	xfs_iwalk_set_prefetch(&iwag, max_prefetch);
> +	error = xfs_iwalk_alloc(&iwag);
> +	if (error)
> +		return error;
> +
> +	for (; agno < mp->m_sb.sb_agcount; agno++) {
> +		error = xfs_iwalk_ag(&iwag);
> +		if (error)
> +			break;
> +		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
> +	}
> +
> +	xfs_iwalk_free(&iwag);
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
> new file mode 100644
> index 000000000000..45b1baabcd2d
> --- /dev/null
> +++ b/fs/xfs/xfs_iwalk.h
> @@ -0,0 +1,18 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#ifndef __XFS_IWALK_H__
> +#define __XFS_IWALK_H__
> +
> +/* Walk all inodes in the filesystem starting from @startino. */
> +typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
> +			    xfs_ino_t ino, void *data);
> +/* Return value (for xfs_iwalk_fn) that aborts the walk immediately. */
> +#define XFS_IWALK_ABORT	(1)
> +
> +int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
> +		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
> +
> +#endif /* __XFS_IWALK_H__ */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 2464ea351f83..f9bb1d50bc0e 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3516,6 +3516,46 @@ DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
>  DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
>  DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
>  
> +TRACE_EVENT(xfs_iwalk_ag,
> +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> +		 xfs_agino_t startino),
> +	TP_ARGS(mp, agno, startino),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agino_t, startino)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->agno = agno;
> +		__entry->startino = startino;
> +	),
> +	TP_printk("dev %d:%d agno %d startino %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
> +		  __entry->startino)
> +)
> +
> +TRACE_EVENT(xfs_iwalk_ag_rec,
> +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> +		 struct xfs_inobt_rec_incore *irec),
> +	TP_ARGS(mp, agno, irec),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agino_t, startino)
> +		__field(uint64_t, freemask)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->agno = agno;
> +		__entry->startino = irec->ir_startino;
> +		__entry->freemask = irec->ir_free;
> +	),
> +	TP_printk("dev %d:%d agno %d startino %u freemask 0x%llx",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
> +		  __entry->startino, __entry->freemask)
> +)
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 

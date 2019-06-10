Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55014 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390340AbfFJXMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 19:12:05 -0400
Date: Mon, 10 Jun 2019 16:11:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/10] xfs: create simplified inode walk function
Message-ID: <20190610231134.GM1871505@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968497450.1657646.15305138327955918345.stgit@magnolia>
 <20190610135816.GA6473@bfoster>
 <20190610165909.GI1871505@magnolia>
 <20190610175509.GF6473@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610175509.GF6473@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 10, 2019 at 01:55:10PM -0400, Brian Foster wrote:
> On Mon, Jun 10, 2019 at 09:59:09AM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 10, 2019 at 09:58:19AM -0400, Brian Foster wrote:
> > > On Tue, Jun 04, 2019 at 02:49:34PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Create a new iterator function to simplify walking inodes in an XFS
> > > > filesystem.  This new iterator will replace the existing open-coded
> > > > walking that goes on in various places.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/Makefile                  |    1 
> > > >  fs/xfs/libxfs/xfs_ialloc_btree.c |   31 +++
> > > >  fs/xfs/libxfs/xfs_ialloc_btree.h |    3 
> > > >  fs/xfs/xfs_itable.c              |    5 
> > > >  fs/xfs/xfs_itable.h              |    8 +
> > > >  fs/xfs/xfs_iwalk.c               |  400 ++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/xfs_iwalk.h               |   18 ++
> > > >  fs/xfs/xfs_trace.h               |   40 ++++
> > > >  8 files changed, 502 insertions(+), 4 deletions(-)
> > > >  create mode 100644 fs/xfs/xfs_iwalk.c
> > > >  create mode 100644 fs/xfs/xfs_iwalk.h
> > > > 
> > > > 
> > > ...
> > > > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > > index ac4b65da4c2b..cb7eac2f51c0 100644
> > > > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> ...
> > > > +}
> > > > +
> > > > +/*
> > > > + * Given the number of inodes to prefetch, set the number of inobt records that
> > > > + * we cache in memory, which controls the number of inodes we try to read
> > > > + * ahead.
> > > > + *
> > > > + * If no max prefetch was given, default to 4096 bytes' worth of inobt records;
> > > > + * this should be plenty of inodes to read ahead.  This number (256 inobt
> > > > + * records) was chosen so that the cache is never more than a single memory
> > > > + * page.
> > > > + */
> > > > +static inline void
> > > > +xfs_iwalk_set_prefetch(
> > > > +	struct xfs_iwalk_ag	*iwag,
> > > > +	unsigned int		max_prefetch)
> > > > +{
> > > > +	if (max_prefetch)
> > > > +		iwag->sz_recs = round_up(max_prefetch, XFS_INODES_PER_CHUNK) /
> > > > +					XFS_INODES_PER_CHUNK;
> > > > +	else
> > > > +		iwag->sz_recs = 4096 / sizeof(struct xfs_inobt_rec_incore);
> > > > +
> > > 
> > > Perhaps this should use PAGE_SIZE or a related macro?
> > 
> > It did in the previous revision, but Dave pointed out that sz_recs then
> > becomes quite large on a system with 64k pages...
> > 
> > 65536 bytes / 16 bytes per inobt record = 4096 records
> > 4096 records * 64 inodes per record = 262144 inodes
> > 262144 inodes * 512 bytes per inode = 128MB of inode readahead
> > 
> 
> Ok, the comment just gave me the impression the intent was to fill a
> single page.
> 
> > I could extend the comment to explain why we don't use PAGE_SIZE...
> > 
> 
> Sounds good, though what I think would be better is to define a
> IWALK_DEFAULT_RECS or some such somewhere and put the calculation
> details with that.
> 
> Though now that you point out the readahead thing, aren't we at risk of
> a similar problem for users who happen to pass a really large userspace
> buffer? Should we cap the kernel allocation/readahead window in all
> cases and not just the default case?

Hmm, that's right, we don't want to let userspace arbitrarily determine
the size of the buffer, and I think the current implementation caps it
the readahaead at ... oh, PAGE_SIZE / sizeof(xfs_inogrp_t).

Oh, right, and in the V1 patchset Dave said that we should constrain
readahead even further.

--D

> 
> Brian
> 
> > /*
> >  * Note: We hardcode 4096 here (instead of, say, PAGE_SIZE) because we want to
> >  * constrain the amount of inode readahead to 16k inodes regardless of CPU:
> >  *
> >  * 4096 bytes / 16 bytes per inobt record = 256 inobt records
> >  * 256 inobt records * 64 inodes per record = 16384 inodes
> >  * 16384 inodes * 512 bytes per inode(?) = 8MB of inode readahead
> >  */
> > 
> > --D
> > 
> > > Brian
> > > 
> > > > +	/*
> > > > +	 * Allocate enough space to prefetch at least two records so that we
> > > > +	 * can cache both the inobt record where the iwalk started and the next
> > > > +	 * record.  This simplifies the AG inode walk loop setup code.
> > > > +	 */
> > > > +	iwag->sz_recs = max_t(unsigned int, iwag->sz_recs, 2);
> > > > +}
> > > > +
> > > > +/*
> > > > + * Walk all inodes in the filesystem starting from @startino.  The @iwalk_fn
> > > > + * will be called for each allocated inode, being passed the inode's number and
> > > > + * @data.  @max_prefetch controls how many inobt records' worth of inodes we
> > > > + * try to readahead.
> > > > + */
> > > > +int
> > > > +xfs_iwalk(
> > > > +	struct xfs_mount	*mp,
> > > > +	struct xfs_trans	*tp,
> > > > +	xfs_ino_t		startino,
> > > > +	xfs_iwalk_fn		iwalk_fn,
> > > > +	unsigned int		max_prefetch,
> > > > +	void			*data)
> > > > +{
> > > > +	struct xfs_iwalk_ag	iwag = {
> > > > +		.mp		= mp,
> > > > +		.tp		= tp,
> > > > +		.iwalk_fn	= iwalk_fn,
> > > > +		.data		= data,
> > > > +		.startino	= startino,
> > > > +	};
> > > > +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
> > > > +	int			error;
> > > > +
> > > > +	ASSERT(agno < mp->m_sb.sb_agcount);
> > > > +
> > > > +	xfs_iwalk_set_prefetch(&iwag, max_prefetch);
> > > > +	error = xfs_iwalk_alloc(&iwag);
> > > > +	if (error)
> > > > +		return error;
> > > > +
> > > > +	for (; agno < mp->m_sb.sb_agcount; agno++) {
> > > > +		error = xfs_iwalk_ag(&iwag);
> > > > +		if (error)
> > > > +			break;
> > > > +		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
> > > > +	}
> > > > +
> > > > +	xfs_iwalk_free(&iwag);
> > > > +	return error;
> > > > +}
> > > > diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
> > > > new file mode 100644
> > > > index 000000000000..45b1baabcd2d
> > > > --- /dev/null
> > > > +++ b/fs/xfs/xfs_iwalk.h
> > > > @@ -0,0 +1,18 @@
> > > > +// SPDX-License-Identifier: GPL-2.0+
> > > > +/*
> > > > + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> > > > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > > > + */
> > > > +#ifndef __XFS_IWALK_H__
> > > > +#define __XFS_IWALK_H__
> > > > +
> > > > +/* Walk all inodes in the filesystem starting from @startino. */
> > > > +typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
> > > > +			    xfs_ino_t ino, void *data);
> > > > +/* Return value (for xfs_iwalk_fn) that aborts the walk immediately. */
> > > > +#define XFS_IWALK_ABORT	(1)
> > > > +
> > > > +int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
> > > > +		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
> > > > +
> > > > +#endif /* __XFS_IWALK_H__ */
> > > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > > index 2464ea351f83..f9bb1d50bc0e 100644
> > > > --- a/fs/xfs/xfs_trace.h
> > > > +++ b/fs/xfs/xfs_trace.h
> > > > @@ -3516,6 +3516,46 @@ DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
> > > >  DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
> > > >  DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
> > > >  
> > > > +TRACE_EVENT(xfs_iwalk_ag,
> > > > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> > > > +		 xfs_agino_t startino),
> > > > +	TP_ARGS(mp, agno, startino),
> > > > +	TP_STRUCT__entry(
> > > > +		__field(dev_t, dev)
> > > > +		__field(xfs_agnumber_t, agno)
> > > > +		__field(xfs_agino_t, startino)
> > > > +	),
> > > > +	TP_fast_assign(
> > > > +		__entry->dev = mp->m_super->s_dev;
> > > > +		__entry->agno = agno;
> > > > +		__entry->startino = startino;
> > > > +	),
> > > > +	TP_printk("dev %d:%d agno %d startino %u",
> > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
> > > > +		  __entry->startino)
> > > > +)
> > > > +
> > > > +TRACE_EVENT(xfs_iwalk_ag_rec,
> > > > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> > > > +		 struct xfs_inobt_rec_incore *irec),
> > > > +	TP_ARGS(mp, agno, irec),
> > > > +	TP_STRUCT__entry(
> > > > +		__field(dev_t, dev)
> > > > +		__field(xfs_agnumber_t, agno)
> > > > +		__field(xfs_agino_t, startino)
> > > > +		__field(uint64_t, freemask)
> > > > +	),
> > > > +	TP_fast_assign(
> > > > +		__entry->dev = mp->m_super->s_dev;
> > > > +		__entry->agno = agno;
> > > > +		__entry->startino = irec->ir_startino;
> > > > +		__entry->freemask = irec->ir_free;
> > > > +	),
> > > > +	TP_printk("dev %d:%d agno %d startino %u freemask 0x%llx",
> > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
> > > > +		  __entry->startino, __entry->freemask)
> > > > +)
> > > > +
> > > >  #endif /* _TRACE_XFS_H */
> > > >  
> > > >  #undef TRACE_INCLUDE_PATH
> > > > 

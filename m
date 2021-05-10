Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE33C433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 23:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B664861585
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 23:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhEJXjg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 19:39:36 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:46179 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229561AbhEJXjg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 May 2021 19:39:36 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 5AEA680B480;
        Tue, 11 May 2021 09:38:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lgFTo-00D0Hf-5u; Tue, 11 May 2021 09:38:28 +1000
Date:   Tue, 11 May 2021 09:38:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/22] xfs: move perag structure and setup to
 libxfs/xfs_ag.[ch]
Message-ID: <20210510233828.GP63242@dread.disaster.area>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-4-david@fromorbit.com>
 <20210510222655.GH8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510222655.GH8582@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=3cxL0vOHBQcozKhhfx4A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 10, 2021 at 03:26:55PM -0700, Darrick J. Wong wrote:
> On Thu, May 06, 2021 at 05:20:35PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Move the xfs_perag infrastructure to the libxfs files that contain
> > all the per AG infrastructure. This helps set up for passing perags
> > around all the code instead of bare agnos with minimal extra
> > includes for existing files.
.....
> > -int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
> > +
> > +/* per-AG block reservation data structures*/
> > +struct xfs_ag_resv {
> > +	/* number of blocks originally reserved here */
> > +	xfs_extlen_t			ar_orig_reserved;
> > +	/* number of blocks reserved here */
> > +	xfs_extlen_t			ar_reserved;
> > +	/* number of blocks originally asked for */
> > +	xfs_extlen_t			ar_asked;
> > +};
> > +
> > +/*
> > + * Per-ag incore structure, copies of information in agf and agi, to improve the
> > + * performance of allocation group selection.
> > + */
> > +typedef struct xfs_perag {
> > +	struct xfs_mount *pag_mount;	/* owner filesystem */
> > +	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
> > +	atomic_t	pag_ref;	/* perag reference count */
> > +	char		pagf_init;	/* this agf's entry is initialized */
> > +	char		pagi_init;	/* this agi's entry is initialized */
> > +	char		pagf_metadata;	/* the agf is preferred to be metadata */
> > +	char		pagi_inodeok;	/* The agi is ok for inodes */
> > +	uint8_t		pagf_levels[XFS_BTNUM_AGF];
> > +					/* # of levels in bno & cnt btree */
> > +	bool		pagf_agflreset; /* agfl requires reset before use */
> > +	uint32_t	pagf_flcount;	/* count of blocks in freelist */
> > +	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
> > +	xfs_extlen_t	pagf_longest;	/* longest free space */
> > +	uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
> > +	xfs_agino_t	pagi_freecount;	/* number of free inodes */
> > +	xfs_agino_t	pagi_count;	/* number of allocated inodes */
> > +
> > +	/*
> > +	 * Inode allocation search lookup optimisation.
> > +	 * If the pagino matches, the search for new inodes
> > +	 * doesn't need to search the near ones again straight away
> > +	 */
> > +	xfs_agino_t	pagl_pagino;
> > +	xfs_agino_t	pagl_leftrec;
> > +	xfs_agino_t	pagl_rightrec;
> > +
> > +	int		pagb_count;	/* pagb slots in use */
> > +	uint8_t		pagf_refcount_level; /* recount btree height */
> > +
> > +	/* Blocks reserved for all kinds of metadata. */
> > +	struct xfs_ag_resv	pag_meta_resv;
> > +	/* Blocks reserved for the reverse mapping btree. */
> > +	struct xfs_ag_resv	pag_rmapbt_resv;
> > +
> > +	/* -- kernel only structures below this line -- */
> > +
> > +	/*
> > +	 * Bitsets of per-ag metadata that have been checked and/or are sick.
> > +	 * Callers should hold pag_state_lock before accessing this field.
> > +	 */
> > +	uint16_t	pag_checked;
> > +	uint16_t	pag_sick;
> > +	spinlock_t	pag_state_lock;
> > +
> > +	spinlock_t	pagb_lock;	/* lock for pagb_tree */
> > +	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
> > +	unsigned int	pagb_gen;	/* generation count for pagb_tree */
> > +	wait_queue_head_t pagb_wait;	/* woken when pagb_gen changes */
> > +
> > +	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
> > +
> > +	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
> > +	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
> > +	int		pag_ici_reclaimable;	/* reclaimable inodes */
> > +	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
> > +
> > +	/* buffer cache index */
> > +	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
> > +	struct rhashtable pag_buf_hash;
> > +
> > +	/* for rcu-safe freeing */
> > +	struct rcu_head	rcu_head;
> > +
> > +	/* background prealloc block trimming */
> > +	struct delayed_work	pag_blockgc_work;
> > +
> > +	/*
> > +	 * Unlinked inode information.  This incore information reflects
> > +	 * data stored in the AGI, so callers must hold the AGI buffer lock
> > +	 * or have some other means to control concurrency.
> > +	 */
> > +	struct rhashtable	pagi_unlinked_hash;
> > +} xfs_perag_t;
> 
> I wonder, have you ported this to xfsprogs yet?  How much of a mess is
> this going to create for things like libxfs-diff?

I've looked at it, not yet ported. I structured the code so that
userspace should just need to add a couple of "#ifdef
KERNEL"/"#endif /* KERNEL */" pairs around the structure definition
and the init function, and then all userspace sees is the common
parts of the structure. Then the custom code to initialise the
perags in libxfs/init.c in userspace can go away....

IOWs, I think the xfs-diff should only show up a couple of ifdefs
and nothing else.

> (Also would be nice to kill off xfs_perag_t, but maybe you did that at
> the end of the series already <shrug>)

No, I don't think I did. Should be trivial to do, there's only 4 or
5 of them in use. I'll do it as a separate patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

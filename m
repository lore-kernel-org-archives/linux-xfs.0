Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23672 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757657AbcIHTOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 15:14:46 -0400
Date: Thu, 8 Sep 2016 12:14:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/71] xfs: log refcount intent items
Message-ID: <20160908191404.GB8969@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
 <147216802075.867.12945255918683675311.stgit@birch.djwong.org>
 <20160906152155.GJ24287@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160906152155.GJ24287@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 08:21:55AM -0700, Christoph Hellwig wrote:
> > +	__uint64_t			cui_id;
> > +	struct xfs_ail_cursor		cur;
> > +	struct xfs_ail			*ailp = log->l_ailp;
> > +
> > +	cud_formatp = item->ri_buf[0].i_addr;
> > +	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_cud_log_format));
> 
> Should we return -EFSCORRUPTED here instead?

Yes.  The RUD recovery routine should probably get that change too.

> > +	/* XXX: do nothing for now */
> 
> What else would be do in the future here?
> 
> > +static void
> > +xfs_trans_set_refcount_flags(
> > +	struct xfs_phys_extent		*refc,
> > +	enum xfs_refcount_intent_type	type)
> > +{
> > +	refc->pe_flags = 0;
> > +	switch (type) {
> > +	case XFS_REFCOUNT_INCREASE:
> > +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_INCREASE;
> > +		break;
> > +	case XFS_REFCOUNT_DECREASE:
> > +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_DECREASE;
> > +		break;
> > +	case XFS_REFCOUNT_ALLOC_COW:
> > +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_ALLOC_COW;
> > +		break;
> > +	case XFS_REFCOUNT_FREE_COW:
> > +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_FREE_COW;
> > +		break;
> 
> Is there any good reasons to use a type enum in core, but flags on
> disk?

I suppose since log structures aren't guaranteed to be platform agnostic
it's fine to just copy in the in-core enum here.

> > +int
> > +xfs_trans_log_finish_refcount_update(
> > +	struct xfs_trans		*tp,
> > +	struct xfs_cud_log_item		*cudp,
> > +	enum xfs_refcount_intent_type	type,
> > +	xfs_fsblock_t			startblock,
> > +	xfs_extlen_t			blockcount,
> > +	struct xfs_btree_cur		**pcur)
> > +{
> > +	int				error;
> > +
> > +	/* XXX: leave this empty for now */
> > +	error = -EFSCORRUPTED;
> 
> Lift might be a lot easier if this patch and "xfs: connect refcount
> adjust functions to upper layers" were merged into one.  It's not like
> they are testable independently anyway.

I'll think about it.  I think it might not be too difficult to push "xfs: log
refcount intent items" down one and merge it with "xfs: connect refcount adjust
functions to upper layers", though my preference biases towards not stirring
things up just to reduce commit count.

(Basically, I'll give it a try after I'm done making the other fixes and commit
it if it doesn't make a total mess of things.)

--D

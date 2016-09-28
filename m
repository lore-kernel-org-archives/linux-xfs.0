Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37047 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752977AbcI1SqY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2016 14:46:24 -0400
Date: Wed, 28 Sep 2016 11:46:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/63] xfs: add refcount btree operations
Message-ID: <20160928184615.GR14092@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503126699.30303.3194028804178091894.stgit@birch.djwong.org>
 <20160928162012.GD8852@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160928162012.GD8852@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Sep 28, 2016 at 12:20:13PM -0400, Brian Foster wrote:
> On Tue, Sep 27, 2016 at 07:54:27PM -0700, Darrick J. Wong wrote:
> > Implement the generic btree operations required to manipulate refcount
> > btree blocks.  The implementation is similar to the bmapbt, though it
> > will only allocate and free blocks from the AG.
> > 
> > Since the refcount root and level fields are separate from the
> > existing roots and levels array, they need a separate logging flag.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > [hch: fix logging of AGF refcount btree fields]
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> > v2: Remove init_rec_from_key since we no longer need it, and add
> > tracepoints when refcount btree operations fail.
> > ---
> >  fs/xfs/Makefile                    |    1 
> >  fs/xfs/libxfs/xfs_alloc.c          |    3 
> >  fs/xfs/libxfs/xfs_format.h         |   10 +-
> >  fs/xfs/libxfs/xfs_refcount.c       |  177 ++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_refcount.h       |   30 +++++
> >  fs/xfs/libxfs/xfs_refcount_btree.c |  226 ++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_fsops.c                 |    1 
> >  7 files changed, 446 insertions(+), 2 deletions(-)
> >  create mode 100644 fs/xfs/libxfs/xfs_refcount.c
> >  create mode 100644 fs/xfs/libxfs/xfs_refcount.h
> > 
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> > index 359cf0c..c4550bd 100644
> > --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> > +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> ...
> > @@ -106,12 +279,65 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
> >  	.verify_write		= xfs_refcountbt_write_verify,
> >  };
> >  
> > +#if defined(DEBUG) || defined(XFS_WARN)
> > +STATIC int
> > +xfs_refcountbt_keys_inorder(
> > +	struct xfs_btree_cur	*cur,
> > +	union xfs_btree_key	*k1,
> > +	union xfs_btree_key	*k2)
> > +{
> > +	return be32_to_cpu(k1->refc.rc_startblock) <
> > +	       be32_to_cpu(k2->refc.rc_startblock);
> > +}
> > +
> > +STATIC int
> > +xfs_refcountbt_recs_inorder(
> > +	struct xfs_btree_cur	*cur,
> > +	union xfs_btree_rec	*r1,
> > +	union xfs_btree_rec	*r2)
> > +{
> > +	struct xfs_refcount_irec	a, b;
> > +
> > +	int ret = be32_to_cpu(r1->refc.rc_startblock) +
> > +		be32_to_cpu(r1->refc.rc_blockcount) <=
> > +		be32_to_cpu(r2->refc.rc_startblock);
> > +	if (!ret) {
> > +		a.rc_startblock = be32_to_cpu(r1->refc.rc_startblock);
> > +		a.rc_blockcount = be32_to_cpu(r1->refc.rc_blockcount);
> > +		a.rc_refcount = be32_to_cpu(r1->refc.rc_refcount);
> > +		b.rc_startblock = be32_to_cpu(r2->refc.rc_startblock);
> > +		b.rc_blockcount = be32_to_cpu(r2->refc.rc_blockcount);
> > +		b.rc_refcount = be32_to_cpu(r2->refc.rc_refcount);
> > +		a = a; b = b;
> 
> What's that about ^?

Shutting up gcc warnings when I build this for xfsprogs. :)

The whole thing was a way to trigger a tracepoint when the refc records
are out of order.  It's probably unnecessary now, so I'll just remove it.

> 
> > +		trace_xfs_refcount_rec_order_error(cur->bc_mp,
> > +				cur->bc_private.a.agno, &a, &b);
> > +	}
> > +
> > +	return ret;
> > +}
> > +#endif
> > +
> >  static const struct xfs_btree_ops xfs_refcountbt_ops = {
> >  	.rec_len		= sizeof(struct xfs_refcount_rec),
> >  	.key_len		= sizeof(struct xfs_refcount_key),
> >  
> >  	.dup_cursor		= xfs_refcountbt_dup_cursor,
> > +	.set_root		= xfs_refcountbt_set_root,
> > +	.alloc_block		= xfs_refcountbt_alloc_block,
> > +	.free_block		= xfs_refcountbt_free_block,
> > +	.get_minrecs		= xfs_refcountbt_get_minrecs,
> > +	.get_maxrecs		= xfs_refcountbt_get_maxrecs,
> > +	.init_key_from_rec	= xfs_refcountbt_init_key_from_rec,
> > +	.init_high_key_from_rec	= xfs_refcountbt_init_high_key_from_rec,
> > +	.init_rec_from_cur	= xfs_refcountbt_init_rec_from_cur,
> > +	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
> > +	.key_diff		= xfs_refcountbt_key_diff,
> >  	.buf_ops		= &xfs_refcountbt_buf_ops,
> > +	.diff_two_keys		= xfs_refcountbt_diff_two_keys,
> > +#if defined(DEBUG) || defined(XFS_WARN)
> > +	.keys_inorder		= xfs_refcountbt_keys_inorder,
> > +	.recs_inorder		= xfs_refcountbt_recs_inorder,
> > +#endif
> >  };
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index c2fe6bf..4b4059b 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -263,6 +263,7 @@ xfs_growfs_data_private(
> >  			agf->agf_refcount_root = cpu_to_be32(
> >  					xfs_refc_block(mp));
> >  			agf->agf_refcount_level = cpu_to_be32(1);
> > +			agf->agf_refcount_blocks = cpu_to_be32(1);
> 
> Looks like this should have come earlier..?

Yes.

--D

> 
> Brian
> 
> >  		}
> >  
> >  		error = xfs_bwrite(bp);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A3BED7CD5
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 18:54:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C638AC003
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 16:54:05 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 0cJ4xwC0cisIZifs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jul 2016 16:54:01 -0700 (PDT)
Date: Fri, 8 Jul 2016 16:53:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 032/119] xfs: add rmap btree operations
Message-ID: <20160708235351.GA30604@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612647771.12839.2301418036042118299.stgit@birch.djwong.org>
	<20160708183347.GD59278@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160708183347.GD59278@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Fri, Jul 08, 2016 at 02:33:47PM -0400, Brian Foster wrote:
> On Thu, Jun 16, 2016 at 06:21:17PM -0700, Darrick J. Wong wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Implement the generic btree operations needed to manipulate rmap
> > btree blocks. This is very similar to the per-ag freespace btree
> > implementation, and uses the AGFL for allocation and freeing of
> > blocks.
> > 
> > Adapt the rmap btree to store owner offsets within each rmap record,
> > and to handle the primary key being redefined as the tuple
> > [agblk, owner, offset].  The expansion of the primary key is crucial
> > to allowing multiple owners per extent.
> > 
> > [darrick: adapt the btree ops to deal with offsets]
> > [darrick: remove init_rec_from_key]
> > [darrick: move unwritten bit to rm_offset]
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> > ---
> >  fs/xfs/libxfs/xfs_btree.h      |    1 
> >  fs/xfs/libxfs/xfs_rmap.c       |   96 ++++++++++++++++
> >  fs/xfs/libxfs/xfs_rmap_btree.c |  243 ++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_rmap_btree.h |    9 +
> >  fs/xfs/xfs_trace.h             |    3 
> >  5 files changed, 352 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 90ea2a7..9963c48 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -216,6 +216,7 @@ union xfs_btree_irec {
> >  	xfs_alloc_rec_incore_t		a;
> >  	xfs_bmbt_irec_t			b;
> >  	xfs_inobt_rec_incore_t		i;
> > +	struct xfs_rmap_irec		r;
> >  };
> >  
> >  /*
> > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > index d1fd471..c6a5a0b 100644
> > --- a/fs/xfs/libxfs/xfs_rmap.c
> > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > @@ -37,6 +37,102 @@
> >  #include "xfs_error.h"
> >  #include "xfs_extent_busy.h"
> >  
> ...
> > +/*
> > + * Update the record referred to by cur to the value given
> > + * by [bno, len, owner, offset].
> > + * This either works (return 0) or gets an EFSCORRUPTED error.
> > + */
> > +STATIC int
> > +xfs_rmap_update(
> 
> This throws an unused warning, but I assume it will be used later.

Yes.

> > +	struct xfs_btree_cur	*cur,
> > +	struct xfs_rmap_irec	*irec)
> > +{
> > +	union xfs_btree_rec	rec;
> > +
> > +	rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
> > +	rec.rmap.rm_blockcount = cpu_to_be32(irec->rm_blockcount);
> > +	rec.rmap.rm_owner = cpu_to_be64(irec->rm_owner);
> > +	rec.rmap.rm_offset = cpu_to_be64(
> > +			xfs_rmap_irec_offset_pack(irec));
> > +	return xfs_btree_update(cur, &rec);
> > +}
> > +
> ...
> >  int
> >  xfs_rmap_free(
> >  	struct xfs_trans	*tp,
> > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> > index 7a35c78..c50c725 100644
> > --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> > +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> ...
> > @@ -43,6 +68,173 @@ xfs_rmapbt_dup_cursor(
> >  			cur->bc_private.a.agbp, cur->bc_private.a.agno);
> >  }
> >  
> > +STATIC void
> > +xfs_rmapbt_set_root(
> > +	struct xfs_btree_cur	*cur,
> > +	union xfs_btree_ptr	*ptr,
> > +	int			inc)
> > +{
> > +	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> > +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> > +	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
> > +	int			btnum = cur->bc_btnum;
> > +	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
> > +
> > +	ASSERT(ptr->s != 0);
> > +
> > +	agf->agf_roots[btnum] = ptr->s;
> > +	be32_add_cpu(&agf->agf_levels[btnum], inc);
> > +	pag->pagf_levels[btnum] += inc;
> > +	xfs_perag_put(pag);
> > +
> > +	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
> > +}
> > +
> > +STATIC int
> > +xfs_rmapbt_alloc_block(
> > +	struct xfs_btree_cur	*cur,
> > +	union xfs_btree_ptr	*start,
> > +	union xfs_btree_ptr	*new,
> > +	int			*stat)
> > +{
> > +	int			error;
> > +	xfs_agblock_t		bno;
> > +
> > +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > +
> > +	/* Allocate the new block from the freelist. If we can't, give up.  */
> > +	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
> > +				       &bno, 1);
> > +	if (error) {
> > +		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> > +		return error;
> > +	}
> > +
> > +	trace_xfs_rmapbt_alloc_block(cur->bc_mp, cur->bc_private.a.agno,
> > +			bno, 1);
> > +	if (bno == NULLAGBLOCK) {
> > +		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> > +		*stat = 0;
> > +		return 0;
> > +	}
> > +
> > +	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_private.a.agno, bno, 1,
> > +			false);
> > +
> > +	xfs_trans_agbtree_delta(cur->bc_tp, 1);
> > +	new->s = cpu_to_be32(bno);
> > +
> > +	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> > +	*stat = 1;
> > +	return 0;
> > +}
> > +
> > +STATIC int
> > +xfs_rmapbt_free_block(
> > +	struct xfs_btree_cur	*cur,
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> > +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> > +	xfs_agblock_t		bno;
> > +	int			error;
> > +
> > +	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
> > +	trace_xfs_rmapbt_free_block(cur->bc_mp, cur->bc_private.a.agno,
> > +			bno, 1);
> > +	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
> > +	if (error)
> > +		return error;
> > +
> > +	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
> > +			      XFS_EXTENT_BUSY_SKIP_DISCARD);
> > +	xfs_trans_agbtree_delta(cur->bc_tp, -1);
> > +
> > +	xfs_trans_binval(cur->bc_tp, bp);
> 
> This is handled in the generic btree code.

Oh, right, I noticed that this changed since I started developing
rmap/reflink.  Will change both.

> 
> > +	return 0;
> > +}
> > +
> ...
> > @@ -117,12 +309,63 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
> >  	.verify_write		= xfs_rmapbt_write_verify,
> >  };
> >  
> > +#if defined(DEBUG) || defined(XFS_WARN)
> > +STATIC int
> > +xfs_rmapbt_keys_inorder(
> > +	struct xfs_btree_cur	*cur,
> > +	union xfs_btree_key	*k1,
> > +	union xfs_btree_key	*k2)
> > +{
> > +	if (be32_to_cpu(k1->rmap.rm_startblock) <
> > +	    be32_to_cpu(k2->rmap.rm_startblock))
> > +		return 1;
> > +	if (be64_to_cpu(k1->rmap.rm_owner) <
> > +	    be64_to_cpu(k2->rmap.rm_owner))
> > +		return 1;
> > +	if (XFS_RMAP_OFF(be64_to_cpu(k1->rmap.rm_offset)) <=
> > +	    XFS_RMAP_OFF(be64_to_cpu(k2->rmap.rm_offset)))
> > +		return 1;
> > +	return 0;
> 
> I might just not be familiar enough with the rmapbt ordering rules, but
> this doesn't look right. If the rm_startblock values are out of order
> (k1 startblock > k2 startblock), but either of the owner or offset
> values are in-order, then we call the keys in order. Is that intentional
> or should (k1->rmap.rm_startblock > k2->rmap.rm_startblock) always
> return 0?

Nope, you are correct about ordering rules.  This is an error.

> > +}
> > +
> > +STATIC int
> > +xfs_rmapbt_recs_inorder(
> > +	struct xfs_btree_cur	*cur,
> > +	union xfs_btree_rec	*r1,
> > +	union xfs_btree_rec	*r2)
> > +{
> > +	if (be32_to_cpu(r1->rmap.rm_startblock) <
> > +	    be32_to_cpu(r2->rmap.rm_startblock))
> > +		return 1;
> > +	if (XFS_RMAP_OFF(be64_to_cpu(r1->rmap.rm_offset)) <
> > +	    XFS_RMAP_OFF(be64_to_cpu(r2->rmap.rm_offset)))
> > +		return 1;
> > +	if (be64_to_cpu(r1->rmap.rm_owner) <=
> > +	    be64_to_cpu(r2->rmap.rm_owner))
> > +		return 1;
> > +	return 0;
> > +}
> 
> Same question here.

Same answer.  Will fix both of these and take a second look at the refcount
versions of these.

--D

> 
> Brian
> 
> > +#endif	/* DEBUG */
> > +
> >  static const struct xfs_btree_ops xfs_rmapbt_ops = {
> >  	.rec_len		= sizeof(struct xfs_rmap_rec),
> >  	.key_len		= sizeof(struct xfs_rmap_key),
> >  
> >  	.dup_cursor		= xfs_rmapbt_dup_cursor,
> > +	.set_root		= xfs_rmapbt_set_root,
> > +	.alloc_block		= xfs_rmapbt_alloc_block,
> > +	.free_block		= xfs_rmapbt_free_block,
> > +	.get_minrecs		= xfs_rmapbt_get_minrecs,
> > +	.get_maxrecs		= xfs_rmapbt_get_maxrecs,
> > +	.init_key_from_rec	= xfs_rmapbt_init_key_from_rec,
> > +	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
> > +	.init_ptr_from_cur	= xfs_rmapbt_init_ptr_from_cur,
> > +	.key_diff		= xfs_rmapbt_key_diff,
> >  	.buf_ops		= &xfs_rmapbt_buf_ops,
> > +#if defined(DEBUG) || defined(XFS_WARN)
> > +	.keys_inorder		= xfs_rmapbt_keys_inorder,
> > +	.recs_inorder		= xfs_rmapbt_recs_inorder,
> > +#endif
> >  };
> >  
> >  /*
> > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> > index 462767f..17fa383 100644
> > --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> > +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> > @@ -52,6 +52,15 @@ struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
> >  int xfs_rmapbt_maxrecs(struct xfs_mount *mp, int blocklen, int leaf);
> >  extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
> >  
> > +int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
> > +		xfs_extlen_t len, uint64_t owner, uint64_t offset,
> > +		unsigned int flags, int *stat);
> > +int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t bno,
> > +		xfs_extlen_t len, uint64_t owner, uint64_t offset,
> > +		unsigned int flags, int *stat);
> > +int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
> > +		int *stat);
> > +
> >  int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
> >  		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
> >  		   struct xfs_owner_info *oinfo);
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index b4ee9c8..28bd991 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -2470,6 +2470,9 @@ DEFINE_RMAP_EVENT(xfs_rmap_alloc_extent);
> >  DEFINE_RMAP_EVENT(xfs_rmap_alloc_extent_done);
> >  DEFINE_RMAP_EVENT(xfs_rmap_alloc_extent_error);
> >  
> > +DEFINE_BUSY_EVENT(xfs_rmapbt_alloc_block);
> > +DEFINE_BUSY_EVENT(xfs_rmapbt_free_block);
> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

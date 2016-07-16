Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 931677CC9
	for <xfs@oss.sgi.com>; Sat, 16 Jul 2016 02:26:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 60C8D8F8037
	for <xfs@oss.sgi.com>; Sat, 16 Jul 2016 00:26:33 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 1FLzYWxSEYAcK36L (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 16 Jul 2016 00:26:29 -0700 (PDT)
Date: Sat, 16 Jul 2016 00:26:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 044/119] xfs: propagate bmap updates to rmapbt
Message-ID: <20160716072621.GC21529@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612655409.12839.4069768871045909071.stgit@birch.djwong.org>
	<20160715183356.GD55338@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160715183356.GD55338@bfoster.bfoster>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Fri, Jul 15, 2016 at 02:33:56PM -0400, Brian Foster wrote:
> On Thu, Jun 16, 2016 at 06:22:34PM -0700, Darrick J. Wong wrote:
> > When we map, unmap, or convert an extent in a file's data or attr
> > fork, schedule a respective update in the rmapbt.  Previous versions
> > of this patch required a 1:1 correspondence between bmap and rmap,
> > but this is no longer true.
> > 
> > v2: Remove the 1:1 correspondence requirement now that we have the
> > ability to make interval queries against the rmapbt.  Update the
> > commit message to reflect the broad restructuring of this patch.
> > Fix the bmap shift code to adjust the rmaps correctly.
> > 
> > v3: Use the deferred operations code to handle redo operations
> > atomically and deadlock free.  Plumb in all five rmap actions
> > (map, unmap, convert extent, alloc, free); we'll use the first
> > three now for file data, and reflink will want the last two.
> > Add an error injection site to test log recovery.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c       |   56 ++++++++-
> >  fs/xfs/libxfs/xfs_rmap.c       |  252 ++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_rmap_btree.h |   24 ++++
> >  fs/xfs/xfs_bmap_util.c         |    1 
> >  fs/xfs/xfs_defer_item.c        |    6 +
> >  fs/xfs/xfs_error.h             |    4 -
> >  fs/xfs/xfs_log_recover.c       |   56 +++++++++
> >  fs/xfs/xfs_trans.h             |    3 
> >  fs/xfs/xfs_trans_rmap.c        |    7 +
> >  9 files changed, 393 insertions(+), 16 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 61c0231..507fd74 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -46,6 +46,7 @@
> >  #include "xfs_symlink.h"
> >  #include "xfs_attr_leaf.h"
> >  #include "xfs_filestream.h"
> > +#include "xfs_rmap_btree.h"
> >  
> >  
> >  kmem_zone_t		*xfs_bmap_free_item_zone;
> > @@ -2178,6 +2179,11 @@ xfs_bmap_add_extent_delay_real(
> >  		ASSERT(0);
> >  	}
> >  
> > +	/* add reverse mapping */
> > +	error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip, whichfork, new);
> > +	if (error)
> > +		goto done;
> > +
> >  	/* convert to a btree if necessary */
> >  	if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
> >  		int	tmp_logflags;	/* partial log flag return val */
> > @@ -2714,6 +2720,11 @@ xfs_bmap_add_extent_unwritten_real(
> >  		ASSERT(0);
> >  	}
> >  
> > +	/* update reverse mappings */
> > +	error = xfs_rmap_convert_extent(mp, dfops, ip, XFS_DATA_FORK, new);
> > +	if (error)
> > +		goto done;
> > +
> >  	/* convert to a btree if necessary */
> >  	if (xfs_bmap_needs_btree(ip, XFS_DATA_FORK)) {
> >  		int	tmp_logflags;	/* partial log flag return val */
> > @@ -3106,6 +3117,11 @@ xfs_bmap_add_extent_hole_real(
> >  		break;
> >  	}
> >  
> > +	/* add reverse mapping */
> > +	error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip, whichfork, new);
> > +	if (error)
> > +		goto done;
> > +
> >  	/* convert to a btree if necessary */
> >  	if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
> >  		int	tmp_logflags;	/* partial log flag return val */
> > @@ -5032,6 +5048,14 @@ xfs_bmap_del_extent(
> >  		++*idx;
> >  		break;
> >  	}
> > +
> > +	/* remove reverse mapping */
> > +	if (!delay) {
> > +		error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, del);
> > +		if (error)
> > +			goto done;
> > +	}
> > +
> >  	/*
> >  	 * If we need to, add to list of extents to delete.
> >  	 */
> > @@ -5569,7 +5593,8 @@ xfs_bmse_shift_one(
> >  	struct xfs_bmbt_rec_host	*gotp,
> >  	struct xfs_btree_cur		*cur,
> >  	int				*logflags,
> > -	enum shift_direction		direction)
> > +	enum shift_direction		direction,
> > +	struct xfs_defer_ops		*dfops)
> >  {
> >  	struct xfs_ifork		*ifp;
> >  	struct xfs_mount		*mp;
> > @@ -5617,9 +5642,13 @@ xfs_bmse_shift_one(
> >  		/* check whether to merge the extent or shift it down */
> >  		if (xfs_bmse_can_merge(&adj_irec, &got,
> >  				       offset_shift_fsb)) {
> > -			return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
> > -					      *current_ext, gotp, adj_irecp,
> > -					      cur, logflags);
> > +			error = xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
> > +					       *current_ext, gotp, adj_irecp,
> > +					       cur, logflags);
> > +			if (error)
> > +				return error;
> > +			adj_irec = got;
> > +			goto update_rmap;
> >  		}
> >  	} else {
> >  		startoff = got.br_startoff + offset_shift_fsb;
> > @@ -5656,9 +5685,10 @@ update_current_ext:
> >  		(*current_ext)--;
> >  	xfs_bmbt_set_startoff(gotp, startoff);
> >  	*logflags |= XFS_ILOG_CORE;
> > +	adj_irec = got;
> >  	if (!cur) {
> >  		*logflags |= XFS_ILOG_DEXT;
> > -		return 0;
> > +		goto update_rmap;
> >  	}
> >  
> >  	error = xfs_bmbt_lookup_eq(cur, got.br_startoff, got.br_startblock,
> > @@ -5668,8 +5698,18 @@ update_current_ext:
> >  	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
> >  
> >  	got.br_startoff = startoff;
> > -	return xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
> > -			       got.br_blockcount, got.br_state);
> > +	error = xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
> > +			got.br_blockcount, got.br_state);
> > +	if (error)
> > +		return error;
> > +
> > +update_rmap:
> > +	/* update reverse mapping */
> > +	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, &adj_irec);
> > +	if (error)
> > +		return error;
> > +	adj_irec.br_startoff = startoff;
> > +	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, &adj_irec);
> >  }
> >  
> >  /*
> > @@ -5797,7 +5837,7 @@ xfs_bmap_shift_extents(
> >  	while (nexts++ < num_exts) {
> >  		error = xfs_bmse_shift_one(ip, whichfork, offset_shift_fsb,
> >  					   &current_ext, gotp, cur, &logflags,
> > -					   direction);
> > +					   direction, dfops);
> >  		if (error)
> >  			goto del_cursor;
> >  		/*
> > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > index 76fc5c2..f179ea4 100644
> > --- a/fs/xfs/libxfs/xfs_rmap.c
> > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > @@ -36,6 +36,8 @@
> >  #include "xfs_trace.h"
> >  #include "xfs_error.h"
> >  #include "xfs_extent_busy.h"
> > +#include "xfs_bmap.h"
> > +#include "xfs_inode.h"
> >  
> >  /*
> >   * Lookup the first record less than or equal to [bno, len, owner, offset]
> > @@ -1212,3 +1214,253 @@ xfs_rmapbt_query_range(
> >  	return xfs_btree_query_range(cur, &low_brec, &high_brec,
> >  			xfs_rmapbt_query_range_helper, &query);
> >  }
> > +
> > +/* Clean up after calling xfs_rmap_finish_one. */
> > +void
> > +xfs_rmap_finish_one_cleanup(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_btree_cur	*rcur,
> > +	int			error)
> > +{
> > +	struct xfs_buf		*agbp;
> > +
> > +	if (rcur == NULL)
> > +		return;
> > +	agbp = rcur->bc_private.a.agbp;
> > +	xfs_btree_del_cursor(rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> > +	xfs_trans_brelse(tp, agbp);
> 
> Why unconditionally release the agbp (and not just on error)?

We grabbed the agbp (er, AGF buffer) to construct the rmapbt cursor, so we have
to free it after the cursor is deleted regardless of whether or not there's an
error.

> > +}
> > +
> > +/*
> > + * Process one of the deferred rmap operations.  We pass back the
> > + * btree cursor to maintain our lock on the rmapbt between calls.
> > + * This saves time and eliminates a buffer deadlock between the
> > + * superblock and the AGF because we'll always grab them in the same
> > + * order.
> > + */
> > +int
> > +xfs_rmap_finish_one(
> > +	struct xfs_trans		*tp,
> > +	enum xfs_rmap_intent_type	type,
> > +	__uint64_t			owner,
> > +	int				whichfork,
> > +	xfs_fileoff_t			startoff,
> > +	xfs_fsblock_t			startblock,
> > +	xfs_filblks_t			blockcount,
> > +	xfs_exntst_t			state,
> > +	struct xfs_btree_cur		**pcur)
> > +{
> > +	struct xfs_mount		*mp = tp->t_mountp;
> > +	struct xfs_btree_cur		*rcur;
> > +	struct xfs_buf			*agbp = NULL;
> > +	int				error = 0;
> > +	xfs_agnumber_t			agno;
> > +	struct xfs_owner_info		oinfo;
> > +	xfs_agblock_t			bno;
> > +	bool				unwritten;
> > +
> > +	agno = XFS_FSB_TO_AGNO(mp, startblock);
> > +	ASSERT(agno != NULLAGNUMBER);
> > +	bno = XFS_FSB_TO_AGBNO(mp, startblock);
> > +
> > +	trace_xfs_rmap_deferred(mp, agno, type, bno, owner, whichfork,
> > +			startoff, blockcount, state);
> > +
> > +	if (XFS_TEST_ERROR(false, mp,
> > +			XFS_ERRTAG_RMAP_FINISH_ONE,
> > +			XFS_RANDOM_RMAP_FINISH_ONE))
> > +		return -EIO;
> > +
> > +	/*
> > +	 * If we haven't gotten a cursor or the cursor AG doesn't match
> > +	 * the startblock, get one now.
> > +	 */
> > +	rcur = *pcur;
> > +	if (rcur != NULL && rcur->bc_private.a.agno != agno) {
> > +		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
> > +		rcur = NULL;
> > +		*pcur = NULL;
> > +	}
> > +	if (rcur == NULL) {
> > +		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
> 
> Comment? Why is this here? (Maybe we should rename that function while
> we're at it..)

/*
 * Ensure the freelist is of a sufficient length to provide for any btree
 * splits that could happen when we make changes to the rmapbt.
 */

(I don't know why the function has that name; Dave supplied it.)

> > +		if (error)
> > +			return error;
> > +		if (!agbp)
> > +			return -EFSCORRUPTED;
> > +
> > +		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
> > +		if (!rcur) {
> > +			error = -ENOMEM;
> > +			goto out_cur;
> > +		}
> > +	}
> > +	*pcur = rcur;
> > +
> > +	xfs_rmap_ino_owner(&oinfo, owner, whichfork, startoff);
> > +	unwritten = state == XFS_EXT_UNWRITTEN;
> > +	bno = XFS_FSB_TO_AGBNO(rcur->bc_mp, startblock);
> > +
> > +	switch (type) {
> > +	case XFS_RMAP_MAP:
> > +		error = xfs_rmap_map(rcur, bno, blockcount, unwritten, &oinfo);
> > +		break;
> > +	case XFS_RMAP_UNMAP:
> > +		error = xfs_rmap_unmap(rcur, bno, blockcount, unwritten,
> > +				&oinfo);
> > +		break;
> > +	case XFS_RMAP_CONVERT:
> > +		error = xfs_rmap_convert(rcur, bno, blockcount, !unwritten,
> > +				&oinfo);
> > +		break;
> > +	case XFS_RMAP_ALLOC:
> > +		error = __xfs_rmap_alloc(rcur, bno, blockcount, unwritten,
> > +				&oinfo);
> > +		break;
> > +	case XFS_RMAP_FREE:
> > +		error = __xfs_rmap_free(rcur, bno, blockcount, unwritten,
> > +				&oinfo);
> > +		break;
> > +	default:
> > +		ASSERT(0);
> > +		error = -EFSCORRUPTED;
> > +	}
> > +	return error;
> > +
> > +out_cur:
> > +	xfs_trans_brelse(tp, agbp);
> > +
> > +	return error;
> > +}
> > +
> > +/*
> > + * Record a rmap intent; the list is kept sorted first by AG and then by
> > + * increasing age.
> > + */
> > +static int
> > +__xfs_rmap_add(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_defer_ops	*dfops,
> > +	struct xfs_rmap_intent	*ri)
> > +{
> > +	struct xfs_rmap_intent	*new;
> > +
> > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > +		return 0;
> > +
> > +	trace_xfs_rmap_defer(mp, XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock),
> > +			ri->ri_type,
> > +			XFS_FSB_TO_AGBNO(mp, ri->ri_bmap.br_startblock),
> > +			ri->ri_owner, ri->ri_whichfork,
> > +			ri->ri_bmap.br_startoff,
> > +			ri->ri_bmap.br_blockcount,
> > +			ri->ri_bmap.br_state);
> > +
> > +	new = kmem_zalloc(sizeof(struct xfs_rmap_intent), KM_SLEEP | KM_NOFS);
> > +	*new = *ri;
> > +
> > +	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_RMAP, &new->ri_list);
> > +	return 0;
> > +}
> > +
> > +/* Map an extent into a file. */
> > +int
> > +xfs_rmap_map_extent(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_defer_ops	*dfops,
> > +	struct xfs_inode	*ip,
> > +	int			whichfork,
> > +	struct xfs_bmbt_irec	*PREV)
> > +{
> > +	struct xfs_rmap_intent	ri;
> > +
> > +	ri.ri_type = XFS_RMAP_MAP;
> > +	ri.ri_owner = ip->i_ino;
> > +	ri.ri_whichfork = whichfork;
> > +	ri.ri_bmap = *PREV;
> > +
> 
> I think we should probably initialize ri_list as well (maybe turn this
> into an xfs_rmap_init helper).

__xfs_rmap_add calls xfs_defer_add, which calls list_add_tail, which
initializes ri_list.  Could probably just make an _rmap_init helper that
allocates the structure, then have _rmap_*_extent fill out the new intent, and
make the _rmap_add function pass it to _defer_add, which I think is what you're
getting at.

> Also, for some reason it feels to me like the _hasrmapbt() feature check
> should be up at this level (or higher), rather than buried in
> __xfs_rmap_add(). I don't feel too strongly about that if others think
> differently, however.

<shrug> It probably ought to be in the higher level function.

> > +	return __xfs_rmap_add(mp, dfops, &ri);
> > +}
> > +
> > +/* Unmap an extent out of a file. */
> > +int
> > +xfs_rmap_unmap_extent(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_defer_ops	*dfops,
> > +	struct xfs_inode	*ip,
> > +	int			whichfork,
> > +	struct xfs_bmbt_irec	*PREV)
> > +{
> > +	struct xfs_rmap_intent	ri;
> > +
> > +	ri.ri_type = XFS_RMAP_UNMAP;
> > +	ri.ri_owner = ip->i_ino;
> > +	ri.ri_whichfork = whichfork;
> > +	ri.ri_bmap = *PREV;
> > +
> > +	return __xfs_rmap_add(mp, dfops, &ri);
> > +}
> > +
> > +/* Convert a data fork extent from unwritten to real or vice versa. */
> > +int
> > +xfs_rmap_convert_extent(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_defer_ops	*dfops,
> > +	struct xfs_inode	*ip,
> > +	int			whichfork,
> > +	struct xfs_bmbt_irec	*PREV)
> > +{
> > +	struct xfs_rmap_intent	ri;
> > +
> > +	ri.ri_type = XFS_RMAP_CONVERT;
> > +	ri.ri_owner = ip->i_ino;
> > +	ri.ri_whichfork = whichfork;
> > +	ri.ri_bmap = *PREV;
> > +
> > +	return __xfs_rmap_add(mp, dfops, &ri);
> > +}
> > +
> > +/* Schedule the creation of an rmap for non-file data. */
> > +int
> > +xfs_rmap_alloc_defer(
> 
> xfs_rmap_[alloc|free]_extent() like the others..?

Yeah.  The naming has shifted a bit over the past few revisions.

--D

> 
> Brian 
> 
> > +	struct xfs_mount	*mp,
> > +	struct xfs_defer_ops	*dfops,
> > +	xfs_agnumber_t		agno,
> > +	xfs_agblock_t		bno,
> > +	xfs_extlen_t		len,
> > +	__uint64_t		owner)
> > +{
> > +	struct xfs_rmap_intent	ri;
> > +
> > +	ri.ri_type = XFS_RMAP_ALLOC;
> > +	ri.ri_owner = owner;
> > +	ri.ri_whichfork = XFS_DATA_FORK;
> > +	ri.ri_bmap.br_startblock = XFS_AGB_TO_FSB(mp, agno, bno);
> > +	ri.ri_bmap.br_blockcount = len;
> > +	ri.ri_bmap.br_startoff = 0;
> > +	ri.ri_bmap.br_state = XFS_EXT_NORM;
> > +
> > +	return __xfs_rmap_add(mp, dfops, &ri);
> > +}
> > +
> > +/* Schedule the deletion of an rmap for non-file data. */
> > +int
> > +xfs_rmap_free_defer(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_defer_ops	*dfops,
> > +	xfs_agnumber_t		agno,
> > +	xfs_agblock_t		bno,
> > +	xfs_extlen_t		len,
> > +	__uint64_t		owner)
> > +{
> > +	struct xfs_rmap_intent	ri;
> > +
> > +	ri.ri_type = XFS_RMAP_FREE;
> > +	ri.ri_owner = owner;
> > +	ri.ri_whichfork = XFS_DATA_FORK;
> > +	ri.ri_bmap.br_startblock = XFS_AGB_TO_FSB(mp, agno, bno);
> > +	ri.ri_bmap.br_blockcount = len;
> > +	ri.ri_bmap.br_startoff = 0;
> > +	ri.ri_bmap.br_state = XFS_EXT_NORM;
> > +
> > +	return __xfs_rmap_add(mp, dfops, &ri);
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> > index aff60dc..5df406e 100644
> > --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> > +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> > @@ -106,4 +106,28 @@ struct xfs_rmap_intent {
> >  	struct xfs_bmbt_irec			ri_bmap;
> >  };
> >  
> > +/* functions for updating the rmapbt based on bmbt map/unmap operations */
> > +int xfs_rmap_map_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> > +		struct xfs_inode *ip, int whichfork,
> > +		struct xfs_bmbt_irec *imap);
> > +int xfs_rmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> > +		struct xfs_inode *ip, int whichfork,
> > +		struct xfs_bmbt_irec *imap);
> > +int xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> > +		struct xfs_inode *ip, int whichfork,
> > +		struct xfs_bmbt_irec *imap);
> > +int xfs_rmap_alloc_defer(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> > +		xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
> > +		__uint64_t owner);
> > +int xfs_rmap_free_defer(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> > +		xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
> > +		__uint64_t owner);
> > +
> > +void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
> > +		struct xfs_btree_cur *rcur, int error);
> > +int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
> > +		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
> > +		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
> > +		xfs_exntst_t state, struct xfs_btree_cur **pcur);
> > +
> >  #endif	/* __XFS_RMAP_BTREE_H__ */
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 62d194e..450fd49 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -41,6 +41,7 @@
> >  #include "xfs_trace.h"
> >  #include "xfs_icache.h"
> >  #include "xfs_log.h"
> > +#include "xfs_rmap_btree.h"
> >  
> >  /* Kernel only BMAP related definitions and functions */
> >  
> > diff --git a/fs/xfs/xfs_defer_item.c b/fs/xfs/xfs_defer_item.c
> > index dbd10fc..9ed060d 100644
> > --- a/fs/xfs/xfs_defer_item.c
> > +++ b/fs/xfs/xfs_defer_item.c
> > @@ -213,7 +213,8 @@ xfs_rmap_update_finish_item(
> >  			rmap->ri_bmap.br_startoff,
> >  			rmap->ri_bmap.br_startblock,
> >  			rmap->ri_bmap.br_blockcount,
> > -			rmap->ri_bmap.br_state);
> > +			rmap->ri_bmap.br_state,
> > +			(struct xfs_btree_cur **)state);
> >  	kmem_free(rmap);
> >  	return error;
> >  }
> > @@ -225,6 +226,9 @@ xfs_rmap_update_finish_cleanup(
> >  	void			*state,
> >  	int			error)
> >  {
> > +	struct xfs_btree_cur	*rcur = state;
> > +
> > +	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> >  }
> >  
> >  /* Abort all pending RUIs. */
> > diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> > index ee4680e..6bc614c 100644
> > --- a/fs/xfs/xfs_error.h
> > +++ b/fs/xfs/xfs_error.h
> > @@ -91,7 +91,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
> >  #define XFS_ERRTAG_DIOWRITE_IOERR			20
> >  #define XFS_ERRTAG_BMAPIFORMAT				21
> >  #define XFS_ERRTAG_FREE_EXTENT				22
> > -#define XFS_ERRTAG_MAX					23
> > +#define XFS_ERRTAG_RMAP_FINISH_ONE			23
> > +#define XFS_ERRTAG_MAX					24
> >  
> >  /*
> >   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> > @@ -119,6 +120,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
> >  #define XFS_RANDOM_DIOWRITE_IOERR			(XFS_RANDOM_DEFAULT/10)
> >  #define	XFS_RANDOM_BMAPIFORMAT				XFS_RANDOM_DEFAULT
> >  #define XFS_RANDOM_FREE_EXTENT				1
> > +#define XFS_RANDOM_RMAP_FINISH_ONE			1
> >  
> >  #ifdef DEBUG
> >  extern int xfs_error_test_active;
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index c9fe0c4..f7f9635 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -45,6 +45,7 @@
> >  #include "xfs_error.h"
> >  #include "xfs_dir2.h"
> >  #include "xfs_rmap_item.h"
> > +#include "xfs_rmap_btree.h"
> >  
> >  #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
> >  
> > @@ -4486,6 +4487,12 @@ xlog_recover_process_rui(
> >  	struct xfs_map_extent		*rmap;
> >  	xfs_fsblock_t			startblock_fsb;
> >  	bool				op_ok;
> > +	struct xfs_rud_log_item		*rudp;
> > +	enum xfs_rmap_intent_type	type;
> > +	int				whichfork;
> > +	xfs_exntst_t			state;
> > +	struct xfs_trans		*tp;
> > +	struct xfs_btree_cur		*rcur = NULL;
> >  
> >  	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
> >  
> > @@ -4528,9 +4535,54 @@ xlog_recover_process_rui(
> >  		}
> >  	}
> >  
> > -	/* XXX: do nothing for now */
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> > +	if (error)
> > +		return error;
> > +	rudp = xfs_trans_get_rud(tp, ruip, ruip->rui_format.rui_nextents);
> > +
> > +	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
> > +		rmap = &(ruip->rui_format.rui_extents[i]);
> > +		state = (rmap->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
> > +				XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
> > +		whichfork = (rmap->me_flags & XFS_RMAP_EXTENT_ATTR_FORK) ?
> > +				XFS_ATTR_FORK : XFS_DATA_FORK;
> > +		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
> > +		case XFS_RMAP_EXTENT_MAP:
> > +			type = XFS_RMAP_MAP;
> > +			break;
> > +		case XFS_RMAP_EXTENT_UNMAP:
> > +			type = XFS_RMAP_UNMAP;
> > +			break;
> > +		case XFS_RMAP_EXTENT_CONVERT:
> > +			type = XFS_RMAP_CONVERT;
> > +			break;
> > +		case XFS_RMAP_EXTENT_ALLOC:
> > +			type = XFS_RMAP_ALLOC;
> > +			break;
> > +		case XFS_RMAP_EXTENT_FREE:
> > +			type = XFS_RMAP_FREE;
> > +			break;
> > +		default:
> > +			error = -EFSCORRUPTED;
> > +			goto abort_error;
> > +		}
> > +		error = xfs_trans_log_finish_rmap_update(tp, rudp, type,
> > +				rmap->me_owner, whichfork,
> > +				rmap->me_startoff, rmap->me_startblock,
> > +				rmap->me_len, state, &rcur);
> > +		if (error)
> > +			goto abort_error;
> > +
> > +	}
> > +
> > +	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> >  	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
> > -	xfs_rui_release(ruip);
> > +	error = xfs_trans_commit(tp);
> > +	return error;
> > +
> > +abort_error:
> > +	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> > +	xfs_trans_cancel(tp);
> >  	return error;
> >  }
> >  
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index c48be63..f59d934 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -244,12 +244,13 @@ void xfs_trans_log_start_rmap_update(struct xfs_trans *tp,
> >  		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
> >  		xfs_exntst_t state);
> >  
> > +struct xfs_btree_cur;
> >  struct xfs_rud_log_item *xfs_trans_get_rud(struct xfs_trans *tp,
> >  		struct xfs_rui_log_item *ruip, uint nextents);
> >  int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
> >  		struct xfs_rud_log_item *rudp, enum xfs_rmap_intent_type type,
> >  		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
> >  		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
> > -		xfs_exntst_t state);
> > +		xfs_exntst_t state, struct xfs_btree_cur **pcur);
> >  
> >  #endif	/* __XFS_TRANS_H__ */
> > diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
> > index b55a725..0c0df18 100644
> > --- a/fs/xfs/xfs_trans_rmap.c
> > +++ b/fs/xfs/xfs_trans_rmap.c
> > @@ -170,14 +170,15 @@ xfs_trans_log_finish_rmap_update(
> >  	xfs_fileoff_t			startoff,
> >  	xfs_fsblock_t			startblock,
> >  	xfs_filblks_t			blockcount,
> > -	xfs_exntst_t			state)
> > +	xfs_exntst_t			state,
> > +	struct xfs_btree_cur		**pcur)
> >  {
> >  	uint				next_extent;
> >  	struct xfs_map_extent		*rmap;
> >  	int				error;
> >  
> > -	/* XXX: actually finish the rmap update here */
> > -	error = -EFSCORRUPTED;
> > +	error = xfs_rmap_finish_one(tp, type, owner, whichfork, startoff,
> > +			startblock, blockcount, state, pcur);
> >  
> >  	/*
> >  	 * Mark the transaction dirty, even on error. This ensures the
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22478 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030940AbdDZVig (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 17:38:36 -0400
Date: Wed, 26 Apr 2017 14:37:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: try to avoid blowing out the transaction
 reservation when bunmaping a shared extent
Message-ID: <20170426213731.GC23371@birch.djwong.org>
References: <20170425020954.GV23371@birch.djwong.org>
 <20170426135912.GB42456@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170426135912.GB42456@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Wed, Apr 26, 2017 at 09:59:14AM -0400, Brian Foster wrote:
> On Mon, Apr 24, 2017 at 07:09:54PM -0700, Darrick J. Wong wrote:
> > In a pathological scenario where we are trying to bunmapi a single
> > extent in which every other block is shared, it's possible that trying
> > to unmap the entire large extent in a single transaction can generate so
> > many EFIs that we overflow the transaction reservation.
> > 
> > Therefore, use a heuristic to guess at the number of blocks we can
> > safely unmap from a reflink file's data fork in an single transaction.
> > This should prevent problems such as the log head slamming into the tail
> > and ASSERTs that trigger because we've exceeded the transaction
> > reservation.
> > 
> > Note that since bunmapi can fail to unmap the entire range, we must also
> > teach the deferred unmap code to roll into a new transaction whenever we
> > get low on reservation.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c     |   38 ++++++++++++++++++++++++++++++--------
> >  fs/xfs/libxfs/xfs_bmap.h     |    2 +-
> >  fs/xfs/libxfs/xfs_refcount.c |   10 +---------
> >  fs/xfs/libxfs/xfs_refcount.h |   16 ++++++++++++++++
> >  fs/xfs/xfs_bmap_item.c       |   17 +++++++++++++++--
> >  fs/xfs/xfs_trans.h           |    2 +-
> >  fs/xfs/xfs_trans_bmap.c      |   11 +++++++++--
> >  7 files changed, 73 insertions(+), 23 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index f02eb76..1e79fb5 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5435,6 +5435,7 @@ __xfs_bunmapi(
> >  	int			whichfork;	/* data or attribute fork */
> >  	xfs_fsblock_t		sum;
> >  	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
> > +	xfs_fileoff_t		max_len;
> >  
> >  	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
> >  
> > @@ -5456,6 +5457,16 @@ __xfs_bunmapi(
> >  	ASSERT(len > 0);
> >  	ASSERT(nexts >= 0);
> >  
> > +	/*
> > +	 * Guesstimate how many blocks we can unmap without running the risk of
> > +	 * blowing out the transaction with a mix of EFIs and reflink
> > +	 * adjustments.
> > +	 */
> > +	if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK)
> > +		max_len = min(len, xfs_refcount_max_unmap(tp->t_log_res));
> > +	else
> > +		max_len = len;
> > +
> 
> Hmm... on first glance, this seems a bit overcomplicated, particularly
> the non-determinism of how many blocks we can free being based on an
> estimation of an already estimated transaction reservation.
> 
> Since we already have a transaction reservation that is calculated based
> on a fixed number of modifications (i.e., 2 extent removals) and an
> associated extent count parameter. Would it address the problem if we
> considered shared extent boundaries as physical extent boundaries for
> reflinked files? E.g., unmap of an extent with two total blocks and one
> shared block is effectively equivalent to a file with two (discontig)
> single block extents..? Just a thought.

That's so shockingly obvious I don't know why it didn't occur to me.
Uh, I'll go give that a try with that horrid generic/931 testcase that
I sent to the list a couple of weeks ago. :)

--D

> 
> Brian
> 
> >  	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
> >  	    (error = xfs_iread_extents(tp, ip, whichfork)))
> >  		return error;
> > @@ -5500,7 +5511,7 @@ __xfs_bunmapi(
> >  
> >  	extno = 0;
> >  	while (bno != (xfs_fileoff_t)-1 && bno >= start && lastx >= 0 &&
> > -	       (nexts == 0 || extno < nexts)) {
> > +	       (nexts == 0 || extno < nexts) && max_len > 0) {
> >  		/*
> >  		 * Is the found extent after a hole in which bno lives?
> >  		 * Just back up to the previous extent, if so.
> > @@ -5532,6 +5543,15 @@ __xfs_bunmapi(
> >  		}
> >  		if (del.br_startoff + del.br_blockcount > bno + 1)
> >  			del.br_blockcount = bno + 1 - del.br_startoff;
> > +
> > +		/* How much can we safely unmap? */
> > +		if (max_len < del.br_blockcount) {
> > +			del.br_startoff += del.br_blockcount - max_len;
> > +			if (!wasdel)
> > +				del.br_startblock += del.br_blockcount - max_len;
> > +			del.br_blockcount = max_len;
> > +		}
> > +
> >  		sum = del.br_startblock + del.br_blockcount;
> >  		if (isrt &&
> >  		    (mod = do_mod(sum, mp->m_sb.sb_rextsize))) {
> > @@ -5708,6 +5728,7 @@ __xfs_bunmapi(
> >  		if (!isrt && wasdel)
> >  			xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount, false);
> >  
> > +		max_len -= del.br_blockcount;
> >  		bno = del.br_startoff - 1;
> >  nodelete:
> >  		/*
> > @@ -6473,15 +6494,16 @@ xfs_bmap_finish_one(
> >  	int				whichfork,
> >  	xfs_fileoff_t			startoff,
> >  	xfs_fsblock_t			startblock,
> > -	xfs_filblks_t			blockcount,
> > +	xfs_filblks_t			*blockcount,
> >  	xfs_exntst_t			state)
> >  {
> > -	int				error = 0, done;
> > +	xfs_fsblock_t			firstfsb;
> > +	int				error = 0;
> >  
> >  	trace_xfs_bmap_deferred(tp->t_mountp,
> >  			XFS_FSB_TO_AGNO(tp->t_mountp, startblock), type,
> >  			XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
> > -			ip->i_ino, whichfork, startoff, blockcount, state);
> > +			ip->i_ino, whichfork, startoff, *blockcount, state);
> >  
> >  	if (WARN_ON_ONCE(whichfork != XFS_DATA_FORK))
> >  		return -EFSCORRUPTED;
> > @@ -6493,13 +6515,13 @@ xfs_bmap_finish_one(
> >  
> >  	switch (type) {
> >  	case XFS_BMAP_MAP:
> > -		error = xfs_bmapi_remap(tp, ip, startoff, blockcount,
> > +		error = xfs_bmapi_remap(tp, ip, startoff, *blockcount,
> >  				startblock, dfops);
> > +		*blockcount = 0;
> >  		break;
> >  	case XFS_BMAP_UNMAP:
> > -		error = xfs_bunmapi(tp, ip, startoff, blockcount,
> > -				XFS_BMAPI_REMAP, 1, &startblock, dfops, &done);
> > -		ASSERT(done);
> > +		error = __xfs_bunmapi(tp, ip, startoff, blockcount,
> > +				XFS_BMAPI_REMAP, 1, &firstfsb, dfops);
> >  		break;
> >  	default:
> >  		ASSERT(0);
> > diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> > index c35a14f..851982a 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.h
> > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > @@ -271,7 +271,7 @@ struct xfs_bmap_intent {
> >  int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_defer_ops *dfops,
> >  		struct xfs_inode *ip, enum xfs_bmap_intent_type type,
> >  		int whichfork, xfs_fileoff_t startoff, xfs_fsblock_t startblock,
> > -		xfs_filblks_t blockcount, xfs_exntst_t state);
> > +		xfs_filblks_t *blockcount, xfs_exntst_t state);
> >  int	xfs_bmap_map_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> >  		struct xfs_inode *ip, struct xfs_bmbt_irec *imap);
> >  int	xfs_bmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > index b177ef3..29dcde3 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > @@ -784,14 +784,6 @@ xfs_refcount_merge_extents(
> >  }
> >  
> >  /*
> > - * While we're adjusting the refcounts records of an extent, we have
> > - * to keep an eye on the number of extents we're dirtying -- run too
> > - * many in a single transaction and we'll exceed the transaction's
> > - * reservation and crash the fs.  Each record adds 12 bytes to the
> > - * log (plus any key updates) so we'll conservatively assume 24 bytes
> > - * per record.  We must also leave space for btree splits on both ends
> > - * of the range and space for the CUD and a new CUI.
> > - *
> >   * XXX: This is a pretty hand-wavy estimate.  The penalty for guessing
> >   * true incorrectly is a shutdown FS; the penalty for guessing false
> >   * incorrectly is more transaction rolls than might be necessary.
> > @@ -822,7 +814,7 @@ xfs_refcount_still_have_space(
> >  	else if (overhead > cur->bc_tp->t_log_res)
> >  		return false;
> >  	return  cur->bc_tp->t_log_res - overhead >
> > -		cur->bc_private.a.priv.refc.nr_ops * 32;
> > +		cur->bc_private.a.priv.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
> > index 098dc66..eafb9d1 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.h
> > +++ b/fs/xfs/libxfs/xfs_refcount.h
> > @@ -67,4 +67,20 @@ extern int xfs_refcount_free_cow_extent(struct xfs_mount *mp,
> >  extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
> >  		xfs_agnumber_t agno);
> >  
> > +/*
> > + * While we're adjusting the refcounts records of an extent, we have
> > + * to keep an eye on the number of extents we're dirtying -- run too
> > + * many in a single transaction and we'll exceed the transaction's
> > + * reservation and crash the fs.  Each record adds 12 bytes to the
> > + * log (plus any key updates) so we'll conservatively assume 32 bytes
> > + * per record.  We must also leave space for btree splits on both ends
> > + * of the range and space for the CUD and a new CUI.
> > + */
> > +#define XFS_REFCOUNT_ITEM_OVERHEAD	32
> > +
> > +static inline xfs_fileoff_t xfs_refcount_max_unmap(int log_res)
> > +{
> > +	return (log_res * 3 / 4) / XFS_REFCOUNT_ITEM_OVERHEAD;
> > +}
> > +
> >  #endif	/* __XFS_REFCOUNT_H__ */
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 378f144..89908bb 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -396,6 +396,7 @@ xfs_bui_recover(
> >  	struct xfs_map_extent		*bmap;
> >  	xfs_fsblock_t			startblock_fsb;
> >  	xfs_fsblock_t			inode_fsb;
> > +	xfs_filblks_t			count;
> >  	bool				op_ok;
> >  	struct xfs_bud_log_item		*budp;
> >  	enum xfs_bmap_intent_type	type;
> > @@ -404,6 +405,7 @@ xfs_bui_recover(
> >  	struct xfs_trans		*tp;
> >  	struct xfs_inode		*ip = NULL;
> >  	struct xfs_defer_ops		dfops;
> > +	struct xfs_bmbt_irec		irec;
> >  	xfs_fsblock_t			firstfsb;
> >  	unsigned int			resblks;
> >  
> > @@ -483,13 +485,24 @@ xfs_bui_recover(
> >  	}
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > +	count = bmap->me_len;
> >  	error = xfs_trans_log_finish_bmap_update(tp, budp, &dfops, type,
> >  			ip, whichfork, bmap->me_startoff,
> > -			bmap->me_startblock, bmap->me_len,
> > -			state);
> > +			bmap->me_startblock, &count, state);
> >  	if (error)
> >  		goto err_dfops;
> >  
> > +	if (count > 0) {
> > +		ASSERT(type == XFS_BMAP_UNMAP);
> > +		irec.br_startblock = bmap->me_startblock;
> > +		irec.br_blockcount = count;
> > +		irec.br_startoff = bmap->me_startoff;
> > +		irec.br_state = state;
> > +		error = xfs_bmap_unmap_extent(tp->t_mountp, &dfops, ip, &irec);
> > +		if (error)
> > +			goto err_dfops;
> > +	}
> > +
> >  	/* Finish transaction, free inodes. */
> >  	error = xfs_defer_finish(&tp, &dfops, NULL);
> >  	if (error)
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index a07acbf..08923e5 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -275,6 +275,6 @@ int xfs_trans_log_finish_bmap_update(struct xfs_trans *tp,
> >  		struct xfs_bud_log_item *rudp, struct xfs_defer_ops *dfops,
> >  		enum xfs_bmap_intent_type type, struct xfs_inode *ip,
> >  		int whichfork, xfs_fileoff_t startoff, xfs_fsblock_t startblock,
> > -		xfs_filblks_t blockcount, xfs_exntst_t state);
> > +		xfs_filblks_t *blockcount, xfs_exntst_t state);
> >  
> >  #endif	/* __XFS_TRANS_H__ */
> > diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
> > index 6408e7d..14543d9 100644
> > --- a/fs/xfs/xfs_trans_bmap.c
> > +++ b/fs/xfs/xfs_trans_bmap.c
> > @@ -63,7 +63,7 @@ xfs_trans_log_finish_bmap_update(
> >  	int				whichfork,
> >  	xfs_fileoff_t			startoff,
> >  	xfs_fsblock_t			startblock,
> > -	xfs_filblks_t			blockcount,
> > +	xfs_filblks_t			*blockcount,
> >  	xfs_exntst_t			state)
> >  {
> >  	int				error;
> > @@ -196,16 +196,23 @@ xfs_bmap_update_finish_item(
> >  	void				**state)
> >  {
> >  	struct xfs_bmap_intent		*bmap;
> > +	xfs_filblks_t			count;
> >  	int				error;
> >  
> >  	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
> > +	count = bmap->bi_bmap.br_blockcount;
> >  	error = xfs_trans_log_finish_bmap_update(tp, done_item, dop,
> >  			bmap->bi_type,
> >  			bmap->bi_owner, bmap->bi_whichfork,
> >  			bmap->bi_bmap.br_startoff,
> >  			bmap->bi_bmap.br_startblock,
> > -			bmap->bi_bmap.br_blockcount,
> > +			&count,
> >  			bmap->bi_bmap.br_state);
> > +	if (!error && count > 0) {
> > +		ASSERT(bmap->bi_type == XFS_BMAP_UNMAP);
> > +		bmap->bi_bmap.br_blockcount = count;
> > +		return -EAGAIN;
> > +	}
> >  	kmem_free(bmap);
> >  	return error;
> >  }
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A97AD7CA1
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 07:31:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5CFA28F8035
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 05:31:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xlx2F7dyRIrDE6M5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 05:31:49 -0700 (PDT)
Date: Tue, 28 Jun 2016 08:31:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 012/119] xfs: during btree split, save new block key &
	ptr for future insertion
Message-ID: <20160628123146.GA4212@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612634887.12839.6210102273046676244.stgit@birch.djwong.org>
	<20160621130043.GA62352@bfoster.bfoster>
	<20160627223023.GD4921@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160627223023.GD4921@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Mon, Jun 27, 2016 at 03:30:23PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 21, 2016 at 09:00:45AM -0400, Brian Foster wrote:
> > On Thu, Jun 16, 2016 at 06:19:08PM -0700, Darrick J. Wong wrote:
> > > When a btree block has to be split, we pass the new block's ptr from
> > > xfs_btree_split() back to xfs_btree_insert() via a pointer parameter;
> > > however, we pass the block's key through the cursor's record.  It is a
> > > little weird to "initialize" a record from a key since the non-key
> > > attributes will have garbage values.
> > > 
> > > When we go to add support for interval queries, we have to be able to
> > > pass the lowest and highest keys accessible via a pointer.  There's no
> > > clean way to pass this back through the cursor's record field.
> > > Therefore, pass the key directly back to xfs_btree_insert() the same
> > > way that we pass the btree_ptr.
> > > 
> > > As a bonus, we no longer need init_rec_from_key and can drop it from the
> > > codebase.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc_btree.c  |   12 ----------
> > >  fs/xfs/libxfs/xfs_bmap_btree.c   |   12 ----------
> > >  fs/xfs/libxfs/xfs_btree.c        |   44 +++++++++++++++++++-------------------
> > >  fs/xfs/libxfs/xfs_btree.h        |    2 --
> > >  fs/xfs/libxfs/xfs_ialloc_btree.c |   10 ---------
> > >  5 files changed, 22 insertions(+), 58 deletions(-)
> > > 
> > > 
> > ...
> > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > index 046fbcf..a096539 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > ...
> > > @@ -2929,16 +2927,16 @@ xfs_btree_insrec(
> > >  	struct xfs_btree_cur	*cur,	/* btree cursor */
> > >  	int			level,	/* level to insert record at */
> > >  	union xfs_btree_ptr	*ptrp,	/* i/o: block number inserted */
> > > -	union xfs_btree_rec	*recp,	/* i/o: record data inserted */
> > > +	union xfs_btree_key	*key,	/* i/o: block key for ptrp */
> > >  	struct xfs_btree_cur	**curp,	/* output: new cursor replacing cur */
> > >  	int			*stat)	/* success/failure */
> > >  {
> > >  	struct xfs_btree_block	*block;	/* btree block */
> > >  	struct xfs_buf		*bp;	/* buffer for block */
> > > -	union xfs_btree_key	key;	/* btree key */
> > >  	union xfs_btree_ptr	nptr;	/* new block ptr */
> > >  	struct xfs_btree_cur	*ncur;	/* new btree cursor */
> > > -	union xfs_btree_rec	nrec;	/* new record count */
> > > +	union xfs_btree_key	nkey;	/* new block key */
> > > +	union xfs_btree_rec	rec;	/* record to insert */
> > >  	int			optr;	/* old key/record index */
> > >  	int			ptr;	/* key/record index */
> > >  	int			numrecs;/* number of records */
> > > @@ -2947,8 +2945,14 @@ xfs_btree_insrec(
> > >  	int			i;
> > >  #endif
> > >  
> > > +	/* Make a key out of the record data to be inserted, and save it. */
> > > +	if (level == 0) {
> > > +		cur->bc_ops->init_rec_from_cur(cur, &rec);
> > > +		cur->bc_ops->init_key_from_rec(key, &rec);
> > > +	}
> > 
> > The level == 0 check looks a bit hacky to me. IOW, I think it's cleaner
> > that the key is initialized once in the caller rather than check for a
> > particular iteration down in xfs_btree_insrec(). That said,
> > xfs_btree_insrec() still needs rec initialized in the level == 0 case.
> > 
> > I wonder if we could create an inline xfs_btree_init_key_from_cur()
> > helper to combine the above calls, invoke it once in xfs_btree_insert(),
> > then push down the ->init_rec_from_cur() calls to the contexts further
> > down in this function where rec is actually required. There are only two
> > and one of them is DEBUG code. Thoughts?
> 
> How about I make btree_insert set both &key and &rec at the start and
> pass them both into btree_insrec?  That would eliminate the hacky check
> above and fix the dummy tracing hook too, in case it ever does anything.
> 

That seems fine to me.

Brian

> > 
> > > +
> > >  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > > -	XFS_BTREE_TRACE_ARGIPR(cur, level, *ptrp, recp);
> > > +	XFS_BTREE_TRACE_ARGIPR(cur, level, *ptrp, &rec);
> > >  
> > 
> > So these look like unimplemented dummy tracing hooks. It sounds like
> > previously rec could have a junk value after a btree split, but now it
> > looks like rec is junk for every non-zero level. Kind of annoying, I
> > wonder if we can just kill these.. :/
> 
> <shrug> I have no opinion either way. :)
> 
> --D
> > 
> > Brian
> > 
> > >  	ncur = NULL;
> > >  
> > > @@ -2973,9 +2977,6 @@ xfs_btree_insrec(
> > >  		return 0;
> > >  	}
> > >  
> > > -	/* Make a key out of the record data to be inserted, and save it. */
> > > -	cur->bc_ops->init_key_from_rec(&key, recp);
> > > -
> > >  	optr = ptr;
> > >  
> > >  	XFS_BTREE_STATS_INC(cur, insrec);
> > > @@ -2992,10 +2993,10 @@ xfs_btree_insrec(
> > >  	/* Check that the new entry is being inserted in the right place. */
> > >  	if (ptr <= numrecs) {
> > >  		if (level == 0) {
> > > -			ASSERT(cur->bc_ops->recs_inorder(cur, recp,
> > > +			ASSERT(cur->bc_ops->recs_inorder(cur, &rec,
> > >  				xfs_btree_rec_addr(cur, ptr, block)));
> > >  		} else {
> > > -			ASSERT(cur->bc_ops->keys_inorder(cur, &key,
> > > +			ASSERT(cur->bc_ops->keys_inorder(cur, key,
> > >  				xfs_btree_key_addr(cur, ptr, block)));
> > >  		}
> > >  	}
> > > @@ -3008,7 +3009,7 @@ xfs_btree_insrec(
> > >  	xfs_btree_set_ptr_null(cur, &nptr);
> > >  	if (numrecs == cur->bc_ops->get_maxrecs(cur, level)) {
> > >  		error = xfs_btree_make_block_unfull(cur, level, numrecs,
> > > -					&optr, &ptr, &nptr, &ncur, &nrec, stat);
> > > +					&optr, &ptr, &nptr, &ncur, &nkey, stat);
> > >  		if (error || *stat == 0)
> > >  			goto error0;
> > >  	}
> > > @@ -3058,7 +3059,7 @@ xfs_btree_insrec(
> > >  #endif
> > >  
> > >  		/* Now put the new data in, bump numrecs and log it. */
> > > -		xfs_btree_copy_keys(cur, kp, &key, 1);
> > > +		xfs_btree_copy_keys(cur, kp, key, 1);
> > >  		xfs_btree_copy_ptrs(cur, pp, ptrp, 1);
> > >  		numrecs++;
> > >  		xfs_btree_set_numrecs(block, numrecs);
> > > @@ -3079,7 +3080,7 @@ xfs_btree_insrec(
> > >  		xfs_btree_shift_recs(cur, rp, 1, numrecs - ptr + 1);
> > >  
> > >  		/* Now put the new data in, bump numrecs and log it. */
> > > -		xfs_btree_copy_recs(cur, rp, recp, 1);
> > > +		xfs_btree_copy_recs(cur, rp, &rec, 1);
> > >  		xfs_btree_set_numrecs(block, ++numrecs);
> > >  		xfs_btree_log_recs(cur, bp, ptr, numrecs);
> > >  #ifdef DEBUG
> > > @@ -3095,7 +3096,7 @@ xfs_btree_insrec(
> > >  
> > >  	/* If we inserted at the start of a block, update the parents' keys. */
> > >  	if (optr == 1) {
> > > -		error = xfs_btree_updkey(cur, &key, level + 1);
> > > +		error = xfs_btree_updkey(cur, key, level + 1);
> > >  		if (error)
> > >  			goto error0;
> > >  	}
> > > @@ -3105,7 +3106,7 @@ xfs_btree_insrec(
> > >  	 * we are at the far right edge of the tree, update it.
> > >  	 */
> > >  	if (xfs_btree_is_lastrec(cur, block, level)) {
> > > -		cur->bc_ops->update_lastrec(cur, block, recp,
> > > +		cur->bc_ops->update_lastrec(cur, block, &rec,
> > >  					    ptr, LASTREC_INSREC);
> > >  	}
> > >  
> > > @@ -3115,7 +3116,7 @@ xfs_btree_insrec(
> > >  	 */
> > >  	*ptrp = nptr;
> > >  	if (!xfs_btree_ptr_is_null(cur, &nptr)) {
> > > -		*recp = nrec;
> > > +		*key = nkey;
> > >  		*curp = ncur;
> > >  	}
> > >  
> > > @@ -3146,14 +3147,13 @@ xfs_btree_insert(
> > >  	union xfs_btree_ptr	nptr;	/* new block number (split result) */
> > >  	struct xfs_btree_cur	*ncur;	/* new cursor (split result) */
> > >  	struct xfs_btree_cur	*pcur;	/* previous level's cursor */
> > > -	union xfs_btree_rec	rec;	/* record to insert */
> > > +	union xfs_btree_key	key;	/* key of block to insert */
> > >  
> > >  	level = 0;
> > >  	ncur = NULL;
> > >  	pcur = cur;
> > >  
> > >  	xfs_btree_set_ptr_null(cur, &nptr);
> > > -	cur->bc_ops->init_rec_from_cur(cur, &rec);
> > >  
> > >  	/*
> > >  	 * Loop going up the tree, starting at the leaf level.
> > > @@ -3165,7 +3165,7 @@ xfs_btree_insert(
> > >  		 * Insert nrec/nptr into this level of the tree.
> > >  		 * Note if we fail, nptr will be null.
> > >  		 */
> > > -		error = xfs_btree_insrec(pcur, level, &nptr, &rec, &ncur, &i);
> > > +		error = xfs_btree_insrec(pcur, level, &nptr, &key, &ncur, &i);
> > >  		if (error) {
> > >  			if (pcur != cur)
> > >  				xfs_btree_del_cursor(pcur, XFS_BTREE_ERROR);
> > > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > > index b955e5d..b99c018 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.h
> > > +++ b/fs/xfs/libxfs/xfs_btree.h
> > > @@ -158,8 +158,6 @@ struct xfs_btree_ops {
> > >  	/* init values of btree structures */
> > >  	void	(*init_key_from_rec)(union xfs_btree_key *key,
> > >  				     union xfs_btree_rec *rec);
> > > -	void	(*init_rec_from_key)(union xfs_btree_key *key,
> > > -				     union xfs_btree_rec *rec);
> > >  	void	(*init_rec_from_cur)(struct xfs_btree_cur *cur,
> > >  				     union xfs_btree_rec *rec);
> > >  	void	(*init_ptr_from_cur)(struct xfs_btree_cur *cur,
> > > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > index 89c21d7..88da2ad 100644
> > > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > @@ -146,14 +146,6 @@ xfs_inobt_init_key_from_rec(
> > >  }
> > >  
> > >  STATIC void
> > > -xfs_inobt_init_rec_from_key(
> > > -	union xfs_btree_key	*key,
> > > -	union xfs_btree_rec	*rec)
> > > -{
> > > -	rec->inobt.ir_startino = key->inobt.ir_startino;
> > > -}
> > > -
> > > -STATIC void
> > >  xfs_inobt_init_rec_from_cur(
> > >  	struct xfs_btree_cur	*cur,
> > >  	union xfs_btree_rec	*rec)
> > > @@ -314,7 +306,6 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
> > >  	.get_minrecs		= xfs_inobt_get_minrecs,
> > >  	.get_maxrecs		= xfs_inobt_get_maxrecs,
> > >  	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
> > > -	.init_rec_from_key	= xfs_inobt_init_rec_from_key,
> > >  	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
> > >  	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
> > >  	.key_diff		= xfs_inobt_key_diff,
> > > @@ -336,7 +327,6 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
> > >  	.get_minrecs		= xfs_inobt_get_minrecs,
> > >  	.get_maxrecs		= xfs_inobt_get_maxrecs,
> > >  	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
> > > -	.init_rec_from_key	= xfs_inobt_init_rec_from_key,
> > >  	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
> > >  	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
> > >  	.key_diff		= xfs_inobt_key_diff,
> > > 
> > > _______________________________________________
> > > xfs mailing list
> > > xfs@oss.sgi.com
> > > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37398 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbeKUDAR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 22:00:17 -0500
Date: Tue, 20 Nov 2018 08:30:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] xfs: remove xfs_rmap_ag_owner and friends
Message-ID: <20181120163009.GB6792@magnolia>
References: <154171920164.30818.2178553842722589349.stgit@magnolia>
 <154171921390.30818.8627531125794999636.stgit@magnolia>
 <20181120162008.GB48509@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120162008.GB48509@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 11:20:09AM -0500, Brian Foster wrote:
> On Thu, Nov 08, 2018 at 03:20:13PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Owner information for static fs metadata can be defined readonly at
> > build time because it never changes across filesystems.  This enables us
> > to reduce stack usage (particularly in scrub) because we can use the
> > statically defined oinfo structures.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.c             |    9 ++++-----
> >  fs/xfs/libxfs/xfs_alloc.c          |    8 +++-----
> >  fs/xfs/libxfs/xfs_bmap.c           |    4 ++--
> >  fs/xfs/libxfs/xfs_ialloc.c         |    8 +++-----
> >  fs/xfs/libxfs/xfs_ialloc_btree.c   |    7 ++-----
> >  fs/xfs/libxfs/xfs_refcount_btree.c |    6 ++----
> >  fs/xfs/libxfs/xfs_rmap.c           |   28 ++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_rmap.h           |   34 ++++++++++------------------------
> >  fs/xfs/scrub/agheader.c            |   25 +++++++------------------
> >  fs/xfs/scrub/agheader_repair.c     |    5 ++---
> >  fs/xfs/scrub/alloc.c               |    4 +---
> >  fs/xfs/scrub/ialloc.c              |   28 +++++++++-------------------
> >  fs/xfs/scrub/inode.c               |    4 +---
> >  fs/xfs/scrub/refcount.c            |   15 +++++----------
> >  fs/xfs/scrub/repair.c              |    4 +---
> >  fs/xfs/scrub/rmap.c                |    5 +----
> >  fs/xfs/xfs_extfree_item.c          |    5 ++---
> >  17 files changed, 83 insertions(+), 116 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index bce46fa0ee38..0f5e10a0c024 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -1594,7 +1594,6 @@ xfs_alloc_ag_vextent_small(
> >  	xfs_extlen_t	*flenp,	/* result length */
> >  	int		*stat)	/* status: 0-freelist, 1-normal/none */
> >  {
> > -	struct xfs_owner_info	oinfo;
> >  	int		error;
> >  	xfs_agblock_t	fbno;
> >  	xfs_extlen_t	flen;
> > @@ -1648,9 +1647,8 @@ xfs_alloc_ag_vextent_small(
> >  			 * doesn't live in the free space, we need to clear
> >  			 * out the OWN_AG rmap.
> >  			 */
> > -			xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> >  			error = xfs_rmap_free(args->tp, args->agbp, args->agno,
> > -					fbno, 1, &oinfo);
> > +					fbno, 1, &XFS_RMAP_OINFO_AG);
> >  			if (error)
> >  				goto error0;
> >  
> > @@ -2315,9 +2313,9 @@ xfs_alloc_fix_freelist(
> >  	 */
> >  	memset(&targs, 0, sizeof(targs));
> >  	if (flags & XFS_ALLOC_FLAG_NORMAP)
> > -		xfs_rmap_skip_owner_update(&targs.oinfo);
> > +		targs.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> >  	else
> > -		xfs_rmap_ag_owner(&targs.oinfo, XFS_RMAP_OWN_AG);
> > +		targs.oinfo = XFS_RMAP_OINFO_AG;
> 
> Hmm, so these are actually struct copies. The broader changes to use the
> global directly seem fine, but it's kind of unfortunate how close these
> assignment patterns look to some kind of direct value assignment at a
> glance, particularly with the macro looking name.

I'll add a comment /* struct copy */ to this.

> >  	while (!(flags & XFS_ALLOC_FLAG_NOSHRINK) && pag->pagf_flcount > need) {
> >  		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
> >  		if (error)
> ...
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index 3068a9382feb..90955ab1e895 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> ...
> > @@ -638,7 +632,7 @@ xchk_agfl_block(
> >  	else
> >  		xchk_block_set_corrupt(sc, sc->sa.agfl_bp);
> >  
> > -	xchk_agfl_block_xref(sc, agbno, priv);
> > +	xchk_agfl_block_xref(sc, agbno);
> 
> Heh, I'm not sure if that was an intentional hack or happy accident, but
> this looks like it removes a bit of a landmine by passing the void
> pointer to the struct xchk_agfl_info directly as the oinfo. :P

Yep, I'm glad this weird code can go away. :)

--D

> Brian
> 
> >  
> >  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> >  		return XFS_BTREE_QUERY_RANGE_ABORT;
> > @@ -662,7 +656,6 @@ STATIC void
> >  xchk_agfl_xref(
> >  	struct xfs_scrub	*sc)
> >  {
> > -	struct xfs_owner_info	oinfo;
> >  	struct xfs_mount	*mp = sc->mp;
> >  	xfs_agblock_t		agbno;
> >  	int			error;
> > @@ -678,8 +671,7 @@ xchk_agfl_xref(
> >  
> >  	xchk_xref_is_used_space(sc, agbno, 1);
> >  	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
> > -	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
> > +	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
> >  	xchk_xref_is_not_shared(sc, agbno, 1);
> >  
> >  	/*
> > @@ -732,7 +724,6 @@ xchk_agfl(
> >  	}
> >  
> >  	/* Check the blocks in the AGFL. */
> > -	xfs_rmap_ag_owner(&sai.oinfo, XFS_RMAP_OWN_AG);
> >  	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
> >  			sc->sa.agfl_bp, xchk_agfl_block, &sai);
> >  	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
> > @@ -791,7 +782,6 @@ STATIC void
> >  xchk_agi_xref(
> >  	struct xfs_scrub	*sc)
> >  {
> > -	struct xfs_owner_info	oinfo;
> >  	struct xfs_mount	*mp = sc->mp;
> >  	xfs_agblock_t		agbno;
> >  	int			error;
> > @@ -808,8 +798,7 @@ xchk_agi_xref(
> >  	xchk_xref_is_used_space(sc, agbno, 1);
> >  	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
> >  	xchk_agi_xref_icounts(sc);
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
> > -	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
> > +	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
> >  	xchk_xref_is_not_shared(sc, agbno, 1);
> >  
> >  	/* scrub teardown will take care of sc->sa for us */
> > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> > index f7568a4b5fe5..03d1e15cceba 100644
> > --- a/fs/xfs/scrub/agheader_repair.c
> > +++ b/fs/xfs/scrub/agheader_repair.c
> > @@ -646,7 +646,6 @@ int
> >  xrep_agfl(
> >  	struct xfs_scrub	*sc)
> >  {
> > -	struct xfs_owner_info	oinfo;
> >  	struct xfs_bitmap	agfl_extents;
> >  	struct xfs_mount	*mp = sc->mp;
> >  	struct xfs_buf		*agf_bp;
> > @@ -708,8 +707,8 @@ xrep_agfl(
> >  		goto err;
> >  
> >  	/* Dump any AGFL overflow. */
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > -	return xrep_reap_extents(sc, &agfl_extents, &oinfo, XFS_AG_RESV_AGFL);
> > +	return xrep_reap_extents(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
> > +			XFS_AG_RESV_AGFL);
> >  err:
> >  	xfs_bitmap_destroy(&agfl_extents);
> >  	return error;
> > diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> > index 376bcb585ae6..44883e9112ad 100644
> > --- a/fs/xfs/scrub/alloc.c
> > +++ b/fs/xfs/scrub/alloc.c
> > @@ -125,12 +125,10 @@ xchk_allocbt(
> >  	struct xfs_scrub	*sc,
> >  	xfs_btnum_t		which)
> >  {
> > -	struct xfs_owner_info	oinfo;
> >  	struct xfs_btree_cur	*cur;
> >  
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> >  	cur = which == XFS_BTNUM_BNO ? sc->sa.bno_cur : sc->sa.cnt_cur;
> > -	return xchk_btree(sc, cur, xchk_allocbt_rec, &oinfo, NULL);
> > +	return xchk_btree(sc, cur, xchk_allocbt_rec, &XFS_RMAP_OINFO_AG, NULL);
> >  }
> >  
> >  int
> > diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> > index 224dba937492..72f45b298fa5 100644
> > --- a/fs/xfs/scrub/ialloc.c
> > +++ b/fs/xfs/scrub/ialloc.c
> > @@ -82,15 +82,12 @@ xchk_iallocbt_chunk_xref(
> >  	xfs_agblock_t			agbno,
> >  	xfs_extlen_t			len)
> >  {
> > -	struct xfs_owner_info		oinfo;
> > -
> >  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> >  		return;
> >  
> >  	xchk_xref_is_used_space(sc, agbno, len);
> >  	xchk_iallocbt_chunk_xref_other(sc, irec, agino);
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
> > -	xchk_xref_is_owned_by(sc, agbno, len, &oinfo);
> > +	xchk_xref_is_owned_by(sc, agbno, len, &XFS_RMAP_OINFO_INODES);
> >  	xchk_xref_is_not_shared(sc, agbno, len);
> >  }
> >  
> > @@ -186,7 +183,6 @@ xchk_iallocbt_check_freemask(
> >  	struct xchk_btree		*bs,
> >  	struct xfs_inobt_rec_incore	*irec)
> >  {
> > -	struct xfs_owner_info		oinfo;
> >  	struct xfs_imap			imap;
> >  	struct xfs_mount		*mp = bs->cur->bc_mp;
> >  	struct xfs_dinode		*dip;
> > @@ -205,7 +201,6 @@ xchk_iallocbt_check_freemask(
> >  	/* Make sure the freemask matches the inode records. */
> >  	blks_per_cluster = xfs_icluster_size_fsb(mp);
> >  	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
> >  
> >  	for (agino = irec->ir_startino;
> >  	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
> > @@ -230,12 +225,13 @@ xchk_iallocbt_check_freemask(
> >  		/* If any part of this is a hole, skip it. */
> >  		if (ir_holemask) {
> >  			xchk_xref_is_not_owned_by(bs->sc, agbno,
> > -					blks_per_cluster, &oinfo);
> > +					blks_per_cluster,
> > +					&XFS_RMAP_OINFO_INODES);
> >  			continue;
> >  		}
> >  
> >  		xchk_xref_is_owned_by(bs->sc, agbno, blks_per_cluster,
> > -				&oinfo);
> > +				&XFS_RMAP_OINFO_INODES);
> >  
> >  		/* Grab the inode cluster buffer. */
> >  		imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno,
> > @@ -366,7 +362,6 @@ xchk_iallocbt_xref_rmap_btreeblks(
> >  	struct xfs_scrub	*sc,
> >  	int			which)
> >  {
> > -	struct xfs_owner_info	oinfo;
> >  	xfs_filblks_t		blocks;
> >  	xfs_extlen_t		inobt_blocks = 0;
> >  	xfs_extlen_t		finobt_blocks = 0;
> > @@ -388,9 +383,8 @@ xchk_iallocbt_xref_rmap_btreeblks(
> >  			return;
> >  	}
> >  
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
> > -	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
> > -			&blocks);
> > +	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur,
> > +			&XFS_RMAP_OINFO_INOBT, &blocks);
> >  	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
> >  		return;
> >  	if (blocks != inobt_blocks + finobt_blocks)
> > @@ -407,7 +401,6 @@ xchk_iallocbt_xref_rmap_inodes(
> >  	int			which,
> >  	xfs_filblks_t		inode_blocks)
> >  {
> > -	struct xfs_owner_info	oinfo;
> >  	xfs_filblks_t		blocks;
> >  	int			error;
> >  
> > @@ -415,9 +408,8 @@ xchk_iallocbt_xref_rmap_inodes(
> >  		return;
> >  
> >  	/* Check that we saw as many inode blocks as the rmap knows about. */
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
> > -	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
> > -			&blocks);
> > +	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur,
> > +			&XFS_RMAP_OINFO_INODES, &blocks);
> >  	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
> >  		return;
> >  	if (blocks != inode_blocks)
> > @@ -431,13 +423,11 @@ xchk_iallocbt(
> >  	xfs_btnum_t		which)
> >  {
> >  	struct xfs_btree_cur	*cur;
> > -	struct xfs_owner_info	oinfo;
> >  	xfs_filblks_t		inode_blocks = 0;
> >  	int			error;
> >  
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
> >  	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
> > -	error = xchk_btree(sc, cur, xchk_iallocbt_rec, &oinfo,
> > +	error = xchk_btree(sc, cur, xchk_iallocbt_rec, &XFS_RMAP_OINFO_INOBT,
> >  			&inode_blocks);
> >  	if (error)
> >  		return error;
> > diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> > index e386c9b0b4ab..e213efc194a1 100644
> > --- a/fs/xfs/scrub/inode.c
> > +++ b/fs/xfs/scrub/inode.c
> > @@ -509,7 +509,6 @@ xchk_inode_xref(
> >  	xfs_ino_t		ino,
> >  	struct xfs_dinode	*dip)
> >  {
> > -	struct xfs_owner_info	oinfo;
> >  	xfs_agnumber_t		agno;
> >  	xfs_agblock_t		agbno;
> >  	int			error;
> > @@ -526,8 +525,7 @@ xchk_inode_xref(
> >  
> >  	xchk_xref_is_used_space(sc, agbno, 1);
> >  	xchk_inode_xref_finobt(sc, ino);
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
> > -	xchk_xref_is_owned_by(sc, agbno, 1, &oinfo);
> > +	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_INODES);
> >  	xchk_xref_is_not_shared(sc, agbno, 1);
> >  	xchk_inode_xref_bmap(sc, dip);
> >  
> > diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> > index b7ade620acee..708b4158eb90 100644
> > --- a/fs/xfs/scrub/refcount.c
> > +++ b/fs/xfs/scrub/refcount.c
> > @@ -385,7 +385,6 @@ xchk_refcount_xref_rmap(
> >  	struct xfs_scrub	*sc,
> >  	xfs_filblks_t		cow_blocks)
> >  {
> > -	struct xfs_owner_info	oinfo;
> >  	xfs_extlen_t		refcbt_blocks = 0;
> >  	xfs_filblks_t		blocks;
> >  	int			error;
> > @@ -394,21 +393,19 @@ xchk_refcount_xref_rmap(
> >  		return;
> >  
> >  	/* Check that we saw as many refcbt blocks as the rmap knows about. */
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
> >  	error = xfs_btree_count_blocks(sc->sa.refc_cur, &refcbt_blocks);
> >  	if (!xchk_btree_process_error(sc, sc->sa.refc_cur, 0, &error))
> >  		return;
> > -	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
> > -			&blocks);
> > +	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur,
> > +			&XFS_RMAP_OINFO_REFC, &blocks);
> >  	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
> >  		return;
> >  	if (blocks != refcbt_blocks)
> >  		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
> >  
> >  	/* Check that we saw as many cow blocks as the rmap knows about. */
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_COW);
> > -	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
> > -			&blocks);
> > +	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur,
> > +			&XFS_RMAP_OINFO_COW, &blocks);
> >  	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
> >  		return;
> >  	if (blocks != cow_blocks)
> > @@ -420,13 +417,11 @@ int
> >  xchk_refcountbt(
> >  	struct xfs_scrub	*sc)
> >  {
> > -	struct xfs_owner_info	oinfo;
> >  	xfs_agblock_t		cow_blocks = 0;
> >  	int			error;
> >  
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
> >  	error = xchk_btree(sc, sc->sa.refc_cur, xchk_refcountbt_rec,
> > -			&oinfo, &cow_blocks);
> > +			&XFS_RMAP_OINFO_REFC, &cow_blocks);
> >  	if (error)
> >  		return error;
> >  
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index 90ae9e173de7..1c8eecfe52b8 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> > @@ -505,7 +505,6 @@ xrep_put_freelist(
> >  	struct xfs_scrub	*sc,
> >  	xfs_agblock_t		agbno)
> >  {
> > -	struct xfs_owner_info	oinfo;
> >  	int			error;
> >  
> >  	/* Make sure there's space on the freelist. */
> > @@ -518,9 +517,8 @@ xrep_put_freelist(
> >  	 * create an rmap for the block prior to merging it or else other
> >  	 * parts will break.
> >  	 */
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> >  	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno, agbno, 1,
> > -			&oinfo);
> > +			&XFS_RMAP_OINFO_AG);
> >  	if (error)
> >  		return error;
> >  
> > diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> > index 8a5bf15d544d..92a140c5b55e 100644
> > --- a/fs/xfs/scrub/rmap.c
> > +++ b/fs/xfs/scrub/rmap.c
> > @@ -174,11 +174,8 @@ int
> >  xchk_rmapbt(
> >  	struct xfs_scrub	*sc)
> >  {
> > -	struct xfs_owner_info	oinfo;
> > -
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> >  	return xchk_btree(sc, sc->sa.rmap_cur, xchk_rmapbt_rec,
> > -			&oinfo, NULL);
> > +			&XFS_RMAP_OINFO_AG, NULL);
> >  }
> >  
> >  /* xref check that the extent is owned by a given owner */
> > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > index d9da66c718bb..74ddf66f4cfe 100644
> > --- a/fs/xfs/xfs_extfree_item.c
> > +++ b/fs/xfs/xfs_extfree_item.c
> > @@ -494,7 +494,6 @@ xfs_efi_recover(
> >  	int			error = 0;
> >  	xfs_extent_t		*extp;
> >  	xfs_fsblock_t		startblock_fsb;
> > -	struct xfs_owner_info	oinfo;
> >  
> >  	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
> >  
> > @@ -526,11 +525,11 @@ xfs_efi_recover(
> >  		return error;
> >  	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
> >  
> > -	xfs_rmap_any_owner_update(&oinfo);
> >  	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> >  		extp = &efip->efi_format.efi_extents[i];
> >  		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
> > -					      extp->ext_len, &oinfo, false);
> > +					      extp->ext_len,
> > +					      &XFS_RMAP_OINFO_ANY_OWNER, false);
> >  		if (error)
> >  			goto abort_error;
> >  
> > 

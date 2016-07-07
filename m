Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 46B8C7CD8
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 14:12:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D61B4AC04C
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 12:12:08 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id r9FC8C7lzuCaPHJU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Jul 2016 12:12:03 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <20160707190956.GA12567@birch.djwong.org>
Date: Thu, 7 Jul 2016 12:09:56 -0700 (PDT)
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 026/119] xfs: add owner field to extent allocation and
	freeing
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612643914.12839.17925699349002137545.stgit@birch.djwong.org>
	<20160707151227.GA33740@bfoster.bfoster>
In-Reply-To: <20160707151227.GA33740@bfoster.bfoster>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Thu, Jul 07, 2016 at 11:12:27AM -0400, Brian Foster wrote:
> On Thu, Jun 16, 2016 at 06:20:39PM -0700, Darrick J. Wong wrote:
> > For the rmap btree to work, we have to feed the extent owner
> > information to the the allocation and freeing functions. This
> > information is what will end up in the rmap btree that tracks
> > allocated extents. While we technically don't need the owner
> > information when freeing extents, passing it allows us to validate
> > that the extent we are removing from the rmap btree actually
> > belonged to the owner we expected it to belong to.
> > 
> > We also define a special set of owner values for internal metadata
> > that would otherwise have no owner. This allows us to tell the
> > difference between metadata owned by different per-ag btrees, as
> > well as static fs metadata (e.g. AG headers) and internal journal
> > blocks.
> > 
> > There are also a couple of special cases we need to take care of -
> > during EFI recovery, we don't actually know who the original owner
> > was, so we need to pass a wildcard to indicate that we aren't
> > checking the owner for validity. We also need special handling in
> > growfs, as we "free" the space in the last AG when extending it, but
> > because it's new space it has no actual owner...
> > 
> > While touching the xfs_bmap_add_free() function, re-order the
> > parameters to put the struct xfs_mount first.
> > 
> > Extend the owner field to include both the owner type and some sort
> > of index within the owner.  The index field will be used to support
> > reverse mappings when reflink is enabled.
> > 
> > This is based upon a patch originally from Dave Chinner. It has been
> > extended to add more owner information with the intent of helping
> > recovery operations when things go wrong (e.g. offset of user data
> > block in a file).
> > 
> > v2: When we're freeing extents from an EFI, we don't have the owner
> > information available (rmap updates have their own redo items).
> > xfs_free_extent therefore doesn't need to do an rmap update, but the
> > log replay code doesn't signal this correctly.  Fix it so that it
> > does.
> > 
> > [dchinner: de-shout the xfs_rmap_*_owner helpers]
> > [darrick: minor style fixes suggested by Christoph Hellwig]
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c        |   11 +++++-
> >  fs/xfs/libxfs/xfs_alloc.h        |    4 ++
> >  fs/xfs/libxfs/xfs_bmap.c         |   17 ++++++++--
> >  fs/xfs/libxfs/xfs_bmap.h         |    4 ++
> >  fs/xfs/libxfs/xfs_bmap_btree.c   |    6 +++-
> >  fs/xfs/libxfs/xfs_format.h       |   65 ++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_ialloc.c       |    7 +++-
> >  fs/xfs/libxfs/xfs_ialloc_btree.c |    7 ++++
> >  fs/xfs/xfs_defer_item.c          |    3 +-
> >  fs/xfs/xfs_fsops.c               |   16 +++++++--
> >  fs/xfs/xfs_log_recover.c         |    5 ++-
> >  fs/xfs/xfs_trans.h               |    2 +
> >  fs/xfs/xfs_trans_extfree.c       |    5 ++-
> >  13 files changed, 131 insertions(+), 21 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index fb00042..eed26f9 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -1596,6 +1596,7 @@ xfs_free_ag_extent(
> >  	xfs_agnumber_t	agno,	/* allocation group number */
> >  	xfs_agblock_t	bno,	/* starting block number */
> >  	xfs_extlen_t	len,	/* length of extent */
> > +	struct xfs_owner_info	*oinfo,	/* extent owner */
> 
> Alignment, here and a couple other places in the patch.

Ok, will have a look at that the next time I go through all the patches.

> >  	int		isfl)	/* set if is freelist blocks - no sb acctg */
> >  {
> >  	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
> > @@ -2005,13 +2006,15 @@ xfs_alloc_fix_freelist(
> >  	 * back on the free list? Maybe we should only do this when space is
> >  	 * getting low or the AGFL is more than half full?
> >  	 */
> > +	xfs_rmap_ag_owner(&targs.oinfo, XFS_RMAP_OWN_AG);
> >  	while (pag->pagf_flcount > need) {
> >  		struct xfs_buf	*bp;
> >  
> >  		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
> >  		if (error)
> >  			goto out_agbp_relse;
> > -		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1);
> > +		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1,
> > +					   &targs.oinfo, 1);
> >  		if (error)
> >  			goto out_agbp_relse;
> >  		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
> > @@ -2021,6 +2024,7 @@ xfs_alloc_fix_freelist(
> >  	memset(&targs, 0, sizeof(targs));
> >  	targs.tp = tp;
> >  	targs.mp = mp;
> > +	xfs_rmap_ag_owner(&targs.oinfo, XFS_RMAP_OWN_AG);
> >  	targs.agbp = agbp;
> >  	targs.agno = args->agno;
> >  	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
> > @@ -2711,7 +2715,8 @@ int				/* error */
> >  xfs_free_extent(
> >  	struct xfs_trans	*tp,	/* transaction pointer */
> >  	xfs_fsblock_t		bno,	/* starting block number of extent */
> > -	xfs_extlen_t		len)	/* length of extent */
> > +	xfs_extlen_t		len,	/* length of extent */
> > +	struct xfs_owner_info	*oinfo)	/* extent owner */
> >  {
> >  	struct xfs_mount	*mp = tp->t_mountp;
> >  	struct xfs_buf		*agbp;
> > @@ -2739,7 +2744,7 @@ xfs_free_extent(
> >  			agbno + len <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length),
> >  			err);
> >  
> > -	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, 0);
> > +	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, oinfo, 0);
> >  	if (error)
> >  		goto err;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> > index 20b54aa..0721a48 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.h
> > +++ b/fs/xfs/libxfs/xfs_alloc.h
> > @@ -123,6 +123,7 @@ typedef struct xfs_alloc_arg {
> >  	char		isfl;		/* set if is freelist blocks - !acctg */
> >  	char		userdata;	/* mask defining userdata treatment */
> >  	xfs_fsblock_t	firstblock;	/* io first block allocated */
> > +	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
> >  } xfs_alloc_arg_t;
> >  
> >  /*
> > @@ -210,7 +211,8 @@ int				/* error */
> >  xfs_free_extent(
> >  	struct xfs_trans *tp,	/* transaction pointer */
> >  	xfs_fsblock_t	bno,	/* starting block number of extent */
> > -	xfs_extlen_t	len);	/* length of extent */
> > +	xfs_extlen_t	len,	/* length of extent */
> > +	struct xfs_owner_info	*oinfo);	/* extent owner */
> >  
> >  int				/* error */
> >  xfs_alloc_lookup_ge(
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 3a6d3e3..2c28f2a 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -574,7 +574,8 @@ xfs_bmap_add_free(
> >  	struct xfs_mount	*mp,		/* mount point structure */
> >  	struct xfs_defer_ops	*dfops,		/* list of extents */
> >  	xfs_fsblock_t		bno,		/* fs block number of extent */
> > -	xfs_filblks_t		len)		/* length of extent */
> > +	xfs_filblks_t		len,		/* length of extent */
> > +	struct xfs_owner_info	*oinfo)		/* extent owner */
> >  {
> >  	struct xfs_bmap_free_item	*new;		/* new element */
> >  #ifdef DEBUG
> > @@ -593,9 +594,14 @@ xfs_bmap_add_free(
> >  	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
> >  #endif
> >  	ASSERT(xfs_bmap_free_item_zone != NULL);
> > +
> >  	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
> >  	new->xbfi_startblock = bno;
> >  	new->xbfi_blockcount = (xfs_extlen_t)len;
> > +	if (oinfo)
> > +		memcpy(&new->xbfi_oinfo, oinfo, sizeof(struct xfs_owner_info));
> > +	else
> > +		memset(&new->xbfi_oinfo, 0, sizeof(struct xfs_owner_info));
> 
> How about just using KM_ZERO on the allocation and doing something like
> 'if (oinfo) new->xbfi_oinfo = *oinfo'?
> 
> BTW, what's the use case for a zeroed out oinfo if we explicitly define
> null/unknown owner types?

The two main ways we end up altering the rmapbt are as follows:

1) Alloc/free of AG metadata blocks.  For this use case, the caller (generally
a btree ->alloc_block function) bundles the bnobt and rmapbt updates in the
same transaction by passing ownership info (via this oinfo pointer) to the
alloc/free function.  Passing the "special" owner value XFS_RMAP_OWN_NULL just
checks that there are no rmaps for the given range, which is a spot check
performed by growfs.

2) Map/unmap of file blocks.  For this use case, I must treat map/unmap
separately from alloc/free in order to handle reflink.  Therefore, the map &
unmap functions schedule rmap updates directly (via the deferred ops mechanism)
and the alloc/free functions, if they're called, should not update the rmapbt.
Zeroing out the oinfo indicates this.  However, XFS_RMAP_OWN_UNKNOWN is now
unused, so I think I can overload that, especially since we should never be
writing XFS_RMAP_OWN_UNKNOWN to disk.

I think I can simply create an "xfs_rmap_skip_owner_update()" helper (like the
other xfs_rmap_*_owner functions) to encapsulate this.

if (oinfo)
	new->xbfi_oinfo = *oinfo;
else
	xfs_rmap_skip_owner_update(&new->xbfi_oinfo);

Seems clearer, I hope?

Also, the "Special Case #2: EFIs do not record the owner of the extent, so
when" comment is now wrong and needs to be changed.

"Special Case #2: An owner of XFS_RMAP_OWN_UNKNOWN means 'no rmap update'".

> >  	trace_xfs_bmap_free_defer(mp, XFS_FSB_TO_AGNO(mp, bno), 0,
> >  			XFS_FSB_TO_AGBNO(mp, bno), len);
> >  	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_FREE, &new->xbfi_list);
> > @@ -628,6 +634,7 @@ xfs_bmap_btree_to_extents(
> >  	xfs_mount_t		*mp;	/* mount point structure */
> >  	__be64			*pp;	/* ptr to block address */
> >  	struct xfs_btree_block	*rblock;/* root btree block */
> > +	struct xfs_owner_info	oinfo;
> >  
> >  	mp = ip->i_mount;
> >  	ifp = XFS_IFORK_PTR(ip, whichfork);
> > @@ -651,7 +658,8 @@ xfs_bmap_btree_to_extents(
> >  	cblock = XFS_BUF_TO_BLOCK(cbp);
> >  	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
> >  		return error;
> > -	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, cbno, 1);
> > +	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
> > +	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, cbno, 1, &oinfo);
> >  	ip->i_d.di_nblocks--;
> >  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
> >  	xfs_trans_binval(tp, cbp);
> > @@ -732,6 +740,7 @@ xfs_bmap_extents_to_btree(
> >  	memset(&args, 0, sizeof(args));
> >  	args.tp = tp;
> >  	args.mp = mp;
> > +	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
> >  	args.firstblock = *firstblock;
> >  	if (*firstblock == NULLFSBLOCK) {
> >  		args.type = XFS_ALLOCTYPE_START_BNO;
> > @@ -878,6 +887,7 @@ xfs_bmap_local_to_extents(
> >  	memset(&args, 0, sizeof(args));
> >  	args.tp = tp;
> >  	args.mp = ip->i_mount;
> > +	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
> >  	args.firstblock = *firstblock;
> >  	/*
> >  	 * Allocate a block.  We know we need only one, since the
> > @@ -4839,6 +4849,7 @@ xfs_bmap_del_extent(
> >  		nblks = 0;
> >  		do_fx = 0;
> >  	}
> > +
> >  	/*
> >  	 * Set flag value to use in switch statement.
> >  	 * Left-contig is 2, right-contig is 1.
> > @@ -5026,7 +5037,7 @@ xfs_bmap_del_extent(
> >  	 */
> >  	if (do_fx)
> >  		xfs_bmap_add_free(mp, dfops, del->br_startblock,
> > -			del->br_blockcount);
> > +				  del->br_blockcount, NULL);
> 
> Any reason we don't set the owner here?

(See above.)

> >  	/*
> >  	 * Adjust inode # blocks in the file.
> >  	 */
> > diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> > index 8c5f530..862ea464 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.h
> > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > @@ -67,6 +67,7 @@ struct xfs_bmap_free_item
> >  	xfs_fsblock_t		xbfi_startblock;/* starting fs block number */
> >  	xfs_extlen_t		xbfi_blockcount;/* number of blocks in extent */
> >  	struct list_head	xbfi_list;
> > +	struct xfs_owner_info	xbfi_oinfo;	/* extent owner */
> >  };
> >  
> >  #define	XFS_BMAP_MAX_NMAP	4
> > @@ -165,7 +166,8 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
> >  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
> >  void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
> >  void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> > -			  xfs_fsblock_t bno, xfs_filblks_t len);
> > +			  xfs_fsblock_t bno, xfs_filblks_t len,
> > +			  struct xfs_owner_info *oinfo);
> >  void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
> >  int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
> >  		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
> > diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> > index 18b5361..3e68f9a 100644
> > --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> > +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> > @@ -447,6 +447,8 @@ xfs_bmbt_alloc_block(
> >  	args.mp = cur->bc_mp;
> >  	args.fsbno = cur->bc_private.b.firstblock;
> >  	args.firstblock = args.fsbno;
> > +	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_private.b.ip->i_ino,
> > +			cur->bc_private.b.whichfork);
> >  
> >  	if (args.fsbno == NULLFSBLOCK) {
> >  		args.fsbno = be64_to_cpu(start->l);
> > @@ -526,8 +528,10 @@ xfs_bmbt_free_block(
> >  	struct xfs_inode	*ip = cur->bc_private.b.ip;
> >  	struct xfs_trans	*tp = cur->bc_tp;
> >  	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
> > +	struct xfs_owner_info	oinfo;
> >  
> > -	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, fsbno, 1);
> > +	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
> > +	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, fsbno, 1, &oinfo);
> >  	ip->i_d.di_nblocks--;
> >  
> >  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index b5b0901..97f354f 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -1318,6 +1318,71 @@ typedef __be32 xfs_inobt_ptr_t;
> >   */
> >  #define	XFS_RMAP_CRC_MAGIC	0x524d4233	/* 'RMB3' */
> >  
> > +/*
> > + * Ownership info for an extent.  This is used to create reverse-mapping
> > + * entries.
> > + */
> > +#define XFS_OWNER_INFO_ATTR_FORK	(1 << 0)
> > +#define XFS_OWNER_INFO_BMBT_BLOCK	(1 << 1)
> > +struct xfs_owner_info {
> > +	uint64_t		oi_owner;
> > +	xfs_fileoff_t		oi_offset;
> > +	unsigned int		oi_flags;
> > +};
> > +
> > +static inline void
> > +xfs_rmap_ag_owner(
> > +	struct xfs_owner_info	*oi,
> > +	uint64_t		owner)
> > +{
> > +	oi->oi_owner = owner;
> > +	oi->oi_offset = 0;
> > +	oi->oi_flags = 0;
> > +}
> > +
> > +static inline void
> > +xfs_rmap_ino_bmbt_owner(
> > +	struct xfs_owner_info	*oi,
> > +	xfs_ino_t		ino,
> > +	int			whichfork)
> > +{
> > +	oi->oi_owner = ino;
> > +	oi->oi_offset = 0;
> > +	oi->oi_flags = XFS_OWNER_INFO_BMBT_BLOCK;
> > +	if (whichfork == XFS_ATTR_FORK)
> > +		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
> > +}
> > +
> > +static inline void
> > +xfs_rmap_ino_owner(
> > +	struct xfs_owner_info	*oi,
> > +	xfs_ino_t		ino,
> > +	int			whichfork,
> > +	xfs_fileoff_t		offset)
> > +{
> > +	oi->oi_owner = ino;
> > +	oi->oi_offset = offset;
> > +	oi->oi_flags = 0;
> > +	if (whichfork == XFS_ATTR_FORK)
> > +		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
> > +}
> > +
> > +/*
> > + * Special owner types.
> > + *
> > + * Seeing as we only support up to 8EB, we have the upper bit of the owner field
> > + * to tell us we have a special owner value. We use these for static metadata
> > + * allocated at mkfs/growfs time, as well as for freespace management metadata.
> > + */
> > +#define XFS_RMAP_OWN_NULL	(-1ULL)	/* No owner, for growfs */
> > +#define XFS_RMAP_OWN_UNKNOWN	(-2ULL)	/* Unknown owner, for EFI recovery */
> > +#define XFS_RMAP_OWN_FS		(-3ULL)	/* static fs metadata */
> > +#define XFS_RMAP_OWN_LOG	(-4ULL)	/* static fs metadata */
> > +#define XFS_RMAP_OWN_AG		(-5ULL)	/* AG freespace btree blocks */
> 
> How about XFS_RMAP_OWN_AGFL? OWN_AG confuses me into thinking it's for
> AG headers, but IIUC that is covered by OWN_FS.

or _SPACEBT for AG {free,rmap} space btrees?

> > +#define XFS_RMAP_OWN_INOBT	(-6ULL)	/* Inode btree blocks */
> > +#define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
> > +#define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
> > +
> >  #define	XFS_RMAP_BLOCK(mp) \
> >  	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
> >  	 XFS_FIBT_BLOCK(mp) + 1 : \
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index dbc3e35..1982561 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -615,6 +615,7 @@ xfs_ialloc_ag_alloc(
> >  	args.tp = tp;
> >  	args.mp = tp->t_mountp;
> >  	args.fsbno = NULLFSBLOCK;
> > +	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_INODES);
> >  
> >  #ifdef DEBUG
> >  	/* randomly do sparse inode allocations */
> > @@ -1825,12 +1826,14 @@ xfs_difree_inode_chunk(
> >  	int		nextbit;
> >  	xfs_agblock_t	agbno;
> >  	int		contigblk;
> > +	struct xfs_owner_info	oinfo;
> >  	DECLARE_BITMAP(holemask, XFS_INOBT_HOLEMASK_BITS);
> > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
> >  
> >  	if (!xfs_inobt_issparse(rec->ir_holemask)) {
> >  		/* not sparse, calculate extent info directly */
> >  		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, sagbno),
> > -				  mp->m_ialloc_blks);
> > +				  mp->m_ialloc_blks, &oinfo);
> >  		return;
> >  	}
> >  
> > @@ -1874,7 +1877,7 @@ xfs_difree_inode_chunk(
> >  		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
> >  		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
> >  		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, agbno),
> > -				  contigblk);
> > +				  contigblk, &oinfo);
> >  
> >  		/* reset range to current bit and carry on... */
> >  		startidx = endidx = nextbit;
> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > index 88da2ad..f9ea86b 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > @@ -96,6 +96,7 @@ xfs_inobt_alloc_block(
> >  	memset(&args, 0, sizeof(args));
> >  	args.tp = cur->bc_tp;
> >  	args.mp = cur->bc_mp;
> > +	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_INOBT);
> >  	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
> >  	args.minlen = 1;
> >  	args.maxlen = 1;
> > @@ -125,8 +126,12 @@ xfs_inobt_free_block(
> >  	struct xfs_btree_cur	*cur,
> >  	struct xfs_buf		*bp)
> >  {
> > +	struct xfs_owner_info	oinfo;
> > +
> > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
> >  	return xfs_free_extent(cur->bc_tp,
> > -			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1);
> > +			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
> > +			&oinfo);
> >  }
> >  
> >  STATIC int
> > diff --git a/fs/xfs/xfs_defer_item.c b/fs/xfs/xfs_defer_item.c
> > index 127a54e..1c2d556 100644
> > --- a/fs/xfs/xfs_defer_item.c
> > +++ b/fs/xfs/xfs_defer_item.c
> > @@ -99,7 +99,8 @@ xfs_bmap_free_finish_item(
> >  	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
> >  	error = xfs_trans_free_extent(tp, done_item,
> >  			free->xbfi_startblock,
> > -			free->xbfi_blockcount);
> > +			free->xbfi_blockcount,
> > +			&free->xbfi_oinfo);
> >  	kmem_free(free);
> >  	return error;
> >  }
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 62162d4..d60bb97 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -436,6 +436,8 @@ xfs_growfs_data_private(
> >  	 * There are new blocks in the old last a.g.
> >  	 */
> >  	if (new) {
> > +		struct xfs_owner_info	oinfo;
> > +
> >  		/*
> >  		 * Change the agi length.
> >  		 */
> > @@ -463,14 +465,20 @@ xfs_growfs_data_private(
> >  		       be32_to_cpu(agi->agi_length));
> >  
> >  		xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
> > +
> >  		/*
> >  		 * Free the new space.
> > +		 *
> > +		 * XFS_RMAP_OWN_NULL is used here to tell the rmap btree that
> > +		 * this doesn't actually exist in the rmap btree.
> >  		 */
> > -		error = xfs_free_extent(tp, XFS_AGB_TO_FSB(mp, agno,
> > -			be32_to_cpu(agf->agf_length) - new), new);
> > -		if (error) {
> > +		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_NULL);
> > +		error = xfs_free_extent(tp,
> > +				XFS_AGB_TO_FSB(mp, agno,
> > +					be32_to_cpu(agf->agf_length) - new),
> > +				new, &oinfo);
> > +		if (error)
> >  			goto error0;
> > -		}
> >  	}
> >  
> >  	/*
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 080b54b..0c41bd2 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -4180,6 +4180,7 @@ xlog_recover_process_efi(
> >  	int			error = 0;
> >  	xfs_extent_t		*extp;
> >  	xfs_fsblock_t		startblock_fsb;
> > +	struct xfs_owner_info	oinfo;
> >  
> >  	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
> >  
> > @@ -4211,10 +4212,12 @@ xlog_recover_process_efi(
> >  		return error;
> >  	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
> >  
> > +	oinfo.oi_owner = 0;
> 
> Should this be XFS_RMAP_OWN_UNKNOWN?

xfs_rmap_skip_owner_update(), but yes.

--D

> 
> Brian
> 
> >  	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> >  		extp = &(efip->efi_format.efi_extents[i]);
> >  		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
> > -					      extp->ext_len);
> > +					      extp->ext_len,
> > +					      &oinfo);
> >  		if (error)
> >  			goto abort_error;
> >  
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 9a462e8..f8d363f 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -219,7 +219,7 @@ struct xfs_efd_log_item	*xfs_trans_get_efd(xfs_trans_t *,
> >  				  uint);
> >  int		xfs_trans_free_extent(struct xfs_trans *,
> >  				      struct xfs_efd_log_item *, xfs_fsblock_t,
> > -				      xfs_extlen_t);
> > +				      xfs_extlen_t, struct xfs_owner_info *);
> >  int		xfs_trans_commit(struct xfs_trans *);
> >  int		__xfs_trans_roll(struct xfs_trans **, struct xfs_inode *, int *);
> >  int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
> > diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
> > index a96ae54..d1b8833 100644
> > --- a/fs/xfs/xfs_trans_extfree.c
> > +++ b/fs/xfs/xfs_trans_extfree.c
> > @@ -118,13 +118,14 @@ xfs_trans_free_extent(
> >  	struct xfs_trans	*tp,
> >  	struct xfs_efd_log_item	*efdp,
> >  	xfs_fsblock_t		start_block,
> > -	xfs_extlen_t		ext_len)
> > +	xfs_extlen_t		ext_len,
> > +	struct xfs_owner_info	*oinfo)
> >  {
> >  	uint			next_extent;
> >  	struct xfs_extent	*extp;
> >  	int			error;
> >  
> > -	error = xfs_free_extent(tp, start_block, ext_len);
> > +	error = xfs_free_extent(tp, start_block, ext_len, oinfo);
> >  
> >  	/*
> >  	 * Mark the transaction dirty, even on error. This ensures the
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

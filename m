Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9DC477F63
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 14:09:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35445AC001
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 12:09:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BuHeUd0oeellpaUN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2015 12:09:20 -0700 (PDT)
Date: Wed, 24 Jun 2015 15:09:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/20] xfs: add owner field to extent allocation and
	freeing
Message-ID: <20150624190918.GA3604@bfoster.bfoster>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
	<1433311497-10245-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433311497-10245-9-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 03, 2015 at 04:04:45PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For the rmap btree to work, we have to fed the extent owner
> information to the the allocation and freeing functions. This
> information is what will end up in the rmap btree that tracks
> allocated extents. While we technically don't need the owner
> information when freeing extents, passing it allows us to validate
> that the extent we are removing from the rmap btree actually
> belonged to the owner we expected it to belong to.
> 
> We also define a special set of owner values for internal metadata
> that would otherwise have no owner. This allows us to tell the
> difference between metadata owned by different per-ag btrees, as
> well as static fs metadata (e.g. AG headers) and internal journal
> blocks.
> 
> There are also a couple of special cases we need to take care of -
> during EFI recovery, we don't actually know who the original owner
> was, so we need to pass a wildcard to indicate that we aren't
> checking the owner for validity. We also need special handling in
> growfs, as we "free" the space in the last AG when extending it, but
> because it's new space it has no actual owner...
> 

Any reason not to support passing the owner through the efi/efd log
structures? You've already plumbed it through the bmap_free struct. I
suppose that could make this a backwards incompatible feature rather
than read-only incompatible, though.

Brian

> While touching the xfs_bmap_add_free() function, re-order the
> parameters to put the struct xfs_mount first.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c        | 11 ++++++++---
>  fs/xfs/libxfs/xfs_alloc.h        |  4 +++-
>  fs/xfs/libxfs/xfs_bmap.c         | 17 ++++++++++++-----
>  fs/xfs/libxfs/xfs_bmap.h         |  5 +++--
>  fs/xfs/libxfs/xfs_bmap_btree.c   |  3 ++-
>  fs/xfs/libxfs/xfs_format.h       | 16 ++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.c       | 10 +++++-----
>  fs/xfs/libxfs/xfs_ialloc_btree.c |  3 ++-
>  fs/xfs/xfs_bmap_util.c           | 17 +++++++++--------
>  fs/xfs/xfs_fsops.c               | 13 +++++++++----
>  fs/xfs/xfs_log_recover.c         |  3 ++-
>  11 files changed, 71 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index a683d7a..4353135 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1592,6 +1592,7 @@ xfs_free_ag_extent(
>  	xfs_agnumber_t	agno,	/* allocation group number */
>  	xfs_agblock_t	bno,	/* starting block number */
>  	xfs_extlen_t	len,	/* length of extent */
> +	uint64_t	owner,	/* extent owner */
>  	int		isfl)	/* set if is freelist blocks - no sb acctg */
>  {
>  	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
> @@ -2010,7 +2011,8 @@ xfs_alloc_fix_freelist(
>  		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
>  		if (error)
>  			goto out_agbp_relse;
> -		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1);
> +		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1,
> +					   XFS_RMAP_OWN_AG, 1);
>  		if (error)
>  			goto out_agbp_relse;
>  		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
> @@ -2020,6 +2022,7 @@ xfs_alloc_fix_freelist(
>  	memset(&targs, 0, sizeof(targs));
>  	targs.tp = tp;
>  	targs.mp = mp;
> +	targs.owner = XFS_RMAP_OWN_AG;
>  	targs.agbp = agbp;
>  	targs.agno = args->agno;
>  	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
> @@ -2660,7 +2663,8 @@ int				/* error */
>  xfs_free_extent(
>  	xfs_trans_t	*tp,	/* transaction pointer */
>  	xfs_fsblock_t	bno,	/* starting block number of extent */
> -	xfs_extlen_t	len)	/* length of extent */
> +	xfs_extlen_t	len,	/* length of extent */
> +	uint64_t	owner)	/* extent owner */
>  {
>  	xfs_alloc_arg_t	args;
>  	int		error;
> @@ -2696,7 +2700,8 @@ xfs_free_extent(
>  		goto error0;
>  	}
>  
> -	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
> +	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno,
> +				   len, owner, 0);
>  	if (!error)
>  		xfs_extent_busy_insert(tp, args.agno, args.agbno, len, 0);
>  error0:
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 71379f6..39ca815 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -122,6 +122,7 @@ typedef struct xfs_alloc_arg {
>  	char		isfl;		/* set if is freelist blocks - !acctg */
>  	char		userdata;	/* set if this is user data */
>  	xfs_fsblock_t	firstblock;	/* io first block allocated */
> +	uint64_t	owner;		/* owner of blocks being allocated */
>  } xfs_alloc_arg_t;
>  
>  /*
> @@ -208,7 +209,8 @@ int				/* error */
>  xfs_free_extent(
>  	struct xfs_trans *tp,	/* transaction pointer */
>  	xfs_fsblock_t	bno,	/* starting block number of extent */
> -	xfs_extlen_t	len);	/* length of extent */
> +	xfs_extlen_t	len,	/* length of extent */
> +	uint64_t	owner);	/* extent owner */
>  
>  int					/* error */
>  xfs_alloc_lookup_le(
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 983a5d0..0b40a29 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -567,10 +567,11 @@ xfs_bmap_validate_ret(
>   */
>  void
>  xfs_bmap_add_free(
> +	struct xfs_mount	*mp,		/* mount point structure */
> +	struct xfs_bmap_free	*flist,		/* list of extents */
>  	xfs_fsblock_t		bno,		/* fs block number of extent */
>  	xfs_filblks_t		len,		/* length of extent */
> -	xfs_bmap_free_t		*flist,		/* list of extents */
> -	xfs_mount_t		*mp)		/* mount point structure */
> +	uint64_t		owner)		/* extent owner */
>  {
>  	xfs_bmap_free_item_t	*cur;		/* current (next) element */
>  	xfs_bmap_free_item_t	*new;		/* new element */
> @@ -591,9 +592,12 @@ xfs_bmap_add_free(
>  	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
>  #endif
>  	ASSERT(xfs_bmap_free_item_zone != NULL);
> +	ASSERT(owner);
> +
>  	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
>  	new->xbfi_startblock = bno;
>  	new->xbfi_blockcount = (xfs_extlen_t)len;
> +	new->xbfi_owner = owner;
>  	for (prev = NULL, cur = flist->xbf_first;
>  	     cur != NULL;
>  	     prev = cur, cur = cur->xbfi_next) {
> @@ -696,7 +700,7 @@ xfs_bmap_btree_to_extents(
>  	cblock = XFS_BUF_TO_BLOCK(cbp);
>  	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
>  		return error;
> -	xfs_bmap_add_free(cbno, 1, cur->bc_private.b.flist, mp);
> +	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1, ip->i_ino);
>  	ip->i_d.di_nblocks--;
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
>  	xfs_trans_binval(tp, cbp);
> @@ -777,6 +781,7 @@ xfs_bmap_extents_to_btree(
>  	memset(&args, 0, sizeof(args));
>  	args.tp = tp;
>  	args.mp = mp;
> +	args.owner = ip->i_ino;
>  	args.firstblock = *firstblock;
>  	if (*firstblock == NULLFSBLOCK) {
>  		args.type = XFS_ALLOCTYPE_START_BNO;
> @@ -923,6 +928,7 @@ xfs_bmap_local_to_extents(
>  	memset(&args, 0, sizeof(args));
>  	args.tp = tp;
>  	args.mp = ip->i_mount;
> +	args.owner = ip->i_ino;
>  	args.firstblock = *firstblock;
>  	/*
>  	 * Allocate a block.  We know we need only one, since the
> @@ -3706,6 +3712,7 @@ xfs_bmap_btalloc(
>  	memset(&args, 0, sizeof(args));
>  	args.tp = ap->tp;
>  	args.mp = mp;
> +	args.owner = ap->ip->i_ino;
>  	args.fsbno = ap->blkno;
>  
>  	/* Trim the allocation back to the maximum an AG can fit. */
> @@ -4980,8 +4987,8 @@ xfs_bmap_del_extent(
>  	 * If we need to, add to list of extents to delete.
>  	 */
>  	if (do_fx)
> -		xfs_bmap_add_free(del->br_startblock, del->br_blockcount, flist,
> -			mp);
> +		xfs_bmap_add_free(mp, flist, del->br_startblock,
> +				  del->br_blockcount, ip->i_ino);
>  	/*
>  	 * Adjust inode # blocks in the file.
>  	 */
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 6aaa0c1..674819f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -66,6 +66,7 @@ typedef struct xfs_bmap_free_item
>  {
>  	xfs_fsblock_t		xbfi_startblock;/* starting fs block number */
>  	xfs_extlen_t		xbfi_blockcount;/* number of blocks in extent */
> +	uint64_t		xbfi_owner;	/* extent owner */
>  	struct xfs_bmap_free_item *xbfi_next;	/* link to next entry */
>  } xfs_bmap_free_item_t;
>  
> @@ -182,8 +183,8 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
>  
>  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
>  void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
> -void	xfs_bmap_add_free(xfs_fsblock_t bno, xfs_filblks_t len,
> -		struct xfs_bmap_free *flist, struct xfs_mount *mp);
> +void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_bmap_free *flist,
> +			  xfs_fsblock_t bno, xfs_filblks_t len, uint64_t owner);
>  void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
>  int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
>  			int *committed);
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 2c44c8e..18fe394 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -445,6 +445,7 @@ xfs_bmbt_alloc_block(
>  	args.mp = cur->bc_mp;
>  	args.fsbno = cur->bc_private.b.firstblock;
>  	args.firstblock = args.fsbno;
> +	args.owner = cur->bc_private.b.ip->i_ino;
>  
>  	if (args.fsbno == NULLFSBLOCK) {
>  		args.fsbno = be64_to_cpu(start->l);
> @@ -525,7 +526,7 @@ xfs_bmbt_free_block(
>  	struct xfs_trans	*tp = cur->bc_tp;
>  	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
>  
> -	xfs_bmap_add_free(fsbno, 1, cur->bc_private.b.flist, mp);
> +	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1, ip->i_ino);
>  	ip->i_d.di_nblocks--;
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index e81ffec..4c9e7e1 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1288,6 +1288,22 @@ typedef __be32 xfs_inobt_ptr_t;
>   */
>  #define	XFS_RMAP_CRC_MAGIC	0x524d4233	/* 'RMB3' */
>  
> +/*
> + * Special owner types.
> + *
> + * Seeing as we only support up to 8EB, we have the upper bit of the owner field
> + * to tell us we have a special owner value. We use these for static metadata
> + * allocated at mkfs/growfs time, as well as for freespace management metadata.
> + */
> +#define XFS_RMAP_OWN_NULL	(-1ULL)	/* No owner, for growfs */
> +#define XFS_RMAP_OWN_UNKNOWN	(-2ULL)	/* Unknown owner, for EFI recovery */
> +#define XFS_RMAP_OWN_FS		(-3ULL)	/* static fs metadata */
> +#define XFS_RMAP_OWN_LOG	(-4ULL)	/* static fs metadata */
> +#define XFS_RMAP_OWN_AG		(-5ULL)	/* AG freespace btree blocks */
> +#define XFS_RMAP_OWN_INOBT	(-6ULL)	/* Inode btree blocks */
> +#define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
> +#define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
> +
>  #define	XFS_RMAP_BLOCK(mp) \
>  	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
>  	 XFS_FIBT_BLOCK(mp) + 1 : \
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 66efc70..b08823a 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -612,6 +612,7 @@ xfs_ialloc_ag_alloc(
>  	args.tp = tp;
>  	args.mp = tp->t_mountp;
>  	args.fsbno = NULLFSBLOCK;
> +	args.owner = XFS_RMAP_OWN_INODES;
>  
>  #ifdef DEBUG
>  	/* randomly do sparse inode allocations */
> @@ -1826,9 +1827,8 @@ xfs_difree_inode_chunk(
>  
>  	if (!xfs_inobt_issparse(rec->ir_holemask)) {
>  		/* not sparse, calculate extent info directly */
> -		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno,
> -				  XFS_AGINO_TO_AGBNO(mp, rec->ir_startino)),
> -				  mp->m_ialloc_blks, flist, mp);
> +		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, sagbno),
> +				  mp->m_ialloc_blks, XFS_RMAP_OWN_INODES);
>  		return;
>  	}
>  
> @@ -1871,8 +1871,8 @@ xfs_difree_inode_chunk(
>  
>  		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
>  		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
> -		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
> -				  flist, mp);
> +		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, agbno),
> +				  contigblk, XFS_RMAP_OWN_INODES);
>  
>  		/* reset range to current bit and carry on... */
>  		startidx = endidx = nextbit;
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 674ad8f..b96db1c 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -96,6 +96,7 @@ xfs_inobt_alloc_block(
>  	memset(&args, 0, sizeof(args));
>  	args.tp = cur->bc_tp;
>  	args.mp = cur->bc_mp;
> +	args.owner = XFS_RMAP_OWN_INOBT;
>  	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
>  	args.minlen = 1;
>  	args.maxlen = 1;
> @@ -129,7 +130,7 @@ xfs_inobt_free_block(
>  	int			error;
>  
>  	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp));
> -	error = xfs_free_extent(cur->bc_tp, fsbno, 1);
> +	error = xfs_free_extent(cur->bc_tp, fsbno, 1, XFS_RMAP_OWN_INOBT);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 4a29655..5ed272b 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -117,15 +117,16 @@ xfs_bmap_finish(
>  	efd = xfs_trans_get_efd(ntp, efi, flist->xbf_count);
>  	for (free = flist->xbf_first; free != NULL; free = next) {
>  		next = free->xbfi_next;
> -		if ((error = xfs_free_extent(ntp, free->xbfi_startblock,
> -				free->xbfi_blockcount))) {
> +		error = xfs_free_extent(ntp, free->xbfi_startblock,
> +					free->xbfi_blockcount,
> +					free->xbfi_owner);
> +		if (error) {
>  			/*
> -			 * The bmap free list will be cleaned up at a
> -			 * higher level.  The EFI will be canceled when
> -			 * this transaction is aborted.
> -			 * Need to force shutdown here to make sure it
> -			 * happens, since this transaction may not be
> -			 * dirty yet.
> +			 * The bmap free list will be cleaned up at a higher
> +			 * level.  The EFI will be canceled when this
> +			 * transaction is aborted.  Need to force shutdown here
> +			 * to make sure it happens, since this transaction may
> +			 * not be dirty yet.
>  			 */
>  			mp = ntp->t_mountp;
>  			if (!XFS_FORCED_SHUTDOWN(mp))
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index a564c4c..ebfeb84 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -466,14 +466,19 @@ xfs_growfs_data_private(
>  		       be32_to_cpu(agi->agi_length));
>  
>  		xfs_alloc_log_agf(tp, bp, XFS_AGF_LENGTH);
> +
>  		/*
>  		 * Free the new space.
> +		 *
> +		 * XFS_RMAP_OWN_NULL is used here to tell the rmap btree that
> +		 * this doesn't actually exist in the rmap btree.
>  		 */
> -		error = xfs_free_extent(tp, XFS_AGB_TO_FSB(mp, agno,
> -			be32_to_cpu(agf->agf_length) - new), new);
> -		if (error) {
> +		error = xfs_free_extent(tp,
> +				XFS_AGB_TO_FSB(mp, agno,
> +					be32_to_cpu(agf->agf_length) - new),
> +				new, XFS_RMAP_OWN_NULL);
> +		if (error)
>  			goto error0;
> -		}
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 4a8c440..5dad26c 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3753,7 +3753,8 @@ xlog_recover_process_efi(
>  
>  	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
>  		extp = &(efip->efi_format.efi_extents[i]);
> -		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len);
> +		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len,
> +					XFS_RMAP_OWN_UNKNOWN);
>  		if (error)
>  			goto abort_error;
>  		xfs_trans_log_efd_extent(tp, efdp, extp->ext_start,
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

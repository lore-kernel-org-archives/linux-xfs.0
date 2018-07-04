Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47606 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbeGDAyw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:54:52 -0400
Date: Tue, 3 Jul 2018 17:54:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 19/25] xfs: remove xfs_alloc_arg firstblock field
Message-ID: <20180704005437.GS32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-20-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-20-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:13PM -0400, Brian Foster wrote:
> The xfs_alloc_arg.firstblock field is used to control the starting
> agno for an allocation. The structure already carries a pointer to
> the transaction, which carries the current firstblock value.
> 
> Remove the field and access ->t_firstblock directly in the
> allocation code.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c          | 20 ++++++++++----------
>  fs/xfs/libxfs/xfs_alloc.h          |  1 -
>  fs/xfs/libxfs/xfs_bmap.c           |  3 ---
>  fs/xfs/libxfs/xfs_bmap_btree.c     |  1 -
>  fs/xfs/libxfs/xfs_refcount_btree.c |  1 -
>  fs/xfs/xfs_trace.h                 |  2 +-
>  6 files changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 5b1607d76fe9..bd6d8aeea825 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2783,16 +2783,16 @@ xfs_alloc_read_agf(
>   */
>  int				/* error */
>  xfs_alloc_vextent(
> -	xfs_alloc_arg_t	*args)	/* allocation argument structure */
> +	struct xfs_alloc_arg	*args)	/* allocation argument structure */
>  {
> -	xfs_agblock_t	agsize;	/* allocation group size */
> -	int		error;
> -	int		flags;	/* XFS_ALLOC_FLAG_... locking flags */
> -	xfs_mount_t	*mp;	/* mount structure pointer */
> -	xfs_agnumber_t	sagno;	/* starting allocation group number */
> -	xfs_alloctype_t	type;	/* input allocation type */
> -	int		bump_rotor = 0;
> -	xfs_agnumber_t	rotorstep = xfs_rotorstep; /* inode32 agf stepper */
> +	xfs_agblock_t		agsize;	/* allocation group size */
> +	int			error;
> +	int			flags;	/* XFS_ALLOC_FLAG_... locking flags */
> +	struct xfs_mount	*mp;	/* mount structure pointer */
> +	xfs_agnumber_t		sagno;	/* starting allocation group number */
> +	xfs_alloctype_t		type;	/* input allocation type */
> +	int			bump_rotor = 0;
> +	xfs_agnumber_t		rotorstep = xfs_rotorstep; /* inode32 agf stepper */
>  
>  	mp = args->mp;
>  	type = args->otype = args->type;
> @@ -2913,7 +2913,7 @@ xfs_alloc_vextent(
>  			* locking of AGF, which might cause deadlock.
>  			*/
>  			if (++(args->agno) == mp->m_sb.sb_agcount) {
> -				if (args->firstblock != NULLFSBLOCK)
> +				if (args->tp->t_firstblock != NULLFSBLOCK)
>  					args->agno = sagno;
>  				else
>  					args->agno = 0;
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index e716c993ac4c..00cd5ec4cb6b 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -74,7 +74,6 @@ typedef struct xfs_alloc_arg {
>  	int		datatype;	/* mask defining data type treatment */
>  	char		wasdel;		/* set if allocation was prev delayed */
>  	char		wasfromfl;	/* set if allocation is from freelist */
> -	xfs_fsblock_t	firstblock;	/* io first block allocated */
>  	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
>  	enum xfs_ag_resv_type	resv;	/* block reservation to use */
>  } xfs_alloc_arg_t;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c83add15233b..1955b8410410 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -697,7 +697,6 @@ xfs_bmap_extents_to_btree(
>  	args.tp = tp;
>  	args.mp = mp;
>  	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
> -	args.firstblock = tp->t_firstblock;
>  	if (tp->t_firstblock == NULLFSBLOCK) {
>  		args.type = XFS_ALLOCTYPE_START_BNO;
>  		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
> @@ -845,7 +844,6 @@ xfs_bmap_local_to_extents(
>  	args.tp = tp;
>  	args.mp = ip->i_mount;
>  	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
> -	args.firstblock = tp->t_firstblock;
>  	/*
>  	 * Allocate a block.  We know we need only one, since the
>  	 * file currently fits in an inode.
> @@ -3445,7 +3443,6 @@ xfs_bmap_btalloc(
>  
>  	/* Trim the allocation back to the maximum an AG can fit. */
>  	args.maxlen = min(ap->length, mp->m_ag_max_usable);
> -	args.firstblock = ap->tp->t_firstblock;
>  	blen = 0;
>  	if (nullfb) {
>  		/*
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 8a9b98b11e34..628ed82ca286 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -208,7 +208,6 @@ xfs_bmbt_alloc_block(
>  	args.tp = cur->bc_tp;
>  	args.mp = cur->bc_mp;
>  	args.fsbno = cur->bc_tp->t_firstblock;
> -	args.firstblock = args.fsbno;
>  	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_private.b.ip->i_ino,
>  			cur->bc_private.b.whichfork);
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 393aa88f93db..26d2300ed865 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -70,7 +70,6 @@ xfs_refcountbt_alloc_block(
>  	args.type = XFS_ALLOCTYPE_NEAR_BNO;
>  	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
>  			xfs_refc_block(args.mp));
> -	args.firstblock = args.fsbno;
>  	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_REFC);
>  	args.minlen = args.maxlen = args.prod = 1;
>  	args.resv = XFS_AG_RESV_METADATA;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 972d45d28097..392e026bea79 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1604,7 +1604,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
>  		__entry->wasfromfl = args->wasfromfl;
>  		__entry->resv = args->resv;
>  		__entry->datatype = args->datatype;
> -		__entry->firstblock = args->firstblock;
> +		__entry->firstblock = args->tp->t_firstblock;
>  	),
>  	TP_printk("dev %d:%d agno %u agbno %u minlen %u maxlen %u mod %u "
>  		  "prod %u minleft %u total %u alignment %u minalignslop %u "
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

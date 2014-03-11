Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 19D197F3F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 10:32:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DA4AAC001
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 08:32:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lLjEBBSKTsW381zx for
	<xfs@oss.sgi.com>; Tue, 11 Mar 2014 08:32:10 -0700 (PDT)
Date: Tue, 11 Mar 2014 11:31:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: merge xfs_bmap_free_item and xfs_extent_busy
Message-ID: <20140311153135.GA37254@bfoster.bfoster>
References: <20140307105535.GA7850@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140307105535.GA7850@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Mar 07, 2014 at 02:55:35AM -0800, Christoph Hellwig wrote:
> Merge the two structures to track a freed extent into a single one, to simply
> tracking the flow in the extent free code and reduce the amount of required
> memory allocations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index c1cf6a3..656991d 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -2579,37 +2579,41 @@ error0:
>  	return error;
>  }
>  
> -/*
> - * Free an extent.
> - * Just break up the extent address and hand off to xfs_free_ag_extent
> - * after fixing up the freelist.
> - */
> -int				/* error */
> -xfs_free_extent(
> -	xfs_trans_t	*tp,	/* transaction pointer */
> -	xfs_fsblock_t	bno,	/* starting block number of extent */
> -	xfs_extlen_t	len)	/* length of extent */
> +struct xfs_freed_extent *
> +xfs_freed_extent_alloc(
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	unsigned int		flags)
> +{
> +	struct xfs_freed_extent	*new;
> +
> +	new = kmem_zone_zalloc(xfs_freed_extent_zone, KM_SLEEP);
> +	if (!new)
> +		return NULL;
> +
> +	new->agno = agno;
> +	new->bno = bno;
> +	new->length = len;
> +	INIT_LIST_HEAD(&new->list);
> +	new->flags = flags;
> +	return new;
> +}
> +
> +int
> +__xfs_free_extent(
> +	struct xfs_trans	*tp,
> +	struct xfs_freed_extent	*free)
>  {
>  	xfs_alloc_arg_t	args;
>  	int		error;
>  
> -	ASSERT(len != 0);
> +	ASSERT(free->length != 0);
>  	memset(&args, 0, sizeof(xfs_alloc_arg_t));
>  	args.tp = tp;
>  	args.mp = tp->t_mountp;
> -
> -	/*
> -	 * validate that the block number is legal - the enables us to detect
> -	 * and handle a silent filesystem corruption rather than crashing.
> -	 */
> -	args.agno = XFS_FSB_TO_AGNO(args.mp, bno);
> -	if (args.agno >= args.mp->m_sb.sb_agcount)
> -		return EFSCORRUPTED;
> -
> -	args.agbno = XFS_FSB_TO_AGBNO(args.mp, bno);
> -	if (args.agbno >= args.mp->m_sb.sb_agblocks)
> -		return EFSCORRUPTED;
> -
> +	args.agno = free->agno;
> +	args.agbno = free->bno;
>  	args.pag = xfs_perag_get(args.mp, args.agno);
>  	ASSERT(args.pag);
>  
> @@ -2618,16 +2622,45 @@ xfs_free_extent(
>  		goto error0;
>  
>  	/* validate the extent size is legal now we have the agf locked */
> -	if (args.agbno + len >
> +	if (args.agbno + free->length >
>  			be32_to_cpu(XFS_BUF_TO_AGF(args.agbp)->agf_length)) {
>  		error = EFSCORRUPTED;
>  		goto error0;
>  	}
>  
> -	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
> -	if (!error)
> -		xfs_extent_busy_insert(tp, args.agno, args.agbno, len, 0);
> +	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno,
> +				   free->length, 0);
>  error0:
>  	xfs_perag_put(args.pag);
>  	return error;
>  }
> +
> +int
> +xfs_free_extent(
> +	struct xfs_trans	*tp,
> +	xfs_fsblock_t		bno,
> +	xfs_extlen_t		len)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, bno);
> +	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, bno);
> +	struct xfs_freed_extent	*free;
> +	int			error;
> +
> +	/*
> +	 * validate that the block number is legal - the enables us to detect
> +	 * and handle a silent filesystem corruption rather than crashing.
> +	 */
> +	if (agno >= mp->m_sb.sb_agcount)
> +		return EFSCORRUPTED;
> +	if (agbno >= mp->m_sb.sb_agblocks)
> +		return EFSCORRUPTED;
> +
> +	free = xfs_freed_extent_alloc(agno, agbno, len, 0);
> +	error = __xfs_free_extent(tp, free);
> +	if (!error) {
> +		xfs_extent_busy_insert(tp, free);
> +		list_add(&free->list, &tp->t_busy);

If I follow correctly, the list_add() is removed from
xfs_extent_busy_insert() because we use the list field for the bmap
flist as well as the t_busy list.

It appears we've lost an error check associated with allocation failure
in xfs_freed_extent_alloc() (here and at other callers). The current
code looks like it handles this by marking the transaction as
synchronous. Have we avoided the need for this by using
kmem_zone_alloc()? I guess it looks like the sleep param will cause it
to continue to retry...

> +	}
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
> index feacb06..4aa7f8c 100644
> --- a/fs/xfs/xfs_alloc.h
> +++ b/fs/xfs/xfs_alloc.h
> @@ -122,6 +122,17 @@ typedef struct xfs_alloc_arg {
>  	xfs_fsblock_t	firstblock;	/* io first block allocated */
>  } xfs_alloc_arg_t;
>  
> +struct xfs_freed_extent {
> +	struct rb_node	rb_node;	/* ag by-bno indexed search tree */
> +	struct list_head list;		/* transaction busy extent list */
> +	xfs_agnumber_t	agno;
> +	xfs_agblock_t	bno;

agbno?

> +	xfs_extlen_t	length;
> +	unsigned int	flags;
> +#define XFS_EXTENT_DISCARDED	0x01	/* undergoing a discard op. */
> +#define XFS_EXTENT_SKIP_DISCARD	0x02	/* do not discard */
> +};
> +
>  /*
>   * Defines for userdata
>   */
> @@ -210,6 +221,11 @@ xfs_free_extent(
>  	xfs_fsblock_t	bno,	/* starting block number of extent */
>  	xfs_extlen_t	len);	/* length of extent */
>  
> +int
> +__xfs_free_extent(
> +	struct xfs_trans	*tp,
> +	struct xfs_freed_extent	*free);
> +
>  int					/* error */
>  xfs_alloc_lookup_le(
>  	struct xfs_btree_cur	*cur,	/* btree cursor */
> @@ -231,4 +247,13 @@ xfs_alloc_get_rec(
>  	xfs_extlen_t		*len,	/* output: length of extent */
>  	int			*stat);	/* output: success/failure */
>  
> +struct xfs_freed_extent *
> +xfs_freed_extent_alloc(
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	unsigned int		flags);
> +
> +extern kmem_zone_t	*xfs_freed_extent_zone;
> +
>  #endif	/* __XFS_ALLOC_H__ */
> diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
> index cc1eadc..ce3041a 100644
> --- a/fs/xfs/xfs_alloc_btree.c
> +++ b/fs/xfs/xfs_alloc_btree.c
> @@ -107,21 +107,24 @@ xfs_allocbt_free_block(
>  	struct xfs_btree_cur	*cur,
>  	struct xfs_buf		*bp)
>  {
> +	struct xfs_trans	*tp = cur->bc_tp;
>  	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> +	struct xfs_freed_extent	*free;
>  	xfs_agblock_t		bno;
>  	int			error;
>  
>  	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
> -	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
> +	error = xfs_alloc_put_freelist(tp, agbp, NULL, bno, 1);
>  	if (error)
>  		return error;
>  
> -	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
> -			      XFS_EXTENT_BUSY_SKIP_DISCARD);
> -	xfs_trans_agbtree_delta(cur->bc_tp, -1);

Was this supposed to go away?

> +	free = xfs_freed_extent_alloc(be32_to_cpu(agf->agf_seqno), bno, 1,
> +			      XFS_EXTENT_SKIP_DISCARD);
> +	xfs_extent_busy_insert(tp, free);
> +	list_add(&free->list, &tp->t_busy);
>  
> -	xfs_trans_binval(cur->bc_tp, bp);
> +	xfs_trans_binval(tp, bp);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 5b6092e..9c2c00c 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -50,7 +50,7 @@
>  #include "xfs_filestream.h"
>  
>  
> -kmem_zone_t		*xfs_bmap_free_item_zone;
> +kmem_zone_t		*xfs_freed_extent_zone;
>  
>  /*
>   * Miscellaneous helper functions
> @@ -588,10 +588,6 @@ xfs_bmap_validate_ret(
>  #endif /* DEBUG */
>  
>  /*
> - * bmap free list manipulation functions
> - */
> -
> -/*
>   * Add the extent to the list of extents to be free at transaction end.
>   * The list is maintained sorted (by block number).
>   */

This comment could be fixed now that the sort is deferred.

> @@ -602,58 +598,22 @@ xfs_bmap_add_free(
>  	xfs_bmap_free_t		*flist,		/* list of extents */
>  	xfs_mount_t		*mp)		/* mount point structure */
>  {
> -	xfs_bmap_free_item_t	*cur;		/* current (next) element */
> -	xfs_bmap_free_item_t	*new;		/* new element */
> -	xfs_bmap_free_item_t	*prev;		/* previous element */
> -#ifdef DEBUG
> -	xfs_agnumber_t		agno;
> -	xfs_agblock_t		agbno;
> +	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, bno);
> +	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, bno);
> +	struct xfs_freed_extent	*new;
>  
>  	ASSERT(bno != NULLFSBLOCK);
>  	ASSERT(len > 0);
>  	ASSERT(len <= MAXEXTLEN);
>  	ASSERT(!isnullstartblock(bno));
> -	agno = XFS_FSB_TO_AGNO(mp, bno);
> -	agbno = XFS_FSB_TO_AGBNO(mp, bno);
>  	ASSERT(agno < mp->m_sb.sb_agcount);
>  	ASSERT(agbno < mp->m_sb.sb_agblocks);
>  	ASSERT(len < mp->m_sb.sb_agblocks);
>  	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
> -#endif
> -	ASSERT(xfs_bmap_free_item_zone != NULL);
> -	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
> -	new->xbfi_startblock = bno;
> -	new->xbfi_blockcount = (xfs_extlen_t)len;
> -	for (prev = NULL, cur = flist->xbf_first;
> -	     cur != NULL;
> -	     prev = cur, cur = cur->xbfi_next) {
> -		if (cur->xbfi_startblock >= bno)
> -			break;
> -	}
> -	if (prev)
> -		prev->xbfi_next = new;
> -	else
> -		flist->xbf_first = new;
> -	new->xbfi_next = cur;
> -	flist->xbf_count++;
> -}
>  
> -/*
> - * Remove the entry "free" from the free item list.  Prev points to the
> - * previous entry, unless "free" is the head of the list.
> - */
> -void
> -xfs_bmap_del_free(
> -	xfs_bmap_free_t		*flist,	/* free item list header */
> -	xfs_bmap_free_item_t	*prev,	/* previous item on list, if any */
> -	xfs_bmap_free_item_t	*free)	/* list item to be freed */
> -{
> -	if (prev)
> -		prev->xbfi_next = free->xbfi_next;
> -	else
> -		flist->xbf_first = free->xbfi_next;
> -	flist->xbf_count--;
> -	kmem_zone_free(xfs_bmap_free_item_zone, free);
> +	new = xfs_freed_extent_alloc(agno, agbno, len, 0);
> +	list_add_tail(&new->list, &flist->xbf_list);
> +	flist->xbf_count++;
>  }
>  
>  /*
> @@ -663,16 +623,14 @@ void
>  xfs_bmap_cancel(
>  	xfs_bmap_free_t		*flist)	/* list of bmap_free_items */
>  {
> -	xfs_bmap_free_item_t	*free;	/* free list item */
> -	xfs_bmap_free_item_t	*next;
> +	struct xfs_freed_extent	*free, *n;
>  
> -	if (flist->xbf_count == 0)
> -		return;
> -	ASSERT(flist->xbf_first != NULL);
> -	for (free = flist->xbf_first; free; free = next) {
> -		next = free->xbfi_next;
> -		xfs_bmap_del_free(flist, NULL, free);
> +	list_for_each_entry_safe(free, n, &flist->xbf_list, list) {
> +		list_del(&free->list);
> +		flist->xbf_count--;
> +		kmem_zone_free(xfs_freed_extent_zone, free);
>  	}
> +
>  	ASSERT(flist->xbf_count == 0);
>  }
>  
> diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
> index f84bd7a..73cedc4 100644
> --- a/fs/xfs/xfs_bmap.h
> +++ b/fs/xfs/xfs_bmap.h
> @@ -25,19 +25,6 @@ struct xfs_inode;
>  struct xfs_mount;
>  struct xfs_trans;
>  
> -extern kmem_zone_t	*xfs_bmap_free_item_zone;
> -
> -/*
> - * List of extents to be free "later".
> - * The list is kept sorted on xbf_startblock.
> - */
> -typedef struct xfs_bmap_free_item
> -{
> -	xfs_fsblock_t		xbfi_startblock;/* starting fs block number */
> -	xfs_extlen_t		xbfi_blockcount;/* number of blocks in extent */
> -	struct xfs_bmap_free_item *xbfi_next;	/* link to next entry */
> -} xfs_bmap_free_item_t;
> -
>  /*
>   * Header for free extent list.
>   *
> @@ -52,9 +39,8 @@ typedef struct xfs_bmap_free_item
>   * transaction reservations have been made then this algorithm will eventually
>   * find all the space it needs.
>   */
> -typedef	struct xfs_bmap_free
> -{
> -	xfs_bmap_free_item_t	*xbf_first;	/* list of to-be-free extents */
> +typedef	struct xfs_bmap_free {
> +	struct list_head	xbf_list;
>  	int			xbf_count;	/* count of items on list */
>  	int			xbf_low;	/* alloc in low mode */
>  } xfs_bmap_free_t;
> @@ -103,8 +89,10 @@ static inline int xfs_bmapi_aflag(int w)
>  
>  static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
>  {
> -	((flp)->xbf_first = NULL, (flp)->xbf_count = 0, \
> -		(flp)->xbf_low = 0, *(fbp) = NULLFSBLOCK);
> +	INIT_LIST_HEAD(&flp->xbf_list);
> +	flp->xbf_count = 0;
> +	flp->xbf_low = 0;
> +	*fbp = NULLFSBLOCK;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 01f6a64..ade325f 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -59,6 +59,22 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
>  		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
>  }
>  
> +STATIC int
> +xfs_freed_extent_cmp(
> +	void			*priv,
> +	struct list_head	*la,
> +	struct list_head	*lb)
> +{
> +	struct xfs_freed_extent *a =
> +		container_of(la, struct xfs_freed_extent, list);
> +	struct xfs_freed_extent *b =
> +		container_of(lb, struct xfs_freed_extent, list);
> +
> +	if (a->agno == b->agno)
> +		return a->bno - b->bno;

Could we just do a comparison here and return +/-1? 

> +	return a->agno - b->agno;
> +}
> +
>  /*
>   * Routine to be called at transaction's end by xfs_bmapi, xfs_bunmapi
>   * caller.  Frees all the extents that need freeing, which must be done
> @@ -74,13 +90,12 @@ xfs_bmap_finish(
>  	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
>  	int			*committed)	/* xact committed or not */
>  {
> +	struct xfs_mount	*mp = (*tp)->t_mountp;
> +	struct xfs_freed_extent	*free;
>  	xfs_efd_log_item_t	*efd;		/* extent free data */
>  	xfs_efi_log_item_t	*efi;		/* extent free intention */
>  	int			error;		/* error return value */
> -	xfs_bmap_free_item_t	*free;		/* free extent item */
>  	struct xfs_trans_res	tres;		/* new log reservation */
> -	xfs_mount_t		*mp;		/* filesystem mount structure */
> -	xfs_bmap_free_item_t	*next;		/* next item on free list */
>  	xfs_trans_t		*ntp;		/* new transaction pointer */
>  
>  	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> @@ -90,9 +105,14 @@ xfs_bmap_finish(
>  	}
>  	ntp = *tp;
>  	efi = xfs_trans_get_efi(ntp, flist->xbf_count);
> -	for (free = flist->xbf_first; free; free = free->xbfi_next)
> -		xfs_trans_log_efi_extent(ntp, efi, free->xbfi_startblock,
> -			free->xbfi_blockcount);
> +
> +	list_sort(NULL, &flist->xbf_list, xfs_freed_extent_cmp);
> +
> +	list_for_each_entry(free, &flist->xbf_list, list) {
> +		xfs_trans_log_efi_extent(ntp, efi,
> +			XFS_AGB_TO_FSB(mp, free->agno, free->bno),
> +			free->length);
> +	}
>  
>  	tres.tr_logres = ntp->t_log_res;
>  	tres.tr_logcount = ntp->t_log_count;
> @@ -118,10 +138,10 @@ xfs_bmap_finish(
>  	if (error)
>  		return error;
>  	efd = xfs_trans_get_efd(ntp, efi, flist->xbf_count);
> -	for (free = flist->xbf_first; free != NULL; free = next) {
> -		next = free->xbfi_next;
> -		if ((error = xfs_free_extent(ntp, free->xbfi_startblock,
> -				free->xbfi_blockcount))) {
> +
> +	list_for_each_entry(free, &flist->xbf_list, list) {
> +		error = __xfs_free_extent(ntp, free);
> +		if (error) {
>  			/*
>  			 * The bmap free list will be cleaned up at a
>  			 * higher level.  The EFI will be canceled when

So it seems like technically we could get away with still doing the list
migration here an extent at a time, but that would turn this code kind
of ugly (e.g., to remove each entry from xbf_list as we go).

Also, it appears we no longer do the xfs_extent_busy_insert() in this
path..?

> @@ -130,7 +150,6 @@ xfs_bmap_finish(
>  			 * happens, since this transaction may not be
>  			 * dirty yet.
>  			 */
> -			mp = ntp->t_mountp;
>  			if (!XFS_FORCED_SHUTDOWN(mp))
>  				xfs_force_shutdown(mp,
>  						   (error == EFSCORRUPTED) ?
> @@ -138,10 +157,13 @@ xfs_bmap_finish(
>  						   SHUTDOWN_META_IO_ERROR);
>  			return error;
>  		}
> -		xfs_trans_log_efd_extent(ntp, efd, free->xbfi_startblock,
> -			free->xbfi_blockcount);
> -		xfs_bmap_del_free(flist, NULL, free);
> +
> +		xfs_trans_log_efd_extent(ntp, efd,
> +			XFS_AGB_TO_FSB(mp, free->agno, free->bno),
> +			free->length);
>  	}
> +
> +	list_splice_init(&flist->xbf_list, &ntp->t_busy);
>  	return 0;
>  }
>  
> @@ -826,7 +848,7 @@ xfs_bmap_punch_delalloc_range(
>  		if (error)
>  			break;
>  
> -		ASSERT(!flist.xbf_count && !flist.xbf_first);
> +		ASSERT(!flist.xbf_count && list_empty(&flist.xbf_list));
>  next_block:
>  		start_fsb++;
>  		remaining--;
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 935ed2b..ffb26ea 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -21,7 +21,6 @@
>  /* Kernel only BMAP related definitions and functions */
>  
>  struct xfs_bmbt_irec;
> -struct xfs_bmap_free_item;
>  struct xfs_ifork;
>  struct xfs_inode;
>  struct xfs_mount;
> @@ -80,9 +79,6 @@ int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
>  		xfs_bmap_format_t formatter, void *arg);
>  
>  /* functions in xfs_bmap.c that are only needed by xfs_bmap_util.c */
> -void	xfs_bmap_del_free(struct xfs_bmap_free *flist,
> -			  struct xfs_bmap_free_item *prev,
> -			  struct xfs_bmap_free_item *free);
>  int	xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
>  			       struct xfs_bmbt_irec *prevp, xfs_extlen_t extsz,
>  			       int rt, int eof, int delay, int convert,
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 4f11ef0..e3d0f18 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -215,7 +215,7 @@ xfs_discard_extents(
>  	struct xfs_mount	*mp,
>  	struct list_head	*list)
>  {
> -	struct xfs_extent_busy	*busyp;
> +	struct xfs_freed_extent	*busyp;
>  	int			error = 0;
>  
>  	list_for_each_entry(busyp, list, list) {
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index fd22f69..f4711ee 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -35,51 +35,29 @@
>  void
>  xfs_extent_busy_insert(
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> -	xfs_agblock_t		bno,
> -	xfs_extlen_t		len,
> -	unsigned int		flags)
> +	struct xfs_freed_extent	*new)
>  {

tp is only used for the mount now, so we can probably replace tp with
mp.

Brian

> -	struct xfs_extent_busy	*new;
> -	struct xfs_extent_busy	*busyp;
> +	struct xfs_freed_extent	*busyp;
>  	struct xfs_perag	*pag;
>  	struct rb_node		**rbp;
>  	struct rb_node		*parent = NULL;
>  
> -	new = kmem_zalloc(sizeof(struct xfs_extent_busy), KM_MAYFAIL);
> -	if (!new) {
> -		/*
> -		 * No Memory!  Since it is now not possible to track the free
> -		 * block, make this a synchronous transaction to insure that
> -		 * the block is not reused before this transaction commits.
> -		 */
> -		trace_xfs_extent_busy_enomem(tp->t_mountp, agno, bno, len);
> -		xfs_trans_set_sync(tp);
> -		return;
> -	}
> -
> -	new->agno = agno;
> -	new->bno = bno;
> -	new->length = len;
> -	INIT_LIST_HEAD(&new->list);
> -	new->flags = flags;
> -
>  	/* trace before insert to be able to see failed inserts */
> -	trace_xfs_extent_busy(tp->t_mountp, agno, bno, len);
> +	trace_xfs_extent_busy(tp->t_mountp, new->agno, new->bno, new->length);
>  
>  	pag = xfs_perag_get(tp->t_mountp, new->agno);
>  	spin_lock(&pag->pagb_lock);
>  	rbp = &pag->pagb_tree.rb_node;
>  	while (*rbp) {
>  		parent = *rbp;
> -		busyp = rb_entry(parent, struct xfs_extent_busy, rb_node);
> +		busyp = rb_entry(parent, struct xfs_freed_extent, rb_node);
>  
>  		if (new->bno < busyp->bno) {
>  			rbp = &(*rbp)->rb_left;
>  			ASSERT(new->bno + new->length <= busyp->bno);
>  		} else if (new->bno > busyp->bno) {
>  			rbp = &(*rbp)->rb_right;
> -			ASSERT(bno >= busyp->bno + busyp->length);
> +			ASSERT(new->bno >= busyp->bno + busyp->length);
>  		} else {
>  			ASSERT(0);
>  		}
> @@ -88,7 +66,6 @@ xfs_extent_busy_insert(
>  	rb_link_node(&new->rb_node, parent, rbp);
>  	rb_insert_color(&new->rb_node, &pag->pagb_tree);
>  
> -	list_add(&new->list, &tp->t_busy);
>  	spin_unlock(&pag->pagb_lock);
>  	xfs_perag_put(pag);
>  }
> @@ -111,7 +88,7 @@ xfs_extent_busy_search(
>  {
>  	struct xfs_perag	*pag;
>  	struct rb_node		*rbp;
> -	struct xfs_extent_busy	*busyp;
> +	struct xfs_freed_extent	*busyp;
>  	int			match = 0;
>  
>  	pag = xfs_perag_get(mp, agno);
> @@ -121,7 +98,7 @@ xfs_extent_busy_search(
>  
>  	/* find closest start bno overlap */
>  	while (rbp) {
> -		busyp = rb_entry(rbp, struct xfs_extent_busy, rb_node);
> +		busyp = rb_entry(rbp, struct xfs_freed_extent, rb_node);
>  		if (bno < busyp->bno) {
>  			/* may overlap, but exact start block is lower */
>  			if (bno + len > busyp->bno)
> @@ -158,7 +135,7 @@ STATIC bool
>  xfs_extent_busy_update_extent(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag,
> -	struct xfs_extent_busy	*busyp,
> +	struct xfs_freed_extent	*busyp,
>  	xfs_agblock_t		fbno,
>  	xfs_extlen_t		flen,
>  	bool			userdata) __releases(&pag->pagb_lock)
> @@ -173,7 +150,7 @@ xfs_extent_busy_update_extent(
>  	 * performing the discard a chance to mark the extent unbusy
>  	 * and retry.
>  	 */
> -	if (busyp->flags & XFS_EXTENT_BUSY_DISCARDED) {
> +	if (busyp->flags & XFS_EXTENT_DISCARDED) {
>  		spin_unlock(&pag->pagb_lock);
>  		delay(1);
>  		spin_lock(&pag->pagb_lock);
> @@ -320,8 +297,8 @@ xfs_extent_busy_reuse(
>  restart:
>  	rbp = pag->pagb_tree.rb_node;
>  	while (rbp) {
> -		struct xfs_extent_busy *busyp =
> -			rb_entry(rbp, struct xfs_extent_busy, rb_node);
> +		struct xfs_freed_extent *busyp =
> +			rb_entry(rbp, struct xfs_freed_extent, rb_node);
>  		xfs_agblock_t	bbno = busyp->bno;
>  		xfs_agblock_t	bend = bbno + busyp->length;
>  
> @@ -367,8 +344,8 @@ restart:
>  	flen = len;
>  	rbp = args->pag->pagb_tree.rb_node;
>  	while (rbp && flen >= args->minlen) {
> -		struct xfs_extent_busy *busyp =
> -			rb_entry(rbp, struct xfs_extent_busy, rb_node);
> +		struct xfs_freed_extent *busyp =
> +			rb_entry(rbp, struct xfs_freed_extent, rb_node);
>  		xfs_agblock_t	fend = fbno + flen;
>  		xfs_agblock_t	bbno = busyp->bno;
>  		xfs_agblock_t	bend = bbno + busyp->length;
> @@ -386,7 +363,7 @@ restart:
>  		 * extent instead of trimming the allocation.
>  		 */
>  		if (!args->userdata &&
> -		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
> +		    !(busyp->flags & XFS_EXTENT_DISCARDED)) {
>  			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
>  							  busyp, fbno, flen,
>  							  false))
> @@ -540,7 +517,7 @@ STATIC void
>  xfs_extent_busy_clear_one(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag,
> -	struct xfs_extent_busy	*busyp)
> +	struct xfs_freed_extent	*busyp)
>  {
>  	if (busyp->length) {
>  		trace_xfs_extent_busy_clear(mp, busyp->agno, busyp->bno,
> @@ -549,7 +526,7 @@ xfs_extent_busy_clear_one(
>  	}
>  
>  	list_del_init(&busyp->list);
> -	kmem_free(busyp);
> +	kmem_zone_free(xfs_freed_extent_zone, busyp);
>  }
>  
>  /*
> @@ -563,7 +540,7 @@ xfs_extent_busy_clear(
>  	struct list_head	*list,
>  	bool			do_discard)
>  {
> -	struct xfs_extent_busy	*busyp, *n;
> +	struct xfs_freed_extent	*busyp, *n;
>  	struct xfs_perag	*pag = NULL;
>  	xfs_agnumber_t		agno = NULLAGNUMBER;
>  
> @@ -579,8 +556,8 @@ xfs_extent_busy_clear(
>  		}
>  
>  		if (do_discard && busyp->length &&
> -		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD))
> -			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
> +		    !(busyp->flags & XFS_EXTENT_SKIP_DISCARD))
> +			busyp->flags = XFS_EXTENT_DISCARDED;
>  		else
>  			xfs_extent_busy_clear_one(mp, pag, busyp);
>  	}
> @@ -600,6 +577,6 @@ xfs_extent_busy_ag_cmp(
>  	struct list_head	*a,
>  	struct list_head	*b)
>  {
> -	return container_of(a, struct xfs_extent_busy, list)->agno -
> -		container_of(b, struct xfs_extent_busy, list)->agno;
> +	return container_of(a, struct xfs_freed_extent, list)->agno -
> +		container_of(b, struct xfs_freed_extent, list)->agno;
>  }
> diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> index bfff284..ccc8a13 100644
> --- a/fs/xfs/xfs_extent_busy.h
> +++ b/fs/xfs/xfs_extent_busy.h
> @@ -20,31 +20,13 @@
>  #ifndef __XFS_EXTENT_BUSY_H__
>  #define	__XFS_EXTENT_BUSY_H__
>  
> +struct xfs_freed_extent;
>  struct xfs_mount;
>  struct xfs_trans;
>  struct xfs_alloc_arg;
>  
> -/*
> - * Busy block/extent entry.  Indexed by a rbtree in perag to mark blocks that
> - * have been freed but whose transactions aren't committed to disk yet.
> - *
> - * Note that we use the transaction ID to record the transaction, not the
> - * transaction structure itself. See xfs_extent_busy_insert() for details.
> - */
> -struct xfs_extent_busy {
> -	struct rb_node	rb_node;	/* ag by-bno indexed search tree */
> -	struct list_head list;		/* transaction busy extent list */
> -	xfs_agnumber_t	agno;
> -	xfs_agblock_t	bno;
> -	xfs_extlen_t	length;
> -	unsigned int	flags;
> -#define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
> -#define XFS_EXTENT_BUSY_SKIP_DISCARD	0x02	/* do not discard */
> -};
> -
>  void
> -xfs_extent_busy_insert(struct xfs_trans *tp, xfs_agnumber_t agno,
> -	xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
> +xfs_extent_busy_insert(struct xfs_trans	*tp, struct xfs_freed_extent *free);
>  
>  void
>  xfs_extent_busy_clear(struct xfs_mount *mp, struct list_head *list,
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f317488..a674664 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1581,15 +1581,15 @@ xfs_init_zones(void)
>  	if (!xfs_log_ticket_zone)
>  		goto out_destroy_ioend_pool;
>  
> -	xfs_bmap_free_item_zone = kmem_zone_init(sizeof(xfs_bmap_free_item_t),
> -						"xfs_bmap_free_item");
> -	if (!xfs_bmap_free_item_zone)
> +	xfs_freed_extent_zone = kmem_zone_init(sizeof(struct xfs_freed_extent),
> +						"xfs_freed_extent");
> +	if (!xfs_freed_extent_zone)
>  		goto out_destroy_log_ticket_zone;
>  
>  	xfs_btree_cur_zone = kmem_zone_init(sizeof(xfs_btree_cur_t),
>  						"xfs_btree_cur");
>  	if (!xfs_btree_cur_zone)
> -		goto out_destroy_bmap_free_item_zone;
> +		goto out_destroy_freed_extent_zone;
>  
>  	xfs_da_state_zone = kmem_zone_init(sizeof(xfs_da_state_t),
>  						"xfs_da_state");
> @@ -1671,8 +1671,8 @@ xfs_init_zones(void)
>  	kmem_zone_destroy(xfs_da_state_zone);
>   out_destroy_btree_cur_zone:
>  	kmem_zone_destroy(xfs_btree_cur_zone);
> - out_destroy_bmap_free_item_zone:
> -	kmem_zone_destroy(xfs_bmap_free_item_zone);
> + out_destroy_freed_extent_zone:
> +	kmem_zone_destroy(xfs_freed_extent_zone);
>   out_destroy_log_ticket_zone:
>  	kmem_zone_destroy(xfs_log_ticket_zone);
>   out_destroy_ioend_pool:
> @@ -1702,7 +1702,7 @@ xfs_destroy_zones(void)
>  	kmem_zone_destroy(xfs_ifork_zone);
>  	kmem_zone_destroy(xfs_da_state_zone);
>  	kmem_zone_destroy(xfs_btree_cur_zone);
> -	kmem_zone_destroy(xfs_bmap_free_item_zone);
> +	kmem_zone_destroy(xfs_freed_extent_zone);
>  	kmem_zone_destroy(xfs_log_ticket_zone);
>  	mempool_destroy(xfs_ioend_pool);
>  	kmem_zone_destroy(xfs_ioend_zone);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a4ae41c..2dfe819 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1313,7 +1313,6 @@ DEFINE_EVENT(xfs_extent_busy_class, name, \
>  		 xfs_agblock_t agbno, xfs_extlen_t len), \
>  	TP_ARGS(mp, agno, agbno, len))
>  DEFINE_BUSY_EVENT(xfs_extent_busy);
> -DEFINE_BUSY_EVENT(xfs_extent_busy_enomem);
>  DEFINE_BUSY_EVENT(xfs_extent_busy_force);
>  DEFINE_BUSY_EVENT(xfs_extent_busy_reuse);
>  DEFINE_BUSY_EVENT(xfs_extent_busy_clear);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

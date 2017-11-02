Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751898AbdKBROj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 13:14:39 -0400
Date: Thu, 2 Nov 2017 13:14:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/18] xfs: introduce the xfs_iext_cursor abstraction
Message-ID: <20171102171437.GH16645@bfoster.bfoster>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031142230.11755-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 04:22:24PM +0200, Christoph Hellwig wrote:
> Add a new xfs_iext_cursor structure to hide the direct extent map
> index manipulations. In addition to the existing lookup/get/insert/
> remove and update routines new primitives to get the first and last
> extent cursor, as well as moving up and down by one extent are
> provided.  Also new are convenience to increment/decrement the
> cursor and retreive the new extent, as well as to peek into the
> previous/next extent without updating the cursor and last but not
> least a macro to iterate over all extents in a fork.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 432 ++++++++++++++++++++---------------------
>  fs/xfs/libxfs/xfs_bmap.h       |  12 +-
>  fs/xfs/libxfs/xfs_inode_fork.c |  75 +++----
>  fs/xfs/libxfs/xfs_inode_fork.h |  87 ++++++++-
>  fs/xfs/libxfs/xfs_types.h      |   3 +
>  fs/xfs/scrub/bmap.c            |   6 +-
>  fs/xfs/scrub/dir.c             |  14 +-
>  fs/xfs/xfs_bmap_util.c         |  12 +-
>  fs/xfs/xfs_dir2_readdir.c      |   8 +-
>  fs/xfs/xfs_dquot.c             |   4 +-
>  fs/xfs/xfs_iomap.c             |  13 +-
>  fs/xfs/xfs_reflink.c           |  56 +++---
>  fs/xfs/xfs_trace.h             |  12 +-
>  13 files changed, 401 insertions(+), 333 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 56482bf6280d..453dc1ae76ab 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
...
> @@ -1263,7 +1268,8 @@ xfs_iread_extents(
>  			}
>  			trp->l0 = be64_to_cpu(frp->l0);
>  			trp->l1 = be64_to_cpu(frp->l1);
> -			trace_xfs_read_extent(ip, i, state, _THIS_IP_);
> +			trace_xfs_read_extent(ip, &ext, state, _THIS_IP_);
> +			xfs_iext_next(ifp, &ext);

Can we just open code ext->idx here rather than maintain two counters,
or will that go away later?

BTW, I agree with Darrick's comment regarding 'ext' vs. 'cur' naming.
The former causes me to confuse the cursor field with the record field
in the cursor processing code.

>  		}
>  		xfs_trans_brelse(tp, bp);
>  		bno = nextbno;
...
> @@ -1553,8 +1558,6 @@ xfs_bmap_add_extent_delay_real(
>  	nextents = (whichfork == XFS_COW_FORK ? &bma->ip->i_cnextents :
>  						&bma->ip->i_d.di_nextents);
>  
> -	ASSERT(bma->idx >= 0);
> -	ASSERT(bma->idx <= xfs_iext_count(ifp));

I think it might be useful to encapsulate this check (which is also part
of xfs_iext_get_extent()) into a cursor validation helper so we can
preserve these asserts (here and in the other bmap functions). E.g.,
something like:

	ASSERT(xfs_iext_valid(&bma->ext));

>  	ASSERT(!isnullstartblock(new->br_startblock));
>  	ASSERT(!bma->cur ||
>  	       (bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
...
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 7dd77b497fc2..c9e10d4818b7 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
...
> @@ -1948,31 +1955,31 @@ xfs_iext_lookup_extent_before(
>  	struct xfs_inode	*ip,
>  	struct xfs_ifork	*ifp,
>  	xfs_fileoff_t		*end,
> -	xfs_extnum_t		*idxp,
> +	struct xfs_iext_cursor	*cur,
>  	struct xfs_bmbt_irec	*gotp)
>  {
> -	if (xfs_iext_lookup_extent(ip, ifp, *end - 1, idxp, gotp) &&
> +	if (xfs_iext_lookup_extent(ip, ifp, *end - 1, cur, gotp) &&
>  	    gotp->br_startoff <= *end - 1)
>  		return true;
> -	if (!xfs_iext_get_extent(ifp, --*idxp, gotp))
> +	if (!xfs_iext_prev_extent(ifp, cur, gotp))
>  		return false;
>  	*end = gotp->br_startoff + gotp->br_blockcount;
>  	return true;
>  }
>  
>  /*
> - * Return true if there is an extent at index idx, and return the expanded
> - * extent structure at idx in that case.  Else return false.
> + * Return true if there is an extent at cursor cur and return the expanded
> + * extent structure at cur in gotp in that case.  Else return false.

"Return true if the cursor points at an extent and return the extent
structure in gotp. Else return false."

>   */
>  bool
>  xfs_iext_get_extent(
>  	struct xfs_ifork	*ifp,
> -	xfs_extnum_t		idx,
> +	struct xfs_iext_cursor	*cur,
>  	struct xfs_bmbt_irec	*gotp)
>  {
> -	if (idx < 0 || idx >= xfs_iext_count(ifp))
> +	if (cur->idx < 0 || cur->idx >= xfs_iext_count(ifp))
>  		return false;
> -	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), gotp);
> +	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, cur->idx), gotp);
>  	return true;
>  }
>  
...
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 113fd42ec36d..dc347dd9dc78 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
...
> @@ -182,15 +183,85 @@ void		xfs_iext_irec_update_extoffs(struct xfs_ifork *, int, int);
>  
>  bool		xfs_iext_lookup_extent(struct xfs_inode *ip,
>  			struct xfs_ifork *ifp, xfs_fileoff_t bno,
> -			xfs_extnum_t *idxp, struct xfs_bmbt_irec *gotp);
> +			struct xfs_iext_cursor *cur,
> +			 struct xfs_bmbt_irec *gotp);

Indentation looks off here.

>  bool		xfs_iext_lookup_extent_before(struct xfs_inode *ip,
>  			struct xfs_ifork *ifp, xfs_fileoff_t *end,
> -			xfs_extnum_t *idxp, struct xfs_bmbt_irec *gotp);
> -
> -bool		xfs_iext_get_extent(struct xfs_ifork *ifp, xfs_extnum_t idx,
> +			struct xfs_iext_cursor *cur,
> +			struct xfs_bmbt_irec *gotp);
> +bool		xfs_iext_get_extent(struct xfs_ifork *ifp,
> +			struct xfs_iext_cursor *cur,
>  			struct xfs_bmbt_irec *gotp);
>  void		xfs_iext_update_extent(struct xfs_inode *ip, int state,
> -			xfs_extnum_t idx, struct xfs_bmbt_irec *gotp);
> +			struct xfs_iext_cursor *cur,
> +			struct xfs_bmbt_irec *gotp);
> +
...
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index f04dbfb2f50d..5da6382bdaf1 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -142,5 +142,8 @@ typedef uint32_t	xfs_dqid_t;
>  #define	XFS_NBWORD	(1 << XFS_NBWORDLOG)
>  #define	XFS_WORDMASK	((1 << XFS_WORDLOG) - 1)
>  
> +struct xfs_iext_cursor {
> +	xfs_extnum_t		idx;
> +};
>  

FWIW, this patch has me wondering about a couple things that may not be
apparent until I get through more of the series:

1.) Why do we place these new cursors directly on the stack as opposed
to dynamic allocation?
2.) Why not encode the fork/inode in the cursor rather than passing them
around throughout the helper functions?

Brian

...
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

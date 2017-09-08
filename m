Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756600AbdIHRTG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 13:19:06 -0400
Date: Fri, 8 Sep 2017 13:19:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 13/17] xfs: pass a struct xfs_bmbt_irec to xfs_bmbt_update
Message-ID: <20170908171904.GC905@bfoster.bfoster>
References: <20170903072956.3175-1-hch@lst.de>
 <20170903072956.3175-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903072956.3175-14-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 09:29:52AM +0200, Christoph Hellwig wrote:
> Now that we've massaged the callers into the right form we can always
> pass the actual extent record instead of the individual fields.
> 
> With that xfs_bmbt_disk_set_allf can go away, and xfs_bmbt_disk_set_all
> can be merged into the former implementation of xfs_bmbt_disk_set_allf.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c       | 114 +++++++++++------------------------------
>  fs/xfs/libxfs/xfs_bmap_btree.c |  42 +++++----------
>  fs/xfs/libxfs/xfs_bmap_btree.h |   4 +-
>  3 files changed, 44 insertions(+), 116 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index bc41fc18cceb..9d1e66c708f9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -161,21 +161,17 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>  }
>  
>  /*
> - * Update the record referred to by cur to the value given
> - * by [off, bno, len, state].
> + * Update the record referred to by cur to the value given by irec
>   * This either works (return 0) or gets an EFSCORRUPTED error.
>   */
>  STATIC int
>  xfs_bmbt_update(
>  	struct xfs_btree_cur	*cur,
> -	xfs_fileoff_t		off,
> -	xfs_fsblock_t		bno,
> -	xfs_filblks_t		len,
> -	xfs_exntst_t		state)
> +	struct xfs_bmbt_irec	*irec)
>  {
>  	union xfs_btree_rec	rec;
>  
> -	xfs_bmbt_disk_set_allf(&rec.bmbt, off, bno, len, state);
> +	xfs_bmbt_disk_set_all(&rec.bmbt, irec);
>  	return xfs_btree_update(cur, &rec);
>  }
>  
> @@ -1729,9 +1725,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
> -					LEFT.br_startblock,
> -					LEFT.br_blockcount, LEFT.br_state);
> +			error = xfs_bmbt_update(bma->cur, &LEFT);
>  			if (error)
>  				goto done;
>  		}
> @@ -1761,9 +1755,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
> -					LEFT.br_startblock,
> -					LEFT.br_blockcount, LEFT.br_state);
> +			error = xfs_bmbt_update(bma->cur, &LEFT);
>  			if (error)
>  				goto done;
>  		}
> @@ -1791,9 +1783,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(bma->cur, PREV.br_startoff,
> -					PREV.br_startblock,
> -					PREV.br_blockcount, PREV.br_state);
> +			error = xfs_bmbt_update(bma->cur, &PREV);
>  			if (error)
>  				goto done;
>  		}
> @@ -1852,9 +1842,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
> -					LEFT.br_startblock, LEFT.br_blockcount,
> -					LEFT.br_state);
> +			error = xfs_bmbt_update(bma->cur, &LEFT);
>  			if (error)
>  				goto done;
>  		}
> @@ -1942,9 +1930,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(bma->cur, new->br_startoff,
> -					new->br_startblock, new->br_blockcount,
> -					new->br_state);
> +			error = xfs_bmbt_update(bma->cur, new);
>  			if (error)
>  				goto done;
>  		}
> @@ -2304,9 +2290,7 @@ xfs_bmap_add_extent_unwritten_real(
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(cur, LEFT.br_startoff,
> -					LEFT.br_startblock, LEFT.br_blockcount,
> -					LEFT.br_state);
> +			error = xfs_bmbt_update(cur, &LEFT);
>  			if (error)
>  				goto done;
>  		}
> @@ -2342,9 +2326,7 @@ xfs_bmap_add_extent_unwritten_real(
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(cur, LEFT.br_startoff,
> -					LEFT.br_startblock, LEFT.br_blockcount,
> -					LEFT.br_state);
> +			error = xfs_bmbt_update(cur, &LEFT);
>  			if (error)
>  				goto done;
>  		}
> @@ -2379,9 +2361,7 @@ xfs_bmap_add_extent_unwritten_real(
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(cur, PREV.br_startoff,
> -					PREV.br_startblock, PREV.br_blockcount,
> -					PREV.br_state);
> +			error = xfs_bmbt_update(cur, &PREV);
>  			if (error)
>  				goto done;
>  		}
> @@ -2407,9 +2387,7 @@ xfs_bmap_add_extent_unwritten_real(
>  					&i)))
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(cur, PREV.br_startoff,
> -					PREV.br_startblock, PREV.br_blockcount,
> -					PREV.br_state);
> +			error = xfs_bmbt_update(cur, &PREV);
>  			if (error)
>  				goto done;
>  		}
> @@ -2445,17 +2423,13 @@ xfs_bmap_add_extent_unwritten_real(
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(cur, PREV.br_startoff,
> -					PREV.br_startblock, PREV.br_blockcount,
> -					PREV.br_state);
> +			error = xfs_bmbt_update(cur, &PREV);
>  			if (error)
>  				goto done;
>  			error = xfs_btree_decrement(cur, 0, &i);
>  			if (error)
>  				goto done;
> -			error = xfs_bmbt_update(cur, LEFT.br_startoff,
> -					LEFT.br_startblock, LEFT.br_blockcount,
> -					LEFT.br_state);
> +			error = xfs_bmbt_update(cur, &LEFT);
>  			if (error)
>  				goto done;
>  		}
> @@ -2487,9 +2461,7 @@ xfs_bmap_add_extent_unwritten_real(
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(cur, PREV.br_startoff,
> -					PREV.br_startblock, PREV.br_blockcount,
> -					PREV.br_state);
> +			error = xfs_bmbt_update(cur, &PREV);
>  			if (error)
>  				goto done;
>  			cur->bc_rec.b = *new;
> @@ -2529,17 +2501,13 @@ xfs_bmap_add_extent_unwritten_real(
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(cur, PREV.br_startoff,
> -					PREV.br_startblock, PREV.br_blockcount,
> -					PREV.br_state);
> +			error = xfs_bmbt_update(cur, &PREV);
>  			if (error)
>  				goto done;
>  			error = xfs_btree_increment(cur, 0, &i);
>  			if (error)
>  				goto done;
> -			error = xfs_bmbt_update(cur, RIGHT.br_startoff,
> -					RIGHT.br_startblock,
> -					RIGHT.br_blockcount, RIGHT.br_state);
> +			error = xfs_bmbt_update(cur, &RIGHT);
>  			if (error)
>  				goto done;
>  		}
> @@ -2571,9 +2539,7 @@ xfs_bmap_add_extent_unwritten_real(
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(cur, PREV.br_startoff,
> -					PREV.br_startblock, PREV.br_blockcount,
> -					PREV.br_state);
> +			error = xfs_bmbt_update(cur, &PREV);
>  			if (error)
>  				goto done;
>  			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
> @@ -2623,9 +2589,8 @@ xfs_bmap_add_extent_unwritten_real(
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  			/* new right extent - oldext */
> -			if ((error = xfs_bmbt_update(cur, r[1].br_startoff,
> -				r[1].br_startblock, r[1].br_blockcount,
> -				r[1].br_state)))
> +			error = xfs_bmbt_update(cur, &r[1]);
> +			if (error)
>  				goto done;
>  			/* new left extent - oldext */
>  			cur->bc_rec.b = PREV;
> @@ -2966,9 +2931,7 @@ xfs_bmap_add_extent_hole_real(
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(cur, left.br_startoff,
> -					left.br_startblock,
> -					left.br_blockcount, left.br_state);
> +			error = xfs_bmbt_update(cur, &left);
>  			if (error)
>  				goto done;
>  		}
> @@ -2997,9 +2960,7 @@ xfs_bmap_add_extent_hole_real(
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(cur, left.br_startoff,
> -					left.br_startblock,
> -					left.br_blockcount, left.br_state);
> +			error = xfs_bmbt_update(cur, &left);
>  			if (error)
>  				goto done;
>  		}
> @@ -3029,9 +2990,7 @@ xfs_bmap_add_extent_hole_real(
>  			if (error)
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> -			error = xfs_bmbt_update(cur, right.br_startoff,
> -					right.br_startblock,
> -					right.br_blockcount, right.br_state);
> +			error = xfs_bmbt_update(cur, &right);
>  			if (error)
>  				goto done;
>  		}
> @@ -5204,8 +5163,7 @@ xfs_bmap_del_extent_real(
>  			flags |= xfs_ilog_fext(whichfork);
>  			break;
>  		}
> -		error = xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
> -				got.br_blockcount, got.br_state);
> +		error = xfs_bmbt_update(cur, &got);
>  		if (error)
>  			goto done;
>  		break;
> @@ -5221,8 +5179,7 @@ xfs_bmap_del_extent_real(
>  			flags |= xfs_ilog_fext(whichfork);
>  			break;
>  		}
> -		error = xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
> -				got.br_blockcount, got.br_state);
> +		error = xfs_bmbt_update(cur, &got);
>  		if (error)
>  			goto done;
>  		break;
> @@ -5243,9 +5200,7 @@ xfs_bmap_del_extent_real(
>  
>  		flags |= XFS_ILOG_CORE;
>  		if (cur) {
> -			error = xfs_bmbt_update(cur, got.br_startoff,
> -					got.br_startblock, got.br_blockcount,
> -					got.br_state);
> +			error = xfs_bmbt_update(cur, &got);
>  			if (error)
>  				goto done;
>  			error = xfs_btree_increment(cur, 0, &i);
> @@ -5275,10 +5230,7 @@ xfs_bmap_del_extent_real(
>  				 * Update the btree record back
>  				 * to the original value.
>  				 */
> -				error = xfs_bmbt_update(cur, old.br_startoff,
> -						old.br_startblock,
> -						old.br_blockcount,
> -						old.br_state);
> +				error = xfs_bmbt_update(cur, &old);
>  				if (error)
>  					goto done;
>  				/*
> @@ -5816,8 +5768,7 @@ xfs_bmse_merge(
>  		return error;
>  	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
>  
> -	error = xfs_bmbt_update(cur, new.br_startoff, new.br_startblock,
> -			        new.br_blockcount, new.br_state);
> +	error = xfs_bmbt_update(cur, &new);
>  	if (error)
>  		return error;
>  
> @@ -5934,9 +5885,7 @@ xfs_bmse_shift_one(
>  			return error;
>  		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
>  
> -		error = xfs_bmbt_update(cur, new.br_startoff,
> -				new.br_startblock, new.br_blockcount,
> -				new.br_state);
> +		error = xfs_bmbt_update(cur, &new);
>  		if (error)
>  			return error;
>  	} else {
> @@ -6197,10 +6146,7 @@ xfs_bmap_split_extent_at(
>  
>  	logflags = XFS_ILOG_CORE;
>  	if (cur) {
> -		error = xfs_bmbt_update(cur, got.br_startoff,
> -				got.br_startblock,
> -				got.br_blockcount,
> -				got.br_state);
> +		error = xfs_bmbt_update(cur, &got);
>  		if (error)
>  			goto del_cursor;
>  	} else
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index a6331ffa51e3..7e2d981626ef 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -228,48 +228,32 @@ xfs_bmbt_set_all(
>  			     s->br_blockcount, s->br_state);
>  }
>  
> -
>  /*
> - * Set all the fields in a disk format bmap extent record from the arguments.
> + * Set all the fields in a bmap extent record from the uncompressed form.
>   */
>  void
> -xfs_bmbt_disk_set_allf(
> -	xfs_bmbt_rec_t		*r,
> -	xfs_fileoff_t		startoff,
> -	xfs_fsblock_t		startblock,
> -	xfs_filblks_t		blockcount,
> -	xfs_exntst_t		state)
> +xfs_bmbt_disk_set_all(
> +	struct xfs_bmbt_rec	*r,
> +	struct xfs_bmbt_irec	*s)
>  {
> -	int			extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
> +	int			extent_flag = (s->br_state != XFS_EXT_NORM);
>  
> -	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
> -	ASSERT((startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)) == 0);
> -	ASSERT((blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
> -	ASSERT((startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)) == 0);
> +	ASSERT(s->br_state == XFS_EXT_NORM || s->br_state == XFS_EXT_UNWRITTEN);
> +	ASSERT(!(s->br_startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)));
> +	ASSERT(!(s->br_blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)));
> +	ASSERT(!(s->br_startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)));
>  
>  	r->l0 = cpu_to_be64(
>  		((xfs_bmbt_rec_base_t)extent_flag << 63) |
> -		 ((xfs_bmbt_rec_base_t)startoff << 9) |
> -		 ((xfs_bmbt_rec_base_t)startblock >> 43));
> +		 ((xfs_bmbt_rec_base_t)s->br_startoff << 9) |
> +		 ((xfs_bmbt_rec_base_t)s->br_startblock >> 43));
>  	r->l1 = cpu_to_be64(
> -		((xfs_bmbt_rec_base_t)startblock << 21) |
> -		 ((xfs_bmbt_rec_base_t)blockcount &
> +		((xfs_bmbt_rec_base_t)s->br_startblock << 21) |
> +		 ((xfs_bmbt_rec_base_t)s->br_blockcount &
>  		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
>  }
>  
>  /*
> - * Set all the fields in a bmap extent record from the uncompressed form.
> - */
> -STATIC void
> -xfs_bmbt_disk_set_all(
> -	xfs_bmbt_rec_t	*r,
> -	xfs_bmbt_irec_t *s)
> -{
> -	xfs_bmbt_disk_set_allf(r, s->br_startoff, s->br_startblock,
> -				  s->br_blockcount, s->br_state);
> -}
> -
> -/*
>   * Set the blockcount field in a bmap extent record.
>   */
>  void
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> index 9da5a8d4f184..bd3c56f1cd03 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> @@ -104,6 +104,7 @@ extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_host_t *r);
>  extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_host_t *r);
>  extern xfs_exntst_t xfs_bmbt_get_state(xfs_bmbt_rec_host_t *r);
>  
> +void xfs_bmbt_disk_set_all(struct xfs_bmbt_rec *r, struct xfs_bmbt_irec *s);
>  extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
>  extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
>  
> @@ -115,9 +116,6 @@ extern void xfs_bmbt_set_startblock(xfs_bmbt_rec_host_t *r, xfs_fsblock_t v);
>  extern void xfs_bmbt_set_startoff(xfs_bmbt_rec_host_t *r, xfs_fileoff_t v);
>  extern void xfs_bmbt_set_state(xfs_bmbt_rec_host_t *r, xfs_exntst_t v);
>  
> -extern void xfs_bmbt_disk_set_allf(xfs_bmbt_rec_t *r, xfs_fileoff_t o,
> -			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
> -
>  extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
>  			xfs_bmdr_block_t *, int);
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

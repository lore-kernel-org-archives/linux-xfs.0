Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5C43BED46
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792180013; cv=none; b=t05n9q06BuPUVvBA9PsnXR2oJH5yNT+WVjkQ7aZbNFX2P24aEUVjlaPAuHWug2fywk9cyGMalorbeHHMTwLTYS1m2XXKqTS2ou17o4ctVVHnW2JlxTrYTcnoWZFcOd/v4G/3LC9hKcDiSi9wZpQIWU0ZffS9maLDtpXOW1QcX88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792180013; c=relaxed/simple;
	bh=Wgh7nyJb4gPEyntiWU4aj0AYqCMp/gW1RaIMXKrAxV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHMXcSwfXSq0Zb+TOCW4b5AH0ZQB6cVaE3e/WnjF+c48Mzkj5YeNrU2XxcSYNJGj60Tj+1Tz2+L9wvyE2zCr2kntofdlEELvFmaIk8suDaFIZ0HWYLEy6+rG9pR1KGBJkZ9jf0Y75vqvwFN6nKWVDPb46R54O63eOaVKAb4NxmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCWshrM6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCWshrM6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6FC831F000C4;
	Fri, 16 Oct 2026 19:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792180007;
	bh=+dbBYVzp0axHH8EyeExNitW5LewC/sjIFtXbxi8lP+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VCWshrM6loPa+GL5EXD8NueCvesZf4k32AxKyrZ2RMzwPAzYPsJarLL9Pg0JYnqzT
	 UAnn48QInlN3Mnwn3Dy+aCiUhgil80vgUxu7ULniIx0aoYNsu+tehxHnlgDD4qpMUj
	 5REPkVu3OLfq8qybcCfC+TKIX1tF8UWQza7uo1ECwY1e8OagcgimK0cf3MHoOSS93E
	 WKS813V4VFQfHzwO15yPwZSDYZhaUIILmtvOGPEvj+qJQ8jXlLmOeL9+quUyjGkgbM
	 25RjMLjICMEsSutD9AESsOWKifLPLbO9PQCXqpXsLaqsbhyjXz4Mtuo+jRSvFE8rEd
	 amr9Y6Iu78OBg==
Date: Fri, 16 Oct 2026 12:46:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de, dgc@kernel.org
Subject: Re: [PATCH 5/8] xfs: remove status parameter from several btree
 insert functions
Message-ID: <20261016194647.GG107986@frogsfrogsfrogs>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-6-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016193422.1630907-6-sandeen@redhat.com>

On Fri, Oct 16, 2026 at 02:29:05PM -0500, Eric Sandeen wrote:
> xfs_btree_insert and its callers now have no need for the status
> parameter; either they return error = 0 / status = 1, or nonzero error
> and status 0. No caller evaluates the status variable, so remove that
> parameter from these functions.
> 
> As requested, convert all of the compound tests/assignments to discrete
> lines.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c    | 15 ++++++++++-----
>  fs/xfs/libxfs/xfs_bmap.c     | 26 +++++++++++++++-----------
>  fs/xfs/libxfs/xfs_btree.c    |  4 +---
>  fs/xfs/libxfs/xfs_btree.h    |  2 +-
>  fs/xfs/libxfs/xfs_ialloc.c   | 13 ++++++-------
>  fs/xfs/libxfs/xfs_ialloc.h   |  3 +--
>  fs/xfs/libxfs/xfs_refcount.c | 17 +++++++----------
>  fs/xfs/libxfs/xfs_refcount.h |  2 +-
>  fs/xfs/libxfs/xfs_rmap.c     | 14 +++++++-------
>  fs/xfs/scrub/rcbag.c         |  2 +-
>  fs/xfs/scrub/rcbag_btree.c   |  5 ++---
>  fs/xfs/scrub/rcbag_btree.h   |  3 +--
>  12 files changed, 53 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index b40c51a0f651..acd8f4521c4c 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -692,7 +692,8 @@ xfs_alloc_fixup_trees(
>  			xfs_btree_mark_sick(cnt_cur);
>  			return -EFSCORRUPTED;
>  		}
> -		if ((error = xfs_btree_insert(cnt_cur, &i)))
> +		error = xfs_btree_insert(cnt_cur);
> +		if (error)
>  			return error;
>  	}
>  	if (nfbno2 != NULLAGBLOCK) {
> @@ -702,7 +703,8 @@ xfs_alloc_fixup_trees(
>  			xfs_btree_mark_sick(cnt_cur);
>  			return -EFSCORRUPTED;
>  		}
> -		if ((error = xfs_btree_insert(cnt_cur, &i)))
> +		error = xfs_btree_insert(cnt_cur);
> +		if (error)
>  			return error;
>  	}
>  	/*
> @@ -735,7 +737,8 @@ xfs_alloc_fixup_trees(
>  			xfs_btree_mark_sick(bno_cur);
>  			return -EFSCORRUPTED;
>  		}
> -		if ((error = xfs_btree_insert(bno_cur, &i)))
> +		error = xfs_btree_insert(bno_cur);
> +		if (error)
>  			return error;
>  	}
>  
> @@ -2300,7 +2303,8 @@ xfs_free_ag_extent(
>  	else {
>  		nbno = bno;
>  		nlen = len;
> -		if ((error = xfs_btree_insert(bno_cur, &i)))
> +		error = xfs_btree_insert(bno_cur);
> +		if (error)
>  			goto error0;
>  	}
>  	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
> @@ -2322,7 +2326,8 @@ xfs_free_ag_extent(
>  	}
>  	if (xfs_alloc_cursor_at_lastrec(cnt_cur))
>  		fixup_longest = true;
> -	if ((error = xfs_btree_insert(cnt_cur, &i)))
> +	error = xfs_btree_insert(cnt_cur);
> +	if (error)
>  		goto error0;
>  	if (fixup_longest) {
>  		error = xfs_alloc_fixup_longest(cnt_cur);
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 073c11e631ea..09d6792e42be 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1671,7 +1671,7 @@ xfs_bmap_add_extent_delay_real(
>  				error = -EFSCORRUPTED;
>  				goto done;
>  			}
> -			error = xfs_btree_insert(bma->cur, &i);
> +			error = xfs_btree_insert(bma->cur);
>  			if (error)
>  				goto done;
>  		}
> @@ -1737,7 +1737,7 @@ xfs_bmap_add_extent_delay_real(
>  				error = -EFSCORRUPTED;
>  				goto done;
>  			}
> -			error = xfs_btree_insert(bma->cur, &i);
> +			error = xfs_btree_insert(bma->cur);
>  			if (error)
>  				goto done;
>  		}
> @@ -1823,7 +1823,7 @@ xfs_bmap_add_extent_delay_real(
>  				error = -EFSCORRUPTED;
>  				goto done;
>  			}
> -			error = xfs_btree_insert(bma->cur, &i);
> +			error = xfs_btree_insert(bma->cur);
>  			if (error)
>  				goto done;
>  		}
> @@ -1907,7 +1907,7 @@ xfs_bmap_add_extent_delay_real(
>  				error = -EFSCORRUPTED;
>  				goto done;
>  			}
> -			error = xfs_btree_insert(bma->cur, &i);
> +			error = xfs_btree_insert(bma->cur);
>  			if (error)
>  				goto done;
>  		}
> @@ -2328,7 +2328,8 @@ xfs_bmap_add_extent_unwritten_real(
>  			if (error)
>  				goto done;
>  			cur->bc_rec.b = *new;
> -			if ((error = xfs_btree_insert(cur, &i)))
> +			error = xfs_btree_insert(cur);
> +			if (error)
>  				goto done;
>  		}
>  		break;
> @@ -2409,7 +2410,8 @@ xfs_bmap_add_extent_unwritten_real(
>  				error = -EFSCORRUPTED;
>  				goto done;
>  			}
> -			if ((error = xfs_btree_insert(cur, &i)))
> +			error = xfs_btree_insert(cur);
> +			if (error)
>  				goto done;
>  		}
>  		break;
> @@ -2454,7 +2456,8 @@ xfs_bmap_add_extent_unwritten_real(
>  				goto done;
>  			/* new left extent - oldext */
>  			cur->bc_rec.b = PREV;
> -			if ((error = xfs_btree_insert(cur, &i)))
> +			error = xfs_btree_insert(cur);
> +			if (error)
>  				goto done;
>  			/*
>  			 * Reset the cursor to the position of the new extent
> @@ -2470,7 +2473,8 @@ xfs_bmap_add_extent_unwritten_real(
>  				goto done;
>  			}
>  			/* new middle extent - newext */
> -			if ((error = xfs_btree_insert(cur, &i)))
> +			error = xfs_btree_insert(cur);
> +			if (error)
>  				goto done;
>  		}
>  		break;
> @@ -2724,7 +2728,7 @@ xfs_bmap_add_extent_hole_real(
>  				error = -EFSCORRUPTED;
>  				goto done;
>  			}
> -			error = xfs_btree_insert(cur, &i);
> +			error = xfs_btree_insert(cur);
>  			if (error)
>  				goto done;
>  		}
> @@ -5013,7 +5017,7 @@ xfs_bmap_del_extent_real(
>  			if (error)
>  				return error;
>  			cur->bc_rec.b = new;
> -			error = xfs_btree_insert(cur, &i);
> +			error = xfs_btree_insert(cur);
>  			if (error && error != -ENOSPC)
>  				return error;
>  			/*
> @@ -5906,7 +5910,7 @@ xfs_bmap_split_extent(
>  			error = -EFSCORRUPTED;
>  			goto del_cursor;
>  		}
> -		error = xfs_btree_insert(cur, &i);
> +		error = xfs_btree_insert(cur);
>  		if (error)
>  			goto del_cursor;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 7effebe297ea..e2e698596c21 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -3728,8 +3728,7 @@ xfs_btree_insrec(
>   */
>  int
>  xfs_btree_insert(
> -	struct xfs_btree_cur	*cur,
> -	int			*stat)
> +	struct xfs_btree_cur	*cur)
>  {
>  	int			error;	/* error return value */
>  	int			i;	/* result value, 0 for failure */
> @@ -3798,7 +3797,6 @@ xfs_btree_insert(
>  		}
>  	} while (!xfs_btree_ptr_is_null(cur, &nptr));
>  
> -	*stat = i;
>  	return 0;
>  error0:
>  	return error;
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 60e78572e725..0f82f3106bac 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -405,7 +405,7 @@ int xfs_btree_decrement(struct xfs_btree_cur *, int, int *);
>  int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
>  int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
>  int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
> -int xfs_btree_insert(struct xfs_btree_cur *, int *);
> +int xfs_btree_insert(struct xfs_btree_cur *);

Nitpick: parameters should have names... even though it's pretty obvious
what the one parameter is supposed to be here.

Everything else in here looks good, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  int xfs_btree_delete(struct xfs_btree_cur *, int *);
>  int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
>  int xfs_btree_change_owner(struct xfs_btree_cur *cur, uint64_t new_owner,
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index fd916a2a005b..bd7b0a24225f 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -186,14 +186,13 @@ xfs_inobt_insert_rec(
>  	uint16_t		holemask,
>  	uint8_t			count,
>  	int32_t			freecount,
> -	xfs_inofree_t		free,
> -	int			*stat)
> +	xfs_inofree_t		free)
>  {
>  	cur->bc_rec.i.ir_holemask = holemask;
>  	cur->bc_rec.i.ir_count = count;
>  	cur->bc_rec.i.ir_freecount = freecount;
>  	cur->bc_rec.i.ir_free = free;
> -	return xfs_btree_insert(cur, stat);
> +	return xfs_btree_insert(cur);
>  }
>  
>  /*
> @@ -231,7 +230,7 @@ xfs_inobt_insert(
>  		error = xfs_inobt_insert_rec(cur, XFS_INOBT_HOLEMASK_FULL,
>  					     XFS_INODES_PER_CHUNK,
>  					     XFS_INODES_PER_CHUNK,
> -					     XFS_INOBT_ALL_FREE, &i);
> +					     XFS_INOBT_ALL_FREE);
>  		if (error) {
>  			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>  			return error;
> @@ -568,7 +567,7 @@ xfs_inobt_insert_sprec(
>  	if (i == 0) {
>  		error = xfs_inobt_insert_rec(cur, nrec->ir_holemask,
>  					     nrec->ir_count, nrec->ir_freecount,
> -					     nrec->ir_free, &i);
> +					     nrec->ir_free);
>  		if (error)
>  			goto error;
>  		goto out;
> @@ -654,7 +653,7 @@ xfs_finobt_insert_sprec(
>  	if (i == 0) {
>  		error = xfs_inobt_insert_rec(cur, nrec->ir_holemask,
>  					     nrec->ir_count, nrec->ir_freecount,
> -					     nrec->ir_free, &i);
> +					     nrec->ir_free);
>  		if (error)
>  			goto error;
>  	} else {
> @@ -2238,7 +2237,7 @@ xfs_difree_finobt(
>  		error = xfs_inobt_insert_rec(cur, ibtrec->ir_holemask,
>  					     ibtrec->ir_count,
>  					     ibtrec->ir_freecount,
> -					     ibtrec->ir_free, &i);
> +					     ibtrec->ir_free);
>  		if (error)
>  			goto error;
>  		goto out;
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 3a1323155a45..49c3d4c513c9 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -105,8 +105,7 @@ int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
>  int xfs_ialloc_count_inodes(struct xfs_btree_cur *cur, xfs_agino_t *count,
>  		xfs_agino_t *freecount);
>  int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
> -		uint8_t count, int32_t freecount, xfs_inofree_t free,
> -		int *stat);
> +		uint8_t count, int32_t freecount, xfs_inofree_t free);
>  
>  int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
>  void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index aec6c839220a..574a5e7c0cdf 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -263,8 +263,7 @@ xfs_refcount_update(
>  int
>  xfs_refcount_insert(
>  	struct xfs_btree_cur		*cur,
> -	struct xfs_refcount_irec	*irec,
> -	int				*i)
> +	struct xfs_refcount_irec	*irec)
>  {
>  	int				error;
>  
> @@ -275,7 +274,7 @@ xfs_refcount_insert(
>  	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
>  	cur->bc_rec.rc.rc_domain = irec->rc_domain;
>  
> -	error = xfs_btree_insert(cur, i);
> +	error = xfs_btree_insert(cur);
>  	if (error)
>  		trace_xfs_refcount_insert_error(cur, error, _RET_IP_);
>  	return error;
> @@ -454,7 +453,7 @@ xfs_refcount_split_extent(
>  	/* Insert the left extent. */
>  	tmp = rcext;
>  	tmp.rc_blockcount = agbno - rcext.rc_startblock;
> -	error = xfs_refcount_insert(cur, &tmp, &found_rec);
> +	error = xfs_refcount_insert(cur, &tmp);
>  	if (error)
>  		goto out_error;
>  
> @@ -1141,7 +1140,7 @@ xfs_refcount_adjust_extents(
>  {
>  	struct xfs_refcount_irec	ext, tmp;
>  	int				error;
> -	int				found_rec, found_tmp;
> +	int				found_rec;
>  
>  	/* Merging did all the work already. */
>  	if (*aglen == 0)
> @@ -1183,8 +1182,7 @@ xfs_refcount_adjust_extents(
>  			 */
>  			cur->bc_refc.nr_ops++;
>  			if (tmp.rc_refcount) {
> -				error = xfs_refcount_insert(cur, &tmp,
> -						&found_tmp);
> +				error = xfs_refcount_insert(cur, &tmp);
>  				if (error)
>  					goto out_error;
>  			} else {
> @@ -1784,7 +1782,7 @@ xfs_refcount_adjust_cow_extents(
>  {
>  	struct xfs_refcount_irec	ext, tmp;
>  	int				error;
> -	int				found_rec, found_tmp;
> +	int				found_rec;
>  
>  	if (aglen == 0)
>  		return 0;
> @@ -1827,8 +1825,7 @@ xfs_refcount_adjust_cow_extents(
>  
>  		trace_xfs_refcount_modify_extent(cur, &tmp);
>  
> -		error = xfs_refcount_insert(cur, &tmp,
> -				&found_tmp);
> +		error = xfs_refcount_insert(cur, &tmp);
>  		if (error)
>  			goto out_error;
>  		break;
> diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
> index f2e299a716a4..cf300532bf04 100644
> --- a/fs/xfs/libxfs/xfs_refcount.h
> +++ b/fs/xfs/libxfs/xfs_refcount.h
> @@ -126,7 +126,7 @@ xfs_failaddr_t xfs_refcount_check_irec(struct xfs_perag *pag,
>  xfs_failaddr_t xfs_rtrefcount_check_irec(struct xfs_rtgroup *rtg,
>  		const struct xfs_refcount_irec *irec);
>  extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
> -		struct xfs_refcount_irec *irec, int *stat);
> +		struct xfs_refcount_irec *irec);
>  
>  extern struct kmem_cache	*xfs_refcount_intent_cache;
>  
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index ff4aef8d30a7..99575ae419a7 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -145,7 +145,7 @@ xfs_rmap_insert(
>  	rcur->bc_rec.r.rm_owner = owner;
>  	rcur->bc_rec.r.rm_offset = offset;
>  	rcur->bc_rec.r.rm_flags = flags;
> -	error = xfs_btree_insert(rcur, &i);
> +	error = xfs_btree_insert(rcur);
>  done:
>  	if (error)
>  		trace_xfs_rmap_insert_error(rcur, error, _RET_IP_);
> @@ -855,7 +855,7 @@ xfs_rmap_unmap(
>  				cur->bc_rec.r.rm_owner,
>  				cur->bc_rec.r.rm_offset,
>  				cur->bc_rec.r.rm_flags);
> -		error = xfs_btree_insert(cur, &i);
> +		error = xfs_btree_insert(cur);
>  		if (error)
>  			goto out_error;
>  	}
> @@ -1175,7 +1175,7 @@ xfs_rmap_map(
>  		cur->bc_rec.r.rm_offset = offset;
>  		cur->bc_rec.r.rm_flags = flags;
>  		trace_xfs_rmap_insert(cur, bno, len, owner, offset, flags);
> -		error = xfs_btree_insert(cur, &i);
> +		error = xfs_btree_insert(cur);
>  		if (error)
>  			goto out_error;
>  	}
> @@ -1577,7 +1577,7 @@ xfs_rmap_convert(
>  		NEW.rm_flags = newext;
>  		cur->bc_rec.r = NEW;
>  		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
> -		error = xfs_btree_insert(cur, &i);
> +		error = xfs_btree_insert(cur);
>  		if (error)
>  			goto done;
>  		break;
> @@ -1630,7 +1630,7 @@ xfs_rmap_convert(
>  		NEW.rm_flags = newext;
>  		cur->bc_rec.r = NEW;
>  		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
> -		error = xfs_btree_insert(cur, &i);
> +		error = xfs_btree_insert(cur);
>  		if (error)
>  			goto done;
>  		break;
> @@ -1658,7 +1658,7 @@ xfs_rmap_convert(
>  		trace_xfs_rmap_insert(cur, NEW.rm_startblock,
>  				NEW.rm_blockcount, NEW.rm_owner, NEW.rm_offset,
>  				NEW.rm_flags);
> -		error = xfs_btree_insert(cur, &i);
> +		error = xfs_btree_insert(cur);
>  		if (error)
>  			goto done;
>  		/*
> @@ -1679,7 +1679,7 @@ xfs_rmap_convert(
>  		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
>  		cur->bc_rec.r.rm_flags |= newext;
>  		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
> -		error = xfs_btree_insert(cur, &i);
> +		error = xfs_btree_insert(cur);
>  		if (error)
>  			goto done;
>  		break;
> diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
> index fd9ccb205725..41e798f65c67 100644
> --- a/fs/xfs/scrub/rcbag.c
> +++ b/fs/xfs/scrub/rcbag.c
> @@ -102,7 +102,7 @@ rcbag_add(
>  		bagrec.rbg_blockcount = rmap->rm_blockcount;
>  		bagrec.rbg_refcount = 1;
>  
> -		error = rcbagbt_insert(cur, &bagrec, &has);
> +		error = rcbagbt_insert(cur, &bagrec);
>  		if (error)
>  			goto out_cur;
>  	}
> diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
> index 367f8ccf55c4..790931fa8f06 100644
> --- a/fs/xfs/scrub/rcbag_btree.c
> +++ b/fs/xfs/scrub/rcbag_btree.c
> @@ -342,11 +342,10 @@ rcbagbt_update(
>  int
>  rcbagbt_insert(
>  	struct xfs_btree_cur	*cur,
> -	const struct rcbag_rec	*rec,
> -	int			*success)
> +	const struct rcbag_rec	*rec)
>  {
>  	struct rcbag_rec	*btrec = (struct rcbag_rec *)&cur->bc_rec;
>  
>  	memcpy(btrec, rec, sizeof(struct rcbag_rec));
> -	return xfs_btree_insert(cur, success);
> +	return xfs_btree_insert(cur);
>  }
> diff --git a/fs/xfs/scrub/rcbag_btree.h b/fs/xfs/scrub/rcbag_btree.h
> index 03cadb032552..da45d9e885f8 100644
> --- a/fs/xfs/scrub/rcbag_btree.h
> +++ b/fs/xfs/scrub/rcbag_btree.h
> @@ -70,8 +70,7 @@ int rcbagbt_lookup_eq(struct xfs_btree_cur *cur,
>  		const struct xfs_rmap_irec *rmap, int *success);
>  int rcbagbt_get_rec(struct xfs_btree_cur *cur, struct rcbag_rec *rec, int *has);
>  int rcbagbt_update(struct xfs_btree_cur *cur, const struct rcbag_rec *rec);
> -int rcbagbt_insert(struct xfs_btree_cur *cur, const struct rcbag_rec *rec,
> -		int *success);
> +int rcbagbt_insert(struct xfs_btree_cur *cur, const struct rcbag_rec *rec);
>  
>  #else
>  # define rcbagbt_init_cur_cache()		0
> -- 
> 2.55.0
> 
> 

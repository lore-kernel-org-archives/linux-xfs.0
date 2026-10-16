Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74473BED46
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792180077; cv=none; b=qbQCwrc6ek5wJxnMJC9EWoHK4RL9hDEfJdfM3gb8n/XU6wivyrsUiUJH7zVIAeg7a14MNHHs3o8YYIjL54L/AZCIJ7RfAPYGkpaniYXAFzeM28hWB7aV4x9vjdgsVYezVfaNraOOfhkWEHtKslpw0I7j/JF7Kb2cO4kCX0wdQwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792180077; c=relaxed/simple;
	bh=oyrIvEbs7MI2r9BXzy0O9CgswvFGvGQEyfL440XvfFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6ulU6YPOAqBX2E/bcBUCu6SF+eVrYYFhQJfUpRZoqtJDowDTzdNBwKIxr8DlhBgKTFZ57l+NeBc/mlJkvfgaQH08sms5K0QwQyu2OF5zQmlrrscAPBN1qDcZs6lzK1fwA/5XVvsDGRy8fWy0UiN39ZRRdZR97FMOSY8y+0iS+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FEUOrKe0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FEUOrKe0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1908E1F000C4;
	Fri, 16 Oct 2026 19:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792180074;
	bh=DGUMiS7ZJVLB1e96RJ4GFrUfPHtqXUGRZD4RaAYDAXQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FEUOrKe0wbYu8NDzqjgwW2VcDK+71RghNgFkU4p+0fHoP9HC3O3o7scp8Z2bl17Uy
	 /dmaeVNdUQPee7fvgHv4joLiV5+rEn1tVzwP+PlcjMUXJyskfs45z3f/YxQB8pt9le
	 JtfWDD1Snkr9fTcmEOljdvvydD1osfQ2b0oGGv9wCkGzAFCFg+IMgkPnDa3hAeEG4u
	 KgLmbjH7A40jpLsWM6deULUF1FcrTDeJl/s+kdzxenoZfP9y+s43vIuZgtCVwXuJYp
	 +FsmGgT7njhf0dn+1phHnq4tSxAoAz/9UQYBBTtDMJJKvhltx57YLDCo0OZ7KGzHrd
	 kKXcSzEe/1IZg==
Date: Fri, 16 Oct 2026 12:47:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de, dgc@kernel.org
Subject: Re: [PATCH 8/8] xfs: remove status parameter from two btree delete
 functions
Message-ID: <20261016194753.GJ107986@frogsfrogsfrogs>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-9-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016193422.1630907-9-sandeen@redhat.com>

On Fri, Oct 16, 2026 at 02:29:08PM -0500, Eric Sandeen wrote:
> xfs_btree_delete and its callers now have no need for the status
> parameter; either they return error = 0 / status = 1, or nonzero error
> and status 0. No caller evaluates the status variable, so remove that
> parameter from these functions.
> 
> As requested, convert all of the compound tests/assignments to discrete
> lines.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c    | 21 ++++++++++++++-------
>  fs/xfs/libxfs/xfs_bmap.c     | 21 +++++++++++++--------
>  fs/xfs/libxfs/xfs_btree.c    |  4 +---
>  fs/xfs/libxfs/xfs_btree.h    |  2 +-
>  fs/xfs/libxfs/xfs_ialloc.c   |  8 ++++----
>  fs/xfs/libxfs/xfs_refcount.c | 17 ++++++++---------
>  fs/xfs/libxfs/xfs_rmap.c     | 15 +++++++--------
>  fs/xfs/scrub/rcbag.c         |  2 +-
>  8 files changed, 49 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index bc43afff33bc..c32816390217 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -676,7 +676,8 @@ xfs_alloc_fixup_trees(
>  	/*
>  	 * Delete the entry from the by-size btree.
>  	 */
> -	if ((error = xfs_btree_delete(cnt_cur, &i)))
> +	error = xfs_btree_delete(cnt_cur);
> +	if (error)
>  		return error;
>  	/*
>  	 * Add new by-size btree entry(s).
> @@ -710,7 +711,8 @@ xfs_alloc_fixup_trees(
>  		/*
>  		 * No remaining freespace, just delete the by-block tree entry.
>  		 */
> -		if ((error = xfs_btree_delete(bno_cur, &i)))
> +		error = xfs_btree_delete(bno_cur);
> +		if (error)
>  			return error;
>  	} else {
>  		/*
> @@ -2145,7 +2147,8 @@ xfs_free_ag_extent(
>  			error = -EFSCORRUPTED;
>  			goto error0;
>  		}
> -		if ((error = xfs_btree_delete(cnt_cur, &i)))
> +		error = xfs_btree_delete(cnt_cur);
> +		if (error)
>  			goto error0;
>  		/*
>  		 * Delete the old by-size entry on the right.
> @@ -2157,12 +2160,14 @@ xfs_free_ag_extent(
>  			error = -EFSCORRUPTED;
>  			goto error0;
>  		}
> -		if ((error = xfs_btree_delete(cnt_cur, &i)))
> +		error = xfs_btree_delete(cnt_cur);
> +		if (error)
>  			goto error0;
>  		/*
>  		 * Delete the old by-block entry for the right block.
>  		 */
> -		if ((error = xfs_btree_delete(bno_cur, &i)))
> +		error = xfs_btree_delete(bno_cur);
> +		if (error)
>  			goto error0;
>  		/*
>  		 * Move the by-block cursor back to the left neighbor.
> @@ -2219,7 +2224,8 @@ xfs_free_ag_extent(
>  			error = -EFSCORRUPTED;
>  			goto error0;
>  		}
> -		if ((error = xfs_btree_delete(cnt_cur, &i)))
> +		error = xfs_btree_delete(cnt_cur);
> +		if (error)
>  			goto error0;
>  		/*
>  		 * Back up the by-block cursor to the left neighbor, and
> @@ -2252,7 +2258,8 @@ xfs_free_ag_extent(
>  			error = -EFSCORRUPTED;
>  			goto error0;
>  		}
> -		if ((error = xfs_btree_delete(cnt_cur, &i)))
> +		error = xfs_btree_delete(cnt_cur);
> +		if (error)
>  			goto error0;
>  		/*
>  		 * Update the starting block and length of the right
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index cf7360adf1a8..beaa92ea8015 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1559,7 +1559,7 @@ xfs_bmap_add_extent_delay_real(
>  				error = -EFSCORRUPTED;
>  				goto done;
>  			}
> -			error = xfs_btree_delete(bma->cur, &i);
> +			error = xfs_btree_delete(bma->cur);
>  			if (error)
>  				goto done;
>  			error = xfs_btree_decrement(bma->cur, 0, &i);
> @@ -2103,7 +2103,8 @@ xfs_bmap_add_extent_unwritten_real(
>  				error = -EFSCORRUPTED;
>  				goto done;
>  			}
> -			if ((error = xfs_btree_delete(cur, &i)))
> +			error = xfs_btree_delete(cur);
> +			if (error)
>  				goto done;
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
> @@ -2112,7 +2113,8 @@ xfs_bmap_add_extent_unwritten_real(
>  				error = -EFSCORRUPTED;
>  				goto done;
>  			}
> -			if ((error = xfs_btree_delete(cur, &i)))
> +			error = xfs_btree_delete(cur);
> +			if (error)
>  				goto done;
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
> @@ -2150,7 +2152,8 @@ xfs_bmap_add_extent_unwritten_real(
>  				error = -EFSCORRUPTED;
>  				goto done;
>  			}
> -			if ((error = xfs_btree_delete(cur, &i)))
> +			error = xfs_btree_delete(cur);
> +			if (error)
>  				goto done;
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
> @@ -2191,7 +2194,8 @@ xfs_bmap_add_extent_unwritten_real(
>  				error = -EFSCORRUPTED;
>  				goto done;
>  			}
> -			if ((error = xfs_btree_delete(cur, &i)))
> +			error = xfs_btree_delete(cur);
> +			if (error)
>  				goto done;
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
> @@ -2599,7 +2603,7 @@ xfs_bmap_add_extent_hole_real(
>  				error = -EFSCORRUPTED;
>  				goto done;
>  			}
> -			error = xfs_btree_delete(cur, &i);
> +			error = xfs_btree_delete(cur);
>  			if (error)
>  				goto done;
>  			error = xfs_btree_decrement(cur, 0, &i);
> @@ -4926,7 +4930,8 @@ xfs_bmap_del_extent_real(
>  			*logflagsp |= xfs_ilog_fext(whichfork);
>  			break;
>  		}
> -		if ((error = xfs_btree_delete(cur, &i)))
> +		error = xfs_btree_delete(cur);
> +		if (error)
>  			return error;
>  		break;
>  	case BMAP_LEFT_FILLING:
> @@ -5488,7 +5493,7 @@ xfs_bmse_merge(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	error = xfs_btree_delete(cur, &i);
> +	error = xfs_btree_delete(cur);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 367c14e4dec5..91211d212c74 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4555,8 +4555,7 @@ xfs_btree_delrec(
>   */
>  int					/* error */
>  xfs_btree_delete(
> -	struct xfs_btree_cur	*cur,
> -	int			*stat)	/* success/failure */
> +	struct xfs_btree_cur	*cur)
>  {
>  	int			error;	/* error return value */
>  	int			level;
> @@ -4604,7 +4603,6 @@ xfs_btree_delete(
>  		goto error0;
>  	}
>  
> -	*stat = i;
>  	return 0;
>  error0:
>  	return error;
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 0f82f3106bac..c4337ab244f2 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -406,7 +406,7 @@ int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
>  int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
>  int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
>  int xfs_btree_insert(struct xfs_btree_cur *);
> -int xfs_btree_delete(struct xfs_btree_cur *, int *);
> +int xfs_btree_delete(struct xfs_btree_cur *);

Same nitpick about parameter names, but otherwise I like this, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


>  int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
>  int xfs_btree_change_owner(struct xfs_btree_cur *cur, uint64_t new_owner,
>  			   struct list_head *buffer_list);
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 7a9cc0b9e206..ec0a37499f28 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1564,7 +1564,6 @@ xfs_dialloc_ag(
>  	xfs_ino_t			ino;
>  	int				error;
>  	int				offset;
> -	int				i;
>  
>  	if (!xfs_has_finobt(mp))
>  		return xfs_dialloc_ag_inobt(pag, tp, agbp, parent, inop);
> @@ -1617,7 +1616,7 @@ xfs_dialloc_ag(
>  		if (error)
>  			goto error_cur;
>  	} else {
> -		error = xfs_btree_delete(cur, &i);
> +		error = xfs_btree_delete(cur);
>  		if (error)
>  			goto error_cur;
>  	}
> @@ -2148,7 +2147,8 @@ xfs_difree_inobt(
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
>  
> -		if ((error = xfs_btree_delete(cur, &i))) {
> +		error = xfs_btree_delete(cur);
> +		if (error) {
>  			xfs_warn(mp, "%s: xfs_btree_delete returned error %d.",
>  				__func__, error);
>  			goto error0;
> @@ -2274,7 +2274,7 @@ xfs_difree_finobt(
>  	 */
>  	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
>  	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
> -		error = xfs_btree_delete(cur, &i);
> +		error = xfs_btree_delete(cur);
>  		if (error)
>  			goto error;
>  	} else {
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 924f839b35a0..75e469576a8b 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -288,8 +288,7 @@ xfs_refcount_insert(
>   */
>  STATIC int
>  xfs_refcount_delete(
> -	struct xfs_btree_cur	*cur,
> -	int			*i)
> +	struct xfs_btree_cur	*cur)
>  {
>  	struct xfs_refcount_irec	irec;
>  	int			found_rec;
> @@ -304,7 +303,7 @@ xfs_refcount_delete(
>  		goto out_error;
>  	}
>  	trace_xfs_refcount_delete(cur, &irec);
> -	error = xfs_btree_delete(cur, i);
> +	error = xfs_btree_delete(cur);
>  	if (error)
>  		goto out_error;
>  	error = xfs_refcount_lookup_ge(cur, irec.rc_domain, irec.rc_startblock,
> @@ -497,12 +496,12 @@ xfs_refcount_merge_center_extents(
>  		goto out_error;
>  	}
>  
> -	error = xfs_refcount_delete(cur, &found_rec);
> +	error = xfs_refcount_delete(cur);
>  	if (error)
>  		goto out_error;
>  
>  	if (center->rc_refcount > 1) {
> -		error = xfs_refcount_delete(cur, &found_rec);
> +		error = xfs_refcount_delete(cur);
>  		if (error)
>  			goto out_error;
>  	}
> @@ -561,7 +560,7 @@ xfs_refcount_merge_left_extent(
>  			goto out_error;
>  		}
>  
> -		error = xfs_refcount_delete(cur, &found_rec);
> +		error = xfs_refcount_delete(cur);
>  		if (error)
>  			goto out_error;
>  	}
> @@ -623,7 +622,7 @@ xfs_refcount_merge_right_extent(
>  			goto out_error;
>  		}
>  
> -		error = xfs_refcount_delete(cur, &found_rec);
> +		error = xfs_refcount_delete(cur);
>  		if (error)
>  			goto out_error;
>  	}
> @@ -1209,7 +1208,7 @@ xfs_refcount_adjust_extents(
>  			if (error)
>  				goto out_error;
>  		} else if (ext.rc_refcount == 1) {
> -			error = xfs_refcount_delete(cur, &found_rec);
> +			error = xfs_refcount_delete(cur);
>  			if (error)
>  				goto out_error;
>  			goto advloop;
> @@ -1819,7 +1818,7 @@ xfs_refcount_adjust_cow_extents(
>  
>  		ext.rc_refcount = 0;
>  		trace_xfs_refcount_modify_extent(cur, &ext);
> -		error = xfs_refcount_delete(cur, &found_rec);
> +		error = xfs_refcount_delete(cur);
>  		if (error)
>  			goto out_error;
>  		break;
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 31c41e9bcb3f..6fe06612eac2 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -175,7 +175,7 @@ xfs_rmap_delete(
>  		goto done;
>  	}
>  
> -	error = xfs_btree_delete(rcur, &i);
> +	error = xfs_btree_delete(rcur);
>  	if (error)
>  		goto done;
>  done:
> @@ -770,7 +770,7 @@ xfs_rmap_unmap(
>  		trace_xfs_rmap_delete(cur, ltrec.rm_startblock,
>  				ltrec.rm_blockcount, ltrec.rm_owner,
>  				ltrec.rm_offset, ltrec.rm_flags);
> -		error = xfs_btree_delete(cur, &i);
> +		error = xfs_btree_delete(cur);
>  		if (error)
>  			goto out_error;
>  	} else if (ltrec.rm_startblock == bno) {
> @@ -1012,7 +1012,6 @@ xfs_rmap_map(
>  	int				have_gt;
>  	int				have_lt;
>  	int				error = 0;
> -	int				i;
>  	uint64_t			owner;
>  	uint64_t			offset;
>  	unsigned int			flags = 0;
> @@ -1118,7 +1117,7 @@ xfs_rmap_map(
>  			trace_xfs_rmap_delete(cur, gtrec.rm_startblock,
>  					gtrec.rm_blockcount, gtrec.rm_owner,
>  					gtrec.rm_offset, gtrec.rm_flags);
> -			error = xfs_btree_delete(cur, &i);
> +			error = xfs_btree_delete(cur);
>  			if (error)
>  				goto out_error;
>  		}
> @@ -1395,7 +1394,7 @@ xfs_rmap_convert(
>  		trace_xfs_rmap_delete(cur, RIGHT.rm_startblock,
>  				RIGHT.rm_blockcount, RIGHT.rm_owner,
>  				RIGHT.rm_offset, RIGHT.rm_flags);
> -		error = xfs_btree_delete(cur, &i);
> +		error = xfs_btree_delete(cur);
>  		if (error)
>  			goto done;
>  		error = xfs_btree_decrement(cur, 0, &i);
> @@ -1409,7 +1408,7 @@ xfs_rmap_convert(
>  		trace_xfs_rmap_delete(cur, PREV.rm_startblock,
>  				PREV.rm_blockcount, PREV.rm_owner,
>  				PREV.rm_offset, PREV.rm_flags);
> -		error = xfs_btree_delete(cur, &i);
> +		error = xfs_btree_delete(cur);
>  		if (error)
>  			goto done;
>  		error = xfs_btree_decrement(cur, 0, &i);
> @@ -1435,7 +1434,7 @@ xfs_rmap_convert(
>  		trace_xfs_rmap_delete(cur, PREV.rm_startblock,
>  				PREV.rm_blockcount, PREV.rm_owner,
>  				PREV.rm_offset, PREV.rm_flags);
> -		error = xfs_btree_delete(cur, &i);
> +		error = xfs_btree_delete(cur);
>  		if (error)
>  			goto done;
>  		error = xfs_btree_decrement(cur, 0, &i);
> @@ -1469,7 +1468,7 @@ xfs_rmap_convert(
>  		trace_xfs_rmap_delete(cur, RIGHT.rm_startblock,
>  				RIGHT.rm_blockcount, RIGHT.rm_owner,
>  				RIGHT.rm_offset, RIGHT.rm_flags);
> -		error = xfs_btree_delete(cur, &i);
> +		error = xfs_btree_delete(cur);
>  		if (error)
>  			goto done;
>  		error = xfs_btree_decrement(cur, 0, &i);
> diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
> index 5a390e3c7777..bd1aa55a8910 100644
> --- a/fs/xfs/scrub/rcbag.c
> +++ b/fs/xfs/scrub/rcbag.c
> @@ -239,7 +239,7 @@ rcbag_remove_ending_at(
>  		if (rcbag_rec_next_bno(&bagrec) != next_bno)
>  			continue;
>  
> -		error = xfs_btree_delete(cur, &has);
> +		error = xfs_btree_delete(cur);
>  		if (error)
>  			goto out_cur;
>  
> -- 
> 2.55.0
> 
> 

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EE23D300E
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792180040; cv=none; b=DC9jxU7OUVDBP/cqbW+edsuJzwqC8Qt3XnqkpkVXfbjC6cY4jXLrEYiVW7Y/Q18ziSGE8w2ptPuBI2sEA/mstZdR5MBeIqLi3IOqT7G5wtS8mXIWJa9tlJVVHKyeOvKbldkUhiEKh0IUnFYdO6BM2KUKGKlWt4OTV7C28q20X3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792180040; c=relaxed/simple;
	bh=cXUenOseMxK4pTILIBE1e/AWx2Ew5zDPIfB5L7gTlW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OX3KozsM7EOdB6smmDwKHCXbf+tWvXD+DHbh0H/hmjZLPvS4pF1JC13bnrvX1tktEWs51UzP15RJgGbk6/mSjCiW5SxnXXaSZ14PZtGi6bWVXXOlotq7bPD/eyVssJOEpXA64oq9xlpPwbcyj6Efh5OzGnPvq9qKZgU2BJg/LCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kMCyxjVB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kMCyxjVB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AA3F21F000C4;
	Fri, 16 Oct 2026 19:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792180034;
	bh=2y9+rzExLrKIMoNjCREF+fi9kUuFRQsOGbNyIA29Uqs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kMCyxjVBGkvDwd/OxEpvLeug+1BixIzZUSSMLPMC9wMLeJOZqHW9vm8GTf8VGZTTj
	 CHYRO+u80Mkwy5jPU/h7aU/IZJMghVPK4Vu93UfPlgQn/zHEaBNy65fmVL0pCxCZpW
	 crv/xyLNYjn0iicYQmqawvcq+YlftOeBcsROLfyFl7f+ByZpEn0Q9lM3hFql8GlpSZ
	 RgAVEBfE/j1EbTCQyxe/e+IxKPTfrin0O3pIrUCk+YL07xqBJLKHnh7KvyqPLE6Y7y
	 lnUB6Vwofnr1xu9CDSd8O8uUeVMAzOf+wIGVGpOmb3IW7V35RXakHsNjsNDJ2T/G9U
	 /g4hDmV04kd6w==
Date: Fri, 16 Oct 2026 12:47:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de, dgc@kernel.org
Subject: Re: [PATCH 6/8] xfs: add stat check to xfs_btree_delete and remove
 caller checks
Message-ID: <20261016194714.GH107986@frogsfrogsfrogs>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-7-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016193422.1630907-7-sandeen@redhat.com>

On Fri, Oct 16, 2026 at 02:29:06PM -0500, Eric Sandeen wrote:
> Unlike xfs_btree_insert(), xfs_btree_delete() does not validate its own
> status return internally, so every caller open-codes the same check that
> a record was actually deleted:
> 
> 	error = xfs_btree_delete(cur, &i);
> 	if (error)
> 		return error;
> 	if (XFS_IS_CORRUPT(mp, i != 1)) {
> 		xfs_btree_mark_sick(cur);
> 		return -EFSCORRUPTED;
> 	}
> 
> No caller expects or accepts i == 0; that is considered corruption in
> every case.
> 
> Move this check into xfs_btree_delete, to mirror xfs_btree_insert's
> behavior, so that xfs_btree_delete either returns error = 0 / status = 1,
> or a nonzero error.
> 
> With that in place, remove the now-redundant i != 1 checks from all
> callers, parallel to what was done earlier for xfs_btree_insert().
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c    | 33 -------------------------------
>  fs/xfs/libxfs/xfs_bmap.c     | 38 ------------------------------------
>  fs/xfs/libxfs/xfs_btree.c    |  6 ++++++
>  fs/xfs/libxfs/xfs_ialloc.c   | 15 --------------
>  fs/xfs/libxfs/xfs_refcount.c |  5 -----
>  fs/xfs/libxfs/xfs_rmap.c     | 35 ---------------------------------
>  fs/xfs/scrub/rcbag.c         |  4 ----
>  7 files changed, 6 insertions(+), 130 deletions(-)

Excellent!  Very nice cleanup!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index acd8f4521c4c..bc43afff33bc 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -678,10 +678,6 @@ xfs_alloc_fixup_trees(
>  	 */
>  	if ((error = xfs_btree_delete(cnt_cur, &i)))
>  		return error;
> -	if (XFS_IS_CORRUPT(mp, i != 1)) {
> -		xfs_btree_mark_sick(cnt_cur);
> -		return -EFSCORRUPTED;
> -	}
>  	/*
>  	 * Add new by-size btree entry(s).
>  	 */
> @@ -716,10 +712,6 @@ xfs_alloc_fixup_trees(
>  		 */
>  		if ((error = xfs_btree_delete(bno_cur, &i)))
>  			return error;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(bno_cur);
> -			return -EFSCORRUPTED;
> -		}
>  	} else {
>  		/*
>  		 * Update the by-block entry to start later|be shorter.
> @@ -2155,11 +2147,6 @@ xfs_free_ag_extent(
>  		}
>  		if ((error = xfs_btree_delete(cnt_cur, &i)))
>  			goto error0;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cnt_cur);
> -			error = -EFSCORRUPTED;
> -			goto error0;
> -		}
>  		/*
>  		 * Delete the old by-size entry on the right.
>  		 */
> @@ -2172,21 +2159,11 @@ xfs_free_ag_extent(
>  		}
>  		if ((error = xfs_btree_delete(cnt_cur, &i)))
>  			goto error0;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cnt_cur);
> -			error = -EFSCORRUPTED;
> -			goto error0;
> -		}
>  		/*
>  		 * Delete the old by-block entry for the right block.
>  		 */
>  		if ((error = xfs_btree_delete(bno_cur, &i)))
>  			goto error0;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(bno_cur);
> -			error = -EFSCORRUPTED;
> -			goto error0;
> -		}
>  		/*
>  		 * Move the by-block cursor back to the left neighbor.
>  		 */
> @@ -2244,11 +2221,6 @@ xfs_free_ag_extent(
>  		}
>  		if ((error = xfs_btree_delete(cnt_cur, &i)))
>  			goto error0;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cnt_cur);
> -			error = -EFSCORRUPTED;
> -			goto error0;
> -		}
>  		/*
>  		 * Back up the by-block cursor to the left neighbor, and
>  		 * update its length.
> @@ -2282,11 +2254,6 @@ xfs_free_ag_extent(
>  		}
>  		if ((error = xfs_btree_delete(cnt_cur, &i)))
>  			goto error0;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cnt_cur);
> -			error = -EFSCORRUPTED;
> -			goto error0;
> -		}
>  		/*
>  		 * Update the starting block and length of the right
>  		 * neighbor in the by-block tree.
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 09d6792e42be..cf7360adf1a8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1562,11 +1562,6 @@ xfs_bmap_add_extent_delay_real(
>  			error = xfs_btree_delete(bma->cur, &i);
>  			if (error)
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(bma->cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  			error = xfs_btree_decrement(bma->cur, 0, &i);
>  			if (error)
>  				goto done;
> @@ -2110,11 +2105,6 @@ xfs_bmap_add_extent_unwritten_real(
>  			}
>  			if ((error = xfs_btree_delete(cur, &i)))
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
>  			if (XFS_IS_CORRUPT(mp, i != 1)) {
> @@ -2124,11 +2114,6 @@ xfs_bmap_add_extent_unwritten_real(
>  			}
>  			if ((error = xfs_btree_delete(cur, &i)))
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
>  			if (XFS_IS_CORRUPT(mp, i != 1)) {
> @@ -2167,11 +2152,6 @@ xfs_bmap_add_extent_unwritten_real(
>  			}
>  			if ((error = xfs_btree_delete(cur, &i)))
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
>  			if (XFS_IS_CORRUPT(mp, i != 1)) {
> @@ -2213,11 +2193,6 @@ xfs_bmap_add_extent_unwritten_real(
>  			}
>  			if ((error = xfs_btree_delete(cur, &i)))
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  			if ((error = xfs_btree_decrement(cur, 0, &i)))
>  				goto done;
>  			if (XFS_IS_CORRUPT(mp, i != 1)) {
> @@ -2627,11 +2602,6 @@ xfs_bmap_add_extent_hole_real(
>  			error = xfs_btree_delete(cur, &i);
>  			if (error)
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  			error = xfs_btree_decrement(cur, 0, &i);
>  			if (error)
>  				goto done;
> @@ -4958,10 +4928,6 @@ xfs_bmap_del_extent_real(
>  		}
>  		if ((error = xfs_btree_delete(cur, &i)))
>  			return error;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			return -EFSCORRUPTED;
> -		}
>  		break;
>  	case BMAP_LEFT_FILLING:
>  		/*
> @@ -5525,10 +5491,6 @@ xfs_bmse_merge(
>  	error = xfs_btree_delete(cur, &i);
>  	if (error)
>  		return error;
> -	if (XFS_IS_CORRUPT(mp, i != 1)) {
> -		xfs_btree_mark_sick(cur);
> -		return -EFSCORRUPTED;
> -	}
>  
>  	/* lookup and update size of the previous extent */
>  	error = xfs_bmbt_lookup_eq(cur, left, &i);
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index e2e698596c21..367c14e4dec5 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4598,6 +4598,12 @@ xfs_btree_delete(
>  		}
>  	}
>  
> +	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1)) {
> +		xfs_btree_mark_sick(cur);
> +		error = -EFSCORRUPTED;
> +		goto error0;
> +	}
> +
>  	*stat = i;
>  	return 0;
>  error0:
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index bd7b0a24225f..7a9cc0b9e206 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1620,11 +1620,6 @@ xfs_dialloc_ag(
>  		error = xfs_btree_delete(cur, &i);
>  		if (error)
>  			goto error_cur;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto error_cur;
> -		}
>  	}
>  
>  	/*
> @@ -2158,11 +2153,6 @@ xfs_difree_inobt(
>  				__func__, error);
>  			goto error0;
>  		}
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto error0;
> -		}
>  
>  		error = xfs_difree_inode_chunk(tp, pag, &rec);
>  		if (error)
> @@ -2287,11 +2277,6 @@ xfs_difree_finobt(
>  		error = xfs_btree_delete(cur, &i);
>  		if (error)
>  			goto error;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto error;
> -		}
>  	} else {
>  		error = xfs_inobt_update(cur, &rec);
>  		if (error)
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 574a5e7c0cdf..bf7526621681 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -305,11 +305,6 @@ xfs_refcount_delete(
>  	}
>  	trace_xfs_refcount_delete(cur, &irec);
>  	error = xfs_btree_delete(cur, i);
> -	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
> -		xfs_btree_mark_sick(cur);
> -		error = -EFSCORRUPTED;
> -		goto out_error;
> -	}
>  	if (error)
>  		goto out_error;
>  	error = xfs_refcount_lookup_ge(cur, irec.rc_domain, irec.rc_startblock,
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 99575ae419a7..31c41e9bcb3f 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -178,11 +178,6 @@ xfs_rmap_delete(
>  	error = xfs_btree_delete(rcur, &i);
>  	if (error)
>  		goto done;
> -	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
> -		xfs_btree_mark_sick(rcur);
> -		error = -EFSCORRUPTED;
> -		goto done;
> -	}
>  done:
>  	if (error)
>  		trace_xfs_rmap_delete_error(rcur, error, _RET_IP_);
> @@ -778,11 +773,6 @@ xfs_rmap_unmap(
>  		error = xfs_btree_delete(cur, &i);
>  		if (error)
>  			goto out_error;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto out_error;
> -		}
>  	} else if (ltrec.rm_startblock == bno) {
>  		/*
>  		 * overlap left hand side of extent: move the start, trim the
> @@ -1131,11 +1121,6 @@ xfs_rmap_map(
>  			error = xfs_btree_delete(cur, &i);
>  			if (error)
>  				goto out_error;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				error = -EFSCORRUPTED;
> -				goto out_error;
> -			}
>  		}
>  
>  		/* point the cursor back to the left record and update */
> @@ -1413,11 +1398,6 @@ xfs_rmap_convert(
>  		error = xfs_btree_delete(cur, &i);
>  		if (error)
>  			goto done;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto done;
> -		}
>  		error = xfs_btree_decrement(cur, 0, &i);
>  		if (error)
>  			goto done;
> @@ -1432,11 +1412,6 @@ xfs_rmap_convert(
>  		error = xfs_btree_delete(cur, &i);
>  		if (error)
>  			goto done;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto done;
> -		}
>  		error = xfs_btree_decrement(cur, 0, &i);
>  		if (error)
>  			goto done;
> @@ -1463,11 +1438,6 @@ xfs_rmap_convert(
>  		error = xfs_btree_delete(cur, &i);
>  		if (error)
>  			goto done;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto done;
> -		}
>  		error = xfs_btree_decrement(cur, 0, &i);
>  		if (error)
>  			goto done;
> @@ -1502,11 +1472,6 @@ xfs_rmap_convert(
>  		error = xfs_btree_delete(cur, &i);
>  		if (error)
>  			goto done;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto done;
> -		}
>  		error = xfs_btree_decrement(cur, 0, &i);
>  		if (error)
>  			goto done;
> diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
> index 41e798f65c67..5a390e3c7777 100644
> --- a/fs/xfs/scrub/rcbag.c
> +++ b/fs/xfs/scrub/rcbag.c
> @@ -242,10 +242,6 @@ rcbag_remove_ending_at(
>  		error = xfs_btree_delete(cur, &has);
>  		if (error)
>  			goto out_cur;
> -		if (!has) {
> -			error = -EFSCORRUPTED;
> -			goto out_cur;
> -		}
>  
>  		bag->nr_items -= bagrec.rbg_refcount;
>  	}
> -- 
> 2.55.0
> 
> 

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD2F3B42D9
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179885; cv=none; b=B/S/VQhnrGbLP+yYH1ShuH0eeE84d5x4Zs4/Y/g26OKXXHVubFhzQ0WsPfoLss3lnss4TVL8DuY4qwjMtY07DtMGTyG//OAxDJSbqxaGLQBqBU0FlZxYizlM/ubZlWPmy+bvpLzghnooGxsrXmKaJn7UGECopqaPSK9WO7Wz4uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179885; c=relaxed/simple;
	bh=WPZyQ+oyF8C5/hBIzpIMDYM4eIozE0KLt1OrCU2aics=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EVEUkocdZEZkFUuMQO4KNjRzzZkUsTUmt2/WkfWQDcDPxqSBsTJp0IwLkINnbDI68b0/mmdF2y9ntVSYNKCeZ+u3DJFthOBjuINLPjMy5O1E/3mY4xUM2vv+ASTnkw4rMWI6zvGR+QvfHt0bmVFpR87KrLPqFIlZy4wuW8P5j3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ElWpBkvW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ElWpBkvW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9425B1F000C4;
	Fri, 16 Oct 2026 19:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179883;
	bh=+rRCzTHxQUJK/TixtzhCPnyz/bkGQPUMn/YlLGzaJt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ElWpBkvWRjyJrDMMfCixyHSOGQI5szkUx1oYpGOca4Yrslm1ck6ICNopT5vs3xR6H
	 ndv2j/L3fKtZ/yJRvR8Amja4XxFQ+9wAbnZ35UWZDTroWLxmDopTeWU10TLbFNxRK9
	 FjSfni/at/oaDOcpf5srjhwHcqcHoAqurufOZN8yxF579qZ2tAmIdE4N0h45/6FHkL
	 3WVuzyOdjLe2/YivwcoWeesoKVHdOG9hSZ4EqNjvcVIL3YOYVALzFcwnDgeSM+ax7w
	 fIe/yUDmmOqoAQmMxauPD/m3nxpDB6L93+hUfRJwt6r1WKtuRC4Ft21/k+iKsTA1/p
	 ieXlNbtKibJQg==
Date: Fri, 16 Oct 2026 12:44:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de, dgc@kernel.org
Subject: Re: [PATCH 1/8] xfs: remove redundant stat checks after
 xfs_btree_insert()
Message-ID: <20261016194441.GC107986@frogsfrogsfrogs>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-2-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016193422.1630907-2-sandeen@redhat.com>

On Fri, Oct 16, 2026 at 02:29:01PM -0500, Eric Sandeen wrote:
> xfs_btree_insert() validates its own status internally via the result
> of xfs_btree_insrec(). When it returns 0 it guarantees the status value
> is 1; on any error it returns a nonzero error and does not update the
> status value, so on error the status value is meaningless and on success
> the status value does not need to be tested.
> 
> This makes every instance of the 2nd test in this idiom:
> 
> 	if ((error = xfs_btree_insert(cnt_cur, &i)))
> 		return error;
> 	if (XFS_IS_CORRUPT(mp, i != 1)) {
> 		xfs_btree_mark_sick(cnt_cur);
> 		return -EFSCORRUPTED;
> 	}
> 
> unreachable on an error, and always false on success. The mark_sick and
> error return cannot be reached, so remove all that.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Oh hey, I hadn't even realized there were all these redundant checks!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c    | 22 ---------------
>  fs/xfs/libxfs/xfs_bmap.c     | 54 ------------------------------------
>  fs/xfs/libxfs/xfs_refcount.c |  9 ------
>  fs/xfs/libxfs/xfs_rmap.c     | 32 ---------------------
>  4 files changed, 117 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index ae221a158764..b40c51a0f651 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -694,10 +694,6 @@ xfs_alloc_fixup_trees(
>  		}
>  		if ((error = xfs_btree_insert(cnt_cur, &i)))
>  			return error;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cnt_cur);
> -			return -EFSCORRUPTED;
> -		}
>  	}
>  	if (nfbno2 != NULLAGBLOCK) {
>  		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno2, nflen2, &i)))
> @@ -708,10 +704,6 @@ xfs_alloc_fixup_trees(
>  		}
>  		if ((error = xfs_btree_insert(cnt_cur, &i)))
>  			return error;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cnt_cur);
> -			return -EFSCORRUPTED;
> -		}
>  	}
>  	/*
>  	 * Fix up the by-block btree entry(s).
> @@ -745,10 +737,6 @@ xfs_alloc_fixup_trees(
>  		}
>  		if ((error = xfs_btree_insert(bno_cur, &i)))
>  			return error;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(bno_cur);
> -			return -EFSCORRUPTED;
> -		}
>  	}
>  
>  	if (fixup_longest)
> @@ -2314,11 +2302,6 @@ xfs_free_ag_extent(
>  		nlen = len;
>  		if ((error = xfs_btree_insert(bno_cur, &i)))
>  			goto error0;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(bno_cur);
> -			error = -EFSCORRUPTED;
> -			goto error0;
> -		}
>  	}
>  	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
>  	bno_cur = NULL;
> @@ -2341,11 +2324,6 @@ xfs_free_ag_extent(
>  		fixup_longest = true;
>  	if ((error = xfs_btree_insert(cnt_cur, &i)))
>  		goto error0;
> -	if (XFS_IS_CORRUPT(mp, i != 1)) {
> -		xfs_btree_mark_sick(cnt_cur);
> -		error = -EFSCORRUPTED;
> -		goto error0;
> -	}
>  	if (fixup_longest) {
>  		error = xfs_alloc_fixup_longest(cnt_cur);
>  		if (error)
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ca49bf4a50c5..073c11e631ea 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1674,11 +1674,6 @@ xfs_bmap_add_extent_delay_real(
>  			error = xfs_btree_insert(bma->cur, &i);
>  			if (error)
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(bma->cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  		}
>  		ASSERT(da_new <= da_old);
>  		break;
> @@ -1745,11 +1740,6 @@ xfs_bmap_add_extent_delay_real(
>  			error = xfs_btree_insert(bma->cur, &i);
>  			if (error)
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(bma->cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  		}
>  
>  		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
> @@ -1836,11 +1826,6 @@ xfs_bmap_add_extent_delay_real(
>  			error = xfs_btree_insert(bma->cur, &i);
>  			if (error)
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(bma->cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  		}
>  
>  		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
> @@ -1925,11 +1910,6 @@ xfs_bmap_add_extent_delay_real(
>  			error = xfs_btree_insert(bma->cur, &i);
>  			if (error)
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(bma->cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  		}
>  
>  		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
> @@ -2350,11 +2330,6 @@ xfs_bmap_add_extent_unwritten_real(
>  			cur->bc_rec.b = *new;
>  			if ((error = xfs_btree_insert(cur, &i)))
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  		}
>  		break;
>  
> @@ -2436,11 +2411,6 @@ xfs_bmap_add_extent_unwritten_real(
>  			}
>  			if ((error = xfs_btree_insert(cur, &i)))
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  		}
>  		break;
>  
> @@ -2486,11 +2456,6 @@ xfs_bmap_add_extent_unwritten_real(
>  			cur->bc_rec.b = PREV;
>  			if ((error = xfs_btree_insert(cur, &i)))
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  			/*
>  			 * Reset the cursor to the position of the new extent
>  			 * we are about to insert as we can't trust it after
> @@ -2507,11 +2472,6 @@ xfs_bmap_add_extent_unwritten_real(
>  			/* new middle extent - newext */
>  			if ((error = xfs_btree_insert(cur, &i)))
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  		}
>  		break;
>  
> @@ -2767,11 +2727,6 @@ xfs_bmap_add_extent_hole_real(
>  			error = xfs_btree_insert(cur, &i);
>  			if (error)
>  				goto done;
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				error = -EFSCORRUPTED;
> -				goto done;
> -			}
>  		}
>  		break;
>  	}
> @@ -5093,10 +5048,6 @@ xfs_bmap_del_extent_real(
>  				*logflagsp = 0;
>  				return -ENOSPC;
>  			}
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				return -EFSCORRUPTED;
> -			}
>  		} else
>  			*logflagsp |= xfs_ilog_fext(whichfork);
>  
> @@ -5958,11 +5909,6 @@ xfs_bmap_split_extent(
>  		error = xfs_btree_insert(cur, &i);
>  		if (error)
>  			goto del_cursor;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto del_cursor;
> -		}
>  	}
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 6b67308fa594..49e9993ce360 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -276,15 +276,6 @@ xfs_refcount_insert(
>  	cur->bc_rec.rc.rc_domain = irec->rc_domain;
>  
>  	error = xfs_btree_insert(cur, i);
> -	if (error)
> -		goto out_error;
> -	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
> -		xfs_btree_mark_sick(cur);
> -		error = -EFSCORRUPTED;
> -		goto out_error;
> -	}
> -
> -out_error:
>  	if (error)
>  		trace_xfs_refcount_insert_error(cur, error, _RET_IP_);
>  	return error;
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 14aef87837a9..ff4aef8d30a7 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -146,13 +146,6 @@ xfs_rmap_insert(
>  	rcur->bc_rec.r.rm_offset = offset;
>  	rcur->bc_rec.r.rm_flags = flags;
>  	error = xfs_btree_insert(rcur, &i);
> -	if (error)
> -		goto done;
> -	if (XFS_IS_CORRUPT(rcur->bc_mp, i != 1)) {
> -		xfs_btree_mark_sick(rcur);
> -		error = -EFSCORRUPTED;
> -		goto done;
> -	}
>  done:
>  	if (error)
>  		trace_xfs_rmap_insert_error(rcur, error, _RET_IP_);
> @@ -1185,11 +1178,6 @@ xfs_rmap_map(
>  		error = xfs_btree_insert(cur, &i);
>  		if (error)
>  			goto out_error;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto out_error;
> -		}
>  	}
>  
>  	trace_xfs_rmap_map_done(cur, bno, len, unwritten, oinfo);
> @@ -1592,11 +1580,6 @@ xfs_rmap_convert(
>  		error = xfs_btree_insert(cur, &i);
>  		if (error)
>  			goto done;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto done;
> -		}
>  		break;
>  
>  	case RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG:
> @@ -1650,11 +1633,6 @@ xfs_rmap_convert(
>  		error = xfs_btree_insert(cur, &i);
>  		if (error)
>  			goto done;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto done;
> -		}
>  		break;
>  
>  	case 0:
> @@ -1683,11 +1661,6 @@ xfs_rmap_convert(
>  		error = xfs_btree_insert(cur, &i);
>  		if (error)
>  			goto done;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto done;
> -		}
>  		/*
>  		 * Reset the cursor to the position of the new extent
>  		 * we are about to insert as we can't trust it after
> @@ -1709,11 +1682,6 @@ xfs_rmap_convert(
>  		error = xfs_btree_insert(cur, &i);
>  		if (error)
>  			goto done;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto done;
> -		}
>  		break;
>  
>  	case RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG | RMAP_RIGHT_CONTIG:
> -- 
> 2.55.0
> 
> 

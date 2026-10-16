Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8933C3B71A6
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792180056; cv=none; b=G9QEgxnwCy9l7T6ZYj5RpIrTFVXsV6W7qortCzeQfKfgOKZXwfipBY1YE98cIKanyTaoKmfUc+k2217JDhCuv9WxxZBE3S7GgOQ4Ib3vK1Gk0gIkuUndKO1e7b1nNAQwCbrL/aQ4hYwrBrXHiEBws9fFmV05vRTYug2bkcIfaaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792180056; c=relaxed/simple;
	bh=xjuhH5tRCCw2vl2rlvoLf/+hVDU00YzQ0onW8YkXNbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T3HLpq83Gf/54XJtsLpbdXMK28FnarY4ARaESZ9XUvtBUC0Hf9eXdkqF1Ua37XBqe/csQlTYh865xM1lFQV1F0SvIZ/AqxGUiYzyd0xeMBZX5+FUjrdNRer1dmKV97xS+T70xVP/3IuQAhtYNkuVCRpGf33wm9GsfBQcOb3Qaik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/pwhaMi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/pwhaMi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C60261F000C4;
	Fri, 16 Oct 2026 19:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792180046;
	bh=/c2EXMQfSOw7TerjyTzTOQJ1bUISboI/faI3v9mMrNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B/pwhaMi8L4/+KnWnpBTqPBJDF4rRuJ226vGIvIEA2c11Eve9a5ddigXaJ5VBAdpc
	 clIUHTMNikVc2wAKre/pbIOrJc/UKcxg9/203IC2IH8FZEy4fJ2EHxYY/Pe/eCjKhb
	 FYiY+hBnyyakG8O91/19SC5SDvvOEwHp1y4sGUbV59mKudLTSvQkSs39gVFDtShdZV
	 5h4621rJZ8dkHT/bW0+yx5tqDTzh6CEWN3LSK9s+ftf6vVhNEmJFCKZocf3WpLyvrT
	 SioG2nVNGQW6X3F2bGNkWFV4VHlxsLk1rGnKMXZqPFqtYuCch+iSIa2n3xusOsykJ+
	 IHpRLMiZeHTWA==
Date: Fri, 16 Oct 2026 12:47:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de, dgc@kernel.org
Subject: Re: [PATCH 7/8] xfs: remove redundant stat checks after
 xfs_refcount_delete()
Message-ID: <20261016194726.GI107986@frogsfrogsfrogs>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-8-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016193422.1630907-8-sandeen@redhat.com>

On Fri, Oct 16, 2026 at 02:29:07PM -0500, Eric Sandeen wrote:
> xfs_refcount_delete() simply returns the error and status from
> xfs_btree_delete, which now validates the delete or returns an error.
> 
> This makes every instance of the 2nd test in this idiom:
> 
> 	error = xfs_refcount_delete(cur, &found_rec);
> 	if (error)
> 		goto out_error;
> 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
> 		xfs_btree_mark_sick(cur);
> 		error = -EFSCORRUPTED;
> 		goto out_error;
> 	}
> 
> unnecessary/unreachable code. Remove them.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_refcount.c | 30 ------------------------------
>  1 file changed, 30 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index bf7526621681..924f839b35a0 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -500,21 +500,11 @@ xfs_refcount_merge_center_extents(
>  	error = xfs_refcount_delete(cur, &found_rec);
>  	if (error)
>  		goto out_error;
> -	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
> -		xfs_btree_mark_sick(cur);
> -		error = -EFSCORRUPTED;
> -		goto out_error;
> -	}
>  
>  	if (center->rc_refcount > 1) {
>  		error = xfs_refcount_delete(cur, &found_rec);
>  		if (error)
>  			goto out_error;
> -		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto out_error;
> -		}
>  	}
>  
>  	/* Enlarge the left extent. */
> @@ -574,11 +564,6 @@ xfs_refcount_merge_left_extent(
>  		error = xfs_refcount_delete(cur, &found_rec);
>  		if (error)
>  			goto out_error;
> -		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto out_error;
> -		}
>  	}
>  
>  	/* Enlarge the left extent. */
> @@ -641,11 +626,6 @@ xfs_refcount_merge_right_extent(
>  		error = xfs_refcount_delete(cur, &found_rec);
>  		if (error)
>  			goto out_error;
> -		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto out_error;
> -		}
>  	}
>  
>  	/* Enlarge the right extent. */
> @@ -1232,11 +1212,6 @@ xfs_refcount_adjust_extents(
>  			error = xfs_refcount_delete(cur, &found_rec);
>  			if (error)
>  				goto out_error;
> -			if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
> -				xfs_btree_mark_sick(cur);
> -				error = -EFSCORRUPTED;
> -				goto out_error;
> -			}
>  			goto advloop;
>  		} else {
>  			error = xrefc_free_extent(cur, &ext);
> @@ -1847,11 +1822,6 @@ xfs_refcount_adjust_cow_extents(
>  		error = xfs_refcount_delete(cur, &found_rec);
>  		if (error)
>  			goto out_error;
> -		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto out_error;
> -		}
>  		break;
>  	default:
>  		ASSERT(0);
> -- 
> 2.55.0
> 
> 

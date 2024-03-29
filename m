Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3850D85627
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 16:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711729284; cv=none; b=FLilW+oANaAzWs0nK5UkibJYu2eGnmiRaWc+7GlPZKYQhbZGefSNDZEbAs0jc5GIV8AToCMMkTCHIrpR/ZI0/DEARx8HqezcofDj//xYwByU9X9N/1x6QHtny/R9KzsDO8WxvX70BlMPCGENapgLzXYhlbAOM6bC0VaURt1TAFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711729284; c=relaxed/simple;
	bh=aaR7VsIs45VZBGT2rK6z8izUHbUHaN5LeItWyQ8Orqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6tBm7chqgnGPcdRDBBirb2eNr99suTJLNCcfLgWL6czdAznfcEOkrOVyCNHYxr0gvLkclGFmmPB4TrsjwqU2KMTDZzCUhnhTY3jbRuzy/z1mum7nTacJrKib5SatNjLpxypPHVhWttIstxtBMQcELEWo3eOUnvO9MLd6aSkXPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XVqta1KK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XVqta1KK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAC0C433C7;
	Fri, 29 Mar 2024 16:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711729283;
	bh=aaR7VsIs45VZBGT2rK6z8izUHbUHaN5LeItWyQ8Orqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XVqta1KKqWdK66zVDmvuKIlw1wPtMSVzpig9cMiWxkcfcl4AJGVW1xluAJHNZ0WnJ
	 lpV8QrZDWatSddL7aJYd6ZlrNEhsT//zokJmC6YxQcNxDCz8yBhVUAyyB1HXT3FADR
	 gKj5kNzFPJtIshT4ZbtWw98S5BY1rGUt8Btuj6znlbhc73bWmX2mZtbwk90rh3TOX/
	 BaVbiSMuZAgEPc0VdcLE6PVUH4zbq/5csqn2j3x/R5WdCDR6II7oOBb9kLGBgwGd4g
	 6xf1lvgk3JDCpF58ZJADbTzDYXIbTnFy51ahIUjWNJU1HnlHMA2J3YHd4G1NNSUXfJ
	 x2cTfwV8ZgrtA==
Date: Fri, 29 Mar 2024 09:21:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: xfs_quota_unreserve_blkres can't fail
Message-ID: <20240329162123.GG6390@frogsfrogsfrogs>
References: <20240328070256.2918605-1-hch@lst.de>
 <20240328070256.2918605-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240328070256.2918605-4-hch@lst.de>

On Thu, Mar 28, 2024 at 08:02:53AM +0100, Christoph Hellwig wrote:
> Unreserving quotas can't fail due to quota limits, and we'll pіck up
> a shutdown file system a bit later in all the callers anyway.  Return
> void and remove the error checking and propagation in the callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 16 +++++-----------
>  fs/xfs/libxfs/xfs_bmap.h |  2 +-
>  fs/xfs/xfs_aops.c        |  6 +-----
>  fs/xfs/xfs_bmap_util.c   |  9 +++------
>  fs/xfs/xfs_bmap_util.h   |  2 +-
>  fs/xfs/xfs_iomap.c       |  4 ++--
>  fs/xfs/xfs_quota.h       |  5 +++--
>  fs/xfs/xfs_reflink.c     | 11 +++--------
>  8 files changed, 19 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 656c95a22f2e6d..6c752e55a52724 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4895,7 +4895,7 @@ xfs_bmap_split_indlen(
>  	return stolen;
>  }
>  
> -int
> +void
>  xfs_bmap_del_extent_delay(
>  	struct xfs_inode	*ip,
>  	int			whichfork,
> @@ -4910,7 +4910,6 @@ xfs_bmap_del_extent_delay(
>  	xfs_fileoff_t		del_endoff, got_endoff;
>  	xfs_filblks_t		got_indlen, new_indlen, stolen;
>  	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
> -	int			error = 0;
>  	bool			isrt;
>  
>  	XFS_STATS_INC(mp, xs_del_exlist);
> @@ -4934,9 +4933,7 @@ xfs_bmap_del_extent_delay(
>  	 * indirect block accounting.
>  	 */
>  	ASSERT(!isrt);
> -	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount);
> -	if (error)
> -		return error;
> +	xfs_quota_unreserve_blkres(ip, del->br_blockcount);
>  	ip->i_delayed_blks -= del->br_blockcount;
>  
>  	if (got->br_startoff == del->br_startoff)
> @@ -5016,7 +5013,6 @@ xfs_bmap_del_extent_delay(
>  		xfs_mod_fdblocks(mp, da_diff, false);
>  		xfs_mod_delalloc(mp, -da_diff);
>  	}
> -	return error;
>  }
>  
>  void
> @@ -5584,18 +5580,16 @@ __xfs_bunmapi(
>  
>  delete:
>  		if (wasdel) {
> -			error = xfs_bmap_del_extent_delay(ip, whichfork, &icur,
> -					&got, &del);
> +			xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del);
>  		} else {
>  			error = xfs_bmap_del_extent_real(ip, tp, &icur, cur,
>  					&del, &tmp_logflags, whichfork,
>  					flags);
>  			logflags |= tmp_logflags;
> +			if (error)
> +				goto error0;
>  		}
>  
> -		if (error)
> -			goto error0;
> -
>  		end = del.br_startoff - 1;
>  nodelete:
>  		/*
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index f7662595309d86..0144835117c610 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -195,7 +195,7 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
>  int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
>  		xfs_extnum_t nexts, int *done);
> -int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
> +void	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
>  		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
>  		struct xfs_bmbt_irec *del);
>  void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 3f428620ebf2a3..c51bc17f5cfa03 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -469,7 +469,6 @@ xfs_discard_folio(
>  {
>  	struct xfs_inode	*ip = XFS_I(folio->mapping->host);
>  	struct xfs_mount	*mp = ip->i_mount;
> -	int			error;
>  
>  	if (xfs_is_shutdown(mp))
>  		return;
> @@ -483,11 +482,8 @@ xfs_discard_folio(
>  	 * byte of the next folio. Hence the end offset is only dependent on the
>  	 * folio itself and not the start offset that is passed in.
>  	 */
> -	error = xfs_bmap_punch_delalloc_range(ip, pos,
> +	xfs_bmap_punch_delalloc_range(ip, pos,
>  				folio_pos(folio) + folio_size(folio));
> -
> -	if (error && !xfs_is_shutdown(mp))
> -		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
>  }
>  
>  static const struct iomap_writeback_ops xfs_writeback_ops = {
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 19e11d1da66074..2be52d8265db91 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -440,7 +440,7 @@ xfs_getbmap(
>   * if the ranges only partially overlap them, so it is up to the caller to
>   * ensure that partial blocks are not passed in.
>   */
> -int
> +void
>  xfs_bmap_punch_delalloc_range(
>  	struct xfs_inode	*ip,
>  	xfs_off_t		start_byte,
> @@ -452,7 +452,6 @@ xfs_bmap_punch_delalloc_range(
>  	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
>  	struct xfs_bmbt_irec	got, del;
>  	struct xfs_iext_cursor	icur;
> -	int			error = 0;
>  
>  	ASSERT(!xfs_need_iread_extents(ifp));
>  
> @@ -476,15 +475,13 @@ xfs_bmap_punch_delalloc_range(
>  			continue;
>  		}
>  
> -		error = xfs_bmap_del_extent_delay(ip, XFS_DATA_FORK, &icur,
> -						  &got, &del);
> -		if (error || !xfs_iext_get_extent(ifp, &icur, &got))
> +		xfs_bmap_del_extent_delay(ip, XFS_DATA_FORK, &icur, &got, &del);
> +		if (!xfs_iext_get_extent(ifp, &icur, &got))
>  			break;
>  	}
>  
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 77ecbb753ef207..51f84d8ff372fa 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -30,7 +30,7 @@ xfs_bmap_rtalloc(struct xfs_bmalloca *ap)
>  }
>  #endif /* CONFIG_XFS_RT */
>  
> -int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
> +void	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
>  		xfs_off_t start_byte, xfs_off_t end_byte);
>  
>  struct kgetbmap {
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 4087af7f3c9f3f..ba359bee2c2256 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1194,8 +1194,8 @@ xfs_buffered_write_delalloc_punch(
>  	loff_t			offset,
>  	loff_t			length)
>  {
> -	return xfs_bmap_punch_delalloc_range(XFS_I(inode), offset,
> -			offset + length);
> +	xfs_bmap_punch_delalloc_range(XFS_I(inode), offset, offset + length);
> +	return 0;
>  }
>  
>  static int
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index 621ea9d7cf06d9..078b2b88206b2c 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -215,10 +215,11 @@ xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
>  	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
>  }
>  
> -static inline int
> +static inline void
>  xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t blocks)
>  {
> -	return xfs_quota_reserve_blkres(ip, -blocks);
> +	/* don't return an error as unreserving quotas can't fail */
> +	xfs_quota_reserve_blkres(ip, -blocks);

xfs_quota_reserve_blkres only doesn't fail if the nblks argument is
actually negative.  Can we have an ASSERT(blocks >= 0) here to guard
against someone accidentally passing in a negative @blocks here?

Everything else in this patch looks good to me.

--D

>  }
>  
>  extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index df632790a0a51c..83f243cfa40571 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -606,10 +606,8 @@ xfs_reflink_cancel_cow_blocks(
>  		trace_xfs_reflink_cancel_cow(ip, &del);
>  
>  		if (isnullstartblock(del.br_startblock)) {
> -			error = xfs_bmap_del_extent_delay(ip, XFS_COW_FORK,
> -					&icur, &got, &del);
> -			if (error)
> -				break;
> +			xfs_bmap_del_extent_delay(ip, XFS_COW_FORK, &icur, &got,
> +					&del);
>  		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
>  			ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
>  
> @@ -632,10 +630,7 @@ xfs_reflink_cancel_cow_blocks(
>  			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
>  
>  			/* Remove the quota reservation */
> -			error = xfs_quota_unreserve_blkres(ip,
> -					del.br_blockcount);
> -			if (error)
> -				break;
> +			xfs_quota_unreserve_blkres(ip, del.br_blockcount);
>  		} else {
>  			/* Didn't do anything, push cursor back. */
>  			xfs_iext_prev(ifp, &icur);
> -- 
> 2.39.2
> 
> 

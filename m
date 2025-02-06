Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F1A1D61B1
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 20:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738875291; cv=none; b=Xr3W7Q/WbFE+RBHVwVc4HiCAygHuHwiV8Q0d8+R9EOSo0Ygzqt2e8y/UV3HHWYArLJCLDnDRrWJqj0vMrHQQ8M+FPcnbOrOvjvFqNzXyKU5JmM1YVqF+PsrgVxn00JRHiYEWTz8qXsmB5A4I4hwFalFNdVF2upGduDJZTHhoN0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738875291; c=relaxed/simple;
	bh=t+l07bhw00lEhTgZ5OcWZ0AIOoU3p5OzUCbzPleJ58k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+xjZ+ORKniLphgNGII73oVw0q057m0SGGSQ1qcUK28IuMfFUApd34Cl6fvuzvWGcHNmD3JL/IB/IvceAWLOe3ny0LJcrjAnCj/9XkeTJpPW9mYKatOirrITTZVqwdg7QZbqZN54cKGJyyrdsk2ta9901WTCTWGJ/B1AErQjlnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocnSpKeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocnSpKeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B1DC4CEDD;
	Thu,  6 Feb 2025 20:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738875290;
	bh=t+l07bhw00lEhTgZ5OcWZ0AIOoU3p5OzUCbzPleJ58k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ocnSpKeBb9UTfJFcnDsXw/Rm9rjzb2qEoYSylxd6JxBz3nD+tCwkxmldRfBxYehrc
	 zUWQ/Tk3d4cy370TWUG9hqPvgA2xylUzdcq3Qd2/jt/3mDL2mHZRd99tLVlxd2yMb8
	 T6/k0iSwGxkqLYhiIqDIFi/ntaKNSiLmm9pSWAjZ//zkfMMSO/ZOedh+HhZClnXs+w
	 LcpVEEw8iYVZE7NetttTsiQ952mfdNH15wktBrctE//dgeSr2NL8wje8BSj4H1X95C
	 4+HN0HeOPKUydAd03oZYIxsASttz02NVj9sxhQJjiREr429qutl5syvH8E4qgrukaB
	 ODBc0CcJe5TSA==
Date: Thu, 6 Feb 2025 12:54:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/43] xfs: support XFS_BMAPI_REMAP in
 xfs_bmap_del_extent_delay
Message-ID: <20250206205449.GN21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-13-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:28AM +0100, Christoph Hellwig wrote:
> The zone allocator wants to be able to remove a delalloc mapping in the
> COW fork while keeping the block reservation.  To support that pass the
> blags argument down to xfs_bmap_del_extent_delay and support the

  bmapi flags?

I've seen a lot of blagging on the Internet today about Linux.

> XFS_BMAPI_REMAP flag to keep the reservation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With that expanded,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 10 +++++++---
>  fs/xfs/libxfs/xfs_bmap.h |  2 +-
>  fs/xfs/xfs_bmap_util.c   |  2 +-
>  fs/xfs/xfs_reflink.c     |  2 +-
>  4 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5b17e59ed5b8..522c126e52fb 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4667,7 +4667,8 @@ xfs_bmap_del_extent_delay(
>  	int			whichfork,
>  	struct xfs_iext_cursor	*icur,
>  	struct xfs_bmbt_irec	*got,
> -	struct xfs_bmbt_irec	*del)
> +	struct xfs_bmbt_irec	*del,
> +	uint32_t		bflags)	/* bmapi flags */
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
> @@ -4787,7 +4788,9 @@ xfs_bmap_del_extent_delay(
>  	da_diff = da_old - da_new;
>  	fdblocks = da_diff;
>  
> -	if (isrt)
> +	if (bflags & XFS_BMAPI_REMAP)
> +		;
> +	else if (isrt)
>  		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, del->br_blockcount));
>  	else
>  		fdblocks += del->br_blockcount;
> @@ -5389,7 +5392,8 @@ __xfs_bunmapi(
>  
>  delete:
>  		if (wasdel) {
> -			xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del);
> +			xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got,
> +					&del, flags);
>  		} else {
>  			error = xfs_bmap_del_extent_real(ip, tp, &icur, cur,
>  					&del, &tmp_logflags, whichfork,
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 4d48087fd3a8..b4d9c6e0f3f9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -204,7 +204,7 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_extnum_t nexts, int *done);
>  void	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
>  		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
> -		struct xfs_bmbt_irec *del);
> +		struct xfs_bmbt_irec *del, uint32_t bflags);
>  void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
>  		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
>  		struct xfs_bmbt_irec *del);
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0836fea2d6d8..c623688e457c 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -467,7 +467,7 @@ xfs_bmap_punch_delalloc_range(
>  			continue;
>  		}
>  
> -		xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del);
> +		xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del, 0);
>  		if (!xfs_iext_get_extent(ifp, &icur, &got))
>  			break;
>  	}
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index fd65e5d7994a..b977930c4ebc 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -651,7 +651,7 @@ xfs_reflink_cancel_cow_blocks(
>  
>  		if (isnullstartblock(del.br_startblock)) {
>  			xfs_bmap_del_extent_delay(ip, XFS_COW_FORK, &icur, &got,
> -					&del);
> +					&del, 0);
>  		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
>  			ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
>  
> -- 
> 2.45.2
> 
> 

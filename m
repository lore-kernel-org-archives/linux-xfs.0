Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FE42F2F
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 21:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734040041; cv=none; b=puz72YCCdbVBZl9LKYdwq+eLxsQXrS4s4S31zW0izrxs5RibWfKhXwz6GAZrjkM2+SbJOS4EUa1ARH6TfASNHBibNj9UljrGYzo62kj+fY54UvnQJ4KTQXPHjNTGqwuM/Pb9slZM1Yyu2/EnKfbbSGKLN9X7/jhaGfgdVdykU8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734040041; c=relaxed/simple;
	bh=XjsM+6Dy+l7TlW+QoYFmMHvH4nXCjO+pxi7yZnQTlbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h0mJvaAvq4PcBxNfJAuqYZ859m9QXhw5KO+UHbo/ZvGgQsmn4SNZyPlMI7HAoHgrJD0IKNMVTrHNZFVRw0zLUJ6w75zu2a9MBTQpBY4vnvRwxxXcrLbO0H/RhcKdjrvBXgAA0VF6shSYe5srqa8hxitOpY+V5TukXWJwtkQtWHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ubwv0qiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ubwv0qiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AD1C4CECE;
	Thu, 12 Dec 2024 21:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734040040;
	bh=XjsM+6Dy+l7TlW+QoYFmMHvH4nXCjO+pxi7yZnQTlbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ubwv0qiSKFVgy0klV4zzLikcdNvEygySn7u981TAW7DxBY35NJCRxUVF4YTaN/RE1
	 AOtyl8nAgQ1pynpsgslywthlJmADX/CRK9fQ7bkr4Qym50E5JCId4+bnuxYk8lael9
	 cjC06cp+mbbxnasEhR0MoOebYaI4EIyItXynU4lLfQvp4+wJSByApV/GiPj41PzY0C
	 t4MzkdPuPe4TEqGWghEpWuIxXRE3A4ZGYrwcWgJJm7CeFkwJMtJRcO67nEJDkRQH7P
	 SzWeE6RtkHMjdg2Q8FVJr5ZO3vvT6NJFO/qgjHBHGv28v3ua5NKaqefqTPf2U0wzzp
	 Qg9v/hXMS/5xg==
Date: Thu, 12 Dec 2024 13:47:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/43] xfs: support XFS_BMAPI_REMAP in
 xfs_bmap_del_extent_delayOM
Message-ID: <20241212214720.GZ6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-14-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:38AM +0100, Christoph Hellwig wrote:
> The zone allocator wants to be able to remove a delalloc mapping in the
> COW fork while keeping the block reservation.  To support that pass the
> blags argument down to xfs_bmap_del_extent_delay and support the

  bflags

> XFS_BMAPI_REMAP flag to keep the reservation.

Is REMAP the only bmapi flag that will be valid here?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 10 +++++++---
>  fs/xfs/libxfs/xfs_bmap.h |  2 +-
>  fs/xfs/xfs_bmap_util.c   |  2 +-
>  fs/xfs/xfs_reflink.c     |  2 +-
>  4 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 861945a5fce3..512f1ceca47f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4666,7 +4666,8 @@ xfs_bmap_del_extent_delay(
>  	int			whichfork,
>  	struct xfs_iext_cursor	*icur,
>  	struct xfs_bmbt_irec	*got,
> -	struct xfs_bmbt_irec	*del)
> +	struct xfs_bmbt_irec	*del,
> +	uint32_t		bflags)	/* bmapi flags */
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
> @@ -4786,7 +4787,9 @@ xfs_bmap_del_extent_delay(
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
> @@ -5388,7 +5391,8 @@ __xfs_bunmapi(
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
> index 3e778e077d09..b7dba5ad2f34 100644
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

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B886DD0E
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 20:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CkHUUaHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA44EC433C7;
	Thu, 14 Dec 2023 20:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702587142;
	bh=EmdsO3Wft5xAxaXC60QqDnKN4uY7VjU6VyF1Be7sQTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CkHUUaHnmdzwXoHtOZkWb6GjleS9+lTFn3ezntB8X2vpUYnmN5yIA2XYf88cwI3Ge
	 0n8kEd4y5QZVH/QMs6Q+lNyhBy4rTZRePEhxTHwNuDg8BQnfnbLbLY9uIRwAnZpFFL
	 VS+fbmH/uoCNv8vxy8Cv7Av/AZjDqVqMyEj/Wua+b4mz/SS25V6KxwachaXjGHA7X3
	 nVkn9Dl9qY87JlqS38CKhb0LQKIwNF0hycCjRsGCKer4a+qbrStoxrQX7nTMDz/eJh
	 VHhSJLjPt44aE2GI8rvtOUR8F0z4Ms418Bsvw0tzUeA8cdkdfPU+FBYkAoOLspXXZZ
	 S5mdjHWY91AIQ==
Date: Thu, 14 Dec 2023 12:52:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/19] xfs: indicate if xfs_bmap_adjacent changed
 ap->blkno
Message-ID: <20231214205222.GW361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-9-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:27AM +0100, Christoph Hellwig wrote:
> Add a return value to xfs_bmap_adjacent to indicate if it did change
> ap->blkno or not.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me, though I don't see any immediate callsite changes so I
guess I'll look out for whatever uses the return value.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 19 ++++++++++++++-----
>  fs/xfs/xfs_bmap_util.h   |  2 +-
>  2 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6722205949ad4c..46a9b22a3733e3 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3044,7 +3044,8 @@ xfs_bmap_extsize_align(
>  
>  #define XFS_ALLOC_GAP_UNITS	4
>  
> -void
> +/* returns true if ap->blkno was modified */
> +bool
>  xfs_bmap_adjacent(
>  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
>  {
> @@ -3079,13 +3080,14 @@ xfs_bmap_adjacent(
>  		if (adjust &&
>  		    ISVALID(ap->blkno + adjust, ap->prev.br_startblock))
>  			ap->blkno += adjust;
> +		return true;
>  	}
>  	/*
>  	 * If not at eof, then compare the two neighbor blocks.
>  	 * Figure out whether either one gives us a good starting point,
>  	 * and pick the better one.
>  	 */
> -	else if (!ap->eof) {
> +	if (!ap->eof) {
>  		xfs_fsblock_t	gotbno;		/* right side block number */
>  		xfs_fsblock_t	gotdiff=0;	/* right side difference */
>  		xfs_fsblock_t	prevbno;	/* left side block number */
> @@ -3165,14 +3167,21 @@ xfs_bmap_adjacent(
>  		 * If both valid, pick the better one, else the only good
>  		 * one, else ap->blkno is already set (to 0 or the inode block).
>  		 */
> -		if (prevbno != NULLFSBLOCK && gotbno != NULLFSBLOCK)
> +		if (prevbno != NULLFSBLOCK && gotbno != NULLFSBLOCK) {
>  			ap->blkno = prevdiff <= gotdiff ? prevbno : gotbno;
> -		else if (prevbno != NULLFSBLOCK)
> +			return true;
> +		}
> +		if (prevbno != NULLFSBLOCK) {
>  			ap->blkno = prevbno;
> -		else if (gotbno != NULLFSBLOCK)
> +			return true;
> +		}
> +		if (gotbno != NULLFSBLOCK) {
>  			ap->blkno = gotbno;
> +			return true;
> +		}
>  	}
>  #undef ISVALID
> +	return false;
>  }
>  
>  int
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 6888078f5c31e0..77ecbb753ef207 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -47,7 +47,7 @@ int	xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
>  			       struct xfs_bmbt_irec *prevp, xfs_extlen_t extsz,
>  			       int rt, int eof, int delay, int convert,
>  			       xfs_fileoff_t *offp, xfs_extlen_t *lenp);
> -void	xfs_bmap_adjacent(struct xfs_bmalloca *ap);
> +bool	xfs_bmap_adjacent(struct xfs_bmalloca *ap);
>  int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  			     int whichfork, struct xfs_bmbt_irec *rec,
>  			     int *is_empty);
> -- 
> 2.39.2
> 
> 

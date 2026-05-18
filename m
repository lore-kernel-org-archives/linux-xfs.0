Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225A8330D36
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 11:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779102876; cv=none; b=u6O5r95ZtMy+6eX3HOVcgDaAOfOSZGSR5ov9g5bbF9TNcOYTeNpElfs6tm2bGnXyqhoDWF+ZTTk/OmUEz8wjUKBulZ+fvPUzgUzF1gfuErGicnxWAa2XCGlEwlDtQV2K50E5+qXgRDKEntW1l6N9teR1xa0W7MuSczUJsz5uZS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779102876; c=relaxed/simple;
	bh=xrKJA8wSXW6LbWa6kozlLRpXtpNggEBdnSKy69O6jCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7El65EZOEOX7deVroaRPpmZ0zac4H5bkzgBK2u/hcoxskk3P6Kz1QodFzBRH88lgz+MW7ukGrnFwMPoMBvwhWb7uBgi9Chk+3ac/bIDq8oque9+AJ3CKB07hJWyvE2XGPmJtX1ut1U4m8z/VXzoKdTw0Es9cIkX0NI+ewp2N18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7w08tC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7w08tC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6D1C2BCB7;
	Mon, 18 May 2026 11:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779102875;
	bh=xrKJA8wSXW6LbWa6kozlLRpXtpNggEBdnSKy69O6jCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g7w08tC8ErLJ3lKLZjQiyvXT3nrYYHtcSaPgmfiEK24+hmU7DRASi5+6JiIwfp/Jd
	 eUnWNrH6cPcJ83ywBF5PRR+fmk4ZzmFWmi1CUX92gskkC650cLNCfJ5kwqz1AgsJ0r
	 tLTk1bmxlnWTk2lmlxw1QBTop12i0m5nx9bShBLciUGPbBFeogy5AZ6g96Lm/ecnum
	 kDp4JycrMxOmqPRiUGtOS9QKRtlar84ra5JpuVO73hVIW49pSzK3HQ7lZpeLDpedSK
	 7A4ZrFNtuJqOoFQFdIRPsaGvjM7NyyOSFMu++woY7bo9gRRRLy6oi16/uQbtMIFnyT
	 6BHKbWf0Nwy8w==
Date: Mon, 18 May 2026 13:14:31 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: add a xfs_rmap_inode_owner helper
Message-ID: <agrzt5K9OVTPObMs@nidhogg.toxiclabs.cc>
References: <20260515135103.4042407-1-hch@lst.de>
 <20260515135103.4042407-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515135103.4042407-6-hch@lst.de>

On Fri, May 15, 2026 at 03:50:26PM +0200, Christoph Hellwig wrote:
> Add a small wrapper for initializing the rmap owner to i_ino.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This and the previous one, provides very little gain IMHO, do you intend
to get rid of xfs_rmap_ino_owner and xfs_rmap_inode_bmbt_owner? It seems
to me they could simply be replaced by these new helpers instead of just
wrapping them into these new ones.
A little disclaimer: I didn't look into the next patches yet to see if
it will all make sense later.

I'm adding a RwB here and on the previous one because the patches look
correct but I'd like to see what others think about those too.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  fs/xfs/libxfs/xfs_rmap.h | 2 ++
>  fs/xfs/scrub/bmap.c      | 6 +++---
>  fs/xfs/scrub/reap.c      | 3 +--
>  4 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 066d13e97ec9..9920e2df62b0 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -819,7 +819,7 @@ xfs_bmap_local_to_extents(
>  	args.mp = ip->i_mount;
>  	args.total = total;
>  	args.minlen = args.maxlen = args.prod = 1;
> -	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
> +	xfs_rmap_inode_owner(&args.oinfo, ip, whichfork, 0);
>  
>  	/*
>  	 * Allocate a block.  We know we need only one, since the
> diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
> index 7188459f61cf..6016fd5fcad9 100644
> --- a/fs/xfs/libxfs/xfs_rmap.h
> +++ b/fs/xfs/libxfs/xfs_rmap.h
> @@ -37,6 +37,8 @@ xfs_rmap_ino_owner(
>  	if (whichfork == XFS_ATTR_FORK)
>  		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
>  }
> +#define xfs_rmap_inode_owner(oi, ip, whichfork, offset) \
> +	xfs_rmap_ino_owner(oi, (ip)->i_ino, whichfork, offset)
>  
>  static inline bool
>  xfs_rmap_should_skip_owner_update(
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 2ad223f0bc8a..67861102cdb9 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -352,7 +352,7 @@ xchk_bmap_rt_iextent_xref(
>  	case XFS_DATA_FORK:
>  		xchk_bmap_xref_rmap(info, irec, rgbno);
>  		if (!xfs_is_reflink_inode(info->sc->ip)) {
> -			xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
> +			xfs_rmap_inode_owner(&oinfo, info->sc->ip,
>  					info->whichfork, irec->br_startoff);
>  			xchk_xref_is_only_rt_owned_by(info->sc, rgbno,
>  					irec->br_blockcount, &oinfo);
> @@ -407,7 +407,7 @@ xchk_bmap_iextent_xref(
>  	case XFS_DATA_FORK:
>  		xchk_bmap_xref_rmap(info, irec, agbno);
>  		if (!xfs_is_reflink_inode(info->sc->ip)) {
> -			xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
> +			xfs_rmap_inode_owner(&oinfo, info->sc->ip,
>  					info->whichfork, irec->br_startoff);
>  			xchk_xref_is_only_owned_by(info->sc, agbno,
>  					irec->br_blockcount, &oinfo);
> @@ -419,7 +419,7 @@ xchk_bmap_iextent_xref(
>  		break;
>  	case XFS_ATTR_FORK:
>  		xchk_bmap_xref_rmap(info, irec, agbno);
> -		xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
> +		xfs_rmap_inode_owner(&oinfo, info->sc->ip,
>  				info->whichfork, irec->br_startoff);
>  		xchk_xref_is_only_owned_by(info->sc, agbno, irec->br_blockcount,
>  				&oinfo);
> diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> index cd90ecae3ffb..fcd14c1703ea 100644
> --- a/fs/xfs/scrub/reap.c
> +++ b/fs/xfs/scrub/reap.c
> @@ -1249,8 +1249,7 @@ xreap_bmapi_select(
>  	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
>  			sc->sa.pag);
>  
> -	xfs_rmap_ino_owner(&oinfo, rs->ip->i_ino, rs->whichfork,
> -			imap->br_startoff);
> +	xfs_rmap_inode_owner(&oinfo, rs->ip, rs->whichfork, imap->br_startoff);
>  	error = xfs_rmap_has_other_keys(cur, agbno, 1, &oinfo, crosslinked);
>  	if (error)
>  		goto out_cur;
> -- 
> 2.53.0
> 
> 

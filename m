Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F673E5A0B
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 11:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779103401; cv=none; b=X+zPwvlWiJ18RsJSyupWPf7Fi4z/x/9pn3yFIe3q2QXX3h7DINut8zZBPAvUnXtFRlgeIC7Mk4XSLGpXuCOJjU8hFwhfdQRkohqCvjTQ6wbKgPoTisGmzUfQ8GOYwlm7yz/iHpvmlD/efa/TCP5vu1FXuL1n6j80svn+PJCoaUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779103401; c=relaxed/simple;
	bh=8GS0T0dMEU2d/wGQEiC+jXop9f2xsD3H1LWebFr8jwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mrnC85J+3QIk4ti4SVeqdgTw7P8krdpF9JcGVZXVNXLuhfQoxDoMv38ZH7EdkVFLsDmclWmUQEnZaWJVnIeY7kAJFqGSo175UYWyny57PztPJmWXulyhTCbh1/ETcvSnw4zBL44+eGukX8Cbr/78m11X74zbe32PbF+eA5GhC9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HW7xybqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HW7xybqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC7CC2BCB7;
	Mon, 18 May 2026 11:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779103400;
	bh=8GS0T0dMEU2d/wGQEiC+jXop9f2xsD3H1LWebFr8jwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HW7xybqdcveN/NoXV5dR/wnsApPiEHv9DPz7yNwv3BjRYgHLRPrJmD5ranGgNDGrV
	 vODZMY+vWI7ifGp9Kah2ObBzoTbw2MbYu5kRvv69IeHzBdhmDlywVxVYVG5Fvj2PSD
	 8DKh1GS2OyXWQLw9ne0dZqhp6QBNqTC/pZ0h83oUOK52YEEgblMiCVi9QAeJ+Ttizp
	 uIaf+OMZXrD3pBfmnssbgljNmzttIGFDOXo3ndxhQ8l2BM64HLzJUmxa3kdZcLZbyw
	 AR2Ibx3qBUeYMUJ0HkPOoPzKDD6Nlya3yTAfla5HTv4155acCN4o0ARKePO8En8VtX
	 5O65OW5F1jR8g==
Date: Mon, 18 May 2026 13:23:16 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: add a xfs_rmap_inode_owner helper
Message-ID: <agr2biy2g5BAMDed@nidhogg.toxiclabs.cc>
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

Adding a RwB as the patch looks correct, but as I mentioned, ISTM all
callers of xfs_rmap_ino_owner have straight access to the xfs_inode, so
we could just get rid of it in lieu of this new helper.

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

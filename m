Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9F93EF0D4
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 11:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779103058; cv=none; b=IMneatkD1rPCTGdZ52osLUIhx3jY5krUX9bJTb7cqaF5h/bCVWRdZytsviRQbiAyzVf921rR2wuq+9jpkwtKWV/mLzRqZKTwVwyjV0eXnku6yy39YN7H3uuM0Uj09cwig6EQOSKkZp7CcX3f/bg5w++nmevCpb9rfC3fHWP13/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779103058; c=relaxed/simple;
	bh=lF33opxjsusXOpJOR/hFyWXS2914V9d3KzeJKhSSxXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6FqeRKEl73tJjEmADJWdc5QtPZD8tkTM/9nje60I9BQPrFZ7EBi/velrUWPPQXFYhkmIwK7y4nXUiUEB8+ZUaGOwnZWdXfM9EbCjBN4TNnBvw31IKoIzkdiMymzxEIQ1c41NmbxCJYrrpnPqYcRQoZHOc1I2riatmv5oF8Hn/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bOuQPYrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bOuQPYrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940B6C2BCB8;
	Mon, 18 May 2026 11:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779103056;
	bh=lF33opxjsusXOpJOR/hFyWXS2914V9d3KzeJKhSSxXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bOuQPYrFrRezvn04qmVfvOvrRKuKcGf/xylQK+FW4UjVAG10amKdt/2yZsDvMCFKK
	 DtEa0yQrbDkpJQE8UZwHXgdd94Z/GhAvW5fX34I7wR1i4PDJMb97n8N/piWDfcBllr
	 mBC2gSzbFn2Nq014hNgV8+uS2TIiOpl441NTAxnSgsU+55aYMDnJIbH0CdROIYttvn
	 YpPt9uTd4ZEfJBo/UgG6r7io2GmMI0AC3yKEv4+vynZcNfIwxfNZo2XU+BwJntbb/u
	 2e5Js6yoSVgbqENwJ+kGiMzFjG0XvxgOzEJwxaIS2JTXM2Hk/uPSqJlMVjesS5eELg
	 Euykb46qesa/Q==
Date: Mon, 18 May 2026 13:17:32 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: convert xchk_inode_xref_set_corrupt to
 xchk_ip_xref_set_corrupt
Message-ID: <agr1SLuUd4CBdeg9@nidhogg.toxiclabs.cc>
References: <20260515135103.4042407-1-hch@lst.de>
 <20260515135103.4042407-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515135103.4042407-8-hch@lst.de>

On Fri, May 15, 2026 at 03:50:28PM +0200, Christoph Hellwig wrote:
> All xref corruption reports have the xfs_inode structure, so switch
> the helper to work based on that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/scrub/common.c    | 6 +++---
>  fs/xfs/scrub/common.h    | 4 ++--
>  fs/xfs/scrub/dirtree.c   | 4 ++--
>  fs/xfs/scrub/inode.c     | 6 +++---
>  fs/xfs/scrub/nlinks.c    | 2 +-
>  fs/xfs/scrub/rtbitmap.c  | 4 ++--
>  fs/xfs/scrub/rtsummary.c | 2 +-
>  7 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 5041f0c91603..f4d17239175f 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -309,12 +309,12 @@ xchk_ino_set_corrupt(
>  
>  /* Record a corruption while cross-referencing with an inode. */
>  void
> -xchk_ino_xref_set_corrupt(
> +xchk_ip_xref_set_corrupt(
>  	struct xfs_scrub	*sc,
> -	xfs_ino_t		ino)
> +	struct xfs_inode	*ip)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
> -	trace_xchk_ino_error(sc, ino, __return_address);
> +	trace_xchk_ino_error(sc, ip->i_ino, __return_address);
>  }
>  
>  /* Record corruption in a block indexed by a file fork. */
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index ae998501f8aa..5f854d3c7e8e 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -41,8 +41,8 @@ void xchk_qcheck_set_corrupt(struct xfs_scrub *sc, unsigned int dqtype,
>  
>  void xchk_block_xref_set_corrupt(struct xfs_scrub *sc,
>  		struct xfs_buf *bp);
> -void xchk_ino_xref_set_corrupt(struct xfs_scrub *sc,
> -		xfs_ino_t ino);
> +void xchk_ip_xref_set_corrupt(struct xfs_scrub *sc,
> +		struct xfs_inode *ip);
>  void xchk_fblock_xref_set_corrupt(struct xfs_scrub *sc,
>  		int whichfork, xfs_fileoff_t offset);
>  
> diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
> index 124b2379d5c4..51b37dfa28f0 100644
> --- a/fs/xfs/scrub/dirtree.c
> +++ b/fs/xfs/scrub/dirtree.c
> @@ -954,7 +954,7 @@ xchk_dirtree(
>  		 * parent pointers are corrupt; this scan cannot be completed
>  		 * without full information.
>  		 */
> -		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
> +		xchk_ip_xref_set_corrupt(sc, sc->ip);
>  		error = 0;
>  		goto out_scanlock;
>  	}
> @@ -984,7 +984,7 @@ xchk_dirtree(
>  		if (oc.bad || oc.good + oc.suspect != 1)
>  			xchk_ip_set_corrupt(sc, sc->ip);
>  		if (oc.suspect)
> -			xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
> +			xchk_ip_xref_set_corrupt(sc, sc->ip);
>  	}
>  
>  out_scanlock:
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 948d04dcba2a..3f234e9c5afd 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -710,17 +710,17 @@ xchk_inode_xref_bmap(
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
>  	if (nextents < xfs_dfork_data_extents(dip))
> -		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
> +		xchk_ip_xref_set_corrupt(sc, sc->ip);
>  
>  	error = xchk_inode_count_blocks(sc, XFS_ATTR_FORK, &nextents, &acount);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
>  	if (nextents != xfs_dfork_attr_extents(dip))
> -		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
> +		xchk_ip_xref_set_corrupt(sc, sc->ip);
>  
>  	/* Check nblocks against the inode. */
>  	if (count + acount != be64_to_cpu(dip->di_nblocks))
> -		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
> +		xchk_ip_xref_set_corrupt(sc, sc->ip);
>  }
>  
>  /* Cross-reference with the other btrees. */
> diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
> index 2a214802c77c..01ce6517a036 100644
> --- a/fs/xfs/scrub/nlinks.c
> +++ b/fs/xfs/scrub/nlinks.c
> @@ -740,7 +740,7 @@ xchk_nlinks_compare_inode(
>  		 * number of subdirectory entries in the directory.
>  		 */
>  		if (obs.children != obs.backrefs)
> -			xchk_ino_xref_set_corrupt(sc, ip->i_ino);
> +			xchk_ip_xref_set_corrupt(sc, ip);
>  	} else {
>  		/*
>  		 * Non-directories and unlinked directories should not have
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index 10d4c11372d9..de3f22f310f7 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -284,7 +284,7 @@ xchk_xref_is_used_rt_space(
>  	if (xfs_has_zoned(sc->mp)) {
>  		if (!xfs_zone_rgbno_is_valid(rtg,
>  				xfs_rtb_to_rgbno(sc->mp, rtbno) + len - 1))
> -			xchk_ino_xref_set_corrupt(sc, rtg_rmap(rtg)->i_ino);
> +			xchk_ip_xref_set_corrupt(sc, rtg_rmap(rtg));
>  		return;
>  	}
>  
> @@ -295,5 +295,5 @@ xchk_xref_is_used_rt_space(
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
>  	if (is_free)
> -		xchk_ino_xref_set_corrupt(sc, rtg_bitmap(rtg)->i_ino);
> +		xchk_ip_xref_set_corrupt(sc, rtg_bitmap(rtg));
>  }
> diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
> index 18074c1ff166..78f72a046887 100644
> --- a/fs/xfs/scrub/rtsummary.c
> +++ b/fs/xfs/scrub/rtsummary.c
> @@ -189,7 +189,7 @@ xchk_rtsum_record_free(
>  	rtlen = xfs_rtxlen_to_extlen(mp, rec->ar_extcount);
>  
>  	if (!xfs_verify_rtbext(mp, rtbno, rtlen)) {
> -		xchk_ino_xref_set_corrupt(sc, rtg_bitmap(rtg)->i_ino);
> +		xchk_ip_xref_set_corrupt(sc, rtg_bitmap(rtg));
>  		return -EFSCORRUPTED;
>  	}
>  
> -- 
> 2.53.0
> 

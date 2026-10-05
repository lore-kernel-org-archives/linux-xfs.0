Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8673847D93E
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 13:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205651; cv=none; b=qEI+kHDE01Lj2sUCQmzvu5jF2TWogRBw0HsC6hBIVjoMMvIdevBtmxwM1AMVyAyECG/LlEGalml6aEvMo1X9a56JOdNgEeh5As5onvzr1qcfNdd71tY6UV+AT1QFHkBvF1YeCKBBu9O18k1rorhjWY87li7e9Eu80fSElPsvXeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205651; c=relaxed/simple;
	bh=4Lp1j6orAHfywn/ATO4oqOYs8Y3mz51ktIEIhx5Wh04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Golq2pHZM5Fnnb+Oa+rluzDvGto7zJsFrut9/blyUFgNNvtiNH36RqCccDHZfZdy9p90RamqqoCWsLX3jEVYI55jy5HrsdpvE0nybQmsoiuNEKfLiwdZ73CCYedYE8+VOyGZK+Tw+AlIq+BkSx8KRT1ww5k79Q4b2xmIncEF6Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ol+XHaD9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ol+XHaD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218771F000FF;
	Mon,  5 Oct 2026 13:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791205650;
	bh=gGreXu40Y0yTNJL5kwCo1yqrMj1a5WCVqt06ImCR1M4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ol+XHaD9INPbOUmP97+RwJmEa1rMj5pFKlfiZ4stzFov0NqVJvhdqCOEMdjcAiJgO
	 C+y+Q7MjBdTEuBy03uamLAoG4kE3g9KYFUm1VjByxNkUySzb+joXXH2RvOnYCQ+4Pw
	 PUHK3zMfeEvRbrC/yTXb/lqRCfkVfUBOt6TNtgnggu0UMRSYkqrd1d1QyyjB1UlMv1
	 NeO3G6VbzHJ/3eIuSWk3lVbcQJj4YxozmEWmlLBRgwJbK+1XQknFY6dWHMyavkTzg6
	 hWaDuK+X07C9v3+coaOPxMDL3kLVVZHSx3rr8HaAf5e9tNtz/I0iU2ZcojCpa7veZk
	 fCzyK1OgQpZ4g==
Date: Mon, 5 Oct 2026 15:07:24 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 2/3] xfs: factor out xrep_reset_fork_to_extents helper
 for scrub/repair
Message-ID: <asOXG8ePgukShDRq@nidhogg.toxiclabs.cc>
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-3-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002211038.2139655-3-sandeen@redhat.com>

On Fri, Oct 02, 2026 at 04:08:10PM -0500, Eric Sandeen wrote:
> The open-coded 8-line series of steps to reset a fork to empty extents
> format is repeated 3 times; factor this out into a helper to eliminate
> cut and paste.
> 
> +/* Discard the contents of this fork and initialize as empty extent-format. */
> +void
> +xrep_reset_fork_to_extents(
> +	struct xfs_scrub	*sc,
> +	int			whichfork)
> +{
> +	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
> +
> +	xfs_idestroy_fork(ifp);
> +	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
> +	ifp->if_nextents = 0;
> +	ifp->if_bytes = 0;
> +	ifp->if_data = NULL;
> +	ifp->if_height = 0;
> +}

Why not also move xfs_trans_log_inode() here?
Sure it will need to use a different flag depending on the fork type,
but then the whole reset and log will be contained within there.



> +
>  /*
>   * Initialize all the btree cursors for an AG repair except for the btree that
>   * we're rebuilding.
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index 2bb125c4f9bf..c1ba462e4426 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -81,6 +81,7 @@ int xrep_setup_xfbtree(struct xfs_scrub *sc, const char *descr);
>  int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
>  		xfs_extnum_t nextents);
>  int xrep_reset_perag_resv(struct xfs_scrub *sc);
> +void xrep_reset_fork_to_extents(struct xfs_scrub *sc, int whichfork);
>  int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
>  int xrep_metadata_inode_forks(struct xfs_scrub *sc);
>  int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
> diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
> index 181961364233..5f5bc5211600 100644
> --- a/fs/xfs/scrub/symlink_repair.c
> +++ b/fs/xfs/scrub/symlink_repair.c
> @@ -304,16 +304,7 @@ xrep_symlink_swap_prep(
>  	 * exchange.
>  	 */
>  	if (ip_local) {
> -		struct xfs_ifork	*ifp;
> -
> -		ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
> -		xfs_idestroy_fork(ifp);
> -		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
> -		ifp->if_nextents = 0;
> -		ifp->if_bytes = 0;
> -		ifp->if_data = NULL;
> -		ifp->if_height = 0;
> -
> +		xrep_reset_fork_to_extents(sc, XFS_DATA_FORK);
>  		xfs_trans_log_inode(sc->tp, sc->ip,
>  				XFS_ILOG_CORE | XFS_ILOG_DDATA);
>  	}
> -- 
> 2.55.0
> 
> 

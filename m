Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FF719F137
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 11:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791457340; cv=none; b=V+kg9txZ1+GWQIH7XuD9jzcyhgtsywawoZTslMTeY/PfCh8FGFZw1vzf54r+xlXXHPc1CplUbZxyzcHw10Ajm6TQiJ/d3l1sTLtB22V1AKvjtmwCrn/qLfeCib1I0JYwf9Z2YuaQxzZeo4LAOq9gfh8mNUyaankLBFWhLz8ZQMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791457340; c=relaxed/simple;
	bh=YGSFJl/ueN8F+g+TD8aHT4SHW4SBDUh7/kv2PYc4//8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXangv4XJWeBlfFGvuDvK/zte5EdCw8Ee5sS4R913pxSXxi059MNl0bk4oqYxFCtzwo7yWupxobYQ9104IzLHlvEI/3YbCLJBaf0yBc1HDGfBI10Wxdn9Amaurhv+CdrNiBod4rDr+Gxy6Sw2sfj2jlD3/xchKD9b/WTGo7fUhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FkayS4YD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FkayS4YD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36AD1F000FF;
	Thu,  8 Oct 2026 11:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791457339;
	bh=to/oZ/dNn5h7Ff6oCxVvd5huragl7HzxlAgQ2JLouoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FkayS4YDGlGag3CXs56bF/+vsl+WaddxiWHKzEWSe4+6m/2zgH1yLXrHfYNKEPFfH
	 MXC4TALK2WLDa/1zhKeb1uGfc4z7OZghXnRiw6VUhTcNnZmtbrzwZ1tnYPaDcuxf0V
	 jLLblsTJbROxqrWwrR87NC49wZTddAoAnjqO2xHaNoMu24z8uhj4UdUIsGnBK7kjHs
	 WXDDo4XVL71hZDwZylHMKTA4h/l7U5aeY6iNPEYRz+RrZcwga4vqon6PO3ojjWnxvk
	 vHQylA5qQ1yMp58ZWnM1+ENhgB14ZjFYbUL/Zqinhjq2+FxwmJ+GoS548LPMarRTl0
	 iWHpNlzmCeZHw==
Date: Thu, 8 Oct 2026 13:02:15 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, 
	djwong@kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3 2/3] xfs: factor out xrep_reset_fork_to_extents helper
 for scrub/repair
Message-ID: <asd4BXMVIg9sQ0hO@cronus.toxiclabs.cc>
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-3-sandeen@redhat.com>
 <5a8c7689-492f-4119-a75f-5d5bb442786d@sandeen.net>
 <9c5ce463-c28e-4b71-ae32-7d42abcb87f8@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c5ce463-c28e-4b71-ae32-7d42abcb87f8@sandeen.net>

On Wed, Oct 07, 2026 at 10:25:21AM -0500, Eric Sandeen wrote:
> The open-coded 8-line series of steps to reset a fork to empty extents
> format is repeated 3 times; factor this out into a helper to eliminate
> cut and paste.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> V3: Ok, ok, fine - it's a switch now. Merge whatever you feel is best. :)
>     This V3 change is compile-tested only.

Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
>  fs/xfs/scrub/attr_repair.c    | 17 ++---------------
>  fs/xfs/scrub/dir_repair.c     | 16 ++--------------
>  fs/xfs/scrub/repair.c         | 31 +++++++++++++++++++++++++++++++
>  fs/xfs/scrub/repair.h         |  1 +
>  fs/xfs/scrub/symlink_repair.c | 16 ++--------------
>  5 files changed, 38 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
> index 387ad909e20b..46e6b2fe109a 100644
> --- a/fs/xfs/scrub/attr_repair.c
> +++ b/fs/xfs/scrub/attr_repair.c
> @@ -1319,21 +1319,8 @@ xrep_xattr_swap_prep(
>  	 * that to an empty extent list in preparation for the atomic mapping
>  	 * exchange.
>  	 */
> -	if (ip_local) {
> -		struct xfs_ifork	*ifp;
> -
> -		ifp = xfs_ifork_ptr(sc->ip, XFS_ATTR_FORK);
> -
> -		xfs_idestroy_fork(ifp);
> -		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
> -		ifp->if_nextents = 0;
> -		ifp->if_bytes = 0;
> -		ifp->if_data = NULL;
> -		ifp->if_height = 0;
> -
> -		xfs_trans_log_inode(sc->tp, sc->ip,
> -				XFS_ILOG_CORE | XFS_ILOG_ADATA);
> -	}
> +	if (ip_local)
> +		xrep_reset_fork_to_extents(sc, XFS_ATTR_FORK);
>  
>  	return 0;
>  }
> diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
> index 2cfcf1c35679..5db1ec324409 100644
> --- a/fs/xfs/scrub/dir_repair.c
> +++ b/fs/xfs/scrub/dir_repair.c
> @@ -1510,20 +1510,8 @@ xrep_dir_swap_prep(
>  	 * to an empty extent list in preparation for the atomic mapping
>  	 * exchange.
>  	 */
> -	if (ip_local) {
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
> -		xfs_trans_log_inode(sc->tp, sc->ip,
> -				XFS_ILOG_CORE | XFS_ILOG_DDATA);
> -	}
> +	if (ip_local)
> +		xrep_reset_fork_to_extents(sc, XFS_DATA_FORK);
>  
>  	return 0;
>  }
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 956aa75218aa..dd00d4ed8c17 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -882,6 +882,37 @@ xrep_ino_ensure_extent_count(
>  	return 0;
>  }
>  
> +/* Discard the contents of this fork and initialize as empty extent-format. */
> +void
> +xrep_reset_fork_to_extents(
> +	struct xfs_scrub	*sc,
> +	int			whichfork)
> +{
> +	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
> +	uint			ilog_flags = XFS_ILOG_CORE;
> +
> +	switch (whichfork) {
> +	case XFS_DATA_FORK:
> +		ilog_flags |= XFS_ILOG_DDATA;
> +		break;
> +	case XFS_ATTR_FORK:
> +		ilog_flags |= XFS_ILOG_ADATA;
> +		break;
> +	default:
> +		ASSERT(0);
> +		return;
> +	}
> +
> +	xfs_idestroy_fork(ifp);
> +	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
> +	ifp->if_nextents = 0;
> +	ifp->if_bytes = 0;
> +	ifp->if_data = NULL;
> +	ifp->if_height = 0;
> +
> +	xfs_trans_log_inode(sc->tp, sc->ip, ilog_flags);
> +}
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
> index 181961364233..9f6901905bfd 100644
> --- a/fs/xfs/scrub/symlink_repair.c
> +++ b/fs/xfs/scrub/symlink_repair.c
> @@ -303,20 +303,8 @@ xrep_symlink_swap_prep(
>  	 * to an empty extent list in preparation for the atomic mapping
>  	 * exchange.
>  	 */
> -	if (ip_local) {
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
> -		xfs_trans_log_inode(sc->tp, sc->ip,
> -				XFS_ILOG_CORE | XFS_ILOG_DDATA);
> -	}
> +	if (ip_local)
> +		xrep_reset_fork_to_extents(sc, XFS_DATA_FORK);
>  
>  	return 0;
>  }
> -- 
> 2.55.0
> 
> 

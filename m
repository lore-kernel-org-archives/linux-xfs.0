Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D7E4AD4C8
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 20:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791231661; cv=none; b=bsx4vOs03MFOld6Mq8h+cAMLkqEQbWlRsBgm6sMu7OKdOdGShA2e3IaywxsIyfEyBnJfzJCH0Rb2OUpvDONtEbdB/elSsF67/1A6cLZ0s728ae6OQojg4oAAm+UxrkFsjd2yEfnGWQ9RY0qhLk0LPw51bDmP76/UeT4lbFRnmzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791231661; c=relaxed/simple;
	bh=c67/KZBZAupk17+iPWu7YQrNehzs1HbK/y4z6DGTJi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+quKEB/VJ0wkjvpNFTBpM9fVjzScETFvhaOmL/+sWdDCdjpH0dz+td05YKul2nT7PD4LLw5SqF8GGzvR0Wu2kUVnuDHV+YchGA46KS9Q6SvIYKReeeNu/t4ZGvY8v5CaL/UDhXjMM+aP4niyPkMrbudqNwg6tLPb+KnVWNcWyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mmqh+uxz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mmqh+uxz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9FFA71F000FF;
	Mon,  5 Oct 2026 20:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791231659;
	bh=IGDBDCDaNDILVwDGKoyGpszQzpUOJtX+m1xwf/Mh/aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mmqh+uxzs1V6WC5oMJyF547IUSE2aoeuSaGNxdr2FAeNPYCECAGfkJh4K7vUX0ne2
	 /4jj/uodzd9YlLtnB31vTZIIsxVir8g9bIISyvy4HH4vGru5Bf3zS6x9ue1H5uZZyY
	 k6kKbnxgB9Ki/wuF66UE4a5HeBuUipIuvcGYBz1/z88GuYH1N5bsYOonB3XMwp7y4d
	 RQFP8jEgxgn7YPe8VwI/o7tPk1lbhjZ6jj0xGXQivwae6jC0pmbmoeJityXxgDC2TN
	 bbrjYBVzOONDgpdMd1bdAOUYQoBoeLvOnMOpKNfPYwdPR2gi+30ayccFPM1p1dzPr6
	 1SkYYYJ0m9e4A==
Date: Mon, 5 Oct 2026 13:20:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [PATCH V2 2/3] xfs: factor out xrep_reset_fork_to_extents helper
 for scrub/repair
Message-ID: <20261005202059.GD2705364@frogsfrogsfrogs>
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-3-sandeen@redhat.com>
 <5a8c7689-492f-4119-a75f-5d5bb442786d@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a8c7689-492f-4119-a75f-5d5bb442786d@sandeen.net>

On Mon, Oct 05, 2026 at 02:11:37PM -0500, Eric Sandeen wrote:
> The open-coded ~10 line series of steps to reset a fork to empty extents
> format is repeated 3 times; factor this out into a helper to eliminate
> cut and paste.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Better? (nb: compile tested only)
> 
>  fs/xfs/scrub/attr_repair.c    | 17 ++---------------
>  fs/xfs/scrub/dir_repair.c     | 16 ++--------------
>  fs/xfs/scrub/repair.c         | 26 ++++++++++++++++++++++++++
>  fs/xfs/scrub/repair.h         |  1 +
>  fs/xfs/scrub/symlink_repair.c | 16 ++--------------
>  5 files changed, 33 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
> index 28f92e9ba72b..25bf4e49d56c 100644
> --- a/fs/xfs/scrub/attr_repair.c
> +++ b/fs/xfs/scrub/attr_repair.c
> @@ -1316,21 +1316,8 @@ xrep_xattr_swap_prep(
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
> index c2a437416227..8385308c852f 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -882,6 +882,32 @@ xrep_ino_ensure_extent_count(
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
> +	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
> +
> +	if (whichfork == XFS_DATA_FORK)
> +		ilog_flags |= XFS_ILOG_DDATA;
> +	else
> +		ilog_flags |= XFS_ILOG_ADATA;

Nit pick:

	switch (whichfork) {
	case XFS_DATA_FORK:
		ilog_flags |= XFS_ILOG_DDATA;
		break;
	case XFS_ATTR_FORK:
		ilog_flags |= XFS_ILOG_ADATA;
		break;
	default:
		ASSERT(0);
		return;
	}

Either way this looks like a good hoist to me, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

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

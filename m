Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0A013AD1C
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 14:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752591580; cv=none; b=HNFlXx4Ppqhq/IPUIfQF16+2AcK33JMMWpMg9MoOmE+r669VGyeE6ZzTNuJnGiMWWCdAWVAoBa3HiY7pZLJmJL/ZyG8wrlomTC41qGco50b4+HwDe1dpgsx+RO7wz3VxAJjhE+pEy/K0fcGqWznXoLA8CmfodyzIfYCBqB/AUR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752591580; c=relaxed/simple;
	bh=/+g4DfICGnrbpe5woP4Jzn+K7kXzygXYdJ9rO9s1a1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEdLDKkT9zaEePveSXxY8MXMOYSGQc4ithoE9AZCKVY64tq9/QxBo27fjdXjFcAwDjfSfeZGV++Jr/6kSImbHrnx1115EWLgGn0Eq5Em3NWReNFPV3C7rxIiBcHGGm6i4POzVdGjSHE5DYZNhmNeONdJMNOn31/yv/74/Z25I5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sVn3GR/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sVn3GR/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D47C4CEE3;
	Tue, 15 Jul 2025 14:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752591579;
	bh=/+g4DfICGnrbpe5woP4Jzn+K7kXzygXYdJ9rO9s1a1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sVn3GR/7puyKpSoSOsDTk+E0FGkHdDW72RN3vA5ng8BoOY2u98OnqwMIctYdD+k6X
	 naG1GRZzUb8L5uimggyzEPN0YqEJcExGMSOP6JKyImeUgFdeZ4E44okJzjafsMBR30
	 sGW5HllpC+m1X4aVSsFToTowtVkOwzvZJaA3fUYJfpRff60bXElXMr5Z67IxoGk2Sw
	 0AN0kP9DMIR7H5cdjqmgY2BxwYU41LTt9vYZZ0LCMgN0oxNzNVCame3Th6PqPn4rj3
	 bIzDZXrHDo+1TTkYijELtoUwo7B9PjCg3LckStgS2qu0AqZAk4QKbEJfi3BrUHRxYB
	 k815T/slGWILQ==
Date: Tue, 15 Jul 2025 07:59:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: return the allocated transaction from
 xchk_trans_alloc_empty
Message-ID: <20250715145938.GY2672049@frogsfrogsfrogs>
References: <20250715122544.1943403-1-hch@lst.de>
 <20250715122544.1943403-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715122544.1943403-7-hch@lst.de>

On Tue, Jul 15, 2025 at 02:25:39PM +0200, Christoph Hellwig wrote:
> xchk_trans_alloc_empty can't return errors, so return the allocated
> transaction directly instead of an output double pointer argument.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/common.c        |  6 +++---
>  fs/xfs/scrub/common.h        |  2 +-
>  fs/xfs/scrub/dir_repair.c    |  8 ++------
>  fs/xfs/scrub/fscounters.c    |  3 ++-
>  fs/xfs/scrub/metapath.c      |  4 +---
>  fs/xfs/scrub/nlinks.c        |  8 ++------
>  fs/xfs/scrub/nlinks_repair.c |  4 +---
>  fs/xfs/scrub/parent_repair.c | 12 +++---------
>  fs/xfs/scrub/quotacheck.c    |  4 +---
>  fs/xfs/scrub/rmap_repair.c   |  4 +---
>  fs/xfs/scrub/rtrmap_repair.c |  4 +---
>  11 files changed, 18 insertions(+), 41 deletions(-)

Moar yaaaay,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index d080f4e6e9d8..2ef7742be7d3 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -866,12 +866,11 @@ xchk_trans_cancel(
>  	sc->tp = NULL;
>  }
>  
> -int
> +void
>  xchk_trans_alloc_empty(
>  	struct xfs_scrub	*sc)
>  {
>  	sc->tp = xfs_trans_alloc_empty(sc->mp);
> -	return 0;
>  }
>  
>  /*
> @@ -893,7 +892,8 @@ xchk_trans_alloc(
>  		return xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
>  				resblks, 0, 0, &sc->tp);
>  
> -	return xchk_trans_alloc_empty(sc);
> +	xchk_trans_alloc_empty(sc);
> +	return 0;
>  }
>  
>  /* Set us up with a transaction and an empty context. */
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index 19877d99f255..ddbc065c798c 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -7,7 +7,7 @@
>  #define __XFS_SCRUB_COMMON_H__
>  
>  int xchk_trans_alloc(struct xfs_scrub *sc, uint resblks);
> -int xchk_trans_alloc_empty(struct xfs_scrub *sc);
> +void xchk_trans_alloc_empty(struct xfs_scrub *sc);
>  void xchk_trans_cancel(struct xfs_scrub *sc);
>  
>  bool xchk_process_error(struct xfs_scrub *sc, xfs_agnumber_t agno,
> diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
> index 249313882108..8d3b550990b5 100644
> --- a/fs/xfs/scrub/dir_repair.c
> +++ b/fs/xfs/scrub/dir_repair.c
> @@ -1289,9 +1289,7 @@ xrep_dir_scan_dirtree(
>  	if (sc->ilock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL))
>  		xchk_iunlock(sc, sc->ilock_flags & (XFS_ILOCK_SHARED |
>  						    XFS_ILOCK_EXCL));
> -	error = xchk_trans_alloc_empty(sc);
> -	if (error)
> -		return error;
> +	xchk_trans_alloc_empty(sc);
>  
>  	while ((error = xchk_iscan_iter(&rd->pscan.iscan, &ip)) == 1) {
>  		bool		flush;
> @@ -1317,9 +1315,7 @@ xrep_dir_scan_dirtree(
>  			if (error)
>  				break;
>  
> -			error = xchk_trans_alloc_empty(sc);
> -			if (error)
> -				break;
> +			xchk_trans_alloc_empty(sc);
>  		}
>  
>  		if (xchk_should_terminate(sc, &error))
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 9b598c5790ad..cebd0d526926 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -237,7 +237,8 @@ xchk_setup_fscounters(
>  			return error;
>  	}
>  
> -	return xchk_trans_alloc_empty(sc);
> +	xchk_trans_alloc_empty(sc);
> +	return 0;
>  }
>  
>  /*
> diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
> index e21c16fbd15d..14939d7de349 100644
> --- a/fs/xfs/scrub/metapath.c
> +++ b/fs/xfs/scrub/metapath.c
> @@ -318,9 +318,7 @@ xchk_metapath(
>  		return 0;
>  	}
>  
> -	error = xchk_trans_alloc_empty(sc);
> -	if (error)
> -		return error;
> +	xchk_trans_alloc_empty(sc);
>  
>  	error = xchk_metapath_ilock_both(mpath);
>  	if (error)
> diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
> index 4a47d0aabf73..26721fab5cab 100644
> --- a/fs/xfs/scrub/nlinks.c
> +++ b/fs/xfs/scrub/nlinks.c
> @@ -555,9 +555,7 @@ xchk_nlinks_collect(
>  	 * do not take sb_internal.
>  	 */
>  	xchk_trans_cancel(sc);
> -	error = xchk_trans_alloc_empty(sc);
> -	if (error)
> -		return error;
> +	xchk_trans_alloc_empty(sc);
>  
>  	while ((error = xchk_iscan_iter(&xnc->collect_iscan, &ip)) == 1) {
>  		if (S_ISDIR(VFS_I(ip)->i_mode))
> @@ -880,9 +878,7 @@ xchk_nlinks_compare(
>  	 * inactivation workqueue.
>  	 */
>  	xchk_trans_cancel(sc);
> -	error = xchk_trans_alloc_empty(sc);
> -	if (error)
> -		return error;
> +	xchk_trans_alloc_empty(sc);
>  
>  	/*
>  	 * Use the inobt to walk all allocated inodes to compare the link
> diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
> index 4ebdee095428..6ef2ee9c3814 100644
> --- a/fs/xfs/scrub/nlinks_repair.c
> +++ b/fs/xfs/scrub/nlinks_repair.c
> @@ -340,9 +340,7 @@ xrep_nlinks(
>  		 * We can only push the inactivation workqueues with an empty
>  		 * transaction.
>  		 */
> -		error = xchk_trans_alloc_empty(sc);
> -		if (error)
> -			break;
> +		xchk_trans_alloc_empty(sc);
>  	}
>  	xchk_iscan_iter_finish(&xnc->compare_iscan);
>  	xchk_iscan_teardown(&xnc->compare_iscan);
> diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
> index 31bfe10be22a..2949feda6271 100644
> --- a/fs/xfs/scrub/parent_repair.c
> +++ b/fs/xfs/scrub/parent_repair.c
> @@ -569,9 +569,7 @@ xrep_parent_scan_dirtree(
>  	if (sc->ilock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL))
>  		xchk_iunlock(sc, sc->ilock_flags & (XFS_ILOCK_SHARED |
>  						    XFS_ILOCK_EXCL));
> -	error = xchk_trans_alloc_empty(sc);
> -	if (error)
> -		return error;
> +	xchk_trans_alloc_empty(sc);
>  
>  	while ((error = xchk_iscan_iter(&rp->pscan.iscan, &ip)) == 1) {
>  		bool		flush;
> @@ -597,9 +595,7 @@ xrep_parent_scan_dirtree(
>  			if (error)
>  				break;
>  
> -			error = xchk_trans_alloc_empty(sc);
> -			if (error)
> -				break;
> +			xchk_trans_alloc_empty(sc);
>  		}
>  
>  		if (xchk_should_terminate(sc, &error))
> @@ -1099,9 +1095,7 @@ xrep_parent_flush_xattrs(
>  	xrep_tempfile_iounlock(rp->sc);
>  
>  	/* Recreate the empty transaction and relock the inode. */
> -	error = xchk_trans_alloc_empty(rp->sc);
> -	if (error)
> -		return error;
> +	xchk_trans_alloc_empty(rp->sc);
>  	xchk_ilock(rp->sc, XFS_ILOCK_EXCL);
>  	return 0;
>  }
> diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
> index dc4033b91e44..e4105aaafe84 100644
> --- a/fs/xfs/scrub/quotacheck.c
> +++ b/fs/xfs/scrub/quotacheck.c
> @@ -505,9 +505,7 @@ xqcheck_collect_counts(
>  	 * transactions do not take sb_internal.
>  	 */
>  	xchk_trans_cancel(sc);
> -	error = xchk_trans_alloc_empty(sc);
> -	if (error)
> -		return error;
> +	xchk_trans_alloc_empty(sc);
>  
>  	while ((error = xchk_iscan_iter(&xqc->iscan, &ip)) == 1) {
>  		error = xqcheck_collect_inode(xqc, ip);
> diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
> index f5f73078ffe2..bf1e632b449a 100644
> --- a/fs/xfs/scrub/rmap_repair.c
> +++ b/fs/xfs/scrub/rmap_repair.c
> @@ -951,9 +951,7 @@ xrep_rmap_find_rmaps(
>  	sa->agf_bp = NULL;
>  	sa->agi_bp = NULL;
>  	xchk_trans_cancel(sc);
> -	error = xchk_trans_alloc_empty(sc);
> -	if (error)
> -		return error;
> +	xchk_trans_alloc_empty(sc);
>  
>  	/* Iterate all AGs for inodes rmaps. */
>  	while ((error = xchk_iscan_iter(&rr->iscan, &ip)) == 1) {
> diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
> index fc2592c53af5..4a56726d9952 100644
> --- a/fs/xfs/scrub/rtrmap_repair.c
> +++ b/fs/xfs/scrub/rtrmap_repair.c
> @@ -580,9 +580,7 @@ xrep_rtrmap_find_rmaps(
>  	 */
>  	xchk_trans_cancel(sc);
>  	xchk_rtgroup_unlock(&sc->sr);
> -	error = xchk_trans_alloc_empty(sc);
> -	if (error)
> -		return error;
> +	xchk_trans_alloc_empty(sc);
>  
>  	while ((error = xchk_iscan_iter(&rr->iscan, &ip)) == 1) {
>  		error = xrep_rtrmap_scan_inode(rr, ip);
> -- 
> 2.47.2
> 
> 

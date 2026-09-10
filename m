Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB963A6EEC;
	Thu, 10 Sep 2026 07:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789025759; cv=none; b=jqzvt6ynSP1G2kmBgQLHcl7sHFpMzfc3eLKYYDlncnxFjyHWAOs7tE3SsUb9U8SYWIhw/9HmJpZDH0dVc/YDB9dlQTqWEnPjzqCZX4kIRhyzSg1Pk2RS7T20ZRMaDoqQdE/UMbQyu+wJLPoPxgtMgOP91zUji0etEh1eWFAKxP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789025759; c=relaxed/simple;
	bh=XLNJaXK1FIsauG2KyfOx/YhXcciYHklhsHku0fak/YU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqptZgACJd/8t9tz0ZNAaU0Wx9XuTkaanGlTnNYt5nZus3gsPet8KGnlEYD8bg9hH9FnZSe2naL5pj7/1uv8yEWt7pRkr6Frj9sOEmot+FdaYV4C61cNqKHoSgjQXxBbqfQbBkfcln+kAGBq03Gw46kPEC311JJ/KbCf8uKlH4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PONztaQW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PONztaQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658EB1F00898;
	Thu, 10 Sep 2026 07:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789025754;
	bh=p+pbGKdMXltzn8OfCPyfczxGn/IqQcScoPepku4Q24k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PONztaQWEhXdu5WOVV+fk4pzadATtiSSj+aQ1sHi4qSDM1Lu/vSkWE4V9B4LqInYl
	 EjGtN0TupaOSXUgcG+WomWrqfSw2CE8O1DkTJH+f6B+/xL6i+eApN520MDLHBBL4Y0
	 roani7ZuDsEkwnpWtuMwiZ0n4cs+P+M2XZzgq50MXbDGHTSIDu5Cx/Ab/Hjz7IbEpB
	 Ub9HrZOyONLmeJEe/sr7fIwqZ+vVPOhYQnVEpcTLxNvUaBDZ+sxSpuu3kbKXNzoFnD
	 pmRjw+4uhDSZxQHKS+YjH/nsgcgYkLsQFwvBoEniGqSVoIIXgXCebA9RdL+gNzsiHk
	 fscIut/xRKWDQ==
Date: Thu, 10 Sep 2026 09:35:48 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: advance the findparent inode scan cursor while
 holding ILOCK
Message-ID: <aqJdzuFlmlpjFKSV@andromeda.toxiclabs.cc>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
 <178892936771.4057962.16778990010632981835.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936771.4057962.16778990010632981835.stgit@frogsfrogsfrogs>

On Tue, Sep 08, 2026 at 11:06:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM pointed out a race condition in xrep_findparent_scan -- the
> directory live update hook holds the directory ILOCK when it calls the
> xchk_iscan_want_live_update predicate to figure out if it needs to
> remember the live update, but xrep_findparent_scan drops the directory
> ILOCK before advancing the cursor.  Therefore, it's possible for a live
> update to check the scan cursor after the scan drops the ILOCK but
> before the scan updates its cursor.  If this happens, we'll fail to
> record the live update.  Fix this by moving the cursor update logic
> inside xrep_findparent_walk_directory.
> 
> Note that for non-directories it's ok to advance the cursor without
> holding any ILOCK because the findparent scan only cares about directory
> parents, not the children.
> 
> Cc: <stable@vger.kernel.org> # v6.10
> Fixes: a07b45576264e7 ("xfs: scan the filesystem to repair a directory dotdot entry")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


>  fs/xfs/scrub/findparent.c |   54 ++++++++++++++++++++++++++++++---------------
>  1 file changed, 36 insertions(+), 18 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
> index 04b6b96b0a30ed..eab3ac2704befe 100644
> --- a/fs/xfs/scrub/findparent.c
> +++ b/fs/xfs/scrub/findparent.c
> @@ -139,32 +139,52 @@ xrep_findparent_dirent(
>  	return 0;
>  }
>  
> -/*
> - * If this is a directory, walk the dirents looking for any that point to the
> - * scrub target inode.
> - */
> -STATIC int
> -xrep_findparent_walk_directory(
> -	struct xrep_findparent_info	*fpi)
> +static inline bool
> +xrep_findparent_want_scan_file(
> +	const struct xrep_findparent_info	*fpi)
>  {
> -	struct xfs_scrub		*sc = fpi->sc;
> -	struct xfs_inode		*dp = fpi->dp;
> -	unsigned int			lock_mode;
> -	int				error = 0;
> +	const struct xfs_scrub			*sc = fpi->sc;
> +	const struct xfs_inode			*dp = fpi->dp;
> +
> +	/* Only directories can be parents */
> +	if (!S_ISDIR(VFS_IC(dp)->i_mode))
> +		return false;
>  
>  	/*
>  	 * The inode being scanned cannot be its own parent, nor can any
>  	 * temporary directory we created to stage this repair.
>  	 */
>  	if (dp == sc->ip || dp == sc->tempip)
> -		return 0;
> +		return false;
>  
>  	/*
>  	 * Similarly, temporary files created to stage a repair cannot be the
>  	 * parent of this inode.
>  	 */
>  	if (xrep_is_tempfile(dp))
> +		return false;
> +
> +	return true;
> +}
> +
> +/*
> + * If this is a directory, walk the dirents looking for any that point to the
> + * scrub target inode.
> + */
> +STATIC int
> +xrep_findparent_walk_file(
> +	struct xrep_findparent_info	*fpi)
> +{
> +	struct xfs_scrub		*sc = fpi->sc;
> +	struct xfs_inode		*dp = fpi->dp;
> +	unsigned int			lock_mode;
> +	int				error = 0;
> +
> +	if (!xrep_findparent_want_scan_file(fpi)) {
> +		if (fpi->parent_scan)
> +			xchk_iscan_mark_visited(&fpi->parent_scan->iscan, dp);
>  		return 0;
> +	}
>  
>  	/*
>  	 * Scan the directory to see if there it contains an entry pointing to
> @@ -201,6 +221,8 @@ xrep_findparent_walk_directory(
>  		goto out_unlock;
>  
>  out_unlock:
> +	if (fpi->parent_scan)
> +		xchk_iscan_mark_visited(&fpi->parent_scan->iscan, dp);
>  	xfs_iunlock(dp, lock_mode);
>  	return error;
>  }
> @@ -308,11 +330,7 @@ xrep_findparent_scan(
>  	ASSERT(S_ISDIR(VFS_IC(sc->ip)->i_mode));
>  
>  	while ((ret = xchk_iscan_iter(&pscan->iscan, &fpi.dp)) == 1) {
> -		if (S_ISDIR(VFS_I(fpi.dp)->i_mode))
> -			ret = xrep_findparent_walk_directory(&fpi);
> -		else
> -			ret = 0;
> -		xchk_iscan_mark_visited(&pscan->iscan, fpi.dp);
> +		ret = xrep_findparent_walk_file(&fpi);
>  		xchk_irele(sc, fpi.dp);
>  		if (ret)
>  			break;
> @@ -401,7 +419,7 @@ xrep_findparent_confirm(
>  		goto out_rele;
>  	}
>  
> -	error = xrep_findparent_walk_directory(&fpi);
> +	error = xrep_findparent_walk_file(&fpi);
>  	if (error)
>  		goto out_rele;
>  
> 
> 

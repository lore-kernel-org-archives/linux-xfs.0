Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1752C11DF
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 19:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758222753; cv=none; b=Tms/GD/1iOfSAdrOsLRObAgvE0RBJBONBFvuODcVbq2o4bTI+Mm2aVXWV2asp5Yl3BcEy9tMsrgWM3Mr71ZL0W2tX/Ais4jd8A4kTU22+LxLTrsHIea3j8U3rJgWMeVNWJr6BCHL0zAa3eozfzFPwqOz72Ny/lcU0KCchp84kBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758222753; c=relaxed/simple;
	bh=GgouXcSNBO1NGQ+h9v7VZ91ePEevFwcOTLCT00eSFD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeEBwivwVSPfTKZn2nYnNDx0cXGn9wXfpfhLmD2wzf2Sdtyr4h920/bOXUok6u0RQMl4ElmNFRPjrHx/nJRRSWIzE34vhi2b45hNPtROQEJLETUF3vRiEAw724wXftSVWlsNV9bJcLKJwFfpqal/MoHBl5PV08eHgxXulurlS0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cYxYCONr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cYxYCONr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166B3C4CEE7;
	Thu, 18 Sep 2025 19:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758222753;
	bh=GgouXcSNBO1NGQ+h9v7VZ91ePEevFwcOTLCT00eSFD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cYxYCONryiKoS+D491U7PtYEMlC5Ln/0eCOxWrQxJOr3GbvE+B8w7KIdy/LdNweaF
	 oDNFUxtZjSm3q4PBzER5UCxC+aUhzJpB0YMN3FZyW+HZE84HcgNLM50u610Wd4wnuB
	 FB6ONarHC/1YYvBN7uvNZ83OQD8PeFBxRh0MOHIa5bm9N+1AxLgPTJnGelX1bX5xaD
	 +ysx+OMJzFtiDDv7jODq1YDHElDiS5ulcEaIauawi105m3DqYOHUh1JG1Xmx6dY95E
	 2shmg8WD33F6/pQXXnQ6wV7qP2hfoQi/Gt39tdn+giNavMB0/NSIq5QsozLkKFs9CA
	 Sfa/LiSRJUiFA==
Date: Thu, 18 Sep 2025 12:12:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: scrub: use kstrdup_const() for metapath scan setups
Message-ID: <20250918191232.GJ8096@frogsfrogsfrogs>
References: <20250918111403.1169904-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918111403.1169904-1-dmantipov@yandex.ru>

On Thu, Sep 18, 2025 at 02:14:03PM +0300, Dmitry Antipov wrote:
> Except 'xchk_setup_metapath_rtginode()' case, 'path' argument of
> 'xchk_setup_metapath_scan()' is a compile-time constant. So it may
> be reasonable to use 'kstrdup_const()' / 'kree_const()' to manage
> 'path' field of 'struct xchk_metapath' in attempt to reuse .rodata
> instance rather than making a copy. Compile tested only.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

I guess that works...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/metapath.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
> index 14939d7de349..378ec7c8d38e 100644
> --- a/fs/xfs/scrub/metapath.c
> +++ b/fs/xfs/scrub/metapath.c
> @@ -79,7 +79,7 @@ xchk_metapath_cleanup(
>  
>  	if (mpath->dp_ilock_flags)
>  		xfs_iunlock(mpath->dp, mpath->dp_ilock_flags);
> -	kfree(mpath->path);
> +	kfree_const(mpath->path);
>  }
>  
>  /* Set up a metadir path scan.  @path must be dynamically allocated. */
> @@ -98,13 +98,13 @@ xchk_setup_metapath_scan(
>  
>  	error = xchk_install_live_inode(sc, ip);
>  	if (error) {
> -		kfree(path);
> +		kfree_const(path);
>  		return error;
>  	}
>  
>  	mpath = kzalloc(sizeof(struct xchk_metapath), XCHK_GFP_FLAGS);
>  	if (!mpath) {
> -		kfree(path);
> +		kfree_const(path);
>  		return -ENOMEM;
>  	}
>  
> @@ -132,7 +132,7 @@ xchk_setup_metapath_rtdir(
>  		return -ENOENT;
>  
>  	return xchk_setup_metapath_scan(sc, sc->mp->m_metadirip,
> -			kasprintf(GFP_KERNEL, "rtgroups"), sc->mp->m_rtdirip);
> +			kstrdup_const("rtgroups", GFP_KERNEL), sc->mp->m_rtdirip);
>  }
>  
>  /* Scan a rtgroup inode under the /rtgroups directory. */
> @@ -179,7 +179,7 @@ xchk_setup_metapath_quotadir(
>  		return -ENOENT;
>  
>  	return xchk_setup_metapath_scan(sc, sc->mp->m_metadirip,
> -			kstrdup("quota", GFP_KERNEL), qi->qi_dirip);
> +			kstrdup_const("quota", GFP_KERNEL), qi->qi_dirip);
>  }
>  
>  /* Scan a quota inode under the /quota directory. */
> @@ -212,7 +212,7 @@ xchk_setup_metapath_dqinode(
>  		return -ENOENT;
>  
>  	return xchk_setup_metapath_scan(sc, qi->qi_dirip,
> -			kstrdup(xfs_dqinode_path(type), GFP_KERNEL), ip);
> +			kstrdup_const(xfs_dqinode_path(type), GFP_KERNEL), ip);
>  }
>  #else
>  # define xchk_setup_metapath_quotadir(...)	(-ENOENT)
> -- 
> 2.51.0
> 
> 

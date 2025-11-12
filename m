Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD8224BC07
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 18:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762973590; cv=none; b=lRaPCgbb5cnsKTuIkPhfrb/DsItT1qZ8dBOP1dMCM+tIcQoX7oZMPSqbSz+rDEODcll0Vf1VhU0fEJ+ARIPHcRsfBZlF4vt+OZh1eI0jsz3SgMTzivLn3Pakdmg+FtJZF4ssQcyZHKGXcIF8hjmqFcEMK+qwpQUXbI0m3HJ8d+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762973590; c=relaxed/simple;
	bh=9OKw2YrOvT9RNvdcEggdThD+Cqt87zpfNaBpLsXBcMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqaDlUFaS3+zCqLT8fCJqxqcvqY7fXFdoncDkz6NWzdXrMc3182t+F6k2I4qjnS/h4iUwzCq74SmizpWR2wo9cg0KCBNVACkirYK2+ceeGGTvdkYc9giCNFgoZt01ELIak9WkEcNbu5ncd6VOZt4nv45hlmk2A2Hkgvl4C3clX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iq8ZyxKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iq8ZyxKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B007BC19421;
	Wed, 12 Nov 2025 18:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762973588;
	bh=9OKw2YrOvT9RNvdcEggdThD+Cqt87zpfNaBpLsXBcMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iq8ZyxKEd8ifkGtvyo8+57wD0/z8D9geDk4VvAK+N6j//Le2vhmiok5u5aOHD2zDS
	 JmEbFOwcVfVhi6h1sDHj9LrHpR8/WZ8n3YP1sVkSNhG3dZ4I0OqRtapODMMWzWzevC
	 XJqXl0vaWeuzqZ5IzlYxoTP6G8G+MbcXy7ZDDK+3wmaxrQIiJfWNHbJOvKwqh3Xo9D
	 e0rb86H8o03v/UH6qvTTfxiay41yjDrmqEigHgwPLijYQvCK6GYB9CSNfInJr/J4oA
	 HbIu5khi4Z5pv3ptpP/Nvrxwed6yMzpCwn7RS0MP0B8P6+mKY7j2EN5UIZ271Mbk9U
	 RtlGpvHSuiSXw==
Date: Wed, 12 Nov 2025 10:53:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Alexander Monakov <amonakov@ispras.ru>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db rdump: remove sole_path logic
Message-ID: <20251112185308.GB196370@frogsfrogsfrogs>
References: <20251112151932.12141-1-amonakov@ispras.ru>
 <20251112151932.12141-2-amonakov@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112151932.12141-2-amonakov@ispras.ru>

On Wed, Nov 12, 2025 at 06:19:31PM +0300, Alexander Monakov wrote:
> Eliminate special handling of the case where rdump'ing one directory
> does not create the corresponding directory in the destination, but
> instead modifies the destination's attributes and creates children
> alongside the pre-existing children.

It sounds like what happened is that you ran rdump with a non-empty
destdir, only to have rdump mutate the existing children in that
directory.  Is that correct?

If so, then I think what you really wanted was for rdump to check for
that and error out, unless explicit --overwrite permission had been
granted.  Because...

> This can be a trap for the unwary (the effect on attributes can be
> particularly surprising and non-trivial to undo), and, in general, fewer
> special cases in such a low-level tool should be desirable.

...I use this "special case" and don't understand why you decided that
removing functionality was the solution here.  This is a filesystem
debugger, there are weird functions and sharp edges everywhere.

--D

> Signed-off-by: Alexander Monakov <amonakov@ispras.ru>
> ---
>  db/rdump.c        | 19 ++-----------------
>  man/man8/xfs_db.8 |  8 +-------
>  2 files changed, 3 insertions(+), 24 deletions(-)
> 
> diff --git a/db/rdump.c b/db/rdump.c
> index 9ff83355..73295dbe 100644
> --- a/db/rdump.c
> +++ b/db/rdump.c
> @@ -852,7 +852,6 @@ rdump_file(
>  static int
>  rdump_path(
>  	struct xfs_mount	*mp,
> -	bool			sole_path,
>  	const char		*path,
>  	const struct destdir	*destdir)
>  {
> @@ -890,20 +889,6 @@ rdump_path(
>  			dbprintf(_("%s: %s\n"), path, strerror(ret));
>  			return 1;
>  		}
> -
> -		if (sole_path) {
> -			struct xfs_dinode	*dip = iocur_top->data;
> -
> -			/*
> -			 * If this is the only path to copy out and it's a dir,
> -			 * then we can copy the children directly into the
> -			 * target.
> -			 */
> -			if (S_ISDIR(be16_to_cpu(dip->di_mode))) {
> -				pbuf->len = 0;
> -				pbuf->path[0] = 0;
> -			}
> -		}
>  	} else {
>  		set_cur_inode(mp->m_sb.sb_rootino);
>  	}
> @@ -980,7 +965,7 @@ rdump_f(
>  	if (optind == argc - 1) {
>  		/* no dirs given, just do the whole fs */
>  		push_cur();
> -		ret = rdump_path(mp, false, "", &destdir);
> +		ret = rdump_path(mp, "", &destdir);
>  		pop_cur();
>  		if (ret)
>  			exitcode = 1;
> @@ -996,7 +981,7 @@ rdump_f(
>  		argv[i][len] = 0;
>  
>  		push_cur();
> -		ret = rdump_path(mp, argc == optind + 2, argv[i], &destdir);
> +		ret = rdump_path(mp, argv[i], &destdir);
>  		pop_cur();
>  
>  		if (ret) {
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 1e85aebb..920b2b3e 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -1147,13 +1147,7 @@ the filesystem as possible.
>  If zero
>  .B paths
>  are specified, the entire filesystem is dumped.
> -If only one
> -.B path
> -is specified and it is a directory, the children of that directory will be
> -copied directly to the destination.
> -If multiple
> -.B paths
> -are specified, each file is copied into the directory as a new child.
> +Otherwise, each entry is copied into the destination as a new child.
>  
>  If possible, sparse holes, xfs file attributes, and extended attributes will be
>  preserved.
> -- 
> 2.51.0
> 
> 

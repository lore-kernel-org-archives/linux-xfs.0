Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9791512D1F6
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 23:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715298065; cv=none; b=HWObxVmkEyxxWm0sdZbXsu260zw8NKOAUCq0dRbBqYimNlonp5MR91nYYrjNkIgHVuXP0xitceCCWGDZRL+rP8SmLsK7J7nNsS5q6anrVDaVsUgkMq19QPgnV7leaapvguKKmdjLquRfohyUcBoZaJsRAIHLwKMgHMe2i4LXmUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715298065; c=relaxed/simple;
	bh=zQ2oSuFyNQWqbgGgZAdzkKU76p8OjtnfUarzqeCbDtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b1qIVMj4b6G3Xmzad0nre42bCVjoIUJDhbYAEzSIsylej5YHmIDt/DzsNV6D4I3Vb/YVuadFxJ9NWRy63GIdYTX9+GBM/yfLLL+TrMxxQJMaITmPkWV7rTs4iY2oXfZIVMcELlZGGf25v4J44OGzDhZO/bJv0xJNUCayIQgQGCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mhRGzGQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mhRGzGQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2676AC116B1;
	Thu,  9 May 2024 23:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715298065;
	bh=zQ2oSuFyNQWqbgGgZAdzkKU76p8OjtnfUarzqeCbDtM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mhRGzGQKj/3OfAD1pT99ofZlG7bioC1T9j9yrhT0XBU7O8ztdLTxEfZK+7H3czaGs
	 fYpgpqgZueYHKF6bdaFGIiWT29MfvTCSkKvMlvEB94M1IssW2TkoCGDrIfQbK9Au7F
	 160A6NVPk61UGeeMpOQh0lOrvub5naPAeXJij54E0GlrwUqWxXOqFQvzJOyPODX6H3
	 pysF73WZDkEZYUiI5G8cekfkLGyTsaEOVuFciQew2+dsBVNLNOYdldttWvxXQx1bSt
	 OWdAlldE1BEWRn+4f0i0+4D5q3On7mtYQb3HjeQL5KtvaXrwPi5FfLfq9zIwFOq/JM
	 yChBuwfT6DIJg==
Date: Thu, 9 May 2024 16:41:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs/quota: utilize XFS_IOC_SETFSXATTRAT to set prjid
 on special files
Message-ID: <20240509234104.GU360919@frogsfrogsfrogs>
References: <20240509151714.3623695-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509151714.3623695-2-aalbersh@redhat.com>

On Thu, May 09, 2024 at 05:17:15PM +0200, Andrey Albershteyn wrote:
> Utilize new XFS ioctl to set project ID on special files.
> Previously, special files were skipped due to lack of the way to
> call FS_IOC_SETFSXATTR on them. The quota accounting was therefore
> missing a few inodes (special files created before project setup).
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  libxfs/xfs_fs.h |  11 ++++
>  quota/project.c | 139 +++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 144 insertions(+), 6 deletions(-)
> 
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 6360073865db..1a560dfa7e15 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -662,6 +662,15 @@ typedef struct xfs_swapext
>  	struct xfs_bstat sx_stat;	/* stat of target b4 copy */
>  } xfs_swapext_t;
>  
> +/*
> + * Structure passed to XFS_IOC_GETFSXATTRAT/XFS_IOC_GETFSXATTRAT
> + */
> +struct xfs_xattrat_req {
> +	struct fsxattr	__user *fsx;		/* XATTR to get/set */
> +	__u32		dfd;			/* parent dir */
> +	const char	__user *path;		/* NUL terminated path */
> +};
> +
>  /*
>   * Flags for going down operation
>   */
> @@ -837,6 +846,8 @@ struct xfs_scrub_metadata {
>  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
>  #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
>  #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
> +#define XFS_IOC_GETFSXATTRAT	     _IOR ('X', 130, struct xfs_xattrat_req)
> +#define XFS_IOC_SETFSXATTRAT	     _IOW ('X', 131, struct xfs_xattrat_req)
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
>  
> diff --git a/quota/project.c b/quota/project.c
> index adb26945fa57..e6059db93a77 100644
> --- a/quota/project.c
> +++ b/quota/project.c
> @@ -12,6 +12,8 @@
>  static cmdinfo_t project_cmd;
>  static prid_t prid;
>  static int recurse_depth = -1;
> +static int dfd;
> +static int dlen;
>  
>  enum {
>  	CHECK_PROJECT	= 0x1,
> @@ -78,6 +80,42 @@ project_help(void)
>  "\n"));
>  }
>  
> +static int
> +check_special_file(
> +	const char		*path,
> +	const struct stat	*stat,
> +	int			flag,
> +	struct FTW		*data)
> +{
> +	int			error;
> +	struct fsxattr		fa;
> +	struct xfs_xattrat_req	xreq = {
> +		.fsx = &fa,
> +		.dfd = dfd,
> +		.path = path + (data->level ? dlen + 1 : 0),
> +	};
> +
> +	error = xfsctl(path, dfd, XFS_IOC_GETFSXATTRAT, &xreq);
> +	if (error == -ENOTTY) {

These xfsctl calls should be direct ioctl calls.

> +		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> +		return 0;
> +	}
> +
> +	if (error) {
> +		exitcode = 1;
> +		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> +			progname, path, strerror(errno));
> +		return 0;
> +	}
> +
> +	if (xreq.fsx->fsx_projid != prid)
> +		printf(_("%s - project identifier is not set"
> +			 " (inode=%u, tree=%u)\n"),
> +			path, xreq.fsx->fsx_projid, (unsigned int)prid);
> +
> +	return 0;
> +}
> +
>  static int
>  check_project(
>  	const char		*path,
> @@ -97,8 +135,7 @@ check_project(
>  		return 0;
>  	}
>  	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> -		return 0;
> +		return check_special_file(path, stat, flag, data);
>  	}
>  
>  	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> @@ -123,6 +160,48 @@ check_project(
>  	return 0;
>  }
>  
> +static int
> +clear_special_file(
> +	const char		*path,
> +	const struct stat	*stat,
> +	int			flag,
> +	struct FTW		*data)
> +{
> +	int			error;
> +	struct fsxattr		fa;
> +	struct xfs_xattrat_req	xreq = {
> +		.fsx = &fa,
> +		.dfd = dfd,
> +		.path = path + (data->level ? dlen + 1 : 0),
> +	};
> +
> +	error = xfsctl(path, dfd, XFS_IOC_GETFSXATTRAT, &xreq);
> +	if (error == -ENOTTY) {
> +		fprintf(stderr, _("%s: skipping special file %s\n"),
> +				progname, path);
> +		return 0;
> +	}
> +
> +	if (error) {
> +		exitcode = 1;
> +		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> +			progname, path, strerror(errno));
> +		return 0;
> +	}
> +
> +	xreq.fsx->fsx_projid = 0;
> +	xreq.fsx->fsx_xflags &= ~FS_XFLAG_PROJINHERIT;
> +	error = xfsctl(path, dfd, XFS_IOC_SETFSXATTRAT, &xreq);
> +	if (error) {
> +		exitcode = 1;
> +		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
> +			progname, path, strerror(errno));
> +		return 0;
> +	}
> +
> +	return 0;
> +}
> +
>  static int
>  clear_project(
>  	const char		*path,
> @@ -142,8 +221,7 @@ clear_project(
>  		return 0;
>  	}
>  	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> -		return 0;
> +		return clear_special_file(path, stat, flag, data);
>  	}
>  
>  	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> @@ -170,6 +248,47 @@ clear_project(
>  	return 0;
>  }
>  
> +static int
> +setup_special_file(
> +	const char		*path,
> +	const struct stat	*stat,
> +	int			flag,
> +	struct FTW		*data)
> +{
> +	int			error;
> +	struct fsxattr		fa;
> +	struct xfs_xattrat_req	xreq = {
> +		.fsx = &fa,
> +		.dfd = dfd,
> +		/* Cut path to parent - make it relative to the dfd */
> +		.path = path + (data->level ? dlen + 1 : 0),
> +	};
> +
> +	error = xfsctl(path, dfd, XFS_IOC_GETFSXATTRAT, &xreq);
> +	if (error == -ENOTTY) {
> +                fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> +                return 0;
> +        }
> +
> +	if (error) {
> +		exitcode = 1;
> +		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> +			progname, path, strerror(errno));
> +		return 0;
> +	}
> +	xreq.fsx->fsx_projid = prid;
> +	xreq.fsx->fsx_xflags |= FS_XFLAG_PROJINHERIT;
> +	error = xfsctl(path, dfd, XFS_IOC_SETFSXATTRAT, &xreq);
> +	if (error) {
> +		exitcode = 1;
> +		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
> +			progname, path, strerror(errno));
> +		return 0;
> +	}
> +
> +	return 0;
> +}
> +
>  static int
>  setup_project(
>  	const char		*path,
> @@ -189,8 +308,7 @@ setup_project(
>  		return 0;
>  	}
>  	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> -		return 0;
> +		return setup_special_file(path, stat, flag, data);
>  	}
>  
>  	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> @@ -223,6 +341,13 @@ project_operations(
>  	char		*dir,
>  	int		type)
>  {
> +	if ((dfd = open(dir, O_RDONLY|O_NOCTTY)) == -1) {

Please let's not introduce more of this ^ in the codebase:

	dfd = open(...);
	if (dfd < 0) {
		printf(...);

--D

> +		printf(_("Error opening dir %s for project %s...\n"), dir,
> +				project);
> +		return;
> +	}
> +	dlen = strlen(dir);
> +
>  	switch (type) {
>  	case CHECK_PROJECT:
>  		printf(_("Checking project %s (path %s)...\n"), project, dir);
> @@ -237,6 +362,8 @@ project_operations(
>  		nftw(dir, clear_project, 100, FTW_PHYS|FTW_MOUNT);
>  		break;
>  	}
> +
> +	close(dfd);
>  }
>  
>  static void
> -- 
> 2.42.0
> 
> 

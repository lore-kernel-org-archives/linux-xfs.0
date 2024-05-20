Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDA534CDE
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227965; cv=none; b=ukZeTk1sIS0Kv799W4Hf76Iach5mC8RSPhwpA97R9JblIiFY1jxJ4WPYAUHd8wLpdRwapyv4KsoPcTLystOpMqyg8jjj+1MWKtb7LMuDuLQUj4nonwbk1SHiB+RoFpKsVHNgPGCK48QkotjROUKKEjvdHx1Rhbj9deIY4mkyBMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227965; c=relaxed/simple;
	bh=UJyFyJmegfqQvSEJwLyipIE1PJZZ1hRdY/Mdo76junA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+3JNj5KsJslyyGw/mR8cEMSMnmiCKdtCXMelbwO+VrOsstF9olaEe6aeREzBOeh+WIg6aiP5wN4PtADNdos6eCkkg6gwHpKPV2hVTAOMa+UwrgRXiMO9jGVO5cdPUiJcFMjGMaBIDl+MuMGZCBgRQlPOBZB1nJXSAqFufAqyGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hC066cCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hC066cCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E601EC2BD10;
	Mon, 20 May 2024 17:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716227965;
	bh=UJyFyJmegfqQvSEJwLyipIE1PJZZ1hRdY/Mdo76junA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hC066cCvECZu3K+5JaGS76X14gLZQm27QPPckRtubn09M4dz1DWSRjXTWszVMEjPT
	 VAbm/Ekgievbyo+a+9OyoZMThY+Xr7gPQR+gEUbwAMUA5VY6mud+IOdeo7TCz+HH+5
	 CCG9cyvBO84EgBsSMDiHCHbaa239CJqQ9ZvgfaE0lfZDObzA4Cof2txRl7eWhSG7wi
	 ITMIat1IJ1YMUuf2YGrYb3i3TYFTXr+h8BSbfcvCwSVthS/v4GICSekHl9r5ArVPhm
	 QDZgI7a7k69qdTwj+PLv3yYTLWsUj0PRgGPALWM29xsOv9OzjS5AhGGAnKjqYw7m2L
	 iwvsU6NFOKqXQ==
Date: Mon, 20 May 2024 10:59:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH v2] libxfs/quota: utilize FS_IOC_FSSETXATTRAT to set
 prjid on special files
Message-ID: <20240520175924.GG25518@frogsfrogsfrogs>
References: <20240520165200.667150-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520165200.667150-2-aalbersh@redhat.com>

On Mon, May 20, 2024 at 06:52:01PM +0200, Andrey Albershteyn wrote:
> Utilize new FS_IOC_FS[SET|GET]XATTRAT ioctl to set project ID on
> special files. Previously, special files were skipped due to lack of
> the way to call FS_IOC_SETFSXATTR on them. The quota accounting was
> therefore missing a few inodes (special files created before project
> setup).
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  include/linux.h |  14 +++++
>  quota/project.c | 158 ++++++++++++++++++++++++++++++++----------------
>  2 files changed, 120 insertions(+), 52 deletions(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index 95a0deee2594..baae28727030 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -249,6 +249,20 @@ struct fsxattr {
>  #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
>  #endif
>  
> +#ifndef FS_IOC_FSGETXATTRAT
> +/*
> + * Structure passed to FS_IOC_FSGETXATTRAT/FS_IOC_FSSETXATTRAT
> + */
> +struct fsxattrat {
> +	struct fsxattr	fsx;		/* XATTR to get/set */
> +	__u32		dfd;		/* parent dir */
> +	const char	*path;
> +};
> +
> +#define FS_IOC_FSGETXATTRAT   _IOR ('X', 33, struct fsxattrat)
> +#define FS_IOC_FSSETXATTRAT   _IOW ('X', 34, struct fsxattrat)
> +#endif

Might want to hide this in quota/project.c since it's the only user.
(Do we need to port the xfs_io commands?  I think not since xfs_io
cannot open special files?)

> +
>  /*
>   * Reminder: anything added to this file will be compiled into downstream
>   * userspace projects!
> diff --git a/quota/project.c b/quota/project.c
> index adb26945fa57..438dd925c884 100644
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
> @@ -19,7 +21,7 @@ enum {
>  	CLEAR_PROJECT	= 0x4,
>  };
>  
> -#define EXCLUDED_FILE_TYPES(x) \
> +#define SPECIAL_FILE(x) \
>  	   (S_ISCHR((x)) \
>  	|| S_ISBLK((x)) \
>  	|| S_ISFIFO((x)) \
> @@ -78,6 +80,71 @@ project_help(void)
>  "\n"));
>  }
>  
> +static int
> +get_fsxattr(
> +	const char		*path,
> +	const struct stat	*stat,
> +	struct FTW		*data,
> +	struct fsxattr		*fsx)
> +{
> +	int			error;
> +	int			fd;
> +	struct fsxattrat	xreq = {
> +		.fsx = { 0 },
> +		.dfd = dfd,
> +		.path = path + (data->level ? dlen + 1 : 0),
> +	};
> +
> +	if (SPECIAL_FILE(stat->st_mode)) {
> +		error = ioctl(dfd, FS_IOC_FSGETXATTRAT, &xreq);
> +		if (error)
> +			return error;
> +
> +		memcpy(fsx, &xreq.fsx, sizeof(struct fsxattr));
> +		return error;
> +	}
> +
> +	fd = open(path, O_RDONLY|O_NOCTTY);
> +	if (fd == -1)
> +		return errno;
> +
> +	error = ioctl(fd, FS_IOC_FSGETXATTR, fsx);
> +	close(fd);
> +
> +	return error;
> +}
> +
> +static int
> +set_fsxattr(
> +	const char		*path,
> +	const struct stat	*stat,
> +	struct FTW		*data,
> +	struct fsxattr		*fsx)
> +{
> +	int			error;
> +	int			fd;
> +	struct fsxattrat	xreq = {
> +		.fsx = { 0 },

		.fsx = *fsx, /* struct copy */

> +		.dfd = dfd,
> +		.path = path + (data->level ? dlen + 1 : 0),
> +	};
> +
> +	if (SPECIAL_FILE(stat->st_mode)) {
> +		memcpy(&xreq.fsx, fsx, sizeof(struct fsxattr));
> +		error = ioctl(dfd, FS_IOC_FSSETXATTRAT, &xreq);
> +		return error;

	if (SPECIAL_FILE(stat->st_mode))
		return ioctl(dfd, FS_IOC_FSSETXATTRAT, &xreq);

Everything else looks good!

--D

> +	}
> +
> +	fd = open(path, O_RDONLY|O_NOCTTY);
> +	if (fd == -1)
> +		return errno;
> +
> +	error = ioctl(fd, FS_IOC_FSSETXATTR, fsx);
> +	close(fd);
> +
> +	return error;
> +}
> +
>  static int
>  check_project(
>  	const char		*path,
> @@ -85,8 +152,8 @@ check_project(
>  	int			flag,
>  	struct FTW		*data)
>  {
> -	struct fsxattr		fsx;
> -	int			fd;
> +	int			error;
> +	struct fsxattr		fsx = { 0 };
>  
>  	if (recurse_depth >= 0 && data->level > recurse_depth)
>  		return 0;
> @@ -96,30 +163,23 @@ check_project(
>  		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
>  		return 0;
>  	}
> -	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> -		return 0;
> -	}
>  
> -	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> -		exitcode = 1;
> -		fprintf(stderr, _("%s: cannot open %s: %s\n"),
> -			progname, path, strerror(errno));
> -	} else if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
> +	error = get_fsxattr(path, stat, data, &fsx);
> +	if (error) {
>  		exitcode = 1;
>  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
>  			progname, path, strerror(errno));
> -	} else {
> -		if (fsx.fsx_projid != prid)
> -			printf(_("%s - project identifier is not set"
> -				 " (inode=%u, tree=%u)\n"),
> -				path, fsx.fsx_projid, (unsigned int)prid);
> -		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && S_ISDIR(stat->st_mode))
> -			printf(_("%s - project inheritance flag is not set\n"),
> -				path);
> +		return 0;
>  	}
> -	if (fd != -1)
> -		close(fd);
> +
> +	if (fsx.fsx_projid != prid)
> +		printf(_("%s - project identifier is not set"
> +				" (inode=%u, tree=%u)\n"),
> +			path, fsx.fsx_projid, (unsigned int)prid);
> +	if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && S_ISDIR(stat->st_mode))
> +		printf(_("%s - project inheritance flag is not set\n"),
> +			path);
> +
>  	return 0;
>  }
>  
> @@ -130,8 +190,8 @@ clear_project(
>  	int			flag,
>  	struct FTW		*data)
>  {
> +	int			error;
>  	struct fsxattr		fsx;
> -	int			fd;
>  
>  	if (recurse_depth >= 0 && data->level > recurse_depth)
>  		return 0;
> @@ -141,32 +201,24 @@ clear_project(
>  		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
>  		return 0;
>  	}
> -	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> -		return 0;
> -	}
>  
> -	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> -		exitcode = 1;
> -		fprintf(stderr, _("%s: cannot open %s: %s\n"),
> -			progname, path, strerror(errno));
> -		return 0;
> -	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
> +	error = get_fsxattr(path, stat, data, &fsx);
> +	if (error) {
>  		exitcode = 1;
>  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> -			progname, path, strerror(errno));
> -		close(fd);
> +				progname, path, strerror(errno));
>  		return 0;
>  	}
>  
>  	fsx.fsx_projid = 0;
>  	fsx.fsx_xflags &= ~FS_XFLAG_PROJINHERIT;
> -	if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx) < 0) {
> +
> +	error = set_fsxattr(path, stat, data, &fsx);
> +	if (error) {
>  		exitcode = 1;
>  		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
>  			progname, path, strerror(errno));
>  	}
> -	close(fd);
>  	return 0;
>  }
>  
> @@ -178,7 +230,7 @@ setup_project(
>  	struct FTW		*data)
>  {
>  	struct fsxattr		fsx;
> -	int			fd;
> +	int			error;
>  
>  	if (recurse_depth >= 0 && data->level > recurse_depth)
>  		return 0;
> @@ -188,32 +240,24 @@ setup_project(
>  		fprintf(stderr, _("%s: cannot stat file %s\n"), progname, path);
>  		return 0;
>  	}
> -	if (EXCLUDED_FILE_TYPES(stat->st_mode)) {
> -		fprintf(stderr, _("%s: skipping special file %s\n"), progname, path);
> -		return 0;
> -	}
>  
> -	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
> -		exitcode = 1;
> -		fprintf(stderr, _("%s: cannot open %s: %s\n"),
> -			progname, path, strerror(errno));
> -		return 0;
> -	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
> +	error = get_fsxattr(path, stat, data, &fsx);
> +	if (error) {
>  		exitcode = 1;
>  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
> -			progname, path, strerror(errno));
> -		close(fd);
> +				progname, path, strerror(errno));
>  		return 0;
>  	}
>  
>  	fsx.fsx_projid = prid;
>  	fsx.fsx_xflags |= FS_XFLAG_PROJINHERIT;
> -	if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx) < 0) {
> +
> +	error = set_fsxattr(path, stat, data, &fsx);
> +	if (error) {
>  		exitcode = 1;
>  		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
>  			progname, path, strerror(errno));
>  	}
> -	close(fd);
>  	return 0;
>  }
>  
> @@ -223,6 +267,14 @@ project_operations(
>  	char		*dir,
>  	int		type)
>  {
> +	dfd = open(dir, O_RDONLY|O_NOCTTY);
> +	if (dfd < -1) {
> +		printf(_("Error opening dir %s for project %s...\n"), dir,
> +				project);
> +		return;
> +	}
> +	dlen = strlen(dir);
> +
>  	switch (type) {
>  	case CHECK_PROJECT:
>  		printf(_("Checking project %s (path %s)...\n"), project, dir);
> @@ -237,6 +289,8 @@ project_operations(
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

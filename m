Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40180 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751991AbeDKBsH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 21:48:07 -0400
Subject: Re: [PATCH 10/14] xfs_scrub: refactor mountpoint finding code to use
 libfrog path code
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
 <152160364198.8288.1222538238075511907.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d4fbe9a1-23f8-ca79-0f64-7dac4bad1f05@sandeen.net>
Date: Tue, 10 Apr 2018 20:48:05 -0500
MIME-Version: 1.0
In-Reply-To: <152160364198.8288.1222538238075511907.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 3/20/18 10:40 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the libfrog path finding code to determine if the argument being
> passed in is a mountpoint, remove all mention of taking a block device
> (we have never supported that) from the documentation, and fix some
> potential memory leaks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

now with 100% mount point!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man8/xfs_scrub.8 |    2 +
>  scrub/common.c       |   69 --------------------------------------------------
>  scrub/common.h       |    1 -
>  scrub/phase1.c       |   12 ---------
>  scrub/xfs_scrub.c    |   19 +++++++-------
>  scrub/xfs_scrub.h    |    1 -
>  6 files changed, 10 insertions(+), 94 deletions(-)
> 
> 
> diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
> index 77fed92..680ef72 100644
> --- a/man/man8/xfs_scrub.8
> +++ b/man/man8/xfs_scrub.8
> @@ -6,7 +6,7 @@ xfs_scrub \- check the contents of a mounted XFS filesystem
>  [
>  .B \-abCemnTvx
>  ]
> -.RI "[" mount-point " | " block-device "]"
> +.I mount-point
>  .br
>  .B xfs_scrub \-V
>  .SH DESCRIPTION
> diff --git a/scrub/common.c b/scrub/common.c
> index 5a37a98..722bf36 100644
> --- a/scrub/common.c
> +++ b/scrub/common.c
> @@ -267,75 +267,6 @@ scrub_nproc_workqueue(
>  }
>  
>  /*
> - * Check if the argument is either the device name or mountpoint of a mounted
> - * filesystem.
> - */
> -#define MNTTYPE_XFS	"xfs"
> -static bool
> -find_mountpoint_check(
> -	struct stat		*sb,
> -	struct mntent		*t)
> -{
> -	struct stat		ms;
> -
> -	if (S_ISDIR(sb->st_mode)) {		/* mount point */
> -		if (stat(t->mnt_dir, &ms) < 0)
> -			return false;
> -		if (sb->st_ino != ms.st_ino)
> -			return false;
> -		if (sb->st_dev != ms.st_dev)
> -			return false;
> -		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
> -			return NULL;
> -	} else {				/* device */
> -		if (stat(t->mnt_fsname, &ms) < 0)
> -			return false;
> -		if (sb->st_rdev != ms.st_rdev)
> -			return false;
> -		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
> -			return NULL;
> -		/*
> -		 * Make sure the mountpoint given by mtab is accessible
> -		 * before using it.
> -		 */
> -		if (stat(t->mnt_dir, &ms) < 0)
> -			return false;
> -	}
> -
> -	return true;
> -}
> -
> -/* Check that our alleged mountpoint is in mtab */
> -bool
> -find_mountpoint(
> -	char			*mtab,
> -	struct scrub_ctx	*ctx)
> -{
> -	struct mntent_cursor	cursor;
> -	struct mntent		*t = NULL;
> -	bool			found = false;
> -
> -	if (platform_mntent_open(&cursor, mtab) != 0) {
> -		fprintf(stderr, "Error: can't get mntent entries.\n");
> -		exit(1);
> -	}
> -
> -	while ((t = platform_mntent_next(&cursor)) != NULL) {
> -		/*
> -		 * Keep jotting down matching mount details; newer mounts are
> -		 * towards the end of the file (hopefully).
> -		 */
> -		if (find_mountpoint_check(&ctx->mnt_sb, t)) {
> -			ctx->mntpoint = strdup(t->mnt_dir);
> -			ctx->blkdev = strdup(t->mnt_fsname);
> -			found = true;
> -		}
> -	}
> -	platform_mntent_close(&cursor);
> -	return found;
> -}
> -
> -/*
>   * Sleep for 100ms * however many -b we got past the initial one.
>   * This is an (albeit clumsy) way to throttle scrub activity.
>   */
> diff --git a/scrub/common.h b/scrub/common.h
> index 4f1f0cd..bc83971 100644
> --- a/scrub/common.h
> +++ b/scrub/common.h
> @@ -88,7 +88,6 @@ static inline int syncfs(int fd)
>  }
>  #endif
>  
> -bool find_mountpoint(char *mtab, struct scrub_ctx *ctx);
>  void background_sleep(void);
>  char *string_escape(const char *in);
>  
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index 9926770..c2b9067 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -83,7 +83,6 @@ bool
>  xfs_setup_fs(
>  	struct scrub_ctx		*ctx)
>  {
> -	struct fs_path			*fsp;
>  	int				error;
>  
>  	/*
> @@ -178,17 +177,6 @@ _("Kernel metadata repair facility is not available.  Use -n to scrub."));
>  		return false;
>  	}
>  
> -	/* Go find the XFS devices if we have a usable fsmap. */
> -	fs_table_initialise(0, NULL, 0, NULL);
> -	errno = 0;
> -	fsp = fs_table_lookup(ctx->mntpoint, FS_MOUNT_POINT);
> -	if (!fsp) {
> -		str_info(ctx, ctx->mntpoint,
> -_("Unable to find XFS information."));
> -		return false;
> -	}
> -	memcpy(&ctx->fsinfo, fsp, sizeof(struct fs_path));
> -
>  	/* Did we find the log and rt devices, if they're present? */
>  	if (ctx->geo.logstart == 0 && ctx->fsinfo.fs_log == NULL) {
>  		str_info(ctx, ctx->mntpoint,
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index 2d55283..a5b5cf2 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -170,7 +170,7 @@ bool				is_service;
>  static void __attribute__((noreturn))
>  usage(void)
>  {
> -	fprintf(stderr, _("Usage: %s [OPTIONS] mountpoint | device\n"), progname);
> +	fprintf(stderr, _("Usage: %s [OPTIONS] mountpoint\n"), progname);
>  	fprintf(stderr, "\n");
>  	fprintf(stderr, _("Options:\n"));
>  	fprintf(stderr, _("  -a count     Stop after this many errors are found.\n"));
> @@ -538,8 +538,8 @@ main(
>  	struct phase_rusage	all_pi;
>  	char			*mtab = NULL;
>  	FILE			*progress_fp = NULL;
> +	struct fs_path		*fsp;
>  	bool			moveon = true;
> -	bool			ismnt;
>  	int			c;
>  	int			fd;
>  	int			ret = SCRUB_RET_SUCCESS;
> @@ -640,7 +640,7 @@ main(
>  	if (optind != argc - 1)
>  		usage();
>  
> -	ctx.mntpoint = strdup(argv[optind]);
> +	ctx.mntpoint = argv[optind];
>  
>  	stdout_isatty = isatty(STDOUT_FILENO);
>  	stderr_isatty = isatty(STDERR_FILENO);
> @@ -680,14 +680,15 @@ main(
>  			mtab = _PATH_MOUNTED;
>  	}
>  
> -	ismnt = find_mountpoint(mtab, &ctx);
> -	if (!ismnt) {
> -		fprintf(stderr,
> -_("%s: Not a XFS mount point or block device.\n"),
> -			ctx.mntpoint);
> +	fs_table_initialise(0, NULL, 0, NULL);
> +	fsp = fs_table_lookup_mount(ctx.mntpoint);
> +	if (!fsp) {
> +		fprintf(stderr, _("%s: Not a XFS mount point.\n"),
> +				ctx.mntpoint);
>  		ret |= SCRUB_RET_SYNTAX;
>  		goto out;
>  	}
> +	memcpy(&ctx.fsinfo, fsp, sizeof(struct fs_path));
>  
>  	/* How many CPUs? */
>  	nproc = sysconf(_SC_NPROCESSORS_ONLN);
> @@ -740,8 +741,6 @@ _("%s: Not a XFS mount point or block device.\n"),
>  	phase_end(&all_pi, 0);
>  	if (progress_fp)
>  		fclose(progress_fp);
> -	free(ctx.blkdev);
> -	free(ctx.mntpoint);
>  
>  	/*
>  	 * If we're being run as a service, the return code must fit the LSB
> diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
> index aa130a7..c9dbe8e 100644
> --- a/scrub/xfs_scrub.h
> +++ b/scrub/xfs_scrub.h
> @@ -48,7 +48,6 @@ struct scrub_ctx {
>  
>  	/* Strings we need for presentation */
>  	char			*mntpoint;
> -	char			*blkdev;
>  
>  	/* Mountpoint info */
>  	struct stat		mnt_sb;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

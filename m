Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D5B11701
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 09:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HtVC1GVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53505C433C7;
	Mon, 18 Dec 2023 09:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702891243;
	bh=h9cTjyZi0nBmlRCLMBD09NxyTxSCz96GwMrIojVX/Jg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HtVC1GVkY4quk6ihAyEo0XHZx1bQV7DyINwDauLG3pnwW0XSBWzKLJYUOFNUtfrrx
	 3YgnfD0GoRwN5m/QsuNMA7pIu9iMqI19Jar/A6XSBquvNhHWPnR9aMDmAknA2QknTj
	 RPGlC5XWjMSqiE/cpV0IOEr86o7lZbM16sbp7tH33r4zO1TfYQ/IyLu1E4Wd4OoSkK
	 XAu4NTzCXRNhfXgXV9C8LJO/kt0hiQtF2EFlO2XQvmq537A4oOFPnQ9lnfuOvwvQ+W
	 DRF8kAvFsBO6F1Qm91iZQEbW76w1uMSnCxIw+LK3+NrrUBXCy8jDUGZyw6oJB/5dr0
	 9ImMxEOK0sSUQ==
Date: Mon, 18 Dec 2023 10:20:39 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/23] libxfs: rename struct libxfs_xinit to libxfs_init
Message-ID: <vffferqrkzzjw7nl3v3fwwzg7ocedjcitv5hztyetctm473goe@lnbuqpgkyu32>
References: <20231211163742.837427-1-hch@lst.de>
 <qDBV5zWdjpvmIMKsiwu40N0OvODUvXHrpcdCqQQ75RaoVX65gFDBgZCpyJugGAv1-WX47X7Y1m8lS0hQMunhCQ==@protonmail.internalid>
 <20231211163742.837427-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-11-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:29PM +0100, Christoph Hellwig wrote:
> Make the struct name more usual, and remove the libxfs_init_t typedef.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  copy/xfs_copy.c     |  2 +-
>  db/init.c           |  2 +-
>  db/init.h           |  2 +-
>  growfs/xfs_growfs.c |  2 +-
>  include/libxfs.h    | 10 ++++++----
>  libxfs/init.c       |  6 +++---
>  libxfs/topology.c   |  5 +++--
>  libxfs/topology.h   |  4 ++--
>  logprint/logprint.c |  2 +-
>  mkfs/xfs_mkfs.c     | 18 +++++++++---------
>  repair/globals.h    |  2 +-
>  repair/init.c       |  6 +++---
>  repair/protos.h     |  2 +-
>  repair/sb.c         |  2 +-
>  14 files changed, 34 insertions(+), 31 deletions(-)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 86187086d..12ad81eb1 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -582,7 +582,7 @@ main(int argc, char **argv)
>  	xfs_alloc_rec_t	*rec_ptr;
>  	extern char	*optarg;
>  	extern int	optind;
> -	libxfs_init_t	xargs;
> +	struct libxfs_init xargs;
>  	thread_args	*tcarg;
>  	struct stat	statbuf;
>  	int		error;
> diff --git a/db/init.c b/db/init.c
> index eceaf576c..36e2bb89d 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -27,7 +27,7 @@ static struct xfs_mount	xmount;
>  struct xfs_mount	*mp;
>  static struct xlog	xlog;
>  xfs_agnumber_t		cur_agno = NULLAGNUMBER;
> -libxfs_init_t		x;
> +struct libxfs_init	x;
> 
>  static void
>  usage(void)
> diff --git a/db/init.h b/db/init.h
> index 05e75c100..aa6d843d8 100644
> --- a/db/init.h
> +++ b/db/init.h
> @@ -8,5 +8,5 @@ extern int		blkbb;
>  extern int		exitcode;
>  extern int		expert_mode;
>  extern xfs_mount_t	*mp;
> -extern libxfs_init_t	x;
> +extern struct libxfs_init x;
>  extern xfs_agnumber_t	cur_agno;
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 683961f6b..802e01154 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -61,7 +61,7 @@ main(int argc, char **argv)
>  	char			*logdev;  /*  log device name */
>  	char			*rtdev;	/*   RT device name */
>  	fs_path_t		*fs;	/* mount point information */
> -	libxfs_init_t		xi;	/* libxfs structure */
> +	struct libxfs_init	xi;	/* libxfs structure */
>  	char			rpath[PATH_MAX];
>  	int			ret;
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 270efb2c1..6da8fd1c8 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -92,7 +92,7 @@ struct iomap;
>  /*
>   * Argument structure for libxfs_init().
>   */
> -typedef struct libxfs_xinit {
> +struct libxfs_init {
>  				/* input parameters */
>  	char            *dname;         /* pathname of data "subvolume" */
>  	char            *logname;       /* pathname of log "subvolume" */
> @@ -123,7 +123,7 @@ typedef struct libxfs_xinit {
>  	int             logfd;          /* log subvolume file descriptor */
>  	int             rtfd;           /* realtime subvolume file descriptor */
>  	int		bcache_flags;	/* cache init flags */
> -} libxfs_init_t;
> +};
> 
>  #define LIBXFS_ISREADONLY	0x0002	/* disallow all mounted filesystems */
>  #define LIBXFS_ISINACTIVE	0x0004	/* allow mounted only if mounted ro */
> @@ -133,8 +133,10 @@ typedef struct libxfs_xinit {
> 
>  extern char	*progname;
>  extern xfs_lsn_t libxfs_max_lsn;
> -extern int	libxfs_init (libxfs_init_t *);
> -void		libxfs_destroy(struct libxfs_xinit *li);
> +
> +int		libxfs_init(struct libxfs_init *);
> +void		libxfs_destroy(struct libxfs_init *li);
> +
>  extern int	libxfs_device_to_fd (dev_t);
>  extern dev_t	libxfs_device_open (char *, int, int, int);
>  extern void	libxfs_device_close (dev_t);
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 6482ba52b..cafd40b11 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -273,7 +273,7 @@ destroy_caches(void)
> 
>  static void
>  libxfs_close_devices(
> -	struct libxfs_xinit	*li)
> +	struct libxfs_init	*li)
>  {
>  	if (li->ddev)
>  		libxfs_device_close(li->ddev);
> @@ -291,7 +291,7 @@ libxfs_close_devices(
>   * Caller gets a 0 on failure (and we print a message), 1 on success.
>   */
>  int
> -libxfs_init(libxfs_init_t *a)
> +libxfs_init(struct libxfs_init *a)
>  {
>  	char		*dname;
>  	char		*logname;
> @@ -1034,7 +1034,7 @@ libxfs_umount(
>   */
>  void
>  libxfs_destroy(
> -	struct libxfs_xinit	*li)
> +	struct libxfs_init	*li)
>  {
>  	int			leaked;
> 
> diff --git a/libxfs/topology.c b/libxfs/topology.c
> index 25f47beda..d6791c0f6 100644
> --- a/libxfs/topology.c
> +++ b/libxfs/topology.c
> @@ -286,8 +286,9 @@ static void blkid_get_topology(
> 
>  #endif /* ENABLE_BLKID */
> 
> -void get_topology(
> -	libxfs_init_t		*xi,
> +void
> +get_topology(
> +	struct libxfs_init	*xi,
>  	struct fs_topology	*ft,
>  	int			force_overwrite)
>  {
> diff --git a/libxfs/topology.h b/libxfs/topology.h
> index 1a0fe24c0..1af5b0549 100644
> --- a/libxfs/topology.h
> +++ b/libxfs/topology.h
> @@ -18,9 +18,9 @@ typedef struct fs_topology {
>  	int	psectorsize;	/* physical sector size */
>  } fs_topology_t;
> 
> -extern void
> +void
>  get_topology(
> -	libxfs_init_t		*xi,
> +	struct libxfs_init	*xi,
>  	struct fs_topology	*ft,
>  	int			force_overwrite);
> 
> diff --git a/logprint/logprint.c b/logprint/logprint.c
> index 1a096fa79..c6e5051e8 100644
> --- a/logprint/logprint.c
> +++ b/logprint/logprint.c
> @@ -25,7 +25,7 @@ int	print_overwrite;
>  int     print_no_data;
>  int     print_no_print;
>  static int	print_operation = OP_PRINT;
> -static struct libxfs_xinit x;
> +static struct libxfs_init x;
> 
>  static void
>  usage(void)
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 19849ed21..346516e13 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -907,7 +907,7 @@ struct cli_params {
>  	struct fsxattr		fsx;
> 
>  	/* libxfs device setup */
> -	struct libxfs_xinit	*xi;
> +	struct libxfs_init	*xi;
>  };
> 
>  /*
> @@ -1246,7 +1246,7 @@ validate_ag_geometry(
> 
>  static void
>  zero_old_xfs_structures(
> -	libxfs_init_t		*xi,
> +	struct libxfs_init	*xi,
>  	xfs_sb_t		*new_sb)
>  {
>  	void 			*buf;
> @@ -2834,7 +2834,7 @@ _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
>  static void
>  open_devices(
>  	struct mkfs_params	*cfg,
> -	struct libxfs_xinit	*xi)
> +	struct libxfs_init	*xi)
>  {
>  	uint64_t		sector_mask;
> 
> @@ -2867,7 +2867,7 @@ open_devices(
> 
>  static void
>  discard_devices(
> -	struct libxfs_xinit	*xi,
> +	struct libxfs_init	*xi,
>  	int			quiet)
>  {
>  	/*
> @@ -2887,7 +2887,7 @@ validate_datadev(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli)
>  {
> -	struct libxfs_xinit	*xi = cli->xi;
> +	struct libxfs_init	*xi = cli->xi;
> 
>  	if (!xi->dsize) {
>  		/*
> @@ -2934,7 +2934,7 @@ validate_logdev(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli)
>  {
> -	struct libxfs_xinit	*xi = cli->xi;
> +	struct libxfs_init	*xi = cli->xi;
> 
>  	cfg->loginternal = cli->loginternal;
> 
> @@ -2998,7 +2998,7 @@ validate_rtdev(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli)
>  {
> -	struct libxfs_xinit	*xi = cli->xi;
> +	struct libxfs_init	*xi = cli->xi;
> 
>  	if (!xi->rtdev) {
>  		if (cli->rtsize) {
> @@ -3750,7 +3750,7 @@ alloc_write_buf(
>  static void
>  prepare_devices(
>  	struct mkfs_params	*cfg,
> -	struct libxfs_xinit	*xi,
> +	struct libxfs_init	*xi,
>  	struct xfs_mount	*mp,
>  	struct xfs_sb		*sbp,
>  	bool			clear_stale)
> @@ -4055,7 +4055,7 @@ main(
>  	char			*protostring = NULL;
>  	int			worst_freelist = 0;
> 
> -	struct libxfs_xinit	xi = {
> +	struct libxfs_init	xi = {
>  		.isdirect = LIBXFS_DIRECT,
>  		.isreadonly = LIBXFS_EXCLUSIVELY,
>  	};
> diff --git a/repair/globals.h b/repair/globals.h
> index f2952d8b4..89f1b0e07 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -169,6 +169,6 @@ extern int		thread_count;
>  /* If nonzero, simulate failure after this phase. */
>  extern int		fail_after_phase;
> 
> -extern libxfs_init_t	x;
> +extern struct libxfs_init x;
> 
>  #endif /* _XFS_REPAIR_GLOBAL_H */
> diff --git a/repair/init.c b/repair/init.c
> index 6e3548b32..1c562fb34 100644
> --- a/repair/init.c
> +++ b/repair/init.c
> @@ -18,7 +18,7 @@
>  #include "libfrog/dahashselftest.h"
>  #include <sys/resource.h>
> 
> -struct libxfs_xinit	x;
> +struct libxfs_init	x;
> 
>  static void
>  ts_create(void)
> @@ -52,9 +52,9 @@ increase_rlimit(void)
>  }
> 
>  void
> -xfs_init(libxfs_init_t *args)
> +xfs_init(struct libxfs_init *args)
>  {
> -	memset(args, 0, sizeof(libxfs_init_t));
> +	memset(args, 0, sizeof(*args));
> 
>  	args->dname = fs_name;
>  	args->disfile = isa_file;
> diff --git a/repair/protos.h b/repair/protos.h
> index 83e471ff2..e2f39f1d6 100644
> --- a/repair/protos.h
> +++ b/repair/protos.h
> @@ -4,7 +4,7 @@
>   * All Rights Reserved.
>   */
> 
> -void	xfs_init(libxfs_init_t *args);
> +void	xfs_init(struct libxfs_init *args);
> 
>  int	verify_sb(char			*sb_buf,
>  		xfs_sb_t		*sb,
> diff --git a/repair/sb.c b/repair/sb.c
> index 7391cf043..b823ba3a9 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -176,7 +176,7 @@ static int
>  guess_default_geometry(
>  	uint64_t		*agsize,
>  	uint64_t		*agcount,
> -	libxfs_init_t		*x)
> +	struct libxfs_init	*x)
>  {
>  	struct fs_topology	ft;
>  	int			blocklog;
> --
> 2.39.2
> 

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45250 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932346AbeALBaM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 20:30:12 -0500
Subject: Re: [PATCH 03/27] xfs_scrub: set up command line argument parsing
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520350632.2027.11272777646597420008.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e9e65539-8811-af76-ebf6-0d75cc261401@sandeen.net>
Date: Thu, 11 Jan 2018 19:30:11 -0600
MIME-Version: 1.0
In-Reply-To: <151520350632.2027.11272777646597420008.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/5/18 7:51 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Parse command line options in order to set up the context in which we
> will scrub the filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/common.h    |    8 ++
>  scrub/xfs_scrub.c |  207 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  scrub/xfs_scrub.h |   34 +++++++++
>  3 files changed, 249 insertions(+)
> 
> 
> diff --git a/scrub/common.h b/scrub/common.h
> index f620620..15a59bd 100644
> --- a/scrub/common.h
> +++ b/scrub/common.h
> @@ -48,4 +48,12 @@ void __record_preen(struct scrub_ctx *ctx, const char *descr, const char *file,
>  #define str_info(ctx, str, ...)		__str_info(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
>  #define dbg_printf(fmt, ...)		{if (debug > 1) {printf(fmt, __VA_ARGS__);}}
>  
> +/* Is this debug tweak enabled? */
> +static inline bool
> +debug_tweak_on(
> +	const char		*name)
> +{
> +	return debug && getenv(name) != NULL;

since it's debug anyway, I wonder if printing
"FOO_BAR_TWEAK is on" would be useful here.

> +}
> +
>  #endif /* XFS_SCRUB_COMMON_H_ */
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index 10116a8..9db3b41 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -20,7 +20,12 @@
>  #include <stdio.h>
>  #include <pthread.h>
>  #include <stdbool.h>
> +#include <stdlib.h>
> +#include "platform_defs.h"
> +#include "xfs.h"
> +#include "input.h"
>  #include "xfs_scrub.h"
> +#include "common.h"
>  
>  /*
>   * XFS Online Metadata Scrub (and Repair)
> @@ -107,11 +112,213 @@ unsigned int			debug;
>  /* Should we dump core if errors happen? */
>  bool				dumpcore;
>  
> +/* Display resource usage at the end of each phase? */
> +bool				display_rusage;
> +
> +/* Background mode; higher values insert more pauses between scrub calls. */
> +unsigned int			bg_mode;
> +
> +/* Maximum number of processors available to us. */
> +int				nproc;
> +
> +/* Number of threads we're allowed to use. */
> +unsigned int			nr_threads;
> +
> +/* Verbosity; higher values print more information. */
> +bool				verbose;
> +
> +/* Should we scrub the data blocks? */
> +bool				scrub_data;
> +
> +/* Size of a memory page. */
> +long				page_size;
> +
> +static void __attribute__((noreturn))
> +usage(void)
> +{
> +	fprintf(stderr, _("Usage: %s [OPTIONS] mountpoint\n"), progname);
> +	fprintf(stderr, _("-a:\tStop after this many errors are found.\n"));
> +	fprintf(stderr, _("-b:\tBackground mode.\n"));
> +	fprintf(stderr, _("-e:\tWhat to do if errors are found.\n"));
> +	fprintf(stderr, _("-m:\tPath to /etc/mtab.\n"));
> +	fprintf(stderr, _("-n:\tDry run.  Do not modify anything.\n"));
> +	fprintf(stderr, _("-T:\tDisplay timing/usage information.\n"));
> +	fprintf(stderr, _("-v:\tVerbose output.\n"));
> +	fprintf(stderr, _("-V:\tPrint version.\n"));
> +	fprintf(stderr, _("-x:\tScrub file data too.\n"));
> +	fprintf(stderr, _("-y:\tRepair all errors.\n"));
> +
> +	exit(16);
> +}
> +
>  int
>  main(
>  	int			argc,
>  	char			**argv)
>  {
> +	int			c;
> +	char			*mtab = NULL;
> +	char			*repairstr = "";
> +	struct scrub_ctx	ctx = {0};
> +	unsigned long long	total_errors;
> +	bool			moveon = true;
> +	static bool		injected;
> +	int			ret = 0;
> +
>  	fprintf(stderr, "XXX: This program is not complete!\n");
>  	return 4;
> +
> +	progname = basename(argv[0]);
> +	setlocale(LC_ALL, "");
> +	bindtextdomain(PACKAGE, LOCALEDIR);
> +	textdomain(PACKAGE);
> +
> +	pthread_mutex_init(&ctx.lock, NULL);
> +	ctx.mode = SCRUB_MODE_DEFAULT;
> +	ctx.error_action = ERRORS_CONTINUE;
> +	while ((c = getopt(argc, argv, "a:bde:m:nTvxVy")) != EOF) {
> +		switch (c) {
> +		case 'a':
> +			ctx.max_errors = cvt_u64(optarg, 10);
> +			if (errno) {
> +				perror(optarg);
> +				usage();
> +			}
> +			break;
> +		case 'b':
> +			nr_threads = 1;
> +			bg_mode++;
> +			break;
> +		case 'd':
> +			debug++;
> +			dumpcore = true;
> +			break;
> +		case 'e':
> +			if (!strcmp("continue", optarg))
> +				ctx.error_action = ERRORS_CONTINUE;
> +			else if (!strcmp("shutdown", optarg))
> +				ctx.error_action = ERRORS_SHUTDOWN;
> +			else
> +				usage();

Nothing tells me what I did wrong here,

# scrub/xfs_scrub -e make_it_so /mnt/test
Usage: xfs_scrub [OPTIONS] mountpoint
-a:	Stop after this many errors are found.
-b:	Background mode.
-C:	Print progress information to this fd.
-e:	What to do if errors are found.
...

I told it what to do... what's wrong?

> +			break;
> +		case 'm':
> +			mtab = optarg;
> +			break;
> +		case 'n':
> +			if (ctx.mode != SCRUB_MODE_DEFAULT) {
> +				fprintf(stderr,
> +_("Only one of the options -n or -y may be specified.\n"));
> +				return 1;
> +			}
> +			ctx.mode = SCRUB_MODE_DRY_RUN;
> +			break;
> +		case 'T':
> +			display_rusage = true;
> +			break;
> +		case 'v':
> +			verbose = true;
> +			break;
> +		case 'V':
> +			fprintf(stdout, _("%s version %s\n"), progname,
> +					VERSION);
> +			fflush(stdout);
> +			exit(0);
> +		case 'x':
> +			scrub_data = true;
> +			break;
> +		case 'y':
> +			if (ctx.mode != SCRUB_MODE_DEFAULT) {
> +				fprintf(stderr,
> +_("Only one of the options -n or -y may be specified.\n"));
> +				return 1;
> +			}
> +			ctx.mode = SCRUB_MODE_REPAIR;
> +			break;
> +		case '?':

'?' isn't in the getopt string ...

# scrub/xfs_scrub ?
xfs_scrub: could not stat: ?: No such file or directory


> +			/* fall through */
> +		default:
> +			usage();
> +		}
> +	}
> +
> +	/* Override thread count if debugger */
> +	if (debug_tweak_on("XFS_SCRUB_THREADS")) {

can you document all these tweaks somewhere near the top in a comment?

> +		unsigned int	x;
> +
> +		x = cvt_u32(getenv("XFS_SCRUB_THREADS"), 10);
> +		if (errno) {
> +			perror("nr_threads");
> +			usage();
> +		}
> +		nr_threads = x;
> +	}
> +
> +	if (optind != argc - 1)
> +		usage();
> +
> +	ctx.mntpoint = strdup(argv[optind]);
> +
> +	/*
> +	 * If the user did not specify an explicit mount table, try to use
> +	 * /proc/mounts if it is available, else /etc/mtab.  We prefer
> +	 * /proc/mounts because it is kernel controlled, while /etc/mtab
> +	 * may contain garbage that userspace tools like pam_mounts wrote
> +	 * into it.
> +	 */
> +	if (!mtab) {
> +		if (access(_PATH_PROC_MOUNTS, R_OK) == 0)
> +			mtab = _PATH_PROC_MOUNTS;
> +		else
> +			mtab = _PATH_MOUNTED;
> +	}
> +
> +	/* How many CPUs? */
> +	nproc = sysconf(_SC_NPROCESSORS_ONLN);
> +	if (nproc < 1)
> +		nproc = 1;
> +
> +	/* Set up a page-aligned buffer for read verification. */
> +	page_size = sysconf(_SC_PAGESIZE);
> +	if (page_size < 0) {
> +		str_errno(&ctx, ctx.mntpoint);
> +		goto out;
> +	}
> +
> +	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
> +		ctx.mode = SCRUB_MODE_REPAIR;
> +		injected = true;
> +	}

what is "injected" used for?  How could it already be set?.

> +
> +	if (xfs_scrub_excessive_errors(&ctx))
> +		str_info(&ctx, ctx.mntpoint, _("Too many errors; aborting."));

wait wut?  oh right, you'll add $DO_STUFF above this in later patches ;)


Rest looks ok

-Eric

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60392 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932712AbeBLX5b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Feb 2018 18:57:31 -0500
Date: Mon, 12 Feb 2018 15:57:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/7] xfs_scrub: remove preen mode
Message-ID: <20180212235725.GC5217@magnolia>
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
 <151787294694.3743.4964498325259193655.stgit@magnolia>
 <98c28c9e-3a46-e7a7-c38b-822aaa196204@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98c28c9e-3a46-e7a7-c38b-822aaa196204@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Mon, Feb 12, 2018 at 02:49:01PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/5/18 5:22 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > While it's true that the kernel can tell us whether something needs
> > repairs or it needs optimizing, from the admin's perspective there's
> > no point in having an optimize-only mode -- either fix everything, or
> > don't.  This is what xfs_repair does w.r.t. -n, so let's do the same
> > thing too.
> 
> <ok and a few other changes but sure> :)
> 
> nitpick, does -n skip the "read all the data blocks" pass?  I'm not sure
> the manpage really addresses the data block scrubbing yet.

-n will not skip the data block scrub, it only prevents metadata repairs.

--D

> Anyway, for the changes here:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man8/xfs_scrub.8 |   51 +++++++++++++++++++++++---------------------------
> >  scrub/phase1.c       |    6 +-----
> >  scrub/phase4.c       |   19 -------------------
> >  scrub/scrub.c        |    2 +-
> >  scrub/xfs_scrub.c    |   33 +++++++-------------------------
> >  scrub/xfs_scrub.h    |    3 ---
> >  6 files changed, 32 insertions(+), 82 deletions(-)
> > 
> > 
> > diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
> > index 4c394a5..77fed92 100644
> > --- a/man/man8/xfs_scrub.8
> > +++ b/man/man8/xfs_scrub.8
> > @@ -1,10 +1,10 @@
> >  .TH xfs_scrub 8
> >  .SH NAME
> > -xfs_scrub \- scrub the contents of an XFS filesystem
> > +xfs_scrub \- check the contents of a mounted XFS filesystem
> >  .SH SYNOPSIS
> >  .B xfs_scrub
> >  [
> > -.B \-abCemnTvxy
> > +.B \-abCemnTvx
> >  ]
> >  .RI "[" mount-point " | " block-device "]"
> >  .br
> > @@ -13,6 +13,12 @@ xfs_scrub \- scrub the contents of an XFS filesystem
> >  .B xfs_scrub
> >  attempts to check and repair all metadata in a mounted XFS filesystem.
> >  .PP
> > +.B WARNING!
> > +This program is
> > +.BR EXPERIMENTAL ","
> > +which means that its behavior and interface
> > +could change at any time!
> > +.PP
> >  .B xfs_scrub
> >  asks the kernel to scrub all metadata objects in the filesystem.
> >  Metadata records are scanned for obviously bad values and then
> > @@ -28,19 +34,17 @@ the standard error stream.
> >  Enabling verbose mode will increase the amount of status information
> >  sent to the output.
> >  .PP
> > -This utility does not know how to correct all errors.
> > -If the tool cannot fix the detected errors, you must unmount the
> > -filesystem and run
> > +If the kernel scrub reports that metadata needs repairs or optimizations and
> > +the user does not pass
> > +.B -n
> > +on the command line, this program will ask the kernel to make the repairs and
> > +to perform the optimizations.
> > +See the sections about optimizations and repairs for a list of optimizations
> > +and repairs known to this program.
> > +The kernel may not support repairing or optimizing the filesystem.
> > +If this is the case, the filesystem must be unmounted and
> >  .BR xfs_repair (8)
> > -to fix the problems.
> > -If this tool is not run with either of the
> > -.B \-n
> > -or
> > -.B \-y
> > -options, then it will optimize the filesystem when possible,
> > -but it will not try to fix errors.
> > -See the optimizations section below for a list of optimizations
> > -supported by this program.
> > +run on the filesystem to fix the problems.
> >  .SH OPTIONS
> >  .TP
> >  .BI \-a " errors"
> > @@ -73,14 +77,14 @@ is given, no action is taken if errors are found; this is the default
> >  behavior.
> >  .TP
> >  .B \-k
> > -Do not call FITRIM on the free space.
> > +Do not call TRIM on the free space.
> >  .TP
> >  .BI \-m " file"
> >  Search this file for mounted filesystems instead of /etc/mtab.
> >  .TP
> >  .B \-n
> > -Dry run, do not modify anything in the filesystem.
> > -This disables all optimization and repair behaviors.
> > +Only check filesystem metadata.
> > +Do not repair or optimize anything.
> >  .TP
> >  .BI \-T
> >  Print timing and memory usage information for each phase.
> > @@ -98,20 +102,11 @@ will issue O_DIRECT reads to the block device directly.
> >  If the block device is a SCSI disk, it will instead issue READ VERIFY commands
> >  directly to the disk.
> >  These actions will confirm that all file data blocks can be read from storage.
> > -.TP
> > -.B \-y
> > -Try to repair all filesystem errors.
> > -If the errors cannot be fixed online, then the filesystem must be taken
> > -offline for repair.
> >  .SH OPTIMIZATIONS
> > -Optimizations supported by this program include:
> > +Optimizations supported by this program include, but are not limited to:
> >  .IP \[bu] 2
> > -Updating secondary superblocks to match the primary superblock.
> > -.IP \[bu]
> > -Turning off shared block write checks for files that no longer share blocks.
> > -.IP \[bu]
> >  Instructing the underlying storage to discard unused extents via the
> > -.B FITRIM
> > +.B TRIM
> >  ioctl.
> >  .SH REPAIRS
> >  This program currently does not support making any repairs.
> > diff --git a/scrub/phase1.c b/scrub/phase1.c
> > index 75da296..af93d0f 100644
> > --- a/scrub/phase1.c
> > +++ b/scrub/phase1.c
> > @@ -181,11 +181,7 @@ _("Kernel metadata scrubbing facility is not available."));
> >  
> >  	/* Do we need kernel-assisted metadata repair? */
> >  	if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
> > -		if (ctx->mode == SCRUB_MODE_PREEN)
> > -			str_error(ctx, ctx->mntpoint,
> > -_("Kernel metadata optimization facility is not available.  Use -n to scrub."));
> > -		else
> > -			str_error(ctx, ctx->mntpoint,
> > +		str_error(ctx, ctx->mntpoint,
> >  _("Kernel metadata repair facility is not available.  Use -n to scrub."));
> >  		return false;
> >  	}
> > diff --git a/scrub/phase4.c b/scrub/phase4.c
> > index 3100d75..1fb8da9 100644
> > --- a/scrub/phase4.c
> > +++ b/scrub/phase4.c
> > @@ -62,25 +62,6 @@ xfs_repair_fs(
> >  	return xfs_process_action_items(ctx);
> >  }
> >  
> > -/* Run the optimize-only phase if there are no errors. */
> > -bool
> > -xfs_optimize_fs(
> > -	struct scrub_ctx	*ctx)
> > -{
> > -	/*
> > -	 * In preen mode, corruptions are immediately recorded as errors,
> > -	 * so if there are any corruptions on the filesystem errors_found
> > -	 * will be non-zero and we won't do anything.
> > -	 */
> > -	if (ctx->errors_found) {
> > -		str_info(ctx, ctx->mntpoint,
> > -_("Errors found, please re-run with -y."));
> > -		return true;
> > -	}
> > -
> > -	return xfs_process_action_items(ctx);
> > -}
> > -
> >  /* Estimate how much work we're going to do. */
> >  bool
> >  xfs_estimate_repair_work(
> > diff --git a/scrub/scrub.c b/scrub/scrub.c
> > index 6abca2a..bc0e2f0 100644
> > --- a/scrub/scrub.c
> > +++ b/scrub/scrub.c
> > @@ -279,7 +279,7 @@ _("Repairs are required."));
> >  	 * otherwise complain.
> >  	 */
> >  	if (is_unoptimized(meta)) {
> > -		if (ctx->mode < SCRUB_MODE_PREEN) {
> > +		if (ctx->mode != SCRUB_MODE_REPAIR) {
> >  			if (!is_inode) {
> >  				/* AG or FS metadata, always warn. */
> >  				str_info(ctx, buf,
> > diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> > index 5ab557d..6efcf77 100644
> > --- a/scrub/xfs_scrub.c
> > +++ b/scrub/xfs_scrub.c
> > @@ -187,7 +187,6 @@ usage(void)
> >  	fprintf(stderr, _("  -v           Verbose output.\n"));
> >  	fprintf(stderr, _("  -V           Print version.\n"));
> >  	fprintf(stderr, _("  -x           Scrub file data too.\n"));
> > -	fprintf(stderr, _("  -y           Repair all errors.\n"));
> >  
> >  	exit(SCRUB_RET_SYNTAX);
> >  }
> > @@ -441,16 +440,11 @@ run_scrub_phases(
> >  		/* Turn on certain phases if user said to. */
> >  		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
> >  			sp->fn = xfs_scan_blocks;
> > -		} else if (sp->fn == REPAIR_DUMMY_FN) {
> > -			if (ctx->mode == SCRUB_MODE_PREEN) {
> > -				sp->descr = _("Optimize filesystem.");
> > -				sp->fn = xfs_optimize_fs;
> > -				sp->must_run = true;
> > -			} else if (ctx->mode == SCRUB_MODE_REPAIR) {
> > -				sp->descr = _("Repair filesystem.");
> > -				sp->fn = xfs_repair_fs;
> > -				sp->must_run = true;
> > -			}
> > +		} else if (sp->fn == REPAIR_DUMMY_FN &&
> > +			   ctx->mode == SCRUB_MODE_REPAIR) {
> > +			sp->descr = _("Repair filesystem.");
> > +			sp->fn = xfs_repair_fs;
> > +			sp->must_run = true;
> >  		}
> >  
> >  		/* Skip certain phases unless they're turned on. */
> > @@ -524,9 +518,9 @@ main(
> >  	textdomain(PACKAGE);
> >  
> >  	pthread_mutex_init(&ctx.lock, NULL);
> > -	ctx.mode = SCRUB_MODE_DEFAULT;
> > +	ctx.mode = SCRUB_MODE_REPAIR;
> >  	ctx.error_action = ERRORS_CONTINUE;
> > -	while ((c = getopt(argc, argv, "a:bC:de:km:nTvxVy")) != EOF) {
> > +	while ((c = getopt(argc, argv, "a:bC:de:km:nTvxV")) != EOF) {
> >  		switch (c) {
> >  		case 'a':
> >  			ctx.max_errors = cvt_u64(optarg, 10);
> > @@ -574,11 +568,6 @@ main(
> >  			mtab = optarg;
> >  			break;
> >  		case 'n':
> > -			if (ctx.mode != SCRUB_MODE_DEFAULT) {
> > -				fprintf(stderr,
> > -_("Only one of the options -n or -y may be specified.\n"));
> > -				usage();
> > -			}
> >  			ctx.mode = SCRUB_MODE_DRY_RUN;
> >  			break;
> >  		case 'T':
> > @@ -595,14 +584,6 @@ _("Only one of the options -n or -y may be specified.\n"));
> >  		case 'x':
> >  			scrub_data = true;
> >  			break;
> > -		case 'y':
> > -			if (ctx.mode != SCRUB_MODE_DEFAULT) {
> > -				fprintf(stderr,
> > -_("Only one of the options -n or -y may be specified.\n"));
> > -				usage();
> > -			}
> > -			ctx.mode = SCRUB_MODE_REPAIR;
> > -			break;
> >  		case '?':
> >  			/* fall through */
> >  		default:
> > diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
> > index 8407885..89b46a4 100644
> > --- a/scrub/xfs_scrub.h
> > +++ b/scrub/xfs_scrub.h
> > @@ -34,10 +34,8 @@ extern bool			stdout_isatty;
> >  
> >  enum scrub_mode {
> >  	SCRUB_MODE_DRY_RUN,
> > -	SCRUB_MODE_PREEN,
> >  	SCRUB_MODE_REPAIR,
> >  };
> > -#define SCRUB_MODE_DEFAULT			SCRUB_MODE_PREEN
> >  
> >  enum error_action {
> >  	ERRORS_CONTINUE,
> > @@ -111,7 +109,6 @@ bool xfs_scan_connections(struct scrub_ctx *ctx);
> >  bool xfs_scan_blocks(struct scrub_ctx *ctx);
> >  bool xfs_scan_summary(struct scrub_ctx *ctx);
> >  bool xfs_repair_fs(struct scrub_ctx *ctx);
> > -bool xfs_optimize_fs(struct scrub_ctx *ctx);
> >  
> >  /* Progress estimator functions */
> >  uint64_t xfs_estimate_inodes(struct scrub_ctx *ctx);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

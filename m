Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43382 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752563AbeEHNzQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 May 2018 09:55:16 -0400
Subject: Re: [PATCH] xfs_db: add -R option
References: <20180504140244.GA32161@deer-run.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <db080bb2-a649-fbb3-ec91-d16f00ad30f0@sandeen.net>
Date: Tue, 8 May 2018 08:55:14 -0500
MIME-Version: 1.0
In-Reply-To: <20180504140244.GA32161@deer-run.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hal@deer-run.com, linux-xfs@vger.kernel.org

On 5/4/18 9:02 AM, hal@deer-run.com wrote:
> From: Hal Pomeranz <hal@deer-run.com>
> 
> -R is similar to -r, but allows for blockget on a mounted file system
> or "dirty" file system image with pending log entries.

Hm, so this probably makes it possible that blockget will wander off into
inconsistencies and fail; there's a /reason/ for the check.  So if anything
this is probably best-effort.  I doubt you can rely on blockget even completing
without error, let alone being correct.  In that case, is it still useful
to you?

Of course if you simply desire to not perturb the image you're analyzing
you'd be operating on a copy in any case, and so that's presumably not the
issue here; I assume you wish to analyze the state of the filesystem before
any log changes are applied.

What sort of information do you hope to gather after running blockget without
a replay?

I guess what I'm getting at here is yes, we could short-circuit the check
in one way or another, but I want to be sure that it really would advance
your goals.

In any case:

Using -r seems a bit odd; blockget is already a readonly operation, so
using "-r" / readonly as a modifier seems out of place.  (The same warning
would come up for -c check).

Given that xfs_db is a command for experts, and forensics analysis on an
unreplayed filesystem even more so, what about modifying the logformat
command to allow zeroing of a dirty log with some type of force option,
which would then allow blkget to proceed?  (assuming you were working on
a copy, of course.)  That would make things pretty explicit.

Is that too convoluted?

Otherwise I might suggest adding a switch specific to the blockget_f
function, which would just skip the sb_logcheck() altogether.  That would
be more targeted, and wouldn't be some global switch which affects
every current and future caller of sb_logcheck.  A warning about how
the log is being ignored and results may be inconsistent could then
be added specifically to blockget_f.

-Eric

>  This makes
> xfs_db more useful for forensics where we are often dealing with these
> types of images.  Flushing log entries to disk by mounting/unmounting
> the file system would allow us to use blockget, but would make changes
> to the file system state which are not desirable in forensics
> contexts.
> 
> Signed-off-by: Hal Pomeranz <hal@deer-run.com>
> ---
>  db/init.c         | 7 +++++--
>  db/init.h         | 1 +
>  db/sb.c           | 2 +-
>  man/man8/xfs_db.8 | 8 ++++++++
>  4 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/db/init.c b/db/init.c
> index 29fc344..96a0e78 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -36,6 +36,7 @@ int			blkbb;
>  int			exitcode;
>  int			expert_mode;
>  int			force;
> +int                     ignore_dirty;
>  struct xfs_mount	xmount;
>  struct xfs_mount	*mp;
>  struct xlog		xlog;
> @@ -46,7 +47,7 @@ static void
>  usage(void)
>  {
>  	fprintf(stderr, _(
> -		"Usage: %s [-ifFrxV] [-p prog] [-l logdev] [-c cmd]... device\n"
> +		"Usage: %s [-ifFrRxV] [-p prog] [-l logdev] [-c cmd]... device\n"
>  		), progname);
>  	exit(1);
>  }
> @@ -66,7 +67,7 @@ init(
>  	textdomain(PACKAGE);
>  
>  	progname = basename(argv[0]);
> -	while ((c = getopt(argc, argv, "c:fFip:rxVl:")) != EOF) {
> +	while ((c = getopt(argc, argv, "c:fFip:rRxVl:")) != EOF) {
>  		switch (c) {
>  		case 'c':
>  			cmdline = xrealloc(cmdline, (ncmdline+1)*sizeof(char*));
> @@ -84,6 +85,8 @@ init(
>  		case 'p':
>  			progname = optarg;
>  			break;
> +		case 'R':
> +		        ignore_dirty = 1;
>  		case 'r':
>  			x.isreadonly = LIBXFS_ISREADONLY;
>  			break;
> diff --git a/db/init.h b/db/init.h
> index b09389e..f6bfda9 100644
> --- a/db/init.h
> +++ b/db/init.h
> @@ -20,6 +20,7 @@ extern char		*fsdevice;
>  extern int		blkbb;
>  extern int		exitcode;
>  extern int		expert_mode;
> +extern int              ignore_dirty;
>  extern xfs_mount_t	*mp;
>  extern libxfs_init_t	x;
>  extern xfs_agnumber_t	cur_agno;
> diff --git a/db/sb.c b/db/sb.c
> index c7fbfd6..4c04d79 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -251,7 +251,7 @@ sb_logcheck(void)
>  	if (dirty == -1) {
>  		dbprintf(_("ERROR: cannot find log head/tail, run xfs_repair\n"));
>  		return 0;
> -	} else if (dirty == 1) {
> +	} else if (dirty == 1 && ignore_dirty == 0) {
>  		dbprintf(_(
>  "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
>  "be replayed.  Mount the filesystem to replay the log, and unmount it before\n"
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 524b1ef..89be1aa 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -90,6 +90,14 @@ It is only necessary to omit this flag if a command that changes data
>  .RB ( write ", " blocktrash ", " crc )
>  is to be used.
>  .TP
> +.B -R
> +Like
> +.B -r
> +but allows the 
> +.B blockget
> +command even if the file system is "dirty" (unreconciled transactions
> +in the log).
> +.TP
>  .B \-x
>  Specifies expert mode.
>  This enables the
> 

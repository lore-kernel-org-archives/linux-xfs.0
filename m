Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46300 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933791AbeEWVvJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 May 2018 17:51:09 -0400
Subject: Re: [PATCH v3] xfs_io: Allow -P and -L to be given to open for O_PATH
 and O_NOFOLLOW
References: <20180516132738.27776-1-jlayton@kernel.org>
 <20180516171428.25576-1-jlayton@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7a2485bc-de36-e3c5-58ab-4023b965c6c5@sandeen.net>
Date: Wed, 23 May 2018 16:51:08 -0500
MIME-Version: 1.0
In-Reply-To: <20180516171428.25576-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-xfs@vger.kernel.org, dhowells@redhat.com



On 5/16/18 12:14 PM, Jeff Layton wrote:
> From: David Howells <dhowells@redhat.com>
> 
> Allow "open -P" to specify O_PATH so that paths which would otherwise be
> unopenable might be opened for stat()'ing.  Such things include files that
> would incur an access error or device files for which no corresponding
> driver is available.
> 
> Allow "-L" to be given in conjunction with O_PATH to specify O_NOFOLLOW
> also.
> 
> We also have to avoid calling xfsctl() if O_PATH is given as ioctls are
> forbidden on such fds.  This means we cannot retrieve the geometry
> information on an XFS filesystem, so the record gets cleared instead.  For
> the moment, only the xfsctl() calls in the 'open' command are
> conditionalised.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>   io/file.c         |  6 ++++--
>   io/init.c         |  8 +++++++-
>   io/io.h           |  2 ++
>   io/open.c         | 29 +++++++++++++++++++++++++----
>   man/man8/xfs_io.8 | 12 +++++++++++-
>   5 files changed, 49 insertions(+), 8 deletions(-)
> 
> v3: print new options in print_fileio
>      handle -P and -L in init()
> 
> diff --git a/io/file.c b/io/file.c
> index 349b19cdc420..b7edf6ef841f 100644
> --- a/io/file.c
> +++ b/io/file.c
> @@ -35,7 +35,7 @@ print_fileio(
>   	int		index,
>   	int		braces)
>   {
> -	printf(_("%c%03d%c %-14s (%s,%s,%s,%s%s%s%s%s)\n"),
> +	printf(_("%c%03d%c %-14s (%s,%s,%s,%s%s%s%s%s%s%s)\n"),
>   		braces? '[' : ' ', index, braces? ']' : ' ', file->name,
>   		file->flags & IO_FOREIGN ? _("foreign") : _("xfs"),
>   		file->flags & IO_OSYNC ? _("sync") : _("non-sync"),
> @@ -44,7 +44,9 @@ print_fileio(
>   		file->flags & IO_REALTIME ? _(",real-time") : "",
>   		file->flags & IO_APPEND ? _(",append-only") : "",
>   		file->flags & IO_NONBLOCK ? _(",non-block") : "",
> -		file->flags & IO_TMPFILE ? _(",tmpfile") : "");
> +		file->flags & IO_TMPFILE ? _(",tmpfile") : "",
> +		file->flags & IO_PATH ? _(",path") : "",
> +		file->flags & IO_NOFOLLOW ? _(",nofollow") : "");
>   }
>   
>   int
> diff --git a/io/init.c b/io/init.c
> index 0336c9623beb..d54a2fb957cf 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -154,7 +154,7 @@ init(
>   	gettimeofday(&stopwatch, NULL);
>   
>   	fs_table_initialise(0, NULL, 0, NULL);
> -	while ((c = getopt(argc, argv, "ac:C:dFfim:p:nrRstTVx")) != EOF) {
> +	while ((c = getopt(argc, argv, "ac:C:dFfiLm:p:PnrRstTVx")) != EOF) {
>   		switch (c) {
>   		case 'a':
>   			flags |= IO_APPEND;
> @@ -200,6 +200,12 @@ init(
>   		case 't':
>   			flags |= IO_TRUNC;
>   			break;
> +		case 'P':
> +			flags |= IO_PATH;
> +			break;
> +		case 'L':
> +			flags |= IO_NOFOLLOW;
> +			break;
>   		case 'R':
>   			flags |= IO_REALTIME;
>   			break;
> diff --git a/io/io.h b/io/io.h
> index a26763610877..f2569588b28f 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -40,6 +40,8 @@
>   #define IO_FOREIGN	(1<<7)
>   #define IO_NONBLOCK	(1<<8)
>   #define IO_TMPFILE	(1<<9)
> +#define IO_PATH		(1<<10)
> +#define IO_NOFOLLOW	(1<<11)
>   
>   /*
>    * Regular file I/O control
> diff --git a/io/open.c b/io/open.c
> index 2cce0455263a..7cda47cc85dd 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -74,6 +74,10 @@ openfile(
>   		oflags |= O_NONBLOCK;
>   	if (flags & IO_TMPFILE)
>   		oflags |= O_TMPFILE;
> +	if (flags & IO_PATH)
> +		oflags |= O_PATH;
> +	if (flags & IO_NOFOLLOW)
> +		oflags |= O_NOFOLLOW;
>   
>   	fd = open(path, oflags, mode);
>   	if (fd < 0) {
> @@ -97,13 +101,16 @@ openfile(
>   	if (!geom || !platform_test_xfs_fd(fd))
>   		return fd;
>   
> -	if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
> +	if (flags & IO_PATH) {
> +		/* Can't call ioctl() on O_PATH fds */
> +		memset(geom, 0, sizeof(*geom));
> +	} else if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
>   		perror("XFS_IOC_FSGEOMETRY");
>   		close(fd);
>   		return -1;
>   	}
>   
> -	if (!(flags & IO_READONLY) && (flags & IO_REALTIME)) {
> +	if (!(flags & (IO_READONLY | IO_PATH)) && (flags & IO_REALTIME)) {
>   		struct fsxattr	attr;
>   
>   		if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &attr) < 0) {
> @@ -191,6 +198,8 @@ open_help(void)
>   " -t -- open with O_TRUNC (truncate the file to zero length if it exists)\n"
>   " -R -- mark the file as a realtime XFS file immediately after opening it\n"
>   " -T -- open with O_TMPFILE (create a file not visible in the namespace)\n"
> +" -P -- open with O_PATH (create an fd that is merely a location reference)\n"
> +" -L -- open with O_NOFOLLOW (don't follow symlink)\n"
>   " Note1: usually read/write direct IO requests must be blocksize aligned;\n"
>   "        some kernels, however, allow sectorsize alignment for direct IO.\n"
>   " Note2: the bmap for non-regular files can be obtained provided the file\n"
> @@ -216,7 +225,7 @@ open_f(
>   		return 0;
>   	}
>   
> -	while ((c = getopt(argc, argv, "FRTacdfm:nrstx")) != EOF) {
> +	while ((c = getopt(argc, argv, "FLPRTacdfm:nrstx")) != EOF) {
>   		switch (c) {
>   		case 'F':
>   			/* Ignored / deprecated now, handled automatically */
> @@ -257,6 +266,12 @@ open_f(
>   		case 'T':
>   			flags |= IO_TMPFILE;
>   			break;
> +		case 'P':
> +			flags |= IO_PATH;
> +			break;
> +		case 'L':
> +			flags |= IO_NOFOLLOW;
> +			break;
>   		default:
>   			return command_usage(&open_cmd);
>   		}
> @@ -270,6 +285,12 @@ open_f(
>   		return -1;
>   	}
>   
> +	if ((flags & (IO_PATH|IO_NOFOLLOW)) &&
> +	    (flags & ~(IO_PATH|IO_NOFOLLOW))) {
> +		fprintf(stderr, _("-P and -L are incompatible with the other options\n"));
> +		return -1;
> +	}
> +
>   	fd = openfile(argv[optind], &geometry, flags, mode, &fsp);
>   	if (fd < 0)
>   		return 0;
> @@ -785,7 +806,7 @@ open_init(void)
>   	open_cmd.argmax = -1;
>   	open_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK |
>   			 CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
> -	open_cmd.args = _("[-acdrstxT] [-m mode] [path]");
> +	open_cmd.args = _("[-acdrstxRTPL] [-m mode] [path]");
>   	open_cmd.oneline = _("open the file specified by path");
>   	open_cmd.help = open_help;
>   
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index c3ab532da03f..a49d067100fe 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -122,7 +122,7 @@ command for more details on any command.
>   Display a list of all open files and (optionally) switch to an alternate
>   current open file.
>   .TP
> -.BI "open [[ \-acdfrstRT ] " path " ]"
> +.BI "open [[ \-acdfrstRTPL ] " path " ]"
>   Closes the current file, and opens the file specified by
>   .I path
>   instead. Without any arguments, displays statistics about the current
> @@ -164,6 +164,16 @@ option.
>   .B \-R
>   marks the file as a realtime XFS file after
>   opening it, if it is not already marked as such.
> +.TP
> +.B \-P
> +opens the path as a referent only (O_PATH).  This is incompatible with other
> +flags specifying other O_xxx flags apart from
> +.BR \-L .
> +.TP
> +.B \-L
> +doesn't follow symlinks (O_NOFOLLOW).  This is incompatible with other
> +flags specifying other O_xxx flags apart from
> +.BR \-P .
>   .PD
>   .RE
>   .TP
> 

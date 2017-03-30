Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58576 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933240AbdC3Q3Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Mar 2017 12:29:24 -0400
Subject: Re: [PATCH] xfs_io: Allow "open -P" to specify O_PATH
References: <29183.1490711359@warthog.procyon.org.uk>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2377cb3d-60e9-3c7a-2a32-68ef7d9a6d5a@sandeen.net>
Date: Thu, 30 Mar 2017 12:29:20 -0400
MIME-Version: 1.0
In-Reply-To: <29183.1490711359@warthog.procyon.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>
Cc: Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org

On 3/28/17 10:29 AM, David Howells wrote:
> xfs_io: Allow "open -P" to specify O_PATH
> 
> Allow "open -P" to specify O_PATH so that paths which would otherwise be
> unopenable might be opened for stat()'ing.  Such things include files that
> would incur an access error or device files for which no corresponding
> driver is available.

Given all the trouble you ran into with this (and I guess I'm not too surprised),
it might make more sense to change stat_f() and statx_f() to be able
to take a pathname separate from the target pathname on the xfs_io
commandline, i.e. something like:

xfs_io -c "stat foo"

instead of 

xfs_io -P -c "stat" foo

-Eric

> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>  io/io.h           |    1 +
>  io/open.c         |   13 ++++++++++++-
>  man/man8/xfs_io.8 |    6 +++++-
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/io/io.h b/io/io.h
> index 952bdb8..b49a133 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -38,6 +38,7 @@
>  #define IO_FOREIGN	(1<<7)
>  #define IO_NONBLOCK	(1<<8)
>  #define IO_TMPFILE	(1<<9)
> +#define IO_PATH		(1<<10)
>  
>  /*
>   * Regular file I/O control
> diff --git a/io/open.c b/io/open.c
> index 2ed55cf..9eba8ae 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -72,6 +72,8 @@ openfile(
>  		oflags |= O_NONBLOCK;
>  	if (flags & IO_TMPFILE)
>  		oflags |= O_TMPFILE;
> +	if (flags & IO_PATH)
> +		oflags |= O_PATH;
>  
>  	fd = open(path, oflags, mode);
>  	if (fd < 0) {
> @@ -179,6 +181,7 @@ open_help(void)
>  " -t -- open with O_TRUNC (truncate the file to zero length if it exists)\n"
>  " -R -- mark the file as a realtime XFS file immediately after opening it\n"
>  " -T -- open with O_TMPFILE (create a file not visible in the namespace)\n"
> +" -P -- open with O_PATH (create an fd that is merely a location reference)\n"
>  " Note1: usually read/write direct IO requests must be blocksize aligned;\n"
>  "        some kernels, however, allow sectorsize alignment for direct IO.\n"
>  " Note2: the bmap for non-regular files can be obtained provided the file\n"
> @@ -203,7 +206,7 @@ open_f(
>  		return 0;
>  	}
>  
> -	while ((c = getopt(argc, argv, "FRTacdfm:nrstx")) != EOF) {
> +	while ((c = getopt(argc, argv, "FPRTacdfm:nrstx")) != EOF) {
>  		switch (c) {
>  		case 'F':
>  			/* Ignored / deprecated now, handled automatically */
> @@ -244,6 +247,9 @@ open_f(
>  		case 'T':
>  			flags |= IO_TMPFILE;
>  			break;
> +		case 'P':
> +			flags |= IO_PATH;
> +			break;
>  		default:
>  			return command_usage(&open_cmd);
>  		}
> @@ -257,6 +263,11 @@ open_f(
>  		return -1;
>  	}
>  
> +	if ((flags & IO_PATH) && (flags & ~IO_PATH)) {
> +		fprintf(stderr, _("-P is incompatible with other options\n"));
> +		return -1;
> +	}
> +
>  	fd = openfile(argv[optind], &geometry, flags, mode);
>  	if (fd < 0)
>  		return 0;
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 022f0ea..77ba760 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -122,7 +122,7 @@ command for more details on any command.
>  Display a list of all open files and (optionally) switch to an alternate
>  current open file.
>  .TP
> -.BI "open [[ \-acdfrstRT ] " path " ]"
> +.BI "open [[ \-acdfrstRTP ] " path " ]"
>  Closes the current file, and opens the file specified by
>  .I path
>  instead. Without any arguments, displays statistics about the current
> @@ -164,6 +164,10 @@ option.
>  .B \-R
>  marks the file as a realtime XFS file after
>  opening it, if it is not already marked as such.
> +.TP
> +.B \-P
> +opens the path as a referent only (O_PATH).  This is incompatible with other
> +flags specifying other O_xxx flags.
>  .PD
>  .RE
>  .TP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

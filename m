Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51938 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752252AbcLTUXI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Dec 2016 15:23:08 -0500
Subject: Re: [PATCH v2] xfs_io: implement 'utimes' command
References: <1482202286-8390-1-git-send-email-deepa.kernel@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0e2f1ec8-c81b-ddea-825c-0e7a8684e117@sandeen.net>
Date: Tue, 20 Dec 2016 14:23:07 -0600
MIME-Version: 1.0
In-Reply-To: <1482202286-8390-1-git-send-email-deepa.kernel@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Deepa Dinamani <deepa.kernel@gmail.com>, linux-xfs@vger.kernel.org
Cc: arnd@arndb.de, y2038@lists.linaro.org

On 12/19/16 8:51 PM, Deepa Dinamani wrote:
> Add the utimes command to provide a way to utilize
> the futimens C library call. This is the
> interface to the utimensat system call, which updates
> the mtime and atime of a file.
> 
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>

Looks fine, thanks

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> Changes since v1:
> * changed error return values
> * removed redundant roff formatting directive
> * removed unneeded argument count check
> 
>  include/input.h   |  1 +
>  io/Makefile       |  2 +-
>  io/init.c         |  1 +
>  io/io.h           |  1 +
>  io/utimes.c       | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  libxcmd/input.c   | 22 +++++++++++++++
>  man/man8/xfs_io.8 | 11 ++++++++
>  7 files changed, 118 insertions(+), 1 deletion(-)
>  create mode 100755 io/utimes.c
>  mode change 100644 => 100755 libxcmd/input.c
> 
> diff --git a/include/input.h b/include/input.h
> index d02170f..221678e 100644
> --- a/include/input.h
> +++ b/include/input.h
> @@ -48,6 +48,7 @@ extern uid_t	uid_from_string(char *user);
>  extern gid_t	gid_from_string(char *group);
>  extern prid_t	prid_from_string(char *project);
>  extern bool	isdigits_only(const char *str);
> +extern int	timespec_from_string(const char *sec, const char *nsec, struct timespec *ts);
>  
>  #define HAVE_FTW_H 1	/* TODO: configure me */
>  
> diff --git a/io/Makefile b/io/Makefile
> index 62bc03b..392e02a 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -11,7 +11,7 @@ HFILES = init.h io.h
>  CFILES = init.c \
>  	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c link.c \
>  	mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
> -	sync.c truncate.c reflink.c
> +	sync.c truncate.c reflink.c utimes.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
> diff --git a/io/init.c b/io/init.c
> index efe7390..6319aeb 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -85,6 +85,7 @@ init_commands(void)
>  	sync_range_init();
>  	truncate_init();
>  	reflink_init();
> +	utimes_init();
>  }
>  
>  static int
> diff --git a/io/io.h b/io/io.h
> index 2bc7ac4..fddd7a3 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -113,6 +113,7 @@ extern void		seek_init(void);
>  extern void		shutdown_init(void);
>  extern void		sync_init(void);
>  extern void		truncate_init(void);
> +extern void		utimes_init(void);
>  
>  #ifdef HAVE_FADVISE
>  extern void		fadvise_init(void);
> diff --git a/io/utimes.c b/io/utimes.c
> new file mode 100755
> index 0000000..faf9b8d
> --- /dev/null
> +++ b/io/utimes.c
> @@ -0,0 +1,81 @@
> +/*
> + * Copyright (c) 2016 Deepa Dinamani
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +#include "command.h"
> +#include "input.h"
> +#include "init.h"
> +#include "io.h"
> +
> +static cmdinfo_t utimes_cmd;
> +
> +static void
> +utimes_help(void)
> +{
> +	printf(_(
> +"\n"
> +" Update file atime and mtime of the current file with nansecond precision.\n"
> +"\n"
> +" Usage: utimes atime_sec atime_nsec mtime_sec mtime_nsec.\n"
> +" *_sec: Seconds elapsed since 1970-01-01 00:00:00 UTC.\n"
> +" *_nsec: Nanoseconds since the corresponding *_sec.\n"
> +"\n"));
> +}
> +
> +static int
> +utimes_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	struct timespec t[2];
> +	int result;
> +
> +	/* Get the timestamps */
> +	result = timespec_from_string(argv[1], argv[2], &t[0]);
> +	if (result) {
> +		fprintf(stderr, "Bad value for atime\n");
> +		return 0;
> +	}
> +	result = timespec_from_string(argv[3], argv[4], &t[1]);
> +	if (result) {
> +		fprintf(stderr, "Bad value for mtime\n");
> +		return 0;
> +	}
> +
> +	/* Call futimens to update time. */
> +	if (futimens(file->fd, t)) {
> +		perror("futimens");
> +		return 0;
> +	}
> +
> +	return 0;
> +}
> +
> +void
> +utimes_init(void)
> +{
> +	utimes_cmd.name = "utimes";
> +	utimes_cmd.cfunc = utimes_f;
> +	utimes_cmd.argmin = 4;
> +	utimes_cmd.argmax = 4;
> +	utimes_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	utimes_cmd.args = _("atime_sec atime_nsec mtime_sec mtime_nsec");
> +	utimes_cmd.oneline = _("Update file times of the current file");
> +	utimes_cmd.help = utimes_help;
> +
> +	add_command(&utimes_cmd);
> +}
> diff --git a/libxcmd/input.c b/libxcmd/input.c
> old mode 100644
> new mode 100755
> index 5a7dce3..8aeb3b0
> --- a/libxcmd/input.c
> +++ b/libxcmd/input.c
> @@ -327,6 +327,28 @@ timestr(
>  }
>  
>  /*
> + * Convert from a pair of arbitrary user strings into a timespec.
> + */
> +
> +int
> +timespec_from_string(
> +	const char	* secs,
> +	const char	* nsecs,
> +	struct timespec	* ts)
> +{
> +	char* p;
> +	if (!secs || !nsecs || !ts)
> +		return 1;
> +	ts->tv_sec = strtoull(secs, &p, 0);
> +	if (*p)
> +		return 1;
> +	ts->tv_nsec = strtoull(nsecs, &p, 0);
> +	if (*p)
> +		return 1;
> +	return 0;
> +}
> +
> +/*
>   * Convert from arbitrary user strings into a numeric ID.
>   * If it's all numeric, we convert that inplace, else we do
>   * the name lookup, and return the found identifier.
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 2c56f09..9efb7b2 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -589,6 +589,16 @@ Copy data into the open file beginning at
>  Copy up to
>  .I length
>  bytes of data.
> +.RE
> +.PD
> +.TP
> +.BI utimes " atime_sec atime_nsec mtime_sec mtime_nsec"
> +The utimes command changes the atime and mtime of the current file.
> +sec uses UNIX timestamp notation and is the seconds elapsed since
> +1970-01-01 00:00:00 UTC.
> +nsec is the nanoseconds since the sec. This value needs to be in
> +the range 0-999999999 with UTIME_NOW and UTIME_OMIT being exceptions.
> +Each (sec, nsec) pair constitutes a single timestamp value.
>  
>  .SH MEMORY MAPPED I/O COMMANDS
>  .TP
> @@ -875,6 +885,7 @@ verbose output will be printed.
>  .BR fstatfs (2),
>  .BR fsync (2),
>  .BR ftruncate (2),
> +.BR futimens (3),
>  .BR mmap (2),
>  .BR msync (2),
>  .BR open (2),
> 

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NCLCFV043597 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 07:21:14 -0500
Date: Tue, 23 Oct 2012 08:22:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_io: add the lseek() SEEK_DATA/SEEK_HOLE support
Message-ID: <20121023122250.GA7341@infradead.org>
References: <20121022213759.033667921@sgi.com>
	<20121022213804.616209844@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121022213804.616209844@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

In addition to Dave's comments: can we get a testcase for this support
into xfstests?

On Mon, Oct 22, 2012 at 04:38:00PM -0500, Mark Tinguely wrote:
> Add the lseek() SEEK_DATA/SEEK_HOLE support into xfs_io.
> The result from the lseek() call is printed to the output:
>   xfs_io> lseek -h 609k
>   lseek for hole starting at offset 623616 result offset 630784
> 
> Configure this feature only on Linux distributions that support
> SEEK_DATA/SEEK_HOLE.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com> 
> ---
>  configure.in          |    1 
>  include/builddefs.in  |    1 
>  io/Makefile           |    5 ++
>  io/init.c             |    1 
>  io/io.h               |    6 ++
>  io/lseek.c            |  101 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  m4/package_libcdev.m4 |   15 +++++++
>  man/man8/xfs_io.8     |    7 +++
>  8 files changed, 137 insertions(+)
> 
> Index: b/configure.in
> ===================================================================
> --- a/configure.in
> +++ b/configure.in
> @@ -109,6 +109,7 @@ AC_HAVE_GETMNTINFO
>  AC_HAVE_FALLOCATE
>  AC_HAVE_FIEMAP
>  AC_HAVE_PREADV
> +AC_HAVE_LSEEK_DATA
>  AC_HAVE_SYNC_FILE_RANGE
>  AC_HAVE_BLKID_TOPO($enable_blkid)
>  
> Index: b/include/builddefs.in
> ===================================================================
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -102,6 +102,7 @@ HAVE_GETMNTINFO = @have_getmntinfo@
>  HAVE_FALLOCATE = @have_fallocate@
>  HAVE_FIEMAP = @have_fiemap@
>  HAVE_PREADV = @have_preadv@
> +HAVE_LSEEK_DATA = @have_lseek_data@
>  HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
>  
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
> Index: b/io/Makefile
> ===================================================================
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -80,6 +80,11 @@ ifeq ($(HAVE_PREADV),yes)
>  LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV
>  endif
>  
> +ifeq ($(HAVE_LSEEK_DATA),yes)
> +LCFLAGS += -DHAVE_LSEEK_DATA
> +CFILES += lseek.c
> +endif
> +
>  default: depend $(LTCOMMAND)
>  
>  include $(BUILDRULES)
> Index: b/io/init.c
> ===================================================================
> --- a/io/init.c
> +++ b/io/init.c
> @@ -64,6 +64,7 @@ init_commands(void)
>  	help_init();
>  	imap_init();
>  	inject_init();
> +	lseek_init();
>  	madvise_init();
>  	mincore_init();
>  	mmap_init();
> Index: b/io/io.h
> ===================================================================
> --- a/io/io.h
> +++ b/io/io.h
> @@ -108,6 +108,12 @@ extern void		quit_init(void);
>  extern void		shutdown_init(void);
>  extern void		truncate_init(void);
>  
> +#ifdef HAVE_LSEEK_DATA
> +extern void		lseek_init(void);
> +#else
> +#define lseek_init()	do { } while (0)
> +#endif
> +
>  #ifdef HAVE_FADVISE
>  extern void		fadvise_init(void);
>  #else
> Index: b/io/lseek.c
> ===================================================================
> --- /dev/null
> +++ b/io/lseek.c
> @@ -0,0 +1,101 @@
> +/*
> + * Copyright (c) 2012 SGI
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
> +#define _LARGEFILE64_SOURCE     /* See feature_test_macros(7) */
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include <linux/fs.h>
> +
> +#include <sys/uio.h>
> +#include <xfs/xfs.h>
> +#include <xfs/command.h>
> +#include <xfs/input.h>
> +#include <ctype.h>
> +#include "init.h"
> +#include "io.h"
> +
> +static cmdinfo_t lseek_cmd;
> +
> +static void
> +lseek_help(void)
> +{
> +	printf(_(
> +"\n"
> +" returns the next hole or data offset at or after the specified offset\n"
> +"\n"
> +" Example:\n"
> +" 'lseek -d 512'  - offset of data at or following offset 512\n"
> +"\n"
> +" Repositions and returns the offset of either the next data or hole.\n"
> +" There is an implied hole at the end of file. If the specified offset is\n"
> +" past end of file, or there is no data past the specied offset, the offset\n"
> +" -1 is returned.\n"
> +" -d   -- search for data starting at the specified offset.\n"
> +" -h   -- search for a hole starting at the specified offset.\n"
> +"\n"));
> +}
> +
> +static int
> +lseek_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	off64_t		offset, res_off;
> +	size_t          fsblocksize, fssectsize;
> +	int		flag;
> +	int		c;
> +
> +	flag = 0;
> +	init_cvtnum(&fsblocksize, &fssectsize);
> +
> +	while ((c = getopt(argc, argv, "dh")) != EOF) {
> +		switch (c) {
> +		case 'd':
> +			flag = SEEK_DATA;
> +			break;
> +		case 'h':
> +			flag = SEEK_HOLE;
> +			break;
> +		default:
> +			return command_usage(&lseek_cmd);
> +		}
> +	}
> +	if (!flag  || optind > 2)
> +		return command_usage(&lseek_cmd);
> +	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +	res_off = lseek64(file->fd, offset, flag);
> +	printf("lseek for %s starting at offset %lld result offset %lld\n",
> +		(flag == SEEK_DATA) ? "data" : "hole",	offset, res_off);
> +	return 0;
> +}
> +
> +void
> +lseek_init(void)
> +{
> +	lseek_cmd.name = "lseek";
> +	lseek_cmd.altname = "seek";
> +	lseek_cmd.cfunc = lseek_f;
> +	lseek_cmd.argmin = 2;
> +	lseek_cmd.argmax = 2;
> +	lseek_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	lseek_cmd.args = _("[-d | -h] off");
> +	lseek_cmd.oneline = _("locate and postition to next data or hole");
> +	lseek_cmd.help = lseek_help;
> +
> +	add_command(&lseek_cmd);
> +}
> Index: b/m4/package_libcdev.m4
> ===================================================================
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -153,6 +153,21 @@ AC_DEFUN([AC_HAVE_PREADV],
>      AC_SUBST(have_preadv)
>    ])
>  
> +# 
> +# Check if we have a working fadvise system call
> +# 
> +AC_DEFUN([AC_HAVE_LSEEK_DATA],
> +  [ AC_MSG_CHECKING([for lseek SEEK_DATA])
> +    AC_TRY_COMPILE([
> +#include <linux/fs.h>
> +    ], [
> +	lseek(0, 0, SEEK_DATA);
> +    ],	have_lseek_data=yes
> +	AC_MSG_RESULT(yes),
> +	AC_MSG_RESULT(no))
> +    AC_SUBST(have_lseek_data)
> +  ])
> +
>  #
>  # Check if we have a sync_file_range libc call (Linux)
>  #
> Index: b/man/man8/xfs_io.8
> ===================================================================
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -377,6 +377,13 @@ must be specified as another open file
>  .RB ( \-f )
>  or by path
>  .RB ( \-i ).
> +.TP
> +.BI "lseek [ \-b " offset " | \-h " offset " ]
> +Repositions and prints the file pointer to the next offset containing data
> +.RB ( \-d )
> +or next offset containing a hole 
> +.RB ( \-h )
> +.TP
>  
>  .SH MEMORY MAPPED I/O COMMANDS
>  .TP
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

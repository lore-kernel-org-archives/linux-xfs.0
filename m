Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C5F387F7E
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 16:50:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53F66AC007
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 14:50:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6LWBKYdPGoF8DM1X (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Oct 2014 14:50:37 -0700 (PDT)
Date: Mon, 27 Oct 2014 17:50:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs_io: add sync and syncfs commands
Message-ID: <20141027215033.GA62546@bfoster.bfoster>
References: <544A9511.70500@redhat.com>
 <544E951B.9030600@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <544E951B.9030600@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 27, 2014 at 01:55:23PM -0500, Eric Sandeen wrote:
> There's no easy way to invoke syncfs from the commandline,
> as far as I know, so add it to xfs_io to be handy.
> 
> Add sync while we're at it, just for completeness.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks good to me.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> V2: sync doesn't need to have a file open
> 
> diff --git a/io/Makefile b/io/Makefile
> index c16af87..82593a6 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -11,7 +11,7 @@ HFILES = init.h io.h
>  CFILES = init.c \
>  	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c link.c \
>  	mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
> -	truncate.c
> +	sync.c truncate.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
> @@ -64,6 +64,10 @@ CFILES += sync_file_range.c
>  LCFLAGS += -DHAVE_SYNC_FILE_RANGE
>  endif
>  
> +ifeq ($(HAVE_SYNCFS),yes)
> +LCFLAGS += -DHAVE_SYNCFS
> +endif
> +
>  ifeq ($(ENABLE_READLINE),yes)
>  LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
>  endif
> diff --git a/io/init.c b/io/init.c
> index bfc35bf..1b07518 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -80,8 +80,9 @@ init_commands(void)
>  	resblks_init();
>  	sendfile_init();
>  	shutdown_init();
> -	truncate_init();
> +	sync_init();
>  	sync_range_init();
> +	truncate_init();
>  }
>  
>  static int
> diff --git a/io/io.h b/io/io.h
> index 1b3bca1..db8b513 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -109,6 +109,7 @@ extern void		pwrite_init(void);
>  extern void		quit_init(void);
>  extern void		seek_init(void);
>  extern void		shutdown_init(void);
> +extern void		sync_init(void);
>  extern void		truncate_init(void);
>  
>  #ifdef HAVE_FADVISE
> diff --git a/io/sync.c b/io/sync.c
> new file mode 100644
> index 0000000..683899b
> --- /dev/null
> +++ b/io/sync.c
> @@ -0,0 +1,70 @@
> +/*
> + * Copyright (c) 2014 Red Hat, Inc.
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
> +#include <xfs/xfs.h>
> +#include <xfs/command.h>
> +#include "init.h"
> +#include "io.h"
> +
> +static cmdinfo_t sync_cmd;
> +
> +static int
> +sync_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	/* sync can't fail */
> +	sync();
> +	return 0;
> +}
> +
> +#ifdef HAVE_SYNCFS
> +static cmdinfo_t syncfs_cmd;
> +
> +static int
> +syncfs_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	/* syncfs can't fail */
> +	syncfs(file->fd);
> +	return 0;
> +}
> +#endif
> +
> +void
> +sync_init(void)
> +{
> +	sync_cmd.name = "sync";
> +	sync_cmd.cfunc = sync_f;
> +	sync_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK | CMD_FOREIGN_OK;
> +	sync_cmd.oneline =
> +		_("calls sync(2) to flush all in-core filesystem state to disk");
> +
> +	add_command(&sync_cmd);
> +
> +#ifdef HAVE_SYNCFS
> +	syncfs_cmd.name = "syncfs";
> +	syncfs_cmd.cfunc = syncfs_f;
> +	syncfs_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	syncfs_cmd.oneline =
> +		_("calls syncfs(2) to flush all in-core filesystem state to disk");
> +
> +	add_command(&syncfs_cmd);
> +#endif
> +}
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 8267ba0..919ae0a 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -171,6 +171,23 @@ AC_DEFUN([AC_HAVE_SYNC_FILE_RANGE],
>    ])
>  
>  #
> +# Check if we have a syncfs libc call (Linux)
> +#
> +AC_DEFUN([AC_HAVE_SYNCFS],
> +  [ AC_MSG_CHECKING([for syncfs])
> +    AC_TRY_LINK([
> +#define _GNU_SOURCE
> +#define _FILE_OFFSET_BITS 64
> +#include <unistd.h>
> +    ], [
> +         syncfs(0);
> +    ], have_sync_fs=yes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(have_syncfs)
> +  ])
> +
> +#
>  # Check if we have a readdir libc call
>  #
>  AC_DEFUN([AC_HAVE_READDIR],
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index e40fbf9..cf27b99 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -362,6 +362,16 @@ start writeback of dirty data in the given range (SYNC_FILE_RANGE_WRITE).
>  .RE
>  .PD
>  .TP
> +.B sync
> +Calls
> +.BR sync (2)
> +to flush all filesystems' in-core data to disk.
> +.TP
> +.B syncfs
> +Calls
> +.BR syncfs (2)
> +to flush this filesystem's in-core data to disk.
> +.TP
>  .BI resvsp " offset length"
>  Allocates reserved, unwritten space for part of a file using the
>  XFS_IOC_RESVSP system call described in the
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

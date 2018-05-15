Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39208 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbeEOUMb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 16:12:31 -0400
Date: Tue, 15 May 2018 13:12:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5 V2] xfs_io: add label command
Message-ID: <20180515201209.GK4933@magnolia>
References: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
 <ef558e14-5b31-4c5a-a07c-3d2ac67dd993@redhat.com>
 <0f9a7c17-233c-042a-5449-acd7e0a27316@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f9a7c17-233c-042a-5449-acd7e0a27316@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, May 15, 2018 at 10:32:22AM -0500, Eric Sandeen wrote:
> This adds a get/set label command to xfs_io.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Set exitcode rather than error return on ioctl failure
>     fix ioctl definitions o_O :)
> 
> diff --git a/io/Makefile b/io/Makefile
> index 88e47517..b40156da 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -10,9 +10,9 @@ LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
>  HFILES = init.h io.h
>  CFILES = init.c \
>  	attr.c bmap.c cowextsize.c encrypt.c file.c freeze.c fsync.c \
> -	getrusage.c imap.c link.c mmap.c open.c parent.c pread.c prealloc.c \
> -	pwrite.c reflink.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
> -	truncate.c utimes.c
> +	getrusage.c imap.c label.c link.c mmap.c open.c parent.c pread.c \
> +	prealloc.c pwrite.c reflink.c scrub.c seek.c shutdown.c stat.c \
> +	swapext.c sync.c truncate.c utimes.c
>  LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
> diff --git a/io/init.c b/io/init.c
> index 0336c962..612962e8 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -72,6 +72,7 @@ init_commands(void)
>  	help_init();
>  	imap_init();
>  	inject_init();
> +	label_init();
>  	log_writes_init();
>  	madvise_init();
>  	mincore_init();
> diff --git a/io/io.h b/io/io.h
> index a2676361..7f8197ca 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -109,6 +109,7 @@ extern void		getrusage_init(void);
>  extern void		help_init(void);
>  extern void		imap_init(void);
>  extern void		inject_init(void);
> +extern void		label_init(void);
>  extern void		mmap_init(void);
>  extern void		open_init(void);
>  extern void		parent_init(void);
> diff --git a/io/label.c b/io/label.c
> new file mode 100644
> index 00000000..7eeab324
> --- /dev/null
> +++ b/io/label.c
> @@ -0,0 +1,75 @@
> +/*
> + * Copyright (c) 2018 Red Hat, Inc.
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
> +#include <sys/ioctl.h>
> +#include <sys/mount.h>
> +#include "platform_defs.h"
> +#include "libxfs.h"
> +#include "path.h"
> +#include "command.h"
> +#include "init.h"
> +#include "io.h"
> +
> +#ifndef FS_IOC_GETFSLABEL
> +/* Max chars for the interface; fs limits may differ */
> +#define FSLABEL_MAX 256
> +#define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
> +#define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
> +#endif
> +
> +static cmdinfo_t label_cmd;
> +
> +static int
> +label_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	int		error;
> +	char		label[FSLABEL_MAX];
> +
> +	if (argc == 1) {
> +		memset(label, 0, sizeof(label));
> +		error = ioctl(file->fd, FS_IOC_GETFSLABEL, &label);
> +	} else {
> +		strncpy(label, argv[1], sizeof(label));
> +		error = ioctl(file->fd, FS_IOC_SETFSLABEL, label);
> +	}
> +
> +	if (error) {
> +		perror("label");
> +		exitcode = 1;
> +	} else
> +		printf("label = \"%s\"\n", label);
> +
> +	return 0;
> +}
> +
> +void
> +label_init(void)
> +{
> +	label_cmd.name = "label";
> +	label_cmd.cfunc = label_f;
> +	label_cmd.argmin = 0;
> +	label_cmd.argmax = 1;
> +	label_cmd.args = _("[label]");
> +	label_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	label_cmd.oneline =
> +		_("query or set the filesystem label while mounted");
> +
> +	add_command(&label_cmd);
> +}
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index c3ab532d..52b983d5 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -1175,6 +1175,16 @@ This is intended to be equivalent to the shell command:
>  See the
>  .B log_writes
>  command.
> +.TP
> +.BI "label" " " [ " label " ]
> +On  filesystems  that  support  online label manipulation, set or get the

Only need one space between wor... oh there I go about whitespace again. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> +filesystem label.  With no options, get the current filesystem label.
> +With one option, set the filesystem label to
> +.IR label .
> +If the label is longer than the filesystem will accept,
> +.B xfs_io
> +will print an error message.  XFS filesystem labels can be at most 12
> +characters long, excluding any terminating NULL.
>  .SH SEE ALSO
>  .BR mkfs.xfs (8),
>  .BR xfsctl (3),
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

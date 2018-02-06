Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59326 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753105AbeBFRcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Feb 2018 12:32:19 -0500
Date: Tue, 6 Feb 2018 09:32:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_io: support a basic extent swap command
Message-ID: <20180206173213.GM4849@magnolia>
References: <20180206130247.61882-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180206130247.61882-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 06, 2018 at 08:02:47AM -0500, Brian Foster wrote:
> Extent swap is a low level mechanism exported by XFS to facilitate
> filesystem defragmentation. It is typically invoked by xfs_fsr under
> conditions that will atomically adjust inode extent state without
> loss of file data.
> 
> xfs_fsr does not provide the necessary controls for low-level
> testing of the extent swap command, however. For example, xfs_fsr
> implements policies that dictate when to perform an extent swap and
> offers no control over the donor file characteristics.
> 
> Add a basic swapext command to xfs_io that allows userspace
> invocation of the command under more controlled conditions. This
> command makes no effort to retain data across the operation. As
> such, it is primarily for testing purposes (i.e., in support of
> xfstests, etc.).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This command is in support of an xfstests test to be posted shortly...
> 
> Brian
> 
>  io/Makefile  |   3 +-
>  io/init.c    |   1 +
>  io/io.h      |   1 +
>  io/swapext.c | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 111 insertions(+), 1 deletion(-)
>  create mode 100644 io/swapext.c
> 
> diff --git a/io/Makefile b/io/Makefile
> index 6725936d..2f9249e8 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -11,7 +11,8 @@ HFILES = init.h io.h
>  CFILES = init.c \
>  	attr.c bmap.c cowextsize.c encrypt.c file.c freeze.c fsync.c \
>  	getrusage.c imap.c link.c mmap.c open.c parent.c pread.c prealloc.c \
> -	pwrite.c reflink.c seek.c shutdown.c stat.c sync.c truncate.c utimes.c
> +	pwrite.c reflink.c seek.c shutdown.c stat.c swapext.c sync.c \
> +	truncate.c utimes.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
> diff --git a/io/init.c b/io/init.c
> index 20d5f80d..2ade03f4 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -88,6 +88,7 @@ init_commands(void)
>  	sendfile_init();
>  	shutdown_init();
>  	stat_init();
> +	swapext_init();
>  	sync_init();
>  	sync_range_init();
>  	truncate_init();
> diff --git a/io/io.h b/io/io.h
> index 3862985f..258311f1 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -118,6 +118,7 @@ extern void		quit_init(void);
>  extern void		seek_init(void);
>  extern void		shutdown_init(void);
>  extern void		stat_init(void);
> +extern void		swapext_init(void);
>  extern void		sync_init(void);
>  extern void		truncate_init(void);
>  extern void		utimes_init(void);
> diff --git a/io/swapext.c b/io/swapext.c
> new file mode 100644
> index 00000000..5e161d69
> --- /dev/null
> +++ b/io/swapext.c
> @@ -0,0 +1,107 @@
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
> +#include "command.h"
> +#include "input.h"
> +#include "init.h"
> +#include "io.h"
> +
> +static cmdinfo_t swapext_cmd;
> +
> +static void
> +swapext_help(void)
> +{
> +	printf(_(
> +"\n"
> +" Swaps extents between the open file descriptor and the supplied filename.\n"

An update to the xfs_io manpage is needed, but this otherwise looks ok to me.

--D

> +"\n"));
> +}
> +
> +static int
> +xfs_bulkstat_single(
> +	int			fd,
> +	xfs_ino_t		*lastip,
> +	struct xfs_bstat	*ubuffer)
> +{
> +	struct xfs_fsop_bulkreq	bulkreq;
> +
> +	bulkreq.lastip = (__u64 *)lastip;
> +	bulkreq.icount = 1;
> +	bulkreq.ubuffer = ubuffer;
> +	bulkreq.ocount = NULL;
> +	return ioctl(fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
> +}
> +
> +static int
> +swapext_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	int			fd;
> +	int			error;
> +	struct xfs_swapext	sx;
> +	struct stat		stat;
> +
> +	/* open the donor file */
> +	fd = openfile(argv[1], NULL, 0, 0, NULL);
> +	if (fd < 0)
> +		return 0;
> +
> +	/*
> +	 * stat the target file to get the inode number and use the latter to
> +	 * get the bulkstat info for the swapext cmd.
> +	 */
> +	error = fstat(file->fd, &stat);
> +	if (error) {
> +		perror("fstat");
> +		goto out;
> +	}
> +
> +	error = xfs_bulkstat_single(file->fd, &stat.st_ino, &sx.sx_stat);
> +	if (error) {
> +		perror("bulkstat");
> +		goto out;
> +	}
> +	sx.sx_version = XFS_SX_VERSION;
> +	sx.sx_fdtarget = file->fd;
> +	sx.sx_fdtmp = fd;
> +	sx.sx_offset = 0;
> +	sx.sx_length = stat.st_size;
> +	error = ioctl(file->fd, XFS_IOC_SWAPEXT, &sx);
> +	if (error)
> +		perror("swapext");
> +
> +out:
> +	close(fd);
> +	return 0;
> +}
> +
> +void
> +swapext_init(void)
> +{
> +	swapext_cmd.name = "swapext";
> +	swapext_cmd.cfunc = swapext_f;
> +	swapext_cmd.argmin = 1;
> +	swapext_cmd.argmax = 1;
> +	swapext_cmd.flags = CMD_NOMAP_OK;
> +	swapext_cmd.args = _("<donorfile>");
> +	swapext_cmd.oneline = _("Swap extents between files.");
> +	swapext_cmd.help = swapext_help;
> +
> +	add_command(&swapext_cmd);
> +}
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

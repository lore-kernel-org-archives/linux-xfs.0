Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59528 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751108AbdFUVMn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 17:12:43 -0400
Subject: Re: [PATCH 07/12] xfs_spaceman: space management tool
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
 <149755899206.3625.14837747293278221142.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9cc65b68-634a-61f1-fd1e-1c7b1f6f2a01@sandeen.net>
Date: Wed, 21 Jun 2017 16:12:41 -0500
MIME-Version: 1.0
In-Reply-To: <149755899206.3625.14837747293278221142.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On 6/15/17 3:36 PM, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_spaceman is intended as a diagnostic and control tool for space
> management operations within XFS. Operations like examining free
> space, managing allocation policies, issuing block discards on free
> space, etc.
> 
> The tool is modelled on the xfs_io interface, allowing both
> interactive and command line control of the tool, enabling it to be
> used in scripts and automated management tools.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [darrick: change xfsctl to ioctl]
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  Makefile          |    3 +
>  spaceman/Makefile |   33 ++++++++++++++
>  spaceman/file.c   |  122 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  spaceman/init.c   |  113 +++++++++++++++++++++++++++++++++++++++++++++++++
>  spaceman/init.h   |   24 ++++++++++
>  spaceman/space.h  |   38 +++++++++++++++++
>  6 files changed, 332 insertions(+), 1 deletion(-)
>  create mode 100644 spaceman/Makefile
>  create mode 100644 spaceman/file.c
>  create mode 100644 spaceman/init.c
>  create mode 100644 spaceman/init.h
>  create mode 100644 spaceman/space.h
> 
> 
> diff --git a/Makefile b/Makefile
> index ba87327..72d0044 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -47,7 +47,7 @@ HDR_SUBDIRS = include libxfs
>  DLIB_SUBDIRS = libxlog libxcmd libhandle
>  LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
>  TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
> -		mdrestore repair rtcp m4 man doc debian
> +		mdrestore repair rtcp m4 man doc debian spaceman
>  
>  ifneq ("$(PKG_PLATFORM)","darwin")
>  TOOL_SUBDIRS += fsr
> @@ -88,6 +88,7 @@ quota: libxcmd
>  repair: libxlog libxcmd
>  copy: libxlog
>  mkfs: libxcmd
> +spaceman: libxcmd
>  
>  ifeq ($(HAVE_BUILDDEFS), yes)
>  include $(BUILDRULES)
> diff --git a/spaceman/Makefile b/spaceman/Makefile
> new file mode 100644
> index 0000000..df59edf
> --- /dev/null
> +++ b/spaceman/Makefile
> @@ -0,0 +1,33 @@
> +#
> +# Copyright (c) 2012 Red Hat, Inc.  All Rights Reserved.
> +#
> +
> +TOPDIR = ..
> +include $(TOPDIR)/include/builddefs
> +
> +LTCOMMAND = xfs_spaceman
> +HFILES = init.h space.h
> +CFILES = init.c file.c
> +
> +LLDLIBS = $(LIBXCMD)
> +LTDEPENDENCIES = $(LIBXCMD)
> +LLDFLAGS = -static
> +
> +ifeq ($(ENABLE_READLINE),yes)
> +LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
> +endif
> +
> +ifeq ($(ENABLE_EDITLINE),yes)
> +LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
> +endif
> +
> +default: depend $(LTCOMMAND)
> +
> +include $(BUILDRULES)
> +
> +install: default
> +	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
> +	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
> +install-dev:
> +
> +-include .dep
> diff --git a/spaceman/file.c b/spaceman/file.c
> new file mode 100644
> index 0000000..beca5ba
> --- /dev/null
> +++ b/spaceman/file.c
> @@ -0,0 +1,122 @@
> +/*
> + * Copyright (c) 2004-2005 Silicon Graphics, Inc.
> + * Copyright (c) 2012 Red Hat, Inc.
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
> +#include "libxfs.h"
> +#include <sys/mman.h>
> +#include "command.h"
> +#include "input.h"
> +#include "init.h"
> +#include "space.h"
> +
> +static cmdinfo_t print_cmd;
> +
> +fileio_t	*filetable;
> +int		filecount;
> +fileio_t	*file;
> +
> +static void
> +print_fileio(
> +	fileio_t	*file,
> +	int		index,
> +	int		braces)
> +{
> +	printf(_("%c%03d%c %-14s\n"), braces? '[' : ' ', index,
> +			braces? ']' : ' ', file->name);
> +}
> +
> +static int
> +print_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	int		i;
> +
> +	for (i = 0; i < filecount; i++)
> +		print_fileio(&filetable[i], i, &filetable[i] == file);
> +	return 0;
> +}
> +
> +int
> +openfile(
> +	char		*path,
> +	xfs_fsop_geom_t	*geom)
> +{
> +	int		fd;
> +
> +	fd = open(path, 0);
> +	if (fd < 0) {
> +		perror(path);
> +		return -1;
> +	}
> +
> +	if (ioctl(fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
> +		perror("XFS_IOC_FSGEOMETRY");
> +		close(fd);
> +		return -1;
> +	}
> +	return fd;
> +}
> +
> +int
> +addfile(
> +	char		*name,
> +	int		fd,
> +	xfs_fsop_geom_t	*geometry)
> +{
> +	char		*filename;
> +
> +	filename = strdup(name);
> +	if (!filename) {
> +		perror("strdup");
> +		close(fd);
> +		return -1;
> +	}
> +
> +	/* Extend the table of currently open files */
> +	filetable = (fileio_t *)realloc(filetable,	/* growing */
> +					++filecount * sizeof(fileio_t));
> +	if (!filetable) {
> +		perror("realloc");
> +		filecount = 0;
> +		free(filename);
> +		close(fd);
> +		return -1;
> +	}
> +
> +	/* Finally, make this the new active open file */
> +	file = &filetable[filecount - 1];
> +	file->fd = fd;
> +	file->name = filename;
> +	file->geom = *geometry;
> +	return 0;
> +}
> +
> +void
> +print_init(void)
> +{
> +	print_cmd.name = "print";
> +	print_cmd.altname = "p";
> +	print_cmd.cfunc = print_f;
> +	print_cmd.argmin = 0;
> +	print_cmd.argmax = 0;
> +	print_cmd.flags = CMD_FLAG_ONESHOT;
> +	print_cmd.oneline = _("list current open files");
> +
> +	add_command(&print_cmd);
> +}
> diff --git a/spaceman/init.c b/spaceman/init.c
> new file mode 100644
> index 0000000..8cbfbda
> --- /dev/null
> +++ b/spaceman/init.c
> @@ -0,0 +1,113 @@
> +/*
> + * Copyright (c) 2012 Red Hat, Inc
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
> +#include "libxfs.h"
> +#include "command.h"
> +#include "input.h"
> +#include "init.h"
> +#include "space.h"
> +
> +char	*progname;
> +int	exitcode;
> +
> +void
> +usage(void)
> +{
> +	fprintf(stderr,
> +		_("Usage: %s [-c cmd] file\n"),
> +		progname);
> +	exit(1);
> +}
> +
> +static void
> +init_commands(void)
> +{
> +	print_init();
> +	help_init();
> +	quit_init();
> +}
> +
> +static int
> +init_args_command(
> +	int	index)
> +{
> +	if (index >= filecount)
> +		return 0;
> +	file = &filetable[index++];
> +	return index;
> +}
> +
> +static int
> +init_check_command(
> +	const cmdinfo_t	*ct)
> +{
> +	if (!(ct->flags & CMD_FLAG_ONESHOT))
> +		return 0;
> +	return 1;
> +}
> +
> +void
> +init(
> +	int		argc,
> +	char		**argv)
> +{
> +	int		c;
> +	xfs_fsop_geom_t	geometry = { 0 };
> +
> +	progname = basename(argv[0]);
> +	setlocale(LC_ALL, "");
> +	bindtextdomain(PACKAGE, LOCALEDIR);
> +	textdomain(PACKAGE);
> +
> +	while ((c = getopt(argc, argv, "c:V")) != EOF) {
> +		switch (c) {
> +		case 'c':
> +			add_user_command(optarg);
> +			break;
> +		case 'V':
> +			printf(_("%s version %s\n"), progname, VERSION);
> +			exit(0);
> +		default:
> +			usage();
> +		}
> +	}
> +
> +	if (optind != argc - 1)
> +		usage();
> +
> +	if ((c = openfile(argv[optind], &geometry)) < 0)
> +		exit(1);
> +	if (!platform_test_xfs_fd(c))
> +		printf(_("Not an XFS filesystem!\n"));
> +	if (addfile(argv[optind], c, &geometry) < 0)
> +		exit(1);
> +
> +	init_commands();
> +	add_command_iterator(init_args_command);
> +	add_check_command(init_check_command);
> +}
> +
> +int
> +main(
> +	int	argc,
> +	char	**argv)
> +{
> +	init(argc, argv);
> +	command_loop();
> +	return exitcode;
> +}
> diff --git a/spaceman/init.h b/spaceman/init.h
> new file mode 100644
> index 0000000..e9c25be
> --- /dev/null
> +++ b/spaceman/init.h
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (c) 2012 Red Hat, Inc.
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
> +#ifndef XFS_SPACEMAN_INIT_H_
> +#define XFS_SPACEMAN_INIT_H_
> +
> +extern char	*progname;
> +extern int	exitcode;
> +
> +#endif /* XFS_SPACEMAN_INIT_H_ */
> diff --git a/spaceman/space.h b/spaceman/space.h
> new file mode 100644
> index 0000000..7bfe874
> --- /dev/null
> +++ b/spaceman/space.h
> @@ -0,0 +1,38 @@
> +/*
> + * Copyright (c) 2012 Red Hat, Inc.
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
> +#ifndef XFS_SPACEMAN_SPACE_H_
> +#define XFS_SPACEMAN_SPACE_H_
> +
> +typedef struct fileio {
> +	xfs_fsop_geom_t	geom;		/* XFS filesystem geometry */
> +	char		*name;		/* file name at time of open */
> +	int		fd;		/* open file descriptor */
> +} fileio_t;
> +
> +extern fileio_t		*filetable;	/* open file table */
> +extern int		filecount;	/* number of open files */
> +extern fileio_t		*file;		/* active file in file table */
> +
> +extern int	openfile(char *, xfs_fsop_geom_t *);
> +extern int	addfile(char *, int , xfs_fsop_geom_t *);
> +
> +extern void	print_init(void);
> +extern void	help_init(void);
> +extern void	quit_init(void);
> +
> +#endif /* XFS_SPACEMAN_SPACE_H_ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

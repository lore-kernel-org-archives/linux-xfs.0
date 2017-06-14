Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40731 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751800AbdFNQQx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2017 12:16:53 -0400
Date: Wed, 14 Jun 2017 09:16:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/10] xfs_spaceman: space management tool
Message-ID: <20170614161644.GR4530@birch.djwong.org>
References: <149643307433.15899.922559884171553380.stgit@birch.djwong.org>
 <149643310508.15899.8647641887998046926.stgit@birch.djwong.org>
 <1d4675d8-eec7-22cd-0180-bad5ac230cde@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d4675d8-eec7-22cd-0180-bad5ac230cde@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Wed, Jun 14, 2017 at 09:15:49AM -0500, Eric Sandeen wrote:
> On 6/2/17 2:51 PM, Darrick J. Wong wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_spaceman is intended as a diagnostic and control tool for space
> > management operations within XFS. Operations like examining free
> > space, managing allocation policies, issuing block discards on free
> > space, etc.
> > 
> > The tool is modelled on the xfs_io interface, allowing both
> > interactive and command line control of the tool, enabling it to be
> > used in scripts and automated management tools.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > [darrick: change xfsctl to ioctl]
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  Makefile          |    3 +
> >  spaceman/Makefile |   33 ++++++++++++
> >  spaceman/file.c   |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  spaceman/init.c   |  114 +++++++++++++++++++++++++++++++++++++++++
> >  spaceman/init.h   |   23 ++++++++
> >  spaceman/space.h  |   36 +++++++++++++
> >  6 files changed, 357 insertions(+), 1 deletion(-)
> >  create mode 100644 spaceman/Makefile
> >  create mode 100644 spaceman/file.c
> >  create mode 100644 spaceman/init.c
> >  create mode 100644 spaceman/init.h
> >  create mode 100644 spaceman/space.h
> > 
> > 
> > diff --git a/Makefile b/Makefile
> > index ba87327..72d0044 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -47,7 +47,7 @@ HDR_SUBDIRS = include libxfs
> >  DLIB_SUBDIRS = libxlog libxcmd libhandle
> >  LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
> >  TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
> > -		mdrestore repair rtcp m4 man doc debian
> > +		mdrestore repair rtcp m4 man doc debian spaceman
> >  
> >  ifneq ("$(PKG_PLATFORM)","darwin")
> >  TOOL_SUBDIRS += fsr
> > @@ -88,6 +88,7 @@ quota: libxcmd
> >  repair: libxlog libxcmd
> >  copy: libxlog
> >  mkfs: libxcmd
> > +spaceman: libxcmd
> >  
> >  ifeq ($(HAVE_BUILDDEFS), yes)
> >  include $(BUILDRULES)
> > diff --git a/spaceman/Makefile b/spaceman/Makefile
> > new file mode 100644
> > index 0000000..df59edf
> > --- /dev/null
> > +++ b/spaceman/Makefile
> > @@ -0,0 +1,33 @@
> > +#
> > +# Copyright (c) 2012 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +
> > +TOPDIR = ..
> > +include $(TOPDIR)/include/builddefs
> > +
> > +LTCOMMAND = xfs_spaceman
> > +HFILES = init.h space.h
> > +CFILES = init.c file.c
> > +
> > +LLDLIBS = $(LIBXCMD)
> > +LTDEPENDENCIES = $(LIBXCMD)
> > +LLDFLAGS = -static
> > +
> > +ifeq ($(ENABLE_READLINE),yes)
> > +LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
> > +endif
> > +
> > +ifeq ($(ENABLE_EDITLINE),yes)
> > +LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
> > +endif
> > +
> > +default: depend $(LTCOMMAND)
> > +
> > +include $(BUILDRULES)
> > +
> > +install: default
> > +	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
> > +	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
> > +install-dev:
> > +
> > +-include .dep
> > diff --git a/spaceman/file.c b/spaceman/file.c
> > new file mode 100644
> > index 0000000..9356066
> > --- /dev/null
> > +++ b/spaceman/file.c
> > @@ -0,0 +1,149 @@
> > +/*
> > + * Copyright (c) 2004-2005 Silicon Graphics, Inc.
> > + * Copyright (c) 2012 Red Hat, Inc.
> > + * All Rights Reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > + */
> > +
> > +#include "libxfs.h"
> > +#include <sys/mman.h>
> > +#include "command.h"
> > +#include "input.h"
> > +#include "init.h"
> > +#include "space.h"
> > +
> > +static cmdinfo_t print_cmd;
> > +
> > +fileio_t	*filetable;
> > +int		filecount;
> > +fileio_t	*file;
> > +
> > +static void
> > +print_fileio(
> > +	fileio_t	*file,
> > +	int		index,
> > +	int		braces)
> > +{
> > +	printf(_("%c%03d%c %-14s (%s,%s,%s%s%s)\n"),
> > +		braces? '[' : ' ', index, braces? ']' : ' ', file->name,
> > +		file->flags & O_SYNC ? _("sync") : _("non-sync"),
> 
> Ok, my question last round about this didn't get answered:
> 
> [xfsprogs-fsmap]# spaceman/xfs_spaceman -c print mnt/
> [000] mnt/           (non-sync,non-direct,read-write)
> 
> [xfsprogs-fsmap]# mount -o remount,ro mnt
> 
> [xfsprogs-fsmap]# spaceman/xfs_spaceman -c print mnt/
> [000] mnt/           (non-sync,non-direct,read-write)
> 
> I don't see that these flags have any meaning; indeed, the flags argument
> to openfile() and addfile() is initialized to 0 and never changed.  Should
> it just be removed?
> 
> If you want to get things merged and clean stuff up with a later patch,
> that's ok by me, or we could remove them now.  It's not really a functionality
> problem so I'm not too bothered.

I don't think any of these flags matter for spaceman, I'll just remove
the fd flags reporting.

> > +		file->flags & O_DIRECT ? _("direct") : _("non-direct"),
> > +		file->flags & O_RDONLY ? _("read-only") : _("read-write"),

FWIW I'm not sure how this /ever/ works, since "#define O_RDONLY 0".

> > +		file->flags & O_APPEND ? _(",append-only") : "",
> > +		file->flags & O_NONBLOCK ? _(",non-block") : "");
> > +}
> > +
> > +int
> > +filelist_f(void)
> > +{
> > +	int		i;
> > +
> > +	for (i = 0; i < filecount; i++)
> > +		print_fileio(&filetable[i], i, &filetable[i] == file);
> > +	return 0;
> > +}
> > +
> > +static int
> > +print_f(
> > +	int		argc,
> > +	char		**argv)
> > +{
> > +	filelist_f();
> 
> No need for the separate filelist_f, just put the guts here, it has no other
> caller.
> 
> Hm, actually ... for consistency with xfs_io should we have both "file" and "print?"
> 
>        file [ N ]
>               Display a list of all open files and (optionally) switch to an alternate current open file.
> 
>        print  Display a list of all open files and memory mapped regions.  The current file and current mapping are distinguishable from  any others.
> 
> Again not overly concerned about this, just pointing it out - if it's modeled on xfs_io behavior, let's keep it as similar as possible.
> 
> (If this gets changed, don't forget the manpage)

I'll just get rid of the weird print_f -> filelist_f indirection since
spaceman doesn't have a 'file' command anymore anyway.

> 
> > +	return 0;
> > +}
> > +
> > +int
> > +openfile(
> > +	char		*path,
> > +	xfs_fsop_geom_t	*geom,
> > +	int		flags,
> 
> flags is always called with flags == 0, so all the flag testing below is pointless -
> and probably doesn't relate to filesystem-wide operations anyway.

I'll get rid of mode too, since we don't use it either.

> 
> > +	mode_t		mode)
> > +{
> > +	int		fd;
> > +
> > +	fd = open(path, flags, mode);
> > +	if (fd < 0) {
> > +		if ((errno == EISDIR) && (flags & O_RDWR)) {
> > +			/* make it as if we asked for O_RDONLY & try again */
> > +			flags &= ~O_RDWR;
> > +			flags |= O_RDONLY;
> > +			fd = open(path, flags, mode);
> > +			if (fd < 0) {
> > +				perror(path);
> > +				return -1;
> > +			}
> > +		} else {
> > +			perror(path);
> > +			return -1;
> > +		}
> > +	}
> > +
> > +	if (ioctl(fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
> > +		perror("XFS_IOC_FSGEOMETRY");
> > +		close(fd);
> > +		return -1;
> > +	}
> > +	return fd;
> > +}
> > +
> > +int
> > +addfile(
> > +	char		*name,
> > +	int		fd,
> > +	xfs_fsop_geom_t	*geometry,
> > +	int		flags)
> > +{
> > +	char		*filename;
> > +
> > +	filename = strdup(name);
> > +	if (!filename) {
> > +		perror("strdup");
> > +		close(fd);
> > +		return -1;
> > +	}
> > +
> > +	/* Extend the table of currently open files */
> > +	filetable = (fileio_t *)realloc(filetable,	/* growing */
> > +					++filecount * sizeof(fileio_t));
> 
> Are you keeping all the filetable stuff with the thought that maybe some 
> day we'll allow operation on multiple filesystems?  Probably a good idea.

Yes.

> > +	if (!filetable) {
> > +		perror("realloc");
> > +		filecount = 0;
> > +		free(filename);
> > +		close(fd);
> > +		return -1;
> > +	}
> > +
> > +	/* Finally, make this the new active open file */
> > +	file = &filetable[filecount - 1];
> > +	file->fd = fd;
> > +	file->flags = flags;
> > +	file->name = filename;
> > +	file->geom = *geometry;
> > +	return 0;
> > +}
> > +
> > +void
> > +file_init(void)
> > +{
> 
> file_init setting up print_cmd is confusing - unless you want both ala xfs_io,
> I'd go consistently with either "print" or "file" but not a mishmash.

Ok, print_init it is.
> 
> > +	print_cmd.name = "print";
> > +	print_cmd.altname = "p";
> > +	print_cmd.cfunc = print_f;
> > +	print_cmd.argmin = 0;
> > +	print_cmd.argmax = 0;
> > +	print_cmd.flags = CMD_FLAG_ONESHOT;
> > +	print_cmd.oneline = _("list current open files");
> > +
> > +	add_command(&print_cmd);
> > +}
> > diff --git a/spaceman/init.c b/spaceman/init.c
> > new file mode 100644
> > index 0000000..5dbaef2
> > --- /dev/null
> > +++ b/spaceman/init.c
> > @@ -0,0 +1,114 @@
> > +/*
> > + * Copyright (c) 2012 Red Hat, Inc
> > + * All Rights Reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > + */
> > +
> > +#include "libxfs.h"
> > +#include "command.h"
> > +#include "input.h"
> > +#include "init.h"
> > +#include "space.h"
> > +
> > +char	*progname;
> > +int	exitcode;
> > +
> > +void
> > +usage(void)
> > +{
> > +	fprintf(stderr,
> > +		_("Usage: %s [-c cmd] file\n"),
> > +		progname);
> > +	exit(1);
> > +}
> > +
> > +static void
> > +init_commands(void)
> > +{
> > +	file_init();
> > +	help_init();
> > +	quit_init();
> > +}
> > +
> > +static int
> > +init_args_command(
> > +	int	index)
> > +{
> > +	if (index >= filecount)
> > +		return 0;
> > +	file = &filetable[index++];
> > +	return index;
> > +}
> > +
> > +static int
> > +init_check_command(
> > +	const cmdinfo_t	*ct)
> > +{
> > +	if (!(ct->flags & CMD_FLAG_ONESHOT))
> > +		return 0;
> > +	return 1;
> > +}
> > +
> > +void
> > +init(
> > +	int		argc,
> > +	char		**argv)
> > +{
> > +	int		c, flags = 0;
> > +	mode_t		mode = 0600;
> > +	xfs_fsop_geom_t	geometry = { 0 };
> > +
> > +	progname = basename(argv[0]);
> > +	setlocale(LC_ALL, "");
> > +	bindtextdomain(PACKAGE, LOCALEDIR);
> > +	textdomain(PACKAGE);
> > +
> > +	while ((c = getopt(argc, argv, "c:V")) != EOF) {
> > +		switch (c) {
> > +		case 'c':
> > +			add_user_command(optarg);
> > +			break;
> > +		case 'V':
> > +			printf(_("%s version %s\n"), progname, VERSION);
> > +			exit(0);
> > +		default:
> > +			usage();
> > +		}
> > +	}
> > +
> > +	if (optind != argc - 1)
> > +		usage();
> > +
> > +	if ((c = openfile(argv[optind], &geometry, flags, mode)) < 0)
> > +		exit(1);
> > +	if (!platform_test_xfs_fd(c))
> > +		printf(_("Not an XFS filesystem!\n"));
> > +	if (addfile(argv[optind], c, &geometry, flags) < 0)
> > +		exit(1);
> > +
> > +	init_commands();
> > +	add_command_iterator(init_args_command);
> > +	add_check_command(init_check_command);
> > +}
> > +
> > +int
> > +main(
> > +	int	argc,
> > +	char	**argv)
> > +{
> > +	init(argc, argv);
> > +	command_loop();
> > +	return exitcode;
> > +}
> > diff --git a/spaceman/init.h b/spaceman/init.h
> > new file mode 100644
> > index 0000000..165e4f5
> > --- /dev/null
> > +++ b/spaceman/init.h
> > @@ -0,0 +1,23 @@
> > +/*
> > + * Copyright (c) 2012 Red Hat, Inc.
> > + * All Rights Reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > + */
> > +
> > +extern char	*progname;
> > +extern int	exitcode;
> > +
> > +#define min(a,b)	(((a)<(b))?(a):(b))
> > +#define max(a,b)	(((a)>(b))?(a):(b))
> 
> these aren't actually used, FWIW.

Deleted.

Also realizing that these header files don't have ifndef guards; will
add those too.

> > diff --git a/spaceman/space.h b/spaceman/space.h
> > new file mode 100644
> > index 0000000..6e1bc52
> > --- /dev/null
> > +++ b/spaceman/space.h
> > @@ -0,0 +1,36 @@
> > +/*
> > + * Copyright (c) 2012 Red Hat, Inc.
> > + * All Rights Reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > + */
> > +
> > +typedef struct fileio {
> > +	int		fd;		/* open file descriptor */
> > +	int		flags;		/* flags describing file state */
> 
> This is never used, really - always 0.

Deleted.

--D

> 
> > +	char		*name;		/* file name at time of open */
> > +	xfs_fsop_geom_t	geom;		/* XFS filesystem geometry */
> > +} fileio_t;
> > +
> > +extern fileio_t		*filetable;	/* open file table */
> > +extern int		filecount;	/* number of open files */
> > +extern fileio_t		*file;		/* active file in file table */
> > +extern int filelist_f(void);
> > +
> > +extern int	openfile(char *, xfs_fsop_geom_t *, int, mode_t);
> > +extern int	addfile(char *, int , xfs_fsop_geom_t *, int);
> > +
> > +extern void	file_init(void);
> > +extern void	help_init(void);
> > +extern void	quit_init(void);
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

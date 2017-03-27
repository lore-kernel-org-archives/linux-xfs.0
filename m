Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38825 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbdC0Pxb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 11:53:31 -0400
Date: Mon, 27 Mar 2017 08:52:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2 V2] xfs_io: move stat functions to new file
Message-ID: <20170327155254.GG5722@birch.djwong.org>
References: <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <05b4710f-8459-6386-244b-9df2db8398f9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05b4710f-8459-6386-244b-9df2db8398f9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Mar 23, 2017 at 11:34:23PM -0500, Eric Sandeen wrote:
> Adding statx will add a bit of code, so break stat-related
> functions out of open.c into their own new file.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> V2: No change
> 
> diff --git a/io/Makefile b/io/Makefile
> index 32df568..435ccff 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -11,7 +11,7 @@ HFILES = init.h io.h
>  CFILES = init.c \
>  	attr.c bmap.c cowextsize.c encrypt.c file.c freeze.c fsync.c \
>  	getrusage.c imap.c link.c mmap.c open.c parent.c pread.c prealloc.c \
> -	pwrite.c reflink.c seek.c shutdown.c sync.c truncate.c utimes.c
> +	pwrite.c reflink.c seek.c shutdown.c stat.c sync.c truncate.c utimes.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
> diff --git a/io/io.h b/io/io.h
> index c40aad0..7e95bd5 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -53,7 +53,7 @@ extern fileio_t		*filetable;	/* open file table */
>  extern int		filecount;	/* number of open files */
>  extern fileio_t		*file;		/* active file in file table */
>  extern int filelist_f(void);
> -
> +extern int stat_f(int argc, char **argv);
>  /*
>   * Memory mapped file regions
>   */
> diff --git a/io/open.c b/io/open.c
> index 941fdc1..2ed55cf 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -39,9 +39,7 @@
>  #endif
>  
>  static cmdinfo_t open_cmd;
> -static cmdinfo_t stat_cmd;
>  static cmdinfo_t close_cmd;
> -static cmdinfo_t statfs_cmd;
>  static cmdinfo_t chproj_cmd;
>  static cmdinfo_t lsproj_cmd;
>  static cmdinfo_t extsize_cmd;
> @@ -49,96 +47,6 @@ static cmdinfo_t inode_cmd;
>  static prid_t prid;
>  static long extsize;
>  
> -off64_t
> -filesize(void)
> -{
> -	struct stat	st;
> -
> -	if (fstat(file->fd, &st) < 0) {
> -		perror("fstat");
> -		return -1;
> -	}
> -	return st.st_size;
> -}
> -
> -static char *
> -filetype(mode_t mode)
> -{
> -	switch (mode & S_IFMT) {
> -	case S_IFSOCK:
> -		return _("socket");
> -	case S_IFDIR:
> -		return _("directory");
> -	case S_IFCHR:
> -		return _("char device");
> -	case S_IFBLK:
> -		return _("block device");
> -	case S_IFREG:
> -		return _("regular file");
> -	case S_IFLNK:
> -		return _("symbolic link");
> -	case S_IFIFO:
> -		return _("fifo");
> -	}
> -	return NULL;
> -}
> -
> -static int
> -stat_f(
> -	int		argc,
> -	char		**argv)
> -{
> -	struct dioattr	dio;
> -	struct fsxattr	fsx, fsxa;
> -	struct stat	st;
> -	int		verbose = (argc == 2 && !strcmp(argv[1], "-v"));
> -
> -	printf(_("fd.path = \"%s\"\n"), file->name);
> -	printf(_("fd.flags = %s,%s,%s%s%s%s%s\n"),
> -		file->flags & IO_OSYNC ? _("sync") : _("non-sync"),
> -		file->flags & IO_DIRECT ? _("direct") : _("non-direct"),
> -		file->flags & IO_READONLY ? _("read-only") : _("read-write"),
> -		file->flags & IO_REALTIME ? _(",real-time") : "",
> -		file->flags & IO_APPEND ? _(",append-only") : "",
> -		file->flags & IO_NONBLOCK ? _(",non-block") : "",
> -		file->flags & IO_TMPFILE ? _(",tmpfile") : "");
> -	if (fstat(file->fd, &st) < 0) {
> -		perror("fstat");
> -	} else {
> -		printf(_("stat.ino = %lld\n"), (long long)st.st_ino);
> -		printf(_("stat.type = %s\n"), filetype(st.st_mode));
> -		printf(_("stat.size = %lld\n"), (long long)st.st_size);
> -		printf(_("stat.blocks = %lld\n"), (long long)st.st_blocks);
> -		if (verbose) {
> -			printf(_("stat.atime = %s"), ctime(&st.st_atime));
> -			printf(_("stat.mtime = %s"), ctime(&st.st_mtime));
> -			printf(_("stat.ctime = %s"), ctime(&st.st_ctime));
> -		}
> -	}
> -	if (file->flags & IO_FOREIGN)
> -		return 0;
> -	if ((xfsctl(file->name, file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0 ||
> -	    (xfsctl(file->name, file->fd, XFS_IOC_FSGETXATTRA, &fsxa)) < 0) {
> -		perror("FS_IOC_FSGETXATTR");
> -	} else {
> -		printf(_("fsxattr.xflags = 0x%x "), fsx.fsx_xflags);
> -		printxattr(fsx.fsx_xflags, verbose, 0, file->name, 1, 1);
> -		printf(_("fsxattr.projid = %u\n"), fsx.fsx_projid);
> -		printf(_("fsxattr.extsize = %u\n"), fsx.fsx_extsize);
> -		printf(_("fsxattr.cowextsize = %u\n"), fsx.fsx_cowextsize);
> -		printf(_("fsxattr.nextents = %u\n"), fsx.fsx_nextents);
> -		printf(_("fsxattr.naextents = %u\n"), fsxa.fsx_nextents);
> -	}
> -	if ((xfsctl(file->name, file->fd, XFS_IOC_DIOINFO, &dio)) < 0) {
> -		perror("XFS_IOC_DIOINFO");
> -	} else {
> -		printf(_("dioattr.mem = 0x%x\n"), dio.d_mem);
> -		printf(_("dioattr.miniosz = %u\n"), dio.d_miniosz);
> -		printf(_("dioattr.maxiosz = %u\n"), dio.d_maxiosz);
> -	}
> -	return 0;
> -}
> -
>  int
>  openfile(
>  	char		*path,
> @@ -697,58 +605,6 @@ extsize_f(
>  	return 0;
>  }
>  
> -static int
> -statfs_f(
> -	int			argc,
> -	char			**argv)
> -{
> -	struct xfs_fsop_counts	fscounts;
> -	struct xfs_fsop_geom	fsgeo;
> -	struct statfs		st;
> -
> -	printf(_("fd.path = \"%s\"\n"), file->name);
> -	if (platform_fstatfs(file->fd, &st) < 0) {
> -		perror("fstatfs");
> -	} else {
> -		printf(_("statfs.f_bsize = %lld\n"), (long long) st.f_bsize);
> -		printf(_("statfs.f_blocks = %lld\n"), (long long) st.f_blocks);
> -		printf(_("statfs.f_bavail = %lld\n"), (long long) st.f_bavail);
> -		printf(_("statfs.f_files = %lld\n"), (long long) st.f_files);
> -		printf(_("statfs.f_ffree = %lld\n"), (long long) st.f_ffree);
> -	}
> -	if (file->flags & IO_FOREIGN)
> -		return 0;
> -	if ((xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo)) < 0) {
> -		perror("XFS_IOC_FSGEOMETRY_V1");
> -	} else {
> -		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
> -		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
> -		printf(_("geom.agblocks = %u\n"), fsgeo.agblocks);
> -		printf(_("geom.datablocks = %llu\n"),
> -			(unsigned long long) fsgeo.datablocks);
> -		printf(_("geom.rtblocks = %llu\n"),
> -			(unsigned long long) fsgeo.rtblocks);
> -		printf(_("geom.rtextents = %llu\n"),
> -			(unsigned long long) fsgeo.rtextents);
> -		printf(_("geom.rtextsize = %u\n"), fsgeo.rtextsize);
> -		printf(_("geom.sunit = %u\n"), fsgeo.sunit);
> -		printf(_("geom.swidth = %u\n"), fsgeo.swidth);
> -	}
> -	if ((xfsctl(file->name, file->fd, XFS_IOC_FSCOUNTS, &fscounts)) < 0) {
> -		perror("XFS_IOC_FSCOUNTS");
> -	} else {
> -		printf(_("counts.freedata = %llu\n"),
> -			(unsigned long long) fscounts.freedata);
> -		printf(_("counts.freertx = %llu\n"),
> -			(unsigned long long) fscounts.freertx);
> -		printf(_("counts.freeino = %llu\n"),
> -			(unsigned long long) fscounts.freeino);
> -		printf(_("counts.allocino = %llu\n"),
> -			(unsigned long long) fscounts.allocino);
> -	}
> -	return 0;
> -}
> -
>  static void
>  inode_help(void)
>  {
> @@ -920,14 +776,6 @@ open_init(void)
>  	open_cmd.oneline = _("open the file specified by path");
>  	open_cmd.help = open_help;
>  
> -	stat_cmd.name = "stat";
> -	stat_cmd.cfunc = stat_f;
> -	stat_cmd.argmin = 0;
> -	stat_cmd.argmax = 1;
> -	stat_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> -	stat_cmd.args = _("[-v]");
> -	stat_cmd.oneline = _("statistics on the currently open file");
> -
>  	close_cmd.name = "close";
>  	close_cmd.altname = "c";
>  	close_cmd.cfunc = close_f;
> @@ -936,12 +784,6 @@ open_init(void)
>  	close_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
>  	close_cmd.oneline = _("close the current open file");
>  
> -	statfs_cmd.name = "statfs";
> -	statfs_cmd.cfunc = statfs_f;
> -	statfs_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> -	statfs_cmd.oneline =
> -		_("statistics on the filesystem of the currently open file");
> -
>  	chproj_cmd.name = "chproj";
>  	chproj_cmd.cfunc = chproj_f;
>  	chproj_cmd.args = _("[-D | -R] projid");
> @@ -983,9 +825,7 @@ open_init(void)
>  	inode_cmd.help = inode_help;
>  
>  	add_command(&open_cmd);
> -	add_command(&stat_cmd);
>  	add_command(&close_cmd);
> -	add_command(&statfs_cmd);
>  	add_command(&chproj_cmd);
>  	add_command(&lsproj_cmd);
>  	add_command(&extsize_cmd);
> diff --git a/io/stat.c b/io/stat.c
> new file mode 100644
> index 0000000..3ae9903
> --- /dev/null
> +++ b/io/stat.c
> @@ -0,0 +1,189 @@
> +/*
> + * Copyright (c) 2003-2005 Silicon Graphics, Inc.
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
> +#include "libxfs.h"
> +
> +static cmdinfo_t stat_cmd;
> +static cmdinfo_t statfs_cmd;
> +
> +off64_t
> +filesize(void)
> +{
> +	struct stat	st;
> +
> +	if (fstat(file->fd, &st) < 0) {
> +		perror("fstat");
> +		return -1;
> +	}
> +	return st.st_size;
> +}
> +
> +static char *
> +filetype(mode_t mode)
> +{
> +	switch (mode & S_IFMT) {
> +	case S_IFSOCK:
> +		return _("socket");
> +	case S_IFDIR:
> +		return _("directory");
> +	case S_IFCHR:
> +		return _("char device");
> +	case S_IFBLK:
> +		return _("block device");
> +	case S_IFREG:
> +		return _("regular file");
> +	case S_IFLNK:
> +		return _("symbolic link");
> +	case S_IFIFO:
> +		return _("fifo");
> +	}
> +	return NULL;
> +}
> +
> +int
> +stat_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	struct dioattr	dio;
> +	struct fsxattr	fsx, fsxa;
> +	struct stat	st;
> +	int		verbose = (argc == 2 && !strcmp(argv[1], "-v"));
> +
> +	printf(_("fd.path = \"%s\"\n"), file->name);
> +	printf(_("fd.flags = %s,%s,%s%s%s%s%s\n"),
> +		file->flags & IO_OSYNC ? _("sync") : _("non-sync"),
> +		file->flags & IO_DIRECT ? _("direct") : _("non-direct"),
> +		file->flags & IO_READONLY ? _("read-only") : _("read-write"),
> +		file->flags & IO_REALTIME ? _(",real-time") : "",
> +		file->flags & IO_APPEND ? _(",append-only") : "",
> +		file->flags & IO_NONBLOCK ? _(",non-block") : "",
> +		file->flags & IO_TMPFILE ? _(",tmpfile") : "");
> +	if (fstat(file->fd, &st) < 0) {
> +		perror("fstat");
> +	} else {
> +		printf(_("stat.ino = %lld\n"), (long long)st.st_ino);
> +		printf(_("stat.type = %s\n"), filetype(st.st_mode));
> +		printf(_("stat.size = %lld\n"), (long long)st.st_size);
> +		printf(_("stat.blocks = %lld\n"), (long long)st.st_blocks);
> +		if (verbose) {
> +			printf(_("stat.atime = %s"), ctime(&st.st_atime));
> +			printf(_("stat.mtime = %s"), ctime(&st.st_mtime));
> +			printf(_("stat.ctime = %s"), ctime(&st.st_ctime));
> +		}
> +	}
> +	if (file->flags & IO_FOREIGN)
> +		return 0;
> +	if ((xfsctl(file->name, file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0 ||
> +	    (xfsctl(file->name, file->fd, XFS_IOC_FSGETXATTRA, &fsxa)) < 0) {
> +		perror("FS_IOC_FSGETXATTR");
> +	} else {
> +		printf(_("fsxattr.xflags = 0x%x "), fsx.fsx_xflags);
> +		printxattr(fsx.fsx_xflags, verbose, 0, file->name, 1, 1);
> +		printf(_("fsxattr.projid = %u\n"), fsx.fsx_projid);
> +		printf(_("fsxattr.extsize = %u\n"), fsx.fsx_extsize);
> +		printf(_("fsxattr.cowextsize = %u\n"), fsx.fsx_cowextsize);
> +		printf(_("fsxattr.nextents = %u\n"), fsx.fsx_nextents);
> +		printf(_("fsxattr.naextents = %u\n"), fsxa.fsx_nextents);
> +	}
> +	if ((xfsctl(file->name, file->fd, XFS_IOC_DIOINFO, &dio)) < 0) {
> +		perror("XFS_IOC_DIOINFO");
> +	} else {
> +		printf(_("dioattr.mem = 0x%x\n"), dio.d_mem);
> +		printf(_("dioattr.miniosz = %u\n"), dio.d_miniosz);
> +		printf(_("dioattr.maxiosz = %u\n"), dio.d_maxiosz);
> +	}
> +	return 0;
> +}
> +
> +static int
> +statfs_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	struct xfs_fsop_counts	fscounts;
> +	struct xfs_fsop_geom	fsgeo;
> +	struct statfs		st;
> +
> +	printf(_("fd.path = \"%s\"\n"), file->name);
> +	if (platform_fstatfs(file->fd, &st) < 0) {
> +		perror("fstatfs");
> +	} else {
> +		printf(_("statfs.f_bsize = %lld\n"), (long long) st.f_bsize);
> +		printf(_("statfs.f_blocks = %lld\n"), (long long) st.f_blocks);
> +		printf(_("statfs.f_bavail = %lld\n"), (long long) st.f_bavail);
> +		printf(_("statfs.f_files = %lld\n"), (long long) st.f_files);
> +		printf(_("statfs.f_ffree = %lld\n"), (long long) st.f_ffree);
> +	}
> +	if (file->flags & IO_FOREIGN)
> +		return 0;
> +	if ((xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo)) < 0) {
> +		perror("XFS_IOC_FSGEOMETRY_V1");
> +	} else {
> +		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
> +		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
> +		printf(_("geom.agblocks = %u\n"), fsgeo.agblocks);
> +		printf(_("geom.datablocks = %llu\n"),
> +			(unsigned long long) fsgeo.datablocks);
> +		printf(_("geom.rtblocks = %llu\n"),
> +			(unsigned long long) fsgeo.rtblocks);
> +		printf(_("geom.rtextents = %llu\n"),
> +			(unsigned long long) fsgeo.rtextents);
> +		printf(_("geom.rtextsize = %u\n"), fsgeo.rtextsize);
> +		printf(_("geom.sunit = %u\n"), fsgeo.sunit);
> +		printf(_("geom.swidth = %u\n"), fsgeo.swidth);
> +	}
> +	if ((xfsctl(file->name, file->fd, XFS_IOC_FSCOUNTS, &fscounts)) < 0) {
> +		perror("XFS_IOC_FSCOUNTS");
> +	} else {
> +		printf(_("counts.freedata = %llu\n"),
> +			(unsigned long long) fscounts.freedata);
> +		printf(_("counts.freertx = %llu\n"),
> +			(unsigned long long) fscounts.freertx);
> +		printf(_("counts.freeino = %llu\n"),
> +			(unsigned long long) fscounts.freeino);
> +		printf(_("counts.allocino = %llu\n"),
> +			(unsigned long long) fscounts.allocino);
> +	}
> +	return 0;
> +}
> +
> +void
> +stat_init(void)
> +{
> +	stat_cmd.name = "stat";
> +	stat_cmd.cfunc = stat_f;
> +	stat_cmd.argmin = 0;
> +	stat_cmd.argmax = 1;
> +	stat_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	stat_cmd.args = _("[-v]");
> +	stat_cmd.oneline = _("statistics on the currently open file");
> +
> +	statfs_cmd.name = "statfs";
> +	statfs_cmd.cfunc = statfs_f;
> +	statfs_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	statfs_cmd.oneline =
> +		_("statistics on the filesystem of the currently open file");
> +
> +	add_command(&stat_cmd);
> +	add_command(&statfs_cmd);
> +}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

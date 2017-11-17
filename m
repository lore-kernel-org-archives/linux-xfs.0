Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39240 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965320AbdKQUkd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 15:40:33 -0500
Date: Fri, 17 Nov 2017 12:40:21 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [xfsprogs PATCH 1/2] xfs_io: add MAP_SYNC support to mmap()
Message-ID: <20171117204021.GO5119@magnolia>
References: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
 <20171117202524.24696-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171117202524.24696-2-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>

On Fri, Nov 17, 2017 at 01:25:23PM -0700, Ross Zwisler wrote:
> Add support for a new -S flag to xfs_io's mmap command.  This opens the
> mapping with the (MAP_SYNC | MAP_SHARED_VALIDATE) flags instead of the
> standard MAP_SHARED flag.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> ---
>  configure.ac          |  1 +
>  include/builddefs.in  |  1 +
>  include/linux.h       |  5 +++++
>  io/io.h               |  1 +
>  io/mmap.c             | 19 ++++++++++++++-----
>  m4/package_libcdev.m4 | 16 ++++++++++++++++
>  man/man8/xfs_io.8     |  6 +++++-
>  7 files changed, 43 insertions(+), 6 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index cb23fb8..7153c9f 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -162,6 +162,7 @@ AC_HAVE_FSETXATTR
>  AC_HAVE_MREMAP
>  AC_NEED_INTERNAL_FSXATTR
>  AC_HAVE_GETFSMAP
> +AC_HAVE_MAP_SYNC
>  
>  if test "$enable_blkid" = yes; then
>  AC_HAVE_BLKID_TOPO
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 1d454b6..78b71fe 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -114,6 +114,7 @@ HAVE_FSETXATTR = @have_fsetxattr@
>  HAVE_MREMAP = @have_mremap@
>  NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
>  HAVE_GETFSMAP = @have_getfsmap@
> +HAVE_MAP_SYNC = @have_map_sync@
>  
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>  #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
> diff --git a/include/linux.h b/include/linux.h
> index 6ce344c..4ee03ed 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -327,4 +327,9 @@ fsmap_advance(
>  #define HAVE_GETFSMAP
>  #endif /* HAVE_GETFSMAP */
>  
> +#ifndef HAVE_MAP_SYNC
> +#define MAP_SYNC 0x80000
> +#define MAP_SHARED_VALIDATE 0x3
> +#endif /* HAVE_MAP_SYNC */

Hmm, what's the point of ifndef/define if you have an configure.ac check?

> +
>  #endif	/* __XFS_LINUX_H__ */
> diff --git a/io/io.h b/io/io.h
> index 3862985..8b2753b 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -65,6 +65,7 @@ typedef struct mmap_region {
>  	size_t		length;		/* length of mapping */
>  	off64_t		offset;		/* start offset into backing file */
>  	int		prot;		/* protection mode of the mapping */
> +	bool		map_sync;	/* is this a MAP_SYNC mapping? */
>  	char		*name;		/* name of backing file */
>  } mmap_region_t;
>  
> diff --git a/io/mmap.c b/io/mmap.c
> index 7a8150e..520b037 100644
> --- a/io/mmap.c
> +++ b/io/mmap.c
> @@ -42,7 +42,7 @@ print_mapping(
>  	int		index,
>  	int		braces)
>  {
> -	unsigned char	buffer[8] = { 0 };
> +	char		buffer[8] = { 0 };
>  	int		i;
>  
>  	static struct {
> @@ -57,6 +57,10 @@ print_mapping(
>  
>  	for (i = 0, p = pflags; p->prot != PROT_NONE; i++, p++)
>  		buffer[i] = (map->prot & p->prot) ? p->mode : '-';
> +
> +	if (map->map_sync)
> +		sprintf(&buffer[i], " S");

Does buffer need enlarging here?

> +
>  	printf("%c%03d%c 0x%lx - 0x%lx %s  %14s (%lld : %ld)\n",
>  		braces? '[' : ' ', index, braces? ']' : ' ',
>  		(unsigned long)map->addr,
> @@ -146,6 +150,7 @@ mmap_help(void)
>  " -r -- map with PROT_READ protection\n"
>  " -w -- map with PROT_WRITE protection\n"
>  " -x -- map with PROT_EXEC protection\n"
> +" -S -- map with MAP_SHARED_VALIDATE and MAP_SYNC flags\n"
>  " -s <size> -- first do mmap(size)/munmap(size), try to reserve some free space\n"
>  " If no protection mode is specified, all are used by default.\n"
>  "\n"));
> @@ -161,7 +166,7 @@ mmap_f(
>  	void		*address = NULL;
>  	char		*filename;
>  	size_t		blocksize, sectsize;
> -	int		c, prot = 0;
> +	int		c, prot = 0, flags = MAP_SHARED;
>  
>  	if (argc == 1) {
>  		if (mapping)
> @@ -184,7 +189,7 @@ mmap_f(
>  
>  	init_cvtnum(&blocksize, &sectsize);
>  
> -	while ((c = getopt(argc, argv, "rwxs:")) != EOF) {
> +	while ((c = getopt(argc, argv, "rwxSs:")) != EOF) {
>  		switch (c) {
>  		case 'r':
>  			prot |= PROT_READ;
> @@ -195,6 +200,9 @@ mmap_f(
>  		case 'x':
>  			prot |= PROT_EXEC;
>  			break;
> +		case 'S':
> +			flags = MAP_SHARED_VALIDATE | MAP_SYNC;
> +			break;
>  		case 's':
>  			length2 = cvtnum(blocksize, sectsize, optarg);
>  			break;
> @@ -238,7 +246,7 @@ mmap_f(
>  		               MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>  		munmap(address, length2);
>  	}
> -	address = mmap(address, length, prot, MAP_SHARED, file->fd, offset);
> +	address = mmap(address, length, prot, flags, file->fd, offset);
>  	if (address == MAP_FAILED) {
>  		perror("mmap");
>  		free(filename);
> @@ -263,6 +271,7 @@ mmap_f(
>  	mapping->offset = offset;
>  	mapping->name = filename;
>  	mapping->prot = prot;
> +	mapping->map_sync = (flags == (MAP_SHARED_VALIDATE | MAP_SYNC));
>  	return 0;
>  }
>  
> @@ -676,7 +685,7 @@ mmap_init(void)
>  	mmap_cmd.argmax = -1;
>  	mmap_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK |
>  			 CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
> -	mmap_cmd.args = _("[N] | [-rwx] [-s size] [off len]");
> +	mmap_cmd.args = _("[N] | [-rwxS] [-s size] [off len]");
>  	mmap_cmd.oneline =
>  		_("mmap a range in the current file, show mappings");
>  	mmap_cmd.help = mmap_help;
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index fdf9d69..598f5df 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -314,3 +314,19 @@ AC_DEFUN([AC_HAVE_GETFSMAP],
>         AC_MSG_RESULT(no))
>      AC_SUBST(have_getfsmap)
>    ])
> +
> +#
> +# Check if we have MAP_SYNC defines (Linux)
> +#
> +AC_DEFUN([AC_HAVE_MAP_SYNC],
> +  [ AC_MSG_CHECKING([for MAP_SYNC])
> +    AC_TRY_COMPILE([
> +#include <asm-generic/mman.h>
> +#include <asm-generic/mman-common.h>
> +    ], [
> +         int flags = MAP_SHARED_VALIDATE | MAP_SYNC;
> +    ], have_map_sync=yes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(have_map_sync)
> +  ])
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 9bf1a47..1693f7f 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -764,7 +764,7 @@ Each (sec, nsec) pair constitutes a single timestamp value.
>  
>  .SH MEMORY MAPPED I/O COMMANDS
>  .TP
> -.BI "mmap [ " N " | [[ \-rwx ] [\-s " size " ] " "offset length " ]]
> +.BI "mmap [ " N " | [[ \-rwxS ] [\-s " size " ] " "offset length " ]]
>  With no arguments,
>  .B mmap
>  shows the current mappings. Specifying a single numeric argument
> @@ -780,6 +780,10 @@ PROT_WRITE
>  .RB ( \-w ),
>  and PROT_EXEC
>  .RB ( \-x ).
> +The mapping will be created with the MAP_SHARED flag by default, or with the
> +Linux specific (MAP_SYNC | MAP_SHARED_VALIDATE) flags if
> +.B -S
> +is given.

Woo, documentation!

--D

>  .BI \-s " size"
>  is used to do a mmap(size) && munmap(size) operation at first, try to reserve some
>  extendible free memory space, if
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

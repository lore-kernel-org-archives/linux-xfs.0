Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38A067FD7
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 18:07:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 117E68F8035
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 16:07:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vQyG45MN8ClENC4S for <xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 16:07:29 -0700 (PDT)
Message-ID: <5213F6AF.8070107@sandeen.net>
Date: Tue, 20 Aug 2013 18:07:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20130816205409.976658624@sgi.com>
In-Reply-To: <20130816205409.976658624@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 8/16/13 3:54 PM, Mark Tinguely wrote:

> Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
> The result from the lseek() call will be printed to the output.
> For example:
> 
> xfs_io> lseek -h 609k
> Type	Offset
> hole	630784

HOLE not hole, I guess.  ;)

I was going to say that's a lot of verbosity for a single output,
but I guess the other options might have many lines, so I suppose
it makes sense.

(I was just thinking about what xfstests might need to do to filter
& parse output...)

> Signed-off-by: Mark Tinguely <tinguely@sgi.com> 
> ---
>  Not trying to be difficult. Dave wanted the single hole/data/hole and data
>  seperated from the recursive loop, but doing it that way is basically unrolling
>  the loop into a if-then-else and is really terrible. If this is still not
>  acceptable, then we can throw this feature into /dev/null.
> 
>  configure.ac          |    1 
>  include/builddefs.in  |    1 
>  io/Makefile           |    5 +
>  io/init.c             |    1 
>  io/io.h               |    6 +
>  io/seek.c             |  187 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  m4/package_libcdev.m4 |   15 ++++
>  man/man8/xfs_io.8     |   35 +++++++++
>  8 files changed, 251 insertions(+)
> 
> Index: b/configure.ac
> ===================================================================
> --- a/configure.ac
> +++ b/configure.ac
> @@ -110,6 +110,7 @@ AC_HAVE_GETMNTINFO
>  AC_HAVE_FALLOCATE
>  AC_HAVE_FIEMAP
>  AC_HAVE_PREADV
> +AC_HAVE_SEEK_DATA
>  AC_HAVE_SYNC_FILE_RANGE
>  AC_HAVE_BLKID_TOPO($enable_blkid)
>  AC_HAVE_READDIR
> Index: b/include/builddefs.in
> ===================================================================
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -102,6 +102,7 @@ HAVE_GETMNTINFO = @have_getmntinfo@
>  HAVE_FALLOCATE = @have_fallocate@
>  HAVE_FIEMAP = @have_fiemap@
>  HAVE_PREADV = @have_preadv@
> +HAVE_SEEK_DATA = @have_seek_data@
>  HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
>  HAVE_READDIR = @have_readdir@
>  
> Index: b/io/Makefile
> ===================================================================
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -85,6 +85,11 @@ CFILES += readdir.c
>  LCFLAGS += -DHAVE_READDIR
>  endif
>  
> +ifeq ($(HAVE_SEEK_DATA),yes)
> +LCFLAGS += -DHAVE_SEEK_DATA
> +CFILES += seek.c

see below; we should unconditionally compile, but conditionally
locally define SEEK_DATA / SEEK_HOLE

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
> +	seek_init();
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
> +#ifdef HAVE_SEEK_DATA
> +extern void		seek_init(void);
> +#else
> +#define seek_init()	do { } while (0)
> +#endif

this can go when we unconditionally compile it in

> +
>  #ifdef HAVE_FADVISE
>  extern void		fadvise_init(void);
>  #else
> Index: b/io/seek.c
> ===================================================================
> --- /dev/null
> +++ b/io/seek.c
> @@ -0,0 +1,187 @@
> +/*
> + * Copyright (c) 2013 SGI
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
> +#include <libxfs.h>

hm, including this clashes w/ the min() define in io/init.h,
which is maybe a separate problem down the line, but libxfs.h
isn't required anyway for this file, so I'd just drop this include.

> +#include <linux/fs.h>
> +
> +#include <sys/uio.h>
> +#include <xfs/xfs.h>
> +#include <xfs/command.h>
> +#include <xfs/input.h>
> +#include <ctype.h>
> +#include "init.h"
> +#include "io.h"

#ifndef HAVE_SEEK_DATA
#define SEEK_DATA       3       /* seek to the next data */
#define SEEK_HOLE       4       /* seek to the next hole */
#endif

> +
> +static cmdinfo_t seek_cmd;
> +
> +static void
> +seek_help(void)
> +{
> +	printf(_(
> +"\n"
> +" returns the next hole and/or data offset at or after the specified offset\n"
> +"\n"
> +" Example:\n"
> +" 'seek -d 512'   - offset of data at or following offset 512\n"
> +" 'seek -a -r 0'  - offsets of all data and hole in entire file\n"
> +"\n"
> +" Returns the offset of the next data and/or hole. There is an implied hole\n"
> +" at the end of file.

is this expected, given the hole at the end of the file?  This is for a single
non-sparse file:

xfs_io> seek -ar 0
Type	offset
DATA	0
HOLE	3022
DATA	EOF

That last line doesn't make sense, does it?

> If the specified offset is past end of file, or there\n"
> +" is no data past the specied offset, EOF is returned.\n"

"specified"

> +" -a   -- return the next data and hole starting at the specified offset.\n"
> +" -d   -- return the next data starting at the specified offset.\n"
> +" -h   -- return the next hole starting at the specified offset.\n"
> +" -r   -- return all remaining type(s) starting at the specified offset.\n"
> +"\n"));
> +}
> +
> +#define	SEEK_DFLAG	(1 << 0)
> +#define	SEEK_HFLAG	(1 << 1)
> +#define	SEEK_RFLAG	(1 << 2)
> +#define	DATA		0
> +#define	HOLE		1
> +
> +struct seekinfo {
> +	char		*name;
> +	int		seektype;
> +	int		mask;
> +} seekinfo[] = {
> +		{"DATA", SEEK_DATA, SEEK_DFLAG},
> +		{"HOLE", SEEK_HOLE, SEEK_HFLAG}

I guess "DATA" doesn't get replaced by "0" ?  Sorry, I failed cpp 101.
It prints the right thing so I guess not.  ;)

> +};
> +
> +void
> +seek_output(
> +	char	*type,
> +	off64_t	offset)
> +{
> +	if (offset == -1) {
> +		if (errno == ENXIO)
> +			printf("%s	EOF\n", type);
> +		else
> +			printf("%s	ERR %d\n", type, errno);
> +	} else
> +		printf("%s	%ld\n", type, offset);
> +}
> +
> +static int
> +seek_f(
> +	int	argc,
> +	char	**argv)
> +{
> +	off64_t		offset, result;
> +	size_t          fsblocksize, fssectsize;
> +	int		flag;
> +	int		current;	/* specify data or hole */
> +	int		c;
> +
> +	flag = 0;
> +	init_cvtnum(&fsblocksize, &fssectsize);
> +
> +	while ((c = getopt(argc, argv, "adhr")) != EOF) {
> +		switch (c) {
> +		case 'a':
> +			flag |= (SEEK_HFLAG | SEEK_DFLAG);
> +			break;
> +		case 'd':
> +			flag |= SEEK_DFLAG;
> +			break;
> +		case 'h':
> +			flag |= SEEK_HFLAG;
> +			break;
> +		case 'r':
> +			flag |= SEEK_RFLAG;
> +			break;
> +		default:
> +			return command_usage(&seek_cmd);
> +		}
> +	}
> +		/* must have hole or data specified and an offset */
> +	if (!(flag & (SEEK_DFLAG | SEEK_HFLAG)) ||
> +             optind != argc - 1)
> +		return command_usage(&seek_cmd);
> +
> +	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);

need to error check that:

xfs_io> seek -a 8x8
Type	offset
HOLE	EOF

> +
> +	if (flag & SEEK_HFLAG) {
> +		result = lseek64(file->fd, offset, SEEK_HOLE);
> +		if ((result == offset) ||
> +		    !(flag & SEEK_DFLAG)) {
> +			offset = result;	/* in case it was EOF */
> +			current = HOLE;
> +			goto found_hole;
> +		}

what if result < 0?

# io/xfs_io /tmp/fifo
xfs_io> seek -a 0
Type	offset
DATA	ERR 29

hum I guess seek_output handles it?  perror would be nice, maybe?

> +	}
> +
> +	/* found data or -1 when "-a" option was requested */
> +	current = DATA;
> +	offset = lseek64(file->fd, offset, SEEK_DATA);

Ok, I guess I have to think harder about how the error handling
from lseek is supposed to work.

> +
> +found_hole:
> +	printf("Type	offset\n");
> +
> +	while (flag) {
> +		/*
> +		 * handle the data / hole entries in assending order from
> +		 * the specified offset.
> +		 *
> +		 * flag determines if there are more items to be displayed.
> +		 * SEEK_RFLAG is an infinite loop that is terminated with
> +		 * a offset at EOF.
> +		 *
> +		 * current determines next type to process/display where
> +		 * 0 is data and 1 is data.
> +		 */
> +
> +		if (flag & seekinfo[current].mask) {
> +			seek_output(seekinfo[current].name, offset);
> +			if (offset == -1)
> +				break;		/* stop on error or EOF */
> +		}
> +
> +		/*
> +		 * When displaying only a single data and/or hole item, mask
> +		 * off the item as it is displayed. The loop will end when all
> +		 * requested items have been displayed.
> +		 */
> +		if (!(flag & SEEK_RFLAG))
> +			flag &= ~seekinfo[current].mask;
> +
> +		current ^= 1;		/* alternate between data and hole */
> +		if (offset != -1)
> +			offset = lseek64(file->fd, offset,
> +					 seekinfo[current].seektype);
> +	}
> +	return 0;
> +}
> +
> +void
> +seek_init(void)
> +{
> +	seek_cmd.name = "seek";
> +	seek_cmd.altname = "seek";

altname isn't required, but I don't think there's a reason to re-specify the same name.

> +	seek_cmd.cfunc = seek_f;
> +	seek_cmd.argmin = 2;
> +	seek_cmd.argmax = 5;
> +	seek_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	seek_cmd.args = _("-a | -d | -h [-r] off");
> +	seek_cmd.oneline = _("locate the next data and/or hole");
> +	seek_cmd.help = seek_help;
> +
> +	add_command(&seek_cmd);
> +}
> Index: b/m4/package_libcdev.m4
> ===================================================================
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -154,6 +154,21 @@ AC_DEFUN([AC_HAVE_PREADV],
>    ])
>  
>  #
> +# Check if we have a working fadvise system call

fadvise...? ;)

> +#
> +AC_DEFUN([AC_HAVE_SEEK_DATA],
> +  [ AC_MSG_CHECKING([for seek_data ])

So really, we're checking for the SEEK_DATA & SEEK_HOLE defines here.

If they aren't present, we can locally define them, and we'll still get
the functionality (though io has to cope w/ EINVAL or whatnot if the
system xfs_io runs on doesn't understand the flags)

Also, coverity didn't find any errors in seek.c \o/ :)

Thanks,
-Eric

> +    AC_TRY_COMPILE([
> +#include <linux/fs.h>
> +    ], [
> +         lseek(0, 0, SEEK_DATA);
> +    ], have_seek_data=yes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(have_seek_data)
> +  ])
> +
> +#
>  # Check if we have a sync_file_range libc call (Linux)
>  #
>  AC_DEFUN([AC_HAVE_SYNC_FILE_RANGE],
> Index: b/man/man8/xfs_io.8
> ===================================================================
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -418,6 +418,41 @@ to read (in bytes)
>  .RE
>  .PD
>  .TP
> +.TP
> +.BI "seek  \-a | \-d | \-h [ \-r ] offset"
> +On platforms that support the
> +.BR lseek (2)
> +.B SEEK_DATA
> +and
> +.B SEEK_HOLE
> +options, display the offsets of the specified segments.
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.B \-a
> +Display both
> +.B data
> +and
> +.B hole
> +segments starting at the specified
> +.B offset.
> +.TP
> +.B \-d
> +Display the
> +.B data
> +segment starting at the specified
> +.B offset.
> +.TP
> +.B \-h
> +Display the
> +.B hole
> +segment starting at the specified
> +.B offset.
> +.TP
> +.B \-r
> +Recursively display all the specified segments starting at the specified
> +.B offset.
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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

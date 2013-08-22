Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 862597CBF
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:45:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 762F78F8040
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 15:45:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mX8XAE8LWGk7WSGU for <xfs@oss.sgi.com>;
	Thu, 22 Aug 2013 15:45:30 -0700 (PDT)
Message-ID: <52169488.2040303@sandeen.net>
Date: Thu, 22 Aug 2013 17:45:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: v7 add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20130822213148.224998379@sgi.com>
In-Reply-To: <20130822213148.224998379@sgi.com>
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

On 8/22/13 4:31 PM, Mark Tinguely wrote:

> Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
> The result from the lseek() call will be printed to the output.
> For example:
> 
> xfs_io> seek -h 609k
> HOLE	630784
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  version 7 or 8 - Eric what number is this?

Go for 13, for luck!

I think this looks ok, I won't torture you any longer.  If there's anything
to fix up when it really gets used in earnest we can do it then.

(it crossed my mind that for the "-r" and "-a" invocations it might be good to print
out the offset which was sent for each SEEK_* "whence," but *shrug*)

Thanks for all the iterations,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  I think I added all the old Dave and new Eric changes.
> 
>  Unconditionally compile the feature into xfs_io.
> 
>  (Too) many comments added. This routine basically is a seek and print loop.
> 
>  Removed the ending EOF, except where that was the only entry.
>    No output looked bad.
>    This print the only entry exception changed the loop/if statements.
> 
>  Changed error message to perror.
> 
>  Ran the fine-tune kernel test on the following XFS kernel version:
>   Linux 3.0 no support.
>   Linux 3.1 vfs default support.
>   Linux 3.5 XFS first support.
>   Linux 3.7 XFS fine-tuned support.
> 
>  Each version has different output - as expected. Eric you want the output?

Meh.  We can fix it up as needed.  I'm a bit shocked that we (the grand Linux
"we") didn't just settle on "whatever Solaris did is correct."

>  io/Makefile       |    3 
>  io/init.c         |    1 
>  io/io.h           |    1 
>  io/seek.c         |  197 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/xfs_io.8 |   35 +++++++++
>  5 files changed, 236 insertions(+), 1 deletion(-)
> 
> Index: b/io/Makefile
> ===================================================================
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -10,7 +10,8 @@ LSRCFILES = xfs_bmap.sh xfs_freeze.sh xf
>  HFILES = init.h io.h
>  CFILES = init.c \
>  	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c mmap.c \
> -	open.c parent.c pread.c prealloc.c pwrite.c shutdown.c truncate.c
> +	open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
> +	truncate.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
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
> @@ -105,6 +105,7 @@ extern void		pread_init(void);
>  extern void		prealloc_init(void);
>  extern void		pwrite_init(void);
>  extern void		quit_init(void);
> +extern void		seek_init(void);
>  extern void		shutdown_init(void);
>  extern void		truncate_init(void);
>  
> Index: b/io/seek.c
> ===================================================================
> --- /dev/null
> +++ b/io/seek.c
> @@ -0,0 +1,197 @@
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
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
> + */
> +
> +#include <xfs/xfs.h>
> +#include <xfs/command.h>
> +#include <xfs/input.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include "init.h"
> +#include "io.h"
> +
> +static cmdinfo_t seek_cmd;
> +
> +static void
> +seek_help(void)
> +{
> +	printf(_(
> +"\n"
> +" returns the next hole and/or data offset at or after the requested offset\n"
> +"\n"
> +" Example:\n"
> +" 'seek -d 512'		- offset of data at or following offset 512\n"
> +" 'seek -a -r 0'	- offsets of all data and hole in entire file\n"
> +"\n"
> +" Returns the offset of the next data and/or hole. There is an implied hole\n"
> +" at the end of file. If the specified offset is past end of file, or there\n"
> +" is no data past the specified offset, EOF is returned.\n"
> +" -a	-- return the next data and hole starting at the specified offset.\n"
> +" -d	-- return the next data starting at the specified offset.\n"
> +" -h	-- return the next hole starting at the specified offset.\n"
> +" -r	-- return all remaining type(s) starting at the specified offset.\n"
> +"\n"));
> +}
> +
> +#ifndef HAVE_SEEK_DATA
> +#define	SEEK_DATA	3	/* seek to the next data */
> +#define	SEEK_HOLE	4	/* seek to the next hole */
> +#endif
> +
> +/* values for flag variable */
> +#define	SEEK_DFLAG	(1 << 0)
> +#define	SEEK_HFLAG	(1 << 1)
> +#define	SEEK_RFLAG	(1 << 2)
> +
> +/* indexes into the seekinfo array */
> +#define	DATA		0
> +#define	HOLE		1
> +
> +struct seekinfo {
> +	char		*name;		/* display item name */
> +	int		seektype;	/* data or hole */
> +	int		mask;		/* compared for print and looping */
> +} seekinfo[] = {
> +		{"DATA", SEEK_DATA, SEEK_DFLAG},
> +		{"HOLE", SEEK_HOLE, SEEK_HFLAG}
> +};
> +
> +/* print item type and offset. catch special cases of eof and error */
> +void
> +seek_output(
> +	char	*type,
> +	off64_t	offset)
> +{
> +	if (offset == -1) {
> +		if (errno == ENXIO)
> +			printf("%s	EOF\n", type);
> +		else
> +			perror("ERR");
> +	} else
> +		printf("%s	%lld\n", type, (long long)offset);
> +}
> +
> +static int
> +seek_f(
> +	int	argc,
> +	char	**argv)
> +{
> +	off64_t		offset, result;
> +	size_t		fsblocksize, fssectsize;
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
> +	if (!(flag & (SEEK_DFLAG | SEEK_HFLAG)) || optind != argc - 1)
> +		return command_usage(&seek_cmd);
> +
> +	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +	if (offset < 0)
> +		return command_usage(&seek_cmd);
> +
> +	/*
> +	 * check to see if the offset is a data or hole entry and
> +	 * decide if we want to display that type of entry.
> +	 */
> +	if (flag & SEEK_HFLAG) {
> +		result = lseek64(file->fd, offset, SEEK_HOLE);
> +		if ((result == offset) || !(flag & SEEK_DFLAG)) {
> +			/*
> +			 * this offset is a hole or are only displaying holes.
> +			 * if this offset is for data and we are displaying
> +			 * data, then we will fall through below to
> +			 * initialize the data search.
> +			 */
> +			offset = result;
> +			current = HOLE;
> +			goto found_hole;
> +		}
> +	}
> +
> +	/* The offset is not a hole, or we are looking just for data */
> +	current = DATA;
> +	offset = lseek64(file->fd, offset, SEEK_DATA);
> +
> +found_hole:
> +	/*
> +	 * At this point we know which type and the offset of the starting
> +	 * item. "current" alternates between data / hole entries in
> +	 * assending order - this alternation is needed even if only one
> +	 * type is to be displayed.
> +	 *
> +	 * An error or EOF will terminate the display, otherwise "flag"
> +	 * determines if there are more items to be displayed.
> +	 */
> +	for (c = 0; flag; c++) {
> +		if (offset == -1) {
> +			/* print error or eof if the only entry */
> +			if (errno != ENXIO || c == 0 )
> +				seek_output(seekinfo[current].name, offset);
> +			return 0;	/* stop on error or EOF */
> +		}
> +
> +		seek_output(seekinfo[current].name, offset);
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
> +		offset = lseek64(file->fd, offset, seekinfo[current].seektype);
> +	}
> +	return 0;
> +}
> +
> +void
> +seek_init(void)
> +{
> +	seek_cmd.name = "seek";
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

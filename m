Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60248 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751093AbdFUVVw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 17:21:52 -0400
Subject: Re: [PATCH 08/12] xfs_spaceman: add FITRIM support
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
 <149755899832.3625.846462761036158527.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <58138380-683c-9b92-958a-5d759f09df59@sandeen.net>
Date: Wed, 21 Jun 2017 16:21:50 -0500
MIME-Version: 1.0
In-Reply-To: <149755899832.3625.846462761036158527.stgit@birch.djwong.org>
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
> Add support for discarding free space extents via the FITRIM
> command. Make it easy to discard a single range, an entire AG or all
> the freespace in the filesystem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  spaceman/Makefile |    2 -
>  spaceman/init.c   |    1 
>  spaceman/space.h  |    1 
>  spaceman/trim.c   |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 134 insertions(+), 1 deletion(-)
>  create mode 100644 spaceman/trim.c
> 
> 
> diff --git a/spaceman/Makefile b/spaceman/Makefile
> index df59edf..c63a4fc 100644
> --- a/spaceman/Makefile
> +++ b/spaceman/Makefile
> @@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
>  
>  LTCOMMAND = xfs_spaceman
>  HFILES = init.h space.h
> -CFILES = init.c file.c
> +CFILES = init.c file.c trim.c
>  
>  LLDLIBS = $(LIBXCMD)
>  LTDEPENDENCIES = $(LIBXCMD)
> diff --git a/spaceman/init.c b/spaceman/init.c
> index 8cbfbda..107a692 100644
> --- a/spaceman/init.c
> +++ b/spaceman/init.c
> @@ -40,6 +40,7 @@ init_commands(void)
>  	print_init();
>  	help_init();
>  	quit_init();
> +	trim_init();
>  }
>  
>  static int
> diff --git a/spaceman/space.h b/spaceman/space.h
> index 7bfe874..8cd3953 100644
> --- a/spaceman/space.h
> +++ b/spaceman/space.h
> @@ -34,5 +34,6 @@ extern int	addfile(char *, int , xfs_fsop_geom_t *);
>  extern void	print_init(void);
>  extern void	help_init(void);
>  extern void	quit_init(void);
> +extern void	trim_init(void);
>  
>  #endif /* XFS_SPACEMAN_SPACE_H_ */
> diff --git a/spaceman/trim.c b/spaceman/trim.c
> new file mode 100644
> index 0000000..c0bc7f2
> --- /dev/null
> +++ b/spaceman/trim.c
> @@ -0,0 +1,131 @@
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
> +
> +#include "libxfs.h"
> +#include <linux/fs.h>
> +#include "command.h"
> +#include "init.h"
> +#include "space.h"
> +#include "input.h"
> +
> +static cmdinfo_t trim_cmd;
> +
> +/*
> + * Trim unused space in xfs filesystem.
> + */
> +static int
> +trim_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	struct fstrim_range trim = {0};
> +	xfs_agnumber_t	agno = 0;
> +	off64_t		offset = 0;
> +	ssize_t		length = 0;
> +	ssize_t		minlen = 0;
> +	int		aflag = 0;
> +	int		fflag = 0;
> +	int		ret;
> +	int		c;
> +
> +	while ((c = getopt(argc, argv, "a:fm:")) != EOF) {
> +		switch (c) {
> +		case 'a':
> +			aflag = 1;
> +			agno = cvt_u32(optarg, 10);
> +			if (errno) {
> +				printf(_("bad agno value %s\n"), optarg);
> +				return command_usage(&trim_cmd);
> +			}
> +			break;
> +		case 'f':
> +			fflag = 1;
> +			break;
> +		case 'm':
> +			minlen = cvtnum(file->geom.blocksize,
> +					file->geom.sectsize, optarg);
> +			break;
> +		default:
> +			return command_usage(&trim_cmd);
> +		}
> +	}
> +
> +	if (aflag && fflag)
> +		return command_usage(&trim_cmd);
> +
> +	if (optind != argc - 2 && !(aflag || fflag))
> +		return command_usage(&trim_cmd);
> +	if (optind != argc) {
> +		offset = cvtnum(file->geom.blocksize, file->geom.sectsize,
> +				argv[optind]);
> +		length = cvtnum(file->geom.blocksize, file->geom.sectsize,
> +				argv[optind + 1]);
> +	} else if (agno) {
> +		offset = agno * file->geom.agblocks * file->geom.blocksize;
> +		length = file->geom.agblocks * file->geom.blocksize;
> +	} else {
> +		offset = 0;
> +		length = file->geom.datablocks * file->geom.blocksize;
> +	}
> +
> +	trim.start = offset;
> +	trim.len = length;
> +	trim.minlen = minlen;
> +
> +	ret = ioctl(file->fd, FITRIM, (unsigned long)&trim);
> +	if (ret < 0) {
> +		fprintf(stderr, "%s: ioctl(FITRIM) [\"%s\"]: "
> +			"%s\n", progname, file->name, strerror(errno));
> +		exitcode = 1;
> +	}
> +	return 0;
> +}
> +
> +static void
> +trim_help(void)
> +{
> +	printf(_(
> +"\n"
> +"Discard filesystem free space\n"
> +"\n"
> +" -a agno       -- trim all the freespace in the given AG agno\n"
> +" -f            -- trim all the freespace in the entire filesystem\n"
> +" offset length -- trim the freespace in the range {offset, length}\n"
> +" -m minlen     -- skip freespace extents smaller than minlen\n"
> +"\n"
> +"One of -a, -f, or the offset/length pair are required.\n"
> +"\n"));
> +
> +}
> +
> +void
> +trim_init(void)
> +{
> +	trim_cmd.name = "trim";
> +	trim_cmd.altname = "tr";
> +	trim_cmd.cfunc = trim_f;
> +	trim_cmd.argmin = 1;
> +	trim_cmd.argmax = 4;
> +	trim_cmd.args = "[-m minlen] ( -a agno | -f | offset length )";
> +	trim_cmd.flags = CMD_FLAG_ONESHOT;
> +	trim_cmd.oneline = _("Discard filesystem free space");
> +	trim_cmd.help = trim_help;
> +
> +	add_command(&trim_cmd);
> +}
> +
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

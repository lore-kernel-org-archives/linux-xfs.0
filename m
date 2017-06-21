Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60602 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751083AbdFUV0q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 17:26:46 -0400
Subject: Re: [PATCH 09/12] xfs_spaceman: add new speculative prealloc control
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
 <149755900449.3625.1673913017722813839.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <69e495ee-7c82-a7ad-5506-e2403b46005b@sandeen.net>
Date: Wed, 21 Jun 2017 16:26:44 -0500
MIME-Version: 1.0
In-Reply-To: <149755900449.3625.1673913017722813839.stgit@birch.djwong.org>
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
> Add an control interface for purging speculative
> preallocation via the new ioctls.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [darrick: change xfsctl to ioctl]
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  spaceman/Makefile   |    2 -
>  spaceman/init.c     |    1 
>  spaceman/prealloc.c |  118 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  spaceman/space.h    |    1 
>  4 files changed, 121 insertions(+), 1 deletion(-)
>  create mode 100644 spaceman/prealloc.c
> 
> 
> diff --git a/spaceman/Makefile b/spaceman/Makefile
> index c63a4fc..6aad746 100644
> --- a/spaceman/Makefile
> +++ b/spaceman/Makefile
> @@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
>  
>  LTCOMMAND = xfs_spaceman
>  HFILES = init.h space.h
> -CFILES = init.c file.c trim.c
> +CFILES = init.c file.c prealloc.c trim.c
>  
>  LLDLIBS = $(LIBXCMD)
>  LTDEPENDENCIES = $(LIBXCMD)
> diff --git a/spaceman/init.c b/spaceman/init.c
> index 107a692..a51007d 100644
> --- a/spaceman/init.c
> +++ b/spaceman/init.c
> @@ -39,6 +39,7 @@ init_commands(void)
>  {
>  	print_init();
>  	help_init();
> +	prealloc_init();
>  	quit_init();
>  	trim_init();
>  }
> diff --git a/spaceman/prealloc.c b/spaceman/prealloc.c
> new file mode 100644
> index 0000000..439a9e8
> --- /dev/null
> +++ b/spaceman/prealloc.c
> @@ -0,0 +1,118 @@
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
> +#include "command.h"
> +#include "input.h"
> +#include "init.h"
> +#include "space.h"
> +
> +static cmdinfo_t prealloc_cmd;
> +
> +/*
> + * Control preallocation amounts.
> + */
> +static int
> +prealloc_f(
> +	int	argc,
> +	char	**argv)
> +{
> +	struct xfs_fs_eofblocks eofb = {0};
> +	int	c;
> +
> +	eofb.eof_version = XFS_EOFBLOCKS_VERSION;
> +
> +	while ((c = getopt(argc, argv, "g:m:p:su:")) != EOF) {
> +		switch (c) {
> +		case 'g':
> +			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
> +			eofb.eof_gid = cvt_u32(optarg, 10);
> +			if (errno)
> +				return command_usage(&prealloc_cmd);
> +			break;
> +		case 'u':
> +			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
> +			eofb.eof_uid = cvt_u32(optarg, 10);
> +			if (errno)
> +				return command_usage(&prealloc_cmd);
> +			break;
> +		case 'p':
> +			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
> +			eofb.eof_prid = cvt_u32(optarg, 10);
> +			if (errno)
> +				return command_usage(&prealloc_cmd);
> +			break;
> +		case 's':
> +			eofb.eof_flags |= XFS_EOF_FLAGS_SYNC;
> +			break;
> +		case 'm':
> +			eofb.eof_flags |= XFS_EOF_FLAGS_MINFILESIZE;
> +			eofb.eof_min_file_size = cvtnum(file->geom.blocksize,
> +							file->geom.sectsize,
> +							optarg);
> +			break;
> +		case '?':
> +		default:
> +			return command_usage(&prealloc_cmd);
> +		}
> +	}
> +	if (optind != argc)
> +		return command_usage(&prealloc_cmd);
> +
> +	if (ioctl(file->fd, XFS_IOC_FREE_EOFBLOCKS, &eofb) < 0) {
> +		fprintf(stderr, _("%s: XFS_IOC_FREE_EOFBLOCKS on %s: %s\n"),
> +			progname, file->name, strerror(errno));
> +	}
> +	return 0;
> +}
> +
> +static void
> +prealloc_help(void)
> +{
> +	printf(_(
> +"\n"
> +"Control speculative preallocation\n"
> +"\n"
> +" -g gid    -- remove prealloc on files matching group <gid>\n"
> +" -m minlen -- only consider files larger than <minlen>\n"
> +" -p prid   -- remove prealloc on files matching project <prid>\n"
> +" -s        -- wait for removal to complete\n"
> +" -u uid    -- remove prealloc on files matching user <uid>\n"
> +"\n"
> +"If none of -u, -g, or -p are specified, this command acts on all files.\n"
> +"minlen can take units.\n"
> +"\n"));
> +
> +}
> +
> +void
> +prealloc_init(void)
> +{
> +	prealloc_cmd.name = "prealloc";
> +	prealloc_cmd.altname = "prealloc";
> +	prealloc_cmd.cfunc = prealloc_f;
> +	prealloc_cmd.argmin = 1;
> +	prealloc_cmd.argmax = -1;
> +	prealloc_cmd.args = "[-s] [-u id] [-g id] [-p id] [-m minlen]";
> +	prealloc_cmd.flags = CMD_FLAG_ONESHOT;
> +	prealloc_cmd.oneline = _("Control speculative preallocation");
> +	prealloc_cmd.help = prealloc_help;
> +
> +	add_command(&prealloc_cmd);
> +}
> +
> diff --git a/spaceman/space.h b/spaceman/space.h
> index 8cd3953..de97139 100644
> --- a/spaceman/space.h
> +++ b/spaceman/space.h
> @@ -33,6 +33,7 @@ extern int	addfile(char *, int , xfs_fsop_geom_t *);
>  
>  extern void	print_init(void);
>  extern void	help_init(void);
> +extern void	prealloc_init(void);
>  extern void	quit_init(void);
>  extern void	trim_init(void);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

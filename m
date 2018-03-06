Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48768 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753071AbeCFTcI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 14:32:08 -0500
Subject: Re: [PATCH 12/16] xfs_db: add a superblock info command
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993165958.22223.10507415725288169958.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <20edb4dd-80c4-76e6-d63d-09c6553b5c29@sandeen.net>
Date: Tue, 6 Mar 2018 13:32:06 -0600
MIME-Version: 1.0
In-Reply-To: <151993165958.22223.10507415725288169958.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

On 3/1/18 1:14 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add an 'info' command to pretty-print the superblock geometry.

I'm on the fence about this; xfs_db generally just dumps representations
of individual disk structures.  This seems like a bit of an expansion of
its charter.  What is the use case for this?  Convince me that it's good
to add this code?

Thanks,
-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/Makefile       |    2 +
>  db/command.c      |    1 +
>  db/command.h      |    1 +
>  db/info.c         |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/xfs_db.8 |    6 ++++
>  5 files changed, 83 insertions(+), 1 deletion(-)
>  create mode 100644 db/info.c
> 
> 
> diff --git a/db/Makefile b/db/Makefile
> index 6caa634..c73d7f2 100644
> --- a/db/Makefile
> +++ b/db/Makefile
> @@ -14,7 +14,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
>  	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
>  	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
>  	fuzz.h
> -CFILES = $(HFILES:.h=.c) btdump.c
> +CFILES = $(HFILES:.h=.c) btdump.c info.c
>  LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
>  
>  LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
> diff --git a/db/command.c b/db/command.c
> index 12ae5b7..087955e 100644
> --- a/db/command.c
> +++ b/db/command.c
> @@ -136,6 +136,7 @@ init_commands(void)
>  	fsmap_init();
>  	help_init();
>  	hash_init();
> +	info_init();
>  	inode_init();
>  	input_init();
>  	logres_init();
> diff --git a/db/command.h b/db/command.h
> index 9b4ed2d..84cd0b1 100644
> --- a/db/command.h
> +++ b/db/command.h
> @@ -41,3 +41,4 @@ extern const cmdinfo_t	*find_command(const char *cmd);
>  extern void		init_commands(void);
>  
>  extern void		btdump_init(void);
> +extern void		info_init(void);
> diff --git a/db/info.c b/db/info.c
> new file mode 100644
> index 0000000..7e7e4db
> --- /dev/null
> +++ b/db/info.c
> @@ -0,0 +1,74 @@
> +/*
> + * Copyright (C) 2018 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#include "libxfs.h"
> +#include "command.h"
> +#include "init.h"
> +#include "output.h"
> +#include "fsgeom.h"
> +
> +static void
> +info_help(void)
> +{
> +	dbprintf(_(
> +"\n"
> +" Pretty-prints the filesystem geometry as derived from the superblock.\n"
> +" The output has the same format as mkfs.\n"
> +"\n"
> +));
> +
> +}
> +
> +static int
> +info_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	struct xfs_fsop_geom	geo;
> +	int			error;
> +
> +	error = -libxfs_fs_geometry(&mp->m_sb, &geo,
> +			XFS_FS_GEOM_MAX_STRUCT_VER);
> +	if (error) {
> +		dbprintf(_("could not obtain geometry\n"));
> +		exitcode = 1;
> +		return 0;
> +	}
> +
> +	xfs_report_geom(&geo, fsdevice, x.logname, x.rtname);
> +	return 0;
> +}
> +
> +static const struct cmdinfo info_cmd = {
> +	.name =		"info",
> +	.altname =	"i",
> +	.cfunc =	info_f,
> +	.argmin =	0,
> +	.argmax =	0,
> +	.canpush =	0,
> +	.args =		NULL,
> +	.oneline =	N_("dump superblock info"),
> +	.help =		info_help,
> +};
> +
> +void
> +info_init(void)
> +{
> +	add_command(&info_cmd);
> +}
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 524b1ef..e29821e 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -670,6 +670,12 @@ using the hash function of the XFS directory and attribute implementation.
>  .BI "help [" command ]
>  Print help for one or all commands.
>  .TP
> +.B info
> +Displays selected geometry information about the filesystem.
> +The output will have the same format that
> +.BR "mkfs.xfs" "(8)"
> +prints when creating a filesystem.
> +.TP
>  .BI "inode [" inode# ]
>  Set the current inode number. If no
>  .I inode#
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

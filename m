Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56218 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932644AbeEHPYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 11:24:55 -0400
Date: Tue, 8 May 2018 08:24:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/9] xfs_spaceman: add a superblock info command
Message-ID: <20180508152433.GK11261@magnolia>
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
 <152401956907.13048.9916119316995542280.stgit@magnolia>
 <3166828d-0d56-adcd-32d1-2da12d13729a@sandeen.net>
 <20180503213904.GB26569@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180503213904.GB26569@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 02:39:04PM -0700, Darrick J. Wong wrote:
> On Thu, May 03, 2018 at 04:09:36PM -0500, Eric Sandeen wrote:
> > On 4/17/18 9:46 PM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Add an 'info' command to pretty-print the superblock geometry.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > 
> > 
> > 
> > > diff --git a/spaceman/file.c b/spaceman/file.c
> > > index 4f9f66c..6adb4f5 100644
> > > --- a/spaceman/file.c
> > > +++ b/spaceman/file.c
> > > @@ -84,6 +84,8 @@ openfile(
> > 
> >         char            *path,
> >         xfs_fsop_geom_t *geom,
> >         struct fs_path  *fs_path)
> > {
> > ..
> > 
> >         if (fs_path) {
> > ...
> > >  			return -1;
> > >  		}
> > >  		memcpy(fs_path, fsp, sizeof(struct fs_path));
> > > +	} else {
> > > +		memset(fs_path, 0, sizeof(struct fs_path));
> > >  	}
> > 
> > so if fs_path == NULL memset(NULL, 0) ?
> > 
> > Not sure what's going on here.
> > 
> > (or maybe I've forgotten how C works)
> 
> Not sure either.  The only caller of openfile() always passes in fs_path
> so the else clause can go away.  Bad xfs_io copy pasta, sorry. :(
> 
> --D

Dangit, I missed some comments.

> > >  	return fd;
> > >  }
> > > diff --git a/spaceman/info.c b/spaceman/info.c
> > > new file mode 100644
> > > index 0000000..b8b8133
> > > --- /dev/null
> > > +++ b/spaceman/info.c
> > > @@ -0,0 +1,96 @@
> > > +/*
> > > + * Copyright (C) 2018 Oracle.  All Rights Reserved.
> > > + *
> > > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License
> > > + * as published by the Free Software Foundation; either version 2
> > > + * of the License, or (at your option) any later version.
> > > + *
> > > + * This program is distributed in the hope that it would be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public License
> > > + * along with this program; if not, write the Free Software Foundation,
> > > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > > + */
> > > +#include "libxfs.h"
> > > +#include "command.h"
> > > +#include "init.h"
> > > +#include "path.h"
> > > +#include "space.h"
> > > +#include "fsgeom.h"
> > > +
> > > +static void
> > > +info_help(void)
> > > +{
> > > +	printf(_(
> > > +"\n"
> > > +" Pretty-prints the filesystem geometry as derived from the superblock.\n"
> > > +" The output has the same format as mkfs.  The opened file must be a XFS\n"
> > 
> > "an XFS?"

Sure.

> > > +" mount point.\n"
> > > +"\n"
> > > +));
> > > +
> > > +}
> > > +
> > > +static int
> > > +info_f(
> > > +	int			argc,
> > > +	char			**argv)
> > > +{
> > > +	struct xfs_fsop_geom	geo;
> > > +	int			error;
> > > +
> > > +	if (fs_table_lookup_mount(file->name) == NULL) {
> > > +		fprintf(stderr, _("%s: Not a XFS mount point.\n"), file->name);
> > > +		return 1;
> > > +	}
> > > +
> > > +	/* get the current filesystem size & geometry */
> > > +	error = ioctl(file->fd, XFS_IOC_FSGEOMETRY, &geo);
> > > +	if (error) {
> > > +		/*
> > > +		 * OK, new xfsctl barfed - back off and try earlier version
> > > +		 * as we're probably running an older kernel version.
> > > +		 * Only field added in the v2 geometry xfsctl is "logsunit"
> > > +		 * so we'll zero that out for later display (as zero).
> > > +		 */
> > > +		geo.logsunit = 0;
> > > +		error = ioctl(file->fd, XFS_IOC_FSGEOMETRY_V1, &geo);
> > 
> > We're certain that it won't fill in logsunit with junk, right?
> > Would it be any safer to set logsunit after or is that presupposing too
> > much about the interface?  I guess it's fine.

The kernel had better not fill logsunit with anything, since it copies
the v1 structure back to userspace and the v1 structure isn't long
enough to overlay logsunit.

> > > +		if (error) {
> > > +			fprintf(stderr, _(
> > > +				"%s: cannot determine geometry of filesystem"
> > > +				" mounted at %s: %s\n"),
> > > +				progname, file->name, strerror(errno));
> > > +			exitcode = 1;
> > > +			return 0;
> > > +		}
> > > +	}
> > > +
> > > +	xfs_report_geom(&geo, file->fs_path.fs_name, file->fs_path.fs_log,
> > > +			file->fs_path.fs_rt);
> > > +	return 0;
> > > +}
> > > +
> > > +static const struct cmdinfo info_cmd = {
> > > +	.name =		"info",
> > > +	.altname =	"i",
> > > +	.cfunc =	info_f,
> > > +	.argmin =	0,
> > > +	.argmax =	0,
> > > +	.canpush =	0,
> > > +	.args =		NULL,
> > > +	.flags =	CMD_FLAG_ONESHOT,
> > > +	.oneline =	N_("dump superblock info"),
> > 
> > "print geometry superblock info"

"pretty-print superblock geometry info" ?

--D

> > > +	.help =		info_help,
> > > +};
> > > +
> > > +void
> > > +info_init(void)
> > > +{
> > > +	add_command(&info_cmd);
> > > +}
> > > diff --git a/spaceman/init.c b/spaceman/init.c
> > > index b3eface..895504f 100644
> > > --- a/spaceman/init.c
> > > +++ b/spaceman/init.c
> > > @@ -40,6 +40,7 @@ init_commands(void)
> > >  {
> > >  	print_init();
> > >  	help_init();
> > > +	info_init();
> > >  	prealloc_init();
> > >  	quit_init();
> > >  	trim_init();
> > > diff --git a/spaceman/space.h b/spaceman/space.h
> > > index 5f4a8a0..d2a2543 100644
> > > --- a/spaceman/space.h
> > > +++ b/spaceman/space.h
> > > @@ -42,5 +42,6 @@ extern void	freesp_init(void);
> > >  #else
> > >  # define freesp_init()	do { } while (0)
> > >  #endif
> > > +extern void	info_init(void);
> > >  
> > >  #endif /* XFS_SPACEMAN_SPACE_H_ */
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

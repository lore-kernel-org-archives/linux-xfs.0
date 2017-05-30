Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34530 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdE3SYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 May 2017 14:24:45 -0400
Date: Tue, 30 May 2017 11:24:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/9] xfs_spaceman: add FITRIM support
Message-ID: <20170530182432.GX4519@birch.djwong.org>
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <149417260155.24656.16174864340015004658.stgit@birch.djwong.org>
 <ee86c948-9514-7a0f-1a0f-0c994c969030@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee86c948-9514-7a0f-1a0f-0c994c969030@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Fri, May 26, 2017 at 07:27:40PM -0500, Eric Sandeen wrote:
> On 5/7/17 10:56 AM, Darrick J. Wong wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add support for discarding free space extents via the FITRIM
> > command. Make it easy to discard a single range, an entire AG or all
> > the freespace in the filesystem.
> 
> So we re-implemented fstrim?  Do we need that?
> Ok I guess it knows per-AG, so... that's a thing.
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  spaceman/Makefile |    2 -
> >  spaceman/init.c   |    1 
> >  spaceman/space.h  |    1 
> >  spaceman/trim.c   |  139 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 142 insertions(+), 1 deletion(-)
> >  create mode 100644 spaceman/trim.c
> > 
> > 
> > diff --git a/spaceman/Makefile b/spaceman/Makefile
> > index ff8d23e..9fb9142 100644
> > --- a/spaceman/Makefile
> > +++ b/spaceman/Makefile
> > @@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
> >  LTCOMMAND = xfs_spaceman
> >  HFILES = init.h space.h
> >  CFILES = init.c \
> > -	file.c
> > +	file.c trim.c
> >  
> >  LLDLIBS = $(LIBXCMD)
> >  LTDEPENDENCIES = $(LIBXCMD)
> > diff --git a/spaceman/init.c b/spaceman/init.c
> > index 404b183..ae5cfb5 100644
> > --- a/spaceman/init.c
> > +++ b/spaceman/init.c
> > @@ -40,6 +40,7 @@ init_commands(void)
> >  	file_init();
> >  	help_init();
> >  	quit_init();
> > +	trim_init();
> >  }
> >  
> >  static int
> > diff --git a/spaceman/space.h b/spaceman/space.h
> > index 6e1bc52..7b4f034 100644
> > --- a/spaceman/space.h
> > +++ b/spaceman/space.h
> > @@ -34,3 +34,4 @@ extern int	addfile(char *, int , xfs_fsop_geom_t *, int);
> >  extern void	file_init(void);
> >  extern void	help_init(void);
> >  extern void	quit_init(void);
> > +extern void	trim_init(void);
> > diff --git a/spaceman/trim.c b/spaceman/trim.c
> > new file mode 100644
> > index 0000000..9bf6565
> > --- /dev/null
> > +++ b/spaceman/trim.c
> > @@ -0,0 +1,139 @@
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
> > +#include "libxfs.h"
> > +#include <linux/fs.h>
> > +#include "command.h"
> > +#include "init.h"
> > +#include "space.h"
> > +#include "input.h"
> > +
> > +#ifndef FITRIM
> 
> I wonder if we really still need this compat #ifndef...

Well, it's been in the kernel since 2.6.37 (2010) and XFS since 2.6.38
(2011).  Seven years seems long enough; even the RHEL6 kernel seems to
have FITRIM defined in it. (I think?)

> > +#define FITRIM          _IOWR('X', 121, struct fstrim_range)    /* Trim */
> > +
> > +struct fstrim_range {
> > +	__u64 start;
> > +	__u64 len;
> > +	__u64 minlen;
> > +};
> > +#endif
> > +
> > +static cmdinfo_t trim_cmd;
> > +
> > +/*
> > + * Report on trimace usage in xfs filesystem.
> 
> "Report on trimace?"  (Is that like a grimace?)

"Trim unused space"....

> > + */
> > +static int
> > +trim_f(
> > +	int		argc,
> > +	char		**argv)
> > +{
> > +	struct fstrim_range trim = {0};
> > +	xfs_agnumber_t	agno = 0;
> > +	off64_t		offset = 0;
> > +	ssize_t		length = 0;
> > +	ssize_t		minlen = 0;
> 
> len & minlen in the trim command are 64-bit, is ssize_t
> sufficient?

Probably, since cvtnum returns (signed long long) and file offsets in
Linux can't be larger than 2^63 anyway.

> > +	int		aflag = 0;
> > +	int		fflag = 0;
> > +	int		ret;
> > +	int		c;
> > +
> > +	while ((c = getopt(argc, argv, "a:fm:")) != EOF) {
> > +		switch (c) {
> > +		case 'a':
> > +			if (fflag)
> > +				return command_usage(&trim_cmd);
> > +			aflag = 1;
> > +			agno = atoi(optarg);
> > +			break;
> > +		case 'f':
> > +			if (aflag)
> > +				return command_usage(&trim_cmd);
> > +			fflag = 1;
> > +			break;
> > +		case 'm':
> > +			minlen = cvtnum(file->geom.blocksize,
> > +					file->geom.sectsize, argv[optind]);
> > +			break;
> > +		default:
> > +			return command_usage(&trim_cmd);
> > +		}
> > +	}
> 
> Not a huge deal, but maybe move the above command_usage stuff down here:
> 
> +	if (aflag && fflag)
> +		return command_usage(&trim_cmd);
> 
> so all the checking is in one spot.  Save Future-jtulak some grief ;)

Ok.

> > +
> > +	if (optind != argc - 2 && !(aflag || fflag))
> > +		return command_usage(&trim_cmd);
> > +	if (optind != argc) {
> > +		offset = cvtnum(file->geom.blocksize, file->geom.sectsize,
> > +				argv[optind]);
> > +		length = cvtnum(file->geom.blocksize, file->geom.sectsize,
> > +				argv[optind + 1]);
> > +	} else if (agno) {
> > +		offset = agno * file->geom.agblocks * file->geom.blocksize;
> > +		length = file->geom.agblocks * file->geom.blocksize;
> > +	} else {
> > +		offset = 0;
> > +		length = file->geom.datablocks * file->geom.blocksize;
> > +	}
> > +
> > +	trim.start = offset;
> > +	trim.len = length;
> > +	trim.minlen = minlen;
> > +
> > +	ret = ioctl(file->fd, FITRIM, (unsigned long)&trim);
> > +	if (ret < 0) {
> > +		fprintf(stderr, "%s: ioctl(FITRIM) [\"%s\"]: "
> > +			"%s\n", progname, file->name, strerror(errno));
> 
> +	if (ret < 0) {
> +		fprintf(stderr, "%s: ioctl(FITRIM) [\"%s\"]: %s\n",
> +			progname, file->name, strerror(errno));
> 
> > +		exitcode = 1;
> > +		return 0;
> 
> maybe don't need that return here (but don't really care)

Fixed.

> > +	}
> > +	return 0;
> > +}
> > +
> > +static void
> > +trim_help(void)
> > +{
> > +	printf(_(
> > +"\n"
> > +"Discard filesystem free space\n"
> > +"\n"
> > +"Options: [-m minlen] [-f]|[-a agno]|[offset length]\n"
> > +"\n"
> > +" -m minlen -- skip freespace extents smaller than minlen\n"
> > +" -f -- trim all the freespace in the entire filesystem\n"
> > +" -a agno -- trim all the freespace in the given AG agno\n"
> > +" offset length -- trim the freespace in the range {offset, length}\n"
> 
> xfs_io lines these things up (brute force whitespace) and looks nicer:
> 
>  -S   -- use an alternate seed number for filling the write buffer
>  -i   -- input file, source of data to write (used when writing forward)
>  -d   -- open the input file for direct IO
>  -s   -- skip a number of bytes at the start of the input file
>  -w   -- call fdatasync(2) at the end (included in timing results)
> 
> so:
> 
> +" -m minle      -- skip freespace extents smaller than minlen\n"
> +" -f            -- trim all the freespace in the entire filesystem\n"
> +" -a agno       -- trim all the freespace in the given AG agno\n"
> +" offset length -- trim the freespace in the range {offset, length}\n"

Ok.

> > +"\n"));
> > +
> > +}
> > +
> > +void
> > +trim_init(void)
> > +{
> > +	trim_cmd.name = "trim";
> > +	trim_cmd.altname = "tr";
> > +	trim_cmd.cfunc = trim_f;
> > +	trim_cmd.argmin = 1;
> > +	trim_cmd.argmax = 4;
> > +	trim_cmd.args = "[-m minlen] [-f]|[-a agno]|[offset length]\n";
> 
> Not sure we want \n at the end:
> 
> xfs_spaceman> help trim
> trim [-m minlen] [-f]|[-a agno]|[offset length]
>  -- Discard filesystem free space
> 
> xfs_io tends to put that all on one line - or are we worried about 80cols?

We aren't, since various xfs_io commands spill the first line over
80col.  Will fix.

--D

> > +	trim_cmd.flags = CMD_FLAG_ONESHOT;
> > +	trim_cmd.oneline = _("Discard filesystem free space");
> > +	trim_cmd.help = trim_help;
> > +
> > +	add_command(&trim_cmd);
> > +}
> > +
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

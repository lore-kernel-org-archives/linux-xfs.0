Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38689 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdFNQdC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2017 12:33:02 -0400
Date: Wed, 14 Jun 2017 09:32:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/10] xfs_spaceman: add FITRIM support
Message-ID: <20170614163253.GS4530@birch.djwong.org>
References: <149643307433.15899.922559884171553380.stgit@birch.djwong.org>
 <149643311135.15899.9680513857399078950.stgit@birch.djwong.org>
 <0468491a-0292-e708-ce43-5556f78bcb0d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0468491a-0292-e708-ce43-5556f78bcb0d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Wed, Jun 14, 2017 at 10:32:53AM -0500, Eric Sandeen wrote:
> On 6/2/17 2:51 PM, Darrick J. Wong wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add support for discarding free space extents via the FITRIM
> > command. Make it easy to discard a single range, an entire AG or all
> > the freespace in the filesystem.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  spaceman/Makefile |    2 -
> >  spaceman/init.c   |    1 
> >  spaceman/space.h  |    1 
> >  spaceman/trim.c   |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 130 insertions(+), 1 deletion(-)
> >  create mode 100644 spaceman/trim.c
> > 
> > 
> > diff --git a/spaceman/Makefile b/spaceman/Makefile
> > index df59edf..c63a4fc 100644
> > --- a/spaceman/Makefile
> > +++ b/spaceman/Makefile
> > @@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
> >  
> >  LTCOMMAND = xfs_spaceman
> >  HFILES = init.h space.h
> > -CFILES = init.c file.c
> > +CFILES = init.c file.c trim.c
> >  
> >  LLDLIBS = $(LIBXCMD)
> >  LTDEPENDENCIES = $(LIBXCMD)
> > diff --git a/spaceman/init.c b/spaceman/init.c
> > index 5dbaef2..0958377 100644
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
> > index 0000000..d58f6d1
> > --- /dev/null
> > +++ b/spaceman/trim.c
> > @@ -0,0 +1,127 @@
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
> > +static cmdinfo_t trim_cmd;
> > +
> > +/*
> > + * Trim unused space in xfs filesystem.
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
> > +	int		aflag = 0;
> > +	int		fflag = 0;
> > +	int		ret;
> > +	int		c;
> > +
> > +	while ((c = getopt(argc, argv, "a:fm:")) != EOF) {
> > +		switch (c) {
> > +		case 'a':
> > +			aflag = 1;
> > +			agno = atoi(optarg);
> 
> (do we want to detect errors with strtol?)  *shrug*

strtoul, since it's an AG number.

Some of the xfsprogs code still uses atoi, maybe they ought to be converted?

$ grep atoi.*optarg */*.c -n
db/freesp.c:170:                        equalsize = atoi(optarg);
db/freesp.c:176:                        addhistent(atoi(optarg));
db/freesp.c:182:                        multsize = atoi(optarg);
fsr/xfs_fsr.c:273:                      howlong = atoi(optarg);
fsr/xfs_fsr.c:282:                      argv_blksz_dio = atoi(optarg);
fsr/xfs_fsr.c:285:                      npasses = atoi(optarg);
fsr/xfs_fsr.c:290:                              nfrags = atoi(optarg);
growfs/xfs_growfs.c:169:                        maxpct = atoi(optarg);
io/bmap.c:97:                   nflag = atoi(optarg);
io/fiemap.c:230:                        max_extents = atoi(optarg);
io/fsmap.c:379:                 nflag = atoi(optarg);
logprint/logprint.c:197:                                print_start = atoi(optarg);
quota/project.c:290:                    recurse_depth = atoi(optarg);
quota/report.c:225:                     lower = (uint)atoi(optarg);
quota/report.c:228:                     upper = (uint)atoi(optarg);
quota/report.c:717:                     lower = (uint)atoi(optarg);
quota/report.c:721:                     upper = (uint)atoi(optarg);
rtcp/xfs_rtcp.c:49:                     extsize = atoi(optarg);

Separate patch, though...

> 
> > +			break;
> > +		case 'f':
> > +			fflag = 1;
> > +			break;
> > +		case 'm':
> > +			minlen = cvtnum(file->geom.blocksize,
> > +					file->geom.sectsize, argv[optind]);
> 
> s/argtv[optind]/optarg/ (see below)

Fixed.

> 
> > +			break;
> > +		default:
> > +			return command_usage(&trim_cmd);
> > +		}
> > +	}
> > +
> > +	if (aflag && fflag)
> > +		return command_usage(&trim_cmd);
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
> > +		exitcode = 1;
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
> 
> Don't restate the Options, that comes out already from
> the cmd args:
> 
> xfs_spaceman> help trim
> trim [-m minlen] [-f]|[-a agno]|[offset length] -- Discard filesystem free space
> 
> Discard filesystem free space
> 
> Options: [-m minlen] [-f]|[-a agno]|[offset length]

Fixed.

> > +"\n"
> > +" -m minlen     -- skip freespace extents smaller than minlen\n"
> > +" -f            -- trim all the freespace in the entire filesystem\n"
> > +" -a agno       -- trim all the freespace in the given AG agno\n"
> > +" offset length -- trim the freespace in the range {offset, length}\n"
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
> > +	trim_cmd.args = "[-m minlen] [-f]|[-a agno]|[offset length]";
> 
> I found myself wondering if any of these were default, and testing shows
> that nope, one is of the last 3 or'd options is required.  Is the above
> the standard way to represent that?
> 
> /me checks http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html
> 
> Meh, not sure.  If it were in a SYNOPSIS it would be 3 separate lines
> for each of the 3 modes (-f / -a / offset length)
> 
> is:
> 
> trim_cmd.args = "-f|-a agno|offset length [-m minlen] ";
> 
> any better?  Not sure there is a standard way to show mutually exclusive
> but required options on a single line.

ISTR seeing (in DOS land) people using:

(-a agno|-f|offset length)

to communicate that exactly one of the options has to be specified.
It's familiar at least to the extent that egrep uses the same syntax
to find any of the three options, and unfamiliar in that we're using
it here to mean XOR whereas egrep uses it for OR.

For now I'll amend the help text to state that exactly one of -a, -f,
or the offset/length pair are required.

> > +	trim_cmd.flags = CMD_FLAG_ONESHOT;
> > +	trim_cmd.oneline = _("Discard filesystem free space");
> > +	trim_cmd.help = trim_help;
> > +
> > +	add_command(&trim_cmd);
> > +}
> > +
> 
> A little testing....
> 
> xfs_spaceman> trim -m 16k
> Segmentation fault
> 
> (sadface)
> 
> ahah:
>                 case 'm':
>                         minlen = cvtnum(file->geom.blocksize,
> -                                       file->geom.sectsize, argv[optind]);
> +                                       file->geom.sectsize, optarg);

Fixed.

> Ok, also, am I forgetting how getopt works?
> 
> xfs_spaceman> trim -f -m
> trim: option requires an argument -- 'm'
> trim [-m minlen] [-f]|[-a agno]|[offset length] -- Discard filesystem free space
> 
> xfs_spaceman> trim -m -f
> trim [-m minlen] [-f]|[-a agno]|[offset length] -- Discard filesystem free space
> xfs_spaceman> 
> 
> getopt is interpreting "-f" as the required argument for "-m?"
> I didn't know it did that ....

Yep, it does that.  getopt("f:m") means that the next arg after -f is sucked
in as -f's argument even if it matches something else in the getopt string.
For all it knows, -m /is/ a valid input to -f.

> xfs_spaceman> trim -m -derp -f
> xfs_spaceman: ioctl(FITRIM) ["mnt/"]: Invalid argument
> 
> hm maybe we do want something better than atoi()...

strtoul, as mentioned above.

--D

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47948 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966433AbdEOTSs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2017 15:18:48 -0400
Date: Mon, 15 May 2017 12:18:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/9] xfs_io: support the new getfsmap ioctl
Message-ID: <20170515191809.GO4519@birch.djwong.org>
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <149417258268.24656.3441330396895207773.stgit@birch.djwong.org>
 <212fe5da-d589-1614-0980-ab583db1df5d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <212fe5da-d589-1614-0980-ab583db1df5d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Mon, May 08, 2017 at 04:01:11PM -0500, Eric Sandeen wrote:
> On 5/7/17 10:56 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  io/Makefile          |    4 
> >  io/copy_file_range.c |    2 
> >  io/encrypt.c         |    1 
> >  io/fsmap.c           |  559 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  io/init.c            |    8 +
> >  io/io.h              |   14 +
> >  io/open.c            |   21 ++
> >  io/pwrite.c          |    2 
> >  io/reflink.c         |    4 
> >  io/sendfile.c        |    2 
> >  man/man8/xfs_io.8    |   47 ++++
> >  11 files changed, 651 insertions(+), 13 deletions(-)
> >  create mode 100644 io/fsmap.c
> > 
> > 
> > diff --git a/io/Makefile b/io/Makefile
> > index 435ccff..8d3a30e 100644
> > --- a/io/Makefile
> > +++ b/io/Makefile
> > @@ -99,6 +99,10 @@ ifeq ($(HAVE_MREMAP),yes)
> >  LCFLAGS += -DHAVE_MREMAP
> >  endif
> >  
> > +ifeq ($(HAVE_GETFSMAP),yes)
> > +CFILES += fsmap.c
> > +endif
> > +
> >  default: depend $(LTCOMMAND)
> >  
> >  include $(BUILDRULES)
> > diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> > index 249c649..d1dfc5a 100644
> > --- a/io/copy_file_range.c
> > +++ b/io/copy_file_range.c
> > @@ -121,7 +121,7 @@ copy_range_f(int argc, char **argv)
> >  	if (optind != argc - 1)
> >  		return command_usage(&copy_range_cmd);
> >  
> > -	fd = openfile(argv[optind], NULL, IO_READONLY, 0);
> > +	fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
> >  	if (fd < 0)
> >  		return 0;
> >  
> > diff --git a/io/encrypt.c b/io/encrypt.c
> > index d844c5e..26ab97c 100644
> > --- a/io/encrypt.c
> > +++ b/io/encrypt.c
> > @@ -20,6 +20,7 @@
> >  #include "platform_defs.h"
> >  #include "command.h"
> >  #include "init.h"
> > +#include "path.h"
> >  #include "io.h"
> >  
> >  #ifndef ARRAY_SIZE
> > diff --git a/io/fsmap.c b/io/fsmap.c
> > new file mode 100644
> > index 0000000..4128fae
> > --- /dev/null
> > +++ b/io/fsmap.c
> > @@ -0,0 +1,559 @@
> > +/*
> > + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> > + *
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > + */
> > +#include "platform_defs.h"
> > +#include "command.h"
> > +#include "init.h"
> > +#include "path.h"
> > +#include "io.h"
> > +#include "input.h"
> > +
> > +static cmdinfo_t	fsmap_cmd;
> > +static dev_t		xfs_data_dev;
> > +
> > +static void
> > +fsmap_help(void)
> > +{
> > +	printf(_(
> > +"\n"
> > +" prints the block mapping for an XFS filesystem"
> 
> Did you want an \n" on the above line too?  Seems a bit odd to have it only on the next line.
> (one \n is fine too, but not like this) :)
> 
> > +"\n"
> > +" Example:\n"
> > +" 'fsmap -dlrv [-n nr] [startoff] [endoff]' - tabular format verbose map, including unwritten extents\n"
> 
> This doesn't match the short help:
> 
> +	fsmap_cmd.args = _("[-v] [-n nx] [start] [end]");
> 
> or the manpage:
> 
> +.BI "fsmap [ \-v ] [ \-n " nx " ] [ " start " ] [ " end " ]
> 
> but getopt sez:
> 
> > +	while ((c = getopt(argc, argv, "dln:rv")) != EOF) {
> 
> so I guess the short help & manpage need updates.
> 
> Also, I don't think the "Example:" above is valid:
> 
>         if (dflag + lflag + rflag > 1)
>                 return command_usage(&fsmap_cmd);
> 
> so the help needs to indicate that exactly 1 of -d, -l, or -r is required.
> 
> > +"\n"
> > +" fsmap prints the map of disk blocks used by the whole filesystem.\n"
> > +" The map lists each extent used by the file
> 
> <newbie>
> 
> "the file?"  what file?
> 
>                                                , as well as regions in the\n"
> > +" filesystem that do not have any corresponding blocks (free space).\n"
> > +" By default, each line of the listing takes the following form:\n"
> > +"     extent: [startoffset..endoffset] owner startblock..endblock\n"
> 
> say what "owner" means in this case?  </newbie>
> 
> > +" All the file offsets and disk blocks are in units of 512-byte blocks.\n"
> > +" -d -- query only the data device.\n"
> > +" -l -- query only the log device.\n"
> > +" -r -- query only the realtime device.\n"
> > +" -n -- query n extents.\n"
> > +" -v -- Verbose information, specify ag info.  Show flags legend on 2nd -v\n"
> > +"\n"));
> > +}
> > +
> > +static int
> > +numlen(
> > +	off64_t	val)
> > +{
> > +	off64_t	tmp;
> > +	int	len;
> > +
> > +	for (len = 0, tmp = val; tmp > 0; tmp = tmp/10)
> > +		len++;
> > +	return (len == 0 ? 1 : len);
> > +}
> 
> Hm, copy #3, do we still not have anywhere to put common stuff like this?
> 
> > +
> > +#define OWNER_BUF_SZ	32
> > +static const char *
> > +special_owner(
> > +	__int64_t	owner,
> > +	char		*buf)
> > +{
> > +	switch (owner) {
> > +	case XFS_FMR_OWN_FREE:
> > +		return _("free space");
> > +	case XFS_FMR_OWN_UNKNOWN:
> > +		return _("unknown");
> > +	case XFS_FMR_OWN_FS:
> > +		return _("static fs metadata");
> > +	case XFS_FMR_OWN_LOG:
> > +		return _("journalling log");
> > +	case XFS_FMR_OWN_AG:
> > +		return _("per-AG metadata");
> > +	case XFS_FMR_OWN_INOBT:
> > +		return _("inode btree");
> > +	case XFS_FMR_OWN_INODES:
> > +		return _("inodes");
> > +	case XFS_FMR_OWN_REFC:
> > +		return _("refcount btree");
> > +	case XFS_FMR_OWN_COW:
> > +		return _("cow reservation");
> > +	case XFS_FMR_OWN_DEFECTIVE:
> > +		return _("defective");
> > +	default:
> > +		snprintf(buf, OWNER_BUF_SZ, _("special %u:%u"),
> > +				FMR_OWNER_TYPE(owner), FMR_OWNER_CODE(owner));
> > +		return buf;
> > +	}
> > +}
> > +
> > +static void
> > +dump_map(
> > +	unsigned long long	*nr,
> > +	struct fsmap_head	*head)
> > +{
> > +	unsigned long long	i;
> > +	struct fsmap		*p;
> > +	char			owner[OWNER_BUF_SZ];
> > +
> > +	for (i = 0, p = head->fmh_recs; i < head->fmh_entries; i++, p++) {
> > +		printf("\t%llu: %u:%u [%lld..%lld]: ", i + (*nr),
> > +			major(p->fmr_device), minor(p->fmr_device),
> > +			(long long)BTOBBT(p->fmr_physical),
> > +			(long long)BTOBBT(p->fmr_physical + p->fmr_length - 1));
> > +		if (p->fmr_flags & FMR_OF_SPECIAL_OWNER)
> > +			printf("%s", special_owner(p->fmr_owner, owner));
> > +		else if (p->fmr_flags & FMR_OF_EXTENT_MAP)
> > +			printf(_("inode %lld extent map"),
> > +				(long long) p->fmr_owner);
> > +		else
> > +			printf(_("inode %lld %lld..%lld"),
> > +				(long long)p->fmr_owner,
> > +				(long long)BTOBBT(p->fmr_offset),
> > +				(long long)BTOBBT(p->fmr_offset + p->fmr_length - 1));
> > +		printf(_(" %lld blocks\n"),
> > +			(long long)BTOBBT(p->fmr_length));
> > +	}
> > +
> > +	(*nr) += head->fmh_entries;
> > +}
> > +
> > +/*
> > + * Verbose mode displays:
> > + *   extent: major:minor [startblock..endblock]: startoffset..endoffset \
> > + *	ag# (agoffset..agendoffset) totalbbs flags
> > + */
> > +#define MINRANGE_WIDTH	16
> > +#define MINAG_WIDTH	2
> > +#define MINTOT_WIDTH	5
> > +#define NFLG		7		/* count of flags */
> > +#define	FLG_NULL	00000000	/* Null flag */
> > +#define	FLG_SHARED	01000000	/* shared extent */
> > +#define	FLG_ATTR_FORK	00100000	/* attribute fork */
> > +#define	FLG_PRE		00010000	/* Unwritten extent */
> > +#define	FLG_BSU		00001000	/* Not on begin of stripe unit  */
> > +#define	FLG_ESU		00000100	/* Not on end   of stripe unit  */
> > +#define	FLG_BSW		00000010	/* Not on begin of stripe width */
> > +#define	FLG_ESW		00000001	/* Not on end   of stripe width */
> 
> These really couldn't share w/ io/bmap.c?  :(
> (could FLG_ATTR_FORK go to the end so that it matches bmap until then?)

Well yes, we could flip them (I already did); afaict the only change
that needs to happen is an update to xfs/274.

> speakinawhich, I wonder how much of this is copied from bmap, and what could
> be shared?
> 
> I'm going to go off & look at that a bit, may have further comments.  :)

Do you have further comments?

--D

> 
> 
> > diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> > index 29a036c..2c956b8 100644
> > --- a/man/man8/xfs_io.8
> > +++ b/man/man8/xfs_io.8
> > @@ -301,6 +301,53 @@ ioctl.  Options behave as described in the
> >  .BR xfs_bmap (8)
> >  manual page.
> >  .TP
> > +.BI "fsmap [ \-v ] [ \-n " nx " ] [ " start " ] [ " end " ]
> > +Prints the mapping of disk blocks used by an XFS filesystem.
> 
> FOREIGN_OK too right?
> 
> -Eric
> 
> >  The map
> > +lists each extent used by files, allocation group metadata,
> > +journalling logs, and static filesystem metadata, as well as any
> > +regions that are unused.  Each line of the listings takes the
> > +following form:
> > +.PP
> > +.RS
> > +.IR extent ": " major ":" minor " [" startblock .. endblock "]: " owner " " startoffset .. endoffset " " length
> > +.PP
> > +Static filesystem metadata, allocation group metadata, btrees,
> > +journalling logs, and free space are marked by replacing the
> > +.IR startoffset .. endoffset
> > +with the appropriate marker.  All blocks, offsets, and lengths are specified
> > +in units of 512-byte blocks, no matter what the filesystem's block size is.
> > +.BI "The optional " start " and " end " arguments can be used to constrain
> > +the output to a particular range of disk blocks.
> > +.RE
> > +.RS 1.0i
> > +.PD 0
> > +.TP
> > +.BI \-n " num_extents"
> > +If this option is given,
> > +.B xfs_fsmap
> > +obtains the extent list of the file in groups of
> > +.I num_extents
> > +extents. In the absence of
> > +.BR \-n ", " xfs_fsmap
> > +queries the system for the number of extents in the filesystem and uses that
> > +value to compute the group size.
> > +.TP
> > +.B \-v
> > +Shows verbose information. When this flag is specified, additional AG
> > +specific information is appended to each line in the following form:
> > +.IP
> > +.RS 1.2i
> > +.IR agno " (" startagblock .. endagblock ") " nblocks " " flags
> > +.RE
> > +.IP
> > +A second
> > +.B \-v
> > +option will print out the
> > +.I flags
> > +legend.
> > +.RE
> > +.PD
> > +.TP
> >  .BI "extsize [ \-R | \-D ] [ " value " ]"
> >  Display and/or modify the preferred extent size used when allocating
> >  space for the currently open file. If the
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49774 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752615AbdFMWU3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Jun 2017 18:20:29 -0400
Subject: Re: [PATCH 03/10] xfs_io: support the new getfsmap ioctl
References: <149643307433.15899.922559884171553380.stgit@birch.djwong.org>
 <149643309277.15899.8992260632053602994.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e7125566-4a05-57dd-ca6c-5eac3f739d16@sandeen.net>
Date: Tue, 13 Jun 2017 17:20:28 -0500
MIME-Version: 1.0
In-Reply-To: <149643309277.15899.8992260632053602994.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/2/17 2:51 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Sorry Darrick, lots more here that I missed the first time around.

> ---
>  io/Makefile          |    7 +
>  io/copy_file_range.c |    2 
>  io/encrypt.c         |    1 
>  io/fsmap.c           |  549 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  io/init.c            |    8 +
>  io/io.h              |   14 +
>  io/open.c            |   21 ++
>  io/pwrite.c          |    2 
>  io/reflink.c         |    4 
>  io/sendfile.c        |    2 
>  man/man8/xfs_io.8    |   66 ++++++
>  11 files changed, 663 insertions(+), 13 deletions(-)
>  create mode 100644 io/fsmap.c
> 
> 
> diff --git a/io/Makefile b/io/Makefile
> index 435ccff..47b0a66 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -99,6 +99,13 @@ ifeq ($(HAVE_MREMAP),yes)
>  LCFLAGS += -DHAVE_MREMAP
>  endif
>  
> +# On linux we get fsmap from the system or define it ourselves
> +# so include this based on platform type.  If this reverts to only
> +# the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
> +ifeq ($(PKG_PLATFORM),linux)
> +CFILES += fsmap.c
> +endif
> +
>  default: depend $(LTCOMMAND)
>  
>  include $(BUILDRULES)
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index 249c649..d1dfc5a 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -121,7 +121,7 @@ copy_range_f(int argc, char **argv)
>  	if (optind != argc - 1)
>  		return command_usage(&copy_range_cmd);
>  
> -	fd = openfile(argv[optind], NULL, IO_READONLY, 0);
> +	fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
>  	if (fd < 0)
>  		return 0;
>  
> diff --git a/io/encrypt.c b/io/encrypt.c
> index d844c5e..26ab97c 100644
> --- a/io/encrypt.c
> +++ b/io/encrypt.c
> @@ -20,6 +20,7 @@
>  #include "platform_defs.h"
>  #include "command.h"
>  #include "init.h"
> +#include "path.h"
>  #include "io.h"
>  
>  #ifndef ARRAY_SIZE
> diff --git a/io/fsmap.c b/io/fsmap.c
> new file mode 100644
> index 0000000..1f4de81
> --- /dev/null
> +++ b/io/fsmap.c
> @@ -0,0 +1,549 @@
> +/*
> + * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
> +#include "platform_defs.h"
> +#include "command.h"
> +#include "init.h"
> +#include "path.h"
> +#include "io.h"
> +#include "input.h"
> +
> +static cmdinfo_t	fsmap_cmd;
> +static dev_t		xfs_data_dev;
> +
> +static void
> +fsmap_help(void)
> +{
> +	printf(_(
> +"\n"
> +" Prints the block mapping for a filesystem"
> +"\n"
> +" Example:\n"
> +" 'fsmap [-d|-l|-r] [-v] [-n nr] [startoff] [endoff]' - tabular format verbose map, including unwritten extents\n"

Whoops, I missed this the first time, that's a restatement of all options,
not an example.

(Or I'd probably just drop it, I don't think an example is needed
or useful, but as you like it... I guess it's modeled on fiemap)

> +"\n"
> +" fsmap prints the map of disk blocks used by the whole filesystem.\n"
> +" When possible, owner and offset information will be included in the\n"
> +" sapce report.\n"
> +"\n"
> +" By default, each line of the listing takes the following form:\n"
> +"     extent: [startoffset..endoffset] owner startblock..endblock\n"

Hm, no:

	0: 8:17 [0..1175]: unknown 1176 blocks
	1: 8:17 [1176..1183]: free space 8 blocks

manpage gets it right:

extent: major:minor [startblock..endblock]: owner startoffset..endoffset length

(I might drop the last "blocks"... is it useful?  fiemap doesn't use it)


Sigh, sorry for missing stuff on the first round.

OK fiemap prints a header with -v ...

# io/xfs_io -c "fiemap -v" /mnt/test/junk
/mnt/test/junk:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..7]:          hole                 8
   1: [8..39]:         5936..5967          32   0x0

I think that'd be useful here, too ... oh, bug.  see below.  (s/nr == 0/*nr == 0/)

> +" The owner field is either an inode number or a special value.\n"
> +" All the file offsets and disk blocks are in units of 512-byte blocks.\n"
> +" -d -- query only the data device.\n"

(this is the default, yes?)

> +" -l -- query only the log device.\n"

Hm, with an external log I get:

xfs_io> fsmap -l
	0: 7:7 [0..2097151]: journalling log 2097152 blocks

but an internal log does not show those blocks in the output, should it?

> +" -r -- query only the realtime device.\n"
> +" -n -- query n extents.\n"

-n doesn't seem to work as described:

# io/xfs_io -c "fsmap -n 2" /mnt/test
	0: 8:17 [0..1175]: unknown 1176 blocks
	1: 8:17 [1176..1183]: free space 8 blocks
	2: 8:17 [1184..1327]: unknown 144 blocks
	3: 8:17 [1328..1343]: free space 16 blocks

Oh, it's "at a time" - so help text needs to be fixed to reflect that it's 
the size of each query, not the total number queried.

> +" -v -- Verbose information, specify ag info.  Show flags legend on 2nd -v\n"

(and FILE-OFFSET of each owner?)

There are no flags printed AFAICT, and no different behavior with -vv...
but that seems broken somewhere.

Oh, it looks like if no flags are (will be?) printed we skip the column
and the legend.  That seems a little odd to me... is it intentional?

> +"\n"));
> +}
> +
> +#define OWNER_BUF_SZ	32
> +static const char *
> +special_owner(
> +	int64_t		owner,
> +	char		*buf)
> +{
> +	switch (owner) {
> +	case XFS_FMR_OWN_FREE:
> +		return _("free space");

(Aside: I wonder if there's any way to avoid spaces in the owner field,
so that awk can easily parse the result...?  Not sure how that'd look,
but it'd make it a lot more useful when presented with thousands of
records)

> +	case XFS_FMR_OWN_UNKNOWN:
> +		return _("unknown");
> +	case XFS_FMR_OWN_FS:
> +		return _("static fs metadata");
> +	case XFS_FMR_OWN_LOG:
> +		return _("journalling log");
> +	case XFS_FMR_OWN_AG:
> +		return _("per-AG metadata");
> +	case XFS_FMR_OWN_INOBT:
> +		return _("inode btree");
> +	case XFS_FMR_OWN_INODES:
> +		return _("inodes");
> +	case XFS_FMR_OWN_REFC:
> +		return _("refcount btree");
> +	case XFS_FMR_OWN_COW:
> +		return _("cow reservation");
> +	case XFS_FMR_OWN_DEFECTIVE:
> +		return _("defective");
> +	default:
> +		snprintf(buf, OWNER_BUF_SZ, _("special %u:%u"),
> +				FMR_OWNER_TYPE(owner), FMR_OWNER_CODE(owner));
> +		return buf;
> +	}
> +}
> +
> +static void
> +dump_map(
> +	unsigned long long	*nr,
> +	struct fsmap_head	*head)
> +{
> +	unsigned long long	i;
> +	struct fsmap		*p;
> +	char			owner[OWNER_BUF_SZ];
> +
> +	for (i = 0, p = head->fmh_recs; i < head->fmh_entries; i++, p++) {
> +		printf("\t%llu: %u:%u [%lld..%lld]: ", i + (*nr),
> +			major(p->fmr_device), minor(p->fmr_device),
> +			(long long)BTOBBT(p->fmr_physical),
> +			(long long)BTOBBT(p->fmr_physical + p->fmr_length - 1));
> +		if (p->fmr_flags & FMR_OF_SPECIAL_OWNER)
> +			printf("%s", special_owner(p->fmr_owner, owner));
> +		else if (p->fmr_flags & FMR_OF_EXTENT_MAP)
> +			printf(_("inode %lld extent map"),
> +				(long long) p->fmr_owner);
> +		else
> +			printf(_("inode %lld %lld..%lld"),
> +				(long long)p->fmr_owner,
> +				(long long)BTOBBT(p->fmr_offset),
> +				(long long)BTOBBT(p->fmr_offset + p->fmr_length - 1));
> +		printf(_(" %lld blocks\n"),
> +			(long long)BTOBBT(p->fmr_length));
> +	}
> +
> +	(*nr) += head->fmh_entries;
> +}
> +
> +/*
> + * Verbose mode displays:
> + *   extent: major:minor [startblock..endblock]: startoffset..endoffset \
> + *	ag# (agoffset..agendoffset) totalbbs flags
> + */
> +#define MINRANGE_WIDTH	16
> +#define MINAG_WIDTH	2
> +#define MINTOT_WIDTH	5
> +#define NFLG		7		/* count of flags */
> +#define	FLG_NULL	00000000	/* Null flag */
> +#define	FLG_ATTR_FORK	01000000	/* attribute fork */
> +#define	FLG_SHARED	00100000	/* shared extent */
> +#define	FLG_PRE		00010000	/* Unwritten extent */
> +#define	FLG_BSU		00001000	/* Not on begin of stripe unit  */
> +#define	FLG_ESU		00000100	/* Not on end   of stripe unit  */
> +#define	FLG_BSW		00000010	/* Not on begin of stripe width */
> +#define	FLG_ESW		00000001	/* Not on end   of stripe width */
> +static void
> +dump_map_verbose(
> +	unsigned long long	*nr,
> +	struct fsmap_head	*head,
> +	bool			*dumped_flags,
> +	struct xfs_fsop_geom	*fsgeo)
> +{
> +	unsigned long long	i;
> +	struct fsmap		*p;
> +	int			agno;
> +	off64_t			agoff, bperag;
> +	int			foff_w, boff_w, aoff_w, tot_w, agno_w, own_w;
> +	int			nr_w, dev_w;
> +	char			rbuf[32], bbuf[32], abuf[32], obuf[32];
> +	char			nbuf[32], dbuf[32], gbuf[32];
> +	char			owner[OWNER_BUF_SZ];
> +	int			sunit, swidth;
> +	int			flg = 0;
> +
> +	foff_w = boff_w = aoff_w = own_w = MINRANGE_WIDTH;
> +	dev_w = 3;
> +	nr_w = 4;
> +	tot_w = MINTOT_WIDTH;
> +	bperag = (off64_t)fsgeo->agblocks *
> +		  (off64_t)fsgeo->blocksize;
> +	sunit = (fsgeo->sunit * fsgeo->blocksize);
> +	swidth = (fsgeo->swidth * fsgeo->blocksize);
> +
> +	/*
> +	 * Go through the extents and figure out the width
> +	 * needed for all columns.
> +	 */
> +	for (i = 0, p = head->fmh_recs; i < head->fmh_entries; i++, p++) {
> +		if (p->fmr_flags & FMR_OF_PREALLOC ||
> +		    p->fmr_flags & FMR_OF_ATTR_FORK ||
> +		    p->fmr_flags & FMR_OF_SHARED)
> +			flg = 1;
> +		if (sunit &&
> +		    (p->fmr_physical  % sunit != 0 ||
> +		     ((p->fmr_physical + p->fmr_length) % sunit) != 0 ||
> +		     p->fmr_physical % swidth != 0 ||
> +		     ((p->fmr_physical + p->fmr_length) % swidth) != 0))
> +			flg = 1;
> +		if (flg)
> +			*dumped_flags = true;
> +		snprintf(nbuf, sizeof(nbuf), "%llu", (*nr) + i);
> +		nr_w = max(nr_w, strlen(nbuf));
> +		if (head->fmh_oflags & FMH_OF_DEV_T)
> +			snprintf(dbuf, sizeof(dbuf), "%u:%u",
> +				major(p->fmr_device),
> +				minor(p->fmr_device));
> +		else
> +			snprintf(dbuf, sizeof(dbuf), "0x%x", p->fmr_device);
> +		dev_w = max(dev_w, strlen(dbuf));
> +		snprintf(bbuf, sizeof(bbuf), "[%lld..%lld]:",
> +			(long long)BTOBBT(p->fmr_physical),
> +			(long long)BTOBBT(p->fmr_physical + p->fmr_length - 1));
> +		boff_w = max(boff_w, strlen(bbuf));
> +		if (p->fmr_flags & FMR_OF_SPECIAL_OWNER)
> +			own_w = max(own_w, strlen(
> +					special_owner(p->fmr_owner, owner)));
> +		else {
> +			snprintf(obuf, sizeof(obuf), "%lld",
> +				(long long)p->fmr_owner);
> +			own_w = max(own_w, strlen(obuf));
> +		}
> +		if (p->fmr_flags & FMR_OF_EXTENT_MAP)
> +			foff_w = max(foff_w, strlen(_("extent_map")));
> +		else if (p->fmr_flags & FMR_OF_SPECIAL_OWNER)
> +			;
> +		else {
> +			snprintf(rbuf, sizeof(rbuf), "%lld..%lld",
> +				(long long)BTOBBT(p->fmr_offset),
> +				(long long)BTOBBT(p->fmr_offset + p->fmr_length - 1));
> +			foff_w = max(foff_w, strlen(rbuf));
> +		}
> +		if (p->fmr_device == xfs_data_dev) {
> +			agno = p->fmr_physical / bperag;
> +			agoff = p->fmr_physical - (agno * bperag);
> +			snprintf(abuf, sizeof(abuf),
> +				"(%lld..%lld)",
> +				(long long)BTOBBT(agoff),
> +				(long long)BTOBBT(agoff + p->fmr_length - 1));
> +		} else
> +			abuf[0] = 0;
> +		aoff_w = max(aoff_w, strlen(abuf));
> +		tot_w = max(tot_w,
> +			numlen(BTOBBT(p->fmr_length), 10));
> +	}
> +	agno_w = max(MINAG_WIDTH, numlen(fsgeo->agcount, 10));
> +	if (nr == 0)

if (*nr == 0)

> +		printf("%*s: %-*s %-*s %-*s %-*s %*s %-*s %*s%s\n",
> +			nr_w, _("EXT"),
> +			dev_w, _("DEV"),
> +			boff_w, _("BLOCK-RANGE"),
> +			own_w, _("OWNER"),
> +			foff_w, _("FILE-OFFSET"),
> +			agno_w, _("AG"),
> +			aoff_w, _("AG-OFFSET"),
> +			tot_w, _("TOTAL"),
> +			flg ? _(" FLAGS") : "");
> +	for (i = 0, p = head->fmh_recs; i < head->fmh_entries; i++, p++) {
> +		flg = FLG_NULL;
> +		if (p->fmr_flags & FMR_OF_PREALLOC)
> +			flg |= FLG_PRE;
> +		if (p->fmr_flags & FMR_OF_ATTR_FORK)
> +			flg |= FLG_ATTR_FORK;
> +		if (p->fmr_flags & FMR_OF_SHARED)
> +			flg |= FLG_SHARED;
> +		/*
> +		 * If striping enabled, determine if extent starts/ends
> +		 * on a stripe unit boundary.
> +		 */
> +		if (sunit) {
> +			if (p->fmr_physical  % sunit != 0)
> +				flg |= FLG_BSU;
> +			if (((p->fmr_physical +
> +			      p->fmr_length ) % sunit ) != 0)
> +				flg |= FLG_ESU;
> +			if (p->fmr_physical % swidth != 0)
> +				flg |= FLG_BSW;
> +			if (((p->fmr_physical +
> +			      p->fmr_length ) % swidth ) != 0)
> +				flg |= FLG_ESW;
> +		}
> +		if (head->fmh_oflags & FMH_OF_DEV_T)
> +			snprintf(dbuf, sizeof(dbuf), "%u:%u",
> +				major(p->fmr_device),
> +				minor(p->fmr_device));
> +		else
> +			snprintf(dbuf, sizeof(dbuf), "0x%x", p->fmr_device);
> +		snprintf(bbuf, sizeof(bbuf), "[%lld..%lld]:",
> +			(long long)BTOBBT(p->fmr_physical),
> +			(long long)BTOBBT(p->fmr_physical + p->fmr_length - 1));
> +		if (p->fmr_flags & FMR_OF_SPECIAL_OWNER) {
> +			snprintf(obuf, sizeof(obuf), "%s",
> +				special_owner(p->fmr_owner, owner));
> +			snprintf(rbuf, sizeof(rbuf), " ");
> +		} else {
> +			snprintf(obuf, sizeof(obuf), "%lld",
> +				(long long)p->fmr_owner);
> +			snprintf(rbuf, sizeof(rbuf), "%lld..%lld",
> +				(long long)BTOBBT(p->fmr_offset),
> +				(long long)BTOBBT(p->fmr_offset + p->fmr_length - 1));
> +		}
> +		if (p->fmr_device == xfs_data_dev) {
> +			agno = p->fmr_physical / bperag;
> +			agoff = p->fmr_physical - (agno * bperag);
> +			snprintf(abuf, sizeof(abuf),
> +				"(%lld..%lld)",
> +				(long long)BTOBBT(agoff),
> +				(long long)BTOBBT(agoff + p->fmr_length - 1));
> +			snprintf(gbuf, sizeof(gbuf),
> +				"%lld",
> +				(long long)agno);
> +		} else {
> +			abuf[0] = 0;
> +			gbuf[0] = 0;
> +		}
> +		if (p->fmr_flags & FMR_OF_EXTENT_MAP)
> +			printf("%*llu: %-*s %-*s %-*s %-*s %-*s %-*s %*lld\n",
> +				nr_w, (*nr) + i,
> +				dev_w, dbuf,
> +				boff_w, bbuf,
> +				own_w, obuf,
> +				foff_w, _("extent map"),
> +				agno_w, gbuf,
> +				aoff_w, abuf,
> +				tot_w, (long long)BTOBBT(p->fmr_length));
> +		else {
> +			printf("%*llu: %-*s %-*s %-*s %-*s", nr_w, (*nr) + i,
> +				dev_w, dbuf, boff_w, bbuf, own_w, obuf,
> +				foff_w, rbuf);
> +			printf(" %-*s %-*s", agno_w, gbuf,
> +				aoff_w, abuf);
> +			printf(" %*lld", tot_w,
> +				(long long)BTOBBT(p->fmr_length));
> +			if (flg == FLG_NULL)
> +				printf("\n");
> +			else
> +				printf(" %-*.*o\n", NFLG, NFLG, flg);
> +		}
> +	}
> +
> +	(*nr) += head->fmh_entries;
> +}
> +
> +static void
> +dump_verbose_key(void)
> +{
> +	printf(_(" FLAG Values:\n"));
> +	printf(_("    %*.*o Attribute fork\n"),
> +		NFLG+1, NFLG+1, FLG_ATTR_FORK);
> +	printf(_("    %*.*o Shared extent\n"),
> +		NFLG+1, NFLG+1, FLG_SHARED);
> +	printf(_("    %*.*o Unwritten preallocated extent\n"),
> +		NFLG+1, NFLG+1, FLG_PRE);
> +	printf(_("    %*.*o Doesn't begin on stripe unit\n"),
> +		NFLG+1, NFLG+1, FLG_BSU);
> +	printf(_("    %*.*o Doesn't end   on stripe unit\n"),
> +		NFLG+1, NFLG+1, FLG_ESU);
> +	printf(_("    %*.*o Doesn't begin on stripe width\n"),
> +		NFLG+1, NFLG+1, FLG_BSW);
> +	printf(_("    %*.*o Doesn't end   on stripe width\n"),
> +		NFLG+1, NFLG+1, FLG_ESW);
> +}
> +
> +int
> +fsmap_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	struct fsmap		*p;
> +	struct fsmap_head	*nhead;
> +	struct fsmap_head	*head;
> +	struct fsmap		*l, *h;
> +	struct xfs_fsop_geom	fsgeo;
> +	long long		start = 0;
> +	long long		end = -1;
> +	int			nmap_size;
> +	int			map_size;
> +	int			nflag = 0;
> +	int			vflag = 0;
> +	int			i = 0;
> +	int			c;
> +	unsigned long long	nr = 0;
> +	size_t			fsblocksize, fssectsize;
> +	struct fs_path		*fs;
> +	static bool		tab_init;
> +	bool			dumped_flags = false;
> +	int			dflag, lflag, rflag;
> +
> +	init_cvtnum(&fsblocksize, &fssectsize);
> +
> +	dflag = lflag = rflag = 0;
> +	while ((c = getopt(argc, argv, "dln:rv")) != EOF) {
> +		switch (c) {
> +		case 'd':	/* data device */
> +			dflag = 1;
> +			break;
> +		case 'l':	/* log device */
> +			lflag = 1;
> +			break;
> +		case 'n':	/* number of extents specified */
> +			nflag = atoi(optarg);
> +			break;
> +		case 'r':	/* rt device */
> +			rflag = 1;
> +			break;
> +		case 'v':	/* Verbose output */
> +			vflag++;
> +			break;
> +		default:
> +			return command_usage(&fsmap_cmd);
> +		}
> +	}
> +
> +	if (dflag + lflag + rflag > 1)
> +		return command_usage(&fsmap_cmd);
> +
> +	if (argc > optind && dflag + lflag + rflag == 0)
> +		return command_usage(&fsmap_cmd);
> +
> +	if (argc > optind) {
> +		start = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +		if (start < 0) {
> +			fprintf(stderr,
> +				_("Bad rmap start_bblock %s.\n"),
> +				argv[optind]);
> +			return 0;
> +		}
> +		start <<= BBSHIFT;
> +	}
> +
> +	if (argc > optind + 1) {
> +		end = cvtnum(fsblocksize, fssectsize, argv[optind + 1]);
> +		if (end < 0) {
> +			fprintf(stderr,
> +				_("Bad rmap end_bblock %s.\n"),
> +				argv[optind + 1]);
> +			return 0;
> +		}
> +		end <<= BBSHIFT;
> +	}
> +
> +	if (vflag) {
> +		c = ioctl(file->fd, XFS_IOC_FSGEOMETRY, &fsgeo);
> +		if (c < 0) {
> +			fprintf(stderr,
> +				_("%s: can't get geometry [\"%s\"]: %s\n"),
> +				progname, file->name, strerror(errno));
> +			exitcode = 1;
> +			return 0;
> +		}
> +	}
> +
> +	map_size = nflag ? nflag : 131072 / sizeof(struct fsmap);

Manpage, below:

"In the absence of -n, xfs_fsmap queries the system for the number of extents in the filesystem
and uses that value to compute the group size."

Looks hard-coded to 131072, no?

> +	head = malloc(fsmap_sizeof(map_size));
> +	if (head == NULL) {
> +		fprintf(stderr, _("%s: malloc of %zu bytes failed.\n"),
> +			progname, fsmap_sizeof(map_size));
> +		exitcode = 1;
> +		return 0;
> +	}
> +
> +	memset(head, 0, sizeof(*head));
> +	l = head->fmh_keys;
> +	h = head->fmh_keys + 1;
> +	if (dflag) {
> +		l->fmr_device = h->fmr_device = file->fs_path.fs_datadev;
> +	} else if (lflag) {
> +		l->fmr_device = h->fmr_device = file->fs_path.fs_logdev;
> +	} else if (rflag) {
> +		l->fmr_device = h->fmr_device = file->fs_path.fs_rtdev;
> +	} else {
> +		l->fmr_device = 0;
> +		h->fmr_device = UINT_MAX;
> +	}
> +	l->fmr_physical = start;
> +	h->fmr_physical = end;
> +	h->fmr_owner = ULLONG_MAX;
> +	h->fmr_flags = UINT_MAX;
> +	h->fmr_offset = ULLONG_MAX;
> +
> +	/* Count mappings */
> +	if (!nflag) {
> +		head->fmh_count = 0;
> +		i = ioctl(file->fd, FS_IOC_GETFSMAP, head);
> +		if (i < 0) {
> +			fprintf(stderr, _("%s: xfsctl(XFS_IOC_GETFSMAP)"
> +				" iflags=0x%x [\"%s\"]: %s\n"),
> +				progname, head->fmh_iflags, file->name,
> +				strerror(errno));
> +			free(head);
> +			exitcode = 1;
> +			return 0;
> +		}
> +		if (head->fmh_entries > map_size + 2) {
> +			map_size = 11ULL * head->fmh_entries / 10;
> +			nmap_size = map_size > (1 << 24) ? (1 << 24) : map_size;
> +			nhead = realloc(head, fsmap_sizeof(nmap_size));
> +			if (nhead == NULL) {
> +				fprintf(stderr,
> +					_("%s: cannot realloc %zu bytes\n"),
> +					progname, fsmap_sizeof(nmap_size));
> +			} else {
> +				head = nhead;
> +				map_size = nmap_size;
> +			}
> +		}
> +	}
> +
> +	/*
> +	 * If this is an XFS filesystem, remember the data device.
> +	 * (We report AG number/block for data device extents on XFS).
> +	 */
> +	if (!tab_init) {
> +		fs_table_initialise(0, NULL, 0, NULL);
> +		tab_init = true;
> +	}
> +	fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
> +	xfs_data_dev = fs ? fs->fs_datadev : 0;
> +
> +	head->fmh_count = map_size;
> +	do {
> +		/* Get some extents */
> +		i = ioctl(file->fd, FS_IOC_GETFSMAP, head);
> +		if (i < 0) {
> +			fprintf(stderr, _("%s: xfsctl(XFS_IOC_GETFSMAP)"
> +				" iflags=0x%x [\"%s\"]: %s\n"),
> +				progname, head->fmh_iflags, file->name,
> +				strerror(errno));
> +			free(head);
> +			exitcode = 1;
> +			return 0;
> +		}
> +
> +		if (head->fmh_entries == 0)
> +			break;
> +
> +		if (!vflag)
> +			dump_map(&nr, head);
> +		else
> +			dump_map_verbose(&nr, head, &dumped_flags, &fsgeo);
> +
> +		p = &head->fmh_recs[head->fmh_entries - 1];
> +		if (p->fmr_flags & FMR_OF_LAST)
> +			break;
> +		fsmap_advance(head);
> +	} while (true);
> +
> +	if (dumped_flags)
> +		dump_verbose_key();
> +
> +	free(head);
> +	return 0;
> +}
> +
> +void
> +fsmap_init(void)
> +{
> +	fsmap_cmd.name = "fsmap";
> +	fsmap_cmd.cfunc = fsmap_f;
> +	fsmap_cmd.argmin = 0;
> +	fsmap_cmd.argmax = -1;
> +	fsmap_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_FOREIGN_OK;
> +	fsmap_cmd.args = _("[-d|-l|-r] [-v] [-n nx] [start] [end]");
> +	fsmap_cmd.oneline = _("print filesystem mapping for a range of blocks");
> +	fsmap_cmd.help = fsmap_help;
> +
> +	add_command(&fsmap_cmd);
> +}
> diff --git a/io/init.c b/io/init.c
> index c15a1e1..20d5f80 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -66,6 +66,7 @@ init_commands(void)
>  	file_init();
>  	flink_init();
>  	freeze_init();
> +	fsmap_init();
>  	fsync_init();
>  	getrusage_init();
>  	help_init();
> @@ -139,6 +140,7 @@ init(
>  	char		*sp;
>  	mode_t		mode = 0600;
>  	xfs_fsop_geom_t	geometry = { 0 };
> +	struct fs_path	fsp;
>  
>  	progname = basename(argv[0]);
>  	setlocale(LC_ALL, "");
> @@ -148,6 +150,7 @@ init(
>  	pagesize = getpagesize();
>  	gettimeofday(&stopwatch, NULL);
>  
> +	fs_table_initialise(0, NULL, 0, NULL);
>  	while ((c = getopt(argc, argv, "ac:C:dFfim:p:nrRstTVx")) != EOF) {
>  		switch (c) {
>  		case 'a':
> @@ -212,11 +215,12 @@ init(
>  	}
>  
>  	while (optind < argc) {
> -		if ((c = openfile(argv[optind], &geometry, flags, mode)) < 0)
> +		c = openfile(argv[optind], &geometry, flags, mode, &fsp);
> +		if (c < 0)
>  			exit(1);
>  		if (!platform_test_xfs_fd(c))
>  			flags |= IO_FOREIGN;
> -		if (addfile(argv[optind], c, &geometry, flags) < 0)
> +		if (addfile(argv[optind], c, &geometry, flags, &fsp) < 0)
>  			exit(1);
>  		optind++;
>  	}
> diff --git a/io/io.h b/io/io.h
> index 952bdb8..6a0fe65 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -17,6 +17,7 @@
>   */
>  
>  #include "xfs.h"
> +#include "path.h"
>  
>  /*
>   * Read/write patterns (default is always "forward")
> @@ -47,6 +48,7 @@ typedef struct fileio {
>  	int		flags;		/* flags describing file state */
>  	char		*name;		/* file name at time of open */
>  	xfs_fsop_geom_t	geom;		/* XFS filesystem geometry */
> +	struct fs_path	fs_path;	/* XFS path information */
>  } fileio_t;
>  
>  extern fileio_t		*filetable;	/* open file table */
> @@ -76,8 +78,10 @@ extern void *check_mapping_range(mmap_region_t *, off64_t, size_t, int);
>   */
>  
>  extern off64_t		filesize(void);
> -extern int		openfile(char *, xfs_fsop_geom_t *, int, mode_t);
> -extern int		addfile(char *, int , xfs_fsop_geom_t *, int);
> +extern int		openfile(char *, xfs_fsop_geom_t *, int, mode_t,
> +				 struct fs_path *);
> +extern int		addfile(char *, int , xfs_fsop_geom_t *, int,
> +				struct fs_path *);
>  extern void		printxattr(uint, int, int, const char *, int, int);
>  
>  extern unsigned int	recurse_all;
> @@ -174,3 +178,9 @@ extern void		readdir_init(void);
>  extern void		reflink_init(void);
>  
>  extern void		cowextsize_init(void);
> +
> +#ifdef HAVE_GETFSMAP
> +extern void		fsmap_init(void);
> +#else
> +# define fsmap_init()	do { } while (0)
> +#endif
> diff --git a/io/open.c b/io/open.c
> index 2ed55cf..b50f068 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -52,8 +52,10 @@ openfile(
>  	char		*path,
>  	xfs_fsop_geom_t	*geom,
>  	int		flags,
> -	mode_t		mode)
> +	mode_t		mode,
> +	struct fs_path	*fs_path)
>  {
> +	struct fs_path	*fsp;
>  	int		fd;
>  	int		oflags;
>  
> @@ -118,6 +120,14 @@ openfile(
>  			}
>  		}
>  	}
> +
> +	if (fs_path) {
> +		fsp = fs_table_lookup(path, FS_MOUNT_POINT);
> +		if (!fsp)
> +			memset(fs_path, 0, sizeof(*fs_path));
> +		else
> +			*fs_path = *fsp;
> +	}
>  	return fd;
>  }
>  
> @@ -126,7 +136,8 @@ addfile(
>  	char		*name,
>  	int		fd,
>  	xfs_fsop_geom_t	*geometry,
> -	int		flags)
> +	int		flags,
> +	struct fs_path	*fs_path)
>  {
>  	char		*filename;
>  
> @@ -154,6 +165,7 @@ addfile(
>  	file->flags = flags;
>  	file->name = filename;
>  	file->geom = *geometry;
> +	file->fs_path = *fs_path;
>  	return 0;
>  }
>  
> @@ -195,6 +207,7 @@ open_f(
>  	char		*sp;
>  	mode_t		mode = 0600;
>  	xfs_fsop_geom_t	geometry = { 0 };
> +	struct fs_path	fsp;
>  
>  	if (argc == 1) {
>  		if (file)
> @@ -257,14 +270,14 @@ open_f(
>  		return -1;
>  	}
>  
> -	fd = openfile(argv[optind], &geometry, flags, mode);
> +	fd = openfile(argv[optind], &geometry, flags, mode, &fsp);
>  	if (fd < 0)
>  		return 0;
>  
>  	if (!platform_test_xfs_fd(fd))
>  		flags |= IO_FOREIGN;
>  
> -	addfile(argv[optind], fd, &geometry, flags);
> +	addfile(argv[optind], fd, &geometry, flags, &fsp);
>  	return 0;
>  }
>  
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 7c0bb7f..1c5dfca 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -357,7 +357,7 @@ pwrite_f(
>  		return 0;
>  
>  	c = IO_READONLY | (dflag ? IO_DIRECT : 0);
> -	if (infile && ((fd = openfile(infile, NULL, c, 0)) < 0))
> +	if (infile && ((fd = openfile(infile, NULL, c, 0, NULL)) < 0))
>  		return 0;
>  
>  	gettimeofday(&t1, NULL);
> diff --git a/io/reflink.c b/io/reflink.c
> index fe05d1e..f584e8f 100644
> --- a/io/reflink.c
> +++ b/io/reflink.c
> @@ -154,7 +154,7 @@ dedupe_f(
>  		return 0;
>  	}
>  
> -	fd = openfile(infile, NULL, IO_READONLY, 0);
> +	fd = openfile(infile, NULL, IO_READONLY, 0, NULL);
>  	if (fd < 0)
>  		return 0;
>  
> @@ -278,7 +278,7 @@ reflink_f(
>  	}
>  
>  clone_all:
> -	fd = openfile(infile, NULL, IO_READONLY, 0);
> +	fd = openfile(infile, NULL, IO_READONLY, 0, NULL);
>  	if (fd < 0)
>  		return 0;
>  
> diff --git a/io/sendfile.c b/io/sendfile.c
> index edd31c9..063fa7f 100644
> --- a/io/sendfile.c
> +++ b/io/sendfile.c
> @@ -115,7 +115,7 @@ sendfile_f(
>  
>  	if (!infile)
>  		fd = filetable[fd].fd;
> -	else if ((fd = openfile(infile, NULL, IO_READONLY, 0)) < 0)
> +	else if ((fd = openfile(infile, NULL, IO_READONLY, 0, NULL)) < 0)
>  		return 0;
>  
>  	if (optind == argc - 2) {
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 29a036c..bd8af47 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -301,6 +301,72 @@ ioctl.  Options behave as described in the
>  .BR xfs_bmap (8)
>  manual page.
>  .TP
> +.BI "fsmap [ \-d | \-l | \-r ] [ \-v ] [ \-n " nx " ] [ " start " ] [ " end " ]
> +Prints the mapping of disk blocks used by a filesystem.
> +The map lists each extent used by files, allocation group metadata,
> +journalling logs, and static filesystem metadata, as well as any
> +regions that are unused.
> +Each line of the listings takes the following form:
> +.PP
> +.RS
> +.IR extent ": " major ":" minor " [" startblock .. endblock "]: " owner " " startoffset .. endoffset " " length
> +.PP
> +Static filesystem metadata, allocation group metadata, btrees,
> +journalling logs, and free space are marked by replacing the
> +.IR startoffset .. endoffset
> +with the appropriate marker.
> +All blocks, offsets, and lengths are specified in units of 512-byte
> +blocks, no matter what the filesystem's block size is.
> +The optional
> +.I start
> +and
> +.I end
> +arguments can be used to constrain the output to a particular range of
> +disk blocks.
> +.RE
> +.RS 1.0i
> +.PD 0
> +.TP
> +.BI \-d
> +Display only extents from the data device.
> +This option only applies for XFS filesystems.
> +.TP
> +.BI \-l
> +Display only extents from the external log device.
> +This option only applies to XFS filesystems.
> +.TP
> +.BI \-r
> +Display only extents from the realtime device.
> +This option only applies to XFS filesystems.
> +.TP
> +.BI \-n " num_extents"
> +If this option is given,
> +.B xfs_fsmap
> +obtains the extent list of the file in groups of
> +.I num_extents
> +extents.
> +In the absence of
> +.BR \-n ", " xfs_fsmap
> +queries the system for the number of extents in the filesystem and uses
> +that value to compute the group size.
> +.TP
> +.B \-v
> +Shows verbose information.
> +When this flag is specified, additional AG specific information is
> +appended to each line in the following form:
> +.IP
> +.RS 1.2i
> +.IR agno " (" startagblock .. endagblock ") " nblocks " " flags
> +.RE
> +.IP
> +A second
> +.B \-v
> +option will print out the
> +.I flags
> +legend.
> +.RE
> +.PD
> +.TP
>  .BI "extsize [ \-R | \-D ] [ " value " ]"
>  Display and/or modify the preferred extent size used when allocating
>  space for the currently open file. If the
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

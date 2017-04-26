Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56716 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967141AbdDZTur (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 15:50:47 -0400
Subject: Re: [PATCH 4/4] xfs_db: dump metadata btrees via 'btdump'
References: <149186446125.32572.5134583964816531229.stgit@birch.djwong.org>
 <149186448580.32572.11952289934147703634.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <751a55aa-a698-0464-9ac1-b962b38381d8@sandeen.net>
Date: Wed, 26 Apr 2017 14:50:45 -0500
MIME-Version: 1.0
In-Reply-To: <149186448580.32572.11952289934147703634.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/10/17 5:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new 'btdump' command that can print the contents of all
> blocks of any metadata subtree in the filesystem.  This enables
> developers and forensic analyst to view a metadata structure without
> having to navigate the btree manually.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: put the btdump_init declaration in command.h to avoid lots of silly
> little header files
> ---
>  db/Makefile  |    2 
>  db/btdump.c  |  271 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  db/command.c |    1 
>  db/command.h |    2 

man/man8/xfs_db.8 ?

>  4 files changed, 275 insertions(+), 1 deletion(-)
>  create mode 100644 db/btdump.c
> 
> 
> diff --git a/db/Makefile b/db/Makefile
> index cdc0b99..2c7679c 100644
> --- a/db/Makefile
> +++ b/db/Makefile
> @@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
>  LTCOMMAND = xfs_db
>  
>  HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
> -	btblock.h bmroot.h check.h command.h convert.h crc.h debug.h \
> +	btblock.h btdump.c bmroot.h check.h command.h convert.h crc.h debug.h \
                  ^^^^^^^^

That's ... not an HFILE :)

>  	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
>  	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
>  	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \

...

CFILES = $(HFILES:.h=.c)

Oh.  Urgh.  Yuk.  o_O  /o\

How about:

CFILES = btdump.c $(HFILES:.h=.c)

maybe?

(I have another patch to remove all the other silly little headers, so maybe
we can start going in that direction for new functions)


> diff --git a/db/btdump.c b/db/btdump.c
> new file mode 100644
> index 0000000..9b9fc2c
> --- /dev/null
> +++ b/db/btdump.c
> @@ -0,0 +1,271 @@
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
> +#include "libxfs.h"
> +#include "command.h"
> +#include "output.h"
> +#include "init.h"
> +#include "io.h"
> +#include "type.h"
> +#include "input.h"
> +
> +static void
> +btdump_help(void)
> +{
> +	dbprintf(_(
> +"\n"
> +" 'btdump' dumps the btree rooted at the current io cursor location.\n"

Note that the current type must be set to the proper btree?
(I know a guy who forgot to do that) Or could/should it be automagic?

> +" In the case of an inode, the data fork bmbt is displayed.\n"

"In the case of an inode, the data fork btree root is automatically
selected, unless the attribute btree root is selected with -a."

> +" Options:\n"
> +"   -a -- Display the extended attribute bmbt.\n"

-a -- Display an inode's extended attribute btree.

> +"   -i -- Print internal btree nodes.\n"
> +"\n"
> +));
> +
> +}
> +
> +static int
> +eval(
> +	const char	*fmt, ...)
> +{
> +	va_list		ap;
> +	char		buf[PATH_MAX];
> +	char		**v;
> +	int		c;
> +	int		ret;
> +
> +	va_start(ap, fmt);
> +	vsnprintf(buf, sizeof(buf), fmt, ap);
> +	va_end(ap);
> +
> +	v = breakline(buf, &c);
> +	ret = command(c, v);
> +	free(v);
> +	return ret;
> +}

w00t

> +
> +static bool
> +btblock_has_rightsib(
> +	struct xfs_btree_block	*block,
> +	bool			long_format)
> +{
> +	if (long_format)
> +		return block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK);
> +	return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
> +}
> +
> +static int
> +dump_btlevel(
> +	int			level,
> +	bool			long_format)
> +{
> +	xfs_daddr_t		orig_daddr = iocur_top->bb;
> +	xfs_daddr_t		last_daddr;
> +	unsigned int		nr;
> +	int			ret;
> +
> +	ret = eval("push");
> +	if (ret)
> +		return ret;
> +
> +	nr = 1;
> +	do {
> +		last_daddr = iocur_top->bb;
> +		dbprintf(_("%s level %u block %u daddr %llu\n"),
> +			 iocur_top->typ->name, level, nr, last_daddr);
> +		if (level > 0) {
> +			ret = eval("print keys");
> +			if (ret)
> +				goto err;
> +			ret = eval("print ptrs");
> +		} else {
> +			ret = eval("print recs");
> +		}
> +		if (ret)
> +			goto err;
> +		if (btblock_has_rightsib(iocur_top->data, long_format)) {
> +			ret = eval("addr rightsib");
> +			if (ret)
> +				goto err;
> +		}
> +		nr++;
> +	} while (iocur_top->bb != orig_daddr && iocur_top->bb != last_daddr);
> +
> +	ret = eval("pop");
> +	return ret;
> +err:
> +	eval("pop");
> +	return ret;
> +}
> +
> +static int
> +dump_btree(
> +	bool		dump_node_blocks,
> +	bool		long_format)
> +{
> +	xfs_daddr_t	orig_daddr = iocur_top->bb;
> +	xfs_daddr_t	last_daddr;
> +	int		level;
> +	int		ret;
> +
> +	ret = eval("push");
> +	if (ret)
> +		return ret;
> +
> +	cur_agno = XFS_FSB_TO_AGNO(mp, XFS_DADDR_TO_FSB(mp, iocur_top->bb));
> +	level = xfs_btree_get_level(iocur_top->data);
> +	do {
> +		last_daddr = iocur_top->bb;
> +		if (level > 0) {
> +			if (dump_node_blocks) {
> +				ret = dump_btlevel(level, long_format);
> +				if (ret)
> +					goto err;
> +			}
> +			ret = eval("addr ptrs[1]");
> +		} else {
> +			ret = dump_btlevel(level, long_format);
> +		}
> +		if (ret)
> +			goto err;
> +		level--;
> +	} while (level >= 0 &&
> +		 iocur_top->bb != orig_daddr &&
> +		 iocur_top->bb != last_daddr);
> +
> +	ret = eval("pop");
> +	return ret;
> +err:
> +	eval("pop");
> +	return ret;
> +}
> +
> +static int
> +dump_inode(
> +	bool			dump_node_blocks,
> +	bool			attrfork)
> +{
> +	char			*prefix;
> +	struct xfs_dinode	*dip;
> +	int			ret;
> +
> +	if (attrfork)
> +		prefix = "a.bmbt";
> +	else if (xfs_sb_version_hascrc(&mp->m_sb))
> +		prefix = "u3.bmbt";
> +	else
> +		prefix = "u.bmbt";
> +
> +	dip = iocur_top->data;
> +	if (attrfork) {
> +		if (!dip->di_anextents ||
> +		    dip->di_aformat != XFS_DINODE_FMT_BTREE)

			dbprintf(_("attr fork not in btree format\n"));

> +			return 0;
> +	} else {
> +		if (!dip->di_nextents ||
> +		    dip->di_format != XFS_DINODE_FMT_BTREE)

			dbprintf(_("data fork not in btree format\n"));

> +			return 0;
> +	}
> +
> +	ret = eval("push");
> +	if (ret)
> +		return ret;
> +
> +	if (dump_node_blocks) {
> +		ret = eval("print %s.keys", prefix);
> +		if (ret)
> +			goto err;
> +		ret = eval("print %s.ptrs", prefix);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	ret = eval("addr %s.ptrs[1]", prefix);
> +	if (ret)
> +		goto err;
> +
> +	ret = dump_btree(dump_node_blocks, true);

not a huge fan of the magic "true / false" options in callers for
dump_btree, though it's not a dealbreaker.

> +	if (ret)
> +		goto err;
> +
> +	ret = eval("pop");
> +	return ret;
> +err:
> +	eval("pop");
> +	return ret;
> +}
> +
> +static int
> +btdump_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	bool		aflag = false;
> +	bool		iflag = false;
> +	int		c;
> +
> +	if (cur_typ == NULL) {
> +		dbprintf(_("no current type\n"));
> +		return 0;
> +	}
> +	while ((c = getopt(argc, argv, "ai")) != EOF) {
> +		switch (c) {
> +		case 'a':
> +			aflag = true;
> +			break;
> +		case 'i':
> +			iflag = true;
> +			break;
> +		default:
> +			dbprintf(_("bad option for btdump command\n"));
> +			return 0;
> +		}
> +	}

		if (optind != argc) {
			dbprintf(_("bad options for btdump command\n"));
			return 0;
		}

(this catches "btdump foo")

> +	if (aflag && cur_typ->typnm != TYP_INODE) {
> +		dbprintf(_("attrfork flag doesn't apply here\n"));
> +		return 0;
> +	}
> +	switch (cur_typ->typnm) {
> +	case TYP_BNOBT:
> +	case TYP_CNTBT:
> +	case TYP_INOBT:
> +	case TYP_FINOBT:
> +	case TYP_RMAPBT:
> +	case TYP_REFCBT:
> +		return dump_btree(iflag, false);
> +	case TYP_BMAPBTA:
> +	case TYP_BMAPBTD:
> +		return dump_btree(iflag, true);
> +	case TYP_INODE:
> +		return dump_inode(iflag, aflag);
> +	default:
> +		dbprintf(_("Not a btree.\n"));

dbprintf(_("Type \"%s\" is not a btree type.\n"), cur_typ->name);

?

> +		return 0;
> +	}
> +}
> +
> +static const cmdinfo_t btdump_cmd =
> +	{ "btdump", "b", btdump_f, 0, 1, 0, "",
> +	  N_("dump btree"), btdump_help };

args (not "") here please, so that bare "xfs_db> help" gives you the
proper synopsis as do other commands:

xfs_db> help
...
blockuse [-n] [-c blockcount] -- print usage for current block(s)
bmap [-ad] [block [len]] -- show block map for current file
btdump  -- dump btree
...

and arg max is wrong, so we can't:

xfs_db> btdump -i -a
bad argument count 2 to btdump, expected between 0 and 1 arguments

but we can:

xfs_db> btdump -ia
xfs_db> 

(named structure members ala db/logformat.c would be nice, but
I guess most other db commands don't use that today...)

> +
> +void
> +btdump_init(void)
> +{
> +	add_command(&btdump_cmd);
> +}
> diff --git a/db/command.c b/db/command.c
> index 3d7cfd7..c90c85c 100644
> --- a/db/command.c
> +++ b/db/command.c
> @@ -124,6 +124,7 @@ init_commands(void)
>  	attrset_init();
>  	block_init();
>  	bmap_init();
> +	btdump_init();
>  	check_init();
>  	convert_init();
>  	crc_init();
> diff --git a/db/command.h b/db/command.h
> index 4d4807d..9b4ed2d 100644
> --- a/db/command.h
> +++ b/db/command.h
> @@ -39,3 +39,5 @@ extern void		add_command(const cmdinfo_t *ci);
>  extern int		command(int argc, char **argv);
>  extern const cmdinfo_t	*find_command(const char *cmd);
>  extern void		init_commands(void);
> +
> +extern void		btdump_init(void);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

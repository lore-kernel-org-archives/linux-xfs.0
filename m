Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45155 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756619AbdDFHyO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2017 03:54:14 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v367sB8Q031063
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 6 Apr 2017 07:54:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v367sB6i006778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 6 Apr 2017 07:54:11 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v367sBCp000643
        for <linux-xfs@vger.kernel.org>; Thu, 6 Apr 2017 07:54:11 GMT
Subject: Re: [RFC PATCH 1/1] xfsprogs/db: add a command for dumping the btree
 blocks
References: <1491443083-18600-1-git-send-email-shan.hai@oracle.com>
 <1491443083-18600-2-git-send-email-shan.hai@oracle.com>
 <20170406065923.GV4864@birch.djwong.org>
From: Shan Hai <shan.hai@oracle.com>
Message-ID: <9e81b030-b633-e27c-7939-19a497182fff@oracle.com>
Date: Thu, 6 Apr 2017 15:54:08 +0800
MIME-Version: 1.0
In-Reply-To: <20170406065923.GV4864@birch.djwong.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 2017年04月06日 14:59, Darrick J. Wong wrote:
> On Thu, Apr 06, 2017 at 09:44:43AM +0800, Shan Hai wrote:
>> Currently there is no way to dump the whole blocks of btrees in the
>> xfs_db except manually step through the btree nodes, dumping the blocks
>> of the whole btree by a command is more convenient than interactive
>> walking of the tree in some circumstances.
>>
>> This patch adds a new command to the xfs_db utility called 'treedump',
>> which can dump the specific btree or dump all btrees of the xfs, below
>> is an example usage of the command:
>>
>> sudo xfs_db -r -c "agf 0" -c "treedump -b" /dev/sda1
>>
>> The blocks of the bnobt tree are dumped to the stdout.
>>
>> Signed-off-by: Shan Hai <shan.hai@oracle.com>
>> ---
>>   db/Makefile   |   4 +-
>>   db/command.c  |   1 +
>>   db/treedump.c | 306 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   db/treedump.h |  20 ++++
>>   4 files changed, 329 insertions(+), 2 deletions(-)
>>   create mode 100644 db/treedump.c
>>   create mode 100644 db/treedump.h
>>
>> diff --git a/db/Makefile b/db/Makefile
>> index cdc0b99..03a2283 100644
>> --- a/db/Makefile
>> +++ b/db/Makefile
>> @@ -8,8 +8,8 @@ include $(TOPDIR)/include/builddefs
>>   LTCOMMAND = xfs_db
>>   
>>   HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
>> -	btblock.h bmroot.h check.h command.h convert.h crc.h debug.h \
>> -	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
>> +	btblock.h bmroot.h treedump.h check.h command.h convert.h crc.h \
>> +	debug.h dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
>>   	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
>>   	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
>>   	 sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h
>> diff --git a/db/command.c b/db/command.c
>> index 3d7cfd7..060ebed 100644
>> --- a/db/command.c
>> +++ b/db/command.c
>> @@ -143,6 +143,7 @@ init_commands(void)
>>   	print_init();
>>   	quit_init();
>>   	sb_init();
>> +	treedump_init();
>>   	type_init();
>>   	write_init();
>>   	dquot_init();
>> diff --git a/db/treedump.c b/db/treedump.c
>> new file mode 100644
>> index 0000000..8d5a33e
>> --- /dev/null
>> +++ b/db/treedump.c
>> @@ -0,0 +1,306 @@
>> +/*
>> + * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>> + * Copyright (c) 2017 Oracle.
>> + * All Rights Reserved.
>> + *
>> + * Author: Shan Hai <shan.hai@oracle.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it would be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write the Free Software Foundation,
>> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> + */
>> +
>> +#include "libxfs.h"
>> +#include <math.h>
>> +#include <sys/time.h>
>> +#include "command.h"
>> +#include "io.h"
>> +#include "type.h"
>> +#include "fprint.h"
>> +#include "faddr.h"
>> +#include "field.h"
>> +#include "sb.h"
>> +#include "input.h"
>> +#include "output.h"
>> +#include "init.h"
>> +#include "malloc.h"
>> +
>> +#define TYP_MASK ( \
>> +	TYP_AGF | TYP_AGFL |  TYP_AGI | TYP_ATTR \
>> +	| TYP_BMAPBTA | TYP_BMAPBTD | TYP_BNOBT | TYP_CNTBT \
>> +	| TYP_RMAPBT | TYP_REFCBT | TYP_DATA | TYP_DIR2 \
>> +	| TYP_DQBLK | TYP_INOBT | TYP_INODATA | TYP_INODE \
>> +	| TYP_LOG | TYP_RTBITMAP | TYP_RTSUMMARY | TYP_SB \
>> +	| TYP_SYMLINK | TYP_TEXT | TYP_FINOBT | TYP_NONE)
>> +
>> +static struct btree_types {
>> +	xfs_btnum_t	btnum;
>> +	uint32_t	magic;
>> +	uint32_t	crc_magic;
>> +} const type_to_btree_table[TYP_NONE] = {
>> +	[0 ... TYP_NONE - 1]	= { XFS_BTNUM_MAX,  -1, -1 },
>> +
>> +	[TYP_BNOBT]		= { XFS_BTNUM_BNO,
>> +				    XFS_ABTB_MAGIC, XFS_ABTB_CRC_MAGIC },
>> +	[TYP_CNTBT]		= { XFS_BTNUM_CNT,
>> +				    XFS_ABTC_MAGIC, XFS_ABTC_CRC_MAGIC },
>> +	[TYP_RMAPBT]		= { XFS_BTNUM_RMAP,
>> +				    XFS_RMAP_CRC_MAGIC, XFS_RMAP_CRC_MAGIC },
>> +	[TYP_REFCBT]		= { XFS_BTNUM_REFC,
>> +				    XFS_REFC_CRC_MAGIC, XFS_REFC_CRC_MAGIC },
> Uh.... what if I want to dump one of the other btrees?  There's at least
> four more types. ;)
>
> TBH I was wondering why not let the user navigate to the root node of
> whichever tree they wish to dump, and then the command simply has to
> travel down the left side of the tree to level 0 and then dump each leaf
> and use rightsib to move on to the next leaf?

Agreed.

If we choose the root of the tree first and then dump the tree the above 
table definition is
not necessary.

Dump the tree by following the rightsib pointer can eliminate the 
recursion in the code.

I am going to do that in the v2 patch, thanks for the suggestions.

Regards
Shan Hai
> i.e.
> xfs_db> agi 3
> xfs_db> addr free_root
> xfs_db> treedump
> 0: [...]
> 1: [...]
> xfs_db>
>
> --D
>
>> +};
>> +
>> +static typnm_t	btype_map[TYP_NONE];
>> +
>> +#define TYP_MAP_SIZE (sizeof (btype_map) / sizeof (typnm_t))
>> +
>> +typedef void	(*scan_sbtree_f_t)(struct xfs_btree_block *block,
>> +				   int level, xfs_agf_t *agf,
>> +				   xfs_agblock_t bno, int isroot,
>> +				   typnm_t btype);
>> +static int	treedump_f(int argc, char **argv);
>> +static void	scan_ag(xfs_agnumber_t agno);
>> +static void	scan_sbtree(xfs_agf_t *agf, xfs_agblock_t root,
>> +			    int nlevels, int isroot,
>> +			    scan_sbtree_f_t func, typnm_t btype);
>> +static void	scanfunc_btree(struct xfs_btree_block *block, int level,
>> +			       xfs_agf_t *agf, xfs_agblock_t bno,
>> +			       int isroot, typnm_t btype);
>> +/*
>> + * [-b]: bnobt, [-c]: cntbt, [-f]: refcntbt, [-r]: rmapbt
>> + */
>> +static const cmdinfo_t	treedump_cmd =
>> +	{ "treedump", NULL, treedump_f, 0, 4, 0,
>> +	 N_("[-b] [-c] [-f] [-r]"),
>> +	 N_("dump the metadata of the btrees"), NULL };
>> +
>> +static void set_btree_type(
>> +	typnm_t	type)
>> +{
>> +	btype_map[type] = type;
>> +}
>> +
>> +/* ARGSUSED */
>> +static int
>> +treedump_f(
>> +	int	argc,
>> +	char	**argv)
>> +{	
>> +	int c;
>> +
>> +	if (cur_agno == NULLAGNUMBER)
>> +                cur_agno = 0;
>> +
>> +	/* Dump the BNOBT if none is specified */
>> +	set_btree_type(TYP_BNOBT);
>> +
>> +	while ((c = getopt(argc, argv, "bcfr")) != EOF) {
>> +                switch (c) {
>> +                case 'b':
>> +                        set_btree_type(TYP_BNOBT);
>> +                        break;
>> +                case 'c':
>> +                        set_btree_type(TYP_CNTBT);
>> +                        break;
>> +		case 'f':
>> +			set_btree_type(TYP_REFCBT);
>> +			break;
>> +		case 'r':
>> +			set_btree_type(TYP_RMAPBT);
>> +			break;
>> +		default:
>> +			set_btree_type(TYP_BNOBT);
>> +			break;
>> +		}
>> +	}
>> +
>> +	scan_ag(cur_agno);
>> +
>> +	return 0;
>> +}
>> +
>> +void
>> +treedump_init(void)
>> +{
>> +	add_command(&treedump_cmd);
>> +}
>> +
>> +static void
>> +scan_ag(
>> +	xfs_agnumber_t	agno)
>> +{
>> +	xfs_agf_t	*agf;
>> +	xfs_sb_t	tsb;
>> +	xfs_sb_t	*sb = &tsb;
>> +	typnm_t		btype;
>> +	xfs_btnum_t	btree;
>> +	int i, c;
>> +	char **argv;
>> +
>> +	push_cur();	/* 1 pushed */
>> +	set_cur(&typtab[TYP_SB],
>> +		XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
>> +		XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
>> +
>> +	if (!iocur_top->data) {
>> +		dbprintf(_("can't read superblock for ag %u\n"), agno);
>> +		goto pop1_out;
>> +	}
>> +
>> +	libxfs_sb_from_disk(sb, iocur_top->data);
>> +
>> +	if (sb->sb_magicnum != XFS_SB_MAGIC) {
>> +		dbprintf(_("bad sb magic # %#x in ag %u\n"),
>> +			sb->sb_magicnum, agno);
>> +	}
>> +
>> +	if (!xfs_sb_good_version(sb)) {
>> +		dbprintf(_("bad sb version # %#x in ag %u\n"),
>> +			sb->sb_versionnum, agno);
>> +	}
>> +
>> +	if (agno == 0 && sb->sb_inprogress != 0) {
>> +		dbprintf(_("mkfs not completed successfully\n"));
>> +	}
>> +
>> +	push_cur();     /* 2 pushed */
>> +        set_cur(&typtab[TYP_AGF],
>> +                XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
>> +                XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
>> +
>> +	if ((agf = iocur_top->data) == NULL) {
>> +                dbprintf(_("can't read agf block for ag %u\n"), agno);
>> +                goto pop2_out;
>> +        }
>> +        if (be32_to_cpu(agf->agf_magicnum) != XFS_AGF_MAGIC) {
>> +		dbprintf(_("bad agf magic # %#x in ag %u\n"),
>> +		be32_to_cpu(agf->agf_magicnum), agno);
>> +        }
>> +        if (!XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum))) {
>> +		dbprintf(_("bad agf version # %#x in ag %u\n"),
>> +			be32_to_cpu(agf->agf_versionnum), agno);
>> +        }
>> +
>> +	dbprintf(_("\nAGF %d\n\n"), agno);
>> +	argv = breakline("print", &c);
>> +	command(c, argv);
>> +
>> +	for (i = 0; i < TYP_MAP_SIZE; i++) {
>> +		btype = btype_map[i];
>> +		if (btype & TYP_MASK) {
>> +			btree = type_to_btree_table[btype].btnum;
>> +			scan_sbtree(agf, be32_to_cpu(agf->agf_roots[btree]),
>> +					be32_to_cpu(agf->agf_levels[btree]),
>> +					1, scanfunc_btree, btype);
>> +		}
>> +	}
>> +
>> +pop2_out:
>> +	pop_cur();
>> +pop1_out:
>> +	pop_cur();
>> +}
>> +
>> +
>> +static void
>> +scan_sbtree(
>> +	xfs_agf_t	*agf,
>> +	xfs_agblock_t	root,
>> +	int		nlevels,
>> +	int		isroot,
>> +	scan_sbtree_f_t	func,
>> +	typnm_t		btype)
>> +{
>> +	xfs_agnumber_t	seqno = be32_to_cpu(agf->agf_seqno);
>> +	push_cur();
>> +
>> +	set_cur(&typtab[btype],
>> +		XFS_AGB_TO_DADDR(mp, seqno, root), blkbb, DB_RING_IGN, NULL);
>> +	if (iocur_top->data == NULL) {
>> +		dbprintf(_("can't read btree block %u/%u\n"), seqno, root);
>> +		pop_cur();
>> +		return;
>> +	}
>> +	(*func)(iocur_top->data, nlevels - 1, agf, root, isroot, btype);
>> +	pop_cur();
>> +}
>> +
>> +static int check_magic(
>> +	struct xfs_btree_block	*block,
>> +	xfs_agnumber_t		seqno,
>> +	xfs_agblock_t		bno,
>> +	typnm_t			btype)
>> +{
>> +	uint32_t magic = type_to_btree_table[btype].magic;
>> +	uint32_t crc_magic = type_to_btree_table[btype].crc_magic;
>> +	char *btree_name = typtab[btype].name;
>> +	
>> +	if (be32_to_cpu(block->bb_magic) != magic &&
>> +		be32_to_cpu(block->bb_magic) != crc_magic) {
>> +		dbprintf(_("bad magic # %#x in %s block %u/%u\n"),
>> +			be32_to_cpu(block->bb_magic), btree_name, seqno, bno);
>> +		return -1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void
>> +scanfunc_btree(
>> +	struct xfs_btree_block	*block,
>> +	int			level,
>> +	xfs_agf_t		*agf,
>> +	xfs_agblock_t		bno,
>> +	int			isroot,
>> +	typnm_t			btype)
>> +{
>> +	int			i, c;
>> +	char			**argv;
>> +	xfs_alloc_ptr_t         *pp;
>> +	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
>> +
>> +	if (check_magic(block, seqno, bno, btype))
>> +		return;
>> +
>> +	dbprintf(_("\ncurrent blkno %d\n\n"), bno);
>> +	if (level == 0) {
>> +		if (be16_to_cpu(block->bb_numrecs) > mp->m_alloc_mxr[0] ||
>> +		    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_alloc_mnr[0])) {
>> +			dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in "
>> +				 "btbno block %u/%u\n"),
>> +				be16_to_cpu(block->bb_numrecs), mp->m_alloc_mnr[0],
>> +				mp->m_alloc_mxr[0], seqno, bno);
>> +			return;
>> +		}
>> +
>> +		argv = breakline("print", &c);
>> +		command(c, argv);
>> +
>> +		return;
>> +	} else {
>> +		argv = breakline("print", &c);
>> +		command(c, argv);
>> +	}
>> +
>> +	if (be16_to_cpu(block->bb_numrecs) > mp->m_alloc_mxr[1] ||
>> +	    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_alloc_mnr[1])) {
>> +		dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in btbno block "
>> +			 "%u/%u\n"),
>> +			be16_to_cpu(block->bb_numrecs), mp->m_alloc_mnr[1],
>> +			mp->m_alloc_mxr[1], seqno, bno);
>> +		return;
>> +	}
>> +
>> +	pp = XFS_ALLOC_PTR_ADDR(mp, block, 1, mp->m_alloc_mxr[1]);
>> +	for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
>> +		scan_sbtree(agf, be32_to_cpu(pp[i]), level, 0, scanfunc_btree, btype);
>> +}
>> diff --git a/db/treedump.h b/db/treedump.h
>> new file mode 100644
>> index 0000000..c9dbffc
>> --- /dev/null
>> +++ b/db/treedump.h
>> @@ -0,0 +1,20 @@
>> +/*
>> + * Copyright (c) 2017 Oracle.  All Rights Reserved.
>> + *
>> + * Author: Shan Hai <shan.hai@oracle.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it would be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write the Free Software Foundation,
>> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> + */
>> +
>> +extern void	treedump_init(void);
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


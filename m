Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21414 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbdGWQlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jul 2017 12:41:03 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6NGf2cl031444
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 16:41:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6NGf1hf009068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 16:41:02 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v6NGf1MD025611
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 16:41:01 GMT
Subject: Re: [PATCH 04/22] xfs: generic functions to scrub metadata and btrees
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061193407.14732.9644386359653380682.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c71d6e0a-fb27-0b21-4b7f-93979eee06fb@oracle.com>
Date: Sun, 23 Jul 2017 09:40:59 -0700
MIME-Version: 1.0
In-Reply-To: <150061193407.14732.9644386359653380682.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks good.  You can add
Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 7/20/2017 9:38 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Create a function that walks a btree, checking the integrity of each
> btree block (headers, keys, records) and calling back to the caller
> to perform further checks on the records.  Add some helper functions
> so that we report detailed scrub errors in a uniform manner in dmesg.
> These are helper functions for subsequent patches.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/Makefile       |    1
>  fs/xfs/scrub/btree.c  |  658 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/btree.h  |   95 +++++++
>  fs/xfs/scrub/common.c |  169 +++++++++++++
>  fs/xfs/scrub/common.h |   30 ++
>  5 files changed, 953 insertions(+)
>  create mode 100644 fs/xfs/scrub/btree.c
>  create mode 100644 fs/xfs/scrub/btree.h
>
>
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index c4fdaa2..4e04da9 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -140,6 +140,7 @@ xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
>  # online scrub/repair
>  ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
>  xfs-y				+= $(addprefix scrub/, \
> +				   btree.o \
>  				   common.o \
>  				   )
>  endif
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> new file mode 100644
> index 0000000..452e70a
> --- /dev/null
> +++ b/fs/xfs/scrub/btree.c
> @@ -0,0 +1,658 @@
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
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_btree.h"
> +#include "xfs_bit.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans.h"
> +#include "xfs_trace.h"
> +#include "xfs_sb.h"
> +#include "xfs_inode.h"
> +#include "xfs_alloc.h"
> +#include "scrub/common.h"
> +#include "scrub/btree.h"
> +
> +/* btree scrubbing */
> +
> +const char * const btree_types[] = {
> +	[XFS_BTNUM_BNO]		= "bnobt",
> +	[XFS_BTNUM_CNT]		= "cntbt",
> +	[XFS_BTNUM_RMAP]	= "rmapbt",
> +	[XFS_BTNUM_BMAP]	= "bmapbt",
> +	[XFS_BTNUM_INO]		= "inobt",
> +	[XFS_BTNUM_FINO]	= "finobt",
> +	[XFS_BTNUM_REFC]	= "refcountbt",
> +};
> +
> +/* Format the trace parameters for the tree cursor. */
> +static inline void
> +xfs_scrub_btree_format(
> +	struct xfs_btree_cur		*cur,
> +	int				level,
> +	char				*bt_type,
> +	size_t				type_len,
> +	char				*bt_ptr,
> +	size_t				ptr_len,
> +	xfs_fsblock_t			*fsbno)
> +{
> +	char				*type = NULL;
> +	struct xfs_btree_block		*block;
> +	struct xfs_buf			*bp;
> +
> +	switch (cur->bc_btnum) {
> +	case XFS_BTNUM_BMAP:
> +		switch (cur->bc_private.b.whichfork) {
> +		case XFS_DATA_FORK:
> +			type = "data";
> +			break;
> +		case XFS_ATTR_FORK:
> +			type = "attr";
> +			break;
> +		case XFS_COW_FORK:
> +			type = "CoW";
> +			break;
> +		}
> +		snprintf(bt_type, type_len, "inode %llu %s fork",
> +				(unsigned long long)cur->bc_private.b.ip->i_ino,
> +				type);
> +		break;
> +	default:
> +		strncpy(bt_type, btree_types[cur->bc_btnum], type_len);
> +		break;
> +	}
> +
> +	if (level < cur->bc_nlevels && cur->bc_ptrs[level] >= 1) {
> +		block = xfs_btree_get_block(cur, level, &bp);
> +		snprintf(bt_ptr, ptr_len, " %s %d/%d",
> +				level == 0 ? "rec" : "ptr",
> +				cur->bc_ptrs[level],
> +				be16_to_cpu(block->bb_numrecs));
> +	} else
> +		bt_ptr[0] = 0;
> +
> +	if (level < cur->bc_nlevels && cur->bc_bufs[level])
> +		*fsbno = XFS_DADDR_TO_FSB(cur->bc_mp,
> +				cur->bc_bufs[level]->b_bn);
> +	else if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> +		*fsbno = XFS_INO_TO_FSB(cur->bc_mp,
> +				cur->bc_private.b.ip->i_ino);
> +	else
> +		*fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno, 0);
> +}
> +
> +/* Check for btree corruption. */
> +bool
> +xfs_scrub_btree_ok(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_btree_cur		*cur,
> +	int				level,
> +	bool				fs_ok,
> +	const char			*check,
> +	const char			*func,
> +	int				line)
> +{
> +	char				bt_ptr[24];
> +	char				bt_type[48];
> +	xfs_fsblock_t			fsbno;
> +
> +	if (fs_ok)
> +		return fs_ok;
> +
> +	sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
> +	xfs_scrub_btree_format(cur, level, bt_type, 48, bt_ptr, 24, &fsbno);
> +
> +	trace_xfs_scrub_btree_error(cur->bc_mp, bt_type, bt_ptr,
> +			XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
> +			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
> +			check, func, line);
> +	return fs_ok;
> +}
> +
> +/* Check for btree operation errors . */
> +bool
> +xfs_scrub_btree_op_ok(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_btree_cur		*cur,
> +	int				level,
> +	int				*error,
> +	const char			*func,
> +	int				line)
> +{
> +	char				bt_ptr[24];
> +	char				bt_type[48];
> +	xfs_fsblock_t			fsbno;
> +
> +	if (*error == 0)
> +		return true;
> +
> +	xfs_scrub_btree_format(cur, level, bt_type, 48, bt_ptr, 24, &fsbno);
> +
> +	return xfs_scrub_op_ok(sc,
> +			XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
> +			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
> +			bt_type, error, func, line);
> +}
> +
> +/*
> + * Make sure this record is in order and doesn't stray outside of the parent
> + * keys.
> + */
> +STATIC int
> +xfs_scrub_btree_rec(
> +	struct xfs_scrub_btree	*bs)
> +{
> +	struct xfs_btree_cur	*cur = bs->cur;
> +	union xfs_btree_rec	*rec;
> +	union xfs_btree_key	key;
> +	union xfs_btree_key	hkey;
> +	union xfs_btree_key	*keyp;
> +	struct xfs_btree_block	*block;
> +	struct xfs_btree_block	*keyblock;
> +	struct xfs_buf		*bp;
> +
> +	block = xfs_btree_get_block(cur, 0, &bp);
> +	rec = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
> +
> +	if (bp)
> +		trace_xfs_scrub_btree_rec(cur->bc_mp,
> +				XFS_FSB_TO_AGNO(cur->bc_mp,
> +					XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn)),
> +				XFS_FSB_TO_AGBNO(cur->bc_mp,
> +					XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn)),
> +				cur->bc_btnum, 0, cur->bc_nlevels,
> +				cur->bc_ptrs[0]);
> +	else if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> +		trace_xfs_scrub_btree_rec(cur->bc_mp,
> +				XFS_INO_TO_AGNO(cur->bc_mp,
> +					cur->bc_private.b.ip->i_ino),
> +				XFS_INO_TO_AGBNO(cur->bc_mp,
> +					cur->bc_private.b.ip->i_ino),
> +				cur->bc_btnum, 0, cur->bc_nlevels,
> +				cur->bc_ptrs[0]);
> +	else
> +		trace_xfs_scrub_btree_rec(cur->bc_mp,
> +				NULLAGNUMBER, NULLAGBLOCK,
> +				cur->bc_btnum, 0, cur->bc_nlevels,
> +				cur->bc_ptrs[0]);
> +
> +	/* If this isn't the first record, are they in order? */
> +	XFS_SCRUB_BTREC_CHECK(bs, bs->firstrec ||
> +			cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec));
> +	bs->firstrec = false;
> +	memcpy(&bs->lastrec, rec, cur->bc_ops->rec_len);
> +
> +	if (cur->bc_nlevels == 1)
> +		return 0;
> +
> +	/* Is this at least as large as the parent low key? */
> +	cur->bc_ops->init_key_from_rec(&key, rec);
> +	keyblock = xfs_btree_get_block(cur, 1, &bp);
> +	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[1], keyblock);
> +	XFS_SCRUB_BTKEY_CHECK(bs, 1,
> +			cur->bc_ops->diff_two_keys(cur, &key, keyp) >= 0);
> +
> +	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
> +		return 0;
> +
> +	/* Is this no larger than the parent high key? */
> +	cur->bc_ops->init_high_key_from_rec(&hkey, rec);
> +	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[1], keyblock);
> +	XFS_SCRUB_BTKEY_CHECK(bs, 1,
> +			cur->bc_ops->diff_two_keys(cur, keyp, &hkey) >= 0);
> +
> +	return 0;
> +}
> +
> +/*
> + * Make sure this key is in order and doesn't stray outside of the parent
> + * keys.
> + */
> +STATIC int
> +xfs_scrub_btree_key(
> +	struct xfs_scrub_btree	*bs,
> +	int			level)
> +{
> +	struct xfs_btree_cur	*cur = bs->cur;
> +	union xfs_btree_key	*key;
> +	union xfs_btree_key	*keyp;
> +	struct xfs_btree_block	*block;
> +	struct xfs_btree_block	*keyblock;
> +	struct xfs_buf		*bp;
> +
> +	block = xfs_btree_get_block(cur, level, &bp);
> +	key = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
> +
> +	if (bp)
> +		trace_xfs_scrub_btree_key(cur->bc_mp,
> +				XFS_FSB_TO_AGNO(cur->bc_mp,
> +					XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn)),
> +				XFS_FSB_TO_AGBNO(cur->bc_mp,
> +					XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn)),
> +				cur->bc_btnum, level, cur->bc_nlevels,
> +				cur->bc_ptrs[level]);
> +	else if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> +		trace_xfs_scrub_btree_key(cur->bc_mp,
> +				XFS_INO_TO_AGNO(cur->bc_mp,
> +					cur->bc_private.b.ip->i_ino),
> +				XFS_INO_TO_AGBNO(cur->bc_mp,
> +					cur->bc_private.b.ip->i_ino),
> +				cur->bc_btnum, level, cur->bc_nlevels,
> +				cur->bc_ptrs[level]);
> +	else
> +		trace_xfs_scrub_btree_key(cur->bc_mp,
> +				NULLAGNUMBER, NULLAGBLOCK,
> +				cur->bc_btnum, level, cur->bc_nlevels,
> +				cur->bc_ptrs[level]);
> +
> +	/* If this isn't the first key, are they in order? */
> +	XFS_SCRUB_BTKEY_CHECK(bs, level, bs->firstkey[level] ||
> +			cur->bc_ops->keys_inorder(cur, &bs->lastkey[level],
> +					key));
> +	bs->firstkey[level] = false;
> +	memcpy(&bs->lastkey[level], key, cur->bc_ops->key_len);
> +
> +	if (level + 1 >= cur->bc_nlevels)
> +		return 0;
> +
> +	/* Is this at least as large as the parent low key? */
> +	keyblock = xfs_btree_get_block(cur, level + 1, &bp);
> +	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
> +	XFS_SCRUB_BTKEY_CHECK(bs, level,
> +			cur->bc_ops->diff_two_keys(cur, key, keyp) >= 0);
> +
> +	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
> +		return 0;
> +
> +	/* Is this no larger than the parent high key? */
> +	key = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
> +	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
> +	XFS_SCRUB_BTKEY_CHECK(bs, level,
> +			cur->bc_ops->diff_two_keys(cur, keyp, key) >= 0);
> +
> +	return 0;
> +}
> +
> +/* Check a btree pointer. */
> +static int
> +xfs_scrub_btree_ptr(
> +	struct xfs_scrub_btree		*bs,
> +	int				level,
> +	union xfs_btree_ptr		*ptr)
> +{
> +	struct xfs_btree_cur		*cur = bs->cur;
> +	xfs_daddr_t			daddr;
> +	xfs_daddr_t			eofs;
> +
> +	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> +			level == cur->bc_nlevels) {
> +		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> +			XFS_SCRUB_BTKEY_GOTO(bs, level, ptr->l == 0, corrupt);
> +		} else {
> +			XFS_SCRUB_BTKEY_GOTO(bs, level, ptr->s == 0, corrupt);
> +		}
> +		return 0;
> +	}
> +
> +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> +		XFS_SCRUB_BTKEY_GOTO(bs, level,
> +				ptr->l != cpu_to_be64(NULLFSBLOCK), corrupt);
> +
> +		daddr = XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
> +	} else {
> +		XFS_SCRUB_BTKEY_GOTO(bs, level,
> +				cur->bc_private.a.agno != NULLAGNUMBER, corrupt);
> +		XFS_SCRUB_BTKEY_GOTO(bs, level,
> +				ptr->s != cpu_to_be32(NULLAGBLOCK), corrupt);
> +
> +		daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
> +				be32_to_cpu(ptr->s));
> +	}
> +	eofs = XFS_FSB_TO_BB(cur->bc_mp, cur->bc_mp->m_sb.sb_dblocks);
> +	XFS_SCRUB_BTKEY_GOTO(bs, level, daddr != 0, corrupt);
> +	XFS_SCRUB_BTKEY_GOTO(bs, level, daddr < eofs, corrupt);
> +
> +	return 0;
> +
> +corrupt:
> +	return -EFSCORRUPTED;
> +}
> +
> +/* Check the siblings of a large format btree block. */
> +STATIC int
> +xfs_scrub_btree_lblock_check_siblings(
> +	struct xfs_scrub_btree		*bs,
> +	struct xfs_btree_block		*block)
> +{
> +	struct xfs_btree_block		*pblock;
> +	struct xfs_buf			*pbp;
> +	struct xfs_btree_cur		*ncur = NULL;
> +	union xfs_btree_ptr		*pp;
> +	xfs_fsblock_t			leftsib;
> +	xfs_fsblock_t			rightsib;
> +	xfs_fsblock_t			fsbno;
> +	int				level;
> +	int				success;
> +	int				error = 0;
> +
> +	leftsib = be64_to_cpu(block->bb_u.l.bb_leftsib);
> +	rightsib = be64_to_cpu(block->bb_u.l.bb_rightsib);
> +	level = xfs_btree_get_level(block);
> +
> +	/* Root block should never have siblings. */
> +	if (level == bs->cur->bc_nlevels - 1) {
> +		XFS_SCRUB_BTKEY_CHECK(bs, level, leftsib == NULLFSBLOCK);
> +		XFS_SCRUB_BTKEY_CHECK(bs, level, rightsib == NULLFSBLOCK);
> +		return error;
> +	}
> +
> +	/* Does the left sibling match the parent level left block? */
> +	if (leftsib != NULLFSBLOCK) {
> +		error = xfs_btree_dup_cursor(bs->cur, &ncur);
> +		if (error)
> +			return error;
> +		error = xfs_btree_decrement(ncur, level + 1, &success);
> +		XFS_SCRUB_BTKEY_OP_ERROR_GOTO(bs, level + 1, &error, out_cur);
> +		XFS_SCRUB_BTKEY_GOTO(bs, level, success, out_cur);
> +
> +		pblock = xfs_btree_get_block(ncur, level + 1, &pbp);
> +		pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
> +		if (!xfs_scrub_btree_ptr(bs, level + 1, pp)) {
> +			fsbno = be64_to_cpu(pp->l);
> +			XFS_SCRUB_BTKEY_CHECK(bs, level, fsbno == leftsib);
> +		}
> +
> +		xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> +		ncur = NULL;
> +	}
> +
> +	/* Does the right sibling match the parent level right block? */
> +	if (!error && rightsib != NULLFSBLOCK) {
> +		error = xfs_btree_dup_cursor(bs->cur, &ncur);
> +		if (error)
> +			return error;
> +		error = xfs_btree_increment(ncur, level + 1, &success);
> +		XFS_SCRUB_BTKEY_OP_ERROR_GOTO(bs, level + 1, &error, out_cur);
> +		XFS_SCRUB_BTKEY_GOTO(bs, level, success, out_cur);
> +
> +		pblock = xfs_btree_get_block(ncur, level + 1, &pbp);
> +		pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
> +		if (!xfs_scrub_btree_ptr(bs, level + 1, pp)) {
> +			fsbno = be64_to_cpu(pp->l);
> +			XFS_SCRUB_BTKEY_CHECK(bs, level, fsbno == rightsib);
> +		}
> +
> +		xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> +		ncur = NULL;
> +	}
> +
> +out_cur:
> +	if (ncur)
> +		xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> +	return error;
> +}
> +
> +/* Check the siblings of a small format btree block. */
> +STATIC int
> +xfs_scrub_btree_sblock_check_siblings(
> +	struct xfs_scrub_btree		*bs,
> +	struct xfs_btree_block		*block)
> +{
> +	struct xfs_btree_block		*pblock;
> +	struct xfs_buf			*pbp;
> +	struct xfs_btree_cur		*ncur = NULL;
> +	union xfs_btree_ptr		*pp;
> +	xfs_agblock_t			leftsib;
> +	xfs_agblock_t			rightsib;
> +	xfs_agblock_t			agbno;
> +	int				level;
> +	int				success;
> +	int				error = 0;
> +
> +	leftsib = be32_to_cpu(block->bb_u.s.bb_leftsib);
> +	rightsib = be32_to_cpu(block->bb_u.s.bb_rightsib);
> +	level = xfs_btree_get_level(block);
> +
> +	/* Root block should never have siblings. */
> +	if (level == bs->cur->bc_nlevels - 1) {
> +		XFS_SCRUB_BTKEY_CHECK(bs, level, leftsib == NULLAGBLOCK);
> +		XFS_SCRUB_BTKEY_CHECK(bs, level, rightsib == NULLAGBLOCK);
> +		return error;
> +	}
> +
> +	/* Does the left sibling match the parent level left block? */
> +	if (leftsib != NULLAGBLOCK) {
> +		error = xfs_btree_dup_cursor(bs->cur, &ncur);
> +		if (error)
> +			return error;
> +		error = xfs_btree_decrement(ncur, level + 1, &success);
> +		XFS_SCRUB_BTKEY_OP_ERROR_GOTO(bs, level + 1, &error, out_cur);
> +		XFS_SCRUB_BTKEY_GOTO(bs, level, success, verify_rightsib);
> +
> +		pblock = xfs_btree_get_block(ncur, level + 1, &pbp);
> +		pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
> +		if (!xfs_scrub_btree_ptr(bs, level + 1, pp)) {
> +			agbno = be32_to_cpu(pp->s);
> +			XFS_SCRUB_BTKEY_CHECK(bs, level, agbno == leftsib);
> +		}
> +
> +		xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> +		ncur = NULL;
> +	}
> +
> +verify_rightsib:
> +	if (ncur) {
> +		xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> +		ncur = NULL;
> +	}
> +
> +	/* Does the right sibling match the parent level right block? */
> +	if (rightsib != NULLAGBLOCK) {
> +		error = xfs_btree_dup_cursor(bs->cur, &ncur);
> +		if (error)
> +			return error;
> +		error = xfs_btree_increment(ncur, level + 1, &success);
> +		XFS_SCRUB_BTKEY_OP_ERROR_GOTO(bs, level + 1, &error, out_cur);
> +		XFS_SCRUB_BTKEY_GOTO(bs, level, success, out_cur);
> +
> +		pblock = xfs_btree_get_block(ncur, level + 1, &pbp);
> +		pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
> +		if (!xfs_scrub_btree_ptr(bs, level + 1, pp)) {
> +			agbno = be32_to_cpu(pp->s);
> +			XFS_SCRUB_BTKEY_CHECK(bs, level, agbno == rightsib);
> +		}
> +
> +		xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> +		ncur = NULL;
> +	}
> +
> +out_cur:
> +	if (ncur)
> +		xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> +	return error;
> +}
> +
> +/* Grab and scrub a btree block. */
> +STATIC int
> +xfs_scrub_btree_block(
> +	struct xfs_scrub_btree		*bs,
> +	int				level,
> +	union xfs_btree_ptr		*pp,
> +	struct xfs_btree_block		**pblock,
> +	struct xfs_buf			**pbp)
> +{
> +	int				error;
> +
> +	error = xfs_btree_lookup_get_block(bs->cur, level, pp, pblock);
> +	if (error)
> +		return error;
> +
> +	xfs_btree_get_block(bs->cur, level, pbp);
> +	error = xfs_btree_check_block(bs->cur, *pblock, level, *pbp);
> +	if (error)
> +		return error;
> +
> +	return bs->check_siblings_fn(bs, *pblock);
> +}
> +
> +/*
> + * Visit all nodes and leaves of a btree.  Check that all pointers and
> + * records are in order, that the keys reflect the records, and use a callback
> + * so that the caller can verify individual records.  The callback is the same
> + * as the one for xfs_btree_query_range, so therefore this function also
> + * returns XFS_BTREE_QUERY_RANGE_ABORT, zero, or a negative error code.
> + */
> +int
> +xfs_scrub_btree(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_btree_cur		*cur,
> +	xfs_scrub_btree_rec_fn		scrub_fn,
> +	struct xfs_owner_info		*oinfo,
> +	void				*private)
> +{
> +	struct xfs_scrub_btree		bs = {0};
> +	union xfs_btree_ptr		ptr;
> +	union xfs_btree_ptr		*pp;
> +	union xfs_btree_rec		*recp;
> +	struct xfs_btree_block		*block;
> +	int				level;
> +	struct xfs_buf			*bp;
> +	int				i;
> +	int				error = 0;
> +
> +	/* Finish filling out the scrub state */
> +	bs.cur = cur;
> +	bs.scrub_rec = scrub_fn;
> +	bs.oinfo = oinfo;
> +	bs.firstrec = true;
> +	bs.private = private;
> +	bs.sc = sc;
> +	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++)
> +		bs.firstkey[i] = true;
> +	INIT_LIST_HEAD(&bs.to_check);
> +
> +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> +		bs.check_siblings_fn = xfs_scrub_btree_lblock_check_siblings;
> +	else
> +		bs.check_siblings_fn = xfs_scrub_btree_sblock_check_siblings;
> +
> +	/* Don't try to check a tree with a height we can't handle. */
> +	XFS_SCRUB_BTREC_GOTO(&bs, cur->bc_nlevels > 0, out_badcursor);
> +	XFS_SCRUB_BTREC_GOTO(&bs, cur->bc_nlevels <= XFS_BTREE_MAXLEVELS,
> +			out_badcursor);
> +
> +	/* Make sure the root isn't in the superblock. */
> +	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
> +	error = xfs_scrub_btree_ptr(&bs, cur->bc_nlevels, &ptr);
> +	XFS_SCRUB_BTKEY_OP_ERROR_GOTO(&bs, cur->bc_nlevels, &error,
> +			out_badcursor);
> +
> +	/* Load the root of the btree. */
> +	level = cur->bc_nlevels - 1;
> +	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
> +	error = xfs_scrub_btree_block(&bs, level, &ptr, &block, &bp);
> +	XFS_SCRUB_BTKEY_OP_ERROR_GOTO(&bs, level, &error, out);
> +
> +	cur->bc_ptrs[level] = 1;
> +
> +	while (level < cur->bc_nlevels) {
> +		block = xfs_btree_get_block(cur, level, &bp);
> +
> +		if (level == 0) {
> +			/* End of leaf, pop back towards the root. */
> +			if (cur->bc_ptrs[level] >
> +			    be16_to_cpu(block->bb_numrecs)) {
> +				if (level < cur->bc_nlevels - 1)
> +					cur->bc_ptrs[level + 1]++;
> +				level++;
> +				continue;
> +			}
> +
> +			/* Records in order for scrub? */
> +			error = xfs_scrub_btree_rec(&bs);
> +			if (error)
> +				goto out;
> +			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
> +			error = bs.scrub_rec(&bs, recp);
> +			if (error < 0 ||
> +			    error == XFS_BTREE_QUERY_RANGE_ABORT)
> +				break;
> +			if (xfs_scrub_should_terminate(&error))
> +				break;
> +
> +			cur->bc_ptrs[level]++;
> +			continue;
> +		}
> +
> +		/* End of node, pop back towards the root. */
> +		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
> +			if (level < cur->bc_nlevels - 1)
> +				cur->bc_ptrs[level + 1]++;
> +			level++;
> +			continue;
> +		}
> +
> +		/* Keys in order for scrub? */
> +		error = xfs_scrub_btree_key(&bs, level);
> +		if (error)
> +			goto out;
> +
> +		/* Drill another level deeper. */
> +		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
> +		error = xfs_scrub_btree_ptr(&bs, level, pp);
> +		if (error) {
> +			error = 0;
> +			cur->bc_ptrs[level]++;
> +			continue;
> +		}
> +		level--;
> +		error = xfs_scrub_btree_block(&bs, level, pp, &block, &bp);
> +		XFS_SCRUB_BTKEY_OP_ERROR_GOTO(&bs, level, &error, out);
> +
> +		cur->bc_ptrs[level] = 1;
> +	}
> +
> +out:
> +	/*
> +	 * If we don't end this function with the cursor pointing at a record
> +	 * block, a subsequent non-error cursor deletion will not release
> +	 * node-level buffers, causing a buffer leak.  This is quite possible
> +	 * with a zero-results scrubbing run, so release the buffers if we
> +	 * aren't pointing at a record.
> +	 */
> +	if (cur->bc_bufs[0] == NULL) {
> +		for (i = 0; i < cur->bc_nlevels; i++) {
> +			if (cur->bc_bufs[i]) {
> +				xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);
> +				cur->bc_bufs[i] = NULL;
> +				cur->bc_ptrs[i] = 0;
> +				cur->bc_ra[i] = 0;
> +			}
> +		}
> +	}
> +
> +out_badcursor:
> +	return error;
> +}
> diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
> new file mode 100644
> index 0000000..75e89b1
> --- /dev/null
> +++ b/fs/xfs/scrub/btree.h
> @@ -0,0 +1,95 @@
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
> +#ifndef __XFS_REPAIR_BTREE_H__
> +#define __XFS_REPAIR_BTREE_H__
> +
> +/* btree scrub */
> +
> +extern const char * const btree_types[];
> +
> +/* Check for btree corruption. */
> +bool xfs_scrub_btree_ok(struct xfs_scrub_context *sc,
> +			struct xfs_btree_cur *cur, int level, bool fs_ok,
> +			const char *check, const char *func, int line);
> +
> +/* Check for btree operation errors. */
> +bool xfs_scrub_btree_op_ok(struct xfs_scrub_context *sc,
> +			   struct xfs_btree_cur *cur, int level, int *error,
> +			   const char *func, int line);
> +
> +#define XFS_SCRUB_BTREC_CHECK(bs, fs_ok) \
> +	xfs_scrub_btree_ok((bs)->sc, (bs)->cur, 0, (fs_ok), #fs_ok, \
> +			__func__, __LINE__)
> +#define XFS_SCRUB_BTREC_GOTO(bs, fs_ok, label) \
> +	do { \
> +		if (!xfs_scrub_btree_ok((bs)->sc, (bs)->cur, 0, (fs_ok), \
> +				#fs_ok, __func__, __LINE__)) \
> +			goto label; \
> +	} while (0)
> +#define XFS_SCRUB_BTREC_OP_ERROR_GOTO(bs, error, label) \
> +	do { \
> +		if (!xfs_scrub_btree_op_ok((bs)->sc, (bs)->cur, 0, \
> +				(error), __func__, __LINE__)) \
> +			goto label; \
> +	} while (0)
> +#define XFS_SCRUB_BTKEY_CHECK(bs, level, fs_ok) \
> +	xfs_scrub_btree_ok((bs)->sc, (bs)->cur, (level), (fs_ok), #fs_ok, \
> +			__func__, __LINE__)
> +#define XFS_SCRUB_BTKEY_GOTO(bs, level, fs_ok, label) \
> +	do { \
> +		if (!xfs_scrub_btree_ok((bs)->sc, (bs)->cur, (level), (fs_ok), \
> +				#fs_ok, __func__, __LINE__)) \
> +			goto label; \
> +	} while (0)
> +#define XFS_SCRUB_BTKEY_OP_ERROR_GOTO(bs, level, error, label) \
> +	do { \
> +		if (!xfs_scrub_btree_op_ok((bs)->sc, (bs)->cur, (level), \
> +				(error), __func__, __LINE__)) \
> +			goto label; \
> +	} while (0)
> +
> +struct xfs_scrub_btree;
> +typedef int (*xfs_scrub_btree_rec_fn)(
> +	struct xfs_scrub_btree	*bs,
> +	union xfs_btree_rec	*rec);
> +
> +struct xfs_scrub_btree {
> +	/* caller-provided scrub state */
> +	struct xfs_scrub_context	*sc;
> +	struct xfs_btree_cur		*cur;
> +	xfs_scrub_btree_rec_fn		scrub_rec;
> +	struct xfs_owner_info		*oinfo;
> +	void				*private;
> +
> +	/* internal scrub state */
> +	union xfs_btree_rec		lastrec;
> +	bool				firstrec;
> +	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
> +	bool				firstkey[XFS_BTREE_MAXLEVELS];
> +	struct list_head		to_check;
> +	int				(*check_siblings_fn)(
> +						struct xfs_scrub_btree *,
> +						struct xfs_btree_block *);
> +};
> +int xfs_scrub_btree(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
> +		    xfs_scrub_btree_rec_fn scrub_fn,
> +		    struct xfs_owner_info *oinfo, void *private);
> +
> +#endif /* __XFS_REPAIR_BTREE_H__ */
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 6931793..331aa14 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -43,6 +43,7 @@
>  #include "xfs_rmap_btree.h"
>  #include "scrub/xfs_scrub.h"
>  #include "scrub/common.h"
> +#include "scrub/btree.h"
>
>  /*
>   * Online Scrub and Repair
> @@ -367,6 +368,172 @@ xfs_scrub_incomplete(
>  	return fs_ok;
>  }
>
> +/* AG scrubbing */
> +
> +/* Grab all the headers for an AG. */
> +int
> +xfs_scrub_ag_read_headers(
> +	struct xfs_scrub_context	*sc,
> +	xfs_agnumber_t			agno,
> +	struct xfs_buf			**agi,
> +	struct xfs_buf			**agf,
> +	struct xfs_buf			**agfl)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	int				error;
> +
> +	error = xfs_ialloc_read_agi(mp, sc->tp, agno, agi);
> +	if (error)
> +		goto out;
> +
> +	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, agf);
> +	if (error)
> +		goto out;
> +	if (!*agf) {
> +		error = -ENOMEM;
> +		goto out;
> +	}
> +
> +	error = xfs_alloc_read_agfl(mp, sc->tp, agno, agfl);
> +	if (error)
> +		goto out;
> +
> +out:
> +	return error;
> +}
> +
> +/* Release all the AG btree cursors. */
> +STATIC void
> +xfs_scrub_ag_btcur_free(
> +	struct xfs_scrub_ag		*sa)
> +{
> +	if (sa->refc_cur)
> +		xfs_btree_del_cursor(sa->refc_cur, XFS_BTREE_ERROR);
> +	if (sa->rmap_cur)
> +		xfs_btree_del_cursor(sa->rmap_cur, XFS_BTREE_ERROR);
> +	if (sa->fino_cur)
> +		xfs_btree_del_cursor(sa->fino_cur, XFS_BTREE_ERROR);
> +	if (sa->ino_cur)
> +		xfs_btree_del_cursor(sa->ino_cur, XFS_BTREE_ERROR);
> +	if (sa->cnt_cur)
> +		xfs_btree_del_cursor(sa->cnt_cur, XFS_BTREE_ERROR);
> +	if (sa->bno_cur)
> +		xfs_btree_del_cursor(sa->bno_cur, XFS_BTREE_ERROR);
> +
> +	sa->refc_cur = NULL;
> +	sa->rmap_cur = NULL;
> +	sa->fino_cur = NULL;
> +	sa->ino_cur = NULL;
> +	sa->bno_cur = NULL;
> +	sa->cnt_cur = NULL;
> +}
> +
> +/* Initialize all the btree cursors for an AG. */
> +int
> +xfs_scrub_ag_btcur_init(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_scrub_ag		*sa)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	xfs_agnumber_t			agno = sa->agno;
> +
> +	if (sa->agf_bp) {
> +		/* Set up a bnobt cursor for cross-referencing. */
> +		sa->bno_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
> +				agno, XFS_BTNUM_BNO);
> +		if (!sa->bno_cur)
> +			goto err;
> +
> +		/* Set up a cntbt cursor for cross-referencing. */
> +		sa->cnt_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
> +				agno, XFS_BTNUM_CNT);
> +		if (!sa->cnt_cur)
> +			goto err;
> +	}
> +
> +	/* Set up a inobt cursor for cross-referencing. */
> +	if (sa->agi_bp) {
> +		sa->ino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
> +					agno, XFS_BTNUM_INO);
> +		if (!sa->ino_cur)
> +			goto err;
> +	}
> +
> +	/* Set up a finobt cursor for cross-referencing. */
> +	if (sa->agi_bp && xfs_sb_version_hasfinobt(&mp->m_sb)) {
> +		sa->fino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
> +				agno, XFS_BTNUM_FINO);
> +		if (!sa->fino_cur)
> +			goto err;
> +	}
> +
> +	/* Set up a rmapbt cursor for cross-referencing. */
> +	if (sa->agf_bp && xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> +		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
> +				agno);
> +		if (!sa->rmap_cur)
> +			goto err;
> +	}
> +
> +	/* Set up a refcountbt cursor for cross-referencing. */
> +	if (sa->agf_bp && xfs_sb_version_hasreflink(&mp->m_sb)) {
> +		sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
> +				sa->agf_bp, agno, NULL);
> +		if (!sa->refc_cur)
> +			goto err;
> +	}
> +
> +	return 0;
> +err:
> +	return -ENOMEM;
> +}
> +
> +/* Release the AG header context and btree cursors. */
> +void
> +xfs_scrub_ag_free(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_scrub_ag		*sa)
> +{
> +	xfs_scrub_ag_btcur_free(sa);
> +	if (sa->agfl_bp) {
> +		xfs_trans_brelse(sc->tp, sa->agfl_bp);
> +		sa->agfl_bp = NULL;
> +	}
> +	if (sa->agf_bp) {
> +		xfs_trans_brelse(sc->tp, sa->agf_bp);
> +		sa->agf_bp = NULL;
> +	}
> +	if (sa->agi_bp) {
> +		xfs_trans_brelse(sc->tp, sa->agi_bp);
> +		sa->agi_bp = NULL;
> +	}
> +	sa->agno = NULLAGNUMBER;
> +}
> +
> +/*
> + * For scrub, grab the AGI and the AGF headers, in that order.  Locking
> + * order requires us to get the AGI before the AGF.  We use the
> + * transaction to avoid deadlocking on crosslinked metadata buffers;
> + * either the caller passes one in (bmap scrub) or we have to create a
> + * transaction ourselves.
> + */
> +int
> +xfs_scrub_ag_init(
> +	struct xfs_scrub_context	*sc,
> +	xfs_agnumber_t			agno,
> +	struct xfs_scrub_ag		*sa)
> +{
> +	int				error;
> +
> +	sa->agno = agno;
> +	error = xfs_scrub_ag_read_headers(sc, agno, &sa->agi_bp,
> +			&sa->agf_bp, &sa->agfl_bp);
> +	if (error)
> +		return error;
> +
> +	return xfs_scrub_ag_btcur_init(sc, sa);
> +}
> +
>  /* Dummy scrubber */
>
>  int
> @@ -409,6 +576,7 @@ xfs_scrub_teardown(
>  	struct xfs_scrub_context	*sc,
>  	int				error)
>  {
> +	xfs_scrub_ag_free(sc, &sc->sa);
>  	if (sc->tp) {
>  		xfs_trans_cancel(sc->tp);
>  		sc->tp = NULL;
> @@ -430,6 +598,7 @@ xfs_scrub_setup(
>  	sc->sm = sm;
>  	sc->fns = fns;
>  	sc->try_harder = try_harder;
> +	sc->sa.agno = NULLAGNUMBER;
>
>  	return sc->fns->setup(sc, ip);
>  }
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index 4f3113a..15baccb 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -27,6 +27,24 @@ static inline bool xfs_scrub_found_corruption(struct xfs_scrub_metadata *sm)
>  			       XFS_SCRUB_FLAG_XCORRUPT);
>  }
>
> +/* Buffer pointers and btree cursors for an entire AG. */
> +struct xfs_scrub_ag {
> +	xfs_agnumber_t			agno;
> +
> +	/* AG btree roots */
> +	struct xfs_buf			*agf_bp;
> +	struct xfs_buf			*agfl_bp;
> +	struct xfs_buf			*agi_bp;
> +
> +	/* AG btrees */
> +	struct xfs_btree_cur		*bno_cur;
> +	struct xfs_btree_cur		*cnt_cur;
> +	struct xfs_btree_cur		*ino_cur;
> +	struct xfs_btree_cur		*fino_cur;
> +	struct xfs_btree_cur		*rmap_cur;
> +	struct xfs_btree_cur		*refc_cur;
> +};
> +
>  struct xfs_scrub_context {
>  	/* General scrub state. */
>  	struct xfs_mount		*mp;
> @@ -35,6 +53,9 @@ struct xfs_scrub_context {
>  	struct xfs_trans		*tp;
>  	struct xfs_inode		*ip;
>  	bool				try_harder;
> +
> +	/* State tracking for single-AG operations. */
> +	struct xfs_scrub_ag		sa;
>  };
>
>  /* Should we end the scrub early? */
> @@ -164,6 +185,15 @@ bool xfs_scrub_incomplete(struct xfs_scrub_context *sc, const char *type,
>  	xfs_scrub_incomplete((sc), (type), (fs_ok), \
>  			#fs_ok, __func__, __LINE__)
>
> +void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
> +int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
> +		      struct xfs_scrub_ag *sa);
> +int xfs_scrub_ag_read_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
> +			      struct xfs_buf **agi, struct xfs_buf **agf,
> +			      struct xfs_buf **agfl);
> +int xfs_scrub_ag_btcur_init(struct xfs_scrub_context *sc,
> +			    struct xfs_scrub_ag *sa);
> +
>  /* Setup functions */
>
>  #define SETUP_FN(name) int name(struct xfs_scrub_context *sc, struct xfs_inode *ip)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

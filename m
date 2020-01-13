Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F649C33CA9
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 21:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC96421569
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 21:26:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o/GS+gSi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgAMV0s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 16:26:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgAMV0s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 16:26:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00DLPfhX150994;
        Mon, 13 Jan 2020 21:26:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=EkYu1qoS2dqf0KADJnt5LZLEBxqcehcjBp7qtMAK4v8=;
 b=o/GS+gSimpEInod+13e/JwxBiHRsNK8DOBjRolO6YW3j9K0yEVWPcZIT/SbgGa5Rsa54
 4evVmz1InzDMVDHOX4f1Uttt5INO3RTXWMOFU2iumv4zHBGw7ma8U9nJUMLHK2Ue6gSx
 CaZxhmp6ntyzshPC6GopCAG5vyfPtX/7TqYo6m52HJOpoPLR/KoX7sRjeIIT3NrwtFRB
 RdDRP/Rgkl4913jB1xGC0v1PzU+Cl9Ebrx5SGtuF0KjcphjQ8LrgUwD8dwnxvyg/ohf6
 ousC+YD+AJwks7Ckhyi2kR51AR51/L7IFqAgRENrd0envWiAGI5WYHk9R3nuE+Kd3I40 Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xf74s1qtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 21:26:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00DLFSrG009732;
        Mon, 13 Jan 2020 21:26:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xfrgjdc3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 21:26:42 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00DLQf5v008651;
        Mon, 13 Jan 2020 21:26:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 13:26:41 -0800
Date:   Mon, 13 Jan 2020 13:26:39 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     david@fromorbit.com, chandan@linux.ibm.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Fix log reservation calculation for xattr
 insert operation
Message-ID: <20200113212639.GL8247@magnolia>
References: <20200110042953.18557-1-chandanrlinux@gmail.com>
 <20200110042953.18557-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110042953.18557-2-chandanrlinux@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001130173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001130174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 10, 2020 at 09:59:53AM +0530, Chandan Rajendra wrote:
> Log space reservation for xattr insert operation can be divided into two
> parts,
> 1. Mount time
>    - Inode
>    - Superblock for accounting space allocations
>    - AGF for accounting space used be count, block number, rmapbt and refcnt
>      btrees.
> 
> 2. The remaining log space can only be calculated at run time because,
>    - A local xattr can be large enough to cause a double split of the dabtree.
>    - The value of the xattr can be large enough to be stored in remote
>      blocks. The contents of the remote blocks are not logged.
> 
>    The log space reservation would be,
>    - 2 * XFS_DA_NODE_MAXDEPTH number of blocks. Additional XFS_DA_NODE_MAXDEPTH
>      number of blocks are required if xattr is large enough to cause another
>      split of the dabtree path from root to leaf block.
>    - BMBT blocks for storing (2 * XFS_DA_NODE_MAXDEPTH) record
>      entries. Additional XFS_DA_NODE_MAXDEPTH number of blocks are required in
>      case of a double split of the dabtree path from root to leaf blocks.
>    - Space for logging blocks of count, block number, rmap and refcnt btrees.
> 
> This commit refactors xfs_attr_calc_size() to calculate the log reservation
> space and also the FS reservation space. It then replaces the erroneous
> calculation inside xfs_log_calc_max_attrsetm_res() with an invocation of
> xfs_attr_calc_size().

Uh, what was the error that you saw?

> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       | 107 +++++++++++++++++++++------------
>  fs/xfs/libxfs/xfs_attr.h       |   4 +-
>  fs/xfs/libxfs/xfs_log_rlimit.c |  15 ++---
>  fs/xfs/libxfs/xfs_trans_resv.c |  34 ++---------
>  fs/xfs/libxfs/xfs_trans_resv.h |   2 +
>  5 files changed, 86 insertions(+), 76 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1eae1db74f6c..067661e61286 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -183,43 +183,6 @@ xfs_attr_get(
>  	return 0;
>  }
>  
> -/*
> - * Calculate how many blocks we need for the new attribute,
> - */
> -STATIC int
> -xfs_attr_calc_size(
> -	struct xfs_da_args	*args,
> -	int			*local)
> -{
> -	struct xfs_mount	*mp = args->dp->i_mount;
> -	int			size;
> -	int			nblks;
> -
> -	/*
> -	 * Determine space new attribute will use, and if it would be
> -	 * "local" or "remote" (note: local != inline).
> -	 */
> -	size = xfs_attr_leaf_newentsize(mp, args->namelen, args->valuelen,
> -					local);
> -	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> -	if (*local) {
> -		if (size > (args->geo->blksize / 2)) {
> -			/* Double split possible */
> -			nblks *= 2;
> -		}
> -	} else {
> -		/*
> -		 * Out of line attribute, cannot double split, but
> -		 * make room for the attribute value itself.
> -		 */
> -		uint	dblocks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> -		nblks += dblocks;
> -		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
> -	}
> -
> -	return nblks;
> -}
> -
>  STATIC int
>  xfs_attr_try_sf_addname(
>  	struct xfs_inode	*dp,
> @@ -248,6 +211,69 @@ xfs_attr_try_sf_addname(
>  	return error ? error : error2;
>  }
>  
> +/*
> + * Calculate how many blocks we need for the new attribute,
> + */
> +void
> +xfs_attr_calc_size(
> +	struct xfs_mount	*mp,
> +	int			namelen,
> +	int			valuelen,
> +	int			*local,
> +	unsigned int		*log_blks,

I see the xfs_calc_buf_res() calls below, which means this value ends up
with the number of *log bytes* needed to log all the blocks we think
we're going to need for the new attr.

> +	unsigned int		*total_blks)
> +{
> +	unsigned int		blksize;
> +	int			dabtree_blks;
> +	int			bmbt_blks;
> +	int			size;
> +	int			dblks;
> +
> +	blksize = mp->m_dir_geo->blksize;
> +	dblks = 0;
> +	*log_blks = 0;
> +	*total_blks = 0;
> +
> +	/*
> +	 * Determine space new attribute will use, and if it would be
> +	 * "local" or "remote" (note: local != inline).
> +	 */
> +	size = xfs_attr_leaf_newentsize(mp, namelen, valuelen, local);
> +
> +	dabtree_blks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> +	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);

Ok, so this calculates the number of blocks we need to add one attr
block to the dabtree + whatever dabtree split we might need to insert
the leaf block + whatever bmbt splits we might need to insert each of
the new dabtree blocks into the attr fork.

I guess this calculation handles the case where we have to add an attr
leaf block to the dabtree...?

> +
> +	*log_blks = xfs_calc_buf_res(2 * dabtree_blks, blksize);
> +	*log_blks += xfs_calc_buf_res(2 * bmbt_blks, XFS_FSB_TO_B(mp, 1));

Why reserve log space for twice as many blocks as we just calculated?

> +	if (*local) {
> +		if (size > (blksize / 2)) {
> +			/* Double split possible */
> +			*log_blks += xfs_calc_buf_res(dabtree_blks, blksize);
> +			*log_blks += xfs_calc_buf_res(bmbt_blks,
> +						XFS_FSB_TO_B(mp, 1));
> +
> +			dabtree_blks *= 2;
> +			bmbt_blks *= 2;

This appears to be the new version of the old code "nblks *= 2", which
doubled the resource counts if it anticipates a possible second dabtree
split (i.e. the attr entry size is more than half a block), right?

You really ought to use the proper macro to update bmbt_blocks instead
of assuming that doubling it will be fine.

> +		}
> +	} else {
> +		/*
> +		 * Out of line attribute, cannot double split, but
> +		 * make room for the attribute value itself.
> +		 */
> +		dblks = xfs_attr3_rmt_blocks(mp, valuelen);
> +		bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, dblks, XFS_ATTR_FORK);
> +		*log_blks += xfs_calc_buf_res(bmbt_blks, XFS_FSB_TO_B(mp, 1));

This adds enough log bytes reservation to handle bmbt splits to add all
the (unlogged) remote attr value blocks to the attr fork...

> +	}
> +
> +	*log_blks += xfs_calc_buf_res(xfs_allocfree_log_count(mp, dabtree_blks),
> +				XFS_FSB_TO_B(mp, 1));

...this adds log bytes reservation for all the AG space btree updates
that might be necessary to all all those blocks to the dabtree...

> +	*log_blks += xfs_calc_buf_res(xfs_allocfree_log_count(mp, dblks),
> +				XFS_FSB_TO_B(mp, 1));

...and this one does the same for all the bmbt blocks needed to map in
the new dabtree blocks.

> +	*total_blks = dabtree_blks + bmbt_blks + dblks;

This calculation is the worst case number of blocks we think we'll need,
which gets fed to _trans_alloc as well as args.total.  This is the same
behavior as before this patchset.

Before this series, we compute the number of bytes of log space needed
to record all the new metadata:

	tr_attrsetm.tr_logres + (args.total * tr_attrsetrt.tr_logres)

tr_attrsetm.tr_logres is large enough to log the first of the dabtree
splits, but ... doesn't seem to do so for the double split case?  Hmm.

tr_attrsetrt.tr_logres is set to the number of log bytes needed
to log the AGF and BMBT updates needed to add one block to the tree, but
that doesn't factor in all of the log bytes needed to record the changes
to the bnobt, cntbt, and rmapbt.

So my guess is that the problem you saw was that you're running some
workload that exercises the attribute setting routines heavily, and at
some point the dabtree gets full enough and/or the fs fragments enough
that we exceed the log bytes reservation and the log goes offline?

Assuming I've gotten all that correct, I think I see a better way to
structure this.  For one thing, I think we should keep the log space
reservation calculations functions in xfs_trans_resv.c and not spread
them into xfs_attr.c.

xfs_attr_calc_size should return both the (max) number of *dabtree*
blocks that we're going to log and the (max) number of *dabtree* blocks
that we could be allocating.  Next, add a pair of functions to
xfs_trans_resv.c to compute the actual log space and log blocks
reservations given the above two outputs.

xfs_calc_attr_res(log_dablocks, total_dablocks)
{
	bmbt_blks = XFS_NEXTENTADD_SPACE_RES(total_dablocks)
	space_blks = xfs_allocfree_log_count(total_dablocks + bmbt_blks)

	return tr_attrsetm.tr_logres +
	       xfs_calc_buf_res(log_dablocks, blksize) +
	       xfs_calc_buf_res(bmbt_blks, blksize) +
	       xfs_calc_buf_res(space_blks, blksize) +
}

xfs_calc_attr_blocks(total_dablocks)
{
	return total_dablocks + XFS_NEXTENTADD_SPACE_RES(total_dablocks)
}

and fix the atttrsetm.tr_logres calculation not to include the dablocks
reservation.

Ok, bikeshedding time. :P

--D

> +}
> +
>  /*
>   * Set the attribute specified in @args.
>   */
> @@ -347,6 +373,7 @@ xfs_attr_set(
>  	struct xfs_da_args	args;
>  	struct xfs_trans_res	tres;
>  	int			rsvd = (flags & ATTR_ROOT) != 0;
> +	int			log_blks;
>  	int			error, local;
>  
>  	XFS_STATS_INC(mp, xs_attr_set);
> @@ -361,7 +388,8 @@ xfs_attr_set(
>  	args.value = value;
>  	args.valuelen = valuelen;
>  	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> -	args.total = xfs_attr_calc_size(&args, &local);
> +	xfs_attr_calc_size(mp, args.namelen, args.valuelen, &local,
> +			&log_blks, &args.total);
>  
>  	error = xfs_qm_dqattach(dp);
>  	if (error)
> @@ -380,8 +408,7 @@ xfs_attr_set(
>  			return error;
>  	}
>  
> -	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> -			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
> +	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres + log_blks;
>  	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>  	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 94badfa1743e..9c9b301dc27c 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -154,5 +154,7 @@ int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> -
> +void xfs_attr_calc_size(struct xfs_mount *mp, int namelen, int valuelen,
> +			int *local, unsigned int *log_blks,
> +			unsigned int *total_blks);
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index 7f55eb3f3653..be13c2f1abce 100644
> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> @@ -10,6 +10,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> +#include "xfs_attr.h"
>  #include "xfs_da_format.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_da_btree.h"
> @@ -23,17 +24,17 @@ STATIC int
>  xfs_log_calc_max_attrsetm_res(
>  	struct xfs_mount	*mp)
>  {
> -	int			size;
> -	int			nblks;
> +	int		size;
> +	int		local;
> +	unsigned int	total_blks;
> +	unsigned int	log_blks;
>  
>  	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
>  	       MAXNAMELEN - 1;
> -	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> -	nblks += XFS_B_TO_FSB(mp, size);
> -	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
> +	xfs_attr_calc_size(mp, size, 0, &local, &log_blks, &total_blks);
> +	ASSERT(local == 1);
>  
> -	return  M_RES(mp)->tr_attrsetm.tr_logres +
> -		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
> +	return M_RES(mp)->tr_attrsetm.tr_logres + log_blks;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 824073a839ac..3fb0aa92ac54 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -30,7 +30,7 @@
>   * to a multiple of 128 bytes so that we don't change the historical
>   * reservation that has been used for this overhead.
>   */
> -STATIC uint
> +uint
>  xfs_buf_log_overhead(void)
>  {
>  	return round_up(sizeof(struct xlog_op_header) +
> @@ -44,7 +44,7 @@ xfs_buf_log_overhead(void)
>   * will be changed in a transaction.  size is used to tell how many
>   * bytes should be reserved per item.
>   */
> -STATIC uint
> +uint
>  xfs_calc_buf_res(
>  	uint		nbufs,
>  	uint		size)
> @@ -701,12 +701,10 @@ xfs_calc_attrinval_reservation(
>   * Setting an attribute at mount time.
>   *	the inode getting the attribute
>   *	the superblock for allocations
> - *	the agfs extents are allocated from
> - *	the attribute btree * max depth
> - *	the inode allocation btree
> + *	the agf extents are allocated from
>   * Since attribute transaction space is dependent on the size of the attribute,
>   * the calculation is done partially at mount time and partially at runtime(see
> - * below).
> + * xfs_attr_calc_size()).
>   */
>  STATIC uint
>  xfs_calc_attrsetm_reservation(
> @@ -714,27 +712,7 @@ xfs_calc_attrsetm_reservation(
>  {
>  	return XFS_DQUOT_LOGRES(mp) +
>  		xfs_calc_inode_res(mp, 1) +
> -		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> -		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
> -}
> -
> -/*
> - * Setting an attribute at runtime, transaction space unit per block.
> - * 	the superblock for allocations: sector size
> - *	the inode bmap btree could join or split: max depth * block size
> - * Since the runtime attribute transaction space is dependent on the total
> - * blocks needed for the 1st bmap, here we calculate out the space unit for
> - * one block so that the caller could figure out the total space according
> - * to the attibute extent length in blocks by:
> - *	ext * M_RES(mp)->tr_attrsetrt.tr_logres
> - */
> -STATIC uint
> -xfs_calc_attrsetrt_reservation(
> -	struct xfs_mount	*mp)
> -{
> -	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> -		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
> -				 XFS_FSB_TO_B(mp, 1));
> +		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize);
>  }
>  
>  /*
> @@ -942,7 +920,7 @@ xfs_trans_resv_calc(
>  	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
>  	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
>  	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
> -	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
> +	resp->tr_attrsetrt.tr_logres = 0;
>  	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
>  	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
>  	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index 7241ab28cf84..9a7af411cec9 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -91,6 +91,8 @@ struct xfs_trans_resv {
>  #define	XFS_ATTRSET_LOG_COUNT		3
>  #define	XFS_ATTRRM_LOG_COUNT		3
>  
> +uint xfs_buf_log_overhead(void);
> +uint xfs_calc_buf_res(uint nbufs, uint size);
>  void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
>  uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
>  
> -- 
> 2.19.1
> 

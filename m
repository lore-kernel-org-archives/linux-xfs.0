Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BF4C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C30121D7E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:29:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S3rY1YoO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfKHA3M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:29:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40222 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfKHA3M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:29:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80OX3m162323;
        Fri, 8 Nov 2019 00:29:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=013yiClk77oNxVHpie8Jg1mp/BgwUFdUhdtnH2VZX+o=;
 b=S3rY1YoON2a5aLZ09cFMtiGsCNUzESX7tY64trM6r/GJa5eGi1ThC7Ae+9KMp2vUcPEt
 lWrv8JyY53JoSnxfFvOgvD3UxYiAojx69gpnzTMtM4TtGPxV7pnR4+e5rNOUdNyzoU1g
 17LJ5VKInr4GpSAOBJwj8LKoCueACzUwSPNE5oDZRb/l80O9Rv5T8qLw9vJCtOcaZwB2
 Sw950j2Xgc65TUsNmjA3nRI/XVeC/RcxedVc2ZrzriHPnpeZKVCOrjFlC1zj9QGDtklp
 bwbjE9IOUFLQo1JMozBOKE3vQHtOVfOqeeA4t4Jtb1QxFusWt/cWGdAMEme0ibMXuUkd MA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w41w19v7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:29:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80S4IV167254;
        Fri, 8 Nov 2019 00:29:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w4k2xtv98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:28:59 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA80SwjL005411;
        Fri, 8 Nov 2019 00:28:58 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:28:58 -0800
Date:   Thu, 7 Nov 2019 16:28:58 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/46] xfs: add a entries pointer to struct
 xfs_dir3_icleaf_hdr
Message-ID: <20191108002858.GS6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-11-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080003
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:23:34PM +0100, Christoph Hellwig wrote:
> All callers of the ->node_tree_p dir operation already have a struct
> xfs_dir3_icleaf_hdr from a previous call to xfs_da_leaf_hdr_from_disk at
> hand, or just need slight changes to the calling conventions to do so.
> Add a pointer to the entries to struct xfs_dir3_icleaf_hdr to clean up
> this pattern.  To make this possible the xfs_dir3_leaf_log_ents function
> grow a new argument to pass the xfs_dir3_icleaf_hdr that call callers
> already have, and xfs_dir2_leaf_lookup_int returns the
> xfs_dir3_icleaf_hdr to the callers so that they can later use it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.c   |   7 +--
>  fs/xfs/libxfs/xfs_da_format.c  |  15 -----
>  fs/xfs/libxfs/xfs_dir2.h       |   2 -
>  fs/xfs/libxfs/xfs_dir2_block.c |   7 +--
>  fs/xfs/libxfs/xfs_dir2_leaf.c  | 101 +++++++++++++++------------------
>  fs/xfs/libxfs/xfs_dir2_node.c  |  64 +++++++++------------
>  fs/xfs/libxfs/xfs_dir2_priv.h  |   9 ++-
>  fs/xfs/scrub/dir.c             |  14 ++---
>  8 files changed, 93 insertions(+), 126 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 1742e8293574..46b1c3fb305c 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -640,15 +640,14 @@ xfs_da3_root_split(
>  		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
>  	} else {
>  		struct xfs_dir3_icleaf_hdr leafhdr;
> -		struct xfs_dir2_leaf_entry *ents;
>  
>  		leaf = (xfs_dir2_leaf_t *)oldroot;
>  		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
> -		ents = dp->d_ops->leaf_ents_p(leaf);
>  
>  		ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
>  		       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
> -		size = (int)((char *)&ents[leafhdr.count] - (char *)leaf);
> +		size = (int)((char *)&leafhdr.ents[leafhdr.count] -
> +			(char *)leaf);
>  		level = 0;
>  
>  		/*
> @@ -2297,7 +2296,7 @@ xfs_da3_swap_lastblock(
>  		dead_leaf2 = (xfs_dir2_leaf_t *)dead_info;
>  		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr,
>  					    dead_leaf2);
> -		ents = dp->d_ops->leaf_ents_p(dead_leaf2);
> +		ents = leafhdr.ents;
>  		dead_level = 0;
>  		dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
>  	} else {
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 193708d12459..ed21ce01502f 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -411,12 +411,6 @@ xfs_dir2_max_leaf_ents(struct xfs_da_geometry *geo)
>  		(uint)sizeof(struct xfs_dir2_leaf_entry);
>  }
>  
> -static struct xfs_dir2_leaf_entry *
> -xfs_dir2_leaf_ents_p(struct xfs_dir2_leaf *lp)
> -{
> -	return lp->__ents;
> -}
> -
>  static int
>  xfs_dir3_max_leaf_ents(struct xfs_da_geometry *geo)
>  {
> @@ -424,12 +418,6 @@ xfs_dir3_max_leaf_ents(struct xfs_da_geometry *geo)
>  		(uint)sizeof(struct xfs_dir2_leaf_entry);
>  }
>  
> -static struct xfs_dir2_leaf_entry *
> -xfs_dir3_leaf_ents_p(struct xfs_dir2_leaf *lp)
> -{
> -	return ((struct xfs_dir3_leaf *)lp)->__ents;
> -}
> -
>  /*
>   * Directory free space block operations
>   */
> @@ -584,7 +572,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  
>  	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
>  	.leaf_max_ents = xfs_dir2_max_leaf_ents,
> -	.leaf_ents_p = xfs_dir2_leaf_ents_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
> @@ -627,7 +614,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  
>  	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
>  	.leaf_max_ents = xfs_dir2_max_leaf_ents,
> -	.leaf_ents_p = xfs_dir2_leaf_ents_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
> @@ -670,7 +656,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  
>  	.leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr),
>  	.leaf_max_ents = xfs_dir3_max_leaf_ents,
> -	.leaf_ents_p = xfs_dir3_leaf_ents_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
>  	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 15a1a72dc126..b46657974134 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -74,8 +74,6 @@ struct xfs_dir_ops {
>  
>  	int	leaf_hdr_size;
>  	int	(*leaf_max_ents)(struct xfs_da_geometry *geo);
> -	struct xfs_dir2_leaf_entry *
> -		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
>  
>  	int	free_hdr_size;
>  	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index d9ad89f6fd79..065fe10a842b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -914,7 +914,6 @@ xfs_dir2_leaf_to_block(
>  	__be16			*tagp;		/* end of entry (tag) */
>  	int			to;		/* block/leaf to index */
>  	xfs_trans_t		*tp;		/* transaction pointer */
> -	struct xfs_dir2_leaf_entry *ents;
>  	struct xfs_dir3_icleaf_hdr leafhdr;
>  
>  	trace_xfs_dir2_leaf_to_block(args);
> @@ -924,7 +923,6 @@ xfs_dir2_leaf_to_block(
>  	mp = dp->i_mount;
>  	leaf = lbp->b_addr;
>  	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
> -	ents = dp->d_ops->leaf_ents_p(leaf);
>  	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
>  
>  	ASSERT(leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
> @@ -1004,9 +1002,10 @@ xfs_dir2_leaf_to_block(
>  	 */
>  	lep = xfs_dir2_block_leaf_p(btp);
>  	for (from = to = 0; from < leafhdr.count; from++) {
> -		if (ents[from].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
> +		if (leafhdr.ents[from].address ==
> +		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
>  			continue;
> -		lep[to++] = ents[from];
> +		lep[to++] = leafhdr.ents[from];
>  	}
>  	ASSERT(to == be32_to_cpu(btp->count));
>  	xfs_dir2_block_log_leaf(tp, dbp, 0, be32_to_cpu(btp->count) - 1);
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 07734c0fe8a7..5e3e96efdaca 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -24,7 +24,8 @@
>   * Local function declarations.
>   */
>  static int xfs_dir2_leaf_lookup_int(xfs_da_args_t *args, struct xfs_buf **lbpp,
> -				    int *indexp, struct xfs_buf **dbpp);
> +				    int *indexp, struct xfs_buf **dbpp,
> +				    struct xfs_dir3_icleaf_hdr *leafhdr);
>  static void xfs_dir3_leaf_log_bests(struct xfs_da_args *args,
>  				    struct xfs_buf *bp, int first, int last);
>  static void xfs_dir3_leaf_log_tail(struct xfs_da_args *args,
> @@ -44,6 +45,7 @@ xfs_dir2_leaf_hdr_from_disk(
>  		to->magic = be16_to_cpu(from3->hdr.info.hdr.magic);
>  		to->count = be16_to_cpu(from3->hdr.count);
>  		to->stale = be16_to_cpu(from3->hdr.stale);
> +		to->ents = from3->__ents;
>  
>  		ASSERT(to->magic == XFS_DIR3_LEAF1_MAGIC ||
>  		       to->magic == XFS_DIR3_LEAFN_MAGIC);
> @@ -53,6 +55,7 @@ xfs_dir2_leaf_hdr_from_disk(
>  		to->magic = be16_to_cpu(from->hdr.info.magic);
>  		to->count = be16_to_cpu(from->hdr.count);
>  		to->stale = be16_to_cpu(from->hdr.stale);
> +		to->ents = from->__ents;
>  
>  		ASSERT(to->magic == XFS_DIR2_LEAF1_MAGIC ||
>  		       to->magic == XFS_DIR2_LEAFN_MAGIC);
> @@ -139,7 +142,6 @@ xfs_dir3_leaf_check_int(
>  	struct xfs_dir3_icleaf_hdr *hdr,
>  	struct xfs_dir2_leaf	*leaf)
>  {
> -	struct xfs_dir2_leaf_entry *ents;
>  	xfs_dir2_leaf_tail_t	*ltp;
>  	int			stale;
>  	int			i;
> @@ -158,7 +160,6 @@ xfs_dir3_leaf_check_int(
>  		hdr = &leafhdr;
>  	}
>  
> -	ents = ops->leaf_ents_p(leaf);
>  	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
>  
>  	/*
> @@ -172,17 +173,17 @@ xfs_dir3_leaf_check_int(
>  	/* Leaves and bests don't overlap in leaf format. */
>  	if ((hdr->magic == XFS_DIR2_LEAF1_MAGIC ||
>  	     hdr->magic == XFS_DIR3_LEAF1_MAGIC) &&
> -	    (char *)&ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
> +	    (char *)&hdr->ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
>  		return __this_address;
>  
>  	/* Check hash value order, count stale entries.  */
>  	for (i = stale = 0; i < hdr->count; i++) {
>  		if (i + 1 < hdr->count) {
> -			if (be32_to_cpu(ents[i].hashval) >
> -					be32_to_cpu(ents[i + 1].hashval))
> +			if (be32_to_cpu(hdr->ents[i].hashval) >
> +					be32_to_cpu(hdr->ents[i + 1].hashval))
>  				return __this_address;
>  		}
> -		if (ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
> +		if (hdr->ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
>  			stale++;
>  	}
>  	if (hdr->stale != stale)
> @@ -404,7 +405,6 @@ xfs_dir2_block_to_leaf(
>  	int			needscan;	/* need to rescan bestfree */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  	struct xfs_dir2_data_free *bf;
> -	struct xfs_dir2_leaf_entry *ents;
>  	struct xfs_dir3_icleaf_hdr leafhdr;
>  
>  	trace_xfs_dir2_block_to_leaf(args);
> @@ -434,7 +434,6 @@ xfs_dir2_block_to_leaf(
>  	btp = xfs_dir2_block_tail_p(args->geo, hdr);
>  	blp = xfs_dir2_block_leaf_p(btp);
>  	bf = dp->d_ops->data_bestfree_p(hdr);
> -	ents = dp->d_ops->leaf_ents_p(leaf);
>  
>  	/*
>  	 * Set the counts in the leaf header.
> @@ -449,8 +448,9 @@ xfs_dir2_block_to_leaf(
>  	 * Could compact these but I think we always do the conversion
>  	 * after squeezing out stale entries.
>  	 */
> -	memcpy(ents, blp, be32_to_cpu(btp->count) * sizeof(xfs_dir2_leaf_entry_t));
> -	xfs_dir3_leaf_log_ents(args, lbp, 0, leafhdr.count - 1);
> +	memcpy(leafhdr.ents, blp,
> +		be32_to_cpu(btp->count) * sizeof(struct xfs_dir2_leaf_entry));
> +	xfs_dir3_leaf_log_ents(args, &leafhdr, lbp, 0, leafhdr.count - 1);
>  	needscan = 0;
>  	needlog = 1;
>  	/*
> @@ -665,8 +665,8 @@ xfs_dir2_leaf_addname(
>  	index = xfs_dir2_leaf_search_hash(args, lbp);
>  	leaf = lbp->b_addr;
>  	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
> -	ents = dp->d_ops->leaf_ents_p(leaf);
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
> +	ents = leafhdr.ents;
>  	bestsp = xfs_dir2_leaf_bests_p(ltp);
>  	length = dp->d_ops->data_entsize(args->namelen);
>  
> @@ -912,7 +912,7 @@ xfs_dir2_leaf_addname(
>  	 */
>  	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
>  	xfs_dir3_leaf_log_header(args, lbp);
> -	xfs_dir3_leaf_log_ents(args, lbp, lfloglow, lfloghigh);
> +	xfs_dir3_leaf_log_ents(args, &leafhdr, lbp, lfloglow, lfloghigh);
>  	xfs_dir3_leaf_check(dp, lbp);
>  	xfs_dir3_data_check(dp, dbp);
>  	return 0;
> @@ -932,7 +932,6 @@ xfs_dir3_leaf_compact(
>  	xfs_dir2_leaf_t	*leaf;		/* leaf structure */
>  	int		loglow;		/* first leaf entry to log */
>  	int		to;		/* target leaf index */
> -	struct xfs_dir2_leaf_entry *ents;
>  	struct xfs_inode *dp = args->dp;
>  
>  	leaf = bp->b_addr;
> @@ -942,9 +941,9 @@ xfs_dir3_leaf_compact(
>  	/*
>  	 * Compress out the stale entries in place.
>  	 */
> -	ents = dp->d_ops->leaf_ents_p(leaf);
>  	for (from = to = 0, loglow = -1; from < leafhdr->count; from++) {
> -		if (ents[from].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
> +		if (leafhdr->ents[from].address ==
> +		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
>  			continue;
>  		/*
>  		 * Only actually copy the entries that are different.
> @@ -952,7 +951,7 @@ xfs_dir3_leaf_compact(
>  		if (from > to) {
>  			if (loglow == -1)
>  				loglow = to;
> -			ents[to] = ents[from];
> +			leafhdr->ents[to] = leafhdr->ents[from];
>  		}
>  		to++;
>  	}
> @@ -966,7 +965,7 @@ xfs_dir3_leaf_compact(
>  	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, leafhdr);
>  	xfs_dir3_leaf_log_header(args, bp);
>  	if (loglow != -1)
> -		xfs_dir3_leaf_log_ents(args, bp, loglow, to - 1);
> +		xfs_dir3_leaf_log_ents(args, leafhdr, bp, loglow, to - 1);
>  }
>  
>  /*
> @@ -1095,6 +1094,7 @@ xfs_dir3_leaf_log_bests(
>  void
>  xfs_dir3_leaf_log_ents(
>  	struct xfs_da_args	*args,
> +	struct xfs_dir3_icleaf_hdr *hdr,
>  	struct xfs_buf		*bp,
>  	int			first,
>  	int			last)
> @@ -1102,16 +1102,14 @@ xfs_dir3_leaf_log_ents(
>  	xfs_dir2_leaf_entry_t	*firstlep;	/* pointer to first entry */
>  	xfs_dir2_leaf_entry_t	*lastlep;	/* pointer to last entry */
>  	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> -	struct xfs_dir2_leaf_entry *ents;
>  
>  	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
>  	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
>  	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
>  	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
>  
> -	ents = args->dp->d_ops->leaf_ents_p(leaf);
> -	firstlep = &ents[first];
> -	lastlep = &ents[last];
> +	firstlep = &hdr->ents[first];
> +	lastlep = &hdr->ents[last];
>  	xfs_trans_log_buf(args->trans, bp,
>  		(uint)((char *)firstlep - (char *)leaf),
>  		(uint)((char *)lastlep - (char *)leaf + sizeof(*lastlep) - 1));
> @@ -1173,28 +1171,27 @@ xfs_dir2_leaf_lookup(
>  	int			error;		/* error return code */
>  	int			index;		/* found entry index */
>  	struct xfs_buf		*lbp;		/* leaf buffer */
> -	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
>  	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
>  	xfs_trans_t		*tp;		/* transaction pointer */
> -	struct xfs_dir2_leaf_entry *ents;
> +	struct xfs_dir3_icleaf_hdr leafhdr;
>  
>  	trace_xfs_dir2_leaf_lookup(args);
>  
>  	/*
>  	 * Look up name in the leaf block, returning both buffers and index.
>  	 */
> -	if ((error = xfs_dir2_leaf_lookup_int(args, &lbp, &index, &dbp))) {
> +	error = xfs_dir2_leaf_lookup_int(args, &lbp, &index, &dbp, &leafhdr);
> +	if (error)
>  		return error;
> -	}
> +
>  	tp = args->trans;
>  	dp = args->dp;
>  	xfs_dir3_leaf_check(dp, lbp);
> -	leaf = lbp->b_addr;
> -	ents = dp->d_ops->leaf_ents_p(leaf);
> +
>  	/*
>  	 * Get to the leaf entry and contained data entry address.
>  	 */
> -	lep = &ents[index];
> +	lep = &leafhdr.ents[index];
>  
>  	/*
>  	 * Point to the data entry.
> @@ -1224,7 +1221,8 @@ xfs_dir2_leaf_lookup_int(
>  	xfs_da_args_t		*args,		/* operation arguments */
>  	struct xfs_buf		**lbpp,		/* out: leaf buffer */
>  	int			*indexp,	/* out: index in leaf block */
> -	struct xfs_buf		**dbpp)		/* out: data buffer */
> +	struct xfs_buf		**dbpp,		/* out: data buffer */
> +	struct xfs_dir3_icleaf_hdr *leafhdr)
>  {
>  	xfs_dir2_db_t		curdb = -1;	/* current data block number */
>  	struct xfs_buf		*dbp = NULL;	/* data buffer */
> @@ -1240,8 +1238,6 @@ xfs_dir2_leaf_lookup_int(
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  	xfs_dir2_db_t		cidb = -1;	/* case match data block no. */
>  	enum xfs_dacmp		cmp;		/* name compare result */
> -	struct xfs_dir2_leaf_entry *ents;
> -	struct xfs_dir3_icleaf_hdr leafhdr;
>  
>  	dp = args->dp;
>  	tp = args->trans;
> @@ -1254,8 +1250,7 @@ xfs_dir2_leaf_lookup_int(
>  	*lbpp = lbp;
>  	leaf = lbp->b_addr;
>  	xfs_dir3_leaf_check(dp, lbp);
> -	ents = dp->d_ops->leaf_ents_p(leaf);
> -	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
> +	xfs_dir2_leaf_hdr_from_disk(mp, leafhdr, leaf);
>  
>  	/*
>  	 * Look for the first leaf entry with our hash value.
> @@ -1265,8 +1260,9 @@ xfs_dir2_leaf_lookup_int(
>  	 * Loop over all the entries with the right hash value
>  	 * looking to match the name.
>  	 */
> -	for (lep = &ents[index];
> -	     index < leafhdr.count && be32_to_cpu(lep->hashval) == args->hashval;
> +	for (lep = &leafhdr->ents[index];
> +	     index < leafhdr->count &&
> +			be32_to_cpu(lep->hashval) == args->hashval;
>  	     lep++, index++) {
>  		/*
>  		 * Skip over stale leaf entries.
> @@ -1372,7 +1368,6 @@ xfs_dir2_leaf_removename(
>  	int			needscan;	/* need to rescan data frees */
>  	xfs_dir2_data_off_t	oldbest;	/* old value of best free */
>  	struct xfs_dir2_data_free *bf;		/* bestfree table */
> -	struct xfs_dir2_leaf_entry *ents;
>  	struct xfs_dir3_icleaf_hdr leafhdr;
>  
>  	trace_xfs_dir2_leaf_removename(args);
> @@ -1380,20 +1375,20 @@ xfs_dir2_leaf_removename(
>  	/*
>  	 * Lookup the leaf entry, get the leaf and data blocks read in.
>  	 */
> -	if ((error = xfs_dir2_leaf_lookup_int(args, &lbp, &index, &dbp))) {
> +	error = xfs_dir2_leaf_lookup_int(args, &lbp, &index, &dbp, &leafhdr);
> +	if (error)
>  		return error;
> -	}
> +
>  	dp = args->dp;
>  	leaf = lbp->b_addr;
>  	hdr = dbp->b_addr;
>  	xfs_dir3_data_check(dp, dbp);
>  	bf = dp->d_ops->data_bestfree_p(hdr);
> -	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
> -	ents = dp->d_ops->leaf_ents_p(leaf);
> +
>  	/*
>  	 * Point to the leaf entry, use that to point to the data entry.
>  	 */
> -	lep = &ents[index];
> +	lep = &leafhdr.ents[index];
>  	db = xfs_dir2_dataptr_to_db(args->geo, be32_to_cpu(lep->address));
>  	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
>  		xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
> @@ -1419,7 +1414,7 @@ xfs_dir2_leaf_removename(
>  	xfs_dir3_leaf_log_header(args, lbp);
>  
>  	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
> -	xfs_dir3_leaf_log_ents(args, lbp, index, index);
> +	xfs_dir3_leaf_log_ents(args, &leafhdr, lbp, index, index);
>  
>  	/*
>  	 * Scan the freespace in the data block again if necessary,
> @@ -1508,26 +1503,24 @@ xfs_dir2_leaf_replace(
>  	int			error;		/* error return code */
>  	int			index;		/* index of leaf entry */
>  	struct xfs_buf		*lbp;		/* leaf buffer */
> -	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
>  	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
>  	xfs_trans_t		*tp;		/* transaction pointer */
> -	struct xfs_dir2_leaf_entry *ents;
> +	struct xfs_dir3_icleaf_hdr leafhdr;
>  
>  	trace_xfs_dir2_leaf_replace(args);
>  
>  	/*
>  	 * Look up the entry.
>  	 */
> -	if ((error = xfs_dir2_leaf_lookup_int(args, &lbp, &index, &dbp))) {
> +	error = xfs_dir2_leaf_lookup_int(args, &lbp, &index, &dbp, &leafhdr);
> +	if (error)
>  		return error;
> -	}
> +
>  	dp = args->dp;
> -	leaf = lbp->b_addr;
> -	ents = dp->d_ops->leaf_ents_p(leaf);
>  	/*
>  	 * Point to the leaf entry, get data address from it.
>  	 */
> -	lep = &ents[index];
> +	lep = &leafhdr.ents[index];
>  	/*
>  	 * Point to the data entry.
>  	 */
> @@ -1561,21 +1554,17 @@ xfs_dir2_leaf_search_hash(
>  	xfs_dahash_t		hashwant;	/* hash value looking for */
>  	int			high;		/* high leaf index */
>  	int			low;		/* low leaf index */
> -	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
>  	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
>  	int			mid=0;		/* current leaf index */
> -	struct xfs_dir2_leaf_entry *ents;
>  	struct xfs_dir3_icleaf_hdr leafhdr;
>  
> -	leaf = lbp->b_addr;
> -	ents = args->dp->d_ops->leaf_ents_p(leaf);
> -	xfs_dir2_leaf_hdr_from_disk(args->dp->i_mount, &leafhdr, leaf);
> +	xfs_dir2_leaf_hdr_from_disk(args->dp->i_mount, &leafhdr, lbp->b_addr);
>  
>  	/*
>  	 * Note, the table cannot be empty, so we have to go through the loop.
>  	 * Binary search the leaf entries looking for our hash value.
>  	 */
> -	for (lep = ents, low = 0, high = leafhdr.count - 1,
> +	for (lep = leafhdr.ents, low = 0, high = leafhdr.count - 1,
>  		hashwant = args->hashval;
>  	     low <= high; ) {
>  		mid = (low + high) >> 1;
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 98cd645a8c99..721dd2dcba8d 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -441,7 +441,7 @@ xfs_dir2_leafn_add(
>  	trace_xfs_dir2_leafn_add(args, index);
>  
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
> -	ents = dp->d_ops->leaf_ents_p(leaf);
> +	ents = leafhdr.ents;
>  
>  	/*
>  	 * Quick check just to make sure we are not going to index
> @@ -499,7 +499,7 @@ xfs_dir2_leafn_add(
>  
>  	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
>  	xfs_dir3_leaf_log_header(args, bp);
> -	xfs_dir3_leaf_log_ents(args, bp, lfloglow, lfloghigh);
> +	xfs_dir3_leaf_log_ents(args, &leafhdr, bp, lfloglow, lfloghigh);
>  	xfs_dir3_leaf_check(dp, bp);
>  	return 0;
>  }
> @@ -534,11 +534,9 @@ xfs_dir2_leaf_lasthash(
>  	struct xfs_buf	*bp,			/* leaf buffer */
>  	int		*count)			/* count of entries in leaf */
>  {
> -	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> -	struct xfs_dir2_leaf_entry *ents;
>  	struct xfs_dir3_icleaf_hdr leafhdr;
>  
> -	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
> +	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, bp->b_addr);
>  
>  	ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
>  	       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC ||
> @@ -549,9 +547,7 @@ xfs_dir2_leaf_lasthash(
>  		*count = leafhdr.count;
>  	if (!leafhdr.count)
>  		return 0;
> -
> -	ents = dp->d_ops->leaf_ents_p(leaf);
> -	return be32_to_cpu(ents[leafhdr.count - 1].hashval);
> +	return be32_to_cpu(leafhdr.ents[leafhdr.count - 1].hashval);
>  }
>  
>  /*
> @@ -580,7 +576,6 @@ xfs_dir2_leafn_lookup_for_addname(
>  	xfs_dir2_db_t		newdb;		/* new data block number */
>  	xfs_dir2_db_t		newfdb;		/* new free block number */
>  	xfs_trans_t		*tp;		/* transaction pointer */
> -	struct xfs_dir2_leaf_entry *ents;
>  	struct xfs_dir3_icleaf_hdr leafhdr;
>  
>  	dp = args->dp;
> @@ -588,7 +583,6 @@ xfs_dir2_leafn_lookup_for_addname(
>  	mp = dp->i_mount;
>  	leaf = bp->b_addr;
>  	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
> -	ents = dp->d_ops->leaf_ents_p(leaf);
>  
>  	xfs_dir3_leaf_check(dp, bp);
>  	ASSERT(leafhdr.count > 0);
> @@ -612,7 +606,7 @@ xfs_dir2_leafn_lookup_for_addname(
>  	/*
>  	 * Loop over leaf entries with the right hash value.
>  	 */
> -	for (lep = &ents[index];
> +	for (lep = &leafhdr.ents[index];
>  	     index < leafhdr.count && be32_to_cpu(lep->hashval) == args->hashval;
>  	     lep++, index++) {
>  		/*
> @@ -732,7 +726,6 @@ xfs_dir2_leafn_lookup_for_entry(
>  	xfs_dir2_db_t		newdb;		/* new data block number */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  	enum xfs_dacmp		cmp;		/* comparison result */
> -	struct xfs_dir2_leaf_entry *ents;
>  	struct xfs_dir3_icleaf_hdr leafhdr;
>  
>  	dp = args->dp;
> @@ -740,7 +733,6 @@ xfs_dir2_leafn_lookup_for_entry(
>  	mp = dp->i_mount;
>  	leaf = bp->b_addr;
>  	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
> -	ents = dp->d_ops->leaf_ents_p(leaf);
>  
>  	xfs_dir3_leaf_check(dp, bp);
>  	if (leafhdr.count <= 0) {
> @@ -762,7 +754,7 @@ xfs_dir2_leafn_lookup_for_entry(
>  	/*
>  	 * Loop over leaf entries with the right hash value.
>  	 */
> -	for (lep = &ents[index];
> +	for (lep = &leafhdr.ents[index];
>  	     index < leafhdr.count && be32_to_cpu(lep->hashval) == args->hashval;
>  	     lep++, index++) {
>  		/*
> @@ -917,7 +909,7 @@ xfs_dir3_leafn_moveents(
>  	if (start_d < dhdr->count) {
>  		memmove(&dents[start_d + count], &dents[start_d],
>  			(dhdr->count - start_d) * sizeof(xfs_dir2_leaf_entry_t));
> -		xfs_dir3_leaf_log_ents(args, bp_d, start_d + count,
> +		xfs_dir3_leaf_log_ents(args, dhdr, bp_d, start_d + count,
>  				       count + dhdr->count - 1);
>  	}
>  	/*
> @@ -939,7 +931,7 @@ xfs_dir3_leafn_moveents(
>  	 */
>  	memcpy(&dents[start_d], &sents[start_s],
>  		count * sizeof(xfs_dir2_leaf_entry_t));
> -	xfs_dir3_leaf_log_ents(args, bp_d, start_d, start_d + count - 1);
> +	xfs_dir3_leaf_log_ents(args, dhdr, bp_d, start_d, start_d + count - 1);
>  
>  	/*
>  	 * If there are source entries after the ones we copied,
> @@ -948,7 +940,8 @@ xfs_dir3_leafn_moveents(
>  	if (start_s + count < shdr->count) {
>  		memmove(&sents[start_s], &sents[start_s + count],
>  			count * sizeof(xfs_dir2_leaf_entry_t));
> -		xfs_dir3_leaf_log_ents(args, bp_s, start_s, start_s + count - 1);
> +		xfs_dir3_leaf_log_ents(args, shdr, bp_s, start_s,
> +				       start_s + count - 1);
>  	}
>  
>  	/*
> @@ -979,8 +972,8 @@ xfs_dir2_leafn_order(
>  
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr1, leaf1);
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr2, leaf2);
> -	ents1 = dp->d_ops->leaf_ents_p(leaf1);
> -	ents2 = dp->d_ops->leaf_ents_p(leaf2);
> +	ents1 = hdr1.ents;
> +	ents2 = hdr2.ents;
>  
>  	if (hdr1.count > 0 && hdr2.count > 0 &&
>  	    (be32_to_cpu(ents2[0].hashval) < be32_to_cpu(ents1[0].hashval) ||
> @@ -1032,8 +1025,8 @@ xfs_dir2_leafn_rebalance(
>  	leaf2 = blk2->bp->b_addr;
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr1, leaf1);
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr2, leaf2);
> -	ents1 = dp->d_ops->leaf_ents_p(leaf1);
> -	ents2 = dp->d_ops->leaf_ents_p(leaf2);
> +	ents1 = hdr1.ents;
> +	ents2 = hdr2.ents;
>  
>  	oldsum = hdr1.count + hdr2.count;
>  #if defined(DEBUG) || defined(XFS_WARN)
> @@ -1221,7 +1214,6 @@ xfs_dir2_leafn_remove(
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  	struct xfs_dir2_data_free *bf;		/* bestfree table */
>  	struct xfs_dir3_icleaf_hdr leafhdr;
> -	struct xfs_dir2_leaf_entry *ents;
>  
>  	trace_xfs_dir2_leafn_remove(args, index);
>  
> @@ -1229,12 +1221,11 @@ xfs_dir2_leafn_remove(
>  	tp = args->trans;
>  	leaf = bp->b_addr;
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
> -	ents = dp->d_ops->leaf_ents_p(leaf);
>  
>  	/*
>  	 * Point to the entry we're removing.
>  	 */
> -	lep = &ents[index];
> +	lep = &leafhdr.ents[index];
>  
>  	/*
>  	 * Extract the data block and offset from the entry.
> @@ -1253,7 +1244,7 @@ xfs_dir2_leafn_remove(
>  	xfs_dir3_leaf_log_header(args, bp);
>  
>  	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
> -	xfs_dir3_leaf_log_ents(args, bp, index, index);
> +	xfs_dir3_leaf_log_ents(args, &leafhdr, bp, index, index);
>  
>  	/*
>  	 * Make the data entry free.  Keep track of the longest freespace
> @@ -1350,7 +1341,7 @@ xfs_dir2_leafn_remove(
>  	 * to justify trying to join it with a neighbor.
>  	 */
>  	*rval = (dp->d_ops->leaf_hdr_size +
> -		 (uint)sizeof(ents[0]) * (leafhdr.count - leafhdr.stale)) <
> +		 (uint)sizeof(leafhdr.ents) * (leafhdr.count - leafhdr.stale)) <
>  		args->geo->magicpct;
>  	return 0;
>  }
> @@ -1451,7 +1442,7 @@ xfs_dir2_leafn_toosmall(
>  	blk = &state->path.blk[state->path.active - 1];
>  	leaf = blk->bp->b_addr;
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
> -	ents = dp->d_ops->leaf_ents_p(leaf);
> +	ents = leafhdr.ents;
>  	xfs_dir3_leaf_check(dp, blk->bp);
>  
>  	count = leafhdr.count - leafhdr.stale;
> @@ -1514,7 +1505,7 @@ xfs_dir2_leafn_toosmall(
>  
>  		leaf = bp->b_addr;
>  		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr2, leaf);
> -		ents = dp->d_ops->leaf_ents_p(leaf);
> +		ents = hdr2.ents;
>  		count += hdr2.count - hdr2.stale;
>  		bytes -= count * sizeof(ents[0]);
>  
> @@ -1578,8 +1569,8 @@ xfs_dir2_leafn_unbalance(
>  
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &savehdr, save_leaf);
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &drophdr, drop_leaf);
> -	sents = dp->d_ops->leaf_ents_p(save_leaf);
> -	dents = dp->d_ops->leaf_ents_p(drop_leaf);
> +	sents = savehdr.ents;
> +	dents = drophdr.ents;
>  
>  	/*
>  	 * If there are any stale leaf entries, take this opportunity
> @@ -2161,8 +2152,6 @@ xfs_dir2_node_replace(
>  	int			i;		/* btree level */
>  	xfs_ino_t		inum;		/* new inode number */
>  	int			ftype;		/* new file type */
> -	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
> -	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry being changed */
>  	int			rval;		/* internal return value */
>  	xfs_da_state_t		*state;		/* btree cursor */
>  
> @@ -2194,16 +2183,17 @@ xfs_dir2_node_replace(
>  	 * and locked it.  But paranoia is good.
>  	 */
>  	if (rval == -EEXIST) {
> -		struct xfs_dir2_leaf_entry *ents;
> +		struct xfs_dir3_icleaf_hdr	leafhdr;
> +
>  		/*
>  		 * Find the leaf entry.
>  		 */
>  		blk = &state->path.blk[state->path.active - 1];
>  		ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
> -		leaf = blk->bp->b_addr;
> -		ents = args->dp->d_ops->leaf_ents_p(leaf);
> -		lep = &ents[blk->index];
>  		ASSERT(state->extravalid);
> +
> +		xfs_dir2_leaf_hdr_from_disk(state->mp, &leafhdr,
> +					    blk->bp->b_addr);
>  		/*
>  		 * Point to the data entry.
>  		 */
> @@ -2213,7 +2203,7 @@ xfs_dir2_node_replace(
>  		dep = (xfs_dir2_data_entry_t *)
>  		      ((char *)hdr +
>  		       xfs_dir2_dataptr_to_off(args->geo,
> -					       be32_to_cpu(lep->address)));
> +				be32_to_cpu(leafhdr.ents[blk->index].address)));
>  		ASSERT(inum != be64_to_cpu(dep->inumber));
>  		/*
>  		 * Fill in the new inode number and log the entry.
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index af96e3faefaf..1f068812c453 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -18,6 +18,12 @@ struct xfs_dir3_icleaf_hdr {
>  	uint16_t		magic;
>  	uint16_t		count;
>  	uint16_t		stale;
> +
> +	/*
> +	 * Pointer to the on-disk format entries, which are behind the
> +	 * variable size (v4 vs v5) header in the on-disk block.
> +	 */
> +	struct xfs_dir2_leaf_entry *ents;
>  };
>  
>  struct xfs_dir3_icfree_hdr {
> @@ -85,7 +91,8 @@ extern void xfs_dir3_leaf_compact_x1(struct xfs_dir3_icleaf_hdr *leafhdr,
>  extern int xfs_dir3_leaf_get_buf(struct xfs_da_args *args, xfs_dir2_db_t bno,
>  		struct xfs_buf **bpp, uint16_t magic);
>  extern void xfs_dir3_leaf_log_ents(struct xfs_da_args *args,
> -		struct xfs_buf *bp, int first, int last);
> +		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_buf *bp, int first,
> +		int last);
>  extern void xfs_dir3_leaf_log_header(struct xfs_da_args *args,
>  		struct xfs_buf *bp);
>  extern int xfs_dir2_leaf_lookup(struct xfs_da_args *args);
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 5b004d1f6bef..6754e1477661 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -195,14 +195,15 @@ xchk_dir_rec(
>  	xfs_dir2_dataptr_t		ptr;
>  	xfs_dahash_t			calc_hash;
>  	xfs_dahash_t			hash;
> +	struct xfs_dir3_icleaf_hdr	hdr;
>  	unsigned int			tag;
>  	int				error;
>  
>  	ASSERT(blk->magic == XFS_DIR2_LEAF1_MAGIC ||
>  	       blk->magic == XFS_DIR2_LEAFN_MAGIC);
>  
> -	ent = (void *)ds->dargs.dp->d_ops->leaf_ents_p(blk->bp->b_addr) +
> -		(blk->index * sizeof(struct xfs_dir2_leaf_entry));
> +	xfs_dir2_leaf_hdr_from_disk(mp, &hdr, blk->bp->b_addr);
> +	ent = hdr.ents + blk->index;
>  
>  	/* Check the hash of the entry. */
>  	error = xchk_da_btree_hash(ds, level, &ent->hashval);
> @@ -481,7 +482,6 @@ xchk_directory_leaf1_bestfree(
>  	xfs_dablk_t			lblk)
>  {
>  	struct xfs_dir3_icleaf_hdr	leafhdr;
> -	struct xfs_dir2_leaf_entry	*ents;
>  	struct xfs_dir2_leaf_tail	*ltp;
>  	struct xfs_dir2_leaf		*leaf;
>  	struct xfs_buf			*dbp;
> @@ -505,7 +505,6 @@ xchk_directory_leaf1_bestfree(
>  
>  	leaf = bp->b_addr;
>  	xfs_dir2_leaf_hdr_from_disk(sc->ip->i_mount, &leafhdr, leaf);
> -	ents = d_ops->leaf_ents_p(leaf);
>  	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
>  	bestcount = be32_to_cpu(ltp->bestcount);
>  	bestp = xfs_dir2_leaf_bests_p(ltp);
> @@ -533,18 +532,19 @@ xchk_directory_leaf1_bestfree(
>  	}
>  
>  	/* Leaves and bests don't overlap in leaf format. */
> -	if ((char *)&ents[leafhdr.count] > (char *)bestp) {
> +	if ((char *)&leafhdr.ents[leafhdr.count] > (char *)bestp) {
>  		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>  		goto out;
>  	}
>  
>  	/* Check hash value order, count stale entries.  */
>  	for (i = 0; i < leafhdr.count; i++) {
> -		hash = be32_to_cpu(ents[i].hashval);
> +		hash = be32_to_cpu(leafhdr.ents[i].hashval);
>  		if (i > 0 && lasthash > hash)
>  			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>  		lasthash = hash;
> -		if (ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
> +		if (leafhdr.ents[i].address ==
> +		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
>  			stale++;
>  	}
>  	if (leafhdr.stale != stale)
> -- 
> 2.20.1
> 

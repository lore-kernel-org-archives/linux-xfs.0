Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B86DCA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CBA82084D
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:09:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZgrCCgR8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbfKDUJC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:09:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41344 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbfKDUJC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:09:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4JxEm8080110;
        Mon, 4 Nov 2019 20:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=YS+oqNhpYxOzX0kRQjNG2X/WkF6tmKz0133Xu2eCj8w=;
 b=ZgrCCgR88l7C70q2S3xPaYkX9hVvMnYZ2dZNUfdj5KL7HGfJq1euXB/l9f1ODH7XQLlr
 c/et/BoK9YLOwema/GFV2+8CC6+frCrpozWABASGVOMZiJ2Ev85cXCq/uR7+t9RC4kW+
 GMQdJJ18NRswcg1FcUJxmCzzMr7iBjDtNJQrGC3FMXnT7+Tyi96ahFGnKR/p0msI8LPj
 MEWxfJwk/kpcLupL3++KFOJW33ym07+MKtErZ4Ecc93Y1osP7afyt4b8MfYWzkn2F2Nj
 t8hEX77gj1YfUtfRlw1++BAn5tdyCqloZKmJi79KAB0qto68bicd4Zfdx6hSO/0h81R5 Ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w12er1mj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:08:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4K8skE051499;
        Mon, 4 Nov 2019 20:08:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w1kxmygrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:08:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4K8DvO027271;
        Mon, 4 Nov 2019 20:08:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:08:13 -0800
Date:   Mon, 4 Nov 2019 12:08:12 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/34] xfs: devirtualize ->free_hdr_from_disk
Message-ID: <20191104200812.GM4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-13-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040193
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:06:57PM -0700, Christoph Hellwig wrote:
> Replace the ->free_hdr_from_disk dir ops method with a directly called
> xfs_dir_free_hdr_from_disk helper that takes care of the differences
> between the v4 and v5 on-disk format.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c | 30 -----------------------
>  fs/xfs/libxfs/xfs_dir2.h      |  2 --
>  fs/xfs/libxfs/xfs_dir2_leaf.c | 14 +++--------
>  fs/xfs/libxfs/xfs_dir2_node.c | 46 +++++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_dir2_priv.h |  5 ++--
>  fs/xfs/scrub/dir.c            |  2 +-
>  6 files changed, 43 insertions(+), 56 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index fe9e20698719..d0e541d9d335 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -468,18 +468,6 @@ xfs_dir3_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
>  	return db % xfs_dir3_free_max_bests(geo);
>  }
>  
> -static void
> -xfs_dir2_free_hdr_from_disk(
> -	struct xfs_dir3_icfree_hdr	*to,
> -	struct xfs_dir2_free		*from)
> -{
> -	to->magic = be32_to_cpu(from->hdr.magic);
> -	to->firstdb = be32_to_cpu(from->hdr.firstdb);
> -	to->nvalid = be32_to_cpu(from->hdr.nvalid);
> -	to->nused = be32_to_cpu(from->hdr.nused);
> -	ASSERT(to->magic == XFS_DIR2_FREE_MAGIC);
> -}
> -
>  static void
>  xfs_dir2_free_hdr_to_disk(
>  	struct xfs_dir2_free		*to,
> @@ -493,21 +481,6 @@ xfs_dir2_free_hdr_to_disk(
>  	to->hdr.nused = cpu_to_be32(from->nused);
>  }
>  
> -static void
> -xfs_dir3_free_hdr_from_disk(
> -	struct xfs_dir3_icfree_hdr	*to,
> -	struct xfs_dir2_free		*from)
> -{
> -	struct xfs_dir3_free_hdr *hdr3 = (struct xfs_dir3_free_hdr *)from;
> -
> -	to->magic = be32_to_cpu(hdr3->hdr.magic);
> -	to->firstdb = be32_to_cpu(hdr3->firstdb);
> -	to->nvalid = be32_to_cpu(hdr3->nvalid);
> -	to->nused = be32_to_cpu(hdr3->nused);
> -
> -	ASSERT(to->magic == XFS_DIR3_FREE_MAGIC);
> -}
> -
>  static void
>  xfs_dir3_free_hdr_to_disk(
>  	struct xfs_dir2_free		*to,
> @@ -555,7 +528,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
> -	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
>  	.free_max_bests = xfs_dir2_free_max_bests,
>  	.free_bests_p = xfs_dir2_free_bests_p,
>  	.db_to_fdb = xfs_dir2_db_to_fdb,
> @@ -594,7 +566,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
> -	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
>  	.free_max_bests = xfs_dir2_free_max_bests,
>  	.free_bests_p = xfs_dir2_free_bests_p,
>  	.db_to_fdb = xfs_dir2_db_to_fdb,
> @@ -633,7 +604,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  
>  	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
>  	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
> -	.free_hdr_from_disk = xfs_dir3_free_hdr_from_disk,
>  	.free_max_bests = xfs_dir3_free_max_bests,
>  	.free_bests_p = xfs_dir3_free_bests_p,
>  	.db_to_fdb = xfs_dir3_db_to_fdb,
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index ee18fc56a6a1..c3e6a6fb7e37 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -75,8 +75,6 @@ struct xfs_dir_ops {
>  	int	free_hdr_size;
>  	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
>  				    struct xfs_dir3_icfree_hdr *from);
> -	void	(*free_hdr_from_disk)(struct xfs_dir3_icfree_hdr *to,
> -				      struct xfs_dir2_free *from);
>  	int	(*free_max_bests)(struct xfs_da_geometry *geo);
>  	__be16 * (*free_bests_p)(struct xfs_dir2_free *free);
>  	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 38d42fe1aa02..4b697dd85eab 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -113,7 +113,7 @@ xfs_dir3_leaf1_check(
>  	} else if (leafhdr.magic != XFS_DIR2_LEAF1_MAGIC)
>  		return __this_address;
>  
> -	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf);
> +	return xfs_dir3_leaf_check_int(dp->i_mount, &leafhdr, leaf);
>  }
>  
>  static inline void
> @@ -138,23 +138,15 @@ xfs_dir3_leaf_check(
>  xfs_failaddr_t
>  xfs_dir3_leaf_check_int(
>  	struct xfs_mount	*mp,
> -	struct xfs_inode	*dp,
>  	struct xfs_dir3_icleaf_hdr *hdr,
>  	struct xfs_dir2_leaf	*leaf)
>  {
>  	xfs_dir2_leaf_tail_t	*ltp;
>  	int			stale;
>  	int			i;
> -	const struct xfs_dir_ops *ops;
>  	struct xfs_dir3_icleaf_hdr leafhdr;
>  	struct xfs_da_geometry	*geo = mp->m_dir_geo;
>  
> -	/*
> -	 * we can be passed a null dp here from a verifier, so we need to go the
> -	 * hard way to get them.
> -	 */
> -	ops = xfs_dir_get_ops(mp, dp);
> -
>  	if (!hdr) {
>  		xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
>  		hdr = &leafhdr;
> @@ -208,7 +200,7 @@ xfs_dir3_leaf_verify(
>  	if (fa)
>  		return fa;
>  
> -	return xfs_dir3_leaf_check_int(mp, NULL, NULL, leaf);
> +	return xfs_dir3_leaf_check_int(mp, NULL, leaf);
>  }
>  
>  static void
> @@ -1756,7 +1748,7 @@ xfs_dir2_node_to_leaf(
>  	if (error)
>  		return error;
>  	free = fbp->b_addr;
> -	dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +	xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
>  
>  	ASSERT(!freehdr.firstdb);
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 3b9ed6ac72b6..9e22710bb772 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -54,7 +54,7 @@ xfs_dir3_leafn_check(
>  	} else if (leafhdr.magic != XFS_DIR2_LEAFN_MAGIC)
>  		return __this_address;
>  
> -	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf);
> +	return xfs_dir3_leaf_check_int(dp->i_mount, &leafhdr, leaf);
>  }
>  
>  static inline void
> @@ -220,6 +220,30 @@ __xfs_dir3_free_read(
>  	return 0;
>  }
>  
> +void
> +xfs_dir2_free_hdr_from_disk(
> +	struct xfs_mount		*mp,
> +	struct xfs_dir3_icfree_hdr	*to,
> +	struct xfs_dir2_free		*from)
> +{
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_dir3_free	*from3 = (struct xfs_dir3_free *)from;
> +
> +		to->magic = be32_to_cpu(from3->hdr.hdr.magic);
> +		to->firstdb = be32_to_cpu(from3->hdr.firstdb);
> +		to->nvalid = be32_to_cpu(from3->hdr.nvalid);
> +		to->nused = be32_to_cpu(from3->hdr.nused);
> +
> +		ASSERT(to->magic == XFS_DIR3_FREE_MAGIC);
> +	} else {
> +		to->magic = be32_to_cpu(from->hdr.magic);
> +		to->firstdb = be32_to_cpu(from->hdr.firstdb);
> +		to->nvalid = be32_to_cpu(from->hdr.nvalid);
> +		to->nused = be32_to_cpu(from->hdr.nused);
> +		ASSERT(to->magic == XFS_DIR2_FREE_MAGIC);
> +	}
> +}
> +
>  int
>  xfs_dir2_free_read(
>  	struct xfs_trans	*tp,
> @@ -369,7 +393,7 @@ xfs_dir2_leaf_to_node(
>  		return error;
>  
>  	free = fbp->b_addr;
> -	dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +	xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
>  	leaf = lbp->b_addr;
>  	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
>  	if (be32_to_cpu(ltp->bestcount) >
> @@ -509,7 +533,7 @@ xfs_dir2_free_hdr_check(
>  {
>  	struct xfs_dir3_icfree_hdr hdr;
>  
> -	dp->d_ops->free_hdr_from_disk(&hdr, bp->b_addr);
> +	xfs_dir2_free_hdr_from_disk(dp->i_mount, &hdr, bp->b_addr);
>  
>  	ASSERT((hdr.firstdb %
>  		dp->d_ops->free_max_bests(dp->i_mount->m_dir_geo)) == 0);
> @@ -1117,7 +1141,7 @@ xfs_dir3_data_block_free(
>  	struct xfs_dir3_icfree_hdr freehdr;
>  	struct xfs_inode	*dp = args->dp;
>  
> -	dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +	xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
>  	bests = dp->d_ops->free_bests_p(free);
>  	if (hdr) {
>  		/*
> @@ -1286,7 +1310,8 @@ xfs_dir2_leafn_remove(
>  #ifdef DEBUG
>  	{
>  		struct xfs_dir3_icfree_hdr freehdr;
> -		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +
> +		xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
>  		ASSERT(freehdr.firstdb == dp->d_ops->free_max_bests(args->geo) *
>  			(fdb - xfs_dir2_byte_to_db(args->geo,
>  						   XFS_DIR2_FREE_OFFSET)));
> @@ -1680,7 +1705,7 @@ xfs_dir2_node_add_datablk(
>  			return error;
>  		free = fbp->b_addr;
>  		bests = dp->d_ops->free_bests_p(free);
> -		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +		xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
>  
>  		/* Remember the first slot as our empty slot. */
>  		freehdr.firstdb = (fbno - xfs_dir2_byte_to_db(args->geo,
> @@ -1689,7 +1714,7 @@ xfs_dir2_node_add_datablk(
>  	} else {
>  		free = fbp->b_addr;
>  		bests = dp->d_ops->free_bests_p(free);
> -		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +		xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
>  	}
>  
>  	/* Set the freespace block index from the data block number. */
> @@ -1758,7 +1783,8 @@ xfs_dir2_node_find_freeblk(
>  		if (findex >= 0) {
>  			/* caller already found the freespace for us. */
>  			bests = dp->d_ops->free_bests_p(free);
> -			dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +			xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr,
> +						    free);
>  
>  			ASSERT(findex < freehdr.nvalid);
>  			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
> @@ -1807,7 +1833,7 @@ xfs_dir2_node_find_freeblk(
>  
>  		free = fbp->b_addr;
>  		bests = dp->d_ops->free_bests_p(free);
> -		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +		xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
>  
>  		/* Scan the free entry array for a large enough free space. */
>  		for (findex = freehdr.nvalid - 1; findex >= 0; findex--) {
> @@ -2260,7 +2286,7 @@ xfs_dir2_node_trim_free(
>  	if (!bp)
>  		return 0;
>  	free = bp->b_addr;
> -	dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +	xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
>  
>  	/*
>  	 * If there are used entries, there's nothing to do.
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 07cea5751783..ef4a2b402e25 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -104,10 +104,11 @@ xfs_dir3_leaf_find_entry(struct xfs_dir3_icleaf_hdr *leafhdr,
>  extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
>  
>  extern xfs_failaddr_t xfs_dir3_leaf_check_int(struct xfs_mount *mp,
> -		struct xfs_inode *dp, struct xfs_dir3_icleaf_hdr *hdr,
> -		struct xfs_dir2_leaf *leaf);
> +		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_dir2_leaf *leaf);
>  
>  /* xfs_dir2_node.c */
> +void xfs_dir2_free_hdr_from_disk(struct xfs_mount *mp,
> +		struct xfs_dir3_icfree_hdr *to, struct xfs_dir2_free *from);
>  extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
>  		struct xfs_buf *lbp);
>  extern xfs_dahash_t xfs_dir2_leaf_lasthash(struct xfs_inode *dp,
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index e4e189d3c1c0..6b8d9a774ddf 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -601,7 +601,7 @@ xchk_directory_free_bestfree(
>  	}
>  
>  	/* Check all the entries. */
> -	sc->ip->d_ops->free_hdr_from_disk(&freehdr, bp->b_addr);
> +	xfs_dir2_free_hdr_from_disk(sc->ip->i_mount, &freehdr, bp->b_addr);
>  	bestp = sc->ip->d_ops->free_bests_p(bp->b_addr);
>  	for (i = 0; i < freehdr.nvalid; i++, bestp++) {
>  		best = be16_to_cpu(*bestp);
> -- 
> 2.20.1
> 

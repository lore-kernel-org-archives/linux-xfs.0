Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B70ABCA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FE5320869
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:00:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C65OFPQz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfKDUAz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:00:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60742 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbfKDUAz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:00:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4JxEpq080115;
        Mon, 4 Nov 2019 20:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=HI7aqJ8gEh1CqiFmK4qPQ0biUwrR5wlN6ELtyTG2ZiE=;
 b=C65OFPQzv0roJAi2x3M8mjrhmiHOvW96vqy069C64ApJEz6pXRSzAIlYm1fKhbF2mf5l
 RKlJNInri2F1/hrGRn0RvdzbJ0O7HRnPuU2omalOGBjNZQffc3Qu7wjD5QGdj4ZAgtv9
 VWK6Xw6GK3Mbca8D2XhQXDCHBMuZ0SnLJI+sxZqNy2roNvK14hl18kon6OQeViK5czaK
 TcVOE2SrPZz7U7FXkYigf/27RCP8j56OEsmf4fJP2Z+5bdCx7F2i7JKbImWKpANqJ2tk
 K2TajAGL5Aqtk7snjciibFeHQCl8Y5Io+kSlauU4gUD0cpYs7RZDztASJJTdTxtulWn7 zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w12er1ka1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:00:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4JwlVW025843;
        Mon, 4 Nov 2019 20:00:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w1kxmy50n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:00:50 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4K0mf1016227;
        Mon, 4 Nov 2019 20:00:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:00:48 -0800
Date:   Mon, 4 Nov 2019 12:00:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/34] xfs: devirtualize ->leaf_hdr_to_disk
Message-ID: <20191104200047.GI4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-9-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040191
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

On Fri, Nov 01, 2019 at 03:06:53PM -0700, Christoph Hellwig wrote:
> Replace the ->leaf_hdr_to_disk dir ops method with a directly called
> xfs_dir_leaf_hdr_to_disk helper that takes care of the differences
> between the v4 and v5 on-disk format.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c | 35 -------------------------------
>  fs/xfs/libxfs/xfs_dir2.h      |  2 --
>  fs/xfs/libxfs/xfs_dir2_leaf.c | 39 ++++++++++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_dir2_node.c | 12 +++++------
>  fs/xfs/libxfs/xfs_dir2_priv.h |  2 ++
>  5 files changed, 42 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index c848cab41be5..193708d12459 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -430,38 +430,6 @@ xfs_dir3_leaf_ents_p(struct xfs_dir2_leaf *lp)
>  	return ((struct xfs_dir3_leaf *)lp)->__ents;
>  }
>  
> -static void
> -xfs_dir2_leaf_hdr_to_disk(
> -	struct xfs_dir2_leaf		*to,
> -	struct xfs_dir3_icleaf_hdr	*from)
> -{
> -	ASSERT(from->magic == XFS_DIR2_LEAF1_MAGIC ||
> -	       from->magic == XFS_DIR2_LEAFN_MAGIC);
> -
> -	to->hdr.info.forw = cpu_to_be32(from->forw);
> -	to->hdr.info.back = cpu_to_be32(from->back);
> -	to->hdr.info.magic = cpu_to_be16(from->magic);
> -	to->hdr.count = cpu_to_be16(from->count);
> -	to->hdr.stale = cpu_to_be16(from->stale);
> -}
> -
> -static void
> -xfs_dir3_leaf_hdr_to_disk(
> -	struct xfs_dir2_leaf		*to,
> -	struct xfs_dir3_icleaf_hdr	*from)
> -{
> -	struct xfs_dir3_leaf_hdr *hdr3 = (struct xfs_dir3_leaf_hdr *)to;
> -
> -	ASSERT(from->magic == XFS_DIR3_LEAF1_MAGIC ||
> -	       from->magic == XFS_DIR3_LEAFN_MAGIC);
> -
> -	hdr3->info.hdr.forw = cpu_to_be32(from->forw);
> -	hdr3->info.hdr.back = cpu_to_be32(from->back);
> -	hdr3->info.hdr.magic = cpu_to_be16(from->magic);
> -	hdr3->count = cpu_to_be16(from->count);
> -	hdr3->stale = cpu_to_be16(from->stale);
> -}
> -
>  /*
>   * Directory free space block operations
>   */
> @@ -615,7 +583,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
>  	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
> -	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
>  	.leaf_max_ents = xfs_dir2_max_leaf_ents,
>  	.leaf_ents_p = xfs_dir2_leaf_ents_p,
>  
> @@ -659,7 +626,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
>  	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
> -	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
>  	.leaf_max_ents = xfs_dir2_max_leaf_ents,
>  	.leaf_ents_p = xfs_dir2_leaf_ents_p,
>  
> @@ -703,7 +669,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_unused_p = xfs_dir3_data_unused_p,
>  
>  	.leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr),
> -	.leaf_hdr_to_disk = xfs_dir3_leaf_hdr_to_disk,
>  	.leaf_max_ents = xfs_dir3_max_leaf_ents,
>  	.leaf_ents_p = xfs_dir3_leaf_ents_p,
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 74c592496bf0..15a1a72dc126 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -73,8 +73,6 @@ struct xfs_dir_ops {
>  		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
>  
>  	int	leaf_hdr_size;
> -	void	(*leaf_hdr_to_disk)(struct xfs_dir2_leaf *to,
> -				    struct xfs_dir3_icleaf_hdr *from);
>  	int	(*leaf_max_ents)(struct xfs_da_geometry *geo);
>  	struct xfs_dir2_leaf_entry *
>  		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 137ffd0a538b..56aae0b4cf89 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -59,6 +59,35 @@ xfs_dir2_leaf_hdr_from_disk(
>  	}
>  }
>  
> +void
> +xfs_dir2_leaf_hdr_to_disk(
> +	struct xfs_mount		*mp,
> +	struct xfs_dir2_leaf		*to,
> +	struct xfs_dir3_icleaf_hdr	*from)
> +{
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_dir3_leaf *to3 = (struct xfs_dir3_leaf *)to;
> +
> +		ASSERT(from->magic == XFS_DIR3_LEAF1_MAGIC ||
> +		       from->magic == XFS_DIR3_LEAFN_MAGIC);
> +
> +		to3->hdr.info.hdr.forw = cpu_to_be32(from->forw);
> +		to3->hdr.info.hdr.back = cpu_to_be32(from->back);
> +		to3->hdr.info.hdr.magic = cpu_to_be16(from->magic);
> +		to3->hdr.count = cpu_to_be16(from->count);
> +		to3->hdr.stale = cpu_to_be16(from->stale);
> +	} else {
> +		ASSERT(from->magic == XFS_DIR2_LEAF1_MAGIC ||
> +		       from->magic == XFS_DIR2_LEAFN_MAGIC);
> +
> +		to->hdr.info.forw = cpu_to_be32(from->forw);
> +		to->hdr.info.back = cpu_to_be32(from->back);
> +		to->hdr.info.magic = cpu_to_be16(from->magic);
> +		to->hdr.count = cpu_to_be16(from->count);
> +		to->hdr.stale = cpu_to_be16(from->stale);
> +	}
> +}
> +
>  /*
>   * Check the internal consistency of a leaf1 block.
>   * Pop an assert if something is wrong.
> @@ -413,7 +442,7 @@ xfs_dir2_block_to_leaf(
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
>  	leafhdr.count = be32_to_cpu(btp->count);
>  	leafhdr.stale = be32_to_cpu(btp->stale);
> -	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
> +	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
>  	xfs_dir3_leaf_log_header(args, lbp);
>  
>  	/*
> @@ -881,7 +910,7 @@ xfs_dir2_leaf_addname(
>  	/*
>  	 * Log the leaf fields and give up the buffers.
>  	 */
> -	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
> +	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
>  	xfs_dir3_leaf_log_header(args, lbp);
>  	xfs_dir3_leaf_log_ents(args, lbp, lfloglow, lfloghigh);
>  	xfs_dir3_leaf_check(dp, lbp);
> @@ -934,7 +963,7 @@ xfs_dir3_leaf_compact(
>  	leafhdr->count -= leafhdr->stale;
>  	leafhdr->stale = 0;
>  
> -	dp->d_ops->leaf_hdr_to_disk(leaf, leafhdr);
> +	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, leafhdr);
>  	xfs_dir3_leaf_log_header(args, bp);
>  	if (loglow != -1)
>  		xfs_dir3_leaf_log_ents(args, bp, loglow, to - 1);
> @@ -1384,7 +1413,7 @@ xfs_dir2_leaf_removename(
>  	 * We just mark the leaf entry stale by putting a null in it.
>  	 */
>  	leafhdr.stale++;
> -	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
> +	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
>  	xfs_dir3_leaf_log_header(args, lbp);
>  
>  	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
> @@ -1775,7 +1804,7 @@ xfs_dir2_node_to_leaf(
>  	memcpy(xfs_dir2_leaf_bests_p(ltp), dp->d_ops->free_bests_p(free),
>  		freehdr.nvalid * sizeof(xfs_dir2_data_off_t));
>  
> -	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
> +	xfs_dir2_leaf_hdr_to_disk(mp, leaf, &leafhdr);
>  	xfs_dir3_leaf_log_header(args, lbp);
>  	xfs_dir3_leaf_log_bests(args, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
>  	xfs_dir3_leaf_log_tail(args, lbp);
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 736a3ea2b92c..207ef9b4fe50 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -493,7 +493,7 @@ xfs_dir2_leafn_add(
>  	lep->address = cpu_to_be32(xfs_dir2_db_off_to_dataptr(args->geo,
>  				args->blkno, args->index));
>  
> -	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
> +	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
>  	xfs_dir3_leaf_log_header(args, bp);
>  	xfs_dir3_leaf_log_ents(args, bp, lfloglow, lfloghigh);
>  	xfs_dir3_leaf_check(dp, bp);
> @@ -1073,8 +1073,8 @@ xfs_dir2_leafn_rebalance(
>  	ASSERT(hdr1.stale + hdr2.stale == oldstale);
>  
>  	/* log the changes made when moving the entries */
> -	dp->d_ops->leaf_hdr_to_disk(leaf1, &hdr1);
> -	dp->d_ops->leaf_hdr_to_disk(leaf2, &hdr2);
> +	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf1, &hdr1);
> +	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf2, &hdr2);
>  	xfs_dir3_leaf_log_header(args, blk1->bp);
>  	xfs_dir3_leaf_log_header(args, blk2->bp);
>  
> @@ -1243,7 +1243,7 @@ xfs_dir2_leafn_remove(
>  	 * Log the leaf block changes.
>  	 */
>  	leafhdr.stale++;
> -	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
> +	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
>  	xfs_dir3_leaf_log_header(args, bp);
>  
>  	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
> @@ -1599,8 +1599,8 @@ xfs_dir2_leafn_unbalance(
>  	save_blk->hashval = be32_to_cpu(sents[savehdr.count - 1].hashval);
>  
>  	/* log the changes made when moving the entries */
> -	dp->d_ops->leaf_hdr_to_disk(save_leaf, &savehdr);
> -	dp->d_ops->leaf_hdr_to_disk(drop_leaf, &drophdr);
> +	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, save_leaf, &savehdr);
> +	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, drop_leaf, &drophdr);
>  	xfs_dir3_leaf_log_header(args, save_blk->bp);
>  	xfs_dir3_leaf_log_header(args, drop_blk->bp);
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 434bb60c718c..b402a2391f49 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -69,6 +69,8 @@ extern int xfs_dir3_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
>  /* xfs_dir2_leaf.c */
>  void xfs_dir2_leaf_hdr_from_disk(struct xfs_mount *mp,
>  		struct xfs_dir3_icleaf_hdr *to, struct xfs_dir2_leaf *from);
> +void xfs_dir2_leaf_hdr_to_disk(struct xfs_mount *mp, struct xfs_dir2_leaf *to,
> +		struct xfs_dir3_icleaf_hdr *from);
>  extern int xfs_dir3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
>  		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
>  extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
> -- 
> 2.20.1
> 

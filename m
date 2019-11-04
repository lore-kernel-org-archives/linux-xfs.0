Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B70CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 18:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7C422084D
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 18:40:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kCWoS1Tp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfKDSkG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 13:40:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35572 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbfKDSkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 13:40:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4Ia8K4035968;
        Mon, 4 Nov 2019 18:40:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=XRMNZ3Sgey32efNYH1LfgOPegWMz/upXXiQRqGVPjNQ=;
 b=kCWoS1TpcNbiPJkb2mrdx/ykAfrYj4VO6F8DCISPEAiaC/G7SdG9IdeSUQYodjV1C5KK
 7YsdmqY93PwHnlS4jXhzNv2vn7O+sV+22Ib+29FqhV1JN357K28CyK3rSID7CMENPvDB
 lDNFoCqJvtxWf1am2bVC2wkr1/zaztMwf3LtMCVGeFaWEr5So7oBuqAW5aMlFu7DQ83v
 Gj6mMboRlEVpWRcrL4sXJqhayfVkhsqKAdPtPf8jTIHLaK8X2hLuKpCFOkGNyQHIMKIf
 APmV/o1p/bkSSZIfVN6IYqA8yHboHhkotJ57ZAWoc5bUkHZD++9Hib1F8r9Z8noOpSu2 pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w117tsc72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 18:40:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4IdCOI038774;
        Mon, 4 Nov 2019 18:40:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w1kxdrgj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 18:40:01 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4Idxqj028313;
        Mon, 4 Nov 2019 18:39:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 10:39:59 -0800
Date:   Mon, 4 Nov 2019 10:39:58 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/34] xfs: devirtualize ->node_hdr_to_disk
Message-ID: <20191104183958.GE4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040180
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:06:49PM -0700, Christoph Hellwig wrote:
> Replace the ->node_hdr_to_disk dir ops method with a directly called
> xfs_da_node_hdr_to_disk helper that takes care of the v4 vs v5
> difference.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice substitution here too,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>  fs/xfs/libxfs/xfs_da_btree.c  | 39 ++++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_da_btree.h  |  2 ++
>  fs/xfs/libxfs/xfs_da_format.c | 34 ------------------------------
>  fs/xfs/libxfs/xfs_dir2.h      |  2 --
>  5 files changed, 35 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 131fef677896..1b0fbee21e14 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1196,7 +1196,7 @@ xfs_attr3_leaf_to_node(
>  	btree[0].hashval = entries[icleafhdr.count - 1].hashval;
>  	btree[0].before = cpu_to_be32(blkno);
>  	icnodehdr.count = 1;
> -	dp->d_ops->node_hdr_to_disk(node, &icnodehdr);
> +	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &icnodehdr);
>  	xfs_trans_log_buf(args->trans, bp1, 0, args->geo->blksize - 1);
>  	error = 0;
>  out:
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index f7ddc91ed099..462a245fdad7 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -135,6 +135,31 @@ xfs_da3_node_hdr_from_disk(
>  	}
>  }
>  
> +void
> +xfs_da3_node_hdr_to_disk(
> +	struct xfs_mount		*mp,
> +	struct xfs_da_intnode		*to,
> +	struct xfs_da3_icnode_hdr	*from)
> +{
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_da3_intnode	*to3 = (struct xfs_da3_intnode *)to;
> +
> +		ASSERT(from->magic == XFS_DA3_NODE_MAGIC);
> +		to3->hdr.info.hdr.forw = cpu_to_be32(from->forw);
> +		to3->hdr.info.hdr.back = cpu_to_be32(from->back);
> +		to3->hdr.info.hdr.magic = cpu_to_be16(from->magic);
> +		to3->hdr.__count = cpu_to_be16(from->count);
> +		to3->hdr.__level = cpu_to_be16(from->level);
> +	} else {
> +		ASSERT(from->magic == XFS_DA_NODE_MAGIC);
> +		to->hdr.info.forw = cpu_to_be32(from->forw);
> +		to->hdr.info.back = cpu_to_be32(from->back);
> +		to->hdr.info.magic = cpu_to_be16(from->magic);
> +		to->hdr.__count = cpu_to_be16(from->count);
> +		to->hdr.__level = cpu_to_be16(from->level);
> +	}
> +}
> +
>  /*
>   * Verify an xfs_da3_blkinfo structure. Note that the da3 fields are only
>   * accessible on v5 filesystems. This header format is common across da node,
> @@ -385,7 +410,7 @@ xfs_da3_node_create(
>  	}
>  	ichdr.level = level;
>  
> -	dp->d_ops->node_hdr_to_disk(node, &ichdr);
> +	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &ichdr);
>  	xfs_trans_log_buf(tp, bp,
>  		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
>  
> @@ -666,7 +691,7 @@ xfs_da3_root_split(
>  	btree[1].hashval = cpu_to_be32(blk2->hashval);
>  	btree[1].before = cpu_to_be32(blk2->blkno);
>  	nodehdr.count = 2;
> -	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
> +	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
>  
>  #ifdef DEBUG
>  	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
> @@ -891,11 +916,11 @@ xfs_da3_node_rebalance(
>  	/*
>  	 * Log header of node 1 and all current bits of node 2.
>  	 */
> -	dp->d_ops->node_hdr_to_disk(node1, &nodehdr1);
> +	xfs_da3_node_hdr_to_disk(dp->i_mount, node1, &nodehdr1);
>  	xfs_trans_log_buf(tp, blk1->bp,
>  		XFS_DA_LOGRANGE(node1, &node1->hdr, dp->d_ops->node_hdr_size));
>  
> -	dp->d_ops->node_hdr_to_disk(node2, &nodehdr2);
> +	xfs_da3_node_hdr_to_disk(dp->i_mount, node2, &nodehdr2);
>  	xfs_trans_log_buf(tp, blk2->bp,
>  		XFS_DA_LOGRANGE(node2, &node2->hdr,
>  				dp->d_ops->node_hdr_size +
> @@ -967,7 +992,7 @@ xfs_da3_node_add(
>  				tmp + sizeof(*btree)));
>  
>  	nodehdr.count += 1;
> -	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
> +	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
>  	xfs_trans_log_buf(state->args->trans, oldblk->bp,
>  		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
>  
> @@ -1403,7 +1428,7 @@ xfs_da3_node_remove(
>  	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
>  	    XFS_DA_LOGRANGE(node, &btree[index], sizeof(btree[index])));
>  	nodehdr.count -= 1;
> -	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
> +	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
>  	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
>  	    XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
>  
> @@ -1475,7 +1500,7 @@ xfs_da3_node_unbalance(
>  	memcpy(&save_btree[sindex], &drop_btree[0], tmp);
>  	save_hdr.count += drop_hdr.count;
>  
> -	dp->d_ops->node_hdr_to_disk(save_node, &save_hdr);
> +	xfs_da3_node_hdr_to_disk(dp->i_mount, save_node, &save_hdr);
>  	xfs_trans_log_buf(tp, save_blk->bp,
>  		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
>  				dp->d_ops->node_hdr_size));
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index eb15b9e76bc8..69ebf6a50d85 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -217,6 +217,8 @@ void xfs_da_state_free(xfs_da_state_t *state);
>  
>  void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
>  		struct xfs_da3_icnode_hdr *to, struct xfs_da_intnode *from);
> +void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
> +		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
>  
>  extern struct kmem_zone *xfs_da_state_zone;
>  extern const struct xfs_nameops xfs_default_nameops;
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 267aca857126..912096416a86 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -510,35 +510,6 @@ xfs_da3_node_tree_p(struct xfs_da_intnode *dap)
>  	return ((struct xfs_da3_intnode *)dap)->__btree;
>  }
>  
> -static void
> -xfs_da2_node_hdr_to_disk(
> -	struct xfs_da_intnode		*to,
> -	struct xfs_da3_icnode_hdr	*from)
> -{
> -	ASSERT(from->magic == XFS_DA_NODE_MAGIC);
> -	to->hdr.info.forw = cpu_to_be32(from->forw);
> -	to->hdr.info.back = cpu_to_be32(from->back);
> -	to->hdr.info.magic = cpu_to_be16(from->magic);
> -	to->hdr.__count = cpu_to_be16(from->count);
> -	to->hdr.__level = cpu_to_be16(from->level);
> -}
> -
> -static void
> -xfs_da3_node_hdr_to_disk(
> -	struct xfs_da_intnode		*to,
> -	struct xfs_da3_icnode_hdr	*from)
> -{
> -	struct xfs_da3_node_hdr *hdr3 = (struct xfs_da3_node_hdr *)to;
> -
> -	ASSERT(from->magic == XFS_DA3_NODE_MAGIC);
> -	hdr3->info.hdr.forw = cpu_to_be32(from->forw);
> -	hdr3->info.hdr.back = cpu_to_be32(from->back);
> -	hdr3->info.hdr.magic = cpu_to_be16(from->magic);
> -	hdr3->__count = cpu_to_be16(from->count);
> -	hdr3->__level = cpu_to_be16(from->level);
> -}
> -
> -
>  /*
>   * Directory free space block operations
>   */
> @@ -698,7 +669,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.leaf_ents_p = xfs_dir2_leaf_ents_p,
>  
>  	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
> -	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
>  	.node_tree_p = xfs_da2_node_tree_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
> @@ -747,7 +717,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.leaf_ents_p = xfs_dir2_leaf_ents_p,
>  
>  	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
> -	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
>  	.node_tree_p = xfs_da2_node_tree_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
> @@ -796,7 +765,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.leaf_ents_p = xfs_dir3_leaf_ents_p,
>  
>  	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
> -	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
>  	.node_tree_p = xfs_da3_node_tree_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
> @@ -810,13 +778,11 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  
>  static const struct xfs_dir_ops xfs_dir2_nondir_ops = {
>  	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
> -	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
>  	.node_tree_p = xfs_da2_node_tree_p,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir3_nondir_ops = {
>  	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
> -	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
>  	.node_tree_p = xfs_da3_node_tree_p,
>  };
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 573043f59c85..c16efeae0f2b 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -82,8 +82,6 @@ struct xfs_dir_ops {
>  		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
>  
>  	int	node_hdr_size;
> -	void	(*node_hdr_to_disk)(struct xfs_da_intnode *to,
> -				    struct xfs_da3_icnode_hdr *from);
>  	struct xfs_da_node_entry *
>  		(*node_tree_p)(struct xfs_da_intnode *dap);
>  
> -- 
> 2.20.1
> 

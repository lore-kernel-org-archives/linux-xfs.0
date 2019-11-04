Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0159CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 18:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B16B2089C
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 18:37:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z9VjTrQn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbfKDSha (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 13:37:30 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54090 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDSha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 13:37:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4IZ36j008263;
        Mon, 4 Nov 2019 18:37:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Mx+OA72WNpuWp2QX6Pr4J1aqQ3E91tsxIvxcmHxheJI=;
 b=Z9VjTrQn5RENj3YmStUhKU/OMU9JP7HPb+0lnC6xDbCLBSyywNvf6nmm8cSdrkTF4hkY
 v/+WcARqiWcfrSJkofmVm1U+y4j120eYyKezbmPlXNQlEPDHokfVTyyhpgfQ6P1IhtAv
 yPbFcNtox1zYI2m/Z+k7Fk7tapL3LQ50dVezi5x3es3294Agw39n/lQSiLRFNm3rAiyG
 JEv4Fzq53ih+RLUMBgoNBvOjdGUM3g2/SxS4jSbZfEmatpoGRkbDEAIG6i6COLrpI3hM
 UL76gR15EbUeUSKgE36efOCCf5c1xlE7lHfXHS5lM0BvR9YXRBdE0dPtqCXDOpeYJAD1 zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w12er14su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 18:37:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4IIRhU155375;
        Mon, 4 Nov 2019 18:37:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w1kxmucwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 18:37:25 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4IbNl3008350;
        Mon, 4 Nov 2019 18:37:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 10:37:23 -0800
Date:   Mon, 4 Nov 2019 10:37:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/34] xfs: devirtualize ->node_hdr_from_disk
Message-ID: <20191104183722.GD4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040179
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

On Fri, Nov 01, 2019 at 03:06:48PM -0700, Christoph Hellwig wrote:
> Replace the ->node_hdr_from_disk dir ops method with a directly called
> xfs_da_node_hdr_from_disk helper that takes care of the v4 vs v5
> difference.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems like a nice cleanup,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>  fs/xfs/libxfs/xfs_da_btree.c  | 84 ++++++++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_da_btree.h  |  3 ++
>  fs/xfs/libxfs/xfs_da_format.c | 33 --------------
>  fs/xfs/libxfs/xfs_dir2.h      |  2 -
>  fs/xfs/scrub/dabtree.c        |  2 +-
>  fs/xfs/xfs_attr_inactive.c    |  2 +-
>  fs/xfs/xfs_attr_list.c        |  2 +-
>  8 files changed, 60 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 56e62b3d9bb7..131fef677896 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1185,7 +1185,7 @@ xfs_attr3_leaf_to_node(
>  	if (error)
>  		goto out;
>  	node = bp1->b_addr;
> -	dp->d_ops->node_hdr_from_disk(&icnodehdr, node);
> +	xfs_da3_node_hdr_from_disk(mp, &icnodehdr, node);
>  	btree = dp->d_ops->node_tree_p(node);
>  
>  	leaf = bp2->b_addr;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 4fd1223c1bd5..f7ddc91ed099 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -110,6 +110,31 @@ xfs_da_state_free(xfs_da_state_t *state)
>  	kmem_zone_free(xfs_da_state_zone, state);
>  }
>  
> +void
> +xfs_da3_node_hdr_from_disk(
> +	struct xfs_mount		*mp,
> +	struct xfs_da3_icnode_hdr	*to,
> +	struct xfs_da_intnode		*from)
> +{
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_da3_intnode	*from3 = (struct xfs_da3_intnode *)from;
> +
> +		to->forw = be32_to_cpu(from3->hdr.info.hdr.forw);
> +		to->back = be32_to_cpu(from3->hdr.info.hdr.back);
> +		to->magic = be16_to_cpu(from3->hdr.info.hdr.magic);
> +		to->count = be16_to_cpu(from3->hdr.__count);
> +		to->level = be16_to_cpu(from3->hdr.__level);
> +		ASSERT(to->magic == XFS_DA3_NODE_MAGIC);
> +	} else {
> +		to->forw = be32_to_cpu(from->hdr.info.forw);
> +		to->back = be32_to_cpu(from->hdr.info.back);
> +		to->magic = be16_to_cpu(from->hdr.info.magic);
> +		to->count = be16_to_cpu(from->hdr.__count);
> +		to->level = be16_to_cpu(from->hdr.__level);
> +		ASSERT(to->magic == XFS_DA_NODE_MAGIC);
> +	}
> +}
> +
>  /*
>   * Verify an xfs_da3_blkinfo structure. Note that the da3 fields are only
>   * accessible on v5 filesystems. This header format is common across da node,
> @@ -145,12 +170,9 @@ xfs_da3_node_verify(
>  	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_da_intnode	*hdr = bp->b_addr;
>  	struct xfs_da3_icnode_hdr ichdr;
> -	const struct xfs_dir_ops *ops;
>  	xfs_failaddr_t		fa;
>  
> -	ops = xfs_dir_get_ops(mp, NULL);
> -
> -	ops->node_hdr_from_disk(&ichdr, hdr);
> +	xfs_da3_node_hdr_from_disk(mp, &ichdr, hdr);
>  
>  	fa = xfs_da3_blkinfo_verify(bp, bp->b_addr);
>  	if (fa)
> @@ -577,7 +599,7 @@ xfs_da3_root_split(
>  	    oldroot->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC)) {
>  		struct xfs_da3_icnode_hdr icnodehdr;
>  
> -		dp->d_ops->node_hdr_from_disk(&icnodehdr, oldroot);
> +		xfs_da3_node_hdr_from_disk(dp->i_mount, &icnodehdr, oldroot);
>  		btree = dp->d_ops->node_tree_p(oldroot);
>  		size = (int)((char *)&btree[icnodehdr.count] - (char *)oldroot);
>  		level = icnodehdr.level;
> @@ -637,7 +659,7 @@ xfs_da3_root_split(
>  		return error;
>  
>  	node = bp->b_addr;
> -	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
>  	btree = dp->d_ops->node_tree_p(node);
>  	btree[0].hashval = cpu_to_be32(blk1->hashval);
>  	btree[0].before = cpu_to_be32(blk1->blkno);
> @@ -686,7 +708,7 @@ xfs_da3_node_split(
>  	trace_xfs_da_node_split(state->args);
>  
>  	node = oldblk->bp->b_addr;
> -	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
>  
>  	/*
>  	 * With V2 dirs the extra block is data or freespace.
> @@ -733,7 +755,7 @@ xfs_da3_node_split(
>  	 * If we had double-split op below us, then add the extra block too.
>  	 */
>  	node = oldblk->bp->b_addr;
> -	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
>  	if (oldblk->index <= nodehdr.count) {
>  		oldblk->index++;
>  		xfs_da3_node_add(state, oldblk, addblk);
> @@ -788,8 +810,8 @@ xfs_da3_node_rebalance(
>  
>  	node1 = blk1->bp->b_addr;
>  	node2 = blk2->bp->b_addr;
> -	dp->d_ops->node_hdr_from_disk(&nodehdr1, node1);
> -	dp->d_ops->node_hdr_from_disk(&nodehdr2, node2);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr1, node1);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr2, node2);
>  	btree1 = dp->d_ops->node_tree_p(node1);
>  	btree2 = dp->d_ops->node_tree_p(node2);
>  
> @@ -804,8 +826,8 @@ xfs_da3_node_rebalance(
>  		tmpnode = node1;
>  		node1 = node2;
>  		node2 = tmpnode;
> -		dp->d_ops->node_hdr_from_disk(&nodehdr1, node1);
> -		dp->d_ops->node_hdr_from_disk(&nodehdr2, node2);
> +		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr1, node1);
> +		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr2, node2);
>  		btree1 = dp->d_ops->node_tree_p(node1);
>  		btree2 = dp->d_ops->node_tree_p(node2);
>  		swap = 1;
> @@ -886,8 +908,8 @@ xfs_da3_node_rebalance(
>  	if (swap) {
>  		node1 = blk1->bp->b_addr;
>  		node2 = blk2->bp->b_addr;
> -		dp->d_ops->node_hdr_from_disk(&nodehdr1, node1);
> -		dp->d_ops->node_hdr_from_disk(&nodehdr2, node2);
> +		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr1, node1);
> +		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr2, node2);
>  		btree1 = dp->d_ops->node_tree_p(node1);
>  		btree2 = dp->d_ops->node_tree_p(node2);
>  	}
> @@ -921,7 +943,7 @@ xfs_da3_node_add(
>  	trace_xfs_da_node_add(state->args);
>  
>  	node = oldblk->bp->b_addr;
> -	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
>  	btree = dp->d_ops->node_tree_p(node);
>  
>  	ASSERT(oldblk->index >= 0 && oldblk->index <= nodehdr.count);
> @@ -1092,7 +1114,7 @@ xfs_da3_root_join(
>  
>  	args = state->args;
>  	oldroot = root_blk->bp->b_addr;
> -	dp->d_ops->node_hdr_from_disk(&oldroothdr, oldroot);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &oldroothdr, oldroot);
>  	ASSERT(oldroothdr.forw == 0);
>  	ASSERT(oldroothdr.back == 0);
>  
> @@ -1172,7 +1194,7 @@ xfs_da3_node_toosmall(
>  	blk = &state->path.blk[ state->path.active-1 ];
>  	info = blk->bp->b_addr;
>  	node = (xfs_da_intnode_t *)info;
> -	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
>  	if (nodehdr.count > (state->args->geo->node_ents >> 1)) {
>  		*action = 0;	/* blk over 50%, don't try to join */
>  		return 0;	/* blk over 50%, don't try to join */
> @@ -1230,7 +1252,7 @@ xfs_da3_node_toosmall(
>  			return error;
>  
>  		node = bp->b_addr;
> -		dp->d_ops->node_hdr_from_disk(&thdr, node);
> +		xfs_da3_node_hdr_from_disk(dp->i_mount, &thdr, node);
>  		xfs_trans_brelse(state->args->trans, bp);
>  
>  		if (count - thdr.count >= 0)
> @@ -1277,7 +1299,7 @@ xfs_da3_node_lasthash(
>  	struct xfs_da3_icnode_hdr nodehdr;
>  
>  	node = bp->b_addr;
> -	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
>  	if (count)
>  		*count = nodehdr.count;
>  	if (!nodehdr.count)
> @@ -1328,7 +1350,7 @@ xfs_da3_fixhashpath(
>  		struct xfs_da3_icnode_hdr nodehdr;
>  
>  		node = blk->bp->b_addr;
> -		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> +		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
>  		btree = dp->d_ops->node_tree_p(node);
>  		if (be32_to_cpu(btree[blk->index].hashval) == lasthash)
>  			break;
> @@ -1360,7 +1382,7 @@ xfs_da3_node_remove(
>  	trace_xfs_da_node_remove(state->args);
>  
>  	node = drop_blk->bp->b_addr;
> -	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
>  	ASSERT(drop_blk->index < nodehdr.count);
>  	ASSERT(drop_blk->index >= 0);
>  
> @@ -1416,8 +1438,8 @@ xfs_da3_node_unbalance(
>  
>  	drop_node = drop_blk->bp->b_addr;
>  	save_node = save_blk->bp->b_addr;
> -	dp->d_ops->node_hdr_from_disk(&drop_hdr, drop_node);
> -	dp->d_ops->node_hdr_from_disk(&save_hdr, save_node);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &drop_hdr, drop_node);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &save_hdr, save_node);
>  	drop_btree = dp->d_ops->node_tree_p(drop_node);
>  	save_btree = dp->d_ops->node_tree_p(save_node);
>  	tp = state->args->trans;
> @@ -1550,7 +1572,7 @@ xfs_da3_node_lookup_int(
>  		 * Search an intermediate node for a match.
>  		 */
>  		node = blk->bp->b_addr;
> -		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> +		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
>  		btree = dp->d_ops->node_tree_p(node);
>  
>  		/* Tree taller than we can handle; bail out! */
> @@ -1678,8 +1700,8 @@ xfs_da3_node_order(
>  
>  	node1 = node1_bp->b_addr;
>  	node2 = node2_bp->b_addr;
> -	dp->d_ops->node_hdr_from_disk(&node1hdr, node1);
> -	dp->d_ops->node_hdr_from_disk(&node2hdr, node2);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &node1hdr, node1);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &node2hdr, node2);
>  	btree1 = dp->d_ops->node_tree_p(node1);
>  	btree2 = dp->d_ops->node_tree_p(node2);
>  
> @@ -1902,7 +1924,7 @@ xfs_da3_path_shift(
>  	level = (path->active-1) - 1;	/* skip bottom layer in path */
>  	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
>  		node = blk->bp->b_addr;
> -		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> +		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
>  		btree = dp->d_ops->node_tree_p(node);
>  
>  		if (forward && (blk->index < nodehdr.count - 1)) {
> @@ -1963,7 +1985,7 @@ xfs_da3_path_shift(
>  		case XFS_DA3_NODE_MAGIC:
>  			blk->magic = XFS_DA_NODE_MAGIC;
>  			node = (xfs_da_intnode_t *)info;
> -			dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> +			xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
>  			btree = dp->d_ops->node_tree_p(node);
>  			blk->hashval = be32_to_cpu(btree[nodehdr.count - 1].hashval);
>  			if (forward)
> @@ -2248,7 +2270,7 @@ xfs_da3_swap_lastblock(
>  		struct xfs_da3_icnode_hdr deadhdr;
>  
>  		dead_node = (xfs_da_intnode_t *)dead_info;
> -		dp->d_ops->node_hdr_from_disk(&deadhdr, dead_node);
> +		xfs_da3_node_hdr_from_disk(dp->i_mount, &deadhdr, dead_node);
>  		btree = dp->d_ops->node_tree_p(dead_node);
>  		dead_level = deadhdr.level;
>  		dead_hash = be32_to_cpu(btree[deadhdr.count - 1].hashval);
> @@ -2308,7 +2330,7 @@ xfs_da3_swap_lastblock(
>  		if (error)
>  			goto done;
>  		par_node = par_buf->b_addr;
> -		dp->d_ops->node_hdr_from_disk(&par_hdr, par_node);
> +		xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
>  		if (level >= 0 && level != par_hdr.level + 1) {
>  			XFS_ERROR_REPORT("xfs_da_swap_lastblock(4)",
>  					 XFS_ERRLEVEL_LOW, mp);
> @@ -2359,7 +2381,7 @@ xfs_da3_swap_lastblock(
>  		if (error)
>  			goto done;
>  		par_node = par_buf->b_addr;
> -		dp->d_ops->node_hdr_from_disk(&par_hdr, par_node);
> +		xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
>  		if (par_hdr.level != level) {
>  			XFS_ERROR_REPORT("xfs_da_swap_lastblock(7)",
>  					 XFS_ERRLEVEL_LOW, mp);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 02f7a21ab3a5..eb15b9e76bc8 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -215,6 +215,9 @@ enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
>  xfs_da_state_t *xfs_da_state_alloc(void);
>  void xfs_da_state_free(xfs_da_state_t *state);
>  
> +void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
> +		struct xfs_da3_icnode_hdr *to, struct xfs_da_intnode *from);
> +
>  extern struct kmem_zone *xfs_da_state_zone;
>  extern const struct xfs_nameops xfs_default_nameops;
>  
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 31bb250c1899..267aca857126 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -510,19 +510,6 @@ xfs_da3_node_tree_p(struct xfs_da_intnode *dap)
>  	return ((struct xfs_da3_intnode *)dap)->__btree;
>  }
>  
> -static void
> -xfs_da2_node_hdr_from_disk(
> -	struct xfs_da3_icnode_hdr	*to,
> -	struct xfs_da_intnode		*from)
> -{
> -	ASSERT(from->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
> -	to->forw = be32_to_cpu(from->hdr.info.forw);
> -	to->back = be32_to_cpu(from->hdr.info.back);
> -	to->magic = be16_to_cpu(from->hdr.info.magic);
> -	to->count = be16_to_cpu(from->hdr.__count);
> -	to->level = be16_to_cpu(from->hdr.__level);
> -}
> -
>  static void
>  xfs_da2_node_hdr_to_disk(
>  	struct xfs_da_intnode		*to,
> @@ -536,21 +523,6 @@ xfs_da2_node_hdr_to_disk(
>  	to->hdr.__level = cpu_to_be16(from->level);
>  }
>  
> -static void
> -xfs_da3_node_hdr_from_disk(
> -	struct xfs_da3_icnode_hdr	*to,
> -	struct xfs_da_intnode		*from)
> -{
> -	struct xfs_da3_node_hdr *hdr3 = (struct xfs_da3_node_hdr *)from;
> -
> -	ASSERT(from->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC));
> -	to->forw = be32_to_cpu(hdr3->info.hdr.forw);
> -	to->back = be32_to_cpu(hdr3->info.hdr.back);
> -	to->magic = be16_to_cpu(hdr3->info.hdr.magic);
> -	to->count = be16_to_cpu(hdr3->__count);
> -	to->level = be16_to_cpu(hdr3->__level);
> -}
> -
>  static void
>  xfs_da3_node_hdr_to_disk(
>  	struct xfs_da_intnode		*to,
> @@ -727,7 +699,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  
>  	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
>  	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
> -	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
>  	.node_tree_p = xfs_da2_node_tree_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
> @@ -777,7 +748,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  
>  	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
>  	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
> -	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
>  	.node_tree_p = xfs_da2_node_tree_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
> @@ -827,7 +797,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  
>  	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
>  	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
> -	.node_hdr_from_disk = xfs_da3_node_hdr_from_disk,
>  	.node_tree_p = xfs_da3_node_tree_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
> @@ -842,14 +811,12 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  static const struct xfs_dir_ops xfs_dir2_nondir_ops = {
>  	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
>  	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
> -	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
>  	.node_tree_p = xfs_da2_node_tree_p,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir3_nondir_ops = {
>  	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
>  	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
> -	.node_hdr_from_disk = xfs_da3_node_hdr_from_disk,
>  	.node_tree_p = xfs_da3_node_tree_p,
>  };
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index e170792c0acc..573043f59c85 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -84,8 +84,6 @@ struct xfs_dir_ops {
>  	int	node_hdr_size;
>  	void	(*node_hdr_to_disk)(struct xfs_da_intnode *to,
>  				    struct xfs_da3_icnode_hdr *from);
> -	void	(*node_hdr_from_disk)(struct xfs_da3_icnode_hdr *to,
> -				      struct xfs_da_intnode *from);
>  	struct xfs_da_node_entry *
>  		(*node_tree_p)(struct xfs_da_intnode *dap);
>  
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index d1248c223c7f..be19a48716b7 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -410,7 +410,7 @@ xchk_da_btree_block(
>  				XFS_BLFT_DA_NODE_BUF);
>  		blk->magic = XFS_DA_NODE_MAGIC;
>  		node = blk->bp->b_addr;
> -		ip->d_ops->node_hdr_from_disk(&nodehdr, node);
> +		xfs_da3_node_hdr_from_disk(ip->i_mount, &nodehdr, node);
>  		btree = ip->d_ops->node_tree_p(node);
>  		*pmaxrecs = nodehdr.count;
>  		blk->hashval = be32_to_cpu(btree[*pmaxrecs - 1].hashval);
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index f83f11d929e4..c1ce06ccfab0 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -213,7 +213,7 @@ xfs_attr3_node_inactive(
>  	}
>  
>  	node = bp->b_addr;
> -	dp->d_ops->node_hdr_from_disk(&ichdr, node);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &ichdr, node);
>  	parent_blkno = bp->b_bn;
>  	if (!ichdr.count) {
>  		xfs_trans_brelse(*trans, bp);
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index c02f22d50e45..5b5a3772ed24 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -240,7 +240,7 @@ xfs_attr_node_list_lookup(
>  			goto out_corruptbuf;
>  		}
>  
> -		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> +		xfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
>  
>  		/* Tree taller than we can handle; bail out! */
>  		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
> -- 
> 2.20.1
> 

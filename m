Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C495CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 19:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E749E2089C
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 19:52:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YfdzmKjf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfKDTwl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 14:52:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47420 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbfKDTwl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 14:52:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4JnKXT088037;
        Mon, 4 Nov 2019 19:52:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=fYAY1amalOpYCUUZ8mPg+f5Tqm8lDWwEWIntAc8jz/8=;
 b=YfdzmKjfGVh71vynscqDMRi1If75/ATfllX5ZtUFZuGLT3n1K+ja5PEydacc3hCVuIw5
 efNWOMm9G3uCO2OCLlSpqwHnQC/9sq+zE0znRybi0AeBRNXLuIKugsxUf/FqY1jak1fw
 71Ad3u08s21qmUN39cYBS4chu99pBTma2D6wfiBhO7+Zx1pgrI8cnCs+B/pCgeTyCuDK
 JO8acsbvuioBskSXH4Kryn0LRm22Cal8bEANv5ShhE7Jo4uR1b0jwlfL7ZAACYF6NG7E
 CHfcv36ayoRifz+H+VFWtlfpOeunFMm7/Emj/cen5pQMdzIt0Qk8LrmENqR/CvX5PjcF Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w11rpsqk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 19:52:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4JivFN145257;
        Mon, 4 Nov 2019 19:52:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w1k8vdbrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 19:52:36 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4JqZQJ015226;
        Mon, 4 Nov 2019 19:52:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 11:52:35 -0800
Date:   Mon, 4 Nov 2019 11:52:33 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/34] xfs: add a btree entries pointer to struct
 xfs_da3_icnode_hdr
Message-ID: <20191104195233.GF4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040189
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040190
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:06:50PM -0700, Christoph Hellwig wrote:
> All but two callers of the ->node_tree_p dir operation already have a
> xfs_da3_icnode_hdr from a previous call to xfs_da3_node_hdr_from_disk at
> hand.  Add a pointer to the btree entries to struct xfs_da3_icnode_hdr
> to clean up this pattern.  The two remaining callers now expand the
> whole header as well, but that isn't very expensive and not in a super
> hot path anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |  6 ++--
>  fs/xfs/libxfs/xfs_da_btree.c  | 68 ++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_da_btree.h  |  1 +
>  fs/xfs/libxfs/xfs_da_format.c | 21 -----------
>  fs/xfs/libxfs/xfs_dir2.h      |  2 --
>  fs/xfs/scrub/dabtree.c        |  6 ++--
>  fs/xfs/xfs_attr_inactive.c    | 34 +++++++++---------
>  fs/xfs/xfs_attr_list.c        |  2 +-
>  8 files changed, 55 insertions(+), 85 deletions(-)
> 

<snip>

> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 69ebf6a50d85..63ed45057fa5 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -135,6 +135,7 @@ struct xfs_da3_icnode_hdr {
>  	uint16_t		magic;
>  	uint16_t		count;
>  	uint16_t		level;
> +	struct xfs_da_node_entry *btree;

This adds to the incore node header structure a pointer to raw disk
structures, right?  Can we make this a little more explicit by naming
the field "raw_entries" or something?

--D

>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 912096416a86..f896d37c845f 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -494,22 +494,6 @@ xfs_dir3_leaf_hdr_to_disk(
>  	hdr3->stale = cpu_to_be16(from->stale);
>  }
>  
> -
> -/*
> - * Directory/Attribute Node block operations
> - */
> -static struct xfs_da_node_entry *
> -xfs_da2_node_tree_p(struct xfs_da_intnode *dap)
> -{
> -	return dap->__btree;
> -}
> -
> -static struct xfs_da_node_entry *
> -xfs_da3_node_tree_p(struct xfs_da_intnode *dap)
> -{
> -	return ((struct xfs_da3_intnode *)dap)->__btree;
> -}
> -
>  /*
>   * Directory free space block operations
>   */
> @@ -669,7 +653,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.leaf_ents_p = xfs_dir2_leaf_ents_p,
>  
>  	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
> -	.node_tree_p = xfs_da2_node_tree_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
> @@ -717,7 +700,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.leaf_ents_p = xfs_dir2_leaf_ents_p,
>  
>  	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
> -	.node_tree_p = xfs_da2_node_tree_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
> @@ -765,7 +747,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.leaf_ents_p = xfs_dir3_leaf_ents_p,
>  
>  	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
> -	.node_tree_p = xfs_da3_node_tree_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
>  	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
> @@ -778,12 +759,10 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  
>  static const struct xfs_dir_ops xfs_dir2_nondir_ops = {
>  	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
> -	.node_tree_p = xfs_da2_node_tree_p,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir3_nondir_ops = {
>  	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
> -	.node_tree_p = xfs_da3_node_tree_p,
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index c16efeae0f2b..6eee4c1b20da 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -82,8 +82,6 @@ struct xfs_dir_ops {
>  		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
>  
>  	int	node_hdr_size;
> -	struct xfs_da_node_entry *
> -		(*node_tree_p)(struct xfs_da_intnode *dap);
>  
>  	int	free_hdr_size;
>  	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index be19a48716b7..52aa69743dfa 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -83,10 +83,12 @@ xchk_da_btree_node_entry(
>  	int				level)
>  {
>  	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
> +	struct xfs_da3_icnode_hdr	hdr;
>  
>  	ASSERT(blk->magic == XFS_DA_NODE_MAGIC);
>  
> -	return (void *)ds->dargs.dp->d_ops->node_tree_p(blk->bp->b_addr) +
> +	xfs_da3_node_hdr_from_disk(ds->sc->mp, &hdr, blk->bp->b_addr);
> +	return (void *)hdr.btree +
>  		(blk->index * sizeof(struct xfs_da_node_entry));
>  }
>  
> @@ -411,7 +413,7 @@ xchk_da_btree_block(
>  		blk->magic = XFS_DA_NODE_MAGIC;
>  		node = blk->bp->b_addr;
>  		xfs_da3_node_hdr_from_disk(ip->i_mount, &nodehdr, node);
> -		btree = ip->d_ops->node_tree_p(node);
> +		btree = nodehdr.btree;
>  		*pmaxrecs = nodehdr.count;
>  		blk->hashval = be32_to_cpu(btree[*pmaxrecs - 1].hashval);
>  		if (level == 0) {
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index c1ce06ccfab0..f6d8967f0a8e 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -190,19 +190,17 @@ xfs_attr3_leaf_inactive(
>   */
>  STATIC int
>  xfs_attr3_node_inactive(
> -	struct xfs_trans **trans,
> -	struct xfs_inode *dp,
> -	struct xfs_buf	*bp,
> -	int		level)
> +	struct xfs_trans	**trans,
> +	struct xfs_inode	*dp,
> +	struct xfs_buf		*bp,
> +	int			level)
>  {
> -	xfs_da_blkinfo_t *info;
> -	xfs_da_intnode_t *node;
> -	xfs_dablk_t child_fsb;
> -	xfs_daddr_t parent_blkno, child_blkno;
> -	int error, i;
> -	struct xfs_buf *child_bp;
> -	struct xfs_da_node_entry *btree;
> +	struct xfs_da_blkinfo	*info;
> +	xfs_dablk_t		child_fsb;
> +	xfs_daddr_t		parent_blkno, child_blkno;
> +	struct xfs_buf		*child_bp;
>  	struct xfs_da3_icnode_hdr ichdr;
> +	int			error, i;
>  
>  	/*
>  	 * Since this code is recursive (gasp!) we must protect ourselves.
> @@ -212,15 +210,13 @@ xfs_attr3_node_inactive(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	node = bp->b_addr;
> -	xfs_da3_node_hdr_from_disk(dp->i_mount, &ichdr, node);
> +	xfs_da3_node_hdr_from_disk(dp->i_mount, &ichdr, bp->b_addr);
>  	parent_blkno = bp->b_bn;
>  	if (!ichdr.count) {
>  		xfs_trans_brelse(*trans, bp);
>  		return 0;
>  	}
> -	btree = dp->d_ops->node_tree_p(node);
> -	child_fsb = be32_to_cpu(btree[0].before);
> +	child_fsb = be32_to_cpu(ichdr.btree[0].before);
>  	xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
>  
>  	/*
> @@ -279,13 +275,15 @@ xfs_attr3_node_inactive(
>  		 * child block number.
>  		 */
>  		if (i + 1 < ichdr.count) {
> +			struct xfs_da3_icnode_hdr phdr;
> +
>  			error = xfs_da3_node_read(*trans, dp, 0, parent_blkno,
>  						 &bp, XFS_ATTR_FORK);
>  			if (error)
>  				return error;
> -			node = bp->b_addr;
> -			btree = dp->d_ops->node_tree_p(node);
> -			child_fsb = be32_to_cpu(btree[i + 1].before);
> +			xfs_da3_node_hdr_from_disk(dp->i_mount, &phdr,
> +						  bp->b_addr);
> +			child_fsb = be32_to_cpu(phdr.btree[i + 1].before);
>  			xfs_trans_brelse(*trans, bp);
>  		}
>  		/*
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 5b5a3772ed24..032920952aa2 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -254,7 +254,7 @@ xfs_attr_node_list_lookup(
>  		else
>  			expected_level--;
>  
> -		btree = dp->d_ops->node_tree_p(node);
> +		btree = nodehdr.btree;
>  		for (i = 0; i < nodehdr.count; btree++, i++) {
>  			if (cursor->hashval <= be32_to_cpu(btree->hashval)) {
>  				cursor->blkno = be32_to_cpu(btree->before);
> -- 
> 2.20.1
> 

Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02264C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B828222311
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:24:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TT9HesPN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfKRVYw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 16:24:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34396 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfKRVYv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 16:24:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILDt2w177730;
        Mon, 18 Nov 2019 21:24:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=6ER9AktOtG2BAJEX/5JhG/3qL8+Jdwp8uY7RJ2QGAu0=;
 b=TT9HesPN14i62AIW0+1IR5icajZgtpVY97uxve+ic0BAuj1ecRaM5Pjrq5dhjTzVVAYH
 wDaWSeB1I14GudVe/12qb0IKGRTthtcGTHOY1KKmiQ8YtisuHrf42RI4xb/GUg7BL7Gy
 DATRxTWt54E8dtihmJnFnTD6whNkXrEEOe31nsCtmDo1CYTJQ4QPXd62FNvKOEEpzvO+
 edSLxCSMcfxKaOsKtCILbruKdulnPkfh/w0EBzQQto3Vg0Zin69YT/716JBbucrfXxu7
 3sgc5CxpRHHPiTP54G+4jp1kcK2c1TMxTAnd5QI8rgWC7C6/gTrHi7Tnd7Slz1gbPVx3 Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wa8htk1vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:24:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILE24j162747;
        Mon, 18 Nov 2019 21:24:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wc0af8340-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:24:47 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAILOkSN005714;
        Mon, 18 Nov 2019 21:24:46 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 13:24:46 -0800
Date:   Mon, 18 Nov 2019 13:24:44 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 7/9] xfs: split xfs_da3_node_read
Message-ID: <20191118212444.GC6219@magnolia>
References: <20191116182214.23711-1-hch@lst.de>
 <20191116182214.23711-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116182214.23711-8-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911180184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911180184
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 16, 2019 at 07:22:12PM +0100, Christoph Hellwig wrote:
> Split xfs_da3_node_read into one variant that always looks up the daddr
> and doesn't accept holes, and one that already has a daddr at hand.
> This is in preparation of splitting up xfs_da_read_buf in a similar way.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c     |  14 ++---
>  fs/xfs/libxfs/xfs_da_btree.c | 111 ++++++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_da_btree.h |   6 +-
>  fs/xfs/xfs_attr_inactive.c   |   8 +--
>  fs/xfs/xfs_attr_list.c       |   6 +-
>  5 files changed, 82 insertions(+), 63 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ebe6b0575f40..0d7fcc983b3d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1266,10 +1266,9 @@ xfs_attr_refillstate(xfs_da_state_t *state)
>  	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
>  	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
>  		if (blk->disk_blkno) {
> -			error = xfs_da3_node_read(state->args->trans,
> -						state->args->dp,
> -						blk->blkno, blk->disk_blkno,
> -						&blk->bp, XFS_ATTR_FORK);
> +			error = xfs_da3_node_read_mapped(state->args->trans,
> +					state->args->dp, blk->disk_blkno,
> +					&blk->bp, XFS_ATTR_FORK);
>  			if (error)
>  				return error;
>  		} else {
> @@ -1285,10 +1284,9 @@ xfs_attr_refillstate(xfs_da_state_t *state)
>  	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
>  	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
>  		if (blk->disk_blkno) {
> -			error = xfs_da3_node_read(state->args->trans,
> -						state->args->dp,
> -						blk->blkno, blk->disk_blkno,
> -						&blk->bp, XFS_ATTR_FORK);
> +			error = xfs_da3_node_read_mapped(state->args->trans,
> +					state->args->dp, blk->disk_blkno,
> +					&blk->bp, XFS_ATTR_FORK);
>  			if (error)
>  				return error;
>  		} else {
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index b1b0b38d7747..489936e01c33 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -331,46 +331,66 @@ const struct xfs_buf_ops xfs_da3_node_buf_ops = {
>  	.verify_struct = xfs_da3_node_verify_struct,
>  };
>  
> +static int
> +xfs_da3_node_set_type(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_da_blkinfo	*info = bp->b_addr;
> +
> +	switch (be16_to_cpu(info->magic)) {
> +	case XFS_DA_NODE_MAGIC:
> +	case XFS_DA3_NODE_MAGIC:
> +		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
> +		return 0;
> +	case XFS_ATTR_LEAF_MAGIC:
> +	case XFS_ATTR3_LEAF_MAGIC:
> +		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_ATTR_LEAF_BUF);
> +		return 0;
> +	case XFS_DIR2_LEAFN_MAGIC:
> +	case XFS_DIR3_LEAFN_MAGIC:
> +		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_LEAFN_BUF);
> +		return 0;
> +	default:
> +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp,
> +				info, sizeof(*info));
> +		xfs_trans_brelse(tp, bp);
> +		return -EFSCORRUPTED;
> +	}
> +}
> +
>  int
>  xfs_da3_node_read(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		bno,
> -	xfs_daddr_t		mappedbno,
>  	struct xfs_buf		**bpp,
> -	int			which_fork)
> +	int			whichfork)
>  {
> -	int			err;
> +	int			error;
>  
> -	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
> -					which_fork, &xfs_da3_node_buf_ops);
> -	if (!err && tp && *bpp) {
> -		struct xfs_da_blkinfo	*info = (*bpp)->b_addr;
> -		int			type;
> +	error = xfs_da_read_buf(tp, dp, bno, -1, bpp, whichfork,
> +			&xfs_da3_node_buf_ops);
> +	if (error || !*bpp || !tp)
> +		return error;
> +	return xfs_da3_node_set_type(tp, *bpp);
> +}
>  
> -		switch (be16_to_cpu(info->magic)) {
> -		case XFS_DA_NODE_MAGIC:
> -		case XFS_DA3_NODE_MAGIC:
> -			type = XFS_BLFT_DA_NODE_BUF;
> -			break;
> -		case XFS_ATTR_LEAF_MAGIC:
> -		case XFS_ATTR3_LEAF_MAGIC:
> -			type = XFS_BLFT_ATTR_LEAF_BUF;
> -			break;
> -		case XFS_DIR2_LEAFN_MAGIC:
> -		case XFS_DIR3_LEAFN_MAGIC:
> -			type = XFS_BLFT_DIR_LEAFN_BUF;
> -			break;
> -		default:
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -					tp->t_mountp, info, sizeof(*info));
> -			xfs_trans_brelse(tp, *bpp);
> -			*bpp = NULL;
> -			return -EFSCORRUPTED;
> -		}
> -		xfs_trans_buf_set_type(tp, *bpp, type);
> -	}
> -	return err;
> +int
> +xfs_da3_node_read_mapped(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
> +	xfs_daddr_t		mappedbno,
> +	struct xfs_buf		**bpp,
> +	int			whichfork)
> +{
> +	int			error;
> +
> +	error = xfs_da_read_buf(tp, dp, 0, mappedbno, bpp, whichfork,
> +			&xfs_da3_node_buf_ops);
> +	if (error || !*bpp || !tp)
> +		return error;
> +	return xfs_da3_node_set_type(tp, *bpp);
>  }
>  
>  /*========================================================================
> @@ -1166,8 +1186,7 @@ xfs_da3_root_join(
>  	 */
>  	child = be32_to_cpu(oldroothdr.btree[0].before);
>  	ASSERT(child != 0);
> -	error = xfs_da3_node_read(args->trans, dp, child, -1, &bp,
> -					     args->whichfork);
> +	error = xfs_da3_node_read(args->trans, dp, child, &bp, args->whichfork);
>  	if (error)
>  		return error;
>  	xfs_da_blkinfo_onlychild_validate(bp->b_addr, oldroothdr.level);
> @@ -1281,8 +1300,8 @@ xfs_da3_node_toosmall(
>  			blkno = nodehdr.back;
>  		if (blkno == 0)
>  			continue;
> -		error = xfs_da3_node_read(state->args->trans, dp,
> -					blkno, -1, &bp, state->args->whichfork);
> +		error = xfs_da3_node_read(state->args->trans, dp, blkno, &bp,
> +				state->args->whichfork);
>  		if (error)
>  			return error;
>  
> @@ -1570,7 +1589,7 @@ xfs_da3_node_lookup_int(
>  		 */
>  		blk->blkno = blkno;
>  		error = xfs_da3_node_read(args->trans, args->dp, blkno,
> -					-1, &blk->bp, args->whichfork);
> +					&blk->bp, args->whichfork);
>  		if (error) {
>  			blk->blkno = 0;
>  			state->path.active--;
> @@ -1809,7 +1828,7 @@ xfs_da3_blk_link(
>  		if (old_info->back) {
>  			error = xfs_da3_node_read(args->trans, dp,
>  						be32_to_cpu(old_info->back),
> -						-1, &bp, args->whichfork);
> +						&bp, args->whichfork);
>  			if (error)
>  				return error;
>  			ASSERT(bp != NULL);
> @@ -1830,7 +1849,7 @@ xfs_da3_blk_link(
>  		if (old_info->forw) {
>  			error = xfs_da3_node_read(args->trans, dp,
>  						be32_to_cpu(old_info->forw),
> -						-1, &bp, args->whichfork);
> +						&bp, args->whichfork);
>  			if (error)
>  				return error;
>  			ASSERT(bp != NULL);
> @@ -1889,7 +1908,7 @@ xfs_da3_blk_unlink(
>  		if (drop_info->back) {
>  			error = xfs_da3_node_read(args->trans, args->dp,
>  						be32_to_cpu(drop_info->back),
> -						-1, &bp, args->whichfork);
> +						&bp, args->whichfork);
>  			if (error)
>  				return error;
>  			ASSERT(bp != NULL);
> @@ -1906,7 +1925,7 @@ xfs_da3_blk_unlink(
>  		if (drop_info->forw) {
>  			error = xfs_da3_node_read(args->trans, args->dp,
>  						be32_to_cpu(drop_info->forw),
> -						-1, &bp, args->whichfork);
> +						&bp, args->whichfork);
>  			if (error)
>  				return error;
>  			ASSERT(bp != NULL);
> @@ -1990,7 +2009,7 @@ xfs_da3_path_shift(
>  		/*
>  		 * Read the next child block into a local buffer.
>  		 */
> -		error = xfs_da3_node_read(args->trans, dp, blkno, -1, &bp,
> +		error = xfs_da3_node_read(args->trans, dp, blkno, &bp,
>  					  args->whichfork);
>  		if (error)
>  			return error;
> @@ -2283,7 +2302,7 @@ xfs_da3_swap_lastblock(
>  	 * Read the last block in the btree space.
>  	 */
>  	last_blkno = (xfs_dablk_t)lastoff - args->geo->fsbcount;
> -	error = xfs_da3_node_read(tp, dp, last_blkno, -1, &last_buf, w);
> +	error = xfs_da3_node_read(tp, dp, last_blkno, &last_buf, w);
>  	if (error)
>  		return error;
>  	/*
> @@ -2320,7 +2339,7 @@ xfs_da3_swap_lastblock(
>  	 * If the moved block has a left sibling, fix up the pointers.
>  	 */
>  	if ((sib_blkno = be32_to_cpu(dead_info->back))) {
> -		error = xfs_da3_node_read(tp, dp, sib_blkno, -1, &sib_buf, w);
> +		error = xfs_da3_node_read(tp, dp, sib_blkno, &sib_buf, w);
>  		if (error)
>  			goto done;
>  		sib_info = sib_buf->b_addr;
> @@ -2342,7 +2361,7 @@ xfs_da3_swap_lastblock(
>  	 * If the moved block has a right sibling, fix up the pointers.
>  	 */
>  	if ((sib_blkno = be32_to_cpu(dead_info->forw))) {
> -		error = xfs_da3_node_read(tp, dp, sib_blkno, -1, &sib_buf, w);
> +		error = xfs_da3_node_read(tp, dp, sib_blkno, &sib_buf, w);
>  		if (error)
>  			goto done;
>  		sib_info = sib_buf->b_addr;
> @@ -2366,7 +2385,7 @@ xfs_da3_swap_lastblock(
>  	 * Walk down the tree looking for the parent of the moved block.
>  	 */
>  	for (;;) {
> -		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
> +		error = xfs_da3_node_read(tp, dp, par_blkno, &par_buf, w);
>  		if (error)
>  			goto done;
>  		par_node = par_buf->b_addr;
> @@ -2417,7 +2436,7 @@ xfs_da3_swap_lastblock(
>  			error = -EFSCORRUPTED;
>  			goto done;
>  		}
> -		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
> +		error = xfs_da3_node_read(tp, dp, par_blkno, &par_buf, w);
>  		if (error)
>  			goto done;
>  		par_node = par_buf->b_addr;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 4ba0ded7b973..74eeb97852d8 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -198,8 +198,10 @@ int	xfs_da3_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
>  int	xfs_da3_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
>  				       xfs_da_state_blk_t *new_blk);
>  int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
> -			 xfs_dablk_t bno, xfs_daddr_t mappedbno,
> -			 struct xfs_buf **bpp, int which_fork);
> +			xfs_dablk_t bno, struct xfs_buf **bpp, int whichfork);
> +int	xfs_da3_node_read_mapped(struct xfs_trans *tp, struct xfs_inode *dp,
> +			xfs_daddr_t mappedbno, struct xfs_buf **bpp,
> +			int whichfork);
>  
>  /*
>   * Utility routines.
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index a78c501f6fb1..f1cafd82ec75 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -233,7 +233,7 @@ xfs_attr3_node_inactive(
>  		 * traversal of the tree so we may deal with many blocks
>  		 * before we come back to this one.
>  		 */
> -		error = xfs_da3_node_read(*trans, dp, child_fsb, -1, &child_bp,
> +		error = xfs_da3_node_read(*trans, dp, child_fsb, &child_bp,
>  					  XFS_ATTR_FORK);
>  		if (error)
>  			return error;
> @@ -280,8 +280,8 @@ xfs_attr3_node_inactive(
>  		if (i + 1 < ichdr.count) {
>  			struct xfs_da3_icnode_hdr phdr;
>  
> -			error = xfs_da3_node_read(*trans, dp, 0, parent_blkno,
> -						 &bp, XFS_ATTR_FORK);
> +			error = xfs_da3_node_read_mapped(*trans, dp,
> +					parent_blkno, &bp, XFS_ATTR_FORK);
>  			if (error)
>  				return error;
>  			xfs_da3_node_hdr_from_disk(dp->i_mount, &phdr,
> @@ -322,7 +322,7 @@ xfs_attr3_root_inactive(
>  	 * the extents in reverse order the extent containing
>  	 * block 0 must still be there.
>  	 */
> -	error = xfs_da3_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
> +	error = xfs_da3_node_read(*trans, dp, 0, &bp, XFS_ATTR_FORK);
>  	if (error)
>  		return error;
>  	blkno = bp->b_bn;
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 426f93cfb2ea..8afbb30be002 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -224,7 +224,7 @@ xfs_attr_node_list_lookup(
>  	ASSERT(*pbp == NULL);
>  	cursor->blkno = 0;
>  	for (;;) {
> -		error = xfs_da3_node_read(tp, dp, cursor->blkno, -1, &bp,
> +		error = xfs_da3_node_read(tp, dp, cursor->blkno, &bp,
>  				XFS_ATTR_FORK);
>  		if (error)
>  			return error;
> @@ -312,8 +312,8 @@ xfs_attr_node_list(
>  	 */
>  	bp = NULL;
>  	if (cursor->blkno > 0) {
> -		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, -1,
> -					      &bp, XFS_ATTR_FORK);
> +		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, &bp,
> +				XFS_ATTR_FORK);
>  		if ((error != 0) && (error != -EFSCORRUPTED))
>  			return error;
>  		if (bp) {
> -- 
> 2.20.1
> 

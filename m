Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0230DC432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5C2422315
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fVTkhiHH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfKRVcN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 16:32:13 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39240 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfKRVcN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 16:32:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILTZuL177831;
        Mon, 18 Nov 2019 21:32:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=g+cKhR/fjOdEssxXoGG1XHn76aYDKtZ01j9eeM7lSlo=;
 b=fVTkhiHHKR9wOQX4onnwIOv8MFSNPOC28cvYG1EzUYkqNhT2nS8mUUqBdJvnZmFh2b2F
 MYCd68Gg4CtLXpMQ/sPOBtwp++YK+kGMmSw9viMY9dwOzhIyNJJjm32zsw1YXaqJqdql
 lYbS4U/oTaZSj26m4izqI/jVebvu0xjErOgaoLHEvcd10y6PJ78N/ko1kOOhIsH1AKlN
 WnEqWhNRL6f0JHvNBRaEJvsTw+LODivre/6yBmKL8+xd2ncPBI29UrELqUIIOD0LjPBH
 EHzAjTJs0fN14bPp1hKPKcsSyFZiboYulI/Eb6eo8ijdVLUdRPTxBliUTRjD8XNHOOSp Tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wa92pk079-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:32:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILDeau135528;
        Mon, 18 Nov 2019 21:32:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wc09w8eeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:32:08 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAILW7CZ030827;
        Mon, 18 Nov 2019 21:32:07 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 13:32:07 -0800
Date:   Mon, 18 Nov 2019 13:32:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 9/9] xfs: remove the mappedbno argument to xfs_da_get_buf
Message-ID: <20191118213206.GE6219@magnolia>
References: <20191116182214.23711-1-hch@lst.de>
 <20191116182214.23711-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116182214.23711-10-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911180184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911180185
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 16, 2019 at 07:22:14PM +0100, Christoph Hellwig wrote:
> Use the xfs_da_get_buf_daddr function directly for the two callers
> that pass a mapped disk address, and then remove the mappedbno argument.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, though I haven't tested this ... :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |  4 ++--
>  fs/xfs/libxfs/xfs_da_btree.c  | 18 +++---------------
>  fs/xfs/libxfs/xfs_da_btree.h  |  3 +--
>  fs/xfs/libxfs/xfs_dir2_data.c |  2 +-
>  fs/xfs/libxfs/xfs_dir2_leaf.c |  2 +-
>  fs/xfs/libxfs/xfs_dir2_node.c |  2 +-
>  fs/xfs/xfs_attr_inactive.c    | 24 +++++++++++++++++++-----
>  7 files changed, 28 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 450e75cc7c93..32bf3c30238c 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1162,7 +1162,7 @@ xfs_attr3_leaf_to_node(
>  	if (error)
>  		goto out;
>  
> -	error = xfs_da_get_buf(args->trans, dp, blkno, -1, &bp2, XFS_ATTR_FORK);
> +	error = xfs_da_get_buf(args->trans, dp, blkno, &bp2, XFS_ATTR_FORK);
>  	if (error)
>  		goto out;
>  
> @@ -1223,7 +1223,7 @@ xfs_attr3_leaf_create(
>  
>  	trace_xfs_attr_leaf_create(args);
>  
> -	error = xfs_da_get_buf(args->trans, args->dp, blkno, -1, &bp,
> +	error = xfs_da_get_buf(args->trans, args->dp, blkno, &bp,
>  					    XFS_ATTR_FORK);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 34d0ce93bcc3..dbb2b2f38a7f 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -429,7 +429,7 @@ xfs_da3_node_create(
>  	trace_xfs_da_node_create(args);
>  	ASSERT(level <= XFS_DA_NODE_MAXDEPTH);
>  
> -	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, whichfork);
> +	error = xfs_da_get_buf(tp, dp, blkno, &bp, whichfork);
>  	if (error)
>  		return error;
>  	bp->b_ops = &xfs_da3_node_buf_ops;
> @@ -656,7 +656,7 @@ xfs_da3_root_split(
>  
>  	dp = args->dp;
>  	tp = args->trans;
> -	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, args->whichfork);
> +	error = xfs_da_get_buf(tp, dp, blkno, &bp, args->whichfork);
>  	if (error)
>  		return error;
>  	node = bp->b_addr;
> @@ -2665,7 +2665,6 @@ xfs_da_get_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		bno,
> -	xfs_daddr_t		mappedbno,
>  	struct xfs_buf		**bpp,
>  	int			whichfork)
>  {
> @@ -2676,17 +2675,7 @@ xfs_da_get_buf(
>  	int			error;
>  
>  	*bpp = NULL;
> -
> -	if (mappedbno >= 0) {
> -		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, mappedbno,
> -				XFS_FSB_TO_BB(mp,
> -					xfs_dabuf_nfsb(mp, whichfork)), 0);
> -		goto done;
> -	}
> -
> -	error = xfs_dabuf_map(dp, bno,
> -			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
> -			whichfork, &mapp, &nmap);
> +	error = xfs_dabuf_map(dp, bno, 0, whichfork, &mapp, &nmap);
>  	if (error) {
>  		/* mapping a hole is not an error, but we don't continue */
>  		if (error == -ENOENT)
> @@ -2695,7 +2684,6 @@ xfs_da_get_buf(
>  	}
>  
>  	bp = xfs_trans_get_buf_map(tp, mp->m_ddev_targp, mapp, nmap, 0);
> -done:
>  	error = bp ? bp->b_error : -EIO;
>  	if (error) {
>  		if (bp)
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 1c8347af8071..1f874e7b0bed 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -213,8 +213,7 @@ int	xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno);
>  int	xfs_da_grow_inode_int(struct xfs_da_args *args, xfs_fileoff_t *bno,
>  			      int count);
>  int	xfs_da_get_buf(struct xfs_trans *trans, struct xfs_inode *dp,
> -			      xfs_dablk_t bno, xfs_daddr_t mappedbno,
> -			      struct xfs_buf **bp, int whichfork);
> +		xfs_dablk_t bno, struct xfs_buf **bp, int whichfork);
>  int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
>  		xfs_dablk_t bno, unsigned int flags, struct xfs_buf **bpp,
>  		int whichfork, const struct xfs_buf_ops *ops);
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 9ac08df96b3f..c616ea1eb0a3 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -680,7 +680,7 @@ xfs_dir3_data_init(
>  	 * Get the buffer set up for the block.
>  	 */
>  	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, blkno),
> -			       -1, &bp, XFS_DATA_FORK);
> +			       &bp, XFS_DATA_FORK);
>  	if (error)
>  		return error;
>  	bp->b_ops = &xfs_dir3_data_buf_ops;
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 0107a661acd8..4845d4c7055d 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -355,7 +355,7 @@ xfs_dir3_leaf_get_buf(
>  	       bno < xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET));
>  
>  	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, bno),
> -			       -1, &bp, XFS_DATA_FORK);
> +			       &bp, XFS_DATA_FORK);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index cc1a20b69215..c928febb54bf 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -324,7 +324,7 @@ xfs_dir3_free_get_buf(
>  	struct xfs_dir3_icfree_hdr hdr;
>  
>  	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, fbno),
> -				   -1, &bp, XFS_DATA_FORK);
> +			&bp, XFS_DATA_FORK);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index f1cafd82ec75..5ff49523d8ea 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -196,6 +196,7 @@ xfs_attr3_node_inactive(
>  	struct xfs_buf		*bp,
>  	int			level)
>  {
> +	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_da_blkinfo	*info;
>  	xfs_dablk_t		child_fsb;
>  	xfs_daddr_t		parent_blkno, child_blkno;
> @@ -267,10 +268,16 @@ xfs_attr3_node_inactive(
>  		/*
>  		 * Remove the subsidiary block from the cache and from the log.
>  		 */
> -		error = xfs_da_get_buf(*trans, dp, 0, child_blkno, &child_bp,
> -				       XFS_ATTR_FORK);
> -		if (error)
> +		child_bp = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
> +				child_blkno,
> +				XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0);
> +		if (!child_bp)
> +			return -EIO;
> +		error = bp->b_error;
> +		if (error) {
> +			xfs_trans_brelse(*trans, child_bp);
>  			return error;
> +		}
>  		xfs_trans_binval(*trans, child_bp);
>  
>  		/*
> @@ -311,6 +318,7 @@ xfs_attr3_root_inactive(
>  	struct xfs_trans	**trans,
>  	struct xfs_inode	*dp)
>  {
> +	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_da_blkinfo	*info;
>  	struct xfs_buf		*bp;
>  	xfs_daddr_t		blkno;
> @@ -353,9 +361,15 @@ xfs_attr3_root_inactive(
>  	/*
>  	 * Invalidate the incore copy of the root block.
>  	 */
> -	error = xfs_da_get_buf(*trans, dp, 0, blkno, &bp, XFS_ATTR_FORK);
> -	if (error)
> +	bp = xfs_trans_get_buf(*trans, mp->m_ddev_targp, blkno,
> +			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0);
> +	if (!bp)
> +		return -EIO;
> +	error = bp->b_error;
> +	if (error) {
> +		xfs_trans_brelse(*trans, bp);
>  		return error;
> +	}
>  	xfs_trans_binval(*trans, bp);	/* remove from cache */
>  	/*
>  	 * Commit the invalidate and start the next transaction.
> -- 
> 2.20.1
> 

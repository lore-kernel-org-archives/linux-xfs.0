Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7069C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B121A222DD
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:23:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pqe3w/HH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfKRVXF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 16:23:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:32808 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfKRVXF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 16:23:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILDuU9177795;
        Mon, 18 Nov 2019 21:23:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Gzmwr1LdNhy16G44xiLJpOh0DBJ5sy5qbTZz2Te7Xl0=;
 b=pqe3w/HH5qj+Padw1tW/A5WJrVVzaxEoeoNZG/4MbTXUgHlN/xUXIXKIUB9wXxW6UMwS
 KGspg+gq1ooc9JRab52rCrcS2gAKLanIDestqYEmOs+LL0NCroJ9sgoZYdVfZaZa9CAL
 Rq8VVxrHiArkwY1DiM0z84NvACZ8Q90rWsqwyxYkgW1uxp/4ujNhN7SZQHGbYs20yeDs
 7Qgz/jmTh/lq+Z6ZWbIPO7jTlMOwhjvUkfHePQsHJUqcIK5phAnH2r9mWWjHcuzQRyN7
 LqZjjYxT6ZXrUbSK1jTJWj75xQT/G14FNNX37TaBbBIi+tOLf3rStW7WMSCImZKXPVBh Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8htk1kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:23:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILDS6g060739;
        Mon, 18 Nov 2019 21:23:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wbxm35g3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:23:00 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAILMxTw017831;
        Mon, 18 Nov 2019 21:22:59 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 13:22:59 -0800
Date:   Mon, 18 Nov 2019 13:22:58 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 4/9] xfs: remove the mappedbno argument to
 xfs_attr3_leaf_read
Message-ID: <20191118212258.GY6219@magnolia>
References: <20191116182214.23711-1-hch@lst.de>
 <20191116182214.23711-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116182214.23711-5-hch@lst.de>
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

On Sat, Nov 16, 2019 at 07:22:09PM +0100, Christoph Hellwig wrote:
> This argument is always hard coded to -1, so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Heh, neat!
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 10 +++++-----
>  fs/xfs/libxfs/xfs_attr_leaf.c | 17 ++++++++---------
>  fs/xfs/libxfs/xfs_attr_leaf.h |  3 +--
>  fs/xfs/xfs_attr_list.c        |  5 +++--
>  4 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 510ca6974604..ebe6b0575f40 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -589,7 +589,7 @@ xfs_attr_leaf_addname(
>  	 */
>  	dp = args->dp;
>  	args->blkno = 0;
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
>  	if (error)
>  		return error;
>  
> @@ -715,7 +715,7 @@ xfs_attr_leaf_addname(
>  		 * remove the "old" attr from that block (neat, huh!)
>  		 */
>  		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> -					   -1, &bp);
> +					   &bp);
>  		if (error)
>  			return error;
>  
> @@ -769,7 +769,7 @@ xfs_attr_leaf_removename(
>  	 */
>  	dp = args->dp;
>  	args->blkno = 0;
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
>  	if (error)
>  		return error;
>  
> @@ -813,7 +813,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  	trace_xfs_attr_leaf_get(args);
>  
>  	args->blkno = 0;
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
>  	if (error)
>  		return error;
>  
> @@ -1173,7 +1173,7 @@ xfs_attr_node_removename(
>  		ASSERT(state->path.blk[0].bp);
>  		state->path.blk[0].bp = NULL;
>  
> -		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, &bp);
> +		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
>  		if (error)
>  			goto out;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 85ec5945d29f..9c0cdb51955e 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -430,13 +430,12 @@ xfs_attr3_leaf_read(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		bno,
> -	xfs_daddr_t		mappedbno,
>  	struct xfs_buf		**bpp)
>  {
>  	int			err;
>  
> -	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
> -				XFS_ATTR_FORK, &xfs_attr3_leaf_buf_ops);
> +	err = xfs_da_read_buf(tp, dp, bno, -1, bpp, XFS_ATTR_FORK,
> +			&xfs_attr3_leaf_buf_ops);
>  	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_ATTR_LEAF_BUF);
>  	return err;
> @@ -1159,7 +1158,7 @@ xfs_attr3_leaf_to_node(
>  	error = xfs_da_grow_inode(args, &blkno);
>  	if (error)
>  		goto out;
> -	error = xfs_attr3_leaf_read(args->trans, dp, 0, -1, &bp1);
> +	error = xfs_attr3_leaf_read(args->trans, dp, 0, &bp1);
>  	if (error)
>  		goto out;
>  
> @@ -1994,7 +1993,7 @@ xfs_attr3_leaf_toosmall(
>  		if (blkno == 0)
>  			continue;
>  		error = xfs_attr3_leaf_read(state->args->trans, state->args->dp,
> -					blkno, -1, &bp);
> +					blkno, &bp);
>  		if (error)
>  			return error;
>  
> @@ -2730,7 +2729,7 @@ xfs_attr3_leaf_clearflag(
>  	/*
>  	 * Set up the operation.
>  	 */
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
>  	if (error)
>  		return error;
>  
> @@ -2797,7 +2796,7 @@ xfs_attr3_leaf_setflag(
>  	/*
>  	 * Set up the operation.
>  	 */
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
>  	if (error)
>  		return error;
>  
> @@ -2859,7 +2858,7 @@ xfs_attr3_leaf_flipflags(
>  	/*
>  	 * Read the block containing the "old" attr
>  	 */
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp1);
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp1);
>  	if (error)
>  		return error;
>  
> @@ -2868,7 +2867,7 @@ xfs_attr3_leaf_flipflags(
>  	 */
>  	if (args->blkno2 != args->blkno) {
>  		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
> -					   -1, &bp2);
> +					   &bp2);
>  		if (error)
>  			return error;
>  	} else {
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 16208a7743df..f4a188e28b7b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -108,8 +108,7 @@ int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
>  				   struct xfs_buf *leaf2_bp);
>  int	xfs_attr_leaf_newentsize(struct xfs_da_args *args, int *local);
>  int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
> -			xfs_dablk_t bno, xfs_daddr_t mappedbno,
> -			struct xfs_buf **bpp);
> +			xfs_dablk_t bno, struct xfs_buf **bpp);
>  void	xfs_attr3_leaf_hdr_from_disk(struct xfs_da_geometry *geo,
>  				     struct xfs_attr3_icleaf_hdr *to,
>  				     struct xfs_attr_leafblock *from);
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 0ec6606149a2..426f93cfb2ea 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -380,7 +380,8 @@ xfs_attr_node_list(
>  			break;
>  		cursor->blkno = leafhdr.forw;
>  		xfs_trans_brelse(context->tp, bp);
> -		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno, -1, &bp);
> +		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno,
> +					    &bp);
>  		if (error)
>  			return error;
>  	}
> @@ -500,7 +501,7 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
>  	trace_xfs_attr_leaf_list(context);
>  
>  	context->cursor->blkno = 0;
> -	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, -1, &bp);
> +	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, &bp);
>  	if (error)
>  		return error;
>  
> -- 
> 2.20.1
> 

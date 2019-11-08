Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119CCFC6196
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD7C62178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:37:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WEbZskSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388102AbfKHVhG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:37:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58750 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388098AbfKHVhF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 16:37:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8LZ4aW196308
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:37:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=p0zniDP0PkSDOn7UzsiixSiJhOPS0NJG9jgocpB7r4k=;
 b=WEbZskSoAuRVJTJMu9n1zO4P6Ge7p3PixsWREYTZ9Tga0s1GvqOovVtwbVjJYFfxwOUX
 rXGpf6EfDb2b3liZVWtmuJGruiPhCIr+52zdRGvqzqPMpQAGxk2nxUJoJPjpZ5MobqI1
 +bs5KcCzhLqLwCW7nm4Bx+Lj+LMbW9BgboVMWBSzdH2o6kdgMomIKpVPjVlQI0+rGZVs
 hcstUicMtxfCv4xOjtYP2p9a29WQErOujkHZW2P+R3YAzXSo7UsLViohxSvPPz+JuBvu
 e4Z2hhLQQ4OWefXETBgWO13Cd1HbdMTgQVn3O1GtfuatlSA8Z3p7wjbcjwNsX0vOmGdY HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w17t6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:37:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8LX5sq040117
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:37:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w5bmqe59w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:37:03 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA8Lb2qI030230
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:37:02 GMT
Received: from localhost (/10.159.140.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 13:37:02 -0800
Date:   Fri, 8 Nov 2019 13:37:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 16/17] xfs: Add delay ready attr remove routines
Message-ID: <20191108213701.GG6219@magnolia>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-17-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107012801.22863-17-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:28:00PM -0700, Allison Collins wrote:
> This patch modifies the attr remove routines to be delay ready.
> This means they no longer roll or commit transactions, but instead
> return -EAGAIN to have the calling routine roll and refresh the
> transaction.  In this series, xfs_attr_remove_args has become
> xfs_attr_remove_later, which uses a state machine to keep track
> of where it was when EAGAIN was returned.  xfs_attr_node_removename
> has also been modified to use the state machine, and a  new version of
> xfs_attr_remove_args consists of a simple loop to refresh the
> transaction until the operation is completed.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 123 +++++++++++++++++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_attr.h |   1 +
>  2 files changed, 104 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 626d4a98..38d5c5c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -369,10 +369,56 @@ xfs_has_attr(
>   */
>  int
>  xfs_attr_remove_args(
> +	struct xfs_da_args	*args)
> +{
> +	int			error = 0;
> +	int			err2 = 0;
> +
> +	do {
> +		error = xfs_attr_remove_later(args);
> +		if (error && error != -EAGAIN)
> +			goto out;
> +
> +		xfs_trans_log_inode(args->trans, args->dp,
> +			XFS_ILOG_CORE | XFS_ILOG_ADATA);

Don't the individual pieces of attr removal log ADATA on their own, when
needed?

If it weren't for that, this could just be xfs_trans_roll_inode, right?

--D

> +
> +		err2 = xfs_trans_roll(&args->trans);
> +		if (err2) {
> +			error = err2;
> +			goto out;
> +		}
> +
> +		/* Rejoin inode */
> +		xfs_trans_ijoin(args->trans, args->dp, 0);
> +
> +	} while (error == -EAGAIN);
> +out:
> +	return error;
> +}
> +
> +/*
> + * Remove the attribute specified in @args.
> + * This routine is meant to function as a delayed operation, and may return
> + * -EGAIN when the transaction needs to be rolled.  Calling functions will need
> + * to handle this, and recall the function until a successful error code is
> + * returned.
> + */
> +int
> +xfs_attr_remove_later(
>  	struct xfs_da_args      *args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	int			error;
> +	int			error = 0;
> +
> +	/* State machine switch */
> +	switch (args->dc.dc_state) {
> +	case XFS_DC_RM_INVALIDATE:
> +	case XFS_DC_RM_SHRINK:
> +	case XFS_DC_RM_NODE_BLKS:
> +		goto node;
> +	default:
> +		break;
> +	}
>  
>  	if (!xfs_inode_hasattr(dp)) {
>  		error = -ENOATTR;
> @@ -382,6 +428,7 @@ xfs_attr_remove_args(
>  	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>  		error = xfs_attr_leaf_removename(args);
>  	} else {
> +node:
>  		error = xfs_attr_node_removename(args);
>  	}
>  
> @@ -892,9 +939,6 @@ xfs_attr_leaf_removename(
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (error)
>  			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
>  	}
>  	return 0;
>  }
> @@ -1212,6 +1256,11 @@ xfs_attr_node_addname(
>   * This will involve walking down the Btree, and may involve joining
>   * leaf nodes and even joining intermediate nodes up to and including
>   * the root node (a special case of an intermediate node).
> + *
> + * This routine is meant to function as a delayed operation, and may return
> + * -EAGAIN when the transaction needs to be rolled.  Calling functions
> + * will need to handle this, and recall the function until a successful error
> + * code is returned.
>   */
>  STATIC int
>  xfs_attr_node_removename(
> @@ -1222,12 +1271,29 @@ xfs_attr_node_removename(
>  	struct xfs_buf		*bp;
>  	int			retval, error, forkoff;
>  	struct xfs_inode	*dp = args->dp;
> +	int			done = 0;
>  
>  	trace_xfs_attr_node_removename(args);
> +	state = args->dc.da_state;
> +	blk = args->dc.blk;
> +
> +	/* State machine switch */
> +	switch (args->dc.dc_state) {
> +	case XFS_DC_RM_NODE_BLKS:
> +		goto rm_node_blks;
> +	case XFS_DC_RM_INVALIDATE:
> +		goto rm_invalidate;
> +	case XFS_DC_RM_SHRINK:
> +		goto rm_shrink;
> +	default:
> +		break;
> +	}
>  
>  	error = xfs_attr_node_hasname(args, &state);
>  	if (error != -EEXIST)
>  		goto out;
> +	else
> +		error = 0;
>  
>  	/*
>  	 * If there is an out-of-line value, de-allocate the blocks.
> @@ -1237,6 +1303,14 @@ xfs_attr_node_removename(
>  	blk = &state->path.blk[ state->path.active-1 ];
>  	ASSERT(blk->bp != NULL);
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +
> +	/*
> +	 * Store blk and state in the context incase we need to cycle out the
> +	 * transaction
> +	 */
> +	args->dc.blk = blk;
> +	args->dc.da_state = state;
> +
>  	if (args->rmtblkno > 0) {
>  		/*
>  		 * Fill in disk block numbers in the state structure
> @@ -1255,13 +1329,30 @@ xfs_attr_node_removename(
>  		if (error)
>  			goto out;
>  
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +		args->dc.dc_state = XFS_DC_RM_INVALIDATE;
> +		return -EAGAIN;
> +rm_invalidate:
> +		error = xfs_attr_rmtval_invalidate(args);
>  		if (error)
>  			goto out;
> +rm_node_blks:
> +		/*
> +		 * Unmap value blocks for this attr.  This is similar to
> +		 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
> +		 * for new transactions
> +		 */
> +		while (!done && !error) {
> +			error = xfs_bunmapi(args->trans, args->dp,
> +				    args->rmtblkno, args->rmtblkcnt,
> +				    XFS_BMAPI_ATTRFORK, 1, &done);
> +			if (error)
> +				return error;
>  
> -		error = xfs_attr_rmtval_remove(args);
> -		if (error)
> -			goto out;
> +			if (!done) {
> +				args->dc.dc_state = XFS_DC_RM_NODE_BLKS;
> +				return -EAGAIN;
> +			}
> +		}
>  
>  		/*
>  		 * Refill the state structure with buffers, the prior calls
> @@ -1287,17 +1378,12 @@ xfs_attr_node_removename(
>  		error = xfs_da3_join(state);
>  		if (error)
>  			goto out;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			goto out;
> -		/*
> -		 * Commit the Btree join operation and start a new trans.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			goto out;
> +
> +		args->dc.dc_state = XFS_DC_RM_SHRINK;
> +		return -EAGAIN;
>  	}
>  
> +rm_shrink:
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> @@ -1319,9 +1405,6 @@ xfs_attr_node_removename(
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
>  				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
>  		} else
>  			xfs_trans_brelse(args->trans, bp);
>  	}
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 3b5dad4..fb8bf5b 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -152,6 +152,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
>  int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
> +int xfs_attr_remove_later(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> -- 
> 2.7.4
> 

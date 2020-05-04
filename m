Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBA9C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 17:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CFBB20663
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 17:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wDcyEtJL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgEDRmf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 13:42:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgEDRme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 13:42:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044HbfZW018811
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 17:42:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=RqsLlRLI/HC/ZR4+DZRGas+3Bj+j4Ez8voQv9nhkL6c=;
 b=wDcyEtJLc3EtPTgvzxuhgnG/xMHLcBEm7A4b6veXP/j20cxfZiAMyKep0qObaMO/PSY8
 qKNQE4KnwUa0E6Ru/TdE/x2Sv5h+03HOpO3NoLM1z14IMVK7p9oXApoG2R8GhmJtgPuf
 LoeBgV3loE+GPAiQvFAHf+ZFFel6qUNjkzofdJ4bZnJ/yK9SloEDxvI4IirBtRFBB8vJ
 w9hMlHC7/9PFkHWgKhjx3XvwlvoVPr/QmjBcBUZefbovRqSJSx3jiCcaHP4K22Xbbavc
 YcEjlDbUNJR1UQ+DV4NKmw7M7hH83RGawxZa0Ab99yFIuHcJ7H4Su0ejqDF98SWQqMZR xQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30s09r0e6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 17:42:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044HaqUl050463
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 17:42:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30sjdr0q5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 17:42:32 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044HgW05011023
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 17:42:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 10:42:31 -0700
Date:   Mon, 4 May 2020 10:42:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 12/24] xfs: Add helper function xfs_attr_node_shrink
Message-ID: <20200504174231.GF13783@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-13-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=2
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:04PM -0700, Allison Collins wrote:
> This patch adds a new helper function xfs_attr_node_shrink used to
> shrink an attr name into an inode if it is small enough.  This helps to
> modularize the greater calling function xfs_attr_node_removename.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Simple enough looking hoist;
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 68 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 42 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4fdfab9..d83443c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1108,6 +1108,45 @@ xfs_attr_node_addname(
>  }
>  
>  /*
> + * Shrink an attribute from leaf to shortform
> + */
> +STATIC int
> +xfs_attr_node_shrink(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state     *state)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	int			error, forkoff;
> +	struct xfs_buf		*bp;
> +
> +	/*
> +	 * Have to get rid of the copy of this dabuf in the state.
> +	 */
> +	ASSERT(state->path.active == 1);
> +	ASSERT(state->path.blk[0].bp);
> +	state->path.blk[0].bp = NULL;
> +
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> +	if (error)
> +		return error;
> +
> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
> +	if (forkoff) {
> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +		/* bp is gone due to xfs_da_shrink_inode */
> +		if (error)
> +			return error;
> +
> +		error = xfs_defer_finish(&args->trans);
> +		if (error)
> +			return error;
> +	} else
> +		xfs_trans_brelse(args->trans, bp);
> +
> +	return 0;
> +}
> +
> +/*
>   * Remove a name from a B-tree attribute list.
>   *
>   * This will involve walking down the Btree, and may involve joining
> @@ -1120,8 +1159,7 @@ xfs_attr_node_removename(
>  {
>  	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
> -	struct xfs_buf		*bp;
> -	int			retval, error, forkoff;
> +	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
> @@ -1206,30 +1244,8 @@ xfs_attr_node_removename(
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		/*
> -		 * Have to get rid of the copy of this dabuf in the state.
> -		 */
> -		ASSERT(state->path.active == 1);
> -		ASSERT(state->path.blk[0].bp);
> -		state->path.blk[0].bp = NULL;
> -
> -		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> -		if (error)
> -			goto out;
> -
> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -			/* bp is gone due to xfs_da_shrink_inode */
> -			if (error)
> -				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
> -		} else
> -			xfs_trans_brelse(args->trans, bp);
> -	}
> -	error = 0;
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +		error = xfs_attr_node_shrink(args, state);
>  
>  out:
>  	if (state)
> -- 
> 2.7.4
> 

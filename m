Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BADC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 18:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 076AD2068E
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 18:58:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N40R8I8U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgEDS6P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 14:58:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34004 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgEDS6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 14:58:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044IveG7161358
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 18:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=1zfKxG83Dh85EqwQ2YrnYUp7Yz9AW7/SobJyRymWFI0=;
 b=N40R8I8U9G/R7ybM5JGUsLsgvA9h/qqO+h8hXWuKuluswLOEHpcISZp40rhNPg7R2RXp
 fGqlQnpKWxldVgqw+adCTUOeAK4KwykeVIWwMWEwU2Qe4Qfj8uB+fSXhY2MX5EG9Ggwt
 YaDk/93GvPu7Ue+5RQGNlMr9SIvrsgZ8JbK9s0v+f6TRqe97MGT1tpzap8zBEN4hAT7i
 LiS59DjS+ghW2V+C9R7VEMDdRPyh66Jg3mbgVFgPanlGsRxPol+/5YYV3JmabkIwrnZ+
 g2l1fJeXlq2xA0TDbABG0ja6yvXKOBkP3j31+TpenoyvLjVzay6xOv352P4vqEl2m+Jd 2Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30s09r0teq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 18:58:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044Iuh8d009689
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 18:58:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30sjdr574u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 18:58:13 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044IwDHX010012
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 18:58:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 11:58:13 -0700
Date:   Mon, 4 May 2020 11:58:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 17/24] xfs: Add helper function
 xfs_attr_node_removename_setup
Message-ID: <20200504185812.GD5703@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-18-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-18-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=2
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:09PM -0700, Allison Collins wrote:
> This patch adds a new helper function xfs_attr_node_removename_setup.
> This will help modularize xfs_attr_node_removename when we add delay
> ready attributes later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 48 +++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 35 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index feae122..c8226c6 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1184,6 +1184,39 @@ xfs_attr_leaf_mark_incomplete(
>  }
>  
>  /*
> + * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
> + * the blocks are valid.  Any remote blocks will be marked incomplete.

"Attr keys with remote blocks will be marked incomplete."

> + */
> +STATIC
> +int xfs_attr_node_removename_setup(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	**state)
> +{
> +	int			error;
> +	struct xfs_da_state_blk	*blk;
> +
> +	error = xfs_attr_node_hasname(args, state);
> +	if (error != -EEXIST)
> +		return error;
> +
> +	blk = &(*state)->path.blk[(*state)->path.active - 1];
> +	ASSERT(blk->bp != NULL);
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +
> +	if (args->rmtblkno > 0) {
> +		error = xfs_attr_leaf_mark_incomplete(args, *state);
> +		if (error)
> +			return error;
> +
> +		error = xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;

		return xfs_attr_rmtval_invalidate(args);

With those two things changed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +	}
> +
> +	return 0;
> +}
> +
> +/*
>   * Remove a name from a B-tree attribute list.
>   *
>   * This will involve walking down the Btree, and may involve joining
> @@ -1201,8 +1234,8 @@ xfs_attr_node_removename(
>  
>  	trace_xfs_attr_node_removename(args);
>  
> -	error = xfs_attr_node_hasname(args, &state);
> -	if (error != -EEXIST)
> +	error = xfs_attr_node_removename_setup(args, &state);
> +	if (error)
>  		goto out;
>  
>  	/*
> @@ -1210,18 +1243,7 @@ xfs_attr_node_removename(
>  	 * This is done before we remove the attribute so that we don't
>  	 * overflow the maximum size of a transaction and/or hit a deadlock.
>  	 */
> -	blk = &state->path.blk[ state->path.active-1 ];
> -	ASSERT(blk->bp != NULL);
> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  	if (args->rmtblkno > 0) {
> -		error = xfs_attr_leaf_mark_incomplete(args, state);
> -		if (error)
> -			goto out;
> -
> -		error = xfs_attr_rmtval_invalidate(args);
> -		if (error)
> -			return error;
> -
>  		error = xfs_attr_rmtval_remove(args);
>  		if (error)
>  			goto out;
> -- 
> 2.7.4
> 

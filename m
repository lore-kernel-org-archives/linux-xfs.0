Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCD1C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 19:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E871206C0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 19:06:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XNNeMPe6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgEDTGQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 15:06:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47608 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgEDTGP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 15:06:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044J0PU4072590
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3m3ICRlbpmyvdi0L5huo9aJkEMWSu6Nl8AydpQuOz0w=;
 b=XNNeMPe68vh/KPSzh2+CZkO/kai5AHCfiqMJ3HmZluHpvEZY3WsFMOHoctaCcLDX1zYZ
 r/UpZMA7RMlMsIt8ygmhu4r2O2/V9HTDL3e2fZ0tPoEVc2WJLx3TTpho3KK9N3KyV0g7
 poKjpMyo2iksboULiOBSZWvWDo1bjF2jOGgEE4TcLiqeSdm/hjuysj1mIRp22AjkeS7R
 sZK4K6HnL3UKmmH31Baa8LQH5xgiPE3/82z5gfNtOiupn/dGcK7geKaSPSMM9kpXE8fY
 Iutzt219ANEw9AB2RMkJ3m99Tzos3eAIL9mBR6rclweBx4gILVlnxwK2oArNfmSR8CTt rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30s1gn0mph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 19:06:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044J5jfY071786
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:06:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30t1r3034y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 19:06:14 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044J6DaI023651
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:06:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 12:06:13 -0700
Date:   Mon, 4 May 2020 12:06:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 20/24] xfs: Simplify xfs_attr_node_addname
Message-ID: <20200504190612.GG5703@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-21-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-21-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=2
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:12PM -0700, Allison Collins wrote:
> Quick patch to unnest the rename logic in the node code path.  This will
> help simplify delayed attr logic later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 131 +++++++++++++++++++++++------------------------
>  1 file changed, 64 insertions(+), 67 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1810f90..9171895 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1030,83 +1030,80 @@ xfs_attr_node_addname(
>  			return error;
>  	}
>  
> -	/*
> -	 * If this is an atomic rename operation, we must "flip" the
> -	 * incomplete flags on the "new" and "old" attribute/value pairs
> -	 * so that one disappears and one appears atomically.  Then we
> -	 * must remove the "old" attribute/value pair.
> -	 */
> -	if (args->op_flags & XFS_DA_OP_RENAME) {
> -		/*
> -		 * In a separate transaction, set the incomplete flag on the
> -		 * "old" attr and clear the incomplete flag on the "new" attr.
> -		 */
> -		error = xfs_attr3_leaf_flipflags(args);
> -		if (error)
> -			goto out;
> +	if ((args->op_flags & XFS_DA_OP_RENAME) == 0) {

Same comments about the commit message and the if test as the previous
patch.

Admittedly I'm now starting to wonder if this patch and the previous one
should really just hoist the taken and not-taken branches into separate
functions, but maybe you've already gone around and around on that, and
everyone else already thought we have too many small functions...

--D

>  		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series
> +		 * Added a "remote" value, just clear the incomplete flag.
>  		 */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			goto out;
> +		if (args->rmtblkno > 0)
> +			error = xfs_attr3_leaf_clearflag(args);
> +		retval = error;
> +		goto out;
> +	}
>  
> -		/*
> -		 * Dismantle the "old" attribute/value pair by removing
> -		 * a "remote" value (if it exists).
> -		 */
> -		xfs_attr_restore_rmt_blk(args);
> +	/*
> +	 * If this is an atomic rename operation, we must "flip" the incomplete
> +	 * flags on the "new" and "old" attribute/value pairs so that one
> +	 * disappears and one appears atomically.  Then we must remove the "old"
> +	 * attribute/value pair.
> +	 *
> +	 * In a separate transaction, set the incomplete flag on the "old" attr
> +	 * and clear the incomplete flag on the "new" attr.
> +	 */
> +	error = xfs_attr3_leaf_flipflags(args);
> +	if (error)
> +		goto out;
> +	/*
> +	 * Commit the flag value change and start the next trans in series
> +	 */
> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
> +	if (error)
> +		goto out;
>  
> -		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_invalidate(args);
> -			if (error)
> -				return error;
> +	/*
> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> +	 * (if it exists).
> +	 */
> +	xfs_attr_restore_rmt_blk(args);
>  
> -			error = xfs_attr_rmtval_remove(args);
> -			if (error)
> -				return error;
> -		}
> +	if (args->rmtblkno) {
> +		error = xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;
>  
> -		/*
> -		 * Re-find the "old" attribute entry after any split ops.
> -		 * The INCOMPLETE flag means that we will find the "old"
> -		 * attr, not the "new" one.
> -		 */
> -		args->attr_filter |= XFS_ATTR_INCOMPLETE;
> -		state = xfs_da_state_alloc();
> -		state->args = args;
> -		state->mp = mp;
> -		state->inleaf = 0;
> -		error = xfs_da3_node_lookup_int(state, &retval);
> +		error = xfs_attr_rmtval_remove(args);
>  		if (error)
> -			goto out;
> +			return error;
> +	}
>  
> -		/*
> -		 * Remove the name and update the hashvals in the tree.
> -		 */
> -		blk = &state->path.blk[ state->path.active-1 ];
> -		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -		error = xfs_attr3_leaf_remove(blk->bp, args);
> -		xfs_da3_fixhashpath(state, &state->path);
> +	/*
> +	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
> +	 * flag means that we will find the "old" attr, not the "new" one.
> +	 */
> +	args->attr_filter |= XFS_ATTR_INCOMPLETE;
> +	state = xfs_da_state_alloc();
> +	state->args = args;
> +	state->mp = mp;
> +	state->inleaf = 0;
> +	error = xfs_da3_node_lookup_int(state, &retval);
> +	if (error)
> +		goto out;
>  
> -		/*
> -		 * Check to see if the tree needs to be collapsed.
> -		 */
> -		if (retval && (state->path.active > 1)) {
> -			error = xfs_da3_join(state);
> -			if (error)
> -				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
> -		}
> +	/*
> +	 * Remove the name and update the hashvals in the tree.
> +	 */
> +	blk = &state->path.blk[state->path.active-1];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +	error = xfs_attr3_leaf_remove(blk->bp, args);
> +	xfs_da3_fixhashpath(state, &state->path);
>  
> -	} else if (args->rmtblkno > 0) {
> -		/*
> -		 * Added a "remote" value, just clear the incomplete flag.
> -		 */
> -		error = xfs_attr3_leaf_clearflag(args);
> +	/*
> +	 * Check to see if the tree needs to be collapsed.
> +	 */
> +	if (retval && (state->path.active > 1)) {
> +		error = xfs_da3_join(state);
> +		if (error)
> +			goto out;
> +		error = xfs_defer_finish(&args->trans);
>  		if (error)
>  			goto out;
>  	}
> -- 
> 2.7.4
> 

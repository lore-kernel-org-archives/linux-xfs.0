Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B15C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 20:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9746522CEA
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 20:52:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T70/VLd9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfH2UwV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 16:52:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45238 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfH2UwV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 16:52:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TKpK3H122797;
        Thu, 29 Aug 2019 20:52:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=0wAnVZZf8gHaC6r8vcV2ij2EaBGL8kVzMcjqsJCmcVg=;
 b=T70/VLd9DV9jDdrmjq/cEN35gcx7mZeP3xszqqnRBKQl7bn9gscqleeg5MyzRcb3JsxF
 IBbDG/vN+U2Bj/IMnVZJ1dQBysM4BCVTUuisXbz3OgeL4Tyw3H2UQlS+2CyL1PL3beTO
 sOuytd1Fgmu7VdTpQDxLfDPtGCak63VnANcLzdwEOp7/5eHAnSkXWm/LS3tyIRgz0C8A
 AGJU/zrTXXHjn3a1bwN5AhLN8UUiBPZKpAKUG6blqIzq3v6FsqfSVBxESimagq2zXnt9
 JPzFa6jy+x3N3SN4KhVZ3i4QjqY4IV18or0WljsEo3w+IHouBwneE2XpaSB43QmU+CL8 iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2upp3u80aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 20:52:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TKm06J166822;
        Thu, 29 Aug 2019 20:52:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2upc8v4f6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 20:52:17 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TKqGWV011609;
        Thu, 29 Aug 2019 20:52:16 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 13:52:15 -0700
Date:   Thu, 29 Aug 2019 13:52:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: move xfs_dir2_addname()
Message-ID: <20190829205215.GI5354@magnolia>
References: <20190829104710.28239-1-david@fromorbit.com>
 <20190829104710.28239-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829104710.28239-2-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290209
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290210
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 08:47:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This gets rid of the need for a forward  declaration of the static
> function xfs_dir2_addname_int() and readies the code for factoring
> of xfs_dir2_addname_int().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_node.c | 140 +++++++++++++++++-----------------
>  1 file changed, 69 insertions(+), 71 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 1fc44efc344d..e40986cc0759 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -32,8 +32,6 @@ static void xfs_dir2_leafn_rebalance(xfs_da_state_t *state,
>  static int xfs_dir2_leafn_remove(xfs_da_args_t *args, struct xfs_buf *bp,
>  				 int index, xfs_da_state_blk_t *dblk,
>  				 int *rval);
> -static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
> -				     xfs_da_state_blk_t *fblk);
>  
>  /*
>   * Check internal consistency of a leafn block.
> @@ -1610,75 +1608,6 @@ xfs_dir2_leafn_unbalance(
>  	xfs_dir3_leaf_check(dp, drop_blk->bp);
>  }
>  
> -/*
> - * Top-level node form directory addname routine.
> - */
> -int						/* error */
> -xfs_dir2_node_addname(
> -	xfs_da_args_t		*args)		/* operation arguments */
> -{
> -	xfs_da_state_blk_t	*blk;		/* leaf block for insert */
> -	int			error;		/* error return value */
> -	int			rval;		/* sub-return value */
> -	xfs_da_state_t		*state;		/* btree cursor */
> -
> -	trace_xfs_dir2_node_addname(args);
> -
> -	/*
> -	 * Allocate and initialize the state (btree cursor).
> -	 */
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = args->dp->i_mount;
> -	/*
> -	 * Look up the name.  We're not supposed to find it, but
> -	 * this gives us the insertion point.
> -	 */
> -	error = xfs_da3_node_lookup_int(state, &rval);
> -	if (error)
> -		rval = error;
> -	if (rval != -ENOENT) {
> -		goto done;
> -	}
> -	/*
> -	 * Add the data entry to a data block.
> -	 * Extravalid is set to a freeblock found by lookup.
> -	 */
> -	rval = xfs_dir2_node_addname_int(args,
> -		state->extravalid ? &state->extrablk : NULL);
> -	if (rval) {
> -		goto done;
> -	}
> -	blk = &state->path.blk[state->path.active - 1];
> -	ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
> -	/*
> -	 * Add the new leaf entry.
> -	 */
> -	rval = xfs_dir2_leafn_add(blk->bp, args, blk->index);
> -	if (rval == 0) {
> -		/*
> -		 * It worked, fix the hash values up the btree.
> -		 */
> -		if (!(args->op_flags & XFS_DA_OP_JUSTCHECK))
> -			xfs_da3_fixhashpath(state, &state->path);
> -	} else {
> -		/*
> -		 * It didn't work, we need to split the leaf block.
> -		 */
> -		if (args->total == 0) {
> -			ASSERT(rval == -ENOSPC);
> -			goto done;
> -		}
> -		/*
> -		 * Split the leaf block and insert the new entry.
> -		 */
> -		rval = xfs_da3_split(state);
> -	}
> -done:
> -	xfs_da_state_free(state);
> -	return rval;
> -}
> -
>  /*
>   * Add the data entry for a node-format directory name addition.
>   * The leaf entry is added in xfs_dir2_leafn_add.
> @@ -2056,6 +1985,75 @@ xfs_dir2_node_addname_int(
>  	return 0;
>  }
>  
> +/*
> + * Top-level node form directory addname routine.
> + */
> +int						/* error */
> +xfs_dir2_node_addname(
> +	xfs_da_args_t		*args)		/* operation arguments */
> +{
> +	xfs_da_state_blk_t	*blk;		/* leaf block for insert */
> +	int			error;		/* error return value */
> +	int			rval;		/* sub-return value */
> +	xfs_da_state_t		*state;		/* btree cursor */
> +
> +	trace_xfs_dir2_node_addname(args);
> +
> +	/*
> +	 * Allocate and initialize the state (btree cursor).
> +	 */
> +	state = xfs_da_state_alloc();
> +	state->args = args;
> +	state->mp = args->dp->i_mount;
> +	/*
> +	 * Look up the name.  We're not supposed to find it, but
> +	 * this gives us the insertion point.
> +	 */
> +	error = xfs_da3_node_lookup_int(state, &rval);
> +	if (error)
> +		rval = error;
> +	if (rval != -ENOENT) {
> +		goto done;
> +	}
> +	/*
> +	 * Add the data entry to a data block.
> +	 * Extravalid is set to a freeblock found by lookup.
> +	 */
> +	rval = xfs_dir2_node_addname_int(args,
> +		state->extravalid ? &state->extrablk : NULL);
> +	if (rval) {
> +		goto done;
> +	}
> +	blk = &state->path.blk[state->path.active - 1];
> +	ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
> +	/*
> +	 * Add the new leaf entry.
> +	 */
> +	rval = xfs_dir2_leafn_add(blk->bp, args, blk->index);
> +	if (rval == 0) {
> +		/*
> +		 * It worked, fix the hash values up the btree.
> +		 */
> +		if (!(args->op_flags & XFS_DA_OP_JUSTCHECK))
> +			xfs_da3_fixhashpath(state, &state->path);
> +	} else {
> +		/*
> +		 * It didn't work, we need to split the leaf block.
> +		 */
> +		if (args->total == 0) {
> +			ASSERT(rval == -ENOSPC);
> +			goto done;
> +		}
> +		/*
> +		 * Split the leaf block and insert the new entry.
> +		 */
> +		rval = xfs_da3_split(state);
> +	}
> +done:
> +	xfs_da_state_free(state);
> +	return rval;
> +}
> +
>  /*
>   * Lookup an entry in a node-format directory.
>   * All the real work happens in xfs_da3_node_lookup_int.
> -- 
> 2.23.0.rc1
> 

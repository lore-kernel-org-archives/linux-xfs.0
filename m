Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E592EC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 17:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B89E820663
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 17:34:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U0P//lrE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgEDReD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 13:34:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43940 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729549AbgEDReD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 13:34:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044HX5DV119469
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 17:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2uYrYLD8BHpPQe5pC8GrJrq/hKYQFX/dslAApH/7aQs=;
 b=U0P//lrEC1pDyKBnTlXKfoCoinxWUqCjZMPN0WkmHWHS2vqtyq6GFmXA53yuR3nAmOkO
 TsITYLg3cuR2axEtrrhzpRIRj7ImIGdD6DCJwBZDNNDjJcEwedGX09ku3WaPbcqKbvtK
 zBaoIRCdfmA86G4GjYGErztmDaI6DCbCZJpYkt6fLO6vcs2aABdr6aQK1fOZcu8JPgKw
 F8U5ExLHZC7Zn6Yx3eBnBHW1wpSizzRDzzsUutroGorLON5WGjl/9AqcdIxIWdjADxzU
 5y/theg9hfBkxBXValVJirvkv6s3Qc7U3pGMEtfHnvbDsVn4qpaeikrQEyKUQMG7I/fK lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30s0tm8aty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 17:34:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044HXcfB025435
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 17:34:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30t1r2skm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 17:34:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044HY05A009859
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 17:34:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 10:34:00 -0700
Date:   Mon, 4 May 2020 10:33:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 05/24] xfs: Split apart xfs_attr_leaf_addname
Message-ID: <20200504173359.GC13783@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-6-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=1
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:49:57PM -0700, Allison Collins wrote:
> Split out new helper function xfs_attr_leaf_try_add from
> xfs_attr_leaf_addname. Because new delayed attribute routines cannot
> roll transactions, we split off the parts of xfs_attr_leaf_addname that
> we can use, and move the commit into the calling function.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

<groan> I just replied to the xfsprogs version of this patch by accident. :(

Modulo the comments I made in that reply, the rest of the patch looks
ok.

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 94 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 60 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index dcbc475..b3b21a7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -256,10 +256,30 @@ xfs_attr_set_args(
>  		}
>  	}
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>  		error = xfs_attr_leaf_addname(args);
> -	else
> -		error = xfs_attr_node_addname(args);
> +		if (error != -ENOSPC)
> +			return error;
> +
> +		/*
> +		 * Commit that transaction so that the node_addname()
> +		 * call can manage its own transactions.
> +		 */
> +		error = xfs_defer_finish(&args->trans);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Commit the current trans (including the inode) and
> +		 * start a new one.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, dp);
> +		if (error)
> +			return error;
> +
> +	}
> +
> +	error = xfs_attr_node_addname(args);
>  	return error;
>  }
>  
> @@ -507,20 +527,21 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   *========================================================================*/
>  
>  /*
> - * Add a name to the leaf attribute list structure
> + * Tries to add an attribute to an inode in leaf form
>   *
> - * This leaf block cannot have a "remote" value, we only call this routine
> - * if bmap_one_block() says there is only one block (ie: no remote blks).
> + * This function is meant to execute as part of a delayed operation and leaves
> + * the transaction handling to the caller.  On success the attribute is added
> + * and the inode and transaction are left dirty.  If there is not enough space,
> + * the attr data is converted to node format and -ENOSPC is returned. Caller is
> + * responsible for handling the dirty inode and transaction or adding the attr
> + * in node format.
>   */
>  STATIC int
> -xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> +xfs_attr_leaf_try_add(
> +	struct xfs_da_args	*args,
> +	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf		*bp;
> -	int			retval, error, forkoff;
> -	struct xfs_inode	*dp = args->dp;
> -
> -	trace_xfs_attr_leaf_addname(args);
> +	int			retval, error;
>  
>  	/*
>  	 * Look up the given attribute in the leaf block.  Figure out if
> @@ -562,31 +583,39 @@ xfs_attr_leaf_addname(
>  	retval = xfs_attr3_leaf_add(bp, args);
>  	if (retval == -ENOSPC) {
>  		/*
> -		 * Promote the attribute list to the Btree format, then
> -		 * Commit that transaction so that the node_addname() call
> -		 * can manage its own transactions.
> +		 * Promote the attribute list to the Btree format. Unless an
> +		 * error occurs, retain the -ENOSPC retval
>  		 */
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +	}
> +	return retval;
> +out_brelse:
> +	xfs_trans_brelse(args->trans, bp);
> +	return retval;
> +}
>  
> -		/*
> -		 * Commit the current trans (including the inode) and start
> -		 * a new one.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
>  
> -		/*
> -		 * Fob the whole rest of the problem off on the Btree code.
> -		 */
> -		error = xfs_attr_node_addname(args);
> +/*
> + * Add a name to the leaf attribute list structure
> + *
> + * This leaf block cannot have a "remote" value, we only call this routine
> + * if bmap_one_block() says there is only one block (ie: no remote blks).
> + */
> +STATIC int
> +xfs_attr_leaf_addname(
> +	struct xfs_da_args	*args)
> +{
> +	int			error, forkoff;
> +	struct xfs_buf		*bp = NULL;
> +	struct xfs_inode	*dp = args->dp;
> +
> +	trace_xfs_attr_leaf_addname(args);
> +
> +	error = xfs_attr_leaf_try_add(args, bp);
> +	if (error)
>  		return error;
> -	}
>  
>  	/*
>  	 * Commit the transaction that added the attr name so that
> @@ -681,9 +710,6 @@ xfs_attr_leaf_addname(
>  		error = xfs_attr3_leaf_clearflag(args);
>  	}
>  	return error;
> -out_brelse:
> -	xfs_trans_brelse(args->trans, bp);
> -	return retval;
>  }
>  
>  /*
> -- 
> 2.7.4
> 

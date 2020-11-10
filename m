Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA00AC63697
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 20:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 750E620731
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 20:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kbbISRVB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbgKJUHG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 15:07:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60136 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbgKJUHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 15:07:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAK3xxV170468
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:07:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=dvNo1JOaN+rogQYcjCXwSDdFQlLVEszcZ3Y3w+N9PLQ=;
 b=kbbISRVBr2tdpfCOmiULClil3ed+sbDoPy8l5E35MCqLML516cKMlLz02SfNCTyUns9W
 auPwwic7YiddandtWWGwA18YUm07r/pSuWZ5Gte4Y/1qLuY1ycbf4c3ibwDyH+FbhvuH
 gONRxOOKoimGBds9wboRUlvgQNPHVoQJ83aEIzTCLjqWct5qopvHf5S58oHD5ulp/Mp2
 N/Qfzerfx6q9T4opE1c4EtzThIwu4OWHB8Yq6gd9TFfrwQLqt/e8xEm5wQfQuQTNBz5r
 jX06oslrvl+KR0CsahHDT/CnVY5sMkdwhNAz/umP8ohwdlHqR/lEYxdN8O4Qi4+N0xdZ Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34nkhkwkwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:07:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAK55mG150014
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:07:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34qgp7bdnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:07:03 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AAK72g7004511
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:07:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 12:07:02 -0800
Date:   Tue, 10 Nov 2020 12:07:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 09/10] xfs: Remove unused xfs_attr_*_args
Message-ID: <20201110200701.GD9695@magnolia>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-10-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023063435.7510-10-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=1 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100136
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 11:34:34PM -0700, Allison Henderson wrote:
> Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
> These high level loops are now driven by the delayed operations code,
> and can be removed.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 97 +----------------------------------------
>  fs/xfs/libxfs/xfs_attr.h        |  9 ++--
>  fs/xfs/libxfs/xfs_attr_remote.c |  4 +-
>  3 files changed, 5 insertions(+), 105 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index edd5d10..b5e1e84 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -262,65 +262,6 @@ xfs_attr_set_shortform(
>  }
>  
>  /*
> - * Checks to see if a delayed attribute transaction should be rolled.  If so,
> - * also checks for a defer finish.  Transaction is finished and rolled as
> - * needed, and returns true of false if the delayed operation should continue.
> - */
> -STATIC int
> -xfs_attr_trans_roll(
> -	struct xfs_delattr_context	*dac)
> -{
> -	struct xfs_da_args		*args = dac->da_args;
> -	int				error = 0;
> -
> -	if (dac->flags & XFS_DAC_DEFER_FINISH) {
> -		/*
> -		 * The caller wants us to finish all the deferred ops so that we
> -		 * avoid pinning the log tail with a large number of deferred
> -		 * ops.
> -		 */
> -		dac->flags &= ~XFS_DAC_DEFER_FINISH;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> -	}
> -
> -	return xfs_trans_roll_inode(&args->trans, args->dp);
> -}
> -
> -/*
> - * Set the attribute specified in @args.
> - */
> -int
> -xfs_attr_set_args(
> -	struct xfs_da_args	*args)
> -{
> -	struct xfs_buf			*leaf_bp = NULL;
> -	int				error = 0;
> -	struct xfs_delattr_context	dac = {
> -		.da_args	= args,
> -	};
> -
> -	do {
> -		error = xfs_attr_set_iter(&dac, &leaf_bp);

Now that there's only one caller of xfs_attr_set_iter and it passes
&dac->leaf_bp, I think you can get rid of this second parameter, right?

It's nice to see so much code disappear now that we track attr
operations with deferred ops.  Everything else looks ok here. :)

--D

> -		if (error != -EAGAIN)
> -			break;
> -
> -		error = xfs_attr_trans_roll(&dac);
> -		if (error)
> -			return error;
> -
> -		if (leaf_bp) {
> -			xfs_trans_bjoin(args->trans, leaf_bp);
> -			xfs_trans_bhold(args->trans, leaf_bp);
> -		}
> -
> -	} while (true);
> -
> -	return error;
> -}
> -
> -/*
>   * Set the attribute specified in @args.
>   * This routine is meant to function as a delayed operation, and may return
>   * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
> @@ -363,11 +304,7 @@ xfs_attr_set_iter(
>  		 * continue.  Otherwise, is it converted from shortform to leaf
>  		 * and -EAGAIN is returned.
>  		 */
> -		error = xfs_attr_set_shortform(args, leaf_bp);
> -		if (error == -EAGAIN)
> -			dac->flags |= XFS_DAC_DEFER_FINISH;
> -
> -		return error;
> +		return xfs_attr_set_shortform(args, leaf_bp);
>  	}
>  
>  	/*
> @@ -398,7 +335,6 @@ xfs_attr_set_iter(
>  			 * same state (inode locked and joined, transaction
>  			 * clean) no matter how we got to this step.
>  			 */
> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			return -EAGAIN;
>  		case 0:
>  			dac->dela_state = XFS_DAS_FOUND_LBLK;
> @@ -455,32 +391,6 @@ xfs_has_attr(
>  
>  /*
>   * Remove the attribute specified in @args.
> - */
> -int
> -xfs_attr_remove_args(
> -	struct xfs_da_args	*args)
> -{
> -	int				error = 0;
> -	struct xfs_delattr_context	dac = {
> -		.da_args	= args,
> -	};
> -
> -	do {
> -		error = xfs_attr_remove_iter(&dac);
> -		if (error != -EAGAIN)
> -			break;
> -
> -		error = xfs_attr_trans_roll(&dac);
> -		if (error)
> -			return error;
> -
> -	} while (true);
> -
> -	return error;
> -}
> -
> -/*
> - * Remove the attribute specified in @args.
>   *
>   * This function may return -EAGAIN to signal that the transaction needs to be
>   * rolled.  Callers should continue calling this function until they receive a
> @@ -895,7 +805,6 @@ xfs_attr_leaf_addname(
>  		if (error)
>  			return error;
>  
> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>  		return -EAGAIN;
>  	}
>  
> @@ -1192,7 +1101,6 @@ xfs_attr_node_addname(
>  			 * Restart routine from the top.  No need to set  the
>  			 * state
>  			 */
> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			return -EAGAIN;
>  		}
>  
> @@ -1205,7 +1113,6 @@ xfs_attr_node_addname(
>  		error = xfs_da3_split(state);
>  		if (error)
>  			goto out;
> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>  	} else {
>  		/*
>  		 * Addition succeeded, update Btree hashvals.
> @@ -1246,7 +1153,6 @@ xfs_attr_node_addname(
>  			if (error)
>  				return error;
>  
> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			dac->dela_state = XFS_DAS_ALLOC_NODE;
>  			return -EAGAIN;
>  		}
> @@ -1516,7 +1422,6 @@ xfs_attr_node_remove_step(
>  		if (error)
>  			return error;
>  
> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>  		dac->dela_state = XFS_DAS_RM_SHRINK;
>  		return -EAGAIN;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 8a08411..6d90301 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -244,10 +244,9 @@ enum xfs_delattr_state {
>  /*
>   * Defines for xfs_delattr_context.flags
>   */
> -#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
> -#define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename init */
> -#define XFS_DAC_LEAF_ADDNAME_INIT	0x04 /* xfs_attr_leaf_addname init*/
> -#define XFS_DAC_DELAYED_OP_INIT		0x08 /* delayed operations init*/
> +#define XFS_DAC_NODE_RMVNAME_INIT	0x01 /* xfs_attr_node_removename init */
> +#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
> +#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
>  
>  /*
>   * Context used for keeping track of delayed attribute operations
> @@ -297,11 +296,9 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
> -int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>  		      struct xfs_buf **leaf_bp);
>  int xfs_has_attr(struct xfs_da_args *args);
> -int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>  bool xfs_attr_namecheck(const void *name, size_t length);
>  void xfs_delattr_context_init(struct xfs_delattr_context *dac,
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 45c4bc5..262d1870 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -751,10 +751,8 @@ xfs_attr_rmtval_remove(
>  	if (error)
>  		return error;
>  
> -	if (!done) {
> -		dac->flags |= XFS_DAC_DEFER_FINISH;
> +	if (!done)
>  		return -EAGAIN;
> -	}
>  
>  	return error;
>  }
> -- 
> 2.7.4
> 

Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E67C3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 22:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 125EF22CED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 22:03:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FY9vvLSs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfH1WDH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 18:03:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53788 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbfH1WDH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 18:03:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SLwfir101320;
        Wed, 28 Aug 2019 22:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=CcWwd5AcdCpRI2IJlgRAnuC8rVMlbjLGWGN51U+XsXw=;
 b=FY9vvLSsESng7yUq/YSo0MlEoKsReoVrtEfmEf9u3ZSPoVe3ADtM9HAegZ+3K2MlqWL/
 /QSws6Hk7MNFz1bO8U1c3wDI0opZRrjSkN8q7NtIsELbuHo9M/DoHr2avg010PNd9f0C
 IgRnjRq+Ut6AOzl+7YUmgNpMeYypESpFa71seD0EJM4/TLHN8wG8yE1we8jmaml3J7s4
 8bgbnD75YS55BxUGxOOfxiU0juzH7QbCTqsFq1TRui3LT9hDzH8+ReMlLPe8sIrbS8tL
 5cSwM2XmdU04Zu+XLo4hljUnkZfIRfWrNvSn06fGzJeP9FcNx7js0I07h4XTxKfsLCkc zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2up1ybr0vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:03:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SLwNVG171941;
        Wed, 28 Aug 2019 22:01:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2unvtxx2dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:01:04 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7SM14Lc014805;
        Wed, 28 Aug 2019 22:01:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 15:01:03 -0700
Date:   Wed, 28 Aug 2019 15:01:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: move remote attr retrieval into
 xfs_attr3_leaf_getvalue
Message-ID: <20190828220102.GJ1037350@magnolia>
References: <20190828042350.6062-1-david@fromorbit.com>
 <20190828042350.6062-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828042350.6062-3-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280211
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908280211
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 28, 2019 at 02:23:49PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because we repeat exactly the same code to get the remote attribute
> value after both calls to xfs_attr3_leaf_getvalue() if it's a remote
> attr. Just do it in xfs_attr3_leaf_getvalue() so the callers don't
> have to care about it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 16 +---------------
>  fs/xfs/libxfs/xfs_attr_leaf.c | 35 ++++++++++++++++++-----------------
>  2 files changed, 19 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 776343c4f22b..5e6b6846e607 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -794,15 +794,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  	}
>  	error = xfs_attr3_leaf_getvalue(bp, args);
>  	xfs_trans_brelse(args->trans, bp);
> -	if (error)
> -		return error;
> -
> -	/* check if we have to retrieve a remote attribute to get the value */
> -	if (args->flags & ATTR_KERNOVAL)
> -		return 0;
> -	if (!args->rmtblkno)
> -		return 0;
> -	return xfs_attr_rmtval_get(args);
> +	return error;
>  }
>  
>  /*========================================================================
> @@ -1316,12 +1308,6 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  	 */
>  	blk = &state->path.blk[state->path.active - 1];
>  	retval = xfs_attr3_leaf_getvalue(blk->bp, args);
> -	if (retval)
> -		goto out_release;
> -	if (args->flags & ATTR_KERNOVAL)
> -		goto out_release;
> -	if (args->rmtblkno > 0)
> -		retval = xfs_attr_rmtval_get(args);
>  
>  	/*
>  	 * If not in a transaction, we have to release all the buffers.
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index d056767b5c53..e325cdbc9818 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2391,25 +2391,26 @@ xfs_attr3_leaf_getvalue(
>  		}
>  		args->valuelen = valuelen;
>  		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
> -	} else {
> -		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
> -		ASSERT(name_rmt->namelen == args->namelen);
> -		ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
> -		args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
> -		args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
> -		args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
> -						       args->rmtvaluelen);
> -		if (args->flags & ATTR_KERNOVAL) {
> -			args->valuelen = args->rmtvaluelen;
> -			return 0;
> -		}
> -		if (args->valuelen < args->rmtvaluelen) {
> -			args->valuelen = args->rmtvaluelen;
> -			return -ERANGE;
> -		}
> +		return 0;
> +	}
> +
> +	name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
> +	ASSERT(name_rmt->namelen == args->namelen);
> +	ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
> +	args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
> +	args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
> +	args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
> +					       args->rmtvaluelen);
> +	if (args->flags & ATTR_KERNOVAL) {
>  		args->valuelen = args->rmtvaluelen;
> +		return 0;
>  	}
> -	return 0;
> +	if (args->valuelen < args->rmtvaluelen) {
> +		args->valuelen = args->rmtvaluelen;
> +		return -ERANGE;
> +	}
> +	args->valuelen = args->rmtvaluelen;
> +	return xfs_attr_rmtval_get(args);
>  }
>  
>  /*========================================================================
> -- 
> 2.23.0.rc1
> 

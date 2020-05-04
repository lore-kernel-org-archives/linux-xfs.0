Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B9DC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 19:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9662206C0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 19:10:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rT75aQJD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgEDTKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 15:10:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51230 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgEDTKT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 15:10:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044J7dmF079748
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:10:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=y+Zpd3BTYDvaKFFpKbgExor98ymUqMsrDpcAAHEnxsQ=;
 b=rT75aQJD3Aeypygxp0AZY1yyKuVu/EWwSDXTjXo6fIMfAc9BC9m50/jQdkAN12Y8re0K
 ZsHM9juxP48q60RvVC5j15N0Ind+m/GzGqfrSz4GbjcJ33VlLes66VA+F9hffSsIH3lJ
 0sAHMuW14Z6XA4rtwFft4dP3KTvXqix3UeLc+K4+BDfD2jI0sqFY9/vxl0pYqibWn2LH
 0Rmq3eXgZrLSrqGskJ10MO8cgFilWoNb5vq2/pH7irr9YqR4rcArCVxtdEX1ZfsHQK/j
 vYrrfssv8CO7o8EhIfYINRXyv77BzM+11Z7loKz4AbHCyonAzFReUjG3dxXhqC+ukxnA VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30s1gn0nas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 19:10:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044J7LmI008947
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:10:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjnbkkn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 19:10:18 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044JAGnt020180
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:10:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 12:10:16 -0700
Date:   Mon, 4 May 2020 12:10:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 21/24] xfs: Lift -ENOSPC handler from
 xfs_attr_leaf_addname
Message-ID: <20200504191015.GH5703@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-22-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-22-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:13PM -0700, Allison Collins wrote:
> Lift -ENOSPC handler from xfs_attr_leaf_addname.  This will help to
> reorganize transitions between the attr forms later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Looks decent,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 9171895..c8cae68 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -299,6 +299,13 @@ xfs_attr_set_args(
>  			return error;
>  
>  		/*
> +		 * Promote the attribute list to the Btree format.
> +		 */
> +		error = xfs_attr3_leaf_to_node(args);
> +		if (error)
> +			return error;
> +
> +		/*
>  		 * Commit that transaction so that the node_addname()
>  		 * call can manage its own transactions.
>  		 */
> @@ -602,7 +609,7 @@ xfs_attr_leaf_try_add(
>  	struct xfs_da_args	*args,
>  	struct xfs_buf		*bp)
>  {
> -	int			retval, error;
> +	int			retval;
>  
>  	/*
>  	 * Look up the given attribute in the leaf block.  Figure out if
> @@ -634,20 +641,10 @@ xfs_attr_leaf_try_add(
>  	}
>  
>  	/*
> -	 * Add the attribute to the leaf block, transitioning to a Btree
> -	 * if required.
> +	 * Add the attribute to the leaf block
>  	 */
> -	retval = xfs_attr3_leaf_add(bp, args);
> -	if (retval == -ENOSPC) {
> -		/*
> -		 * Promote the attribute list to the Btree format. Unless an
> -		 * error occurs, retain the -ENOSPC retval
> -		 */
> -		error = xfs_attr3_leaf_to_node(args);
> -		if (error)
> -			return error;
> -	}
> -	return retval;
> +	return xfs_attr3_leaf_add(bp, args);
> +
>  out_brelse:
>  	xfs_trans_brelse(args->trans, bp);
>  	return retval;
> -- 
> 2.7.4
> 

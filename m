Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE752C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 23:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAEB224655
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 23:21:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V+3TxOkv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgAUXVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 18:21:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37124 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgAUXVn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 18:21:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LNIqQc016173
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:21:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=/zcN027RyNANr5orndDrsv+yy0g64bugz69iNF8pBNI=;
 b=V+3TxOkvEQrxgLZv/PvVpnHJR8lqafT8LAB34tF3+la+VuRO0+kkzZo3vxgXouhaf5P5
 Z3W5IFECSpGorXRP0oRCBF3FggMtOotNWGY0jZ1irjCNoQ2QNRYpfUlEdgphQXVLR+5C
 LijSJnHSpUCqOcsCn5YtdehT8ta+04HkQ16JBQgPuLPz/mR+MPmRDSdvERGZIkKaD4iU
 MaPjCqZVai34UDnPaNu90VN3zeyqnDJOxYrpk9nWBJ1J3lcRXGoFBWMUJ8haSSRAUQ3a
 Z0vSj5ICh9c1YYegFWOs/NWvypb92gCEHDzyLiT/tvQao/e0MetZCr1cS01cXwqJtYrO lA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyq8bkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:21:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LNJOqw011569
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:21:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xnpegsc52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:21:41 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LNLedn006839
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:21:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 15:21:40 -0800
Date:   Tue, 21 Jan 2020 15:21:39 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 12/16] xfs: Add helper function
 xfs_attr_init_unmapstate
Message-ID: <20200121232139.GL8247@magnolia>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118225035.19503-13-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 18, 2020 at 03:50:31PM -0700, Allison Collins wrote:
> This patch helps to pre-simplify xfs_attr_node_removename by modularizing
> the code around the transactions into helper functions.  This will make
> the function easier to follow when we introduce delayed attributes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 45 +++++++++++++++++++++++++++++++--------------
>  1 file changed, 31 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e9d22c1..453ea59 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1202,6 +1202,36 @@ xfs_attr_node_addname(
>  }
>  
>  /*
> + * Set up the state for unmap and set the incomplete flag

"Mark an attribute entry INCOMPLETE and save pointers to the relevant
buffers for later deletion of the entry." ?

> + */
> +STATIC int
> +xfs_attr_init_unmapstate(

I'm hung up on this name -- it marks the entry incomplete and saves some
breadcrumbs for erasing data later, which I guess is "unmap state"?
What do you think of:

xfs_attr_leaf_mark_incomplete()

> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	int error;
> +
> +	/*
> +	 * Fill in disk block numbers in the state structure
> +	 * so that we can get the buffers back after we commit
> +	 * several transactions in the following calls.
> +	 */
> +	error = xfs_attr_fillstate(state);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Mark the attribute as INCOMPLETE

Has this stopped doing the bunmapi call, or was the comment inaccurate?
I'm guessing the second if it's necessary to save state to recover
buffer pointers later...?

--D

> +	 */
> +	error = xfs_attr3_leaf_setflag(args);
> +	if (error)
> +		return error;
> +
> +	return 0;
> +}
> +
> +
> +/*
>   * Remove a name from a B-tree attribute list.
>   *
>   * This will involve walking down the Btree, and may involve joining
> @@ -1233,20 +1263,7 @@ xfs_attr_node_removename(
>  	ASSERT(blk->bp != NULL);
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  	if (args->rmtblkno > 0) {
> -		/*
> -		 * Fill in disk block numbers in the state structure
> -		 * so that we can get the buffers back after we commit
> -		 * several transactions in the following calls.
> -		 */
> -		error = xfs_attr_fillstate(state);
> -		if (error)
> -			goto out;
> -
> -		/*
> -		 * Mark the attribute as INCOMPLETE, then bunmapi() the
> -		 * remote value.
> -		 */
> -		error = xfs_attr3_leaf_setflag(args);
> +		error = xfs_attr_init_unmapstate(args, state);
>  		if (error)
>  			goto out;
>  
> -- 
> 2.7.4
> 

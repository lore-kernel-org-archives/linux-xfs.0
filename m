Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D227BFC6197
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3AA220869
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:19:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O0xPH8Iq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387457AbfKHVTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:19:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38898 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387417AbfKHVTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 16:19:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8L962e174959
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=DMu2c4W7hHD1Nbbj61IRduC/ZWiPV1UZVbjDlRSH58I=;
 b=O0xPH8IqkgMHGjveF7bYg2JwcNqqbZzFgokfxfkIjBwVn6ohW30W242ViYlcaN9U77Jx
 MrQ0XRjAHRR6fGkivDM56JORDmqRhD10vvVgxnxjFJ4TjQAPEOcPmw+33qJmOsxjXepn
 ZlBGAcc7+XL1VkRGw4IsFbnJ5HbZVaE66rWDCBi5eOyapgeaWdONEOXs1LC6RuWjFvqe
 +0ko3yCqLQS1xvcHtG5jdXE++dpCOOYCMlOqxFsJgxnZAVmF/M79Bw9zMcuNxH1674Bu
 jS65P5v9Ks8o4iw6Fu2kZc4AWbsBX1A/7PMWCboaHrWIYRTSj3jWF2vQpk0xOK3t53NA Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w17r3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:19:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8L96hZ174172
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:19:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w5bmqd4kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:19:50 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA8LJmYV013226
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:19:50 GMT
Received: from localhost (/10.159.140.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 13:19:48 -0800
Date:   Fri, 8 Nov 2019 13:19:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 13/17] xfs: Factor up trans roll in
 xfs_attr3_leaf_clearflag
Message-ID: <20191108211947.GD6219@magnolia>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107012801.22863-14-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080204
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:57PM -0700, Allison Collins wrote:
> New delayed allocation routines cannot be handling
> transactions so factor them up into the calling functions
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Looks pretty straightforward,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 16 ++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c |  5 +----
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2f9fb7a..5dcb19f 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -797,6 +797,14 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
>  		 * Added a "remote" value, just clear the incomplete flag.
>  		 */
>  		error = xfs_attr3_leaf_clearflag(args);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  	}
>  	return error;
>  }
> @@ -1154,6 +1162,14 @@ xfs_attr_node_addname(
>  		error = xfs_attr3_leaf_clearflag(args);
>  		if (error)
>  			goto out;
> +
> +		 /*
> +		  * Commit the flag value change and start the next trans in
> +		  * series.
> +		  */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +		if (error)
> +			goto out;
>  	}
>  	retval = error = 0;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 023c616..07eee3ff 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2802,10 +2802,7 @@ xfs_attr3_leaf_clearflag(
>  			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>  	}
>  
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	return xfs_trans_roll_inode(&args->trans, args->dp);
> +	return error;
>  }
>  
>  /*
> -- 
> 2.7.4
> 

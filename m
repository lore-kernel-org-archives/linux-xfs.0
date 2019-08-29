Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7806EC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44CC22189D
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:23:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SgrHIFlw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfH2VXW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:23:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57402 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2VXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 17:23:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLLD1x152054;
        Thu, 29 Aug 2019 21:23:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=DL1felT1QIOKhD8ERGc+0+v9Q3Oayir2l7iRmXV5KkA=;
 b=SgrHIFlwJVC47N00s4T5n0oA9VcOQPRpPH0steHGvNXyWa68bp/H0wIrxKkCCd5NFzpH
 9jp88BNBo+2haqvb78E+mQE7wnu2F9JTLiBYax3LRi/J+5a6JF3HPUT8tp/P2IYp6JNu
 i2c88AphNt0cEmnGVr/Jco0Nw8psN/4SWRC5wgWvhjQhPq/SEMwlvMiupBIEK4/+ewN0
 vJzBsl8iu+iqT8b0j9eRkwIIfNJwD2q+2B74ckhW9fe8JANBIoIau8YSQ6W87sYgsZNd
 1nYz5JUnW8gM6W5CX8DFwiBTYHLZkPS3iPO/GhySgECXG+47MjkxHtarP8Q1MbhnWecy 3Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2upphkg0rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:23:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLE7ZT018373;
        Thu, 29 Aug 2019 21:23:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2unvu0m8gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:23:19 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TLNJuO031417;
        Thu, 29 Aug 2019 21:23:19 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:23:19 -0700
Date:   Thu, 29 Aug 2019 14:23:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: remove unnecessary indenting from
 xfs_attr3_leaf_getvalue
Message-ID: <20190829212318.GO5354@magnolia>
References: <20190829113505.27223-1-david@fromorbit.com>
 <20190829113505.27223-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829113505.27223-3-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290214
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:35:02PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 7a9440b7ab00..c7378bc62d2b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2391,24 +2391,25 @@ xfs_attr3_leaf_getvalue(
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
> +		args->valuelen = args->rmtvaluelen;
> +		return 0;
> +	}
> +	if (args->valuelen < args->rmtvaluelen) {
>  		args->valuelen = args->rmtvaluelen;
> +		return -ERANGE;
>  	}
> +	args->valuelen = args->rmtvaluelen;
>  	return 0;
>  }
>  
> -- 
> 2.23.0.rc1
> 

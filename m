Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39676C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05BCA22CEA
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:26:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EqntMecL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfH2V0J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:26:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60172 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727926AbfH2V0I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 17:26:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLO4nH156676;
        Thu, 29 Aug 2019 21:26:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=2DI/1gfz5hKiNKzt5hYEZLSF8RchwFaA6GXCYq2uzzo=;
 b=EqntMecL6XpJCTgR94K4x7decLH+fhG1t4on+oLVasgFtvSyXUf4uKaQkaz0MFifpfcP
 8KoezMJRSCQpfhLVNm+uOWPA2GZB5cihW1MFXyzBoenD46yngI7X/CvCQD1WxBzmZqaY
 858LzkMg4LRMEyEHQdM9h1dHN1PQ9cpJcWg9yNmj1AYHWiLs0e0mCoPquJddBkcQSGyA
 4dUe3fXkunT7oLHaCqFqDC+QxZCb/DLyuvYgtDaE0IfIMijU+ewfJBNGW+gE8kFnEKR8
 LXL7racSh84u+PJXqZ0j4Kxqjc+89H4OwDAy1+cw3MPjfIYirSkAGL1wqs28bI9jGPKa FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2upphkg0xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:26:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLEBe0031384;
        Thu, 29 Aug 2019 21:26:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2upc8v59fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:26:05 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TLQ4p8027891;
        Thu, 29 Aug 2019 21:26:04 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:26:04 -0700
Date:   Thu, 29 Aug 2019 14:26:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: move remote attr retrieval into
 xfs_attr3_leaf_getvalue
Message-ID: <20190829212603.GP5354@magnolia>
References: <20190829113505.27223-1-david@fromorbit.com>
 <20190829113505.27223-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829113505.27223-4-david@fromorbit.com>
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
 definitions=main-1908290215
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:35:03PM +1000, Dave Chinner wrote:
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
>  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>  2 files changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 32879ab11290..4773eef9d3de 100644
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
> index c7378bc62d2b..8085c4f0e5a0 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2410,7 +2410,7 @@ xfs_attr3_leaf_getvalue(
>  		return -ERANGE;
>  	}
>  	args->valuelen = args->rmtvaluelen;
> -	return 0;
> +	return xfs_attr_rmtval_get(args);
>  }
>  
>  /*========================================================================
> -- 
> 2.23.0.rc1
> 

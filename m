Return-Path: <SRS0=4kkz=AY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCCBC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 16:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA993205CB
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 16:22:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S9HtlaTy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgGMQWn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 12:22:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57996 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729933AbgGMQWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 12:22:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DG2ojU153707;
        Mon, 13 Jul 2020 16:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=sSyBJNwZ2pXoRhGFlR+eKBcFGzkVt6ECSjfcpBLJueY=;
 b=S9HtlaTyvLXOUbM0ew0NDNAzfsjqlbZFLhAGepZwRNxM3BzEyZp6EN8zD0uoIjAIOtXe
 dI7RtkvsohZwLqXHl+V2xi1IAAyxjvlsqikyfCcLxASYqvHdMn98dfJNxKTKszxG2RzL
 VfT9HSyr/y/euSWGYQNQ7IW3FBhJDhj7RXjo2LUnkgcin1QgmGHmgvJFOAkPPzMD52ZJ
 Vl3ax538r9IDjGR3BNYrugWQX2JXrHEwNgQL8BXkvn1PHIQqZQRRNS3Aj2+PI0SzP8P7
 SKwYFxU0zS8Xxs6pZ5TlTIpSkBL9UfLCV706v+y971mWD9KC6VJ3TG3Xxw2odu1fxjZJ Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32762n7xj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 16:22:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DGJXDd023176;
        Mon, 13 Jul 2020 16:20:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 327q0mjpbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 16:20:35 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06DGKYQb002855;
        Mon, 13 Jul 2020 16:20:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 09:20:33 -0700
Date:   Mon, 13 Jul 2020 09:20:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] xfs: remove duplicated include from xfs_buf_item.c
Message-ID: <20200713162033.GX7606@magnolia>
References: <20200711073458.27029-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711073458.27029-1-yuehaibing@huawei.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1011 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=1 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130119
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 11, 2020 at 07:34:58AM +0000, YueHaibing wrote:
> Remove duplicated include.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf_item.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index e9428c30862a..ed1bf1d99483 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -19,7 +19,6 @@
>  #include "xfs_quota.h"
>  #include "xfs_dquot_item.h"
>  #include "xfs_dquot.h"
> -#include "xfs_trans_priv.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
>  
> 
> 
> 
> 
> 

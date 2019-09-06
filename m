Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4E6C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 01:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D86620692
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 01:10:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V0SacOI5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403862AbfIFBKw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 21:10:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50258 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403861AbfIFBKw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 21:10:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x861A15E001800;
        Fri, 6 Sep 2019 01:10:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=w1Dcv5RBWyCoNh2IJlNIjad4NWHC0GIOCdAyIeZwDf4=;
 b=V0SacOI5jkOeTVXZ5fkduY6k7IMaS/wUBqALlL1fnFb/Nj2EX30931tZP0Bo9cy2nRzm
 efQPoHRCpC+QhgIOJ6Xg0wo1+uCeULW6shThdvRRfc0UaX5p95WQ6PaxPbBA0TGz5ZPW
 GCCafuNhqyj8K5JP7iUGuVtzpftYGnJ/IzO4A/Q3+ndVD1rdnykBZ9Nj0bkPIAl/aQ9m
 uz9Ki/6WJ3wEfYTJMY6z5vvQDOayDJZxeffHIMXT8AWQRL5F3AUNHqG1eLw1S/CZ7Am7
 WLfKA58AXB9ljEXKaUgHQU8tJTwn6C/93j+5ETAgVsS5Jr3GYW6C87+CQbApASinOTzL ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uudhy804a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 01:10:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8619UcV058175;
        Fri, 6 Sep 2019 01:10:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uud7p0cu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 01:10:48 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x861AmNW011277;
        Fri, 6 Sep 2019 01:10:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 18:10:48 -0700
Date:   Thu, 5 Sep 2019 18:10:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use WARN_ON_ONCE for bailout mount-operation
Message-ID: <20190906011047.GP2229799@magnolia>
References: <20190830014110.GA20651@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830014110.GA20651@LGEARND20B15>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 10:41:10AM +0900, Austin Kim wrote:
> If the CONFIG_BUG is enabled, BUG is executed and then system is crashed.
> However, the bailout for mount is no longer proceeding.
> 
> Using WARN_ON_ONCE rather than BUG can prevent this situation.
> 
> Signed-off-by: Austin Kim <austindh.kim@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_mount.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 322da69..3ab2acf 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -214,7 +214,7 @@ xfs_initialize_perag(
>  
>  		spin_lock(&mp->m_perag_lock);
>  		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> -			BUG();
> +			WARN_ON_ONCE(1);
>  			spin_unlock(&mp->m_perag_lock);
>  			radix_tree_preload_end();
>  			error = -EEXIST;
> -- 
> 2.6.2
> 

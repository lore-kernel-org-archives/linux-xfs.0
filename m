Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BE9C63798
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 17:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF69248AA
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 17:17:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IwL17tVU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgKRRRi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 12:17:38 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52468 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgKRRRh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Nov 2020 12:17:37 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AIHAECE073044;
        Wed, 18 Nov 2020 17:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Y7RDndGVzQeN5im5B5VdCZDnnFdxreOzlbN5GxqqxM0=;
 b=IwL17tVUmIjvZI2qwSjTt3gRoA6NEBhxyEefDWG6VkprGVuz2fwUY5PokPGePLRrCJB9
 IF8wp6DnXmvd2GKkfeV37khi2xVohcKGYJLjWE9kv64CXeu12Dy3W1RTprz8OHrJ/Jtn
 FOKYcb2nFlKe2DhbE9l8mKx6ZrvRYVbegm+UHBlKZy3ssNhEKFGjTQiBd9BJwWBq2Odf
 q7UbnU3r3gd4VCh+1Iaxjtha+SBgiEdU37Htm9mFEeU75toUikh8lLAsNJ8nrc+d5uQw
 xeeYwB2SZxh6bAnwIMOlsghjJIRP2JwohlCNOJssY1WtFQpYpjSB0nSS+Tnw2aJkQiv8 Mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34t7vn956x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Nov 2020 17:17:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AIHBLkR091763;
        Wed, 18 Nov 2020 17:17:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34umd0u0hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 17:17:26 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AIHHPo3032243;
        Wed, 18 Nov 2020 17:17:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Nov 2020 09:17:24 -0800
Date:   Wed, 18 Nov 2020 09:17:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, zhangxiaoxu5@huawei.com
Subject: Re: [PATCH] xfs: return corresponding errcode if
 xfs_initialize_perag() fail
Message-ID: <20201118171723.GC9695@magnolia>
References: <20201118111531.455814-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118111531.455814-1-yukuai3@huawei.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9809 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9809 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180119
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 18, 2020 at 07:15:31PM +0800, Yu Kuai wrote:
> In xfs_initialize_perag(), if kmem_zalloc(), xfs_buf_hash_init(), or
> radix_tree_preload() failed, the returned value 'error' is not set
> accordingly.
> 
> Fixes: commit 8b26c5825e02 ("xfs: handle ENOMEM correctly during initialisation of perag structures")

/me suspects you really want

Fixes: 9b2471797942 ("xfs: cache unlinked pointers in an rhashtable")

but otherwise this is legit.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  fs/xfs/xfs_mount.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 150ee5cb8645..7110507a2b6b 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -194,20 +194,25 @@ xfs_initialize_perag(
>  		}
>  
>  		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
> -		if (!pag)
> +		if (!pag) {
> +			error = -ENOMEM;
>  			goto out_unwind_new_pags;
> +		}
>  		pag->pag_agno = index;
>  		pag->pag_mount = mp;
>  		spin_lock_init(&pag->pag_ici_lock);
>  		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
> -		if (xfs_buf_hash_init(pag))
> +
> +		error = xfs_buf_hash_init(pag);
> +		if (error)
>  			goto out_free_pag;
>  		init_waitqueue_head(&pag->pagb_wait);
>  		spin_lock_init(&pag->pagb_lock);
>  		pag->pagb_count = 0;
>  		pag->pagb_tree = RB_ROOT;
>  
> -		if (radix_tree_preload(GFP_NOFS))
> +		error = radix_tree_preload(GFP_NOFS);
> +		if (error)
>  			goto out_hash_destroy;
>  
>  		spin_lock(&mp->m_perag_lock);
> -- 
> 2.25.4
> 

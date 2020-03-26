Return-Path: <SRS0=JvtZ=5L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB344C43331
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 05:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 833092070A
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 05:05:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CDoQk2Ik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgCZFF1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 01:05:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52706 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgCZFF1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 01:05:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02Q536Dg166788;
        Thu, 26 Mar 2020 05:05:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=i/MPR1l0dczxt8Yz1toSPPG0zMUkkngUPwgUt3cx2jY=;
 b=CDoQk2IkV0ch4jmBpy2JWHJaXbNkOgkHAWBcxGlvHBFdDyOyregRejSW+GokSjWlZiRY
 1CBh9ddNJplsqpVq4vuBiMlcwMeuCty7dRdrc6tFw4RSFQeAxm1K2/RFsX9/XUI30AIH
 7GaP9tagAY0V8SrcNwbX9X55ZAh/P7pksC/L6/XqZWMDnDGLbTBbBvaoLMIWbO39G+ss
 dGD14YtwlTfCYGq4SkbdiNZQ2er+TThFSjqnpvsGJ8pxvb6BXWLkgd0rKpmDsYy+FAlK
 m0M+YBkAUPo0U+5kKcKcbKGv/a/5XVpLaCU4SOmXB8vGtG01Kv9/oD7mP/mHktnjvJpx sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ywavmdgg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 05:05:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02Q52anx015415;
        Thu, 26 Mar 2020 05:05:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30073c8jmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 05:05:24 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02Q55NCq014895;
        Thu, 26 Mar 2020 05:05:23 GMT
Received: from localhost (/10.159.237.96)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Mar 2020 22:05:23 -0700
Date:   Wed, 25 Mar 2020 22:05:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: Improve metadata buffer reclaim accountability
Message-ID: <20200326050522.GA29339@magnolia>
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325014205.11843-5-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9571 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=2 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003260031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9571 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=2 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003260031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 12:42:01PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The buffer cache shrinker frees more than just the xfs_buf slab
> objects - it also frees the pages attached to the buffers. Make sure
> the memory reclaim code accounts for this memory being freed
> correctly, similar to how the inode shrinker accounts for pages
> freed from the page cache due to mapping invalidation.
> 
> We also need to make sure that the mm subsystem knows these are
> reclaimable objects. We provide the memory reclaim subsystem with a
> a shrinker to reclaim xfs_bufs, so we should really mark the slab
> that way.
> 
> We also have a lot of xfs_bufs in a busy system, spread them around
> like we do inodes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks decent,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f880141a22681..9ec3eaf1c618f 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -327,6 +327,9 @@ xfs_buf_free(
>  
>  			__free_page(page);
>  		}
> +		if (current->reclaim_state)
> +			current->reclaim_state->reclaimed_slab +=
> +							bp->b_page_count;
>  	} else if (bp->b_flags & _XBF_KMEM)
>  		kmem_free(bp->b_addr);
>  	_xfs_buf_free_pages(bp);
> @@ -2114,9 +2117,11 @@ xfs_buf_delwri_pushbuf(
>  int __init
>  xfs_buf_init(void)
>  {
> -	xfs_buf_zone = kmem_cache_create("xfs_buf",
> -					 sizeof(struct xfs_buf), 0,
> -					 SLAB_HWCACHE_ALIGN, NULL);
> +	xfs_buf_zone = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
> +					 SLAB_HWCACHE_ALIGN |
> +					 SLAB_RECLAIM_ACCOUNT |
> +					 SLAB_MEM_SPREAD,
> +					 NULL);
>  	if (!xfs_buf_zone)
>  		goto out;
>  
> -- 
> 2.26.0.rc2
> 

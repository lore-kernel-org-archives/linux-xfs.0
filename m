Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24AAC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 05:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D9522074A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 05:43:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y54UPlR4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgGXFnn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 01:43:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34326 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgGXFnm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 01:43:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06O5cP0s065696;
        Fri, 24 Jul 2020 05:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=VIo4FYpjFm5+NIyGSgCJLUdoy9aE8bd6gPe0wttPKtY=;
 b=Y54UPlR4KEwmEoElggW3CqVkumcVv/rqvHjNrOV0REGEebSOg7NgrgvB0Iv1BqD1rWp+
 jln/DTmgh+bmeOQtnqbsBnhdydebFF6lx4BJ8wd/PIi8Z3aAj5hRJyuRcKn2xisqRgY7
 KH1CLjOvqn3pRcS5Ei6Udb1xIetU4SqisACo4aZaU8r9zueLs9AYJ7KTt5RAmjKFBo+d
 3A3nQNf09Td6sjoyjKHo4taCgxC0DQYpnj0N2AG7hVEaoZJ/myhENxDzmmG1ircHA6cZ
 HUoIpur1PsU71hB8SoGd3awUe4oq0pid6xjVT/fy0tx8M12QTCzM7EGmUOCLYn+a8q5k Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32bs1mw73x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 Jul 2020 05:43:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06O5dBO4154074;
        Fri, 24 Jul 2020 05:41:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32fhy6sswp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 05:41:39 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06O5ackh007852;
        Fri, 24 Jul 2020 05:36:38 GMT
Received: from localhost (/10.159.156.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jul 2020 22:36:38 -0700
Date:   Thu, 23 Jul 2020 22:36:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: Remove kmem_zone_alloc() usage
Message-ID: <20200724053637.GQ3151642@magnolia>
References: <20200722090518.214624-1-cmaiolino@redhat.com>
 <20200722090518.214624-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722090518.214624-2-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=5
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 22, 2020 at 11:05:14AM +0200, Carlos Maiolino wrote:
> Use kmem_cache_alloc() directly.
> 
> All kmem_zone_alloc() users pass 0 as flags, which are translated into:
> GFP_KERNEL | __GFP_NOWARN, and kmem_zone_alloc() loops forever until the
> allocation succeeds.
> 
> We can use __GFP_NOFAIL to tell the allocator to loop forever rather
> than doing it ourself, and because the allocation will never fail, we do
> not need to use __GFP_NOWARN anymore. Hence, all callers can be
> converted to use GFP_KERNEL | __GFP_NOFAIL
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok to me too (I put the comment back in),
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Changelog:
> 	V2:
> 		- Wire up xfs_inode_alloc to use __GFP_NOFAIL
> 		  if it's called inside a transaction
> 		- Rewrite changelog in a more decent way.
> 	V3:
> 		- Use __GFP_NOFAIL unconditionally in xfs_inode_alloc(),
> 		  use of PF_FSTRANS will be added when the patch re-adding
> 		  it is moved to mainline.
> 
>  fs/xfs/libxfs/xfs_alloc.c |  3 ++-
>  fs/xfs/libxfs/xfs_bmap.c  |  3 ++-
>  fs/xfs/xfs_icache.c       | 10 ++--------
>  3 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 203e74fa64aa6..583242253c027 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2467,7 +2467,8 @@ xfs_defer_agfl_block(
>  	ASSERT(xfs_bmap_free_item_zone != NULL);
>  	ASSERT(oinfo != NULL);
>  
> -	new = kmem_zone_alloc(xfs_bmap_free_item_zone, 0);
> +	new = kmem_cache_alloc(xfs_bmap_free_item_zone,
> +			       GFP_KERNEL | __GFP_NOFAIL);
>  	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
>  	new->xefi_blockcount = 1;
>  	new->xefi_oinfo = *oinfo;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 667cdd0dfdf4a..fd5c0d669d0d7 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -553,7 +553,8 @@ __xfs_bmap_add_free(
>  #endif
>  	ASSERT(xfs_bmap_free_item_zone != NULL);
>  
> -	new = kmem_zone_alloc(xfs_bmap_free_item_zone, 0);
> +	new = kmem_cache_alloc(xfs_bmap_free_item_zone,
> +			       GFP_KERNEL | __GFP_NOFAIL);
>  	new->xefi_startblock = bno;
>  	new->xefi_blockcount = (xfs_extlen_t)len;
>  	if (oinfo)
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 58a750ce689c0..c2d97e4f131fb 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -36,14 +36,8 @@ xfs_inode_alloc(
>  {
>  	struct xfs_inode	*ip;
>  
> -	/*
> -	 * if this didn't occur in transactions, we could use
> -	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
> -	 * code up to do this anyway.
> -	 */
> -	ip = kmem_zone_alloc(xfs_inode_zone, 0);
> -	if (!ip)
> -		return NULL;
> +	ip = kmem_cache_alloc(xfs_inode_zone, GFP_KERNEL | __GFP_NOFAIL);
> +
>  	if (inode_init_always(mp->m_super, VFS_I(ip))) {
>  		kmem_cache_free(xfs_inode_zone, ip);
>  		return NULL;
> -- 
> 2.26.2
> 

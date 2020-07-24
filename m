Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D92C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 05:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1713206D8
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 05:39:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LNfm5cjt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGXFjy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 01:39:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39358 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgGXFjy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 01:39:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06O5aZlu105336;
        Fri, 24 Jul 2020 05:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hYFYwWih6MxetaqZxFwalGNQlXg8m5UYx6St8yfFImk=;
 b=LNfm5cjtJx5OHN2ImFNoOcbC0Ha6TvYdcW49kzQywQKoE1DorpAlM2xHLZ/VVPO2thRQ
 gfM/De43LV1N2k2fOO0OtCdcZReQQCLzkLh1p8dkAGMY73fBZV9FKQiM0JGXvMhC1yem
 w9qhgJ4j/wbnlu61TAZJ7cp5yF00px/BRjpUJa+BnFbg//ACOo0jwQRBiA+xt8dG6Y3Z
 FgPGUNVgG0tetS+TdnRh1wpJ9Q8t6RAhrapH2L/kU1AY87uweCn5VWJwXSLFVwQId78n
 4TBVtBDhGgblyPcvz+wXX4QrIEfpIKqr4Fz5vTWq3tgIVupVRT7O5D2NezyEYhGOzMLw PA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32brgrw84f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 Jul 2020 05:39:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06O5dBxx153984;
        Fri, 24 Jul 2020 05:39:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32fhy6sq2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 05:39:50 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06O5dn88016467;
        Fri, 24 Jul 2020 05:39:49 GMT
Received: from localhost (/10.159.156.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jul 2020 22:39:48 -0700
Date:   Thu, 23 Jul 2020 22:39:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: Modify xlog_ticket_alloc() to use kernel's MM
 API
Message-ID: <20200724053947.GS3151642@magnolia>
References: <20200722090518.214624-1-cmaiolino@redhat.com>
 <20200722090518.214624-4-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722090518.214624-4-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 22, 2020 at 11:05:16AM +0200, Carlos Maiolino wrote:
> xlog_ticket_alloc() is always called under NOFS context, except from
> unmount path, which eitherway is holding many FS locks, so, there is no
> need for its callers to keep passing allocation flags into it.
> 
> change xlog_ticket_alloc() to use default kmem_cache_zalloc(), remove
> its alloc_flags argument, and always use GFP_NOFS | __GFP_NOFAIL flags.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks decent,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Changelog:
> 	V2:
> 		- Remove alloc_flags argument from xlog_ticket_alloc()
> 		  and update patch description accordingly.
> 
>  fs/xfs/xfs_log.c      | 9 +++------
>  fs/xfs/xfs_log_cil.c  | 3 +--
>  fs/xfs/xfs_log_priv.h | 4 +---
>  3 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 00fda2e8e7380..ad0c69ee89475 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -433,7 +433,7 @@ xfs_log_reserve(
>  	XFS_STATS_INC(mp, xs_try_logspace);
>  
>  	ASSERT(*ticp == NULL);
> -	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
> +	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent);
>  	*ticp = tic;
>  
>  	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
> @@ -3408,15 +3408,12 @@ xlog_ticket_alloc(
>  	int			unit_bytes,
>  	int			cnt,
>  	char			client,
> -	bool			permanent,
> -	xfs_km_flags_t		alloc_flags)
> +	bool			permanent)
>  {
>  	struct xlog_ticket	*tic;
>  	int			unit_res;
>  
> -	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
> -	if (!tic)
> -		return NULL;
> +	tic = kmem_cache_zalloc(xfs_log_ticket_zone, GFP_NOFS | __GFP_NOFAIL);
>  
>  	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 9ed90368ab311..56c32eecffead 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -37,8 +37,7 @@ xlog_cil_ticket_alloc(
>  {
>  	struct xlog_ticket *tic;
>  
> -	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0,
> -				KM_NOFS);
> +	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0);
>  
>  	/*
>  	 * set the current reservation to zero so we know to steal the basic
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 75a62870b63af..1c6fdbf3d5066 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -464,9 +464,7 @@ xlog_ticket_alloc(
>  	int		unit_bytes,
>  	int		count,
>  	char		client,
> -	bool		permanent,
> -	xfs_km_flags_t	alloc_flags);
> -
> +	bool		permanent);
>  
>  static inline void
>  xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
> -- 
> 2.26.2
> 

Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7B9C433E3
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 05:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A92620748
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 05:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VjW1HHX4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgGXFmT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 01:42:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38060 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgGXFmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 01:42:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06O5dxoJ036319;
        Fri, 24 Jul 2020 05:42:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aAlB8KWrY5Qsejyokljdt8Yd989YDg3ijbUXTKaFslk=;
 b=VjW1HHX4rxr7ck/xddYHZs/Kq1V9/jkrxzQOp2ZONgJe4/ElU4lIPuqSpBmHvISqKwVU
 pu7Ep+TwfBeePeolyYFL2iV+CN5WtyU8N3gP4t8cnWunCv1RqL9pcZf0+ep9b6+OD1bg
 hNz00ZzfE8iY7WrSOqjsLN5j0mWEVNoboASTiES/CIBE9M0ekc82V3Z90pfGga6eoi8i
 vYXVbIMh8IziK3uScg48W88Dovo5Kn7GMSTiNiC7PdG/QDDMvI3yynTUpDfLnSEohXw2
 u5UofXyjrZozBE8vbO6YniYera+cPAjruUq1s4Shc9Oz7b8HmZqht8raI++L9ue1l/DY qQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32d6kt1eyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 Jul 2020 05:42:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06O5cBYA105279;
        Fri, 24 Jul 2020 05:42:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32fn6q0qr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 05:42:14 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06O5e8nw026343;
        Fri, 24 Jul 2020 05:40:08 GMT
Received: from localhost (/10.159.156.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 05:40:08 +0000
Date:   Thu, 23 Jul 2020 22:40:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: remove xfs_zone_{alloc,zalloc} helpers
Message-ID: <20200724054005.GT3151642@magnolia>
References: <20200722090518.214624-1-cmaiolino@redhat.com>
 <20200722090518.214624-5-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722090518.214624-5-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=1 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 22, 2020 at 11:05:17AM +0200, Carlos Maiolino wrote:
> All their users have been converted to use MM API directly, no need to
> keep them around anymore.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Neato!!!!
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/kmem.c      | 21 ---------------------
>  fs/xfs/kmem.h      |  8 --------
>  fs/xfs/xfs_trace.h |  1 -
>  3 files changed, 30 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index f1366475c389c..e841ed781a257 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -115,24 +115,3 @@ kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
>  		congestion_wait(BLK_RW_ASYNC, HZ/50);
>  	} while (1);
>  }
> -
> -void *
> -kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
> -{
> -	int	retries = 0;
> -	gfp_t	lflags = kmem_flags_convert(flags);
> -	void	*ptr;
> -
> -	trace_kmem_zone_alloc(kmem_cache_size(zone), flags, _RET_IP_);
> -	do {
> -		ptr = kmem_cache_alloc(zone, lflags);
> -		if (ptr || (flags & KM_MAYFAIL))
> -			return ptr;
> -		if (!(++retries % 100))
> -			xfs_err(NULL,
> -		"%s(%u) possible memory allocation deadlock in %s (mode:0x%x)",
> -				current->comm, current->pid,
> -				__func__, lflags);
> -		congestion_wait(BLK_RW_ASYNC, HZ/50);
> -	} while (1);
> -}
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 34cbcfde92281..8e8555817e6d3 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -85,14 +85,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
>  #define kmem_zone	kmem_cache
>  #define kmem_zone_t	struct kmem_cache
>  
> -extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
> -
> -static inline void *
> -kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
> -{
> -	return kmem_zone_alloc(zone, flags | KM_ZERO);
> -}
> -
>  static inline struct page *
>  kmem_to_page(void *addr)
>  {
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 50c478374a31b..627fe4fef9ac7 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3536,7 +3536,6 @@ DEFINE_KMEM_EVENT(kmem_alloc);
>  DEFINE_KMEM_EVENT(kmem_alloc_io);
>  DEFINE_KMEM_EVENT(kmem_alloc_large);
>  DEFINE_KMEM_EVENT(kmem_realloc);
> -DEFINE_KMEM_EVENT(kmem_zone_alloc);
>  
>  TRACE_EVENT(xfs_check_new_dalign,
>  	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
> -- 
> 2.26.2
> 

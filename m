Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D848C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 18:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6744321826
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 18:59:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mc0+iXp7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfKTS71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:59:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56848 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfKTS70 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 13:59:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIxK5A020125;
        Wed, 20 Nov 2019 18:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=t7BcD/RlUedKbuW6MMeEPrrdQ/0V3eLUE10Fq53Vqjs=;
 b=Mc0+iXp7txsfalHfZ4zMO00tKcMHRVnKy7c+GPsqJT7Sk1gjYe1K+u4j2EuHnBzuyjlm
 fAD7ClrteR6i5znzMH7i2KLgDWjOLUgdZBe0E4o1y5b19Nq5LDc/dgjGNj+KMZOt5odm
 PzbmJjyC5Ii6m9sWJUo+oyHPEoFgn/ow4+msksKbFljXjWV1dbLA41vx0NFpxGkesCdn
 Wu9+WobU4pxlup1QlRU2dZyr8h/LQ2x0OeuZy26qF3vFpR4wLSw85+OwNNkt2y9GtZ5f
 0njyJ7A7A0c9thcjGGEEmYbpGlZZooJwAKfxKoyYCdQ9ThlprQCLWeOx5h1udPT3Us5p nA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wa92pyhg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:59:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIx8NI177304;
        Wed, 20 Nov 2019 18:59:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wda04kqup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:59:14 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAKIwaCC015846;
        Wed, 20 Nov 2019 18:58:36 GMT
Received: from localhost (/10.159.246.236)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 10:58:36 -0800
Date:   Wed, 20 Nov 2019 10:58:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 2/5] xfs: Remove kmem_zone_alloc() wrapper
Message-ID: <20191120185835.GO6219@magnolia>
References: <20191120104425.407213-1-cmaiolino@redhat.com>
 <20191120104425.407213-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120104425.407213-3-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 11:44:22AM +0100, Carlos Maiolino wrote:
> __GFP_NOFAIL can be used for an infinite retry + congestion_wait, so we
> can use kmem_cache_alloc() directly.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> V2:
> 	- Rephrase commit log to explain why it's ok to remove the retry
> 	  loop from kmem_zone_alloc().
> 
>  fs/xfs/kmem.c             | 21 ---------------------
>  fs/xfs/kmem.h             |  2 --
>  fs/xfs/libxfs/xfs_alloc.c |  3 ++-
>  fs/xfs/libxfs/xfs_bmap.c  |  3 ++-
>  fs/xfs/xfs_icache.c       |  2 +-
>  fs/xfs/xfs_trace.h        |  1 -
>  6 files changed, 5 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index 1da94237a8cf..2644fdaa0549 100644
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
> index 3242de676808..7e4ad73771ce 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -76,8 +76,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
>  #define kmem_zone	kmem_cache
>  #define kmem_zone_t	struct kmem_cache
>  
> -extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
> -
>  static inline struct page *
>  kmem_to_page(void *addr)
>  {
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 675613c7bacb..42cae87bdd2d 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2351,7 +2351,8 @@ xfs_defer_agfl_block(
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
> index 9fbdca183465..37596e49b92e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -554,7 +554,8 @@ __xfs_bmap_add_free(
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
> index 950e8a51ec66..985f48e3795f 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -40,7 +40,7 @@ xfs_inode_alloc(
>  	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
>  	 * code up to do this anyway.
>  	 */
> -	ip = kmem_zone_alloc(xfs_inode_zone, 0);
> +	ip = kmem_cache_alloc(xfs_inode_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	if (!ip)
>  		return NULL;
>  	if (inode_init_always(mp->m_super, VFS_I(ip))) {
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index c13bb3655e48..192f499ccd7e 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3571,7 +3571,6 @@ DEFINE_KMEM_EVENT(kmem_alloc);
>  DEFINE_KMEM_EVENT(kmem_alloc_io);
>  DEFINE_KMEM_EVENT(kmem_alloc_large);
>  DEFINE_KMEM_EVENT(kmem_realloc);
> -DEFINE_KMEM_EVENT(kmem_zone_alloc);
>  
>  #endif /* _TRACE_XFS_H */
>  
> -- 
> 2.23.0
> 

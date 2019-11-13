Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BA5C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 17:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E52206D3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 17:28:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i2YsOXen"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfKMR20 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 12:28:26 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57056 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfKMR20 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 12:28:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADHNjqY040512;
        Wed, 13 Nov 2019 17:28:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RzhkY0I8yLPhJ1MRNHRXQiNH91fV1ehwChyPUQR3UNI=;
 b=i2YsOXenkY7dWJdLmTBktYFG0gS+Bvf8LOZgmgOBrG6pS4MIEiqdVsjPqTsJdV40ac9F
 7i6vHgw5lG/Mu1U9PIhU1WDghT5gvV2NG6hdYvvyzgpXEQxWFvncEAJ6jXMhiYccqc9h
 eEgafSQHVPEYdORDgYYaErVjutyH1RK34V4rRGT2nxNcARTh6sZ6NlV79BGnYTD1d39J
 ztC6CIByuP1Hl/HCpSxMoy756qgyDEPNga5WfKzplGKKU5fOR0hX/quHNzGIVfNXMeY3
 QRvPHJjrThSWKEUrrpxZUtI0r9bA8mAtQYHGLZ6R4y0zprBCIq5uRkwOPU2NhxZHKcMw 6w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w5p3qwy1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:28:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADHN11o144588;
        Wed, 13 Nov 2019 17:28:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w8g17vkd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:28:22 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xADHSLOo015743;
        Wed, 13 Nov 2019 17:28:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 09:28:21 -0800
Date:   Wed, 13 Nov 2019 09:28:20 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: Remove kmem_zone_alloc() wrapper
Message-ID: <20191113172820.GB6219@magnolia>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-6-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113142335.1045631-6-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 03:23:29PM +0100, Carlos Maiolino wrote:
> Use kmem_cache_alloc() directly.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
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

Heh, nobody was using KM_MAYFAIL here at all? :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
> index c12ab170c396..33523a0b5801 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -81,8 +81,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
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

Comment needs updating.  How about:

	/*
	 * If this didn't occur in transactions, we could omit
	 * __GFP_NOFAIL and return NULL here on ENOMEM. Set the
	 * code up to do this anyway.
	 */

Looks ok other than that, though even with the full series applied I
still see a few mentions of KM_* flags in comments.

--D

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

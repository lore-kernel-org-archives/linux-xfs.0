Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FEFC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 14:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 219A522CB3
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 14:55:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lGl3haOh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgH0OzR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 10:55:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37026 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgH0OzE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 10:55:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07REohCP149021;
        Thu, 27 Aug 2020 14:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=yslJy3c0uQsTHT2gf9jVUbk2QTH7c+XVmm5eDmaqU9A=;
 b=lGl3haOhTh8zVppsslYkFFbJqRyXmq9QgjyKWJ50aYv6UbpmqwEsxrjYkPI6ox8tM0x/
 QKwnzWMSd/fXwJw4cNhE0HndmQV6ACnNUjvV9MWc3pi4wayceWZhLpWBZ9ktk0nt4XHl
 ovGYgOfzXnGVbOpq80ujxkGWBSVAXuIcSVNxeqvyQGMQFy/XmF7rHhwEMcjUbvn4S0Mm
 lrb1UkTV94XMsTNZ48vF9tGMNsbabyIVXc4xe53WsGERlHrV5xFSTH0mToQo9L5RaC7u
 J73AnWLfZqFS9g6bC1noNYhNo9skDtk1G8bGHnwPqsdxnNnbKyUu/ZhgNA2ZudHkfhTJ TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 335gw88pht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Aug 2020 14:55:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07REoK8G104011;
        Thu, 27 Aug 2020 14:54:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 333rud7p8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 14:54:59 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07REswnp011125;
        Thu, 27 Aug 2020 14:54:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 07:54:57 -0700
Date:   Thu, 27 Aug 2020 07:54:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V3] xfs: Remove kmem_zalloc_large()
Message-ID: <20200827145457.GS6096@magnolia>
References: <20200827092417.7973-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827092417.7973-1-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=5 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 lowpriorityscore=0
 mlxscore=0 phishscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270114
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 11:24:17AM +0200, Carlos Maiolino wrote:
> This patch aims to replace kmem_zalloc_large() with global kernel memory
> API. So, all its callers are now using kvzalloc() directly, so kmalloc()
> fallsback to vmalloc() automatically.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Changelog:
> 
> 	V2:
> 		Remove __GFP_RETRY_MAYFAIL from the kvzalloc() calls
> 	V3:
> 		Remove extra newline
> 
>  fs/xfs/kmem.h          | 6 ------
>  fs/xfs/scrub/symlink.c | 2 +-
>  fs/xfs/xfs_acl.c       | 2 +-
>  fs/xfs/xfs_ioctl.c     | 4 ++--
>  fs/xfs/xfs_rtalloc.c   | 2 +-
>  5 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index fb1d066770723..38007117697ef 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -71,12 +71,6 @@ kmem_zalloc(size_t size, xfs_km_flags_t flags)
>  	return kmem_alloc(size, flags | KM_ZERO);
>  }
>  
> -static inline void *
> -kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
> -{
> -	return kmem_alloc_large(size, flags | KM_ZERO);
> -}
> -
>  /*
>   * Zone interfaces
>   */
> diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
> index 5641ae512c9ef..c08be5ede0661 100644
> --- a/fs/xfs/scrub/symlink.c
> +++ b/fs/xfs/scrub/symlink.c
> @@ -22,7 +22,7 @@ xchk_setup_symlink(
>  	struct xfs_inode	*ip)
>  {
>  	/* Allocate the buffer without the inode lock held. */
> -	sc->buf = kmem_zalloc_large(XFS_SYMLINK_MAXLEN + 1, 0);
> +	sc->buf = kvzalloc(XFS_SYMLINK_MAXLEN + 1, GFP_KERNEL);
>  	if (!sc->buf)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index d4c687b5cd067..c544951a0c07f 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -192,7 +192,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  
>  	if (acl) {
>  		args.valuelen = XFS_ACL_SIZE(acl->a_count);
> -		args.value = kmem_zalloc_large(args.valuelen, 0);
> +		args.value = kvzalloc(args.valuelen, GFP_KERNEL);
>  		if (!args.value)
>  			return -ENOMEM;
>  		xfs_acl_to_disk(args.value, acl);
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6f22a66777cd0..4428b893f8372 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -404,7 +404,7 @@ xfs_ioc_attr_list(
>  	     context.cursor.offset))
>  		return -EINVAL;
>  
> -	buffer = kmem_zalloc_large(bufsize, 0);
> +	buffer = kvzalloc(bufsize, GFP_KERNEL);
>  	if (!buffer)
>  		return -ENOMEM;
>  
> @@ -1690,7 +1690,7 @@ xfs_ioc_getbmap(
>  	if (bmx.bmv_count > ULONG_MAX / recsize)
>  		return -ENOMEM;
>  
> -	buf = kmem_zalloc_large(bmx.bmv_count * sizeof(*buf), 0);
> +	buf = kvzalloc(bmx.bmv_count * sizeof(*buf), GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6209e7b6b895b..0558f92ecdb83 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -862,7 +862,7 @@ xfs_alloc_rsum_cache(
>  	 * lower bound on the minimum level with any free extents. We can
>  	 * continue without the cache if it couldn't be allocated.
>  	 */
> -	mp->m_rsum_cache = kmem_zalloc_large(rbmblocks, 0);
> +	mp->m_rsum_cache = kvzalloc(rbmblocks, GFP_KERNEL);
>  	if (!mp->m_rsum_cache)
>  		xfs_warn(mp, "could not allocate realtime summary cache");
>  }
> -- 
> 2.26.2
> 

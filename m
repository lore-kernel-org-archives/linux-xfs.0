Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0301C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 16:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B80D42078B
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 16:46:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kdpn5WQr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgHZQqU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 12:46:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44164 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgHZQpt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 12:45:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QGjHEs009180;
        Wed, 26 Aug 2020 16:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7+G2P1AlTibMZ0nvG/xklh07G0bOHO6xqQyBNhbR6c0=;
 b=kdpn5WQrijhic98wvHqRq7nM4Fa9lfWLthQR96eIzVsi/caalyS7TM7/W4fX4qp4BqIT
 1Va+fDebKByzZ6mtlhuD6AG5aQ69xJgyZVugNZrauadGYi1h/S0jP79XC6ITQ9mB03Iv
 0cOdCoPePeSXESnsYUBVdZXQ5D4hWgOdcSrpj9jBteLB3jwW3r/myQ1Ov2vDA5Qod/1R
 rksHfcBxv6gxNY6tafKPtVNu2ukXSBj9w2Xv/W1fBu4jccgFr5+jLRDeyD9FYk+P2zGw
 09FJUPqTKR1bvFoNcWP4OOQGMH5hd5yKGyNkyoh8/H8+uw1R5buOafHm8Bjt50KoBtnG Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 333w6u05gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 16:45:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QGiqE4107833;
        Wed, 26 Aug 2020 16:45:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 333r9mcnpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 16:45:43 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07QGjfbU028505;
        Wed, 26 Aug 2020 16:45:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 09:45:41 -0700
Date:   Wed, 26 Aug 2020 09:45:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: Remove kmem_zalloc_large()
Message-ID: <20200826164540.GQ6096@magnolia>
References: <20200826161402.55132-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826161402.55132-1-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008260124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=5 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008260124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 06:14:02PM +0200, Carlos Maiolino wrote:
> This patch aims to replace kmem_zalloc_large() with global kernel memory
> API. So, all its callers are now using kvzalloc() directly, so kmalloc()
> fallsback to vmalloc() automatically.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Changelog:
> 
> 	V2:
> 		Remove __GFP_RETRY_MAYFAIL from the kvzalloc() calls
> 
>  fs/xfs/kmem.h          | 6 ------
>  fs/xfs/scrub/symlink.c | 3 ++-
>  fs/xfs/xfs_acl.c       | 2 +-
>  fs/xfs/xfs_ioctl.c     | 4 ++--
>  fs/xfs/xfs_rtalloc.c   | 2 +-
>  5 files changed, 6 insertions(+), 11 deletions(-)
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
> index 5641ae512c9ef..5a721a9adea78 100644
> --- a/fs/xfs/scrub/symlink.c
> +++ b/fs/xfs/scrub/symlink.c
> @@ -22,11 +22,12 @@ xchk_setup_symlink(
>  	struct xfs_inode	*ip)
>  {
>  	/* Allocate the buffer without the inode lock held. */
> -	sc->buf = kmem_zalloc_large(XFS_SYMLINK_MAXLEN + 1, 0);
> +	sc->buf = kvzalloc(XFS_SYMLINK_MAXLEN + 1, GFP_KERNEL);
>  	if (!sc->buf)
>  		return -ENOMEM;
>  
>  	return xchk_setup_inode_contents(sc, ip, 0);
> +

Nit: empty line added here.

Everything else looks fine to me.

--D

>  }
>  
>  /* Symbolic links. */
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

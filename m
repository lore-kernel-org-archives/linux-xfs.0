Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5195EC432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 18:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5389A206EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 18:14:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vo785R2Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfKMSOh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 13:14:37 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54244 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKMSOh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 13:14:37 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADI99MS081003;
        Wed, 13 Nov 2019 18:14:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=CZtJEosxo3TR49Q/SsCZGENEm1uCdHSSQAX5/Hw+Fu4=;
 b=Vo785R2QersqVwwFGc9+MzQqw5k5PgtN7wtZenSALgeoNF+RdfcOLzJNUgokcRldO5Rg
 Lp9kCiaDFyNLO1/4BHKb0E2OuxV39RfvttNjOTI3bnPuDwlVzj7VsQWAhiVQi4ogKuEp
 sPSJuGHTqUq0goacIq7LmI6I0J+1kO6WlS6ZnBjtimAZlyfFc4mMoZjGzlN65OMBIqxU
 /Hh9LTOoDPV3jai1NBjqK7WPiPtZ7VuzIiQ/JrCm/m6emf+H1Ih8BxT2BfuxZa+DBi32
 aig/EgkoQYVuXffPvadsX2hn+Vk/BDl8/SnI9e72jbjdV63DQ0WQtaC3MRRxK/ksKFTF zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w5p3qx7dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:14:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADIDfR7098964;
        Wed, 13 Nov 2019 18:14:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w8g17xqfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:14:33 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xADIEWTL021129;
        Wed, 13 Nov 2019 18:14:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 10:14:31 -0800
Date:   Wed, 13 Nov 2019 10:14:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: Remove KM_* flags
Message-ID: <20191113181430.GG6219@magnolia>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-11-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113142335.1045631-11-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 03:23:34PM +0100, Carlos Maiolino wrote:
> We now use slab flags directly, so get rid of KM_flags and the
> kmem_flags_convert() function.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/kmem.h | 37 -------------------------------------
>  1 file changed, 37 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 9249323567ce..791e770be0eb 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -15,43 +15,6 @@
>   * General memory allocation interfaces
>   */
>  
> -typedef unsigned __bitwise xfs_km_flags_t;
> -#define KM_NOFS		((__force xfs_km_flags_t)0x0004u)
> -#define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
> -#define KM_ZERO		((__force xfs_km_flags_t)0x0010u)
> -
> -/*
> - * We use a special process flag to avoid recursive callbacks into
> - * the filesystem during transactions.  We will also issue our own
> - * warnings, so we explicitly skip any generic ones (silly of us).
> - */
> -static inline gfp_t
> -kmem_flags_convert(xfs_km_flags_t flags)
> -{
> -	gfp_t	lflags;
> -
> -	BUG_ON(flags & ~(KM_NOFS|KM_MAYFAIL|KM_ZERO));
> -
> -	lflags = GFP_KERNEL | __GFP_NOWARN;
> -	if (flags & KM_NOFS)
> -		lflags &= ~__GFP_FS;
> -
> -	/*
> -	 * Default page/slab allocator behavior is to retry for ever
> -	 * for small allocations. We can override this behavior by using
> -	 * __GFP_RETRY_MAYFAIL which will tell the allocator to retry as long
> -	 * as it is feasible but rather fail than retry forever for all
> -	 * request sizes.
> -	 */
> -	if (flags & KM_MAYFAIL)
> -		lflags |= __GFP_RETRY_MAYFAIL;
> -
> -	if (flags & KM_ZERO)
> -		lflags |= __GFP_ZERO;
> -
> -	return lflags;
> -}
> -
>  extern void *kmem_alloc_io(size_t size, int align_mask, gfp_t flags);
>  extern void *kmem_alloc_large(size_t size, gfp_t);
>  static inline void  kmem_free(const void *ptr)
> -- 
> 2.23.0
> 

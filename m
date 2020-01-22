Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A7EC2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 17:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0A2421569
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 17:03:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GmGcGife"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgAVRD6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:03:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37246 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgAVRD6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jan 2020 12:03:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00MGwDgd078312;
        Wed, 22 Jan 2020 17:03:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=HLbOdkKxXDp45lhYYVwtvU4TeComUtt2xXjayBzYofA=;
 b=GmGcGifecVEAjRv3MJZiD1jj6udxpO4bwdQIDeHLr85FrznaXSAoccVA/2htCqwxlNFS
 4i4GKEZ2aSceQIwKAh4Q+lhzKYIkSIIs5zVJAilEwFN/16/mJpWE544JsxKcXG32nB2q
 bqElqZ9ZRnA1Kmzv4DuYLJhwshXpaSgZbsmnrg+caG1ElYFuxINj9SSF3oq9GUT6PKcp
 RK7suK5IIhZpcDOmUJ9PWT4e/UDueAInGJnmG2RIH+fOuDYmS1LTwEItvJFf4ud6Ydwg
 zc6AccbkVU+YoyBOUPONU1HIfnmOw9HtdbB4253g4HrsHOmGlWhmmoBWW53XFNgj8oji sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xktnrcy7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 17:03:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00MGwV1K089247;
        Wed, 22 Jan 2020 17:03:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xpq0ue7wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 17:03:53 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00MH3qp0017034;
        Wed, 22 Jan 2020 17:03:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 09:03:52 -0800
Date:   Wed, 22 Jan 2020 09:03:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] libxfs: move header includes closer to kernelspace
Message-ID: <20200122170351.GT8247@magnolia>
References: <e0f6e0e5-d5e0-1829-f08c-0ec6e6095fb0@redhat.com>
 <4d8501f5-4db1-9f46-bbf8-e2a7ae5726b6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8501f5-4db1-9f46-bbf8-e2a7ae5726b6@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 22, 2020 at 10:48:51AM -0600, Eric Sandeen wrote:
> Aid application of future kernel patches which change #includes;
> not all headers exist in userspace so this is not a 1:1 match, but
> it brings userspace files a bit closer to kernelspace by adding all
> #includes which do match, and putting them in the same order.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Assuming gcc reviewed this and didn't barf up errors everywhere,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
> index 1fe13bf4..530455a5 100644
> --- a/libxfs/xfs_ag_resv.c
> +++ b/libxfs/xfs_ag_resv.c
> @@ -7,10 +7,13 @@
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
> +#include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_alloc.h"
> +#include "xfs_errortag.h"
>  #include "xfs_trace.h"
> +#include "xfs_trans.h"
>  #include "xfs_rmap_btree.h"
>  #include "xfs_btree.h"
>  #include "xfs_refcount_btree.h"
> diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
> index 1d25d14f..ec233d0d 100644
> --- a/libxfs/xfs_alloc.c
> +++ b/libxfs/xfs_alloc.c
> @@ -17,6 +17,7 @@
>  #include "xfs_rmap.h"
>  #include "xfs_alloc_btree.h"
>  #include "xfs_alloc.h"
> +#include "xfs_errortag.h"
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
>  #include "xfs_ag_resv.h"
> diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
> index d39c973a..57327deb 100644
> --- a/libxfs/xfs_alloc_btree.c
> +++ b/libxfs/xfs_alloc_btree.c
> @@ -7,6 +7,7 @@
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
> +#include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
> @@ -14,6 +15,7 @@
>  #include "xfs_alloc_btree.h"
>  #include "xfs_alloc.h"
>  #include "xfs_trace.h"
> +#include "xfs_trans.h"
>  
>  
>  STATIC struct xfs_btree_cur *
> diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
> index 7f11de3e..219736ac 100644
> --- a/libxfs/xfs_attr_leaf.c
> +++ b/libxfs/xfs_attr_leaf.c
> @@ -13,6 +13,7 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_bmap_btree.h"
> diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
> index 0969f655..5efa2f0c 100644
> --- a/libxfs/xfs_bmap.c
> +++ b/libxfs/xfs_bmap.c
> @@ -20,6 +20,7 @@
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_btree.h"
> +#include "xfs_errortag.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
>  #include "xfs_attr_leaf.h"
> diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
> index 08a7e4eb..aae1d30f 100644
> --- a/libxfs/xfs_btree.c
> +++ b/libxfs/xfs_btree.c
> @@ -14,7 +14,9 @@
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_btree.h"
> +#include "xfs_errortag.h"
>  #include "xfs_trace.h"
> +#include "xfs_alloc.h"
>  
>  /*
>   * Cursor allocation zone.
> diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
> index cff27a9b..c7a536ac 100644
> --- a/libxfs/xfs_defer.c
> +++ b/libxfs/xfs_defer.c
> @@ -6,9 +6,13 @@
>  #include "libxfs_priv.h"
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
> +#include "xfs_format.h"
>  #include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_trans.h"
> +#include "xfs_inode.h"
>  #include "xfs_trace.h"
>  
>  /*
> diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
> index 9a104a76..31ac89a3 100644
> --- a/libxfs/xfs_dir2.c
> +++ b/libxfs/xfs_dir2.c
> @@ -15,6 +15,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
> +#include "xfs_errortag.h"
>  #include "xfs_trace.h"
>  
>  struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
> diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
> index 4a175bc3..5b372a23 100644
> --- a/libxfs/xfs_dquot_buf.c
> +++ b/libxfs/xfs_dquot_buf.c
> @@ -8,9 +8,12 @@
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
> +#include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_quota_defs.h"
> +#include "xfs_inode.h"
> +#include "xfs_trans.h"
>  
>  int
>  xfs_calc_dquots_per_chunk(
> diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
> index 23bcc8c9..baa99551 100644
> --- a/libxfs/xfs_ialloc.c
> +++ b/libxfs/xfs_ialloc.c
> @@ -17,6 +17,7 @@
>  #include "xfs_ialloc.h"
>  #include "xfs_ialloc_btree.h"
>  #include "xfs_alloc.h"
> +#include "xfs_errortag.h"
>  #include "xfs_bmap.h"
>  #include "xfs_trans.h"
>  #include "xfs_trace.h"
> diff --git a/libxfs/xfs_iext_tree.c b/libxfs/xfs_iext_tree.c
> index 568fb33b..f68091dc 100644
> --- a/libxfs/xfs_iext_tree.c
> +++ b/libxfs/xfs_iext_tree.c
> @@ -3,14 +3,14 @@
>   * Copyright (c) 2017 Christoph Hellwig.
>   */
>  
> -// #include <linux/cache.h>
> -// #include <linux/kernel.h>
> -// #include <linux/slab.h>
>  #include "libxfs_priv.h"
> +#include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_bit.h"
>  #include "xfs_log_format.h"
>  #include "xfs_inode.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
>  #include "xfs_trace.h"
>  
>  /*
> diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
> index 4c90e198..c0cb5676 100644
> --- a/libxfs/xfs_inode_buf.c
> +++ b/libxfs/xfs_inode_buf.c
> @@ -11,6 +11,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_errortag.h"
>  #include "xfs_trans.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_dir2.h"
> diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
> index a4b5686e..819faa63 100644
> --- a/libxfs/xfs_inode_fork.c
> +++ b/libxfs/xfs_inode_fork.c
> @@ -3,6 +3,7 @@
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
>   */
> +
>  #include "libxfs_priv.h"
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
> @@ -21,7 +22,6 @@
>  #include "xfs_dir2_priv.h"
>  #include "xfs_attr_leaf.h"
>  
> -
>  kmem_zone_t *xfs_ifork_zone;
>  
>  STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
> diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
> index 5149b0f7..71d29486 100644
> --- a/libxfs/xfs_refcount.c
> +++ b/libxfs/xfs_refcount.c
> @@ -15,6 +15,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_alloc.h"
> +#include "xfs_errortag.h"
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
>  #include "xfs_bit.h"
> diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
> index a52b50c3..c1561325 100644
> --- a/libxfs/xfs_refcount_btree.c
> +++ b/libxfs/xfs_refcount_btree.c
> @@ -16,6 +16,7 @@
>  #include "xfs_alloc.h"
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
> +#include "xfs_bit.h"
>  #include "xfs_rmap.h"
>  
>  static struct xfs_btree_cur *
> diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
> index 69a14d66..10a17e41 100644
> --- a/libxfs/xfs_rmap.c
> +++ b/libxfs/xfs_rmap.c
> @@ -18,6 +18,7 @@
>  #include "xfs_rmap.h"
>  #include "xfs_rmap_btree.h"
>  #include "xfs_trace.h"
> +#include "xfs_errortag.h"
>  #include "xfs_inode.h"
>  
>  /*
> diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
> index f0b48a7d..5f3279d4 100644
> --- a/libxfs/xfs_trans_resv.c
> +++ b/libxfs/xfs_trans_resv.c
> @@ -13,6 +13,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
> +#include "xfs_inode.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_space.h"
> 
> 

Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FEBC43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6D002176D
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BaQogToI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfLRXKw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:10:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38960 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLRXKw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 18:10:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBINA2rp091205;
        Wed, 18 Dec 2019 23:10:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ya/Jv4Q7NQLfAwu0XdQdWAoOALErEkwivi9c3Vcm67k=;
 b=BaQogToI7DVnvFMXo4HRpSkDPHd5DsXdD7IY4q6NgE4OwG3pCAYHeTZsX8ZCk9+hSLoN
 TGX67/iU5mKj2D9xU5h/XFZ8oLKJuBi3OkBLhqGJVM4HgzuRsu3tf2YIHDT3KyvaXbu0
 nn2rMqFqmAYBxGbpaeFReiThA70fmE1+mhO26BI8vz653mCHOru3a6KBEOWblEomS4pV
 qnfkfhNAaQ7hsfZoqFm4p4q/nouF+1+oybOvQAMTTI7BojQIf4wj/MDf40nYlayQ5KrY
 4R//qjaNxKpvG8VsxZtE2hXA68ANiBehnw7cVhl+2FV3i6/y7seQKEI8jRfi8z2vI2GI Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wvqpqgm2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:10:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIN9pEP108497;
        Wed, 18 Dec 2019 23:10:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wyk3bxk5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:10:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBINAl8I007313;
        Wed, 18 Dec 2019 23:10:47 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 15:10:46 -0800
Date:   Wed, 18 Dec 2019 15:10:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] xfsprogs: include headers to fix sparse warnings
 about statics
Message-ID: <20191218231045.GK7489@magnolia>
References: <291387f3-1517-14c0-f64a-a98164131f89@sandeen.net>
 <a67fa479-1749-9485-2fd8-c2a12acea909@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a67fa479-1749-9485-2fd8-c2a12acea909@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 04:54:46PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> Addresses many "foo was not declared. Should it be static?"
> warnings from sparse.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/libfrog/linux.c b/libfrog/linux.c
> index 79bd79eb..d7264108 100644
> --- a/libfrog/linux.c
> +++ b/libfrog/linux.c
> @@ -9,6 +9,7 @@
>  #include <sys/ioctl.h>
>  #include <sys/sysinfo.h>
>  
> +#include "libfrog/platform.h"
>  #include "libxfs_priv.h"

libfrog code shouldn't depend on anything in libxfs/ but I'll send my
own patch to fix that.

Looks ok otherwise
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


>  #include "xfs_fs.h"
>  #include "init.h"
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 885dd42b..cd303341 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -28,6 +28,7 @@
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_dir2_priv.h"
> +#include "xfs_health.h"
>  
>  /*
>   * Calculate the worst case log unit reservation for a given superblock
> diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
> index 1328e5de..1fe13bf4 100644
> --- a/libxfs/xfs_ag_resv.c
> +++ b/libxfs/xfs_ag_resv.c
> @@ -15,6 +15,8 @@
>  #include "xfs_btree.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_ialloc_btree.h"
> +#include "xfs_sb.h"
> +#include "xfs_ag_resv.h"
>  
>  /*
>   * Per-AG Block Reservations
> diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
> index 7234f86c..1ce6359a 100644
> --- a/libxfs/xfs_attr_remote.c
> +++ b/libxfs/xfs_attr_remote.c
> @@ -18,6 +18,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_bmap.h"
> +#include "xfs_attr_remote.h"
>  #include "xfs_trace.h"
>  
>  #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
> diff --git a/libxfs/xfs_bit.c b/libxfs/xfs_bit.c
> index 6a76a5ad..3f97fa3e 100644
> --- a/libxfs/xfs_bit.c
> +++ b/libxfs/xfs_bit.c
> @@ -5,6 +5,7 @@
>   */
>  #include "libxfs_priv.h"
>  #include "xfs_log_format.h"
> +#include "xfs_bit.h"
>  
>  /*
>   * XFS bit manipulation routines, used in non-realtime code.
> diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
> index 68da426e..044f1272 100644
> --- a/libxfs/xfs_dir2_data.c
> +++ b/libxfs/xfs_dir2_data.c
> @@ -13,6 +13,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_dir2.h"
> +#include "xfs_dir2_priv.h"
>  #include "xfs_trans.h"
>  
>  static xfs_failaddr_t xfs_dir2_data_freefind_verify(
> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> index 583d29aa..4f750d19 100644
> --- a/libxfs/xfs_sb.c
> +++ b/libxfs/xfs_sb.c
> @@ -10,6 +10,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
> +#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_alloc.h"
> 

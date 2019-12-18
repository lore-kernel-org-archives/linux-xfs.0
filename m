Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9C7C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19D62218AC
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:26:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EPu0yB1W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfLRV0T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 16:26:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48362 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfLRV0T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 16:26:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIL9v5j024630;
        Wed, 18 Dec 2019 21:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=oZEpkg/4r70X7u+c0+q2SoZ0OZcsHRDJKwFu9J7t3J0=;
 b=EPu0yB1WGgRrY1CYGWZvjoNztTxGEMddi4FbkRNDlJbiBrcNPtAWrSikIld0k8ZRsHuX
 9244Janan3/hl0siNbXscCg9TBPAG/XGw35GiAywXI+u+sPEkaGZw69bk71SWB9i1B0I
 SFWF3hVdZ0tn7T5yQodMkEYTwAfkxOV0YlDEpetMPdeiB0VYkz40/FwKSpS6DyqoHtKH
 1ktBdbnrSeectzUSPWNIrbsu5PuQya5qCO8UszdmXAVCw1rzeC2i8X82aea35HOGq01t
 sVMN9qalCNXm4DtaKGIE0dssnIfSh4Gzbxf1rTrxFlttB19YylslhXewVVrOm/Z4ojiO Fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wvq5urccm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:26:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBILAlsZ186491;
        Wed, 18 Dec 2019 21:26:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wyut48f2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:26:10 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBILQ9QU017047;
        Wed, 18 Dec 2019 21:26:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 13:26:09 -0800
Date:   Wed, 18 Dec 2019 13:26:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 01/33] xfs: clear kernel only flags in
 XFS_IOC_ATTRMULTI_BY_HANDLE
Message-ID: <20191218212608.GD7489@magnolia>
References: <20191212105433.1692-1-hch@lst.de>
 <20191212105433.1692-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212105433.1692-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 12, 2019 at 11:54:01AM +0100, Christoph Hellwig wrote:
> Don't allow passing arbitrary flags as they change behavior including
> memory allocation that the call stack is not prepared for.
> 
> Fixes: ddbca70cc45c ("xfs: allocate xattr buffer on demand")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.h | 7 +++++--
>  fs/xfs/xfs_ioctl.c       | 2 ++
>  fs/xfs/xfs_ioctl32.c     | 2 ++
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 94badfa1743e..91c2cb14276e 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -26,7 +26,7 @@ struct xfs_attr_list_context;
>   *========================================================================*/
>  
>  
> -#define ATTR_DONTFOLLOW	0x0001	/* -- unused, from IRIX -- */
> +#define ATTR_DONTFOLLOW	0x0001	/* -- ignored, from IRIX -- */
>  #define ATTR_ROOT	0x0002	/* use attrs in root (trusted) namespace */
>  #define ATTR_TRUST	0x0004	/* -- unused, from IRIX -- */
>  #define ATTR_SECURE	0x0008	/* use attrs in security namespace */
> @@ -37,7 +37,10 @@ struct xfs_attr_list_context;
>  #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
>  
>  #define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
> -#define ATTR_ALLOC	0x8000	/* allocate xattr buffer on demand */
> +#define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
> +
> +#define ATTR_KERNEL_FLAGS \
> +	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_INCOMPLETE | ATTR_ALLOC)
>  
>  #define XFS_ATTR_FLAGS \
>  	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 7b35d62ede9f..2f76d0a7b818 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -462,6 +462,8 @@ xfs_attrmulti_by_handle(
>  
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
> +		ops[i].am_flags &= ATTR_KERNEL_FLAGS;

The only flags we allow from userspace are the internal state flags?
Is this supposed to be am_flags &= ~ATTR_KERNEL_FLAGS?

--D

> +
>  		ops[i].am_error = strncpy_from_user((char *)attr_name,
>  				ops[i].am_attrname, MAXNAMELEN);
>  		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index c4c4f09113d3..8b5acf8c42e1 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -450,6 +450,8 @@ xfs_compat_attrmulti_by_handle(
>  
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
> +		ops[i].am_flags &= ATTR_KERNEL_FLAGS;
> +
>  		ops[i].am_error = strncpy_from_user((char *)attr_name,
>  				compat_ptr(ops[i].am_attrname),
>  				MAXNAMELEN);
> -- 
> 2.20.1
> 

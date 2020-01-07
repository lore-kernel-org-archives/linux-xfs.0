Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B71C282DD
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 23:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43160207E0
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 23:23:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ijCXUEWd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgAGXXL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 18:23:11 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58260 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727225AbgAGXXL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 18:23:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007NJOno031768;
        Tue, 7 Jan 2020 23:23:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+wQsq/6OQzg7VSFe7mmmlnSEuBrXkZk8ZbFB8UY6CUg=;
 b=ijCXUEWdSaZVbUxAgoXe7gRJEU7NVZEaUvVbwhNX6CMRMXZmIUVb0HRtkbP+K8PMLLIh
 eHmQFvKbF8Qm2X8pEpOEzBJZ6tBO9DIy8ypP5yv/tOBJDmgE7JRerEu6N3j26PRmliK1
 VLjKibVgOzsfNHEcdKY3RB/av9yhltQpuj5C48Zey63JWwZfJIucn1alIdTOPO1Y+HU9
 EComxNcrBh0hmPDLJH3yhxFB3GldhorMDpce9eUmIMuPjCCfa73lzPEkVJQ3ESFIXTlb
 u/iqkseOoMEfYrTzY34G08OX+V6GBD2sS2yc8GZz/hPOTGURiJUR18OC0J/iCkGBe5ep Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xakbqrk6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 23:23:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007NJIph088830;
        Tue, 7 Jan 2020 23:23:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xcqbhcpx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 23:23:04 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 007NN2Nb000854;
        Tue, 7 Jan 2020 23:23:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 15:23:02 -0800
Date:   Tue, 7 Jan 2020 15:23:00 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: clear kernel only flags in
 XFS_IOC_ATTRMULTI_BY_HANDLE
Message-ID: <20200107232300.GF917713@magnolia>
References: <20200107165442.262020-1-hch@lst.de>
 <20200107165442.262020-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107165442.262020-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 05:54:39PM +0100, Christoph Hellwig wrote:
> Don't allow passing arbitrary flags as they change behavior including
> memory allocation that the call stack is not prepared for.
> 
> Fixes: ddbca70cc45c ("xfs: allocate xattr buffer on demand")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
> index 7b35d62ede9f..edfbdb8f85e2 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -462,6 +462,8 @@ xfs_attrmulti_by_handle(
>  
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
> +		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
> +
>  		ops[i].am_error = strncpy_from_user((char *)attr_name,
>  				ops[i].am_attrname, MAXNAMELEN);
>  		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index c4c4f09113d3..bd9d9ebf85d8 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -450,6 +450,8 @@ xfs_compat_attrmulti_by_handle(
>  
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
> +		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
> +
>  		ops[i].am_error = strncpy_from_user((char *)attr_name,
>  				compat_ptr(ops[i].am_attrname),
>  				MAXNAMELEN);
> -- 
> 2.24.1
> 

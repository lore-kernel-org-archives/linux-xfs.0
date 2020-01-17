Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BCBBC33CAF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 00:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EFC62072E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 00:59:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QMoknN+I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732218AbgAQA7m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 19:59:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52114 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729577AbgAQA7m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 19:59:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H0x6ro139870;
        Fri, 17 Jan 2020 00:59:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=5pIHDeCS35cxnrQUK+3OhlacI8uzC0dkPDc4ICSWKEY=;
 b=QMoknN+IKt5Hc1q8LqtiD/EoRS05VeYpsu2j6vaiA0L5ane7IjicfXzaEvM6OJC0ws8D
 kC30VcaLJ6rasD/O2cSf9+vyLIUpBywsB+s+sZ1g9vdQIBduCX9NifLg6iYldA930UlH
 5CksZUaxFiDIsmlo8ZesFH3SR+21qNvSZG2SWEmowMYgrOw8WkSmmgWldKS+X8tcAX2M
 9UrCuhX8a0uLYmvnrYqrnlI5XTfUCIAN0cAIGnYR6EEXulrSyG7qu3uP57igLyGQhD0u
 +57dl92AEzkXSwSGLWsBpFZ+GHQot+19YwvazwIiGfVtxnYgcueCTLNM3MTnGkUkVpsX yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xf73u5u3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 00:59:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H0xSZa107949;
        Fri, 17 Jan 2020 00:59:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xk24e1qjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 00:59:31 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00H0xBGD027544;
        Fri, 17 Jan 2020 00:59:11 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 16:59:11 -0800
Date:   Thu, 16 Jan 2020 16:59:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 01/29] xfs: remove the ATTR_INCOMPLETE flag
Message-ID: <20200117005908.GP8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:23AM +0100, Christoph Hellwig wrote:
> Replace the ATTR_INCOMPLETE flag with a new boolean field in struct
> xfs_attr_list_context.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.h | 5 ++---
>  fs/xfs/scrub/attr.c      | 2 +-
>  fs/xfs/xfs_attr_list.c   | 6 +-----
>  3 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 4243b2272642..71bcf1298e4c 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -36,11 +36,10 @@ struct xfs_attr_list_context;
>  #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
>  #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
>  
> -#define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
>  #define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
>  
>  #define ATTR_KERNEL_FLAGS \
> -	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_INCOMPLETE | ATTR_ALLOC)
> +	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_ALLOC)
>  
>  #define XFS_ATTR_FLAGS \
>  	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
> @@ -51,7 +50,6 @@ struct xfs_attr_list_context;
>  	{ ATTR_REPLACE,		"REPLACE" }, \
>  	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
>  	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
> -	{ ATTR_INCOMPLETE,	"INCOMPLETE" }, \
>  	{ ATTR_ALLOC,		"ALLOC" }
>  
>  /*
> @@ -123,6 +121,7 @@ typedef struct xfs_attr_list_context {
>  	 * error values to the xfs_attr_list caller.
>  	 */
>  	int				seen_enough;
> +	bool				allow_incomplete;
>  
>  	ssize_t				count;		/* num used entries */
>  	int				dupcnt;		/* count dup hashvals seen */
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index d9f0dd444b80..d804558cdbca 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -497,7 +497,7 @@ xchk_xattr(
>  	sx.context.resynch = 1;
>  	sx.context.put_listent = xchk_xattr_listent;
>  	sx.context.tp = sc->tp;
> -	sx.context.flags = ATTR_INCOMPLETE;
> +	sx.context.allow_incomplete = true;
>  	sx.sc = sc;
>  
>  	/*
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index d37743bdf274..5139ef983cd6 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -452,7 +452,7 @@ xfs_attr3_leaf_list_int(
>  		}
>  
>  		if ((entry->flags & XFS_ATTR_INCOMPLETE) &&
> -		    !(context->flags & ATTR_INCOMPLETE))
> +		    !context->allow_incomplete)
>  			continue;		/* skip incomplete entries */
>  
>  		if (entry->flags & XFS_ATTR_LOCAL) {
> @@ -632,10 +632,6 @@ xfs_attr_list(
>  	    (cursor->hashval || cursor->blkno || cursor->offset))
>  		return -EINVAL;
>  
> -	/* Only internal consumers can retrieve incomplete attrs. */
> -	if (flags & ATTR_INCOMPLETE)
> -		return -EINVAL;
> -
>  	/*
>  	 * Check for a properly aligned buffer.
>  	 */
> -- 
> 2.24.1
> 

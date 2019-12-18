Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6521C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9707A2176D
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bvGUup4P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLRVoe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 16:44:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38142 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfLRVoe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 16:44:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBILiFZH027327;
        Wed, 18 Dec 2019 21:44:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=WacXWiqhXM6jGbo0pGrpmRjS60BCYUc2u9o0VU7+9cs=;
 b=bvGUup4Pa+SKChKzmxeGP7T/HKAaR58N0ZAX8SCPqsiH9YPY3sV5bC7Y/h+j11T2YdfF
 KDRKSgHH0IBxA+pBKV8yKlLQsWe6vyps5tpIlekyIhxm1GQLK9VIjOXol5P8rV0VApKj
 P5HZohflpHABo14p+PAnUZIBQvOl5lUvyvrySF4Am/VQGPr2D4BxXacV5MhXz61rQhhl
 //Q57CTyl7/5qj+TMs/3A9FhXyVQinLxLLA1nRz+IxYVL15ykJIllP3FgORK4TsR7B2n
 vkzK+iq2d5yU5lzb+baM9vLJPk8vQqW+7YCtzAqduVLu3hSNNpKptQw4oGvYrlElvsXu 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wvrcrg80g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:44:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBILiGZ7059738;
        Wed, 18 Dec 2019 21:44:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wyut4906j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:44:20 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBILhAYA014079;
        Wed, 18 Dec 2019 21:43:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 13:43:10 -0800
Date:   Wed, 18 Dec 2019 13:43:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 05/33] xfs: remove the ATTR_INCOMPLETE flag
Message-ID: <20191218214309.GH7489@magnolia>
References: <20191212105433.1692-1-hch@lst.de>
 <20191212105433.1692-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212105433.1692-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 12, 2019 at 11:54:05AM +0100, Christoph Hellwig wrote:
> Replace the ATTR_INCOMPLETE flag with a new boolean field in struct
> xfs_attr_list_context.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.h | 5 ++---
>  fs/xfs/scrub/attr.c      | 2 +-
>  fs/xfs/xfs_attr_list.c   | 6 +-----
>  3 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 91c2cb14276e..04a628016728 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -36,11 +36,10 @@ struct xfs_attr_list_context;
>  #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
>  #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
>  
> -#define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */

Hmm, did we used to allow ATTR_INCOMPLETE from the attr_multi userspace
calls?  Maybe we should leave ATTR_INCOMPLETE so that we can blacklist
it in case we ever see it coming from userspace?  Or at least prevent
anyone from reusing 0x4000 and suffering the confusion.

I also wonder if we can break userspace this way, but OTOH userspace
should never be able to query incomplete attrs and this is an obscure
ioctl anyway so maybe it's fine....

--D

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
> 2.20.1
> 

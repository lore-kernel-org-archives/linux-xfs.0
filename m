Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9D4C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F3D922522
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:15:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rHuasuDy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgAUSPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:15:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59112 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUSPq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:15:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LI7wMh169790;
        Tue, 21 Jan 2020 18:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=N0zRmVb8fESrCLNBaRHak37Cnnh8s+jDXKVJwiMwmXA=;
 b=rHuasuDym56VqodbTDjNQ9Jt8rf3qsd3okfQEWPVW0RsFlIoOdYEZQti46rwwSGlaGV3
 d5K25KenG1lgQl2eqqGZ1QD/CSBvdaJ4aXHEyV4bQC0nacDaSEXr+Kk+uhxG9ngln0WY
 jVY9wJAJ/cGUpKbT4TzrMF0TF9bW+oJ3gNVnhzkl1B2pRCOWiHPvxxrRXWezExXxQirQ
 0RQyXlJXhsCzRxLqg0TTRghjo9AAmf4P5nNEqeIMkfi8dkhtWu7XrHyDeOSqfUU+4/sB
 JIF2Ab/vTMbqtHTqjNkn1d8dEN8YgF0a6Mx7kJHv0iVctO3Ykl8pUTHp3rvxzoGyH875 Yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xktnr6qk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:15:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LI7wM2113174;
        Tue, 21 Jan 2020 18:15:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xnpfpg9v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:15:40 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LIFdD2027748;
        Tue, 21 Jan 2020 18:15:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:15:39 -0800
Date:   Tue, 21 Jan 2020 10:15:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 13/29] xfs: remove ATTR_KERNOVAL
Message-ID: <20200121181538.GM8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-14-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:35AM +0100, Christoph Hellwig wrote:
> We can just pass down the Linux convention of a zero valuelen to just
> query for the existance of an attribute to the low-level code instead.
> The use in the legacy xfs_attr_list code only used by the ioctl
> interface was already dead code, as the callers check that the flag
> is not present.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        |  8 ++++----
>  fs/xfs/libxfs/xfs_attr.h        |  4 +---
>  fs/xfs/libxfs/xfs_attr_leaf.c   | 14 +++++++-------
>  fs/xfs/libxfs/xfs_attr_remote.c |  2 +-
>  fs/xfs/xfs_attr_list.c          |  3 ---
>  fs/xfs/xfs_xattr.c              |  4 ----
>  6 files changed, 13 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 09954c0e8456..1c4e8ac38d5a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -94,9 +94,9 @@ xfs_attr_get_ilocked(
>  /*
>   * Retrieve an extended attribute by name, and its value if requested.
>   *
> - * If ATTR_KERNOVAL is set in args->flags, then the caller does not want the
> - * value, just an indication whether the attribute exists and the size of the
> - * value if it exists. The size is returned in args.valuelen.
> + * If args->valuelen is zero, then the caller does not want the value, just an
> + * indication whether the attribute exists and the size of the value if it
> + * exists. The size is returned in args.valuelen.
>   *
>   * If the attribute is found, but exceeds the size limit set by the caller in
>   * args->valuelen, return -ERANGE with the size of the attribute that was found
> @@ -115,7 +115,7 @@ xfs_attr_get(
>  	uint			lock_mode;
>  	int			error;
>  
> -	ASSERT((args->flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || args->value);
> +	ASSERT((args->flags & ATTR_ALLOC) || !args->valuelen || args->value);
>  
>  	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index b8c4ed27f626..fe064cd81747 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -34,12 +34,11 @@ struct xfs_attr_list_context;
>  #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
>  
>  #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
> -#define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
>  
>  #define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
>  
>  #define ATTR_KERNEL_FLAGS \
> -	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_ALLOC)
> +	(ATTR_KERNOTIME | ATTR_ALLOC)
>  
>  #define XFS_ATTR_FLAGS \
>  	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
> @@ -49,7 +48,6 @@ struct xfs_attr_list_context;
>  	{ ATTR_CREATE,		"CREATE" }, \
>  	{ ATTR_REPLACE,		"REPLACE" }, \
>  	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
> -	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
>  	{ ATTR_ALLOC,		"ALLOC" }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index fed537a4353d..5e700dfc48a9 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -464,7 +464,7 @@ xfs_attr_copy_value(
>  	/*
>  	 * No copy if all we have to do is get the length
>  	 */
> -	if (args->flags & ATTR_KERNOVAL) {
> +	if (!args->valuelen) {
>  		args->valuelen = valuelen;
>  		return 0;
>  	}
> @@ -830,9 +830,9 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  /*
>   * Retrieve the attribute value and length.
>   *
> - * If ATTR_KERNOVAL is specified, only the length needs to be returned.
> - * Unlike a lookup, we only return an error if the attribute does not
> - * exist or we can't retrieve the value.
> + * If args->valuelen is zero, only the length needs to be returned.  Unlike a
> + * lookup, we only return an error if the attribute does not exist or we can't
> + * retrieve the value.
>   */
>  int
>  xfs_attr_shortform_getvalue(
> @@ -2444,9 +2444,9 @@ xfs_attr3_leaf_lookup_int(
>   * Get the value associated with an attribute name from a leaf attribute
>   * list structure.
>   *
> - * If ATTR_KERNOVAL is specified, only the length needs to be returned.
> - * Unlike a lookup, we only return an error if the attribute does not
> - * exist or we can't retrieve the value.
> + * If args->valuelen is zero, only the length needs to be returned.  Unlike a
> + * lookup, we only return an error if the attribute does not exist or we can't
> + * retrieve the value.
>   */
>  int
>  xfs_attr3_leaf_getvalue(
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index a6ef5df42669..56d8ba785c53 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -380,7 +380,7 @@ xfs_attr_rmtval_get(
>  
>  	trace_xfs_attr_rmtval_get(args);
>  
> -	ASSERT(!(args->flags & ATTR_KERNOVAL));
> +	ASSERT(args->valuelen != 0);
>  	ASSERT(args->rmtvaluelen == args->valuelen);
>  
>  	valuelen = args->rmtvaluelen;
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 5139ef983cd6..ac8dc64447d6 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -568,7 +568,6 @@ xfs_attr_put_listent(
>  	int arraytop;
>  
>  	ASSERT(!context->seen_enough);
> -	ASSERT(!(context->flags & ATTR_KERNOVAL));
>  	ASSERT(context->count >= 0);
>  	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
>  	ASSERT(context->firstu >= sizeof(*alist));
> @@ -637,8 +636,6 @@ xfs_attr_list(
>  	 */
>  	if (((long)buffer) & (sizeof(int)-1))
>  		return -EFAULT;
> -	if (flags & ATTR_KERNOVAL)
> -		bufsize = 0;
>  
>  	/*
>  	 * Initialize the output buffer.
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index b3ce5e8777f9..c9c44f8aebed 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -31,10 +31,6 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>  	};
>  	int			error;
>  
> -	/* Convert Linux syscall to XFS internal ATTR flags */
> -	if (!size)
> -		args.flags |= ATTR_KERNOVAL;
> -
>  	error = xfs_attr_get(&args);
>  	if (error)
>  		return error;
> -- 
> 2.24.1
> 

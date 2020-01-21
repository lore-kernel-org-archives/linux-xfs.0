Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECF9C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08E2722522
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:17:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SB8QekQW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgAUSR6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:17:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33264 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUSR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:17:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LI7xjf169798;
        Tue, 21 Jan 2020 18:17:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=KE1FSTQ32qgqtkO+6KdW94TBxZYIstagiqhsBLA/E+w=;
 b=SB8QekQWVft++fPusQZR+PIB76/j1TZPstyLSYzEWXBCgxqrtxxEubkA9VmhTW9Z/DJS
 v4iTIYXDGH0tTw9V+1HTiABGJKe7eIKT5lfNHK8Wd9QGY/wD5GM3j9x02ZdvB+SRElaK
 p43Tf3ES85sI14pnGFXwAIz7M5U9kLonwWpmUDrlaCC6eMmUjgV+9m1q6sSFGAAUKLp0
 cHJFMPvCvayAp7rsMYh6PyNkVMrjdlxs0/0/He/vYVCFZjpLV/un3f8ZaTwrDyAS7YyS
 iV9tTKn6snuIUyXjQxWarevPg8HCzrtpms4/2uVtmdNlmPSFdcYJiZ/iEumlvz31MThr Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xktnr6qyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:17:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LI9316121178;
        Tue, 21 Jan 2020 18:17:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xnsj53n46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:17:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LIHrqF031923;
        Tue, 21 Jan 2020 18:17:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:17:53 -0800
Date:   Tue, 21 Jan 2020 10:17:52 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 14/29] xfs: remove ATTR_ALLOC and XFS_DA_OP_ALLOCVAL
Message-ID: <20200121181752.GN8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-15-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:36AM +0100, Christoph Hellwig wrote:
> Use a NULL args->value as the indicator to lazily allocate a buffer
> instead, and let the caller always free args->value instead of
> duplicating the cleanup.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 20 +++++---------------
>  fs/xfs/libxfs/xfs_attr.h      |  7 ++-----
>  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>  fs/xfs/libxfs/xfs_types.h     |  2 --
>  fs/xfs/xfs_acl.c              | 20 ++++++++++----------
>  5 files changed, 18 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1c4e8ac38d5a..c362dbab1a6a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -98,15 +98,14 @@ xfs_attr_get_ilocked(
>   * indication whether the attribute exists and the size of the value if it
>   * exists. The size is returned in args.valuelen.
>   *
> + * If args->value is NULL but args->valuelen is non-zero, allocate the buffer
> + * for the value after existence of the attribute has been determined. The
> + * caller always has to free args->value if it is set, no matter if this
> + * function was successful or not.

/me wonders if the "null value means alloc buffer internally" (and the
"zero valuelen means return only the value size") behaviors ought to be
documented in the struct xfs_da_args definition?

The code looks fine though.

--D

> + *
>   * If the attribute is found, but exceeds the size limit set by the caller in
>   * args->valuelen, return -ERANGE with the size of the attribute that was found
>   * in args->valuelen.
> - *
> - * If ATTR_ALLOC is set in args->flags, allocate the buffer for the value after
> - * existence of the attribute has been determined. On success, return that
> - * buffer to the caller and leave them to free it. On failure, free any
> - * allocated buffer and ensure the buffer pointer returned to the caller is
> - * null.
>   */
>  int
>  xfs_attr_get(
> @@ -115,8 +114,6 @@ xfs_attr_get(
>  	uint			lock_mode;
>  	int			error;
>  
> -	ASSERT((args->flags & ATTR_ALLOC) || !args->valuelen || args->value);
> -
>  	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
>  
>  	if (XFS_FORCED_SHUTDOWN(args->dp->i_mount))
> @@ -128,18 +125,11 @@ xfs_attr_get(
>  
>  	/* Entirely possible to look up a name which doesn't exist */
>  	args->op_flags = XFS_DA_OP_OKNOENT;
> -	if (args->flags & ATTR_ALLOC)
> -		args->op_flags |= XFS_DA_OP_ALLOCVAL;
>  
>  	lock_mode = xfs_ilock_attr_map_shared(args->dp);
>  	error = xfs_attr_get_ilocked(args);
>  	xfs_iunlock(args->dp, lock_mode);
>  
> -	/* on error, we have to clean up allocated value buffers */
> -	if (error && (args->flags & ATTR_ALLOC)) {
> -		kmem_free(args->value);
> -		args->value = NULL;
> -	}
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index fe064cd81747..a6de050675c9 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -35,10 +35,8 @@ struct xfs_attr_list_context;
>  
>  #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
>  
> -#define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
> -
>  #define ATTR_KERNEL_FLAGS \
> -	(ATTR_KERNOTIME | ATTR_ALLOC)
> +	(ATTR_KERNOTIME)
>  
>  #define XFS_ATTR_FLAGS \
>  	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
> @@ -47,8 +45,7 @@ struct xfs_attr_list_context;
>  	{ ATTR_SECURE,		"SECURE" }, \
>  	{ ATTR_CREATE,		"CREATE" }, \
>  	{ ATTR_REPLACE,		"REPLACE" }, \
> -	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
> -	{ ATTR_ALLOC,		"ALLOC" }
> +	{ ATTR_KERNOTIME,	"KERNOTIME" }
>  
>  /*
>   * The maximum size (into the kernel or returned from the kernel) of an
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 5e700dfc48a9..b0658eb8fbcc 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -477,7 +477,7 @@ xfs_attr_copy_value(
>  		return -ERANGE;
>  	}
>  
> -	if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
> +	if (!args->value) {
>  		args->value = kmem_alloc_large(valuelen, 0);
>  		if (!args->value)
>  			return -ENOMEM;
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 634814dd1d10..3379ebc0c7c5 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -223,7 +223,6 @@ typedef struct xfs_da_args {
>  #define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
>  #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
>  #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
> -#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
>  #define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
>  
>  #define XFS_DA_OP_FLAGS \
> @@ -232,7 +231,6 @@ typedef struct xfs_da_args {
>  	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
>  	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
>  	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
> -	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
>  	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
>  
>  /*
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index a3c7f86a13e7..89f076e2ed7d 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -125,7 +125,7 @@ xfs_get_acl(struct inode *inode, int type)
>  	struct posix_acl	*acl = NULL;
>  	struct xfs_da_args	args = {
>  		.dp		= ip,
> -		.flags		= ATTR_ALLOC | ATTR_ROOT,
> +		.flags		= ATTR_ROOT,
>  		.valuelen	= XFS_ACL_MAX_SIZE(mp),
>  	};
>  	int			error;
> @@ -144,19 +144,19 @@ xfs_get_acl(struct inode *inode, int type)
>  	}
>  	args.namelen = strlen(args.name);
>  
> +	/*
> +	 * If the attribute doesn't exist make sure we have a negative cache
> +	 * entry, for any other error assume it is transient.
> +	 */
>  	error = xfs_attr_get(&args);
> -	if (error) {
> -		/*
> -		 * If the attribute doesn't exist make sure we have a negative
> -		 * cache entry, for any other error assume it is transient.
> -		 */
> -		if (error != -ENOATTR)
> -			acl = ERR_PTR(error);
> -	} else  {
> +	if (!error) {
>  		acl = xfs_acl_from_disk(mp, args.value, args.valuelen,
>  					XFS_ACL_MAX_ENTRIES(mp));
> -		kmem_free(args.value);
> +	} else if (error != -ENOATTR) {
> +		acl = ERR_PTR(error);
>  	}
> +
> +	kmem_free(args.value);
>  	return acl;
>  }
>  
> -- 
> 2.24.1
> 

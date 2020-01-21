Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AEFC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63B7122522
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:12:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qf1V/jC1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgAUSMz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:12:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47254 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUSMy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:12:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LI87fH153808;
        Tue, 21 Jan 2020 18:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=5U7vaauXOqtvanZa8ghYXdOHuunPp9SYG7uUSLn+7A0=;
 b=Qf1V/jC1TX6Q48I11ccwPo2uu/OoMscPzcSG/mmca6c4I56p8raqPH2eO//s3ECa8iCY
 SanBdhnso4brShY7IjytYXm1aeAPlGNMuvoTakiHwoxXqvraAzTDiMtsaKPVc/WeV/yr
 9l85y+Ig+iYDfB3x9z2g2Um0mslHFfipD4MrKOkJ2a4gd8TY3C2ERVZDhx5+KvSqaVih
 V59ixAM7PZ0nj0FYrrJ/N66H995xkMjuE3jNWZp7SwDLxHkMj6Ff3xCk28C0C+M8VJ8e
 4UyWUeeB5bOrW1SENtRLnYBb7Y6EqTHLyh0GbWKv3B6UnlUXlr635E1MlYeYybHNNWL8 Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyq6thf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:12:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LI8qll033632;
        Tue, 21 Jan 2020 18:12:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xnpef88cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:12:49 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LICm4w029042;
        Tue, 21 Jan 2020 18:12:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:12:48 -0800
Date:   Tue, 21 Jan 2020 10:12:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 11/29] xfs: pass an initialized xfs_da_args to
 xfs_attr_get
Message-ID: <20200121181247.GK8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-12-hch@lst.de>
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

On Tue, Jan 14, 2020 at 09:10:33AM +0100, Christoph Hellwig wrote:
> Instead of converting from one style of arguments to another in
> xfs_attr_set, pass the structure from higher up in the call chain.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 80 ++++++++++++----------------------------
>  fs/xfs/libxfs/xfs_attr.h |  4 +-
>  fs/xfs/xfs_acl.c         | 35 ++++++++----------
>  fs/xfs/xfs_ioctl.c       | 25 ++++++++-----
>  fs/xfs/xfs_xattr.c       | 24 ++++++------
>  5 files changed, 68 insertions(+), 100 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index c565e510fccc..4aaec6304f98 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -56,26 +56,6 @@ STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>  
> -
> -STATIC int
> -xfs_attr_args_init(
> -	struct xfs_da_args	*args,
> -	struct xfs_inode	*dp,
> -	const unsigned char	*name,
> -	size_t			namelen,
> -	int			flags)
> -{
> -	memset(args, 0, sizeof(*args));
> -	args->geo = dp->i_mount->m_attr_geo;
> -	args->whichfork = XFS_ATTR_FORK;
> -	args->dp = dp;
> -	args->flags = flags;
> -	args->name = name;
> -	args->namelen = namelen;
> -	args->hashval = xfs_da_hashname(args->name, args->namelen);
> -	return 0;
> -}
> -
>  int
>  xfs_inode_hasattr(
>  	struct xfs_inode	*ip)
> @@ -115,15 +95,15 @@ xfs_attr_get_ilocked(
>  /*
>   * Retrieve an extended attribute by name, and its value if requested.
>   *
> - * If ATTR_KERNOVAL is set in @flags, then the caller does not want the value,
> - * just an indication whether the attribute exists and the size of the value if
> - * it exists. The size is returned in @valuelenp,
> + * If ATTR_KERNOVAL is set in args->flags, then the caller does not want the

"...is set in @args->flags..." ?

(I mean... it's pretty obvious to a human that "args" refers to the
parameter, but I dunno if the automated scanning tools are going to get
all cranky if we don't @ it.)

With that fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> + * value, just an indication whether the attribute exists and the size of the
> + * value if it exists. The size is returned in args.valuelen.
>   *
>   * If the attribute is found, but exceeds the size limit set by the caller in
> - * @valuelenp, return -ERANGE with the size of the attribute that was found in
> - * @valuelenp.
> + * args->valuelen, return -ERANGE with the size of the attribute that was found
> + * in args->valuelen.
>   *
> - * If ATTR_ALLOC is set in @flags, allocate the buffer for the value after
> + * If ATTR_ALLOC is set in args->flags, allocate the buffer for the value after
>   * existence of the attribute has been determined. On success, return that
>   * buffer to the caller and leave them to free it. On failure, free any
>   * allocated buffer and ensure the buffer pointer returned to the caller is
> @@ -131,51 +111,37 @@ xfs_attr_get_ilocked(
>   */
>  int
>  xfs_attr_get(
> -	struct xfs_inode	*ip,
> -	const unsigned char	*name,
> -	size_t			namelen,
> -	unsigned char		**value,
> -	int			*valuelenp,
> -	int			flags)
> +	struct xfs_da_args	*args)
>  {
> -	struct xfs_da_args	args;
>  	uint			lock_mode;
>  	int			error;
>  
> -	ASSERT((flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || *value);
> +	ASSERT((args->flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || args->value);
>  
> -	XFS_STATS_INC(ip->i_mount, xs_attr_get);
> +	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
>  
> -	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> +	if (XFS_FORCED_SHUTDOWN(args->dp->i_mount))
>  		return -EIO;
>  
> -	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
> -	if (error)
> -		return error;
> +	args->geo = args->dp->i_mount->m_attr_geo;
> +	args->whichfork = XFS_ATTR_FORK;
> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
>  
>  	/* Entirely possible to look up a name which doesn't exist */
> -	args.op_flags = XFS_DA_OP_OKNOENT;
> -	if (flags & ATTR_ALLOC)
> -		args.op_flags |= XFS_DA_OP_ALLOCVAL;
> -	else
> -		args.value = *value;
> -	args.valuelen = *valuelenp;
> +	args->op_flags = XFS_DA_OP_OKNOENT;
> +	if (args->flags & ATTR_ALLOC)
> +		args->op_flags |= XFS_DA_OP_ALLOCVAL;
>  
> -	lock_mode = xfs_ilock_attr_map_shared(ip);
> -	error = xfs_attr_get_ilocked(ip, &args);
> -	xfs_iunlock(ip, lock_mode);
> -	*valuelenp = args.valuelen;
> +	lock_mode = xfs_ilock_attr_map_shared(args->dp);
> +	error = xfs_attr_get_ilocked(args->dp, args);
> +	xfs_iunlock(args->dp, lock_mode);
>  
>  	/* on error, we have to clean up allocated value buffers */
> -	if (error) {
> -		if (flags & ATTR_ALLOC) {
> -			kmem_free(args.value);
> -			*value = NULL;
> -		}
> -		return error;
> +	if (error && (args->flags & ATTR_ALLOC)) {
> +		kmem_free(args->value);
> +		args->value = NULL;
>  	}
> -	*value = args.value;
> -	return 0;
> +	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 07ca543db831..be77d13a2902 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -146,9 +146,7 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
>  int xfs_attr_list_int(struct xfs_attr_list_context *);
>  int xfs_inode_hasattr(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
> -int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
> -		 size_t namelen, unsigned char **value, int *valuelenp,
> -		 int flags);
> +int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 8e2a0469e6dc..a3c7f86a13e7 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -120,34 +120,31 @@ xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
>  struct posix_acl *
>  xfs_get_acl(struct inode *inode, int type)
>  {
> -	struct xfs_inode *ip = XFS_I(inode);
> -	struct posix_acl *acl = NULL;
> -	struct xfs_acl *xfs_acl = NULL;
> -	unsigned char *ea_name;
> -	int error;
> -	int len;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct posix_acl	*acl = NULL;
> +	struct xfs_da_args	args = {
> +		.dp		= ip,
> +		.flags		= ATTR_ALLOC | ATTR_ROOT,
> +		.valuelen	= XFS_ACL_MAX_SIZE(mp),
> +	};
> +	int			error;
>  
>  	trace_xfs_get_acl(ip);
>  
>  	switch (type) {
>  	case ACL_TYPE_ACCESS:
> -		ea_name = SGI_ACL_FILE;
> +		args.name = SGI_ACL_FILE;
>  		break;
>  	case ACL_TYPE_DEFAULT:
> -		ea_name = SGI_ACL_DEFAULT;
> +		args.name = SGI_ACL_DEFAULT;
>  		break;
>  	default:
>  		BUG();
>  	}
> +	args.namelen = strlen(args.name);
>  
> -	/*
> -	 * If we have a cached ACLs value just return it, not need to
> -	 * go out to the disk.
> -	 */
> -	len = XFS_ACL_MAX_SIZE(ip->i_mount);
> -	error = xfs_attr_get(ip, ea_name, strlen(ea_name),
> -				(unsigned char **)&xfs_acl, &len,
> -				ATTR_ALLOC | ATTR_ROOT);
> +	error = xfs_attr_get(&args);
>  	if (error) {
>  		/*
>  		 * If the attribute doesn't exist make sure we have a negative
> @@ -156,9 +153,9 @@ xfs_get_acl(struct inode *inode, int type)
>  		if (error != -ENOATTR)
>  			acl = ERR_PTR(error);
>  	} else  {
> -		acl = xfs_acl_from_disk(ip->i_mount, xfs_acl, len,
> -					XFS_ACL_MAX_ENTRIES(ip->i_mount));
> -		kmem_free(xfs_acl);
> +		acl = xfs_acl_from_disk(mp, args.value, args.valuelen,
> +					XFS_ACL_MAX_ENTRIES(mp));
> +		kmem_free(args.value);
>  	}
>  	return acl;
>  }
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 44d97a8ceb4b..75b8fa7da1c9 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -355,27 +355,32 @@ xfs_attrmulti_attr_get(
>  	uint32_t		*len,
>  	uint32_t		flags)
>  {
> -	unsigned char		*kbuf;
> -	int			error = -EFAULT;
> -	size_t			namelen;
> +	struct xfs_da_args	args = {
> +		.dp		= XFS_I(inode),
> +		.flags		= flags,
> +		.name		= name,
> +		.namelen	= strlen(name),
> +		.valuelen	= *len,
> +	};
> +	int			error;
>  
>  	if (*len > XFS_XATTR_SIZE_MAX)
>  		return -EINVAL;
> -	kbuf = kmem_zalloc_large(*len, 0);
> -	if (!kbuf)
> +
> +	args.value = kmem_zalloc_large(*len, 0);
> +	if (!args.value)
>  		return -ENOMEM;
>  
> -	namelen = strlen(name);
> -	error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
> -			     flags);
> +	error = xfs_attr_get(&args);
>  	if (error)
>  		goto out_kfree;
>  
> -	if (copy_to_user(ubuf, kbuf, *len))
> +	*len = args.valuelen;
> +	if (copy_to_user(ubuf, args.value, args.valuelen))
>  		error = -EFAULT;
>  
>  out_kfree:
> -	kmem_free(kbuf);
> +	kmem_free(args.value);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 09f967f97699..b3ce5e8777f9 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -21,22 +21,24 @@ static int
>  xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>  		struct inode *inode, const char *name, void *value, size_t size)
>  {
> -	int xflags = handler->flags;
> -	struct xfs_inode *ip = XFS_I(inode);
> -	int error, asize = size;
> -	size_t namelen = strlen(name);
> +	struct xfs_da_args	args = {
> +		.dp		= XFS_I(inode),
> +		.flags		= handler->flags,
> +		.name		= name,
> +		.namelen	= strlen(name),
> +		.value		= value,
> +		.valuelen	= size,
> +	};
> +	int			error;
>  
>  	/* Convert Linux syscall to XFS internal ATTR flags */
> -	if (!size) {
> -		xflags |= ATTR_KERNOVAL;
> -		value = NULL;
> -	}
> +	if (!size)
> +		args.flags |= ATTR_KERNOVAL;
>  
> -	error = xfs_attr_get(ip, name, namelen, (unsigned char **)&value,
> -			     &asize, xflags);
> +	error = xfs_attr_get(&args);
>  	if (error)
>  		return error;
> -	return asize;
> +	return args.valuelen;
>  }
>  
>  void
> -- 
> 2.24.1
> 

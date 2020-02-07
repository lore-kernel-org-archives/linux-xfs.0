Return-Path: <SRS0=0es8=33=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6E5C352A2
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Feb 2020 13:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0302B20720
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Feb 2020 13:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgBGNK0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Feb 2020 08:10:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3082 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726819AbgBGNK0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Feb 2020 08:10:26 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 017DALaN101343
        for <linux-xfs@vger.kernel.org>; Fri, 7 Feb 2020 08:10:24 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0p79rffm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 07 Feb 2020 08:10:24 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Fri, 7 Feb 2020 13:10:19 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 7 Feb 2020 13:10:17 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 017DAHLD61473014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 13:10:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5C8F5204E;
        Fri,  7 Feb 2020 13:10:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.102.23.88])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C409F52063;
        Fri,  7 Feb 2020 13:10:15 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/30] xfs: pass an initialized xfs_da_args to xfs_attr_get
Date:   Fri, 07 Feb 2020 18:43:00 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-13-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-13-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020713-0012-0000-0000-00000384A951
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020713-0013-0000-0000-000021C11A83
Message-Id: <1787383.kW3nU2oyif@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=7 mlxlogscore=999
 priorityscore=1501 adultscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002070102
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 
> Instead of converting from one style of arguments to another in
> xfs_attr_set, pass the structure from higher up in the call chain.
>

The newly introduced changes logically match with the code flow that existed
earlier.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 80 ++++++++++++----------------------------
>  fs/xfs/libxfs/xfs_attr.h |  4 +-
>  fs/xfs/xfs_acl.c         | 35 ++++++++----------
>  fs/xfs/xfs_ioctl.c       | 25 ++++++++-----
>  fs/xfs/xfs_xattr.c       | 24 ++++++------
>  5 files changed, 68 insertions(+), 100 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index eea6d90af276..288b39e81efd 100644
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
> index e9ae7cbe1973..780924984492 100644
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
> index 47a88b5cfa63..2da22595f828 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -357,27 +357,32 @@ xfs_attrmulti_attr_get(
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
> 


-- 
chandan




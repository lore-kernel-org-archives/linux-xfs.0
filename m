Return-Path: <SRS0=0es8=33=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A85C352A3
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Feb 2020 09:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31DAC24691
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Feb 2020 09:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgBGJjc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Feb 2020 04:39:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63042 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbgBGJjc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Feb 2020 04:39:32 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0179buKf002192
        for <linux-xfs@vger.kernel.org>; Fri, 7 Feb 2020 04:39:31 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0knes5ew-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 07 Feb 2020 04:39:31 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Fri, 7 Feb 2020 09:39:28 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 7 Feb 2020 09:39:25 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0179cVXd42992036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 09:38:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5927FA4040;
        Fri,  7 Feb 2020 09:39:24 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59176A404D;
        Fri,  7 Feb 2020 09:39:21 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.125.39])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  7 Feb 2020 09:39:20 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/30] xfs: pass an initialized xfs_da_args structure to xfs_attr_set
Date:   Fri, 07 Feb 2020 15:12:06 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-12-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-12-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020709-0012-0000-0000-000003849794
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020709-0013-0000-0000-000021C10833
Message-Id: <3555829.Ga2YY0DfQR@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 suspectscore=7 mlxlogscore=999 adultscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002070072
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 
> Instead of converting from one style of arguments to another in
> xfs_attr_set, pass the structure from higher up in the call chain.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 69 ++++++++++++++++++----------------------
>  fs/xfs/libxfs/xfs_attr.h |  3 +-
>  fs/xfs/xfs_acl.c         | 31 +++++++++---------
>  fs/xfs/xfs_ioctl.c       | 20 +++++++-----
>  fs/xfs/xfs_iops.c        | 13 +++++---
>  fs/xfs/xfs_xattr.c       | 19 +++++++----
>  6 files changed, 81 insertions(+), 74 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f887d62e0956..eea6d90af276 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -330,22 +330,17 @@ xfs_attr_remove_args(
>  }
> 
>  /*
> - * Note: If value is NULL the attribute will be removed, just like the
> + * Note: If args->value is NULL the attribute will be removed, just like the
>   * Linux ->setattr API.
>   */
>  int
>  xfs_attr_set(
> -	struct xfs_inode	*dp,
> -	const unsigned char	*name,
> -	size_t			namelen,
> -	unsigned char		*value,
> -	int			valuelen,
> -	int			flags)
> +	struct xfs_da_args	*args)
>  {
> +	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
> -	struct xfs_da_args	args;
>  	struct xfs_trans_res	tres;
> -	int			rsvd = (flags & ATTR_ROOT) != 0;
> +	int			rsvd = (args->flags & ATTR_ROOT) != 0;
>  	int			error, local;
>  	unsigned int		total;
> 
> @@ -356,25 +351,22 @@ xfs_attr_set(
>  	if (error)
>  		return error;
> 
> -	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
> -	if (error)
> -		return error;
> -
> -	args.value = value;
> -	args.valuelen = valuelen;
> +	args->geo = mp->m_attr_geo;
> +	args->whichfork = XFS_ATTR_FORK;
> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
> 
>  	/*
>  	 * We have no control over the attribute names that userspace passes us
>  	 * to remove, so we have to allow the name lookup prior to attribute
>  	 * removal to fail as well.
>  	 */
> -	args.op_flags = XFS_DA_OP_OKNOENT;
> +	args->op_flags = XFS_DA_OP_OKNOENT;
> 
> -	if (value) {
> +	if (args->value) {
>  		XFS_STATS_INC(mp, xs_attr_set);
> 
> -		args.op_flags |= XFS_DA_OP_ADDNAME;
> -		args.total = xfs_attr_calc_size(&args, &local);
> +		args->op_flags |= XFS_DA_OP_ADDNAME;
> +		args->total = xfs_attr_calc_size(args, &local);
> 
>  		/*
>  		 * If the inode doesn't have an attribute fork, add one.
> @@ -382,8 +374,8 @@ xfs_attr_set(
>  		 */
>  		if (XFS_IFORK_Q(dp) == 0) {
>  			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
> -				XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen,
> -						valuelen);
> +				XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen,
> +						args->valuelen);
> 
>  			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
>  			if (error)
> @@ -391,10 +383,11 @@ xfs_attr_set(
>  		}
> 
>  		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> -				 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
> +				 M_RES(mp)->tr_attrsetrt.tr_logres *
> +					args->total;
>  		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>  		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> -		total = args.total;
> +		total = args->total;
>  	} else {
>  		XFS_STATS_INC(mp, xs_attr_remove);
> 
> @@ -407,29 +400,29 @@ xfs_attr_set(
>  	 * operation if necessary
>  	 */
>  	error = xfs_trans_alloc(mp, &tres, total, 0,
> -			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
> +			rsvd ? XFS_TRANS_RESERVE : 0, &args->trans);
>  	if (error)
>  		return error;
> 
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(args.trans, dp, 0);
> -	if (value) {
> +	xfs_trans_ijoin(args->trans, dp, 0);
> +	if (args->value) {
>  		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
> 
>  		if (rsvd)
>  			quota_flags |= XFS_QMOPT_FORCE_RES;
> -		error = xfs_trans_reserve_quota_nblks(args.trans, dp,
> -				args.total, 0, quota_flags);
> +		error = xfs_trans_reserve_quota_nblks(args->trans, dp,
> +				args->total, 0, quota_flags);
>  		if (error)
>  			goto out_trans_cancel;
> -		error = xfs_attr_set_args(&args);
> +		error = xfs_attr_set_args(args);
>  		if (error)
>  			goto out_trans_cancel;
>  		/* shortform attribute has already been committed */
> -		if (!args.trans)
> +		if (!args->trans)
>  			goto out_unlock;
>  	} else {
> -		error = xfs_attr_remove_args(&args);
> +		error = xfs_attr_remove_args(args);
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> @@ -439,23 +432,23 @@ xfs_attr_set(
>  	 * transaction goes to disk before returning to the user.
>  	 */
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
> -		xfs_trans_set_sync(args.trans);
> +		xfs_trans_set_sync(args->trans);
> 
> -	if ((flags & ATTR_KERNOTIME) == 0)
> -		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
> +	if ((args->flags & ATTR_KERNOTIME) == 0)
> +		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
> 
>  	/*
>  	 * Commit the last in the sequence of transactions.
>  	 */
> -	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
> -	error = xfs_trans_commit(args.trans);
> +	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
> +	error = xfs_trans_commit(args->trans);
>  out_unlock:
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  	return error;
> 
>  out_trans_cancel:
> -	if (args.trans)
> -		xfs_trans_cancel(args.trans);
> +	if (args->trans)
> +		xfs_trans_cancel(args->trans);
>  	goto out_unlock;
>  }
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index db58a6c7dea5..07ca543db831 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -149,8 +149,7 @@ int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
>  		 size_t namelen, unsigned char **value, int *valuelenp,
>  		 int flags);
> -int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
> -		 size_t namelen, unsigned char *value, int valuelen, int flags);
> +int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 4e76063ff956..e9ae7cbe1973 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -166,41 +166,42 @@ xfs_get_acl(struct inode *inode, int type)
>  int
>  __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
> -	struct xfs_inode *ip = XFS_I(inode);
> -	unsigned char *ea_name;
> -	struct xfs_acl *xfs_acl = NULL;
> -	int len = 0;
> -	int error;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_da_args	args = {
> +		.dp		= ip,
> +		.flags		= ATTR_ROOT,
> +	};
> +	int			error;
> 
>  	switch (type) {
>  	case ACL_TYPE_ACCESS:
> -		ea_name = SGI_ACL_FILE;
> +		args.name = SGI_ACL_FILE;
>  		break;
>  	case ACL_TYPE_DEFAULT:
>  		if (!S_ISDIR(inode->i_mode))
>  			return acl ? -EACCES : 0;
> -		ea_name = SGI_ACL_DEFAULT;
> +		args.name = SGI_ACL_DEFAULT;
>  		break;
>  	default:
>  		return -EINVAL;
>  	}
> +	args.namelen = strlen(args.name);
> 
>  	if (acl) {
> -		len = XFS_ACL_MAX_SIZE(ip->i_mount);
> -		xfs_acl = kmem_zalloc_large(len, 0);
> -		if (!xfs_acl)
> +		args.valuelen = XFS_ACL_MAX_SIZE(ip->i_mount);
> +		args.value = kmem_zalloc_large(args.valuelen, 0);
> +		if (!args.value)
>  			return -ENOMEM;
> 
> -		xfs_acl_to_disk(xfs_acl, acl);
> +		xfs_acl_to_disk(args.value, acl);
> 
>  		/* subtract away the unused acl entries */
> -		len -= sizeof(struct xfs_acl_entry) *
> +		args.valuelen -= sizeof(struct xfs_acl_entry) *
>  			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
>  	}
> 
> -	error = xfs_attr_set(ip, ea_name, strlen(ea_name),
> -			(unsigned char *)xfs_acl, len, ATTR_ROOT);
> -	kmem_free(xfs_acl);
> +	error = xfs_attr_set(&args);
> +	kmem_free(args.value);
> 
>  	/*
>  	 * If the attribute didn't exist to start with that's fine.
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index cfdd80b4ea2d..47a88b5cfa63 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -389,9 +389,13 @@ xfs_attrmulti_attr_set(
>  	uint32_t		len,
>  	uint32_t		flags)
>  {
> -	unsigned char		*kbuf = NULL;
> +	struct xfs_da_args	args = {
> +		.dp		= XFS_I(inode),
> +		.flags		= flags,
> +		.name		= name,
> +		.namelen	= strlen(name),
> +	};
>  	int			error;
> -	size_t			namelen;
> 
>  	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>  		return -EPERM;
> @@ -399,16 +403,16 @@ xfs_attrmulti_attr_set(
>  	if (ubuf) {
>  		if (len > XFS_XATTR_SIZE_MAX)
>  			return -EINVAL;
> -		kbuf = memdup_user(ubuf, len);
> -		if (IS_ERR(kbuf))
> -			return PTR_ERR(kbuf);
> +		args.value = memdup_user(ubuf, len);
> +		if (IS_ERR(args.value))
> +			return PTR_ERR(args.value);
> +		args.valuelen = len;
>  	}
> 
> -	namelen = strlen(name);
> -	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
> +	error = xfs_attr_set(&args);
>  	if (!error)
>  		xfs_forget_acl(inode, name, flags);
> -	kfree(kbuf);
> +	kfree(args.value);
>  	return error;
>  }
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 81f2f93caec0..94cd4254656c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -50,10 +50,15 @@ xfs_initxattrs(
>  	int			error = 0;
> 
>  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> -		error = xfs_attr_set(ip, xattr->name,
> -				     strlen(xattr->name),
> -				     xattr->value, xattr->value_len,
> -				     ATTR_SECURE);
> +		struct xfs_da_args	args = {
> +			.dp		= ip,
> +			.flags		= ATTR_SECURE,
> +			.name		= xattr->name,
> +			.namelen	= strlen(xattr->name),
> +			.value		= xattr->value,
> +			.valuelen	= xattr->value_len,
> +		};
> +		error = xfs_attr_set(&args);
>  		if (error < 0)
>  			break;
>  	}
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 1670bfbc9ad2..09f967f97699 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -66,20 +66,25 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  		struct inode *inode, const char *name, const void *value,
>  		size_t size, int flags)
>  {
> -	int			xflags = handler->flags;
> -	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_da_args	args = {
> +		.dp		= XFS_I(inode),
> +		.flags		= handler->flags,
> +		.name		= name,
> +		.namelen	= strlen(name),
> +		.value		= (unsigned char *)value,

Since xfs_da_args.value is of type "void *', Wouldn't it be more uniform if
'value' is typecasted with (void *)? 

Apart from the above very trival nit, the changes look good to me,

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> +		.valuelen	= size,
> +	};
>  	int			error;
> 
>  	/* Convert Linux syscall to XFS internal ATTR flags */
>  	if (flags & XATTR_CREATE)
> -		xflags |= ATTR_CREATE;
> +		args.flags |= ATTR_CREATE;
>  	if (flags & XATTR_REPLACE)
> -		xflags |= ATTR_REPLACE;
> +		args.flags |= ATTR_REPLACE;
> 
> -	error = xfs_attr_set(ip, (unsigned char *)name, strlen(name),
> -				(void *)value, size, xflags);
> +	error = xfs_attr_set(&args);
>  	if (!error)
> -		xfs_forget_acl(inode, name, xflags);
> +		xfs_forget_acl(inode, name, args.flags);
>  	return error;
>  }
> 
> 


-- 
chandan




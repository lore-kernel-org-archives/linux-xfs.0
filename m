Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC183C2D0B1
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 07:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 924C0214AF
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 07:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBFH5d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 02:57:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726673AbgBFH5c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 02:57:32 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0167s9NZ100254
        for <linux-xfs@vger.kernel.org>; Thu, 6 Feb 2020 02:57:31 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xym4nkvaa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Feb 2020 02:57:31 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Thu, 6 Feb 2020 07:57:29 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Feb 2020 07:57:28 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0167vRd440173626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Feb 2020 07:57:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15B61A4057;
        Thu,  6 Feb 2020 07:57:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13D97A4051;
        Thu,  6 Feb 2020 07:57:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.102.2.200])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Feb 2020 07:57:25 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 03/30] xfs: merge xfs_attr_remove into xfs_attr_set
Date:   Thu, 06 Feb 2020 13:30:11 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-4-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-4-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020607-0016-0000-0000-000002E42BD5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020607-0017-0000-0000-000033471009
Message-Id: <1706193.rOtLxuY5yH@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_06:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 suspectscore=7
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002060062
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 

> The Linux xattr and acl APIs use a single call for set an remove.  Modify
> the high-level XFS API to match that and let xfs_attr_set handle removing
> attributes as well.  With a little bit of reordering this removes a lot
> of code.
>

The newly introduced changes match with the code flow that earlier existed
separately in xfs_attr_set() and xfs_attr_remove().

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 178 ++++++++++++++-------------------------
>  fs/xfs/libxfs/xfs_attr.h |   2 -
>  fs/xfs/xfs_acl.c         |  33 +++-----
>  fs/xfs/xfs_ioctl.c       |   4 +-
>  fs/xfs/xfs_xattr.c       |   9 +-
>  5 files changed, 77 insertions(+), 149 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e6149720ce02..bb391b96cd78 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -336,6 +336,10 @@ xfs_attr_remove_args(
>  	return error;
>  }
> 
> +/*
> + * Note: If value is NULL the attribute will be removed, just like the
> + * Linux ->setattr API.
> + */
>  int
>  xfs_attr_set(
>  	struct xfs_inode	*dp,
> @@ -350,149 +354,92 @@ xfs_attr_set(
>  	struct xfs_trans_res	tres;
>  	int			rsvd = (flags & ATTR_ROOT) != 0;
>  	int			error, local;
> -
> -	XFS_STATS_INC(mp, xs_attr_set);
> +	unsigned int		total;
> 
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return -EIO;
> 
> -	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
> -	if (error)
> -		return error;
> -
> -	args.value = value;
> -	args.valuelen = valuelen;
> -	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> -	args.total = xfs_attr_calc_size(&args, &local);
> -
>  	error = xfs_qm_dqattach(dp);
>  	if (error)
>  		return error;
> 
> -	/*
> -	 * If the inode doesn't have an attribute fork, add one.
> -	 * (inode must not be locked when we call this routine)
> -	 */
> -	if (XFS_IFORK_Q(dp) == 0) {
> -		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
> -			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
> -
> -		error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
> -		if (error)
> -			return error;
> -	}
> -
> -	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> -			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
> -	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> -	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> -
> -	/*
> -	 * Root fork attributes can use reserved data blocks for this
> -	 * operation if necessary
> -	 */
> -	error = xfs_trans_alloc(mp, &tres, args.total, 0,
> -			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
> +	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
>  	if (error)
>  		return error;
> 
> -	xfs_ilock(dp, XFS_ILOCK_EXCL);
> -	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
> -				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
> -				       XFS_QMOPT_RES_REGBLKS);
> -	if (error)
> -		goto out_trans_cancel;
> -
> -	xfs_trans_ijoin(args.trans, dp, 0);
> -	error = xfs_attr_set_args(&args);
> -	if (error)
> -		goto out_trans_cancel;
> -	if (!args.trans) {
> -		/* shortform attribute has already been committed */
> -		goto out_unlock;
> -	}
> -
> -	/*
> -	 * If this is a synchronous mount, make sure that the
> -	 * transaction goes to disk before returning to the user.
> -	 */
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> -		xfs_trans_set_sync(args.trans);
> -
> -	if ((flags & ATTR_KERNOTIME) == 0)
> -		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
> +	args.value = value;
> +	args.valuelen = valuelen;
> 
>  	/*
> -	 * Commit the last in the sequence of transactions.
> +	 * We have no control over the attribute names that userspace passes us
> +	 * to remove, so we have to allow the name lookup prior to attribute
> +	 * removal to fail as well.
>  	 */
> -	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
> -	error = xfs_trans_commit(args.trans);
> -out_unlock:
> -	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> -	return error;
> -
> -out_trans_cancel:
> -	if (args.trans)
> -		xfs_trans_cancel(args.trans);
> -	goto out_unlock;
> -}
> +	args.op_flags = XFS_DA_OP_OKNOENT;
> 
> -/*
> - * Generic handler routine to remove a name from an attribute list.
> - * Transitions attribute list from Btree to shortform as necessary.
> - */
> -int
> -xfs_attr_remove(
> -	struct xfs_inode	*dp,
> -	const unsigned char	*name,
> -	size_t			namelen,
> -	int			flags)
> -{
> -	struct xfs_mount	*mp = dp->i_mount;
> -	struct xfs_da_args	args;
> -	int			error;
> +	if (value) {
> +		XFS_STATS_INC(mp, xs_attr_set);
> 
> -	XFS_STATS_INC(mp, xs_attr_remove);
> +		args.op_flags |= XFS_DA_OP_ADDNAME;
> +		args.total = xfs_attr_calc_size(&args, &local);
> 
> -	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
> -		return -EIO;
> +		/*
> +		 * If the inode doesn't have an attribute fork, add one.
> +		 * (inode must not be locked when we call this routine)
> +		 */
> +		if (XFS_IFORK_Q(dp) == 0) {
> +			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
> +				XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen,
> +						valuelen);
> 
> -	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
> -	if (error)
> -		return error;
> +			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
> +			if (error)
> +				return error;
> +		}
> 
> -	/*
> -	 * we have no control over the attribute names that userspace passes us
> -	 * to remove, so we have to allow the name lookup prior to attribute
> -	 * removal to fail.
> -	 */
> -	args.op_flags = XFS_DA_OP_OKNOENT;
> +		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> +				 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
> +		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> +		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> +		total = args.total;
> +	} else {
> +		XFS_STATS_INC(mp, xs_attr_remove);
> 
> -	error = xfs_qm_dqattach(dp);
> -	if (error)
> -		return error;
> +		tres = M_RES(mp)->tr_attrrm;
> +		total = XFS_ATTRRM_SPACE_RES(mp);
> +	}
> 
>  	/*
>  	 * Root fork attributes can use reserved data blocks for this
>  	 * operation if necessary
>  	 */
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
> -			XFS_ATTRRM_SPACE_RES(mp), 0,
> -			(flags & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
> -			&args.trans);
> +	error = xfs_trans_alloc(mp, &tres, total, 0,
> +			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
>  	if (error)
>  		return error;
> 
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
> -	/*
> -	 * No need to make quota reservations here. We expect to release some
> -	 * blocks not allocate in the common case.
> -	 */
>  	xfs_trans_ijoin(args.trans, dp, 0);
> +	if (value) {
> +		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
> 
> -	error = xfs_attr_remove_args(&args);
> -	if (error)
> -		goto out;
> +		if (rsvd)
> +			quota_flags |= XFS_QMOPT_FORCE_RES;
> +		error = xfs_trans_reserve_quota_nblks(args.trans, dp,
> +				args.total, 0, quota_flags);
> +		if (error)
> +			goto out_trans_cancel;
> +		error = xfs_attr_set_args(&args);
> +		if (error)
> +			goto out_trans_cancel;
> +		/* shortform attribute has already been committed */
> +		if (!args.trans)
> +			goto out_unlock;
> +	} else {
> +		error = xfs_attr_remove_args(&args);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> 
>  	/*
>  	 * If this is a synchronous mount, make sure that the
> @@ -509,15 +456,14 @@ xfs_attr_remove(
>  	 */
>  	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
>  	error = xfs_trans_commit(args.trans);
> +out_unlock:
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> -
>  	return error;
> 
> -out:
> +out_trans_cancel:
>  	if (args.trans)
>  		xfs_trans_cancel(args.trans);
> -	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> -	return error;
> +	goto out_unlock;
>  }
> 
>  /*========================================================================
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 71bcf1298e4c..db58a6c7dea5 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -152,8 +152,6 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
>  int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
>  		 size_t namelen, unsigned char *value, int valuelen, int flags);
>  int xfs_attr_set_args(struct xfs_da_args *args);
> -int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
> -		    size_t namelen, int flags);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index cd743fad8478..4e76063ff956 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -168,6 +168,8 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
>  	struct xfs_inode *ip = XFS_I(inode);
>  	unsigned char *ea_name;
> +	struct xfs_acl *xfs_acl = NULL;
> +	int len = 0;
>  	int error;
> 
>  	switch (type) {
> @@ -184,9 +186,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  	}
> 
>  	if (acl) {
> -		struct xfs_acl *xfs_acl;
> -		int len = XFS_ACL_MAX_SIZE(ip->i_mount);
> -
> +		len = XFS_ACL_MAX_SIZE(ip->i_mount);
>  		xfs_acl = kmem_zalloc_large(len, 0);
>  		if (!xfs_acl)
>  			return -ENOMEM;
> @@ -196,26 +196,17 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  		/* subtract away the unused acl entries */
>  		len -= sizeof(struct xfs_acl_entry) *
>  			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
> -
> -		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
> -				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
> -
> -		kmem_free(xfs_acl);
> -	} else {
> -		/*
> -		 * A NULL ACL argument means we want to remove the ACL.
> -		 */
> -		error = xfs_attr_remove(ip, ea_name,
> -					strlen(ea_name),
> -					ATTR_ROOT);
> -
> -		/*
> -		 * If the attribute didn't exist to start with that's fine.
> -		 */
> -		if (error == -ENOATTR)
> -			error = 0;
>  	}
> 
> +	error = xfs_attr_set(ip, ea_name, strlen(ea_name),
> +			(unsigned char *)xfs_acl, len, ATTR_ROOT);
> +	kmem_free(xfs_acl);
> +
> +	/*
> +	 * If the attribute didn't exist to start with that's fine.
> +	 */
> +	if (!acl && error == -ENOATTR)
> +		error = 0;
>  	if (!error)
>  		set_cached_acl(inode, type, acl);
>  	return error;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d974bf099d45..79c418888e9a 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -417,12 +417,10 @@ xfs_attrmulti_attr_remove(
>  	uint32_t		flags)
>  {
>  	int			error;
> -	size_t			namelen;
> 
>  	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>  		return -EPERM;
> -	namelen = strlen(name);
> -	error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
> +	error = xfs_attr_set(XFS_I(inode), name, strlen(name), NULL, 0, flags);
>  	if (!error)
>  		xfs_forget_acl(inode, name, flags);
>  	return error;
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index b0fedb543f97..1670bfbc9ad2 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -69,7 +69,6 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  	int			xflags = handler->flags;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error;
> -	size_t			namelen = strlen(name);
> 
>  	/* Convert Linux syscall to XFS internal ATTR flags */
>  	if (flags & XATTR_CREATE)
> @@ -77,14 +76,10 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  	if (flags & XATTR_REPLACE)
>  		xflags |= ATTR_REPLACE;
> 
> -	if (value)
> -		error = xfs_attr_set(ip, name, namelen, (void *)value, size,
> -				xflags);
> -	else
> -		error = xfs_attr_remove(ip, name, namelen, xflags);
> +	error = xfs_attr_set(ip, (unsigned char *)name, strlen(name),
> +				(void *)value, size, xflags);
>  	if (!error)
>  		xfs_forget_acl(inode, name, xflags);
> -
>  	return error;
>  }
> 
> 


-- 
chandan




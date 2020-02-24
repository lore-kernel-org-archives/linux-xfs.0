Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C55C35671
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 12:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4A0420828
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 12:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgBXMFr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 07:05:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727185AbgBXMFr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 07:05:47 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OC5GhH124305
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2020 07:05:46 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb12apu05-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2020 07:05:45 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 24 Feb 2020 12:05:44 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 24 Feb 2020 12:05:41 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01OC5ePo63176846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 12:05:40 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25AC2A4060;
        Mon, 24 Feb 2020 12:05:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36E18A405B;
        Mon, 24 Feb 2020 12:05:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.91.136])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 12:05:38 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v7 01/19] xfs: Replace attribute parameters with struct xfs_name
Date:   Mon, 24 Feb 2020 17:38:31 +0530
Organization: IBM
In-Reply-To: <20200223020611.1802-2-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022412-0020-0000-0000-000003AD1492
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022412-0021-0000-0000-00002205258B
Message-Id: <1635715.8B5ru1jVeS@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_03:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 suspectscore=10
 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240101
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 7:35 AM Allison Collins wrote: 
> This patch replaces the attribute name and length parameters with a single struct
> xfs_name parameter.  This helps to clean up the numbers of parameters being passed
> around and pre-simplifies the code some.
>

I don't see any logical errors.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c  | 22 +++++++++-------------
>  fs/xfs/libxfs/xfs_attr.h  | 12 +++++-------
>  fs/xfs/libxfs/xfs_types.c | 11 +++++++++++
>  fs/xfs/libxfs/xfs_types.h |  1 +
>  fs/xfs/xfs_acl.c          | 25 +++++++++++--------------
>  fs/xfs/xfs_ioctl.c        | 23 +++++++++++++----------
>  fs/xfs/xfs_iops.c         |  6 +++---
>  fs/xfs/xfs_xattr.c        | 28 ++++++++++++++++------------
>  8 files changed, 69 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e614972..6717f47 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -61,8 +61,7 @@ STATIC int
>  xfs_attr_args_init(
>  	struct xfs_da_args	*args,
>  	struct xfs_inode	*dp,
> -	const unsigned char	*name,
> -	size_t			namelen,
> +	struct xfs_name		*name,
>  	int			flags)
>  {
>  
> @@ -74,8 +73,8 @@ xfs_attr_args_init(
>  	args->whichfork = XFS_ATTR_FORK;
>  	args->dp = dp;
>  	args->flags = flags;
> -	args->name = name;
> -	args->namelen = namelen;
> +	args->name = name->name;
> +	args->namelen = name->len;
>  	if (args->namelen >= MAXNAMELEN)
>  		return -EFAULT;		/* match IRIX behaviour */
>  
> @@ -139,8 +138,7 @@ xfs_attr_get_ilocked(
>  int
>  xfs_attr_get(
>  	struct xfs_inode	*ip,
> -	const unsigned char	*name,
> -	size_t			namelen,
> +	struct xfs_name		*name,
>  	unsigned char		**value,
>  	int			*valuelenp,
>  	int			flags)
> @@ -156,7 +154,7 @@ xfs_attr_get(
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> -	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
> +	error = xfs_attr_args_init(&args, ip, name, flags);
>  	if (error)
>  		return error;
>  
> @@ -339,8 +337,7 @@ xfs_attr_remove_args(
>  int
>  xfs_attr_set(
>  	struct xfs_inode	*dp,
> -	const unsigned char	*name,
> -	size_t			namelen,
> +	struct xfs_name		*name,
>  	unsigned char		*value,
>  	int			valuelen,
>  	int			flags)
> @@ -356,7 +353,7 @@ xfs_attr_set(
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return -EIO;
>  
> -	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
> +	error = xfs_attr_args_init(&args, dp, name, flags);
>  	if (error)
>  		return error;
>  
> @@ -444,8 +441,7 @@ xfs_attr_set(
>  int
>  xfs_attr_remove(
>  	struct xfs_inode	*dp,
> -	const unsigned char	*name,
> -	size_t			namelen,
> +	struct xfs_name		*name,
>  	int			flags)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
> @@ -457,7 +453,7 @@ xfs_attr_remove(
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return -EIO;
>  
> -	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
> +	error = xfs_attr_args_init(&args, dp, name, flags);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 4243b22..35043db 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -147,14 +147,12 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
>  int xfs_attr_list_int(struct xfs_attr_list_context *);
>  int xfs_inode_hasattr(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
> -int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
> -		 size_t namelen, unsigned char **value, int *valuelenp,
> -		 int flags);
> -int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
> -		 size_t namelen, unsigned char *value, int valuelen, int flags);
> +int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
> +		 unsigned char **value, int *valuelenp, int flags);
> +int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
> +		 unsigned char *value, int valuelen, int flags);
>  int xfs_attr_set_args(struct xfs_da_args *args);
> -int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
> -		    size_t namelen, int flags);
> +int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> index 4f59554..781a5a9 100644
> --- a/fs/xfs/libxfs/xfs_types.c
> +++ b/fs/xfs/libxfs/xfs_types.c
> @@ -12,6 +12,17 @@
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
>  
> +/* Initialize a struct xfs_name with a null terminated string name */
> +void
> +xfs_name_init(
> +	struct xfs_name *xname,
> +	const char *name)
> +{
> +	xname->name = (unsigned char *)name;
> +	xname->len = strlen(name);
> +	xname->type = 0;
> +}
> +
>  /* Find the size of the AG, in blocks. */
>  xfs_agblock_t
>  xfs_ag_block_count(
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 397d947..b94acb5 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -180,6 +180,7 @@ enum xfs_ag_resv_type {
>   */
>  struct xfs_mount;
>  
> +void xfs_name_init(struct xfs_name *xname, const char *name);
>  xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
>  bool xfs_verify_agbno(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		xfs_agblock_t agbno);
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index cd743fad..42ac847 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -123,7 +123,7 @@ xfs_get_acl(struct inode *inode, int type)
>  	struct xfs_inode *ip = XFS_I(inode);
>  	struct posix_acl *acl = NULL;
>  	struct xfs_acl *xfs_acl = NULL;
> -	unsigned char *ea_name;
> +	struct xfs_name name;
>  	int error;
>  	int len;
>  
> @@ -131,10 +131,10 @@ xfs_get_acl(struct inode *inode, int type)
>  
>  	switch (type) {
>  	case ACL_TYPE_ACCESS:
> -		ea_name = SGI_ACL_FILE;
> +		xfs_name_init(&name, SGI_ACL_FILE);
>  		break;
>  	case ACL_TYPE_DEFAULT:
> -		ea_name = SGI_ACL_DEFAULT;
> +		xfs_name_init(&name, SGI_ACL_DEFAULT);
>  		break;
>  	default:
>  		BUG();
> @@ -145,9 +145,8 @@ xfs_get_acl(struct inode *inode, int type)
>  	 * go out to the disk.
>  	 */
>  	len = XFS_ACL_MAX_SIZE(ip->i_mount);
> -	error = xfs_attr_get(ip, ea_name, strlen(ea_name),
> -				(unsigned char **)&xfs_acl, &len,
> -				ATTR_ALLOC | ATTR_ROOT);
> +	error = xfs_attr_get(ip, &name, (unsigned char **)&xfs_acl, &len,
> +			     ATTR_ALLOC | ATTR_ROOT);
>  	if (error) {
>  		/*
>  		 * If the attribute doesn't exist make sure we have a negative
> @@ -167,17 +166,17 @@ int
>  __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
>  	struct xfs_inode *ip = XFS_I(inode);
> -	unsigned char *ea_name;
> +	struct xfs_name name;
>  	int error;
>  
>  	switch (type) {
>  	case ACL_TYPE_ACCESS:
> -		ea_name = SGI_ACL_FILE;
> +		xfs_name_init(&name, SGI_ACL_FILE);
>  		break;
>  	case ACL_TYPE_DEFAULT:
>  		if (!S_ISDIR(inode->i_mode))
>  			return acl ? -EACCES : 0;
> -		ea_name = SGI_ACL_DEFAULT;
> +		xfs_name_init(&name, SGI_ACL_DEFAULT);
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -197,17 +196,15 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  		len -= sizeof(struct xfs_acl_entry) *
>  			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
>  
> -		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
> -				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
> +		error = xfs_attr_set(ip, &name, (unsigned char *)xfs_acl, len,
> +				     ATTR_ROOT);
>  
>  		kmem_free(xfs_acl);
>  	} else {
>  		/*
>  		 * A NULL ACL argument means we want to remove the ACL.
>  		 */
> -		error = xfs_attr_remove(ip, ea_name,
> -					strlen(ea_name),
> -					ATTR_ROOT);
> +		error = xfs_attr_remove(ip, &name, ATTR_ROOT);
>  
>  		/*
>  		 * If the attribute didn't exist to start with that's fine.
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d42de92..28c07c9 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -357,7 +357,9 @@ xfs_attrmulti_attr_get(
>  {
>  	unsigned char		*kbuf;
>  	int			error = -EFAULT;
> -	size_t			namelen;
> +	struct xfs_name		xname;
> +
> +	xfs_name_init(&xname, name);
>  
>  	if (*len > XFS_XATTR_SIZE_MAX)
>  		return -EINVAL;
> @@ -365,9 +367,7 @@ xfs_attrmulti_attr_get(
>  	if (!kbuf)
>  		return -ENOMEM;
>  
> -	namelen = strlen(name);
> -	error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
> -			     flags);
> +	error = xfs_attr_get(XFS_I(inode), &xname, &kbuf, (int *)len, flags);
>  	if (error)
>  		goto out_kfree;
>  
> @@ -389,7 +389,9 @@ xfs_attrmulti_attr_set(
>  {
>  	unsigned char		*kbuf;
>  	int			error;
> -	size_t			namelen;
> +	struct xfs_name		xname;
> +
> +	xfs_name_init(&xname, name);
>  
>  	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>  		return -EPERM;
> @@ -400,8 +402,7 @@ xfs_attrmulti_attr_set(
>  	if (IS_ERR(kbuf))
>  		return PTR_ERR(kbuf);
>  
> -	namelen = strlen(name);
> -	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
> +	error = xfs_attr_set(XFS_I(inode), &xname, kbuf, len, flags);
>  	if (!error)
>  		xfs_forget_acl(inode, name, flags);
>  	kfree(kbuf);
> @@ -415,12 +416,14 @@ xfs_attrmulti_attr_remove(
>  	uint32_t		flags)
>  {
>  	int			error;
> -	size_t			namelen;
> +	struct xfs_name		xname;
> +
> +	xfs_name_init(&xname, name);
>  
>  	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>  		return -EPERM;
> -	namelen = strlen(name);
> -	error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
> +
> +	error = xfs_attr_remove(XFS_I(inode), &xname, flags);
>  	if (!error)
>  		xfs_forget_acl(inode, name, flags);
>  	return error;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 81f2f93..e85bbf5 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -48,11 +48,11 @@ xfs_initxattrs(
>  	const struct xattr	*xattr;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error = 0;
> +	struct xfs_name		name;
>  
>  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> -		error = xfs_attr_set(ip, xattr->name,
> -				     strlen(xattr->name),
> -				     xattr->value, xattr->value_len,
> +		xfs_name_init(&name, xattr->name);
> +		error = xfs_attr_set(ip, &name, xattr->value, xattr->value_len,
>  				     ATTR_SECURE);
>  		if (error < 0)
>  			break;
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index b0fedb5..74133a5 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -21,10 +21,12 @@ static int
>  xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>  		struct inode *inode, const char *name, void *value, size_t size)
>  {
> -	int xflags = handler->flags;
> -	struct xfs_inode *ip = XFS_I(inode);
> -	int error, asize = size;
> -	size_t namelen = strlen(name);
> +	int			xflags = handler->flags;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	int			error, asize = size;
> +	struct xfs_name		xname;
> +
> +	xfs_name_init(&xname, name);
>  
>  	/* Convert Linux syscall to XFS internal ATTR flags */
>  	if (!size) {
> @@ -32,8 +34,8 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>  		value = NULL;
>  	}
>  
> -	error = xfs_attr_get(ip, name, namelen, (unsigned char **)&value,
> -			     &asize, xflags);
> +	error = xfs_attr_get(ip, &xname, (unsigned char **)&value, &asize,
> +			     xflags);
>  	if (error)
>  		return error;
>  	return asize;
> @@ -69,7 +71,9 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  	int			xflags = handler->flags;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error;
> -	size_t			namelen = strlen(name);
> +	struct xfs_name		xname;
> +
> +	xfs_name_init(&xname, name);
>  
>  	/* Convert Linux syscall to XFS internal ATTR flags */
>  	if (flags & XATTR_CREATE)
> @@ -77,11 +81,11 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  	if (flags & XATTR_REPLACE)
>  		xflags |= ATTR_REPLACE;
>  
> -	if (value)
> -		error = xfs_attr_set(ip, name, namelen, (void *)value, size,
> -				xflags);
> -	else
> -		error = xfs_attr_remove(ip, name, namelen, xflags);
> +        if (value)
> +               error = xfs_attr_set(ip, &xname, (void *)value, size, xflags);
> +        else
> +               error = xfs_attr_remove(ip, &xname, xflags);
> +
>  	if (!error)
>  		xfs_forget_acl(inode, name, xflags);
>  
> 


-- 
chandan




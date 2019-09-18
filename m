Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51421C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B29521907
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387701AbfIRQnE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 12:43:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387625AbfIRQnE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 12:43:04 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D01433082B4B;
        Wed, 18 Sep 2019 16:43:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65E0E6060D;
        Wed, 18 Sep 2019 16:43:03 +0000 (UTC)
Date:   Wed, 18 Sep 2019 12:43:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 01/19] xfs: Replace attribute parameters with struct
 xfs_name
Message-ID: <20190918164301.GE29377@bfoster>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905221837.17388-2-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 18 Sep 2019 16:43:03 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 03:18:19PM -0700, Allison Collins wrote:
> This patch replaces the attribute name, length and flags parameters with a
> single struct xfs_name parameter.  This helps to clean up the numbers of
> parameters being passed around and pre-simplifies the code some.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 46 +++++++++++++++++++---------------------------
>  fs/xfs/libxfs/xfs_attr.h | 12 +++++-------
>  fs/xfs/xfs_acl.c         | 27 +++++++++++++--------------
>  fs/xfs/xfs_ioctl.c       | 28 ++++++++++++++++++----------
>  fs/xfs/xfs_iops.c        | 12 ++++++++----
>  fs/xfs/xfs_xattr.c       | 30 +++++++++++++++++-------------
>  6 files changed, 80 insertions(+), 75 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 7589cb7..d0308d6 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -139,30 +137,28 @@ xfs_attr_get_ilocked(
>  int
>  xfs_attr_get(
>  	struct xfs_inode	*ip,
> -	const unsigned char	*name,
> -	size_t			namelen,
> +	struct xfs_name		*name,
>  	unsigned char		**value,
> -	int			*valuelenp,
> -	int			flags)
> +	int			*valuelenp)
>  {
>  	struct xfs_da_args	args;
>  	uint			lock_mode;
>  	int			error;
>  
> -	ASSERT((flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || *value);
> +	ASSERT((name->type & (ATTR_ALLOC | ATTR_KERNOVAL)) || *value);

While this looks like a nice cleanup, I'm not a huge fan of burying the
attr flags in the xfs_name like this. To me they are distinct parameters
and the interface isn't as clear for new callers. Other than that the
patch looks good.

BTW after looking at the next patch, a reasonable compromise might be to
leave the flags param for the top level xfs_attr_*() functions and then
bury the value in args->name.type for the rest of the lower level code
to use. Just a thought..

Brian

>  
>  	XFS_STATS_INC(ip->i_mount, xs_attr_get);
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> -	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
> +	error = xfs_attr_args_init(&args, ip, name);
>  	if (error)
>  		return error;
>  
>  	/* Entirely possible to look up a name which doesn't exist */
>  	args.op_flags = XFS_DA_OP_OKNOENT;
> -	if (flags & ATTR_ALLOC)
> +	if (name->type & ATTR_ALLOC)
>  		args.op_flags |= XFS_DA_OP_ALLOCVAL;
>  	else
>  		args.value = *value;
> @@ -175,7 +171,7 @@ xfs_attr_get(
>  
>  	/* on error, we have to clean up allocated value buffers */
>  	if (error) {
> -		if (flags & ATTR_ALLOC) {
> +		if (name->type & ATTR_ALLOC) {
>  			kmem_free(args.value);
>  			*value = NULL;
>  		}
> @@ -339,16 +335,14 @@ xfs_attr_remove_args(
>  int
>  xfs_attr_set(
>  	struct xfs_inode	*dp,
> -	const unsigned char	*name,
> -	size_t			namelen,
> +	struct xfs_name		*name,
>  	unsigned char		*value,
> -	int			valuelen,
> -	int			flags)
> +	int			valuelen)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_da_args	args;
>  	struct xfs_trans_res	tres;
> -	int			rsvd = (flags & ATTR_ROOT) != 0;
> +	int			rsvd = (name->type & ATTR_ROOT) != 0;
>  	int			error, local;
>  
>  	XFS_STATS_INC(mp, xs_attr_set);
> @@ -356,7 +350,7 @@ xfs_attr_set(
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return -EIO;
>  
> -	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
> +	error = xfs_attr_args_init(&args, dp, name);
>  	if (error)
>  		return error;
>  
> @@ -419,7 +413,7 @@ xfs_attr_set(
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(args.trans);
>  
> -	if ((flags & ATTR_KERNOTIME) == 0)
> +	if ((name->type & ATTR_KERNOTIME) == 0)
>  		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
>  
>  	/*
> @@ -444,9 +438,7 @@ xfs_attr_set(
>  int
>  xfs_attr_remove(
>  	struct xfs_inode	*dp,
> -	const unsigned char	*name,
> -	size_t			namelen,
> -	int			flags)
> +	struct xfs_name		*name)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_da_args	args;
> @@ -457,7 +449,7 @@ xfs_attr_remove(
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return -EIO;
>  
> -	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
> +	error = xfs_attr_args_init(&args, dp, name);
>  	if (error)
>  		return error;
>  
> @@ -478,7 +470,7 @@ xfs_attr_remove(
>  	 */
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
>  			XFS_ATTRRM_SPACE_RES(mp), 0,
> -			(flags & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
> +			(name->type & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
>  			&args.trans);
>  	if (error)
>  		return error;
> @@ -501,7 +493,7 @@ xfs_attr_remove(
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(args.trans);
>  
> -	if ((flags & ATTR_KERNOTIME) == 0)
> +	if ((name->type & ATTR_KERNOTIME) == 0)
>  		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 106a2f2..cedb4e2 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -144,14 +144,12 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
>  int xfs_attr_list_int(struct xfs_attr_list_context *);
>  int xfs_inode_hasattr(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
> -int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
> -		 size_t namelen, unsigned char **value, int *valuelenp,
> -		 int flags);
> -int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
> -		 size_t namelen, unsigned char *value, int valuelen, int flags);
> +int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
> +		 unsigned char **value, int *valuelenp);
> +int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
> +		 unsigned char *value, int valuelen);
>  int xfs_attr_set_args(struct xfs_da_args *args);
> -int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
> -		    size_t namelen, int flags);
> +int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 12be708..f8fb6e10 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -113,7 +113,7 @@ xfs_get_acl(struct inode *inode, int type)
>  	struct xfs_inode *ip = XFS_I(inode);
>  	struct posix_acl *acl = NULL;
>  	struct xfs_acl *xfs_acl = NULL;
> -	unsigned char *ea_name;
> +	struct xfs_name name;
>  	int error;
>  	int len;
>  
> @@ -121,10 +121,10 @@ xfs_get_acl(struct inode *inode, int type)
>  
>  	switch (type) {
>  	case ACL_TYPE_ACCESS:
> -		ea_name = SGI_ACL_FILE;
> +		name.name = SGI_ACL_FILE;
>  		break;
>  	case ACL_TYPE_DEFAULT:
> -		ea_name = SGI_ACL_DEFAULT;
> +		name.name = SGI_ACL_DEFAULT;
>  		break;
>  	default:
>  		BUG();
> @@ -135,9 +135,9 @@ xfs_get_acl(struct inode *inode, int type)
>  	 * go out to the disk.
>  	 */
>  	len = XFS_ACL_MAX_SIZE(ip->i_mount);
> -	error = xfs_attr_get(ip, ea_name, strlen(ea_name), 
> -				(unsigned char **)&xfs_acl, &len,
> -				ATTR_ALLOC | ATTR_ROOT);
> +	name.len = strlen(name.name);
> +	name.type = ATTR_ALLOC | ATTR_ROOT;
> +	error = xfs_attr_get(ip, &name, (unsigned char **)&xfs_acl, &len);
>  	if (error) {
>  		/*
>  		 * If the attribute doesn't exist make sure we have a negative
> @@ -157,17 +157,17 @@ int
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
> +		name.name = SGI_ACL_FILE;
>  		break;
>  	case ACL_TYPE_DEFAULT:
>  		if (!S_ISDIR(inode->i_mode))
>  			return acl ? -EACCES : 0;
> -		ea_name = SGI_ACL_DEFAULT;
> +		name.name = SGI_ACL_DEFAULT;
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -187,17 +187,16 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  		len -= sizeof(struct xfs_acl_entry) *
>  			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
>  
> -		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
> -				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
> +		name.len = strlen(name.name);
> +		name.type = ATTR_ROOT;
> +		error = xfs_attr_set(ip, &name, (unsigned char *)xfs_acl, len);
>  
>  		kmem_free(xfs_acl);
>  	} else {
>  		/*
>  		 * A NULL ACL argument means we want to remove the ACL.
>  		 */
> -		error = xfs_attr_remove(ip, ea_name,
> -					strlen(ea_name),
> -					ATTR_ROOT);
> +		error = xfs_attr_remove(ip, &name);
>  
>  		/*
>  		 * If the attribute didn't exist to start with that's fine.
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d440426..626420d 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -431,7 +431,11 @@ xfs_attrmulti_attr_get(
>  {
>  	unsigned char		*kbuf;
>  	int			error = -EFAULT;
> -	size_t			namelen;
> +	struct xfs_name		xname = {
> +		.name		= name,
> +		.len		= strlen(name),
> +		.type		= flags,
> +	};
>  
>  	if (*len > XFS_XATTR_SIZE_MAX)
>  		return -EINVAL;
> @@ -439,9 +443,7 @@ xfs_attrmulti_attr_get(
>  	if (!kbuf)
>  		return -ENOMEM;
>  
> -	namelen = strlen(name);
> -	error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
> -			     flags);
> +	error = xfs_attr_get(XFS_I(inode), &xname, &kbuf, (int *)len);
>  	if (error)
>  		goto out_kfree;
>  
> @@ -463,7 +465,7 @@ xfs_attrmulti_attr_set(
>  {
>  	unsigned char		*kbuf;
>  	int			error;
> -	size_t			namelen;
> +	struct xfs_name		xname;
>  
>  	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>  		return -EPERM;
> @@ -474,8 +476,10 @@ xfs_attrmulti_attr_set(
>  	if (IS_ERR(kbuf))
>  		return PTR_ERR(kbuf);
>  
> -	namelen = strlen(name);
> -	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
> +	xname.name = name;
> +	xname.len = strlen(name);
> +	xname.type = flags;
> +	error = xfs_attr_set(XFS_I(inode), &xname, kbuf, len);
>  	if (!error)
>  		xfs_forget_acl(inode, name, flags);
>  	kfree(kbuf);
> @@ -489,12 +493,16 @@ xfs_attrmulti_attr_remove(
>  	uint32_t		flags)
>  {
>  	int			error;
> -	size_t			namelen;
> +	struct xfs_name		xname = {
> +		.name		= name,
> +		.len		= strlen(name),
> +		.type		= flags,
> +	};
>  
>  	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>  		return -EPERM;
> -	namelen = strlen(name);
> -	error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
> +
> +	error = xfs_attr_remove(XFS_I(inode), &xname);
>  	if (!error)
>  		xfs_forget_acl(inode, name, flags);
>  	return error;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 92de0a7..469e8e2 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -49,10 +49,14 @@ xfs_initxattrs(
>  	int			error = 0;
>  
>  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> -		error = xfs_attr_set(ip, xattr->name,
> -				     strlen(xattr->name),
> -				     xattr->value, xattr->value_len,
> -				     ATTR_SECURE);
> +		struct xfs_name	name = {
> +			.name	= xattr->name,
> +			.len	= strlen(xattr->name),
> +			.type	= ATTR_SECURE,
> +		};
> +
> +		error = xfs_attr_set(ip, &name,
> +				     xattr->value, xattr->value_len);
>  		if (error < 0)
>  			break;
>  	}
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 59ffe6c..6309da4 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -20,19 +20,21 @@ static int
>  xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>  		struct inode *inode, const char *name, void *value, size_t size)
>  {
> -	int xflags = handler->flags;
>  	struct xfs_inode *ip = XFS_I(inode);
>  	int error, asize = size;
> -	size_t namelen = strlen(name);
> +	struct xfs_name xname = {
> +		.name	= name,
> +		.len	= strlen(name),
> +		.type	= handler->flags
> +	};
>  
>  	/* Convert Linux syscall to XFS internal ATTR flags */
>  	if (!size) {
> -		xflags |= ATTR_KERNOVAL;
> +		xname.type |= ATTR_KERNOVAL;
>  		value = NULL;
>  	}
>  
> -	error = xfs_attr_get(ip, name, namelen, (unsigned char **)&value,
> -			     &asize, xflags);
> +	error = xfs_attr_get(ip, &xname, (unsigned char **)&value, &asize);
>  	if (error)
>  		return error;
>  	return asize;
> @@ -65,23 +67,25 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  		struct inode *inode, const char *name, const void *value,
>  		size_t size, int flags)
>  {
> -	int			xflags = handler->flags;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error;
> -	size_t			namelen = strlen(name);
> +	struct xfs_name		xname = {
> +		.name		= name,
> +		.len		= strlen(name),
> +		.type		= handler->flags,
> +	};
>  
>  	/* Convert Linux syscall to XFS internal ATTR flags */
>  	if (flags & XATTR_CREATE)
> -		xflags |= ATTR_CREATE;
> +		xname.type |= ATTR_CREATE;
>  	if (flags & XATTR_REPLACE)
> -		xflags |= ATTR_REPLACE;
> +		xname.type |= ATTR_REPLACE;
>  
>  	if (!value)
> -		return xfs_attr_remove(ip, name,
> -				       namelen, xflags);
> -	error = xfs_attr_set(ip, name, namelen, (void *)value, size, xflags);
> +		return xfs_attr_remove(ip, &xname);
> +	error = xfs_attr_set(ip, &xname, (void *)value, size);
>  	if (!error)
> -		xfs_forget_acl(inode, name, xflags);
> +		xfs_forget_acl(inode, name, xname.type);
>  
>  	return error;
>  }
> -- 
> 2.7.4
> 

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Feb 2008 19:25:41 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m183PSE9025587
	for <xfs@oss.sgi.com>; Thu, 7 Feb 2008 19:25:32 -0800
Message-ID: <47ABCBB3.3010506@sgi.com>
Date: Fri, 08 Feb 2008 14:25:39 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] use generic ACL code
References: <20080207083222.GA14317@lst.de>
In-Reply-To: <20080207083222.GA14317@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com, a.gruenbacher@computer.org

Hi Christoph,

Yeah, I've recently taken your old patch and applied it to TOT dev
yesterday (as my old patch of it stopped applying after more recent
changes of yours went in).
I'm running thru qa (051 passes as you said) and was just going to do
053 and see where the problems are.

I did have a few questions from before but I need to relook at them
to see if they make sense now.
One of the comments I noticed recently was about extending the limit
of ACEs with this change instead of having the fixed array.

More soon.

--Tim

Christoph Hellwig wrote:
> This patch rips out the XFS ACL handling code and uses the generic
> fs/posix_acl.c code instead.  The ondisk format is of course left
> unchanged.
> 
> This also introduces the same ACL caching all other Linux filesystems do
> by adding pointers to the acl and default acl in struct xfs_inode.
> It'll probably need some benchmarking to find out whether bloating the
> inode is worth it.  It should be possible to use the generic code
> without this caching by revamping the code a little, although no other
> filesystem currently does that.
> 
> This patch is only an RFC because it still introduces a regression in
> XFSQA test 053, but I really want to get it out now to get more comments
> or even someone having a look at it because I'm running a little out of
> time currently.
> 
> Note that this patch applies ontop of the various vnode cleanups I've
> posted to the XFS list a few weeks ago that haven't been applied yet.
> 
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_acl.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_acl.c	2008-02-07 09:15:35.000000000 +0100
> @@ -0,0 +1,453 @@
> +/*
> + * Copyright (C) 2007 Christoph Hellwig.
> + *	Released under GPL v2.
> + */
> +#include "xfs.h"
> +#include "xfs_acl.h"
> +#include "xfs_attr.h"
> +#include "xfs_bmap_btree.h"	/* required by xfs_inode.h */
> +#include "xfs_inode.h"
> +#include "xfs_vnodeops.h"
> +
> +#include <linux/posix_acl_xattr.h>
> +
> +
> +#define XFS_ACL_NOT_CACHED	((void *)-1)
> +
> +/*
> + * Convert from extended attribute to in-memory representation.
> + */
> +static struct posix_acl *xfs_acl_from_disk(struct xfs_acl *aclp)
> +{
> +	struct posix_acl_entry *acl_e;
> +	struct posix_acl *acl;
> +	struct xfs_acl_entry *ace;
> +	int count, i;
> +
> +	count = be32_to_cpu(aclp->acl_cnt);
> +
> +	acl = posix_acl_alloc(count, GFP_KERNEL);
> +	if (!acl)
> +		return ERR_PTR(-ENOMEM);
> +
> +	for (i = 0; i < count; i++) {
> +		acl_e = &acl->a_entries[i];
> +		ace = &aclp->acl_entry[i];
> +
> +		/*
> +		 * XXX(hch): the tag is 32 bits on disk and 16 bits in core.
> +		 *		Any special handling required??
> +		 */
> +		acl_e->e_tag = be32_to_cpu(ace->ae_tag);
> +		acl_e->e_perm = be16_to_cpu(ace->ae_perm);
> +
> +		switch(acl_e->e_tag) {
> +		case ACL_USER:
> +		case ACL_GROUP:
> +			acl_e->e_id = be32_to_cpu(ace->ae_id);
> +			break;
> +		case ACL_USER_OBJ:
> +		case ACL_GROUP_OBJ:
> +		case ACL_MASK:
> +		case ACL_OTHER:
> +			acl_e->e_id = ACL_UNDEFINED_ID;
> +			break;
> +		default:
> +			goto fail;
> +		}
> +	}
> +	return acl;
> +
> +fail:
> +	posix_acl_release(acl);
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +/*
> + * Convert from in-memory to extended attribute representation.
> + */
> +static void xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
> +{
> +	const struct posix_acl_entry *acl_e;
> +	struct xfs_acl_entry *ace;
> +	int i;
> +
> +	for (i = 0; i < acl->a_count; i++) {
> +		ace = &aclp->acl_entry[i];
> +		acl_e = &acl->a_entries[i];
> +
> +		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
> +		ace->ae_id = cpu_to_be32(acl_e->e_id);
> +		ace->ae_perm = cpu_to_be16(acl_e->e_perm);
> +	}
> +}
> +
> +struct posix_acl *xfs_get_acl(struct inode *inode, int type)
> +{
> +	struct xfs_inode *ip = XFS_I(inode);
> +	struct posix_acl *acl = NULL, **p_acl;
> +	struct xfs_acl *xfs_acl;
> +	int len = sizeof(struct xfs_acl);
> +	char *ea_name;
> +	int error;
> +
> +	switch (type) {
> +	case ACL_TYPE_ACCESS:
> +		ea_name = SGI_ACL_FILE;
> +		p_acl = &ip->i_acl;
> +		break;
> +	case ACL_TYPE_DEFAULT:
> +		ea_name = SGI_ACL_DEFAULT;
> +		p_acl = &ip->i_default_acl;
> +		break;
> +	default:
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	if (*p_acl != XFS_ACL_NOT_CACHED)
> +		return posix_acl_dup(*p_acl);
> +
> +	xfs_acl = kzalloc(sizeof(struct xfs_acl), GFP_KERNEL);
> +	if (!xfs_acl)
> +		return ERR_PTR(-ENOMEM);
> +
> +	error = -xfs_attr_get(ip, ea_name, (char *)xfs_acl,
> +				&len, ATTR_ROOT, sys_cred);
> +	if (!error) {
> +		acl = xfs_acl_from_disk(xfs_acl);
> +		if (!IS_ERR(acl))
> +			*p_acl = posix_acl_dup(acl);
> +	} else {
> +		*p_acl = NULL;
> +	}
> +
> +	kfree(xfs_acl);
> +	return acl;
> +}
> +
> +static int xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
> +{
> +	struct xfs_inode *ip = XFS_I(inode);
> +	struct posix_acl **p_acl;
> +	char *ea_name;
> +	int error;
> +
> +	if (S_ISLNK(inode->i_mode))
> +		return -EOPNOTSUPP;
> +
> +	switch (type) {
> +	case ACL_TYPE_ACCESS:
> +		ea_name = SGI_ACL_FILE;
> +		p_acl = &ip->i_acl;
> +		break;
> +	case ACL_TYPE_DEFAULT:
> +		ea_name = SGI_ACL_DEFAULT;
> +		p_acl = &ip->i_default_acl;
> +		if (!S_ISDIR(inode->i_mode))
> +			return acl ? -EACCES : 0;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (acl) {
> +		struct xfs_acl *xfs_acl;
> +		int len;
> +
> +		xfs_acl = kzalloc(sizeof(struct xfs_acl), GFP_KERNEL);
> +		if (!xfs_acl)
> +			return -ENOMEM;
> +
> +		xfs_acl_to_disk(xfs_acl, acl);
> +		len = sizeof(struct xfs_acl) -
> +			(sizeof(struct xfs_acl_entry) *
> +			 (XFS_ACL_MAX_ENTRIES - acl->a_count));
> +
> +		error = -xfs_attr_set(ip, ea_name, (char *)xfs_acl,
> +				len, ATTR_ROOT);
> +
> +		kfree(xfs_acl);
> +	} else {
> +		error = -xfs_attr_remove(ip, ea_name, ATTR_ROOT);
> +		/*
> +		 * If the attribute didn't exist to start with that's fine.
> +		 */
> +		if (error == -ENOATTR)
> +			error = 0;
> +	}
> +
> +	if (!error) {
> +		if (*p_acl && *p_acl != XFS_ACL_NOT_CACHED)
> +			posix_acl_release(*p_acl);
> +		*p_acl = posix_acl_dup(acl);
> +	}
> +	return error;
> +}
> +
> +static int xfs_check_acl(struct inode *inode, int mask)
> +{
> +	struct xfs_inode *ip = XFS_I(inode);
> +
> +	xfs_itrace_entry(ip);
> +
> +	if (!XFS_IFORK_Q(ip))
> +		return -EAGAIN;
> +
> +	if (ip->i_acl == XFS_ACL_NOT_CACHED) {
> +		struct posix_acl *acl = xfs_get_acl(inode, ACL_TYPE_ACCESS);
> +		if (IS_ERR(acl))
> +			return PTR_ERR(acl);
> +		posix_acl_release(acl);
> +	}
> +
> +	if (ip->i_acl)
> +		return posix_acl_permission(inode, ip->i_acl, mask);
> +	return -EAGAIN;
> +}
> +
> +int xfs_vn_permission(struct inode *inode, int mask, struct nameidata *nd)
> +{
> +	return generic_permission(inode, mask, xfs_check_acl);
> +}
> +
> +/*
> + * Extended attribute handlers
> + */
> +static int xfs_xattr_get_acl(struct inode *inode, int type,
> +		void *buffer, size_t size)
> +{
> +	struct posix_acl *acl;
> +	int error;
> +
> +	acl = xfs_get_acl(inode, type);
> +	if (IS_ERR(acl))
> +		return PTR_ERR(acl);
> +	if (acl == NULL)
> +		return -ENODATA;
> +	error = posix_acl_to_xattr(acl, buffer, size);
> +	posix_acl_release(acl);
> +
> +	return error;
> +}
> +
> +/*
> + * Helper to propagate i_mode the xfs_inode.
> + */
> +static int xfs_set_mode(struct inode *inode, mode_t mode)
> +{
> +	int error = 0;
> +
> +	if (mode != inode->i_mode) {
> +		struct bhv_vattr va = {
> +			.va_mask	= XFS_AT_MODE,
> +			.va_mode	= mode,
> +		};
> +
> +		va.va_mask = XFS_AT_MODE;
> +		va.va_mode = mode;
> +
> +		error = -xfs_setattr(XFS_I(inode), &va, 0, sys_cred);
> +		inode->i_mode = mode;
> +	}
> +
> +	return error;
> +}
> +
> +static int xfs_xattr_set_acl(struct inode *inode, int type,
> +		const void *value, size_t size)
> +{
> +	struct posix_acl *acl;
> +	int error;
> +
> +	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		return -EPERM;
> +
> +	if (value) {
> +		acl = posix_acl_from_xattr(value, size);
> +		if (IS_ERR(acl))
> +			return PTR_ERR(acl);
> +		else if (acl) {
> +			error = posix_acl_valid(acl);
> +			if (error)
> +				goto release_and_out;
> +			if (acl->a_count > XFS_ACL_MAX_ENTRIES) {
> +				error = -EINVAL;
> +				goto release_and_out;
> +			}
> +
> +			if (type == ACL_TYPE_ACCESS) {
> +				mode_t mode = inode->i_mode;
> +				error = posix_acl_equiv_mode(acl, &mode);
> +				if (error < 0)
> +					return error;
> +				if (error == 0) {
> +					posix_acl_release(acl);
> +					acl = NULL;
> +				}
> +				error = xfs_set_mode(inode, mode);
> +				if (error)
> +					goto release_and_out;
> +			}
> +		}
> +	} else
> +		acl = NULL;
> +
> +	error = xfs_set_acl(inode, type, acl);
> +release_and_out:
> +	posix_acl_release(acl);
> +	return error;
> +}
> +
> +static int xfs_acl_exists(struct inode *inode, char *name)
> +{
> +	int len = sizeof(struct xfs_acl);
> +
> +	return xfs_attr_get(XFS_I(inode), name, NULL, &len,
> +			    ATTR_ROOT|ATTR_KERNOVAL, sys_cred);
> +}
> +
> +static int posix_acl_access_get(struct inode *inode, char *name, void *data,
> +		size_t size, int xflags)
> +{
> +	return xfs_xattr_get_acl(inode, ACL_TYPE_ACCESS, data, size);
> +}
> +
> +static int posix_acl_access_set(struct inode *inode, char *name, void *data,
> +		size_t size, int xflags)
> +{
> +	return xfs_xattr_set_acl(inode, ACL_TYPE_ACCESS, data, size);
> +}
> +
> +static int posix_acl_access_remove(struct inode *inode, char *name, int xflags)
> +{
> +	return xfs_xattr_set_acl(inode, ACL_TYPE_ACCESS, NULL, 0);
> +}
> +
> +static int posix_acl_access_exists(struct inode *inode)
> +{
> +	return xfs_acl_exists(inode, SGI_ACL_FILE);
> +}
> +
> +static int posix_acl_default_get(struct inode *inode, char *name, void *data,
> +		size_t size, int xflags)
> +{
> +	return xfs_xattr_get_acl(inode, ACL_TYPE_DEFAULT, data, size);
> +}
> +
> +static int posix_acl_default_set(struct inode *inode, char *name, void *data,
> +		size_t size, int xflags)
> +{
> +	if (!S_ISDIR(inode->i_mode))
> +		return data ? -EACCES : 0;
> +	return xfs_xattr_set_acl(inode, ACL_TYPE_DEFAULT, data, size);
> +}
> +
> +static int posix_acl_default_remove(struct inode *inode, char *name, int xflags)
> +{
> +	return xfs_xattr_set_acl(inode, ACL_TYPE_DEFAULT, NULL, 0);
> +}
> +
> +int posix_acl_default_exists(struct inode *inode)
> +{
> +	if (!S_ISDIR(inode->i_mode))
> +		return 0;
> +	return xfs_acl_exists(inode, SGI_ACL_DEFAULT);
> +}
> +
> +struct attrnames posix_acl_access = {
> +	.attr_name	= "posix_acl_access",
> +	.attr_namelen	= sizeof("posix_acl_access") - 1,
> +	.attr_get	= posix_acl_access_get,
> +	.attr_set	= posix_acl_access_set,
> +	.attr_remove	= posix_acl_access_remove,
> +	.attr_exists	= posix_acl_access_exists,
> +};
> +
> +struct attrnames posix_acl_default = {
> +	.attr_name	= "posix_acl_default",
> +	.attr_namelen	= sizeof("posix_acl_default") - 1,
> +	.attr_get	= posix_acl_default_get,
> +	.attr_set	= posix_acl_default_set,
> +	.attr_remove	= posix_acl_default_remove,
> +	.attr_exists	= posix_acl_default_exists,
> +};
> +
> +/*
> + * Unlike the other functions in this file this returns positive errors.
> + */
> +int xfs_inherit_acl(struct inode *inode, struct posix_acl *default_acl)
> +{
> +	struct xfs_inode *ip = XFS_I(inode);
> +	struct posix_acl *clone;
> +	mode_t mode;
> +	int error = 0;
> +
> +	if (S_ISDIR(inode->i_mode)) {
> +		error = xfs_set_acl(inode, ACL_TYPE_DEFAULT, default_acl);
> +		if (error)
> +			return -error;
> +	}
> +
> +	clone = posix_acl_clone(default_acl, GFP_KERNEL);
> +	if (!clone)
> +		return ENOMEM;
> +
> +	mode = inode->i_mode;
> +	error = posix_acl_create_masq(clone, &mode);
> +	if (error < 0)
> +		goto out_release_clone;
> +
> +	error = xfs_set_mode(inode, mode);
> +	if (error > 0)
> +		error = xfs_set_acl(inode, ACL_TYPE_ACCESS, clone);
> +	xfs_iflags_set(ip, XFS_IMODIFIED);
> +
> + out_release_clone:
> +	posix_acl_release(clone);
> +	return -error;
> +}
> +
> +int xfs_acl_chmod(struct inode *inode)
> +{
> +	struct posix_acl *acl, *clone;
> +	int error;
> +
> +	if (S_ISLNK(inode->i_mode))
> +		return -EOPNOTSUPP;
> +
> +	acl = xfs_get_acl(inode, ACL_TYPE_ACCESS);
> +	if (IS_ERR(acl) || !acl)
> +		return PTR_ERR(acl);
> +
> +	clone = posix_acl_clone(acl, GFP_KERNEL);
> +	posix_acl_release(acl);
> +	if (!clone)
> +		return -ENOMEM;
> +
> +	error = posix_acl_chmod_masq(clone, inode->i_mode);
> +	if (!error)
> +		error = xfs_set_acl(inode, ACL_TYPE_ACCESS, clone);
> +
> +	posix_acl_release(clone);
> +	return error;
> +}
> +
> +void xfs_inode_init_acls(struct xfs_inode *ip)
> +{
> +	ip->i_acl = XFS_ACL_NOT_CACHED;
> +	ip->i_default_acl = XFS_ACL_NOT_CACHED;
> +}
> +
> +static void xfs_clear_acl(struct posix_acl **aclp)
> +{
> +	if (*aclp != XFS_ACL_NOT_CACHED) {
> +		posix_acl_release(*aclp);
> +		*aclp = XFS_ACL_NOT_CACHED;
> +	}
> +}
> +
> +void xfs_inode_clear_acls(struct xfs_inode *ip)
> +{
> +	xfs_clear_acl(&ip->i_acl);
> +	xfs_clear_acl(&ip->i_default_acl);
> +}
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-02-05 08:43:31.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-02-07 09:17:11.000000000 +0100
> @@ -51,6 +51,7 @@
>  #include <linux/capability.h>
>  #include <linux/xattr.h>
>  #include <linux/namei.h>
> +#include <linux/posix_acl.h>
>  #include <linux/security.h>
>  #include <linux/falloc.h>
>  
> @@ -272,8 +273,7 @@ xfs_vn_mknod(
>  {
>  	struct inode	*inode;
>  	struct xfs_inode *ip = NULL;
> -	xfs_acl_t	*default_acl = NULL;
> -	attrexists_t	test_default_acl = _ACL_DEFAULT_EXISTS;
> +	struct posix_acl *default_acl = NULL;
>  	int		error;
>  
>  	/*
> @@ -283,18 +283,14 @@ xfs_vn_mknod(
>  	if (unlikely(!sysv_valid_dev(rdev) || MAJOR(rdev) & ~0x1ff))
>  		return -EINVAL;
>  
> -	if (test_default_acl && test_default_acl(dir)) {
> -		if (!_ACL_ALLOC(default_acl)) {
> -			return -ENOMEM;
> -		}
> -		if (!_ACL_GET_DEFAULT(dir, default_acl)) {
> -			_ACL_FREE(default_acl);
> -			default_acl = NULL;
> -		}
> -	}
> +	if (IS_POSIXACL(dir)) {
> +		default_acl = xfs_get_acl(dir, ACL_TYPE_DEFAULT);
> +		if (IS_ERR(default_acl))
> +			return -PTR_ERR(default_acl);
>  
> -	if (IS_POSIXACL(dir) && !default_acl)
> -		mode &= ~current->fs->umask;
> +		if (!default_acl)
> +			mode &= ~current->fs->umask;
> +	}
>  
>  	switch (mode & S_IFMT) {
>  	case S_IFCHR:
> @@ -323,11 +319,11 @@ xfs_vn_mknod(
>  		goto out_cleanup_inode;
>  
>  	if (default_acl) {
> -		error = _ACL_INHERIT(inode, mode, default_acl);
> +		error = xfs_inherit_acl(inode, default_acl);
>  		if (unlikely(error))
>  			goto out_cleanup_inode;
>  		xfs_iflags_set(ip, XFS_IMODIFIED);
> -		_ACL_FREE(default_acl);
> +		posix_acl_release(default_acl);
>  	}
>  
>  
> @@ -340,8 +336,7 @@ xfs_vn_mknod(
>   out_cleanup_inode:
>  	xfs_cleanup_inode(dir, inode, dentry, mode);
>   out_free_acl:
> -	if (default_acl)
> -		_ACL_FREE(default_acl);
> +	posix_acl_release(default_acl);
>  	return -error;
>  }
>  
> @@ -545,38 +540,6 @@ xfs_vn_put_link(
>  		kfree(s);
>  }
>  
> -#ifdef CONFIG_XFS_POSIX_ACL
> -STATIC int
> -xfs_check_acl(
> -	struct inode		*inode,
> -	int			mask)
> -{
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	int			error;
> -
> -	xfs_itrace_entry(ip);
> -
> -	if (XFS_IFORK_Q(ip)) {
> -		error = xfs_acl_iaccess(ip, mask, NULL);
> -		if (error != -1)
> -			return -error;
> -	}
> -
> -	return -EAGAIN;
> -}
> -
> -STATIC int
> -xfs_vn_permission(
> -	struct inode		*inode,
> -	int			mask,
> -	struct nameidata	*nd)
> -{
> -	return generic_permission(inode, mask, xfs_check_acl);
> -}
> -#else
> -#define xfs_vn_permission NULL
> -#endif
> -
>  STATIC int
>  xfs_vn_getattr(
>  	struct vfsmount		*mnt,
> @@ -689,6 +652,9 @@ xfs_vn_setattr(
>  	error = xfs_setattr(XFS_I(inode), &vattr, flags, NULL);
>  	if (likely(!error))
>  		vn_revalidate(vn_from_inode(inode));
> +
> +	if (!error && (attr->ia_valid & ATTR_MODE))
> +		error = -xfs_acl_chmod(inode);
>  	return -error;
>  }
>  
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.h	2008-02-05 08:43:31.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h	2008-02-07 09:15:35.000000000 +0100
> @@ -26,6 +26,12 @@ extern const struct file_operations xfs_
>  extern const struct file_operations xfs_dir_file_operations;
>  extern const struct file_operations xfs_invis_file_operations;
>  
> +#ifdef CONFIG_XFS_POSIX_ACL
> +int xfs_vn_permission(struct inode *inode, int mask, struct nameidata *nd);
> +#else
> +#define xfs_vn_permission NULL
> +#endif
> +
>  
>  struct xfs_inode;
>  extern void xfs_ichgtime(struct xfs_inode *, int);
> Index: linux-2.6-xfs/fs/xfs/xfs_acl.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_acl.h	2008-02-05 08:43:31.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_acl.h	2008-02-07 09:15:35.000000000 +0100
> @@ -18,27 +18,25 @@
>  #ifndef __XFS_ACL_H__
>  #define __XFS_ACL_H__
>  
> +struct inode;
> +struct posix_acl;
> +struct xfs_inode;
> +
> +
>  /*
>   * Access Control Lists
>   */
> -typedef __uint16_t	xfs_acl_perm_t;
> -typedef __int32_t	xfs_acl_type_t;
> -typedef __int32_t	xfs_acl_tag_t;
> -typedef __int32_t	xfs_acl_id_t;
> -
>  #define XFS_ACL_MAX_ENTRIES 25
>  #define XFS_ACL_NOT_PRESENT (-1)
>  
> -typedef struct xfs_acl_entry {
> -	xfs_acl_tag_t	ae_tag;
> -	xfs_acl_id_t	ae_id;
> -	xfs_acl_perm_t	ae_perm;
> -} xfs_acl_entry_t;
> -
> -typedef struct xfs_acl {
> -	__int32_t	acl_cnt;
> -	xfs_acl_entry_t	acl_entry[XFS_ACL_MAX_ENTRIES];
> -} xfs_acl_t;
> +struct xfs_acl {
> +	__be32		acl_cnt;
> +	struct xfs_acl_entry {
> +		__be32	ae_tag;
> +		__be32	ae_id;
> +		__be16	ae_perm;
> +	} acl_entry[XFS_ACL_MAX_ENTRIES];
> +};
>  
>  /* On-disk XFS extended attribute names */
>  #define SGI_ACL_FILE	"SGI_ACL_FILE"
> @@ -49,51 +47,31 @@ typedef struct xfs_acl {
>  
>  #ifdef CONFIG_XFS_POSIX_ACL
>  
> -struct vattr;
> -struct xfs_inode;
> -
> -extern struct kmem_zone *xfs_acl_zone;
> -#define xfs_acl_zone_init(zone, name)	\
> -		(zone) = kmem_zone_init(sizeof(xfs_acl_t), (name))
> -#define xfs_acl_zone_destroy(zone)	kmem_zone_destroy(zone)
> -
> -extern int xfs_acl_inherit(bhv_vnode_t *, mode_t mode, xfs_acl_t *);
> -extern int xfs_acl_iaccess(struct xfs_inode *, mode_t, cred_t *);
> -extern int xfs_acl_vtoacl(bhv_vnode_t *, xfs_acl_t *, xfs_acl_t *);
> -extern int xfs_acl_vhasacl_access(bhv_vnode_t *);
> -extern int xfs_acl_vhasacl_default(bhv_vnode_t *);
> -extern int xfs_acl_vset(bhv_vnode_t *, void *, size_t, int);
> -extern int xfs_acl_vget(bhv_vnode_t *, void *, size_t, int);
> -extern int xfs_acl_vremove(bhv_vnode_t *, int);
> -
> -#define _ACL_TYPE_ACCESS	1
> -#define _ACL_TYPE_DEFAULT	2
> -#define _ACL_PERM_INVALID(perm)	((perm) & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
> -
> -#define _ACL_INHERIT(c,m,d)	(xfs_acl_inherit(c,m,d))
> -#define _ACL_GET_ACCESS(pv,pa)	(xfs_acl_vtoacl(pv,pa,NULL) == 0)
> -#define _ACL_GET_DEFAULT(pv,pd)	(xfs_acl_vtoacl(pv,NULL,pd) == 0)
> -#define _ACL_ACCESS_EXISTS	xfs_acl_vhasacl_access
> -#define _ACL_DEFAULT_EXISTS	xfs_acl_vhasacl_default
> -
> -#define _ACL_ALLOC(a)		((a) = kmem_zone_alloc(xfs_acl_zone, KM_SLEEP))
> -#define _ACL_FREE(a)		((a)? kmem_zone_free(xfs_acl_zone, (a)):(void)0)
> +struct posix_acl *xfs_get_acl(struct inode *inode, int type);
> +int xfs_inherit_acl(struct inode *inode, struct posix_acl *default_acl);
> +int xfs_acl_chmod(struct inode *inode);
> +void xfs_inode_init_acls(struct xfs_inode *ip);
> +void xfs_inode_clear_acls(struct xfs_inode *ip);
>  
>  #else
> -#define xfs_acl_zone_init(zone,name)
> -#define xfs_acl_zone_destroy(zone)
> -#define xfs_acl_vset(v,p,sz,t)	(-EOPNOTSUPP)
> -#define xfs_acl_vget(v,p,sz,t)	(-EOPNOTSUPP)
> -#define xfs_acl_vremove(v,t)	(-EOPNOTSUPP)
> -#define xfs_acl_vhasacl_access(v)	(0)
> -#define xfs_acl_vhasacl_default(v)	(0)
> -#define _ACL_ALLOC(a)		(1)	/* successfully allocate nothing */
> -#define _ACL_FREE(a)		((void)0)
> -#define _ACL_INHERIT(c,m,d)	(0)
> -#define _ACL_GET_ACCESS(pv,pa)	(0)
> -#define _ACL_GET_DEFAULT(pv,pd)	(0)
> -#define _ACL_ACCESS_EXISTS	(NULL)
> -#define _ACL_DEFAULT_EXISTS	(NULL)
> -#endif
>  
> +static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
> +{
> +	BUG();
> +}
> +static inline int xfs_inherit_acl(struct inode *inode,
> +		struct posix_acl *default_acl)
> +{
> +	BUG();
> +}
> +
> +static inline void xfs_inode_init_acls(struct xfs_inode *ip)
> +{
> +}
> +
> +static inline void xfs_inode_clear_acls(struct xfs_inode *ip)
> +{
> +}
> +
> +#endif /* CONFIG_XFS_POSIX_ACL */
>  #endif	/* __XFS_ACL_H__ */
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-02-05 08:43:31.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-02-07 09:15:35.000000000 +0100
> @@ -52,7 +52,6 @@
>  #include "xfs_dir2_block.h"
>  #include "xfs_dir2_node.h"
>  #include "xfs_dir2_trace.h"
> -#include "xfs_acl.h"
>  #include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_inode_item.h"
> @@ -183,10 +182,6 @@ EXPORT_SYMBOL(uuid_table_remove);
>  EXPORT_SYMBOL(vn_hold);
>  EXPORT_SYMBOL(vn_revalidate);
>  
> -#if defined(CONFIG_XFS_POSIX_ACL)
> -EXPORT_SYMBOL(xfs_acl_vtoacl);
> -EXPORT_SYMBOL(xfs_acl_inherit);
> -#endif
>  EXPORT_SYMBOL(xfs_alloc_buftarg);
>  EXPORT_SYMBOL(xfs_flush_buftarg);
>  EXPORT_SYMBOL(xfs_free_buftarg);
> Index: linux-2.6-xfs/fs/xfs/xfs_attr.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_attr.c	2008-02-05 08:43:31.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_attr.c	2008-02-07 09:15:35.000000000 +0100
> @@ -58,8 +58,6 @@
>   */
>  
>  #define ATTR_SYSCOUNT	2
> -static struct attrnames posix_acl_access;
> -static struct attrnames posix_acl_default;
>  static struct attrnames *attr_system_names[ATTR_SYSCOUNT];
>  
>  /*========================================================================
> @@ -2427,80 +2425,6 @@ xfs_attr_trace_enter(int type, char *whe
>   * System (pseudo) namespace attribute interface routines.
>   *========================================================================*/
>  
> -STATIC int
> -posix_acl_access_set(
> -	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
> -{
> -	return xfs_acl_vset(vp, data, size, _ACL_TYPE_ACCESS);
> -}
> -
> -STATIC int
> -posix_acl_access_remove(
> -	bhv_vnode_t *vp, char *name, int xflags)
> -{
> -	return xfs_acl_vremove(vp, _ACL_TYPE_ACCESS);
> -}
> -
> -STATIC int
> -posix_acl_access_get(
> -	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
> -{
> -	return xfs_acl_vget(vp, data, size, _ACL_TYPE_ACCESS);
> -}
> -
> -STATIC int
> -posix_acl_access_exists(
> -	bhv_vnode_t *vp)
> -{
> -	return xfs_acl_vhasacl_access(vp);
> -}
> -
> -STATIC int
> -posix_acl_default_set(
> -	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
> -{
> -	return xfs_acl_vset(vp, data, size, _ACL_TYPE_DEFAULT);
> -}
> -
> -STATIC int
> -posix_acl_default_get(
> -	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
> -{
> -	return xfs_acl_vget(vp, data, size, _ACL_TYPE_DEFAULT);
> -}
> -
> -STATIC int
> -posix_acl_default_remove(
> -	bhv_vnode_t *vp, char *name, int xflags)
> -{
> -	return xfs_acl_vremove(vp, _ACL_TYPE_DEFAULT);
> -}
> -
> -STATIC int
> -posix_acl_default_exists(
> -	bhv_vnode_t *vp)
> -{
> -	return xfs_acl_vhasacl_default(vp);
> -}
> -
> -static struct attrnames posix_acl_access = {
> -	.attr_name	= "posix_acl_access",
> -	.attr_namelen	= sizeof("posix_acl_access") - 1,
> -	.attr_get	= posix_acl_access_get,
> -	.attr_set	= posix_acl_access_set,
> -	.attr_remove	= posix_acl_access_remove,
> -	.attr_exists	= posix_acl_access_exists,
> -};
> -
> -static struct attrnames posix_acl_default = {
> -	.attr_name	= "posix_acl_default",
> -	.attr_namelen	= sizeof("posix_acl_default") - 1,
> -	.attr_get	= posix_acl_default_get,
> -	.attr_set	= posix_acl_default_set,
> -	.attr_remove	= posix_acl_default_remove,
> -	.attr_exists	= posix_acl_default_exists,
> -};
> -
>  static struct attrnames *attr_system_names[] =
>  	{ &posix_acl_access, &posix_acl_default };
>  
> Index: linux-2.6-xfs/fs/xfs/xfs_attr.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_attr.h	2008-02-05 08:43:31.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_attr.h	2008-02-07 09:15:35.000000000 +0100
> @@ -61,6 +61,8 @@ extern struct attrnames attr_secure;
>  extern struct attrnames attr_system;
>  extern struct attrnames attr_trusted;
>  extern struct attrnames *attr_namespaces[ATTR_NAMECOUNT];
> +extern struct attrnames posix_acl_access;
> +extern struct attrnames posix_acl_default;
>  
>  extern attrnames_t *attr_lookup_namespace(char *, attrnames_t **, int);
>  extern int attr_generic_list(bhv_vnode_t *, void *, size_t, int, ssize_t *);
> Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2008-02-05 08:43:31.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2008-02-07 09:15:35.000000000 +0100
> @@ -78,7 +78,6 @@ xfs_init(void)
>  		kmem_zone_init(sizeof(xfs_da_state_t), "xfs_da_state");
>  	xfs_dabuf_zone = kmem_zone_init(sizeof(xfs_dabuf_t), "xfs_dabuf");
>  	xfs_ifork_zone = kmem_zone_init(sizeof(xfs_ifork_t), "xfs_ifork");
> -	xfs_acl_zone_init(xfs_acl_zone, "xfs_acl");
>  	xfs_mru_cache_init();
>  	xfs_filestream_init();
>  
> @@ -160,7 +159,6 @@ xfs_cleanup(void)
>  	xfs_refcache_destroy();
>  	xfs_filestream_uninit();
>  	xfs_mru_cache_uninit();
> -	xfs_acl_zone_destroy(xfs_acl_zone);
>  
>  #ifdef XFS_DIR2_TRACE
>  	ktrace_free(xfs_dir2_trace_buf);
> Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2008-02-05 08:43:31.000000000 +0100
> +++ /dev/null	1970-01-01 00:00:00.000000000 +0000
> @@ -1,903 +0,0 @@
> -/*
> - * Copyright (c) 2001-2002,2005 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -#include "xfs.h"
> -#include "xfs_fs.h"
> -#include "xfs_types.h"
> -#include "xfs_bit.h"
> -#include "xfs_inum.h"
> -#include "xfs_ag.h"
> -#include "xfs_dir2.h"
> -#include "xfs_bmap_btree.h"
> -#include "xfs_alloc_btree.h"
> -#include "xfs_ialloc_btree.h"
> -#include "xfs_dir2_sf.h"
> -#include "xfs_attr_sf.h"
> -#include "xfs_dinode.h"
> -#include "xfs_inode.h"
> -#include "xfs_btree.h"
> -#include "xfs_acl.h"
> -#include "xfs_attr.h"
> -#include "xfs_vnodeops.h"
> -
> -#include <linux/capability.h>
> -#include <linux/posix_acl_xattr.h>
> -
> -STATIC int	xfs_acl_setmode(bhv_vnode_t *, xfs_acl_t *, int *);
> -STATIC void     xfs_acl_filter_mode(mode_t, xfs_acl_t *);
> -STATIC void	xfs_acl_get_endian(xfs_acl_t *);
> -STATIC int	xfs_acl_access(uid_t, gid_t, xfs_acl_t *, mode_t, cred_t *);
> -STATIC int	xfs_acl_invalid(xfs_acl_t *);
> -STATIC void	xfs_acl_sync_mode(mode_t, xfs_acl_t *);
> -STATIC void	xfs_acl_get_attr(bhv_vnode_t *, xfs_acl_t *, int, int, int *);
> -STATIC void	xfs_acl_set_attr(bhv_vnode_t *, xfs_acl_t *, int, int *);
> -STATIC int	xfs_acl_allow_set(bhv_vnode_t *, int);
> -
> -kmem_zone_t *xfs_acl_zone;
> -
> -
> -/*
> - * Test for existence of access ACL attribute as efficiently as possible.
> - */
> -int
> -xfs_acl_vhasacl_access(
> -	bhv_vnode_t	*vp)
> -{
> -	int		error;
> -
> -	xfs_acl_get_attr(vp, NULL, _ACL_TYPE_ACCESS, ATTR_KERNOVAL, &error);
> -	return (error == 0);
> -}
> -
> -/*
> - * Test for existence of default ACL attribute as efficiently as possible.
> - */
> -int
> -xfs_acl_vhasacl_default(
> -	bhv_vnode_t	*vp)
> -{
> -	int		error;
> -
> -	if (!VN_ISDIR(vp))
> -		return 0;
> -	xfs_acl_get_attr(vp, NULL, _ACL_TYPE_DEFAULT, ATTR_KERNOVAL, &error);
> -	return (error == 0);
> -}
> -
> -/*
> - * Convert from extended attribute representation to in-memory for XFS.
> - */
> -STATIC int
> -posix_acl_xattr_to_xfs(
> -	posix_acl_xattr_header	*src,
> -	size_t			size,
> -	xfs_acl_t		*dest)
> -{
> -	posix_acl_xattr_entry	*src_entry;
> -	xfs_acl_entry_t		*dest_entry;
> -	int			n;
> -
> -	if (!src || !dest)
> -		return EINVAL;
> -
> -	if (size < sizeof(posix_acl_xattr_header))
> -		return EINVAL;
> -
> -	if (src->a_version != cpu_to_le32(POSIX_ACL_XATTR_VERSION))
> -		return EOPNOTSUPP;
> -
> -	memset(dest, 0, sizeof(xfs_acl_t));
> -	dest->acl_cnt = posix_acl_xattr_count(size);
> -	if (dest->acl_cnt < 0 || dest->acl_cnt > XFS_ACL_MAX_ENTRIES)
> -		return EINVAL;
> -
> -	/*
> -	 * acl_set_file(3) may request that we set default ACLs with
> -	 * zero length -- defend (gracefully) against that here.
> -	 */
> -	if (!dest->acl_cnt)
> -		return 0;
> -
> -	src_entry = (posix_acl_xattr_entry *)((char *)src + sizeof(*src));
> -	dest_entry = &dest->acl_entry[0];
> -
> -	for (n = 0; n < dest->acl_cnt; n++, src_entry++, dest_entry++) {
> -		dest_entry->ae_perm = le16_to_cpu(src_entry->e_perm);
> -		if (_ACL_PERM_INVALID(dest_entry->ae_perm))
> -			return EINVAL;
> -		dest_entry->ae_tag  = le16_to_cpu(src_entry->e_tag);
> -		switch(dest_entry->ae_tag) {
> -		case ACL_USER:
> -		case ACL_GROUP:
> -			dest_entry->ae_id = le32_to_cpu(src_entry->e_id);
> -			break;
> -		case ACL_USER_OBJ:
> -		case ACL_GROUP_OBJ:
> -		case ACL_MASK:
> -		case ACL_OTHER:
> -			dest_entry->ae_id = ACL_UNDEFINED_ID;
> -			break;
> -		default:
> -			return EINVAL;
> -		}
> -	}
> -	if (xfs_acl_invalid(dest))
> -		return EINVAL;
> -
> -	return 0;
> -}
> -
> -/*
> - * Comparison function called from xfs_sort().
> - * Primary key is ae_tag, secondary key is ae_id.
> - */
> -STATIC int
> -xfs_acl_entry_compare(
> -	const void	*va,
> -	const void	*vb)
> -{
> -	xfs_acl_entry_t	*a = (xfs_acl_entry_t *)va,
> -			*b = (xfs_acl_entry_t *)vb;
> -
> -	if (a->ae_tag == b->ae_tag)
> -		return (a->ae_id - b->ae_id);
> -	return (a->ae_tag - b->ae_tag);
> -}
> -
> -/*
> - * Convert from in-memory XFS to extended attribute representation.
> - */
> -STATIC int
> -posix_acl_xfs_to_xattr(
> -	xfs_acl_t		*src,
> -	posix_acl_xattr_header	*dest,
> -	size_t			size)
> -{
> -	int			n;
> -	size_t			new_size = posix_acl_xattr_size(src->acl_cnt);
> -	posix_acl_xattr_entry	*dest_entry;
> -	xfs_acl_entry_t		*src_entry;
> -
> -	if (size < new_size)
> -		return -ERANGE;
> -
> -	/* Need to sort src XFS ACL by <ae_tag,ae_id> */
> -	xfs_sort(src->acl_entry, src->acl_cnt, sizeof(src->acl_entry[0]),
> -		 xfs_acl_entry_compare);
> -
> -	dest->a_version = cpu_to_le32(POSIX_ACL_XATTR_VERSION);
> -	dest_entry = &dest->a_entries[0];
> -	src_entry = &src->acl_entry[0];
> -	for (n = 0; n < src->acl_cnt; n++, dest_entry++, src_entry++) {
> -		dest_entry->e_perm = cpu_to_le16(src_entry->ae_perm);
> -		if (_ACL_PERM_INVALID(src_entry->ae_perm))
> -			return -EINVAL;
> -		dest_entry->e_tag  = cpu_to_le16(src_entry->ae_tag);
> -		switch (src_entry->ae_tag) {
> -		case ACL_USER:
> -		case ACL_GROUP:
> -			dest_entry->e_id = cpu_to_le32(src_entry->ae_id);
> -				break;
> -		case ACL_USER_OBJ:
> -		case ACL_GROUP_OBJ:
> -		case ACL_MASK:
> -		case ACL_OTHER:
> -			dest_entry->e_id = cpu_to_le32(ACL_UNDEFINED_ID);
> -			break;
> -		default:
> -			return -EINVAL;
> -		}
> -	}
> -	return new_size;
> -}
> -
> -int
> -xfs_acl_vget(
> -	bhv_vnode_t	*vp,
> -	void		*acl,
> -	size_t		size,
> -	int		kind)
> -{
> -	int			error;
> -	xfs_acl_t		*xfs_acl = NULL;
> -	posix_acl_xattr_header	*ext_acl = acl;
> -	int			flags = 0;
> -
> -	VN_HOLD(vp);
> -	if(size) {
> -		if (!(_ACL_ALLOC(xfs_acl))) {
> -			error = ENOMEM;
> -			goto out;
> -		}
> -		memset(xfs_acl, 0, sizeof(xfs_acl_t));
> -	} else
> -		flags = ATTR_KERNOVAL;
> -
> -	xfs_acl_get_attr(vp, xfs_acl, kind, flags, &error);
> -	if (error)
> -		goto out;
> -
> -	if (!size) {
> -		error = -posix_acl_xattr_size(XFS_ACL_MAX_ENTRIES);
> -	} else {
> -		if (xfs_acl_invalid(xfs_acl)) {
> -			error = EINVAL;
> -			goto out;
> -		}
> -		if (kind == _ACL_TYPE_ACCESS) {
> -			bhv_vattr_t	va;
> -
> -			va.va_mask = XFS_AT_MODE;
> -			error = xfs_getattr(xfs_vtoi(vp), &va, 0);
> -			if (error)
> -				goto out;
> -			xfs_acl_sync_mode(va.va_mode, xfs_acl);
> -		}
> -		error = -posix_acl_xfs_to_xattr(xfs_acl, ext_acl, size);
> -	}
> -out:
> -	VN_RELE(vp);
> -	if(xfs_acl)
> -		_ACL_FREE(xfs_acl);
> -	return -error;
> -}
> -
> -int
> -xfs_acl_vremove(
> -	bhv_vnode_t	*vp,
> -	int		kind)
> -{
> -	int		error;
> -
> -	VN_HOLD(vp);
> -	error = xfs_acl_allow_set(vp, kind);
> -	if (!error) {
> -		error = xfs_attr_remove(xfs_vtoi(vp),
> -						kind == _ACL_TYPE_DEFAULT?
> -						SGI_ACL_DEFAULT: SGI_ACL_FILE,
> -						ATTR_ROOT);
> -		if (error == ENOATTR)
> -			error = 0;	/* 'scool */
> -	}
> -	VN_RELE(vp);
> -	return -error;
> -}
> -
> -int
> -xfs_acl_vset(
> -	bhv_vnode_t		*vp,
> -	void			*acl,
> -	size_t			size,
> -	int			kind)
> -{
> -	posix_acl_xattr_header	*ext_acl = acl;
> -	xfs_acl_t		*xfs_acl;
> -	int			error;
> -	int			basicperms = 0; /* more than std unix perms? */
> -
> -	if (!acl)
> -		return -EINVAL;
> -
> -	if (!(_ACL_ALLOC(xfs_acl)))
> -		return -ENOMEM;
> -
> -	error = posix_acl_xattr_to_xfs(ext_acl, size, xfs_acl);
> -	if (error) {
> -		_ACL_FREE(xfs_acl);
> -		return -error;
> -	}
> -	if (!xfs_acl->acl_cnt) {
> -		_ACL_FREE(xfs_acl);
> -		return 0;
> -	}
> -
> -	VN_HOLD(vp);
> -	error = xfs_acl_allow_set(vp, kind);
> -	if (error)
> -		goto out;
> -
> -	/* Incoming ACL exists, set file mode based on its value */
> -	if (kind == _ACL_TYPE_ACCESS)
> -		xfs_acl_setmode(vp, xfs_acl, &basicperms);
> -
> -	/*
> -	 * If we have more than std unix permissions, set up the actual attr.
> -	 * Otherwise, delete any existing attr.  This prevents us from
> -	 * having actual attrs for permissions that can be stored in the
> -	 * standard permission bits.
> -	 */
> -	if (!basicperms) {
> -		xfs_acl_set_attr(vp, xfs_acl, kind, &error);
> -	} else {
> -		xfs_acl_vremove(vp, _ACL_TYPE_ACCESS);
> -	}
> -
> -out:
> -	VN_RELE(vp);
> -	_ACL_FREE(xfs_acl);
> -	return -error;
> -}
> -
> -int
> -xfs_acl_iaccess(
> -	xfs_inode_t	*ip,
> -	mode_t		mode,
> -	cred_t		*cr)
> -{
> -	xfs_acl_t	*acl;
> -	int		rval;
> -
> -	if (!(_ACL_ALLOC(acl)))
> -		return -1;
> -
> -	/* If the file has no ACL return -1. */
> -	rval = sizeof(xfs_acl_t);
> -	if (xfs_attr_fetch(ip, SGI_ACL_FILE, SGI_ACL_FILE_SIZE,
> -			(char *)acl, &rval, ATTR_ROOT | ATTR_KERNACCESS, cr)) {
> -		_ACL_FREE(acl);
> -		return -1;
> -	}
> -	xfs_acl_get_endian(acl);
> -
> -	/* If the file has an empty ACL return -1. */
> -	if (acl->acl_cnt == XFS_ACL_NOT_PRESENT) {
> -		_ACL_FREE(acl);
> -		return -1;
> -	}
> -
> -	/* Synchronize ACL with mode bits */
> -	xfs_acl_sync_mode(ip->i_d.di_mode, acl);
> -
> -	rval = xfs_acl_access(ip->i_d.di_uid, ip->i_d.di_gid, acl, mode, cr);
> -	_ACL_FREE(acl);
> -	return rval;
> -}
> -
> -STATIC int
> -xfs_acl_allow_set(
> -	bhv_vnode_t	*vp,
> -	int		kind)
> -{
> -	xfs_inode_t	*ip = xfs_vtoi(vp);
> -	bhv_vattr_t	va;
> -	int		error;
> -
> -	if (vp->i_flags & (S_IMMUTABLE|S_APPEND))
> -		return EPERM;
> -	if (kind == _ACL_TYPE_DEFAULT && !VN_ISDIR(vp))
> -		return ENOTDIR;
> -	if (vp->i_sb->s_flags & MS_RDONLY)
> -		return EROFS;
> -	va.va_mask = XFS_AT_UID;
> -	error = xfs_getattr(ip, &va, 0);
> -	if (error)
> -		return error;
> -	if (va.va_uid != current->fsuid && !capable(CAP_FOWNER))
> -		return EPERM;
> -	return error;
> -}
> -
> -/*
> - * Note: cr is only used here for the capability check if the ACL test fails.
> - *       It is not used to find out the credentials uid or groups etc, as was
> - *       done in IRIX. It is assumed that the uid and groups for the current
> - *       thread are taken from "current" instead of the cr parameter.
> - */
> -STATIC int
> -xfs_acl_access(
> -	uid_t		fuid,
> -	gid_t		fgid,
> -	xfs_acl_t	*fap,
> -	mode_t		md,
> -	cred_t		*cr)
> -{
> -	xfs_acl_entry_t	matched;
> -	int		i, allows;
> -	int		maskallows = -1;	/* true, but not 1, either */
> -	int		seen_userobj = 0;
> -
> -	matched.ae_tag = 0;	/* Invalid type */
> -	matched.ae_perm = 0;
> -
> -	for (i = 0; i < fap->acl_cnt; i++) {
> -		/*
> -		 * Break out if we've got a user_obj entry or
> -		 * a user entry and the mask (and have processed USER_OBJ)
> -		 */
> -		if (matched.ae_tag == ACL_USER_OBJ)
> -			break;
> -		if (matched.ae_tag == ACL_USER) {
> -			if (maskallows != -1 && seen_userobj)
> -				break;
> -			if (fap->acl_entry[i].ae_tag != ACL_MASK &&
> -			    fap->acl_entry[i].ae_tag != ACL_USER_OBJ)
> -				continue;
> -		}
> -		/* True if this entry allows the requested access */
> -		allows = ((fap->acl_entry[i].ae_perm & md) == md);
> -
> -		switch (fap->acl_entry[i].ae_tag) {
> -		case ACL_USER_OBJ:
> -			seen_userobj = 1;
> -			if (fuid != current->fsuid)
> -				continue;
> -			matched.ae_tag = ACL_USER_OBJ;
> -			matched.ae_perm = allows;
> -			break;
> -		case ACL_USER:
> -			if (fap->acl_entry[i].ae_id != current->fsuid)
> -				continue;
> -			matched.ae_tag = ACL_USER;
> -			matched.ae_perm = allows;
> -			break;
> -		case ACL_GROUP_OBJ:
> -			if ((matched.ae_tag == ACL_GROUP_OBJ ||
> -			    matched.ae_tag == ACL_GROUP) && !allows)
> -				continue;
> -			if (!in_group_p(fgid))
> -				continue;
> -			matched.ae_tag = ACL_GROUP_OBJ;
> -			matched.ae_perm = allows;
> -			break;
> -		case ACL_GROUP:
> -			if ((matched.ae_tag == ACL_GROUP_OBJ ||
> -			    matched.ae_tag == ACL_GROUP) && !allows)
> -				continue;
> -			if (!in_group_p(fap->acl_entry[i].ae_id))
> -				continue;
> -			matched.ae_tag = ACL_GROUP;
> -			matched.ae_perm = allows;
> -			break;
> -		case ACL_MASK:
> -			maskallows = allows;
> -			break;
> -		case ACL_OTHER:
> -			if (matched.ae_tag != 0)
> -				continue;
> -			matched.ae_tag = ACL_OTHER;
> -			matched.ae_perm = allows;
> -			break;
> -		}
> -	}
> -	/*
> -	 * First possibility is that no matched entry allows access.
> -	 * The capability to override DAC may exist, so check for it.
> -	 */
> -	switch (matched.ae_tag) {
> -	case ACL_OTHER:
> -	case ACL_USER_OBJ:
> -		if (matched.ae_perm)
> -			return 0;
> -		break;
> -	case ACL_USER:
> -	case ACL_GROUP_OBJ:
> -	case ACL_GROUP:
> -		if (maskallows && matched.ae_perm)
> -			return 0;
> -		break;
> -	case 0:
> -		break;
> -	}
> -
> -	/* EACCES tells generic_permission to check for capability overrides */
> -	return EACCES;
> -}
> -EXPORT_SYMBOL(xfs_acl_access);
> -
> -/*
> - * ACL validity checker.
> - *   This acl validation routine checks each ACL entry read in makes sense.
> - */
> -STATIC int
> -xfs_acl_invalid(
> -	xfs_acl_t	*aclp)
> -{
> -	xfs_acl_entry_t	*entry, *e;
> -	int		user = 0, group = 0, other = 0, mask = 0;
> -	int		mask_required = 0;
> -	int		i, j;
> -
> -	if (!aclp)
> -		goto acl_invalid;
> -
> -	if (aclp->acl_cnt > XFS_ACL_MAX_ENTRIES)
> -		goto acl_invalid;
> -
> -	for (i = 0; i < aclp->acl_cnt; i++) {
> -		entry = &aclp->acl_entry[i];
> -		switch (entry->ae_tag) {
> -		case ACL_USER_OBJ:
> -			if (user++)
> -				goto acl_invalid;
> -			break;
> -		case ACL_GROUP_OBJ:
> -			if (group++)
> -				goto acl_invalid;
> -			break;
> -		case ACL_OTHER:
> -			if (other++)
> -				goto acl_invalid;
> -			break;
> -		case ACL_USER:
> -		case ACL_GROUP:
> -			for (j = i + 1; j < aclp->acl_cnt; j++) {
> -				e = &aclp->acl_entry[j];
> -				if (e->ae_id == entry->ae_id &&
> -				    e->ae_tag == entry->ae_tag)
> -					goto acl_invalid;
> -			}
> -			mask_required++;
> -			break;
> -		case ACL_MASK:
> -			if (mask++)
> -				goto acl_invalid;
> -			break;
> -		default:
> -			goto acl_invalid;
> -		}
> -	}
> -	if (!user || !group || !other || (mask_required && !mask))
> -		goto acl_invalid;
> -	else
> -		return 0;
> -acl_invalid:
> -	return EINVAL;
> -}
> -
> -/*
> - * Do ACL endian conversion.
> - */
> -STATIC void
> -xfs_acl_get_endian(
> -	xfs_acl_t	*aclp)
> -{
> -	xfs_acl_entry_t	*ace, *end;
> -
> -	INT_SET(aclp->acl_cnt, ARCH_CONVERT, aclp->acl_cnt);
> -	end = &aclp->acl_entry[0]+aclp->acl_cnt;
> -	for (ace = &aclp->acl_entry[0]; ace < end; ace++) {
> -		INT_SET(ace->ae_tag, ARCH_CONVERT, ace->ae_tag);
> -		INT_SET(ace->ae_id, ARCH_CONVERT, ace->ae_id);
> -		INT_SET(ace->ae_perm, ARCH_CONVERT, ace->ae_perm);
> -	}
> -}
> -
> -/*
> - * Get the ACL from the EA and do endian conversion.
> - */
> -STATIC void
> -xfs_acl_get_attr(
> -	bhv_vnode_t	*vp,
> -	xfs_acl_t	*aclp,
> -	int		kind,
> -	int		flags,
> -	int		*error)
> -{
> -	int		len = sizeof(xfs_acl_t);
> -
> -	ASSERT((flags & ATTR_KERNOVAL) ? (aclp == NULL) : 1);
> -	flags |= ATTR_ROOT;
> -	*error = xfs_attr_get(xfs_vtoi(vp),
> -					kind == _ACL_TYPE_ACCESS ?
> -					SGI_ACL_FILE : SGI_ACL_DEFAULT,
> -					(char *)aclp, &len, flags, sys_cred);
> -	if (*error || (flags & ATTR_KERNOVAL))
> -		return;
> -	xfs_acl_get_endian(aclp);
> -}
> -
> -/*
> - * Set the EA with the ACL and do endian conversion.
> - */
> -STATIC void
> -xfs_acl_set_attr(
> -	bhv_vnode_t	*vp,
> -	xfs_acl_t	*aclp,
> -	int		kind,
> -	int		*error)
> -{
> -	xfs_acl_entry_t	*ace, *newace, *end;
> -	xfs_acl_t	*newacl;
> -	int		len;
> -
> -	if (!(_ACL_ALLOC(newacl))) {
> -		*error = ENOMEM;
> -		return;
> -	}
> -
> -	len = sizeof(xfs_acl_t) -
> -	      (sizeof(xfs_acl_entry_t) * (XFS_ACL_MAX_ENTRIES - aclp->acl_cnt));
> -	end = &aclp->acl_entry[0]+aclp->acl_cnt;
> -	for (ace = &aclp->acl_entry[0], newace = &newacl->acl_entry[0];
> -	     ace < end;
> -	     ace++, newace++) {
> -		INT_SET(newace->ae_tag, ARCH_CONVERT, ace->ae_tag);
> -		INT_SET(newace->ae_id, ARCH_CONVERT, ace->ae_id);
> -		INT_SET(newace->ae_perm, ARCH_CONVERT, ace->ae_perm);
> -	}
> -	INT_SET(newacl->acl_cnt, ARCH_CONVERT, aclp->acl_cnt);
> -	*error = xfs_attr_set(xfs_vtoi(vp),
> -				kind == _ACL_TYPE_ACCESS ?
> -				SGI_ACL_FILE: SGI_ACL_DEFAULT,
> -				(char *)newacl, len, ATTR_ROOT);
> -	_ACL_FREE(newacl);
> -}
> -
> -int
> -xfs_acl_vtoacl(
> -	bhv_vnode_t	*vp,
> -	xfs_acl_t	*access_acl,
> -	xfs_acl_t	*default_acl)
> -{
> -	bhv_vattr_t	va;
> -	int		error = 0;
> -
> -	if (access_acl) {
> -		/*
> -		 * Get the Access ACL and the mode.  If either cannot
> -		 * be obtained for some reason, invalidate the access ACL.
> -		 */
> -		xfs_acl_get_attr(vp, access_acl, _ACL_TYPE_ACCESS, 0, &error);
> -		if (!error) {
> -			/* Got the ACL, need the mode... */
> -			va.va_mask = XFS_AT_MODE;
> -			error = xfs_getattr(xfs_vtoi(vp), &va, 0);
> -		}
> -
> -		if (error)
> -			access_acl->acl_cnt = XFS_ACL_NOT_PRESENT;
> -		else /* We have a good ACL and the file mode, synchronize. */
> -			xfs_acl_sync_mode(va.va_mode, access_acl);
> -	}
> -
> -	if (default_acl) {
> -		xfs_acl_get_attr(vp, default_acl, _ACL_TYPE_DEFAULT, 0, &error);
> -		if (error)
> -			default_acl->acl_cnt = XFS_ACL_NOT_PRESENT;
> -	}
> -	return error;
> -}
> -
> -/*
> - * This function retrieves the parent directory's acl, processes it
> - * and lets the child inherit the acl(s) that it should.
> - */
> -int
> -xfs_acl_inherit(
> -	bhv_vnode_t	*vp,
> -	mode_t		mode,
> -	xfs_acl_t	*pdaclp)
> -{
> -	xfs_acl_t	*cacl;
> -	int		error = 0;
> -	int		basicperms = 0;
> -
> -	/*
> -	 * If the parent does not have a default ACL, or it's an
> -	 * invalid ACL, we're done.
> -	 */
> -	if (!vp)
> -		return 0;
> -	if (!pdaclp || xfs_acl_invalid(pdaclp))
> -		return 0;
> -
> -	/*
> -	 * Copy the default ACL of the containing directory to
> -	 * the access ACL of the new file and use the mode that
> -	 * was passed in to set up the correct initial values for
> -	 * the u::,g::[m::], and o:: entries.  This is what makes
> -	 * umask() "work" with ACL's.
> -	 */
> -
> -	if (!(_ACL_ALLOC(cacl)))
> -		return ENOMEM;
> -
> -	memcpy(cacl, pdaclp, sizeof(xfs_acl_t));
> -	xfs_acl_filter_mode(mode, cacl);
> -	xfs_acl_setmode(vp, cacl, &basicperms);
> -
> -	/*
> -	 * Set the Default and Access ACL on the file.  The mode is already
> -	 * set on the file, so we don't need to worry about that.
> -	 *
> -	 * If the new file is a directory, its default ACL is a copy of
> -	 * the containing directory's default ACL.
> -	 */
> -	if (VN_ISDIR(vp))
> -		xfs_acl_set_attr(vp, pdaclp, _ACL_TYPE_DEFAULT, &error);
> -	if (!error && !basicperms)
> -		xfs_acl_set_attr(vp, cacl, _ACL_TYPE_ACCESS, &error);
> -	_ACL_FREE(cacl);
> -	return error;
> -}
> -
> -/*
> - * Set up the correct mode on the file based on the supplied ACL.  This
> - * makes sure that the mode on the file reflects the state of the
> - * u::,g::[m::], and o:: entries in the ACL.  Since the mode is where
> - * the ACL is going to get the permissions for these entries, we must
> - * synchronize the mode whenever we set the ACL on a file.
> - */
> -STATIC int
> -xfs_acl_setmode(
> -	bhv_vnode_t	*vp,
> -	xfs_acl_t	*acl,
> -	int		*basicperms)
> -{
> -	bhv_vattr_t	va;
> -	xfs_acl_entry_t	*ap;
> -	xfs_acl_entry_t	*gap = NULL;
> -	int		i, error, nomask = 1;
> -
> -	*basicperms = 1;
> -
> -	if (acl->acl_cnt == XFS_ACL_NOT_PRESENT)
> -		return 0;
> -
> -	/*
> -	 * Copy the u::, g::, o::, and m:: bits from the ACL into the
> -	 * mode.  The m:: bits take precedence over the g:: bits.
> -	 */
> -	va.va_mask = XFS_AT_MODE;
> -	error = xfs_getattr(xfs_vtoi(vp), &va, 0);
> -	if (error)
> -		return error;
> -
> -	va.va_mask = XFS_AT_MODE;
> -	va.va_mode &= ~(S_IRWXU|S_IRWXG|S_IRWXO);
> -	ap = acl->acl_entry;
> -	for (i = 0; i < acl->acl_cnt; ++i) {
> -		switch (ap->ae_tag) {
> -		case ACL_USER_OBJ:
> -			va.va_mode |= ap->ae_perm << 6;
> -			break;
> -		case ACL_GROUP_OBJ:
> -			gap = ap;
> -			break;
> -		case ACL_MASK:	/* more than just standard modes */
> -			nomask = 0;
> -			va.va_mode |= ap->ae_perm << 3;
> -			*basicperms = 0;
> -			break;
> -		case ACL_OTHER:
> -			va.va_mode |= ap->ae_perm;
> -			break;
> -		default:	/* more than just standard modes */
> -			*basicperms = 0;
> -			break;
> -		}
> -		ap++;
> -	}
> -
> -	/* Set the group bits from ACL_GROUP_OBJ if there's no ACL_MASK */
> -	if (gap && nomask)
> -		va.va_mode |= gap->ae_perm << 3;
> -
> -	return xfs_setattr(xfs_vtoi(vp), &va, 0, sys_cred);
> -}
> -
> -/*
> - * The permissions for the special ACL entries (u::, g::[m::], o::) are
> - * actually stored in the file mode (if there is both a group and a mask,
> - * the group is stored in the ACL entry and the mask is stored on the file).
> - * This allows the mode to remain automatically in sync with the ACL without
> - * the need for a call-back to the ACL system at every point where the mode
> - * could change.  This function takes the permissions from the specified mode
> - * and places it in the supplied ACL.
> - *
> - * This implementation draws its validity from the fact that, when the ACL
> - * was assigned, the mode was copied from the ACL.
> - * If the mode did not change, therefore, the mode remains exactly what was
> - * taken from the special ACL entries at assignment.
> - * If a subsequent chmod() was done, the POSIX spec says that the change in
> - * mode must cause an update to the ACL seen at user level and used for
> - * access checks.  Before and after a mode change, therefore, the file mode
> - * most accurately reflects what the special ACL entries should permit/deny.
> - *
> - * CAVEAT: If someone sets the SGI_ACL_FILE attribute directly,
> - *         the existing mode bits will override whatever is in the
> - *         ACL. Similarly, if there is a pre-existing ACL that was
> - *         never in sync with its mode (owing to a bug in 6.5 and
> - *         before), it will now magically (or mystically) be
> - *         synchronized.  This could cause slight astonishment, but
> - *         it is better than inconsistent permissions.
> - *
> - * The supplied ACL is a template that may contain any combination
> - * of special entries.  These are treated as place holders when we fill
> - * out the ACL.  This routine does not add or remove special entries, it
> - * simply unites each special entry with its associated set of permissions.
> - */
> -STATIC void
> -xfs_acl_sync_mode(
> -	mode_t		mode,
> -	xfs_acl_t	*acl)
> -{
> -	int		i, nomask = 1;
> -	xfs_acl_entry_t	*ap;
> -	xfs_acl_entry_t	*gap = NULL;
> -
> -	/*
> -	 * Set ACL entries. POSIX1003.1eD16 requires that the MASK
> -	 * be set instead of the GROUP entry, if there is a MASK.
> -	 */
> -	for (ap = acl->acl_entry, i = 0; i < acl->acl_cnt; ap++, i++) {
> -		switch (ap->ae_tag) {
> -		case ACL_USER_OBJ:
> -			ap->ae_perm = (mode >> 6) & 0x7;
> -			break;
> -		case ACL_GROUP_OBJ:
> -			gap = ap;
> -			break;
> -		case ACL_MASK:
> -			nomask = 0;
> -			ap->ae_perm = (mode >> 3) & 0x7;
> -			break;
> -		case ACL_OTHER:
> -			ap->ae_perm = mode & 0x7;
> -			break;
> -		default:
> -			break;
> -		}
> -	}
> -	/* Set the ACL_GROUP_OBJ if there's no ACL_MASK */
> -	if (gap && nomask)
> -		gap->ae_perm = (mode >> 3) & 0x7;
> -}
> -
> -/*
> - * When inheriting an Access ACL from a directory Default ACL,
> - * the ACL bits are set to the intersection of the ACL default
> - * permission bits and the file permission bits in mode. If there
> - * are no permission bits on the file then we must not give them
> - * the ACL. This is what what makes umask() work with ACLs.
> - */
> -STATIC void
> -xfs_acl_filter_mode(
> -	mode_t		mode,
> -	xfs_acl_t	*acl)
> -{
> -	int		i, nomask = 1;
> -	xfs_acl_entry_t	*ap;
> -	xfs_acl_entry_t	*gap = NULL;
> -
> -	/*
> -	 * Set ACL entries. POSIX1003.1eD16 requires that the MASK
> -	 * be merged with GROUP entry, if there is a MASK.
> -	 */
> -	for (ap = acl->acl_entry, i = 0; i < acl->acl_cnt; ap++, i++) {
> -		switch (ap->ae_tag) {
> -		case ACL_USER_OBJ:
> -			ap->ae_perm &= (mode >> 6) & 0x7;
> -			break;
> -		case ACL_GROUP_OBJ:
> -			gap = ap;
> -			break;
> -		case ACL_MASK:
> -			nomask = 0;
> -			ap->ae_perm &= (mode >> 3) & 0x7;
> -			break;
> -		case ACL_OTHER:
> -			ap->ae_perm &= mode & 0x7;
> -			break;
> -		default:
> -			break;
> -		}
> -	}
> -	/* Set the ACL_GROUP_OBJ if there's no ACL_MASK */
> -	if (gap && nomask)
> -		gap->ae_perm &= (mode >> 3) & 0x7;
> -}
> Index: linux-2.6-xfs/fs/xfs/Makefile
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/Makefile	2008-02-05 08:43:31.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/Makefile	2008-02-07 09:15:35.000000000 +0100
> @@ -29,7 +29,7 @@ obj-$(CONFIG_XFS_QUOTA)		+= quota/
>  obj-$(CONFIG_XFS_DMAPI)		+= dmapi/
>  
>  xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
> -xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
> +xfs-$(CONFIG_XFS_POSIX_ACL)	+= $(XFS_LINUX)/xfs_acl.o
>  xfs-$(CONFIG_PROC_FS)		+= $(XFS_LINUX)/xfs_stats.o
>  xfs-$(CONFIG_SYSCTL)		+= $(XFS_LINUX)/xfs_sysctl.o
>  xfs-$(CONFIG_COMPAT)		+= $(XFS_LINUX)/xfs_ioctl32.o
> Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-02-05 08:43:31.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-02-07 09:15:35.000000000 +0100
> @@ -52,6 +52,7 @@
>  #include "xfs_acl.h"
>  #include "xfs_filestream.h"
>  #include "xfs_vnodeops.h"
> +#include "xfs_acl.h"
>  
>  kmem_zone_t *xfs_ifork_zone;
>  kmem_zone_t *xfs_inode_zone;
> @@ -870,6 +871,7 @@ xfs_iread(
>  	ip->i_mount = mp;
>  	atomic_set(&ip->i_iocount, 0);
>  	spin_lock_init(&ip->i_flags_lock);
> +	xfs_inode_init_acls(ip);
>  
>  	/*
>  	 * Get pointer's to the on-disk inode and the buffer containing it.
> @@ -2793,6 +2795,8 @@ xfs_idestroy(
>  		}
>  		xfs_inode_item_destroy(ip);
>  	}
> +
> +	xfs_inode_clear_acls(ip);
>  	kmem_zone_free(xfs_inode_zone, ip);
>  }
>  
> Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-02-05 08:43:31.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-02-07 09:15:35.000000000 +0100
> @@ -18,6 +18,7 @@
>  #ifndef	__XFS_INODE_H__
>  #define	__XFS_INODE_H__
>  
> +struct posix_acl;
>  struct xfs_dinode;
>  struct xfs_dinode_core;
>  
> @@ -258,6 +259,11 @@ typedef struct xfs_inode {
>  	xfs_fsize_t		i_size;		/* in-memory size */
>  	xfs_fsize_t		i_new_size;	/* size when write completes */
>  	atomic_t		i_iocount;	/* outstanding I/O count */
> +
> +#ifdef CONFIG_XFS_POSIX_ACL
> +	struct posix_acl	*i_acl;
> +	struct posix_acl	*i_default_acl;
> +#endif
>  	/* Trace buffers per inode. */
>  #ifdef XFS_INODE_TRACE
>  	struct ktrace		*i_trace;	/* general inode trace */
> Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-02-07 09:15:55.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-02-07 09:16:07.000000000 +0100
> @@ -77,132 +77,6 @@ xfs_open(
>  }
>  
>  /*
> - * xfs_getattr
> - */
> -int
> -xfs_getattr(
> -	xfs_inode_t	*ip,
> -	bhv_vattr_t	*vap,
> -	int		flags)
> -{
> -	bhv_vnode_t	*vp = XFS_ITOV(ip);
> -	xfs_mount_t	*mp = ip->i_mount;
> -
> -	xfs_itrace_entry(ip);
> -
> -	if (XFS_FORCED_SHUTDOWN(mp))
> -		return XFS_ERROR(EIO);
> -
> -	if (!(flags & ATTR_LAZY))
> -		xfs_ilock(ip, XFS_ILOCK_SHARED);
> -
> -	vap->va_size = XFS_ISIZE(ip);
> -	if (vap->va_mask == XFS_AT_SIZE)
> -		goto all_done;
> -
> -	vap->va_nblocks =
> -		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
> -	vap->va_nodeid = ip->i_ino;
> -#if XFS_BIG_INUMS
> -	vap->va_nodeid += mp->m_inoadd;
> -#endif
> -	vap->va_nlink = ip->i_d.di_nlink;
> -
> -	/*
> -	 * Quick exit for non-stat callers
> -	 */
> -	if ((vap->va_mask &
> -	    ~(XFS_AT_SIZE|XFS_AT_FSID|XFS_AT_NODEID|
> -	      XFS_AT_NLINK|XFS_AT_BLKSIZE)) == 0)
> -		goto all_done;
> -
> -	/*
> -	 * Copy from in-core inode.
> -	 */
> -	vap->va_mode = ip->i_d.di_mode;
> -	vap->va_uid = ip->i_d.di_uid;
> -	vap->va_gid = ip->i_d.di_gid;
> -	vap->va_projid = ip->i_d.di_projid;
> -
> -	/*
> -	 * Check vnode type block/char vs. everything else.
> -	 */
> -	switch (ip->i_d.di_mode & S_IFMT) {
> -	case S_IFBLK:
> -	case S_IFCHR:
> -		vap->va_rdev = ip->i_df.if_u2.if_rdev;
> -		vap->va_blocksize = BLKDEV_IOSIZE;
> -		break;
> -	default:
> -		vap->va_rdev = 0;
> -
> -		if (!(XFS_IS_REALTIME_INODE(ip))) {
> -			vap->va_blocksize = xfs_preferred_iosize(mp);
> -		} else {
> -
> -			/*
> -			 * If the file blocks are being allocated from a
> -			 * realtime partition, then return the inode's
> -			 * realtime extent size or the realtime volume's
> -			 * extent size.
> -			 */
> -			vap->va_blocksize =
> -				xfs_get_extsz_hint(ip) << mp->m_sb.sb_blocklog;
> -		}
> -		break;
> -	}
> -
> -	vn_atime_to_timespec(vp, &vap->va_atime);
> -	vap->va_mtime.tv_sec = ip->i_d.di_mtime.t_sec;
> -	vap->va_mtime.tv_nsec = ip->i_d.di_mtime.t_nsec;
> -	vap->va_ctime.tv_sec = ip->i_d.di_ctime.t_sec;
> -	vap->va_ctime.tv_nsec = ip->i_d.di_ctime.t_nsec;
> -
> -	/*
> -	 * Exit for stat callers.  See if any of the rest of the fields
> -	 * to be filled in are needed.
> -	 */
> -	if ((vap->va_mask &
> -	     (XFS_AT_XFLAGS|XFS_AT_EXTSIZE|XFS_AT_NEXTENTS|XFS_AT_ANEXTENTS|
> -	      XFS_AT_GENCOUNT|XFS_AT_VCODE)) == 0)
> -		goto all_done;
> -
> -	/*
> -	 * Convert di_flags to xflags.
> -	 */
> -	vap->va_xflags = xfs_ip2xflags(ip);
> -
> -	/*
> -	 * Exit for inode revalidate.  See if any of the rest of
> -	 * the fields to be filled in are needed.
> -	 */
> -	if ((vap->va_mask &
> -	     (XFS_AT_EXTSIZE|XFS_AT_NEXTENTS|XFS_AT_ANEXTENTS|
> -	      XFS_AT_GENCOUNT|XFS_AT_VCODE)) == 0)
> -		goto all_done;
> -
> -	vap->va_extsize = ip->i_d.di_extsize << mp->m_sb.sb_blocklog;
> -	vap->va_nextents =
> -		(ip->i_df.if_flags & XFS_IFEXTENTS) ?
> -			ip->i_df.if_bytes / sizeof(xfs_bmbt_rec_t) :
> -			ip->i_d.di_nextents;
> -	if (ip->i_afp)
> -		vap->va_anextents =
> -			(ip->i_afp->if_flags & XFS_IFEXTENTS) ?
> -				ip->i_afp->if_bytes / sizeof(xfs_bmbt_rec_t) :
> -				 ip->i_d.di_anextents;
> -	else
> -		vap->va_anextents = 0;
> -	vap->va_gen = ip->i_d.di_gen;
> -
> - all_done:
> -	if (!(flags & ATTR_LAZY))
> -		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -	return 0;
> -}
> -
> -
> -/*
>   * xfs_setattr
>   */
>  int
> Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2008-02-07 09:15:48.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-02-07 09:15:53.000000000 +0100
> @@ -15,7 +15,6 @@ struct xfs_iomap;
>  
>  
>  int xfs_open(struct xfs_inode *ip);
> -int xfs_getattr(struct xfs_inode *ip, struct bhv_vattr *vap, int flags);
>  int xfs_setattr(struct xfs_inode *ip, struct bhv_vattr *vap, int flags,
>  		struct cred *credp);
>  int xfs_readlink(struct xfs_inode *ip, char *link);
> 

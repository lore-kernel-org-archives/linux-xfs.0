Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED62E7F57
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 16:17:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 641ACAC004
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 14:17:36 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Y7RXJSHzBt3zYluy for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 14:17:34 -0800 (PST)
Date: Mon, 2 Dec 2013 23:17:33 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 13/18] reiserfs: use generic posix ACL infrastructure
Message-ID: <20131202221733.GJ12253@quack.suse.cz>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120656.032405773@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131201120656.032405773@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Sun 01-12-13 03:59:16, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/reiserfs/acl.h       |    4 +-
>  fs/reiserfs/file.c      |    1 +
>  fs/reiserfs/namei.c     |    3 +
>  fs/reiserfs/xattr.c     |    5 +-
>  fs/reiserfs/xattr_acl.c |  175 ++++++++---------------------------------------
>  5 files changed, 36 insertions(+), 152 deletions(-)
> 
> diff --git a/fs/reiserfs/acl.h b/fs/reiserfs/acl.h
> index f096b80..4a211f5 100644
> --- a/fs/reiserfs/acl.h
> +++ b/fs/reiserfs/acl.h
> @@ -48,18 +48,18 @@ static inline int reiserfs_acl_count(size_t size)
>  
>  #ifdef CONFIG_REISERFS_FS_POSIX_ACL
>  struct posix_acl *reiserfs_get_acl(struct inode *inode, int type);
> +int reiserfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
>  int reiserfs_acl_chmod(struct inode *inode);
>  int reiserfs_inherit_default_acl(struct reiserfs_transaction_handle *th,
>  				 struct inode *dir, struct dentry *dentry,
>  				 struct inode *inode);
>  int reiserfs_cache_default_acl(struct inode *dir);
> -extern const struct xattr_handler reiserfs_posix_acl_default_handler;
> -extern const struct xattr_handler reiserfs_posix_acl_access_handler;
>  
>  #else
>  
>  #define reiserfs_cache_default_acl(inode) 0
>  #define reiserfs_get_acl NULL
> +#define reiserfs_set_acl NULL
>  
>  static inline int reiserfs_acl_chmod(struct inode *inode)
>  {
> diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
> index dcaafcf..ed58d84 100644
> --- a/fs/reiserfs/file.c
> +++ b/fs/reiserfs/file.c
> @@ -260,4 +260,5 @@ const struct inode_operations reiserfs_file_inode_operations = {
>  	.removexattr = reiserfs_removexattr,
>  	.permission = reiserfs_permission,
>  	.get_acl = reiserfs_get_acl,
> +	.set_acl = reiserfs_set_acl,
>  };
> diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
> index dc5236f..8ba707e 100644
> --- a/fs/reiserfs/namei.c
> +++ b/fs/reiserfs/namei.c
> @@ -1522,6 +1522,7 @@ const struct inode_operations reiserfs_dir_inode_operations = {
>  	.removexattr = reiserfs_removexattr,
>  	.permission = reiserfs_permission,
>  	.get_acl = reiserfs_get_acl,
> +	.set_acl = reiserfs_set_acl,
>  };
>  
>  /*
> @@ -1539,6 +1540,7 @@ const struct inode_operations reiserfs_symlink_inode_operations = {
>  	.removexattr = reiserfs_removexattr,
>  	.permission = reiserfs_permission,
>  	.get_acl = reiserfs_get_acl,
> +	.set_acl = reiserfs_set_acl,
>  
>  };
>  
> @@ -1553,4 +1555,5 @@ const struct inode_operations reiserfs_special_inode_operations = {
>  	.removexattr = reiserfs_removexattr,
>  	.permission = reiserfs_permission,
>  	.get_acl = reiserfs_get_acl,
> +	.set_acl = reiserfs_set_acl,
>  };
> diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
> index 8a9e2dc..5cdfbd6 100644
> --- a/fs/reiserfs/xattr.c
> +++ b/fs/reiserfs/xattr.c
> @@ -50,6 +50,7 @@
>  #include <linux/stat.h>
>  #include <linux/quotaops.h>
>  #include <linux/security.h>
> +#include <linux/posix_acl_xattr.h>
>  
>  #define PRIVROOT_NAME ".reiserfs_priv"
>  #define XAROOT_NAME   "xattrs"
> @@ -904,8 +905,8 @@ static const struct xattr_handler *reiserfs_xattr_handlers[] = {
>  	&reiserfs_xattr_security_handler,
>  #endif
>  #ifdef CONFIG_REISERFS_FS_POSIX_ACL
> -	&reiserfs_posix_acl_access_handler,
> -	&reiserfs_posix_acl_default_handler,
> +	&posix_acl_access_xattr_handler,
> +	&posix_acl_default_xattr_handler,
>  #endif
>  	NULL
>  };
> diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
> index d95c959..ff04988 100644
> --- a/fs/reiserfs/xattr_acl.c
> +++ b/fs/reiserfs/xattr_acl.c
> @@ -11,35 +11,19 @@
>  #include "acl.h"
>  #include <asm/uaccess.h>
>  
> -static int reiserfs_set_acl(struct reiserfs_transaction_handle *th,
> +static int __reiserfs_set_acl(struct reiserfs_transaction_handle *th,
>  			    struct inode *inode, int type,
>  			    struct posix_acl *acl);
>  
> -static int
> -reiserfs_posix_acl_set(struct dentry *dentry, const char *name, const void *value,
> -		size_t size, int flags, int type)
> +
> +int
> +reiserfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
> -	struct inode *inode = dentry->d_inode;
> -	struct posix_acl *acl;
>  	int error, error2;
>  	struct reiserfs_transaction_handle th;
>  	size_t jcreate_blocks;
> -	if (!reiserfs_posixacl(inode->i_sb))
> -		return -EOPNOTSUPP;
> -	if (!inode_owner_or_capable(inode))
> -		return -EPERM;
> -
> -	if (value) {
> -		acl = posix_acl_from_xattr(&init_user_ns, value, size);
> -		if (IS_ERR(acl)) {
> -			return PTR_ERR(acl);
> -		} else if (acl) {
> -			error = posix_acl_valid(acl);
> -			if (error)
> -				goto release_and_out;
> -		}
> -	} else
> -		acl = NULL;
> +	int size = acl ? posix_acl_xattr_size(acl->a_count) : 0;
> +
>  
>  	/* Pessimism: We can't assume that anything from the xattr root up
>  	 * has been created. */
> @@ -51,7 +35,7 @@ reiserfs_posix_acl_set(struct dentry *dentry, const char *name, const void *valu
>  	error = journal_begin(&th, inode->i_sb, jcreate_blocks);
>  	reiserfs_write_unlock(inode->i_sb);
>  	if (error == 0) {
> -		error = reiserfs_set_acl(&th, inode, type, acl);
> +		error = __reiserfs_set_acl(&th, inode, type, acl);
>  		reiserfs_write_lock(inode->i_sb);
>  		error2 = journal_end(&th, inode->i_sb, jcreate_blocks);
>  		reiserfs_write_unlock(inode->i_sb);
> @@ -59,29 +43,6 @@ reiserfs_posix_acl_set(struct dentry *dentry, const char *name, const void *valu
>  			error = error2;
>  	}
>  
> -      release_and_out:
> -	posix_acl_release(acl);
> -	return error;
> -}
> -
> -static int
> -reiserfs_posix_acl_get(struct dentry *dentry, const char *name, void *buffer,
> -		size_t size, int type)
> -{
> -	struct posix_acl *acl;
> -	int error;
> -
> -	if (!reiserfs_posixacl(dentry->d_sb))
> -		return -EOPNOTSUPP;
> -
> -	acl = reiserfs_get_acl(dentry->d_inode, type);
> -	if (IS_ERR(acl))
> -		return PTR_ERR(acl);
> -	if (acl == NULL)
> -		return -ENODATA;
> -	error = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
> -	posix_acl_release(acl);
> -
>  	return error;
>  }
>  
> @@ -273,7 +234,7 @@ struct posix_acl *reiserfs_get_acl(struct inode *inode, int type)
>   * BKL held [before 2.5.x]
>   */
>  static int
> -reiserfs_set_acl(struct reiserfs_transaction_handle *th, struct inode *inode,
> +__reiserfs_set_acl(struct reiserfs_transaction_handle *th, struct inode *inode,
>  		 int type, struct posix_acl *acl)
>  {
>  	char *name;
> @@ -343,7 +304,7 @@ reiserfs_inherit_default_acl(struct reiserfs_transaction_handle *th,
>  			     struct inode *dir, struct dentry *dentry,
>  			     struct inode *inode)
>  {
> -	struct posix_acl *acl;
> +	struct posix_acl *default_acl, *acl;
>  	int err = 0;
>  
>  	/* ACLs only get applied to files and directories */
> @@ -363,37 +324,28 @@ reiserfs_inherit_default_acl(struct reiserfs_transaction_handle *th,
>  		goto apply_umask;
>  	}
>  
> -	acl = reiserfs_get_acl(dir, ACL_TYPE_DEFAULT);
> -	if (IS_ERR(acl))
> -		return PTR_ERR(acl);
> +	err = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
> +	if (err)
> +		return err;
>  
> +	if (default_acl) {
> +		err = __reiserfs_set_acl(th, inode, ACL_TYPE_DEFAULT,
> +					 default_acl);
> +		posix_acl_release(default_acl);
> +	}
>  	if (acl) {
> -		/* Copy the default ACL to the default ACL of a new directory */
> -		if (S_ISDIR(inode->i_mode)) {
> -			err = reiserfs_set_acl(th, inode, ACL_TYPE_DEFAULT,
> -					       acl);
> -			if (err)
> -				goto cleanup;
> -		}
> -
> -		/* Now we reconcile the new ACL and the mode,
> -		   potentially modifying both */
> -		err = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
> -		if (err < 0)
> -			return err;
> -
> -		/* If we need an ACL.. */
> -		if (err > 0)
> -			err = reiserfs_set_acl(th, inode, ACL_TYPE_ACCESS, acl);
> -	      cleanup:
> +		if (!err)
> +			err = __reiserfs_set_acl(th, inode, ACL_TYPE_ACCESS,
> +						 acl);
>  		posix_acl_release(acl);
> -	} else {
> -	      apply_umask:
> -		/* no ACL, apply umask */
> -		inode->i_mode &= ~current_umask();
>  	}
>  
>  	return err;
> +
> +      apply_umask:
> +	/* no ACL, apply umask */
> +	inode->i_mode &= ~current_umask();
> +	return err;
>  }
>  
>  /* This is used to cache the default acl before a new object is created.
> @@ -442,84 +394,11 @@ int reiserfs_cache_default_acl(struct inode *inode)
>   */
>  int reiserfs_acl_chmod(struct inode *inode)
>  {
> -	struct reiserfs_transaction_handle th;
> -	struct posix_acl *acl;
> -	size_t size;
> -	int error;
> -
>  	if (IS_PRIVATE(inode))
>  		return 0;
> -
> -	if (S_ISLNK(inode->i_mode))
> -		return -EOPNOTSUPP;
> -
>  	if (get_inode_sd_version(inode) == STAT_DATA_V1 ||
> -	    !reiserfs_posixacl(inode->i_sb)) {
> +	    !reiserfs_posixacl(inode->i_sb))
>  		return 0;
> -	}
>  
> -	acl = reiserfs_get_acl(inode, ACL_TYPE_ACCESS);
> -	if (!acl)
> -		return 0;
> -	if (IS_ERR(acl))
> -		return PTR_ERR(acl);
> -	error = __posix_acl_chmod(&acl, GFP_NOFS, inode->i_mode);
> -	if (error)
> -		return error;
> -
> -	size = reiserfs_xattr_nblocks(inode, reiserfs_acl_size(acl->a_count));
> -	reiserfs_write_lock(inode->i_sb);
> -	error = journal_begin(&th, inode->i_sb, size * 2);
> -	reiserfs_write_unlock(inode->i_sb);
> -	if (!error) {
> -		int error2;
> -		error = reiserfs_set_acl(&th, inode, ACL_TYPE_ACCESS, acl);
> -		reiserfs_write_lock(inode->i_sb);
> -		error2 = journal_end(&th, inode->i_sb, size * 2);
> -		reiserfs_write_unlock(inode->i_sb);
> -		if (error2)
> -			error = error2;
> -	}
> -	posix_acl_release(acl);
> -	return error;
> -}
> -
> -static size_t posix_acl_access_list(struct dentry *dentry, char *list,
> -				    size_t list_size, const char *name,
> -				    size_t name_len, int type)
> -{
> -	const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
> -	if (!reiserfs_posixacl(dentry->d_sb))
> -		return 0;
> -	if (list && size <= list_size)
> -		memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
> -	return size;
> +	return posix_acl_chmod(inode);
>  }
> -
> -const struct xattr_handler reiserfs_posix_acl_access_handler = {
> -	.prefix = POSIX_ACL_XATTR_ACCESS,
> -	.flags = ACL_TYPE_ACCESS,
> -	.get = reiserfs_posix_acl_get,
> -	.set = reiserfs_posix_acl_set,
> -	.list = posix_acl_access_list,
> -};
> -
> -static size_t posix_acl_default_list(struct dentry *dentry, char *list,
> -				     size_t list_size, const char *name,
> -				     size_t name_len, int type)
> -{
> -	const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
> -	if (!reiserfs_posixacl(dentry->d_sb))
> -		return 0;
> -	if (list && size <= list_size)
> -		memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
> -	return size;
> -}
> -
> -const struct xattr_handler reiserfs_posix_acl_default_handler = {
> -	.prefix = POSIX_ACL_XATTR_DEFAULT,
> -	.flags = ACL_TYPE_DEFAULT,
> -	.get = reiserfs_posix_acl_get,
> -	.set = reiserfs_posix_acl_set,
> -	.list = posix_acl_default_list,
> -};
> -- 
> 1.7.10.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

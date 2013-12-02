Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DBCC229E05
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 16:13:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8CDA48F8084
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 14:13:45 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ihxTHqlQjioYFetm for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 14:13:42 -0800 (PST)
Date: Mon, 2 Dec 2013 23:13:39 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 08/18] ext2/3/4: use generic posix ACL infrastructure
Message-ID: <20131202221339.GI12253@quack.suse.cz>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120655.018342089@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131201120655.018342089@bombadil.infradead.org>
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

On Sun 01-12-13 03:59:11, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

							Honza

> ---
>  fs/ext2/acl.c   |  176 ++++-----------------------------------------
>  fs/ext2/acl.h   |    8 +--
>  fs/ext2/file.c  |    1 +
>  fs/ext2/inode.c |    2 +-
>  fs/ext2/namei.c |    2 +
>  fs/ext2/xattr.c |    8 +--
>  fs/ext2/xattr.h |    2 -
>  fs/ext3/acl.c   |  213 ++++++++-----------------------------------------------
>  fs/ext3/acl.h   |    9 +--
>  fs/ext3/file.c  |    1 +
>  fs/ext3/inode.c |    2 +-
>  fs/ext3/namei.c |    2 +
>  fs/ext3/xattr.c |    8 +--
>  fs/ext3/xattr.h |    2 -
>  fs/ext4/acl.c   |  213 ++++++++-----------------------------------------------
>  fs/ext4/acl.h   |    9 +--
>  fs/ext4/file.c  |    1 +
>  fs/ext4/inode.c |    2 +-
>  fs/ext4/namei.c |    2 +
>  fs/ext4/xattr.c |    8 +--
>  fs/ext4/xattr.h |    2 -
>  21 files changed, 100 insertions(+), 573 deletions(-)
> 
> diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
> index 6e842a7..f04a295 100644
> --- a/fs/ext2/acl.c
> +++ b/fs/ext2/acl.c
> @@ -189,8 +189,8 @@ ext2_get_acl(struct inode *inode, int type)
>  /*
>   * inode->i_mutex: down
>   */
> -static int
> -ext2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
> +int
> +ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
>  	int name_index;
>  	void *value = NULL;
> @@ -250,169 +250,21 @@ ext2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
>  int
>  ext2_init_acl(struct inode *inode, struct inode *dir)
>  {
> -	struct posix_acl *acl = NULL;
> -	int error = 0;
> -
> -	if (!S_ISLNK(inode->i_mode)) {
> -		if (test_opt(dir->i_sb, POSIX_ACL)) {
> -			acl = ext2_get_acl(dir, ACL_TYPE_DEFAULT);
> -			if (IS_ERR(acl))
> -				return PTR_ERR(acl);
> -		}
> -		if (!acl)
> -			inode->i_mode &= ~current_umask();
> -	}
> -	if (test_opt(inode->i_sb, POSIX_ACL) && acl) {
> -		if (S_ISDIR(inode->i_mode)) {
> -			error = ext2_set_acl(inode, ACL_TYPE_DEFAULT, acl);
> -			if (error)
> -				goto cleanup;
> -		}
> -		error = __posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
> -		if (error < 0)
> -			return error;
> -		if (error > 0) {
> -			/* This is an extended ACL */
> -			error = ext2_set_acl(inode, ACL_TYPE_ACCESS, acl);
> -		}
> -	}
> -cleanup:
> -       posix_acl_release(acl);
> -       return error;
> -}
> -
> -/*
> - * Does chmod for an inode that may have an Access Control List. The
> - * inode->i_mode field must be updated to the desired value by the caller
> - * before calling this function.
> - * Returns 0 on success, or a negative error number.
> - *
> - * We change the ACL rather than storing some ACL entries in the file
> - * mode permission bits (which would be more efficient), because that
> - * would break once additional permissions (like  ACL_APPEND, ACL_DELETE
> - * for directories) are added. There are no more bits available in the
> - * file mode.
> - *
> - * inode->i_mutex: down
> - */
> -int
> -ext2_acl_chmod(struct inode *inode)
> -{
> -	struct posix_acl *acl;
> -        int error;
> +	struct posix_acl *default_acl, *acl;
> +	int error;
>  
> -	if (!test_opt(inode->i_sb, POSIX_ACL))
> -		return 0;
> -	if (S_ISLNK(inode->i_mode))
> -		return -EOPNOTSUPP;
> -	acl = ext2_get_acl(inode, ACL_TYPE_ACCESS);
> -	if (IS_ERR(acl) || !acl)
> -		return PTR_ERR(acl);
> -	error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
> +	error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
>  	if (error)
>  		return error;
> -	error = ext2_set_acl(inode, ACL_TYPE_ACCESS, acl);
> -	posix_acl_release(acl);
> -	return error;
> -}
> -
> -/*
> - * Extended attribut handlers
> - */
> -static size_t
> -ext2_xattr_list_acl_access(struct dentry *dentry, char *list, size_t list_size,
> -			   const char *name, size_t name_len, int type)
> -{
> -	const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
> -
> -	if (!test_opt(dentry->d_sb, POSIX_ACL))
> -		return 0;
> -	if (list && size <= list_size)
> -		memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
> -	return size;
> -}
>  
> -static size_t
> -ext2_xattr_list_acl_default(struct dentry *dentry, char *list, size_t list_size,
> -			    const char *name, size_t name_len, int type)
> -{
> -	const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
> -
> -	if (!test_opt(dentry->d_sb, POSIX_ACL))
> -		return 0;
> -	if (list && size <= list_size)
> -		memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
> -	return size;
> -}
> -
> -static int
> -ext2_xattr_get_acl(struct dentry *dentry, const char *name, void *buffer,
> -		   size_t size, int type)
> -{
> -	struct posix_acl *acl;
> -	int error;
> -
> -	if (strcmp(name, "") != 0)
> -		return -EINVAL;
> -	if (!test_opt(dentry->d_sb, POSIX_ACL))
> -		return -EOPNOTSUPP;
> -
> -	acl = ext2_get_acl(dentry->d_inode, type);
> -	if (IS_ERR(acl))
> -		return PTR_ERR(acl);
> -	if (acl == NULL)
> -		return -ENODATA;
> -	error = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
> -	posix_acl_release(acl);
> -
> -	return error;
> -}
> -
> -static int
> -ext2_xattr_set_acl(struct dentry *dentry, const char *name, const void *value,
> -		   size_t size, int flags, int type)
> -{
> -	struct posix_acl *acl;
> -	int error;
> -
> -	if (strcmp(name, "") != 0)
> -		return -EINVAL;
> -	if (!test_opt(dentry->d_sb, POSIX_ACL))
> -		return -EOPNOTSUPP;
> -	if (!inode_owner_or_capable(dentry->d_inode))
> -		return -EPERM;
> -
> -	if (value) {
> -		acl = posix_acl_from_xattr(&init_user_ns, value, size);
> -		if (IS_ERR(acl))
> -			return PTR_ERR(acl);
> -		else if (acl) {
> -			error = posix_acl_valid(acl);
> -			if (error)
> -				goto release_and_out;
> -		}
> -	} else
> -		acl = NULL;
> -
> -	error = ext2_set_acl(dentry->d_inode, type, acl);
> -
> -release_and_out:
> -	posix_acl_release(acl);
> +	if (default_acl) {
> +		error = ext2_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
> +		posix_acl_release(default_acl);
> +	}
> +	if (acl) {
> +		if (!error)
> +			error = ext2_set_acl(inode, acl, ACL_TYPE_ACCESS);
> +		posix_acl_release(acl);
> +	}
>  	return error;
>  }
> -
> -const struct xattr_handler ext2_xattr_acl_access_handler = {
> -	.prefix	= POSIX_ACL_XATTR_ACCESS,
> -	.flags	= ACL_TYPE_ACCESS,
> -	.list	= ext2_xattr_list_acl_access,
> -	.get	= ext2_xattr_get_acl,
> -	.set	= ext2_xattr_set_acl,
> -};
> -
> -const struct xattr_handler ext2_xattr_acl_default_handler = {
> -	.prefix	= POSIX_ACL_XATTR_DEFAULT,
> -	.flags	= ACL_TYPE_DEFAULT,
> -	.list	= ext2_xattr_list_acl_default,
> -	.get	= ext2_xattr_get_acl,
> -	.set	= ext2_xattr_set_acl,
> -};
> diff --git a/fs/ext2/acl.h b/fs/ext2/acl.h
> index 503bfb0..44937f9 100644
> --- a/fs/ext2/acl.h
> +++ b/fs/ext2/acl.h
> @@ -55,7 +55,7 @@ static inline int ext2_acl_count(size_t size)
>  
>  /* acl.c */
>  extern struct posix_acl *ext2_get_acl(struct inode *inode, int type);
> -extern int ext2_acl_chmod (struct inode *);
> +extern int ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type);
>  extern int ext2_init_acl (struct inode *, struct inode *);
>  
>  #else
> @@ -63,12 +63,6 @@ extern int ext2_init_acl (struct inode *, struct inode *);
>  #define ext2_get_acl	NULL
>  #define ext2_set_acl	NULL
>  
> -static inline int
> -ext2_acl_chmod (struct inode *inode)
> -{
> -	return 0;
> -}
> -
>  static inline int ext2_init_acl (struct inode *inode, struct inode *dir)
>  {
>  	return 0;
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index a5b3a5d..44c36e5 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -103,5 +103,6 @@ const struct inode_operations ext2_file_inode_operations = {
>  #endif
>  	.setattr	= ext2_setattr,
>  	.get_acl	= ext2_get_acl,
> +	.set_acl	= ext2_set_acl,
>  	.fiemap		= ext2_fiemap,
>  };
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 8a33764..1be8866 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1566,7 +1566,7 @@ int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
>  	}
>  	setattr_copy(inode, iattr);
>  	if (iattr->ia_valid & ATTR_MODE)
> -		error = ext2_acl_chmod(inode);
> +		error = posix_acl_chmod(inode);
>  	mark_inode_dirty(inode);
>  
>  	return error;
> diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> index 256dd5f..c268d0a 100644
> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -421,6 +421,7 @@ const struct inode_operations ext2_dir_inode_operations = {
>  #endif
>  	.setattr	= ext2_setattr,
>  	.get_acl	= ext2_get_acl,
> +	.set_acl	= ext2_set_acl,
>  	.tmpfile	= ext2_tmpfile,
>  };
>  
> @@ -433,4 +434,5 @@ const struct inode_operations ext2_special_inode_operations = {
>  #endif
>  	.setattr	= ext2_setattr,
>  	.get_acl	= ext2_get_acl,
> +	.set_acl	= ext2_set_acl,
>  };
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 2d7557d..9142614 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -103,8 +103,8 @@ static struct mb_cache *ext2_xattr_cache;
>  static const struct xattr_handler *ext2_xattr_handler_map[] = {
>  	[EXT2_XATTR_INDEX_USER]		     = &ext2_xattr_user_handler,
>  #ifdef CONFIG_EXT2_FS_POSIX_ACL
> -	[EXT2_XATTR_INDEX_POSIX_ACL_ACCESS]  = &ext2_xattr_acl_access_handler,
> -	[EXT2_XATTR_INDEX_POSIX_ACL_DEFAULT] = &ext2_xattr_acl_default_handler,
> +	[EXT2_XATTR_INDEX_POSIX_ACL_ACCESS]  = &posix_acl_access_xattr_handler,
> +	[EXT2_XATTR_INDEX_POSIX_ACL_DEFAULT] = &posix_acl_default_xattr_handler,
>  #endif
>  	[EXT2_XATTR_INDEX_TRUSTED]	     = &ext2_xattr_trusted_handler,
>  #ifdef CONFIG_EXT2_FS_SECURITY
> @@ -116,8 +116,8 @@ const struct xattr_handler *ext2_xattr_handlers[] = {
>  	&ext2_xattr_user_handler,
>  	&ext2_xattr_trusted_handler,
>  #ifdef CONFIG_EXT2_FS_POSIX_ACL
> -	&ext2_xattr_acl_access_handler,
> -	&ext2_xattr_acl_default_handler,
> +	&posix_acl_access_xattr_handler,
> +	&posix_acl_default_xattr_handler,
>  #endif
>  #ifdef CONFIG_EXT2_FS_SECURITY
>  	&ext2_xattr_security_handler,
> diff --git a/fs/ext2/xattr.h b/fs/ext2/xattr.h
> index 5e41ccc..60edf29 100644
> --- a/fs/ext2/xattr.h
> +++ b/fs/ext2/xattr.h
> @@ -57,8 +57,6 @@ struct ext2_xattr_entry {
>  
>  extern const struct xattr_handler ext2_xattr_user_handler;
>  extern const struct xattr_handler ext2_xattr_trusted_handler;
> -extern const struct xattr_handler ext2_xattr_acl_access_handler;
> -extern const struct xattr_handler ext2_xattr_acl_default_handler;
>  extern const struct xattr_handler ext2_xattr_security_handler;
>  
>  extern ssize_t ext2_listxattr(struct dentry *, char *, size_t);
> diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
> index 4f3d8fa..e9cb33f 100644
> --- a/fs/ext3/acl.c
> +++ b/fs/ext3/acl.c
> @@ -190,7 +190,7 @@ ext3_get_acl(struct inode *inode, int type)
>   * inode->i_mutex: down unless called from ext3_new_inode
>   */
>  static int
> -ext3_set_acl(handle_t *handle, struct inode *inode, int type,
> +__ext3_set_acl(handle_t *handle, struct inode *inode, int type,
>  	     struct posix_acl *acl)
>  {
>  	int name_index;
> @@ -243,204 +243,49 @@ ext3_set_acl(handle_t *handle, struct inode *inode, int type,
>  	return error;
>  }
>  
> -/*
> - * Initialize the ACLs of a new inode. Called from ext3_new_inode.
> - *
> - * dir->i_mutex: down
> - * inode->i_mutex: up (access to inode is still exclusive)
> - */
> -int
> -ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
> -{
> -	struct posix_acl *acl = NULL;
> -	int error = 0;
> -
> -	if (!S_ISLNK(inode->i_mode)) {
> -		if (test_opt(dir->i_sb, POSIX_ACL)) {
> -			acl = ext3_get_acl(dir, ACL_TYPE_DEFAULT);
> -			if (IS_ERR(acl))
> -				return PTR_ERR(acl);
> -		}
> -		if (!acl)
> -			inode->i_mode &= ~current_umask();
> -	}
> -	if (test_opt(inode->i_sb, POSIX_ACL) && acl) {
> -		if (S_ISDIR(inode->i_mode)) {
> -			error = ext3_set_acl(handle, inode,
> -					     ACL_TYPE_DEFAULT, acl);
> -			if (error)
> -				goto cleanup;
> -		}
> -		error = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
> -		if (error < 0)
> -			return error;
> -
> -		if (error > 0) {
> -			/* This is an extended ACL */
> -			error = ext3_set_acl(handle, inode, ACL_TYPE_ACCESS, acl);
> -		}
> -	}
> -cleanup:
> -	posix_acl_release(acl);
> -	return error;
> -}
> -
> -/*
> - * Does chmod for an inode that may have an Access Control List. The
> - * inode->i_mode field must be updated to the desired value by the caller
> - * before calling this function.
> - * Returns 0 on success, or a negative error number.
> - *
> - * We change the ACL rather than storing some ACL entries in the file
> - * mode permission bits (which would be more efficient), because that
> - * would break once additional permissions (like  ACL_APPEND, ACL_DELETE
> - * for directories) are added. There are no more bits available in the
> - * file mode.
> - *
> - * inode->i_mutex: down
> - */
>  int
> -ext3_acl_chmod(struct inode *inode)
> +ext3_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
> -	struct posix_acl *acl;
>  	handle_t *handle;
> -	int retries = 0;
> -        int error;
> +	int error, retries = 0;
>  
> -	if (S_ISLNK(inode->i_mode))
> -		return -EOPNOTSUPP;
> -	if (!test_opt(inode->i_sb, POSIX_ACL))
> -		return 0;
> -	acl = ext3_get_acl(inode, ACL_TYPE_ACCESS);
> -	if (IS_ERR(acl) || !acl)
> -		return PTR_ERR(acl);
> -	error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
> -	if (error)
> -		return error;
>  retry:
> -	handle = ext3_journal_start(inode,
> -			EXT3_DATA_TRANS_BLOCKS(inode->i_sb));
> -	if (IS_ERR(handle)) {
> -		error = PTR_ERR(handle);
> -		ext3_std_error(inode->i_sb, error);
> -		goto out;
> -	}
> -	error = ext3_set_acl(handle, inode, ACL_TYPE_ACCESS, acl);
> +	handle = ext3_journal_start(inode, EXT3_DATA_TRANS_BLOCKS(inode->i_sb));
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +	error = __ext3_set_acl(handle, inode, type, acl);
>  	ext3_journal_stop(handle);
> -	if (error == -ENOSPC &&
> -	    ext3_should_retry_alloc(inode->i_sb, &retries))
> +	if (error == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
>  		goto retry;
> -out:
> -	posix_acl_release(acl);
>  	return error;
>  }
>  
>  /*
> - * Extended attribute handlers
> + * Initialize the ACLs of a new inode. Called from ext3_new_inode.
> + *
> + * dir->i_mutex: down
> + * inode->i_mutex: up (access to inode is still exclusive)
>   */
> -static size_t
> -ext3_xattr_list_acl_access(struct dentry *dentry, char *list, size_t list_len,
> -			   const char *name, size_t name_len, int type)
> -{
> -	const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
> -
> -	if (!test_opt(dentry->d_sb, POSIX_ACL))
> -		return 0;
> -	if (list && size <= list_len)
> -		memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
> -	return size;
> -}
> -
> -static size_t
> -ext3_xattr_list_acl_default(struct dentry *dentry, char *list, size_t list_len,
> -			    const char *name, size_t name_len, int type)
> -{
> -	const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
> -
> -	if (!test_opt(dentry->d_sb, POSIX_ACL))
> -		return 0;
> -	if (list && size <= list_len)
> -		memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
> -	return size;
> -}
> -
> -static int
> -ext3_xattr_get_acl(struct dentry *dentry, const char *name, void *buffer,
> -		   size_t size, int type)
> +int
> +ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
>  {
> -	struct posix_acl *acl;
> +	struct posix_acl *default_acl, *acl;
>  	int error;
>  
> -	if (strcmp(name, "") != 0)
> -		return -EINVAL;
> -	if (!test_opt(dentry->d_sb, POSIX_ACL))
> -		return -EOPNOTSUPP;
> -
> -	acl = ext3_get_acl(dentry->d_inode, type);
> -	if (IS_ERR(acl))
> -		return PTR_ERR(acl);
> -	if (acl == NULL)
> -		return -ENODATA;
> -	error = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
> -	posix_acl_release(acl);
> -
> -	return error;
> -}
> -
> -static int
> -ext3_xattr_set_acl(struct dentry *dentry, const char *name, const void *value,
> -		   size_t size, int flags, int type)
> -{
> -	struct inode *inode = dentry->d_inode;
> -	handle_t *handle;
> -	struct posix_acl *acl;
> -	int error, retries = 0;
> -
> -	if (strcmp(name, "") != 0)
> -		return -EINVAL;
> -	if (!test_opt(inode->i_sb, POSIX_ACL))
> -		return -EOPNOTSUPP;
> -	if (!inode_owner_or_capable(inode))
> -		return -EPERM;
> -
> -	if (value) {
> -		acl = posix_acl_from_xattr(&init_user_ns, value, size);
> -		if (IS_ERR(acl))
> -			return PTR_ERR(acl);
> -		else if (acl) {
> -			error = posix_acl_valid(acl);
> -			if (error)
> -				goto release_and_out;
> -		}
> -	} else
> -		acl = NULL;
> -
> -retry:
> -	handle = ext3_journal_start(inode, EXT3_DATA_TRANS_BLOCKS(inode->i_sb));
> -	if (IS_ERR(handle))
> -		return PTR_ERR(handle);
> -	error = ext3_set_acl(handle, inode, type, acl);
> -	ext3_journal_stop(handle);
> -	if (error == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
> -		goto retry;
> +	error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
> +	if (error)
> +		return error;
>  
> -release_and_out:
> -	posix_acl_release(acl);
> +	if (default_acl) {
> +		error = __ext3_set_acl(handle, inode, ACL_TYPE_DEFAULT,
> +				       default_acl);
> +		posix_acl_release(default_acl);
> +	}
> +	if (acl) {
> +		if (!error)
> +			error = __ext3_set_acl(handle, inode, ACL_TYPE_ACCESS,
> +					       acl);
> +		posix_acl_release(acl);
> +	}
>  	return error;
>  }
> -
> -const struct xattr_handler ext3_xattr_acl_access_handler = {
> -	.prefix	= POSIX_ACL_XATTR_ACCESS,
> -	.flags	= ACL_TYPE_ACCESS,
> -	.list	= ext3_xattr_list_acl_access,
> -	.get	= ext3_xattr_get_acl,
> -	.set	= ext3_xattr_set_acl,
> -};
> -
> -const struct xattr_handler ext3_xattr_acl_default_handler = {
> -	.prefix	= POSIX_ACL_XATTR_DEFAULT,
> -	.flags	= ACL_TYPE_DEFAULT,
> -	.list	= ext3_xattr_list_acl_default,
> -	.get	= ext3_xattr_get_acl,
> -	.set	= ext3_xattr_set_acl,
> -};
> diff --git a/fs/ext3/acl.h b/fs/ext3/acl.h
> index dbc921e..ea1c69e 100644
> --- a/fs/ext3/acl.h
> +++ b/fs/ext3/acl.h
> @@ -55,18 +55,13 @@ static inline int ext3_acl_count(size_t size)
>  
>  /* acl.c */
>  extern struct posix_acl *ext3_get_acl(struct inode *inode, int type);
> -extern int ext3_acl_chmod (struct inode *);
> +extern int ext3_set_acl(struct inode *inode, struct posix_acl *acl, int type);
>  extern int ext3_init_acl (handle_t *, struct inode *, struct inode *);
>  
>  #else  /* CONFIG_EXT3_FS_POSIX_ACL */
>  #include <linux/sched.h>
>  #define ext3_get_acl NULL
> -
> -static inline int
> -ext3_acl_chmod(struct inode *inode)
> -{
> -	return 0;
> -}
> +#define ext3_set_acl NULL
>  
>  static inline int
>  ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
> diff --git a/fs/ext3/file.c b/fs/ext3/file.c
> index 25cb413..aad0531 100644
> --- a/fs/ext3/file.c
> +++ b/fs/ext3/file.c
> @@ -75,6 +75,7 @@ const struct inode_operations ext3_file_inode_operations = {
>  	.removexattr	= generic_removexattr,
>  #endif
>  	.get_acl	= ext3_get_acl,
> +	.set_acl	= ext3_set_acl,
>  	.fiemap		= ext3_fiemap,
>  };
>  
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 2bd8548..150b6c1 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -3365,7 +3365,7 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
>  	mark_inode_dirty(inode);
>  
>  	if (ia_valid & ATTR_MODE)
> -		rc = ext3_acl_chmod(inode);
> +		rc = posix_acl_chmod(inode);
>  
>  err_out:
>  	ext3_std_error(inode->i_sb, error);
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index f8cde46..f197736 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -2569,6 +2569,7 @@ const struct inode_operations ext3_dir_inode_operations = {
>  	.removexattr	= generic_removexattr,
>  #endif
>  	.get_acl	= ext3_get_acl,
> +	.set_acl	= ext3_set_acl,
>  };
>  
>  const struct inode_operations ext3_special_inode_operations = {
> @@ -2580,4 +2581,5 @@ const struct inode_operations ext3_special_inode_operations = {
>  	.removexattr	= generic_removexattr,
>  #endif
>  	.get_acl	= ext3_get_acl,
> +	.set_acl	= ext3_set_acl,
>  };
> diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
> index b1fc963..c6874be 100644
> --- a/fs/ext3/xattr.c
> +++ b/fs/ext3/xattr.c
> @@ -102,8 +102,8 @@ static struct mb_cache *ext3_xattr_cache;
>  static const struct xattr_handler *ext3_xattr_handler_map[] = {
>  	[EXT3_XATTR_INDEX_USER]		     = &ext3_xattr_user_handler,
>  #ifdef CONFIG_EXT3_FS_POSIX_ACL
> -	[EXT3_XATTR_INDEX_POSIX_ACL_ACCESS]  = &ext3_xattr_acl_access_handler,
> -	[EXT3_XATTR_INDEX_POSIX_ACL_DEFAULT] = &ext3_xattr_acl_default_handler,
> +	[EXT3_XATTR_INDEX_POSIX_ACL_ACCESS]  = &posix_acl_access_xattr_handler,
> +	[EXT3_XATTR_INDEX_POSIX_ACL_DEFAULT] = &posix_acl_default_xattr_handler,
>  #endif
>  	[EXT3_XATTR_INDEX_TRUSTED]	     = &ext3_xattr_trusted_handler,
>  #ifdef CONFIG_EXT3_FS_SECURITY
> @@ -115,8 +115,8 @@ const struct xattr_handler *ext3_xattr_handlers[] = {
>  	&ext3_xattr_user_handler,
>  	&ext3_xattr_trusted_handler,
>  #ifdef CONFIG_EXT3_FS_POSIX_ACL
> -	&ext3_xattr_acl_access_handler,
> -	&ext3_xattr_acl_default_handler,
> +	&posix_acl_access_xattr_handler,
> +	&posix_acl_default_xattr_handler,
>  #endif
>  #ifdef CONFIG_EXT3_FS_SECURITY
>  	&ext3_xattr_security_handler,
> diff --git a/fs/ext3/xattr.h b/fs/ext3/xattr.h
> index 2be4f69..32e93eb 100644
> --- a/fs/ext3/xattr.h
> +++ b/fs/ext3/xattr.h
> @@ -60,8 +60,6 @@ struct ext3_xattr_entry {
>  
>  extern const struct xattr_handler ext3_xattr_user_handler;
>  extern const struct xattr_handler ext3_xattr_trusted_handler;
> -extern const struct xattr_handler ext3_xattr_acl_access_handler;
> -extern const struct xattr_handler ext3_xattr_acl_default_handler;
>  extern const struct xattr_handler ext3_xattr_security_handler;
>  
>  extern ssize_t ext3_listxattr(struct dentry *, char *, size_t);
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index f827f3b..acaba0f 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -196,7 +196,7 @@ ext4_get_acl(struct inode *inode, int type)
>   * inode->i_mutex: down unless called from ext4_new_inode
>   */
>  static int
> -ext4_set_acl(handle_t *handle, struct inode *inode, int type,
> +__ext4_set_acl(handle_t *handle, struct inode *inode, int type,
>  	     struct posix_acl *acl)
>  {
>  	int name_index;
> @@ -248,208 +248,51 @@ ext4_set_acl(handle_t *handle, struct inode *inode, int type,
>  	return error;
>  }
>  
> -/*
> - * Initialize the ACLs of a new inode. Called from ext4_new_inode.
> - *
> - * dir->i_mutex: down
> - * inode->i_mutex: up (access to inode is still exclusive)
> - */
> -int
> -ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
> -{
> -	struct posix_acl *acl = NULL;
> -	int error = 0;
> -
> -	if (!S_ISLNK(inode->i_mode)) {
> -		if (test_opt(dir->i_sb, POSIX_ACL)) {
> -			acl = ext4_get_acl(dir, ACL_TYPE_DEFAULT);
> -			if (IS_ERR(acl))
> -				return PTR_ERR(acl);
> -		}
> -		if (!acl)
> -			inode->i_mode &= ~current_umask();
> -	}
> -	if (test_opt(inode->i_sb, POSIX_ACL) && acl) {
> -		if (S_ISDIR(inode->i_mode)) {
> -			error = ext4_set_acl(handle, inode,
> -					     ACL_TYPE_DEFAULT, acl);
> -			if (error)
> -				goto cleanup;
> -		}
> -		error = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
> -		if (error < 0)
> -			return error;
> -
> -		if (error > 0) {
> -			/* This is an extended ACL */
> -			error = ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, acl);
> -		}
> -	}
> -cleanup:
> -	posix_acl_release(acl);
> -	return error;
> -}
> -
> -/*
> - * Does chmod for an inode that may have an Access Control List. The
> - * inode->i_mode field must be updated to the desired value by the caller
> - * before calling this function.
> - * Returns 0 on success, or a negative error number.
> - *
> - * We change the ACL rather than storing some ACL entries in the file
> - * mode permission bits (which would be more efficient), because that
> - * would break once additional permissions (like  ACL_APPEND, ACL_DELETE
> - * for directories) are added. There are no more bits available in the
> - * file mode.
> - *
> - * inode->i_mutex: down
> - */
>  int
> -ext4_acl_chmod(struct inode *inode)
> +ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
> -	struct posix_acl *acl;
>  	handle_t *handle;
> -	int retries = 0;
> -	int error;
> -
> +	int error, retries = 0;
>  
> -	if (S_ISLNK(inode->i_mode))
> -		return -EOPNOTSUPP;
> -	if (!test_opt(inode->i_sb, POSIX_ACL))
> -		return 0;
> -	acl = ext4_get_acl(inode, ACL_TYPE_ACCESS);
> -	if (IS_ERR(acl) || !acl)
> -		return PTR_ERR(acl);
> -	error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
> -	if (error)
> -		return error;
>  retry:
>  	handle = ext4_journal_start(inode, EXT4_HT_XATTR,
>  				    ext4_jbd2_credits_xattr(inode));
> -	if (IS_ERR(handle)) {
> -		error = PTR_ERR(handle);
> -		ext4_std_error(inode->i_sb, error);
> -		goto out;
> -	}
> -	error = ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, acl);
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +
> +	error = __ext4_set_acl(handle, inode, type, acl);
>  	ext4_journal_stop(handle);
> -	if (error == -ENOSPC &&
> -	    ext4_should_retry_alloc(inode->i_sb, &retries))
> +	if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>  		goto retry;
> -out:
> -	posix_acl_release(acl);
>  	return error;
>  }
>  
>  /*
> - * Extended attribute handlers
> + * Initialize the ACLs of a new inode. Called from ext4_new_inode.
> + *
> + * dir->i_mutex: down
> + * inode->i_mutex: up (access to inode is still exclusive)
>   */
> -static size_t
> -ext4_xattr_list_acl_access(struct dentry *dentry, char *list, size_t list_len,
> -			   const char *name, size_t name_len, int type)
> -{
> -	const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
> -
> -	if (!test_opt(dentry->d_sb, POSIX_ACL))
> -		return 0;
> -	if (list && size <= list_len)
> -		memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
> -	return size;
> -}
> -
> -static size_t
> -ext4_xattr_list_acl_default(struct dentry *dentry, char *list, size_t list_len,
> -			    const char *name, size_t name_len, int type)
> -{
> -	const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
> -
> -	if (!test_opt(dentry->d_sb, POSIX_ACL))
> -		return 0;
> -	if (list && size <= list_len)
> -		memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
> -	return size;
> -}
> -
> -static int
> -ext4_xattr_get_acl(struct dentry *dentry, const char *name, void *buffer,
> -		   size_t size, int type)
> +int
> +ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
>  {
> -	struct posix_acl *acl;
> +	struct posix_acl *default_acl, *acl;
>  	int error;
>  
> -	if (strcmp(name, "") != 0)
> -		return -EINVAL;
> -	if (!test_opt(dentry->d_sb, POSIX_ACL))
> -		return -EOPNOTSUPP;
> -
> -	acl = ext4_get_acl(dentry->d_inode, type);
> -	if (IS_ERR(acl))
> -		return PTR_ERR(acl);
> -	if (acl == NULL)
> -		return -ENODATA;
> -	error = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
> -	posix_acl_release(acl);
> -
> -	return error;
> -}
> -
> -static int
> -ext4_xattr_set_acl(struct dentry *dentry, const char *name, const void *value,
> -		   size_t size, int flags, int type)
> -{
> -	struct inode *inode = dentry->d_inode;
> -	handle_t *handle;
> -	struct posix_acl *acl;
> -	int error, retries = 0;
> -
> -	if (strcmp(name, "") != 0)
> -		return -EINVAL;
> -	if (!test_opt(inode->i_sb, POSIX_ACL))
> -		return -EOPNOTSUPP;
> -	if (!inode_owner_or_capable(inode))
> -		return -EPERM;
> -
> -	if (value) {
> -		acl = posix_acl_from_xattr(&init_user_ns, value, size);
> -		if (IS_ERR(acl))
> -			return PTR_ERR(acl);
> -		else if (acl) {
> -			error = posix_acl_valid(acl);
> -			if (error)
> -				goto release_and_out;
> -		}
> -	} else
> -		acl = NULL;
> +	error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
> +	if (error)
> +		return error;
>  
> -retry:
> -	handle = ext4_journal_start(inode, EXT4_HT_XATTR,
> -				    ext4_jbd2_credits_xattr(inode));
> -	if (IS_ERR(handle)) {
> -		error = PTR_ERR(handle);
> -		goto release_and_out;
> +	if (default_acl) {
> +		error = __ext4_set_acl(handle, inode, ACL_TYPE_DEFAULT,
> +				       default_acl);
> +		posix_acl_release(default_acl);
> +	}
> +	if (acl) {
> +		if (!error)
> +			error = __ext4_set_acl(handle, inode, ACL_TYPE_ACCESS,
> +					       acl);
> +		posix_acl_release(acl);
>  	}
> -	error = ext4_set_acl(handle, inode, type, acl);
> -	ext4_journal_stop(handle);
> -	if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> -		goto retry;
> -
> -release_and_out:
> -	posix_acl_release(acl);
>  	return error;
>  }
> -
> -const struct xattr_handler ext4_xattr_acl_access_handler = {
> -	.prefix	= POSIX_ACL_XATTR_ACCESS,
> -	.flags	= ACL_TYPE_ACCESS,
> -	.list	= ext4_xattr_list_acl_access,
> -	.get	= ext4_xattr_get_acl,
> -	.set	= ext4_xattr_set_acl,
> -};
> -
> -const struct xattr_handler ext4_xattr_acl_default_handler = {
> -	.prefix	= POSIX_ACL_XATTR_DEFAULT,
> -	.flags	= ACL_TYPE_DEFAULT,
> -	.list	= ext4_xattr_list_acl_default,
> -	.get	= ext4_xattr_get_acl,
> -	.set	= ext4_xattr_set_acl,
> -};
> diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
> index 18cb39e..da2c795 100644
> --- a/fs/ext4/acl.h
> +++ b/fs/ext4/acl.h
> @@ -55,18 +55,13 @@ static inline int ext4_acl_count(size_t size)
>  
>  /* acl.c */
>  struct posix_acl *ext4_get_acl(struct inode *inode, int type);
> -extern int ext4_acl_chmod(struct inode *);
> +int ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type);
>  extern int ext4_init_acl(handle_t *, struct inode *, struct inode *);
>  
>  #else  /* CONFIG_EXT4_FS_POSIX_ACL */
>  #include <linux/sched.h>
>  #define ext4_get_acl NULL
> -
> -static inline int
> -ext4_acl_chmod(struct inode *inode)
> -{
> -	return 0;
> -}
> +#define ext4_set_acl NULL
>  
>  static inline int
>  ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 3da2194..43e64f6 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -617,6 +617,7 @@ const struct inode_operations ext4_file_inode_operations = {
>  	.listxattr	= ext4_listxattr,
>  	.removexattr	= generic_removexattr,
>  	.get_acl	= ext4_get_acl,
> +	.set_acl	= ext4_set_acl,
>  	.fiemap		= ext4_fiemap,
>  };
>  
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0757634..6f69f96 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4675,7 +4675,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  		ext4_orphan_del(NULL, inode);
>  
>  	if (!rc && (ia_valid & ATTR_MODE))
> -		rc = ext4_acl_chmod(inode);
> +		rc = posix_acl_chmod(inode);
>  
>  err_out:
>  	ext4_std_error(inode->i_sb, error);
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 5a0408d..e77c1ba 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3225,6 +3225,7 @@ const struct inode_operations ext4_dir_inode_operations = {
>  	.listxattr	= ext4_listxattr,
>  	.removexattr	= generic_removexattr,
>  	.get_acl	= ext4_get_acl,
> +	.set_acl	= ext4_set_acl,
>  	.fiemap         = ext4_fiemap,
>  };
>  
> @@ -3235,4 +3236,5 @@ const struct inode_operations ext4_special_inode_operations = {
>  	.listxattr	= ext4_listxattr,
>  	.removexattr	= generic_removexattr,
>  	.get_acl	= ext4_get_acl,
> +	.set_acl	= ext4_set_acl,
>  };
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 1423c48..e175e94 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -95,8 +95,8 @@ static struct mb_cache *ext4_xattr_cache;
>  static const struct xattr_handler *ext4_xattr_handler_map[] = {
>  	[EXT4_XATTR_INDEX_USER]		     = &ext4_xattr_user_handler,
>  #ifdef CONFIG_EXT4_FS_POSIX_ACL
> -	[EXT4_XATTR_INDEX_POSIX_ACL_ACCESS]  = &ext4_xattr_acl_access_handler,
> -	[EXT4_XATTR_INDEX_POSIX_ACL_DEFAULT] = &ext4_xattr_acl_default_handler,
> +	[EXT4_XATTR_INDEX_POSIX_ACL_ACCESS]  = &posix_acl_access_xattr_handler,
> +	[EXT4_XATTR_INDEX_POSIX_ACL_DEFAULT] = &posix_acl_default_xattr_handler,
>  #endif
>  	[EXT4_XATTR_INDEX_TRUSTED]	     = &ext4_xattr_trusted_handler,
>  #ifdef CONFIG_EXT4_FS_SECURITY
> @@ -108,8 +108,8 @@ const struct xattr_handler *ext4_xattr_handlers[] = {
>  	&ext4_xattr_user_handler,
>  	&ext4_xattr_trusted_handler,
>  #ifdef CONFIG_EXT4_FS_POSIX_ACL
> -	&ext4_xattr_acl_access_handler,
> -	&ext4_xattr_acl_default_handler,
> +	&posix_acl_access_xattr_handler,
> +	&posix_acl_default_xattr_handler,
>  #endif
>  #ifdef CONFIG_EXT4_FS_SECURITY
>  	&ext4_xattr_security_handler,
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index c767dbd..819d639 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -96,8 +96,6 @@ struct ext4_xattr_ibody_find {
>  
>  extern const struct xattr_handler ext4_xattr_user_handler;
>  extern const struct xattr_handler ext4_xattr_trusted_handler;
> -extern const struct xattr_handler ext4_xattr_acl_access_handler;
> -extern const struct xattr_handler ext4_xattr_acl_default_handler;
>  extern const struct xattr_handler ext4_xattr_security_handler;
>  
>  extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
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

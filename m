Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 36AB97F57
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 16:18:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 219E08F8040
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 14:18:59 -0800 (PST)
Received: from mail-pd0-f172.google.com (mail-pd0-f172.google.com
	[209.85.192.172]) by cuda.sgi.com with ESMTP id
	8qV5FmACdqVbVdZ7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 14:18:54 -0800 (PST)
Received: by mail-pd0-f172.google.com with SMTP id g10so19063846pdj.17
	for <xfs@oss.sgi.com>; Mon, 02 Dec 2013 14:18:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131202221339.GI12253@quack.suse.cz>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120655.018342089@bombadil.infradead.org>
	<20131202221339.GI12253@quack.suse.cz>
Date: Mon, 2 Dec 2013 14:18:53 -0800
Message-ID: <CAMBnPoAR0dYoVHffR85G199oTWff+OZm_hcZ0wh7LL2Wvugjcg@mail.gmail.com>
Subject: Re: [Jfs-discussion] [PATCH 08/18] ext2/3/4: use generic posix ACL
	infrastructure
From: gary sheppard <rhyotte@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8073369636330785012=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig <hch@infradead.org>, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

--===============8073369636330785012==
Content-Type: multipart/alternative; boundary=047d7b6d9b16abcffb04ec9490ed

--047d7b6d9b16abcffb04ec9490ed
Content-Type: text/plain; charset=ISO-8859-1

Really nice to see all the sudden activity here in JFS again!


On Mon, Dec 2, 2013 at 2:13 PM, Jan Kara <jack@suse.cz> wrote:

> On Sun 01-12-13 03:59:11, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
>   Looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>
>
>                                                         Honza
>
> > ---
> >  fs/ext2/acl.c   |  176 ++++-----------------------------------------
> >  fs/ext2/acl.h   |    8 +--
> >  fs/ext2/file.c  |    1 +
> >  fs/ext2/inode.c |    2 +-
> >  fs/ext2/namei.c |    2 +
> >  fs/ext2/xattr.c |    8 +--
> >  fs/ext2/xattr.h |    2 -
> >  fs/ext3/acl.c   |  213
> ++++++++-----------------------------------------------
> >  fs/ext3/acl.h   |    9 +--
> >  fs/ext3/file.c  |    1 +
> >  fs/ext3/inode.c |    2 +-
> >  fs/ext3/namei.c |    2 +
> >  fs/ext3/xattr.c |    8 +--
> >  fs/ext3/xattr.h |    2 -
> >  fs/ext4/acl.c   |  213
> ++++++++-----------------------------------------------
> >  fs/ext4/acl.h   |    9 +--
> >  fs/ext4/file.c  |    1 +
> >  fs/ext4/inode.c |    2 +-
> >  fs/ext4/namei.c |    2 +
> >  fs/ext4/xattr.c |    8 +--
> >  fs/ext4/xattr.h |    2 -
> >  21 files changed, 100 insertions(+), 573 deletions(-)
> >
> > diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
> > index 6e842a7..f04a295 100644
> > --- a/fs/ext2/acl.c
> > +++ b/fs/ext2/acl.c
> > @@ -189,8 +189,8 @@ ext2_get_acl(struct inode *inode, int type)
> >  /*
> >   * inode->i_mutex: down
> >   */
> > -static int
> > -ext2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
> > +int
> > +ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> >  {
> >       int name_index;
> >       void *value = NULL;
> > @@ -250,169 +250,21 @@ ext2_set_acl(struct inode *inode, int type,
> struct posix_acl *acl)
> >  int
> >  ext2_init_acl(struct inode *inode, struct inode *dir)
> >  {
> > -     struct posix_acl *acl = NULL;
> > -     int error = 0;
> > -
> > -     if (!S_ISLNK(inode->i_mode)) {
> > -             if (test_opt(dir->i_sb, POSIX_ACL)) {
> > -                     acl = ext2_get_acl(dir, ACL_TYPE_DEFAULT);
> > -                     if (IS_ERR(acl))
> > -                             return PTR_ERR(acl);
> > -             }
> > -             if (!acl)
> > -                     inode->i_mode &= ~current_umask();
> > -     }
> > -     if (test_opt(inode->i_sb, POSIX_ACL) && acl) {
> > -             if (S_ISDIR(inode->i_mode)) {
> > -                     error = ext2_set_acl(inode, ACL_TYPE_DEFAULT, acl);
> > -                     if (error)
> > -                             goto cleanup;
> > -             }
> > -             error = __posix_acl_create(&acl, GFP_KERNEL,
> &inode->i_mode);
> > -             if (error < 0)
> > -                     return error;
> > -             if (error > 0) {
> > -                     /* This is an extended ACL */
> > -                     error = ext2_set_acl(inode, ACL_TYPE_ACCESS, acl);
> > -             }
> > -     }
> > -cleanup:
> > -       posix_acl_release(acl);
> > -       return error;
> > -}
> > -
> > -/*
> > - * Does chmod for an inode that may have an Access Control List. The
> > - * inode->i_mode field must be updated to the desired value by the
> caller
> > - * before calling this function.
> > - * Returns 0 on success, or a negative error number.
> > - *
> > - * We change the ACL rather than storing some ACL entries in the file
> > - * mode permission bits (which would be more efficient), because that
> > - * would break once additional permissions (like  ACL_APPEND, ACL_DELETE
> > - * for directories) are added. There are no more bits available in the
> > - * file mode.
> > - *
> > - * inode->i_mutex: down
> > - */
> > -int
> > -ext2_acl_chmod(struct inode *inode)
> > -{
> > -     struct posix_acl *acl;
> > -        int error;
> > +     struct posix_acl *default_acl, *acl;
> > +     int error;
> >
> > -     if (!test_opt(inode->i_sb, POSIX_ACL))
> > -             return 0;
> > -     if (S_ISLNK(inode->i_mode))
> > -             return -EOPNOTSUPP;
> > -     acl = ext2_get_acl(inode, ACL_TYPE_ACCESS);
> > -     if (IS_ERR(acl) || !acl)
> > -             return PTR_ERR(acl);
> > -     error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
> > +     error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
> >       if (error)
> >               return error;
> > -     error = ext2_set_acl(inode, ACL_TYPE_ACCESS, acl);
> > -     posix_acl_release(acl);
> > -     return error;
> > -}
> > -
> > -/*
> > - * Extended attribut handlers
> > - */
> > -static size_t
> > -ext2_xattr_list_acl_access(struct dentry *dentry, char *list, size_t
> list_size,
> > -                        const char *name, size_t name_len, int type)
> > -{
> > -     const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
> > -
> > -     if (!test_opt(dentry->d_sb, POSIX_ACL))
> > -             return 0;
> > -     if (list && size <= list_size)
> > -             memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
> > -     return size;
> > -}
> >
> > -static size_t
> > -ext2_xattr_list_acl_default(struct dentry *dentry, char *list, size_t
> list_size,
> > -                         const char *name, size_t name_len, int type)
> > -{
> > -     const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
> > -
> > -     if (!test_opt(dentry->d_sb, POSIX_ACL))
> > -             return 0;
> > -     if (list && size <= list_size)
> > -             memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
> > -     return size;
> > -}
> > -
> > -static int
> > -ext2_xattr_get_acl(struct dentry *dentry, const char *name, void
> *buffer,
> > -                size_t size, int type)
> > -{
> > -     struct posix_acl *acl;
> > -     int error;
> > -
> > -     if (strcmp(name, "") != 0)
> > -             return -EINVAL;
> > -     if (!test_opt(dentry->d_sb, POSIX_ACL))
> > -             return -EOPNOTSUPP;
> > -
> > -     acl = ext2_get_acl(dentry->d_inode, type);
> > -     if (IS_ERR(acl))
> > -             return PTR_ERR(acl);
> > -     if (acl == NULL)
> > -             return -ENODATA;
> > -     error = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
> > -     posix_acl_release(acl);
> > -
> > -     return error;
> > -}
> > -
> > -static int
> > -ext2_xattr_set_acl(struct dentry *dentry, const char *name, const void
> *value,
> > -                size_t size, int flags, int type)
> > -{
> > -     struct posix_acl *acl;
> > -     int error;
> > -
> > -     if (strcmp(name, "") != 0)
> > -             return -EINVAL;
> > -     if (!test_opt(dentry->d_sb, POSIX_ACL))
> > -             return -EOPNOTSUPP;
> > -     if (!inode_owner_or_capable(dentry->d_inode))
> > -             return -EPERM;
> > -
> > -     if (value) {
> > -             acl = posix_acl_from_xattr(&init_user_ns, value, size);
> > -             if (IS_ERR(acl))
> > -                     return PTR_ERR(acl);
> > -             else if (acl) {
> > -                     error = posix_acl_valid(acl);
> > -                     if (error)
> > -                             goto release_and_out;
> > -             }
> > -     } else
> > -             acl = NULL;
> > -
> > -     error = ext2_set_acl(dentry->d_inode, type, acl);
> > -
> > -release_and_out:
> > -     posix_acl_release(acl);
> > +     if (default_acl) {
> > +             error = ext2_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
> > +             posix_acl_release(default_acl);
> > +     }
> > +     if (acl) {
> > +             if (!error)
> > +                     error = ext2_set_acl(inode, acl, ACL_TYPE_ACCESS);
> > +             posix_acl_release(acl);
> > +     }
> >       return error;
> >  }
> > -
> > -const struct xattr_handler ext2_xattr_acl_access_handler = {
> > -     .prefix = POSIX_ACL_XATTR_ACCESS,
> > -     .flags  = ACL_TYPE_ACCESS,
> > -     .list   = ext2_xattr_list_acl_access,
> > -     .get    = ext2_xattr_get_acl,
> > -     .set    = ext2_xattr_set_acl,
> > -};
> > -
> > -const struct xattr_handler ext2_xattr_acl_default_handler = {
> > -     .prefix = POSIX_ACL_XATTR_DEFAULT,
> > -     .flags  = ACL_TYPE_DEFAULT,
> > -     .list   = ext2_xattr_list_acl_default,
> > -     .get    = ext2_xattr_get_acl,
> > -     .set    = ext2_xattr_set_acl,
> > -};
> > diff --git a/fs/ext2/acl.h b/fs/ext2/acl.h
> > index 503bfb0..44937f9 100644
> > --- a/fs/ext2/acl.h
> > +++ b/fs/ext2/acl.h
> > @@ -55,7 +55,7 @@ static inline int ext2_acl_count(size_t size)
> >
> >  /* acl.c */
> >  extern struct posix_acl *ext2_get_acl(struct inode *inode, int type);
> > -extern int ext2_acl_chmod (struct inode *);
> > +extern int ext2_set_acl(struct inode *inode, struct posix_acl *acl, int
> type);
> >  extern int ext2_init_acl (struct inode *, struct inode *);
> >
> >  #else
> > @@ -63,12 +63,6 @@ extern int ext2_init_acl (struct inode *, struct
> inode *);
> >  #define ext2_get_acl NULL
> >  #define ext2_set_acl NULL
> >
> > -static inline int
> > -ext2_acl_chmod (struct inode *inode)
> > -{
> > -     return 0;
> > -}
> > -
> >  static inline int ext2_init_acl (struct inode *inode, struct inode *dir)
> >  {
> >       return 0;
> > diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> > index a5b3a5d..44c36e5 100644
> > --- a/fs/ext2/file.c
> > +++ b/fs/ext2/file.c
> > @@ -103,5 +103,6 @@ const struct inode_operations
> ext2_file_inode_operations = {
> >  #endif
> >       .setattr        = ext2_setattr,
> >       .get_acl        = ext2_get_acl,
> > +     .set_acl        = ext2_set_acl,
> >       .fiemap         = ext2_fiemap,
> >  };
> > diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> > index 8a33764..1be8866 100644
> > --- a/fs/ext2/inode.c
> > +++ b/fs/ext2/inode.c
> > @@ -1566,7 +1566,7 @@ int ext2_setattr(struct dentry *dentry, struct
> iattr *iattr)
> >       }
> >       setattr_copy(inode, iattr);
> >       if (iattr->ia_valid & ATTR_MODE)
> > -             error = ext2_acl_chmod(inode);
> > +             error = posix_acl_chmod(inode);
> >       mark_inode_dirty(inode);
> >
> >       return error;
> > diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> > index 256dd5f..c268d0a 100644
> > --- a/fs/ext2/namei.c
> > +++ b/fs/ext2/namei.c
> > @@ -421,6 +421,7 @@ const struct inode_operations
> ext2_dir_inode_operations = {
> >  #endif
> >       .setattr        = ext2_setattr,
> >       .get_acl        = ext2_get_acl,
> > +     .set_acl        = ext2_set_acl,
> >       .tmpfile        = ext2_tmpfile,
> >  };
> >
> > @@ -433,4 +434,5 @@ const struct inode_operations
> ext2_special_inode_operations = {
> >  #endif
> >       .setattr        = ext2_setattr,
> >       .get_acl        = ext2_get_acl,
> > +     .set_acl        = ext2_set_acl,
> >  };
> > diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> > index 2d7557d..9142614 100644
> > --- a/fs/ext2/xattr.c
> > +++ b/fs/ext2/xattr.c
> > @@ -103,8 +103,8 @@ static struct mb_cache *ext2_xattr_cache;
> >  static const struct xattr_handler *ext2_xattr_handler_map[] = {
> >       [EXT2_XATTR_INDEX_USER]              = &ext2_xattr_user_handler,
> >  #ifdef CONFIG_EXT2_FS_POSIX_ACL
> > -     [EXT2_XATTR_INDEX_POSIX_ACL_ACCESS]  =
> &ext2_xattr_acl_access_handler,
> > -     [EXT2_XATTR_INDEX_POSIX_ACL_DEFAULT] =
> &ext2_xattr_acl_default_handler,
> > +     [EXT2_XATTR_INDEX_POSIX_ACL_ACCESS]  =
> &posix_acl_access_xattr_handler,
> > +     [EXT2_XATTR_INDEX_POSIX_ACL_DEFAULT] =
> &posix_acl_default_xattr_handler,
> >  #endif
> >       [EXT2_XATTR_INDEX_TRUSTED]           = &ext2_xattr_trusted_handler,
> >  #ifdef CONFIG_EXT2_FS_SECURITY
> > @@ -116,8 +116,8 @@ const struct xattr_handler *ext2_xattr_handlers[] = {
> >       &ext2_xattr_user_handler,
> >       &ext2_xattr_trusted_handler,
> >  #ifdef CONFIG_EXT2_FS_POSIX_ACL
> > -     &ext2_xattr_acl_access_handler,
> > -     &ext2_xattr_acl_default_handler,
> > +     &posix_acl_access_xattr_handler,
> > +     &posix_acl_default_xattr_handler,
> >  #endif
> >  #ifdef CONFIG_EXT2_FS_SECURITY
> >       &ext2_xattr_security_handler,
> > diff --git a/fs/ext2/xattr.h b/fs/ext2/xattr.h
> > index 5e41ccc..60edf29 100644
> > --- a/fs/ext2/xattr.h
> > +++ b/fs/ext2/xattr.h
> > @@ -57,8 +57,6 @@ struct ext2_xattr_entry {
> >
> >  extern const struct xattr_handler ext2_xattr_user_handler;
> >  extern const struct xattr_handler ext2_xattr_trusted_handler;
> > -extern const struct xattr_handler ext2_xattr_acl_access_handler;
> > -extern const struct xattr_handler ext2_xattr_acl_default_handler;
> >  extern const struct xattr_handler ext2_xattr_security_handler;
> >
> >  extern ssize_t ext2_listxattr(struct dentry *, char *, size_t);
> > diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
> > index 4f3d8fa..e9cb33f 100644
> > --- a/fs/ext3/acl.c
> > +++ b/fs/ext3/acl.c
> > @@ -190,7 +190,7 @@ ext3_get_acl(struct inode *inode, int type)
> >   * inode->i_mutex: down unless called from ext3_new_inode
> >   */
> >  static int
> > -ext3_set_acl(handle_t *handle, struct inode *inode, int type,
> > +__ext3_set_acl(handle_t *handle, struct inode *inode, int type,
> >            struct posix_acl *acl)
> >  {
> >       int name_index;
> > @@ -243,204 +243,49 @@ ext3_set_acl(handle_t *handle, struct inode
> *inode, int type,
> >       return error;
> >  }
> >
> > -/*
> > - * Initialize the ACLs of a new inode. Called from ext3_new_inode.
> > - *
> > - * dir->i_mutex: down
> > - * inode->i_mutex: up (access to inode is still exclusive)
> > - */
> > -int
> > -ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
> > -{
> > -     struct posix_acl *acl = NULL;
> > -     int error = 0;
> > -
> > -     if (!S_ISLNK(inode->i_mode)) {
> > -             if (test_opt(dir->i_sb, POSIX_ACL)) {
> > -                     acl = ext3_get_acl(dir, ACL_TYPE_DEFAULT);
> > -                     if (IS_ERR(acl))
> > -                             return PTR_ERR(acl);
> > -             }
> > -             if (!acl)
> > -                     inode->i_mode &= ~current_umask();
> > -     }
> > -     if (test_opt(inode->i_sb, POSIX_ACL) && acl) {
> > -             if (S_ISDIR(inode->i_mode)) {
> > -                     error = ext3_set_acl(handle, inode,
> > -                                          ACL_TYPE_DEFAULT, acl);
> > -                     if (error)
> > -                             goto cleanup;
> > -             }
> > -             error = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
> > -             if (error < 0)
> > -                     return error;
> > -
> > -             if (error > 0) {
> > -                     /* This is an extended ACL */
> > -                     error = ext3_set_acl(handle, inode,
> ACL_TYPE_ACCESS, acl);
> > -             }
> > -     }
> > -cleanup:
> > -     posix_acl_release(acl);
> > -     return error;
> > -}
> > -
> > -/*
> > - * Does chmod for an inode that may have an Access Control List. The
> > - * inode->i_mode field must be updated to the desired value by the
> caller
> > - * before calling this function.
> > - * Returns 0 on success, or a negative error number.
> > - *
> > - * We change the ACL rather than storing some ACL entries in the file
> > - * mode permission bits (which would be more efficient), because that
> > - * would break once additional permissions (like  ACL_APPEND, ACL_DELETE
> > - * for directories) are added. There are no more bits available in the
> > - * file mode.
> > - *
> > - * inode->i_mutex: down
> > - */
> >  int
> > -ext3_acl_chmod(struct inode *inode)
> > +ext3_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> >  {
> > -     struct posix_acl *acl;
> >       handle_t *handle;
> > -     int retries = 0;
> > -        int error;
> > +     int error, retries = 0;
> >
> > -     if (S_ISLNK(inode->i_mode))
> > -             return -EOPNOTSUPP;
> > -     if (!test_opt(inode->i_sb, POSIX_ACL))
> > -             return 0;
> > -     acl = ext3_get_acl(inode, ACL_TYPE_ACCESS);
> > -     if (IS_ERR(acl) || !acl)
> > -             return PTR_ERR(acl);
> > -     error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
> > -     if (error)
> > -             return error;
> >  retry:
> > -     handle = ext3_journal_start(inode,
> > -                     EXT3_DATA_TRANS_BLOCKS(inode->i_sb));
> > -     if (IS_ERR(handle)) {
> > -             error = PTR_ERR(handle);
> > -             ext3_std_error(inode->i_sb, error);
> > -             goto out;
> > -     }
> > -     error = ext3_set_acl(handle, inode, ACL_TYPE_ACCESS, acl);
> > +     handle = ext3_journal_start(inode,
> EXT3_DATA_TRANS_BLOCKS(inode->i_sb));
> > +     if (IS_ERR(handle))
> > +             return PTR_ERR(handle);
> > +     error = __ext3_set_acl(handle, inode, type, acl);
> >       ext3_journal_stop(handle);
> > -     if (error == -ENOSPC &&
> > -         ext3_should_retry_alloc(inode->i_sb, &retries))
> > +     if (error == -ENOSPC && ext3_should_retry_alloc(inode->i_sb,
> &retries))
> >               goto retry;
> > -out:
> > -     posix_acl_release(acl);
> >       return error;
> >  }
> >
> >  /*
> > - * Extended attribute handlers
> > + * Initialize the ACLs of a new inode. Called from ext3_new_inode.
> > + *
> > + * dir->i_mutex: down
> > + * inode->i_mutex: up (access to inode is still exclusive)
> >   */
> > -static size_t
> > -ext3_xattr_list_acl_access(struct dentry *dentry, char *list, size_t
> list_len,
> > -                        const char *name, size_t name_len, int type)
> > -{
> > -     const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
> > -
> > -     if (!test_opt(dentry->d_sb, POSIX_ACL))
> > -             return 0;
> > -     if (list && size <= list_len)
> > -             memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
> > -     return size;
> > -}
> > -
> > -static size_t
> > -ext3_xattr_list_acl_default(struct dentry *dentry, char *list, size_t
> list_len,
> > -                         const char *name, size_t name_len, int type)
> > -{
> > -     const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
> > -
> > -     if (!test_opt(dentry->d_sb, POSIX_ACL))
> > -             return 0;
> > -     if (list && size <= list_len)
> > -             memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
> > -     return size;
> > -}
> > -
> > -static int
> > -ext3_xattr_get_acl(struct dentry *dentry, const char *name, void
> *buffer,
> > -                size_t size, int type)
> > +int
> > +ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
> >  {
> > -     struct posix_acl *acl;
> > +     struct posix_acl *default_acl, *acl;
> >       int error;
> >
> > -     if (strcmp(name, "") != 0)
> > -             return -EINVAL;
> > -     if (!test_opt(dentry->d_sb, POSIX_ACL))
> > -             return -EOPNOTSUPP;
> > -
> > -     acl = ext3_get_acl(dentry->d_inode, type);
> > -     if (IS_ERR(acl))
> > -             return PTR_ERR(acl);
> > -     if (acl == NULL)
> > -             return -ENODATA;
> > -     error = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
> > -     posix_acl_release(acl);
> > -
> > -     return error;
> > -}
> > -
> > -static int
> > -ext3_xattr_set_acl(struct dentry *dentry, const char *name, const void
> *value,
> > -                size_t size, int flags, int type)
> > -{
> > -     struct inode *inode = dentry->d_inode;
> > -     handle_t *handle;
> > -     struct posix_acl *acl;
> > -     int error, retries = 0;
> > -
> > -     if (strcmp(name, "") != 0)
> > -             return -EINVAL;
> > -     if (!test_opt(inode->i_sb, POSIX_ACL))
> > -             return -EOPNOTSUPP;
> > -     if (!inode_owner_or_capable(inode))
> > -             return -EPERM;
> > -
> > -     if (value) {
> > -             acl = posix_acl_from_xattr(&init_user_ns, value, size);
> > -             if (IS_ERR(acl))
> > -                     return PTR_ERR(acl);
> > -             else if (acl) {
> > -                     error = posix_acl_valid(acl);
> > -                     if (error)
> > -                             goto release_and_out;
> > -             }
> > -     } else
> > -             acl = NULL;
> > -
> > -retry:
> > -     handle = ext3_journal_start(inode,
> EXT3_DATA_TRANS_BLOCKS(inode->i_sb));
> > -     if (IS_ERR(handle))
> > -             return PTR_ERR(handle);
> > -     error = ext3_set_acl(handle, inode, type, acl);
> > -     ext3_journal_stop(handle);
> > -     if (error == -ENOSPC && ext3_should_retry_alloc(inode->i_sb,
> &retries))
> > -             goto retry;
> > +     error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
> > +     if (error)
> > +             return error;
> >
> > -release_and_out:
> > -     posix_acl_release(acl);
> > +     if (default_acl) {
> > +             error = __ext3_set_acl(handle, inode, ACL_TYPE_DEFAULT,
> > +                                    default_acl);
> > +             posix_acl_release(default_acl);
> > +     }
> > +     if (acl) {
> > +             if (!error)
> > +                     error = __ext3_set_acl(handle, inode,
> ACL_TYPE_ACCESS,
> > +                                            acl);
> > +             posix_acl_release(acl);
> > +     }
> >       return error;
> >  }
> > -
> > -const struct xattr_handler ext3_xattr_acl_access_handler = {
> > -     .prefix = POSIX_ACL_XATTR_ACCESS,
> > -     .flags  = ACL_TYPE_ACCESS,
> > -     .list   = ext3_xattr_list_acl_access,
> > -     .get    = ext3_xattr_get_acl,
> > -     .set    = ext3_xattr_set_acl,
> > -};
> > -
> > -const struct xattr_handler ext3_xattr_acl_default_handler = {
> > -     .prefix = POSIX_ACL_XATTR_DEFAULT,
> > -     .flags  = ACL_TYPE_DEFAULT,
> > -     .list   = ext3_xattr_list_acl_default,
> > -     .get    = ext3_xattr_get_acl,
> > -     .set    = ext3_xattr_set_acl,
> > -};
> > diff --git a/fs/ext3/acl.h b/fs/ext3/acl.h
> > index dbc921e..ea1c69e 100644
> > --- a/fs/ext3/acl.h
> > +++ b/fs/ext3/acl.h
> > @@ -55,18 +55,13 @@ static inline int ext3_acl_count(size_t size)
> >
> >  /* acl.c */
> >  extern struct posix_acl *ext3_get_acl(struct inode *inode, int type);
> > -extern int ext3_acl_chmod (struct inode *);
> > +extern int ext3_set_acl(struct inode *inode, struct posix_acl *acl, int
> type);
> >  extern int ext3_init_acl (handle_t *, struct inode *, struct inode *);
> >
> >  #else  /* CONFIG_EXT3_FS_POSIX_ACL */
> >  #include <linux/sched.h>
> >  #define ext3_get_acl NULL
> > -
> > -static inline int
> > -ext3_acl_chmod(struct inode *inode)
> > -{
> > -     return 0;
> > -}
> > +#define ext3_set_acl NULL
> >
> >  static inline int
> >  ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
> > diff --git a/fs/ext3/file.c b/fs/ext3/file.c
> > index 25cb413..aad0531 100644
> > --- a/fs/ext3/file.c
> > +++ b/fs/ext3/file.c
> > @@ -75,6 +75,7 @@ const struct inode_operations
> ext3_file_inode_operations = {
> >       .removexattr    = generic_removexattr,
> >  #endif
> >       .get_acl        = ext3_get_acl,
> > +     .set_acl        = ext3_set_acl,
> >       .fiemap         = ext3_fiemap,
> >  };
> >
> > diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> > index 2bd8548..150b6c1 100644
> > --- a/fs/ext3/inode.c
> > +++ b/fs/ext3/inode.c
> > @@ -3365,7 +3365,7 @@ int ext3_setattr(struct dentry *dentry, struct
> iattr *attr)
> >       mark_inode_dirty(inode);
> >
> >       if (ia_valid & ATTR_MODE)
> > -             rc = ext3_acl_chmod(inode);
> > +             rc = posix_acl_chmod(inode);
> >
> >  err_out:
> >       ext3_std_error(inode->i_sb, error);
> > diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> > index f8cde46..f197736 100644
> > --- a/fs/ext3/namei.c
> > +++ b/fs/ext3/namei.c
> > @@ -2569,6 +2569,7 @@ const struct inode_operations
> ext3_dir_inode_operations = {
> >       .removexattr    = generic_removexattr,
> >  #endif
> >       .get_acl        = ext3_get_acl,
> > +     .set_acl        = ext3_set_acl,
> >  };
> >
> >  const struct inode_operations ext3_special_inode_operations = {
> > @@ -2580,4 +2581,5 @@ const struct inode_operations
> ext3_special_inode_operations = {
> >       .removexattr    = generic_removexattr,
> >  #endif
> >       .get_acl        = ext3_get_acl,
> > +     .set_acl        = ext3_set_acl,
> >  };
> > diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
> > index b1fc963..c6874be 100644
> > --- a/fs/ext3/xattr.c
> > +++ b/fs/ext3/xattr.c
> > @@ -102,8 +102,8 @@ static struct mb_cache *ext3_xattr_cache;
> >  static const struct xattr_handler *ext3_xattr_handler_map[] = {
> >       [EXT3_XATTR_INDEX_USER]              = &ext3_xattr_user_handler,
> >  #ifdef CONFIG_EXT3_FS_POSIX_ACL
> > -     [EXT3_XATTR_INDEX_POSIX_ACL_ACCESS]  =
> &ext3_xattr_acl_access_handler,
> > -     [EXT3_XATTR_INDEX_POSIX_ACL_DEFAULT] =
> &ext3_xattr_acl_default_handler,
> > +     [EXT3_XATTR_INDEX_POSIX_ACL_ACCESS]  =
> &posix_acl_access_xattr_handler,
> > +     [EXT3_XATTR_INDEX_POSIX_ACL_DEFAULT] =
> &posix_acl_default_xattr_handler,
> >  #endif
> >       [EXT3_XATTR_INDEX_TRUSTED]           = &ext3_xattr_trusted_handler,
> >  #ifdef CONFIG_EXT3_FS_SECURITY
> > @@ -115,8 +115,8 @@ const struct xattr_handler *ext3_xattr_handlers[] = {
> >       &ext3_xattr_user_handler,
> >       &ext3_xattr_trusted_handler,
> >  #ifdef CONFIG_EXT3_FS_POSIX_ACL
> > -     &ext3_xattr_acl_access_handler,
> > -     &ext3_xattr_acl_default_handler,
> > +     &posix_acl_access_xattr_handler,
> > +     &posix_acl_default_xattr_handler,
> >  #endif
> >  #ifdef CONFIG_EXT3_FS_SECURITY
> >       &ext3_xattr_security_handler,
> > diff --git a/fs/ext3/xattr.h b/fs/ext3/xattr.h
> > index 2be4f69..32e93eb 100644
> > --- a/fs/ext3/xattr.h
> > +++ b/fs/ext3/xattr.h
> > @@ -60,8 +60,6 @@ struct ext3_xattr_entry {
> >
> >  extern const struct xattr_handler ext3_xattr_user_handler;
> >  extern const struct xattr_handler ext3_xattr_trusted_handler;
> > -extern const struct xattr_handler ext3_xattr_acl_access_handler;
> > -extern const struct xattr_handler ext3_xattr_acl_default_handler;
> >  extern const struct xattr_handler ext3_xattr_security_handler;
> >
> >  extern ssize_t ext3_listxattr(struct dentry *, char *, size_t);
> > diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> > index f827f3b..acaba0f 100644
> > --- a/fs/ext4/acl.c
> > +++ b/fs/ext4/acl.c
> > @@ -196,7 +196,7 @@ ext4_get_acl(struct inode *inode, int type)
> >   * inode->i_mutex: down unless called from ext4_new_inode
> >   */
> >  static int
> > -ext4_set_acl(handle_t *handle, struct inode *inode, int type,
> > +__ext4_set_acl(handle_t *handle, struct inode *inode, int type,
> >            struct posix_acl *acl)
> >  {
> >       int name_index;
> > @@ -248,208 +248,51 @@ ext4_set_acl(handle_t *handle, struct inode
> *inode, int type,
> >       return error;
> >  }
> >
> > -/*
> > - * Initialize the ACLs of a new inode. Called from ext4_new_inode.
> > - *
> > - * dir->i_mutex: down
> > - * inode->i_mutex: up (access to inode is still exclusive)
> > - */
> > -int
> > -ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
> > -{
> > -     struct posix_acl *acl = NULL;
> > -     int error = 0;
> > -
> > -     if (!S_ISLNK(inode->i_mode)) {
> > -             if (test_opt(dir->i_sb, POSIX_ACL)) {
> > -                     acl = ext4_get_acl(dir, ACL_TYPE_DEFAULT);
> > -                     if (IS_ERR(acl))
> > -                             return PTR_ERR(acl);
> > -             }
> > -             if (!acl)
> > -                     inode->i_mode &= ~current_umask();
> > -     }
> > -     if (test_opt(inode->i_sb, POSIX_ACL) && acl) {
> > -             if (S_ISDIR(inode->i_mode)) {
> > -                     error = ext4_set_acl(handle, inode,
> > -                                          ACL_TYPE_DEFAULT, acl);
> > -                     if (error)
> > -                             goto cleanup;
> > -             }
> > -             error = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
> > -             if (error < 0)
> > -                     return error;
> > -
> > -             if (error > 0) {
> > -                     /* This is an extended ACL */
> > -                     error = ext4_set_acl(handle, inode,
> ACL_TYPE_ACCESS, acl);
> > -             }
> > -     }
> > -cleanup:
> > -     posix_acl_release(acl);
> > -     return error;
> > -}
> > -
> > -/*
> > - * Does chmod for an inode that may have an Access Control List. The
> > - * inode->i_mode field must be updated to the desired value by the
> caller
> > - * before calling this function.
> > - * Returns 0 on success, or a negative error number.
> > - *
> > - * We change the ACL rather than storing some ACL entries in the file
> > - * mode permission bits (which would be more efficient), because that
> > - * would break once additional permissions (like  ACL_APPEND, ACL_DELETE
> > - * for directories) are added. There are no more bits available in the
> > - * file mode.
> > - *
> > - * inode->i_mutex: down
> > - */
> >  int
> > -ext4_acl_chmod(struct inode *inode)
> > +ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> >  {
> > -     struct posix_acl *acl;
> >       handle_t *handle;
> > -     int retries = 0;
> > -     int error;
> > -
> > +     int error, retries = 0;
> >
> > -     if (S_ISLNK(inode->i_mode))
> > -             return -EOPNOTSUPP;
> > -     if (!test_opt(inode->i_sb, POSIX_ACL))
> > -             return 0;
> > -     acl = ext4_get_acl(inode, ACL_TYPE_ACCESS);
> > -     if (IS_ERR(acl) || !acl)
> > -             return PTR_ERR(acl);
> > -     error = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
> > -     if (error)
> > -             return error;
> >  retry:
> >       handle = ext4_journal_start(inode, EXT4_HT_XATTR,
> >                                   ext4_jbd2_credits_xattr(inode));
> > -     if (IS_ERR(handle)) {
> > -             error = PTR_ERR(handle);
> > -             ext4_std_error(inode->i_sb, error);
> > -             goto out;
> > -     }
> > -     error = ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, acl);
> > +     if (IS_ERR(handle))
> > +             return PTR_ERR(handle);
> > +
> > +     error = __ext4_set_acl(handle, inode, type, acl);
> >       ext4_journal_stop(handle);
> > -     if (error == -ENOSPC &&
> > -         ext4_should_retry_alloc(inode->i_sb, &retries))
> > +     if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb,
> &retries))
> >               goto retry;
> > -out:
> > -     posix_acl_release(acl);
> >       return error;
> >  }
> >
> >  /*
> > - * Extended attribute handlers
> > + * Initialize the ACLs of a new inode. Called from ext4_new_inode.
> > + *
> > + * dir->i_mutex: down
> > + * inode->i_mutex: up (access to inode is still exclusive)
> >   */
> > -static size_t
> > -ext4_xattr_list_acl_access(struct dentry *dentry, char *list, size_t
> list_len,
> > -                        const char *name, size_t name_len, int type)
> > -{
> > -     const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
> > -
> > -     if (!test_opt(dentry->d_sb, POSIX_ACL))
> > -             return 0;
> > -     if (list && size <= list_len)
> > -             memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
> > -     return size;
> > -}
> > -
> > -static size_t
> > -ext4_xattr_list_acl_default(struct dentry *dentry, char *list, size_t
> list_len,
> > -                         const char *name, size_t name_len, int type)
> > -{
> > -     const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
> > -
> > -     if (!test_opt(dentry->d_sb, POSIX_ACL))
> > -             return 0;
> > -     if (list && size <= list_len)
> > -             memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
> > -     return size;
> > -}
> > -
> > -static int
> > -ext4_xattr_get_acl(struct dentry *dentry, const char *name, void
> *buffer,
> > -                size_t size, int type)
> > +int
> > +ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
> >  {
> > -     struct posix_acl *acl;
> > +     struct posix_acl *default_acl, *acl;
> >       int error;
> >
> > -     if (strcmp(name, "") != 0)
> > -             return -EINVAL;
> > -     if (!test_opt(dentry->d_sb, POSIX_ACL))
> > -             return -EOPNOTSUPP;
> > -
> > -     acl = ext4_get_acl(dentry->d_inode, type);
> > -     if (IS_ERR(acl))
> > -             return PTR_ERR(acl);
> > -     if (acl == NULL)
> > -             return -ENODATA;
> > -     error = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
> > -     posix_acl_release(acl);
> > -
> > -     return error;
> > -}
> > -
> > -static int
> > -ext4_xattr_set_acl(struct dentry *dentry, const char *name, const void
> *value,
> > -                size_t size, int flags, int type)
> > -{
> > -     struct inode *inode = dentry->d_inode;
> > -     handle_t *handle;
> > -     struct posix_acl *acl;
> > -     int error, retries = 0;
> > -
> > -     if (strcmp(name, "") != 0)
> > -             return -EINVAL;
> > -     if (!test_opt(inode->i_sb, POSIX_ACL))
> > -             return -EOPNOTSUPP;
> > -     if (!inode_owner_or_capable(inode))
> > -             return -EPERM;
> > -
> > -     if (value) {
> > -             acl = posix_acl_from_xattr(&init_user_ns, value, size);
> > -             if (IS_ERR(acl))
> > -                     return PTR_ERR(acl);
> > -             else if (acl) {
> > -                     error = posix_acl_valid(acl);
> > -                     if (error)
> > -                             goto release_and_out;
> > -             }
> > -     } else
> > -             acl = NULL;
> > +     error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
> > +     if (error)
> > +             return error;
> >
> > -retry:
> > -     handle = ext4_journal_start(inode, EXT4_HT_XATTR,
> > -                                 ext4_jbd2_credits_xattr(inode));
> > -     if (IS_ERR(handle)) {
> > -             error = PTR_ERR(handle);
> > -             goto release_and_out;
> > +     if (default_acl) {
> > +             error = __ext4_set_acl(handle, inode, ACL_TYPE_DEFAULT,
> > +                                    default_acl);
> > +             posix_acl_release(default_acl);
> > +     }
> > +     if (acl) {
> > +             if (!error)
> > +                     error = __ext4_set_acl(handle, inode,
> ACL_TYPE_ACCESS,
> > +                                            acl);
> > +             posix_acl_release(acl);
> >       }
> > -     error = ext4_set_acl(handle, inode, type, acl);
> > -     ext4_journal_stop(handle);
> > -     if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb,
> &retries))
> > -             goto retry;
> > -
> > -release_and_out:
> > -     posix_acl_release(acl);
> >       return error;
> >  }
> > -
> > -const struct xattr_handler ext4_xattr_acl_access_handler = {
> > -     .prefix = POSIX_ACL_XATTR_ACCESS,
> > -     .flags  = ACL_TYPE_ACCESS,
> > -     .list   = ext4_xattr_list_acl_access,
> > -     .get    = ext4_xattr_get_acl,
> > -     .set    = ext4_xattr_set_acl,
> > -};
> > -
> > -const struct xattr_handler ext4_xattr_acl_default_handler = {
> > -     .prefix = POSIX_ACL_XATTR_DEFAULT,
> > -     .flags  = ACL_TYPE_DEFAULT,
> > -     .list   = ext4_xattr_list_acl_default,
> > -     .get    = ext4_xattr_get_acl,
> > -     .set    = ext4_xattr_set_acl,
> > -};
> > diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
> > index 18cb39e..da2c795 100644
> > --- a/fs/ext4/acl.h
> > +++ b/fs/ext4/acl.h
> > @@ -55,18 +55,13 @@ static inline int ext4_acl_count(size_t size)
> >
> >  /* acl.c */
> >  struct posix_acl *ext4_get_acl(struct inode *inode, int type);
> > -extern int ext4_acl_chmod(struct inode *);
> > +int ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type);
> >  extern int ext4_init_acl(handle_t *, struct inode *, struct inode *);
> >
> >  #else  /* CONFIG_EXT4_FS_POSIX_ACL */
> >  #include <linux/sched.h>
> >  #define ext4_get_acl NULL
> > -
> > -static inline int
> > -ext4_acl_chmod(struct inode *inode)
> > -{
> > -     return 0;
> > -}
> > +#define ext4_set_acl NULL
> >
> >  static inline int
> >  ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index 3da2194..43e64f6 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -617,6 +617,7 @@ const struct inode_operations
> ext4_file_inode_operations = {
> >       .listxattr      = ext4_listxattr,
> >       .removexattr    = generic_removexattr,
> >       .get_acl        = ext4_get_acl,
> > +     .set_acl        = ext4_set_acl,
> >       .fiemap         = ext4_fiemap,
> >  };
> >
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 0757634..6f69f96 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -4675,7 +4675,7 @@ int ext4_setattr(struct dentry *dentry, struct
> iattr *attr)
> >               ext4_orphan_del(NULL, inode);
> >
> >       if (!rc && (ia_valid & ATTR_MODE))
> > -             rc = ext4_acl_chmod(inode);
> > +             rc = posix_acl_chmod(inode);
> >
> >  err_out:
> >       ext4_std_error(inode->i_sb, error);
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index 5a0408d..e77c1ba 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -3225,6 +3225,7 @@ const struct inode_operations
> ext4_dir_inode_operations = {
> >       .listxattr      = ext4_listxattr,
> >       .removexattr    = generic_removexattr,
> >       .get_acl        = ext4_get_acl,
> > +     .set_acl        = ext4_set_acl,
> >       .fiemap         = ext4_fiemap,
> >  };
> >
> > @@ -3235,4 +3236,5 @@ const struct inode_operations
> ext4_special_inode_operations = {
> >       .listxattr      = ext4_listxattr,
> >       .removexattr    = generic_removexattr,
> >       .get_acl        = ext4_get_acl,
> > +     .set_acl        = ext4_set_acl,
> >  };
> > diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> > index 1423c48..e175e94 100644
> > --- a/fs/ext4/xattr.c
> > +++ b/fs/ext4/xattr.c
> > @@ -95,8 +95,8 @@ static struct mb_cache *ext4_xattr_cache;
> >  static const struct xattr_handler *ext4_xattr_handler_map[] = {
> >       [EXT4_XATTR_INDEX_USER]              = &ext4_xattr_user_handler,
> >  #ifdef CONFIG_EXT4_FS_POSIX_ACL
> > -     [EXT4_XATTR_INDEX_POSIX_ACL_ACCESS]  =
> &ext4_xattr_acl_access_handler,
> > -     [EXT4_XATTR_INDEX_POSIX_ACL_DEFAULT] =
> &ext4_xattr_acl_default_handler,
> > +     [EXT4_XATTR_INDEX_POSIX_ACL_ACCESS]  =
> &posix_acl_access_xattr_handler,
> > +     [EXT4_XATTR_INDEX_POSIX_ACL_DEFAULT] =
> &posix_acl_default_xattr_handler,
> >  #endif
> >       [EXT4_XATTR_INDEX_TRUSTED]           = &ext4_xattr_trusted_handler,
> >  #ifdef CONFIG_EXT4_FS_SECURITY
> > @@ -108,8 +108,8 @@ const struct xattr_handler *ext4_xattr_handlers[] = {
> >       &ext4_xattr_user_handler,
> >       &ext4_xattr_trusted_handler,
> >  #ifdef CONFIG_EXT4_FS_POSIX_ACL
> > -     &ext4_xattr_acl_access_handler,
> > -     &ext4_xattr_acl_default_handler,
> > +     &posix_acl_access_xattr_handler,
> > +     &posix_acl_default_xattr_handler,
> >  #endif
> >  #ifdef CONFIG_EXT4_FS_SECURITY
> >       &ext4_xattr_security_handler,
> > diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> > index c767dbd..819d639 100644
> > --- a/fs/ext4/xattr.h
> > +++ b/fs/ext4/xattr.h
> > @@ -96,8 +96,6 @@ struct ext4_xattr_ibody_find {
> >
> >  extern const struct xattr_handler ext4_xattr_user_handler;
> >  extern const struct xattr_handler ext4_xattr_trusted_handler;
> > -extern const struct xattr_handler ext4_xattr_acl_access_handler;
> > -extern const struct xattr_handler ext4_xattr_acl_default_handler;
> >  extern const struct xattr_handler ext4_xattr_security_handler;
> >
> >  extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
> > --
> > 1.7.10.4
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
>
> ------------------------------------------------------------------------------
> Rapidly troubleshoot problems before they affect your business. Most IT
> organizations don't have a clear picture of how application performance
> affects their revenue. With AppDynamics, you get 100% visibility into your
> Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics
> Pro!
> http://pubads.g.doubleclick.net/gampad/clk?id=84349351&iu=/4140/ostg.clktrk
> _______________________________________________
> Jfs-discussion mailing list
> Jfs-discussion@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/jfs-discussion
>

--047d7b6d9b16abcffb04ec9490ed
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Really nice to see all the sudden activity here in JFS aga=
in!<br></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">=
On Mon, Dec 2, 2013 at 2:13 PM, Jan Kara <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:jack@suse.cz" target=3D"_blank">jack@suse.cz</a>&gt;</span> wrote:<br=
>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">On Sun 01-12-13 03:59:11, Christoph Hellwig =
wrote:<br>
&gt; Signed-off-by: Christoph Hellwig &lt;<a href=3D"mailto:hch@lst.de">hch=
@lst.de</a>&gt;<br>
=A0 Looks good. You can add:<br>
Reviewed-by: Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&=
gt;<br>
<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Honza<br>
<br>
&gt; ---<br>
&gt; =A0fs/ext2/acl.c =A0 | =A0176 ++++------------------------------------=
-----<br>
&gt; =A0fs/ext2/acl.h =A0 | =A0 =A08 +--<br>
&gt; =A0fs/ext2/file.c =A0| =A0 =A01 +<br>
&gt; =A0fs/ext2/inode.c | =A0 =A02 +-<br>
&gt; =A0fs/ext2/namei.c | =A0 =A02 +<br>
&gt; =A0fs/ext2/xattr.c | =A0 =A08 +--<br>
&gt; =A0fs/ext2/xattr.h | =A0 =A02 -<br>
&gt; =A0fs/ext3/acl.c =A0 | =A0213 ++++++++--------------------------------=
---------------<br>
&gt; =A0fs/ext3/acl.h =A0 | =A0 =A09 +--<br>
&gt; =A0fs/ext3/file.c =A0| =A0 =A01 +<br>
&gt; =A0fs/ext3/inode.c | =A0 =A02 +-<br>
&gt; =A0fs/ext3/namei.c | =A0 =A02 +<br>
&gt; =A0fs/ext3/xattr.c | =A0 =A08 +--<br>
&gt; =A0fs/ext3/xattr.h | =A0 =A02 -<br>
&gt; =A0fs/ext4/acl.c =A0 | =A0213 ++++++++--------------------------------=
---------------<br>
&gt; =A0fs/ext4/acl.h =A0 | =A0 =A09 +--<br>
&gt; =A0fs/ext4/file.c =A0| =A0 =A01 +<br>
&gt; =A0fs/ext4/inode.c | =A0 =A02 +-<br>
&gt; =A0fs/ext4/namei.c | =A0 =A02 +<br>
&gt; =A0fs/ext4/xattr.c | =A0 =A08 +--<br>
&gt; =A0fs/ext4/xattr.h | =A0 =A02 -<br>
&gt; =A021 files changed, 100 insertions(+), 573 deletions(-)<br>
&gt;<br>
&gt; diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c<br>
&gt; index 6e842a7..f04a295 100644<br>
&gt; --- a/fs/ext2/acl.c<br>
&gt; +++ b/fs/ext2/acl.c<br>
&gt; @@ -189,8 +189,8 @@ ext2_get_acl(struct inode *inode, int type)<br>
&gt; =A0/*<br>
&gt; =A0 * inode-&gt;i_mutex: down<br>
&gt; =A0 */<br>
&gt; -static int<br>
&gt; -ext2_set_acl(struct inode *inode, int type, struct posix_acl *acl)<br=
>
&gt; +int<br>
&gt; +ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)<br=
>
&gt; =A0{<br>
&gt; =A0 =A0 =A0 int name_index;<br>
&gt; =A0 =A0 =A0 void *value =3D NULL;<br>
&gt; @@ -250,169 +250,21 @@ ext2_set_acl(struct inode *inode, int type, str=
uct posix_acl *acl)<br>
&gt; =A0int<br>
&gt; =A0ext2_init_acl(struct inode *inode, struct inode *dir)<br>
&gt; =A0{<br>
&gt; - =A0 =A0 struct posix_acl *acl =3D NULL;<br>
&gt; - =A0 =A0 int error =3D 0;<br>
&gt; -<br>
&gt; - =A0 =A0 if (!S_ISLNK(inode-&gt;i_mode)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (test_opt(dir-&gt;i_sb, POSIX_ACL)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acl =3D ext2_get_acl(dir, AC=
L_TYPE_DEFAULT);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(acl))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_E=
RR(acl);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (!acl)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode-&gt;i_mode &amp;=3D ~c=
urrent_umask();<br>
&gt; - =A0 =A0 }<br>
&gt; - =A0 =A0 if (test_opt(inode-&gt;i_sb, POSIX_ACL) &amp;&amp; acl) {<br=
>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (S_ISDIR(inode-&gt;i_mode)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D ext2_set_acl(inode=
, ACL_TYPE_DEFAULT, acl);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup=
;<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 error =3D __posix_acl_create(&amp;acl, GFP_K=
ERNEL, &amp;inode-&gt;i_mode);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (error &lt; 0)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (error &gt; 0) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This is an extended ACL *=
/<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D ext2_set_acl(inode=
, ACL_TYPE_ACCESS, acl);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 }<br>
&gt; -cleanup:<br>
&gt; - =A0 =A0 =A0 posix_acl_release(acl);<br>
&gt; - =A0 =A0 =A0 return error;<br>
&gt; -}<br>
&gt; -<br>
&gt; -/*<br>
&gt; - * Does chmod for an inode that may have an Access Control List. The<=
br>
&gt; - * inode-&gt;i_mode field must be updated to the desired value by the=
 caller<br>
&gt; - * before calling this function.<br>
&gt; - * Returns 0 on success, or a negative error number.<br>
&gt; - *<br>
&gt; - * We change the ACL rather than storing some ACL entries in the file=
<br>
&gt; - * mode permission bits (which would be more efficient), because that=
<br>
&gt; - * would break once additional permissions (like =A0ACL_APPEND, ACL_D=
ELETE<br>
&gt; - * for directories) are added. There are no more bits available in th=
e<br>
&gt; - * file mode.<br>
&gt; - *<br>
&gt; - * inode-&gt;i_mutex: down<br>
&gt; - */<br>
&gt; -int<br>
&gt; -ext2_acl_chmod(struct inode *inode)<br>
&gt; -{<br>
&gt; - =A0 =A0 struct posix_acl *acl;<br>
&gt; - =A0 =A0 =A0 =A0int error;<br>
&gt; + =A0 =A0 struct posix_acl *default_acl, *acl;<br>
&gt; + =A0 =A0 int error;<br>
&gt;<br>
&gt; - =A0 =A0 if (!test_opt(inode-&gt;i_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
&gt; - =A0 =A0 if (S_ISLNK(inode-&gt;i_mode))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;<br>
&gt; - =A0 =A0 acl =3D ext2_get_acl(inode, ACL_TYPE_ACCESS);<br>
&gt; - =A0 =A0 if (IS_ERR(acl) || !acl)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(acl);<br>
&gt; - =A0 =A0 error =3D __posix_acl_chmod(&amp;acl, GFP_KERNEL, inode-&gt;=
i_mode);<br>
&gt; + =A0 =A0 error =3D posix_acl_create(dir, &amp;inode-&gt;i_mode, &amp;=
default_acl, &amp;acl);<br>
&gt; =A0 =A0 =A0 if (error)<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;<br>
&gt; - =A0 =A0 error =3D ext2_set_acl(inode, ACL_TYPE_ACCESS, acl);<br>
&gt; - =A0 =A0 posix_acl_release(acl);<br>
&gt; - =A0 =A0 return error;<br>
&gt; -}<br>
&gt; -<br>
&gt; -/*<br>
&gt; - * Extended attribut handlers<br>
&gt; - */<br>
&gt; -static size_t<br>
&gt; -ext2_xattr_list_acl_access(struct dentry *dentry, char *list, size_t =
list_size,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *name, siz=
e_t name_len, int type)<br>
&gt; -{<br>
&gt; - =A0 =A0 const size_t size =3D sizeof(POSIX_ACL_XATTR_ACCESS);<br>
&gt; -<br>
&gt; - =A0 =A0 if (!test_opt(dentry-&gt;d_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
&gt; - =A0 =A0 if (list &amp;&amp; size &lt;=3D list_size)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 memcpy(list, POSIX_ACL_XATTR_ACCESS, size);<=
br>
&gt; - =A0 =A0 return size;<br>
&gt; -}<br>
&gt;<br>
&gt; -static size_t<br>
&gt; -ext2_xattr_list_acl_default(struct dentry *dentry, char *list, size_t=
 list_size,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *name, si=
ze_t name_len, int type)<br>
&gt; -{<br>
&gt; - =A0 =A0 const size_t size =3D sizeof(POSIX_ACL_XATTR_DEFAULT);<br>
&gt; -<br>
&gt; - =A0 =A0 if (!test_opt(dentry-&gt;d_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
&gt; - =A0 =A0 if (list &amp;&amp; size &lt;=3D list_size)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);=
<br>
&gt; - =A0 =A0 return size;<br>
&gt; -}<br>
&gt; -<br>
&gt; -static int<br>
&gt; -ext2_xattr_get_acl(struct dentry *dentry, const char *name, void *buf=
fer,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t size, int type)<br>
&gt; -{<br>
&gt; - =A0 =A0 struct posix_acl *acl;<br>
&gt; - =A0 =A0 int error;<br>
&gt; -<br>
&gt; - =A0 =A0 if (strcmp(name, &quot;&quot;) !=3D 0)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;<br>
&gt; - =A0 =A0 if (!test_opt(dentry-&gt;d_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;<br>
&gt; -<br>
&gt; - =A0 =A0 acl =3D ext2_get_acl(dentry-&gt;d_inode, type);<br>
&gt; - =A0 =A0 if (IS_ERR(acl))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(acl);<br>
&gt; - =A0 =A0 if (acl =3D=3D NULL)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -ENODATA;<br>
&gt; - =A0 =A0 error =3D posix_acl_to_xattr(&amp;init_user_ns, acl, buffer,=
 size);<br>
&gt; - =A0 =A0 posix_acl_release(acl);<br>
&gt; -<br>
&gt; - =A0 =A0 return error;<br>
&gt; -}<br>
&gt; -<br>
&gt; -static int<br>
&gt; -ext2_xattr_set_acl(struct dentry *dentry, const char *name, const voi=
d *value,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t size, int flags, int type)<br>
&gt; -{<br>
&gt; - =A0 =A0 struct posix_acl *acl;<br>
&gt; - =A0 =A0 int error;<br>
&gt; -<br>
&gt; - =A0 =A0 if (strcmp(name, &quot;&quot;) !=3D 0)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;<br>
&gt; - =A0 =A0 if (!test_opt(dentry-&gt;d_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;<br>
&gt; - =A0 =A0 if (!inode_owner_or_capable(dentry-&gt;d_inode))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EPERM;<br>
&gt; -<br>
&gt; - =A0 =A0 if (value) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 acl =3D posix_acl_from_xattr(&amp;init_user_=
ns, value, size);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(acl))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(acl);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 else if (acl) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D posix_acl_valid(ac=
l);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release=
_and_out;<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 } else<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 acl =3D NULL;<br>
&gt; -<br>
&gt; - =A0 =A0 error =3D ext2_set_acl(dentry-&gt;d_inode, type, acl);<br>
&gt; -<br>
&gt; -release_and_out:<br>
&gt; - =A0 =A0 posix_acl_release(acl);<br>
&gt; + =A0 =A0 if (default_acl) {<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 error =3D ext2_set_acl(inode, default_acl, A=
CL_TYPE_DEFAULT);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 posix_acl_release(default_acl);<br>
&gt; + =A0 =A0 }<br>
&gt; + =A0 =A0 if (acl) {<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 if (!error)<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D ext2_set_acl(inode=
, acl, ACL_TYPE_ACCESS);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 posix_acl_release(acl);<br>
&gt; + =A0 =A0 }<br>
&gt; =A0 =A0 =A0 return error;<br>
&gt; =A0}<br>
&gt; -<br>
&gt; -const struct xattr_handler ext2_xattr_acl_access_handler =3D {<br>
&gt; - =A0 =A0 .prefix =3D POSIX_ACL_XATTR_ACCESS,<br>
&gt; - =A0 =A0 .flags =A0=3D ACL_TYPE_ACCESS,<br>
&gt; - =A0 =A0 .list =A0 =3D ext2_xattr_list_acl_access,<br>
&gt; - =A0 =A0 .get =A0 =A0=3D ext2_xattr_get_acl,<br>
&gt; - =A0 =A0 .set =A0 =A0=3D ext2_xattr_set_acl,<br>
&gt; -};<br>
&gt; -<br>
&gt; -const struct xattr_handler ext2_xattr_acl_default_handler =3D {<br>
&gt; - =A0 =A0 .prefix =3D POSIX_ACL_XATTR_DEFAULT,<br>
&gt; - =A0 =A0 .flags =A0=3D ACL_TYPE_DEFAULT,<br>
&gt; - =A0 =A0 .list =A0 =3D ext2_xattr_list_acl_default,<br>
&gt; - =A0 =A0 .get =A0 =A0=3D ext2_xattr_get_acl,<br>
&gt; - =A0 =A0 .set =A0 =A0=3D ext2_xattr_set_acl,<br>
&gt; -};<br>
&gt; diff --git a/fs/ext2/acl.h b/fs/ext2/acl.h<br>
&gt; index 503bfb0..44937f9 100644<br>
&gt; --- a/fs/ext2/acl.h<br>
&gt; +++ b/fs/ext2/acl.h<br>
&gt; @@ -55,7 +55,7 @@ static inline int ext2_acl_count(size_t size)<br>
&gt;<br>
&gt; =A0/* acl.c */<br>
&gt; =A0extern struct posix_acl *ext2_get_acl(struct inode *inode, int type=
);<br>
&gt; -extern int ext2_acl_chmod (struct inode *);<br>
&gt; +extern int ext2_set_acl(struct inode *inode, struct posix_acl *acl, i=
nt type);<br>
&gt; =A0extern int ext2_init_acl (struct inode *, struct inode *);<br>
&gt;<br>
&gt; =A0#else<br>
&gt; @@ -63,12 +63,6 @@ extern int ext2_init_acl (struct inode *, struct in=
ode *);<br>
&gt; =A0#define ext2_get_acl NULL<br>
&gt; =A0#define ext2_set_acl NULL<br>
&gt;<br>
&gt; -static inline int<br>
&gt; -ext2_acl_chmod (struct inode *inode)<br>
&gt; -{<br>
&gt; - =A0 =A0 return 0;<br>
&gt; -}<br>
&gt; -<br>
&gt; =A0static inline int ext2_init_acl (struct inode *inode, struct inode =
*dir)<br>
&gt; =A0{<br>
&gt; =A0 =A0 =A0 return 0;<br>
&gt; diff --git a/fs/ext2/file.c b/fs/ext2/file.c<br>
&gt; index a5b3a5d..44c36e5 100644<br>
&gt; --- a/fs/ext2/file.c<br>
&gt; +++ b/fs/ext2/file.c<br>
&gt; @@ -103,5 +103,6 @@ const struct inode_operations ext2_file_inode_oper=
ations =3D {<br>
&gt; =A0#endif<br>
&gt; =A0 =A0 =A0 .setattr =A0 =A0 =A0 =A0=3D ext2_setattr,<br>
&gt; =A0 =A0 =A0 .get_acl =A0 =A0 =A0 =A0=3D ext2_get_acl,<br>
&gt; + =A0 =A0 .set_acl =A0 =A0 =A0 =A0=3D ext2_set_acl,<br>
&gt; =A0 =A0 =A0 .fiemap =A0 =A0 =A0 =A0 =3D ext2_fiemap,<br>
&gt; =A0};<br>
&gt; diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c<br>
&gt; index 8a33764..1be8866 100644<br>
&gt; --- a/fs/ext2/inode.c<br>
&gt; +++ b/fs/ext2/inode.c<br>
&gt; @@ -1566,7 +1566,7 @@ int ext2_setattr(struct dentry *dentry, struct i=
attr *iattr)<br>
&gt; =A0 =A0 =A0 }<br>
&gt; =A0 =A0 =A0 setattr_copy(inode, iattr);<br>
&gt; =A0 =A0 =A0 if (iattr-&gt;ia_valid &amp; ATTR_MODE)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 error =3D ext2_acl_chmod(inode);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 error =3D posix_acl_chmod(inode);<br>
&gt; =A0 =A0 =A0 mark_inode_dirty(inode);<br>
&gt;<br>
&gt; =A0 =A0 =A0 return error;<br>
&gt; diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c<br>
&gt; index 256dd5f..c268d0a 100644<br>
&gt; --- a/fs/ext2/namei.c<br>
&gt; +++ b/fs/ext2/namei.c<br>
&gt; @@ -421,6 +421,7 @@ const struct inode_operations ext2_dir_inode_opera=
tions =3D {<br>
&gt; =A0#endif<br>
&gt; =A0 =A0 =A0 .setattr =A0 =A0 =A0 =A0=3D ext2_setattr,<br>
&gt; =A0 =A0 =A0 .get_acl =A0 =A0 =A0 =A0=3D ext2_get_acl,<br>
&gt; + =A0 =A0 .set_acl =A0 =A0 =A0 =A0=3D ext2_set_acl,<br>
&gt; =A0 =A0 =A0 .tmpfile =A0 =A0 =A0 =A0=3D ext2_tmpfile,<br>
&gt; =A0};<br>
&gt;<br>
&gt; @@ -433,4 +434,5 @@ const struct inode_operations ext2_special_inode_o=
perations =3D {<br>
&gt; =A0#endif<br>
&gt; =A0 =A0 =A0 .setattr =A0 =A0 =A0 =A0=3D ext2_setattr,<br>
&gt; =A0 =A0 =A0 .get_acl =A0 =A0 =A0 =A0=3D ext2_get_acl,<br>
&gt; + =A0 =A0 .set_acl =A0 =A0 =A0 =A0=3D ext2_set_acl,<br>
&gt; =A0};<br>
&gt; diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c<br>
&gt; index 2d7557d..9142614 100644<br>
&gt; --- a/fs/ext2/xattr.c<br>
&gt; +++ b/fs/ext2/xattr.c<br>
&gt; @@ -103,8 +103,8 @@ static struct mb_cache *ext2_xattr_cache;<br>
&gt; =A0static const struct xattr_handler *ext2_xattr_handler_map[] =3D {<b=
r>
&gt; =A0 =A0 =A0 [EXT2_XATTR_INDEX_USER] =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D &am=
p;ext2_xattr_user_handler,<br>
&gt; =A0#ifdef CONFIG_EXT2_FS_POSIX_ACL<br>
&gt; - =A0 =A0 [EXT2_XATTR_INDEX_POSIX_ACL_ACCESS] =A0=3D &amp;ext2_xattr_a=
cl_access_handler,<br>
&gt; - =A0 =A0 [EXT2_XATTR_INDEX_POSIX_ACL_DEFAULT] =3D &amp;ext2_xattr_acl=
_default_handler,<br>
&gt; + =A0 =A0 [EXT2_XATTR_INDEX_POSIX_ACL_ACCESS] =A0=3D &amp;posix_acl_ac=
cess_xattr_handler,<br>
&gt; + =A0 =A0 [EXT2_XATTR_INDEX_POSIX_ACL_DEFAULT] =3D &amp;posix_acl_defa=
ult_xattr_handler,<br>
&gt; =A0#endif<br>
&gt; =A0 =A0 =A0 [EXT2_XATTR_INDEX_TRUSTED] =A0 =A0 =A0 =A0 =A0 =3D &amp;ex=
t2_xattr_trusted_handler,<br>
&gt; =A0#ifdef CONFIG_EXT2_FS_SECURITY<br>
&gt; @@ -116,8 +116,8 @@ const struct xattr_handler *ext2_xattr_handlers[] =
=3D {<br>
&gt; =A0 =A0 =A0 &amp;ext2_xattr_user_handler,<br>
&gt; =A0 =A0 =A0 &amp;ext2_xattr_trusted_handler,<br>
&gt; =A0#ifdef CONFIG_EXT2_FS_POSIX_ACL<br>
&gt; - =A0 =A0 &amp;ext2_xattr_acl_access_handler,<br>
&gt; - =A0 =A0 &amp;ext2_xattr_acl_default_handler,<br>
&gt; + =A0 =A0 &amp;posix_acl_access_xattr_handler,<br>
&gt; + =A0 =A0 &amp;posix_acl_default_xattr_handler,<br>
&gt; =A0#endif<br>
&gt; =A0#ifdef CONFIG_EXT2_FS_SECURITY<br>
&gt; =A0 =A0 =A0 &amp;ext2_xattr_security_handler,<br>
&gt; diff --git a/fs/ext2/xattr.h b/fs/ext2/xattr.h<br>
&gt; index 5e41ccc..60edf29 100644<br>
&gt; --- a/fs/ext2/xattr.h<br>
&gt; +++ b/fs/ext2/xattr.h<br>
&gt; @@ -57,8 +57,6 @@ struct ext2_xattr_entry {<br>
&gt;<br>
&gt; =A0extern const struct xattr_handler ext2_xattr_user_handler;<br>
&gt; =A0extern const struct xattr_handler ext2_xattr_trusted_handler;<br>
&gt; -extern const struct xattr_handler ext2_xattr_acl_access_handler;<br>
&gt; -extern const struct xattr_handler ext2_xattr_acl_default_handler;<br>
&gt; =A0extern const struct xattr_handler ext2_xattr_security_handler;<br>
&gt;<br>
&gt; =A0extern ssize_t ext2_listxattr(struct dentry *, char *, size_t);<br>
&gt; diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c<br>
&gt; index 4f3d8fa..e9cb33f 100644<br>
&gt; --- a/fs/ext3/acl.c<br>
&gt; +++ b/fs/ext3/acl.c<br>
&gt; @@ -190,7 +190,7 @@ ext3_get_acl(struct inode *inode, int type)<br>
&gt; =A0 * inode-&gt;i_mutex: down unless called from ext3_new_inode<br>
&gt; =A0 */<br>
&gt; =A0static int<br>
&gt; -ext3_set_acl(handle_t *handle, struct inode *inode, int type,<br>
&gt; +__ext3_set_acl(handle_t *handle, struct inode *inode, int type,<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0struct posix_acl *acl)<br>
&gt; =A0{<br>
&gt; =A0 =A0 =A0 int name_index;<br>
&gt; @@ -243,204 +243,49 @@ ext3_set_acl(handle_t *handle, struct inode *in=
ode, int type,<br>
&gt; =A0 =A0 =A0 return error;<br>
&gt; =A0}<br>
&gt;<br>
&gt; -/*<br>
&gt; - * Initialize the ACLs of a new inode. Called from ext3_new_inode.<br=
>
&gt; - *<br>
&gt; - * dir-&gt;i_mutex: down<br>
&gt; - * inode-&gt;i_mutex: up (access to inode is still exclusive)<br>
&gt; - */<br>
&gt; -int<br>
&gt; -ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *di=
r)<br>
&gt; -{<br>
&gt; - =A0 =A0 struct posix_acl *acl =3D NULL;<br>
&gt; - =A0 =A0 int error =3D 0;<br>
&gt; -<br>
&gt; - =A0 =A0 if (!S_ISLNK(inode-&gt;i_mode)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (test_opt(dir-&gt;i_sb, POSIX_ACL)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acl =3D ext3_get_acl(dir, AC=
L_TYPE_DEFAULT);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(acl))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_E=
RR(acl);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (!acl)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode-&gt;i_mode &amp;=3D ~c=
urrent_umask();<br>
&gt; - =A0 =A0 }<br>
&gt; - =A0 =A0 if (test_opt(inode-&gt;i_sb, POSIX_ACL) &amp;&amp; acl) {<br=
>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (S_ISDIR(inode-&gt;i_mode)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D ext3_set_acl(handl=
e, inode,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0ACL_TYPE_DEFAULT, acl);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup=
;<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 error =3D __posix_acl_create(&amp;acl, GFP_N=
OFS, &amp;inode-&gt;i_mode);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (error &lt; 0)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;<br>
&gt; -<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (error &gt; 0) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This is an extended ACL *=
/<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D ext3_set_acl(handl=
e, inode, ACL_TYPE_ACCESS, acl);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 }<br>
&gt; -cleanup:<br>
&gt; - =A0 =A0 posix_acl_release(acl);<br>
&gt; - =A0 =A0 return error;<br>
&gt; -}<br>
&gt; -<br>
&gt; -/*<br>
&gt; - * Does chmod for an inode that may have an Access Control List. The<=
br>
&gt; - * inode-&gt;i_mode field must be updated to the desired value by the=
 caller<br>
&gt; - * before calling this function.<br>
&gt; - * Returns 0 on success, or a negative error number.<br>
&gt; - *<br>
&gt; - * We change the ACL rather than storing some ACL entries in the file=
<br>
&gt; - * mode permission bits (which would be more efficient), because that=
<br>
&gt; - * would break once additional permissions (like =A0ACL_APPEND, ACL_D=
ELETE<br>
&gt; - * for directories) are added. There are no more bits available in th=
e<br>
&gt; - * file mode.<br>
&gt; - *<br>
&gt; - * inode-&gt;i_mutex: down<br>
&gt; - */<br>
&gt; =A0int<br>
&gt; -ext3_acl_chmod(struct inode *inode)<br>
&gt; +ext3_set_acl(struct inode *inode, struct posix_acl *acl, int type)<br=
>
&gt; =A0{<br>
&gt; - =A0 =A0 struct posix_acl *acl;<br>
&gt; =A0 =A0 =A0 handle_t *handle;<br>
&gt; - =A0 =A0 int retries =3D 0;<br>
&gt; - =A0 =A0 =A0 =A0int error;<br>
&gt; + =A0 =A0 int error, retries =3D 0;<br>
&gt;<br>
&gt; - =A0 =A0 if (S_ISLNK(inode-&gt;i_mode))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;<br>
&gt; - =A0 =A0 if (!test_opt(inode-&gt;i_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
&gt; - =A0 =A0 acl =3D ext3_get_acl(inode, ACL_TYPE_ACCESS);<br>
&gt; - =A0 =A0 if (IS_ERR(acl) || !acl)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(acl);<br>
&gt; - =A0 =A0 error =3D __posix_acl_chmod(&amp;acl, GFP_KERNEL, inode-&gt;=
i_mode);<br>
&gt; - =A0 =A0 if (error)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return error;<br>
&gt; =A0retry:<br>
&gt; - =A0 =A0 handle =3D ext3_journal_start(inode,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT3_DATA_TRANS_BLOCKS(inode=
-&gt;i_sb));<br>
&gt; - =A0 =A0 if (IS_ERR(handle)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(handle);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 ext3_std_error(inode-&gt;i_sb, error);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 goto out;<br>
&gt; - =A0 =A0 }<br>
&gt; - =A0 =A0 error =3D ext3_set_acl(handle, inode, ACL_TYPE_ACCESS, acl);=
<br>
&gt; + =A0 =A0 handle =3D ext3_journal_start(inode, EXT3_DATA_TRANS_BLOCKS(=
inode-&gt;i_sb));<br>
&gt; + =A0 =A0 if (IS_ERR(handle))<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);<br>
&gt; + =A0 =A0 error =3D __ext3_set_acl(handle, inode, type, acl);<br>
&gt; =A0 =A0 =A0 ext3_journal_stop(handle);<br>
&gt; - =A0 =A0 if (error =3D=3D -ENOSPC &amp;&amp;<br>
&gt; - =A0 =A0 =A0 =A0 ext3_should_retry_alloc(inode-&gt;i_sb, &amp;retries=
))<br>
&gt; + =A0 =A0 if (error =3D=3D -ENOSPC &amp;&amp; ext3_should_retry_alloc(=
inode-&gt;i_sb, &amp;retries))<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto retry;<br>
&gt; -out:<br>
&gt; - =A0 =A0 posix_acl_release(acl);<br>
&gt; =A0 =A0 =A0 return error;<br>
&gt; =A0}<br>
&gt;<br>
&gt; =A0/*<br>
&gt; - * Extended attribute handlers<br>
&gt; + * Initialize the ACLs of a new inode. Called from ext3_new_inode.<br=
>
&gt; + *<br>
&gt; + * dir-&gt;i_mutex: down<br>
&gt; + * inode-&gt;i_mutex: up (access to inode is still exclusive)<br>
&gt; =A0 */<br>
&gt; -static size_t<br>
&gt; -ext3_xattr_list_acl_access(struct dentry *dentry, char *list, size_t =
list_len,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *name, siz=
e_t name_len, int type)<br>
&gt; -{<br>
&gt; - =A0 =A0 const size_t size =3D sizeof(POSIX_ACL_XATTR_ACCESS);<br>
&gt; -<br>
&gt; - =A0 =A0 if (!test_opt(dentry-&gt;d_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
&gt; - =A0 =A0 if (list &amp;&amp; size &lt;=3D list_len)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 memcpy(list, POSIX_ACL_XATTR_ACCESS, size);<=
br>
&gt; - =A0 =A0 return size;<br>
&gt; -}<br>
&gt; -<br>
&gt; -static size_t<br>
&gt; -ext3_xattr_list_acl_default(struct dentry *dentry, char *list, size_t=
 list_len,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *name, si=
ze_t name_len, int type)<br>
&gt; -{<br>
&gt; - =A0 =A0 const size_t size =3D sizeof(POSIX_ACL_XATTR_DEFAULT);<br>
&gt; -<br>
&gt; - =A0 =A0 if (!test_opt(dentry-&gt;d_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
&gt; - =A0 =A0 if (list &amp;&amp; size &lt;=3D list_len)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);=
<br>
&gt; - =A0 =A0 return size;<br>
&gt; -}<br>
&gt; -<br>
&gt; -static int<br>
&gt; -ext3_xattr_get_acl(struct dentry *dentry, const char *name, void *buf=
fer,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t size, int type)<br>
&gt; +int<br>
&gt; +ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *di=
r)<br>
&gt; =A0{<br>
&gt; - =A0 =A0 struct posix_acl *acl;<br>
&gt; + =A0 =A0 struct posix_acl *default_acl, *acl;<br>
&gt; =A0 =A0 =A0 int error;<br>
&gt;<br>
&gt; - =A0 =A0 if (strcmp(name, &quot;&quot;) !=3D 0)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;<br>
&gt; - =A0 =A0 if (!test_opt(dentry-&gt;d_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;<br>
&gt; -<br>
&gt; - =A0 =A0 acl =3D ext3_get_acl(dentry-&gt;d_inode, type);<br>
&gt; - =A0 =A0 if (IS_ERR(acl))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(acl);<br>
&gt; - =A0 =A0 if (acl =3D=3D NULL)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -ENODATA;<br>
&gt; - =A0 =A0 error =3D posix_acl_to_xattr(&amp;init_user_ns, acl, buffer,=
 size);<br>
&gt; - =A0 =A0 posix_acl_release(acl);<br>
&gt; -<br>
&gt; - =A0 =A0 return error;<br>
&gt; -}<br>
&gt; -<br>
&gt; -static int<br>
&gt; -ext3_xattr_set_acl(struct dentry *dentry, const char *name, const voi=
d *value,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t size, int flags, int type)<br>
&gt; -{<br>
&gt; - =A0 =A0 struct inode *inode =3D dentry-&gt;d_inode;<br>
&gt; - =A0 =A0 handle_t *handle;<br>
&gt; - =A0 =A0 struct posix_acl *acl;<br>
&gt; - =A0 =A0 int error, retries =3D 0;<br>
&gt; -<br>
&gt; - =A0 =A0 if (strcmp(name, &quot;&quot;) !=3D 0)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;<br>
&gt; - =A0 =A0 if (!test_opt(inode-&gt;i_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;<br>
&gt; - =A0 =A0 if (!inode_owner_or_capable(inode))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EPERM;<br>
&gt; -<br>
&gt; - =A0 =A0 if (value) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 acl =3D posix_acl_from_xattr(&amp;init_user_=
ns, value, size);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(acl))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(acl);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 else if (acl) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D posix_acl_valid(ac=
l);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release=
_and_out;<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 } else<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 acl =3D NULL;<br>
&gt; -<br>
&gt; -retry:<br>
&gt; - =A0 =A0 handle =3D ext3_journal_start(inode, EXT3_DATA_TRANS_BLOCKS(=
inode-&gt;i_sb));<br>
&gt; - =A0 =A0 if (IS_ERR(handle))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);<br>
&gt; - =A0 =A0 error =3D ext3_set_acl(handle, inode, type, acl);<br>
&gt; - =A0 =A0 ext3_journal_stop(handle);<br>
&gt; - =A0 =A0 if (error =3D=3D -ENOSPC &amp;&amp; ext3_should_retry_alloc(=
inode-&gt;i_sb, &amp;retries))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 goto retry;<br>
&gt; + =A0 =A0 error =3D posix_acl_create(dir, &amp;inode-&gt;i_mode, &amp;=
default_acl, &amp;acl);<br>
&gt; + =A0 =A0 if (error)<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 return error;<br>
&gt;<br>
&gt; -release_and_out:<br>
&gt; - =A0 =A0 posix_acl_release(acl);<br>
&gt; + =A0 =A0 if (default_acl) {<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 error =3D __ext3_set_acl(handle, inode, ACL_=
TYPE_DEFAULT,<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0default_acl);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 posix_acl_release(default_acl);<br>
&gt; + =A0 =A0 }<br>
&gt; + =A0 =A0 if (acl) {<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 if (!error)<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D __ext3_set_acl(han=
dle, inode, ACL_TYPE_ACCESS,<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0acl);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 posix_acl_release(acl);<br>
&gt; + =A0 =A0 }<br>
&gt; =A0 =A0 =A0 return error;<br>
&gt; =A0}<br>
&gt; -<br>
&gt; -const struct xattr_handler ext3_xattr_acl_access_handler =3D {<br>
&gt; - =A0 =A0 .prefix =3D POSIX_ACL_XATTR_ACCESS,<br>
&gt; - =A0 =A0 .flags =A0=3D ACL_TYPE_ACCESS,<br>
&gt; - =A0 =A0 .list =A0 =3D ext3_xattr_list_acl_access,<br>
&gt; - =A0 =A0 .get =A0 =A0=3D ext3_xattr_get_acl,<br>
&gt; - =A0 =A0 .set =A0 =A0=3D ext3_xattr_set_acl,<br>
&gt; -};<br>
&gt; -<br>
&gt; -const struct xattr_handler ext3_xattr_acl_default_handler =3D {<br>
&gt; - =A0 =A0 .prefix =3D POSIX_ACL_XATTR_DEFAULT,<br>
&gt; - =A0 =A0 .flags =A0=3D ACL_TYPE_DEFAULT,<br>
&gt; - =A0 =A0 .list =A0 =3D ext3_xattr_list_acl_default,<br>
&gt; - =A0 =A0 .get =A0 =A0=3D ext3_xattr_get_acl,<br>
&gt; - =A0 =A0 .set =A0 =A0=3D ext3_xattr_set_acl,<br>
&gt; -};<br>
&gt; diff --git a/fs/ext3/acl.h b/fs/ext3/acl.h<br>
&gt; index dbc921e..ea1c69e 100644<br>
&gt; --- a/fs/ext3/acl.h<br>
&gt; +++ b/fs/ext3/acl.h<br>
&gt; @@ -55,18 +55,13 @@ static inline int ext3_acl_count(size_t size)<br>
&gt;<br>
&gt; =A0/* acl.c */<br>
&gt; =A0extern struct posix_acl *ext3_get_acl(struct inode *inode, int type=
);<br>
&gt; -extern int ext3_acl_chmod (struct inode *);<br>
&gt; +extern int ext3_set_acl(struct inode *inode, struct posix_acl *acl, i=
nt type);<br>
&gt; =A0extern int ext3_init_acl (handle_t *, struct inode *, struct inode =
*);<br>
&gt;<br>
&gt; =A0#else =A0/* CONFIG_EXT3_FS_POSIX_ACL */<br>
&gt; =A0#include &lt;linux/sched.h&gt;<br>
&gt; =A0#define ext3_get_acl NULL<br>
&gt; -<br>
&gt; -static inline int<br>
&gt; -ext3_acl_chmod(struct inode *inode)<br>
&gt; -{<br>
&gt; - =A0 =A0 return 0;<br>
&gt; -}<br>
&gt; +#define ext3_set_acl NULL<br>
&gt;<br>
&gt; =A0static inline int<br>
&gt; =A0ext3_init_acl(handle_t *handle, struct inode *inode, struct inode *=
dir)<br>
&gt; diff --git a/fs/ext3/file.c b/fs/ext3/file.c<br>
&gt; index 25cb413..aad0531 100644<br>
&gt; --- a/fs/ext3/file.c<br>
&gt; +++ b/fs/ext3/file.c<br>
&gt; @@ -75,6 +75,7 @@ const struct inode_operations ext3_file_inode_operat=
ions =3D {<br>
&gt; =A0 =A0 =A0 .removexattr =A0 =A0=3D generic_removexattr,<br>
&gt; =A0#endif<br>
&gt; =A0 =A0 =A0 .get_acl =A0 =A0 =A0 =A0=3D ext3_get_acl,<br>
&gt; + =A0 =A0 .set_acl =A0 =A0 =A0 =A0=3D ext3_set_acl,<br>
&gt; =A0 =A0 =A0 .fiemap =A0 =A0 =A0 =A0 =3D ext3_fiemap,<br>
&gt; =A0};<br>
&gt;<br>
&gt; diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c<br>
&gt; index 2bd8548..150b6c1 100644<br>
&gt; --- a/fs/ext3/inode.c<br>
&gt; +++ b/fs/ext3/inode.c<br>
&gt; @@ -3365,7 +3365,7 @@ int ext3_setattr(struct dentry *dentry, struct i=
attr *attr)<br>
&gt; =A0 =A0 =A0 mark_inode_dirty(inode);<br>
&gt;<br>
&gt; =A0 =A0 =A0 if (ia_valid &amp; ATTR_MODE)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ext3_acl_chmod(inode);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D posix_acl_chmod(inode);<br>
&gt;<br>
&gt; =A0err_out:<br>
&gt; =A0 =A0 =A0 ext3_std_error(inode-&gt;i_sb, error);<br>
&gt; diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c<br>
&gt; index f8cde46..f197736 100644<br>
&gt; --- a/fs/ext3/namei.c<br>
&gt; +++ b/fs/ext3/namei.c<br>
&gt; @@ -2569,6 +2569,7 @@ const struct inode_operations ext3_dir_inode_ope=
rations =3D {<br>
&gt; =A0 =A0 =A0 .removexattr =A0 =A0=3D generic_removexattr,<br>
&gt; =A0#endif<br>
&gt; =A0 =A0 =A0 .get_acl =A0 =A0 =A0 =A0=3D ext3_get_acl,<br>
&gt; + =A0 =A0 .set_acl =A0 =A0 =A0 =A0=3D ext3_set_acl,<br>
&gt; =A0};<br>
&gt;<br>
&gt; =A0const struct inode_operations ext3_special_inode_operations =3D {<b=
r>
&gt; @@ -2580,4 +2581,5 @@ const struct inode_operations ext3_special_inode=
_operations =3D {<br>
&gt; =A0 =A0 =A0 .removexattr =A0 =A0=3D generic_removexattr,<br>
&gt; =A0#endif<br>
&gt; =A0 =A0 =A0 .get_acl =A0 =A0 =A0 =A0=3D ext3_get_acl,<br>
&gt; + =A0 =A0 .set_acl =A0 =A0 =A0 =A0=3D ext3_set_acl,<br>
&gt; =A0};<br>
&gt; diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c<br>
&gt; index b1fc963..c6874be 100644<br>
&gt; --- a/fs/ext3/xattr.c<br>
&gt; +++ b/fs/ext3/xattr.c<br>
&gt; @@ -102,8 +102,8 @@ static struct mb_cache *ext3_xattr_cache;<br>
&gt; =A0static const struct xattr_handler *ext3_xattr_handler_map[] =3D {<b=
r>
&gt; =A0 =A0 =A0 [EXT3_XATTR_INDEX_USER] =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D &am=
p;ext3_xattr_user_handler,<br>
&gt; =A0#ifdef CONFIG_EXT3_FS_POSIX_ACL<br>
&gt; - =A0 =A0 [EXT3_XATTR_INDEX_POSIX_ACL_ACCESS] =A0=3D &amp;ext3_xattr_a=
cl_access_handler,<br>
&gt; - =A0 =A0 [EXT3_XATTR_INDEX_POSIX_ACL_DEFAULT] =3D &amp;ext3_xattr_acl=
_default_handler,<br>
&gt; + =A0 =A0 [EXT3_XATTR_INDEX_POSIX_ACL_ACCESS] =A0=3D &amp;posix_acl_ac=
cess_xattr_handler,<br>
&gt; + =A0 =A0 [EXT3_XATTR_INDEX_POSIX_ACL_DEFAULT] =3D &amp;posix_acl_defa=
ult_xattr_handler,<br>
&gt; =A0#endif<br>
&gt; =A0 =A0 =A0 [EXT3_XATTR_INDEX_TRUSTED] =A0 =A0 =A0 =A0 =A0 =3D &amp;ex=
t3_xattr_trusted_handler,<br>
&gt; =A0#ifdef CONFIG_EXT3_FS_SECURITY<br>
&gt; @@ -115,8 +115,8 @@ const struct xattr_handler *ext3_xattr_handlers[] =
=3D {<br>
&gt; =A0 =A0 =A0 &amp;ext3_xattr_user_handler,<br>
&gt; =A0 =A0 =A0 &amp;ext3_xattr_trusted_handler,<br>
&gt; =A0#ifdef CONFIG_EXT3_FS_POSIX_ACL<br>
&gt; - =A0 =A0 &amp;ext3_xattr_acl_access_handler,<br>
&gt; - =A0 =A0 &amp;ext3_xattr_acl_default_handler,<br>
&gt; + =A0 =A0 &amp;posix_acl_access_xattr_handler,<br>
&gt; + =A0 =A0 &amp;posix_acl_default_xattr_handler,<br>
&gt; =A0#endif<br>
&gt; =A0#ifdef CONFIG_EXT3_FS_SECURITY<br>
&gt; =A0 =A0 =A0 &amp;ext3_xattr_security_handler,<br>
&gt; diff --git a/fs/ext3/xattr.h b/fs/ext3/xattr.h<br>
&gt; index 2be4f69..32e93eb 100644<br>
&gt; --- a/fs/ext3/xattr.h<br>
&gt; +++ b/fs/ext3/xattr.h<br>
&gt; @@ -60,8 +60,6 @@ struct ext3_xattr_entry {<br>
&gt;<br>
&gt; =A0extern const struct xattr_handler ext3_xattr_user_handler;<br>
&gt; =A0extern const struct xattr_handler ext3_xattr_trusted_handler;<br>
&gt; -extern const struct xattr_handler ext3_xattr_acl_access_handler;<br>
&gt; -extern const struct xattr_handler ext3_xattr_acl_default_handler;<br>
&gt; =A0extern const struct xattr_handler ext3_xattr_security_handler;<br>
&gt;<br>
&gt; =A0extern ssize_t ext3_listxattr(struct dentry *, char *, size_t);<br>
&gt; diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c<br>
&gt; index f827f3b..acaba0f 100644<br>
&gt; --- a/fs/ext4/acl.c<br>
&gt; +++ b/fs/ext4/acl.c<br>
&gt; @@ -196,7 +196,7 @@ ext4_get_acl(struct inode *inode, int type)<br>
&gt; =A0 * inode-&gt;i_mutex: down unless called from ext4_new_inode<br>
&gt; =A0 */<br>
&gt; =A0static int<br>
&gt; -ext4_set_acl(handle_t *handle, struct inode *inode, int type,<br>
&gt; +__ext4_set_acl(handle_t *handle, struct inode *inode, int type,<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0struct posix_acl *acl)<br>
&gt; =A0{<br>
&gt; =A0 =A0 =A0 int name_index;<br>
&gt; @@ -248,208 +248,51 @@ ext4_set_acl(handle_t *handle, struct inode *in=
ode, int type,<br>
&gt; =A0 =A0 =A0 return error;<br>
&gt; =A0}<br>
&gt;<br>
&gt; -/*<br>
&gt; - * Initialize the ACLs of a new inode. Called from ext4_new_inode.<br=
>
&gt; - *<br>
&gt; - * dir-&gt;i_mutex: down<br>
&gt; - * inode-&gt;i_mutex: up (access to inode is still exclusive)<br>
&gt; - */<br>
&gt; -int<br>
&gt; -ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *di=
r)<br>
&gt; -{<br>
&gt; - =A0 =A0 struct posix_acl *acl =3D NULL;<br>
&gt; - =A0 =A0 int error =3D 0;<br>
&gt; -<br>
&gt; - =A0 =A0 if (!S_ISLNK(inode-&gt;i_mode)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (test_opt(dir-&gt;i_sb, POSIX_ACL)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acl =3D ext4_get_acl(dir, AC=
L_TYPE_DEFAULT);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(acl))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_E=
RR(acl);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (!acl)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode-&gt;i_mode &amp;=3D ~c=
urrent_umask();<br>
&gt; - =A0 =A0 }<br>
&gt; - =A0 =A0 if (test_opt(inode-&gt;i_sb, POSIX_ACL) &amp;&amp; acl) {<br=
>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (S_ISDIR(inode-&gt;i_mode)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D ext4_set_acl(handl=
e, inode,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0ACL_TYPE_DEFAULT, acl);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup=
;<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 error =3D __posix_acl_create(&amp;acl, GFP_N=
OFS, &amp;inode-&gt;i_mode);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (error &lt; 0)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;<br>
&gt; -<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (error &gt; 0) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This is an extended ACL *=
/<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D ext4_set_acl(handl=
e, inode, ACL_TYPE_ACCESS, acl);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 }<br>
&gt; -cleanup:<br>
&gt; - =A0 =A0 posix_acl_release(acl);<br>
&gt; - =A0 =A0 return error;<br>
&gt; -}<br>
&gt; -<br>
&gt; -/*<br>
&gt; - * Does chmod for an inode that may have an Access Control List. The<=
br>
&gt; - * inode-&gt;i_mode field must be updated to the desired value by the=
 caller<br>
&gt; - * before calling this function.<br>
&gt; - * Returns 0 on success, or a negative error number.<br>
&gt; - *<br>
&gt; - * We change the ACL rather than storing some ACL entries in the file=
<br>
&gt; - * mode permission bits (which would be more efficient), because that=
<br>
&gt; - * would break once additional permissions (like =A0ACL_APPEND, ACL_D=
ELETE<br>
&gt; - * for directories) are added. There are no more bits available in th=
e<br>
&gt; - * file mode.<br>
&gt; - *<br>
&gt; - * inode-&gt;i_mutex: down<br>
&gt; - */<br>
&gt; =A0int<br>
&gt; -ext4_acl_chmod(struct inode *inode)<br>
&gt; +ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type)<br=
>
&gt; =A0{<br>
&gt; - =A0 =A0 struct posix_acl *acl;<br>
&gt; =A0 =A0 =A0 handle_t *handle;<br>
&gt; - =A0 =A0 int retries =3D 0;<br>
&gt; - =A0 =A0 int error;<br>
&gt; -<br>
&gt; + =A0 =A0 int error, retries =3D 0;<br>
&gt;<br>
&gt; - =A0 =A0 if (S_ISLNK(inode-&gt;i_mode))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;<br>
&gt; - =A0 =A0 if (!test_opt(inode-&gt;i_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
&gt; - =A0 =A0 acl =3D ext4_get_acl(inode, ACL_TYPE_ACCESS);<br>
&gt; - =A0 =A0 if (IS_ERR(acl) || !acl)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(acl);<br>
&gt; - =A0 =A0 error =3D __posix_acl_chmod(&amp;acl, GFP_KERNEL, inode-&gt;=
i_mode);<br>
&gt; - =A0 =A0 if (error)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return error;<br>
&gt; =A0retry:<br>
&gt; =A0 =A0 =A0 handle =3D ext4_journal_start(inode, EXT4_HT_XATTR,<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex=
t4_jbd2_credits_xattr(inode));<br>
&gt; - =A0 =A0 if (IS_ERR(handle)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(handle);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 ext4_std_error(inode-&gt;i_sb, error);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 goto out;<br>
&gt; - =A0 =A0 }<br>
&gt; - =A0 =A0 error =3D ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, acl);=
<br>
&gt; + =A0 =A0 if (IS_ERR(handle))<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);<br>
&gt; +<br>
&gt; + =A0 =A0 error =3D __ext4_set_acl(handle, inode, type, acl);<br>
&gt; =A0 =A0 =A0 ext4_journal_stop(handle);<br>
&gt; - =A0 =A0 if (error =3D=3D -ENOSPC &amp;&amp;<br>
&gt; - =A0 =A0 =A0 =A0 ext4_should_retry_alloc(inode-&gt;i_sb, &amp;retries=
))<br>
&gt; + =A0 =A0 if (error =3D=3D -ENOSPC &amp;&amp; ext4_should_retry_alloc(=
inode-&gt;i_sb, &amp;retries))<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto retry;<br>
&gt; -out:<br>
&gt; - =A0 =A0 posix_acl_release(acl);<br>
&gt; =A0 =A0 =A0 return error;<br>
&gt; =A0}<br>
&gt;<br>
&gt; =A0/*<br>
&gt; - * Extended attribute handlers<br>
&gt; + * Initialize the ACLs of a new inode. Called from ext4_new_inode.<br=
>
&gt; + *<br>
&gt; + * dir-&gt;i_mutex: down<br>
&gt; + * inode-&gt;i_mutex: up (access to inode is still exclusive)<br>
&gt; =A0 */<br>
&gt; -static size_t<br>
&gt; -ext4_xattr_list_acl_access(struct dentry *dentry, char *list, size_t =
list_len,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *name, siz=
e_t name_len, int type)<br>
&gt; -{<br>
&gt; - =A0 =A0 const size_t size =3D sizeof(POSIX_ACL_XATTR_ACCESS);<br>
&gt; -<br>
&gt; - =A0 =A0 if (!test_opt(dentry-&gt;d_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
&gt; - =A0 =A0 if (list &amp;&amp; size &lt;=3D list_len)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 memcpy(list, POSIX_ACL_XATTR_ACCESS, size);<=
br>
&gt; - =A0 =A0 return size;<br>
&gt; -}<br>
&gt; -<br>
&gt; -static size_t<br>
&gt; -ext4_xattr_list_acl_default(struct dentry *dentry, char *list, size_t=
 list_len,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *name, si=
ze_t name_len, int type)<br>
&gt; -{<br>
&gt; - =A0 =A0 const size_t size =3D sizeof(POSIX_ACL_XATTR_DEFAULT);<br>
&gt; -<br>
&gt; - =A0 =A0 if (!test_opt(dentry-&gt;d_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
&gt; - =A0 =A0 if (list &amp;&amp; size &lt;=3D list_len)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);=
<br>
&gt; - =A0 =A0 return size;<br>
&gt; -}<br>
&gt; -<br>
&gt; -static int<br>
&gt; -ext4_xattr_get_acl(struct dentry *dentry, const char *name, void *buf=
fer,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t size, int type)<br>
&gt; +int<br>
&gt; +ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *di=
r)<br>
&gt; =A0{<br>
&gt; - =A0 =A0 struct posix_acl *acl;<br>
&gt; + =A0 =A0 struct posix_acl *default_acl, *acl;<br>
&gt; =A0 =A0 =A0 int error;<br>
&gt;<br>
&gt; - =A0 =A0 if (strcmp(name, &quot;&quot;) !=3D 0)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;<br>
&gt; - =A0 =A0 if (!test_opt(dentry-&gt;d_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;<br>
&gt; -<br>
&gt; - =A0 =A0 acl =3D ext4_get_acl(dentry-&gt;d_inode, type);<br>
&gt; - =A0 =A0 if (IS_ERR(acl))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(acl);<br>
&gt; - =A0 =A0 if (acl =3D=3D NULL)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -ENODATA;<br>
&gt; - =A0 =A0 error =3D posix_acl_to_xattr(&amp;init_user_ns, acl, buffer,=
 size);<br>
&gt; - =A0 =A0 posix_acl_release(acl);<br>
&gt; -<br>
&gt; - =A0 =A0 return error;<br>
&gt; -}<br>
&gt; -<br>
&gt; -static int<br>
&gt; -ext4_xattr_set_acl(struct dentry *dentry, const char *name, const voi=
d *value,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t size, int flags, int type)<br>
&gt; -{<br>
&gt; - =A0 =A0 struct inode *inode =3D dentry-&gt;d_inode;<br>
&gt; - =A0 =A0 handle_t *handle;<br>
&gt; - =A0 =A0 struct posix_acl *acl;<br>
&gt; - =A0 =A0 int error, retries =3D 0;<br>
&gt; -<br>
&gt; - =A0 =A0 if (strcmp(name, &quot;&quot;) !=3D 0)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;<br>
&gt; - =A0 =A0 if (!test_opt(inode-&gt;i_sb, POSIX_ACL))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;<br>
&gt; - =A0 =A0 if (!inode_owner_or_capable(inode))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 return -EPERM;<br>
&gt; -<br>
&gt; - =A0 =A0 if (value) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 acl =3D posix_acl_from_xattr(&amp;init_user_=
ns, value, size);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(acl))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(acl);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 else if (acl) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D posix_acl_valid(ac=
l);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error)<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release=
_and_out;<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 } else<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 acl =3D NULL;<br>
&gt; + =A0 =A0 error =3D posix_acl_create(dir, &amp;inode-&gt;i_mode, &amp;=
default_acl, &amp;acl);<br>
&gt; + =A0 =A0 if (error)<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 return error;<br>
&gt;<br>
&gt; -retry:<br>
&gt; - =A0 =A0 handle =3D ext4_journal_start(inode, EXT4_HT_XATTR,<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4=
_jbd2_credits_xattr(inode));<br>
&gt; - =A0 =A0 if (IS_ERR(handle)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(handle);<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 goto release_and_out;<br>
&gt; + =A0 =A0 if (default_acl) {<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 error =3D __ext4_set_acl(handle, inode, ACL_=
TYPE_DEFAULT,<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0default_acl);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 posix_acl_release(default_acl);<br>
&gt; + =A0 =A0 }<br>
&gt; + =A0 =A0 if (acl) {<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 if (!error)<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D __ext4_set_acl(han=
dle, inode, ACL_TYPE_ACCESS,<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0acl);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 posix_acl_release(acl);<br>
&gt; =A0 =A0 =A0 }<br>
&gt; - =A0 =A0 error =3D ext4_set_acl(handle, inode, type, acl);<br>
&gt; - =A0 =A0 ext4_journal_stop(handle);<br>
&gt; - =A0 =A0 if (error =3D=3D -ENOSPC &amp;&amp; ext4_should_retry_alloc(=
inode-&gt;i_sb, &amp;retries))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 goto retry;<br>
&gt; -<br>
&gt; -release_and_out:<br>
&gt; - =A0 =A0 posix_acl_release(acl);<br>
&gt; =A0 =A0 =A0 return error;<br>
&gt; =A0}<br>
&gt; -<br>
&gt; -const struct xattr_handler ext4_xattr_acl_access_handler =3D {<br>
&gt; - =A0 =A0 .prefix =3D POSIX_ACL_XATTR_ACCESS,<br>
&gt; - =A0 =A0 .flags =A0=3D ACL_TYPE_ACCESS,<br>
&gt; - =A0 =A0 .list =A0 =3D ext4_xattr_list_acl_access,<br>
&gt; - =A0 =A0 .get =A0 =A0=3D ext4_xattr_get_acl,<br>
&gt; - =A0 =A0 .set =A0 =A0=3D ext4_xattr_set_acl,<br>
&gt; -};<br>
&gt; -<br>
&gt; -const struct xattr_handler ext4_xattr_acl_default_handler =3D {<br>
&gt; - =A0 =A0 .prefix =3D POSIX_ACL_XATTR_DEFAULT,<br>
&gt; - =A0 =A0 .flags =A0=3D ACL_TYPE_DEFAULT,<br>
&gt; - =A0 =A0 .list =A0 =3D ext4_xattr_list_acl_default,<br>
&gt; - =A0 =A0 .get =A0 =A0=3D ext4_xattr_get_acl,<br>
&gt; - =A0 =A0 .set =A0 =A0=3D ext4_xattr_set_acl,<br>
&gt; -};<br>
&gt; diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h<br>
&gt; index 18cb39e..da2c795 100644<br>
&gt; --- a/fs/ext4/acl.h<br>
&gt; +++ b/fs/ext4/acl.h<br>
&gt; @@ -55,18 +55,13 @@ static inline int ext4_acl_count(size_t size)<br>
&gt;<br>
&gt; =A0/* acl.c */<br>
&gt; =A0struct posix_acl *ext4_get_acl(struct inode *inode, int type);<br>
&gt; -extern int ext4_acl_chmod(struct inode *);<br>
&gt; +int ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type=
);<br>
&gt; =A0extern int ext4_init_acl(handle_t *, struct inode *, struct inode *=
);<br>
&gt;<br>
&gt; =A0#else =A0/* CONFIG_EXT4_FS_POSIX_ACL */<br>
&gt; =A0#include &lt;linux/sched.h&gt;<br>
&gt; =A0#define ext4_get_acl NULL<br>
&gt; -<br>
&gt; -static inline int<br>
&gt; -ext4_acl_chmod(struct inode *inode)<br>
&gt; -{<br>
&gt; - =A0 =A0 return 0;<br>
&gt; -}<br>
&gt; +#define ext4_set_acl NULL<br>
&gt;<br>
&gt; =A0static inline int<br>
&gt; =A0ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *=
dir)<br>
&gt; diff --git a/fs/ext4/file.c b/fs/ext4/file.c<br>
&gt; index 3da2194..43e64f6 100644<br>
&gt; --- a/fs/ext4/file.c<br>
&gt; +++ b/fs/ext4/file.c<br>
&gt; @@ -617,6 +617,7 @@ const struct inode_operations ext4_file_inode_oper=
ations =3D {<br>
&gt; =A0 =A0 =A0 .listxattr =A0 =A0 =A0=3D ext4_listxattr,<br>
&gt; =A0 =A0 =A0 .removexattr =A0 =A0=3D generic_removexattr,<br>
&gt; =A0 =A0 =A0 .get_acl =A0 =A0 =A0 =A0=3D ext4_get_acl,<br>
&gt; + =A0 =A0 .set_acl =A0 =A0 =A0 =A0=3D ext4_set_acl,<br>
&gt; =A0 =A0 =A0 .fiemap =A0 =A0 =A0 =A0 =3D ext4_fiemap,<br>
&gt; =A0};<br>
&gt;<br>
&gt; diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c<br>
&gt; index 0757634..6f69f96 100644<br>
&gt; --- a/fs/ext4/inode.c<br>
&gt; +++ b/fs/ext4/inode.c<br>
&gt; @@ -4675,7 +4675,7 @@ int ext4_setattr(struct dentry *dentry, struct i=
attr *attr)<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_orphan_del(NULL, inode);<br>
&gt;<br>
&gt; =A0 =A0 =A0 if (!rc &amp;&amp; (ia_valid &amp; ATTR_MODE))<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ext4_acl_chmod(inode);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D posix_acl_chmod(inode);<br>
&gt;<br>
&gt; =A0err_out:<br>
&gt; =A0 =A0 =A0 ext4_std_error(inode-&gt;i_sb, error);<br>
&gt; diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c<br>
&gt; index 5a0408d..e77c1ba 100644<br>
&gt; --- a/fs/ext4/namei.c<br>
&gt; +++ b/fs/ext4/namei.c<br>
&gt; @@ -3225,6 +3225,7 @@ const struct inode_operations ext4_dir_inode_ope=
rations =3D {<br>
&gt; =A0 =A0 =A0 .listxattr =A0 =A0 =A0=3D ext4_listxattr,<br>
&gt; =A0 =A0 =A0 .removexattr =A0 =A0=3D generic_removexattr,<br>
&gt; =A0 =A0 =A0 .get_acl =A0 =A0 =A0 =A0=3D ext4_get_acl,<br>
&gt; + =A0 =A0 .set_acl =A0 =A0 =A0 =A0=3D ext4_set_acl,<br>
&gt; =A0 =A0 =A0 .fiemap =A0 =A0 =A0 =A0 =3D ext4_fiemap,<br>
&gt; =A0};<br>
&gt;<br>
&gt; @@ -3235,4 +3236,5 @@ const struct inode_operations ext4_special_inode=
_operations =3D {<br>
&gt; =A0 =A0 =A0 .listxattr =A0 =A0 =A0=3D ext4_listxattr,<br>
&gt; =A0 =A0 =A0 .removexattr =A0 =A0=3D generic_removexattr,<br>
&gt; =A0 =A0 =A0 .get_acl =A0 =A0 =A0 =A0=3D ext4_get_acl,<br>
&gt; + =A0 =A0 .set_acl =A0 =A0 =A0 =A0=3D ext4_set_acl,<br>
&gt; =A0};<br>
&gt; diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c<br>
&gt; index 1423c48..e175e94 100644<br>
&gt; --- a/fs/ext4/xattr.c<br>
&gt; +++ b/fs/ext4/xattr.c<br>
&gt; @@ -95,8 +95,8 @@ static struct mb_cache *ext4_xattr_cache;<br>
&gt; =A0static const struct xattr_handler *ext4_xattr_handler_map[] =3D {<b=
r>
&gt; =A0 =A0 =A0 [EXT4_XATTR_INDEX_USER] =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D &am=
p;ext4_xattr_user_handler,<br>
&gt; =A0#ifdef CONFIG_EXT4_FS_POSIX_ACL<br>
&gt; - =A0 =A0 [EXT4_XATTR_INDEX_POSIX_ACL_ACCESS] =A0=3D &amp;ext4_xattr_a=
cl_access_handler,<br>
&gt; - =A0 =A0 [EXT4_XATTR_INDEX_POSIX_ACL_DEFAULT] =3D &amp;ext4_xattr_acl=
_default_handler,<br>
&gt; + =A0 =A0 [EXT4_XATTR_INDEX_POSIX_ACL_ACCESS] =A0=3D &amp;posix_acl_ac=
cess_xattr_handler,<br>
&gt; + =A0 =A0 [EXT4_XATTR_INDEX_POSIX_ACL_DEFAULT] =3D &amp;posix_acl_defa=
ult_xattr_handler,<br>
&gt; =A0#endif<br>
&gt; =A0 =A0 =A0 [EXT4_XATTR_INDEX_TRUSTED] =A0 =A0 =A0 =A0 =A0 =3D &amp;ex=
t4_xattr_trusted_handler,<br>
&gt; =A0#ifdef CONFIG_EXT4_FS_SECURITY<br>
&gt; @@ -108,8 +108,8 @@ const struct xattr_handler *ext4_xattr_handlers[] =
=3D {<br>
&gt; =A0 =A0 =A0 &amp;ext4_xattr_user_handler,<br>
&gt; =A0 =A0 =A0 &amp;ext4_xattr_trusted_handler,<br>
&gt; =A0#ifdef CONFIG_EXT4_FS_POSIX_ACL<br>
&gt; - =A0 =A0 &amp;ext4_xattr_acl_access_handler,<br>
&gt; - =A0 =A0 &amp;ext4_xattr_acl_default_handler,<br>
&gt; + =A0 =A0 &amp;posix_acl_access_xattr_handler,<br>
&gt; + =A0 =A0 &amp;posix_acl_default_xattr_handler,<br>
&gt; =A0#endif<br>
&gt; =A0#ifdef CONFIG_EXT4_FS_SECURITY<br>
&gt; =A0 =A0 =A0 &amp;ext4_xattr_security_handler,<br>
&gt; diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h<br>
&gt; index c767dbd..819d639 100644<br>
&gt; --- a/fs/ext4/xattr.h<br>
&gt; +++ b/fs/ext4/xattr.h<br>
&gt; @@ -96,8 +96,6 @@ struct ext4_xattr_ibody_find {<br>
&gt;<br>
&gt; =A0extern const struct xattr_handler ext4_xattr_user_handler;<br>
&gt; =A0extern const struct xattr_handler ext4_xattr_trusted_handler;<br>
&gt; -extern const struct xattr_handler ext4_xattr_acl_access_handler;<br>
&gt; -extern const struct xattr_handler ext4_xattr_acl_default_handler;<br>
&gt; =A0extern const struct xattr_handler ext4_xattr_security_handler;<br>
&gt;<br>
&gt; =A0extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);<br>
&gt; --<br>
&gt; 1.7.10.4<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; To unsubscribe from this list: send the line &quot;unsubscribe linux-f=
sdevel&quot; in<br>
&gt; the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">=
majordomo@vger.kernel.org</a><br>
&gt; More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordomo-=
info.html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a>=
<br>
--<br>
Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt;<br>
SUSE Labs, CR<br>
<br>
---------------------------------------------------------------------------=
---<br>
Rapidly troubleshoot problems before they affect your business. Most IT<br>
organizations don&#39;t have a clear picture of how application performance=
<br>
affects their revenue. With AppDynamics, you get 100% visibility into your<=
br>
Java,.NET, &amp; PHP application. Start your 15-day FREE TRIAL of AppDynami=
cs Pro!<br>
<a href=3D"http://pubads.g.doubleclick.net/gampad/clk?id=3D84349351&amp;iu=
=3D/4140/ostg.clktrk" target=3D"_blank">http://pubads.g.doubleclick.net/gam=
pad/clk?id=3D84349351&amp;iu=3D/4140/ostg.clktrk</a><br>
_______________________________________________<br>
Jfs-discussion mailing list<br>
<a href=3D"mailto:Jfs-discussion@lists.sourceforge.net">Jfs-discussion@list=
s.sourceforge.net</a><br>
<a href=3D"https://lists.sourceforge.net/lists/listinfo/jfs-discussion" tar=
get=3D"_blank">https://lists.sourceforge.net/lists/listinfo/jfs-discussion<=
/a><br>
</blockquote></div><br></div>

--047d7b6d9b16abcffb04ec9490ed--


--===============8073369636330785012==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8073369636330785012==--

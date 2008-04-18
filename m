Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Apr 2008 23:23:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3I6NBBR000604
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2008 23:23:16 -0700
Message-ID: <48083E68.4000002@sgi.com>
Date: Fri, 18 Apr 2008 16:23:36 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [REVIEW] - cleanup xfs_attr a bit
References: <op.t9qhhmhx3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080417182702.GA7154@infradead.org> <op.t9sjc8hu3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t9sjc8hu3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Barry Naujok wrote:
> On Fri, 18 Apr 2008 04:27:02 +1000, Christoph Hellwig 
> <hch@infradead.org> wrote:
> 
>> On Thu, Apr 17, 2008 at 12:35:36PM +1000, Barry Naujok wrote:
>>> This patch starts using struct xfs_name more for the xattr code and
>>> is another step for using xfs_name in xfs_da_args.
>>>
>>> Also, the cred parameter is removed from xfs_attr_get and 
>>> xfs_attr_fetch.
>>
Yeah, we used to have callers to capable_cred() which just compared
with sys_cred (to effectively bypass cred checks).
But we don't seem to have any callers anymore.
Used to be in xfs_iaccess() and xfs_acl_capability_check() use it.
So is anyone using sys_cred now?
Is anyone using creds at all now?
i.e. should the cred removal be part of an entire cred cleanup?

So xfs_attr_fetch takes xfs_name instead of <name,size>.
You made xfs_attr_remove_int, set_int and list_int version STATIC
and removed header protos. Ok.

So xfs_attr_name_to_xname() was invented to abstract validity code being
used in xfs_attr_get() and xfs_attr_set() and set up struct.

Yeah, some of these functions changed so that we could pass in
binary names instead of null-terminated ones, within the
kernel code (e.g. parent ptrs) and hence needed name-len as param.

--Tim

>> Looks good, but I'd really not expected a function called
>> xfs_attr_name_to_name to do the shutdown check.  Either keep it in the
>> callers or give the function a different name.
> 
> Ok, done:
> 
> ---
>  fs/xfs/dmapi/xfs_dm.c        |   13 ++----
>  fs/xfs/linux-2.6/xfs_ioctl.c |    6 +-
>  fs/xfs/xfs_acl.c             |    7 +--
>  fs/xfs/xfs_attr.c            |   93 
> ++++++++++++++++++++++++-------------------
>  fs/xfs/xfs_attr.h            |    6 --
>  fs/xfs/xfs_vnodeops.h        |    2
>  6 files changed, 68 insertions(+), 59 deletions(-)
> 
> Index: kern_ci/fs/xfs/dmapi/xfs_dm.c
> ===================================================================
> --- kern_ci.orig/fs/xfs/dmapi/xfs_dm.c
> +++ kern_ci/fs/xfs/dmapi/xfs_dm.c
> @@ -516,8 +516,7 @@ xfs_dm_bulkall_iget_one(
>      xfs_iunlock(ip, XFS_ILOCK_SHARED);
> 
>      memset(&xbuf->dx_attrdata, 0, sizeof(dm_vardata_t));
> -    error = xfs_attr_get(ip, attr_name, attr_buf,
> -                 &value_len, ATTR_ROOT, sys_cred);
> +    error = xfs_attr_get(ip, attr_name, attr_buf, &value_len, ATTR_ROOT);
>      iput(ip->i_vnode);
> 
>      DM_EA_XLATE_ERR(error);
> @@ -1691,8 +1690,8 @@ xfs_dm_get_destroy_dmattr(
>      if (value == NULL)
>          return(-ENOMEM);
> 
> -    error = xfs_attr_get(XFS_I(inode), dkattrname.dan_chars, value, 
> &value_len,
> -                    ATTR_ROOT, sys_cred);
> +    error = xfs_attr_get(XFS_I(inode), dkattrname.dan_chars, value,
> +                            &value_len, ATTR_ROOT);
>      if (error == ERANGE) {
>          kfree(value);
>          alloc_size = value_len;
> @@ -1701,7 +1700,7 @@ xfs_dm_get_destroy_dmattr(
>              return(-ENOMEM);
> 
>          error = xfs_attr_get(XFS_I(inode), dkattrname.dan_chars, value,
> -                    &value_len, ATTR_ROOT, sys_cred);
> +                    &value_len, ATTR_ROOT);
>      }
>      if (error) {
>          kfree(value);
> @@ -1970,7 +1969,7 @@ xfs_dm_get_dmattr(
>      value_len = alloc_size;        /* in/out parameter */
> 
>      error = xfs_attr_get(XFS_I(inode), name.dan_chars, value, &value_len,
> -                    ATTR_ROOT, NULL);
> +                    ATTR_ROOT);
>      DM_EA_XLATE_ERR(error);
> 
>      /* DMAPI requires an errno of ENOENT if an attribute does not exist,
> @@ -2217,7 +2216,7 @@ xfs_dm_getall_dmattr(
> 
>              error = xfs_attr_get(XFS_I(inode), entry->a_name,
>                          (void *)(ulist + 1), &value_len,
> -                        ATTR_ROOT, NULL);
> +                        ATTR_ROOT);
>              DM_EA_XLATE_ERR(error);
> 
>              if (error || value_len != entry->a_valuelen) {
> Index: kern_ci/fs/xfs/linux-2.6/xfs_ioctl.c
> ===================================================================
> --- kern_ci.orig/fs/xfs/linux-2.6/xfs_ioctl.c
> +++ kern_ci/fs/xfs/linux-2.6/xfs_ioctl.c
> @@ -505,14 +505,14 @@ xfs_attrmulti_attr_get(
>  {
>      char            *kbuf;
>      int            error = EFAULT;
> -   
> +
>      if (*len > XATTR_SIZE_MAX)
>          return EINVAL;
>      kbuf = kmalloc(*len, GFP_KERNEL);
>      if (!kbuf)
>          return ENOMEM;
> 
> -    error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags, 
> NULL);
> +    error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
>      if (error)
>          goto out_kfree;
> 
> @@ -548,7 +548,7 @@ xfs_attrmulti_attr_set(
> 
>      if (copy_from_user(kbuf, ubuf, len))
>          goto out_kfree;
> -           
> +
>      error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
> 
>   out_kfree:
> Index: kern_ci/fs/xfs/xfs_acl.c
> ===================================================================
> --- kern_ci.orig/fs/xfs/xfs_acl.c
> +++ kern_ci/fs/xfs/xfs_acl.c
> @@ -341,14 +341,15 @@ xfs_acl_iaccess(
>  {
>      xfs_acl_t    *acl;
>      int        rval;
> +    struct xfs_name    acl_name = {SGI_ACL_FILE, SGI_ACL_FILE_SIZE};
> 
>      if (!(_ACL_ALLOC(acl)))
>          return -1;
> 
>      /* If the file has no ACL return -1. */
>      rval = sizeof(xfs_acl_t);
> -    if (xfs_attr_fetch(ip, SGI_ACL_FILE, SGI_ACL_FILE_SIZE,
> -            (char *)acl, &rval, ATTR_ROOT | ATTR_KERNACCESS, cr)) {
> +    if (xfs_attr_fetch(ip, &acl_name, (char *)acl, &rval,
> +                    ATTR_ROOT | ATTR_KERNACCESS)) {
>          _ACL_FREE(acl);
>          return -1;
>      }
> @@ -595,7 +596,7 @@ xfs_acl_get_attr(
>      *error = xfs_attr_get(xfs_vtoi(vp),
>                      kind == _ACL_TYPE_ACCESS ?
>                      SGI_ACL_FILE : SGI_ACL_DEFAULT,
> -                    (char *)aclp, &len, flags, sys_cred);
> +                    (char *)aclp, &len, flags);
>      if (*error || (flags & ATTR_KERNOVAL))
>          return;
>      xfs_acl_get_endian(aclp);
> Index: kern_ci/fs/xfs/xfs_attr.c
> ===================================================================
> --- kern_ci.orig/fs/xfs/xfs_attr.c
> +++ kern_ci/fs/xfs/xfs_attr.c
> @@ -101,14 +101,28 @@ STATIC int xfs_attr_rmtval_remove(xfs_da
>  ktrace_t *xfs_attr_trace_buf;
>  #endif
> 
> +STATIC int
> +xfs_attr_name_to_xname(
> +    struct xfs_name    *xname,
> +    const char    *aname)
> +{
> +    if (!aname)
> +        return EINVAL;
> +    xname->name = aname;
> +    xname->len = strlen(aname);
> +    if (xname->len >= MAXNAMELEN)
> +        return EFAULT;        /* match IRIX behaviour */
> +
> +    return 0;
> +}
> 
>  /*========================================================================
>   * Overall external interface routines.
>   
> *========================================================================*/
> 
>  int
> -xfs_attr_fetch(xfs_inode_t *ip, const char *name, int namelen,
> -           char *value, int *valuelenp, int flags, struct cred *cred)
> +xfs_attr_fetch(xfs_inode_t *ip, struct xfs_name *name,
> +        char *value, int *valuelenp, int flags)
>  {
>      xfs_da_args_t   args;
>      int             error;
> @@ -122,8 +136,8 @@ xfs_attr_fetch(xfs_inode_t *ip, const ch
>       * Fill in the arg structure for this request.
>       */
>      memset((char *)&args, 0, sizeof(args));
> -    args.name = name;
> -    args.namelen = namelen;
> +    args.name = name->name;
> +    args.namelen = name->len;
>      args.value = value;
>      args.valuelen = *valuelenp;
>      args.flags = flags;

> 
>      XFS_STATS_INC(xs_attr_get);
> 
> -    if (!name)
> -        return(EINVAL);
> -    namelen = strlen(name);
> -    if (namelen >= MAXNAMELEN)
> -        return(EFAULT);        /* match IRIX behaviour */
> -
>      if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>          return(EIO);
> 
> +    error = xfs_attr_name_to_xname(&xname, name);
> +    if (error)
> +        return error;
> +
>      xfs_ilock(ip, XFS_ILOCK_SHARED);
> -    error = xfs_attr_fetch(ip, name, namelen, value, valuelenp, flags, 
> cred);
> +    error = xfs_attr_fetch(ip, &xname, value, valuelenp, flags);
>      xfs_iunlock(ip, XFS_ILOCK_SHARED);
>      return(error);
>  }
> 
> -int
> -xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
> -         char *value, int valuelen, int flags)
> +STATIC int
> +xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
> +        char *value, int valuelen, int flags)
>  {
>      xfs_da_args_t    args;
>      xfs_fsblock_t    firstblock;
> @@ -209,7 +221,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const
>       */
>      if (XFS_IFORK_Q(dp) == 0) {
>          int sf_size = sizeof(xfs_attr_sf_hdr_t) +
> -                  XFS_ATTR_SF_ENTSIZE_BYNAME(namelen, valuelen);
> +                  XFS_ATTR_SF_ENTSIZE_BYNAME(name->len, valuelen);
> 
>          if ((error = xfs_bmap_add_attrfork(dp, sf_size, rsvd)))
>              return(error);
> @@ -219,8 +231,8 @@ xfs_attr_set_int(xfs_inode_t *dp, const
>       * Fill in the arg structure for this request.
>       */
>      memset((char *)&args, 0, sizeof(args));
> -    args.name = name;
> -    args.namelen = namelen;
> +    args.name = name->name;
> +    args.namelen = name->len;
>      args.value = value;
>      args.valuelen = valuelen;
>      args.flags = flags;
> @@ -236,7 +248,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const
>       * Determine space new attribute will use, and if it would be
>       * "local" or "remote" (note: local != inline).
>       */
> -    size = xfs_attr_leaf_newentsize(namelen, valuelen,
> +    size = xfs_attr_leaf_newentsize(name->len, valuelen,
>                      mp->m_sb.sb_blocksize, &local);
> 
>      nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> @@ -429,26 +441,27 @@ xfs_attr_set(
>      int        valuelen,
>      int        flags)
>  {
> -    int             namelen;
> -
> -    namelen = strlen(name);
> -    if (namelen >= MAXNAMELEN)
> -        return EFAULT;        /* match IRIX behaviour */
> +    int             error;
> +    struct xfs_name    xname;
> 
>      XFS_STATS_INC(xs_attr_set);
> 
>      if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>          return (EIO);
> 
> -    return xfs_attr_set_int(dp, name, namelen, value, valuelen, flags);
> +    error = xfs_attr_name_to_xname(&xname, name);
> +    if (error)
> +        return error;
> +
> +    return xfs_attr_set_int(dp, &xname, value, valuelen, flags);
>  }
> 
>  /*
>   * Generic handler routine to remove a name from an attribute list.
>   * Transitions attribute list from Btree to shortform as necessary.
>   */
> -int
> -xfs_attr_remove_int(xfs_inode_t *dp, const char *name, int namelen, int 
> flags)
> +STATIC int
> +xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
>  {
>      xfs_da_args_t    args;
>      xfs_fsblock_t    firstblock;
> @@ -460,8 +473,8 @@ xfs_attr_remove_int(xfs_inode_t *dp, con
>       * Fill in the arg structure for this request.
>       */
>      memset((char *)&args, 0, sizeof(args));
> -    args.name = name;
> -    args.namelen = namelen;
> +    args.name = name->name;
> +    args.namelen = name->len;
>      args.flags = flags;
>      args.hashval = xfs_da_hashname(args.name, args.namelen);
>      args.dp = dp;
> @@ -575,17 +588,18 @@ xfs_attr_remove(
>      const char    *name,
>      int        flags)
>  {
> -    int        namelen;
> -
> -    namelen = strlen(name);
> -    if (namelen >= MAXNAMELEN)
> -        return EFAULT;        /* match IRIX behaviour */
> +    int        error;
> +    struct xfs_name    xname;
> 
>      XFS_STATS_INC(xs_attr_remove);
> 
>      if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>          return (EIO);
> 
> +    error = xfs_attr_name_to_xname(&xname, name);
> +    if (error)
> +        return error;
> +
>      xfs_ilock(dp, XFS_ILOCK_SHARED);
>      if (XFS_IFORK_Q(dp) == 0 ||
>             (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> @@ -595,10 +609,10 @@ xfs_attr_remove(
>      }
>      xfs_iunlock(dp, XFS_ILOCK_SHARED);
> 
> -    return xfs_attr_remove_int(dp, name, namelen, flags);
> +    return xfs_attr_remove_int(dp, &xname, flags);
>  }
> 
> -int                                /* error */
> +STATIC int
>  xfs_attr_list_int(xfs_attr_list_context_t *context)
>  {
>      int error;
> @@ -2522,8 +2536,7 @@ attr_generic_get(
>  {
>      int    error, asize = size;
> 
> -    error = xfs_attr_get(xfs_vtoi(vp), name, data,
> -                    &asize, xflags, NULL);
> +    error = xfs_attr_get(xfs_vtoi(vp), name, data, &asize, xflags);
>      if (!error)
>          return asize;
>      return -error;
> Index: kern_ci/fs/xfs/xfs_attr.h
> ===================================================================
> --- kern_ci.orig/fs/xfs/xfs_attr.h
> +++ kern_ci/fs/xfs/xfs_attr.h
> @@ -158,14 +158,10 @@ struct xfs_da_args;
>  /*
>   * Overall external interface routines.
>   */
> -int xfs_attr_set_int(struct xfs_inode *, const char *, int, char *, 
> int, int);
> -int xfs_attr_remove_int(struct xfs_inode *, const char *, int, int);
> -int xfs_attr_list_int(struct xfs_attr_list_context *);
>  int xfs_attr_inactive(struct xfs_inode *dp);
> 
>  int xfs_attr_shortform_getvalue(struct xfs_da_args *);
> -int xfs_attr_fetch(struct xfs_inode *, const char *, int,
> -            char *, int *, int, struct cred *);
> +int xfs_attr_fetch(struct xfs_inode *, struct xfs_name *, char *, int 
> *, int);
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
> 
>  #endif    /* __XFS_ATTR_H__ */
> Index: kern_ci/fs/xfs/xfs_vnodeops.h
> ===================================================================
> --- kern_ci.orig/fs/xfs/xfs_vnodeops.h
> +++ kern_ci/fs/xfs/xfs_vnodeops.h
> @@ -50,7 +50,7 @@ int xfs_rename(struct xfs_inode *src_dp,
>          struct xfs_inode *src_ip, struct xfs_inode *target_dp,
>          struct xfs_name *target_name, struct xfs_inode *target_ip);
>  int xfs_attr_get(struct xfs_inode *ip, const char *name, char *value,
> -        int *valuelenp, int flags, cred_t *cred);
> +        int *valuelenp, int flags);
>  int xfs_attr_set(struct xfs_inode *dp, const char *name, char *value,
>          int valuelen, int flags);
>  int xfs_attr_remove(struct xfs_inode *dp, const char *name, int flags);
> 

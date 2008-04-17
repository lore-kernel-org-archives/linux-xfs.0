Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Apr 2008 19:35:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3H2YgFu031462
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2008 19:34:45 -0700
Date: Thu, 17 Apr 2008 12:35:36 +1000
Subject: [REVIEW] - cleanup xfs_attr a bit
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------e4TOE9pR9W1Pc1L6bdFs6s
MIME-Version: 1.0
Message-ID: <op.t9qhhmhx3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

------------e4TOE9pR9W1Pc1L6bdFs6s
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

This patch starts using struct xfs_name more for the xattr code and
is another step for using xfs_name in xfs_da_args.

Also, the cred parameter is removed from xfs_attr_get and xfs_attr_fetch.

The new xfs_attr_name_to_name will be a place holder for the Unicode
CI checks/NLS conversion too.

---
  fs/xfs/dmapi/xfs_dm.c        |   13 ++---
  fs/xfs/linux-2.6/xfs_ioctl.c |    6 +-
  fs/xfs/xfs_acl.c             |    7 +-
  fs/xfs/xfs_attr.c            |  103=20=20
+++++++++++++++++++++++--------------------
  fs/xfs/xfs_attr.h            |    6 --
  fs/xfs/xfs_vnodeops.h        |    2
  6 files changed, 71 insertions(+), 66 deletions(-)

Index: kern_ci/fs/xfs/dmapi/xfs_dm.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/dmapi/xfs_dm.c
+++ kern_ci/fs/xfs/dmapi/xfs_dm.c
@@ -516,8 +516,7 @@ xfs_dm_bulkall_iget_one(
  	xfs_iunlock(ip, XFS_ILOCK_SHARED);

  	memset(&xbuf->dx_attrdata, 0, sizeof(dm_vardata_t));
-	error =3D xfs_attr_get(ip, attr_name, attr_buf,
-				 &value_len, ATTR_ROOT, sys_cred);
+	error =3D xfs_attr_get(ip, attr_name, attr_buf, &value_len, ATTR_ROOT);
  	iput(ip->i_vnode);

  	DM_EA_XLATE_ERR(error);
@@ -1691,8 +1690,8 @@ xfs_dm_get_destroy_dmattr(
  	if (value =3D=3D NULL)
  		return(-ENOMEM);

-	error =3D xfs_attr_get(XFS_I(inode), dkattrname.dan_chars, value,=20=20
&value_len,
-					ATTR_ROOT, sys_cred);
+	error =3D xfs_attr_get(XFS_I(inode), dkattrname.dan_chars, value,
+							&value_len, ATTR_ROOT);
  	if (error =3D=3D ERANGE) {
  		kfree(value);
  		alloc_size =3D value_len;
@@ -1701,7 +1700,7 @@ xfs_dm_get_destroy_dmattr(
  			return(-ENOMEM);

  		error =3D xfs_attr_get(XFS_I(inode), dkattrname.dan_chars, value,
-					&value_len, ATTR_ROOT, sys_cred);
+					&value_len, ATTR_ROOT);
  	}
  	if (error) {
  		kfree(value);
@@ -1970,7 +1969,7 @@ xfs_dm_get_dmattr(
  	value_len =3D alloc_size;		/* in/out parameter */

  	error =3D xfs_attr_get(XFS_I(inode), name.dan_chars, value, &value_len,
-					ATTR_ROOT, NULL);
+					ATTR_ROOT);
  	DM_EA_XLATE_ERR(error);

  	/* DMAPI requires an errno of ENOENT if an attribute does not exist,
@@ -2217,7 +2216,7 @@ xfs_dm_getall_dmattr(

  			error =3D xfs_attr_get(XFS_I(inode), entry->a_name,
  						(void *)(ulist + 1), &value_len,
-						ATTR_ROOT, NULL);
+						ATTR_ROOT);
  			DM_EA_XLATE_ERR(error);

  			if (error || value_len !=3D entry->a_valuelen) {
Index: kern_ci/fs/xfs/linux-2.6/xfs_ioctl.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -505,14 +505,14 @@ xfs_attrmulti_attr_get(
  {
  	char			*kbuf;
  	int			error =3D EFAULT;
-=09
+
  	if (*len > XATTR_SIZE_MAX)
  		return EINVAL;
  	kbuf =3D kmalloc(*len, GFP_KERNEL);
  	if (!kbuf)
  		return ENOMEM;

-	error =3D xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags, NULL);
+	error =3D xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
  	if (error)
  		goto out_kfree;

@@ -548,7 +548,7 @@ xfs_attrmulti_attr_set(

  	if (copy_from_user(kbuf, ubuf, len))
  		goto out_kfree;
-=09=09=09
+
  	error =3D xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);

   out_kfree:
Index: kern_ci/fs/xfs/xfs_acl.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_acl.c
+++ kern_ci/fs/xfs/xfs_acl.c
@@ -341,14 +341,15 @@ xfs_acl_iaccess(
  {
  	xfs_acl_t	*acl;
  	int		rval;
+	struct xfs_name	acl_name =3D {SGI_ACL_FILE, SGI_ACL_FILE_SIZE};

  	if (!(_ACL_ALLOC(acl)))
  		return -1;

  	/* If the file has no ACL return -1. */
  	rval =3D sizeof(xfs_acl_t);
-	if (xfs_attr_fetch(ip, SGI_ACL_FILE, SGI_ACL_FILE_SIZE,
-			(char *)acl, &rval, ATTR_ROOT | ATTR_KERNACCESS, cr)) {
+	if (xfs_attr_fetch(ip, &acl_name, (char *)acl, &rval,
+					ATTR_ROOT | ATTR_KERNACCESS)) {
  		_ACL_FREE(acl);
  		return -1;
  	}
@@ -595,7 +596,7 @@ xfs_acl_get_attr(
  	*error =3D xfs_attr_get(xfs_vtoi(vp),
  					kind =3D=3D _ACL_TYPE_ACCESS ?
  					SGI_ACL_FILE : SGI_ACL_DEFAULT,
-					(char *)aclp, &len, flags, sys_cred);
+					(char *)aclp, &len, flags);
  	if (*error || (flags & ATTR_KERNOVAL))
  		return;
  	xfs_acl_get_endian(aclp);
Index: kern_ci/fs/xfs/xfs_attr.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_attr.c
+++ kern_ci/fs/xfs/xfs_attr.c
@@ -101,14 +101,32 @@ STATIC int xfs_attr_rmtval_remove(xfs_da
  ktrace_t *xfs_attr_trace_buf;
  #endif

+STATIC int
+xfs_attr_name_to_name(
+	xfs_inode_t	*ip,
+	struct xfs_name	*xname,
+	const char	*aname)
+{
+	if (!aname)
+		return EINVAL;
+	xname->name =3D aname;
+	xname->len =3D strlen(aname);
+	if (xname->len >=3D MAXNAMELEN)
+		return EFAULT;		/* match IRIX behaviour */
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return EIO;
+
+	return 0;
+}

  /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   * Overall external interface routines.
   *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*/

  int
-xfs_attr_fetch(xfs_inode_t *ip, const char *name, int namelen,
-	       char *value, int *valuelenp, int flags, struct cred *cred)
+xfs_attr_fetch(xfs_inode_t *ip, struct xfs_name *name,
+		char *value, int *valuelenp, int flags)
  {
  	xfs_da_args_t   args;
  	int             error;
@@ -122,8 +140,8 @@ xfs_attr_fetch(xfs_inode_t *ip, const ch
  	 * Fill in the arg structure for this request.
  	 */
  	memset((char *)&args, 0, sizeof(args));
-	args.name =3D name;
-	args.namelen =3D namelen;
+	args.name =3D name->name;
+	args.namelen =3D name->len;
  	args.value =3D value;
  	args.valuelen =3D *valuelenp;
  	args.flags =3D flags;
@@ -162,31 +180,27 @@ xfs_attr_get(
  	const char	*name,
  	char		*value,
  	int		*valuelenp,
-	int		flags,
-	cred_t		*cred)
+	int		flags)
  {
-	int		error, namelen;
+	int		error;
+	struct xfs_name	xname;

  	XFS_STATS_INC(xs_attr_get);

-	if (!name)
-		return(EINVAL);
-	namelen =3D strlen(name);
-	if (namelen >=3D MAXNAMELEN)
-		return(EFAULT);		/* match IRIX behaviour */
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return(EIO);
+	error =3D xfs_attr_name_to_name(ip, &xname, name);
+	if (error)
+		return error;

  	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error =3D xfs_attr_fetch(ip, name, namelen, value, valuelenp, flags, cred=
);
+	error =3D xfs_attr_fetch(ip, &xname, value, valuelenp, flags);
  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return(error);
+
+	return error;
  }

-int
-xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
-		 char *value, int valuelen, int flags)
+STATIC int
+xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
+		char *value, int valuelen, int flags)
  {
  	xfs_da_args_t	args;
  	xfs_fsblock_t	firstblock;
@@ -209,7 +223,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const
  	 */
  	if (XFS_IFORK_Q(dp) =3D=3D 0) {
  		int sf_size =3D sizeof(xfs_attr_sf_hdr_t) +
-			      XFS_ATTR_SF_ENTSIZE_BYNAME(namelen, valuelen);
+			      XFS_ATTR_SF_ENTSIZE_BYNAME(name->len, valuelen);

  		if ((error =3D xfs_bmap_add_attrfork(dp, sf_size, rsvd)))
  			return(error);
@@ -219,8 +233,8 @@ xfs_attr_set_int(xfs_inode_t *dp, const
  	 * Fill in the arg structure for this request.
  	 */
  	memset((char *)&args, 0, sizeof(args));
-	args.name =3D name;
-	args.namelen =3D namelen;
+	args.name =3D name->name;
+	args.namelen =3D name->len;
  	args.value =3D value;
  	args.valuelen =3D valuelen;
  	args.flags =3D flags;
@@ -236,7 +250,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const
  	 * Determine space new attribute will use, and if it would be
  	 * "local" or "remote" (note: local !=3D inline).
  	 */
-	size =3D xfs_attr_leaf_newentsize(namelen, valuelen,
+	size =3D xfs_attr_leaf_newentsize(name->len, valuelen,
  					mp->m_sb.sb_blocksize, &local);

  	nblks =3D XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
@@ -429,26 +443,24 @@ xfs_attr_set(
  	int		valuelen,
  	int		flags)
  {
-	int             namelen;
-
-	namelen =3D strlen(name);
-	if (namelen >=3D MAXNAMELEN)
-		return EFAULT;		/* match IRIX behaviour */
+	int             error;
+	struct xfs_name	xname;

  	XFS_STATS_INC(xs_attr_set);

-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return (EIO);
+	error =3D xfs_attr_name_to_name(dp, &xname, name);
+	if (error)
+		return error;

-	return xfs_attr_set_int(dp, name, namelen, value, valuelen, flags);
+	return xfs_attr_set_int(dp, &xname, value, valuelen, flags);
  }

  /*
   * Generic handler routine to remove a name from an attribute list.
   * Transitions attribute list from Btree to shortform as necessary.
   */
-int
-xfs_attr_remove_int(xfs_inode_t *dp, const char *name, int namelen, int=20=
=20
flags)
+STATIC int
+xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
  {
  	xfs_da_args_t	args;
  	xfs_fsblock_t	firstblock;
@@ -460,8 +472,8 @@ xfs_attr_remove_int(xfs_inode_t *dp, con
  	 * Fill in the arg structure for this request.
  	 */
  	memset((char *)&args, 0, sizeof(args));
-	args.name =3D name;
-	args.namelen =3D namelen;
+	args.name =3D name->name;
+	args.namelen =3D name->len;
  	args.flags =3D flags;
  	args.hashval =3D xfs_da_hashname(args.name, args.namelen);
  	args.dp =3D dp;
@@ -575,16 +587,14 @@ xfs_attr_remove(
  	const char	*name,
  	int		flags)
  {
-	int		namelen;
-
-	namelen =3D strlen(name);
-	if (namelen >=3D MAXNAMELEN)
-		return EFAULT;		/* match IRIX behaviour */
+	int		error;
+	struct xfs_name	xname;

  	XFS_STATS_INC(xs_attr_remove);

-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return (EIO);
+	error =3D xfs_attr_name_to_name(dp, &xname, name);
+	if (error)
+		return error;

  	xfs_ilock(dp, XFS_ILOCK_SHARED);
  	if (XFS_IFORK_Q(dp) =3D=3D 0 ||
@@ -595,10 +605,10 @@ xfs_attr_remove(
  	}
  	xfs_iunlock(dp, XFS_ILOCK_SHARED);

-	return xfs_attr_remove_int(dp, name, namelen, flags);
+	return xfs_attr_remove_int(dp, &xname, flags);
  }

-int								/* error */
+STATIC int
  xfs_attr_list_int(xfs_attr_list_context_t *context)
  {
  	int error;
@@ -2522,8 +2532,7 @@ attr_generic_get(
  {
  	int	error, asize =3D size;

-	error =3D xfs_attr_get(xfs_vtoi(vp), name, data,
-				    &asize, xflags, NULL);
+	error =3D xfs_attr_get(xfs_vtoi(vp), name, data, &asize, xflags);
  	if (!error)
  		return asize;
  	return -error;
Index: kern_ci/fs/xfs/xfs_attr.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_attr.h
+++ kern_ci/fs/xfs/xfs_attr.h
@@ -158,14 +158,10 @@ struct xfs_da_args;
  /*
   * Overall external interface routines.
   */
-int xfs_attr_set_int(struct xfs_inode *, const char *, int, char *, int,=
=20=20
int);
-int xfs_attr_remove_int(struct xfs_inode *, const char *, int, int);
-int xfs_attr_list_int(struct xfs_attr_list_context *);
  int xfs_attr_inactive(struct xfs_inode *dp);

  int xfs_attr_shortform_getvalue(struct xfs_da_args *);
-int xfs_attr_fetch(struct xfs_inode *, const char *, int,
-			char *, int *, int, struct cred *);
+int xfs_attr_fetch(struct xfs_inode *, struct xfs_name *, char *, int *,=
=20=20
int);
  int xfs_attr_rmtval_get(struct xfs_da_args *args);

  #endif	/* __XFS_ATTR_H__ */
Index: kern_ci/fs/xfs/xfs_vnodeops.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_vnodeops.h
+++ kern_ci/fs/xfs/xfs_vnodeops.h
@@ -50,7 +50,7 @@ int xfs_rename(struct xfs_inode *src_dp,
  		struct xfs_inode *src_ip, struct xfs_inode *target_dp,
  		struct xfs_name *target_name, struct xfs_inode *target_ip);
  int xfs_attr_get(struct xfs_inode *ip, const char *name, char *value,
-		int *valuelenp, int flags, cred_t *cred);
+		int *valuelenp, int flags);
  int xfs_attr_set(struct xfs_inode *dp, const char *name, char *value,
  		int valuelen, int flags);
  int xfs_attr_remove(struct xfs_inode *dp, const char *name, int flags);
------------e4TOE9pR9W1Pc1L6bdFs6s
Content-Disposition: attachment; filename=attr_name.patch
Content-Type: text/x-patch; name=attr_name.patch
Content-Transfer-Encoding: Quoted-Printable

---
 fs/xfs/dmapi/xfs_dm.c        |   13 ++---
 fs/xfs/linux-2.6/xfs_ioctl.c |    6 +-
 fs/xfs/xfs_acl.c             |    7 +-
 fs/xfs/xfs_attr.c            |  103 +++++++++++++++++++++++---------------=
-----
 fs/xfs/xfs_attr.h            |    6 --
 fs/xfs/xfs_vnodeops.h        |    2=20
 6 files changed, 71 insertions(+), 66 deletions(-)

Index: kern_ci/fs/xfs/dmapi/xfs_dm.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/dmapi/xfs_dm.c
+++ kern_ci/fs/xfs/dmapi/xfs_dm.c
@@ -516,8 +516,7 @@ xfs_dm_bulkall_iget_one(
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
=20
 	memset(&xbuf->dx_attrdata, 0, sizeof(dm_vardata_t));
-	error =3D xfs_attr_get(ip, attr_name, attr_buf,
-				 &value_len, ATTR_ROOT, sys_cred);
+	error =3D xfs_attr_get(ip, attr_name, attr_buf, &value_len, ATTR_ROOT);
 	iput(ip->i_vnode);
=20
 	DM_EA_XLATE_ERR(error);
@@ -1691,8 +1690,8 @@ xfs_dm_get_destroy_dmattr(
 	if (value =3D=3D NULL)
 		return(-ENOMEM);
=20
-	error =3D xfs_attr_get(XFS_I(inode), dkattrname.dan_chars, value, &value_=
len,
-					ATTR_ROOT, sys_cred);
+	error =3D xfs_attr_get(XFS_I(inode), dkattrname.dan_chars, value,
+							&value_len, ATTR_ROOT);
 	if (error =3D=3D ERANGE) {
 		kfree(value);
 		alloc_size =3D value_len;
@@ -1701,7 +1700,7 @@ xfs_dm_get_destroy_dmattr(
 			return(-ENOMEM);
=20
 		error =3D xfs_attr_get(XFS_I(inode), dkattrname.dan_chars, value,
-					&value_len, ATTR_ROOT, sys_cred);
+					&value_len, ATTR_ROOT);
 	}
 	if (error) {
 		kfree(value);
@@ -1970,7 +1969,7 @@ xfs_dm_get_dmattr(
 	value_len =3D alloc_size;		/* in/out parameter */
=20
 	error =3D xfs_attr_get(XFS_I(inode), name.dan_chars, value, &value_len,
-					ATTR_ROOT, NULL);
+					ATTR_ROOT);
 	DM_EA_XLATE_ERR(error);
=20
 	/* DMAPI requires an errno of ENOENT if an attribute does not exist,
@@ -2217,7 +2216,7 @@ xfs_dm_getall_dmattr(
=20
 			error =3D xfs_attr_get(XFS_I(inode), entry->a_name,
 						(void *)(ulist + 1), &value_len,
-						ATTR_ROOT, NULL);
+						ATTR_ROOT);
 			DM_EA_XLATE_ERR(error);
=20
 			if (error || value_len !=3D entry->a_valuelen) {
Index: kern_ci/fs/xfs/linux-2.6/xfs_ioctl.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -505,14 +505,14 @@ xfs_attrmulti_attr_get(
 {
 	char			*kbuf;
 	int			error =3D EFAULT;
-=09
+
 	if (*len > XATTR_SIZE_MAX)
 		return EINVAL;
 	kbuf =3D kmalloc(*len, GFP_KERNEL);
 	if (!kbuf)
 		return ENOMEM;
=20
-	error =3D xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags, NULL);
+	error =3D xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
 	if (error)
 		goto out_kfree;
=20
@@ -548,7 +548,7 @@ xfs_attrmulti_attr_set(
=20
 	if (copy_from_user(kbuf, ubuf, len))
 		goto out_kfree;
-=09=09=09
+
 	error =3D xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
=20
  out_kfree:
Index: kern_ci/fs/xfs/xfs_acl.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_acl.c
+++ kern_ci/fs/xfs/xfs_acl.c
@@ -341,14 +341,15 @@ xfs_acl_iaccess(
 {
 	xfs_acl_t	*acl;
 	int		rval;
+	struct xfs_name	acl_name =3D {SGI_ACL_FILE, SGI_ACL_FILE_SIZE};
=20
 	if (!(_ACL_ALLOC(acl)))
 		return -1;
=20
 	/* If the file has no ACL return -1. */
 	rval =3D sizeof(xfs_acl_t);
-	if (xfs_attr_fetch(ip, SGI_ACL_FILE, SGI_ACL_FILE_SIZE,
-			(char *)acl, &rval, ATTR_ROOT | ATTR_KERNACCESS, cr)) {
+	if (xfs_attr_fetch(ip, &acl_name, (char *)acl, &rval,
+					ATTR_ROOT | ATTR_KERNACCESS)) {
 		_ACL_FREE(acl);
 		return -1;
 	}
@@ -595,7 +596,7 @@ xfs_acl_get_attr(
 	*error =3D xfs_attr_get(xfs_vtoi(vp),
 					kind =3D=3D _ACL_TYPE_ACCESS ?
 					SGI_ACL_FILE : SGI_ACL_DEFAULT,
-					(char *)aclp, &len, flags, sys_cred);
+					(char *)aclp, &len, flags);
 	if (*error || (flags & ATTR_KERNOVAL))
 		return;
 	xfs_acl_get_endian(aclp);
Index: kern_ci/fs/xfs/xfs_attr.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_attr.c
+++ kern_ci/fs/xfs/xfs_attr.c
@@ -101,14 +101,32 @@ STATIC int xfs_attr_rmtval_remove(xfs_da
 ktrace_t *xfs_attr_trace_buf;
 #endif
=20
+STATIC int
+xfs_attr_name_to_name(
+	xfs_inode_t	*ip,
+	struct xfs_name	*xname,
+	const char	*aname)
+{
+	if (!aname)
+		return EINVAL;
+	xname->name =3D aname;
+	xname->len =3D strlen(aname);
+	if (xname->len >=3D MAXNAMELEN)
+		return EFAULT;		/* match IRIX behaviour */
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return EIO;
+
+	return 0;
+}
=20
 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  * Overall external interface routines.
  *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*/
=20
 int
-xfs_attr_fetch(xfs_inode_t *ip, const char *name, int namelen,
-	       char *value, int *valuelenp, int flags, struct cred *cred)
+xfs_attr_fetch(xfs_inode_t *ip, struct xfs_name *name,
+		char *value, int *valuelenp, int flags)
 {
 	xfs_da_args_t   args;
 	int             error;
@@ -122,8 +140,8 @@ xfs_attr_fetch(xfs_inode_t *ip, const ch
 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.name =3D name;
-	args.namelen =3D namelen;
+	args.name =3D name->name;
+	args.namelen =3D name->len;
 	args.value =3D value;
 	args.valuelen =3D *valuelenp;
 	args.flags =3D flags;
@@ -162,31 +180,27 @@ xfs_attr_get(
 	const char	*name,
 	char		*value,
 	int		*valuelenp,
-	int		flags,
-	cred_t		*cred)
+	int		flags)
 {
-	int		error, namelen;
+	int		error;
+	struct xfs_name	xname;
=20
 	XFS_STATS_INC(xs_attr_get);
=20
-	if (!name)
-		return(EINVAL);
-	namelen =3D strlen(name);
-	if (namelen >=3D MAXNAMELEN)
-		return(EFAULT);		/* match IRIX behaviour */
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return(EIO);
+	error =3D xfs_attr_name_to_name(ip, &xname, name);
+	if (error)
+		return error;
=20
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error =3D xfs_attr_fetch(ip, name, namelen, value, valuelenp, flags, cred=
);
+	error =3D xfs_attr_fetch(ip, &xname, value, valuelenp, flags);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return(error);
+
+	return error;
 }
=20
-int
-xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
-		 char *value, int valuelen, int flags)
+STATIC int
+xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
+		char *value, int valuelen, int flags)
 {
 	xfs_da_args_t	args;
 	xfs_fsblock_t	firstblock;
@@ -209,7 +223,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const=20
 	 */
 	if (XFS_IFORK_Q(dp) =3D=3D 0) {
 		int sf_size =3D sizeof(xfs_attr_sf_hdr_t) +
-			      XFS_ATTR_SF_ENTSIZE_BYNAME(namelen, valuelen);
+			      XFS_ATTR_SF_ENTSIZE_BYNAME(name->len, valuelen);
=20
 		if ((error =3D xfs_bmap_add_attrfork(dp, sf_size, rsvd)))
 			return(error);
@@ -219,8 +233,8 @@ xfs_attr_set_int(xfs_inode_t *dp, const=20
 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.name =3D name;
-	args.namelen =3D namelen;
+	args.name =3D name->name;
+	args.namelen =3D name->len;
 	args.value =3D value;
 	args.valuelen =3D valuelen;
 	args.flags =3D flags;
@@ -236,7 +250,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const=20
 	 * Determine space new attribute will use, and if it would be
 	 * "local" or "remote" (note: local !=3D inline).
 	 */
-	size =3D xfs_attr_leaf_newentsize(namelen, valuelen,
+	size =3D xfs_attr_leaf_newentsize(name->len, valuelen,
 					mp->m_sb.sb_blocksize, &local);
=20
 	nblks =3D XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
@@ -429,26 +443,24 @@ xfs_attr_set(
 	int		valuelen,
 	int		flags)
 {
-	int             namelen;
-
-	namelen =3D strlen(name);
-	if (namelen >=3D MAXNAMELEN)
-		return EFAULT;		/* match IRIX behaviour */
+	int             error;
+	struct xfs_name	xname;
=20
 	XFS_STATS_INC(xs_attr_set);
=20
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return (EIO);
+	error =3D xfs_attr_name_to_name(dp, &xname, name);
+	if (error)
+		return error;
=20
-	return xfs_attr_set_int(dp, name, namelen, value, valuelen, flags);
+	return xfs_attr_set_int(dp, &xname, value, valuelen, flags);
 }
=20
 /*
  * Generic handler routine to remove a name from an attribute list.
  * Transitions attribute list from Btree to shortform as necessary.
  */
-int
-xfs_attr_remove_int(xfs_inode_t *dp, const char *name, int namelen, int fl=
ags)
+STATIC int
+xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 {
 	xfs_da_args_t	args;
 	xfs_fsblock_t	firstblock;
@@ -460,8 +472,8 @@ xfs_attr_remove_int(xfs_inode_t *dp, con
 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.name =3D name;
-	args.namelen =3D namelen;
+	args.name =3D name->name;
+	args.namelen =3D name->len;
 	args.flags =3D flags;
 	args.hashval =3D xfs_da_hashname(args.name, args.namelen);
 	args.dp =3D dp;
@@ -575,16 +587,14 @@ xfs_attr_remove(
 	const char	*name,
 	int		flags)
 {
-	int		namelen;
-
-	namelen =3D strlen(name);
-	if (namelen >=3D MAXNAMELEN)
-		return EFAULT;		/* match IRIX behaviour */
+	int		error;
+	struct xfs_name	xname;
=20
 	XFS_STATS_INC(xs_attr_remove);
=20
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return (EIO);
+	error =3D xfs_attr_name_to_name(dp, &xname, name);
+	if (error)
+		return error;
=20
 	xfs_ilock(dp, XFS_ILOCK_SHARED);
 	if (XFS_IFORK_Q(dp) =3D=3D 0 ||
@@ -595,10 +605,10 @@ xfs_attr_remove(
 	}
 	xfs_iunlock(dp, XFS_ILOCK_SHARED);
=20
-	return xfs_attr_remove_int(dp, name, namelen, flags);
+	return xfs_attr_remove_int(dp, &xname, flags);
 }
=20
-int								/* error */
+STATIC int
 xfs_attr_list_int(xfs_attr_list_context_t *context)
 {
 	int error;
@@ -2522,8 +2532,7 @@ attr_generic_get(
 {
 	int	error, asize =3D size;
=20
-	error =3D xfs_attr_get(xfs_vtoi(vp), name, data,
-				    &asize, xflags, NULL);
+	error =3D xfs_attr_get(xfs_vtoi(vp), name, data, &asize, xflags);
 	if (!error)
 		return asize;
 	return -error;
Index: kern_ci/fs/xfs/xfs_attr.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_attr.h
+++ kern_ci/fs/xfs/xfs_attr.h
@@ -158,14 +158,10 @@ struct xfs_da_args;
 /*
  * Overall external interface routines.
  */
-int xfs_attr_set_int(struct xfs_inode *, const char *, int, char *, int, i=
nt);
-int xfs_attr_remove_int(struct xfs_inode *, const char *, int, int);
-int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_attr_inactive(struct xfs_inode *dp);
=20
 int xfs_attr_shortform_getvalue(struct xfs_da_args *);
-int xfs_attr_fetch(struct xfs_inode *, const char *, int,
-			char *, int *, int, struct cred *);
+int xfs_attr_fetch(struct xfs_inode *, struct xfs_name *, char *, int *, i=
nt);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
=20
 #endif	/* __XFS_ATTR_H__ */
Index: kern_ci/fs/xfs/xfs_vnodeops.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_vnodeops.h
+++ kern_ci/fs/xfs/xfs_vnodeops.h
@@ -50,7 +50,7 @@ int xfs_rename(struct xfs_inode *src_dp,
 		struct xfs_inode *src_ip, struct xfs_inode *target_dp,
 		struct xfs_name *target_name, struct xfs_inode *target_ip);
 int xfs_attr_get(struct xfs_inode *ip, const char *name, char *value,
-		int *valuelenp, int flags, cred_t *cred);
+		int *valuelenp, int flags);
 int xfs_attr_set(struct xfs_inode *dp, const char *name, char *value,
 		int valuelen, int flags);
 int xfs_attr_remove(struct xfs_inode *dp, const char *name, int flags);

------------e4TOE9pR9W1Pc1L6bdFs6s--

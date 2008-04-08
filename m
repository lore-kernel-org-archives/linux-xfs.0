Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 00:36:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m387af7l005554
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 00:36:45 -0700
Date: Tue, 08 Apr 2008 17:38:39 +1000
Subject: [REVIEW #2] cleanup - remove bhv_vname_t
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------mTJiuIKRrFB793e0LEPxBc
MIME-Version: 1.0
Message-ID: <op.t897ipuu3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>

------------mTJiuIKRrFB793e0LEPxBc
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable


Most of the comments by Dave and Christoph have been implemented.

I cleaned up the calls to xfs_dir_canenter in xfs_vnodeops.c and=20=20
xfs_rename.c
but I'm not sure of the "preferred" way of doing this: add resblks to
xfs_dir_canenter, or the following xfs_dir_check_canenter() wrapper in
xfs_dir2.h.

Putting xfs_name in xfs_da_args will involve a much bigger patch
(all the attr code is affected too).

Unresolved comments: "const" xfs_name_dotdot;

---
  fs/dmapi/dmapi_event.c        |    4 -
  fs/dmapi/dmapi_kern.h         |    4 -
  fs/xfs/dmapi/xfs_dm.c         |    6 +-
  fs/xfs/linux-2.6/xfs_export.c |    5 -
  fs/xfs/linux-2.6/xfs_iops.c   |   55 +++++++++++++++------
  fs/xfs/linux-2.6/xfs_vnode.h  |    8 ---
  fs/xfs/xfs_dir2.c             |   57 ++++++++--------------
  fs/xfs/xfs_dir2.h             |   29 +++++++++--
  fs/xfs/xfs_mount.h            |    4 -
  fs/xfs/xfs_rename.c           |   58 ++++++++++------------
  fs/xfs/xfs_utils.c            |    4 -
  fs/xfs/xfs_utils.h            |    4 -
  fs/xfs/xfs_vnodeops.c         |  108=20=20
+++++++++++++++++-------------------------
  fs/xfs/xfs_vnodeops.h         |   25 +++++----
  14 files changed, 191 insertions(+), 180 deletions(-)

Index: kern_ci/fs/dmapi/dmapi_event.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/dmapi/dmapi_event.c
+++ kern_ci/fs/dmapi/dmapi_event.c
@@ -622,8 +622,8 @@ dm_send_namesp_event(
  	dm_right_t	vp1_right,
  	struct inode	*ip2,
  	dm_right_t	vp2_right,
-	char		*name1,
-	char		*name2,
+	const char	*name1,
+	const char	*name2,
  	mode_t		mode,
  	int		retcode,
  	int		flags)
Index: kern_ci/fs/dmapi/dmapi_kern.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/dmapi/dmapi_kern.h
+++ kern_ci/fs/dmapi/dmapi_kern.h
@@ -119,8 +119,8 @@ int		dm_send_namesp_event(
  			dm_right_t	vp1_right,
  			struct inode	*ip2,
  			dm_right_t	vp2_right,
-			char		*name1,
-			char		*name2,
+			const char	*name1,
+			const char	*name2,
  			mode_t		mode,
  			int		retcode,
  			int		flags);
Index: kern_ci/fs/xfs/dmapi/xfs_dm.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/dmapi/xfs_dm.c
+++ kern_ci/fs/xfs/dmapi/xfs_dm.c
@@ -245,7 +245,7 @@ xfs_copyin_attrname(
  	size_t len;

  	strcpy(to->dan_chars, dmattr_prefix);
-
+
          len =3D strnlen_user((char __user *)from, DM_ATTR_NAME_SIZE);
          if (len =3D=3D 0)
              error =3D EFAULT;
@@ -3172,8 +3172,8 @@ xfs_dm_send_namesp_event(
  	dm_right_t	vp1_right,
  	xfs_inode_t	*ip2,
  	dm_right_t	vp2_right,
-	char		*name1,
-	char		*name2,
+	const char	*name1,
+	const char	*name2,
  	mode_t		mode,
  	int		retcode,
  	int		flags)
Index: kern_ci/fs/xfs/linux-2.6/xfs_export.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_export.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_export.c
@@ -22,6 +22,7 @@
  #include "xfs_trans.h"
  #include "xfs_sb.h"
  #include "xfs_ag.h"
+#include "xfs_dir2.h"
  #include "xfs_dmapi.h"
  #include "xfs_mount.h"
  #include "xfs_export.h"
@@ -30,8 +31,6 @@
  #include "xfs_inode.h"
  #include "xfs_vfsops.h"

-static struct dentry dotdot =3D { .d_name.name =3D "..", .d_name.len =3D 2=
, };
-
  /*
   * Note that we only accept fileids which are long enough rather than=20=
=20
allow
   * the parent generation number to default to zero.  XFS considers zero a
@@ -216,7 +215,7 @@ xfs_fs_get_parent(
  	struct xfs_inode	*cip;
  	struct dentry		*parent;

-	error =3D xfs_lookup(XFS_I(child->d_inode), &dotdot, &cip);
+	error =3D xfs_lookup(XFS_I(child->d_inode), &xfs_name_dotdot, &cip);
  	if (unlikely(error))
  		return ERR_PTR(-error);

Index: kern_ci/fs/xfs/linux-2.6/xfs_iops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_iops.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_iops.c
@@ -239,6 +239,15 @@ xfs_init_security(
  	return error;
  }

+static void
+xfs_dentry_to_name(
+	struct xfs_name	*namep,
+	struct dentry	*dentry)
+{
+	namep->name =3D dentry->d_name.name;
+	namep->len =3D dentry->d_name.len;
+}
+
  STATIC void
  xfs_cleanup_inode(
  	struct inode	*dir,
@@ -246,20 +255,19 @@ xfs_cleanup_inode(
  	struct dentry	*dentry,
  	int		mode)
  {
-	struct dentry   teardown =3D {};
+	struct xfs_name	teardown;

  	/* Oh, the horror.
  	 * If we can't add the ACL or we fail in
  	 * xfs_init_security we must back out.
  	 * ENOSPC can hit here, among other things.
  	 */
-	teardown.d_inode =3D inode;
-	teardown.d_name =3D dentry->d_name;
+	xfs_dentry_to_name(&teardown, dentry);

  	if (S_ISDIR(mode))
-		xfs_rmdir(XFS_I(dir), &teardown);
+		xfs_rmdir(XFS_I(dir), &teardown, XFS_I(inode));
  	else
-		xfs_remove(XFS_I(dir), &teardown);
+		xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
  	iput(inode);
  }

@@ -273,6 +281,7 @@ xfs_vn_mknod(
  	struct inode	*inode;
  	struct xfs_inode *ip =3D NULL;
  	xfs_acl_t	*default_acl =3D NULL;
+	struct xfs_name	name;
  	attrexists_t	test_default_acl =3D _ACL_DEFAULT_EXISTS;
  	int		error;

@@ -293,6 +302,8 @@ xfs_vn_mknod(
  		}
  	}

+	xfs_dentry_to_name(&name, dentry);
+
  	if (IS_POSIXACL(dir) && !default_acl)
  		mode &=3D ~current->fs->umask;

@@ -303,10 +314,10 @@ xfs_vn_mknod(
  	case S_IFSOCK:
  		rdev =3D sysv_encode_dev(rdev);
  	case S_IFREG:
-		error =3D xfs_create(XFS_I(dir), dentry, mode, rdev, &ip, NULL);
+		error =3D xfs_create(XFS_I(dir), &name, mode, rdev, &ip, NULL);
  		break;
  	case S_IFDIR:
-		error =3D xfs_mkdir(XFS_I(dir), dentry, mode, &ip, NULL);
+		error =3D xfs_mkdir(XFS_I(dir), &name, mode, &ip, NULL);
  		break;
  	default:
  		error =3D EINVAL;
@@ -371,12 +382,14 @@ xfs_vn_lookup(
  	struct nameidata *nd)
  {
  	struct xfs_inode *cip;
+	struct xfs_name	name;
  	int		error;

  	if (dentry->d_name.len >=3D MAXNAMELEN)
  		return ERR_PTR(-ENAMETOOLONG);

-	error =3D xfs_lookup(XFS_I(dir), dentry, &cip);
+	xfs_dentry_to_name(&name, dentry);
+	error =3D xfs_lookup(XFS_I(dir), &name, &cip);
  	if (unlikely(error)) {
  		if (unlikely(error !=3D ENOENT))
  			return ERR_PTR(-error);
@@ -394,12 +407,14 @@ xfs_vn_link(
  	struct dentry	*dentry)
  {
  	struct inode	*inode;	/* inode of guy being linked to */
+	struct xfs_name	name;
  	int		error;

  	inode =3D old_dentry->d_inode;
+	xfs_dentry_to_name(&name, dentry);

  	igrab(inode);
-	error =3D xfs_link(XFS_I(dir), XFS_I(inode), dentry);
+	error =3D xfs_link(XFS_I(dir), XFS_I(inode), &name);
  	if (unlikely(error)) {
  		iput(inode);
  		return -error;
@@ -417,11 +432,13 @@ xfs_vn_unlink(
  	struct dentry	*dentry)
  {
  	struct inode	*inode;
+	struct xfs_name	name;
  	int		error;

  	inode =3D dentry->d_inode;
+	xfs_dentry_to_name(&name, dentry);

-	error =3D xfs_remove(XFS_I(dir), dentry);
+	error =3D xfs_remove(XFS_I(dir), &name, XFS_I(inode));
  	if (likely(!error)) {
  		xfs_validate_fields(dir);	/* size needs update */
  		xfs_validate_fields(inode);
@@ -437,14 +454,15 @@ xfs_vn_symlink(
  {
  	struct inode	*inode;
  	struct xfs_inode *cip =3D NULL;
+	struct xfs_name	name;
  	int		error;
  	mode_t		mode;

  	mode =3D S_IFLNK |
  		(irix_symlink_mode ? 0777 & ~current->fs->umask : S_IRWXUGO);
+	xfs_dentry_to_name(&name, dentry);

-	error =3D xfs_symlink(XFS_I(dir), dentry, (char *)symname, mode,
-			    &cip, NULL);
+	error =3D xfs_symlink(XFS_I(dir), &name, symname, mode, &cip, NULL);
  	if (unlikely(error))
  		goto out;

@@ -471,9 +489,12 @@ xfs_vn_rmdir(
  	struct dentry	*dentry)
  {
  	struct inode	*inode =3D dentry->d_inode;
+	struct xfs_name	name;
  	int		error;

-	error =3D xfs_rmdir(XFS_I(dir), dentry);
+	xfs_dentry_to_name(&name, dentry);
+
+	error =3D xfs_rmdir(XFS_I(dir), &name, XFS_I(inode));
  	if (likely(!error)) {
  		xfs_validate_fields(inode);
  		xfs_validate_fields(dir);
@@ -489,9 +510,15 @@ xfs_vn_rename(
  	struct dentry	*ndentry)
  {
  	struct inode	*new_inode =3D ndentry->d_inode;
+	struct xfs_name	oname;
+	struct xfs_name	nname;
  	int		error;

-	error =3D xfs_rename(XFS_I(odir), odentry, XFS_I(ndir), ndentry);
+	xfs_dentry_to_name(&oname, odentry);
+	xfs_dentry_to_name(&nname, ndentry);
+
+	error =3D xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
+			   XFS_I(ndir), &nname);
  	if (likely(!error)) {
  		if (new_inode)
  			xfs_validate_fields(new_inode);
Index: kern_ci/fs/xfs/linux-2.6/xfs_vnode.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_vnode.h
+++ kern_ci/fs/xfs/linux-2.6/xfs_vnode.h
@@ -23,7 +23,6 @@ struct bhv_vattr;
  struct xfs_iomap;
  struct attrlist_cursor_kern;

-typedef struct dentry	bhv_vname_t;
  typedef __u64		bhv_vnumber_t;
  typedef struct inode	bhv_vnode_t;

@@ -211,13 +210,6 @@ static inline bhv_vnode_t *vn_grab(bhv_v
  }

  /*
- * Vname handling macros.
- */
-#define VNAME(dentry)		((char *) (dentry)->d_name.name)
-#define VNAMELEN(dentry)	((dentry)->d_name.len)
-#define VNAME_TO_INODE(dentry)	(XFS_I((dentry)->d_inode))
-
-/*
   * Dealing with bad inodes
   */
  static inline int VN_BAD(bhv_vnode_t *vp)
Index: kern_ci/fs/xfs/xfs_dir2.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_dir2.c
+++ kern_ci/fs/xfs/xfs_dir2.c
@@ -44,6 +44,7 @@
  #include "xfs_error.h"
  #include "xfs_vnodeops.h"

+struct xfs_name xfs_name_dotdot =3D {"..", 2};

  void
  xfs_dir_mount(
@@ -146,8 +147,7 @@ int
  xfs_dir_createname(
  	xfs_trans_t		*tp,
  	xfs_inode_t		*dp,
-	char			*name,
-	int			namelen,
+	struct xfs_name		*name,
  	xfs_ino_t		inum,		/* new entry inode number */
  	xfs_fsblock_t		*first,		/* bmap's firstblock */
  	xfs_bmap_free_t		*flist,		/* bmap's freeblock list */
@@ -162,9 +162,9 @@ xfs_dir_createname(
  		return rval;
  	XFS_STATS_INC(xs_dir_create);

-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.name =3D name->name;
+	args.namelen =3D name->len;
+	args.hashval =3D xfs_da_hashname(name->name, name->len);
  	args.inumber =3D inum;
  	args.dp =3D dp;
  	args.firstblock =3D first;
@@ -197,8 +197,7 @@ int
  xfs_dir_lookup(
  	xfs_trans_t	*tp,
  	xfs_inode_t	*dp,
-	char		*name,
-	int		namelen,
+	struct xfs_name	*name,
  	xfs_ino_t	*inum)		/* out: inode number */
  {
  	xfs_da_args_t	args;
@@ -207,18 +206,14 @@ xfs_dir_lookup(

  	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
  	XFS_STATS_INC(xs_dir_lookup);
+	memset(&args, 0, sizeof(xfs_da_args_t));

-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
-	args.inumber =3D 0;
+	args.name =3D name->name;
+	args.namelen =3D name->len;
+	args.hashval =3D xfs_da_hashname(name->name, name->len);
  	args.dp =3D dp;
-	args.firstblock =3D NULL;
-	args.flist =3D NULL;
-	args.total =3D 0;
  	args.whichfork =3D XFS_DATA_FORK;
  	args.trans =3D tp;
-	args.justcheck =3D args.addname =3D 0;
  	args.oknoent =3D 1;

  	if (dp->i_d.di_format =3D=3D XFS_DINODE_FMT_LOCAL)
@@ -247,8 +242,7 @@ int
  xfs_dir_removename(
  	xfs_trans_t	*tp,
  	xfs_inode_t	*dp,
-	char		*name,
-	int		namelen,
+	struct xfs_name	*name,
  	xfs_ino_t	ino,
  	xfs_fsblock_t	*first,		/* bmap's firstblock */
  	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
@@ -261,9 +255,9 @@ xfs_dir_removename(
  	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
  	XFS_STATS_INC(xs_dir_remove);

-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.name =3D name->name;
+	args.namelen =3D name->len;
+	args.hashval =3D xfs_da_hashname(name->name, name->len);
  	args.inumber =3D ino;
  	args.dp =3D dp;
  	args.firstblock =3D first;
@@ -329,8 +323,7 @@ int
  xfs_dir_replace(
  	xfs_trans_t	*tp,
  	xfs_inode_t	*dp,
-	char		*name,		/* name of entry to replace */
-	int		namelen,
+	struct xfs_name	*name,		/* name of entry to replace */
  	xfs_ino_t	inum,		/* new inode number */
  	xfs_fsblock_t	*first,		/* bmap's firstblock */
  	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
@@ -345,9 +338,9 @@ xfs_dir_replace(
  	if ((rval =3D xfs_dir_ino_validate(tp->t_mountp, inum)))
  		return rval;

-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.name =3D name->name;
+	args.namelen =3D name->len;
+	args.hashval =3D xfs_da_hashname(name->name, name->len);
  	args.inumber =3D inum;
  	args.dp =3D dp;
  	args.firstblock =3D first;
@@ -379,23 +372,19 @@ int
  xfs_dir_canenter(
  	xfs_trans_t	*tp,
  	xfs_inode_t	*dp,
-	char		*name,		/* name of entry to add */
-	int		namelen)
+	struct xfs_name	*name)		/* name of entry to add */
  {
  	xfs_da_args_t	args;
  	int		rval;
  	int		v;		/* type-checking value */

  	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
+	memset(&args, 0, sizeof(xfs_da_args_t));

-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
-	args.inumber =3D 0;
+	args.name =3D name->name;
+	args.namelen =3D name->len;
+	args.hashval =3D xfs_da_hashname(name->name, name->len);
  	args.dp =3D dp;
-	args.firstblock =3D NULL;
-	args.flist =3D NULL;
-	args.total =3D 0;
  	args.whichfork =3D XFS_DATA_FORK;
  	args.trans =3D tp;
  	args.justcheck =3D args.addname =3D args.oknoent =3D 1;
Index: kern_ci/fs/xfs/xfs_dir2.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_dir2.h
+++ kern_ci/fs/xfs/xfs_dir2.h
@@ -60,6 +60,16 @@ typedef	__uint32_t	xfs_dir2_db_t;
  typedef	xfs_off_t	xfs_dir2_off_t;

  /*
+ * Counted string for file names.
+ */
+struct xfs_name {
+	const char	*name;
+	int		len;
+};
+
+extern struct xfs_name	xfs_name_dotdot;
+
+/*
   * Generic directory interface routines
   */
  extern void xfs_dir_startup(void);
@@ -68,23 +78,32 @@ extern int xfs_dir_isempty(struct xfs_in
  extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
  				struct xfs_inode *pdp);
  extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
-				char *name, int namelen, xfs_ino_t inum,
+				struct xfs_name *name, xfs_ino_t inum,
  				xfs_fsblock_t *first,
  				struct xfs_bmap_free *flist, xfs_extlen_t tot);
  extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
-				char *name, int namelen, xfs_ino_t *inum);
+				struct xfs_name *name, xfs_ino_t *inum);
  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
-				char *name, int namelen, xfs_ino_t ino,
+				struct xfs_name *name, xfs_ino_t ino,
  				xfs_fsblock_t *first,
  				struct xfs_bmap_free *flist, xfs_extlen_t tot);
  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
-				char *name, int namelen, xfs_ino_t inum,
+				struct xfs_name *name, xfs_ino_t inum,
  				xfs_fsblock_t *first,
  				struct xfs_bmap_free *flist, xfs_extlen_t tot);
  extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
-				char *name, int namelen);
+				struct xfs_name *name);
  extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);

+static inline int
+xfs_dir_check_canenter(uint resblks, struct xfs_trans *tp,
+				struct xfs_inode *dp, struct xfs_name *name)
+{
+	if (resblks)
+		return 0;
+	return xfs_dir_canenter(tp, dp, name);;
+}
+
  /*
   * Utility routines for v2 directories.
   */
Index: kern_ci/fs/xfs/xfs_mount.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_mount.h
+++ kern_ci/fs/xfs/xfs_mount.h
@@ -73,7 +73,7 @@ typedef int	(*xfs_send_destroy_t)(struct
  typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct xfs_mount *,
  			struct xfs_inode *, dm_right_t,
  			struct xfs_inode *, dm_right_t,
-			char *, char *, mode_t, int, int);
+			const char *, const char *, mode_t, int, int);
  typedef int	(*xfs_send_mount_t)(struct xfs_mount *, dm_right_t,
  			char *, char *);
  typedef void	(*xfs_send_unmount_t)(struct xfs_mount *, struct xfs_inode *,
@@ -401,7 +401,7 @@ typedef struct xfs_mount {

  /*
   * Allow large block sizes to be reported to userspace programs if the
- * "largeio" mount option is used.
+ * "largeio" mount option is used.
   *
   * If compatibility mode is specified, simply return the basic unit of=20=
=20
caching
   * so that we don't get inefficient read/modify/write I/O from user apps.
Index: kern_ci/fs/xfs/xfs_rename.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_rename.c
+++ kern_ci/fs/xfs/xfs_rename.c
@@ -83,17 +83,16 @@ int xfs_rename_skip, xfs_rename_nskip;
   */
  STATIC int
  xfs_lock_for_rename(
-	xfs_inode_t	*dp1,	/* old (source) directory inode */
-	xfs_inode_t	*dp2,	/* new (target) directory inode */
-	bhv_vname_t	*vname1,/* old entry name */
-	bhv_vname_t	*vname2,/* new entry name */
-	xfs_inode_t	**ipp1,	/* inode of old entry */
-	xfs_inode_t	**ipp2,	/* inode of new entry, if it
+	xfs_inode_t	*dp1,	/* in: old (source) directory inode */
+	xfs_inode_t	*dp2,	/* in: new (target) directory inode */
+	struct xfs_name	*name2,	/* in: new entry name */
+	xfs_inode_t	**ipp1,	/* in/out: inode of old entry */
+	xfs_inode_t	**ipp2,	/* out: inode of new entry, if it
  				   already exists, NULL otherwise. */
-	xfs_inode_t	**i_tab,/* array of inode returned, sorted */
-	int		*num_inodes)  /* number of inodes in array */
+	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
+	int		*num_inodes)  /* out: number of inodes in array */
  {
-	xfs_inode_t		*ip1 =3D VNAME_TO_INODE(vname1);
+	xfs_inode_t		*ip1;
  	xfs_inode_t		*ip2, *temp;
  	xfs_ino_t		inum1, inum2;
  	int			error;
@@ -101,7 +100,9 @@ xfs_lock_for_rename(
  	uint			lock_mode;
  	int			diff_dirs =3D (dp1 !=3D dp2);

+	ip1 =3D *ipp1;
  	ip2 =3D NULL;
+	ASSERT(ip1);

  	/*
  	 * First, find out the current inums of the entries so that we
@@ -125,7 +126,7 @@ xfs_lock_for_rename(
  		lock_mode =3D xfs_ilock_map_shared(dp2);
  	}

-	error =3D xfs_dir_lookup_int(dp2, lock_mode, vname2, &inum2, &ip2);
+	error =3D xfs_dir_lookup_int(dp2, lock_mode, name2, &inum2, &ip2);
  	if (error =3D=3D ENOENT) {		/* target does not need to exist. */
  		inum2 =3D 0;
  	} else if (error) {
@@ -218,12 +219,13 @@ xfs_lock_for_rename(
  int
  xfs_rename(
  	xfs_inode_t	*src_dp,
-	bhv_vname_t	*src_vname,
+	struct xfs_name	*src_name,
+	xfs_inode_t	*src_ip,
  	xfs_inode_t	*target_dp,
-	bhv_vname_t	*target_vname)
+	struct xfs_name	*target_name)
  {
  	xfs_trans_t	*tp;
-	xfs_inode_t	*src_ip, *target_ip;
+	xfs_inode_t	*target_ip;
  	xfs_mount_t	*mp =3D src_dp->i_mount;
  	int		new_parent;		/* moving to a new dir */
  	int		src_is_directory;	/* src_name is a directory */
@@ -237,10 +239,6 @@ xfs_rename(
  	int		spaceres;
  	int		target_link_zero =3D 0;
  	int		num_inodes;
-	char		*src_name =3D VNAME(src_vname);
-	char		*target_name =3D VNAME(target_vname);
-	int		src_namelen =3D VNAMELEN(src_vname);
-	int		target_namelen =3D VNAMELEN(target_vname);

  	xfs_itrace_entry(src_dp);
  	xfs_itrace_entry(target_dp);
@@ -250,7 +248,7 @@ xfs_rename(
  		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_RENAME,
  					src_dp, DM_RIGHT_NULL,
  					target_dp, DM_RIGHT_NULL,
-					src_name, target_name,
+					src_name->name, target_name->name,
  					0, 0, 0);
  		if (error) {
  			return error;
@@ -267,9 +265,8 @@ xfs_rename(
  	 * does not exist in the source directory.
  	 */
  	tp =3D NULL;
-	error =3D xfs_lock_for_rename(src_dp, target_dp, src_vname,
-			target_vname, &src_ip, &target_ip, inodes,
-			&num_inodes);
+	error =3D xfs_lock_for_rename(src_dp, target_dp, target_name,
+			&src_ip, &target_ip, inodes, &num_inodes);

  	if (error) {
  		/*
@@ -316,7 +313,7 @@ xfs_rename(
  	XFS_BMAP_INIT(&free_list, &first_block);
  	tp =3D xfs_trans_alloc(mp, XFS_TRANS_RENAME);
  	cancel_flags =3D XFS_TRANS_RELEASE_LOG_RES;
-	spaceres =3D XFS_RENAME_SPACE_RES(mp, target_namelen);
+	spaceres =3D XFS_RENAME_SPACE_RES(mp, target_name->len);
  	error =3D xfs_trans_reserve(tp, spaceres, XFS_RENAME_LOG_RES(mp), 0,
  			XFS_TRANS_PERM_LOG_RES, XFS_RENAME_LOG_COUNT);
  	if (error =3D=3D ENOSPC) {
@@ -374,9 +371,9 @@ xfs_rename(
  		 * If there's no space reservation, check the entry will
  		 * fit before actually inserting it.
  		 */
-		if (spaceres =3D=3D 0 &&
-		    (error =3D xfs_dir_canenter(tp, target_dp, target_name,
-						target_namelen)))
+		error =3D xfs_dir_check_canenter(spaceres, tp, target_dp,
+						target_name);
+		if (error)
  			goto error_return;
  		/*
  		 * If target does not exist and the rename crosses
@@ -384,7 +381,7 @@ xfs_rename(
  		 * to account for the ".." reference from the new entry.
  		 */
  		error =3D xfs_dir_createname(tp, target_dp, target_name,
-					   target_namelen, src_ip->i_ino,
+					   src_ip->i_ino,
  					   &first_block, &free_list, spaceres);
  		if (error =3D=3D ENOSPC)
  			goto error_return;
@@ -424,7 +421,7 @@ xfs_rename(
  		 * name at the destination directory, remove it first.
  		 */
  		error =3D xfs_dir_replace(tp, target_dp, target_name,
-					target_namelen, src_ip->i_ino,
+					src_ip->i_ino,
  					&first_block, &free_list, spaceres);
  		if (error)
  			goto abort_return;
@@ -461,7 +458,8 @@ xfs_rename(
  		 * Rewrite the ".." entry to point to the new
  		 * directory.
  		 */
-		error =3D xfs_dir_replace(tp, src_ip, "..", 2, target_dp->i_ino,
+		error =3D xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
+					target_dp->i_ino,
  					&first_block, &free_list, spaceres);
  		ASSERT(error !=3D EEXIST);
  		if (error)
@@ -497,7 +495,7 @@ xfs_rename(
  			goto abort_return;
  	}

-	error =3D xfs_dir_removename(tp, src_dp, src_name, src_namelen,
+	error =3D xfs_dir_removename(tp, src_dp, src_name,
  			src_ip->i_ino, &first_block, &free_list, spaceres);
  	if (error)
  		goto abort_return;
@@ -583,7 +581,7 @@ std_return:
  		(void) XFS_SEND_NAMESP (mp, DM_EVENT_POSTRENAME,
  					src_dp, DM_RIGHT_NULL,
  					target_dp, DM_RIGHT_NULL,
-					src_name, target_name,
+					src_name->name, target_name->name,
  					0, error, 0);
  	}
  	return error;
Index: kern_ci/fs/xfs/xfs_utils.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_utils.c
+++ kern_ci/fs/xfs/xfs_utils.c
@@ -45,7 +45,7 @@ int
  xfs_dir_lookup_int(
  	xfs_inode_t	*dp,
  	uint		lock_mode,
-	bhv_vname_t	*dentry,
+	struct xfs_name	*name,
  	xfs_ino_t	*inum,
  	xfs_inode_t	**ipp)
  {
@@ -53,7 +53,7 @@ xfs_dir_lookup_int(

  	xfs_itrace_entry(dp);

-	error =3D xfs_dir_lookup(NULL, dp, VNAME(dentry), VNAMELEN(dentry), inum);
+	error =3D xfs_dir_lookup(NULL, dp, name, inum);
  	if (!error) {
  		/*
  		 * Unlock the directory. We do this because we can't
Index: kern_ci/fs/xfs/xfs_utils.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_utils.h
+++ kern_ci/fs/xfs/xfs_utils.h
@@ -21,8 +21,8 @@
  #define IRELE(ip)	VN_RELE(XFS_ITOV(ip))
  #define IHOLD(ip)	VN_HOLD(XFS_ITOV(ip))

-extern int xfs_dir_lookup_int (xfs_inode_t *, uint, bhv_vname_t *,=20=20
xfs_ino_t *,
-				xfs_inode_t **);
+extern int xfs_dir_lookup_int (xfs_inode_t *, uint, struct xfs_name *,
+				xfs_ino_t *, xfs_inode_t **);
  extern int xfs_truncate_file (xfs_mount_t *, xfs_inode_t *);
  extern int xfs_dir_ialloc (xfs_trans_t **, xfs_inode_t *, mode_t,=20=20
xfs_nlink_t,
  				xfs_dev_t, cred_t *, prid_t, int,
Index: kern_ci/fs/xfs/xfs_vnodeops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_vnodeops.c
+++ kern_ci/fs/xfs/xfs_vnodeops.c
@@ -1762,7 +1762,7 @@ xfs_inactive(
  int
  xfs_lookup(
  	xfs_inode_t		*dp,
-	bhv_vname_t		*dentry,
+	struct xfs_name		*name,
  	xfs_inode_t		**ipp)
  {
  	xfs_inode_t		*ip;
@@ -1776,7 +1776,7 @@ xfs_lookup(
  		return XFS_ERROR(EIO);

  	lock_mode =3D xfs_ilock_map_shared(dp);
-	error =3D xfs_dir_lookup_int(dp, lock_mode, dentry, &e_inum, &ip);
+	error =3D xfs_dir_lookup_int(dp, lock_mode, name, &e_inum, &ip);
  	if (!error) {
  		*ipp =3D ip;
  		xfs_itrace_ref(ip);
@@ -1788,13 +1788,12 @@ xfs_lookup(
  int
  xfs_create(
  	xfs_inode_t		*dp,
-	bhv_vname_t		*dentry,
+	struct xfs_name		*name,
  	mode_t			mode,
  	xfs_dev_t		rdev,
  	xfs_inode_t		**ipp,
  	cred_t			*credp)
  {
-	char			*name =3D VNAME(dentry);
  	xfs_mount_t	        *mp =3D dp->i_mount;
  	xfs_inode_t		*ip;
  	xfs_trans_t		*tp;
@@ -1808,17 +1807,14 @@ xfs_create(
  	xfs_prid_t		prid;
  	struct xfs_dquot	*udqp, *gdqp;
  	uint			resblks;
-	int			namelen;

  	ASSERT(!*ipp);
  	xfs_itrace_entry(dp);

-	namelen =3D VNAMELEN(dentry);
-
  	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
  		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
  				dp, DM_RIGHT_NULL, NULL,
-				DM_RIGHT_NULL, name, NULL,
+				DM_RIGHT_NULL, name->name, NULL,
  				mode, 0, 0);

  		if (error)
@@ -1850,7 +1846,7 @@ xfs_create(

  	tp =3D xfs_trans_alloc(mp, XFS_TRANS_CREATE);
  	cancel_flags =3D XFS_TRANS_RELEASE_LOG_RES;
-	resblks =3D XFS_CREATE_SPACE_RES(mp, namelen);
+	resblks =3D XFS_CREATE_SPACE_RES(mp, name->len);
  	/*
  	 * Initially assume that the file does not exist and
  	 * reserve the resources for that case.  If that is not
@@ -1883,7 +1879,8 @@ xfs_create(
  	if (error)
  		goto error_return;

-	if (resblks =3D=3D 0 && (error =3D xfs_dir_canenter(tp, dp, name, namelen=
)))
+	error =3D xfs_dir_check_canenter(resblks, tp, dp, name);
+	if (error)
  		goto error_return;
  	error =3D xfs_dir_ialloc(&tp, dp, mode, 1,
  			rdev, credp, prid, resblks > 0,
@@ -1913,7 +1910,7 @@ xfs_create(
  	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
  	unlock_dp_on_error =3D B_FALSE;

-	error =3D xfs_dir_createname(tp, dp, name, namelen, ip->i_ino,
+	error =3D xfs_dir_createname(tp, dp, name, ip->i_ino,
  					&first_block, &free_list, resblks ?
  					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
  	if (error) {
@@ -1974,7 +1971,7 @@ std_return:
  		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE,
  			dp, DM_RIGHT_NULL,
  			*ipp ? ip : NULL,
-			DM_RIGHT_NULL, name, NULL,
+			DM_RIGHT_NULL, name->name, NULL,
  			mode, error, 0);
  	}
  	return error;
@@ -2266,12 +2263,10 @@ int remove_which_error_return =3D 0;
  int
  xfs_remove(
  	xfs_inode_t             *dp,
-	bhv_vname_t		*dentry)
+	struct xfs_name		*name,
+	xfs_inode_t		*ip)
  {
-	char			*name =3D VNAME(dentry);
  	xfs_mount_t		*mp =3D dp->i_mount;
-	xfs_inode_t             *ip =3D VNAME_TO_INODE(dentry);
-	int			namelen =3D VNAMELEN(dentry);
  	xfs_trans_t             *tp =3D NULL;
  	int                     error =3D 0;
  	xfs_bmap_free_t         free_list;
@@ -2287,9 +2282,9 @@ xfs_remove(
  		return XFS_ERROR(EIO);

  	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
-		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dp,
-					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
-					name, NULL, ip->i_d.di_mode, 0, 0);
+		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dp, DM_RIGHT_NULL,
+					NULL, DM_RIGHT_NULL, name->name, NULL,
+					ip->i_d.di_mode, 0, 0);
  		if (error)
  			return error;
  	}
@@ -2374,7 +2369,7 @@ xfs_remove(
  	 * Entry must exist since we did a lookup in xfs_lock_dir_and_entry.
  	 */
  	XFS_BMAP_INIT(&free_list, &first_block);
-	error =3D xfs_dir_removename(tp, dp, name, namelen, ip->i_ino,
+	error =3D xfs_dir_removename(tp, dp, name, ip->i_ino,
  					&first_block, &free_list, 0);
  	if (error) {
  		ASSERT(error !=3D ENOENT);
@@ -2442,7 +2437,7 @@ xfs_remove(
  		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE,
  				dp, DM_RIGHT_NULL,
  				NULL, DM_RIGHT_NULL,
-				name, NULL, ip->i_d.di_mode, error, 0);
+				name->name, NULL, ip->i_d.di_mode, error, 0);
  	}
  	return error;

@@ -2472,7 +2467,7 @@ int
  xfs_link(
  	xfs_inode_t		*tdp,
  	xfs_inode_t		*sip,
-	bhv_vname_t		*dentry)
+	struct xfs_name		*target_name)
  {
  	xfs_mount_t		*mp =3D tdp->i_mount;
  	xfs_trans_t		*tp;
@@ -2483,13 +2478,10 @@ xfs_link(
  	int			cancel_flags;
  	int			committed;
  	int			resblks;
-	char			*target_name =3D VNAME(dentry);
-	int			target_namelen;

  	xfs_itrace_entry(tdp);
  	xfs_itrace_entry(sip);

-	target_namelen =3D VNAMELEN(dentry);
  	ASSERT(!S_ISDIR(sip->i_d.di_mode));

  	if (XFS_FORCED_SHUTDOWN(mp))
@@ -2499,7 +2491,7 @@ xfs_link(
  		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_LINK,
  					tdp, DM_RIGHT_NULL,
  					sip, DM_RIGHT_NULL,
-					target_name, NULL, 0, 0, 0);
+					target_name->name, NULL, 0, 0, 0);
  		if (error)
  			return error;
  	}
@@ -2514,7 +2506,7 @@ xfs_link(

  	tp =3D xfs_trans_alloc(mp, XFS_TRANS_LINK);
  	cancel_flags =3D XFS_TRANS_RELEASE_LOG_RES;
-	resblks =3D XFS_LINK_SPACE_RES(mp, target_namelen);
+	resblks =3D XFS_LINK_SPACE_RES(mp, target_name->len);
  	error =3D xfs_trans_reserve(tp, resblks, XFS_LINK_LOG_RES(mp), 0,
  			XFS_TRANS_PERM_LOG_RES, XFS_LINK_LOG_COUNT);
  	if (error =3D=3D ENOSPC) {
@@ -2566,13 +2558,13 @@ xfs_link(
  		goto error_return;
  	}

-	if (resblks =3D=3D 0 &&
-	    (error =3D xfs_dir_canenter(tp, tdp, target_name, target_namelen)))
+	error =3D xfs_dir_check_canenter(resblks, tp, tdp, target_name);
+	if (error)
  		goto error_return;

  	XFS_BMAP_INIT(&free_list, &first_block);

-	error =3D xfs_dir_createname(tp, tdp, target_name, target_namelen,
+	error =3D xfs_dir_createname(tp, tdp, target_name,
  				   sip->i_ino, &first_block, &free_list,
  				   resblks);
  	if (error)
@@ -2610,7 +2602,7 @@ std_return:
  		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTLINK,
  				tdp, DM_RIGHT_NULL,
  				sip, DM_RIGHT_NULL,
-				target_name, NULL, 0, error, 0);
+				target_name->name, NULL, 0, error, 0);
  	}
  	return error;

@@ -2627,13 +2619,11 @@ std_return:
  int
  xfs_mkdir(
  	xfs_inode_t             *dp,
-	bhv_vname_t		*dentry,
+	struct xfs_name		*dir_name,
  	mode_t			mode,
  	xfs_inode_t		**ipp,
  	cred_t			*credp)
  {
-	char			*dir_name =3D VNAME(dentry);
-	int			dir_namelen =3D VNAMELEN(dentry);
  	xfs_mount_t		*mp =3D dp->i_mount;
  	xfs_inode_t		*cdp;	/* inode of created dir */
  	xfs_trans_t		*tp;
@@ -2657,7 +2647,7 @@ xfs_mkdir(
  	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
  		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
  					dp, DM_RIGHT_NULL, NULL,
-					DM_RIGHT_NULL, dir_name, NULL,
+					DM_RIGHT_NULL, dir_name->name, NULL,
  					mode, 0, 0);
  		if (error)
  			return error;
@@ -2686,7 +2676,7 @@ xfs_mkdir(

  	tp =3D xfs_trans_alloc(mp, XFS_TRANS_MKDIR);
  	cancel_flags =3D XFS_TRANS_RELEASE_LOG_RES;
-	resblks =3D XFS_MKDIR_SPACE_RES(mp, dir_namelen);
+	resblks =3D XFS_MKDIR_SPACE_RES(mp, dir_name->len);
  	error =3D xfs_trans_reserve(tp, resblks, XFS_MKDIR_LOG_RES(mp), 0,
  				  XFS_TRANS_PERM_LOG_RES, XFS_MKDIR_LOG_COUNT);
  	if (error =3D=3D ENOSPC) {
@@ -2718,8 +2708,8 @@ xfs_mkdir(
  	if (error)
  		goto error_return;

-	if (resblks =3D=3D 0 &&
-	    (error =3D xfs_dir_canenter(tp, dp, dir_name, dir_namelen)))
+	error =3D xfs_dir_check_canenter(resblks, tp, dp, dir_name);
+	if (error)
  		goto error_return;
  	/*
  	 * create the directory inode.
@@ -2748,7 +2738,7 @@ xfs_mkdir(

  	XFS_BMAP_INIT(&free_list, &first_block);

-	error =3D xfs_dir_createname(tp, dp, dir_name, dir_namelen, cdp->i_ino,
+	error =3D xfs_dir_createname(tp, dp, dir_name, cdp->i_ino,
  				   &first_block, &free_list, resblks ?
  				   resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
  	if (error) {
@@ -2815,7 +2805,7 @@ std_return:
  					dp, DM_RIGHT_NULL,
  					created ? cdp : NULL,
  					DM_RIGHT_NULL,
-					dir_name, NULL,
+					dir_name->name, NULL,
  					mode, error, 0);
  	}
  	return error;
@@ -2839,13 +2829,11 @@ std_return:
  int
  xfs_rmdir(
  	xfs_inode_t             *dp,
-	bhv_vname_t		*dentry)
+	struct xfs_name		*name,
+	xfs_inode_t		*cdp)
  {
  	bhv_vnode_t		*dir_vp =3D XFS_ITOV(dp);
-	char			*name =3D VNAME(dentry);
-	int			namelen =3D VNAMELEN(dentry);
  	xfs_mount_t		*mp =3D dp->i_mount;
-  	xfs_inode_t             *cdp =3D VNAME_TO_INODE(dentry);
  	xfs_trans_t             *tp;
  	int                     error;
  	xfs_bmap_free_t         free_list;
@@ -2863,8 +2851,8 @@ xfs_rmdir(
  	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
  		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE,
  					dp, DM_RIGHT_NULL,
-					NULL, DM_RIGHT_NULL,
-					name, NULL, cdp->i_d.di_mode, 0, 0);
+					NULL, DM_RIGHT_NULL, name->name,
+					NULL, cdp->i_d.di_mode, 0, 0);
  		if (error)
  			return XFS_ERROR(error);
  	}
@@ -2958,7 +2946,7 @@ xfs_rmdir(
  		goto error_return;
  	}

-	error =3D xfs_dir_removename(tp, dp, name, namelen, cdp->i_ino,
+	error =3D xfs_dir_removename(tp, dp, name, cdp->i_ino,
  					&first_block, &free_list, resblks);
  	if (error)
  		goto error1;
@@ -3038,7 +3026,7 @@ xfs_rmdir(
  		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE,
  					dp, DM_RIGHT_NULL,
  					NULL, DM_RIGHT_NULL,
-					name, NULL, cdp->i_d.di_mode,
+					name->name, NULL, cdp->i_d.di_mode,
  					error, 0);
  	}
  	return error;
@@ -3056,8 +3044,8 @@ xfs_rmdir(
  int
  xfs_symlink(
  	xfs_inode_t		*dp,
-	bhv_vname_t		*dentry,
-	char			*target_path,
+	struct xfs_name		*link_name,
+	const char		*target_path,
  	mode_t			mode,
  	xfs_inode_t		**ipp,
  	cred_t			*credp)
@@ -3077,15 +3065,13 @@ xfs_symlink(
  	int			nmaps;
  	xfs_bmbt_irec_t		mval[SYMLINK_MAPS];
  	xfs_daddr_t		d;
-	char			*cur_chunk;
+	const char		*cur_chunk;
  	int			byte_cnt;
  	int			n;
  	xfs_buf_t		*bp;
  	xfs_prid_t		prid;
  	struct xfs_dquot	*udqp, *gdqp;
  	uint			resblks;
-	char			*link_name =3D VNAME(dentry);
-	int			link_namelen;

  	*ipp =3D NULL;
  	error =3D 0;
@@ -3097,8 +3083,6 @@ xfs_symlink(
  	if (XFS_FORCED_SHUTDOWN(mp))
  		return XFS_ERROR(EIO);

-	link_namelen =3D VNAMELEN(dentry);
-
  	/*
  	 * Check component lengths of the target path name.
  	 */
@@ -3134,7 +3118,7 @@ xfs_symlink(
  	if (DM_EVENT_ENABLED(dp, DM_EVENT_SYMLINK)) {
  		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_SYMLINK, dp,
  					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
-					link_name, target_path, 0, 0, 0);
+					link_name->name, target_path, 0, 0, 0);
  		if (error)
  			return error;
  	}
@@ -3166,7 +3150,7 @@ xfs_symlink(
  		fs_blocks =3D 0;
  	else
  		fs_blocks =3D XFS_B_TO_FSB(mp, pathlen);
-	resblks =3D XFS_SYMLINK_SPACE_RES(mp, link_namelen, fs_blocks);
+	resblks =3D XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
  	error =3D xfs_trans_reserve(tp, resblks, XFS_SYMLINK_LOG_RES(mp), 0,
  			XFS_TRANS_PERM_LOG_RES, XFS_SYMLINK_LOG_COUNT);
  	if (error =3D=3D ENOSPC && fs_blocks =3D=3D 0) {
@@ -3200,8 +3184,8 @@ xfs_symlink(
  	/*
  	 * Check for ability to enter directory entry, if no space reserved.
  	 */
-	if (resblks =3D=3D 0 &&
-	    (error =3D xfs_dir_canenter(tp, dp, link_name, link_namelen)))
+	error =3D xfs_dir_check_canenter(resblks, tp, dp, link_name);
+	if (error)
  		goto error_return;
  	/*
  	 * Initialize the bmap freelist prior to calling either
@@ -3293,7 +3277,7 @@ xfs_symlink(
  	/*
  	 * Create the directory entry for the symlink.
  	 */
-	error =3D xfs_dir_createname(tp, dp, link_name, link_namelen, ip->i_ino,
+	error =3D xfs_dir_createname(tp, dp, link_name, ip->i_ino,
  				   &first_block, &free_list, resblks);
  	if (error)
  		goto error1;
@@ -3338,8 +3322,8 @@ std_return:
  		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTSYMLINK,
  					dp, DM_RIGHT_NULL,
  					error ? NULL : ip,
-					DM_RIGHT_NULL, link_name, target_path,
-					0, error, 0);
+					DM_RIGHT_NULL, link_name->name,
+					target_path, 0, error, 0);
  	}

  	if (!error)
Index: kern_ci/fs/xfs/xfs_vnodeops.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_vnodeops.h
+++ kern_ci/fs/xfs/xfs_vnodeops.h
@@ -12,7 +12,7 @@ struct pipe_inode_info;
  struct uio;
  struct xfs_inode;
  struct xfs_iomap;
-
+struct xfs_name;

  int xfs_open(struct xfs_inode *ip);
  int xfs_getattr(struct xfs_inode *ip, struct bhv_vattr *vap, int flags);
@@ -23,20 +23,22 @@ int xfs_fsync(struct xfs_inode *ip, int
  		xfs_off_t stop);
  int xfs_release(struct xfs_inode *ip);
  int xfs_inactive(struct xfs_inode *ip);
-int xfs_lookup(struct xfs_inode *dp, bhv_vname_t *dentry,
+int xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
  		struct xfs_inode **ipp);
-int xfs_create(struct xfs_inode *dp, bhv_vname_t *dentry, mode_t mode,
+int xfs_create(struct xfs_inode *dp, struct xfs_name *name, mode_t mode,
  		xfs_dev_t rdev, struct xfs_inode **ipp, struct cred *credp);
-int xfs_remove(struct xfs_inode *dp, bhv_vname_t	*dentry);
+int xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
  int xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
-		bhv_vname_t *dentry);
-int xfs_mkdir(struct xfs_inode *dp, bhv_vname_t *dentry,
+		struct xfs_name *target_name);
+int xfs_mkdir(struct xfs_inode *dp, struct xfs_name *dir_name,
  		mode_t mode, struct xfs_inode **ipp, struct cred *credp);
-int xfs_rmdir(struct xfs_inode *dp, bhv_vname_t *dentry);
+int xfs_rmdir(struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *cdp);
  int xfs_readdir(struct xfs_inode	*dp, void *dirent, size_t bufsize,
  		       xfs_off_t *offset, filldir_t filldir);
-int xfs_symlink(struct xfs_inode *dp, bhv_vname_t *dentry,
-		char *target_path, mode_t mode, struct xfs_inode **ipp,
+int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
+		const char *target_path, mode_t mode, struct xfs_inode **ipp,
  		struct cred *credp);
  int xfs_inode_flush(struct xfs_inode *ip, int flags);
  int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
@@ -44,8 +46,9 @@ int xfs_reclaim(struct xfs_inode *ip);
  int xfs_change_file_space(struct xfs_inode *ip, int cmd,
  		xfs_flock64_t *bf, xfs_off_t offset,
  		struct cred *credp, int	attr_flags);
-int xfs_rename(struct xfs_inode *src_dp, bhv_vname_t *src_vname,
-		struct xfs_inode *target_dp, bhv_vname_t *target_vname);
+int xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
+		struct xfs_inode *src_ip, struct xfs_inode *target_dp,
+		struct xfs_name *target_name);
  int xfs_attr_get(struct xfs_inode *ip, const char *name, char *value,
  		int *valuelenp, int flags, cred_t *cred);
  int xfs_attr_set(struct xfs_inode *dp, const char *name, char *value,
------------mTJiuIKRrFB793e0LEPxBc
Content-Disposition: attachment; filename=remove_bhv_vname.patch
Content-Type: text/x-patch; name=remove_bhv_vname.patch
Content-Transfer-Encoding: Quoted-Printable

---
 fs/dmapi/dmapi_event.c        |    4 -
 fs/dmapi/dmapi_kern.h         |    4 -
 fs/xfs/dmapi/xfs_dm.c         |    6 +-
 fs/xfs/linux-2.6/xfs_export.c |    5 -
 fs/xfs/linux-2.6/xfs_iops.c   |   55 +++++++++++++++------
 fs/xfs/linux-2.6/xfs_vnode.h  |    8 ---
 fs/xfs/xfs_dir2.c             |   57 ++++++++--------------
 fs/xfs/xfs_dir2.h             |   29 +++++++++--
 fs/xfs/xfs_mount.h            |    4 -
 fs/xfs/xfs_rename.c           |   58 ++++++++++------------
 fs/xfs/xfs_utils.c            |    4 -
 fs/xfs/xfs_utils.h            |    4 -
 fs/xfs/xfs_vnodeops.c         |  108 +++++++++++++++++--------------------=
-----
 fs/xfs/xfs_vnodeops.h         |   25 +++++----
 14 files changed, 191 insertions(+), 180 deletions(-)

Index: kern_ci/fs/dmapi/dmapi_event.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/dmapi/dmapi_event.c
+++ kern_ci/fs/dmapi/dmapi_event.c
@@ -622,8 +622,8 @@ dm_send_namesp_event(
 	dm_right_t	vp1_right,
 	struct inode	*ip2,
 	dm_right_t	vp2_right,
-	char		*name1,
-	char		*name2,
+	const char	*name1,
+	const char	*name2,
 	mode_t		mode,
 	int		retcode,
 	int		flags)
Index: kern_ci/fs/dmapi/dmapi_kern.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/dmapi/dmapi_kern.h
+++ kern_ci/fs/dmapi/dmapi_kern.h
@@ -119,8 +119,8 @@ int		dm_send_namesp_event(
 			dm_right_t	vp1_right,
 			struct inode	*ip2,
 			dm_right_t	vp2_right,
-			char		*name1,
-			char		*name2,
+			const char	*name1,
+			const char	*name2,
 			mode_t		mode,
 			int		retcode,
 			int		flags);
Index: kern_ci/fs/xfs/dmapi/xfs_dm.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/dmapi/xfs_dm.c
+++ kern_ci/fs/xfs/dmapi/xfs_dm.c
@@ -245,7 +245,7 @@ xfs_copyin_attrname(
 	size_t len;
=20
 	strcpy(to->dan_chars, dmattr_prefix);
-=20=20=20=20=20=20=20=20
+
         len =3D strnlen_user((char __user *)from, DM_ATTR_NAME_SIZE);
         if (len =3D=3D 0)
             error =3D EFAULT;
@@ -3172,8 +3172,8 @@ xfs_dm_send_namesp_event(
 	dm_right_t	vp1_right,
 	xfs_inode_t	*ip2,
 	dm_right_t	vp2_right,
-	char		*name1,
-	char		*name2,
+	const char	*name1,
+	const char	*name2,
 	mode_t		mode,
 	int		retcode,
 	int		flags)
Index: kern_ci/fs/xfs/linux-2.6/xfs_export.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_export.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_export.c
@@ -22,6 +22,7 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
+#include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_export.h"
@@ -30,8 +31,6 @@
 #include "xfs_inode.h"
 #include "xfs_vfsops.h"
=20
-static struct dentry dotdot =3D { .d_name.name =3D "..", .d_name.len =3D 2=
, };
-
 /*
  * Note that we only accept fileids which are long enough rather than allow
  * the parent generation number to default to zero.  XFS considers zero a
@@ -216,7 +215,7 @@ xfs_fs_get_parent(
 	struct xfs_inode	*cip;
 	struct dentry		*parent;
=20
-	error =3D xfs_lookup(XFS_I(child->d_inode), &dotdot, &cip);
+	error =3D xfs_lookup(XFS_I(child->d_inode), &xfs_name_dotdot, &cip);
 	if (unlikely(error))
 		return ERR_PTR(-error);
=20
Index: kern_ci/fs/xfs/linux-2.6/xfs_iops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_iops.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_iops.c
@@ -239,6 +239,15 @@ xfs_init_security(
 	return error;
 }
=20
+static void
+xfs_dentry_to_name(
+	struct xfs_name	*namep,
+	struct dentry	*dentry)
+{
+	namep->name =3D dentry->d_name.name;
+	namep->len =3D dentry->d_name.len;
+}
+
 STATIC void
 xfs_cleanup_inode(
 	struct inode	*dir,
@@ -246,20 +255,19 @@ xfs_cleanup_inode(
 	struct dentry	*dentry,
 	int		mode)
 {
-	struct dentry   teardown =3D {};
+	struct xfs_name	teardown;
=20
 	/* Oh, the horror.
 	 * If we can't add the ACL or we fail in
 	 * xfs_init_security we must back out.
 	 * ENOSPC can hit here, among other things.
 	 */
-	teardown.d_inode =3D inode;
-	teardown.d_name =3D dentry->d_name;
+	xfs_dentry_to_name(&teardown, dentry);
=20
 	if (S_ISDIR(mode))
-		xfs_rmdir(XFS_I(dir), &teardown);
+		xfs_rmdir(XFS_I(dir), &teardown, XFS_I(inode));
 	else
-		xfs_remove(XFS_I(dir), &teardown);
+		xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
 	iput(inode);
 }
=20
@@ -273,6 +281,7 @@ xfs_vn_mknod(
 	struct inode	*inode;
 	struct xfs_inode *ip =3D NULL;
 	xfs_acl_t	*default_acl =3D NULL;
+	struct xfs_name	name;
 	attrexists_t	test_default_acl =3D _ACL_DEFAULT_EXISTS;
 	int		error;
=20
@@ -293,6 +302,8 @@ xfs_vn_mknod(
 		}
 	}
=20
+	xfs_dentry_to_name(&name, dentry);
+
 	if (IS_POSIXACL(dir) && !default_acl)
 		mode &=3D ~current->fs->umask;
=20
@@ -303,10 +314,10 @@ xfs_vn_mknod(
 	case S_IFSOCK:
 		rdev =3D sysv_encode_dev(rdev);
 	case S_IFREG:
-		error =3D xfs_create(XFS_I(dir), dentry, mode, rdev, &ip, NULL);
+		error =3D xfs_create(XFS_I(dir), &name, mode, rdev, &ip, NULL);
 		break;
 	case S_IFDIR:
-		error =3D xfs_mkdir(XFS_I(dir), dentry, mode, &ip, NULL);
+		error =3D xfs_mkdir(XFS_I(dir), &name, mode, &ip, NULL);
 		break;
 	default:
 		error =3D EINVAL;
@@ -371,12 +382,14 @@ xfs_vn_lookup(
 	struct nameidata *nd)
 {
 	struct xfs_inode *cip;
+	struct xfs_name	name;
 	int		error;
=20
 	if (dentry->d_name.len >=3D MAXNAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
=20
-	error =3D xfs_lookup(XFS_I(dir), dentry, &cip);
+	xfs_dentry_to_name(&name, dentry);
+	error =3D xfs_lookup(XFS_I(dir), &name, &cip);
 	if (unlikely(error)) {
 		if (unlikely(error !=3D ENOENT))
 			return ERR_PTR(-error);
@@ -394,12 +407,14 @@ xfs_vn_link(
 	struct dentry	*dentry)
 {
 	struct inode	*inode;	/* inode of guy being linked to */
+	struct xfs_name	name;
 	int		error;
=20
 	inode =3D old_dentry->d_inode;
+	xfs_dentry_to_name(&name, dentry);
=20
 	igrab(inode);
-	error =3D xfs_link(XFS_I(dir), XFS_I(inode), dentry);
+	error =3D xfs_link(XFS_I(dir), XFS_I(inode), &name);
 	if (unlikely(error)) {
 		iput(inode);
 		return -error;
@@ -417,11 +432,13 @@ xfs_vn_unlink(
 	struct dentry	*dentry)
 {
 	struct inode	*inode;
+	struct xfs_name	name;
 	int		error;
=20
 	inode =3D dentry->d_inode;
+	xfs_dentry_to_name(&name, dentry);
=20
-	error =3D xfs_remove(XFS_I(dir), dentry);
+	error =3D xfs_remove(XFS_I(dir), &name, XFS_I(inode));
 	if (likely(!error)) {
 		xfs_validate_fields(dir);	/* size needs update */
 		xfs_validate_fields(inode);
@@ -437,14 +454,15 @@ xfs_vn_symlink(
 {
 	struct inode	*inode;
 	struct xfs_inode *cip =3D NULL;
+	struct xfs_name	name;
 	int		error;
 	mode_t		mode;
=20
 	mode =3D S_IFLNK |
 		(irix_symlink_mode ? 0777 & ~current->fs->umask : S_IRWXUGO);
+	xfs_dentry_to_name(&name, dentry);
=20
-	error =3D xfs_symlink(XFS_I(dir), dentry, (char *)symname, mode,
-			    &cip, NULL);
+	error =3D xfs_symlink(XFS_I(dir), &name, symname, mode, &cip, NULL);
 	if (unlikely(error))
 		goto out;
=20
@@ -471,9 +489,12 @@ xfs_vn_rmdir(
 	struct dentry	*dentry)
 {
 	struct inode	*inode =3D dentry->d_inode;
+	struct xfs_name	name;
 	int		error;
=20
-	error =3D xfs_rmdir(XFS_I(dir), dentry);
+	xfs_dentry_to_name(&name, dentry);
+
+	error =3D xfs_rmdir(XFS_I(dir), &name, XFS_I(inode));
 	if (likely(!error)) {
 		xfs_validate_fields(inode);
 		xfs_validate_fields(dir);
@@ -489,9 +510,15 @@ xfs_vn_rename(
 	struct dentry	*ndentry)
 {
 	struct inode	*new_inode =3D ndentry->d_inode;
+	struct xfs_name	oname;
+	struct xfs_name	nname;
 	int		error;
=20
-	error =3D xfs_rename(XFS_I(odir), odentry, XFS_I(ndir), ndentry);
+	xfs_dentry_to_name(&oname, odentry);
+	xfs_dentry_to_name(&nname, ndentry);
+
+	error =3D xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
+			   XFS_I(ndir), &nname);
 	if (likely(!error)) {
 		if (new_inode)
 			xfs_validate_fields(new_inode);
Index: kern_ci/fs/xfs/linux-2.6/xfs_vnode.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_vnode.h
+++ kern_ci/fs/xfs/linux-2.6/xfs_vnode.h
@@ -23,7 +23,6 @@ struct bhv_vattr;
 struct xfs_iomap;
 struct attrlist_cursor_kern;
=20
-typedef struct dentry	bhv_vname_t;
 typedef __u64		bhv_vnumber_t;
 typedef struct inode	bhv_vnode_t;
=20
@@ -211,13 +210,6 @@ static inline bhv_vnode_t *vn_grab(bhv_v
 }
=20
 /*
- * Vname handling macros.
- */
-#define VNAME(dentry)		((char *) (dentry)->d_name.name)
-#define VNAMELEN(dentry)	((dentry)->d_name.len)
-#define VNAME_TO_INODE(dentry)	(XFS_I((dentry)->d_inode))
-
-/*
  * Dealing with bad inodes
  */
 static inline int VN_BAD(bhv_vnode_t *vp)
Index: kern_ci/fs/xfs/xfs_dir2.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_dir2.c
+++ kern_ci/fs/xfs/xfs_dir2.c
@@ -44,6 +44,7 @@
 #include "xfs_error.h"
 #include "xfs_vnodeops.h"
=20
+struct xfs_name xfs_name_dotdot =3D {"..", 2};
=20
 void
 xfs_dir_mount(
@@ -146,8 +147,7 @@ int
 xfs_dir_createname(
 	xfs_trans_t		*tp,
 	xfs_inode_t		*dp,
-	char			*name,
-	int			namelen,
+	struct xfs_name		*name,
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_fsblock_t		*first,		/* bmap's firstblock */
 	xfs_bmap_free_t		*flist,		/* bmap's freeblock list */
@@ -162,9 +162,9 @@ xfs_dir_createname(
 		return rval;
 	XFS_STATS_INC(xs_dir_create);
=20
-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.name =3D name->name;
+	args.namelen =3D name->len;
+	args.hashval =3D xfs_da_hashname(name->name, name->len);
 	args.inumber =3D inum;
 	args.dp =3D dp;
 	args.firstblock =3D first;
@@ -197,8 +197,7 @@ int
 xfs_dir_lookup(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*dp,
-	char		*name,
-	int		namelen,
+	struct xfs_name	*name,
 	xfs_ino_t	*inum)		/* out: inode number */
 {
 	xfs_da_args_t	args;
@@ -207,18 +206,14 @@ xfs_dir_lookup(
=20
 	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
 	XFS_STATS_INC(xs_dir_lookup);
+	memset(&args, 0, sizeof(xfs_da_args_t));
=20
-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
-	args.inumber =3D 0;
+	args.name =3D name->name;
+	args.namelen =3D name->len;
+	args.hashval =3D xfs_da_hashname(name->name, name->len);
 	args.dp =3D dp;
-	args.firstblock =3D NULL;
-	args.flist =3D NULL;
-	args.total =3D 0;
 	args.whichfork =3D XFS_DATA_FORK;
 	args.trans =3D tp;
-	args.justcheck =3D args.addname =3D 0;
 	args.oknoent =3D 1;
=20
 	if (dp->i_d.di_format =3D=3D XFS_DINODE_FMT_LOCAL)
@@ -247,8 +242,7 @@ int
 xfs_dir_removename(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*dp,
-	char		*name,
-	int		namelen,
+	struct xfs_name	*name,
 	xfs_ino_t	ino,
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
 	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
@@ -261,9 +255,9 @@ xfs_dir_removename(
 	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
 	XFS_STATS_INC(xs_dir_remove);
=20
-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.name =3D name->name;
+	args.namelen =3D name->len;
+	args.hashval =3D xfs_da_hashname(name->name, name->len);
 	args.inumber =3D ino;
 	args.dp =3D dp;
 	args.firstblock =3D first;
@@ -329,8 +323,7 @@ int
 xfs_dir_replace(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*dp,
-	char		*name,		/* name of entry to replace */
-	int		namelen,
+	struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t	inum,		/* new inode number */
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
 	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
@@ -345,9 +338,9 @@ xfs_dir_replace(
 	if ((rval =3D xfs_dir_ino_validate(tp->t_mountp, inum)))
 		return rval;
=20
-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.name =3D name->name;
+	args.namelen =3D name->len;
+	args.hashval =3D xfs_da_hashname(name->name, name->len);
 	args.inumber =3D inum;
 	args.dp =3D dp;
 	args.firstblock =3D first;
@@ -379,23 +372,19 @@ int
 xfs_dir_canenter(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*dp,
-	char		*name,		/* name of entry to add */
-	int		namelen)
+	struct xfs_name	*name)		/* name of entry to add */
 {
 	xfs_da_args_t	args;
 	int		rval;
 	int		v;		/* type-checking value */
=20
 	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
+	memset(&args, 0, sizeof(xfs_da_args_t));
=20
-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
-	args.inumber =3D 0;
+	args.name =3D name->name;
+	args.namelen =3D name->len;
+	args.hashval =3D xfs_da_hashname(name->name, name->len);
 	args.dp =3D dp;
-	args.firstblock =3D NULL;
-	args.flist =3D NULL;
-	args.total =3D 0;
 	args.whichfork =3D XFS_DATA_FORK;
 	args.trans =3D tp;
 	args.justcheck =3D args.addname =3D args.oknoent =3D 1;
Index: kern_ci/fs/xfs/xfs_dir2.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_dir2.h
+++ kern_ci/fs/xfs/xfs_dir2.h
@@ -60,6 +60,16 @@ typedef	__uint32_t	xfs_dir2_db_t;
 typedef	xfs_off_t	xfs_dir2_off_t;
=20
 /*
+ * Counted string for file names.
+ */
+struct xfs_name {
+	const char	*name;
+	int		len;
+};
+
+extern struct xfs_name	xfs_name_dotdot;
+
+/*
  * Generic directory interface routines
  */
 extern void xfs_dir_startup(void);
@@ -68,23 +78,32 @@ extern int xfs_dir_isempty(struct xfs_in
 extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
-				char *name, int namelen, xfs_ino_t inum,
+				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
 				struct xfs_bmap_free *flist, xfs_extlen_t tot);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
-				char *name, int namelen, xfs_ino_t *inum);
+				struct xfs_name *name, xfs_ino_t *inum);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
-				char *name, int namelen, xfs_ino_t ino,
+				struct xfs_name *name, xfs_ino_t ino,
 				xfs_fsblock_t *first,
 				struct xfs_bmap_free *flist, xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
-				char *name, int namelen, xfs_ino_t inum,
+				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
 				struct xfs_bmap_free *flist, xfs_extlen_t tot);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
-				char *name, int namelen);
+				struct xfs_name *name);
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
=20
+static inline int
+xfs_dir_check_canenter(uint resblks, struct xfs_trans *tp,
+				struct xfs_inode *dp, struct xfs_name *name)
+{
+	if (resblks)
+		return 0;
+	return xfs_dir_canenter(tp, dp, name);;
+}
+
 /*
  * Utility routines for v2 directories.
  */
Index: kern_ci/fs/xfs/xfs_mount.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_mount.h
+++ kern_ci/fs/xfs/xfs_mount.h
@@ -73,7 +73,7 @@ typedef int	(*xfs_send_destroy_t)(struct
 typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct xfs_mount *,
 			struct xfs_inode *, dm_right_t,
 			struct xfs_inode *, dm_right_t,
-			char *, char *, mode_t, int, int);
+			const char *, const char *, mode_t, int, int);
 typedef int	(*xfs_send_mount_t)(struct xfs_mount *, dm_right_t,
 			char *, char *);
 typedef void	(*xfs_send_unmount_t)(struct xfs_mount *, struct xfs_inode *,
@@ -401,7 +401,7 @@ typedef struct xfs_mount {
=20
 /*
  * Allow large block sizes to be reported to userspace programs if the
- * "largeio" mount option is used.=20
+ * "largeio" mount option is used.
  *
  * If compatibility mode is specified, simply return the basic unit of cac=
hing
  * so that we don't get inefficient read/modify/write I/O from user apps.
Index: kern_ci/fs/xfs/xfs_rename.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_rename.c
+++ kern_ci/fs/xfs/xfs_rename.c
@@ -83,17 +83,16 @@ int xfs_rename_skip, xfs_rename_nskip;
  */
 STATIC int
 xfs_lock_for_rename(
-	xfs_inode_t	*dp1,	/* old (source) directory inode */
-	xfs_inode_t	*dp2,	/* new (target) directory inode */
-	bhv_vname_t	*vname1,/* old entry name */
-	bhv_vname_t	*vname2,/* new entry name */
-	xfs_inode_t	**ipp1,	/* inode of old entry */
-	xfs_inode_t	**ipp2,	/* inode of new entry, if it
+	xfs_inode_t	*dp1,	/* in: old (source) directory inode */
+	xfs_inode_t	*dp2,	/* in: new (target) directory inode */
+	struct xfs_name	*name2,	/* in: new entry name */
+	xfs_inode_t	**ipp1,	/* in/out: inode of old entry */
+	xfs_inode_t	**ipp2,	/* out: inode of new entry, if it
 				   already exists, NULL otherwise. */
-	xfs_inode_t	**i_tab,/* array of inode returned, sorted */
-	int		*num_inodes)  /* number of inodes in array */
+	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
+	int		*num_inodes)  /* out: number of inodes in array */
 {
-	xfs_inode_t		*ip1 =3D VNAME_TO_INODE(vname1);
+	xfs_inode_t		*ip1;
 	xfs_inode_t		*ip2, *temp;
 	xfs_ino_t		inum1, inum2;
 	int			error;
@@ -101,7 +100,9 @@ xfs_lock_for_rename(
 	uint			lock_mode;
 	int			diff_dirs =3D (dp1 !=3D dp2);
=20
+	ip1 =3D *ipp1;
 	ip2 =3D NULL;
+	ASSERT(ip1);
=20
 	/*
 	 * First, find out the current inums of the entries so that we
@@ -125,7 +126,7 @@ xfs_lock_for_rename(
 		lock_mode =3D xfs_ilock_map_shared(dp2);
 	}
=20
-	error =3D xfs_dir_lookup_int(dp2, lock_mode, vname2, &inum2, &ip2);
+	error =3D xfs_dir_lookup_int(dp2, lock_mode, name2, &inum2, &ip2);
 	if (error =3D=3D ENOENT) {		/* target does not need to exist. */
 		inum2 =3D 0;
 	} else if (error) {
@@ -218,12 +219,13 @@ xfs_lock_for_rename(
 int
 xfs_rename(
 	xfs_inode_t	*src_dp,
-	bhv_vname_t	*src_vname,
+	struct xfs_name	*src_name,
+	xfs_inode_t	*src_ip,
 	xfs_inode_t	*target_dp,
-	bhv_vname_t	*target_vname)
+	struct xfs_name	*target_name)
 {
 	xfs_trans_t	*tp;
-	xfs_inode_t	*src_ip, *target_ip;
+	xfs_inode_t	*target_ip;
 	xfs_mount_t	*mp =3D src_dp->i_mount;
 	int		new_parent;		/* moving to a new dir */
 	int		src_is_directory;	/* src_name is a directory */
@@ -237,10 +239,6 @@ xfs_rename(
 	int		spaceres;
 	int		target_link_zero =3D 0;
 	int		num_inodes;
-	char		*src_name =3D VNAME(src_vname);
-	char		*target_name =3D VNAME(target_vname);
-	int		src_namelen =3D VNAMELEN(src_vname);
-	int		target_namelen =3D VNAMELEN(target_vname);
=20
 	xfs_itrace_entry(src_dp);
 	xfs_itrace_entry(target_dp);
@@ -250,7 +248,7 @@ xfs_rename(
 		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_RENAME,
 					src_dp, DM_RIGHT_NULL,
 					target_dp, DM_RIGHT_NULL,
-					src_name, target_name,
+					src_name->name, target_name->name,
 					0, 0, 0);
 		if (error) {
 			return error;
@@ -267,9 +265,8 @@ xfs_rename(
 	 * does not exist in the source directory.
 	 */
 	tp =3D NULL;
-	error =3D xfs_lock_for_rename(src_dp, target_dp, src_vname,
-			target_vname, &src_ip, &target_ip, inodes,
-			&num_inodes);
+	error =3D xfs_lock_for_rename(src_dp, target_dp, target_name,
+			&src_ip, &target_ip, inodes, &num_inodes);
=20
 	if (error) {
 		/*
@@ -316,7 +313,7 @@ xfs_rename(
 	XFS_BMAP_INIT(&free_list, &first_block);
 	tp =3D xfs_trans_alloc(mp, XFS_TRANS_RENAME);
 	cancel_flags =3D XFS_TRANS_RELEASE_LOG_RES;
-	spaceres =3D XFS_RENAME_SPACE_RES(mp, target_namelen);
+	spaceres =3D XFS_RENAME_SPACE_RES(mp, target_name->len);
 	error =3D xfs_trans_reserve(tp, spaceres, XFS_RENAME_LOG_RES(mp), 0,
 			XFS_TRANS_PERM_LOG_RES, XFS_RENAME_LOG_COUNT);
 	if (error =3D=3D ENOSPC) {
@@ -374,9 +371,9 @@ xfs_rename(
 		 * If there's no space reservation, check the entry will
 		 * fit before actually inserting it.
 		 */
-		if (spaceres =3D=3D 0 &&
-		    (error =3D xfs_dir_canenter(tp, target_dp, target_name,
-						target_namelen)))
+		error =3D xfs_dir_check_canenter(spaceres, tp, target_dp,
+						target_name);
+		if (error)
 			goto error_return;
 		/*
 		 * If target does not exist and the rename crosses
@@ -384,7 +381,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error =3D xfs_dir_createname(tp, target_dp, target_name,
-					   target_namelen, src_ip->i_ino,
+					   src_ip->i_ino,
 					   &first_block, &free_list, spaceres);
 		if (error =3D=3D ENOSPC)
 			goto error_return;
@@ -424,7 +421,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error =3D xfs_dir_replace(tp, target_dp, target_name,
-					target_namelen, src_ip->i_ino,
+					src_ip->i_ino,
 					&first_block, &free_list, spaceres);
 		if (error)
 			goto abort_return;
@@ -461,7 +458,8 @@ xfs_rename(
 		 * Rewrite the ".." entry to point to the new
 		 * directory.
 		 */
-		error =3D xfs_dir_replace(tp, src_ip, "..", 2, target_dp->i_ino,
+		error =3D xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
+					target_dp->i_ino,
 					&first_block, &free_list, spaceres);
 		ASSERT(error !=3D EEXIST);
 		if (error)
@@ -497,7 +495,7 @@ xfs_rename(
 			goto abort_return;
 	}
=20
-	error =3D xfs_dir_removename(tp, src_dp, src_name, src_namelen,
+	error =3D xfs_dir_removename(tp, src_dp, src_name,
 			src_ip->i_ino, &first_block, &free_list, spaceres);
 	if (error)
 		goto abort_return;
@@ -583,7 +581,7 @@ std_return:
 		(void) XFS_SEND_NAMESP (mp, DM_EVENT_POSTRENAME,
 					src_dp, DM_RIGHT_NULL,
 					target_dp, DM_RIGHT_NULL,
-					src_name, target_name,
+					src_name->name, target_name->name,
 					0, error, 0);
 	}
 	return error;
Index: kern_ci/fs/xfs/xfs_utils.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_utils.c
+++ kern_ci/fs/xfs/xfs_utils.c
@@ -45,7 +45,7 @@ int
 xfs_dir_lookup_int(
 	xfs_inode_t	*dp,
 	uint		lock_mode,
-	bhv_vname_t	*dentry,
+	struct xfs_name	*name,
 	xfs_ino_t	*inum,
 	xfs_inode_t	**ipp)
 {
@@ -53,7 +53,7 @@ xfs_dir_lookup_int(
=20
 	xfs_itrace_entry(dp);
=20
-	error =3D xfs_dir_lookup(NULL, dp, VNAME(dentry), VNAMELEN(dentry), inum);
+	error =3D xfs_dir_lookup(NULL, dp, name, inum);
 	if (!error) {
 		/*
 		 * Unlock the directory. We do this because we can't
Index: kern_ci/fs/xfs/xfs_utils.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_utils.h
+++ kern_ci/fs/xfs/xfs_utils.h
@@ -21,8 +21,8 @@
 #define IRELE(ip)	VN_RELE(XFS_ITOV(ip))
 #define IHOLD(ip)	VN_HOLD(XFS_ITOV(ip))
=20
-extern int xfs_dir_lookup_int (xfs_inode_t *, uint, bhv_vname_t *, xfs_ino=
_t *,
-				xfs_inode_t **);
+extern int xfs_dir_lookup_int (xfs_inode_t *, uint, struct xfs_name *,
+				xfs_ino_t *, xfs_inode_t **);
 extern int xfs_truncate_file (xfs_mount_t *, xfs_inode_t *);
 extern int xfs_dir_ialloc (xfs_trans_t **, xfs_inode_t *, mode_t, xfs_nlin=
k_t,
 				xfs_dev_t, cred_t *, prid_t, int,
Index: kern_ci/fs/xfs/xfs_vnodeops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_vnodeops.c
+++ kern_ci/fs/xfs/xfs_vnodeops.c
@@ -1762,7 +1762,7 @@ xfs_inactive(
 int
 xfs_lookup(
 	xfs_inode_t		*dp,
-	bhv_vname_t		*dentry,
+	struct xfs_name		*name,
 	xfs_inode_t		**ipp)
 {
 	xfs_inode_t		*ip;
@@ -1776,7 +1776,7 @@ xfs_lookup(
 		return XFS_ERROR(EIO);
=20
 	lock_mode =3D xfs_ilock_map_shared(dp);
-	error =3D xfs_dir_lookup_int(dp, lock_mode, dentry, &e_inum, &ip);
+	error =3D xfs_dir_lookup_int(dp, lock_mode, name, &e_inum, &ip);
 	if (!error) {
 		*ipp =3D ip;
 		xfs_itrace_ref(ip);
@@ -1788,13 +1788,12 @@ xfs_lookup(
 int
 xfs_create(
 	xfs_inode_t		*dp,
-	bhv_vname_t		*dentry,
+	struct xfs_name		*name,
 	mode_t			mode,
 	xfs_dev_t		rdev,
 	xfs_inode_t		**ipp,
 	cred_t			*credp)
 {
-	char			*name =3D VNAME(dentry);
 	xfs_mount_t	        *mp =3D dp->i_mount;
 	xfs_inode_t		*ip;
 	xfs_trans_t		*tp;
@@ -1808,17 +1807,14 @@ xfs_create(
 	xfs_prid_t		prid;
 	struct xfs_dquot	*udqp, *gdqp;
 	uint			resblks;
-	int			namelen;
=20
 	ASSERT(!*ipp);
 	xfs_itrace_entry(dp);
=20
-	namelen =3D VNAMELEN(dentry);
-
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
 		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
 				dp, DM_RIGHT_NULL, NULL,
-				DM_RIGHT_NULL, name, NULL,
+				DM_RIGHT_NULL, name->name, NULL,
 				mode, 0, 0);
=20
 		if (error)
@@ -1850,7 +1846,7 @@ xfs_create(
=20
 	tp =3D xfs_trans_alloc(mp, XFS_TRANS_CREATE);
 	cancel_flags =3D XFS_TRANS_RELEASE_LOG_RES;
-	resblks =3D XFS_CREATE_SPACE_RES(mp, namelen);
+	resblks =3D XFS_CREATE_SPACE_RES(mp, name->len);
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1883,7 +1879,8 @@ xfs_create(
 	if (error)
 		goto error_return;
=20
-	if (resblks =3D=3D 0 && (error =3D xfs_dir_canenter(tp, dp, name, namelen=
)))
+	error =3D xfs_dir_check_canenter(resblks, tp, dp, name);
+	if (error)
 		goto error_return;
 	error =3D xfs_dir_ialloc(&tp, dp, mode, 1,
 			rdev, credp, prid, resblks > 0,
@@ -1913,7 +1910,7 @@ xfs_create(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error =3D B_FALSE;
=20
-	error =3D xfs_dir_createname(tp, dp, name, namelen, ip->i_ino,
+	error =3D xfs_dir_createname(tp, dp, name, ip->i_ino,
 					&first_block, &free_list, resblks ?
 					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
 	if (error) {
@@ -1974,7 +1971,7 @@ std_return:
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE,
 			dp, DM_RIGHT_NULL,
 			*ipp ? ip : NULL,
-			DM_RIGHT_NULL, name, NULL,
+			DM_RIGHT_NULL, name->name, NULL,
 			mode, error, 0);
 	}
 	return error;
@@ -2266,12 +2263,10 @@ int remove_which_error_return =3D 0;
 int
 xfs_remove(
 	xfs_inode_t             *dp,
-	bhv_vname_t		*dentry)
+	struct xfs_name		*name,
+	xfs_inode_t		*ip)
 {
-	char			*name =3D VNAME(dentry);
 	xfs_mount_t		*mp =3D dp->i_mount;
-	xfs_inode_t             *ip =3D VNAME_TO_INODE(dentry);
-	int			namelen =3D VNAMELEN(dentry);
 	xfs_trans_t             *tp =3D NULL;
 	int                     error =3D 0;
 	xfs_bmap_free_t         free_list;
@@ -2287,9 +2282,9 @@ xfs_remove(
 		return XFS_ERROR(EIO);
=20
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
-		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dp,
-					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
-					name, NULL, ip->i_d.di_mode, 0, 0);
+		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dp, DM_RIGHT_NULL,
+					NULL, DM_RIGHT_NULL, name->name, NULL,
+					ip->i_d.di_mode, 0, 0);
 		if (error)
 			return error;
 	}
@@ -2374,7 +2369,7 @@ xfs_remove(
 	 * Entry must exist since we did a lookup in xfs_lock_dir_and_entry.
 	 */
 	XFS_BMAP_INIT(&free_list, &first_block);
-	error =3D xfs_dir_removename(tp, dp, name, namelen, ip->i_ino,
+	error =3D xfs_dir_removename(tp, dp, name, ip->i_ino,
 					&first_block, &free_list, 0);
 	if (error) {
 		ASSERT(error !=3D ENOENT);
@@ -2442,7 +2437,7 @@ xfs_remove(
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE,
 				dp, DM_RIGHT_NULL,
 				NULL, DM_RIGHT_NULL,
-				name, NULL, ip->i_d.di_mode, error, 0);
+				name->name, NULL, ip->i_d.di_mode, error, 0);
 	}
 	return error;
=20
@@ -2472,7 +2467,7 @@ int
 xfs_link(
 	xfs_inode_t		*tdp,
 	xfs_inode_t		*sip,
-	bhv_vname_t		*dentry)
+	struct xfs_name		*target_name)
 {
 	xfs_mount_t		*mp =3D tdp->i_mount;
 	xfs_trans_t		*tp;
@@ -2483,13 +2478,10 @@ xfs_link(
 	int			cancel_flags;
 	int			committed;
 	int			resblks;
-	char			*target_name =3D VNAME(dentry);
-	int			target_namelen;
=20
 	xfs_itrace_entry(tdp);
 	xfs_itrace_entry(sip);
=20
-	target_namelen =3D VNAMELEN(dentry);
 	ASSERT(!S_ISDIR(sip->i_d.di_mode));
=20
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -2499,7 +2491,7 @@ xfs_link(
 		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_LINK,
 					tdp, DM_RIGHT_NULL,
 					sip, DM_RIGHT_NULL,
-					target_name, NULL, 0, 0, 0);
+					target_name->name, NULL, 0, 0, 0);
 		if (error)
 			return error;
 	}
@@ -2514,7 +2506,7 @@ xfs_link(
=20
 	tp =3D xfs_trans_alloc(mp, XFS_TRANS_LINK);
 	cancel_flags =3D XFS_TRANS_RELEASE_LOG_RES;
-	resblks =3D XFS_LINK_SPACE_RES(mp, target_namelen);
+	resblks =3D XFS_LINK_SPACE_RES(mp, target_name->len);
 	error =3D xfs_trans_reserve(tp, resblks, XFS_LINK_LOG_RES(mp), 0,
 			XFS_TRANS_PERM_LOG_RES, XFS_LINK_LOG_COUNT);
 	if (error =3D=3D ENOSPC) {
@@ -2566,13 +2558,13 @@ xfs_link(
 		goto error_return;
 	}
=20
-	if (resblks =3D=3D 0 &&
-	    (error =3D xfs_dir_canenter(tp, tdp, target_name, target_namelen)))
+	error =3D xfs_dir_check_canenter(resblks, tp, tdp, target_name);
+	if (error)
 		goto error_return;
=20
 	XFS_BMAP_INIT(&free_list, &first_block);
=20
-	error =3D xfs_dir_createname(tp, tdp, target_name, target_namelen,
+	error =3D xfs_dir_createname(tp, tdp, target_name,
 				   sip->i_ino, &first_block, &free_list,
 				   resblks);
 	if (error)
@@ -2610,7 +2602,7 @@ std_return:
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTLINK,
 				tdp, DM_RIGHT_NULL,
 				sip, DM_RIGHT_NULL,
-				target_name, NULL, 0, error, 0);
+				target_name->name, NULL, 0, error, 0);
 	}
 	return error;
=20
@@ -2627,13 +2619,11 @@ std_return:
 int
 xfs_mkdir(
 	xfs_inode_t             *dp,
-	bhv_vname_t		*dentry,
+	struct xfs_name		*dir_name,
 	mode_t			mode,
 	xfs_inode_t		**ipp,
 	cred_t			*credp)
 {
-	char			*dir_name =3D VNAME(dentry);
-	int			dir_namelen =3D VNAMELEN(dentry);
 	xfs_mount_t		*mp =3D dp->i_mount;
 	xfs_inode_t		*cdp;	/* inode of created dir */
 	xfs_trans_t		*tp;
@@ -2657,7 +2647,7 @@ xfs_mkdir(
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
 		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
 					dp, DM_RIGHT_NULL, NULL,
-					DM_RIGHT_NULL, dir_name, NULL,
+					DM_RIGHT_NULL, dir_name->name, NULL,
 					mode, 0, 0);
 		if (error)
 			return error;
@@ -2686,7 +2676,7 @@ xfs_mkdir(
=20
 	tp =3D xfs_trans_alloc(mp, XFS_TRANS_MKDIR);
 	cancel_flags =3D XFS_TRANS_RELEASE_LOG_RES;
-	resblks =3D XFS_MKDIR_SPACE_RES(mp, dir_namelen);
+	resblks =3D XFS_MKDIR_SPACE_RES(mp, dir_name->len);
 	error =3D xfs_trans_reserve(tp, resblks, XFS_MKDIR_LOG_RES(mp), 0,
 				  XFS_TRANS_PERM_LOG_RES, XFS_MKDIR_LOG_COUNT);
 	if (error =3D=3D ENOSPC) {
@@ -2718,8 +2708,8 @@ xfs_mkdir(
 	if (error)
 		goto error_return;
=20
-	if (resblks =3D=3D 0 &&
-	    (error =3D xfs_dir_canenter(tp, dp, dir_name, dir_namelen)))
+	error =3D xfs_dir_check_canenter(resblks, tp, dp, dir_name);
+	if (error)
 		goto error_return;
 	/*
 	 * create the directory inode.
@@ -2748,7 +2738,7 @@ xfs_mkdir(
=20
 	XFS_BMAP_INIT(&free_list, &first_block);
=20
-	error =3D xfs_dir_createname(tp, dp, dir_name, dir_namelen, cdp->i_ino,
+	error =3D xfs_dir_createname(tp, dp, dir_name, cdp->i_ino,
 				   &first_block, &free_list, resblks ?
 				   resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
 	if (error) {
@@ -2815,7 +2805,7 @@ std_return:
 					dp, DM_RIGHT_NULL,
 					created ? cdp : NULL,
 					DM_RIGHT_NULL,
-					dir_name, NULL,
+					dir_name->name, NULL,
 					mode, error, 0);
 	}
 	return error;
@@ -2839,13 +2829,11 @@ std_return:
 int
 xfs_rmdir(
 	xfs_inode_t             *dp,
-	bhv_vname_t		*dentry)
+	struct xfs_name		*name,
+	xfs_inode_t		*cdp)
 {
 	bhv_vnode_t		*dir_vp =3D XFS_ITOV(dp);
-	char			*name =3D VNAME(dentry);
-	int			namelen =3D VNAMELEN(dentry);
 	xfs_mount_t		*mp =3D dp->i_mount;
-  	xfs_inode_t             *cdp =3D VNAME_TO_INODE(dentry);
 	xfs_trans_t             *tp;
 	int                     error;
 	xfs_bmap_free_t         free_list;
@@ -2863,8 +2851,8 @@ xfs_rmdir(
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
 		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE,
 					dp, DM_RIGHT_NULL,
-					NULL, DM_RIGHT_NULL,
-					name, NULL, cdp->i_d.di_mode, 0, 0);
+					NULL, DM_RIGHT_NULL, name->name,
+					NULL, cdp->i_d.di_mode, 0, 0);
 		if (error)
 			return XFS_ERROR(error);
 	}
@@ -2958,7 +2946,7 @@ xfs_rmdir(
 		goto error_return;
 	}
=20
-	error =3D xfs_dir_removename(tp, dp, name, namelen, cdp->i_ino,
+	error =3D xfs_dir_removename(tp, dp, name, cdp->i_ino,
 					&first_block, &free_list, resblks);
 	if (error)
 		goto error1;
@@ -3038,7 +3026,7 @@ xfs_rmdir(
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE,
 					dp, DM_RIGHT_NULL,
 					NULL, DM_RIGHT_NULL,
-					name, NULL, cdp->i_d.di_mode,
+					name->name, NULL, cdp->i_d.di_mode,
 					error, 0);
 	}
 	return error;
@@ -3056,8 +3044,8 @@ xfs_rmdir(
 int
 xfs_symlink(
 	xfs_inode_t		*dp,
-	bhv_vname_t		*dentry,
-	char			*target_path,
+	struct xfs_name		*link_name,
+	const char		*target_path,
 	mode_t			mode,
 	xfs_inode_t		**ipp,
 	cred_t			*credp)
@@ -3077,15 +3065,13 @@ xfs_symlink(
 	int			nmaps;
 	xfs_bmbt_irec_t		mval[SYMLINK_MAPS];
 	xfs_daddr_t		d;
-	char			*cur_chunk;
+	const char		*cur_chunk;
 	int			byte_cnt;
 	int			n;
 	xfs_buf_t		*bp;
 	xfs_prid_t		prid;
 	struct xfs_dquot	*udqp, *gdqp;
 	uint			resblks;
-	char			*link_name =3D VNAME(dentry);
-	int			link_namelen;
=20
 	*ipp =3D NULL;
 	error =3D 0;
@@ -3097,8 +3083,6 @@ xfs_symlink(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
=20
-	link_namelen =3D VNAMELEN(dentry);
-
 	/*
 	 * Check component lengths of the target path name.
 	 */
@@ -3134,7 +3118,7 @@ xfs_symlink(
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_SYMLINK)) {
 		error =3D XFS_SEND_NAMESP(mp, DM_EVENT_SYMLINK, dp,
 					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
-					link_name, target_path, 0, 0, 0);
+					link_name->name, target_path, 0, 0, 0);
 		if (error)
 			return error;
 	}
@@ -3166,7 +3150,7 @@ xfs_symlink(
 		fs_blocks =3D 0;
 	else
 		fs_blocks =3D XFS_B_TO_FSB(mp, pathlen);
-	resblks =3D XFS_SYMLINK_SPACE_RES(mp, link_namelen, fs_blocks);
+	resblks =3D XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
 	error =3D xfs_trans_reserve(tp, resblks, XFS_SYMLINK_LOG_RES(mp), 0,
 			XFS_TRANS_PERM_LOG_RES, XFS_SYMLINK_LOG_COUNT);
 	if (error =3D=3D ENOSPC && fs_blocks =3D=3D 0) {
@@ -3200,8 +3184,8 @@ xfs_symlink(
 	/*
 	 * Check for ability to enter directory entry, if no space reserved.
 	 */
-	if (resblks =3D=3D 0 &&
-	    (error =3D xfs_dir_canenter(tp, dp, link_name, link_namelen)))
+	error =3D xfs_dir_check_canenter(resblks, tp, dp, link_name);
+	if (error)
 		goto error_return;
 	/*
 	 * Initialize the bmap freelist prior to calling either
@@ -3293,7 +3277,7 @@ xfs_symlink(
 	/*
 	 * Create the directory entry for the symlink.
 	 */
-	error =3D xfs_dir_createname(tp, dp, link_name, link_namelen, ip->i_ino,
+	error =3D xfs_dir_createname(tp, dp, link_name, ip->i_ino,
 				   &first_block, &free_list, resblks);
 	if (error)
 		goto error1;
@@ -3338,8 +3322,8 @@ std_return:
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTSYMLINK,
 					dp, DM_RIGHT_NULL,
 					error ? NULL : ip,
-					DM_RIGHT_NULL, link_name, target_path,
-					0, error, 0);
+					DM_RIGHT_NULL, link_name->name,
+					target_path, 0, error, 0);
 	}
=20
 	if (!error)
Index: kern_ci/fs/xfs/xfs_vnodeops.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_vnodeops.h
+++ kern_ci/fs/xfs/xfs_vnodeops.h
@@ -12,7 +12,7 @@ struct pipe_inode_info;
 struct uio;
 struct xfs_inode;
 struct xfs_iomap;
-
+struct xfs_name;
=20
 int xfs_open(struct xfs_inode *ip);
 int xfs_getattr(struct xfs_inode *ip, struct bhv_vattr *vap, int flags);
@@ -23,20 +23,22 @@ int xfs_fsync(struct xfs_inode *ip, int=20
 		xfs_off_t stop);
 int xfs_release(struct xfs_inode *ip);
 int xfs_inactive(struct xfs_inode *ip);
-int xfs_lookup(struct xfs_inode *dp, bhv_vname_t *dentry,
+int xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode **ipp);
-int xfs_create(struct xfs_inode *dp, bhv_vname_t *dentry, mode_t mode,
+int xfs_create(struct xfs_inode *dp, struct xfs_name *name, mode_t mode,
 		xfs_dev_t rdev, struct xfs_inode **ipp, struct cred *credp);
-int xfs_remove(struct xfs_inode *dp, bhv_vname_t	*dentry);
+int xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
 int xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
-		bhv_vname_t *dentry);
-int xfs_mkdir(struct xfs_inode *dp, bhv_vname_t *dentry,
+		struct xfs_name *target_name);
+int xfs_mkdir(struct xfs_inode *dp, struct xfs_name *dir_name,
 		mode_t mode, struct xfs_inode **ipp, struct cred *credp);
-int xfs_rmdir(struct xfs_inode *dp, bhv_vname_t *dentry);
+int xfs_rmdir(struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *cdp);
 int xfs_readdir(struct xfs_inode	*dp, void *dirent, size_t bufsize,
 		       xfs_off_t *offset, filldir_t filldir);
-int xfs_symlink(struct xfs_inode *dp, bhv_vname_t *dentry,
-		char *target_path, mode_t mode, struct xfs_inode **ipp,
+int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
+		const char *target_path, mode_t mode, struct xfs_inode **ipp,
 		struct cred *credp);
 int xfs_inode_flush(struct xfs_inode *ip, int flags);
 int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
@@ -44,8 +46,9 @@ int xfs_reclaim(struct xfs_inode *ip);
 int xfs_change_file_space(struct xfs_inode *ip, int cmd,
 		xfs_flock64_t *bf, xfs_off_t offset,
 		struct cred *credp, int	attr_flags);
-int xfs_rename(struct xfs_inode *src_dp, bhv_vname_t *src_vname,
-		struct xfs_inode *target_dp, bhv_vname_t *target_vname);
+int xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
+		struct xfs_inode *src_ip, struct xfs_inode *target_dp,
+		struct xfs_name *target_name);
 int xfs_attr_get(struct xfs_inode *ip, const char *name, char *value,
 		int *valuelenp, int flags, cred_t *cred);
 int xfs_attr_set(struct xfs_inode *dp, const char *name, char *value,

------------mTJiuIKRrFB793e0LEPxBc--

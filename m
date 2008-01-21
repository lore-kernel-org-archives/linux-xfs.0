Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 19:52:01 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L3pmvK002497
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 19:51:50 -0800
Date: Mon, 21 Jan 2008 14:53:02 +1100
Subject: Re: [REVIEW 1/2] Case insensitive support for XFS - kernel patch
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------OopNAZbFULX3uI7ekf9jl6
MIME-Version: 1.0
References: <op.t43zfc073jf8g2@pc-bnaujok.melbourne.sgi.com> <47918927.2000603@sandeen.net>
Message-ID: <op.t49g2olx3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <47918927.2000603@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

------------OopNAZbFULX3uI7ekf9jl6
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 7bit

On Sat, 19 Jan 2008 16:22:47 +1100, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Lots of comments below;

I have addressed the "real" ones :)

- xfs_unicode.c functions do not return negative error codes anymore.
- Fixed up the indenting in the patch.
- Added a few comments for things that weren't clear.
- Made sure my changes didn't exceed 80 char lines.

No sub-patches at this stage.


------------OopNAZbFULX3uI7ekf9jl6
Content-Disposition: attachment; filename=ci_kernel.patch
Content-Type: text/x-patch; name=ci_kernel.patch
Content-Transfer-Encoding: Quoted-Printable


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/Makefile	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/Makefile	2007-10-23 16:17:22.173903950 +1000
@@ -74,6 +74,7 @@ xfs-y				+=3D xfs_alloc.o \
 				   xfs_trans_extfree.o \
 				   xfs_trans_inode.o \
 				   xfs_trans_item.o \
+				   xfs_unicode.o \
 				   xfs_utils.o \
 				   xfs_vfsops.o \
 				   xfs_vnodeops.o \
@@ -97,7 +98,7 @@ xfs-y				+=3D $(addprefix $(XFS_LINUX)/, \
 				   xfs_lrw.o \
 				   xfs_super.o \
 				   xfs_vnode.o \
-				   xfs_ksyms.o) =

+				   xfs_ksyms.o)
 =

 # Objects in support/
 xfs-y				+=3D $(addprefix support/, \

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/linux-2.6/xfs_export.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/linux-2.6/xfs_export.c	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/linux-2.6/xfs_export.c	2008-01-11 14:20:10.000000000 +1100
@@ -217,7 +217,7 @@ xfs_fs_get_parent(
 	struct dentry		*parent;
 =

 	cvp =3D NULL;
-	error =3D xfs_lookup(XFS_I(child->d_inode), &dotdot, &cvp);
+	error =3D xfs_lookup(XFS_I(child->d_inode), &dotdot, &cvp, NULL, NULL)=
;
 	if (unlikely(error))
 		return ERR_PTR(-error);
 =


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/linux-2.6/xfs_iops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/linux-2.6/xfs_iops.c	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/linux-2.6/xfs_iops.c	2008-01-21 14:27:33.000000000 +1100
@@ -47,6 +47,8 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_vnodeops.h"
+#include "xfs_da_btree.h"
+#include "xfs_unicode.h"
 =

 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -388,7 +390,7 @@ xfs_vn_lookup(
 	if (dentry->d_name.len >=3D MAXNAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
 =

-	error =3D xfs_lookup(XFS_I(dir), dentry, &cvp);
+	error =3D xfs_lookup(XFS_I(dir), dentry, &cvp, NULL, NULL);
 	if (unlikely(error)) {
 		if (unlikely(error !=3D ENOENT))
 			return ERR_PTR(-error);
@@ -399,6 +401,113 @@ xfs_vn_lookup(
 	return d_splice_alias(vn_to_inode(cvp), dentry);
 }
 =

+STATIC struct dentry *
+xfs_vn_ci_lookup(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	struct nameidata *nd)
+{
+	bhv_vnode_t	*cvp;
+	int		error;
+	struct dentry	*result;
+	struct qstr	actual_name;
+	struct inode	*inode;
+
+	if (dentry->d_name.len >=3D MAXNAMELEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	error =3D xfs_lookup(XFS_I(dir), dentry, &cvp, (char **)&actual_name.n=
ame,
+			&actual_name.len);
+	if (unlikely(error)) {
+		if (unlikely(error !=3D ENOENT))
+			return ERR_PTR(-error);
+		d_add(dentry, NULL);
+		return NULL;
+	}
+	inode =3D vn_to_inode(cvp);
+
+	/* if exact match, just splice and exit */
+	if (!actual_name.name) {
+		result =3D d_splice_alias(inode, dentry);
+		return result;
+	}
+
+	/*
+	 * case-insensitive match, create a dentry to return and fill it
+	 * in with the correctly cased name. Parameter "dentry" is not
+	 * used anymore and the caller will free it.
+	 * Derived from fs/ntfs/namei.c
+	 */
+
+	actual_name.hash =3D full_name_hash(actual_name.name, actual_name.len)=
;
+
+	/* Does an existing dentry match? */
+	result =3D d_lookup(dentry->d_parent, &actual_name);
+	if (!result) {
+		/* if not, create one */
+		result =3D d_alloc(dentry->d_parent, &actual_name);
+		xfs_free_unicode_nls_name((char *)actual_name.name);
+		if (!result)
+			return ERR_PTR(-ENOMEM);
+		dentry =3D d_splice_alias(inode, result);
+		if (dentry) {
+			dput(result);
+			return dentry;
+		}
+		return result;
+	}
+	xfs_free_unicode_nls_name((char *)actual_name.name);
+
+	/* an existing dentry matches, use it */
+
+	if (result->d_inode) {
+		/*
+		 * already an inode attached, deref the inode that was
+		 * refcounted with xfs_lookup and return the dentry.
+		 */
+		if (unlikely(result->d_inode !=3D inode)) {
+			/* This can happen because bad inodes are unhashed. */
+			BUG_ON(!is_bad_inode(inode));
+			BUG_ON(!is_bad_inode(result->d_inode));
+		}
+		iput(inode);
+		return result;
+	}
+
+	if (!S_ISDIR(inode->i_mode)) {
+		/* not a directory, easy to handle */
+		d_instantiate(result, inode);
+		return result;
+	}
+
+	spin_lock(&dcache_lock);
+	if (list_empty(&inode->i_dentry)) {
+		/*
+		 * Directory without a 'disconnected' dentry; we need to do
+		 * d_instantiate() by hand because it takes dcache_lock which
+		 * we already hold.
+		 */
+		list_add(&result->d_alias, &inode->i_dentry);
+		result->d_inode =3D inode;
+		spin_unlock(&dcache_lock);
+		security_d_instantiate(result, inode);
+		return result;
+	}
+	/*
+	 * Directory with a 'disconnected' dentry; get a reference to the
+	 * 'disconnected' dentry.
+	 */
+	dentry =3D list_entry(inode->i_dentry.next, struct dentry, d_alias);
+	dget_locked(dentry);
+	spin_unlock(&dcache_lock);
+	security_d_instantiate(result, inode);
+	d_move(dentry, result);
+	iput(inode);
+	dput(result);
+	return dentry;
+}
+
+
 STATIC int
 xfs_vn_link(
 	struct dentry	*old_dentry,
@@ -887,6 +996,25 @@ const struct inode_operations xfs_dir_in
 	.removexattr		=3D xfs_vn_removexattr,
 };
 =

+const struct inode_operations xfs_dir_ci_inode_operations =3D {
+	.create			=3D xfs_vn_create,
+	.lookup			=3D xfs_vn_ci_lookup,
+	.link			=3D xfs_vn_link,
+	.unlink			=3D xfs_vn_unlink,
+	.symlink		=3D xfs_vn_symlink,
+	.mkdir			=3D xfs_vn_mkdir,
+	.rmdir			=3D xfs_vn_rmdir,
+	.mknod			=3D xfs_vn_mknod,
+	.rename			=3D xfs_vn_rename,
+	.permission		=3D xfs_vn_permission,
+	.getattr		=3D xfs_vn_getattr,
+	.setattr		=3D xfs_vn_setattr,
+	.setxattr		=3D xfs_vn_setxattr,
+	.getxattr		=3D xfs_vn_getxattr,
+	.listxattr		=3D xfs_vn_listxattr,
+	.removexattr		=3D xfs_vn_removexattr,
+};
+
 const struct inode_operations xfs_symlink_inode_operations =3D {
 	.readlink		=3D generic_readlink,
 	.follow_link		=3D xfs_vn_follow_link,

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/linux-2.6/xfs_iops.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/linux-2.6/xfs_iops.h	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/linux-2.6/xfs_iops.h	2007-10-26 13:19:11.702517171 +1000
@@ -20,6 +20,7 @@
 =

 extern const struct inode_operations xfs_inode_operations;
 extern const struct inode_operations xfs_dir_inode_operations;
+extern const struct inode_operations xfs_dir_ci_inode_operations;
 extern const struct inode_operations xfs_symlink_inode_operations;
 =

 extern const struct file_operations xfs_file_operations;

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/linux-2.6/xfs_ksyms.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/linux-2.6/xfs_ksyms.c	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/linux-2.6/xfs_ksyms.c	2008-01-21 14:27:33.000000000 +1100
@@ -157,6 +157,7 @@ EXPORT_SYMBOL(kmem_zone_init);
 EXPORT_SYMBOL(kmem_zone_zalloc);
 EXPORT_SYMBOL(xfs_address_space_operations);
 EXPORT_SYMBOL(xfs_dir_inode_operations);
+EXPORT_SYMBOL(xfs_dir_ci_inode_operations);
 EXPORT_SYMBOL(xfs_dir_file_operations);
 EXPORT_SYMBOL(xfs_inode_operations);
 EXPORT_SYMBOL(xfs_file_operations);

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/linux-2.6/xfs_linux.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/linux-2.6/xfs_linux.h	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/linux-2.6/xfs_linux.h	2008-01-11 14:49:16.537591564 +1100
@@ -75,6 +75,8 @@
 #include <linux/delay.h>
 #include <linux/log2.h>
 #include <linux/spinlock.h>
+#include <linux/ctype.h>
+#include <linux/nls.h>
 =

 #include <asm/page.h>
 #include <asm/div64.h>
@@ -180,6 +182,12 @@
 #define howmany(x, y)	(((x)+((y)-1))/(y))
 =

 /*
+ * NLS UTF-8 character set
+ */
+
+#define XFS_NLS_UTF8	"utf8"
+
+/*
  * Various platform dependent calls that don't fit anywhere else
  */
 #define xfs_sort(a,n,s,fn)	sort(a,n,s,fn,NULL)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/linux-2.6/xfs_super.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/linux-2.6/xfs_super.c	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/linux-2.6/xfs_super.c	2008-01-21 14:27:33.000000000 +1100
@@ -50,6 +50,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_vfsops.h"
 #include "xfs_version.h"
+#include "xfs_unicode.h"
 #include "xfs_log_priv.h"
 #include "xfs_trans_priv.h"
 =

@@ -122,6 +123,9 @@ xfs_args_allocate(
 #define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
 #define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format *=
/
 #define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator *=
/
+#define MNTOPT_NLS	"nls"		/* NLS code page to use */
+#define MNTOPT_CILOOKUP	"ci"		/* case-insensitive dir names */
+#define MNTOPT_CIATTR	"ciattr"	/* case-insensitive attr names */
 #define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
 #define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
 #define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
@@ -316,6 +320,18 @@ xfs_parseargs(
 			args->flags &=3D ~XFSMNT_ATTR2;
 		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
 			args->flags2 |=3D XFSMNT2_FILESTREAMS;
+		} else if (!strcmp(this_char, MNTOPT_NLS)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			strncpy(args->nls, value, MAXNAMELEN);
+		} else if (!strcmp(this_char, MNTOPT_CILOOKUP)) {
+			args->flags2 |=3D XFSMNT2_CILOOKUP;
+		} else if (!strcmp(this_char, MNTOPT_CIATTR)) {
+			args->flags2 |=3D XFSMNT2_CIATTR;
 		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
 			args->flags &=3D ~(XFSMNT_UQUOTAENF|XFSMNT_UQUOTA);
 			args->flags &=3D ~(XFSMNT_GQUOTAENF|XFSMNT_GQUOTA);
@@ -455,6 +471,8 @@ xfs_showargs(
 		{ XFS_MOUNT_OSYNCISOSYNC,	"," MNTOPT_OSYNCISOSYNC },
 		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
+		{ XFS_MOUNT_CI_LOOKUP,		"," MNTOPT_CILOOKUP },
+		{ XFS_MOUNT_CI_ATTR,		"," MNTOPT_CIATTR },
 		{ XFS_MOUNT_DMAPI,		"," MNTOPT_DMAPI },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
 		{ 0, NULL }
@@ -517,6 +535,13 @@ xfs_showargs(
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, "," MNTOPT_NOQUOTA);
 =

+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		if (mp->m_nls)
+			seq_printf(m, "," MNTOPT_NLS "=3D%s", mp->m_nls->charset);
+		else
+			seq_puts(m, "," MNTOPT_NLS "=3D" XFS_NLS_UTF8);
+	}
+
 	return 0;
 }
 __uint64_t
@@ -564,7 +589,11 @@ xfs_set_inodeops(
 		inode->i_mapping->a_ops =3D &xfs_address_space_operations;
 		break;
 	case S_IFDIR:
-		inode->i_op =3D &xfs_dir_inode_operations;
+		inode->i_op =3D
+			xfs_sb_version_hasoldci(&XFS_I(inode)->i_mount->m_sb) ||
+			(XFS_I(inode)->i_mount->m_flags & XFS_MOUNT_CI_LOOKUP) ?
+				&xfs_dir_ci_inode_operations :
+				&xfs_dir_inode_operations;
 		inode->i_fop =3D &xfs_dir_file_operations;
 		break;
 	case S_IFLNK:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_attr.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_attr.c	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/xfs_attr.c	2008-01-18 13:25:20.068339942 +1100
@@ -106,6 +106,17 @@ ktrace_t *xfs_attr_trace_buf;
  * Overall external interface routines.
  *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
 =

+void
+xfs_attr_mount(struct xfs_mount *mp)
+{
+	mp->m_attr_magicpct =3D (mp->m_sb.sb_blocksize * 37) / 100;
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		mp->m_attrnameops =3D (mp->m_flags & XFS_MOUNT_CI_ATTR) ?
+			&xfs_unicode_ci_nameops : &xfs_unicode_nameops;
+	} else
+		mp->m_attrnameops =3D &xfs_default_nameops;
+}
+
 int
 xfs_attr_fetch(xfs_inode_t *ip, const char *name, int namelen,
 	       char *value, int *valuelenp, int flags, struct cred *cred)
@@ -122,14 +133,14 @@ xfs_attr_fetch(xfs_inode_t *ip, const ch
 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.name =3D name;
-	args.namelen =3D namelen;
 	args.value =3D value;
 	args.valuelen =3D *valuelenp;
 	args.flags =3D flags;
-	args.hashval =3D xfs_da_hashname(args.name, args.namelen);
 	args.dp =3D ip;
 	args.whichfork =3D XFS_ATTR_FORK;
+	error =3D xfs_da_setup_name_and_hash(&args, name, namelen);
+	if (error)
+		return error;
 =

 	/*
 	 * Decide on what work routines to call based on the inode size.
@@ -153,6 +164,7 @@ xfs_attr_fetch(xfs_inode_t *ip, const ch
 =

 	if (error =3D=3D EEXIST)
 		error =3D 0;
+	xfs_da_cleanup_name(&args, name);
 	return(error);
 }
 =

@@ -181,6 +193,7 @@ xfs_attr_get(
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	error =3D xfs_attr_fetch(ip, name, namelen, value, valuelenp, flags, c=
red);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
 	return(error);
 }
 =

@@ -219,18 +232,18 @@ xfs_attr_set_int(xfs_inode_t *dp, const =

 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.name =3D name;
-	args.namelen =3D namelen;
 	args.value =3D value;
 	args.valuelen =3D valuelen;
 	args.flags =3D flags;
-	args.hashval =3D xfs_da_hashname(args.name, args.namelen);
 	args.dp =3D dp;
 	args.firstblock =3D &firstblock;
 	args.flist =3D &flist;
 	args.whichfork =3D XFS_ATTR_FORK;
 	args.addname =3D 1;
 	args.oknoent =3D 1;
+	error =3D xfs_da_setup_name_and_hash(&args, name, namelen);
+	if (error)
+		return error;
 =

 	/*
 	 * Determine space new attribute will use, and if it would be
@@ -282,6 +295,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const =

 				      0, XFS_TRANS_PERM_LOG_RES,
 				      XFS_ATTRSET_LOG_COUNT))) {
 		xfs_trans_cancel(args.trans, 0);
+		xfs_da_cleanup_name(&args, name);
 		return(error);
 	}
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
@@ -292,6 +306,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const =

 	if (error) {
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 		xfs_trans_cancel(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+		xfs_da_cleanup_name(&args, name);
 		return (error);
 	}
 =

@@ -342,6 +357,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const =

 			if (!error && (flags & ATTR_KERNOTIME) =3D=3D 0) {
 				xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
 			}
+			xfs_da_cleanup_name(&args, name);
 			return(error =3D=3D 0 ? err2 : error);
 		}
 =

@@ -411,6 +427,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const =

 		xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
 	}
 =

+	xfs_da_cleanup_name(&args, name);
 	return(error);
 =

 out:
@@ -418,6 +435,7 @@ out:
 		xfs_trans_cancel(args.trans,
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_da_cleanup_name(&args, name);
 	return(error);
 }
 =

@@ -460,21 +478,23 @@ xfs_attr_remove_int(xfs_inode_t *dp, con
 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.name =3D name;
-	args.namelen =3D namelen;
 	args.flags =3D flags;
-	args.hashval =3D xfs_da_hashname(args.name, args.namelen);
 	args.dp =3D dp;
 	args.firstblock =3D &firstblock;
 	args.flist =3D &flist;
 	args.total =3D 0;
 	args.whichfork =3D XFS_ATTR_FORK;
+	error =3D xfs_da_setup_name_and_hash(&args, name, namelen);
+	if (error)
+		return error;
 =

 	/*
 	 * Attach the dquots to the inode.
 	 */
-	if ((error =3D XFS_QM_DQATTACH(mp, dp, 0)))
+	if ((error =3D XFS_QM_DQATTACH(mp, dp, 0))) {
+		xfs_da_cleanup_name(&args, name);
 		return (error);
+	}
 =

 	/*
 	 * Start our first transaction of the day.
@@ -502,6 +522,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, con
 				      0, XFS_TRANS_PERM_LOG_RES,
 				      XFS_ATTRRM_LOG_COUNT))) {
 		xfs_trans_cancel(args.trans, 0);
+		xfs_da_cleanup_name(&args, name);
 		return(error);
 	}
 =

@@ -559,6 +580,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, con
 		xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
 	}
 =

+	xfs_da_cleanup_name(&args, name);
 	return(error);
 =

 out:
@@ -566,6 +588,7 @@ out:
 		xfs_trans_cancel(args.trans,
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_da_cleanup_name(&args, name);
 	return(error);
 }
 =

@@ -634,7 +657,7 @@ xfs_attr_list_int(xfs_attr_list_context_
  */
 /*ARGSUSED*/
 STATIC int
-xfs_attr_put_listent(xfs_attr_list_context_t *context, attrnames_t *nam=
esp,
+xfs_attr_user_list(xfs_attr_list_context_t *context, attrnames_t *names=
p,
 		     char *name, int namelen,
 		     int valuelen, char *value)
 {
@@ -765,7 +788,7 @@ xfs_attr_list(
 		context.alist->al_count =3D 0;
 		context.alist->al_more =3D 0;
 		context.alist->al_offset[0] =3D context.bufsize;
-		context.put_listent =3D xfs_attr_put_listent;
+		context.put_listent =3D xfs_attr_user_list;
 	}
 =

 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_attr_leaf.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_attr_leaf.c	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/xfs_attr_leaf.c	2008-01-21 14:07:01.982908019 +1100
@@ -42,6 +42,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
+#include "xfs_unicode.h"
 =

 /*
  * xfs_attr_leaf.c
@@ -90,6 +91,10 @@ STATIC void xfs_attr_leaf_moveents(xfs_a
 					 xfs_mount_t *mp);
 STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)=
;
 =

+STATIC int xfs_attr_put_listent(xfs_attr_list_context_t *context,
+					attrnames_t *namesp, char *name,
+					int namelen, int valuelen, char *value);
+
 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  * Namespace helper routines
  *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
@@ -135,6 +140,38 @@ xfs_attr_namesp_match_overrides(int arg_
  * External routines when attribute fork size < XFS_LITINO(mp).
  *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
 =

+STATIC xfs_attr_sf_entry_t *
+xfs_attr_shortform_find_ent(xfs_da_args_t *args)
+{
+	xfs_attr_shortform_t *sf;
+	xfs_attr_sf_entry_t *sfe;
+	int i;
+	xfs_attr_sf_entry_t *ci_sfe =3D NULL;
+
+	ASSERT(args->dp->i_afp->if_flags & XFS_IFINLINE);
+	sf =3D (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
+	sfe =3D &sf->list[0];
+
+	args->cmpresult =3D XFS_CMP_DIFFERENT;
+	for (i =3D 0; i < sf->hdr.count; sfe =3D XFS_ATTR_SF_NEXTENTRY(sfe), i=
++) {
+		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
+			continue;
+		switch (xfs_attr_compname(args->dp, sfe->nameval, sfe->namelen,
+				args->name, args->namelen)) {
+		case XFS_CMP_EXACT:
+			args->cmpresult =3D XFS_CMP_EXACT;
+			return sfe;
+		case XFS_CMP_CASE:
+			if (!ci_sfe) {
+				args->cmpresult =3D XFS_CMP_CASE;
+				ci_sfe =3D sfe;
+			}
+		default:;
+		}
+	}
+	return ci_sfe;
+}
+
 /*
  * Query whether the requested number of additional bytes of extended
  * attribute space will be able to fit inline.
@@ -295,13 +332,10 @@ xfs_attr_shortform_add(xfs_da_args_t *ar
 	sfe =3D &sf->list[0];
 	for (i =3D 0; i < sf->hdr.count; sfe =3D XFS_ATTR_SF_NEXTENTRY(sfe), i=
++) {
 #ifdef DEBUG
-		if (sfe->namelen !=3D args->namelen)
-			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) !=3D 0)
-			continue;
 		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
 			continue;
-		ASSERT(0);
+		ASSERT(xfs_attr_compname(args->dp, args->name, args->namelen,
+			sfe->nameval, sfe->namelen) =3D=3D XFS_CMP_DIFFERENT);
 #endif
 	}
 =

@@ -331,29 +365,19 @@ xfs_attr_shortform_remove(xfs_da_args_t =

 {
 	xfs_attr_shortform_t *sf;
 	xfs_attr_sf_entry_t *sfe;
-	int base, size=3D0, end, totsize, i;
+	int base, size, end, totsize;
 	xfs_mount_t *mp;
 	xfs_inode_t *dp;
 =

+	sfe =3D xfs_attr_shortform_find_ent(args);
+	if (!sfe)
+		return XFS_ERROR(ENOATTR);
+
 	dp =3D args->dp;
 	mp =3D dp->i_mount;
-	base =3D sizeof(xfs_attr_sf_hdr_t);
 	sf =3D (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
-	sfe =3D &sf->list[0];
-	end =3D sf->hdr.count;
-	for (i =3D 0; i < end; sfe =3D XFS_ATTR_SF_NEXTENTRY(sfe),
-					base +=3D size, i++) {
-		size =3D XFS_ATTR_SF_ENTSIZE(sfe);
-		if (sfe->namelen !=3D args->namelen)
-			continue;
-		if (memcmp(sfe->nameval, args->name, args->namelen) !=3D 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		break;
-	}
-	if (i =3D=3D end)
-		return(XFS_ERROR(ENOATTR));
+	size =3D XFS_ATTR_SF_ENTSIZE(sfe);
+	base =3D (int)((char *)sfe - (char *)sf);
 =

 	/*
 	 * Fix up the attribute fork data, covering the hole
@@ -412,26 +436,7 @@ xfs_attr_shortform_remove(xfs_da_args_t =

 int
 xfs_attr_shortform_lookup(xfs_da_args_t *args)
 {
-	xfs_attr_shortform_t *sf;
-	xfs_attr_sf_entry_t *sfe;
-	int i;
-	xfs_ifork_t *ifp;
-
-	ifp =3D args->dp->i_afp;
-	ASSERT(ifp->if_flags & XFS_IFINLINE);
-	sf =3D (xfs_attr_shortform_t *)ifp->if_u1.if_data;
-	sfe =3D &sf->list[0];
-	for (i =3D 0; i < sf->hdr.count;
-				sfe =3D XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-		if (sfe->namelen !=3D args->namelen)
-			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) !=3D 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		return(XFS_ERROR(EEXIST));
-	}
-	return(XFS_ERROR(ENOATTR));
+	return XFS_ERROR(xfs_attr_shortform_find_ent(args) ? EEXIST : ENOATTR)=
;
 }
 =

 /*
@@ -441,35 +446,24 @@ xfs_attr_shortform_lookup(xfs_da_args_t =

 int
 xfs_attr_shortform_getvalue(xfs_da_args_t *args)
 {
-	xfs_attr_shortform_t *sf;
 	xfs_attr_sf_entry_t *sfe;
-	int i;
 =

-	ASSERT(args->dp->i_d.di_aformat =3D=3D XFS_IFINLINE);
-	sf =3D (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
-	sfe =3D &sf->list[0];
-	for (i =3D 0; i < sf->hdr.count;
-				sfe =3D XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-		if (sfe->namelen !=3D args->namelen)
-			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) !=3D 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		if (args->flags & ATTR_KERNOVAL) {
-			args->valuelen =3D sfe->valuelen;
-			return(XFS_ERROR(EEXIST));
-		}
-		if (args->valuelen < sfe->valuelen) {
-			args->valuelen =3D sfe->valuelen;
-			return(XFS_ERROR(ERANGE));
-		}
+	sfe =3D xfs_attr_shortform_find_ent(args);
+	if (!sfe)
+		return XFS_ERROR(ENOATTR);
+
+	if (args->flags & ATTR_KERNOVAL) {
 		args->valuelen =3D sfe->valuelen;
-		memcpy(args->value, &sfe->nameval[args->namelen],
-						    args->valuelen);
-		return(XFS_ERROR(EEXIST));
+		return XFS_ERROR(EEXIST);
 	}
-	return(XFS_ERROR(ENOATTR));
+	if (args->valuelen < sfe->valuelen) {
+		args->valuelen =3D sfe->valuelen;
+		return XFS_ERROR(ERANGE);
+	}
+	args->valuelen =3D sfe->valuelen;
+	memcpy(args->value, &sfe->nameval[args->namelen], args->valuelen);
+
+	return XFS_ERROR(EEXIST);
 }
 =

 /*
@@ -535,17 +529,18 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t
 =

 	sfe =3D &sf->list[0];
 	for (i =3D 0; i < sf->hdr.count; i++) {
-		nargs.name =3D (char *)sfe->nameval;
-		nargs.namelen =3D sfe->namelen;
-		nargs.value =3D (char *)&sfe->nameval[nargs.namelen];
+		nargs.value =3D (char *)&sfe->nameval[sfe->namelen];
 		nargs.valuelen =3D sfe->valuelen;
-		nargs.hashval =3D xfs_da_hashname((char *)sfe->nameval,
-						sfe->namelen);
+		error =3D xfs_da_setup_name_and_hash(&nargs, sfe->nameval,
+				sfe->namelen);
+		if (error)
+			goto out;
 		nargs.flags =3D XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
 		error =3D xfs_attr_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error =3D=3D ENOATTR);
 		error =3D xfs_attr_leaf_add(bp, &nargs);
 		ASSERT(error !=3D ENOSPC);
+		xfs_da_cleanup_name(&nargs, sfe->nameval);
 		if (error)
 			goto out;
 		sfe =3D XFS_ATTR_SF_NEXTENTRY(sfe);
@@ -631,7 +626,7 @@ xfs_attr_shortform_list(xfs_attr_list_co
 				continue;
 			}
 			namesp =3D xfs_attr_flags_namesp(sfe->flags);
-			error =3D context->put_listent(context,
+			error =3D xfs_attr_put_listent(context,
 					   namesp,
 					   (char *)sfe->nameval,
 					   (int)sfe->namelen,
@@ -734,7 +729,7 @@ xfs_attr_shortform_list(xfs_attr_list_co
 			cursor->hashval =3D sbp->hash;
 			cursor->offset =3D 0;
 		}
-		error =3D context->put_listent(context,
+		error =3D xfs_attr_put_listent(context,
 					namesp,
 					sbp->name,
 					sbp->namelen,
@@ -1960,6 +1955,7 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp
 	xfs_attr_leaf_name_remote_t *name_rmt;
 	int probe, span;
 	xfs_dahash_t hashval;
+	xfs_dacmp_t cmp;
 =

 	leaf =3D bp->data;
 	ASSERT(be16_to_cpu(leaf->hdr.info.magic) =3D=3D XFS_ATTR_LEAF_MAGIC);
@@ -2008,6 +2004,7 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp
 	/*
 	 * Duplicate keys may be present, so search all of them for a match.
 	 */
+	args->cmpresult =3D XFS_CMP_DIFFERENT;
 	for (  ; (probe < be16_to_cpu(leaf->hdr.count)) &&
 			(be32_to_cpu(entry->hashval) =3D=3D hashval);
 			entry++, probe++) {
@@ -2019,35 +2016,46 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp
 		 * If we are looking for complete entries, show only those.
 		 */
 		if ((args->flags & XFS_ATTR_INCOMPLETE) !=3D
-		    (entry->flags & XFS_ATTR_INCOMPLETE)) {
+				(entry->flags & XFS_ATTR_INCOMPLETE))
+			continue;
+		if (!xfs_attr_namesp_match(args->flags, entry->flags))
 			continue;
-		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			name_loc =3D XFS_ATTR_LEAF_NAME_LOCAL(leaf, probe);
-			if (name_loc->namelen !=3D args->namelen)
-				continue;
-			if (memcmp(args->name, (char *)name_loc->nameval, args->namelen) !=3D=
 0)
-				continue;
-			if (!xfs_attr_namesp_match(args->flags, entry->flags))
-				continue;
-			args->index =3D probe;
-			return(XFS_ERROR(EEXIST));
+			cmp =3D xfs_attr_compname(args->dp, args->name,
+					args->namelen, name_loc->nameval,
+					name_loc->namelen);
+			if (cmp !=3D XFS_CMP_DIFFERENT &&
+					cmp !=3D args->cmpresult) {
+				args->cmpresult =3D cmp;
+				args->index =3D probe;
+				args->rmtblkno =3D 0;
+				args->rmtblkcnt =3D 0;
+				if (cmp =3D=3D XFS_CMP_EXACT)
+					return XFS_ERROR(EEXIST);
+			}
 		} else {
 			name_rmt =3D XFS_ATTR_LEAF_NAME_REMOTE(leaf, probe);
-			if (name_rmt->namelen !=3D args->namelen)
-				continue;
-			if (memcmp(args->name, (char *)name_rmt->name,
-					     args->namelen) !=3D 0)
-				continue;
-			if (!xfs_attr_namesp_match(args->flags, entry->flags))
-				continue;
-			args->index =3D probe;
-			args->rmtblkno =3D be32_to_cpu(name_rmt->valueblk);
-			args->rmtblkcnt =3D XFS_B_TO_FSB(args->dp->i_mount,
-						   be32_to_cpu(name_rmt->valuelen));
-			return(XFS_ERROR(EEXIST));
+			cmp =3D xfs_attr_compname(args->dp, args->name,
+					args->namelen, name_rmt->name,
+					name_rmt->namelen);
+			if (cmp !=3D XFS_CMP_DIFFERENT &&
+					cmp !=3D args->cmpresult) {
+				args->cmpresult =3D cmp;
+				args->index =3D probe;
+				args->rmtblkno =3D
+					be32_to_cpu(name_rmt->valueblk);
+				args->rmtblkcnt =3D
+					XFS_B_TO_FSB(args->dp->i_mount,
+					    be32_to_cpu(name_rmt->valuelen));
+				if (cmp =3D=3D XFS_CMP_EXACT)
+					return XFS_ERROR(EEXIST);
+			}
 		}
 	}
+	if (args->cmpresult =3D=3D XFS_CMP_CASE)
+		return XFS_ERROR(EEXIST);
+
 	args->index =3D probe;
 	return(XFS_ERROR(ENOATTR));
 }
@@ -2074,8 +2082,9 @@ xfs_attr_leaf_getvalue(xfs_dabuf_t *bp, =

 	entry =3D &leaf->entries[args->index];
 	if (entry->flags & XFS_ATTR_LOCAL) {
 		name_loc =3D XFS_ATTR_LEAF_NAME_LOCAL(leaf, args->index);
-		ASSERT(name_loc->namelen =3D=3D args->namelen);
-		ASSERT(memcmp(args->name, name_loc->nameval, args->namelen) =3D=3D 0)=
;
+		ASSERT(xfs_attr_compname(args->dp, args->name, args->namelen,
+			name_loc->nameval, name_loc->namelen) !=3D
+				XFS_CMP_DIFFERENT);
 		valuelen =3D be16_to_cpu(name_loc->valuelen);
 		if (args->flags & ATTR_KERNOVAL) {
 			args->valuelen =3D valuelen;
@@ -2086,11 +2095,13 @@ xfs_attr_leaf_getvalue(xfs_dabuf_t *bp, =

 			return(XFS_ERROR(ERANGE));
 		}
 		args->valuelen =3D valuelen;
-		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
+		memcpy(args->value, &name_loc->nameval[args->namelen],
+				valuelen);
 	} else {
 		name_rmt =3D XFS_ATTR_LEAF_NAME_REMOTE(leaf, args->index);
-		ASSERT(name_rmt->namelen =3D=3D args->namelen);
-		ASSERT(memcmp(args->name, name_rmt->name, args->namelen) =3D=3D 0);
+		ASSERT(xfs_attr_compname(args->dp, args->name, args->namelen,
+			name_rmt->nameval, name_rmt->namelen) !=3D
+				XFS_CMP_DIFFERENT);
 		valuelen =3D be32_to_cpu(name_rmt->valuelen);
 		args->rmtblkno =3D be32_to_cpu(name_rmt->valueblk);
 		args->rmtblkcnt =3D XFS_B_TO_FSB(args->dp->i_mount, valuelen);
@@ -2298,7 +2309,8 @@ xfs_attr_leaf_lasthash(xfs_dabuf_t *bp, =

 		*count =3D be16_to_cpu(leaf->hdr.count);
 	if (!leaf->hdr.count)
 		return(0);
-	return be32_to_cpu(leaf->entries[be16_to_cpu(leaf->hdr.count)-1].hashv=
al);
+	return be32_to_cpu(
+			leaf->entries[be16_to_cpu(leaf->hdr.count)-1].hashval);
 }
 =

 /*
@@ -2316,7 +2328,7 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock
 	if (leaf->entries[index].flags & XFS_ATTR_LOCAL) {
 		name_loc =3D XFS_ATTR_LEAF_NAME_LOCAL(leaf, index);
 		size =3D XFS_ATTR_LEAF_ENTSIZE_LOCAL(name_loc->namelen,
-						   be16_to_cpu(name_loc->valuelen));
+					be16_to_cpu(name_loc->valuelen));
 	} else {
 		name_rmt =3D XFS_ATTR_LEAF_NAME_REMOTE(leaf, index);
 		size =3D XFS_ATTR_LEAF_ENTSIZE_REMOTE(name_rmt->namelen);
@@ -2409,7 +2421,8 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, =

 =

 		if (entry->flags & XFS_ATTR_INCOMPLETE)
 			continue;		/* skip incomplete entries */
-		if (!xfs_attr_namesp_match_overrides(context->flags, entry->flags))
+		if (!xfs_attr_namesp_match_overrides(context->flags,
+				entry->flags))
 			continue;
 =

 		namesp =3D xfs_attr_flags_namesp(entry->flags);
@@ -2418,12 +2431,13 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, =

 			xfs_attr_leaf_name_local_t *name_loc =3D
 				XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
 =

-			retval =3D context->put_listent(context,
+			retval =3D xfs_attr_put_listent(context,
 						namesp,
 						(char *)name_loc->nameval,
 						(int)name_loc->namelen,
 						be16_to_cpu(name_loc->valuelen),
-						(char *)&name_loc->nameval[name_loc->namelen]);
+						(char *)&name_loc->
+						    nameval[name_loc->namelen]);
 			if (retval)
 				return retval;
 		} else {
@@ -2441,11 +2455,12 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, =

 				args.valuelen =3D valuelen;
 				args.value =3D kmem_alloc(valuelen, KM_SLEEP);
 				args.rmtblkno =3D be32_to_cpu(name_rmt->valueblk);
-				args.rmtblkcnt =3D XFS_B_TO_FSB(args.dp->i_mount, valuelen);
+				args.rmtblkcnt =3D XFS_B_TO_FSB(args.dp->i_mount,
+						valuelen);
 				retval =3D xfs_attr_rmtval_get(&args);
 				if (retval)
 					return retval;
-				retval =3D context->put_listent(context,
+				retval =3D xfs_attr_put_listent(context,
 						namesp,
 						(char *)name_rmt->name,
 						(int)name_rmt->namelen,
@@ -2454,7 +2469,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, =

 				kmem_free(args.value, valuelen);
 			}
 			else {
-				retval =3D context->put_listent(context,
+				retval =3D xfs_attr_put_listent(context,
 						namesp,
 						(char *)name_rmt->name,
 						(int)name_rmt->namelen,
@@ -2472,6 +2487,33 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, =

 	return(retval);
 }
 =

+/*
+ * Do NLS name conversion if required for attribute name and call
+ * context's put_listent routine
+ */
+
+STATIC int
+xfs_attr_put_listent(xfs_attr_list_context_t *context, attrnames_t *nam=
esp,
+	char *name, int namelen, int valuelen, char *value)
+{
+	xfs_mount_t *mp =3D context->dp->i_mount;
+	char *nls_name =3D NULL;
+	int nls_namelen;
+	int rval;
+
+	if (!mp->m_nls)
+		return context->put_listent(context, namesp, name, namelen,
+				valuelen, value);
+
+	rval =3D xfs_unicode_to_nls(mp->m_nls, name, namelen, &nls_name,
+			&nls_namelen);
+	if (rval !=3D 0)
+		return rval;
+	rval =3D context->put_listent(context, namesp, nls_name, nls_namelen,
+			valuelen, value);
+	xfs_free_unicode_nls_name(nls_name);
+	return rval;
+}
 =

 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  * Manage the INCOMPLETE flag in a leaf entry
@@ -2522,8 +2564,8 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *a
 		name =3D (char *)name_rmt->name;
 	}
 	ASSERT(be32_to_cpu(entry->hashval) =3D=3D args->hashval);
-	ASSERT(namelen =3D=3D args->namelen);
-	ASSERT(memcmp(name, args->name, namelen) =3D=3D 0);
+	ASSERT(xfs_attr_compname(args->dp, args->name, args->namelen,
+			name, namelen) !=3D XFS_CMP_DIFFERENT);
 #endif /* DEBUG */
 =

 	entry->flags &=3D ~XFS_ATTR_INCOMPLETE;
@@ -2674,8 +2716,8 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *a
 		name2 =3D (char *)name_rmt->name;
 	}
 	ASSERT(be32_to_cpu(entry1->hashval) =3D=3D be32_to_cpu(entry2->hashval=
));
-	ASSERT(namelen1 =3D=3D namelen2);
-	ASSERT(memcmp(name1, name2, namelen1) =3D=3D 0);
+	ASSERT(xfs_attr_compname(args->dp, name1, namelen1, name2, namelen2) !=
=3D
+			XFS_CMP_DIFFERENT);
 #endif /* DEBUG */
 =

 	ASSERT(entry1->flags & XFS_ATTR_INCOMPLETE);
@@ -2834,7 +2876,8 @@ xfs_attr_node_inactive(xfs_trans_t **tra
 			if (be16_to_cpu(info->magic) =3D=3D XFS_DA_NODE_MAGIC) {
 				error =3D xfs_attr_node_inactive(trans, dp,
 						child_bp, level+1);
-			} else if (be16_to_cpu(info->magic) =3D=3D XFS_ATTR_LEAF_MAGIC) {
+			} else if (be16_to_cpu(info->magic) =3D=3D
+					XFS_ATTR_LEAF_MAGIC) {
 				error =3D xfs_attr_leaf_inactive(trans, dp,
 						child_bp);
 			} else {
@@ -2935,7 +2978,7 @@ xfs_attr_leaf_inactive(xfs_trans_t **tra
 			if (name_rmt->valueblk) {
 				lp->valueblk =3D be32_to_cpu(name_rmt->valueblk);
 				lp->valuelen =3D XFS_B_TO_FSB(dp->i_mount,
-						    be32_to_cpu(name_rmt->valuelen));
+					be32_to_cpu(name_rmt->valuelen));
 				lp++;
 			}
 		}

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_attr_leaf.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_attr_leaf.h	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/xfs_attr_leaf.h	2008-01-11 14:16:44.268796245 +1100
@@ -36,6 +36,7 @@ struct xfs_da_args;
 struct xfs_da_state;
 struct xfs_da_state_blk;
 struct xfs_inode;
+struct xfs_mount;
 struct xfs_trans;
 =

 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
@@ -204,6 +205,16 @@ static inline int xfs_attr_leaf_entsize_
 	return (((bsize) >> 1) + ((bsize) >> 2));
 }
 =

+/*
+ * Do hash and name compare based on nameops
+ */
+#define xfs_attr_hashname(dp, n, l) \
+		((dp)->i_mount->m_attrnameops->hashname((dp), (n), (l)))
+
+#define xfs_attr_compname(dp, n1, l1, n2, l2) \
+		((dp)->i_mount->m_attrnameops->compname((dp), (n1), (l1), \
+							(n2), (l2)))
+
 =

 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  * Structure used to pass context around among the routines.
@@ -296,6 +307,7 @@ int	xfs_attr_root_inactive(struct xfs_tr
 /*
  * Utility routines.
  */
+void	xfs_attr_mount(struct xfs_mount *mp);
 xfs_dahash_t	xfs_attr_leaf_lasthash(struct xfs_dabuf *bp, int *count);
 int	xfs_attr_leaf_order(struct xfs_dabuf *leaf1_bp,
 				   struct xfs_dabuf *leaf2_bp);

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_clnt.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_clnt.h	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/xfs_clnt.h	2007-11-01 13:16:55.000383139 +1100
@@ -48,6 +48,7 @@ struct xfs_mount_args {
 	char	rtname[MAXNAMELEN+1];	/* realtime device filename */
 	char	logname[MAXNAMELEN+1];	/* journal device filename */
 	char	mtpt[MAXNAMELEN+1];	/* filesystem mount point */
+	char	nls[MAXNAMELEN+1];	/* NLS code page to use */
 	int	sunit;		/* stripe unit (BBs) */
 	int	swidth;		/* stripe width (BBs), multiple of sunit */
 	uchar_t iosizelog;	/* log2 of the preferred I/O size */
@@ -100,5 +101,9 @@ struct xfs_mount_args {
 						 * I/O size in stat(2) */
 #define XFSMNT2_FILESTREAMS	0x00000002	/* enable the filestreams
 						 * allocator */
+#define XFSMNT2_CILOOKUP	0x00000004	/* enable case-insensitive
+						 * filename lookup */
+#define XFSMNT2_CIATTR		0x00000008	/* enable case-insensitive
+						 * extended attr names */
 =

 #endif	/* __XFS_CLNT_H__ */

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_da_btree.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_da_btree.c	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/xfs_da_btree.c	2008-01-21 14:23:59.544205024 +1100
@@ -46,6 +46,7 @@
 #include "xfs_dir2_block.h"
 #include "xfs_dir2_node.h"
 #include "xfs_error.h"
+#include "xfs_unicode.h"
 =

 /*
  * xfs_da_btree.c
@@ -1530,6 +1531,106 @@ xfs_da_hashname(const uchar_t *name, int
 	}
 }
 =

+
+static xfs_dahash_t
+xfs_default_hashname(xfs_inode_t *inode, const uchar_t *name, int namel=
en)
+{
+	return xfs_da_hashname(name, namelen);
+}
+
+xfs_dacmp_t
+xfs_default_compname(xfs_inode_t *inode, const uchar_t *name1, int len1=
,
+	const uchar_t *name2, int len2)
+{
+	return (len1 =3D=3D len2 && memcmp(name1, name2, len1) =3D=3D 0) ?
+			XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
+}
+
+static xfs_dahash_t
+xfs_unicode_ci_hashname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name,
+	int		namelen)
+{
+	return xfs_unicode_hash(inode->i_mount->m_cft, name, namelen);
+}
+
+static xfs_dacmp_t
+xfs_unicode_ci_compname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
+	int 		len2)
+{
+	if (len1 =3D=3D len2 && memcmp(name1, name2, len1) =3D=3D 0)
+		return XFS_CMP_EXACT;
+
+	return xfs_unicode_casecmp(inode->i_mount->m_cft, name1, len1,
+			name2, len2) =3D=3D 0 ? XFS_CMP_CASE : XFS_CMP_DIFFERENT;
+}
+
+const struct xfs_nameops xfs_default_nameops =3D {
+	.hashname	=3D xfs_default_hashname,
+	.compname	=3D xfs_default_compname
+};
+
+const struct xfs_nameops xfs_unicode_nameops =3D {
+	.hashname	=3D xfs_unicode_ci_hashname,
+	.compname	=3D xfs_default_compname,
+};
+
+const struct xfs_nameops xfs_unicode_ci_nameops =3D {
+	.hashname	=3D xfs_unicode_ci_hashname,
+	.compname	=3D xfs_unicode_ci_compname,
+};
+
+int
+xfs_da_setup_name_and_hash(
+	xfs_da_args_t		*args,
+	const char 		*name,
+	int			namelen)
+{
+	xfs_mount_t		*mp =3D args->dp->i_mount;
+	int			error;
+
+	/*
+	 * xfs_nls_to_unicode will return an allocated string in
+	 * args->name. Therefore, all calls to xfs_da_setup_name_and_hash
+	 * needs a corresponding call to xfs_da_cleanup_name.
+	 */
+
+	if (mp->m_nls) {
+		args->name =3D NULL;
+		error =3D xfs_nls_to_unicode(mp->m_nls, name, namelen,
+				(char **)&args->name, &args->namelen);
+		if (error)
+			return error;
+	} else {
+		if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+			error =3D xfs_unicode_validate(name, namelen);
+			if (error)
+				return error;
+		}
+		args->name =3D name;
+		args->namelen =3D namelen;
+	}
+	args->hashval =3D (args->whichfork =3D=3D XFS_ATTR_FORK) ?
+		xfs_attr_hashname(args->dp, args->name, args->namelen) :
+		xfs_dir_hashname(args->dp, args->name, args->namelen);
+	return 0;
+}
+
+void
+xfs_da_cleanup_name(
+	xfs_da_args_t		*args,
+	const char		*name)
+{
+	if ((char *)args->name !=3D name)
+		xfs_free_unicode_nls_name((char *)args->name);
+}
+
+
 /*
  * Add a block to the btree ahead of the file.
  * Return the new block number to the caller.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_da_btree.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_da_btree.h	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/xfs_da_btree.h	2008-01-14 12:12:32.917055949 +1100
@@ -99,12 +99,21 @@ typedef struct xfs_da_node_entry xfs_da_
  *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
 =

 /*
+ * Search comparison results
+ */
+typedef enum {
+	XFS_CMP_DIFFERENT,	/* names are completely different */
+	XFS_CMP_EXACT,		/* names are exactly the same */
+	XFS_CMP_CASE		/* names are same but differ in case */
+} xfs_dacmp_t;
+
+/*
  * Structure to ease passing around component names.
  */
 typedef struct xfs_da_args {
 	const uchar_t	*name;		/* string (maybe not NULL terminated) */
 	int		namelen;	/* length of string (maybe no NULL) */
-	uchar_t		*value;		/* set of bytes (maybe contain NULLs) */
+	uchar_t		*value; 	/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
 	xfs_dahash_t	hashval;	/* hash value of name */
@@ -127,6 +136,7 @@ typedef struct xfs_da_args {
 	unsigned char	rename;		/* T/F: this is an atomic rename op */
 	unsigned char	addname;	/* T/F: this is an add operation */
 	unsigned char	oknoent;	/* T/F: ok to return ENOENT, else die */
+	xfs_dacmp_t	cmpresult;	/* name compare result for lookups */
 } xfs_da_args_t;
 =

 /*
@@ -201,12 +211,37 @@ typedef struct xfs_da_state {
 		(uint)(XFS_DA_LOGOFF(BASE, ADDR)), \
 		(uint)(XFS_DA_LOGOFF(BASE, ADDR)+(SIZE)-1)
 =

+/*
+ * Name ops for directory and/or attr name operations
+ */
+
+typedef xfs_dahash_t	(*xfs_hashname_t)(struct xfs_inode *, const uchar_=
t *,
+					int);
+typedef xfs_dacmp_t	(*xfs_compname_t)(struct xfs_inode *, const uchar_t=
 *,
+					int, const uchar_t *, int);
+
+typedef struct xfs_nameops {
+	xfs_hashname_t		hashname;
+	xfs_compname_t		compname;
+} xfs_nameops_t;
+
 =

 #ifdef __KERNEL__
 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  * Function prototypes for the kernel.
  *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
 =

+extern const struct xfs_nameops xfs_default_nameops;
+extern const struct xfs_nameops xfs_unicode_nameops;
+extern const struct xfs_nameops xfs_unicode_ci_nameops;
+
+xfs_dacmp_t xfs_default_compname(struct xfs_inode *inode, const uchar_t=
 *name1,
+				int len1, const uchar_t *name2, int len2);
+
+int	xfs_da_setup_name_and_hash(xfs_da_args_t *args, const char *name,
+				int namelen);
+void	xfs_da_cleanup_name(xfs_da_args_t *args, const char *name);
+
 /*
  * Routines used for growing the Btree.
  */

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_dir2.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_dir2.c	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/xfs_dir2.c	2008-01-21 13:21:20.375779062 +1100
@@ -42,8 +42,58 @@
 #include "xfs_dir2_node.h"
 #include "xfs_dir2_trace.h"
 #include "xfs_error.h"
+#include "xfs_unicode.h"
 #include "xfs_vnodeops.h"
 =

+/*
+ * V1/OLDCI case-insensitive support for directories
+ *
+ * This is ASCII only case support, ie. A-Z.
+ */
+static xfs_dahash_t
+xfs_ascii_ci_hashname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name,
+	int		namelen)
+{
+	xfs_dahash_t	hash;
+	int		i;
+
+	for (i =3D 0, hash =3D 0; i < namelen; i++)
+		hash =3D tolower(name[i]) ^ rol32(hash, 7);
+
+	return hash;
+}
+
+static xfs_dacmp_t
+xfs_ascii_ci_compname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
+	int 		len2)
+{
+	xfs_dacmp_t	result =3D XFS_CMP_EXACT;
+	int		i;
+
+	if (len1 !=3D len2)
+		return XFS_CMP_DIFFERENT;
+
+	for (i =3D 0; i < len1; i++) {
+		if (name1[i] =3D=3D name2[i])
+			continue;
+		if (tolower(name1[i]) !=3D tolower(name2[i]))
+			return XFS_CMP_DIFFERENT;
+		result =3D XFS_CMP_CASE;
+	}
+
+	return result;
+}
+
+static const struct xfs_nameops xfs_ascii_ci_nameops =3D {
+	.hashname	=3D xfs_ascii_ci_hashname,
+	.compname	=3D xfs_ascii_ci_compname,
+};
 =

 void
 xfs_dir_mount(
@@ -64,6 +114,13 @@ xfs_dir_mount(
 		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
 		(uint)sizeof(xfs_da_node_entry_t);
 	mp->m_dir_magicpct =3D (mp->m_dirblksize * 37) / 100;
+
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		mp->m_dirnameops =3D (mp->m_flags & XFS_MOUNT_CI_LOOKUP) ?
+			&xfs_unicode_ci_nameops : &xfs_unicode_nameops;
+	} else
+		mp->m_dirnameops =3D (xfs_sb_version_hasoldci(&mp->m_sb)) ?
+			&xfs_ascii_ci_nameops : &xfs_default_nameops;
 }
 =

 /*
@@ -140,7 +197,7 @@ xfs_dir_init(
 }
 =

 /*
-  Enter a name in a directory.
+ * Enter a name in a directory.
  */
 int
 xfs_dir_createname(
@@ -162,9 +219,6 @@ xfs_dir_createname(
 		return rval;
 	XFS_STATS_INC(xs_dir_create);
 =

-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
 	args.inumber =3D inum;
 	args.dp =3D dp;
 	args.firstblock =3D first;
@@ -174,32 +228,41 @@ xfs_dir_createname(
 	args.trans =3D tp;
 	args.justcheck =3D 0;
 	args.addname =3D args.oknoent =3D 1;
+	rval =3D xfs_da_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;
 =

 	if (dp->i_d.di_format =3D=3D XFS_DINODE_FMT_LOCAL)
 		rval =3D xfs_dir2_sf_addname(&args);
 	else if ((rval =3D xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out;
 	else if (v)
 		rval =3D xfs_dir2_block_addname(&args);
 	else if ((rval =3D xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out;
 	else if (v)
 		rval =3D xfs_dir2_leaf_addname(&args);
 	else
 		rval =3D xfs_dir2_node_addname(&args);
+out:
+	xfs_da_cleanup_name(&args, name);
 	return rval;
 }
 =

 /*
- * Lookup a name in a directory, give back the inode number.
+ * Lookup a name in a directory, give back the inode number and also
+ * actual name if case-insensitive match.
  */
+
 int
 xfs_dir_lookup(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*dp,
 	char		*name,
 	int		namelen,
-	xfs_ino_t	*inum)		/* out: inode number */
+	xfs_ino_t	*inum,		/* out: inode number */
+	char		**actual_name,	/* out: actual name if different */
+	int		*actual_namelen)
 {
 	xfs_da_args_t	args;
 	int		rval;
@@ -208,9 +271,9 @@ xfs_dir_lookup(
 	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
 	XFS_STATS_INC(xs_dir_lookup);
 =

-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	if (actual_name)
+		*actual_name =3D NULL;
+
 	args.inumber =3D 0;
 	args.dp =3D dp;
 	args.firstblock =3D NULL;
@@ -220,23 +283,39 @@ xfs_dir_lookup(
 	args.trans =3D tp;
 	args.justcheck =3D args.addname =3D 0;
 	args.oknoent =3D 1;
+	args.value =3D NULL;	/* value may contain actual name on return */
+	args.valuelen =3D 0;
+	rval =3D xfs_da_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;
 =

 	if (dp->i_d.di_format =3D=3D XFS_DINODE_FMT_LOCAL)
 		rval =3D xfs_dir2_sf_lookup(&args);
 	else if ((rval =3D xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out;
 	else if (v)
 		rval =3D xfs_dir2_block_lookup(&args);
 	else if ((rval =3D xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out;
 	else if (v)
 		rval =3D xfs_dir2_leaf_lookup(&args);
 	else
 		rval =3D xfs_dir2_node_lookup(&args);
 	if (rval =3D=3D EEXIST)
 		rval =3D 0;
-	if (rval =3D=3D 0)
+	if (rval =3D=3D 0) {
 		*inum =3D args.inumber;
+		if (args.value) {
+			ASSERT(args->cmpresult =3D=3D XFS_CMP_CASE);
+			if (actual_name) {
+				*actual_namelen =3D args.valuelen,
+				*actual_name =3D args.value;
+			} else
+				xfs_free_unicode_nls_name(args.value);
+		}
+	}
+out:
+	xfs_da_cleanup_name(&args, name);
 	return rval;
 }
 =

@@ -261,9 +340,6 @@ xfs_dir_removename(
 	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
 	XFS_STATS_INC(xs_dir_remove);
 =

-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
 	args.inumber =3D ino;
 	args.dp =3D dp;
 	args.firstblock =3D first;
@@ -272,19 +348,24 @@ xfs_dir_removename(
 	args.whichfork =3D XFS_DATA_FORK;
 	args.trans =3D tp;
 	args.justcheck =3D args.addname =3D args.oknoent =3D 0;
+	rval =3D xfs_da_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;
 =

 	if (dp->i_d.di_format =3D=3D XFS_DINODE_FMT_LOCAL)
 		rval =3D xfs_dir2_sf_removename(&args);
 	else if ((rval =3D xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out;
 	else if (v)
 		rval =3D xfs_dir2_block_removename(&args);
 	else if ((rval =3D xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out;
 	else if (v)
 		rval =3D xfs_dir2_leaf_removename(&args);
 	else
 		rval =3D xfs_dir2_node_removename(&args);
+out:
+	xfs_da_cleanup_name(&args, name);
 	return rval;
 }
 =

@@ -345,9 +426,6 @@ xfs_dir_replace(
 	if ((rval =3D xfs_dir_ino_validate(tp->t_mountp, inum)))
 		return rval;
 =

-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
 	args.inumber =3D inum;
 	args.dp =3D dp;
 	args.firstblock =3D first;
@@ -356,19 +434,24 @@ xfs_dir_replace(
 	args.whichfork =3D XFS_DATA_FORK;
 	args.trans =3D tp;
 	args.justcheck =3D args.addname =3D args.oknoent =3D 0;
+	rval =3D xfs_da_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;
 =

 	if (dp->i_d.di_format =3D=3D XFS_DINODE_FMT_LOCAL)
 		rval =3D xfs_dir2_sf_replace(&args);
 	else if ((rval =3D xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out;
 	else if (v)
 		rval =3D xfs_dir2_block_replace(&args);
 	else if ((rval =3D xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out;
 	else if (v)
 		rval =3D xfs_dir2_leaf_replace(&args);
 	else
 		rval =3D xfs_dir2_node_replace(&args);
+out:
+	xfs_da_cleanup_name(&args, name);
 	return rval;
 }
 =

@@ -388,9 +471,6 @@ xfs_dir_canenter(
 =

 	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
 =

-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
 	args.inumber =3D 0;
 	args.dp =3D dp;
 	args.firstblock =3D NULL;
@@ -399,19 +479,24 @@ xfs_dir_canenter(
 	args.whichfork =3D XFS_DATA_FORK;
 	args.trans =3D tp;
 	args.justcheck =3D args.addname =3D args.oknoent =3D 1;
+	rval =3D xfs_da_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;
 =

 	if (dp->i_d.di_format =3D=3D XFS_DINODE_FMT_LOCAL)
 		rval =3D xfs_dir2_sf_addname(&args);
 	else if ((rval =3D xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out;
 	else if (v)
 		rval =3D xfs_dir2_block_addname(&args);
 	else if ((rval =3D xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out;
 	else if (v)
 		rval =3D xfs_dir2_leaf_addname(&args);
 	else
 		rval =3D xfs_dir2_node_addname(&args);
+out:
+	xfs_da_cleanup_name(&args, name);
 	return rval;
 }
 =


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_dir2.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_dir2.h	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/xfs_dir2.h	2007-11-01 13:11:00.206583735 +1100
@@ -72,7 +72,8 @@ extern int xfs_dir_createname(struct xfs
 				xfs_fsblock_t *first,
 				struct xfs_bmap_free *flist, xfs_extlen_t tot);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
-				char *name, int namelen, xfs_ino_t *inum);
+				char *name, int namelen, xfs_ino_t *inum,
+				char **actual_name, int *actual_namelen);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *d=
p,
 				char *name, int namelen, xfs_ino_t ino,
 				xfs_fsblock_t *first,
@@ -85,6 +86,13 @@ extern int xfs_dir_canenter(struct xfs_t
 				char *name, int namelen);
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 =

+#define xfs_dir_hashname(dp, n, l) \
+		((dp)->i_mount->m_dirnameops->hashname((dp), (n), (l)))
+
+#define xfs_dir_compname(dp, n1, l1, n2, l2) \
+		((dp)->i_mount->m_dirnameops->compname((dp), (n1), (l1), \
+							(n2), (l2)))
+
 /*
  * Utility routines for v2 directories.
  */

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_dir2_block.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_dir2_block.c	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/xfs_dir2_block.c	2008-01-21 13:50:21.175545312 +1100
@@ -38,6 +38,7 @@
 #include "xfs_dir2_block.h"
 #include "xfs_dir2_trace.h"
 #include "xfs_error.h"
+#include "xfs_unicode.h"
 =

 /*
  * Local function prototypes.
@@ -450,6 +451,8 @@ xfs_dir2_block_getdents(
 	int			wantoff;	/* starting block offset */
 	xfs_ino_t		ino;
 	xfs_off_t		cook;
+	char			*nls_name =3D NULL; /* NLS name buffer */
+	int			nls_namelen =3D 0;
 =

 	mp =3D dp->i_mount;
 	/*
@@ -481,6 +484,9 @@ xfs_dir2_block_getdents(
 	ptr =3D (char *)block->u;
 	endptr =3D (char *)xfs_dir2_block_leaf_p(btp);
 =

+	if (mp->m_nls)
+		nls_name =3D xfs_alloc_unicode_nls_name();
+
 	/*
 	 * Loop over the data portion of the block.
 	 * Each object is a real entry (dep) or an unused one (dup).
@@ -513,15 +519,24 @@ xfs_dir2_block_getdents(
 #if XFS_BIG_INUMS
 		ino +=3D mp->m_inoadd;
 #endif
+		if (mp->m_nls) {
+			error =3D xfs_unicode_to_nls(mp->m_nls, dep->name,
+					dep->namelen, &nls_name, &nls_namelen);
+			if (error) {
+				xfs_da_brelse(NULL, bp);
+				return error;
+			}
+		}
 =

 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
-		if (filldir(dirent, dep->name, dep->namelen, cook,
-			    ino, DT_UNKNOWN)) {
+		if (filldir(dirent,
+				nls_namelen ? nls_name : (char *)dep->name,
+				nls_namelen ? nls_namelen : dep->namelen,
+				cook, ino, DT_UNKNOWN)) {
 			*offset =3D cook;
-			xfs_da_brelse(NULL, bp);
-			return 0;
+			goto out;
 		}
 	}
 =

@@ -530,6 +545,9 @@ xfs_dir2_block_getdents(
 	 * Set the offset to a non-existent block 1 and return.
 	 */
 	*offset =3D xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
+out:
+	if (mp->m_nls)
+		xfs_free_unicode_nls_name(nls_name);
 	xfs_da_brelse(NULL, bp);
 	return 0;
 }
@@ -616,6 +634,14 @@ xfs_dir2_block_lookup(
 	 * Fill in inode number, release the block.
 	 */
 	args->inumber =3D be64_to_cpu(dep->inumber);
+	if (args->cmpresult =3D=3D XFS_CMP_CASE) {
+		error =3D xfs_unicode_to_nls(mp->m_nls, dep->name, dep->namelen,
+				(char **)&args->value, &args->valuelen);
+		if (error) {
+			xfs_da_brelse(args->trans, bp);
+			return XFS_ERROR(error);
+		}
+	}
 	xfs_da_brelse(args->trans, bp);
 	return XFS_ERROR(EEXIST);
 }
@@ -643,6 +669,7 @@ xfs_dir2_block_lookup_int(
 	int			mid;		/* binary search current idx */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	xfs_dacmp_t		cmp;		/* comparison result */
 =

 	dp =3D args->dp;
 	tp =3D args->trans;
@@ -688,6 +715,7 @@ xfs_dir2_block_lookup_int(
 	 * Now loop forward through all the entries with the
 	 * right hash value looking for our name.
 	 */
+	args->cmpresult =3D XFS_CMP_DIFFERENT;
 	do {
 		if ((addr =3D be32_to_cpu(blp[mid].address)) =3D=3D XFS_DIR2_NULL_DAT=
APTR)
 			continue;
@@ -697,20 +725,34 @@ xfs_dir2_block_lookup_int(
 		dep =3D (xfs_dir2_data_entry_t *)
 			((char *)block + xfs_dir2_dataptr_to_off(mp, addr));
 		/*
-		 * Compare, if it's right give back buffer & entry number.
-		 */
-		if (dep->namelen =3D=3D args->namelen &&
-		    dep->name[0] =3D=3D args->name[0] &&
-		    memcmp(dep->name, args->name, args->namelen) =3D=3D 0) {
+		 * Compare, if it's right give back buffer & entry number:
+		 *
+		 * lookup case - use nameops;
+		 *
+		 * replace/remove case - as lookup has been already been
+		 * performed, look for an exact match using the fast method
+		 */
+		cmp =3D args->oknoent ?
+			xfs_dir_compname(dp, dep->name, dep->namelen,
+						args->name, args->namelen) :
+			xfs_default_compname(dp, dep->name, dep->namelen,
+						args->name, args->namelen);
+		if (cmp !=3D XFS_CMP_DIFFERENT && cmp !=3D args->cmpresult) {
+			args->cmpresult =3D cmp;
 			*bpp =3D bp;
 			*entno =3D mid;
-			return 0;
+			if (cmp =3D=3D XFS_CMP_EXACT)
+				return 0;
 		}
-	} while (++mid < be32_to_cpu(btp->count) && be32_to_cpu(blp[mid].hashv=
al) =3D=3D hash);
+	} while (++mid < be32_to_cpu(btp->count) &&
+			be32_to_cpu(blp[mid].hashval) =3D=3D hash);
+
+	ASSERT(args->oknoent);
+	if (args->cmpresult =3D=3D XFS_CMP_CASE)
+		return 0;
 	/*
 	 * No match, release the buffer and return ENOENT.
 	 */
-	ASSERT(args->oknoent);
 	xfs_da_brelse(tp, bp);
 	return XFS_ERROR(ENOENT);
 }
@@ -1187,8 +1229,8 @@ xfs_dir2_sf_to_block(
 		tagp =3D xfs_dir2_data_entry_tag_p(dep);
 		*tagp =3D cpu_to_be16((char *)dep - (char *)block);
 		xfs_dir2_data_log_entry(tp, bp, dep);
-		blp[2 + i].hashval =3D cpu_to_be32(xfs_da_hashname(
-					(char *)sfep->name, sfep->namelen));
+		blp[2 + i].hashval =3D cpu_to_be32(xfs_dir_hashname(dp,
+						sfep->name, sfep->namelen));
 		blp[2 + i].address =3D cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 						 (char *)dep - (char *)block));
 		offset =3D (int)((char *)(tagp + 1) - (char *)block);

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_dir2_data.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_dir2_data.c	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/xfs_dir2_data.c	2008-01-21 14:33:22.540095423 +1100
@@ -140,7 +140,8 @@ xfs_dir2_data_check(
 			addr =3D xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)d));
-			hash =3D xfs_da_hashname((char *)dep->name, dep->namelen);
+			hash =3D xfs_dir_hashname(dp, (char *)dep->name,
+					dep->namelen);
 			for (i =3D 0; i < be32_to_cpu(btp->count); i++) {
 				if (be32_to_cpu(lep[i].address) =3D=3D addr &&
 				    be32_to_cpu(lep[i].hashval) =3D=3D hash)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_dir2_leaf.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_dir2_leaf.c	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/xfs_dir2_leaf.c	2008-01-21 14:16:01.621460279 +1100
@@ -40,6 +40,7 @@
 #include "xfs_dir2_node.h"
 #include "xfs_dir2_trace.h"
 #include "xfs_error.h"
+#include "xfs_unicode.h"
 =

 /*
  * Local function declarations.
@@ -780,6 +781,8 @@ xfs_dir2_leaf_getdents(
 	int			ra_offset;	/* map entry offset for ra */
 	int			ra_want;	/* readahead count wanted */
 	xfs_ino_t		ino;
+	char			*nls_name =3D NULL; /* NLS name buffer */
+	int			nls_namelen =3D 0;
 =

 	/*
 	 * If the offset is at or past the largest allowed value,
@@ -800,6 +803,9 @@ xfs_dir2_leaf_getdents(
 	map_valid =3D ra_index =3D ra_offset =3D ra_current =3D map_blocks =3D=
 0;
 	bp =3D NULL;
 =

+	if (mp->m_nls)
+		nls_name =3D xfs_alloc_unicode_nls_name();
+
 	/*
 	 * Inside the loop we keep the main offset value as a byte offset
 	 * in the directory file.
@@ -1086,13 +1092,21 @@ xfs_dir2_leaf_getdents(
 #if XFS_BIG_INUMS
 		ino +=3D mp->m_inoadd;
 #endif
+		if (mp->m_nls) {
+			error =3D xfs_unicode_to_nls(mp->m_nls, dep->name,
+					dep->namelen, &nls_name, &nls_namelen);
+			if (error)
+				break;
+		}
 =

 		/*
 		 * Won't fit.  Return to caller.
 		 */
-		if (filldir(dirent, dep->name, dep->namelen,
-			    xfs_dir2_byte_to_dataptr(mp, curoff),
-			    ino, DT_UNKNOWN))
+		if (filldir(dirent,
+				nls_namelen ? nls_name : (char *)dep->name,
+				nls_namelen ? nls_namelen : dep->namelen,
+				xfs_dir2_byte_to_dataptr(mp, curoff),
+				ino, DT_UNKNOWN))
 			break;
 =

 		/*
@@ -1113,6 +1127,8 @@ xfs_dir2_leaf_getdents(
 	kmem_free(map, map_size * sizeof(*map));
 	if (bp)
 		xfs_da_brelse(NULL, bp);
+	if (mp->m_nls)
+		xfs_free_unicode_nls_name(nls_name);
 	return error;
 }
 =

@@ -1300,10 +1316,18 @@ xfs_dir2_leaf_lookup(
 	/*
 	 * Return the found inode number.
 	 */
+	error =3D EEXIST;
 	args->inumber =3D be64_to_cpu(dep->inumber);
+	if (args->cmpresult =3D=3D XFS_CMP_CASE) {
+		error =3D xfs_unicode_to_nls(args->dp->i_mount->m_nls,
+				dep->name, dep->namelen,
+				(char **)&args->value, &args->valuelen);
+		if (!error)
+			error =3D EEXIST;
+	}
 	xfs_da_brelse(tp, dbp);
 	xfs_da_brelse(tp, lbp);
-	return XFS_ERROR(EEXIST);
+	return XFS_ERROR(error);
 }
 =

 /*
@@ -1331,6 +1355,7 @@ xfs_dir2_leaf_lookup_int(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_dir2_db_t		newdb;		/* new data block number */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	xfs_dacmp_t		cmp;		/* name compare result */
 =

 	dp =3D args->dp;
 	tp =3D args->trans;
@@ -1354,6 +1379,7 @@ xfs_dir2_leaf_lookup_int(
 	 * Loop over all the entries with the right hash value
 	 * looking to match the name.
 	 */
+	args->cmpresult =3D XFS_CMP_DIFFERENT;
 	for (lep =3D &leaf->ents[index], dbp =3D NULL, curdb =3D -1;
 	     index < be16_to_cpu(leaf->hdr.count) && be32_to_cpu(lep->hashval)=
 =3D=3D args->hashval;
 	     lep++, index++) {
@@ -1391,19 +1417,31 @@ xfs_dir2_leaf_lookup_int(
 		       xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
 		/*
 		 * If it matches then return it.
-		 */
-		if (dep->namelen =3D=3D args->namelen &&
-		    dep->name[0] =3D=3D args->name[0] &&
-		    memcmp(dep->name, args->name, args->namelen) =3D=3D 0) {
+		 *
+		 * lookup case - use nameops;
+		 *
+		 * replace/remove case - as lookup has been already been
+		 * performed, look for an exact match using the fast method
+		 */
+		cmp =3D args->oknoent ?
+			xfs_dir_compname(dp, dep->name, dep->namelen,
+						args->name, args->namelen) :
+			xfs_default_compname(dp, dep->name, dep->namelen,
+						args->name, args->namelen);
+		if (cmp !=3D XFS_CMP_DIFFERENT && cmp !=3D args->cmpresult) {
+			args->cmpresult =3D cmp;
 			*dbpp =3D dbp;
 			*indexp =3D index;
-			return 0;
+			if (cmp =3D=3D XFS_CMP_EXACT)
+				return 0;
 		}
 	}
+	ASSERT(args->oknoent);
+	if (args->cmpresult =3D=3D XFS_CMP_CASE)
+		return 0;
 	/*
 	 * No match found, return ENOENT.
 	 */
-	ASSERT(args->oknoent);
 	if (dbp)
 		xfs_da_brelse(tp, dbp);
 	xfs_da_brelse(tp, lbp);

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_dir2_node.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_dir2_node.c	2008-01-21 14:42:50.000000000 +1100
+++ b/fs/xfs/xfs_dir2_node.c	2008-01-21 14:35:07.954595095 +1100
@@ -39,6 +39,7 @@
 #include "xfs_dir2_node.h"
 #include "xfs_dir2_trace.h"
 #include "xfs_error.h"
+#include "xfs_unicode.h"
 =

 /*
  * Function declarations.
@@ -414,6 +415,7 @@ xfs_dir2_leafn_lookup_int(
 	xfs_dir2_db_t		newdb;		/* new data block number */
 	xfs_dir2_db_t		newfdb;		/* new free block number */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	xfs_dacmp_t		cmp;		/* comparison result */
 =

 	dp =3D args->dp;
 	tp =3D args->trans;
@@ -455,6 +457,7 @@ xfs_dir2_leafn_lookup_int(
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
+	args->cmpresult =3D XFS_CMP_DIFFERENT;
 	for (lep =3D &leaf->ents[index];
 	     index < be16_to_cpu(leaf->hdr.count) && be32_to_cpu(lep->hashval)=
 =3D=3D args->hashval;
 	     lep++, index++) {
@@ -572,28 +575,36 @@ xfs_dir2_leafn_lookup_int(
 			/*
 			 * Point to the data entry.
 			 */
-			dep =3D (xfs_dir2_data_entry_t *)
-			      ((char *)curbp->data +
-			       xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
+			dep =3D (xfs_dir2_data_entry_t *)((char *)curbp->data +
+				xfs_dir2_dataptr_to_off(mp,
+					be32_to_cpu(lep->address)));
 			/*
 			 * Compare the entry, return it if it matches.
 			 */
-			if (dep->namelen =3D=3D args->namelen &&
-			    dep->name[0] =3D=3D args->name[0] &&
-			    memcmp(dep->name, args->name, args->namelen) =3D=3D 0) {
+			cmp =3D args->oknoent ?
+				xfs_dir_compname(dp, dep->name, dep->namelen,
+						args->name, args->namelen):
+				xfs_default_compname(dp, dep->name,
+						dep->namelen, args->name,
+						args->namelen);
+			if (cmp !=3D XFS_CMP_DIFFERENT &&
+					cmp !=3D args->cmpresult) {
+				args->cmpresult =3D cmp;
 				args->inumber =3D be64_to_cpu(dep->inumber);
 				*indexp =3D index;
 				state->extravalid =3D 1;
 				state->extrablk.bp =3D curbp;
 				state->extrablk.blkno =3D curdb;
-				state->extrablk.index =3D
-					(int)((char *)dep -
-					      (char *)curbp->data);
+				state->extrablk.index =3D (int)((char *)dep -
+							(char *)curbp->data);
 				state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
-				return XFS_ERROR(EEXIST);
+				if (cmp =3D=3D XFS_CMP_EXACT)
+					return XFS_ERROR(EEXIST);
 			}
 		}
 	}
+	if (args->cmpresult =3D=3D XFS_CMP_CASE)
+		return XFS_ERROR(EEXIST);
 	/*
 	 * Didn't find a match.
 	 * If we are holding a buffer, give it back in case our caller
@@ -823,16 +834,17 @@ xfs_dir2_leafn_rebalance(
 	 */
 	if (!state->inleaf)
 		blk2->index =3D blk1->index - be16_to_cpu(leaf1->hdr.count);
-	=

-	/* =

-	 * Finally sanity check just to make sure we are not returning a negat=
ive index =

+
+	/*
+	 * Finally sanity check just to make sure we are not returning a
+	 * negative index
 	 */
 	if(blk2->index < 0) {
 		state->inleaf =3D 1;
 		blk2->index =3D 0;
 		cmn_err(CE_ALERT,
-			"xfs_dir2_leafn_rebalance: picked the wrong leaf? reverting original=
 leaf: "
-			"blk1->index %d\n",
+			"xfs_dir2_leafn_rebalance: picked the wrong leaf? "
+			"reverting original leaf: blk1->index %d\n",
 			blk1->index);
 	}
 }
@@ -1768,6 +1780,20 @@ xfs_dir2_node_lookup(
 	if (error)
 		rval =3D error;
 	/*
+	 * If case-insens match, copy name out
+	 */
+	if (args->cmpresult =3D=3D XFS_CMP_CASE) {
+		xfs_dir2_data_entry_t	*dep =3D
+				(xfs_dir2_data_entry_t *)
+					((char *)state->extrablk.bp->data +
+					state->extrablk.index);
+		error =3D xfs_unicode_to_nls(args->dp->i_mount->m_nls,
+				dep->name, dep->namelen,
+				(char **)&args->value, &args->valuelen);
+		if (error)
+			rval =3D error;
+	}
+	/*
 	 * Release the btree blocks and leaf block.
 	 */
 	for (i =3D 0; i < state->path.active; i++) {

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_dir2_sf.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_dir2_sf.c	2008-01-21 14:42:51.000000000 +1100
+++ b/fs/xfs/xfs_dir2_sf.c	2008-01-21 14:21:42.201792024 +1100
@@ -38,6 +38,7 @@
 #include "xfs_dir2_leaf.h"
 #include "xfs_dir2_block.h"
 #include "xfs_dir2_trace.h"
+#include "xfs_unicode.h"
 =

 /*
  * Prototypes for internal functions.
@@ -701,6 +702,7 @@ xfs_dir2_sf_getdents(
 	filldir_t		filldir)
 {
 	int			i;		/* shortform entry number */
+	int			error =3D 0;
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_dir2_dataptr_t	off;		/* current entry's offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
@@ -708,6 +710,8 @@ xfs_dir2_sf_getdents(
 	xfs_dir2_dataptr_t	dot_offset;
 	xfs_dir2_dataptr_t	dotdot_offset;
 	xfs_ino_t		ino;
+	char			*nls_name =3D NULL; /* NLS name buffer */
+	int			nls_namelen =3D 0;
 =

 	mp =3D dp->i_mount;
 =

@@ -772,6 +776,9 @@ xfs_dir2_sf_getdents(
 		}
 	}
 =

+	if (mp->m_nls)
+		nls_name =3D xfs_alloc_unicode_nls_name();
+
 	/*
 	 * Loop while there are more entries and put'ing works.
 	 */
@@ -789,17 +796,26 @@ xfs_dir2_sf_getdents(
 #if XFS_BIG_INUMS
 		ino +=3D mp->m_inoadd;
 #endif
-
-		if (filldir(dirent, sfep->name, sfep->namelen,
-					    off, ino, DT_UNKNOWN)) {
+		if (mp->m_nls) {
+			error =3D xfs_unicode_to_nls(mp->m_nls, sfep->name,
+					sfep->namelen, &nls_name, &nls_namelen);
+			if (error)
+				goto out;
+		}
+		if (filldir(dirent,
+				nls_namelen ? nls_name : (char *)sfep->name,
+				nls_namelen ? nls_namelen : sfep->namelen,
+				off, ino, DT_UNKNOWN)) {
 			*offset =3D off;
-			return 0;
+			goto out;
 		}
 		sfep =3D xfs_dir2_sf_nextentry(sfp, sfep);
 	}
-
 	*offset =3D xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
-	return 0;
+out:
+	if (mp->m_nls)
+		xfs_free_unicode_nls_name(nls_name);
+	return error;
 }
 =

 /*
@@ -812,6 +828,7 @@ xfs_dir2_sf_lookup(
 {
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			i;		/* entry index */
+	int			error;
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 =

@@ -836,6 +853,7 @@ xfs_dir2_sf_lookup(
 	 */
 	if (args->namelen =3D=3D 1 && args->name[0] =3D=3D '.') {
 		args->inumber =3D dp->i_ino;
+		args->cmpresult =3D XFS_CMP_EXACT;
 		return XFS_ERROR(EEXIST);
 	}
 	/*
@@ -844,23 +862,44 @@ xfs_dir2_sf_lookup(
 	if (args->namelen =3D=3D 2 &&
 	    args->name[0] =3D=3D '.' && args->name[1] =3D=3D '.') {
 		args->inumber =3D xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
+		args->cmpresult =3D XFS_CMP_EXACT;
 		return XFS_ERROR(EEXIST);
 	}
 	/*
 	 * Loop over all the entries trying to match ours.
 	 */
-	for (i =3D 0, sfep =3D xfs_dir2_sf_firstentry(sfp);
-	     i < sfp->hdr.count;
-	     i++, sfep =3D xfs_dir2_sf_nextentry(sfp, sfep)) {
-		if (sfep->namelen =3D=3D args->namelen &&
-		    sfep->name[0] =3D=3D args->name[0] &&
-		    memcmp(args->name, sfep->name, args->namelen) =3D=3D 0) {
-			args->inumber =3D
-				xfs_dir2_sf_get_inumber(sfp,
-					xfs_dir2_sf_inumberp(sfep));
+	args->cmpresult =3D XFS_CMP_DIFFERENT;
+	for (i =3D 0, sfep =3D xfs_dir2_sf_firstentry(sfp); i < sfp->hdr.count=
;
+			i++, sfep =3D xfs_dir2_sf_nextentry(sfp, sfep)) {
+		switch (xfs_dir_compname(dp, sfep->name, sfep->namelen,
+				args->name, args->namelen)) {
+		case XFS_CMP_EXACT:
+			args->cmpresult =3D XFS_CMP_EXACT;
+			args->inumber =3D xfs_dir2_sf_get_inumber(sfp,
+						xfs_dir2_sf_inumberp(sfep));
+			if (args->value) {
+				xfs_free_unicode_nls_name(args->value);
+				args->value =3D NULL;
+			}
 			return XFS_ERROR(EEXIST);
+
+		case XFS_CMP_CASE:
+			if (!args->value) {
+				error =3D xfs_unicode_to_nls(
+					args->dp->i_mount->m_nls, sfep->name,
+					sfep->namelen, (char **)&args->value,
+					&args->valuelen);
+				if (error)
+					return XFS_ERROR(error);
+				args->cmpresult =3D XFS_CMP_CASE;
+				args->inumber =3D xfs_dir2_sf_get_inumber(sfp,
+						xfs_dir2_sf_inumberp(sfep));
+			}
+		default: ;
 		}
 	}
+	if (args->cmpresult =3D=3D XFS_CMP_CASE)
+		return XFS_ERROR(EEXIST);
 	/*
 	 * Didn't find it.
 	 */
@@ -907,9 +946,8 @@ xfs_dir2_sf_removename(
 	for (i =3D 0, sfep =3D xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->hdr.count;
 	     i++, sfep =3D xfs_dir2_sf_nextentry(sfp, sfep)) {
-		if (sfep->namelen =3D=3D args->namelen &&
-		    sfep->name[0] =3D=3D args->name[0] &&
-		    memcmp(sfep->name, args->name, args->namelen) =3D=3D 0) {
+		if (xfs_default_compname(dp, sfep->name, sfep->namelen,
+				args->name, args->namelen) =3D=3D XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_inumber(sfp,
 					xfs_dir2_sf_inumberp(sfep)) =3D=3D
 				args->inumber);
@@ -1044,9 +1082,9 @@ xfs_dir2_sf_replace(
 		for (i =3D 0, sfep =3D xfs_dir2_sf_firstentry(sfp);
 		     i < sfp->hdr.count;
 		     i++, sfep =3D xfs_dir2_sf_nextentry(sfp, sfep)) {
-			if (sfep->namelen =3D=3D args->namelen &&
-			    sfep->name[0] =3D=3D args->name[0] &&
-			    memcmp(args->name, sfep->name, args->namelen) =3D=3D 0) {
+			if (xfs_default_compname(dp, sfep->name,
+					sfep->namelen, args->name,
+					args->namelen) =3D=3D XFS_CMP_EXACT) {
 #if XFS_BIG_INUMS || defined(DEBUG)
 				ino =3D xfs_dir2_sf_get_inumber(sfp,
 					xfs_dir2_sf_inumberp(sfep));

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_itable.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_itable.c	2008-01-21 14:42:51.000000000 +1100
+++ b/fs/xfs/xfs_itable.c	2008-01-18 13:45:10.740061749 +1100
@@ -45,6 +45,8 @@ xfs_internal_inum(
 	xfs_ino_t	ino)
 {
 	return (ino =3D=3D mp->m_sb.sb_rbmino || ino =3D=3D mp->m_sb.sb_rsumin=
o ||
+		(xfs_sb_version_hasunicode(&mp->m_sb) &&
+		 ino =3D=3D mp->m_sb.sb_cftino) ||
 		(XFS_SB_VERSION_HASQUOTA(&mp->m_sb) &&
 		 (ino =3D=3D mp->m_sb.sb_uquotino || ino =3D=3D mp->m_sb.sb_gquotino)=
));
 }

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_mount.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_mount.c	2008-01-21 14:42:51.000000000 +1100
+++ b/fs/xfs/xfs_mount.c	2008-01-21 14:27:33.000000000 +1100
@@ -25,6 +25,7 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
+#include "xfs_attr.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
@@ -43,6 +44,9 @@
 #include "xfs_rw.h"
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_unicode.h"
 =

 STATIC void	xfs_mount_log_sbunit(xfs_mount_t *, __int64_t);
 STATIC int	xfs_uuid_mount(xfs_mount_t *);
@@ -119,6 +123,8 @@ static const struct {
     { offsetof(xfs_sb_t, sb_logsectsize),0 },
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
+    { offsetof(xfs_sb_t, sb_bad_features2), 0 },
+    { offsetof(xfs_sb_t, sb_cftino),	 0 },
     { sizeof(xfs_sb_t),			 0 }
 };
 =

@@ -165,6 +171,9 @@ xfs_mount_free(
 			  sizeof(xfs_perag_t) * mp->m_sb.sb_agcount);
 	}
 =

+	if (mp->m_cft)
+		xfs_unicode_free_cft(mp->m_cft);
+
 	spinlock_destroy(&mp->m_ail_lock);
 	spinlock_destroy(&mp->m_sb_lock);
 	mutex_destroy(&mp->m_ilock);
@@ -449,6 +458,8 @@ xfs_sb_from_disk(
 	to->sb_logsectsize =3D be16_to_cpu(from->sb_logsectsize);
 	to->sb_logsunit =3D be32_to_cpu(from->sb_logsunit);
 	to->sb_features2 =3D be32_to_cpu(from->sb_features2);
+	to->sb_bad_features2 =3D be32_to_cpu(from->sb_bad_features2);
+	to->sb_cftino =3D be64_to_cpu(from->sb_cftino);
 }
 =

 /*
@@ -1056,7 +1067,7 @@ xfs_mountfs(
 	/*
 	 * Initialize the attribute manager's entries.
 	 */
-	mp->m_attr_magicpct =3D (mp->m_sb.sb_blocksize * 37) / 100;
+	xfs_attr_mount(mp);
 =

 	/*
 	 * Initialize the precomputed transaction reservations values.
@@ -1159,6 +1170,18 @@ xfs_mountfs(
 	}
 =

 	/*
+	 * Load in unicode case folding table from disk
+	 */
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		error =3D xfs_unicode_read_cft(mp);
+		if (error) {
+			cmn_err(CE_WARN,
+				"XFS: failed to read case folding table");
+			goto error4;
+		}
+	}
+
+	/*
 	 * If fs is not mounted readonly, then update the superblock
 	 * unit and width changes.
 	 */
@@ -1214,6 +1237,8 @@ xfs_mountfs(
 	 * Free up the root inode.
 	 */
 	VN_RELE(rvp);
+	if (mp->m_cft)
+		xfs_unicode_free_cft(mp->m_cft);
  error3:
 	xfs_log_unmount_dealloc(mp);
  error2:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_mount.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_mount.h	2008-01-21 14:42:51.000000000 +1100
+++ b/fs/xfs/xfs_mount.h	2008-01-21 14:27:33.000000000 +1100
@@ -54,6 +54,7 @@ typedef struct xfs_trans_reservations {
 #else
 struct cred;
 struct log;
+struct nls_table;
 struct xfs_mount_args;
 struct xfs_inode;
 struct xfs_bmbt_irec;
@@ -61,6 +62,8 @@ struct xfs_bmap_free;
 struct xfs_extdelta;
 struct xfs_swapext;
 struct xfs_mru_cache;
+struct xfs_nameops;
+struct xfs_cft;
 =

 /*
  * Prototypes and functions for the Data Migration subsystem.
@@ -312,6 +315,10 @@ typedef struct xfs_mount {
 	__uint8_t		m_inode_quiesce;/* call quiesce on new inodes.
 						   field governed by m_ilock */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
+	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
+	const struct xfs_nameops *m_attrnameops; /* vector of attr name ops */=

+	const struct xfs_cft	*m_cft;		/* unicode case fold table */
+	struct nls_table 	*m_nls;		/* active NLS table */
 	int			m_dirblksize;	/* directory block sz--bytes */
 	int			m_dirblkfsbs;	/* directory block sz--fsbs */
 	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */
@@ -377,7 +384,10 @@ typedef struct xfs_mount {
 						   counters */
 #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
 						   allocator */
-
+#define XFS_MOUNT_CI_LOOKUP	(1ULL << 25)	/* enable case-insensitive
+						 * file lookup */
+#define XFS_MOUNT_CI_ATTR	(1ULL << 26)	/* enable case-insensitive
+						   attribute names */
 =

 /*
  * Default minimum read and write sizes.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_rename.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_rename.c	2008-01-21 14:42:51.000000000 +1100
+++ b/fs/xfs/xfs_rename.c	2008-01-17 12:25:31.652529581 +1100
@@ -130,7 +130,9 @@ xfs_lock_for_rename(
 		lock_mode =3D xfs_ilock_map_shared(dp2);
 	}
 =

-	error =3D xfs_dir_lookup_int(dp2, lock_mode, vname2, &inum2, &ip2);
+	error =3D xfs_dir_lookup_int(dp2, lock_mode, vname2, &inum2, &ip2,
+			NULL, NULL);
+
 	if (error =3D=3D ENOENT) {		/* target does not need to exist. */
 		inum2 =3D 0;
 	} else if (error) {
@@ -214,6 +216,7 @@ xfs_lock_for_rename(
 	for (;i < 4; i++) {
 		i_tab[i] =3D NULL;
 	}
+
 	return 0;
 }
 =


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_sb.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_sb.h	2008-01-21 14:42:51.000000000 +1100
+++ b/fs/xfs/xfs_sb.h	2008-01-21 14:41:29.721741469 +1100
@@ -46,10 +46,12 @@ struct xfs_mount;
 #define XFS_SB_VERSION_SECTORBIT	0x0800
 #define	XFS_SB_VERSION_EXTFLGBIT	0x1000
 #define	XFS_SB_VERSION_DIRV2BIT		0x2000
+#define XFS_SB_VERSION_OLDCIBIT		0x4000	/* ASCII only case-insens. */
 #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
 #define	XFS_SB_VERSION_OKSASHFBITS	\
 	(XFS_SB_VERSION_EXTFLGBIT | \
-	 XFS_SB_VERSION_DIRV2BIT)
+	 XFS_SB_VERSION_DIRV2BIT | \
+	 XFS_SB_VERSION_OLDCIBIT)
 #define	XFS_SB_VERSION_OKREALFBITS	\
 	(XFS_SB_VERSION_ATTRBIT | \
 	 XFS_SB_VERSION_NLINKBIT | \
@@ -77,10 +79,12 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters =
*/
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
+#define XFS_SB_VERSION2_UNICODEBIT	0x00000020	/* Unicode names */
 =

 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
-	 XFS_SB_VERSION2_ATTR2BIT)
+	 XFS_SB_VERSION2_ATTR2BIT | \
+	 XFS_SB_VERSION2_UNICODEBIT)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -145,6 +149,9 @@ typedef struct xfs_sb {
 	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
 	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
 	__uint32_t	sb_features2;	/* additional feature bits */
+	__uint32_t	sb_bad_features2; /* bad mkfs set features2 here */
+	xfs_ino_t	sb_cftino;	/* unicode case folding table inode */
+	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 =

 /*
@@ -205,6 +212,9 @@ typedef struct xfs_dsb {
 	__be16		sb_logsectsize;	/* sector size for the log, bytes */
 	__be32		sb_logsunit;	/* stripe unit size for the log */
 	__be32		sb_features2;	/* additional feature bits */
+	__be32		sb_bad_features2; /* bad mkfs set features2 here */
+	__be64		sb_cftino;	/* unicode case folding table inode */
+	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
 =

 /*
@@ -223,7 +233,7 @@ typedef enum {
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_CFTINO,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 =

@@ -248,13 +258,15 @@ typedef enum {
 #define XFS_SB_IFREE		XFS_SB_MVAL(IFREE)
 #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
+#define XFS_SB_CASEFOLDINO	XFS_SB_MVAL(CASEFOLDINO)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
 #define	XFS_SB_MOD_BITS		\
 	(XFS_SB_UUID | XFS_SB_ROOTINO | XFS_SB_RBMINO | XFS_SB_RSUMINO | \
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
-	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2)
+	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \=

+	 XFS_SB_CFTINO)
 =

 =

 /*
@@ -463,6 +475,12 @@ static inline int xfs_sb_version_hassect
 		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
 =

+static inline int xfs_sb_version_hasoldci(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) =3D=3D XFS_SB_VERSION_4) && \
+		((sbp)->sb_versionnum & XFS_SB_VERSION_OLDCIBIT);
+}
+
 #define XFS_SB_VERSION_HASMOREBITS(sbp)	xfs_sb_version_hasmorebits(sbp)=

 static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 {
@@ -502,6 +520,13 @@ static inline void xfs_sb_version_addatt
 		((sbp)->sb_features2 | XFS_SB_VERSION2_ATTR2BIT)));
 }
 =

+static inline int xfs_sb_version_hasunicode(xfs_sb_t *sbp)
+{
+	return (xfs_sb_version_hasmorebits(sbp) &&	\
+		((sbp)->sb_features2 & XFS_SB_VERSION2_UNICODEBIT));
+}
+
+
 /*
  * end of superblock version macros
  */

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_unicode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_unicode.c	2006-06-17 00:58:24.000000000 +1000
+++ b/fs/xfs/xfs_unicode.c	2008-01-21 14:10:29.048257871 +1100
@@ -0,0 +1,530 @@
+/*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,=

+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_clnt.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_alloc.h"
+#include "xfs_dmapi.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_dir2_sf.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_itable.h"
+#include "xfs_rtalloc.h"
+#include "xfs_error.h"
+#include "xfs_bmap.h"
+#include "xfs_rw.h"
+#include "xfs_unicode.h"
+
+#define MAX_FOLD_CHARS	4
+
+static kmem_zone_t	*xfs_nls_uni_zone;
+
+static inline int
+xfs_casefold(
+	const xfs_cft_t *cft,
+	__uint16_t	c,
+	__uint16_t	*fc)
+{
+	__uint16_t	*table =3D XFS_CFT_PTR(cft, 0);
+	__uint16_t	tmp =3D table[c >> 8];
+	int		i;
+
+	if (!tmp) {
+		*fc =3D c;
+		return 1;
+	}
+	tmp =3D table[tmp + (c & 0xff)];
+	if ((tmp & 0xf000) !=3D 0xe000) {
+		*fc =3D tmp;
+		return 1;
+	}
+	i =3D ((tmp >> 10) & 0x3) + 2;
+	ASSERT(i < cft->num_tables);
+	table =3D XFS_CFT_PTR(cft, i - 1) + ((tmp & 0x3ff) * i);
+
+	memcpy(fc, table, sizeof(__uint16_t) * i);
+
+	return i;
+}
+
+static inline int
+xfs_utf8_casefold(
+	const xfs_cft_t	*cft,
+	const uchar_t	**name,
+	int		*namelen,
+	__uint16_t	*fc)
+{
+	wchar_t		uc;
+
+	if (*namelen =3D=3D 0)
+		return 0;
+
+	if (**name & 0x80) {
+		int	n =3D utf8_mbtowc(&uc, *name, *namelen);
+		if (n < 0) {
+			(*namelen)--;
+			*fc =3D *(*name)++;
+			return 1;
+		}
+		*name +=3D n;
+		*namelen -=3D n;
+	} else {
+		uc =3D *(*name)++;
+		(*namelen)--;
+	}
+	return xfs_casefold(cft, uc, fc);
+}
+
+__uint32_t
+xfs_unicode_hash(
+	const xfs_cft_t	*cft,
+	const uchar_t	*name,
+	int		namelen)
+{
+	__uint32_t	hash =3D 0;
+	__uint16_t	fc[MAX_FOLD_CHARS];
+	int		nfc;
+	int		i;
+
+	while (namelen > 0) {
+		nfc =3D xfs_utf8_casefold(cft, &name, &namelen, fc);
+		for (i =3D 0; i < nfc; i++)
+			hash =3D fc[i] ^ rol32(hash, 7);
+	}
+	return hash;
+}
+
+int
+xfs_unicode_casecmp(
+	const xfs_cft_t	*cft,
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
+	int		len2)
+{
+	__uint16_t	fc1[MAX_FOLD_CHARS], fc2[MAX_FOLD_CHARS];
+	__uint16_t	*pfc1, *pfc2;
+	int		nfc1, nfc2;
+
+	nfc1 =3D xfs_utf8_casefold(cft, &name1, &len1, fc1);
+	pfc1 =3D fc1;
+	nfc2 =3D xfs_utf8_casefold(cft, &name2, &len2, fc2);
+	pfc2 =3D fc2;
+
+	while (nfc1 > 0 && nfc2 > 0) {
+		if (*pfc1 !=3D *pfc2)
+			return (*pfc1 < *pfc2) ? -1 : 1;
+		if (!--nfc1) {
+			nfc1 =3D xfs_utf8_casefold(cft, &name1, &len1, fc1);
+			pfc1 =3D fc1;
+		} else
+			pfc1++;
+		if (!--nfc2) {
+			nfc2 =3D xfs_utf8_casefold(cft, &name2, &len2, fc2);
+			pfc2 =3D fc2;
+		} else
+			pfc2++;
+	}
+	if (nfc1 !=3D nfc2)
+		return (nfc1 < nfc2) ? -1 : 1;
+	return 0;
+}
+
+
+char *
+xfs_alloc_unicode_nls_name(void)
+{
+	return kmem_zone_alloc(xfs_nls_uni_zone, KM_SLEEP);
+}
+
+
+void
+xfs_free_unicode_nls_name(
+	char		*name)
+{
+	kmem_zone_free(xfs_nls_uni_zone, name);
+}
+
+int
+xfs_nls_to_unicode(
+	struct nls_table *nls,
+	const char	*nls_name,
+	int		nls_namelen,
+	char		**uni_name,
+	int		*uni_namelen)
+{
+	char		*n;
+	int		i, o;
+	wchar_t		uc;
+	int		nlen;
+	int		u8len;
+	int		error =3D 0;
+
+	n =3D *uni_name ? *uni_name : xfs_alloc_unicode_nls_name();
+
+	if (!nls) {
+		if (nls_namelen > MAXNAMELEN) {
+			error =3D ENAMETOOLONG;
+			goto err_out;
+		}
+		memcpy(n, nls_name, nls_namelen);
+		*uni_name =3D n;
+		*uni_namelen =3D nls_namelen;
+		return 0;
+	}
+
+	for (i =3D 0, o =3D 0; i < nls_namelen; i +=3D nlen, o +=3D u8len) {
+		nlen =3D nls->char2uni(nls_name + i, nls_namelen - i, &uc);
+		if (nlen < 0) {
+			error =3D -nlen;
+			goto err_out;
+		}
+		if (uc >=3D 0xfffe || (uc >=3D 0xd800 && uc <=3D 0xdfff)) {
+			error =3D EINVAL;	/* don't support chars outside BMP */
+			goto err_out;
+		}
+		u8len =3D utf8_wctomb(n + o, uc, MAXNAMELEN - o);
+		if (u8len <=3D 0) {
+			error =3D (MAXNAMELEN - o < 3) ? ENAMETOOLONG : EINVAL;
+			goto err_out;
+		}
+	}
+	*uni_name =3D n;
+	*uni_namelen =3D o;
+	return 0;
+err_out:
+	if (*uni_name =3D=3D NULL)
+		xfs_free_unicode_nls_name(n);
+	return error;
+}
+
+int
+xfs_unicode_to_nls(
+	struct nls_table *nls,
+	const char	*uni_name,
+	int		uni_namelen,
+	char		**nls_name,
+	int		*nls_namelen)
+{
+	char		*n;
+	int		i, o;
+	wchar_t		uc;
+	int		nlen;
+	int		u8len;
+	int		error =3D 0;
+
+	n =3D *nls_name ? *nls_name : xfs_alloc_unicode_nls_name();
+
+	if (!nls) {
+		if (uni_namelen > MAXNAMELEN) {
+			error =3D ENAMETOOLONG;
+			goto err_out;
+		}
+		memcpy(n, uni_name, uni_namelen);
+		*nls_name =3D n;
+		*nls_namelen =3D uni_namelen;
+		return 0;
+	}
+
+	for (i =3D 0, o =3D 0; i < uni_namelen && o < MAXNAMELEN;
+			i +=3D u8len, o +=3D nlen) {
+		u8len =3D utf8_mbtowc(&uc, uni_name + i, uni_namelen - i);
+		if (u8len < 0) {
+			error =3D EINVAL;
+			goto err_out;
+		}
+		nlen =3D nls->uni2char(uc, n + o, MAXNAMELEN - o);
+		if (nlen =3D=3D -EINVAL) {
+			n[o] =3D '?';
+			nlen =3D 1;
+		} else if (nlen < 0) {
+			error =3D -nlen;
+			goto err_out;
+		}
+	}
+	if (i =3D=3D uni_namelen) {
+		*nls_name =3D n;
+		*nls_namelen =3D o;
+		return 0;
+	}
+
+	error =3D ENAMETOOLONG;
+err_out:
+	if (*nls_name =3D=3D NULL)
+		xfs_free_unicode_nls_name(n);
+	return error;
+}
+
+int
+xfs_unicode_validate(
+	const uchar_t	*name,
+	int		namelen)
+{
+	wchar_t		uc;
+	int		i, nlen;
+
+	for (i =3D 0; i < namelen; i +=3D nlen) {
+		if (*name >=3D 0xf0) {
+			cmn_err(CE_WARN, "xfs_unicode_validate: "
+					"UTF-8 char beyond U+FFFF\n");
+			return EINVAL;
+		}
+		/* utf8_mbtowc must fail on overlong sequences too */
+		nlen =3D utf8_mbtowc(&uc, name + i, namelen - i);
+		if (nlen < 0) {
+			cmn_err(CE_WARN, "xfs_unicode_validate: "
+					"invalid UTF-8 sequence\n");
+			return EILSEQ;
+		}
+		/* check for invalid/surrogate/private unicode chars */
+		if (uc >=3D 0xfffe || (uc >=3D 0xd800 && uc <=3D 0xf8ff)) {
+			cmn_err(CE_WARN, "xfs_unicode_validate: "
+					"unsupported UTF-8 char\n");
+			return EINVAL;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Unicode Case Fold Table management
+ */
+
+struct cft_item {
+	xfs_cft_t	*table;
+	int		size;
+	int		refcount;
+};
+
+static mutex_t		cft_lock;
+static int		cft_size;
+static struct cft_item	*cft_list;
+
+static xfs_cft_t *
+add_cft(
+	xfs_dcft_t	*dcft,
+	int		size)
+{
+	int		found =3D 0;
+	int		i, j;
+	xfs_cft_t	*cft;
+	__be16		*duc;
+	__uint16_t	*uc;
+
+	mutex_lock(&cft_lock);
+
+	for (i =3D 0; i < cft_size; i++) {
+		if (cft_list[i].size !=3D size)
+			continue;
+		cft =3D cft_list[i].table;
+		if (cft->num_tables !=3D be32_to_cpu(dcft->num_tables) ||
+				cft->flags !=3D be32_to_cpu(dcft->flags))
+			continue;
+		found =3D 1;
+		for (j =3D 0; j < cft->num_tables; j++) {
+			if (cft->table_offset[j] !=3D
+					be32_to_cpu(dcft->table_offset[j])) {
+				found =3D 0;
+				break;
+			}
+		}
+		if (found) {
+			cft_list[i].refcount++;
+			mutex_unlock(&cft_lock);
+			return cft;
+		}
+	}
+
+	cft =3D vmalloc(size);
+	if (!cft) {
+		mutex_unlock(&cft_lock);
+		return NULL;
+	}
+	cft->magic =3D be32_to_cpu(dcft->magic);
+	cft->flags =3D be32_to_cpu(dcft->flags);
+	cft->num_tables =3D be32_to_cpu(dcft->num_tables);
+	ASSERT(cft->num_tables <=3D MAX_FOLD_CHARS);
+	for (i =3D 0; i < cft->num_tables; i++)
+		cft->table_offset[i] =3D be32_to_cpu(dcft->table_offset[i]);
+	j =3D (size - cft->table_offset[0]) / sizeof(__uint16_t);
+	uc =3D XFS_CFT_PTR(cft, 0);
+	duc =3D XFS_DCFT_PTR(dcft, 0);
+	for (i =3D 0; i < j; i++)
+		uc[i] =3D be16_to_cpu(duc[i]);
+
+	cft_list =3D kmem_realloc(cft_list,
+			(cft_size + 1) * sizeof(struct cft_item),
+			cft_size  * sizeof(struct cft_item), KM_SLEEP);
+	cft_list[cft_size].table =3D cft;
+	cft_list[cft_size].size =3D size;
+	cft_list[cft_size].refcount =3D 1;
+	cft_size++;
+
+	mutex_unlock(&cft_lock);
+
+	return cft;
+}
+
+static void
+remove_cft(
+	const xfs_cft_t	*cft)
+{
+	int		i;
+
+	mutex_lock(&cft_lock);
+
+	for (i =3D 0; i < cft_size; i++) {
+		if (cft_list[i].table =3D=3D cft) {
+			ASSERT(cft_list[i].refcount > 0);
+			cft_list[i].refcount--;
+			break;
+		}
+	}
+
+	mutex_unlock(&cft_lock);
+}
+
+
+int
+xfs_unicode_read_cft(
+	xfs_mount_t	*mp)
+{
+	int		error;
+	xfs_inode_t	*cftip;
+	int		size;
+	int		nfsb;
+	int             nmap;
+	xfs_bmbt_irec_t *mapp;
+	int		n;
+	int		byte_cnt;
+	xfs_buf_t	*bp;
+	char		*table;
+	xfs_dcft_t	*dcft;
+
+	if (mp->m_sb.sb_cftino =3D=3D NULLFSINO || mp->m_sb.sb_cftino =3D=3D 0=
)
+		return EINVAL;
+	error =3D xfs_iget(mp, NULL, mp->m_sb.sb_cftino, 0, 0, &cftip, 0);
+	if (error)
+		return error;
+	ASSERT(cftip !=3D NULL);
+
+	size =3D cftip->i_d.di_size;
+	nfsb =3D cftip->i_d.di_nblocks;
+
+	table =3D vmalloc(size);
+	if (!table) {
+		xfs_iput(cftip, 0);
+		return ENOMEM;
+	}
+	dcft =3D (xfs_dcft_t *)table;
+
+	nmap =3D nfsb;
+	mapp =3D kmem_alloc(nfsb * sizeof(xfs_bmbt_irec_t), KM_SLEEP);
+
+	error =3D xfs_bmapi(NULL, cftip, 0, nfsb, 0, NULL, 0, mapp, &nmap,
+			NULL, NULL);
+	if (error)
+		goto out;
+
+	for (n =3D 0; n < nmap; n++) {
+		byte_cnt =3D XFS_FSB_TO_B(mp, mapp[n].br_blockcount);
+
+		error =3D xfs_read_buf(mp, mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp, mapp[n].br_startblock),
+				BTOBB(byte_cnt), 0, &bp);
+		if (error)
+			goto out;
+
+		if (size < byte_cnt)
+			byte_cnt =3D size;
+		size -=3D byte_cnt;
+		memcpy(table, XFS_BUF_PTR(bp), byte_cnt);
+		table +=3D byte_cnt;
+		xfs_buf_relse(bp);
+	}
+
+	/* verify case table read off disk */
+	if (!uuid_equal(&dcft->uuid, &mp->m_sb.sb_uuid)) {
+		error =3D EINVAL;
+		goto out;
+	}
+
+	/* clear UUID for in-memory copy/compare */
+	memset(&dcft->uuid, 0, sizeof(dcft->uuid));
+
+	mp->m_cft =3D add_cft(dcft, cftip->i_d.di_size);
+	if (mp->m_cft =3D=3D NULL)
+		error =3D ENOMEM;
+
+out:
+	xfs_iput(cftip, 0);
+	kmem_free(mapp, nfsb * sizeof(xfs_bmbt_irec_t));
+	vfree(dcft);
+
+	return error;
+}
+
+void
+xfs_unicode_free_cft(
+	const xfs_cft_t	*cft)
+{
+	remove_cft(cft);
+}
+
+void
+xfs_unicode_init(void)
+{
+	mutex_init(&cft_lock);
+	xfs_nls_uni_zone =3D kmem_zone_init(MAXNAMELEN, "xfs_nls_uni");
+}
+
+void
+xfs_unicode_uninit(void)
+{
+	int		i;
+
+	mutex_lock(&cft_lock);
+
+	for (i =3D 0; i < cft_size; i++) {
+		ASSERT(cft_list[i].refcount =3D=3D 0);
+		vfree(cft_list[i].table);
+	}
+	kmem_free(cft_list, cft_size * sizeof(struct cft_item));
+	cft_size =3D 0;
+	cft_list =3D NULL;
+
+	mutex_unlock(&cft_lock);
+	mutex_destroy(&cft_lock);
+
+	kmem_zone_destroy(xfs_nls_uni_zone);
+}

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_unicode.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_unicode.h	2006-06-17 00:58:24.000000000 +1000
+++ b/fs/xfs/xfs_unicode.h	2008-01-21 14:23:07.266899447 +1100
@@ -0,0 +1,76 @@
+/*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,=

+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_UNICODE_H__
+#define	__XFS_UNICODE_H__
+
+#define	XFS_CFT_MAGIC		0x58434654	/* 'XCFT' */
+#define XFS_CFT_FLAG_TURKIC	0x00000001
+#define XFS_CFT_FLAG_MAX	0x00000001
+
+/*
+ * Case Fold Table - on disk version. Must match the incore version bel=
ow.
+ */
+typedef struct xfs_dcft {
+	__be32			magic;		/* validity check */
+	__be32			flags;
+	uuid_t			uuid;		/* UUID of the filesystem */
+	__be32			crc;		/* for future support */
+	__be32			num_tables;	/* single, double, etc */
+	__be32			table_offset[1];
+} xfs_dcft_t;
+
+/*
+ * Case Fold Table - in core version. Must match the ondisk version abo=
ve.
+ */
+typedef struct xfs_cft {
+	__uint32_t		magic;
+	__uint32_t		flags;
+	uuid_t			uuid;		/* UUID of the filesystem */
+	__uint32_t		crc;
+	__uint32_t		num_tables;	/* single, double, etc */
+	__uint32_t		table_offset[1];/* num_tables sized */
+	/* 16-bit array tables immediately follow */
+} xfs_cft_t;
+
+#define XFS_CFT_PTR(t,n)	(__uint16_t *)(((char *)(t)) + \
+					(t)->table_offset[n])
+#define XFS_DCFT_PTR(t,n)	(__be16 *)(((char *)(t)) + \
+					be32_to_cpu((t)->table_offset[n]))
+
+void xfs_unicode_init(void);
+void xfs_unicode_uninit(void);
+
+__uint32_t xfs_unicode_hash(const xfs_cft_t *cft,
+				const uchar_t *name, int namelen);
+
+int xfs_unicode_casecmp(const xfs_cft_t *cft, const uchar_t *name1,
+				int len1, const uchar_t *name2, int len2);
+
+char *xfs_alloc_unicode_nls_name(void);
+void xfs_free_unicode_nls_name(char *name);
+int xfs_nls_to_unicode(struct nls_table *nls, const char *nls_name,
+			int nls_namelen, char **uni_name, int *uni_namelen);
+int xfs_unicode_to_nls(struct nls_table *nls, const char *uni_name,
+			int uni_namelen, char **nls_name, int *nls_namelen);
+
+int xfs_unicode_validate(const uchar_t *name, int namelen);
+
+int xfs_unicode_read_cft(struct xfs_mount *mp);
+void xfs_unicode_free_cft(const xfs_cft_t *cft);
+
+#endif /* __XFS_UNICODE_H__ */

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_utils.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_utils.c	2008-01-21 14:42:51.000000000 +1100
+++ b/fs/xfs/xfs_utils.c	2007-10-26 15:42:04.856766756 +1000
@@ -39,6 +39,7 @@
 #include "xfs_rw.h"
 #include "xfs_itable.h"
 #include "xfs_utils.h"
+#include "xfs_unicode.h"
 =

 /*
  * xfs_get_dir_entry is used to get a reference to an inode given
@@ -69,13 +70,16 @@ xfs_dir_lookup_int(
 	uint		lock_mode,
 	bhv_vname_t	*dentry,
 	xfs_ino_t	*inum,
-	xfs_inode_t	**ipp)
+	xfs_inode_t	**ipp,
+	char		**actual_name,
+	int		*actual_namelen)
 {
 	int		error;
 =

 	xfs_itrace_entry(dp);
 =

-	error =3D xfs_dir_lookup(NULL, dp, VNAME(dentry), VNAMELEN(dentry), in=
um);
+	error =3D xfs_dir_lookup(NULL, dp, VNAME(dentry), VNAMELEN(dentry), in=
um,
+			actual_name, actual_namelen);
 	if (!error) {
 		/*
 		 * Unlock the directory. We do this because we can't
@@ -102,6 +106,8 @@ xfs_dir_lookup_int(
 			xfs_ilock(dp, lock_mode);
 			error =3D XFS_ERROR(ENOENT);
 		}
+		if (error && actual_name)
+			xfs_free_unicode_nls_name(*actual_name);
 	}
 	return error;
 }

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_utils.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_utils.h	2008-01-21 14:42:51.000000000 +1100
+++ b/fs/xfs/xfs_utils.h	2007-10-26 15:35:54.052564595 +1000
@@ -23,7 +23,7 @@
 =

 extern int xfs_get_dir_entry (bhv_vname_t *, xfs_inode_t **);
 extern int xfs_dir_lookup_int (xfs_inode_t *, uint, bhv_vname_t *, xfs_=
ino_t *,
-				xfs_inode_t **);
+				xfs_inode_t **, char **, int *);
 extern int xfs_truncate_file (xfs_mount_t *, xfs_inode_t *);
 extern int xfs_dir_ialloc (xfs_trans_t **, xfs_inode_t *, mode_t, xfs_n=
link_t,
 				xfs_dev_t, cred_t *, prid_t, int,

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_vfsops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_vfsops.c	2008-01-21 14:42:51.000000000 +1100
+++ b/fs/xfs/xfs_vfsops.c	2008-01-11 14:47:36.214448806 +1100
@@ -56,7 +56,7 @@
 #include "xfs_fsops.h"
 #include "xfs_vnodeops.h"
 #include "xfs_vfsops.h"
-
+#include "xfs_unicode.h"
 =

 int
 xfs_init(void)
@@ -81,6 +81,7 @@ xfs_init(void)
 	xfs_acl_zone_init(xfs_acl_zone, "xfs_acl");
 	xfs_mru_cache_init();
 	xfs_filestream_init();
+	xfs_unicode_init();
 =

 	/*
 	 * The size of the zone allocated buf log item is the maximum
@@ -158,6 +159,7 @@ xfs_cleanup(void)
 	xfs_cleanup_procfs();
 	xfs_sysctl_unregister();
 	xfs_refcache_destroy();
+	xfs_unicode_uninit();
 	xfs_filestream_uninit();
 	xfs_mru_cache_uninit();
 	xfs_acl_zone_destroy(xfs_acl_zone);
@@ -247,7 +249,6 @@ xfs_start_flags(
 		mp->m_logname =3D kmem_alloc(strlen(ap->logname) + 1, KM_SLEEP);
 		strcpy(mp->m_logname, ap->logname);
 	}
-
 	if (ap->flags & XFSMNT_WSYNC)
 		mp->m_flags |=3D XFS_MOUNT_WSYNC;
 #if XFS_BIG_INUMS
@@ -404,6 +405,39 @@ xfs_finish_flags(
 			mp->m_qflags |=3D XFS_OQUOTA_ENFD;
 	}
 =

+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		if (ap->flags2 & XFSMNT2_CILOOKUP)
+			mp->m_flags |=3D XFS_MOUNT_CI_LOOKUP;
+		if (ap->flags2 & XFSMNT2_CIATTR)
+			mp->m_flags |=3D XFS_MOUNT_CI_ATTR;
+
+		mp->m_nls =3D ap->nls[0] ? load_nls(ap->nls) : load_nls_default();
+		if (!mp->m_nls) {
+			cmn_err(CE_WARN,
+	"XFS: unable to load nls mapping \"%s\"\n", ap->nls);
+			return XFS_ERROR(EINVAL);
+		}
+		if (strcmp(mp->m_nls->charset, XFS_NLS_UTF8) =3D=3D 0) {
+			/* special case utf8 - no translation required */
+			unload_nls(mp->m_nls);
+			mp->m_nls =3D NULL;
+		}
+	} else {
+		/*
+		 * Check for mount options which require a Unicode FS
+		 */
+		if (ap->flags2 & (XFSMNT2_CILOOKUP | XFSMNT2_CIATTR)) {
+			cmn_err(CE_WARN,
+	"XFS: can't do case-insensitive mount on non-utf8 filesystem");
+			return XFS_ERROR(EINVAL);
+
+		}
+		if (ap->nls[0]) {
+			cmn_err(CE_WARN,
+	"XFS: can't use nls mount option on non-utf8 filesystem");
+			return XFS_ERROR(EINVAL);
+		}
+	}
 	return 0;
 }
 =

@@ -641,6 +675,8 @@ out:
 		xfs_unmountfs(mp, credp);
 		xfs_qmops_put(mp);
 		xfs_dmops_put(mp);
+		if (mp->m_nls)
+			unload_nls(mp->m_nls);
 		kmem_free(mp, sizeof(xfs_mount_t));
 	}
 =


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_vnodeops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_vnodeops.c	2008-01-21 14:42:51.000000000 +1100
+++ b/fs/xfs/xfs_vnodeops.c	2008-01-21 14:27:33.000000000 +1100
@@ -1772,7 +1772,9 @@ int
 xfs_lookup(
 	xfs_inode_t		*dp,
 	bhv_vname_t		*dentry,
-	bhv_vnode_t		**vpp)
+	bhv_vnode_t		**vpp,
+	char			**actual_name,
+	int			*actual_namelen)
 {
 	xfs_inode_t		*ip;
 	xfs_ino_t		e_inum;
@@ -1785,7 +1787,8 @@ xfs_lookup(
 		return XFS_ERROR(EIO);
 =

 	lock_mode =3D xfs_ilock_map_shared(dp);
-	error =3D xfs_dir_lookup_int(dp, lock_mode, dentry, &e_inum, &ip);
+	error =3D xfs_dir_lookup_int(dp, lock_mode, dentry, &e_inum, &ip,
+			actual_name, actual_namelen);
 	if (!error) {
 		*vpp =3D XFS_ITOV(ip);
 		xfs_itrace_ref(ip);

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
fs/xfs/xfs_vnodeops.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

--- a/fs/xfs/xfs_vnodeops.h	2008-01-21 14:42:51.000000000 +1100
+++ b/fs/xfs/xfs_vnodeops.h	2008-01-21 14:27:33.000000000 +1100
@@ -24,7 +24,7 @@ int xfs_fsync(struct xfs_inode *ip, int =

 int xfs_release(struct xfs_inode *ip);
 int xfs_inactive(struct xfs_inode *ip);
 int xfs_lookup(struct xfs_inode *dp, bhv_vname_t *dentry,
-		bhv_vnode_t **vpp);
+		bhv_vnode_t **vpp, char **actual_name, int *actual_namelen);
 int xfs_create(struct xfs_inode *dp, bhv_vname_t *dentry, mode_t mode,
 		xfs_dev_t rdev, bhv_vnode_t **vpp, struct cred *credp);
 int xfs_remove(struct xfs_inode *dp, bhv_vname_t	*dentry);

------------OopNAZbFULX3uI7ekf9jl6--

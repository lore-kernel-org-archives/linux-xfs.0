Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Oct 2007 00:51:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9N7pHQ8005590
	for <xfs@oss.sgi.com>; Tue, 23 Oct 2007 00:51:19 -0700
Date: Tue, 23 Oct 2007 17:53:10 +1000
Subject: [RFC 1/2] Case-insensitive XFS - kernel patch
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
Message-ID: <op.t0m36wxm3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>


  Makefile              |    1
  linux-2.6/xfs_iops.c  |   89 ++++++++
  linux-2.6/xfs_linux.h |    2
  linux-2.6/xfs_super.c |    8
  xfs_clnt.h            |    5
  xfs_da_btree.c        |   20 +
  xfs_da_btree.h        |   21 +
  xfs_dir2.c            |  177 +++++++++++++---
  xfs_dir2.h            |    9
  xfs_dir2_block.c      |   30 +-
  xfs_dir2_data.c       |    3
  xfs_dir2_leaf.c       |   19 +
  xfs_dir2_node.c       |    5
  xfs_dir2_sf.c         |   35 ++-
  xfs_mount.c           |   25 ++
  xfs_mount.h           |    8
  xfs_sb.h              |   33 ++-
  xfs_unicode.c         |  547  
++++++++++++++++++++++++++++++++++++++++++++++++++
  xfs_unicode.h         |   75 ++++++
  xfs_vfsops.c          |   53 ++++
  20 files changed, 1100 insertions(+), 65 deletions(-)

===========================================================================
fs/xfs/Makefile
===========================================================================

--- a/fs/xfs/Makefile	2007-10-23 17:19:40.000000000 +1000
+++ b/fs/xfs/Makefile	2007-10-23 16:17:22.173903950 +1000
@@ -74,6 +74,7 @@ xfs-y				+= xfs_alloc.o \
  				   xfs_trans_extfree.o \
  				   xfs_trans_inode.o \
  				   xfs_trans_item.o \
+				   xfs_unicode.o \
  				   xfs_utils.o \
  				   xfs_vfsops.o \
  				   xfs_vnodeops.o \

===========================================================================
fs/xfs/linux-2.6/xfs_iops.c
===========================================================================

--- a/fs/xfs/linux-2.6/xfs_iops.c	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_iops.c	2007-10-23 16:43:19.828562924 +1000
@@ -47,12 +47,17 @@
  #include "xfs_buf_item.h"
  #include "xfs_utils.h"
  #include "xfs_vnodeops.h"
+#include "xfs_da_btree.h"
+#include "xfs_unicode.h"

  #include <linux/capability.h>
  #include <linux/xattr.h>
  #include <linux/namei.h>
  #include <linux/security.h>

+struct dentry_operations xfs_dentry_operations;
+struct dentry_operations xfs_nls_dentry_operations;
+
  /*
   * Bring the atime in the XFS inode uptodate.
   * Used before logging the inode to disk or when the Linux inode goes  
away.
@@ -369,10 +374,17 @@ xfs_vn_lookup(
  {
  	bhv_vnode_t	*cvp;
  	int		error;
+	struct xfs_mount *mp = XFS_I(dir)->i_mount;
+	struct dentry	*result;

  	if (dentry->d_name.len >= MAXNAMELEN)
  		return ERR_PTR(-ENAMETOOLONG);

+	if (xfs_sb_version_hasunicode(&mp->m_sb) ||
+			xfs_sb_version_hasoldci(&mp->m_sb))
+		dentry->d_op = mp->m_nls ? &xfs_nls_dentry_operations :
+					&xfs_dentry_operations;
+
  	error = xfs_lookup(XFS_I(dir), dentry, &cvp);
  	if (unlikely(error)) {
  		if (unlikely(error != ENOENT))
@@ -381,7 +393,11 @@ xfs_vn_lookup(
  		return NULL;
  	}

-	return d_splice_alias(vn_to_inode(cvp), dentry);
+	result = d_splice_alias(vn_to_inode(cvp), dentry);
+	if (result)
+		result->d_op = dentry->d_op;
+
+	return result;
  }

  STATIC int
@@ -823,3 +839,74 @@ const struct inode_operations xfs_symlin
  	.listxattr		= xfs_vn_listxattr,
  	.removexattr		= xfs_vn_removexattr,
  };
+
+
+STATIC int
+xfs_dentry_hash(
+	struct dentry	*dir,
+	struct qstr	*this)
+{
+	this->hash = xfs_dir_hashname(XFS_I(dir->d_inode),
+				this->name, this->len);
+	return 0;
+}
+
+STATIC int
+xfs_dentry_compare(
+	struct dentry	*dir,
+	struct qstr	*a,
+	struct qstr	*b)
+{
+	int result = xfs_dir_compname(XFS_I(dir->d_inode), a->name, a->len,
+				b->name, b->len);
+	if (result == 0) {
+		if (a->len == b->len)
+			memcpy((unsigned char *)a->name, b->name, a->len);
+		else {
+			/* TODO: more complicated when name lengths differ */
+		}
+	}
+	return result;
+}
+
+STATIC int
+xfs_nls_dentry_hash(
+	struct dentry	*dir,
+	struct qstr	*this)
+{
+	xfs_mount_t	*mp = XFS_I(dir->d_inode)->i_mount;
+
+	this->hash = xfs_nls_hash(mp->m_nls, mp->m_cft, this->name, this->len);
+	return 0;
+}
+
+STATIC int
+xfs_nls_dentry_compare(
+	struct dentry	*dir,
+	struct qstr	*a,
+	struct qstr	*b)
+{
+	xfs_mount_t	*mp = XFS_I(dir->d_inode)->i_mount;
+	int 		result = xfs_nls_casecmp(mp->m_nls, mp->m_cft,
+					a->name, a->len, b->name, b->len);
+	if (result == 0) {
+		if (a->len == b->len)
+			memcpy((unsigned char *)a->name, b->name, a->len);
+		else {
+			/* TODO: more complicated when name lengths differ */
+		}
+	}
+	return result;
+}
+
+struct dentry_operations xfs_dentry_operations =
+{
+	.d_hash = xfs_dentry_hash,
+	.d_compare = xfs_dentry_compare,
+};
+
+struct dentry_operations xfs_nls_dentry_operations =
+{
+	.d_hash = xfs_nls_dentry_hash,
+	.d_compare = xfs_nls_dentry_compare,
+};

===========================================================================
fs/xfs/linux-2.6/xfs_linux.h
===========================================================================

--- a/fs/xfs/linux-2.6/xfs_linux.h	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_linux.h	2007-10-10 15:16:26.698563845 +1000
@@ -75,6 +75,8 @@
  #include <linux/delay.h>
  #include <linux/log2.h>
  #include <linux/spinlock.h>
+#include <linux/ctype.h>
+#include <linux/nls.h>

  #include <asm/page.h>
  #include <asm/div64.h>

===========================================================================
fs/xfs/linux-2.6/xfs_super.c
===========================================================================

--- a/fs/xfs/linux-2.6/xfs_super.c	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_super.c	2007-10-23 16:43:46.017187812 +1000
@@ -50,6 +50,7 @@
  #include "xfs_vnodeops.h"
  #include "xfs_vfsops.h"
  #include "xfs_version.h"
+#include "xfs_unicode.h"

  #include <linux/namei.h>
  #include <linux/init.h>
@@ -65,6 +66,9 @@ static kmem_zone_t *xfs_vnode_zone;
  static kmem_zone_t *xfs_ioend_zone;
  mempool_t *xfs_ioend_pool;

+extern struct dentry_operations xfs_dentry_operations;
+extern struct dentry_operations xfs_nls_dentry_operations;
+
  STATIC struct xfs_mount_args *
  xfs_args_allocate(
  	struct super_block	*sb,
@@ -871,6 +875,10 @@ xfs_fs_fill_super(
  		error = EINVAL;
  		goto fail_vnrele;
  	}
+	if (xfs_sb_version_hasunicode(&mp->m_sb) ||
+			xfs_sb_version_hasoldci(&mp->m_sb))
+		sb->s_root->d_op = mp->m_nls ? &xfs_nls_dentry_operations :
+						&xfs_dentry_operations;

  	mp->m_sync_work.w_syncer = xfs_sync_worker;
  	mp->m_sync_work.w_mount = mp;

===========================================================================
fs/xfs/xfs_clnt.h
===========================================================================

--- a/fs/xfs/xfs_clnt.h	2007-10-23 17:19:40.000000000 +1000
+++ b/fs/xfs/xfs_clnt.h	2007-10-12 17:07:03.022094920 +1000
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
+						 * extended attrs */

  #endif	/* __XFS_CLNT_H__ */

===========================================================================
fs/xfs/xfs_da_btree.c
===========================================================================

--- a/fs/xfs/xfs_da_btree.c	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_da_btree.c	2007-10-22 17:09:31.333665254 +1000
@@ -1530,6 +1530,26 @@ xfs_da_hashname(const uchar_t *name, int
  	}
  }

+
+xfs_dahash_t
+xfs_default_hashname(xfs_inode_t *inode, const uchar_t *name, int namelen)
+{
+	return xfs_da_hashname(name, namelen);
+}
+
+int
+xfs_default_compname(xfs_inode_t *inode, const uchar_t *name1, int len1,
+	const uchar_t *name2, int len2)
+{
+	return (len1 == len2) ? memcmp(name1, name2, len1) :
+			(len1 < len2) ? -1 : 1;
+}
+
+const struct xfs_nameops xfs_default_nameops = {
+	.hashname	= xfs_default_hashname,
+	.compname	= xfs_default_compname
+};
+
  /*
   * Add a block to the btree ahead of the file.
   * Return the new block number to the caller.

===========================================================================
fs/xfs/xfs_da_btree.h
===========================================================================

--- a/fs/xfs/xfs_da_btree.h	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_da_btree.h	2007-10-23 16:19:40.083993281 +1000
@@ -208,6 +208,27 @@ typedef struct xfs_da_state {
   *========================================================================*/

  /*
+ * Name ops for directory and/or attr name operations
+ */
+
+typedef xfs_dahash_t	(*xfs_hashname_t)(struct xfs_inode *,
+					const uchar_t *, int);
+typedef int	(*xfs_compname_t)(struct xfs_inode *, const uchar_t *, int,
+					const uchar_t *, int);
+
+typedef struct xfs_nameops {
+	xfs_hashname_t		hashname;
+	xfs_compname_t		compname;
+} xfs_nameops_t;
+
+extern const struct xfs_nameops xfs_default_nameops;
+
+xfs_dahash_t xfs_default_hashname(struct xfs_inode *inode, const uchar_t  
*name,
+				int namelen);
+int xfs_default_compname(struct xfs_inode *inode, const uchar_t *name1,
+				int len1, const uchar_t *name2, int len2);
+
+/*
   * Routines used for growing the Btree.
   */
  int	xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,

===========================================================================
fs/xfs/xfs_dir2.c
===========================================================================

--- a/fs/xfs/xfs_dir2.c	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_dir2.c	2007-10-23 16:42:40.857585216 +1000
@@ -42,9 +42,71 @@
  #include "xfs_dir2_node.h"
  #include "xfs_dir2_trace.h"
  #include "xfs_error.h"
+#include "xfs_unicode.h"

+static xfs_dahash_t
+xfs_ascii_ci_hashname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name,
+	int		namelen)
+{
+	xfs_dahash_t	hash;
+	int		i;
+
+	for (i = 0, hash = 0; i < namelen; i++)
+		hash = tolower(name[i]) ^ rol32(hash, 7);
+
+	return hash;
+}
+
+static int
+xfs_ascii_ci_compname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
+	int 		len2)
+{
+	return (len1 == len2) ? strncasecmp(name1, name2, len1) : len1 - len2;
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

-void
+static int
+xfs_unicode_ci_compname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
+	int 		len2)
+{
+	return xfs_unicode_casecmp(inode->i_mount->m_cft,
+			name1, len1, name2, len2);
+}
+
+static const struct xfs_nameops xfs_ascii_ci_nameops = {
+	.hashname	= xfs_ascii_ci_hashname,
+	.compname	= xfs_ascii_ci_compname,
+};
+
+static const struct xfs_nameops xfs_unicode_nameops = {
+	.hashname	= xfs_unicode_ci_hashname,
+	.compname	= xfs_default_compname,
+};
+
+static const struct xfs_nameops xfs_unicode_ci_nameops = {
+	.hashname	= xfs_unicode_ci_hashname,
+	.compname	= xfs_unicode_ci_compname,
+};
+
+int
  xfs_dir_mount(
  	xfs_mount_t	*mp)
  {
@@ -63,6 +125,15 @@ xfs_dir_mount(
  		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
  		(uint)sizeof(xfs_da_node_entry_t);
  	mp->m_dir_magicpct = (mp->m_dirblksize * 37) / 100;
+
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		mp->m_dirnameops = (mp->m_flags & XFS_MOUNT_CI_LOOKUP) ?
+			&xfs_unicode_ci_nameops : &xfs_unicode_nameops;
+	} else
+		mp->m_dirnameops = (xfs_sb_version_hasoldci(&mp->m_sb)) ?
+			&xfs_ascii_ci_nameops : &xfs_default_nameops;
+
+	return 0;
  }

  /*
@@ -139,6 +210,50 @@ xfs_dir_init(
  }

  /*
+ * Set up the args with appropriate name and hash value
+ */
+
+static int
+xfs_dir_setup_name_and_hash(
+	xfs_da_args_t		*args,
+	const char 		*name,
+	int			namelen)
+{
+	char			*uname;
+
+	if (args->dp->i_mount->m_nls) {
+		uname = kmem_alloc(MAXNAMELEN, KM_SLEEP);
+		args->namelen = xfs_nls_to_unicode(args->dp->i_mount->m_nls,
+					name, namelen, uname, MAXNAMELEN);
+		if (args->namelen < 0) {
+			kmem_free(uname, MAXNAMELEN);
+			return -args->namelen;
+		}
+		args->name = uname;
+	} else {
+		if (xfs_sb_version_hasunicode(&args->dp->i_mount->m_sb)) {
+			int	rval;
+			rval = xfs_unicode_validate(name, namelen);
+			if (rval < 0)
+				return -rval;
+		}
+		args->name = name;
+		args->namelen = namelen;
+	}
+	args->hashval = xfs_dir_hashname(args->dp, args->name, args->namelen);
+	return 0;
+}
+
+static inline void
+xfs_dir_cleanup_name(
+	xfs_da_args_t		*args,
+	const uchar_t 		*name)
+{
+	if (args->name != name)
+		kmem_free((void *)args->name, MAXNAMELEN);
+}
+
+/*
    Enter a name in a directory.
   */
  int
@@ -161,9 +276,6 @@ xfs_dir_createname(
  		return rval;
  	XFS_STATS_INC(xs_dir_create);

-	args.name = name;
-	args.namelen = namelen;
-	args.hashval = xfs_da_hashname(name, namelen);
  	args.inumber = inum;
  	args.dp = dp;
  	args.firstblock = first;
@@ -173,19 +285,24 @@ xfs_dir_createname(
  	args.trans = tp;
  	args.justcheck = 0;
  	args.addname = args.oknoent = 1;
+	rval = xfs_dir_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;

  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
  		rval = xfs_dir2_sf_addname(&args);
  	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out;
  	else if (v)
  		rval = xfs_dir2_block_addname(&args);
  	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out;
  	else if (v)
  		rval = xfs_dir2_leaf_addname(&args);
  	else
  		rval = xfs_dir2_node_addname(&args);
+out:
+	xfs_dir_cleanup_name(&args, name);
  	return rval;
  }

@@ -207,9 +324,6 @@ xfs_dir_lookup(
  	ASSERT((dp->i_d.di_mode & S_IFMT) == S_IFDIR);
  	XFS_STATS_INC(xs_dir_lookup);

-	args.name = name;
-	args.namelen = namelen;
-	args.hashval = xfs_da_hashname(name, namelen);
  	args.inumber = 0;
  	args.dp = dp;
  	args.firstblock = NULL;
@@ -219,15 +333,18 @@ xfs_dir_lookup(
  	args.trans = tp;
  	args.justcheck = args.addname = 0;
  	args.oknoent = 1;
+	rval = xfs_dir_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;

  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
  		rval = xfs_dir2_sf_lookup(&args);
  	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out;
  	else if (v)
  		rval = xfs_dir2_block_lookup(&args);
  	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out;
  	else if (v)
  		rval = xfs_dir2_leaf_lookup(&args);
  	else
@@ -236,6 +353,8 @@ xfs_dir_lookup(
  		rval = 0;
  	if (rval == 0)
  		*inum = args.inumber;
+out:
+	xfs_dir_cleanup_name(&args, name);
  	return rval;
  }

@@ -260,9 +379,6 @@ xfs_dir_removename(
  	ASSERT((dp->i_d.di_mode & S_IFMT) == S_IFDIR);
  	XFS_STATS_INC(xs_dir_remove);

-	args.name = name;
-	args.namelen = namelen;
-	args.hashval = xfs_da_hashname(name, namelen);
  	args.inumber = ino;
  	args.dp = dp;
  	args.firstblock = first;
@@ -271,19 +387,24 @@ xfs_dir_removename(
  	args.whichfork = XFS_DATA_FORK;
  	args.trans = tp;
  	args.justcheck = args.addname = args.oknoent = 0;
+	rval = xfs_dir_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;

  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
  		rval = xfs_dir2_sf_removename(&args);
  	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out;
  	else if (v)
  		rval = xfs_dir2_block_removename(&args);
  	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out;
  	else if (v)
  		rval = xfs_dir2_leaf_removename(&args);
  	else
  		rval = xfs_dir2_node_removename(&args);
+out:
+	xfs_dir_cleanup_name(&args, name);
  	return rval;
  }

@@ -344,9 +465,6 @@ xfs_dir_replace(
  	if ((rval = xfs_dir_ino_validate(tp->t_mountp, inum)))
  		return rval;

-	args.name = name;
-	args.namelen = namelen;
-	args.hashval = xfs_da_hashname(name, namelen);
  	args.inumber = inum;
  	args.dp = dp;
  	args.firstblock = first;
@@ -355,19 +473,24 @@ xfs_dir_replace(
  	args.whichfork = XFS_DATA_FORK;
  	args.trans = tp;
  	args.justcheck = args.addname = args.oknoent = 0;
+	rval = xfs_dir_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;

  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
  		rval = xfs_dir2_sf_replace(&args);
  	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out;
  	else if (v)
  		rval = xfs_dir2_block_replace(&args);
  	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out;
  	else if (v)
  		rval = xfs_dir2_leaf_replace(&args);
  	else
  		rval = xfs_dir2_node_replace(&args);
+out:
+	xfs_dir_cleanup_name(&args, name);
  	return rval;
  }

@@ -387,9 +510,6 @@ xfs_dir_canenter(

  	ASSERT((dp->i_d.di_mode & S_IFMT) == S_IFDIR);

-	args.name = name;
-	args.namelen = namelen;
-	args.hashval = xfs_da_hashname(name, namelen);
  	args.inumber = 0;
  	args.dp = dp;
  	args.firstblock = NULL;
@@ -398,19 +518,24 @@ xfs_dir_canenter(
  	args.whichfork = XFS_DATA_FORK;
  	args.trans = tp;
  	args.justcheck = args.addname = args.oknoent = 1;
+	rval = xfs_dir_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;

  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
  		rval = xfs_dir2_sf_addname(&args);
  	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out;
  	else if (v)
  		rval = xfs_dir2_block_addname(&args);
  	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out;
  	else if (v)
  		rval = xfs_dir2_leaf_addname(&args);
  	else
  		rval = xfs_dir2_node_addname(&args);
+out:
+	xfs_dir_cleanup_name(&args, name);
  	return rval;
  }


===========================================================================
fs/xfs/xfs_dir2.h
===========================================================================

--- a/fs/xfs/xfs_dir2.h	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_dir2.h	2007-10-22 17:32:23.984399805 +1000
@@ -63,7 +63,7 @@ typedef	xfs_off_t	xfs_dir2_off_t;
   * Generic directory interface routines
   */
  extern void xfs_dir_startup(void);
-extern void xfs_dir_mount(struct xfs_mount *mp);
+extern int xfs_dir_mount(struct xfs_mount *mp);
  extern int xfs_dir_isempty(struct xfs_inode *dp);
  extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
  				struct xfs_inode *pdp);
@@ -85,6 +85,13 @@ extern int xfs_dir_canenter(struct xfs_t
  				char *name, int namelen);
  extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);

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

===========================================================================
fs/xfs/xfs_dir2_block.c
===========================================================================

--- a/fs/xfs/xfs_dir2_block.c	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_dir2_block.c	2007-10-15 16:57:13.164123893 +1000
@@ -38,6 +38,7 @@
  #include "xfs_dir2_block.h"
  #include "xfs_dir2_trace.h"
  #include "xfs_error.h"
+#include "xfs_unicode.h"

  /*
   * Local function prototypes.
@@ -450,6 +451,8 @@ xfs_dir2_block_getdents(
  	int			wantoff;	/* starting block offset */
  	xfs_ino_t		ino;
  	xfs_off_t		cook;
+	char			*nls_name = NULL; /* NLS name buffer */
+	int			nls_namelen = 0;

  	mp = dp->i_mount;
  	/*
@@ -481,6 +484,9 @@ xfs_dir2_block_getdents(
  	ptr = (char *)block->u;
  	endptr = (char *)xfs_dir2_block_leaf_p(btp);

+	if (mp->m_nls)
+		nls_name = kmem_alloc(MAXNAMELEN, KM_SLEEP);
+
  	/*
  	 * Loop over the data portion of the block.
  	 * Each object is a real entry (dep) or an unused one (dup).
@@ -513,17 +519,21 @@ xfs_dir2_block_getdents(
  #if XFS_BIG_INUMS
  		ino += mp->m_inoadd;
  #endif
+		if (mp->m_nls)
+			nls_namelen = xfs_unicode_to_nls(mp->m_nls, dep->name,
+					dep->namelen, nls_name, MAXNAMELEN);

  		/*
  		 * If it didn't fit, set the final offset to here & return.
  		 */
-		if (filldir(dirent, dep->name, dep->namelen, cook,
-			    ino, DT_UNKNOWN)) {
+
+		if (filldir(dirent, nls_namelen > 0 ? nls_name : (char *)dep->name,
+				nls_namelen > 0 ? nls_namelen : dep->namelen,
+				cook, ino, DT_UNKNOWN)) {
  			*offset = xfs_dir2_db_off_to_dataptr(mp,
  					mp->m_dirdatablk,
  					(char *)dep - (char *)block);
-			xfs_da_brelse(NULL, bp);
-			return 0;
+			goto out;
  		}
  	}

@@ -532,7 +542,10 @@ xfs_dir2_block_getdents(
  	 * Set the offset to a non-existent block 1 and return.
  	 */
  	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
+out:
  	xfs_da_brelse(NULL, bp);
+	if (mp->m_nls)
+		kmem_free(nls_name, MAXNAMELEN);
  	return 0;
  }

@@ -701,9 +714,8 @@ xfs_dir2_block_lookup_int(
  		/*
  		 * Compare, if it's right give back buffer & entry number.
  		 */
-		if (dep->namelen == args->namelen &&
-		    dep->name[0] == args->name[0] &&
-		    memcmp(dep->name, args->name, args->namelen) == 0) {
+		if (xfs_dir_compname(dp, dep->name, dep->namelen, args->name,
+		    		args->namelen) == 0) {
  			*bpp = bp;
  			*entno = mid;
  			return 0;
@@ -1189,8 +1201,8 @@ xfs_dir2_sf_to_block(
  		tagp = xfs_dir2_data_entry_tag_p(dep);
  		*tagp = cpu_to_be16((char *)dep - (char *)block);
  		xfs_dir2_data_log_entry(tp, bp, dep);
-		blp[2 + i].hashval = cpu_to_be32(xfs_da_hashname(
-					(char *)sfep->name, sfep->namelen));
+		blp[2 + i].hashval = cpu_to_be32(xfs_dir_hashname(dp,
+						sfep->name, sfep->namelen));
  		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
  						 (char *)dep - (char *)block));
  		offset = (int)((char *)(tagp + 1) - (char *)block);

===========================================================================
fs/xfs/xfs_dir2_data.c
===========================================================================

--- a/fs/xfs/xfs_dir2_data.c	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_dir2_data.c	2007-10-10 15:10:39.019079916 +1000
@@ -140,7 +140,8 @@ xfs_dir2_data_check(
  			addr = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
  				(xfs_dir2_data_aoff_t)
  				((char *)dep - (char *)d));
-			hash = xfs_da_hashname((char *)dep->name, dep->namelen);
+			hash = xfs_dir_hashname(dp, (char *)dep->name,
+				dep->namelen);
  			for (i = 0; i < be32_to_cpu(btp->count); i++) {
  				if (be32_to_cpu(lep[i].address) == addr &&
  				    be32_to_cpu(lep[i].hashval) == hash)

===========================================================================
fs/xfs/xfs_dir2_leaf.c
===========================================================================

--- a/fs/xfs/xfs_dir2_leaf.c	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_dir2_leaf.c	2007-10-15 16:57:31.749743368 +1000
@@ -40,6 +40,7 @@
  #include "xfs_dir2_node.h"
  #include "xfs_dir2_trace.h"
  #include "xfs_error.h"
+#include "xfs_unicode.h"

  /*
   * Local function declarations.
@@ -780,6 +781,8 @@ xfs_dir2_leaf_getdents(
  	int			ra_offset;	/* map entry offset for ra */
  	int			ra_want;	/* readahead count wanted */
  	xfs_ino_t		ino;
+	char			*nls_name = NULL; /* NLS name buffer */
+	int			nls_namelen = 0;

  	/*
  	 * If the offset is at or past the largest allowed value,
@@ -800,6 +803,9 @@ xfs_dir2_leaf_getdents(
  	map_valid = ra_index = ra_offset = ra_current = map_blocks = 0;
  	bp = NULL;

+	if (mp->m_nls)
+		nls_name = kmem_alloc(MAXNAMELEN, KM_SLEEP);
+
  	/*
  	 * Inside the loop we keep the main offset value as a byte offset
  	 * in the directory file.
@@ -1086,11 +1092,15 @@ xfs_dir2_leaf_getdents(
  #if XFS_BIG_INUMS
  		ino += mp->m_inoadd;
  #endif
+		if (mp->m_nls)
+			nls_namelen = xfs_unicode_to_nls(mp->m_nls, dep->name,
+					dep->namelen, nls_name, MAXNAMELEN);

  		/*
  		 * Won't fit.  Return to caller.
  		 */
-		if (filldir(dirent, dep->name, dep->namelen,
+		if (filldir(dirent, nls_namelen > 0 ? nls_name : (char *)dep->name,
+				nls_namelen > 0 ? nls_namelen : dep->namelen,
  			    xfs_dir2_byte_to_dataptr(mp, curoff + length),
  			    ino, DT_UNKNOWN))
  			break;
@@ -1113,6 +1123,8 @@ xfs_dir2_leaf_getdents(
  	kmem_free(map, map_size * sizeof(*map));
  	if (bp)
  		xfs_da_brelse(NULL, bp);
+	if (mp->m_nls)
+		kmem_free(nls_name, MAXNAMELEN);
  	return error;
  }

@@ -1392,9 +1404,8 @@ xfs_dir2_leaf_lookup_int(
  		/*
  		 * If it matches then return it.
  		 */
-		if (dep->namelen == args->namelen &&
-		    dep->name[0] == args->name[0] &&
-		    memcmp(dep->name, args->name, args->namelen) == 0) {
+		if (xfs_dir_compname(dp, dep->name, dep->namelen, args->name,
+				args->namelen) == 0) {
  			*dbpp = dbp;
  			*indexp = index;
  			return 0;

===========================================================================
fs/xfs/xfs_dir2_node.c
===========================================================================

--- a/fs/xfs/xfs_dir2_node.c	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_dir2_node.c	2007-10-10 15:11:08.719279567 +1000
@@ -578,9 +578,8 @@ xfs_dir2_leafn_lookup_int(
  			/*
  			 * Compare the entry, return it if it matches.
  			 */
-			if (dep->namelen == args->namelen &&
-			    dep->name[0] == args->name[0] &&
-			    memcmp(dep->name, args->name, args->namelen) == 0) {
+			if (xfs_dir_compname(dp, dep->name, dep->namelen,
+					args->name, args->namelen) == 0) {
  				args->inumber = be64_to_cpu(dep->inumber);
  				*indexp = index;
  				state->extravalid = 1;

===========================================================================
fs/xfs/xfs_dir2_sf.c
===========================================================================

--- a/fs/xfs/xfs_dir2_sf.c	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_dir2_sf.c	2007-10-18 14:03:09.916774315 +1000
@@ -38,6 +38,7 @@
  #include "xfs_dir2_leaf.h"
  #include "xfs_dir2_block.h"
  #include "xfs_dir2_trace.h"
+#include "xfs_unicode.h"

  /*
   * Prototypes for internal functions.
@@ -708,6 +709,8 @@ xfs_dir2_sf_getdents(
  	xfs_dir2_dataptr_t	dot_offset;
  	xfs_dir2_dataptr_t	dotdot_offset;
  	xfs_ino_t		ino;
+	char			*nls_name = NULL; /* NLS name buffer */
+	int			nls_namelen = 0;

  	mp = dp->i_mount;

@@ -774,6 +777,9 @@ xfs_dir2_sf_getdents(
  		}
  	}

+	if (mp->m_nls)
+		nls_name = kmem_alloc(MAXNAMELEN, KM_SLEEP);
+
  	/*
  	 * Loop while there are more entries and put'ing works.
  	 */
@@ -791,17 +797,22 @@ xfs_dir2_sf_getdents(
  #if XFS_BIG_INUMS
  		ino += mp->m_inoadd;
  #endif
-
-		if (filldir(dirent, sfep->name, sfep->namelen,
+		if (mp->m_nls)
+			nls_namelen = xfs_unicode_to_nls(mp->m_nls, sfep->name,
+					sfep->namelen, nls_name, MAXNAMELEN);
+		if (filldir(dirent, nls_namelen > 0 ? nls_name : (char *)sfep->name,
+				nls_namelen > 0 ? nls_namelen : sfep->namelen,
  			    off + xfs_dir2_data_entsize(sfep->namelen),
  			    ino, DT_UNKNOWN)) {
  			*offset = off;
-			return 0;
+			goto out;
  		}
  		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
  	}
-
  	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
+out:
+	if (mp->m_nls)
+		kmem_free(nls_name, MAXNAMELEN);
  	return 0;
  }

@@ -855,9 +866,8 @@ xfs_dir2_sf_lookup(
  	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
  	     i < sfp->hdr.count;
  	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
-		if (sfep->namelen == args->namelen &&
-		    sfep->name[0] == args->name[0] &&
-		    memcmp(args->name, sfep->name, args->namelen) == 0) {
+		if (xfs_dir_compname(dp, sfep->name, sfep->namelen,
+				args->name, args->namelen) == 0) {
  			args->inumber =
  				xfs_dir2_sf_get_inumber(sfp,
  					xfs_dir2_sf_inumberp(sfep));
@@ -910,9 +920,8 @@ xfs_dir2_sf_removename(
  	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
  	     i < sfp->hdr.count;
  	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
-		if (sfep->namelen == args->namelen &&
-		    sfep->name[0] == args->name[0] &&
-		    memcmp(sfep->name, args->name, args->namelen) == 0) {
+		if (xfs_dir_compname(dp, sfep->name, sfep->namelen,
+				args->name, args->namelen) == 0) {
  			ASSERT(xfs_dir2_sf_get_inumber(sfp,
  					xfs_dir2_sf_inumberp(sfep)) ==
  				args->inumber);
@@ -1047,9 +1056,9 @@ xfs_dir2_sf_replace(
  		for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
  		     i < sfp->hdr.count;
  		     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
-			if (sfep->namelen == args->namelen &&
-			    sfep->name[0] == args->name[0] &&
-			    memcmp(args->name, sfep->name, args->namelen) == 0) {
+			if (xfs_dir_compname(dp, sfep->name,
+					sfep->namelen, args->name,
+					args->namelen) == 0) {
  #if XFS_BIG_INUMS || defined(DEBUG)
  				ino = xfs_dir2_sf_get_inumber(sfp,
  					xfs_dir2_sf_inumberp(sfep));

===========================================================================
fs/xfs/xfs_mount.c
===========================================================================

--- a/fs/xfs/xfs_mount.c	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_mount.c	2007-10-23 16:36:16.371190339 +1000
@@ -43,6 +43,7 @@
  #include "xfs_rw.h"
  #include "xfs_quota.h"
  #include "xfs_fsops.h"
+#include "xfs_unicode.h"

  STATIC void	xfs_mount_log_sbunit(xfs_mount_t *, __int64_t);
  STATIC int	xfs_uuid_mount(xfs_mount_t *);
@@ -119,6 +120,8 @@ static const struct {
      { offsetof(xfs_sb_t, sb_logsectsize),0 },
      { offsetof(xfs_sb_t, sb_logsunit),	 0 },
      { offsetof(xfs_sb_t, sb_features2),	 0 },
+    { offsetof(xfs_sb_t, sb_reserved),	 0 },
+    { offsetof(xfs_sb_t, sb_cftino),	 0 },
      { sizeof(xfs_sb_t),			 0 }
  };

@@ -171,6 +174,9 @@ xfs_mount_free(
  			  sizeof(xfs_perag_t) * mp->m_sb.sb_agcount);
  	}

+	if (mp->m_cft)
+		xfs_unicode_free_cft(mp->m_cft);
+
  	spinlock_destroy(&mp->m_ail_lock);
  	spinlock_destroy(&mp->m_sb_lock);
  	mutex_destroy(&mp->m_ilock);
@@ -455,6 +461,8 @@ xfs_sb_from_disk(
  	to->sb_logsectsize = be16_to_cpu(from->sb_logsectsize);
  	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
  	to->sb_features2 = be32_to_cpu(from->sb_features2);
+	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
+	to->sb_cftino = be64_to_cpu(from->sb_cftino);
  }

  /*
@@ -1057,7 +1065,9 @@ xfs_mountfs(

  	mp->m_dmevmask = 0;	/* not persistent; set after each mount */

-	xfs_dir_mount(mp);
+	error = xfs_dir_mount(mp);
+	if (error)
+		goto error1;

  	/*
  	 * Initialize the attribute manager's entries.
@@ -1165,6 +1175,17 @@ xfs_mountfs(
  	}

  	/*
+	 * Load in unicode case folding table from disk
+	 */
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		error = xfs_unicode_read_cft(mp);
+		if (error) {
+			cmn_err(CE_WARN, "XFS: failed to read unicode table");
+			goto error4;
+		}
+	}
+
+	/*
  	 * If fs is not mounted readonly, then update the superblock
  	 * unit and width changes.
  	 */
@@ -1220,6 +1241,8 @@ xfs_mountfs(
  	 * Free up the root inode.
  	 */
  	VN_RELE(rvp);
+	if (mp->m_cft)
+		xfs_unicode_free_cft(mp->m_cft);
   error3:
  	xfs_log_unmount_dealloc(mp);
   error2:

===========================================================================
fs/xfs/xfs_mount.h
===========================================================================

--- a/fs/xfs/xfs_mount.h	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_mount.h	2007-10-22 13:57:35.769401728 +1000
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

  /*
   * Prototypes and functions for the Data Migration subsystem.
@@ -306,6 +309,9 @@ typedef struct xfs_mount {
  	__uint8_t		m_inode_quiesce;/* call quiesce on new inodes.
  						   field governed by m_ilock */
  	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
+	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
+	const struct xfs_cft	*m_cft;		/* unicode case fold table */
+	struct nls_table 	*m_nls;		/* active NLS table */
  	int			m_dirblksize;	/* directory block sz--bytes */
  	int			m_dirblkfsbs;	/* directory block sz--fsbs */
  	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */
@@ -371,6 +377,8 @@ typedef struct xfs_mount {
  						   counters */
  #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
  						   allocator */
+#define XFS_MOUNT_CI_LOOKUP	(1ULL << 25)	/* enable case-insensitive
+						 * file lookup */


  /*

===========================================================================
fs/xfs/xfs_sb.h
===========================================================================

--- a/fs/xfs/xfs_sb.h	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_sb.h	2007-10-23 16:55:47.440178601 +1000
@@ -46,10 +46,12 @@ struct xfs_mount;
  #define XFS_SB_VERSION_SECTORBIT	0x0800
  #define	XFS_SB_VERSION_EXTFLGBIT	0x1000
  #define	XFS_SB_VERSION_DIRV2BIT		0x2000
+#define XFS_SB_VERSION_OLDCIBIT		0x4000
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
  #define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters */
  #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
  #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
+#define XFS_SB_VERSION2_UNICODEBIT	0x00000020	/* Unicode names */

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
+	__uint32_t	sb_bad_features2; /* features2 could be here */
+	xfs_ino_t	sb_cftino;	/* unicode case folding table inode */
+	/* must be padded to 64 bit alignment */
  } xfs_sb_t;

  /*
@@ -205,6 +212,9 @@ typedef struct xfs_dsb {
  	__be16		sb_logsectsize;	/* sector size for the log, bytes */
  	__be32		sb_logsunit;	/* stripe unit size for the log */
  	__be32		sb_features2;	/* additional feature bits */
+	__be32		sb_bad_features2; /* features2 could be here */
+	__be64		sb_cftino;	/* unicode case folding table inode */
+	/* must be padded to 64 bit alignment */
  } xfs_dsb_t;

  /*
@@ -223,7 +233,7 @@ typedef enum {
  	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
  	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
  	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_CFTINO,
  	XFS_SBS_FIELDCOUNT
  } xfs_sb_field_t;

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
+	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
+	 XFS_SB_CFTINO)


  /*
@@ -463,6 +475,12 @@ static inline int xfs_sb_version_hassect
  		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
  }

+static inline int xfs_sb_version_hasoldci(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
+		((sbp)->sb_versionnum & XFS_SB_VERSION_OLDCIBIT);
+}
+
  #define XFS_SB_VERSION_HASMOREBITS(sbp)	xfs_sb_version_hasmorebits(sbp)
  static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
  {
@@ -502,6 +520,13 @@ static inline void xfs_sb_version_addatt
  		((sbp)->sb_features2 | XFS_SB_VERSION2_ATTR2BIT)));
  }

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

===========================================================================
fs/xfs/xfs_unicode.c
===========================================================================

--- a/fs/xfs/xfs_unicode.c	2006-06-17 00:58:24.000000000 +1000
+++ b/fs/xfs/xfs_unicode.c	2007-10-23 16:17:02.336480442 +1000
@@ -0,0 +1,547 @@
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
+ * along with this program; if not, write the Free Software Foundation,
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
+#include "xfs_unicode.h"
+
+#define MAX_FOLD_CHARS	4
+
+static inline int
+xfs_casefold(
+	const xfs_cft_t *cft,
+	__uint16_t	c,
+	__uint16_t	*fc)
+{
+	__uint16_t	*table = XFS_CFT_PTR(cft, 0);
+	__uint16_t	tmp = table[c >> 8];
+	int		i;
+
+	if (!tmp) {
+		*fc = c;
+		return 1;
+	}
+	tmp = table[tmp + (c & 0xff)];
+	if ((tmp & 0xf000) != 0xe000) {
+		*fc = tmp;
+		return 1;
+	}
+	i = ((tmp >> 10) & 0x3) + 2;
+	ASSERT(i < cft->num_tables);
+	table = XFS_CFT_PTR(cft, i - 1) + ((tmp & 0x3ff) * i);
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
+	if (*namelen == 0)
+		return 0;
+
+	if (**name & 0x80) {
+		int	n = utf8_mbtowc(&uc, *name, *namelen);
+		if (n < 0) {
+			(*namelen)--;
+			*fc = *(*name)++;
+			return 1;
+		}
+		*name += n;
+		*namelen -= n;
+	} else {
+		uc = *(*name)++;
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
+	__uint32_t	hash = 0;
+	__uint16_t	fc[MAX_FOLD_CHARS];
+	int		nfc;
+	int		i;
+
+	while (namelen > 0) {
+		nfc = xfs_utf8_casefold(cft, &name, &namelen, fc);
+		for (i = 0; i < nfc; i++)
+			hash = fc[i] ^ rol32(hash, 7);
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
+	nfc1 = xfs_utf8_casefold(cft, &name1, &len1, fc1);
+	pfc1 = fc1;
+	nfc2 = xfs_utf8_casefold(cft, &name2, &len2, fc2);
+	pfc2 = fc2;
+
+	while (nfc1 > 0 && nfc2 > 0) {
+		if (*pfc1 != *pfc2)
+			return (*pfc1 < *pfc2) ? -1 : 1;
+		if (!--nfc1) {
+			nfc1 = xfs_utf8_casefold(cft, &name1, &len1, fc1);
+			pfc1 = fc1;
+		} else
+			pfc1++;
+		if (!--nfc2) {
+			nfc2 = xfs_utf8_casefold(cft, &name2, &len2, fc2);
+			pfc2 = fc2;
+		} else
+			pfc2++;
+	}
+	if (nfc1 != nfc2)
+		return (nfc1 < nfc2) ? -1 : 1;
+	return 0;
+}
+
+
+int
+xfs_nls_to_unicode(
+	struct nls_table *nls,
+	const char	*nls_name,
+	int		nls_namelen,
+	char		*uni_name,
+	int		uni_buflen)
+{
+	int		i, o;
+	wchar_t		uc;
+	int		nlen;
+	int		u8len;
+
+	if (!nls) {
+		if (uni_buflen < nls_namelen)
+			return -ENAMETOOLONG;
+		memcpy(uni_name, nls_name, nls_namelen);
+		return nls_namelen;
+	}
+
+	for (i = 0, o = 0; i < nls_namelen; i += nlen, o += u8len) {
+		nlen = nls->char2uni(nls_name + i, nls_namelen - i, &uc);
+		if (nlen < 0)
+			return nlen;
+		if (uc >= 0xfffe || (uc >= 0xd800 && uc <= 0xdfff))
+			return -EINVAL;	/* don't support chars outside BMP */
+		u8len = utf8_wctomb(uni_name + o, uc, uni_buflen - o);
+		if (u8len <= 0)
+			return (uni_buflen - o < 3) ? -ENAMETOOLONG : -EINVAL;
+	}
+	return o;
+}
+
+int
+xfs_unicode_to_nls(
+	struct nls_table *nls,
+	const char	*uni_name,
+	int		uni_namelen,
+	char		*nls_name,
+	int		nls_buflen)
+{
+	int		i, o;
+	wchar_t		uc;
+	int		nlen;
+	int		u8len;
+
+	if (!nls) {
+		if (nls_buflen < uni_namelen)
+			return -ENAMETOOLONG;
+		memcpy(nls_name, uni_name, uni_namelen);
+		return uni_namelen;
+	}
+
+	for (i = 0, o = 0; i < uni_namelen && o < nls_buflen; i += u8len, o +=  
nlen) {
+		u8len = utf8_mbtowc(&uc, uni_name + i, uni_namelen - i);
+		if (u8len < 0)
+			return -EINVAL;
+		nlen = nls->uni2char(uc, nls_name + o, nls_buflen - o);
+		if (nlen == -EINVAL) {
+			nls_name[o] = '?';
+			nlen = 1;
+		} else if (nlen < 0)
+			return nlen;
+	}
+	if (i < uni_namelen)
+		return -ENAMETOOLONG;
+	return o;
+}
+
+static inline int
+xfs_nls_casefold(
+	struct nls_table *nls,
+	const xfs_cft_t	*cft,
+	const uchar_t	**name,
+	int		*namelen,
+	__uint16_t	*fc)
+{
+	wchar_t		uc;
+
+	if (*namelen == 0)
+		return 0;
+
+	if (**name & 0x80) {
+		int	n = nls->char2uni(*name, *namelen, &uc);
+		if (n < 0) {
+			uc = *(*name)++;
+			(*namelen)--;
+		} else {
+			*name += n;
+			*namelen -= n;
+		}
+	} else {
+		uc = *(*name)++;
+		(*namelen)--;
+	}
+	return xfs_casefold(cft, uc, fc);
+}
+
+
+__uint32_t
+xfs_nls_hash(
+	struct nls_table *nls,
+	const xfs_cft_t	*cft,
+	const uchar_t	*name,
+	int		namelen)
+{
+	__uint32_t	hash = 0;
+	__uint16_t	fc[MAX_FOLD_CHARS];
+	int		i, nfc;
+
+	while (namelen > 0) {
+		nfc = xfs_nls_casefold(nls, cft, &name, &namelen, fc);
+		for (i = 0; i < nfc; i++)
+			hash = fc[i] ^ rol32(hash, 7);
+	}
+	return hash;
+}
+
+int
+xfs_nls_casecmp(
+	struct nls_table *nls,
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
+	nfc1 = xfs_nls_casefold(nls, cft, &name1, &len1, fc1);
+	pfc1 = fc1;
+	nfc2 = xfs_nls_casefold(nls, cft, &name2, &len2, fc2);
+	pfc2 = fc2;
+
+	while (nfc1 > 0 && nfc2 > 0) {
+		if (*pfc1 != *pfc2)
+			return (*pfc1 < *pfc2) ? -1 : 1;
+		if (!--nfc1) {
+			nfc1 = xfs_nls_casefold(nls, cft, &name1, &len1, fc1);
+			pfc1 = fc1;
+		} else
+			pfc1++;
+		if (!--nfc2) {
+			nfc2 = xfs_nls_casefold(nls, cft, &name2, &len2, fc2);
+			pfc2 = fc2;
+		} else
+			pfc2++;
+	}
+	if (nfc1 != nfc2)
+		return (nfc1 < nfc2) ? -1 : 1;
+	return 0;
+
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
+	for (i = 0; i < namelen; i += nlen) {
+		if (*name >= 0xf0) {
+			cmn_err(CE_WARN, "xfs_unicode_validate: "
+					"UTF-8 char beyond U+FFFF\n");
+			return -EINVAL;
+		}
+		/* utf8_mbtowc must fail on overlong sequences too */
+		nlen = utf8_mbtowc(&uc, name + i, namelen - i);
+		if (nlen < 0) {
+			cmn_err(CE_WARN, "xfs_unicode_validate: "
+					"invalid UTF-8 sequence\n");
+			return -EILSEQ;
+		}
+		/* check for invalid/surrogate/private unicode chars */
+		if (uc >= 0xfffe || (uc >= 0xd800 && uc <= 0xf8ff)) {
+			cmn_err(CE_WARN, "xfs_unicode_validate: "
+					"unsupported UTF-8 char\n");
+			return -EINVAL;
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
+	int		found = 0;
+	int		i, j;
+	xfs_cft_t	*cft;
+	__be16		*duc;
+	__uint16_t	*uc;
+
+	mutex_lock(&cft_lock);
+
+	for (i = 0; i < cft_size; i++) {
+		if (cft_list[i].size != size)
+			continue;
+		cft = cft_list[i].table;
+		if (cft->num_tables != be32_to_cpu(dcft->num_tables) ||
+				cft->flags != be32_to_cpu(dcft->flags))
+			continue;
+		found = 1;
+		for (j = 0; j < cft->num_tables; j++) {
+			if (cft->table_offset[j] !=
+					be32_to_cpu(dcft->table_offset[j])) {
+				found = 0;
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
+	cft = vmalloc(size);
+	if (!cft) {
+		mutex_unlock(&cft_lock);
+		return NULL;
+	}
+	cft->magic = be32_to_cpu(dcft->magic);
+	cft->flags = be32_to_cpu(dcft->flags);
+	cft->num_tables = be32_to_cpu(dcft->num_tables);
+	ASSERT(cft->num_tables <= MAX_FOLD_CHARS);
+	for (i = 0; i < cft->num_tables; i++)
+		cft->table_offset[i] = be32_to_cpu(dcft->table_offset[i]);
+	j = (size - cft->table_offset[0]) / sizeof(__uint16_t);
+	uc = XFS_CFT_PTR(cft, 0);
+	duc = XFS_DCFT_PTR(dcft, 0);
+	for (i = 0; i < j; i++)
+		uc[i] = be16_to_cpu(duc[i]);
+
+	cft_list = kmem_realloc(cft_list,
+			(cft_size + 1) * sizeof(struct cft_item),
+			cft_size  * sizeof(struct cft_item), KM_SLEEP);
+	cft_list[cft_size].table = cft;
+	cft_list[cft_size].size = size;
+	cft_list[cft_size].refcount = 1;
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
+	for (i = 0; i < cft_size; i++) {
+		if (cft_list[i].table == cft) {
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
+	if (mp->m_sb.sb_cftino == NULLFSINO || mp->m_sb.sb_cftino == 0)
+		return EINVAL;
+	error = xfs_iget(mp, NULL, mp->m_sb.sb_cftino, 0, 0, &cftip, 0);
+	if (error)
+		return error;
+	ASSERT(cftip != NULL);
+
+	size = cftip->i_d.di_size;
+	nfsb = cftip->i_d.di_nblocks;
+
+	table = vmalloc(size);
+	if (!table) {
+		xfs_iput(cftip, 0);
+		return ENOMEM;
+	}
+	dcft = (xfs_dcft_t *)table;
+
+	nmap = nfsb;
+	mapp = kmem_alloc(nfsb * sizeof(xfs_bmbt_irec_t), KM_SLEEP);
+
+	error = xfs_bmapi(NULL, cftip, 0, nfsb, 0, NULL, 0, mapp, &nmap,
+			NULL, NULL);
+	if (error)
+		goto out;
+
+	for (n = 0; n < nmap; n++) {
+		byte_cnt = XFS_FSB_TO_B(mp, mapp[n].br_blockcount);
+
+		bp = xfs_buf_read(mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp, mapp[n].br_startblock),
+				BTOBB(byte_cnt), 0);
+		error = XFS_BUF_GETERROR(bp);
+		if (error)
+			goto out;
+
+		if (size < byte_cnt)
+			byte_cnt = size;
+		size -= byte_cnt;
+		memcpy(table, XFS_BUF_PTR(bp), byte_cnt);
+		table += byte_cnt;
+		xfs_buf_relse(bp);
+	}
+
+	mp->m_cft = add_cft(dcft, cftip->i_d.di_size);
+	if (mp->m_cft == NULL)
+		error = ENOMEM;
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
+}
+
+void
+xfs_unicode_uninit(void)
+{
+	int		i;
+
+	mutex_lock(&cft_lock);
+
+	for (i = 0; i < cft_size; i++) {
+		ASSERT(cft_list[i].refcount == 0);
+		vfree(cft_list[i].table);
+	}
+	kmem_free(cft_list, cft_size * sizeof(struct cft_item));
+	cft_size = 0;
+	cft_list = NULL;
+
+	mutex_unlock(&cft_lock);
+}

===========================================================================
fs/xfs/xfs_unicode.h
===========================================================================

--- a/fs/xfs/xfs_unicode.h	2006-06-17 00:58:24.000000000 +1000
+++ b/fs/xfs/xfs_unicode.h	2007-10-23 13:04:32.733676326 +1000
@@ -0,0 +1,75 @@
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
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_UNICODE_H__
+#define	__XFS_UNICODE_H__
+
+#define	XFS_CFT_MAGIC		0x58434654	/* 'XCFT' */
+#define XFS_CFT_FLAG_TURKIC	0x00000001
+
+/*
+ * Case Fold Table - on disk version. Must match the incore version below.
+ */
+typedef struct xfs_dcft {
+	__be32			magic;		/* validity check */
+	__be32			flags;
+	__be32			num_tables;	/* single, double, etc */
+	__be32			table_offset[1];
+} xfs_dcft_t;
+
+/*
+ * Case Fold Table - in core version. Must match the ondisk version above.
+ */
+typedef struct xfs_cft {
+	__uint32_t		magic;
+	__uint32_t		flags;
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
+extern void xfs_unicode_init(void);
+extern void xfs_unicode_uninit(void);
+
+extern __uint32_t xfs_unicode_hash(const xfs_cft_t *cft,
+				const uchar_t *name, int namelen);
+
+extern int xfs_unicode_casecmp(const xfs_cft_t *cft, const uchar_t *name1,
+				int len1, const uchar_t *name2, int len2);
+
+extern int xfs_nls_to_unicode(struct nls_table *nls, const char *nls_name,
+			      int nls_namelen, char *uni_name, int uni_buflen);
+extern int xfs_unicode_to_nls(struct nls_table *nls, const char *uni_name,
+			      int uni_namelen, char *nls_name, int nls_buflen);
+
+extern __uint32_t xfs_nls_hash(struct nls_table *nls, const xfs_cft_t  
*cft,
+				const uchar_t *name, int namelen);
+extern int xfs_nls_casecmp(struct nls_table *nls, const xfs_cft_t *cft,
+				const uchar_t *name1, int len1,
+				const uchar_t *name2, int len2);
+
+extern int xfs_unicode_validate(const uchar_t *name, int namelen);
+
+extern int xfs_unicode_read_cft(struct xfs_mount *mp);
+extern void xfs_unicode_free_cft(const xfs_cft_t *cft);
+
+#endif /* __XFS_UNICODE_H__ */

===========================================================================
fs/xfs/xfs_vfsops.c
===========================================================================

--- a/fs/xfs/xfs_vfsops.c	2007-10-23 17:19:41.000000000 +1000
+++ b/fs/xfs/xfs_vfsops.c	2007-10-23 17:00:14.533732586 +1000
@@ -56,7 +56,7 @@
  #include "xfs_fsops.h"
  #include "xfs_vnodeops.h"
  #include "xfs_vfsops.h"
-
+#include "xfs_unicode.h"

  int
  xfs_init(void)
@@ -86,6 +86,7 @@ xfs_init(void)
  	xfs_acl_zone_init(xfs_acl_zone, "xfs_acl");
  	xfs_mru_cache_init();
  	xfs_filestream_init();
+	xfs_unicode_init();

  	/*
  	 * The size of the zone allocated buf log item is the maximum
@@ -169,6 +170,7 @@ xfs_cleanup(void)
  	xfs_cleanup_procfs();
  	xfs_sysctl_unregister();
  	xfs_refcache_destroy();
+	xfs_unicode_uninit();
  	xfs_filestream_uninit();
  	xfs_mru_cache_uninit();
  	xfs_acl_zone_destroy(xfs_acl_zone);
@@ -258,7 +260,6 @@ xfs_start_flags(
  		mp->m_logname = kmem_alloc(strlen(ap->logname) + 1, KM_SLEEP);
  		strcpy(mp->m_logname, ap->logname);
  	}
-
  	if (ap->flags & XFSMNT_WSYNC)
  		mp->m_flags |= XFS_MOUNT_WSYNC;
  #if XFS_BIG_INUMS
@@ -415,6 +416,37 @@ xfs_finish_flags(
  			mp->m_qflags |= XFS_OQUOTA_ENFD;
  	}

+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		if (ap->flags2 & XFSMNT2_CILOOKUP)
+			mp->m_flags |= XFS_MOUNT_CI_LOOKUP;
+
+		mp->m_nls = ap->nls[0] ? load_nls(ap->nls) : load_nls_default();
+		if (!mp->m_nls) {
+			cmn_err(CE_WARN,
+	"XFS: unable to load nls mapping \"%s\"\n", ap->nls);
+			return XFS_ERROR(EINVAL);
+		}
+		if (strcmp(mp->m_nls->charset, "utf8") == 0) {
+			/* special case utf8 - no translation required */
+			unload_nls(mp->m_nls);
+			mp->m_nls = NULL;
+		}
+	} else {
+		/*
+		 * Check for mount options which require a Unicode FS
+		 */
+		if (ap->flags2 & XFSMNT2_CILOOKUP) {
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

@@ -652,6 +684,8 @@ out:
  		xfs_unmountfs(mp, credp);
  		xfs_qmops_put(mp);
  		xfs_dmops_put(mp);
+		if (mp->m_nls)
+			unload_nls(mp->m_nls);
  		kmem_free(mp, sizeof(xfs_mount_t));
  	}

@@ -1505,6 +1539,9 @@ xfs_vget(
  #define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
  #define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
  #define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
+#define MNTOPT_NLS	"nls"		/* NLS code page to use */
+#define MNTOPT_CILOOKUP	"ci"		/* case-insensitive lookup */
+#define MNTOPT_CIATTR	"ciattr"	/* case-insensitive attrs */
  #define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
  #define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
  #define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
@@ -1699,6 +1736,18 @@ xfs_parseargs(
  			args->flags &= ~XFSMNT_ATTR2;
  		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
  			args->flags2 |= XFSMNT2_FILESTREAMS;
+		} else if (!strcmp(this_char, MNTOPT_NLS)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			strncpy(args->nls, value, MAXNAMELEN);
+		} else if (!strcmp(this_char, MNTOPT_CILOOKUP)) {
+			args->flags2 |= XFSMNT2_CILOOKUP;
+		} else if (!strcmp(this_char, MNTOPT_CIATTR)) {
+			args->flags2 |= XFSMNT2_CIATTR;
  		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
  			args->flags &= ~(XFSMNT_UQUOTAENF|XFSMNT_UQUOTA);
  			args->flags &= ~(XFSMNT_GQUOTAENF|XFSMNT_GQUOTA);

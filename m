Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 410317F86
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 15:53:57 -0500 (CDT)
Date: Thu, 11 Sep 2014 15:53:56 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 03/13] libxfs: add xfs_nameops.normhash
Message-ID: <20140911205356.GL13262@sgi.com>
References: <20140911203735.GA19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140911203735.GA19952@sgi.com>
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
To: xfs@oss.sgi.com
Cc: tinguely@sgi.com, olaf@sgi.com

From: Olaf Weber <olaf@sgi.com>

Add a normhash callout to the xfs_nameops. This callout takes an xfs_da_args
structure as its argument, and calculates a hash value over the name. It may
in the process create a normalized form of the name, and assign that to the
norm/normlen fields in the xfs_da_args structure.

Changes:
 The pointer in kmem_free() was type converted to suppress compiler
 warnings.

Signed-off-by: Olaf Weber <olaf@sgi.com>
---
 include/xfs_da_btree.h |  5 ++++-
 libxfs/xfs_da_btree.c  |  9 ++++++++
 libxfs/xfs_dir2.c      | 56 +++++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 57 insertions(+), 13 deletions(-)

diff --git a/include/xfs_da_btree.h b/include/xfs_da_btree.h
index 3d9f9dd..06b50bf 100644
--- a/include/xfs_da_btree.h
+++ b/include/xfs_da_btree.h
@@ -42,7 +42,9 @@ enum xfs_dacmp {
  */
 typedef struct xfs_da_args {
 	const __uint8_t	*name;		/* string (maybe not NULL terminated) */
-	int		namelen;	/* length of string (maybe no NULL) */
+	const __uint8_t	*norm;		/* normalized name (may be NULL) */
+ 	int		namelen;	/* length of string (maybe no NULL) */
+	int		normlen;	/* length of normalized name */
 	__uint8_t	filetype;	/* filetype of inode for directories */
 	__uint8_t	*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
@@ -131,6 +133,7 @@ typedef struct xfs_da_state {
  */
 struct xfs_nameops {
 	xfs_dahash_t	(*hashname)(struct xfs_name *);
+	int		(*normhash)(struct xfs_da_args *);
 	enum xfs_dacmp	(*compname)(struct xfs_da_args *,
 					const unsigned char *, int);
 };
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index b731b54..eb97317 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2000,8 +2000,17 @@ xfs_default_hashname(
 	return xfs_da_hashname(name->name, name->len);
 }
 
+STATIC int
+xfs_da_normhash(
+	struct xfs_da_args *args)
+{
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return 0;
+}
+
 const struct xfs_nameops xfs_default_nameops = {
 	.hashname	= xfs_default_hashname,
+	.normhash	= xfs_da_normhash,
 	.compname	= xfs_da_compname
 };
 
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 57e98a3..e52d082 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -54,6 +54,21 @@ xfs_ascii_ci_hashname(
 	return hash;
 }
 
+STATIC int
+xfs_ascii_ci_normhash(
+	struct xfs_da_args *args)
+{
+	xfs_dahash_t	hash;
+	int		i;
+
+	for (i = 0, hash = 0; i < args->namelen; i++)
+		hash = tolower(args->name[i]) ^ rol32(hash, 7);
+
+	args->hashval = hash;
+	return 0;
+}
+
+
 STATIC enum xfs_dacmp
 xfs_ascii_ci_compname(
 	struct xfs_da_args *args,
@@ -80,6 +95,7 @@ xfs_ascii_ci_compname(
 
 static struct xfs_nameops xfs_ascii_ci_nameops = {
 	.hashname	= xfs_ascii_ci_hashname,
+	.normhash	= xfs_ascii_ci_normhash,
 	.compname	= xfs_ascii_ci_compname,
 };
 
@@ -211,7 +227,6 @@ xfs_dir_createname(
 	args.name = name->name;
 	args.namelen = name->len;
 	args.filetype = name->type;
-	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = inum;
 	args.dp = dp;
 	args.firstblock = first;
@@ -220,19 +235,24 @@ xfs_dir_createname(
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
 	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	if ((rval = dp->i_mount->m_dirnameops->normhash(&args)))
+		return rval;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_addname(&args);
 	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out_free;
 	else if (v)
 		rval = xfs_dir2_block_addname(&args);
 	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out_free;
 	else if (v)
 		rval = xfs_dir2_leaf_addname(&args);
 	else
 		rval = xfs_dir2_node_addname(&args);
+out_free:
+	if (args.norm)
+		kmem_free((void *)args.norm);
 	return rval;
 }
 
@@ -289,22 +309,23 @@ xfs_dir_lookup(
 	args.name = name->name;
 	args.namelen = name->len;
 	args.filetype = name->type;
-	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
 	args.op_flags = XFS_DA_OP_OKNOENT;
 	if (ci_name)
 		args.op_flags |= XFS_DA_OP_CILOOKUP;
+	if ((rval = dp->i_mount->m_dirnameops->normhash(&args)))
+		return rval;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_lookup(&args);
 	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out_free;
 	else if (v)
 		rval = xfs_dir2_block_lookup(&args);
 	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out_free;
 	else if (v)
 		rval = xfs_dir2_leaf_lookup(&args);
 	else
@@ -318,6 +339,9 @@ xfs_dir_lookup(
 			ci_name->len = args.valuelen;
 		}
 	}
+out_free:
+	if (args.norm)
+		kmem_free((void *)args.norm);
 	return rval;
 }
 
@@ -345,7 +369,6 @@ xfs_dir_removename(
 	args.name = name->name;
 	args.namelen = name->len;
 	args.filetype = name->type;
-	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = ino;
 	args.dp = dp;
 	args.firstblock = first;
@@ -353,19 +376,24 @@ xfs_dir_removename(
 	args.total = total;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
+	if ((rval = dp->i_mount->m_dirnameops->normhash(&args)))
+		return rval;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_removename(&args);
 	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out_free;
 	else if (v)
 		rval = xfs_dir2_block_removename(&args);
 	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out_free;
 	else if (v)
 		rval = xfs_dir2_leaf_removename(&args);
 	else
 		rval = xfs_dir2_node_removename(&args);
+out_free:
+	if (args.norm)
+		kmem_free((void *)args.norm);
 	return rval;
 }
 
@@ -395,7 +423,6 @@ xfs_dir_replace(
 	args.name = name->name;
 	args.namelen = name->len;
 	args.filetype = name->type;
-	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = inum;
 	args.dp = dp;
 	args.firstblock = first;
@@ -403,19 +430,24 @@ xfs_dir_replace(
 	args.total = total;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
+	if ((rval = dp->i_mount->m_dirnameops->normhash(&args)))
+		return rval;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_replace(&args);
 	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
-		return rval;
+		goto out_free;
 	else if (v)
 		rval = xfs_dir2_block_replace(&args);
 	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
-		return rval;
+		goto out_free;
 	else if (v)
 		rval = xfs_dir2_leaf_replace(&args);
 	else
 		rval = xfs_dir2_node_replace(&args);
+out_free:
+	if (args.norm)
+		kmem_free((void *)args.norm);
 	return rval;
 }
 
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

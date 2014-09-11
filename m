Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F05DC7F81
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 15:42:55 -0500 (CDT)
Date: Thu, 11 Sep 2014 15:42:55 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 3/9] xfs: add xfs_nameops.normhash
Message-ID: <20140911204255.GC13262@sgi.com>
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

Signed-off-by: Olaf Weber <olaf@sgi.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |  9 +++++++++
 fs/xfs/libxfs/xfs_da_btree.h |  3 +++
 fs/xfs/libxfs/xfs_dir2.c     | 42 +++++++++++++++++++++++++++++++++++++-----
 3 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 2c42ae2..07a3acf 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1990,8 +1990,17 @@ xfs_default_hashname(
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
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 9ebcc23..6cdafee 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -61,7 +61,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const __uint8_t	*name;		/* string (maybe not NULL terminated) */
+	const __uint8_t	*norm;		/* normalized name (may be NULL) */
 	int		namelen;	/* length of string (maybe no NULL) */
+	int		normlen;	/* length of normalized name */
 	__uint8_t	filetype;	/* filetype of inode for directories */
 	__uint8_t	*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
@@ -150,6 +152,7 @@ typedef struct xfs_da_state {
  */
 struct xfs_nameops {
 	xfs_dahash_t	(*hashname)(struct xfs_name *);
+	int		(*normhash)(struct xfs_da_args *);
 	enum xfs_dacmp	(*compname)(struct xfs_da_args *,
 					const unsigned char *, int);
 };
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 32e769b..55733a6 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -56,6 +56,21 @@ xfs_ascii_ci_hashname(
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
@@ -82,6 +97,7 @@ xfs_ascii_ci_compname(
 
 static struct xfs_nameops xfs_ascii_ci_nameops = {
 	.hashname	= xfs_ascii_ci_hashname,
+	.normhash	= xfs_ascii_ci_normhash,
 	.compname	= xfs_ascii_ci_compname,
 };
 
@@ -267,7 +283,6 @@ xfs_dir_createname(
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
-	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = inum;
 	args->dp = dp;
 	args->firstblock = first;
@@ -276,6 +291,8 @@ xfs_dir_createname(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	if ((rval = dp->i_mount->m_dirnameops->normhash(args)))
+		goto out_free;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_addname(args);
@@ -299,6 +316,8 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	if (args->norm)
+		kmem_free(args->norm);
 	kmem_free(args);
 	return rval;
 }
@@ -365,13 +384,14 @@ xfs_dir_lookup(
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
-	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->dp = dp;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_OKNOENT;
 	if (ci_name)
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
+	if ((rval = dp->i_mount->m_dirnameops->normhash(args)))
+		goto out_free;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_lookup(args);
@@ -405,6 +425,9 @@ out_check_rval:
 		}
 	}
 out_free:
+	if (args->norm)
+		kmem_free(args->norm);
+
 	kmem_free(args);
 	return rval;
 }
@@ -437,7 +460,6 @@ xfs_dir_removename(
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
-	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = ino;
 	args->dp = dp;
 	args->firstblock = first;
@@ -445,6 +467,8 @@ xfs_dir_removename(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	if ((rval = dp->i_mount->m_dirnameops->normhash(args)))
+		goto out_free;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_removename(args);
@@ -467,6 +491,8 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
+	if (args->norm)
+		kmem_free(args->norm);
 	kmem_free(args);
 	return rval;
 }
@@ -502,7 +528,6 @@ xfs_dir_replace(
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
-	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->inumber = inum;
 	args->dp = dp;
 	args->firstblock = first;
@@ -510,6 +535,8 @@ xfs_dir_replace(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	if ((rval = dp->i_mount->m_dirnameops->normhash(args)))
+		goto out_free;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_replace(args);
@@ -532,6 +559,8 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (args->norm)
+		kmem_free(args->norm);
 	kmem_free(args);
 	return rval;
 }
@@ -564,12 +593,13 @@ xfs_dir_canenter(
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
-	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args->dp = dp;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_JUSTCHECK | XFS_DA_OP_ADDNAME |
 							XFS_DA_OP_OKNOENT;
+	if ((rval = dp->i_mount->m_dirnameops->normhash(args)))
+		goto out_free;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_addname(args);
@@ -592,6 +622,8 @@ xfs_dir_canenter(
 	else
 		rval = xfs_dir2_node_addname(args);
 out_free:
+	if (args->norm)
+		kmem_free(args->norm);
 	kmem_free(args);
 	return rval;
 }
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

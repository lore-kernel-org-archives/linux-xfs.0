Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 08E977F53
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 19:58:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8FFD304062
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 17:58:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AEKZGFn6GH67c15Z for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 17:58:37 -0700 (PDT)
Message-ID: <53F695C3.1020607@sandeen.net>
Date: Thu, 21 Aug 2014 19:58:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/4] xfs: combine xfs_dir_canenter into xfs_dir_createname
References: <53F6942B.80808@redhat.com>
In-Reply-To: <53F6942B.80808@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

xfs_dir_canenter and xfs_dir_createname are
almost identical.

Fold the former into the latter, with a helpful
wrapper for the former.  If createname is called without
an inode number, it now only checks for space, and does
not actually add the entry.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index ea84e1c..fdd391f 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -237,7 +237,8 @@ xfs_dir_init(
 }
 
 /*
-  Enter a name in a directory.
+ * Enter a name in a directory.
+ * If inum is 0, only test for available space.
  */
 int
 xfs_dir_createname(
@@ -254,10 +255,12 @@ xfs_dir_createname(
 	int			v;		/* type-checking value */
 
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
-	rval = xfs_dir_ino_validate(tp->t_mountp, inum);
-	if (rval)
-		return rval;
-	XFS_STATS_INC(xs_dir_create);
+	if (inum) {
+		rval = xfs_dir_ino_validate(tp->t_mountp, inum);
+		if (rval)
+			return rval;
+		XFS_STATS_INC(xs_dir_create);
+	}
 
 	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
 	if (!args)
@@ -276,6 +279,8 @@ xfs_dir_createname(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	if (!inum)
+		args->op_flags |= XFS_DA_OP_JUSTCHECK;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_addname(args);
@@ -542,50 +547,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	struct xfs_da_args *args;
-	int		rval;
-	int		v;		/* type-checking value */
-
-	ASSERT(S_ISDIR(dp->i_d.di_mode));
-
-	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
-	if (!args)
-		return -ENOMEM;
-
-	args->geo = dp->i_mount->m_dir_geo;
-	args->name = name->name;
-	args->namelen = name->len;
-	args->filetype = name->type;
-	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
-	args->dp = dp;
-	args->whichfork = XFS_DATA_FORK;
-	args->trans = tp;
-	args->op_flags = XFS_DA_OP_JUSTCHECK | XFS_DA_OP_ADDNAME |
-							XFS_DA_OP_OKNOENT;
-
-	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
-		rval = xfs_dir2_sf_addname(args);
-		goto out_free;
-	}
-
-	rval = xfs_dir2_isblock(args, &v);
-	if (rval)
-		goto out_free;
-	if (v) {
-		rval = xfs_dir2_block_addname(args);
-		goto out_free;
-	}
-
-	rval = xfs_dir2_isleaf(args, &v);
-	if (rval)
-		goto out_free;
-	if (v)
-		rval = xfs_dir2_leaf_addname(args);
-	else
-		rval = xfs_dir2_node_addname(args);
-out_free:
-	kmem_free(args);
-	return rval;
+	return xfs_dir_createname(tp, dp, name, 0, NULL, NULL, 0);
 }
 
 /*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29845 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdFBVZR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 17:25:17 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52LPGcR010339
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:25:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v52LPFHt006508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:25:16 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v52LPFK8028637
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:25:15 GMT
Subject: [PATCH 12/13] xfs: pass along transaction context when reading
 directory block buffers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 14:25:14 -0700
Message-ID: <149643871474.23065.12129624430660182688.stgit@birch.djwong.org>
In-Reply-To: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach the directory reading functions to pass along a transaction context
if one was supplied.  The directory scrub code will use transactions to
lock buffers and avoid deadlocking with itself in the case of loops.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_priv.h |    4 ++--
 fs/xfs/xfs_dir2_readdir.c     |   15 +++++++++++----
 fs/xfs/xfs_file.c             |    2 +-
 3 files changed, 14 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index c09bca1..cb679cf 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -132,7 +132,7 @@ extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
 extern int xfs_dir2_sf_verify(struct xfs_inode *ip);
 
 /* xfs_dir2_readdir.c */
-extern int xfs_readdir(struct xfs_inode *dp, struct dir_context *ctx,
-		       size_t bufsize);
+extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
+		       struct dir_context *ctx, size_t bufsize);
 
 #endif /* __XFS_DIR2_PRIV_H__ */
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index ede4790..ba2638d 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -170,7 +170,7 @@ xfs_dir2_block_getdents(
 		return 0;
 
 	lock_mode = xfs_ilock_data_map_shared(dp);
-	error = xfs_dir3_block_read(NULL, dp, &bp);
+	error = xfs_dir3_block_read(args->trans, dp, &bp);
 	xfs_iunlock(dp, lock_mode);
 	if (error)
 		return error;
@@ -228,7 +228,7 @@ xfs_dir2_block_getdents(
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
 			    be64_to_cpu(dep->inumber),
 			    xfs_dir3_get_dtype(dp->i_mount, filetype))) {
-			xfs_trans_brelse(NULL, bp);
+			xfs_trans_brelse(args->trans, bp);
 			return 0;
 		}
 	}
@@ -239,7 +239,7 @@ xfs_dir2_block_getdents(
 	 */
 	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk + 1, 0) &
 								0x7fffffff;
-	xfs_trans_brelse(NULL, bp);
+	xfs_trans_brelse(args->trans, bp);
 	return 0;
 }
 
@@ -495,15 +495,21 @@ xfs_dir2_leaf_getdents(
 	else
 		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
 	if (bp)
-		xfs_trans_brelse(NULL, bp);
+		xfs_trans_brelse(args->trans, bp);
 	return error;
 }
 
 /*
  * Read a directory.
+ *
+ * If supplied, the transaction collects locked dir buffers to avoid
+ * nested buffer deadlocks.  This function does not dirty the
+ * transaction.  The caller should ensure that the inode is locked
+ * before calling this function.
  */
 int
 xfs_readdir(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	struct dir_context	*ctx,
 	size_t			bufsize)
@@ -522,6 +528,7 @@ xfs_readdir(
 
 	args.dp = dp;
 	args.geo = dp->i_mount->m_dir_geo;
+	args.trans = tp;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_getdents(&args, ctx);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5fb5a09..36c1293 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -950,7 +950,7 @@ xfs_file_readdir(
 	 */
 	bufsize = (size_t)min_t(loff_t, 32768, ip->i_d.di_size);
 
-	return xfs_readdir(ip, ctx, bufsize);
+	return xfs_readdir(NULL, ip, ctx, bufsize);
 }
 
 /*


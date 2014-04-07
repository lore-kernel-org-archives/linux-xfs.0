Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 514E67F93
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E2108F8039
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EjuojFhKYweGUbvb for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 11/19] xfs: remove unused mp arg from xfs_dir2 dataptr/byte
	functions
Date: Mon,  7 Apr 2014 14:58:58 -0500
Message-Id: <1396900746-22201-12-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_da_format.h    |   10 +++++-----
 fs/xfs/xfs_dir2_block.c   |    8 ++++----
 fs/xfs/xfs_dir2_readdir.c |    8 ++++----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_da_format.h b/fs/xfs/xfs_da_format.h
index a19d3f8..1432b57 100644
--- a/fs/xfs/xfs_da_format.h
+++ b/fs/xfs/xfs_da_format.h
@@ -541,7 +541,7 @@ xfs_dir2_leaf_bests_p(struct xfs_dir2_leaf_tail *ltp)
  * Convert dataptr to byte in file space
  */
 static inline xfs_dir2_off_t
-xfs_dir2_dataptr_to_byte(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
+xfs_dir2_dataptr_to_byte(xfs_dir2_dataptr_t dp)
 {
 	return (xfs_dir2_off_t)dp << XFS_DIR2_DATA_ALIGN_LOG;
 }
@@ -550,7 +550,7 @@ xfs_dir2_dataptr_to_byte(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
  * Convert byte in file space to dataptr.  It had better be aligned.
  */
 static inline xfs_dir2_dataptr_t
-xfs_dir2_byte_to_dataptr(struct xfs_mount *mp, xfs_dir2_off_t by)
+xfs_dir2_byte_to_dataptr(xfs_dir2_off_t by)
 {
 	return (xfs_dir2_dataptr_t)(by >> XFS_DIR2_DATA_ALIGN_LOG);
 }
@@ -571,7 +571,7 @@ xfs_dir2_byte_to_db(struct xfs_mount *mp, xfs_dir2_off_t by)
 static inline xfs_dir2_db_t
 xfs_dir2_dataptr_to_db(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
 {
-	return xfs_dir2_byte_to_db(mp, xfs_dir2_dataptr_to_byte(mp, dp));
+	return xfs_dir2_byte_to_db(mp, xfs_dir2_dataptr_to_byte(dp));
 }
 
 /*
@@ -590,7 +590,7 @@ xfs_dir2_byte_to_off(struct xfs_mount *mp, xfs_dir2_off_t by)
 static inline xfs_dir2_data_aoff_t
 xfs_dir2_dataptr_to_off(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
 {
-	return xfs_dir2_byte_to_off(mp, xfs_dir2_dataptr_to_byte(mp, dp));
+	return xfs_dir2_byte_to_off(mp, xfs_dir2_dataptr_to_byte(dp));
 }
 
 /*
@@ -629,7 +629,7 @@ static inline xfs_dir2_dataptr_t
 xfs_dir2_db_off_to_dataptr(struct xfs_mount *mp, xfs_dir2_db_t db,
 			   xfs_dir2_data_aoff_t o)
 {
-	return xfs_dir2_byte_to_dataptr(mp, xfs_dir2_db_off_to_byte(mp, db, o));
+	return xfs_dir2_byte_to_dataptr(xfs_dir2_db_off_to_byte(mp, db, o));
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 90cdbf4..976842e 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -536,7 +536,7 @@ xfs_dir2_block_addname(
 	 * Fill in the leaf entry.
 	 */
 	blp[mid].hashval = cpu_to_be32(args->hashval);
-	blp[mid].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
+	blp[mid].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
 				(char *)dep - (char *)hdr));
 	xfs_dir2_block_log_leaf(tp, bp, lfloglow, lfloghigh);
 	/*
@@ -1169,7 +1169,7 @@ xfs_dir2_sf_to_block(
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, dp, bp, dep);
 	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
-	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
+	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
 				(char *)dep - (char *)hdr));
 	/*
 	 * Create entry for ..
@@ -1183,7 +1183,7 @@ xfs_dir2_sf_to_block(
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, dp, bp, dep);
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
-	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
+	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
 				(char *)dep - (char *)hdr));
 	offset = dp->d_ops->data_first_offset;
 	/*
@@ -1237,7 +1237,7 @@ xfs_dir2_sf_to_block(
 		name.len = sfep->namelen;
 		blp[2 + i].hashval = cpu_to_be32(mp->m_dirnameops->
 							hashname(&name));
-		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
+		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
 						 (char *)dep - (char *)hdr));
 		offset = (int)((char *)(tagp + 1) - (char *)hdr);
 		if (++i == sfp->count)
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index a99967b..50b72f7 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -531,7 +531,7 @@ xfs_dir2_leaf_getdents(
 	 * Inside the loop we keep the main offset value as a byte offset
 	 * in the directory file.
 	 */
-	curoff = xfs_dir2_dataptr_to_byte(mp, ctx->pos);
+	curoff = xfs_dir2_dataptr_to_byte(ctx->pos);
 
 	/*
 	 * Force this conversion through db so we truncate the offset
@@ -635,7 +635,7 @@ xfs_dir2_leaf_getdents(
 		length = dp->d_ops->data_entsize(dep->namelen);
 		filetype = dp->d_ops->data_get_ftype(dep);
 
-		ctx->pos = xfs_dir2_byte_to_dataptr(mp, curoff) & 0x7fffffff;
+		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
 			    be64_to_cpu(dep->inumber),
 			    xfs_dir3_get_dtype(mp, filetype)))
@@ -653,10 +653,10 @@ xfs_dir2_leaf_getdents(
 	/*
 	 * All done.  Set output offset value to current offset.
 	 */
-	if (curoff > xfs_dir2_dataptr_to_byte(mp, XFS_DIR2_MAX_DATAPTR))
+	if (curoff > xfs_dir2_dataptr_to_byte(XFS_DIR2_MAX_DATAPTR))
 		ctx->pos = XFS_DIR2_MAX_DATAPTR & 0x7fffffff;
 	else
-		ctx->pos = xfs_dir2_byte_to_dataptr(mp, curoff) & 0x7fffffff;
+		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
 	kmem_free(map_info);
 	if (bp)
 		xfs_trans_brelse(NULL, bp);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

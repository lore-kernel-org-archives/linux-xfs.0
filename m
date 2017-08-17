Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27045 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753297AbdHQXbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 19:31:45 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7HNVi8I027945
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:31:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7HNVhCo022485
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:31:44 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7HNVhFp007770
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:31:43 GMT
Subject: [PATCH 02/12] xfs: remove XFS_WANT_CORRUPTED_RETURN from dir3 data
 verifiers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 17 Aug 2017 16:31:42 -0700
Message-ID: <150301270211.5851.13466252563036652049.stgit@magnolia>
In-Reply-To: <150301268960.5851.2513223883233763065.stgit@magnolia>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Since __xfs_dir3_data_check verifies on-disk metadata, we can't have it
noisily blowing asserts and hanging the system on corrupt data coming in
off the disk.  Instead, have it return a boolean like all the other
checker functions, and only have it noisily fail if we fail in debug
mode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_block.c |    4 --
 fs/xfs/libxfs/xfs_dir2_data.c  |  100 +++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_dir2_priv.h  |   10 +++-
 3 files changed, 61 insertions(+), 53 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 43c902f..e427249 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -78,9 +78,7 @@ xfs_dir3_block_verify(
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
 			return false;
 	}
-	if (__xfs_dir3_data_check(NULL, bp))
-		return false;
-	return true;
+	return __xfs_dir3_data_check(NULL, bp);
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 8727a43..af15f705 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -36,9 +36,9 @@
 /*
  * Check the consistency of the data block.
  * The input can also be a block-format directory.
- * Return 0 is the buffer is good, otherwise an error.
+ * Return true if the buffer is good.
  */
-int
+bool
 __xfs_dir3_data_check(
 	struct xfs_inode	*dp,		/* incore inode pointer */
 	struct xfs_buf		*bp)		/* data block's buffer */
@@ -90,16 +90,16 @@ __xfs_dir3_data_check(
 		 * so just ensure that the count falls somewhere inside the
 		 * block right now.
 		 */
-		XFS_WANT_CORRUPTED_RETURN(mp, be32_to_cpu(btp->count) <
-			((char *)btp - p) / sizeof(struct xfs_dir2_leaf_entry));
+		if (be32_to_cpu(btp->count) >=
+		    ((char *)btp - p) / sizeof(struct xfs_dir2_leaf_entry))
+			return false;
 		break;
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
 		endp = (char *)hdr + geo->blksize;
 		break;
 	default:
-		XFS_ERROR_REPORT("Bad Magic", XFS_ERRLEVEL_LOW, mp);
-		return -EFSCORRUPTED;
+		return false;
 	}
 
 	/*
@@ -108,22 +108,25 @@ __xfs_dir3_data_check(
 	bf = ops->data_bestfree_p(hdr);
 	count = lastfree = freeseen = 0;
 	if (!bf[0].length) {
-		XFS_WANT_CORRUPTED_RETURN(mp, !bf[0].offset);
+		if (bf[0].offset)
+			return false;
 		freeseen |= 1 << 0;
 	}
 	if (!bf[1].length) {
-		XFS_WANT_CORRUPTED_RETURN(mp, !bf[1].offset);
+		if (bf[1].offset)
+			return false;
 		freeseen |= 1 << 1;
 	}
 	if (!bf[2].length) {
-		XFS_WANT_CORRUPTED_RETURN(mp, !bf[2].offset);
+		if (bf[2].offset)
+			return false;
 		freeseen |= 1 << 2;
 	}
 
-	XFS_WANT_CORRUPTED_RETURN(mp, be16_to_cpu(bf[0].length) >=
-						be16_to_cpu(bf[1].length));
-	XFS_WANT_CORRUPTED_RETURN(mp, be16_to_cpu(bf[1].length) >=
-						be16_to_cpu(bf[2].length));
+	if (be16_to_cpu(bf[0].length) < be16_to_cpu(bf[1].length))
+		return false;
+	if (be16_to_cpu(bf[1].length) < be16_to_cpu(bf[2].length))
+		return false;
 	/*
 	 * Loop over the data/unused entries.
 	 */
@@ -135,22 +138,23 @@ __xfs_dir3_data_check(
 		 * doesn't need to be there.
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			XFS_WANT_CORRUPTED_RETURN(mp, lastfree == 0);
-			XFS_WANT_CORRUPTED_RETURN(mp, endp >=
-					p + be16_to_cpu(dup->length));
-			XFS_WANT_CORRUPTED_RETURN(mp,
-				be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) ==
-					       (char *)dup - (char *)hdr);
+			if (lastfree != 0)
+				return false;
+			if (endp < p + be16_to_cpu(dup->length))
+				return false;
+			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
+			    (char *)dup - (char *)hdr)
+				return false;
 			dfp = xfs_dir2_data_freefind(hdr, bf, dup);
 			if (dfp) {
 				i = (int)(dfp - bf);
-				XFS_WANT_CORRUPTED_RETURN(mp,
-					(freeseen & (1 << i)) == 0);
+				if ((freeseen & (1 << i)) != 0)
+					return false;
 				freeseen |= 1 << i;
 			} else {
-				XFS_WANT_CORRUPTED_RETURN(mp,
-					be16_to_cpu(dup->length) <=
-						be16_to_cpu(bf[2].length));
+				if (be16_to_cpu(dup->length) >
+				    be16_to_cpu(bf[2].length))
+					return false;
 			}
 			p += be16_to_cpu(dup->length);
 			lastfree = 1;
@@ -163,16 +167,17 @@ __xfs_dir3_data_check(
 		 * The linear search is crude but this is DEBUG code.
 		 */
 		dep = (xfs_dir2_data_entry_t *)p;
-		XFS_WANT_CORRUPTED_RETURN(mp, dep->namelen != 0);
-		XFS_WANT_CORRUPTED_RETURN(mp,
-			!xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)));
-		XFS_WANT_CORRUPTED_RETURN(mp, endp >=
-				p + ops->data_entsize(dep->namelen));
-		XFS_WANT_CORRUPTED_RETURN(mp,
-			be16_to_cpu(*ops->data_entry_tag_p(dep)) ==
-					       (char *)dep - (char *)hdr);
-		XFS_WANT_CORRUPTED_RETURN(mp,
-				ops->data_get_ftype(dep) < XFS_DIR3_FT_MAX);
+		if (dep->namelen == 0)
+			return false;
+		if (xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)))
+			return false;
+		if (endp < p + ops->data_entsize(dep->namelen))
+			return false;
+		if (be16_to_cpu(*ops->data_entry_tag_p(dep)) !=
+		    (char *)dep - (char *)hdr)
+			return false;
+		if (ops->data_get_ftype(dep) >= XFS_DIR3_FT_MAX)
+			return false;
 		count++;
 		lastfree = 0;
 		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
@@ -188,31 +193,32 @@ __xfs_dir3_data_check(
 				    be32_to_cpu(lep[i].hashval) == hash)
 					break;
 			}
-			XFS_WANT_CORRUPTED_RETURN(mp,
-						  i < be32_to_cpu(btp->count));
+			if (i >= be32_to_cpu(btp->count))
+				return false;
 		}
 		p += ops->data_entsize(dep->namelen);
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
 	 */
-	XFS_WANT_CORRUPTED_RETURN(mp, freeseen == 7);
+	if (freeseen != 7)
+		return false;
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
 		for (i = stale = 0; i < be32_to_cpu(btp->count); i++) {
 			if (lep[i].address ==
 			    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 				stale++;
-			if (i > 0)
-				XFS_WANT_CORRUPTED_RETURN(mp,
-					be32_to_cpu(lep[i].hashval) >=
-						be32_to_cpu(lep[i - 1].hashval));
+			if (i > 0 && be32_to_cpu(lep[i].hashval) <
+				     be32_to_cpu(lep[i - 1].hashval))
+				return false;
 		}
-		XFS_WANT_CORRUPTED_RETURN(mp, count ==
-			be32_to_cpu(btp->count) - be32_to_cpu(btp->stale));
-		XFS_WANT_CORRUPTED_RETURN(mp, stale == be32_to_cpu(btp->stale));
+		if (count != be32_to_cpu(btp->count) - be32_to_cpu(btp->stale))
+			return false;
+		if (stale != be32_to_cpu(btp->stale))
+			return false;
 	}
-	return 0;
+	return true;
 }
 
 static bool
@@ -235,9 +241,7 @@ xfs_dir3_data_verify(
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC))
 			return false;
 	}
-	if (__xfs_dir3_data_check(NULL, bp))
-		return false;
-	return true;
+	return __xfs_dir3_data_check(NULL, bp);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 4badd26..45c68d0 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -39,12 +39,18 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 
 /* xfs_dir2_data.c */
 #ifdef DEBUG
-#define	xfs_dir3_data_check(dp,bp) __xfs_dir3_data_check(dp, bp);
+#define	xfs_dir3_data_check(dp, bp) \
+do { \
+	if (!__xfs_dir3_data_check((dp), (bp))) { \
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, \
+				(bp)->b_target->bt_mount, (bp)->b_addr); \
+	} \
+} while (0)
 #else
 #define	xfs_dir3_data_check(dp,bp)
 #endif
 
-extern int __xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
+extern bool __xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
 extern int xfs_dir3_data_readahead(struct xfs_inode *dp, xfs_dablk_t bno,


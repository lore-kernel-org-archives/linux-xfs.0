Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E820376F2
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591448; cv=none; b=aL0rOTjyUoilU6NGnDddw0XOT3kk3FZSP1B64sHYFQz5I0cryCYTjsaDN5jSniJz5SCa3XJpac0xx9Tvgb1naNYibsD6CBvpot1kSe2lXtJJeFiz92U/LPc5o/Vzum3oo5EsNrNJEufZgTjiTQu88wblV337us/BnXs56+59P0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591448; c=relaxed/simple;
	bh=1icw28T2O99t1TA5dY89EmMVhxlXItY3zLdUVTQsr3k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VMyenOZ+iCUsMRLjysDvk+j/KO8xS5eUduVXMsA4sod3aD8nBi84jyQaqhUHiHvr1gheNuwdxl5JSu7GFYHAoc/LAlTI4zSZ7RDcOOvCMIgrM7bEPOaIzCJi6d5f89oVMJPfux2FM72kY+c1maIM2LGci7LEtX42rFogU64Pd1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLOBTDBf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLOBTDBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D8DC433F1;
	Tue, 30 Jan 2024 05:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591448;
	bh=1icw28T2O99t1TA5dY89EmMVhxlXItY3zLdUVTQsr3k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BLOBTDBf3dmgkwPwlT5pFu4qsrw1Y4lFJdLc1MNm6GRlj/Ceu1YZpXayGJ5qKI8LS
	 KJEZH+jFk5rgvFWHigj8Lg6WZiBqFI+gfpEpZfe98jI5v1RMmsBIulHkIfeLMohV+S
	 fYrqWSoP/S9YDYbsIMldHnQ5jNYc6lR87AMi/5AyRxjpjrF9k+R/HkFm+zxhK2B5Rd
	 uyB2kZGZB3qJelwv1MC4ErQsmOpTU8MURfIpIIt1VTufRBpMFXohcNEzQK88KteZts
	 laEBLKDm3awphIfcH0aMz1s6oHSSaGFchkGUXEkHXoM+86SOa2uZQ+OMHIo/YWmb4Z
	 m5WPuy9eu32jg==
Date: Mon, 29 Jan 2024 21:10:47 -0800
Subject: [PATCH 06/11] xfs: report dir/attr block corruption errors to the
 health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063825.3353909.17642030683619753394.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
References: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Whenever we encounter corrupt directory or extended attribute blocks, we
should report that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c   |    4 ++++
 fs/xfs/libxfs/xfs_attr_remote.c |   27 ++++++++++++++++-----------
 fs/xfs/libxfs/xfs_da_btree.c    |   37 ++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2.c        |    5 ++++-
 fs/xfs/libxfs/xfs_dir2_block.c  |    2 ++
 fs/xfs/libxfs/xfs_dir2_data.c   |    3 +++
 fs/xfs/libxfs/xfs_dir2_leaf.c   |    3 +++
 fs/xfs/libxfs/xfs_dir2_node.c   |    7 +++++++
 fs/xfs/libxfs/xfs_health.h      |    3 +++
 fs/xfs/xfs_attr_inactive.c      |    4 ++++
 fs/xfs/xfs_attr_list.c          |    9 ++++++++-
 fs/xfs/xfs_health.c             |   39 +++++++++++++++++++++++++++++++++++++++
 12 files changed, 125 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6374bf1072420..eb90753e183dd 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -29,6 +29,7 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_errortag.h"
+#include "xfs_health.h"
 
 
 /*
@@ -2343,6 +2344,7 @@ xfs_attr3_leaf_lookup_int(
 	entries = xfs_attr3_leaf_entryp(leaf);
 	if (ichdr.count >= args->geo->blksize / 8) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -2362,10 +2364,12 @@ xfs_attr3_leaf_lookup_int(
 	}
 	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count))) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval)) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d440393b40eb8..b18a3cf44192e 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -22,6 +22,7 @@
 #include "xfs_attr_remote.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
@@ -276,17 +277,18 @@ xfs_attr3_rmt_hdr_set(
  */
 STATIC int
 xfs_attr_rmtval_copyout(
-	struct xfs_mount *mp,
-	struct xfs_buf	*bp,
-	xfs_ino_t	ino,
-	int		*offset,
-	int		*valuelen,
-	uint8_t		**dst)
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	struct xfs_inode	*dp,
+	int			*offset,
+	int			*valuelen,
+	uint8_t			**dst)
 {
-	char		*src = bp->b_addr;
-	xfs_daddr_t	bno = xfs_buf_daddr(bp);
-	int		len = BBTOB(bp->b_length);
-	int		blksize = mp->m_attr_geo->blksize;
+	char			*src = bp->b_addr;
+	xfs_ino_t		ino = dp->i_ino;
+	xfs_daddr_t		bno = xfs_buf_daddr(bp);
+	int			len = BBTOB(bp->b_length);
+	int			blksize = mp->m_attr_geo->blksize;
 
 	ASSERT(len >= blksize);
 
@@ -302,6 +304,7 @@ xfs_attr_rmtval_copyout(
 				xfs_alert(mp,
 "remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)",
 					bno, *offset, byte_cnt, ino);
+				xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 				return -EFSCORRUPTED;
 			}
 			hdr_size = sizeof(struct xfs_attr3_rmt_hdr);
@@ -418,10 +421,12 @@ xfs_attr_rmtval_get(
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
 					0, &bp, &xfs_attr3_rmt_buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_dirattr_mark_sick(args->dp, XFS_ATTR_FORK);
 			if (error)
 				return error;
 
-			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
+			error = xfs_attr_rmtval_copyout(mp, bp, args->dp,
 							&offset, &valuelen,
 							&dst);
 			xfs_buf_relse(bp);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 5457188bb4deb..21fb8aff40df7 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -23,6 +23,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 #include "xfs_errortag.h"
+#include "xfs_health.h"
 
 /*
  * xfs_da_btree.c
@@ -352,6 +353,8 @@ const struct xfs_buf_ops xfs_da3_node_buf_ops = {
 static int
 xfs_da3_node_set_type(
 	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	int			whichfork,
 	struct xfs_buf		*bp)
 {
 	struct xfs_da_blkinfo	*info = bp->b_addr;
@@ -373,6 +376,7 @@ xfs_da3_node_set_type(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp,
 				info, sizeof(*info));
 		xfs_trans_brelse(tp, bp);
+		xfs_dirattr_mark_sick(dp, whichfork);
 		return -EFSCORRUPTED;
 	}
 }
@@ -391,7 +395,7 @@ xfs_da3_node_read(
 			&xfs_da3_node_buf_ops);
 	if (error || !*bpp || !tp)
 		return error;
-	return xfs_da3_node_set_type(tp, *bpp);
+	return xfs_da3_node_set_type(tp, dp, whichfork, *bpp);
 }
 
 int
@@ -408,6 +412,8 @@ xfs_da3_node_read_mapped(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, mappedbno,
 			XFS_FSB_TO_BB(mp, xfs_dabuf_nfsb(mp, whichfork)), 0,
 			bpp, &xfs_da3_node_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_dirattr_mark_sick(dp, whichfork);
 	if (error || !*bpp)
 		return error;
 
@@ -418,7 +424,7 @@ xfs_da3_node_read_mapped(
 
 	if (!tp)
 		return 0;
-	return xfs_da3_node_set_type(tp, *bpp);
+	return xfs_da3_node_set_type(tp, dp, whichfork, *bpp);
 }
 
 /*
@@ -631,6 +637,7 @@ xfs_da3_split(
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
 			xfs_buf_mark_corrupt(oldblk->bp);
+			xfs_da_mark_sick(state->args);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -644,6 +651,7 @@ xfs_da3_split(
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
 			xfs_buf_mark_corrupt(oldblk->bp);
+			xfs_da_mark_sick(state->args);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1635,6 +1643,7 @@ xfs_da3_node_lookup_int(
 
 		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
 			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
@@ -1650,6 +1659,7 @@ xfs_da3_node_lookup_int(
 		/* Tree taller than we can handle; bail out! */
 		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
 			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
@@ -1658,6 +1668,7 @@ xfs_da3_node_lookup_int(
 			expected_level = nodehdr.level - 1;
 		else if (expected_level != nodehdr.level) {
 			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		} else
 			expected_level--;
@@ -1709,12 +1720,16 @@ xfs_da3_node_lookup_int(
 		}
 
 		/* We can't point back to the root. */
-		if (XFS_IS_CORRUPT(dp->i_mount, blkno == args->geo->leafblk))
+		if (XFS_IS_CORRUPT(dp->i_mount, blkno == args->geo->leafblk)) {
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
+		}
 	}
 
-	if (XFS_IS_CORRUPT(dp->i_mount, expected_level != 0))
+	if (XFS_IS_CORRUPT(dp->i_mount, expected_level != 0)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * A leaf block that ends in the hashval that we are interested in
@@ -1732,6 +1747,7 @@ xfs_da3_node_lookup_int(
 			args->blkno = blk->blkno;
 		} else {
 			ASSERT(0);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 		if (((retval == -ENOENT) || (retval == -ENOATTR)) &&
@@ -2297,8 +2313,10 @@ xfs_da3_swap_lastblock(
 	error = xfs_bmap_last_before(tp, dp, &lastoff, w);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(mp, lastoff == 0))
+	if (XFS_IS_CORRUPT(mp, lastoff == 0)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
+	}
 	/*
 	 * Read the last block in the btree space.
 	 */
@@ -2348,6 +2366,7 @@ xfs_da3_swap_lastblock(
 		if (XFS_IS_CORRUPT(mp,
 				   be32_to_cpu(sib_info->forw) != last_blkno ||
 				   sib_info->magic != dead_info->magic)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2368,6 +2387,7 @@ xfs_da3_swap_lastblock(
 		if (XFS_IS_CORRUPT(mp,
 				   be32_to_cpu(sib_info->back) != last_blkno ||
 				   sib_info->magic != dead_info->magic)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2390,6 +2410,7 @@ xfs_da3_swap_lastblock(
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
 		if (XFS_IS_CORRUPT(mp,
 				   level >= 0 && level != par_hdr.level + 1)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2401,6 +2422,7 @@ xfs_da3_swap_lastblock(
 		     entno++)
 			continue;
 		if (XFS_IS_CORRUPT(mp, entno == par_hdr.count)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2426,6 +2448,7 @@ xfs_da3_swap_lastblock(
 		xfs_trans_brelse(tp, par_buf);
 		par_buf = NULL;
 		if (XFS_IS_CORRUPT(mp, par_blkno == 0)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2435,6 +2458,7 @@ xfs_da3_swap_lastblock(
 		par_node = par_buf->b_addr;
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
 		if (XFS_IS_CORRUPT(mp, par_hdr.level != level)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2563,6 +2587,7 @@ xfs_dabuf_map(
 invalid_mapping:
 	/* Caller ok with no mapping. */
 	if (XFS_IS_CORRUPT(mp, !(flags & XFS_DABUF_MAP_HOLE_OK))) {
+		xfs_dirattr_mark_sick(dp, whichfork);
 		error = -EFSCORRUPTED;
 		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
 			xfs_alert(mp, "%s: bno %u inode %llu",
@@ -2644,6 +2669,8 @@ xfs_da_read_buf(
 
 	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
 			&bp, ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_dirattr_mark_sick(dp, whichfork);
 	if (error)
 		goto out_free;
 
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 86b751d9504df..847449ce3017b 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -18,6 +18,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_health.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -632,8 +633,10 @@ xfs_dir2_isblock(
 		return 0;
 
 	*isblock = true;
-	if (XFS_IS_CORRUPT(mp, args->dp->i_disk_size != args->geo->blksize))
+	if (XFS_IS_CORRUPT(mp, args->dp->i_disk_size != args->geo->blksize)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
+	}
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 3c256d4cc40b4..ba9fce415faf9 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -20,6 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 /*
  * Local function prototypes.
@@ -152,6 +153,7 @@ xfs_dir3_block_read(
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		*bpp = NULL;
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index dbcf58979a598..7a6d965bea71b 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
@@ -433,6 +434,7 @@ xfs_dir3_data_read(
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		*bpp = NULL;
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 		return -EFSCORRUPTED;
 	}
 
@@ -1198,6 +1200,7 @@ xfs_dir2_data_use_free(
 corrupt:
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount,
 			hdr, sizeof(*hdr), __FILE__, __LINE__, fa);
+	xfs_da_mark_sick(args);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index cb9e950a911d8..08dda5ce9d91c 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -19,6 +19,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_health.h"
 
 /*
  * Local function declarations.
@@ -1393,8 +1394,10 @@ xfs_dir2_leaf_removename(
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	if (be16_to_cpu(bestsp[db]) != oldbest) {
 		xfs_buf_mark_corrupt(lbp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
+
 	/*
 	 * Mark the former data entry unused.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7a03aeb9f4c91..be0b8834028c0 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -20,6 +20,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 /*
  * Function declarations.
@@ -231,6 +232,7 @@ __xfs_dir3_free_read(
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		*bpp = NULL;
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 		return -EFSCORRUPTED;
 	}
 
@@ -443,6 +445,7 @@ xfs_dir2_leaf_to_node(
 	if (be32_to_cpu(ltp->bestcount) >
 				(uint)dp->i_disk_size / args->geo->blksize) {
 		xfs_buf_mark_corrupt(lbp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -517,6 +520,7 @@ xfs_dir2_leafn_add(
 	 */
 	if (index < 0) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -736,6 +740,7 @@ xfs_dir2_leafn_lookup_for_addname(
 					   cpu_to_be16(NULLDATAOFF))) {
 				if (curfdb != newfdb)
 					xfs_trans_brelse(tp, curbp);
+				xfs_da_mark_sick(args);
 				return -EFSCORRUPTED;
 			}
 			curfdb = newfdb;
@@ -804,6 +809,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	xfs_dir3_leaf_check(dp, bp);
 	if (leafhdr.count <= 0) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -1739,6 +1745,7 @@ xfs_dir2_node_add_datablk(
 			} else {
 				xfs_alert(mp, " ... fblk is NULL");
 			}
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 0876c767d9ddc..a5b346b377cbb 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -38,6 +38,7 @@ struct xfs_perag;
 struct xfs_inode;
 struct xfs_fsop_geom;
 struct xfs_btree_cur;
+struct xfs_da_args;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -155,6 +156,8 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 void xfs_health_unmount(struct xfs_mount *mp);
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
 void xfs_btree_mark_sick(struct xfs_btree_cur *cur);
+void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork);
+void xfs_da_mark_sick(struct xfs_da_args *args);
 
 /* Now some helpers. */
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 89c7a9f4f9305..24fb12986a568 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -23,6 +23,7 @@
 #include "xfs_quota.h"
 #include "xfs_dir2.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * Invalidate any incore buffers associated with this remote attribute value
@@ -147,6 +148,7 @@ xfs_attr3_node_inactive(
 	if (level > XFS_DA_NODE_MAXDEPTH) {
 		xfs_buf_mark_corrupt(bp);
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
+		xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 		return -EFSCORRUPTED;
 	}
 
@@ -197,6 +199,7 @@ xfs_attr3_node_inactive(
 		default:
 			xfs_buf_mark_corrupt(child_bp);
 			xfs_trans_brelse(*trans, child_bp);
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			error = -EFSCORRUPTED;
 			break;
 		}
@@ -286,6 +289,7 @@ xfs_attr3_root_inactive(
 		error = xfs_attr3_leaf_inactive(trans, dp, bp);
 		break;
 	default:
+		xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 		error = -EFSCORRUPTED;
 		xfs_buf_mark_corrupt(bp);
 		xfs_trans_brelse(*trans, bp);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index e368ad671e261..453b15ec33df3 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -22,6 +22,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_dir2.h"
+#include "xfs_health.h"
 
 STATIC int
 xfs_attr_shortform_compare(const void *a, const void *b)
@@ -125,6 +126,7 @@ xfs_attr_shortform_list(
 					     context->dp->i_mount, sfe,
 					     sizeof(*sfe));
 			kmem_free(sbuf);
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
 		}
 
@@ -262,8 +264,10 @@ xfs_attr_node_list_lookup(
 			return 0;
 
 		/* We can't point back to the root. */
-		if (XFS_IS_CORRUPT(mp, cursor->blkno == 0))
+		if (XFS_IS_CORRUPT(mp, cursor->blkno == 0)) {
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	if (expected_level != 0)
@@ -275,6 +279,7 @@ xfs_attr_node_list_lookup(
 out_corruptbuf:
 	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(tp, bp);
+	xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 	return -EFSCORRUPTED;
 }
 
@@ -304,6 +309,8 @@ xfs_attr_node_list(
 	if (cursor->blkno > 0) {
 		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, &bp,
 				XFS_ATTR_FORK);
+		if (xfs_metadata_is_sick(error))
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 		if ((error != 0) && (error != -EFSCORRUPTED))
 			return error;
 		if (bp) {
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 27a27e27a2316..7c5e132609011 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -15,6 +15,8 @@
 #include "xfs_health.h"
 #include "xfs_ag.h"
 #include "xfs_btree.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 
 /*
  * Warn about metadata corruption that we detected but haven't fixed, and
@@ -529,3 +531,40 @@ xfs_btree_mark_sick(
 
 	xfs_ag_mark_sick(cur->bc_ag.pag, mask);
 }
+
+/*
+ * Record observations of dir/attr btree corruption with the health tracking
+ * system.
+ */
+void
+xfs_dirattr_mark_sick(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	unsigned int		mask;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		mask = XFS_SICK_INO_DIR;
+		break;
+	case XFS_ATTR_FORK:
+		mask = XFS_SICK_INO_XATTR;
+		break;
+	default:
+		ASSERT(0);
+		return;
+	}
+
+	xfs_inode_mark_sick(ip, mask);
+}
+
+/*
+ * Record observations of dir/attr btree corruption with the health tracking
+ * system.
+ */
+void
+xfs_da_mark_sick(
+	struct xfs_da_args	*args)
+{
+	xfs_dirattr_mark_sick(args->dp, args->whichfork);
+}


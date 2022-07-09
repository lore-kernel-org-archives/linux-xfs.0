Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0B2C43334
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jul 2022 22:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiGIWtM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jul 2022 18:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGIWtL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jul 2022 18:49:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B922013E9C
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 15:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D43FB80815
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 22:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F17C3411C;
        Sat,  9 Jul 2022 22:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657406945;
        bh=2M3AmMMhHoodJMuTDoFTCwKsvKpbBamLqvldiXp70AA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EQl5P6Gj3stONSv3MbBtHjCu+eRK/RZqAiFAW4fBxdK2p9QSVYUQ5S0yCDOqSURoo
         3DRnmUAgmiCwboSK18XbX5RFOjHChOAENWeZUjbEx9snNLATo4v2CwLfe9LSPyFk85
         sU/m34rAhcsJsAzLDBmRB0CEVn6TN7+y3sdpDELjNNl8fnfZCrYLyxzFcStS1ghr1M
         Ik6BrsZQp/sENj6wPkUrSgJ7M5ELUlz/Q/dCvkcNdpBO0HSRGb4eGLtIxJrqxdJpW4
         7sfUCDVxn3jwk3AL0XXKjH1qoL7kRwqyA169wja8l3F3P7uPJB59Vy2ixcM/C7DGi1
         sZrIDTpR0Ib3Q==
Subject: [PATCH 5/5] xfs: replace inode fork size macros with functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Date:   Sat, 09 Jul 2022 15:49:04 -0700
Message-ID: <165740694457.73293.2995121699967809910.stgit@magnolia>
In-Reply-To: <165740691606.73293.12753862498202082021.stgit@magnolia>
References: <165740691606.73293.12753862498202082021.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace the shouty macros here with typechecked helper functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |    2 +-
 fs/xfs/libxfs/xfs_bmap.c       |    6 +++---
 fs/xfs/libxfs/xfs_bmap_btree.c |    2 +-
 fs/xfs/libxfs/xfs_dir2.c       |    2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |    4 ++--
 fs/xfs/libxfs/xfs_dir2_sf.c    |    6 +++---
 fs/xfs/libxfs/xfs_inode_fork.c |   10 +++++-----
 fs/xfs/libxfs/xfs_inode_fork.h |   15 +--------------
 fs/xfs/scrub/symlink.c         |    4 ++--
 fs/xfs/xfs_bmap_util.c         |    4 ++--
 fs/xfs/xfs_inode.h             |   35 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode_item.c        |    4 ++--
 fs/xfs/xfs_itable.c            |    2 +-
 fs/xfs/xfs_symlink.c           |    2 +-
 fs/xfs/xfs_trace.h             |    2 +-
 15 files changed, 61 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 435c6cc485bf..5bd554b88d99 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -590,7 +590,7 @@ xfs_attr_shortform_bytesfit(
 	 * to real extents, or the delalloc conversion will take care of the
 	 * literal area rebalancing.
 	 */
-	if (bytes <= XFS_IFORK_ASIZE(dp))
+	if (bytes <= xfs_inode_attr_fork_size(dp))
 		return dp->i_forkoff;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e5108df54f5a..e56723dc9cd5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -880,7 +880,7 @@ xfs_bmap_add_attrfork_btree(
 
 	mp = ip->i_mount;
 
-	if (XFS_BMAP_BMDR_SPACE(block) <= XFS_IFORK_DSIZE(ip))
+	if (XFS_BMAP_BMDR_SPACE(block) <= xfs_inode_data_fork_size(ip))
 		*flags |= XFS_ILOG_DBROOT;
 	else {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
@@ -920,7 +920,7 @@ xfs_bmap_add_attrfork_extents(
 	int			error;		/* error return value */
 
 	if (ip->i_df.if_nextents * sizeof(struct xfs_bmbt_rec) <=
-	    XFS_IFORK_DSIZE(ip))
+	    xfs_inode_data_fork_size(ip))
 		return 0;
 	cur = NULL;
 	error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0, flags,
@@ -951,7 +951,7 @@ xfs_bmap_add_attrfork_local(
 {
 	struct xfs_da_args	dargs;		/* args for dir/attr code */
 
-	if (ip->i_df.if_bytes <= XFS_IFORK_DSIZE(ip))
+	if (ip->i_df.if_bytes <= xfs_inode_data_fork_size(ip))
 		return 0;
 
 	if (S_ISDIR(VFS_I(ip)->i_mode)) {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 986ffca7f74d..cfa052d40105 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -564,7 +564,7 @@ xfs_bmbt_init_cursor(
 	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_ino.forksize = XFS_IFORK_SIZE(ip, whichfork);
+	cur->bc_ino.forksize = xfs_inode_fork_size(ip, whichfork);
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
 	cur->bc_ino.flags = 0;
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 3cd51fa3837b..76eedc2756b3 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -193,7 +193,7 @@ xfs_dir_isempty(
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	if (dp->i_disk_size == 0)	/* might happen during shutdown. */
 		return 1;
-	if (dp->i_disk_size > XFS_IFORK_DSIZE(dp))
+	if (dp->i_disk_size > xfs_inode_data_fork_size(dp))
 		return 0;
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	return !sfp->count;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index f5e45aa28c91..00f960a703b2 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -842,7 +842,7 @@ xfs_dir2_block_removename(
 	 * See if the size as a shortform is good enough.
 	 */
 	size = xfs_dir2_block_sfsize(dp, hdr, &sfh);
-	if (size > XFS_IFORK_DSIZE(dp))
+	if (size > xfs_inode_data_fork_size(dp))
 		return 0;
 
 	/*
@@ -1055,7 +1055,7 @@ xfs_dir2_leaf_to_block(
 	 * Now see if the resulting block can be shrunken to shortform.
 	 */
 	size = xfs_dir2_block_sfsize(dp, hdr, &sfh);
-	if (size > XFS_IFORK_DSIZE(dp))
+	if (size > xfs_inode_data_fork_size(dp))
 		return 0;
 
 	return xfs_dir2_block_to_sf(args, dbp, size, &sfh);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index a41e2624e115..003812fd7d35 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -237,7 +237,7 @@ xfs_dir2_block_sfsize(
 		       (i8count ?			/* inumber */
 				count * XFS_INO64_SIZE :
 				count * XFS_INO32_SIZE);
-		if (size > XFS_IFORK_DSIZE(dp))
+		if (size > xfs_inode_data_fork_size(dp))
 			return size;		/* size value is a failure */
 	}
 	/*
@@ -406,7 +406,7 @@ xfs_dir2_sf_addname(
 	 * Won't fit as shortform any more (due to size),
 	 * or the pick routine says it won't (due to offset values).
 	 */
-	if (new_isize > XFS_IFORK_DSIZE(dp) ||
+	if (new_isize > xfs_inode_data_fork_size(dp) ||
 	    (pick =
 	     xfs_dir2_sf_addname_pick(args, objchange, &sfep, &offset)) == 0) {
 		/*
@@ -1031,7 +1031,7 @@ xfs_dir2_sf_replace_needblock(
 	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
 
 	return inum > XFS_DIR2_MAX_SHORT_INUM &&
-	       sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp);
+	       sfp->i8count == 0 && newsize > xfs_inode_data_fork_size(dp);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index b3ba97242e71..7c34184448e6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -407,7 +407,7 @@ xfs_iroot_realloc(
 						     (int)new_size);
 		ifp->if_broot_bytes = (int)new_size;
 		ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
-			XFS_IFORK_SIZE(ip, whichfork));
+			xfs_inode_fork_size(ip, whichfork));
 		memmove(np, op, cur_max * (uint)sizeof(xfs_fsblock_t));
 		return;
 	}
@@ -461,7 +461,7 @@ xfs_iroot_realloc(
 	ifp->if_broot_bytes = (int)new_size;
 	if (ifp->if_broot)
 		ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
-			XFS_IFORK_SIZE(ip, whichfork));
+			xfs_inode_fork_size(ip, whichfork));
 	return;
 }
 
@@ -491,7 +491,7 @@ xfs_idata_realloc(
 	int64_t			new_size = ifp->if_bytes + byte_diff;
 
 	ASSERT(new_size >= 0);
-	ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));
+	ASSERT(new_size <= xfs_inode_fork_size(ip, whichfork));
 
 	if (byte_diff == 0)
 		return;
@@ -614,7 +614,7 @@ xfs_iflush_fork(
 		if ((iip->ili_fields & dataflag[whichfork]) &&
 		    (ifp->if_bytes > 0)) {
 			ASSERT(ifp->if_u1.if_data != NULL);
-			ASSERT(ifp->if_bytes <= XFS_IFORK_SIZE(ip, whichfork));
+			ASSERT(ifp->if_bytes <= xfs_inode_fork_size(ip, whichfork));
 			memcpy(cp, ifp->if_u1.if_data, ifp->if_bytes);
 		}
 		break;
@@ -633,7 +633,7 @@ xfs_iflush_fork(
 		    (ifp->if_broot_bytes > 0)) {
 			ASSERT(ifp->if_broot != NULL);
 			ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
-			        XFS_IFORK_SIZE(ip, whichfork));
+			        xfs_inode_fork_size(ip, whichfork));
 			xfs_bmbt_to_bmdr(mp, ifp->if_broot, ifp->if_broot_bytes,
 				(xfs_bmdr_block_t *)cp,
 				XFS_DFORK_SIZE(dip, mp, whichfork));
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index efee11956540..d3943d6ad0b9 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -77,21 +77,8 @@ struct xfs_ifork {
 /*
  * Fork handling.
  */
-
-#define XFS_IFORK_BOFF(ip)		((int)((ip)->i_forkoff << 3))
-
-#define XFS_IFORK_DSIZE(ip) \
-	(xfs_inode_has_attr_fork(ip) ? XFS_IFORK_BOFF(ip) : XFS_LITINO((ip)->i_mount))
-#define XFS_IFORK_ASIZE(ip) \
-	(xfs_inode_has_attr_fork(ip) ? XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : 0)
-#define XFS_IFORK_SIZE(ip,w) \
-	((w) == XFS_DATA_FORK ? \
-		XFS_IFORK_DSIZE(ip) : \
-		((w) == XFS_ATTR_FORK ? \
-			XFS_IFORK_ASIZE(ip) : \
-			0))
 #define XFS_IFORK_MAXEXT(ip, w) \
-	(XFS_IFORK_SIZE(ip, w) / sizeof(xfs_bmbt_rec_t))
+	(xfs_inode_fork_size(ip, w) / sizeof(xfs_bmbt_rec_t))
 
 static inline bool xfs_ifork_has_extents(struct xfs_ifork *ifp)
 {
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 0215f014e164..75311f8daeeb 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -52,8 +52,8 @@ xchk_symlink(
 
 	/* Inline symlink? */
 	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
-		if (len > XFS_IFORK_DSIZE(ip) ||
-		    len > strnlen(ifp->if_u1.if_data, XFS_IFORK_DSIZE(ip)))
+		if (len > xfs_inode_data_fork_size(ip) ||
+		    len > strnlen(ifp->if_u1.if_data, xfs_inode_data_fork_size(ip)))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out;
 	}
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8111319cbb46..74f96e1aa5cd 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1321,7 +1321,7 @@ xfs_swap_extents_check_format(
 	 */
 	if (tifp->if_format == XFS_DINODE_FMT_BTREE) {
 		if (xfs_inode_has_attr_fork(ip) &&
-		    XFS_BMAP_BMDR_SPACE(tifp->if_broot) > XFS_IFORK_BOFF(ip))
+		    XFS_BMAP_BMDR_SPACE(tifp->if_broot) > xfs_inode_fork_boff(ip))
 			return -EINVAL;
 		if (tifp->if_nextents <= XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
 			return -EINVAL;
@@ -1330,7 +1330,7 @@ xfs_swap_extents_check_format(
 	/* Reciprocal target->temp btree format checks */
 	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		if (xfs_inode_has_attr_fork(tip) &&
-		    XFS_BMAP_BMDR_SPACE(ip->i_df.if_broot) > XFS_IFORK_BOFF(tip))
+		    XFS_BMAP_BMDR_SPACE(ip->i_df.if_broot) > xfs_inode_fork_boff(tip))
 			return -EINVAL;
 		if (ifp->if_nextents <= XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
 			return -EINVAL;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2badbf9bb80d..7ff828504b3c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -102,6 +102,41 @@ xfs_ifork_ptr(
 	}
 }
 
+static inline unsigned int xfs_inode_fork_boff(struct xfs_inode *ip)
+{
+	return ip->i_forkoff << 3;
+}
+
+static inline unsigned int xfs_inode_data_fork_size(struct xfs_inode *ip)
+{
+	if (xfs_inode_has_attr_fork(ip))
+		return xfs_inode_fork_boff(ip);
+
+	return XFS_LITINO(ip->i_mount);
+}
+
+static inline unsigned int xfs_inode_attr_fork_size(struct xfs_inode *ip)
+{
+	if (xfs_inode_has_attr_fork(ip))
+		return XFS_LITINO(ip->i_mount) - xfs_inode_fork_boff(ip);
+	return 0;
+}
+
+static inline unsigned int
+xfs_inode_fork_size(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		return xfs_inode_data_fork_size(ip);
+	case XFS_ATTR_FORK:
+		return xfs_inode_attr_fork_size(ip);
+	default:
+		return 0;
+	}
+}
+
 /* Convert from vfs inode to xfs inode */
 static inline struct xfs_inode *XFS_I(struct inode *inode)
 {
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index a78a0b9dd1d0..6e19ece916bf 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -57,7 +57,7 @@ xfs_inode_item_data_fork_size(
 		    ip->i_df.if_nextents > 0 &&
 		    ip->i_df.if_bytes > 0) {
 			/* worst case, doesn't subtract delalloc extents */
-			*nbytes += XFS_IFORK_DSIZE(ip);
+			*nbytes += xfs_inode_data_fork_size(ip);
 			*nvecs += 1;
 		}
 		break;
@@ -98,7 +98,7 @@ xfs_inode_item_attr_fork_size(
 		    ip->i_af.if_nextents > 0 &&
 		    ip->i_af.if_bytes > 0) {
 			/* worst case, doesn't subtract unused space */
-			*nbytes += XFS_IFORK_ASIZE(ip);
+			*nbytes += xfs_inode_attr_fork_size(ip);
 			*nvecs += 1;
 		}
 		break;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 7d1ff282953f..36312b00b164 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -112,7 +112,7 @@ xfs_bulkstat_one_int(
 
 	xfs_bulkstat_health(ip, buf);
 	buf->bs_aextents = xfs_ifork_nextents(&ip->i_af);
-	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
+	buf->bs_forkoff = xfs_inode_fork_boff(ip);
 	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
 
 	if (xfs_has_v3inodes(mp)) {
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 4145ba872547..8389f3ef88ef 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -256,7 +256,7 @@ xfs_symlink(
 	/*
 	 * If the symlink will fit into the inode, write it inline.
 	 */
-	if (pathlen <= XFS_IFORK_DSIZE(ip)) {
+	if (pathlen <= xfs_inode_data_fork_size(ip)) {
 		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);
 
 		ip->i_disk_size = pathlen;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0fa1b7a2918c..8abc49af0d72 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2171,7 +2171,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__entry->format = ip->i_df.if_format;
 		__entry->nex = ip->i_df.if_nextents;
 		__entry->broot_size = ip->i_df.if_broot_bytes;
-		__entry->fork_off = XFS_IFORK_BOFF(ip);
+		__entry->fork_off = xfs_inode_fork_boff(ip);
 	),
 	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %llu, "
 		  "broot size %d, forkoff 0x%x",


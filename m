Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D407ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GP/S51yZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73868C433C8;
	Mon,  1 Jan 2024 00:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068894;
	bh=hVYj4jbgCPkWdishLeg5Un5RlgH5s4IOYno7rMwZxiw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GP/S51yZR6QwljGTVmxZfaq+dE8y7dsKcCJLuYUosHW+iCoSItrSzlx4t0rHCkpZc
	 hfiuMp5Zlu0FpJbGfl4csyWV5Zb41WPA2GQZs14pKK01csd4xQWdYYcLtkz8d4PsYr
	 N0H8vVM3HzU0Dw66dV9J/fL/xu9EOarU1SmeF1avLc53JkpqIpS+HmrAP4ufqCv4B5
	 YZ+F0DiWUNf1YMn+ghE+oXvdwklKfZ44m/QaSNuQoqQTaFfzLIwHTbqYZB/dA/a9xC
	 ZSNeT+zKBGUoMyQl9YwZrIOjjNng4yvXX1xlWGzBOvEXdEU+nQLzI4Y4B4KOJb8C+H
	 pYLAyHtqAVx2g==
Date: Sun, 31 Dec 2023 16:28:14 +9900
Subject: [PATCH 08/42] xfs: add realtime refcount btree inode to metadata
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017232.1817107.5732989162467268065.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Add a metadir path to select the realtime refcount btree inode and load
it at mount time.  The rtrefcountbt inode will have a unique extent format
code, which means that we also have to update the inode validation and
flush routines to look for it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c                 |    4 ++++
 libxfs/xfs_bmap.c             |    8 ++++++--
 libxfs/xfs_format.h           |    4 +++-
 libxfs/xfs_inode_buf.c        |    8 ++++++++
 libxfs/xfs_inode_fork.c       |    9 +++++++++
 libxfs/xfs_rtgroup.h          |    3 +++
 libxfs/xfs_rtrefcount_btree.c |   33 +++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h |    4 ++++
 8 files changed, 70 insertions(+), 3 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 36b4b486145..6add79121b2 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -970,6 +970,10 @@ libxfs_rtmount_destroy(xfs_mount_t *mp)
 	xfs_rgnumber_t		rgno;
 
 	for_each_rtgroup(mp, rgno, rtg) {
+		if (rtg->rtg_refcountip)
+			libxfs_imeta_irele(rtg->rtg_refcountip);
+		rtg->rtg_refcountip = NULL;
+
 		if (rtg->rtg_rmapip)
 			libxfs_imeta_irele(rtg->rtg_rmapip);
 		rtg->rtg_rmapip = NULL;
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 31129fb4884..9e30b4441c1 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5105,9 +5105,13 @@ xfs_bmap_del_extent_real(
 		 * the same order of operations as the data device, which is:
 		 * Remove the file mapping, remove the reverse mapping, and
 		 * then free the blocks.  This means that we must delay the
-		 * freeing until after we've scheduled the rmap update.
+		 * freeing until after we've scheduled the rmap update.  If
+		 * realtime reflink is enabled, use deferred refcount intent
+		 * items to decide what to do with the extent, just like we do
+		 * for the data device.
 		 */
-		if (want_free && !xfs_has_rtrmapbt(mp)) {
+		if (want_free && !xfs_has_rtrmapbt(mp) &&
+				 !xfs_has_rtreflink(mp)) {
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
 			if (error)
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index c938b814c43..93a9b8e3b56 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1028,6 +1028,7 @@ enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
 	XFS_DINODE_FMT_UUID,		/* added long ago, but never used */
 	XFS_DINODE_FMT_RMAP,		/* reverse mapping btree */
+	XFS_DINODE_FMT_REFCOUNT,	/* reference count btree */
 };
 
 #define XFS_INODE_FORMAT_STR \
@@ -1036,7 +1037,8 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_EXTENTS,	"extent" }, \
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }, \
-	{ XFS_DINODE_FMT_RMAP,		"rmap" }
+	{ XFS_DINODE_FMT_RMAP,		"rmap" }, \
+	{ XFS_DINODE_FMT_REFCOUNT,	"refcount" }
 
 /*
  * Max values for extnum and aextnum.
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index e7bf8ff7046..6f4dbe8367b 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -414,6 +414,12 @@ xfs_dinode_verify_fork(
 		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADIR)))
 			return __this_address;
 		break;
+	case XFS_DINODE_FMT_REFCOUNT:
+		if (!xfs_has_rtreflink(mp))
+			return __this_address;
+		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADIR)))
+			return __this_address;
+		break;
 	default:
 		return __this_address;
 	}
@@ -434,6 +440,7 @@ xfs_dinode_verify_forkoff(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_RMAP:
+	case XFS_DINODE_FMT_REFCOUNT:
 		if (!(xfs_has_metadir(mp) && xfs_has_parent(mp)))
 			return __this_address;
 		fallthrough;
@@ -705,6 +712,7 @@ xfs_dinode_verify(
 	if (flags2 & XFS_DIFLAG2_METADIR) {
 		switch (XFS_DFORK_FORMAT(dip, XFS_DATA_FORK)) {
 		case XFS_DINODE_FMT_RMAP:
+		case XFS_DINODE_FMT_REFCOUNT:
 			break;
 		default:
 			if (nextents + naextents == 0 && nblocks != 0)
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 127571527cf..11cfdc9b2bf 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -269,6 +269,11 @@ xfs_iformat_data_fork(
 				return -EFSCORRUPTED;
 			}
 			return xfs_iformat_rtrmap(ip, dip);
+		case XFS_DINODE_FMT_REFCOUNT:
+			if (!xfs_has_rtreflink(ip->i_mount))
+				return -EFSCORRUPTED;
+			ASSERT(0); /* to be implemented later */
+			return -EFSCORRUPTED;
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
@@ -664,6 +669,10 @@ xfs_iflush_fork(
 			xfs_iflush_rtrmap(ip, dip);
 		break;
 
+	case XFS_DINODE_FMT_REFCOUNT:
+		ASSERT(0); /* to be implemented later */
+		break;
+
 	default:
 		ASSERT(0);
 		break;
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 3522527e553..bd88a4d7281 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -25,6 +25,9 @@ struct xfs_rtgroup {
 	/* reverse mapping btree inode */
 	struct xfs_inode	*rtg_rmapip;
 
+	/* refcount btree inode */
+	struct xfs_inode	*rtg_refcountip;
+
 	/* Number of blocks in this group */
 	xfs_rgblock_t		rtg_blockcount;
 
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index fb4944d570f..425a56578c6 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -24,6 +24,7 @@
 #include "xfs_cksum.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_imeta.h"
 
 static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
 
@@ -353,6 +354,7 @@ xfs_rtrefcountbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_fork->if_format == XFS_DINODE_FMT_REFCOUNT);
 
 	/*
 	 * Free any resources hanging off the real fork, then shallow-copy the
@@ -456,3 +458,34 @@ xfs_rtrefcountbt_compute_maxlevels(
 	/* Add one level to handle the inode root level. */
 	mp->m_rtrefc_maxlevels = min(d_maxlevels, r_maxlevels) + 1;
 }
+
+#define XFS_RTREFC_NAMELEN		21
+
+/* Create the metadata directory path for an rtrefcount btree inode. */
+int
+xfs_rtrefcountbt_create_path(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	struct xfs_imeta_path	**pathp)
+{
+	struct xfs_imeta_path	*path;
+	unsigned char		*fname;
+	int			error;
+
+	error = xfs_imeta_create_file_path(mp, 2, &path);
+	if (error)
+		return error;
+
+	fname = kmalloc(XFS_RTREFC_NAMELEN, GFP_KERNEL);
+	if (!fname) {
+		xfs_imeta_free_path(path);
+		return -ENOMEM;
+	}
+
+	snprintf(fname, XFS_RTREFC_NAMELEN, "%u.refcount", rgno);
+	path->im_path[0] = "realtime";
+	path->im_path[1] = fname;
+	path->im_dynamicmask = 0x2;
+	*pathp = path;
+	return 0;
+}
diff --git a/libxfs/xfs_rtrefcount_btree.h b/libxfs/xfs_rtrefcount_btree.h
index 6d23ab3a9ad..ff49e95d1a4 100644
--- a/libxfs/xfs_rtrefcount_btree.h
+++ b/libxfs/xfs_rtrefcount_btree.h
@@ -11,6 +11,7 @@ struct xfs_btree_cur;
 struct xfs_mount;
 struct xbtree_ifakeroot;
 struct xfs_rtgroup;
+struct xfs_imeta_path;
 
 /* refcounts only exist on crc enabled filesystems */
 #define XFS_RTREFCOUNT_BLOCK_LEN	XFS_BTREE_LBLOCK_CRC_LEN
@@ -68,4 +69,7 @@ unsigned int xfs_rtrefcountbt_maxlevels_ondisk(void);
 int __init xfs_rtrefcountbt_init_cur_cache(void);
 void xfs_rtrefcountbt_destroy_cur_cache(void);
 
+int xfs_rtrefcountbt_create_path(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		struct xfs_imeta_path **pathp);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */


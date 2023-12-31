Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41407BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="INYB9HLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5E4C433C7;
	Sun, 31 Dec 2023 21:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059246;
	bh=6eVUvKBbRXJDGQRPfWoPr2Wx8W21OJraHdeR/5aXpHI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=INYB9HLhnMh/GpT05jkkN/04KN8gw072aBYrYACUvqOD4sudbNnOF6YL1Ek0l6Ti7
	 gNvOrRawLiGgRs1FSWdW4cjDdsu2551bQPGlqXgUaZ4XQ+rClj+hEq5BqRzqujNUmQ
	 oEI+9xLlMSrXtxXva9F5rN3N4aAwsL8zKC8K9MyQIa6hhzGPxRSXYrUxSvluHOV+CG
	 Is7i3eTKXUsxL63IcEl8ZLS4ndix7RgkStXGyMjJgMCI77qGUu3upoHHwLxHu1iY0s
	 jS/W2daMgk9dCjKgiSOXPXFAhhhqNBYrvybs4uwbWo3eRKV2gqcJyN4kqqp5nSArff
	 y/0bec9+NmgpA==
Date: Sun, 31 Dec 2023 13:47:26 -0800
Subject: [PATCH 11/44] xfs: add realtime refcount btree inode to metadata
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851758.1766284.13403280825223969168.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap.c             |    8 +++-
 fs/xfs/libxfs/xfs_format.h           |    4 ++
 fs/xfs/libxfs/xfs_inode_buf.c        |    8 ++++
 fs/xfs/libxfs/xfs_inode_fork.c       |    9 +++++
 fs/xfs/libxfs/xfs_rtgroup.h          |    3 ++
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   33 ++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |    4 ++
 fs/xfs/xfs_inode.c                   |   13 +++++++
 fs/xfs/xfs_inode_item.c              |    2 +
 fs/xfs/xfs_inode_item_recover.c      |    1 +
 fs/xfs/xfs_rtalloc.c                 |   63 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h                   |    1 +
 12 files changed, 146 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9a285f38da4cd..27f992dc6d2d6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5111,9 +5111,13 @@ xfs_bmap_del_extent_real(
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
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c938b814c430d..93a9b8e3b5694 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index dae2efec1d5d0..6e08ff8d8e239 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -417,6 +417,12 @@ xfs_dinode_verify_fork(
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
@@ -437,6 +443,7 @@ xfs_dinode_verify_forkoff(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_RMAP:
+	case XFS_DINODE_FMT_REFCOUNT:
 		if (!(xfs_has_metadir(mp) && xfs_has_parent(mp)))
 			return __this_address;
 		fallthrough;
@@ -708,6 +715,7 @@ xfs_dinode_verify(
 	if (flags2 & XFS_DIFLAG2_METADIR) {
 		switch (XFS_DFORK_FORMAT(dip, XFS_DATA_FORK)) {
 		case XFS_DINODE_FMT_RMAP:
+		case XFS_DINODE_FMT_REFCOUNT:
 			break;
 		default:
 			if (nextents + naextents == 0 && nblocks != 0)
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index e7ab04aea2db6..ae6e7deb04106 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -271,6 +271,11 @@ xfs_iformat_data_fork(
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
@@ -666,6 +671,10 @@ xfs_iflush_fork(
 			xfs_iflush_rtrmap(ip, dip);
 		break;
 
+	case XFS_DINODE_FMT_REFCOUNT:
+		ASSERT(0); /* to be implemented later */
+		break;
+
 	default:
 		ASSERT(0);
 		break;
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 3522527e553b8..bd88a4d728135 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -25,6 +25,9 @@ struct xfs_rtgroup {
 	/* reverse mapping btree inode */
 	struct xfs_inode	*rtg_rmapip;
 
+	/* refcount btree inode */
+	struct xfs_inode	*rtg_refcountip;
+
 	/* Number of blocks in this group */
 	xfs_rgblock_t		rtg_blockcount;
 
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 0892c4ddc7adf..ead6baf6de7e4 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -26,6 +26,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_imeta.h"
 
 static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
 
@@ -355,6 +356,7 @@ xfs_rtrefcountbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_fork->if_format == XFS_DINODE_FMT_REFCOUNT);
 
 	/*
 	 * Free any resources hanging off the real fork, then shallow-copy the
@@ -458,3 +460,34 @@ xfs_rtrefcountbt_compute_maxlevels(
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
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index 6d23ab3a9ad41..ff49e95d1a490 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b7cda81161fb5..334f87f7a8f3f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2509,6 +2509,14 @@ xfs_iflush(
 				__func__, ip->i_ino, ip);
 			goto flush_out;
 		}
+	} else if (ip->i_df.if_format == XFS_DINODE_FMT_REFCOUNT) {
+		if (!S_ISREG(VFS_I(ip)->i_mode) ||
+		    !(ip->i_diflags2 & XFS_DIFLAG2_METADIR)) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad rt refcountbt inode %Lu, ptr "PTR_FMT,
+				__func__, ip->i_ino, ip);
+			goto flush_out;
+		}
 	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
 		    ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
@@ -2555,6 +2563,11 @@ xfs_iflush(
 				"%s: rt rmapbt in inode %Lu attr fork, ptr "PTR_FMT,
 				__func__, ip->i_ino, ip);
 			goto flush_out;
+		} else if (ip->i_af.if_format == XFS_DINODE_FMT_REFCOUNT) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: rt refcountbt in inode %Lu attr fork, ptr "PTR_FMT,
+				__func__, ip->i_ino, ip);
+			goto flush_out;
 		}
 	}
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 2903c101505f5..fdc0b14bb9fbb 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -211,6 +211,7 @@ xfs_inode_item_data_fork_size(
 		break;
 	case XFS_DINODE_FMT_BTREE:
 	case XFS_DINODE_FMT_RMAP:
+	case XFS_DINODE_FMT_REFCOUNT:
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			*nbytes += ip->i_df.if_broot_bytes;
@@ -332,6 +333,7 @@ xfs_inode_item_format_data_fork(
 		break;
 	case XFS_DINODE_FMT_BTREE:
 	case XFS_DINODE_FMT_RMAP:
+	case XFS_DINODE_FMT_REFCOUNT:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT | XFS_ILOG_DEV);
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 4cf967df28ef1..2b5f7a143c479 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -420,6 +420,7 @@ xlog_recover_inode_commit_pass2(
 	if (unlikely(S_ISREG(ldip->di_mode))) {
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ldip->di_format != XFS_DINODE_FMT_RMAP) &&
+		    (ldip->di_format != XFS_DINODE_FMT_REFCOUNT) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
 			XFS_CORRUPTION_ERROR(
 				"Bad log dinode data fork format for regular file",
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 37156cf8acd25..4102a46ed274d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -31,6 +31,7 @@
 #include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_trace.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * Realtime metadata files are not quite regular files because userspace can't
@@ -42,6 +43,7 @@
 static struct lock_class_key xfs_rbmip_key;
 static struct lock_class_key xfs_rsumip_key;
 static struct lock_class_key xfs_rrmapip_key;
+static struct lock_class_key xfs_rrefcountip_key;
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1835,6 +1837,53 @@ xfs_rtmount_iread_extents(
 	return error;
 }
 
+/* Load realtime refcount btree inode. */
+STATIC int
+xfs_rtmount_refcountbt(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_trans	*tp)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_path	*path;
+	struct xfs_inode	*ip;
+	xfs_ino_t		ino;
+	int			error;
+
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	error = xfs_rtrefcountbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		return error;
+
+	error = xfs_imeta_lookup(tp, path, &ino);
+	if (error)
+		goto out_path;
+
+	if (ino == NULLFSINO) {
+		error = -EFSCORRUPTED;
+		goto out_path;
+	}
+
+	error = xfs_rt_iget(tp, ino, &xfs_rrefcountip_key, &ip);
+	if (error)
+		goto out_path;
+
+	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_REFCOUNT)) {
+		error = -EFSCORRUPTED;
+		goto out_rele;
+	}
+
+	rtg->rtg_refcountip = ip;
+	ip = NULL;
+out_rele:
+	if (ip)
+		xfs_imeta_irele(ip);
+out_path:
+	xfs_imeta_free_path(path);
+	return error;
+}
+
 /*
  * Get the bitmap and summary inodes and the summary cache into the mount
  * structure at mount time.
@@ -1886,6 +1935,12 @@ xfs_rtmount_inodes(
 			xfs_rtgroup_rele(rtg);
 			goto out_rele_rtgroup;
 		}
+
+		error = xfs_rtmount_refcountbt(rtg, tp);
+		if (error) {
+			xfs_rtgroup_rele(rtg);
+			goto out_rele_rtgroup;
+		}
 	}
 
 	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
@@ -1894,6 +1949,10 @@ xfs_rtmount_inodes(
 
 out_rele_rtgroup:
 	for_each_rtgroup(mp, rgno, rtg) {
+		if (rtg->rtg_refcountip)
+			xfs_imeta_irele(rtg->rtg_refcountip);
+		rtg->rtg_refcountip = NULL;
+
 		if (rtg->rtg_rmapip)
 			xfs_imeta_irele(rtg->rtg_rmapip);
 		rtg->rtg_rmapip = NULL;
@@ -1917,6 +1976,10 @@ xfs_rtunmount_inodes(
 	kmem_free(mp->m_rsum_cache);
 
 	for_each_rtgroup(mp, rgno, rtg) {
+		if (rtg->rtg_refcountip)
+			xfs_imeta_irele(rtg->rtg_refcountip);
+		rtg->rtg_refcountip = NULL;
+
 		if (rtg->rtg_rmapip)
 			xfs_imeta_irele(rtg->rtg_rmapip);
 		rtg->rtg_rmapip = NULL;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 86e0aa946aa00..f94f144f9a39d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2225,6 +2225,7 @@ TRACE_DEFINE_ENUM(XFS_DINODE_FMT_EXTENTS);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_BTREE);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_UUID);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_RMAP);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_REFCOUNT);
 
 DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 	TP_PROTO(struct xfs_inode *ip, int which),


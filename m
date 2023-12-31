Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83014BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnSNcFGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACCBC433C8;
	Sun, 31 Dec 2023 21:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058480;
	bh=SKWFlA0j7WTbEZDTizmejKvICN+Bu8V9ikZlfMhFnUc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cnSNcFGOU7pTHAk+d6G/gS1EXXoDPwj+BNJrg7Cclt79/hnwYMo/6tI+8KVfEeBlg
	 dwEsQdAUn0pdUakWtq+2l4FSLPjlZ/8D7w8BBVeXdnDjFiggIKy288ZxdIddz6QOCf
	 aDuCc6cWfZyQmYNVrm/tSXozuMS8KkGxXWWixAeBko1Qnlluvm4LXQtO5kcBSlMHzA
	 8aSSwT1hXQstv4/MzA5+C5exYuYiUJTGglcl5EIf+DlwYMJv7EjNE01ZA/Gb0PAL/F
	 +ajtj5j4hU3H3YAiNav2qCOKcChK/YjrojUwgwjfpYvNPI08zu4ckq5GTWp9ZkQw3F
	 Jc9Fby7vmTJxw==
Date: Sun, 31 Dec 2023 13:34:39 -0800
Subject: [PATCH 11/39] xfs: add realtime reverse map inode to metadata
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850078.1764998.2120978271688136761.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Add a metadir path to select the realtime rmap btree inode and load
it at mount time.  The rtrmapbt inode will have a unique extent format
code, which means that we also have to update the inode validation and
flush routines to look for it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h       |    6 ++-
 fs/xfs/libxfs/xfs_inode_buf.c    |   10 +++++
 fs/xfs/libxfs/xfs_inode_fork.c   |    9 +++++
 fs/xfs/libxfs/xfs_rtgroup.h      |    3 ++
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   33 ++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    4 ++
 fs/xfs/xfs_inode.c               |   19 ++++++++++
 fs/xfs/xfs_inode_item.c          |    2 +
 fs/xfs/xfs_inode_item_recover.c  |    1 +
 fs/xfs/xfs_rtalloc.c             |   71 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h               |    1 +
 11 files changed, 156 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 5317c6438f070..d374240fc58c0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1026,7 +1026,8 @@ enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_LOCAL,		/* bulk data */
 	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
 	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
-	XFS_DINODE_FMT_UUID		/* added long ago, but never used */
+	XFS_DINODE_FMT_UUID,		/* added long ago, but never used */
+	XFS_DINODE_FMT_RMAP,		/* reverse mapping btree */
 };
 
 #define XFS_INODE_FORMAT_STR \
@@ -1034,7 +1035,8 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_LOCAL,		"local" }, \
 	{ XFS_DINODE_FMT_EXTENTS,	"extent" }, \
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
-	{ XFS_DINODE_FMT_UUID,		"uuid" }
+	{ XFS_DINODE_FMT_UUID,		"uuid" }, \
+	{ XFS_DINODE_FMT_RMAP,		"rmap" }
 
 /*
  * Max values for extnum and aextnum.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 18d9e71a3bb30..5ed779cbe6f9f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -411,6 +411,12 @@ xfs_dinode_verify_fork(
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		if (!xfs_has_rtrmapbt(mp))
+			return __this_address;
+		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADIR)))
+			return __this_address;
+		break;
 	default:
 		return __this_address;
 	}
@@ -430,6 +436,10 @@ xfs_dinode_verify_forkoff(
 		if (dip->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3))
 			return __this_address;
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		if (!(xfs_has_metadir(mp) && xfs_has_parent(mp)))
+			return __this_address;
+		fallthrough;
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 16543bb873a81..eb7e733b30638 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -264,6 +264,11 @@ xfs_iformat_data_fork(
 			return xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
 		case XFS_DINODE_FMT_BTREE:
 			return xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
+		case XFS_DINODE_FMT_RMAP:
+			if (!xfs_has_rtrmapbt(ip->i_mount))
+				return -EFSCORRUPTED;
+			ASSERT(0); /* to be implemented later */
+			return -EFSCORRUPTED;
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
@@ -653,6 +658,10 @@ xfs_iflush_fork(
 		}
 		break;
 
+	case XFS_DINODE_FMT_RMAP:
+		ASSERT(0); /* to be implemented later */
+		break;
+
 	default:
 		ASSERT(0);
 		break;
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 0a63f14b5aa0f..77503bda35563 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -22,6 +22,9 @@ struct xfs_rtgroup {
 	/* for rcu-safe freeing */
 	struct rcu_head		rcu_head;
 
+	/* reverse mapping btree inode */
+	struct xfs_inode	*rtg_rmapip;
+
 	/* Number of blocks in this group */
 	xfs_rgblock_t		rtg_blockcount;
 
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 5be3e1af55684..e60864dd15030 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -18,6 +18,7 @@
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
+#include "xfs_imeta.h"
 #include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_trace.h"
@@ -476,6 +477,7 @@ xfs_rtrmapbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_fork->if_format == XFS_DINODE_FMT_RMAP);
 
 	/*
 	 * Free any resources hanging off the real fork, then shallow-copy the
@@ -576,3 +578,34 @@ xfs_rtrmapbt_compute_maxlevels(
 	/* Add one level to handle the inode root level. */
 	mp->m_rtrmap_maxlevels = min(d_maxlevels, r_maxlevels) + 1;
 }
+
+#define XFS_RTRMAP_NAMELEN		17
+
+/* Create the metadata directory path for an rtrmap btree inode. */
+int
+xfs_rtrmapbt_create_path(
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
+	fname = kmalloc(XFS_RTRMAP_NAMELEN, GFP_KERNEL);
+	if (!fname) {
+		xfs_imeta_free_path(path);
+		return -ENOMEM;
+	}
+
+	snprintf(fname, XFS_RTRMAP_NAMELEN, "%u.rmap", rgno);
+	path->im_path[0] = "realtime";
+	path->im_path[1] = fname;
+	path->im_dynamicmask = 0x2;
+	*pathp = path;
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 0f73267971924..29b698660182d 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -11,6 +11,7 @@ struct xfs_btree_cur;
 struct xfs_mount;
 struct xbtree_ifakeroot;
 struct xfs_rtgroup;
+struct xfs_imeta_path;
 
 /* rmaps only exist on crc enabled filesystems */
 #define XFS_RTRMAP_BLOCK_LEN	XFS_BTREE_LBLOCK_CRC_LEN
@@ -80,4 +81,7 @@ unsigned int xfs_rtrmapbt_maxlevels_ondisk(void);
 int __init xfs_rtrmapbt_init_cur_cache(void);
 void xfs_rtrmapbt_destroy_cur_cache(void);
 
+int xfs_rtrmapbt_create_path(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		struct xfs_imeta_path **pathp);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 78afc5b8e11c6..b7cda81161fb5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2501,7 +2501,15 @@ xfs_iflush(
 			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
 		goto flush_out;
 	}
-	if (S_ISREG(VFS_I(ip)->i_mode)) {
+	if (ip->i_df.if_format == XFS_DINODE_FMT_RMAP) {
+		if (!S_ISREG(VFS_I(ip)->i_mode) ||
+		    !(ip->i_diflags2 & XFS_DIFLAG2_METADIR)) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad rt rmapbt inode %Lu, ptr "PTR_FMT,
+				__func__, ip->i_ino, ip);
+			goto flush_out;
+		}
+	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
 		    ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
 		    ip->i_df.if_format != XFS_DINODE_FMT_BTREE,
@@ -2541,6 +2549,15 @@ xfs_iflush(
 		goto flush_out;
 	}
 
+	if (xfs_inode_has_attr_fork(ip)) {
+		if (ip->i_af.if_format == XFS_DINODE_FMT_RMAP) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: rt rmapbt in inode %Lu attr fork, ptr "PTR_FMT,
+				__func__, ip->i_ino, ip);
+			goto flush_out;
+		}
+	}
+
 	/*
 	 * Inode item log recovery for v2 inodes are dependent on the flushiter
 	 * count for correct sequencing.  We bump the flush iteration count so
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index b35335e20342c..2903c101505f5 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -210,6 +210,7 @@ xfs_inode_item_data_fork_size(
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_RMAP:
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			*nbytes += ip->i_df.if_broot_bytes;
@@ -330,6 +331,7 @@ xfs_inode_item_format_data_fork(
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_RMAP:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT | XFS_ILOG_DEV);
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 144198a6b2702..0ec61d17f98e6 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -393,6 +393,7 @@ xlog_recover_inode_commit_pass2(
 
 	if (unlikely(S_ISREG(ldip->di_mode))) {
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ldip->di_format != XFS_DINODE_FMT_RMAP) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
 			XFS_CORRUPTION_ERROR(
 				"Bad log dinode data fork format for regular file",
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 49528f901d047..5308554fa93ec 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -25,6 +25,8 @@
 #include "xfs_da_format.h"
 #include "xfs_imeta.h"
 #include "xfs_rtgroup.h"
+#include "xfs_error.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Realtime metadata files are not quite regular files because userspace can't
@@ -35,6 +37,7 @@
  */
 static struct lock_class_key xfs_rbmip_key;
 static struct lock_class_key xfs_rsumip_key;
+static struct lock_class_key xfs_rrmapip_key;
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1589,6 +1592,53 @@ __xfs_rt_iget(
 #define xfs_rt_iget(tp, ino, lockdep_key, ipp) \
 	__xfs_rt_iget((tp), (ino), (lockdep_key), #lockdep_key, (ipp))
 
+/* Load realtime rmap btree inode. */
+STATIC int
+xfs_rtmount_rmapbt(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_trans	*tp)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_path	*path;
+	struct xfs_inode	*ip;
+	xfs_ino_t		ino;
+	int			error;
+
+	if (!xfs_has_rtrmapbt(mp))
+		return 0;
+
+	error = xfs_rtrmapbt_create_path(mp, rtg->rtg_rgno, &path);
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
+	error = xfs_rt_iget(tp, ino, &xfs_rrmapip_key, &ip);
+	if (error)
+		goto out_path;
+
+	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_RMAP)) {
+		error = -EFSCORRUPTED;
+		goto out_rele;
+	}
+
+	rtg->rtg_rmapip = ip;
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
  * Read in the bmbt of an rt metadata inode so that we never have to load them
  * at runtime.  This enables the use of shared ILOCKs for rtbitmap scans.  Use
@@ -1663,12 +1713,24 @@ xfs_rtmount_inodes(
 	for_each_rtgroup(mp, rgno, rtg) {
 		rtg->rtg_blockcount = xfs_rtgroup_block_count(mp,
 							      rtg->rtg_rgno);
+
+		error = xfs_rtmount_rmapbt(rtg, tp);
+		if (error) {
+			xfs_rtgroup_rele(rtg);
+			goto out_rele_rtgroup;
+		}
 	}
 
 	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
 	xfs_trans_cancel(tp);
 	return 0;
 
+out_rele_rtgroup:
+	for_each_rtgroup(mp, rgno, rtg) {
+		if (rtg->rtg_rmapip)
+			xfs_imeta_irele(rtg->rtg_rmapip);
+		rtg->rtg_rmapip = NULL;
+	}
 out_rele_summary:
 	xfs_imeta_irele(mp->m_rsumip);
 out_rele_bitmap:
@@ -1682,7 +1744,16 @@ void
 xfs_rtunmount_inodes(
 	struct xfs_mount	*mp)
 {
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+
 	kmem_free(mp->m_rsum_cache);
+
+	for_each_rtgroup(mp, rgno, rtg) {
+		if (rtg->rtg_rmapip)
+			xfs_imeta_irele(rtg->rtg_rmapip);
+		rtg->rtg_rmapip = NULL;
+	}
 	if (mp->m_rbmip)
 		xfs_imeta_irele(mp->m_rbmip);
 	if (mp->m_rsumip)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 10eeceb8b9e7f..8ebdfb216266c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2221,6 +2221,7 @@ TRACE_DEFINE_ENUM(XFS_DINODE_FMT_LOCAL);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_EXTENTS);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_BTREE);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_UUID);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_RMAP);
 
 DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 	TP_PROTO(struct xfs_inode *ip, int which),


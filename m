Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05646384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A86srkuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C9BC433C7;
	Mon,  1 Jan 2024 00:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067956;
	bh=gxyrQQpad9JFVN0c9XiaocO7nUjYTvhIIye7Wp7hcDc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A86srkuK0+LjZ43dB3cZf35u1SCtxckiUw/PhjsRDv2UkYcW7FlV4RMqYGAyY9xJm
	 p5zYP5fLQH4OLfw1fnKBP9wwC1cVX9RqJmYbREEAPQa1JoefXAEMcCNxvUEROPp16S
	 VruJVRc3wM7I7HoIZNJgMqCEJf72g10cbRMIbqV8O8BtKGH4L461RaxRqhSKJXJ4/P
	 FLaP/j0qdl5s+KN+fiEkLOMo3cpIHZEESTK500QoPR4WllrD98b1zxlkNcRQYfzKtj
	 q7xAYQVPGU/D0WjK6fTH/pcNJX/0JVn6g28r92KdeZlIYQ4++Cv9Eg14zP6hoaDSdv
	 FH3UfdQj5HlIQ==
Date: Sun, 31 Dec 2023 16:12:36 +9900
Subject: [PATCH 08/47] xfs: add realtime reverse map inode to metadata
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015420.1815505.10479182490320173681.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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
 libxfs/init.c             |    8 ++++++++
 libxfs/xfs_format.h       |    6 ++++--
 libxfs/xfs_inode_buf.c    |   10 ++++++++++
 libxfs/xfs_inode_fork.c   |    9 +++++++++
 libxfs/xfs_rtgroup.h      |    3 +++
 libxfs/xfs_rtrmap_btree.c |   33 +++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |    4 ++++
 7 files changed, 71 insertions(+), 2 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 9a4dfe02945..ba0b9a87f2d 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -969,6 +969,14 @@ libxfs_mount(
 void
 libxfs_rtmount_destroy(xfs_mount_t *mp)
 {
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+
+	for_each_rtgroup(mp, rgno, rtg) {
+		if (rtg->rtg_rmapip)
+			libxfs_imeta_irele(rtg->rtg_rmapip);
+		rtg->rtg_rmapip = NULL;
+	}
 	if (mp->m_rsumip)
 		libxfs_imeta_irele(mp->m_rsumip);
 	if (mp->m_rbmip)
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 5317c6438f0..d374240fc58 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 8d100595756..9755ae33813 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -408,6 +408,12 @@ xfs_dinode_verify_fork(
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
@@ -427,6 +433,10 @@ xfs_dinode_verify_forkoff(
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
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index ec3a399e798..2e8f84e57a4 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -262,6 +262,11 @@ xfs_iformat_data_fork(
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
@@ -651,6 +656,10 @@ xfs_iflush_fork(
 		}
 		break;
 
+	case XFS_DINODE_FMT_RMAP:
+		ASSERT(0); /* to be implemented later */
+		break;
+
 	default:
 		ASSERT(0);
 		break;
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 0a63f14b5aa..77503bda355 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -22,6 +22,9 @@ struct xfs_rtgroup {
 	/* for rcu-safe freeing */
 	struct rcu_head		rcu_head;
 
+	/* reverse mapping btree inode */
+	struct xfs_inode	*rtg_rmapip;
+
 	/* Number of blocks in this group */
 	xfs_rgblock_t		rtg_blockcount;
 
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index a2cb497379f..d788ef60333 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -24,6 +24,7 @@
 #include "xfs_cksum.h"
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
+#include "xfs_imeta.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -474,6 +475,7 @@ xfs_rtrmapbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_fork->if_format == XFS_DINODE_FMT_RMAP);
 
 	/*
 	 * Free any resources hanging off the real fork, then shallow-copy the
@@ -574,3 +576,34 @@ xfs_rtrmapbt_compute_maxlevels(
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
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 0f732679719..29b69866018 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
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


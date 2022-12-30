Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67F7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiLaBu4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236099AbiLaBuz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:50:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C54101E3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:50:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00DB461CCE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB92C433D2;
        Sat, 31 Dec 2022 01:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451453;
        bh=M/ygd3wZW8MjZ2x3Z5eh6jbkd35RxdBozOnz7WsYJA8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W/lo94Tt8IEAt8fay3iTjPhsEqFTm0G5xl/OQB9qv1RVJcugff+sRYny8vBKR/ufZ
         z2LZlbTsf31iA2AWE9sa1RJpmoTs4tquvx93d4pMhj5kvTOa3ywdSo2fTeZoloFAq6
         VfpwnGhm1lHdv9+bXvjazBnVR5TqLiUdJi2l2AQnj3MKxlbKJX/8td3Ky5/hPo1fWW
         uNcEWYXZ1gIHMm0whWx0Af0a4rlEZAIRz2sDz+t+ZQ87kaIC5xYDtX1voxA9vNoBFU
         wzSsaIrgP2nqopVnRGK6qRdmvuvBSUXjzu2LiVEzmQC3BvBMlcqMLc72OWl4TI0OIF
         IqaM9IjsaagtQ==
Subject: [PATCH 11/42] xfs: add realtime refcount btree inode to metadata
 directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:30 -0800
Message-ID: <167243871053.717073.8108075011573657245.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a metadir path to select the realtime refcount btree inode and load
it at mount time.  The rtrefcountbt inode will have a unique extent format
code, which means that we also have to update the inode validation and
flush routines to look for it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c             |    8 +++-
 fs/xfs/libxfs/xfs_format.h           |    4 ++
 fs/xfs/libxfs/xfs_inode_buf.c        |    6 +++
 fs/xfs/libxfs/xfs_inode_fork.c       |    9 +++++
 fs/xfs/libxfs/xfs_rtgroup.h          |    3 ++
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   33 ++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |    4 ++
 fs/xfs/xfs_inode.c                   |   13 +++++++
 fs/xfs/xfs_inode_item.c              |    2 +
 fs/xfs/xfs_inode_item_recover.c      |    1 +
 fs/xfs/xfs_rtalloc.c                 |   63 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h                   |    1 +
 12 files changed, 144 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b46504d861e3..fe31f3cb5d91 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5148,9 +5148,13 @@ xfs_bmap_del_extent_real(
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
index d2270f95bfbc..20af5b730d6d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1011,6 +1011,7 @@ enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
 	XFS_DINODE_FMT_UUID,		/* added long ago, but never used */
 	XFS_DINODE_FMT_RMAP,		/* reverse mapping btree */
+	XFS_DINODE_FMT_REFCOUNT,	/* reference count btree */
 };
 
 #define XFS_INODE_FORMAT_STR \
@@ -1019,7 +1020,8 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_EXTENTS,	"extent" }, \
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }, \
-	{ XFS_DINODE_FMT_RMAP,		"rmap" }
+	{ XFS_DINODE_FMT_RMAP,		"rmap" }, \
+	{ XFS_DINODE_FMT_REFCOUNT,	"refcount" }
 
 /*
  * Max values for extnum and aextnum.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 9ac84be391b3..dcf816f2643b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -414,6 +414,12 @@ xfs_dinode_verify_fork(
 		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
 			return __this_address;
 		break;
+	case XFS_DINODE_FMT_REFCOUNT:
+		if (!xfs_has_rtreflink(mp))
+			return __this_address;
+		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
+			return __this_address;
+		break;
 	default:
 		return __this_address;
 	}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 61926c07aad3..e69ec68b5a9d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -266,6 +266,11 @@ xfs_iformat_data_fork(
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
@@ -652,6 +657,10 @@ xfs_iflush_fork(
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
index 4e9b9098f2f2..0f400f133d88 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -23,6 +23,9 @@ struct xfs_rtgroup {
 	/* reverse mapping btree inode */
 	struct xfs_inode	*rtg_rmapip;
 
+	/* refcount btree inode */
+	struct xfs_inode	*rtg_refcountip;
+
 	/* Number of blocks in this group */
 	xfs_rgblock_t		rtg_blockcount;
 
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index bdefc4f5939d..40524fee3860 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -26,6 +26,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_imeta.h"
 
 static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
 
@@ -354,6 +355,7 @@ xfs_rtrefcountbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_fork->if_format == XFS_DINODE_FMT_REFCOUNT);
 
 	/*
 	 * Free any resources hanging off the real fork, then shallow-copy the
@@ -457,3 +459,34 @@ xfs_rtrefcountbt_compute_maxlevels(
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
+	char			*fname;
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
index d10ebdcf7727..1f3f590c68e6 100644
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
index 3b0c04b6bcdf..d50cbd0eb260 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2580,6 +2580,14 @@ xfs_iflush(
 				__func__, ip->i_ino, ip);
 			goto flush_out;
 		}
+	} else if (ip->i_df.if_format == XFS_DINODE_FMT_REFCOUNT) {
+		if (!S_ISREG(VFS_I(ip)->i_mode) ||
+		    !(ip->i_diflags2 & XFS_DIFLAG2_METADATA)) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad rt refcountbt inode %Lu, ptr "PTR_FMT,
+				__func__, ip->i_ino, ip);
+			goto flush_out;
+		}
 	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
 		    ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
@@ -2626,6 +2634,11 @@ xfs_iflush(
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
index b6e374744474..7cbc79e3997a 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -63,6 +63,7 @@ xfs_inode_item_data_fork_size(
 		break;
 	case XFS_DINODE_FMT_BTREE:
 	case XFS_DINODE_FMT_RMAP:
+	case XFS_DINODE_FMT_REFCOUNT:
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			*nbytes += ip->i_df.if_broot_bytes;
@@ -184,6 +185,7 @@ xfs_inode_item_format_data_fork(
 		break;
 	case XFS_DINODE_FMT_BTREE:
 	case XFS_DINODE_FMT_RMAP:
+	case XFS_DINODE_FMT_REFCOUNT:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT | XFS_ILOG_DEV);
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 4f1ed1f6a34d..feeba1dff01e 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -417,6 +417,7 @@ xlog_recover_inode_commit_pass2(
 	if (unlikely(S_ISREG(ldip->di_mode))) {
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ldip->di_format != XFS_DINODE_FMT_RMAP) &&
+		    (ldip->di_format != XFS_DINODE_FMT_REFCOUNT) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
 			XFS_CORRUPTION_ERROR(
 				"Bad log dinode data fork format for regular file",
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 0f31680284fb..c998e26f5db9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -31,6 +31,7 @@
 #include "xfs_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
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
@@ -1855,6 +1857,47 @@ xfs_rtmount_iread_extents(
 	return error;
 }
 
+/* Load realtime refcount btree inode. */
+STATIC int
+xfs_rtmount_refcountbt(
+	struct xfs_rtgroup	*rtg)
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
+	error = xfs_imeta_lookup(mp, path, &ino);
+	if (error)
+		goto out_path;
+
+	error = xfs_rt_iget(mp, ino, &xfs_rrefcountip_key, &ip);
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
@@ -1902,6 +1945,10 @@ xfs_rtmount_inodes(
 			xfs_rtgroup_put(rtg);
 			goto out_rele_rtgroup;
 		}
+
+		error = xfs_rtmount_refcountbt(rtg);
+		if (error)
+			goto out_rele_rtgroup;
 	}
 
 	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
@@ -1909,6 +1956,10 @@ xfs_rtmount_inodes(
 
 out_rele_rtgroup:
 	for_each_rtgroup(mp, rgno, rtg) {
+		if (rtg->rtg_refcountip)
+			xfs_imeta_irele(rtg->rtg_refcountip);
+		rtg->rtg_refcountip = NULL;
+
 		if (rtg->rtg_rmapip)
 			xfs_imeta_irele(rtg->rtg_rmapip);
 		rtg->rtg_rmapip = NULL;
@@ -1945,6 +1996,14 @@ xfs_rtmount_dqattach(
 				return error;
 			}
 		}
+
+		if (rtg->rtg_refcountip) {
+			error = xfs_qm_dqattach(rtg->rtg_refcountip);
+			if (error) {
+				xfs_rtgroup_put(rtg);
+				return error;
+			}
+		}
 	}
 
 	return 0;
@@ -1960,6 +2019,10 @@ xfs_rtunmount_inodes(
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
index 1f8ab7c436a9..d07947451ec9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2239,6 +2239,7 @@ TRACE_DEFINE_ENUM(XFS_DINODE_FMT_EXTENTS);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_BTREE);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_UUID);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_RMAP);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_REFCOUNT);
 
 DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 	TP_PROTO(struct xfs_inode *ip, int which),


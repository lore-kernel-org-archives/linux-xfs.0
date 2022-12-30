Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5865C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbiLaBkB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbiLaBkA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:40:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233051CFF0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:39:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8CAC61CBD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B53FC433EF;
        Sat, 31 Dec 2022 01:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450798;
        bh=aYQndyBaD62ond7EkDf/Ho7sntO8H81uh9cmQ9WtJHw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hfzEaIOaaJCxhSBZ7v/P76fmSuZrWqKF7x1lmmOf+ashV5Lff9c6MtwfLAFL6vxVT
         kQnAz8+Z239CdWmYYfNShcq4lDsvUTy82XpUh4kwjDsIW+0AxPQQvmNpggQBDHUwTv
         O3DJshIrCPIAnkJeZiSbkKkaWih0nmKYXDf1n7IgxWkYaKKnpD5W8twR1bNxFlE63e
         0fqE70utqVF6nv36t7jAXsich60dSGgbCazysgtoX/yP0tVjndePpbnbb3wAWW6X30
         S3+emTkzCbIz9TZ59zYIjzJW8R0/CDqRZYNC7R2MyFPMHAyasQHt+Mbpco+jloXQGO
         F98CvCDqbhuXQ==
Subject: [PATCH 12/38] xfs: add realtime reverse map inode to metadata
 directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:17 -0800
Message-ID: <167243869769.715303.8418722142356010813.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a metadir path to select the realtime rmap btree inode and load
it at mount time.  The rtrmapbt inode will have a unique extent format
code, which means that we also have to update the inode validation and
flush routines to look for it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h       |    6 ++-
 fs/xfs/libxfs/xfs_inode_buf.c    |    6 +++
 fs/xfs/libxfs/xfs_inode_fork.c   |    9 ++++
 fs/xfs/libxfs/xfs_rtgroup.h      |    3 +
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   33 ++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    4 ++
 fs/xfs/xfs_inode.c               |   19 +++++++++
 fs/xfs/xfs_inode_item.c          |    2 +
 fs/xfs/xfs_inode_item_recover.c  |    1 
 fs/xfs/xfs_rtalloc.c             |   79 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h               |    1 
 11 files changed, 159 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index fb727e1e4072..babe5d3fabb1 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1009,7 +1009,8 @@ enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_LOCAL,		/* bulk data */
 	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
 	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
-	XFS_DINODE_FMT_UUID		/* added long ago, but never used */
+	XFS_DINODE_FMT_UUID,		/* added long ago, but never used */
+	XFS_DINODE_FMT_RMAP,		/* reverse mapping btree */
 };
 
 #define XFS_INODE_FORMAT_STR \
@@ -1017,7 +1018,8 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_LOCAL,		"local" }, \
 	{ XFS_DINODE_FMT_EXTENTS,	"extent" }, \
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
-	{ XFS_DINODE_FMT_UUID,		"uuid" }
+	{ XFS_DINODE_FMT_UUID,		"uuid" }, \
+	{ XFS_DINODE_FMT_RMAP,		"rmap" }
 
 /*
  * Max values for extnum and aextnum.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 1fb11d0e7eba..9ac84be391b3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -408,6 +408,12 @@ xfs_dinode_verify_fork(
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		if (!xfs_has_rtrmapbt(mp))
+			return __this_address;
+		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
+			return __this_address;
+		break;
 	default:
 		return __this_address;
 	}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index b844bfd94e9c..899428f96b94 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -259,6 +259,11 @@ xfs_iformat_data_fork(
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
@@ -639,6 +644,10 @@ xfs_iflush_fork(
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
index 3c9572677f79..1792a9ab3bbf 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -20,6 +20,9 @@ struct xfs_rtgroup {
 	/* for rcu-safe freeing */
 	struct rcu_head		rcu_head;
 
+	/* reverse mapping btree inode */
+	struct xfs_inode	*rtg_rmapip;
+
 	/* Number of blocks in this group */
 	xfs_rgblock_t		rtg_blockcount;
 
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 551d575713db..754812eaff87 100644
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
@@ -475,6 +476,7 @@ xfs_rtrmapbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_fork->if_format == XFS_DINODE_FMT_RMAP);
 
 	/*
 	 * Free any resources hanging off the real fork, then shallow-copy the
@@ -575,3 +577,34 @@ xfs_rtrmapbt_compute_maxlevels(
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
+	char			*fname;
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
index 7380c04e7705..26e2445f5d6c 100644
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
index ab805df9db16..3b0c04b6bcdf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2572,7 +2572,15 @@ xfs_iflush(
 			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
 		goto flush_out;
 	}
-	if (S_ISREG(VFS_I(ip)->i_mode)) {
+	if (ip->i_df.if_format == XFS_DINODE_FMT_RMAP) {
+		if (!S_ISREG(VFS_I(ip)->i_mode) ||
+		    !(ip->i_diflags2 & XFS_DIFLAG2_METADATA)) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad rt rmapbt inode %Lu, ptr "PTR_FMT,
+				__func__, ip->i_ino, ip);
+			goto flush_out;
+		}
+	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
 		    ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
 		    ip->i_df.if_format != XFS_DINODE_FMT_BTREE,
@@ -2612,6 +2620,15 @@ xfs_iflush(
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
index ca2941ab6cbc..b6e374744474 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -62,6 +62,7 @@ xfs_inode_item_data_fork_size(
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_RMAP:
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			*nbytes += ip->i_df.if_broot_bytes;
@@ -182,6 +183,7 @@ xfs_inode_item_format_data_fork(
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_RMAP:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT | XFS_ILOG_DEV);
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 0e5dba2343ea..3453a204d196 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -390,6 +390,7 @@ xlog_recover_inode_commit_pass2(
 
 	if (unlikely(S_ISREG(ldip->di_mode))) {
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ldip->di_format != XFS_DINODE_FMT_RMAP) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
 			XFS_CORRUPTION_ERROR(
 				"Bad log dinode data fork format for regular file",
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 82b729a86740..ba330265ab8a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -27,6 +27,8 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
 #include "xfs_quota.h"
+#include "xfs_error.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Realtime metadata files are not quite regular files because userspace can't
@@ -37,6 +39,7 @@
  */
 static struct lock_class_key xfs_rbmip_key;
 static struct lock_class_key xfs_rsumip_key;
+static struct lock_class_key xfs_rrmapip_key;
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1600,6 +1603,47 @@ __xfs_rt_iget(
 #define xfs_rt_iget(mp, ino, lockdep_key, ipp) \
 	__xfs_rt_iget((mp), (ino), (lockdep_key), #lockdep_key, (ipp))
 
+/* Load realtime rmap btree inode. */
+STATIC int
+xfs_rtmount_rmapbt(
+	struct xfs_rtgroup	*rtg)
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
+	error = xfs_imeta_lookup(mp, path, &ino);
+	if (error)
+		goto out_path;
+
+	error = xfs_rt_iget(mp, ino, &xfs_rrmapip_key, &ip);
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
@@ -1638,7 +1682,7 @@ xfs_rtmount_iread_extents(
  * Get the bitmap and summary inodes and the summary cache into the mount
  * structure at mount time.
  */
-int					/* error */
+int
 xfs_rtmount_inodes(
 	struct xfs_mount	*mp)		/* file system mount structure */
 {
@@ -1675,11 +1719,23 @@ xfs_rtmount_inodes(
 	for_each_rtgroup(mp, rgno, rtg) {
 		rtg->rtg_blockcount = xfs_rtgroup_block_count(mp,
 							      rtg->rtg_rgno);
+
+		error = xfs_rtmount_rmapbt(rtg);
+		if (error) {
+			xfs_rtgroup_put(rtg);
+			goto out_rele_rtgroup;
+		}
 	}
 
 	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
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
@@ -1692,6 +1748,8 @@ int
 xfs_rtmount_dqattach(
 	struct xfs_mount	*mp)
 {
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
 	int			error;
 
 	error = xfs_qm_dqattach(mp->m_rbmip);
@@ -1702,6 +1760,16 @@ xfs_rtmount_dqattach(
 	if (error)
 		return error;
 
+	for_each_rtgroup(mp, rgno, rtg) {
+		if (rtg->rtg_rmapip) {
+			error = xfs_qm_dqattach(rtg->rtg_rmapip);
+			if (error) {
+				xfs_rtgroup_put(rtg);
+				return error;
+			}
+		}
+	}
+
 	return 0;
 }
 
@@ -1709,7 +1777,16 @@ void
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
index c02a58cbf15b..77f4acc1b923 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2235,6 +2235,7 @@ TRACE_DEFINE_ENUM(XFS_DINODE_FMT_LOCAL);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_EXTENTS);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_BTREE);
 TRACE_DEFINE_ENUM(XFS_DINODE_FMT_UUID);
+TRACE_DEFINE_ENUM(XFS_DINODE_FMT_RMAP);
 
 DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 	TP_PROTO(struct xfs_inode *ip, int which),


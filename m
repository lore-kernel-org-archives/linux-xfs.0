Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8643C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbiLaC4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaC4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:56:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1CF10F2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:56:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D275CB81E52
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C85C433D2;
        Sat, 31 Dec 2022 02:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455374;
        bh=3IDbGFr+NwCSfR1FT/4EQzcuH395SeUu0G2aUEazheA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tV7OZgRST4WFbXr2pc0VvnR+TjL7H1ztNa7aM+xxpcwpQ5mSCxHfoCJ4hpVRx2oqV
         DRsnoLfgGwoBRBb+QxZWncjQA7Tw46vKQarB9fJzGAOnhyXY4GWHSBqbS7h+W7B1gk
         eyFz7TscDuXoSPiF9vHVRSnaHZzWHWZ7jiPmNx88/De1JeFvJHmBRRSi1rvw8MDhMY
         QaiTcRWP42y88xkBgqxKPSJ8pC5B5RVqHEOBC2k4V7NpnWYPDWnt0eBTGz6WWenHRh
         msBJxUX3KiZNcfIweYnuvIpvovUEZkqQX41blDabws+j1qZ8l+iyRe0+6reByzsU71
         NQFeEHefgT/Fw==
Subject: [PATCH 08/41] xfs: add realtime refcount btree inode to metadata
 directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:08 -0800
Message-ID: <167243880875.734096.14383279943023016178.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
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
 libxfs/init.c                 |    4 ++++
 libxfs/xfs_bmap.c             |    8 ++++++--
 libxfs/xfs_format.h           |    4 +++-
 libxfs/xfs_inode_buf.c        |    6 ++++++
 libxfs/xfs_inode_fork.c       |    9 +++++++++
 libxfs/xfs_rtgroup.h          |    3 +++
 libxfs/xfs_rtrefcount_btree.c |   33 +++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h |    4 ++++
 8 files changed, 68 insertions(+), 3 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index cda8c92ab4f..40ebbbce39d 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -1027,6 +1027,10 @@ libxfs_rtmount_destroy(xfs_mount_t *mp)
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
index 6795f070214..4bf5ce838a9 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5142,9 +5142,13 @@ xfs_bmap_del_extent_real(
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
index d2270f95bfb..20af5b730d6 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 3aaa1988fb1..004dafdf1bd 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -411,6 +411,12 @@ xfs_dinode_verify_fork(
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
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 2b2a3fcab94..f7a168e0625 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -264,6 +264,11 @@ xfs_iformat_data_fork(
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
@@ -650,6 +655,10 @@ xfs_iflush_fork(
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
index 4e9b9098f2f..0f400f133d8 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -23,6 +23,9 @@ struct xfs_rtgroup {
 	/* reverse mapping btree inode */
 	struct xfs_inode	*rtg_rmapip;
 
+	/* refcount btree inode */
+	struct xfs_inode	*rtg_refcountip;
+
 	/* Number of blocks in this group */
 	xfs_rgblock_t		rtg_blockcount;
 
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index ad2f94e5231..c69b4296d57 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -24,6 +24,7 @@
 #include "xfs_cksum.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_imeta.h"
 
 static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
 
@@ -352,6 +353,7 @@ xfs_rtrefcountbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_fork->if_format == XFS_DINODE_FMT_REFCOUNT);
 
 	/*
 	 * Free any resources hanging off the real fork, then shallow-copy the
@@ -455,3 +457,34 @@ xfs_rtrefcountbt_compute_maxlevels(
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
diff --git a/libxfs/xfs_rtrefcount_btree.h b/libxfs/xfs_rtrefcount_btree.h
index d10ebdcf772..1f3f590c68e 100644
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


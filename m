Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79DEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbiLaCow (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbiLaCog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:44:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D4ADF76
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:44:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01EEE61D17
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E601C433EF;
        Sat, 31 Dec 2022 02:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454674;
        bh=qn2uRh/QFjODjuCRihPUJIyF0jEiiJScU/+Cmjdxla4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J5pWJwnBggXN45Xs931wbgYEYYaZJ45IIQLsiZ6Gcc1fKEjv06C7vPZLRlRLnEJDJ
         YlDJ5KFnqpuJVLTcga5csfNFPPopNRGsf48klSzJjrT2DN7B+vTM9TszKCBqD6BiME
         7srLEuYTfGokiZaSb15ZNncn64pqY02TCMFEBhi+ekB4bBcjWQj/pK5TkTnk1FULWB
         3FDrXymtsPEV+Am7ZW13cZMAuo1FG7DxrQr0qc3eOO6iK2iXxs9+XyUgTglMxuf1hb
         k/arGj2+u7xx/pTGdXMYa2mgmEnLtnSlxOK/6e0fpgTsIwgd5maUbigSPYEzGnaamD
         12kPVDHk+q+dg==
Subject: [PATCH 08/41] xfs: add realtime reverse map inode to superblock
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:57 -0800
Message-ID: <167243879703.732820.18008528042044400135.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
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
 libxfs/init.c             |    8 ++++++++
 libxfs/xfs_format.h       |    6 ++++--
 libxfs/xfs_inode_buf.c    |    6 ++++++
 libxfs/xfs_inode_fork.c   |    9 +++++++++
 libxfs/xfs_rtgroup.h      |    3 +++
 libxfs/xfs_rtrmap_btree.c |   33 +++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |    4 ++++
 7 files changed, 67 insertions(+), 2 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 4ce0aca9796..6f549996b1e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -1026,6 +1026,14 @@ libxfs_mount(
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
index fb727e1e407..babe5d3fabb 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index b5d4e5dd7ca..3aaa1988fb1 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -405,6 +405,12 @@ xfs_dinode_verify_fork(
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
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 58e5ab45e42..b441328cc9c 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -257,6 +257,11 @@ xfs_iformat_data_fork(
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
@@ -637,6 +642,10 @@ xfs_iflush_fork(
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
index 3c9572677f7..1792a9ab3bb 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -20,6 +20,9 @@ struct xfs_rtgroup {
 	/* for rcu-safe freeing */
 	struct rcu_head		rcu_head;
 
+	/* reverse mapping btree inode */
+	struct xfs_inode	*rtg_rmapip;
+
 	/* Number of blocks in this group */
 	xfs_rgblock_t		rtg_blockcount;
 
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 4dfd4fd1b1f..85608c813b4 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -24,6 +24,7 @@
 #include "xfs_cksum.h"
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
+#include "xfs_imeta.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -473,6 +474,7 @@ xfs_rtrmapbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_fork->if_format == XFS_DINODE_FMT_RMAP);
 
 	/*
 	 * Free any resources hanging off the real fork, then shallow-copy the
@@ -573,3 +575,34 @@ xfs_rtrmapbt_compute_maxlevels(
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
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 7380c04e770..26e2445f5d6 100644
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


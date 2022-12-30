Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8EBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbiLaC70 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiLaC7Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:59:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1564E1929B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:59:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF1D9B81E71
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E8BC433EF;
        Sat, 31 Dec 2022 02:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455561;
        bh=/lx3H61ktMs2wlqiT1c+4HnxWeTYjg9B9dpYdAf/YvA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lAlSMiuSHOYm2yFMiPN+u45z0vS9ePn2E6fnISR5ZqyndJWjyVelq6To/H5XKDyj8
         yJXQXEh05D3nXwxnpcqMWXGyQDpHeR40PHXUu0YMFKj8KhwGQdETukXGIyZxvZrNs8
         BVtSPMy6OQUG4loNuVkNmDcHkeA6prjH8++mCMJe7SachiV/CZ0u2S785zYKSkb9Kd
         +XEEVtJM8+j9A4W9o2yzvunVcgUTBc+Zxfut2AyuISqwMVaFnxf5cx15OmLPVrVBU1
         zUl8Wi2qzslabVmRhfltY5SWXT9YehZ8D9d6fNozwT4zXTDCIXM5OMpO1Z+k7tnkrw
         f3kUiWCccGt4A==
Subject: [PATCH 20/41] xfs: report realtime refcount btree corruption errors
 to the health system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:10 -0800
Message-ID: <167243881034.734096.4449054021704934789.stgit@magnolia>
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

Whenever we encounter corrupt realtime refcount btree blocks, we should
report that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h               |    1 +
 libxfs/xfs_health.h           |    4 +++-
 libxfs/xfs_inode_fork.c       |    4 +++-
 libxfs/xfs_rtrefcount_btree.c |    5 ++++-
 4 files changed, 11 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 8547ba85c55..5819576a51a 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -314,6 +314,7 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1 << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1 << 1)  /* rtbitmap for this group */
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1 << 2)  /* reverse mappings */
+#define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1 << 3)  /* reference counts */
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index d5976f6b0de..13128216754 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -68,6 +68,7 @@ struct xfs_rtgroup;
 #define XFS_SICK_RT_SUMMARY	(1 << 1)  /* realtime summary */
 #define XFS_SICK_RT_SUPER	(1 << 2)  /* rt group superblock */
 #define XFS_SICK_RT_RMAPBT	(1 << 3)  /* reverse mappings */
+#define XFS_SICK_RT_REFCNTBT	(1 << 4)  /* reference counts */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -106,7 +107,8 @@ struct xfs_rtgroup;
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY | \
 				 XFS_SICK_RT_SUPER | \
-				 XFS_SICK_RT_RMAPBT)
+				 XFS_SICK_RT_RMAPBT | \
+				 XFS_SICK_RT_REFCNTBT)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index b019cbeb5fd..4bdcfcda234 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -266,8 +266,10 @@ xfs_iformat_data_fork(
 			}
 			return xfs_iformat_rtrmap(ip, dip);
 		case XFS_DINODE_FMT_REFCOUNT:
-			if (!xfs_has_rtreflink(ip->i_mount))
+			if (!xfs_has_rtreflink(ip->i_mount)) {
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 				return -EFSCORRUPTED;
+			}
 			return xfs_iformat_rtrefcount(ip, dip);
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 5e9930d315c..537287c1696 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -25,6 +25,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_imeta.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
 
@@ -691,8 +692,10 @@ xfs_iformat_rtrefcount(
 	level = be16_to_cpu(dfp->bb_level);
 
 	if (level > mp->m_rtrefc_maxlevels ||
-	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize)
+	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	xfs_iroot_alloc(ip, XFS_DATA_FORK,
 			xfs_rtrefcount_broot_space_calc(mp, level, numrecs));


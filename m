Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE8DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbiLaCqK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLaCqJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:46:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0534625D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:46:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C1D761D1F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3485C433EF;
        Sat, 31 Dec 2022 02:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454767;
        bh=VIEnQ5AJR6Ftgec3yGYKb1k5I/atQePkvY7S6Bho34o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iv81uHBjmLxby9ODw3nebubjnmFbnrj4mg/t3ZMNeXbVEKEiZbHew8FR5qtWQ7HSN
         d44oq7HWu7Q+pC3s5WqvrIZbDc2ut7odaJXg8f5vo3wdDikrovmLNEE/A40S0vx0q8
         /tXI88VroZVo+XDlTLsROSHqpuJVBWzT2tHzYEiKdA7nEFyoVEvXxytSbpfjO4tIIt
         CNpf+rrcagrf3wht6la/ZCM6GB4/eLZ+mLECIYdMTPFJmm61jO1phpJiLypU4vdV/T
         eEgsR1F1rHNZ1AxyObR7y7xMYwc3yDzhy8Tlj0SthQzjyXN4p0+UyfcrmSzHbaJViJ
         05SPCZ7iEETIw==
Subject: [PATCH 14/41] xfs: report realtime rmap btree corruption errors to
 the health system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:57 -0800
Message-ID: <167243879782.732820.6518594918342608869.stgit@magnolia>
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

Whenever we encounter corrupt realtime rmap btree blocks, we should
report that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h           |    1 +
 libxfs/xfs_health.h       |    4 +++-
 libxfs/xfs_inode_fork.c   |    4 +++-
 libxfs/xfs_rtrmap_btree.c |    5 ++++-
 4 files changed, 11 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 7e9d7d7bb40..5c557d5ff13 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -313,6 +313,7 @@ struct xfs_rtgroup_geometry {
 };
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1 << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1 << 1)  /* rtbitmap for this group */
+#define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1 << 2)  /* reverse mappings */
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 44137c4983f..d5976f6b0de 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -67,6 +67,7 @@ struct xfs_rtgroup;
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
 #define XFS_SICK_RT_SUMMARY	(1 << 1)  /* realtime summary */
 #define XFS_SICK_RT_SUPER	(1 << 2)  /* rt group superblock */
+#define XFS_SICK_RT_RMAPBT	(1 << 3)  /* reverse mappings */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -104,7 +105,8 @@ struct xfs_rtgroup;
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY | \
-				 XFS_SICK_RT_SUPER)
+				 XFS_SICK_RT_SUPER | \
+				 XFS_SICK_RT_RMAPBT)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 386f23b2954..2b2a3fcab94 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -259,8 +259,10 @@ xfs_iformat_data_fork(
 		case XFS_DINODE_FMT_BTREE:
 			return xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 		case XFS_DINODE_FMT_RMAP:
-			if (!xfs_has_rtrmapbt(ip->i_mount))
+			if (!xfs_has_rtrmapbt(ip->i_mount)) {
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 				return -EFSCORRUPTED;
+			}
 			return xfs_iformat_rtrmap(ip, dip);
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 38f0b8567a6..b39ccba497a 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -25,6 +25,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
 #include "xfs_imeta.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -797,8 +798,10 @@ xfs_iformat_rtrmap(
 	level = be16_to_cpu(dfp->bb_level);
 
 	if (level > mp->m_rtrmap_maxlevels ||
-	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize)
+	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	xfs_iroot_alloc(ip, XFS_DATA_FORK,
 			xfs_rtrmap_broot_space_calc(mp, level, numrecs));


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5437C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbiLaBnJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbiLaBnI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:43:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8285C13F7A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:43:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2141961C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8A9C433D2;
        Sat, 31 Dec 2022 01:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450986;
        bh=I2HMR3AKOFHmhJbfSOWeo8c8fkkCe1q0lPlfDNrSPvc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VQiaZ7ZAHnNjjkrdiOnOiON2fOmZ3UEC/Tgas0TrhVx32nHeJPJroZnUSPtvnWZXk
         +1lFE7oHlvoPvdv0ee9Jd9+FLawfSgGSXAb8f/vP0qRAb+9MckQ/CyKQOY4U9Kh1x9
         46UXS11pqW6+Sq3W0V5SxTeGp2havETVKYv2HpSRe7DbdD4ZtrToJT2EXf65n4ZUdz
         tv6Ad0IIb4Q+tP9Hd1ifxhN5OdSB/wHFMHggSLKNAzVGP6LrKhGIWDyVTqWkDrN3fR
         rg9D5xhO2S1VZCq5dx3meqBZBU6U21RiAJp+Q+s2q6HULUYvvMU1Eo5i6C4ue6T1vJ
         VraHc61pW5+Aw==
Subject: [PATCH 24/38] xfs: report realtime rmap btree corruption errors to
 the health system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:19 -0800
Message-ID: <167243869942.715303.8274942737380162651.stgit@magnolia>
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

Whenever we encounter corrupt realtime rmap btree blocks, we should
report that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h           |    1 +
 fs/xfs/libxfs/xfs_health.h       |    4 +++-
 fs/xfs/libxfs/xfs_inode_fork.c   |    4 +++-
 fs/xfs/libxfs/xfs_rtrmap_btree.c |    5 ++++-
 fs/xfs/xfs_health.c              |    4 ++++
 fs/xfs/xfs_rtalloc.c             |    1 +
 6 files changed, 16 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 7e9d7d7bb40b..5c557d5ff13e 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -313,6 +313,7 @@ struct xfs_rtgroup_geometry {
 };
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1 << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1 << 1)  /* rtbitmap for this group */
+#define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1 << 2)  /* reverse mappings */
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 44137c4983fc..d5976f6b0de1 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 94979bed8f32..61926c07aad3 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -261,8 +261,10 @@ xfs_iformat_data_fork(
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
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 9181fca2ba54..2d8130b4c187 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -28,6 +28,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
 #include "xfs_imeta.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -800,8 +801,10 @@ xfs_iformat_rtrmap(
 	level = be16_to_cpu(dfp->bb_level);
 
 	if (level > mp->m_rtrmap_maxlevels ||
-	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize)
+	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	xfs_iroot_alloc(ip, XFS_DATA_FORK,
 			xfs_rtrmap_broot_space_calc(mp, level, numrecs));
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 33f332ee8044..80cc735b52d1 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -531,6 +531,7 @@ xfs_ag_geom_health(
 static const struct ioctl_sick_map rtgroup_map[] = {
 	{ XFS_SICK_RT_SUPER,	XFS_RTGROUP_GEOM_SICK_SUPER },
 	{ XFS_SICK_RT_BITMAP,	XFS_RTGROUP_GEOM_SICK_BITMAP },
+	{ XFS_SICK_RT_RMAPBT,	XFS_RTGROUP_GEOM_SICK_RMAPBT },
 	{ 0, 0 },
 };
 
@@ -630,6 +631,9 @@ xfs_btree_mark_sick(
 	case XFS_BTNUM_BMAP:
 		xfs_bmap_mark_sick(cur->bc_ino.ip, cur->bc_ino.whichfork);
 		return;
+	case XFS_BTNUM_RTRMAP:
+		xfs_rtgroup_mark_sick(cur->bc_ino.rtg, XFS_SICK_RT_RMAPBT);
+		return;
 	case XFS_BTNUM_BNO:
 		mask = XFS_SICK_AG_BNOBT;
 		break;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 45c388ad4c1f..0f31680284fb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1806,6 +1806,7 @@ xfs_rtmount_rmapbt(
 		goto out_path;
 
 	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_RMAP)) {
+		xfs_rtgroup_mark_sick(rtg, XFS_SICK_RT_RMAPBT);
 		error = -EFSCORRUPTED;
 		goto out_rele;
 	}


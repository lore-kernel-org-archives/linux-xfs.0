Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96EABC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbiLaBzW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbiLaBzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:55:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0D11DDDA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:55:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B7F4B81E08
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018A6C433EF;
        Sat, 31 Dec 2022 01:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451718;
        bh=6SLftXjIPDFS8ycIrKppO90HNSzeEZmUUAqiqJ8kaHQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Fl47TkN4bPJdO4w0NzP3vXsMDhZeFEdEBsUzpQYjtSDdkCdxdjoOKnqJxig3LhmX9
         qTAZ+ndyLtjbZk7V1okTGF5LAkBvRjT1zKWHDh9o951IT3wQhOU4dDLwuE5N8PKJcm
         s++OOwXUj4vkjqY2wPdDQlcbXT9eYuws55lzEu27EYZnWKCF4ayFARLytbWV0TVrU2
         OzWGR5QoDv7MVBAag96N1VsANnCx51uDUfrpy0saS1ew7J+34LmCr/bYukaApgs/mu
         TzWmx+eXi7hPVT0mKhgtoKK7j94dgnqqJtG3/j2EWAXmXuo9eWDMbiYgPCHDYbkW6O
         yvx8UMyV/vDmw==
Subject: [PATCH 28/42] xfs: report realtime refcount btree corruption errors
 to the health system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:32 -0800
Message-ID: <167243871294.717073.3857302599711174842.stgit@magnolia>
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

Whenever we encounter corrupt realtime refcount btree blocks, we should
report that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h               |    1 +
 fs/xfs/libxfs/xfs_health.h           |    4 +++-
 fs/xfs/libxfs/xfs_inode_fork.c       |    4 +++-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    5 ++++-
 fs/xfs/xfs_health.c                  |    4 ++++
 fs/xfs/xfs_rtalloc.c                 |    1 +
 6 files changed, 16 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 8547ba85c550..5819576a51a1 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -314,6 +314,7 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1 << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1 << 1)  /* rtbitmap for this group */
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1 << 2)  /* reverse mappings */
+#define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1 << 3)  /* reference counts */
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index d5976f6b0de1..131282167548 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7aae3ae810b7..5d5134a61994 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -268,8 +268,10 @@ xfs_iformat_data_fork(
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
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 0a6fa9851371..4bbda3ff0b39 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -27,6 +27,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_imeta.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
 
@@ -693,8 +694,10 @@ xfs_iformat_rtrefcount(
 	level = be16_to_cpu(dfp->bb_level);
 
 	if (level > mp->m_rtrefc_maxlevels ||
-	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize)
+	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	xfs_iroot_alloc(ip, XFS_DATA_FORK,
 			xfs_rtrefcount_broot_space_calc(mp, level, numrecs));
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 80cc735b52d1..3a6684acd858 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -532,6 +532,7 @@ static const struct ioctl_sick_map rtgroup_map[] = {
 	{ XFS_SICK_RT_SUPER,	XFS_RTGROUP_GEOM_SICK_SUPER },
 	{ XFS_SICK_RT_BITMAP,	XFS_RTGROUP_GEOM_SICK_BITMAP },
 	{ XFS_SICK_RT_RMAPBT,	XFS_RTGROUP_GEOM_SICK_RMAPBT },
+	{ XFS_SICK_RT_REFCNTBT,	XFS_RTGROUP_GEOM_SICK_REFCNTBT },
 	{ 0, 0 },
 };
 
@@ -634,6 +635,9 @@ xfs_btree_mark_sick(
 	case XFS_BTNUM_RTRMAP:
 		xfs_rtgroup_mark_sick(cur->bc_ino.rtg, XFS_SICK_RT_RMAPBT);
 		return;
+	case XFS_BTNUM_RTREFC:
+		xfs_rtgroup_mark_sick(cur->bc_ino.rtg, XFS_SICK_RT_REFCNTBT);
+		return;
 	case XFS_BTNUM_BNO:
 		mask = XFS_SICK_AG_BNOBT;
 		break;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8929c4fffb53..75d39c3274df 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1968,6 +1968,7 @@ xfs_rtmount_refcountbt(
 		goto out_path;
 
 	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_REFCOUNT)) {
+		xfs_rtgroup_mark_sick(rtg, XFS_SICK_RT_REFCNTBT);
 		error = -EFSCORRUPTED;
 		goto out_rele;
 	}


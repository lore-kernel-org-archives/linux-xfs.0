Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE5CC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbiLaBIu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236008AbiLaBIs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:08:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E1F15F3F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:08:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 116E761D3D
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D90DC433F1;
        Sat, 31 Dec 2022 01:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448926;
        bh=4TZXYGpMLLTXMOdSQHjP+ekx99tNVyAIdgI6smfMv2w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iydwyFlFmqgNnKYb23BncNJPYGjzqXMEJ+IkaGEVXWfxbUNEWe6sRUwLw46A1Toz+
         nnhol6zoagpqbJDUmxNWn0SHv2HoAJx4wlmyDrOIrbxu5CmZpZ/EEv9ySD/rzZT4NL
         xwP0TBuHyrqui1m5nR+VgZBEVFyU+eyGv5NfeqsQQI3GNwu2vPkGV/CplpwXV+6vlV
         qwmDex5QYeW3ZR3Ew3DerkpMvu1ebJO1U6bz1z/ViIy8LiCzlaw4MwblE3/d5kA9Pn
         7F6BjT0Mfr7pfGhDKRvgR3NvZYHAzVCchuWOFWdbE5Cr6Vt7NVJsze5a0Q6ujfEp3H
         AYjTpmpFEHm6A==
Subject: [PATCH 14/20] xfs: create libxfs helper to link a new inode into a
 directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:20 -0800
Message-ID: <167243864030.707335.4591241191547646047.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new libxfs function to link a newly created inode into a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    4 ++++
 fs/xfs/xfs_inode.c       |   17 ++---------------
 3 files changed, 50 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index fb0697dc733f..bca493a2da8d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -19,6 +19,8 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_health.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -781,3 +783,45 @@ xfs_dir2_compname(
 		return xfs_ascii_ci_compname(args, name, len);
 	return xfs_da_compname(args, name, len);
 }
+
+/*
+ * Given a directory @dp, a newly allocated inode @ip, and a @name, link @ip
+ * into @dp under the given @name.  If @ip is a directory, it will be
+ * initialized.  Both inodes must have the ILOCK held and the transaction must
+ * have sufficient blocks reserved.
+ */
+int
+xfs_dir_create_new_child(
+	struct xfs_trans		*tp,
+	uint				resblks,
+	struct xfs_inode		*dp,
+	struct xfs_name			*name,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	int				error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_EXCL));
+	ASSERT(resblks == 0 || resblks > XFS_IALLOC_SPACE_RES(mp));
+
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
+					resblks - XFS_IALLOC_SPACE_RES(mp));
+	if (error) {
+		ASSERT(error != -ENOSPC);
+		return error;
+	}
+
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	if (!S_ISDIR(VFS_I(ip)->i_mode))
+		return 0;
+
+	error = xfs_dir_init(tp, ip, dp);
+	if (error)
+		return error;
+
+	xfs_bumplink(tp, dp);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 7322284f61a0..d3e7607c0e9d 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -253,4 +253,8 @@ unsigned int xfs_dir3_data_end_offset(struct xfs_da_geometry *geo,
 		struct xfs_dir2_data_hdr *hdr);
 bool xfs_dir2_namecheck(const void *name, size_t length);
 
+int xfs_dir_create_new_child(struct xfs_trans *tp, uint resblks,
+		struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
+
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f9599aa49ab4..b66a9cf66055 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -868,22 +868,9 @@ xfs_create(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = false;
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
-	if (error) {
-		ASSERT(error != -ENOSPC);
+	error = xfs_dir_create_new_child(tp, resblks, dp, name, ip);
+	if (error)
 		goto out_trans_cancel;
-	}
-	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
-
-	if (is_dir) {
-		error = xfs_dir_init(tp, ip, dp);
-		if (error)
-			goto out_trans_cancel;
-
-		xfs_bumplink(tp, dp);
-	}
 
 	/*
 	 * Create ip with a reference from dp, and add '.' and '..' references


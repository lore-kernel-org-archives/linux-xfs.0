Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29C5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbiLaCD4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbiLaCDy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:03:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B217F2AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:03:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7022DB81C23
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1BAC433EF;
        Sat, 31 Dec 2022 02:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452231;
        bh=9hgBuR3PxBP47oOnbGAHCQkoj0gVExbDqco8knX96hY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XZ1fi0jOYO4BLPmkAuTEJii/if71EgCbriujn6c3pxm93qAHnM6ZE5wKloLQGl8RO
         x8PvLpvrR2gq4BKH6nnZ/9cPpPa/Uc68mZKwCet7w0UlaIfFZhBDsNFuIjTwkoGyQ1
         mShob4Plx22L+dBzoG6TabE2NyFu3YHIqYgZuJYxPKibW4pjiD+F3+/Ih/2jO3xTF1
         UwhH0xRhLmVIj09S3zkmATg9dL2apESkL2A4DIEaqim1CNU1xGKLRtBrT/FwIYBvr9
         +gLMlXzFv1LtAQoW4KQhtJJeSmqhW8NItjqsg3NJfHOGhyY1RIFv0o9aY9KkK81Ggm
         7WZuHDtE2YRQg==
Subject: [PATCH 03/26] xfs: hoist project id get/set functions to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:13 -0800
Message-ID: <167243875362.723621.17855762543390893319.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the project id get and set functions into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 ++
 libxfs/xfs_inode_util.c  |   11 +++++++++++
 libxfs/xfs_inode_util.h  |    2 ++
 3 files changed, 15 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index d871963966c..01ad6e54624 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -135,6 +135,7 @@
 #define xfs_free_extent			libxfs_free_extent
 #define xfs_free_perag			libxfs_free_perag
 #define xfs_fs_geometry			libxfs_fs_geometry
+#define xfs_get_projid			libxfs_get_projid
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
@@ -207,6 +208,7 @@
 #define xfs_sb_read_secondary		libxfs_sb_read_secondary
 #define xfs_sb_to_disk			libxfs_sb_to_disk
 #define xfs_sb_version_to_features	libxfs_sb_version_to_features
+#define xfs_set_projid			libxfs_set_projid
 #define xfs_symlink_blocks		libxfs_symlink_blocks
 #define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
 #define xfs_symlink_write_target	libxfs_symlink_write_target
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 868a77cafa6..89fb58807a1 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -122,3 +122,14 @@ xfs_ip2xflags(
 		flags |= FS_XFLAG_HASATTR;
 	return flags;
 }
+
+#define XFS_PROJID_DEFAULT	0
+
+prid_t
+xfs_get_initial_prid(struct xfs_inode *dp)
+{
+	if (dp->i_diflags & XFS_DIFLAG_PROJINHERIT)
+		return dp->i_projid;
+
+	return XFS_PROJID_DEFAULT;
+}
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index 6ad1898a0f7..f7e4d5a8235 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -11,4 +11,6 @@ uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(struct xfs_inode *ip);
 uint32_t	xfs_ip2xflags(struct xfs_inode *ip);
 
+prid_t		xfs_get_initial_prid(struct xfs_inode *dp);
+
 #endif /* __XFS_INODE_UTIL_H__ */


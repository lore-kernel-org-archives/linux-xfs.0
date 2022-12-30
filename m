Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ADBCC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbiLaCMo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:12:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEE91C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:12:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2A0EB81E49
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C82C433D2;
        Sat, 31 Dec 2022 02:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452760;
        bh=uS4BZk38QizGOB/TLw9q2F3qBahpKRCpaE+4gfih7HQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oUavLRWjc2tja+Ne4hSH+tSkR4hqwRssoBN595VvsfQ/MWPaQYXfqxlDx/cdfRZAn
         qpgheUQMb8leCBUpFhv3hnOUoSKev+tioP2U8EZZrYFilbpPgoKDkhWLigy5cTfPQQ
         yboLh8J6iAABe0kucYg4WzmHs8pRXe03pZIyGIFUpxmo/ahDzKdA38B4P9XkIyXuLk
         +Rkc8+HzefU+toDnR67YWSDbgI8aAZglqQiLUiUFTX3v5roCzhTqOv8n8vvz7idlhv
         m2eIAvbaCyNDQ9H6bWbl0ApM0ApF5Yv1XeIcY98pokiSdcTYPyk3y3Sq9+Kgh24mXv
         XiVwnOPXk+aRQ==
Subject: [PATCH 11/46] xfs: enforce metadata inode flag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:20 -0800
Message-ID: <167243876081.725900.15231592838271764438.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add checks for the metadata inode flag so that we don't ever leak
metadata inodes out to userspace, and we don't ever try to read a
regular inode as metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c         |    7 ++++-
 libxfs/xfs_inode_buf.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_buf.h |    3 ++
 3 files changed, 82 insertions(+), 1 deletion(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 95a1ba50cdf..db42529e07e 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -231,7 +231,9 @@ libxfs_imeta_iget(
 	if (error)
 		return error;
 
-	if (ftype == XFS_DIR3_FT_UNKNOWN ||
+	if ((xfs_has_metadir(mp) &&
+	     !xfs_is_metadata_inode(ip)) ||
+	    ftype == XFS_DIR3_FT_UNKNOWN ||
 	    xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype) {
 		libxfs_irele(ip);
 		return -EFSCORRUPTED;
@@ -278,6 +280,9 @@ void
 libxfs_imeta_irele(
 	struct xfs_inode	*ip)
 {
+	ASSERT(!xfs_has_metadir(ip->i_mount) ||
+	       xfs_is_metadata_inode(ip));
+
 	libxfs_irele(ip);
 }
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 82eb3f91b9d..b5d4e5dd7ca 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -454,6 +454,73 @@ xfs_dinode_verify_nrext64(
 	return NULL;
 }
 
+/*
+ * Validate all the picky requirements we have for a file that claims to be
+ * filesystem metadata.
+ */
+xfs_failaddr_t
+xfs_dinode_verify_metaflag(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip,
+	uint16_t		mode,
+	uint16_t		flags,
+	uint64_t		flags2)
+{
+	if (!xfs_has_metadir(mp))
+		return __this_address;
+
+	/* V5 filesystem only */
+	if (dip->di_version < 3)
+		return __this_address;
+
+	/* V3 inode fields that are always zero */
+	if (dip->di_onlink)
+		return __this_address;
+	if ((flags2 & XFS_DIFLAG2_NREXT64) && dip->di_nrext64_pad)
+		return __this_address;
+	if (!(flags2 & XFS_DIFLAG2_NREXT64) && dip->di_flushiter)
+		return __this_address;
+
+	/* Metadata files can only be directories or regular files */
+	if (!S_ISDIR(mode) && !S_ISREG(mode))
+		return __this_address;
+
+	/* They must have zero access permissions */
+	if (mode & 0777)
+		return __this_address;
+
+	/* DMAPI event and state masks are zero */
+	if (dip->di_dmevmask || dip->di_dmstate)
+		return __this_address;
+
+	/* User, group, and project IDs must be zero */
+	if (dip->di_uid || dip->di_gid ||
+	    dip->di_projid_lo || dip->di_projid_hi)
+		return __this_address;
+
+	/* Immutable, sync, noatime, nodump, and nodefrag flags must be set */
+	if (!(flags & XFS_DIFLAG_IMMUTABLE))
+		return __this_address;
+	if (!(flags & XFS_DIFLAG_SYNC))
+		return __this_address;
+	if (!(flags & XFS_DIFLAG_NOATIME))
+		return __this_address;
+	if (!(flags & XFS_DIFLAG_NODUMP))
+		return __this_address;
+	if (!(flags & XFS_DIFLAG_NODEFRAG))
+		return __this_address;
+
+	/* Directories must have nosymlinks flags set */
+	if (S_ISDIR(mode) && !(flags & XFS_DIFLAG_NOSYMLINKS))
+		return __this_address;
+
+	/* dax flags2 must not be set */
+	if (flags2 & XFS_DIFLAG2_DAX)
+		return __this_address;
+
+	return NULL;
+}
+
 xfs_failaddr_t
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
@@ -607,6 +674,12 @@ xfs_dinode_verify(
 	    !xfs_has_bigtime(mp))
 		return __this_address;
 
+	if (flags2 & XFS_DIFLAG2_METADATA) {
+		fa = xfs_dinode_verify_metaflag(mp, dip, mode, flags, flags2);
+		if (fa)
+			return fa;
+	}
+
 	return NULL;
 }
 
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 585ed5a110a..94d6e7c018e 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -28,6 +28,9 @@ int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 
 xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
 			   struct xfs_dinode *dip);
+xfs_failaddr_t xfs_dinode_verify_metaflag(struct xfs_mount *mp,
+		struct xfs_dinode *dip, uint16_t mode, uint16_t flags,
+		uint64_t flags2);
 xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
 		uint32_t extsize, uint16_t mode, uint16_t flags);
 xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,


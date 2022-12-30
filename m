Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E2D8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbiLaCLZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCLY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:11:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E6E1C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:11:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4885D61D07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3484C433EF;
        Sat, 31 Dec 2022 02:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452682;
        bh=xMoMo0bi2s+suv9ccTFqgA/x8JAQB6sNtesw3kjhT8A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k4XZz/nvfSCFB+1scTfIXiYJSoiouiRYhP9Y4bnz8Y3IJu94AJG0OKLXJyvyakl1g
         Xc7fW1J7Bc4pQHSABSzQYFWQvUjtfDz4jNQZ3YGuSiWzciEwem7tQvd022yyBbkiSt
         wyBadu/oTwPbkIOZiJQAth+6FcDRe8IZ1KNWIAn/YZ60gqS9qGtaYYezNtUm5xFenS
         1jPxOmZqXWOtSBHRdTO6W9aXtJTzuBH7vRvqFyn0kweFzdpQx2b38b9m2AqYzD9C5z
         131fppSw3HC6+QjO8iS/ynTXuPV8dulrlyI4ld5+OptTqz4/LsEpmoeLGG04BBmCaq
         uAf0GS6awRH1g==
Subject: [PATCH 06/46] libxfs: iget for metadata inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:20 -0800
Message-ID: <167243876020.725900.11842457884493442774.stgit@magnolia>
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

Create a libxfs_iget_meta function for metadata inodes to ensure that we
always check that the inobt thinks a metadata inode is in use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c            |    4 ++--
 libxfs/inode.c           |   32 ++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    2 ++
 libxfs/xfs_imeta.h       |    5 +++++
 4 files changed, 41 insertions(+), 2 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index e19b4e6d4cf..d114ac87f19 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -983,9 +983,9 @@ void
 libxfs_rtmount_destroy(xfs_mount_t *mp)
 {
 	if (mp->m_rsumip)
-		libxfs_irele(mp->m_rsumip);
+		libxfs_imeta_irele(mp->m_rsumip);
 	if (mp->m_rbmip)
-		libxfs_irele(mp->m_rbmip);
+		libxfs_imeta_irele(mp->m_rbmip);
 	mp->m_rsumip = mp->m_rbmip = NULL;
 }
 
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 1a27016a763..95a1ba50cdf 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -216,6 +216,31 @@ libxfs_iget(
 	return error;
 }
 
+/* Get a metadata inode.  The ftype must match exactly. */
+int
+libxfs_imeta_iget(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	unsigned char		ftype,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_inode	*ip;
+	int			error;
+
+	error = libxfs_iget(mp, NULL, ino, 0, &ip);
+	if (error)
+		return error;
+
+	if (ftype == XFS_DIR3_FT_UNKNOWN ||
+	    xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype) {
+		libxfs_irele(ip);
+		return -EFSCORRUPTED;
+	}
+
+	*ipp = ip;
+	return 0;
+}
+
 static void
 libxfs_idestroy(
 	struct xfs_inode	*ip)
@@ -249,6 +274,13 @@ libxfs_irele(
 	}
 }
 
+void
+libxfs_imeta_irele(
+	struct xfs_inode	*ip)
+{
+	libxfs_irele(ip);
+}
+
 void
 xfs_inode_sgid_inherit(
 	const struct xfs_icreate_args	*args,
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 69f1cf2c752..c27949e5f48 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -159,6 +159,8 @@
 #define xfs_imeta_create		libxfs_imeta_create
 #define xfs_imeta_create_space_res	libxfs_imeta_create_space_res
 #define xfs_imeta_end_update		libxfs_imeta_end_update
+#define xfs_imeta_iget			libxfs_imeta_iget
+#define xfs_imeta_irele			libxfs_imeta_irele
 #define xfs_imeta_link			libxfs_imeta_link
 #define xfs_imeta_lookup		libxfs_imeta_lookup
 #define xfs_imeta_mount			libxfs_imeta_mount
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
index 9d54cb0d796..312e3a6fdb9 100644
--- a/libxfs/xfs_imeta.h
+++ b/libxfs/xfs_imeta.h
@@ -48,4 +48,9 @@ int xfs_imeta_mount(struct xfs_mount *mp);
 unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
 unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
 
+/* Must be implemented by the libxfs client */
+int xfs_imeta_iget(struct xfs_mount *mp, xfs_ino_t ino, unsigned char ftype,
+		struct xfs_inode **ipp);
+void xfs_imeta_irele(struct xfs_inode *ip);
+
 #endif /* __XFS_IMETA_H__ */

